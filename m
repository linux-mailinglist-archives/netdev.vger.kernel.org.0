Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32C64030F8
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349253AbhIGWZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348325AbhIGWZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:05 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7407CC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:23:58 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id j13so25914edv.13
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VrYufPGtjCUT0dky9yDhI8t1ufTvbEptWesm+ao/2u0=;
        b=M6rYgPcRM/XxNtbSMsd5L2c+ztWnOku7cmwqnr5o4ezFRiBhmANsKRbLs2Idz47LH7
         lLlT2KcAIvWgC1I0kHtR1lRkga1dB38a5UvLA+zGCpC3wMmDLTWHxvrewgyoR3GXTkGk
         8fSIiUcnHLwrO8HZ67mU9Rg1Lu50TwDS27pKyHADMvPev4vlWXFw5ec5LtoN18gGukor
         6O7Xm4dAHW2ht8/eJa+xyvNe/XjseR+zfe2OyHObFIu+hV7+YHjON7z4opoG+Y63iGpo
         6KoadOA9BZB9EU+x80AXoOWO/C5+3D/HvG0iWeOL1zzh2zk0LKB11f9LrDrJKaj65WM7
         i9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VrYufPGtjCUT0dky9yDhI8t1ufTvbEptWesm+ao/2u0=;
        b=ikeJaHF8Hv0G+ceisBBvB2vdPqpTNF53/Y6PFU+7rsLD4sqx0vaSmmHdCzVX08Lk36
         9vRM6RvmW148ROhH2IUZDRhTQGxUXuR2cxUAQrrgX8M8sNaIsCKUCTFomoljIHi80LWV
         fst7yGOUKp9MuoGQHxJH4a9y4YMnGS+E6XloHWhyH/cDhsbTGKoDpBtlBiV7eDcfCWvU
         /NJKKRxvJ3nzRNuvHIYmvMXSieBSEEW4TrWARraRV71tmW831QcSQhDjT4HDJ0k6AWqG
         Y/imC42iRu/kdPdhen1qT6UIllLJt7zvy5HnSbKat+8ZtNvY60oIgAuawQKyIw+pYTmG
         j/pw==
X-Gm-Message-State: AOAM532/21LnGdtURxbOevUdSpTvrYXjZqiVE7aq+TXgZtRBF08TETQV
        LBKS1mEY0ZbNkQVygiNKEaGvZEgkxnLG0v2B8h0=
X-Google-Smtp-Source: ABdhPJxq/zVCKO+LcvpT4BOmvbBvObpGjqgAxUwKWfiwxPoRvleMXb4blJuA/NcsIQTueqQlLCDvMA==
X-Received: by 2002:a05:6402:40ce:: with SMTP id z14mr560238edb.28.1631053437078;
        Tue, 07 Sep 2021 15:23:57 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:56 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 08/13] bpf/tests: Add test case flag for verifier zero-extension
Date:   Wed,  8 Sep 2021 00:23:34 +0200
Message-Id: <20210907222339.4130924-9-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new flag to indicate that the verified did insert
zero-extensions, even though the verifier is not being run for any
of the tests.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 6a04447171c7..26f7c244c78a 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -52,6 +52,7 @@
 #define FLAG_NO_DATA		BIT(0)
 #define FLAG_EXPECTED_FAIL	BIT(1)
 #define FLAG_SKB_FRAG		BIT(2)
+#define FLAG_VERIFIER_ZEXT	BIT(3)
 
 enum {
 	CLASSIC  = BIT(6),	/* Old BPF instructions only. */
@@ -11280,6 +11281,8 @@ static struct bpf_prog *generate_filter(int which, int *err)
 		fp->type = BPF_PROG_TYPE_SOCKET_FILTER;
 		memcpy(fp->insnsi, fptr, fp->len * sizeof(struct bpf_insn));
 		fp->aux->stack_depth = tests[which].stack_depth;
+		fp->aux->verifier_zext = !!(tests[which].aux &
+					    FLAG_VERIFIER_ZEXT);
 
 		/* We cannot error here as we don't need type compatibility
 		 * checks.
-- 
2.25.1

