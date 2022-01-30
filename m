Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7678C4A3558
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 10:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354457AbiA3JaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 04:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354455AbiA3JaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 04:30:02 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAB8C061714;
        Sun, 30 Jan 2022 01:30:01 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so9472132pjq.0;
        Sun, 30 Jan 2022 01:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hwhiK/i0m2gMPbUVcACp59cbViDIBKcuhYUz1Evs1T8=;
        b=SuD27Uwt0VDKSTE/hpK3UZuAUqFXHAvhFsvcLUhQRKTsYPHnRI0c6V0HyqeD2GB4Lt
         3131mhQojJSEJ1QRUJCStJrmlGncfYqKyz6x8w5sG/+oPwXivgY5zT1bqATqP2FSaNqN
         EWXwhewG8LIWvVScBum9ffoC8MxRNFsC2RFTo+QmK9teDyZH1dJ7jHnFGoSOSQj6zqpQ
         sqwmvXtZu9JYtOpnAPk2H3T9IA0AZv/QW10jukl1ISXqEaZsHLsGzWLKhs9M4lDF3s8m
         1y6rk0ngTzfYApmqjGiTgdZRSdwVSQEuZJ5i2IMaK5yx+OL9Pg/l4Y979H4ci84g2379
         kinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hwhiK/i0m2gMPbUVcACp59cbViDIBKcuhYUz1Evs1T8=;
        b=vVdub2RmV4Iu8ndvt76cPdwZ1IK16ajCxaDtEx/P9KRt1lCs3EewYD9ZNK0pG30m9z
         638DVMkHVx+nECyrYM4mfFbLj723ccVEQ66+YifnInPAi4kLid/3+XAqaNZO0skSkFOJ
         bobMJSfwzDiHcMOlt8l0JNOit1FXQlPijzM4nyP19BH65RgMraxCD/ah2Weg8JduGBIu
         jD3HjwaJIuL3veTEhS938VIDHUXprcCJO4RYKvCfcMW6bBvxa/tK7tTsQaARkoSNdAY/
         huFZCaBph8poJ346bKb1GYhiN7wP+uiDRmhdPp4KcPekZzbRhDkIGDCa6MyKD7Vu9X5+
         10IQ==
X-Gm-Message-State: AOAM530KwaVvYTyqAZG9wSoMTd+TySLQUCUQszs0g1D4vkeB8BjInNO9
        JIUAIwS4Cs6RFNZv4vl93nc=
X-Google-Smtp-Source: ABdhPJxiXht9rQ0HJ5RMTZeHOXNaz82mVp0MXPm3OIsOJ7xyLtnXTTg6KUALVdRw3mTcR2Z9AEXxrQ==
X-Received: by 2002:a17:903:2290:: with SMTP id b16mr16037097plh.103.1643535001397;
        Sun, 30 Jan 2022 01:30:01 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id e28sm1159654pgm.23.2022.01.30.01.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 01:30:00 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH bpf-next v3 1/3] bpf, arm64: enable kfunc call
Date:   Sun, 30 Jan 2022 17:29:15 +0800
Message-Id: <20220130092917.14544-2-hotforest@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220130092917.14544-1-hotforest@gmail.com>
References: <20220130092917.14544-1-hotforest@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

Since commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
randomization range to 2 GB"), for arm64 whether KASLR is enabled
or not, the module is placed within 2GB of the kernel region, so
s32 in bpf_kfunc_desc is sufficient to represente the offset of
module function relative to __bpf_call_base. The only thing needed
is to override bpf_jit_supports_kfunc_call().

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/arm64/net/bpf_jit_comp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index e96d4d87291f..74f9a9b6a053 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1143,6 +1143,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	return prog;
 }
 
+bool bpf_jit_supports_kfunc_call(void)
+{
+	return true;
+}
+
 u64 bpf_jit_alloc_exec_limit(void)
 {
 	return VMALLOC_END - VMALLOC_START;
-- 
2.20.1

