Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883A047C8C4
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 22:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhLUVZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 16:25:36 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:46268 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236445AbhLUVZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 16:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=JHeSu5B22K89b1uN+6C/y1+Gc1Ewng2Ne1GLKiG5hJQ=;
        b=Z50HddbN7Z/f/ln9vKHZp6CTWY0iWLqGHWzu/2r3ZTnZ0tP3yo/UuOoy0+DmooxppUlv
        FpiF7wVHWOCGInsa0cPMupBPO+vI/FcZlKo/qDoiV4WEOFpJAxcA06C28T0drF+VNULZYA
        xJaGpZz9cqRjy3LmYrUlVnKuHVDQUv1Y3vKu3Z6Jnrq1VS3QwNj5FTRe5Z7HiH3tSdqfum
        PnQX7wk6g/9aujdCiOOlEiiJIu+O1PS7a5xK7mIZsSqaERmEGkZ7bN396FDakoulUjWb8r
        INi5ZwrOknEHWOgKf7hTFYcMDR04IzK7glJKAUMQ3b5VpodP0da9hnnsMs69U2RA==
Received: by filterdrecv-75ff7b5ffb-96rhp with SMTP id filterdrecv-75ff7b5ffb-96rhp-1-61C2464E-39
        2021-12-21 21:25:34.636667651 +0000 UTC m=+9587114.517174376
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-0 (SG)
        with ESMTP
        id NbOfuhV3SlqtHpibrZR1UA
        Tue, 21 Dec 2021 21:25:34.460 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id B6466700264; Tue, 21 Dec 2021 14:25:33 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v7 0/2] wilc1000: Add reset/enable GPIO support to SPI driver
Date:   Tue, 21 Dec 2021 21:25:34 +0000 (UTC)
Message-Id: <20211221212531.4011609-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvPckgytttEHbTWkZU?=
 =?us-ascii?Q?zzUaFH1kLvflQDrAYob2c03sztJSr2Z+wyu3Pv2?=
 =?us-ascii?Q?No9OaSTU1pAoX0MBLY8TXKkx+uOZczyIAk414Ed?=
 =?us-ascii?Q?pW+WJJuY9wP+THSC3nJsj8M0A9qg1aWl8Ue6SG0?=
 =?us-ascii?Q?xOVdafl8S9=2FDDld5ECnj=2Fn06GqfmX2HoFMdkIWr?=
 =?us-ascii?Q?w+Dh6ztyTZW7YoT7=2FTHFw=3D=3D?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v7:
	- Rebase to latest wireless-drivers-next.
v6:
	- Convert line comments to block comments.
v5:
	- Fix a dt_binding_check error by including
	  <dt-bindings/gpio/gpio.h> in microchip,wilc1000.yaml.
v4:
	- Simplify wilc_wlan_power() by letting gpiod_set_value()
	  handle NULL gpios.
v3:
	- Fix to include correct header file.
	- Rename wilc_set_enable() to wilc_wlan_power().
	- Use devm_gpiod_get{,_optional}() instead of of_get_named_gpio()
	- Parse GPIO pins once at probe time.
v2:
	- Split documentation update and driver changes into seprate
          patches.

David Mosberger-Tang (2):
  wilc1000: Add reset/enable GPIO support to SPI driver
  wilc1000: Document enable-gpios and reset-gpios properties

 .../net/wireless/microchip,wilc1000.yaml      | 19 ++++++
 drivers/net/wireless/microchip/wilc1000/spi.c | 62 ++++++++++++++++++-
 .../net/wireless/microchip/wilc1000/wlan.c    |  2 +-
 3 files changed, 79 insertions(+), 4 deletions(-)

-- 
2.25.1

