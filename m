Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADCB3BF1ED
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 00:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhGGWTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 18:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbhGGWTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 18:19:49 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E36C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 15:17:08 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id f17so3578550pfj.8
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 15:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TVFqh6EgRMGzBVVuOuD42u7mzGcwsEHA3R/s/xKM4Rc=;
        b=JAIXurvG7xQFb9CWacQy8otHUTqgn3qWpyKdcSH0o8Fk4FOMyP2wsYoIjMKp0Ts9gg
         ebmVOuERF7iD06QcX7D16EflAp7Gxnb7q+8Sgwd+j2scAixg4mfbemESSH2w240iAxol
         CfPy40Gnp6ef+XmuToyqCMVzUYRLZuRzvCXd8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TVFqh6EgRMGzBVVuOuD42u7mzGcwsEHA3R/s/xKM4Rc=;
        b=FH/DFtpHMtXvtbs29PS/u6/HaKyzTG8G+K048eG1fvODvaynLtleMFVXVHIW8b0k0m
         YoFCp9iaQ7JH5DsvznZvdQJGTEdFueriU4/O3mHKFYM8IQEty5tv/hJDsoAeA2WR/Pyh
         O87mK+NaCtWIrmAkCpkyqOx8vU0D5tNBVucpzWVGkwHUl7P7HkXLww8KwHWaAah4V7ds
         Y7EBTQPlzKu39DPr6P8prpzsfxP3JMxdC3u7LAq++6my7eBPQdusAvezsAJ78LfzGWPR
         BiLXTGpnJ9lxei5UTwbN9xQbqrUOv1hNJ2/rf40AaI0PrEfOkPSDa9HeD3UXsE/rvZn1
         nvvA==
X-Gm-Message-State: AOAM531aE6GFXiUTk6V08UyQkjR7hLpueYmyiQM5RYiSK/deVHinKXUx
        7IGXlK426kZgYJLhwROqBCeUEg==
X-Google-Smtp-Source: ABdhPJz2atxEt+zATP0LVhx3Q7RUC2lOygdi7J1lyv2MH2SKjrkDUdBPOqK+lKq7xaZq6ynHBDkQ1Q==
X-Received: by 2002:a05:6a00:2293:b029:309:e87c:1f4a with SMTP id f19-20020a056a002293b0290309e87c1f4amr26933092pfe.36.1625696228266;
        Wed, 07 Jul 2021 15:17:08 -0700 (PDT)
Received: from ip-10-184-182-114.us-west-2.compute.internal (ec2-54-191-147-77.us-west-2.compute.amazonaws.com. [54.191.147.77])
        by smtp.gmail.com with ESMTPSA id 75sm203748pfx.71.2021.07.07.15.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 15:17:07 -0700 (PDT)
From:   Zvi Effron <zeffron@riotgames.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, KP Singh <kpsingh@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Zvi Effron <zeffron@riotgames.com>,
        Cody Haas <chaas@riotgames.com>,
        Lisa Watanabe <lwatanabe@riotgames.com>
Subject: [PATCH bpf-next v8 2/4] bpf: support input xdp_md context in BPF_PROG_TEST_RUN
Date:   Wed,  7 Jul 2021 22:16:55 +0000
Message-Id: <20210707221657.3985075-3-zeffron@riotgames.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707221657.3985075-1-zeffron@riotgames.com>
References: <20210707221657.3985075-1-zeffron@riotgames.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support passing a xdp_md via ctx_in/ctx_out in bpf_attr for
BPF_PROG_TEST_RUN.

The intended use case is to pass some XDP meta data to the test runs of
XDP programs that are used as tail calls.

For programs that use bpf_prog_test_run_xdp, support xdp_md input and
output. Unlike with an actual xdp_md during a non-test run, data_meta must
be 0 because it must point to the start of the provided user data. From
the initial xdp_md, use data and data_end to adjust the pointers in the
generated xdp_buff. All other non-zero fields are prohibited (with
EINVAL). If the user has set ctx_out/ctx_size_out, copy the (potentially
different) xdp_md back to the userspace.

We require all fields of input xdp_md except the ones we explicitly
support to be set to zero. The expectation is that in the future we might
add support for more fields and we want to fail explicitly if the user
runs the program on the kernel where we don't yet support them.

Co-developed-by: Cody Haas <chaas@riotgames.com>
Signed-off-by: Cody Haas <chaas@riotgames.com>
Co-developed-by: Lisa Watanabe <lwatanabe@riotgames.com>
Signed-off-by: Lisa Watanabe <lwatanabe@riotgames.com>
Signed-off-by: Zvi Effron <zeffron@riotgames.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/bpf.h |  3 --
 net/bpf/test_run.c       | 67 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 59 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bf9252c7381e..b46a383e8db7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -324,9 +324,6 @@ union bpf_iter_link_info {
  *		**BPF_PROG_TYPE_SK_LOOKUP**
  *			*data_in* and *data_out* must be NULL.
  *
- *		**BPF_PROG_TYPE_XDP**
- *			*ctx_in* and *ctx_out* must be NULL.
- *
  *		**BPF_PROG_TYPE_RAW_TRACEPOINT**,
  *		**BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE**
  *
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index aa47af349ba8..229c5deb813c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -15,6 +15,7 @@
 #include <linux/error-injection.h>
 #include <linux/smp.h>
 #include <linux/sock_diag.h>
+#include <net/xdp.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
@@ -687,6 +688,22 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	return ret;
 }
 
+static int xdp_convert_md_to_buff(struct xdp_md *xdp_md, struct xdp_buff *xdp)
+{
+	if (!xdp_md)
+		return 0;
+
+	if (xdp_md->egress_ifindex != 0)
+		return -EINVAL;
+
+	if (xdp_md->ingress_ifindex != 0 || xdp_md->rx_queue_index != 0)
+		return -EINVAL;
+
+	xdp->data = xdp->data_meta + xdp_md->data;
+
+	return 0;
+}
+
 int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
@@ -697,35 +714,69 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	struct netdev_rx_queue *rxqueue;
 	struct xdp_buff xdp = {};
 	u32 retval, duration;
+	struct xdp_md *ctx;
 	u32 max_data_sz;
 	void *data;
-	int ret;
+	int ret = -EINVAL;
 
-	if (kattr->test.ctx_in || kattr->test.ctx_out)
-		return -EINVAL;
+	ctx = bpf_ctx_init(kattr, sizeof(struct xdp_md));
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	if (ctx) {
+		/* There can't be user provided data before the meta data */
+		if (ctx->data_meta || ctx->data_end != size ||
+		    ctx->data > ctx->data_end ||
+		    unlikely(xdp_metalen_invalid(ctx->data)))
+			goto free_ctx;
+		/* Meta data is allocated from the headroom */
+		headroom -= ctx->data;
+	}
 
 	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
 
 	data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);
-	if (IS_ERR(data))
-		return PTR_ERR(data);
+	if (IS_ERR(data)) {
+		ret = PTR_ERR(data);
+		goto free_ctx;
+	}
 
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
 	xdp_init_buff(&xdp, headroom + max_data_sz + tailroom,
 		      &rxqueue->xdp_rxq);
 	xdp_prepare_buff(&xdp, data, headroom, size, true);
 
+	ret = xdp_convert_md_to_buff(ctx, &xdp);
+	if (ret)
+		goto free_data;
+
 	bpf_prog_change_xdp(NULL, prog);
 	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	if (ret)
 		goto out;
-	if (xdp.data != data + headroom || xdp.data_end != xdp.data + size)
-		size = xdp.data_end - xdp.data;
-	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
+
+	if (xdp.data_meta != data + headroom ||
+	    xdp.data_end != xdp.data_meta + size)
+		size = xdp.data_end - xdp.data_meta;
+
+	if (ctx) {
+		ctx->data = xdp.data - xdp.data_meta;
+		ctx->data_end = xdp.data_end - xdp.data_meta;
+	}
+
+	ret = bpf_test_finish(kattr, uattr, xdp.data_meta, size, retval,
+			      duration);
+	if (!ret)
+		ret = bpf_ctx_finish(kattr, uattr, ctx,
+				     sizeof(struct xdp_md));
+
 out:
 	bpf_prog_change_xdp(prog, NULL);
+free_data:
 	kfree(data);
+free_ctx:
+	kfree(ctx);
 	return ret;
 }
 
-- 
2.31.1

