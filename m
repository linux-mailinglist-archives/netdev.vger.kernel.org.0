Return-Path: <netdev+bounces-5188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A167101E2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 02:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 445381C20E10
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 00:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771F518E;
	Thu, 25 May 2023 00:04:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0E3179
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:04:23 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5A1135
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:04:22 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1ae40139967so7898065ad.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684973062; x=1687565062;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JxmNnYgfaOtAwG3k7PZVh3xrHSOh7px0pgm2Rioiw6o=;
        b=Zj/fw8nmn6hoYdeGZf06QX+F1CudDEYVZTfIJKpBptP+hQz+AZfbDSs7kYyL9lhaFA
         FXHGJ5L0Q9h2//2gGs1HpTjxvAE6PdCxlUoHz/4QXOWjMeAV1rbvHhvbLPiIuJ1YeIFE
         KHbnV8A6PvqAovc8k8Ow1+C1zdzBh9oFFbirPuZQQHMW2/PFRTtpPSFlztSli9AdsFYw
         zWLU8dzks5nY9Ls9UASK0kWl0olJjSKCPycJ3LkGw2YTh+So7V7pSa/nWKz+gshuPSHB
         jn26lgjzx6kWOCz1yUE5C9ERczfnh3iquHaWH9PKXTkPEZVat7p0W/nI8FiQ1KjumdYd
         a1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684973062; x=1687565062;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JxmNnYgfaOtAwG3k7PZVh3xrHSOh7px0pgm2Rioiw6o=;
        b=Z555iTE+T1mIA/enwMQmNU84j+SQyuNdOkdBpEvghczXnSHhWn4jIsyl5D2gZd69KA
         3f8PJQvdhCVFoE0FyeFHjWth/p0tFDX3x85WfYNaPhxSwPYEgQuHZTZy+5tSwwjZyTcC
         ovw5XjJ07ZDN8SSJzUr1fh3ekt9i591VVQikBe1vBYrdCgP8Gdma1iizBPICnxjOMjya
         HxuSDCm/qA2/7i0EuxDdEPH7fPoA0Y3CbnXofC5TDWoes7pHRIoCOOcYT16QA/3VMRJU
         VKvgOWf8sXC99+E8Pj7ZEHHdOfTWM/WPMHTwqMBb0KlXTJzY8VWHh3K+PIsoDNrhjZ8p
         L0Mw==
X-Gm-Message-State: AC+VfDwnS4DPcXbAsbq53x1EqBmvVwLDt8/gEP7zVPgiFG2ZlbkRruvd
	TpmdNOo8vnW+QJeepWZV1fXqJGe215EW
X-Google-Smtp-Source: ACHHUZ6hpmN3QjzofQnR261iNpNAsxsI9fXdPsPI51ofRYxGfFB1NDraSuymfcJxH3lVr8U4UxXo3bTULABm
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a17:902:7587:b0:1ae:5f7e:c115 with SMTP id
 j7-20020a170902758700b001ae5f7ec115mr4392038pll.11.1684973061937; Wed, 24 May
 2023 17:04:21 -0700 (PDT)
Date: Wed, 24 May 2023 17:04:15 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230524170415.kernel.v1.1.I575ec21daa35ebba038fe38e164df60b6121c633@changeid>
Subject: [kernel PATCH v1] Bluetooth: L2CAP: Fix use-after-free
From: Zhengping Jiang <jiangzp@google.com>
To: linux-bluetooth@vger.kernel.org, marcel@holtmann.org, luiz.dentz@gmail.com
Cc: chromeos-bluetooth-upstreaming@chromium.org, 
	Zhengping Jiang <jiangzp@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Johan Hedberg <johan.hedberg@gmail.com>, Paolo Abeni <pabeni@redhat.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fix potential use-after-free in l2cap_le_command_rej.

Signed-off-by: Zhengping Jiang <jiangzp@google.com>
---

Changes in v1:
- Use l2cap_chan_hold_unless_zero to prevent adding refcnt when it is
  already 0.

 net/bluetooth/l2cap_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 376b523c7b26..19b0b1f7ffed 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6361,9 +6361,14 @@ static inline int l2cap_le_command_rej(struct l2cap_conn *conn,
 	if (!chan)
 		goto done;
 
+	chan = l2cap_chan_hold_unless_zero(chan);
+	if (!chan)
+		goto done;
+
 	l2cap_chan_lock(chan);
 	l2cap_chan_del(chan, ECONNREFUSED);
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 done:
 	mutex_unlock(&conn->chan_lock);
-- 
2.40.1.698.g37aff9b760-goog


