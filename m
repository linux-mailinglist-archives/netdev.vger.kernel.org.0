Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D374187359
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 20:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbgCPTbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 15:31:47 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53139 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732452AbgCPTbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 15:31:46 -0400
Received: by mail-pj1-f67.google.com with SMTP id ng8so1870153pjb.2
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 12:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Kh1lVmiW2UcsTpytBjVKvk3IZRJxfjUMW30Es8ZGulU=;
        b=WqHJKVFal0QLZxwle7QMsXEB+yMMblzsrjxBGRtjhMG1jmwJ0wcO/mgK7ogWOVMe36
         qYjQp4irWMnupt9cfVHD/0l2yrfi8w6BQnwf1yG8w83PBwGkm94uc0sTJJxMBZHrxaST
         cW8HIxI/LLfBprSR2EbzUgDFhf+FEBCTCqzlYuCsfTtYgWiP1A5trP+Czb5myo+33J9n
         1ah58+hTuC+m5wNNol85GFgkfGZnJotqnyzzCq7GTtzO+DQqpVBflCm/z+B6/4urPIM8
         qlhcIqxey7x3qMro5bwQtKWEQyptpfqNwu9Z7qC3P+zOs3xRgi3vCftDZi1fy1e4sn3g
         q2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Kh1lVmiW2UcsTpytBjVKvk3IZRJxfjUMW30Es8ZGulU=;
        b=Kr8hD/reDCcg7AeIrnLh2KtWy9xEgblb3GSUyczJOpPEL8yoYi863YD5SesHkP1PRN
         HicvF+WKVw6qapICSjUznmxU7t6lLgHD3+JqKvdaJaU3Wp5XQ/1LvKK0r108vB1CFQjx
         Qq8ldRqcokXvExtqHbgYjP9lOL9z5qwGMzDKvn/UmMOwZPfcHwqnWyWrS3scNpAmEan2
         6qeQ2YLPlr/OWLg4gLnu/LeW3iseoJ1psJJIStg4P0/wLstycYoRdXLqNrBso2MKZHre
         aWn8OK364SfhM9AhGtaKHIfKsaebhJWuUNCxaQHtfjgPi0+nc8JTSGuLuc0lk92d94pQ
         mGXw==
X-Gm-Message-State: ANhLgQ1Z4bcfIhLEMjxevg4fQswZSYSGvsSCqJrbish7Ngyd+c9SoWwY
        LxWuDH2v17EfwU2GmuZc+QxxlT7ycDs=
X-Google-Smtp-Source: ADFU+vvHQYW3tkkkH0MjoN7ym7qmQORvClA2kZTGeLnEk4aYJR/iTLyBFsbyuZUiaSzzW+racMASpg==
X-Received: by 2002:a17:90a:33e5:: with SMTP id n92mr1115871pjb.39.1584387105741;
        Mon, 16 Mar 2020 12:31:45 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w17sm656413pfi.59.2020.03.16.12.31.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:31:45 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/5] ionic: remove adminq napi instance
Date:   Mon, 16 Mar 2020 12:31:32 -0700
Message-Id: <20200316193134.56820-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316193134.56820-1-snelson@pensando.io>
References: <20200316193134.56820-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the adminq's napi struct when tearing down
the adminq.

Fixes: 1d062b7b6f64 ("ionic: Add basic adminq support")
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

