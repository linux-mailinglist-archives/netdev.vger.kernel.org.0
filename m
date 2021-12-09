Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C7A46E3A6
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhLIIEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhLIIEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:04:50 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02894C061746;
        Thu,  9 Dec 2021 00:01:18 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k4so3286101plx.8;
        Thu, 09 Dec 2021 00:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QfRJ3meNcEMg/hBc840EZK1vTCSuG9vpEpM34yNkkrE=;
        b=QDOyQpnmpjp7JAZNDedIohyKhEj3k0F5OQ5OgJ7PWN9GMeFJZ9zLwNsh3uYEA49Pq/
         70Arnmp+Q5mRhRkPH/lgsZPWHxqtQC5NxWoWbeG6mkUPHYzUAM07rSQv0Nnq6etmng6x
         Xc3Mpbaywhms4wlqExRJnQQBTsamipCYGPDj5/tKoBskHc1SMg+FpcOJafvWm6mJ2M8F
         f34CUfSNNGDyBtvHwd2hTOilx5JHK3nUiEKgDQqeraQvybVSadTiVyZe9Uz5yHtR7g1q
         cyVZDwy46nZbajMBab5Ext1JJm5lPEZBV2nR46DRWezx/Vc/wWKIa4pRPo8Xw7/aLku5
         7YIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QfRJ3meNcEMg/hBc840EZK1vTCSuG9vpEpM34yNkkrE=;
        b=3CF+hh+8vdWpfl+r7wMLSsbjgFP4oRtZUGgFBIEKP6JXkhGzBWxJnJWaNFz5nBLodV
         4J1M61enR9/AZThvQ3SqnWPu3oNBuzSbzjIRUJbaFrNp82YX1tamUJd4saurtXtfquWW
         wEup+wljmn3aPvx0dXtrk9sph1o71gBP4eOHkcF7CHryGa5fwvioCJPss816y/zIAXON
         5R19MJjSmnT0zXC6/f+10I1052TKlGoEP06FPaYFah5oVu5d8Pn24E/hRB8EZ3W5x7VO
         Z+L23+b2Rwz1X++eQTIsJfKgNX27ow62DxJQTlqwwC7fOjMBjmpg28zX6L+LFM7FlnHT
         l1tA==
X-Gm-Message-State: AOAM533okux/BSYHkzN1+s0aCkP+CP17eVyoDZmB7P6d5cMqtOKzgEpO
        hnClXReujDNgdEnKHw+tg/OKpvcmSCg=
X-Google-Smtp-Source: ABdhPJyyQe7HdQxrvV1i6b8tnzpLKmPUt7sloM1aRGCMI4uQiuYu7l8f9I3yg1o4VPv0cEAQBxTqQw==
X-Received: by 2002:a17:90a:1283:: with SMTP id g3mr13615242pja.174.1639036877529;
        Thu, 09 Dec 2021 00:01:17 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h6sm5835126pfh.82.2021.12.09.00.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 00:01:17 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        cgel.zte@gmail.com, chi.minghao@zte.com.cn, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, zealci@zte.com.cm
Subject: [PATCHv2 bpf-next] samples/bpf:remove unneeded variable
Date:   Thu,  9 Dec 2021 08:00:51 +0000
Message-Id: <20211209080051.421844-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAEf4BzacuM8cR8Xuv5tdg7=KScVi26pZ3CjewAy=UuHouiRZdg@mail.gmail.com>
References: <CAEf4BzacuM8cR8Xuv5tdg7=KScVi26pZ3CjewAy=UuHouiRZdg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

return value form directly instead of
taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cm>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 samples/bpf/xdp_redirect_cpu.bpf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu.bpf.c b/samples/bpf/xdp_redirect_cpu.bpf.c
index f10fe3cf25f6..25e3a405375f 100644
--- a/samples/bpf/xdp_redirect_cpu.bpf.c
+++ b/samples/bpf/xdp_redirect_cpu.bpf.c
@@ -100,7 +100,6 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
 	void *data     = (void *)(long)ctx->data;
 	struct iphdr *iph = data + nh_off;
 	struct udphdr *udph;
-	u16 dport;
 
 	if (iph + 1 > data_end)
 		return 0;
@@ -111,8 +110,7 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
 	if (udph + 1 > data_end)
 		return 0;
 
-	dport = bpf_ntohs(udph->dest);
-	return dport;
+	return bpf_ntohs(udph->dest);
 }
 
 static __always_inline
-- 
2.25.1

