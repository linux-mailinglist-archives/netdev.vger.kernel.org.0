Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 015A6198AC7
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 06:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgCaEBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 00:01:20 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42682 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgCaEBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 00:01:20 -0400
Received: by mail-pl1-f194.google.com with SMTP id e1so7610229plt.9;
        Mon, 30 Mar 2020 21:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZC40A9tEmS88Wu0yKU/oWRDpI8/iuziLQhjXOXknsZk=;
        b=JgUFsIUjbfIkAlxs3hY7f+QKxydbNeTiol7uGLKg9iy4LfFT2M6+/niYLybGdgVB33
         wZAXhblLwHTsaosDJ15L/FJ0tixBAqlANlZtYdEqPtxTks8uKBd6WMYTb6sS0vh+8z34
         NWbBGRvFbreGivgyIEZxTsV+d03vkTZ5nHl4dKUhTUv86CZy7rVC+4sltRO0uq0/KtUp
         wrpT5FEMeP02pJRjUYbE94JzcPoDlfCJAlGikjP39cnMLtuCkTLZBWQu9tMiPO7yMuhp
         o89LMK/d1ksRLRH9zeA4AJCx/yeV01j3xAooUNiMVZ67jQ3q9hkF3SnEkR0lpPtw2c4E
         fNXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZC40A9tEmS88Wu0yKU/oWRDpI8/iuziLQhjXOXknsZk=;
        b=FdrLOv7UqCHks5Vp0GmqQBOgsj3Ey3McOIfoJy82+7YJsU76zk5bBCVwZhNiNtezou
         yTFk6U361mTWxL0p2mYzpJhNAlR+X120617PfJRiOsgXLIz79rVAKxyBva0KZuQV+m/O
         ntUYSiCD3e/2BcQHHhveVIVDFLlO51RTofU0cRSqTXvLWl1Emv0xRB5FAF59iQo1KWaw
         AlMth+TzmGIO53lNSsNKmlyyb7p/L07jafagfQ1zCFHPs6hhN/mNO6wnwbCNbEOgrkGw
         iNRSMq3Vi5PoVwifbDZFK0MChw1qE3B0jynhpn33XNjgqHykLeS620HzFGHWe6uY1bGT
         tzMg==
X-Gm-Message-State: AGi0PuaAhKzYxDsqytQuENkUL9gXtSHzbjjIWMk2agtF3QErIwLzAEvo
        PVvIndV/4buCu4Cx1BjS+cM=
X-Google-Smtp-Source: APiQypIWbWU9dMgpUlPMRxl5SaMkLzutbTmTwADpif49tnuLVu1GJtORUIpPp6AURxHwQoWTiamWjw==
X-Received: by 2002:a17:90a:3547:: with SMTP id q65mr1643566pjb.118.1585627278751;
        Mon, 30 Mar 2020 21:01:18 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:442d])
        by smtp.gmail.com with ESMTPSA id b25sm11307737pfp.201.2020.03.30.21.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 21:01:17 -0700 (PDT)
Date:   Mon, 30 Mar 2020 21:01:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Message-ID: <20200331040112.5tvvubsf6ij4eupb@ast-mbp>
References: <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk>
 <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk>
 <20200328022609.zfupojim7see5cqx@ast-mbp>
 <87eetcl1e3.fsf@toke.dk>
 <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
 <53515939-00bb-174c-bc55-f90eaceac2a3@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53515939-00bb-174c-bc55-f90eaceac2a3@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 04:41:46PM +0100, Edward Cree wrote:
> On 29/03/2020 21:23, Andrii Nakryiko wrote:
> > But you can't say the same about other XDP applications that do not
> > use libxdp. So will your library come with a huge warning
> What about a system-wide policy switch to decide whether replacing/
>  removing an XDP program without EXPECTED_FD is allowed?  That way
>  the sysadmin gets to choose whether it's the firewall or the packet
>  analyser that breaks, rather than baking a policy into the design.
> Then libxdp just needs to say in the README "you might want to turn
>  on this switch".  Or maybe it defaults to on, and the other program
>  has to talk you into turning it off if it wants to be 'ill-behaved'.

yeah. something like this can work for xdp only, but
it won't work for tc, since ownership is missing.
It looks like such policy knob will bere-inventing bpf_link for
one specific xdp case only because xdp has one program per attachment.

Imagine it was easy to come up with sensible policy and allow
multiple progs in xdp hook.
How would you implement such policy knob?
processA attaches prog XDP_A. processB attaches prog XDP-B.
Unless they start tagging their indivdual programs with BTF tags
(as Toke is planning to do) there is no way to tell them apart.
Then processA can iterate all progs in a hook, finds its prog
based on tag and tell kernel: "find and replace an xdp prog with old_fd
with new_fd on this ifindex".
Kinda works, but it doesn't stop processB to accidently detach prog XDP_A
that was installed by processA.

The kernel job is to share the system resources. Like memory, cpu time.
The hook is such resource too. The owner concept part of bpf_link
allows such sharing.

> Either way, affected users will be driven to the kernel's
>  documentation for the policy switch, where we can tell them whatever
>  we think they need to know.

In the data center there are no users. Few months back I described it
the single user system. A bunch of processes are competing for resources.
They can be all root, or all nobody, or containers with userns.
Neither user id nor caps can be such separator among processes for
the job of sharing bpf hook.
The tc/xdp/cgroup/tracing bpf attachment points need to be safely
shared among N root processes that are not cooperating with each other.
For tc, cgroup, tracing the problem is solved with bpf_link, since
they all allow multi prog.
XDP is the hardest, since it does single prog only.
That's what we're trying to solve with libdispatcher.
I think if it goes well it can become part of the kernel and kernel
will do multi prog XDP attach. And all hooks will be symmetrical.
But looking at the size of this thread and still lots of misunderstanding
about basic concept like bpf_link I'm not hopeful that libdispatcher
will ever become part of the kernel.
