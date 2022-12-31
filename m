Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34D265A4B4
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 14:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiLaNoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Dec 2022 08:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLaNoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Dec 2022 08:44:21 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4445FFF;
        Sat, 31 Dec 2022 05:44:21 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ge16so21400593pjb.5;
        Sat, 31 Dec 2022 05:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WbkuGmDcRQ6q49+hrj+g863+SldsRWquZ8uo6XW4rW8=;
        b=YsxJpyPOhrO+dvIWEYCHWn5nMYXkpBHEQlya7071C5AryRCjimG92wklmfHivauTp+
         h2ydeoZ1ZPm6VA/vfkh0h/PdPNKkU6ZUl9iQyMTa3VfRuHDKkrIjlGakwTeVkk2F/iGE
         d8ylEFXySuECaKpLKPG9N+wSHxGV9q0r1C14VDFOxkVLfC21mZisDz6ybS/Jjy7FlMRH
         tJEiKjVNBpGj+YMX0dKd4PZg1E2B1jbNw9D6UIQ4urpe4dKiTql7lZnssArdMjp3jfBk
         7RKZow2iRLKTbTUOKXAqvAkJ586N4Fks3sOLeKeHMLjshxDF5sifV1m6NosU02cazn8e
         jiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbkuGmDcRQ6q49+hrj+g863+SldsRWquZ8uo6XW4rW8=;
        b=C7H2vtxJ4UbubEE82vp7zoDa+1qrJ+XIpnxRgDSKyNERwLyL6V1M3NIr7ze5MfER0w
         Y4I22w4elWl5ZP6ISmll8cto8bsTQKAZMfmO1Gq8uwclqsKi65cFDeCqB4wysyUtfZZF
         xdGpe3BXsLKT8FG/SGT3vr4wIYSTylhlJZJS4MBdfUGdc9N5q2epkhjCDLMyIBAVDu0/
         +o4fgxQuU7g8N1+L/hURFK8jbtdPxd1p4Rwuhkdcs6nxXahf7qlBPOS+0lWe6h9RGyeT
         JdDBoY0WBEaOx23QH2fQH2KXLDMUCnUtLSHK3Wx+PhU78xL57ojkoeMyk3IrEfH/kooE
         MWlQ==
X-Gm-Message-State: AFqh2krTrUor3wtf3DXU502GIBq2ADKz9g33vRo0powgq6mcK0tCKJWe
        TZUjGs9quf4CXcpNPFbsPag=
X-Google-Smtp-Source: AMrXdXuqrD2kqE4ZsvEhs3GhVDCnSPlgz9F8TloFclEA9nK80bYQWfw/+Sv6eTXzolcrcYI022a6nA==
X-Received: by 2002:a17:90a:c795:b0:225:bd44:cf0e with SMTP id gn21-20020a17090ac79500b00225bd44cf0emr32789373pjb.32.1672494260594;
        Sat, 31 Dec 2022 05:44:20 -0800 (PST)
Received: from debian.me (subs02-180-214-232-18.three.co.id. [180.214.232.18])
        by smtp.gmail.com with ESMTPSA id h10-20020a63120a000000b0046fe244ed6esm14282393pgl.23.2022.12.31.05.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 05:44:19 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id CC3451017FB; Sat, 31 Dec 2022 20:44:15 +0700 (WIB)
Date:   Sat, 31 Dec 2022 20:44:15 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     syzbot <syzbot+4ca3ba1e3ae6ff5ae0f8@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] net build error (6)
Message-ID: <Y7A8r4Yo07BnDxYv@debian.me>
References: <0000000000000ad94305f116ba53@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6lDnvxkT2UOro6nM"
Content-Disposition: inline
In-Reply-To: <0000000000000ad94305f116ba53@google.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6lDnvxkT2UOro6nM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 30, 2022 at 06:46:36PM -0800, syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    d3805695fe1e net: ethernet: marvell: octeontx2: Fix unini=
t..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D14f43b54480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8ca07260bb631=
fb4
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D4ca3ba1e3ae6ff5=
ae0f8
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+4ca3ba1e3ae6ff5ae0f8@syzkaller.appspotmail.com
>=20
> failed to run ["make" "-j" "64" "ARCH=3Dx86_64" "bzImage"]: exit status 2
>=20

I think the actual build warnings/errors should be listed here instead
of only dumping exit status and then having to click the log output.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--6lDnvxkT2UOro6nM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7A8qwAKCRD2uYlJVVFO
o92SAP9+iLNZ0ZMBLfg6ILr1XCPo08d675mDWAtVI1eakPeiNQD/bh899J260SvF
dRZhNO7tf/i8K0/nerqHfAf5xB8vogw=
=izVW
-----END PGP SIGNATURE-----

--6lDnvxkT2UOro6nM--
