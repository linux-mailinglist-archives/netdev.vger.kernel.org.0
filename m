Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5504CDA9C
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbiCDRdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241340AbiCDRdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:33:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 982301CD9D0
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jXjAemh+tgaeshWdU0Zw5DqV+Jw6OpdtZV+yJ3YWHiI=;
        b=Pq7oeTiZim9L821up8Bt3uocFT/eU/E65NZHoJlL0nObHmj2VUQZXsbPFfcZgyUx/LcgAx
        P29tuo0YljEnqu1VlOzAfUjrJlSBuMzSGqEWodX0j2feEF39NlXpAnECSittVQQdOjOJSb
        LvBlR0i2K7aFq4xiz/1bMB3vszFO/PM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-hTrIEclbMQmRMq9TQ7IA5A-1; Fri, 04 Mar 2022 12:32:12 -0500
X-MC-Unique: hTrIEclbMQmRMq9TQ7IA5A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59BC51091DA0;
        Fri,  4 Mar 2022 17:32:10 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49C2486595;
        Fri,  4 Mar 2022 17:32:06 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v2 11/28] samples/bpf: add a report descriptor fixup
Date:   Fri,  4 Mar 2022 18:28:35 +0100
Message-Id: <20220304172852.274126-12-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the program inverts the definition of X and Y at a given place in the
report descriptor of my mouse.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 samples/bpf/hid_mouse_kern.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/samples/bpf/hid_mouse_kern.c b/samples/bpf/hid_mouse_kern.c
index c24a12e06b40..958820caaf5d 100644
--- a/samples/bpf/hid_mouse_kern.c
+++ b/samples/bpf/hid_mouse_kern.c
@@ -62,5 +62,30 @@ int hid_x_event(struct hid_bpf_ctx *ctx)
 	return 0;
 }
 
+SEC("hid/rdesc_fixup")
+int hid_rdesc_fixup(struct hid_bpf_ctx *ctx)
+{
+	if (ctx->type != HID_BPF_RDESC_FIXUP)
+		return 0;
+
+	bpf_printk("rdesc: %02x %02x %02x",
+		   ctx->data[0],
+		   ctx->data[1],
+		   ctx->data[2]);
+	bpf_printk("       %02x %02x %02x",
+		   ctx->data[3],
+		   ctx->data[4],
+		   ctx->data[5]);
+	bpf_printk("       %02x %02x %02x ...",
+		   ctx->data[6],
+		   ctx->data[7],
+		   ctx->data[8]);
+
+	ctx->data[39] = 0x31;
+	ctx->data[41] = 0x30;
+
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
 u32 _version SEC("version") = LINUX_VERSION_CODE;
-- 
2.35.1

