Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2C74EDDDA
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiCaPuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239392AbiCaPtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:49:49 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857FB1E31B8
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:47:48 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g22so17568386edz.2
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nskiFwx+g2T4qgOaIJRCNY4/G4AKqd9dpI6ucmP1lGM=;
        b=03PCAbp3f+5DFRCn6JOj3Wy7NBvanDFLIutm9Bw9LUkXSjbeiK6udmBp/xZd6EWTf6
         xqfBkPFapHIGqZeh3Ja0R1tbqAN1uarEgBrpyWwqg/0Ky73tD/kYnC8rhBzCSRDp90nc
         VLqkGmBnTpxwRkxOhbQh7vuSiHFoUyK6xVTGw8YkE3O2OEFsb+0zGz6CvbzIqmEQILEE
         N/VnhMslGSy+xYpaRJDkra7Eewjnm7rllbZxlTL+MMVQP1XzV2QSKeEETxXQzH5Ftzbk
         cxfkqr/NeG/9cvZCpjQ7zS4gDjmBSF3AeF3f3guXDgS0yw3QuDD2kwwx1lax2iAYjkdX
         aOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nskiFwx+g2T4qgOaIJRCNY4/G4AKqd9dpI6ucmP1lGM=;
        b=KFAX9t9qnGcZXA/bAJIP6+98IoMFlWeVmtK8aUmhy+dwNzjaIgvev+p/vu4i6Uxafz
         d6fKVcFPY5QqwM4krsF9DAtm0XpVhqUZzxN2jiSdXAZjcGXHHVY/4lqVMrNBhWtUF73p
         Uixcvqf5fQ8964ChTA7cxCw4zNeynuHoD/347Z7FFGeF3To1ZvbuHpbwWc3Chi73TNQe
         oGb3o+f5Rpx20v8uA7yr+hzWYWwPwcO20ptMgEKCpDTXemHfEvyD5BK/Qi8F8pxoBj9d
         m09JhbttHRvPcJNft9NmQw8xuPDEzKp2IU/DZ/+m4iNZZgBec9mqm2piu/mY/Kcfx0S7
         oazg==
X-Gm-Message-State: AOAM533MSz3vw+d6vGrl2+3odQFcBD+pWWcW6wXBr9bCdDJ4Kc2IUMpJ
        QiLdAY4qCqRaVrKsF9jzFkU4/Onu0N4nDeWK658=
X-Google-Smtp-Source: ABdhPJzpV0ejMveP6c9fvJgKsZ+sNf7lqhY+tgEyZKvnGnNXL5wedkRVGxdpVzCSLOZWQtDs8SDzAw==
X-Received: by 2002:a50:ee15:0:b0:41b:67a0:860 with SMTP id g21-20020a50ee15000000b0041b67a00860mr8953498eds.48.1648741666460;
        Thu, 31 Mar 2022 08:47:46 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id dk21-20020a0564021d9500b0041b501eab8csm4016576edb.57.2022.03.31.08.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 08:47:46 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, donaldsharp72@gmail.com,
        philippe.guibert@outlook.com, kuba@kernel.org, davem@davemloft.net,
        idosch@idosch.org, Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net 2/2] selftests: net: add delete nexthop route warning test
Date:   Thu, 31 Mar 2022 18:46:15 +0300
Message-Id: <20220331154615.108214-3-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331154615.108214-1-razor@blackwall.org>
References: <20220331154615.108214-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test which causes a WARNING on kernels which treat a
nexthop route like a normal route when comparing for deletion and a
device is specified. That is, a route is found but we hit a warning while
matching it. The warning is from fib_info_nh() in include/net/nexthop.h
because we run it on a fib_info with nexthop object. The call chain is:
 inet_rtm_delroute -> fib_table_delete -> fib_nh_match (called with a
nexthop fib_info and also with fc_oif set thus calling fib_info_nh on
the fib_info and triggering the warning).

Repro steps:
 $ ip nexthop add id 12 via 172.16.1.3 dev veth1
 $ ip route add 172.16.101.1/32 nhid 12
 $ ip route delete 172.16.101.1/32 dev veth1

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 tools/testing/selftests/net/fib_nexthops.sh | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index d444ee6aa3cb..371e3e0c91b7 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1208,6 +1208,19 @@ ipv4_fcnal()
 	set +e
 	check_nexthop "dev veth1" ""
 	log_test $? 0 "Nexthops removed on admin down"
+
+	# nexthop route delete warning
+	run_cmd "$IP li set dev veth1 up"
+	run_cmd "$IP nexthop add id 12 via 172.16.1.3 dev veth1"
+	out1=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	run_cmd "$IP route add 172.16.101.1/32 nhid 12"
+	run_cmd "$IP route delete 172.16.101.1/32 dev veth1"
+	out2=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	[ $out1 -eq $out2 ]
+	rc=$?
+	log_test $rc 0 "Delete nexthop route warning"
+	run_cmd "$IP ip route delete 172.16.101.1/32 nhid 12"
+	run_cmd "$IP ip nexthop del id 12"
 }
 
 ipv4_grp_fcnal()
-- 
2.35.1

