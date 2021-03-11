Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5463337EC6
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhCKUMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:12:01 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:28577 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhCKULw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:11:52 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BKBk9C029469;
        Thu, 11 Mar 2021 15:11:46 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com with ESMTP id 376bes9hvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 15:11:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUeimwskF0GqR5eMcP8ugs6ok86pA/z2QmX5u3p34TJtDaxSLYsk7UEtWLNqLMce0Vss0YbBbvMy1+fS+Jr5mCJZ0IrIdeRbU9PtLk2Mkr83CCBWdgmbbTa2NKicyoa0ZSI8DjzsVkMRM3kw/SVvOBGBkrdcokd0uD1qZIRlwEZna5pTvKk/JPs8ABQWfOOzZRkaQMVRvA3XZlAU2Qnq6Vw8x8aV08zzk5pqrRJIvR/yCC6cijSA9h1vhe7gk2cseBKcRoSl4PwstPCI96FlVJDljH/TsQfdxlz92yUCpGy3sdnKbt3OmpQBy3pXUOBICbWJEQkoybLprnhHKpvjBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0BPugQlUQ51TieQ24OSvGo59gG8EXjMillu4nOE1WM=;
 b=LWulGRu9P0zqn8vwbbDuqATr7Gx5VfVxFbttFu60PSDyG9Bw5sYY8apzpBJeIOKkCBkLw19O9reWTSXILFR+d/RP8+942Bbw1A4mZPmyu4J6WzRQY2IZEHwIXleCfhv/hGgYlgxat0LiwsMsA5pa1TZOTQoQbep4y28kdu6aK9qIahDKzewROZbazA13Ulc2cL6lJMIlvxSFJWqKyW6gMmjlZDpupCq+5aOyI6Zr93PBEKwGFBrB6yvTnK01ORXyjHkk241OKDd04Gv8I/jKumMQ68iMt7PWizJRpKfZu40zclHy23nkVn8UJ0PNgnAdp0rasNzeCZaQf/8u6eesdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0BPugQlUQ51TieQ24OSvGo59gG8EXjMillu4nOE1WM=;
 b=Ne4h37Mu4w33d90zux46t75gigk9V51xzOIfGOPgNCK6hX6HOpg9idqhdPtZ3Ch/Lcok+lGPlvhXxLf9LpFhbONTk96X6gdpgfxy/Z/bo8tM6uwZzW38ILSJ5A4beq30NsMKEIy07avwuoJT+C1JW9kuZtk9IhB2n4W95fini80=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT2PR01MB4446.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:3d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.2; Thu, 11 Mar
 2021 20:11:44 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 20:11:44 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/2] axienet clock additions
Date:   Thu, 11 Mar 2021 14:11:15 -0600
Message-Id: <20210311201117.3802311-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: CO2PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:104:6::27) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by CO2PR04CA0101.namprd04.prod.outlook.com (2603:10b6:104:6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 20:11:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2aaa2465-9f13-4c20-5abd-08d8e4c9e474
X-MS-TrafficTypeDiagnostic: YT2PR01MB4446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT2PR01MB4446854C21B00D079E57701EEC909@YT2PR01MB4446.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfbpiV6/SQOfUAvIGF5sFamUK7avihX4uxvfndCQJAcjQyVneNoGG6QXZPncG6IzP0IgUeV0NE5mqS7GktZGRSd2cJk0AE6WPIknA7En82oYolLMK78AVJVCxsooJQC9fPViqft+oiMpgxyDn1WK76bjZYJf2m9yICR20YVUzVlkPYJPyhbs9nIr+RCuJhMKHxOqhb8GSJ/Swc0f9bKMtTxbEtJXOZZT5QuWM6EVWOx95FXHRz7/mOKa2MvgA7oWKb5K2MVUmBSEpqqw2Il7JHiZOOrpcgJsCbP0e6OGxolmeVnLnOjYD0QFZEXV/xlEzXitmg9filc/gc4xdBt0SD8qVW5oX9SRToWwnO4+H6bHdkpxxkA7uu3JczvUJ8AeqZ15sH5mQipTLfxtcSzZ1yh/Bw7DaLhF4Pr493dUEEqtbdSJhDZn2YheR4FAMf6vPgfkTN8WDNclnH6X0B03t6pNAH2vdxTF74dKbaakXmZC+AcmUIKI5KyMUtolGgERJ1bCPRTeAYNsNioakYDPcktnH/CMRQtYEDdRIc07eLicyBOsqj8DK4gcYH9PZ3D6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39850400004)(8936002)(2616005)(4326008)(26005)(44832011)(956004)(186003)(8676002)(36756003)(107886003)(83380400001)(4744005)(69590400012)(6486002)(2906002)(6666004)(5660300002)(16526019)(6512007)(478600001)(316002)(86362001)(66946007)(66476007)(66556008)(52116002)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UzC75vIhAYm6QxaOeamR5/9HnmAg9zmGdhghgIxFgFzUQbHH60NH5yzalt8b?=
 =?us-ascii?Q?TyN5Rwv7qOepyC23RPM4OQ8y7lDHYtcGnPTq67vv+6Q7WyZkCx4mOzgiMiH7?=
 =?us-ascii?Q?Q7McV5P/v7htgvaLFEgMejLElavMNkwlv74n8MFm215vpcz8RVLcTfrw1WJT?=
 =?us-ascii?Q?qz7laUUZhWHXwXfhJDuLlPEJ/P06ynDWfs16lEEQM8Dt4WBqAP58Rb87Xgcm?=
 =?us-ascii?Q?I7zwL4wS/SJUg/z22tTxwtiiQB95WBgFBSQoEbff4YzdYyjSRsMQ0URC8Dkw?=
 =?us-ascii?Q?KSwGZ2t56RDnk9dQqtfLDa/D90Zq4hb+V+A+ysDorA7m0niYyDSM52JBzeDZ?=
 =?us-ascii?Q?8p2+DhN/yLWQkQ0EII78LeyI5xewMAzEOXMYUqh88vFQuuAMol7lps/uFcso?=
 =?us-ascii?Q?diA9YM9qsmAccHX9mtPn5g/xrG1/VD878+Tu9i7L8tHt4MiP1FlQ+G5O96o8?=
 =?us-ascii?Q?drXS0Ik2Xh5dGqfZcyPC6+ki5+sttk2yaZe4tkL9utbJbBtaFo1ff60wMdqu?=
 =?us-ascii?Q?QzmPU54moxoD1AxE22vB+ZGUPsT8RDLtBe9AQYI9EKruvtaw0AEtcSoB8CJf?=
 =?us-ascii?Q?O1z1l0YkHAp1kzAa/w++7JRij4ORfSKZk/ROgDth6E8UwMikUoZOE+UoiPZI?=
 =?us-ascii?Q?W51TXlt+SK/lpJI5cwj/1iLQN1YnGhQXasePQ2ZII8wwL+x8O1DGX3J/m8Oq?=
 =?us-ascii?Q?kDU4gk3AAWwx88FWExRcQS7txg/KLcup9egjmOAehVRW9REpoQGVNyGeRFRA?=
 =?us-ascii?Q?KrY8j2APQLn558vmyDZHZYtkA0zyYxDc8LITwquVnlCZrSB/O0E4v0mGunbc?=
 =?us-ascii?Q?EnOn45vS9afU0X52bHR2efbhqXhdbFzs6r2UfyRhE8LAqWOm4yYJj5jzTLOO?=
 =?us-ascii?Q?FA8fTbjsYSUa0sjcx8HijDXPTNHkgRN84Rbx6T+kTJ45r0J9zuujFo4tmtgx?=
 =?us-ascii?Q?pZe+aGWw9N6AMMEpP2DAPPStbqocpSAGp5i1LjVXa6my/xZpgxASiinD9eXT?=
 =?us-ascii?Q?wHA8isbJ3jfLQh2cpoCWb6NKd3MKHDalJ0bog03iuhCkbLFNy1WZrmGBxlLK?=
 =?us-ascii?Q?ZO2BbRZwNkOw+Dzeg7Wezz8HunAP+BNuyjTlI81wbYknv80aiIYhxWT1xjfm?=
 =?us-ascii?Q?9kl+Uh5IXZV4yO+ZkD4njUCbe+pkQU89zJDJumPshjAbIvEuE/oNBbMhQHgF?=
 =?us-ascii?Q?6NPJ1lv3JhkOawAOLcsIhltj5wMP8EO05vfTwRyAcV8UKkJqAJDFg8Gp9800?=
 =?us-ascii?Q?OO18TtIKe+da5MfKmgWhcfKJLeXVX0Y/NilvnjgC3+t0itrByUZZxNCse7hc?=
 =?us-ascii?Q?1TU9jy6otdkLNb6LTtl0RHEE?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aaa2465-9f13-4c20-5abd-08d8e4c9e474
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:11:44.7224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/v9zaYsRJK4BhAaqACDVhG10vqWWw9n4w828L8wtVek87s4zixGVnt1geFzv6KbPnbPCIVHcLiUzlctGq3EAkLK22/uVTP+WnFt+ifdYGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4446
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_08:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=803 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 clxscore=1011 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to the axienet driver for controlling all of the clocks that
the logic core may utilize.

Robert Hancock (2):
  dt-bindings: net: xilinx_axienet: Document additional clocks
  net: axienet: Enable more clocks

 .../bindings/net/xilinx_axienet.txt           | 23 +++++++++----
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  8 +++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 34 +++++++++++++++----
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c |  4 +--
 4 files changed, 52 insertions(+), 17 deletions(-)

-- 
2.27.0

