Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE74D4AB047
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 16:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243952AbiBFPhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 10:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiBFPhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 10:37:13 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A37C06173B
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 07:37:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVxoQeeBgWNWdIOUcdYBPEZz4a6z13TjXmQVIVVpNwhH6eo2NnD2hJ7aBBc+Z5AZp1Z7gKExFKeB6jK5k68HMNbO90z1Ks+3dd0CdgYG6o0Y14KwJIdyonwM5GN/5zWixYCo+OXpRz2TAoeuAtiyw5jUrj7oxtf0YWyz05KMdv/gDSFYcawjbZX0UqPjWXEcR7XT0Cgl9S49JKgFQOPsyiiDyfu3IPATBZUJglQwAKtZiaKdno/CnDQ2JyXtfeaGvji8oCiIEhwzeRAxQBwMTXW7jOL3CCLRdcKTO/QyWolajA2wpmjGy1x/5yI8+KVykKkNWzoU55LqqRJ7vMPJ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5rbI3ZrwE5qvAfbqgd6lUQlky5aDsO/UaJ/yttW1ug=;
 b=TM8lBGfFETgSdSsv+RO/oyZA7JY12KUVh+Sx/1aM7ynoCQS9bUcCzjipuwW2b9JATt4B2kBTIY5NBcQaH1HvlUXgPJ6NWryX3GixSD8+lvOvpNtVNZLHXjRiKCSoMkBex+nzDFuze5gCKnXzQrEkE+7ZGt3cvZ+yBKeGnOmiJlJ3UTEtWK84e908NbROelZW0NX03XMnmzz1JcgYoyIjvjCgn5DD4QxGQFwnoQTjkZT/PwNb64mn9qBKNzTWlZ9QAR3XNGLSO2YSScQBLRexUd+ltCX2gLq4nLDIBlP/rUAPn48+ERUTF4RPVIfU2zZ/SqSyBEOFYAraIIsuH76Cdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5rbI3ZrwE5qvAfbqgd6lUQlky5aDsO/UaJ/yttW1ug=;
 b=UmfckGhuFrK9H6404S+u2QR7Lhxe967IOko5Lgy1dESj4btM9uIMzpoCEukzcUKrUyy2deOCG7FEPXrV5nS8OrZRLnjWXvZ5+j+0PzNvAfLflen7CM5cZlwj+pqXKoBhcuWbZTgmMYIHJaQjHwh+JaYFqaTbb3Vsxk1Plzzztd2IsX6YM8pagUCi1j+WYIx0WdAtjyWXBlRMRsWNeRfMGQzA6tXxawOnfubVU8RqqthPNb8HrPrBmeBwL6ZU/ma1FivvoMtr6t2AaQC9zOTRh0O0PdFdhMW4aKD6/Kf4yTQzZbqSxwdmq0KrHPp4PZZV69BIrldRE35VjVryjicy8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN8PR12MB3395.namprd12.prod.outlook.com (2603:10b6:408:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Sun, 6 Feb
 2022 15:37:10 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff%3]) with mapi id 15.20.4951.018; Sun, 6 Feb 2022
 15:37:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/4] mlxsw: Add SIP and DIP mangling support
Date:   Sun,  6 Feb 2022 17:36:09 +0200
Message-Id: <20220206153613.763944-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0262.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::29) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27749849-e8ad-47d3-fb89-08d9e98689d1
X-MS-TrafficTypeDiagnostic: BN8PR12MB3395:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3395CA0199C017D43CBBCB1CB22B9@BN8PR12MB3395.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: US+NO97WDDVruq9i6yHtHRECc13sRLO3YN6EUOYpl5YDnyre0n5P8ncmGjECH6lQPLrG0RMzhpfmfYPtrD9BCBjNJUAy9/+AB3aLeuPLU7Iot1w4rzLeoHiY9G/bwEy5mLE01sRWV5QTTgDHU2j8R+k84NGqsYg6VSumr7t2DmVYp87eog5Pg0EHQ+G8j6yZcDYwPsjrP8nmRU6/EfESmcmzB+RaRzdVglz3F4vcCtWOsWwo1jNMQcyYMPRGoJU6VLRFqvenEWoztynTmBdzcIsBqJp0pg3gAQDKtSpZWqWdy3MlFlg+lesB0Vm6o8ygC9KJo6KEny4fK1yIz1rd9YX6SA4Arz9/f3DXGtANqpe04hi1u6cF8OXY60XA9YUpgTRcdBbVtqBI9V3PkgxqzEPPtAQ1F+NCd4rZU5tG1HT+UL/nM4FSOCye2Pcii2/i8k0bIS33fiy7Sioqzf92piorwZEWt6u76PNyMABTBrOFN1sDkY7YuihyWoJedc84tlEgDB49ka/ZANVQJELPFPX/6BXHalnrLVS+SKKsQn1Bcw2oHaQqHgsKBGEuT3Yhfb03SLLB9aHVqLAr8FZgf3OIdnhidjVVtzAY+l3uFZuT0JB9lgWoFcHa0NA+pPwDwxldf9MntwOJ0rlQmGc0FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(26005)(186003)(83380400001)(6506007)(6512007)(5660300002)(6916009)(316002)(36756003)(8676002)(4326008)(2906002)(66556008)(66476007)(86362001)(8936002)(66946007)(508600001)(107886003)(1076003)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VC3+iivCyAL48FTHMGzIiEzBpo4C/6Kfht8vyCH7ggr1n0zxBdvH4/zQw9v2?=
 =?us-ascii?Q?+qgF3bbVMXbMdTcQuHe/me8lqt9oNTGhYYkc9BHknMJBTnRApJBUbLvIUZhp?=
 =?us-ascii?Q?JDqFRiXcQJHGT0l3Z+yGWYbi7eFoVl6KJEDCxQAO1pw79UUhSTu2fqij7nhe?=
 =?us-ascii?Q?+Lj8tfjGNA026AUJU66whrBDv8ffVo4mUi4VjdCGALsF5W+Il3h9c3G3RBfh?=
 =?us-ascii?Q?IO5Sq8omawHf8kczY3l6VA3d1u5eC7cpKQqfFW+bgVTMRRb1en29drXEp03L?=
 =?us-ascii?Q?rU/0APYcdmC1kMxVFmN7NNbti5M3XqNzbKIQFJWkqqH+JkQeZx8LZSLnl5uG?=
 =?us-ascii?Q?YXzy5R1nFJ5v18rYyAtC+rpu2FHoWP3nyMKjgcgiiV0o2cx4yFoUCnXvgSZI?=
 =?us-ascii?Q?xYTx5uVgJYTZfTD/HrzuRYl0btdhPMQKEB95qAbPGPZLRRSxptIW+xRPLipv?=
 =?us-ascii?Q?bx7rIHeU1hifKN0/z9dhec4DiAK1wJxQs4QMrQvAlzc1Q4pm/z2dM2eJd3wj?=
 =?us-ascii?Q?+iO1DO6xdmgJUBgAR2ZrTYAzggrBc+HGxRBv4+S3OoVSLRrBbS9Y7u/KnTeG?=
 =?us-ascii?Q?YetyPexo1x2k0tT2BRqtCrNDOexUasXOjAU1QI3NuWuHwLeKS4/336qlLGJY?=
 =?us-ascii?Q?TtUTLDXB/LN/D3ET7A8zh259A1SgwUzhd4v8Nj8r4BkujrQGK0dQD5Ab86GV?=
 =?us-ascii?Q?V0gDPUvUWRPv2UYFsmwj6xsFfIpW9QEk8/R7ds3MJqrs7UbpZAzwNNX2keOn?=
 =?us-ascii?Q?+D6b10kemYh53eLScdB6QeG92GfRpDYkZQnP+713NuN7AQNklOeQUJL8BvmB?=
 =?us-ascii?Q?LUoOM/YTcD0XpUCVFRruR/rfxAFD29czIQAnegCfmywcnyVkQflPv00nQ4eA?=
 =?us-ascii?Q?BLl3V3euyM9CYNjGO71GwsYs71fwwAGq4Pjvae0iVzbXeCP1r/RKwdWmEg/B?=
 =?us-ascii?Q?Bo8W0g1o2KrEd2K+6VdFLCisnuM+uqpcAGcLkY5DDYg/crdMbLPgrtkE48VE?=
 =?us-ascii?Q?0z11NMJEu1r2jbIil3ciPgUMwqV3/CGntO83foYu834vv6hAfXwFJCnuGN3a?=
 =?us-ascii?Q?2QCLYPe78JX9iJE1553ALX7p+wziLRq5SfxVitFTDhButH2uNMZsXnb3GP1h?=
 =?us-ascii?Q?CpkG5I1nVNfvYVDIABVyxXqlDN02z/4vzCK0yFVByo91sAcz7dRDlMLd2hpq?=
 =?us-ascii?Q?mWFY00DkIzCwrHYq1X7Cul1u8S0XcIkcmFnTTU2x8QWFJLddkSNncRx0MUjY?=
 =?us-ascii?Q?nxjx3dnbasSwDPxdu7ymuTrqxyxzSKDNqtb4wtraDO660pJhjEiSgLZM7iyf?=
 =?us-ascii?Q?vKV7Tv8WQfmb/1P7/esokxI6hiro3xTHqWb1SGOwZLkZzi8ZaC1n5dOHdKiS?=
 =?us-ascii?Q?LePyW/c0n3tCeQhAeZlxhtcDb4Dq+6p+6Qbv8ZjulPWYfJteeFPN5gnWGNs4?=
 =?us-ascii?Q?DeSreUpxKTYfgkFIbF8cofHT7t0NISCa91rJfSu/88W9V66qlQjRDfR/aM57?=
 =?us-ascii?Q?To58BGlqpQpiRWrc0wnHavMjDeeYTwNqsPUf8ShWqWDXsrO031pjDfal7ypr?=
 =?us-ascii?Q?QsAHGuIncq3upszwNBNKHQPm+ZLtIdx4XfNcD/WvgI9jaCndrvmbiqPyCdcg?=
 =?us-ascii?Q?I8OwcTKI49ROcyyIm6n9ehg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27749849-e8ad-47d3-fb89-08d9e98689d1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2022 15:37:09.8171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0CIBYnd2hMKBOooDz2VmIa/Y6rAMCjhvXlGmurwTW7d8J0yf959DbsG+LjXMupceHvob0CdluuhJ8r6nuEEGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3395
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Danielle says:

On Spectrum-2 onwards, it is possible to overwrite SIP and DIP address
of an IPv4 or IPv6 packet in the ACL engine. That corresponds to pedit
munges of, respectively, ip src and ip dst fields, and likewise for ip6.
Offload these munges on the systems where they are supported.

Patchset overview:
Patch #1: introduces SIP_DIP_ACTION and its fields.
Patch #2-#3: adds the new pedit fields, and dispatches on them on
	     Spectrum-2 and above.
Patch #4 adds a selftest.

Danielle Ratson (4):
  mlxsw: core_acl_flex_actions: Add SIP_DIP_ACTION
  mlxsw: Support FLOW_ACTION_MANGLE for SIP and DIP IPv4 addresses
  mlxsw: Support FLOW_ACTION_MANGLE for SIP and DIP IPv6 addresses
  selftests: forwarding: Add a test for pedit munge SIP and DIP

 .../mellanox/mlxsw/core_acl_flex_actions.c    |  77 +++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   3 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  25 ++-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  91 +++++++-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   6 +
 .../selftests/net/forwarding/pedit_ip.sh      | 201 ++++++++++++++++++
 6 files changed, 394 insertions(+), 9 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/pedit_ip.sh

-- 
2.33.1

