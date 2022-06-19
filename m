Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250B95509A9
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbiFSKax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbiFSKas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:48 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2232FD25
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jlcdn8I5KujJj21l1JVGZPk/P3YfOlOhe+aVXrGciSPA9TVyRJ+4vq7qEQp5D5eE0vJM5Qqvilgt9ayuqiJBKPkJoKw1JDg0n0fsvxiLYinZtvsd5SEVef6u7luJNUh+vifNsNkmAfujNPadRqRwPicpuY7PP+IImr6qlvMINKlVoPxGgKAlCu6mzw2NVu15/XDisu53OKWkwVDe34r6XRYF8j9BxJS6WTgj1HzHSauES3NH1SZvk6Wtiow9iHhFn36QvWT6xM5L7RRlxUl2YP5a8xAAbuCDQeg+u7kk5fd+HZF6hMG4mYbDdutddJHZHEJutC5KQjA1xuo7MXpSUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15jfFzKQren0Qy3+7Sg/whiLW5gnem6wIMuySUSLmFA=;
 b=UZOYcsqRzLGwnmtYczxtkI0MIlrRU/bjp+Vw+P5orIeuwtG0Nbp20YdvquDFtVQqCV6dW5eS3XD8+CbdwUCcUsEJsoMkcQr2hyk6mSTP69scIhsYKRpr96ANKWKJsN+Yv6WppGFT6/Yj8wwxrZMnHvwZxkQihcIos6btKNjjLWp7q/5rp3WVGnZ/jUsBzayDAPmpq6R6UZme6Lo3oSrsEIdyWdATkTQU7IdFhMna6ZnDI9k/D1b1353Zq7zcIMu6dzeYmjY+6uRWKYbsrT09L7xi3J3/tcCYw4NTzTxoJTjeHy7W00iO9VM25u0nPBwNY7KyJx/GxwVZwzdSpoEoNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15jfFzKQren0Qy3+7Sg/whiLW5gnem6wIMuySUSLmFA=;
 b=AySXLzW9tkxb3orWrrl8vE0m1ZjYLHM9/JCr/ncuOqGc4GJovfdLSdleFQxRuOLB8waeM9pyOKG5EgBGjpQHSfVJsAeV851R+eILewEhaUGn/Cwf6Ai8shQ2Q4GB67sfeRnUvPu+7qNzs54XAG++pN9dgdBqhEjNNcbnAFiqPSST2VMCOMSGGi1pHNKjkmYfzYoQqlrJRVolyRqnhJcZJ6+m5Zrz/tVu/8nvl4JuddIaxDfRzE1zDwKBt4bOt3IW6VUGpmSfh9BNyI1TvpOVKsThghJbzsjOwAQGh4o//sq8zDzmgisKZd5TfeXkc4RbZvxB36kMI55W6tqH7aBY/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:41 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/13] mlxsw: reg: Add flood related field to SFMR register
Date:   Sun, 19 Jun 2022 13:29:16 +0300
Message-Id: <20220619102921.33158-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0023.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec29dfd8-61c6-427b-7ddc-08da51dec237
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1193057CA93DFD2713274AD3B2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sn5dmTdcLImnx6FwcPiksMdC75A/yZdAPoIvRxgsD/vjXVxvE8guM7omsy01tsc6RVsGL3+yaJZ3O6L80pNi3hO6lOKqwUzxHKINJ5UZAdm9zOip7EXpfMu3vdwu3QtEi7oUyUFx48E5cHZBpt9Z5aShpvvxDNEr12cptnKnr0Gwa/+BbE7x6q+L35Yq6hLkMnh0hRQ7zpWFwEzz1MBpxYCB0BgISBZ9krhJfsmz3U+ipFQT6hXkbNxZPFS1JuwLKbIE2Zu7coEjMP5g3Onhn29YXleN8w1raECUNUlur8OwLnTA/yYL1alTJ4YcOWgcszDz/jeVARnvtuFViMMdtjZq9VRmpTOCFPpx9yGajjNZfH2qcE0ufA0MG9tADm+TJ+PTtnjOqWtdcp0dFnIZZJAUV/uc66J5j7dsJ2OOIx3Hghxy0NgnxJSWebI+xHL8ZkPL5SFkKgsCjrntjmrBsm4xT/Wf5XQkDPOQJjGYKoVS/7TIbFR74WC6cm4O8+WG4Yv7Ndc0eV3aoDgvzE2mHxVlc5Q/e+Hd87eGFkq7E5xhqCK2SB27cJim2jAN5BN2kio2Hpp4EDQahRzIW0R9IKVD8J9/QGhLTi7JW0t+qQ3dArXroydhiv3cSKO4io9/2rL/qLFd650SHG5IkgrPFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lAmKdZzQv9yisEr90RVVdL10PHpjIj79oetp63/uP8rog1s+J1SkAppeegov?=
 =?us-ascii?Q?K2n9RBXGgUzFgStyfFKVk21DO9VpkbXDwxnZceJzfzhs17C+TYnso8zkGCdh?=
 =?us-ascii?Q?Ti3rtfNH4aDvs4+NZQEn5nFVEAjb8FmmAtXnkBuoWP5ZOfgWeZexSGRNTc+C?=
 =?us-ascii?Q?2JhrOoQusQmIg2TQPGok5jlUMnKvSnXNLK8p8QH/PmcUundhifCVMAAgzDYP?=
 =?us-ascii?Q?XM7vh75lYwybCK6EnGGKcjrwlKbjIaGHPIbnNprpIaMsWj/4FZXInUENOQBF?=
 =?us-ascii?Q?nsuS7+7ocXS5U8mk+iOmb2TwKxrBIN3v5nscxL7ovNyixAfdb9jPI+4aGP2y?=
 =?us-ascii?Q?SVWQ4XsOoZgM0ezJIMhcIp4DTiDMmaJ9L4V0dqbh+i/oeM1cZOEMoXy1NHm0?=
 =?us-ascii?Q?KYtaA+TbdbwqeD9W4TgQlBRFqo+TOZT5cTLzeOZnaMFpH6mpQVchXZHnPr/w?=
 =?us-ascii?Q?DX3cJpkAJjhNsDZ0z1qXs17c3RIVyum0iVS+1TJncQSpnQnXgCu08ufJNtVc?=
 =?us-ascii?Q?Oka+grsAUx+2O8yp/FfAv74bCRjAtx/CWY8CbnRdoXJXXcXT1K+SZNP6vBYA?=
 =?us-ascii?Q?R0/O1NBmpX/D3Zzru3bKgNOQwSz3OIyCobsGXNKbChE3PBzJJDiQEdZsnts+?=
 =?us-ascii?Q?qGFz4yRujkRUh0iieIHk06034W558PqA68qygB9X2qc9tCRjapad5IWNhQHC?=
 =?us-ascii?Q?/1wG7g2AJuPN7fPizWL0lNeaLLV4h+nnRHyxkG6uIv4lRf0zbrSpGTcYcGm8?=
 =?us-ascii?Q?aZSNU36ADk5k7k5+gpjwJlNtsnK1kuXheSG+8sy1GMWkndxRKeKjjeAzg/IA?=
 =?us-ascii?Q?2WpFaRgxNT+XkaCRv4tBC9H7LOpolX8V63ggeTcj8Tq2HL2UAx0w6WnO/nxx?=
 =?us-ascii?Q?s9OA+/yKcePDuU3A1Q2hVfpb0K0pooJNDsw2waPAY/Ol7ZPU7J9dlgoxEyKV?=
 =?us-ascii?Q?IRh9t/ZRqMkbywws8QgJvog9cLFsmDz2XH2vz7FmHhmBMq2vMl2CWTq01jBo?=
 =?us-ascii?Q?18WNCvNKwjh3vQOVqVcpkrRqKRtYsUhzT6CMGP1CVf2bBMz+ExduG3/5hwnU?=
 =?us-ascii?Q?DZnAO/V4MBUzbZwGjYt0/0Y7bL7qlXDtHm6BbfmzV3Ew5lEticzSBacb1Qd8?=
 =?us-ascii?Q?0rfeLyxiJOO6/k3Efnt5zPps47URjipkUthEr4vpKggnNTCLjQgvfnwND9yr?=
 =?us-ascii?Q?RvndOSfafzpoMpoSKbtcWWNcRFIwrktnpTT4g2DsTOJ3Ew2o4umEGEdYBPwP?=
 =?us-ascii?Q?BU/BErfpEly+Ks1DYwA7rNoJH6wxHstkUrt29lS+MxeqP1KRdMxEH3qeAFcf?=
 =?us-ascii?Q?Kd7Vz0jsGCW0gI0IAg9y3m0VqYZeiRBQiKV00KWVX8tM/PTICNEYhcM6z0+3?=
 =?us-ascii?Q?a60vOnrJ22Ol5dbslUSZ8RojMhAMTYw7twlGxmPvA9lznUbgbzjXxeTItBUR?=
 =?us-ascii?Q?USkSNEhREz7qQ406IdnfCfXotxQ3sBPz6ZPVvwVedUzW4V3zHVp4dOnvi8Da?=
 =?us-ascii?Q?SZXJjVXk8j+Qf+pTRTiYxWQiALlV8qs0EF9kpMmHipPj2UgutLf6lTfdWsic?=
 =?us-ascii?Q?AO8J+NPl0K/tdu9GF1gsLIKTm7CDmBYWhCNcRtSTsMurOGLFwkZKnpR6fmfb?=
 =?us-ascii?Q?OanmkIeMPXkCV1LTBdetgTWfXTWP6CfQvDb/GOWLpK8LGeVTY7WtRyIcaarf?=
 =?us-ascii?Q?lySOK6TAYV2qJftouX8U2NxTjVETUsOSgcSUJCCrXY1UzZn9L5ROzGyWKHgr?=
 =?us-ascii?Q?LbCzgcgbmA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec29dfd8-61c6-427b-7ddc-08da51dec237
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:41.0446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iADaiiWyDipdn6vv7HX83OzwnLdy5IBG8LjmLyJ48Vo5kxscISNHWOsW8PseLTTrdG83/6FYvFvkxLacs+ugDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

SFMR register creates and configures FIDs. As preparation for unified
bridge model, add a required field for future use.

The PGT (Port Group) table maps multicast ID (MID) to
{local port list, SMPE index} on Spectrum-1 and to {local port list} on
the other ASICs.

In the legacy model, software did not interact with this table directly.
Instead, it was accessed by firmware in response to registers such as
SFTR and SMID.
In the new model, the SFTR register is deprecated and software has full
control over the PGT table using the SMID register.

The configuration of MDB entries (using SFD) is unchanged, but flooding
configuration is completely different.
SFGC register maps {packet type, bridge type} -> {MID base, table type},
then with FID and FID-offset which are configured via SFMR, the MID index
is obtained.

Add the field 'flood_bridge_type' to SFMR, software can separate between
802.1q FIDs and vFIDs using two types which are supported.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0600ede2eb7a..c32c433c2f93 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1831,6 +1831,16 @@ MLXSW_ITEM32(reg, sfmr, fid, 0x00, 0, 16);
  */
 MLXSW_ITEM32(reg, sfmr, flood_rsp, 0x08, 31, 1);
 
+/* reg_sfmr_flood_bridge_type
+ * Flood bridge type (see SFGC.bridge_type).
+ * 0 - type_0.
+ * 1 - type_1.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used and when flood_rsp=1.
+ */
+MLXSW_ITEM32(reg, sfmr, flood_bridge_type, 0x08, 28, 1);
+
 /* reg_sfmr_fid_offset
  * FID offset.
  * Used to point into the flooding table selected by SFGC register if
-- 
2.36.1

