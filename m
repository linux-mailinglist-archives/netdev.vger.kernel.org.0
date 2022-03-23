Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223124E4D74
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 08:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242269AbiCWHia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 03:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbiCWHi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 03:38:27 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BD35EDFD;
        Wed, 23 Mar 2022 00:36:53 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w8so746787pll.10;
        Wed, 23 Mar 2022 00:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m1iCmozCFO2nDUbdDZOeMBYLeshVtbE1//V44gRhfv8=;
        b=MqHMspPcSlKu9NLkB7yl/rkEVfNptO/w7y0kPb8esvKHzzWH+HAarv7W2zksAiOvGI
         L0smPUkUiYS9wnFvpXA5v+/kODBl8g9RSJC7wuoIRew8x2ULMgJidGZS7U+6GZHomqR+
         dDWPGSStirVRDj8dZZjVJ/TRFTrgJrfbg3tA47YXVxldwQK3s+NakqlxIAREsmGYcx/E
         CS2EZEd5uQJ58J6xxMAlmopw05uvtpaeIGkgidxIiACTsASMiIYWHDowxTDKoMX1v30b
         KqDYqoLRn5mOEwIGZfMZBW9QUCx7kpVAIfxFsd9mne+96jPRdWyX1cY1pECqxYU22Rz3
         uvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m1iCmozCFO2nDUbdDZOeMBYLeshVtbE1//V44gRhfv8=;
        b=j4Mr5P4hPKpNaKlhrnBAxDOA3roSNGrvvt0CZX9JKRPkwKLUUGxJ78cUtm+Eyoikn8
         N1ScFks3zFDhflni5vkt9GClhGQe0XtTxT9MUOxXhxmMWGm546JPdT98lf+OxBoJjeC/
         r936YLKonPKtuhiZChsnqSGZarBhDCw0al3J9V79UmWhTCi26EUNf5ex1w/R1OHUyXDV
         9JsanXu6cLTgZmd6xMmKHE0tq9N06FqzAhxyc+elROKzkaqWWWMx5u38FXRR8z+UWN0M
         Z2Edr9ZHn392noV5UfaO7ZpR65ZBQ+Hnp4/u/8eFupN+y7xDEldvvOOkOpgbOqtjNPJY
         9AiA==
X-Gm-Message-State: AOAM532oYTR0RSlh4h6+TDcOEyI9e2PPqHsCCsGwUUYMQAn609rpXCPw
        I5fBsk66/QKUXtUyTzArQMc=
X-Google-Smtp-Source: ABdhPJzPEEK9ZixNQwtvEIi5X0A3WXJM+iT8soYrHwThTS4gHEbROpq/XN7nXTl9qLmD3gS6GCfT+g==
X-Received: by 2002:a17:902:c40a:b0:154:2302:9b88 with SMTP id k10-20020a170902c40a00b0015423029b88mr22204578plk.165.1648021012846;
        Wed, 23 Mar 2022 00:36:52 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id u9-20020a056a00158900b004faad3ae570sm8416190pfk.189.2022.03.23.00.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 00:36:52 -0700 (PDT)
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
Subject: [PATCH bpf-next] bpf: Remove redundant assignment to smap->map.value_size
Date:   Wed, 23 Mar 2022 15:36:26 +0800
Message-Id: <20220323073626.958652-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The attr->value_size is already assigned to smap->map.value_size
in bpf_map_init_from_attr(), there is no need to do it again in
stack_map_alloc()

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/stackmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 34725bfa1e97..6131b4a19572 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -106,7 +106,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-ENOMEM);
 
 	bpf_map_init_from_attr(&smap->map, attr);
-	smap->map.value_size = value_size;
 	smap->n_buckets = n_buckets;
 
 	err = get_callchain_buffers(sysctl_perf_event_max_stack);
-- 
2.35.0.rc2

