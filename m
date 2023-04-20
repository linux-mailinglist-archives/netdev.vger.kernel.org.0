Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477C96E946E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbjDTMcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbjDTMcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:32:50 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154D712F;
        Thu, 20 Apr 2023 05:32:33 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f178da21b5so4446725e9.3;
        Thu, 20 Apr 2023 05:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681993951; x=1684585951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQt4d0zWjQY1z91uepy6h4EuQqaXR87jdp20zwNy9IM=;
        b=EzZCGW8+GBqLFc5RwBAzUZE0mhTL7nEhEZC1sraSYZOZ0ZF1sZV5oR0THYhzW3XyGo
         rknZ2Ch94q3kyfXD1wa+JZORjr7wS5TkY31olxsctkReFWB4g6xmpiDPB6purgkPXOGB
         1FIT5JoGYTudVToFaLmwJr185zGzDXbgG41zzrMBcfiXFUROivGawFE9LqFQA5RMLSyr
         3YugEZEy2WKV07hho9ofpN88T2KWiWuJC2BaRXyra8SscJNhsQr2EzZgA7accXSyhoa9
         zSEVKpRrNxaYvy+kY3alUFgd5HwTqHsz64YSa5cauOhS8U/cP16IgaHong6quDbPxmp6
         U34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681993951; x=1684585951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQt4d0zWjQY1z91uepy6h4EuQqaXR87jdp20zwNy9IM=;
        b=QqBGEZYqp63o2dkZByZfE7KTJkxIEo2T+4jttX7Ht0xbBbma+8D9EM013eGyKJQlWh
         Rr8asrsUeyBwr7qa5u9P/cxUKp6WgaJMNh9ToMfgZ+CY7GQNcs5LIxqRR6goSRxf40m8
         Thu9bZ0MMLhliwfWQ6FKylz8VoV3uM+Qv5VfnjwhDzmQGxLfZBqTIC5UU4Ewsej0GhRE
         Nqas7cwyOL4i5NeuK5ODVzUDBIKjkn2bT3B69Fw8eBdKiu6u+qOgaVuKIdN1tzA+LJPM
         nFLZt7TyVcBe0sgeSjVIK9/ZLahSe9GJjF8zcdUNPI9HPgYjnH3uqOHLUmIyfz9HjsRy
         g7Kg==
X-Gm-Message-State: AAQBX9ebgEDDrl6Sw0moOtJjRkSVFPq3dzDmqgHFuj053YVG9UYVfNWL
        S7duamxpRrMKJZSYy8Y+5qs=
X-Google-Smtp-Source: AKy350YhKYEwknDHPu9QM3Wf0jpgPncIy67BxrDuOVn4vNX9LMfVQ/D5bEMB4qL7dbetCvQAtcP5CQ==
X-Received: by 2002:adf:f3d0:0:b0:2cf:efc7:19ad with SMTP id g16-20020adff3d0000000b002cfefc719admr1226762wrp.53.1681993951394;
        Thu, 20 Apr 2023 05:32:31 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id z16-20020a5d4410000000b002f79ea6746asm1835081wrq.94.2023.04.20.05.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 05:32:30 -0700 (PDT)
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
Subject: [PATCH bpf 2/4] bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC hookpoint
Date:   Thu, 20 Apr 2023 15:31:53 +0300
Message-Id: <20230420123155.497634-3-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420123155.497634-1-gilad9366@gmail.com>
References: <20230420123155.497634-1-gilad9366@gmail.com>
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

Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
 net/core/filter.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5910956f4e0d..f43f86fc1235 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6704,8 +6704,12 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
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
@@ -6723,8 +6727,12 @@ static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
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
@@ -6742,8 +6750,12 @@ static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
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

