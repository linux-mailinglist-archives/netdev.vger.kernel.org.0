Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE54E699B
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 21:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353184AbiCXUHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 16:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344496AbiCXUHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 16:07:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9E2B244B
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 13:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4dPaVTHTXU7nADQi0TIsqkE4i5YdTWGV3VkAqHNO39pHWV0I8E0M01UtHuQt7DFXRTjYw3JIEDROiKrBctjvqCW0GC7PsEB7eJoPyHRsFK5ZAN1aGGRKp9WthJYoyvBonUVvllgZdNLj07pix6yj6oI2zZu3g/gWkDBvE7v2Ti7cSgIFDiphM+AInlvvdaoq1XDbw/hOVn3FmNW/sIRtGalK11/bjAptgNQqNAov3SBI+Z1PwXltestNVPoZPkoTTZfnVmWfjVbToWpXWXu2xq+D6JP9nhE6AMLn6JBNrmwAIm3CLmkvwf1+Rd+VIDPqo96WZXYYwH0OBWJs+Ljqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0muRVgS5ePMLWJnl11kyl7XQjtQcQzzx9p9vJPGxrvo=;
 b=DhrYTpcHD7z7XVqVKc5FkWOZjmvwMS85WhtlShxzgreGorrad8GRofSRKaelgBLtlP0VfAZhMLrHZMDYqAGDXWPDXgQusf7BLIJS68fAyP/r6CPOrMC8YPmoidOcI+GSV9rxbIOBcShsxjIcKOKacjQT3T2UcfQQvhhSyqCaGfMGbYB6o8v50LqPj3tUIlfWF/p57bch5ED+Wft3gXGeFP6dR6gViVGzmrulYMIT/5wZCfYOVdAH4G5keGcdTXnEkW9rVNCZwhN3Nx5zyZ032DEtf7vBMT3Jbodu4NJ1CMJJLCO0utZKcSNDNcdismLfxDbn1XTm8GCjOymd30CWEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0muRVgS5ePMLWJnl11kyl7XQjtQcQzzx9p9vJPGxrvo=;
 b=K1fleVGTBL8ruBC6psl1Tt4aSN1M1mEldThI3wWQoLmPdCSCTdnyeIm+Z2IrA71ST8S6eNbwuUGPXGOvkHzqzVi/0a859BK3bFJpdboAXckQDK0LM8vErAH80NFY3JCwYelOyX+8a/9Vm5F6tN2b/FEx2/RRVrZYa2eoNpPYq1xHu3p06VATR5TgQnxmJj97l7Tyiv8BNngCOiFVOLDSEdlST2rUkXNR2RAw57eVnDqC3uMcLb6+xR5bo2w2EfpQRerUSc5G3OBPLOqBbGzLQUYjrFviAL9IDEz4Im8qUpK6JlLhgEuLmp/rVKfOts8G3V0QQn1YEaUJf11YIEPp9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9)
 by DM5PR12MB1529.namprd12.prod.outlook.com (2603:10b6:4:3::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.16; Thu, 24 Mar 2022 20:05:27 +0000
Received: from SA0PR12MB4352.namprd12.prod.outlook.com
 ([fe80::54cb:32b6:bbde:13c5]) by SA0PR12MB4352.namprd12.prod.outlook.com
 ([fe80::54cb:32b6:bbde:13c5%4]) with mapi id 15.20.5102.017; Thu, 24 Mar 2022
 20:05:27 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        abauvin@scaleway.com, akherbouche@scaleway.com, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] selftests: test_vxlan_under_vrf: Fix broken test case
Date:   Thu, 24 Mar 2022 22:05:14 +0200
Message-Id: <20220324200514.1638326-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0021.eurprd05.prod.outlook.com
 (2603:10a6:800:92::31) To SA0PR12MB4352.namprd12.prod.outlook.com
 (2603:10b6:806:9c::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c33e1b4-5be5-47ab-e615-08da0dd1a3de
X-MS-TrafficTypeDiagnostic: DM5PR12MB1529:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1529082F83B9548F142573C9B2199@DM5PR12MB1529.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8BvRGuFO6I/afeQ6Q/W/j7EnIjKNnZGa7Icnkxx1ZuxfNJndrK2Pwx73Ireb+CBzKJD+5b4odKbZAPi6JcrJUA2vyng/255tJxYEDKUR7kM2vAZMPaw8aFFMtAxcPjbFuHITd2R6WdVoDLCHHDp9oRH+XYIovhiDy75QjIrqyKplRRuReQhiTBzjyX4yUCVib1UtG/07sIiB2cGglFWBoJGLhfL6PuOOhoQe+bUYqpdyJ29ryD3jQFAFkf0DyI4Jz1hXPykyAQS0XFoaRVuUZx9wAWy/cI5JutnTX2JRuzglAFgM1BuGBVtkRE0qvrJsQjN3ngTMlsQ4X7WwkGoiKfpYkFi5cjD/2o55mUPDUyaym8KS2lE4VfSq1iJ01Gqqs/kuAueS5ejjHzu/EFbKVhd+wungnCEacdR6Ee/jnwirZeUKakMiY/fesbgMSpR6Csomc89xxvWkIkrUep1xGxuBVxoPlAUOiMpozhuDyxFivVeVT5WqIV7rmiy7bg2yuq+l2rQSbxfvQHxc8zWlk4lL3B//2LLRIzzImG3ojEHhv5isfEXzlkRLU6rULHA13psXBEiT9q+zQgGBDmRWTcSjXfhtbn3ImBjSrjV8EhBxdUcy8L3uD0rZVIHUO3MWast7RH8Puuyl5MxyRI5ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(83380400001)(38100700002)(508600001)(8936002)(5660300002)(186003)(36756003)(107886003)(6486002)(316002)(4326008)(66476007)(66556008)(66946007)(6916009)(6506007)(6666004)(6512007)(8676002)(1076003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VFSOvOVvOZYWl9/BcKYRf2BhLG5HPD61TgVMoSt84HunD5Jrwb5Lo0dufgtj?=
 =?us-ascii?Q?c1nybIQcLfm0lQckx7Sz/CEfYF4jF2RisLGu2hl8x92AP+O9j9jMv3MKAqmb?=
 =?us-ascii?Q?jMwnWHpVumeRIBQWJa72utCwGjS3pUkgFczhsPSSsEK411R5fJu2r8/tSRny?=
 =?us-ascii?Q?YfEVHiASLl5Yg1oIIgqrxgANUo2Rplp2GpSgBwXdnNL9fK8H8zjYY0ARRtfa?=
 =?us-ascii?Q?rI8oQPkvDGhJpxfRZA4mTJodyng9MVex+u7sHvF+z06CjNR0tQH7uGrgJPrl?=
 =?us-ascii?Q?DCuPfv4MXbAzTCLJ28ufsdt/JA5yvLpHOepvrkTOvcb8RNGc/zN9H+iAa1nQ?=
 =?us-ascii?Q?uVmAmjXVHgEhrlknYDF7GGlzcVVAAxQC7KAVKr+0ZuD/ne7CO3+NgOZFfrBJ?=
 =?us-ascii?Q?ys1sPCc5nzXy3GXa1FSlRFewzTvI9e5e/FwE2y/8z0BwtNuuLKa45JdsDe+P?=
 =?us-ascii?Q?bgP46IGYYE2THEz26GyKuaT1E4eedJLuigOnKHlhuUBLnBtvAaHCggwIHXi6?=
 =?us-ascii?Q?Ne1w6cLax4bHBVcUbc3yZc/iXQscayJRVnrJED+Xu6sYvtuxTFbXaUy5w/Ad?=
 =?us-ascii?Q?5ycDnCF5XyD2+ypnxBuvYajc3UDWgD0DSdxvsusFgSqybeviD5v4ns4D9mLA?=
 =?us-ascii?Q?lpGuETVunkoYXqRdH5ijuBHeDI0GqSR4Z72jIkG7DYnToEqVbRhnmXZwHUNk?=
 =?us-ascii?Q?KOYxC0iA8sXipyKmknFaGQFFjEJDCMgy37gQpeBx6T5lPEcRssFx7w1eePJm?=
 =?us-ascii?Q?ZilVzW0oUy+O2pX6E40u8eZEunsevVNbEWXVh8rpaG6+he2FAV7NuBLBj5M2?=
 =?us-ascii?Q?RRUVECKyIM/G4/bX9iJYV9yp3YgcTks3iSknfpZqTLksrh5qDrvK+Iotmy7S?=
 =?us-ascii?Q?5WyopTJPt+cRaflGgAraW0YAwZYhYXPBWCbf9PsDF8fIERoq2igkXh766+OJ?=
 =?us-ascii?Q?P+WYYmcZ+3dODhGfrDbjI4rg6unGfERG2/GCbtSjzyfvFtZtEVS0/JGHJYBU?=
 =?us-ascii?Q?JRFmuB32u32kFuhY0goT7a2X5Iz6vlLXJnr/5SRG7hoafOW3rPk71JUMkzEy?=
 =?us-ascii?Q?iazAdeZ2mHGx5ClhK7tUI5sgPvyHi7bZVQU+CzIBilNUPGXv2TAl54C17lXy?=
 =?us-ascii?Q?fSMOdieResIWIYbSNJ2MsfksjNBtnNWUX52JyTBoax/AHjzARIKd/WPX78Nj?=
 =?us-ascii?Q?B3Va0InqmsCwq6YWn2O0xG3wgTUU5/w7ACc52dgUM1wDvrxGgBhB441fYluH?=
 =?us-ascii?Q?WsnPKFx2dWEMTT0QSbeaU3MEoAUO2J+zd+T1mv6EWle5sCn0GdwTO1Ir1+iw?=
 =?us-ascii?Q?I9bBzsMFxy9p/ySZp1HWVKsQ5P8VSgE6ZXueGekfhvfU9XNYZ8T2h7JAxd/9?=
 =?us-ascii?Q?sNukc5SSIUuOJHV6WrsU0wbKwNlPyBuYpwaL2m3ENtNINFp6VgHmd628IjMk?=
 =?us-ascii?Q?B6vdbrrYK3MGHIq/zCpEa1W0Bb4BoZJe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c33e1b4-5be5-47ab-e615-08da0dd1a3de
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 20:05:27.7323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZjZBxLVA7kvwGTKpKDjF3rtsntKwBt/xfQRo0TFca+uDW+1xeZpZYHOE9q1gHKXJPVsCIlUYarb5L/Faroz2Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1529
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of the last test case is to test VXLAN encapsulation and
decapsulation when the underlay lookup takes place in a non-default VRF.
This is achieved by enslaving the physical device of the tunnel to a
VRF.

The binding of the VXLAN UDP socket to the VRF happens when the VXLAN
device itself is opened, not when its physical device is opened. This
was also mentioned in the cited commit ("tests that moving the underlay
from a VRF to another works when down/up the VXLAN interface"), but the
test did something else.

Fix it by reopening the VXLAN device instead of its physical device.

Before:

 # ./test_vxlan_under_vrf.sh
 Checking HV connectivity                                           [ OK ]
 Check VM connectivity through VXLAN (underlay in the default VRF)  [ OK ]
 Check VM connectivity through VXLAN (underlay in a VRF)            [FAIL]

After:

 # ./test_vxlan_under_vrf.sh
 Checking HV connectivity                                           [ OK ]
 Check VM connectivity through VXLAN (underlay in the default VRF)  [ OK ]
 Check VM connectivity through VXLAN (underlay in a VRF)            [ OK ]

Fixes: 03f1c26b1c56 ("test/net: Add script for VXLAN underlay in a VRF")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/test_vxlan_under_vrf.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/test_vxlan_under_vrf.sh b/tools/testing/selftests/net/test_vxlan_under_vrf.sh
index ea5a7a808f12..1fd1250ebc66 100755
--- a/tools/testing/selftests/net/test_vxlan_under_vrf.sh
+++ b/tools/testing/selftests/net/test_vxlan_under_vrf.sh
@@ -120,11 +120,11 @@ echo "[ OK ]"
 
 # Move the underlay to a non-default VRF
 ip -netns hv-1 link set veth0 vrf vrf-underlay
-ip -netns hv-1 link set veth0 down
-ip -netns hv-1 link set veth0 up
+ip -netns hv-1 link set vxlan0 down
+ip -netns hv-1 link set vxlan0 up
 ip -netns hv-2 link set veth0 vrf vrf-underlay
-ip -netns hv-2 link set veth0 down
-ip -netns hv-2 link set veth0 up
+ip -netns hv-2 link set vxlan0 down
+ip -netns hv-2 link set vxlan0 up
 
 echo -n "Check VM connectivity through VXLAN (underlay in a VRF)            "
 ip netns exec vm-1 ping -c 1 -W 1 10.0.0.2 &> /dev/null || (echo "[FAIL]"; false)
-- 
2.33.1

