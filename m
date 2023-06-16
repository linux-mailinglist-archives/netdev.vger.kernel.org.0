Return-Path: <netdev+bounces-11489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75970733554
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D4671C2100B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7074C19E46;
	Fri, 16 Jun 2023 16:01:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6531479E5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:01:39 +0000 (UTC)
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C7F35A4;
	Fri, 16 Jun 2023 09:01:24 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 3f1490d57ef6-bc43a73ab22so1512003276.0;
        Fri, 16 Jun 2023 09:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686931283; x=1689523283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QFpbI4cV9Gd42NkceYFYj6cG9uu5I+URBfsC3J8xAYs=;
        b=Je8n+1DxKqAWm/6RVTRghBh9VeSw/2TGZgtQB8n2YsrAn/ZnPVWOuEDL80HA1bPkqc
         8MqwUZn94ILpCo5xKfHpLZYHDofFwlHcgZa9a7lMLNMTcb+LkgW/4qKYtnuGC3KfL5HJ
         UzTzGw1VHNTEVKLNEReWAHp99EaqofgIsOTHiBPVluKBY1yUJ7OguVO5JWyhHUfH13H2
         9s8m52aL7G38Gsww1Hwb028Ym7HWFnNKeK/1AJ5O1aQn6+M+Xtx0VIYS1hdDzWLUhF3K
         8UwlAVF1fVLnOayV5qtB2eOhM7DTKmcwBI70DAj9XDyemfZq7o5nP0/kwXmpDcOAXLav
         Eiag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686931283; x=1689523283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QFpbI4cV9Gd42NkceYFYj6cG9uu5I+URBfsC3J8xAYs=;
        b=SuwT5tRZTVxcBHlUB2HjcwZFjorDx7KONhZkJm9TQn9YxA1yL4sXM2RdR/BMBcpJ8B
         O/9Xwob7nTMr52/zKnKu22Py0vhmqB7a9qvvaastOgESiARh4i16EwV429IbkTlDm6zO
         F0PhpXhSB7cBuXc6cw+j+GW1uh5/EVAwvMC4wvJWVcga/40yJ/X2b2e3phNaJxBknEMn
         IKJJT9+eLcYEye1gBgQCPlTZ0Sy+z/2A6Vu4scaLrsfd+aiZzLA7gQWyVtoLo4x2M1iL
         PVzdQR/ULBbOgfMZJp9FeUdupd/qnx0JcWn4jwCxs8tB9kWT3uu4w5C8aWsq+b9CcYdv
         Jy9Q==
X-Gm-Message-State: AC+VfDwaUWdqxw25kreBUeeVrt1/OuR0KFEDbn6KNuKWYyu4vwUBCz8s
	s06waqEV3i0z9jUh8K1e7D9Xcr32SlB05AhwZ9w=
X-Google-Smtp-Source: ACHHUZ5jFFIflSyNlSISFwHqRA4xK4OES2dEIZGPNMLAhCvs2X3Lfdmmpow1RS60cgw+CDhXcKLYtspEeCo0fK4lE9o=
X-Received: by 2002:a25:dd8:0:b0:bcf:2e49:4909 with SMTP id
 207-20020a250dd8000000b00bcf2e494909mr10802027ybn.10.1686931281668; Fri, 16
 Jun 2023 09:01:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614230128.199724bd@kernel.org> <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org> <20230616.220220.1985070935510060172.ubuntu@gmail.com>
 <f28d6403-d042-4ffb-9872-044388d0f9d9@lunn.ch> <CANiq72mMi=7P9OxSH0+ORYDEyxG3+n5uOv_ooxMJ72YRBRZ+PQ@mail.gmail.com>
 <a4bc8847-c668-4cff-9892-663516cf8127@lunn.ch>
In-Reply-To: <a4bc8847-c668-4cff-9892-663516cf8127@lunn.ch>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 16 Jun 2023 18:01:10 +0200
Message-ID: <CANiq72=g0vw3fPh7ZHckqsdU+XgqHnnvbFPk+7YYmQZ6fYyz6Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
To: Andrew Lunn <andrew@lunn.ch>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, kuba@kernel.org, netdev@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, aliceryhl@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 4:43=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> I said in another email, i don't want to suggest premature
> optimisation, before profiling is done. But in C, these functions are
> inline for a reason. We don't want the cost of a subroutine call. We
> want the compiler to be able to inline the code, and the optimiser to
> be able to see it and generate the best code it can.

See my reply in v2 to your message where I mentioned some of the
options we are considering [1] -- not sure if you saw it:

> Yeah, other use cases will also need that solved, e.g. Andreas for his
> NVMe work.
>
> We discussed reimplementing performance-critical bits in Rust as you
> suggest, as well as cross-language LTO. We also talked about possible
> alternative approaches like "manual local LTO" for the helpers only
> via feeding their LLVM IR to `rustc`, which may recover most of the
> performance without having to go for full LTO and its associated
> kernel link times.

[1] https://lore.kernel.org/rust-for-linux/CANiq72kyUhvmG6KB32X1vuhNzOOJbs7=
R1JbK+vnPELX4tG73RA@mail.gmail.com/

Cheers,
Miguel

