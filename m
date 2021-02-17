Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585C431D3A3
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhBQBK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhBQBJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:19 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747DBC06178B;
        Tue, 16 Feb 2021 17:08:39 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id w18so7341362pfu.9;
        Tue, 16 Feb 2021 17:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ObgloKUUku0ihUpaDdYn1V0eSJ13PyKERfA5sVWUhWc=;
        b=ei5tAvN9oUhW3g3BORq/vbSQdflED2tsYzNcG8pVJUVHYA7B/X9CGaaBN5HNjIUtXv
         0HYnH0CX4Z9Sv1zzx/luCQpwZ5DTXFsBfG0r2ep5cs/QhxFKB6cev0gtyhHZ0DiOJ8N4
         wLH35Qjsn17Ta50oE5IvchMJEhCdj8x3m8t1zBIYeU+Gl8xvhUj0vXTw4cfJ6wO5gCPC
         FiWyYCAHvd3phZuLsvXKo0r4U18ALQFCc9uOwD1j8w0AfqYAF2s6HNQHiIvyQlTN616G
         zk9Yt995AJIb1TlMQ5AwC9RFmxxwf0aFyxhdJU2sEJHUmeCejnodnOSRZj/eGVdioQYI
         cpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ObgloKUUku0ihUpaDdYn1V0eSJ13PyKERfA5sVWUhWc=;
        b=fd2L3uj/0IFzbr4jpRpU5sayqGvVj87I3PxkAOkJBUHRkAp8L1Qsf3hsKchjjQA1Ks
         bgVO8geSisW/dx8XL/FwTALj7hXUaImc5dEEMEyeZ+zL7gagjYCnmfw2xz5Xw5miZaCN
         KvQBEorX/CcTDyNiC7j63CDTR6UBr/V9F8s/YCwedSp7rTPS5/fzI+blZSZQKGjyw6xo
         nTSoj2obu1AZwDXLQ4qU/B4ALBS+qBZLOwGPoB8fseqN57pl05YfTxCfI/IwDiwWiWHU
         PcM+lBUhKT7rAQYYLuBPWIhtastmEM2Ham5w4Od+lu1/NpddqzhF7HvHdADSo/Q904I7
         Bsdg==
X-Gm-Message-State: AOAM532i1J02Jn+xanMRP+YV+LDTJsVAuVRh/VycXtW3jQ6pCfMmXx+r
        QhRpTnl1eHQcbIHTuVmqCeX5+BuLJHBl6A==
X-Google-Smtp-Source: ABdhPJyn/Q0NAIioFBOpOucvNNZ3GX7DGPEm/wkHJOxhQUl24G3Yv7e3PNWnl/bRQav8LYxDm5eeSg==
X-Received: by 2002:aa7:978a:0:b029:1e8:3607:9d3a with SMTP id o10-20020aa7978a0000b02901e836079d3amr21815371pfp.72.1613524118694;
        Tue, 16 Feb 2021 17:08:38 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:38 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 07/17] bpf: Document BPF_PROG_QUERY syscall command
Date:   Tue, 16 Feb 2021 17:08:11 -0800
Message-Id: <20210217010821.1810741-8-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Commit 468e2f64d220 ("bpf: introduce BPF_PROG_QUERY command") originally
introduced this, but there have been several additions since then.
Unlike BPF_PROG_ATTACH, it appears that the sockmap progs are not able
to be queried so far.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
CC: Alexei Starovoitov <ast@kernel.org>
---
 include/uapi/linux/bpf.h | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 86fe0445c395..a07cecfd2148 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -386,6 +386,43 @@ union bpf_iter_link_info {
  *		Obtain information about eBPF programs associated with the
  *		specified *attach_type* hook.
  *
+ *		The *target_fd* must be a valid file descriptor for a kernel
+ *		object which depends on the attach type of *attach_bpf_fd*:
+ *
+ *		**BPF_PROG_TYPE_CGROUP_DEVICE**,
+ *		**BPF_PROG_TYPE_CGROUP_SKB**,
+ *		**BPF_PROG_TYPE_CGROUP_SOCK**,
+ *		**BPF_PROG_TYPE_CGROUP_SOCK_ADDR**,
+ *		**BPF_PROG_TYPE_CGROUP_SOCKOPT**,
+ *		**BPF_PROG_TYPE_CGROUP_SYSCTL**,
+ *		**BPF_PROG_TYPE_SOCK_OPS**
+ *
+ *			Control Group v2 hierarchy with the eBPF controller
+ *			enabled. Requires the kernel to be compiled with
+ *			**CONFIG_CGROUP_BPF**.
+ *
+ *		**BPF_PROG_TYPE_FLOW_DISSECTOR**
+ *
+ *			Network namespace (eg /proc/self/ns/net).
+ *
+ *		**BPF_PROG_TYPE_LIRC_MODE2**
+ *
+ *			LIRC device path (eg /dev/lircN). Requires the kernel
+ *			to be compiled with **CONFIG_BPF_LIRC_MODE2**.
+ *
+ *		**BPF_PROG_QUERY** always fetches the number of programs
+ *		attached and the *attach_flags* which were used to attach those
+ *		programs. Additionally, if *prog_ids* is nonzero and the number
+ *		of attached programs is less than *prog_cnt*, populates
+ *		*prog_ids* with the eBPF program ids of the programs attached
+ *		at *target_fd*.
+ *
+ *		The following flags may alter the result:
+ *
+ *		**BPF_F_QUERY_EFFECTIVE**
+ *			Only return information regarding programs which are
+ *			currently effective at the specified *target_fd*.
+ *
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
  *		is set appropriately.
-- 
2.27.0

