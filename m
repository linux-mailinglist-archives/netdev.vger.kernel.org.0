Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041A053F858
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbiFGIkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiFGIkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:40:37 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE27D244B;
        Tue,  7 Jun 2022 01:40:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gd1so15075422pjb.2;
        Tue, 07 Jun 2022 01:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ATdsPi2nyPJrCtSwjLDoIDI28BDhkul0ZHRuVKbiVeU=;
        b=aTy3ycsVlPjY2qR2JGGXUJiDrOZTgH3ksWv8C+c7GZWR6X5euX9vCQ06ZcimtSh3D8
         +J59gFQneB3bS7Qz4Mv7kATRie5734whWmBkOKk/cuYU31JprsKSZR+6ABk002gTpQ37
         9U6Exmp9rcinLsPTr8DLWK0nhJFYMUVabMKRQPhdC64bXltPt08xV4EqaH8/nq9Nzts/
         OFcAZszvD8nQks0k+YpVTJcMbDaK15BcA21Rilf+jPLXKbGiqAhT+l0y/j86fnC+NRjt
         B6yIEz3ZN5r86DgHkuegURVkDEMd8hp6HkyWlrfhpSSuOdH40VDuZJHxeDyM5Ty8T6E9
         QoTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ATdsPi2nyPJrCtSwjLDoIDI28BDhkul0ZHRuVKbiVeU=;
        b=2sgu8y8gOsKU33mf4kngFmXQ2f6i5chLUADiJOQfOOR5wDX+oq8o9VGx/KoARzpj/t
         qamA53Uyp+qgD6qyIc2u5Y+Wdsp3/jxUKGe2I6/YweSggW11SZ3U7sHbVUY24CQFvioy
         lUxY7q6B2bXLofwtmBX5gvszW8nmbCn/TrooxvyDJd9jhTpXuhUXuBxGhzx+AWprETbc
         xoxLkCkXzvkBK7G+LondjDvqnYBoUq8kha+cES0dwv0grtXP3oWoAvdtiUxKq4D+ikQ4
         KiubgfcynHXYvNUauBePBHm+tL6jo5ToF2jhQZMYLXJ/uS4fsk8Fvzz2WuhpimYGUJfm
         WJ1w==
X-Gm-Message-State: AOAM533C5jbee8Emz7WdFE4ow5Sxy+L8KtsvWuQ63SarRuilpfMRLtHL
        g8f1rEGnnINFo8m9KnLN0uy9GHsWG2ID+g==
X-Google-Smtp-Source: ABdhPJzQSf5HJ9aGj1DdppbvbqcD+LOGyg5qhBgm5/amGSZFnYzAYZPoHzc1o1ucHFW11Lj66PD/Kg==
X-Received: by 2002:a17:90b:38c4:b0:1e6:89f9:73da with SMTP id nn4-20020a17090b38c400b001e689f973damr28443486pjb.220.1654591236349;
        Tue, 07 Jun 2022 01:40:36 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s18-20020aa78d52000000b0050dc76281fdsm12134047pfe.215.2022.06.07.01.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 01:40:35 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next 1/3] samples/bpf/xdpsock_user.c: Get rid of bpf_prog_load_xattr()
Date:   Tue,  7 Jun 2022 16:40:01 +0800
Message-Id: <20220607084003.898387-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607084003.898387-1-liuhangbin@gmail.com>
References: <20220607084003.898387-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1e4edb6d8c4f ("samples/bpf: Get rid of bpf_prog_load_xattr()
use") tried to remove all the deprecated bpf_prog_load_xattr() API..
But xdpsock_user.c was left as it set GCC diagnostic ignored
"-Wdeprecated-declarations".

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 samples/bpf/xdpsock_user.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index be7d2572e3e6..3ea46c300df2 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1742,17 +1742,22 @@ static void l2fwd_all(void)
 
 static void load_xdp_program(char **argv, struct bpf_object **obj)
 {
-	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type      = BPF_PROG_TYPE_XDP,
-	};
+	struct bpf_program *prog;
 	char xdp_filename[256];
 	int prog_fd;
 
 	snprintf(xdp_filename, sizeof(xdp_filename), "%s_kern.o", argv[0]);
-	prog_load_attr.file = xdp_filename;
+	*obj = bpf_object__open_file(xdp_filename, NULL);
+	if (libbpf_get_error(*obj))
+		exit(EXIT_FAILURE);
 
-	if (bpf_prog_load_xattr(&prog_load_attr, obj, &prog_fd))
+	prog = bpf_object__next_program(*obj, NULL);
+	bpf_program__set_type(prog, BPF_PROG_TYPE_XDP);
+
+	if (bpf_object__load(*obj))
 		exit(EXIT_FAILURE);
+
+	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
 		fprintf(stderr, "ERROR: no program found: %s\n",
 			strerror(prog_fd));
@@ -1885,10 +1890,10 @@ int main(int argc, char **argv)
 {
 	struct __user_cap_header_struct hdr = { _LINUX_CAPABILITY_VERSION_3, 0 };
 	struct __user_cap_data_struct data[2] = { { 0 } };
+	struct bpf_object *obj = NULL;
 	bool rx = false, tx = false;
 	struct sched_param schparam;
 	struct xsk_umem_info *umem;
-	struct bpf_object *obj;
 	int xsks_map_fd = 0;
 	pthread_t pt;
 	int i, ret;
-- 
2.35.1

