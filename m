Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5F949C790
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239983AbiAZKbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:31:16 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:24257
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232627AbiAZKbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:31:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qr3le7ZI5kNEn+iWcGN2Fg0nnT8Qq2gcBmgT7HEBYuLX7sS93rOzWw1OHAhndpbKP2sziQGDKo6IQ9hKSLa5s1zwFp0TXbXuqNTzzfy/kZUrnX8QYHxNt2810Yu7bQkeaxWMXMIv6NawippwAsJLbl5PrPwjFTNe1tFuO5MMPI4a7q5mJDX4TYQ7lXnqIqua4MiOQyhLGtwnP3eJVa4/Z2cCwIOoah3xqUJ8EIct20cbkPbD5YvD5aEEp/Ti7vLk3SxzDfCzzkkprPTaGEDgU3DnwBUQyl5v6wo48QkoMiiOQWcbF/hw3+NVd5um/sGrTZ3j4oLD0FTRIKJHYXaDzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B9OkeP4A/Hhcy3Z9FvBFcluqB+iq1PlOGY2pIECknvo=;
 b=jVuRkvOH2qCjr23QppAc59bskxjnoEK64BDaswT6DrCgmTbckU6P6M0yyV/HrI9vjNvAOvZMa4WcdRqRxmnR38q9hEEKHWE7WYP/US2sUMRIS/T3uuTlC8+U+fn1Lyh6vgdEra6nDULgbzMH7+T/tNUrsQgloQ0siKP8xnGHMaava7rIHmcrUDDSfTFk7QHVKxux8xLcwwUz+3CMgoMz/XawTyGR8vOdCbqgEzw2Ys1QP5o0ipAxUAH9f0gkvWoPELAT67kjc4S2OFzopbG+H1R85Fc7pjk1tcGjA54ThvXUs9qwS/MdGJEM60NOnnPu26NPm8XFm7FY7CwBbiqbFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9OkeP4A/Hhcy3Z9FvBFcluqB+iq1PlOGY2pIECknvo=;
 b=gEOfiQst04ikNfBKiWEr15AbJMUi7fopfLqKb1IkEB8mCzAI9hjBdyjnP+78124ORyJ7fg1+XJ5SxpKwTyT1dbpxE2SVdwfnE9uziVO6ORyCsgFVj6lwG05yXYQCKe/b8iG6ZrQR6hfGWyoBXkTp2JugKGjeKkevQEobfJOx9fnVUU9eGCo1wyhdB9MLyon8BPOpZLmP0a4IwS6nxB0T02dEznGpGxe8rOPWI3jtduXS58I4/EoNh8i/lbaUPjWOHzAjwh/rtttsHI7LTmyUD2eQHOKmy+6PjCTgRQbDXzuTNJGYkSAz6vzjh0CBtDOMXU8PWK/F0cj7iWdEp7ylqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 26 Jan
 2022 10:31:13 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:31:12 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/9] mlxsw: Add RJ45 ports support
Date:   Wed, 26 Jan 2022 12:30:28 +0200
Message-Id: <20220126103037.234986-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de6ed12e-69fb-4f81-be98-08d9e0b6f989
X-MS-TrafficTypeDiagnostic: SA0PR12MB4461:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4461FD5AAA27C9C2445B1F19B2209@SA0PR12MB4461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: deZe52wtfhVET0KrUTEsOfQkvdXvTiN+ThG+emi9cltvNWvn05jFn09oujqwzE/BgnVT8PxB9uTDfRRjJhjFwQ++dlT18M+3msCabeOh15e514chlx5f3PZ3EVPqM7XTHpLrJMP95kbE1Zuj/gwp/234xSo0yLtv875ENCG7h5X+Klmy2YOIrZiSJRfNuSdn+l2yr2Z2luUILwU9TL5EuBGKl//zU9CEkqAfyZlaaMi+pg48rxJU0pE+6ScXJm3Wfhi9UyObcASugyYw7qWoHyrfceKWk/VSX3N+oQXAykCt3AD+JnYwaC2TCIH1e2zVRuyl4ndQrhUbaQrmhIAMsGE2w3P1MwHoiUwTHBTMLP+p6vq/n7NV5DKPjJWCc085aJOivomIdd0xzpbtp9p71cr1vcAXg3r/+izRNkSp3grS90I8QAkBM7D3xUFJNXV04U82eAPcTAY9kckJCKXCAGIPk38klooX+YHaFkxhleVWC6DytmpccPbA9KblIDsxcXZzzuLnny/SSo0KElagUxrS9oh1RtFTnBokcJlBdyfJqZS5ToTmxhdo62ed2UN6iqn1+81K1ZvMJQWTX+e8vZB0kEklpPvJblS5BZMYWRfyr2X2X14+EXLB6PDxb34ZkTelCqj0KLWMgAnDvOPhow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(107886003)(86362001)(66476007)(508600001)(8676002)(66556008)(38100700002)(2616005)(5660300002)(8936002)(6666004)(83380400001)(4326008)(6916009)(186003)(6486002)(6512007)(6506007)(2906002)(316002)(26005)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mxuYQigwBIdAqV203W82x4H+VxlZ5IpT2lmB9zQ+yl2DB6jZA+/tmuVaqXDZ?=
 =?us-ascii?Q?rKJBkWlOt5kD/a5WQqEuBuMSNv+2PK4BHccJcIfvtnpBABwrCH0x01gOD11u?=
 =?us-ascii?Q?Jrips2S2xmNlOss3KkfXtpNkSFoH3lwf3YDiOpF0Ayy2PlFLw55qMY0+VMgx?=
 =?us-ascii?Q?Z/LPsb8dJbsi/bbrdxVZd9Bp+JO8HRALEn8F7zp0TcNAdaxyaacU0yPBHsNc?=
 =?us-ascii?Q?lAT+QYS6Wpsop/dhI8ptgixELuVjiN61A9SE9OR0cihvTUarJR9BPCxTkDfp?=
 =?us-ascii?Q?WSGhEi3SDMnChVXH78X9u5tT+nGjcD7ptURakwwfPyaHoEDVxASupsQr9bMm?=
 =?us-ascii?Q?pDWs7gY4p9nnFakLwmDeEYaUnFY3+yqC8csACpD4e8nBwu7jlaK0QTnqJXAB?=
 =?us-ascii?Q?ZKaUQ/YoqfoXUfu926PQFr8awlEhcsmdcfRXF5LcMWcicNkA+yoElvV/nRGa?=
 =?us-ascii?Q?aC0S0pkoETXsB3yvVXp+HFU0xGatGBZnrvr2Gw1XqjspatFa84zeoaZ4t7tZ?=
 =?us-ascii?Q?xNBeUSSO8h14mvqkTyRGG673A+fVG6iBFFILivSPFhoWeG4riijJS/cnE4fP?=
 =?us-ascii?Q?lThC50JNbICLq4OgN4kegegE0BTdMsiBEG4+GM1iuKwSDjefYYW9JYfanRxS?=
 =?us-ascii?Q?ONo1FjXRIx+Mtw4ty4YU7GQZXj50PEb0Pe9yyHMY3B/kVkdqn25OmElX01A0?=
 =?us-ascii?Q?PQ1TZRkUA7dzjmdEinz3SkV7eObLcInVIN6H9NadPFzkfvzjz3WbhygKNz/I?=
 =?us-ascii?Q?NtWNIqZfWv2Hetru8FCC9jA+GSx1l4e2kyj1agm4dB3vS6eAB6IO6INc83QK?=
 =?us-ascii?Q?/WPvYQCkYKxHbkjwqHM7zlPwRpj2S4A9Q8Pni5s+nqDQjW9+u0UrVPucPkl4?=
 =?us-ascii?Q?GEskgujuQniHBo5/jSGMUyeEsf6R61kIguMW94jIBTLHo/RDVjajorqzl/e9?=
 =?us-ascii?Q?HcOb0lzqQyc91/34BD70Q1FSSXvPyuAsUkSTOmo8KBuShVor3dKiKBx7JouD?=
 =?us-ascii?Q?6nFk8dlUUJNd1OGqRzfQDiWMnDhCkyxR264u1ltG8KNMvXgLUO70sbYW7UDB?=
 =?us-ascii?Q?+bHqJux3EkX6krHdmY8BlUeRIOx36RrT2v9Ke1dveGKesavI4BvueHAdTaS1?=
 =?us-ascii?Q?uKprm9+2URPJCyyAV//LQNvo3AsyENZQdgIQX/24uiqP9Y1lRWztK6oGSvEK?=
 =?us-ascii?Q?FQ+jpBggVCoSf3X3ve3EyIHM4rgCJxsG7o+cpkCiYt9p94eMgBsGnszWBCi8?=
 =?us-ascii?Q?T2htWDIJJQXyEsdqQX2reOYSCq14eYFf6FiTVTv6aUtu2LOIUO3VsM5Xq7pN?=
 =?us-ascii?Q?WMi6htJ4pY/5DE4g51VSJQEPRQ07qfgaXbO9vj2uOq5RyQgCJrwak5jHZGHF?=
 =?us-ascii?Q?6FC0EGOyEwjxfs1n/rqRtlNLZ8kL/wgYz9MVevzvn1h6hhd4mnM3MKL47zGK?=
 =?us-ascii?Q?ZbpTk0jvQvO4FM842Wtjj2rnqRTpJWq0qpdEBVQOKKfnEmABmO1vabwOP6D/?=
 =?us-ascii?Q?+7JhLhpKOx32Ftz2sOmJTybAvtXkKXyYe9rEre6Dz3q4XAvq44DLm6vqVTPb?=
 =?us-ascii?Q?6Vd7wXHzYZgqWViT0A6uOcnDcUB8S6YrCBSvTp436deaKh+Q7xBCVU7/Nb5D?=
 =?us-ascii?Q?iZrtZlzkqA11l/wPzwbc/Jg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de6ed12e-69fb-4f81-be98-08d9e0b6f989
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:31:12.8296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fd5imSrv56H+o6y1xbSBl2IlrNrjpcALlZ4xUa50Z7MO/zXmsC0sHGx3Zdm4o7SDmocGS64s6t1DT71Uj76KPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are in the process of qualifying a new system that has RJ45 ports as
opposed to the transceiver modules (e.g., SFP, QSFP) present on all
existing systems.

This patchset adds support for these ports in mlxsw by adding a couple of
missing BaseT link modes and rejecting ethtool operations that are
specific to transceiver modules.

Patchset overview:

Patches #1-#3 are cleanups and preparations.

Patch #4 adds support for two new link modes.

Patches #5-#6 query and cache the port module's type (e.g., QSFP, RJ45)
during initialization.

Patches #7-#9 forbid ethtool operations that are invalid on RJ45 ports.

Danielle Ratson (7):
  mlxsw: Add netdev argument to mlxsw_env_get_module_info()
  mlxsw: spectrum_ethtool: Add support for two new link modes
  mlxsw: reg: Add Port Module Type Mapping register
  mlxsw: core_env: Query and store port module's type during
    initialization
  mlxsw: core_env: Forbid getting module EEPROM on RJ45 ports
  mlxsw: core_env: Forbid power mode set and get on RJ45 ports
  mlxsw: core_env: Forbid module reset on RJ45 ports

Ido Schimmel (2):
  mlxsw: spectrum_ethtool: Remove redundant variable
  mlxsw: core_env: Do not pass number of modules as argument

 .../net/ethernet/mellanox/mlxsw/core_env.c    | 117 ++++++++++++++++--
 .../net/ethernet/mellanox/mlxsw/core_env.h    |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  55 ++++++++
 .../mellanox/mlxsw/spectrum_ethtool.c         |  28 +++--
 5 files changed, 179 insertions(+), 27 deletions(-)

-- 
2.33.1

