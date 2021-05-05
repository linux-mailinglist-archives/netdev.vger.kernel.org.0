Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D8D3747DA
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbhEESJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 14:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbhEESJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 14:09:09 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECE4C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 11:08:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id di13so3120963edb.2
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 11:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OyHHxl0o1nlSGoKlMC7YvjTbD4roq+ar0grvpcjq3pc=;
        b=LvJNEcAzr0JD6rg5e0Mm3LWsqXXeG6sLPhjCD2Ty7sWfLEmqL9AZ/SsLWbOQ4Ttv/7
         X12liaUy5vg4AWK5DB7MEB8xemMfZqLodiW8gAIs4g+lYaXLjijexGn7r2/Oa/lyktad
         0zufw1M2T9ircbE3sMAe3ehneOg8iVm4+kdZ29k7cEfuTrmBTHnC6Aebb9ecWoWEV2I2
         YTEHMiMWytRNZOzKGO6rRwzVXAnDetpVwYr10DFtTa0IMMbmzNg3F5i3evTmc0+h3Q/V
         X/XuJePgDqpoDwr5lJkDkHVBP4YBlB4a0AgYKhE2i64lWV2DD2CkG6MwU98cGMg9g2DG
         m2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OyHHxl0o1nlSGoKlMC7YvjTbD4roq+ar0grvpcjq3pc=;
        b=S1DAtMgfH/MobBJyp2xDlgd2XAcKETPMgFO+B2IXKLr26EKRmdd7xFoET7brV69t3V
         GzUj8ofaswJPexafLL6ZKIpgAD19/jrabkL6b29El9HO2e2QyvGWKGQi6c0nMd+9BZmH
         uhohf3GoFIhQE2cBOrQfBYVM4ZNingq2/o91J1a1K6CAqLpSFXAlOLoY/NyHn5jYO2cl
         2Psk5BfYLzzDqgTnk1f8n1Rkvw9WS+dY4MptQ5Xp4L3j9lD+1YZVq/RIyfiz54mH+rJE
         +aVSMVIz6YsFpwxDVy/lx330UEU504FEmkpu0PF9Pl6sY5MUDE8E6+bJlcKxP3mSLbP5
         WrBA==
X-Gm-Message-State: AOAM533u1LoVdXS1S2ErzisG0gvy+t8zJD+cdWn7qCMjunnufuINjLWp
        abTqazpwD8jTw6MTSJU1rOGpNfk75+GuPcgcO9Y=
X-Google-Smtp-Source: ABdhPJwNYbGv3u7Pqx1HkdhKedggZGzpUWGhLgMdWw5iKWKrRQUFA1cH/w16fWU1KvilaMmx3ilmaSrDMUwNGhinAuw=
X-Received: by 2002:a05:6402:138f:: with SMTP id b15mr317279edv.121.1620238090990;
 Wed, 05 May 2021 11:08:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-28-smalin@marvell.com>
 <156b840a-2ea2-0b3b-1bf6-7869838fccbe@suse.de>
In-Reply-To: <156b840a-2ea2-0b3b-1bf6-7869838fccbe@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Wed, 5 May 2021 21:08:00 +0300
Message-ID: <CAKKgK4yN7kfRrEEaBdMM5xxqtpahGP3611Hq6NJR0gojKBHmgw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 27/27] qedn: Add support of ASYNC
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 2:59 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> >
> > This patch implement ASYNC request and response event notification
> > handling at qedn driver level.
> >
> > NVME Ofld layer's ASYNC request is treated similar to read with
> > fake CCCID. This CCCID used to route ASYNC notification back to
> > the NVME ofld layer.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/hw/qedn/qedn.h      |   8 ++
> >   drivers/nvme/hw/qedn/qedn_main.c |   1 +
> >   drivers/nvme/hw/qedn/qedn_task.c | 156 +++++++++++++++++++++++++++++-=
-
> >   3 files changed, 156 insertions(+), 9 deletions(-)
> >
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
