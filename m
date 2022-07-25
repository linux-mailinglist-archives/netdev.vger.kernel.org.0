Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900C857FED7
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbiGYMQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiGYMQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:16:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B132BF41;
        Mon, 25 Jul 2022 05:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QxOTMLEK7NykqypuWPrzoA6WBS9tC4bfnwDUZxkPiFk=; b=HlYf3uNjOyGcQCyPoeDaoWsISe
        slYvNYi6yfo1wREK2pgxaXYiM95GvQR+qpxqELAyFuYhDBxJkPh6Zli4o8mjoZl/WDTx4r7VQ+WNF
        yO2oTNqBJHKTIW7D+RJhsMU74rPxJLXWnvgVv5PQlKQV8vJcNvs1okr1UvGX4pCvxvE4PjWQTVJpa
        OQYncVsIc7ebVsBr50sN1LmUD28d0ZTE/Ck22gBawO4yFpddJPMfkzuNc/R0sIGJ7w+J6ybypebcn
        x54uh7DdAoplhLLvSKPTwFi3RNDBIRV3UFkzFWB+SL/0skbgJNENvO9NRNTlbDsiTQHkW4K4twCCs
        XQ9LkTng==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oFx01-00160W-EX; Mon, 25 Jul 2022 12:15:49 +0000
Date:   Mon, 25 Jul 2022 13:15:49 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf 2/2] bpf: Update bpf_design_QA.rst to clarify that
 attaching to functions is not ABI
Message-ID: <Yt6JdYSitC6e2lLk@casper.infradead.org>
References: <20220722180641.2902585-1-paulmck@kernel.org>
 <20220722180641.2902585-2-paulmck@kernel.org>
 <d452fcee-2d15-c3b0-cc44-6b880ecc4722@iogearbox.net>
 <20220722212346.GD2860372@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722212346.GD2860372@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 02:23:46PM -0700, Paul E. McKenney wrote:
> On Fri, Jul 22, 2022 at 10:17:57PM +0200, Daniel Borkmann wrote:
> > Otherwise I think this could be a bit misunderstood, e.g. most of the networking
> > programs (e.g. XDP, tc, sock_addr) have a fixed framework around them where
> > attaching programs is part of ABI.
> 
> Excellent point, thank you!
> 
> Apologies for the newbie question, but does BTF_ID() mark a function as
> ABI from the viewpoing of a BPF program calling that function, attaching
> to that function, or both?  Either way, is it worth mentioning this
> in this QA entry?

Not necessarily.  For example, __filemap_add_folio has a BTF_ID(), but
it is not ABI (it's error injection).

> The updated patch below just adds the "arbitrary".
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> commit 89659e20d11fc1350f5881ff7c9687289806b2ba
> Author: Paul E. McKenney <paulmck@kernel.org>
> Date:   Fri Jul 22 10:52:05 2022 -0700
> 
>     bpf: Update bpf_design_QA.rst to clarify that attaching to functions is not ABI
>     
>     This patch updates bpf_design_QA.rst to clarify that the ability to
>     attach a BPF program to an arbitrary function in the kernel does not
>     make that function become part of the Linux kernel's ABI.
>     
>     [ paulmck: Apply Daniel Borkmann feedback. ]
>     
>     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> 
> diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
> index 2ed9128cfbec8..a06ae8a828e3d 100644
> --- a/Documentation/bpf/bpf_design_QA.rst
> +++ b/Documentation/bpf/bpf_design_QA.rst
> @@ -279,3 +279,15 @@ cc (congestion-control) implementations.  If any of these kernel
>  functions has changed, both the in-tree and out-of-tree kernel tcp cc
>  implementations have to be changed.  The same goes for the bpf
>  programs and they have to be adjusted accordingly.
> +
> +Q: Attaching to arbitrary kernel functions is an ABI?
> +-----------------------------------------------------
> +Q: BPF programs can be attached to many kernel functions.  Do these
> +kernel functions become part of the ABI?
> +
> +A: NO.
> +
> +The kernel function prototypes will change, and BPF programs attaching to
> +them will need to change.  The BPF compile-once-run-everywhere (CO-RE)
> +should be used in order to make it easier to adapt your BPF programs to
> +different versions of the kernel.
