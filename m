Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79656C9300
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 09:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCZHrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 03:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCZHrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 03:47:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8F35FF0;
        Sun, 26 Mar 2023 00:47:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j13so5096764pjd.1;
        Sun, 26 Mar 2023 00:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679816835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UgjlposdC6qH3DVEdWJ2rkdbbJFgyNplJNPG5hJZRIg=;
        b=KMLANcw8P5giPzb0qEEgXCnmR7F6MvQ7jvGKake+EBnX3PJ8ctxFcAlCFNGXw2cmh5
         4erJHPDs+IHJgNXcRHhBtMhYh3+QdUfdGODe9GnfyVIM38aJl8IAUs8qQCC2K5O9ZMir
         e8WH1moC3DmCcZ1n5ZQJXR4tOhCinLLN7FdQODPPgpISH5gyu1Yy6z8leBeX/pdPWbIv
         M44eo1EFHdzI63v46YImnyIIE+fPoQInKyxL6MSctcUkmGOXsHrDLkmaQXaSHyNmJWEj
         nV/5UgRGRkRpJpJf4Bc8NJdt3vR57mLNmATJF+Hfm4DMefl0o88duBYmFheWyxKolY66
         eB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679816835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UgjlposdC6qH3DVEdWJ2rkdbbJFgyNplJNPG5hJZRIg=;
        b=c96RWSX69zl5J3YcGo89PdOv9nOeLBeRHE4c2tnBONWsQqRjd4EP8ysLpXgI1uo/sM
         9kKmPgJgCtNMvaOAEPDAlqc0rGZNWfNWgy3oUz+xkS2+ua/jvHY7RdWhM6Nz1uPiITDH
         /7/JIjkv1hwi2IpxXpI8qFaE8pwn4uSlzk3Ow/GH5kzSM/vygJBBKRo5oglDdDb6BQo3
         HzCg40Xz3ZoMNUT7OzpUDABNRMkUqQMRWMvlUs9nYkYkmJt9iXNDdKE/ejVRMmRbh4mT
         mdw/PWOj6zWgho3LOKukvhXVcdoF+UO+A9m74qNc9eZRrOz9fLFGOBrIW3/YQIkJ3ZvG
         NKyQ==
X-Gm-Message-State: AAQBX9c3v8jt4KXFOVvtEkqT+Z2CSNZhCDJrDuyd0sA0vLIDyvXKngJ5
        x0wXFgwq9L4b4CYlmexEih/hEHFjxFPsUA==
X-Google-Smtp-Source: AKy350Y5e6L5dqe5n1R1vPcdJxRtE+02TAggx2JfyIZIvkMRyjLD2L32mHZD2go/2Sv/WS6ao1fiLQ==
X-Received: by 2002:a17:903:1d1:b0:1a1:ad5e:bdbb with SMTP id e17-20020a17090301d100b001a1ad5ebdbbmr10386719plh.36.1679816835209;
        Sun, 26 Mar 2023 00:47:15 -0700 (PDT)
Received: from debian.me (subs09a-223-255-225-74.three.co.id. [223.255.225.74])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902b7c300b0019fcece6847sm16977222plz.227.2023.03.26.00.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 00:47:14 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id B3CC3105D9C; Sun, 26 Mar 2023 14:47:11 +0700 (WIB)
Date:   Sun, 26 Mar 2023 14:47:11 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Shinu Chandran <s4superuser@gmail.com>, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: ptp_clock: Fix coding style issues
Message-ID: <ZB/4f0H0y8COVR90@debian.me>
References: <20230325163135.2431367-1-s4superuser@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="J7kkaICAQb7tt5yH"
Content-Disposition: inline
In-Reply-To: <20230325163135.2431367-1-s4superuser@gmail.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J7kkaICAQb7tt5yH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 25, 2023 at 10:01:35PM +0530, Shinu Chandran wrote:
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index 62d4d29e7c05..8fe7f2ce9705 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -129,6 +129,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, =
struct __kernel_timex *tx)
>  		err =3D ops->adjtime(ops, delta);
>  	} else if (tx->modes & ADJ_FREQUENCY) {
>  		long ppb =3D scaled_ppm_to_ppb(tx->freq);
> +
>  		if (ppb > ops->max_adj || ppb < -ops->max_adj)
>  			return -ERANGE;
>  		err =3D ops->adjfine(ops, tx->freq);
> @@ -278,11 +279,13 @@ struct ptp_clock *ptp_clock_register(struct ptp_clo=
ck_info *info,
>  	/* Register a new PPS source. */
>  	if (info->pps) {
>  		struct pps_source_info pps;
> +
>  		memset(&pps, 0, sizeof(pps));
>  		snprintf(pps.name, PPS_MAX_NAME_LEN, "ptp%d", index);
>  		pps.mode =3D PTP_PPS_MODE;
>  		pps.owner =3D info->owner;
>  		ptp->pps_source =3D pps_register_source(&pps, PTP_PPS_DEFAULTS);
> +
>  		if (IS_ERR(ptp->pps_source)) {
>  			err =3D PTR_ERR(ptp->pps_source);
>  			pr_err("failed to register pps source\n");
> @@ -347,9 +350,8 @@ static int unregister_vclock(struct device *dev, void=
 *data)
> =20
>  int ptp_clock_unregister(struct ptp_clock *ptp)
>  {
> -	if (ptp_vclock_in_use(ptp)) {
> +	if (ptp_vclock_in_use(ptp))
>  		device_for_each_child(&ptp->dev, NULL, unregister_vclock);
> -	}
> =20
>  	ptp->defunct =3D 1;
>  	wake_up_interruptible(&ptp->tsev_wq);

Two style fixes in one patch (blank lines and braces). Please split
them into each individual patches in a series.

But hey, shouldn't checkpatch complain about one-line brace block?

And also, the patch subject should have been [PATCH net-next]
(targetting next Linux release) or [PATCH net] (targetting current
release).

Thanks!

--=20
An old man doll... just what I always wanted! - Clara

--J7kkaICAQb7tt5yH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZB/4eAAKCRD2uYlJVVFO
o91KAQCbj9ofMdcUyyoEeRyLASN+Rwy62tmpA5I0nI5kLUJwrQD/U7UBNxEodRtb
hMXwkAvhYJLDj6JLH7VE4VZqhQIUMQ0=
=dDGy
-----END PGP SIGNATURE-----

--J7kkaICAQb7tt5yH--
