Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97DFE1823
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404546AbfJWKjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404434AbfJWKjD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 06:39:03 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B8220663;
        Wed, 23 Oct 2019 10:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571827142;
        bh=5AK0STRJe83V/D3fkEmXSMTubrLSJu1+Jpg5Pyef9/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4IGdXR95KwimHkjPdhFU+qv0y/m+/vTlkmkyd/q1uYVfYD5bHgSfb76XbwLfsGte
         t+EQXNLT4m2DR/EfBRY9LHPn8BQzRnX6UeTeXTHJel/kI5BcifTNMByvVOz5M4JUWq
         1NIFb6695zUanvtd6D5MQjFNIfHoPobGDmVbnUa8=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 2/2] rdma: Document MR statistics
Date:   Wed, 23 Oct 2019 13:38:54 +0300
Message-Id: <20191023103854.5981-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023103854.5981-1-leon@kernel.org>
References: <20191023103854.5981-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Alfasi <ereza@mellanox.com>

Add document of accessing the MR counters into
the rdma-statistic man pages.

Signed-off-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 man/man8/rdma-statistic.8 | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/man/man8/rdma-statistic.8 b/man/man8/rdma-statistic.8
index dea6ff24..541b5d63 100644
--- a/man/man8/rdma-statistic.8
+++ b/man/man8/rdma-statistic.8
@@ -1,4 +1,4 @@
-.TH RDMA\-STATISTIC 8 "17 Mar 2019" "iproute2" "Linux"
+.TH RDMA\-STATISTIC 8 "27 June 2019" "iproute2" "Linux"
 .SH NAME
 rdma-statistic \- RDMA statistic counter configuration
 .SH SYNOPSIS
@@ -15,7 +15,7 @@ rdma-statistic \- RDMA statistic counter configuration
 
 .ti -8
 .B rdma statistic
-.RI "[ " OBJECT " ]"
+.RI "{ " OBJECT " }"
 .B show
 
 .ti -8
@@ -63,7 +63,7 @@ rdma-statistic \- RDMA statistic counter configuration
 
 .ti -8
 .IR OBJECT " := "
-.RB "{ " qp " }"
+.RB "{ " qp " | " mr " }"
 
 .ti -8
 .IR CRITERIA " := "
@@ -80,13 +80,13 @@ rdma-statistic \- RDMA statistic counter configuration
 - specifies counters on this RDMA port to show.
 
 .SS rdma statistic <object> set - configure counter statistic auto-mode for a specific device/port
-In auto mode all objects belong to one category are bind automatically to a single counter set.
+In auto mode all objects belong to one category are bind automatically to a single counter set. Not applicable for MR's.
 
 .SS rdma statistic <object> bind - manually bind an object (e.g., a qp) with a counter
-When bound the statistics of this object are available in this counter.
+When bound the statistics of this object are available in this counter. Not applicable for MR's.
 
 .SS rdma statistic <object> unbind - manually unbind an object (e.g., a qp) from the counter previously bound
-When unbound the statistics of this object are no longer available in this counter; And if object id is not specified then all objects on this counter will be unbound.
+When unbound the statistics of this object are no longer available in this counter; And if object id is not specified then all objects on this counter will be unbound. Not applicable for MR's.
 
 .I "COUNTER-ID"
 - specifies the id of the counter to be bound.
@@ -152,9 +152,16 @@ On device mlx5_2 port 1, bind the specified qp on the specified counter
 rdma statistic qp unbind link mlx5_2/1 cntn 4
 .RS 4
 On device mlx5_2 port 1, unbind all QPs on the specified counter. After that this counter will be released automatically by the kernel.
-
 .RE
 .PP
+rdma statistic show mr
+.RS 4
+List all currently allocated MR's and their counters.
+.RE
+.PP
+rdma statistic show mr mrn 6
+.RS 4
+Dump a specific MR statistics with mrn 6. Dumps nothing if does not exists.
 
 .SH SEE ALSO
 .BR rdma (8),
@@ -163,5 +170,7 @@ On device mlx5_2 port 1, unbind all QPs on the specified counter. After that thi
 .BR rdma-resource (8),
 .br
 
-.SH AUTHOR
+.SH AUTHORS
 Mark Zhang <markz@mellanox.com>
+.br
+Erez Alfasi <ereza@mellanox.com>
-- 
2.20.1

