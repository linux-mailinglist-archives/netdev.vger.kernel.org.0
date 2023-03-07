Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AA36ADE9D
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjCGMXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCGMXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:23:51 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93643E61E
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 04:23:46 -0800 (PST)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A8CA83FB95
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 12:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678191822;
        bh=gcBjgTyFzqziFUQTuD3fuF6hhRUdHz1Lc7VypcmVc5Y=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=RMFkqEOPdDXR1tal367owRmiZaM4NeOb5MUACCp1aBWwRV0OSZ9cs4/U/PZaPRR/6
         dLw3yHafhwZ4C1U8oGdv0QvvFBEIztqxhNJjlx+3JSZmnaWLpveVQIwzSvtNkrkcD6
         7WsWUO87oLwNiRCab9tqHGQOUHvnc+ToPj3EqMQIEWj3CfjeurdADbfdDz7Jh19U9C
         hXNP8RkCb46dTZ+FWChQPRyUu9KFsJBmrz9X6cPyG+NDO1+qw/UanuybZxCrjGT2q+
         Bsori15Q0ZYLgNDWmujboqJeRxexJE30mFbcxqthnhQbn5mjFJ8XD2sOFfIvRxlv4a
         kBkMx1q9Uvmjg==
Received: by mail-qv1-f69.google.com with SMTP id e9-20020a0cf749000000b00571f1377451so7405126qvo.2
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 04:23:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678191820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gcBjgTyFzqziFUQTuD3fuF6hhRUdHz1Lc7VypcmVc5Y=;
        b=5i0O5G/Tzsjned6iD2jpJBeMmB/s9SnKXzE394/WPiBGadLgZEDp1JgnTacSMIHZtu
         XWsmZk/kyhnpMDA9XwvuDvy8a4lcrHJy2K7m3dcSyxHj5XHz47ELUnXrZuJWN9rAQUU9
         A38fgKdOEZd9WMY3MMX8ME16BgHbRaVCnfciaSVHx+hf3hi66Hfg25ayurou++NlitAY
         65z0AY6PlflxryNiisNNub1H476CJUhpRm81t9ltyhAbhv8xgQT6pxyXg1Kh6wExxpUg
         h+jRrta/kqml3xuih1J2CZo5kX9Kr/t/a9lQtnaSAJlUu3ygoJ79lUZ4RcFfJFt0xsar
         5FlQ==
X-Gm-Message-State: AO0yUKVkelIBV9pghcjwJmIK+GkozKQDuAUeCcRjr3yvbh7gZF13PCeB
        hSn+td2Z1JCmx2fKmh0D/L/ZliBaGdE8LZK/ufcAQkbRBPeToaCqfmiVqMn+J64ptxCNptjg5re
        N8eklPv8o/60bnD09t4paa9xD2MteDjswXjfJQHscujWRkzWW3w==
X-Received: by 2002:a05:6214:b04:b0:56e:917a:1c19 with SMTP id u4-20020a0562140b0400b0056e917a1c19mr3445623qvj.0.1678191820511;
        Tue, 07 Mar 2023 04:23:40 -0800 (PST)
X-Google-Smtp-Source: AK7set/xv6+E6KxtnITdbAjC4xYrTm6Drs+UHv7miXjwgKWU+sirb/BaI9S4untDNyhwiOt1iKsR4BAo+UXPdUSi9e0=
X-Received: by 2002:a05:6214:b04:b0:56e:917a:1c19 with SMTP id
 u4-20020a0562140b0400b0056e917a1c19mr3445610qvj.0.1678191820260; Tue, 07 Mar
 2023 04:23:40 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-13-samin.guo@starfivetech.com> <CAJM55Z-WpxJUshAa_gN5GD+mMp1VaxPbnF6AV-ua0HzsFWsB6w@mail.gmail.com>
 <99a9eccd-2886-832f-07e6-4ba620c522b5@starfivetech.com>
In-Reply-To: <99a9eccd-2886-832f-07e6-4ba620c522b5@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Tue, 7 Mar 2023 13:23:24 +0100
Message-ID: <CAJM55Z9P9PG2TBU_UVHWhRikg5YXoi=77ObjeCc4TU1FykLK1w@mail.gmail.com>
Subject: Re: [PATCH v5 12/12] riscv: dts: starfive: visionfive 2: Enable gmac
 device tree node
To:     Guo Samin <samin.guo@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Mar 2023 at 02:21, Guo Samin <samin.guo@starfivetech.com> wrote:

> =E5=9C=A8 2023/3/6 21:04:28, Emil Renner Berthing =E5=86=99=E9=81=93:
> > On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wro=
te:
> >> From: Yanhong Wang <yanhong.wang@starfivetech.com>
> >>
> >> Update gmac device tree node status to okay.
> >>
> >> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> >> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> >> ---
> >>  .../dts/starfive/jh7110-starfive-visionfive-2.dtsi     | 10 +++++++++=
+
> >>  1 file changed, 10 insertions(+)
> >>
> >> diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2=
.dtsi b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
> >> index c2aa8946a0f1..d1c409f40014 100644
> >> --- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
> >> +++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
> >> @@ -12,6 +12,8 @@
> >>  / {
> >>         aliases {
> >>                 serial0 =3D &uart0;
> >> +               ethernet0 =3D &gmac0;
> >> +               ethernet1 =3D &gmac1;
> >
> > Please sort these alphabetically.
> Thanks, will fix.
> >
> >>                 i2c0 =3D &i2c0;
> >>                 i2c2 =3D &i2c2;
> >>                 i2c5 =3D &i2c5;
> >> @@ -92,6 +94,14 @@
> >>         status =3D "okay";
> >>  };
> >>
> >> +&gmac0 {
> >> +       status =3D "okay";
> >> +};
> >> +
> >> +&gmac1 {
> >> +       status =3D "okay";
> >> +};
> >
> > Since you'll need to add to the gmac0 and gmac1 nodes in the board
> > specific files too and it's only one line, consider just dropping this
> > here and add the status =3D "okay" there instead.
> >
> According to Andrew's suggestion, can I put the nodes of mdio and phy her=
e?

Yeah, if the boards then end up sharing more information it's fine to
put it here. It just seemed a little much to add 8 lines here when all
the boards shared was a status =3D "okay";

> >>  &i2c0 {
> >>         clock-frequency =3D <100000>;
> >>         i2c-sda-hold-time-ns =3D <300>;
> >> --
> >> 2.17.1
> >>
> >>
> >> _______________________________________________
> >> linux-riscv mailing list
> >> linux-riscv@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-riscv
>
> Best regards,
> Samin
> --
> Best regards,
> Samin
