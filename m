Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D64358B5B9
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 15:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiHFNgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 09:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiHFNgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 09:36:02 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4817F60FB;
        Sat,  6 Aug 2022 06:36:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 15-20020a17090a098f00b001f305b453feso10626544pjo.1;
        Sat, 06 Aug 2022 06:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:from:to:cc;
        bh=q//QPCFJ+lomTuvB83Pn/0/9ILoFCI64bQr/I2c0Ih8=;
        b=X06xJcWuc7XtjDkM+GIg09mA43NDQCaFGZqaz7dEl9oe7JGVXOSiuyNCldX7PL1w18
         bo1/Q0tyrxvVXIDdyGdRSo950yqpwWDBbB9pxEHDopF6umYdFKr5Eg6FgscWwhap/MkT
         wZvnLMmxJNcN5DTHxgFhDf+QARuyIXYH2cGR5PMb799+tdOl1/A1DbSOSelrGkaaoUiY
         AYXlJ9qX1+P4w7JMef7MP8HjPv1leEpaohl4tkCcjZbM+0MHxs/taDO9UtTMHrOeG6rm
         PdPN9+TAZrjn+Fun6XLCVW35U8d74PDY2HH+VB8R6uusIY4KQOd/rKQtOmSGpXCIO3mG
         ow+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:x-gm-message-state:from:to:cc;
        bh=q//QPCFJ+lomTuvB83Pn/0/9ILoFCI64bQr/I2c0Ih8=;
        b=7hr7GuH5QJzZRkv8XTrxhEQACnirWLDVLGfwLlyE0dWIqNH6rln9AwU/5tv3d09GyB
         mjpc3yOmCxq6LA3VBCQpQedsWy0eX7HascovpX9HApT9yDp+fBsQ99yr55Cd0CnJlBpi
         eEk4FarOG045ruzdoB9t1SvA/pzHfcLGfAE2iZpBFfW/WGzz/H/m11KaqJnR0bQULR31
         ewr2ykyoGwL2hTdG9U9Bwp9m5qHOrvRCkzNSSVjgfE0DerdZiIKPAUTcEHN3fqRPOdUp
         0HLRwi6g2xYVVkWI841thABN7P8VMU87oPtdChwKfWVjsMSg60NC3RLbL4XVObZBLrnx
         5sCw==
X-Gm-Message-State: ACgBeo1L2QQt4J+9j5sqJEkMgqinOp0RgzgIVD1ktreKBt5mCtWinLk4
        DrN9HeUVDfE2FCHIYoXtQU8=
X-Google-Smtp-Source: AA6agR4ZOlh71lA7ZC6N0opxCo1T2Q7kXeldIEQ9tBQ2L8U97SGnLbBUbCA34DhNmLSQsaCu4SpndQ==
X-Received: by 2002:a17:903:41c1:b0:16f:68c:28 with SMTP id u1-20020a17090341c100b0016f068c0028mr10950996ple.74.1659792960607;
        Sat, 06 Aug 2022 06:36:00 -0700 (PDT)
Received: from localhost (220-135-95-34.hinet-ip.hinet.net. [220.135.95.34])
        by smtp.gmail.com with ESMTPSA id h22-20020a63df56000000b0041cbcc1c222sm3102052pgj.41.2022.08.06.06.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 06:35:59 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
From:   AceLan Kao <acelan.kao@canonical.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dmitrii Tarakanov <Dmitrii.Tarakanov@aquantia.com>,
        Alexander Loktionov <Alexander.Loktionov@aquantia.com>,
        David VomLehn <vomlehn@texas.net>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: atlantic: fix aq_vec index out of range error
Date:   Sat,  6 Aug 2022 21:35:58 +0800
Message-Id: <20220806133558.3897444-1-acelan.kao@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>

The final update statement of the for loop exceeds the array range, the
dereference of self->aq_vec[i] is not checked and then leads to the
index out of range error.
Also fixed this kind of coding style in other for loop.

[   97.937604] UBSAN: array-index-out-of-bounds in drivers/net/ethernet/aquantia/atlantic/aq_nic.c:1404:48
[   97.937607] index 8 is out of range for type 'aq_vec_s *[8]'
[   97.937608] CPU: 38 PID: 3767 Comm: kworker/u256:18 Not tainted 5.19.0+ #2
[   97.937610] Hardware name: Dell Inc. Precision 7865 Tower/, BIOS 1.0.0 06/12/2022
[   97.937611] Workqueue: events_unbound async_run_entry_fn
[   97.937616] Call Trace:
[   97.937617]  <TASK>
[   97.937619]  dump_stack_lvl+0x49/0x63
[   97.937624]  dump_stack+0x10/0x16
[   97.937626]  ubsan_epilogue+0x9/0x3f
[   97.937627]  __ubsan_handle_out_of_bounds.cold+0x44/0x49
[   97.937629]  ? __scm_send+0x348/0x440
[   97.937632]  ? aq_vec_stop+0x72/0x80 [atlantic]
[   97.937639]  aq_nic_stop+0x1b6/0x1c0 [atlantic]
[   97.937644]  aq_suspend_common+0x88/0x90 [atlantic]
[   97.937648]  aq_pm_suspend_poweroff+0xe/0x20 [atlantic]
[   97.937653]  pci_pm_suspend+0x7e/0x1a0
[   97.937655]  ? pci_pm_suspend_noirq+0x2b0/0x2b0
[   97.937657]  dpm_run_callback+0x54/0x190
[   97.937660]  __device_suspend+0x14c/0x4d0
[   97.937661]  async_suspend+0x23/0x70
[   97.937663]  async_run_entry_fn+0x33/0x120
[   97.937664]  process_one_work+0x21f/0x3f0
[   97.937666]  worker_thread+0x4a/0x3c0
[   97.937668]  ? process_one_work+0x3f0/0x3f0
[   97.937669]  kthread+0xf0/0x120
[   97.937671]  ? kthread_complete_and_exit+0x20/0x20
[   97.937672]  ret_from_fork+0x22/0x30
[   97.937676]  </TASK>

v2. fixed "warning: variable 'aq_vec' set but not used"

Fixes: 97bde5c4f909 ("net: ethernet: aquantia: Support for NIC-specific code")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index e11cc29d3264..6986f0080072 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -265,12 +265,10 @@ static void aq_nic_service_timer_cb(struct timer_list *t)
 static void aq_nic_polling_timer_cb(struct timer_list *t)
 {
 	struct aq_nic_s *self = from_timer(self, t, polling_timer);
-	struct aq_vec_s *aq_vec = NULL;
 	unsigned int i = 0U;
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
-		aq_vec_isr(i, (void *)aq_vec);
+	for (i = 0U; self->aq_vecs > i; ++i)
+		aq_vec_isr(i, (void *)self->aq_vec[i]);
 
 	mod_timer(&self->polling_timer, jiffies +
 		  AQ_CFG_POLLING_TIMER_INTERVAL);
@@ -1065,10 +1063,11 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 
 	for (tc = 0U; tc < self->aq_nic_cfg.tcs; tc++) {
 		for (i = 0U, aq_vec = self->aq_vec[0];
-		     aq_vec && self->aq_vecs > i;
-		     ++i, aq_vec = self->aq_vec[i]) {
+		     aq_vec && self->aq_vecs > i; ++i) {
 			data += count;
 			count = aq_vec_get_sw_stats(aq_vec, tc, data);
+			if (self->aq_vecs > i)
+				aq_vec = self->aq_vec[i];
 		}
 	}
 
@@ -1382,7 +1381,6 @@ int aq_nic_set_loopback(struct aq_nic_s *self)
 
 int aq_nic_stop(struct aq_nic_s *self)
 {
-	struct aq_vec_s *aq_vec = NULL;
 	unsigned int i = 0U;
 
 	netif_tx_disable(self->ndev);
@@ -1400,9 +1398,8 @@ int aq_nic_stop(struct aq_nic_s *self)
 
 	aq_ptp_irq_free(self);
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
-		aq_vec_stop(aq_vec);
+	for (i = 0U; self->aq_vecs > i; ++i)
+		aq_vec_stop(self->aq_vec[i]);
 
 	aq_ptp_ring_stop(self);
 
-- 
2.25.1

