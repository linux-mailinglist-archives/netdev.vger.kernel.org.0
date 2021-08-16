Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCE63ED1B0
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhHPKMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbhHPKMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 06:12:18 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979E9C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:11:47 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id by4so25675224edb.0
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VeAxzN5DXkah2WW1j0/kmj2z9yubcpseK6WCofF+3Js=;
        b=g6mPVuDPBag/AAVcsHK14Ce7QpDJMjTOWoV7FJ+tziCL01WHrAJoG64Amw0YaNQKjq
         dXKY/8LiqwzOTfi4lof4HfzWpf+SDvmTbNMrVH12wWrpUtNhM/k6r0Am3l7ne20e3wmF
         m3sFXIf6dOenFk61y4rjDslXOUMbv3Abjn7Y7NUNXoztX9F4UzW52vnxfEMGLG1ZbqAP
         Zd9JNo7V7BO+lf8JMYfaxaF6zSuVH3IXr3KZJ3xwyrpXuXhKeNuC8OWRqxRx55FSyd30
         WW3+/4aR8J3FozZYFYCSnWZ+X7lEpnsAJvcf7wb2ZnHTXQ9tp0Z+H2AwDQQ0P8qlaEmj
         enGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VeAxzN5DXkah2WW1j0/kmj2z9yubcpseK6WCofF+3Js=;
        b=ud3NOnCc1/2pJOiKuTXFI1i62izXBY6B805oUCF0TX/7RjEFRiylQzXxYQ4tstNZa8
         K7SC5wVLzKF0j8pSibzpffpbWF4uT+GlaPx+9JMTOOrW8ZvVuiecvN6nU6Ap0INnv0Xe
         Q3AThAG8Wmm4VuegZ54xdEBve9N/vYmv/GUH+SdN2tZmciqfGm801lpkRMrYC8AT4R20
         ma/DfDZyDG0StFrdqA6V4IXZYQPRTTd6OGrJ4i+k1xNSI5CWQTcMWVlFGTrfrKzlnzdC
         qX/QBvVTAlZ8+9T9VugmzlLXGvf1lVVN9vRVtIGChQmUYRHmTE2VEFH1i9AsHd1mJc7/
         /NEw==
X-Gm-Message-State: AOAM530QrAvTFNFq0jvpyLHRruUQxnp5A0LsicSskP5RmAPb+dMW5zk/
        WUze6c/M0U2CfcnoqC0A0FjITeLamP8LnyYr
X-Google-Smtp-Source: ABdhPJyljAumV2r7rnIRE8L73ezYdjuO2ulEuxqg8XGlrm65lyb/CYkORdq2I8Nan30OG0F6Sv1WgQ==
X-Received: by 2002:a05:6402:89a:: with SMTP id e26mr19146030edy.196.1629108705507;
        Mon, 16 Aug 2021 03:11:45 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a60sm4673779edf.59.2021.08.16.03.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 03:11:45 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next 2/3] net: bridge: mcast: drop sizeof for nest attribute's zero size
Date:   Mon, 16 Aug 2021 13:11:33 +0300
Message-Id: <20210816101134.577413-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816101134.577413-1-razor@blackwall.org>
References: <20210816101134.577413-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

This was a dumb error I made instead of writing nla_total_size(0)
for a nest attribute, I wrote nla_total_size(sizeof(0)).

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 606433fe3e11 ("net: bridge: mcast: dump ipv4 querier state")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9bdf12635871..76992ddac7e0 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2928,7 +2928,7 @@ __br_multicast_get_querier_port(struct net_bridge *br,
 
 size_t br_multicast_querier_state_size(void)
 {
-	return nla_total_size(sizeof(0)) +      /* nest attribute */
+	return nla_total_size(0) +		/* nest attribute */
 	       nla_total_size(sizeof(__be32)) + /* BRIDGE_QUERIER_IP_ADDRESS */
 	       nla_total_size(sizeof(int)) +    /* BRIDGE_QUERIER_IP_PORT */
 	       nla_total_size_64bit(sizeof(u64)); /* BRIDGE_QUERIER_IP_OTHER_TIMER */
-- 
2.31.1

