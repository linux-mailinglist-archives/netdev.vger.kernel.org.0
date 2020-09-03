Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB04225C525
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgICPXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgICPXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 11:23:05 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7903CC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 08:23:04 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id x203so1926280vsc.11
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 08:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Joe7bJxFvjhQ7PFpcfdBrDyWM8om/PRVTMRPGum9AiA=;
        b=rEqNHiOw8u46b6Z6/wsQzrmXcn6qbwSQp6vFILV8eNXL4YI9HvX2LIdfq+9eYrPyMU
         MZ8MZGKO/8MwIkMSX5QePW1p/3cpjdE6ToP6ar4lpWqtFL/VIxOhFHSpLzbqDreaGUjv
         UuPq5Tr37QGU8YozIZVPxnAjbqr0fCPKh5klkqsd3G6Lyx3d1TWO3gCMf2CK2UOt4FCu
         YtnPZZXxp8YVqB6bBDuwXkio1RDCKyuZ1o7omSRnc7gtoCaUfawN49aEN+kCGRLudwVT
         W0f4ljMLH0rlCEZn9TEGabz6/iTlKPHCljVvToCtll8LCmpHH/PJpEIFKA6fnVpwgKAD
         uOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Joe7bJxFvjhQ7PFpcfdBrDyWM8om/PRVTMRPGum9AiA=;
        b=j1PtNb1lpjfTNFppqmTELsfcnwXmQYPrqZ9v+RlB6Ks5Ky6oRkQYxojcZfSLgVM02j
         u7d9Re76I0COYFk8+OMvZ8E/TMpeNiztMh3oeU4J7hjlMN3U9RvxUpVbxTnoHU0dRwtp
         uj4DJY1Fiqa5llLkfXUpXiDrYX8A008dljCRtaWTL/huW/M5EGEgc8KTBLIsw8Fe8270
         bS3c2Qao6oDtkB79FkWIJHfWyl6qYakJuzRn8ylXwgyTl8ao+1Regs983/ZVnGOgMF2z
         Ea3y5VXBFGoxtxyr5ifOdzqMCLmqOkfM4Ns7BB4Xi5+XIEjbit0WzKPCQhU17ITHky/W
         +8QA==
X-Gm-Message-State: AOAM531zk1KaBp3q7Fx4u+gQdpRzKpLD6cpP7RCJfbrwdjjV3zozEc2h
        3fRP6SPPJX9MBP/HFUCIJayvCHG/crJTTw==
X-Google-Smtp-Source: ABdhPJxQAxuOPxSa3+Vl8zcN72I0n8vMYBFXTC9ES7+DJpGOgwox6ETnQyN7acFUlxvg4fjQIHkNBA==
X-Received: by 2002:a67:1687:: with SMTP id 129mr2303642vsw.111.1599146583140;
        Thu, 03 Sep 2020 08:23:03 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id x124sm525363vka.34.2020.09.03.08.23.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 08:23:02 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id q13so1916786vsj.13
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 08:23:01 -0700 (PDT)
X-Received: by 2002:a05:6102:150:: with SMTP id a16mr2136712vsr.99.1599146581291;
 Thu, 03 Sep 2020 08:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200902150442.2779-1-vadym.kochan@plvision.eu> <20200902150442.2779-2-vadym.kochan@plvision.eu>
In-Reply-To: <20200902150442.2779-2-vadym.kochan@plvision.eu>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 3 Sep 2020 17:22:24 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfMRhEZ5c2CWaN_F3ASDgvV7eQ4q6zVuY-FvgLqsqYecw@mail.gmail.com>
Message-ID: <CA+FuTSfMRhEZ5c2CWaN_F3ASDgvV7eQ4q6zVuY-FvgLqsqYecw@mail.gmail.com>
Subject: Re: [PATCH net v6 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 2, 2020 at 5:37 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
>
> Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> wireless SMB deployment.
>
> The current implementation supports only boards designed for the Marvell
> Switchdev solution and requires special firmware.
>
> The core Prestera switching logic is implemented in prestera_main.c,
> there is an intermediate hw layer between core logic and firmware. It is
> implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> related logic, in future there is a plan to support more devices with
> different HW related configurations.
>
> This patch contains only basic switch initialization and RX/TX support
> over SDMA mechanism.
>
> Currently supported devices have DMA access range <= 32bit and require
> ZONE_DMA to be enabled, for such cases SDMA driver checks if the skb
> allocated in proper range supported by the Prestera device.
>
> Also meanwhile there is no TX interrupt support in current firmware
> version so recycling work is scheduled on each xmit.
>
> Port's mac address is generated from the switch base mac which may be
> provided via device-tree (static one or as nvme cell), or randomly
> generated.
>
> Co-developed-by: Andrii Savka <andrii.savka@plvision.eu>
> Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Co-developed-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Co-developed-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>

> +int prestera_hw_port_cap_get(const struct prestera_port *port,
> +                            struct prestera_port_caps *caps)
> +{
> +       struct prestera_msg_port_attr_resp resp;
> +       struct prestera_msg_port_attr_req req = {
> +               .attr = PRESTERA_CMD_PORT_ATTR_CAPABILITY,
> +               .port = port->hw_id,
> +               .dev = port->dev_id
> +       };
> +       int err;
> +
> +       err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
> +                              &req.cmd, sizeof(req), &resp.ret, sizeof(resp));

Here and elsewhere, why use a pointer to the first field in the struct
vs the struct itself?

They are the same address, so it's fine, just a bit confusing as the
size argument makes clear that the entire struct is to be copied.

> +static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
> +{
> +       if (!is_valid_ether_addr(addr))
> +               return -EADDRNOTAVAIL;
> +
> +       if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))

Why ETH_ALEN - 1?

> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
> +static int prestera_port_set_mac_address(struct net_device *dev, void *p)
> +{
> +       struct prestera_port *port = netdev_priv(dev);
> +       struct sockaddr *addr = p;
> +       int err;
> +
> +       err = prestera_is_valid_mac_addr(port, addr->sa_data);
> +       if (err)
> +               return err;
> +
> +       err = prestera_hw_port_mac_set(port, addr->sa_data);
> +       if (err)
> +               return err;
> +
> +       memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);

Is addr_len ever not ETH_ALEN for this device?

> +static int prestera_sdma_buf_init(struct prestera_sdma *sdma,
> +                                 struct prestera_sdma_buf *buf)
> +{
> +       struct device *dma_dev = sdma->sw->dev->dev;
> +       struct prestera_sdma_desc *desc;
> +       dma_addr_t dma;
> +
> +       desc = dma_pool_alloc(sdma->desc_pool, GFP_DMA | GFP_KERNEL, &dma);
> +       if (!desc)
> +               return -ENOMEM;
> +
> +       if (dma + sizeof(struct prestera_sdma_desc) > sdma->dma_mask) {

Can this happen? The DMA API should take care of dev->dma_mask constraints.

> +               dma_pool_free(sdma->desc_pool, desc, dma);
> +               dev_err(dma_dev, "failed to alloc desc\n");
> +               return -ENOMEM;
> +       }

> +static int prestera_sdma_rx_skb_alloc(struct prestera_sdma *sdma,
> +                                     struct prestera_sdma_buf *buf)
> +{
> +       struct device *dev = sdma->sw->dev->dev;
> +       struct sk_buff *skb;
> +       dma_addr_t dma;
> +
> +       skb = alloc_skb(PRESTERA_SDMA_BUFF_SIZE_MAX, GFP_DMA | GFP_ATOMIC);
> +       if (!skb)
> +               return -ENOMEM;
> +
> +       dma = dma_map_single(dev, skb->data, skb->len, DMA_FROM_DEVICE);
> +       if (dma_mapping_error(dev, dma))
> +               goto err_dma_map;
> +       if (dma + skb->len > sdma->dma_mask)
> +               goto err_dma_range;

Same here
