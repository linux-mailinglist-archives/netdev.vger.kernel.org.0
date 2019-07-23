Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F971A0C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390497AbfGWOPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:15:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38297 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfGWOPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:15:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id f5so10683844pgu.5;
        Tue, 23 Jul 2019 07:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t8/tYNsVxDLiBnfPm14iuWNmhM56kmPj2n/HRk6yks8=;
        b=N1YENDNLsN8BAjvWh4jHBgqIidbRRnVoIi6SYOXw+vTl2GHO2Ocurbufia/6kbMdlP
         xhKzKjfaAUuslQdmPNX+0QwHiFzyggi3HQuAwzL0eNUcKj8tIJpjNs3CcNorPsp8uLOX
         MpBJsmTFo7gTDEmZA5Pt/1FFG4KAelDUyTxtl5RTdOt0jEoRgosuNx8TlpGU+6Pvpw9q
         YWGX16b7eMyOHOTdvsHZ2bS8yOvsTwUhe1EQhEYUvGPBFL7q/8dz6Hp+rKSFYDR3ObPT
         ouvLHqXEgInfSVwt3abO9YgrWR/db0rpjlKhvICNbYt6exk5r3UrAWdipm5l38s0bYl7
         ANVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t8/tYNsVxDLiBnfPm14iuWNmhM56kmPj2n/HRk6yks8=;
        b=MQgYHAucwWuDfeAAFIEN3Msl0T0DmUBNgt2ma1x57Sri0nZ/fRwzVKBMYhJjI0GrL7
         qHzc4ZbWkqku1AGagQtClH8ikKgq2e5r9FCrWCsXbnceBueyZa1G2JhO8bpfBCPKkfgh
         CYjxBWGCNnGVl9L7WZ86+h8oWiGd/Iy3r0lXQ56cxVFgeZ3+5j02uBJbWwDBcH7bKHuN
         ib9s0BnQwaY+9BKZ2c12VY9el1GwaALf3mFpKBzrMSDm6T72AQvDoT9/kCqiuj6ZWzTZ
         6TAXGPtNRt8BHHdNpdtehFqaP5juhXdpYz5vZnsaTGMxV+B8NXyGPU23f11dXcZOAni2
         TBbQ==
X-Gm-Message-State: APjAAAW5Z3R+wEfaX04Coce7EqwUP26HpaFzVTfZqYHG693CwgBqxcGo
        HXami/VKOxwiBHBVUwD6iug=
X-Google-Smtp-Source: APXvYqyjee5FJxFzNGCVsaawUAzdmeQOTwBPSjj0kU5hpEjsEX3E5SwZSYWIU/L2KabkoYR+fyfJbw==
X-Received: by 2002:a63:e54f:: with SMTP id z15mr76552521pgj.4.1563891338414;
        Tue, 23 Jul 2019 07:15:38 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id bg3sm39370448pjb.9.2019.07.23.07.15.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 07:15:37 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] fm10k: Use dev_get_drvdata
Date:   Tue, 23 Jul 2019 22:15:33 +0800
Message-Id: <20190723141533.5803-1-hslester96@gmail.com>
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
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index e49fb51d3613..7bfc8a5b6f55 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -2352,7 +2352,7 @@ static int fm10k_handle_resume(struct fm10k_intfc *interface)
  **/
 static int __maybe_unused fm10k_resume(struct device *dev)
 {
-	struct fm10k_intfc *interface = pci_get_drvdata(to_pci_dev(dev));
+	struct fm10k_intfc *interface = dev_get_drvdata(dev);
 	struct net_device *netdev = interface->netdev;
 	struct fm10k_hw *hw = &interface->hw;
 	int err;
@@ -2379,7 +2379,7 @@ static int __maybe_unused fm10k_resume(struct device *dev)
  **/
 static int __maybe_unused fm10k_suspend(struct device *dev)
 {
-	struct fm10k_intfc *interface = pci_get_drvdata(to_pci_dev(dev));
+	struct fm10k_intfc *interface = dev_get_drvdata(dev);
 	struct net_device *netdev = interface->netdev;
 
 	netif_device_detach(netdev);
-- 
2.20.1

