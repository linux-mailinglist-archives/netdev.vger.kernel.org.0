Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F82648E15E
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 01:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbiANAIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 19:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiANAIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 19:08:00 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCAEC061574;
        Thu, 13 Jan 2022 16:07:59 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id h1so11784631pls.11;
        Thu, 13 Jan 2022 16:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LWC3AwLn+pi/1icA54lHg1UENoGSgLmYWqjtgA88t8k=;
        b=S0sMwr/B4nl0wfRfAE/WSoA3SJWEdpoPfToaEkFzEZ/FjSybeE+uWfcgcWjOFGLOrq
         6ZeJz1GgsayQLVKx00nOESKlr96hjOO9ruyD+jPE1Itq1X0I1C4MTWp3az3mgoxuouW2
         wH9BDBW/vYceSW8TnX3CYN6cNRyA+R0IBDR/qh1ECf3q9dQYebKe80wbxTxaI/w0wHOy
         hA1Z1UHG4jQeTSDRwiHrttlM1qa/TylAOxcD/IClmpVof805kfmKpSxe+0sr2vRqPc2Z
         wd/tTIt3c3PWKbUxX1pI1HXceFilu7JMTQq2zFJWUyOiQjAHx4dlT4v8bzk1MjE/nOek
         MCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LWC3AwLn+pi/1icA54lHg1UENoGSgLmYWqjtgA88t8k=;
        b=DHt+BNdsu2rL1IcwB3ahzxz1hxSjzV28SRLZV+bmdw/E5H1YRn3nGd5+MNimCvzodY
         7Y7s5QFjhf92XaF1kNLYZ9vgXVzQuypqcc+GIUVQymyeyp2EK+434FCE4xWSqCcVceO/
         0HIa+pIhZpd6bdR9v89rLJ6dPhi6sgmSltTOf69gy8G5/0nES1iav6my17snl9uRUYo7
         sh91lmjkPiK5oNdmrrJicpsc2yfXf+U9G6XXC/RMImoQRO7cZ0VgARF8gY68ykgnq//v
         SpwuN9NbX6h4fxvrvh5HgpU6KTSyGkvhtP5aW97aA95mNnaww8ZZZxDvjA4bFsK1fp3D
         rzAQ==
X-Gm-Message-State: AOAM531iWfEU4am4ERDNijoCa1pGebpvXFfJlkIM/GRlUG75fBTyuM4t
        Hvha5XR2Y+w6aAD3fpuQ+P8=
X-Google-Smtp-Source: ABdhPJz554A99ugCuGCBTrviDhTKZwZ13ueRRgw7mMcw8c60IqtRoCYg93T5ccuobUv3VeIzqhDq3g==
X-Received: by 2002:a17:90b:3b4d:: with SMTP id ot13mr7717150pjb.167.1642118879473;
        Thu, 13 Jan 2022 16:07:59 -0800 (PST)
Received: from localhost.localdomain (192.243.120.57.16clouds.com. [192.243.120.57])
        by smtp.gmail.com with ESMTPSA id b14sm3746026pfm.122.2022.01.13.16.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 16:07:59 -0800 (PST)
From:   davidcomponentone@gmail.com
To:     ast@kernel.org
Cc:     davidcomponentone@gmail.com, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] libbpf: remove unneeded conversion to bool
Date:   Fri, 14 Jan 2022 08:07:45 +0800
Message-Id: <2010e0898586ad83321e8d84181789123e2fe4e4.1642062557.git.davidcomponentone@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

The coccinelle report
./tools/lib/bpf/libbpf.c:1653:43-48:
WARNING: conversion to bool not needed here

Relational and logical operators evaluate to bool,
explicit conversion is overly verbose and unneeded.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7f10dd501a52..f87787608795 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1650,7 +1650,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
 				ext->name, value);
 			return -EINVAL;
 		}
-		*(bool *)ext_val = value == 'y' ? true : false;
+		*(bool *)ext_val = value == 'y';
 		break;
 	case KCFG_TRISTATE:
 		if (value == 'y')
-- 
2.30.2

