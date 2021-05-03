Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A051337183B
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 17:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhECPpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 11:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhECPpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 11:45:23 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9C1C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 08:44:28 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i24so6794845edy.8
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 08:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dOMhIDQcj6FbPcrDgTY+DqGjm9zmhAQ5MfYxilunNmQ=;
        b=sSRUP/1hhlH2g/zHKqxj/36ugp9QXIdmj3kzHFO9ShrVx/h2y+5Lb/hBbVyXYE/wJz
         ulIklWHyN8Dc6L9HoLraR4N1pQtdGvy2TCFbezrwB5s48r6O9wwlegKpS3HAG1MXxcKm
         Y/i+jjLFdLzt/qlltytBwKurhFNz3eV6XjKEzqJCuesfUl1EN8ikGKHFaQM3CXSeN25U
         2ho995Ko9DCypdiuNIWW8+dhrBX/YkzOHYfCdH8TCO2JcRPLIcmzPWsgPf9dP2dCpgRU
         TzqCCLOBKEEg6XXIYh8nGJat3HI/gC+ZhE3GUUpfDMTu7BcTHq1Ah7/w9/2TsGN2NEb3
         0VpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dOMhIDQcj6FbPcrDgTY+DqGjm9zmhAQ5MfYxilunNmQ=;
        b=GQwHKo+uflO/LKkeQVXghnlQkM38hvgl1dgwq3ewl+NF4NosTz0+aRUJ/Wnt+VndOP
         BYurOrWb/nmSq3zScCcyqsxRzsRAbfUpboTXsZH9EVCepOYf/dBwuOuB5hl6h/4s5zB+
         C/th7SrMgFZ1F2ueEHF3k+trc0derTFaf5P3L0mkhSLKQinqkWt8/EkyuqWX+Evpg4GI
         nLGX3cgHbm3RLogu7I4uiIo77LzeLUXIXB2d1UmOIyrBz3PXLAa9J8H6WqQGox3FH+Lm
         6eX+jL9oeRQj1PR4ju3Vva10erMD+h0X4/hWW8T09ESXRU9jIKzaF3qSE8KVuvOotM8R
         JgBA==
X-Gm-Message-State: AOAM532DAMPSxyuIPikBTZUiVUpZVnJ7BRohLfcvlcR3fzlDUmfSgJvn
        MarW/bKnbgkcMm60O884vDbgIjsPUeWk9WLP9YM=
X-Google-Smtp-Source: ABdhPJxXs1WGxfy3MynteKLLKryZ4Dkabn/JEfLYdYpiJN0QWceNiV+U9bGKqUG5xVq+WHpL4Xf+/0VtGQXC+YUfNEU=
X-Received: by 2002:a05:6402:1a2f:: with SMTP id be15mr20567642edb.207.1620056667619;
 Mon, 03 May 2021 08:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210429190926.5086-1-smalin@marvell.com> <20210429190926.5086-8-smalin@marvell.com>
 <8b17f15c-4776-1744-8183-fb783b7a4c97@suse.de>
In-Reply-To: <8b17f15c-4776-1744-8183-fb783b7a4c97@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 3 May 2021 18:44:16 +0300
Message-ID: <CAKKgK4wfCQO1p4da1mwfzhQuCHxWD6kVpoC=Ea1z6O+Dtcq=Ag@mail.gmail.com>
Subject: Re: [RFC PATCH v4 07/27] qed: Add IP services APIs support
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

On 5/2/21 2:26 PM, Hannes Reinecke wrote:
> On 4/29/21 9:09 PM, Shai Malin wrote:
> > From: Nikolay Assa <nassa@marvell.com>
> >
> > This patch introduces APIs which the NVMeTCP Offload device (qedn)
> > will use through the paired net-device (qede).
> > It includes APIs for:
> > - ipv4/ipv6 routing
> > - get VLAN from net-device
> > - TCP ports reservation
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Nikolay Assa <nassa@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >   .../qlogic/qed/qed_nvmetcp_ip_services.c      | 239 +++++++++++++++++=
+
> >   .../linux/qed/qed_nvmetcp_ip_services_if.h    |  29 +++
> >   2 files changed, 268 insertions(+)
> >   create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_ser=
vices.c
> >   create mode 100644 include/linux/qed/qed_nvmetcp_ip_services_if.h
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c =
b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
> > new file mode 100644
> > index 000000000000..2904b1a0830a
> > --- /dev/null
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
> > @@ -0,0 +1,239 @@
> > +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
> > +/*
> > + * Copyright 2021 Marvell. All rights reserved.
> > + */
> > +
> > +#include <linux/types.h>
> > +#include <asm/byteorder.h>
> > +#include <asm/param.h>
> > +#include <linux/delay.h>
> > +#include <linux/pci.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/etherdevice.h>
> > +#include <linux/kernel.h>
> > +#include <linux/stddef.h>
> > +#include <linux/errno.h>
> > +
> > +#include <net/tcp.h>
> > +
> > +#include <linux/qed/qed_nvmetcp_ip_services_if.h>
> > +
> > +#define QED_IP_RESOL_TIMEOUT  4
> > +
> > +int qed_route_ipv4(struct sockaddr_storage *local_addr,
> > +                struct sockaddr_storage *remote_addr,
> > +                struct sockaddr *hardware_address,
> > +                struct net_device **ndev)
> > +{
> > +     struct neighbour *neigh =3D NULL;
> > +     __be32 *loc_ip, *rem_ip;
> > +     struct rtable *rt;
> > +     int rc =3D -ENXIO;
> > +     int retry;
> > +
> > +     loc_ip =3D &((struct sockaddr_in *)local_addr)->sin_addr.s_addr;
> > +     rem_ip =3D &((struct sockaddr_in *)remote_addr)->sin_addr.s_addr;
> > +     *ndev =3D NULL;
> > +     rt =3D ip_route_output(&init_net, *rem_ip, *loc_ip, 0/*tos*/, 0/*=
oif*/);
> > +     if (IS_ERR(rt)) {
> > +             pr_err("lookup route failed\n");
> > +             rc =3D PTR_ERR(rt);
> > +             goto return_err;
> > +     }
> > +
> > +     neigh =3D dst_neigh_lookup(&rt->dst, rem_ip);
> > +     if (!neigh) {
> > +             rc =3D -ENOMEM;
> > +             ip_rt_put(rt);
> > +             goto return_err;
> > +     }
> > +
> > +     *ndev =3D rt->dst.dev;
> > +     ip_rt_put(rt);
> > +
> > +     /* If not resolved, kick-off state machine towards resolution */
> > +     if (!(neigh->nud_state & NUD_VALID))
> > +             neigh_event_send(neigh, NULL);
> > +
> > +     /* query neighbor until resolved or timeout */
> > +     retry =3D QED_IP_RESOL_TIMEOUT;
> > +     while (!(neigh->nud_state & NUD_VALID) && retry > 0) {
> > +             msleep(1000);
> > +             retry--;
> > +     }
> > +
> > +     if (neigh->nud_state & NUD_VALID) {
> > +             /* copy resolved MAC address */
> > +             neigh_ha_snapshot(hardware_address->sa_data, neigh, *ndev=
);
> > +
> > +             hardware_address->sa_family =3D (*ndev)->type;
> > +             rc =3D 0;
> > +     }
> > +
> > +     neigh_release(neigh);
> > +     if (!(*loc_ip)) {
> > +             *loc_ip =3D inet_select_addr(*ndev, *rem_ip, RT_SCOPE_UNI=
VERSE);
> > +             local_addr->ss_family =3D AF_INET;
> > +     }
> > +
> > +return_err:
> > +
> > +     return rc;
> > +}
> > +EXPORT_SYMBOL(qed_route_ipv4);
> > +
> > +int qed_route_ipv6(struct sockaddr_storage *local_addr,
> > +                struct sockaddr_storage *remote_addr,
> > +                struct sockaddr *hardware_address,
> > +                struct net_device **ndev)
> > +{
> > +     struct neighbour *neigh =3D NULL;
> > +     struct dst_entry *dst;
> > +     struct flowi6 fl6;
> > +     int rc =3D -ENXIO;
> > +     int retry;
> > +
> > +     memset(&fl6, 0, sizeof(fl6));
> > +     fl6.saddr =3D ((struct sockaddr_in6 *)local_addr)->sin6_addr;
> > +     fl6.daddr =3D ((struct sockaddr_in6 *)remote_addr)->sin6_addr;
> > +
> > +     dst =3D ip6_route_output(&init_net, NULL, &fl6);
> > +     if (!dst || dst->error) {
> > +             if (dst) {
> > +                     dst_release(dst);
> > +                     pr_err("lookup route failed %d\n", dst->error);
> > +             }
> > +
> > +             goto out;
> > +     }
> > +
> > +     neigh =3D dst_neigh_lookup(dst, &fl6.daddr);
> > +     if (neigh) {
> > +             *ndev =3D ip6_dst_idev(dst)->dev;
> > +
> > +             /* If not resolved, kick-off state machine towards resolu=
tion */
> > +             if (!(neigh->nud_state & NUD_VALID))
> > +                     neigh_event_send(neigh, NULL);
> > +
> > +             /* query neighbor until resolved or timeout */
> > +             retry =3D QED_IP_RESOL_TIMEOUT;
> > +             while (!(neigh->nud_state & NUD_VALID) && retry > 0) {
> > +                     msleep(1000);
> > +                     retry--;
> > +             }
> > +
> > +             if (neigh->nud_state & NUD_VALID) {
> > +                     neigh_ha_snapshot((u8 *)hardware_address->sa_data=
, neigh, *ndev);
> > +
> > +                     hardware_address->sa_family =3D (*ndev)->type;
> > +                     rc =3D 0;
> > +             }
> > +
> > +             neigh_release(neigh);
> > +
> > +             if (ipv6_addr_any(&fl6.saddr)) {
> > +                     if (ipv6_dev_get_saddr(dev_net(*ndev), *ndev,
> > +                                            &fl6.daddr, 0, &fl6.saddr)=
) {
> > +                             pr_err("Unable to find source IP address\=
n");
> > +                             goto out;
> > +                     }
> > +
> > +                     local_addr->ss_family =3D AF_INET6;
> > +                     ((struct sockaddr_in6 *)local_addr)->sin6_addr =
=3D
> > +                                                             fl6.saddr=
;
> > +             }
> > +     }
> > +
> > +     dst_release(dst);
> > +
> > +out:
> > +
> > +     return rc;
> > +}
> > +EXPORT_SYMBOL(qed_route_ipv6);
> > +
> > +void qed_vlan_get_ndev(struct net_device **ndev, u16 *vlan_id)
> > +{
> > +     if (is_vlan_dev(*ndev)) {
> > +             *vlan_id =3D vlan_dev_vlan_id(*ndev);
> > +             *ndev =3D vlan_dev_real_dev(*ndev);
> > +     }
> > +}
> > +EXPORT_SYMBOL(qed_vlan_get_ndev);
> > +
> > +struct pci_dev *qed_validate_ndev(struct net_device *ndev)
> > +{
> > +     struct pci_dev *pdev =3D NULL;
> > +     struct net_device *upper;
> > +
> > +     for_each_pci_dev(pdev) {
> > +             if (pdev && pdev->driver &&
> > +                 !strcmp(pdev->driver->name, "qede")) {
> > +                     upper =3D pci_get_drvdata(pdev);
> > +                     if (upper->ifindex =3D=3D ndev->ifindex)
> > +                             return pdev;
> > +             }
> > +     }
> > +
> > +     return NULL;
> > +}
> > +EXPORT_SYMBOL(qed_validate_ndev);
> > +
> > +__be16 qed_get_in_port(struct sockaddr_storage *sa)
> > +{
> > +     return sa->ss_family =3D=3D AF_INET
> > +             ? ((struct sockaddr_in *)sa)->sin_port
> > +             : ((struct sockaddr_in6 *)sa)->sin6_port;
> > +}
> > +EXPORT_SYMBOL(qed_get_in_port);
> > +
> > +int qed_fetch_tcp_port(struct sockaddr_storage local_ip_addr,
> > +                    struct socket **sock, u16 *port)
> > +{
> > +     struct sockaddr_storage sa;
> > +     int rc =3D 0;
> > +
> > +     rc =3D sock_create(local_ip_addr.ss_family, SOCK_STREAM, IPPROTO_=
TCP, sock);
> > +     if (rc) {
> > +             pr_warn("failed to create socket: %d\n", rc);
> > +             goto err;
> > +     }
> > +
> > +     (*sock)->sk->sk_allocation =3D GFP_KERNEL;
> > +     sk_set_memalloc((*sock)->sk);
> > +
> > +     rc =3D kernel_bind(*sock, (struct sockaddr *)&local_ip_addr,
> > +                      sizeof(local_ip_addr));
> > +
> > +     if (rc) {
> > +             pr_warn("failed to bind socket: %d\n", rc);
> > +             goto err_sock;
> > +     }
> > +
> > +     rc =3D kernel_getsockname(*sock, (struct sockaddr *)&sa);
> > +     if (rc < 0) {
> > +             pr_warn("getsockname() failed: %d\n", rc);
> > +             goto err_sock;
> > +     }
> > +
> > +     *port =3D ntohs(qed_get_in_port(&sa));
> > +
> > +     return 0;
> > +
> > +err_sock:
> > +     sock_release(*sock);
> > +     sock =3D NULL;
> > +err:
> > +
> > +     return rc;
> > +}
> > +EXPORT_SYMBOL(qed_fetch_tcp_port);
> > +
> > +void qed_return_tcp_port(struct socket *sock)
> > +{
> > +     if (sock && sock->sk) {
> > +             tcp_set_state(sock->sk, TCP_CLOSE);
> > +             sock_release(sock);
> > +     }
> > +}
> > +EXPORT_SYMBOL(qed_return_tcp_port);
> > diff --git a/include/linux/qed/qed_nvmetcp_ip_services_if.h b/include/l=
inux/qed/qed_nvmetcp_ip_services_if.h
> > new file mode 100644
> > index 000000000000..3604aee53796
> > --- /dev/null
> > +++ b/include/linux/qed/qed_nvmetcp_ip_services_if.h
> > @@ -0,0 +1,29 @@
> > +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
> > +/*
> > + * Copyright 2021 Marvell. All rights reserved.
> > + */
> > +
> > +#ifndef _QED_IP_SERVICES_IF_H
> > +#define _QED_IP_SERVICES_IF_H
> > +
> > +#include <linux/types.h>
> > +#include <net/route.h>
> > +#include <net/ip6_route.h>
> > +#include <linux/inetdevice.h>
> > +
> > +int qed_route_ipv4(struct sockaddr_storage *local_addr,
> > +                struct sockaddr_storage *remote_addr,
> > +                struct sockaddr *hardware_address,
> > +                struct net_device **ndev);
> > +int qed_route_ipv6(struct sockaddr_storage *local_addr,
> > +                struct sockaddr_storage *remote_addr,
> > +                struct sockaddr *hardware_address,
> > +                struct net_device **ndev);
> > +void qed_vlan_get_ndev(struct net_device **ndev, u16 *vlan_id);
> > +struct pci_dev *qed_validate_ndev(struct net_device *ndev);
> > +void qed_return_tcp_port(struct socket *sock);
> > +int qed_fetch_tcp_port(struct sockaddr_storage local_ip_addr,
> > +                    struct socket **sock, u16 *port);
> > +__be16 qed_get_in_port(struct sockaddr_storage *sa);
> > +
> > +#endif /* _QED_IP_SERVICES_IF_H */
> >
> Reviewed-by: Hannes Reinecke <hare@suse.de>
>

Thanks.

> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
