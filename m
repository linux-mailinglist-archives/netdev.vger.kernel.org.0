Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA47563D7A4
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiK3OHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiK3OHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D641D7721E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:06:57 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r26so22089272edc.10
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQO2/gt+7UaIdXHENQ5ZaxLgiM9C0b2kktLfe3u7CaA=;
        b=UP5IDyaYKAbQYwyPEVFU9u9jRWhTaimdQwDrnYu0VwshzwnFrDvEL9sdFfB1hicvJU
         gJct9ZZX1jFbJzKCqeSiedksAXrUtYxVL0RctQpKt3tyXG+/bKZWkraNR/0Ftb/C8ps3
         2CJ+SSAOmCKYSuibkG2+NSE80c2bQVIW/+oQAhQMa/43oJNA+P/AoY4l2EpenKSb+QID
         Czwaxgipp3E/bFZq6z2iijLpQTqxeIehkerBafnN5J9FPYaxn/Ara34DyrwjYo7+3p4Z
         t6ESno+WYUCzwyrF+wJojkUUNgoO37g8pDD4sgFBZ+ke4iPz4xCQzDaLccDSEGfI2pKk
         01nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQO2/gt+7UaIdXHENQ5ZaxLgiM9C0b2kktLfe3u7CaA=;
        b=K3QjcL5KmGBBAoluhA3CdJ0xPYNmXN7V9Ow/RJmt7h9VLkXFU3YyvDBreH5Bc/1/4g
         XNGOCtIqBvC/hURulZVA5xjIO0mAuw2saNUbg9QWB7EqLzmXOtewNuEACfrKW+ltPbuR
         ugt5LDXm90PzwHTYy4nzSUKhnGLmip+5o1txsSdM1GPe/NisogdgSXvOsWP9U3TX12pS
         mx/dYObldc75+ktGBgAsYsf4vwGxHlSqmtVEhrcIMFtevQQMTNjRn9ctBgvM6YKijUe4
         lUGo1dC7K40qVrUTlJcJ8eawuSS5Ctc0Z9JttgnTLE0Gn+0BnsvSGrjveKYa0asxywLh
         MDjA==
X-Gm-Message-State: ANoB5pnSqusJM9eb53PMlIanPgqEFaK8V7ZFuo+2a1UHd7hSiS4C5aZr
        Wh2q/+RQWahmts8vAe6Tel6bEw==
X-Google-Smtp-Source: AA0mqf6ggzzPvQ3J2jOw7BrYgDyTjNWOleO13OYDUTtaLi+CbbmMsBCWXvDPCuEq/IJWsgNh6G/qGw==
X-Received: by 2002:a05:6402:110d:b0:469:dd6:bfee with SMTP id u13-20020a056402110d00b004690dd6bfeemr40142074edv.330.1669817216324;
        Wed, 30 Nov 2022 06:06:56 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:06:55 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/11] selftests: mptcp: run mptcp_inq from a clean netns
Date:   Wed, 30 Nov 2022 15:06:23 +0100
Message-Id: <20221130140637.409926-2-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1101; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=21EHdex0rQiARRVFRiFLSu+im/TNbuOJS38o4ruu26M=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2Nnct4H0wj83WZH/+oM+MXHQnuCT8T9+BqudzJn
 xpwH41OJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djZwAKCRD2t4JPQmmgcwqOEA
 CXuREgN2zrT/bFDdL+YwSLjhAaLLXwGqs7Fvlkm7CdjnCE1vzNtTZ/1ZS8hq5aLaSxJVTY3DOoDF/9
 dY4X27Cp79Yzl/OXt53OWqQfAsaJ+/dxnNTiUGr2oZfN+fLLKKwDWZ6YiYjRBOO7zq6FllTQ9jtBsY
 egeBsY8u/abuBiyhL/x5KnhZfaKAuBeFPOu6bsE4sunZf4TadIABgztQ01OEAS75eot2Ik6kNFvs0n
 bKgTUriGwAsZD3b0WjoO8lEZDGfJ0KWL3ju7rjQNHAHCuAJB0Q0ywzRCAJSsXuYo2wM+mnQZp/pEb8
 Ec5L4zg5VNgz1AU1eP9eTp8QdmG06ymYr0Enr2QMJgqI3crCDH3zaOXEyU1WLSL19RxptbcrE6z4Ai
 ur0goV7R2R5DH9n341fjWODrrDXPtDel2QYnGHjr/EGLkeB+p1YNbzXfiKs+r6IxgKogYlKPQRB0AC
 Zd/ntthZvW8C4IQux8g/zyOy/hY9d4FzThIOvImWQ2Pr5Ntda+V7Poz9nA4RU08XbsKGX8uawCpP1q
 HbYcO69O3zB4tEk3fNGN9NmblsIj8fIcV60YPuVbRii01QgmD2mDIEAhmrZIkZaoVC1fHK2UXv2ztw
 J7mQE/ZVAyHHr5Gu850ARa4bnxt+wiVQB0EJK+6BCL+4CWFrjCCs0QM50uaA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new "sandbox" net namespace is available where no other netfilter
rules have been added.

Use this new netns instead of re-using "ns1" and clean it.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index 80d36f7cfee8..8a83100b212e 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -282,7 +282,7 @@ run_tests()
 
 do_tcpinq_test()
 {
-	ip netns exec "$ns1" ./mptcp_inq "$@"
+	ip netns exec "$ns_sbox" ./mptcp_inq "$@"
 	lret=$?
 	if [ $lret -ne 0 ];then
 		ret=$lret
@@ -298,9 +298,6 @@ do_tcpinq_tests()
 {
 	local lret=0
 
-	ip netns exec "$ns1" iptables -F
-	ip netns exec "$ns1" ip6tables -F
-
 	for args in "-t tcp" "-r tcp"; do
 		do_tcpinq_test $args
 		lret=$?
-- 
2.37.2

