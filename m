Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472DC5604EC
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiF2PtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiF2PtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:49:05 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3531EEFF;
        Wed, 29 Jun 2022 08:49:04 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m2so14516234plx.3;
        Wed, 29 Jun 2022 08:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rfwZRXZMUJDGu/8doZStZd5M09ONYzjmjpqvrokj+CQ=;
        b=fZZ12bs6yX72c8VVlT+GCLcsLST+dJ56WPBDci2zMVkGajFVJDGhRpwVxHmi8XO0q7
         ywCTkKt1BsF5mzUpfTz3ZLL0IeKZVywyJn1EFwSYApFZuZhlHmDjvKTQe5pUpoHXlCKS
         RtSoKLiQJKeRpPhXBc21rueT0KoWN9/Oc5ediDq6og7HhJH5db7Z3nt+7aJ6IpQCOX5q
         Ds5wuf2v93po9FLs0T9QHiUgfrqeuzblrm7Wge8dcl+kfHiaeu9Fu8w5qSdXBQhdlCVs
         5BLEXU+OPmtn1WsaqQy0oRv4MKcrXLUVpuo78RrPdZm94Ec3fRo/8tiGMjuzWMwU9La1
         0Exg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rfwZRXZMUJDGu/8doZStZd5M09ONYzjmjpqvrokj+CQ=;
        b=HLpiX/CEQCv42EI0nF7x+li24IyBH5A7TZMW2q0laMsAplrO7nuoFYuQFBx0Xl0Xsf
         oMRxj3Yk7RlN+xHbLFFXcubboi3FsS06gR/l+Gj2PmkOzGkuR8Bs+EmLxVLk9rkewoKr
         0cpH4xMoSDlPvK9nfLrVUBo6oD9KNlKVZU2ZX37He/BlA6dLwg6G1StamNm1BPYGRE3j
         20kM+hskyvBTDYvqvBN3yO2P3tov4oDfFoVRXWF3ClPl1BXTKgjtOp44b0O+Us24EybK
         OUIcti82ryXbVYnFds2F7HwBMs6z0H1mZeM3jabiutNJzZ/sKCyU7tmYB7MXQ5sCOn9h
         sh9w==
X-Gm-Message-State: AJIora+o2xRmaxSYJad2Vlla5VdKeAqmcGpp2RoceRP5exEPiZv489wk
        UObCk27k/s/fXz+ydenAsMs=
X-Google-Smtp-Source: AGRyM1tt9bD/jduGyp2X0xaN0NPYO+Z1Yacmnb6B5JA/JcZW4AMhcnmL/yAJJWe0rglLCwJVDt1h9A==
X-Received: by 2002:a17:90b:1a8c:b0:1ed:1afb:7a73 with SMTP id ng12-20020a17090b1a8c00b001ed1afb7a73mr4632401pjb.144.1656517744036;
        Wed, 29 Jun 2022 08:49:04 -0700 (PDT)
Received: from vultr.guest ([45.32.72.20])
        by smtp.gmail.com with ESMTPSA id 1-20020a620501000000b00527d84dfa42sm2661329pff.167.2022.06.29.08.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:49:02 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, quentin@isovalent.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 4/4] bpftool: Show also the name of type BPF_OBJ_LINK
Date:   Wed, 29 Jun 2022 15:48:32 +0000
Message-Id: <20220629154832.56986-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220629154832.56986-1-laoar.shao@gmail.com>
References: <20220629154832.56986-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For example,
/sys/fs/bpf/maps.debug is a bpf link, when you run `bpftool map show` to
show it,
- before
  $ bpftool map show pinned /sys/fs/bpf/maps.debug
  Error: incorrect object type: unknown
- after
  $ bpftool map show pinned /sys/fs/bpf/maps.debug
  Error: incorrect object type: link

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/bpftool/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index a0d4acd7c54a..5e979269c89a 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -251,6 +251,7 @@ const char *get_fd_type_name(enum bpf_obj_type type)
 		[BPF_OBJ_UNKNOWN]	= "unknown",
 		[BPF_OBJ_PROG]		= "prog",
 		[BPF_OBJ_MAP]		= "map",
+		[BPF_OBJ_LINK]		= "link",
 	};
 
 	if (type < 0 || type >= ARRAY_SIZE(names) || !names[type])
-- 
2.17.1

