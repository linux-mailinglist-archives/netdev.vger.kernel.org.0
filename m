Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6144219529A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgC0IKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:10:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:54964 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgC0IKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 04:10:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4DAF820561;
        Fri, 27 Mar 2020 09:10:14 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HQrLxZKkqPUo; Fri, 27 Mar 2020 09:10:13 +0100 (CET)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6510B20501;
        Fri, 27 Mar 2020 09:10:13 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 27 Mar
 2020 09:10:13 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1153A31800D2; Fri, 27 Mar 2020 09:10:13 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/8] xfrm: handle NETDEV_UNREGISTER for xfrm device
Date:   Fri, 27 Mar 2020 09:10:00 +0100
Message-ID: <20200327081007.1185-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327081007.1185-1-steffen.klassert@secunet.com>
References: <20200327081007.1185-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 cas-essen-01.secunet.de (10.53.40.201)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

This patch to handle the asynchronous unregister
device event so the device IPsec offload resources
could be cleanly released.

Fixes: e4db5b61c572 ("xfrm: policy: remove pcpu policy cache")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 50f567a88f45..3231ec628544 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -383,6 +383,7 @@ static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void
 		return xfrm_dev_feat_change(dev);
 
 	case NETDEV_DOWN:
+	case NETDEV_UNREGISTER:
 		return xfrm_dev_down(dev);
 	}
 	return NOTIFY_DONE;
-- 
2.17.1

