Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27D064FAE6
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 16:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiLQPzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 10:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiLQPys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 10:54:48 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D45B8BABF;
        Sat, 17 Dec 2022 07:38:32 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n4so5119210plp.1;
        Sat, 17 Dec 2022 07:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iup7qw0+rj8DaZBRvEJ2soCZA1zKqIHJImQRSJG43gk=;
        b=K/+sKSytvNZOquFT4/eSf556X0cE/H3UeTVU7N+Phf2GjRaHXnJjwmpAOnDksKhVL2
         /09jixdjrCLSiTsCJGDY2928IftwBe8idg4IISV3Ym/qLpgmU+sKiAOynNhrpJVm85Lb
         8wrtlu9l3Kzetmhw9U/tNjsrdfoaByOFyp3WPTreYpn7s2pvCFGWpcErNFIteb6fDQh9
         gUt6RfDhB9bbzFxbSPp2l/iK6jVFGvKYw8Dtj0myDyJP6qJB5MV3IKmsoVckGMscE0Ra
         nUhBQskUeJh8zvXS0CoduwVJy9Ttg7nvzH3NgyC/VnEQo5c+D7t/txK8m1XZic416Jzb
         dnMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iup7qw0+rj8DaZBRvEJ2soCZA1zKqIHJImQRSJG43gk=;
        b=HT3ZkLMmHpHNLqxrUyhxnaHdiDJobkrInKXDE6XPuxVu/TSfBHiOJMm0t2SNbfLNjK
         o+UeIWVG2Y0WVqBzUsZNY34t5iyG3n89fyZs8O4t/Ipvha5MlU78NUGJCGRruxS7p2YQ
         jy3nB2dfIBx3XrSo9JFhZe+oQC20w92lO7eV+N6zBMrpZB+xgag7kY3FpMGa9tcpkj9v
         2HwYImYLvYhd6+5dfgLofGTSTS+/Hto+D7d7rSfDe6qUE9H/FGWHaOSm1LVM7CzTCDe+
         aUV+O0Fk8j9Sv7JBOIBmBgEnWwcAdkDRAnELFSrZoquqDZi1kUW2WqpKQQ3L3gOeZxVn
         uenQ==
X-Gm-Message-State: ANoB5plKwGIENN/vxoTiqbMMDZ4mNS64PJDIS/sHToWdNe6AmSpShZvr
        2aWQKfzt1UP+5wDUbHndAJ8e/HTvw0zu
X-Google-Smtp-Source: AA0mqf4G0aH5VznYgXb3khbLrXri8FJjJMAHHJob89tT7oFB9UObGnKvA2L6adL0BubvepuNT6VnhA==
X-Received: by 2002:a17:90a:e010:b0:21a:1291:e80f with SMTP id u16-20020a17090ae01000b0021a1291e80fmr37141631pjy.33.1671291510824;
        Sat, 17 Dec 2022 07:38:30 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id u31-20020a63235f000000b00488b8ad57bfsm732039pgm.54.2022.12.17.07.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 07:38:30 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 2/3] samples/bpf: replace meaningless counter with tracex4
Date:   Sun, 18 Dec 2022 00:38:20 +0900
Message-Id: <20221217153821.2285-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221217153821.2285-1-danieltimlee@gmail.com>
References: <20221217153821.2285-1-danieltimlee@gmail.com>
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

