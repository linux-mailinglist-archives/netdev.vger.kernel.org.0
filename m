Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00E520A0D0
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 16:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405394AbgFYO1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 10:27:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22809 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405189AbgFYO1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 10:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593095229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aJMWF6nEMVTEkBQ3KGHol472KSqMk2el0vXzn497+4o=;
        b=Kjnp+GORB8OHGWDaNEgVS7SGxjLEuTfzVKYqlhh3rv8Kh/ojRrgxYjc4aV16A3xupgJu3r
        lDrqHYfd3sNMoUmAiD5Dn8KHILdsixaTA90jpDGBml7cf4Ufphhv2xsctq1EGpubdB2Y8W
        WlFYSTZRa/Ybf3Y8avhQKOuvC1/uFQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-M6DDAliuMYOJ3TP-qodGsw-1; Thu, 25 Jun 2020 10:27:05 -0400
X-MC-Unique: M6DDAliuMYOJ3TP-qodGsw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97C73464;
        Thu, 25 Jun 2020 14:27:03 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 294215D9CA;
        Thu, 25 Jun 2020 14:27:00 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E91ED30000B66;
        Thu, 25 Jun 2020 16:26:58 +0200 (CEST)
Subject: [PATCH bpf] libbpf: adjust SEC short cut for expected attach type
 BPF_XDP_DEVMAP
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, andriin@fb.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Ahern <dsahern@gmail.com>
Date:   Thu, 25 Jun 2020 16:26:58 +0200
Message-ID: <159309521882.821855.6873145686353617509.stgit@firesoul>
In-Reply-To: <CAADnVQ+tiHo1y12ae4EREtBiU=AKUW7upMV4Pfa8Yc7mrAsqEg@mail.gmail.com>
References: <CAADnVQ+tiHo1y12ae4EREtBiU=AKUW7upMV4Pfa8Yc7mrAsqEg@mail.gmail.com>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust the SEC("xdp_devmap/") prog type prefix to contain a
slash "/" for expected attach type BPF_XDP_DEVMAP.  This is consistent
with other prog types like tracing.

Fixes: 2778797037a6 ("libbpf: Add SEC name for xdp programs attached to device map")
Suggested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/lib/bpf/libbpf.c                             |    2 +-
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f17151d866e6..11e4725b8b1c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6659,7 +6659,7 @@ static const struct bpf_sec_def section_defs[] = {
 		.expected_attach_type = BPF_TRACE_ITER,
 		.is_attach_btf = true,
 		.attach_fn = attach_iter),
-	BPF_EAPROG_SEC("xdp_devmap",		BPF_PROG_TYPE_XDP,
+	BPF_EAPROG_SEC("xdp_devmap/",		BPF_PROG_TYPE_XDP,
 						BPF_XDP_DEVMAP),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
index 330811260123..0ac086497722 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
@@ -27,7 +27,7 @@ int xdp_dummy_prog(struct xdp_md *ctx)
 /* valid program on DEVMAP entry via SEC name;
  * has access to egress and ingress ifindex
  */
-SEC("xdp_devmap")
+SEC("xdp_devmap/map_prog")
 int xdp_dummy_dm(struct xdp_md *ctx)
 {
 	char fmt[] = "devmap redirect: dev %u -> dev %u len %u\n";


