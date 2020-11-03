Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD52A4B60
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgKCQ05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgKCQ05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 11:26:57 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7716C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 08:26:55 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 10so14660774pfp.5
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 08:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q7Rr4h8jgG1g6dQ43vyn0f2NKcgPO6Gve7klvtnHf0s=;
        b=J9ubuYTM4wXgexKGDyx5JYciBXJNq0bbFDgdls7EoQCTwbFKHnSAFD2TJI7Ec5JX7O
         OZ4cbbmq6crrPt6VjKIcQC/RLqUJM3Aa2j1/10lEFq9e5xHbSB6J6+fQLfTiBOmbltgh
         ZC3ziJAx++D8HuedDZY3W/rKv+ovwl0XhCa07vUY2ySXj6XYetFv8MBDNn++2FVLoqY0
         ufydQyey3HndJhOz6tgv37fVcgskiJexE0dq56W6ewvwzpWbY2N+ykiFpB8jRCLp0bJV
         Kv4VFnZRVulH17R/J/AftSTYYxV6GGKzgVbARYA/4goaPRHRHYfp95PZ/Pzktqf4PzMM
         A8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q7Rr4h8jgG1g6dQ43vyn0f2NKcgPO6Gve7klvtnHf0s=;
        b=ht++hhOzZV7y23P+9tA4UBEMZGzT+k3ZSj5kIbGRaOM+0YHKZSqUgOElcJuMOQQrtG
         ZnTiC2xq+mx23hcmuAHDFt8JGkfr4AhikAmp4eBF2QO+eagyPQAJJ5ZFviDBe+N/9O+/
         fNB+RMY88byvU5mkUVq3T9hbx8Tq/hcHle/89pdgDpa1R24Dzbtt6KVEI2tAwPVvjDqK
         1/Aom+dtL8Nyp0ubUGqdkuBeDWO9+cdNNqNGSE75VYp63gHi/OrrWA1y2ZwUf1s5N54v
         vsYrxO6FKCjsoyqL2AAPRb3JlqzQPGrNmwZonkFf2rs3TBjrdEOgvU2vnwOY5te7eRtm
         ZPNg==
X-Gm-Message-State: AOAM533PEiq1JyJOV09YyNDv4oz55CdqvjxdkhSmrDqm124en0GzP9FR
        s7k4miDXAXqPGMC0aonP1jxKVuJqYCpyJbYU
X-Google-Smtp-Source: ABdhPJxhWx9gl1NqmlYxOuedOUHwo24YYmoR7jGHmEWzaFrLQP3vF93L//QdiIgl3Rer2/IANGNWKQ==
X-Received: by 2002:aa7:950b:0:b029:18a:df47:ef90 with SMTP id b11-20020aa7950b0000b029018adf47ef90mr11941628pfp.74.1604420815400;
        Tue, 03 Nov 2020 08:26:55 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id lk13sm3345000pjb.43.2020.11.03.08.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:26:55 -0800 (PST)
Date:   Tue, 3 Nov 2020 08:26:51 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Jakub Kicinski' <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] drivers: net: sky2: Fix -Wstringop-truncation
 with W=1
Message-ID: <20201103082651.7edadae6@hermes.local>
In-Reply-To: <20201103082501.39eac063@hermes.local>
References: <20201031174028.1080476-1-andrew@lunn.ch>
        <20201102160106.29edcc11@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c3c5682a5953429987bb5d30d631daa7@AcuMS.aculab.com>
        <20201103082501.39eac063@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 08:25:01 -0800
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Tue, 3 Nov 2020 10:19:55 +0000
> David Laight <David.Laight@ACULAB.COM> wrote:
>=20
> > From: Jakub Kicinski =20
> > > Sent: 03 November 2020 00:01
> > >=20
> > > On Sat, 31 Oct 2020 18:40:28 +0100 Andrew Lunn wrote:   =20
> > > > In function =E2=80=98strncpy=E2=80=99,
> > > >     inlined from =E2=80=98sky2_name=E2=80=99 at drivers/net/etherne=
t/marvell/sky2.c:4903:3,
> > > >     inlined from =E2=80=98sky2_probe=E2=80=99 at drivers/net/ethern=
et/marvell/sky2.c:5049:2:
> > > > ./include/linux/string.h:297:30: warning: =E2=80=98__builtin_strncp=
y=E2=80=99 specified bound 16 equals destination   =20
> > > size [-Wstringop-truncation]   =20
> > > >
> > > > None of the device names are 16 characters long, so it was never an
> > > > issue, but reduce the length of the buffer size by one to avoid the
> > > > warning.
> > > >
> > > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > > ---
> > > >  drivers/net/ethernet/marvell/sky2.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethe=
rnet/marvell/sky2.c
> > > > index 25981a7a43b5..35b0ec5afe13 100644
> > > > --- a/drivers/net/ethernet/marvell/sky2.c
> > > > +++ b/drivers/net/ethernet/marvell/sky2.c
> > > > @@ -4900,7 +4900,7 @@ static const char *sky2_name(u8 chipid, char =
*buf, int sz)
> > > >  	};
> > > >
> > > >  	if (chipid >=3D CHIP_ID_YUKON_XL && chipid <=3D CHIP_ID_YUKON_OP_=
2)
> > > > -		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz);
> > > > +		strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz - 1);   =20
> > >=20
> > > Hm. This irks the eye a little. AFAIK the idiomatic code would be:
> > >=20
> > > 	strncpy(buf, name..., sz - 1);
> > > 	buf[sz - 1] =3D '\0';
> > >=20
> > > Perhaps it's easier to convert to strscpy()/strscpy_pad()?
> > >    =20
> > > >  	else
> > > >  		snprintf(buf, sz, "(chip %#x)", chipid);
> > > >  	return buf;   =20
> >=20
> > Is the pad needed?
> > It isn't present in the 'else' branch. =20
>=20
> Since this is non-critical code and is only ther to print something useful
> on boot, why not just use snprintf on both sides of statement?

Like this is what I meant...
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/mar=
vell/sky2.c
index 25981a7a43b5..ebe1406c6e64 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4900,7 +4900,7 @@ static const char *sky2_name(u8 chipid, char *buf, in=
t sz)
        };
=20
        if (chipid >=3D CHIP_ID_YUKON_XL && chipid <=3D CHIP_ID_YUKON_OP_2)
-               strncpy(buf, name[chipid - CHIP_ID_YUKON_XL], sz);
+               snprintf(buf, sz, "%s", name[chipid - CHIP_ID_YUKON_XL]);
        else
                snprintf(buf, sz, "(chip %#x)", chipid);
        return buf;


