Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851C6308D27
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhA2TKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhA2TJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:09:43 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76A9C06174A;
        Fri, 29 Jan 2021 11:08:59 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id c12so9910723wrc.7;
        Fri, 29 Jan 2021 11:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O23rlZtfo1FZK0qx/WutTi+hkYR2QPOf0nbtZy10Zxw=;
        b=DdVDH9ZXqAC6pKsXfQftK93OjTPC27Nw5D2M6I8L/f2uvZev0A9JsuKm0emyUXWDAF
         SM7M/J5PhQl9LL8FbOW4nNny9Or4Gkqp9wlfYzTawOjIgh2P71w8aSqwWH9J6OkZmR/z
         GpY8TDRxBO79rLhpmj6+29vwqm6hJmzjOy6ym74Rq3Qd5KbAWfoHO4pMnjuFrxqw5gbE
         9uGCmsJhWd+lFYGDpi2mUqyJdWdAgaeMHNofQjputA9/s65xjOmhqiCTbD+tW5nU+Ex1
         RJTAI7mK3KBmLP/le5Q01NDo6Ed8KhScv3SWrGEHMCjKt6GT6Tf5HZfXLQ5/5hIB8Y1Z
         5qpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O23rlZtfo1FZK0qx/WutTi+hkYR2QPOf0nbtZy10Zxw=;
        b=uISZpXuAqlEj+FCY9gquqskiRK8lGUWuXy3dUzsUrYMN3yU5Ak5FwCSUNfDhJCqYCe
         QH2Cxbc2YjpM67Td5zhiCFc+NG+AHk4NkErrNwKzK9m3kdTihxgP9prte9su/2Za/xEI
         WAjYg2Z40NdMyIkChFOoPFo5hvqk4jwGdri/NdGxkphReeJbTsVcdpG7FYMA8bb36vlQ
         rm7OawgDams0AC+7IpZqhMsb4Xba4y30X9tUnkLs7VLZAb43WrA7ilrOxuGrykyasjg+
         9nBDktPdKamw9lIO9URTfH4yxmVULD3Y9FntYwqTZRBD62gRDTS+zAAcNpOY773EEuqE
         8eHQ==
X-Gm-Message-State: AOAM530zu47yrmWVzv3ouVqpFhVtBnZFAIIFPH2LmZ62kQz4WbVDZqzo
        U3YPo4ReOneTJ0JOCu6rbI65QE/WLcKcLLR3ySE=
X-Google-Smtp-Source: ABdhPJzAbgdkkapiGmzGouxTGwveq5m7LmJNveRCk+Kv9qY2evOh0QQsbBh6o6uIYkABxwRfFnIBxorHq8dmbcxo0OQ=
X-Received: by 2002:a5d:49cf:: with SMTP id t15mr6034971wrs.217.1611947338629;
 Fri, 29 Jan 2021 11:08:58 -0800 (PST)
MIME-Version: 1.0
References: <20210127215010.99954-1-uwe@kleine-koenig.org>
In-Reply-To: <20210127215010.99954-1-uwe@kleine-koenig.org>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Fri, 29 Jan 2021 13:08:45 -0600
Message-ID: <CAOhMmr4ZMXS+R3AcdKm3qcePfuaZeC-0dNWvsSzowbv5hXo2-Q@mail.gmail.com>
Subject: Re: [PATCH] vio: make remove callback return void
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
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 6:41 PM Uwe Kleine-K=C3=B6nig <uwe@kleine-koenig.or=
g> wrote:
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
>
> Note that for the powerpc implementation there is a semantical change:
> Before this patch for a device that was bound to a driver without a
> remove callback vio_cmo_bus_remove(viodev) wasn't called. As the device
> core still considers the device unbound after vio_bus_remove() returns
> calling this unconditionally is the consistent behaviour which is
> implemented here.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <uwe@kleine-koenig.org>

Acked-by: Lijun Pan <ljp@linux.ibm.com>
