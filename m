Return-Path: <netdev+bounces-6660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA74717475
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ACED28136F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 03:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B820F1878;
	Wed, 31 May 2023 03:45:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB14F186B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 03:45:30 +0000 (UTC)
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22280EC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:45:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-53f7bef98b7so2984187a12.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685504728; x=1688096728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mWRStRzhjvxvXtPIyOg18FX2uAjXK3LmODKkFrfOfw0=;
        b=fPPupQpDJe/KmEnc2WnZF8g5GpmYFL7szIinLEYV32rvUtsaCDyhhmM6HS+5Vg8tAq
         Ju7LCyeMJgyyKq5XB/Rn13NFszVCnQwEFVEur0eXcG+4sUhRHce3QetMa3fyv7P1lv7z
         N+u1plwb+KEfc8mRjeNx98MhNSHTGvoxu2f/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685504728; x=1688096728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mWRStRzhjvxvXtPIyOg18FX2uAjXK3LmODKkFrfOfw0=;
        b=TWSre2mTAFvTg6dGviIS6pDGiEVqFkHTDpOQr7E/Zhh/JbYM+hnpc2q8RME4aPYCRe
         BTQpjB4GfZRfeL5WOrpwlaN4jx3QVLY54gZOd6uRzSb36EOtyywpg1cJAdN3DewTjkr3
         I/Y7xWmPQNcRUmmQ7fBPT8JivO1h/0pXH5Kl2XKNVnlkR6esgMRFfEs40XzRFwTTeEG0
         kBW7Tm/VYuJLCfnpqEMz0I1ZkyIbhvu0PAnGksvkAe2puPpRWY3LAGDp/vBGPgiLi6ZO
         NM+PEnuTnldQEYsoP8E40iinCj7FDZFw5DG1THNcIMLdkuGY6cbtl6vgIrCplhbclSrI
         kdAw==
X-Gm-Message-State: AC+VfDz1vJc0Vd5hCXTrrPKs8C+yq8AIqH6OaBnBB5xSH8PUNjG3J5+S
	ANn46qi+yg/LQktsN3Jf6g8MZA==
X-Google-Smtp-Source: ACHHUZ43/DN6lEy8Zrzn0r3E1bhpKKnF7A8bfa3e3OXdy+1nCr5lMGZ3vkOrHeG/LMfIYwjX5e1AQw==
X-Received: by 2002:a17:902:a508:b0:1b0:31a8:2f74 with SMTP id s8-20020a170902a50800b001b031a82f74mr3379208plq.68.1685504728555;
        Tue, 30 May 2023 20:45:28 -0700 (PDT)
Received: from localhost (21.160.199.104.bc.googleusercontent.com. [104.199.160.21])
        by smtp.gmail.com with UTF8SMTPSA id e7-20020a17090301c700b001b042e8ed77sm72787plh.281.2023.05.30.20.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 20:45:28 -0700 (PDT)
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
Subject: [PATCH v5] Bluetooth: Fix l2cap_disconnect_req deadlock
Date: Wed, 31 May 2023 03:44:56 +0000
Message-ID: <20230531034522.375889-1-yinghsu@chromium.org>
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
	autolearn=ham autolearn_force=no version=3.4.6
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

Changes in v5:
- Fixing the merge conflict by removing l2cap_del_chan_by_scid.

Changes in v4:
- Using l2cap_get_chan_by_scid to avoid repeated code.
- Releasing chan->lock before acquiring conn->chan_lock.

Changes in v3:
- Adding the fixes tag.

Changes in v2:
- Adding the prefix "Bluetooth:" to subject line.

 net/bluetooth/l2cap_core.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 036bc147f4de..16ac4aac0638 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4634,26 +4634,6 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
 	return err;
 }
 
-static struct l2cap_chan *l2cap_del_chan_by_scid(struct l2cap_conn *conn,
-						 u16 cid, int err)
-{
-	struct l2cap_chan *c;
-
-	mutex_lock(&conn->chan_lock);
-	c = __l2cap_get_chan_by_scid(conn, cid);
-	if (c) {
-		/* Only lock if chan reference is not 0 */
-		c = l2cap_chan_hold_unless_zero(c);
-		if (c) {
-			l2cap_chan_lock(c);
-			l2cap_chan_del(c, err);
-		}
-	}
-	mutex_unlock(&conn->chan_lock);
-
-	return c;
-}
-
 static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 				       struct l2cap_cmd_hdr *cmd, u16 cmd_len,
 				       u8 *data)
@@ -4671,7 +4651,7 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 
 	BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
 
-	chan = l2cap_del_chan_by_scid(conn, dcid, ECONNRESET);
+	chan = l2cap_get_chan_by_scid(conn, dcid);
 	if (!chan) {
 		cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
 		return 0;
@@ -4682,6 +4662,13 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_DISCONN_RSP, sizeof(rsp), &rsp);
 
 	chan->ops->set_shutdown(chan);
+
+	l2cap_chan_unlock(chan);
+	mutex_lock(&conn->chan_lock);
+	l2cap_chan_lock(chan);
+	l2cap_chan_del(chan, ECONNRESET);
+	mutex_unlock(&conn->chan_lock);
+
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
@@ -4706,7 +4693,7 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x", dcid, scid);
 
-	chan = l2cap_del_chan_by_scid(conn, scid, 0);
+	chan = l2cap_get_chan_by_scid(conn, scid);
 	if (!chan)
 		return 0;
 
@@ -4716,6 +4703,12 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 		return 0;
 	}
 
+	l2cap_chan_unlock(chan);
+	mutex_lock(&conn->chan_lock);
+	l2cap_chan_lock(chan);
+	l2cap_chan_del(chan, 0);
+	mutex_unlock(&conn->chan_lock);
+
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
-- 
2.41.0.rc0.172.g3f132b7071-goog


