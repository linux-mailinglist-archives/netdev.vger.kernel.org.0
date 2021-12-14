Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0778747405A
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 11:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhLNKWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 05:22:18 -0500
Received: from mail-mw2nam08on2042.outbound.protection.outlook.com ([40.107.101.42]:10720
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232977AbhLNKWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 05:22:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlIhvVhS6NYwsjcIdm442j/3NtKGMVz6LexHisU1ko+i4WvxaoQcap0HsY7xv1pOESagakqnwc6Dq1JPztsGXKM8uyoH5CJIa88eCu0RkwYFP7RDIUWTm1qdaqYeAgVNacTxpBqMk0ZqRI3UEJ8eiyDH7oWONdaX2WyBsq5Db14utg2GWV+nDiMQnqvUi1fwr0WyAMV4m0LFtNYTeNbaZVkB+rXYVpBu+7DHb6xe6voPUoOdpson9q4dG7cBaQGLKy+lvfRNptOPEnA/oYPKASVelXBgILYLdfdi/nl26at9799GtwuGWo4rq+kADxtgmEO73TajIretQpA8Qq7B7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqBkfTUzJkv+a99yD7Is/ggt5YXEX7tFZUWfNfYKGho=;
 b=gPMUtD4QozAJY2ELPhGAYO+ThEFnyovQw9J8KN+wq+b5crmPSeLjzDLLogmrbpEXHMpKxWveqeZ0Clc/CW7gyQhN/t5K1jyL7RzlohBjF2WoPivhIuIvl0M9yEQjayjDeLPvhKqbwUF0uC41zmV8y0RltAWJanGrPRF7ugbMGMByzrw6tU6CP6Asbf4kH70I87wpN8YkFCBxEegeDs431itZtrk8ws8PMbIqnB5kZhh+K+heFUdyUKZnHoLC413XZMIpbvmQVAO8rN3JqaET6OS/6XOPHSRur5kR1OAz1ys/WSKIBNQVedFmsgVKbJLxlbCecgI/q5rS0PerAejwPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqBkfTUzJkv+a99yD7Is/ggt5YXEX7tFZUWfNfYKGho=;
 b=qEj+/xQl8/CzUVYTCz+2iA8k2yUVO6x4QY1Ab4lTtwlVV+sD69ChfskGpCFr7TNTEmwLhaZqe8fjauZ8yhInl5ybyveEWGBN61rUPhY5H5pLvdTiYv5yaoMz5BC/PRZ/UjLKoFSWj1Rui+pCeKtVAZyVxJ7afZ7G++74XxjR65EiRzcMWM+rz19RJmX5pPo/tF3Yrf4kzGLwP4poJHAMxZbUfZqAzUiXsJDw+McoBgHeLRmGu3u4Ku08hv280tV2rxX3tJAbJppS+30rRrDCebCPdH65gHxPUWflmDYmHVyWJK8CBmIsg8NasVgF6LEWTBHAu3aCqtnOamdO/hxYBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB3079.namprd12.prod.outlook.com (2603:10b6:a03:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 14 Dec
 2021 10:22:05 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 10:22:04 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] mlxsw: MAC profiles occupancy fix
Date:   Tue, 14 Dec 2021 12:21:35 +0200
Message-Id: <20211214102137.580179-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0078.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3f::24) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR1P264CA0078.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 10:22:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed1e9be4-247d-459c-38f6-08d9beeb92b4
X-MS-TrafficTypeDiagnostic: BYAPR12MB3079:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB30790A9929D176C89A0DBCB0B2759@BYAPR12MB3079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +RMneDvKdvnlKLd9P2gAw2etauOXfbLbEEP/WokdSgtK0zjIPB4r04S3rcFruPgdVn6wyo2+r3vYsCvMyeyO3Kvk3+2S6tBTLcty4JQ1C43QMBxlxbNkjM6m3abLBXeLD2Icl2nIr8GuLS2Xm0ptbKebNVeOR+LBpAV4Plc3QPoUm/qFI7MPiv33Cb+k2H/+PyytSSBXbtPEQDFFStO9BY9a00EanyhvyaSVUQCHpO3OVq38P8MbSVLwDAX5CANnu5dWKoUVRYMEP1kG3Ao75JE1NqsuMVaCPTYYF/Y97tUwWqpbxOLEysA8MHqJKWwmK4pPN+Jw6jqVSE7NbkQJ4Vt4ABCyjJ+OSdG32fzbMzKWTw+IxgmCKq7U2L+eaaPvJW3RXNl0vNzhjytntW0M29um8J4+HI/KRfq90pjp8X9z/bxS/iqe/nUiDCmroGWbo2ZBRAq3M3cDUm6+gXQ5OdtMUCGTJyUsBYXhyg4HXAd6yLwUP9+P7ztddgT5nLplxZUQv0K8aRuXsbDZqbXSzZGpM0xOJSRC+wLTJtmuY4jdDLaHG5peTagfSp8uYM/aglqNueos5RkU+mmfCumsyJOPQEFJWbhJSTT2wu6kDXAzpHfIb4wEt1JcZJY+UhWrnPTkhuuRa0ah0TWJLo9cYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(66556008)(66476007)(66946007)(508600001)(5660300002)(1076003)(107886003)(66574015)(316002)(8936002)(8676002)(86362001)(83380400001)(2906002)(36756003)(6666004)(4326008)(6486002)(38100700002)(6496006)(2616005)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B+CiYJK0DeC+bz50THMR4QhkiiisCuofQT+X6c4uwc9O15yFlEWXr6XdEgB1?=
 =?us-ascii?Q?XjF9NA1bMoVKX/88bOwSALle+ZI2LIFm1ycmZBiSPnJs9O3vXa2tLvfhE+8O?=
 =?us-ascii?Q?uDlKfRs61DkrADJ5+2Vxze+NFo5iJMN0cvKpy9+W+95teRQtzgckIYcjxwkM?=
 =?us-ascii?Q?TSbVofzA/eX0jik4lS9pJoyg18/xyar7cYmMmabZCM7He9zjyPJ4jRWcaTWa?=
 =?us-ascii?Q?htCJMieXdrM5J4MTehq0EHTwnrCMYgPwDUHylqzZNq1XcOh/+tM8I+5e70Sp?=
 =?us-ascii?Q?dJxVYYLrHQxGL8jWZSfuOFxwxKa4HZN894rqUjlp1Z5kji6e8hOZ/LYi36L/?=
 =?us-ascii?Q?+1nyJauvQshYskbf0vgXV81b00PXQjx6cT8UAmzqTh/FOTAGxuACJxCB7nYt?=
 =?us-ascii?Q?x2zOjkf25unVooI1gkxtrNSBsOKFh87zX6tBc2D0LOEeG9d++BIPo/ih8Rms?=
 =?us-ascii?Q?BQf2xTA9GrjYOlM2FmnAK6soksxhkJbZE1dNgCrm6afNgw5yiMDMQ/6UkiRj?=
 =?us-ascii?Q?P5mRfbtSzVCjGtg+7fi7lx3Dz4WiMdxcDNVpGOCSj1Y6bur2//dV+5vGdIB9?=
 =?us-ascii?Q?2SAqzA7Y3JpoHjLaZ0fPf7X/tpW6RTKwwsdrk6zTuTUo0atY63fgYz3a0Cqt?=
 =?us-ascii?Q?hhuf/rLS47nGSXjwcfVrgKD2X2+S5+r5I8W5+nMj9at4bSKsOWgMtCZIc4gP?=
 =?us-ascii?Q?f6gMwHVjgXMFIblTUgaE2L7aIwwsnj0F0FpOd2KrjjorD+m5HhmrYcbNntmm?=
 =?us-ascii?Q?bCdb3G8RvemiSAX47MC21ScPccQ+ihrL8M9hNds2ACqKMxUJmU2ANK6xV6TO?=
 =?us-ascii?Q?f9AWKp4SJiCm8lnUiGV4JhOIrVwcBZ8YUvmXPn9KpK4lYYGjLOUeiHifWWsK?=
 =?us-ascii?Q?hbm1OBw1Z3xILt+xawDUTAF3NO4oFFzPfkRiq3v3vL3ByOKvERMv7ofjM5NK?=
 =?us-ascii?Q?9NhceP+cLqJrDu7tWGAfBB3B36iD/ONmvm+aA5OPWdd+Scai8PvrXo+UbCp6?=
 =?us-ascii?Q?jb70njFTRyO7VFj3Iyjp3ybMqKxnmppXL7UNV2iRd3YxT/PZP8bVNlyfkqo4?=
 =?us-ascii?Q?I8MTiMTOms6dXJGwZvs6SRvdroHh8zEKd4rkZat/q504DHofZoryYnZjUwGt?=
 =?us-ascii?Q?LgGp3BHSuVj5RvdTUdBTv/uSeVCHMJ/TqBwV52HwFEw6MfR0i69roJPta2pD?=
 =?us-ascii?Q?Y0Tn6boC8a/oG6xcYz1X0IDeBMFbKl/ldNevcTm94w7qSUKJC6Kpr1rw8yT0?=
 =?us-ascii?Q?SwZHqXGnuOfUue+AEr8s7f2VR8165T7i2q9VlXASo8MBcmpCCBW0vsub0l2S?=
 =?us-ascii?Q?TIrJvQcEjIQLVEP+P9lMLg3ZLINCW5Ubp6RzTGM5zP0fGJr7/h1prIHC5YU5?=
 =?us-ascii?Q?k2+Wdb39LhKPjt7hMkcXN5WIS2vwy1yIH+okDUteqF/gcw3NNuSegI3csmyo?=
 =?us-ascii?Q?JbqKuJmadKDNrpOY/Z/LpZ9ifiL4TvXPDQFQUIoZXiJIRzQLgcrIWpv96k2p?=
 =?us-ascii?Q?r5E/PTAfM7mD6aX6OSB5bIv6GLePb3XZQMGTmAP4b/KbOp57DQ/7RqlNPTWq?=
 =?us-ascii?Q?DosugJJx2mfpiyKOfGmguOwV7QKsMdGtJ9m6yFnaz7aWOr5JMPW58CPzIajZ?=
 =?us-ascii?Q?K7gNuDaystxKrXN1AOToX6KJU2pt0cE1z3sh7kSqFYTlSW66i5PyQvjQ1wrT?=
 =?us-ascii?Q?IhBKu3Q/WX2c2Uwfx7D+YMjUrYo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed1e9be4-247d-459c-38f6-08d9beeb92b4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 10:22:04.0012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UCNLsKef5VbYGEKAGdSNq8ylcYoEDL7xRak9wiRD2/PH3oC+7Daprh9u43rtmfCpke7OrHHnTKl5M3P8e2WN9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 fixes a router interface (RIF) MAC profiles occupancy bug that
was merged in the last cycle.

Patch #2 adds a selftest that fails without the fix.

Danielle Ratson (2):
  mlxsw: spectrum_router: Consolidate MAC profiles when possible
  selftests: mlxsw: Add a test case for MAC profiles consolidation

 .../ethernet/mellanox/mlxsw/spectrum_router.c |  3 +-
 .../drivers/net/mlxsw/rif_mac_profiles_occ.sh | 30 +++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

-- 
2.31.1

