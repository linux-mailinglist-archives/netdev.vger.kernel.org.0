Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40D1251D7
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfEUOW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:22:58 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57780 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728293AbfEUOW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:22:57 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 May 2019 17:22:52 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x4LEMlHt023035;
        Tue, 21 May 2019 17:22:51 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        stephen@networkplumber.org, leonro@mellanox.com, parav@mellanox.com
Subject: [PATCH iproute2-next 2/4] rdma: Add man pages for rdma system commands
Date:   Tue, 21 May 2019 09:22:42 -0500
Message-Id: <20190521142244.8452-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190521142244.8452-1-parav@mellanox.com>
References: <20190521142244.8452-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 man/man8/rdma-system.8 | 82 ++++++++++++++++++++++++++++++++++++++++++
 man/man8/rdma.8        |  7 +++-
 2 files changed, 88 insertions(+), 1 deletion(-)
 create mode 100644 man/man8/rdma-system.8

diff --git a/man/man8/rdma-system.8 b/man/man8/rdma-system.8
new file mode 100644
index 00000000..a6873b52
--- /dev/null
+++ b/man/man8/rdma-system.8
@@ -0,0 +1,82 @@
+.TH RDMA\-SYSTEM 8 "06 Jul 2017" "iproute2" "Linux"
+.SH NAME
+rdma-system \- RDMA subsystem configuration
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B rdma
+.RI "[ " OPTIONS " ]"
+.B sys
+.RI  " { " COMMAND " | "
+.BR help " }"
+.sp
+
+.ti -8
+.IR OPTIONS " := { "
+\fB\-V\fR[\fIersion\fR] |
+\fB\-d\fR[\fIetails\fR] }
+
+.ti -8
+.B rdma system show
+
+.ti -8
+.B rdma system set
+.BR netns
+.BR NEWMODE
+
+.ti -8
+.B rdma system help
+
+.SH "DESCRIPTION"
+.SS rdma system set - set RDMA subsystem network namespace mode
+
+.SS rdma system show - display RDMA subsystem network namespace mode
+
+.PP
+.I "NEWMODE"
+- specifies the RDMA subsystem mode. Either exclusive or shared.
+When user wants to assign dedicated RDMA device to a particular
+network namespace, exclusive mode should be set before creating
+any network namespace. If there are active network namespaces and if
+one or more RDMA devices exist, changing mode from shared to
+exclusive returns error code EBUSY.
+
+When RDMA subsystem is in shared mode, RDMA device is accessible in
+all network namespace. When RDMA device isolation among multiple
+network namespaces is not needed, shared mode can be used.
+
+It is preferred to not change the subsystem mode when there is active
+RDMA traffic running, even though it is supported.
+
+.SH "EXAMPLES"
+.PP
+rdma system show
+.RS 4
+Shows the state of RDMA subsystem network namespace mode on the system.
+.RE
+.PP
+rdma system set netns exclusive
+.RS 4
+Sets the RDMA subsystem in network namespace exclusive mode. In this mode RDMA devices
+are visible only in single network namespace.
+.RE
+.PP
+rdma system set netns shared
+.RS 4
+Sets the RDMA subsystem in network namespace shared mode. In this mode RDMA devices
+are shared among network namespaces.
+.RE
+.PP
+
+.SH SEE ALSO
+.BR rdma (8),
+.BR rdma-link (8),
+.BR rdma-resource (8),
+.BR network_namespaces(7),
+.BR namespaces(7),
+.br
+
+.SH AUTHOR
+Parav Pandit <parav@mellanox.com>
diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index b2b5aef8..3ae33987 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -19,7 +19,7 @@ rdma \- RDMA tool
 
 .ti -8
 .IR OBJECT " := { "
-.BR dev " | " link " }"
+.BR dev " | " link " | " system " }"
 .sp
 
 .ti -8
@@ -70,6 +70,10 @@ Generate JSON output.
 .B link
 - RDMA port related.
 
+.TP
+.B sys
+- RDMA subsystem related.
+
 .PP
 The names of all objects may be written in full or
 abbreviated form, for example
@@ -107,6 +111,7 @@ Exit status is 0 if command was successful or a positive integer upon failure.
 .BR rdma-dev (8),
 .BR rdma-link (8),
 .BR rdma-resource (8),
+.BR rdma-system (8),
 .br
 
 .SH REPORTING BUGS
-- 
2.19.2

