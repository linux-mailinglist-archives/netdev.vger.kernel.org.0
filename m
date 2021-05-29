Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726E6394E26
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 22:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhE2UZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 16:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhE2UY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 16:24:58 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12177C061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 13:23:21 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id i67so7613189qkc.4
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 13:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=418Q4uQ2N4LUo69LitsRoIDsFi3DR//uNbfhc97umiI=;
        b=jb7K9ocmk4aDf1KXVdd8/kUMp1PS0+J2kj8yde7TuzwX3LqHkrGp5hTj1GRxfn8GSn
         2hC/2yE8OKkPIglgeW3bhHdpQyGDf+EuNTqn19P4HlEFZlilYjJ67iOqAFtAEE3mHHfW
         3HZWxpbn1maqHYwHbSNCldLaeqSU8MGiIfEm1azQ1V8R5h4+wYbCLrbvbrQ/4T6gqjh/
         MAtzG9H1Gf8Awa3fRz/scHGGu5eWExdlZp6PRQLGVfHnXarO1yR8xYgbkPvBJFVPj3Rv
         D7dL0oeqICLAL3gnL+cxX0AsPcARNy0v8oRLFM3lvKEQrErE/T2TIxgtW6Y0aad+foRW
         ODsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=418Q4uQ2N4LUo69LitsRoIDsFi3DR//uNbfhc97umiI=;
        b=PSZs8c3bR3+SGOKCFYPqqFgusSLuk1BGd0paCTFDxiFElOfRrKr1oOEe1Chzk5r901
         pV6hX0Oyaa7TYcAsjSIl1HwrZzYyZkLhDJx4QBlfRB1kuIaMajADjCQsUTIFUxJ1pohM
         1LQRE9OkXMOw0R3HODbsIxPDzbOH4jXuBp59gVkf17akjIJR72u2UlJZ1hwcnwLsi//5
         1Sb6AdiNw/9zm5KA8uJJVagdUDTKBQVoISNSCR1Chezg9WkDndU5qvKXxlRgHeQKesue
         iLnaLzN08fiMDt4xXCeuvu9ATfMZoUzuzvIHIANo3W90OLCStTeX6S+fqBqapAYq0zdI
         ECFA==
X-Gm-Message-State: AOAM532kh+szqAK6zgEgF853QSgyer9pMCbS5w8b4agypVVmAEMKR44i
        so4BnZd7RPso1W3crKjt6sMyF5iUlAmTKQ==
X-Google-Smtp-Source: ABdhPJzl0gveac98D9ICdih+ibAeuGcaAOKFFgty3PDjpWj+jVbVoN/96d1pbbaWimTGjaa49sG3/A==
X-Received: by 2002:ae9:e40b:: with SMTP id q11mr9694433qkc.101.1622319799410;
        Sat, 29 May 2021 13:23:19 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id a5sm5789815qto.75.2021.05.29.13.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 13:23:19 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH ipsec] xfrm: remove the fragment check for ipv6 beet mode
Date:   Sat, 29 May 2021 16:23:18 -0400
Message-Id: <8099f9355ff059dbcbde40ae0b2a1c377844706f.1622319798.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 68dc022d04eb ("xfrm: BEET mode doesn't support fragments
for inner packets"), it tried to fix the issue that in TX side the
packet is fragmented before the ESP encapping while in the RX side
the fragments always get reassembled before decapping with ESP.

This is not true for IPv6. IPv6 is different, and it's using exthdr
to save fragment info, as well as the ESP info. Exthdrs are added
in TX and processed in RX both in order. So in the above case, the
ESP decapping will be done earlier than the fragment reassembling
in TX side.

Here just remove the fragment check for the IPv6 inner packets to
recover the fragments support for BEET mode.

Fixes: 68dc022d04eb ("xfrm: BEET mode doesn't support fragments for inner packets")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_output.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e4cb0ff4dcf4..ac907b9d32d1 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -711,15 +711,8 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
 static int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	unsigned int ptr = 0;
 	int err;
 
-	if (x->outer_mode.encap == XFRM_MODE_BEET &&
-	    ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL, NULL) >= 0) {
-		net_warn_ratelimited("BEET mode doesn't support inner IPv6 fragments\n");
-		return -EAFNOSUPPORT;
-	}
-
 	err = xfrm6_tunnel_check_size(skb);
 	if (err)
 		return err;
-- 
2.27.0

