Return-Path: <netdev+bounces-6656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 517D57173D8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 04:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDA8F1C20E16
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16250A28;
	Wed, 31 May 2023 02:38:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0511BA21
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 02:38:39 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2091C113
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:38:38 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b021cddb74so27716365ad.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685500717; x=1688092717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tpH4t+aA6VmGuKwExaIddXhyI8sEcDcaGGPTHS+CPmI=;
        b=g5BFEFHPBgZ4qgHQ1gYDCA8l9KFVdQqB/fixZvBbGIxNlUbVNYI2tDO/GAU0pLDms6
         kLUAwWHzku0iuuHwSGQJLAqUALQDwfzADkSn72ivYxbkpbX0lrqCMKceR6AO2ZtRGerD
         V2WGNkUk/PD4flTllzlIP0O7+kdyqRkRlr1MQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685500717; x=1688092717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tpH4t+aA6VmGuKwExaIddXhyI8sEcDcaGGPTHS+CPmI=;
        b=H9Dpd/T/tWLwFZuK/lVS0C/IYFwQihc/RJMro4hrNbVULjeptYiW+I3VvSVZ1XS6Fk
         nZ0CU7n16JmvR8KoZFyFv4BeDmvFq5vIzuZZQ3qbA+lhNnObBnCoh/Y+XQjAjhEHcwvV
         WGgS+XUILMlYmjm0DF4In3BtHDGXU0ia0gmW9RJ8QrAYe/bQwtq1n5c3tErx8liAEaYg
         8c3lLLJWzC/HSMJdX5l6Jtc3JiGT+Hxuax8f1tXf5vD6UHCPN67XTpqbvUQyqD6ay4KG
         byfI4sT2xNr6Uh1y11xvaENevK6RDReGiqNTT2i5HB6bMOn773Wl3tSAqs3otVzTToom
         +x+Q==
X-Gm-Message-State: AC+VfDyZbvvyAjGR/HcN4sMTpbyqfKHPg63gwSasW/Ms3JguqskUWlnh
	2Agkot2mw8BBkxYEmHIUW/CyGA==
X-Google-Smtp-Source: ACHHUZ58y6ZyWusYdmqf7jZnAxuypZK1eJ3gue4OHftvOWO4wTa+IcaIZbkiiKzykQ4E+SpDPpwhIw==
X-Received: by 2002:a17:902:db11:b0:1ae:7421:82b8 with SMTP id m17-20020a170902db1100b001ae742182b8mr4572863plx.28.1685500717586;
        Tue, 30 May 2023 19:38:37 -0700 (PDT)
Received: from localhost (21.160.199.104.bc.googleusercontent.com. [104.199.160.21])
        by smtp.gmail.com with UTF8SMTPSA id jk15-20020a170903330f00b001b024ee5f6esm48397plb.81.2023.05.30.19.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 19:38:37 -0700 (PDT)
From: Ying Hsu <yinghsu@chromium.org>
To: linux-bluetooth@vger.kernel.org
Cc: chromeos-bluetooth-upstreaming@chromium.org,
	Ying Hsu <yinghsu@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v4] Bluetooth: Fix l2cap_disconnect_req deadlock
Date: Wed, 31 May 2023 02:38:16 +0000
Message-ID: <20230531023821.349759-1-yinghsu@chromium.org>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

L2CAP assumes that the locks conn->chan_lock and chan->lock are
acquired in the order conn->chan_lock, chan->lock to avoid
potential deadlock.
For example, l2sock_shutdown acquires these locks in the order:
  mutex_lock(&conn->chan_lock)
  l2cap_chan_lock(chan)

However, l2cap_disconnect_req acquires chan->lock in
l2cap_get_chan_by_scid first and then acquires conn->chan_lock
before calling l2cap_chan_del. This means that these locks are
acquired in unexpected order, which leads to potential deadlock:
  l2cap_chan_lock(c)
  mutex_lock(&conn->chan_lock)

This patch releases chan->lock before acquiring the conn_chan_lock
to avoid the potential deadlock.

Fixes: ("a2a9339e1c9d Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}")
Signed-off-by: Ying Hsu <yinghsu@chromium.org>
---
This commit has been tested on a Chromebook device.

Changes in v4:
- Using l2cap_get_chan_by_scid to avoid repeated code.
- Releasing chan->lock before acquiring conn->chan_lock.

Changes in v3:
- Adding the fixes tag.

Changes in v2:
- Adding the prefix "Bluetooth:" to subject line.

 net/bluetooth/l2cap_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 376b523c7b26..d9c4d26b2518 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4663,7 +4663,9 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 
 	chan->ops->set_shutdown(chan);
 
+	l2cap_chan_unlock(chan);
 	mutex_lock(&conn->chan_lock);
+	l2cap_chan_lock(chan);
 	l2cap_chan_del(chan, ECONNRESET);
 	mutex_unlock(&conn->chan_lock);
 
@@ -4702,7 +4704,9 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 		return 0;
 	}
 
+	l2cap_chan_unlock(chan);
 	mutex_lock(&conn->chan_lock);
+	l2cap_chan_lock(chan);
 	l2cap_chan_del(chan, 0);
 	mutex_unlock(&conn->chan_lock);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog


