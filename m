Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2226631889A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhBKKuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhBKKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:46:33 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEE1C06178A
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:30 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id i8so9312124ejc.7
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JPhnCoGgJ5HsL07+WIpZ2VAVa8xMb9ssCIEdiBXb2HM=;
        b=Q4pwV6qLqRpbI+INpT3umC4BLNutFCLtcWuH/68u4Y6nLYM9YFL8IfyorSwT+SsEO5
         LwGCj7B34ZWk0SkMHtENSoBSkjS0PKR2Mz3HHVZjmFAZcM7s3FP4qmS/dQiQK1TlsNcb
         ppWcRDWq0odKURh+7e7wZiMD2ot7koFQLSsWKoVlZssEAfIxmgPD3tHYkNZZzYvYXGW2
         eySOeui32IkelFHAVotULKc2BJC/dk3r2MVkjg+uTP1k0OUIVVmT8M4rZjiEtg9bx1ho
         zlsl6LflwzKf+UY04F+D3F9LGTATBwCCzZRn6BgzS/mpd2zbzA5X/Uu8iCb2TbUfw1gA
         +RHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JPhnCoGgJ5HsL07+WIpZ2VAVa8xMb9ssCIEdiBXb2HM=;
        b=HyWWOFKcQTv27nTBmoNgp6XLLSmAyFJtCuuX5dDhjWKnbcf+AiUFEeNGHczb1QQsnD
         DRTSx8GYBQM/CPTKKhrbfGluBtp8N/GXWBkyU9DFSIWxCaDxrqu2TeN+HQr3cBtQORV2
         ARYO1U/l/TZ1nvPasSieC3U649Wov3rIvjdtaH3u87DsGoa1/iDurLA50d9/QigON6Jx
         W5xA7AY+Op3u8pgIO20lzuAuci/7xx03VmfgfBemWi/kK30+vSLLl/+haAQIA5gQr8U7
         CSh8/6wkIBJLlZA+yf1kos1MGcmUZ2QpVTrXEUOQR06hXaZE7ErXnJC/oS1GpM19hMBQ
         aQCA==
X-Gm-Message-State: AOAM531Z9sL7rdL2KGSsiHZPqL4a8xsjAk26PKc+sSFRR44+bZYxe+x3
        9mto1CeyZs9gk7QudHmSY1e90hHWLc8=
X-Google-Smtp-Source: ABdhPJyoo5FT+XhlLNRxzKBzPmgltJKCFvz+ygKkRp54JHnoBomcSN05Xd2HEJ8O8kxkxkFmQ+zQ8g==
X-Received: by 2002:a17:907:7605:: with SMTP id jx5mr8085554ejc.340.1613040329285;
        Thu, 11 Feb 2021 02:45:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l1sm3815458eje.12.2021.02.11.02.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:45:28 -0800 (PST)
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
Subject: [PATCH iproute2 4/6] man8/bridge.8: fix which one of self/master is default for "bridge fdb"
Date:   Thu, 11 Feb 2021 12:45:00 +0200
Message-Id: <20210211104502.2081443-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211104502.2081443-1-olteanv@gmail.com>
References: <20210211104502.2081443-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The bridge program does:

fdb_modify:
	/* Assume self */
	if (!(req.ndm.ndm_flags&(NTF_SELF|NTF_MASTER)))
		req.ndm.ndm_flags |= NTF_SELF;

which is clearly against the documented behavior. The only thing we can
do, sadly, is update the documentation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/bridge.8 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index b629c52b8341..1dc0aec83f09 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -533,11 +533,12 @@ specified.
 .sp
 
 .B self
-- the address is associated with the port drivers fdb. Usually hardware.
+- the address is associated with the port drivers fdb. Usually hardware
+  (default).
 .sp
 
 .B master
-- the address is associated with master devices fdb. Usually software (default).
+- the address is associated with master devices fdb. Usually software.
 .sp
 
 .B router
-- 
2.25.1

