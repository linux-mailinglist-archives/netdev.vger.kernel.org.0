Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247246151C9
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 19:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiKASt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 14:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKASt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 14:49:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76C02643
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 11:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667328501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7ie1yf5gnqJej0Jdp4B4ph0EWrk81soUHngI0zbagow=;
        b=HRdbBLJf0US7Vvtq8axz0+kKyFav6iQToYvc094w6jtrcsQk/Xrtv8Hwd2XqM9+nsj5yS7
        Nxhz2cH1cR4i6Mxv90clZVbRobY/rThL3hjdf28UZO8TSCaqK0hm/e3IVeLo+njllLRR5o
        RyAkJnN2ojuvFHfjEyOkvQOBk5y4KLQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-135-_-lZNaaBMH23JPsFtZNQIQ-1; Tue, 01 Nov 2022 14:48:20 -0400
X-MC-Unique: _-lZNaaBMH23JPsFtZNQIQ-1
Received: by mail-qt1-f200.google.com with SMTP id ff5-20020a05622a4d8500b003a526107477so4429799qtb.9
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 11:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ie1yf5gnqJej0Jdp4B4ph0EWrk81soUHngI0zbagow=;
        b=6+YsgZhjDMe9p/7V/Hzkusq6OoMJZgtVV1HcuhSTXvVhsEwAR65hai5zbr8wAgNPJh
         kZuem5QboRjVrD7tlUWA17ELzXytxEkD5FuTx2eTUHw/G7Ut2FFdoyTWYpWrRiWViGEg
         eA3byYb2tjGgCA1F3eJa3rC+kIv+6Cbd8II+pW56EDJk47IP4wo8fYPdLZi4MrVMbu3K
         mBXJoJ4+Ws0jVKdniO71+2F9b9GDNPgkMSjOWkpkWkkX6Ut7rXNrbki4UbOc/okyHqFy
         HzNGm2Blf/gFp5P3ZuDukQ4R3QBH8h5jjcki+8MX/lAdlrmCVC2n2hPNjVs71D5qnnVk
         WJow==
X-Gm-Message-State: ACrzQf01D+CPfM+SO1t8ZNm96SLgYUG2J3cFmcESOdxa8XOBgl7l0xMz
        1N34k1Z8RmA61Zy56BirzbAYHVaQPEjDhTZ2o43pi6Q0rV8xfWe1NBkia2PatfZWh5lxByes59N
        Xw7i3Hq25aLRzgtPP
X-Received: by 2002:a05:6214:c2d:b0:4bb:fce3:bb30 with SMTP id a13-20020a0562140c2d00b004bbfce3bb30mr8927603qvd.16.1667328499892;
        Tue, 01 Nov 2022 11:48:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM67UmKZbA62ABhdvT+lYMvZ1rpVwKDjdkJ6Oa1NJ5uofq+84se+nFHREf5K9o/MZk0H6WmkqA==
X-Received: by 2002:a05:6214:c2d:b0:4bb:fce3:bb30 with SMTP id a13-20020a0562140c2d00b004bbfce3bb30mr8927586qvd.16.1667328499652;
        Tue, 01 Nov 2022 11:48:19 -0700 (PDT)
Received: from fedora.redhat.com (modemcable149.19-202-24.mc.videotron.ca. [24.202.19.149])
        by smtp.gmail.com with ESMTPSA id fb24-20020a05622a481800b003a51d65b8basm4579638qtb.36.2022.11.01.11.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 11:48:18 -0700 (PDT)
From:   Adrien Thierry <athierry@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Adrien Thierry <athierry@redhat.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH] selftests/net: give more time to udpgro bg processes to complete startup
Date:   Tue,  1 Nov 2022 14:48:08 -0400
Message-Id: <20221101184809.50013-1-athierry@redhat.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some conditions, background processes in udpgro don't have enough
time to set up the sockets. When foreground processes start, this
results in the test failing with "./udpgso_bench_tx: sendmsg: Connection
refused". For instance, this happens from time to time on a Qualcomm
SA8540P SoC running CentOS Stream 9.

To fix this, increase the time given to background processes to
complete the startup before foreground processes start.

Signed-off-by: Adrien Thierry <athierry@redhat.com>
---
This is a continuation of the hack that's present in those tests. Other
ideas are welcome to fix this in a more permanent way.

 tools/testing/selftests/net/udpgro.sh         | 4 ++--
 tools/testing/selftests/net/udpgro_bench.sh   | 2 +-
 tools/testing/selftests/net/udpgro_frglist.sh | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index ebbd0b282432..6a443ca3cd3a 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -50,7 +50,7 @@ run_one() {
 		echo "failed" &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 	ret=$?
 	wait $(jobs -p)
@@ -117,7 +117,7 @@ run_one_2sock() {
 		echo "failed" &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args} -p 12345
 	sleep 0.1
 	# first UDP GSO socket should be closed at this point
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index fad2d1a71cac..8a1109a545db 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -39,7 +39,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 }
 
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index 832c738cc3c2..7fe85ba51075 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -44,7 +44,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 }
 
-- 
2.38.1

