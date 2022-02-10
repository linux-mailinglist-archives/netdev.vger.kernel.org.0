Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E744B03F7
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 04:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiBJDcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 22:32:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiBJDcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 22:32:18 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341D723BD9;
        Wed,  9 Feb 2022 19:32:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so7170130pja.3;
        Wed, 09 Feb 2022 19:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j48+22ZByNM/hLovrTeV1WT75NKYqr7Fm/OV9vNHCNw=;
        b=JlUWCJAPQI439U0lMs+OPOWWl3X1lSr2P7x4WylcZgyfHbYwq6YrPZ3Tu5o5HafJKo
         fVHDurp6eQWq3TtiV6H+AX2hwcOb1kUUP+GFxY3kLz34H96bMRf+77VbH2GZz6+2XT67
         pARFWY+Dye1DP+h45smS7Pz/Ric4pJfu63wjsEAqwO/wtqr+kZL1Br+k6qAdmo1u2gmb
         cNFKvWDrB5Fbm58+cKvBB5CnpHs+Amo4RN0Zn5YatgJqAMood1vHixHJm7GqGlGQGaJm
         RB7mIH3Fo9KfdD22SCA7yrMwInDtQBuaNsRUqbzBOJT3Csj3IXeaS5crfx8TQammNg07
         hwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j48+22ZByNM/hLovrTeV1WT75NKYqr7Fm/OV9vNHCNw=;
        b=NGXlE2SEiAjE4H8Scv+eipkE1Rg2lF7klbmMGAW4LqYa+0ZfPPrRlv8TmJYvWy+rrH
         fe+9+3RZUCzkbY3XPQvDzWpuve8UNUnSnxc7LBbpYRj8k6J/Zspe67UmlhBuNNQuj2HV
         yFAXzFCEm3bHBDMFNVP+6JpscRK54tf2CwnC4/ejQ0zuVjdvBlzXq7z+/GdvWAN0x4GC
         hTTKmWDpYRJvnZR7Hdn67XT5SQQEJTFfKWUbPO92sNdzmYDkk1mDU8WGK8FrPmXe01Pl
         fDUvkH7jHUz89EZ85s7b685Hx9mhulhOOKWHgSzrEUnzXPQYplPKwMPPNn8WqqOk3X2l
         YgCw==
X-Gm-Message-State: AOAM531s6Zqv2+HECRVfqXa+AJ0ZV2p2gZNXzlDY0ipPloZo2kqO5Zhj
        zPw1Lgk8qB2ZwGjMszlBErSa5yl4Ck8=
X-Google-Smtp-Source: ABdhPJyo0+D8jUvlBqAmfE5CePl88jZnnBW8Ll4BK9L/VWpYynwKdcLU5UUEL1QpMQermI4wqHAdcA==
X-Received: by 2002:a17:903:249:: with SMTP id j9mr5276607plh.39.1644463939513;
        Wed, 09 Feb 2022 19:32:19 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s32sm14760483pfw.80.2022.02.09.19.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 19:32:19 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Hangbin Liu <liuhangbin@gmail.com>, Yi Chen <yiche@redhat.com>
Subject: [PATCH nf] selftests: netfilter: disable rp_filter on router
Date:   Thu, 10 Feb 2022 11:32:05 +0800
Message-Id: <20220210033205.928458-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Some distros may enalbe rp_filter by default. After ns1 change addr to
10.0.2.99 and set default router to 10.0.2.1, while the connected router
address is still 10.0.1.1. The router will not reply the arp request
from ns1. Fix it by setting the router's veth0 rp_filter to 0.

Before the fix:
  # ./nft_fib.sh
  PASS: fib expression did not cause unwanted packet drops
  Netns nsrouter-HQkDORO2 fib counter doesn't match expected packet count of 1 for 1.1.1.1
  table inet filter {
          chain prerouting {
                  type filter hook prerouting priority filter; policy accept;
                  ip daddr 1.1.1.1 fib saddr . iif oif missing counter packets 0 bytes 0 drop
                  ip6 daddr 1c3::c01d fib saddr . iif oif missing counter packets 0 bytes 0 drop
          }
  }

After the fix:
  # ./nft_fib.sh
  PASS: fib expression did not cause unwanted packet drops
  PASS: fib expression did drop packets for 1.1.1.1
  PASS: fib expression did drop packets for 1c3::c01d

Fixes: 82944421243e ("selftests: netfilter: add fib test case")
Signed-off-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/netfilter/nft_fib.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_fib.sh b/tools/testing/selftests/netfilter/nft_fib.sh
index 6caf6ac8c285..22c7feff8d48 100755
--- a/tools/testing/selftests/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/netfilter/nft_fib.sh
@@ -174,6 +174,8 @@ test_ping() {
 ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.rp_filter=0 > /dev/null
 
 sleep 3
 
-- 
2.31.1

