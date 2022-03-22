Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A624E4818
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbiCVVJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbiCVVJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:09:14 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B013EAA5
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:45 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so4085701wme.5
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lIYEEzHUYKzkWkxt1nwU2xaGYq4yK0UBpk6s66e1KD4=;
        b=c7JZOjdlVB/hNXmn+I2Vk1+M2KyKT1MtJn0t2XLD3/Up4911XVoTUIf7TWD4EGlYFu
         +0FgCxM634JO08vusv4DfGM34JUZvGVuAj44eUyhNU8Vzw8W9NnXQVbw1xZ8FdtPOnz+
         Wrsq05UoJmTs4taZi1Ad2KArn0/bQWb+Mr05X9QMRB1U5KVlYOymF37IDXUA0/DASHgn
         P5o9vkdKS6B3u4v1A5UwwcLAU06gE0I4dgU3fJOmU8yF6IEzYnO+d41dC4eca9twtFhg
         HyQ9xWj3Wavu8jK4T+mYE9L8ignnXe4olnayGohbDZR78jATxZ+NuM5aHjuPMSiuecdy
         qUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lIYEEzHUYKzkWkxt1nwU2xaGYq4yK0UBpk6s66e1KD4=;
        b=dVp31fSf4x21skjUQ8kvhOw0cHexDaE0lr0iAWg+5suj+DMs1i40lc1njOyB6JAkrS
         OGmG4dix/elYClVS4QxDSkd+KcIgUHcHAHVb8vcPjNOHPRZCPE7EKnGQPiQqkqZtJSgs
         JcIz2RQhrQ579xOE7oaZz26zYFEVHszEQNBlw4ivSBCCTfLm5mQbBG7wWVAmvr2/jriX
         xjvVwtZREttiPrS/PuRDGR2zvDRiWWgld0hTzpLPPmEp7TnJ6dYYgc6GJiuTIXnqF5LE
         T3y+SKv+lcH/i+x4wQ44sJHKhskMAFTDd1qNHHycoD64Jn3ZlxW4VYIe+4iIeOx1QGSp
         s0dg==
X-Gm-Message-State: AOAM5329lAo/Dy0JqrzoOdkI2U0dTKkO1p17EbUU+ZaGvQJgUbHLobKQ
        UkBX6vjCwGKyiKuaQ26O+x0Xag==
X-Google-Smtp-Source: ABdhPJzC4CkdJU8Mjb9hZGgZTUueN21KJNVRaff5uqR89ZD64UBuJx7nM45hvERhXu6qBlfJU3oWCg==
X-Received: by 2002:a1c:c904:0:b0:38c:8dc1:87a3 with SMTP id f4-20020a1cc904000000b0038c8dc187a3mr5884410wmb.101.1647983264184;
        Tue, 22 Mar 2022 14:07:44 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm16281805wru.75.2022.03.22.14.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 14:07:43 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v1 3/6] ptp: Pass hwtstamp to ptp_convert_timestamp()
Date:   Tue, 22 Mar 2022 22:07:19 +0100
Message-Id: <20220322210722.6405-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220322210722.6405-1-gerhard@engleder-embedded.com>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp_convert_timestamp() converts only the timestamp hwtstamp, which is
a field of the argument with the type struct skb_shared_hwtstamps *. So
a pointer to the hwtstamp field of this structure is sufficient.

Rework ptp_convert_timestamp() to use an argument of type ktime_t *.
This allows to add additional timestamp manipulation stages before the
call of ptp_convert_timestamp().

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/ptp/ptp_vclock.c         | 5 ++---
 include/linux/ptp_clock_kernel.h | 7 +++----
 net/socket.c                     | 2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 3a095eab9cc5..c30bcce2bb43 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -232,8 +232,7 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
 }
 EXPORT_SYMBOL(ptp_get_vclocks_index);
 
-ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
-			      int vclock_index)
+ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 {
 	char name[PTP_CLOCK_NAME_LEN] = "";
 	struct ptp_vclock *vclock;
@@ -255,7 +254,7 @@ ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
 
 	vclock = info_to_vclock(ptp->info);
 
-	ns = ktime_to_ns(hwtstamps->hwtstamp);
+	ns = ktime_to_ns(*hwtstamp);
 
 	spin_lock_irqsave(&vclock->lock, flags);
 	ns = timecounter_cyc2time(&vclock->tc, ns);
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index acdcaa4a1ec2..cc6a7b2e267d 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -379,17 +379,16 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
 /**
  * ptp_convert_timestamp() - convert timestamp to a ptp vclock time
  *
- * @hwtstamps:    skb_shared_hwtstamps structure pointer
+ * @hwtstamp:     timestamp
  * @vclock_index: phc index of ptp vclock.
  *
  * Returns converted timestamp, or 0 on error.
  */
-ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
-			      int vclock_index);
+ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index);
 #else
 static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
 { return 0; }
-static inline ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
+static inline ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp,
 					    int vclock_index)
 { return 0; }
 
diff --git a/net/socket.c b/net/socket.c
index 1acebcb19e8f..2e932c058002 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -887,7 +887,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
 	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
 		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
-			hwtstamp = ptp_convert_timestamp(shhwtstamps,
+			hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
 							 sk->sk_bind_phc);
 		else
 			hwtstamp = shhwtstamps->hwtstamp;
-- 
2.20.1

