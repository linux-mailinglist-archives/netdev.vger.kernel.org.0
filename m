Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EAF376681
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 15:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbhEGN6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 09:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbhEGN6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 09:58:23 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580D1C061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 06:57:21 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id t4so13837918ejo.0
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 06:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QlTz9xj6lp+eZnKQtXhoB95xBxoI3W/Ee89KukGEB7w=;
        b=QESgEzJYkBr06wWFLgYi2/S0tq43bdS5yYhvRTo9rISFL88E/d7McPhgit1fGOt5/u
         WHt8wxpBywi21Sn0ZVf7GTiXftzNUXNAdMmG0j6cG96Td0tKEAkEhQDTk9aEfwyt7i3T
         CYYZ+gUc2HAw/gkVUHmKSg4EQK0oIbyhjRk9bI40pGkU+lD4O5GKd8h/GY+uptIdePCt
         9hHj3JCgBzdDeN0HupWKodVCOhnsL0xSqQGuErx3JB2/Zz9WKvL9VtfGGTDA0k1yPRXo
         7DqWTCsnf9ObCvMSCAr4Y2Vn80cQyAPqO2TzYpKiilgOZisRjY5grkDhW0bMK2Yc4VM5
         XvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QlTz9xj6lp+eZnKQtXhoB95xBxoI3W/Ee89KukGEB7w=;
        b=FTY9uIhQfSGe+0WbY7Dh8I8vhIIhSrvEBg1oJkHCwmQXcNgtfDd2s9MtDN9eC8Y2Q6
         aG+N4AkSZz+qUWJ58+JAllf4xwDqxS5ByAN1yATNU/r8CUnu7nFBU03TjGxBcQjVlOCQ
         UdwF4aDmk7Z1fN9z76fEdU+GdbF+eZp4fS2gUYf96bSiKpUQFszSgkYjBmgiXD4CVsHC
         0TWTtEL+O+jXb/N/qyxFKQgqbXgvzVf9wd/Oow6NW+N+wY8XkZM60ql6qHMlMOPZ6HJr
         +4msLM07NK0LkgmNk4h2UJAS92tNDRHlLwFruKhCBDFMVIgOKW0dh4wjm1Iq1CBDiq81
         rAeQ==
X-Gm-Message-State: AOAM533qXmr+A2abk1EMdfgopZohY5+9jSzl7l1tm+4EQO7asFqe8Naj
        liw4AF7/gP4RY+c7x6LKxzF4Aw/SYOT6V20pVJg=
X-Google-Smtp-Source: ABdhPJywmJY1jSMDaESFPI4BIKtrVXlRH+9R5JCFoDV08yQ+ViKrwr5iFpVq0zHZXcAyZ2DE0TLU7fmZihY1I6dpwrE=
X-Received: by 2002:a17:906:90b:: with SMTP id i11mr10126700ejd.168.1620395839981;
 Fri, 07 May 2021 06:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-19-smalin@marvell.com>
 <049e436b-d166-ebdd-5442-f616e7007d0e@suse.de>
In-Reply-To: <049e436b-d166-ebdd-5442-f616e7007d0e@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Fri, 7 May 2021 16:57:08 +0300
Message-ID: <CAKKgK4w5zWmrjkTOPgp8QhyXdQpNMrWiRT1DwshiED-hKvJ8wA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 18/27] qedn: Add qedn_claim_dev API support
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Nikolay Assa <nassa@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 2:29 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Nikolay Assa <nassa@marvell.com>
> >
> > This patch introduces the qedn_claim_dev() network service which the
> > offload device (qedn) is using through the paired net-device (qede).
> > qedn_claim_dev() returns true if the IP addr(IPv4 or IPv6) of the targe=
t
> > server is reachable via the net-device which is paired with the
> > offloaded device.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Nikolay Assa <nassa@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   drivers/nvme/hw/qedn/qedn.h      |  4 +++
> >   drivers/nvme/hw/qedn/qedn_main.c | 42 ++++++++++++++++++++++++++++++-=
-
> >   2 files changed, 44 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> > index c1ac17eabcb7..7efe2366eb7c 100644
> > --- a/drivers/nvme/hw/qedn/qedn.h
> > +++ b/drivers/nvme/hw/qedn/qedn.h
> > @@ -8,6 +8,10 @@
> >
> >   #include <linux/qed/qed_if.h>
> >   #include <linux/qed/qed_nvmetcp_if.h>
> > +#include <linux/qed/qed_nvmetcp_ip_services_if.h>
> > +#include <linux/qed/qed_chain.h>
> > +#include <linux/qed/storage_common.h>
> > +#include <linux/qed/nvmetcp_common.h>
> >
> >   /* Driver includes */
> >   #include "../../host/tcp-offload.h"
> > diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qe=
dn_main.c
> > index e3e8e3676b79..52007d35622d 100644
> > --- a/drivers/nvme/hw/qedn/qedn_main.c
> > +++ b/drivers/nvme/hw/qedn/qedn_main.c
> > @@ -27,9 +27,47 @@ static int
> >   qedn_claim_dev(struct nvme_tcp_ofld_dev *dev,
> >              struct nvme_tcp_ofld_ctrl_con_params *conn_params)
> >   {
> > -     /* Placeholder - qedn_claim_dev */
> > +     struct pci_dev *qede_pdev =3D NULL;
> > +     struct net_device *ndev =3D NULL;
> > +     u16 vlan_id =3D 0;
> > +     int rc =3D 0;
> >
> > -     return 0;
> > +     /* qedn utilizes host network stack through paired qede device fo=
r
> > +      * non-offload traffic. First we verify there is valid route to r=
emote
> > +      * peer.
> > +      */
> > +     if (conn_params->remote_ip_addr.ss_family =3D=3D AF_INET) {
> > +             rc =3D qed_route_ipv4(&conn_params->local_ip_addr,
> > +                                 &conn_params->remote_ip_addr,
> > +                                 &conn_params->remote_mac_addr,
> > +                                 &ndev);
> > +     } else if (conn_params->remote_ip_addr.ss_family =3D=3D AF_INET6)=
 {
> > +             rc =3D qed_route_ipv6(&conn_params->local_ip_addr,
> > +                                 &conn_params->remote_ip_addr,
> > +                                 &conn_params->remote_mac_addr,
> > +                                 &ndev);
> > +     } else {
> > +             pr_err("address family %d not supported\n",
> > +                    conn_params->remote_ip_addr.ss_family);
> > +
> > +             return false;
> > +     }
> > +
> > +     if (rc)
> > +             return false;
> > +
> > +     qed_vlan_get_ndev(&ndev, &vlan_id);
> > +     conn_params->vlan_id =3D vlan_id;
> > +
> > +     /* route found through ndev - validate this is qede*/
> > +     qede_pdev =3D qed_validate_ndev(ndev);
> > +     if (!qede_pdev)
> > +             return false;
> > +
> > +     dev->qede_pdev =3D qede_pdev;
> > +     dev->ndev =3D ndev;
> > +
> > +     return true;
> >   }
> >
> >   static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int q=
id,
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
