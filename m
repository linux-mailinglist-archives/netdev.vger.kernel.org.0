Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B4042D2D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409518AbfFLRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:12:48 -0400
Received: from vsmx011.vodafonemail.xion.oxcs.net ([153.92.174.89]:24360 "EHLO
        vsmx011.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405993AbfFLRMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:12:48 -0400
Received: from vsmx003.vodafonemail.xion.oxcs.net (unknown [192.168.75.197])
        by mta-5-out.mta.xion.oxcs.net (Postfix) with ESMTP id E06F93E0399;
        Wed, 12 Jun 2019 17:04:04 +0000 (UTC)
Received: from arcor.de (unknown [2.247.255.147])
        by mta-7-out.mta.xion.oxcs.net (Postfix) with ESMTPA id 60385300355;
        Wed, 12 Jun 2019 17:03:56 +0000 (UTC)
Date:   Wed, 12 Jun 2019 19:03:50 +0200
From:   Reinhard Speyerer <rspmn@arcor.de>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Daniele Palmas <dnlplm@gmail.com>, netdev@vger.kernel.org,
        rspmn@arcor.de
Subject: [PATCH 4/4] qmi_wwan: extend permitted QMAP mux_id value range
Message-ID: <faf4b113875c5c4eaa5532a69f9279070c5e4697.1560287477.git.rspmn@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1560287477.git.rspmn@arcor.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-VADE-STATUS: LEGIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Permit mux_id values up to 254 to be used in qmimux_register_device()
for compatibility with ip(8) and the rmnet driver.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
---
 Documentation/ABI/testing/sysfs-class-net-qmi | 4 ++--
 drivers/net/usb/qmi_wwan.c                    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net-qmi b/Documentation/ABI/testing/sysfs-class-net-qmi
index 7122d6264c49..c310db4ccbc2 100644
--- a/Documentation/ABI/testing/sysfs-class-net-qmi
+++ b/Documentation/ABI/testing/sysfs-class-net-qmi
@@ -29,7 +29,7 @@ Contact:	Bjørn Mork <bjorn@mork.no>
 Description:
 		Unsigned integer.
 
-		Write a number ranging from 1 to 127 to add a qmap mux
+		Write a number ranging from 1 to 254 to add a qmap mux
 		based network device, supported by recent Qualcomm based
 		modems.
 
@@ -46,5 +46,5 @@ Contact:	Bjørn Mork <bjorn@mork.no>
 Description:
 		Unsigned integer.
 
-		Write a number ranging from 1 to 127 to delete a previously
+		Write a number ranging from 1 to 254 to delete a previously
 		created qmap mux based network device.
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index c6fbc2a2a785..780c10ee359b 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -429,8 +429,8 @@ static ssize_t add_mux_store(struct device *d,  struct device_attribute *attr, c
 	if (kstrtou8(buf, 0, &mux_id))
 		return -EINVAL;
 
-	/* mux_id [1 - 0x7f] range empirically found */
-	if (mux_id < 1 || mux_id > 0x7f)
+	/* mux_id [1 - 254] for compatibility with ip(8) and the rmnet driver */
+	if (mux_id < 1 || mux_id > 254)
 		return -EINVAL;
 
 	if (!rtnl_trylock())
-- 
2.11.0

