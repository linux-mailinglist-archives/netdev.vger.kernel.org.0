Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1EF2B6811
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgKQO6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgKQO6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:58:00 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992F6C0613CF;
        Tue, 17 Nov 2020 06:57:59 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id js21so581713pjb.0;
        Tue, 17 Nov 2020 06:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RS/qSpAFGukp3/v16zb33bFhkDVWoKnFpkOAjHD2Ues=;
        b=dkyxrp1RGjI36BH2iup2vZcq4ZdAvid2JI0v4/fBiY/iWrIiXjvo1NoYs4RRNEkTbK
         hhvzPhQM7ebnz2XX79/yWhUOF17dQR+gjLoIuW5WvmXLlcLaAXn4XMHY92FcLk9coqjM
         6umnLyuMjgdHKi+yypqMWHo5YxmKVmTQf+DHYZUEJbs5K876eXzYxMsVDGQ+Kbybm76C
         TmA8/fzEOvggaQsamkpn5U/xPRfCOIgZxKG7i2N83m5ZgCLvhT7HAAyo8s1VguTMl5G+
         LU6xrEM5zhvxfRcodt1DsThLqj2UCGigJrrCTmDHs9UayKUtwixcssMt/BGWpJ47kn9+
         ExOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RS/qSpAFGukp3/v16zb33bFhkDVWoKnFpkOAjHD2Ues=;
        b=jwwLzV966+tlOfdt3s5zv4Xpz0smeeDkLTbIpN12rZTxrVpFt1lAjJBsHTpuzxEkez
         Nl4pwEf6AZUL5Z9wolKBrPYCy9CbcwMLHlcZtvNfH22VzlQV+d1K3zCFjU1CC+RbnNv5
         kUZqM6u0M7L3NfWAqTJSJhiFiP7gMPXijCQzsHrNQ9ZPQeF7TwOdc+NSYFVbpi1K7y/E
         D0H1n2ZDhv0p+katCxaysYFiKYawgGYMRgc14ZB3RaggdGCB3NiJz5F75UhUM+xeO5Oh
         q+4z/kjQvyYR9EIQB5utfUNj6nTkxktx1GOehNht6ZzWJ5AHueu0/qzNA+J+fv429fce
         M/zQ==
X-Gm-Message-State: AOAM531dcgxX+fJWkZUuD4C3v4vYhHsrkcXzsbSYoPMv4ZByvb2x92B+
        dRVdTR/lD8kVsrADIvJXvQ==
X-Google-Smtp-Source: ABdhPJxrb58cb1CPaftdp+rpIP17pxB2kX0BOO0X1IqtJff9erSme1IcGFP9Rf3xDRYND/vsW5yTVw==
X-Received: by 2002:a17:90a:9403:: with SMTP id r3mr5070054pjo.66.1605625079161;
        Tue, 17 Nov 2020 06:57:59 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q13sm3517981pjq.15.2020.11.17.06.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:57:58 -0800 (PST)
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
Subject: [PATCH bpf-next 7/9] samples: bpf: fix lwt_len_hist reusing previous BPF map
Date:   Tue, 17 Nov 2020 14:56:42 +0000
Message-Id: <20201117145644.1166255-8-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117145644.1166255-1-danieltimlee@gmail.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
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

