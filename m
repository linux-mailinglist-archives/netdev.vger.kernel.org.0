Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5A160059A
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 05:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiJQDJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 23:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiJQDJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 23:09:55 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7CB13D5A;
        Sun, 16 Oct 2022 20:09:50 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id l28so7004278qtv.4;
        Sun, 16 Oct 2022 20:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B+BvkuKX9F0LgkAS+9y4xZTGhLntumoi0G3eVfOo/lY=;
        b=NbInKp64MTTh4DaeWO0sT6t8a5bcnIrmZRqEFJSRYEDGPwa98vfjzf1vmwxaMj5hjX
         t9LUZ0XatXx6B4aT4L+KK2+MWgM7QeckEnmtiNgGRdEP9ByVNmgv4zgTyhBq/d5bVkrM
         cyS0BB+k0inPV1f6arH87NQFvA3lGIFYHnfoWj9qV52LbMgJG6fp8mxlGnqCFBnbkkLd
         5hV0xGOWiwlMOuppzvkgfY8aDApfPNTY1uDGpLmQtMWtPKV5glsdFePYqfQwS6Hu4NeW
         5cMPgKI0h5UN4GxVjgt7g9bYP0wU01hI3E8WGi09MDl6Lyfl/Eb9BsA/5HX+etjtG0BQ
         EJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B+BvkuKX9F0LgkAS+9y4xZTGhLntumoi0G3eVfOo/lY=;
        b=2qoqkV2BQlu9XzhExXdQVSch+whZntonfrJtmyd41RfX1iaY0r4RAWo8FyfXBDTgTF
         +hc33fPLq4A5aRT56nqzkfZLhdqUM77IPBvD19Irx4pt4ybtI8yENF61n0MtM3qIJRrS
         Vvp4tnrREz1ppuJ/CRxO1uAYWEmIlq+llsy9lvgXbNzixJVePmuCw3QWztE/GXacyf0M
         EPbJmEuLLD5MJblG0+ode7Ujlb+bGnNE3WbjeGVbT5OLTsZ5xtbCrSmvpnuLR4DjkIWt
         961UrhiZJ6bQOWWvkzSmA9Kqpnp5ErKy+b5tfPgdoCVj96NzfdBHRM958BX56EXxoX8Q
         GxpQ==
X-Gm-Message-State: ACrzQf05R5SfvQjd77a9KXV4Qu2MIqOrtw+3R586e7SYXHVBxLyyY+3J
        9HfGPafEpsa0gAHU96VQoUBkm4wG/Ys=
X-Google-Smtp-Source: AMsMyM5xmU3x72VcDuNwgr7WoZG6cponuAmLDur3pSA5WXXo9vYxqNnW24dncHjKnmjXVOHcbaej/w==
X-Received: by 2002:a05:622a:60e:b0:39c:c3aa:69a4 with SMTP id z14-20020a05622a060e00b0039cc3aa69a4mr7108306qta.368.1665976189593;
        Sun, 16 Oct 2022 20:09:49 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:53b9:bba7:4847:520c])
        by smtp.gmail.com with ESMTPSA id t138-20020a37aa90000000b006ecb9dfdd15sm8305004qke.92.2022.10.16.20.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 20:09:49 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Eric Dumazet <edumazet@google.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Menglong Dong <imagedong@tencent.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@nvidia.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        andriy.shevchenko@linux.intel.com, caraitto@google.com,
        jonolson@google.com, willemb@google.com,
        "David S .Miller" <davem@davemloft.net>,
        Andrew Jones <ajones@ventanamicro.com>,
        amritha.nambiar@intel.com, linux@rasmusvillemoes.dk
Subject: [PATCH] Revert "net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}"
Date:   Sun, 16 Oct 2022 20:09:47 -0700
Message-Id: <20221017030947.1295426-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 854701ba4c39afae2362ba19a580c461cb183e4f.

The reverted commit makes netif_attr_test_online() network subsystems
generating warnings, and it breaks syzkaller testing.

https://syzkaller.appspot.com/bug?extid=9abe5ecc348676215427

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/netdevice.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a36edb0ec199..eddf8ee270e7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3663,8 +3663,9 @@ static inline bool netif_attr_test_online(unsigned long j,
 static inline unsigned int netif_attrmask_next(int n, const unsigned long *srcp,
 					       unsigned int nr_bits)
 {
-	/* n is a prior cpu */
-	cpu_max_bits_warn(n + 1, nr_bits);
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpu_max_bits_warn(n, nr_bits);
 
 	if (srcp)
 		return find_next_bit(srcp, nr_bits, n + 1);
@@ -3685,8 +3686,9 @@ static inline int netif_attrmask_next_and(int n, const unsigned long *src1p,
 					  const unsigned long *src2p,
 					  unsigned int nr_bits)
 {
-	/* n is a prior cpu */
-	cpu_max_bits_warn(n + 1, nr_bits);
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpu_max_bits_warn(n, nr_bits);
 
 	if (src1p && src2p)
 		return find_next_and_bit(src1p, src2p, nr_bits, n + 1);
-- 
2.34.1

