Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA4642876D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 09:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhJKHLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 03:11:17 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:54540 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230102AbhJKHLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 03:11:16 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B6vOmF023476;
        Mon, 11 Oct 2021 00:09:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=aavDrPA6FVSylkSMrxyWtlfYZ4geMqtsfWCK6ubKncI=;
 b=CMzbAA/daWpWaXkVFksR1D0YnSp2kvX9af7XiYlciZCZ+GISEn1PyLvy9FUOuG5Vpmk3
 48oKe19Z2gfU1yxerE7S7TsZcy9XRlWznHRGWgSCMzFjEPe4L25VInyeviARnIh3NoHw
 smgqlHx5XdPWns3pb3SiitGKYTlxbYCXTo2zkXCdbgWVwuojSDVp2WypbIx4xMYTTM4a
 3g6pqEFSkqZOb7uJBroeENbX47rtTRZbPe8Ks8AjmdUczPhm7RNev3OkiJyeRbtAPzkc
 ufKsB/xxKpYsJ0byBGHhw3ZXQDJ3YJj1PyFZreFePxttTQEwsrHRJoaLzX/mXwkjEUTs 0A== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bm5qvgajk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 00:09:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/OrgnZm/oouqdlxsuc6qkp6WUpPJPDWlOvj7WCM7HglmJQnta+1kB4p6meYCn4Uc9hzWsRyK+DVaoE9wRJiAvhgrndGgzX8A2IC/v0pFVsHHTubHa3Bu2YiAzlpo7/e9X39/+v2JA1j5orc9XkQWLe3FNX3KGjekbEleQP13CWdTDCy9DUmXw1VcACxajbLUATuUSG/oU+uUs4O6RUctSuuEygwoFN43PzlN2bIvW8/uOo5l/KXRkbhw5rc9NIo0+d/U2TNUjMlfUo7tJh6GII7ncbFaESGXtMlzuT6TJIRh4I9KmhaypiGYcBR4oXaxxg0Z10496VqHOJPrhQUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aavDrPA6FVSylkSMrxyWtlfYZ4geMqtsfWCK6ubKncI=;
 b=kRCSGlTfdjkGuu3dObrowtv6pVUBgwjWzcG3zZdEF9uerJzN8s/5w3I7jonvCWzN1kAy2sB22lC4L3D+VTHWm2NNoEUUarfVxPkf9YBc+F8T4nVPeLIMWZbjsrgWbUgGmSTUPV0Z5FNDoTIkrtwjCmw+OXPasrHQw2pWtqEV8PaeGgupQ29Fs01yAgDr+4syFHsezNxWOghgSOhxJWwNbx7qX8xdheyy2ifVYMeB+zj1ko6FfXTeURYYqXQvFORcJJ4F11y0kZTgNsPbfMCNMdPRKjPUQCl+RnJLnVy8zlEeMDFRXUoQalZixsCJZU5K7EVTJMTHqh3H/DTqdN3k5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
Received: from PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8)
 by PH0PR11MB4806.namprd11.prod.outlook.com (2603:10b6:510:31::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Mon, 11 Oct
 2021 07:09:10 +0000
Received: from PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::adbc:d2be:9f69:b963]) by PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::adbc:d2be:9f69:b963%7]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 07:09:10 +0000
From:   Yongxin Liu <yongxin.liu@windriver.com>
To:     jacob.e.keller@intel.com, gurucharanx.g@intel.com,
        anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, kuba@kernel.org
Subject: [PATCH net] ice: check whether PTP is initialized in ice_ptp_release()
Date:   Mon, 11 Oct 2021 15:02:16 +0800
Message-Id: <20211011070216.40657-1-yongxin.liu@windriver.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0005.apcprd06.prod.outlook.com
 (2603:1096:202:2e::17) To PH0PR11MB5175.namprd11.prod.outlook.com
 (2603:10b6:510:3d::8)
MIME-Version: 1.0
Received: from pek-lpggp6.wrs.com (60.247.85.82) by HK2PR06CA0005.apcprd06.prod.outlook.com (2603:1096:202:2e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Mon, 11 Oct 2021 07:09:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82244a69-a087-4f9b-8067-08d98c8605af
X-MS-TrafficTypeDiagnostic: PH0PR11MB4806:
X-Microsoft-Antispam-PRVS: <PH0PR11MB4806DB741940F12D03C79403E5B59@PH0PR11MB4806.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b7lg9B4htXZHWv2E+d6FbOE/udnqxlth9MUhYYF/XLF3cUl3KyRrKd5BKmc7yucidNqf7wI6jJ/cvufbHFcj6QT1in6z3Aa/J3T7H+hrwC+PIomlaSxdwEhiPg9hTsrWTLMX7eMKYX/enqNwOmw1Hum1MnXbGrm6qwlNpGaXqOkaxmNve35H+ZLIsq80XCF4keJenmuwiWmvefO4St+f/QKR25tyh2SWbTBsFwMVMTC7v4uubxtlMMwn+7xlN3+8jXzu9S+DTNYrY5UPLyFX4RJlZTZL1nntPM+iY1r1ur+ozqOjGTivMxyPwHIWHdaK6p+Q2M5Ehd7BFQEf226LBSpK2KyrCWtwayBYrXiCFuJBOp2y/j4UIE35gkBR4JA64UgM5hF4AMwOLxQPcTX9y9wgpAptYxLD2BF51OShKB74UViP9eslMBMzA4m1bikWlP2gfFgQeh8IkpGEqhQU+UjnLjtco2OgTJcWBaS7ifHzbRFfZZBGw6+35KNo90pnGIQCz57HYpUBLjV98dWoxW1Sm+zaX94pn7njdA2HWapmR0YFHRNO5sl2NVThbE7YtOfKfXwYe+/nZXMbttI+3XvTtkT8FHaj0cxPy1hb3a6EMt+c7O1KlBPzkwEIPwKNg8aPPC55eNrYtv4aDF9EryZyah4RXG3WautaoML8QlWjioQbOztJ4P9690ubh/Za4dWZ7gFiMxS9RxSZe8ADGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5175.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(2906002)(316002)(66556008)(6512007)(52116002)(4326008)(508600001)(44832011)(2616005)(956004)(38100700002)(36756003)(26005)(186003)(38350700002)(66946007)(6506007)(8936002)(6486002)(8676002)(1076003)(6666004)(83380400001)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ho0dzgGv14dTDkO031SG0BXG6P/LhrN84LH/0eSEa7Zmz/5+n2V1QhFQ3hGj?=
 =?us-ascii?Q?q9QA6DLN81xtn5w0FB4HQZLEYB4zhBh27qybBRdYplEcMs9SpPeZMyoS2hNU?=
 =?us-ascii?Q?+CZIz0XVoYgqCmju+eD46uStdjjDKeqe6+GtCoYTy1NFVvD0jIs6Wkz2OvAd?=
 =?us-ascii?Q?YoGQjuzI1mjEl/RDoblFdBGVCsEASYKo5ZKj2bu/GTWz4FELBO+fxENJjKLg?=
 =?us-ascii?Q?oCdEXnUst8tgX7ke/eKwbgbZ6V09bAY+9gXRc8z6iBMbw90LgNgVGjUgT5k5?=
 =?us-ascii?Q?tjePwtKV9MYilrYAqAg5zIAmaHio4s91hH2CZ21EIgA8ZgQ0EYVZSXGn0E99?=
 =?us-ascii?Q?VK0LyCFt2Zu000MWmbh3x4Fy8pe30Fgw5tlYxKSpUTzTS5lMtI+KHh3zIkDV?=
 =?us-ascii?Q?ZQ1jWF83uCdOThrtoT2wJalNdihp8V7tdcjA7B1PgMbws4C18YuhdQ2ytpoN?=
 =?us-ascii?Q?p3/hiLImgtrOQSXElZsgCOvsr+w3x6IAaFRmm9tB1i5HtsmfDFcb8zig9y+c?=
 =?us-ascii?Q?oH9hOUjQJKdw9mdGOIrFZrTYm4rm0Upph2pfeQ7SyTwsRldMATtzUc5nOb5I?=
 =?us-ascii?Q?IEGiV6aqsxV1+wmEBCV1j/tA75kz33pgyzd4F2iNuEUyCC99/MMj28DkwS0B?=
 =?us-ascii?Q?VrMfboe9N9Vljgx7vfJ1/5ZjlHzOc5YcHk3PYxfeSY9MWb9zS8/cUMOzRbpM?=
 =?us-ascii?Q?IptcFh345CIPBtnP6UmkHSXj6wEwYPtYGKvycGaEcRKDYP7UCgIUUihRyzeJ?=
 =?us-ascii?Q?kqe++4rHWW+RfBBPO4FWgNNFe8GFHyUvhzHFZ1lOwpFm4c3RiuVmFzuQQ542?=
 =?us-ascii?Q?pFzE6j3G8e/DKhuLD+t96yK/4yYsurXALWr4Q8PvM2k974+4fK2q99hDRd1Q?=
 =?us-ascii?Q?ZmI5QC7r9SX+YuVeFTKG28fCv+MgHcGgRzoIAEfjyQ16xeGLK1p9G6IhKMdU?=
 =?us-ascii?Q?6y2TGhBAqRr0CQNzhKQ24clSrDQ+CZ9LwD+oL6JqwzxUfMZT/IL/sXtQHuZw?=
 =?us-ascii?Q?XB7XYtgpPdmvhPEikJmk7gkJH6UNdhDM2oUgeV+9YWJ9FCG9/WQI8q2rWpqT?=
 =?us-ascii?Q?nJtNH1CFfqscBCU+npDkojYVaPpok4svGs5XYQfdRtFICgN8FZJMY5/o3/g6?=
 =?us-ascii?Q?gTKr5ABKHiE52XWlDDmJdoYOJ74DlLhxkShqZcRsafr3oBeThkB+ics+I1ek?=
 =?us-ascii?Q?2vK5UU/ZcMfrd7ccm7SHZdVb+xnSHMtbasdl25ZyinQyEmKl0jVjCLxLDzg7?=
 =?us-ascii?Q?cCiwVDP+4lxccc0h4HezIZI8gjGUjJR5waWpGbjA1uxTlxE+0Dvz80WW05ZA?=
 =?us-ascii?Q?GAMfZI48/c8O6CDHLrWBvbjF?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82244a69-a087-4f9b-8067-08d98c8605af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5175.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 07:09:10.0182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: geGSeW9puva/OLBOAqI6KrItqQ8y+59YtPhv0+iEZs4BkDDmDRFoktrksOGg6T6pH5ohG3xdhc2bUZdAJVEk4pxqh+3Dgaem+ihVZzsmjg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4806
X-Proofpoint-GUID: hMDhYxmecA8c4sWeBOpXgGObCo_d4cWR
X-Proofpoint-ORIG-GUID: hMDhYxmecA8c4sWeBOpXgGObCo_d4cWR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_02,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=955 clxscore=1011
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110110041
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP is currently only supported on E810 devices, it is checked
in ice_ptp_init(). However, there is no check in ice_ptp_release().
For other E800 series devices, ice_ptp_release() will be wrongly executed.

Fix the following calltrace.

  INFO: trying to register non-static key.
  The code is fine but needs lockdep annotation, or maybe
  you didn't initialize this object before use?
  turning off the locking correctness validator.
  Workqueue: ice ice_service_task [ice]
  Call Trace:
   dump_stack_lvl+0x5b/0x82
   dump_stack+0x10/0x12
   register_lock_class+0x495/0x4a0
   ? find_held_lock+0x3c/0xb0
   __lock_acquire+0x71/0x1830
   lock_acquire+0x1e6/0x330
   ? ice_ptp_release+0x3c/0x1e0 [ice]
   ? _raw_spin_lock+0x19/0x70
   ? ice_ptp_release+0x3c/0x1e0 [ice]
   _raw_spin_lock+0x38/0x70
   ? ice_ptp_release+0x3c/0x1e0 [ice]
   ice_ptp_release+0x3c/0x1e0 [ice]
   ice_prepare_for_reset+0xcb/0xe0 [ice]
   ice_do_reset+0x38/0x110 [ice]
   ice_service_task+0x138/0xf10 [ice]
   ? __this_cpu_preempt_check+0x13/0x20
   process_one_work+0x26a/0x650
   worker_thread+0x3f/0x3b0
   ? __kthread_parkme+0x51/0xb0
   ? process_one_work+0x650/0x650
   kthread+0x161/0x190
   ? set_kthread_struct+0x40/0x40
   ret_from_fork+0x1f/0x30

Fixes: 4dd0d5c33c3e ("ice: add lock around Tx timestamp tracker flush")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 05cc5870e4ef..b1cd26a5ad33 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1572,6 +1572,9 @@ void ice_ptp_init(struct ice_pf *pf)
  */
 void ice_ptp_release(struct ice_pf *pf)
 {
+	if (!test_bit(ICE_FLAG_PTP, pf->flags))
+		return;
+
 	/* Disable timestamping for both Tx and Rx */
 	ice_ptp_cfg_timestamp(pf, false);
 
-- 
2.31.1

