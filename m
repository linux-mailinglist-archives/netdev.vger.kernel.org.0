Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB228560728
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiF2ROk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiF2ROj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:14:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377D03C706;
        Wed, 29 Jun 2022 10:14:38 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r20so23478626wra.1;
        Wed, 29 Jun 2022 10:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=QtkOAm0FQLhRgm9nQIcdvq/G+pjTMw1++vcyZDrhmCY=;
        b=qNeOuwYwu8CSAclcMtI0eB4EyowiRSGhu/GjxlWeh6+xNjCSTzlc0UjUNepKIAdiqs
         4A+DQe5VXZ0zghAi8AphvoK9Db//FTr3MD56CZ7FG+Vhvh3Tu4Hgb8+JEdeL8ky8IM7e
         6DBYY37p14oePiNVP7vXutAASoUg/HQQcDCECFIFweDQabA0LXWz4pknxGP2l/c6lRzN
         GVLvUdaE3HUpg5uDOXCHJJAx2razHNkL+pF0x5ZKrHX75/eUaoXLuqVKTM8+8sjphr8z
         t2EgrHI4vurdlXVKPR8R4X2Y0wVdOzlUgkfAf6H1tT1vnFaCw/CTIKs77cxgAxjJz3jI
         jnVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=QtkOAm0FQLhRgm9nQIcdvq/G+pjTMw1++vcyZDrhmCY=;
        b=09elqe3BuRXtt7ZNVP2iZnU9DY4hX+joCNDCY82QzrhU1d5FHVd+dGMVY5fESfUBk0
         5nlInFEb4iooWumNtuXmefUwa1V0FtGK6UiMeh9jksBLLKrnGBfLxQbKE+ziU2SAqwhc
         xwUDB0oRdL/Jsm6JYjdAsGSb20csTaiNrDxmuCJ135jrSAQxcWGG6ordCNr7/7NhngZ/
         IBKS62bRu7r6fdOpS0UhK5+0fuNU+Bf5N+wKPppHBZS+99DUkFpFk8gISBHq4S5MxOrV
         OCnZewOC3EXS6YKpc9xR4vuOj2cVtsBIy6gvhtQwyAByZ80teYoS7TYf69tnSBuqzX5P
         7b/g==
X-Gm-Message-State: AJIora/VCXw4r2gQ6ekNyQb7GsTGEcNBzHwdud5oAp3yuY4zOZd5Uns/
        N9DTi3wOjS4XhxLMl1I42pl51ok9lMp0fE+Brw==
X-Google-Smtp-Source: AGRyM1tIRAchdw3GOYBjxXnXREzBWUO8obItkKRDgyPyadqp50TYce8Wl312TzI0qDl6L/q9Bs7y1g==
X-Received: by 2002:a5d:6487:0:b0:21b:983c:5508 with SMTP id o7-20020a5d6487000000b0021b983c5508mr4197505wri.185.1656522876148;
        Wed, 29 Jun 2022 10:14:36 -0700 (PDT)
Received: from playground (host-78-146-72-11.as13285.net. [78.146.72.11])
        by smtp.gmail.com with ESMTPSA id d11-20020a5d6dcb000000b0020e6ce4dabdsm16636281wrz.103.2022.06.29.10.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 10:14:35 -0700 (PDT)
Date:   Wed, 29 Jun 2022 18:14:30 +0100
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 1/2] btf: Fix required space error
Message-ID: <YryIdu0jdTF+fIiW@playground>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes error reported ny Checkpatch at bpf_log()

ERROR: space required after that , ctx:VxV
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 kernel/bpf/btf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2e2066d6af94..1bc496162572 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5454,7 +5454,9 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 
 		if (ctx_arg_info->offset == off) {
 			if (!ctx_arg_info->btf_id) {
-				bpf_log(log,"invalid btf_id for context argument offset %u\n", off);
+				bpf_log(log,
+					"invalid btf_id for context argument offset %u\n",
+					off);
 				return false;
 			}
 
-- 
2.36.1

