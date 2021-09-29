Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E541C9AB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345608AbhI2QIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346365AbhI2QI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:08:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C345AC06176D;
        Wed, 29 Sep 2021 08:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=66kcDX4j9SWeNVqC2qsyhHxLYpPMWSV88hcaCjXWkO0=; b=WIqdC8eCERWRWrKKbrN36grsgm
        QLRTNAK03cxDdJQMKf3dnIo3j5MUjjvstJ42yTghzBEWoWc59AYfvWnCeNpMay/rvSiFviinH55UN
        D0WPDDLLevQsWEe8F5Ggaq3gAyUFf8sUPMRQHByblE0pd9dpL2owgs+2RlbnRbVtkjeCi/BQVNSbS
        ZIXZmVnLkol2Bu/XO1pJx/X+YxjUSeRxDw+Hu7zIloTFEn8xlxYH4m7hOHHmsbYFzKZoAWI/CGUj2
        R4h++Iehj+Jm8XsCaC4DcHePTjylepdWeGJUx8k0Vculx06lwd7DqcxiZnyaTl9v15HxKPaou7tMD
        3rvimdJA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbzN-006jtL-0f; Wed, 29 Sep 2021 15:59:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1C0A8300056;
        Wed, 29 Sep 2021 17:59:20 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0322A2C78F4FA; Wed, 29 Sep 2021 17:59:19 +0200 (CEST)
Date:   Wed, 29 Sep 2021 17:59:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Message-ID: <YVSNV/1tFRGWIa6c@hirez.programming.kicks-ass.net>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
 <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
 <C6DF009D-161A-4B17-88AE-3982DD6F22A2@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C6DF009D-161A-4B17-88AE-3982DD6F22A2@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 02:42:27PM +0000, Song Liu wrote:
> Hi Peter, 
> 
> > On Sep 29, 2021, at 5:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > On Wed, Sep 29, 2021 at 08:05:24PM +0800, Like Xu wrote:
> >> On 29/9/2021 3:35 pm, Peter Zijlstra wrote:
> > 
> >>>> [  139.494159] unchecked MSR access error: WRMSR to 0x3f1 (tried to write 0x0000000000000000) at rIP: 0xffffffff81011a8b (intel_pmu_snapshot_branch_stack+0x3b/0xd0)
> >> 
> >> Uh, it uses a PEBS counter to sample or count, which is not yet upstream but
> >> should be soon.
> > 
> > Ooh that's PEBS_ENABLE
> > 
> >> Song, can you try to fix bpf_get_branch_snapshot on a normal PMC counter,
> >> or where is the src for bpf_get_branch_snapshot? I am more than happy to help.
> > 
> > Nah, all that code wants to do is disable PEBS... and virt being virt,
> > it's all sorts of weird with f/m/s :/
> > 
> > I so hate all that. So there's two solutions:
> > 
> > - get confirmation that clearing GLOBAL_CTRL is suffient to supress
> >   PEBS, in which case we can simply remove the PEBS_ENABLE clear.
> 
> How should we confirm this? Can we run some tests for this? Or do we
> need hardware experts' input for this?

I'll put it on the list to ask the hardware people when I talk to them
next. But maybe Kan or Andi know without asking.
