Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7707F179F1B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgCEFXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:23:36 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37687 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgCEFXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:23:35 -0500
Received: by mail-pl1-f195.google.com with SMTP id b8so2108967plx.4
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=61gZ4SQN/1tdeU8RQk3DcrIUxl3TSrJNCIjlf4zlDM0=;
        b=c2rZWdIyjxSoFFNxGpSsDAFN/DmrQ9plnVo2DjzHabStkhK7qga4oPnp2yX+YdcpbG
         EgiAdSFDLmicoc06LxQSFLwxMuyyXXTfUck9NhUHzxZrnpSwdJhIoct10vZjzkw140Qo
         PIZNGOtX9OFf6sK1dJeEIhPX5h6TnHDJjhoUHuQpXU0IYxzNhCLjWCn79Ku4xc3vPxxH
         ljcsT/6oA8rVsSI0u0p88FCMwBrVuRK7qDSRyZYR1nlP7vq07AJghI/wdULgfmCBdaXv
         +c4PemCrRd0AUrnoKzLFFwVjmErys2+6L7DzkWC83OOIdsqt0Pp9shTukzp/tyJa0bLk
         1PyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=61gZ4SQN/1tdeU8RQk3DcrIUxl3TSrJNCIjlf4zlDM0=;
        b=pU7WIfW7o954P7oQphJ2zVEGUdBctAuDuwNGh9mHLBKEXxZHMjYU8pFsB/9KXwZiHA
         TZp/1im9OXVycjAvm0S5F7zjDxd1Ku6dg8v6noaKd2Kvz8CCATpenfsrVu9AxExyLkbw
         uSz3kdZsuDOmZmA25DLezEhJfpMkBEen3mWn9yfZzstQVClSacK8sT5qo7oPVSVbrptA
         ibXq+MlXCnyje+PVfaQS5O1ZQ32T007jndIYYMMumdPlYaMXUrifkDK/3APRjrZxa4i6
         F6P8bvAQHQ9+iLgYauaghugHUyXgsoRtORzt95rjAxnuAdvJzosu4MpVBF+nU+sgf6WZ
         aKJA==
X-Gm-Message-State: ANhLgQ0yfqdDLJvG2cjE0pGybu7hS3VwDlD/HN7JzIYdicxgWZlHCkm5
        lSAp0ELTGLxgyYuM4EGeCSHu1aOZjMg=
X-Google-Smtp-Source: ADFU+vtVAluaGxjTSAJjstPuTqpSzbevEOqlvy/blfv1Rbg0bJ01xM6jbjbICv9lb/jcFHzh13Yx5g==
X-Received: by 2002:a17:90a:8c06:: with SMTP id a6mr6131838pjo.137.1583385814649;
        Wed, 04 Mar 2020 21:23:34 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h2sm29337759pgv.40.2020.03.04.21.23.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 21:23:34 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 7/8] ionic: add support for device id 0x1004
Date:   Wed,  4 Mar 2020 21:23:18 -0800
Message-Id: <20200305052319.14682-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305052319.14682-1-snelson@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for an additional device id.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h         | 1 +
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index bb106a32f416..c8ff33da243a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -18,6 +18,7 @@ struct ionic_lif;
 
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
+#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT	0x1004
 
 #define DEVCMD_TIMEOUT  10
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 59b0091146e6..3dc985cae391 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -15,6 +15,7 @@
 static const struct pci_device_id ionic_id_table[] = {
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF) },
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF) },
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT) },
 	{ 0, }	/* end of table */
 };
 MODULE_DEVICE_TABLE(pci, ionic_id_table);
-- 
2.17.1

