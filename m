Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC4B5049DE
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 00:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbiDQW4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 18:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiDQW4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 18:56:02 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB14E186DE
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 15:53:24 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id g18so16731097wrb.10
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 15:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BtgDA6M+q83530d83u2YAxY+km/ULIVAct7ZtEsGSyU=;
        b=J9FIiVVGZjtr4EPK/c5jdZWDGuCIPmKFaE/G3JSmrw4pwnC6nRdQ+FADEgr4JpujfG
         whjqVTt6sYjgb5KT2OJgU3t1BiC3HAuPhVouroTkl5PoOZI+4Hl/7+faQWNncBpBzumk
         64Qn3/ox7r8gjsK+olwCw0oS0glaqmVlDuM83v/zCdMt0L41qyu2xtUD3QbYQWifQUZN
         2vswsR8E6y4jUClAodnSr2OvBCdnUTk3wIpWmPAkE2roU7UT+ojwQWM+OtlVvXUS6yvR
         Njwlf3H/w7ETKY2y1GczpqzeUc3hPnrNCpCpGdCiL/b0lmo0tAfZ86x2QakvkRICfcpO
         0Oaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BtgDA6M+q83530d83u2YAxY+km/ULIVAct7ZtEsGSyU=;
        b=BJsaRPK1EcqvdrUS/AG1WQ5eGhC8/DJgiXHFNxdyeLHhcSTWuWEVERvdWDMc7VTi53
         /oIASclaz/avfyWB5IO+Jyn4yRcBMgPcQ7xo8/Trs4Sn8ClivcdEFZc/FIgmIDG0aA4m
         AeavtTEczUnVpiJRHos0RRVGJPmPKr8ACmA2BDbYB8x8AQvhsUugJ/vYyHfIY3wwg4H7
         iOwFiRiPajqy6JHD4MQ0JhRlLbqhKdwCLRVn+HdNIp11108H444eCahI/wtbmtg+JZ1Q
         vZUgv2d508Sup/gfaofOPR0E2ZFgDIT/U7ALOWw5SXOgOiDskEHCU7EV6M2oJBm2JSyh
         3awg==
X-Gm-Message-State: AOAM530Qul6f+NDc/X2gzJ+cwlZwVG4i21Ur06L0tmXJrnu8V0dYEMwq
        k81jPFsmV+TixfBAzIjwu5ISX5euNrc=
X-Google-Smtp-Source: ABdhPJylXupl/TEoLZTtmIj3cxvfcdLoZB548j3svivA9ZTpYsqcPhDYpAGDTbWFin7kgaQUZ3TxTw==
X-Received: by 2002:a05:6000:136e:b0:207:a5e9:f816 with SMTP id q14-20020a056000136e00b00207a5e9f816mr6434197wrz.307.1650236003023;
        Sun, 17 Apr 2022 15:53:23 -0700 (PDT)
Received: from localhost.localdomain (82-64-45-45.subs.proxad.net. [82.64.45.45])
        by smtp.googlemail.com with ESMTPSA id e16-20020a05600c2dd000b0038ed449cbdbsm19934947wmh.3.2022.04.17.15.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 15:53:22 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Baligh Gasmi <gasmibal@gmail.com>
Subject: [PATCH] ip/iplink_virt_wifi: add support for virt_wifi
Date:   Mon, 18 Apr 2022 00:53:18 +0200
Message-Id: <20220417225318.18765-1-gasmibal@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for creating virt_wifi devices type.

Syntax:
$ ip link add link eth0 name wlan0 type virt_wifi

Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
---
 ip/Makefile           |  2 +-
 ip/iplink_virt_wifi.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)
 create mode 100644 ip/iplink_virt_wifi.c

diff --git a/ip/Makefile b/ip/Makefile
index 0f14c609..e06a7c84 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -12,7 +12,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
     ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o \
-    iplink_amt.o iplink_batadv.o iplink_gtp.o
+    iplink_amt.o iplink_batadv.o iplink_gtp.o iplink_virt_wifi.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink_virt_wifi.c b/ip/iplink_virt_wifi.c
new file mode 100644
index 00000000..28157d85
--- /dev/null
+++ b/ip/iplink_virt_wifi.c
@@ -0,0 +1,24 @@
+/*
+ * iplink_virt_wifi.c	A fake implementation of cfg80211_ops that can be tacked
+ *                      on to an ethernet net_device to make it appear as a
+ *                      wireless connection.
+ *
+ * Authors:            Baligh Gasmi <gasmibal@gmail.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "utils.h"
+#include "ip_common.h"
+
+static void virt_wifi_print_help(struct link_util *lu,
+		int argc, char **argv, FILE *f)
+{
+	fprintf(f, "Usage: ... virt_wifi \n");
+}
+
+struct link_util virt_wifi_link_util = {
+	.id		= "virt_wifi",
+	.print_help	= virt_wifi_print_help,
+};
-- 
2.25.1

