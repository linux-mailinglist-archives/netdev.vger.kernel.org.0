Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84DA04D295A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiCIHSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiCIHSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:18:30 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C032A26EA
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:17:28 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id 3so2123012lfr.7
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=93c5XXpJUTEPP71ABquCsBO3fHl+NABUZRIP4xIAZT4=;
        b=LjbqYv3pE/ZJCBw8xEBgYObQjOhT/Ubo/+YmUtF8iSbH7MmFR/AomgCVdMmMi1Ol2N
         myh/bvJ1FrsjKm3KK7HtTjQgX2dJb4c1FYt5/yUHNtVnf7vl7EZTwkT4IyOixDRFSop9
         YGUrmFJfpeLOqSDpQUNUq+fhvTZb56nxCz8B61gW4U1DOQZZRS76bWD/M3v6zmTGad7H
         ru4uQROc+iP3ImNwRmTAhjUarpC8tEqZAfJDJN6hzWaROT5Q+TEYCD5lVD3jLv7Dz0IK
         M/pMCuqSz3OQYRt1yrExgm/rixBTfG4xxwPb4Oozchk4/p/8mIKVsvC3uJ0sXF6Pcgh8
         PvqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=93c5XXpJUTEPP71ABquCsBO3fHl+NABUZRIP4xIAZT4=;
        b=d7kcdk0JyM3V++8u8FSHEWGBvaSy0/D0wdjUqcZpnfZcGjt16RLesCUisDsrKMNhsy
         izPjAXTFXylLTUYmaL5cp6etMqr02RS5c9V1tJWB92/TSCRubWgDrm7KjHhk54Xxif+D
         Ym33b7+lSzfLu0AMEaQejpHZiExz9R8jDAexyt40gJaAAuqWCkyQbdvpZgGUsSSwLkR9
         53+xodKX8bqyaVTQ6zDWl9UQSFyOPDtFJekaKQIsTdFUGYF5eu3LOHzlo9BV5KfklCpl
         NVfvfGfJ9VG4IAYL7U8b6bcrtIx16XnatVkfs1lvv8GFhL8dxzusmERWfSWpatyWVRSN
         Hlwg==
X-Gm-Message-State: AOAM530/e/hS1r4tkANbJfVIC6SEIHpkMcMCV+wV6Efc4ZlwFcCoeVv1
        h7/PXKv0sDG7zVbPAawKogujYgyLGI/PQA==
X-Google-Smtp-Source: ABdhPJxFC3SgP/5gj9EYO0JBZdpx9cM3gmZTz2GgLnmqYw8Upxwwmp6N9Ok8nQ1NpUsEi/3RdFAbsg==
X-Received: by 2002:a05:6512:3a85:b0:445:c812:cbc2 with SMTP id q5-20020a0565123a8500b00445c812cbc2mr13957496lfu.232.1646810246545;
        Tue, 08 Mar 2022 23:17:26 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id g21-20020ac24d95000000b0044842b21f34sm233730lfe.193.2022.03.08.23.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:17:26 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v2 2/6] man: bridge: document new bcast_flood flag for bridge ports
Date:   Wed,  9 Mar 2022 08:17:12 +0100
Message-Id: <20220309071716.2678952-3-troglobit@gmail.com>
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
 man/man8/bridge.8 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 81ce9e6f..1d03eef1 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -46,6 +46,7 @@ bridge \- show / manipulate bridge addresses and devices
 .BR flood " { " on " | " off " } ] [ "
 .BR hwmode " { " vepa " | " veb " } ] [ "
 .BR mcast_flood " { " on " | " off " } ] [ "
+.BR bcast_flood " { " on " | " off " } ] [ "
 .BR mcast_to_unicast " { " on " | " off " } ] [ "
 .BR neigh_suppress " { " on " | " off " } ] [ "
 .BR vlan_tunnel " { " on " | " off " } ] [ "
@@ -466,6 +467,11 @@ switch.
 Controls whether multicast traffic for which there is no MDB entry will be
 flooded towards this given port. By default this flag is on.
 
+.TP
+.BR "bcast_flood on " or " bcast_flood off "
+Controls flooding of broadcast traffic on the given port.
+By default this flag is on.
+
 .TP
 .BR "mcast_to_unicast on " or " mcast_to_unicast off "
 Controls whether a given port will replicate packets using unicast
-- 
2.25.1

