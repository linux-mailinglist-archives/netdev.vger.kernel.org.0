Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140145AEFBB
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbiIFPzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiIFPzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:55:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471A38E44A
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662477213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1DaeNMwnIMma39gQy3Kd4VGsxLc+nlgISR5lWAO1mHM=;
        b=hlsvOGt8rpt9RrUKHjsIgH76WmbHgSYq4NjlyvLLGeyoo0W1AQJ3fcBEK/82eCQKcFWcTa
        oftxqm2qAk4IAaahOf07NmSGK4Er35wcUivVnlvblww8lLcvARXnp0KUdtdLZzicBG2sgD
        eQA0MECfXvIc6UFFsX/Ytim8NjtFo9M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-RC5XfcEtPBGGWbpc6W56lw-1; Tue, 06 Sep 2022 11:13:26 -0400
X-MC-Unique: RC5XfcEtPBGGWbpc6W56lw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E4A63801F5E;
        Tue,  6 Sep 2022 15:13:25 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49B7440D296C;
        Tue,  6 Sep 2022 15:13:23 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v11 5/7] bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
Date:   Tue,  6 Sep 2022 17:13:01 +0200
Message-Id: <20220906151303.2780789-6-benjamin.tissoires@redhat.com>
In-Reply-To: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/bpf/test_run.c is already presenting 20 kfuncs.
net/netfilter/nf_conntrack_bpf.c is also presenting an extra 10 kfuncs.

Given that all the kfuncs are regrouped into one unique set, having
only 2 space left prevent us to add more selftests.

Bump it to 64 for now.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v11

new in v10
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index eca9ea78ee5f..8280c1a8dbce 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -208,7 +208,7 @@ enum btf_kfunc_hook {
 };
 
 enum {
-	BTF_KFUNC_SET_MAX_CNT = 32,
+	BTF_KFUNC_SET_MAX_CNT = 64,
 	BTF_DTOR_KFUNC_MAX_CNT = 256,
 };
 
-- 
2.36.1

