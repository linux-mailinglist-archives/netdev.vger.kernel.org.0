Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D663188A0
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhBKKu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhBKKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:46:33 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64696C061786
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:28 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id f14so9312648ejc.8
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 02:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q0x8reR+y8VY9XBx3PtPCY7fqMs2lXRuHU5JVxtfCBc=;
        b=EpkkpDkbPM6yqlUUEemRBXhP/iGDJX6I9odjD5O/btmAvAR0dPkyhmbe88jWKAUrbT
         c8gMzf3cGuadT5n+je2qi7s81AtH68k+Jb7m179PLNUDT54gJYRsL9U1pO0FGgEhIpKN
         PbrI6aqavJal5yyBd3coIA2QrCHKEtTKTZSQ4pdBN0qjtmXkkpSawNx3pmbjx4BMOWdC
         QAnVfj2C0MaSaWjqKeuHHEMgCIkqL+V9m55MxHXF1sdplXQeZsCIWiB5x9yqv1fasCNl
         Xv2Dt2dzySFQGIX4lF39Om5BtKl85Iax1C4JpM/iFewdCzl/6x3GHuTFiRN82jhr/H4w
         ELzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q0x8reR+y8VY9XBx3PtPCY7fqMs2lXRuHU5JVxtfCBc=;
        b=LxmcBbxhzc/a2RltQQ2OcWY3Yn4YXuSpog77VX5Vz10vX22kCN/uQAqba+kIDzi+ZU
         0FRdzCQAtvGqdEczJD7uxDSVmoj1A6+HBMYlJ1tWv4XGA3lg9QS1/bOS3m2a+6gf5yGx
         dHDyd8YDY125Q6SY8/ZZDtun9TNhs9fKBoOQJ+W5kQSrlOT9haT/KEXmhO/E239/gQLY
         kk4YxmL3IxB02GDhXArBEzrZMGtsMGFnInXkQ935njWQKE9VhHaqIjWRLw5IyIGaJUz3
         mRWRUN20jmhIKvKf0qz1isQ3X2XEgPydDu/gVKjiap//MlvN0fNQa9YwaaLuc2yemucy
         B4iw==
X-Gm-Message-State: AOAM530LxCb4zHRupQbkE+Z10gc+RKEnMYxRioKHuUFIVbY7XWIQZbKc
        n6dJ0aNv6gzt4uUK48z0j8I=
X-Google-Smtp-Source: ABdhPJy/KtVcKkkCpVJ7XhgLn5jkI+Y8yn59maxYjddDP0Gkn6i4JhUZnBz7x5EWZFuw3+pLnrlCtg==
X-Received: by 2002:a17:906:9bf8:: with SMTP id de56mr7796151ejc.425.1613040327152;
        Thu, 11 Feb 2021 02:45:27 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id l1sm3815458eje.12.2021.02.11.02.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:45:26 -0800 (PST)
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
Subject: [PATCH iproute2 2/6] man8/bridge.8: document that "local" is default for "bridge fdb add"
Date:   Thu, 11 Feb 2021 12:44:58 +0200
Message-Id: <20210211104502.2081443-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211104502.2081443-1-olteanv@gmail.com>
References: <20210211104502.2081443-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The bridge does this:

fdb_modify:
	/* Assume permanent */
	if (!(req.ndm.ndm_state&(NUD_PERMANENT|NUD_REACHABLE)))
		req.ndm.ndm_state |= NUD_PERMANENT;

So let's make the user aware of the fact that if they don't want local
entries, they need to specify some other flag like "static".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/bridge.8 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 12c09a56563d..223e65d64757 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -514,7 +514,8 @@ the Ethernet MAC address.
 the interface to which this address is associated.
 
 .B local
-- is a local permanent fdb entry
+- is a local permanent fdb entry. This flag is default unless "static" or
+  "dynamic" are explicitly specified.
 .sp
 
 .B permanent
-- 
2.25.1

