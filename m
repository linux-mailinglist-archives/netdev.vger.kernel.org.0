Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7AE64FD4C
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiLRAnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiLRAnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:43:18 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABADBE0F;
        Sat, 17 Dec 2022 16:43:18 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d7so5777189pll.9;
        Sat, 17 Dec 2022 16:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGJubt8HF7jBnIg3wM08JRpJ2gzwaKNjVWAVkyCf2Ao=;
        b=ZvIAwzTcU+CbYY5kUHU5e709XFUhpyoCNTswg6h0hSAHV3Pir3/Z/rxV+2Yq5/KfiC
         g+ohZ8h47zANPaA6e9QkNN0q6tT3M2D51diM+9TaZ1sAay42li2/gJAgV4MOcNxEmtgb
         qJ69WBoKaJm19RgsQfHULgfwwxKiTNd/yv7FeDsW1gPt0j0OxEnvVJM2JsIbX3hMOC9q
         k381oE7c+Vs8w1EbldQ/RT/FHJos6xt4JOekXNbrCAhj/5TZEOwBY7tkr+SPQFbK4aKI
         nxzRacvj/w5/rN1IN+VALOCendRgzof9Gj4Rqm/zd3oqmMIp1oz7KW2Y2i5E95owecHn
         LxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGJubt8HF7jBnIg3wM08JRpJ2gzwaKNjVWAVkyCf2Ao=;
        b=LoXlcWSyfzUzsqWMO7j0HRsFfdem3GQ1jBDe9cNNL1ZN2Jyj0i9BimASikW7YXarXy
         clUYHJAdqIfBrFm4UO+F/lH+CfzkaiWAUXqnsgNjc9HTkPKAsgvgL2zsVY4MJe/aHSe8
         gCi62PcoYd9P7JrIRRqMonXNPYKosOkX25sK/W5BQC0zJhMmx8s8Ug3IisuHdmjh8aNH
         LEtezsVDODzLR4M0q8ONGp7kL83vYn0yjuN1eO8EB/Cc0TOTKxTS6g0/K42WM5pdlRgf
         XJkkIy3QAsWH9ZH6p20/UJ0aIyJFoOY/2r49dh1mstRdaKfAsWlNf+SDz5Cp2TrpISoR
         GwjA==
X-Gm-Message-State: ANoB5pmRe+arlj738KrNuGWnCJUvTTqzYAbUctGCYEOIYJrbJL3wpDzK
        x2osWbnE0bL6zdRUMUYz+A==
X-Google-Smtp-Source: AA0mqf5cYXpx7BMY7mQIfJg+ZejDxYTLXZYZUUDjroJAmpxKguBo5q82cn6W7jmDTUA6h0QowpOjXg==
X-Received: by 2002:a05:6a20:9b9a:b0:ab:fe5a:df95 with SMTP id mr26-20020a056a209b9a00b000abfe5adf95mr43045423pzb.15.1671324197553;
        Sat, 17 Dec 2022 16:43:17 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id k10-20020a63ff0a000000b0047048c201e3sm3639458pgi.33.2022.12.17.16.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 16:43:17 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 2/3] samples/bpf: replace meaningless counter with tracex4
Date:   Sun, 18 Dec 2022 09:43:06 +0900
Message-Id: <20221218004307.4872-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218004307.4872-1-danieltimlee@gmail.com>
References: <20221218004307.4872-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, compiling samples/bpf with LLVM warns about the unused but
set variable with tracex4_user.

    ./samples/bpf/tracex4_user.c:54:14:
    warning: variable 'i' set but not used [-Wunused-but-set-variable]
        int map_fd, i, j = 0;
                    ^
                    1 warning generated.

This commit resolve this compiler warning by replacing the meaningless
counter.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 samples/bpf/tracex4_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/tracex4_user.c b/samples/bpf/tracex4_user.c
index 227b05a0bc88..dee8f0a091ba 100644
--- a/samples/bpf/tracex4_user.c
+++ b/samples/bpf/tracex4_user.c
@@ -51,7 +51,7 @@ int main(int ac, char **argv)
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char filename[256];
-	int map_fd, i, j = 0;
+	int map_fd, j = 0;
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
@@ -82,7 +82,7 @@ int main(int ac, char **argv)
 		j++;
 	}
 
-	for (i = 0; ; i++) {
+	while (1) {
 		print_old_objects(map_fd);
 		sleep(1);
 	}
-- 
2.34.1

