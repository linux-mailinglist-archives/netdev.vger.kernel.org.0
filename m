Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF822DAE10
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 14:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgLONev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 08:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgLONeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 08:34:44 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580B0C0617A6
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 05:34:04 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cm17so21044158edb.4
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 05:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8fHZY8jQhIBpusF6yf8e92qQDUahX34y07cjU+x+4Lc=;
        b=cO/R8zqzXQWaqT/sxc9QrhmMQ2504daZiE8+OwYV4SXqyBvDGUtrz9RfITI24qs9Wo
         j/eq9yOerSXt+zy1In85b1+nscjDqMKMC+0peh5PgLjQ+9be35aZyQJEi//jyAtT4Oe3
         fE1VKs79YGUHzNdq9eOcX2SXWF831SNcnGl5bngL3X6j+HOl0oX+ZKNmKySDU3LYYine
         JQwFUUCETA/CngNdVEkHP4jTArbiUAs/TaPaKrV5BqM0BUxv+I4/GP9NGkhwQoanUMt6
         bA9cuoCvN/zEet9oHUn/36WFPydl4hsLpq7HTFoSaLVEuckDOL/fmUYojEhtdTyiLE/l
         Wp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8fHZY8jQhIBpusF6yf8e92qQDUahX34y07cjU+x+4Lc=;
        b=MuUVHrk7spTN1dXmqytdYJ3cSbhpBektluTz81NPS3TyS13UODCcTOdG34TAUh/cCG
         T8llR9zb18t85vuBK2WOiK22st1CF+qAfkqP+MBFnfKgCa11JXwEDzSfHm0gczwo2Igd
         wLOUCVXJy06eUOEbDgz92W4ENHze0ixvUhF9mb9TCq3AX0v+f+4aJKz75oXPye0nR1pW
         5TXpQNdg7z2vHL7B/BA82g7r+TbXf2bEf26tCo36n5wUcnuAtQGIPd4Vu/IG4Ui4H6P5
         OXc1tNDBfciVjT3hzOTJvX/X30K5KFdmC5lykP871e+QSlbJbxDwcCumsVcpVopkO6ck
         Gm3A==
X-Gm-Message-State: AOAM530SWmeWqkoOyM024yjbGweOFyKhM2qtzN+jaEHEvcHNpf3IIdq1
        /Mk5ynIhQQM4CKAC+bU+oViPwGIM+pJkG3Tsmko=
X-Google-Smtp-Source: ABdhPJyOR8l+ibYSEWSbxbgeDrfjSe24miZDy1PKnHAvU2OPvW5AecKexf8MaJ2VVOKAVGTZVgbXdYNr6BRVh7dc5yo=
X-Received: by 2002:a50:8744:: with SMTP id 4mr29241136edv.362.1608039242936;
 Tue, 15 Dec 2020 05:34:02 -0800 (PST)
MIME-Version: 1.0
References: <20201207210649.19194-1-borisp@mellanox.com> <20201207210649.19194-6-borisp@mellanox.com>
 <PH0PR18MB3845486FF240614CA08E7B4CCCCB0@PH0PR18MB3845.namprd18.prod.outlook.com>
 <0a272589-940c-6488-9cb9-1833400f38b3@gmail.com>
In-Reply-To: <0a272589-940c-6488-9cb9-1833400f38b3@gmail.com>
From:   Shai Malin <malin1024@gmail.com>
Date:   Tue, 15 Dec 2020 15:33:50 +0200
Message-ID: <CAKKgK4xvS9SeM3NmNKDNe5oFxxfi0m_=iHCXeXX0DGcgzG_BBA@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 05/15] nvme-tcp: Add DDP offload control path
To:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "edumazet@google.com" <edumazet@google.com>
Cc:     Yoray Zack <yorayz@mellanox.com>,
        "yorayz@nvidia.com" <yorayz@nvidia.com>,
        "boris.pismenny@gmail.com" <boris.pismenny@gmail.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        "benishay@nvidia.com" <benishay@nvidia.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "ogerlitz@nvidia.com" <ogerlitz@nvidia.com>,
        Shai Malin <smalin@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Shai Malin <malin1024@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/2020 08:38, Boris Pismenny wrote:
> On 10/12/2020 19:15, Shai Malin wrote:
> > diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c index c0c33320fe65..ef96e4a02bbd 100644
> > --- a/drivers/nvme/host/tcp.c
> > +++ b/drivers/nvme/host/tcp.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/blk-mq.h>
> >  #include <crypto/hash.h>
> >  #include <net/busy_poll.h>
> > +#include <net/tcp_ddp.h>
> >
> >  #include "nvme.h"
> >  #include "fabrics.h"
> > @@ -62,6 +63,7 @@ enum nvme_tcp_queue_flags {
> >       NVME_TCP_Q_ALLOCATED    = 0,
> >       NVME_TCP_Q_LIVE         = 1,
> >       NVME_TCP_Q_POLLING      = 2,
> > +     NVME_TCP_Q_OFFLOADS     = 3,
> >  };
> >
> > The same comment from the previous version - we are concerned that perhaps
> > the generic term "offload" for both the transport type (for the Marvell work)
> > and for the DDP and CRC offload queue (for the Mellanox work) may be
> > misleading and confusing to developers and to users.
> >
> > As suggested by Sagi, we can call this NVME_TCP_Q_DDP.
> >
>
> While I don't mind changing the naming here. I wonder  why not call the
> toe you use TOE and not TCP_OFFLOAD, and then offload is free for this?

Thanks - please do change the name to NVME_TCP_Q_DDP.
The Marvell nvme-tcp-offload patch series introducing the offloading of both the
TCP as well as the NVMe/TCP layer, therefore it's not TOE.

>
> Moreover, the most common use of offload in the kernel is for partial offloads
> like this one, and not for full offloads (such as toe).

Because each vendor might implement a different partial offload I
suggest naming it
with the specific technique which is used, as was suggested - NVME_TCP_Q_DDP.
