Return-Path: <netdev+bounces-10480-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E7E072EB1F
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9A0A1C2040E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF4C1ED35;
	Tue, 13 Jun 2023 18:39:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0C41ED29
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 18:39:16 +0000 (UTC)
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E4C1BF0
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:39:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-25bbcf3c0acso1969740a91.2
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686681554; x=1689273554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QT+fQzSbsB3hqlxQq4ezOUZ9kAZ8c91ieAT3ZrWtoFA=;
        b=fGJFBgzP7m78qyQUQLVEwT1ooky9W43a0imOgCl47ZWm1NoRo5i18nC+6tisau2W6W
         b7dsM70tAYWw9NnIl3Q0XlFdISCnBWnW2UCvRXGVb0wdfOMuYcBFU9uj29S9KDXyRLTA
         LCI+oogJ76epuvoPj196jnEnDyjvXrZhAm2aJ+ebjYQ2xnRO8SXpOA0+eAXJN/93M5KI
         nJdMTmjT3KjutvOU1QsY4LHnsXhK+jjwHg2WMFeA5MNoGpINuzIJ8Xn1acUbHx0aysbz
         Wo5pcLkKCLOiwwUeLhTULT7OatG22R3bQwgsSEevY5EM4FJ7G6nl3I7K07qAj1mlzyMa
         SElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686681554; x=1689273554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QT+fQzSbsB3hqlxQq4ezOUZ9kAZ8c91ieAT3ZrWtoFA=;
        b=icMlCHe7PDbKegE/a7wrjit/6IEw47c0Mjlofl2BCj4x0//WYQNFL3JMsjMdew/+1n
         w6WSOVkpUMzO1V5Z+sCd7xTBYfy06+Qh7eO+4mebU9xNSa3c1+mKeBRPuO3JoTaIsliD
         h0rJzVpQTC7PjHjt8Lo26iDiaG1HK1JqDsSLWCNCSK/67VbQReoCq40Au4DeVWtsxths
         DKiuYaK6btaJu5Tv5k5yUT8G+FU512SMT4gLtbzope9d2o8KNEJJZ/69qDrbyg8xN793
         82McQKhps48V6n9ZM9p0ESL5t6V+bhHixZ7bud6BX9crzM4ucv3Jbk6DiNM+UprTrbWK
         cGGw==
X-Gm-Message-State: AC+VfDw/xmZ6VdNtyCsxjmAufequy8t6MdP/w3ZOz12iQgI3l517zsZp
	VgEpAXdFK8Ts0BZF47esJuRHEXEw4JjaiMQEr5Yp4A==
X-Google-Smtp-Source: ACHHUZ6UzjLxyWPiRJjnbgASTJNqy2M+mr/+5MHLW4EvJchmkA3n8OlyNncmExxmrOJE9ZRcG6sHIhK+zROeBbHCGWI=
X-Received: by 2002:a17:90a:1909:b0:253:37a9:178 with SMTP id
 9-20020a17090a190900b0025337a90178mr10681963pjg.45.1686681553846; Tue, 13 Jun
 2023 11:39:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
 <ZIiaHXr9M0LGQ0Ht@google.com> <877cs7xovi.fsf@toke.dk>
In-Reply-To: <877cs7xovi.fsf@toke.dk>
From: Stanislav Fomichev <sdf@google.com>
Date: Tue, 13 Jun 2023 11:39:02 -0700
Message-ID: <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
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

On Tue, Jun 13, 2023 at 10:18=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@kernel.org> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On 06/12, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Some immediate thoughts after glancing through this:
> >>
> >> > --- Use cases ---
> >> >
> >> > The goal of this series is to add two new standard-ish places
> >> > in the transmit path:
> >> >
> >> > 1. Right before the packet is transmitted (with access to TX
> >> >    descriptors)
> >> > 2. Right after the packet is actually transmitted and we've received=
 the
> >> >    completion (again, with access to TX completion descriptors)
> >> >
> >> > Accessing TX descriptors unlocks the following use-cases:
> >> >
> >> > - Setting device hints at TX: XDP/AF_XDP might use these new hooks t=
o
> >> > use device offloads. The existing case implements TX timestamp.
> >> > - Observability: global per-netdev hooks can be used for tracing
> >> > the packets and exploring completion descriptors for all sorts of
> >> > device errors.
> >> >
> >> > Accessing TX descriptors also means that the hooks have to be called
> >> > from the drivers.
> >> >
> >> > The hooks are a light-weight alternative to XDP at egress and curren=
tly
> >> > don't provide any packet modification abilities. However, eventually=
,
> >> > can expose new kfuncs to operate on the packet (or, rather, the actu=
al
> >> > descriptors; for performance sake).
> >>
> >> dynptr?
> >
> > Haven't considered, let me explore, but not sure what it buys us
> > here?
>
> API consistency, certainly. Possibly also performance, if using the
> slice thing that gets you a direct pointer to the pkt data? Not sure
> about that, though, haven't done extensive benchmarking of dynptr yet...

Same. Let's keep it on the table, I'll try to explore. I was just
thinking that having less abstraction here might be better
performance-wise.

> >> > --- UAPI ---
> >> >
> >> > The hooks are implemented in a HID-BPF style. Meaning they don't
> >> > expose any UAPI and are implemented as tracing programs that call
> >> > a bunch of kfuncs. The attach/detach operation happen via BPF syscal=
l
> >> > programs. The series expands device-bound infrastructure to tracing
> >> > programs.
> >>
> >> Not a fan of the "attach from BPF syscall program" thing. These are pa=
rt
> >> of the XDP data path API, and I think we should expose them as proper
> >> bpf_link attachments from userspace with introspection etc. But I gues=
s
> >> the bpf_mprog thing will give us that?
> >
> > bpf_mprog will just make those attach kfuncs return the link fd. The
> > syscall program will still stay :-(
>
> Why does the attachment have to be done this way, exactly? Couldn't we
> just use the regular bpf_link attachment from userspace? AFAICT it's not
> really piggy-backing on the function override thing anyway when the
> attachment is per-dev? Or am I misunderstanding how all this works?

It's UAPI vs non-UAPI. I'm assuming kfunc makes it non-UAPI and gives
us an opportunity to fix things.
We can do it via a regular syscall path if there is a consensus.

> >> > --- skb vs xdp ---
> >> >
> >> > The hooks operate on a new light-weight devtx_frame which contains:
> >> > - data
> >> > - len
> >> > - sinfo
> >> >
> >> > This should allow us to have a unified (from BPF POW) place at TX
> >> > and not be super-taxing (we need to copy 2 pointers + len to the sta=
ck
> >> > for each invocation).
> >>
> >> Not sure what I think about this one. At the very least I think we
> >> should expose xdp->data_meta as well. I'm not sure what the use case f=
or
> >> accessing skbs is? If that *is* indeed useful, probably there will als=
o
> >> end up being a use case for accessing the full skb?
> >
> > skb_shared_info has meta_len, buf afaik, xdp doesn't use it. Maybe I
> > a good opportunity to unify? Or probably won't work because if
> > xdf_frame doesn't have frags, it won't have sinfo?
>
> No, it won't. But why do we need this unification between the skb and
> xdp paths in the first place? Doesn't the skb path already have support
> for these things? Seems like we could just stick to making this xdp-only
> and keeping xdp_frame as the ctx argument?

For skb path, I'm assuming we can read sinfo->meta_len; it feels nice
to make it work for both cases?
We can always export metadata len via some kfunc, sure.

> >> > --- Multiprog attachment ---
> >> >
> >> > Currently, attach/detach don't expose links and don't support multip=
le
> >> > programs. I'm planning to use Daniel's bpf_mprog once it lands.
> >> >
> >> > --- TODO ---
> >> >
> >> > Things that I'm planning to do for the non-RFC series:
> >> > - have some real device support to verify xdp_hw_metadata works
> >>
> >> Would be good to see some performance numbers as well :)
> >
> > +1 :-)
> >
> >> > - freplace
> >> > - Documentation/networking/xdp-rx-metadata.rst - like documentation
> >> >
> >> > --- CC ---
> >> >
> >> > CC'ing people only on the cover letter. Hopefully can find the rest =
via
> >> > lore.
> >>
> >> Well, I found it there, even though I was apparently left off the Cc
> >> list :(
> >>
> >> -Toke
> >
> > Sure, I'll CC you explicitly next time! But I know you diligently follo=
w bpf
> > list, so decided to explicitly cc mostly netdev folks that might miss
> > it otherwise.
>
> Haha, fair point! And no big deal, I did obviously see it. I was just
> feeling a bit left out, that's all ;)
>
> -Toke

