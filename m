Return-Path: <netdev+bounces-10245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A9C72D31F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D12972810AB
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75D522D69;
	Mon, 12 Jun 2023 21:18:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D4AC8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:18:18 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::604])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E91146BB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:17:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S76IplY+B88HacOi++smVibnzV0Tgv9CIVGphoR4eLYSF21WrvNPLlVRBSI4CpeYG5/KO1Vfy61VKzzxeeSboYDPwVt6zed5YHKjRet7Qm9G0v3tN9wn+3Db+WW+828lGDOfJivUNNPVmXyi38NFg03rwuS0womTyR98YKJ4UDYHchkLqqQJcC/sJaj7PHMyu9maxTTF0RJ9EGr7dt+1YX9WBIUlQwhJLKtgjqmx+lhPXm9mgpNRUNxvBmfFtM3xNoy+t77SVvyPTtmnqHRzoWSf2tYTCS6mrGhJFGLomuByRTYuO3eERWKcEwzWhabvY5J6CfnfDwJ4t6M7WdHavQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNCiEoM0WlNI/JCgxPNHkzrynywp9Y5oBNOO/8l1mtM=;
 b=LTc1/eXiWykE9w285A72gDob9qYroJAoanUwJR9H+ZGqAYwghYUYi8YSWI3UUR8QKU6cpKKZSD1NcLmXFSiQounUpn7nxt8tTYGPY4adgJ2cC4iZ93Rmkb7w1QTR/4bQN6zUxnSXEJUkdNPujoDtlK6rDd75WcQnVOv6JxVZnrP1r9/qkC0pWJfKdtjEa2u+mA8g0+Hiamtb97Z/EW/EbS4WDmhp3y8UsG+Uo1leAuK+3PdWMc/VxRuF3LQ5BYQ0JZt0PW3Kx2Tisw1D22OQBJry0wZeAdz8o6thNCQGqNqZ8A1D3GNmC+gH+rjzbQWhUdAUh6Z3z7HZ0qtELwFF/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNCiEoM0WlNI/JCgxPNHkzrynywp9Y5oBNOO/8l1mtM=;
 b=eYmIReuSd5qK097GENfYI/u/IgKU2kHCkGTsn1joAYKqG3gI7Z2ccQY1/8M2WdeKGo9sEe8MIDgQD5OkMDYCtoQlLpRnlqEv87AqSaPZscg8bYfTl06Qd7dFYCJUgHC0eyz2UCfTL23oIF7UG1NccclcjVC/8+UQ3MdxIxPj1LFng+5UBe/6TqZgzes1j5407cfVnF2oVg34LJ6Dwy7qPkmDOMehIWfOHa9kpnUiihJpkuLl7dtwZcU3NrcNOfUeIQdlvwDyYwRJVTgBdVX+U6vyoQ5vtQhR6q3ST2i+4EUEg7Y9wlNFuW5kXE2a3gIjVoUTH987grQqpErpIruftg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CO6PR12MB5441.namprd12.prod.outlook.com (2603:10b6:303:13b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 21:16:08 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:16:08 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Min Li <min.li.xe@renesas.com>
Subject: [PATCH v3 8/9] ptp: idt82p33: Add .getmaxphase ptp_clock_info callback
Date: Mon, 12 Jun 2023 14:14:59 -0700
Message-Id: <20230612211500.309075-9-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0159.namprd03.prod.outlook.com
 (2603:10b6:a03:338::14) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CO6PR12MB5441:EE_
X-MS-Office365-Filtering-Correlation-Id: c74ac752-aba4-4191-89e6-08db6b8a3d60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0vS7PqiKBiaeJM9oV/BN4bkB2CTWfiRWYXktPpj+IBA6e22GQjNwfV42XN2yxHr2IIYygm5unZHK12BVNzEhTxgrRxbEfnTNg8ELbMwlTFpYc3X7m9jBykpZs6Lpfhpg5ZVTKkqk7EZMeN2mSBBm2AfK8+Lg3dVbTA9D9zYNeT6zU8Pq/m0RR5w1WfBW/098TqA6pP3wsQmeRnhMZc3EuGfXAO/V1ntWZ/cvjExjLG0nrZ94+d5oAqJRumzO22IeZ4dHP8Z/iLfhrL+aJTnwufH0UXs7NoRODoH8I4dRzmNvOste1B5wzK37ykK8sJtBoDsPfY+hbpYoMCY1TZyriyW0/3TXYfRFg+/AMc5gGJR+IQ9ccfw7ZzIF3NZA08Y87ZmWSk+mhdDKCimLWYKdzgRpflAFndjo5X0qvBx+CMOiMBchkhZ9moPSdwNzhvN+Gb79o39lcBiu9VtYfFkcTfHM7iJSW3gqt6j/3SCXkhT0JHMR4lxJMPIoRxCG+sWW1rgID3LxvgQ3B2j0sFNDb82LeMVyJnup8t94DBSHRCs6Y1zxDwYlxhsDUoDbPFKLsRTenFvK17Og/h347Bea/Z1R4tpvbgEW9j/stYdr3dHHtQW/TnLgbMK9r3p8s1EqV5Ttnwu+Ze9kXIJYHlEo6Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(36756003)(2906002)(86362001)(5660300002)(966005)(186003)(83380400001)(6666004)(6512007)(1076003)(6506007)(26005)(6486002)(54906003)(66946007)(66556008)(66476007)(4326008)(2616005)(316002)(38100700002)(6916009)(478600001)(8936002)(8676002)(41300700001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mC3NjgzPeErBfLtJ10/ykJXiOpDl7TFcNnY+69d+lEp2bQB0WBUKqdUvtdip?=
 =?us-ascii?Q?Varv5z6CMQIogVJDWM+pyDPXBreGt7wU+k+wWSbwv0wDZaynQWAOao675Ej3?=
 =?us-ascii?Q?+nsJR9dSK7jgbz42zwSkg9de5lxc0cl66RHOyQGZpbqKDpZXeyQhEdw9mn6i?=
 =?us-ascii?Q?OAFsN/76NZpzg+6K0mWZGwqclGL17gMvgrEtv2hoPS7mbHlc8q3MLgyAVIrM?=
 =?us-ascii?Q?ol7j9NuNeGBRvP6XCHctOm2J1HAUdL/UYRoC5GYpZ3kVGJ2seOLTSmal0yg+?=
 =?us-ascii?Q?cK5q94nyQC7wzpCce3FHd0E3RvxWBsCbzMi7aDOq2O9q8FuyaFa88mQ0tMJl?=
 =?us-ascii?Q?eTwHM6VUoxzQe91+KWd9KwCkyzhiM1Wz5b50/CxNDl4SBbzvS5TPek1dg7s2?=
 =?us-ascii?Q?sKT9dZaWO1YkgzJyjM5V6bm64ItLZVqRbXxJLH9/I0Stzfg7KFC6VxyYO8Ei?=
 =?us-ascii?Q?cuPbM/nFD7bofxath58khvJ5cPvo/SKx6rUCOeQ3nqe6b28LQ/7+G/BmVIyk?=
 =?us-ascii?Q?vaOLtYyEBcP7Aqr6d5DU40AcwSkyiAGt7l45H8bfTwi4g6CqOJ+OrN4zWdu0?=
 =?us-ascii?Q?V+XIoZWpRDLl4s1A37YuP6ULsLazc4SUax1HvmhsN63Z5xkryN45iHoTqbwB?=
 =?us-ascii?Q?MCR9E+e26MWt9UMY5aBcZ/6nABo8ed+3GpsLRq8Tjj8T8gzH4vuSF/ruJbqf?=
 =?us-ascii?Q?JZajdJC1iAo/fn6M3t4bbpTXmprL7L+R0rrmUCO4hCI8O8UR1/7oHc5OIFW4?=
 =?us-ascii?Q?YICafZX9rGrp5eARPug4XZqCJAD3lj490YrBG4eAlg8pW41XsPvVtFGj7YaO?=
 =?us-ascii?Q?fXIuZFtkCxC44b7x8fB/BkSlHnNhSPqtYZ70Iu6XehBsvccEKbCHpcEKhB6K?=
 =?us-ascii?Q?jTz3adzOZempyNUx49aZtkh3U+jsG8q678uRQt7qCXWn0IfRKsz9y2wvEHbF?=
 =?us-ascii?Q?EmwQUcjrSbMe2GDU/BQyVQD+NbM6fFG73TYu44qvKNwH+1upiloSH35rhm75?=
 =?us-ascii?Q?k/aIthnPHKWDO9UhsZuiHr+gKP+nzwH8AeZw4cZf0vyYBIk/goOAHmTbJfjH?=
 =?us-ascii?Q?DZyETKNXFj4MnmGp1jfir/+HiW5AzXwjOaNX3ARdbpurvX8o1payA13Vr1rI?=
 =?us-ascii?Q?kmb19jXqKAPnboi0NGm5MjqFGJKj6ZlXdL6Fw6nCjDxuA1OyP/79cZQfuhcy?=
 =?us-ascii?Q?HPTv7YVXNqb6m1w/FvOEA30UT56tBF1XhtoMgLLGvKn3DSg6uk6B6dNlW8rR?=
 =?us-ascii?Q?dg0qKVCrO5goG4Rl9CX4OQfp2wBBoWmWyqAZOgpQizZNgKgUgfW614VYzhgj?=
 =?us-ascii?Q?5HI8l4+Sb/1rqv5+e+7/Ag8DzKFLvirBrFWbkFayt0uNFi+ABsAe80Xk5g3U?=
 =?us-ascii?Q?wokThkD/LnSWVhuL5VV84BZVulurhpDetw0fWf8B8GCx/40fVhuIaGtUcKTL?=
 =?us-ascii?Q?Dv43alkubqhx0lvNxCRQTL/osFkWQkFkdHFz/ocGHwwutfggm6ApRt2Wrz7R?=
 =?us-ascii?Q?kXinlimP76cE0qb0elJ3pgKbPAViEMHSa21EEWRzvZWAdsKzHkXx+cxETJJX?=
 =?us-ascii?Q?L08vxwBusd0m/kBos1OASyEc8dnOoRx5rkeM3uwkjp4Y043L6cQYaRu7xPia?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c74ac752-aba4-4191-89e6-08db6b8a3d60
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:16:08.4043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nGlpIVzuoI4ZFVBeGd9ZBsdxXoT+vXW26UGwhhFeqWJwzoqxmy7qWwAhdYc11z47QzU/y5gdPpFgsvNx6hJH0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5441
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Advertise the maximum offset the .adjphase callback is capable of
supporting in nanoseconds for IDT devices.

Refactor the negation of the offset stored in the register to be after the
boundary check of the offset value rather than before. Boundary check based
on the intended value rather than its device-specific representation.
Depend on ptp_clock_adjtime for handling out-of-range offsets.
ptp_clock_adjtime returns -ERANGE instead of clamping out-of-range offsets.

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Min Li <min.li.xe@renesas.com>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---

Notes:
    Changes:
    
      v3->v2:
        * Add information about returning -ERANGE instead of clamping
          out-of-range offsets.
    
          Link: https://lore.kernel.org/netdev/13b7315446390d3a78d8f508937354f12778b68e.camel@redhat.com/

 drivers/ptp/ptp_idt82p33.c | 18 +++++++++---------
 drivers/ptp/ptp_idt82p33.h |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index afc76c22271a..057190b9cd3d 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -978,24 +978,23 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 	return err;
 }
 
+static s32 idt82p33_getmaxphase(__always_unused struct ptp_clock_info *ptp)
+{
+	return WRITE_PHASE_OFFSET_LIMIT;
+}
+
 static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32 offset_ns)
 {
 	struct idt82p33_channel *channel =
 		container_of(ptp, struct idt82p33_channel, caps);
 	struct idt82p33 *idt82p33 = channel->idt82p33;
-	s64 offset_regval, offset_fs;
+	s64 offset_regval;
 	u8 val[4] = {0};
 	int err;
 
-	offset_fs = (s64)(-offset_ns) * 1000000;
-
-	if (offset_fs > WRITE_PHASE_OFFSET_LIMIT)
-		offset_fs = WRITE_PHASE_OFFSET_LIMIT;
-	else if (offset_fs < -WRITE_PHASE_OFFSET_LIMIT)
-		offset_fs = -WRITE_PHASE_OFFSET_LIMIT;
-
 	/* Convert from phaseoffset_fs to register value */
-	offset_regval = div_s64(offset_fs * 1000, IDT_T0DPLL_PHASE_RESOL);
+	offset_regval = div_s64((s64)(-offset_ns) * 1000000000ll,
+				IDT_T0DPLL_PHASE_RESOL);
 
 	val[0] = offset_regval & 0xFF;
 	val[1] = (offset_regval >> 8) & 0xFF;
@@ -1175,6 +1174,7 @@ static void idt82p33_caps_init(u32 index, struct ptp_clock_info *caps,
 	caps->n_ext_ts = MAX_PHC_PLL,
 	caps->n_pins = max_pins,
 	caps->adjphase = idt82p33_adjwritephase,
+	caps->getmaxphase = idt82p33_getmaxphase,
 	caps->adjfine = idt82p33_adjfine;
 	caps->adjtime = idt82p33_adjtime;
 	caps->gettime64 = idt82p33_gettime;
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 8fcb0b17d207..6a63c14b6966 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -43,9 +43,9 @@
 #define DEFAULT_OUTPUT_MASK_PLL1	DEFAULT_OUTPUT_MASK_PLL0
 
 /**
- * @brief Maximum absolute value for write phase offset in femtoseconds
+ * @brief Maximum absolute value for write phase offset in nanoseconds
  */
-#define WRITE_PHASE_OFFSET_LIMIT (20000052084ll)
+#define WRITE_PHASE_OFFSET_LIMIT (20000l)
 
 /** @brief Phase offset resolution
  *
-- 
2.40.1


