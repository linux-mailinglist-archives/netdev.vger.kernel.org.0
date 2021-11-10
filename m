Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914B944BCA8
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhKJIRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:17:00 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23104 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229791AbhKJIQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:16:59 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AA7VCQQ013632;
        Wed, 10 Nov 2021 08:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=UdKsPDku9m72FgQrXVjGjD2ktZ1fl2CZ+8gXZjK1xrY=;
 b=uI56q+cyiZO48Zvfrybdqo38oydoDdR9zlYA2DrHPkgB9HqRRHSPXNEXnb7WXlwml0S1
 azRz5lpxzG686X7rnOM9UAjNCJxeWlc15u1jjclQJzzS6TI4NVyDGfhHlXzUESCqgrsL
 yU/9jqPhyw6qS5CVIixA7ByIz2TiBO7HpESuH8jThrGhmJuDx3lz7IcSE+wTzZpngh91
 JSdc2eV4OG+fMd/yfb+a++KXcHRKwqFWQxlHcEH0daWrdcLOMeL2lE3GHchVzZby4nIH
 5ANK5s7bDke3hcBc6pYvX+YAOFewfxfnjvLhS8HnUQGarGZi+IImk16Uh6otpqwVsWZ4 VA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c82vga0j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 08:14:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AA8A3Io157250;
        Wed, 10 Nov 2021 08:14:06 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by aserp3030.oracle.com with ESMTP id 3c5frf8sxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 08:14:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCqI+TBkC9KXf/IpBMxUCRd11FcxP/53vKpghdjmDaKnstsUcIFlGIkhCNV9Yp31HnOb/QXMvOEE8Ku6Eg0hlrLSG4MeMhlQFjK9J6tbJSyiuzxcAvDVlJKChTkpwc8gSe3qMaOQmwBJ0w4JodsHPOo+pySS2r98khWfbbLf83FPu/62Dks/fZ5HkojBDxgaVpYBh2iSHcOhmHx26QiZSVzBWZRC4sDdIQktaXTkJDcOBGu7uMn1RkZgQu3tZGEX4Va5iKFaOh7GDUrklkx8yN33CxGr6InaUB8yAYVzflmAqTMGNL5PRYcBFW7QJs6SQnrsn79BIcZUs1GwVcB7Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdKsPDku9m72FgQrXVjGjD2ktZ1fl2CZ+8gXZjK1xrY=;
 b=jTMoLy3wJT5mKOROIhUsHdo5DzeD3WhdBDmRVqW33sKI0CWQdyLfYbUBw9TBsH78Yju5Z772cS0pUXB6V8weybdrAcK4hdjkCSXWPxsNzDFsovTe5Wdq/wJ5EdX++Gr0i4q2M2qVlYCHXgrfDjSuiDRKJMwyphDKX/0wen7I7xqSHYuRcaWoTFZatPfGMFNWxGsLp6p4TbyrWAgJCK1oJj597QWH/xkhR+ZwEtfghkvQzwhJIzCuoMW3FzkOD5ElWcnWcF3I0DAR1JvPgEmDS9/lRrr+uaVxNzfdvu/P1PPztoPiIbNKqwCCqTrTyivdO4RqW4qp9NSq2VziO6fO3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdKsPDku9m72FgQrXVjGjD2ktZ1fl2CZ+8gXZjK1xrY=;
 b=YTCL2N/VavwN1LsaVqkf4ai/vKdzX9Ao/GsOqPu5y+QF2TQiP6yJKUh9v3cn65olovComJY1eaZM607iOGBsb76AEcxHw8J1BF9Kxxq2zqaJdnpTs3azyA7P58+EE1r7WxoKKoy4oSED4igj5sB50/9W4uMyD4GeBwq2nHzy/qc=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1727.namprd10.prod.outlook.com
 (2603:10b6:301:8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Wed, 10 Nov
 2021 08:14:04 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Wed, 10 Nov 2021
 08:14:04 +0000
Date:   Wed, 10 Nov 2021 11:13:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Jakub Pawlak <jakub.pawlak@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] iavf: missing unlocks in iavf_watchdog_task()
Message-ID: <20211110081350.GI5176@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 08:13:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b040764-e0d3-4f4f-cb97-08d9a4220f10
X-MS-TrafficTypeDiagnostic: MWHPR10MB1727:
X-Microsoft-Antispam-PRVS: <MWHPR10MB172723B67383538811478B7D8E939@MWHPR10MB1727.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kab9E+k8pZGI08wR6IaAkr49PPb2Lv9A/fVAdOk22jwUrrnr7fbrQqcDNs7xGrKAogi3fGmIc3AbnleA/0XjZ3NgwcUW52RojI0Y/cW704jvo1k+Ty3NR77jDms253qdCKPXEsaFChpeqEBsTnCLqUfmjFuqBRuCtIDkP6gdMWLviro5Tqrsg6wbrKNze/MmSH+q8XgUnoAxEyE6NFb5RnsbNz0ul+olWAE2PWXbRxJeoXQzKsx9aV4fnYXYyw+0IZcW6LiEQzjs7hcCPz2l7l3zBIe9NV3/19zd4/DWkcr6zyKoOpgVf8Tk2Pm1WGY/sopHaMr1o5R4SUzfhQypXEibjJiEmRXgCT2oNKpewxC3YliWkmCZnADEsQVzKmvmf+dDxXLRTCUipWVSvpNMd2h0AAd9NDU0EH+RcWoAR+nCzBrdXHkBEMl/EanPklNXQsT7BBGEdsxWMXpeyzDNajGgIhJIiNQ+4FL51hOTIpMkLuhGKSv8XwFC1xrkRfBy2aACInkjCdhwAZSCd1zoEwr7qn2hSYjgxjo1jtDGEBi4QdD+ncOMVQlGQ8MkTlnsiwQxQIcO0BRE+E5Wc6UVJvBWo7lnDwZ6MdViJWl0pUuKPQlX7VALlghtKaKtiYhv80Ac4RF35UrqKcNMMgaUIrXDqVTHntexvmeLgZ/GI7laPnIJ+5QNDujOgsUYdHizxilh8sQOwp8UKYKpxAuzMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(508600001)(956004)(38350700002)(33656002)(316002)(86362001)(38100700002)(2906002)(33716001)(66556008)(9576002)(7416002)(4326008)(52116002)(5660300002)(6496006)(66946007)(66476007)(8936002)(26005)(83380400001)(186003)(44832011)(55016002)(8676002)(9686003)(1076003)(6666004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5pTsODpILad8/V5ymFO8Mp00x9JmHUzr7EbF+mALS4QdUrwov7GzzwsdkHVE?=
 =?us-ascii?Q?Y1bPA7Bx52yqzpm9Ml52dyjkYfOU1chFWcOhl08rwWCJqzQC9SXYC1l1E9wR?=
 =?us-ascii?Q?HJWkRTU9qchEn+vtcz+muszlXxLBqlspx0ImyUt03XkfZWovSkZ7+uB3leFc?=
 =?us-ascii?Q?qIWzCnERkUzypTH75krliCutmegnyJSfq3rb2wjtJ8V9n9p4BXx489l3fYne?=
 =?us-ascii?Q?f8/+fIP7Y3e1sq2DNgmHeb2SPqMj9xlt29keuIcSP4YkCTe9rANf5dKf53Cz?=
 =?us-ascii?Q?o1BtFKqcnFDaHvfU5yZuxS8VU1S6+Ze06WDz/Q/lZ0dS8uN+AzTe0VvdkIjm?=
 =?us-ascii?Q?AAlPn/7fCd08oTdtcHq3MmEIuZk2LREBl0rCJRl+9qEkHeO0LJ3gtvSXFVJx?=
 =?us-ascii?Q?o+7uIFpHlxBPcd4bwPqm0niJXxhAWwVsDcxASwQmsAdeJQCM1GuTz43iGTuU?=
 =?us-ascii?Q?qQBcCNk+fANPRVO8txiRHLp/fco8kOCmc0WuNPUtqAeUhUFMD0ppRB7WEKQY?=
 =?us-ascii?Q?FbyplNlG/4SteNIToxw/OmQ1bXbz6TtuTk4inT3UItmZc4OXGaiTDKlisM73?=
 =?us-ascii?Q?Re4RjOI1b4/veVY2z3C9VHXVSSsrYTlZtGu1uJgCT05ywAdrkyfQ0lTef21o?=
 =?us-ascii?Q?GR3/TvSgxDQlgbfxhVg81/ABlX3Vr7y8/2HEYAHV1E5dXc+oYoSBVRUrVUwT?=
 =?us-ascii?Q?PTLJfAMGL0X1XXzllKBwIIEdMD0lmSs6qBHaCNFtE6LxVyULPtr4Xeh80C6J?=
 =?us-ascii?Q?1zOOPqkAT+Smrv8GSnh2R3cuxgg6oYkb68UpdoWCcySDXzSHTJstCEwBVX33?=
 =?us-ascii?Q?2eQ7SGire5WbqFDR0CY/FTpMj95fqiJK9rpyqyN4YklflMQhuoOQXxFC6s2y?=
 =?us-ascii?Q?q8U6MsbneUFlEO7aNP1CsLEzhxirClaRnilDXVjgczge4WA1ZmqT2yJD6aFN?=
 =?us-ascii?Q?9gsAzpqqFIelFx5KznxIOLQU/JJikJnaMhQLG+vye91UCRI2olsryJ+xPbyb?=
 =?us-ascii?Q?trsthRgpf3j24/BJL79denFYqaZHyaljQVQEuNttCa87jEHjmasFzMt1crE7?=
 =?us-ascii?Q?OLwDn9V+pKzDStfgXYsODlS9CkdOf6Tb5KPQ8ahH0QZODmrK+/r1WbYsKcVN?=
 =?us-ascii?Q?DdgWaHN8LulvGOVC6FYguRTHP3CcEoyYCojvUPm7N37J36B/m1wqcnCPK1no?=
 =?us-ascii?Q?dwyt54in4nmJ7Xj/fHoxhBLzKGzkUomHzZhFP3AWmazwaDX4rL80SIMUDpy+?=
 =?us-ascii?Q?mMJCEgwLg/e0zAJ5IMtIKXR3BQXanj0l4HsQsZT8Vzi6iiedkEFAjn443TCO?=
 =?us-ascii?Q?Ymh0S9eu8zCx8NAasDS+H7Tgsq2+drkQistLxoUMNbzwvzdrDErXwbrsyguD?=
 =?us-ascii?Q?1tV1VzRJzcmbdk5aTqb0SbpJwB528eAh86X6voJMnTXjklPGFIowRHSBcUrU?=
 =?us-ascii?Q?VsOHHu2VoPLDYIJ+vPQoKy5ghYFjnI1FT+y9HaA6EHbD45lJB+nWEXWIEwuj?=
 =?us-ascii?Q?yZf261GWH+dHJPFWR1xNcDrrU+ozXk4xIwW7wwKtphHxW7scfgl3vQifYw+v?=
 =?us-ascii?Q?W7IxlLpMHnHPsoZEWb2Ccj6e0UY48LfTBTHUBmR3J7PuTxtLL+/4JbMuuCmK?=
 =?us-ascii?Q?3lmLad1BQmn3eqooYqZTd7SOQ7jMGSQv3lkshQHEfzEVo9tRqZzz175xQKHF?=
 =?us-ascii?Q?gFWUgHstxCKA7m2Ic69xXnFMDiI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b040764-e0d3-4f4f-cb97-08d9a4220f10
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 08:14:03.9377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0GtVRNr60NJqbor21eD6rtsmyMzZtjH0uPmW+WRXAefHoKoG4XTb/yddbfjfUFc/d+K8M3fhXPt9DnbrUdU1br52W2ivjQSkUHAUXoClLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1727
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100044
X-Proofpoint-ORIG-GUID: Zx0AsNBL3qbVgBeXKwf4h_XVmg7dLIDn
X-Proofpoint-GUID: Zx0AsNBL3qbVgBeXKwf4h_XVmg7dLIDn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code was re-organized and there some unlocks missing now.

Fixes: 898ef1cb1cb2 ("iavf: Combine init and watchdog state machines")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 847d67e32a54..b97f685a5cf8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2012,6 +2012,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
@@ -2042,9 +2043,8 @@ static void iavf_watchdog_task(struct work_struct *work)
 			iavf_detect_recover_hung(&adapter->vsi);
 		break;
 	case __IAVF_REMOVE:
-		mutex_unlock(&adapter->crit_lock);
-		return;
 	default:
+		mutex_unlock(&adapter->crit_lock);
 		return;
 	}
 
-- 
2.20.1

