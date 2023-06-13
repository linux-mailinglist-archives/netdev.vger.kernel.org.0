Return-Path: <netdev+bounces-10444-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F027272E88B
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A871A28123E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8AC4209B9;
	Tue, 13 Jun 2023 16:32:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E4E15AF7
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:32:33 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B97B10F3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:32:32 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-653a5de0478so3474553b3a.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686673952; x=1689265952;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y//5lnyaAT2DGrXf05YFo8avhdpiNf6tF65xRMg/pVQ=;
        b=JM2nn4s4FZqXC8kVBSJELKOYchTl9FEyIYGo0EFOFhJyesKOnJHuqV1LIO59VoJt2r
         8SpVDm0jmuFtmI5yw/D78PmFTTaTvIkndpjK6u2tDqDTpb5O/S/GhyMyf1/aziE9GNRx
         SCxQddNKnW0n3It4kyFP3hSuF2yhZb9gBVDg1HTI/otG9lbVZhubdIZkeyeSX+HGyvsL
         +0OCYMaSuMCI/65HUO8GiugwD/vwq+a9Gbml/jMzuRbsCWLpTIo8i8sqpm91pfCOwNjv
         Njxh74KSjuxhvBPBkRBw7MZc3DCk2caF52XD7LVb72d6uDTFNDMbDcEqzhQMIN4+G8Vy
         O33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686673952; x=1689265952;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y//5lnyaAT2DGrXf05YFo8avhdpiNf6tF65xRMg/pVQ=;
        b=P+eYRRhtcbhO424o971yxHlwxo5zA/f3lwpKcjhiYZ1Ooam/qMQmzBYPf/EC5iJqbd
         DdgVnyiM8HRIIRJVkzlQ6w9s74cwbU0Vd6dYkKSDfy94dKYQbU4Je+pzNKzgs+pi/xhR
         RI9U5Olt91F3dG7ooit5xfPMvutHRyFn8/ObWhVuubjCYOBVqBwMMMrItGOD/SfhBMeH
         NxPHV4D1RAY3YOU5wowv2V6GhyrTgM+th+q8FBaXmpBbULMQIDhY2UKEjl8IcyO4YKfI
         pWy6Nvk3nvccTvc/5rSshShw7krZImcoX9M9ncdzvNHB7yDeR2Oz4lMy5VIvJqgQvK5m
         PVng==
X-Gm-Message-State: AC+VfDyv7Qm99dWGImlJ25apRA+yBVFZGl2xoy5Q0lmzbpBg7hfXpKVJ
	4ZzxcNKPfbXMcdsG1eWKX1Oi2lQ=
X-Google-Smtp-Source: ACHHUZ4rhdTx+VU1jqVfBA6p3i2B5m0EL3yvBv6UDydWBcYrDMDcWBXKlD18ogYMHlKlImyh4KUx6Mk=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:3a22:b0:665:bf0e:6399 with SMTP id
 fj34-20020a056a003a2200b00665bf0e6399mr939224pfb.3.1686673951676; Tue, 13 Jun
 2023 09:32:31 -0700 (PDT)
Date: Tue, 13 Jun 2023 09:32:29 -0700
In-Reply-To: <87cz20xunt.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
Message-ID: <ZIiaHXr9M0LGQ0Ht@google.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
From: Stanislav Fomichev <sdf@google.com>
To: "Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?=" <toke@kernel.org>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, willemb@google.com, dsahern@kernel.org, 
	magnus.karlsson@intel.com, bjorn@kernel.org, maciej.fijalkowski@intel.com, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/12, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Some immediate thoughts after glancing through this:
>=20
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
>=20
> dynptr?

Haven't considered, let me explore, but not sure what it buys us
here?

> > --- UAPI ---
> >
> > The hooks are implemented in a HID-BPF style. Meaning they don't
> > expose any UAPI and are implemented as tracing programs that call
> > a bunch of kfuncs. The attach/detach operation happen via BPF syscall
> > programs. The series expands device-bound infrastructure to tracing
> > programs.
>=20
> Not a fan of the "attach from BPF syscall program" thing. These are part
> of the XDP data path API, and I think we should expose them as proper
> bpf_link attachments from userspace with introspection etc. But I guess
> the bpf_mprog thing will give us that?

bpf_mprog will just make those attach kfuncs return the link fd. The
syscall program will still stay :-(

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
>=20
> Not sure what I think about this one. At the very least I think we
> should expose xdp->data_meta as well. I'm not sure what the use case for
> accessing skbs is? If that *is* indeed useful, probably there will also
> end up being a use case for accessing the full skb?

skb_shared_info has meta_len, buf afaik, xdp doesn't use it. Maybe I
a good opportunity to unify? Or probably won't work because if
xdf_frame doesn't have frags, it won't have sinfo?

> > --- Multiprog attachment ---
> >
> > Currently, attach/detach don't expose links and don't support multiple
> > programs. I'm planning to use Daniel's bpf_mprog once it lands.
> >
> > --- TODO ---
> >
> > Things that I'm planning to do for the non-RFC series:
> > - have some real device support to verify xdp_hw_metadata works
>=20
> Would be good to see some performance numbers as well :)

+1 :-)

> > - freplace
> > - Documentation/networking/xdp-rx-metadata.rst - like documentation
> >
> > --- CC ---
> >
> > CC'ing people only on the cover letter. Hopefully can find the rest via
> > lore.
>=20
> Well, I found it there, even though I was apparently left off the Cc
> list :(
>=20
> -Toke

Sure, I'll CC you explicitly next time! But I know you diligently follow bp=
f
list, so decided to explicitly cc mostly netdev folks that might miss
it otherwise.

