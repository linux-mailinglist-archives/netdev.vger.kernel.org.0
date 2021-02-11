Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E4E31889E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhBKKuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhBKKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:46:33 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7279CC061788
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:29 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id y9so9264411ejp.10
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XMRInG8YduALFgGWZAULvLD9JmzWOSKsqMn1CgAioHo=;
        b=alXI3bTKlqQHRWHWTThap8QF2iUxW7hsjnUbBL0QFKyN12T6akfuuX53VOSfbPJlpf
         d2AP1/TrRMN7P5pzPi0GIDOHkH/F3a0uPcYsYaz3cZt0bFFS3mO5pEFvt5oNcSb4ClPC
         kDKDiritpJDu+mmaB6Yfqa9csxeyi+VAE5cN1sZv8jPOtm+hLkEND/f2Hqc1sZpYGfBl
         ytS0FXUbx5iaja9U9WwLlPhzy4MzIhMiCcKrYG4jA8UXgM75coTFkcQcXUeAwbvQ0MPg
         SfAFdDrlyKjobhzSAlg9UciCZkOrTP73KU3VbKl8bLiuqRP1uelgrxnXACVe5hJ1PixZ
         JxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XMRInG8YduALFgGWZAULvLD9JmzWOSKsqMn1CgAioHo=;
        b=gUlDjwCXq6b1+50rceroYEirxfipVgL0sv2DbClMMk+RSeGXgAGFNupZRCJMJIf62w
         HeM30DD7W1cZwAUDG2FhoKDD55Yr7p3Gqb9938ehoQ9BS6pjomI4aLOXytAxWLW76ieC
         GMw0+ZqJ87PZb7RX3ZRvQwGk+q08iwb3B8BE5lBHfOD5kiI7tmC3uHkAlg7ouL5m3TDa
         TRDd7110iIT9cRQahs18sB47eaOBY2imZXNiCPubKf5sxVpIxvdJ+wfN258ZJnrEfuCC
         3Bsyrr/tNlct6looEhKSuCuBrzgVz+/j21HLxjZuthpZU37XgqCufTwVnF6idCb9gWeL
         cw1Q==
X-Gm-Message-State: AOAM53065EdwLLtnGZSpk6ki3X89KoHBoT288+H4cWEB2/A/8ENcsWe9
        I5w8EQjRoS1VItGwQsIlUE8=
X-Google-Smtp-Source: ABdhPJyPtypliSVhvaLkOrdFODgX0GpLywhwEEYHEl9zDLIhYQFam2bxWm+ufCmyW9U7YmvyPuCBgQ==
X-Received: by 2002:a17:906:3883:: with SMTP id q3mr7820509ejd.160.1613040328222;
        Thu, 11 Feb 2021 02:45:28 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l1sm3815458eje.12.2021.02.11.02.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:45:27 -0800 (PST)
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
Subject: [PATCH iproute2 3/6] man8/bridge.8: explain what a local FDB entry is
Date:   Thu, 11 Feb 2021 12:44:59 +0200
Message-Id: <20210211104502.2081443-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211104502.2081443-1-olteanv@gmail.com>
References: <20210211104502.2081443-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Explaining the "local" flag by saying that it is "a local permanent fdb
entry" is not very helpful, be more specific.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/bridge.8 | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 223e65d64757..b629c52b8341 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -514,8 +514,10 @@ the Ethernet MAC address.
 the interface to which this address is associated.
 
 .B local
-- is a local permanent fdb entry. This flag is default unless "static" or
-  "dynamic" are explicitly specified.
+- is a local permanent fdb entry, which means that the bridge will not forward
+frames with this destination MAC address and VLAN ID, but terminate them
+locally. This flag is default unless "static" or "dynamic" are explicitly
+specified.
 .sp
 
 .B permanent
-- 
2.25.1

