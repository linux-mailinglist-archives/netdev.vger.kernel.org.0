Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4819D4DD7BF
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbiCRKO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbiCRKO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:14:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2102.outbound.protection.outlook.com [40.107.220.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579E7F1E99
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcOMQQpik39KBMNF/CDz0IPw5GFAWgwp7GHnxUOu+hpZoC/U94DcbVW3s6AtMxKvLgsVqOCu+JrO9LNyb5lN1QhS/nBpAbWEQgb4gps3GIId7e0/j4altyxbSR9I4lCwKYv565YAPbLEm0meBq8HiVGmkm/s8h3NKIS2IatW48Dp6OcyGf8+qwSllZ08nEjndahL6svhOV5CYaRrBNX6dDPpxe1cLGNkJmhCIwnhssQLTJ92iPDostjYa1WZ7A5xOJ9i3oJ/hSwQ3flR+ZkhuJ2+/MfMs8T4qcyOPNeK9GnGBVwMH6c/rYGA0BySeA14oqFwqXi0Rg8Qo35sB3yVHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rfmihsNmDLBjpkL6M7X8roCgvh6FrVeCWKarT9uejo=;
 b=SRJEOD5iPK2Xv2009pP2ThOyt4b1isWj9QpUszEqSTxE1wb7gXhQGmZLQHzkn2c6QUZwI3M2xzA4jp0bpjvJjqq1uaYYOzGdRbKRY+gHGNx74xl+ki7iVojrRL5f8MRApj+IKeOdqGmiCtH2T/a6EzLhDsnT+IuH5C6UtC6936lS8AbbHDZ8Z2Flp0A1EzpdpzGIPqxC7mbATIHhLvXEEb0tcp0Kz0N5ucMfilwOO2a6K5vPa/cbSnOM8DJ4KtDg4BAHyZCHPIL7EUj3YtnrV2+2cmqZCC/BeDJsirG01HDitgxyPOsb6YzsXXIr0LpEKPBLN3wF4OQK8KJR9B7l0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rfmihsNmDLBjpkL6M7X8roCgvh6FrVeCWKarT9uejo=;
 b=J2di9MyGUoO0qUkOU+LVwadsPdBUKUtWK4EJZ5mJznS22Ge+Fj6bRc9dwNBpH8842LEDwgJW6lZi6xf6hB2KR1i15fjrIG+//4UwZmqps0fAeQLdoKdg1BCFjGOkQv24g2gN0CkRLMGGT3MGUVluqD6/4f1fvOKkOWX9C13KiT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB3139.namprd13.prod.outlook.com (2603:10b6:405:7f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.8; Fri, 18 Mar
 2022 10:13:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 00/10]  nfp: support for NFP-3800
Date:   Fri, 18 Mar 2022 11:12:52 +0100
Message-Id: <20220318101302.113419-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d27a9a83-0218-478b-a43c-08da08c7f440
X-MS-TrafficTypeDiagnostic: BN6PR13MB3139:EE_
X-Microsoft-Antispam-PRVS: <BN6PR13MB31392FA9A76A10B909DA5F55E8139@BN6PR13MB3139.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tU2RyvElofA8GduzS9hJrieDq4ngAjbv8hkjtALicYfBfSYybKyt7FzN45ymCiq8bR9sXi+jzpVRrYxRggSbl5l4u5LneVIW3dfse/sKsZaD7fslJr1hjtYzWXp/zP/D/uGdCdd1tK5xtQCq6iNZRvVDRhKKmpPIUeNQ14ecsvCFo2W0LWz2Qrb1LEZ9nbHt1sbr2Mn5xyAtQ/o5SUY01wuMmI47yzWIMyOhAYyiKE1SH+CSkyCsSSLraBrgneTLXQgbSfvT5pyU45UZcOoPFkJCWw0le0q0ZhsculQgqqdaYz7Zewug7oCOrPztcFVMFs8hVdyxfdVkk0BiEkXmoLfVjUUx6p8MMttk4nK9ESR68/le36yV1SNWFMLr4RRcKD94oiTALdcFqGcRF0Nij7qAT94mOgkk8mRzc0jhSlqiHRwGP0OZ1OB8ol0oovdU6HWny5tOdus2PvvOn25sVCKe3xo+np1Je74NvRp/6sACO2hSktCJRvzTYjpFqX9SH+RMbeZHYreKGRngiuRmdqP+ZSnvcVxIjCtspthFMirj8Kn7zHrcdidOXH3JKEpgYBZfOlIGJBP2IM2rAGGoagHNmgHQe62NU/YY+OEzaG3463pl4+6cEyebyVJjrEH5PYkINSY2CeI2ohZ6z21aLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(39830400003)(396003)(366004)(376002)(66946007)(66556008)(36756003)(8676002)(8936002)(66476007)(5660300002)(4326008)(44832011)(6486002)(508600001)(316002)(2906002)(110136005)(38100700002)(2616005)(83380400001)(107886003)(1076003)(186003)(86362001)(6506007)(6512007)(6666004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XxcNWyfbgWKURn4Wp1cxKiHhgjb6xYWZoL/jVESYVYTZgcRAf1Q1EWN9+gx0?=
 =?us-ascii?Q?ujjPC540bdmqJkfHnDD9CbpsUr2lpg3O4eK+sc/xM3DRVnMk9ZcHE/o502hw?=
 =?us-ascii?Q?0l/vRaJX3Zk9zRjsAD5nMUJ9lTnmzoiQ7ERo5mH1X8j2g4/7DOdKJ64KBxLH?=
 =?us-ascii?Q?Xrdig9sQc1qngnHyCzoqTM1v31NAQckGGsaY26WI9i0TahahnDclRt8OOdv2?=
 =?us-ascii?Q?ZCpCA08I+Tx3LgvilvJtn5OZzRWSgt1cUmyUJ2Vf7bhToOmCaSG+O36TqHlf?=
 =?us-ascii?Q?EsqCqYDW5NPy/u2WihK2vx6QFwhm0xDk72msxvmBjO+tdC/4PkBMbgM/87s8?=
 =?us-ascii?Q?Grhzz759y4tDrPzCZ4tZvZ4XVR9X12JcOMvACCJjKOcpfEG27vxjd8o67qzW?=
 =?us-ascii?Q?WD0LIRAq8mo4YP22ec6Vuywmc2WGq/6GFmNhvlCzkzGYZES3Yk4iLrsZFm+6?=
 =?us-ascii?Q?5PL7F/IAiKiYZiRULFe8Lq4jWfZR6R0iBeVunrzW1F8utVfIUPrwMnG7HHfU?=
 =?us-ascii?Q?h7gqywAZjpe/lE8Q3FBNIl+itjEg933JMsBH1P48SObe0KMLh4vBReFz5bCI?=
 =?us-ascii?Q?SdaeJqIRTFxGDbw8XKPq7X6q50KzM9EulQNJYJcGymM1QGoEt8Ha1DPVC0WX?=
 =?us-ascii?Q?5r8DNwzur6cZL3gpC8Z+QVLZtIrNP7ayWfnNujxCDIfLqTEMIa9zirDSvQ2D?=
 =?us-ascii?Q?rpdGcnS4yphl9INLJkeH2JTY6JJilONZH8LJKkGmIBn7jBcU/RjISJ1A9ah5?=
 =?us-ascii?Q?SqPspamaBE3VMvwZK2F3KKl+KUeW0KWb+iOadLzF8i2FRNSX0gXwZDjn57qi?=
 =?us-ascii?Q?SJgdLFUVhPjYFmvH8yvdC+5rehhCyye4Ah6S/26W0BEKNlHJXKiFO8NT9ksn?=
 =?us-ascii?Q?IENSGe9RlyzmoXANr3KxTKak781itwqpY73cO/tgfn5jDfug+oa2pXMcc+gk?=
 =?us-ascii?Q?CuwFbj1VeNzhUieWu26/lPlLLdl6d++PdTT9EFk6uRImWBXBrsvGfqdjecHB?=
 =?us-ascii?Q?VbSBNlDdFFDqIIvb5tuBJwi0zyaS+lsY3DqdbXTqxTK+k/TXO11pv/Bhv/Vd?=
 =?us-ascii?Q?sEHOn8FjAip6fqUl0ByHoJuKK9ER8DnE4EknpShSehNrKepL8ImNAQT/hSi6?=
 =?us-ascii?Q?CiKyumTJHGYKP8wAqXh8jo+BnorbylSVopNaCOJ027RJuq/P55hMgFKWf459?=
 =?us-ascii?Q?pCkSopRib2tF8UWpau9a/xoOvvwBXvFWwmx5ahGBedNszdaGWijc9/03FqiE?=
 =?us-ascii?Q?cAoMafSHm0R6nYcc+CJ17GFYfbyze9qK1MIAp4mhLxXhJpv/9BlBuYhYSnzt?=
 =?us-ascii?Q?Cgo1VDfEALabEajYXw4+14FY4b+2u1gPaNmwfpsfAgphRlr8VIUO/xbV1Dxj?=
 =?us-ascii?Q?o6PMUk4j8SkDUwIv2ShPWvdvhpn+pRR2u3+SIEnUsZQ2NC7N2HZ53O6KRqix?=
 =?us-ascii?Q?IaTDNKCVdVCZ2mjt8mOCS5DF8ZZtg1G9NYapfNDsKi7VRp6V1yzVtiCgfC0u?=
 =?us-ascii?Q?YUXYz5K/uxxVgyADbTyUes+Zvo0752KhWJR7XgWJOWzqpaAXljtWxjFazQ?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d27a9a83-0218-478b-a43c-08da08c7f440
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:31.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DsK2MG4jsU78UwJRrp1LShvjXplRrIDvcU5C+vG5wGsmsfTL8rFGaSk+ildTI0R9tx7JppuAyiVKJznc7mXjwiFdhXDsBRK4ZCKEjNYJS2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB3139
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Yinjun Zhan says:

This is the second of a two part series to support the NFP-3800 device.

To utilize the new hardware features of the NFP-3800, driver adds support
of a new data path NFDK. This series mainly does some refactor work to the
data path related implementations. The data path specific implementations
are now separated into nfd3 and nfdk directories respectively, and the
common part is also moved into a new file.

* The series starts with a small refinement in Patch 1/10. Patches 2/10 and
  3/10 are the main refactoring of data path implementation, which prepares
  for the adding the NFDK data path.
* Before the introduction of NFDK, there's some more preparation work
  for NFP-3800 features, such as multi-descriptor per-packet and write-back
  mechanism of TX pointer, which is done in patches 4/10, 5/10, 6/10, 7/10.
* Patch 8/10 allows the driver to select data path according
  to firmware version. Finally, patches 9/10 and 10/10 introduce the new
  NFDK data path.

Thanks to everyone who contributed to this work.

Jakub Kicinski (9):
  nfp: calculate ring masks without conditionals
  nfp: move the fast path code to separate files
  nfp: use callbacks for slow path ring related functions
  nfp: prepare for multi-part descriptors
  nfp: move tx_ring->qcidx into cold data
  nfp: use TX ring pointer write back
  nfp: add per-data path feature mask
  nfp: choose data path based on version
  nfp: add support for NFDK data path

Yinjun Zhang (1):
  nfp: nfdk: implement xdp tx path for NFDK

 drivers/net/ethernet/netronome/nfp/Makefile   |    6 +
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  | 1350 ++++++++++
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |  106 +
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  275 +++
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |  408 +++
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 1524 ++++++++++++
 .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  128 +
 .../net/ethernet/netronome/nfp/nfdk/rings.c   |  195 ++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  159 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 2180 +----------------
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |    5 +-
 .../ethernet/netronome/nfp/nfp_net_debugfs.c  |   51 +-
 .../net/ethernet/netronome/nfp/nfp_net_dp.c   |  442 ++++
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   |  215 ++
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |   10 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |    9 +-
 .../net/ethernet/netronome/nfp/nfp_net_xsk.c  |  440 +---
 .../net/ethernet/netronome/nfp/nfp_net_xsk.h  |   16 +-
 .../ethernet/netronome/nfp/nfp_netvf_main.c   |    9 +-
 19 files changed, 4889 insertions(+), 2639 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/rings.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/rings.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_dp.h

-- 
2.30.2

