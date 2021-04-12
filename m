Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A73C35BB15
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbhDLHny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236977AbhDLHns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:43:48 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4A2C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:43:30 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 25so11087226oiy.5
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kYfsAs5oGGnESDxFtqUD5yQatjSVHZVLXv9XYqH+nLg=;
        b=qEn/B9JUzgRXgnI4W9Rx0xQ1sApbu5KsVQ+LVuM0Rc3Zpnsx715eKulEMHVK01QDcW
         Q6Hb7DO6WCA0968wmZFuCElAHN6r7F/UPQYIa9B4Mod+53CBTuapU+FOo38hKu5GN4cp
         /TWQALxKaZMlAfIK9p5MPip+1ZDwNdzhHIxDOSW7bek06WQPGVeuwOWW8NVi3MWTwHaI
         fH/3qV9WRJf17Gn6BKyMT2ku4UYUTB5laNpiV7VILUhCPOB9TrG8Mt4JIIHmXVVMYgli
         R+ZiGvrUya65TX+ISCRdX1YCvxU/tt/iJlL1b6wxRaiowGzOJjWJIjPjqSPWYjSGmAgf
         4Yiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYfsAs5oGGnESDxFtqUD5yQatjSVHZVLXv9XYqH+nLg=;
        b=soBD9mVk77rPsbnIGaqgcGDXHiTNF2+F5asR2FoFUqSP5LsaKMOcjPYW2zpqZtK+iV
         d+hrTayVy0fRPwppiWruV/szjPQ5EojpsR7woX4MJ1AvSmpuTHHeBQyRPiJIl88OlN8o
         A68OC1rYNUsT+m766nL7bitBaptXr4K2xhKTObAMWJMqUbUlRqWpZu0rpd3gUG7R6Af0
         L7ex5qVs2R0VRZDna2wUzM9gbO/T/NErSlGjbOUv5tHyc43Ep08vysspUpqezgImIj1b
         36xUM0ljrD1vPivcmg3x+TNAs4PNCq/niqgG877Jq3CJS5BQGEjHkk0BjBtJBeD/YCzz
         pcpQ==
X-Gm-Message-State: AOAM533Ec0o8P53KNaRIJf+Prylgb/UYkyu/10Hdzwm/nYTmjQgh3UGL
        Hu8TYygE+kNBu1pF3TVbtJUwc+mI0sg=
X-Google-Smtp-Source: ABdhPJxOqnJ+YzHMEhdN/rPI5UmJ933pB60qzUIzsc/4cRTAQlCDn5unWyGZzzSbw/nJh2WkZ8Pltg==
X-Received: by 2002:aca:4c0c:: with SMTP id z12mr18682734oia.109.1618213409473;
        Mon, 12 Apr 2021 00:43:29 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:70fe:cfb5:1414:607d])
        by smtp.gmail.com with ESMTPSA id f12sm2485676otf.65.2021.04.12.00.43.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Apr 2021 00:43:29 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 2/2] ibmvnic: add sysfs entry for timeout and fatal reset
Date:   Mon, 12 Apr 2021 02:43:30 -0500
Message-Id: <20210412074330.9371-3-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412074330.9371-1-lijunp213@gmail.com>
References: <20210412074330.9371-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add timeout and fatal reset sysfs entries so that both functions
can be triggered manually the tested. Otherwise, you have to run
the program for enough time and check both randomly generated
resets in the long long log.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 50 ++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d44a7b5b8f67..b4d2c055a284 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5329,6 +5329,8 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 	return rc;
 }
 
+static struct device_attribute dev_attr_timeout;
+static struct device_attribute dev_attr_fatal;
 static struct device_attribute dev_attr_failover;
 
 static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
@@ -5407,9 +5409,15 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
 	netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
 
+	rc = device_create_file(&dev->dev, &dev_attr_timeout);
+	if (rc)
+		goto ibmvnic_dev_file_timeout_err;
+	rc = device_create_file(&dev->dev, &dev_attr_fatal);
+	if (rc)
+		goto ibmvnic_dev_file_fatal_err;
 	rc = device_create_file(&dev->dev, &dev_attr_failover);
 	if (rc)
-		goto ibmvnic_dev_file_err;
+		goto ibmvnic_dev_file_failover_err;
 
 	netif_carrier_off(netdev);
 	rc = register_netdev(netdev);
@@ -5428,7 +5436,13 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 ibmvnic_register_fail:
 	device_remove_file(&dev->dev, &dev_attr_failover);
 
-ibmvnic_dev_file_err:
+ibmvnic_dev_file_failover_err:
+	device_remove_file(&dev->dev, &dev_attr_fatal);
+
+ibmvnic_dev_file_fatal_err:
+	device_remove_file(&dev->dev, &dev_attr_timeout);
+
+ibmvnic_dev_file_timeout_err:
 	release_stats_token(adapter);
 
 ibmvnic_stats_fail:
@@ -5481,11 +5495,43 @@ static void ibmvnic_remove(struct vio_dev *dev)
 
 	rtnl_unlock();
 	mutex_destroy(&adapter->fw_lock);
+	device_remove_file(&dev->dev, &dev_attr_timeout);
+	device_remove_file(&dev->dev, &dev_attr_fatal);
 	device_remove_file(&dev->dev, &dev_attr_failover);
 	free_netdev(netdev);
 	dev_set_drvdata(&dev->dev, NULL);
 }
 
+static ssize_t timeout_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct net_device *netdev = dev_get_drvdata(dev);
+	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
+
+	if (!sysfs_streq(buf, "1"))
+		return -EINVAL;
+
+	ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
+
+	return count;
+}
+static DEVICE_ATTR_WO(timeout);
+
+static ssize_t fatal_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct net_device *netdev = dev_get_drvdata(dev);
+	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
+
+	if (!sysfs_streq(buf, "1"))
+		return -EINVAL;
+
+	ibmvnic_reset(adapter, VNIC_RESET_FATAL);
+
+	return count;
+}
+static DEVICE_ATTR_WO(fatal);
+
 static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-- 
2.23.0

