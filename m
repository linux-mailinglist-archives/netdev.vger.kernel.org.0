Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B64B186179
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgCPCOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:14:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38667 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbgCPCOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:14:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id x7so8821328pgh.5
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 19:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Efs90bMbd7QSQoPO39b+jNsz85imJEBsT/DmTEGo90c=;
        b=Qe+UuMsVLJoO/mk+2jmkPYQKb+s3ZAz9n6vwYqclyJmMlTRL2GrnJgJQ15djCUJ2oK
         2MqGqPwXNF24yD2nJjoY56RNGtOznZwNqxnP2tBhFzUSlMtVb4ahyqXtqKKWl8Taan2X
         6U9DyvtG998NSEECqiKDfzIPwCrYdCYhZj7F0ot877j3S5qMf1bZ9hvHRatwGKm8YXN7
         M5ueCdlJOJnHqEB1efyCMLHkqq0iW4ouQT3vR9N/HIQfYbxtniF/klzo8dcObnIhFgVc
         jvhwBKaIYMjdYGQ9laDlud1p9bZFaSomjtJggfYNNDxYlCMux5urn8bMEew371+U/n5s
         2n3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Efs90bMbd7QSQoPO39b+jNsz85imJEBsT/DmTEGo90c=;
        b=mYvAHXl1LH7A8G/AowMw38DTpsIf6JF0cAjlQs/5krMrDXcVtmfgi3BempR/i6Vdx6
         0DTcM9Y7XChJ5FTgTdGPvHldFnh+bbecF/vhLCxU/+8XlAvi8hMa939RGiS9qQQIhT1h
         RkQbnIjyM0RCUleHOgZYbCUW3C3txlIcIp67NeWcZhP91lfYAOsifztiiw1p9m9sQ4l5
         qPOsv1AoWxjt2oTsG/SqXBnGtxeZdo1Qk1yYec0PbSC3NMBsP9klKpKrEhUCQv6hBSRr
         xCjEGo+PfVIXYpAIBQTjJd9H9H1oT1pcHoTVfkY/H5+opquLSGvIoYus6uzgNOA821F4
         oDuw==
X-Gm-Message-State: ANhLgQ0cb9OV3BQYZvFvgduDLPe2/jXqeGGQlZz0oiH7FQ4amEJY6Jr+
        uOMZEGtDNND76vzRjjJnK3DRaxKK4iM=
X-Google-Smtp-Source: ADFU+vuNRUBj2lAe6lHPGqL3azj3qMPIW11UajJD89yedEc4hVfP9nbvoYecv9JYLBXZW1dQcl+zgw==
X-Received: by 2002:aa7:83d7:: with SMTP id j23mr24632199pfn.77.1584324879417;
        Sun, 15 Mar 2020 19:14:39 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p4sm4386142pfg.163.2020.03.15.19.14.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 19:14:39 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/5] ionic: remove adminq napi instance
Date:   Sun, 15 Mar 2020 19:14:26 -0700
Message-Id: <20200316021428.48919-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316021428.48919-1-snelson@pensando.io>
References: <20200316021428.48919-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the adminq's napi struct when tearing down
the adminq.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 19fd7cc36f28..12e3823b0bc1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2070,6 +2070,7 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 		ionic_lif_rss_deinit(lif);
 
 	napi_disable(&lif->adminqcq->napi);
+	netif_napi_del(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
-- 
2.17.1

