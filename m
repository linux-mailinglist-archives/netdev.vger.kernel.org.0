Return-Path: <netdev+bounces-7192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A0B71F0A5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9ED91C20A08
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 589384700D;
	Thu,  1 Jun 2023 17:22:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD7F4252C
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:22:04 +0000 (UTC)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3525F1A1
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:21:58 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b021cddb74so5738035ad.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685640117; x=1688232117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9j3narrsxe03huzqvKsSsW9jWi72TLYmmQBkxj0a2/Q=;
        b=KEYx5twPd+O8SA7JfI1OmQDyCGO+RfmBgA8+b1bhzTRsdGE5JXm9ZjX2I3zNs36QNt
         MSNrFV/EPqv1rlH276g+w3nC3+YVr6lJyuuxhk9kKU1JoY9CqaVxwK9oHiblKSXDGQPV
         owM5/BpCr71G9me5zvSAZR9S9o98TxxBm/LMCV9DkpRkInxblJ+4c5OcsmNbBsmis4OM
         29VL1cZXTCadFvyzP5YoZUwJEVmoSDj5qJgi1IduQcS1CfV9dP+Pe6pKe18fiO4xyA63
         XquN9N8CWLsSHKOKutjbAOHAQN3O0TNpa9mGasAjYj5j//Bx9knWhHbFEMUDiHFge5sh
         fSYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640117; x=1688232117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9j3narrsxe03huzqvKsSsW9jWi72TLYmmQBkxj0a2/Q=;
        b=IdXhsE3OJcZfFrtOTM2YSSLxtayPlqfODc/8tlkgZmu06DsjynpEhtogkgVOlwo4we
         jbskQBkbUnyIbZrlqyuQMDQf9/T6GpwhAwFf7Zz8Jr4lZUxFJyMFRg6LJAmp93KdfvYE
         iqV+k/VIN01DzXUgTSnD5zvIeuAohmMlBzAlJD6gj5OApZsrsx3KnOSz5PeGVa5lVRxC
         wn/5DPs6TG24Z+I7SGPgJg5clTkSHjUaCN/QZHFDpuYE1WCDfdwgERY9bZzPP4pKpOed
         NHI8EHVuqU3XEcADgKGDUVXfUHNMyKM+y6tLvteKJkrLmbQ1B5fqutLIAroBCdu8XBAG
         G19Q==
X-Gm-Message-State: AC+VfDx5+0ruSz9whgD0olZMHUPSkrrmPnx8fRbMnyfmeeEOQWoCEGMF
	wEmFAxALRea5RCBR7tILQaTTwgBZ3VeyDw6k/gFzKg==
X-Google-Smtp-Source: ACHHUZ69Pkn5lUIVNzFfEdC4BcORl/qWiATSJSkJVB+EKH3nAoSMnrs87OUraUJi1/5b3OyEobO9kQ==
X-Received: by 2002:a17:902:dac7:b0:1ac:8837:de9 with SMTP id q7-20020a170902dac700b001ac88370de9mr134946plx.3.1685640117453;
        Thu, 01 Jun 2023 10:21:57 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902760600b001b1920cffdasm2378945pll.204.2023.06.01.10.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 10:21:56 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	bridge@lists.linux-foundation.org
Subject: [PATCH iproute2 3/7] bridge: make print_vlan_info static
Date: Thu,  1 Jun 2023 10:21:41 -0700
Message-Id: <20230601172145.51357-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230601172145.51357-1-stephen@networkplumber.org>
References: <20230601172145.51357-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Function defined and used in only one file.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 bridge/br_common.h | 1 -
 bridge/vlan.c      | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index 1bdee65844c1..704e76b0acb2 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -6,7 +6,6 @@
 #define MDB_RTR_RTA(r) \
 		((struct rtattr *)(((char *)(r)) + RTA_ALIGN(sizeof(__u32))))
 
-void print_vlan_info(struct rtattr *tb, int ifindex);
 int print_linkinfo(struct nlmsghdr *n, void *arg);
 int print_mdb_mon(struct nlmsghdr *n, void *arg);
 int print_fdb(struct nlmsghdr *n, void *arg);
diff --git a/bridge/vlan.c b/bridge/vlan.c
index 5b304ea94224..dfc62f83a5df 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -18,6 +18,7 @@
 
 static unsigned int filter_index, filter_vlan;
 static int vlan_rtm_cur_ifidx = -1;
+static void print_vlan_info(struct rtattr *tb, int ifindex);
 
 enum vlan_show_subject {
 	VLAN_SHOW_VLAN,
@@ -1309,7 +1310,7 @@ static int vlan_global_show(int argc, char **argv)
 	return 0;
 }
 
-void print_vlan_info(struct rtattr *tb, int ifindex)
+static void print_vlan_info(struct rtattr *tb, int ifindex)
 {
 	struct rtattr *i, *list = tb;
 	int rem = RTA_PAYLOAD(list);
-- 
2.39.2


