Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AEA3717FC
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 17:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhECP3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 11:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhECP3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 11:29:06 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AAAC06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 08:28:12 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id c22so6746903edn.7
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 08:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s/OGxKTRhjN8cMwpa1nCfVPRRvIUlqY8n6JRtgjGsPk=;
        b=e7djG/yChudtUnxkAM1M0m3O/btXlqSvEIZaGKDH0MRJCUzNcbgP1Iz+eLNrjRH/2Q
         jooMwp0sCEXKk/nO6gaN8QBDkMNpUSyGf0Ev6R/zr9dtn1sNwpmbZjH9gdQ2s579bbhX
         iYyKccmsZqHBb8A90XdwGf9FTeKUz8bwnsscH7ENhDzrxuc6ZG5MSjWKelfnA+7TMcyw
         D2holJ3W1/vEoRar9yu158Aq56VbZO4K5ZYqqJMLB+vhrUvt7ZPEoFZlbA/1gGfA2Vvi
         BvXX3KjgbaErFyEyp5K+aT1m1sU0Wcaus5ePHvtBmv02Oppw7rLo9rhIW8DrxvA1RjyH
         ZRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s/OGxKTRhjN8cMwpa1nCfVPRRvIUlqY8n6JRtgjGsPk=;
        b=SyXOINP+tJ8c3GV0qxB//+aZsXkctaA0CfD2OQgvbaOpThKgP7xA4tEOo+bH4zI/rn
         8NwzmbrUyzwpZ2T0G8fcRPWT65g2HH5kP33iCnpzpPGuHISfoa+YDcoC+nKhUOjY2hXR
         xAFWQhD3LmunXWghhoQsEWhTQHAGeWALydWIHouwkh4qkVouEPSvJOZQoh1JjD1QAeX4
         R+2KyF5QnCdjjkGxDhOBg/u0SZHO8/ofcUDbjiW2ivAbh9ohpi1LXvJw09x7D+cjKXUG
         INMvCRPWRn/wlOl54FODAujsVpzTOGdWDuUw5erOj0Hm79NX5/iigyODgQU5ytEznUFa
         QaJQ==
X-Gm-Message-State: AOAM531Me99+Hid1cVe+QRmRR0kX4KEKqKhgvpzAe6QHkz9NosMo+Ja7
        M+7uuD3iv4AfgWzserDmv6zj+RVKSpkqOlIU+ac=
X-Google-Smtp-Source: ABdhPJyPH6OfRnqPDHbnscuBMP7D0B6z5vhOsjxfVWu9M+MvN8J9zm9A+X/zAUdgcT+m3x00n3v4/FaSCjvj6/zjhzI=
X-Received: by 2002:a05:6402:35c4:: with SMTP id z4mr4371665edc.362.1620055690674;
 Mon, 03 May 2021 08:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-5-smalin@marvell.com>
 <761a58da-2933-4750-510e-c12dfe8f919c@suse.de>
In-Reply-To: <761a58da-2933-4750-510e-c12dfe8f919c@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 3 May 2021 18:27:59 +0300
Message-ID: <CAKKgK4xr4E129jtTPK00PbW_FSzm-VDeui0B0fAUvxvvWS+H7g@mail.gmail.com>
Subject: Re: [RFC PATCH v4 04/27] qed: Add support of HW filter block
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 2:13 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> >
> > This patch introduces the functionality of HW filter block.
> > It adds and removes filters based on source and target TCP port.
> >
> > It also add functionality to clear all filters at once.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > ---
> >   drivers/net/ethernet/qlogic/qed/qed.h         |  10 ++
> >   drivers/net/ethernet/qlogic/qed/qed_dev.c     | 107 +++++++++++++++++=
+
> >   drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c |   5 +
> >   include/linux/qed/qed_nvmetcp_if.h            |  24 ++++
> >   4 files changed, 146 insertions(+)
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
