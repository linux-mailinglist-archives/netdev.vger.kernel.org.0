Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF3C37183C
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 17:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhECPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 11:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbhECPrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 11:47:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460AEC06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 08:46:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u21so8531547ejo.13
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 08:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e5urHp2pKhem2MEsTQYPlFemG31abPiVuCzUED6xLlM=;
        b=qcJ49LyQi32B8nQgKz0pVycJUDXgKlF3UC34odKI5DOVbh6eqD0b0XyaVo/kseNstn
         bSv2FLdzXXu/98WlqBPYRIlmDr3x+Z7vFBI6/T8rY2Cn46wFn3TooopWxDFR7nLIkm1Z
         rO/X47ThDNPJQZJfrdZkvE56bYWcA1gnm+3KdXq/UkNYgMeydsA5rF292au64mu2koAF
         YhzljUj0m1ke3P8WMN1jz5IqAPpuUSNghE3jXwKpV/z8Yb2A0j5v4KAcvfHf9W4X+1LK
         xJksR/17NM7g9QbVE7hMf3yRmWQ7FEIB5Ms6jLWmf6fyzcyXFcZ7FI1rWNpSgqNb7vky
         Qzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e5urHp2pKhem2MEsTQYPlFemG31abPiVuCzUED6xLlM=;
        b=Mq/fRpHIbmvWHkZ32yhNeRx7oNyXtfZYOA/Kp0mkQx3QdM5VTkBvpnHh47tBux6f7K
         HQ5ev7Bhy7Yul6OWc/Y16H212ZCU8ScIrzSEcC4dYC1hc5B/A2mcNTz/5dgECmzooCGO
         Z17RwxM/2ZcOValeUdfwpxL3p/MgINo3tpU1BIOth3mTkxD71iIjWjk04J5kZ5JnGams
         TUajpbES8P28SNj/sDK8llry6G+aDR1HOZSj0UvhgyE+MxAUvsujuvCeiVF7QKXoIP7G
         xkQ4a1eIulBRaof/hmdCqgiel/6rY1l7Anb2Xr0w2Pkgfs/KjCSmi7LIah0d/wFpHQBr
         CCzA==
X-Gm-Message-State: AOAM5317CXODsqPV1qKetp4wosfTiLpXAryPF/79U9kw66m8JlBTs5oV
        PU/LQsaa4uDNl0RU1OPdbzrCzAumFb8tNTGzChY=
X-Google-Smtp-Source: ABdhPJyoTkJmtTXEDMO202XSpVgDCWthvq3f0YU6ntgiWaRBqz4OKJvDEZxtTpcEjKNrkZgE8evzI4fB1076HfS3Mho=
X-Received: by 2002:a17:906:3a45:: with SMTP id a5mr17881005ejf.288.1620056776960;
 Mon, 03 May 2021 08:46:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-9-smalin@marvell.com>
 <7831d4ff-9e47-3c43-8725-95eb0bdd7107@suse.de>
In-Reply-To: <7831d4ff-9e47-3c43-8725-95eb0bdd7107@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 3 May 2021 18:46:05 +0300
Message-ID: <CAKKgK4z28-gGB05y3nOPpok22H9tYzPQyYZXF4UpTcsR31e9AQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 08/27] nvme-tcp-offload: Add nvme-tcp-offload -
 NVMeTCP HW offload ULP
To:     Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 3:18 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > This patch will present the structure for the NVMeTCP offload common
> > layer driver. This module is added under "drivers/nvme/host/" and futur=
e
> > offload drivers which will register to it will be placed under
> > "drivers/nvme/hw".
> > This new driver will be enabled by the Kconfig "NVM Express over Fabric=
s
> > TCP offload commmon layer".
> > In order to support the new transport type, for host mode, no change is
> > needed.
> >
> > Each new vendor-specific offload driver will register to this ULP durin=
g
> > its probe function, by filling out the nvme_tcp_ofld_dev->ops and
> > nvme_tcp_ofld_dev->private_data and calling nvme_tcp_ofld_register_dev
> > with the initialized struct.
> >
> > The internal implementation:
> > - tcp-offload.h:
> >    Includes all common structs and ops to be used and shared by offload
> >    drivers.
> >
> > - tcp-offload.c:
> >    Includes the init function which registers as a NVMf transport just
> >    like any other transport.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/host/Kconfig       |  16 +++
> >   drivers/nvme/host/Makefile      |   3 +
> >   drivers/nvme/host/tcp-offload.c | 126 +++++++++++++++++++
> >   drivers/nvme/host/tcp-offload.h | 206 +++++++++++++++++++++++++++++++=
+
> >   4 files changed, 351 insertions(+)
> >   create mode 100644 drivers/nvme/host/tcp-offload.c
> >   create mode 100644 drivers/nvme/host/tcp-offload.h
> >
> It will be tricky to select the correct transport eg when traversing the
> discovery log page; the discovery log page only knows about 'tcp' (not
> 'tcp_offload'), so the offload won't be picked up.
> But that can we worked on / fixed later on, as it's arguably a policy
> decision.

I agree that we should improve the policy decision and allow additional
capabilities and it may be discussed as a new NVMe TPAR.

>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

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
