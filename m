Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998F141D057
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 02:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347841AbhI3ABz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347789AbhI3ABV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271B4C061771;
        Wed, 29 Sep 2021 16:59:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id l6so2687094plh.9;
        Wed, 29 Sep 2021 16:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yI7BV4fdateh4Yh2ZMtRE1dN8bGB1WKWaE3HyslH3m8=;
        b=XfzGq2eGzUkAWhLlAdkHx+LEIfv3iTeEj7CVrCvgLG2Y0uAMqKs1a11vr9qLQKlH/Y
         0SCWrKcaqL9xlA65p0LAoe3lz9cLSzpNdQ+bcz2K9ji+EzPDdegVj9UHC2ujftffALrz
         F0gUAPW5QZfcGmwTiFNBr+/tShUhOo2e0fiZE8ALbVSETfrsmVugatuhNacZTsoAvY5S
         HaqxnJJozMbmHtHyuALVcxrsuVebigUfzTMQq5jzoasFrYd9M1ts9Jm5iRTNhAANGINQ
         thEWPQX2y8ATQNT4hEickgQOK9cQRX+wLJIfA6yehmGQ+31JNXsYawr6Rh+s5liqaqi5
         b3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yI7BV4fdateh4Yh2ZMtRE1dN8bGB1WKWaE3HyslH3m8=;
        b=WA4ze9dFT0S0tvtB50w+GjgM11duHu3gxlY/K/gVZKViJVPtX97L9/4RDpd1uXsYGv
         PPz4lZ0LsDqmndAjMCzQ0FwZOfRmcxGruImWMq0QKpRChR8/s3Q0QBbpYCxqQdipMtdt
         06c+C7zvQuWt5K3OEHchGej0mxLoQJvW7Hz0zykasBL/xws/tj3jgMn41uV7ehOcwUK0
         UrqM5E6AHeg3QioPqx4v3RIBw/gVVOsoQ6bTGPOHa62okw2QUbxp8b/v/PCfxcqynpzJ
         YVLC98JFcNvehtJ7LYxyk6hlbGLk5Uz+r5GwQzUJC2tHQjJ3EbAzW/Z4FJUXQiLBZQ/G
         fvlQ==
X-Gm-Message-State: AOAM533G8R2e5RC7VoAAUA56lG5AsUlPwDNKV6rkd2LqbJUBSCz+aOoZ
        /MPN9PbiJzCg/gTU6NfkqQ==
X-Google-Smtp-Source: ABdhPJxgQFBUU+3pxoYoquYnmGb3g5n5eyBkXkubOav1yiIiSiEAo88Ed9nTvPf9pnoDNFbeM14BXw==
X-Received: by 2002:a17:902:c245:b0:13e:2254:d3d6 with SMTP id 5-20020a170902c24500b0013e2254d3d6mr1178898plg.52.1632959977751;
        Wed, 29 Sep 2021 16:59:37 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:37 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 10/13] Add bpf_map_trace_{update,delete}_elem() helper functions
Date:   Wed, 29 Sep 2021 23:59:07 +0000
Message-Id: <20210929235910.1765396-11-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

These helpers invoke tracing programs attached to a given map.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 include/linux/bpf.h  |  2 ++
 kernel/bpf/helpers.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 73f4524c1c29..847501a69012 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2148,6 +2148,8 @@ extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
 extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
 extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
+extern const struct bpf_func_proto bpf_map_trace_update_elem_proto;
+extern const struct bpf_func_proto bpf_map_trace_delete_elem_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 1ffd469c217f..f6ebc519334a 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1328,6 +1328,35 @@ void bpf_timer_cancel_and_free(void *val)
 	kfree(t);
 }
 
+BPF_CALL_4(bpf_map_trace_update_elem, struct bpf_map *, map,
+	   void *, key, void *, value, u64, flags)
+{
+	bpf_trace_map_update_elem(map, key, value, flags);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_map_trace_update_elem_proto = {
+	.func		= bpf_map_trace_update_elem,
+	.ret_type	= RET_VOID,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_MAP_KEY,
+	.arg3_type	= ARG_PTR_TO_MAP_VALUE,
+	.arg4_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_2(bpf_map_trace_delete_elem, struct bpf_map *, map, void *, key)
+{
+	bpf_trace_map_delete_elem(map, key);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_map_trace_delete_elem_proto = {
+	.func		= bpf_map_trace_delete_elem,
+	.ret_type	= RET_VOID,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_MAP_KEY,
+};
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_get_current_task_btf_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
-- 
2.33.0.685.g46640cef36-goog

