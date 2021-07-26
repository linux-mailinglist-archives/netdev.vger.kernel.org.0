Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0BD3D5B43
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbhGZNdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbhGZNcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:32:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DE4C0617B9
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81LF-0001jg-VE
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:26 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3E03165824E
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 060DC6581AF;
        Mon, 26 Jul 2021 14:11:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6d2f691e;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Zhen Lei <thunder.leizhen@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 21/46] can: janz-ican3: use DEVICE_ATTR_RO/RW() helper macro
Date:   Mon, 26 Jul 2021 16:11:19 +0200
Message-Id: <20210726141144.862529-22-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

Use DEVICE_ATTR_RO/RW() helper macro instead of plain DEVICE_ATTR(), which
makes the code a bit shorter and easier to read.

Link: https://lore.kernel.org/r/20210603111739.11983-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/janz-ican3.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 2a6c918186c0..c68ad56628bd 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1815,9 +1815,9 @@ static int ican3_get_berr_counter(const struct net_device *ndev,
  * Sysfs Attributes
  */
 
-static ssize_t ican3_sysfs_show_term(struct device *dev,
-				     struct device_attribute *attr,
-				     char *buf)
+static ssize_t termination_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
 {
 	struct ican3_dev *mod = netdev_priv(to_net_dev(dev));
 	int ret;
@@ -1834,9 +1834,9 @@ static ssize_t ican3_sysfs_show_term(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "%u\n", mod->termination_enabled);
 }
 
-static ssize_t ican3_sysfs_set_term(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t count)
+static ssize_t termination_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
 {
 	struct ican3_dev *mod = netdev_priv(to_net_dev(dev));
 	unsigned long enable;
@@ -1852,18 +1852,17 @@ static ssize_t ican3_sysfs_set_term(struct device *dev,
 	return count;
 }
 
-static ssize_t ican3_sysfs_show_fwinfo(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf)
+static ssize_t fwinfo_show(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
 {
 	struct ican3_dev *mod = netdev_priv(to_net_dev(dev));
 
 	return scnprintf(buf, PAGE_SIZE, "%s\n", mod->fwinfo);
 }
 
-static DEVICE_ATTR(termination, 0644, ican3_sysfs_show_term,
-		   ican3_sysfs_set_term);
-static DEVICE_ATTR(fwinfo, 0444, ican3_sysfs_show_fwinfo, NULL);
+static DEVICE_ATTR_RW(termination);
+static DEVICE_ATTR_RO(fwinfo);
 
 static struct attribute *ican3_sysfs_attrs[] = {
 	&dev_attr_termination.attr,
-- 
2.30.2


