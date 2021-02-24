Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3777323AF9
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhBXLC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbhBXLB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:01:58 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23DBC061574;
        Wed, 24 Feb 2021 03:01:17 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id u3so1443540ybk.6;
        Wed, 24 Feb 2021 03:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q5EBUPu7DHD+FuA5SGZ+0iNoNfQivrRarTOBbjTJdyk=;
        b=PpKt4nXgl8dkkxBzxuaLrjlXX0hqqCr8wUyXp2yPXNJFwryHemyu90dCsMWVBumO+n
         1RL9h3nYbcv61lEowunFuKgz64z7Yzeh8Lgpc+qhcQk3o47Q8vXTa/1JqCs0I07wh3ha
         Uz5wfupBLDaMNbhfqzaE3k0qhkd7I5DtWuNC4bkQLJKrI5aDDHXPPyyYB1y2GQNdUs5T
         5kHhKZrfhGu76w2/xSocoV9KQw24jWXlmIw0Kwd03g0L4j4RAnepznV2u3xE8Gs6fLMU
         EAMzIh826mV8TtupQHPvIlfwN+/s/AhkuamaO0KCG5dcOHlst96H3i75lGMtPG9LM+IU
         /Deg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q5EBUPu7DHD+FuA5SGZ+0iNoNfQivrRarTOBbjTJdyk=;
        b=IzZAkbHDJe/QJxIrdWGAU7lMkIiSCp/M20ACbkl7H7Z5BowIQYipLWV7JJ9QJkuuW2
         kN2KRYe5dcOGCPBVIqqtcpQ61KZsSSD49GQu1czAov4HVUKBslbkpxTCRC1XGaG8D9dQ
         ZYREryi2RCLrupnbYaye33/JzV03zilCFZANV0ekc+HR+M2kCOielz1OJJbYbmjFROlV
         60DsShvsNHn70F56NyAX11S9HJTj3eZYrSGBsScWRdo1g6LeIwZGjKLQm6pulRX5oyT6
         RAeGJM735uA3Q0JYf6Gf6WJFtZe1M6Mw4q6QIop2j9K6Rt1xV21x8c9mIz6PtGJdr9aS
         K5Fg==
X-Gm-Message-State: AOAM53144j2dPkZAsYro/5kmeOUcS4zkYpsR/piAqpI8etuM+Yil6d4v
        lJLETuMZhNYS//i8LnwTuWMrGnELvGVAkZyE49I=
X-Google-Smtp-Source: ABdhPJxhiCfGjIzPOx2Fqgi7qb3IEYMwNvLkNSu5A5vWCLP2a0ja0byv/ganfMSniEGrB2L8iDsLWc4l18D5rmld2Ec=
X-Received: by 2002:a25:324b:: with SMTP id y72mr46115248yby.233.1614164477289;
 Wed, 24 Feb 2021 03:01:17 -0800 (PST)
MIME-Version: 1.0
References: <20210224072516.74696-1-uwe@kleine-koenig.org>
In-Reply-To: <20210224072516.74696-1-uwe@kleine-koenig.org>
From:   Anatoly Pugachev <matorola@gmail.com>
Date:   Wed, 24 Feb 2021 14:01:06 +0300
Message-ID: <CADxRZqzG7jtNwYsdnO1xm8FLes_+GqTB=2naxaUTP2MNkzGG3g@mail.gmail.com>
Subject: Re: [PATCH v2] vio: make remove callback return void
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <uwe@kleine-koenig.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Haren Myneni <haren@us.ibm.com>,
        =?UTF-8?Q?Breno_Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Steven Royer <seroyer@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Sparc kernel list <sparclinux@vger.kernel.org>,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 11:17 AM Uwe Kleine-K=C3=B6nig <uwe@kleine-koenig.o=
rg> wrote:
>
> The driver core ignores the return value of struct bus_type::remove()
> because there is only little that can be done. To simplify the quest to
> make this function return void, let struct vio_driver::remove() return
> void, too. All users already unconditionally return 0, this commit makes
> it obvious that returning an error code is a bad idea and makes it
> obvious for future driver authors that returning an error code isn't
> intended.
>
> Note there are two nominally different implementations for a vio bus:
> one in arch/sparc/kernel/vio.c and the other in
> arch/powerpc/platforms/pseries/vio.c. I didn't care to check which
> driver is using which of these busses (or if even some of them can be
> used with both) and simply adapt all drivers and the two bus codes in
> one go.

Applied over current git kernel, boots on my sparc64 LDOM (sunvdc
block driver which uses vio).
Linux ttip 5.11.0-10201-gc03c21ba6f4e-dirty #189 SMP Wed Feb 24
13:48:37 MSK 2021 sparc64 GNU/Linux
boot logs (and kernel config) on [1] for "5.11.0-10201-gc03c21ba6f4e-dirty"=
.
Up to you to add "tested-by".
Thanks.

1. https://github.com/mator/sparc64-dmesg

PS: going to check with ppc64 later as well on LPAR (uses vio).
