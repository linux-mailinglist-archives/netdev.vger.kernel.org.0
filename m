Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBC3196199
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgC0XAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:00:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45685 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbgC0XAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 19:00:54 -0400
Received: by mail-pf1-f193.google.com with SMTP id r14so2737821pfl.12;
        Fri, 27 Mar 2020 16:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+GqeFlYDOVxo+UwHqbYTX+sDCdzCxbsaVnEq0Ryq7Go=;
        b=bwr8UhTluMh/r9tdpl4Lxi5BalTdo4vORZRP8JBtNnkjUDmzPgfOLmS7HauuLut+pi
         h6+EjpW6muF8eVikZi9/fGDhI97eCZVE4VaB7UBqdmINTAmX+6bmj6TkfOhVh9zJQMIC
         MjCx85zMXPePi5RrG35RCk381Vr1xj9p9kvJbbyOQUajDhKHD0zNXhJcedWe8Qhz6HWE
         QOcFVcAfxEeWFRgg0r5G4Zhth7NUec1NCWcgjhgQeBR7y5jUrxYgGQvHTc+kW6SmroBE
         BcTgwMFqKDFPS9HRpMNrRDOa8CVlruG6WCSUz9JGTvkPUkga/c3j717NTyVfgkQTM9DT
         BWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+GqeFlYDOVxo+UwHqbYTX+sDCdzCxbsaVnEq0Ryq7Go=;
        b=EpzPycNlbsIwQMyPe1rDMmn9jtrwYaWHSoAhtp9fohNP1yu4zwRkFCTAywbUQxsUnq
         vZjf/p0mUAQD0+bgwU7o6qp4/DpkN81cjjSW6KNCQUBK8rGRquoLBz5fTtQ5FEndEx1w
         uWaBHG7j9EgyHCEtOUS1uV3ikNExq8/X2RBRmNqfBF6y0nrEwFlHoI6liKobnRnm2Ziq
         wKJdfqzOCYL73gFMMMNY26BCgpVxBwLNMMPWHUbn6tOtTavyPNYgtRYQ/NkrFC9ebKYc
         azbFonKNVnk/eP65biulcE2tBY3BkqlInQF8G2ssVfOmATDZUmjgbUqrz+XqVCrxTrhp
         V1Yg==
X-Gm-Message-State: ANhLgQ2LfpDResDCIjZ4seRJKbm2VvW1iDAQmRWGoKrXA6DHeTlWzDJv
        dIBik+awnn0qzNjnwhWNOJM=
X-Google-Smtp-Source: ADFU+vuUhkrlEEBTB1nOUwmmMAnqQZbVwhLi02JeIWuQdWpJbX4+U9Qlvycgx7eb1uabNDUW+iuCXA==
X-Received: by 2002:a62:fcc7:: with SMTP id e190mr1545773pfh.285.1585350052148;
        Fri, 27 Mar 2020 16:00:52 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:4ef7])
        by smtp.gmail.com with ESMTPSA id z17sm4956001pff.12.2020.03.27.16.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 16:00:50 -0700 (PDT)
Date:   Fri, 27 Mar 2020 16:00:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200327230047.ois5esl35s63qorj@ast-mbp>
References: <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87imiqm27d.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 01:06:46PM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Thu, Mar 26, 2020 at 01:35:13PM +0100, Toke Høiland-Jørgensen wrote:
> >> 
> >> Additionally, in the case where there is *not* a central management
> >> daemon (i.e., what I'm implementing with libxdp), this would be the flow
> >> implemented by the library without bpf_link:
> >> 
> >> 1. Query kernel for current BPF prog loaded on $IFACE
> >> 2. Sanity-check that this program is a dispatcher program installed by
> >>    libxdp
> >> 3. Create a new dispatcher program with whatever changes we want to do
> >>    (such as adding another component program).
> >> 4. Atomically replace the old program with the new one using the netlink
> >>    API in this patch series.
> >
> > in this model what stops another application that is not using libdispatcher to
> > nuke dispatcher program ?
> 
> Nothing. But nothing is stopping it from issuing 'ip link down' either -
> an application with CAP_NET_ADMIN is implicitly trusted to be
> well-behaved. This patch series is just adding the kernel primitive that
> enables applications to be well-behaved. I consider it an API bug-fix.

I think what you're proposing is not a fix, but a band-aid.
And from what I can read in this thread you remain unconvinced that
you will hit exactly the same issues we're describing.
We hit them already and you will hit them a year from now.
Simply because fb usage of all parts of bpf are about 3-4 years ahead
of everyone else.
I'm trying to convince you that your libxdp will be in much better
shape a year from now. It will be prepared for a situation when
other libxdp clones exist and are trying to do the same.
While you're saying:
"let me shot myself in the foot. I know what I'm doing. I'll be fine".
I know you will not be. And soon enough you'll come back proposing
locking, id, owner apis for xdp.

> >> Whereas with bpf_link, it would be:
> >> 
> >> 1. Find the pinned bpf_link for $IFACE (e.g., load from
> >>    /sys/fs/bpf/iface-links/$IFNAME).
> >> 2. Query kernel for current BPF prog linked to $LINK
> >> 3. Sanity-check that this program is a dispatcher program installed by
> >>    libxdp
> >> 4. Create a new dispatcher program with whatever changes we want to do
> >>    (such as adding another component program).
> >> 5. Atomically replace the old program with the new one using the
> >>    LINK_UPDATE bpf() API.
> >
> > whereas here dispatcher program is only accessible to libdispatcher.
> > Instance of bpffs needs to be known to libdispatcher only.
> > That's the ownership I've been talking about.
> >
> > As discussed early we need a way for _human_ to nuke dispatcher program,
> > but such api shouldn't be usable out of application/task.
> 
> As long as there is this kind of override in place, I'm not actually
> fundamentally opposed to the concept of bpf_link for XDP, as an
> additional mechanism. What I'm opposed to is using bpf_link as a reason
> to block this series.
> 
> In fact, a way to implement the "human override" you mention, could be
> to reuse the mechanism implemented in this series: If the EXPECTED_FD
> passed via netlink is a bpf_link FD, that could be interpreted as an
> override by the kernel.

That's not "human override". You want to use expected_fd in libxdp.
That's not human. That's any 'yum install firewall' will be nuking
the bpf_link and careful orchestration of our libxdp.

As far as blocking cap_net_admin...
you mentioned that use case is to do:
sudo yum install firewall1
sudo yum install firewall2

when these packages are being installed they will invoke startup scripts
that will install their dispatcher progs on eth0.
Imagine firewall2 is not using correct vestion of libxdp. or buggy one.
all the good work from firewall1 went down the drain.
Note in both cases you only need cap_net_admin to install the prog.
The packages will not be reconfiguring eth0. They need to be told
which interface to apply firewall to. That's all.
