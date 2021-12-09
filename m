Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AB846E1A3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhLIEsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:48:06 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:11274 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhLIEsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=YaTQ2gxJhl0t16vCN/mieGkdFAy59VhLYl6Y22oNjxs=;
        b=QaBBm9exwNLuNKpyoT23WthmbAgSEhRABvzM0ArfeBDYwQcMVh/sYu3dMtD44uLY+YUt
        ou3m9tiMJvW92VwywF3vG+hH21+7IrkNVf9mwuWF4IWVdX3eb1Sx+JH42YudQ1DBucFnWo
        3DVQaGs2cM7bDibKs7AerMwg7LRlB+50kP9jS9suunAmgw3Y1fk9c9ufJhu3cwwGQwaaA0
        lbc7HMgfFm/o0+fuXUOH4iEoXQgz35yp5g7AmU1vgXCfri3G3FWMLP/JhdkfNufgJgjZNy
        PkF1qQFPntz9cumI5l8oYxQpIui+aCgLeBzW0PycIyjApMWr72y5NTRCF7GkKArg==
Received: by filterdrecv-75ff7b5ffb-96rhp with SMTP id filterdrecv-75ff7b5ffb-96rhp-1-61B189AB-19
        2021-12-09 04:44:27.857624053 +0000 UTC m=+8490247.738130723
Received: from pearl.egauge.net (unknown)
        by ismtpd0047p1las1.sendgrid.net (SG) with ESMTP
        id xn7barkGR2qV9cf5_7G2Wg
        Thu, 09 Dec 2021 04:44:27.778 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 49BEB7002CB; Wed,  8 Dec 2021 21:44:27 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 2/4] wilc1000: Rename irq handler from "WILC_IRQ" to netdev
 name
Date:   Thu, 09 Dec 2021 04:44:28 +0000 (UTC)
Message-Id: <20211209044411.3482259-3-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209044411.3482259-1-davidm@egauge.net>
References: <20211209044411.3482259-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvFe3c01PoG04mJYIZ?=
 =?us-ascii?Q?gQwDCewcoG18r=2Ff11AGGAmZHMWMyzfrUGZq0kyC?=
 =?us-ascii?Q?MKkZ7Oshm9MG8hcWR3ioKnwDggTrV5d0FYSBG73?=
 =?us-ascii?Q?3PuEplO16cx6demwN48yhT3Pczvak3OmWG09tLp?=
 =?us-ascii?Q?n3YWyLsKa66oucQs6XBzBL5sCq+TI+YTpJcevF?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change follows normal Linux convention and the new name is more
useful since it'll be clear which irq handler statistics correspond to
which net device.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 690572e01a2a..fae6b364ce5c 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -56,7 +56,7 @@ static int init_irq(struct net_device *dev)
 	ret = request_threaded_irq(wl->dev_irq_num, isr_uh_routine,
 				   isr_bh_routine,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				   "WILC_IRQ", wl);
+				   dev->name, wl);
 	if (ret) {
 		netdev_err(dev, "Failed to request IRQ [%d]\n", ret);
 		return ret;
-- 
2.25.1

