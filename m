Return-Path: <netdev+bounces-9274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87AFE72858A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD3681C21057
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C39E919922;
	Thu,  8 Jun 2023 16:39:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B029B171D7
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:39:36 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250AF35A6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:39:16 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-30af0aa4812so647397f8f.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686242342; x=1688834342;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z5QfjatVBc+UOU/sh03jIPNVrbTRG+sfLrSsyGdKccw=;
        b=FgcnTgDeIyKjr2ddER7XjIWrbKxbSmU4qNUhVBJsu0BeUs7lZOQVp38v/HH5qgE3zg
         Ottn+GpfAYauezlOB1eLjayZQ8yQv/OT7JB+LFFrN1MUPDrrqjaH0naxCVLrm5ZyaDBY
         q2CEBhQTeoe7p0QjuMXEkBLyvklz3y+pNZYcrhRMg3uF7ZnU+nZE1dZXOdxecdFS+VDO
         SYP7bz5G1W6Nql32d+MFW9nL/nLstTVTBWj6U4uPQYWvRXpTYIDJCR29HWX23cMJ5J8d
         t3w1E7INp2oQv1mHWNiW0M6WGpnfpXUnOloyjQIj+0Bok69H5tcPsIbszjdADtSgYsNb
         vmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242342; x=1688834342;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z5QfjatVBc+UOU/sh03jIPNVrbTRG+sfLrSsyGdKccw=;
        b=lN2LWV+DZvymWjIYrfAk1qJYduVCaSbHl37CeK4wJqr4ZyIb8b2gaqOFbH2fP6aoZ2
         mtwYnl9T7BT683jxmvqG2Q5kfq5vGE8LTveZ/KZA9FQmO7t71/NDOAvNdQk1K1dNA4/4
         F4YwDsFKVi+YkLhl0ZhSoqE5pV8iwobDDH5hSoCrNaZrJ31Bh4cGSKt6oV11/mEF6zlL
         UE0aaS63HyDDvlWjQ1mul8K/0d66XwoO6abjNQFGNO/jriY0R3Tmd0iJTe91/HvCbSoH
         TZ1+0ZzA7OfN+rIYDkXilgMYPBiKJBrNlpTBL7705aefQINlx4lVcA1a1+M601SkwNTA
         El9w==
X-Gm-Message-State: AC+VfDy/SRoLqGCdEbcIM12S80ZQ1Q45rTJGZGpqHZGR0l1Z8KqE5WgY
	ZRLeBVZbDp7IUz+gn5/92Gf5MQ==
X-Google-Smtp-Source: ACHHUZ7wx7hlSwuMrdCrq4YW/Kh5FCR6bvTO4XgnIy6RUYYvnVtbyh/v8tV9f4Kj6BZkkDQXR8yDhA==
X-Received: by 2002:a5d:65c2:0:b0:30a:6958:456 with SMTP id e2-20020a5d65c2000000b0030a69580456mr6237867wrw.4.1686242342528;
        Thu, 08 Jun 2023 09:39:02 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id e13-20020adfef0d000000b0030aeb3731d0sm2038215wro.98.2023.06.08.09.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 09:39:02 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 18:38:50 +0200
Subject: [PATCH net 08/14] selftests: mptcp: pm nl: skip fullmesh flag
 checks if not supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-8-20997a6fd841@tessares.net>
References: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-0-20997a6fd841@tessares.net>
In-Reply-To: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-0-20997a6fd841@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Davide Caratti <dcaratti@redhat.com>, 
 Dmytro Shytyi <dmytro@shytyi.net>, Menglong Dong <imagedong@tencent.com>, 
 Geliang Tang <geliang.tang@suse.com>, 
 Kishen Maloor <kishen.maloor@intel.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2408;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=fBWV1AaPrYseN5Cy0tbLjkgFuddp1+Kl8LYSe6sCVzY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkggQa9cZgI5NnXWQxzcCcxMao08wnQcD5e931m
 dXG6wzLDN+JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIIEGgAKCRD2t4JPQmmg
 c8luD/9WjQztHwOltdgDBF5y7YlQZ5onmoZos6LzgMQN6IjPZKmWoBDr4BA81g/din5tFnWv0K+
 kPGP+EU2JpD1wQfvFhc64aPZNXMqfPPgRpCyeyFO8apNwwg9yj2+B4M6IjENwwlYxq7A65a0JUP
 D3OdNQUdyRRMhJfaUz5tfHtcSrbJW7iMcmsYKUObPv0znqk2jJGWjKFz5NMxoUB51ys27v8oqdu
 0gncKx6fRfG16UB1T0btDLX1g3fvpvAbqCZv2Dhk1S1seovR0DuKo1UgrUNdg7HzBD2b+ceHYR4
 lz41jHOPx5ZdpxsSd3ObmeJRpzt9mXkynIatoIdST6Z1kqKzC+PHionYS2IfmOXkv3SAbvzn8eP
 5TsjD93PHrTKj0oG/FmeUkqATztSkU7d4XhlhXnTnMBjKo+KD6K3C3ebsKbT3/zA10FjGGykx/Y
 gwEqG4M0HVV8fCz/d0KjCerI3lS0H0WLUoyj4l9rK0PXK9Gn1fsa91YYG+50a5YZvhKoleCdyVa
 w8pa6nv71W7Zv0Lrt26343a6fbgVnNum3lEhgkucxeKtw1D/sUMuzrSqaU5B8oUFUDMVQLCB26t
 GyVdmSuNhwHhuxBK5WEfSq6Ve+h2FcFQKHQ8v0O1AJDne496xy7WjbmPW4MOWnUTU9c44NMqE0E
 zWB0ic0yaghREPA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the fullmesh flag that can be given to the MPTCP
in-kernel path-manager and introduced in commit 2843ff6f36db ("mptcp:
remote addresses fullmesh").

If the flag is not visible in the dump after having set it, we don't
check the content. Note that if we expect to have this feature and
SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES env var is set to 1, we always
check the content to avoid regressions.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 6da1dfdd037e ("selftests: mptcp: add set_flags tests in pm_netlink.sh")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index 664cafc60705..d02e0d63a8f9 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -178,14 +178,19 @@ subflow,backup 10.0.1.1" "set flags (backup)"
 ip netns exec $ns1 ./pm_nl_ctl set 10.0.1.1 flags nobackup
 check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow 10.0.1.1" "          (nobackup)"
+
+# fullmesh support has been added later
 ip netns exec $ns1 ./pm_nl_ctl set id 1 flags fullmesh
-check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+if ip netns exec $ns1 ./pm_nl_ctl dump | grep -q "fullmesh" ||
+   mptcp_lib_expect_all_features; then
+	check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow,fullmesh 10.0.1.1" "          (fullmesh)"
-ip netns exec $ns1 ./pm_nl_ctl set id 1 flags nofullmesh
-check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+	ip netns exec $ns1 ./pm_nl_ctl set id 1 flags nofullmesh
+	check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow 10.0.1.1" "          (nofullmesh)"
-ip netns exec $ns1 ./pm_nl_ctl set id 1 flags backup,fullmesh
-check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+	ip netns exec $ns1 ./pm_nl_ctl set id 1 flags backup,fullmesh
+	check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow,backup,fullmesh 10.0.1.1" "          (backup,fullmesh)"
+fi
 
 exit $ret

-- 
2.40.1


