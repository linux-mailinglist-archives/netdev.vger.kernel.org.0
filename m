Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015FD2F3AD9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406812AbhALTnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436544AbhALTnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:43:01 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C09C0617A4
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:41:59 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id y23so3237194wmi.1
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 11:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+hdtHCSFxGXzmG9zcdLMtsA9CM+yy9a1rXrTwefd0k4=;
        b=uDUgsIFWkCAbgZpUVsXjZnHVBtT5AU2g2Tu3bHmPpimoSMu5Pt0D9DUupyK66NiDmr
         SFEsFzaU9DeZGgsQNEmiMdYaft+Prt2oiSZp3IwXkNZcxt/HhMRiefuYPbdbHk207Kqk
         Ox0YHcUONluOucMlOfT29PUY08TWwE4IG1a6SaLfcUzRQriJ5ZteB9zJYi6UG87ywCfN
         JJHQnkpHwdqQk0KZ4i9o+jUIFEziT+WLlSsXAP0tJN8Igphnx/Aqlr/nyFJ/mvZPN5MB
         EXwGgSs6GpQKpUPrMqOtt2NwAzA19W1ixaml8FgEQbVfWvbklv/rk1W2DIbuFaxQ7f41
         yRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+hdtHCSFxGXzmG9zcdLMtsA9CM+yy9a1rXrTwefd0k4=;
        b=BnfYcBQP4rb7QNZGA4jlA19WvA375w8e5jU+ZtsfnBrT/i7G4oubqMdvzDVurgQ3bs
         Xwo1CGi2+DHiE9u1xxDjnAcNR52PqwAYPUdcP8Z7AykVWK31przQZfKAY+ai+9Xl56Ka
         yDUcTkWrIBT8JGFn8ZItDMmILRyG9v1v3bF/dK4JtWhiSZcfbWA8EUryAJnPS87OfDio
         7Zc347xfVkG6mT8XNuFNE2tc9Q35WDq2piAOUV4Y7yf1YskPHJgCVCxdOamuk7Hnyajk
         aoObUvMFsCUJu9h8SOlQFDvVTsksUzwpJKAmSvWHw+VxxW7JCHDf7I6mP5S8Q9dA0znM
         BTeQ==
X-Gm-Message-State: AOAM533OLhnAZ64M+vNouvbbFYosuusomNUoSPm0KNVj3qYy15VpEDzc
        V3jEb9NbIfoozYS55zVMlDOtSg==
X-Google-Smtp-Source: ABdhPJx/0woun/MhI7lJlAwq65ikInzHiKo9rw3lXUFvfj5s5Qs3xrAuB3tgEtBp9fISRu7oCo34FA==
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr809749wmm.122.1610480517946;
        Tue, 12 Jan 2021 11:41:57 -0800 (PST)
Received: from f2.redhat.com (bzq-79-183-72-147.red.bezeqint.net. [79.183.72.147])
        by smtp.gmail.com with ESMTPSA id z63sm4885315wme.8.2021.01.12.11.41.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Jan 2021 11:41:57 -0800 (PST)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        rdunlap@infradead.org, willemb@google.com, gustavoars@kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        nogikh@google.com, pablo@netfilter.org, decui@microsoft.com,
        cai@lca.pw, jakub@cloudflare.com, elver@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Cc:     yan@daynix.com
Subject: [RFC PATCH 1/7] skbuff: define field for hash report type
Date:   Tue, 12 Jan 2021 21:41:37 +0200
Message-Id: <20210112194143.1494-2-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112194143.1494-1-yuri.benditovich@daynix.com>
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used by virtio-net receive side scaling

Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
---
 include/linux/skbuff.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 416bf95cd5f2..36cf40ec0259 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -510,7 +510,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
  * the end of the header data, ie. at skb->end.
  */
 struct skb_shared_info {
-	__u8		__unused;
+	__u8		hash_report_type; /* virtio-net rss */
 	__u8		meta_len;
 	__u8		nr_frags;
 	__u8		tx_flags;
@@ -1430,6 +1430,11 @@ static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
 	return &skb_shinfo(skb)->hwtstamps;
 }
 
+static inline __u8 *skb_hash_report_type(struct sk_buff *skb)
+{
+	return &skb_shinfo(skb)->hash_report_type;
+}
+
 static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 {
 	bool is_zcopy = skb && skb_shinfo(skb)->tx_flags & SKBTX_DEV_ZEROCOPY;
-- 
2.17.1

