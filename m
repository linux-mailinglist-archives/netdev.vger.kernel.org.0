Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCFF325126
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 15:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhBYOC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230467AbhBYOCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 09:02:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33D3764F1B;
        Thu, 25 Feb 2021 14:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614261702;
        bh=gB6SQ75V2Rk37+UKLUfmsXNjtKCUUEXnmz4FEJPQVQY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iGKh9gRLvR8o04SWuKsCmipjtlzTrYuO47BWoJKHisDTteOpg/JDJDJJNnt+rGTTb
         0rw4Z/+2u64PifagBhihDsPlyJ67Y3oQmsZn/oOul3KOK4yi2rGalMnkTSGw0hDAQu
         5UCXh/aLF+AKNOXFFYPj9pbvUcZ+cJQXjOePkvmGZX37GfJUD/b8DZYdke/mmAKvZT
         fAGvXP4lcs8maCpu0ckyrKPIoHkrpGb6cRtLNo09qQE/bWR08AfpprntjG9xmxGdei
         eNSETbirr5t3ogcQ9xtRSswYiW1kh8gzy8rrgKIT9HRwylXF4qapcoQRRth0EghGpX
         ctCpWU8hVtI2A==
Received: by mail-oo1-f51.google.com with SMTP id x10so1389976oor.3;
        Thu, 25 Feb 2021 06:01:42 -0800 (PST)
X-Gm-Message-State: AOAM530YQNSUY6DI1p/w+oMByG+xrschcT2x6xk2C68fFUBMnyNwDQQJ
        HRKQc6KM13zEsopqRnEASZN4oYZnOLKbfAR4rYM=
X-Google-Smtp-Source: ABdhPJy0Z8oAC8F3qvd9r/HrjNWv0zSRZwzOF/sqWqHtbHpdIOPcLKBh4nK6FxEKGL+hdddWAENt07LK/yhwcmvgmrE=
X-Received: by 2002:a4a:870c:: with SMTP id z12mr2391944ooh.15.1614261701193;
 Thu, 25 Feb 2021 06:01:41 -0800 (PST)
MIME-Version: 1.0
References: <20210224072516.74696-1-uwe@kleine-koenig.org> <87sg5ks6xp.fsf@mpe.ellerman.id.au>
In-Reply-To: <87sg5ks6xp.fsf@mpe.ellerman.id.au>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 25 Feb 2021 15:01:25 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1q=zqyOxBgV-nprpN3jBczZWexupkA1Wy6g+AEW6rQqw@mail.gmail.com>
Message-ID: <CAK8P3a1q=zqyOxBgV-nprpN3jBczZWexupkA1Wy6g+AEW6rQqw@mail.gmail.com>
Subject: Re: [PATCH v2] vio: make remove callback return void
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <uwe@kleine-koenig.org>,
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
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-integrity@vger.kernel.org,
        Networking <netdev@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 12:52 PM Michael Ellerman <mpe@ellerman.id.au> wrot=
e:
>
> Uwe Kleine-K=C3=B6nig <uwe@kleine-koenig.org> writes:
> > The driver core ignores the return value of struct bus_type::remove()
> > because there is only little that can be done. To simplify the quest to
> > make this function return void, let struct vio_driver::remove() return
> > void, too. All users already unconditionally return 0, this commit make=
s
> > it obvious that returning an error code is a bad idea and makes it
> > obvious for future driver authors that returning an error code isn't
> > intended.
> >
> > Note there are two nominally different implementations for a vio bus:
> > one in arch/sparc/kernel/vio.c and the other in
> > arch/powerpc/platforms/pseries/vio.c. I didn't care to check which
> > driver is using which of these busses (or if even some of them can be
> > used with both) and simply adapt all drivers and the two bus codes in
> > one go.
>
> I'm 99% sure there's no connection between the two implementations,
> other than the name.
>
> So splitting the patch by arch would make it easier to merge. I'm
> reluctant to merge changes to sparc code.

The sparc subsystem clearly started out as a copy of the powerpc
version, and serves roughly the same purpose, but the communication
with the hypervisor is quite different.

As there are only four drivers for the sparc vio subsystem:
drivers/block/sunvdc.c
drivers/net/ethernet/sun/ldmvsw.c
drivers/net/ethernet/sun/sunvnet.c
drivers/tty/vcc.c
maybe it would make sense to rename those to use distinct
identifiers now?

       Arnd
