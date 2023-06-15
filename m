Return-Path: <netdev+bounces-11167-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C36731D78
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22A4B1C20ECE
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF2A182AC;
	Thu, 15 Jun 2023 16:10:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068B5156C0;
	Thu, 15 Jun 2023 16:10:50 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091B41BC3;
	Thu, 15 Jun 2023 09:10:47 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-518ff822360so2565074a12.1;
        Thu, 15 Jun 2023 09:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686845445; x=1689437445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6oF4O/3EA5olKSB626xfLYiUy/lhqpKUwualmtgXOY=;
        b=Kyxb9xM4MSdy/GID1WQVmnBVf3YUuKcg0xA4nWHLITgRtumn1ZMSyzYipDy0bLKODN
         1BDCoy5yDX8dlM18Fr8NQB2ckzBf7ItdfyuVIkCpNtNlEokPYIFSJmHJWgkxlbK9OGxq
         Y1kng/t8OjlhueScat3JXziUaCfIWI+4XKYiQQNobTsQ6cfuuD3ggKydD0sFsezHkiGb
         lY63S+OdfwXFTOgUY50beXrdBPIZfrQsOb5tOvLG3tnhAhH25Q/Uz3TEn0CqoCYOuTw3
         zIeOybr1zPsbT7iKZ58KwRIA5Gcznya3PnttZT2Q68bvA4Dde5Sl8Qm4mrvcyctrTWcY
         ZmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686845445; x=1689437445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m6oF4O/3EA5olKSB626xfLYiUy/lhqpKUwualmtgXOY=;
        b=jzxI1DkcVgya3fHKKz06hprXCyr2KhRdDXEsFiA0q/CtrKTfp3dWUph89+5p5tGQKZ
         8kcKnNs0d38AHBrd5YwVfcbwz6iHoqLrwisnP+Cqp9Z/IKHpZTQ7+Cr/YVK5qJmZJmRX
         0aWbTsNPmZV9TRqBJya+qmOEJd5DH1jNlSgjUdIyM/z+D/cSVgR68MDAAX6lYG/rgdtZ
         c6mPReV2AYbMcKADNcLdnLyduCh8L5QY4ENWvAUn6T83dJTKolGiqa4OhpFly1cEAiGm
         +WnPMpRE9oj6LeAkJJ3ZSwrN8C3+fN3DjORA00zPzi8SZtvpJsyySaNmsGDHjeZmjvdy
         4lrw==
X-Gm-Message-State: AC+VfDztQkMffraNcxMX96U1Ylp8/fRwaGu8WHphWKd0bL7rQ+pI+/Yj
	3wRnD98KsMf0ctE18ltpkjYSv2WxwB+euUOR82s=
X-Google-Smtp-Source: ACHHUZ5ZtlHaXnpS0WI4lKB88rLfn+k/K19HMqxayec1Q8iRulYaJOxI2C9+2tbRY6AVabfJ2wh7/i9IwN7V9t8YQiI=
X-Received: by 2002:a05:6402:5172:b0:518:7bc3:4cec with SMTP id
 d18-20020a056402517200b005187bc34cecmr4233691ede.22.1686845445155; Thu, 15
 Jun 2023 09:10:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
 <ZIiaHXr9M0LGQ0Ht@google.com> <877cs7xovi.fsf@toke.dk> <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
 <87v8frw546.fsf@toke.dk> <CAKH8qBtsvsWvO3Avsqb2PbvZgh5GDMxe2fok-jS4DrJM=x2Row@mail.gmail.com>
 <CAADnVQKFmXAQDYVZxjvH8qbxk+3M2COGbfmtd=w8Nxvf9=DaeA@mail.gmail.com>
 <CAKH8qBvAMKtfrZ1jdwVS2pF161UdeXPSpY4HSzKYGTYNTupmTg@mail.gmail.com>
 <CAADnVQ+CCOw9_LbCAaFz0593eydKNb7RxnGr6_FatUOKmvPmBg@mail.gmail.com>
 <877cs6l0ea.fsf@toke.dk> <CAADnVQJM6ttxLjj2FGCO1DKOwHdj9eqcz75dFpsfwJ_4b3iqDw@mail.gmail.com>
 <87pm5wgaws.fsf@toke.dk>
In-Reply-To: <87pm5wgaws.fsf@toke.dk>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 15 Jun 2023 09:10:33 -0700
Message-ID: <CAADnVQKvn-6xio0DyO8EDJktHKtWykfEQc3VosO7oji+Fk1oMA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
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

On Thu, Jun 15, 2023 at 5:36=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@kernel.org> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Wed, Jun 14, 2023 at 5:00=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgense=
n <toke@kernel.org> wrote:
> >>
> >> >>
> >> >> It's probably going to work if each driver has a separate set of tx
> >> >> fentry points, something like:
> >> >>   {veth,mlx5,etc}_devtx_submit()
> >> >>   {veth,mlx5,etc}_devtx_complete()
> >>
> >> I really don't get the opposition to exposing proper APIs; as a
> >> dataplane developer I want to attach a program to an interface. The
> >> kernel's role is to provide a consistent interface for this, not to
> >> require users to become driver developers just to get at the required
> >> details.
> >
> > Consistent interface can appear only when there is a consistency
> > across nic manufacturers.
> > I'm suggesting to experiment in the most unstable way and
> > if/when the consistency is discovered then generalize.
>
> That would be fine for new experimental HW features, but we're talking
> about timestamps here: a feature that is already supported by multiple
> drivers and for which the stack has a working abstraction. There's no
> reason why we can't have that for the XDP path as well.

... has an abstraction to receive, but has no mechanism to set it
selectively per packet and read it on completion.

