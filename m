Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A651E3513
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgE0B5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:57:22 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:36855 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbgE0B5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 21:57:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id F0D13580130;
        Tue, 26 May 2020 21:57:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 26 May 2020 21:57:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=SR919SUjGUEOgu6aawZxJ9MFHn
        ifhK/bHfB0G/3X0fI=; b=cq4cSNvpUw5lOvBat5Giz2d/mr1nInrFIantibAv0K
        hJokOcclOiA06jjYNSb/wn1Eq99VWz7t87UWoWweDteZTadzoS0BMOPSFqjdBnXR
        baXzdq18JfaMZUuI++PwPsvSytyM6i4sPIMU6l6pozWlIT+xBvoQKhfiO/VMDePQ
        s2QRrK9WMyrNj696s0KB5yej99lkL4NLPw2Hpe+RmQkrpEF/t6+h9uYok6XezVl4
        epRQ4hbNre15zLlTqdi7xngcag2LKieQTlJNZ2p2Zq1beYoNlqUsRKiujgKV+JBu
        UthzjWkEE4WzE3nHU/bp9G/oVWoUPQXiQsFFhhT9CKyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SR919SUjGUEOgu6aa
        wZxJ9MFHnifhK/bHfB0G/3X0fI=; b=k7o/aCqWbLvj/TYg2w/MHA6UebWGpIuHz
        fMLSc4EZ+B5wiVvpSjYr1azP5krszIp5mx9fEvgd/ogZKxR7BvDPfyLvWKs7uzlO
        LDt3s+G4qY+eePW9wDrt0HCas//JVU+38ylAXF0N7UyQL9F0ynvemc+j9pkFtwub
        Zsw8Ef5Xh3zjylnEdiOxmk0SsMA8YISTGiiRTXqO9G9y/UF5RjHIpdEMo+a8uC/v
        sHv2bdo7iiCjmysnlVvYegdw0El9fCSYRGA5D2/VP9u4ahLQlAi+iyALe+FZgnNZ
        fMN6iOQffm46Ut30h9Mptqf+DlhccGuVNDVPYeffEJTKx28NVSAWw==
X-ME-Sender: <xms:AMnNXhkgQRzrFeZXHml6CVKTpKr1BjPRrTCG9X5wY4FFJqiMEAZzFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvfedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpefhvf
    fufffkofgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihu
    segugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpeeifffgledvffeitdeljedvte
    effeeivdefheeiveevjeduieeigfetieevieffffenucfkphepjeefrdelfedrvdegjedr
    udefgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:AMnNXs08kxfcZlxVTfc6s5Mg2voABwVlKDQCbkm9n-ClABInitVuGA>
    <xmx:AMnNXnpprRwZEB6eNarDnIcbEN8WqO-OHmH7cc7yFLcLmdkBpoZ5nQ>
    <xmx:AMnNXhnx9E-k8BokHtE2BFPaQkWVpn3YJwf5r8zLd5wF1-wehTV5Dg>
    <xmx:AMnNXtOWFFfbbb8vIDMv-joayJ2cUsN9uzADKJb9B1ijBs-RYannvQ>
Received: from localhost.localdomain (c-73-93-247-134.hsd1.ca.comcast.net [73.93.247.134])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A02E3060F09;
        Tue, 26 May 2020 21:57:18 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        bpf@vger.kernel.org
Cc:     Daniel Xu <dxu@dxuuu.xyz>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH bpf-next] libbpf: Export bpf_object__load_vmlinux_btf
Date:   Tue, 26 May 2020 18:57:04 -0700
Message-Id: <20200527015704.2294223-1-dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now the libbpf model encourages loading the entire object at once.
In this model, libbpf handles loading BTF from vmlinux for us. However,
it can be useful to selectively load certain maps and programs inside an
object without loading everything else.

In the latter model, there was perviously no way to load BTF on-demand.
This commit exports the bpf_object__load_vmlinux_btf such that we are
able to load BTF on demand.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 tools/lib/bpf/libbpf.c   | 2 +-
 tools/lib/bpf/libbpf.h   | 1 +
 tools/lib/bpf/libbpf.map | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5d60de6fd818..399094b1f580 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2477,7 +2477,7 @@ static inline bool libbpf_prog_needs_vmlinux_btf(struct bpf_program *prog)
 	return false;
 }
 
-static int bpf_object__load_vmlinux_btf(struct bpf_object *obj)
+int bpf_object__load_vmlinux_btf(struct bpf_object *obj)
 {
 	struct bpf_program *prog;
 	int err;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 1e2e399a5f2c..6cbd678eb124 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -147,6 +147,7 @@ LIBBPF_API unsigned int bpf_object__kversion(const struct bpf_object *obj);
 struct btf;
 LIBBPF_API struct btf *bpf_object__btf(const struct bpf_object *obj);
 LIBBPF_API int bpf_object__btf_fd(const struct bpf_object *obj);
+LIBBPF_API int bpf_object__load_vmlinux_btf(struct bpf_object *obj);
 
 LIBBPF_API struct bpf_program *
 bpf_object__find_program_by_title(const struct bpf_object *obj,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 381a7342ecfc..56415e671c70 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -261,6 +261,7 @@ LIBBPF_0.0.9 {
 		bpf_iter_create;
 		bpf_link_get_fd_by_id;
 		bpf_link_get_next_id;
+		bpf_object__load_vmlinux_btf;
 		bpf_program__attach_iter;
 		perf_buffer__consume;
 } LIBBPF_0.0.8;
-- 
2.26.2

