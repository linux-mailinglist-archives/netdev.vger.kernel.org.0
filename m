Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D012145D287
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347672AbhKYBuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352333AbhKYBsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 20:48:16 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FD7C07E5C4;
        Wed, 24 Nov 2021 16:55:29 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so6382873pjc.4;
        Wed, 24 Nov 2021 16:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zKGw+5FhjqjsRLyPOIU2XJSo3BqJM6Bv524beyTFEqs=;
        b=lOVrlsBwxr0VRFAvwYWjrR770ihA991/u2Rm+mgb2aPz6L7wpyDf7lKtlfdIT9MASr
         76ULrObQX7OEJNEtVnAfegTn8qPSZNCd6UxWMbI0dbfCMqVsii4WhsILJO80MPo3JuyI
         21qHhEuD86eCYDbEqc04h6e0IvJxVy+QpirE0GNFAy6f5uIZ/+PWMQrghiPOBCkIcW1K
         b+Mfztupe2Y8JfkbKfP8KhutVrbo3g1t1Cpyeup0eQ6YcK7pDFxCj0v1bEjPK+N8o7nh
         bPE5Imdcla5GiB65fJ5xQJrIVAGq/oENWcAkf2zU6TvpqUJ5GSc/GfhnI4ZpwtvSlYef
         nFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zKGw+5FhjqjsRLyPOIU2XJSo3BqJM6Bv524beyTFEqs=;
        b=iWcqvlIoYB24cHm8xt97Z5Wzgq6D0QAWDfiKvvqZxcd5dJkjqWpV+VFexDmuQs6hAP
         JBs2Qf/sRNnbjxdxcLQAvs4SyqvQEDBJOtamrXR4VsflFWCN1KNupyUGUT6LPH8Rdm5Z
         91n0c695QMA6d0UhwvxGaCWZV6fCYnNnM9qV8FfG0YbQnkOBmqMSwUCD2rdiS4/Er/9n
         F1QcFAmRl9TEM3+SiK0yTFhzAtU+c7LuaTF6TBUTcexhqNNf//IZi6KR7gKIUYZ101k/
         VR4GpQdF8lAdFSi5W/yEaPKoSTquCPmHiOE1t6PFnPNs3h0aALCZxWK4hleN9RMS3ug/
         BuOg==
X-Gm-Message-State: AOAM533wnIiQppHLkrEHM3RKN2C8giUL8KQHQgqQKtbaogw5BFrDn2cW
        v33sx5iPB6XZiQYIT7s0wcgX+ivyAbcVyA==
X-Google-Smtp-Source: ABdhPJxucWZqs4tun3xqiviWwOMWwzQlkYVhAy1nGc/tNzrPxt6DcAZupUBw+mvkbkt5Xn0/1u3cZg==
X-Received: by 2002:a17:902:c943:b0:142:1758:8ee7 with SMTP id i3-20020a170902c94300b0014217588ee7mr24007465pla.58.1637801728555;
        Wed, 24 Nov 2021 16:55:28 -0800 (PST)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id t4sm923583pfq.163.2021.11.24.16.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 16:55:28 -0800 (PST)
From:   davidcomponentone@gmail.com
X-Google-Original-From: yang.guang5@zte.com.cn
To:     ast@kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     davidcomponentone@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] libbpf: remove unneeded conversion to bool
Date:   Thu, 25 Nov 2021 08:54:53 +0800
Message-Id: <b7449bd983892bb5a7a76493daa41410ff19bb7d.1637736798.git.yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

The coccinelle report
./tools/lib/bpf/libbpf.c:1644:43-48:
WARNING: conversion to bool not needed here
Relational and logical operators evaluate to bool,
explicit conversion is overly verbose and unneeded.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 14a89dc99937..33eb365a0b7f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1641,7 +1641,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
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

