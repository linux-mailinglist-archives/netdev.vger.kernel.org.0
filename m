Return-Path: <netdev+bounces-5839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B25871316A
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CADF12819DF
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 01:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E65B382;
	Sat, 27 May 2023 01:17:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1147F381
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 01:17:15 +0000 (UTC)
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF5D9;
	Fri, 26 May 2023 18:17:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-253e0edc278so1056966a91.3;
        Fri, 26 May 2023 18:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685150234; x=1687742234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1MUhZ8AL6v7HF/BFevblX8J8zc/hH+SzAnUSc+lhMQ=;
        b=nqALSochM+eKhBXjgMGjKh7FPSpAyPYZn8UU0ZPfjG2054Sy0paJLOU27V7UJZIPqQ
         ZNVjgklIoVJaqr+SUvFiuYhaAWiNvdXJXDZAHX44aOJj5Hbr2abnzGIZaSiAILwvJcd/
         q/Q1jHY7cQ9zQT74EyvQrmWnROA7mY0/BFg66ubdRgD0J0XrPkA1eA0kjciJRWoncDvj
         ANHdkrxtFkPVid+VZ+NHCQYMF6t4sR3jjly4dCDGSGKYK1HjP2M6rWnZ4rNa5DwXm/z+
         ApBXUdRKVk+LTBQU9CbP9w7vP/ODiFHc8t3toJKsKIHWwg+dnQYUeooGrGf2g4PNRPRD
         BcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685150234; x=1687742234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1MUhZ8AL6v7HF/BFevblX8J8zc/hH+SzAnUSc+lhMQ=;
        b=au6n71BKP0Y+UD+8Xx0/m87zZmGDCwr7SXeoCQfLzdrGE1qw1PfKAcFNXA5W1Xvgg9
         8q0BlxoULFz2ifR5SlxBkSVrnmmdFlKvG7P50aEGsrgpZ2O0066AHApsOwu4rTNqv7fr
         NiAaFq/dAEQst0RrBVx9TFF7JEG9mkL1cqChxVVRJ9wI1FlqymRS7+555k6bKgucmJ4h
         QrQszWKpR6PijjD3Wp/1d7Vc0BP3QgMvLqLkSl0zZK/noiB6MebbCdzYRMRSSr3R4uKY
         neiCAbiQmk+Nu/0mTRSgfq046uwwpJQKfnhop1lx4Do7t52baHnDfjMXglwoP2d0fCht
         Z9ow==
X-Gm-Message-State: AC+VfDwVsNhOn0fdotxKqtInXbWW8f/8HzkA7T0sY5t2llhUj/2Y287b
	SffMUcyfthXz2oJalbayECk=
X-Google-Smtp-Source: ACHHUZ7JiSpzKbE0ei9eGYmMk8rPwz9hzFvivVfknmDhWXhTsnvYRkjRRKla1WAtogfK/hFols8vkg==
X-Received: by 2002:a17:90a:9105:b0:253:94c7:4609 with SMTP id k5-20020a17090a910500b0025394c74609mr3863757pjo.44.1685150233669;
        Fri, 26 May 2023 18:17:13 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id q2-20020a17090ad38200b0025063e893c9sm1710887pju.55.2023.05.26.18.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 18:17:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 7374C1069DF; Sat, 27 May 2023 08:17:10 +0700 (WIB)
Date: Sat, 27 May 2023 08:17:10 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Sami Korkalainen <sami.korkalainen@proton.me>,
	Linux Stable <stable@vger.kernel.org>
Cc: Linux Regressions <regressions@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [REGRESSION][BISECTED] Boot stall from merge tag 'net-next-6.2'
Message-ID: <ZHFaFosKY24-L7tQ@debian.me>
References: <GQUnKz2al3yke5mB2i1kp3SzNHjK8vi6KJEh7rnLrOQ24OrlljeCyeWveLW9pICEmB9Qc8PKdNt3w1t_g3-Uvxq1l8Wj67PpoMeWDoH8PKk=@proton.me>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SRbjNOAccUE98jZ9"
Content-Disposition: inline
In-Reply-To: <GQUnKz2al3yke5mB2i1kp3SzNHjK8vi6KJEh7rnLrOQ24OrlljeCyeWveLW9pICEmB9Qc8PKdNt3w1t_g3-Uvxq1l8Wj67PpoMeWDoH8PKk=@proton.me>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--SRbjNOAccUE98jZ9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 26, 2023 at 07:17:26PM +0000, Sami Korkalainen wrote:
> Linux 6.2 and newer are (mostly) unbootable on my old HP 6730b laptop, th=
e 6.1.30 works still fine.
> The weirdest thing is that newer kernels (like 6.3.4 and 6.4-rc3) may boo=
t ok on the first try, but when rebooting, the very same version doesn't bo=
ot.
>       =20
> Some times, when trying to boot, I get this message repeated forever:
> ACPI Error: No handler or method for GPE [XX], disabling event (20221020/=
evgpe-839)
> On newer kernels, the date is 20230331 instead of 20221020. There is also=
 some other error, but I can't read it as it gets overwritten by the other =
ACPI error, see image linked at the end.
>=20
> And some times, the screen will just stay completely blank.
>=20
> I tried booting with acpi=3Doff, but it does not help.
>       =20
> I bisected and this is the first bad commit 7e68dd7d07a2
> "Merge tag 'net-next-6.2' of git://git.kernel.org/pub/scm/linux/kernel/gi=
t/netdev/net-next"

I think networking changes shouldn't cause this ACPI regression, right?

>       =20
> As the later kernels had the seemingly random booting behaviour (mentione=
d above), I retested the last good one 7c4a6309e27f by booting it several t=
imes and it boots every time.
>=20
> I tried getting some boot logs, but the boot process does not go far enou=
gh to make any logs.
>=20
> Kernel .config file: https://0x0.st/Hqt1.txt
>     =20
> Environment (outputs of a working Linux 6.1 build):
> Software (output of the ver_linux script): https://0x0.st/Hqte.txt
> Processor information (from /proc/cpuinfo): https://0x0.st/Hqt2.txt
> Module information (from /proc/modules): https://0x0.st/HqtL.txt
> /proc/ioports: https://0x0.st/Hqt9.txt
> /proc/iomem:   https://0x0.st/Hqtf.txt
> PCI information ('lspci -vvv' as root): https://0x0.st/HqtO.txt
> SCSI information (from /proc/scsi/scsi)

Where is SCSI info?

>=20
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
> Vendor: ATA      Model: KINGSTON SVP200S Rev: C4
> Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
> Vendor: hp       Model: CDDVDW TS-L633M  Rev: 0301
> Type:   CD-ROM                           ANSI  SCSI revision: 05
>       =20
> Distribution: Arch Linux
> Boot manager: systemd-boot (UEFI)
>=20
> git bisect log: https://0x0.st/Hqgx.txt
> ACPI Error (sorry for the dusty screen): https://0x0.st/HqEk.jpeg
>=20
> #regzbot ^introduced 7e68dd7d07a2
>=20
> Best regards
> Sami Korkalainen

Anyway, I also Cc: netdev and acpi lists and maintainers (maybe they have
idea on what's going on here) and also fixing up regzbot entry title:

#regzbot title: Boot stall with ACPI error (no handler/method for GPE) caus=
ed by net-next 6.2 pull

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--SRbjNOAccUE98jZ9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHFaEgAKCRD2uYlJVVFO
o6ZFAP0ecQWNJK9MUFvbYpR/JcZDhn/3RVSBKUgZPHz4eMATbgD+KWLUd6gawDB7
HVS/T0127pVJOVzbN00GRUC9OCir9Q4=
=qIsL
-----END PGP SIGNATURE-----

--SRbjNOAccUE98jZ9--

