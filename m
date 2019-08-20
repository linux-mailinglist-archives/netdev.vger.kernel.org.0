Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860BB96077
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbfHTNlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:41:16 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40579 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730340AbfHTNlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 09:41:12 -0400
Received: by mail-lf1-f68.google.com with SMTP id b17so4151571lff.7
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 06:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qKDCjGrUGEITn9keK4O4wSbQw8s60BA2KTQLoKiFzno=;
        b=NCf+aQCLyOPmICxmwDK6V0Xcg9NK5tJa5uZ4tFopVmo3qpZW6uFwm9JMgevQtG9Qns
         hGHjeb0UzJ7k09qOfUkp4Tql14PTk9unwPbaHn939zgf4VvQG10w3MfUxWZjjoCKatxl
         EPG7eYhW6U7R91XYDZNKBKlrBYpL8eES3GJDUgi5sZdP7nqOjqr3C28o5/77BHkLSvqF
         Fc5OouIJ09I1e4/Qzl0Aw9X/1cvzsuWb4o3+kehRU8k3RCQV2jdLDOmi2XICAYA8O50t
         UC9Rsy6Wxa5j/F4H6Kjn2u4Dj9hkiAVk1c/6idfukQi4nLlZwGfGWAdkhlgEdvk2An7m
         3X9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qKDCjGrUGEITn9keK4O4wSbQw8s60BA2KTQLoKiFzno=;
        b=R3NNHqREpZGU5heCbUHHN29PdfDb4qTP8/cb2hMar6xyO+ONN+zEAnRjDSl5i/UfKr
         HlZeL8W+frRtQzwCDi5g6ToLAGks+8rHCyPt0kXjlkWrQuW8qz/1tMDYrQKfcjl3DkMu
         CjgSBBmfQuElamt89KkxLcBiuyPgQIpnKGVyGXRyWm+lYTpAS2GfGvO9V5353ESx3wmS
         NfpP5MiYe5G5NPxmchdE/yeZx/VP8TLulOOvzfKJgOtFVgjCGIWKFh4OctcEF/Vt26Mz
         L0zyyFj98mDQkepdouWv5ZJ1DV4/Q23M6ZJMlsdOeQ8OZo3NLi0dauVfMIl3OzIzHHNk
         01Fg==
X-Gm-Message-State: APjAAAVHjeZPzkUDMCQSnH3MiriBw0p2zgIN4et5/3tXrZYltbrVGQ4h
        LcNZuSn0G6b1bNX+1NSPXZOWIg==
X-Google-Smtp-Source: APXvYqxttx78GtX0vd5yiKKkdqsdz1pehalivWVgs1kXk1dF/0y8Iyrv4JOoqygWTduXugZhAZBz6w==
X-Received: by 2002:a19:a416:: with SMTP id q22mr15652060lfc.145.1566308470396;
        Tue, 20 Aug 2019 06:41:10 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se. [213.112.60.36])
        by smtp.gmail.com with ESMTPSA id d3sm2867007lfb.92.2019.08.20.06.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 06:41:09 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     davem@davemloft.net, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] selftests: net: add missing NFT_FWD_NETDEV to config
Date:   Tue, 20 Aug 2019 15:41:02 +0200
Message-Id: <20190820134102.25636-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running xfrm_policy.sh we see the following

 # sysctl cannot stat /proc/sys/net/ipv4/conf/eth1/forwarding No such file or directory
 cannot: stat_/proc/sys/net/ipv4/conf/eth1/forwarding #
 # sysctl cannot stat /proc/sys/net/ipv4/conf/veth0/forwarding No such file or directory
 cannot: stat_/proc/sys/net/ipv4/conf/veth0/forwarding #
 # sysctl cannot stat /proc/sys/net/ipv4/conf/eth1/forwarding No such file or directory
 cannot: stat_/proc/sys/net/ipv4/conf/eth1/forwarding #
 # sysctl cannot stat /proc/sys/net/ipv4/conf/veth0/forwarding No such file or directory
 cannot: stat_/proc/sys/net/ipv4/conf/veth0/forwarding #
 # sysctl cannot stat /proc/sys/net/ipv6/conf/eth1/forwarding No such file or directory
 cannot: stat_/proc/sys/net/ipv6/conf/eth1/forwarding #
 # sysctl cannot stat /proc/sys/net/ipv6/conf/veth0/forwarding No such file or directory
 cannot: stat_/proc/sys/net/ipv6/conf/veth0/forwarding #
 # sysctl cannot stat /proc/sys/net/ipv6/conf/eth1/forwarding No such file or directory
 cannot: stat_/proc/sys/net/ipv6/conf/eth1/forwarding #
 # sysctl cannot stat /proc/sys/net/ipv6/conf/veth0/forwarding No such file or directory
 cannot: stat_/proc/sys/net/ipv6/conf/veth0/forwarding #
 # modprobe FATAL Module ip_tables not found in directory /lib/modules/5.3.0-rc5-next-20190820+
 FATAL: Module_ip_tables #
 # iptables v1.6.2 can't initialize iptables table `filter' Table does not exist (do you need to insmod?)
 v1.6.2: can't_initialize #

Rework to enable CONFIG_NF_TABLES_NETDEV and CONFIG_NFT_FWD_NETDEV.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 tools/testing/selftests/net/config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index b8503a8119b0..e30b0ae5d474 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -29,3 +29,5 @@ CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_KALLSYMS=y
+CONFIG_NF_TABLES_NETDEV=y
+CONFIG_NFT_FWD_NETDEV=m
-- 
2.20.1

