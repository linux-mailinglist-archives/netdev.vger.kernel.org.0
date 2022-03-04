Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4EA4CD9D9
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240848AbiCDRNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbiCDRNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:13:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7D555BCA;
        Fri,  4 Mar 2022 09:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FC4261E22;
        Fri,  4 Mar 2022 17:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF899C340E9;
        Fri,  4 Mar 2022 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646413968;
        bh=aRF+Bbp/7rjpaukzjU8FA2iu+wANo3UVwDPmYsnSprg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e4PR8iAeADDukcbM4Ln+Cm4myvENPGNhHw+/Qy1J3uaApQizwykKKUa5X6M8zplsI
         QkQ099tmauhp/58c+6T7bkjpVPv3M6aLHcfLPdQjAdakncFE812zxdrWNbrJwRYYGN
         dObacEdJFucH98n0kzi6UYOmJBzsGpPT8DJ9kOJjiV5Zj7qGqjVp5bUhYoqXMfDjEy
         CRtWJ9Ky8a2RHxrTKTlVIiKCbY9mucQHmF/DVC3iTl1hhipNhzlI8Tt7LdKr1Hl1Wp
         0Ilns+g6BIObKCIeT/v7Hg1VRAKBvl1RsywEsXOWeXDEnsTo+kdAhpbQXegFnDJ8TP
         Ej8y4A6WXKa9Q==
Date:   Fri, 4 Mar 2022 19:12:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org, Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] Revert "net/smc: don't req_notify until all
 CQEs drained"
Message-ID: <YiJIjNu/OO1o11Vc@unreal>
References: <20220304091719.48340-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304091719.48340-1-dust.li@linux.alibaba.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 05:17:19PM +0800, Dust Li wrote:
> This reverts commit a505cce6f7cfaf2aa2385aab7286063c96444526.
> 
> Leon says:
>   We already discussed that. SMC should be changed to use
>   RDMA CQ pool API
>   drivers/infiniband/core/cq.c.
>   ib_poll_handler() has much better implementation (tracing,
>   IRQ rescheduling, proper error handling) than this SMC variant.
> 
> Since we will switch to ib_poll_handler() in the future,
> revert this patch.
> 
> Link: https://lore.kernel.org/netdev/20220301105332.GA9417@linux.alibaba.com/
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Suggested-by: Karsten Graul <kgraul@linux.ibm.com>
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/smc/smc_wr.c | 49 +++++++++++++++++++++---------------------------
>  1 file changed, 21 insertions(+), 28 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
