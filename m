Return-Path: <netdev+bounces-11524-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E28D733775
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDB492817CA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 509201D2A4;
	Fri, 16 Jun 2023 17:32:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376271C779
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 17:32:20 +0000 (UTC)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EF61FF7
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:32:12 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-543cc9541feso649392a12.2
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686936732; x=1689528732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPNdCKJ+trkPSt2qe+X8tZYGTr7hvKkW/jt6Owxsv0A=;
        b=AjsqkQdec5f5zbNbtPIolc9V9LQK2tLmCzqZ5b2Kd6Nrsgz39P3d7nTQXfsieTLLL/
         EdqBhSuPZVnCKUKmEBl7IrdSmiT1foONuG+QHtSuLNbbdeoHxOqRfogXaIwgcwhf4lvN
         AIxLvJL8jzJ8jKp7CngXFVIn7wnCcq4kKwD2LChYvo5mg9lWEcnmj2k5ISbh1YXx+3uZ
         QnCAezCTP4NTD9wPo/OVS+fU6ySJ9m5ZiPTm70EuppruLbTZV7r9xjA0EKUBb0S3EDsE
         KxP1cnIqNibWoP9KLPesPwh0r+2D/DkOnbQ5uqWuDx8nUyWI2+urm2gwajVKzCk2GC6b
         CBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686936732; x=1689528732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bPNdCKJ+trkPSt2qe+X8tZYGTr7hvKkW/jt6Owxsv0A=;
        b=J1vXA0d9YYinKhQuW7ma7tbT2jCbIXqQRPlVQKJREZZwhvW1m9P0amUy+Dyg3vPoEq
         zdW2MpfDCCA9fnTT/vb7zdLDHUUaDNuG/vPIULmykPoo1geD5vfC94LN2n46lHxvn9o+
         jQb8mahr1RbcwzgRWhk1XOCdfL0uOyAQn9Wt6GfceOUAHUKD6ldTyEZKkHC+OIkRxOyX
         8NmiaRx53uygn3WZVFqMJSViXUXHtwJq8bvFnVJTRIWboGZrBbkTPuVZCrlar9cEb028
         +A1RH21j4FoKAhstV3HgxDhg91z3N+U9JO3NafCP5GbLuhLciCwDK3JspXqqIkFJCcc4
         25Qw==
X-Gm-Message-State: AC+VfDy6V/6Ln8ZdAy0ZbsR7fCDTeHa1GR9bquLEHgCcADL+AczWnbGd
	a9YvT7aHiQhkwZcZUTUzJosOyX5yM6XSZe0kPXb4mA==
X-Google-Smtp-Source: ACHHUZ7uYPPfa+dWjP/WNfeBI2QjSTQLGhfRQrwLJhB/jBv91WUYl8CKbKR66axu0KgBPCTpi8g/7pIWJsb//drqm5M=
X-Received: by 2002:a17:90a:1908:b0:256:5dec:50ed with SMTP id
 8-20020a17090a190800b002565dec50edmr2154818pjg.7.1686936732156; Fri, 16 Jun
 2023 10:32:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
 <CAKH8qBuAUems8a7kKJPcFvarW2jy4qTf4sAM8oUC8UHj-gE=ug@mail.gmail.com> <CAJ8uoz2Bx3cd7braAZjZFNYfqX0JjJzSvr4RBN=j8CiH8Ld5-w@mail.gmail.com>
In-Reply-To: <CAJ8uoz2Bx3cd7braAZjZFNYfqX0JjJzSvr4RBN=j8CiH8Ld5-w@mail.gmail.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Fri, 16 Jun 2023 10:32:00 -0700
Message-ID: <CAKH8qBscx=SWSCL_WTMPyNPu=63OzFJcenCySds2KoV1agWW9w@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org, willemb@google.com, 
	dsahern@kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org, 
	maciej.fijalkowski@intel.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 1:13=E2=80=AFAM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Fri, 16 Jun 2023 at 02:09, Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Mon, Jun 12, 2023 at 2:01=E2=80=AFPM Toke H=C3=B8iland-J=C3=B8rgense=
n <toke@kernel.org> wrote:
> > >
> > > Some immediate thoughts after glancing through this:
> > >
> > > > --- Use cases ---
> > > >
> > > > The goal of this series is to add two new standard-ish places
> > > > in the transmit path:
> > > >
> > > > 1. Right before the packet is transmitted (with access to TX
> > > >    descriptors)
> > > > 2. Right after the packet is actually transmitted and we've receive=
d the
> > > >    completion (again, with access to TX completion descriptors)
> > > >
> > > > Accessing TX descriptors unlocks the following use-cases:
> > > >
> > > > - Setting device hints at TX: XDP/AF_XDP might use these new hooks =
to
> > > > use device offloads. The existing case implements TX timestamp.
> > > > - Observability: global per-netdev hooks can be used for tracing
> > > > the packets and exploring completion descriptors for all sorts of
> > > > device errors.
> > > >
> > > > Accessing TX descriptors also means that the hooks have to be calle=
d
> > > > from the drivers.
> > > >
> > > > The hooks are a light-weight alternative to XDP at egress and curre=
ntly
> > > > don't provide any packet modification abilities. However, eventuall=
y,
> > > > can expose new kfuncs to operate on the packet (or, rather, the act=
ual
> > > > descriptors; for performance sake).
> > >
> > > dynptr?
> > >
> > > > --- UAPI ---
> > > >
> > > > The hooks are implemented in a HID-BPF style. Meaning they don't
> > > > expose any UAPI and are implemented as tracing programs that call
> > > > a bunch of kfuncs. The attach/detach operation happen via BPF sysca=
ll
> > > > programs. The series expands device-bound infrastructure to tracing
> > > > programs.
> > >
> > > Not a fan of the "attach from BPF syscall program" thing. These are p=
art
> > > of the XDP data path API, and I think we should expose them as proper
> > > bpf_link attachments from userspace with introspection etc. But I gue=
ss
> > > the bpf_mprog thing will give us that?
> > >
> > > > --- skb vs xdp ---
> > > >
> > > > The hooks operate on a new light-weight devtx_frame which contains:
> > > > - data
> > > > - len
> > > > - sinfo
> > > >
> > > > This should allow us to have a unified (from BPF POW) place at TX
> > > > and not be super-taxing (we need to copy 2 pointers + len to the st=
ack
> > > > for each invocation).
> > >
> > > Not sure what I think about this one. At the very least I think we
> > > should expose xdp->data_meta as well. I'm not sure what the use case =
for
> > > accessing skbs is? If that *is* indeed useful, probably there will al=
so
> > > end up being a use case for accessing the full skb?
> >
> > I spent some time looking at data_meta story on AF_XDP TX and it
> > doesn't look like it's supported (at least in a general way).
> > You obviously get some data_meta when you do XDP_TX, but if you want
> > to pass something to the bpf prog when doing TX via the AF_XDP ring,
> > it gets complicated.
>
> When we designed this some 5 - 6 years ago, we thought that there
> would be an XDP for egress action in the "nearish" future that could
> be used to interpret the metadata field in front of the packet.
> Basically, the user would load an XDP egress program that would define
> the metadata layout by the operations it would perform on the metadata
> area. But since XDP on egress has not happened, you are right, there
> is definitely something missing to be able to use metadata on Tx. Or
> could your proposed hook points be used for something like this?

Thanks for the context!
Yes, the proposal is to use these new tx hooks to read out af_xdp
metadata and apply it to the packet via a bunch of tbd kfuncs.
AF_XDP and BPF programs would have to have a contract about the
metadata layout (same as we have on rx).

> > In zerocopy mode, we can probably use XDP_UMEM_UNALIGNED_CHUNK_FLAG
> > and pass something in the headroom.
>
> This feature is mainly used to allow for multiple packets on the same
> chunk (to save space) and also to be able to have packets spanning two
> chunks. Even in aligned mode, you can start a packet at an arbitrary
> address in the chunk as long as the whole packet fits into the chunk.
> So no problem having headroom in any of the modes.

But if I put it into the headroom it will only be passed down to the
driver in zero-copy mode, right?
If I do tx_desc->addr =3D packet_start, no medata (that goes prior to
packet_start) gets copied into skb in the copy mode (it seems).
Or do you suggest that the interface should be tx_desc->addr =3D
metadata_start and the bpf program should call the equivalent of
bpf_xdp_adjust_head to consume this metadata?

