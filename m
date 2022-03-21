Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905F54E2F63
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351518AbiCURw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351871AbiCURw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:52:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C86554AF
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:51:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvwuRBd5FJRX9LVJU8SdPS2//6Zcwva4TdOsqUkuhDOg7BFzXz2L5YQuHsntSuIFCaC+nMaDUa8pvO36CWXYiOtL4WCpjQKT/ncOip1/vNROPQ/R2eoPCX3R4kQ0T9Nwd0c25ArhT7M5zA5fFnMBeWl2A/hkVfWBe/CCLGrASWVGnPNVvZ0X2oHv8CkBP4IVeKeXhT9Ps3D1rRShTvGWnCoYWhni23GGO8Y5DF+PkBa7C6thQWo3WfP0Pic7MKWvjwKMjfKMm5XwCeASm95k7uFJErWwtVrRqXdTNHxLhMQN6ua/8DWn0fTL93M7fpe3TzdejU60U5gmkRBdeaTC2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5jqT/EVlJjUPUPK7BFWaToU62LYP0CHSd3C0Ndrsg0=;
 b=aU3PWKYDoOEMd6zXDEhUBk3MaH/hatCTXimtdKjnF+OiUGPo0GspjOVEB9c+iTsgJE4tVn/aZfJJtmSS6PwYhQlhmxZNTkpMLSDVE/etpsYb09r/Kp9c0mb+YACwkgbXyKea85SPFhz7w3tug+LU0sPBDHvmgH/diS6CGzS/N2uPh+MQDX99dImfYIPqVY34t+ZA44tzaWwN2nXIccQeuBL8Pt0Blu03G134pW4T7rKy3dRsGyMZPw8i4uRvWcxS08kELYOqhnKNEIrKCO9SjBuvmYneqfyHEybmwKGMUASruGSkxPhQXJiaKsWHVDV7RJhrfMz9W+0vqjUqClZC9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5jqT/EVlJjUPUPK7BFWaToU62LYP0CHSd3C0Ndrsg0=;
 b=qcI04BvQO+Hwv0RhbwK6GgvhnNrdPTpw/wgOCBQHEEzq+kWMUoEP5ux/q/gJak827LnejXd/QIt9Kkk2jgjUOLUmFNJuosHwQXoGOQ67jhv7GRB74qi/nFVaNbIxeM6ILERYKXvWFmQ1BraMJW57c+rGF1MILYYIDFDWLPd+T1E0F5I8226Yy5qSm8EZFdtdHvBtrX5wrhGvCK+G3uh8PuujLOVgy25X6x2CeHnWTZA9OB9aIeG3qroM6Aj9wGvSpe0BNQ0VD4b0+q86BV5rf6aZ3TOj4OtF8yJKlv1cWNGyTjGVC5gN/MQAaNssNm/9o17rBTcgsSARSBoNhePg7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB3435.namprd12.prod.outlook.com (2603:10b6:5:39::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Mon, 21 Mar
 2022 17:51:27 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::151f:fa37:1edb:fad1]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::151f:fa37:1edb:fad1%6]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 17:51:27 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        schultz.hans@gmail.com, razor@blackwall.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/2] selftests: forwarding: Use same VRF for port and VLAN upper
Date:   Mon, 21 Mar 2022 19:51:02 +0200
Message-Id: <20220321175102.978020-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220321175102.978020-1-idosch@nvidia.com>
References: <20220321175102.978020-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0496.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::15) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8480996-599f-4f87-4a28-08da0b636c38
X-MS-TrafficTypeDiagnostic: DM6PR12MB3435:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB343561BB74AB26308019CB97B2169@DM6PR12MB3435.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkbVdV3+LPxwAI6lkDhT/zI+1JDH75G655yneTo8hHyxgyCRhieFfWssip0qashkvGTVEKW0YRaoNkN1aMbLfQh2DP3Q7MSRbGvhxM/6Z/7sZUmDzeFR9FgEnI9d5N2/7R6HbT+FwYzIPf3aeWZITZWivsyIiitWHJt8n7sqB1u6tYQTSpdoQFyLnfLq58CRV4QVKWgX4aoAhlRTZjeexiS+LzWW+Kskh4UUadZ/6MzcT74Uy/7mGeumynqdbmBkObey7uwecpM5bo8/0YRRpK5g/8SC+3nRFoMZgvIrwIEfBZ4MhaRUA1vnQPXNPj6r82PRA7Rd8CvVVhVnoUjSt5PSg99D/1zNF9PcGbEaOSiUseseXRPLpS/Jy3C+ZMvlLvyXArroITEcCqLwuT9aOjt39IiPcEhZvMZpQfl3yLGlh98Lu4Q9GPtPcFNPBnyQqLfQRwL6xaMlxDpgL59O5hCiQfBuMCwMTDjwTi/6bqv+Y1jmB/f1lxXHq1rRBrl0OEc3OTbrew7zptYmg5KxAMBgDyysaCGvG4nHTmWIIANqWx9MOKiYJc+6tqVrzGuqHGGDZ7apfZ8Fvgf7G80B/0YphepmjoUtv174a9rATaxrW2r0Efr9O5WMzRqhQ3NY+9XaK1tj0KtqB58F8F0vzXCEGb0V8qN4zSIG4Fdo/UtB0TKVGNJk9g3EaEuy0hvjAmD5MHzgQ1RUL3Cl7anwMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(1076003)(186003)(26005)(2616005)(6506007)(6512007)(2906002)(6666004)(107886003)(36756003)(83380400001)(4326008)(66946007)(66476007)(38100700002)(66556008)(8676002)(5660300002)(6486002)(508600001)(316002)(6916009)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SilNFsUXoCakJ1fsg9OGTRcaN7BVD69J/BDDAr+zvtsK7rV4yVEP61DXrNrN?=
 =?us-ascii?Q?QxKi1nq2eU9+yhAPip/Qswa4JyZQ8H6ZryPMK/oIGUtp8DKuwSwCmxvQCvaZ?=
 =?us-ascii?Q?SqgSnbEvduJqJf/iipBCGNIWbP/IYpJQgvK3NKs9ap3oCCm7dWMZgcdQhh9Y?=
 =?us-ascii?Q?k0loptjA/vH3jY1jVsXIbd+Y02ePsE+yPNNWuo01MGiVoK3I6In/GnXtsaWC?=
 =?us-ascii?Q?Mll8iCfYsgx4zLAwUI8Cre9zsBSzCf8AFarDAYH3u3v2VUGWDgZF9Vb5S5td?=
 =?us-ascii?Q?jzLOYet2J+WS2/X0Ogk3dQFS7dQ6COPTYv2OPaelt3lj6bgrxr17Ot05UU+z?=
 =?us-ascii?Q?36gsLqlHcYVTqumHmJne9BF/hJY6ES5Sv1hzDOAxuWE4EKjqyZxdnKRCW3UG?=
 =?us-ascii?Q?QW/ZVF3hpxHQVU6hL4br22y2gmYasFnYR1oYlc+C6b1tUg1n9A33vmmsKMlR?=
 =?us-ascii?Q?V9ZXpWvCf3SP7fwhGJ74TA6+eb5I6rFwFtvgU9oNwi0pTVz/3ODbG4S3bVs1?=
 =?us-ascii?Q?5roYgcSZNEHdOrWrsiesMZqE+lPt2kRBYODhc43qO3dtqwheWzb8a4tCw6Z5?=
 =?us-ascii?Q?7zMfTKKlqnksNFNvRMmggA90LWDkRomqKPYX55kSMVnuoWskKVsq/vPSiZRz?=
 =?us-ascii?Q?i1UBBuYx0yaXEnLaGxMtw7UZbujqJRbkOg/TwSlXKXYOJwOgLV2UrO9eR3mQ?=
 =?us-ascii?Q?mCPPJ6wnhvwV246ZJ4o2UNAaoJJc+0n03sC8ATrW1zlAFmf8vYojSU+2vF7L?=
 =?us-ascii?Q?6XDO4Eue3uCXz9fedFmFAnHryoieOOQL56QenbW7tXeAh456WApr9ijbaGWF?=
 =?us-ascii?Q?onMNqNCtWINGtEuEEUT5TXvalIBwpkgjqtMOP4fTt0Xrmr33Z/5W/SNA26F5?=
 =?us-ascii?Q?mB2SRuZyONRQv3EMLMNnmI9jlfQWV/TYoOOW4AcF/y5Kr3DKG3in5DHYznd3?=
 =?us-ascii?Q?2rlEqiTU0rfB8ZkAW16Q4GCilS7X23PG44Of2jfmMYq2wqOwXc1a0+bGN7Xl?=
 =?us-ascii?Q?ghUXhuEpk3jr1xwplJSezCaGf3llexjCO7M5hwSd3WGWHu0Pck9/LX+MBjR2?=
 =?us-ascii?Q?3cFJ4VuEaNyg8Ulj9aY+aeNR8whh57PouQQnb/LzCnSGbd8GDUEX03iEqU00?=
 =?us-ascii?Q?AmfORCStd4iU6Qa1Gse5AN2DOoNE8ApgD5zvviYVllUtffjbdcTITnZiuR2b?=
 =?us-ascii?Q?yKO5Uev9qZB1H9U5jwNwrC0cnSCRkQk+4j/f5O/7DGHtENLHT1z4KVOvs2Yt?=
 =?us-ascii?Q?aowyCQ8y/iavtQQj4WArRgOk/NqWN3RlgdUl1EIyCIPz4K9agfEeKYFNPqPn?=
 =?us-ascii?Q?KLX5bXTxjh8bAZVbiIp4JFqT1y0ZbZJcjuc1jY09DzRpJV78XyeHm70rK5oq?=
 =?us-ascii?Q?WaIAXwAuEOoseGvgFIv+0i6Cx43yJOerTjEQqe5NitBV7QqxX504dybuLo8G?=
 =?us-ascii?Q?cL9ZYjpo+8/cDCnQyLPZ9D30Funr85kw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8480996-599f-4f87-4a28-08da0b636c38
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 17:51:27.4298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubvHBabugzgfAUGfOkqm3PzaQDZYXBJ2wVIjMsjW4rTsSoXtcktTxnNDKJEf9AIDGiAVqX7iZwRNaX1GoY1sSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3435
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test creates a separate VRF for the VLAN upper, but does not destroy
it during cleanup, resulting in "RTNETLINK answers: File exists" errors.

Fix by using the same VRF for the port and its VLAN upper. This is OK
since their IP addresses do not overlap.

Before:

 # ./bridge_locked_port.sh
 TEST: Locked port ipv4                                              [ OK ]
 TEST: Locked port ipv6                                              [ OK ]
 TEST: Locked port vlan                                              [ OK ]

 # ./bridge_locked_port.sh
 RTNETLINK answers: File exists
 RTNETLINK answers: File exists
 RTNETLINK answers: File exists
 RTNETLINK answers: File exists
 RTNETLINK answers: File exists
 RTNETLINK answers: File exists
 TEST: Locked port ipv4                                              [ OK ]
 TEST: Locked port ipv6                                              [ OK ]
 TEST: Locked port vlan                                              [ OK ]

After:

 # ./bridge_locked_port.sh
 TEST: Locked port ipv4                                              [ OK ]
 TEST: Locked port ipv6                                              [ OK ]
 TEST: Locked port vlan                                              [ OK ]

 # ./bridge_locked_port.sh
 TEST: Locked port ipv4                                              [ OK ]
 TEST: Locked port ipv6                                              [ OK ]
 TEST: Locked port vlan                                              [ OK ]

Fixes: b2b681a41251 ("selftests: forwarding: tests of locked port feature")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/bridge_locked_port.sh        | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
index 67ce59bb3555..5b02b6b60ce7 100755
--- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
@@ -9,9 +9,7 @@ source lib.sh
 h1_create()
 {
 	simple_if_init $h1 192.0.2.1/24 2001:db8:1::1/64
-	vrf_create "vrf-vlan-h1"
-	ip link set dev vrf-vlan-h1 up
-	vlan_create $h1 100 vrf-vlan-h1 198.51.100.1/24
+	vlan_create $h1 100 v$h1 198.51.100.1/24
 }
 
 h1_destroy()
@@ -23,9 +21,7 @@ h1_destroy()
 h2_create()
 {
 	simple_if_init $h2 192.0.2.2/24 2001:db8:1::2/64
-	vrf_create "vrf-vlan-h2"
-	ip link set dev vrf-vlan-h2 up
-	vlan_create $h2 100 vrf-vlan-h2 198.51.100.2/24
+	vlan_create $h2 100 v$h2 198.51.100.2/24
 }
 
 h2_destroy()
-- 
2.33.1

