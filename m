Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF1231A8C1
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhBMAZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:25:06 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:6520 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhBMAZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:25:05 -0500
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2021 19:25:04 EST
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D0LdrN023847;
        Fri, 12 Feb 2021 19:24:16 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hq424ak3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 19:24:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPN1sH9wy/Kgk6drb1xjVX+jAPefZyZKgWRwBtHhAobj7M0GzPAxYwHfwqAlDjrGGUSvOCUQ9+jWxcvspUp6KuAx8ino71Nu5O9RWcm+/DHhYm9Fe/Ot5QW1KBQ8hjfJww22pkyA9qeUnQpsTqmL6CDem7LpFoSVzQI99geYi7oVavsnTEi0q+N6x7SrpLhhvxSQY/hnUd8is0qhmhzHBZbKykVgfmUMDXMIAVr5oM4ueEzKCRYu3LjEeYtVY812Qylzj8VDgr1XV2kv5K5EGDUtzBBuiUh8czh0Zn3VClhvvl0ZwUU+966s8cSm0+nOtYjzpN5jYhEqsIexbylIAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bu99Bsvt15ACcTW6RDBzRhCGbPtCDBfUOJIXRCbmJ6M=;
 b=hME6qcDUck+nu9TcfPafNZmlzdf6GSmQp1nWe5boSjHPa5WNobA0YnjVd+F1zkFM3rykS4sMLWRgdTLZ/+BmQ1jnX0SDrgvK3cMVWrlmQCm37LLhO2lA8fx7zESIcd3vMH+dgAJUH8ckpYFLceaHaf7DnOjx203WI+xf04DTlKAz4saNfOSzaVHSPbTdEjZquSvCJYbJ4YI7DcesFAbRGjQ8VU8y/3UsCKxiOD+kiG2qb+IE32YlL7MnbcZl8XFomB0NcOC0BLTdqWT3ZW8ta/9aA32oBQotsOfz4oUKhqJaZ5AMYLlIoEBvxhiVaff9e9ecWQ12qDY5E0/9xPasVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bu99Bsvt15ACcTW6RDBzRhCGbPtCDBfUOJIXRCbmJ6M=;
 b=bxUSrPVNXG9FpK9w7QHGNJ6vmzwDxJ1PSUcvKlOYtns6Wa+v1pDZNPRj0rxPbER57Iphnkzm9oOPQDAcuJw4GgmRigb8UxPQrf9R83NQSE05sSPpKifHHr2Z+00QST88i4hKW97Ch7gmuqhrCd7KRi99Uek0W47PtlOCDqTpuLw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 13 Feb
 2021 00:24:14 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3825.034; Sat, 13 Feb 2021
 00:24:14 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/3] Xilinx axienet updates
Date:   Fri, 12 Feb 2021 18:23:53 -0600
Message-Id: <20210213002356.2557207-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM6PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:5:337::13) To YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM6PR07CA0080.namprd07.prod.outlook.com (2603:10b6:5:337::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sat, 13 Feb 2021 00:24:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f8ea1f7-eb6a-48e5-5b84-08d8cfb5b112
X-MS-TrafficTypeDiagnostic: YT1PR01MB3564:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB35641B9AFD8DB4F5E2B384C9EC8A9@YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZwG5mCzH5lMY7bSQRCd0Oyh9YIg+kzDl4BMZoXPOAuAERkEdA/JXaTyPLQDnoEzV4syLmnA0k2SqS4tkvQpvVLREEQEMr+wm/v3knv3wsNZ4B6T5PNBdTBq4ovyv1UhM0ZkxQYRxUq6u7JXafvwF7eKPYqp0CwXLq/CEkAm0qEiJ1EUKQJzDpV60pINUWXUhmov6/wvcdozdrIcd2NBcaaRLJ4iUo7VtbYgAp2+z9KA7xitEjrSFDHbP+aGSif6Vup8OUSxk2g+cZ3ZoGvomx72GFRqcPY5qlqfZb/0CaJkrEyr6UlnPZ+LKRTBNaBV65RoAgFzMyv9QExabU9Qas56oSEu/nPqBwDLRxfT01tzbHPxrAsUHDRvSuwGeDM0cniC7/uhBbJKLTz59p5Fw2pdH+h50cNYVBA3RQAHyJZt5Tug2VtW5JUSfT2wF6TQsmUYIf+FwYiB/xKHELMEzf5kEWJ2RXhTbwbF8kSC4wfC6waN3SCpyP9zZRt5BSn6ZeBqfcx/qWjwi9qsw7AqAKAqC9lWtjtCbb+by9WF11hN1Mtj1AxtPY4n4/IRWNHuXMuhbH3jIKuJV9rcUS+Qkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(4744005)(1076003)(6512007)(52116002)(4326008)(478600001)(66556008)(66476007)(66946007)(2906002)(8676002)(44832011)(2616005)(107886003)(6486002)(5660300002)(69590400012)(316002)(956004)(15650500001)(83380400001)(16526019)(8936002)(6666004)(6506007)(26005)(36756003)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yXqrHQOLQ3CSDggW5ATsWKpYFFle/C2Kf/asFpXtVQPLRz7PXUiLOE60T/4U?=
 =?us-ascii?Q?FpiFNV3TqD7kNZr6LftTd0A/G0qPX3M120/yskJCk/yXR7z/k3oVANIfGjbf?=
 =?us-ascii?Q?gSgpK8TJww2hiaTNDrWDY2Cr8V9kFi9WOYN1MwC9kivkm0eWXBaIsS1I9nUy?=
 =?us-ascii?Q?G7Gp3Y0bN9gjGtBWpkhOkXeoa0/hPZRI0oJkjsXpDS1fCXUJipIEjkG75AKq?=
 =?us-ascii?Q?X0+krtNUALINDPhRZslo92BoV/P9jj19HJG+kurRKX54/OElW+2wxSOqNmq4?=
 =?us-ascii?Q?SQpvZDzOP3jNLFNozRcnIBwflk1QVWwtuhGlrapArFDQT1qK4ey6MarCChPQ?=
 =?us-ascii?Q?KVFcCFATEenmya9NURmFthPJtB2PnBtEIZ7SZrAihbIa6N4wXYNU4XweTK0X?=
 =?us-ascii?Q?8Gdpa5QW8+hjYqk2MjsjDog0v3XmbJLleOS0hUesWkZ3R3PJ/F/nEK6uchCn?=
 =?us-ascii?Q?o9XLCfSjh3yFOFStXiQrrmw8RLBc2j19wIh1Nejy6XYR+zCm5+hkCrbTRqbX?=
 =?us-ascii?Q?bAZudjpvblHzCvfWL4LWy1dEbfkz/Bm7e9NH7bU8x/JixrZFix5Au3zqk5tu?=
 =?us-ascii?Q?YjJRhRDoiBJe4LGzVPf7VD4foRQgEHct6+nm3w+fGLN9HMWS5Wh6OMrZz6rn?=
 =?us-ascii?Q?7snSaa7ATBhWYf8/O5zbcs0S4WIMKzaRlCy8hcT53VDFwuoWYcSv0qeCh+vj?=
 =?us-ascii?Q?xyXazawThGMxsoW3rAvE1wrgfIfC80t8v87mp14jciA+5CV1ezHUp82T/O+n?=
 =?us-ascii?Q?th+t9QWm4sczUxrpgE0VwkKd5VE5naSBcWtcsh+TiZmEAk2qiITqF2C8aLd3?=
 =?us-ascii?Q?Dh0uGYZEYQ33i49bYdbhUSSn1fx3UbR4xFNtljCajAAU/6UUryTIdWEWje1Q?=
 =?us-ascii?Q?e/jW1699CnHoMq5MdL65SHnYaKKLYJRZBHmUeecOTOyK7ftD/Be20aiXwCK7?=
 =?us-ascii?Q?/TPXt0bycg+fMGFqQ2/9JLl6vlFq6qa4CT7zFhSycV8wTENLDyGrZiO26yF/?=
 =?us-ascii?Q?x6d54x6nBiWghz7xU9M+rXVEH9iAplmKnaVUHVatMiWKAF0CP+L28LTRucrq?=
 =?us-ascii?Q?C/rzB9rJR2N0UV/cad4baBrJp6y9/Nz0iQEliYPxIG3xgUmbxIewlcUlhlzs?=
 =?us-ascii?Q?3+VDcfJlklitlhNDnsJmjbD1+bFkGDAVUud4OZU1lDksmY3fPWMFl9RARo0a?=
 =?us-ascii?Q?0pTfLzrr4bY6T0DHIfgM7Lt5SLGrW2evj/wDEL4nDgTbsRvO8dMRm4UeL2Fh?=
 =?us-ascii?Q?RcY4lsCcpTjHH88q+73LfuV6fUE+ceqeg0CjnTRpGBoD0lsu/kEIu+6iZsKx?=
 =?us-ascii?Q?MSp/z74RO4VBAT75pQ7l1y3g?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8ea1f7-eb6a-48e5-5b84-08d8cfb5b112
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 00:24:14.1434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNHk1154bVUXrzqZaODIGIYnxJv0Ay5XQmAad1xhYmyh7pe0MmfN2BJaqyODR5N1xdTKWDnDqYHVz3W6radqo0AXhAULSNbQ4R6q6JxdRHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxlogscore=615 spamscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updates to the Xilinx AXI Ethernet driver to add support for an additional
ethtool operation, and to support dynamic switching between 1000BaseX and
SGMII interface modes.

Robert Hancock (3):
  net: axienet: hook up nway_reset ethtool operation
  dt-bindings: net: xilinx_axienet: add xlnx,switch-x-sgmii attribute
  net: axienet: Support dynamic switching between 1000BaseX and SGMII

 .../bindings/net/xilinx_axienet.txt           |  4 ++
 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 29 +++++---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 68 +++++++++++++++++--
 3 files changed, 83 insertions(+), 18 deletions(-)

-- 
2.27.0

