Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD22318892
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhBKKsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhBKKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:46:33 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937C0C06178B
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:31 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id t5so6402317eds.12
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ffIX1Q9gvmYguUHbVNgZRrb4xzzJo83lCHTV+IvAs+s=;
        b=UBUJvi2zi6Qb/FOFKlSmYdKoWGMXf9tN07BdchV1gH6gUHJCtHkXeZe6RMxJcebI3f
         IXi7UXRSCJCnHsaxmrFyYqeU1WRJdWisXneZowDcCLZxkNjVaa3z1Qi57aH4YBd9eNCk
         2b+s37zWuBFxBWIzGWJEv9jqvXPQq1vK3abiBDXig+4urvqmeVlu8Ik4Jy9/RWzGdaqY
         +7OApFZF1ZeTT+P9z3Zfgtf4zcUO5XdI1hzxYfNRFBt0qwOTHAWO23CB+u0eee/tPR8h
         SHEjZyt680NK8nYhHjU9PkC9fLLfu0PuoyXQDk6nHQpgURwn3kWsJ7ms8IM2IT0e4tnN
         KfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ffIX1Q9gvmYguUHbVNgZRrb4xzzJo83lCHTV+IvAs+s=;
        b=EBfvqYd1i14zV4Fe7VAUUcit9ekGlpDuoV7I8JFM3sDwx2audQIkqgEY4LUAip06b1
         Wb+GpBwmWMFQ/arZu3KlmbaYipSEAurRKGw59cRg3N7hE0tbOT7POoad5pPwFgLAIqbq
         EzUAMZ60HUQ4GT3bgCqfvtf/+5jMAwjrwPC/6dFru99l9p2+vlkN2410JriUC3JKd6va
         I/e6/ntostcDkKaf0zqdfWkjs0fYrdyChVtg/XYt9BjeaO+Bybeyy+aIQcbHG6NEOXXC
         hR6JHOaFsJOc90+9gWKh1Js4UIhIWd9pC3vEUgGQxRAVMm7eKwXf2lbHRUnOWGm/N1Re
         HIIg==
X-Gm-Message-State: AOAM533AFnwxana1zfuCcPZpfImbn4eFlqW4dkCr6eIXczVTrMdoBjrG
        adIYO7GFYkhFxDggibMvxdE=
X-Google-Smtp-Source: ABdhPJwad9D3MEcnPdmzoE8K+2kSqtpMy20cYcoHR69S3YNpDeTf5SsCDIKgWU/HvONGTK6A/1L+0Q==
X-Received: by 2002:a05:6402:21c3:: with SMTP id bi3mr6102236edb.68.1613040330321;
        Thu, 11 Feb 2021 02:45:30 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l1sm3815458eje.12.2021.02.11.02.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:45:30 -0800 (PST)
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
Subject: [PATCH iproute2 5/6] man8/bridge.8: explain self vs master for "bridge fdb add"
Date:   Thu, 11 Feb 2021 12:45:01 +0200
Message-Id: <20210211104502.2081443-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211104502.2081443-1-olteanv@gmail.com>
References: <20210211104502.2081443-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The "usually hardware" and "usually software" distinctions make no
sense, try to clarify what these do based on the actual kernel behavior.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/bridge.8 | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 1dc0aec83f09..d0bcd708bb61 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -533,12 +533,21 @@ specified.
 .sp
 
 .B self
-- the address is associated with the port drivers fdb. Usually hardware
-  (default).
+- the operation is fulfilled directly by the driver for the specified network
+device. If the network device belongs to a master like a bridge, then the
+bridge is bypassed and not notified of this operation (and if the device does
+notify the bridge, it is driver-specific behavior and not mandated by this
+flag, check the driver for more details). The "bridge fdb add" command can also
+be used on the bridge device itself, and in this case, the added fdb entries
+will be locally terminated (not forwarded). In the latter case, the "self" flag
+is mandatory. The flag is set by default if "master" is not specified.
 .sp
 
 .B master
-- the address is associated with master devices fdb. Usually software.
+- if the specified network device is a port that belongs to a master device
+such as a bridge, the operation is fulfilled by the master device's driver,
+which may in turn notify the port driver too of the address. If the specified
+device is a master itself, such as a bridge, this flag is invalid.
 .sp
 
 .B router
-- 
2.25.1

