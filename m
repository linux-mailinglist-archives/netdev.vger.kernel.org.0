Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1674A77F5
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346606AbiBBSaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:30:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242873AbiBBSae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:30:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643826633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VxSphhwkRTd5EsHLOOcvZP0sk5rc5kz4nLvAGye4isI=;
        b=TMdULIE0hw4oa6SCEajgnlNmyaifXAzrCjFH9zX3t77VIJ4m4bdNhmOv6A6K7Fqc82qEPN
        DxpeWkoFRWbCkFRiE3GSb6c+QLntKYKI3PsvFXtcKpenpvk3wzTwvoetJ0qcLuwrR8KCHb
        wK50nsb6UwxB+raatMvD6AepYNtUe0I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-uhSV1_SOMHqOx89u9YDWEg-1; Wed, 02 Feb 2022 13:30:32 -0500
X-MC-Unique: uhSV1_SOMHqOx89u9YDWEg-1
Received: by mail-wm1-f69.google.com with SMTP id t2-20020a7bc3c2000000b003528fe59cb9so133478wmj.5
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 10:30:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VxSphhwkRTd5EsHLOOcvZP0sk5rc5kz4nLvAGye4isI=;
        b=34Wlev1R45XHLrZl08IBalwGLynRvGPVpM1aQjmaaw5OaP08qEUb0+7N2uTDOc0WSr
         Q0lmnzBYs8055TjUoTrGJkRNqApADo+6u96K21WKm2iK8ahemGiTSjJDLlW1jM+4nHoR
         ajBRsgaduVP9GHjD1nlOITav2/UgOQrVRsW36Zj2SMYiOOJbto0EERoSdJ3mP2xklR4V
         5WDWk942pzfu/amiINTBhYfGW9tuPuyNjSFSDuKJnQG+X1MW8Xbx6F5pOwszNZl3akNY
         B2lFVilWhsu3lRFbRSCuJoRUK7Fk27vPcrGG1GQ8j0gXweBpgHD+3AQtsx/yXLzI2H8m
         UHuA==
X-Gm-Message-State: AOAM5323qjVLlVJ4yC+GVMldjFMaHT4zPXwq2zhHqVwP+OFN02gE8I6J
        u+6WsmdxOYkDuZ+aT/PI86GdsrKqVKTKm0rS4FaIGo8gLUtuW2WyaqJZSErbOEYFsxxHAXFZZ/t
        fO1+UP7Pq8BvFwzt4
X-Received: by 2002:a05:600c:4f84:: with SMTP id n4mr7320064wmq.106.1643826631383;
        Wed, 02 Feb 2022 10:30:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxhD8sTsx9eQnXlioUloGmSteV3B4XUzje0NCeKuYa6y9Qof9hYUm0WZtNSoEMdZVPHwHFBwA==
X-Received: by 2002:a05:600c:4f84:: with SMTP id n4mr7320037wmq.106.1643826631142;
        Wed, 02 Feb 2022 10:30:31 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id o21sm5374675wmh.36.2022.02.02.10.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 10:30:30 -0800 (PST)
Date:   Wed, 2 Feb 2022 19:30:28 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next] selftests: fib offload: use sensible tos values
Message-ID: <5e43b343720360a1c0e4f5947d9e917b26f30fbf.1643826556.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although both iproute2 and the kernel accept 1 and 2 as tos values for
new routes, those are invalid. These values only set ECN bits, which
are ignored during IPv4 fib lookups. Therefore, no packet can actually
match such routes. This selftest therefore only succeeds because it
doesn't verify that the new routes do actually work in practice (it
just checks if the routes are offloaded or not).

It makes more sense to use tos values that don't conflict with ECN.
This way, the selftest won't be affected if we later decide to warn or
even reject invalid tos configurations for new routes.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 .../selftests/net/forwarding/fib_offload_lib.sh      | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/fib_offload_lib.sh b/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
index e134a5f529c9..1b3b46292179 100644
--- a/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
+++ b/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
@@ -99,15 +99,15 @@ fib_ipv4_tos_test()
 	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 0 metric 1024" false
 	check_err $? "Route not in hardware when should"
 
-	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 2 metric 1024
-	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 2 metric 1024" false
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 8 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 8 metric 1024" false
 	check_err $? "Highest TOS route not in hardware when should"
 
 	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 0 metric 1024" true
 	check_err $? "Lowest TOS route still in hardware when should not"
 
-	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 1 metric 1024
-	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 1 metric 1024" true
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 4 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 4 metric 1024" true
 	check_err $? "Middle TOS route in hardware when should not"
 
 	log_test "IPv4 routes with TOS"
@@ -277,11 +277,11 @@ fib_ipv4_replay_tos_test()
 	ip -n $ns link set dev dummy1 up
 
 	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 0
-	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 1
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 4
 
 	devlink -N $ns dev reload $devlink_dev
 
-	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 1" false
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 4" false
 	check_err $? "Highest TOS route not in hardware when should"
 
 	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 0" true
-- 
2.21.3

