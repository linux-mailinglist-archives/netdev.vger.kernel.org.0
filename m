Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA056C2C69
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjCUIaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCUI3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:29:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36376EA9;
        Tue, 21 Mar 2023 01:29:10 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so19407298pjt.2;
        Tue, 21 Mar 2023 01:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679387350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XXUITdPjTxXZgKalDA0xTgo8//yYhr32Q41bNu4Ez/I=;
        b=AhMvqsGvSW52LushkG7KnmYCjgnNJMAofkRd/C96q9sEcDUkGrRSuRULw/75WN5XBE
         /H9ZIUVaYEajYP4zFLf5gSQj+AW51LHN2m8UAW6nBTJvP8y7f4KLDyMDQAUa6C0oTuii
         AMFzvKlgBzdqbE31C1xTNdD6y0wa7DrSMX8r/X9pXUIpECDcqSZoVUMMzxbWfK5HczaR
         wFN6Y0DS5Q44Ml9CkIw5zbnyN1HA5yacCTFCWphGHfmp3vBbe3WeYUf+CGucyYPQt/bN
         pxf7tlQ5EsCv+QSNPyUi3R0cGzhyx96+vjBxL0Fu6JxnYiNGZVTOD+6Hdq4bWVKpSWOr
         5s7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679387350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXUITdPjTxXZgKalDA0xTgo8//yYhr32Q41bNu4Ez/I=;
        b=gGq1S8o7UkjFrkDKR1cwtavi+Gtn/XF5aTuxtJiJzNoUIHrbo8qhPc0mC8Z1Rt6u7o
         FVEa3Zmi+w33QiD/MuMiIbLJuqOy23kqzQCkFon+g0M8jeRyoCgD/KlDw726oCA7l8Tc
         Bq8HoQuPYl7tRtWdWgXsShinQajkzkj4h+7juFIdjmPmv3/xqV2+oCkrTSJMw//VYzPk
         El1E2ahv6N/wzedeC9Q4NGafFHuF9ljKWeFtGEDHi8Ch1xuXD7SFOEbAKlcOv1kby9gO
         j/R07y/9AnbnAraKneCUxZIi4aBezwYJihgRG8LAPMwfXhTVAQru9LWjjsuMoMkuk9ys
         g6Gg==
X-Gm-Message-State: AO0yUKXbtxf2pKLC47ZWuyYuCdw5cex1L/jCTXLSfja/4EYGW5+RogVN
        /AuyQzbWv7IYOUVsazDpCjCoVEhnMoA=
X-Google-Smtp-Source: AK7set8HjcCVUfeQbSo2WUVXy+mI5Fu9Z/+H8+RP5SvccdjNqUM9wD2xui2b5Cl3tm1QPR1R/42D5A==
X-Received: by 2002:a17:903:430d:b0:19e:9849:1767 with SMTP id jz13-20020a170903430d00b0019e98491767mr1317620plb.42.1679387350359;
        Tue, 21 Mar 2023 01:29:10 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-83.three.co.id. [180.214.233.83])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902ee5100b0019339f3368asm8137694plo.3.2023.03.21.01.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 01:29:09 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 433CE106648; Tue, 21 Mar 2023 15:29:07 +0700 (WIB)
Date:   Tue, 21 Mar 2023 15:29:07 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>,
        Linux Networking <netdev@vger.kernel.org>
Subject: Re: My TP-Link EX510 AX3000 Dual-Band Gigabit Wi-Fi 6 Router has a
 paper notice on GNU General Public License
Message-ID: <ZBlq0/DbBIPwZK9s@debian.me>
References: <1D-_qNweCAFnkwL_AEoQeM4SEahOqRb9pOD9W5kE3tFzosEIgcNt8qCC8c48lirfo-J3BGXu7QcnZJOtxY8QFPY3RjYLSWwcAEEZedYot7Y=@protonmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8NSeAUHOeQN3VvcF"
Content-Disposition: inline
In-Reply-To: <1D-_qNweCAFnkwL_AEoQeM4SEahOqRb9pOD9W5kE3tFzosEIgcNt8qCC8c48lirfo-J3BGXu7QcnZJOtxY8QFPY3RjYLSWwcAEEZedYot7Y=@protonmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8NSeAUHOeQN3VvcF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 19, 2023 at 02:43:14PM +0000, Turritopsis Dohrnii Teo En Ming w=
rote:
> Good day from Singapore,
>=20
> I have terminated my M1 ISP fiber home broadband with effect from 11 Mar =
2023 Saturday because I need to pay about SGD$42 per month. My M1 fiber bro=
adband contract ends on 11 Mar 2023.
>=20
> Instead I have subscribed to Infocomm Media Development Authority (IMDA) =
Home Access program. This program is for EXTREMELY POOR FAMILIES in Singapo=
re who are living in HDB PUBLIC RENTAL HOUSING PROGRAM. People who live in =
HDB Public Rental Flats (like myself) have very little money in their bank =
accounts and cannot afford to buy even the smallest HDB BTO 2-room apartmen=
t in Singapore. Because even the monies in our Central Provident Fund (CPF)=
 accounts are mediocre/super low.
>=20
> The participating ISP in the IMDA Home Access Program is MyRepublic. Unde=
r the IMDA Home Access program, I only need to pay SGD$14 per month for my =
fiber home broadband.
>=20
> MyRepublic ISP has also given me a *FREE* TP-Link EX510 AX3000 Dual-Band =
Gigabit Wi-Fi 6 Router on 10 Mar 2023 Friday. MyRepublic fiber broadband li=
ne was also activated on the same day. Inside the packaging box there is a =
paper notice on GNU General Public License.
>=20
> I believe my tp-link Wi-Fi 6 wireless router is most likely running on an=
 open source Linux operating system.=20
>=20
> How can I find out what version of the Linux Kernel it is running on? I t=
hink only Linux kernel 6.x support Wi-Fi 6. Am I right?
>=20
> By the way, I live in a HDB 2-room RENTAL apartment in Ang Mo Kio Singapo=
re.

Hi and welcome to LKML!

Looks like this is general Linux support, so you need to refer to support
channels for whatever the distro you're using. LKML, on the other hand,
is highly technical mailing list about Linux kernel development.

If you have kernel problems (like buggy driver), see Documentation/admin-gu=
ide/reporting-issues.rst in the kernel sources for how to properly report t=
he issue.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--8NSeAUHOeQN3VvcF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBlq0gAKCRD2uYlJVVFO
ozubAQCGKWi5e/z8KAYmpTG6hS+h2UpVcTrvJmFRkJ364i6hogD/VM0rLqSBkHqR
x0AjwGuLEV6/1pLDtnChEDdI9q1IQQk=
=DQeW
-----END PGP SIGNATURE-----

--8NSeAUHOeQN3VvcF--
