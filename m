Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83611372E45
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhEDQx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhEDQx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 12:53:26 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D15C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 09:52:31 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b17so8229200ede.0
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 09:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S9An/4KRHHEsRc5JqJ5HmbiRGmmXFpeFAxk37d4lG3o=;
        b=JnTnb3mxA44OvVQIzk+R8P4FSWgmymxIlQgaZrM5XfJKjdc1LgMnlXYZ9wurxzHOgn
         n7FA3GnEijzxTPelFi01qADd97BkT5KSApS6HtTHrZvwODq8IxOB0ThWwwmfZm6QH4FR
         +k81HqBGpcg1yN3A3WO1mP71H9b24xdxeKWCGtzvIe9VtZg23tBem1VLkGwqnIjO/soy
         vuv73x7vGvHwyBywyHdB6w6fAmf+fydTzdAk6CAomHUdHrilU5hj1eRlXc8Jp194blxO
         yu7sa0pIqqAcRTsIUt96s+D8LIvSkxBuRnvjBHCg7LybnKS5/1bRv+qAdPdUtROvgVfO
         SrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S9An/4KRHHEsRc5JqJ5HmbiRGmmXFpeFAxk37d4lG3o=;
        b=DTSjVZtZLQCZVc/XWL28Otu5mljeXBKdwDVEBTTALBCn1fiaRV35XExx/Q5V2nCzvc
         62msTCyHuUuikcNjR70RljRcPwNBdXLK1Y2XTPEablEMWB3VF7B6SJcSDfp2en/aVAHV
         e4aV5Gc1Sp8yJO3AscFz23CoVwPqX2HhuBD/Ff22lORP1fgq51YfrhvcVZYHsrkTHrGo
         Z7fkqIaCf2IdvuTeRODWPIMEtEZVVE6Zo1rhCuK9o0X8zESQvnt06CX6EB8NNqOwypdC
         b4qxWDm8YS5ZtrrG0JAyBdYLO+WEwOHmGo6h5rxkWrjTcUjNabqDrgYoIkniOyWEzbZ/
         mcnQ==
X-Gm-Message-State: AOAM533QWLhvaoP1T1wqH2uRKe7RTusp00F9oE1HjZstrDtZ0zgMisfD
        gg2MWrXOW5mLfVeAaLOaV8ZvvH8XjKjh+oDnuUY=
X-Google-Smtp-Source: ABdhPJzYXgIMgrBymTxMB6fabBb7YbN947QvsDWyG1TaFm+4dWIALaoRGSJSHnebMz/rK2613adXOPpK8Su4CoWJMyw=
X-Received: by 2002:a05:6402:1a2f:: with SMTP id be15mr26955492edb.207.1620147149831;
 Tue, 04 May 2021 09:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-17-smalin@marvell.com>
 <4c17c44e-a08a-93cc-5ccf-51045cba0f0f@suse.de>
In-Reply-To: <4c17c44e-a08a-93cc-5ccf-51045cba0f0f@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Tue, 4 May 2021 19:52:18 +0300
Message-ID: <CAKKgK4wDV_BEsE1kkH2vxreeuaOnv=1+vvX7J3F7oTzzO-_PKA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 16/27] qedn: Add qedn - Marvell's NVMeTCP HW
 offload vendor driver
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Arie Gershberg <agershberg@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 2:27 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > This patch will present the skeleton of the qedn driver.
> > The new driver will be added under "drivers/nvme/hw/qedn" and will be
> > enabled by the Kconfig "Marvell NVM Express over Fabrics TCP offload".
> >
> > The internal implementation:
> > - qedn.h:
> >    Includes all common structs to be used by the qedn vendor driver.
> >
> > - qedn_main.c
> >    Includes the qedn_init and qedn_cleanup implementation.
> >    As part of the qedn init, the driver will register as a pci device a=
nd
> >    will work with the Marvell fastlinQ NICs.
> >    As part of the probe, the driver will register to the nvme_tcp_offlo=
ad
> >    (ULP).
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   MAINTAINERS                      |  10 ++
> >   drivers/nvme/Kconfig             |   1 +
> >   drivers/nvme/Makefile            |   1 +
> >   drivers/nvme/hw/Kconfig          |   8 ++
> >   drivers/nvme/hw/Makefile         |   3 +
> >   drivers/nvme/hw/qedn/Makefile    |   5 +
> >   drivers/nvme/hw/qedn/qedn.h      |  19 +++
> >   drivers/nvme/hw/qedn/qedn_main.c | 201 ++++++++++++++++++++++++++++++=
+
> >   8 files changed, 248 insertions(+)
> >   create mode 100644 drivers/nvme/hw/Kconfig
> >   create mode 100644 drivers/nvme/hw/Makefile
> >   create mode 100644 drivers/nvme/hw/qedn/Makefile
> >   create mode 100644 drivers/nvme/hw/qedn/qedn.h
> >   create mode 100644 drivers/nvme/hw/qedn/qedn_main.c
> > Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks.

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
