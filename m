Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE9A1CF9DE
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgELPyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgELPyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:54:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DFCC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:54:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d7so5028758ybp.12
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sBMuJHPTkDyJKfezud+eXJ27K11+ocmFDeUYKeSVeo4=;
        b=pUsW/lRDPZPhhEMS6bzDQR18evwKWE+B/64Yg4lul9AIEoAhkU2L2u9huYqGzICg6i
         C0qzmZtvHI5pkvrevJjOLTHNbEdzPTqZPE5pvX1pmriGhCyAr0lZXDZVKHVQHQoKlM7M
         Stch1uwwmvW1Z4roNVWTjS0PZH1nQJbspJMZQYuIw5vUNBBArW3Hmb7vpGQ9ESlvsLe/
         xqYT7YhXRAeEeYCxOI1lE+ptbbAorEVyoLGOKadYTMH3Q0IQOBHJhHV9qQOUg/n6DLZ1
         lZ+9DqJ8yBsCJFCE4zYWiypKtW8VXK7Qmfbqn4Ak2czJkbo6PikzPqP5xT0E2sKhNGRs
         UdcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sBMuJHPTkDyJKfezud+eXJ27K11+ocmFDeUYKeSVeo4=;
        b=DU1VlFpWfBE4Arowqmcp4UxBjOXB7iePcyt3EDBZU+RVflLe+H/+qjeDj/qZ5bxZgP
         Li7yB8YFe/kgK2NCTE8A4LtiROdQe7IwhN7dDNSDsbk4PyALRQrmofA7ZMyLYvO9dQU5
         eJcqAEmdfcbKzDDssVjbfZTS5Pr1lwFk/SoIR228icKtUugHhciA5Y/BQCAWkECGukif
         NzTk9BDH8efWlTvTvxX4NNdNXiE9lkOhO6bMF6s4UJ7MSbamSI8UtkYNpp496XnSFo4O
         fRWoK+k1qKifojSX2KFxQW8stF+nEQZNxYjNP4Om9ksbfrZo37+l62owwBs+6eDCHxU5
         FyPw==
X-Gm-Message-State: AGi0Pub3hvAE9dJYD9L2JF7NQFQLfue3xgEKn8W9fQ5sRFsIemS21V45
        WP/pYAh5CGzfuWeQjj9DFm+09Ys=
X-Google-Smtp-Source: APiQypKBhS9Rl8NMaHetgrxgWZnUs/dFCEydXDqhAdYv4NlUVRZP8uTAWQScLYQGtzC15G/0AUoQOHo=
X-Received: by 2002:a05:6902:6a9:: with SMTP id j9mr31540016ybt.225.1589298852898;
 Tue, 12 May 2020 08:54:12 -0700 (PDT)
Date:   Tue, 12 May 2020 08:54:11 -0700
In-Reply-To: <20200512023641.jupgmhpliblkli4t@ast-mbp.dhcp.thefacebook.com>
Message-Id: <20200512155411.GB235661@google.com>
Mime-Version: 1.0
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com> <20200512001210.GA235661@google.com>
 <20200512023641.jupgmhpliblkli4t@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
From:   sdf@google.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com,
        linux-security-module@vger.kernel.org, acme@redhat.com,
        jamorris@linux.microsoft.com, jannh@google.com, kpsingh@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/11, Alexei Starovoitov wrote:
> On Mon, May 11, 2020 at 05:12:10PM -0700, sdf@google.com wrote:
> > On 05/08, Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > [..]
> > > @@ -3932,7 +3977,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr
> > > __user *, uattr, unsigned int, siz
> > >   	union bpf_attr attr;
> > >   	int err;
> >
> > > -	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
> > > +	if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
> > >   		return -EPERM;
> > This is awesome, thanks for reviving the effort!
> >
> > One question I have about this particular snippet:
> > Does it make sense to drop bpf_capable checks for the operations
> > that work on a provided fd?

> Above snippet is for the case when sysctl switches unpriv off.
> It was a big hammer and stays big hammer.
> I certainly would like to improve the situation, but I suspect
> the folks who turn that sysctl knob on are simply paranoid about bpf
> and no amount of reasoning would turn them around.
Yeah, and we do use it unfortunately :-( I suppose we still would
like to keep it that way for a while, but maybe start relaxing
some operations a bit.

> > The use-case I have in mind is as follows:
> > * privileged (CAP_BPF) process loads the programs/maps and pins
> >   them at some known location
> > * unprivileged process opens up those pins and does the following:
> >   * prepares the maps (and will later on read them)
> >   * does SO_ATTACH_BPF/SO_ATTACH_REUSEPORT_EBPF which afaik don't
> >     require any capabilities
> >
> > This essentially pushes some of the permission checks into a fs layer.  
> So
> > whoever has a file descriptor (via unix sock or open) can do BPF  
> operations
> > on the object that represents it.

> cap_bpf doesn't change things in that regard.
> Two cases here:
> sysctl_unprivileged_bpf_disabled==0:
>    Unpriv can load socket_filter prog type and unpriv can attach it
>    via SO_ATTACH_BPF/SO_ATTACH_REUSEPORT_EBPF.
> sysctl_unprivileged_bpf_disabled==1:
>    cap_sys_admin can load socket_filter and unpriv can attach it.
Sorry, I wasn't clear enough, I was talking about unpriv_bpf_disabled=1
case.

> With addition of cap_bpf in the second case cap_bpf process can
> load socket_filter too.
> It doesn't mean that permissions are pushed into fs layer.
> I'm not sure that relaxing of sysctl_unprivileged_bpf_disabled
> will be well received.
> Are you proposing to selectively allow certain bpf syscall commands
> even when sysctl_unprivileged_bpf_disabled==1 ?
> Like allow unpriv to do BPF_OBJ_GET to get an fd from bpffs ?
> And allow unpriv to do map_update ?
Yes, that's the gist of what I'm proposing. Allow the operations that
work on fd even with unpriv_bpf_disabled=1. The assumption that
obtaining fd requires a privileged operation on its own and
should give enough protection.

> It makes complete sense to me, but I'd like to argue about that
> independently from this cap_bpf set.
> We can relax that sysctl later.
Ack, thanks, let me bring it up again later, when we get to the cap_bpf
state.
