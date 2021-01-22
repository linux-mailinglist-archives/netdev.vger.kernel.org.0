Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AC82FFF85
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbhAVJtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbhAVJrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:47:51 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84C9C06121C
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:55 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id a9so4437029wrt.5
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o5kBOYeQFHBf+oE2T+wnRwjh+YQp8rBeQBWMpv/8gTU=;
        b=JRh9RzZ4o2opZIjqkzk/MkXg6rEbotnmE6AJ+xuIpEFz0Q5JkTupwJAEIse/bWUzQx
         TGnsL+KX4leQvsLVB+gjIB+Zg56R0Rv/EaPFOnHcl8aAwkLDgXR+xUolIAXqithv+ak8
         wJhtBeV9vv3U+KoERw52VTmfAIjPaSGqgW+F4Xg14FVkZGJI8dt+mKDEz2AXHV3XGyFQ
         PikPGB+E5uwxC5PaNRg2psrMervKQfalZ62jNUEoaBKAL90T1kfy4C0qJ25WTfEz/Uho
         obxd78idFcWDU3Em0FUcruSTO7+M/zpiDnWU31DMIvofrRMvE43NZ/aVp/gQBdxLxcU2
         RKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o5kBOYeQFHBf+oE2T+wnRwjh+YQp8rBeQBWMpv/8gTU=;
        b=SeVnSCmcBvyDY70T0/ss8MyyPsN1FRfi4DkVGEDF7DVkE9RpLgpQrebNOLZjFU07pF
         WAYCcE4nwuBFCIObNHXX+HiPFxO5yiZQkLcB+vAmp07ozYgSO1ChI1SyHWNWjxPgsa1M
         D59749XCar3UYEq5TjTPq/FEzAYb/AksTLMYdTgsNgSuOmRdg3v5oRWPVpVkR+Jd6k1C
         K9H1Fy4LLiXXIkAhO1waYc0JkTiHqBfRfJ5p2L3tkteL9dZG/fJ6nb2xJ1i6oLZkYe51
         c2IOpOQpLb3pHHAA3yuEXcMxoRaHpQFKdgpmUI7Ign+vkyYbfMstSldfkAdVY8xCRIp9
         lhzA==
X-Gm-Message-State: AOAM532f2jzoRGgVS8NCa3hVpihy9tT9rDZ5lYYQTHH+fzPsUcsqJiwY
        rkartO5nQmjZkyvowX61pnleYPaQ9JASbvtuo0c=
X-Google-Smtp-Source: ABdhPJzrFmJsJPrkOWwoBjZ/4kFtBO4GS8YoS4lU8lezle9lQvRpoqbWeraYyEtXtaL4YIKldbhwvw==
X-Received: by 2002:a5d:640c:: with SMTP id z12mr3591291wru.342.1611308814320;
        Fri, 22 Jan 2021 01:46:54 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id a27sm11778515wrc.94.2021.01.22.01.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:46:53 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 04/10] devlink: append split port number to the port name
Date:   Fri, 22 Jan 2021 10:46:42 +0100
Message-Id: <20210122094648.1631078-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of doing sprintf twice in case the port is split or not, append
the split port suffix in case the port is split.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1725820dd045..80fcfbb27024 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8673,12 +8673,10 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
-		if (!attrs->split)
-			n = snprintf(name, len, "p%u", attrs->phys.port_number);
-		else
-			n = snprintf(name, len, "p%us%u",
-				     attrs->phys.port_number,
-				     attrs->phys.split_subport_number);
+		n = snprintf(name, len, "p%u", attrs->phys.port_number);
+		if (attrs->split)
+			n += snprintf(name + n, len - n, "s%u",
+				      attrs->phys.split_subport_number);
 		break;
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
-- 
2.26.2

