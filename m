Return-Path: <netdev+bounces-11253-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8985E732418
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E9631C20F27
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686E0368;
	Fri, 16 Jun 2023 00:09:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A491366
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 00:09:31 +0000 (UTC)
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D914B2944
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 17:09:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-25e92536fb6so173460a91.1
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 17:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686874169; x=1689466169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92fQJzfB4RZzAA1tM9wgM08WjhNjZ7Gnu3A68q9wLec=;
        b=vRQoB3UxR6R6UA/EAnuvcOoF6xxSsHAzHPpG7X7Mff88JACQHrqekCKe9W6hY7DUkv
         Pr76NVwCPtKmiRMZhOI9yG0BH2lqb3irohAzmzrpo2/fWmTRA7jnAMO2X0Fs3Scwf0Pz
         Nkl5hsAvbcztqi6+Bg6u5ygLuHKHoNjlv9Qf61OZ+sfWp9icpv26b3DVWwnkuFb9GPoO
         HzlEBM9bEjAAL4UI6nCuPFwEBUSB0+7/bWwabQnMzELUU72OpN7V/UBT4KLGAekRHQ48
         JNCMxstpuvdKIsv28VWvKkbiuDzu5/ep8h1Hc0/aMJ/8v38qlHqU8j6nNcbiVeaOS0fN
         dNYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686874169; x=1689466169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92fQJzfB4RZzAA1tM9wgM08WjhNjZ7Gnu3A68q9wLec=;
        b=QULVU79qxmy8R1V2O6NSoG9/Bd3Up/e0Guf9ddt8hKMdPyKSjUcUpZ9/sjG0TKb8Eo
         8uwqZOJZd9LpofjdKJUtsFX0I2ES5E0dEqISEkV+liQJKxfKFZTVT2EYFTTDWbCsxvKu
         PHXndTLcxcljmD5Tp+r48He+YFv0md4mxtvyHU36eSNioiZevuvDfS9qfm2+cpmGr6KP
         +4qdHSET882mMRV2KgK1wz6JbqOlZZ2UXzVlaTLiBfhEFtXjibmYv/RQw8RKcPNS6FVB
         YeEFThEENHI+eDC8RpV2BV4o4FH7gSfFNXZ/3uM6lGvAmGeLqZXX6VPPiXa5edVYVntZ
         C/qw==
X-Gm-Message-State: AC+VfDwT4ySN4fABWLAsa8292AdfDfaHoDwBs1Etw1l2OsLmgfGP2L+B
	vHcRDsjRob4AjITehKU8/0dN+CxhjHY3jAbmH5Pl2yqlcqgdq2S2Op87Gg==
X-Google-Smtp-Source: ACHHUZ5fQN13BA5/fwv12kbeIqTw2YcXYX4lelUNUpQiuD32pWxko6O34viDMt0BO2mDgkgD7msMPUskZ/PRrp9bh0Q=
X-Received: by 2002:a17:90a:7bc4:b0:25b:f396:c3bc with SMTP id
 d4-20020a17090a7bc400b0025bf396c3bcmr229965pjl.48.1686874169214; Thu, 15 Jun
 2023 17:09:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
In-Reply-To: <87cz20xunt.fsf@toke.dk>
From: Stanislav Fomichev <sdf@google.com>
Date: Thu, 15 Jun 2023 17:09:17 -0700
Message-ID: <CAKH8qBuAUems8a7kKJPcFvarW2jy4qTf4sAM8oUC8UHj-gE=ug@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, willemb@google.com, dsahern@kernel.org, 
	magnus.karlsson@intel.com, bjorn@kernel.org, maciej.fijalkowski@intel.com, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 2:01=E2=80=AFPM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@kernel.org> wrote:
>
> Some immediate thoughts after glancing through this:
>
> > --- Use cases ---
> >
> > The goal of this series is to add two new standard-ish places
> > in the transmit path:
> >
> > 1. Right before the packet is transmitted (with access to TX
> >    descriptors)
> > 2. Right after the packet is actually transmitted and we've received th=
e
> >    completion (again, with access to TX completion descriptors)
> >
> > Accessing TX descriptors unlocks the following use-cases:
> >
> > - Setting device hints at TX: XDP/AF_XDP might use these new hooks to
> > use device offloads. The existing case implements TX timestamp.
> > - Observability: global per-netdev hooks can be used for tracing
> > the packets and exploring completion descriptors for all sorts of
> > device errors.
> >
> > Accessing TX descriptors also means that the hooks have to be called
> > from the drivers.
> >
> > The hooks are a light-weight alternative to XDP at egress and currently
> > don't provide any packet modification abilities. However, eventually,
> > can expose new kfuncs to operate on the packet (or, rather, the actual
> > descriptors; for performance sake).
>
> dynptr?
>
> > --- UAPI ---
> >
> > The hooks are implemented in a HID-BPF style. Meaning they don't
> > expose any UAPI and are implemented as tracing programs that call
> > a bunch of kfuncs. The attach/detach operation happen via BPF syscall
> > programs. The series expands device-bound infrastructure to tracing
> > programs.
>
> Not a fan of the "attach from BPF syscall program" thing. These are part
> of the XDP data path API, and I think we should expose them as proper
> bpf_link attachments from userspace with introspection etc. But I guess
> the bpf_mprog thing will give us that?
>
> > --- skb vs xdp ---
> >
> > The hooks operate on a new light-weight devtx_frame which contains:
> > - data
> > - len
> > - sinfo
> >
> > This should allow us to have a unified (from BPF POW) place at TX
> > and not be super-taxing (we need to copy 2 pointers + len to the stack
> > for each invocation).
>
> Not sure what I think about this one. At the very least I think we
> should expose xdp->data_meta as well. I'm not sure what the use case for
> accessing skbs is? If that *is* indeed useful, probably there will also
> end up being a use case for accessing the full skb?

I spent some time looking at data_meta story on AF_XDP TX and it
doesn't look like it's supported (at least in a general way).
You obviously get some data_meta when you do XDP_TX, but if you want
to pass something to the bpf prog when doing TX via the AF_XDP ring,
it gets complicated.
In zerocopy mode, we can probably use XDP_UMEM_UNALIGNED_CHUNK_FLAG
and pass something in the headroom.
If copy-mode, there is no support to do skb_metadata_set.

Probably makes sense to have something like tx_metalen on the xsk? And
skb_metadata_set it in copy more and skip it in zerocopy mode?
Or maybe I'm missing something?

