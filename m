Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC81F6F1344
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345631AbjD1Iac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345588AbjD1Iab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:30:31 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32572D65;
        Fri, 28 Apr 2023 01:30:29 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f193ca059bso54741615e9.3;
        Fri, 28 Apr 2023 01:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682670628; x=1685262628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHPRs1MqZty/wg+jsAp8zNvbtNVXPPRgzXINsE+kXQE=;
        b=M014uLfMRPYGbQPvm0mG2pIIiplMM0jBHwUWJaiq23FpCX8M8deFpq1DGo4utLztHw
         gql+ey+OmeBEBq+ZB2g1ISf1cZbXXBEoU05YzIzB8SzVoUOjEuPt+sP6Yxaamjp+OcXF
         cFSlHpEToSs/a14XM0fOzqfMZUKklDEPN3mXuEs2b6k0KC/puBkVH9enY2YRTrPyGMre
         Ye+OGn3UixtASXidExSE8HGGYQyPQvT/m6Z+vV60hLNnutGkEVy07eiT+3zvOlyCiBuE
         gZ5pu8iyzg+TxHg1HC+HI59ajqkLE+Wrg4C+C7mXPgzWpwHFH7FVeDP8Mc8fWDWysXKq
         R/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682670628; x=1685262628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHPRs1MqZty/wg+jsAp8zNvbtNVXPPRgzXINsE+kXQE=;
        b=br+/9RV/sxP+p34B42ybyEvun8nbJSEZg6l/LALsvkibCkitEJ78mdHSST8qrcYV5W
         x9ws+RABFSuzCGL8NpbGyBkiJghdAkfNBn/Hb7Mtj5WN5zXHgWbCa/G1Gb2dR88/7zeO
         hOimziruPYyiCB3KVxB+IHgj1SgxQ46Vp0zXbDUBPUv1BVVRdaFnM5OGz4ZInBcgqtRy
         +nC32pOTPHoM++Rw1XHwkHEHf+nct72iWDc617pEmFxdvBNcRXApeHBjU9gcHeIbKh0v
         xo1dhvuzNyv+pewuM09t/iZ15aC2DQp8Rigs3r6mqCb0bS7EdwbVQedKPBZ04UGssgdj
         JCMg==
X-Gm-Message-State: AC+VfDwMCLqx6FtYwxVkz5xaRxEQJJfkMgwEZ+/QTl+WIixylrs8oN8L
        L2gjFxpjew3Rom8P2yAeE/8=
X-Google-Smtp-Source: ACHHUZ6RtnPoxNQUbVE/4ekAiTfR4bSVneqQOGQq4qnXUOWHSZcydnlpo/kZ+wQgrj+kj9/Kth7xeQ==
X-Received: by 2002:a05:600c:3797:b0:3f1:82c6:2d80 with SMTP id o23-20020a05600c379700b003f182c62d80mr3397556wmr.5.1682670627647;
        Fri, 28 Apr 2023 01:30:27 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([2a0d:6fc2:43e5:9b00:5000:8721:8779:7e1])
        by smtp.gmail.com with ESMTPSA id n12-20020a7bc5cc000000b003f17329f7f2sm23540545wmk.38.2023.04.28.01.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 01:30:27 -0700 (PDT)
From:   Gilad Sever <gilad9366@gmail.com>
To:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz
Cc:     eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Gilad Sever <gilad9366@gmail.com>
Subject: [PATCH bpf,v4 2/4] bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC hookpoint
Date:   Fri, 28 Apr 2023 11:30:05 +0300
Message-Id: <20230428083007.148364-3-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230428083007.148364-1-gilad9366@gmail.com>
References: <20230428083007.148364-1-gilad9366@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->dev always exists in the tc flow. There is no need to use
bpf_skc_lookup(), bpf_sk_lookup() from this code path.

This change facilitates fixing the tc flow to be VRF aware.

Acked-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
 net/core/filter.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 57d853460e12..e06547922edc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6730,8 +6730,12 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_skc_lookup(skb, tuple, len, IPPROTO_TCP,
-					     netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_skc_lookup(skb, tuple, len, caller_net,
+					       ifindex, IPPROTO_TCP, netns_id,
+					       flags);
 }
 
 static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
@@ -6749,8 +6753,12 @@ static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_TCP,
-					    netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
+					      ifindex, IPPROTO_TCP, netns_id,
+					      flags);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
@@ -6768,8 +6776,12 @@ static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_UDP,
-					    netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
+					      ifindex, IPPROTO_UDP, netns_id,
+					      flags);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
-- 
2.34.1

