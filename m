Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518593E3A2E
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhHHMZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhHHMZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 08:25:09 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44641C061760;
        Sun,  8 Aug 2021 05:24:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso2199627pjb.2;
        Sun, 08 Aug 2021 05:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cfuHJ0F5XUnbjLf/uGbQtchTlybquzNv2LjZvYHovaU=;
        b=USsNlW4N/ExtU2nKQ4XI1T/tWdGVpfGd0v58FTAoW/DhWZTLmU1N9c+TiWuyGugLq0
         1vaqoVZ43ZGQGphih8FHD70uMGWesDs5su5/vBu6/H7neXnpw88ecy7G3aQ/sEBtOwGt
         IlTxmVK6bzxwD1ZPnYQGThFLZqnWrF/DOTgWA5Qk+5qVGY/g2ZM0xJPSlctHQu9Uov0o
         9eyxSGc+SKcErqwnorLd2M5NTRDWO3iOWoMPJa2jvtf53JCq0q04Cud3g/r4E/Hxo3Vq
         7pZqjIilhqDpHhUDrVQsrOg+LAKDRGNR4hXL1zkr6+6PPANaJoJrMU3pJZKHyTyP/RzS
         xobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cfuHJ0F5XUnbjLf/uGbQtchTlybquzNv2LjZvYHovaU=;
        b=S1rVKGr+3acdjmV5n9vWNAE/d0/sZsGln0Py/eUpXT9v8wNQLb0htfqyEaw8qIImpN
         MSg/+d14zpxXPJwPgxhB1VzoyHDY/h6Z0550weos9wmpkm/US47qdBBBtwbdxCxXjHrp
         h1ZZxnvyEacoQ7kMoZILAQLeMYx9kGroLBr1PLK4+3YEniU6Ox+VmdkY7Ov2Dj1Ub9By
         CuTmGCY74nAgIvFFjg0UKrEr5FeIgcnR343kU8g0cO5zOf6pFpvtdrdAldawucFgaBdd
         468bYcKcj3vkhjOipeE/b92l39kRJCJ+bPxAmf1fFCSAmN0EmaUeuTz7WKM0ek0ty/ZK
         A6Xw==
X-Gm-Message-State: AOAM531Z3V+a7K3+6DfUaSJ0ltvRk/oFTPVojxkpKwmV5uNbAlYp1/2h
        XGabAGP65Et2IfRFSphAOm8=
X-Google-Smtp-Source: ABdhPJw5LKdxwqi9Lfzyt8FsJnFMBTOUX7sv3rKsPTpja/4BnQnUTBy+yntloS7peZkV6sYGP/1Few==
X-Received: by 2002:a17:902:ced0:b029:12c:bebd:1efb with SMTP id d16-20020a170902ced0b029012cbebd1efbmr16803253plg.56.1628425489515;
        Sun, 08 Aug 2021 05:24:49 -0700 (PDT)
Received: from u18.mshome.net ([167.220.238.196])
        by smtp.gmail.com with ESMTPSA id y8sm17346925pfe.162.2021.08.08.05.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 05:24:49 -0700 (PDT)
From:   Muhammad Falak R Wani <falakreyaz@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] samples: bpf: xdp1: remove duplicate code to find protocol
Date:   Sun,  8 Aug 2021 17:54:11 +0530
Message-Id: <20210808122411.10980-1-falakreyaz@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code to find h_vlan_encapsulated_proto is duplicated.
Remove the extra block.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 samples/bpf/xdp1_kern.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
index 34b64394ed9c..a35e064d7726 100644
--- a/samples/bpf/xdp1_kern.c
+++ b/samples/bpf/xdp1_kern.c
@@ -57,15 +57,6 @@ int xdp_prog1(struct xdp_md *ctx)
 
 	h_proto = eth->h_proto;
 
-	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
-		struct vlan_hdr *vhdr;
-
-		vhdr = data + nh_off;
-		nh_off += sizeof(struct vlan_hdr);
-		if (data + nh_off > data_end)
-			return rc;
-		h_proto = vhdr->h_vlan_encapsulated_proto;
-	}
 	if (h_proto == htons(ETH_P_8021Q) || h_proto == htons(ETH_P_8021AD)) {
 		struct vlan_hdr *vhdr;
 
-- 
2.17.1

