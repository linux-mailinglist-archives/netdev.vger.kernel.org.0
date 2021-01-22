Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BA02FF9C2
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbhAVBEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbhAVBE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 20:04:26 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D54C06174A;
        Thu, 21 Jan 2021 17:03:46 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b8so2275719plh.12;
        Thu, 21 Jan 2021 17:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lw4cm+7RXhLgXHhIgHAntQuy6SsZDwNqhL+qH8M4o3Q=;
        b=XhdA9ei1rorZZbjDB1bxDSifSMzivWAG6Z/YPsqR6QqmUxc6VTdh+WLbjCztj5VjV2
         Y+dKEpFeuWM2An1Evn24rEmp+5Z1dm7qpRCibEQ+1GbNwX1r9T5/Gx9nSURWWwbIIe2r
         HfM82xGGVz+LObwR71Pbjpi2+oRPfDZQWmV9/DV6mcUFtH+iaAEuh/XYNUYmanyIPwXg
         ATzqC2zmij1Tegt2Xv3ZP71dx/wTol+Zu5oxZfoID7vldOsjrt6OxnB20MrihUv46wT5
         9Qbw8tCFYnUVghfTteSJg3nWRppmB8WPscLwqjlcs2JIeH8v07/c+Q9k08CQy2bIBPMN
         fXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lw4cm+7RXhLgXHhIgHAntQuy6SsZDwNqhL+qH8M4o3Q=;
        b=HOA6o1HkBG9t+R1vfk89GuC6qTiMgzzVu3SmXhDzN4KAbya9dKaKG4hbfPuwMWE4ys
         43eOuIBhCofQDs5RRUUmSH/z2f+E65fXj2PO8L0tz09PYN0BWklD1fdRpK072oGF0tSV
         u0l79cdWgkVYu43JHR63hUB64CZZOQ+7an3giSgSVRZTwfTcE1JOq9qMZ5si3ZMc310J
         mkilybkFgqbaFPXZgcZgQxlS8w7eZ8bPg7mLYOK6Hfn3e8C+bC5rVKOhjHENznj1bTOQ
         uSPIOIOG7n9ih5TsBfOjKFrjweBEIkUjS4NDWOsmhynG8C2/nrHL5API8E5MP7mqsuw4
         8i8g==
X-Gm-Message-State: AOAM530EdHrzRMj3PcYjJvddiszCN0pNQ17jFaEMXmiOGjJw4ETCe5XD
        gpfrdgajeGNqZW3r4NBKIag=
X-Google-Smtp-Source: ABdhPJzmb7nke4O74Aga3Has5vmSGhKK4Sa5I6pQqAuiHRHYi6rZ29DGdsXsL8nJ1Ji6VskHwOhaDA==
X-Received: by 2002:a17:90a:5513:: with SMTP id b19mr2363941pji.99.1611277425889;
        Thu, 21 Jan 2021 17:03:45 -0800 (PST)
Received: from shinobu (113x33x126x33.ap113.ftth.ucom.ne.jp. [113.33.126.33])
        by smtp.gmail.com with ESMTPSA id e3sm6395565pgs.60.2021.01.21.17.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 17:03:44 -0800 (PST)
Date:   Fri, 22 Jan 2021 10:03:32 +0900
From:   William Breathitt Gray <vilhelm.gray@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pau Oliva Fora <pof@eslack.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v1 0/2] isa: Make the remove callback for isa drivers
 return void
Message-ID: <YAokZMNkgVfJ+csC@shinobu>
References: <20210121204812.402589-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PZu/ILMf5FNwdU4R"
Content-Disposition: inline
In-Reply-To: <20210121204812.402589-1-uwe@kleine-koenig.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PZu/ILMf5FNwdU4R
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 09:48:10PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> Hello,
>=20
> as described in the commit log of the 2nd patch returning an error code
> from a bus' remove callback doesn't make any difference as the driver
> core ignores it and still considers the device removed.
>=20
> So change the remove callback to return void to not give driver authors
> an incentive to believe they could return an error.
>=20
> There is only a single isa driver in the tree (assuming I didn't miss
> any) that has a remove callback that can return a non zero return code.
> This is "fixed" in the first patch, to make the second patch more
> obviously correct.
>=20
> Best regards
> Uwe
>=20
> Uwe Kleine-K=C3=B6nig (2):
>   watchdog: pcwd: drop always-false if from remove callback
>   isa: Make the remove callback for isa drivers return void
>=20
>  drivers/base/isa.c                   | 2 +-
>  drivers/i2c/busses/i2c-elektor.c     | 4 +---
>  drivers/i2c/busses/i2c-pca-isa.c     | 4 +---
>  drivers/input/touchscreen/htcpen.c   | 4 +---
>  drivers/media/radio/radio-sf16fmr2.c | 4 +---
>  drivers/net/can/sja1000/tscan1.c     | 4 +---
>  drivers/net/ethernet/3com/3c509.c    | 3 +--
>  drivers/scsi/advansys.c              | 3 +--
>  drivers/scsi/aha1542.c               | 3 +--
>  drivers/scsi/fdomain_isa.c           | 3 +--
>  drivers/scsi/g_NCR5380.c             | 3 +--
>  drivers/watchdog/pcwd.c              | 7 +------
>  include/linux/isa.h                  | 2 +-
>  sound/isa/ad1848/ad1848.c            | 3 +--
>  sound/isa/adlib.c                    | 3 +--
>  sound/isa/cmi8328.c                  | 3 +--
>  sound/isa/cmi8330.c                  | 3 +--
>  sound/isa/cs423x/cs4231.c            | 3 +--
>  sound/isa/cs423x/cs4236.c            | 3 +--
>  sound/isa/es1688/es1688.c            | 3 +--
>  sound/isa/es18xx.c                   | 3 +--
>  sound/isa/galaxy/galaxy.c            | 3 +--
>  sound/isa/gus/gusclassic.c           | 3 +--
>  sound/isa/gus/gusextreme.c           | 3 +--
>  sound/isa/gus/gusmax.c               | 3 +--
>  sound/isa/gus/interwave.c            | 3 +--
>  sound/isa/msnd/msnd_pinnacle.c       | 3 +--
>  sound/isa/opl3sa2.c                  | 3 +--
>  sound/isa/opti9xx/miro.c             | 3 +--
>  sound/isa/opti9xx/opti92x-ad1848.c   | 3 +--
>  sound/isa/sb/jazz16.c                | 3 +--
>  sound/isa/sb/sb16.c                  | 3 +--
>  sound/isa/sb/sb8.c                   | 3 +--
>  sound/isa/sc6000.c                   | 3 +--
>  sound/isa/sscape.c                   | 3 +--
>  sound/isa/wavefront/wavefront.c      | 3 +--
>  36 files changed, 36 insertions(+), 79 deletions(-)
>=20
>=20
> base-commit: 5a158981aafa7f29709034b17bd007b15cb29983
> --=20
> 2.29.2

Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com>

--PZu/ILMf5FNwdU4R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEk5I4PDJ2w1cDf/bghvpINdm7VJIFAmAKJFgACgkQhvpINdm7
VJLzPQ/9FPQmfnPF1kWcQikWSXr31BdrY/bU1k3tsN3+yIFcnAkjeW5mH5TGysY8
zpAFfnbdVIMz5er9oBLPRcOztSwitbQeOuLQHNnm5Bf8Vs/BBYahD8iK0Z11CLzU
NaOcLr3iJYTisqqbPjiadkoKUeCh6vizab5oaZUR/5jn6YvtFX1vB3amb2J0600r
mNVDoLHL4BnWW40jTxr12OQF/Z27BGaRqUImGhmgUqvLY8WMz79zGTgg4qHYMujs
MYZxWX9ILt3oXKwFrd58mIcG9cIP9q18ndjkyMdH3sXMMYHPm6vKuVnVHcOjSqBn
sX0ciA2HizGr7V2o1AhQiU3loQEaE3uHZ1t0te/vEqVRLlWlqSevRdNxxpgNk58Y
iQe3J72kgc2Pb3009+FpzMMO4MaGfpNTXBeVP9qurmHmaAGBQLAoNxqmSOFnXx7I
aSmNOW9wTuijQeUWN7WlYGtaRlEldvQlPiPbut8p9M7/5kTkW8GTXxvbJd1ylwwF
Oxz1NxLAEvJN3NuwPoAkywW930fVXy4JJigSwMjKlc+vXvJgGqGP20HqeHKBxTdE
GglZQJ0FunBNAYckgJwTqt6A84+wCwZ/5erqRqsJDipn8qcnQ79YiKjh+L4za0QA
yyItzFeVSsa/lPxJ3OrDiOD2LsTb9hkJhmT5OHPFjwxt++d7KiA=
=WpSs
-----END PGP SIGNATURE-----

--PZu/ILMf5FNwdU4R--
