Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774C75802F8
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbiGYQkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 12:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbiGYQkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 12:40:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D93AEA;
        Mon, 25 Jul 2022 09:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3897F61320;
        Mon, 25 Jul 2022 16:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80169C341C6;
        Mon, 25 Jul 2022 16:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658767205;
        bh=d99NW54BYznpRvmtCwN+/aTt0a6aACw7qSGDTXU2/p4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=TTbNGmXzCYVL4vXoSapdkxnJ8WpxQVuIGWBpmzaliX5cLFOFnBE45S41O/aS3oJWz
         y+aPVwD3ASyXCcOJ8VWyVrjTxTSgSoRmrVlqsYsOPNibPaNPr6fqnf3I86gTQCQ7/s
         sRDdBthnq7gBKA+lBRL3Y6++V82R4//yaFzXnDQuIfw799Povej7CWtEFi1T1n/o7A
         sG/guFRzXNvzSMrZzik8IWSMz4V85xMr6PuqRyFPGSU7T/jXBqwiGWHKLftWgShQEL
         MvRD9UzynUVo8dPCUJPZD7WHA7j0shSzExTmjD21SV7uS4GkhedIt7PFtBXIUkn/ks
         mByRqHE/yTqTA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 213655C03E0; Mon, 25 Jul 2022 09:40:05 -0700 (PDT)
Date:   Mon, 25 Jul 2022 09:40:05 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf 2/2] bpf: Update bpf_design_QA.rst to clarify that
 attaching to functions is not ABI
Message-ID: <20220725164005.GG2860372@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220722180641.2902585-1-paulmck@kernel.org>
 <20220722180641.2902585-2-paulmck@kernel.org>
 <d452fcee-2d15-c3b0-cc44-6b880ecc4722@iogearbox.net>
 <20220722212346.GD2860372@paulmck-ThinkPad-P17-Gen-1>
 <Yt6JdYSitC6e2lLk@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt6JdYSitC6e2lLk@casper.infradead.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 01:15:49PM +0100, Matthew Wilcox wrote:
> On Fri, Jul 22, 2022 at 02:23:46PM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 22, 2022 at 10:17:57PM +0200, Daniel Borkmann wrote:
> > > Otherwise I think this could be a bit misunderstood, e.g. most of the networking
> > > programs (e.g. XDP, tc, sock_addr) have a fixed framework around them where
> > > attaching programs is part of ABI.
> > 
> > Excellent point, thank you!
> > 
> > Apologies for the newbie question, but does BTF_ID() mark a function as
> > ABI from the viewpoing of a BPF program calling that function, attaching
> > to that function, or both?  Either way, is it worth mentioning this
> > in this QA entry?
> 
> Not necessarily.  For example, __filemap_add_folio has a BTF_ID(), but
> it is not ABI (it's error injection).

OK, sounds like something to leave out of the QA, then.

							Thanx, Paul

> > The updated patch below just adds the "arbitrary".
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > commit 89659e20d11fc1350f5881ff7c9687289806b2ba
> > Author: Paul E. McKenney <paulmck@kernel.org>
> > Date:   Fri Jul 22 10:52:05 2022 -0700
> > 
> >     bpf: Update bpf_design_QA.rst to clarify that attaching to functions is not ABI
> >     
> >     This patch updates bpf_design_QA.rst to clarify that the ability to
> >     attach a BPF program to an arbitrary function in the kernel does not
> >     make that function become part of the Linux kernel's ABI.
> >     
> >     [ paulmck: Apply Daniel Borkmann feedback. ]
> >     
> >     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > 
> > diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
> > index 2ed9128cfbec8..a06ae8a828e3d 100644
> > --- a/Documentation/bpf/bpf_design_QA.rst
> > +++ b/Documentation/bpf/bpf_design_QA.rst
> > @@ -279,3 +279,15 @@ cc (congestion-control) implementations.  If any of these kernel
> >  functions has changed, both the in-tree and out-of-tree kernel tcp cc
> >  implementations have to be changed.  The same goes for the bpf
> >  programs and they have to be adjusted accordingly.
> > +
> > +Q: Attaching to arbitrary kernel functions is an ABI?
> > +-----------------------------------------------------
> > +Q: BPF programs can be attached to many kernel functions.  Do these
> > +kernel functions become part of the ABI?
> > +
> > +A: NO.
> > +
> > +The kernel function prototypes will change, and BPF programs attaching to
> > +them will need to change.  The BPF compile-once-run-everywhere (CO-RE)
> > +should be used in order to make it easier to adapt your BPF programs to
> > +different versions of the kernel.
