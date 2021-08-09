Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89043E42DF
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhHIJfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbhHIJfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:35:30 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677D5C061799
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:35:10 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id oz16so11633280ejc.7
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOjKYdZ56IxXdoddh6gT5LzULhq+XYbTvDzYpe88OIo=;
        b=vh8Jsgh2G7NoqCxPcJvq2CcBOKUpX6sbGNCrktfTlKggrxMbxRfwrIFyRELsPPTT5+
         L8h7YoO9fbeyvSg1sGrZvEc1o4qKaKwNyupBkQzTOc8evJ559OqpkUp4acXv78yKmJeN
         QduLtlsVaPTKoerVl1Qdz6ZZ4Z5vW6npEJyX+VXvfU0MiNwe7iirU+WGPtcx1I5DTt4M
         hn2Cr11+T5mueHpd3IwA/HUis33q/q7CxFFMJbLwo65aerYGnyTBLh8NsJI3SjOCq114
         idvCnNbCGknR5s6Pzhq8Afz1zce3ZJUd9XoB9QbwRBUcBLEsMVFjwBhq8iPt1EHx8zZL
         r1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOjKYdZ56IxXdoddh6gT5LzULhq+XYbTvDzYpe88OIo=;
        b=LcGbYy4BOZNlXjhACHOcJk4Ss07Xk6W4mM2LoLaOzxX3s4KaXj6tPCDC8hgYNHVEjO
         w5ljtPemw1hj0UmRRVwNABxITPaQ3oQQrZbAlY7PvHQ8Os4k1yYpbUxzJH0lLxQHIt70
         ZUSevf0VZMTiMaDgpmTjl/EX/Sj4X+o8aKYjx+8OEnkgFR0eon2aupWnB4TiZVB40PKp
         E+3aUboiD7C3p+YEAuZmpvUTR8TlWR/q/uu3N9KiFWE5ZfslfeKC7rom/ud5M+15WDaO
         TmzPW8K8zXdHYE+aTOc9gsm8MKU+DJTP67LHlnw3gnGq5G5TusSe1y5GI1051LM2Imvd
         bdwA==
X-Gm-Message-State: AOAM532b3jmA19XGDtuY1cwVQevJosQ3fjHk2RUUM2W5jPTAh1iIsTTC
        0qXatiTUKF1jt/S8KDQMYLrlDA==
X-Google-Smtp-Source: ABdhPJwhg7f58AKgn5rt8ouratg49c6RPKgI1rtqXIbF4oM0hO3q9Q9GtqLPX2lLO7wZe9l7ogPH+w==
X-Received: by 2002:a17:906:aac7:: with SMTP id kt7mr2976221ejb.4.1628501709060;
        Mon, 09 Aug 2021 02:35:09 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id c8sm1989732ejp.124.2021.08.09.02.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:35:08 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        illusionist.neo@gmail.com, zlim.lnx@gmail.com,
        paulburton@kernel.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, luke.r.nels@gmail.com, bjorn@kernel.org,
        iii@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        davem@davemloft.net, udknight@gmail.com,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 1/7] arm: bpf: Fix off-by-one in tail call count limiting
Date:   Mon,  9 Aug 2021 11:34:31 +0200
Message-Id: <20210809093437.876558-2-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
References: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before, the eBPF JIT allowed up to MAX_TAIL_CALL_CNT + 1 tail calls.
Now, precisely MAX_TAIL_CALL_CNT is allowed, which is in line with the
behaviour of the interpreter. Verified with the test_bpf test suite
on qemu-system-arm.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 arch/arm/net/bpf_jit_32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index a951276f0547..200ae9d24205 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1180,12 +1180,12 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 
 	/* tmp2[0] = array, tmp2[1] = index */
 
-	/* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	/* if (tail_call_cnt >= MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 * tail_call_cnt++;
 	 */
-	lo = (u32)MAX_TAIL_CALL_CNT;
-	hi = (u32)((u64)MAX_TAIL_CALL_CNT >> 32);
+	lo = (u32)(MAX_TAIL_CALL_CNT - 1);
+	hi = (u32)((u64)(MAX_TAIL_CALL_CNT - 1) >> 32);
 	tc = arm_bpf_get_reg64(tcc, tmp, ctx);
 	emit(ARM_CMP_I(tc[0], hi), ctx);
 	_emit(ARM_COND_EQ, ARM_CMP_I(tc[1], lo), ctx);
-- 
2.25.1

