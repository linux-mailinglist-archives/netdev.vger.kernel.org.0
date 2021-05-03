Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F568371874
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 17:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhECPv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 11:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbhECPv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 11:51:56 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90810C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 08:51:02 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id t4so8652121ejo.0
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 08:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PovfX3jhu3r6iqd6p4kIrUtBHHGyYiOcYQxAFFzrIyU=;
        b=RFJGyoSptXVvpRoYVLjEu25OL24l9jhAEJUMj6X8nt/Zw0slfVPqy8XT1/qPlaMard
         lUVfw0Ie6pZOw/FXFa5+nZ/3V93LVnn08AW2kutqyYhl7F4YOktQjMy8R0/oKWK3kwo6
         bf5C8KFfYe+FsLfuZwjOWZbPxIZAipWGvTLorSBEFNCosrJhcnUmBaBTWFP1dziSHGlF
         HGqrvYi8nua35g4XoAQVqB/VgzrM+mUu0RPE9KepOEdDFARxg8yOo9/wxNC6rBn/rLFO
         rVdWkWtPODP61wicaz6ukUd9qkwImTscTsLr8L1syqTigfZrRhMieLeD8D8ZrCQibO38
         KMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PovfX3jhu3r6iqd6p4kIrUtBHHGyYiOcYQxAFFzrIyU=;
        b=LyYAvSFhcGZAZIM3NHGLmxfFB3QuPsvJyj9SOy1+aMhf1bGcmOXC2x3Ac9ObK3T4D/
         gg40sPI0op1Q97FioyFQOlKPRHKayZpsSwXK5P7P3DHzTM97S8XUpkYr+POitBG3zh/g
         VdKzfQaSfwlDTRdAMg27BIVnY/NaxxFYgTULpoueAmhocymm9YZ21HraLsxkcbN2Qizj
         09Fh6lYvw9SNMYmWLykPv7Y+yBqcXdG+XCr2aAJx/usEWK0+CfGGx1BmhgOW3kFHgSFc
         ndIC81hAi+3p+j/A9McCaDyRcsNwD+wutUP14fr4gBLnH9CHoahW1rm4JERjosxFoGVZ
         /XXg==
X-Gm-Message-State: AOAM532SeghoB8XTibHVzJnkI9faJc94UKOEZjMNkLnwe4Z762M920oP
        Jjfs13fhhrA2YODNTEPMQwoEHpUfztEEkx/taYrSKLKu/OU=
X-Google-Smtp-Source: ABdhPJzxsNxYaCCkUJEvotJ3llpWHkTeyv8vNd4/4Y6nI+M4HqyRdwbcHs6B0ubm5O/USWNfTEOP8RXYknQzF3h8uQw=
X-Received: by 2002:a17:906:3a45:: with SMTP id a5mr17902408ejf.288.1620057061232;
 Mon, 03 May 2021 08:51:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-10-smalin@marvell.com>
 <62c750cb-b757-510e-a2fa-849f8f89d6e2@suse.de>
In-Reply-To: <62c750cb-b757-510e-a2fa-849f8f89d6e2@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 3 May 2021 18:50:50 +0300
Message-ID: <CAKKgK4z=pCgXZW-dk0pweGc_w2rLqfyhoWgWMkzjV0pogoecyg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 09/27] nvme-fabrics: Move NVMF_ALLOWED_OPTS and
 NVMF_REQUIRED_OPTS definitions
To:     Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Arie Gershberg <agershberg@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 3:19 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Arie Gershberg <agershberg@marvell.com>
> >
> > Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS definitions
> > to header file, so it can be used by transport modules.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/host/fabrics.c | 7 -------
> >   drivers/nvme/host/fabrics.h | 7 +++++++
> >   2 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
> > index 604ab0e5a2ad..55d7125c8483 100644
> > --- a/drivers/nvme/host/fabrics.c
> > +++ b/drivers/nvme/host/fabrics.c
> > @@ -1001,13 +1001,6 @@ void nvmf_free_options(struct nvmf_ctrl_options =
*opts)
> >   }
> >   EXPORT_SYMBOL_GPL(nvmf_free_options);
> >
> > -#define NVMF_REQUIRED_OPTS   (NVMF_OPT_TRANSPORT | NVMF_OPT_NQN)
> > -#define NVMF_ALLOWED_OPTS    (NVMF_OPT_QUEUE_SIZE | NVMF_OPT_NR_IO_QUE=
UES | \
> > -                              NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
> > -                              NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT =
|\
> > -                              NVMF_OPT_DISABLE_SQFLOW |\
> > -                              NVMF_OPT_FAIL_FAST_TMO)
> > -
> >   static struct nvme_ctrl *
> >   nvmf_create_ctrl(struct device *dev, const char *buf)
> >   {
> > diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
> > index 888b108d87a4..b7627e8dcaaf 100644
> > --- a/drivers/nvme/host/fabrics.h
> > +++ b/drivers/nvme/host/fabrics.h
> > @@ -68,6 +68,13 @@ enum {
> >       NVMF_OPT_FAIL_FAST_TMO  =3D 1 << 20,
> >   };
> >
> > +#define NVMF_REQUIRED_OPTS   (NVMF_OPT_TRANSPORT | NVMF_OPT_NQN)
> > +#define NVMF_ALLOWED_OPTS    (NVMF_OPT_QUEUE_SIZE | NVMF_OPT_NR_IO_QUE=
UES | \
> > +                              NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
> > +                              NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT =
|\
> > +                              NVMF_OPT_DISABLE_SQFLOW |\
> > +                              NVMF_OPT_FAIL_FAST_TMO)
> > +
> >   /**
> >    * struct nvmf_ctrl_options - Used to hold the options specified
> >    *                        with the parsing opts enum.
> >
>
> Why do you need them? None of the other transport drivers use them, why y=
ou?
>

Different HW devices that are offloading the NVMeTCP might have different
limitations of the allowed options.
For example, a device that does not support all the queue types.
With tcp and rdma, only the nvme-tcp and nvme-rdma layers handle those
attributes and the HW devices do not create any limitations for the allowed
options.

An alternative design could be to add separate fields in nvme_tcp_ofld_ops =
such
as max_hw_sectors and max_segments that we already have in this series.

Which would you prefer?

> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
