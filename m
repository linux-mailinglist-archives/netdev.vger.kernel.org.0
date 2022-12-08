Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8BC646F3C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiLHMFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLHMFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:05:06 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F248B84DDB
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:05:05 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s196so1026554pgs.3
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 04:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EkD+qvz05ab3h8R8ux8Mh256qDukfvvELmez2tATMG4=;
        b=BjsgL4LUvBqb4fJS1z5jcqzMhxnab4uZowrTBnzetXbRz5Tpny3ZfJ4molVhavFeDe
         ZX/RIrO4xLwXhpsP3H/vTdpcB+7BepTz/CVxB5ECsujgpu5AlBqrE0sJ67HrmiNopsfu
         chBSieRgfjm8HQOJ6QmAvKxnk1tWDg/mw3cfXXJmyd1F7m7cbLZyxZLBjMZve5GBYtRX
         l/rvJzPLmamfNN81i9V+mRCTv4zQ7/oGPOb3s6v+n6xp3APZ0vOZU43lmjQqeVl0nPTZ
         aaoDLhd+GhUm6jH/t3CbzvqGGT2DlKENr2S0lcqdQmTTSROit6Q9zr+Y3joiWgSungdG
         6nEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EkD+qvz05ab3h8R8ux8Mh256qDukfvvELmez2tATMG4=;
        b=SnrBPLJT1u7/FtZUx3AV1yiufiTevCGdtLOBeNLsefja5Tb4ZUNEZ8t1fWQC7wReWC
         mELYg1Yca9Ki+MA3accZlamr1EcXfuMTFRvUt8Dix3UXXPILAFp18ubhVzvxCyc+pAyJ
         HmSrHcFi9JUaAISW4J1lsELKJKSvbwkyn/no3d/7t+nM4HvhX3Asf5qSdCT2hI7Sg5ME
         rQiiONEttYqvCFGU47yzuod8XBV/gDLI5jsQgvxmkyyCcEfVuSlv8B6fEuX/qgmJuz8/
         33EB5DchivXbjBBiWWL0KGXkOCy/FbVcutgmOXwFaMUBUf2vF1/EUvWXsInOOsFLxYnn
         0Y4A==
X-Gm-Message-State: ANoB5pnrlJbRj8PYj3MuCY2V/cGb76yLDsv2fWgaeZeZmmoXMX9NXtsw
        Hn6CuK/bMOu1rl3LOexDIuwmQCOEnpzoY7/g
X-Google-Smtp-Source: AA0mqf4VgqS8yzJ8o1sO2UOa+/EQVJv2AIt8tmMHowtfzpnad5jgNzqvB87SaFK6UwL/89v0yg0iTA==
X-Received: by 2002:a63:7f52:0:b0:478:b5c7:ced1 with SMTP id p18-20020a637f52000000b00478b5c7ced1mr17245563pgn.136.1670501104701;
        Thu, 08 Dec 2022 04:05:04 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902784c00b001888cadf8f6sm16345121pln.49.2022.12.08.04.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 04:05:04 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        William Tu <u9012063@gmail.com>, Andy Zhou <azhou@nicira.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jianlin Shi <jishi@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH net] net/tunnel: wait until all sk_user_data reader finish before releasing the sock
Date:   Thu,  8 Dec 2022 20:04:52 +0800
Message-Id: <20221208120452.556997-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
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

There is a race condition in vxlan that when deleting a vxlan device
during receiving packets, there is a possibility that the sock is
released after getting vxlan_sock vs from sk_user_data. Then in
later vxlan_ecn_decapsulate(), vxlan_get_sk_family() we will got
NULL pointer dereference. e.g.

   #0 [ffffa25ec6978a38] machine_kexec at ffffffff8c669757
   #1 [ffffa25ec6978a90] __crash_kexec at ffffffff8c7c0a4d
   #2 [ffffa25ec6978b58] crash_kexec at ffffffff8c7c1c48
   #3 [ffffa25ec6978b60] oops_end at ffffffff8c627f2b
   #4 [ffffa25ec6978b80] page_fault_oops at ffffffff8c678fcb
   #5 [ffffa25ec6978bd8] exc_page_fault at ffffffff8d109542
   #6 [ffffa25ec6978c00] asm_exc_page_fault at ffffffff8d200b62
      [exception RIP: vxlan_ecn_decapsulate+0x3b]
      RIP: ffffffffc1014e7b  RSP: ffffa25ec6978cb0  RFLAGS: 00010246
      RAX: 0000000000000008  RBX: ffff8aa000888000  RCX: 0000000000000000
      RDX: 000000000000000e  RSI: ffff8a9fc7ab803e  RDI: ffff8a9fd1168700
      RBP: ffff8a9fc7ab803e   R8: 0000000000700000   R9: 00000000000010ae
      R10: ffff8a9fcb748980  R11: 0000000000000000  R12: ffff8a9fd1168700
      R13: ffff8aa000888000  R14: 00000000002a0000  R15: 00000000000010ae
      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
   #7 [ffffa25ec6978ce8] vxlan_rcv at ffffffffc10189cd [vxlan]
   #8 [ffffa25ec6978d90] udp_queue_rcv_one_skb at ffffffff8cfb6507
   #9 [ffffa25ec6978dc0] udp_unicast_rcv_skb at ffffffff8cfb6e45
  #10 [ffffa25ec6978dc8] __udp4_lib_rcv at ffffffff8cfb8807
  #11 [ffffa25ec6978e20] ip_protocol_deliver_rcu at ffffffff8cf76951
  #12 [ffffa25ec6978e48] ip_local_deliver at ffffffff8cf76bde
  #13 [ffffa25ec6978ea0] __netif_receive_skb_one_core at ffffffff8cecde9b
  #14 [ffffa25ec6978ec8] process_backlog at ffffffff8cece139
  #15 [ffffa25ec6978f00] __napi_poll at ffffffff8ceced1a
  #16 [ffffa25ec6978f28] net_rx_action at ffffffff8cecf1f3
  #17 [ffffa25ec6978fa0] __softirqentry_text_start at ffffffff8d4000ca
  #18 [ffffa25ec6978ff0] do_softirq at ffffffff8c6fbdc3

Reproducer: https://github.com/Mellanox/ovs-tests/blob/master/test-ovs-vxlan-remove-tunnel-during-traffic.sh

Fix this by waiting for all sk_user_data reader to finish before
releasing the sock.

Reported-by: Jianlin Shi <jishi@redhat.com>
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Fixes: 6a93cc905274 ("udp-tunnel: Add a few more UDP tunnel APIs")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/udp_tunnel_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 8242c8947340..5f8104cf082d 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -176,6 +176,7 @@ EXPORT_SYMBOL_GPL(udp_tunnel_xmit_skb);
 void udp_tunnel_sock_release(struct socket *sock)
 {
 	rcu_assign_sk_user_data(sock->sk, NULL);
+	synchronize_rcu();
 	kernel_sock_shutdown(sock, SHUT_RDWR);
 	sock_release(sock);
 }
-- 
2.38.1

