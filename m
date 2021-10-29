Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FDB43FB5C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhJ2Lbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:31:50 -0400
Received: from mail-mw2nam10on2134.outbound.protection.outlook.com ([40.107.94.134]:11008
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231670AbhJ2Lbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:31:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACs6B78sLCQP5DX7tFbTv3mxO9+zbd7QPYB9D6jAzhzWLjc3aMPjo4NWN+5jV8UYZM7UJ7relZCM5NiGa9IctjCcx9twnlxRXjKOPoaNctNdKVi0WsePJxkVHbxYJ3nxaGk/U8PG09ABiNxyu8s5kMpqFd4Bzev6M650fRllyV58H09LVT54QmMJKdv8sM3tpgQxWOALtrdT2PzmtUfbDrO2NUxEKgZUfj9uU4OkVaXFPjYfyyfIaGLwOyAjgCH06AVGlUV8VgHfV5HGrcM8NQWAJgmXfPQmpYy2904Usuvs2Ct47wnMvKAemohNeHa2wB3eph9V0y5jpTi8KHqAhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQWTrm8h8Qhn+smKtQKFACFBWwETGatymFYVN4/dQTY=;
 b=K2JJ48IZBYc4CG/Bkyn38noeO35pp4WPipvm+XpKBl9dqG6UGVnmmVoR6y8AtF/8wyJh1k0kkplCPYPjyF7Fd+kM5Pi3hqnvSMMxAzmrDNAxKh1Mc+YUykKvlIpUCrc7y8t3MNMysTSeJ/2oK/HtrpfTsoSNdFdpXvTNuDK5lqIm1SYO6JEYhu5ff8eC30NwAuSgdhDbJ+vc+p8jzbSU8J8WNQ8ygdduHMedozVkavK3khIOwwDDe3TIOMOp1tHf/+frHNo0VJO+nmS0LcPDGMOu7gJ4HH/yL3GjRv8mg/Wwr3NwFiQmKjmvEjEiUnjcefJhDq+wWpX4f7SXBFn8Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQWTrm8h8Qhn+smKtQKFACFBWwETGatymFYVN4/dQTY=;
 b=TMHOMDXiTUqPh+YkT5wHQXVmYXBQWQIQDkVzVKGI1R4/ncgKnkRHSba0Beey463wn2Zl7jZmSK5ZcK9yL+RBBb59U8J8MPF5mWYeII6Ndyy9uXKSrRc1mSUhQtwSO1uP8aJIm4Vjy/rcrcUhjlsl/sCzOh5U6A0m5fV787Rhu7U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4828.namprd13.prod.outlook.com (2603:10b6:510:93::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12; Fri, 29 Oct
 2021 11:29:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Fri, 29 Oct 2021
 11:29:18 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 0/2] nfp: fix bugs caused by adaptive coalesce
Date:   Fri, 29 Oct 2021 13:29:01 +0200
Message-Id: <20211029112903.16806-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0015.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR08CA0015.eurprd08.prod.outlook.com (2603:10a6:208:d2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 11:29:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73694cb4-cdf9-4a85-8318-08d99acf5825
X-MS-TrafficTypeDiagnostic: PH0PR13MB4828:
X-Microsoft-Antispam-PRVS: <PH0PR13MB4828AD84995502BB06C66F89E8879@PH0PR13MB4828.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCQqDNYaphHgHSV9ycjSX+kF+L+sc5ys4sLgwMZDxFXEGnhlukawhHQKN0emkwpZQwczS0x1ZnDS4cUmu9LVIomu2kjXoXn4qnSO7kxealWuYBf0RxAA6yn+YK0Y+Ek0Mv0vttSHSedA16ETq/xEKpo6tmHBdkBkalOm564JgrHsa3Dksr/jx3GiATKyWyJvJ+XSBRKuHbuuTErJLW7auGnyVwQzVG/u2dmdYTtItnn/NVEDOFByilyjRuoTCZucETcxmI+rde6AhKUQfs1QJotDVfdt3ZNs5JxpI9iASzZSMUbf2EXBiddzo1494bVdONwQD7qZsMWnTuAvYM55VeLkCvrUm+LsGDRjRIUOtbHvlkdSbJvlKxSa3nMovaHIdyiujUxzvD3t2Lp/IhpMG40dSmeluB5GzdN0YXYywCF1XQOnngPoeaiqfWVuNewVNpsf62yYv8xTx5QreinxcwegiKzO/GBz4dwwKJdMSvmqHbSXBitb64/K5Uv+E6aNxukYNvQ7YLvyxMAfb9ocNtzUIXFUknOfZpgBCK92Rz5Ovk8QAIOjEs3yWy4IBPo3uAKHH5q25UZKkDgp9iBT9RCZH6V6MHcVn1oqe3GH1bXjz9JB8FDtrKkezNEuvMuJCGTBfeCg5vIFzCEcbbpv8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39830400003)(136003)(366004)(376002)(66476007)(86362001)(4326008)(110136005)(107886003)(54906003)(2906002)(52116002)(6506007)(316002)(508600001)(186003)(36756003)(83380400001)(66946007)(1076003)(2616005)(4744005)(6512007)(8676002)(6486002)(38100700002)(5660300002)(44832011)(6666004)(8936002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ewmkpyn00c9YzzQkf2+Y5lZDYgNA/XLb2bRZNa2oJvBrx63173WqH1ls4y25?=
 =?us-ascii?Q?Tti0Tl239FOxnA/sB/U0UDtoSGyGdo8E1Wd5rQuMYQ7sDPcG5qIsk/38jpLP?=
 =?us-ascii?Q?/y6UlVdeE4DPbXJIXeA7InUyQWAtv3F8/gMGM8jCChgeFYRXz+L0/8lF0ANP?=
 =?us-ascii?Q?It6RhUoToUAwLAnYo2lVxaB1sBt6DNHMFpwpSW6+t46GTFUeBaYspHEzQZH1?=
 =?us-ascii?Q?7Osy8k/KDrpSVOcTC1p7aC1hLxLouNmNRepxXBWrgsCKYExFEISOXR+GSVQC?=
 =?us-ascii?Q?BXEEAOB8/XExKOgB2iaudMZIbvrCCDKu3HvIZWHqr4c3Ps5QjyWjoZOWk6Jn?=
 =?us-ascii?Q?XYVGBvUmvlJU+nubecUAGACotsJXBhEr18lB1xh2n0KykqkSAs6Qa9PYMjlP?=
 =?us-ascii?Q?QZjFGXDIV3MzPOM+4Vi6ina3FzRb051gSZElWMavJWmRc3+poWlv+17nagtm?=
 =?us-ascii?Q?f+0xRusxqEvIkzvzkj6zcx6Tj0ueOvyZye2Agyje0JngirDQMpdOhbBPT5Ul?=
 =?us-ascii?Q?aJkKizACW1ihaM7Cod/xUnctaI2tBImfNPp09MvtQ7B+baA9ntlv8hV7DAYa?=
 =?us-ascii?Q?N6bj967+fv0TUkH3oLh1+r6TIEGPReXF1vJdikeENaL6y5Keyd0tEOqHn1eT?=
 =?us-ascii?Q?ssEf4tPB/CrO2esTLCN6tXNMsDa0AHPTDBPUrJY7fNulgoMvoQwYlaK8Ojys?=
 =?us-ascii?Q?nsv0YwvgtIKzU5TvdbmN1wsr3K2WTKLFVzlGBPjGq+7XB6QIKcxo140WmkBa?=
 =?us-ascii?Q?tiUPBK8Ed0kKEsCUvO5I2+pc1quLP/7A2h30ZryawPBMrWbuFWAunll3pHDn?=
 =?us-ascii?Q?S6jCfoubbGjoaQ6p6Qmc92qD0Hs/N39HzX7DwTgX4YvqBLgl2Pn89wmhHiF8?=
 =?us-ascii?Q?14oBtAF0qo60+eRPGZWi+n4ZJi5MGTOw77A7CECxDgAenZKoEqXWZ2jWlZh4?=
 =?us-ascii?Q?VE8us4dvnKpkDbp6X2rZG7wxeRhq9/B4KZfdiEpNOCbZIGlxWwXDxpH+tuen?=
 =?us-ascii?Q?n+HVuJAD3mYiIUvbldJfeUFwvmZxrQ+ZQAGiJHFnRixzzJ994MDYEtnIr/oW?=
 =?us-ascii?Q?dbZxSZOE88gOMFGY9C4Eyi/TWUkDfgiZZ3PL0+K/x/R3sEP44ati2Ui7aJEC?=
 =?us-ascii?Q?PM1i8lC/rFETG8u+bu/y2Z2u44fP1PcnEL00a7GpqLrJ3jRAEREU2hEqPWBT?=
 =?us-ascii?Q?3qgJPz35zxcOnQyi2YCsQIAQAKEWVlMg35sk34T3BWXh+f49f5wkcaEaMb5l?=
 =?us-ascii?Q?T3COkT3WndboBLnSl4m+e1AgsWJ7ArqNHtq75OpNKa/+jqnTMALgVkCs6OAP?=
 =?us-ascii?Q?E7X1O3hyPOysudEB118IRe9uaEAKP/++jXXMolyWkrH7R3fFhGWc7gwUJYHU?=
 =?us-ascii?Q?FuRjGgtuyq27xnsNjreLCdsJL//gR+kjT+I5p1txXqZjie5anSNyvLegjhHI?=
 =?us-ascii?Q?Zub6tdfN6lKv5MXrbxDJ6VTp8JzTJE18qR6LAJ6ywAK9shFWP0cPGDgpaKzC?=
 =?us-ascii?Q?v7/0hliV1hM7k5oeERk4/SNb0vu2MXkwTnI00viG2pdn8gr1EwHZRiXOsy61?=
 =?us-ascii?Q?jiblGYf9nB0vf1MTwlKCQ75hji3FLCqxjaHzpAfWA/j3TfqRkPGR/H4fk66u?=
 =?us-ascii?Q?Yr3sHZJwgBM0VqAet01oULI+GldfSqs9RU7iWxgwgffBY5H13YoSfnEVbPPV?=
 =?us-ascii?Q?1rF4cvQ/ETkz+ylRH/f+LR3RaIdnZ3GbU/5tGh4y9nxqR61vKLtoW5Pyb6tQ?=
 =?us-ascii?Q?x2xFvHIewA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73694cb4-cdf9-4a85-8318-08d99acf5825
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 11:29:18.0324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVWrDdUnLFYqynt1AqoPTghYPDW+P92S5sU8gOBamJ3kdsLoKuf5qatyL+OxmLq4fOC1mRH+lvnBCbeL6i2cIQ3S8J5z5kAnYIzfoU4AmSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4828
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series contains fixes for two bugs introduced when
when adaptive coalesce support was added to the NFP driver in
v5.15 by 9d32e4e7e9e1 ("nfp: add support for coalesce adaptive feature")

Yinjun Zhang (2):
  nfp: fix NULL pointer access when scheduling dim work
  nfp: fix potential deadlock when canceling dim work

 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

-- 
2.20.1

