Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF4459F141
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 04:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiHXCIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 22:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiHXCIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 22:08:15 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8A46EF34;
        Tue, 23 Aug 2022 19:08:15 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y127so12180048pfy.5;
        Tue, 23 Aug 2022 19:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=z0jGwIZNk8TLu9n677sjLmPSpOtIptc1LacJkvrgElA=;
        b=fBcCNRgv34fni4UMSA1TpneApR3uVzSyckorh5xf6DFohi8H50S/2kpkyKuYXgbMiy
         AbIleHIyGaspPzFkv3spYiErD7V2GJlxO9D72IOd0DnRDDSB6RDMGU5Q5FURtGgeAZ+s
         rC5Zpo4wJ+oSnc87BW4P+Qpre5Y1OVJBDWAuFzyG2gPxtnRBtAsaOWoDezswPATqkzj1
         Ah7PbUzSXr57PQJMtvZ5wz6jb6tpttfZ3wdqLqyUauxZGzAK8HpgdfTDegzbFSwZGP9k
         1wBT9B9SU4Y+O2kFQgBZFKsjG5zBK+6QYn458631LpmYmLDJjo52thfGw+dIztdqC447
         xNfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=z0jGwIZNk8TLu9n677sjLmPSpOtIptc1LacJkvrgElA=;
        b=FZ4ipOvB1HO5zV5RTjAZW++Rd4G7/Z+OQvgeOrLnU+7p8qAe/2ySSGTUhBt9CcMhAn
         ajk7oFHw1AzF2c4m3g6x0hLvMlMlRe1mPAEplinBoNNf6BeoHFG9JSnz0nAueoYBLyzH
         gJBGqcMs4BTn9tlLNF0bLNsrkwEmlh0bdJ9c08erWroGVSMHalnqJuwVyWZza/xHVIRy
         3cvaO7e6j+as2oZ95zBM2qqBcUTsb5GLjdV4rVF2yC1N6qZpxiemn7ETemSFL678/MOD
         ic00T1Mwg2RdMzZbvvRd9a2kZ0hwWCXNp+q3W1CJ42IQAAcGafSNbng5UeMv8opAXJpd
         DLnA==
X-Gm-Message-State: ACgBeo0q6yikDNFMyh6sgNZSpGHqTS8WVphUEcO5Pc3Fl2I0QkTYFVPA
        HtrMfBkx9BCgrXESr85ttbA=
X-Google-Smtp-Source: AA6agR7dvo/rFRCR8xDHJp1GWGmQqmad561FXhHbtCeUj/Ik/nBjju8Y/tJE6H6TXizgbqK+OSH55A==
X-Received: by 2002:a63:bd49:0:b0:41b:8a07:a6ed with SMTP id d9-20020a63bd49000000b0041b8a07a6edmr22133311pgp.124.1661306894838;
        Tue, 23 Aug 2022 19:08:14 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903120700b0016d692ff95esm11380107plh.133.2022.08.23.19.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 19:08:14 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>
Subject: [PATCH v2 3/3] ipv4: add documentation of two sysctls about icmp
Date:   Wed, 24 Aug 2022 02:08:08 +0000
Message-Id: <20220824020808.213837-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220824020051.213658-1-xu.xin16@zte.com.cn>
References: <20220824020051.213658-1-xu.xin16@zte.com.cn>
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

