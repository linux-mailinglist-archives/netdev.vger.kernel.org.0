Return-Path: <netdev+bounces-6435-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00FE6716436
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BFBA1C20C8A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D8E19924;
	Tue, 30 May 2023 14:31:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D493923C9C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:31:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E0DE5E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685457059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IY+aDNUqdQq4/NfjZxSNAtMLzXbraiKq59gH7QofM/w=;
	b=JZwJ1k+N3wotWHh3LRh6j6dD2Zichc5d78F3YlDPrENSFqQ3MgcfeHD/187Tjo5swpcT3U
	izjemo2KNVksdKGES0yRMw+f5QZtABrX30EwiXSj2Y/YimZkJz1U7IQV1g0U24vMDB4HXE
	xIetMCGB9m6d+d/5Axm6w6DWasi+MxM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-6QF8LPqKMPKfo6KndDCoqw-1; Tue, 30 May 2023 10:30:43 -0400
X-MC-Unique: 6QF8LPqKMPKfo6KndDCoqw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 793F21C0ED03;
	Tue, 30 May 2023 14:30:42 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.21])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3ED94140EBB8;
	Tue, 30 May 2023 14:30:42 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
	by firesoul.localdomain (Postfix) with ESMTP id 7D1A9307372E8;
	Tue, 30 May 2023 16:30:41 +0200 (CEST)
Subject: [PATCH bpf-next] samples/bpf: xdp1 and xdp2 reduce XDPBUFSIZE to 60
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Tariq Toukan <ttoukan.linux@gmail.com>,
 Daniel Borkmann <borkmann@iogearbox.net>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>,
 Tariq Toukan <tariqt@nvidia.com>, gal@nvidia.com, lorenzo@kernel.org,
 netdev@vger.kernel.org, andrew.gospodarek@broadcom.com
Date: Tue, 30 May 2023 16:30:41 +0200
Message-ID: <168545704139.2996228.2516528552939485216.stgit@firesoul>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Default samples/pktgen scripts send 60 byte packets as hardware
adds 4-bytes FCS checksum, which fulfils minimum Ethernet 64 bytes
frame size.

XDP layer will not necessary have access to the 4-bytes FCS checksum.

This leads to bpf_xdp_load_bytes() failing as it tries to copy
64-bytes from an XDP packet that only have 60-bytes available.

Fixes: 772251742262 ("samples/bpf: fixup some tools to be able to support xdp multibuffer")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 samples/bpf/xdp1_kern.c |    2 +-
 samples/bpf/xdp2_kern.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
index 0a5c704badd0..d91f27cbcfa9 100644
--- a/samples/bpf/xdp1_kern.c
+++ b/samples/bpf/xdp1_kern.c
@@ -39,7 +39,7 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
 	return ip6h->nexthdr;
 }
 
-#define XDPBUFSIZE	64
+#define XDPBUFSIZE	60
 SEC("xdp.frags")
 int xdp_prog1(struct xdp_md *ctx)
 {
diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
index 67804ecf7ce3..8bca674451ed 100644
--- a/samples/bpf/xdp2_kern.c
+++ b/samples/bpf/xdp2_kern.c
@@ -55,7 +55,7 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
 	return ip6h->nexthdr;
 }
 
-#define XDPBUFSIZE	64
+#define XDPBUFSIZE	60
 SEC("xdp.frags")
 int xdp_prog1(struct xdp_md *ctx)
 {



