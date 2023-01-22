Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3AC676A9D
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 03:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjAVCOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 21:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjAVCN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 21:13:59 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A810522A2D;
        Sat, 21 Jan 2023 18:13:58 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id d10so6710764pgm.13;
        Sat, 21 Jan 2023 18:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bq1sd56d6peHd2gpeH6Q+nFMu9KWkvG/os8VrxgBx5A=;
        b=QHKXckfkvM5+0Mx4SYwHS76drVGOy9c7ALmxiHeW4bfhbw9+WLIf2MQplsnUwE+2zd
         1YnOGVwvZEyFhORS1w2XPDhCRTV0i/aPYGD9GrpkI4eSMKFPGVICVxNfFBcIg1ucDMup
         p/vVJVv6qzSU37ZXZQnWb/QwJSx4VsnoG0V9BJ6cs6QGJS+7i3j1HfSTUlLc10e5i2rD
         5a/F1iqHJ8TsIxP/9eaoQwdnjfbioZBwgegYB5LtUmUK8SOcDmBuuXUzqYPzV+1skswf
         xe1Ll9clEcxrmb8RwIruY6IV4rEpHN4hfIMip7Gik6JwHzeg9j9r7hCcRcCiV3/6VDzZ
         GvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bq1sd56d6peHd2gpeH6Q+nFMu9KWkvG/os8VrxgBx5A=;
        b=xjCHZJLr5f+wK9uiRm8Q1IfdVNdJlTm/VhHnDk78F2IdbRTH6UkVzqgbH8kJI2qQMa
         FeGXGT7Uag3TKBiyq5Q5O3H+lM3e6iOpwv7UXHFaVcYfkhu58OPdCq/XyiXAXWpIelqs
         BK7ZN4E/DZ6VLHW5aTm+He0/l+8ILI4IQEFGc6rdf7cqBqSRrX/WLOYd+kaudNku5lSm
         9skWUBPG70FBVAw5/hL00Bhel7yeed+hYDbFno8PzLJMbADfJzx1LGXt8dzd6J1OPLoc
         6KsttYN56JrqVS3OO8eP3Sfu4+e/bMAJdnyz8VPmfU7+dossiREdtX1Vuo+sHbYhIqkO
         8jFg==
X-Gm-Message-State: AFqh2kqpbGn3y2Y4n1ne2etF8cSs1c33E5ckJnVcJaeFQVR+OuHO9hJm
        Fa3AstTUkjxAflQRmDbbwTY=
X-Google-Smtp-Source: AMrXdXtjm5V/qzj1GeGy85ERTLvGXI7zxnlbS3hVdnI15ANqcjIAfvmTijXyz1f5vW6j9vI6z2N/9Q==
X-Received: by 2002:a62:ab0b:0:b0:58b:46c9:a6b1 with SMTP id p11-20020a62ab0b000000b0058b46c9a6b1mr20683919pff.33.1674353637992;
        Sat, 21 Jan 2023 18:13:57 -0800 (PST)
Received: from debian.me (subs03-180-214-233-71.three.co.id. [180.214.233.71])
        by smtp.gmail.com with ESMTPSA id w27-20020aa79a1b000000b0056be1581126sm14239212pfj.143.2023.01.21.18.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 18:13:57 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id B0991104D39; Sun, 22 Jan 2023 09:13:45 +0700 (WIB)
Date:   Sun, 22 Jan 2023 09:13:44 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     m.chetan.kumar@linux.intel.com, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH v5 net-next 5/5] net: wwan: t7xx: Devlink documentation
Message-ID: <Y8yb2AKf9mDHP0zu@debian.me>
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
 <f902d4a0cb807a205687f7e693079fba72ca7341.1674307425.git.m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="f20Z6JNanG9/8wmS"
Content-Disposition: inline
In-Reply-To: <f902d4a0cb807a205687f7e693079fba72ca7341.1674307425.git.m.chetan.kumar@linux.intel.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--f20Z6JNanG9/8wmS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 21, 2023 at 07:03:58PM +0530, m.chetan.kumar@linux.intel.com wr=
ote:
> +Flash Commands
> +--------------
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacar=
d.bin component "preloader"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file loader_ext-verified.img compone=
nt "loader_ext1"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee=
1"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "s=
pmfw"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file sspm-verified.img component "ss=
pm_1"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "m=
cupm_1"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm=
_1"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file boot-verified.img component "bo=
ot"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file modem-verified.img component "m=
d1img"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1=
dsp"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
> +
> +::
> +
> +  $ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"

It seems like you didn't describe what ``devlink dev flash`` commands above
are doing, as I had requested from v3 review [1].

> +Coredump Collection
> +~~~~~~~~~~~~~~~~~~~
> +
> +::
> +
> +  $ devlink region new mr_dump
> +
> +::
> +
> +  $ devlink region read mr_dump snapshot 0 address 0 length $len
> +
> +::
> +
> +  $ devlink region del mr_dump snapshot 0
> +
> +Note: $len is actual len to be dumped.
> +
> +The userspace application uses these commands for obtaining the modem co=
mponent
> +logs when device encounters an exception.

Individual command explanation please?

> +
> +Second Stage Bootloader dump
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +::
> +
> +  $ devlink region new lk_dump
> +
> +::
> +
> +  $ devlink region read lk_dump snapshot 0 address 0 length $len
> +
> +::
> +
> +  $ devlink region del lk_dump snapshot 0
> +
> +Note: $len is actual len to be dumped.
> +
> +In fastboot mode the userspace application uses these commands for obtai=
ning the
> +current snapshot of second stage bootloader.

Individual command explanation please?

Hint: see any manpages to get sense of how to write the explanations.=20

Thanks.

[1]: https://lore.kernel.org/linux-doc/Y7uOcBRN0Awn5xAb@debian.me/

--=20
An old man doll... just what I always wanted! - Clara

--f20Z6JNanG9/8wmS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8ybrAAKCRD2uYlJVVFO
o56AAQDgk4Z4EspGveJ6ACKPO1SmUuHtnGGGu/iptMTn3AHhgwD/Q8M0IMUznfO4
H1QqzGpSYLG5W5RhMqmv0VjHNQLwkQ8=
=ACkW
-----END PGP SIGNATURE-----

--f20Z6JNanG9/8wmS--
