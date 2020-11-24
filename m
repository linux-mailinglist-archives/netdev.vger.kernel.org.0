Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D88D2C20D7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbgKXJD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731032AbgKXJDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:03:49 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A92C0613D6;
        Tue, 24 Nov 2020 01:03:49 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id e8so5942970pfh.2;
        Tue, 24 Nov 2020 01:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RS/qSpAFGukp3/v16zb33bFhkDVWoKnFpkOAjHD2Ues=;
        b=VKF7fPjV5I+G4TZIPo0HBe7OcGBkX0O0kEIEI78S+vljgkjJXOLUtGZB1en9SJwoWS
         EPPnzCce8LbTQgpxNWW3NDQi8zpcinJKKFN7hsOTMWfvGEErJDWeBP6LQwNaWeChxXZT
         bafVjf6QIkOwizK/kyJAhA1ar9SfaJ0dAMY6bduzumovZazcLwPHi2+39HHVvhXVtkU9
         TTiU5nBcY5snyTv6P4Nx6XDbqLujGcP8qFyPVn/HZDtkOyvk/a+Zap3H+gvmIxOjWIeU
         NsCM8kM0CDRqPvYIGZtr0NSEF5lQAhuzDuJuFmvugslrZ+CWInBb3li5O99QZ75GEkX1
         oamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RS/qSpAFGukp3/v16zb33bFhkDVWoKnFpkOAjHD2Ues=;
        b=FJKp+RwIxC3f6dN45/GrPo0oeEbXnljEpqNRh6KEqX0YfOj8d8NhV+MXC2D6UL81xx
         b8XHqa4gn1OqI+P9uHHyh3xbuH85GZ4LAPZO+I7Y6uQ2ElvABYi9ewURnkJEQ2gt4gqe
         vjSNRNWRUhPLxPlRNv/bc9fO6peiTFal4WCBD+GLZOVsExVMXsKIorIH7Msr5poF9W9Q
         UUA4J0ydPMtofTSpv4YfAq8BWxzDECIcOnTeTfnkmnd5IYusGM8223PqjylyLRP/ENJ4
         L0JV71A3WhQMg0mCCEowiuuAtaTCK2cgXJwTROa0nWsIbaWaRfmAH1LqKc4nXJ4qUGNm
         jR4Q==
X-Gm-Message-State: AOAM532qzmuzMMB6geLHjmkvQ69h1WotUDGghGrXWdLLhX7qBdp8ydnJ
        2YVh33LR3DpP+GDUoXaxUg==
X-Google-Smtp-Source: ABdhPJzkiGtFK2kPmzK6LL5JKzK+ic1KV3ZzylgHoBne5d6xHtMLlUFeYp9lOwcJ8WuA4t6QU1Sksg==
X-Received: by 2002:a17:90a:19d5:: with SMTP id 21mr3630792pjj.187.1606208628580;
        Tue, 24 Nov 2020 01:03:48 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id n68sm14084345pfn.161.2020.11.24.01.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 01:03:48 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v3 6/7] samples: bpf: fix lwt_len_hist reusing previous BPF map
Date:   Tue, 24 Nov 2020 09:03:09 +0000
Message-Id: <20201124090310.24374-7-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201124090310.24374-1-danieltimlee@gmail.com>
References: <20201124090310.24374-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, lwt_len_hist's map lwt_len_hist_map is uses pinning, and the
map isn't cleared on test end. This leds to reuse of that map for
each test, which prevents the results of the test from being accurate.

This commit fixes the problem by removing of pinned map from bpffs.
Also, this commit add the executable permission to shell script
files.

Fixes: f74599f7c5309 ("bpf: Add tests and samples for LWT-BPF")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/lwt_len_hist.sh | 2 ++
 samples/bpf/test_lwt_bpf.sh | 0
 2 files changed, 2 insertions(+)
 mode change 100644 => 100755 samples/bpf/lwt_len_hist.sh
 mode change 100644 => 100755 samples/bpf/test_lwt_bpf.sh

diff --git a/samples/bpf/lwt_len_hist.sh b/samples/bpf/lwt_len_hist.sh
old mode 100644
new mode 100755
index 090b96eaf7f7..0eda9754f50b
--- a/samples/bpf/lwt_len_hist.sh
+++ b/samples/bpf/lwt_len_hist.sh
@@ -8,6 +8,8 @@ VETH1=tst_lwt1b
 TRACE_ROOT=/sys/kernel/debug/tracing
 
 function cleanup {
+	# To reset saved histogram, remove pinned map
+	rm /sys/fs/bpf/tc/globals/lwt_len_hist_map
 	ip route del 192.168.253.2/32 dev $VETH0 2> /dev/null
 	ip link del $VETH0 2> /dev/null
 	ip link del $VETH1 2> /dev/null
diff --git a/samples/bpf/test_lwt_bpf.sh b/samples/bpf/test_lwt_bpf.sh
old mode 100644
new mode 100755
-- 
2.25.1

