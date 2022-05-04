Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B475C51975E
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344947AbiEDGdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344932AbiEDGdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:33:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E591FCDB
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:30:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jlsezchq0xAIVJvKE5XClFYHn8SXhdrv9mAKa9/lEHZp5i2lKQFev33yVhfVswb9kEu/VF8atadcwN7EiazjH8+bt/rM3CEb9ZpVFPaggcuU+EQ3jdAVyH3dkqyNiigcKrBjWHCiC+zPlosO0xsAq5TMHChpajotjDdoxGSfajNd+wzuPgM/qGnoGYwZg2Aquut4KxzNmnFojSUJt5HuMGTwtcCVKWYMkHGGasMEfiWj4hG8+K49Y3PrYMTy1WKiJVDGRpnQdlccELusjyhj5AUAjTTtJd0p3mLEiW//3YgSIMBNtRXU/TRJT4y2K1j4mhLEwP7OwoP0PGxdgQnjJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ge2snK3AleGYCV67D1XwlNFYMSlN5mQ0z/6HnZIdYeI=;
 b=NShS1v53OlTAFYfqIdGvKohDEhEF2l6WJCdz0KLOsnsFMvvwNwOQNjteixvXvYlEPx6UgLZzHxMQEhY39l3oEhG9tq4eYj4whvgVeVbIa59O6C/yfg+KZ7jKQhzCN3XRyeJBrNp+gO5H5MQ7UUUn0lmmpjuZgi21mqoSJzWi0egTmjvEcthNSt4Xep6F7ujXnN/vAEmBnJzUmMpUKMYI1W7Wi8FY5qNcENZJgbyULs72fFX6dodTyXqFpMKE7r8wLVYz86yR6zre2o3+mbXTOeuWR3Fp2xtrQKDVgAyT/X3g+4qlQFAAyyf9t/kg7dZiklqti+ZXIhIAUWMDWc3ycQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ge2snK3AleGYCV67D1XwlNFYMSlN5mQ0z/6HnZIdYeI=;
 b=OvM32yMh5sKKuuo4+KyoQ9PEyIpcAuIvnEO8JdKNoVwuJ8qjibjyrzMkUSqhLbYq3+9UB0wfkHv7TXvZbBoBWGW5lGOrGt6VVVt1+GAqGBZcSQnJwFc5awICvRBPRF+242uE03vQLnmbZh2jJlIPgSTMc2w4yVBhJjK05afxBYA2a1D+5hv95T6jBqYoLVYmXjIgU6sgP1D3KrRPbbFbw7PRpGXXDVy2vQvO2wh4g7LIUPzl32+UD6v40jEAZXt8QWL5RTE3wdd08qGZT/v7IciW4XrRdRC2MgFJ+7pXzMRRCbNqzMKSN03LKuvGUEtcALcXPOue4eP5UeZfeLDqOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4745.namprd12.prod.outlook.com (2603:10b6:5:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 06:30:10 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:30:10 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: spectrum_dcb: Do not warn about priority changes
Date:   Wed,  4 May 2022 09:29:05 +0300
Message-Id: <20220504062909.536194-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504062909.536194-1-idosch@nvidia.com>
References: <20220504062909.536194-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0188.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::45) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72c25401-fe45-4321-ea38-08da2d978997
X-MS-TrafficTypeDiagnostic: DM6PR12MB4745:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4745B787FAA557DDEA537C6EB2C39@DM6PR12MB4745.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fAgl+yByqWipDbpFTARusJzAQ78kJt44UTb34jWujmOi2N/718knGThIihNhh8Wt4ZTfiw2hOQynJj2dxXIF8ZVuaWoiiEOeGfbjpTb9aHzLr8f8mBV5xVqvMMqUxM7o5dA2UYSnC21jOae8KBQ6mol+dnWPTxts9HeM3rB0Plzd6MZrEKxqQVpyJLWHwYizJWhVntpEd29aNaLJSdNVTnOO76D9Eivz/1kDjM1V380Vc/x49xDeoW3lM/KP8v5QTDW544OSLQjyw9fIjzFjMfU1SrA11wcENOjisufmJB/6wD/yzLS745kpTvRt9srT9rKox8HK62r+V2KqjP+1VOhe93hEXLMr8kqD29hJSjWNuWfwuXvU5NxXio2TpaF3vKibjQCBLdkpaeBiZttjAzv5QxTcXn62WSoIBUrMElkZkLJdjRUE0fpXG7N2XVip5olaOpR9aBPfobn05XgEmwXTo39CBhfPX4HkzvWpRJn+edjFkD7hPbfmZYCeZBWXD/w4OKhQQtbrGbiL4aflXY4KCn54SXboIO3KFx6ppRRfPdcVJ1CwKyRzvmxQFh6El9N90WB7CzO4p+J+FNvf7Tj5NG5RzewRIGsdkI2fyzRVVDvPhdLJVHnSVsCLK/FQJyi0O3HrPaSFMoWwS+N6gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6486002)(316002)(66556008)(8676002)(66476007)(4326008)(5660300002)(6506007)(6916009)(508600001)(86362001)(36756003)(38100700002)(1076003)(186003)(6666004)(26005)(6512007)(8936002)(107886003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rx3GASdJvX0Apb5pj1KRUMp0FGH+A0WDzvI8X5O3FCtFc6D7rizN/j1E7hRX?=
 =?us-ascii?Q?uoMr1hCuzkkn/Xgw6Vy/NuWlfergJJPex2jt/Hw8wmvq0HED/eZNIA57i7kp?=
 =?us-ascii?Q?SwTH5NQEdXwzoKpI9q4GQPYTEOZrrfZukKYnYm2H0abze0EkEy9+qT4EKKzG?=
 =?us-ascii?Q?jsbODuerlspVv5E8kNoqWS1MwB0SgkTIFLi6KaDmfxzMgJFnkj7r+yPwLeD0?=
 =?us-ascii?Q?kob87pBSdQ5EAu8gplVLWD42FxTsd2lHfBEPZpvocFVo7DyTdQJ0regyUMpj?=
 =?us-ascii?Q?z4PaNt/qKMxxkurzntOv7Cnv9f+8BM/cZbwSpQ0uqPFYx6z6PCKaqA7vSkBD?=
 =?us-ascii?Q?MyqwpEROfXq4QJfdPdWKn7VdjRvdMQJCbYE1N/3KLQl3LnBw9S5pWl13j1Vc?=
 =?us-ascii?Q?Gp3uZX11D6CxNRV8bdvHUXPJLpwsPV0h1TuVAJ5/W2JBwaTrnB6eW7sLJmxI?=
 =?us-ascii?Q?flIfe17KaMFb808lOj2v/iwmVx349LcidKf97vkfaGlimoyxuLBetdl7PMOy?=
 =?us-ascii?Q?F86gvd5sUdY/apJOxmAtIuEGmKnT/eU0TYavJQETEky5Y54jiHsfb6echcI0?=
 =?us-ascii?Q?Csnq3ralX9bWhFHVDJdYwudKemu5LtvM3A3od0k4+/PTn3/UnV6FZRn82ibh?=
 =?us-ascii?Q?Gsmb1O8UCT0AS5Cg65QR9UZEO+MFeUNHatH5Z8CDkknxf8U/lwl5GVy1ZVAO?=
 =?us-ascii?Q?lmkOF7YXqDr54koLx7zhQU0VYkUrha8r8s3t0U30+yMnd0fGORrM4Ar2Zhci?=
 =?us-ascii?Q?Eg0qQ/ZKrdHm4tTLZH78M6XeTQcGHGmmrJiHDzujy0IZYwdhN8OcLowxII3r?=
 =?us-ascii?Q?jmiNqM9teZECkCuiIECGGS8Bf7Mn9SNTYMs5tr6efIlbhwjI6seV0UQREeNh?=
 =?us-ascii?Q?rw5brmTZtgX6zJAe2oC3UVtGiiZiJIT4KFbriGOd6VB9JSMpJ6GQwuPohidW?=
 =?us-ascii?Q?pOgZ9YZlRJrklVxiO9pwIQW7wiPBOsMug5eVNBFjvTyls98DAEGmyB8R9Opz?=
 =?us-ascii?Q?s+Z0SPSBDk12ktKDxZcgq4tlBOYcGBnZ3clQTs1mhw0cjyDB3UQDfOohnb94?=
 =?us-ascii?Q?zeVzbQwC5h2wTWM9pCzJm6J0TfMmn5h28c9eHy7zoqMXeSYW7OWX+4gpCRUA?=
 =?us-ascii?Q?4OoNoIvMCbXxTnyVmUJsws5A6sBOa0W6sW9V0LA9oHV7IQppjTWCypaV3p1M?=
 =?us-ascii?Q?IqVnKO7coGiXN3MaetpDSJsuAFTI5a/dZDcWDDXx9AobzsphnaPcdcJEdaf8?=
 =?us-ascii?Q?1PxJQ4RM8xrSMLxvCvbkdyX8faF/XHlZtepbXdnIJwc8zcwHlxAZ4Rc6rZIz?=
 =?us-ascii?Q?U3aWh51/dbz+FgW4hp/gAmf5Yejt2Zdv9HYOwOAknl5nVkd+0AKHpavU3bmz?=
 =?us-ascii?Q?NvBp83WR/6Rs55CAOg2zV+o11iKtU+atLBHUB0rktNpoWGCg0ZgK4xp4fNxf?=
 =?us-ascii?Q?ydyVe59Rk7QHwqTRf62F9qwCWkDCunWUAQB3JgE0auuYo+LIBUTTMp6BG1Ql?=
 =?us-ascii?Q?98poVp4H8r87vUXsOAETb+n/j7PGecqpcqTrPH+3diJkMT3Wr4tWPR/ARk86?=
 =?us-ascii?Q?JTLzyPlCn9rWS58ytUMGiYsKI8oSHM+OQduGu8M0+evM4zYBpnCUVL+Pq6wF?=
 =?us-ascii?Q?Fn5rH+kCA3pK64UidHYqspqJXBcInwOfR2vAmvYo5vT/umA8OoEfyjwhaG+y?=
 =?us-ascii?Q?Mry9gfE6C79EV08LsPYvKwlovxbFdEh1byluNXF0tv/2QDWXHbW2glvNvESD?=
 =?us-ascii?Q?BvWYhG77+A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c25401-fe45-4321-ea38-08da2d978997
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:30:09.9499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Suk/54LtYQpYENLTMuZai/zxY/m+35VmfNxkE4579zB4IaSnPa7WNISGGVAr1roavo7tMxI/yDhi0TfsWECiBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4745
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The idea behind the warnings is that the user would get warned in case when
more than one priority is configured for a given DSCP value on a netdevice.

The warning is currently wrong, because dcb_ieee_getapp_mask() returns
the first matching entry, not all of them, and the warning will then claim
that some priority is "current", when in fact it is not.

But more importantly, the warning is misleading in general. Consider the
following commands:

 # dcb app flush dev swp19 dscp-prio
 # dcb app add dev swp19 dscp-prio 24:3
 # dcb app replace dev swp19 dscp-prio 24:2

The last command will issue the following warning:

 mlxsw_spectrum3 0000:07:00.0 swp19: Ignoring new priority 2 for DSCP 24 in favor of current value of 3

The reason is that the "replace" command works by first adding the new
value, and then removing all old values. This is the only way to make the
replacement without causing the traffic to be prioritized to whatever the
chip defaults to. The warning is issued in response to adding the new
priority, and then no warning is shown when the old priority is removed.
The upshot is that the canonical way to change traffic prioritization
always produces a warning about ignoring the new priority, but what gets
configured is in fact what the user intended.

An option to just emit warning every time that the prioritization changes
just to make it clear that it happened is obviously unsatisfactory.

Therefore, in this patch, remove the warnings.

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 5f92b1691360..aff6d4f35cd2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -168,8 +168,6 @@ static int mlxsw_sp_dcbnl_ieee_setets(struct net_device *dev,
 static int mlxsw_sp_dcbnl_app_validate(struct net_device *dev,
 				       struct dcb_app *app)
 {
-	int prio;
-
 	if (app->priority >= IEEE_8021QAZ_MAX_TCS) {
 		netdev_err(dev, "APP entry with priority value %u is invalid\n",
 			   app->priority);
@@ -183,17 +181,6 @@ static int mlxsw_sp_dcbnl_app_validate(struct net_device *dev,
 				   app->protocol);
 			return -EINVAL;
 		}
-
-		/* Warn about any DSCP APP entries with the same PID. */
-		prio = fls(dcb_ieee_getapp_mask(dev, app));
-		if (prio--) {
-			if (prio < app->priority)
-				netdev_warn(dev, "Choosing priority %d for DSCP %d in favor of previously-active value of %d\n",
-					    app->priority, app->protocol, prio);
-			else if (prio > app->priority)
-				netdev_warn(dev, "Ignoring new priority %d for DSCP %d in favor of current value of %d\n",
-					    app->priority, app->protocol, prio);
-		}
 		break;
 
 	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
-- 
2.35.1

