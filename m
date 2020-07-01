Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8A1211126
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732620AbgGAQwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732602AbgGAQwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:52:36 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160F6C08C5C1;
        Wed,  1 Jul 2020 09:52:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b16so11227690pfi.13;
        Wed, 01 Jul 2020 09:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2OLtDqAl4GQ2i7cTj9ta2eBmWz0EGmYq4wIiRHp9/FE=;
        b=uhAQ6kTuNIPnAT6MZkGQZKPb4SmYjOBPwJu8bF4DqpSBJ2+/iWeXskur80ZvhEnM0e
         83KcHzQtUvovd16tT+9PzEHT2+tviuVorr/7I0Y4VrT1PpMs3TnRKPJF0GVozplJNRj/
         fZOG7kU4FjPpDnCpDdte2ESXTM0wPQ++dLS0F2dERlycf1Wd3C4WCLUBbKc224dN0ecR
         64IwHgqSZsKcQYEfbJQMrtNFnUmdNaqfTiqv2peK3RKZuMGARAUMs5PUA9Dk2QDRyi7/
         FSWinVuXuoo+ORVJacu+1QvapZdmG/RYiNjEOyfWa7xZ/eRNMm4sySmJMMYH9Xa0AqNM
         5UmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2OLtDqAl4GQ2i7cTj9ta2eBmWz0EGmYq4wIiRHp9/FE=;
        b=QPxR0PDyiCME8spE+De3lZP3D1cr3qzzltar46X2HfcVPYRgKLXlq6NTdof1hfplfN
         l0/ijliwjWk1gHJ1hxXUFNM4iK/O9wONMkOsfycgA12vyLP2yVHgp9DOdQk7me6VJ5PG
         GCex2iy1Z5J1PTe1hRCNHxyI3II9CXehpErYn0C7yl4+q8oKR5qLhWvuTeS8OtMi3vQI
         lbJTqKnhktijGCyheEp7rgoNYjqU0s/UkZ2kucCDWJU0ltP86P634SRzo3EGy15bdaRp
         j4Iwuu1HfvkSRbP2Ak361UnytVWeUo1q6UXnqg53g7AhZ4BaRITZqy4iQLipVvlTFSym
         eDsA==
X-Gm-Message-State: AOAM533R/gI/eb1OHUHZerxCRP7TKte1jMKYYhXldoBYIoA2N0drHmg+
        vFtzrUocCvoJkyIP+1oh+7E=
X-Google-Smtp-Source: ABdhPJxEUsqZPmzsavfE1MqbjnpPEztOqazk0eTG0nDsad7kI5kOMDKcC6abnLyAgzL47jY9RzIgsg==
X-Received: by 2002:a62:f206:: with SMTP id m6mr11838671pfh.260.1593622355553;
        Wed, 01 Jul 2020 09:52:35 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id g140sm6297437pfb.48.2020.07.01.09.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:52:35 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v2 01/11] typhoon: use generic power management
Date:   Wed,  1 Jul 2020 22:20:47 +0530
Message-Id: <20200701165057.667799-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
References: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states. And they use PCI
helper functions to do it.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

In this driver:
typhoon_resume() calls typhoon_wakeup() which then calls PCI helper
functions pci_set_power_state() and pci_restore_state(). The only other
function, using typhoon_wakeup() is typhoon_open().

Thus remove the pci_*() calls from tyhpoon_wakeup() and place them in
typhoon_open(), maintaining the order, to retain the normal behavior of
the function

Now, typhoon_suspend() calls typhoon_sleep() which then calls PCI helper
functions pci_enable_wake(), pci_disable_device() and
pci_set_power_state(). Other functions:
 - typhoon_open()
 - typhoon_close()
 - typhoon_init_one()
are also invoking typhoon_sleep(). Thus, in this case, cannot simply
move PCI helper functions call.

Hence, define a new function typhoon_sleep_early() which will do all the
operations, which typhoon_sleep() was doing before calling PCI helper
functions. Now typhoon_sleep() will call typhoon_sleep_early() to do
those tasks, hence, the behavior for _open(), _close and _init_one() remain
unchanged. And typhon_suspend() only requires typhoon_sleep_early().

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/3com/typhoon.c | 53 +++++++++++++++++------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 5ed33c2c4742..d3b30bacc94e 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -1801,9 +1801,8 @@ typhoon_free_rx_rings(struct typhoon *tp)
 }
 
 static int
-typhoon_sleep(struct typhoon *tp, pci_power_t state, __le16 events)
+typhoon_sleep_early(struct typhoon *tp, __le16 events)
 {
-	struct pci_dev *pdev = tp->pdev;
 	void __iomem *ioaddr = tp->ioaddr;
 	struct cmd_desc xp_cmd;
 	int err;
@@ -1832,20 +1831,29 @@ typhoon_sleep(struct typhoon *tp, pci_power_t state, __le16 events)
 	 */
 	netif_carrier_off(tp->dev);
 
+	return 0;
+}
+
+static int
+typhoon_sleep(struct typhoon *tp, pci_power_t state, __le16 events)
+{
+	int err;
+
+	err = typhoon_sleep_early(tp, events);
+
+	if (err)
+		return err;
+
 	pci_enable_wake(tp->pdev, state, 1);
-	pci_disable_device(pdev);
-	return pci_set_power_state(pdev, state);
+	pci_disable_device(tp->pdev);
+	return pci_set_power_state(tp->pdev, state);
 }
 
 static int
 typhoon_wakeup(struct typhoon *tp, int wait_type)
 {
-	struct pci_dev *pdev = tp->pdev;
 	void __iomem *ioaddr = tp->ioaddr;
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
 	/* Post 2.x.x versions of the Sleep Image require a reset before
 	 * we can download the Runtime Image. But let's not make users of
 	 * the old firmware pay for the reset.
@@ -2049,6 +2057,9 @@ typhoon_open(struct net_device *dev)
 	if (err)
 		goto out;
 
+	pci_set_power_state(tp->pdev, PCI_D0);
+	pci_restore_state(tp->pdev);
+
 	err = typhoon_wakeup(tp, WaitSleep);
 	if (err < 0) {
 		netdev_err(dev, "unable to wakeup device\n");
@@ -2114,11 +2125,10 @@ typhoon_close(struct net_device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int
-typhoon_resume(struct pci_dev *pdev)
+static int __maybe_unused
+typhoon_resume(struct device *dev_d)
 {
-	struct net_device *dev = pci_get_drvdata(pdev);
+	struct net_device *dev = dev_get_drvdata(dev_d);
 	struct typhoon *tp = netdev_priv(dev);
 
 	/* If we're down, resume when we are upped.
@@ -2144,9 +2154,10 @@ typhoon_resume(struct pci_dev *pdev)
 	return -EBUSY;
 }
 
-static int
-typhoon_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused
+typhoon_suspend(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct typhoon *tp = netdev_priv(dev);
 	struct cmd_desc xp_cmd;
@@ -2190,18 +2201,19 @@ typhoon_suspend(struct pci_dev *pdev, pm_message_t state)
 		goto need_resume;
 	}
 
-	if (typhoon_sleep(tp, pci_choose_state(pdev, state), tp->wol_events) < 0) {
+	if (typhoon_sleep_early(tp, tp->wol_events) < 0) {
 		netdev_err(dev, "unable to put card to sleep\n");
 		goto need_resume;
 	}
 
+	device_wakeup_enable(dev_d);
+
 	return 0;
 
 need_resume:
-	typhoon_resume(pdev);
+	typhoon_resume(dev_d);
 	return -EBUSY;
 }
-#endif
 
 static int
 typhoon_test_mmio(struct pci_dev *pdev)
@@ -2533,15 +2545,14 @@ typhoon_remove_one(struct pci_dev *pdev)
 	free_netdev(dev);
 }
 
+static SIMPLE_DEV_PM_OPS(typhoon_pm_ops, typhoon_suspend, typhoon_resume);
+
 static struct pci_driver typhoon_driver = {
 	.name		= KBUILD_MODNAME,
 	.id_table	= typhoon_pci_tbl,
 	.probe		= typhoon_init_one,
 	.remove		= typhoon_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= typhoon_suspend,
-	.resume		= typhoon_resume,
-#endif
+	.driver.pm	= &typhoon_pm_ops,
 };
 
 static int __init
-- 
2.27.0

