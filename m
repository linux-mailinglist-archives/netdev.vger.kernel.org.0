Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF25197E48
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgC3OY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:24:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44973 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgC3OY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 10:24:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id m17so21829120wrw.11
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 07:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EhYefHey9uPfk3DFQ/3jm1vdYJVN5Kpj0zlBoZ4NBzw=;
        b=wX1hRieN/xZKXphFgTKe64yuK9o+rCgpphBlswk2qZFCgF3FOoe2tgc+1iZ5Ch27Ve
         afOPszc7U1v8PlSEhKSrkcIRwaWepY88L9RMCYcaiZ9mjtMWf5QNk/wsKHZzU2ylx3Kv
         EB63B7cxIWao4iWjrGESxos/0/o1vhCrYib4Dsw3y7KfwS2nQnaH9hAobd8RQqRqgzu7
         RyRmaufqUETZRXWsmpIOIDf23P8kENoDoFyicppELC2FKU1jpjkuO2ns1fxRVd/NAeL/
         xP2Dze1PgJpyLTBTTE4S2JkkYsRlav5IA/eR7MCX6nHn364tpXcb72JkqxgDMoKqYQhX
         6EzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EhYefHey9uPfk3DFQ/3jm1vdYJVN5Kpj0zlBoZ4NBzw=;
        b=bX/bXrzDL4xZQMI4nx3JZhzYwWbU7Nfp9NiQPiUDB0ngUHvKFQffR3oRr1wlt3p7Zc
         d6pIJ/vJyybzBvA1Y+k13T3wiJ6+UwjtxqoZyqRjxRbQelSa78vbZ40RS2IcKFzd/vQv
         /geVFguZEvGV2GeT8/HCXoma7ZDvte78uvNMMemunzT8K0lc+5jx/GLolx+iD01mgX5e
         ja5MbmiiLEx8+8TUVuRERXwSWs0oiD9Ri9MBfCpNphAJ2M/+CQFSeU+w3GBQHCqXmrgY
         BtUbSbtipx7y+WN2hNYG8a4r5pXRm7bIX1I5GuXGo3cfiO6pkUik3TUFwT1buWjqthP7
         qZpQ==
X-Gm-Message-State: ANhLgQ2/u3GaBCtuTXA4uZGEU0+4kz2fDQqVwKTiMPwoCD/ov6CZXzcN
        dkuy1CF/zXSj1/JE0kcrfpDefaQTtwWZOw==
X-Google-Smtp-Source: ADFU+vuVS9XnafD6XDFU33nulXJNMftfAUIOSUQENG/9dNdU5QH43S+EJW46gNquMyNujDyt0lF40Q==
X-Received: by 2002:adf:d849:: with SMTP id k9mr15043107wrl.108.1585578264756;
        Mon, 30 Mar 2020 07:24:24 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id 98sm22956856wrk.52.2020.03.30.07.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 07:24:23 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 1/1] selftests:mptcp: fix failure due to whitespace damage
Date:   Mon, 30 Mar 2020 16:23:54 +0200
Message-Id: <20200330142354.563259-2-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200330142354.563259-1-matthieu.baerts@tessares.net>
References: <20200330142354.563259-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'pm_nl_ctl' was adding a trailing whitespace after having printed the
IP. But at the end, the IP element is currently always the last one.

The bash script launching 'pm_nl_ctl' had trailing whitespaces in the
expected result on purpose. But these whitespaces have been removed when
the patch has been applied upstream. To avoid trailing whitespaces in
the bash code, 'pm_nl_ctl' and expected results have now been adapted.

The MPTCP PM selftest can now pass again.

Fixes: eedbc685321b (selftests: add PM netlink functional tests)
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh | 12 ++++++------
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c   |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index 8c7bd722476e..9172746b6cf0 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -75,29 +75,29 @@ subflows 0" "defaults limits"
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.2 flags subflow dev lo
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.3 flags signal,backup
-check "ip netns exec $ns1 ./pm_nl_ctl get 1" "id 1 flags  10.0.1.1 " "simple add/get addr"
+check "ip netns exec $ns1 ./pm_nl_ctl get 1" "id 1 flags  10.0.1.1" "simple add/get addr"
 
 check "ip netns exec $ns1 ./pm_nl_ctl dump" \
 "id 1 flags  10.0.1.1
 id 2 flags subflow dev lo 10.0.1.2
-id 3 flags signal,backup 10.0.1.3 " "dump addrs"
+id 3 flags signal,backup 10.0.1.3" "dump addrs"
 
 ip netns exec $ns1 ./pm_nl_ctl del 2
 check "ip netns exec $ns1 ./pm_nl_ctl get 2" "" "simple del addr"
 check "ip netns exec $ns1 ./pm_nl_ctl dump" \
 "id 1 flags  10.0.1.1
-id 3 flags signal,backup 10.0.1.3 " "dump addrs after del"
+id 3 flags signal,backup 10.0.1.3" "dump addrs after del"
 
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.3
 check "ip netns exec $ns1 ./pm_nl_ctl get 4" "" "duplicate addr"
 
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.4 id 10 flags signal
-check "ip netns exec $ns1 ./pm_nl_ctl get 4" "id 4 flags signal 10.0.1.4 " "id addr increment"
+check "ip netns exec $ns1 ./pm_nl_ctl get 4" "id 4 flags signal 10.0.1.4" "id addr increment"
 
 for i in `seq 5 9`; do
 	ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.$i flags signal >/dev/null 2>&1
 done
-check "ip netns exec $ns1 ./pm_nl_ctl get 9" "id 9 flags signal 10.0.1.9 " "hard addr limit"
+check "ip netns exec $ns1 ./pm_nl_ctl get 9" "id 9 flags signal 10.0.1.9" "hard addr limit"
 check "ip netns exec $ns1 ./pm_nl_ctl get 10" "" "above hard addr limit"
 
 for i in `seq 9 256`; do
@@ -110,7 +110,7 @@ id 4 flags signal 10.0.1.4
 id 5 flags signal 10.0.1.5
 id 6 flags signal 10.0.1.6
 id 7 flags signal 10.0.1.7
-id 8 flags signal 10.0.1.8 " "id limit"
+id 8 flags signal 10.0.1.8" "id limit"
 
 ip netns exec $ns1 ./pm_nl_ctl flush
 check "ip netns exec $ns1 ./pm_nl_ctl dump" "" "flush addrs"
diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index de9209305026..b24a2f17d415 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -335,14 +335,14 @@ static void print_addr(struct rtattr *attrs, int len)
 				error(1, errno, "wrong IP (v4) for family %d",
 				      family);
 			inet_ntop(AF_INET, RTA_DATA(attrs), str, sizeof(str));
-			printf("%s ", str);
+			printf("%s", str);
 		}
 		if (attrs->rta_type == MPTCP_PM_ADDR_ATTR_ADDR6) {
 			if (family != AF_INET6)
 				error(1, errno, "wrong IP (v6) for family %d",
 				      family);
 			inet_ntop(AF_INET6, RTA_DATA(attrs), str, sizeof(str));
-			printf("%s ", str);
+			printf("%s", str);
 		}
 		if (attrs->rta_type == MPTCP_PM_ADDR_ATTR_ID) {
 			memcpy(&id, RTA_DATA(attrs), 1);
-- 
2.25.1

