Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5765072FF3
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGXNc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:32:57 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38674 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfGXNc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:32:57 -0400
Received: by mail-qk1-f194.google.com with SMTP id a27so33741664qkk.5
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 06:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=VVlcNSa1m2lmqoAvGdWAXDGQzs62Yp1UxP1TI92+l3k=;
        b=K2Dp0nXLVoNti+TEAeDh9CSLDRmAglIPXZVan9Nx9POLt2vz8wcZ+6ts43qH58k4hp
         dfL9Kz6vSqHSgAZWbE+A7FBJM1TdRMwn7Ic0Fb6NsIIiyHlm19j2eluBXBFTVKr5x00Z
         HV0gVSFxx+CSpUNSPpZ8tYN6BR0H65rukDRXTgHL4KqjETMV+TFxNssT6DslDCdPhVr1
         KZUraxiy18oQ3l8NEeUPkJjH6a9HsGwuJRMeoEQhgKCUdJ3QgSovOZEuNox8XLWqyMW6
         RFpE+TYW5riexOpvRLkWYV+gFEUNJV2Kst/LelXM12gKuVbkwgsgIfauJ3Psu62y2ZqS
         Yg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VVlcNSa1m2lmqoAvGdWAXDGQzs62Yp1UxP1TI92+l3k=;
        b=RKGTQ7JkjLympo6cNj00S4KhGWxoPe+M6V/Lz26gNR5352ROWGdrE+qkN66ylHwy/C
         t+y9DfWt4rowUJA+PYKSgTXuBGTeF3IFWEpsxNyfQ4e5cn26jW2Uj1nC56Rr3lKQpp7g
         R/aSpREesEs8hKV8r1RX/ITtuf554jHx+BbLR/TDDbW5jbedxNpjcHUwynFseAtDhhQ0
         x5/6nafsK9MEyZ3GzUBmukXEpOJYBure701B5aoFD8GG/1F+whoO//VJpaR6jxsHvwqR
         h7Qw16RUEfr08KvCIwRvo9cmdj3yHev8K300zL1cLWumzt4Pmt92EiX+P7OKkMonDY/O
         bnfw==
X-Gm-Message-State: APjAAAWlrd22ZlEOcwr0YQiv23hFhZV+BBf7nx8MlVMN4RT1FFLGMDdG
        Dy8zJUj6TAfno12cdaIW0CtkxQ==
X-Google-Smtp-Source: APXvYqwfiEBRGDv0Fl+LzDaXkF5umNZChanqsAUd1U+6ODFBHjZDU0Vb8i++QEVvl49WaG3zAnaYnw==
X-Received: by 2002:a05:620a:1448:: with SMTP id i8mr54936345qkl.73.1563975176507;
        Wed, 24 Jul 2019 06:32:56 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j6sm2476101qtl.85.2019.07.24.06.32.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 06:32:55 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     willy@infradead.org
Cc:     davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH -next] net/ixgbevf: fix a compilation error of skb_frag_t
Date:   Wed, 24 Jul 2019 09:32:37 -0400
Message-Id: <1563975157-30691-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The linux-next commit "net: Rename skb_frag_t size to bv_len" [1]
introduced a compilation error on powerpc as it forgot to rename "size"
to "bv_len" for ixgbevf.

[1] https://lore.kernel.org/netdev/20190723030831.11879-1-willy@infradead.org/T/#md052f1c7de965ccd1bdcb6f92e1990a52298eac5

In file included from ./include/linux/cache.h:5,
                 from ./include/linux/printk.h:9,
                 from ./include/linux/kernel.h:15,
                 from ./include/linux/list.h:9,
                 from ./include/linux/module.h:9,
                 from
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:12:
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c: In function
'ixgbevf_xmit_frame_ring':
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:4138:51: error:
'skb_frag_t' {aka 'struct bio_vec'} has no member named 'size'
   count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
                                                   ^
./include/uapi/linux/kernel.h:13:40: note: in definition of macro
'__KERNEL_DIV_ROUND_UP'
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
                                        ^
drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c:4138:12: note: in
expansion of macro 'TXD_USE_COUNT'
   count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);

Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index bdfccaf38edd..52375cebfbb8 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4135,7 +4135,7 @@ static int ixgbevf_xmit_frame_ring(struct sk_buff *skb,
 	 */
 #if PAGE_SIZE > IXGBE_MAX_DATA_PER_TXD
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
-		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].size);
+		count += TXD_USE_COUNT(skb_shinfo(skb)->frags[f].bv_len);
 #else
 	count += skb_shinfo(skb)->nr_frags;
 #endif
-- 
1.8.3.1

