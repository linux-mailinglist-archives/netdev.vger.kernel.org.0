Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B6649B9C3
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239276AbiAYRI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:08:59 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:15703 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237757AbiAYRFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:05:52 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PBfHRX020266;
        Tue, 25 Jan 2022 12:05:46 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2052.outbound.protection.outlook.com [104.47.61.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsyrhrjan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:05:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFzrwuDRf5m5YioeB8SBKaJexwex7jm4gJXf9DH3m6mS9zrpsQ+tiCEH/cq/RqPYKNrFOvVj0xHAbfDYEZsZx6WwBXn5j1wFL4Tdj2qlGJseCdqV0ya5Qr1j4VR/2zawzXR98MjnF+YkFOdcEbbQJNbmBoWHnSMWCbMH+8OWFIFvAk4bVmqhgLCAji//hKJl4Or/wboFH0rgQcWvaeq12eVcZTn6aiXUz7aTYdEWZ2nkOR9B4gMsx745B3AuTIEXLf+FAadvRgHtJ+CqkvPzCOzT+ucnaWlcg8Jjpgxs8PmlBpNBfOKWY4nT25OnjlQ20xFp0WJfwN4wgosxE1gu5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJhig4QxQukmfoHGYB1mC3x5b2qDzjef0kr5wPLyrSI=;
 b=anSXbqUaN4d85ZwssKJblvOoJtDMjlHYVJDBQDiHue7+oxOPSlFnTqEVej/NP21o3wrX0GvEhxY8rBzvnkG//aNTSLE1qAoYuUUt1aNaXgQz/DKs4rlSi3DEEQhwASXAmT7u/jFLLUaqJaYwKrO90qki+Sk5KBKjTriwQ9IpBaI1DWBIaPmfrTJFmgd/CkP45BPkr+mpeyhGlVXARFr7dbpS5eBb/Kstgari+gVRgJ2ue1SwfO5s5AyrGnL4U6Mqy1UpUGtdXh/Qqs8BcmfoYuNWpxU3YYw9m1FtzYiVx+R71h+JkKbywR/STMVadn8Qj8NU70DTXsy+sSLP6OB1XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJhig4QxQukmfoHGYB1mC3x5b2qDzjef0kr5wPLyrSI=;
 b=m2+KfgKqqUXP+ylpUzqOJrkGsHDVrnNtkCf9gCyky+53RBfICKwuhtDLFkZuvUk4WRwOcbDy65YQs0Erp5sZjnpp69xLTydMNWzDZc6OivEGqMPHVt/qeGNj4AnUOrJshKfs3nGYAI1+Y0c8VaWweSespMNkS7f+Qad1aIhI3G4=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTXPR0101MB1838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 17:05:44 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 17:05:44 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 0/3] Cadence MACB/GEM support for ZynqMP SGMII
Date:   Tue, 25 Jan 2022 11:05:30 -0600
Message-Id: <20220125170533.256468-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR21CA0031.namprd21.prod.outlook.com
 (2603:10b6:300:129::17) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a319bdd9-e294-423c-7793-08d9e024ecd0
X-MS-TrafficTypeDiagnostic: YTXPR0101MB1838:EE_
X-Microsoft-Antispam-PRVS: <YTXPR0101MB1838727D29065B17F304B2E3EC5F9@YTXPR0101MB1838.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sbI58VVR79/3yh8DY2+pwXSj9aLaRELXOgfZmTFjIWxv+1U/xS9Wwq9EmGztUVxz075XmDD4srO7Ps5F3rFVLAqbg4sUeQLvBJ46uWlXSJel5RzLIULFvO1o76TNaVRfJdVh2EHtJ4MOJ9nawcdNZAMCxUsMUPDM0mjpVGSEmBOa5GtKawCVkdJsJ9GCaITPTU1aT8U5m3+2aLqxAnh3wMNGRpFQOPO33LXoKQt9PrLs00ujztMXMgIRu4JK5eZqS07fxsnA4V3sn92WdaBHqUrU/flj0ieSycNMG6E3o6WuMJOW/N4NyurN7nimIbGwYUniU7Q847J6meuV/mFgLj4HOvMaGADMaQ2h/aOax0UGwcMfB/zJdKAb0ON0Ahrr21LmpY1u8Y6XX4ZJz0OmPU2AOJ/b0AIRRMDe18LQFIEd3lukMQYliE0N7sLDuSjF4Uuou0FMy9gonRgFn7D6M+NugMLFnvPh4dRPVWs/CUB5fSLFWrAvZsiqeMuPZ8AwRlgKB3StCORrL1HjwfPh26BXPNCPShaRcGyWiX/2JhmDIogB1k6smeIGdQ4+S6LbJEZy+gK/rSRt72dizTMNuNexscBNP+j9bWNA2BfYoUjYX6AmC02qt+jAF1yl0jHi1kC4//mUeotPqQtKqyUjX/IJynTxn9jxVglspsvousQPPcfEl/6x5fejVgJeFvLyprNV4/5mzY3tJQRVz/AP5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(1076003)(186003)(2616005)(26005)(107886003)(38100700002)(66946007)(66556008)(2906002)(8676002)(66476007)(4744005)(5660300002)(36756003)(8936002)(4326008)(44832011)(86362001)(52116002)(316002)(6506007)(6512007)(6666004)(508600001)(6916009)(83380400001)(6486002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vYKH4U3jh6HIB+y0K87O/oVky9UbUIkPSq8W3WcPB5llQD/k22n0a5WypVNs?=
 =?us-ascii?Q?HErYUi4DNC5O15/lcY28+24D8WcPtp6uYcN8y+UwWD25ZhyH/56Svso12QWI?=
 =?us-ascii?Q?2n1IIdsJibjqvlodvaDkXsDOmaeUEcfikNRSKmh2+1tX9YTFCC3mx1yIlMFv?=
 =?us-ascii?Q?F7Oe+kxYERl3nDlYFLRrIPEl4nL7z0W6yQOkPD/fTNrpZ96jZ3Z0Ni6/NBcy?=
 =?us-ascii?Q?H3uW7FMY5Vx9egXSbi8ohXooTcyUZ3xT+BuHfP6pYCLKKbKYWpzK3hIh6u2C?=
 =?us-ascii?Q?9EX7KZx4xeNk3zohYi4xJi+PAp1WM7bX2f9tRwxTH4Cbeue3slsk/wtcPiJg?=
 =?us-ascii?Q?mDSO6nxz4D+ez6kw6mn/tCCqdOFmB0l+ROEff36y95Sq+hS80x6HL0WihS4h?=
 =?us-ascii?Q?a0tp5lJdMFn+Yp0UTCYubl3w3Cs1j6EtaFtppsuCojnnOC6gE5wLa76uERSt?=
 =?us-ascii?Q?04JEUmbSkVQ45noTl8UcTU4V/01q1vwjcKnoJ/PMOwLR1X22hGuVLnxDI+5J?=
 =?us-ascii?Q?QLy3HOeoJWoAuBfgToRCxiRHYD3bPjTK9kZHxHDAk9yIUmV+RfyhaFlGNpyG?=
 =?us-ascii?Q?ubHdWN9puKmK29GOoEXV/AIrNkAO7UCDxmzQ1M70gf28V7xwpQ8veeqOqTan?=
 =?us-ascii?Q?2mQwBGnpmuz9EKfAz6nW5VVgJS296bi3c3ObL3PfHuqg9Bi5jKup3QJmMU1S?=
 =?us-ascii?Q?RNm6FIDSAf+IL1boGrGqTyhq46B1qtY4/VWf2ZhuRBc8dAVpG9NFACDadUNz?=
 =?us-ascii?Q?RNbym85tTo43vupRPzvYOcbUBbh9bITFZoeOPMccv/uPZgKd2xYdA5/VeWRD?=
 =?us-ascii?Q?xFHvzbPHiuBBfXZ+0DGTiYd/w35lefHHeTggbc204tUvuFwB/SqDgIyxF2qk?=
 =?us-ascii?Q?5xieS4aeBMiJ9oDacTdoNdw05kODU5R/xHnYO5bVm9LrolN53JvcDMtZDaUX?=
 =?us-ascii?Q?L7RiymrMIwEfpV32wbwP7X3wwYMNPs48+n8zr9xAEL/l23eA9uT9nh5EBpPP?=
 =?us-ascii?Q?rb6JXEqaQjI73yRImcmtzvyKyzuoi1MXENd84g+w+1IUMxk2K8GK54c6FxJk?=
 =?us-ascii?Q?AGAncHgwpXo4rk5mZrF4Wypc5NjqUtnT4N65BTXScWvO0uzJxbK+d8pFQ2w9?=
 =?us-ascii?Q?sQAQLBqgBcfZZKAG5iXj25tvgcSdxllQOVMKpv4v4WXC/B3JxQbv4lfxgN8S?=
 =?us-ascii?Q?U1EtlPhvMbE+XYVFDh12dT6JK2bBuBRB7EsHqhQYlRRN9X0CVbh7hXH6gobv?=
 =?us-ascii?Q?fKGLpwQ4va3wWuUKWLb9t9ZRkA/v/XFDsJczmCoOwcQJsnhfn/WMlCB+xOPB?=
 =?us-ascii?Q?gShLDkSUqCIlPgvHoRQ+2mRqJXRVoxAgVukCz6wk1hbKbvGCdcWbYJTnC6Uc?=
 =?us-ascii?Q?1U/LLryZQfFrcERF2IyB3N55TQA2E+zpmO/u4Pel8UbaY/obP3lybfPxja9v?=
 =?us-ascii?Q?EVP7vQo55wmu8CMrLGRPqm4b5YZS19jyu8kOrWtcPaHTK+YH2ngvXJmUrg2e?=
 =?us-ascii?Q?M7AY4tCFpqBfksusWOsBPbp0ejzzYPyH7XEkDdcIhkkXSCCkREPd2jMJKIpo?=
 =?us-ascii?Q?NbpVfW4ua0t+7UhZvlO7ivONrbjURJtar8yT7DtPpqV3VkZJJN4341l+329S?=
 =?us-ascii?Q?ezpWBm8RyKwx+lpnnCQF85qb4ixpCfOv5eC3Q0HgyCpunH7XTh089LHkX5Wa?=
 =?us-ascii?Q?swFvB3CC+K+tiY5YPLqY/MppA4U=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a319bdd9-e294-423c-7793-08d9e024ecd0
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 17:05:44.8040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LkR3h6nHc0HF7LV/bb5kQd//4WBbY7dvqnwgwR84UrBopF3VybiSyCixRlDfgTJtxEWKJSsdmG5sS0Rh96bF6cTDCisdXNvDco+A+Y7PyKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB1838
X-Proofpoint-ORIG-GUID: MLMCHeYvZxgQGs_KlhrUCfJIAozRPWac
X-Proofpoint-GUID: MLMCHeYvZxgQGs_KlhrUCfJIAozRPWac
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=712 clxscore=1015
 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes to allow SGMII mode to work properly in the GEM driver on the
Xilinx ZynqMP platform.

Changes since v1:
-changed order of controller reset and PHY init as per suggestion
-switched device reset to be optional
-updated bindings doc patch for switch to YAML

Robert Hancock (3):
  dt-bindings: net: cdns,macb: added generic PHY and reset mappings for
    ZynqMP
  net: macb: Added ZynqMP-specific initialization
  arm64: dts: zynqmp: Added GEM reset definitions

 .../devicetree/bindings/net/cdns,macb.yaml    | 46 ++++++++++++++++++
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi        |  8 ++++
 drivers/net/ethernet/cadence/macb_main.c      | 48 ++++++++++++++++++-
 3 files changed, 101 insertions(+), 1 deletion(-)

-- 
2.31.1

