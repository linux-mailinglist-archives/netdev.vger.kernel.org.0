Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9B23397CA
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbhCLTxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:53:34 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:1422 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234319AbhCLTxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:53:09 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CJqivH003081;
        Fri, 12 Mar 2021 14:53:06 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2050.outbound.protection.outlook.com [104.47.60.50])
        by mx0c-0054df01.pphosted.com with ESMTP id 375yymhm8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 14:53:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ogFUl9t1/JDEEr11YFxhbApfOxV91H+RDaDqgZY3FL9Zdl/wsRtpi17bSyYRI0bd+PlMwyc4oqE7lUky3thgxXSTB/JX7J2LrIB/MY6L413mSBI4iutKFVq2cpzi+j8NxtsV8da7gYWd1XkWzE6vQR3vmZowogPAF/y09Bi3LWpuJr3M+Mzs9DDBWnfr2pCo5mQl38lR/l9/K/4GX4carFO/zOgjw90DXILU/0k92HDgbNTV1fYMp35se31S/B0gLJvLNmv38SusK5d1FOCUFJGImWvmQg38It4BkVk8Z0RUoOqWh+QJjEHTwqVA36oQjYGynUnP5QUX+FMg98vg0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Z4Vqp4iasz4MObfMyMTJX/g65TnkumCT0o/WSBvUf0=;
 b=Mq3MWdOTYHI7CIgj6e5o3wQJuL60rGmS1F1VSMDD9njpO7I4EcI9T45zHlEj4/tikZc9CzdzlfDcBOcfDBhWnWGEuNB8NmwMdYGBc9d9pi0Cl5UQGXA1DHS+awKmqXmuypsM8e339swQiiLqN1QwTE/FkbkiJsJxPDYxLMdlzPSnHf+AIgdbySGVlO8MumNl2OrlhMipD17+QpSaGtwOwNrl2uNMzCwynsiEZYAQDiVwVO1cOyx9NChyU7fldVcQSNL8GCjf1kQJS1Y6OlXd6EnPLE5gY4BY7nUoCRWhZHg3NpPk17jF5FCASnlo/81XZlwrZP7QRE+u0mfb2fHmyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Z4Vqp4iasz4MObfMyMTJX/g65TnkumCT0o/WSBvUf0=;
 b=XyyqW627j5giB56i7yf6Xq5unrJ0NBUY6Z/KI5E3DFL6UYMrxBkjs2s2ykSGPy4L2jsM4Z5bUQP7u0+K2NoHUAnFPWMWavpGX9V+ENqDWe3Sw0k3PEI/zBGyjLWXo8qkUb7lNQSj3LyfeV5kvIyW59we/O5cOWPWb8IKxVr3Gfw=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT2PR01MB4415.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Fri, 12 Mar
 2021 19:53:05 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.031; Fri, 12 Mar 2021
 19:53:05 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 v3 0/2] axienet clock additions
Date:   Fri, 12 Mar 2021 13:52:12 -0600
Message-Id: <20210312195214.4002847-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MW4PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:303:8f::30) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by MW4PR03CA0025.namprd03.prod.outlook.com (2603:10b6:303:8f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 19:53:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 305fe915-27b3-4a81-a944-08d8e59073d3
X-MS-TrafficTypeDiagnostic: YT2PR01MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT2PR01MB4415DCF890383B26D6E41D1DEC6F9@YT2PR01MB4415.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qtid86w3MrWqR8CqYLhwrGvXvt2fOcMjlv7UxCtBH/N2+hFXMDZQwiapxdZcPxLeizP3GzPJS1inGqjaH6bHtMRJAO819ukHHo2iguVhExXFeObKHJLdSzA0b+yl+a+EGuiPnL/WHYGmOffbAKX79O8/VJSXP92Q28SHA8eeFd5Pg9oXHjN0layeyinWaNkM5w3+WM+LT+H+3NpnRk6FOm03OWg2wLmLKY8kcrFGVZwBKa11QQv+6gQQVkF1dNTCMwKh4ufdRm6rVPRpeC+5ocbQbDDHFriu3q1/LGv+8jcqPkJJVA94E98580bEcWBjbDclSRITO7T0P4rvjKKIhB/KxaEE9ddLqPA4OsgGwJWJvxQ0daVWmBNNNjTBsTIOV7Y98/X6PLS/7NIMN5ulOkuHNOWt79yr8Qyun/Qg/Ixt/B1xSYd3q1ViEgNiW0Qg6mkYlj6cs1Sof/NZsJxuDaQ3QHI/TCZjqObekGFNZLqqTaiZBRLoGgpmurEQ6dxfvfQ3KyrXZ4EfzTDrXsGMb8vt8Hh0K932TekZeFvwJj7D5CuEfT/83wTyt2R/i/Hi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(376002)(346002)(396003)(6512007)(69590400012)(86362001)(66946007)(66476007)(186003)(26005)(6506007)(8936002)(66556008)(478600001)(4326008)(956004)(44832011)(5660300002)(2616005)(6666004)(4744005)(6486002)(1076003)(107886003)(83380400001)(16526019)(52116002)(36756003)(8676002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?deaSPv0fFbHzHCK5RwmyMT49jSkOqoM3BN8R/4FiM0f98fIjR6i8IkvehHZe?=
 =?us-ascii?Q?itwauJww3xl+uG2pYgbRfjgCpR3u2OgJ3N3wk6IF1tXOPCZNTn7ylnuxZlfG?=
 =?us-ascii?Q?pEVKPAQkx6YPhVlRjmrYGp08tgktGdggAQ6/HhA5y8+Q9T8vxIBaqovhJ7xW?=
 =?us-ascii?Q?GuZaL0COwH/WizcUVxlY/IbT+jKvPvDusnWyzcrHsQYnmyBGs58bIDNLxwO0?=
 =?us-ascii?Q?byHAg31KHOcGwVOsY3bSMiFtc1g7iJduCnGJ/17fEL+EikBuqTg9Flu6y23g?=
 =?us-ascii?Q?bx5Jok2RS0W3+BGwF7DZFKxp9zJfOePX6KQYJC+pgk6ap79GJ+BHuK4i7kLf?=
 =?us-ascii?Q?dY99gUEz/DJNyu7OwvMAtOLe6KEP4T9HNgM/9922tN0UKi29VootvEm313vR?=
 =?us-ascii?Q?1g/E6bs7HCKjg8ho9hI+SPQRg0vDMSvgXB853UTC7X/UpMBWQAycxpj6y8lk?=
 =?us-ascii?Q?nE+bJubDwVt8iPbdnxLZttMSYybCYMgxAbOv75XOaJGibGx8BUOdkjqIbVEQ?=
 =?us-ascii?Q?xzP1BgtTn9ZLmQ2TKolUSLPEPp28HuDaSdoGZdDbkUqZvPZYM7ave6fWZJAp?=
 =?us-ascii?Q?eHv+tzaWkprARJTlX+2h6j9fm71GmeyNNkC1QgSHVE/1dkhgTBfAcx6iTNsg?=
 =?us-ascii?Q?6zIuA3H8EZJt4/3Khgfnomcb4EZdhghJXS/nfUVoNW48MCpgGhITciql6w19?=
 =?us-ascii?Q?SJnzCdZMSikZt+AiVwNeJOLvqIiE0zv0HyWmn8aiaeLhpXkLp3pEWS8J4k54?=
 =?us-ascii?Q?0o0bcq2bD+x4L3tdlcFx0vduWNGZ92TcxemwD/GNlGtkWTmknymMed0BGBMs?=
 =?us-ascii?Q?wiN8/zrMm8wLbBVpHNMbCATijbt8D7M7x6RKGrrTZ+bpTltefMm2KO7g+idL?=
 =?us-ascii?Q?WOWGbEdOh7BJxjHN3e7ZhHlrKz11UYyWhuV9CZAy6aneKiK7mqey6wQB9Siz?=
 =?us-ascii?Q?AcSiCmbTqbdjXX1K4PVOWRvViV5K6GgidnkbJ2bjqGqMmOIBmZVp8G3XLQAF?=
 =?us-ascii?Q?WTR9oPPf1BgYHRLgyJHd/zzhVeJYrhFFsDH8qk5LB2hMIT29YA5AU6iSpzYZ?=
 =?us-ascii?Q?9mT2F3DReecg783VLto/HhnVCBKiSZ3WR6zP6AjQreipC8xaIXkD2i/cuslH?=
 =?us-ascii?Q?NkiXgcFXueHL1h68YIF3ELjwjKUJKlXEYGktq4wMVAgvjK+GLBFgU6rD8KH/?=
 =?us-ascii?Q?zY4VqzR025QbycpXAg+BSMPTW/JGVGwz14FyVJDy2xFJKHE399qRPcBj5Cui?=
 =?us-ascii?Q?OUPuqgkAt6RARMGsJKTWwSykAMf32HVCe2hYMIBAP9fJBkhSKta5v/oYWt48?=
 =?us-ascii?Q?6W2H+5RDWm0Z429D0WdIVoQH?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 305fe915-27b3-4a81-a944-08d8e59073d3
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 19:53:05.6416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/tfuSwPemEPOOvgmzrm0bI70aYYwiYZE5n8TLEbPBWYoLeSfIDM0D9pkT/xYzgYgwMIZr+zw6JEXEe0pgR20zrbQm7R+FT0Jk30CSOD4nk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4415
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_12:2021-03-12,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to the axienet driver for controlling all of the clocks that
the logic core may utilize.

Note this patch set is dependent on "net: axienet: Fix probe error cleanup"
which has been submitted for the net tree.

Changed since v2:
-Additional clock description clarification

Changed since v1:
-Clarified clock usages in documentation and code comments

Robert Hancock (2):
  dt-bindings: net: xilinx_axienet: Document additional clocks
  net: axienet: Enable more clocks

 .../bindings/net/xilinx_axienet.txt           | 25 ++++++++++----
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  8 +++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 34 +++++++++++++++----
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c |  4 +--
 4 files changed, 54 insertions(+), 17 deletions(-)

-- 
2.27.0

