Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AC758A8DB
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 11:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbiHEJd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 05:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240378AbiHEJdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 05:33:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E310C78581;
        Fri,  5 Aug 2022 02:33:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so2281108pjf.2;
        Fri, 05 Aug 2022 02:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:from:to:cc;
        bh=syOoI0S6s55oEQL4111NxQUQp+X0D0zhYrVxWYym3Ds=;
        b=nVojK2a2zzpmQM2tU1adCpVvLBQKsuo6T2x1wfIJkzb/TGej4tmpp5hohYQnMQyZYK
         xd3qDC6VKPJuIOPY4LDW4OpC1P4qGQYLVVuXkWG7tLyq3A3chn3FdHv3LcgLnIu8Uc1W
         Lui08TWzZ0zUPITDaJ5KHq2EzegfK/W1N2dzVVwtRHLLrXAMAERrLzeIjGbYQ5k0/MI4
         R0S3uyTxqgNSNn+TTsY+EdpjNJec53+vQbSTtXKuVYDFux8hKI432FkxLl+Mu72VtUP3
         2O23wWvZH/lQNVKbLSIpOyh99hHzC6xZhxN8qIcHx6N/MbnVENmt4q6xL8Twb9zY4dbT
         Rzqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:x-gm-message-state:from:to:cc;
        bh=syOoI0S6s55oEQL4111NxQUQp+X0D0zhYrVxWYym3Ds=;
        b=nmLWCwmu77ZNYLx0YcPxB43sR4nTH0VjZ4RShBnUEgoACXeCzT4k9RbjrghqOuYQTr
         qL5YQudAfknHwr9eiBzMPkKw5Cp2gv/cSTu3lsf5x5OcARbgwj6yNYq+SXCluEZC7HFO
         Za6ga2TVEn1bZGKm/pi6oD8CbBwGuJquYqUvIlb+EmMfndSqVFf1sxCtIfRaJLm7UifX
         aq9hf37Jo4tPufibqaIgV8DEMl68HVnC3ZBpyci60Rf6rvfNWQck8AB5u2QLU5/86sRv
         mLBzH+aKzv0GKW1Lew84siXKgxd/+6XFMtHeY57P7M77h3p5D41+5/Ui7oAzgtYvTHfI
         8slg==
X-Gm-Message-State: ACgBeo3hYyuEuUHb2w4NrLl9dEI6jUXpwf7zS82N5xBZyUUz4JdR6ZWf
        7zpg27nAjiV4vj28JQtudEg=
X-Google-Smtp-Source: AA6agR7x/Y8Tl0BlI6uHNS4Z0TI5p0CfIqHYU5zZ1prE2XxxvJEYjxBJowocRgVP5XmmM/22j1JpYw==
X-Received: by 2002:a17:902:bb8f:b0:16a:80e7:e5d9 with SMTP id m15-20020a170902bb8f00b0016a80e7e5d9mr6057973pls.25.1659692002225;
        Fri, 05 Aug 2022 02:33:22 -0700 (PDT)
Received: from localhost (220-135-95-34.hinet-ip.hinet.net. [220.135.95.34])
        by smtp.gmail.com with ESMTPSA id o8-20020a17090a168800b001f24c08c3fesm5111978pja.1.2022.08.05.02.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 02:33:21 -0700 (PDT)
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
Subject: [PATCH] net: atlantic: fix aq_vec index out of range error
Date:   Fri,  5 Aug 2022 17:33:19 +0800
Message-Id: <20220805093319.3722179-1-acelan.kao@canonical.com>
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

Fixes: 97bde5c4f909 ("net: ethernet: aquantia: Support for NIC-specific code")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index e11cc29d3264..b0064b54d334 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -269,8 +269,8 @@ static void aq_nic_polling_timer_cb(struct timer_list *t)
 	unsigned int i = 0U;
 
 	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
-		aq_vec_isr(i, (void *)aq_vec);
+		self->aq_vecs > i; ++i)
+		aq_vec_isr(i, (void *)self->aq_vec[i]);
 
 	mod_timer(&self->polling_timer, jiffies +
 		  AQ_CFG_POLLING_TIMER_INTERVAL);
@@ -1065,10 +1065,9 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 
 	for (tc = 0U; tc < self->aq_nic_cfg.tcs; tc++) {
 		for (i = 0U, aq_vec = self->aq_vec[0];
-		     aq_vec && self->aq_vecs > i;
-		     ++i, aq_vec = self->aq_vec[i]) {
+		     aq_vec && self->aq_vecs > i; ++i) {
 			data += count;
-			count = aq_vec_get_sw_stats(aq_vec, tc, data);
+			count = aq_vec_get_sw_stats(self->aq_vec[i], tc, data);
 		}
 	}
 
@@ -1400,9 +1399,8 @@ int aq_nic_stop(struct aq_nic_s *self)
 
 	aq_ptp_irq_free(self);
 
-	for (i = 0U, aq_vec = self->aq_vec[0];
-		self->aq_vecs > i; ++i, aq_vec = self->aq_vec[i])
-		aq_vec_stop(aq_vec);
+	for (i = 0U, aq_vec = self->aq_vec[0]; self->aq_vecs > i; ++i)
+		aq_vec_stop(self->aq_vec[i]);
 
 	aq_ptp_ring_stop(self);
 
-- 
2.25.1

