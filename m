Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22D131D39A
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhBQBKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbhBQBJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:16 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4AAC06174A;
        Tue, 16 Feb 2021 17:08:36 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o63so7430530pgo.6;
        Tue, 16 Feb 2021 17:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oVZywqg18g72Uzq75qJ/vikx7hpNBGSQLyL0+doduHA=;
        b=lc7S+6vTJrLsoF2Cqr7PFoEXJEiCRamcWJ16soKt3cE4CgePjTvcwcmXpZwCLCZJTZ
         5f+Ev/tegpYYHw2iZslpubbwTjkRRle+rdGtGaMn/aLKUuX1WML8cfMTe4/aKG59AP5U
         k21jwfHR83ILsi93Pn3LDPjXDEO6KOzZPoWqVKYjxN0fUGAgLIx4XSOikQZh+1NWwMBg
         mm1t8N4iTCf1jAkMPaLo+cB9qf4gHobkowshsJWChMCnzT1nM1D+8Wfu/wc7uhgxyZls
         kH/jjXNmb4oQSY2+QnM3dKs6Zim1ilFSvl4smOQdqAq7JxdRZKpmaZ4xpBkHsM5Lg/EG
         sEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=oVZywqg18g72Uzq75qJ/vikx7hpNBGSQLyL0+doduHA=;
        b=GlWVLY8N13yY/g1+NO9RkM6iKUd9woN82l1IlFt9gjMSGH2RIcCsdeEqlTiZftQAEf
         K0xdjadv6OisxFxzv+FTaiAXN54xg3HIuoG/nEkf9PoXNabWR9yz3aqjfy10iLfnX2ua
         dgSR9Wb5pU+HXuw7tT2s3AlE3jiibWTmtQhxtkj1vaCQT2BaQWf2OEbQ8VSY3qQa5OGH
         SkG/FgyriqJtj1dE0Gpl0ljRt1kJIWhsiGb7A3mT+gDjV1lIr1qSPbul7MegamC7+jPk
         cEYl/whwJ9VwPmZhDC2tEnno6yoaWLuS0fkD1LoDJQo1UN/XeAX5SApXTxTZCNJT3BJz
         rviQ==
X-Gm-Message-State: AOAM531pjcsHSFpycQdOVkTE3tosziFnimUX8+QX1mhw0qDHcJFZoaKk
        npICf3r0qTERkJdYXneNTPkZpMfXaI7PEQ==
X-Google-Smtp-Source: ABdhPJzYiti8RcgJIeyzJvepBlP6NuqA8B0XcyaoG2664DoND4j8F6V+OstPNpVP976IjQ51I2ScvA==
X-Received: by 2002:a05:6a00:854:b029:1b7:6233:c5f with SMTP id q20-20020a056a000854b02901b762330c5fmr22491350pfk.73.1613524115581;
        Tue, 16 Feb 2021 17:08:35 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:34 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>,
        Daniel Mack <daniel@zonque.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sean Young <sean@mess.org>, Petar Penkov <ppenkov@google.com>
Subject: [PATCH bpf-next 05/17] bpf: Document BPF_PROG_ATTACH syscall command
Date:   Tue, 16 Feb 2021 17:08:09 -0800
Message-Id: <20210217010821.1810741-6-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Document the prog attach command in more detail, based on git commits:
* commit f4324551489e ("bpf: add BPF_PROG_ATTACH and BPF_PROG_DETACH
  commands")
* commit 4f738adba30a ("bpf: create tcp_bpf_ulp allowing BPF to monitor
  socket TX/RX data")
* commit f4364dcfc86d ("media: rc: introduce BPF_PROG_LIRC_MODE2")
* commit d58e468b1112 ("flow_dissector: implements flow dissector BPF
  hook")

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
CC: Daniel Mack <daniel@zonque.org>
CC: John Fastabend <john.fastabend@gmail.com>
CC: Sean Young <sean@mess.org>
CC: Petar Penkov <ppenkov@google.com>
---
 include/uapi/linux/bpf.h | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8301a19c97de..603605c5ca03 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -250,6 +250,43 @@ union bpf_iter_link_info {
  *		Attach an eBPF program to a *target_fd* at the specified
  *		*attach_type* hook.
  *
+ *		The *attach_type* specifies the eBPF attachment point to
+ *		attach the program to, and must be one of *bpf_attach_type*
+ *		(see below).
+ *
+ *		The *attach_bpf_fd* must be a valid file descriptor for a
+ *		loaded eBPF program of a cgroup, flow dissector, LIRC, sockmap
+ *		or sock_ops type corresponding to the specified *attach_type*.
+ *
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
+ *		**BPF_PROG_TYPE_SK_SKB**,
+ *		**BPF_PROG_TYPE_SK_MSG**
+ *
+ *			eBPF map of socket type (eg **BPF_MAP_TYPE_SOCKHASH**).
+ *
  *	Return
  *		Returns zero on success. On error, -1 is returned and *errno*
  *		is set appropriately.
-- 
2.27.0

