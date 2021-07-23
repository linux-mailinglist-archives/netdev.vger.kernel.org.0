Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FDA3D3906
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhGWKYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhGWKYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:24:36 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED749C061575;
        Fri, 23 Jul 2021 04:05:08 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id gn11so3240188ejc.0;
        Fri, 23 Jul 2021 04:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZvOmuGDjboR93aCXrzX4U2TF9OvHadby7OHnyO1dGdc=;
        b=cEnVnGpDkavf9X4sTJbxQwJBP2ILnS2Tvy7GZKQrKj5iinFuOKRqgBfM58DMuu9Xhf
         rbcl/ircBWtpt39Rc9adb5ODyEdlgtj+zUqgc0t6kM0PUClEpTWxY3gb4YpjgfpAYsQL
         H7rqdOQk+A+b5al/0wMM0U4NNnVzIq3tHPF+ZM9+zbb1ux0Rwoa+0PZhRmfdaHk41eYH
         +JcZxUyp7pYbcQGSASjldrNmY3XwLHaKDmy3ZKKA5C0KYFS42ztfA8AQceGK6leBf9IT
         1+ZfuqsWXQmkNTxjJ+nyEPwjxFNTIVUsrcJdUfcPg7vvj5jwOJWTzV+uVa28TN7rKQkb
         T4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZvOmuGDjboR93aCXrzX4U2TF9OvHadby7OHnyO1dGdc=;
        b=edWt7S4DAUR7JngbJi8Mt2eOIZ7KTq6MPAYEjkkNTWtKaIIgMc0MWWiIralo8ELwdB
         B5fN0u9DkxUMLIGML+GTYAqA+YC5J88Z7yMlmOzLr4XH4Mgj0DKkgYX05Hf8aHYKzeRo
         Im8CCCqhkVsTiYIyi30qc9f0ixzuOPvWWgH6U1tZ6EdwzCjMv1EfN4N/TpMtm0lTzqov
         q4eWm3OwMzwgWMCD2opK+u1BjtnmaJhm6ATty/fEifF60QjoMJSC0f+s7NsSq/YfeZ/H
         ut92aBzi1HKuRteRJBbpr++lDAMVP+7l1F6EvqtVrLVeLUTHFgVHEzJ6LHifb428ZFbb
         N8EQ==
X-Gm-Message-State: AOAM530gQc4cKx4RRduTpZu8n19KeBnO/b9r0DxXwMpkn0Qa609zU6vy
        cJs1IBtu3sMcyilS52feqQ0=
X-Google-Smtp-Source: ABdhPJyjIiqskyiB67wW/SpOemPa/+6rGZRkAgkCxgURFe0aUmtLXwfNLznYctF9Sgyk8jB4KgnZ4g==
X-Received: by 2002:a17:906:5fc1:: with SMTP id k1mr4001512ejv.360.1627038307340;
        Fri, 23 Jul 2021 04:05:07 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-79-26-254-101.retail.telecomitalia.it. [79.26.254.101])
        by smtp.googlemail.com with ESMTPSA id kj26sm10670958ejc.24.2021.07.23.04.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 04:05:06 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC] dsa: register every port with of_platform
Date:   Fri, 23 Jul 2021 13:05:05 +0200
Message-Id: <20210723110505.9872-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The declaration of a different mac-addr using the nvmem framework is
currently broken. The dsa code uses the generic of_get_mac_address where
the nvmem function requires the device node to be registered in the
of_platform to be found by of_find_device_by_node. Register every port
in the of_platform so they can correctly found and a custom mac-addr can
correctly be declared using a nvmem-cell declared in the dts.

An example of this would be a device that use a specific mac-addr for the
wan port and declare the source of that with a nvmem-cell.
In the current state, nvmem will always fail to find the declared cell
but registering the devicenode with the of_platform doesn't look correct
to me so am I missing something? Is this not supported? (declaring nvmem
cell for the mac-addrs in the port node) In theory it should since
of_get_mac_address supports exactly that.

If I'm not missing something, I see this as the only solution or change
the logic of how the function in of_get_mac_address find the cell.

I hope someone take care of this as currently the function doesn't work
most of the time, if this workaround is not used. Since mtd now actually
supports declaring of nvmem cells, we are starting to adopt this new
implementation and we found this problem.
Also a mediatek drivert suffer of the same problem where it does declare
special mac port without using the of_platform (and so requires manual
registration using the function in this patch) with the compatible 
"mediatek,eth-mac"

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/dsa2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b71e87909f0e..30b1df69ace6 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -14,6 +14,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
+#include <linux/of_platform.h>
 #include <net/devlink.h>
 
 #include "dsa_priv.h"
@@ -392,6 +393,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_USER:
+		of_platform_device_create(dp->dn, NULL, NULL);
 		of_get_mac_address(dp->dn, dp->mac);
 		err = dsa_slave_create(dp);
 		if (err)
-- 
2.31.1

