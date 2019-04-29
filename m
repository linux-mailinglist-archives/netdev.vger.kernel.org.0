Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880D5DBBA
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 08:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfD2GBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 02:01:21 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45977 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfD2GBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 02:01:20 -0400
Received: by mail-lf1-f66.google.com with SMTP id t11so6848776lfl.12;
        Sun, 28 Apr 2019 23:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UC42DcLXAcE+LVtPIk7UgcztXVrIO708I+O1jic9JgM=;
        b=dDW3XiWgt4NK6FQcYSxmKx8WCraOlZhI5Hgu9cP0lV2vV7b0rIqgghfRuqMGKjkG0z
         gS+Ef1NaGI15YSpI6wgcsOnhWb4PJ9txy8V8IkWhevO0izfWWU5CmnOosuMk2xWns536
         nHgGIAFh6W5QeX/R2elWsP++rF8uRumO/kihhsZHyK2Aa5HUKnY5JGyPGMkwo3bNqtcn
         FXW+8kb24b5D6yTlyMsA+ea1hFSf+v7VJwYomc7RRwCwBaiBq4I1WFmfoLkcipKCdCks
         zy6UVhBGvLbG8a8ySNtZN/0f4a/nXaDAWzZeMEbZp1Klg7EYy7S3U4UGnXz6L9JvHv+Q
         Pb4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UC42DcLXAcE+LVtPIk7UgcztXVrIO708I+O1jic9JgM=;
        b=T459qRzTmNZ1U+9nJQQD4hn86jZlmVqg1FWBmDiekLhH6xa5ADUpk1EcHcjwGifxJ5
         RVnTMQ3+Ra7b+J+4sHXem14n+bJJkKtoqCdCpTBtiiB3G+yiGVvKQlbRlQdll/4nuCwf
         F1Sv62pnt/Lqw4+rA3GMVK7Mi/mf3pnhyEqG56aQuNa+mSB23oeup1MM6K9ryWpbdahe
         Y0dfWCFTWWvbKc2Dd6nv22+UBznTNHt6VnOLsfxkUteN2ngU+QCC10hGSL+UcJY42Uuy
         3WNV83Ig2ndms1ci69MbZQRZOFV8odQsZc1orx6LoiFiLAiyN8mIJ29kV5RXBg2ZnbWg
         S9nQ==
X-Gm-Message-State: APjAAAVwzKGEmIFY9uvN8Tu9u9EYLUK0pfvwagy5P5+1PkcspXQ9Y2hF
        6C9fzdLZdD9BZvrXIbtS59s=
X-Google-Smtp-Source: APXvYqzE6DM+lM6WV3M7l5Wvzxp1UPxhvXPyDnX49kh9UkLUyRY04nx0O0NK2JsQnsER0oDxn+8SEw==
X-Received: by 2002:a19:f001:: with SMTP id p1mr33272665lfc.27.1556517678598;
        Sun, 28 Apr 2019 23:01:18 -0700 (PDT)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t8sm514783lfl.73.2019.04.28.23.01.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 23:01:18 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net-sysfs: expose IRQ number
Date:   Mon, 29 Apr 2019 08:01:07 +0200
Message-Id: <20190429060107.10245-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Knowing IRQ number makes e.g. reading /proc/interrupts much simpler.
It's more reliable than guessing device name used by a driver when
calling request_irq().

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
I found a script parsing /proc/interrupts for a given interface name. It wasn't
working for me as it assumed request_irq() was called with a device name. It's
not a case for all drivers.

I also found some other people looking for a proper solution for that:
https://unix.stackexchange.com/questions/275075/programmatically-determine-the-irqs-associated-with-a-network-interface
https://stackoverflow.com/questions/7516984/retrieving-irq-number-of-a-nic

Let me know if this solution makes sense. I can say it works for me ;)
---
 Documentation/ABI/testing/sysfs-class-net |  7 +++++++
 net/core/net-sysfs.c                      | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
index 664a8f6a634f..33440fe77ca7 100644
--- a/Documentation/ABI/testing/sysfs-class-net
+++ b/Documentation/ABI/testing/sysfs-class-net
@@ -301,3 +301,10 @@ Contact:	netdev@vger.kernel.org
 Description:
 		32-bit unsigned integer counting the number of times the link has
 		been down
+
+What:		/sys/class/net/<iface>/irq
+Date:		April 2019
+KernelVersion:	5.2
+Contact:	netdev@vger.kernel.org
+Description:
+		IRQ number used by device
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e4fd68389d6f..a3eb7c3f1f37 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -512,6 +512,21 @@ static ssize_t phys_switch_id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(phys_switch_id);
 
+static ssize_t irq_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	const struct net_device *netdev = to_net_dev(dev);
+	ssize_t ret;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+	ret = sprintf(buf, "%d\n", netdev->irq);
+	rtnl_unlock();
+
+	return ret;
+}
+static DEVICE_ATTR_RO(irq);
+
 static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_netdev_group.attr,
 	&dev_attr_type.attr,
@@ -542,6 +557,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_proto_down.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
+	&dev_attr_irq.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.21.0

