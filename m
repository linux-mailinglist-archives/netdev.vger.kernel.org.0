Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA2950D24B
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 16:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239423AbiDXOhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 10:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239412AbiDXOho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 10:37:44 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB54B338A9;
        Sun, 24 Apr 2022 07:34:43 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n8so21552375plh.1;
        Sun, 24 Apr 2022 07:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TraAa9qxjleDjcKSV6cdBET+ximOcYjIqFdHiJLXCNQ=;
        b=d42AiVW50s9TABrjm13XKqTRuodcUHYC6ylnEacp7SaTKcZQ5YklbmqLVJEgRUkeZ+
         OBeikygE/Ma1lpsB3lIymZrourtRKOLjmMvUstuwB7qev2+BQQryYsRE/f8imrv5NmBA
         2+nJ/ZO2yvMVfPq8k650+ce/lwDGp6XuZYdwOYBKBbtRl80uniIZ5baC4/9LLdOEGTMu
         VDwkgZ7d1k7mqBSccztD29kt9v9YAWd2mPl4o4wdrRAh1FjvhT+vf3ACl8OC0PXag828
         ftIC/UFPZ6ZFGXAr5CLVaufPBfiJzZOq9MQCPogN/a4ISyhPHnuEec+iVXfos9X2JMh4
         G5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TraAa9qxjleDjcKSV6cdBET+ximOcYjIqFdHiJLXCNQ=;
        b=UIrNp61sCj2+PoJBLQLGXeZpfc8oT7g/08uWPxQBZIxnec+o/kII0ivJWi5LM78Blq
         3IpgLT9//s5MZ2BYZ2fpfFGULszlavKPj3l+NHADGQ6j3h9tBQrwVWV0TCpF7kYTjkJa
         rmU6w14bs3mgoHV44pROcU+i8V9RA0ISvuiUC1BEM0TBaVh9Tdl7ZwqzTFzaAc54yj+l
         CjwZhobNu5CFt7cn3rxKPypnjX5DHErQV9p2JouX5/Sd0YhruISdxiChuwe4XwnPWrSW
         6qqIQLhVR7m3mCgnacCKmwXLdBsF6FPE52iQNfXnsUfTRa0owM74gNqlzjAD5LvWBKLX
         oaug==
X-Gm-Message-State: AOAM531DCK+yDu80tfuDgfeCU4esjBHkwKMbbD7fmToVc6if/Ff0TSqI
        X9/aHTpA75neYz/z3xQbot7baFvzgoG52w==
X-Google-Smtp-Source: ABdhPJwTZ6KgukTB9CJWdmkYdUg6KWAiPkj0nDfLsny3nxvpcrrj6CMe+ZGCdXYmnQBissnFmI0UaA==
X-Received: by 2002:a17:902:f605:b0:154:aa89:bd13 with SMTP id n5-20020a170902f60500b00154aa89bd13mr13819802plg.112.1650810883135;
        Sun, 24 Apr 2022 07:34:43 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id n16-20020a17090a091000b001d2bff34228sm5659369pjn.9.2022.04.24.07.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 07:34:42 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] libbpf: Remove unnecessary type cast
Date:   Sun, 24 Apr 2022 22:34:20 +0800
Message-Id: <20220424143420.457082-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.3
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

The link variable is already of type 'struct bpf_link *', casting it to
'struct bpf_link *' is redundant, drop it.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9a213aaaac8a..cc1a8fc47f72 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11270,7 +11270,7 @@ static struct bpf_link *bpf_program__attach_btf_id(const struct bpf_program *pro
 		return libbpf_err_ptr(pfd);
 	}
 	link->fd = pfd;
-	return (struct bpf_link *)link;
+	return link;
 }
 
 struct bpf_link *bpf_program__attach_trace(const struct bpf_program *prog)
-- 
2.35.3

