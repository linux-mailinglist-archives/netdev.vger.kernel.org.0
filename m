Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4A22B3BAD
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 04:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgKPDGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 22:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgKPDGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 22:06:40 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ADDC0613CF
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 19:06:39 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h2so22443529wmm.0
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 19:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bd0Ob4V/NQkCfEN2z75zRdeE/kS4IC5OBhSFoRH60us=;
        b=oBR/DAJV/lZ/8M39wjP6nJfNuWdvHKUKx78hadBy9Rhw6CJAkZIYVE1UZLV1ma3z4X
         Ogk5v6/v6wvsoQ4yuZuPlPTV1ZmFdXMA90Ij3u6Tq4jnkE4JQcP72TqbDHk4IRgltGeX
         CDrSKLlJpBBEX74rHO1MwpmgERia5gUuxMMYLRrpdAUy/y8HGVkMn7TpSs5YchdZcDqz
         VP31DZx0Q5GOi4lfQ3wB/I0RL0nbn1ALg+gdJ2blh1z64qUaAdV8Mtvr6Pl92OnPF+0M
         ov1XPhjsS2vrXzKdUDn6/otoo10aynLK9qUmQGi+rnbMGHdlFrQtRQPhXg4FVr4LUmHT
         IDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bd0Ob4V/NQkCfEN2z75zRdeE/kS4IC5OBhSFoRH60us=;
        b=f4o6+oUo8vAzC+Qx6wS0dTRvTLBXMs7wmQ0BLu2+mj4JHSMjMQBugmvBAkV+yHD5tv
         h4Vv181EJTDOnRIx8Q0zN/lRd4wxG/LVFdA3f8lKnitDM+GeSMG8MI2gPYuLodQMOPuh
         r3LAaXcTaMq09amqfYOmIml1eNAvqQ9P9FAMAb7d0qQltDpNnCUo8t6d0EDSDV3SliQN
         rdfMq25Kbhs7yN5GRJyFbtgCGiAoaVcBgYmvqFmBGpnS1T79EJS5hlL1qALXKA/4GYRE
         RApQckBwvHU9AVNGYEI4rDK/9PEDF9kJgEirXhETEQH7/WQoqLqvxF8mBUSngDVP7FQt
         g8vw==
X-Gm-Message-State: AOAM530GZ+wtRBKdrIpYwc+W7qdzsyuh0zUV6XwHJnlNt4h/cBEh6/Gf
        71nhYGm/wJ4f6e+cPWIUVN6hiA==
X-Google-Smtp-Source: ABdhPJxADAl1cACgYEj1HoBk7AjlaDFs4ctgj5Wz5eV0LperjpBISLw343FlB8m6KMU4+hA+55ZKcA==
X-Received: by 2002:a1c:2c2:: with SMTP id 185mr13368393wmc.103.1605495998288;
        Sun, 15 Nov 2020 19:06:38 -0800 (PST)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id d10sm20637908wro.89.2020.11.15.19.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 19:06:37 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        Dmitry Safonov <dima@arista.com>,
        Yuji Nakao <contact@yujinakao.com>
Subject: [PATCH] brcmsmac: ampdu: Check BA window size before checking block ack
Date:   Mon, 16 Nov 2020 03:06:35 +0000
Message-Id: <20201116030635.645811-1-dima@arista.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bindex can be out of BA window (64):
  tid 0 seq 2983, start_seq 2915, bindex 68, index 39
  tid 0 seq 2984, start_seq 2915, bindex 69, index 40
  tid 0 seq 2985, start_seq 2915, bindex 70, index 41
  tid 0 seq 2986, start_seq 2915, bindex 71, index 42
  tid 0 seq 2879, start_seq 2915, bindex 4060, index 63
  tid 0 seq 2854, start_seq 2915, bindex 4035, index 38
  tid 0 seq 2795, start_seq 2915, bindex 3976, index 43
  tid 0 seq 2989, start_seq 2924, bindex 65, index 45
  tid 0 seq 2992, start_seq 2924, bindex 68, index 48
  tid 0 seq 2993, start_seq 2924, bindex 69, index 49
  tid 0 seq 2994, start_seq 2924, bindex 70, index 50
  tid 0 seq 2997, start_seq 2924, bindex 73, index 53
  tid 0 seq 2795, start_seq 2941, bindex 3950, index 43
  tid 0 seq 2921, start_seq 2941, bindex 4076, index 41
  tid 0 seq 2929, start_seq 2941, bindex 4084, index 49
  tid 0 seq 3011, start_seq 2946, bindex 65, index 3
  tid 0 seq 3012, start_seq 2946, bindex 66, index 4
  tid 0 seq 3013, start_seq 2946, bindex 67, index 5

In result isset() will try to dereference something on the stack,
causing panics:
  BUG: unable to handle page fault for address: ffffa742800ed01f
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 6a4e9067 P4D 6a4e9067 PUD 6a4ec067 PMD 6a4ed067 PTE 0
  Oops: 0000 [#1] PREEMPT SMP PTI
  CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Not tainted 5.8.5-arch1-1-kdump #1
  Hardware name: Apple Inc. MacBookAir3,1/Mac-942452F5819B1C1B, BIOS    MBA31.88Z.0061.B07.1201241641 01/24/12
  RIP: 0010:brcms_c_ampdu_dotxstatus+0x343/0x9f0 [brcmsmac]
  Code: 54 24 20 66 81 e2 ff 0f 41 83 e4 07 89 d1 0f b7 d2 66 c1 e9 03 0f b7 c9 4c 8d 5c 0c 48 49 8b 4d 10 48 8b 79 68 41 57 44 89 e1 <41> 0f b6 33 41 d3 e0 48 c7 c1 38 e0 ea c0 48 83 c7 10 44 21 c6 4c
  RSP: 0018:ffffa742800ecdd0 EFLAGS: 00010207
  RAX: 0000000000000019 RBX: 000000000000000b RCX: 0000000000000006
  RDX: 0000000000000ffe RSI: 0000000000000004 RDI: ffff8fc6ad776800
  RBP: ffff8fc6855acb00 R08: 0000000000000001 R09: 00000000000005d9
  R10: 00000000fffffffe R11: ffffa742800ed01f R12: 0000000000000006
  R13: ffff8fc68d75a000 R14: 00000000000005db R15: 0000000000000019
  FS:  0000000000000000(0000) GS:ffff8fc6aad00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffa742800ed01f CR3: 000000002480a000 CR4: 00000000000406e0
  Call Trace:
   <IRQ>
   brcms_c_dpc+0xb46/0x1020 [brcmsmac]
   ? wlc_intstatus+0xc8/0x180 [brcmsmac]
   ? __raise_softirq_irqoff+0x1a/0x80
   brcms_dpc+0x37/0xd0 [brcmsmac]
   tasklet_action_common.constprop.0+0x51/0xb0
   __do_softirq+0xff/0x340
   ? handle_level_irq+0x1a0/0x1a0
   asm_call_on_stack+0x12/0x20
   </IRQ>
   do_softirq_own_stack+0x5f/0x80
   irq_exit_rcu+0xcb/0x120
   common_interrupt+0xd1/0x200
   asm_common_interrupt+0x1e/0x40
  RIP: 0010:cpuidle_enter_state+0xb3/0x420

Check if the block is within BA window and only then check block's
status. Otherwise as Behan wrote: "When I came back to Dublin I
was courtmartialed in my absence and sentenced to death in my absence,
so I said they could shoot me in my absence."

Also reported:
https://bbs.archlinux.org/viewtopic.php?id=258428
https://lore.kernel.org/linux-wireless/87tuwgi92n.fsf@yujinakao.com/

Reported-by: Yuji Nakao <contact@yujinakao.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c  | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
index c9fb4b0cffaf..2631eb7569eb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
@@ -942,14 +942,19 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		index = TX_SEQ_TO_INDEX(seq);
 		ack_recd = false;
 		if (ba_recd) {
+			int block_acked;
+
 			bindex = MODSUB_POW2(seq, start_seq, SEQNUM_MAX);
+			if (bindex < AMPDU_TX_BA_MAX_WSIZE)
+				block_acked = isset(bitmap, bindex);
+			else
+				block_acked = 0;
 			brcms_dbg_ht(wlc->hw->d11core,
 				     "tid %d seq %d, start_seq %d, bindex %d set %d, index %d\n",
 				     tid, seq, start_seq, bindex,
-				     isset(bitmap, bindex), index);
+				     block_acked, index);
 			/* if acked then clear bit and free packet */
-			if ((bindex < AMPDU_TX_BA_MAX_WSIZE)
-			    && isset(bitmap, bindex)) {
+			if (block_acked) {
 				ini->txretry[index] = 0;
 
 				/*
-- 
2.29.2

