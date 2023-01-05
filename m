Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1AB65F69B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 23:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbjAEWVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 17:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbjAEWVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 17:21:20 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBA26951E
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 14:21:20 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id w203so9768603pfc.12
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 14:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+/rwlFIn0hzbcNETA4wyU6wemvJ1Z4GiTdDdXZcLwaY=;
        b=dkTzAk+1ntj0auXOIzhxwO3g6qxTLW5rcQufexl+8slQLretMtDK9f5HKR4Aliyo39
         TBXDLPSZZ+cPoJEh5357XW2coZYeq+1e9MNXq7GSKaeRBrIVMhLdSL2gmSWInW2aRur7
         qX5tn4dbTdyy53FZ/I69t664nI2sKKOffks2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+/rwlFIn0hzbcNETA4wyU6wemvJ1Z4GiTdDdXZcLwaY=;
        b=dMKc5vjpQB9OWDXS6VIhEof26mE9OkauhlRvXt+3aNw0n6C+BKczM11pS4FUTxBLCJ
         QsXX+40MOrkztt8PxOPS17VFVtNXAU9iGRq4xARjrIqaPv2WcMUBk40Zbdxc43I9Hz5s
         j8PR5DgyZ2GScRPmemGAc2S5fZEP1GxEBow9Q2mx0NeRbdbDGTJP4B+CdLNzJA0zPIf+
         297dUVCFqKEoRvjZR1ZjTRRP6MZDqZPyh0pFlqb0ujJOr99O2FjsBz68vXeKSwZfcyix
         IjHIy/ekG048LesbI/qryx0lc0uiUccLQo4f1QIySF/bqQ2XUwUO2kQ/7yxyenyUMPmF
         jnmw==
X-Gm-Message-State: AFqh2krnaleo2zEiLNNmplMTK+Xfj1hEC1WirC8ldsRqDxVuDKIo2auo
        sc1TKht6SYmOvWXTRSXEmKmmOA==
X-Google-Smtp-Source: AMrXdXvsbcCqthlgFG/jU8xpWagS4JweS/XnATbEg9XOc38bDAosUQDy6Y5JAAFYoWTkfmAnN6dDwA==
X-Received: by 2002:a62:6d82:0:b0:580:da4d:d42a with SMTP id i124-20020a626d82000000b00580da4dd42amr41325570pfc.14.1672957279547;
        Thu, 05 Jan 2023 14:21:19 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 68-20020a621947000000b00580e679dcf2sm21861943pfz.157.2023.01.05.14.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 14:21:19 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Justin Iurman <justin.iurman@uliege.be>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] ipv6: ioam: Replace 0-length array with flexible array
Date:   Thu,  5 Jan 2023 14:21:16 -0800
Message-Id: <20230105222115.never.661-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1685; h=from:subject:message-id; bh=8PkLlA/lLOXSW+eJB32T+aG9Kn60zUa4hKXC+rzMGLs=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjt01cz7/LecK3nXxfm63JdHDplN1K4Q+y5tGGGSPM pUHKzwGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY7dNXAAKCRCJcvTf3G3AJvCJD/ 9dtKcuau0YnqLh8x7WrForeOZfMnYtRszMXUYKVft4FOrOsQ1BAzfridH4lEFedSI0AKz34hSCQxNI 9pU9cHvUjhC/gCo/ssOAQl9wJJ4HZhUqFWjzKpAHuaHE3e1VRoOJYt6L/RoF0EjE0XlVCLMZ9x1Vqs r+Le39VVbucfueuZyrYi9EzDHAw3zF46MNjMcq+m/FWvq4/n+g79tmQRJqEmUeLr2eHVdXqu+AI39R /t6xkHYShlreOKfsg4+qeySTppv/Go0fNAkVuU6ExrA/f6uWBZUQxb8NhSgRcR7U9RF1O3YydmqOFN cqzv7/8m6aUw9mxIojwCPpM+cn1jvTR13BLgwVYe5m+RW4LxUceL04xi/L1YZEhALEWzDXj+gWxotQ GVhwpNAPpztHLjX8fY0Jdzu3Pk8iAPFfqQkl1YNz89kk2bPNyuCDKjBPyGHzeK4x6GNgbKkQZ68Ilm TroxxrefIN30wEIhaLki1WABr+rZs0neuiRFkMMtfZAkA9PbdO1iIb260Ei+FbNutOcTYx1AZR6v7b Mcm1Dx0wF27u+OS0E6bME4TPp/JN3R6YpcsFNUa37xsXm/z7wfsjF10gPcUaMWTHbKaGIXG4X4Z+dc nPIUp2LUnE7439+DrZRdr9Nc/UhV8/G+2Hu+dkW97XuczBseF8nZVsKhlUvQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated[1]. Replace struct ioam6_trace_hdr's
"data" 0-length array with a flexible array. Detected with GCC 13,
using -fstrict-flex-arrays=3:

net/ipv6/ioam6_iptunnel.c: In function 'ioam6_build_state':
net/ipv6/ioam6_iptunnel.c:194:37: warning: array subscript <unknown> is outside array bounds of '__u8[0]' {aka 'unsigned char[]'} [-Warray-bounds=]
  194 |                 tuninfo->traceh.data[trace->remlen * 4] = IPV6_TLV_PADN;
      |                 ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
In file included from include/linux/ioam6.h:11,
                 from net/ipv6/ioam6_iptunnel.c:13:
include/uapi/linux/ioam6.h:130:17: note: while referencing 'data'
  130 |         __u8    data[0];
      |                 ^~~~

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Justin Iurman <justin.iurman@uliege.be>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/uapi/linux/ioam6.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ioam6.h b/include/uapi/linux/ioam6.h
index ac4de376f0ce..8f72b24fefb3 100644
--- a/include/uapi/linux/ioam6.h
+++ b/include/uapi/linux/ioam6.h
@@ -127,7 +127,7 @@ struct ioam6_trace_hdr {
 #endif
 
 #define IOAM6_TRACE_DATA_SIZE_MAX 244
-	__u8	data[0];
+	__u8	data[];
 } __attribute__((packed));
 
 #endif /* _UAPI_LINUX_IOAM6_H */
-- 
2.34.1

