Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659AF46E19A
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhLIEsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:48:00 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:10728 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhLIEr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:47:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=3SNyaj/S+j2jtmtvU1JCQM0pcswhvOSfY0hr1h1ehF4=;
        b=OBbUfpRZB6gzmvAKIK3GQqPtaK0qeNiCPrNvHjkyU1z68RbBNqWr3KPa7jFR4eb0wohs
        OrDoWBFaO7x0DrSGWdoe5fdgI+CTd44iDSBdkxIWJfLPvyMhxmuUUIRbsbthi0xDlBtYTY
        YrQUsBFMm9MnmQoa/8u57dE+21FPSvn9Zbzlg2NDG897dgS/ft2ayRbTx95rYzZGkAO2mt
        VANaSO+S6r5KuJLhEgEatBVVhKvQRooFZ029JEGbvCPEWaweVNwTIFnBWvD3WnSyoGZSRK
        CZyyG7MxH3L7UJKTNhzoGVo6oUPNJ44H6/Ef3y7a96DHbwQH4Ip68s+7cBO3KuYQ==
Received: by filterdrecv-55446c4d49-vth2g with SMTP id filterdrecv-55446c4d49-vth2g-1-61B189AA-3
        2021-12-09 04:44:26.246679973 +0000 UTC m=+8490258.086003700
Received: from pearl.egauge.net (unknown)
        by ismtpd0064p1las1.sendgrid.net (SG) with ESMTP
        id UWVFC7EtQMG-6xVxuz2dcg
        Thu, 09 Dec 2021 04:44:25.875 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id EB5F37002CB; Wed,  8 Dec 2021 21:44:24 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 0/4] wilc1000: use Linux-style for system-visible names
Date:   Thu, 09 Dec 2021 04:44:26 +0000 (UTC)
Message-Id: <20211209044411.3482259-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvIaUwyOv4FO04=2FhkM?=
 =?us-ascii?Q?I1krVVSB3NWyl6m2bMAhbShR=2FDjiXRAzkgdO7HH?=
 =?us-ascii?Q?e75fyLtTOX46loQoBf6i3IFNXx1x1614k4OF64u?=
 =?us-ascii?Q?4=2FeGhWxoMT65yi=2F2sLAt2kqM+ycqwtkmb6yuZKk?=
 =?us-ascii?Q?0ECi4eMnCumuCKfJ5qGoeLJOPX+UyF88bn4q8X?=
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

This set of patches brings system-visible names in line with normal
Linux conventions: lower-case names that include the net-device name
where that makes sense.  The first three patches are trivial.  The
fourth one required rearranging some code to delay work-queue creation
until the net-device name is known.

David Mosberger-Tang (4):
  wilc1000: Rename SPI driver from "WILC_SPI" to "wilc1000_spi"
  wilc1000: Rename irq handler from "WILC_IRQ" to netdev name
  wilc1000: Rename tx task from "K_TXQ_TASK" to NETDEV-tx
  wilc1000: Rename workqueue from "WILC_wq" to "NETDEV-wq"

 .../wireless/microchip/wilc1000/cfg80211.c    | 10 +---------
 .../net/wireless/microchip/wilc1000/netdev.c  | 19 +++++++++++++++----
 drivers/net/wireless/microchip/wilc1000/spi.c |  4 +++-
 .../net/wireless/microchip/wilc1000/wlan.h    |  2 --
 4 files changed, 19 insertions(+), 16 deletions(-)

-- 
2.25.1

