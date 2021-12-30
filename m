Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5472481ECF
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbhL3RvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241541AbhL3RvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:51:02 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF35C061574;
        Thu, 30 Dec 2021 09:51:02 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 196so21922700pfw.10;
        Thu, 30 Dec 2021 09:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ju2VgPfHsj6DPGG27hsnZVYzZFDSJ2tinufjtPhmlw=;
        b=U+RyHlPuf+XH5Tq8K6Y/SFClgKqSssTqMO59CX1vV/Geo2kT53iIFVXZyaXvgdApke
         136N5t+ffq3mMyZyh2Lu+arxBqGWARuwvYqnCO5lx20yOxtfqLFmWCxHAQMf8iXkcTP9
         1zjUAt1Mz+ZB2+JfI5DCo/mcQ/cMOV4ZmKItafi9oD3Pg/z3dwNdZcLCBltSn8CKwPlO
         RuoZf1+kmnDQ4dcojQDNw+Gcgudm9xZL38XW3j+Em2VXp2hQR4hB/1kV2QlvdTL9i/mf
         dyOSRIqvK0UfuFlGxTMJrdlWIAj9WgPMj+TPI0cfUVNU/wtZrErCiMs4Jufz7QdOTxdM
         rRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ju2VgPfHsj6DPGG27hsnZVYzZFDSJ2tinufjtPhmlw=;
        b=lTMj45nfWHn5FxkkuiMGrBwgQZvWZt1Epo+FtOq/FQZxIKgRShFLuA5piymmEGFN45
         kE/GUycFawCCna4Ca9PgL8r4mq4F22/W4iqZYNexSTET/vmCMjRal9nvpqfzsHQ4vGZ9
         bcB7dhUcARixg1qHEJD9FpQ/Tv98fJsCLebaFq9QeP5EJhpThCbuhW41y/Gd8vt1vVPk
         itvdKeNKeWEKewH4Nm1Jazid0mthfq1yunCbpYpoLcZ6wlDN9RoCzpyT5hIseE8oK/Ic
         MJKvJqIad9LElO9kuh37hp2OJEcogPJZm8qwYcGcv8c5VIIFY62ysYxFT3y3EIIl7Gka
         6M2A==
X-Gm-Message-State: AOAM530l+l+tb/gF+T4Cmp3xjomPcDpEfgKp67cynhFU9R0cNvdyFn0e
        AJ8dYwdFRlvUYc3SLdXI5+0=
X-Google-Smtp-Source: ABdhPJzm4F1UvDkN7WWxskOS6Xwlx3ozewhFMgkxivjSV6TAn/DttM8oQxukAAuDXUb9nh6tOWpr1A==
X-Received: by 2002:a05:6a00:1818:b0:4ba:c287:a406 with SMTP id y24-20020a056a00181800b004bac287a406mr32277721pfa.6.1640886661680;
        Thu, 30 Dec 2021 09:51:01 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id s34sm29980811pfg.198.2021.12.30.09.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:51:01 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nugra <richiisei@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [RFC PATCH liburing v1 5/5] man: Add `io_uring_prep_{sendto,recvfrom}` docs
Date:   Fri, 31 Dec 2021 00:50:19 +0700
Message-Id: <20211230174548.178641-6-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230174548.178641-1-ammar.faizi@intel.com>
References: <20211230174548.178641-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nugra <richiisei@gmail.com>

Cc: Ammar Faizi <ammarfaizi2@gmail.com>
Signed-off-by: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 man/io_uring_prep_recvfrom.3 | 33 +++++++++++++++++++++++++++++++++
 man/io_uring_prep_sendto.3   | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 man/io_uring_prep_recvfrom.3
 create mode 100644 man/io_uring_prep_sendto.3

diff --git a/man/io_uring_prep_recvfrom.3 b/man/io_uring_prep_recvfrom.3
new file mode 100644
index 0000000..b6cfea7
--- /dev/null
+++ b/man/io_uring_prep_recvfrom.3
@@ -0,0 +1,33 @@
+.\" Copyright (C) 2021 Nugra <richiisei@gmail.com>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_recvfrom 3 "December 30, 2021" "liburing-2.1" "liburing Manual"
+.SH NAME
+io_uring_prep_recvfrom   - prepare I/O recvfrom request
+
+.SH SYNOPSIS
+.nf
+.BR "#include <liburing.h>"
+.PP
+.BI "void io_uring_prep_recvfrom(struct io_uring_sqe *sqe, int sockfd,"
+.BI "					   void *buf, size_t len, int flags,
+.BI "					   struct sockaddr *src_addr,"
+.BI "					   socklen_t *addrlen)"
+.SH DESCRIPTION
+The io_uring_prep_recvfrom() prepares receive messages from a socket. The submission queue entry
+.I sqe
+is setup to use the file descriptor
+.I fd
+transmit the request.
+
+After the submission queue entry
+.I sqe
+has been prepared as
+.I recvfrom
+op, it can be submitted with one of the submit functions.
+
+.SH RETURN VALUE
+None
+.SH SEE ALSO
+.BR io_uring_get_sqe (3), io_uring_submit (3)
diff --git a/man/io_uring_prep_sendto.3 b/man/io_uring_prep_sendto.3
new file mode 100644
index 0000000..2ed8263
--- /dev/null
+++ b/man/io_uring_prep_sendto.3
@@ -0,0 +1,34 @@
+.\" Copyright (C) 2021 Nugra <richiisei@gmail.com>
+.\"
+.\" SPDX-License-Identifier: LGPL-2.0-or-later
+.\"
+.TH io_uring_prep_sendto 3 "December 30, 2021" "liburing-2.1" "liburing Manual"
+.SH NAME
+io_uring_prep_sendto   - prepare I/O sendto request
+
+.SH SYNOPSIS
+.nf
+.BR "#include <liburing.h>"
+.PP
+.BI "void io_uring_prep_sendto(struct io_uring_sqe *sqe, int sockfd,"
+.BI "					 const void *buf, size_t len, int flags,"
+.BI "					 const struct sockaddr *dest_addr,"
+.BI "					 socklen_t addrlen)"
+.PP
+.SH DESCRIPTION
+The io_uring_prep_sendto() prepares transmit request to another socket. The submission queue entry
+.I sqe
+is setup to use the file descriptor
+.I fd
+transmit the request.
+
+After the submission queue entry
+.I sqe
+has been prepared as
+.I sendto
+op, it can be submitted with one of the submit functions.
+
+.SH RETURN VALUE
+None
+.SH SEE ALSO
+.BR io_uring_get_sqe (3), io_uring_submit (3)
-- 
2.32.0

