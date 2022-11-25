Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC233638314
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 05:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKYENH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 23:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKYEM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 23:12:56 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297B41D676;
        Thu, 24 Nov 2022 20:12:46 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP3wSPq004387;
        Fri, 25 Nov 2022 04:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=t7S28HH7IZwS0lMn30byr/6I7q6b5X/E8sQ0bA1/RVs=;
 b=cw7yO+jzSOcpDEAN+y98Ei+X6w8m5++2ADx1QOI5Bwrancz4kUUJBvVZ77cgxMtA20cc
 40lUBlh/GkFgdluP0cmsx+dwDtwhdvkBxbAbfSG38zsev8okp8c7H2jthKfeA0Pzdbf0
 EY2oSbu2Biwuru+rSyU2buydEgTj/3l/AZFmWpRaQRnSVq3l5/6g8ep2C9BzgFyhkMtP
 uqEq6RC8hEbt7rKHNJ9mGBc+ydinSRtuHp2GX+He9uknqgt7KEzcF0t/wGKF9n41Mlmw
 XwDYjg7RtRCX5E7I4X4q9QvlLezHcZzdHINjv6sb4zWP5x17Lc/OGiEQqxuLWlQkh2Z7 AQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxnxj4q7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 04:12:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vlery6MLYGc8ymyt0Skk60gBfKouer7dGvP+0k6W1NOLntdgh/+5z7r2O7wqKvzXR125y2GEJl57BVZyBx2ndYt3dtOzofG5nFjx6l3uQy3m8+MlJwgInyRfPH95KOhskic9XPJYcfcjrTUXh3FLlu/1Ud6V07gvQEb6gYk86POwbATpbkvN9Zyaa0DUwOI6I1h6yJN+usA1mRTQAd7gGb+ZlPJrG+y8GDMwC+/yHvZF7u1p8WqQLKaCmccXd7Ze1a9t2HCZsRuHmLwIHtZW3grOhuWYP3yYyNP35J/2zwE4AGRNDFQ3Rn0OiKUmFO71rSWACayaGF/otshEPwgYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7S28HH7IZwS0lMn30byr/6I7q6b5X/E8sQ0bA1/RVs=;
 b=lQSIQfY3Af96TyYIJxttIMfcgaI/9Y7X7A0h+dJ73LvesdTMwcwKhPLQgcBsXzrj/sjNemwzvIRXD0keTvOxdujbMHrCHyBXlBG/Qi5I6Jv1VqPGWlUR56/foB4eW+vc804FnIJj3m8hMwrC3WqIuqGhDM4crb29peeeCMeX33QSVFWmYZRKCIe4FjXXbSSQlAheStxmOk/yDxCqKfJchwvZt9HJhJfFNYkgsfLtyhLGGV0RtlyACOIsvF8+2rBBpb44MNcB+3s0Yxl2Nimt/SphXmIbRPLu52djOZ1beQS+YDQDnenJ5GF5Q7RWQcfp8foZyxkpgRNIOQUad86ZKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by SA2PR11MB5163.namprd11.prod.outlook.com (2603:10b6:806:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Fri, 25 Nov
 2022 04:12:21 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b%3]) with mapi id 15.20.5857.018; Fri, 25 Nov 2022
 04:12:21 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [v2][PATCH 0/1] net: phy: Add link between phy dev and mac dev
Date:   Fri, 25 Nov 2022 12:12:05 +0800
Message-Id: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0099.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:3::14) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|SA2PR11MB5163:EE_
X-MS-Office365-Filtering-Correlation-Id: cb032857-397e-47ab-aa04-08dace9b4011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KN4gIbAv0WvVxqM3PBBh7G90fuxQ3Alm1S90cnePAJ3I2ZwpQrNLoqbbizKyj5um2nZzXxfM8J8jlZuvKM3cM1hD58ilo70Dat8yfJW6pfLG0sxd9o8/4kNH8egvUfbDI8QNkImptgG/m0701IbkKXHq+3o/zYexeKrV3lnwLsE50NF9BJKQ25lZEntl0Q24E+dBaakkFBcSDsWaeYcHVd59daOCvCUJXYNVxm94BQESv1tUDPshS0XytjzCaFdflWSMWX5CQVi20+e3tG2T/lz9B9to+TbaZR+q2HyymFD2MYmQtYmWNAR2uXuTwPaYyHJbTXPDOFXnorjOGizJwOvaNE+OFhURG5cLHxmlVT/sgWi2coPbMLQkVugX4vHPbf3k7dpnAQsXVoA7o4b3aQlmtT/NpAWNZzIQwmkhC16JYdeb2ZCpVub/x8QF+MeacH+KuSn6oiHTKJ9b0kKtbVo+Pr9mXOc5JiQKacgsVsvYVdBiZN95jdLM1qlbvazeR9zbI+RXBRkzxSut95LY8Gk9KEAr6Fcm1jWE0/WBVAC0BjWh9VvuYlCqFp+texQcgPrOCrZOpwl8eKGgIkUjJ3JIB6I1W4BCnzcoCQqEyDYs7t0/db6RzEe4AF4hUY0gXO6TeM6RCYaOsrxNo5WTo39Mk0tbmJPjS/VNlOppFibwJEnQpSf7vDZtrR72Dd1r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(346002)(136003)(39840400004)(451199015)(36756003)(38350700002)(41300700001)(45080400002)(44832011)(2906002)(316002)(86362001)(5660300002)(6486002)(6512007)(26005)(66556008)(8676002)(66946007)(186003)(4326008)(1076003)(8936002)(38100700002)(83380400001)(66476007)(6666004)(6506007)(478600001)(52116002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7704u78q+q+tHS+GjstRjfDa0onrlSh856bxOJuxGQkPG7NeemnMtfwAzedL?=
 =?us-ascii?Q?L+xVcyY4eUjYZ7BJ25Z7glT06/tPIIbfHXwK2M88KU7ZeKEbITO+0uqHsQgZ?=
 =?us-ascii?Q?LSVc29lfmCqlGaiFrkSXUGIfXL8Z9T7O9riHfy288WYm7fe3EW2Y16BVVIEd?=
 =?us-ascii?Q?97HeI0sFaesWdLWhZlaFtccs/dZhsj8biDR5srdGKfHp6/OoFU9sUIYQz3tQ?=
 =?us-ascii?Q?YzJOS5pftQs5pjNQkj7ZXK0h62Sf0Pc3wRRIxnMLMTjn0Cwqny23haa1GEB+?=
 =?us-ascii?Q?w8I73/vRQdDlodfuBniVDMWW9P37iHJMl6YOVt4gaccW0bSsQuF6qX75GAo5?=
 =?us-ascii?Q?342vbypTeOLwzHcLkaCanOnaHuU/OSNl/NMOKVT7djpvwQiKNcgJJcidKlWg?=
 =?us-ascii?Q?nAOsPKS0htOFaNe24DtQfwQcXo/EYrZxK2SPomCgBxEwDtetz1R9Owo6/ChY?=
 =?us-ascii?Q?uaSaV31IkkggqvXQyvK4QTR3dYOW1YEgy8pMBFFUTvt1HJndBmCZNfx+3sit?=
 =?us-ascii?Q?pc3d3N6oHA1VdSApGwL7dOebSy+mewdbD3e+WUT4r50BhKcGlWzWLU/NR9ia?=
 =?us-ascii?Q?bL3DhOrZxiUGsXeY448lq/x2ZTA1PCTaaxNfRyzv6MuT1M/SxfLEUzmhg+/w?=
 =?us-ascii?Q?pxLIUReGOGVdlUto7EVObAmdGaqVIHtCkBqGl1FvtftyK7xyG013ADiJS0MI?=
 =?us-ascii?Q?tbmEqmzNwe1kxmRr4LZ1N7trOgHyNbxcmbQNIEoRSGqq0h8TAXBeN/yIoMZP?=
 =?us-ascii?Q?vI6LkyVaoruuwLlEmtcqwVjkb/Ng/yNw5aFcxeWkSKi5xqnRyXfnbY8g5H8E?=
 =?us-ascii?Q?14jEaEx0Ssb3aPSgUtYoVEicNfG4cdCSy9oKFZFa0YY3+h/iUNAnOz3hlBzF?=
 =?us-ascii?Q?g88+CKZbRj9f+tM6jpIZFmNk4GeQR1jUuUximpl7hv7bieLhWrfjzvJ0k7Cb?=
 =?us-ascii?Q?r6ZznGb3GMaP2tTXySYDv+dk9B+eCssFd4+cyeVI7F8Xab3CTWKRGIfBgvfb?=
 =?us-ascii?Q?xN+L1mUp4WYDB3uqEwXKQbUZpAq5KbYEJAZTfODA2aapSveKSp/Mibw3Z2Zq?=
 =?us-ascii?Q?DvqZXN0CYR/7fPbzQHOmFOG/5/QYWllpNqgUhoONHkktYQ8/V+t3mB/ft3dT?=
 =?us-ascii?Q?u3LvCRRMFF52rGA1QRNTbKoO5EVOyfopbt4QNuNnEW8sT4Iu846ymYKbMYZu?=
 =?us-ascii?Q?s9/9JwHkxaYW5fVBRSQkspNgG39J+HEdNtz2RKqQ6HzyKvFCYL9pFgPbOltm?=
 =?us-ascii?Q?qn+lq+y9qpQvniqrInYwcsXkebvwFIhQB4pSziNuVjr0VoMQ+KPpV6fIgG5h?=
 =?us-ascii?Q?qU+lBf4hJvPnVQ0zVK6eTc6VPVhuK2Cm7M7y+3mDGVMUqZxNEBT3Xws3j0jY?=
 =?us-ascii?Q?muZ5puHxkNOfKYLcxi8IpX8uHE7rzpFJQIxFfStxTA1xym+UAV7xeWfzu3S2?=
 =?us-ascii?Q?x7Jao90RmfEwr34hGoY6BY9VreECzSWKSq09ZnGaoKMuxPkqfxnZER/h+4Py?=
 =?us-ascii?Q?4oa9VMQfM00Y2E1t5jSmJwkTHw9aGY7EBpZKfMvi26jXcxOhfZjpMpUz3EDS?=
 =?us-ascii?Q?OnTvxQFreNs/0CPcQcy2EozgeFPj3XpncQLFPCDmmIywIOzJJx4Td/mRwtGX?=
 =?us-ascii?Q?Ow=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb032857-397e-47ab-aa04-08dace9b4011
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 04:12:21.8059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5f/VyyYEeMqNMn8qFkWFEK/nK8vvTtTc3dlfk2FlN9a2KjmyT7HfUgKjnFYHvPP9dJ3LuOpAO5w61Ff68rnts4AdYV0guDv4XZz7NIuejY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5163
X-Proofpoint-GUID: nyOaz2Xk1mRqrRnY0Pe8rO1r8dDhJiuB
X-Proofpoint-ORIG-GUID: nyOaz2Xk1mRqrRnY0Pe8rO1r8dDhJiuB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_14,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=30 bulkscore=0 mlxscore=30
 spamscore=30 phishscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=38
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250029
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compared with v1, put the link between phy dev and mac dev
in phy_attach_direct, if the external phy used by current
mac interface is managed by another mac interface,
so we should create a device link between phy dev and mac dev.

If the external phy used by current mac interface is
managed by another mac interface, it means that this
network port cannot work independently, especially
when the system suspend and resume, the following
trace may appear, so we should create a device link
between phy dev and mac dev.

  WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
  Modules linked in:
  CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
  Hardware name: Freescale i.MX6 SoloX (Device Tree)
  Workqueue: events_power_efficient phy_state_machine
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x68/0x90
  dump_stack_lvl from __warn+0xb4/0x24c
  __warn from warn_slowpath_fmt+0x5c/0xd8
  warn_slowpath_fmt from phy_error+0x20/0x68
  phy_error from phy_state_machine+0x22c/0x23c
  phy_state_machine from process_one_work+0x288/0x744
  process_one_work from worker_thread+0x3c/0x500
  worker_thread from kthread+0xf0/0x114
  kthread from ret_from_fork+0x14/0x28
  Exception stack(0xf0951fb0 to 0xf0951ff8)

Xiaolei Wang (1):
  net: phy: Add link between phy dev and mac dev

 drivers/net/phy/phy_device.c | 12 ++++++++++++
 include/linux/phy.h          |  2 ++
 2 files changed, 14 insertions(+)

-- 
2.25.1

