Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE51B399AE0
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhFCGg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 02:36:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhFCGg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 02:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622702114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ACjtTzNZ3zVUo+4rvX+NvPCzvI/Diwp1X17DZ793eaA=;
        b=Vy5bTQ9e+t2s9AgAz13Im3k1NZpSNjowbJqQGlRZ+Vu/v9Tz3VGwcDes6sTbtfBm0jYouR
        R2+/+lXIEv7lyepVxgIjPHsBziBPbQxosvAFTQLKDsza61TfTy44Pu/1BrjEBEeShwO+24
        aLU6ZdA2vnA5wX5dHW/qLSvV5iVUe1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-78daRXsXOeGsu0FPYaARXg-1; Thu, 03 Jun 2021 02:35:12 -0400
X-MC-Unique: 78daRXsXOeGsu0FPYaARXg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D4B1106BB37;
        Thu,  3 Jun 2021 06:35:11 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-165.ams2.redhat.com [10.36.112.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC6D75D74B;
        Thu,  3 Jun 2021 06:35:09 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivecera@redhat.com,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH 2/2] net:cxgb3: fix code style issues
Date:   Thu,  3 Jun 2021 08:34:30 +0200
Message-Id: <20210603063430.6613-2-ihuguet@redhat.com>
In-Reply-To: <20210603063430.6613-1-ihuguet@redhat.com>
References: <20210603063430.6613-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 84ad7261e243..57f210c53afc 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1273,14 +1273,14 @@ static int cxgb_up(struct adapter *adap)
 			free_irq(adap->msix_info[0].vec, adap);
 			goto irq_err;
 		}
-	} else if ((err = request_irq(adap->pdev->irq,
-				      t3_intr_handler(adap,
-						      adap->sge.qs[0].rspq.
-						      polling),
-				      (adap->flags & USING_MSI) ?
-				       0 : IRQF_SHARED,
-				      adap->name, adap)))
-		goto irq_err;
+	} else {
+		err = request_irq(adap->pdev->irq,
+				  t3_intr_handler(adap, adap->sge.qs[0].rspq.polling),
+				  (adap->flags & USING_MSI) ? 0 : IRQF_SHARED,
+				  adap->name, adap);
+		if (err)
+			goto irq_err;
+	}
 
 	enable_all_napi(adap);
 	t3_sge_start(adap);
@@ -3098,8 +3098,9 @@ static void set_nqsets(struct adapter *adap)
 			nqsets = num_cpus;
 		if (nqsets < 1 || hwports == 4)
 			nqsets = 1;
-	} else
+	} else {
 		nqsets = 1;
+	}
 
 	for_each_port(adap, i) {
 		struct port_info *pi = adap2pinfo(adap, i);
-- 
2.31.1

