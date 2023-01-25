Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AAD67B041
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbjAYKtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235778AbjAYKsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:48:47 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9650122A00
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:11 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id j17so13442337wms.0
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RV58zA+SCkILm0XZPHyNHRUHK+pvhsdLrbaM8qBjSmQ=;
        b=OwVPRCZNbCTLA52WGubCMcVDU60TsNctH4H52salJ2Q7Gdz2w8Yt25Xon0pQtOB61H
         D1NANQo8JZWdJHfJq79yGdGbMIgYZ+6HeUhFox+EDZLTwrQ0Yzjz0xo1VJzUyv+DTokM
         NV33WouA/XJUizV94qleUrEpbUvcrfcBwd/3r+g1AXiHKHZAATqSbwLPjjwQz7xuyBEN
         lcaMX/yIsxypXHrJHAlP5AnSMfRRDixWhcOCvHQkj1Qe8l2GQRbU7YOUf4Ul6I1dw28e
         MoH++G9CZTTNjw6AfdxE7mnl0k1orQ2l6oEtMpRUyyBzlayJFaFnT36bpxhAOkLYpg80
         zoNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RV58zA+SCkILm0XZPHyNHRUHK+pvhsdLrbaM8qBjSmQ=;
        b=qBjRjWWfxwv5n499RmmSOBe9eYpgulU1PwqVRt4juSyc1DXir37W7JzSzGy8IgpB1w
         IeRpFbNT4LBz+h0scxm9C+w8KxZyYPLa0hfppI4oYRjSZcKzJS5qmjKXknK8OkkR2cCR
         RFa2KOpv1CscFEKLEVN3FH/wbjfcyXr6Ii/FoxA0YyRDISzk/A5uRZHduEtWYFwUcoXv
         B7mQt3L+jeKGk3qctU2dUo+3TZgZj0ZvSIFquk27L2bdLZ+BZxS+HjCSwlqxc8PquPLe
         MZcS2xIbwS/iPTiHfdtYaIyZ7wPYaop/YkVYNfnmswGhOC0DLsI0AuUKlH2c3tJdrG6r
         npOA==
X-Gm-Message-State: AFqh2koVixRDFWIDfw1dCoYEMlhoWT2SbtUSCfwWbItUipQWyqEhoW5H
        2Kefpl2Dwqwuaw8kVKk/kLyStm7VTcQ5ge/knCpEQA==
X-Google-Smtp-Source: AMrXdXtLCWuwItXB+ckW/oTvPU1xdVUu7w/DaWjCAMc9Lv9MEwvEQhUGAEmBQ6t+gqOD9oZC/V4nGA==
X-Received: by 2002:a05:600c:4248:b0:3d9:7667:c0e4 with SMTP id r8-20020a05600c424800b003d97667c0e4mr30794094wmm.31.1674643684026;
        Wed, 25 Jan 2023 02:48:04 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id r1-20020a05600c424100b003d9a86a13bfsm1423692wmm.28.2023.01.25.02.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 02:48:03 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 25 Jan 2023 11:47:25 +0100
Subject: [PATCH net-next 5/8] selftests: mptcp: userspace: print titles
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230123-upstream-net-next-pm-v4-v6-v1-5-43fac502bfbf@tessares.net>
References: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
In-Reply-To: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Mailer: b4 0.12.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2983;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=P3VM/iCNu8iP43PEXa6tfD1YO3fGT98t37TeXBvPP7A=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj0Qjdo0FMtsrErT4zXkcmyHJwfc9WvK2QpqSwU2eH
 hOKZmn+JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY9EI3QAKCRD2t4JPQmmgc8JjD/
 4lpfj++M+BTlwMX8u0XpEr3FNE9Lw/PDWGnraa1zPHiOg1kW1k0lGMTalnWAvy+sPj9vECtXnJpIhN
 Xd1JpH4+SoYGNdP6L8NxqYG68YusvEFWeIG1G/+Dk8Ok+1f09XloxVzDuAe05fqKNd3KxYtST42BSy
 IrNBZTXsd/ifqVjBj1iBZwO+/EF9KDEJ/SPzsCIz5Be4Jj4iv3B1jMN0RgxoD6XsXFEz1LUT2YPiuM
 +vo4h2i25DodmyPmPzYHqWWthDnqtSx+6GQZN3qDN1i+vS/iOKGkLII8HVbqyfXpX4BJmq+SE91Zb1
 6avWRahqKRWJSipYGHQ60QR/xtm7DZG3oeYyohT18/egCMoTb9ai2kmRLdWDEhohBUznchN7D+aDi6
 ARzvH8K9nrLl7gAuj4EFPyufUDHq7Va30661tdV+x/s5js2yVIpEIIlIn4PP4ClJfACEVJEhsBHgP1
 6nsxAPVg7ijJzHyIEbViNdBR/NZ0gFRTasqyjSsMnf+fEXp15LXW3GCInoOLtRkdyVwZ8HJn86mXnd
 +OXQcNfIZUM7+MiPIrRmFaZahsYZpSEUQzdtiguNaKWnSrCtChSPwF5xVO1PzTAj9iI8LRBXX7TNkq
 qEm0DXd31HF6pfOQMfY6D0NQwPT+KkuwfE02/v3kfb5yw9maJefvEHaqJ6vQ==
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

This script is running a few tests after having setup the environment.

Printing titles helps understand what is being tested.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 24 ++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index ab2d581f28a1..7b06d9d0aa46 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -43,6 +43,11 @@ rndh=$(printf %x "$sec")-$(mktemp -u XXXXXX)
 ns1="ns1-$rndh"
 ns2="ns2-$rndh"
 
+print_title()
+{
+	stdbuf -o0 -e0 printf "INFO: %s\n" "${1}"
+}
+
 kill_wait()
 {
 	kill $1 > /dev/null 2>&1
@@ -51,7 +56,7 @@ kill_wait()
 
 cleanup()
 {
-	echo "cleanup"
+	print_title "Cleanup"
 
 	rm -rf $file $client_evts $server_evts
 
@@ -78,6 +83,8 @@ cleanup()
 	for netns in "$ns1" "$ns2" ;do
 		ip netns del "$netns"
 	done
+
+	stdbuf -o0 -e0 printf "Done\n"
 }
 
 trap cleanup EXIT
@@ -108,6 +115,7 @@ ip -net "$ns2" addr add dead:beef:1::2/64 dev ns2eth1 nodad
 ip -net "$ns2" addr add dead:beef:2::2/64 dev ns2eth1 nodad
 ip -net "$ns2" link set ns2eth1 up
 
+print_title "Init"
 stdbuf -o0 -e0 printf "Created network namespaces ns1, ns2         \t\t\t[OK]\n"
 
 make_file()
@@ -255,6 +263,8 @@ verify_announce_event()
 
 test_announce()
 {
+	print_title "Announce tests"
+
 	# Capture events on the network namespace running the server
 	:>"$server_evts"
 
@@ -359,6 +369,8 @@ verify_remove_event()
 
 test_remove()
 {
+	print_title "Remove tests"
+
 	# Capture events on the network namespace running the server
 	:>"$server_evts"
 
@@ -521,6 +533,8 @@ verify_subflow_events()
 
 test_subflows()
 {
+	print_title "Subflows v4 or v6 only tests"
+
 	# Capture events on the network namespace running the server
 	:>"$server_evts"
 
@@ -754,6 +768,8 @@ test_subflows()
 
 test_subflows_v4_v6_mix()
 {
+	print_title "Subflows v4 and v6 mix tests"
+
 	# Attempt to add a listener at 10.0.2.1:<subflow-port>
 	ip netns exec "$ns1" ./pm_nl_ctl listen 10.0.2.1\
 	   $app6_port > /dev/null 2>&1 &
@@ -800,6 +816,8 @@ test_subflows_v4_v6_mix()
 
 test_prio()
 {
+	print_title "Prio tests"
+
 	local count
 
 	# Send MP_PRIO signal from client to server machine
@@ -876,6 +894,8 @@ verify_listener_events()
 
 test_listener()
 {
+	print_title "Listener tests"
+
 	# Capture events on the network namespace running the client
 	:>$client_evts
 
@@ -902,8 +922,10 @@ test_listener()
 	verify_listener_events $client_evts $LISTENER_CLOSED $AF_INET 10.0.2.2 $client4_port
 }
 
+print_title "Make connections"
 make_connection
 make_connection "v6"
+
 test_announce
 test_remove
 test_subflows

-- 
2.38.1

