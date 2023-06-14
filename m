Return-Path: <netdev+bounces-10696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C9672FDB7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBB6D1C20CF4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEBFF8C12;
	Wed, 14 Jun 2023 12:00:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA40E8BF0;
	Wed, 14 Jun 2023 12:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D01C433C8;
	Wed, 14 Jun 2023 12:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686744001;
	bh=LoiUr0uaRsxJzM8cKaoy60Y9Kl407w7j8YRTKBB3PNw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IcEwk0Majrvg8ASspBOSZfyC24I+nob4cEzYOBg/PguNe+5K+BrsOrREZLD7xBOxU
	 DpuumrODe6NSQp7RiVCZ0RWbCBjPbDvTxio3G+GHS7CfnWssCSotHiVv4TFIVq8F4L
	 qHt8i1KpagVvQIT8wv6bqadH+iOL4BYKrsKEmrwzTy/knznhknEEVdez6PLrpFI7/O
	 wCvKVpNL5Tl/FNHbNMyZCBQYFcUBmfennFsddQrgwTNH6x03xKdscsSFBWwFb/c7CJ
	 iXW7wzGo1wea0pGkw5Y2Bq/LWdI/u6PSKRtjkQle+W6LySsYLDzZ/Se9wk/FlZyEx+
	 rE9wcNyL14zAg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 82638BBEB5E; Wed, 14 Jun 2023 13:59:57 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Stanislav Fomichev
 <sdf@google.com>
Cc: bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP
 Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Jiri Olsa
 <jolsa@kernel.org>, Willem de Bruijn <willemb@google.com>, David Ahern
 <dsahern@kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>,
 =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, "Fijalkowski, Maciej"
 <maciej.fijalkowski@intel.com>, Network Development
 <netdev@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
In-Reply-To: <CAADnVQ+CCOw9_LbCAaFz0593eydKNb7RxnGr6_FatUOKmvPmBg@mail.gmail.com>
References: <20230612172307.3923165-1-sdf@google.com>
 <87cz20xunt.fsf@toke.dk> <ZIiaHXr9M0LGQ0Ht@google.com>
 <877cs7xovi.fsf@toke.dk>
 <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
 <87v8frw546.fsf@toke.dk>
 <CAKH8qBtsvsWvO3Avsqb2PbvZgh5GDMxe2fok-jS4DrJM=x2Row@mail.gmail.com>
 <CAADnVQKFmXAQDYVZxjvH8qbxk+3M2COGbfmtd=w8Nxvf9=DaeA@mail.gmail.com>
 <CAKH8qBvAMKtfrZ1jdwVS2pF161UdeXPSpY4HSzKYGTYNTupmTg@mail.gmail.com>
 <CAADnVQ+CCOw9_LbCAaFz0593eydKNb7RxnGr6_FatUOKmvPmBg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 14 Jun 2023 13:59:57 +0200
Message-ID: <877cs6l0ea.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Jun 13, 2023 at 4:16=E2=80=AFPM Stanislav Fomichev <sdf@google.co=
m> wrote:
>>
>> On Tue, Jun 13, 2023 at 3:32=E2=80=AFPM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>> >
>> > On Tue, Jun 13, 2023 at 2:17=E2=80=AFPM Stanislav Fomichev <sdf@google=
.com> wrote:
>> > >
>> > > > >> >> > --- UAPI ---
>> > > > >> >> >
>> > > > >> >> > The hooks are implemented in a HID-BPF style. Meaning they=
 don't
>> > > > >> >> > expose any UAPI and are implemented as tracing programs th=
at call
>> > > > >> >> > a bunch of kfuncs. The attach/detach operation happen via =
BPF syscall
>> > > > >> >> > programs. The series expands device-bound infrastructure t=
o tracing
>> > > > >> >> > programs.
>> > > > >> >>
>> > > > >> >> Not a fan of the "attach from BPF syscall program" thing. Th=
ese are part
>> > > > >> >> of the XDP data path API, and I think we should expose them =
as proper
>> > > > >> >> bpf_link attachments from userspace with introspection etc. =
But I guess
>> > > > >> >> the bpf_mprog thing will give us that?
>> > > > >> >
>> > > > >> > bpf_mprog will just make those attach kfuncs return the link =
fd. The
>> > > > >> > syscall program will still stay :-(
>> > > > >>
>> > > > >> Why does the attachment have to be done this way, exactly? Coul=
dn't we
>> > > > >> just use the regular bpf_link attachment from userspace? AFAICT=
 it's not
>> > > > >> really piggy-backing on the function override thing anyway when=
 the
>> > > > >> attachment is per-dev? Or am I misunderstanding how all this wo=
rks?
>> > > > >
>> > > > > It's UAPI vs non-UAPI. I'm assuming kfunc makes it non-UAPI and =
gives
>> > > > > us an opportunity to fix things.
>> > > > > We can do it via a regular syscall path if there is a consensus.
>> > > >
>> > > > Yeah, the API exposed to the BPF program is kfunc-based in any cas=
e. If
>> > > > we were to at some point conclude that this whole thing was not us=
eful
>> > > > at all and deprecate it, it doesn't seem to me that it makes much
>> > > > difference whether that means "you can no longer create a link
>> > > > attachment of this type via BPF_LINK_CREATE" or "you can no longer
>> > > > create a link attachment of this type via BPF_PROG_RUN of a syscal=
l type
>> > > > program" doesn't really seem like a significant detail to me...
>> > >
>> > > In this case, why do you prefer it to go via regular syscall? Seems
>> > > like we can avoid a bunch of boileplate syscall work with a kfunc th=
at
>> > > does the attachment?
>> > > We might as well abstract it at, say, libbpf layer which would
>> > > generate/load this small bpf program to call a kfunc.
>> >
>> > I'm not sure we're on the same page here.
>> > imo using syscall bpf prog that calls kfunc to do a per-device attach
>> > is an overkill here.
>> > It's an experimental feature, but you're already worried about
>> > multiple netdevs?
>> >
>> > Can you add an empty nop function and attach to it tracing style
>> > with fentry ?
>> > It won't be per-netdev, but do you have to do per-device demux
>> > by the kernel? Can your tracing bpf prog do that instead?
>> > It's just an ifindex compare.
>> > This way than non-uapi bits will be even smaller and no need
>> > to change struct netdevice.
>>
>> It's probably going to work if each driver has a separate set of tx
>> fentry points, something like:
>>   {veth,mlx5,etc}_devtx_submit()
>>   {veth,mlx5,etc}_devtx_complete()

I really don't get the opposition to exposing proper APIs; as a
dataplane developer I want to attach a program to an interface. The
kernel's role is to provide a consistent interface for this, not to
require users to become driver developers just to get at the required
details.

> Right. And per-driver descriptors.
> The 'generic' xdptx metadata is unlikely to be practical.
> Marshaling in and out of it is going to be too perf sensitive.
> I'd just add an attach point in the driver with enough
> args for bpf progs to make sense of the context and extend
> the verifier to make few safe fields writeable.

This is a rehashing of the argument we had on the RX side: just exposing
descriptors is a bad API because it forces BPF programs to deal with
hardware errata - which is exactly the kind of thing that belongs in a
driver. Exposing kfuncs allows drivers to deal with hardware quirks
while exposing a consistent API to (BPF) users.

> kfuncs to read/request timestamp are probably too slow.

Which is why we should be inlining them :)

-Toke

