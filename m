Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B733F5876
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 08:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhHXGtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 02:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhHXGtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 02:49:00 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41D6C061575;
        Mon, 23 Aug 2021 23:48:16 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id z2so6556452qvl.10;
        Mon, 23 Aug 2021 23:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M0jDWBfS/ZRei+Gi6YISgWR5GylXfatFNrph9XGijVs=;
        b=BT9QwCHL9NY8rAsbWsoV614pVTMYkQm6UCvZEWe60dL42/qhXC21oUGxnNuusqK8dj
         iEwUy2g19eC6Sb/GVGCLdUkjIVUuC6sK7KR+91OVkLDf7sSsE+nhN9Fc7LOm7HMGyr0D
         24XPpgTLLMY8ld2yqdB2AoRZZxMjAc0kIWw5i+1rUiCZGuZCbmj+02LcJ2w573EkZxdb
         Q0OXfekNHqvtJWjJCvzTqkppLgTfms45ahsn7pvEvMwEjGgNt5Ocl4IKL8PKxujHUZWH
         BSlIm5GuFmUk5cvkvC3gN5dUHLAsOihq0eJGToQxJ+tnck1tzDzfbAGFWhr4s5bQPJ64
         d19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M0jDWBfS/ZRei+Gi6YISgWR5GylXfatFNrph9XGijVs=;
        b=E+FL1BLdKRbIEODxqmfO0NVvUH5Nxk2ns/tgpA+sdEZtwhaT87QtfDLHIzs4J+KZl3
         jmzD24Ef3YcTDVwybGCi2LlrUyJC4xMiEtXZmNiuTNUhxmKY5Tt2Ymcics4rGFTAMYKh
         FWWgizJXROElgdnNPWNYtIuYiPd04ibCeyOBPd462LUBVuEq1Z+/PI4PrF+rFOs4Ks6W
         JbRcUQuePejKVQjnl4rt4SHJ+pTOTDzUAu+/B+x0AA+RXlrqCPy6Gb0CBd2HCOilgtjF
         Wn1VFl1CegGaE8xo6CfKN+FHpVwdqv1TkpfO9t1rdykEU2BhgFrHKRm50QvfF/z3Ux8I
         duRg==
X-Gm-Message-State: AOAM533q+vTsptoOnyh1nvnV5fJb0kRK+tcVuH9zPSfx06QZI92XdtCQ
        Vbw8IQl5+32Y8VY56JmJd+Y=
X-Google-Smtp-Source: ABdhPJzfihc53h8CR6AyfdYSk8Kz3K/Q09eIOuwyEU5Uq4yAGzdchJ8Y4vpKu7mEuso8hF4NE7zYeg==
X-Received: by 2002:a0c:b356:: with SMTP id a22mr37202410qvf.7.1629787696079;
        Mon, 23 Aug 2021 23:48:16 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 71sm7946582qta.25.2021.08.23.23.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 23:48:15 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <deng.changcheng@zte.com.cn>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jing Yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] tools:libbpf: remove unneeded conversions to bool
Date:   Mon, 23 Aug 2021 23:48:04 -0700
Message-Id: <20210824064804.60279-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jing Yangyang <jing.yangyang@zte.com.cn>

./tools/lib/bpf/libbpf.c:1534:43-48:WARNING:
conversion to bool not needed here

Found with scripts/coccinelle/misc/boolconv.cocci.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yangyang <jing.yangyang@zte.com.cn>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 88d8825..e7efead 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1531,7 +1531,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
 				ext->name, value);
 			return -EINVAL;
 		}
-		*(bool *)ext_val = value == 'y' ? true : false;
+		*(bool *)ext_val = (value == 'y');
 		break;
 	case KCFG_TRISTATE:
 		if (value == 'y')
-- 
1.8.3.1


