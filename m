Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5075800C5
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiGYOcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235587AbiGYOcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:32:20 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CD6CE32
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:32:19 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d8so16174722wrp.6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=47FS747aKSVHMGN4K0Lm+GZNrHYtD3EonHeKad+pVjE=;
        b=fSgPqjRtxxHT6FXrRf8MlvY8Qi4eaGJ63JQtrk+oFtu1zhCDwsItbCbkK5r/2YRYiy
         6kchFdsQPAtVn4y/PFl3RebWETR4TFFY/QGWG3Tx7ttep+zZG+6ldEnT5Jx6EDmpyxgK
         S2oPm0nj9d58EPmAhifsJVd5FD6GbOJBBeq81SNTVs3Xs/uVkPR3oTX9SLbegmxnLL9W
         ehEJGM8v+ONkkIpHspXH71Z8oy7Y5nE52Z094GT0RIiRRbwMRKEnQ9csfNW+cSEVzDv7
         j4JPUQCVfzC1OYsuam3O1LNFopF+iXCvrrXVtVWW98S80Y/z1MsOcelimPo93rtAKWlC
         Pvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=47FS747aKSVHMGN4K0Lm+GZNrHYtD3EonHeKad+pVjE=;
        b=h10s2KwQeN0+KIwu8XWoGgObpqyCKRmfuPgSr+d4vHlwEhK07ZM1z1mdtMlAPZTjg7
         SXBwqBZSWkAW1fJJKLMZr7NMLSmD8qqdvUBHP3vXwnhgl0HGk69VYK46RTjk98PjutBC
         VIdZ7E6gez6laTqslEaV5PdGjAFtSKnQKLcvhwKgDtUrtvmOzDEc0PZVGScQMH0wkbn0
         cwe6PR13vQEDu8QjZcKIv0Qntcoo5lB6Y+jlYmNJZ4MsTkXSYa/9eXwGScCgrG8HzfxR
         5j516d+Qsq8Uv9PMZNjgNje6qWVZ579KUQZEO+keoAt+oOm4dzphikltZdBeiSD7rTy/
         CHfw==
X-Gm-Message-State: AJIora9AfVPLGKk3c12e05JQrRcl+1XI690BIV5u6aUpsQHqqPbm+a0O
        p7tsT8iFi0neHraZHBz4WnvD
X-Google-Smtp-Source: AGRyM1t2/6Dsd3sC15jbmdPl45Mnr+p2VKHZz82Ki7Zb9V/jleCF7UjhBMeKZnNyh6zFGyGYjHJL2g==
X-Received: by 2002:adf:f94b:0:b0:21e:46fe:bcdb with SMTP id q11-20020adff94b000000b0021e46febcdbmr7468891wrr.143.1658759538131;
        Mon, 25 Jul 2022 07:32:18 -0700 (PDT)
Received: from Mem (pop.92-184-116-22.mobile.abo.orange.fr. [92.184.116.22])
        by smtp.gmail.com with ESMTPSA id o15-20020a05600c510f00b003a30fbde91dsm20469620wms.20.2022.07.25.07.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:32:17 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:32:15 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v3 3/5] geneve: Use ip_tunnel_key flow flags in
 route lookups
Message-ID: <fcc2e0eea01e8ea465a180126366ec20596ba530.1658759380.git.paul@isovalent.com>
References: <cover.1658759380.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1658759380.git.paul@isovalent.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ip_tunnel_key field with the flow flags in the IPv4 route
lookups for the encapsulated packet. This will be used by the
bpf_skb_set_tunnel_key helper in the subsequent commit.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 drivers/net/geneve.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 2495a5719e1c..018d365f9deb 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -815,6 +815,7 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 	fl4->saddr = info->key.u.ipv4.src;
 	fl4->fl4_dport = dport;
 	fl4->fl4_sport = sport;
+	fl4->flowi4_flags = info->key.flow_flags;
 
 	tos = info->key.tos;
 	if ((tos == 1) && !geneve->cfg.collect_md) {
-- 
2.25.1

