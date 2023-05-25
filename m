Return-Path: <netdev+bounces-5238-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3A27105B0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C0CC1C20E8B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42E31FD9;
	Thu, 25 May 2023 06:31:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38AFBE50
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:31:15 +0000 (UTC)
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19486189;
	Wed, 24 May 2023 23:31:13 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-561bcd35117so2714027b3.3;
        Wed, 24 May 2023 23:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684996272; x=1687588272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8n8iOYyYZVUfxiH0/iEZbqyr+i/7ghiJPs0pDzg9C1M=;
        b=CEG+EMXyuQ6cQIaCVG5zhC6DLoaW9Y9bYtqLKPYbsnsc//kGjybkaBY5ND1eHqCBfa
         o5lFTInLRncn+bPWvIhJMiacT9q/WLWrhawblI7EvTZaiEKt45THhZCqqXcFJ01vVVnl
         P7dvLt8hkWxf7RD/qimHZ4Qt6TVTRry2nzymNq6h/5p58Vkm9rAd4+ORN1TZA5P0Trmj
         XCZvAfF8ebTLNxVA6YY2qQgg/2pj6X50DYMrNJZ+OUJQ+yxJxlYaBbt+Xr6KNiqUWjai
         iwCmHR/s9qugPawoChN67lNCjPzowMYKDl+6lEXREEesC9ygQfKlCL9Q/RZvgZYVjVgF
         0neA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684996272; x=1687588272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8n8iOYyYZVUfxiH0/iEZbqyr+i/7ghiJPs0pDzg9C1M=;
        b=Hg2belZHGQQln81K+WJrkl32UzuDm5p4FmETL5MxRnxsWjyYgYdm8QVa6WvJT2+Lar
         n3KEMj6nz0l7Hoga2mtluNTCvXf5LPxoBJAmYYUv3cvrPFypBc2A4DT4aRBnLTVF+TAD
         K53Tx8MF3CL5+G+gmw0ErAwbz7boqcl0oRd52JzeTBP3vqe0qPuH22vVlJxS8vcSe9Bb
         RMPliy0pEl0ojCaVXtJU8b9lZmoAv4YqTjv9KIuIyYUooXvdQErqKazmGgARwf50Dtae
         Ikuj+Krm2sTX7AwCjof6lPsdQ4vDl6ERGzkDvBGgmYYIOYwmZQxMW56NhjYoJ7o/5V2N
         30OQ==
X-Gm-Message-State: AC+VfDwvenbCyzizD+uNx3X1ATAU6wNnAkc/SOwKAc6lnmf7LlkassI/
	0vPUyxPHovwiq/pBGFECjYPji9vNsqDXLEss7w==
X-Google-Smtp-Source: ACHHUZ56BFLHxCC/VLM3UoUcphcEeGIxtn7J8rlrtNeupmfjXUWipsAbSTJh4ygS6L6azKUsT7BMHOimNJUHd9tW/Z0=
X-Received: by 2002:a81:c308:0:b0:565:323d:8182 with SMTP id
 r8-20020a81c308000000b00565323d8182mr11261506ywk.22.1684996272237; Wed, 24
 May 2023 23:31:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com> <ZG4ISE3WXlTM3H54@debian.me>
In-Reply-To: <ZG4ISE3WXlTM3H54@debian.me>
From: Johannes Pointner <h4nn35.work@gmail.com>
Date: Thu, 25 May 2023 08:31:00 +0200
Message-ID: <CAHvQdo0gucr-GcWc9YFxsP4WwPUdK9GQ6w-5t9CuqqvPTv+VcA@mail.gmail.com>
Subject: Re: DP83867 ethernet PHY regression
To: Francesco Dolcini <francesco@dolcini.it>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Andrew Lunn <andrew@lunn.ch>, Praneeth Bajjuri <praneeth@ti.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Grygorii Strashko <grygorii.strashko@ti.com>, Dan Murphy <dmurphy@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 3:22=E2=80=AFPM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:
>
> On Mon, May 22, 2023 at 04:58:46PM +0200, Francesco Dolcini wrote:
> > Hello all,
> > commit da9ef50f545f ("net: phy: dp83867: perform soft reset and retain
> > established link") introduces a regression on my TI AM62 based board.
> >
> > I have a working DTS with Linux TI 5.10 downstream kernel branch, while
> > testing the DTS with v6.4-rc in preparation of sending it to the mailin=
g
> > list I noticed that ethernet is working only on a cold poweron.
> >
> > With da9ef50f545f reverted it always works.
> >
> > Here the DTS snippet for reference:
> >
> > &cpsw_port1 {
> >       phy-handle =3D <&cpsw3g_phy0>;
> >       phy-mode =3D "rgmii-rxid";
> > };
> >
> > &cpsw3g_mdio {
> >       assigned-clocks =3D <&k3_clks 157 20>;
> >       assigned-clock-parents =3D <&k3_clks 157 22>;
> >       assigned-clock-rates =3D <25000000>;
> >
> >       cpsw3g_phy0: ethernet-phy@0 {
> >               compatible =3D "ethernet-phy-id2000.a231";
> >               reg =3D <0>;
> >               interrupt-parent =3D <&main_gpio0>;
> >               interrupts =3D <25 IRQ_TYPE_EDGE_FALLING>;
> >               reset-gpios =3D <&main_gpio0 17 GPIO_ACTIVE_LOW>;
> >               reset-assert-us =3D <10>;
> >               reset-deassert-us =3D <1000>;
> >               ti,fifo-depth =3D <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
> >               ti,rx-internal-delay =3D <DP83867_RGMIIDCTL_2_00_NS>;
> >       };
> > };
> >
>
> Thanks for the regression report. I'm adding it to regzbot:
>
> #regzbot ^introduced: da9ef50f545f86
> #regzbot title: TI AM62 DTS regression due to dp83867 soft reset

Hello Francesco,

I had a similar issue with a patch like this, but in my case it was the DP8=
3822.
https://lore.kernel.org/netdev/CAHvQdo2yzJC89K74c_CZFjPydDQ5i22w36XPR5tKVv_=
W8a2vcg@mail.gmail.com/
I also raised the question for the commit da9ef50f545f.
https://lore.kernel.org/lkml/CAHvQdo1U_L=3DpETmTJXjdzO+k7vNTxMyujn99Y3Ot9xA=
yQu=3DatQ@mail.gmail.com/

The problem was/is for me that the phy gets the clock from the CPU and
the phy is already initialized in the u-boot.
During the Linux kernel boot up there is a short amount of time where
no clock is delivered to the phy.
The phy didn't like this and was most of the time not usable anymore.
The only thing that brought the phy/link back was resetting the phy
using the phytool.

Regards,
Hannes

