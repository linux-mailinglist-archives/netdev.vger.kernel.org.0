Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9978D46C7B3
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242321AbhLGWuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbhLGWuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 17:50:52 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188D1C061574;
        Tue,  7 Dec 2021 14:47:21 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id q3so765243wru.5;
        Tue, 07 Dec 2021 14:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O39HyWOFBZUdrPmreABJfrxuR9d3BPOym69qD3t0Fwo=;
        b=OcdWNGmfAHOERVFlOngW3VtU4ZV4XYWa2nprnNgB1A7WDH1YEBnjmUXwmze98Ml97g
         alEpF0pIToI6zohB0AzSPpA+LBoCFLLXdF+vGp4ZLjGqgqgtrTZ5y2AAhWDKqeAnsREa
         R5zTj0Tz5wnuW9kN5hgl5Rs/RFxEWABPuQwissAEWrnH4+0Adwvo1GDeDQICsAJcUwfs
         dw5gZHYhPYSx1FYn2g/wu8gjdnwiXVyv0A0h8Fj8sjQQQzpE12H4aQUFvO3IOfO1SXma
         ARHmksmd6VUIhgPDQTt/WbPfAxVJQNDbFaWA3n7y+ECyQVl/4eZpWFA9ufXPEkdaPIhs
         rMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O39HyWOFBZUdrPmreABJfrxuR9d3BPOym69qD3t0Fwo=;
        b=mSh9BfJv0pu/ZCc04ufhNRkcJo6LbwGqMKmnJwhkXQ7nvTdMRNOX/tABhzl9kQSVvF
         uxEaPVXIzgonq1lDbx1BRMNwLnatZkLNY/3Zzz5wee9uxbzmio9vKRnNJpgT+Co5KayZ
         CmuTV0TNWZ2JyrDpkJDoDCRZJbCmg68Pbr7rfTpGT0480tbV0PDZKFr7b8rJ+xJCqoAB
         qHJVySHeVEA0Be+NOmjezXvGqFSJL/V20mshDnsVsa9k5DdxIZJy512Lp5+plFKAABvU
         vY1QGsX17iU6OrPoax/kPRxv+gEMBKB3KtRC0LbA/8sO2cx3ysJ2TrXIdBaS9ERS+xlb
         +8LQ==
X-Gm-Message-State: AOAM532lhEa19uKOgd1Kpv/LqngNZeQGLxAccZcCRZTp2uFtYnkxEMig
        e1GicTGHilRL+1U2xxf+mVo=
X-Google-Smtp-Source: ABdhPJx2+OaO2LWLFBLWfvNhY8D1veAxwiPR8r2M7DRaBnJ/ivOXkM73424dltZuqjE1hNsreXmPcA==
X-Received: by 2002:a5d:4008:: with SMTP id n8mr54191507wrp.489.1638917239718;
        Tue, 07 Dec 2021 14:47:19 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id p27sm847440wmi.28.2021.12.07.14.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 14:47:19 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: remove redundant assignment to pointer t
Date:   Tue,  7 Dec 2021 22:47:18 +0000
Message-Id: <20211207224718.59593-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pointer t is being initialized with a value that is never read. The
pointer is re-assigned a value a littler later on, hence the initialization
is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 48cdf5b425a7..c70f80055b8e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -836,7 +836,7 @@ static const char *btf_show_name(struct btf_show *show)
 	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
 	const char *name = NULL, *prefix = "", *parens = "";
 	const struct btf_member *m = show->state.member;
-	const struct btf_type *t = show->state.type;
+	const struct btf_type *t;
 	const struct btf_array *array;
 	u32 id = show->state.type_id;
 	const char *member = NULL;
-- 
2.33.1

