Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF30357E8DC
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 23:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiGVVXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 17:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiGVVXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 17:23:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA754B5C99;
        Fri, 22 Jul 2022 14:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 361E5B82B1D;
        Fri, 22 Jul 2022 21:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DA3C341C6;
        Fri, 22 Jul 2022 21:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658525026;
        bh=vVhapYzhoF5T6xapt8OGb62w8w46MvmQ5cBjHBEiDLQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Ir6w3Z4lkAUT93V3SuEcqhr9Cw22kquU/jYh1rWulAtUq5KN9B068XdmsoU7TjNIx
         hn0tpDobMNz6BMJ8B62Qd7jDqPAMS3ySDDKIgHoD06P7hFRHTh871HFq/3JTw8PxuK
         q4iXZd6kRPhekQeId7XQPu8iyK9qPuQV2xS2QJzSBG5JTJ/dPXv7BIeoOHJjzN5604
         oVvD382JGRVMfJSl2c7PUyefcUAOlDC5+RDygfkWDkVJ2jOKEW7b2O8CYwbCUdBDFy
         xCxcvrRbqhdwVK2mzxojvkOiRpNs/BBOLxf4n/IHICRq4y00zLXUGq+Xxk6ek0VHc9
         Gf1UOaFbYSG/w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 72BC15C08EB; Fri, 22 Jul 2022 14:23:46 -0700 (PDT)
Date:   Fri, 22 Jul 2022 14:23:46 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf 2/2] bpf: Update bpf_design_QA.rst to clarify that
 attaching to functions is not ABI
Message-ID: <20220722212346.GD2860372@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220722180641.2902585-1-paulmck@kernel.org>
 <20220722180641.2902585-2-paulmck@kernel.org>
 <d452fcee-2d15-c3b0-cc44-6b880ecc4722@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d452fcee-2d15-c3b0-cc44-6b880ecc4722@iogearbox.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 10:17:57PM +0200, Daniel Borkmann wrote:
> On 7/22/22 8:06 PM, Paul E. McKenney wrote:
> > This patch updates bpf_design_QA.rst to clarify that the ability to
> > attach a BPF program to a given function in the kernel does not make
> > that function become part of the Linux kernel's ABI.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > ---
> >   Documentation/bpf/bpf_design_QA.rst | 12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> > 
> > diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
> > index 2ed9128cfbec8..46337a60255e9 100644
> > --- a/Documentation/bpf/bpf_design_QA.rst
> > +++ b/Documentation/bpf/bpf_design_QA.rst
> > @@ -279,3 +279,15 @@ cc (congestion-control) implementations.  If any of these kernel
> >   functions has changed, both the in-tree and out-of-tree kernel tcp cc
> >   implementations have to be changed.  The same goes for the bpf
> >   programs and they have to be adjusted accordingly.
> > +
> > +Q: Attaching to kernel functions is an ABI?
> 
> small nit, I'd change to: Attaching to arbitrary kernel functions [...]
> 
> Otherwise I think this could be a bit misunderstood, e.g. most of the networking
> programs (e.g. XDP, tc, sock_addr) have a fixed framework around them where
> attaching programs is part of ABI.

Excellent point, thank you!

Apologies for the newbie question, but does BTF_ID() mark a function as
ABI from the viewpoing of a BPF program calling that function, attaching
to that function, or both?  Either way, is it worth mentioning this
in this QA entry?

The updated patch below just adds the "arbitrary".

							Thanx, Paul

------------------------------------------------------------------------

commit 89659e20d11fc1350f5881ff7c9687289806b2ba
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Fri Jul 22 10:52:05 2022 -0700

    bpf: Update bpf_design_QA.rst to clarify that attaching to functions is not ABI
    
    This patch updates bpf_design_QA.rst to clarify that the ability to
    attach a BPF program to an arbitrary function in the kernel does not
    make that function become part of the Linux kernel's ABI.
    
    [ paulmck: Apply Daniel Borkmann feedback. ]
    
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
index 2ed9128cfbec8..a06ae8a828e3d 100644
--- a/Documentation/bpf/bpf_design_QA.rst
+++ b/Documentation/bpf/bpf_design_QA.rst
@@ -279,3 +279,15 @@ cc (congestion-control) implementations.  If any of these kernel
 functions has changed, both the in-tree and out-of-tree kernel tcp cc
 implementations have to be changed.  The same goes for the bpf
 programs and they have to be adjusted accordingly.
+
+Q: Attaching to arbitrary kernel functions is an ABI?
+-----------------------------------------------------
+Q: BPF programs can be attached to many kernel functions.  Do these
+kernel functions become part of the ABI?
+
+A: NO.
+
+The kernel function prototypes will change, and BPF programs attaching to
+them will need to change.  The BPF compile-once-run-everywhere (CO-RE)
+should be used in order to make it easier to adapt your BPF programs to
+different versions of the kernel.
