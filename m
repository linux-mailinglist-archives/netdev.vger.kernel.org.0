Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01114A724B
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344683AbiBBNyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:54:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344671AbiBBNyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:54:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gqIBYhSED2KiLRiPVvQEcn95LWAaRUgov7svs5RNRz4=;
        b=Hu0l9O7ZHMS+sNZB3UsrrjPCVNpGtHd0VKhxdOYKbyv5Yi0f73V0nmPsetPrx/CKtNmhcT
        eLIQZxTFSuOO+wbdWs0VimFQQpVUg1i0Ly1oP0QjGN1qXiBX+vfe9Myj0UmItWbB+2BkLO
        jGnp8Bq7TIgi28atfiSpcmkuaiLDZ70=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-R791E_-2McuGOQM-HBYWUA-1; Wed, 02 Feb 2022 08:54:08 -0500
X-MC-Unique: R791E_-2McuGOQM-HBYWUA-1
Received: by mail-ej1-f72.google.com with SMTP id fx12-20020a170906b74c00b006bbeab42f06so4537249ejb.3
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 05:54:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gqIBYhSED2KiLRiPVvQEcn95LWAaRUgov7svs5RNRz4=;
        b=YGCq1mEp8eR3//qOujpwEmimfPhgK6l1TjAiEVMARKJAkp/2YaeKjvcMaVno5uYqPe
         B76r31Ntsb4zgrGfkxfxC9dDggENBi/IY4MeXRscO/epyQD8dBCmfmVrsGE2pd/iV3m3
         Xf5c/hoM3SV/4lXCRdyjCErbgj/ExH338F7eKOV3SLnN2FIBjZZ/0SsPgZ0RtwQ7bg33
         Cduu/pHHVDn9pFweOI8ixtlnJcscFu9aQk2ASYX3Fgd7C4nNFO9BCoF65i3m9Qlx5MTK
         B9IK55XgmlH2VAtlq1UHjmBg+z17vtT5QweLA7wBs6wTtROWUftniJ+NXgNnhaNmlTsa
         duGA==
X-Gm-Message-State: AOAM533VVtzhHnAKMXmPH7+SIxOK1LJqGkSdE8tOdO23g/y0SMXAKqfL
        bz3g0sN69I0soBqqMeev+q41ekxkmS8Th4XY+8NNod5SoMWOM1a40SwPFQkolwwMgZYMUD/EkC3
        /C3MBaVTgtx4Ja784
X-Received: by 2002:a05:6402:509:: with SMTP id m9mr29640228edv.237.1643810046247;
        Wed, 02 Feb 2022 05:54:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcUwK13/nY2kcApXDzGsFhV/cZCeMZ9htyubnhs5SDp70e98r81NKwfnOABmoL6EkvsLeXhg==
X-Received: by 2002:a05:6402:509:: with SMTP id m9mr29640200edv.237.1643810046059;
        Wed, 02 Feb 2022 05:54:06 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id s7sm15703501ejo.212.2022.02.02.05.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:54:05 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: [PATCH 5/8] libbpf: Add bpf_link_create support for multi kprobes
Date:   Wed,  2 Feb 2022 14:53:30 +0100
Message-Id: <20220202135333.190761-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202135333.190761-1-jolsa@kernel.org>
References: <20220202135333.190761-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding new kprobe struct in bpf_link_create_opts object
to pass multi kprobe data to link_create attr API.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/bpf.c | 7 +++++++
 tools/lib/bpf/bpf.h | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 418b259166f8..98156709a96c 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -853,6 +853,13 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, perf_event))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_TRACE_FPROBE:
+		attr.link_create.fprobe.syms = OPTS_GET(opts, fprobe.syms, 0);
+		attr.link_create.fprobe.addrs = OPTS_GET(opts, fprobe.addrs, 0);
+		attr.link_create.fprobe.cnt = OPTS_GET(opts, fprobe.cnt, 0);
+		attr.link_create.fprobe.flags = OPTS_GET(opts, fprobe.flags, 0);
+		attr.link_create.fprobe.bpf_cookies = OPTS_GET(opts, fprobe.bpf_cookies, 0);
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index c2e8327010f9..114e828ae027 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -413,10 +413,17 @@ struct bpf_link_create_opts {
 		struct {
 			__u64 bpf_cookie;
 		} perf_event;
+		struct {
+			__u64 syms;
+			__u64 addrs;
+			__u32 cnt;
+			__u32 flags;
+			__u64 bpf_cookies;
+		} fprobe;
 	};
 	size_t :0;
 };
-#define bpf_link_create_opts__last_field perf_event
+#define bpf_link_create_opts__last_field fprobe.bpf_cookies
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
-- 
2.34.1

