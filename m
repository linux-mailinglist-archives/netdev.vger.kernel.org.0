Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DEF68D816
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjBGNFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbjBGNFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:05:01 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A823A5AC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:04:50 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id o18so13491236wrj.3
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 05:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hw9n2rz8EZk7Zwt4b/TCgbVGXyOC2ofikV1UOhbOy28=;
        b=h0oK28sxWQ1yiqlMPhLdbuZWdEiu8VJlzmakwm4khsZ3Pcw3Uc4PYyty82iPHrAEBN
         vmQhIRRuVpTpUsCLcNwLDmYy3SxIfS8mmABlz5UAWrfpaMFnQyb4LSaMX+inmt5oxUvs
         PwtEBJZ7HK7TcRCALF0k84zaCwfjRDy6JN0rY0XSJg2aHb8jEpZ2Z1yufZn683gaSBrR
         uqsB14inHMxquGjIF6L1biGZBTrtDsXUjps0gaBo2WBqT7WBGLknJhVA5n9IzvYhw0rM
         xKPINz/lHHvwsETQ2x3V//PQGJAAvOhrgMiRwxNe2zf1NZjMXicjJj+YEehS8E4bsA5P
         R8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hw9n2rz8EZk7Zwt4b/TCgbVGXyOC2ofikV1UOhbOy28=;
        b=4IX2YoN3jV0T4gQr4dS57zHV9HWRFKnBjbB7iNbn/ONiv+OR+bQjeY3mz/27GrrErl
         KHOBIJfTWp7vA6qQvIVIN5Ve8pusHD0kDvIXZO8SPNDHsPsHumIx74EHjIJXaHdkxf/x
         wxzci7+CERUmAMjHbAYyioj4Kt2HdAdVWnAQuHbDtp8PXHnV49/EQIxpSzHe47fMQtX4
         c9zykjdIHAoNTG2QYOaw7FXKNKdqaDqxbGlkfIpfKrlHVRUH5uDBEoUZ07Gy2TCHEb/T
         i5aM6pVkYCJYhCU5T4dxtE4fNrlwNogsReXCd0mm5/JjyY6Kccwo9S3Wl0gp0RpHaAhx
         jDxQ==
X-Gm-Message-State: AO0yUKXge5RBa1WZ8TjXblke/F0/Z3QCBCVhidowJnWh+jFKFBSKyKKI
        pq9TItyMkBIVDXaAkcpohvDt7qnITxI2ZwF5qkk=
X-Google-Smtp-Source: AK7set8r31gVm7sG7P21njAagUkRUkg13ZEgePjdspPbk83jINW58WYZkT0Yj4PsigiNCJj09jtAaA==
X-Received: by 2002:adf:df83:0:b0:2bf:f027:3c30 with SMTP id z3-20020adfdf83000000b002bff0273c30mr2725354wrl.56.1675775088552;
        Tue, 07 Feb 2023 05:04:48 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d5989000000b002bc7fcf08ddsm11645394wri.103.2023.02.07.05.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:04:48 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 07 Feb 2023 14:04:18 +0100
Subject: [PATCH net 6/6] selftests: mptcp: stop tests earlier
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230207-upstream-net-20230207-various-fix-6-2-v1-6-2031b495c7cc@tessares.net>
References: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
In-Reply-To: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2465;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=KTY0Kro9lRunsEJq380yUjc2D3jyyLZ/WohBOjvZgO8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj4kxokI/kZwP6C9bNbWeMsWwDSDCb5JP9QFQRt
 trEDx7PjpGJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+JMaAAKCRD2t4JPQmmg
 c5NDEADmKOaYKUbBF/+HG67xP7kMvxCcOzFsp1s9zGzVvE0+pyXFA2MJIfp3qxHnYQBIuoIbQUf
 iyCFcfok/5Yqy6eKpWprWVXJ/u3i9GxXgGwDb2zpfqWBzCBrjy3l1Q9IZ/nrZZkO92tMC6BjEek
 KgTuYMdlTWZuSLP98K0jOGbgiUjZpqs8GVBv0IhV3ucjYowAq6PbZSqtGb6/y6Y9Nhf/Pd1V2ac
 bLxCSnJCHtqZEdM5iT2EnrTGQkffFuCyi7fSRklOQQ0WSdQ9/1Bahdz2JCVTfdO/QpptzX7UGnU
 4GFvMlwy8E7tM3KMAekkq5Z60C059BwSfCFsr6npt/hnxebwWFQ41LMrWo6705cpUutECeYN3LN
 gWzH3zFXc9jFw3KZVvsiQWC+Oy0OUV6nXNb1NfkRbfzQMESWhbJlnnDX3QW0CaEg2eigLE/ciXw
 d32t/4ENVtroYL/bmKZMBRDGwPHM2g14GBpJ2Hq0bePkvhjUKfw5JHrTMu4coUHilTn1hS7E5Vr
 2t6smyy1HHPGqAnc8bSpLTLILvvkEbVDW0881pcI59kM903uYKlseyU3kkk61kogi1dSXEmJF8j
 h0PN+ZF9XOlqQkhYiQYaSSSSNdDYy0meih/C8uPQKmD2fS9X1JZE2YLYzJAbrV2U2p/2nTZp/zZ
 cgAz6jAPYs9n+yA==
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

These 'endpoint' tests from 'mptcp_join.sh' selftest start a transfer in
the background and check the status during this transfer.

Once the expected events have been recorded, there is no reason to wait
for the data transfer to finish. It can be stopped earlier to reduce the
execution time by more than half.

For these tests, the exchanged data were not verified. Errors, if any,
were ignored but that's fine, plenty of other tests are looking at that.
It is then OK to mute stderr now that we are sure errors will be printed
(and still ignored) because the transfer is stopped before the end.

Fixes: e274f7154008 ("selftests: mptcp: add subflow limits test-cases")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f8a969300ef4..079f8f46849d 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -498,6 +498,12 @@ kill_events_pids()
 	kill_wait $evts_ns2_pid
 }
 
+kill_tests_wait()
+{
+	kill -SIGUSR1 $(ip netns pids $ns2) $(ip netns pids $ns1)
+	wait
+}
+
 pm_nl_set_limits()
 {
 	local ns=$1
@@ -3055,7 +3061,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow 2>/dev/null &
 
 		wait_mpj $ns1
 		pm_nl_check_endpoint 1 "creation" \
@@ -3068,14 +3074,14 @@ endpoint_tests()
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
 		pm_nl_check_endpoint 0 "modif is allowed" \
 			$ns2 10.0.2.2 id 1 flags signal
-		wait
+		kill_tests_wait
 	fi
 
 	if reset "delete and re-add"; then
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 &
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
 
 		wait_mpj $ns2
 		pm_nl_del_endpoint $ns2 2 10.0.2.2
@@ -3085,7 +3091,7 @@ endpoint_tests()
 		pm_nl_add_endpoint $ns2 10.0.2.2 dev ns2eth2 flags subflow
 		wait_mpj $ns2
 		chk_subflow_nr "" "after re-add" 2
-		wait
+		kill_tests_wait
 	fi
 }
 

-- 
2.38.1

