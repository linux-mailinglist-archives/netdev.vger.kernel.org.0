Return-Path: <netdev+bounces-10134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 424F272C6ED
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 773191C20B5E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D8F1B8E7;
	Mon, 12 Jun 2023 14:07:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049821B8E0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:07:39 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE09A1;
	Mon, 12 Jun 2023 07:07:38 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-655d1fc8ad8so3578158b3a.1;
        Mon, 12 Jun 2023 07:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686578858; x=1689170858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B+7S35QW+acZtg4WWUpYFQktRq0VTaZ64Z9p3u7NETI=;
        b=qSQK6e/WaMB/Xqatfc63tiEPAzFpdUezm2kefEGgJwx/0LiPniP7wob/B/ICrs1mcg
         l4kKjwnwv1f/Uef9MAbTklNCB7Rj+x8r7ZRMogEg0iQ0JlENJjOqVKpFUcPqoPRxQhMw
         n+uaMV+pRX3jo+mGEdIkfx1V18BN1A8hJkfMK3IB4n49ASr43nFsqOeqq/GyC1czPMxa
         ulF4Y2T/iposudnh6/ovz6HlvzB1cKDXESTNHhbqADKwhiR+RI9VdEhxLV2SBMuw0Xui
         MSOnpxwv2d8papuYkQXRwR6jNwL+6gQT+7q3m5QHOsGcD4YiHIy02WQ0A/F8lLkW0L0q
         BxVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686578858; x=1689170858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+7S35QW+acZtg4WWUpYFQktRq0VTaZ64Z9p3u7NETI=;
        b=hFERIZq1s6mgwN1aGKkdyd07A/TCl7nq/AX2+GLuTeAGB3vyn9BirsYOrvalfPJCe8
         zBw5lwPLyE014nAjSjzbP9N/voJael/O1By5mmI2gyLvyDIJkI+2y/Vrmsm4LEhbiA5q
         3ArU7P7tsC6n4YaF5jBlX2T5P7FeBPim1f4DWFajuPhZwuobpW+e6bbh/atke/8Wx2WG
         CzY12jouSCjLhKJW7Ec5LEII6tOEBQkTSXp7c+9nHwi68qwjnAY68IDcXd3vL24n2CLs
         hfobSZOS0Zrl5Nr8hV3bqBXPdbb4gfs+FqQIWhI74psC2i8TkBtGSGh/XENyFCdjDOJ/
         l4YA==
X-Gm-Message-State: AC+VfDw2kJ9lrLy/XzKZ2AvLZ98tpy7hwuXewSgd7PhBJinihUNpXuG7
	Ltg0nNfWfIKN3EhnL61KQzk=
X-Google-Smtp-Source: ACHHUZ5upXhNnZ0xatFLuC9i6LDRa9OLgeV+Y3qmM3xfBGZkBs9NfQfUKOgKSXrmA8KEYZCpdp5BPw==
X-Received: by 2002:a05:6a00:180e:b0:659:ae1c:c9e2 with SMTP id y14-20020a056a00180e00b00659ae1cc9e2mr11595513pfa.17.1686578858208;
        Mon, 12 Jun 2023 07:07:38 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-21.three.co.id. [180.214.232.21])
        by smtp.gmail.com with ESMTPSA id e15-20020aa7824f000000b0066355064acbsm6914328pfn.104.2023.06.12.07.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 07:07:37 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 2ADC5106C19; Mon, 12 Jun 2023 21:07:34 +0700 (WIB)
Date: Mon, 12 Jun 2023 21:07:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Sami Korkalainen <sami.korkalainen@proton.me>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Stable <stable@vger.kernel.org>,
	Linux Regressions <regressions@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info>
Subject: Re: [REGRESSION][BISECTED] Boot stall from merge tag 'net-next-6.2'
Message-ID: <ZIcmpcEsTLXFaO0f@debian.me>
References: <GQUnKz2al3yke5mB2i1kp3SzNHjK8vi6KJEh7rnLrOQ24OrlljeCyeWveLW9pICEmB9Qc8PKdNt3w1t_g3-Uvxq1l8Wj67PpoMeWDoH8PKk=@proton.me>
 <ZHFaFosKY24-L7tQ@debian.me>
 <NVN-hJsvHwaHe6R-y6XIYJp0FV7sCavgMjobFnseULT1wjgkOFNXbGBGT5iVjCfbtU7dW5xy2hIDoq0ASeNaXhvSY-g2Df4aHWVIMQ2c3TQ=@proton.me>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tWIpDNZqlXgx17RH"
Content-Disposition: inline
In-Reply-To: <NVN-hJsvHwaHe6R-y6XIYJp0FV7sCavgMjobFnseULT1wjgkOFNXbGBGT5iVjCfbtU7dW5xy2hIDoq0ASeNaXhvSY-g2Df4aHWVIMQ2c3TQ=@proton.me>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--tWIpDNZqlXgx17RH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 27, 2023 at 04:07:56AM +0000, Sami Korkalainen wrote:
> >Where is SCSI info?
>=20
> Right there, under the text (It was so short, that I thought to put it in=
 the message. Maybe I should have put that also in pastebin for consistency=
 and clarity):
>=20
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
> Vendor: ATA      Model: KINGSTON SVP200S Rev: C4
> Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
> Vendor: hp       Model: CDDVDW TS-L633M  Rev: 0301
> Type:   CD-ROM                           ANSI  SCSI revision: 05
>=20
> >I think networking changes shouldn't cause this ACPI regression, right?
> Yeah, beats me, but that's what I got by bisecting. My expertise ends abo=
ut here.

Hmm, no reply for a while.

Networking people: It looks like your v6.2 PR introduces unrelated
ACPICA regression. Can you explain why?

ACPICA people: Can you figure out why do this regression happen?

Sami: Can you try latest mainline and repeat bisection as confirmation?

I'm considering to remove this from regression tracking if there is
no replies in several more days.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--tWIpDNZqlXgx17RH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZIcmoQAKCRD2uYlJVVFO
o0wKAQCcH1j4r5tTFN68Co51J4YMdY4PIF5cCpAk35SIIZX4IQEA07PBQBFcbwxR
k4AfJYj4bdOcl372Mr+/9vr6aGcgFgc=
=p0sj
-----END PGP SIGNATURE-----

--tWIpDNZqlXgx17RH--

