Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3CA6DBFE2
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDIMqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 08:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjDIMqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 08:46:07 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A1B3C3D
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 05:46:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q2so7399956pll.7
        for <netdev@vger.kernel.org>; Sun, 09 Apr 2023 05:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681044365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a9wL/Pqq62sbSsupYCiRgkxlWWGHnQ1CTbXR/mHQXsA=;
        b=PBrvvTrDvTe4ljo8OMRueh2ApGxKYMzFMdjsLVHSGdMvhwjjySWsurnntzfhlYiRJ2
         p+TAzL2Vb9IYrYdtR8faOd69bnlF28FA6279MnlzU3xfGbPrKy33gCt8TaQIBIvP8RM+
         ZQoSmG3JkfyxMB9/FclZfsHiCgdCDHovWYufoc+B21ybIXClSQBVFsSt+ZyAWBualf+9
         FazKb8uHj8pD9T5WaWNlnNvDu/1M15slgAGLZyxFUd6DVJa5xYTXRseSwuibWK+CN1vW
         83EUxsqjdNheyynH18Pa2/lRaHFh1I3IPNxv1o4w9zjts2m1UeBhLIbQgSy6nWVcCD9x
         v4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681044365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9wL/Pqq62sbSsupYCiRgkxlWWGHnQ1CTbXR/mHQXsA=;
        b=e5YzBEPJ7XbsTwxrZB73bZPJXoiQI2Dp7viaH0niP8C5hsDACy9VEU/MVtyadrDG4a
         jx7jjSPVCPz/P3/xFQS9Kpr6uAQZv2k2Wq8ijLljxuNkHFFiW+gaCqxpmkRWfv822jbN
         xmjDGVIfEuhSeLrfV5xA3JRK1V319KeoSSOML9BnUTeNCumjMNArY3zrkj4RFAUq6gL/
         fTIrk0nd/aSvLTUbMejOsKYQpHmsBANcNRRR904LjBzmpdLCBdKYGgTi8P2LYHdg8F9p
         NFgs9k9L8zDIIMrt8jpIcXlAlJ0MGMNAEZVL78vV7B0Ul2z/i7iI3M49kAcRug2pfrvH
         Oyug==
X-Gm-Message-State: AAQBX9cyGiFfKySQQYpqyBw8qxNHcxqZWASxlH7EulMoFy6lOsWG0oU9
        3pI08egkGBY/KxqchzZx7WM=
X-Google-Smtp-Source: AKy350aFY5DIZrrNuBE6wdzH66vwaq3SLdeABOuPEOEIk3Z7FmJZaSdhPuOXpFqIIFjjDNo6i6Y3Cg==
X-Received: by 2002:a17:903:245:b0:1a1:bfe8:4fae with SMTP id j5-20020a170903024500b001a1bfe84faemr11094510plh.43.1681044365126;
        Sun, 09 Apr 2023 05:46:05 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-11.three.co.id. [116.206.28.11])
        by smtp.gmail.com with ESMTPSA id m4-20020a63fd44000000b004ff6b744248sm5471352pgj.48.2023.04.09.05.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Apr 2023 05:46:04 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7109510679B; Sun,  9 Apr 2023 19:45:59 +0700 (WIB)
Date:   Sun, 9 Apr 2023 19:45:59 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: netdev email issues?
Message-ID: <ZDKzhyCAYdAcu6H9@debian.me>
References: <365242745.7238033.1680940391036@mrd-tw.us-east-1.eo.internal>
 <CAM0EoMkuv=3C_jsn6NEsWoGBBzL2WDSNAOWxTfJ-Oh8xfJs1Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6JJ1WqAfNYVo8wPu"
Content-Disposition: inline
In-Reply-To: <CAM0EoMkuv=3C_jsn6NEsWoGBBzL2WDSNAOWxTfJ-Oh8xfJs1Fg@mail.gmail.com>
X-Spam-Status: No, score=3.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6JJ1WqAfNYVo8wPu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 08, 2023 at 09:48:12AM -0400, Jamal Hadi Salim wrote:
> ---------- Forwarded message ---------
> From: Postmaster <postmaster@dopamine-today.bounceio.net>
> Date: Sat, Apr 8, 2023 at 3:53=E2=80=AFAM
> Subject: Undeliverable: Re: [PATCH v4 net-next 2/9] net/sched: mqprio:
> simplify handling of nlattr portion of TCA_OPTIONS
> To: <jhs@mojatatu.com>
>=20
>=20
> MESSAGE NOT DELIVERED
>=20
> There was an issue delivering your message to got@dopamine.today. This
> is an 5.1.2 Error.
>=20
> This error typically means: The domain name of the email address is not v=
alid

But dig(1)-ing the domain in question shows no error:

```
; <<>> DiG 9.16.37-Debian <<>> dopamine.today
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55123
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;dopamine.today.                        IN      A

;; ANSWER SECTION:
dopamine.today.         300     IN      A       91.195.240.94

;; Query time: 433 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Sun Apr 09 19:41:03 WIB 2023
;; MSG SIZE  rcvd: 59

```

And because of now-frequent this annoying bounce, I have to tell gmail to
block Postmaster of this domain (i.e. the one that send this bounce). Thus,
it is likely that the problem is email routing.

Konstantin, would you like to have a look on this?

--=20
An old man doll... just what I always wanted! - Clara

--6JJ1WqAfNYVo8wPu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZDKzggAKCRD2uYlJVVFO
owbQAP9fJtlc2B++OgFqdgBBNuFoauQFYw/eBc3prOBxoHfGBAD/UH1xWCwYuZBT
BsP1PNbnPTdsGEcHXw2fJ/G17tIqZgo=
=qEKe
-----END PGP SIGNATURE-----

--6JJ1WqAfNYVo8wPu--
