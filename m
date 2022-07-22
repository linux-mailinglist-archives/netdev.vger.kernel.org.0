Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA0857E118
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiGVL47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234966AbiGVL45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:56:57 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CDC9D516
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:56:55 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id va17so8248399ejb.0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q/6C0hLMVNU55CHBk2mKAQizRq+SuLOg1CztoKY0K0w=;
        b=BEVYIA0lnjGN1trnUmc0Ud1yyrhMRF7BQCNGY1RZGWN2aF7yCiMNOW3Nn0X7V6OP8w
         G1nzBWscScxUURnwYrZrEs6o+haNY6jjbg+81D8L0NEtqxfKYf5K872HphS/EXDSdKUk
         p8I42JuSTAq8FDHTdMhRq9VMskh/l+4vJYz9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q/6C0hLMVNU55CHBk2mKAQizRq+SuLOg1CztoKY0K0w=;
        b=SliiMjTjo0/eIeoZyMEznZpkZPTEKR5K0D6xhO9EvdaEqogxcHmUvt3vBlg9IuL+1e
         Rcy5zLh6KpwhPB+MgS6T0kn/CysoU1zwh2OUOzyUcTmbvxfLBYIu2yjbmn/LetFYr445
         z2Wly/fHl9Bi1l0wyiwNgrmoknVmGX15VUmZFLtalfuC+rQK5ocjll+TIkR4eNqqWAu1
         O6w7FZt7Nt34/8OTHJ9bSXqYkDjwG6EEzhMMIzopMZzET3IdzD6Q+DpXVuAgH9aK8F1k
         TnqEyjtK25rXSdbEE7SgKaJ13zc9mYz41zCfdcfd4DVvlsH98ieVXwqlm/Jl2Gpff28A
         pY8Q==
X-Gm-Message-State: AJIora95kfzwqm9rwOLA8HdyER0rDWozqW0Nr6EihF0aOsm2HNC991hA
        ZP5R71mtloJluvd81r2iJQpLJA==
X-Google-Smtp-Source: AGRyM1uej07WP45uDK4ei4EmPhnABupcSWVKvAJ6snuX+mhlQSBrIveS1JVNXAIWbkE7EBLQ2EpEzA==
X-Received: by 2002:a17:907:d92:b0:72e:e968:7fa1 with SMTP id go18-20020a1709070d9200b0072ee9687fa1mr160432ejc.731.1658491014160;
        Fri, 22 Jul 2022 04:56:54 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id kx6-20020a170907774600b0072b3182368fsm1934370ejc.77.2022.07.22.04.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 04:56:53 -0700 (PDT)
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
Subject: [PATCH 3/6] brcmfmac: fix invalid address access when enabling SCAN log level
Date:   Fri, 22 Jul 2022 13:56:28 +0200
Message-Id: <20220722115632.620681-4-alvin@pqrs.dk>
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

The variable i is changed when setting random MAC address and causes
invalid address access when printing the value of pi->reqs[i]->reqid.

We replace reqs index with ri to fix the issue.

[  136.726473] Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000000
[  136.737365] Mem abort info:
[  136.740172]   ESR = 0x96000004
[  136.743359]   Exception class = DABT (current EL), IL = 32 bits
[  136.749294]   SET = 0, FnV = 0
[  136.752481]   EA = 0, S1PTW = 0
[  136.755635] Data abort info:
[  136.758514]   ISV = 0, ISS = 0x00000004
[  136.762487]   CM = 0, WnR = 0
[  136.765522] user pgtable: 4k pages, 48-bit VAs, pgdp = 000000005c4e2577
[  136.772265] [0000000000000000] pgd=0000000000000000
[  136.777160] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[  136.782732] Modules linked in: brcmfmac(O) brcmutil(O) cfg80211(O) compat(O)
[  136.789788] Process wificond (pid: 3175, stack limit = 0x00000000053048fb)
[  136.796664] CPU: 3 PID: 3175 Comm: wificond Tainted: G           O      4.19.42-00001-g531a5f5 #1
[  136.805532] Hardware name: Freescale i.MX8MQ EVK (DT)
[  136.810584] pstate: 60400005 (nZCv daif +PAN -UAO)
[  136.815429] pc : brcmf_pno_config_sched_scans+0x6cc/0xa80 [brcmfmac]
[  136.821811] lr : brcmf_pno_config_sched_scans+0x67c/0xa80 [brcmfmac]
[  136.828162] sp : ffff00000e9a3880
[  136.831475] x29: ffff00000e9a3890 x28: ffff800020543400
[  136.836786] x27: ffff8000b1008880 x26: ffff0000012bf6a0
[  136.842098] x25: ffff80002054345c x24: ffff800088d22400
[  136.847409] x23: ffff0000012bf638 x22: ffff0000012bf6d8
[  136.852721] x21: ffff8000aced8fc0 x20: ffff8000ac164400
[  136.858032] x19: ffff00000e9a3946 x18: 0000000000000000
[  136.863343] x17: 0000000000000000 x16: 0000000000000000
[  136.868655] x15: ffff0000093f3b37 x14: 0000000000000050
[  136.873966] x13: 0000000000003135 x12: 0000000000000000
[  136.879277] x11: 0000000000000000 x10: ffff000009a61888
[  136.884589] x9 : 000000000000000f x8 : 0000000000000008
[  136.889900] x7 : 303a32303d726464 x6 : ffff00000a1f957d
[  136.895211] x5 : 0000000000000000 x4 : ffff00000e9a3942
[  136.900523] x3 : 0000000000000000 x2 : ffff0000012cead8
[  136.905834] x1 : ffff0000012bf6d8 x0 : 0000000000000000
[  136.911146] Call trace:
[  136.913623]  brcmf_pno_config_sched_scans+0x6cc/0xa80 [brcmfmac]
[  136.919658]  brcmf_pno_start_sched_scan+0xa4/0x118 [brcmfmac]
[  136.925430]  brcmf_cfg80211_sched_scan_start+0x80/0xe0 [brcmfmac]
[  136.931636]  nl80211_start_sched_scan+0x140/0x308 [cfg80211]
[  136.937298]  genl_rcv_msg+0x358/0x3f4
[  136.940960]  netlink_rcv_skb+0xb4/0x118
[  136.944795]  genl_rcv+0x34/0x48
[  136.947935]  netlink_unicast+0x264/0x300
[  136.951856]  netlink_sendmsg+0x2e4/0x33c
[  136.955781]  __sys_sendto+0x120/0x19c

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index fabfbb0b40b0..d0a7465be586 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -158,12 +158,12 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, struct brcmf_pno_info *pi)
 	struct brcmf_pno_macaddr_le pfn_mac;
 	u8 *mac_addr = NULL;
 	u8 *mac_mask = NULL;
-	int err, i;
+	int err, i, ri;
 
-	for (i = 0; i < pi->n_reqs; i++)
-		if (pi->reqs[i]->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
-			mac_addr = pi->reqs[i]->mac_addr;
-			mac_mask = pi->reqs[i]->mac_addr_mask;
+	for (ri = 0; ri < pi->n_reqs; ri++)
+		if (pi->reqs[ri]->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+			mac_addr = pi->reqs[ri]->mac_addr;
+			mac_mask = pi->reqs[ri]->mac_addr_mask;
 			break;
 		}
 
@@ -185,7 +185,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, struct brcmf_pno_info *pi)
 	pfn_mac.mac[0] |= 0x02;
 
 	brcmf_dbg(SCAN, "enabling random mac: reqid=%llu mac=%pM\n",
-		  pi->reqs[i]->reqid, pfn_mac.mac);
+		  pi->reqs[ri]->reqid, pfn_mac.mac);
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_macaddr", &pfn_mac,
 				       sizeof(pfn_mac));
 	if (err)
-- 
2.37.0

