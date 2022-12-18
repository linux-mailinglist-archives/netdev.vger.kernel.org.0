Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FDF64FD2D
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 01:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiLRAIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 19:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiLRAIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 19:08:04 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801B9FAE9;
        Sat, 17 Dec 2022 16:08:03 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id fy4so5874348pjb.0;
        Sat, 17 Dec 2022 16:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGJubt8HF7jBnIg3wM08JRpJ2gzwaKNjVWAVkyCf2Ao=;
        b=deQgBYq2p378zf9Jh83E9DNnRBLfyISSbQ4HQGGjuGpWTw0TWzhwaz+LOvfuvQisAn
         3w90eXUiaXrmghTPEXl2bD57G3ZEBFYQAWxJLkhy7zRbj4r2FmpqqomlhZCi536brAaL
         1e8vapLx6c+RO5fQkEueQeYHMV1RhZEWwhZXHK91WM75nNIYncXlKMhgaD2AD/xpDXwv
         r0o6gywSY6dVp1NQonCqeeW+W+/G5wKKNPTXtT9Fq0ulGLmRrfhgNqd9OMaNiWhjHlnC
         GNQ1UUdOSCOrONnSHr1uIbZz97mcRxu+owF8iCYVXaxQtbR7dfFVRoSjmLj59tD9yKEI
         SLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGJubt8HF7jBnIg3wM08JRpJ2gzwaKNjVWAVkyCf2Ao=;
        b=ks1QlBFmjfebUSnj0thL5VHmjqV+WPH3J3bZCOMUFTQY7N3L1n+LDOmEU1pdHK9EX5
         akn8zL/OQ+A7z4WI33dG9q4oDJgoWmmZ8dvLSppnNtr3iwFppPFwmL4d0ZORexbKykqx
         YbLFFq+kwuZ5Vd/UY1BDjC+B4dsNaTXO3tWyH+4iQSLkE8N4sArKnpntfBn4k3vcsQV/
         7QwsdN5gO0C+NlXKNU0AObV9F3WI4V2vkMgcN2YXxAn70syxkXsSMmoad4SCr+1T5ZAH
         jSPirFx8B/vyhkYY5B5FoqF5E9L+x4gu4yyYz4JL6MJFRK1xuQhHvzHQKJ6qEnSLt8tj
         gklQ==
X-Gm-Message-State: ANoB5plwJ/6n4OZnNoTUeHqsBjh90p5RXsQ+gK/Rbrbak4hjxfCxexaM
        DTBJyMSZIIg36J+IF+v/CBT9D2gJcL1e
X-Google-Smtp-Source: AA0mqf6EN/md6fbBfM15KJ2Foz+i6HfIoamERRAfQTdYOVX3Cebvy2JXKcMUtnh4QAPnliTSiKJ9BA==
X-Received: by 2002:a05:6a21:9013:b0:a5:df86:f2b4 with SMTP id tq19-20020a056a21901300b000a5df86f2b4mr37572928pzb.58.1671322082929;
        Sat, 17 Dec 2022 16:08:02 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id r7-20020a63b107000000b00478bd458bdfsm3554330pgf.88.2022.12.17.16.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 16:08:02 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v2 2/3] samples/bpf: replace meaningless counter with tracex4
Date:   Sun, 18 Dec 2022 09:07:52 +0900
Message-Id: <20221218000753.4519-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218000753.4519-1-danieltimlee@gmail.com>
References: <20221218000753.4519-1-danieltimlee@gmail.com>
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

