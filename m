Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2473F379A
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241041AbhHUAVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240976AbhHUAVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:23 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCD3C061764;
        Fri, 20 Aug 2021 17:20:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so8415228pjb.2;
        Fri, 20 Aug 2021 17:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=72O9qNsna3AtppqwP+BljMaHuTBoVRLTaIc1kmI4yiw=;
        b=DUSn8o4Q/JrDU6guC4hTWdTcD0HuxDF1Pwzn7/jjXi8Sfmg2LmFUVN0K/IKhr9WQbH
         GBeBNzf0N8jPHu2W7DlPUDP3yu0RT/AoYd6qP0biGZqAhx7PU8qfm5iixRsXgV1XBVw7
         8YS/0txnDPXDOmLZYSx7GZIyz2Gn8QMbggFBiXwihPbfOMwSLZO7KbM8ReQ7BXrTw+y/
         wRQYVnjQ9SMwxD/htLKZhYo7DuaFLryfdqWxr7RzI6OM6H/oF/qZpVO4Wpfccd1DNyiE
         mdKMBpHrCqww/iIuk1+CtZamG1hh37ZOdmVvT54LiKRYq7RPthCC2lsx6IpNGkZp2XJU
         G3XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=72O9qNsna3AtppqwP+BljMaHuTBoVRLTaIc1kmI4yiw=;
        b=L4WQJJllpW3W7RqRjHFTxWqV8c6T3BX7alXGz+84oUWYrMk197OqUDNtzOx0O4aRm/
         mcFScpq/OVrPKe6VMOA+gj9darojTCGZLKf+G0uetwLGx7A0qrVdYhDcYmcT1rYrvsS0
         i2xsvV20DDMkXI7PRLOimglrTT/rDEvJsN/Y/MR4gJwEEZ+KdukNVY5XAy/P+WtltOTN
         Ad4Ns7S6IBp3QdOdHBkK8VhoilFM60nHrU6NpFfTSnvOKbi0X2gfQDPuKeM5bydsPftE
         jDpeWMfAPUOHN4tsgkWMl5+l0i3nvQMU4J1dHmbythpM4HCnDPpcWyymO/ODynwVF0NY
         5y5g==
X-Gm-Message-State: AOAM533CN4iI7j1Tz5LuXefka1cUk/oWvqMl8NjWuxCPA3NRWUK0nw4B
        luYdXiEQFUXUszCq0ymH+SW3R0zc+9s=
X-Google-Smtp-Source: ABdhPJyWl9nLtyKsjZ5fnV+PNthkv68wPZbbEFqifzAP4sHv+tbwW+2gYVg50ZusJ4ixza5UCQJg9g==
X-Received: by 2002:a17:902:6b8a:b029:12d:3f99:9e5e with SMTP id p10-20020a1709026b8ab029012d3f999e5emr18595599plk.66.1629505244172;
        Fri, 20 Aug 2021 17:20:44 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id b5sm7350213pjq.2.2021.08.20.17.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:43 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 10/22] samples: bpf: Add BPF support for devmap_xmit tracepoint
Date:   Sat, 21 Aug 2021 05:49:58 +0530
Message-Id: <20210821002010.845777-11-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the devmap_xmit tracepoint, and its multi device
variant that can be used to obtain streams for each individual
net_device to net_device redirection. This is useful for decomposing
total xmit stats in xdp_monitor.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample.bpf.c | 71 ++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/samples/bpf/xdp_sample.bpf.c b/samples/bpf/xdp_sample.bpf.c
index f01a5529751c..0eb7e1dcae22 100644
--- a/samples/bpf/xdp_sample.bpf.c
+++ b/samples/bpf/xdp_sample.bpf.c
@@ -11,6 +11,14 @@ array_map redir_err_cnt SEC(".maps");
 array_map cpumap_enqueue_cnt SEC(".maps");
 array_map cpumap_kthread_cnt SEC(".maps");
 array_map exception_cnt SEC(".maps");
+array_map devmap_xmit_cnt SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 32 * 32);
+	__type(key, u64);
+	__type(value, struct datarec);
+} devmap_xmit_cnt_multi SEC(".maps");
 
 const volatile int nr_cpus = 0;
 
@@ -193,3 +201,66 @@ int BPF_PROG(tp_xdp_exception, const struct net_device *dev,
 
 	return 0;
 }
+
+SEC("tp_btf/xdp_devmap_xmit")
+int BPF_PROG(tp_xdp_devmap_xmit, const struct net_device *from_dev,
+	     const struct net_device *to_dev, int sent, int drops, int err)
+{
+	struct datarec *rec;
+	int idx_in, idx_out;
+	u32 cpu;
+
+	idx_in = from_dev->ifindex;
+	idx_out = to_dev->ifindex;
+
+	if (!IN_SET(from_match, idx_in))
+		return 0;
+	if (!IN_SET(to_match, idx_out))
+		return 0;
+
+	cpu = bpf_get_smp_processor_id();
+	rec = bpf_map_lookup_elem(&devmap_xmit_cnt, &cpu);
+	if (!rec)
+		return 0;
+	NO_TEAR_ADD(rec->processed, sent);
+	NO_TEAR_ADD(rec->dropped, drops);
+	/* Record bulk events, then userspace can calc average bulk size */
+	NO_TEAR_INC(rec->info);
+	/* Record error cases, where no frame were sent */
+	/* Catch API error of drv ndo_xdp_xmit sent more than count */
+	if (err || drops < 0)
+		NO_TEAR_INC(rec->issue);
+	return 0;
+}
+
+SEC("tp_btf/xdp_devmap_xmit")
+int BPF_PROG(tp_xdp_devmap_xmit_multi, const struct net_device *from_dev,
+	     const struct net_device *to_dev, int sent, int drops, int err)
+{
+	struct datarec empty = {};
+	struct datarec *rec;
+	int idx_in, idx_out;
+	u64 idx;
+
+	idx_in = from_dev->ifindex;
+	idx_out = to_dev->ifindex;
+	idx = idx_in;
+	idx = idx << 32 | idx_out;
+
+	if (!IN_SET(from_match, idx_in))
+		return 0;
+	if (!IN_SET(to_match, idx_out))
+		return 0;
+
+	bpf_map_update_elem(&devmap_xmit_cnt_multi, &idx, &empty, BPF_NOEXIST);
+	rec = bpf_map_lookup_elem(&devmap_xmit_cnt_multi, &idx);
+	if (!rec)
+		return 0;
+
+	NO_TEAR_ADD(rec->processed, sent);
+	NO_TEAR_ADD(rec->dropped, drops);
+	NO_TEAR_INC(rec->info);
+	if (err || drops < 0)
+		NO_TEAR_INC(rec->issue);
+	return 0;
+}
-- 
2.33.0

