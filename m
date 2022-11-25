Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5C0638991
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiKYMTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiKYMTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:19:15 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A19421B8;
        Fri, 25 Nov 2022 04:19:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVfPnmv_1669378749;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VVfPnmv_1669378749)
          by smtp.aliyun-inc.com;
          Fri, 25 Nov 2022 20:19:11 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] selftests/tls: Fix tls selftests dependency to correct algorithm
Date:   Fri, 25 Nov 2022 20:19:05 +0800
Message-Id: <20221125121905.88292-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
the SM3 and SM4 stand-alone library and the algorithm implementation for
the Crypto API into the same directory, and the corresponding relationship
of Kconfig is modified, CONFIG_CRYPTO_SM3/4 corresponds to the stand-alone
library of SM3/4, and CONFIG_CRYPTO_SM3/4_GENERIC corresponds to the
algorithm implementation for the Crypto API. Therefore, it is necessary
for this module to depend on the correct algorithm.

Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 tools/testing/selftests/net/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index ead7963b9bf0..bd89198cd817 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -43,5 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
-CONFIG_CRYPTO_SM4=y
+CONFIG_CRYPTO_SM4_GENERIC=y
 CONFIG_AMT=m
-- 
2.24.3 (Apple Git-128)

