Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9FD4838B9
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 23:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiACWMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 17:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiACWMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 17:12:14 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B6EC061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 14:12:13 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id u13so77488839lff.12
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 14:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=51SeiMN2YeEtJCnVth0rnX6YO72iTsj6U/EZKpHYfu0=;
        b=iJHVe9UttaC7K6EmEmHQiGyK+V2faqXo2qfHHvxHqx5hVhVyaZXyo+471STKwcT2Um
         Q/73wXOp5w1nlaHQ/cs27z7dxlPKTTQ910IMjzrFep85z+ytZ0f6YSpXJ8LbXVF4ypHf
         r0JCC4KqwKw/LcJzt/Da55/PdXdfaCSV1z5OY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=51SeiMN2YeEtJCnVth0rnX6YO72iTsj6U/EZKpHYfu0=;
        b=GxJMXVNNv9XLpkc8UaLUBvowHYzSDxGvb846CQWqg+Lm4va6uVRPxlh+u6NFsF9M5r
         DXmoZfWR24gDfuAHOcB5hAukb8h1yB2ONeeNWzSt5yjskpZqog1POqmPHB374mB9+AGB
         QvD+beKK4ItfoaTppE1JkzKT+1m6sMExtehNzSo6plJe9UhNSDeGYOqWK4BB8fLGP+RW
         QWnIsWEN2ueyP7h7Ni4ahN6/2IOMGShq8Xp7u7wyfgktqOUBi4wEvrzL9elp9M8jvj10
         /uyMltUU/DCEZGLN6XLeb39ZEBOyNYTb3qC5zw7QEoColTjhQQId+i0f5VfNTGkVbZ/Z
         SqVg==
X-Gm-Message-State: AOAM531BjGRqJtP1V4RGAVQgVInN+VHcqdfwvpyYuTOLM5dzqdCSUixk
        2nkbpE5OQgICWojOrHfOeBUE3UQlcLzjkfPKqZjyTA==
X-Google-Smtp-Source: ABdhPJwt/6lmqhX/C03kU7/fYnd6qfnkeAth8MCej0egZDiE/iG4Zrbm0LBlw/t1DAw9L7Gn7CmhybycHo5hAy3ztpc=
X-Received: by 2002:a05:6512:2292:: with SMTP id f18mr38669271lfu.51.1641247931479;
 Mon, 03 Jan 2022 14:12:11 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-4-dmichail@fungible.com> <9f552d88-0aa3-b46e-a85f-f661cc338ebc@gmail.com>
In-Reply-To: <9f552d88-0aa3-b46e-a85f-f661cc338ebc@gmail.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Mon, 3 Jan 2022 14:11:58 -0800
Message-ID: <CAOkoqZne1uH9k1O-S8-rfgqRQtk8XEdvBYZHC4VPyDRConaRJw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/8] net/funeth: probing and netdev ops
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 3:15 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 30.12.2021 17:39, Dimitris Michailidis wrote:
> > This is the first part of the Fungible ethernet driver. It deals with
> > device probing, net_device creation, and netdev ops.
> >
> > Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> > ---
> >  drivers/net/ethernet/fungible/funeth/funeth.h |  153 ++
> >  .../ethernet/fungible/funeth/funeth_main.c    | 1772 +++++++++++++++++
> >  2 files changed, 1925 insertions(+)
> >  create mode 100644 drivers/net/ethernet/fungible/funeth/funeth.h
> >  create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_main.c
> >
> > diff --git a/drivers/net/ethernet/fungible/funeth/funeth.h b/drivers/net/ethernet/fungible/funeth/funeth.h
> > new file mode 100644
> > index 000000000000..0c089f685c7f
> > --- /dev/null
> > +++ b/drivers/net/ethernet/fungible/funeth/funeth.h
> > @@ -0,0 +1,153 @@
> > +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
> > +
> > +#ifndef _FUNETH_H
> > +#define _FUNETH_H
> > +
> > +#include <uapi/linux/if_ether.h>
> > +#include <uapi/linux/net_tstamp.h>
> > +#include <linux/seqlock.h>
> > +#include <net/devlink.h>
> > +#include "fun_dev.h"
> > +
> > +#define ADMIN_SQE_SIZE SZ_128
> > +#define ADMIN_CQE_SIZE SZ_64
> > +#define ADMIN_RSP_MAX_LEN (ADMIN_CQE_SIZE - sizeof(struct fun_cqe_info))
> > +
> > +#define FUN_MAX_MTU 9024
> > +
> > +#define SQ_DEPTH 512U
> > +#define CQ_DEPTH 1024U
> > +#define RQ_DEPTH (512U / (PAGE_SIZE / 4096))
> > +
> > +#define CQ_INTCOAL_USEC 10
> > +#define CQ_INTCOAL_NPKT 16
> > +#define SQ_INTCOAL_USEC 10
> > +#define SQ_INTCOAL_NPKT 16
> > +
> > +#define INVALID_LPORT 0xffff
> > +
> > +#define FUN_PORT_CAP_PAUSE_MASK (FUN_PORT_CAP_TX_PAUSE | FUN_PORT_CAP_RX_PAUSE)
> > +
> > +struct fun_vport_info {
> > +     u8 mac[ETH_ALEN];
> > +     u16 vlan;
> > +     __be16 vlan_proto;
> > +     u8 qos;
> > +     u8 spoofchk:1;
> > +     u8 trusted:1;
> > +     unsigned int max_rate;
> > +};
> > +
> > +/* "subclass" of fun_dev for Ethernet functions */
> > +struct fun_ethdev {
> > +     struct fun_dev fdev;
> > +
> > +     /* the function's network ports */
> > +     struct net_device **netdevs;
> > +     unsigned int num_ports;
> > +
> > +     /* configuration for the function's virtual ports */
> > +     unsigned int num_vports;
> > +     struct fun_vport_info *vport_info;
> > +
> > +     unsigned int nsqs_per_port;
> > +};
> > +
> > +static inline struct fun_ethdev *to_fun_ethdev(struct fun_dev *p)
> > +{
> > +     return container_of(p, struct fun_ethdev, fdev);
> > +}
> > +
> > +/* Per netdevice driver state, i.e., netdev_priv. */
> > +struct funeth_priv {
> > +     struct fun_dev *fdev;
> > +     struct pci_dev *pdev;
> > +     struct net_device *netdev;
> > +
> > +     struct funeth_rxq * __rcu *rxqs;
> > +     struct funeth_txq **txqs;
> > +     struct funeth_txq **xdpqs;
> > +
> > +     struct fun_irq *irqs;
> > +     unsigned int num_irqs;
> > +     unsigned int num_tx_irqs;
> > +
> > +     unsigned int lane_attrs;
> > +     u16 lport;
> > +
> > +     /* link settings */
> > +     u64 port_caps;
> > +     u64 advertising;
> > +     u64 lp_advertising;
> > +     unsigned int link_speed;
>
> Any specific reason for handling this manually?
> Why not using phylib/phylink?

Linux here doesn't have access to the MAC/PHY. They are handled
by FW. The driver for the most part sits between FW and ethtool
converting commands and state between them and these fields store
either what FW has reported or what ethtool has requested.
