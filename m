Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1706962A350
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 21:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbiKOUs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 15:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbiKOUs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 15:48:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E05D2B624
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 12:48:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ABDDB81B62
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 20:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9975C433D6;
        Tue, 15 Nov 2022 20:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668545299;
        bh=ILRVsCQiGvGye1pKEuAHJ09D34XQZY9BESvUzl5PMLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QOpAQZmyW9JzxFaL0e1HbN02QSQiXT/JYKoy9CItkjUlxUAO+T0tvAunQltKi1NXu
         PQDyjxHaXmdiCDvKWf2jP7469OAPs8jAZ29aTnWOp8SC5ME4mxz6JCDi2Y1NsBm0C8
         yEuHUJmXshu7qDaImpQq/yaU7qaiQEE5gYloYCJtGnp4Lni9Ug36v7lJBacaIMst8z
         bXaDuLmL5q6lKlJZpdeBTbtD359IfEotxpir3bdTMhVtEnebdPEhFO6vS6HosCHhyi
         +KzRp9ofUZc6LGbZ9B0eUk/rmoTj4Gj1xkiHjduTbCzCefUtm3m9RpmqOEq7MrLEJk
         gWtBlT+OQ8fDA==
Date:   Tue, 15 Nov 2022 12:48:15 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jeffrey.t.kirsher@intel.com,
        mark.d.rustad@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ixgbevf: Fix resource leak in ixgbevf_init_module()
Message-ID: <Y3P7Dzw4OWDxb33S@x130.lan>
References: <20221114025758.9427-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221114025758.9427-1-shangxiaojing@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 10:57, Shang XiaoJing wrote:
>ixgbevf_init_module() won't destroy the workqueue created by
>create_singlethread_workqueue() when pci_register_driver() failed. Add
>destroy_workqueue() in fail path to prevent the resource leak.
>
>Similar to the handling of u132_hcd_init in commit f276e002793c
>("usb: u132-hcd: fix resource leak")
>
>Fixes: 40a13e2493c9 ("ixgbevf: Use a private workqueue to avoid certain possible hangs")
>Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
