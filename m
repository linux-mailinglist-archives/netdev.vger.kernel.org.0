Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6124EE926
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 09:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343891AbiDAHgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 03:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343887AbiDAHgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 03:36:36 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E957925D5DC
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 00:34:47 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r13so4037531ejd.5
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 00:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J1hFvC6nay7lPvt491Watt5p2YL/HVTxc1jbpi+4MTw=;
        b=u5dx23O9w+htxfzP+jRxgpvHgURvvK51lx7C4zHQtk+QKO2L80/wVWR4quv5mSnhxZ
         zJ8fwtu7rXcODSPimm6dMj1U3AVFgdqjU6S2dGzC+9xxAoVJVrk+q1p+6uBfAwJ65yoG
         ftGK783Y/HVSqGt3sG4/AxUz+xZLGCokBnDz+XhvCbq5MwbKUzLRlzx216C/MyD2agv4
         XYvO23lCRBsP7XCEvl12HDVSZi7LO2bqIYrfcPVJdNKcDMf1L71K3JdQOWtwHK79BGmh
         eaqWwjN3N3JmBBu+yzPoaShpVjTU+TQfE5YTU/Ijf0rgtxRiIIomriPHrb8MLBH+mr7f
         RHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J1hFvC6nay7lPvt491Watt5p2YL/HVTxc1jbpi+4MTw=;
        b=Rxbd9iTcw7dY8GWt+PuxBUTVqzFhLLZ01yaM/M/ETGMxFkoE9EpsWWxuDZJsXxEwDa
         7HXyJKo7X5u0MQMVp67PvMz2EdYGs/A9wrOEaP2Up6m/VHLBOuUlKC8pfaZAhuXW06/m
         mMA9z1/phnBKGnI2+dwJFJsqBVcXZiuaB/ymj1dTyAx/B9xmsKaQ49LvWwfsNLaWopch
         qKcvn+WtjBjBCmOrKF5Ix0xuHSYNRnHKacl/YG2yjVM0L+octmaeba3c5ltaenaBbpMd
         c9PhDT9OnxDOCTGhwsE29Xwm2mIaHs0t6jHqzm5MjHqFG6/SC3Y+rjVnZQzwbaw5nU8k
         B8+Q==
X-Gm-Message-State: AOAM531Un3ufhlKEnuPPaFSyQY4rMfjlQ97oTzRnRfImvcpRa2FJLbEW
        k5L7y2Or1OtzzoMmSq2hETXTrUtUE/PDg2PrmV8=
X-Google-Smtp-Source: ABdhPJwtJfrco1lwM+gX+jUBBSDMrSNdBnl2i/MSm3nuLXW9LGXa/va8vYV0o1L+rRTRQ9q3KDDoHw==
X-Received: by 2002:a17:907:1624:b0:6db:8caa:d71 with SMTP id hb36-20020a170907162400b006db8caa0d71mr8274921ejc.723.1648798486304;
        Fri, 01 Apr 2022 00:34:46 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id b7-20020a509f07000000b00418f85deda9sm816663edf.4.2022.04.01.00.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 00:34:45 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, donaldsharp72@gmail.com,
        philippe.guibert@outlook.com, kuba@kernel.org, davem@davemloft.net,
        idosch@idosch.org, Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net v2 2/2] selftests: net: add delete nexthop route warning test
Date:   Fri,  1 Apr 2022 10:33:43 +0300
Message-Id: <20220401073343.277047-3-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401073343.277047-1-razor@blackwall.org>
References: <20220401073343.277047-1-razor@blackwall.org>
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
Reviewed-by: David Ahern <dsahern@kernel.org>
---
v2: adjusted test comment (dsa)

 tools/testing/selftests/net/fib_nexthops.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index d444ee6aa3cb..d8ede0c81ac1 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1208,6 +1208,20 @@ ipv4_fcnal()
 	set +e
 	check_nexthop "dev veth1" ""
 	log_test $? 0 "Nexthops removed on admin down"
+
+	# nexthop route delete warning: route add with nhid and delete
+	# using device
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

