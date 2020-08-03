Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B282023AFE3
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 23:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgHCV6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 17:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgHCV6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 17:58:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84D6C06174A;
        Mon,  3 Aug 2020 14:58:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DAFDC1276E706;
        Mon,  3 Aug 2020 14:42:02 -0700 (PDT)
Date:   Mon, 03 Aug 2020 14:58:43 -0700 (PDT)
Message-Id: <20200803.145843.2285407129021498421.davem@davemloft.net>
To:     hongbo.wang@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org, kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Subject: Re: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ Operation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730102505.27039-3-hongbo.wang@nxp.com>
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
        <20200730102505.27039-3-hongbo.wang@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 14:42:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hongbo.wang@nxp.com
Date: Thu, 30 Jul 2020 18:25:05 +0800

> +	if (vlan->proto == ETH_P_8021AD) {
> +		ocelot->enable_qinq = true;
> +		ocelot_port->qinq_mode = true;
> +	}
 ...
> +	if (vlan->proto == ETH_P_8021AD) {
> +		ocelot->enable_qinq = false;
> +		ocelot_port->qinq_mode = false;
> +	}
> +

I don't understand how this can work just by using a boolean to track
the state.

This won't work properly if you are handling multiple QinQ VLAN entries.

Also, I need Andrew and Florian to review and ACK the DSA layer changes
that add the protocol value to the device notifier block.
