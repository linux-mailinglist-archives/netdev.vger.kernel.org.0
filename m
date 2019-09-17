Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E20D9B4F40
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfIQNbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 09:31:38 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:57951 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728372AbfIQNbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 09:31:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D45D939E6;
        Tue, 17 Sep 2019 09:31:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Sep 2019 09:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=ZwW7fkRd9gZh9
        tDNNySIyBWq5uzvW1saTrgDMoAFOvk=; b=d4Y1LE9+5YPArtmdXmpgmcn92BecV
        iW9bhbWlVueDg+ZpgLeZro1c+F60+qDGdiARBYl4u9S++9iJ8nU4Nqqq064Q0qHB
        hzrb6hRtYV90cOrtmwLP0oEaObY6dJUjXvwoZV9qJ6OW8KD7IPUJFLDIKcYBWbGz
        qS/nWVnaOHCXbNTLmY1HytRTPTVJWyebRrJeDlLbQRykpiLugaX/1c/ruE9tFzNU
        cO1Axz9/EBE8xACXsjUCHdYXQFFf9per2bU+xgciEJA4ylLKRnGAvho+b0Pcfpe1
        2jmZslJX3wEjLUziZaNwgB/i7D6ZiS5NEFmHBx5rzkNcW2jUzy5HTJn6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=ZwW7fkRd9gZh9tDNNySIyBWq5uzvW1saTrgDMoAFOvk=; b=xxhskt1q
        hKcaUOxS7BV7J52wmR/pHhQhsNFvOHH9f6MLetOtLWD4aAJ2428PS/CI0K3fo2aZ
        MCobfzbCSmPOHcGE9v6Eo5236oqOYFIzFos87+TTp4nk3gWnjLX2gTseSGRL+R48
        7MoOfMPP9rHrnv1TKZTn41MGsHd0t29YUa+MdbMJ7ZAYd8RcMEQXVpjKm1Fx14bY
        gAltumB2wprDROmM69TF2ZNkanp/NELcVPdA8LtxZlcVLKiQ+jv0Pai5QlJd0vvK
        8kyb8ZZyjDSjjd0vMfqBj9lxEBODaOjs/s1co9U5ZkwAi2P7BBQMRQwYdKu3cTTa
        Ex2CLHooN9+kOQ==
X-ME-Sender: <xms:NeCAXdpbreVkFXAerqoEj-FOe2YWO636Zopgl38gEeSEyegrUV3QNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougig
    uhesugiguhhuuhdrgiihiieqnecukfhppeduleelrddvtddurdeiiedrtdenucfrrghrrg
    hmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihiienucevlhhushhtvghrufhi
    iigvpedu
X-ME-Proxy: <xmx:NeCAXVIX7Y5s-xzrzGPWDzZUBjyxRA679fSVE5YzKLrjEHbBITy4_Q>
    <xmx:NeCAXSgxmds41XRXftuYkr_5C2Y9WeDI1YZr80al--kqOYVilqLXuA>
    <xmx:NeCAXW-d-r7wq-m0ZuUZ164WJKF6YZzb6lC2SeUTwnBqolMax0kz7g>
    <xmx:NeCAXUGNZ8bMhweRGEb93l3dl8H9MV1qh3xA-lhY9-rhd0l1d65uC9qvvDw>
Received: from dlxu-fedora-R90QNFJV.thefacebook.com (unknown [199.201.66.0])
        by mail.messagingengine.com (Postfix) with ESMTPA id 771A5D6005B;
        Tue, 17 Sep 2019 09:31:32 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     Daniel Xu <dxu@dxuuu.xyz>, ast@fb.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 3/5] libbpf: Add helpers to extract perf fd from bpf_link
Date:   Tue, 17 Sep 2019 06:30:54 -0700
Message-Id: <20190917133056.5545-4-dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190917133056.5545-1-dxu@dxuuu.xyz>
References: <20190917133056.5545-1-dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is sometimes necessary to perform operations on the underlying perf fd.
There is not currently a way to extract the fd given a bpf_link, so add a
a pair of casting and getting helpers.

The casting and getting helpers are nice because they let us define
broad categories of links that makes it clear to users what they can
expect to extract from what type of link.

Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 tools/lib/bpf/libbpf.c   | 21 +++++++++++++++++++++
 tools/lib/bpf/libbpf.h   | 13 +++++++++++++
 tools/lib/bpf/libbpf.map |  3 +++
 3 files changed, 37 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e0276520171b..1ca0acd1d823 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4875,6 +4875,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 
 struct bpf_link {
 	int (*destroy)(struct bpf_link *link);
+	enum bpf_link_type type;
 };
 
 int bpf_link__destroy(struct bpf_link *link)
@@ -4908,6 +4909,24 @@ static int bpf_link__destroy_perf_event(struct bpf_link *link)
 	return err;
 }
 
+const struct bpf_link_fd *bpf_link__as_fd(const struct bpf_link *link)
+{
+	if (link->type != LIBBPF_LINK_FD)
+		return NULL;
+
+	return (struct bpf_link_fd *)link;
+}
+
+enum bpf_link_type bpf_link__type(const struct bpf_link *link)
+{
+	return link->type;
+}
+
+int bpf_link_fd__fd(const struct bpf_link_fd *link)
+{
+	return link->fd;
+}
+
 struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 						int pfd)
 {
@@ -4931,6 +4950,7 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 	if (!link)
 		return ERR_PTR(-ENOMEM);
 	link->link.destroy = &bpf_link__destroy_perf_event;
+	link->link.type = LIBBPF_LINK_FD;
 	link->fd = pfd;
 
 	if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, prog_fd) < 0) {
@@ -5224,6 +5244,7 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 	link = malloc(sizeof(*link));
 	if (!link)
 		return ERR_PTR(-ENOMEM);
+	link->link.type = LIBBPF_LINK_FD;
 	link->link.destroy = &bpf_link__destroy_fd;
 
 	pfd = bpf_raw_tracepoint_open(tp_name, prog_fd);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e8f70977d137..2ddef5315ff9 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -166,7 +166,20 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *path);
 LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *path);
 LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
 
+enum bpf_link_type {
+	LIBBPF_LINK_FD,
+};
+
 struct bpf_link;
+struct bpf_link_fd;
+
+/* casting APIs */
+LIBBPF_API const struct bpf_link_fd *
+bpf_link__as_fd(const struct bpf_link *link);
+
+/* getters APIs */
+LIBBPF_API enum bpf_link_type bpf_link__type(const struct bpf_link *link);
+LIBBPF_API int bpf_link_fd__fd(const struct bpf_link_fd *link);
 
 LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d04c7cb623ed..216713b9eef6 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -189,4 +189,7 @@ LIBBPF_0.0.4 {
 LIBBPF_0.0.5 {
 	global:
 		bpf_btf_get_next_id;
+		bpf_link__type;
+		bpf_link__as_fd;
+		bpf_link_fd__fd;
 } LIBBPF_0.0.4;
-- 
2.21.0

