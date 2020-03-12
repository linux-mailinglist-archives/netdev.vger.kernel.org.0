Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A24183BBA
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgCLVub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:50:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43804 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgCLVua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:50:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id f8so3197853plt.10
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A2Off5c+rsB6P7uz6QlRqvlE3h2U0BNift4nKlDQOuk=;
        b=kXYHkKm0SxZxqVc338w8k3R2m/tGjdWrIPIMO52zlA4S4dQ/P/vf6wAo07ybhn9Iye
         aHPeKp7aAHQxBgbnqpoVM3Ad5K73/mKAlBkiIEt/dofefRQQ6rOf6mRqKORKvNsql4HE
         u3bm3FoZPw0G2k+o0DZt0GmkvJzrZitSlU/1PL3DIqp766UvZS+7HQsbw4+hQVe5PczI
         psS6AyRq29ejD2bg780eZvBR8DXTt1OAVxKE7lQTcU/M0zGayA1Ngx0jH30gmve019BF
         9Dcykrdp8cM+r1/c/+v+cWsS+vJLmoeAkyB3E9RCM2fFNjWolJcwyjejLe+TaHY23LDP
         XfNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A2Off5c+rsB6P7uz6QlRqvlE3h2U0BNift4nKlDQOuk=;
        b=DysdT6PGGkVEH8DDXg8+TTkZZhyDGKWcSF2oS+z7IFy66Ve3G8pFvQIOri2h5sdvwN
         UdHOc7yQuEMkv+0mVJ2UPZgzV2We4nmslgbpwtTOLVw0myiBXQuQuVa/ltyZ/4q+L/D0
         3As3nedPe/ThT0TWM+igsvxVysk/3s2GNm0A5BZbqpxmmsNgC02SUMTWr4lVNRSJhxA4
         tNIFfZnXHIsu3+bop7x8iMsxE/zVc/aoCk2Gn4Q5jcHuzSlVpg7IYroNDv8rxxPbV1hj
         QLfcLUFIEvt6WGEcVSe5nLkYYT1R/B1E+hs2HnyJnwKAlEvdy1L8i4XH3rPyDC5KlZuy
         TKhw==
X-Gm-Message-State: ANhLgQ226RU5O5YAioWgrrAmBw4xtF0ri1xnvTqu7ZykvL/By+2t0WeM
        IxvSfu4f0Jz06su+RjYkS9EoestKVTA=
X-Google-Smtp-Source: ADFU+vvXSQftMbbQvs5dPFq8S9aeMHpr6uugaGGLhgcbclnhsVUyVbjtD22MopLzSvzKtIpabtZxDA==
X-Received: by 2002:a17:90b:1883:: with SMTP id mn3mr6141961pjb.147.1584049829075;
        Thu, 12 Mar 2020 14:50:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p2sm38281203pfb.41.2020.03.12.14.50.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 14:50:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/7] ionic: keep old lif dentry
Date:   Thu, 12 Mar 2020 14:50:10 -0700
Message-Id: <20200312215015.69547-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312215015.69547-1-snelson@pensando.io>
References: <20200312215015.69547-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't replace the lif->dentry until we know we have
a good new value.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index bc03cecf80cc..5f8fc58d42b3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -228,7 +228,13 @@ DEFINE_SHOW_ATTRIBUTE(netdev);
 
 void ionic_debugfs_add_lif(struct ionic_lif *lif)
 {
-	lif->dentry = debugfs_create_dir(lif->name, lif->ionic->dentry);
+	struct dentry *lif_dentry;
+
+	lif_dentry = debugfs_create_dir(lif->name, lif->ionic->dentry);
+	if (IS_ERR_OR_NULL(lif_dentry))
+		return;
+	lif->dentry = lif_dentry;
+
 	debugfs_create_file("netdev", 0400, lif->dentry,
 			    lif->netdev, &netdev_fops);
 }
-- 
2.17.1

