Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04469661CDB
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 04:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbjAIDsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 22:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjAIDsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 22:48:06 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849D2D128;
        Sun,  8 Jan 2023 19:48:05 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id x4so1065040pfj.1;
        Sun, 08 Jan 2023 19:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sihnne3RQDI8AsdrTTmVwvZYK1ek1HQcaOW0HCkOxEk=;
        b=hNItLYuuLWjoX0cymxAC15T9INjLF2mV5p3Qzx/Q73maJ98TH+Oho4K4F3C78Lvsst
         oIEGZdyvI84JLRAnXj99u2EeDJ8N6Vn1uy2gyBn938q0VTFLcZ5RDd5KrPsErPCyd631
         S5LUgG+lwzXzI/Co+eg6Kr2R/cV3srgaS+BhdiJJNkDBFimfD9mqJ5qzAGFXfXdRPpvy
         sB1vq8ytKGm7VJcTaX/FOeRl63DcR6TLuGfizJnGQTiNosmydWpNJs3XEjBXd8uKvvCM
         GNbfGSe8QdcED3pFQw3nOmelqL7dM1t1QGNfOurN1XWNBxdMNDUX36pw17u4/94+VhXN
         Zgvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sihnne3RQDI8AsdrTTmVwvZYK1ek1HQcaOW0HCkOxEk=;
        b=FhgXd+qJ9D1N/MSOgsRPC3UhLfg0pHdj90jExpq0vXGMeYlmWi15hurjX52a5NSYEH
         C+2uL5rdWMiS7zVoTr2bbdjdx+U1kScY28RYUzdJ72Au7zfAkFSXre8pFEyf082qGpk9
         zdLoAzSHZV9FqMHC+qKyWAttha4zyGGnbgHqhn5YftDTwJi5r9F+QsM7gFwlE6QPv54C
         odilatfRZY3hi7y5Yoo7NseuRHYS+KECIz/Eq6b0Q6kfujFUE1SoiBg2XMjO95Dn/r38
         qoZxyOWALZewktyzbL/Bux4rMAx/DFw4bB/wXdmBLRm1BHekcSA6JOVLpd0pt48y6ptT
         wr2g==
X-Gm-Message-State: AFqh2krQIUyDtrYZAEEaKNtqEe/V+SH0rFIfTKjLtiB/nlZN7Nc/dyBZ
        vlt5adPs9YSDAzm0PZW+yuE=
X-Google-Smtp-Source: AMrXdXvsrsFv9SyBFedTssm19CKLisNlVQAY89mLir9qOPrri2um2bVlWhINufu0cbp/NAbyG/cvyQ==
X-Received: by 2002:a05:6a00:158e:b0:581:5be0:4e2a with SMTP id u14-20020a056a00158e00b005815be04e2amr61249952pfk.31.1673236084803;
        Sun, 08 Jan 2023 19:48:04 -0800 (PST)
Received: from debian.me (subs03-180-214-233-24.three.co.id. [180.214.233.24])
        by smtp.gmail.com with ESMTPSA id p128-20020a625b86000000b00580d25a2bb2sm357565pfb.108.2023.01.08.19.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 19:48:04 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id D6FC0100C90; Mon,  9 Jan 2023 10:48:00 +0700 (WIB)
Date:   Mon, 9 Jan 2023 10:48:00 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     m.chetan.kumar@linux.intel.com, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, chandrashekar.devegowda@intel.com,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-doc@vger.kernel.org,
        jiri@nvidia.com, corbet@lwn.net
Subject: Re: [PATCH v3 net-next 5/5] net: wwan: t7xx: Devlink documentation
Message-ID: <Y7uOcBRN0Awn5xAb@debian.me>
References: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
 <500a41cb400b4cdedd6df414b40200a5211965f5.1673016069.git.m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="irWeDYniLkJASH6A"
Content-Disposition: inline
In-Reply-To: <500a41cb400b4cdedd6df414b40200a5211965f5.1673016069.git.m.chetan.kumar@linux.intel.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--irWeDYniLkJASH6A
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 06, 2023 at 09:58:06PM +0530, m.chetan.kumar@linux.intel.com wr=
ote:
> Refer to t7xx.rst file for details.

Above line is unnecessary.

> +The wwan device is put into fastboot mode via devlink reload command, by
> +passing "driver_reinit" action.
> +
> +$ devlink dev reload pci/0000:$bdf action driver_reinit
> +
> +Upon completion of fw flashing or coredump collection the wwan device is
> +reset to normal mode using devlink reload command, by passing "fw_activa=
te"
> +action.
> +
> +$ devlink dev reload pci/0000:$bdf action fw_activate

Personally I prefer to put command-line explanations below the actual
command:

---- >8 ----

diff --git a/Documentation/networking/devlink/t7xx.rst b/Documentation/netw=
orking/devlink/t7xx.rst
index de220878ad7649..24f9e0ee69bffb 100644
--- a/Documentation/networking/devlink/t7xx.rst
+++ b/Documentation/networking/devlink/t7xx.rst
@@ -74,17 +74,21 @@ The supported list of firmware image types is described=
 below.
 procedure, fastboot command & response are exchanged between driver and ww=
an
 device.
=20
+::
+
+  $ devlink dev reload pci/0000:$bdf action driver_reinit
+
 The wwan device is put into fastboot mode via devlink reload command, by
 passing "driver_reinit" action.
=20
-$ devlink dev reload pci/0000:$bdf action driver_reinit
+::
+
+  $ devlink dev reload pci/0000:$bdf action fw_activate
=20
 Upon completion of fw flashing or coredump collection the wwan device is
 reset to normal mode using devlink reload command, by passing "fw_activate"
 action.
=20
-$ devlink dev reload pci/0000:$bdf action fw_activate
-
 Flash Commands:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20

However, I find it's odd to jump from firmware image type list directly to
devlink usage. Perhaps the latter should be put into the following section
below?

I also find that there is minor inconsistency of keyword formatting, so I
have to inline-code the uninlined remainings:

---- >8 ----

diff --git a/Documentation/networking/devlink/t7xx.rst b/Documentation/netw=
orking/devlink/t7xx.rst
index 24f9e0ee69bffb..d8feefe116c978 100644
--- a/Documentation/networking/devlink/t7xx.rst
+++ b/Documentation/networking/devlink/t7xx.rst
@@ -29,7 +29,7 @@ Flash Update
 The ``t7xx`` driver implements the flash update using the ``devlink-flash``
 interface.
=20
-The driver uses DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT to identify the typ=
e of
+The driver uses ``DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT`` to identify the=
 type of
 firmware image that need to be programmed upon the request by user space a=
pplication.
=20
 The supported list of firmware image types is described below.
@@ -79,14 +79,14 @@ device.
   $ devlink dev reload pci/0000:$bdf action driver_reinit
=20
 The wwan device is put into fastboot mode via devlink reload command, by
-passing "driver_reinit" action.
+passing ``driver_reinit`` action.
=20
 ::
=20
   $ devlink dev reload pci/0000:$bdf action fw_activate
=20
 Upon completion of fw flashing or coredump collection the wwan device is
-reset to normal mode using devlink reload command, by passing "fw_activate"
+reset to normal mode using devlink reload command, by passing ``fw_activat=
e``
 action.
=20
 Flash Commands:
=20
> +
> +Flash Commands:
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Trim the unneeded trailing colon on the section title.

> +
> +$ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.=
bin component "preloader"
> +
> +$ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component=
 "loader_ext1"
> +
> +$ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
> +
> +$ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
> +
> +$ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spm=
fw"
> +
> +$ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm=
_1"
> +
> +$ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcu=
pm_1"
> +
> +$ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
> +
> +$ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
> +
> +$ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
> +
> +$ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1=
img"
> +
> +$ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1ds=
p"
> +
> +$ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
> +
> +$ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
> +
> +$ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
> +
> <snipped>...
> +Region commands
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +$ devlink region show
> +
> +
> +$ devlink region new mr_dump
> +
> +$ devlink region read mr_dump snapshot 0 address 0 length $len
> +
> +$ devlink region del mr_dump snapshot 0
> +
> +$ devlink region new lk_dump
> +
> +$ devlink region read lk_dump snapshot 0 address 0 length $len
> +
> +$ devlink region del lk_dump snapshot 0
> +
> +Note: $len is actual len to be dumped.

Please briefly describe these devlink commands.

Also, wrap them in literal code blocks:

---- >8 ----

diff --git a/Documentation/networking/devlink/t7xx.rst b/Documentation/netw=
orking/devlink/t7xx.rst
index d8feefe116c978..1ba3ba4680e721 100644
--- a/Documentation/networking/devlink/t7xx.rst
+++ b/Documentation/networking/devlink/t7xx.rst
@@ -92,35 +92,65 @@ action.
 Flash Commands:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-$ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.bi=
n component "preloader"
+::
=20
-$ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component "=
loader_ext1"
+  $ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.=
bin component "preloader"
=20
-$ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
+::
=20
-$ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
+  $ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component=
 "loader_ext1"
=20
-$ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spmfw"
+::
=20
-$ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm_1"
+  $ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
=20
-$ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcupm=
_1"
+::
=20
-$ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
+  $ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
=20
-$ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
+::
=20
-$ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
+  $ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spm=
fw"
=20
-$ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1im=
g"
+::
=20
-$ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1dsp"
+  $ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm=
_1"
=20
-$ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
+::
=20
-$ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
+  $ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcu=
pm_1"
=20
-$ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
+::
+
+  $ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1=
img"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1ds=
p"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
=20
 Note: Component selects the partition type to be programmed.
=20
@@ -147,19 +177,31 @@ Following regions are accessed for device internal da=
ta.
 Region commands
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-$ devlink region show
+::
+  $ devlink region show
=20
+::
=20
-$ devlink region new mr_dump
+  $ devlink region new mr_dump
=20
-$ devlink region read mr_dump snapshot 0 address 0 length $len
+::
=20
-$ devlink region del mr_dump snapshot 0
+  $ devlink region read mr_dump snapshot 0 address 0 length $len
=20
-$ devlink region new lk_dump
+::
=20
-$ devlink region read lk_dump snapshot 0 address 0 length $len
+  $ devlink region del mr_dump snapshot 0
=20
-$ devlink region del lk_dump snapshot 0
+::
+
+  $ devlink region new lk_dump
+
+::
+
+  $ devlink region read lk_dump snapshot 0 address 0 length $len
+
+::
+
+  $ devlink region del lk_dump snapshot 0
=20
 Note: $len is actual len to be dumped.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--irWeDYniLkJASH6A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7uOagAKCRD2uYlJVVFO
o5A/AP9NvGek0JW4Qi2C310VlJ6mWaEt905jsN7pUeU2ePzEsQD/cg7dAHSb2ecn
DLfa0bVhusQk9kl6SrOwZdSyr0x6YAM=
=Ppu6
-----END PGP SIGNATURE-----

--irWeDYniLkJASH6A--
