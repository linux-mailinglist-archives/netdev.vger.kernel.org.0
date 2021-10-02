Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8304141FA05
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 08:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhJBGM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 02:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbhJBGM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 02:12:56 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2812C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 23:11:11 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v19so7990391pjh.2
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 23:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mSla8hZHIGSxeC+NGhgin1wHPuQRN359f+2msLZCMMM=;
        b=lSbTwDQvddQ0YzgbMRaGasKH10+6GWKuxOZdCHL4uEo8xNOqJe5kyIoH5dUmM0ArSc
         svnOekBOIb1LVHiNnln3IlzoGx5enTN5WYZvdzU0J5ZS2QBbWlzgvLg2Dj74B0lno642
         qgVow0kacUGus7zgoMOW142NAYWszk7NB5ym1oxKnApCI3ApqMcge8YKBrZ1//rqQOuE
         SgwUgDnJ6Quj6hpgUxm9Rb/lvJznxMNVGY3D7K/Ozy7KXeNhVrJjQGlQwOzawvLGsj8Z
         tJDdRJ8za+O18J3k3Rh9QxLY4YKRK6OL5IEbthyVKEgPB8HEzrOstzSiuWvT9dttopfU
         vECw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mSla8hZHIGSxeC+NGhgin1wHPuQRN359f+2msLZCMMM=;
        b=rgPV/JVBDlRKnQd6zW8bcMsfxVDFOxzxjB3oiPV/V2YoRdVWaZE+aeU1QoSuPn+8Lc
         HkWkX/G7pNLboTR1zAMHzr+PpIwDdFZ30n829CORe7GeUtmo/afpMuj+RGzilNq0QFCF
         OBvWA2aONpdh1oseTyc6mZH6mop5ctnCD9ZSkEpQyT5TgkzrGP1R5eI8Elad31wh4Vk5
         n4C+vPvoPuRvLF0xIkneBudmkc9mmpNVlRWtsw3UcvfcDJCq6T+L9Ha91L+HDKcyNGRP
         RgoX62r2c+5g0DH2n7IT379o7DkdkB873cZ4sP5ufW244Z4YPE2AeF4jQKH5DAFqwILO
         q76A==
X-Gm-Message-State: AOAM530CdDt+3sAv+duWSZ5sKdl7H7brPnL3rTvpDgHlmH9XidkaMkTW
        iPutu7y+VjNc9PCe1n83kcA=
X-Google-Smtp-Source: ABdhPJx87Z8mt+o2NZL33AOVNTW2dya2O0k0A/xlHh0ZsjEkDy6Pyxy+tHVIUBLayEcwPMtoyi5YcQ==
X-Received: by 2002:a17:90b:3ec6:: with SMTP id rm6mr24111272pjb.68.1633155071224;
        Fri, 01 Oct 2021 23:11:11 -0700 (PDT)
Received: from tommy.ericsson.se ([124.52.133.176])
        by smtp.gmail.com with ESMTPSA id o5sm2017153pjk.55.2021.10.01.23.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 23:11:10 -0700 (PDT)
From:   Gyumin Hwang <hkm73560@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Gyumin Hwang <hkm73560@gmail.com>
Subject: [PATCH] net:dev: Change napi_gro_complete return type to void
Date:   Sat,  2 Oct 2021 06:11:02 +0000
Message-Id: <20211002061102.1878-1-hkm73560@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_gro_complete always returned the same value, NET_RX_SUCCESS
And the value was not used anywhere

Signed-off-by: Gyumin Hwang <hkm73560@gmail.com>
---
 net/core/dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f930329f0dc2..b181cd49167a 100644
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
@@ -5868,12 +5868,12 @@ static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 	if (err) {
 		WARN_ON(&ptype->list == head);
 		kfree_skb(skb);
-		return NET_RX_SUCCESS;
+		return;
 	}
 
 out:
 	gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
-	return NET_RX_SUCCESS;
+	return;
 }
 
 static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
-- 
2.25.1

