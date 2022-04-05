Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958A74F44D4
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387163AbiDEOaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344185AbiDEOX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:23:28 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A3A6C4A1;
        Tue,  5 Apr 2022 06:09:48 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so2458777pjn.3;
        Tue, 05 Apr 2022 06:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=29tSKU5CIi5toN+mzQg/xoJLGhPPII1qeJKEVizdgAc=;
        b=SRHOtseHc3pgC9262T5fALIRfUCgNFOtq/kJ4SSuFnNHnhNZqZZQlXEkANgg+trIdE
         +54wu9Q2BZeb4Q1ImhlCL+Y0MSDccyemKVgVR4hvitsZyEUfw6d6Dr3hRd6JaOAvfoui
         LT57HVqFG0GGB0svFLzQM94lCbkgsA0f+ZLtmEZNLUNUcwOMCKPoPbXPF2fgq0NHhtcm
         KSWeHn6ljeMP2ezaaZ2oVj9omtIzWS/PGjL4d10F5ebDQ53qcPZ2Sw0kEpOLKZD6fdWl
         kQCWK6AsPwdYWvj6bT4fDQXn6EZkMsD012l2zTdunmsfURrW77h0er5kZSfQAn19mPAy
         IHqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=29tSKU5CIi5toN+mzQg/xoJLGhPPII1qeJKEVizdgAc=;
        b=l/dl6DDcL/C3aBUGKfJ+yVmXMQ1fbfan8fFsrw1DV2L0GLlQB0MS5o0AH1A/D9z01K
         Nh6x8HklUlDaPhgAxfETe4YRYLLJfCvkkpAsXv3O8i1gNTsO7R9r17vmSzzPqbWpd0CH
         h5osieMpSkuhjpXHjFBCsvaV1XNR5XTrCy/+Q5koCXemmawC1uBAELD0QYdpk80v5abF
         uc04cMG3FNOoCGfDgtHSki1uxlA/Og09quKwBmtAwdB1dqfQ3yOREr++2wxGItBEIo4G
         vzjKhffkMY+e9e4nvxR7GoCqZjApB9bC/5+wSEUiOdoIGQHVviTWWOlJn2JrZ8KAYy/s
         LwCg==
X-Gm-Message-State: AOAM532oJnFRAW/0Uf866Z0JEFgmRoMTwD/2BAPPktvQi1FZZ6J2X/K8
        kSyjH7oI/0OVUA4MIXR+J1w=
X-Google-Smtp-Source: ABdhPJxpSXI5Hwcc+Th8R/v5CnSoyL21gAJjIWwHO38u7LmooE/0eNucZHJWA/m1F2s6Zcc1vfCAYw==
X-Received: by 2002:a17:90b:2406:b0:1ca:ab60:60ae with SMTP id nr6-20020a17090b240600b001caab6060aemr4085058pjb.226.1649164188292;
        Tue, 05 Apr 2022 06:09:48 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:47 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 24/27] bpf: bpftool: Remove useless return value of libbpf_set_strict_mode
Date:   Tue,  5 Apr 2022 13:08:55 +0000
Message-Id: <20220405130858.12165-25-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
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

libbpf_set_strict_mode alwasy return 0, so we don't need to check whether
the return value is 0 or not.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/bpftool/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index e81227761f5d..451cefc2d0da 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -507,9 +507,7 @@ int main(int argc, char **argv)
 		 * It will still be rejected if users use LIBBPF_STRICT_ALL
 		 * mode for loading generated skeleton.
 		 */
-		ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
-		if (ret)
-			p_err("failed to enable libbpf strict mode: %d", ret);
+		libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
 	}
 
 	argc -= optind;
-- 
2.17.1

