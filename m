Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC59E1D1E18
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390346AbgEMSy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMSy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:54:56 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E11C061A0C;
        Wed, 13 May 2020 11:54:56 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ms17so11391791pjb.0;
        Wed, 13 May 2020 11:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X+tiTUKR52hR/CFXikpPztlZQufINQFKEJJZyyWqqvU=;
        b=ac+5sOAGFaLUvkd0neVVWhrkjvZb418eZVZTC51A5Xb62lzRpmZzTmeNSSQW/sRKiW
         /E+x8fNohknBodfvPfamdk5ZWRmEmR59cnB0w8Yl6TXjHnXLxIf/rVRjLaT6OVEEF09v
         j2QbYv3aJEElkFCEAkDkL3/1G13FQ1rKOmvHERGxCEK81xjAY8CGhz1rsfV5KSSsLxRA
         7hy8gNa/Gu0zL7go9zBcS5pHgLSuZFNXHg3D5ToJ6zCxGSdycwdSKZ6OYn4j10OQTQ3v
         NyeR4/0MleQY8EfscGbluzmjOyhzVxMDrjAUYFkYe6faHSa9Ld4qhFnV/jQT6aNQkdOo
         7+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X+tiTUKR52hR/CFXikpPztlZQufINQFKEJJZyyWqqvU=;
        b=qlfs1O5iGbYQbwY8L76ReeLO9AEpZEQV05tNvvX9bfB2G6tonNVmCWB32h3eWy2MhC
         AWuBga4WkEvWAsb9npG7zHKLx5Ja5ld9vJyD9zRdu5Cud/c/+TISUry3W3cn2fseHhHN
         dJmbbU1GqPdtHgGhOe0TOSbRXJjiS7kmTbcw57hLqf5rO/wZ+mCaNzrHqbKDvj6XfGZm
         d/R7u/ZJ3nBf+mVu1isOWH5qRPhoIwO31hhabfMYi5rGrCAez++ozahWwEJZZu/GjMiJ
         xYf635r5tKmLiSfD+x56IWEE4HeBDRzUcM5xcsQACBNvZYH1oKDejMydj97Ccgi4EN/m
         ItqQ==
X-Gm-Message-State: AGi0Puam+n4snrIZDkO2P1rhcqTBSJwQy5GfNzDfsMIyxwXp4JciZDov
        KPlORrLpqtjCoVTmtsBELKg=
X-Google-Smtp-Source: APiQypKr6opWiTPLst/o6TxOrZnXhv7hbIXG5kajruV2fweeGe0clTA8I+KsC4je/Twr5l2oAcQRaA==
X-Received: by 2002:a17:90a:8a03:: with SMTP id w3mr37293206pjn.29.1589396096142;
        Wed, 13 May 2020 11:54:56 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:ba8f])
        by smtp.gmail.com with ESMTPSA id z28sm261824pfr.3.2020.05.13.11.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 11:54:54 -0700 (PDT)
Date:   Wed, 13 May 2020 11:54:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        network dev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com,
        Jann Horn <jannh@google.com>, kpsingh@google.com,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH v6 bpf-next 0/3] Introduce CAP_BPF
Message-ID: <20200513185452.6dvzhpz5sgs7hcti@ast-mbp.dhcp.thefacebook.com>
References: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
 <CAJPywT+c8uvi2zgUD_jObmi9T6j50THzjQHg-mudNrEC2HuJvg@mail.gmail.com>
 <20200513175301.43lxbckootoefrow@ast-mbp.dhcp.thefacebook.com>
 <CAJPywTKUmzDObSurppiH4GCJquDTnVWKLH48JNB=8RNcb5TiCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJPywTKUmzDObSurppiH4GCJquDTnVWKLH48JNB=8RNcb5TiCQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 07:30:05PM +0100, Marek Majkowski wrote:
> On Wed, May 13, 2020 at 6:53 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Wed, May 13, 2020 at 11:50:42AM +0100, Marek Majkowski wrote:
> > > On Wed, May 13, 2020 at 4:19 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > CAP_BPF solves three main goals:
> > > > 1. provides isolation to user space processes that drop CAP_SYS_ADMIN and switch to CAP_BPF.
> > > >    More on this below. This is the major difference vs v4 set back from Sep 2019.
> > > > 2. makes networking BPF progs more secure, since CAP_BPF + CAP_NET_ADMIN
> > > >    prevents pointer leaks and arbitrary kernel memory access.
> > > > 3. enables fuzzers to exercise all of the verifier logic. Eventually finding bugs
> > > >    and making BPF infra more secure. Currently fuzzers run in unpriv.
> > > >    They will be able to run with CAP_BPF.
> > > >
> > >
> > > Alexei, looking at this from a user point of view, this looks fine.
> > >
> > > I'm slightly worried about REUSEPORT_EBPF. Currently without your
> > > patch, as far as I understand it:
> > >
> > > - You can load SOCKET_FILTER and SO_ATTACH_REUSEPORT_EBPF without any
> > > permissions
> >
> > correct.
> >
> > > - For loading BPF_PROG_TYPE_SK_REUSEPORT program and for SOCKARRAY map
> > > creation CAP_SYS_ADMIN is needed. But again, no permissions check for
> > > SO_ATTACH_REUSEPORT_EBPF later.
> >
> > correct. With clarification that attaching process needs to own
> > FD of prog and FD of socket.
> >
> > > If I read the patchset correctly, the former SOCKET_FILTER case
> > > remains as it is and is not affected in any way by presence or absence
> > > of CAP_BPF.
> >
> > correct. As commit log says:
> > "Existing unprivileged BPF operations are not affected."
> >
> > > The latter case is different. Presence of CAP_BPF is sufficient for
> > > map creation, but not sufficient for loading SK_REUSEPORT program. It
> > > still requires CAP_SYS_ADMIN.
> >
> > Not quite.
> > The patch will allow BPF_PROG_TYPE_SK_REUSEPORT progs to be loaded
> > with CAP_BPF + CAP_NET_ADMIN.
> > Since this type of progs is clearly networking type I figured it's
> > better to be consistent with the rest of networking types.
> > Two unpriv types SOCKET_FILTER and CGROUP_SKB is the only exception.
> 
> Ok, this is the controversy. It made sense to restrict SK_REUSEPORT
> programs in the past, because programs needed CAP_NET_ADMIN to create
> SOCKARRAY anyway. 

Not quite. Currently sockarray needs CAP_SYS_ADMIN to create
which makes little sense from security pov.
CAP_BPF relaxes it CAP_BPF or CAP_SYS_ADMIN.

> Now we change this and CAP_BPF is sufficient for
> maps - I don't see why CAP_BPF is not sufficient for SK_REUSEPORT
> programs. From a user point of view I don't get why this additional
> CAP_NET_ADMIN is needed.

That actually bring another point. I'm not changing sock_map,
sock_hash, dev_map requirements yet. All three still require CAP_NET_ADMIN.
We can relax them to CAP_BPF _or_ CAP_NET_ADMIN in the future,
but I'd like to do that in the follow up.

> 
> > > I think it's a good opportunity to relax
> > > this CAP_SYS_ADMIN requirement. I think the presence of CAP_BPF should
> > > be sufficient for loading BPF_PROG_TYPE_SK_REUSEPORT.
> > >
> > > Our specific use case is simple - we want an application program -
> > > like nginx - to control REUSEPORT programs. We will grant it CAP_BPF,
> > > but we don't want to grant it CAP_SYS_ADMIN.
> >
> > You'll be able to grant nginx CAP_BPF + CAP_NET_ADMIN to load SK_REUSEPORT
> > and unpriv child process will be able to attach just like before if
> > it has right FDs.
> > I suspect your load balancer needs CAP_NET_ADMIN already anyway due to
> > use of XDP and TC progs.
> > So granting CAP_BPF + CAP_NET_ADMIN should cover all bpf prog needs.
> > Does it address your concern?
> 
> Load balancer (XDP+TC) is another layer and permissions there are not
> a problem. The specific issue is nginx (port 443) and QUIC. QUIC is
> UDP and due to the nginx design we must use REUSEPORT groups to
> balance the load across workers. This is fine and could be done with a
> simple SOCK_FILTER - we don't need to grant nginx any permissions,
> apart from CAP_NET_BIND_SERVICE.
> 
> We would like to make the REUSEPORT program more complex to take
> advantage of REUSEPORT_EBPF for stickyness (restarting server without
> interfering with existing flows), we are happy to grant nginx CAP_BPF,
> but we are not happy to grant it CAP_NET_ADMIN. Requiring this CAP for
> REUSEPORT severely restricts the API usability for us.
> 
> In my head REUSEPORT_EBPF is much closer to SOCKET_FILTER. I
> understand why it needed capabilities before (map creation) and I
> argue these reasons go away in CAP_BPF world. I assume that any
> service (with CAP_BPF) should be able to use reuseport to distribute
> packets within its own sockets.  Let me know if I'm missing something.

Fair enough. We can include SK_REUSEPORT prog type as part of CAP_BPF alone.
But will it truly achieve what you want?
You still need CAP_NET_ADMIN for sock_hash which you're using.
Are you saying it's part of the different process that has that cap_net_admin
and nginx will be fine with cap_bpf + cap_net_bind_service ?
