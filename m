Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A4030E744
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhBCXZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbhBCXZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:25:24 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E83C061786
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 15:24:43 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id nm1so596598pjb.3
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vzspAmAcRNQhzg+74nh8k/ZFIHJ7BPO1bSEKZDqWSjE=;
        b=NW3HcaA3JcBMgPcIclSZxdbmtGVRCtEWA9ymzHdhrtpiycarvIaEzlYjH0u5WX6pbZ
         gg2urH3JL6IrbywWz1TDJhbJG5aNr9cYEvFqIrnXZZeniUfKa7rRPqZfMmC4XtndvQAJ
         e8QfF/MiUo4C7VeJW+6jO+C9kBgzYfi6lJKPT4MCAUle+RNpcgqQZdfpsjM0EA8RsPbo
         jCRfFQwWM+hHNJwLihnKb197Gc5toqoHklMu3QEkovuHgH9CKYlZCNUvppxs5z9bKmvF
         OWxzMzatJTpBiIlVMTVwjLbbIu9oVwrgMtXCr5a6AP5bSMUbEZexLTFe0CVanHCYpZDl
         ZvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vzspAmAcRNQhzg+74nh8k/ZFIHJ7BPO1bSEKZDqWSjE=;
        b=AZJJAhSI5XtEmyUkZviDheltdL/7kA0v3u6oJrZvsgIfY7ZQ53LRsM1QS74CsFEaap
         e+86KERLsIeGrzcqdrF7WURNgF56Ndps+sOhxGpSFGvS984eVbOk6bZS71gmscYKl/rq
         J+TRX8gwgVIzvSLtORGT5ohQ9p++Tq/q7tKcYnFTSDPFKu1j6992N4j2cuNTHmDf0Zw7
         9C9GXJzPhz6D42QM181R30mGQ4OGcP+nQcYKDi9M7cZa4WsejQ70RKZt8bM/9eXUmHBn
         C+sVEFyy6pTYD0jd3efvWQc+cSIJuyq65WktAuuzD9ACxLVfGvDp9kY3e765kHoyhqeu
         iPmA==
X-Gm-Message-State: AOAM532N72NJ0b6eibnwYc+2UqRYcGU4GzUnPbMJyMNb84WWJQFNRnqB
        Vk/e46krOin4yGkSXcZkf8E=
X-Google-Smtp-Source: ABdhPJxWGJTH9IKoL+QUVb9loryP9p5JtNHGFJ1SjAC4bcypgRMkbQxHHkWYX5PXbK/3r20fUNf+6g==
X-Received: by 2002:a17:902:bd85:b029:e1:bbf:3603 with SMTP id q5-20020a170902bd85b02900e10bbf3603mr5224794pls.29.1612394683306;
        Wed, 03 Feb 2021 15:24:43 -0800 (PST)
Received: from localhost.localdomain (h134-215-163-197.lapior.broadband.dynamic.tds.net. [134.215.163.197])
        by smtp.gmail.com with ESMTPSA id i28sm3368870pfk.51.2021.02.03.15.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:24:42 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V2 net-next 3/5] net: add sysctl for enabling RFC 8335 PROBE messages
Date:   Wed,  3 Feb 2021 15:24:41 -0800
Message-Id: <9d167c46fbfb38ab8559695524b5a84449855e1b.1612393368.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Section 8 of RFC 8335 specifies potential security concerns of
responding to PROBE requests, and states that nodes that support PROBE
functionality MUST be able to enable/disable responses and it is
disabled by default. 

Add sysctl to enable responses to PROBE messages. 

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Combine patches related to sysctl into one patch
---
 include/net/netns/ipv4.h   | 1 +
 net/ipv4/sysctl_net_ipv4.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 70a2a085dd1a..362388ab40c8 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -85,6 +85,7 @@ struct netns_ipv4 {
 #endif
 
 	int sysctl_icmp_echo_ignore_all;
+	int sysctl_icmp_echo_enable_probe;
 	int sysctl_icmp_echo_ignore_broadcasts;
 	int sysctl_icmp_ignore_bogus_error_responses;
 	int sysctl_icmp_ratelimit;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index e5798b3b59d2..06b7241bc01d 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -599,6 +599,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "icmp_echo_enable_probe",
+		.data		= &init_net.ipv4.sysctl_icmp_echo_enable_probe,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{
 		.procname	= "icmp_echo_ignore_broadcasts",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_broadcasts,
-- 
2.25.1

