Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19671B6D15
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 21:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387447AbfIRT5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 15:57:54 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:38151 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732201AbfIRT5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 15:57:53 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MBUZr-1iMWhv1hy3-00CwcX; Wed, 18 Sep 2019 21:57:48 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] ionic: remove useless return code
Date:   Wed, 18 Sep 2019 21:57:35 +0200
Message-Id: <20190918195745.2158829-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:tGFs0j53Jb1jMYkS2hCvPmKoxnLZMVIP3N3je8VWvQ5S2zgKuOG
 eRLzmZZRrnOViO/Nb+KEwoZQfjnNaRv4CBfx6fajZLUXaHleqA/VqQfmdYphluD3TZYl9z5
 Yfm3r1ze9i5irbHYscYwYmHHInCXbyzQgM92NJz4YuwaYdvF/K+aKiOG2LMYsKheRJCPHa2
 qNGClUNe8K3p3SkrFcxzg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:luKqPByHVkE=:opdo+VkX6Q+A/eJ1A6bg2i
 HKHF/nTEQZgnlDKLcYSraBMPoydxMYmpSm9xXpCxAecESwcR68I1YakaJbZI/mTqg+97ixphp
 PDsicnKNxxMDqFFRHrJDOf89sDZ+LqKSswowLtLLX72FIY/rDNUe8QbwHKqc65IPgVCh+BAhW
 DhP4FYOSQeuQgLg71++ec6edSlFuLpO5Tle6oDOVwhh9B1jwdf7eB2B3r6mCTZ2daguflSY0B
 17yyXEZgwENwt/tE9zRsYZK1ivcmOd6gOa/o9eIhSOZI12VOpQ1mqdYFi6BB3VIrWm2TRo9Xy
 PfrXkBcCvi0u0jeV6xcf4RWsI6zdW9s/D663ohUgBEM1I745TCg8g4pBnlNZRfIcdg3FYcs3g
 e/bvTpQOtYnOGcBI34gVeb/GBhkYukpkx6l/OkduA2Tg3BmzCj/+Ma7wdPMRCqzZ/8RCXi04K
 f0bPh4E1DS/Ez5FXjMst0BAHjs0Hm6FLbsDDrR9NlkjglTFpuN2s28PbD/z+0IFBDVd9R/leD
 4NO5K3AdbGqBUYPz18992nkrGUIRWzhFGeBiwXpxEwomjPqjwzy/V4o9IX0MfnttMtP+LzrmO
 yr4lGtB/atE68UviXuZb7MMX5CC0RkL3bKDFXOjjCM3g59MSAjvH5M5tDDukuY6mUm/BEUAll
 t4pxdss4cRaPApB7zdTp/21CGS+8uyhxeF8uhbDr7Q/LfmHMsjzdQyNJZDJNqZkBmoZTt2kRk
 YDTx9YcZxeo/AC+pBOu3dl+JSiyi2OFtTcGTv1AaFgiSg0ztB+67SRpBGB70TWAMFq3t3KCWT
 3iBUWKgxmDrWQGqjrKuqdGJzeSV15u7i7K2cq4bCw7urLEItHvqrtNmp4yEyRMVhdLJ8YmKxn
 Hq1f+6loHFbXxxloKZsg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The debugfs function was apparently changed from returning an error code
to a void return, but the return code left in place, causing a warning
from clang:

drivers/net/ethernet/pensando/ionic/ionic_debugfs.c:60:37: error: expression result unused [-Werror,-Wunused-value]
                            ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
                                                         ^~~~~~~~~~~

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index 7afc4a365b75..bc03cecf80cc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -57,7 +57,7 @@ DEFINE_SHOW_ATTRIBUTE(identity);
 void ionic_debugfs_add_ident(struct ionic *ionic)
 {
 	debugfs_create_file("identity", 0400, ionic->dentry,
-			    ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
+			    ionic, &identity_fops);
 }
 
 void ionic_debugfs_add_sizes(struct ionic *ionic)
-- 
2.20.0

