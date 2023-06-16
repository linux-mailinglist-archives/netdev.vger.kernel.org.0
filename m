Return-Path: <netdev+bounces-11322-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D6A7732998
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEC161C20F8E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76988AD22;
	Fri, 16 Jun 2023 08:13:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB776117;
	Fri, 16 Jun 2023 08:13:03 +0000 (UTC)
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7792D65;
	Fri, 16 Jun 2023 01:13:01 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-7576b53e75eso6401685a.1;
        Fri, 16 Jun 2023 01:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686903180; x=1689495180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WjfKnAI0ttilDP4K42t4giDScMrhWVefom03rhUM2R0=;
        b=mBP0FYTDyhdnJy0qkhjs3nkgmV56XA8RwvnlRTNO5jO88FDipNpfhX0EZOO+2KSwte
         ZdLxcvdkETe7NdJ0p+aQFkg3V6PSRv1oePVI4eRaUsJvQcXhvLBiC6xts6Uj9vyRHekc
         9M5B19+LRzcvhlGl+twydI/tIfBr4fW9J8br+P7Mh+vOwPcSR9Bdm7adMxzOVJFq2DMX
         xDYMkwrej51onuhe7CIbgYYIrrCjoOkUEUrzl805P5GTPyODKSwng5RPrAWyZ/LCCu9O
         XJRKS41FNwOeU1fR4m9sRHdEcYaoqxUTcW5k0s8PQB4k/sNpPUAxezP0GwKHubFqpZxu
         0eGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686903180; x=1689495180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WjfKnAI0ttilDP4K42t4giDScMrhWVefom03rhUM2R0=;
        b=Jx+iksD4o3FzND0BjHba12LnHOh1zXQ/Hj79hS8AwMUaqnHqAoM2YgFXx9QGlqeIj7
         nbo0A4YVaw6ccFN0btjW7SgE5GT3/PPwHfkftK46+3bT27W4kIV66kMMjHJVs0CxS9Fx
         +d/Q1moDKaV1EjrrCs6zMZvuhCQXLqTv3cEjjXrhGxA2K+j6V1B5OObVFyI4o3hYx9RX
         Bu6rMYVOPi3spnQrMtWcnqVFOh26lEah/2dWEeHfU7q9F0atlWiET5f4RIf90A35ok48
         B+GdwtNX0aCYpn5/g0JzoowwkYdQp+S7sj0y7EB2lw5zOuP/x0knvQ+aBNYCvccO/G4q
         lx9w==
X-Gm-Message-State: AC+VfDwaMXFMydCN4S5FiFyjN7YDNnwzUp2YelgszTxQ+EuKdDGMpSVb
	2gkggxzR23Ho9gEG5XNefmu7xTQkM6WalO7kVMSGNZ9m9n7GZA==
X-Google-Smtp-Source: ACHHUZ7W4jZbF855+BRWPKzFD6X5P5MoAQ4MoeweEO5Fp6uLF8VWVYno82b5vOcfbWs+tXv6sqEoRxOBEHutozttlE8=
X-Received: by 2002:a05:6214:29cc:b0:62d:fc81:44fc with SMTP id
 gh12-20020a05621429cc00b0062dfc8144fcmr1523046qvb.6.1686903180603; Fri, 16
 Jun 2023 01:13:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk> <CAKH8qBuAUems8a7kKJPcFvarW2jy4qTf4sAM8oUC8UHj-gE=ug@mail.gmail.com>
In-Reply-To: <CAKH8qBuAUems8a7kKJPcFvarW2jy4qTf4sAM8oUC8UHj-gE=ug@mail.gmail.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Fri, 16 Jun 2023 10:12:49 +0200
Message-ID: <CAJ8uoz2Bx3cd7braAZjZFNYfqX0JjJzSvr4RBN=j8CiH8Ld5-w@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
To: Stanislav Fomichev <sdf@google.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org, willemb@google.com, 
	dsahern@kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org, 
	maciej.fijalkowski@intel.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 16 Jun 2023 at 02:09, Stanislav Fomichev <sdf@google.com> wrote:
>
> On Mon, Jun 12, 2023 at 2:01=E2=80=AFPM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@kernel.org> wrote:
> >
> > Some immediate thoughts after glancing through this:
> >
> > > --- Use cases ---
> > >
> > > The goal of this series is to add two new standard-ish places
> > > in the transmit path:
> > >
> > > 1. Right before the packet is transmitted (with access to TX
> > >    descriptors)
> > > 2. Right after the packet is actually transmitted and we've received =
the
> > >    completion (again, with access to TX completion descriptors)
> > >
> > > Accessing TX descriptors unlocks the following use-cases:
> > >
> > > - Setting device hints at TX: XDP/AF_XDP might use these new hooks to
> > > use device offloads. The existing case implements TX timestamp.
> > > - Observability: global per-netdev hooks can be used for tracing
> > > the packets and exploring completion descriptors for all sorts of
> > > device errors.
> > >
> > > Accessing TX descriptors also means that the hooks have to be called
> > > from the drivers.
> > >
> > > The hooks are a light-weight alternative to XDP at egress and current=
ly
> > > don't provide any packet modification abilities. However, eventually,
> > > can expose new kfuncs to operate on the packet (or, rather, the actua=
l
> > > descriptors; for performance sake).
> >
> > dynptr?
> >
> > > --- UAPI ---
> > >
> > > The hooks are implemented in a HID-BPF style. Meaning they don't
> > > expose any UAPI and are implemented as tracing programs that call
> > > a bunch of kfuncs. The attach/detach operation happen via BPF syscall
> > > programs. The series expands device-bound infrastructure to tracing
> > > programs.
> >
> > Not a fan of the "attach from BPF syscall program" thing. These are par=
t
> > of the XDP data path API, and I think we should expose them as proper
> > bpf_link attachments from userspace with introspection etc. But I guess
> > the bpf_mprog thing will give us that?
> >
> > > --- skb vs xdp ---
> > >
> > > The hooks operate on a new light-weight devtx_frame which contains:
> > > - data
> > > - len
> > > - sinfo
> > >
> > > This should allow us to have a unified (from BPF POW) place at TX
> > > and not be super-taxing (we need to copy 2 pointers + len to the stac=
k
> > > for each invocation).
> >
> > Not sure what I think about this one. At the very least I think we
> > should expose xdp->data_meta as well. I'm not sure what the use case fo=
r
> > accessing skbs is? If that *is* indeed useful, probably there will also
> > end up being a use case for accessing the full skb?
>
> I spent some time looking at data_meta story on AF_XDP TX and it
> doesn't look like it's supported (at least in a general way).
> You obviously get some data_meta when you do XDP_TX, but if you want
> to pass something to the bpf prog when doing TX via the AF_XDP ring,
> it gets complicated.

When we designed this some 5 - 6 years ago, we thought that there
would be an XDP for egress action in the "nearish" future that could
be used to interpret the metadata field in front of the packet.
Basically, the user would load an XDP egress program that would define
the metadata layout by the operations it would perform on the metadata
area. But since XDP on egress has not happened, you are right, there
is definitely something missing to be able to use metadata on Tx. Or
could your proposed hook points be used for something like this?

> In zerocopy mode, we can probably use XDP_UMEM_UNALIGNED_CHUNK_FLAG
> and pass something in the headroom.

This feature is mainly used to allow for multiple packets on the same
chunk (to save space) and also to be able to have packets spanning two
chunks. Even in aligned mode, you can start a packet at an arbitrary
address in the chunk as long as the whole packet fits into the chunk.
So no problem having headroom in any of the modes.


> If copy-mode, there is no support to do skb_metadata_set.
>
> Probably makes sense to have something like tx_metalen on the xsk? And
> skb_metadata_set it in copy more and skip it in zerocopy mode?
> Or maybe I'm missing something?
>

