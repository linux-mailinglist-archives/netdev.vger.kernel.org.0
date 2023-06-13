Return-Path: <netdev+bounces-10529-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F5272EDC8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DF6728102A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542183D3A4;
	Tue, 13 Jun 2023 21:17:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A4C1ED43
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:17:44 +0000 (UTC)
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FC410FE
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:17:42 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-39ca0c2970aso3386213b6e.3
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686691062; x=1689283062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cwnfp5ZPpNmyFHOZC3eITBVEtscSEjfh+tASyswlz/g=;
        b=lG4jqWXy9mJIljJa9IMN8pGlHvinNFSz0f3Xx39KkZdEX9YnQLaOSTQTwADseaKiXW
         6anH82QvZMgoXKYOq5THZLHzpk+djQB/PJdtxY1UHO1/3AbojmRLFnAz3luLqoxOS4Ez
         jpOoepau8EYxOLK447RJHZMDKl9Isco+fcps6VrJPlnXEQdWLknLbOg7YhJnYUyOzt0O
         a7qQgzc5YK0Fx3mMg+3SHOEQdcvKC0mSIB9tLaWFxQzw/gYpSwOW5mxeW0nwP+Yi7G6K
         RxyJHfiOjgTE3eN4dKfD8+YuO74WfqAPBwU3O6hHudnP8oun2m7cPaMkPjA8Q5oSqNgn
         tMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686691062; x=1689283062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cwnfp5ZPpNmyFHOZC3eITBVEtscSEjfh+tASyswlz/g=;
        b=eCmi4B9afTOAexUsdpdasaohPecoTGmFyOBtET8ww2vAlr5i+ogMg96LZrA+XXQd/K
         IUXxguOIrBEuXUGXG5gbdxW35DV+WLjvi/CH5pWNj9FBZuxxdxdwyQ+ajLj7fLhOmgZP
         Coj7lGPbIW3zg8Xt4ysT4PKJHowyE6qqCFL9kVrvAXNg2qLXVOgSRN1qf2BJpInHKMv2
         HAAHdun6MLrsnhpHygA4Rfsj72j/cIoVy40J/DZtjCm2id+2tu4PAn3evrddoIRqJrpo
         zxtnjF+6ckbo1OfHWvwUrQ/eCJq7fSg/tx8Ol3AT/m7k8c3KrNkPmy24FjI5WI+wGXCR
         3oxQ==
X-Gm-Message-State: AC+VfDyAIChOgZg9vW9A0x4Z20HY0Qz1jl/80AQIAI/hFWOm3RiD7oCQ
	IRuF7aJjhgsVt6/vNnvUlFliIT0naVntwns1uo9JVQ==
X-Google-Smtp-Source: ACHHUZ4/WBPVxwO2QpvIurSTng7sFf4b38jR/VeKOXl476AglJ0NFXkdqrU/hBJ5YfuT4A6VGOqiVeUCd7AON6dqudc=
X-Received: by 2002:a05:6808:2211:b0:39c:7e0a:6401 with SMTP id
 bd17-20020a056808221100b0039c7e0a6401mr10661514oib.19.1686691061733; Tue, 13
 Jun 2023 14:17:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
 <ZIiaHXr9M0LGQ0Ht@google.com> <877cs7xovi.fsf@toke.dk> <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
 <87v8frw546.fsf@toke.dk>
In-Reply-To: <87v8frw546.fsf@toke.dk>
From: Stanislav Fomichev <sdf@google.com>
Date: Tue, 13 Jun 2023 14:17:29 -0700
Message-ID: <CAKH8qBtsvsWvO3Avsqb2PbvZgh5GDMxe2fok-jS4DrJM=x2Row@mail.gmail.com>
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
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:10=E2=80=AFPM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@kernel.org> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > On Tue, Jun 13, 2023 at 10:18=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgens=
en <toke@kernel.org> wrote:
> >>
> >> Stanislav Fomichev <sdf@google.com> writes:
> >>
> >> > On 06/12, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> >> Some immediate thoughts after glancing through this:
> >> >>
> >> >> > --- Use cases ---
> >> >> >
> >> >> > The goal of this series is to add two new standard-ish places
> >> >> > in the transmit path:
> >> >> >
> >> >> > 1. Right before the packet is transmitted (with access to TX
> >> >> >    descriptors)
> >> >> > 2. Right after the packet is actually transmitted and we've recei=
ved the
> >> >> >    completion (again, with access to TX completion descriptors)
> >> >> >
> >> >> > Accessing TX descriptors unlocks the following use-cases:
> >> >> >
> >> >> > - Setting device hints at TX: XDP/AF_XDP might use these new hook=
s to
> >> >> > use device offloads. The existing case implements TX timestamp.
> >> >> > - Observability: global per-netdev hooks can be used for tracing
> >> >> > the packets and exploring completion descriptors for all sorts of
> >> >> > device errors.
> >> >> >
> >> >> > Accessing TX descriptors also means that the hooks have to be cal=
led
> >> >> > from the drivers.
> >> >> >
> >> >> > The hooks are a light-weight alternative to XDP at egress and cur=
rently
> >> >> > don't provide any packet modification abilities. However, eventua=
lly,
> >> >> > can expose new kfuncs to operate on the packet (or, rather, the a=
ctual
> >> >> > descriptors; for performance sake).
> >> >>
> >> >> dynptr?
> >> >
> >> > Haven't considered, let me explore, but not sure what it buys us
> >> > here?
> >>
> >> API consistency, certainly. Possibly also performance, if using the
> >> slice thing that gets you a direct pointer to the pkt data? Not sure
> >> about that, though, haven't done extensive benchmarking of dynptr yet.=
..
> >
> > Same. Let's keep it on the table, I'll try to explore. I was just
> > thinking that having less abstraction here might be better
> > performance-wise.
>
> Sure, let's evaluate this once we have performance numbers.
>
> >> >> > --- UAPI ---
> >> >> >
> >> >> > The hooks are implemented in a HID-BPF style. Meaning they don't
> >> >> > expose any UAPI and are implemented as tracing programs that call
> >> >> > a bunch of kfuncs. The attach/detach operation happen via BPF sys=
call
> >> >> > programs. The series expands device-bound infrastructure to traci=
ng
> >> >> > programs.
> >> >>
> >> >> Not a fan of the "attach from BPF syscall program" thing. These are=
 part
> >> >> of the XDP data path API, and I think we should expose them as prop=
er
> >> >> bpf_link attachments from userspace with introspection etc. But I g=
uess
> >> >> the bpf_mprog thing will give us that?
> >> >
> >> > bpf_mprog will just make those attach kfuncs return the link fd. The
> >> > syscall program will still stay :-(
> >>
> >> Why does the attachment have to be done this way, exactly? Couldn't we
> >> just use the regular bpf_link attachment from userspace? AFAICT it's n=
ot
> >> really piggy-backing on the function override thing anyway when the
> >> attachment is per-dev? Or am I misunderstanding how all this works?
> >
> > It's UAPI vs non-UAPI. I'm assuming kfunc makes it non-UAPI and gives
> > us an opportunity to fix things.
> > We can do it via a regular syscall path if there is a consensus.
>
> Yeah, the API exposed to the BPF program is kfunc-based in any case. If
> we were to at some point conclude that this whole thing was not useful
> at all and deprecate it, it doesn't seem to me that it makes much
> difference whether that means "you can no longer create a link
> attachment of this type via BPF_LINK_CREATE" or "you can no longer
> create a link attachment of this type via BPF_PROG_RUN of a syscall type
> program" doesn't really seem like a significant detail to me...

In this case, why do you prefer it to go via regular syscall? Seems
like we can avoid a bunch of boileplate syscall work with a kfunc that
does the attachment?
We might as well abstract it at, say, libbpf layer which would
generate/load this small bpf program to call a kfunc.

> >> >> > --- skb vs xdp ---
> >> >> >
> >> >> > The hooks operate on a new light-weight devtx_frame which contain=
s:
> >> >> > - data
> >> >> > - len
> >> >> > - sinfo
> >> >> >
> >> >> > This should allow us to have a unified (from BPF POW) place at TX
> >> >> > and not be super-taxing (we need to copy 2 pointers + len to the =
stack
> >> >> > for each invocation).
> >> >>
> >> >> Not sure what I think about this one. At the very least I think we
> >> >> should expose xdp->data_meta as well. I'm not sure what the use cas=
e for
> >> >> accessing skbs is? If that *is* indeed useful, probably there will =
also
> >> >> end up being a use case for accessing the full skb?
> >> >
> >> > skb_shared_info has meta_len, buf afaik, xdp doesn't use it. Maybe I
> >> > a good opportunity to unify? Or probably won't work because if
> >> > xdf_frame doesn't have frags, it won't have sinfo?
> >>
> >> No, it won't. But why do we need this unification between the skb and
> >> xdp paths in the first place? Doesn't the skb path already have suppor=
t
> >> for these things? Seems like we could just stick to making this xdp-on=
ly
> >> and keeping xdp_frame as the ctx argument?
> >
> > For skb path, I'm assuming we can read sinfo->meta_len; it feels nice
> > to make it work for both cases?
> > We can always export metadata len via some kfunc, sure.
>
> I wasn't referring to the metadata field specifically when talking about
> the skb path. I'm wondering why we need these hooks to work for the skb
> path at all? :)

Aaah. I think John wanted them to trigger for skb path, so I'm trying
to explore whether having both makes sense.
But also, if we go purely xdp_frame, what about af_xdp in copy mode?
That's still skb-driven, right?
Not sure this skb vs xdp is a clear cut :-/

