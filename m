Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BBD5BFC6D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 12:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiIUKe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 06:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIUKe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 06:34:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0CD915EC;
        Wed, 21 Sep 2022 03:34:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RySLviqlMtA4bqRO156USdvo975Sk4R8DDS7xkvJUtbW9HhoB81PBawYCRcpleq17I/Zml9AZLrt3S9h88sWcxSJvWn+posoz5Eysqv/sh53xLbR5l0n/iDsG090NyyG1hZS4Dx0kvlWX7LYYcf8kI36XSVtKjHegNIRnmG+KHSOC/U9QcwFUWF9hCO3iK11G2Ohn9rUNlnqxSjxS8/K+Idfy1Yw60HlBKu3+Do1hAo+52VcuqYlgmvvhPggcSM5sgfzlC2QRHQWJXA5U/4hsss7Ykw5Ijz3P/n671fGvsQeJ+WFp8ShJGR5Lwo8wiAfokAHVk1JuFsbz+9D5IoWhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIEFAt+fqwGBj6BIWotvvRb37mkyUEMqUnIlHIcmusU=;
 b=cTZ/U2uvZvf0JpeHU2wm9CZFL2uyO7salT5pRUAz0htpzvfnJ3vhIxScU6V2Pny52TGsBgnopStNi+6+1G1v6XMj7VQ4oVQYMJJJWATPAtgdVJS/YArIqavTbFrOrpSHyUJNRZyY1RoGP1QwNwD3ycu1LxTMbxZ8NPfMREmEqifuyrXcxs+dQKnszMGBGgP7LjMlQWtXmF6uCe/2yrl5NnqeBe9UhXGzzW/REP9crdXBVshpsNExxQhWmusqheF8xvIbW1xFrqPZj80ZLim7beZbSxoL3MKgfEc9hmehNNsVuFVXlOxU2vS720u2anLjE5v5NtjsCJOut2CmiWMKbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIEFAt+fqwGBj6BIWotvvRb37mkyUEMqUnIlHIcmusU=;
 b=Sp3hdBSLWLq+07daArUareu+lJz7OPykeqzpqvUidGRyTL6fLp4iLWlBYen6ChA3zprb7TT7mMRjEgSjcVsAQFsFXRdurRCgH5nNyfUav/nzvmpTXAM7+roiGtUoF18Z0acyteNP20PgU0fH5+y6EGxTj/eo6NrgouAdxqThdLfkBl174JFJn1dghq0RlkUhEpe/GJPVt02w0iX6bjmBI0u4pQgkWRNxLgXtefok5pwYvYqTZilDp+v/MzyT6k0ZWxYeDml/l4sAgg4HLzB8+1CM4W3oZ9IlJ5rxWBVTPZd0wTEjDUmkktpB2FhYQ4AoVQKKYaufYQdSninoAaGDrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5612.namprd12.prod.outlook.com (2603:10b6:a03:427::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Wed, 21 Sep
 2022 10:34:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2f04:b3e6:43b5:c532]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2f04:b3e6:43b5:c532%6]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 10:34:23 +0000
Date:   Wed, 21 Sep 2022 13:34:17 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     petrm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nbd@nbd.name,
        lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        matthias.bgg@gmail.com, amcohen@nvidia.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 1/5] mlxsw: reg: Remove unused inline function
 mlxsw_reg_sftr2_pack()
Message-ID: <YyroqT8a0InvBaaL@shredder>
References: <20220921090455.752011-1-cuigaosheng1@huawei.com>
 <20220921090455.752011-2-cuigaosheng1@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921090455.752011-2-cuigaosheng1@huawei.com>
X-ClientProxiedBy: VI1PR0602CA0021.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: 0559a101-4b5b-4d59-aba2-08da9bbcd97d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHMyTjGph2JgvDnuluPvxbRXIdS0T2AEFYYEpkssl7laOU0bx+Tc94as/lN348AiuGpiiqHZLOyCEvnpmHlpXgjuEPbgVEu1PCVbkWkOOOnhESoSXxYsAsFHZdMuxj9N2ai2Tu+sIX/e+G5420CkK9KBUO7qIBhB5TIVX5Me3rFGW1b2+bME5kOQBWzTpWqllHpmQFKVrDEeL64s8SzLsbjY62VXg0ZLgMrehMaQp0ys8UmxH5KXLbWk7MkHJOji69SSelhb4/92Uf3xDsXgAvHY+thz2DkHl/Gvag23jHJQPn0izKyYG2TQ8Q38gofAYUYkjNP4oFnopzSGLAbfKjyUPqHQY8+sLUUxpxgljuiF4p+cWl/dEcHhclo8+KfRhuU1f/OIWLDNNfZdFD3GAh3hvBFEXQOnMJtmdQA23D4soZDNjqA4W7ZBAzVYfe0Qe7VMHcbOmAPSxR2GDWTrxk41uNbMSq+i6VYN5taeGLgtRFlSvBc1mDfGYLxG+P7qFSxLZXQuIUUqGnOLJCNY6ImwBM+96rLdKRFu2Dd1ob+3LoBvHHfgfOhP7/nmazEKsgBjCq2Jd8wrCtCa/vhoo6xX1G5ettncnEqAGJRHAsMGUChgDi8k2JHI9sdWiL58DofqPN9fzi8gaio9QeUHdfbY2DQ8rhYx9DaGoWkp2t6wS+/j17m7oUF4CGDIctTTCPaJeJ47B5kuVxkn95O7JEyveBvLl9oP3ocF4QPEOL46iP/M5pqS6+r9E9ImLv9Nuy3UQO55YuVFHDSGwDkrIxYiVmNNUpgVThK0krmCgnI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199015)(966005)(86362001)(38100700002)(8676002)(33716001)(41300700001)(66556008)(4326008)(6916009)(66946007)(66476007)(316002)(2906002)(5660300002)(7416002)(8936002)(6486002)(83380400001)(478600001)(26005)(9686003)(6666004)(186003)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?05ttYsbqlAqZtgq1HfwdFbaezzVwZKQ4whfXskYHPcWFktuI14yQg+2Y8cYh?=
 =?us-ascii?Q?d9PZb30DfjEhJuSSQOfI+r3ToL6BGOnkfNtvy8SlP4M0M7CmD7MzLUX6LjLr?=
 =?us-ascii?Q?q0cjSH2PwEN6GUKrke3B0xHDv1dag71t7lZ8j6SGEqoUAZwcG0xHm4LKZ99Z?=
 =?us-ascii?Q?TfxeI1xtDG2HFItDuRFwPYDYsfk0ACxLBvR5zfVsCYB9l8XYsh9uMe2/Nvkl?=
 =?us-ascii?Q?VJsRdTjX8ouZbjxHuBbV2SZLhZa43C1o8rE+7tpUYxRu7+28wognvRW3j89S?=
 =?us-ascii?Q?Zqmqc0Cm4230yKWQYqvF0L0rw8viLErDQw8iKBz5IWi5jhrgj6Xl61U5AQ8E?=
 =?us-ascii?Q?h1mXjZBW4YMlZ6AZ3RIsbbZ28786gOSDMT1DQi7oKAbl0Pk1+tRzBkbrPdU4?=
 =?us-ascii?Q?5c+MXT2RCsTqIyMRe07kWR8/HKK/Ar5ZAJr4uHWGqL6Q1IywDRjAa1aTOUWj?=
 =?us-ascii?Q?WymJ9bqX2pQhUNeV3e9wYoo7CiHy9ffqTwaIGckX5u8eCXR7nV9Jow2qEv3W?=
 =?us-ascii?Q?qk7w8jx+m+7ndljLu5+h5GATgse9cWvJwxW+r9J56/Ud9sgr5QDvW5I5F4Ul?=
 =?us-ascii?Q?7YJeg2T3gfmOhjQFLrhjWlGNAr++pSXnoZKHYOg9IwWvb7HrdI1SNtQiHrRQ?=
 =?us-ascii?Q?zjRC9bYDz/jzEghRSZg/XX8b5nr/cH9pFztYviMn3FO49rO4uCOHAsBeYGGH?=
 =?us-ascii?Q?LkWWGO1VxSn/aJL9cTTHr10pakF2xAeY2oTk35hvFIQk4Rdh94ko6qweGbg7?=
 =?us-ascii?Q?LhZKl9ETHYWUjis9qobd+egkw/HjtND/IjxdURlCwQZIYRKztciytnqCw5JT?=
 =?us-ascii?Q?LwSFFlPCtLnHa2Bcr/o3v3hpCJYCc708HyaIYpAjvpIlPzHQ/Mxdkh3i0vO9?=
 =?us-ascii?Q?7LsnodalbgqeGaVN7fe0iRqD2RRD5RjcFzP/sHy8kf9LV00ntDluBsyR3IWK?=
 =?us-ascii?Q?9PHhUfCLQnsGIfxez2sudc88gWM7eAigcC8Etbv/R3Hny6SUv4SGKiLOMjgg?=
 =?us-ascii?Q?9Le/LrrBjikA8st+q3BcsKczlIbb7WqzKOA2DlhjWd0edpXM83kJR+CEr9Fi?=
 =?us-ascii?Q?QW13JwTZGqrU0lv2Lq/1w3tsePKiiFOiL6xnzUMI2+H1o56TdL1k1vVj3Vak?=
 =?us-ascii?Q?r8+8H5JAU1pRjvG/pAG/WNv2G4oOR+fXS9U94TlziCsXwKw/78CknH8Gjrg1?=
 =?us-ascii?Q?mKL/auh6faETSNcAT5NclioGN80JXodPvNpJussEr+RaBOhIRiOACSBXi3nm?=
 =?us-ascii?Q?WcVinqoMHHyH7+GSB15MK7ruNH+y/su6pt5ZHvd3/M2V1o+NnBXCyxPwGRSL?=
 =?us-ascii?Q?dZ2tdHWfUwdJ3LsfuAmJNSciGNy/X99Rc35nuDZOqEX8ae4RKo1nSMHUSYpP?=
 =?us-ascii?Q?/cOi7q1h6k3CVlx0ckodvf1ORjZjQ6rIjlALOC0ekQbCthylLWB74sHmtSi4?=
 =?us-ascii?Q?Mfmh/389Z8B23lN9BxjtCVTaDBAXfDKtOrDHMspLWVudvKuWedW+nLO7d0BX?=
 =?us-ascii?Q?UakIOUWtEhs1Zg4Ax1waqZcoVpnlqWelk5uMYpixWnJnwa8I5P8DNGPBPgBw?=
 =?us-ascii?Q?SXkXsrm0bAn9+/LFSOMv56UrcT5eOSA4+jtZ3K39?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0559a101-4b5b-4d59-aba2-08da9bbcd97d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 10:34:23.2645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1p7ZpbEOIiWcrl0hWxKlpEs4zZCdv6zegIiC32VWj+Nfr/O74VGMGWfrE/+E5XMyJAGZSr5EXl3QfhbWHxQ4jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5612
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 05:04:51PM +0800, Gaosheng Cui wrote:
> All uses of mlxsw_reg_sftr2_pack() have
> been removed since commit 77b7f83d5c25 ("mlxsw: Enable unified
> bridge model"), so remove it.

Please rather remove the entire register in v2 [1].

Subject prefix should be "PATCH net-next":
https://docs.kernel.org/process/maintainer-netdev.html#how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in

Thanks

[1]
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b293a154e49f..1cc117c8f230 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -2251,76 +2251,6 @@ static inline void mlxsw_reg_smpe_pack(char *payload, u16 local_port,
 	mlxsw_reg_smpe_evid_set(payload, evid);
 }
 
-/* SFTR-V2 - Switch Flooding Table Version 2 Register
- * --------------------------------------------------
- * The switch flooding table is used for flooding packet replication. The table
- * defines a bit mask of ports for packet replication.
- */
-#define MLXSW_REG_SFTR2_ID 0x202F
-#define MLXSW_REG_SFTR2_LEN 0x120
-
-MLXSW_REG_DEFINE(sftr2, MLXSW_REG_SFTR2_ID, MLXSW_REG_SFTR2_LEN);
-
-/* reg_sftr2_swid
- * Switch partition ID with which to associate the port.
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr2, swid, 0x00, 24, 8);
-
-/* reg_sftr2_flood_table
- * Flooding table index to associate with the specific type on the specific
- * switch partition.
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr2, flood_table, 0x00, 16, 6);
-
-/* reg_sftr2_index
- * Index. Used as an index into the Flooding Table in case the table is
- * configured to use VID / FID or FID Offset.
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr2, index, 0x00, 0, 16);
-
-/* reg_sftr2_table_type
- * See mlxsw_flood_table_type
- * Access: RW
- */
-MLXSW_ITEM32(reg, sftr2, table_type, 0x04, 16, 3);
-
-/* reg_sftr2_range
- * Range of entries to update
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr2, range, 0x04, 0, 16);
-
-/* reg_sftr2_port
- * Local port membership (1 bit per port).
- * Access: RW
- */
-MLXSW_ITEM_BIT_ARRAY(reg, sftr2, port, 0x20, 0x80, 1);
-
-/* reg_sftr2_port_mask
- * Local port mask (1 bit per port).
- * Access: WO
- */
-MLXSW_ITEM_BIT_ARRAY(reg, sftr2, port_mask, 0xA0, 0x80, 1);
-
-static inline void mlxsw_reg_sftr2_pack(char *payload,
-					unsigned int flood_table,
-					unsigned int index,
-					enum mlxsw_flood_table_type table_type,
-					unsigned int range, u16 port, bool set)
-{
-	MLXSW_REG_ZERO(sftr2, payload);
-	mlxsw_reg_sftr2_swid_set(payload, 0);
-	mlxsw_reg_sftr2_flood_table_set(payload, flood_table);
-	mlxsw_reg_sftr2_index_set(payload, index);
-	mlxsw_reg_sftr2_table_type_set(payload, table_type);
-	mlxsw_reg_sftr2_range_set(payload, range);
-	mlxsw_reg_sftr2_port_set(payload, port, set);
-	mlxsw_reg_sftr2_port_mask_set(payload, port, 1);
-}
-
 /* SMID-V2 - Switch Multicast ID Version 2 Register
  * ------------------------------------------------
  * The MID record maps from a MID (Multicast ID), which is a unique identifier
@@ -12876,7 +12806,6 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(spvc),
 	MLXSW_REG(spevet),
 	MLXSW_REG(smpe),
-	MLXSW_REG(sftr2),
 	MLXSW_REG(smid2),
 	MLXSW_REG(cwtp),
 	MLXSW_REG(cwtpm),
