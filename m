Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE126DBCA6
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 21:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDHT0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 15:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDHT0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 15:26:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60409B750
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 12:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680981887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+TaSHMvwM09VD5vY0j30SG5yCXiQxaklbNl6ijmKOnE=;
        b=bL3AynRz7aB5gMdcX3KtidJeb0zgmaC7jG5TT0qL+DfJZFxwh9EXUiK9XHA3yhkcy2++7d
        i5B6Bwe+eUAXqxbuyrtXLJrCa4rYzEgTkFCfXr98W7T3iDkuaKg3pxtKh/cb/gGi7Rpj7v
        sXhcQrH7Y/qCWci8JZuT22RBW5deDQ4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-P2_bZ6THPmCcPhtHfVUSpg-1; Sat, 08 Apr 2023 15:24:43 -0400
X-MC-Unique: P2_bZ6THPmCcPhtHfVUSpg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96F7C3C0C88C;
        Sat,  8 Apr 2023 19:24:42 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E508492C14;
        Sat,  8 Apr 2023 19:24:42 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 641AB307372E8;
        Sat,  8 Apr 2023 21:24:41 +0200 (CEST)
Subject: [PATCH bpf V7 1/7] selftests/bpf: xdp_hw_metadata default disable
 bpf_printk
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, linux-rdma@vger.kernel.org
Date:   Sat, 08 Apr 2023 21:24:41 +0200
Message-ID: <168098188134.96582.7870014252568928901.stgit@firesoul>
In-Reply-To: <168098183268.96582.7852359418481981062.stgit@firesoul>
References: <168098183268.96582.7852359418481981062.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tool xdp_hw_metadata can be used by driver developers
implementing XDP-hints kfuncs.  The tool transfers the
XDP-hints via metadata information to an AF_XDP userspace
process. When everything works the bpf_printk calls are
unncesssary.  Thus, disable bpf_printk by default, but
make it easy to reenable for driver developers to use
when debugging their driver implementation.

This also converts bpf_printk "forwarding UDP:9091 to AF_XDP"
into a code comment.  The bpf_printk's that are important
to the driver developers is when bpf_xdp_adjust_meta fails.
The likely mistake from driver developers is expected to
be that they didn't implement XDP metadata adjust support.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index 4c55b4d79d3d..980eb60d8e5b 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -5,6 +5,19 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 
+/* Per default below bpf_printk() calls are disabled.  Can be
+ * reenabled manually for convenience by XDP-hints driver developer,
+ * when troublshooting the drivers kfuncs implementation details.
+ *
+ * Remember BPF-prog bpf_printk info output can be access via:
+ *  /sys/kernel/debug/tracing/trace_pipe
+ */
+//#define DEBUG	1
+#ifndef DEBUG
+#undef  bpf_printk
+#define bpf_printk(fmt, ...) ({})
+#endif
+
 struct {
 	__uint(type, BPF_MAP_TYPE_XSKMAP);
 	__uint(max_entries, 256);
@@ -49,11 +62,10 @@ int rx(struct xdp_md *ctx)
 	if (!udp)
 		return XDP_PASS;
 
+	/* Forwarding UDP:9091 to AF_XDP */
 	if (udp->dest != bpf_htons(9091))
 		return XDP_PASS;
 
-	bpf_printk("forwarding UDP:9091 to AF_XDP");
-
 	ret = bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
 	if (ret != 0) {
 		bpf_printk("bpf_xdp_adjust_meta returned %d", ret);


