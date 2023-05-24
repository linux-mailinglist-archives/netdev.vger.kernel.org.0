Return-Path: <netdev+bounces-4940-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 244CD70F4AC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF4B51C20B84
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604E4C8F0;
	Wed, 24 May 2023 11:01:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4909C1FB1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:01:34 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D9CC5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:01:30 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64d44b198baso529587b3a.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684926089; x=1687518089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MlhFitbDMZP7hCQbdHVoNuEXl+NL0ZynFialB8QGO0Y=;
        b=hqgqSp8p6fg7qL4ZjMoY2COLrFUlRYy/RquBeTwgV8wDs2/2TSNB26j/fWv3zOXz1X
         B1AA0Oxx4SdBTE7G6P9LvV/AqTgToRdvfvbRoTgOZ3yWookt66AdHwlaHtko7xK2wuf3
         wFWfcYUlYeGGbqA8boIcz3sCNzTzeId4Stvc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684926089; x=1687518089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MlhFitbDMZP7hCQbdHVoNuEXl+NL0ZynFialB8QGO0Y=;
        b=YQrPthwkt8fsms+I5UKGKA0kpaffBQzOzTN0kWMu0E1P8lttgzLluvok4GKML5hsIn
         pZk1fKVHOFzAvWMXbnI0YtJZOpN5gNbY5BOfYhzfvU1eGDdtgKpoyByWBDO5GDQBKfm/
         SnBzVRlPjB6nKijRmoxjDCL81WeSTUKwdaPUIWz11Reybr/79m+THysO/mln4MYJq3lC
         cFJy49BsKzkyBiIbIeVxWOjf22Ey2ZbkA93S5WFIui622W7MwdrZgw1PMHIjJEaX25yG
         cAEx+oA/h9Zm4uExqDePodFFPIYBBjgDo605zL69719NO8I2YSudjlHxq5c6EpRdHerm
         4lyw==
X-Gm-Message-State: AC+VfDzSy/Ou41yD9bVyY025k6iDuEMdWUNCvdpIF9Meo2A9WeJ496O7
	mZgoGbTDo9JiqEJO4KEGJ5byNA==
X-Google-Smtp-Source: ACHHUZ7TKWb9UWfZXWXmF+S12uaUUjdqdzck6N+WWHPWQssG+IjFKnbU1WolIUCxB0LT/ePGwioTIg==
X-Received: by 2002:a05:6a20:394e:b0:103:e813:77a1 with SMTP id r14-20020a056a20394e00b00103e81377a1mr21068407pzg.15.1684926088996;
        Wed, 24 May 2023 04:01:28 -0700 (PDT)
Received: from localhost (21.160.199.104.bc.googleusercontent.com. [104.199.160.21])
        by smtp.gmail.com with UTF8SMTPSA id 10-20020a63060a000000b00502fd70b0bdsm7627969pgg.52.2023.05.24.04.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 04:01:28 -0700 (PDT)
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
Subject: [PATCH v3] Bluetooth: Fix l2cap_disconnect_req deadlock
Date: Wed, 24 May 2023 11:00:00 +0000
Message-ID: <20230524110119.602679-1-yinghsu@chromium.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
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

This patch uses __l2cap_get_chan_by_scid to replace
l2cap_get_chan_by_scid and adjusts the locking order to avoid the
potential deadlock.

Fixes: ("a2a9339e1c9d Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}")
Signed-off-by: Ying Hsu <yinghsu@chromium.org>
---
This commit has been tested on a Chromebook device.

Changes in v3:
- Adding the fixes tag.

Changes in v2:
- Adding the prefix "Bluetooth:" to subject line.

 net/bluetooth/l2cap_core.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 376b523c7b26..7374e3d046da 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4651,8 +4651,15 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 
 	BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
 
-	chan = l2cap_get_chan_by_scid(conn, dcid);
+	mutex_lock(&conn->chan_lock);
+	chan = __l2cap_get_chan_by_scid(conn, dcid);
+	if (chan) {
+		chan = l2cap_chan_hold_unless_zero(chan);
+		if (chan)
+			l2cap_chan_lock(chan);
+	}
 	if (!chan) {
+		mutex_unlock(&conn->chan_lock);
 		cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
 		return 0;
 	}
@@ -4663,14 +4670,13 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 
 	chan->ops->set_shutdown(chan);
 
-	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, ECONNRESET);
-	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
+	mutex_unlock(&conn->chan_lock);
 
 	return 0;
 }
@@ -4691,25 +4697,32 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x", dcid, scid);
 
-	chan = l2cap_get_chan_by_scid(conn, scid);
+	mutex_lock(&conn->chan_lock);
+	chan = __l2cap_get_chan_by_scid(conn, scid);
+	if (chan) {
+		chan = l2cap_chan_hold_unless_zero(chan);
+		if (chan)
+			l2cap_chan_lock(chan);
+	}
 	if (!chan) {
+		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
 	if (chan->state != BT_DISCONN) {
 		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
+		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
-	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, 0);
-	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
+	mutex_unlock(&conn->chan_lock);
 
 	return 0;
 }
-- 
2.40.1.698.g37aff9b760-goog


