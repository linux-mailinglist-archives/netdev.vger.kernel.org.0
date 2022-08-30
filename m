Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1055A5F0C
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiH3JR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiH3JR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:17:27 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62A2D2E95;
        Tue, 30 Aug 2022 02:17:26 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v5so4301014plo.9;
        Tue, 30 Aug 2022 02:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=z0jGwIZNk8TLu9n677sjLmPSpOtIptc1LacJkvrgElA=;
        b=NzFNslmJiCMzU+pz9gBs301wZcRFS8yhsdzOifJK49tFI09UD3OV7aoZDED0pfkrxS
         qOfhAKU1lE/V9jprDsAUId+NZyOiYAjoq2RBV7UziKE+9lTK9jcB3qx7ntwMnXFCe+Cq
         5xzzTKD2YCj4UYltCHOCdH6MgJUhs9nFeJOGmj/gpkOCVBPgZtulvEWiyOlonX4R8KzT
         b+VmaUUKPIGjt4gkcQcZHePhT1MeY34UTAjTX3wmOqLeSr8poM7yWsFBTeVVE5DqdRSL
         LmBj0qTo1XGP1xHIECmp3cjBe4imLRWV/ql0KBrmc1fP5ekt0xOpK8oOJKVpQGarPb2z
         vOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=z0jGwIZNk8TLu9n677sjLmPSpOtIptc1LacJkvrgElA=;
        b=Q0qK2nHp69Mc87Kh2kDiGzPz4suxKn1H1K+5rFRt6nuHxnipXi5nXIS/OXmQm1/Dvo
         3vSV9S37vW3CxV8X38iDl0BZW7BM3WSf1RTCv7xaNulO7qEQVBdJYeaEc/m0nFbLmM8j
         +ulQeAq5Z0+aJCWL+2uoAq1p+SyFi069pB0GKd6CdVN5V0CsLJnoUW3wrbKTxry4tbLx
         m98q/Eg8zC9Hvtd1VGwKnXWOQIdzen7ir3l0+BGUgsZrQGdiBh/BXenZ97qrJdE6x8es
         gObFtrzvurrT4almQRUuVXeIzpAqTdEPQUwDiPQPlrsEveb4ZBj4BMHDcn2aGafD5m6Y
         yvlQ==
X-Gm-Message-State: ACgBeo3bq1TTDpgzgAHGONUuWU8XKz9GiwWAuk4K6rZnVkeomEcF2kCw
        s4u1z4U8d8K0d7wwwEm8bkk=
X-Google-Smtp-Source: AA6agR59tLWXuj9EZY0lhnw5QOQ7LD0VviMav4BPIhsAEorDIWJNaBTAawU6xsxliwm/F0XPT4m8zg==
X-Received: by 2002:a17:902:ebc9:b0:172:951d:fc9c with SMTP id p9-20020a170902ebc900b00172951dfc9cmr20474898plg.97.1661851046339;
        Tue, 30 Aug 2022 02:17:26 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i11-20020a170902c94b00b0016dc6243bb2sm9177749pla.143.2022.08.30.02.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:17:26 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn, Yunkai Zhang <zhang.yunkai@zte.com.cn>
Subject: [PATCH v3 3/3] ipv4: add documentation of two sysctls about icmp
Date:   Tue, 30 Aug 2022 09:17:18 +0000
Message-Id: <20220830091718.286452-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220830091453.286285-1-xu.xin16@zte.com.cn>
References: <20220830091453.286285-1-xu.xin16@zte.com.cn>
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

From: xu xin <xu.xin16@zte.com.cn>

Add the descriptions of the sysctls of error_cost and error_burst in
Documentation/networking/ip-sysctl.rst.

Signed-off-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
Reviewed-by: Yunkai Zhang (CGEL ZTE) <zhang.yunkai@zte.com.cn>
---
 Documentation/networking/ip-sysctl.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 56cd4ea059b2..c113a34a4115 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -156,6 +156,23 @@ route/max_size - INTEGER
 	From linux kernel 3.6 onwards, this is deprecated for ipv4
 	as route cache is no longer used.
 
+route/error_cost - INTEGER
+	The minimum time interval between two consecutive ICMP-DEST-
+	UNREACHABLE packets allowed sent to the same peer in the stable
+	period. Basically, The higher its value is, the lower the general
+	frequency of sending ICMP DEST-UNREACHABLE packets.
+
+	Default: HZ (one second)
+
+route/error_burst - INTEGER
+	Together with error_cost, it controls the max number of burstly
+	sent ICMP DEST-UNREACHABLE packets after a long calm time (no
+	sending ICMP DEST-UNREACHABLE). Basically, the higher the rate
+	of error_burst over error_cost is, the more allowed burstly sent
+	ICMP DEST-UNREACHABLE packets after a long calm time.
+
+	Default: 5 * HZ
+
 neigh/default/gc_thresh1 - INTEGER
 	Minimum number of entries to keep.  Garbage collector will not
 	purge entries if there are fewer than this number.
-- 
2.25.1

