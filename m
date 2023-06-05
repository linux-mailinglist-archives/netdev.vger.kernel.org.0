Return-Path: <netdev+bounces-7853-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD69721D26
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12FB828118E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D851524F;
	Mon,  5 Jun 2023 04:31:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DC8523A
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 04:31:15 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384C0AC
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 21:31:13 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b1c30a1653so12660021fa.2
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 21:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685939471; x=1688531471;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sOUGTndMgfrlVlDjRXo6t37BDrh5sRrI3ATT4Vl3CWI=;
        b=OpRSxvvP4b+NexQdBuFsEF9rDAHY9+ps0jbXqAtflYtwig/lDI22iufN7ZKtof69kE
         /19Q0eZHuIQbdhzwv5h94dpXL2oqcdE4zmLeGWic7pGTCNpV1DVSYNLNZSsesvD2vyZv
         L4mt/7ZPOiO2fE2S/zWC7O9f1vS8c2Hsj9TlDaksUOLyTJhUZR38giJxuXktv0VUVvLh
         GIZ/6DcgaTDYGIW9pbCE1JIhQTtQ38OIz5KsCxyM6nO9rV3KHySJhua4cw8mRDfvbyni
         PhkSTBAqSWSGdqMisKYObGGKM2pNf9a4Lop14l221A+ulAyntNBd3EmA3A6lbTNrQ5ji
         EBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685939471; x=1688531471;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sOUGTndMgfrlVlDjRXo6t37BDrh5sRrI3ATT4Vl3CWI=;
        b=jBL4golSf8bPE7FsE8/7vARVa2YkedOnZONzaXxU3OszJ6yV6bHWzotr+VvEjjgX7Y
         ooD8qPNbJ+RSSRD/ewX0MX2fijDLzAtjNrzQcbRPwEuHPsN+jOF+Fpr/zFLizRVswMqA
         u5jOIP7yvz+Y5m1lUX6uyd8/pDp32MTx3dty0RqBCaIOLhFEPIXXMB9P+kRlw/lr0mH1
         ZcHtm+MahnGGod8n5fPOW26MPvPci/1Ytrb/2nieQXlEKIL0TKqc6k3NIpd0RNJ+oLtW
         czwGZHL0LyTMMK6FeYZ27hu+J0o4WUIiVMfBZQp3w4s7N2AlxHVGP24CiJdArTOkj+Eg
         q1EQ==
X-Gm-Message-State: AC+VfDyLX2BuHkh4aFNGK26BX314fG/ObUrL0oN1AZntY4cvyuFefu+g
	qh212MXodUHR23uKtoiiBiVsjcQ1xeXv5ySQ+I4=
X-Google-Smtp-Source: ACHHUZ4O9sGRBqgdIvzlQtle6ibcX2E+EZTJHxYbibiposWnXAAdXtZG/bo0/tTVfYuWlkVEghklzIbF9UkIBbK2EFg=
X-Received: by 2002:a2e:921a:0:b0:2b1:e943:8ab1 with SMTP id
 k26-20020a2e921a000000b002b1e9438ab1mr129986ljg.34.1685939470591; Sun, 04 Jun
 2023 21:31:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <40df61cc5bebe94e4d7d32f79776be0c12a37d61.1685746295.git.chunkeey@gmail.com>
 <xh2nnmdasqngkycxqvpplxzwu5cqjnjsxp2ssosaholo5iexti@7lzdftu6dmyi>
 <802305c6-10b6-27e6-d154-83ee0abe3aeb@gmail.com> <6uu5s53xi6b7s5yzjfrl7fh3pxotoyge2iyt3avwggwrn3i6vc@xywb2jpqxfro>
In-Reply-To: <6uu5s53xi6b7s5yzjfrl7fh3pxotoyge2iyt3avwggwrn3i6vc@xywb2jpqxfro>
From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date: Mon, 5 Jun 2023 01:30:58 -0300
Message-ID: <CAJq09z5+QdQVgMX1+icdBKW4xGY0fr99C41R-VBRuNc2uSco7w@mail.gmail.com>
Subject: Re: [PATCH v1] net: dsa: realtek: rtl8365mb: add missing case for
 digital interface 0
To: =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc: Christian Lamparter <chunkeey@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linus.walleij@linaro.org" <linus.walleij@linaro.org>, "andrew@lunn.ch" <andrew@lunn.ch>, 
	"olteanv@gmail.com" <olteanv@gmail.com>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > The patch "net: dsa: realtek: rtl8365mb: rename extport to extint" mentioned
> > removed:
> >
> > -#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extport)   \
> > -               (RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 + \
> > -                ((_extport) >> 1) * (0x13C3 - 0x1305))
> >
> > and replaced it with:
> >
> > +#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extint) \
> > +               ((_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 : \
> > +                (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1 : \
> > +                0x0)
> >
> > so with the old RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(0) evaluated to
> > (RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0+(0) (which is 0x1305) and
> > since the patch RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(0) evaluates to
> > 0. So the driver writes to somewhere it shouldn't (in my RTL8363SB)
> > case.
>
> Ah yes, I see what you mean now. OK, so 0 is indeed valid. Please include this
> extra info in your v2 message :)

Yes, the vendor rtl8367c driver does use it for both ext0 and ext1.

if(0 == id || 1 == id)
        {
                ...RTL8367C_REG_DIGITAL_INTERFACE_SELECT...
        }
        else
        {
                ...RTL8367C_REG_DIGITAL_INTERFACE_SELECT_1
        }

But being in the vendor driver does not automatically mean there is a
model that supports that interface, as drivers usually evolve from
previous generation drivers, sometimes leaving unused references
behind. As we didn't have a device supported that used ext0, I
deliberately left it out. There are other features that are not
included in the driver until a device requires them.

But being in the vendor driver does not automatically mean there is a
model that supports that interface as drivers normally grow from
previous generation drivers, sometimes leaving references not used
anymore. As we didn't have a device supported that used ext0, I
deliberately left it out. There are other features not included in the
driver until a device does require it.

> Also I suggest marking REG0 as EXT0 and EXT1, something like this:
>
> #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0         0x1305 /* EXT0/EXT1 */
>
> >
> > so that's why I said it was "by accident" in the commit message.
> > Since the other macros stayed intact.
>
> Yes, agree. Do you agree with me though that this doesn't warrant backporting to
> stable as there is no functional change with just the patch on its own?
> i.e. this should be part of a broader series adding RTL8363SB-CG support
> targetting net-next. (The Fixes: tag is absolutely fine ofc - stable maintainers
> will tell you that this does not necessarily mean it should go in stable, that's
> what cc: stable@vger is for). If so please add [PATCH v2 net-next] so it goes in
> the right place.
>
> >
> > From what I can gleam, Luiz patch mentions at the end:
> > "[...] and ext_id 0 does not seem to be used as well for this family."
>

When I say "family", I mean:

RTL8363NB
RTL8364NB
RTL8365MB-VC
RTL8367RB-VB
RTL8367SB
RTL8367S
RTL8366SC
RTL8363SC
RTL8370MB
RTL8310SR
RTL8363NB-VB
RTL8364NB-VB
RTL8363SC-VB

And your device is:

RTL8363SB

Realtek product names do not help too much to limit which device is
closer to which other. I'm not saying for sure that none of those I
listed does not use ext0 (I was at the time, but not now without
reviewing lots of docs/code), but it looks like your device is from a
previous generation. And if rtl8365mb.c does work, that's great. We
are expanding the family.

> > Looking around in todays OpenWrt's various DTS. There are these devices:
> >
> > extif0:
> > TP-Link WR2543-v1
> > SFR Neufbox 6 (Sercomm)
> > Edimax BR-6475nD
> > Samsung CY-SWR1100
> > (Netgear WNDAP660 + WNDAP620)

I didn't check all devices but I own a TP-Link WR2543-v1. I'm not sure
if RTL8367R in TP-Link WR2543-v1 is compatible with rtl8365mb.c
driver. In OpenWrt, we have all these realtek swconfig drivers:
- rtl8366
- rtl8366s
- rtl8366rb (should support the same device as DSA rtl8366rb.c driver
but not used there yet)
- rtl8367 (compatible with RTL8367R and RTL8367M)
- rtl8367b
- rtk-gsw / rtl8367c / rtl8367s_gsw (this one is actually the vendor
driver for the same rtl8365mb.c family but statically configured for
rtl8367s)

You can compare rtl8367.c with rtl8367b.c to get an idea of what would
be needed to change in the rtl8365mb.c to include support for those
devices supported by rtl8367 (if the CPU tag is compatible). The only
models I'm sure rtl8365mb.c will work out-of-box are those using the
rtk-gsw (compatible string) because they are only using the RTL8367S
chip. You can see that driver in the mediatek target at
target/linux/mediatek/files/drivers/net/phy/rtk/. The ones using
swconfig rtl8367b might work with rtl8365mb.c as your device was
compatible with that driver and it seems to be working with
rtl8365mb.c after some adjustments. BTW, even RTL8367S was working
with swconfig rtl8367b with some minor touches (see
https://github.com/openwrt/openwrt/pull/2174/files).

Regards,

Luiz

