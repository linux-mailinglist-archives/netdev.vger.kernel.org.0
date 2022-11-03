Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9E618A1E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiKCVDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKCVD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:03:29 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72606262C
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 14:03:27 -0700 (PDT)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 567B7C4F6B7; Thu,  3 Nov 2022 13:40:23 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org
Subject: [RFC PATCH v1 2/3] liburing: add documentation for new napi busy polling
Date:   Thu,  3 Nov 2022 13:40:16 -0700
Message-Id: <20221103204017.670757-3-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103204017.670757-1-shr@devkernel.io>
References: <20221103204017.670757-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds two man pages for the two new functions:
- io_uring_register_busy_poll_timeout
- io_uring_unregister_busy_poll_timeout

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 man/io_uring_register_napi.3   | 35 ++++++++++++++++++++++++++++++++++
 man/io_uring_unregister_napi.3 | 26 +++++++++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 man/io_uring_register_napi.3
 create mode 100644 man/io_uring_unregister_napi.3

diff --git a/man/io_uring_register_napi.3 b/man/io_uring_register_napi.3
new file mode 100644
index 0000000..2063b5c
--- /dev/null
+++ b/man/io_uring_register_napi.3
@@ -0,0 +1,35 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_register_busy_poll_timeout 3 "November 1, 2022" "liburing-2=
.3" "liburing Manual"
+.SH NAME
+io_uring_register_busy_poll_timeout \- register NAPI busy poll timeout
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_register_busy_poll_timeout(struct io_uring *" ring ","
+.BI "                                        unsigned int " timeout)
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_register_busy_poll_timeout (3)
+function registers the NAPI busy poll
+.I timeout
+for subsequent operations.
+
+Registering a NAPI busy poll timeout is a requirement to be able to use
+NAPI busy polling. The other way to enable NAPI busy polling is to set t=
he
+proc setting /proc/sys/net/core/busy_poll.
+
+NAPI busy poll can reduce the network roundtrip time.
+
+
+.SH RETURN VALUE
+On success
+.BR io_uring_register_busy_poll_timeout (3)
+return 0. On failure they return
+.BR -errno .
diff --git a/man/io_uring_unregister_napi.3 b/man/io_uring_unregister_nap=
i.3
new file mode 100644
index 0000000..f294ab3
--- /dev/null
+++ b/man/io_uring_unregister_napi.3
@@ -0,0 +1,26 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_unregister_busy_poll_timeout 3 "November 1, 2022" "liburing=
-2.3" "liburing Manual"
+.SH NAME
+io_uring_unregister_busy_poll_timeout \- register NAPI busy poll timeout
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_register_busy_poll_timeout(struct io_uring *" ring ")
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_unregister_busy_poll_timeout (3)
+function unregisters the NAPI busy poll
+for subsequent operations.
+
+.SH RETURN VALUE
+On success
+.BR io_uring_unregister_busy_poll_timeout (3)
+return 0. On failure they return
+.BR -errno .
--=20
2.30.2

