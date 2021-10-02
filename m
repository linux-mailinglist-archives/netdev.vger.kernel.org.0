Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9C441FA65
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 10:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhJBINg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 04:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbhJBINf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 04:13:35 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FCDC061775
        for <netdev@vger.kernel.org>; Sat,  2 Oct 2021 01:11:49 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h3so978685pgb.7
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 01:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L/Y0dK/DJsa4dDzC0rhCrQWvZh9+m0W4XlUzZ39cLjs=;
        b=c4GTfoJxh8NvQLImFpnlyxUlxV87NTfzA65mV+72dCRe9RR0sk03Jl17Gaj5/BxRNn
         HHjBTqgAgn/uaiEGSojIBkvar/072qGnceYkd8geq9PQOyqc4xBfUmCaXjhMY4bZQzeh
         La2MmLMeea+AeGusVzX4THzWff0qky0s/u2/t+yMDAoEEm0912gOLlaCI3j/Xf2Uwome
         JoTOESBRCjLub3uDum8mQvZbn4vHN66XB+U6+4g3vzYEmYbU/Nf2WlwoN1A+LOvDTv9J
         UALREmO9Z9N9HL9PNWUU3DbKq8e2POEW4sRKJqkvCLT6orBAchSwsmzUxQAVS0DmFZXp
         6DrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L/Y0dK/DJsa4dDzC0rhCrQWvZh9+m0W4XlUzZ39cLjs=;
        b=6dIsmpqtp1/0zHedWZ2LI/VBZTKKF420OE4WMnaa4G8RmWci1v8qN6u6yRS5RaGQvg
         nrLMpnvC8RX/i23k0DN4xUrEvqi1VyRHZzPreb7BFSNc1bCZJsWR6ZU3ZsmqQhEttMHq
         9Hl47DR7oj0iUtLuWx6clyr3i/sWvKKmLuJ40La61d4DrI30bEV+i8/fSBwWkKieEzuG
         k9wonmyKhyEk/Epql1j0N34d8RflXV8O9BzgobNvFl65AsuErPJOfCX1K7MEcgyH5sj/
         mNFXHsyvjN3t3BIPCjArINmqP+UqqGGFMgyQ0iMubIfGDl9mAf/fZlG9jBoeRXqL/BF/
         sFpA==
X-Gm-Message-State: AOAM532nUc0pd5a/tZJlKit6WBj6GK8/vlXXoKBQsoaahRASWgBh97R6
        uK1DlyQzbUZJ7hKjB9FSM9I=
X-Google-Smtp-Source: ABdhPJxwzvzTEZGshkQ36LxWo47LDH2eTDt6BY12um5dSmPYTqP47lKO8bujnlAZy+LjLz3d2c9PKA==
X-Received: by 2002:a63:3d4c:: with SMTP id k73mr2027365pga.44.1633162307964;
        Sat, 02 Oct 2021 01:11:47 -0700 (PDT)
Received: from tommy.ericsson.se ([124.52.133.176])
        by smtp.gmail.com with ESMTPSA id n19sm7857318pff.37.2021.10.02.01.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 01:11:47 -0700 (PDT)
From:   Gyumin Hwang <hkm73560@gmail.com>
To:     Joe Perches <joe@perches.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Gyumin Hwang <hkm73560@gmail.com>
Subject: [PATCH v2] net:dev: Change napi_gro_complete return type to void
Date:   Sat,  2 Oct 2021 08:11:36 +0000
Message-Id: <20211002081136.3754-1-hkm73560@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <8d21e758966ca5581edd4babe0773a28e9938a78.camel@perches.com>
References: <8d21e758966ca5581edd4babe0773a28e9938a78.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_gro_complete always returned the same value, NET_RX_SUCCESS
And the value was not used anywhere

Signed-off-by: Gyumin Hwang <hkm73560@gmail.com>
---
Changes in v2:
  - Remove unnecessary return at function end

 net/core/dev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f930329f0dc2..96fd8f77ab6a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5839,7 +5839,7 @@ static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb, int se
 		gro_normal_list(napi);
 }
 
-static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
+static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 {
 	struct packet_offload *ptype;
 	__be16 type = skb->protocol;
@@ -5868,12 +5868,11 @@ static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 	if (err) {
 		WARN_ON(&ptype->list == head);
 		kfree_skb(skb);
-		return NET_RX_SUCCESS;
+		return;
 	}
 
 out:
 	gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
-	return NET_RX_SUCCESS;
 }
 
 static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
-- 
2.25.1

