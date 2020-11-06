Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494082A9012
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgKFHMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgKFHMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 02:12:46 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199BFC0613CF;
        Thu,  5 Nov 2020 23:12:46 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id x13so241365pgp.7;
        Thu, 05 Nov 2020 23:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bF7lB3r/NRXSgPkzBd48IhmbCB8//G6fnlydYhLSsVo=;
        b=eKNlgEOijibnTTUH/nV+RFOE8NNpwdyEGIw4L/CPWt0mkt6is4glTtHwKnxPMorKs0
         4Sz9orP2aqHt4FGv7iYZSTcRZ97O/TMo1gaAB9FYGf05/FCsHatPWC3SeBd0r1Ap2F2y
         5XyY7QL4jhVrIl3IHATVl+DzK2sffLWRh3ClXQrgeSwqevgnsmcXQw4zHzSC6qIaWwkZ
         DhmncFoeXG8DI1BP/tgNF6y22I3E7JX+CeN6pxjpPtFBq87UBQuxanA6fxrPIlnzNt2N
         FpmQS9nInKf2KdHO/8Bon93++VzXi+H+WHNZET7qCTbyM306l030HkE1uCtH2ndGKt3w
         Qp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bF7lB3r/NRXSgPkzBd48IhmbCB8//G6fnlydYhLSsVo=;
        b=D/w+GMODVS8O8Q7VZfCSVMWAcVPAOd+ftafJPz920h/VoNmV1tdfSPy/9LDsIlkPgd
         9y1SVPNNIzZ5fzOaQmMuTav8obPdeLkl6BEhbFIz7iYNQ6hDNe3aYOOCZFnS5ICcoLs8
         0qRC8dIJjErJgdzH1hmFmZH9D896/yfunKjmitgRjBkgzquF6UFX8wgW4kQybbBsAx48
         ZrY1vmJXBt3eCbYkw9VtwdmUkC5XSFG3sPLRx9E6zB0Oypr4AU5osue7iOKJe8TYMycT
         NTffGGG5bEHzLch2ByMmcv8lEVh0fJLYERYmrp5bOs3FO4LPMlmOktFBte7zBb4lL0Kh
         mjmw==
X-Gm-Message-State: AOAM530NnkRs2iMvcWh4msL26VoriNXtpHYLT8vBLYaECyC1zxpRCauE
        718+9qeTXMjuvs1gOjNGPo2rp73w/Grn
X-Google-Smtp-Source: ABdhPJzD1v1HrBF099XBnksUJp+a1q97CIL33LzIwvOib0RahJEBbq2A9WeTLPAvDu7EWylxs1GjOA==
X-Received: by 2002:a63:a5e:: with SMTP id z30mr632484pgk.233.1604646765627;
        Thu, 05 Nov 2020 23:12:45 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v125sm756935pfv.75.2020.11.05.23.12.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 23:12:44 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] libbpf: Remove unnecessary conversion to bool
Date:   Fri,  6 Nov 2020 15:12:39 +0800
Message-Id: <1604646759-785-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix following warning from coccinelle:

./tools/lib/bpf/libbpf.c:1478:43-48: WARNING: conversion to bool not needed here

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 313034117070..fb9625077983 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1475,7 +1475,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
 				ext->name, value);
 			return -EINVAL;
 		}
-		*(bool *)ext_val = value == 'y' ? true : false;
+		*(bool *)ext_val = value == 'y';
 		break;
 	case KCFG_TRISTATE:
 		if (value == 'y')
-- 
2.20.0

