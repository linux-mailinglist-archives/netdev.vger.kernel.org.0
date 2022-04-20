Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328DD50880C
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 14:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378493AbiDTM0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 08:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343983AbiDTM0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 08:26:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D123BFB0;
        Wed, 20 Apr 2022 05:23:20 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so4815659pjb.2;
        Wed, 20 Apr 2022 05:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5V2UhLwA0ER/Kb+luVRoGhDRcpPaUBPA6I29eOPazLA=;
        b=AxyKrj3ihddHgoHgVRsFxNLvGWlZYyi79xMa0k0wi6WvW8JLjk5iN6kWyaKA8iIGQO
         AH9zTkZ2aiazPyWIoM1F5JwIaCGzNefalS9bzEI6DOA7vwxW1VMT1PfHn4r9hpthWoX4
         gYGW7YAAdMmnY/8o4tePx4B2Q0UjStSX0+tL/xA4Yo2RwipCm2azvKNdBHGPHpt5mRKh
         o1rDEV7UejjXYCn9Y2GJ1eSra0RzcALx9CxDW8moYMCGxFjeCrer6RZ8c+OzyI45Qytm
         d61CR1YaRVWNe43ILh5VDZjK1Fc/49to3AYasya7Dyz0PKL3ZzfNBiOAhiCVE8yr1+51
         IpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5V2UhLwA0ER/Kb+luVRoGhDRcpPaUBPA6I29eOPazLA=;
        b=JHqrr0JF992jid1gF5bbxoKbx/2Ch2ZA4nQFPRiv5pTC95j6PHvyzMPrxAVXQMnQ/q
         ecM+z3azaBDnG5JWAUed1So+nobgw7bVxXcTA1tL/J3AhUzxRCpTAhSvvYP/1zd+aIIL
         2ZfXxPdaYaFOsDuyNSayTyOh3EbvhrsqMXgSnBkFpdkLch4Ymm4uCyZ7J6z7qwX8bwih
         MHNHmy6XlAwYfongxw2mLT0c5W8+r7+YzAVtQvzN2eIjwPucDm+ZSlK8w+EasoKtGV7f
         pnBu47c0Tozi/FImxmQX5SpwFhGhVnSc83NccjUx5zAjkxt5ncl64wIuURcg7zACk3Ob
         DpEA==
X-Gm-Message-State: AOAM533raeVrhWHv+h/MijoJEBmYRV1UekldDeGG1dPteW8PGUF5eBq6
        GbWJfSzpYgDKgjYKAIQ+duDpPxakz1xNRg==
X-Google-Smtp-Source: ABdhPJyzHRRZrG0qyZxdtMAy5DRn0u7d1c9JPS3hBGQHShalkyA/enkDFyTI9r1XGPoks1UMrAKfQg==
X-Received: by 2002:a17:902:ecd0:b0:159:572:af3a with SMTP id a16-20020a170902ecd000b001590572af3amr12635191plh.77.1650457399817;
        Wed, 20 Apr 2022 05:23:19 -0700 (PDT)
Received: from localhost.xiaojukeji.com ([111.201.148.136])
        by smtp.gmail.com with ESMTPSA id t69-20020a637848000000b0039831d6dc23sm19365847pgc.94.2022.04.20.05.23.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 05:23:19 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [net-next v1] bpf: add bpf_ktime_get_real_ns helper
Date:   Wed, 20 Apr 2022 20:23:07 +0800
Message-Id: <20220420122307.5290-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This patch introduce a new bpf_ktime_get_real_ns helper, which may
help us to measure the skb latency in the ingress/forwarding path:

HW/SW[1] -> ip_rcv/tcp_rcv_established -> tcp_recvmsg_locked/tcp_update_recv_tstamps

* Insert BPF kprobe into ip_rcv/tcp_rcv_established invoking this helper.
  Then we can inspect how long time elapsed since HW/SW.
* If inserting BPF kprobe tcp_update_recv_tstamps invoked by tcp_recvmsg,
  we can measure how much latency skb in tcp receive queue. The reason for
  this can be application fetch the TCP messages too late.

[1]:
- HW drivers may set skb_hwtstamps(skb)->hwtstamp
- SW __netif_receive_skb_core set skb->tstamp with ktime_get_real()

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Dave Marchevsky <davemarchevsky@fb.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc: Joanne Koong <joannekoong@fb.com>
Cc: Geliang Tang <geliang.tang@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 include/uapi/linux/bpf.h       | 13 +++++++++++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 14 ++++++++++++++
 tools/include/uapi/linux/bpf.h | 13 +++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d14b10b85e51..2565c587fe1b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5143,6 +5143,18 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
+ *
+ * u64 bpf_ktime_get_real_ns(void)
+ * 	Description
+ * 		Return a fine-grained version of the real (i.e., wall-clock) time,
+ * 		in nanoseconds. This clock is affected by discontinuous jumps in
+ * 		the system time (e.g., if the system administrator manually changes
+ * 		the clock), and by the incremental adjustments performed by adjtime(3)
+ * 		and NTP.
+ * 		See: **clock_gettime**\ (**CLOCK_REALTIME**)
+ * 	Return
+ * 		Current *ktime*.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5339,6 +5351,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(ktime_get_real_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 13e9dbeeedf3..acdf538b1dcd 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2627,6 +2627,7 @@ const struct bpf_func_proto bpf_get_prandom_u32_proto __weak;
 const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
 const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
+const struct bpf_func_proto bpf_ktime_get_real_ns_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_coarse_ns_proto __weak;
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 315053ef6a75..d38548ed292f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -159,6 +159,18 @@ const struct bpf_func_proto bpf_ktime_get_ns_proto = {
 	.ret_type	= RET_INTEGER,
 };
 
+BPF_CALL_0(bpf_ktime_get_real_ns)
+{
+	/* NMI safe access to clock realtime. */
+	return ktime_get_real_fast_ns();
+}
+
+const struct bpf_func_proto bpf_ktime_get_real_ns_proto = {
+	.func		= bpf_ktime_get_real_ns,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+};
+
 BPF_CALL_0(bpf_ktime_get_boot_ns)
 {
 	/* NMI safe access to clock boottime */
@@ -1410,6 +1422,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
+	case BPF_FUNC_ktime_get_real_ns:
+		return &bpf_ktime_get_real_ns_proto;
 	case BPF_FUNC_ringbuf_output:
 		return &bpf_ringbuf_output_proto;
 	case BPF_FUNC_ringbuf_reserve:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d14b10b85e51..2565c587fe1b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5143,6 +5143,18 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
+ *
+ * u64 bpf_ktime_get_real_ns(void)
+ * 	Description
+ * 		Return a fine-grained version of the real (i.e., wall-clock) time,
+ * 		in nanoseconds. This clock is affected by discontinuous jumps in
+ * 		the system time (e.g., if the system administrator manually changes
+ * 		the clock), and by the incremental adjustments performed by adjtime(3)
+ * 		and NTP.
+ * 		See: **clock_gettime**\ (**CLOCK_REALTIME**)
+ * 	Return
+ * 		Current *ktime*.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5339,6 +5351,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(ktime_get_real_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.27.0

