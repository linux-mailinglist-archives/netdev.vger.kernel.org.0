Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB2D110196
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 16:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLCPxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 10:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfLCPxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 10:53:21 -0500
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A6D2073F;
        Tue,  3 Dec 2019 15:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575388400;
        bh=cKUlQJxyEbNNE534SxNpTQSfjp4RJhfRU1TUcm+QH08=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Nm1H73YFEpWiEJ7OcGsNEJd3BOuiFHQOpmau/UXVgeM0A3bJ4zEmI/hHgl2R62C1y
         Ms62vpk7yOnX3u1BuWQss6CwRWnVQXsDzid8yYPpfAB1VJO4Tgm8AGk7nzJRGSJKld
         i6dHTj8CNyyW9bPfXgUO/tMXqTZtxcPv3D8aWTdQ=
Received: by mail-qv1-f52.google.com with SMTP id t9so1680702qvh.13;
        Tue, 03 Dec 2019 07:53:19 -0800 (PST)
X-Gm-Message-State: APjAAAVJ49WG1m4rnxIDzV6bZNgvIYDKKpBsv2NUCEBJIK1euNEkDUZm
        7u/8oY6z25IWCMPjFJ4zKb1FAEq1P/tWCDr4HA==
X-Google-Smtp-Source: APXvYqyICjW3HYnUPFqTgR4rEp2A1uuQE3BOephqhDMI2H3gFhNk2aTw/xPKbNHQEIKUpgOnuSfcOdrza+JvE1yn/H8=
X-Received: by 2002:ad4:450a:: with SMTP id k10mr5459306qvu.136.1575388397912;
 Tue, 03 Dec 2019 07:53:17 -0800 (PST)
MIME-Version: 1.0
References: <20191203114743.1294-1-nsaenzjulienne@suse.de> <20191203114743.1294-9-nsaenzjulienne@suse.de>
In-Reply-To: <20191203114743.1294-9-nsaenzjulienne@suse.de>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 3 Dec 2019 09:53:05 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLMCXdnZag3jihV_dzuR+wFaVKFb7q_PdKTxTg0LVA6cw@mail.gmail.com>
Message-ID: <CAL_JsqLMCXdnZag3jihV_dzuR+wFaVKFb7q_PdKTxTg0LVA6cw@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] linux/log2.h: Use roundup/dow_pow_two() on 64bit calculations
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     Andrew Murray <andrew.murray@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "maintainer:BROADCOM BCM7XXX ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        james.quinlan@broadcom.com, Matthias Brugger <mbrugger@suse.com>,
        Phil Elwell <phil@raspberrypi.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        PCI <linux-pci@vger.kernel.org>,
        "moderated list:BROADCOM BCM2835 ARM ARCHITECTURE" 
        <linux-rpi-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-acpi@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        devicetree@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 3, 2019 at 5:48 AM Nicolas Saenz Julienne
<nsaenzjulienne@suse.de> wrote:
>
> The function now is safe to use while expecting a 64bit value. Use it
> where relevant.

What was wrong with the existing code? This is missing some context.

> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> ---
>  drivers/acpi/arm64/iort.c                        | 2 +-
>  drivers/net/ethernet/mellanox/mlx4/en_clock.c    | 3 ++-
>  drivers/of/device.c                              | 3 ++-

In any case,

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/pci/controller/cadence/pcie-cadence-ep.c | 3 ++-
>  drivers/pci/controller/cadence/pcie-cadence.c    | 3 ++-
>  drivers/pci/controller/pcie-brcmstb.c            | 3 ++-
>  drivers/pci/controller/pcie-rockchip-ep.c        | 5 +++--
>  kernel/dma/direct.c                              | 2 +-
>  8 files changed, 15 insertions(+), 9 deletions(-)
