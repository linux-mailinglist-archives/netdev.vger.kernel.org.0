Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32F8C1A21
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 04:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfI3CJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 22:09:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41468 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729394AbfI3CJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 22:09:15 -0400
Received: by mail-pl1-f196.google.com with SMTP id t10so3273150plr.8
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 19:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3N8AYSTn8Cd+SI4v+ldKV2ux7udULZm8tazu3f3NRMU=;
        b=HrrBHCQDhJmBXEjuLbPHoUgefvdA2y0VHPf9FM8OYi8/0uji9GhbSLEuKGZC2YED0Z
         AR61r6hZLK+GCWjyxywAxI8C0DzGBCQ9ZJAEpmuWAVWE9PRHmi9kP86TmQQDlutMAPSd
         cNaHCksAUlMZPQw4XLFeIygIzBUWgOqOqy5zyJOjjTnSKG6svATFWq5d5B7ZsThKkJkd
         iwDUdpkgOyoeyiURnmzifONijnxCwQO/w6KCMM5n0s5m+14wQDk7flx6DhknYCzi9s44
         Mq1fQwJJlZ/sNHoHh0fpaI044iQbjziT1sRji/4WTQ78dGnGr242cmp5Ew1B5DyeqQS6
         SvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3N8AYSTn8Cd+SI4v+ldKV2ux7udULZm8tazu3f3NRMU=;
        b=aN14oSDiMbVVyeLKdHweDmNxfW/xZksD1FPwEmVIFQ6iMBD4JHg8jWSpL5YfofLJHG
         Gtiti/qtIj8igbt5ps1g93aDjQVZW0UZTnVoRzXItoyw6If8mdvl6dGmKYJljNecVNPL
         u81hycInzWCDTp8ucAUHZvESVh4tzZDo9VZjNxHF5n5wFBzibXnMuRuTjC4GitWHsN94
         W8JeR5YfdnlR5cUF9nsB8KkD9k7JgBElGAfWnbRq34o8KUq8WYrMP5plnTL2KyoFvBxn
         hobzRiM9EwXQThKzmf55O3Gzxb5HiP07ToB0BDdGBe45CtLVsiRPfwLkFpUgw6rzeNVn
         PF7A==
X-Gm-Message-State: APjAAAX2KqCBHWDXwzljpBDTRYVry41zZAgmiSebQYp3Q4zNEgnIv7GW
        zMRVKiFXdggjNJddldvJQdg=
X-Google-Smtp-Source: APXvYqxECPw/IcERwc8ewUNy32DH4WaGdq36hnbm8y67+Dxwo4vxNP6L02ivCLnA4RO2cDS5MNMe/A==
X-Received: by 2002:a17:902:6e17:: with SMTP id u23mr17624863plk.205.1569809353136;
        Sun, 29 Sep 2019 19:09:13 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d69sm9941635pfd.175.2019.09.29.19.09.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 19:09:12 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 7/9] net: openvswitch: add likely in flow_lookup
Date:   Mon, 30 Sep 2019 01:10:04 +0800
Message-Id: <1569777006-7435-8-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The most case *index < ma->max, we add likely for performance.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index c8e79c1..c21fd52 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -526,7 +526,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 	struct sw_flow_mask *mask;
 	int i;
 
-	if (*index < ma->max) {
+	if (likely(*index < ma->max)) {
 		mask = rcu_dereference_ovsl(ma->masks[*index]);
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
-- 
1.8.3.1

