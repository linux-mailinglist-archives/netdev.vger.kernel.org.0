Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4168D110510
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLCT2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:28:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51832 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfLCT2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:28:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EB1715103190;
        Tue,  3 Dec 2019 11:28:04 -0800 (PST)
Date:   Tue, 03 Dec 2019 11:28:03 -0800 (PST)
Message-Id: <20191203.112803.2177074793533497746.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        vladimir.oltean@nxp.com, antoine.tenart@bootlin.com
Subject: Re: [PATCH v3 net] net: mscc: ocelot: unregister the PTP clock on
 deinit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203154535.21183-1-olteanv@gmail.com>
References: <20191203154535.21183-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 11:28:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue,  3 Dec 2019 17:45:35 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently a switch driver deinit frees the regmaps, but the PTP clock is
> still out there, available to user space via /dev/ptpN. Any PTP
> operation is a ticking time bomb, since it will attempt to use the freed
> regmaps and thus trigger kernel panics:
 ...
> And now that ocelot->ptp_clock is checked at exit, prevent a potential
> error where ptp_clock_register returned a pointer-encoded error, which
> we are keeping in the ocelot private data structure. So now,
> ocelot->ptp_clock is now either NULL or a valid pointer.
> 
> Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied and queued up for v5.4 -stable, thanks.
