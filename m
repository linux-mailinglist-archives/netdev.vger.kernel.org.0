Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5B662D6C5
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiKQJ2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiKQJ2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:28:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37F9CF4
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D759B81D97
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D10EC433D6;
        Thu, 17 Nov 2022 09:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668677289;
        bh=Oex1I4PJC33uMiV0mNtJNYONNRm/L2AyQ8IgLlbY8cc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tl1vMeITZNyPKTp99sn0HF9atzlO/RoeiCZRFbM4GR0dlx9/9vAPxD4fkJdqpKJC+
         KYvPGd0vdPwBq97tnybf75m2PhGXA8qAEH6FBfe1RgbLmC2msFoxuGiFlsSLL2HOC1
         w0vt18XmuovJVawukxGNGV4K/M+i7vrxHlqYwvSf06/20zp9WZeZ7lVHxbujh4Ux1+
         Z1i2znkmxI2PH9fNej/vaTpuKFGa8AdMpllMeFCr6ycaE5KE7lG/2zjepdwrKmiqe5
         DCuRAHPByGROdyHh6LgjXisV+IgK9Xxe830Pp9YO/dtxZ3egohEE19i9YRQeX9XyLI
         5wPLEWELUZcpA==
Date:   Thu, 17 Nov 2022 11:28:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jeffrey.t.kirsher@intel.com,
        shannon.nelson@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] i40e: Fix error handling in i40e_init_module()
Message-ID: <Y3X+pfOrzs8ixfN8@unreal>
References: <20221116012725.13707-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116012725.13707-1-shangxiaojing@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 09:27:25AM +0800, Shang XiaoJing wrote:
> i40e_init_module() won't free the debugfs directory created by
> i40e_dbg_init() when pci_register_driver() failed. Add fail path to
> call i40e_dbg_exit() to remove the debugfs entries to prevent the bug.
> 
> i40e: Intel(R) Ethernet Connection XL710 Network Driver
> i40e: Copyright (c) 2013 - 2019 Intel Corporation.
> debugfs: Directory 'i40e' with parent '/' already present!
> 
> Fixes: 41c445ff0f48 ("i40e: main driver core")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
> changes in v2:
> - destroy the workqueue in fail path too.
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 

The subject line should indicate the target branch and needs
to be [PATCH net v2] ....

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
