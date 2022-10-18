Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD33602117
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 04:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJRCV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 22:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJRCV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 22:21:57 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6FA8D0CB;
        Mon, 17 Oct 2022 19:21:48 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i6so12467917pli.12;
        Mon, 17 Oct 2022 19:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xQe6WDAOYHq4a+xfdiJbwfTzKRbnd4s6fpLl3pLZwHY=;
        b=V5hcJVkrAsENglV9EVi00qDhW6ik0sjdL0tWfmnBI0IlkBwsWfWxJGPli2xhRJIGlI
         bPeBEdW27XAsJW+Y7cTSLwK/Y2mraw7s9Vq1Ewzup49cXCzeZDPIK+3Ztg+JJk5vB2kK
         4JgB936N2XKc/fw4JFFh+zOj7Yx0syn2KQ7lq2waPuhywowqKjemRoiyH8u2/QyAsM1k
         dAA7zEeIAx4OQNTWMi0F8GsClmmNyJhE/UICuQoNXYBJdLxUHAsdVbAVBVtPgXzj8IBu
         Xozns9wxsChPOeO6y/NpZt0JcFCs537Veit/oXRK0Af2/BK59fJ5EMhVqmGYpxvIXQT0
         3Bcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xQe6WDAOYHq4a+xfdiJbwfTzKRbnd4s6fpLl3pLZwHY=;
        b=a6ZOCNu60jsAw3fsFzQz3y9Y1x49kKiJJxjKMvRA+dWyH+rOxiD4dd+nWr9EUTlciw
         /6R4VWhI5boEF9dfF4mgLjH1ZSb42oKCzRRWssqGvpiD9JYDRx38K143I4indKk6G3xb
         bIj9EygKKTmTuoHfmMCG9Xx1VWLrt3fC+Z8guHfOmXXM4FiCaRB5C4PgcKRNr35kVukh
         yQsCplZIewPeLSfUX+yU89Q1UAso2w7m+lAvA7KjXFceeoQVeCP8gy7qHkkSVi2eTKvk
         STqkZUmZ5pJLGkUNhY3j7EUHJZqKZfyenbZRQiw8l6XYg2BwTWFJ8g9WAwBCMA70cl2Q
         LfZA==
X-Gm-Message-State: ACrzQf1RGpSfkDUcVh2oCz2HE1Imojr6J/I1hdo6ick4r+3zYRrzdrUQ
        vuXzPa5Tpdy7wzpFqny1Abo=
X-Google-Smtp-Source: AMsMyM5nGoVqHZecaVai5tDSmuhi5LMeSC/3uKzGbl3iSmPz6klUuDKSctRlkoeQpd2jPYuB8JSEFg==
X-Received: by 2002:a17:90b:3b50:b0:20d:93f3:9c8d with SMTP id ot16-20020a17090b3b5000b0020d93f39c8dmr34106749pjb.150.1666059706442;
        Mon, 17 Oct 2022 19:21:46 -0700 (PDT)
Received: from localhost ([159.226.94.113])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b0017c37a5a2fdsm7303815plg.216.2022.10.17.19.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 19:21:45 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     18801353760@163.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.von.dentz@intel.com,
        netdev@vger.kernel.org,
        syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: [PATCH v2] Bluetooth: L2CAP: Fix memory leak in vhci_write
Date:   Tue, 18 Oct 2022 10:18:51 +0800
Message-Id: <20221018021851.2900-1-yin31149@gmail.com>
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

Yet the problem is that, HCI core may not free the skb after handling
ACL data packets. To be more specific, when start fragment does not
contain the L2CAP length, HCI core just copies skb into conn->rx_skb and
finishes frame process in l2cap_recv_acldata(), without freeing the skb,
which triggers the above memory leak.

This patch solves it by releasing the relative skb, after processing
the above case in l2cap_recv_acldata().
[Thanks Luiz Augusto von Dentz for his suggestion on using break]

Fixes: 4d7ea8ee90e4 ("Bluetooth: L2CAP: Fix handling fragmented length")
Link: https://lore.kernel.org/all/0000000000000d0b1905e6aaef64@google.com/
Reported-and-tested-by: syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
v2:
  - refactor the commit message on the problem description
  - refactor the goto drop with break, suggested by
Luiz Augusto von Dentz

v1:
  https://lore.kernel.org/all/20221017074432.12177-1-yin31149@gmail.com/

 net/bluetooth/l2cap_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1f34b82ca0ec..f0fb234c2e54 100644
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
+			break;
 		}
 
 		len = get_unaligned_le16(skb->data) + L2CAP_HDR_SIZE;
@@ -8472,7 +8471,7 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 
 			/* Header still could not be read just continue */
 			if (conn->rx_skb->len < L2CAP_LEN_SIZE)
-				return;
+				break;
 		}
 
 		if (skb->len > conn->rx_len) {
-- 
2.25.1

