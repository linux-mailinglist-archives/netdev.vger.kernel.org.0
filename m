Return-Path: <netdev+bounces-11443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 296F673321A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AFE528178D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422941642B;
	Fri, 16 Jun 2023 13:23:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354421113
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:23:13 +0000 (UTC)
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC4EED;
	Fri, 16 Jun 2023 06:23:12 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-bb3d122a19fso607224276.0;
        Fri, 16 Jun 2023 06:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686921792; x=1689513792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYupTS+mGz3DgGD6PUWxkscnXmtIW67spY6KWWU2XDM=;
        b=WWz9wzvFTs87fn+00DXng9L2F8JfzVzkT0mGo/gli4WAxEd1hWxFsK4CSIGp1D6kF0
         DiR+66O3kg+cm2Mg/iXw1dBZ4d1iDEai/vIFEp9bNXrpmg5pJIdUySryd7as5xkqt4eg
         elVxlVSDucTPyjVWMLegLmF2EkqrWwZFAZ1HW/DgiXpoKxIn4EbGUi96GPxmzMLEEiU/
         WybQmz5mU1W5WWTMh9m+ATtA3OEO3wAEhjcW7QylFKj9RYXlQKWTRUswULFxuZYePcO0
         ZqonS6fExSzTyvOTvDa0RJ/xuUmvI8tPItlOgkKM6PNewNH6Mrnqdlg4/AThuVgYfEoJ
         zPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686921792; x=1689513792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RYupTS+mGz3DgGD6PUWxkscnXmtIW67spY6KWWU2XDM=;
        b=gTFZVIxScxPhlA0rUAKp7iHM96ambWeocdI5loYm/TFv04ppeQdKMyu8xhaH7pm6jP
         K48Qzv5o9iXROO4FP8frN8kMmPoBEpl3bW0NE27YIWVDAk3YrY25D2yLrgOi16SIJ3DF
         6ORGMFF9z+NAYKBAafYOr/cCY7ywY1ARVrjEr6PLIXFjT6QfrCo+QsH4oEMTUXQTTXrC
         WZJhtiqmHZRN/RmYgiwlEYp0na0N3hWURLA0ruZAByp5V2CIEyDbeToR3LRpQ0+W6BX3
         UdPLQ4+w3+hBL1YMUavDiHMlqb/G+Pp5xyrIud7Uynt4OD2z90keyhFFH+C0c8SAcnID
         qwlQ==
X-Gm-Message-State: AC+VfDx3lm/JzGpmFmfu6bPbm3g52fyivqEnbSkHSaqlb5YZBzFFnq4F
	D1et3pg6oxheiPuptZTNggcTl9jyFsK+TBw6/kw=
X-Google-Smtp-Source: ACHHUZ7mYh86/wr2d9UgDgaZdV1wqxnOI6263gp7f3gcXXNLt7NOs/iQ6yXi8ykjYMFH5nFtc8bjfZy20+BMM1x5wSw=
X-Received: by 2002:a25:1603:0:b0:bca:efc4:2ccf with SMTP id
 3-20020a251603000000b00bcaefc42ccfmr1476732ybw.44.1686921792018; Fri, 16 Jun
 2023 06:23:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230614230128.199724bd@kernel.org> <CANiq72nLV-BiXerGhhs+c6yeKk478vO_mKxMa=Za83=HbqQk-w@mail.gmail.com>
 <20230615191931.4e4751ac@kernel.org> <20230616.211821.1815408081024606989.ubuntu@gmail.com>
In-Reply-To: <20230616.211821.1815408081024606989.ubuntu@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 16 Jun 2023 15:23:01 +0200
Message-ID: <CANiq72mAHv8ozBsZ9-ax9kY8OfESFAc462CxrKNv0gC3r0=Xmg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: kuba@kernel.org, netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	aliceryhl@google.com, andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 2:18=E2=80=AFPM FUJITA Tomonori
<fujita.tomonori@gmail.com> wrote:
>
> As far as I know, no subsystem has accepted Rust bindings yet.

For abstractions in general (see my previous reply for "real HW"
etc.), the KUnit subsystem [1] which is onboard and taking some
patches through their tree / ownership of the code.

[1] https://lore.kernel.org/rust-for-linux/CABVgOSnprvxzi-z42KFjOZsiRUv7u7E=
2poVGJNmTfS2OU4x4AA@mail.gmail.com/

> Replacing the existing C driver for real HW with Rust new one doesn't
> make sense, right? So a necessary condition of getting Rust bindings
> for a subsystem accepted is that a HW verndor implements both a driver
> and bindings for their new HW?

Not necessarily. It is true that, in general, the kernel does not
want/accept duplicate implementations.

However, this is a bit of a special situation, and there may be some
reasons to allow for it in a given subsystem. For instance:

  - The need to experiment with Rust.

  - To have an actual in-tree user that allows to develop the
abstractions for a subsystem, so that later they are ready to be used
for future, actual new drivers.

  - Pending redesigns: sometimes subsystems may have a
redesign/refactor/experiment that they have wanted to do for a while,
so they may take the chance to also try to write it in Rust anyway. Of
course, that could conflate two experiments, but... :)

  - Security: there may be some modules that have been problematic in
the past (especially if due to memory safety issues / data races), and
the subsystem may be willing to accept a parallel implementation to
see if it would be an improvement thanks to Rust's properties.

Cheers,
Miguel

