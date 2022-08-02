Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7006588139
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 19:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbiHBRm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 13:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiHBRm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 13:42:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2536A4B0D8;
        Tue,  2 Aug 2022 10:42:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92BAC6122D;
        Tue,  2 Aug 2022 17:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBADFC433C1;
        Tue,  2 Aug 2022 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659462173;
        bh=ChZheDQxjFbvZYxirITeZHqH1hnlckxoxxSKad+75DA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=ct/fqppZJjAyJCNkVKnk9X0FbEQkii3byC82v6sr9OR8qjCAa/SHBabA2e6GVFt97
         I33wG7MRx7Vk2dWY181acEqYgJ/UW9nfRlY30CRQJdi/O8+ccx0zykQufqS37584t2
         7rB7nkuTG1loJMSED1oPbpTvSaTIFTvqgVM8i7Yhqg4JH61glx6beNj/Jtdr1jP+i/
         hrpWMCAAljV7IOkKpYAuuUVOX6tZz6pD7eyXOBsrKF22YiScPAAccd2Ns8UNREIEXJ
         5FZP+kMNBMJ66PFxpRBKiRmBSZyADZTAijzreHVvMYEN4Tb6uyKdKsE5BsKAnF30ng
         FNbi1pxHwfFzg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 8961F5C0369; Tue,  2 Aug 2022 10:42:52 -0700 (PDT)
Date:   Tue, 2 Aug 2022 10:42:52 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf 2/2] bpf: Update bpf_design_QA.rst to clarify that
 attaching to functions is not ABI
Message-ID: <20220802174252.GG2860372@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220722180641.2902585-1-paulmck@kernel.org>
 <20220722180641.2902585-2-paulmck@kernel.org>
 <d452fcee-2d15-c3b0-cc44-6b880ecc4722@iogearbox.net>
 <20220722212346.GD2860372@paulmck-ThinkPad-P17-Gen-1>
 <Yt6JdYSitC6e2lLk@casper.infradead.org>
 <20220725164005.GG2860372@paulmck-ThinkPad-P17-Gen-1>
 <CAADnVQKcRv5RJh0aLEg4+xsBepf=24nyHtbN2Q1t8dgZ9U1jRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKcRv5RJh0aLEg4+xsBepf=24nyHtbN2Q1t8dgZ9U1jRQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 10:34:16PM -0700, Alexei Starovoitov wrote:
> On Mon, Jul 25, 2022 at 9:40 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Mon, Jul 25, 2022 at 01:15:49PM +0100, Matthew Wilcox wrote:
> > > On Fri, Jul 22, 2022 at 02:23:46PM -0700, Paul E. McKenney wrote:
> > > > On Fri, Jul 22, 2022 at 10:17:57PM +0200, Daniel Borkmann wrote:
> > > > > Otherwise I think this could be a bit misunderstood, e.g. most of the networking
> > > > > programs (e.g. XDP, tc, sock_addr) have a fixed framework around them where
> > > > > attaching programs is part of ABI.
> > > >
> > > > Excellent point, thank you!
> > > >
> > > > Apologies for the newbie question, but does BTF_ID() mark a function as
> > > > ABI from the viewpoing of a BPF program calling that function, attaching
> > > > to that function, or both?  Either way, is it worth mentioning this
> > > > in this QA entry?
> > >
> > > Not necessarily.  For example, __filemap_add_folio has a BTF_ID(), but
> > > it is not ABI (it's error injection).
> >
> > OK, sounds like something to leave out of the QA, then.
> 
> Obviously, BTF_ID marking doesn't make the kernel function an abi
> in any way. Just like EXPORT_SYMBOL_GPL doesn't do it.
> Documentation/bpf/kfuncs.rst already explains it.
> Probably worth repeating in the QA part of the doc.

Like this?

							Thanx, Paul

------------------------------------------------------------------------

commit 9346b452b92fc520a59da655b55d6bc40f9d1d14
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Tue Aug 2 10:31:17 2022 -0700

    bpf: Update bpf_design_QA.rst to clarify that BTF_ID does not ABIify a function
    
    This patch updates bpf_design_QA.rst to clarify that mentioning a function
    to the BTF_ID macro does not make that function become part of the Linux
    kernel's ABI.
    
    Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index a06ae8a828e3d..a210b8a4df005 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -291,3 +291,10 @@ The kernel function prototypes will change, and BPF programs attaching to
 them will need to change.  The BPF compile-once-run-everywhere (CO-RE)
 should be used in order to make it easier to adapt your BPF programs to
 different versions of the kernel.
+
+Q: Marking a function with BTF_ID makes that function an ABI?
+-------------------------------------------------------------
+A: NO.
+
+The BTF_ID macro does not cause a function to become part of the ABI
+any more than does the EXPORT_SYMBOL_GPL macro.
