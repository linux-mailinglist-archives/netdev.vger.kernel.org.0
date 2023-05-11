Return-Path: <netdev+bounces-1894-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 877986FF6A4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 712CD1C20FA5
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41ECF3D9F;
	Thu, 11 May 2023 16:00:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B26629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:00:08 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE04330CA
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:00:05 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-643990c5319so6293920b3a.2
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683820805; x=1686412805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HRby3KQnf13W5uQ0vU72zWMJwZ8g+l5Gnx6TDobjZtk=;
        b=rX5YVgdsh7xFfgrRdC0BvPix0brNBlAiDsDxC+VbWFMftjW54mrq0UM4cvYm/6bvvF
         JkhaZYPythaDGQfQ13vmHUkfqSkkLyQvFk/VWfdn0bliIVAkCVrIWyLjkB9qa5ryR/oU
         UlNHYy7q8wjw8CBWdSV9uEfBeTXjN8bm/bE5SUwYd5TFV6llfl2zBQDhzqbl14+bxu0J
         O+XJlsArE2lKCV7jWJH9iYaVtxaY37rVc5Iu2zyBd/pZP3WGe2E6e+rGOpiM+F9v6BI3
         05c/YIr1si2dtdQsG348+7+rRnEy6ze5ShkNcxfgk5YqfsHKWwVLSHJvKwu5S69CVoZV
         BzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683820805; x=1686412805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HRby3KQnf13W5uQ0vU72zWMJwZ8g+l5Gnx6TDobjZtk=;
        b=C4/BneDc7XlZC6fQoW+MRp9kmhbG4Q2fvAWk0G0oBpAMcngIrC8Vz+ZO6MKLPv3NYG
         /i9343e0YJgQUyZi/SWYOlsBU7BJI1v3y9hZTP/U/HbLm0rme3rGI5Ay3s0gMYfdVLmC
         fS/pQlNBQQPTyrepwY9qGQ0FpnhNd1K+varTKiYXcE4XCfYdHu8IfZmEcB/pmDA971wj
         FAnxIkie3Lov8aVVRjJBynU60tQ7MzwWg7XEoZc0vTpGKqlfkb+CKx2Vn9OafvJzbq8B
         IpJMjZ5nfagalOGwNa6uOd4I43cG6TDpshaxIRpvytKzgpQDv9jdDUiOD4zkMhFqf6I2
         jtEQ==
X-Gm-Message-State: AC+VfDwc7jACL5IxWFEGqM+THFdNIdNMBh4Jc2xWOIrR8QEyWu1AH7bg
	QHJqQN0CHkB+IJMbPKR+egATsAjtS57jQI7jROZsxw==
X-Google-Smtp-Source: ACHHUZ7rV5I8MmNWtLCne+GLgmhekJffzSJtX3TBFlU1NqNr6KnIfROhsDqFUVz3RBMwH3c2wSrzCQ==
X-Received: by 2002:a05:6a00:240b:b0:639:28de:a91e with SMTP id z11-20020a056a00240b00b0063928dea91emr26585895pfh.17.1683820804871;
        Thu, 11 May 2023 09:00:04 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x20-20020aa793b4000000b0063d2bb0d107sm5525883pff.64.2023.05.11.09.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 09:00:04 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: me@pmachata.org,
	jiri@resnulli.us,
	jmaloy@redhat.com,
	parav@nvidia.com,
	Stephen Hemminger <stephen@networkplumber.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2 v2] Add MAINTAINERS file
Date: Thu, 11 May 2023 09:00:02 -0700
Message-Id: <20230511160002.25439-1-stephen@networkplumber.org>
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
Acked-by: Petr Machata <me@pmachata.org> # For DCB
Acked-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 MAINTAINERS | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 MAINTAINERS

diff --git a/MAINTAINERS b/MAINTAINERS
new file mode 100644
index 000000000000..ec193fd8459a
--- /dev/null
+++ b/MAINTAINERS
@@ -0,0 +1,53 @@
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
+devlink
+M: Jiri Pirko <jiri@resnulli.us>
+F: devlink/*
+
+Remote DMA - rdma
+M: Leon Romanovsky <leon@kernel.org>
+F: rdma/*
+
+Transparent Inter-Process Communication - tipc
+M: Jon Maloy <jmaloy@redhat.com>
+F: tipc/*
+
+Virtual Datapath Accelration - vdpa
+M: Parav Pandit <parav@nvidia.com>
+M: Eli Cohen <elic@nvidia.com>
+F: vdpa/*
-- 
2.39.2


