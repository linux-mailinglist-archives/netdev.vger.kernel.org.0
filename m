Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879D54D3A39
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbiCITZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiCITY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:24:58 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF79433EB4
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:23:41 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id v28so4638212ljv.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=fDEeDlU+kxNN/2eYYetsS0bietC32D2ZAQjV/K3ZsdY=;
        b=WZEgMAYxExO9uwrKAbdeJYU9Z5qn9j7PgiNlPhYYenCtTPB5yNJFMun4gIaIdtRhOr
         s+ZeRywHJ0bHqH0V8c212aq9qfUXEjJo/qQmIr4BrSZNbJXm8ZxfmCRJlMJmAngFYNv4
         P84V+hbzgV6y5+rFJmlJsj5SH+UiJd3nsvoLESsLEr3pLktgaiZolDIIQ8ErxjcZ7/E8
         p6GHBl5RooERctSljbPcuUX3pCKwoTswfP1j7H3Yu8TeoYjMjIvSi62zJqWjJQL1d7Ca
         N0xJEfzDF4wlo3c6M3ORYiySEAuAAVuhlq8aPTNVK0q36Ru2LUUze+UMzj5589iVuEfA
         cZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=fDEeDlU+kxNN/2eYYetsS0bietC32D2ZAQjV/K3ZsdY=;
        b=bYSDJFQxdIFglD/ggHb8aoZ6yif8l1NOwZ44IRK0bru2ngD1tzNn3HiqKHWFr5RfA3
         vGLM0RrIsx5Hyx1tZl66yekXH2vwcB6m3KZtMhRRPcRoATykkvHAoozyrSc8jGIp5uSs
         OwAk9ySHKPg2rZ0dAFcodz0t0Hs4JQjmOhLkB+TcoaQD5P6/bFvzrSVXy5KVn53MC7a3
         SUJAzaajTbM9f6ROkIQZBiaJN1ImASOaHoyrMz420WQww00fuZxSA+ee/QshdkBZtBRo
         /oaKK6YWIfv80hDahmK4thNItKrvWiro4gVVG6TdvMl0CqoqSphph/DFE39l5jMoYsbW
         tI0A==
X-Gm-Message-State: AOAM531qpLOuxrJR0VH3kgaz0JTwYmeWjrer+9WGVjOmflGkEMjAHmCY
        Wj1oBL2HBrpmyWKpiuHbhqwkqGBORiTk+A==
X-Google-Smtp-Source: ABdhPJys4fzRYyfh+qHKk752dCCT1NQ6Ks/9eP7HCuybD3XFIkuneA0fazxmEn6h4/jQKIwGh1TQvw==
X-Received: by 2002:a05:651c:50b:b0:246:8fe5:d18c with SMTP id o11-20020a05651c050b00b002468fe5d18cmr689044ljp.14.1646853819102;
        Wed, 09 Mar 2022 11:23:39 -0800 (PST)
Received: from wbg.labs.westermo.se (h-98-128-229-222.NA.cust.bahnhof.se. [98.128.229.222])
        by smtp.gmail.com with ESMTPSA id f11-20020a19dc4b000000b0044389008f64sm540691lfj.164.2022.03.09.11.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:23:38 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v3 5/7] man: ip-link: document new bcast_flood flag on bridge ports
Date:   Wed,  9 Mar 2022 20:23:14 +0100
Message-Id: <20220309192316.2918792-6-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220309192316.2918792-1-troglobit@gmail.com>
References: <20220309192316.2918792-1-troglobit@gmail.com>
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

The options are not alphabetically sorted, so placing bcast_flood right
before mcast_flood for now.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 man/man8/ip-link.8.in | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 19a0c9ca..c0e7f122 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2364,6 +2364,8 @@ the following additional arguments are supported:
 ] [
 .BR mcast_fast_leave " { " on " | " off "}"
 ] [
+.BR bcast_flood " { " on " | " off " }"
+] [
 .BR mcast_flood " { " on " | " off " }"
 ] [
 .BR mcast_to_unicast " { " on " | " off " }"
@@ -2450,6 +2452,10 @@ queries.
 .B fastleave
 option above.
 
+.BR bcast_flood " { " on " | " off " }"
+- controls flooding of broadcast traffic on the given port. By default
+this flag is on.
+
 .BR mcast_flood " { " on " | " off " }"
 - controls whether a given port will flood multicast traffic for which
   there is no MDB entry.
-- 
2.25.1

