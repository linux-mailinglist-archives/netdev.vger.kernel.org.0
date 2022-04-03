Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C557C4F0A4E
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359077AbiDCOpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359048AbiDCOpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:11 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB47739832;
        Sun,  3 Apr 2022 07:43:17 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso781197pjb.2;
        Sun, 03 Apr 2022 07:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=29tSKU5CIi5toN+mzQg/xoJLGhPPII1qeJKEVizdgAc=;
        b=d/Ou5tvfP6DRmk0vvgWKuKibg8pLMW3OVJ81L/nWqVAsTitwIxHXBQI+F3YSkwCy1k
         g4Tm40B2xZk0HE30DcrRZQTikZi/hZCofvIe4RD5t3du4zUzcn3YTWi6ZJQR7FUaEPJ3
         MWOvv9nIc+a1WDM+3VAmyckbcEL1gtaDYeX95l3uitrsfDFHagTBRKZ/SjqvGXyrhqug
         VQeJ4iEJiuDa/2LUSTgC5FfKQoVctK7hiwTvRgLUsyN6VOleHul0fjmEm5toXpnujwhp
         F6+AYO6mCmT3wmdc12Viok/60dn5D3lRyHflceRmfb7/J7ojdxz8cBN7Qh7F2Z5am7Yj
         mf0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=29tSKU5CIi5toN+mzQg/xoJLGhPPII1qeJKEVizdgAc=;
        b=ISP3RTM0rESSUw1GZSACukPJeKQrwJn6BEnwkizlQqXjkA2K4TJ7lLeTSfBWeXhmud
         12I2lnJ5DcKWs8OZHxj3WSIBHAC1662yi13dvn1J9WQ3LlatgLsV0g2XQSSWlHUePWbc
         qitXVcJWowvmopnSEs2zeSmZhngbNU9gEAy6ELbDSggAb6GNpZjKNd0GACeZjMGMXBwg
         hLuY2+C4l6lZpt56enfYU/arFW3TAB34vJ/Oy6lQexYgaa5imz9x3M5LZr+GT8oXoulN
         QrIbdfzXb3rYhwdGEoXYrmU+qMSLqPC8upbHZW2rel9PZ0n7v5DieNo2p2xX7Y3nDBif
         /gCQ==
X-Gm-Message-State: AOAM533C5/JHMxh3TPshmIa6IRX8ORWxkdYSOQdEFH+tSIB2Z+8jjcm8
        s5IHlFEjQGGCI7cyqsijyVY=
X-Google-Smtp-Source: ABdhPJxgg+6HW/nkYND6FIYpSIwOCVgVCwhgP5w4gjjUPKxo+8FTUhk6R9FpRkCJOcLy05nHRyCiXg==
X-Received: by 2002:a17:903:11cc:b0:151:71e4:dadc with SMTP id q12-20020a17090311cc00b0015171e4dadcmr18883879plh.78.1648996997480;
        Sun, 03 Apr 2022 07:43:17 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:17 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 7/9] bpf: bpftool: Remove useless return value of libbpf_set_strict_mode
Date:   Sun,  3 Apr 2022 14:42:58 +0000
Message-Id: <20220403144300.6707-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220403144300.6707-1-laoar.shao@gmail.com>
References: <20220403144300.6707-1-laoar.shao@gmail.com>
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

libbpf_set_strict_mode alwasy return 0, so we don't need to check whether
the return value is 0 or not.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/bpftool/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index e81227761f5d..451cefc2d0da 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -507,9 +507,7 @@ int main(int argc, char **argv)
 		 * It will still be rejected if users use LIBBPF_STRICT_ALL
 		 * mode for loading generated skeleton.
 		 */
-		ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
-		if (ret)
-			p_err("failed to enable libbpf strict mode: %d", ret);
+		libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
 	}
 
 	argc -= optind;
-- 
2.17.1

