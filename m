Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505883E56B4
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbhHJJWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbhHJJWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:22:23 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8214FC0617B1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:21:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id n12so5344921edx.8
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LGHkd28MWGOCiDBxhGiWFhEVrZHPKuUZlWpdM+gDHPo=;
        b=Os0pBMxreEKRJKeGlgpOk6mhU80oeCPD0k8HXW8LyBX20WrTt35SduZm5PWEMqoFBA
         npOXb5Tno00CL6AJfoTU/RSi998rNHcBE7RfpqJTavKL8md5exUc0lzjKzoYSiU7L3m0
         5HI8rcceizbw3URhKKmIJf0UD78lRfStAqMtdu42n8HHe5bpW5juP6y6xVPgbyxtSz6m
         FJQM9Y6LUs3idH0JgKvgsrPWgyPJ2GsyBCspBMpHtGSYhmBlzEzldZ+Dttt12jVOkhSp
         H1BekTHWhYi6nRD3iK+mP7g77pAmkstaBku11eAYPjTW/jQgkPz+3Bj2C7jqvo0qfHqV
         IGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LGHkd28MWGOCiDBxhGiWFhEVrZHPKuUZlWpdM+gDHPo=;
        b=OhjDvWWzQsBlZwwEoMyFLkwnBVbzr0dLnKC+RR64FNThiAU6iE3kUwUNBC7VHeUol2
         2Nn0mpgWS4uYriuKktKhvnONffKhv9wWycB8+lg+rZaH172Pj0xZcF4HIoiBU67V8GaT
         yN99uHq+PYN3aELvTTLsWm7c1xt+AVHtcBtgOKYf4WvJh7RhhIDzYkPdAq3CyF2qim+6
         zd6HgLNdxE4gRbclQ/rNTEiyJ6isCmz96/Z+qiN6uEjU4JDt7MAOAPFW6TcaSKsV3G/V
         EjGH0X8Ht/1YLFUu7XbxT+u6YdIa/G/z3fEkYxfKhvdQTmXOAc6AxtpBkCRr/KxtEZEi
         KjDQ==
X-Gm-Message-State: AOAM532iOs21H54GEtKRG+cGbkzhwcWlQWCk+fONFNFVs7a31FMh/aga
        tru+ze3QS7Bh5q2x1bDzBwYzGsnxxGmYeKR9
X-Google-Smtp-Source: ABdhPJyZwEHu2SXccuEw6WEvLiE3Lcg/ESLqoCrtYA8Mlk35T8c5TAE3lIoE+USY+f/CdYi1k1J25g==
X-Received: by 2002:a05:6402:50:: with SMTP id f16mr3795604edu.346.1628587307833;
        Tue, 10 Aug 2021 02:21:47 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id jo17sm2680366ejb.40.2021.08.10.02.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 02:21:47 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next] net: bridge: vlan: fix global vlan option range dumping
Date:   Tue, 10 Aug 2021 12:21:39 +0300
Message-Id: <20210810092139.11700-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When global vlan options are equal sequentially we compress them in a
range to save space and reduce processing time. In order to have the
proper range end id we need to update range_end if the options are equal
otherwise we get ranges with the same end vlan id as the start.

Fixes: 743a53d9636a ("net: bridge: vlan: add support for dumping global vlan options")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 8cfd035bbaf9..cbc922681a76 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2019,7 +2019,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 
 		if (dump_global) {
 			if (br_vlan_global_opts_can_enter_range(v, range_end))
-				continue;
+				goto update_end;
 			if (!br_vlan_global_opts_fill(skb, range_start->vid,
 						      range_end->vid,
 						      range_start)) {
@@ -2045,6 +2045,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 
 			range_start = v;
 		}
+update_end:
 		range_end = v;
 	}
 
-- 
2.31.1

