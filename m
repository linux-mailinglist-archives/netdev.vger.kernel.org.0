Return-Path: <netdev+bounces-10588-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 029B272F374
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 06:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 109E51C20A2A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 04:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0203D138C;
	Wed, 14 Jun 2023 04:20:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8ED7F2;
	Wed, 14 Jun 2023 04:20:00 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9AF19B1;
	Tue, 13 Jun 2023 21:19:59 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51496f57e59so8691834a12.2;
        Tue, 13 Jun 2023 21:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686716397; x=1689308397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3kKhomZgVx2SnC2iFALopIqb06H8mvyLhpcO1QQocLs=;
        b=SNiWrpUF+t/j5Da32OdL0aWlUg0b/y/dvSIHhbjA2p4e8SvPSr8e+RyRy2HGo/bvMz
         aIVyOECuEKpryoXvdtHRC51pdZ3ukHDur+P6ExJXsmLjJD6qkjrAfB+zmmLVw9gu+Wcr
         rslpGjdswrYS1o93yqqJBYs/9tAOm0IT2eTW99AIw7GJdfJJZf2OEumH93joBeUz39rm
         b4gf/DtML99JiSDkZayNVMl2W7Uv7p2XPrZ1tZlPdsmmZkgDrYt7kt6pQ4fgUBZtMPRf
         umGdW5G9yrS85sKxgJOuZSXdDC8qYuhDacI1H5LLcfAPVRx9Aw3wxn7fAGJ3dGBbYjyY
         jpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686716397; x=1689308397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3kKhomZgVx2SnC2iFALopIqb06H8mvyLhpcO1QQocLs=;
        b=X4qfYel2voNP5SeuYqQGLxethi8NsEaQAOTCkuugi1U+8R6/zZxLo86lfGL1hwetV+
         3haCqao3Fin3vqQn/80z9ltaiKh7cqOBVo7XmWVaSXnyXPbRifFPNgCahZed+9jmciWb
         T9WvyUE3KyGirzdaGLpkWy2FJgPGJE7aniM4dDyszNu5HmC+oXuRpvYNueMP5ljBt8oE
         qR9V5jedTLB6XLmyMQ+II/dh9YPd9tr/G7K0fu5Kk4tI78luJnd2Vwsx3zoUC195MN/S
         m16RXoysxmUfxneLJoClanU3u/qJ4HyM/ppGa8zLMQ/FR0/cVy6gdtf/uqQYXz5g+uhF
         HImQ==
X-Gm-Message-State: AC+VfDy5p1Qtmk/qjP6GYrRTvbjrzZv+xFh6SvNa7z4BVEV3WVKfZm9o
	7Azusfdss6HPqNWwYrVpQPa/eQHWwHrLWYyrBrA=
X-Google-Smtp-Source: ACHHUZ5qv+ybsXW+kUvqW193WBFkvmeVkJDWLaiFvcZKEHB+YRNF93x0nBqMAuWVz1N3a42FdXWx6Hwks1SOVTeWqbM=
X-Received: by 2002:a50:ec88:0:b0:518:92a1:2c14 with SMTP id
 e8-20020a50ec88000000b0051892a12c14mr289410edr.35.1686716397111; Tue, 13 Jun
 2023 21:19:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
 <ZIiaHXr9M0LGQ0Ht@google.com> <877cs7xovi.fsf@toke.dk> <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
 <87v8frw546.fsf@toke.dk> <CAKH8qBtsvsWvO3Avsqb2PbvZgh5GDMxe2fok-jS4DrJM=x2Row@mail.gmail.com>
 <CAADnVQKFmXAQDYVZxjvH8qbxk+3M2COGbfmtd=w8Nxvf9=DaeA@mail.gmail.com> <CAKH8qBvAMKtfrZ1jdwVS2pF161UdeXPSpY4HSzKYGTYNTupmTg@mail.gmail.com>
In-Reply-To: <CAKH8qBvAMKtfrZ1jdwVS2pF161UdeXPSpY4HSzKYGTYNTupmTg@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 13 Jun 2023 21:19:45 -0700
Message-ID: <CAADnVQ+CCOw9_LbCAaFz0593eydKNb7RxnGr6_FatUOKmvPmBg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
To: Stanislav Fomichev <sdf@google.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	"Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	"Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>, Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 4:16=E2=80=AFPM Stanislav Fomichev <sdf@google.com>=
 wrote:
>
> On Tue, Jun 13, 2023 at 3:32=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jun 13, 2023 at 2:17=E2=80=AFPM Stanislav Fomichev <sdf@google.=
com> wrote:
> > >
> > > > >> >> > --- UAPI ---
> > > > >> >> >
> > > > >> >> > The hooks are implemented in a HID-BPF style. Meaning they =
don't
> > > > >> >> > expose any UAPI and are implemented as tracing programs tha=
t call
> > > > >> >> > a bunch of kfuncs. The attach/detach operation happen via B=
PF syscall
> > > > >> >> > programs. The series expands device-bound infrastructure to=
 tracing
> > > > >> >> > programs.
> > > > >> >>
> > > > >> >> Not a fan of the "attach from BPF syscall program" thing. The=
se are part
> > > > >> >> of the XDP data path API, and I think we should expose them a=
s proper
> > > > >> >> bpf_link attachments from userspace with introspection etc. B=
ut I guess
> > > > >> >> the bpf_mprog thing will give us that?
> > > > >> >
> > > > >> > bpf_mprog will just make those attach kfuncs return the link f=
d. The
> > > > >> > syscall program will still stay :-(
> > > > >>
> > > > >> Why does the attachment have to be done this way, exactly? Could=
n't we
> > > > >> just use the regular bpf_link attachment from userspace? AFAICT =
it's not
> > > > >> really piggy-backing on the function override thing anyway when =
the
> > > > >> attachment is per-dev? Or am I misunderstanding how all this wor=
ks?
> > > > >
> > > > > It's UAPI vs non-UAPI. I'm assuming kfunc makes it non-UAPI and g=
ives
> > > > > us an opportunity to fix things.
> > > > > We can do it via a regular syscall path if there is a consensus.
> > > >
> > > > Yeah, the API exposed to the BPF program is kfunc-based in any case=
. If
> > > > we were to at some point conclude that this whole thing was not use=
ful
> > > > at all and deprecate it, it doesn't seem to me that it makes much
> > > > difference whether that means "you can no longer create a link
> > > > attachment of this type via BPF_LINK_CREATE" or "you can no longer
> > > > create a link attachment of this type via BPF_PROG_RUN of a syscall=
 type
> > > > program" doesn't really seem like a significant detail to me...
> > >
> > > In this case, why do you prefer it to go via regular syscall? Seems
> > > like we can avoid a bunch of boileplate syscall work with a kfunc tha=
t
> > > does the attachment?
> > > We might as well abstract it at, say, libbpf layer which would
> > > generate/load this small bpf program to call a kfunc.
> >
> > I'm not sure we're on the same page here.
> > imo using syscall bpf prog that calls kfunc to do a per-device attach
> > is an overkill here.
> > It's an experimental feature, but you're already worried about
> > multiple netdevs?
> >
> > Can you add an empty nop function and attach to it tracing style
> > with fentry ?
> > It won't be per-netdev, but do you have to do per-device demux
> > by the kernel? Can your tracing bpf prog do that instead?
> > It's just an ifindex compare.
> > This way than non-uapi bits will be even smaller and no need
> > to change struct netdevice.
>
> It's probably going to work if each driver has a separate set of tx
> fentry points, something like:
>   {veth,mlx5,etc}_devtx_submit()
>   {veth,mlx5,etc}_devtx_complete()

Right. And per-driver descriptors.
The 'generic' xdptx metadata is unlikely to be practical.
Marshaling in and out of it is going to be too perf sensitive.
I'd just add an attach point in the driver with enough
args for bpf progs to make sense of the context and extend
the verifier to make few safe fields writeable.
kfuncs to read/request timestamp are probably too slow.

