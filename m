Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911EF64FDE2
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 07:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiLRGPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 01:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiLRGPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 01:15:03 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF94CBF71;
        Sat, 17 Dec 2022 22:15:02 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id 17so6204155pll.0;
        Sat, 17 Dec 2022 22:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGJubt8HF7jBnIg3wM08JRpJ2gzwaKNjVWAVkyCf2Ao=;
        b=AWTw7bywADk0RpYc2IwKGa8FLo1KHB5vXZEjt+blt0YvgfOSyEimPqPEHrbpTVfcpV
         XULNszBTku7gFSJLeSRqSW81uGKmJJaQrdUIi/8dJQfOelVdj7UQ/L4fBZ/CAKGgUwrd
         lKcLdrzCg4PZEXI0vxDcbyPVDfgZcPqRYDSpJ3Wfpq5IwyXKDdkVaaweKbchpJrsJb7J
         MJ8BhnLjzKZ+/JeF88IalQAJNIQ4UYn3FRX3PhXCIsM7vdPdSc0aIJASZWOeMl+9Kv5b
         4LmCIxopmm0s6aRaaB3nlAxm26zZ7TvY34eo5gkx445/3G9BPO/2/Bd4AHJhJbw0hxUA
         FGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGJubt8HF7jBnIg3wM08JRpJ2gzwaKNjVWAVkyCf2Ao=;
        b=P87ko44umWxPsWhcVMoM+gyPi0cY12fSTqWlKx5WbTXpBURgDymWgcjrJQ77kWiN70
         OzR55nRbhp+GF3BmG+qOLvLprvaHWAyvGQvcorNTk1m44lOgzj1LllC5iFATizh3glFN
         tOYbCeEsX+r0XURwSdDYaHtUvepWmXm8eJNbNEhZG4yjgADdtCDpx33k9gsD7vMgXxlI
         JyWJqRE4fh+76ogrky0CVf9sEOihfR8YWsh/w/lhQxkZK0aDhsySQmgdQkhXC1x9jjO5
         UYR79ryq83TA7CPer8PqBtvMW/g59FtFTM+DiI5H+cBVa0ONIb/B5EN+g/TtCrnd6vfu
         ZXmg==
X-Gm-Message-State: ANoB5pmjgZW5Z0SFTk9Jobw1C9bE7TFmu3jY24AuLYcucX2Ox9p1rKYU
        /gYdUGmqRoivcsCcD915Wg==
X-Google-Smtp-Source: AA0mqf4bF8HMkMPUIBBLy0nhqJ9H215Pb0yd3hG7HofIfJ5qlYCaJt3wW10Y/p3SKJvPmI0hSIdMQw==
X-Received: by 2002:a17:90a:b281:b0:219:e761:97e0 with SMTP id c1-20020a17090ab28100b00219e76197e0mr38678814pjr.33.1671344102264;
        Sat, 17 Dec 2022 22:15:02 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id r21-20020a17090b051500b00219eefe47c7sm3721836pjz.47.2022.12.17.22.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 22:15:01 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v4 2/3] samples/bpf: replace meaningless counter with tracex4
Date:   Sun, 18 Dec 2022 15:14:52 +0900
Message-Id: <20221218061453.6287-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218061453.6287-1-danieltimlee@gmail.com>
References: <20221218061453.6287-1-danieltimlee@gmail.com>
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

