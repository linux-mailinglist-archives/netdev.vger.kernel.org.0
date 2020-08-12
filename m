Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EA02423CA
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 03:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgHLBeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 21:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgHLBeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 21:34:44 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D540FC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 18:34:43 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id r24so540443qtu.3
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 18:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=675zMfjuWI/5RZzSSTjyCW3mQvwhcbgO7fOjDuTwwNg=;
        b=OW9RlWTHwFrMxPGtD7zOK0lTv3Q3OJ/mtQAt1pKcGGFBclfLjO9bEnjZGHvNOZ/WT2
         5u4nEV0ZCrQ5s9dY75oXPrCztr8ucf1c+qA78SP391Ppg95/Uwz5nW5k1No+K//ZVISr
         wUVFcFwNYhj//CXUgjXtyDhjhURL/YuynMTVWsGM+CVIcmpUfVq0Qq/jUEvpZH1dE93D
         AtpirXQGVfsdXqV4aPSiej39tDucjRZgQiL01CKHANzKMqa3WgYNqU64I1KtjgOXU3a2
         7d9i2mvA3CPXv7rUOmHM1Ve49x6Noe+vhKF7HW1KaBBzp0AN71DnSHpShSXIZnn9OxGV
         XCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=675zMfjuWI/5RZzSSTjyCW3mQvwhcbgO7fOjDuTwwNg=;
        b=OMaEfDcUSzngFOFq2cQX7P3092sD0zKKRv4+nQBgl+kaKsngaeJpU6BHSvLPKl/6Bf
         uaNCXbpFXHusk+LRqJT9ISt52htzcgxFH+ZhmO81+6tcuMfZlweIIYP/RB4mlhJ/wA9m
         xg76frUH5lxW1r52XHwYCa5TuajPE3TDHCyZvh2LWvviPuT18uj3h80IXoXWu4yo08EQ
         34Cjk2ar6sM494Ec7I2dMLmHqwzzWgOzFih8Bh4K+ggunwN2HKrri1RPlHfZNy37OIpQ
         h/hUKNhE2yJ6LKV6tZq+8/MYTsqq55uTM1vYeIhqL6Z9gUfiA9AteS/d/SBPF6BE9WES
         zyXg==
X-Gm-Message-State: AOAM530CR+XB+ccjPlbND9fTCrNRrGHb49JON4SdvUzQ3m7Tkreq7RkI
        ZwXkUdtZZBfIPqEy/nj6Gk1T9bpRhQwPXA==
X-Google-Smtp-Source: ABdhPJwVYoo7OnprSvkV/uTFyPqaZd93jvNpUzLno4uatxf+1t/gpQLgF7NxUhoM/t3qFn7K0AX4BU8tUY9Q9A==
X-Received: by 2002:ad4:4302:: with SMTP id c2mr4251944qvs.246.1597196083004;
 Tue, 11 Aug 2020 18:34:43 -0700 (PDT)
Date:   Tue, 11 Aug 2020 18:34:40 -0700
Message-Id: <20200812013440.851707-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH net] net: accept an empty mask in /sys/class/net/*/queues/rx-*/rps_cpus
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>,
        Alex Belits <abelits@marvell.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We must accept an empty mask in store_rps_map(), or we are not able
to disable RPS on a queue.

Fixes: 07bbecb34106 ("net: Restrict receive packets queuing to housekeeping=
 CPUs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Maciej =C5=BBenczykowski <maze@google.com>
Cc: Alex Belits <abelits@marvell.com>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 net/core/net-sysfs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9de33b594ff2693c054022a42703c90084122444..efec66fa78b70b2fe5b0a592031=
7eb1d0415d9e3 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -757,11 +757,13 @@ static ssize_t store_rps_map(struct netdev_rx_queue *=
queue,
 		return err;
 	}
=20
-	hk_flags =3D HK_FLAG_DOMAIN | HK_FLAG_WQ;
-	cpumask_and(mask, mask, housekeeping_cpumask(hk_flags));
-	if (cpumask_empty(mask)) {
-		free_cpumask_var(mask);
-		return -EINVAL;
+	if (!cpumask_empty(mask)) {
+		hk_flags =3D HK_FLAG_DOMAIN | HK_FLAG_WQ;
+		cpumask_and(mask, mask, housekeeping_cpumask(hk_flags));
+		if (cpumask_empty(mask)) {
+			free_cpumask_var(mask);
+			return -EINVAL;
+		}
 	}
=20
 	map =3D kzalloc(max_t(unsigned int,
--=20
2.28.0.236.gb10cc79966-goog

