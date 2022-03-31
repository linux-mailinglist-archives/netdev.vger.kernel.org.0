Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821C94EDDCB
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiCaPsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239886AbiCaPsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:48:31 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101C23CA67
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:46:43 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id gh15so20022221qvb.8
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mdaverde-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DPr3sahcikMBYCgbodWmTPoTIB3Qvaf2KIRlwCildB0=;
        b=H+/zy8k0pWiPzlGfpwInObaRAb4BkZ2FQfVGxnE9hLNRytx+WTOGb9SLXZX+8vOrxw
         0PPIGvf9/q/LGySex3jjWnmJRELPdmigntMFJCz8IZCYIAgV51o+20uGHkWTsvGZV5gG
         tnLfwcfiXsJaR7axze+hwi49PkIm9HO+gV1WGeRMKo9E6vg3o6CkUxaTaS6tn1mM74F0
         Q2DtZD7+qN3ilHWlr8iL+/HRtUIPEpw6RZU+v2rA0GbqZYPKgJ5rlTdevaojx2lsq6GC
         7lzsFzx74GPvBEhwQf+ztzA7S+woGz1yYYfKFvJOYdnqvlxNECNjz+KpNMe6HNmPKqdX
         7yQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DPr3sahcikMBYCgbodWmTPoTIB3Qvaf2KIRlwCildB0=;
        b=vWKZE5SHOhVvHexcxCQyh0I8jjRJC/offsmqtQLLAR4QzrC5vKoZv/Yv3y9wRuZpib
         rscFNrqAyChM3RL0mP0Sw6F1eCmET93crDYmXpWQTE8SwMfbz9gMReVh/TtBBmTldNPq
         ZWCdvmaYt0Cwojbt+3rKSEzOeD1uNgTdLahLFYPZeMZapQdZC/blxNHQQ8Lhu8OZz5yH
         RBtLQQjRo5xnze2SnaRXk/MCEspq5QPzLf6uMxOJRduOESDlCD/dvQVH63QKvLwnkyTY
         5DBUuTn53HoaUEMum1nepKmSQU4Z8YPkCjrz2PMFZ1dgjU9K1JIw6ZsODMwuTd2vAxPr
         GSdw==
X-Gm-Message-State: AOAM533dxmkRGN/UOs/Gr5M+oignzVLkvJStzhyLWJ7bIvK061ScYzjs
        bgAXgdVsqt4qYxywh3uQCWcDUw==
X-Google-Smtp-Source: ABdhPJxb6tDpxzZn+h6SsO2e3oPlENq+kosLbrIIN4a2Ey4qpwD4/tlnnFyAQx3Tf4kE9Ql2huYMag==
X-Received: by 2002:a05:6214:2aa4:b0:440:f5fc:f1c4 with SMTP id js4-20020a0562142aa400b00440f5fcf1c4mr36552071qvb.104.1648741602131;
        Thu, 31 Mar 2022 08:46:42 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:1d10:5830:565c:ffc5:fa04:b353])
        by smtp.gmail.com with ESMTPSA id j12-20020ae9c20c000000b0067ec380b320sm13126797qkg.64.2022.03.31.08.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 08:46:41 -0700 (PDT)
From:   Milan Landaverde <milan@mdaverde.com>
To:     bpf@vger.kernel.org
Cc:     milan@mdaverde.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, davemarchevsky@fb.com, sdf@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 2/3] bpf/bpftool: add missing link types
Date:   Thu, 31 Mar 2022 11:45:54 -0400
Message-Id: <20220331154555.422506-3-milan@mdaverde.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220331154555.422506-1-milan@mdaverde.com>
References: <20220331154555.422506-1-milan@mdaverde.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will display the link type names in bpftool link show output

Signed-off-by: Milan Landaverde <milan@mdaverde.com>
---
 tools/bpf/bpftool/link.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 97dec81950e5..9392ef390828 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -20,6 +20,8 @@ static const char * const link_type_name[] = {
 	[BPF_LINK_TYPE_CGROUP]			= "cgroup",
 	[BPF_LINK_TYPE_ITER]			= "iter",
 	[BPF_LINK_TYPE_NETNS]			= "netns",
+	[BPF_LINK_TYPE_XDP]				= "xdp",
+	[BPF_LINK_TYPE_PERF_EVENT]		= "perf_event",
 };
 
 static struct hashmap *link_table;
-- 
2.32.0

