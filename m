Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85AFBEDBF
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfIZIrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:47:36 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44870 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729796AbfIZIrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 04:47:35 -0400
Received: by mail-pf1-f195.google.com with SMTP id q21so1414327pfn.11
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 01:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PkpaOHs/sE044m5RxbVsVjFlZYsusmNZ0HrX5q5KwCc=;
        b=QLNDotYxwlGyC65QixoJr9otbjjcm4GLiLHMWkPUQ4hKHSf9lqlsJOO9JODe7YAU34
         RGjDY/toeXbvlyXKfk61gMEJN6f8X6Zb4hTL2HNZarzstVNdStcCE/TJ77xM7fZTUvjZ
         vLBzM80P7L/4f6Q2cVymG+hvcAqzKYDIpIKbV7EBds32HBiTHSTRHyPqrKhPtozLBacE
         WfMLEgiic1pNYzcg7XOKdXFRFdM0k/w6zT7mXpeMTYmqNdQjW8DM9UelMyp5E/4uuMmm
         o77VUDktTWyCLlS+HNNhL8/MYR+W5AZtFwRNJzLPqs1BZjL+V3Hy13+UbBirFAXs70b4
         hFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PkpaOHs/sE044m5RxbVsVjFlZYsusmNZ0HrX5q5KwCc=;
        b=q2dIsnQmQ03nk+WfsaqDROGFkTsLMeFwQtabqg5GaVS0MJgi3psbsEt6zaE7gx60A2
         NXp2iLmv4Ng2iITjUQtcSiQIv+p7axgXMougk1iX/3FPEM3tuihhJ3ZvCp35NQPvq/+g
         N/gqAtpmC9GWnqNcErfJL8uWw3yqb/IDFv8+/Jhqw196XHHlQTyDUqNU80s0yheBU6oM
         cN+zJW+2xf8t/1VcP0Rmximn1cHOWA2Av83VVKKdp+oxzzCQxXtwtvfRQ3ele7DyBX0p
         YNzZBErklsUDRWwZoS0XVjMeSOZX6q+6B8Oit3G2ju6+rthWIo851EvnOC2jpACAHy4T
         K2wg==
X-Gm-Message-State: APjAAAXyxp5LZKu0bGGH68sd5t0bb4SX42LRsansb/0IdfNqHzGPnHc0
        H7IMMuuMIyVs05yFygWPbrnwHKEkO3c=
X-Google-Smtp-Source: APXvYqxGg+yhfQRY2Yfs39rVaBEecUaiMFmzPR0m6f4V75R63MbJ7Ke+VIAhAkImS1/KQShqpD5gmQ==
X-Received: by 2002:a63:5745:: with SMTP id h5mr2328424pgm.268.1569487654780;
        Thu, 26 Sep 2019 01:47:34 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id t12sm1340513pjq.18.2019.09.26.01.47.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:47:34 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 7/7] net: openvswitch: add likely in flow_lookup
Date:   Fri, 20 Sep 2019 00:54:53 +0800
Message-Id: <1568912093-68535-8-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index 223470a..bd7e976 100644
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

