Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E8A6B8676
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjCMX67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCMX66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:58:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4906187340;
        Mon, 13 Mar 2023 16:58:55 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id y2so13657220pjg.3;
        Mon, 13 Mar 2023 16:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678751935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSM+1NNi1Tfbc5IACqC5h/fXdbGu500kqDaYlPrdfOQ=;
        b=AtnhOoYq+zK89mkv9qjPLHbja1j6um2Gk6L3uAQBmNWoNQ+irAKn5p1EAvtCfyLB2g
         y1FWr0/0/CwQkO1c7q6GvM8y8JFYqx+xYDZKnEP80qnA2+EZOgLXYigq2shpEsatlEhT
         liF6AejJDbphN60aN7xEXmdSH/8UM0wmQ0lpjYIuGoRxdcrHBR2Y7TOjnhOdP75Ftj3Y
         C09it7o1gAZ46waGiQOX1f/jhbWdbHZDkDWvXl+zxEfmTFOsb0y6sX8PuycT+1pDQ7nb
         eguXztT/UYTYY8HybldI3QMOxaDfiTkZIx28/dFZ2++Nsq7hq4/6sprRNAwZnWZ6vVvH
         SteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678751935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSM+1NNi1Tfbc5IACqC5h/fXdbGu500kqDaYlPrdfOQ=;
        b=A+0r3jr5ZOCc9W5zJERb2F+jaRgoEdM0wS2ScB7ZHeg5yvts7c6SOxxLAsapdfsaH/
         zppZohnGMoyET6frKWBjEe7+tWvhwB1XukXwrmsOfM1FHULaWygj6KuskVKPFe0SP0Fe
         T1we8CedcyblsrX9xgDhoGSI/jnPtywpD7DL8ToJh0VSXp+45SyqEMuaDeGkxsfoGJdh
         OzOdnKsWAvVW/rJ1YRdwWqVBBF2De3FYRmmiuPCqmKBBER32dNphM0mSONiF+XWDQWLh
         BAgxNna3Hvadbtszf+go/WkUqVIQdXuahCKybXtQ4ZeeaG6vQtZpjmZOEoNdrZJeXW1V
         c+/g==
X-Gm-Message-State: AO0yUKWmGR79b4N8XnIgywStkTE6i0XDFZqJvtaI7+wgEPmyUEci1Rel
        gsS5t8X14KWOGwAerr13VtXoEXoq2Sk=
X-Google-Smtp-Source: AK7set8ZdaxBji0LMym0cdEIHkthsC0S4thdZEm40kUkwOArjGiAH41eoG5+6Uj5xCV4mvR2DcEPUQ==
X-Received: by 2002:a17:90b:1c05:b0:23a:ccb4:64de with SMTP id oc5-20020a17090b1c0500b0023accb464demr11948078pjb.6.1678751934613;
        Mon, 13 Mar 2023 16:58:54 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:ad6b])
        by smtp.gmail.com with ESMTPSA id my13-20020a17090b4c8d00b002339195a47bsm376400pjb.53.2023.03.13.16.58.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Mar 2023 16:58:53 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 1/3] bpf: Fix bpf_strncmp proto.
Date:   Mon, 13 Mar 2023 16:58:43 -0700
Message-Id: <20230313235845.61029-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
References: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
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

From: Alexei Starovoitov <ast@kernel.org>

bpf_strncmp() doesn't write into its first argument.
Make sure that the verifier knows about it.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 77d64b6951b9..f753676ef652 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -571,7 +571,7 @@ static const struct bpf_func_proto bpf_strncmp_proto = {
 	.func		= bpf_strncmp,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg1_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg2_type	= ARG_CONST_SIZE,
 	.arg3_type	= ARG_PTR_TO_CONST_STR,
 };
-- 
2.34.1

