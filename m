Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F89847405B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 11:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhLNKWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 05:22:20 -0500
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:26272
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233037AbhLNKWN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 05:22:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7YM+Ag6l/FGFEGkzajxaRbC6/FPv4rQulQnQUSSwhXUF2sxGRT3gDpUGYpHzDtoKURcCi5ijkd9//zQMVDeiiREKkzOLpRR6cOs7MnUPoE4Ul/Qd7UZwkrLo0iNLW5LdoTLiqh8ocrZOaPwOuzjL7/uO4x8ayY4mhk3i6ZxzcZgztFmi0ZSiN5mYs/re4Cbrz2SsqVSwHXZ+sxrAprI7fStJyojklg1ggMpQW3ktaExWCSnL4fSEVIPcv708aeZnCqPzZFVCcISghmp/pBE/AueEcSoP9AtTO+nLuH5dSPrgxw5gE/jP8jCYxPRwz0lkuPc+dti3/+B53tAePjSBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nS+iugIAWKcB5wbrznom4AYqCfvJLsVrQM9jknQTAvE=;
 b=h7sucQdwENI/XGJTUlCG0PGnJf863CQIIWRFGY4Jghwzo1b6/lju4POEgldV/YIGZeqnhWvL/+iHt42Ovw7JIuBfh+IcLwlHOChTT/M69EyQqikrTj1c/zDBs0dugM02dYXE37gnrKhvFwZkzC4KmNRGWU+KFIgzSrGospAO+E+A3purKnM/kpOJZmgXUg6JyWDi8Yvvyf1kPg/OziaYITLyr9wd5KX7XCeoHjK5+2rgGAvEI74CX8nYuM51in59jFi5tKov/c6xJ5kHhXo2tbl5vw9JtVTcGPT4aRVLsnQizqd12anG72E8lzHZRMzCOvQVw6OewDV/tny4URjJ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nS+iugIAWKcB5wbrznom4AYqCfvJLsVrQM9jknQTAvE=;
 b=e7efdw/zUHOccEXKrfXQEZrt7zHno+mhPrSSxso9WqTgRPxZydxRwZRk2mfwiNlzjhM/QspHF0BAZgBgKZ3GJGZiPpZOH/jhVz33/P/PjNKYBhDcjKB9FwBI68DMrOi22fZdX/6qK7GKZV51wQ879mYEeaslfTkO3VhQoZroGL4VtjJ1+PeIXLY0EOAsRoV68NqkdRzDm13rje2QMPYTRnkXow0VOqIOVw7ydo4ukR6wFE1MJDgIk9NAudcqG8ptsHevT7qX9S4OvSQY/w7Yhb4TBk44HlsqMFZ9mb9uQllzYAImRvoEkOOvW1Fm0avOMvmmsCqMer2Q07FC/5q4fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB3079.namprd12.prod.outlook.com (2603:10b6:a03:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 14 Dec
 2021 10:22:10 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 10:22:10 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] mlxsw: spectrum_router: Consolidate MAC profiles when possible
Date:   Tue, 14 Dec 2021 12:21:36 +0200
Message-Id: <20211214102137.580179-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214102137.580179-1-idosch@nvidia.com>
References: <20211214102137.580179-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0015.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::27) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR2P264CA0015.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 10:22:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fb90c3c-0e6f-4541-bd5a-08d9beeb96b7
X-MS-TrafficTypeDiagnostic: BYAPR12MB3079:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB307943EA1D4A28F312914677B2759@BYAPR12MB3079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+UWf/uOqHnkMBg8QNKNHE8MsKIqlyYzQUnPR0iiS85zeIjSSp1COl8BE1oNKY1vdt6ZKzQAwduj+Ue6edxwLiA6OpjCMI9HSg5r4QOdrDgV8aTV8qmGH0V4bFP/j1YYgcex8vN6uhFgf6qKjnnDF78GK5Jas8FqE2b+F/fTj4I7mP1/APiwt6BRJvMhqX+Si+fwQXwA9mVEJqMCTEyCc1hJAEhJtSQ+qySoSsi7vLcpjSIQbWxxnBaOVN+YM9qipcIhRTaK+f7NBErvfw5jr74upEfFNHdoZVGdkYnMqpjsM1upFr9gwhM94Qb4dZQj4XSulaBS5oFYvZIsqSvnvQ9dCQOJIaGggpzCAg00DGxY9tSJGUAw6cHzMchHxswQX74YyXGM+CeghHZIKjerFLqkAfENNfBaPusLPSGwS/AUFUVvNijDLWA6bLTzCLO8dKzxxsZXOdCtf9/HM+AEZtWa8P1RI7GhEkqzsMMsZQSSF5HatqPq/qpRxaDHlprjJwl+PpITP++37I3ZCTirfEGsknyqpcql5ZM+hOCtBczgBGtK+rFBMndq2111FQi1Kw8KBYNwqU3wfg6KQd+UdaTtAsZQFPIJ05Z1LRFhr6hpQvxnqSncVgwxeefgWaBEtMWsmekijuijYHC4N9NI/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(508600001)(5660300002)(1076003)(107886003)(66574015)(316002)(8936002)(8676002)(86362001)(83380400001)(2906002)(36756003)(6666004)(4326008)(6486002)(38100700002)(6496006)(2616005)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1rhM0y7LeO+XPwLFjn3eU8cLgTHxuemrPc4TTs0EXjlBOPvDALowX6m2NsCZ?=
 =?us-ascii?Q?60oeTVOKy+ggV4YGz0xlOofYGBcyLANnxKiepuB5JtjH7jjaf+yHuz8s5mMW?=
 =?us-ascii?Q?qZhxDd5H69YBMZwRav8FAQoR6EBUvONJ8Pgsnz2zbbnNvVjTYk/H3D8mdE5b?=
 =?us-ascii?Q?gJIuTb+edcdbkkV/PifEGxT4cMCW2g06NAEztesjEBD2FJsaYOBWDwoGRGKB?=
 =?us-ascii?Q?kD0z146lXPsuM/JT8gsQxOici6d+yZ3tpsINW3tumU8I7CNNzeB56eZ301BH?=
 =?us-ascii?Q?sjjTBeJkplk6jLdKOeRCUqFO2JWs2KgRH/kZW/fAZMwC9yMnOOPEcm/FFu5/?=
 =?us-ascii?Q?LSO6Gj2ONfvQSDx6Ius0Aj6PW80FUnfdyK7eVZnv1ZP0jTTbIAG0+vasKipj?=
 =?us-ascii?Q?fx8YyyG3NK1Ocd8n8zsJWuYveE7VAdhi94cqBue8zeU3Z0DjSxs/KeyMl84z?=
 =?us-ascii?Q?9Dci176pDocfbSfpx+kaeZyNToPa9BcTpZU1Q8D5TUknI7ZvDPMrWUq5SSsR?=
 =?us-ascii?Q?xpFnVTxBUIpBJtiRoT3taTKrP5Xm6uuNeprDDakybovgK5+WAgcLwqAFuoCW?=
 =?us-ascii?Q?PWsOuUy6c4hYxHJ03L/SN7N7aXdPC/SNDqPMz55bqjJMIuUlUBsTN1y6NOjv?=
 =?us-ascii?Q?oxrO3mgquQQlB6+lelnmgzAjjE/TgC5OVF3ZX9u+42UI63AkYUFf5VVpU5Gv?=
 =?us-ascii?Q?PJ1FgJsDqFeulONFb3f2JlbfDMwPo61lJxAcCisIIt/lPCITaxtZa7kPSjW4?=
 =?us-ascii?Q?yZ7VEaFLCXifhvbJM1bZw4greKvbdEmpk/3bM1vPyg3Un3DS+jr7eatMQ17J?=
 =?us-ascii?Q?4Mqz2nvs1ps8dmVWEXaTXZrKMuhNNolJtZZ6dJuxEt+pyBwTCPOtzaEMhIpQ?=
 =?us-ascii?Q?ik42wFEfmR2Ax2DOQEYhi5qHmQVA6g4rl0C+QGWK/ShU6bCR9SAFwueTLE6t?=
 =?us-ascii?Q?uQxEI9JRy6NYinrc21vx9T0K109biNL+yFlSDq30Sga8RqEWP//Rrh0FHSeu?=
 =?us-ascii?Q?FAwpeTMKs/eoo/X0b+GzoWPNKUg+84VjaQYavbYu6qt4nkTxieNFm9gLZT21?=
 =?us-ascii?Q?HEvy6V9DCMFegMzMhhpRuYsumhmN5xHF7Y3jATPH7vE1ofJs05mJJFK7c75v?=
 =?us-ascii?Q?vb2h9vsp0PdblaExZXjDx71rjHwIqiqpnmE3xFEfYlgOdgIAnsc0hNlMAYMs?=
 =?us-ascii?Q?HmyjjfpMj41qoMqG3UVEMpNNXbYSRz5zxS+FsjFzel9cRSMZ1iAExmQmjCwX?=
 =?us-ascii?Q?LsGdi3JnXgWF6sQuXSYSDM/Z1miJAiZZnC2Dc7oEA8RfiSmcPMJEwQty5Vjk?=
 =?us-ascii?Q?fg8lDxdGFCtC9vFllqa7Pm7RoUbR3uaTJYzmU6f1aOdjdA9tB6QEJRDSroCB?=
 =?us-ascii?Q?At4+Tmz0+NPj7tAsrqfqm4SHyBGZR9MTIFjD/TEpwiB5Uq+Z81oUVgVVOq7m?=
 =?us-ascii?Q?5sLcOK6Tm+dTfooS1TgadJFkMKv+Vd+wwsfQgE3Rlo/ay6twnHHz+3mr5Qag?=
 =?us-ascii?Q?fBzYgPon1IVgwACmzvmlYDsmpiLQndN+6J2PWYb6NgR9FOwhcGNwEZyWD1Dj?=
 =?us-ascii?Q?FKVf7Ms7hIfP8ajQsp7CgE460BPAKUNcBU6G+/kLPZ9gom3ZSwjIwcWjfh3U?=
 =?us-ascii?Q?59hKnohK6n6eFYKBvQYTFcqeQhuPbn2+yw06VqrllzoiV+scZJpUcifnDp6Q?=
 =?us-ascii?Q?mwW5rdSKd1+j9v/a2gdO6Ku5S8A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb90c3c-0e6f-4541-bd5a-08d9beeb96b7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 10:22:10.7507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HREN/QV2hg5QDCm+9U0fqwjXidQFz0tNSiikg72WGf5yzvr/lzKR2Ql7aVooxRf3v16A2fMJl3bxtgLTZl3dKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, when setting a router interface (RIF) MAC address while the
MAC profile is not shared with other RIFs, the profile is edited so that
the new MAC address is assigned to it.

This does not take into account a situation in which the new MAC address
already matches an existing MAC profile. In that situation, two MAC
profiles will be occupied even though they hold MAC addresses from the
same profile.

In order to prevent that, add a check to ensure that editing a MAC
profile takes place only when the new MAC address does not match an
existing profile.

Fixes: 605d25cd782a6 ("mlxsw: spectrum_router: Add RIF MAC profiles support")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2af0c6382609..764731eae2cd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8491,7 +8491,8 @@ mlxsw_sp_rif_mac_profile_replace(struct mlxsw_sp *mlxsw_sp,
 	u8 mac_profile;
 	int err;
 
-	if (!mlxsw_sp_rif_mac_profile_is_shared(rif))
+	if (!mlxsw_sp_rif_mac_profile_is_shared(rif) &&
+	    !mlxsw_sp_rif_mac_profile_find(mlxsw_sp, new_mac))
 		return mlxsw_sp_rif_mac_profile_edit(rif, new_mac);
 
 	err = mlxsw_sp_rif_mac_profile_get(mlxsw_sp, new_mac,
-- 
2.31.1

