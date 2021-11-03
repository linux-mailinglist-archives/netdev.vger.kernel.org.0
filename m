Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0365F443CDA
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 06:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhKCFuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 01:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbhKCFuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 01:50:10 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD46C061714;
        Tue,  2 Nov 2021 22:47:34 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s136so1451589pgs.4;
        Tue, 02 Nov 2021 22:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=13wA38efUk+CLxlcvK0usUF2pH5xqXkgtR8d+WLW2mE=;
        b=PGLzqcKlgttwbfvq2KTYEuKreQGgNyVGvMkHhPhSODg0wRrVnittJlIa5vDniutt2f
         HV5p7Q7zhYBhtR0U9osshZPHls9bBuV9pfvkrSk6ZplIH97bNTlQuFEf4B20ENhGo31q
         L1qwpQifafhq1wHK9fIsItj9MuIfuG30UV2mWdMOzZd0aIqBRIs3rksroTTQg4ZCcOUm
         52d+riRVLjDk4GrbIc1O0rhSUe+qILQmgMjsxgEb6NaNtn3fXtRH2p2AAbun0mxP+GTJ
         AKVtls8eBWn2fPGxG1LsAAYChhF+RduGcq5YlSMCDg578/Osjp53/4zWyMX/e4pbDPCR
         L+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=13wA38efUk+CLxlcvK0usUF2pH5xqXkgtR8d+WLW2mE=;
        b=PI2qrZo2W61AaHWeGVzxSIdCQA5hr9MWPcoDK2uEyTTAGkSfuBgtQqpPj08foFxfQc
         kQCQShAHcBTxg2IhThk7an31VP5Tm5WYwhF3fw51XgfaSkaEb2fadkQt1JEYsM+8cxy4
         pdLiuexBuJS4dAFZ4/szrBr9Ksk+AvOMAOcr/9rjHi/QQkcmNf80D9xkT/zPwgAtYP3+
         FjPsPkHjIGQEoZ4XnruWHv3M8ILZEHzbUwglfTD4P9hDvF0cItmrtP+afkz+ELXpwSOk
         ysLzHsH77jVYTIri+t5CHKHtM+43HhjEJAzP3Z7HPzmvcl2qXkLIoIkDslw5NcJ2rxDl
         LnPw==
X-Gm-Message-State: AOAM533Ff3x4xmlKXtu0WJ3qTq+v5vguvPN3jPqc5ZnYl/3dgIM+wRhi
        4IsTCDrY27f7BHyY52ODjRU=
X-Google-Smtp-Source: ABdhPJyS/aG/IRv7twiXT2Fqr1N5LOse4z2rWSbVQlzbnwjxliMTNLIBAeOXQVwxUgzBM96+B2+bqw==
X-Received: by 2002:a62:8454:0:b0:480:f581:3bef with SMTP id k81-20020a628454000000b00480f5813befmr25399350pfd.2.1635918454449;
        Tue, 02 Nov 2021 22:47:34 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id v16sm728039pgo.71.2021.11.02.22.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 22:47:34 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.mingyu@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, udknight@gmail.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Mingyu <zhang.mingyu@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] bpf, x86:remove unneeded variable
Date:   Wed,  3 Nov 2021 05:47:22 +0000
Message-Id: <20211103054722.25285-1-zhang.mingyu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Mingyu <zhang.mingyu@zte.com.cn>

Fix the following coccinelle REVIEW:
./arch/x86/net/bpf_jit_comp32.c:1274:5-8

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
---
 arch/x86/net/bpf_jit_comp32.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index da9b7cfa4632..bce7b9b5a653 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1271,7 +1271,6 @@ static void emit_epilogue(u8 **pprog, u32 stack_depth)
 static int emit_jmp_edx(u8 **pprog, u8 *ip)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 #ifdef CONFIG_RETPOLINE
 	EMIT1_off32(0xE9, (u8 *)__x86_indirect_thunk_edx - (ip + 5));
@@ -1280,7 +1279,7 @@ static int emit_jmp_edx(u8 **pprog, u8 *ip)
 #endif
 	*pprog = prog;
 
-	return cnt;
+	return 0;
 }
 
 /*
-- 
2.25.1

