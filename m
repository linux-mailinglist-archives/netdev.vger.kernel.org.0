Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0380148CA0D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355915AbiALRpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:45:15 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:33102 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355883AbiALRpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:45:08 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6j92020242;
        Wed, 12 Jan 2022 12:44:43 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg598-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:44:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjX3IbLFRxXo4wD7QlTd0gyrPDvYWJMGnneO3VsI+mxRhOqE+Iu3ijzfhoJdcVdjl9nTdr1QC7gAWDkrE3H1g2f2nM0HwNTWtVPEX1hDH3/VEj3h68amou0OlRBF1vtMUYB8ozurp/F6dMLyrg8rq9AA+490z8D0zFHqHGg8Ju1X8GhfAPlZOyPlYfjaxNqFy2j/RUKwdeQDxfoX68VelIOdBF9B0qI8kxmg/UCab5ATHtNeFIO0n9RItbo0KGzH6P2nlhtoHddjpCUZLWhBM2QqnWrt4kWxIH7E5ZT6K+JdIVtIHUDtGH8n0aFTdVPn8R0s5lC3BMzkQelYCYon+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7TQCCa4ylcflm1vgGqUujRLzfobCOWe8czSdV94GTY=;
 b=FGQLKJ6Lbsz0Q/CcQUy5XKpfdcz5re4wOVUJzcRaO92fozfkk1spssY6ZuSBlJiTvkOHpXlKxTyXi80LbA6UEq0LC0/qb+4QfyVeBOC8fOsbNnBOkUbUHsnIVDjenddG1E9DnnJRYpjB46sJQSX2LzGvBUp4GyyyBtklCUUie5KCcW0XfXEz6slPIFhTDG+zTWEN9AsKubDysaym3PZrglbdgQjCeFdBUTmnjTbRO6GqAcQEZtrXp7P1L/0y31nN839pADQlZJk6L7iEilJTYLxaTQPqACtX52RwAO99Dx066T6EftwTb299lsxBKwlpnknF61eoLsgT8vX4CZqwDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7TQCCa4ylcflm1vgGqUujRLzfobCOWe8czSdV94GTY=;
 b=aFHoFVYFB5DwjnOnXBw1DDMRoLVjw/P7LwFY7VtY5Y8lTCbdpUtJC6tBWNIq+ln07EHi5UPxZIZTy8N2Ftr5PR8pfd9s193IGyT/0rYJ7n1Ms9XYegI30vhG+9GeDWLFYPj4qKNwkeZbiD7sZgmNKKp1tMibdkGV9MLwogZoxzM=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTXPR0101MB1215.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Wed, 12 Jan
 2022 17:44:41 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:44:41 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, mail@david-bauer.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 0/3] at803x fiber/SFP support
Date:   Wed, 12 Jan 2022 11:44:15 -0600
Message-Id: <20220112174418.873691-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:610:4f::39) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e4e83e7-bb76-499e-1867-08d9d5f3361c
X-MS-TrafficTypeDiagnostic: YTXPR0101MB1215:EE_
X-Microsoft-Antispam-PRVS: <YTXPR0101MB1215F7D88B6E2DC90C9253DBEC529@YTXPR0101MB1215.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t62SX8VV4wYipxBwzlTLq5AVev14xSBz5L/FkV5QekdpuZJ6J24O+He0SEqTtdiP2YpBm9XGAy08kJr7QxLX777MJrp79BCKD/L2R9Wihh1AIzx6Vchk5ExfAft4AjlSs9bNTIoM7lSOm6ZEFn9nnUN6Wj+n+eH3xq9Rq06vwFrRTv0HD7ZaerXUzBnFwCmLUjEaVGVauH5IUvKCSgw9dPk1BviHOgEf5j72w1xNmwh3oxVDKRFmyjURgmD31FKRkLpYf9DPV10O9SWKQlDXfej8yb/BRAhBM+7WlsId2sEEM+meOPeIXFIlJ2LRtw2u1htxohrQth4jBa+LrhDSCNu4Ink2IPGgAOMV95KgNsejWlZOKn43PxXgpmGadv+p4jqs/vGPq1X6sG3f+JBDC3OIDFn6LeBq9/bnB5DLXGiWDy3/OrLstcTiR8cJlAJnNKbLvt2Yq/pTL2bb0LDjkgR6z9QMd2CRbT7NJ5Vwxl1GjJcvMz+uQzhZDsCf7dA+cvJbZETW+ydEhY0ZGgoa9als8ezSesJNRuh/nnhnF7IKClR6b9Cm50i5+lmUCabX90eJLL1Xeqv76YY6GMJCZ5f4kCK6Aj0eu77zA0Ww2dkDNvixEnjtDWMvR7BodVRXHPF0AFSON6rgAGK1GcW+7CcQ5YuEHNF5ywWsucLRK4a1d8gfvUdYwSEcKwqLlOu4KJNH3hS+RIhF2+KwhzUKuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(8676002)(107886003)(66476007)(6486002)(26005)(5660300002)(8936002)(2906002)(83380400001)(6666004)(508600001)(66556008)(186003)(1076003)(66946007)(6916009)(2616005)(316002)(38350700002)(6512007)(38100700002)(4326008)(52116002)(44832011)(6506007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HjcJ2xk9Uy2JKEjubqpSmiISQorquIMp715dODCU2Tcy256GG+0ABFTo2H3g?=
 =?us-ascii?Q?fUe+OzTawz6QtiWw5qGzaj9svo+6tCYvoZbRu9DCyOuX9Y4t9PwEARAtjiq/?=
 =?us-ascii?Q?IoklEK4DTOEFQd4n/Tot5r7UPUe2THmcRLTqLgEP/bRcdkS633UVa8UAXEpL?=
 =?us-ascii?Q?UviL/ZLQDsp84sxwHFOfvvKuGAkOVjqQzwFU5xRleQ3VsVfF84WkXrN7swQJ?=
 =?us-ascii?Q?vrnrBGKh4jvNzTrXReDNkmGxU2kdqAMM305t0hKmsbUz/9+XmcM9jV7FpMhh?=
 =?us-ascii?Q?o5kN1T6AYfJfFjaUn4lgvv/yHXarnrY2h8y2U8TqsP43JzVaMR+dO3kj39hH?=
 =?us-ascii?Q?dFw3lRpYl/RQPUa9ddPQzE57MNEd7q/kjxKS8r6vYSM4gtQru3dmVyfmzhkL?=
 =?us-ascii?Q?ddX4Ki79k9YjyrJUDtoyGDal6XWH4mWZhABGmSiptmGKeVC8IZ2IryihL++j?=
 =?us-ascii?Q?dvE3QNq5IjcIHBDs42QaFFTqWvUO/xhE/BJjBS6woqAka5tTpdtyjbf0HsB9?=
 =?us-ascii?Q?/b1Aq+szKOtyyG5L+qgAx/3Z3H0L0rXzrBHgKDOpFEtTIlIj7niWPAccwOt/?=
 =?us-ascii?Q?R6hvC/gQo9u4XvSAJrNvQWdy6qsLeYniQOJVxdENqx4rSB9RJFlgp4B23k3O?=
 =?us-ascii?Q?FU7P3g8ZbuHbpn+rv6lsizpgxFV0rGV+C65WBCSQkzY9klplYW4v6/5clKz8?=
 =?us-ascii?Q?Fupv8d9t3jkL6VRUOEKrZ/TDM3hQSX4TG3xs1p7NzEl7F7328UcimodmhSV/?=
 =?us-ascii?Q?geLIQKaWjeLagELoecRszdE/XIAmxf8Lw90fpPexT0xzLljRfsNq+/S5/lvJ?=
 =?us-ascii?Q?Eudm1RfniJ9u2qJhiBWSTUAvJ/X6y5nbxUAh2FHh59GGSLYtQRlCNAmYhTsR?=
 =?us-ascii?Q?Ifr1huOfFDkHvMBz3KU1ijVbK5M57wuMeg0r9uyXffb5u46gXyUV5qLKxdm8?=
 =?us-ascii?Q?estwjyRGT2wA9BflIWLQsxFGreT6TINTbNgPT29So9mnyxSuMCvd1uaQEav/?=
 =?us-ascii?Q?1KD8YgciOhVNN69FeKrf+qDUktq6oClkLSnPclODr286aO/YAKuS+v802EpW?=
 =?us-ascii?Q?CySJsuz/CC67so8erGsknvWtZY3Cf/gk6RuRc7LsKrTXz5JBxTqvoC8IEcTg?=
 =?us-ascii?Q?X/V9HBWKLIw9QBiSL6Tcy4EGdPUXTl9yozgAXzCYNqS12ajLf3NKhieLIV3f?=
 =?us-ascii?Q?m5w722P5oUwEFx3vh3A2yJ4j8nIK6JX+L++WmECm5GtUHc40ECb0xIsdriYl?=
 =?us-ascii?Q?oeu5T641IH0nH+uc5GHGm+mIrUzRRqqpoMR8j0gG9CFCSB0GofmkrrfGYnkN?=
 =?us-ascii?Q?+pc9YkEzkOFImagA3ZkxGUTTy+IwPt2jK4pUr+2jBsm2DdrmKCC8mYBZDeL3?=
 =?us-ascii?Q?3BpchcjwAgJV1ZGBfeWxUEmUrxvP2JoMdJ8dP6/gbe5HvGrIESJpyG+ZkL/m?=
 =?us-ascii?Q?hZPh4imBqUzIkD9qZowZ8La0OhBSeV8y+4pcFIC/69kq50T5YmtQo2TwBC7Y?=
 =?us-ascii?Q?etRDS0c3XAJPQHQ7Wa0HGYZ981oRD0cAjavvC7nWuTY3sbgE9h8zApyW58CX?=
 =?us-ascii?Q?gyFOfqAldM726MFAA44VVhW9exH52J5R91pXhlCPNlV6r0L0JyyDCJqGWrf9?=
 =?us-ascii?Q?1wsc1swwQhne/5984NBF5m1+UM1kBWAn6iWfmpNReRlbIk/4hhnaWcTFcYBu?=
 =?us-ascii?Q?hlbouC9bFXEFUizlzh6VPJz96Wk=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4e83e7-bb76-499e-1867-08d9d5f3361c
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:44:41.2309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BzJediEuorU0xdLa4kYsruLUb/EFDMzDvNrCn+98aSGJTQUFNpZyWXzS6beINKTk/75jnb4NLySOEa6y9sGYd7fDwC7l/isozmBSo4O8Cyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB1215
X-Proofpoint-GUID: Vecb2r6b8hKGtyEA26jtpPxbappMklsY
X-Proofpoint-ORIG-GUID: Vecb2r6b8hKGtyEA26jtpPxbappMklsY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=708 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 1000Base-X fiber modes to the at803x PHY driver, as
well as support for connecting a downstream SFP cage.

Changes since v2:
-fixed tabs/spaces issue in one patch

Changes since v1:
-moved page selection to config_init so it is handled properly
after suspend/resume
-added explicit check for empty sfp_support bitmask

*** BLURB HERE ***

Robert Hancock (3):
  net: phy: at803x: move page selection fix to config_init
  net: phy: at803x: add fiber support
  net: phy: at803x: Support downstream SFP cage

 drivers/net/phy/at803x.c | 146 +++++++++++++++++++++++++++++++++------
 1 file changed, 126 insertions(+), 20 deletions(-)

-- 
2.31.1

