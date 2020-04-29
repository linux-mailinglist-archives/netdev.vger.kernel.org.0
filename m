Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5C41BD903
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgD2KGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgD2KGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:06:46 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874C1C03C1AE;
        Wed, 29 Apr 2020 03:06:46 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r26so1372698wmh.0;
        Wed, 29 Apr 2020 03:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pw3wwMTVVUGeM6C/JIXbWoSi/kG/eOapGiuDxmHz9Pw=;
        b=d16DcqtdtUQeEUkn/bpCndXkgJuMBw4AfpDTDFYPV8bb0lfCiG8oqDHzmFgK8nMd5X
         /qIij6KpBZwoDNnGhEFeyMVvk8sJOyp9I4woTZSW3g66Alxx3pNHN/Il8y24Xhl2p6fh
         4kGMFzP0cx8vjrvzyCEa1o0+tu4KVZsYcX5eTG1KgCxUqBXoDTwLdV+mZmK94uM+MCOi
         4oMWcWUiBfpaOlQEZkbUdy/VS8SEw25MScomY8BdIzJyWbWdgeHsY1Yfa42WOg5jUUiM
         BivcnAPvNHjbO6FtGI26cB8B2auZ0wp1QYD3Zejw8razYLCdDjoOGDLS4q/7PJ62X+7p
         vKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pw3wwMTVVUGeM6C/JIXbWoSi/kG/eOapGiuDxmHz9Pw=;
        b=DOjpw+qUIsgfcvv9NBGaReNnEjZ0psF70IgGegpIvh1aoE/w/1xRWu1MZuFd+xl5zw
         mhzWUN3v6/8BtIlzFm1NvWnJHQIrc0Kxu4MT6wQ6sKimyrleehEysQzk9ha7dkBx8oHE
         z2JE6jkAHsattLMvlib0jpvR5iyIcJ5qFkpfQwQhaitAWD+QODuHrzZHHeFnUHkhjHdi
         S7ck5/N5Jtj7N3FA5/7R+RkIidmGWWo2Z66CAxo/20M1kshWUdKh8Cgrn9CtVfzVZMeE
         xrythD7vBQBzQLY0WkJiXSHvtwj26qSuXDZHlq5mGGJYpDiQYAP85+q877/bELO2Og6A
         5Rcw==
X-Gm-Message-State: AGi0PuY+TdVoKkdosgF0khjPnzJ6c1U2QiFeHauxgeLD+8DeyEjL1mCU
        lYmcSFe7IVWPNrq91QHVbA54rW6374hC
X-Google-Smtp-Source: APiQypLcc6eZ9uECXO7qlAoldSWnzjTUBFfKSfXsLfUegC2QxTGR/ZcJBym9S2dOFWa11D2evGcdHQ==
X-Received: by 2002:a7b:cfc9:: with SMTP id f9mr2469942wmm.61.1588154804962;
        Wed, 29 Apr 2020 03:06:44 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-195.as13285.net. [2.102.14.195])
        by smtp.gmail.com with ESMTPSA id 1sm7205478wmi.0.2020.04.29.03.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 03:06:44 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6])
Subject: [PATCH 2/6] udp: Add missing annotations for busylock_acquire() and busylock_release()
Date:   Wed, 29 Apr 2020 11:05:24 +0100
Message-Id: <20200429100529.19645-3-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200429100529.19645-1-jbi.octave@gmail.com>
References: <0/6>
 <20200429100529.19645-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports warnings

warning: context imbalance in busylock_acquire() - wrong count at exit
warning: context imbalance in busylock_release() - unexpected unlock

The root cause is the missing annotations at
busylock_acquire() and busylock_release()

The __release(busy) annotation inside busylock_release()
tells Sparse and not GCC to shutdown the warning
in case the condition is not satisfied.

Add the missing __acquires(busy) annotation
Add the missing __releases(busy) annotation
Add the __release(busy) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/ipv4/udp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index db76b9609299..5ca12a945ac3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1430,6 +1430,7 @@ static int udp_busylocks_log __read_mostly;
 static spinlock_t *udp_busylocks __read_mostly;
 
 static spinlock_t *busylock_acquire(void *ptr)
+	__acquires(busy)
 {
 	spinlock_t *busy;
 
@@ -1439,9 +1440,13 @@ static spinlock_t *busylock_acquire(void *ptr)
 }
 
 static void busylock_release(spinlock_t *busy)
+	__releases(busy)
 {
 	if (busy)
 		spin_unlock(busy);
+	else
+		/* annotation for sparse */
+		__release(busy);
 }
 
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
-- 
2.25.3

