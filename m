Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D174EDDD4
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238860AbiCaPtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239894AbiCaPsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:48:32 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C049355B1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:46:44 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id ke15so20003633qvb.11
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mdaverde-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ONl/rjPY44Su63M5PgvxVFFtmWipaKmt8kt7MQsENI=;
        b=mGrwJh3X216JDDAJexHUgbVihbd1M5jxhlvHDrMYkBCOtxLkgPJeLCO5zpWEz8aCPO
         XNmTn/D89/CuONk1ktJRG3sanpLHfp550pJGgbwx+TZIj1A2TsfPVT3FQtFKUsOzJnF2
         QVPHkQshtQdcss9A14aF7LNRAK88E+d1GnDhVAmLTsN4dQzL5y2WN92iKWPy141bwRCr
         K6+dC2e18C7JXVr6lcHLAmfevotBXZbzHTvJoeAFu0prlJ74+WaGdMgntZIIKb0GRBhb
         uaFJ1HTKlnkMLbg7tIODHKj8sUGo5USENlketHsqgOlLejvzbGUOYSLcu6DDQqpBgeW/
         +ikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ONl/rjPY44Su63M5PgvxVFFtmWipaKmt8kt7MQsENI=;
        b=qcYvH2OD/AwlGCzYq7ZObHlFWArRLOdxl11HIwvdwy66AlD/gAYATwZHzLSfqo7hd4
         cXF44t3yQ1RdGdqKyGNJ50QGsvP5PaaaMENb5z/UPAZx8ozw6XgFEc0n1+hMTgNUQ5Fu
         GtLgsU5gx7TiO1YbeXv4Y0/1ki84pCyHNFXOyEuTfEzXG9scv2rSx6JNzxmp3aeg7rYa
         fmGaa279mGCoM/k/oHl1LT33K6iL0Txc4LYDt4yaTICTdYUwoN4BdheAlwlYMDMrPf/F
         BJ8pROw8BS7uf6O8e6zWmo25T/0UWKKnBSWGjZxc0r4YYQYkpze/Nf+2pIt8mtiJHmqB
         Sqdg==
X-Gm-Message-State: AOAM532FDfLkd3koHLu9C5OPdsF6XvOlvoJt3rwe48asetSDvr2kknMg
        MUk+qGSqfDCjdbON5fqbqCvgm7JPqiZOqhFytvNWCw==
X-Google-Smtp-Source: ABdhPJxa13kl0P1optMF0WTHmFCEXJZd83UC4G9/VHnydUdYRdzj6BS2cS1m2i4Zen8bt/Yjr4R1Pg==
X-Received: by 2002:ad4:5caf:0:b0:441:5879:5e62 with SMTP id q15-20020ad45caf000000b0044158795e62mr4324894qvh.95.1648741603866;
        Thu, 31 Mar 2022 08:46:43 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:1d10:5830:565c:ffc5:fa04:b353])
        by smtp.gmail.com with ESMTPSA id j12-20020ae9c20c000000b0067ec380b320sm13126797qkg.64.2022.03.31.08.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 08:46:43 -0700 (PDT)
From:   Milan Landaverde <milan@mdaverde.com>
To:     bpf@vger.kernel.org
Cc:     milan@mdaverde.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, davemarchevsky@fb.com, sdf@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 3/3] bpf/bpftool: handle libbpf_probe_prog_type errors
Date:   Thu, 31 Mar 2022 11:45:55 -0400
Message-Id: <20220331154555.422506-4-milan@mdaverde.com>
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

Previously [1], we were using bpf_probe_prog_type which returned a
bool, but the new libbpf_probe_bpf_prog_type can return a negative
error code on failure. This change decides for bpftool to declare
a program type is not available on probe failure.

[1] https://lore.kernel.org/bpf/20220202225916.3313522-3-andrii@kernel.org/

Signed-off-by: Milan Landaverde <milan@mdaverde.com>
---
 tools/bpf/bpftool/feature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index c2f43a5d38e0..b2fbaa7a6b15 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -564,7 +564,7 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
 
 		res = probe_prog_type_ifindex(prog_type, ifindex);
 	} else {
-		res = libbpf_probe_bpf_prog_type(prog_type, NULL);
+		res = libbpf_probe_bpf_prog_type(prog_type, NULL) > 0;
 	}
 
 #ifdef USE_LIBCAP
-- 
2.32.0

