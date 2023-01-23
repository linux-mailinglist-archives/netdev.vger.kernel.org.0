Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB24678397
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjAWRt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjAWRt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:49:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF1A7ED7;
        Mon, 23 Jan 2023 09:49:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 585F760F2F;
        Mon, 23 Jan 2023 17:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35990C433D2;
        Mon, 23 Jan 2023 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674496165;
        bh=p57XG+etvdiOWCPI57K6WXYfqGLKqyyqsXc5nssX9Ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fhkFSIcaAeKb4biePn0z8kyzBe1VP/s3k+NRHtXpHCe23ktLLjLNHRBX4pOO3IZmm
         XPtgBJW5YhmvjIjyKjazSBPMOw6aY0FbKoH7wrV+0A5jz/Zm9wzHhkvNlbMizBz71i
         +YyAvrpA/Wllvt7GnLOHbLJvR768JxUFVDFdDFy7oExGBf8IvyZNfAqld19ShoucB+
         Nt2uPUKPfVIj7PrERUMDeIwBI9OgVxvkFHrtyXXfAlLh8Q2ei2PfE3WvgEvuvqY93i
         AXb0UqVg+tMazYb8ZR2nnw+VrhkS/ouAcsTNYGkLhfjB4xkI6QAK5bT/NiUfdVjy8z
         xrj0mNwLN+KGA==
Date:   Mon, 23 Jan 2023 19:44:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "fw@strlen.de" <fw@strlen.de>, "joe@perches.com" <joe@perches.com>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: conntrack: remote a return value of the
 'seq_print_acct' function.
Message-ID: <Y87Hmv5qSZcD3rRZ@unreal>
References: <Y86Lji5prQEAxKLi@unreal>
 <20230123143202.1785569-1-Ilia.Gavrilov@infotecs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123143202.1785569-1-Ilia.Gavrilov@infotecs.ru>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 02:31:54PM +0000, Gavrilov Ilia wrote:
> The static 'seq_print_acct' function always returns 0.
> 
> Change the return value to 'void' and remove unnecessary checks.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 1ca9e41770cb ("netfilter: Remove uses of seq_<foo> return values")
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> ---
> V2: Fix coding style
>  net/netfilter/nf_conntrack_standalone.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
