Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6983B888D
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhF3SjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:39:12 -0400
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:62027 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234103AbhF3SjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:39:10 -0400
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 15UADer6017608;
        Wed, 30 Jun 2021 14:02:06 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2058.outbound.protection.outlook.com [104.47.60.58])
        by mx0c-0054df01.pphosted.com with ESMTP id 39g3ve0s3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 14:02:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntHt60TEzwLEPTuxOMaeblJc65gXxWp/K9iUM4Y5AtxZThqFrbpgqW6piuMUVXjkIVZKQLPLWyHf4K39Uf/fmTE/e4rBwlDt7gUwzNaS/hn8DARdkVbfrXPAcp/Iuuxah/tUhoNR4lj5MkamqFYVM09G0m9n5ePrF3rIKjMBE4sAVHp1gyW3IRYBsnTpcE8ZIs1IH2pko8pEzIW/GFJJty5xUZjTWhg8P0x3lFO7AhRMhpk3U5BVpRyb/kFINKP+deFH+y22ac3Czs9+wzf/OMrtB8vM2V9A3DrxrudtKXNBmeJd0JklblPAAMHstEdIWgO7QmNVnK7aXt8lPqaD6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ra3iO+wB+J+k0gqamRZ3dKJ3TXjgQiSk1nvy0myMVVs=;
 b=O5XT5FxavkuwnnEzLMwhx1j0O4Q0Mi045VsLqZ3RIacp4rlezH77Wtf91sEQnwvBcQcUQm6ztwKIkq3V8CS2jPlOYWtawyu3un8ZtJ2sDgARH2YmObaNOR0Y/damxE/gIsUohWhho6PuNiaKyc9ifeMiONmAonfwFiAu/uUmOkIEVDNAsBlHDdnzJHk9q8A61lFyWjQHUpaDaroBxPeh7SgJYIKY/Jee5+8PQbrwH82TIDPXkWt5vog7XpIPWYoPAJKL0fUFCgcwqxu48W1YF2faKZd6tq8fwTy8DxfGa/EfJb64LRTfXn6uf3ruRwVGk1JQz2d4EqPQK28AJhZGGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ra3iO+wB+J+k0gqamRZ3dKJ3TXjgQiSk1nvy0myMVVs=;
 b=ipXZI7gdhcjUlRZpjoKnEzYfBHJuprqti4AnmSDtkae1EDAwxRoqaIS3EGKvQ30nvQIscjiLeg744BdFby3jJf1twucjRPlzOvHOj4kc/HCBmiTF//WzDR8/+XtVQr/lOsLKMiqcD2BH6hdRKfcHYSOxhD0n0CCiZVNP1ghpfx8=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:27::23)
 by YQXPR0101MB0869.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:26::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Wed, 30 Jun
 2021 18:02:05 +0000
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007]) by YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007%5]) with mapi id 15.20.4287.023; Wed, 30 Jun 2021
 18:02:05 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/2] at803x fiber/SFP support
Date:   Wed, 30 Jun 2021 12:01:44 -0600
Message-Id: <20210630180146.1121925-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:27::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from eng-hw-cstream8.sedsystems.ca (204.83.154.189) by MWHPR08CA0047.namprd08.prod.outlook.com (2603:10b6:300:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Wed, 30 Jun 2021 18:02:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0067fe8b-f66a-4c92-5fb8-08d93bf12b8c
X-MS-TrafficTypeDiagnostic: YQXPR0101MB0869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YQXPR0101MB08693EEDA7A2C71B2A372C80EC019@YQXPR0101MB0869.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QmHpujGXfr+L6dL5Id4+yfdcZ5t6fJBAMdiIdBOOrMH+W7Li5FDBKNz02dxY7qLYss0vsyLO7D8UtADCuH/aEiTLf7nyI/KzRvs969tFRmbBC97ziUUx1tGQcrzTKFjovyelqGCZI7j5BcFUY0hUVVQoQK9Z5eMiG40nLzBqZfqv6Gl8e0eI3/F4HEMVBJFJDgty18ll+Ivmgd1ubiS5dWCe5/QLT6ty7UZrO+0iZRfpO9wilzxWH+php1koDu01R2BHkXH51SwSwtQeswF/hZKVDrNMSufJucUSb4q0YCvrlWJlAhdF+j1iBQi9sMT3h8GsYAMvNcaRat7AMcc+OcBNWq4rrrdYKvPG5jImiSkHdXlkN+caOmsHRPylKJO0GiJBXLpyAQv582QQSQWc+LHzdouAbGZyUeCANOl1ba01xFC1tDIfMj+CqHVgxuV2AfXQnSeIwRSWtWa2gz//Y71hvEvMltBwx9pHwks53yyd5+Cofj4uimke/mX0Q0G8Gm7GyUAQJDz3zOIRku3sDSdjaVFIaTAZ8brEaIS2qTfPgQsK6ibHNBeJBnhRa2VDgGj01zMBQcGd2mtQQISG3jUHnWX5tuQaGiZNBXNL+ewByO6jHinflNc6q3yasUbYDncoJDLoPkloytAXk+ERJaApjUkQOPIhR2tKjN3dlohIRHYm1dpSm0B4FUtiD1NfqIjKBzx24xFDAlccLGRApg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(136003)(366004)(396003)(346002)(52116002)(16526019)(2616005)(1076003)(38350700002)(6512007)(6486002)(186003)(26005)(38100700002)(8676002)(8936002)(66476007)(36756003)(5660300002)(478600001)(66556008)(44832011)(6506007)(2906002)(4744005)(83380400001)(107886003)(4326008)(6666004)(86362001)(956004)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KT5Ay9rcC577WmQ2Qs0iP8lZbiz/B7kOp7tf1hPKXeGDzWFURj7vHr6yXOyh?=
 =?us-ascii?Q?niQXpyPY8GqJPk1g6bt/qxx9ZInfwLDzR6+SH/jvgyyg1SAsi5dQKtLhqZGH?=
 =?us-ascii?Q?IP4cHweVOVRNVaLdaTTIOEH/gMNCc6M8OmL+zFoSLC1WmeCa+JES+wylB1Va?=
 =?us-ascii?Q?i0c4cgM/ebnU7hQKWrQd0XrrUXIu0cNZF9v9iO9RfT8ELL3qbEovOXabJer0?=
 =?us-ascii?Q?1XLdulBuw64n34qUhzw17DjA9ggihTBete9NeWAHScWSSXDpD8zFgasTmMzE?=
 =?us-ascii?Q?QEDJ5PLy49lkPJIl64zseWAtwKnrPUENKNf4XEucdXI3oKI+vPNPLv5NVndr?=
 =?us-ascii?Q?SauTXo6LpPOG5Ku2N0gr75P6yCKHGGq7qM7vhFtDx/xDm00mw7vNsy/+4Ws9?=
 =?us-ascii?Q?0tqGTPNmOd9zkcMVLRnRhP1XCGZI0CLxHUdSmSlG7spDQD+0I725S7XU1Pxt?=
 =?us-ascii?Q?ypoMIAvFBJmOuIgOEr7SkojqUqajhj6FKbc6lqmwgOQtZX9ZJZ4hQ+HYI1Z0?=
 =?us-ascii?Q?bj+i36F9S0+YxkYpOQ2EcLYY5ZtTa91l9N4dzZgOblc3vy6U6Xl4Ijb3+oaE?=
 =?us-ascii?Q?BgjUT/Is65fIwbtpxbYI3f+rS+Qw9MY73NcOT3obnXm79AlOV6fKrfPz9BUF?=
 =?us-ascii?Q?oQerxgMnxVYdv9FD3Ov5Dw/0ClD324o6ZufOiY9eHdw88ZDxFlCpwejUA2HS?=
 =?us-ascii?Q?P43V8ybrNrImhmrAQrx2fVpPJNjTX7kbDqBim3Bu3T5M85UlHq2h8XUnA9z+?=
 =?us-ascii?Q?152gUvPTsqW0ttq5h/YmlRPREJc0fFByHW/tjpSx/i7pRP/4p3l7K2VmRLBn?=
 =?us-ascii?Q?3zKdx3/IARjeNytux4PSDYZz5yyO5CTrooWEBAW/KDce7F5pYMqKOw2+afbl?=
 =?us-ascii?Q?8sPvuG2OTvgrpTOhkrfhPcWodsN7IMEF8oa7XBJS00DUBZ8NjAPx97A2+Buh?=
 =?us-ascii?Q?XKj/skw2euah00ozsK2BbKtwe7MdXs3ULXVWLqGSrUulR0xf7Q9JuKJY/YGK?=
 =?us-ascii?Q?EmHKoul/7JSJ+yabtsrVTVRQNuvqfelLINoSOeOUbWX+noqApM+DJniOkIVw?=
 =?us-ascii?Q?Yu2PwVKkwBfwd/DXLhuHNzdOf0J1v+zmGOHH1WdcfMjlctQoHS/eT0Er6JLW?=
 =?us-ascii?Q?3x09CccaBD7NIaaBgzvkLQKNmx+a+i4/3x50QdjA0rIehmWDZykgDNwTZ8x+?=
 =?us-ascii?Q?f+AWaXSUwre5l6XVxp/+ZD8rXtVocidDsVrJQBkr47/i7Cv5EGUCPBZyyrk4?=
 =?us-ascii?Q?J9sv88LYQr/jbiLiblogI4GKtFGgp5YrIxkkPqc50KG8wc7xAU0fZXdZFra0?=
 =?us-ascii?Q?Ks29gzzRlLz7uXhL+Rk5e+2r?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0067fe8b-f66a-4c92-5fb8-08d93bf12b8c
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 18:02:05.5413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tE5tyX6dn4i0ipMzs9RxXhQGXyT3zTOeOP1Bhm6uwadhzz5bdMLIOw4P2akofYeNijsz2BjLi2AKFIW1qNOOGL6IAJAXy2N0xi38MD42L40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR0101MB0869
X-Proofpoint-ORIG-GUID: DzUGibjQX-nGMlbl1OrpNOZVoQcYw3uX
X-Proofpoint-GUID: DzUGibjQX-nGMlbl1OrpNOZVoQcYw3uX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-06-30_08,2021-06-30_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=770 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 1000Base-X fiber modes to the at803x PHY driver, as
well as support for connecting a downstream SFP cage.

Robert Hancock (2):
  net: phy: at803x: add fiber support
  net: phy: at803x: Support downstream SFP cage

 drivers/net/phy/at803x.c | 122 +++++++++++++++++++++++++++++++++++----
 1 file changed, 112 insertions(+), 10 deletions(-)

-- 
2.27.0

