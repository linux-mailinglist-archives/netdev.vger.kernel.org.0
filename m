Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5147B4F46
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 15:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfIQNbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 09:31:49 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60105 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfIQNbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 09:31:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 45CB32E12;
        Tue, 17 Sep 2019 09:31:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Sep 2019 09:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=wVxLkASr4WgjE
        Vi71vH9ixp5KrWmhI1orhWokzEt9X8=; b=zKcskGT4h6RF+C7xpW8WTiVytDeNa
        HGE6RrXYCxRA7F5ZB9rbVrqJzDS/zKZ8pvE10YxmWFgPO0C8FCdGln2Vp0oH1+Hq
        IQGkBz+WA2z20HxxcRBYokrANIwXhpi/9sIyV3BN0lXq95U5rJnX7eZEKqVBaj4X
        5H0N6p7oiuKdDFV2Pmz12AnBfK6xvPGA8XE3f5hxT/m3TomaE5zJniPWElw17rxE
        HsfpjOTzWgAszKmpIpDSiLTdRJCavv8YqHRtkAisZOQ7hBsSSGMF7NuQPkVxSvZf
        U4g9bhJkeQZKYRzyemYsxDCI+BHHCYWrqSqfh+0YNApVgNmq6zDNIkkHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wVxLkASr4WgjEVi71vH9ixp5KrWmhI1orhWokzEt9X8=; b=gYIH4hII
        Fji6sdX4JYHLkBMS56gs0v1KPOgaoY42JrmbY7lOe1Rv5VRWh/21BVAeilocaLLL
        GFWzO7xjux+blhkfxUbury5D0OWi6v2V/WdXBxruXfm3I/c0PnjN3VzwUnydqi98
        LZ6LXim9JjlnP0AjzbQwoYxRSI6Eq3v0Wl+DdUFAqqCROp9JlY2Rd1KMqtv95ESD
        zqYjMqF1p2FOYEAfjK0tlyl+oQ+mmsGQom8iUS59QrRKuwK7i2NYbXyuiz8PEeXw
        Z7ILDRCazM9WBIF7FZ7/9JPwSK8/+drFkStSC+kVVd6FfJdLxGDVunmsst5fDBnP
        b9sFP+mHySGcEg==
X-ME-Sender: <xms:N-CAXZ9-DJkucie8eaNvqi0-vxksMd_ZZAb2VZyGWlNJ566gTuknmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougig
    uhesugiguhhuuhdrgiihiieqnecukfhppeduleelrddvtddurdeiiedrtdenucfrrghrrg
    hmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihiienucevlhhushhtvghrufhi
    iigvpedu
X-ME-Proxy: <xmx:N-CAXXw2AwBjxrcJBTHnje3-5PPHyK21AUr71WMvfmeaPMz3qyZMsQ>
    <xmx:N-CAXWG23QpagREGjBmZM9z50Fl9nplFMRs8bDyM7KGS5ZC_-GveNg>
    <xmx:N-CAXVlAGceIfzeq4-DHzDYXQh3cHSm2tCUkCveEqVrayTM7v8oeaA>
    <xmx:N-CAXcMf8y7_SHDLy9mDZZE-6dbJtLTzApEQMzII01Y-08FG9j2RwMBtWz8>
Received: from dlxu-fedora-R90QNFJV.thefacebook.com (unknown [199.201.66.0])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4DBED6005D;
        Tue, 17 Sep 2019 09:31:33 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     Daniel Xu <dxu@dxuuu.xyz>, ast@fb.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 4/5] libbpf: Set read_format PERF_FORMAT_LOST on kprobe perf fds
Date:   Tue, 17 Sep 2019 06:30:55 -0700
Message-Id: <20190917133056.5545-5-dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190917133056.5545-1-dxu@dxuuu.xyz>
References: <20190917133056.5545-1-dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no way to get the nmissed count from kprobes that are created
using the perf API. The previous commits added read_format support for
this count. Enable it in this commit.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 tools/lib/bpf/libbpf.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1ca0acd1d823..43f45f6d914d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5031,7 +5031,7 @@ static int determine_uprobe_retprobe_bit(void)
 }
 
 static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
-				 uint64_t offset, int pid)
+				 uint64_t offset, int pid, uint64_t read_format)
 {
 	struct perf_event_attr attr = {};
 	char errmsg[STRERR_BUFSIZE];
@@ -5060,6 +5060,7 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
 	}
 	attr.size = sizeof(attr);
 	attr.type = type;
+	attr.read_format = read_format;
 	attr.config1 = ptr_to_u64(name); /* kprobe_func or uprobe_path */
 	attr.config2 = offset;		 /* kprobe_addr or probe_offset */
 
@@ -5087,7 +5088,8 @@ struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
 	int pfd, err;
 
 	pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
-				    0 /* offset */, -1 /* pid */);
+				    0 /* offset */, -1 /* pid */,
+				    PERF_FORMAT_LOST /* read_format */);
 	if (pfd < 0) {
 		pr_warning("program '%s': failed to create %s '%s' perf event: %s\n",
 			   bpf_program__title(prog, false),
@@ -5118,7 +5120,8 @@ struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
 	int pfd, err;
 
 	pfd = perf_event_open_probe(true /* uprobe */, retprobe,
-				    binary_path, func_offset, pid);
+				    binary_path, func_offset, pid,
+				    0 /* read_format */);
 	if (pfd < 0) {
 		pr_warning("program '%s': failed to create %s '%s:0x%zx' perf event: %s\n",
 			   bpf_program__title(prog, false),
-- 
2.21.0

