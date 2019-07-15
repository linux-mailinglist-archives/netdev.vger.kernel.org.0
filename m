Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A77C682B0
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 05:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfGODV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 23:21:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46434 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfGODV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 23:21:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id i8so6983394pgm.13;
        Sun, 14 Jul 2019 20:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fQU3ZitNVbm8g6DoiatmHMkRIAL8qxW71kXnvl1QgC8=;
        b=XbAowxVqvNdy8E1lQinnYcjQHKkyTRK4zaOdGeWMOJAtvSf53PE1wo4OfS7WjZvTE0
         FO8caUAxXl+wk+s2u2Eb8t6oGYsitr911KwmFgSTk3erDsqjpFNT81Ac16bF23GOfe5l
         Z8PsEviv+DA6JMaWvyjp9qKRdXP/owmolf65Ul/Qb51H7vkFTlJoq8ghRhytxSp9Qybl
         RAEGDvdcGVRBTn9M2s6i3aqn23QJszAIqhfxc9UWlhuxYUmrINZ+oLPLCKCqkmw9mF2q
         hoITZTklk/JrP+H9sbaSbrm9MxHRcD2nd/qVS7Fkcm72EHttsGEnb3g5G3lPumDRplSV
         qKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fQU3ZitNVbm8g6DoiatmHMkRIAL8qxW71kXnvl1QgC8=;
        b=s0rv3N8gvZF/PeMPaqfL5sPRdeXfZug2empiAKHUh3ZiTXPtCuMcZhhuhOz+tYSgDk
         K+LTsmGGFVNHq5u8eoD7kUXGOG2UTh874AA57bdxeDv93uFgKf4mpjU+cdNWN+VX97Gp
         URszdWN/z9Jy/X8NTuxmQ9Upwg1u56QEp6LSdF+wKA0hawacOvqpOP1jBTSAMLC5xGA7
         JVN6KYNFO3ZgzgqDfdcu+S3do8GC+u26kQv+skTBbWF4td6kL2gP/AiurpqQ0y2M9ITR
         MN1h/cjBfdB932Lbeh9R9QdRhERQX0NYKDc9viS9D+1edl3TfZJR435qpYzQ3rPdSNia
         v2NQ==
X-Gm-Message-State: APjAAAX83ofJhvPvtaXY0P0OfIj9Rnd1cbqZ0pNCzzZQ8NtSsM4ky+SI
        GxTLQUZRyUXLKPCpqyFYeug=
X-Google-Smtp-Source: APXvYqw1SWs+vEujyYwb300maXHvrIECcJMnhv9T7DAFz24xMqClCEgqiec77HLsNWJls9sIMsovmA==
X-Received: by 2002:a63:e54f:: with SMTP id z15mr24551571pgj.4.1563160885244;
        Sun, 14 Jul 2019 20:21:25 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id n26sm16548898pfa.83.2019.07.14.20.21.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 20:21:24 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Ronak Doshi <doshir@vmware.com>,
        "VMware Inc ." <pv-drivers@vmware.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v3 19/24] vmxnet3: Remove call to memset after dma_alloc_coherent
Date:   Mon, 15 Jul 2019 11:21:18 +0800
Message-Id: <20190715032118.7417-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 518a2f1925c3
("dma-mapping: zero memory returned from dma_alloc_*"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v3:
  - Use actual commit rather than the merge commit in the commit message

 drivers/net/vmxnet3/vmxnet3_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 3f48f05dd2a6..2a1918f25e47 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3430,7 +3430,6 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 			err = -ENOMEM;
 			goto err_ver;
 		}
-		memset(adapter->coal_conf, 0, sizeof(*adapter->coal_conf));
 		adapter->coal_conf->coalMode = VMXNET3_COALESCE_DISABLED;
 		adapter->default_coal_mode = true;
 	}
-- 
2.11.0

