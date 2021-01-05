Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2442EAAA0
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbhAEMZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbhAEMZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:25:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B7CC06179F
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 04:24:33 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a12so35966030wrv.8
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 04:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RENS1yiCoqDoLkKN/GRTnjThUIFO+qOBX6TnsDEXMJ4=;
        b=Rsjc+UbI6l1AKroxhh3v0TqyRX6k81MRpq+7OB6mC3k6sYU270+X7iDmnPcUJwrq4H
         QB9Go38farUyWX6zlc1p2fQCfYdkXNd/NVwmFAxjZj30JF5wv/1987mxINy3Vl3ySTjl
         ArjkurbUGoZGDnC4NKIImUw8OBGE1O796zl91v3MgCWXUyb/XY60ZHTqlaNuwhnrH6Y+
         PCC8FtYIt1sOuS1sR5Kyzo4RdPZoiW8SUnXpqT2voCdoqGrMqI1dSRX1j04Tt2ScerCi
         nWCywRHrCIVN3UlXN1eB9d/uliwbj94xC5PgNvjNHwNXT3/VEG+IaIQHlxx8W+M1LMHb
         aFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RENS1yiCoqDoLkKN/GRTnjThUIFO+qOBX6TnsDEXMJ4=;
        b=EVdDb9jwoBpvwXb5FHHYUtGte8lh1zrN27I9ku/9PgiyvU9E4LqUL+ph94CN6vFP2/
         m/p5qIHxOcYcOkcqxs7OZuoau2pszdfqyHx1h40+JAna/QfR2oFhNcdUxIUl2DhK3hAE
         VK9OgvRAKYKEwV5HkXd5z+qSxri1QhVf9ydyIKM0qx6nsDjrVTkyBqTHajbq0rpgw4Ws
         cs+7e4Tt6EDuBohl3AhKa8O3Oo857deuGvZ91gsOKneFWPPkqySIi0Qf09z1BvNqLhJf
         ePe4TRul7/J7acjioD2ls60C710qj9nHABT9ii3HLxvucuUkNWAFhN8mI538lsF5Sgl2
         fdeQ==
X-Gm-Message-State: AOAM532bIo9Bj6Q3NlMZ4OYlR/TMiEXKFPJRmge2jbhWUfIecOQ0Z6Hb
        5BNoVrHuMgNWRA1Ab3aspptrQg==
X-Google-Smtp-Source: ABdhPJwUKO0ye0ZNgsk1g3yOggrEXv0KCoEdblfRWwUU30iRrMbnsJIJGtAgBYucbZzegbuNHb95LA==
X-Received: by 2002:adf:94c7:: with SMTP id 65mr82268745wrr.423.1609849472424;
        Tue, 05 Jan 2021 04:24:32 -0800 (PST)
Received: from f2.redhat.com (bzq-79-183-72-147.red.bezeqint.net. [79.183.72.147])
        by smtp.gmail.com with ESMTPSA id 138sm4242281wma.41.2021.01.05.04.24.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 04:24:31 -0800 (PST)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     yan@daynix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [RFC PATCH 3/7] tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
Date:   Tue,  5 Jan 2021 14:24:12 +0200
Message-Id: <20210105122416.16492-4-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105122416.16492-1-yuri.benditovich@daynix.com>
References: <20210105122416.16492-1-yuri.benditovich@daynix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This program type can set skb hash value. It will be useful
when the tun will support hash reporting feature if virtio-net.

Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
---
 drivers/net/tun.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7959b5c2d11f..455f7afc1f36 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2981,6 +2981,8 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
 		prog = NULL;
 	} else {
 		prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
+		if (IS_ERR(prog))
+			prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SCHED_CLS);
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 	}
-- 
2.17.1

