Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268764D295C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiCIHSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiCIHSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:18:34 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633C222B
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:17:30 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id r7so2135903lfc.4
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=KjIo3PbkeZ9aLzeOzKt1E8cGnOIoy/DeCR6iBYfxLY8=;
        b=FSiKIgcby7l0KLtCrll7pneDDuUlRZRSW/oEpm46Y9khdj9MHU3d2r37r400wBY6T5
         KhneO4LDRkui+wXd5+MoW0x8/QGzXyEyUEufxLrhd5N4pra4RtNH9BXb7X7Cm8q5PSmC
         4aoMwHQlI8GmegztIbYa02y3OrFATIAjcFpA3lOgSfgnKZsKt60KsIYCK7D82JaelSv3
         7dbnPmiwMKtlig9FySVuhw8kBq6YPByrPq/VZrta+zzdLaIH7JEHXQ5yRgWEIU/6lwdT
         2lDsR9KuTeqRmdPIQw8VuQ/STvh+P+QkO4sxyYRd0PG9ICDhJWNTArRoWIq5EYjBQQyP
         cncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=KjIo3PbkeZ9aLzeOzKt1E8cGnOIoy/DeCR6iBYfxLY8=;
        b=h2zHY1KvovL4pAEdXAQOezAqN4ignorD4FY4sR5A4nebmb4mqXmKlD20KlnN3YnhiJ
         3+Hazk5mlZKODAZKb+UEF2WYVF9OWZ/gMg6lVwza1iAboIrLkkij1SfF6ag+MqdfO+dT
         ypFABCXw8oj/0q5UzU3tPaLR2p1y5Qv7qIEgWUX3MF3Zk9s8N9bPKY3SLCn/NcTiONIB
         4eEMgdh1ouRW+WooElV1uguPYNBom3dRW6qJ/sekPciR3UyqZ3nNcTqdju2G93Xg/QGh
         jmLhAyxJ5OypWYs+nyYYtjbBJPwHlosmJEQ2iVoyMKBq7A7D/023fOsM5/5KGYLEaQcd
         FXZA==
X-Gm-Message-State: AOAM531PhO3ob2rJ/bg+KR1XySyL8uBT9SueWjiBTGOp0meAKZuyEfz+
        3/JqQcBHwzba243xKQSwSUl7is8txFIXmg==
X-Google-Smtp-Source: ABdhPJxSF0sdp8Xdf06bBg2xNUOxfAegnmlAk7dvT0q/PSaBMl+yDsil1jQDwfLZso/xA1KvmccKbA==
X-Received: by 2002:ac2:44a4:0:b0:445:8fc5:a12a with SMTP id c4-20020ac244a4000000b004458fc5a12amr13319021lfm.27.1646810248946;
        Tue, 08 Mar 2022 23:17:28 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id g21-20020ac24d95000000b0044842b21f34sm233730lfe.193.2022.03.08.23.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:17:28 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v2 4/6] man: ip-link: document new bcast_flood flag on bridge ports
Date:   Wed,  9 Mar 2022 08:17:14 +0100
Message-Id: <20220309071716.2678952-5-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309071716.2678952-1-troglobit@gmail.com>
References: <20220309071716.2678952-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 man/man8/ip-link.8.in | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 19a0c9ca..6dd18f7b 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2366,6 +2366,8 @@ the following additional arguments are supported:
 ] [
 .BR mcast_flood " { " on " | " off " }"
 ] [
+.BR bcast_flood " { " on " | " off " }"
+] [
 .BR mcast_to_unicast " { " on " | " off " }"
 ] [
 .BR group_fwd_mask " MASK"
@@ -2454,6 +2456,10 @@ option above.
 - controls whether a given port will flood multicast traffic for which
   there is no MDB entry.
 
+.BR bcast_flood " { " on " | " off " }"
+- controls flooding of broadcast traffic on the given port. By default
+this flag is on.
+
 .BR mcast_to_unicast " { " on " | " off " }"
 - controls whether a given port will replicate packets using unicast
   instead of multicast. By default this flag is off.
-- 
2.25.1

