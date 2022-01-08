Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF4548826F
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 09:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiAHIkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 03:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiAHIkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 03:40:19 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E403AC061574;
        Sat,  8 Jan 2022 00:40:18 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso9100396pjb.1;
        Sat, 08 Jan 2022 00:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9zEwDmNMe5JERLrwlCRlU/+ORPGYL9TSSP35Lx3dN30=;
        b=CuClFgSfhd2sHttE34W8oabBRGxMtRezBYjAnGdE1RsZ83TYi8ViK3Xmg1auClddbx
         GwH8+CYdXARMc5nifS/9sklBitiGXcSlRdnrqDF2MuITggX4gShDw9xqSds5Vpz7jCdI
         obMtp+Es1uBXHuSFLk6cpS/sZ6r/fkDEt9tU/Jefu5BOy6FA9Xpo/UoGwAe8GN9aT+jK
         1ajH/DIXh2JtuFylbH9pgGuAyChKpvsSDU5ZJ/l+mvjagsxC1W4UekWKCzX8MoJQ7FJT
         8KTmDJSHASgXEZU6rzCV9rFAKcCM0kdexhEdPXqjC5bBR6WVtnaOtp1Qbp+chGejhIkn
         EijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9zEwDmNMe5JERLrwlCRlU/+ORPGYL9TSSP35Lx3dN30=;
        b=pG9tYXAsTSdT3aTmov757Z+rM75NpqEyN+m5LNXgJKDA/18KMOpgnMDVNtdEaqSLPG
         6XYrWqWQDxDTl7FDZyDT590iELjSA5w0gYRtes2jo9BCyy7HqgWdDyBlH5rr7gQvxa/G
         +a5ysUFDTFs30cgKvJ3O3qOWOBoYMWAt/u/Jytnvkgu2Fy8JDvgUrZPZHVLKSnNxPfoH
         7ZhbLlIRbCq9wGGogcAVz94Od2mn3P4sOgcihb3WXQ4gLfkDpTwgCKk3ANRbJWavvcx2
         H5TY8uKiv91chEqtwGwqz4XiAMo5D2qp6rYCX/RU531dmc99ppnfnsWzFvUnHVylTXpO
         zXtw==
X-Gm-Message-State: AOAM532mmWuZtz4BylICiWVfPfppiAdja/Y7cD7Hb59NxRIUUrC7uFPK
        br/F7XuaQQF5DfAKS+n5mR0=
X-Google-Smtp-Source: ABdhPJxgT+hITarZ5kOie4lgQKjGUCs4kcAxUmDsHXGRU8Ggif6Uqhy6zZ/xF3aIzhOlokShIaQfEQ==
X-Received: by 2002:a17:902:a3c4:b0:149:6639:4b86 with SMTP id q4-20020a170902a3c400b0014966394b86mr62292275plb.60.1641631218474;
        Sat, 08 Jan 2022 00:40:18 -0800 (PST)
Received: from localhost.localdomain ([111.199.185.103])
        by smtp.gmail.com with ESMTPSA id mq12sm1333897pjb.48.2022.01.08.00.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 00:40:18 -0800 (PST)
From:   Wei Fu <fuweid89@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Fu <fuweid89@gmail.com>
Subject: [PATCH bpf] tools/bpf: only set obj->skeleton without err
Date:   Sat,  8 Jan 2022 16:40:08 +0800
Message-Id: <20220108084008.1053111-1-fuweid89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After `bpftool gen skeleton`, the ${bpf_app}.skel.h will provide that
${bpf_app_name}__open helper to load bpf. If there is some error
like ENOMEM, the ${bpf_app_name}__open will rollback(free) the allocated
object, including `bpf_object_skeleton`.

Since the ${bpf_app_name}__create_skeleton set the obj->skeleton first
and not rollback it when error, it will cause double-free in
${bpf_app_name}__destory at ${bpf_app_name}__open. Therefore, we should
set the obj->skeleton before return 0;

Signed-off-by: Wei Fu <fuweid89@gmail.com>
---
 tools/bpf/bpftool/gen.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 5c18351290f0..e61e08f524da 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -928,7 +928,6 @@ static int do_skeleton(int argc, char **argv)
 			s = (struct bpf_object_skeleton *)calloc(1, sizeof(*s));\n\
 			if (!s)						    \n\
 				goto err;				    \n\
-			obj->skeleton = s;				    \n\
 									    \n\
 			s->sz = sizeof(*s);				    \n\
 			s->name = \"%1$s\";				    \n\
@@ -1001,6 +1000,8 @@ static int do_skeleton(int argc, char **argv)
 									    \n\
 			s->data = (void *)%2$s__elf_bytes(&s->data_sz);	    \n\
 									    \n\
+			obj->skeleton = s;				    \n\
+									    \n\
 			return 0;					    \n\
 		err:							    \n\
 			bpf_object__destroy_skeleton(s);		    \n\
-- 
2.25.1

