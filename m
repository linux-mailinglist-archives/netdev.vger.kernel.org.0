Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C102346FFE
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 04:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhCXDLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 23:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbhCXDLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 23:11:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10D5C061763;
        Tue, 23 Mar 2021 20:11:07 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so1922840pjb.0;
        Tue, 23 Mar 2021 20:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=43zFUh5JGMOMp8MUHQANgEucBE0ErwaCoz3su/SHSxA=;
        b=TmQeNKjnbgllO3aOkJjCSUofzMaZwwqGP7rLV3ygCgKLFhLF0/UxFcBFgiU3s/g+OB
         1VMc7b+gyrXnWOV6rpYQfuT9NKRvc4UpfA79G/C9TDRQAObUOH1iCEdp8JOkDlSj54LU
         SDm8CZux11uZpPFw6Zsusd5OAcgMYoxyCqvmUG+9pbJzpvp7kgC41Yj8Fgjvc7rkJAfi
         9qTIxMTbFg5SW8TbtydQh2AshJnSi4za1a6jSEiCWsCLeedCK6OyxKdGQd4rgCon43jx
         8Rl33YyMx0Csex5DZaP3IoDjLsiQQz2hBEL6f7cMorJ88k7Eru3i00Q3x+S8dV7ZDAdZ
         QMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=43zFUh5JGMOMp8MUHQANgEucBE0ErwaCoz3su/SHSxA=;
        b=GiRMLPHl7ksxxrLqq36lobAWz/sq7be02c/i6iJY3b032t6myHaAZmqWrWsmorkoJ3
         CJmvlSy/CzaavmaxacPVoO7LGs4J7MMedNIjNHaLydbsmhiLdYvrfuPIDN1mz0cNlECW
         Roy0QjifqNkbXro858eOkgLxaetWfWusfcCrNHnrNecxfdd0Oav+8WCXyHnqZyyiDoXe
         8asBeAzv3+6BjmB6Ot0qoJdh3RfL+zSuhClvImFXDz5z470EPAxZYemdT7CSH1alUKhA
         /vGN8gviVDthFxxz06g3rhchnHE6/nBYCul4CjFyPIJaM8yvQDHiWdVpZewvPtgbdOhz
         ClGw==
X-Gm-Message-State: AOAM531QnjAhL8EWBu24D93WlV6mm4ZXN5bmE4VavKe/Tw3bUbXMxaWD
        BVxoC2e2HRMqjeQqaycCfwA=
X-Google-Smtp-Source: ABdhPJx/iaamRUWssc7bKcWRDYA20vqMQ9DFun3MY2ajor+L/slzV/pMiIwAgTtlZkXj8YAOLEUKvg==
X-Received: by 2002:a17:902:82c7:b029:e4:74ad:9450 with SMTP id u7-20020a17090282c7b02900e474ad9450mr1608370plz.58.1616555467584;
        Tue, 23 Mar 2021 20:11:07 -0700 (PDT)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id 22sm488166pjl.31.2021.03.23.20.11.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Mar 2021 20:11:07 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune@gmail.com, Yejune Deng <yejune.deng@gmail.com>
Subject: [PATCH 2/2] net: ipv4: route.c: Remove unnecessary if()
Date:   Wed, 24 Mar 2021 11:10:57 +0800
Message-Id: <20210324031057.17416-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

negative_advice handler is only called when dst is non-NULL hence the
'if (rt)' check can be removed. 'if' and 'else if' can be merged together.
And use container_of() instead of (struct rtable *).

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ipv4/route.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 5762d9bc671c..f4ba07c5c1b1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -814,19 +814,15 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
 
 static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst)
 {
-	struct rtable *rt = (struct rtable *)dst;
+	struct rtable *rt = container_of(dst, struct rtable, dst);
 	struct dst_entry *ret = dst;
 
-	if (rt) {
-		if (dst->obsolete > 0) {
-			ip_rt_put(rt);
-			ret = NULL;
-		} else if ((rt->rt_flags & RTCF_REDIRECTED) ||
-			   rt->dst.expires) {
-			ip_rt_put(rt);
-			ret = NULL;
-		}
+	if (dst->obsolete > 0 || rt->dst.expires ||
+	    (rt->rt_flags & RTCF_REDIRECTED)) {
+		ip_rt_put(rt);
+		ret = NULL;
 	}
+
 	return ret;
 }
 
-- 
2.29.0

