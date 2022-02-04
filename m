Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D155E4AA3BE
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359386AbiBDW6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:58:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377736AbiBDW62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:58:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644015507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mbIIMwTtHOK23EwwQeYMceH1azwmVKWfuX9oObuKyeQ=;
        b=VHDgkptulo/cGYPfID8D2UMrlrYZG9O2zGNfyMRj3ujoZ754gughxyG6p3I3n6UVCegA3D
        FYEDUr19Dt16a9gqvbFIv573VOkl+3R5A0oQnXabhYFawNUpWDRFDs1Mt8a4UoTlpzdx0K
        cuRQmb2JS175qGMjx8ihEY/1DtJ46Ms=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-r-0bryZmOJGWclCG21EWog-1; Fri, 04 Feb 2022 17:58:26 -0500
X-MC-Unique: r-0bryZmOJGWclCG21EWog-1
Received: by mail-ed1-f70.google.com with SMTP id s7-20020a508dc7000000b0040f29ccd65aso252070edh.1
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 14:58:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mbIIMwTtHOK23EwwQeYMceH1azwmVKWfuX9oObuKyeQ=;
        b=U13ri7g8oKaNJiHH+whGtqDSjnI9SU/d+fwBQRLqUtZ2e0d9p/ClRdaFPw4blb+pfB
         GK/LCss91HJOGFKYn5znqyu/PN88YN4odIZqDDULsdC4uDkCXFS5obdwWEoNoleqY1WC
         dS63vWGUS/ZBhlcSG1jrpG06a7El8aZvzyXzRFy+Z3Z5ZAIM5+W8KV97rpgz9QqcZdmz
         bxgu+lHse6EORfzmDS5sTcwpp1ekAU9NIq1DM4ZxCozWKcqbmKtSpmwg5V0wjJ6h8jGV
         hGq8DY8AzZVvniTXHY5VPjzjFjUv4K/S2kY3AsfAUOUIFIKXtf2iB77ZAqW0YjVMySNT
         WofQ==
X-Gm-Message-State: AOAM532Wh+Ab+YOLzoZmC/arpzstWAo8jbfpwfiKvaX/2IyE3O2BFOF8
        9fBN3T4lI3MZhnQCh2P1B/q3kyTAG74ZBgoRosG/oYD5QedTzjid5gVZauPQ+lSc6pPFqfQWoNL
        26k8/W9hMj+iNfHD+
X-Received: by 2002:a05:6402:51cd:: with SMTP id r13mr1484386edd.381.1644015505107;
        Fri, 04 Feb 2022 14:58:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6tau51Apvgacqbwdn4SWF8Jr0PsmIu6xyu/W/a+95B28zPUpQ9oEEbT8VgbdxwucI7AZomQ==
X-Received: by 2002:a05:6402:51cd:: with SMTP id r13mr1484378edd.381.1644015504962;
        Fri, 04 Feb 2022 14:58:24 -0800 (PST)
Received: from krava.redhat.com ([83.240.63.12])
        by smtp.gmail.com with ESMTPSA id u1sm1064907ejj.215.2022.02.04.14.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 14:58:24 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH bpf-next 1/3] libbpf: Add names for auxiliary maps
Date:   Fri,  4 Feb 2022 23:58:21 +0100
Message-Id: <20220204225823.339548-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding names for maps that bpftool uses for various detections.
These maps can appear in final map show output (due to deferred
removal in kernel) so some tests (like test_offload.py) needs
to filter them out.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 904cdf83002b..38294ce935d6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4412,7 +4412,7 @@ static int probe_kern_global_data(void)
 	};
 	int ret, map, insn_cnt = ARRAY_SIZE(insns);
 
-	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
+	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, "global_data", sizeof(int), 32, 1, NULL);
 	if (map < 0) {
 		ret = -errno;
 		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
@@ -4545,7 +4545,7 @@ static int probe_kern_array_mmap(void)
 	LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_MMAPABLE);
 	int fd;
 
-	fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), sizeof(int), 1, &opts);
+	fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, "array_mmap", sizeof(int), sizeof(int), 1, &opts);
 	return probe_fd(fd);
 }
 
@@ -4592,7 +4592,7 @@ static int probe_prog_bind_map(void)
 	};
 	int ret, map, prog, insn_cnt = ARRAY_SIZE(insns);
 
-	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
+	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, "bind_map_detect", sizeof(int), 32, 1, NULL);
 	if (map < 0) {
 		ret = -errno;
 		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
-- 
2.34.1

