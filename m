Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D965102245
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfKSKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:50:22 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:46995 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfKSKuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 05:50:20 -0500
Received: by mail-wr1-f42.google.com with SMTP id b3so23216745wrs.13
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 02:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lW5fYRFznQhl0mYpmoGVfe9AF6AxfqUaLZDYUmnCmhA=;
        b=Te9dzMeKQ/g3QeWAL/NqxnIQgAz29j+NrZKaOGHypjJ6636AzHOnyU2xEZkC4JHBXr
         FGf5xvOwpYHR1LAleyeDhgFQ6wWjjgKklFqWEnWywKhZRt+iecUWFo5XAWLH2hMJFsaw
         QK9dOmV0ei17UBJQs/adzFSrQE59csR57w8K1la5StOLcXgrNzrQmaeem6GCkjnG/u5H
         Bsez+qxvKtdj/H+5koyftTLCeIg9Coahdpl+adLe8ot69Vv5yHsazxl2+za9Uq9C6hjv
         aSx5YzMMcLVOnzG0xCUDXkebaY9CqGZZmLtsD+Uo/aZD5BdogVAhsSOJCd3577xSsEAJ
         +Q/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lW5fYRFznQhl0mYpmoGVfe9AF6AxfqUaLZDYUmnCmhA=;
        b=VeC1V3tB0YBQpnl6GBNlR4r3jIvbtX/A8m2cPwLEZwKWaNrEWoxGV4uuLNGzZ0arp+
         ss4Mn/mLbnop8pIJT3XVsb1QWAdRlxh8XsHf/k1eCaflZJL0QqMFRkyftIyaLKDSPcQK
         LaOGr7wR0jd5/hWhXvnzV4GY7ictKrg9ykmAS+lw/jIg6eij1D72qWmeTCC0GU98BgV6
         eH6WBiUpKXcl/JkpQpXr2HwyhigEyJWw0OtJiSrDC4CfwsXIVSt4Iod75fLxFFNHj97K
         mEKNQJsUSXPDKdz6Dsz2iVk8XDxXiyiihPK1B4mjVbZKHnPXxnBja7BVbvzjZFVEfFdX
         Y3EQ==
X-Gm-Message-State: APjAAAWCz7+o2HX0HWssIp6iu9kLAEYW0jIg0xhMapjB2dVCSNXY8sS5
        CTbwKMY9bGM2tA9ORIacWQ2jOw==
X-Google-Smtp-Source: APXvYqwhTfqu1QWzjU7vd7becuO8YTxtRPabMruCbJ0rnyKXdwXwQaqTMdErMxLuRr/bfdkXuMjEyA==
X-Received: by 2002:a5d:66cf:: with SMTP id k15mr35217258wrw.38.1574160618494;
        Tue, 19 Nov 2019 02:50:18 -0800 (PST)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g5sm2646708wma.43.2019.11.19.02.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 02:50:17 -0800 (PST)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf-next 2/2] selftests: bpftool: skip the build test if not in tree
Date:   Tue, 19 Nov 2019 10:50:10 +0000
Message-Id: <20191119105010.19189-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119105010.19189-1-quentin.monnet@netronome.com>
References: <20191119105010.19189-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

If selftests are copied over to another machine/location
for execution the build test of bpftool will obviously
not work, since the sources are not copied.
Skip it if we can't find bpftool's Makefile.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 tools/testing/selftests/bpf/test_bpftool_build.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
index 1fc6f6247f9b..ac349a5cea7e 100755
--- a/tools/testing/selftests/bpf/test_bpftool_build.sh
+++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
@@ -20,6 +20,10 @@ SCRIPT_REL_PATH=$(realpath --relative-to=$PWD $0)
 SCRIPT_REL_DIR=$(dirname $SCRIPT_REL_PATH)
 KDIR_ROOT_DIR=$(realpath $PWD/$SCRIPT_REL_DIR/../../../../)
 cd $KDIR_ROOT_DIR
+if [ ! -e tools/bpf/bpftool/Makefile ]; then
+	echo -e "skip:    bpftool files not found!\n"
+	exit 0
+fi
 
 ERROR=0
 TMPDIR=
-- 
2.17.1

