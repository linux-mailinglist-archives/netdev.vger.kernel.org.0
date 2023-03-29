Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7A46CD4E3
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjC2Ikz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjC2Iky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:40:54 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AEC12E;
        Wed, 29 Mar 2023 01:40:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g7so9781378pfu.2;
        Wed, 29 Mar 2023 01:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680079248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T4nFg4zKMGojw1a9EUgiYrx0HzwuMwAbekbAVn3z66s=;
        b=V4fUz5/MNZNeW1jMG5OcBY4Tpy3nx8pejz1mjjui8TMA8VFc8VTH90eQvkJxcjRK+q
         qGiV1pS07CiLbAP1AaqcNcR+CoYmiHz3aZBc6RmMTnufrnZ6yrYnW4l/SIZ90x2tR/yq
         qqU6ywlIXlm77nooDOXfDuoT3iClb8PMr6I1sD5GBrc4Q6n7UX12trb5um9753Y5CujO
         +tDQgOFl8OCqHAMWEKeuPO39s8ChLyRfjgHKDCOX05VAKhPocYKkTbV8Op1lo6XSMZdX
         lWPnb20TOnLVjnx/2CNWpkIL6ykc6HjvCCGA1S2Efsb6Jw5jbbX3GUMSCnZf1kBiJS/e
         Ik1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680079248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4nFg4zKMGojw1a9EUgiYrx0HzwuMwAbekbAVn3z66s=;
        b=jHysOHPDAAjEPRAn+GAlVPT1bnhfqBLa2pGVdMVLx3cIXCrIxuInhR+b0pHzVWfy1R
         ks7AEM/ORdcw9vXDUOkkgehPy453XhHNC3DzCKrriT1LP6wtKDmvPippnYgWuZE7+8Qh
         2ElUzVbGVG/pzeYIItje5Z3ury7BAHhRGh5z0s6rH4JNIOLEO9yZ7kI1LMfbMvoiHoaO
         zNRCZrFNGT8xtZSs/4HPrd45dpp8Frn5EvAo1mT3fGD7xt9iiuMt3GDF6Ma6wjYVCcpv
         +bAl5/Zh9okZoQ2vuT/h2Sp6iMCqRLH3nJ+a2yw8ii8E+Znvx4iCnu8CMC6KlnkDYFIT
         Q8vg==
X-Gm-Message-State: AAQBX9eQjEPLBjpe7flujq2sqkZds+//OgQ7/8vABshPSK+Sj1/NCE1e
        sNSOTAsA6QXjmrcRG3iZGQY=
X-Google-Smtp-Source: AKy350ZeSdakn87GYUZYeIzq/R0++5i4nskJlkhQzoG11bTfiOXNzxI+PTUP/mlACh8Rh4Eqqw7oCA==
X-Received: by 2002:a62:5254:0:b0:626:286d:b701 with SMTP id g81-20020a625254000000b00626286db701mr17920670pfb.20.1680079247947;
        Wed, 29 Mar 2023 01:40:47 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-15.three.co.id. [116.206.28.15])
        by smtp.gmail.com with ESMTPSA id a25-20020a62e219000000b00590ede84b1csm23173046pfi.147.2023.03.29.01.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 01:40:47 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 8D8D4106705; Wed, 29 Mar 2023 15:40:44 +0700 (WIB)
Date:   Wed, 29 Mar 2023 15:40:44 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>, Takashi Iwai <tiwai@suse.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [Intel-wired-lan] [REGRESSION] e1000e probe/link detection fails
 since 6.2 kernel
Message-ID: <ZCP5jOTNypwG4xK6@debian.me>
References: <87jzz13v7i.wl-tiwai@suse.de>
 <652a9a96-f499-f31f-2a55-3c80b6ac9c75@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cyVgV9qP40t8gPzM"
Content-Disposition: inline
In-Reply-To: <652a9a96-f499-f31f-2a55-3c80b6ac9c75@molgen.mpg.de>
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


--cyVgV9qP40t8gPzM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 28, 2023 at 04:39:01PM +0200, Paul Menzel wrote:
> Does openSUSE Tumbleweed make it easy to bisect the regression at least on
> =E2=80=9Crc level=E2=80=9D? It be great if narrow it more down, so we kno=
w it for example
> regressed in 6.2-rc7.
>=20

Alternatively, can you do bisection using kernel sources from Linus's
tree (git required)?

--=20
An old man doll... just what I always wanted! - Clara

--cyVgV9qP40t8gPzM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCP5hgAKCRD2uYlJVVFO
oyl2AP4j+bMThihDAhQDsVmg3q4Dgn/R1Tm/T9ALIQekbXtkvwD+IWh8158WgO5h
qOc7nN3lZwaB/V+HxGXv7L6aRMBQ3A4=
=4fBA
-----END PGP SIGNATURE-----

--cyVgV9qP40t8gPzM--
