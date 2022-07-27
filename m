Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3176582007
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiG0GYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiG0GYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:24:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5998640BE4
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0XG/UZzc0v5Skqwe6tNiTOH2E51OHPmjuRCA7XjP2TF0zhi8LIc+Q61JGQwayCvgi+IDIY5DM2J1b3q3m+yDfGUXB9IKummdoSipr7nVJJ8ubboSJ8b99vXZJ+1Gbf+7uGv79n931AHSizXEj5K2Dv7tnX+qzB9UUO4tFjCC6zP8SU0N8FndL2CsSg5zq5Kqj1KKcKV7wM/KNqnK0f+eU2r9ln8zfXp9yiRI6zchl0dy6isCwJkV6Uyss77yoeAREptkud7Gq8/mFoFHKJNl9HQxLeA7xH4/gOyD8jWa737BrwsNZWQGClIwtzsh6JQ45EXgHaUpNYBph3QxNNxrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/tNZPZdVhh7gLWmS/lS7R08nhcW+09SzIckH2lciO8=;
 b=hpbV3TvsUIEHEJf+0iKr/JxTrAlyTeFgaOXLBNpImUQE2uTkA5urKwO72XKBJsUYnN0NFHwuzvPKf/OYj/TW3oAgAXRWmf1Vqf2IEWF/kTzQgaBxmYd7gRqQYy6NsCm+OrzwL1CC1obPYtoxdUJFYG0ILH/0HZu2CR36ijLhjznManZIp3quPTMs0aDIEHO+k1DlT9IPIL7Sd0LsbALm0dFfiO3CBrweVLNB/vowxDf6Mn9Pyg7vGXXqq75kyv4QXOWBMa88KLoOpKeTGoOc7gdyM2EeL7PVznelH6PbOrOJ8vfYwtS7KNHsPuqlmyVZ2jbJcQSARVjbXLNX4hy/XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/tNZPZdVhh7gLWmS/lS7R08nhcW+09SzIckH2lciO8=;
 b=euOESDew9UFwWj2fcAH70qb0goycsqBHBAvn37tpkzJeAkq6oKR3AnI/ISmrNdHcVwSW8F57lmQHK0qds5czj62Axy1/f2WPbW2lao4yQXdFfTlfF23QfXErRhmx/58EdI+xjYO0pdmIcHcXDLMwAJccpVmm+rM4xBh5WFp8cREOf4haZuq5+EYixbUOdYEx921akinIo9mcS+wZBPoeCyFGwD+FCbNj3xIlc+CblEsA6Ar0Uh2ipEi3lQhoywye6wwlkyYLGOsd3tUk7UYUNz9ENBLdEtpzZs6fUxZxGds0cRadBZSsAJO61kmDdUxz/wic7tMOuXzQaXMkI/pT5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 27 Jul
 2022 06:24:30 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:24:30 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/9] mlxsw: spectrum_ptp: Add implementation for physical hardware clock operations
Date:   Wed, 27 Jul 2022 09:23:24 +0300
Message-Id: <20220727062328.3134613-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
References: <20220727062328.3134613-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0182.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::39) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18c5c93f-ff79-45ad-7623-08da6f98a9b9
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6243:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2ofZ2FhAno1r4uOfeD/00HGvOUrd9fEraGtNEPY5ZwgjKVx5bWBnK2lBAn8mykcmRlmc1UqS+gh9pIsLWZcxCPFh5w46050zaQFnBDogHUuVhOlOX7fpUT9U5GTYWnbNAwrOXy+cJlkf2VdJ0ZoOkzYxUIRqdVS7lpcZSUvHAb1RWc/yLIKhTF/wQg5HDKSwyqjEo9oTFrZTLPI8d3/l+q5mdUP7k46Nlcjl79RmJoSsRaGbgJ1uzWNMhGgzL3Fr08a3O2pIK5f6OHOWwqzKxgb5XsZiYhXFFjI1cSW3xXK4jlJjXxtd/bjaiHpQ0xC0ArcEdl+JvHtx9IXm2KX8zrgkwtPta+id1kAbSN8UFQKKnqrDlzsYl7Yx48IrCmNrHgigKVnjnMQIArc2tqIzJZ64fQrf5okg3MV/t75LUxZFlYXFdBUJ9MMGi0J5OTNhZebXgNwsD2xN0hX1YZJf70RrwLi55Teq1Ghv+3gVTgO3I3Knth9qbEP0BUB/eJUyM+oHArGVIf5xC1Kq+au5wv/Ypg5yW1s03Wf6SVHHvNaaPbyo2wwLiApH4LfaWALllHExTOkLqEsCPwQ53M6BHhNQQb14B6UHNGMWur3pIysbjqAfpVvcOCHRaL8tEAY10kmsr2nRf85iMfR0mrDTRTjweo/6jb8wf69e4yIGlfUA/D9UAaL0Yaw/lW/isKFxT8LiymVsxzYP6+awKJgOo0uzoPhTWAOgaRhl4vBaqaMAJo7XwH32S9GUDp+TFiM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(41300700001)(66476007)(38100700002)(6486002)(2616005)(66946007)(1076003)(107886003)(478600001)(6506007)(186003)(6666004)(8676002)(83380400001)(26005)(6916009)(8936002)(2906002)(5660300002)(316002)(86362001)(4326008)(36756003)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BRcz/FH4vTAiihSprIRm96XT3NXQjz4DXP6KSIHyJXadqoHJs4ao1Livz6dl?=
 =?us-ascii?Q?xjxcnazSVBEjVLQKdIm5txv/tj/Y97WsEaV6zK6NYIewblfqps7A48djK/6r?=
 =?us-ascii?Q?7ZH/YIPw+TDxJvT7pZ57N4Q5ZdopVaOO7bfzmL+JkuZibSVyPItXDM3QjEer?=
 =?us-ascii?Q?qtHDPA0KMZf5CYcdicqQOVx8iSUhpJyZdzZHLuB0KWWXJjKnNulkKdyIBPnp?=
 =?us-ascii?Q?bKQP1PoRPbf9744YO/BxvE6Pn6/3K3Nkofv6CBxUm2RrbYsQXXas+IzuWsS9?=
 =?us-ascii?Q?5oNyZzZ2tZvwGzcN+6b/6ElMbJobL7vWekeUOtOxv2oeLRPznog8tHtxb19V?=
 =?us-ascii?Q?JMBoqwlsb7ce6hKTpxwLmP3jZ/zBKRWahRt5qUYp1TLIF/WJ0PnBlBG4J/Qn?=
 =?us-ascii?Q?yIn1gWYrDWhKXrRgXBFlNFVoS/kK2Phr6aN4M4pD/ab1igFysF1AO7oNDlxr?=
 =?us-ascii?Q?WlUGHKA7YFOtu810werY3OTM9MktqEAo+zjMDUDFWxRPiDfg4a2LKF8bGvQb?=
 =?us-ascii?Q?X5eEqA2VNrenwORee/Ln/LJq61L0cHGGMC+6mh6aAtD8AFkKD6lWr1vqHtBC?=
 =?us-ascii?Q?w/v5ICMGpG+86WPmieE/ududacY454BJvYLWM2O9eE660Erpad0xiR3jphQk?=
 =?us-ascii?Q?xIgYCRMbtYkDhY/CxkS4DyxIWXooR0hAwlXSd82ckXWLEDR0cituyXhyb9sK?=
 =?us-ascii?Q?xYHxiG3fpewO7AZL7wkbXUJaK5yVU9JvMpaY+J+2pbrRUS0b/HOyyrHN2rKm?=
 =?us-ascii?Q?TAWzirP6Wb5Uu2rOejFb8U9z6skOgZFCdRt1Q7g7BH3UOp55EsEaWKa1PVZj?=
 =?us-ascii?Q?aI/2wQ7NTAP5wqN3QTNn8XaAc4lOBWmFWXdFvRJ6l4Ueqxvl8UrGVjx14KPQ?=
 =?us-ascii?Q?46500hTIyO8VHTumNdHp3qHwLhU/nhGyJaR8B42AZtXYQQXMXbOK++94iA1J?=
 =?us-ascii?Q?mCVwOMdITlRMJN11BCx7vabwF2MgU/RU4jfmI0dUtiBmJAyfN25OBr9D0S4y?=
 =?us-ascii?Q?Vyhtzqyw4c/3lxNeENpDVxe7s64FiqQT79qn54WS6b6Zqc4iJ4XG2Y4T7r/R?=
 =?us-ascii?Q?YYMglfAEPfzlNz6dOYj5w8iH0PUd2qwmpDQMfBKL/nGBsi8gMN/x98cdJeB4?=
 =?us-ascii?Q?K5tzhYKvE9Xx87ndv48MjE7ib9sUoseFb0rmNeGPW9gUPboi/HjkXDEUTff6?=
 =?us-ascii?Q?6y0WASkGktN4V42/QngHxCMecvZ6vpvQv6L6xqkP2C388l6LQlH07CgmCv7+?=
 =?us-ascii?Q?jglKf2JpAW7+YqhV79tEqSzSAeAkxAmKVa12xU6jkGYF+XKxcHTY0tPDHV6t?=
 =?us-ascii?Q?BZMgUB3zOJ39cFcUEvlLvOxYW3ZVwyP5t90ytQyQuwT2aqPdHaO6t9HuraH6?=
 =?us-ascii?Q?NmVNbvN4PpImQg/BKkIRp0mSEw7qwiWYRL8nO+2b4JJ7Mz0XKl3Xb8P0zoY8?=
 =?us-ascii?Q?XExjwnlVgf7EyLvpahjwbQ/X+Ho0z0ODkggsYBcwATLqQoNCBzNvN5Pafgws?=
 =?us-ascii?Q?bv7y5P5T6YussgiJWLFNXSPC9LPXHLgAxWrDET1O3aPVgSW0znewyXEShI/X?=
 =?us-ascii?Q?v2Ro8YrcPq/kKfqaK1GUw9vL5MsqfR+gRcxGsxqq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c5c93f-ff79-45ad-7623-08da6f98a9b9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:24:30.1905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLb+gi+QpqiXghAxtgmhgskfgWAnjoc358nE3W/Wbz9itx8iBblJ1N33Jfws6otXgGSfbGMQ4/R+UxqVyddhMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Implement physical hardware clock operations. The main difference between
the existing operations of Spectrum-1 and the new operations of Spectrum-2
is the usage of UTC hardware clock instead of FRC.

Add support for init() and fini() functions for PTP clock in Spectrum-2.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 147 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  19 ++-
 2 files changed, 159 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 04110a12c855..dd7c94dd4c01 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -339,6 +339,153 @@ void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock_common)
 	kfree(clock);
 }
 
+static u64 mlxsw_sp2_ptp_read_utc(struct mlxsw_sp_ptp_clock *clock,
+				  struct ptp_system_timestamp *sts)
+{
+	struct mlxsw_core *mlxsw_core = clock->core;
+	u32 utc_sec1, utc_sec2, utc_nsec;
+
+	utc_sec1 = mlxsw_core_read_utc_sec(mlxsw_core);
+	ptp_read_system_prets(sts);
+	utc_nsec = mlxsw_core_read_utc_nsec(mlxsw_core);
+	ptp_read_system_postts(sts);
+	utc_sec2 = mlxsw_core_read_utc_sec(mlxsw_core);
+
+	if (utc_sec1 != utc_sec2) {
+		/* Wrap around. */
+		ptp_read_system_prets(sts);
+		utc_nsec = mlxsw_core_read_utc_nsec(mlxsw_core);
+		ptp_read_system_postts(sts);
+	}
+
+	return (u64)utc_sec2 * NSEC_PER_SEC + utc_nsec;
+}
+
+static int
+mlxsw_sp2_ptp_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
+{
+	struct mlxsw_core *mlxsw_core = clock->core;
+	char mtutc_pl[MLXSW_REG_MTUTC_LEN];
+	u32 sec, nsec_rem;
+
+	sec = div_u64_rem(nsec, NSEC_PER_SEC, &nsec_rem);
+	mlxsw_reg_mtutc_pack(mtutc_pl,
+			     MLXSW_REG_MTUTC_OPERATION_SET_TIME_IMMEDIATE,
+			     0, sec, nsec_rem, 0);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtutc), mtutc_pl);
+}
+
+static int mlxsw_sp2_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct mlxsw_sp_ptp_clock *clock =
+		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
+
+	/* In Spectrum-2 and newer ASICs, the frequency adjustment in MTUTC is
+	 * reversed, positive values mean to decrease the frequency. Adjust the
+	 * sign of PPB to this behavior.
+	 */
+	return mlxsw_sp_ptp_phc_adjfreq(clock, -ppb);
+}
+
+static int mlxsw_sp2_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct mlxsw_sp_ptp_clock *clock =
+		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	struct mlxsw_core *mlxsw_core = clock->core;
+	char mtutc_pl[MLXSW_REG_MTUTC_LEN];
+
+	/* HW time adjustment range is s16. If out of range, set time instead. */
+	if (delta < S16_MIN || delta > S16_MAX) {
+		u64 nsec;
+
+		nsec = mlxsw_sp2_ptp_read_utc(clock, NULL);
+		nsec += delta;
+
+		return mlxsw_sp2_ptp_phc_settime(clock, nsec);
+	}
+
+	mlxsw_reg_mtutc_pack(mtutc_pl,
+			     MLXSW_REG_MTUTC_OPERATION_ADJUST_TIME,
+			     0, 0, 0, delta);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtutc), mtutc_pl);
+}
+
+static int mlxsw_sp2_ptp_gettimex(struct ptp_clock_info *ptp,
+				  struct timespec64 *ts,
+				  struct ptp_system_timestamp *sts)
+{
+	struct mlxsw_sp_ptp_clock *clock =
+		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	u64 nsec;
+
+	nsec = mlxsw_sp2_ptp_read_utc(clock, sts);
+	*ts = ns_to_timespec64(nsec);
+
+	return 0;
+}
+
+static int mlxsw_sp2_ptp_settime(struct ptp_clock_info *ptp,
+				 const struct timespec64 *ts)
+{
+	struct mlxsw_sp_ptp_clock *clock =
+		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	u64 nsec = timespec64_to_ns(ts);
+
+	return mlxsw_sp2_ptp_phc_settime(clock, nsec);
+}
+
+static const struct ptp_clock_info mlxsw_sp2_ptp_clock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "mlxsw_sp_clock",
+	.max_adj	= MLXSW_REG_MTUTC_MAX_FREQ_ADJ,
+	.adjfine	= mlxsw_sp2_ptp_adjfine,
+	.adjtime	= mlxsw_sp2_ptp_adjtime,
+	.gettimex64	= mlxsw_sp2_ptp_gettimex,
+	.settime64	= mlxsw_sp2_ptp_settime,
+};
+
+struct mlxsw_sp_ptp_clock *
+mlxsw_sp2_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
+{
+	struct mlxsw_sp_ptp_clock *clock;
+	int err;
+
+	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
+	if (!clock)
+		return ERR_PTR(-ENOMEM);
+
+	clock->core = mlxsw_sp->core;
+
+	clock->ptp_info = mlxsw_sp2_ptp_clock_info;
+
+	err = mlxsw_sp2_ptp_phc_settime(clock, 0);
+	if (err) {
+		dev_err(dev, "setting UTC time failed %d\n", err);
+		goto err_ptp_phc_settime;
+	}
+
+	clock->ptp = ptp_clock_register(&clock->ptp_info, dev);
+	if (IS_ERR(clock->ptp)) {
+		err = PTR_ERR(clock->ptp);
+		dev_err(dev, "ptp_clock_register failed %d\n", err);
+		goto err_ptp_clock_register;
+	}
+
+	return clock;
+
+err_ptp_clock_register:
+err_ptp_phc_settime:
+	kfree(clock);
+	return ERR_PTR(err);
+}
+
+void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
+{
+	ptp_clock_unregister(clock->ptp);
+	kfree(clock);
+}
+
 static int mlxsw_sp_ptp_parse(struct sk_buff *skb,
 			      u8 *p_domain_number,
 			      u8 *p_message_type,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 87afc96a0ed6..d5871cb4ae50 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -57,6 +57,11 @@ void mlxsw_sp1_get_stats_strings(u8 **p);
 void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			 u64 *data, int data_index);
 
+struct mlxsw_sp_ptp_clock *
+mlxsw_sp2_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev);
+
+void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock);
+
 struct mlxsw_sp_ptp_state *mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp);
 
 void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state);
@@ -140,26 +145,26 @@ static inline void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 }
 
-static inline struct mlxsw_sp_ptp_state *
-mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp)
+static inline struct mlxsw_sp_ptp_clock *
+mlxsw_sp2_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
 {
 	return NULL;
 }
 
-static inline void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
+static inline void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
 {
 }
-#endif
 
-static inline struct mlxsw_sp_ptp_clock *
-mlxsw_sp2_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
+static inline struct mlxsw_sp_ptp_state *
+mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp)
 {
 	return NULL;
 }
 
-static inline void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
+static inline void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 {
 }
+#endif
 
 static inline void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp,
 					 struct sk_buff *skb, u16 local_port)
-- 
2.36.1

