Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B68D727E7
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfGXGGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:06:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41921 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:06:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so10292574pgg.8;
        Tue, 23 Jul 2019 23:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+1HMfJjTxMmt6yq++N5V1yBpZofp5uwv8IyU21fY09c=;
        b=JdS7ifxwE5qDaTMSddnrdpqo9R9gPEQj/gz1fqKljkmbd2SaAplf3F0DSQKVQEO4FS
         QAK4ELOErHgMoo2VKVENGOz9dzr4hHEApog1mJWsE0Bn58E0kOVyhNSf+M3rNiEkdJRc
         fkNctifv/t8AvuNwjL88aNZbbTJT09gAPeprHC28MywLmXm0Aty32f7lQP/b5HdJk79g
         jNpn9GkZ3p7kCNuI28jLl2wP6qv6fMZQeLx/vegsNS9LJ+3Gvh65hQUJuvezhf8LoWvv
         6k/h5/9USe7Y6iLNRmS2H1/fLPtb5CN7Ygea19y1sEhER5TlS65gRL/3/FXBaYjxEznW
         07mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+1HMfJjTxMmt6yq++N5V1yBpZofp5uwv8IyU21fY09c=;
        b=p9OUDrHduXtqS4zVmIwBz2eMksk4j4tYw1i3NFv1ve3Y2T7EABPpPvyyT7bHpKpNji
         D21d6O+hHoLiSWy07fwKLQxUmp78d3loe1Rhnd123dythsHc5QQ/A1b5RDvlhjLQBMYY
         YibujAccT7YlI02WM383h5EiVQnptyt29f2n5Vg0v7OkqAuNQMnu7bxdCmJhl1foMrXl
         AdQCyvyBYxtnmydCJu2tOYHSTxuvaXvAgMxeuacj/Lf8G4BhIWfQ/fsD+j3hW/wRsDdy
         bc7ohkrH4HUsotmOaIeL13rxn305RGopK2VV5S2pYtiDsOYGkn0L90EgyO5W7vavwFy3
         3u5w==
X-Gm-Message-State: APjAAAUpGAL1PofnOEeNKBdwlOntyQaMA5wZhm1E2EbRPeuertoRlRqr
        uzb+PEJ0ASP0iqCwscBrB9/3ijkO19M=
X-Google-Smtp-Source: APXvYqzOXgXuZYtmgP1MoJxtOZOC9ioO4gK6RyHz2B7lwyoIGdQG/TTs7Wpl4gfJbhuIGrYlQYXzfA==
X-Received: by 2002:a17:90a:258b:: with SMTP id k11mr82378025pje.110.1563948398256;
        Tue, 23 Jul 2019 23:06:38 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id c23sm31909568pgj.62.2019.07.23.23.06.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:06:37 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net-next v2 7/8] igb: Use dev_get_drvdata where possible
Date:   Wed, 24 Jul 2019 14:06:33 +0800
Message-Id: <20190724060633.24280-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Change pci_set_drvdata to dev_set_drvdata
    to keep consistency.

 drivers/net/ethernet/intel/igb/igb_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b4df3e319467..ed301428c0ce 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3048,7 +3048,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
-	pci_set_drvdata(pdev, netdev);
+	dev_set_drvdata(&pdev->dev, netdev);
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
@@ -8879,8 +8879,7 @@ static int __maybe_unused igb_resume(struct device *dev)
 
 static int __maybe_unused igb_runtime_idle(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct net_device *netdev = dev_get_drvdata(dev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
 	if (!igb_has_link(adapter))
-- 
2.20.1

