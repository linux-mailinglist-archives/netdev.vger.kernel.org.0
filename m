Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553D53D883E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbhG1GuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:50:18 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:53992
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234931AbhG1Gt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:49:59 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id ADE813FE72
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 06:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627454970;
        bh=u5wymAXnL9yVxfEB09vbeM1W+wc1wAMvpQhdfXWNsKY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=s3Ukw21GfqNsxMk28D5IJJIRPYjOv+ns2lswxnPVNXGU+5TNaZ1frTPRNSG6qK5BL
         vft1IJW8tcvwY+v6dFOgNRyUCnjLbXTgKGtFOdmbuUGVslCgptAfM45Eo5NBK8Dmbm
         qaD7UlJvcNFiRxojM59koxMp7WnCtP+cetCdML5Czo1po7xKZrRwKGdvX/At8YFwPO
         I0QdCcC6yEPnCs0kAvMHPTMFtqIKxQTFBZlvtM13y+aUxNQd2VuEgf3knidyaJuZTz
         HTe1GkEkvbdWN8GVSx8P2jtjmlfmo3A1X1d2/fmKn0+cIvSaZypO/vFADWyzJcilYL
         AiYIJTT09SLAA==
Received: by mail-ed1-f72.google.com with SMTP id p2-20020a50c9420000b02903a12bbba1ebso767507edh.6
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 23:49:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u5wymAXnL9yVxfEB09vbeM1W+wc1wAMvpQhdfXWNsKY=;
        b=IPkVQ2/fuUyBKATliQZlngMwx6RHp+Psd28aWMB5qNJkBrBhsqF63cdqau4wRxCeE6
         WLCVnqRam/BQkrgYwLK3lB/PdH7BSOTTkI96B0WmSDihbVgMW76w3HKPet65r4P87I3Y
         iy38YK/zgmVeIpNyg+s7vE0KV2Vq9P4miMQndbLvCwNQxqDqCeIeOj/GabsKztFMgJj6
         /qyGRN0MKVivWoSHXfgtJri0fiLLfsZUz6O4ulgTdKut6My3RwUxCAcViWWevJzKL/uR
         mSXol9O9Oj5McbppD1iwUzUrslF8eEpTnXnuiCMkj5LJ9Wz3GF+O2qwdUORkpoeDOlur
         ULKA==
X-Gm-Message-State: AOAM532tJ9OEYcBNg6pjm8JyZEZ+2U2biJpsSpmpBd3HCF4KAMMAzPs5
        fbhGLTw+zNfWDehmWlUJW6AR66oD9+OpkCEuCVQM6PVLgW5NQhGq1If5NPqnnAZDNr9XQzqT7Ho
        cPzuzVxlaqNTKKzuG4GnzwzZXeDQDd6IrCQ==
X-Received: by 2002:a17:907:629c:: with SMTP id nd28mr1086455ejc.403.1627454970421;
        Tue, 27 Jul 2021 23:49:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhwIxdK1rvmb+nHkDvXvuiqJxTKKPsvzlRGw4p6rWIs3aTz86BmAFyhMDLaycvEfVzWlJzWg==
X-Received: by 2002:a17:907:629c:: with SMTP id nd28mr1086441ejc.403.1627454970296;
        Tue, 27 Jul 2021 23:49:30 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id qt10sm1656394ejb.110.2021.07.27.23.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 23:49:29 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] nfc: nfcsim: fix use after free during module unload
Date:   Wed, 28 Jul 2021 08:49:09 +0200
Message-Id: <20210728064909.5356-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a use after free memory corruption during module exit:
 - nfcsim_exit()
  - nfcsim_device_free(dev0)
    - nfc_digital_unregister_device()
      This iterates over command queue and frees all commands,
    - dev->up = false
    - nfcsim_link_shutdown()
      - nfcsim_link_recv_wake()
        This wakes the sleeping thread nfcsim_link_recv_skb().

 - nfcsim_link_recv_skb()
   Wake from wait_event_interruptible_timeout(),
   call directly the deb->cb callback even though (dev->up == false),
   - digital_send_cmd_complete()
     Dereference of "struct digital_cmd" cmd which was freed earlier by
     nfc_digital_unregister_device().

This causes memory corruption shortly after (with unrelated stack
trace):

  nfc nfc0: NFC: nfcsim_recv_wq: Device is down
  llcp: nfc_llcp_recv: err -19
  nfc nfc1: NFC: nfcsim_recv_wq: Device is down
  BUG: unable to handle page fault for address: ffffffffffffffed
  Call Trace:
   fsnotify+0x54b/0x5c0
   __fsnotify_parent+0x1fe/0x300
   ? vfs_write+0x27c/0x390
   vfs_write+0x27c/0x390
   ksys_write+0x63/0xe0
   do_syscall_64+0x3b/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

KASAN report:

  BUG: KASAN: use-after-free in digital_send_cmd_complete+0x16/0x50
  Write of size 8 at addr ffff88800a05f720 by task kworker/0:2/71
  Workqueue: events nfcsim_recv_wq [nfcsim]
  Call Trace:
   dump_stack_lvl+0x45/0x59
   print_address_description.constprop.0+0x21/0x140
   ? digital_send_cmd_complete+0x16/0x50
   ? digital_send_cmd_complete+0x16/0x50
   kasan_report.cold+0x7f/0x11b
   ? digital_send_cmd_complete+0x16/0x50
   ? digital_dep_link_down+0x60/0x60
   digital_send_cmd_complete+0x16/0x50
   nfcsim_recv_wq+0x38f/0x3d5 [nfcsim]
   ? nfcsim_in_send_cmd+0x4a/0x4a [nfcsim]
   ? lock_is_held_type+0x98/0x110
   ? finish_wait+0x110/0x110
   ? rcu_read_lock_sched_held+0x9c/0xd0
   ? rcu_read_lock_bh_held+0xb0/0xb0
   ? lockdep_hardirqs_on_prepare+0x12e/0x1f0

This flow of calling digital_send_cmd_complete() callback on driver exit
is specific to nfcsim which implements reading and sending work queues.
Since the NFC digital device was unregistered, the callback should not
be called.

Fixes: 204bddcb508f ("NFC: nfcsim: Make use of the Digital layer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcsim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index a9864fcdfba6..dd27c85190d3 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -192,8 +192,7 @@ static void nfcsim_recv_wq(struct work_struct *work)
 
 		if (!IS_ERR(skb))
 			dev_kfree_skb(skb);
-
-		skb = ERR_PTR(-ENODEV);
+		return;
 	}
 
 	dev->cb(dev->nfc_digital_dev, dev->arg, skb);
-- 
2.27.0

