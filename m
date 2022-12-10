Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA23648EDE
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiLJNTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 08:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiLJNS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 08:18:59 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C459E24;
        Sat, 10 Dec 2022 05:18:58 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r18so5303406pgr.12;
        Sat, 10 Dec 2022 05:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yrdMdr4CnXy1K7qhR03uSJz8LU6ClkU8Tex0C5hTdOM=;
        b=SaioU0CyoqxJ7AKuY9GgXurTRmkVlyzcoj1/+kdUmiAsMcUuNjR0RNokYMn8Djz0Iu
         4HHFEBMk0e9diHfYuk1TE/iryTn+FndDI0GF2xq2w3YdaRyGLcytlcL/KCwkjMoNpqNB
         p9Zmepz7y5nLjqBwL0b4aKyW6QT0hWI5TiSCnTYaTKP+ygPzsu8tRvdr6D9ZG6KWQVD/
         jvSihl2xmEYkGV3SfDbX026bwdFY8ijZVaZMLiCpJGbKJQMRGxJw7I0VyYHvUYUlnJwc
         zpc1RKth9mXsQNTWypHY9VQ7zlcpr4huN3R7I6pGe5KArExYsdPmLORDv+hvuDLjATN7
         artw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yrdMdr4CnXy1K7qhR03uSJz8LU6ClkU8Tex0C5hTdOM=;
        b=h/4fLiZQCFydQsHuVsEobFIXSPPyBH3ia4OuQ5RnToo/0gpgdYcVaE5Me3T/8bWMs/
         uKPLgLxzSXFxMgrKqFaqfoNkZwsR1yXO8ShOl3R4aaC2PjqqLtgxBjADkezsAuS6iVMu
         B6QoW18fXjjTmwdgPEF3J5qEq67SumA2zSBG+ZAEaCmi4gVbCBqupFQiSapnwWWrQmY7
         0AYUcZ1wTZesAhKG2kHsi7rFlngnU8qunY/cpLljhILDelK1y8guAfda0K6AktD//Ezp
         W7C5GXcebUWlNPpwG1J9FyXesVdFBfn4f6nWVTnVlpBNCik9W5n494C7uDEy+I5vAiRJ
         zGbw==
X-Gm-Message-State: ANoB5pm5uOyO7WkCr4CjCKfhJJxr3zi2HR5YkWP6PHCjo+EvWNLXlymd
        scRQCBaU0mMkHdpxUhLQbIE=
X-Google-Smtp-Source: AA0mqf7++aspAa/c6SXxFCEULFA9mOxgqnktB7jPp5bYtZ1H+QeL9U9cnMlXKvSUdGKrFHsWzSOoHA==
X-Received: by 2002:a05:6a00:1513:b0:576:f7bd:92d4 with SMTP id q19-20020a056a00151300b00576f7bd92d4mr12585186pfu.30.1670678337734;
        Sat, 10 Dec 2022 05:18:57 -0800 (PST)
Received: from debian.me (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id 81-20020a621954000000b0056b9ec7e2desm2742666pfz.125.2022.12.10.05.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 05:18:57 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 4BF0F104340; Sat, 10 Dec 2022 20:18:52 +0700 (WIB)
Date:   Sat, 10 Dec 2022 20:18:52 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Takahashi Akari <akaritakahashioss@gmail.com>,
        linux-kernel@vger.kernel.org, Networking <netdev@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Guofeng Yue <yueguofeng@hisilicon.com>,
        Geoff Levand <geoff@infradead.org>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: Re: [PATCH] <driver/net/ethernet/amd/nmclan_cs.c> Remove unnecessary
 line
Message-ID: <Y5SHPK0t821eX9Bw@debian.me>
References: <20221210084713.51710-1-akaritakahashioss@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qFwguExfwSZa56k7"
Content-Disposition: inline
In-Reply-To: <20221210084713.51710-1-akaritakahashioss@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qFwguExfwSZa56k7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 10, 2022 at 05:47:13PM +0900, Takahashi Akari wrote:
> Hello:
>=20
> I sent a patch. Please review and merge.
>=20
> Reason:
> Remove unnecessaty line. (if statement is always true)
>=20
> Git repository URL:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>=20
> File:
> drivers/net/ethernet/amd/nmclan_cs.c : 931
>=20

Hi and welcome to LKML!

Based on your patch, here are my notes:

  * Write the patch description in imperative mood (e.g. it should have
    been "Remove redundant inner tx_irq_disabled conditional in
    mace_interrupt() since it has already been handled". Wrap it in about
    72-75 column wide (to account indentation in git-log(1) so that the
    total line length is at maximum 80).
  * Write also short but concise patch subject (one-line summary), while al=
so
    paying attention to the subject prefix. In this
    case, it should have been "net: amd: remove inner tx_irq_disabled
    conditional".
  * Your patch looks like corrupted (tabs converted to spaces, linewrapped,
    etc.). Please configure your email-client not to do such things, or bet=
ter
    yet, use git-send-email(1) to send patches.
  * You need to Cc: relevant maintainers and lists, which can be obtained
    by `scripts/get_maintainer.pl -norolestats -separator , --=20
    /path/to/your/patch`. Personally I put lists in To: header and individu=
al
    addresses in Cc:. I have added them for you.
  * Last but not least, build the kernel with your patch applied (preferably
    enable W=3D1 and CONFIG_WERROR and also cross-compile).

See also tips from one of kernel subsystem maintainer at [1].

> Signed-off-by: Takahashi Akari <akaritakahashioss@gmail.com>
> ---
>  drivers/net/ethernet/amd/nmclan_cs.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/=
amd/nmclan_cs.c
> index 823a329a921f..a90e0c5b603d 100644
> --- a/drivers/net/ethernet/amd/nmclan_cs.c
> +++ b/drivers/net/ethernet/amd/nmclan_cs.c
> @@ -928,10 +928,7 @@ static irqreturn_t mace_interrupt(int irq, void *dev=
_id)
> =20
>    if (lp->tx_irq_disabled) {
>      const char *msg;
> -    if (lp->tx_irq_disabled)
> -      msg =3D "Interrupt with tx_irq_disabled";
> -    else
> -      msg =3D "Re-entering the interrupt handler";
> +    msg =3D "Interrupt with tx_irq_disabled";
>      netdev_notice(dev, "%s [isr=3D%02X, imr=3D%02X]\n",
>  		  msg,
>  		  inb(ioaddr + AM2150_MACE_BASE + MACE_IR),

Dunno if you need to also handle the else case (that gives "Re-entering" ms=
g)
in the outer conditional.

Thanks.

[1]: https://lore.kernel.org/all/20171026223701.GA25649@bhelgaas-glaptop.ro=
am.corp.google.com/

--=20
An old man doll... just what I always wanted! - Clara

--qFwguExfwSZa56k7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5SHNAAKCRD2uYlJVVFO
o6rYAP476bzbs47u6zwAyp+FqQPFkapu4ZyUoIiEdFWZnZPbTwEAzUSKzvWAPb1N
3/MH3mi/V/NrD9zd0tVbWfXQ4fiEug4=
=iAOf
-----END PGP SIGNATURE-----

--qFwguExfwSZa56k7--
