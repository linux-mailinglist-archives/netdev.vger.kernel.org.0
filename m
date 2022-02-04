Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0831B4AA3CF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377157AbiBDW7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:59:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377789AbiBDW6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:58:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644015520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BuPkY8aF8foCy1xMQ7K88ilNkVFxYvJg6UfhArqX/OE=;
        b=Uf4GhKQM72VBnj4reaFT9Hh8XiABYb70xUid7/lzJala96fTzzCDu9jGHX2E7phCXwyWnK
        MMpk0qAizvf61ZufbujqDvD2e7ul0MRkXLTBl0e2+xp2dGR3LO3UN+nCqA6hG/3Yy9WFQI
        Pvz5pP8cfuf/Sw6PiTyPldcXi2yClXg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-0OhuUFbFMgi2-oot6MyMrw-1; Fri, 04 Feb 2022 17:58:38 -0500
X-MC-Unique: 0OhuUFbFMgi2-oot6MyMrw-1
Received: by mail-ed1-f71.google.com with SMTP id o25-20020a056402039900b0040631c2a67dso3944458edv.19
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 14:58:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BuPkY8aF8foCy1xMQ7K88ilNkVFxYvJg6UfhArqX/OE=;
        b=yhc7d2d8j62ClmB6sG6EW3aB8rM31a6fayPD6WEnk093krmP6S9zBpYj1jgQFzsdPc
         1Gv4X++eW+Vojl9KoZPUyjXdxAJ26uvsULFnHcgutqHcKVkHeGXo48idPB216FNwIlns
         jhID+cOYG4/qTEsBA2xVl5LQPu991CvXyPC0+V3JhEP0EW3ZyvA7M5uLklt18e20l/ET
         IPqrhPJPYqlq7JdFTxD2QTRWjnGLqSBS+5uP6NWwBuM3AQnM/1BCBcK1MytGm9gP/o8m
         YE2d0t0267FpOC9SqmOuwr8Xy+pt6da1vXMrIpSAX8OteXTrn3T2nDCITKQdUqhLtagX
         0TaQ==
X-Gm-Message-State: AOAM533qu0JraN/m/wqPRy3bJvTlfladrd1xFOoH6JeAPEi6oHvrx5B1
        umxk9AqQecEwar9XYujgr1K7QNHeVBsZLU/sFvGTo5jQ8Rl1OPFLbAVXYrFpDIuftjjlqr/NIXk
        AgOFqPG9VSH9aVpEA
X-Received: by 2002:a17:907:8a1a:: with SMTP id sc26mr989589ejc.334.1644015517721;
        Fri, 04 Feb 2022 14:58:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfMC0jfCBGSPIZgj8KIZhO3L2DqSwEXEGUdXnhN74v25kVKO9x+CidEyZ1jI72iCp5fKT4dw==
X-Received: by 2002:a17:907:8a1a:: with SMTP id sc26mr989567ejc.334.1644015517562;
        Fri, 04 Feb 2022 14:58:37 -0800 (PST)
Received: from krava.redhat.com ([83.240.63.12])
        by smtp.gmail.com with ESMTPSA id d5sm1388884edz.78.2022.02.04.14.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 14:58:37 -0800 (PST)
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
Subject: [PATCH bpf-next 3/3] bpftool: Fix pretty print dump for maps without BTF loaded
Date:   Fri,  4 Feb 2022 23:58:23 +0100
Message-Id: <20220204225823.339548-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204225823.339548-1-jolsa@kernel.org>
References: <20220204225823.339548-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit e5043894b21f ("bpftool: Use libbpf_get_error() to check
error") forced map dump with pretty print enabled to has BTF loaded,
which is not necessarily needed.

Keeping the libbpf_get_error call, but setting errno to 0 because
get_map_kv_btf does nothing for this case.

This fixes test_offload.py for me, which failed because of the
pretty print fails with:

   Test map dump...
   Traceback (most recent call last):
     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 1251, in <module>
       _, entries = bpftool("map dump id %d" % (m["id"]))
     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 169, in bpftool
       return tool("bpftool", args, {"json":"-p"}, JSON=JSON, ns=ns,
     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 155, in tool
       ret, stdout = cmd(ns + name + " " + params + args,
     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 109, in cmd
       return cmd_result(proc, include_stderr=include_stderr, fail=fail)
     File "/root/bpf-next/tools/testing/selftests/bpf/./test_offload.py", line 131, in cmd_result
       raise Exception("Command failed: %s\n%s" % (proc.args, stderr))
   Exception: Command failed: bpftool -p map dump id 4325

Fixes: e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/bpftool/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c66a3c979b7a..2ccf85042e75 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -862,6 +862,7 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	prev_key = NULL;
 
 	if (wtr) {
+		errno = 0;
 		btf = get_map_kv_btf(info);
 		err = libbpf_get_error(btf);
 		if (err) {
-- 
2.34.1

