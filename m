Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFDF54B329
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 16:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343495AbiFNO1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 10:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343875AbiFNO1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 10:27:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732B231522
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 07:27:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEwHEiawfwheHp68sSzlH3UiS/fYW7hWnueF9S7J3cV8YEIiWDA+v1INMoJc8D63Ihtvqn+WIPjXNQ+YjbL+nsR+Gl5mPX68d1hEQKcPvX/xjLefoKsSIHd3NBELkciwC1Dlk3+mGvOPmOP0b64LjXeE8JCNaa+57DG9zibVa/zHyEtiGWSFuqsWwo4FDnQ20yQOwn6tIFvRe5FlGH7/qtQwMsAb99erl8oqD9hm7gZgfnciq1yXW8JCokdFb2Ev2h3z51aYdWvYGQEgKf8Ua0C6ilRI4ICiRf95GACt1m3i6m7s+4/+RqxILGQUgO8n9NZAow63w02jUV7aNSaaZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRY4jM07o3kmYwcAiaTExkqNbzTWxcD8QUriRHBOQus=;
 b=iv6djc++qb7dzE1DfdI6O+r3zixqXJl7z+XeiPBDJ/r+J6rGxai+sBLX3aAI32ctyVie8RjL5V4Ke9vY0SK5J9ShbsZhpuv5CNqAUTiKlXyEC2gaAM/krTyMNotJxoxpAgdAAPv2XPQlqxOzx3Xku2xdcYikeEaKRNnwg1jwRUhcZlUAdKgW2GzbmFFKGIxUp7c6C+cjeXYbTyG7ZkYElRYb+7ViDMvhXKD2lmVoDJuH1blvlvZHesaI6zmCWNQJh3Px4Y+vGHzC+U7W+QJjifyrWWDWdGmcc8yOjTdxIu/9uMQ2N/lple9BQYWhC2Z/Ec0ER7U8fQho/CX19oJoDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRY4jM07o3kmYwcAiaTExkqNbzTWxcD8QUriRHBOQus=;
 b=dAq92H2rpUdixbpGT2gMQEO1O36ScBmBT+1Cs5FHWLs7oZRwv0EqD/zk0LUyq01DTnraN1E99wLiAZJKPJfJ4z7PM57J7iwVnv7POiXndM8zMFM+yc2S0U2j7ARMjBKRBXwJP4iG8lKuk2JZ1Qt3XeaCrA3F+nGdrBkHeK0OIcDEsdP9maiYxYOll6AErenTNzYXaFjMED6xpW1j9Vrq4Y/8g9QlBwx6ZyCByaCnZLwsus0FEvy3XeVP40j7q4IfRNL0MkqR63wIn2TIDbTl0GTw2PK2rXyKpy3v39RuEzSjqgFQyM1EDKCqQ/zYxkjJ+I9VPgkK1yGRfGmqIx2Z/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB3696.namprd12.prod.outlook.com (2603:10b6:208:169::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Tue, 14 Jun
 2022 14:27:33 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%7]) with mapi id 15.20.5332.020; Tue, 14 Jun 2022
 14:27:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        taspelund@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2] man: tc-fw: Document masked handle usage
Date:   Tue, 14 Jun 2022 17:26:57 +0300
Message-Id: <20220614142657.2112576-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0162.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7194c294-1e1d-458b-6f0c-08da4e120513
X-MS-TrafficTypeDiagnostic: MN2PR12MB3696:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB36969822E49181904CA6FAB8B2AA9@MN2PR12MB3696.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z9lH7dFoyJKKGL3c+gDXbl2LjeN+GV65yLeCLPQHSPKOsr7+UTO/vGjpPBiZ8Y5H2TfXgVI4TJmcBj+UFhk/6X883x7K+NdAr7y/hQ98b0og+jAR/YPyKAiNr27BbE9NW/eUYWKgN6kShoTplUBj0l4LzmigWqkN1dZ0p8H7F7ed4wHlXxPesq5scWpc57bNq3Aox6yD4sYp4uzZT5I5pHSoExDE5VqEgl6OfoXMudaW5/Ejl+o4N3ytOKPPoNNBBncPdwRIXzsQtzuQenYwE9EgHoT+WvwuKyekB2R4plAHGxdGMqXDatPTrue06K0EbwhP13eFBpQtl0OdCawRjrLxUlmd9KBFU3LYlcp+ZOl97mxk+L32FPIVLZWTXUhGlgdO9vUTsvP9Zp5wXuT4eBBbcUXp+25o+osA2gDOWU1TI5lr7wc6ih1lCTLL+8OIiRPMhFcEa1Uk9bZy5jR1QJjLiWYfNQIZxh7OqLalfR6O2FKVhpkV25Vejvkx+6UpHb1PSC3mD0ar7w/xBIWMrg4wlG9wBo4EFIWgOwVl5LN5EtH85OVhwUb+oGzk2Akd0UoLHJk+3dNTsT9HNAd8GGPu4Y2DuQvm+Y+UeliypjhPZL1OHdsr6sfKml6WIKiOhnmCv+6F9rqKrhRXfVJZgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(36756003)(38100700002)(86362001)(508600001)(6486002)(316002)(2906002)(5660300002)(6666004)(107886003)(1076003)(66556008)(66946007)(186003)(66476007)(6916009)(4326008)(8676002)(8936002)(83380400001)(6506007)(2616005)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+pblibaH9cCc4MtAbb8zYx2LtklCCLotz/6jILavIB4fZciKQkAM6LnuLD4G?=
 =?us-ascii?Q?TNuMYj5w/Mh1GLQ0UezbR9GBSRTaGsA0mEfFpVChMeSp/urZcPs+ivdCILqt?=
 =?us-ascii?Q?ANQkb45Hfr0quOi/8nDLfixCgp1pV8tgh5aotgarllkI2R/JQhJcWzBPIHRJ?=
 =?us-ascii?Q?qK8T4XasqSltRL6r8In+t9IoKhhmlBXXC7ckT2ZrvTAo2JMLf1ME1zBYfZYJ?=
 =?us-ascii?Q?APMMv5JW20FxCRT6boo6kyqnkgGpdANBlOIi6X8v9bE1AAI/V3HXUp4OgLhO?=
 =?us-ascii?Q?KCDjaLztmTYmoJxBp5TiPGZl00bpFcyLC2ZvFf8rls0m7EIIMCnxkcqAahAS?=
 =?us-ascii?Q?64TlfylsHI2R/NyhvrA27FwPaiTJbVgsc8Vtgd2B10l/9D63ZIcWB5SqVCND?=
 =?us-ascii?Q?V9uioJauAS52RJHLcKV8GOErIVIR+SY7QqaOz7g6q0FcOFfWPPg9VhpZGUvE?=
 =?us-ascii?Q?vATacGJlHzdo0tXsJ5eIOq0RYboJqo9IBygD0IAvxx3ymTDSFjWyncxoCtLm?=
 =?us-ascii?Q?QUdk+wbUzrPxXE51yBOQPcX5q9rvzgzb4TAOa6PBdJYmC11gH6I5HsYW9Oac?=
 =?us-ascii?Q?kwSDSr/hAvsgBwkpIbuv817Y+4x8C2dPQNa1zFVoGrybOJxJPX2rSEcc52ZQ?=
 =?us-ascii?Q?C136TfJ/Hi78dg/DNFZxejfEbHPaB87mAOJhobGMsmwGz0hkQu/bweAuLPk5?=
 =?us-ascii?Q?uhF6sYbJi0PbMyltuOFqmY2iiCWeZWjKGeumgUsBzEvBGMkxMRfmEGuUPhdk?=
 =?us-ascii?Q?/YaWRc7LDdkhAE7tZIErpuylr0z6C7iWNtcOlxFy6dX0uRMF4mwEZiKVQDyG?=
 =?us-ascii?Q?xlN4PJ5I+qdid6acumESnth1Y4aMAdoMbKUBfbMKIO2ZFyjrNSJA+2tT9yLN?=
 =?us-ascii?Q?jPBnxbxXoLFFYjEuNZugJ3DnZ7UDhBL3NCHCP6/K0Mk0h6OWC5e3erQ4Ps89?=
 =?us-ascii?Q?0rROU2Lf1kWWxvSU23qjxJiazvzolc0hV40NoIrorYfL3q+QadmpBo20B4LJ?=
 =?us-ascii?Q?YiHySJb5bvuzaKl46hYOcUJAlhTvMIwB3Zvtflb5ZR7QrmQJyfAIpy/gYsIO?=
 =?us-ascii?Q?M6Teywg9MPUVRVETWQ8if3WXoV7FnI4RG4PH9g4xPW0iYNC0urFAmoWEnGxV?=
 =?us-ascii?Q?FVnLQaIX1aiG1zkYr86h3t5i7yQNgj81LZCG2ZVReSYQjgJ0zy1W/Q2nlCgf?=
 =?us-ascii?Q?vujvEHqDFGHqYtX6cBkOMkgUbd/BQEuAd9NHtUTrQgIhGCJDvYv6E3mpgVM6?=
 =?us-ascii?Q?HGfrruJQLqSEL83zPalj/XIn3xYctCL/rPrR5sOeLQrLDfSSdVIy1c03Lv9q?=
 =?us-ascii?Q?8os5FjEFbTPCNsj1nYHG5UVJTRSvEXtctASS+x8hQzGVobMqeVyOBMJ5+XtX?=
 =?us-ascii?Q?DkQcdTjhe5gtXycmJnOPbPY4Mw7X4C+q+2PozhypBj9O2SBD98GhllcfEDV/?=
 =?us-ascii?Q?IxjQcfjATjatc+9yyC8X7DnC/CRwBkRYA/5mjJCxPu5jeywgMeLvlc6E4hG2?=
 =?us-ascii?Q?EDmj+FHhriTqeKbU39NmqArLFS9CUCLnsfkTs/JGUn2FqHafRK6gKFhpqRwe?=
 =?us-ascii?Q?soX6LV1+PjEztDFFs+m6oC66AHcloY1OaMfYIM+/PXaNmbcn5/mU/+2OjH+/?=
 =?us-ascii?Q?CtJV8mduJUuMart/O35UM5/uUhDhu+EnFI20W7rEwgJSPgJWUk5fcC5c7K0S?=
 =?us-ascii?Q?wJUOsfF+daec3yioSC8R8QKAG5uD817XmD1kPrazAppY3a7c4I71UbzLKErD?=
 =?us-ascii?Q?12/A4ppsew=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7194c294-1e1d-458b-6f0c-08da4e120513
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 14:27:32.9133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wa458CNNb1VsJosnQaxvlE3MgT99XS2dGzQd0KqBT9IM2T09kbDWb3Lf7jxgxcMCc0IxKD72+siKtvqZp7enUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3696
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tc-fw filter can be used to match on the packet's fwmark by adding a
filter with a matching handle. It also supports matching on specific
bits of the fwmark by specifying the handle together with a mask. This
is documented in the usage message below, but not in the man page.

Document it in the man page together with an example.

 $ tc filter add fw help
 Usage: ... fw [ classid CLASSID ] [ indev DEV ] [ action ACTION_SPEC ]
         CLASSID := Push matching packets to the class identified by CLASSID with format X:Y
                 CLASSID is parsed as hexadecimal input.
         DEV := specify device for incoming device classification.
         ACTION_SPEC := Apply an action on matching packets.
         NOTE: handle is represented as HANDLE[/FWMASK].
                 FWMASK is 0xffffffff by default.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 man/man8/tc-fw.8 | 44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/man/man8/tc-fw.8 b/man/man8/tc-fw.8
index 711e128f1d0a..589505aefb2e 100644
--- a/man/man8/tc-fw.8
+++ b/man/man8/tc-fw.8
@@ -14,9 +14,15 @@ the
 .B fw
 filter allows one to classify packets based on a previously set
 .BR fwmark " by " iptables .
-If it is identical to the filter's
+If the masked value of the
+.B fwmark
+matches the filter's masked
 .BR handle ,
-the filter matches.
+the filter matches. By default, all 32 bits of the
+.B handle
+and the
+.B fwmark
+are masked.
 .B iptables
 allows one to mark single packets with the
 .B MARK
@@ -60,7 +66,39 @@ statement marking packets coming in on eth0:
 iptables -t mangle -A PREROUTING -i eth0 -j MARK --set-mark 6
 .EE
 .RE
+
+Specific bits of the packet's
+.B fwmark
+can be set using the
+.B skbedit
+action. For example, to only set one bit of the
+.B fwmark
+without changing any other bit:
+
+.RS
+.EX
+tc filter add ... action skbedit mark 0x8/0x8
+.EE
+.RE
+
+The
+.B fw
+filter can then be used to match on this bit by masking the
+.B handle:
+
+.RS
+.EX
+tc filter add ... handle 0x8/0x8 fw action drop
+.EE
+.RE
+
+This is useful when different bits of the
+.B fwmark
+are assigned different meanings.
+.EE
+.RE
 .SH SEE ALSO
 .BR tc (8),
 .BR iptables (8),
-.BR iptables-extensions (8)
+.BR iptables-extensions (8),
+.BR tc-skbedit (8)
-- 
2.36.1

