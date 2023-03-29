Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4326CD4F5
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjC2InR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjC2InQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:43:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641361716;
        Wed, 29 Mar 2023 01:43:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u20so9764870pfk.12;
        Wed, 29 Mar 2023 01:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680079394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qAkrUB7euHbox3v7PniPVKEwDjGJe30NY4iWbdoH0eQ=;
        b=irr7FA6utBPpPz/5zJXbIJCT2Q+4ojhBzwGf4kNFvchrW6lv4H9d86AXROqxDEMrVO
         chkl5Frsv2fKA0ZrHeh/IfpRPEcYYW+vFhOodmsrCxuTnJ6apmKiJMKU4LG2iS+3Z3Vs
         2TSuO+asfb7cmCsCCiO6u+cyIU1MDcVS1NEJt8IOGhmJRU0iGxSclduXzz9sRHTA6rrw
         IGlChkjyUbIRugm/X6iRnCljRiZmPNweLgf7Ki0sCM+IdL6QvBwbWUM0FBP5AHsujnbH
         DuFUdgLFKF//7wfVwTBtdHJaB3dKucztCT+xexWpq7dpw1WVNt5XIdHqKqJ1bLwdoAZh
         MUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680079394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAkrUB7euHbox3v7PniPVKEwDjGJe30NY4iWbdoH0eQ=;
        b=yvBmFsJwFNrbMy7YprHVG4ylZgcm9ZReEYM9LqwOF11kBWXWshnnDZZu04wK8tMp7B
         bl0z+4GSSOHNy5Q5bNgzXNA+CbhG+tRc8+3h+4CQ4nLbSZDbbvAe4VTlbhFz72s9Ara/
         C0yb2T+ld6CdmMgavnAFkaX5jYX64dOxPJ8oOMIf3V4DBJLLBvgmWSLofMyE8j1Mu/Af
         7GYdBCGCHykLY6fLuGbGuQrQFn2uusMAt+20EASw08VhVW0rrgr4iRfrAs77MGYzFOHz
         VtBqQS9fmHC3Ny/I6qe4vYGk+ZSJ4ArUbnLjufTm4+d3GiJLTaoDR39io0au4TM/CIHM
         61Zg==
X-Gm-Message-State: AAQBX9c/1e7EJYHVyJjkTg7YZEE7fr10sno1dbCnN99rKLSGYuYhF32b
        sIPan0XZ+nlhO95WsGxd6h0=
X-Google-Smtp-Source: AKy350Yi+FDtNs7I7ur07WPq3PMIY+FGuuQTrqAVCmZswBPeFKnK7Y3Ten8e6jx+gYtFseIR6XFIaA==
X-Received: by 2002:a62:5b44:0:b0:625:4b46:e019 with SMTP id p65-20020a625b44000000b006254b46e019mr1347521pfb.9.1680079393750;
        Wed, 29 Mar 2023 01:43:13 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-15.three.co.id. [116.206.28.15])
        by smtp.gmail.com with ESMTPSA id jk1-20020a170903330100b001a1d5d47105sm7445188plb.53.2023.03.29.01.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 01:43:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id C006B10670B; Wed, 29 Mar 2023 15:43:10 +0700 (WIB)
Date:   Wed, 29 Mar 2023 15:43:10 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Takashi Iwai <tiwai@suse.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     regressions@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] e1000e probe/link detection fails since 6.2 kernel
Message-ID: <ZCP6Hhs21zzpzBQE@debian.me>
References: <87jzz13v7i.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="635VUw/DoI3CBtIu"
Content-Disposition: inline
In-Reply-To: <87jzz13v7i.wl-tiwai@suse.de>
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


--635VUw/DoI3CBtIu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 28, 2023 at 02:40:33PM +0200, Takashi Iwai wrote:
> Hi,
>=20
> we've got a regression report for e1000e device on Lenovo T460p since
> 6.2 kernel (with openSUSE Tumbleweed).  The details are found in
>   https://bugzilla.opensuse.org/show_bug.cgi?id=3D1209254
>=20
> It seems that the driver can't detect the 1000Mbps but only 10/100Mbps
> link, eventually making the device unusable.
>=20
> On 6.1.12:
> [    5.119117] e1000e: Intel(R) PRO/1000 Network Driver
> [    5.119120] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    5.121754] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) =
set to dynamic conservative mode
> [    7.905526] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): Failed t=
o disable ULP
> [    7.988925] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): register=
ed PHC clock
> [    8.069935] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 5=
0:7b:9d:cf:13:43
> [    8.069942] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connec=
tion
> [    8.072691] e1000e 0000:00:1f.6 eth0: MAC: 12, PHY: 12, PBA No: 1000FF=
-0FF
> [   11.643919] e1000e 0000:00:1f.6 eth0: NIC Link is Up 1000 Mbps Full Du=
plex, Flow Control: None
> [   15.437437] e1000e 0000:00:1f.6 eth0: NIC Link is Up 1000 Mbps Full Du=
plex, Flow Control: None
>=20
> On 6.2.4:
> [    4.344140] e1000e: Intel(R) PRO/1000 Network Driver
> [    4.344143] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    4.344933] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) =
set to dynamic conservative mode
> [    7.113334] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): Failed t=
o disable ULP
> [    7.201715] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): register=
ed PHC clock
> [    7.284038] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 5=
0:7b:9d:cf:13:43
> [    7.284044] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connec=
tion
> [    7.284125] e1000e 0000:00:1f.6 eth0: MAC: 12, PHY: 12, PBA No: 1000FF=
-0FF
> [   10.897973] e1000e 0000:00:1f.6 eth0: NIC Link is Up 10 Mbps Full Dupl=
ex, Flow Control: None
> [   10.897977] e1000e 0000:00:1f.6 eth0: 10/100 speed: disabling TSO
> [   14.710059] e1000e 0000:00:1f.6 eth0: NIC Link is Up 10 Mbps Full Dupl=
ex, Flow Control: None
> [   14.710064] e1000e 0000:00:1f.6 eth0: 10/100 speed: disabling TSO
> [   59.894807] e1000e 0000:00:1f.6 eth0: NIC Link is Up 10 Mbps Full Dupl=
ex, Flow Control: None
> [   59.894812] e1000e 0000:00:1f.6 eth0: 10/100 speed: disabling TSO
> [   63.808662] e1000e 0000:00:1f.6 eth0: NIC Link is Up 10 Mbps Full Dupl=
ex, Flow Control: None
> [   63.808668] e1000e 0000:00:1f.6 eth0: 10/100 speed: disabling TSO
>=20
> The same problem persists with 6.3-rc3.
>=20

I'm adding this to regzbot:

#regzbot ^introduced: v6.1.12..v6.2.4
#regzbot: e1000 probe/link detection fails since v6.2

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--635VUw/DoI3CBtIu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCP6HgAKCRD2uYlJVVFO
o8AHAQDFjzDRV29C1MwVXjNV+kbHZ1vxTvB6tFYmWn0YDTmtkwEAqupmkIIt1wg8
KgBw0VHxmNcJ4aCYAV9pZe8nMRr9pwg=
=+9Nm
-----END PGP SIGNATURE-----

--635VUw/DoI3CBtIu--
