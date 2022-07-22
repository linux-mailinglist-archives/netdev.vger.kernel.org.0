Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EF557E108
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbiGVL45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiGVL4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:56:54 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB949D525
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:56:51 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u12so537257edd.5
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sfJUu7YZvL2g6twgjpnle5UI1onmUJrVs9Bpz3S5FYc=;
        b=a/t5NXgblmEZvwDxJtbKMOHWIKIUzapVoC99aGhYw62vKNQwYr4NY31RzsQSeqyD8D
         IzHdYKfuLcMwGch+03d8fDOtaIf2+q1jmpsrJpiXnxcuLg+2296EziHOIKR/4W63mUhU
         otDP3qwJ5QLtaAnqiw2t7sJsKMp7T53cJfmzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sfJUu7YZvL2g6twgjpnle5UI1onmUJrVs9Bpz3S5FYc=;
        b=wMzexI5WTiFkI2MdNGbx24UQzFQ1S++Wk1pCiWl3VlxrP1z6/oh1zECJn/LBcSKkhU
         DRPlkh6ESLHwRzUKPy4d/KoxespRLuEoLClVy+hXddH5xv2r3+W7YrBTXneq52ZQf1aQ
         YQ51gl4k/a8zTfvbQZhofMUhOtI3MuEwgpJyddbSrPlJUhXV3NJcqYm0E2TKhjzuZNmL
         LZV2m7qHRnBtLxHErCfu1/JpDLY7Gv1lcRVy+1MOmTuei95yoCd0ThBOAjjz5KRmh25F
         3lVL35s6gt0atFij9l/ucvnELv5COF+IAmshgUTu0o1B3TkcEgBfddoIabjB3amNv6OL
         kiUw==
X-Gm-Message-State: AJIora8OAP4i9KXTbBiRvrYHEvkLvX4RJOj09JD74VmJrLvt2TyestZh
        lLadkspTwlcsWEV7K6uTof027w==
X-Google-Smtp-Source: AGRyM1vWDrGN9LZIzRynXR7EHhhtZ1o+0jbyaoh2maJYcYi6kAJuctrUKwkKKcU6r/5iaFjBTBkPSQ==
X-Received: by 2002:a05:6402:278e:b0:43a:9cf5:6608 with SMTP id b14-20020a056402278e00b0043a9cf56608mr298484ede.76.1658491009835;
        Fri, 22 Jul 2022 04:56:49 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id kx6-20020a170907774600b0072b3182368fsm1934370ejc.77.2022.07.22.04.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 04:56:49 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] brcmfmac: fix continuous 802.1x tx pending timeout error
Date:   Fri, 22 Jul 2022 13:56:26 +0200
Message-Id: <20220722115632.620681-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220722115632.620681-1-alvin@pqrs.dk>
References: <20220722115632.620681-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

The race condition in brcmf_msgbuf_txflow and brcmf_msgbuf_delete_flowring
makes tx_msghdr writing after brcmf_msgbuf_remove_flowring. Host
driver should delete flowring after txflow complete and all txstatus back,
or pend_8021x_cnt will never be zero and cause every connection 950
milliseconds(MAX_WAIT_FOR_8021X_TX) delay.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 .../broadcom/brcm80211/brcmfmac/core.c        |  4 +++-
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 23 ++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 87aef211b35f..8ca259ace001 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1484,8 +1484,10 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 				 !brcmf_get_pend_8021x_cnt(ifp),
 				 MAX_WAIT_FOR_8021X_TX);
 
-	if (!err)
+	if (!err) {
 		bphy_err(drvr, "Timed out waiting for no pending 802.1x packets\n");
+		atomic_set(&ifp->pend_8021x_cnt, 0);
+	}
 
 	return !err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index b2d0f7570aa9..174584b42972 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -71,6 +71,7 @@
 #define BRCMF_MSGBUF_TRICKLE_TXWORKER_THRS	32
 #define BRCMF_MSGBUF_UPDATE_RX_PTR_THRS		48
 
+#define BRCMF_MAX_TXSTATUS_WAIT_RETRIES		10
 
 struct msgbuf_common_hdr {
 	u8				msgtype;
@@ -806,8 +807,12 @@ static int brcmf_msgbuf_tx_queue_data(struct brcmf_pub *drvr, int ifidx,
 	flowid = brcmf_flowring_lookup(flow, eh->h_dest, skb->priority, ifidx);
 	if (flowid == BRCMF_FLOWRING_INVALID_ID) {
 		flowid = brcmf_msgbuf_flowring_create(msgbuf, ifidx, skb);
-		if (flowid == BRCMF_FLOWRING_INVALID_ID)
+		if (flowid == BRCMF_FLOWRING_INVALID_ID) {
 			return -ENOMEM;
+		} else {
+			brcmf_flowring_enqueue(flow, flowid, skb);
+			return 0;
+		}
 	}
 	queue_count = brcmf_flowring_enqueue(flow, flowid, skb);
 	force = ((queue_count % BRCMF_MSGBUF_TRICKLE_TXWORKER_THRS) == 0);
@@ -1395,9 +1400,25 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
 	struct msgbuf_tx_flowring_delete_req *delete;
 	struct brcmf_commonring *commonring;
+	struct brcmf_commonring *commonring_del;
+
 	void *ret_ptr;
 	u8 ifidx;
 	int err;
+	int retry = BRCMF_MAX_TXSTATUS_WAIT_RETRIES;
+
+	/* wait for commonring txflow finished */
+	commonring_del = msgbuf->flowrings[flowid];
+	brcmf_commonring_lock(commonring_del);
+	while (retry && atomic_read(&commonring_del->outstanding_tx)) {
+		usleep_range(5000, 10000);
+		retry--;
+	}
+	brcmf_commonring_unlock(commonring_del);
+	if (!retry && atomic_read(&commonring_del->outstanding_tx)) {
+		brcmf_err("timed out waiting for txstatus\n");
+		atomic_set(&commonring_del->outstanding_tx, 0);
+	}
 
 	/* no need to submit if firmware can not be reached */
 	if (drvr->bus_if->state != BRCMF_BUS_UP) {
-- 
2.37.0

