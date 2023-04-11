Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2038D6DE5EA
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjDKUmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjDKUmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:42:40 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F315581
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:42:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id he11-20020a05600c540b00b003ef6d684102so3128537wmb.3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681245747;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Qg0UfDgtzM4SSag2U8RERLst0NUUqYRmB2P1uH49t4=;
        b=IGWcpTfjatCz3Eqo5P30S165MgQ8L4VYNgUdGlU7f47eKTaqEl/N0R2Bxijvo4pFg9
         uanbjdbEphIkQDQQEZvaB8ooRWJVv+h7h963uEFJa7dXYDHWqUkAkmm6bTqrjLsz277H
         UfMjUqNzcQZXhCGgsQ+UXxRYJqbcxdztwMq4/Kb7HKNGlv5gphgCTsS1rVR+qx7kEFxk
         4jo+TQgpaCUpe07hKrVaVHQwTUPQyulQDEQVgAPyCj9SbQ6jucUN9bCwfQby51IPFwAY
         ZBAqhQ/EKWaGtG/XvskTPwGou2g8oRoiWi9RLipLyDVoSETAxYgTDlezEF5ORVgAIoJ5
         bLkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681245747;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Qg0UfDgtzM4SSag2U8RERLst0NUUqYRmB2P1uH49t4=;
        b=Vbibjgyha2+NUrnIbPSjsus9KjyyX2CcE9f9om9O9W6S42/JQNKpJ5NK+1PDHXYTkB
         tVX5O/B2PnwLordjIENZZRW0fnFR0unI3BQpi2iRZhty1BcliPV8M7V7pprTlkt8gPXq
         UPHwkhAmrFtGLbVeInmumF+R/P/7oxPZwfdw3Ntn5TamXDRbmucPw64fnMUx7mZMreqQ
         piSiPVEoL105YK7J+8bQSOFjvj2fYQ3S2FUTWEqVDCkYhvHTtlpnUoAa6pzLsvJ22lI9
         9ReLgiQvUaQZjHtEqUIOCfO+4CL1NZ/R46BFACCvuhhx1uZNkjOYKhazsV0xTBWeUSKb
         rdNQ==
X-Gm-Message-State: AAQBX9d42bgkm1wzR9pgU2jj1G3q5VuHxxAkJn0qpIAvxxK4dFq1djMD
        9oNMwbZOgjTrxF0b806hzHsfew==
X-Google-Smtp-Source: AKy350YOhcv/3WdKElepCqK9tqJwEaQ5hRFPchVWdToziQmNHv5rNkdb33WZI77d1usKv9fmjcp+nA==
X-Received: by 2002:a7b:cb51:0:b0:3eb:38e6:f650 with SMTP id v17-20020a7bcb51000000b003eb38e6f650mr9930062wmj.41.1681245747534;
        Tue, 11 Apr 2023 13:42:27 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id p23-20020a1c7417000000b003f0824e8c92sm86887wmc.7.2023.04.11.13.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:42:27 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 11 Apr 2023 22:42:12 +0200
Subject: [PATCH net 4/4] selftests: mptcp: userspace pm: uniform verify
 events
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230411-upstream-net-20230411-mptcp-fixes-v1-4-ca540f3ef986@tessares.net>
References: <20230411-upstream-net-20230411-mptcp-fixes-v1-0-ca540f3ef986@tessares.net>
In-Reply-To: <20230411-upstream-net-20230411-mptcp-fixes-v1-0-ca540f3ef986@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Dmytro Shytyi <dmytro@shytyi.net>,
        Shuah Khan <shuah@kernel.org>,
        Mat Martineau <martineau@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1921;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=1MrCCJJ5GEMq7hx3eoZhKgDEbgVWmBJ0bqSM6h+3CbQ=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkNcYubzn7jx0MUsvw+rle5p4XlZD7yypcKbS9P
 oImjRChXFKJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZDXGLgAKCRD2t4JPQmmg
 c0o6EAChDN8Dhftr1GID9h82qJ9Na9va86JfYFDLY2V766qElhR28T/K7pa+W3+oDlE92GSkmV5
 aHUjNUjxBY4iXgRL4LSfUXTF7A1J+lGDCevgl32h+RzgO/G49ZehMU8zw7g+yHDKFNd3GtBDtpC
 R+LBTS015DkEdUwdzPvOebCKu8Wd6CUINI8GlN3G3Cf37UzMmRFEAaDsjszwx5cCC946OXjpLOW
 dEsD8yWQUc1g0zTKTYYtc+HGkLoAyYYNpyJWIf6JMubGo4Jwjjx51CNtIH6OXywmy7Pfk8Eheai
 UCYP7amDN0J930qgXB/SgTqj3x0xZPWu/QDgoMFQTck7lAPjwPTxp2979RJ14OopFnrY9HcI1wb
 rxqTrDLiIqk9j96BoFSn7KediHPoJANBsCGIxhGxRbsTi21fCINZVWV0IK5538i4G2yanRSUZmC
 kyOv6gRNIQLz1qvdpbVrUZkwk//osw5vnhQqY304o/hf3qAJcxr2zGWJM++ja6J1LXHNW1dFqU0
 tdqxoTDaBSwQbdYJ2Hh6qakprbN1mA9OJAUB6ohe4Rpc2qpGGuxqj6yzdigrmhhGp9PVk1GRvvK
 MruZNp6pcMVP+TPt00b5CD+VdeE3l3UsoEOS8+FVdUSLIPFdN1BH0X2dJ/WDooyMNqIGBa2XEIa
 H9xLIt5le1z8XlA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simply adding a "sleep" before checking something is usually not a good
idea because the time that has been picked can not be enough or too
much. The best is to wait for events with a timeout.

In this selftest, 'sleep 0.5' is used more than 40 times. It is always
used before calling a 'verify_*' function except for this
verify_listener_events which has been added later.

At the end, using all these 'sleep 0.5' seems to work: the slow CIs
don't complain so far. Also because it doesn't take too much time, we
can just add two more 'sleep 0.5' to uniform what is done before calling
a 'verify_*' function. For the same reasons, we can also delay a bigger
refactoring to replace all these 'sleep 0.5' by functions waiting for
events instead of waiting for a fix time and hope for the best.

Fixes: 6c73008aa301 ("selftests: mptcp: listener test for userspace PM")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 48e52f995a98..b1eb7bce599d 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -913,6 +913,7 @@ test_listener()
 		$client4_port > /dev/null 2>&1 &
 	local listener_pid=$!
 
+	sleep 0.5
 	verify_listener_events $client_evts $LISTENER_CREATED $AF_INET 10.0.2.2 $client4_port
 
 	# ADD_ADDR from client to server machine reusing the subflow port
@@ -928,6 +929,7 @@ test_listener()
 	# Delete the listener from the client ns, if one was created
 	kill_wait $listener_pid
 
+	sleep 0.5
 	verify_listener_events $client_evts $LISTENER_CLOSED $AF_INET 10.0.2.2 $client4_port
 }
 

-- 
2.39.2

