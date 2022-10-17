Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F580600800
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 09:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJQHrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 03:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiJQHrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 03:47:06 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9D4193ED;
        Mon, 17 Oct 2022 00:47:05 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b2so10042477plc.7;
        Mon, 17 Oct 2022 00:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=trKg4e+84RTL7802i/2COWxZYFL5an0MughGIKzB3gg=;
        b=Is2mRJ7WSElkiPaw7WGMnu+OPee+ZjTYdAH4JarFZZh1AxUymwfPScZLlDfCz5dGuy
         26qCclC9g8JIZm/9bx09Qpi+2oc+RbGD6VMaw6L929D21P3l8NHSNAfTk5iyU9YjiVyg
         9I4QgP0ovmueLtZ16Zdc2R5qMxewrGwAss1j4d3LN6vq+x4l8paLAFvE5xrf69kriikl
         ThodotI7uheTcjnF4p+QwkKeduT47F6OI9JI3+jg4IrQH9x3RSOCB//O5MTQHLzM21Ta
         ZRq6/Vh3aNXb5/wkotpwkO4xPDuTrCxDrbLwFcIG8yucLOifuDv/XAAvtgU/FYFGVvoH
         xLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=trKg4e+84RTL7802i/2COWxZYFL5an0MughGIKzB3gg=;
        b=ooMCf+70Nac0QIsSaOZP5AuAkPCTEKW5zg6yh6NzpGqR8Qn+bnBOgUaqpipW5JWN1S
         r0Nlm7z4d45p/ofyBkDxzUN9iOlqB9/tVqNlsWFDh5BC+e/cVHCxAFyAe3aMWM26mDB4
         5jKJQgJu53QgRqihgOqnxTb9ep00JG0dfmdWvaDbc77Mnn0KxTreOXe7ekLTES7el9U8
         WX8ed8KSCG3+CqfDX4Ysh5ejmQMRw3ZtiYB+jp3nxBJBp6MJUWc0ju+fiLU5JMsvieov
         UNS6UyaxpUX+QFjDdlyZ9NTEzaycPHchvOtcwtxXz287hCkFyh69s1yyyoivKoH/bFfj
         PXyg==
X-Gm-Message-State: ACrzQf0CqQ5B7XhnAXSFPdcNaHvLD7mxyDCeWvEMLrkQdKppBOJrUUA8
        3ct3UQnPXOSbDZv1NeQGxw0=
X-Google-Smtp-Source: AMsMyM6FsMPVoOIGj/GIWy3kAd5GCtJpbj51sd6eQQHcKxTz9sAYFb6w7o8+2MgwT3QJ7GDaMYOgHA==
X-Received: by 2002:a17:90b:1b51:b0:20d:8594:bd5f with SMTP id nv17-20020a17090b1b5100b0020d8594bd5fmr31118093pjb.125.1665992824904;
        Mon, 17 Oct 2022 00:47:04 -0700 (PDT)
Received: from localhost ([159.226.94.113])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090332c600b001806f4fbf25sm5945229plr.182.2022.10.17.00.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 00:47:04 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, 18801353760@163.com,
        yin31149@gmail.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH] Bluetooth: L2CAP: Fix memory leak in vhci_write
Date:   Mon, 17 Oct 2022 15:44:32 +0800
Message-Id: <20221017074432.12177-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports a memory leak as follows:
====================================
BUG: memory leak
unreferenced object 0xffff88810d81ac00 (size 240):
  [...]
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff838733d9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:418
    [<ffffffff833f742f>] alloc_skb include/linux/skbuff.h:1257 [inline]
    [<ffffffff833f742f>] bt_skb_alloc include/net/bluetooth/bluetooth.h:469 [inline]
    [<ffffffff833f742f>] vhci_get_user drivers/bluetooth/hci_vhci.c:391 [inline]
    [<ffffffff833f742f>] vhci_write+0x5f/0x230 drivers/bluetooth/hci_vhci.c:511
    [<ffffffff815e398d>] call_write_iter include/linux/fs.h:2192 [inline]
    [<ffffffff815e398d>] new_sync_write fs/read_write.c:491 [inline]
    [<ffffffff815e398d>] vfs_write+0x42d/0x540 fs/read_write.c:578
    [<ffffffff815e3cdd>] ksys_write+0x9d/0x160 fs/read_write.c:631
    [<ffffffff845e0645>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845e0645>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
====================================

HCI core will uses hci_rx_work() to process frame, which is queued to
the hdev->rx_q tail in hci_recv_frame() by HCI driver.

Yet the problem is that, HCI core does not free the skb after handling
ACL data packets. To be more specific, when start fragment does not
contain the L2CAP length, HCI core just reads possible bytes and
finishes frame process in l2cap_recv_acldata(), without freeing the skb,
which triggers the above memory leak.

This patch solves it by releasing the relative skb, after processing the
above case in l2cap_recv_acldata()

Fixes: 4d7ea8ee90e4 ("Bluetooth: L2CAP: Fix handling fragmented length")
Link: https://lore.kernel.org/all/0000000000000d0b1905e6aaef64@google.com/
Reported-and-tested-by: syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
 net/bluetooth/l2cap_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1f34b82ca0ec..e0a00854c02e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -8426,9 +8426,8 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		 * expected length.
 		 */
 		if (skb->len < L2CAP_LEN_SIZE) {
-			if (l2cap_recv_frag(conn, skb, conn->mtu) < 0)
-				goto drop;
-			return;
+			l2cap_recv_frag(conn, skb, conn->mtu);
+			goto drop;
 		}
 
 		len = get_unaligned_le16(skb->data) + L2CAP_HDR_SIZE;
@@ -8472,7 +8471,7 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 
 			/* Header still could not be read just continue */
 			if (conn->rx_skb->len < L2CAP_LEN_SIZE)
-				return;
+				goto drop;
 		}
 
 		if (skb->len > conn->rx_len) {
-- 
2.25.1

