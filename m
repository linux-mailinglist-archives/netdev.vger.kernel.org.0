Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABE863D7BB
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiK3OIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiK3OHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:37 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF798BD16
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:08 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bj12so41518563ejb.13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8+9TtQhJTeugjJt6JDxh1bHQ8477mWDIxdOTyt8gMw=;
        b=4oflt4ubSUqJSREur2/9AlJll73FxY6sPeNoi/8wc7ocqzr/u8Cl0H/oPniO8evrYC
         7SEqf9JNI9HBQYpZwbpGd6PgvYJaZ7lzjqGVZw/3jk286YmCOgvsFOi46eTOHUKRwj2g
         c/gsolXbaAlW2aAjBzQRmwIWjHrC5P3LGVNYKXD+3ARG9nokvofk7/EHXSxY3LKrYCq8
         E49GiNfIMAwvMevvQQdi98im6TmTo2/aT1k8CUTo3T8HzBFvDX5Veu49i6PIdNgHmps0
         SF6LShcVe6xUAYMKcqNWatomleAHfran5j/kWwOqpGwt54vpuo30sd0Hi8kVLrplmey2
         jX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8+9TtQhJTeugjJt6JDxh1bHQ8477mWDIxdOTyt8gMw=;
        b=QzuABcgCfTzTc/vI+sfgTIqQO0Vs8HQJMCkTYcsFRbDxHq0jm2hQLDFDsJL19kLMPN
         edacmtKfY4Zt/Dqj9fYVioX3itubUL/mFx84rFlKjtufiB45vCvwKyulXglWPjzBMCgq
         jzeEJesmOMtdhWw7wLC83xXMtw9tDuPZraOkYHtWDs9TTZUDhCrlTRU3q0kRR2Bwlumt
         NNSWORCZMteSzQ2owGaev4nn8cZlRi7xTAqw63F11srCyK+u6bTWuvqRo3MCoMUBLuUO
         Q81uwCZAhsiEFeV5lQXUbm4XFj4TRsSdw3ThTuP7LgW48Cg/rIHIx2XnoC2uERCoSeFg
         d4Mw==
X-Gm-Message-State: ANoB5pnNQjjY73DK4rAruXTV/CbNeIJErgIw2pe3M66URx10C4wb6Pbo
        Ym0peWY4yEUhw3qQMIQWooAgqs/pUw20qz310ng=
X-Google-Smtp-Source: AA0mqf6xQFkbPndD0+0xMKNKfhBREvCTpy6IDc9dr5EQT+7HRW5hZ+Pa9H9qnGWSWNlwoac4ZVY9Aw==
X-Received: by 2002:a17:906:1106:b0:7be:833e:d242 with SMTP id h6-20020a170906110600b007be833ed242mr16211181eja.405.1669817226587;
        Wed, 30 Nov 2022 06:07:06 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:07:05 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/11] selftests: mptcp: enhance userspace pm tests
Date:   Wed, 30 Nov 2022 15:06:29 +0100
Message-Id: <20221130140637.409926-8-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2625; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=Uj60AGilfzPETmXERWWoIIHskkAhbbWouLnBIXu+gN4=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2NoIX0vsxi6qa6Jw9EvRJSFj6RKVVDVxl079pit
 dpz244SJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djaAAKCRD2t4JPQmmgc+QuD/
 4vEfMtrQx3rmlLZrWdN7G+a5I4u1HKqoMgVD/K8hnMq+rbBZsSxkXv0i13De/SUMveauxDcN+h0OGn
 M9bWZkwrt7Vbd+YKt1Eajj+wYl5fN9RHqKXx3GhciodaTxc71HCEZwUDviloUYXzJjjDZzk5EnzM85
 pEyDiRqsFHKfX2YcpXhdvk2HtGoLfFTXI1BzEpVyQnrcOimfiIPPI6iEDWvTleaeK7rug/FrOV1K5f
 HL0btU98dEPfIAYfCaU1gem2Qf9OuRP155KNU0vwTwcnIb2Iv3rmBi6cPW83uz9wbRIfu+bQqvhRWC
 hvWA6fKih0LTqlLAEB9H1fWPWlMXFQk9xQOMqF2a3FYp4M6I9jZSYB34yeDRO4z9gEYZi4M1Rkv+Zq
 c5EOxvzuM7t8IBWVUnoUdfWqC7kFFr+DpYdstkHwL427+m741j8mylCCJeD2rcnzdWvaOW00J7B5NW
 I2Bg+WsKmZoFU3p57XnpTtQMm90/x0O4EkO5hlEyaSyWSkdQuJmVZ3j0cpHsYNKfgssrvRGFnoDg1A
 0IpSJbkwPFpjFtGqWW0awE74dAbjF2yaBJ8TdMdNFJHS8qpmt/w2DSYZlrMo2S6FFW4lzNR0QqCH8t
 dHY/qK32CqLtp1lbDrtl4UmBe+fPYE+e1J2nJpXdPRNYdxQGm9cXvTIzbQFg==
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

From: Geliang Tang <geliang.tang@suse.com>

Some userspace pm tests failed since pm listener events have been added.
Now MPTCP_EVENT_LISTENER_CREATED event becomes the first item in the
events list like this:

 type:15,family:2,sport:10006,saddr4:0.0.0.0
 type:1,token:3701282876,server_side:1,family:2,saddr4:10.0.1.1,...

And no token value in this MPTCP_EVENT_LISTENER_CREATED event.

This patch fixes this by specifying the type 1 item to search for token
values.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh   | 3 ++-
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 2a402b3b771f..f10ef65a7009 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -830,7 +830,8 @@ do_transfer()
 			if [ $userspace_pm -eq 0 ]; then
 				pm_nl_add_endpoint $ns1 $addr flags signal
 			else
-				tk=$(sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns1")
+				tk=$(grep "type:1," "$evts_ns1" |
+				     sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q')
 				ip netns exec ${listener_ns} ./pm_nl_ctl ann $addr token $tk id $id
 				sleep 1
 				ip netns exec ${listener_ns} ./pm_nl_ctl rem token $tk id $id
diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 5dfc3ee74b98..08a88ea47a29 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -172,9 +172,10 @@ make_connection()
 	client_serverside=$(sed --unbuffered -n 's/.*\(server_side:\)\([[:digit:]]*\).*$/\2/p;q'\
 				      "$client_evts")
 	kill_wait $server_evts_pid
-	server_token=$(sed --unbuffered -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
-	server_serverside=$(sed --unbuffered -n 's/.*\(server_side:\)\([[:digit:]]*\).*$/\2/p;q'\
-				      "$server_evts")
+	server_token=$(grep "type:1," "$server_evts" |
+		       sed --unbuffered -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q')
+	server_serverside=$(grep "type:1," "$server_evts" |
+			    sed --unbuffered -n 's/.*\(server_side:\)\([[:digit:]]*\).*$/\2/p;q')
 	rm -f "$client_evts" "$server_evts" "$file"
 
 	if [ "$client_token" != "" ] && [ "$server_token" != "" ] && [ "$client_serverside" = 0 ] &&
-- 
2.37.2

