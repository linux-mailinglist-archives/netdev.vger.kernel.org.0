Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DDE640F09
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbiLBUQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiLBUQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:16:12 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E83F465B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:16:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekY/3qwOGO4vVhZ+ZueCAkiKnjS7J4SC47IN5WoyWtpGKJleboTo5JzqvNPZrP9k+osU1FaqSV6hLkFKum5aE4z9oIUT8VcE0Ehhp0UBcnqre+NvT7EGxzvvaFmPMFqNeeBiGgLYXFMsv/wtKytuKWax7Mc8Ae/vcztlSqYBU8rj+rpKCHNzJLBw2IaN9fxL3LU3bNuFUignZbutJ1oyHkFDiOsPuaL0eW6Ez9hC28G6zUZMvwUjpPIOaF6w/e/TvpsjpwicuMqQ8/Au98I3puQYkQmTerMxTVa8swahq7Pk8VD+pnWWhM+HpjncFVc4wdzbOMZpoPB6hbEB1LtDvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNN+eOGGjCnxpVx9s2GEEoY4WUM/e/BbX9jw8vzbk+M=;
 b=BvLHiLwjW/o6oWo2IaDL0tCZisaF5aI+utReqWDcWOehyDv8+lXRq7l4w2uEjZHJn0CuuMg2888ZPvcxK/U5hDex6Q6/4atcdvG0n+UK3qlANI1G9mRwPko6ipzXN50Ua9vMrW8F7cJpULcCwRsy2b+jWLpj1/G2VOJHM2lKEx4cEfxpsTnvgIRbMGsoAjhCZtotR0GPA4rrea9DSGY5dFxRJeWgq/6su/MnbVs4SBOf1nMzBKR8zUkCSqZlfQdyDeePosyDwnedwJqYjiL4ZrbvWXcK3j6VllNc/TmZgnSFJOEhKMXXm64GcC4yKm7oUplizh9K9qOcFo5kwoOMnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNN+eOGGjCnxpVx9s2GEEoY4WUM/e/BbX9jw8vzbk+M=;
 b=QwV6bzr/bAnpGiv20pPJxqDVnUjkc5SID8gzsWOqorkfAF/6r+pyh0uz4qqr/Fda1hxVTc2BgUAc3Z85HpY4A8+SAhkMhkW43sqGhM5CmGsExiSENfof4vWQDTxc/AGkLjWidYo2qBb7/ILPlKR1bwEJAPMgFVF6Ii4QOPMCO6RuLg10OPa3b4h6+6W1bM5M4Z0FxQTW9JPSuS10YRODJ98z0x+NWJb0aZRZkkM4KeF3e4ZLe17EgPew3zd4oBf9Bwgc2IpWqD4JQKT51XEP7wgdrCKKHmc86vl/LAE7k5mSrD2JkdITkcSWWGZZGBAn+Cob6VfteNTYX6xTZvZobA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by PH7PR12MB7308.namprd12.prod.outlook.com (2603:10b6:510:20c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 20:16:10 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175%5]) with mapi id 15.20.5880.008; Fri, 2 Dec 2022
 20:16:09 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aya Levin <ayal@nvidia.com>, Gal Pressman <gal@nvidia.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] ptp: Add .getfine function to support reporting frequency offset from hardware
Date:   Fri,  2 Dec 2022 12:15:29 -0800
Message-Id: <20221202201528.26634-2-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.36.2
In-Reply-To: <20221202201528.26634-1-rrameshbabu@nvidia.com>
References: <20221202201528.26634-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0177.namprd05.prod.outlook.com
 (2603:10b6:a03:339::32) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|PH7PR12MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c63a674-9b97-47c9-6450-08dad4a20d33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJovMM27TkqdrG/MBa5jSV+THpsMl+IZG4kHQm5frZI6wnlYsHVRpP8euANn1vIXVgOljfgFjce3OrkHvdUteHnu2IRuYY9zNcdMS504uk2GdAGV1FuTg7O7CQR/+bUO4JaXpy7zaAb5Of1wfdxyERQvGGnzD9Xk7pdaHVO/NQsMKggBaUBNLbQFBbZhTYb5qrrl6l1VGeQc494DkwnxUc9BRzaibLra/my6j5nCqKq6K11yDjjIE4l9BiLoZY2aUDVf411QASpJ6uNOd6cpbmEdaqmMo4arqM6vokw4TUsuT6qnH8CJpvX2AEyD0smR67V+mbKKEQz3K2gJnDl6iIrQxOMZNA7Suam7fQNAeRpwyVzXkvNvp8ezdAHYT2sKtsq1a+flDn3TZZ89I8GzOk37jdqMw/LVhuCqFHJrmQGm7ghVRmQcsfXa5fnzEjuUbU/+n4NmmjMPoDjUGdlM5ZaAFM6IGi8XA1ijAN/1GXPnDW8vhuUKzFc2UTyo+Ebk346rExhPMx3EnXAPByjY1U7Uw7Oyziqhz5C0T35HzNZm06fKihWBgMtkGW2ogOQl4A4KfzgbL+ebRZhqTPyWqwucoMxlbUcj6hxI/k54GbSvu7/uGLT8LdeWTK2ZO9mqE1MFvqT7MsqMSrHTBEoW+8mBGSHGoCWHJiN+G9ZbqTXzqjKtxqEev/33CQq3UCg165oxa3YcKZFsosuaAMLCWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199015)(1076003)(2616005)(921005)(6636002)(6486002)(316002)(110136005)(36756003)(86362001)(5660300002)(6506007)(6666004)(38100700002)(83380400001)(186003)(6512007)(2906002)(8936002)(478600001)(66476007)(66556008)(66946007)(41300700001)(8676002)(4326008)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?olskB0tq+Cmsc0UcH2DDctmvjobCe+kkaqfSmnGcgXD5GxPM5IrXl8hzBeXq?=
 =?us-ascii?Q?jz2boLFM5Nd5q5lTdEeu82qEx30LdE1ItuHVzI8txeIpaL6z8BQRfaqaAmB1?=
 =?us-ascii?Q?CL2JCY4wHixnIYwCMEh+U0gKNVwdGpv/N0GkeZuumqzZd/duspJ7Dfdys26x?=
 =?us-ascii?Q?ngC8ymOq+EafeW+t7BKrL6/BMxP8vnO57A0+YH9PF2aSoUx64J4oHAXfPslz?=
 =?us-ascii?Q?INq8b25pki93oKJabdx875nTTy0LQDL4Liy4ovGGxLU0t8gWi6IZ8Tu/rASw?=
 =?us-ascii?Q?6zRQr699+x7ZBfVeonGlhC4Wvh3bna58+Ml4utF8NPNit91qAHYf+KZeivzx?=
 =?us-ascii?Q?SGYSo0Ih1ZecULTUBZRzoV5VnL03qOsiF6xp6l8FjIbLa+Jn5oBVH1kvbyrX?=
 =?us-ascii?Q?jyfiNgeMFGMKWpoB0/4r8Lrrl5UtmzrYiLK+6fVa5wOS82vrPdICxRo0vPj7?=
 =?us-ascii?Q?FfjxR03lri5yEn5H9vEzqenMG5WhF39oXHlua7h+Qf2AC0n2sKHB1lvqVmLv?=
 =?us-ascii?Q?gsjiI3XI+QoIQ0LefggWXqqwQJg8OS+4kRATjyi/8NGplSDvsVbI2btomcxV?=
 =?us-ascii?Q?LCrb9iN+JKPH9MkFCLdDgbsvz4Py7olsRRzj6+6GekYkmcoUVhGCAg2Z7RJy?=
 =?us-ascii?Q?1v0VxtjNK/U1FlgULEyaNz0rsdYRVLFE6FrcDb8ia9w9P8bnQF5GD/qjDJQA?=
 =?us-ascii?Q?yN/g7fqRqC48AydgQf1uJwq06Sq3U/MkRwrXDgMN/DC2S8MPgbxt2oeeVbKy?=
 =?us-ascii?Q?2ukELmU1PGuGyBjZVrXsNTQ1tJYSrwqa/JeIYKEVDnwIrK+HRyA02fy3L5iD?=
 =?us-ascii?Q?7zcHO1iRiQNHC832eJq6ffedouKljhwpJ/DzSxSBLAUYPh0GVH35kO4uky8U?=
 =?us-ascii?Q?EDhubK+VAKo5A0qkD14iux042Wjk2s2X6PLlGu0stuIKcGTyb3igPSRRHBsD?=
 =?us-ascii?Q?6BvYTu0U18xt78RHCA+AKHl8D1jANV0Re69LFU6sK7UQMy8bXG4wQ55FdVy1?=
 =?us-ascii?Q?UW8/CK//WR231RNuGK+Wrz0+8I2zgRv4xhuCg4Q8ELJrO6TXGBVck6cahuR1?=
 =?us-ascii?Q?cBZ6XR+yw7yYe43tzJKif7nBVL+khbskz6VgTDAwSoZrasNgpMLmcmZsJtoR?=
 =?us-ascii?Q?tnoka3gC+yH6zEvzLXgKtYPZOK6/1v/3nKnOXDfdjjV8Ynte8iPkaxthvGzg?=
 =?us-ascii?Q?M6ZSqs8kcbCem/fK3GAWb7lNcgYsjzncpZtkiabESL+DCesIekKiitPClb79?=
 =?us-ascii?Q?04yKLJIMcF+QJvxAFAZyEypVhCoP3nxfS+COlLl57NokeZEeZGx0CRVvAFai?=
 =?us-ascii?Q?vbaAE3HA6e65zmwnSobVEcUtRzfFVeXD1fGwTJ87Ki95Ev7pwxxtuhwo6nTB?=
 =?us-ascii?Q?aTjtOjj7dwRK942uwOPJwTNxp5lUZ3EwlztKl8piBQqIA3KJyIP/Lb7P+Zqf?=
 =?us-ascii?Q?sj2lWb4Hb4/92qbHrShHAr1Q4RxS5VZQ0lN8uu8waPk72lj3jtdkQOprOPrE?=
 =?us-ascii?Q?7tkSfe6TFUnUbi4TVde1sTX5iT4aRKs8zEAnKQtial0Vn0tseatCgMPlAQse?=
 =?us-ascii?Q?bBGx4OKK0EVlcWaf3aSj7O5nQLrtRt6F6+zZBplb0bPYrmMvX0w78/ffos4R?=
 =?us-ascii?Q?gMMiM71ukjvBQFaMges4GQGpFf8A1BSM9TB7ALGnslLJmIzDdi/BneqiQw3x?=
 =?us-ascii?Q?RsgU2Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c63a674-9b97-47c9-6450-08dad4a20d33
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:16:09.9171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1HU5xkFE4omw4amUlUMyeI0jzxUSNmsDtW9QMrFnPiZGwIDTvuvSweXHqUSyQbrefYLjFMLIDpD49EV4JwAUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7308
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Query the hardware for the operational frequency (represented in 16-bit
fractional parts-per-million) instead of caching the value last set by the
last adjfine command. Prevent inconsistencies between the ptp driver and
the hardware.

For drivers that do not implement the .getfine callback, the cached value
is used.

The linuxptp community has seen cases where the cached value for frequency
is incorrect due to concurrent ptp4l processes adjusting frequency but each
using a stale cache value for frequency. The .getfine callback remedies
that by letting implementers provide a method for querying the frequency.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_clock.c          | 18 +++++++++++++++++-
 include/linux/ptp_clock_kernel.h |  6 ++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 62d4d29e7c05..1655381ae731 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -66,6 +66,22 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 
 /* posix clock implementation */
 
+static long ptp_get_fine(struct ptp_clock *ptp)
+{
+	struct ptp_clock_info *ops = ptp->info;
+
+	if (ops->getfine) {
+		long fine;
+
+		if (ops->getfine(ops, &fine))
+			return ptp->dialed_frequency;
+
+		return fine;
+	}
+
+	return ptp->dialed_frequency;
+}
+
 static int ptp_clock_getres(struct posix_clock *pc, struct timespec64 *tp)
 {
 	tp->tv_sec = 0;
@@ -143,7 +159,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 			err = ops->adjphase(ops, offset);
 		}
 	} else if (tx->modes == 0) {
-		tx->freq = ptp->dialed_frequency;
+		tx->freq = ptp_get_fine(ptp);
 		err = 0;
 	}
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index fdffa6a98d79..f17097de349e 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -77,6 +77,11 @@ struct ptp_system_timestamp {
  *            nominal frequency in parts per million, but with a
  *            16 bit binary fractional field.
  *
+ * @getfine:  Reads the current frequency offset from the hardware clock.
+ *            parameter scaled_ppm: Requested frequency offset from
+ *            nominal frequency in parts per million, but with a
+ *            16 bit binary fractional field.
+ *
  * @adjphase:  Adjusts the phase offset of the hardware clock.
  *             parameter delta: Desired change in nanoseconds.
  *
@@ -168,6 +173,7 @@ struct ptp_clock_info {
 	int pps;
 	struct ptp_pin_desc *pin_config;
 	int (*adjfine)(struct ptp_clock_info *ptp, long scaled_ppm);
+	int (*getfine)(struct ptp_clock_info *ptp, long *scaled_ppm);
 	int (*adjphase)(struct ptp_clock_info *ptp, s32 phase);
 	int (*adjtime)(struct ptp_clock_info *ptp, s64 delta);
 	int (*gettime64)(struct ptp_clock_info *ptp, struct timespec64 *ts);
-- 
2.36.2

