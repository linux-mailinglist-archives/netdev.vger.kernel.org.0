Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74CF1CFD71
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbgELSjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgELSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:39:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CBDC061A0C;
        Tue, 12 May 2020 11:39:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z1so6775321pfn.3;
        Tue, 12 May 2020 11:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DjcujlJce+yGdTM56KR+siVfTTDonJGCqjFrtlrB12E=;
        b=TKIZUpleOm+PkJ9tqBZBzNyIrq3m78JQFWKHIGSEqtcLQ6LODxtCb/m4luvQRtRCZB
         YF8jVeEnDCHolzy3z4aaw6G+IAUWpl5/o8dIMthPyFEKYdI3YjcX4WtBiwD6nO6vNmVZ
         DzohTK35FNyHiiwZq0QhghkvgzykP8E6nX6b5zl3s25ntYD2rf8n4PQYZUQb5cUFGq3P
         CXxL1tW/RcklACqpdbU3eZeWt+QXV2I4/GLn6DBRTu3f17iQMICCpp7kXK19NZcxB7rG
         LQ2b6Wk7ueK/vM9+kTiltDdga69+ZfqqYAnB7kybfnraNEgq6FRZJ6pf6Zt2ZFBOJI0Y
         5BAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DjcujlJce+yGdTM56KR+siVfTTDonJGCqjFrtlrB12E=;
        b=sVkHTOWCLb5qrTR9/Fag85FkFc29wAJAmnWc3lBzWRjkipfwyfc3K7X6FdHtq81X/u
         Q4O8lOjU/IqPCEuSYJ6vEt6xVwlScp53CR9iKWcqrmmDq276vl/4YqZnpGJ5SBFoZ7jM
         S6yRHzBafzc1Js2fuDIUUSua3+5Aew/Pdy/kMI+Iu0n485sA9AXji0QMA0IjUJHI+fNN
         8HzC/z4T9VRsViP48+OBDkievnnmXe0U9kA3qX70TloX/hMol5eVDqspGRKp4iyVm6Sy
         7MD3sQ48xyE2FZ/XOym3ySw9VZSNuFK7pcJL7NPYwE5n8yKfzNqM5I6cAt4/yrs7xgOE
         oFtw==
X-Gm-Message-State: AGi0PuZ0aPqs/rlZh+jYavluj3ox6gxJs/Otny5xinUvrULhiPHG0ZYB
        G0M3w23hXNJgWFmhGVPF19xCMKEr
X-Google-Smtp-Source: APiQypINbdHjYVXKeWBxAYbOqHUnfaB4UJzqJskMbX8OGHkD/+fXFaDcOlnD+ANXQjOFUfCx3HRsUg==
X-Received: by 2002:a63:e542:: with SMTP id z2mr19775152pgj.165.1589308754589;
        Tue, 12 May 2020 11:39:14 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c3f6])
        by smtp.gmail.com with ESMTPSA id l15sm13732315pjk.56.2020.05.12.11.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 11:39:13 -0700 (PDT)
Date:   Tue, 12 May 2020 11:39:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     sdf@google.com
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com,
        linux-security-module@vger.kernel.org, acme@redhat.com,
        jamorris@linux.microsoft.com, jannh@google.com, kpsingh@google.com
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20200512183911.cr365b7etucyxgpz@ast-mbp>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <20200512001210.GA235661@google.com>
 <20200512023641.jupgmhpliblkli4t@ast-mbp.dhcp.thefacebook.com>
 <20200512155411.GB235661@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512155411.GB235661@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 08:54:11AM -0700, sdf@google.com wrote:
> On 05/11, Alexei Starovoitov wrote:
> > On Mon, May 11, 2020 at 05:12:10PM -0700, sdf@google.com wrote:
> > > On 05/08, Alexei Starovoitov wrote:
> > > > From: Alexei Starovoitov <ast@kernel.org>
> > > [..]
> > > > @@ -3932,7 +3977,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr
> > > > __user *, uattr, unsigned int, siz
> > > >   	union bpf_attr attr;
> > > >   	int err;
> > >
> > > > -	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
> > > > +	if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
> > > >   		return -EPERM;
> > > This is awesome, thanks for reviving the effort!
> > >
> > > One question I have about this particular snippet:
> > > Does it make sense to drop bpf_capable checks for the operations
> > > that work on a provided fd?
> 
> > Above snippet is for the case when sysctl switches unpriv off.
> > It was a big hammer and stays big hammer.
> > I certainly would like to improve the situation, but I suspect
> > the folks who turn that sysctl knob on are simply paranoid about bpf
> > and no amount of reasoning would turn them around.
> Yeah, and we do use it unfortunately :-( I suppose we still would
> like to keep it that way for a while, but maybe start relaxing
> some operations a bit.

I suspect that was done couple years ago when spectre was just discovered and
the verifier wasn't doing speculative analysis.
If your security folks still insist on that sysctl they either didn't
follow bpf development or paranoid.
If former is the case I would love to openly discuss all the advances in
the verification logic to prevent side channels.
The verifier is doing amazing job finding bad assembly code.
There is no other tool that is similarly capable.
All compilers and static analyzers are no where close to the level
of sophistication that the verifier has in detection of bad speculation.

> > > The use-case I have in mind is as follows:
> > > * privileged (CAP_BPF) process loads the programs/maps and pins
> > >   them at some known location
> > > * unprivileged process opens up those pins and does the following:
> > >   * prepares the maps (and will later on read them)
> > >   * does SO_ATTACH_BPF/SO_ATTACH_REUSEPORT_EBPF which afaik don't
> > >     require any capabilities
> > >
> > > This essentially pushes some of the permission checks into a fs layer.
> > So
> > > whoever has a file descriptor (via unix sock or open) can do BPF
> > operations
> > > on the object that represents it.
> 
> > cap_bpf doesn't change things in that regard.
> > Two cases here:
> > sysctl_unprivileged_bpf_disabled==0:
> >    Unpriv can load socket_filter prog type and unpriv can attach it
> >    via SO_ATTACH_BPF/SO_ATTACH_REUSEPORT_EBPF.
> > sysctl_unprivileged_bpf_disabled==1:
> >    cap_sys_admin can load socket_filter and unpriv can attach it.
> Sorry, I wasn't clear enough, I was talking about unpriv_bpf_disabled=1
> case.
> 
> > With addition of cap_bpf in the second case cap_bpf process can
> > load socket_filter too.
> > It doesn't mean that permissions are pushed into fs layer.
> > I'm not sure that relaxing of sysctl_unprivileged_bpf_disabled
> > will be well received.
> > Are you proposing to selectively allow certain bpf syscall commands
> > even when sysctl_unprivileged_bpf_disabled==1 ?
> > Like allow unpriv to do BPF_OBJ_GET to get an fd from bpffs ?
> > And allow unpriv to do map_update ?
> Yes, that's the gist of what I'm proposing. Allow the operations that
> work on fd even with unpriv_bpf_disabled=1. The assumption that
> obtaining fd requires a privileged operation on its own and
> should give enough protection.

I agree.

> 
> > It makes complete sense to me, but I'd like to argue about that
> > independently from this cap_bpf set.
> > We can relax that sysctl later.
> Ack, thanks, let me bring it up again later, when we get to the cap_bpf
> state.

Thanks for the feedback.
Just to make sure we're on the same page let me clarify one more thing.
The state of cap_bpf in this patch set is not the final state of bpf
security in general. We were stuck on cap_bpf proposal since september.
bpf community lost many months of what could have been gradual
improvements in bpf safety and security.
This cap_bpf is a way to get us unstuck. There will be many more
security related patches that improve safety, security and usability.
