Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E0B4D2D74
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 11:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiCIKy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 05:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiCIKyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 05:54:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEF87108BFA
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 02:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646823235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvNVqarfNkzMY75zhkRvdB+Wpo5cjAId5AeXOVZkNno=;
        b=Dd8VOMtF8D1/YwLhafCJ0eXc8PcGJOnHDyipqRCJRASK4komT62TWQXiZfH9I9Q0wVUx16
        tuRnmFbbd1mZw92HHpSYeH3M9Cyv7Z4jbmMjhISjGi1oP5hSi1fIG+MY7VF96kTxKo+uAJ
        WPYQ82qnGt4GApK91EXGoNoZejiWB7U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-COMiPWMMP-itP5R_4gx2_A-1; Wed, 09 Mar 2022 05:53:54 -0500
X-MC-Unique: COMiPWMMP-itP5R_4gx2_A-1
Received: by mail-ed1-f70.google.com with SMTP id i5-20020a056402054500b00415ce7443f4so1077001edx.12
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 02:53:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gvNVqarfNkzMY75zhkRvdB+Wpo5cjAId5AeXOVZkNno=;
        b=aS46DpChRpk/c5moMxq15hXbnjl7SuMIovs8X0afQv+fuqR89Kcf4/OKubNlZAYElP
         eKDoJcB9nwrhKRh1dkS+9QZF3QYed35JYQT7N2R7QBIBOVImnjY1pszO/D356r7Nk1FH
         y+2E+iCLiV2Yg9CR0is6rj4wYWXyDrCtc5XNkB0mhX6GtpR2rPc5JOZs6IcaDzoCrXaI
         /ik3eXyxoeerzS3j3tn5NtRkb5YwWXOTbpIzq4yMLiQuFEdMU/AjMGbI3lqNXYV7Z6Jv
         GhYoHFCxWqBsY1AXHPQrA6mnU98LhZOn0rvV7qt7lT1sqRoNn6D/BRn3xM/bZ8q5QLzN
         adlg==
X-Gm-Message-State: AOAM531dxeOOsE7IK4cQUr9dy6mckT4doHRNgr2iORAn7uZsgkmh/SZt
        Nw1cRDDW8aYRWgGKvv6jj7phD/pZI+SDScqxHBZK638Hl3vnonTmJiku1uarEjMQ20+kiiEmVBP
        blLexIhCsMTc0q6Eg
X-Received: by 2002:a17:906:2cce:b0:6ce:e203:d207 with SMTP id r14-20020a1709062cce00b006cee203d207mr17499401ejr.242.1646823231477;
        Wed, 09 Mar 2022 02:53:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwiBGngG/zHax2BmUCSjar0ja91djyo+GA0n5pE3tWqOwNGQkNPmwilIFwQe96dSJZmad2y6w==
X-Received: by 2002:a17:906:2cce:b0:6ce:e203:d207 with SMTP id r14-20020a1709062cce00b006cee203d207mr17499325ejr.242.1646823229945;
        Wed, 09 Mar 2022 02:53:49 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q9-20020a17090609a900b006cd30a3c4f0sm596115eje.147.2022.03.09.02.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 02:53:49 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9B1D5192AAB; Wed,  9 Mar 2022 11:53:48 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v11 3/5] libbpf: Support batch_size option to bpf_prog_test_run
Date:   Wed,  9 Mar 2022 11:53:44 +0100
Message-Id: <20220309105346.100053-4-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309105346.100053-1-toke@redhat.com>
References: <20220309105346.100053-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for setting the new batch_size parameter to BPF_PROG_TEST_RUN
to libbpf; just add it as an option and pass it through to the kernel.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf.c | 1 +
 tools/lib/bpf/bpf.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 3c7c180294fa..f69ce3a01385 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -995,6 +995,7 @@ int bpf_prog_test_run_opts(int prog_fd, struct bpf_test_run_opts *opts)
 
 	memset(&attr, 0, sizeof(attr));
 	attr.test.prog_fd = prog_fd;
+	attr.test.batch_size = OPTS_GET(opts, batch_size, 0);
 	attr.test.cpu = OPTS_GET(opts, cpu, 0);
 	attr.test.flags = OPTS_GET(opts, flags, 0);
 	attr.test.repeat = OPTS_GET(opts, repeat, 0);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 16b21757b8bf..5253cb4a4c0a 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -512,8 +512,9 @@ struct bpf_test_run_opts {
 	__u32 duration;      /* out: average per repetition in ns */
 	__u32 flags;
 	__u32 cpu;
+	__u32 batch_size;
 };
-#define bpf_test_run_opts__last_field cpu
+#define bpf_test_run_opts__last_field batch_size
 
 LIBBPF_API int bpf_prog_test_run_opts(int prog_fd,
 				      struct bpf_test_run_opts *opts);
-- 
2.35.1

