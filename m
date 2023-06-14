Return-Path: <netdev+bounces-10784-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B06FA7304DF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAA541C20D33
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADAC1111B2;
	Wed, 14 Jun 2023 16:28:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997A91095C;
	Wed, 14 Jun 2023 16:28:02 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ED2211F;
	Wed, 14 Jun 2023 09:28:00 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-5169f614977so11659904a12.3;
        Wed, 14 Jun 2023 09:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686760079; x=1689352079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7z5ClOpmYGeSB+jF+gmA2VEIzPNCp15J3pxp/TfhBNU=;
        b=RD0aj9ql3Z4vG8A/EeYpgGfLabHYhEzSjLEBvohzqu9CAUbPwMRG+6Ormde0hYFI5J
         lK66cvCJZId6gmHr83AiEmBhLdXbcP1La4sD/g3Mh11UPeQLNjQLN6cawr/E62i2JRQC
         0AKFfFMp+3yKEG2wvUkWFFJYK8qM1extAYGoxmhD54YqXOA88NOiNnqJHKF/TJSN6XzH
         yoKuqw0kIBmXpOK8oQyWNNMBzQiQisfx2sVv8Wcqz6vNw5OX43Og7ybG+dDcnr2ue72D
         yeauXOcvq3S4Wb2FL7WXMPhaMSYOKnhiVT8FcvKNz32Wur5PDEFvNpuY99Nb+2xAjoot
         hA2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686760079; x=1689352079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7z5ClOpmYGeSB+jF+gmA2VEIzPNCp15J3pxp/TfhBNU=;
        b=CASv63FXWnVdGLRj73K2xbW5B7oOQy8XCj2qIVbsYCg5nBeW5sIdOslS/K4sAEVCr1
         P1dJqOLONv6P00KcrSXm/qTqylVPv7KFD9S5m+LCZBjrM3Qve0Csam1QTL5jYgVpx8CD
         R0prV7WmOXHm32gShBmzxUSPt2fWyB2bW32X6zYedh/nVfvsXQMPyeaMcJ6gCyMXkXro
         QgUH8jeBKm6e6cUfWg6khFsENmqYBXJIDBdmJramIdVMMyL1QzmwyK25MBIU8TFqsrAG
         gl+mzq4OuE8Vc0kgMg133d10Ap9tyZj+t0UQ401hWmzUp/sutizsb2A0eL8nJ6p7rxfn
         RLOw==
X-Gm-Message-State: AC+VfDxKZZ0f0w2quiy+WNObqHFk9+XrgtbSzExqwzOQ/pKBCWJeT9Nk
	FCSjQe9cTKlMm3ZApI72F88chvI3EpirzYFVxuQ=
X-Google-Smtp-Source: ACHHUZ43Tbhi3lUORo6ThPJOyZDmVAiNE1w3G/BuyEp5qSSSVHcR0cIgDsAll9cKajDQ/tvOijtEElEs+cKvgnROJE4=
X-Received: by 2002:aa7:c50e:0:b0:50b:c89f:f381 with SMTP id
 o14-20020aa7c50e000000b0050bc89ff381mr10387978edq.29.1686760079101; Wed, 14
 Jun 2023 09:27:59 -0700 (PDT)
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
 <CAADnVQ+CCOw9_LbCAaFz0593eydKNb7RxnGr6_FatUOKmvPmBg@mail.gmail.com> <877cs6l0ea.fsf@toke.dk>
In-Reply-To: <877cs6l0ea.fsf@toke.dk>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 14 Jun 2023 09:27:47 -0700
Message-ID: <CAADnVQJM6ttxLjj2FGCO1DKOwHdj9eqcz75dFpsfwJ_4b3iqDw@mail.gmail.com>
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

On Wed, Jun 14, 2023 at 5:00=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@kernel.org> wrote:
>
> >>
> >> It's probably going to work if each driver has a separate set of tx
> >> fentry points, something like:
> >>   {veth,mlx5,etc}_devtx_submit()
> >>   {veth,mlx5,etc}_devtx_complete()
>
> I really don't get the opposition to exposing proper APIs; as a
> dataplane developer I want to attach a program to an interface. The
> kernel's role is to provide a consistent interface for this, not to
> require users to become driver developers just to get at the required
> details.

Consistent interface can appear only when there is a consistency
across nic manufacturers.
I'm suggesting to experiment in the most unstable way and
if/when the consistency is discovered then generalize.

