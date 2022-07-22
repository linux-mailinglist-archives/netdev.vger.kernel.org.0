Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E570057E117
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbiGVL5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiGVL4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:56:54 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788A6B5054
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:56:53 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r6so5531208edd.7
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ByHDj6/WZNLvf+U8I4CMzhK6/AcSzDl8NnQYMdbCHC0=;
        b=FSMwh2vz58WxOv5apuHGTlYbe8dQNKcB8eRfB22RfKdiB3t/ALd2FrPamvdCAh0gbW
         OQwuReunohVucJw3yYODEQzuMUfykVnM1DMctWhXxEwmPfXTgRhkb2h2lhnojwZ6i9YH
         1nCNf7qLZ4/MiX9uPvfYxBjXPafrojGA14pgY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ByHDj6/WZNLvf+U8I4CMzhK6/AcSzDl8NnQYMdbCHC0=;
        b=jyKSuU8LnH2rbA8UCTO9ULsXmLGs45Q+m9JV4tL4sCy6BUR9WuyHUTJCc4QQ1QhzWl
         Tvl0AMrDbtwi3HkbQcCwo9Hg16KhkLgLI37lQ4MUQZlgWHwg8RXT8LcWt6MjNeNgRF9/
         2B6d7XnCvXH0iETVoqtvr0KTJ1c/d976mnhG6wN397ImBaXYMEil/b8WqcRPN4CUL8L8
         IpXjNLYByCpZ2K2XRWiXI1W8zm/6LaGL/Q6owP/31iy9bRpo3uZx3f26UgPK1isZQUhR
         aQvp7lwzQq/+zQYZWzd/UYTlcjh6RYtW896PwLT11wmFVMrZoA7GbMsHpdzJz3pz/pKC
         bKpw==
X-Gm-Message-State: AJIora+EypyHVnNxTPe7Hm3V5Kj/WCkWyMiBnVUefgd83m9Dn/11WKs3
        owf5qCP0t1D3Usfz6scSIhZczA==
X-Google-Smtp-Source: AGRyM1vdGX0KozqUPHlKamS+jAQgi2PQ56UFeun3hPwIAEyV6QaNxCMTDCsIu960lsOqlMxNsia4dA==
X-Received: by 2002:a05:6402:444c:b0:43b:d375:e932 with SMTP id o12-20020a056402444c00b0043bd375e932mr226594edb.399.1658491011990;
        Fri, 22 Jul 2022 04:56:51 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id kx6-20020a170907774600b0072b3182368fsm1934370ejc.77.2022.07.22.04.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 04:56:51 -0700 (PDT)
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
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] brcmfmac: fix scheduling while atomic issue when deleting flowring
Date:   Fri, 22 Jul 2022 13:56:27 +0200
Message-Id: <20220722115632.620681-3-alvin@pqrs.dk>
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

We should not sleep while holding the spin lock. It makes
'scheduling while atomic' in brcmf_msgbuf_delete_flowring.
And to avoid race condition between deleting flowring and txflow,
we only hold spin lock when seting flowring status to RING_CLOSING.

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 .../broadcom/brcm80211/brcmfmac/flowring.c         |  5 +----
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 14 ++++++++------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
index 096f6b969dd8..e1127d7e086d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -419,7 +419,6 @@ void brcmf_flowring_configure_addr_mode(struct brcmf_flowring *flow, int ifidx,
 				flowid = flow->hash[i].flowid;
 				if (flow->rings[flowid]->status != RING_OPEN)
 					continue;
-				flow->rings[flowid]->status = RING_CLOSING;
 				brcmf_msgbuf_delete_flowring(drvr, flowid);
 			}
 		}
@@ -458,10 +457,8 @@ void brcmf_flowring_delete_peer(struct brcmf_flowring *flow, int ifidx,
 		if ((sta || (memcmp(hash[i].mac, peer, ETH_ALEN) == 0)) &&
 		    (hash[i].ifidx == ifidx)) {
 			flowid = flow->hash[i].flowid;
-			if (flow->rings[flowid]->status == RING_OPEN) {
-				flow->rings[flowid]->status = RING_CLOSING;
+			if (flow->rings[flowid]->status == RING_OPEN)
 				brcmf_msgbuf_delete_flowring(drvr, flowid);
-			}
 		}
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 174584b42972..cec53f934940 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1400,22 +1400,24 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
 	struct msgbuf_tx_flowring_delete_req *delete;
 	struct brcmf_commonring *commonring;
-	struct brcmf_commonring *commonring_del;
-
+	struct brcmf_commonring *commonring_del = msgbuf->flowrings[flowid];
+	struct brcmf_flowring *flow = msgbuf->flow;
 	void *ret_ptr;
 	u8 ifidx;
 	int err;
 	int retry = BRCMF_MAX_TXSTATUS_WAIT_RETRIES;
 
-	/* wait for commonring txflow finished */
-	commonring_del = msgbuf->flowrings[flowid];
+	/* make sure it is not in txflow */
 	brcmf_commonring_lock(commonring_del);
+	flow->rings[flowid]->status = RING_CLOSING;
+	brcmf_commonring_unlock(commonring_del);
+
+	/* wait for commonring txflow finished */
 	while (retry && atomic_read(&commonring_del->outstanding_tx)) {
 		usleep_range(5000, 10000);
 		retry--;
 	}
-	brcmf_commonring_unlock(commonring_del);
-	if (!retry && atomic_read(&commonring_del->outstanding_tx)) {
+	if (!retry) {
 		brcmf_err("timed out waiting for txstatus\n");
 		atomic_set(&commonring_del->outstanding_tx, 0);
 	}
-- 
2.37.0

