Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F263D6D25
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 06:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhG0ELI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 00:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhG0ELG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 00:11:06 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F5AC061757;
        Mon, 26 Jul 2021 21:11:06 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b6so15961160pji.4;
        Mon, 26 Jul 2021 21:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZOkKQ9mkCrA/qKt17/VrVIc8lBqLzH6oDA9OLUrqsLg=;
        b=j+UUCcJ0m+14hlwaznZVmHvpFYYB4iQJqThy2jxxWCrpSyiDxy281u59mJaijMiAvb
         jaKoYw+oIzbTAvvU/Pl/pLVAeKMjGd7X4jPrGErNqQAGGDQ1MJwf8vxWFKkykn7oy9ul
         7dP4xIxA5jA0M9DPAdcYXfEMvqOdi6meD182lL8s0QjxdtJ1DHVHT6CQwCGUMCvZx2W4
         02AG+bjrGF1gsSAsS0f3SxTaa0uBn+REAK9T6XZ6VSDd/fo5EDI9Wdi4UQgJzibUpTo2
         nD90UZ2pZDD6k9bZ+yTPm7GG74OsDcjQ4D5Sv892g7aEW0ktmx7F5OdBWwLV82cG4b8x
         x6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZOkKQ9mkCrA/qKt17/VrVIc8lBqLzH6oDA9OLUrqsLg=;
        b=MeJ20jT5gtiSlyaXZQXqIMcumd9YRxKeofY3W5xU0SD5d5el3+zN/2TM9ZBHvnq+z0
         Pu6MNmJmXNE5ohUAGpdzQE3RTtJ+sMCMs6RNvVtlpypm9thsA7Yq/CFw1IkPavVOol+i
         IBg2cYjQ1OCnzHDpGCfluqQtpWrkTYmMdJF9xkMxOLNAQOflnH5qxGSHE4RICygbE7dt
         V/z02mMq40JTn8XOpJxsBfn4L0ijMzIyriHiLBfm3lxr9U7yfiRGCun5VKl9xKH989Qy
         PNhycjq7gc1XDNQZf0kKwGR/SRqTv2T65UU8KFEPj9c0k1bBOt50bMsX7EbppuaIzpSn
         ShQA==
X-Gm-Message-State: AOAM530Gjyi9O6Mg3oTN9xVNOPYNPRoPA6F8/8lqQRDTetOmX2AldLqe
        4pGtx8BeWPcz83qOb08F3L0=
X-Google-Smtp-Source: ABdhPJy34SnLNcMy/4Hy814wU8BxlaglEkiGaDxa+XAFhJuwwVb+PtmTf0LOf1Qle2pFypECDx4cww==
X-Received: by 2002:a62:1c14:0:b029:34a:70f5:40da with SMTP id c20-20020a621c140000b029034a70f540damr21425236pfc.37.1627359065665;
        Mon, 26 Jul 2021 21:11:05 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id p3sm1493866pgi.20.2021.07.26.21.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 21:11:05 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [bpf-next v2 1/2] samples: bpf: Fix tracex7 error raised on the missing argument
Date:   Tue, 27 Jul 2021 04:10:55 +0000
Message-Id: <20210727041056.23455-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current behavior of 'tracex7' doesn't consist with other bpf samples
tracex{1..6}. Other samples do not require any argument to run with, but
tracex7 should be run with btrfs device argument. (it should be executed
with test_override_return.sh)

Currently, tracex7 doesn't have any description about how to run this
program and raises an unexpected error. And this result might be
confusing since users might not have a hunch about how to run this
program.

    // Current behavior
    # ./tracex7
    sh: 1: Syntax error: word unexpected (expecting ")")
    // Fixed behavior
    # ./tracex7
    ERROR: Run with the btrfs device argument!

In order to fix this error, this commit adds logic to report a message
and exit when running this program with a missing argument.

Additionally in test_override_return.sh, there is a problem with
multiple directory(tmpmnt) creation. So in this commit adds a line with
removing the directory with every execution.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
Change in v2:
 - change directory remove option from -rf to -r

 samples/bpf/test_override_return.sh | 1 +
 samples/bpf/tracex7_user.c          | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/samples/bpf/test_override_return.sh b/samples/bpf/test_override_return.sh
index e68b9ee6814b..35db26f736b9 100755
--- a/samples/bpf/test_override_return.sh
+++ b/samples/bpf/test_override_return.sh
@@ -1,5 +1,6 @@
 #!/bin/bash
 
+rm -r tmpmnt
 rm -f testfile.img
 dd if=/dev/zero of=testfile.img bs=1M seek=1000 count=1
 DEVICE=$(losetup --show -f testfile.img)
diff --git a/samples/bpf/tracex7_user.c b/samples/bpf/tracex7_user.c
index fdcd6580dd73..8be7ce18d3ba 100644
--- a/samples/bpf/tracex7_user.c
+++ b/samples/bpf/tracex7_user.c
@@ -14,6 +14,11 @@ int main(int argc, char **argv)
 	int ret = 0;
 	FILE *f;
 
+	if (!argv[1]) {
+		fprintf(stderr, "ERROR: Run with the btrfs device argument!\n");
+		return 0;
+	}
+
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
 	if (libbpf_get_error(obj)) {
-- 
2.27.0

