Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC433FF8A5
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 03:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346496AbhICBbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 21:31:12 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:15072 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhICBbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 21:31:10 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1831OG5P005686;
        Thu, 2 Sep 2021 18:30:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=AVRB29VkR/JLGByS/2BwlTUzCwJ3zJKmY6u0E0uaYTc=;
 b=UWiL8HIWXpPPMdb+phtRBFzftsawWOVHJIp6ueo9fmkh4Ejmj4HruPDlbPtiVQqVsLTM
 yjVXvPk+GCYJOlLmhvs3ddd8DdCD/hCMp20+vGLdLDGzScsqEpUlGt8Kd1F4dSWrjpOT
 Czz11mjSRQZ4dNaaRUJvPJV7RhDE9RNOwnXcsnY27H4A9H/7Nnjs8+2+iqL0GCcX6sV2
 H+XKYHZOKBu4hlfYi98XsU2lZCmxNfW7Irg1AjR09g14lJ8bOUXX+zPbP/ih/InfaGYs
 0KjsXnDhCmOauz8TP4CkmwE2ldfIXPrzfx7d8jpObr77OECJIUoMBZ0VbmIp8iJw0nu5 6A== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0a-0064b401.pphosted.com with ESMTP id 3atdx617cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Sep 2021 18:30:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czqSldWZBSZf1QRj1LXlrOD1I9VRQs6UShKRaLjsktM0aQO2A2K7ajHA97Cb8Lt8GjijvUlvjxqKwRGasuZPzND/yCwT2zuyOWTgdSRLbfkUTGOBIbOiKxG86rl2x0H/Ee6AfVjlp4EAUAzVm/gdZl+oiQUX0v/kSY68zZfOSzg+uVrVRvqU8fiYl9wlRPKdi8Khus5IaXlLpF7h+zQPpn/W9BBATuteDjuXiLynok+zoq/65jeTcHSAQrQfQeg1Wl1pmWgqW2I6JIGCpBs4F9m1j0uztC6HZI+aNJwzoveVGEZPmL3xNpug6HK2SxChXJYHp34cOfMgb1WBt/y3MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AVRB29VkR/JLGByS/2BwlTUzCwJ3zJKmY6u0E0uaYTc=;
 b=oav9ANFAxNsA1Ng/yHDIaueX7b3pieuPC+5NmiOKvbInfBQxbv3xm8vLaVh3i1RJq64CRZe9eMXavrxyDPRIDJnQT4vI5dedL1r5RWQTbuhxu7T+n+BmrmC8zYyTZJBqsiYyagR3v0Mzb5PJyVvO2nBJ7RVk4j9F7gdL46Xd/vQBcvwNs+rQdm2mKxWNhI5uOfyU4ooCy2ab7EjXblTuwcxROAeZTGtZVB1RfQYxQZLeLuv5FXXlYTSc920B15KGucD6I/FuRrvmKgCGdOWCQSSUELUmnoI6hPOr8/1VoFZ1OdBYZVgq4BLzdqFQXMleveZq8vGpDU8/Ma12PNfYyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
Received: from PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8)
 by PH0PR11MB4981.namprd11.prod.outlook.com (2603:10b6:510:39::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 01:30:03 +0000
Received: from PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::c596:d88c:c3b9:4498]) by PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::c596:d88c:c3b9:4498%7]) with mapi id 15.20.4478.021; Fri, 3 Sep 2021
 01:30:03 +0000
From:   Yongxin Liu <yongxin.liu@windriver.com>
To:     david.m.ertman@intel.com, shiraz.saleem@intel.com,
        anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, kuba@kernel.org
Subject: [PATCH net] ice: check whether AUX devices/drivers are supported in ice_rebuild
Date:   Fri,  3 Sep 2021 09:25:00 +0800
Message-Id: <20210903012500.39407-1-yongxin.liu@windriver.com>
X-Mailer: git-send-email 2.14.5
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0133.apcprd02.prod.outlook.com
 (2603:1096:202:16::17) To PH0PR11MB5175.namprd11.prod.outlook.com
 (2603:10b6:510:3d::8)
MIME-Version: 1.0
Received: from pek-lpggp6.wrs.com (60.247.85.82) by HK2PR02CA0133.apcprd02.prod.outlook.com (2603:1096:202:16::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 01:30:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c531a60f-9719-4fdc-2ea0-08d96e7a5a62
X-MS-TrafficTypeDiagnostic: PH0PR11MB4981:
X-Microsoft-Antispam-PRVS: <PH0PR11MB4981CC1B857FE0C2EA950F80E5CF9@PH0PR11MB4981.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NyRtWzXlpkCFEt3HTIC0YJ636+OMSjWJ6wU52FXP/DExUr5aXzXkAyNTVHDKxkwaaMPEY3Tv7ys86Zs+HuYEkAGVJ/z/dV6InaK0oPO/hDpit3Vg9ZpGgZ4gqzZCtNKEitINQjkw5rg8zAXwOLpE0nnm89tGjsfgW0IyELXzTHkhg0M2Jky+W7lc8fGzWnzv7YSPDBwQrWoLOSjk9fv6wGCGTQy9anxg3o3wyXgogPMKqHBLQ4V8YtoCCjF0yfw0l1DSo9kG2cWVy6JG+vKHnHVafZL/fp59EkIOccpVp9FPqS8t0uAQjbSty6KTozlcjstwnS4sXM+dzUdAXDhD6YP70vPsZrYn8+qnoVZ68XnihOV/XCK9IN8WMOOemsNTnZMHoNQ3rHKvFaHyMgjtiQHmZlyIgY0Z/rcjmUZxpQ48BO5h2Nklisw1v4BaJIXPb4X8NrA1kwTPpCqVdIXCVxagWJ+kyrNFJUMH6l55daLM0AT5G/jFWMUqk3JYjUNM5Tc4pTSj+VRfQvBE/QMVAyKZZLPSByqqqHEY+okDApwhLLF7BrmCrAKQ4yRt00CcMjjU07/8je3EHak4GyKCT6qVnyAvR+24ZX9T83gGlvOBFa8jfJ2ElFbakhxYOcDZUzkHcDd8SZ3DO920AZOxrCbmM747L8IL3aSovV1tZKNcjBV/IDzNZUXSRBvjnTgXJioD4CUpgXOWouY41X4jfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5175.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(26005)(86362001)(8676002)(186003)(44832011)(6506007)(8936002)(6512007)(2616005)(36756003)(956004)(5660300002)(38350700002)(6486002)(4326008)(38100700002)(83380400001)(66946007)(316002)(1076003)(2906002)(66556008)(508600001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ESPU0Wi8cXSD7wRmfEOQ9x+lQ9gMVrM2pfyIxDWftYv0x7lpEblhonjDmOon?=
 =?us-ascii?Q?eKkuq6sP2zxkEWC/8lfp3KmYmLDvmx0EEIuSeV94UJ5Ivtl7llM4tslFIUag?=
 =?us-ascii?Q?M1PIpwj5R35wcNH7+oFW2DtVKYgKhlNcbl6dzDvOMXPN5cxbVmPcMwSS5k6W?=
 =?us-ascii?Q?UBqbQ0mw1SPy/F8Wr0PmxBdRGzfcGuiwijIU92L/67/mVq59ddbc3UighY43?=
 =?us-ascii?Q?TIIee6d1gkz7NBY/oGIc4d8SoDOvpyIR2po+o5X5XBmB5464oumzsrXlO2kr?=
 =?us-ascii?Q?UO6lOBLvy6A1uJcPk3oL/AA/SNy59FTTcJfaa+QUKgJ84wuUiCcnO9GjoL0U?=
 =?us-ascii?Q?5jkOlC/vsWRuciDVVl+26wPKDyCzY+tQ4xDKrW1FxurWF88fvjJQRVxMBA0d?=
 =?us-ascii?Q?0HiI811+OvC1gnneQNL+C6BkU2mRYeL6nyVJocfcy7/B+s6vdccd+kCuiRZT?=
 =?us-ascii?Q?HfZpizfdM4zLnB7V8EfEJj41bqMFQwFl+1iswHT2jUewAWGx3y7oJnSFIY0J?=
 =?us-ascii?Q?89FN4AMUOO096Cy6t7Aq2PnCLwU03BVhFLjmuDJyKx81NldPs8LFN6XifF1P?=
 =?us-ascii?Q?QEwQav3XiAt4SywsjzCf2gSbzd0FuEI9YQ8AwOb98Am4vjd7/o7NgkxCTUBf?=
 =?us-ascii?Q?54IdKInKHpDQi6yYcaANm/Qyar1YJeM8QBNG7mkgRhcX8GnX8Wveo4Eb8SqW?=
 =?us-ascii?Q?4m5MonkElS+vfz5eN5Sg1D4sTUWiIxGFjIOOMezvtl4MZKYTdZL7t42BUg9d?=
 =?us-ascii?Q?j5O1GdxBXjZf3pCOcDQnqU6BwjM0qyTAGSVGoILHWXK8uNJgMbh2drFtCCy8?=
 =?us-ascii?Q?I2ElwMk+AYXYYr4Bs+9+XXaUhXm7YSVYoWEMg3+NxbvZVQXLpjgNYx8TgCWR?=
 =?us-ascii?Q?k37XGuNbiu4pBrQNU+Dw9wjZ+Y4hqcHSGJfWBYEDf3TrB2mlO/62Ubm63IXm?=
 =?us-ascii?Q?0RQr8GvTL0bWQVxVleCBeykkcyAx6Z0tZeuLw40F3sMcPDtx7okRFoD170tm?=
 =?us-ascii?Q?HqG5BFgm8uBuZaAQUSYCAamtIrnC1zvItY004fNKcaGNRK7IqR60BD3TKGlM?=
 =?us-ascii?Q?BxteiAzgLckbm10KIqb5ROyGcGtJYo01Rm9RiCLzIngCdBk3PfbDkpggqxiH?=
 =?us-ascii?Q?+q+CVwYjFQMt3GJos570aXclNxRbhB6EVYIKdDZRllX/Y5Py8ktkFhLyiVXZ?=
 =?us-ascii?Q?XJK3+sDV52i7nrLBzc1/rC2UDb0NGsvYvcfg5G3kbMrRBLzwLSd9skFy9RAp?=
 =?us-ascii?Q?0w0ieZ9RJTQv3qM5Mg7Dwcu32ST/N8Wiw6gNhL1WqaQhaWDja+x+GqQepBcv?=
 =?us-ascii?Q?YDIi9HEsukffMcuEHAUZMi0G?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c531a60f-9719-4fdc-2ea0-08d96e7a5a62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5175.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 01:30:03.3683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYPShbVId1we/MCLQaryCFv0J/22mSuSBKjWq+SY3ZbJlFSjfG1RHGk25D67pEoIGyzalCPxDWa0u/ARUBqwDnfFOK1hfxbd8pH5YiIEmy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4981
X-Proofpoint-GUID: QC2dyOfoo4Vg7_DkiupmpyWFtwuwo32h
X-Proofpoint-ORIG-GUID: QC2dyOfoo4Vg7_DkiupmpyWFtwuwo32h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-02_04,2021-09-02_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 clxscore=1011 priorityscore=1501 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030006
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ice_rebuild(), check whether AUX devices/drivers are supported or not
before calling ice_plug_aux_dev().

Fix the following call trace, if RDMA functionality is not available.

  auxiliary ice.roce.0: adding auxiliary device failed!: -17
  sysfs: cannot create duplicate filename '/bus/auxiliary/devices/ice.roce.0'
  Workqueue: ice ice_service_task [ice]
  Call Trace:
   dump_stack_lvl+0x38/0x49
   dump_stack+0x10/0x12
   sysfs_warn_dup+0x5b/0x70
   sysfs_do_create_link_sd.isra.2+0xc8/0xd0
   sysfs_create_link+0x25/0x40
   bus_add_device+0x6d/0x110
   device_add+0x49d/0x940
   ? _printk+0x52/0x6e
   ? _printk+0x52/0x6e
   __auxiliary_device_add+0x60/0xc0
   ice_plug_aux_dev+0xd3/0xf0 [ice]
   ice_rebuild+0x27d/0x510 [ice]
   ice_do_reset+0x51/0xe0 [ice]
   ice_service_task+0x108/0xe70 [ice]
   ? __switch_to+0x13b/0x510
   process_one_work+0x1de/0x420
   ? apply_wqattrs_cleanup+0xc0/0xc0
   worker_thread+0x34/0x400
   ? apply_wqattrs_cleanup+0xc0/0xc0
   kthread+0x14d/0x180
   ? set_kthread_struct+0x40/0x40
   ret_from_fork+0x1f/0x30

Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0d6c143f6653..98cc708e9517 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6466,7 +6466,9 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	/* if we get here, reset flow is successful */
 	clear_bit(ICE_RESET_FAILED, pf->state);
 
-	ice_plug_aux_dev(pf);
+	if (ice_is_aux_ena(pf))
+		ice_plug_aux_dev(pf);
+
 	return;
 
 err_vsi_rebuild:
-- 
2.14.5

