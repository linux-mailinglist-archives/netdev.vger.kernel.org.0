Return-Path: <netdev+bounces-9401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A980728C2D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08042281706
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 00:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146AF7E1;
	Fri,  9 Jun 2023 00:08:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5AA64A;
	Fri,  9 Jun 2023 00:08:49 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5B82733;
	Thu,  8 Jun 2023 17:08:48 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-977e0fbd742so184327366b.2;
        Thu, 08 Jun 2023 17:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686269326; x=1688861326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=An5siZW4sf1qZzyvz3+Qivn6pv8jVdmr4ctKLLy2fSw=;
        b=KgVbuZcIHrTRv1vb+qa6tiaNVfb4MHnD3A2jtkaTe2X0lLKH2c0qpvTWfXfD1CT193
         w62gevamWi6c84uWCmf4sCdSK6eXDjn0Rx1Zu/L7SARAEUxTeNzybmteiIzEWqcRNBUd
         8ph99lKMp0TyMhEqq3uXTB1lfraOmzwNfpBx6iN1/FdL2aO13i2YKSnjuivQ+5MmAYNC
         wB1AwqPL9fQTMuipHiWtOsBH9FYZEswaf1FwbvESpAp1af3Kp/+DGoXOgkVY+f0TM1eZ
         ks4L6ei4xc+XZJXJpIMKlC76LbnrtRjAInmprlviQK3ekigaYzuLFg4Dl0bWhhvWxBbb
         03GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686269326; x=1688861326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=An5siZW4sf1qZzyvz3+Qivn6pv8jVdmr4ctKLLy2fSw=;
        b=QN1RpNQB4LDVc9e61dE94V0SZOTCBg5NAEh5CiUGayIjVLk2FoejU16v1BIApsngA6
         bQ6dGWDHnbZbSjORj9+bRgiy/WkW3obCLTzUc9rDeiMU+p5Rg8bse+Ocau8R3cwojGEY
         +okjRSNoUwNhzYuivvvaiwAGYUo+pmTlc2PveqA3lIEaXspfFV9KoLRmceuoIhmAQQv9
         OMgoQsm53slZ4cuBnT5It60u73CUq07LcZBhTNsXkocu9iEnEMVuYH8Np29ZH02tmefb
         AtQ/Uic+/sp2UAlja0cV5P5Dgf2/iZaUkZ1X3g4VF12ApL9iHg9v/luFAIm1X+hViXtF
         MmNA==
X-Gm-Message-State: AC+VfDwHLCPecsJ5oUV82IKSlZwB7MT89VsiwQbgi3VnY5bFKVy+Jzrz
	XRGrRSgAjxSfrbUfoRqzcrjs4VvmhGuO8GsnvUA=
X-Google-Smtp-Source: ACHHUZ5+HgiYO0C7ROMaHMHS6Hx/rST0lo5bLD8axqyRN2inzYqO0H6D4c9bvz56Lvf3OCaxtV9DRcx9Plln3gOI93A=
X-Received: by 2002:a17:907:1626:b0:977:95f4:5cca with SMTP id
 hb38-20020a170907162600b0097795f45ccamr54023ejc.54.1686269326584; Thu, 08 Jun
 2023 17:08:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com> <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com> <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <CAADnVQLL8bQxXkGfwc4BTTkjoXx2k_dANhwa0u0kbnkVgm730A@mail.gmail.com>
In-Reply-To: <CAADnVQLL8bQxXkGfwc4BTTkjoXx2k_dANhwa0u0kbnkVgm730A@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 8 Jun 2023 17:08:34 -0700
Message-ID: <CAEf4Bza9Dwi0_75CGPjdoirg97aoygLkChu-6q2DbOnRwZKGZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Stanislav Fomichev <sdf@google.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Nikolay Aleksandrov <razor@blackwall.org>, 
	John Fastabend <john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>, 
	Joe Stringer <joe@cilium.io>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, bpf <bpf@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 4:55=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jun 8, 2023 at 4:06=E2=80=AFPM Stanislav Fomichev <sdf@google.com=
> wrote:
> >
> > I'm not really concerned about our production environment. It's pretty
> > controlled and restricted and I'm pretty certain we can avoid doing
> > something stupid. Probably the same for your env.
> >
> > I'm mostly fantasizing about upstream world where different users don't
> > know about each other and start doing stupid things like F_FIRST where
> > they don't really have to be first. It's that "used judiciously" part
> > that I'm a bit skeptical about :-D
> >
> > Because even with this new ordering scheme, there still should be
> > some entity to do relative ordering (systemd-style, maybe CNI?).
> > And if it does the ordering, I don't really see why we need
> > F_FIRST/F_LAST.
>
> +1.
> I have the same concerns as expressed during lsfmmbpf.
> This first/last is a foot gun.
> It puts the whole API back into a single user situation.
> Without "first api" the users are forced to talk to each other
> and come up with an arbitration mechanism. A daemon to control
> the order or something like that.
> With "first api" there is no incentive to do so.

If Cilium and some other company X both produce, say, anti-DDOS
solution which cannot co-exist with any other anti-DDOS program and
either of them needs to guarantee that their program runs first, then
FIRST is what would be used by both to prevent accidental breakage of
each other (which is basically what happened with Cilium and some
other networking solution, don't remember the name). It's better for
one of them to loudly fail to attach than silently break other
solution with end users struggling to understand what's going on.

You and Stanislav keep insisting that any combination of any BPF
programs should co-exist, and I don't understand why we can or should
presume that. I think we are conflating generic API (and kernel *not*
making any assumptions about such API usage) with encouraging
collaborative BPF attachment policies. They are orthogonal and are not
in conflict with each other.

But we lived without FIRST/LAST guarantees till now, that's fine, I'll
stop fighting this.

