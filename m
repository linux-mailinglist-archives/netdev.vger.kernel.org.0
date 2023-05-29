Return-Path: <netdev+bounces-6174-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B635715099
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 22:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD5F280EE1
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA80ABE57;
	Mon, 29 May 2023 20:35:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94E228E7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 20:35:21 +0000 (UTC)
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5E2C7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:35:19 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-6261a25e9b6so8799346d6.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685392518; x=1687984518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYgzqVuFnwlRpQKhcz2e4X+nRo84gqfsUFC8ZJMPzPg=;
        b=PnC0D0PFo/XRDLB7Eil1Qnm0utLHsun3r+3eMIyICRaUV9AzlHTGW4tPPFzCdItX5d
         77EMhqsBQ3XcPymWdtargzlLffra47OJXIQthgC2+c0g7cen4TpBIUm8HMa0OxRuxpmD
         fBQ2emIRDIG0yk0W4rQhfcQOzS5N5zXgX3iTb/ttaVgdPcLe33S5RjS8cI9advKbU4bC
         AYovdra7zN4S4vR/evJX3DoxgCPp5wTcxq7eUVVue3eq9Rmbg53FEH2qdfpmUx4KTbL1
         Nq8KDkATen9jNcWBimim6TgRRVAhG34ZTYuhbvT7n28XvjDDKWX5KCbB+XN3mgj9p0XF
         ituQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685392518; x=1687984518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MYgzqVuFnwlRpQKhcz2e4X+nRo84gqfsUFC8ZJMPzPg=;
        b=FV+Q6KnYxQs886Q1dEq118amA4+ssziREdY6k/SKCMPmYaOkWEu6TqqGFE5vET92OA
         AD9WgANcmcWWdHPoFlZpEUSMVe2SlFbRh72Z2PsHhjtKS8IU1RnBTEzWYOvgHgqFbjYo
         xuaW0Z+OQtVrR8JHSriFHiUWD/WeRL5/VOqg1XfimhiZny0Oq0AtpNfOflYcEwMNoASw
         j9iHq7G98K2yY8aW5UK/X4xe6EzWR/ENGm7+N9mIdasX47kEbmNCRtct5U+uvZBnzidM
         9BbWwXwHY0kmPN+DF4lB6MzxtxCXXVwIB8vG47eR39iUDL4wxPTgsBeJzZEYnB36V9Up
         cY2g==
X-Gm-Message-State: AC+VfDzAGWF0Atkvq04zClAGOsX2t+/bcHJY7sE0OcJnSNDHnQDKSOHR
	1TgdqiUn1wflBxhrJixapxPU/oon/kvp6HBmQq0=
X-Google-Smtp-Source: ACHHUZ5ULw5veFcE4N5JC50uFwmpE1wojFpUBojt2NAbwqpjhGX6Lli/AZQaJVG2h4OFQyQAwQQXLc9GpzhKCvGIPec=
X-Received: by 2002:ad4:596a:0:b0:625:e039:5af1 with SMTP id
 eq10-20020ad4596a000000b00625e0395af1mr11712820qvb.42.1685392518548; Mon, 29
 May 2023 13:35:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk> <E1q2USm-008PAO-Gx@rmk-PC.armlinux.org.uk>
 <ZHD4Yaf7fgtgOgTS@surfacebook> <e2c558cf-430d-40df-8829-0f68560bd22f@lunn.ch>
In-Reply-To: <e2c558cf-430d-40df-8829-0f68560bd22f@lunn.ch>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 29 May 2023 23:34:42 +0300
Message-ID: <CAHp75Ve3+LsLA1x+zBLCxt7M3f1tL0bUquiG3o8-=0V3gs5_pw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] net: mdio: add mdio_device_get() and mdio_device_put()
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>, Heiner Kallweit <hkallweit1@gmail.com>, 
	Jiawen Wu <jiawenwu@trustnetic.com>, Maxime Chevallier <maxime.chevallier@bootlin.com>, 
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 6:21=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
> On Fri, May 26, 2023 at 09:20:17PM +0300, andy.shevchenko@gmail.com wrote=
:
> > Fri, May 26, 2023 at 11:14:24AM +0100, Russell King (Oracle) kirjoitti:

...

> > > +static inline void mdio_device_get(struct mdio_device *mdiodev)
> > > +{
> > > +   get_device(&mdiodev->dev);
> >
> > Dunno what is the practice in net, but it makes sense to have the patte=
rn as
> >
> >       if (mdiodev)
> >               return to_mdiodev(get_device(&mdiodev->dev));
> >
> > which might be helpful in some cases. This approach is used in many cas=
es in
> > the kernel.
>
> The device should exist. If it does not, it is a bug, and the
> resulting opps will help find the bug.

The main point in the returned value, the 'if' can be dropped, it's
not a big deal.

--=20
With Best Regards,
Andy Shevchenko

