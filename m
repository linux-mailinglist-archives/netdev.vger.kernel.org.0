Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887EC643F61
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiLFJJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiLFJJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:14 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C421DF0D;
        Tue,  6 Dec 2022 01:09:03 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h7so16503653wrs.6;
        Tue, 06 Dec 2022 01:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+t2bcEVl0DD/ffERxP1wbjyownau+yUhNiCVaeD73U=;
        b=qAMYTrjnzZB55dtgbpCJ2J2F0D6mINc0cK3lijI+7xpuJomPiBpzfvoXOBgxOFSt8D
         luC9vfyTJ5RGx0hTF3KuVmrG+vS2LfjXcVozs0GmXcepvIPuqxzPikV3k4DAGIIrK9Ct
         Ls0Aq+uDOMAxgUVb/5pQPFiwViezCLiMMjVD3cUxdo/JGTX/pWnRdoDxEiS4Riupgq/z
         au2ZnntiPB7DqXC7cfqdSqwZvUvUIRWq8GVLgGBayan8eZbNSXlVokxFgFnOrwF/TDa7
         6KkreeMF1D2gu9qyZqVKrGwuMwCI3UF5MAn7OoahLRs31DNO78OVbFYbj8EQQe7irI27
         0deQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k+t2bcEVl0DD/ffERxP1wbjyownau+yUhNiCVaeD73U=;
        b=TlQYDjvz7eGWLDZz175r+3AVhEaUIMS+I6yfcNMKooHoiu+t4BTMIITTjijnLxDB1C
         TVLYIZU2EfJPbzzWPepFerKXaJRG/+TUobECQakYP99pywm2b0lSBT9ZS5hgxqXzo9uz
         tS/lYqlIamQlFMrueSNLcM3G1zHtMKSPiTkejhuvAu8YHzDkSjG7LNARDelm2uUsZ0Uo
         xCrhv8UHWbsymoVF0nDdnt7pPP+gR8xaGAdF6R8pjm51XuoT5kyQPJHvMBMgmip1PGge
         gii4qfedXNj3tsx7Y8mqZRNnI6tOqqyM/ckG5EIWmKmQwtFHzjJjzMg0ufua88Qq1TBc
         C8Yw==
X-Gm-Message-State: ANoB5pmFkFdU6qTgOeiGM/H7CQpCqbdv3qoGDGNCMa6wn7F5xlTLXtLf
        RihYPE4C1QEh6Ci2qp8jlJk=
X-Google-Smtp-Source: AA0mqf6qB0r5+fTMr+w/NpUZ04yD69rV3THnOvI3ZWK6a7QDAmaoB4Wm9yZTn2MgNRvWh4B7Ou04bg==
X-Received: by 2002:adf:aad9:0:b0:242:6564:9b27 with SMTP id i25-20020adfaad9000000b0024265649b27mr4433711wrc.643.1670317741902;
        Tue, 06 Dec 2022 01:09:01 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.08.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:01 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 03/15] selftests/xsk: submit correct number of frames in populate_fill_ring
Date:   Tue,  6 Dec 2022 10:08:14 +0100
Message-Id: <20221206090826.2957-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206090826.2957-1-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Submit the correct number of frames in the function
xsk_populate_fill_ring(). For the tests that set the flag
use_addr_for_fill, uninitialized buffers were sent to the fill ring
following the correct ones. This has no impact on the tests, since
they only use the ones that were initialized. But for correctnes, this
should be fixed.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 2ff43b22180f..a239e975ab66 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1272,7 +1272,7 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
 
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
 	}
-	xsk_ring_prod__submit(&umem->fq, buffers_to_fill);
+	xsk_ring_prod__submit(&umem->fq, i);
 }
 
 static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
-- 
2.34.1

