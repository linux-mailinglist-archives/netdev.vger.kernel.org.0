Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E1542C6C5
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhJMQxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:53:50 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:49086
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237399AbhJMQxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:53:49 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id F11133FFDC;
        Wed, 13 Oct 2021 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634143903;
        bh=nspxtz40p65DZu4TYJBabtEkFf22gqNZfGTLya7Yrd8=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=jHQ+xQpZT3ySNZvfc7Mv2IO5uEBq9duWF1MlPWpGZvYeJHiVcz9A7rRAAkuRwsAWD
         L0aC8QkbNLM/Ovd66WAmrejidVQGrzhN/CM3WyfiuZ67P2/G4AsejdKw/iNfhdcvLf
         r8uEJeG5anV0ARNJ+4MVgIKMi6VYnOWCUlnwC6OShxeUQqiw8abRiFgcNeSpyHUHCF
         a0MLlhJasei7LHS5hQPlNdEOtLCQ/Fpytil4ruNAnNd2LOKPm8bLRwLRwztOhSb6zl
         7fo6dG70HRDukksIb7Qk8FDlv02QO//kgN80AcJNgMvrord248FTEehqNUeiLyynrG
         vcou6qPyVlE6A==
From:   Colin King <colin.king@canonical.com>
To:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xen-netback: Remove redundant initialization of variable err
Date:   Wed, 13 Oct 2021 17:51:42 +0100
Message-Id: <20211013165142.135795-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initialized with a value that is never read, it
is being updated immediately afterwards. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 32d5bc4919d8..0f7fd159f0f2 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1474,7 +1474,7 @@ int xenvif_map_frontend_data_rings(struct xenvif_queue *queue,
 	struct xen_netif_tx_sring *txs;
 	struct xen_netif_rx_sring *rxs;
 	RING_IDX rsp_prod, req_prod;
-	int err = -ENOMEM;
+	int err;
 
 	err = xenbus_map_ring_valloc(xenvif_to_xenbus_device(queue->vif),
 				     &tx_ring_ref, 1, &addr);
-- 
2.32.0

