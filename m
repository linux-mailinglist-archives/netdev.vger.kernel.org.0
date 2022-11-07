Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DA461FC4D
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiKGR4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiKGRzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:55:21 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F03A24BD1
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:54:24 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id AEF39F6B966; Mon,  7 Nov 2022 09:54:04 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [RFC PATCH v2 2/4] liburing: add documentation for new napi busy polling
Date:   Mon,  7 Nov 2022 09:53:55 -0800
Message-Id: <20221107175357.2733763-3-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107175357.2733763-1-shr@devkernel.io>
References: <20221107175357.2733763-1-shr@devkernel.io>
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
- io_uring_register_napi_busy_poll_timeout
- io_uring_unregister_napi_busy_poll_timeout

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 man/io_uring_register_napi.3   | 35 ++++++++++++++++++++++++++++++++++
 man/io_uring_unregister_napi.3 | 26 +++++++++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 man/io_uring_register_napi.3
 create mode 100644 man/io_uring_unregister_napi.3

diff --git a/man/io_uring_register_napi.3 b/man/io_uring_register_napi.3
new file mode 100644
index 0000000..4ef591c
--- /dev/null
+++ b/man/io_uring_register_napi.3
@@ -0,0 +1,35 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_register_napi_busy_poll_timeout 3 "November 1, 2022" "libur=
ing-2.3" "liburing Manual"
+.SH NAME
+io_uring_register_napi_busy_poll_timeout \- register NAPI busy poll time=
out
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_register_napi_busy_poll_timeout(struct io_uring *" rin=
g ","
+.BI "                                             unsigned int " timeout=
)
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_register_napi_busy_poll_timeout (3)
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
+.BR io_uring_register_napi_busy_poll_timeout (3)
+return 0. On failure they return
+.BR -errno .
diff --git a/man/io_uring_unregister_napi.3 b/man/io_uring_unregister_nap=
i.3
new file mode 100644
index 0000000..3a73327
--- /dev/null
+++ b/man/io_uring_unregister_napi.3
@@ -0,0 +1,26 @@
+.\" Copyright (C) 2022 Stefan Roesch <shr@devkernel.io>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_unregister_napi_busy_poll_timeout 3 "November 1, 2022" "lib=
uring-2.3" "liburing Manual"
+.SH NAME
+io_uring_unregister_napi_busy_poll_timeout \- unregister NAPI busy poll =
timeout
+.SH SYNOPSIS
+.nf
+.B #include <liburing.h>
+.PP
+.BI "int io_uring_unregister_napi_busy_poll_timeout(struct io_uring *" r=
ing ")
+.PP
+.fi
+.SH DESCRIPTION
+.PP
+The
+.BR io_uring_unregister_napi_busy_poll_timeout (3)
+function unregisters the NAPI busy poll
+for subsequent operations.
+
+.SH RETURN VALUE
+On success
+.BR io_uring_unregister_napi_busy_poll_timeout (3)
+return 0. On failure they return
+.BR -errno .
--=20
2.30.2

