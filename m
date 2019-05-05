Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51F613EC9
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfEEKTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:19:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46613 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbfEEKTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:19:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id r7so13369709wrr.13
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dgKO/PHTtRuLgaFkxH9QzaBtdXWT6tp2JdglCnPI+L0=;
        b=bnsB1/2T1Kpx5jntDN4e+T2TgKlXphq4VUFCUL9E5n4XhrCp2Vj499XOEnnWu4OHwW
         ZrzB7GGp//OEGHTaSS/f64wQ0OLOEUheaRo8umm9q2t5mJwyNo+iliyLLP2zYdaVGWjO
         qYbqBPrPwBufQfNhuHV5Vt1lbhf5cT8sXCZmbtX7iDk0B7xyKIZRdgXqq9NGJ41WuS7h
         R2/I0GcGcwxoLDTFr2YCqGDf4wXZYQa48GWNo+H/bmvTrBUDZ+pkiF88nx4h4/qD+Cy/
         ZsprefMs2tef6G09IBHJ/+w1GBtjWpt0+XABnNigH5tKE+i6BHkEQYdbMDvHeiMeVxBr
         L3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dgKO/PHTtRuLgaFkxH9QzaBtdXWT6tp2JdglCnPI+L0=;
        b=JQlffnMK7kyMfl27roNgeTfruweC6/EvjFGlzZkUEwC+NgHtE1PgABIo7aD0lCwHUO
         SmWP1lOuspCukpfRArOozRcyKv3bfKOSyanuO1Cz2NatWQI4dsUx13gtL1UlCmAniF4U
         qVBqhj9IxUfUsJU+NFvH8q1Lr4aWI9xkCrwMLAROZUSyvAgsXeMiqPE672GGYKE1KF81
         L8Dn1aIaHHxpoKxcVi4jMLFgT2DoXC+ywhsAYdio3I5M02FKuv7OMkFCX2jR0l37eeqq
         EiPrK9EpMy0A2pwR7xdybXFNAW5rYDh9xa/WSCM5R86SOcrHowLNwOLao07lqb84JzMr
         VLLw==
X-Gm-Message-State: APjAAAVBSxXM4pvQIDnvD7kMNTg57VANU/ZsfeT8xvWbXtXDwuluzM5j
        AkWdvX7bC4bwl5kAYGmNrcQ=
X-Google-Smtp-Source: APXvYqwIi43ByS7XGe7wMDsMN0f7q56dzncnpqCuKnpFfopsL83Q9mCOqus+HG4FUimBo4LfSdy0jQ==
X-Received: by 2002:a5d:53cd:: with SMTP id a13mr13753208wrw.201.1557051586551;
        Sun, 05 May 2019 03:19:46 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id n2sm12333193wra.89.2019.05.05.03.19.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:19:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 07/10] net: dsa: Add a private structure pointer to dsa_port
Date:   Sun,  5 May 2019 13:19:26 +0300
Message-Id: <20190505101929.17056-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505101929.17056-1-olteanv@gmail.com>
References: <20190505101929.17056-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is supposed to share information between the driver and the tagger,
or used by the tagger to keep some state. Its use is optional.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
---
Changes in v3:
  - None.

Changes in v2:
  - None.

 include/net/dsa.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0260b73938e2..e20be1ceb306 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -210,6 +210,12 @@ struct dsa_port {
 	struct work_struct	xmit_work;
 	struct sk_buff_head	xmit_queue;
 
+	/*
+	 * Give the switch driver somewhere to hang its per-port private data
+	 * structures (accessible from the tagger).
+	 */
+	void *priv;
+
 	/*
 	 * Original copy of the master netdev ethtool_ops
 	 */
-- 
2.17.1

