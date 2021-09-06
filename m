Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834FC401CFD
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 16:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbhIFO2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 10:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239556AbhIFO2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 10:28:45 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4C3C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 07:27:41 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id bk29so7018112qkb.8
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 07:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9fcPtrsgTauGuHC1/pIPJAJfOzYQqe90AVtL6ot0wpU=;
        b=qbnFMcKn6p+9hxpdSVI54vx+OWQwTdhqrIU6ck2k9Dhh/QA0x76/g41wGVsteHqjKv
         2C1nlaiJYiHhyg4FzF5AX9Bidayt9OBdrHVwjfljGT5vuOKAVQRYV1QBTaOp1ORm3vzf
         RlK6dWsK7jfiFLLEObZ0911oTJ6LyQB1XsN4BZ31w0liU0QBWGnBizLNk9POtnp3lriS
         CHLCCtHjegUHWLRpNZaWlvfcM17UHnPtt215cafYXnPB48L9PMl+MbfRFEO4Z3o3WaPp
         tviBHamjvx5/ZOnfF/8K5LhK2Gd+VtM2hHyFJMfV8fZMlo/nNnhbTW3Ma77yyGiQVmnC
         wSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9fcPtrsgTauGuHC1/pIPJAJfOzYQqe90AVtL6ot0wpU=;
        b=aL3W+EVLy2KrJTm4VyzwZCS+aaRE3yvFmj2S5cZhMiKqh9ndmkWsN7ztsiAA/UyfCM
         5vIE5WhrKFzSJfvQ4DQh1Oq57EZHmx6H0ciSFxaUR8XA2i6HyF+PAWmlhdWlIs6lqP+T
         GNGzEwHE5uh7CzfjWLnjnob4zLkjEfyIwOslAztG7SzXDdjbLTJMiBL+zsjNA31nZwYM
         kg+hNGnWPKZUHcR6R6jqdG62Nn9BsGzuegF3Bkfr/J5WUbyqyVmxNdeN2rHHpuOKmr82
         w4x65rpFsJUyIx30AhPtJTN1C4euFLAFI52ASh6rClWj8qEX/WeMTMoM5O8reJnI02TY
         +W9Q==
X-Gm-Message-State: AOAM531UIBespiyyPMI5gifDVia3OylWp1AfdP/y/38dpJCBRBsOt7vS
        hCvp+6k6U0NDY5/v/hzYR3oi9k+xmNI=
X-Google-Smtp-Source: ABdhPJzSkeAzM5sFE0CZS4dL/vKzjSM6sak/PrWLqJgAZAOAzxgppN0bu4Ix5Y0T5pVM0//9SrT4UA==
X-Received: by 2002:ae9:e858:: with SMTP id a85mr11089819qkg.97.1630938460404;
        Mon, 06 Sep 2021 07:27:40 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:2be8:4885:147d:736a])
        by smtp.gmail.com with ESMTPSA id a185sm6536137qkg.128.2021.09.06.07.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 07:27:40 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@idosch.org,
        chouhan.shreyansh630@gmail.com, alexander.duyck@gmail.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] ip6_gre: Revert "ip6_gre: add validation for csum_start"
Date:   Mon,  6 Sep 2021 10:27:38 -0400
Message-Id: <20210906142738.1948625-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

This reverts commit 9cf448c200ba9935baa94e7a0964598ce947db9d.

This commit was added for equivalence with a similar fix to ip_gre.
That fix proved to have a bug. Upon closer inspection, ip6_gre is not
susceptible to the original bug.

So revert the unnecessary extra check.

In short, ipgre_xmit calls skb_pull to remove ipv4 headers previously
inserted by dev_hard_header. ip6gre_tunnel_xmit does not.

Link: https://lore.kernel.org/netdev/CA+FuTSe+vJgTVLc9SojGuN-f9YQ+xWLPKE_S4f=f+w+_P2hgUg@mail.gmail.com/#t
Fixes: 9cf448c200ba ("ip6_gre: add validation for csum_start")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv6/ip6_gre.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 7baf41d160f5..3ad201d372d8 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -629,8 +629,6 @@ static int gre_rcv(struct sk_buff *skb)
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
-	if (csum && skb_checksum_start(skb) < skb->data)
-		return -EINVAL;
 	return iptunnel_handle_offloads(skb,
 					csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
-- 
2.33.0.153.gba50c8fa24-goog

