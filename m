Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2564A975F
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346590AbiBDKEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:04:12 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9564 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbiBDKEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:04:12 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2148AqYG020871;
        Fri, 4 Feb 2022 10:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=EF/LSJ28Qd1lfbTYiGKfHej1WBd9/FsvjuJkSLGFZ24=;
 b=0C38ozMTrWw508jot2BDv6roxvg4AQJuG06LdfL+YoNeG3JnuA5ocK4gnMC33dH8D3cz
 CNOWdzPkfIREh0E5dlB86l0Xghia35GofaHOwVUnuEWxxetzGUi0x0HSOTXxbEGmc8y/
 2rOZIS97FDES3poCWjv/SbkbOhPi8v3YPckDC3w6ku7MDHrDrIEZTRm9AYZ7QsBhtr3V
 onk9VamtkLRSXPIJMziIIsAd8JIiJJrsyqOEPpEUmqoF1cwgW12WkbBw2qE7/bgRt5Gd
 N7dmxgcxDmynkPdUe/3uojQZ4dMBa1wn7VZcxA296qt+2iPvPM3oc2igDDcRNrMBQUz5 MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0hfst9bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 10:03:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 214A1qMM155401;
        Fri, 4 Feb 2022 10:03:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3030.oracle.com with ESMTP id 3dvumn7wmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 10:03:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHRCGyuiAFnMTpsCBYZtS5oyNasV2v/cDp0DPChYBQEc/qbeVlA81VyOEEHRk31NSJrmRGwZwiO/W/DFod5E7/M5NRdSR3UAlEalmqLRSLlLKvi5HvDBM3g83L/QTqE7chpt4BhG5e4ox0iiI8efzkIeMxKPuzUifCMUovTaLNoFvWZJDhESuEO5k8gvYdhMxhogorLknm7zIoGHRSiyRlhhzKVn99cbjuvMdkG0R0czvWOqPKh3XOSUIEXBOG+WKoczfmkv3GxuBReo4IFIH74CfdyEAMidqJllGICsdb9N88mXTN54CwLp3hT/4+i/tAsssEu/nScjKzr5dvx2rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EF/LSJ28Qd1lfbTYiGKfHej1WBd9/FsvjuJkSLGFZ24=;
 b=Gpo5fuDccUDYJVLWv5ryQH9jOJrAvJssTqS1mPHnpZSJtnfuaAPKT/Uqh7oed0bgkenug2FCX2Wen3SBs6rX6QVw+2xnHRa00mjO/fZ96aM89ObtEHQqXGTaaiDVh62DBmdN8UmAlxWoURDqX+BfWVEt6P8Of5GqasN8sX+qq6S85r0VDhotdTJO69ilcxMNZoWDonNcY7/Nkv7DspEqJlKP5A+x3/UgJjVLkY45RTHuRKRReYuXLUgNJJY5QhqXMWE80nSEnjTXTbjOneJWE1wXbcJbFLO0B4aDAkgu3ilHOPLW3IuCpTfxHt2rc/a8a1wV1iYMcLtXcSBvcWTFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EF/LSJ28Qd1lfbTYiGKfHej1WBd9/FsvjuJkSLGFZ24=;
 b=txPA9ssLuqDxZTXvDE5prH2Do2ia04y3WEjHuoAVxZ3jXm0+KqPlVfAsaiPGgt3aMXJdb856mh0eUc8G0l1/qVsr2nHlsujp3rBpN3is9icEkDzBsmtexWEI9LqMCXv+tpf0U2DAs01ulPJ6Je+6VvFsZ/nrmSCqDayYk/W7fxM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4482.namprd10.prod.outlook.com
 (2603:10b6:303:99::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Fri, 4 Feb
 2022 10:03:55 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.023; Fri, 4 Feb 2022
 10:03:55 +0000
Date:   Fri, 4 Feb 2022 13:03:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>, Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: dsa: qca8k: check correct variable in
 qca8k_phy_eth_command()
Message-ID: <20220204100336.GA12539@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0181.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db709dbf-f66a-4549-1850-08d9e7c5a71c
X-MS-TrafficTypeDiagnostic: CO1PR10MB4482:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB44823929AF0523E1187B998D8E299@CO1PR10MB4482.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WpcAauzqTjH7JKUD49byCWznIpnnu0u/WpgLo3zdMSdaKZDJ9pbqmomGeI/vDmPMXtwiWm5j13exhDR7hOcwVE88LB87FCxeTDpxkEWAJjgcH7Q0DGALtjCVD1ZCCWHdG3e6PKhRJIQnBeCIpRtLxtfXpTuQ7YerrvWvXoiCDP56M0W3FMeho6kFCqSYy76zJJjgcCUIqYs64oHjhblYf8x4ILUgo47PQb5qahTwyQMHeeomTXqIUTOkhp1vCl5HdEo7Zvg0cL5SWCfMleFXnVHrYE7O6A+ZuznkA1n7psXZrCcSMjdA8qizXfF+Y5xE7xFARRC+PwO1Eh4J+IG2Nnqc9csTTjyLlIv9d33w0oUOeVAa8hPJqqAGdpxugYVrrxdF1z6e9RjCXm/tPIwRW2B2pLAzYWrK8Fg/h5G8wLkdqofd92qOhds6n17pNNb68gXimvCr/OZZKEcNg4sRNqEQECieJ6JbLBB6wnS5x8fhESzpazlxN4ghU4pMDGNuROsROfRk6rof+IYPR9decz/pO4Ak4GPt/2+O1+td1G2iLHlXeoggwUWoAaOhBNW7SdiqttO+dP98KWqUE2NSuhq7RxGyH8hJbEAYD+0NtiSJSC3a9l23FsAvq4M+LlDTnUSvmJLY1KW0c3i2DGLX/MCotIa187rtsLbmsXpQ+5RsqDm9puvkiyxxLtqhChekFn40D9nzivf1v2JI7GVjWVsnM7HuJ7EwMsYnf7n+9VEzjwW2gLPaJbC4MtZda2Uq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(38350700002)(4744005)(44832011)(2906002)(5660300002)(66476007)(66556008)(83380400001)(8676002)(8936002)(4326008)(26005)(186003)(6486002)(316002)(66946007)(1076003)(33716001)(86362001)(33656002)(508600001)(110136005)(52116002)(9686003)(6666004)(6512007)(6506007)(54906003)(5716014)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MqmPY1vNQohF6lLRwLjabK75spaG0yRKxoD4loJxEldAWK1dNxMPIenOmN+I?=
 =?us-ascii?Q?Owj2u3pUqmnU+FV/WfEQIeBN6keV8vbfi00AqeKTNG0iRmO6zIJGyPqC/LV8?=
 =?us-ascii?Q?GPArEK4X57MQ+oC7a6j8v+pvzlUbSqjf4hDiAG6LXeeKyFVwQW6oy8oTjxdE?=
 =?us-ascii?Q?lPRt4lBDmb/yYP1qX48D6h5QkMe9XVMBGdvHNqZD7ofBmUmGX9FoRFq7kyCW?=
 =?us-ascii?Q?LoAIOnaGjUdmpukXkOsVmlVrcoRBM+xy9Co3oUp80r2XJnaM271YPRBUMrt2?=
 =?us-ascii?Q?HBMw0y/r37bmmO7C1EqAzVavcT3GtWMjCAlg+p7XOByE9GkEaIMe979wXrK9?=
 =?us-ascii?Q?pXuedi0xnjbotdxoKVN4CapR4paqXG/cY50+bdV/3UN8GSjLKD2mlvs2rRE3?=
 =?us-ascii?Q?L1OFsuVCLjKHB2up+lm3/7StFpmdAXgnWjRJ34yzfG7JWq+qygXxDXVbUAU4?=
 =?us-ascii?Q?iYV/Np95gvqztP2votHtSVy8yQ27V7QyKbMxb1bI5KUYEu9J5BjoW/oZidzZ?=
 =?us-ascii?Q?od+vXMJrHagnsZ0YSqXPTFOki94y7e8s9F8xLO+f8YXBPkOH5SJoDbPtzNs/?=
 =?us-ascii?Q?+X2/FdAeNmKNYxwqy4B333dAiC2H5OGnrk4324FV1DSBmGReNOXh4h4n7oML?=
 =?us-ascii?Q?naK7ZnKUH4BVABqnXPlERnh9lpFDfV6F6He3NFf0dpTpBdEsLLtVfTwwYZIE?=
 =?us-ascii?Q?emXpMBwTN07tLjUDCCvGCZi7xC4EjJnrLcfuNW/XdaFoKzBqiXODo9D6FTWe?=
 =?us-ascii?Q?R8A5fbMpZC3bk9Z+hY33pNiAZ4AX4wGFGpJ9NfQQ48ZC3bIMK4G+DiND2Taz?=
 =?us-ascii?Q?y+gmh9FQtmrFn6eHAEPCkoWLxqm7P1cZWr0oLOQvJblmvrZix1rCi4PLc8JF?=
 =?us-ascii?Q?fLjdQ0cNP1W9vo6L+ARYFRLy9O00ROBajp/BCio2/AWHmr7EahFP+yakBOlI?=
 =?us-ascii?Q?ZTWabmnuc5W/d13sIbEq2Kp76zczs3/ivyiJCbZfjvVVgy9fgjQPqUQ0bZUE?=
 =?us-ascii?Q?eJtq7/Sb+pIqBfIVFPr/8DHi2i2zbgq/rArG9l2MqUqjqqOC4nwa9nX66xk4?=
 =?us-ascii?Q?zWMtgQbJBfbEZpYSs+3tqVNFAnnvlB3imVq1zZGmNxoG9rk9kE2CTDpo83nE?=
 =?us-ascii?Q?6ziOzNI3aj/E2ATuw8BmEcWDVZvXL9gDL9maSO8GgGxmRmBpY+Qhpd65jSA3?=
 =?us-ascii?Q?ADml6AGfBel8+kSGdqiwfwLc6tc6bh5KrMshlGxyrx5JFJvS2ZvmmtneQ3bx?=
 =?us-ascii?Q?P4pSLK+W7E3cT0u4a3lVsnVE29TJrMW9Mhibj6QnUXr1qfY/893OrwMPRHoq?=
 =?us-ascii?Q?c5eDFzD+VIlJacoWO1pzNYIx8Wr/HSvuaJvwhgTw1OQzfl24B+5BQSqpT9AG?=
 =?us-ascii?Q?Ve3NxnQHmYwFwQECYCXQ+e6G2kPJL2xcSzyuV+ve5DJuiFKjTRMBSKX+dPB9?=
 =?us-ascii?Q?5Kssp9z6wOcqz3xZkcrVgLqJ5yj0S7tSNqz2HZ7LHiwKgmEeQyMilaYOcw8N?=
 =?us-ascii?Q?1Iqo5H6CDEuNSbELZzQ0n+Y3fR2GimcB6opoXghN17QCuPxLk9yDXGQxoWB1?=
 =?us-ascii?Q?i0LUqLXXAUN7coCT7nHAbIqEKXUGhyn1uKPtZc5SnZLm+49lguKyzm4H9FBo?=
 =?us-ascii?Q?qMtvs8v8RciOf7SK1WgMlJieutnuxBIW9wP3T5X3ifqxKWqwz4MEpbD52eji?=
 =?us-ascii?Q?yHE5IUjQGariNemJdmcWVMq4NDA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db709dbf-f66a-4549-1850-08d9e7c5a71c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 10:03:54.9408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i26TH7tWSgSEpVuHC/9chOLMcek+LGQvjnvYnLlrOJffM98oTtqjJxQ5/083TX6pjA0UOUobtL0ggGUIOOdkWdXOxgbfB8lSp9Aeh1ld/Jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4482
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202040054
X-Proofpoint-GUID: 3teDFN1Baujreb9cWuz2PCROsVYp5WY4
X-Proofpoint-ORIG-GUID: 3teDFN1Baujreb9cWuz2PCROsVYp5WY4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a copy and paste bug.  It was supposed to check "clear_skb"
instead of "write_skb".

Fixes: 2cd548566384 ("net: dsa: qca8k: add support for phy read/write with mgmt Ethernet")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 52ec2800dd89..35bb568b1df5 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1018,7 +1018,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL, &clear_val,
 					    QCA8K_ETHERNET_PHY_PRIORITY, sizeof(clear_val));
-	if (!write_skb) {
+	if (!clear_skb) {
 		ret = -ENOMEM;
 		goto err_clear_skb;
 	}
-- 
2.20.1

