Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF1B3B2C25
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 12:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhFXKLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 06:11:10 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:12106 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232100AbhFXKLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 06:11:09 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OA8bAb020322;
        Thu, 24 Jun 2021 03:08:46 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-0064b401.pphosted.com with ESMTP id 39cf0erbn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 03:08:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4UgCKKVwlybQ/KAAG9CTjXjacOjEN9jlie0TAK8G9FfCLLZ9fmt0ecBgR1ZAJ29+yHGOipYM3qF9QHrLJmRa+9RZQ0Q2qduc8d0AOWV4CuBCLjP1ASsEZm8pymNMUbBIKqny0YJdRtbu10iRXHfpcp0fEZczJhKMB+zo68ysP2B4Hcfy0S8Y0GWfpzEbG37JLEh4mP6ZiJQJWfx3PRgMeFM3P3qLxxpdjECVFkKptT9sMba7TCpxcqiRJ7iaC7Mr01LqEd/MmA1DFYv23S7tzE8n5o/1H2JtyHYOYsGUfcikdThi0MSqXlvzDgHeC6b7AHZtNlr6wEl27j5mj6TbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXJfAZLyX1p39Q1Hrk8p3qTmjUDfBGMK4lnSaTrrZTc=;
 b=a3Za7lR84pbrPPqA5XcqmU/PFFijd+UAyxVkTW7/f9u9R9W7s731FVpVw2caKkAjQnoaJ+AMcWUbYERFnH5hVlhZucOznswqfTiap71/4b1qtSc0qtlN8Zwhq+kyo6Csr9RZVYdD+Zc6+WooMFFN+mzYnkDIX0rsvy/v7KZx7z6npNqqQYxX7n+mmv+aBhCRSLQQGVMKgvtT9XukafKTvJR0NZyEZp/RwZAlbXWyypJxI6TwMfEEs/GoQYT04oqKrQirg8ShiIIe6utNUW3d7+k5Pm7+sAQqQZNOpIp9BMm67Cdpul1TmUR9q8kwwT2bfY15YqaMSvQhDZJVf2SllA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXJfAZLyX1p39Q1Hrk8p3qTmjUDfBGMK4lnSaTrrZTc=;
 b=dE1In0Hjzg7CSg3sKORYFsE8daReeIIAuBxQiDwAQd+4Tz9yimA953kc35oAyrzWNfav38bovD5RryuCCXfeIvJ87AQIA/zwpG6vyHvmBA95TQxI5jPK1Qtsx0QpfLFQYmgRh+MSTscRiG537yejaNSThaVdwtBKOJQl4+9GoV8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22)
 by DM6PR11MB3419.namprd11.prod.outlook.com (2603:10b6:5:6f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Thu, 24 Jun
 2021 10:08:43 +0000
Received: from DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::600f:ab96:ee86:2ec4]) by DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::600f:ab96:ee86:2ec4%6]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 10:08:42 +0000
From:   Liwei Song <liwei.song@windriver.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>, David <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liwei.song@windriver.com
Subject: [PATCH] iwlwifi: select MAC80211_LEDS conditionally
Date:   Thu, 24 Jun 2021 18:08:23 +0800
Message-Id: <20210624100823.854-1-liwei.song@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK0PR03CA0105.apcprd03.prod.outlook.com
 (2603:1096:203:b0::21) To DM6PR11MB4739.namprd11.prod.outlook.com
 (2603:10b6:5:2a0::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp3.wrs.com (60.247.85.82) by HK0PR03CA0105.apcprd03.prod.outlook.com (2603:1096:203:b0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Thu, 24 Jun 2021 10:08:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 838947b9-8483-4b63-9f3e-08d936f80b50
X-MS-TrafficTypeDiagnostic: DM6PR11MB3419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB3419E96321AF00B1701E29909E079@DM6PR11MB3419.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8oKjaIfnu+vqHd9Tb/GAnN91338qT30hBI3wi6y41LWkIsU+qcOmcNSB7LQuE2FZhaiVISamDP1WN2nSqOQU414p6B7LPnHL0y8Jy951le46s7L0WBlpV3lSvM46td6dn3e7LvlWG13oV7RKUE91JGlAUIGb7CWvofgWi/Qp7IsTRe/+rZ7DHU7w8Q5IYE1qF8YCzy1tZLsHB7aL/ydDAz/mB/GFf3focoPpMZzMidLcoe0zni9f1Akp68idj1CWf8BGD20V7blaNtmc2FrWJwpbpd4ypg4wHGh0/nE52IqYOb5jN7ZF3TskVu1lpDTSoK3z5s6m1aE91P6L3LDZbAfqGB4J7F3hDXu3xme8z4ClPgmq48I4jJtDKQ+CmL+YPtkMW72RC8f44f36YtwC89kfYEN4UZMJIOJIB05sG/Bo8WQjKMKLfCEBCoCvJc+Z3yIcq1GY9ZQ7lRnb9wW8geQDxAtu+XIJpvnI9TtBU1V8dQxp3KEQVGT5gR9K48uZX0FMzty9XKT8nhnxWhJ5uLSz+j1D01XP5RFBv7TE+Imi4e0ZxiNXmOkOWSrU7pEEOsXg1MmCQAKKWSkh34f07hOURZg4/Vniqb9eupXbEzuTFoZAPukPiOxL14CxqHtQKAeVc0qdpGZlmm/nsG91WQw3ov40vCvbSaNQgkqFHM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(396003)(136003)(376002)(6506007)(44832011)(478600001)(5660300002)(1076003)(26005)(6666004)(8676002)(38350700002)(52116002)(38100700002)(4326008)(186003)(956004)(2616005)(36756003)(8936002)(107886003)(16526019)(86362001)(2906002)(83380400001)(66946007)(6486002)(66556008)(66476007)(110136005)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DSwjsQh7+c2McwPkU1sM0vZUQKRyD93BGg1ngEyTVr/TkfCjB+WANBTD9Q4u?=
 =?us-ascii?Q?x8PaUlduGJWBDCr2zX9YEeoeD7RUyaMG+KlDyLNNojDnmr1Po/dAvFcxxZw4?=
 =?us-ascii?Q?lWmgzOnPwcYCtCFJ9WzPC7RL9Nbw4aNQx9HJQpTj7V88XsrFIqcZceyr1cQI?=
 =?us-ascii?Q?04/CAAkeaOVKUlia2p2G0NXVDdbvyNmIqso8IyJ2WVLe6IE4EGJCpXbzB+FB?=
 =?us-ascii?Q?Yn8cL6stQPkm1l/RUinPeWlXepjWvA8cR36nINxPUgnNdnw5TklSZgnQshhT?=
 =?us-ascii?Q?RiFrD0Xbipz3JvszuP4xjE9T56MjM9xRsNpeQ3ALL6pOUER+d5rb5ZzUSAjM?=
 =?us-ascii?Q?8x0EW8L6OJDBY8wt+Xmudkcx+n9foSKNjSPdp7u0Nrd5ZiT/+ZGsesnWIBVB?=
 =?us-ascii?Q?SDMnkjJDgR2BaP0Bj22FVDgLY+k/SxUFuUqijy+pqPlteFKK7jZYrTECfvNo?=
 =?us-ascii?Q?qn7waRSxhwtx+Hvwu0nOoMcwclvVV0y4fIV72Y82Cz32V6pPiQvnaCOp870I?=
 =?us-ascii?Q?haiXZKNy/Jf/gsZQRDvVZlPi+tFadUqL5V5tUtzNKezV+dsxYQVCZr7/JFHU?=
 =?us-ascii?Q?Yx0EKtWlreUsq944ggQ3fcXStGyb3Vq0NbWeW1fvt7XSTpkoBY+1EDsnTkdY?=
 =?us-ascii?Q?Ag3FA6tjTeONRskwY/ALggCOmzoUZpA9rx1acEx8mw4grx6L9GDmwhsDc922?=
 =?us-ascii?Q?ZcN01XCxt79MyUZMe6Zm8DPo9qpsZx0hiBcahu0iYfnRjaso++CYncwAbc6C?=
 =?us-ascii?Q?87xHnQiwUCXXJeIMzBCvQTjJDL9g3pBQUFY/kL6GaL9BIMxR7bU6uTTHzHro?=
 =?us-ascii?Q?IbvjBTmltE7KXH1TNBHQ8OSOUbN2IrE9taiQ9plYmfo6UR4ZrBsOaq7+ym87?=
 =?us-ascii?Q?638GkyGdhPO4gX/b4Xe7NxRHqo6UTmoI26uYpJPcyqfjkcFHkLl3cXnV92H6?=
 =?us-ascii?Q?3vx/1djv+vEYeZhHlAARv+4B7/5Ew+/AOt5P9n7pK9ebgztJSY/avfpe0a9S?=
 =?us-ascii?Q?GGuzVyFqFEifQWGVqhgvUdCJ6ofhSdo3jGsf+4ZTTyclsfkQaUH6yruE6fSo?=
 =?us-ascii?Q?ivn+tkvZ/sgsdii3NjepPgtUtKU4cbS4QYNQpXtQvxTPr38akEQGYCwYXUUu?=
 =?us-ascii?Q?GLWapQ8LZjYanZzl3m8CBaHoruROmSJN2WEHCCmSDoqgnP/c7HkfOhoFv6FO?=
 =?us-ascii?Q?9b3hMS/wVbKEAtCbY3HE2sRT6U8b9vIo23IWsK6TDFjPxZ7G0dFmMRkoKnXw?=
 =?us-ascii?Q?Xx8sLgiw/z3cvjZx/6lrK3k9mnFDCTljqbUINGUvrN8EtZax+jcVqx/M5pMJ?=
 =?us-ascii?Q?d7Zqr5/0LnZ0G8dm+hcaWxPR?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838947b9-8483-4b63-9f3e-08d936f80b50
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 10:08:42.3171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdLnKB5Lojk89lBiLcYSg/fLInEh5A91GpM0935t77qSnlXqUEgHwaZc9mqXFTDGfY2wlxuWpXir/IyyURSfTsHC/QjUM0Dwtb9/5El6trk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3419
X-Proofpoint-ORIG-GUID: 8FiQYxSEFWnZ95IfGAowPOsentJOmeBM
X-Proofpoint-GUID: 8FiQYxSEFWnZ95IfGAowPOsentJOmeBM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_06:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 clxscore=1011
 priorityscore=1501 bulkscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106240054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC80211_LEDS depends on LEDS_CLASS=y or LEDS_CLASS=MAC80211,
add condition to enable it in iwlwifi/Kconfig to avoid below
compile warning when LEDS_CLASS was set to m:

WARNING: unmet direct dependencies detected for MAC80211_LEDS
  Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=y] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=MAC80211 [=y])
  Selected by [m]:
  - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=m] && (LEDS_CLASS [=m]=y || LEDS_CLASS [=m]=IWLWIFI [=m]) && (IWLMVM [=m] || IWLDVM [=m])

Signed-off-by: Liwei Song <liwei.song@windriver.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 1085afbefba8..0e1de69c259f 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -50,7 +50,7 @@ config IWLWIFI_LEDS
 	depends on LEDS_CLASS=y || LEDS_CLASS=IWLWIFI
 	depends on IWLMVM || IWLDVM
 	select LEDS_TRIGGERS
-	select MAC80211_LEDS
+	select MAC80211_LEDS if (LEDS_CLASS=y || LEDS_CLASS=MAC80211)
 	default y
 
 config IWLDVM
-- 
2.17.1

