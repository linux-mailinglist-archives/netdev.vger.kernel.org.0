Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A574620837
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 05:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbiKHE0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 23:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiKHE03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 23:26:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBCA28732
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 20:26:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BFC5B818BE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7459EC433C1;
        Tue,  8 Nov 2022 04:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667881585;
        bh=+aM60K+CQIEwKuHbi+757OCfu9Vnd3S1cRH4ER8JRQo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BXR7aVahfk+bdK+iKLsib6xmU1eW6gaX2yQ1ngEE8CzhRtWFLi9tnRYN0eXCJQ3pl
         bJOg+rTLc1H5pf6i8n98JuFZMmL1ejfWugjSGnA2JcRLTD6dHkXqhJOY4uXdLuZks7
         rPbmUWjK+MpcjjObpuECqcoRi3SmfNJVIYnp9sKabranK3fG//jnWMFSChdXChRu+j
         7MQoT6OKWIC2t5Y1Wfxz9EI28d+FyodDLfZSqsnbAM33BN/gdKLB4HtCAMuzlCUNct
         gGoW7Lpzjancje84jgUFxv539VsJLy2UhGwGTWLOePRYeiJYkSuJ2OPRtqtpwWxkRx
         zsaKq0vlsSorA==
Date:   Mon, 7 Nov 2022 20:26:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] mctp: Fix an error handling path in mctp_init()
Message-ID: <20221107202624.5c6afcdd@kernel.org>
In-Reply-To: <20221107152756.180628-1-weiyongjun@huaweicloud.com>
References: <20221107152756.180628-1-weiyongjun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Nov 2022 15:27:56 +0000 Wei Yongjun wrote:
> +	mctp_routes_exit();

This function is marked as __exit, build complains:

WARNING: modpost: vmlinux.o: section mismatch in reference: mctp_init (section: .init.text) -> mctp_routes_exit (section: .exit.text)
