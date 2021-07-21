Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC0F3D0D9F
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbhGUKrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbhGUKAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 06:00:33 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFD1C061574
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:41:09 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id qa36so2500094ejc.10
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=of1aHiumD0d746c1BNBCXDD6a5ghwP+21JON2EtY/nc=;
        b=O+AIL5WfDv+LnDd77LpVwq/3jOaXiZ4fnmed7KimdnkYKH5ZxjEY147HnmxRk/6ftk
         E3ax0dLhv6/V2+2d51q7QQKDAckTi3LTo1UfnVmjov3rqVaH6+VL9yKLt9PJaMhnq0Kx
         wDerR0hZps1mIqoHjDAwimB2WkowcDl8A0qMJSjCXAoIYOhStZd9jaeSH3gIUwpTD85n
         4gRHwZj2IOxA2hLqo9lWVeC2L0r5WGR/5ORO11JsbbEI6/YojiaS5fT+eNDl8ZyaSCvw
         4ENfhWBxadeITB/TuDlh7IBVmcvqHpdQGvq8gbWzJwECZe2KkWjDzieHecWR/bHoxSFc
         FL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=of1aHiumD0d746c1BNBCXDD6a5ghwP+21JON2EtY/nc=;
        b=omCGS174YDl5MUTVKluLi5zaJ2T2MJQX0pu07BnylMbIBVAg77/MjfLBjo3kGwPHfS
         Oy8Nrsc6uD6fIVSMvkPKQo2U0FkqG25zrwR/MBkNuMXwyX/xPKvzfG/pfDaTdrxKpbV1
         Rp4oJPqwUd6hDzmRvZNI9Xm0JJUhnhewB58m0Ui6i6ebx6guTVyeojSaBtyULNT/DuPJ
         7mp/f9/PP4dC2B3F/xQdvlhrZ6PMP1/gDpfNpb/cqKul+20gsxg4WPGS7g6PtF+herfL
         F4N9qEy4yry27ZSDxuqfNLq+P/n0h8egIjjSpR84z59NXsIkW+K/2M0OanN1Ujq/QP2p
         JPkQ==
X-Gm-Message-State: AOAM530rVKOMZ2tEgNWC2lnIWDeHHFIXW5jsTRJjJB2jqOXjhqJDfDq8
        XnjRfScY5NceT2COo1G2s+O1iw==
X-Google-Smtp-Source: ABdhPJxYeCaVjdROd2OYfevnzDCpbLcnbMjaYnylZ4Sf0IQ8//ncTW8EcevuSwO2MTUcFAXZdHfJ2Q==
X-Received: by 2002:a17:906:4b46:: with SMTP id j6mr38006668ejv.247.1626864068041;
        Wed, 21 Jul 2021 03:41:08 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id hb7sm8174054ejb.18.2021.07.21.03.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 03:41:07 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH] bpf/tests: fix copy-and-paste error in double word test
Date:   Wed, 21 Jul 2021 12:40:58 +0200
Message-Id: <20210721104058.3755254-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test now operates on DW as stated instead of W, which was
already covered by another test.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index baff847a02da..f6d5d30d01bf 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4286,8 +4286,8 @@ static struct bpf_test tests[] = {
 		.u.insns_int = {
 			BPF_LD_IMM64(R0, 0),
 			BPF_LD_IMM64(R1, 0xffffffffffffffffLL),
-			BPF_STX_MEM(BPF_W, R10, R1, -40),
-			BPF_LDX_MEM(BPF_W, R0, R10, -40),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_LDX_MEM(BPF_DW, R0, R10, -40),
 			BPF_EXIT_INSN(),
 		},
 		INTERNAL,
-- 
2.25.1

