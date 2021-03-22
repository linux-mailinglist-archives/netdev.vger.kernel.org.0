Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10876343FDF
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhCVLcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCVLb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 07:31:56 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F972C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:31:55 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id b7so20657019ejv.1
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0hH7rYyRKArDZ3Ab4/Yhxw9M5G5DAcrHuw30ilWo+lE=;
        b=aO20ko8i5byt4DlW7ELNGZoV7hqObUrQ4hXtde/KIRFBFtrF7zLFCWW8nzzOyQTeqD
         wgQRkrBYChx6979/nXct1bvCQt0An7sjrc5HsGnPHb7BGqWaUJ1f3Yhi3+ne0Nl7PKCb
         /DZ14FxC9EDEapaX6xlomlrZZt6A4LPt8z11kKngB2tzTYJrWGS+AW0b6xjFRw2lfxss
         SoXQD/zgSGV8D2A/zF+5wWELTq1xlEL0x4YKlCqRhSc3U4fGe7/h/HDuO0a8jJPiguM6
         CjK4SsiXFbz4352wQ4JK7vUG4uvzlLrVNkKgrO8PMsLSPabR9Xcn7eUQ30cltMlnYtPH
         pQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0hH7rYyRKArDZ3Ab4/Yhxw9M5G5DAcrHuw30ilWo+lE=;
        b=YFDcO+fBJd8yOCDBwQ/JftsZZ8phA+4vsuq+R7jyCyO7KTrBmVuGFgX/8XMIh9QGuI
         cECYaTy/A30VGkwMM3pVB6U8WrxAJSlsdeAN7GNDceTwP0X7n+27oEI5/dTXli7Y9kr5
         Bk6rYVILwloQlUK7QDG6GN78XbfzoLkrCBy5/HGxJBQ7hJ1KxbVR93w+5VYo1/99VNzX
         JLVhruHn+Llh5VzB2h82rJuOIZrko9eD+5HGW+ZOilanc8hNUtX1rImS+KbLl6lUPok+
         Bj9/CMcf4nVTcF+TuLF94+59FgLSVapKg2ftz1XIN64Xr0YWh2bJB+nsXVfIh0TWMq7q
         qvKg==
X-Gm-Message-State: AOAM532XhlF29E/guqRY8526j7IXwsPeCq3XosYjRPU5hOCB760+ZTKG
        +fE1tH0ZBszpDwmivH3qy20=
X-Google-Smtp-Source: ABdhPJwOOsPcIFtsRvjHOGZoXtEbWt10Wf7tdGKMr7C/D4Ox5tuxVLO5gL1rKHL4xGW0WhyPb4F/eg==
X-Received: by 2002:a17:906:4cd6:: with SMTP id q22mr18755669ejt.469.1616412714335;
        Mon, 22 Mar 2021 04:31:54 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w18sm9664152ejn.23.2021.03.22.04.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 04:31:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: move the ptype_all and ptype_base declarations to include/linux/netdevice.h
Date:   Mon, 22 Mar 2021 13:31:48 +0200
Message-Id: <20210322113148.3789438-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

ptype_all and ptype_base are declared in net/core/dev.c as non-static,
because they are used by net-procfs.c too. However, a "make W=1" build
complains that there was no previous declaration of ptype_all and
ptype_base in a header file, so this way of declaring things constitutes
a violation of coding style.

Let's move the extern declarations of ptype_all and ptype_base to the
linux/netdevice.h file, which is included by net-procfs.c too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/netdevice.h | 3 +++
 net/core/net-procfs.c     | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8f003955c485..3f5e27e93972 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5318,6 +5318,9 @@ do {								\
 #define PTYPE_HASH_SIZE	(16)
 #define PTYPE_HASH_MASK	(PTYPE_HASH_SIZE - 1)
 
+extern struct list_head ptype_all __read_mostly;
+extern struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
+
 extern struct net_device *blackhole_netdev;
 
 #endif	/* _LINUX_NETDEVICE_H */
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index c714e6a9dad4..d8b9dbabd4a4 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -10,9 +10,6 @@
 #define get_offset(x) ((x) & ((1 << BUCKET_SPACE) - 1))
 #define set_bucket_offset(b, o) ((b) << BUCKET_SPACE | (o))
 
-extern struct list_head ptype_all __read_mostly;
-extern struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
-
 static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff_t *pos)
 {
 	struct net *net = seq_file_net(seq);
-- 
2.25.1

