Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9A8178979
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgCDEUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:20:30 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34078 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbgCDEU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:20:29 -0500
Received: by mail-pj1-f67.google.com with SMTP id f2so2000053pjq.1
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 20:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s5+2M55qCyjMNWRRfZa1qww5IAjEysQ2sF63nol+NPk=;
        b=o/8mqBokSRQXoU4XC6DcIe4Ph6Hueob/rLo8judmjoqeeu4syg13hZhI87wMvih09b
         Csb55Ge0v17DZploNjVpl1k5SUa4TaA22AmQe9G7d9t0zohCxDX/hULDPoeHsF1pf+Uy
         VgDWm7ypDG+Gm8cgaNDl6nZ4joUBHA68j3POAsTSZlquroR7I/VeMFn90QVxpFVoUeUa
         vfRy+/BTnbeVTdi1tQXSazckVvHQqEBmnZ1USfeISQRlc39VmfxBO9/OVW4Sar2aURNd
         JYDF17Agq8Uc6OGFcnRrdts9drMGWMcVYkCu9wh3vVjZWYrYS8LJIb8jGhAUDz+ChGha
         lN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s5+2M55qCyjMNWRRfZa1qww5IAjEysQ2sF63nol+NPk=;
        b=TofN6/kYyjL2JBzZUQvemYpsKvRIaijSE8NPe046/6tRhu7ZUmuiImTdCWE6f/Ecxq
         vsvkWqZlMRQLpawo8JMb6Ylwok9f+xzpFtVQaiP6PIavxiVmfN9oRF+tKfNAd+zO72NQ
         s9JSWLZFQBG3fzgFenlrFkaHwq1W7NifUafQR7ZOXHREJl79/BG2o6pKFiStJb53r7lU
         iBjzR5qmGI+ahz5XZEi9M6OgBLy1+LMx5QvoKX7swRVJJfucM6C6UdmxEMeN72TXo42t
         54Ootkta/P83VMxcm+0nqjRtxrRCw8r3iNmuRJCQYTIC+DV0hhJjTTVvRdnniRfedqTw
         cxpw==
X-Gm-Message-State: ANhLgQ21rd69/+/02MN6cB6dZzd1UprKQG3NtVc5wP7Vg65l1l0jRoEE
        0zyzeCzN0+OKMlZWISUZF0R36g==
X-Google-Smtp-Source: ADFU+vv+IM95Aj3uNPou2H87G8LB84K8g6d8oGy7gOaXKt4DS7G559Eu5AliT7iX788nlRWv87T21g==
X-Received: by 2002:a17:90a:5d18:: with SMTP id s24mr1027193pji.141.1583295627282;
        Tue, 03 Mar 2020 20:20:27 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm671702pjo.28.2020.03.03.20.20.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:20:26 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 6/8] ionic: print pci bus lane info
Date:   Tue,  3 Mar 2020 20:20:11 -0800
Message-Id: <20200304042013.51970-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304042013.51970-1-snelson@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print the PCI bus lane information so people can keep an
eye out for poor configurations that might not support
the advertised speed.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 554bafac1147..59b0091146e6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -248,6 +248,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	pci_set_master(pdev);
+	pcie_print_link_status(pdev);
 
 	err = ionic_map_bars(ionic);
 	if (err)
-- 
2.17.1

