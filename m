Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60F03EB5F8
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240590AbhHMNKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 09:10:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239062AbhHMNKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 09:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1MSq2rQag7F3xmCmN6ikUcDNWFi9NhmjIJ0Jw9gtSAE=; b=5skMoLKWDaeRTcHfip7Lr85djs
        Co5nHQJapgTa55QkQn/CwkMV6sX0om90O1e+1C2XMiu4+KvoJ8Vhlo+ZZZP7Eqe5gyMkyaDW2Lo/G
        woknjEH98xX7BTwnDH7yiV/HunJiYJA927m0FiS+P21LnmmZR5ogwMJK9ipOLKamNzHM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mEWwc-00HUwL-8f; Fri, 13 Aug 2021 15:09:54 +0200
Date:   Fri, 13 Aug 2021 15:09:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     hongbo.wang@nxp.com
Cc:     hongjun.chen@nxp.com, po.liu@nxp.com, shawnguo@kernel.org,
        leoyang.li@nxp.com, vladimir.oltean@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file to choose
 swp5 as dsa master
Message-ID: <YRZvItRlSpF2Xf+S@lunn.ch>
References: <20210813030155.23097-1-hongbo.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813030155.23097-1-hongbo.wang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 11:01:55AM +0800, hongbo.wang@nxp.com wrote:
> From: hongbo wang <hongbo.wang@nxp.com>
> 
> some use cases want to use swp4-eno2 link as ordinary data path,
> so we can enable swp5 as dsa master, the data from kernel can
> be transmitted to eno3, then send to swp5 via internal link, switch will
> forward it to swp0-3.
> 
> the data to kernel will come from swp0-3, and received by kernel
> via swp5-eno3 link.
 
> new file mode 100644
> index 000000000000..a88396c137a1
> --- /dev/null
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb-dsa-swp5-eno3.dts
> @@ -0,0 +1,27 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> +/*
> + * Device Tree file for NXP LS1028A RDB with dsa master swp5-eno3.
> + *
> + * Copyright 2018-2021 NXP
> + *
> + * Hongbo Wang <hongbo.wang@nxp.com>
> + *
> + */
> +
> +/dts-v1/;
> +#include "fsl-ls1028a-rdb.dts"

You will end up with two DT blobs with the same top level
compatible. This is going to cause confusion. I suggest you add an
additional top level compatible to make it clear this differs from the
compatible = "fsl,ls1028a-rdb", "fsl,ls1028a" blob.

   Andrew

