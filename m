Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6DE2A4B4E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgKCQZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbgKCQZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 11:25:11 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A574C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 08:25:11 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id x13so14052318pgp.7
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 08:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DCqGOaSpOYDg3nulmmQ7Bw6iG4PewjSeOIR0EBEtfpc=;
        b=BFt4ch0tDAAv2ApradrbvLwFnVCFVq/obIvfx6p2cPgv/mFj88ZZGwsB73/684P2OA
         SJvq37H6qdFtnJWXhk1wdewy9NU4WP6ZpVPIUmAlmDj4uuZ9m0y7on7FEPwPeUTxZs/M
         ok2Ncix8yuLA5CIyNfVlN5WQH9SwbU7mWaOr22G9ejfVKnMmUipGfoE2FVN7NO7dtywz
         gdPrBOD733AtQyYO9ESUplfQ+YbHtrl8syXc9wipC4kEaxF/9ii+96CuTPM4RqraFmZp
         rS4YrQ44ePPl4ElVOM7FcATQtoc6gdPT1PTF+85yhl/6QJDOXh+jXNeUf66khvXCYrIf
         C7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DCqGOaSpOYDg3nulmmQ7Bw6iG4PewjSeOIR0EBEtfpc=;
        b=ZEKoKoBUAvc7G2dguqHfNP+vdz84YZMvziS9W2BXyE2eJ3xHeK+e39tJjD2RSO27GY
         rcNvzDk0D3/LM6TxWcnHT58l5z/fM9ehrKSgUpmnq9Fwru/eyktzGGxnUymtbtecJoYT
         8KE0SQKbxpZkBDuQMabVYftldJr1XqN5BeOjb1ZZt8OZTXr9llV7xcQ3u6eBUVjnfDvW
         RZceUMN+pmbmo7SZ8+ApnO3N/MKR3b5lO0IKtzdxz2yH9gsi6L1gXzNiG5fKWfZ8FDtK
         A10HKOinjlCesx9VyM491QXhSsPt525rpcVLd9r1N34rDG4qedSAmAWYr1M0MX4m9+m7
         Timw==
X-Gm-Message-State: AOAM531caaESAJSIHAYmA7wt/+5Ta08NPEfioyuXJFpS1FhvPzYUXsy4
        GiGi51LNyuX06Ti+5Q8hBhZQEA==
X-Google-Smtp-Source: ABdhPJxEDr9DNCT2KoanSq6dxKO0u7gOeFDWW6OxajP8CFSIErpU/jwkIGROUhX9z7/ReOPhzPbLJQ==
X-Received: by 2002:a17:90b:e8e:: with SMTP id fv14mr617332pjb.94.1604420710544;
        Tue, 03 Nov 2020 08:25:10 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d10sm15978110pgk.74.2020.11.03.08.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:25:10 -0800 (PST)
Date:   Tue, 3 Nov 2020 08:25:01 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Jakub Kicinski' <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] drivers: net: sky2: Fix -Wstringop-truncation
 with W=1
Message-ID: <20201103082501.39eac063@hermes.local>
In-Reply-To: <c3c5682a5953429987bb5d30d631daa7@AcuMS.aculab.com>
References: <20201031174028.1080476-1-andrew@lunn.ch>
        <20201102160106.29edcc11@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c3c5682a5953429987bb5d30d631daa7@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 10:19:55 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> From: Jakub Kicinski
> > Sent: 03 November 2020 00:01
> >=20
> > On Sat, 31 Oct 2020 18:40:28 +0100 Andrew Lunn wrote: =20
> > > In function =E2=80=98strncpy=E2=80=99,
> > >     inlined from =E2=80=98sky2_name=E2=80=99 at drivers/net/ethernet/=
marvell/sky2.c:4903:3,
> > >     inlined from =E2=80=98sky2_probe=E2=80=99 at drivers/net/ethernet=
/marvell/sky2.c:5049:2:
> > > ./include/linux/string.h:297:30: warning: =E2=80=98__builtin_strncpy=
=E2=80=99 specified bound 16 equals destination =20
> > size [-Wstringop-truncation] =20
> > >
> > > None of the device names are 16 characters long, so it was never an
> > > issue, but reduce the length of the buffer size by one to avoid the
> > > warning.
> > >
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > ---
> > >  drivers/net/ethernet/marvell/sky2.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethern=
et/marvell/sky2.c
> > > index 25981a7a43b5..35b0ec5afe13 100644
> > > --- a/drivers/net/ethernet/marvell/sky2.c
> > > +++ b/drivers/net/ethernet/marvell/sky2.c
> > > @@ -4900,7 +4900,7 @@ static const char *sky2_name(u8 chipid, char *b=
uf, int sz)
> > >  	};
> > >
> > >  	if (chipid >=3D CHIP_ID_YUKON_XL && chipid <=3D CHIP_ID_YUKON_OP_2)
> > > -		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz);
> > > +		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz - 1); =20
> >=20
> > Hm. This irks the eye a little. AFAIK the idiomatic code would be:
> >=20
> > 	strncpy(buf, name..., sz - 1);
> > 	buf[sz - 1] =3D '\0';
> >=20
> > Perhaps it's easier to convert to strscpy()/strscpy_pad()?
> >  =20
> > >  	else
> > >  		snprintf(buf, sz, "(chip %#x)", chipid);
> > >  	return buf; =20
>=20
> Is the pad needed?
> It isn't present in the 'else' branch.

Since this is non-critical code and is only ther to print something useful
on boot, why not just use snprintf on both sides of statement?

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/mar=
vell/sky2.c
index 25981a7a43b5..96edad30006e 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4900,7 +4900,7 @@ static const char *sky2_name(u8 chipid, char *buf, in=
t sz)
        };
=20
        if (chipid >=3D CHIP_ID_YUKON_XL && chipid <=3D CHIP_ID_YUKON_OP_2)
-               strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz);
+               snprintf(buf, sz, name[chipid - CHIP_ID_YUKON_XL]);
        else
                snprintf(buf, sz, "(chip %#x)", chipid);
        return buf
