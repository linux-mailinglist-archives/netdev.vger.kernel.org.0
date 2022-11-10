Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A3A624602
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKJPeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiKJPe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:34:26 -0500
X-Greylist: delayed 732 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Nov 2022 07:33:14 PST
Received: from out203-205-221-192.mail.qq.com (out203-205-221-192.mail.qq.com [203.205.221.192])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACF540937
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 07:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1668094391;
        bh=WKAaVON2ncuiTViXUV+2Pk+5RbBLa1ZdK2Z4ndXxZMQ=;
        h=From:To:Cc:Subject:Date;
        b=HYHGwVfO+Qvl7sl59cInnmhYoM9j3V/OyrSAuwvOKi/ZpKDUpG25pcy1/xjbjJHCG
         efz07ZqTaNCCVG80yNMXtK5q6kJ5OMBfunRh4/pinSbcWpcfU8+4yb08sOsqya7/ZU
         sVPGVn7172foVcueolS+e1CyKoJxAACgnTG0bBL0=
Received: from localhost.localdomain ([111.199.191.46])
        by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
        id 4542142F; Thu, 10 Nov 2022 23:17:20 +0800
X-QQ-mid: xmsmtpt1668093440tv75ycliw
Message-ID: <tencent_3E0335A1CE2C91CB09159057B15138441F07@qq.com>
X-QQ-XMAILINFO: M7uElAZZZMmFzi406KAbOEUgH0eGd75eD6bJqID8rYRD5CrJERuxDIF0WfeAdX
         9jOU7DAdGKxOFYXWDsC34QRU938KhVZumwwYUl1gwPNEzU7lruJ7tCaDoPHmM4bpNm8osR4667+Z
         /k0xfRURYd8v6yQY7rCqx0Fu61FNzR1YbMxA8ATQXtSn7ALy6buG6UrvEl7V8NaYtZiKCIHNVPFf
         sk3knfOzCmB08uCnMTiQ99flslita/eYY48uVapJxPaJZeZLrgBUQEASa/U0Pb7VX2oukbX6J6hZ
         mGAY/8uQts+kb++ROdfYYmYMC/R+d9TWWotPNNq5TYy9ubk/Fau7KiWSV2GMr5RSirHzqB3dmazv
         kMDXbINCHqP+sCAt8XIVEpWkOXnulk5jZXvbF4XVAnPnfBIommDv2PfbF67JiMFp4ZnbrZPGHq7w
         ZzhLln+LgOzLXtEIxpI/U6Vsi3hNUhsHQk137ooL/J/nXL+lXA7P+GzxVyXGnjgDgvYMI9CM6YFb
         M2oBbRSykvzS05N/M9my/QjRSNdruDyzJKKZWnHcj6eMTSUUVJ4T7b4cGajdIBNVUtAoSpCrgh/p
         mdvWA5Refy5skFGFWYYiyP9TpuVj2Ss3zuAFwwWgYZ/6ZroAaB+e+GXNumKDAWC/vFPO5aicSRIt
         wHKvzBRuLScGua9PyYVF/y7CCgoQlZv94z67ak81fcff/I7TfSN3Uc5xRDXzFUQr3sWzTW8rzDC9
         DUoh24GIhG02CdyvrDR9uJzYZi6caPyryWZEqdnUS49vynvYbIQjrmzAL8Y6uvvXeBicyLGNxLS9
         73NLk70kim0EAnJ/nJdjnoM+U2QQrRxvHNAthjwJf9pwJqdf/rc4j83Js9YBMFtX3/LRKEy3wyQA
         tes0k32SwsEIW8yR4lRkjgJXXgn7ISpgw+dH/BST3xf5RXavBc9IzfuTPBvrIpVySVTGZbYawyHh
         OVM9y4GEYi6qel8XYDVNItlR06K4wHEwgM1G2rgu6uOCJShR3TWw==
From:   Rong Tao <rtoax@foxmail.com>
To:     davem@davemloft.net
Cc:     Rong Tao <rongtao@cestc.cn>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:BPF [MISC])
Subject: [PATCH] net/ipv4: Fix error: type name requires a specifier or qualifier
Date:   Thu, 10 Nov 2022 23:17:12 +0800
X-OQ-MSGID: <20221110151712.40621-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

since commit 5854a09b4957("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper")
linux/in.h use __DECLARE_FLEX_ARRAY() macro, and sync to tools/ in commit
036b8f5b8970("tools headers uapi: Update linux/in.h copy"), this macro
define in linux/stddef.h, which introduced in commit 3080ea5553cc("stddef:
Introduce DECLARE_FLEX_ARRAY() helper"), thus, stddef.h should be included
in in.h, which resolves the compilation error below:

How to reproduce this compilation error:

$ make -C tools/testing/selftests/bpf/
In file included from progs/bpf_flow.c:8:
linux/in.h:199:3: error: type name requires a specifier or qualifier
                __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
                ^
linux/in.h:199:32: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
                __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
                                             ^
2 errors generated.

Same error occurs with cgroup_skb_sk_lookup_kern.c, connect_force_port4.c,
connect_force_port6.c, etc. that contain the header linux/in.h.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 include/uapi/linux/in.h       | 1 +
 tools/include/uapi/linux/in.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index f243ce665f74..07a4cb149305 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -20,6 +20,7 @@
 #define _UAPI_LINUX_IN_H
 
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <linux/libc-compat.h>
 #include <linux/socket.h>
 
diff --git a/tools/include/uapi/linux/in.h b/tools/include/uapi/linux/in.h
index f243ce665f74..07a4cb149305 100644
--- a/tools/include/uapi/linux/in.h
+++ b/tools/include/uapi/linux/in.h
@@ -20,6 +20,7 @@
 #define _UAPI_LINUX_IN_H
 
 #include <linux/types.h>
+#include <linux/stddef.h>
 #include <linux/libc-compat.h>
 #include <linux/socket.h>
 
-- 
2.31.1

