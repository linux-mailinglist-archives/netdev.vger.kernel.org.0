Return-Path: <netdev+bounces-1583-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6E06FE5E8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0E931C20E39
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DFA21CEE;
	Wed, 10 May 2023 21:01:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9874A21CC3
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:01:12 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800CBCA
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:00:53 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-643990c5319so5537124b3a.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683752442; x=1686344442;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c6CstLFy4vW5ZUbG5PU++myYvkHeSQCfnFEUOsN8lzk=;
        b=s8bkr9DhLmER2xNhaHjJmwxPaHTXwWN/kQ2xETdZkGqKdpZec8zhxslqhRVoENpyBS
         y88QX0zhvNAt976B2am97gqN6FebXOdzbaqT2bhj1opOqnP4Dm/QeEEjITkaJBHKo1OQ
         5hocNF/StYAja5ZqneVE9CEbbHOnCtUk7StfMnksS/3Ok9qbwbN+ndSqeMzVmxZC5Vib
         NlNgteQDuo/fNo3B6gniXN/ilfOITh/ZeftJRv5S8BcqERvgml685/JmkUoFXMORbhiQ
         +yAhgwXLYuGuHwYzbYcv+90aJ9GGXeSo3LsGU3Emi5AD1cNG2cdZXsf0GBH7YprYsHE6
         W1Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683752442; x=1686344442;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c6CstLFy4vW5ZUbG5PU++myYvkHeSQCfnFEUOsN8lzk=;
        b=Dy7IIjl+y8b8iiShHl1pNWkG/k67LLNI7zgv4yw4n9qcH0onmZNnAx+8yFJB/MZKzR
         BBjxlnEqjQObKyt+v6on4LTRO6Puto8P/OqTuZZaMLNDXta7YL2HzavlLUEMo6akaS6Z
         OQKhWfenUlacbrZclFFaZuMXb/pwya219oLT/DPZb+fbV1EQmQ9tS86jLBLy8/9Ya+8+
         TpAev9jUc8YKYE4RtDumjhqwRbjS/9DljG3Oj5s4aDTnAqMyzNQZ6WNEa+ZXP/hufcf1
         8qS/7GrbnrJGVWsk63x6E/nleEYU1ZyxQvLYtKRXz3hTyHoF1dyD3oaw84qB0YyGAauu
         QHmA==
X-Gm-Message-State: AC+VfDxFALypqXuajzB/Q/JpQdmZX+6TcV9C1emXcygodkQcRF2cvfAM
	qJBp+qtqiq00yJ1cs6ZM1dANxZdxr6Wn12s/401iRg==
X-Google-Smtp-Source: ACHHUZ7bELp2cUoJR+gjP2axO0tX568tLNcqDAQ0EmNKgns31JGftGJZnQDIQRTxwYRnXLmgre8hAQ==
X-Received: by 2002:a05:6a00:1a4f:b0:644:2718:dd40 with SMTP id h15-20020a056a001a4f00b006442718dd40mr18327338pfv.30.1683752442282;
        Wed, 10 May 2023 14:00:42 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id j23-20020aa78dd7000000b00640f895fde9sm3895442pfr.214.2023.05.10.14.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 14:00:41 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: me@pmachata.org,
	jiri@resnulli.us,
	jmaloy@redhat.com,
	parav@nvidia.com,
	elic@nvidia.com,
	Stephen Hemminger <stephen@networkplumber.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2] Add MAINTAINERS file
Date: Wed, 10 May 2023 14:00:40 -0700
Message-Id: <20230510210040.42325-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
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

Record the maintainers of subsections of iproute2.
The subtree maintainers are based off of most recent current
patches and maintainer of kernel portion of that subsystem.

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 MAINTAINERS | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 MAINTAINERS

diff --git a/MAINTAINERS b/MAINTAINERS
new file mode 100644
index 000000000000..fa720f686ba8
--- /dev/null
+++ b/MAINTAINERS
@@ -0,0 +1,49 @@
+Iproute2 Maintainers
+====================
+
+The file provides a set of names that are are able to help
+review patches and answer questions. This is in addition to
+the netdev@vger.kernel.org mailing list used for all iproute2
+and kernel networking.
+
+Descriptions of section entries:
+
+	M: Maintainer's Full Name <address@domain>
+	T: Git tree location.
+	F: Files and directories with wildcard patterns.
+	   A trailing slash includes all files and subdirectory files.
+	   A wildcard includes all files but not subdirectories.
+	   One pattern per line. Multiple F: lines acceptable.
+
+Main Branch
+M: Stephen Hemminger <stephen@networkplumber.org>
+T: git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
+L: netdev@vger.kernel.org
+
+Next Tree
+M: David Ahern <dsahern@gmail.com>
+T: git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git
+L: netdev@vger.kernel.org
+
+Ethernet Bridging - bridge
+M: Roopa Prabhu <roopa@nvidia.com>
+M: Nikolay Aleksandrov <razor@blackwall.org>
+L: bridge@lists.linux-foundation.org (moderated for non-subscribers)
+F: bridge/*
+
+Data Center Bridging - dcb
+M: Petr Machata <me@pmachata.org>
+F: dcb/*
+
+Device Link - devlink
+M: Jiri Pirko <jiri@resnulli.us>
+F: devlink/*
+
+Transparent Inter-Process Communication - Tipc
+M: Jon Maloy <jmaloy@redhat.com>
+F: tipc/*
+
+Virtual Datapath Accelration - Vdpa
+M: Parav Pandit <parav@nvidia.com>
+M: Eli Cohen <elic@nvidia.com>
+F: vdpa/*
-- 
2.39.2


