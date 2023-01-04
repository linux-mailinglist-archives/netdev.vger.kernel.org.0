Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7265D249
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239208AbjADMS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239194AbjADMSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:18:45 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD81C18E25;
        Wed,  4 Jan 2023 04:18:44 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso19738750wms.5;
        Wed, 04 Jan 2023 04:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+t2bcEVl0DD/ffERxP1wbjyownau+yUhNiCVaeD73U=;
        b=UuCiwp3BmP0BDmMBpGx5jz9wZQOE66YwFREkjZfMPLpmERgUx+6r8dRLTVp9C4EPIK
         MtyZrPAZc6NNquUDHxkILn/XkQ+SjDBVfrEihEXjlvarGVuU8Wj3aEWDTg7sYS0PCP4a
         zGQ3NY3kO8ieRFXo++u0+mehB0YZMA/FVveoAxmAIrd9T4zL+WJmRrqlF5w5nzAHsfDF
         Buw0O0h/b4TTrobwr7WUTB5X0G9I1jX5fyUfd6b2t4Hof3+dPZmTpA8zIrZptmDaeger
         Yoj/mKfEnDKVDImPU8MJj1BJU66Nyiqf5sBI5/SgpVjVUV2NU0jQDsgNvucb5DY00a0v
         PTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k+t2bcEVl0DD/ffERxP1wbjyownau+yUhNiCVaeD73U=;
        b=0bjTV8qETuKWOqtpjpnWgdQ+yGiuT56LnnDjdeZWlbK5v0CWaU4D1YzWxml08FMWM+
         6LjoRb4nnavKE1O2HpdFljfem8vYYpi+ue+7oP1zNLJkRePs+KdVsxMtjNE0+LY0s074
         eSLlUkA50vlGrfpI7X+QT6v8J/Bg4kyyrX0jnkvRd852kwgQMFePcG6qShQ+K4Sx3qEh
         qRxEETcut3adFh33FmgbcVaI1He8vx6EQYdiCJXZQQNZGGnrvxUVs1A4GQVNBnLs7HWO
         +nmFrx6XdZcfylLEEfsmJe1k0UeZNZvRVxmlcq2329lhfHn30/+IXiDAcORvlYdGZYNf
         1G9w==
X-Gm-Message-State: AFqh2kpC9D5ZZlLpW2b1BZ92voPQE8RbHA202wXuyFkRwhoViYCkJJOi
        AN/4lFdsDMY4YRtni5ZOcnE=
X-Google-Smtp-Source: AMrXdXvKErxMXtDeXBuUxxDxNXEPuAoJJDjYGkzP4gbo9XKAxmulcuyxNdApLxb0esjFfgED/rA//A==
X-Received: by 2002:a7b:cb50:0:b0:3d1:f882:43eb with SMTP id v16-20020a7bcb50000000b003d1f88243ebmr33275285wmj.10.1672834723231;
        Wed, 04 Jan 2023 04:18:43 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.18.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:18:42 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 03/15] selftests/xsk: submit correct number of frames in populate_fill_ring
Date:   Wed,  4 Jan 2023 13:17:32 +0100
Message-Id: <20230104121744.2820-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
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

