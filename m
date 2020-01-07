Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 700E313303D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 21:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgAGUEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 15:04:01 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:42257 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgAGUEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 15:04:01 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MJnnV-1j8w0N2oEj-00K6Dy; Tue, 07 Jan 2020 21:03:50 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Arvid Brodin <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>,
        Taehee Yoo <ap420073@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Murali Karicheri <m-karicheri2@ti.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] hsr: fix dummy hsr_debugfs_rename() declaration
Date:   Tue,  7 Jan 2020 21:03:39 +0100
Message-Id: <20200107200347.3374445-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:CUXJi1Tq3W0V+VbCAFGkPpkT/YOTIHx0LzCaN38WI+u8M7LI2id
 E+5NfhgOFFX8KSoOSK2y6xcv34UdanrEXES5kNgmtPJqrT4Ou41rjH/lzar+4MYVwj+cEz6
 fLnp636IrOKuWkOebAaigXFCe6IH6YX+Bqi0u5+dcfbP18Q6Aw9JwHSe1l0B2E6sIG8/YgQ
 +2Fq8uXferZs6dLQvnQaw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZVUXRmvyAaI=:2nn+y6XsGq2+TZSOwWUUL1
 M9QiP8eppGTbZoaFZXpIQdg8LGjAnLoZEVgjqaPkmma+zaVCFr8PqlPJZH3Aiclx5dM+xDVQT
 cokm4Mw/reJNstn0TyJHvOzUUlZlVu0UjwoNlQjqqYPSs5igeWjU9iBMS/BkAlWEvlNTTdhc1
 B0lgJcneaqkxYDXt1n03ICR82x3/YToB51nUgNEs+e4PDCuV5wR6wlkqfd2BaEiQybojz1Za9
 DsX4hU9p1qLHjz1Gbm//VDiKd8cE4PgnVDi/JeFWqTLDCSglfX18lYSkxAHsZD6Pe00PvAQzI
 aNJRsiwOHMyNPfwEnF6h28qGs968zuhvXFFtbmiZzh8ZOCjymzdn0TIhifR6Ml1sQ6IyR3VYp
 s8F9RtnN4/krMuWYGTkdEy2Y1cbaQ6hSBwQE0rmu+ZJ2UQWiquC+gktrTJjX3EVk8y1KFx6p/
 H2GRKvwMdoOz5pyROd+JDvRW4FGVK+i73x/Nz4e0jv/xFqoHFeZxraHRkfu0l2sAOIlY8Hd3o
 6onhvVzTIWOz2/PmbGzpcub4p3tm7L7q7hsTpwLG97ObD44KEBIhIw4WnpehVQteUhZEFM6NB
 MYXCvwYntoNVlOve+NP+ceN8oQpyknXT+kwNtc2KN1OEIi6oQsDFJC+4Vt7/tiMQhTlN1SBzc
 8maiQLyI9Jl2NHlEcwaIL0YGBILps5apSUnYYqbBdWlKR61aGne0MAYgIyGnxMQHuzDa3hFMU
 Izh4U7aimhiIr0D7713RlwM/zQy+njhIj2mg8O9wbGWpBNpZiGOzUblu2tSr6CB+Jw0bkQzDA
 pK4jGeipuVy4fb/0kTNtzwuBldInlXG8Ib85RlcNJvjyxdfaT62qNNpu+cp6zSOv98Ia0xBeB
 uLIJCU5X36PwyYi/uP9g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hsr_debugfs_rename prototype got an extra 'void' that needs to
be removed again:

In file included from /git/arm-soc/net/hsr/hsr_main.c:12:
net/hsr/hsr_main.h:194:20: error: two or more data types in declaration specifiers
 static inline void void hsr_debugfs_rename(struct net_device *dev)

Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name is changed")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/hsr/hsr_main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index d40de84a637f..754d84b217f0 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -191,7 +191,7 @@ void hsr_debugfs_term(struct hsr_priv *priv);
 void hsr_debugfs_create_root(void);
 void hsr_debugfs_remove_root(void);
 #else
-static inline void void hsr_debugfs_rename(struct net_device *dev)
+static inline void hsr_debugfs_rename(struct net_device *dev)
 {
 }
 static inline void hsr_debugfs_init(struct hsr_priv *priv,
-- 
2.20.0

