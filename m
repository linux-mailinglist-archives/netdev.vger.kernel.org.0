Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7127D44E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgI2RSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:18:49 -0400
Received: from mout.gmx.net ([212.227.15.19]:52949 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2RSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 13:18:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601399927;
        bh=oUjQj8gBZQ4J9AMkMGb0lmwMD4RRP3hHnT9XN3PKrRM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=HlS7Eq1Ja+Wy6KKMuLdLURkgWD1t9MW97JIspg9IZyadMVAqhmaOTp6wEa3dr3kfE
         q4byvHYMPrus2QROCtMoL7D5dJIcAmaxUXdHiPOsrILVBve7gB3vP6o1UQ6e8jaJOK
         yW/iFheUXER6nplEKbbZAMKbKPIBTdG6ybP0X/1Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([84.154.210.160]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MWASe-1ju40v1YWw-00XeRA; Tue, 29 Sep 2020 19:13:39 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2] lib8390: Replace panic() call with BUILD_BUG_ON
Date:   Tue, 29 Sep 2020 19:13:26 +0200
Message-Id: <20200929171326.6492-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:f9a0sATPpJGRz5KK/2LNAEId7v5fliuMSDXJXjy8ah52csxVua3
 P2y31Viuk9YTV6RXE7T2EuhoLpGxyk3SrPxTR93ugoktAAOBt7dDZemulQ/6GghYu2fyqtf
 /tVfdDpZOmO+uuYDtkiuBEMztkJ2hUzwMSxxasOwg77Wxdc5ODFSSE+MkJCHjX2408jINbJ
 K90n5Nv39MaH01bkFaC+g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mkAuxIH33ss=:vPoj4qtjdCnXduV1WPPceW
 k6ZiZV+2qQqsraW+y38ozd/cI3hPlDHcpuD3vdDhxzbRonIOmxrcwJrBMxCTYvG3eysxrrqdp
 ugvRp4tsvmHwpyAsBnNTf8YCfzWO1/VrWmYK3bm7bYBuGBjpu8PoMhKXoFKmtZhIv4zLAP/Zi
 P0dKgEahAA+gxvX8dMDmUWMiOrkJC1LKnW6zDTL61pnXdPsGS2jgAejxPzyUOas+vbp9tS+cj
 BrATzgQVXlULt6eCYRc1st2ozPpVZUjoETp5sOTwouiLPjOF8pkrtPIFXDfFysF8/ua9Wwy19
 ZmOKei2QYoofBmCfi3zh9tvAZO2vd6UdMqlQc4AYEOZmevhvUGE5ijA630FLJ6SnNnLdu05wH
 JQlhNUnUVEZXcn9a/apqhlex8e9lZty6tHGREFKP3HSR1iw5bL/1IIZk+KjGSWepWLoBs2aAP
 bh6a5rOutLbOmfgz/qrX666EWo/vNEXy2AQLJ2U4cYDxAwMT57DUly1fnk0w6KDdArSrhp0MI
 fLjCkWwwrkOxdWKGJ8LK91BCfnmIujhXFoPnetXG4U2g5XAPnuKkizWBKQt21cXRiAoa0i+q5
 bz9DX0ywo6Xtie1yQKr124Ph3PwSPFq6rE2W1AmWtm0SxYWFAxoYLX+2haBH0z2InacxX7olG
 EOOGtlepQtHXwW+Ap4LgLBROLNgNNlmpetkkMRprGFBpeLQDUHIGi6vNxkFvSTx3AZ1SAbgBG
 jDeR/u48lPEkmtHTey9+vJynMws6Nvj6YINIvT6lCokG+OT+NG4Ab9I5dL+69cRbQVeInGdwY
 O/GAUs8mzBbB1J3pbHfzAVsG2SntPcYRXbZDtF3sA10z7x/eDXTx61Ktek0OeDcgaUOh+RJOo
 4/8HzeR/G4DzzD8h32rhjlSFa8mFDNNNDJ7oMzpeU2gTIY5dj41EFT3str8HgrF80DULHHNQd
 uInKmPegSffb0qytoB6x2qE3mGrgF9rcZ1YvdCmJ5Dognu2aukQ+94jszQoRazic9XThdWfyP
 3tZ3WVAduS5Q2go5g1IKPm9uW9Mwqkvfv5n2FPTvGtVpoQBXoJKZeOKdmyH5RtojPy+Hp2Zce
 JH6a0pvut4ObSOoh3GIRPNh0J2RPv4Y4NP0CjmVzo+tCNshNHT7erCrPa+9VxadKXpQjTJJ5/
 dJYPku2JkedEsU050vNHytMyTKUzDwS88+YiLA5HApefIl6qP+DCatAP1WN9Jmv5OSRViiSsc
 UceRAJpp3TqCZFhCA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace panic() call in lib8390.c with BUILD_BUG_ON()
since checking the size of struct e8390_pkt_hdr should
happen at compile-time.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
v2 changes:
- remove __packed from struct e8390_pkt_hdr
=2D--
 drivers/net/ethernet/8390/lib8390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index 1f48d7f6365c..deba94d2c909 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -50,6 +50,7 @@

   */

+#include <linux/build_bug.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
@@ -1018,8 +1019,7 @@ static void __NS8390_init(struct net_device *dev, in=
t startp)
 	    ? (0x48 | ENDCFG_WTS | (ei_local->bigendian ? ENDCFG_BOS : 0))
 	    : 0x48;

-	if (sizeof(struct e8390_pkt_hdr) !=3D 4)
-		panic("8390.c: header struct mispacked\n");
+	BUILD_BUG_ON(sizeof(struct e8390_pkt_hdr) !=3D 4);
 	/* Follow National Semi's recommendations for initing the DP83902. */
 	ei_outb_p(E8390_NODMA+E8390_PAGE0+E8390_STOP, e8390_base+E8390_CMD); /* =
0x21 */
 	ei_outb_p(endcfg, e8390_base + EN0_DCFG);	/* 0x48 or 0x49 */
=2D-
2.20.1

