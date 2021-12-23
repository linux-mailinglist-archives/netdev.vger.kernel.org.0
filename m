Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C41847E404
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 14:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348619AbhLWNRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 08:17:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348613AbhLWNRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 08:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640265468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNaSb3OMoRE9wcAdQ3zOWspvi+wy5zT/zyfsdS3SflI=;
        b=D/bETRX7Meu+pb3uasCt2Kx7shhwL2CRF3uDiuc8z+gifjBJQZl+zJH/KMJ3hhOuBW4xGj
        AMB17JaC/kXxQdt2Uv3mr/9g4abwYfE/moGJK5vOJrt2+I7jzA0a2kqrLw7uINmTUUrzIc
        tXu3wL76WTibKn6JvnlRB8UcOwyhxMY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-y3O-JKGjOb-R8_9WETXIDQ-1; Thu, 23 Dec 2021 08:17:45 -0500
X-MC-Unique: y3O-JKGjOb-R8_9WETXIDQ-1
Received: by mail-ed1-f71.google.com with SMTP id eg23-20020a056402289700b003f80a27ca2bso4475140edb.14
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 05:17:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNaSb3OMoRE9wcAdQ3zOWspvi+wy5zT/zyfsdS3SflI=;
        b=bO2xgA4RHtxbM8pNxrUpduuJ0wFwILSFLsz+7z9b4KlE2S/2c8EygHDp/kxC2uancN
         uVKTeyuN3QurcFzDcSkSyUqOt6ypHZfA8XnKK5udT2XC+AFtL4SLQ246x5wWOkF440T+
         vKAj4MdxC7EGDzSiImAnU1UkWEU2Qqhz9WOYsTeuBg0hmh8denw7cyeUWk6UZ/wXa57Y
         evlIKwdNsoVdDtagamaupO8UmKefqkyihLtyWY5qQMVIwJkeHMqKTaNeQUaPMwpEdjr2
         EUnI5gAJ16mS6X7chCUPin26pmwHd8KWpVbDgptkU8ur+9VYss5gaZrvyMU6yYiAqrEI
         tMhA==
X-Gm-Message-State: AOAM5312WKpnfTQYtPrdCNmU3STP52MCaG2EwFe71GCESG/1PHVuTZkQ
        9rMd+xEOhfU221Dwx/hqdpIlNkh+1QhJDPTzsX+JIus+XIleby6MwzFbs4bUPkFSz1OfwUedikO
        bojIpYHWdWs2fjnpG
X-Received: by 2002:a17:906:b18c:: with SMTP id w12mr1840151ejy.645.1640265464178;
        Thu, 23 Dec 2021 05:17:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwC8968YE5ZR7LaPJnT75CxVmirtTVTSYzqV7G4OHSGq9VKb4UBEdVcbZQ/RxmUk787d2O6lw==
X-Received: by 2002:a17:906:b18c:: with SMTP id w12mr1840136ejy.645.1640265464048;
        Thu, 23 Dec 2021 05:17:44 -0800 (PST)
Received: from krava.redhat.com ([83.240.60.218])
        by smtp.gmail.com with ESMTPSA id 6sm1743743ejj.164.2021.12.23.05.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 05:17:43 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Add btf_dump__new to test_cpp
Date:   Thu, 23 Dec 2021 14:17:36 +0100
Message-Id: <20211223131736.483956-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223131736.483956-1-jolsa@kernel.org>
References: <20211223131736.483956-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding btf_dump__new call to test_cpp, so we can
test C++ compilation with that.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/test_cpp.cpp | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_cpp.cpp b/tools/testing/selftests/bpf/test_cpp.cpp
index a8d2e9a87fbf..e00201de2890 100644
--- a/tools/testing/selftests/bpf/test_cpp.cpp
+++ b/tools/testing/selftests/bpf/test_cpp.cpp
@@ -7,9 +7,15 @@
 
 /* do nothing, just make sure we can link successfully */
 
+static void dump_printf(void *ctx, const char *fmt, va_list args)
+{
+}
+
 int main(int argc, char *argv[])
 {
+	struct btf_dump_opts opts = { };
 	struct test_core_extern *skel;
+	struct btf *btf;
 
 	/* libbpf.h */
 	libbpf_set_print(NULL);
@@ -18,7 +24,8 @@ int main(int argc, char *argv[])
 	bpf_prog_get_fd_by_id(0);
 
 	/* btf.h */
-	btf__new(NULL, 0);
+	btf = btf__new(NULL, 0);
+	btf_dump__new(btf, dump_printf, nullptr, &opts);
 
 	/* BPF skeleton */
 	skel = test_core_extern__open_and_load();
-- 
2.33.1

