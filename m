Return-Path: <netdev+bounces-10547-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DDE272EF79
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 244A72812B9
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D0A1ED51;
	Tue, 13 Jun 2023 22:32:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0AA1361;
	Tue, 13 Jun 2023 22:32:59 +0000 (UTC)
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5722119B1;
	Tue, 13 Jun 2023 15:32:57 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b3451b3ea9so423961fa.1;
        Tue, 13 Jun 2023 15:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686695575; x=1689287575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTvP+VJDU2WSwdurVBK2FZWZY7/TsrOMSB/9rSkASww=;
        b=lAVD+4IOANW7YZpjdeZ35JcQQUcjAUcijpUzbymPZGwuTi3GUKFactcddjsUk2ibb8
         HkbWaiyvhqNliseRGMYZM2MfC7e1ij3q2Rv7ipuZGEntSV5SR9njmdtN9Xh7lUheqyOJ
         UoJ4vpKKusBVLq3g/n7dpINBR8+8KciSK03aqX778bmXViIbp+kVb0JljY8YZs6kTrxu
         Sf2MwjJyG718sAFwh4q/+ln+BRL8t5ybgvU+sckdqzIUGYjXjYulWUJcu7+1KTT894Oz
         ZGCc3rNoWcvykqP6qo8EkVdijOhsKsNR0r5SJPcJCXoLMSt+rBgOq973QJEjDLrh9iVw
         SWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686695575; x=1689287575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTvP+VJDU2WSwdurVBK2FZWZY7/TsrOMSB/9rSkASww=;
        b=PvwIYy0wnpsUbk/Fi/QfW/6mHCMYyyKc9u+AQLbMUit0P50hPB1eeCshf7g30gSWPr
         ubFR84d1oUCjOvE4sWEN5xx7MXbRvQSj9DZfSTBuV92oer/yiqaeUoLDXoONm0RSnQr9
         dvOJlgC5x3zPI9CK++0aOqocUBa3k/B5FfPIuYWdTD97Jkg4WZWyw9RPBdw9ZJGr7dOC
         Cfj4RaJLgLDXQ0dA4hurk3oDxURa8QMazLHlqEi6CWbBbiD3HgQwFTCKup/0i4qK9tLP
         tGKEbGm4EKPaOM7di8CtypKzs/X0sJsFg2oGWGtW6gR8oyWZdTI71dvtICXuQbhKTFv3
         Fknw==
X-Gm-Message-State: AC+VfDzrC0uvC0G7WoBK3RrS1zzJcicWg3bF00fzVjnKfkNRGqnXVSq9
	8qGQUUc2bme4pRmiVnjnw4Ke+lyUgNaM/8VFf6c=
X-Google-Smtp-Source: ACHHUZ47Y1Id9o7bTblsU/TUo8rtP6HbZl4qVpVHh+4XaGAXhg/Hx9WM7/72AWABM8slEWuv5DgKmZIO16bxmFTESIU=
X-Received: by 2002:a2e:9ccf:0:b0:2b1:bacc:b3de with SMTP id
 g15-20020a2e9ccf000000b002b1baccb3demr5579002ljj.4.1686695575147; Tue, 13 Jun
 2023 15:32:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
 <ZIiaHXr9M0LGQ0Ht@google.com> <877cs7xovi.fsf@toke.dk> <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
 <87v8frw546.fsf@toke.dk> <CAKH8qBtsvsWvO3Avsqb2PbvZgh5GDMxe2fok-jS4DrJM=x2Row@mail.gmail.com>
In-Reply-To: <CAKH8qBtsvsWvO3Avsqb2PbvZgh5GDMxe2fok-jS4DrJM=x2Row@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 13 Jun 2023 15:32:43 -0700
Message-ID: <CAADnVQKFmXAQDYVZxjvH8qbxk+3M2COGbfmtd=w8Nxvf9=DaeA@mail.gmail.com>
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

On Tue, Jun 13, 2023 at 2:17=E2=80=AFPM Stanislav Fomichev <sdf@google.com>=
 wrote:
>
> > >> >> > --- UAPI ---
> > >> >> >
> > >> >> > The hooks are implemented in a HID-BPF style. Meaning they don'=
t
> > >> >> > expose any UAPI and are implemented as tracing programs that ca=
ll
> > >> >> > a bunch of kfuncs. The attach/detach operation happen via BPF s=
yscall
> > >> >> > programs. The series expands device-bound infrastructure to tra=
cing
> > >> >> > programs.
> > >> >>
> > >> >> Not a fan of the "attach from BPF syscall program" thing. These a=
re part
> > >> >> of the XDP data path API, and I think we should expose them as pr=
oper
> > >> >> bpf_link attachments from userspace with introspection etc. But I=
 guess
> > >> >> the bpf_mprog thing will give us that?
> > >> >
> > >> > bpf_mprog will just make those attach kfuncs return the link fd. T=
he
> > >> > syscall program will still stay :-(
> > >>
> > >> Why does the attachment have to be done this way, exactly? Couldn't =
we
> > >> just use the regular bpf_link attachment from userspace? AFAICT it's=
 not
> > >> really piggy-backing on the function override thing anyway when the
> > >> attachment is per-dev? Or am I misunderstanding how all this works?
> > >
> > > It's UAPI vs non-UAPI. I'm assuming kfunc makes it non-UAPI and gives
> > > us an opportunity to fix things.
> > > We can do it via a regular syscall path if there is a consensus.
> >
> > Yeah, the API exposed to the BPF program is kfunc-based in any case. If
> > we were to at some point conclude that this whole thing was not useful
> > at all and deprecate it, it doesn't seem to me that it makes much
> > difference whether that means "you can no longer create a link
> > attachment of this type via BPF_LINK_CREATE" or "you can no longer
> > create a link attachment of this type via BPF_PROG_RUN of a syscall typ=
e
> > program" doesn't really seem like a significant detail to me...
>
> In this case, why do you prefer it to go via regular syscall? Seems
> like we can avoid a bunch of boileplate syscall work with a kfunc that
> does the attachment?
> We might as well abstract it at, say, libbpf layer which would
> generate/load this small bpf program to call a kfunc.

I'm not sure we're on the same page here.
imo using syscall bpf prog that calls kfunc to do a per-device attach
is an overkill here.
It's an experimental feature, but you're already worried about
multiple netdevs?

Can you add an empty nop function and attach to it tracing style
with fentry ?
It won't be per-netdev, but do you have to do per-device demux
by the kernel? Can your tracing bpf prog do that instead?
It's just an ifindex compare.
This way than non-uapi bits will be even smaller and no need
to change struct netdevice.

