Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3173049DD37
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbiA0JDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:03:05 -0500
Received: from mail-bn7nam10on2076.outbound.protection.outlook.com ([40.107.92.76]:64417
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234542AbiA0JDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:03:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwJEnDmOGZu/Bh07rfT3TF5tjaBCHPgXlh6ovoxLp3XRyAiiDlgc5E+iG8X4Hvy5hV8pYmTam8unLhR08ewLbVAMSv8ENKgXNIB4/8FITmgPrMt9fVgGFFH8NBaiZ+RkPog3Ov9bg1uP2ISQVbmF9S985baRwgmoWCyTKY0QTSvP5+5An/ER6C6gqCiNLH4Db2jjPervK1ZUx4HFCwMeJqTnH0Z7WGsH8fDQa72lOAVzfnkHgotWDSr/4d6ilfpdUmORGbw2hB9EXKvRInU5Ampi8/MAglfKSWscOp5Ue3wvd82DrEP+VMFWLbP/NcFyQu6ilNItSduDGptVIRZ4cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtD0nXfe4McTPS9UfAqblrn9T4QrlNQuX3KV73TapRo=;
 b=jgMmy5MIHMupykp2DzymMuUULeU+V8b1np5vhzs6/D+95vYT/cJOxU/adnCmgcEs4oZxx72KiEqiO/XNE21nE0ReXQS0FduZ5hgT8OniwxhtV5VWG898+2vG+H2hsLYGo1/3adVXDibOLTNkTopDcgUnq5fVen6ifWrS0VN6kUJj4awLGdkWq2GioJoU5T4jl2TD2O0NaZE3oMLsBbNDcUB4KTKT+dt5dcdyfZNYXJV8Qt4EFH+TycK2aYBE9cYkIoIQP2behi7PulrtWB1uEB0E2wVsvc/cmpX560EPipqQKoSUi5oaxS8bxSWzkk0azS6kzpPz5eu9RlvEi2gjnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtD0nXfe4McTPS9UfAqblrn9T4QrlNQuX3KV73TapRo=;
 b=j8Qqt1nGwoAihm9HHfI8rVkXg96D++/MZOi+lUij6fj/hgvSSNNcMsb8IKDWpEY4gWalt6Pu29TAHVs7LDLvdftWBxTAXi19XR8Iq2uy8ymNbKA6Xa+55W7w2coWGO4u7XberM63MU8vsGuvyY1WllOH6iiH3IBYUzKdGM2zqB0NQVMyE/4C8M2gS9z9tKI96I7KciXlrYhNCBhwOjoTaxNJvga8+dxZG59fkuM3/lYkw4DU10aznvqxYoBREQ8YFWeKw3acONgNPikc//ZwQNHi6q9WDfaCWy1sZbp6gUnaBH9R3tOoguWFKOc3yfP/pMO0Tk5Xfyea8q8ZbAr7lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 09:03:01 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 09:03:00 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/7] mlxsw: Various updates
Date:   Thu, 27 Jan 2022 11:02:19 +0200
Message-Id: <20220127090226.283442-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0015.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::28) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c843412-5ad7-4fa0-2a3c-08d9e173d1b4
X-MS-TrafficTypeDiagnostic: BN9PR12MB5355:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB53550B54E725309DF3D4602AB2219@BN9PR12MB5355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2wxKAf20MxGxg3aQez4IPTHeilyMUODsuetuwWu8ztJzzBEiixbbYWRV/6KSXAdk49EEqb64DrtgVLu0k2lEAQyhfaSWO1+vIQYZfEdiaEDNz+Dt+CoyRvTSDF4vqg7ZfhxfYrz1GoZjO6TgELG7IgtFP0VVWHuZ7CbQROPWw7Svh3qURlqkpO61CZbywHNqesdEsKolPkNSMKvM/afcQp1RHBmSt/+/MweNhQ+fTnZsGq4x20mfbNHOBatyWGaJuGSXOwzpOCTYSouSZltzUtESgrDBpM0RPRObFgZ7ksav/Ijengh4molsYNC+i6CouiNnH/tNSQPF4YDmL1UjoEtRkvQGL+pCTkXFbhIfB0PB5PwzktzbYm5D6TK7VhrClGvXXm3dpuHfI1Z7Mg1THTVwJ57Lg6HHSYYcpGJeRuOkII/XO6EDF7VYCLyvLRyEwLJBZTEnXpcQowq5GUSBSlwNtOkoDe2CZaTlpYni72QEN9cu/A8xOpZkSMpcHSzcu8p5b3TFXxrikJ2FIojn2VHlSUen5bq974NfZSQPtvZxGo9psBCRWOVK3dUl57nQ2zqJDiDgLguJJN6s/rV9po3KcWQptYXICVrsGBKT7WQ5CdNSYXMdmWYw4AoeiefYNmz0PJEDQPzUBG0NQKg7SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(2616005)(6916009)(4326008)(8676002)(316002)(6486002)(66946007)(26005)(186003)(86362001)(1076003)(66476007)(107886003)(508600001)(8936002)(6666004)(15650500001)(66556008)(5660300002)(83380400001)(6506007)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aYxNjNPyo5JUUpjAEvCnC8CD5goLf+BlDCdXb3ntmeiX1bYgql8TJ+/WtGH/?=
 =?us-ascii?Q?hMSwpT6JchIOd0AxLZD7SQteQAfZYrhUN/NinCai11Z4MT0k4Y9oD0anhVFl?=
 =?us-ascii?Q?8E8Lenp/+yAP/Pv1pepL8mDgXdnaiuZKnJyO98z7i12+yHAG+Tze2gvNDIAK?=
 =?us-ascii?Q?5WKjrgxivrN175lCrc4743hZST+ynEmYr6t43h25RkbYleHsDsZSrkZEaOog?=
 =?us-ascii?Q?n0a9/DqS5juL1HHfoNfg6R5uof//Zlq6IgHM5gqho4KOwk8b/3PZDPYajU4G?=
 =?us-ascii?Q?P0Vvhld55gE4IOIX0ReksCY4vwb9JdBuU7fLjLrmqe7d0JDR3Jis7rM8XnuK?=
 =?us-ascii?Q?KhovxtBtmSYJ1s+OxmH5zOUiRBevrCRcGIbUwsJtylL3jWQD+1t+7iczbTt1?=
 =?us-ascii?Q?gDQSSnQ6vKdGJx5MKSTvk94flUGayiqgWOL5lfCtGQ+jmVymo97XjFwSr4+A?=
 =?us-ascii?Q?a8vbIuVbLz61bhnIf5x1najKGuLwSk+xwp5i1TViKJwRC2DXjPoazP1S+2N7?=
 =?us-ascii?Q?xa18CGTZ94UGyxWdZYD4BD7E/jgaZgab1wwfy/LDGOPPINea68VJcGpwtGPA?=
 =?us-ascii?Q?pnf8KXUoObXE/hV6iU8ORuI0nwC8YzlNLYFDfCdOPJdfflxT6uU6HGBemDz/?=
 =?us-ascii?Q?yZ9faQ1PimEuox1s8v6zHjtsp++EjQrOigo8vz6Yvq4HSOrOnbaUZWAZCP29?=
 =?us-ascii?Q?/N5tTFLnTbMpTrITBtpMzSpgPmCMprJmw0ehGd9UVtnCNKrSWj7ISgIhjO19?=
 =?us-ascii?Q?d2VlRGXg5MWMPbUTRKfFGBEsDv7LSdvU2l4bmLo/E/IpkNVTfgjDd7M+YppX?=
 =?us-ascii?Q?O74HVNzaTmo0Bjk77l1oZnULjU8zssxVJ3KFLR9dEROfW5UpDBEen7x1Q3bK?=
 =?us-ascii?Q?eJwBvsfSkLmjn/MGEacP98yLeogS2pnEUNIjMPAH7aYP4+swMEM55y1iZvJz?=
 =?us-ascii?Q?hl5Wh0TVb9Ko33wUiea0c6XnZhbYUl6X1OtH3bqdekz1Q+oezLKdQ6Afnnkq?=
 =?us-ascii?Q?hst4Eke2BH9R9sB4I3EF7RERGRX7KfLO8M3ZqRts4ZQEjFhJQ+5KfUD8mdX2?=
 =?us-ascii?Q?ClX5ITbOIeXfPjTOFkq8svYkONVuwxGxILnQD18LSzo0D9g6HQKfaW/mh96e?=
 =?us-ascii?Q?Ack8sZ64BON5PX73olWYFCP9yX0xkPbVOvSp2UrKq2errYxta1VA3pt1R0bK?=
 =?us-ascii?Q?Dfm454fXY8yg7VNxHeAV5so+4UUVFB2rMhdJ4sTg/x/UVk3s+fm1pfOShPw/?=
 =?us-ascii?Q?G1opkdiqTKolxjl3kHVzZgaiNB4ccOJkpQPmjkTf6FeJ/DLR3okkC64YIEVd?=
 =?us-ascii?Q?QsPtkipgbSGX0cFXV3XLcCY6K7kzbard023/GsM4HlVdFWpHhscXE1lrlZFM?=
 =?us-ascii?Q?t25tOn9xCn6Zc+ITwCc2HiW8/RN6LTtVmeaigx2Z+qosNRyAh0325PzLtjL9?=
 =?us-ascii?Q?A9FHCtRXKayKRFfZioS+XWkyRScZdUEL4yNK2POWATh72kvXmZJtgrGH+crP?=
 =?us-ascii?Q?Wz6OyLQjbg/23fv19dn1zQdWIhkX9jshpgFCBai5lktUcIcw7G/ccf5ZOhQE?=
 =?us-ascii?Q?7Tdh6KUhYwvc4Kn1NgYbl/MgK/Q0+UC7ui4MxxX263ZjOkMvOBkAKp9nSrJB?=
 =?us-ascii?Q?d66whfLFC33p4/B6AMRC08E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c843412-5ad7-4fa0-2a3c-08d9e173d1b4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:03:00.6776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1S14k17cK9GedCPgM8FfE/cuZCWlsqAyj0l8dJelmwC8ySoQJ+EFtV2wC5GgPBI+R46oxv6S+4Z+P/I2+HtcMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains miscellaneous updates for mlxsw. No user visible
changes that I am aware of.

Patches #1-#5 rework registration of internal traps in preparation of
line cards support.

Patch #6 improves driver resilience against a misbehaving device.

Patch #7 prevents the driver from overwriting device internal actions.
See the commit message for more details.

Amit Cohen (1):
  mlxsw: spectrum: Guard against invalid local ports

Ido Schimmel (1):
  mlxsw: spectrum_acl: Allocate default actions for internal TCAM
    regions

Jiri Pirko (5):
  mlxsw: spectrum: Set basic trap groups from an array
  mlxsw: core: Move basic_trap_groups_set() call out of EMAD init code
  mlxsw: core: Move basic trap group initialization from spectrum.c
  mlxsw: core: Move functions to register/unregister array of traps to
    core.c
  mlxsw: core: Consolidate trap groups to a single event group

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  75 +++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  10 +-
 .../net/ethernet/mellanox/mlxsw/core_env.c    |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   4 +-
 .../net/ethernet/mellanox/mlxsw/resources.h   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 106 +++---------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   7 ++
 .../mellanox/mlxsw/spectrum2_acl_tcam.c       |  12 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |   3 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |   3 +-
 10 files changed, 116 insertions(+), 110 deletions(-)

-- 
2.33.1

