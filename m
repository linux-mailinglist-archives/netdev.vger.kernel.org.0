Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E673188A2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhBKKvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhBKKqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:46:42 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF279C06178C
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:32 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s5so6416451edw.8
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/lonPnqVhgTPFxyiJp5qGibeqEG71soSjMN8+ZgR8g4=;
        b=quwE8MQDaoqtoTFwnpifaMKStGTI8uzJFldSG91r42y+eUAvcmgi1waJbAGnhI0YvZ
         dez/5L9lpa2ehI5Rq2OxrIDb6RqFnz0maJ1VAfniFizxqbZEGBGzrGXgOJUx0pFddfY+
         28iCZqDPro2+gHwk/i9sjgEiJ5BkthZSbDrJ/7cNh488LqKtoyciKmVY7TO31aaUFrK3
         vVAdvJFG/iA3sJjnglyFaQO6Zqpn3Eu3zHfe3Ih8tjcpa70Ipwn4p67EanfaoOSXW5Bw
         zjfhGte1PdptlsvzstskfJ9dnsXOa3pyyYbXzb3hhezx3/eJ8KZJk8rKnxshe1aOkSLN
         cHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/lonPnqVhgTPFxyiJp5qGibeqEG71soSjMN8+ZgR8g4=;
        b=UgA0kD1qnj1dmUnf5LeGC4hpmcAODqQo+rNLFnKhyCAsjHVNEzR9xuTgzsqGP6YJ1T
         kU7Fe19hnFcCYJQ+f1w5ff0Kr5t1bIvLxev35T/CLDruCJFztyDiVi1+1h+e4ILH01al
         h5tFgQHnyvHOjfphDE8si/mgFHYLpeORRTEersj/iRerc818j4qT2Ie+q4upxwu8Olg0
         eIJZr8uYZUhANlKQHBPvJV6368StOT68bVtBx4MQPeMxTuqRsxEV3WFfNbVDnxPv/SY/
         lTEIGSRkx8TQekPsp3ck6I5kP02CzGnoCSj3MyCL6KHnl93CEOcD8E67wWjp6qJeZDVX
         1irg==
X-Gm-Message-State: AOAM530QBVU2HY3DHFZkZK7x5S2ojf4FyjWZsu5+5GRp56KISFiToLYQ
        beKrnxXhuRG/839eaF+T2TM=
X-Google-Smtp-Source: ABdhPJzQBEvvnTNYNFDzkTv0UKX/U3K1LJ3JhFf7uBmFXqc9l+ijHHzbUMkjOHn7RMjCMW0Z/hCo0w==
X-Received: by 2002:a50:fa93:: with SMTP id w19mr7849527edr.211.1613040331454;
        Thu, 11 Feb 2021 02:45:31 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l1sm3815458eje.12.2021.02.11.02.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:45:31 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 6/6] man8/bridge.8: be explicit that "flood" is an egress setting
Date:   Thu, 11 Feb 2021 12:45:02 +0200
Message-Id: <20210211104502.2081443-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211104502.2081443-1-olteanv@gmail.com>
References: <20210211104502.2081443-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Talking to varios people, it became apparent that there is a certain
ambiguity in the description of these flags. They refer to egress
flooding, which should perhaps be stated more clearly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/bridge.8 | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index d0bcd708bb61..9d8663bd23cc 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -397,7 +397,8 @@ bridge FDB.
 
 .TP
 .BR "flood on " or " flood off "
-Controls whether a given port will flood unicast traffic for which there is no FDB entry. By default this flag is on.
+Controls whether unicast traffic for which there is no FDB entry will be
+flooded towards this given port. By default this flag is on.
 
 .TP
 .B hwmode
@@ -413,8 +414,8 @@ switch.
 
 .TP
 .BR "mcast_flood on " or " mcast_flood off "
-Controls whether a given port will flood multicast traffic for which
-there is no MDB entry. By default this flag is on.
+Controls whether multicast traffic for which there is no MDB entry will be
+flooded towards this given port. By default this flag is on.
 
 .TP
 .BR "mcast_to_unicast on " or " mcast_to_unicast off "
-- 
2.25.1

