Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A382948B9B5
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiAKVey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:34:54 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:36885 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245492AbiAKVem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:34:42 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BCxNPm017415;
        Tue, 11 Jan 2022 16:14:32 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2055.outbound.protection.outlook.com [104.47.61.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs97yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:14:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrSvmFnQe4sf8/R3FWoUEEOVnnhW+D6+FZDLiyIyvNVzWjxk8Mpq6TUFhGNbfW7E47O+GMayxB4n8JTb/vFS4JPynZ/eHB65Pa2gl2G5l6xGjwtXvfZlH2xLoZiyshQxEybetKLEznHHHnRr3iuSx2mJvMCUD9BjijSsaYY8djUVY7giIFHiQBTWAyLCPvt6gffPDeBlrvAckYAbYV2Eod/pN2TiQDc/D+FLHginuFhFcxjdB1aEIpRbDBj+jc26dLPlat7+IxjCLgp/OqpUYRJDWAlPmBhWxzFBEd2Uwv5CTc0arf8VDjlyxyobP1P5/RH2RATur7cgGnVXz621fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7l1BjpEmKjjb01dQCnUrTbR43RSa+9MhabIjNqzQ7F8=;
 b=LRzNh3MyxiHAT8IQkqjHD5TirvmtUNYqqKTXOcqzFlqUlgbtomN51KI530eNJcQGGfyu8wbWUvCgbIZE9JO5k1TUoPCqRtpsaTe21EscGSQjonCSL6T+DcfPfIqYef6Y4p0pXjQ+rHMM8ALockTsFS+Z1n1NGY+oZKe6PVC893GZMOD3zLYhHGtG981BEldwtKM3BDsLmwtl8nU4HCv41P//nkY8Sbg4dTMHoNcSl8fK2CEVDuwY6EgSZYVynA1fEknm8YPZRmdd4TaWTjGv+P0uvjDFGuU/TdfRBmQiLpUobhsSaa9CD7qX8M/ghkhkEMmDmrrdaDEGBlF06/CooA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7l1BjpEmKjjb01dQCnUrTbR43RSa+9MhabIjNqzQ7F8=;
 b=QFYAbvAUrIjYM/grYDg3gCtqKTvc4w84/0DOIoLpKnr/4U1VvnP39+8VZrbiPcDN3qHGvMD/f+ujXRZUD73UXtoEmx8TgnJD5pjoyl5rQQCxvYpVISs+FiyKQGjLWXB+Niua6UaEdXem3X34Ln9ihtzYW0go52i/9m6xfOawr9s=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Tue, 11 Jan
 2022 21:14:30 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:14:30 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net 4/7] net: axienet: Fix TX ring slot available check
Date:   Tue, 11 Jan 2022 15:13:55 -0600
Message-Id: <20220111211358.2699350-5-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220111211358.2699350-1-robert.hancock@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:610:5b::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67468009-5c23-461a-56f9-08d9d5475b26
X-MS-TrafficTypeDiagnostic: YT3PR01MB9218:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB9218BB5B27A7ABBE31D9E80AEC519@YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FTwNYgFvsyFq5maqf4Ogqkz5z5wM842Z+V6ezYomNfaytAYK4HBXCmQnQwk5z5e7y04fp8AV/GWxiRegNsuRh2ds/2pA7/qbMfbWvbSjFfrZb1LBUc8iLkK7AjIDGO4F+Eze6OdcNSUg33XvT/WhNM82iUN5EOPmtqo/HchXJg78UEAQsrtT7PlWcpW0Cw8b7XviRWVHRuREk9uaE7CccaMUPRFyl376vDSXVjTtByfXrfuj7yBpjWL6xQL7SKQiy+CWn2VY7CsCNi3lMWGBptKsV5ofnptnnAkZb1LOPeCTbtc4ZNT4K7oJLmRpSNRHihiFPs/Eg+lKI+WQ0TS7JO4J0EWqiDQhUFA5TdhCRQ+aW7Y3xZM6+yXa2gddEiwIGwf0ylpR0aAY+ir9NG17julwqF0a83mlYtEbeAl8sz0pFntfpZJd7j5326LEGmqqzrTRmj4FmMIJqz3G2LrLn+WsXJcXKWwolVX4UBmeB93rQ1pCeBxjIbsz/kelVCEBSoUzsR9M1g9reByeAG0Y8NUZ8A56fFA3RqXAv2LFezsBoeQb1ZZdmpDd4elRu/JgaS5eq5zMLRgZnSz3ei1EYiBPmR2qF1uazfasRtrFE7K81p4NfMdExzhKi1cF2N0hwcTQNdUS5d11lJ3zfPU7035gCno2vynZQuJf+HcmQk9HPBxo8P5e4uCXF+O6u7Ig3Wl1/5CtjrvcgR0XGVjzww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(52116002)(6506007)(86362001)(38100700002)(26005)(186003)(44832011)(2616005)(8676002)(2906002)(1076003)(6512007)(38350700002)(36756003)(316002)(8936002)(6666004)(4326008)(508600001)(5660300002)(6916009)(107886003)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4gJSiRTsEmd0UuZBZ0C/Nd8WWqMVU7mg7DSwK3k3i5k+YJ8EIhOmYcDhLs02?=
 =?us-ascii?Q?9Sr4SCjXXHPnaxqkw6zy2N+CHNZFvaWkvdXwF1x8bKrzzyNUIA2zQJJ5U30B?=
 =?us-ascii?Q?5AXunxxikX9tRUIkw+JURniKmf168SkDs+beVXPbeav7gOaPWwSoezg0nhME?=
 =?us-ascii?Q?uuLp0R1JHBzhBW3sJh8/R6vm71flhElSsdF/Ctqkm60YH4efYEI/9txJyLPG?=
 =?us-ascii?Q?U4ylu3wzjE9cXiQtv496RDEnMClnpGMztccQnYFEjTafJuzWHXxaq+7df+IZ?=
 =?us-ascii?Q?v4fn8Paau7pdm8L32QnjqMhhou/xtyGt7SNUWeAEglh9nbjJip6hkmwxxj0Q?=
 =?us-ascii?Q?3DPNkcWhc5I7NFj6sIA/CGqvZmW6jkxj72Z2iSxLosl+5ZE5Ad4sLTJf1LqR?=
 =?us-ascii?Q?aoOrn9pbm0CyFuePOH4e7nl9eJOuzyvQVsPUb3dvA0xSZIS0Ii7fzR503p0s?=
 =?us-ascii?Q?YltGSD/UVXO2AfjN8+w+sj59p9LP96SQwWo8NKjWvJnGehy3dbJtqR2GStkl?=
 =?us-ascii?Q?tWzQIU/S//Gal7vBgrMol+GGJXKtDQM+tL31T7Y0N16xvkiaEDMdEHm+WIrL?=
 =?us-ascii?Q?KP/GD9KhjH1o883GA7TjLOQ3S7Ssi0FvbBD3fP2QsCDU1EZFal7LASepyOr5?=
 =?us-ascii?Q?59frQKSzsf132voUnGZHU98mKdvMQynFuTbs80cTcMjGHot8ZMx7yUa4p08O?=
 =?us-ascii?Q?pCVAQFyYJOmSuy/ZMOAC5YNsSNfBYK1agNT/Jj8NuC/mIC6677R3BT9WWL+/?=
 =?us-ascii?Q?uWgpPf3Rh2pbF5vUh8Oro7Ao0NuznTrZUrzWXVhqktTqOIcQ6gEvCr9IMV7X?=
 =?us-ascii?Q?DbEhQ33o1NDXRrz9LLE+mmjRFVx0IkgUIxTrSuoI1SSQXELE/g6tlaD2XdJB?=
 =?us-ascii?Q?6NDPYq0RzGdZEpjv+CJJ7o6wr36kq4kXf3DZZy5KgtJNVdD7DQ2DvtZfGQdK?=
 =?us-ascii?Q?dVa8zS+bjtRTFzuZA3rNw11Xn1PP76HdELGP8wyVE3fKMoryxLO0EWAciN77?=
 =?us-ascii?Q?aJcu114rsogXlMohTlkeVbtF99DNBbksjs9Px69IirLD8bPHDFOIHZ3eNIv2?=
 =?us-ascii?Q?3wTqbE6uqaf069yvHILmvnxHLhXgGifi9qNaVbbIpw23qCzlFiBycYfB1eJY?=
 =?us-ascii?Q?LfPEyypdU0RuBjTIN7ub/OOFeuGQSOpIp95PIU0eiY5DChqIqzDRF9OK26cF?=
 =?us-ascii?Q?gMMUFy/PCsTq36rMtwTDhrK33hw1phFTCbe+0qgByyI0IXkysMVAFKZhjvDn?=
 =?us-ascii?Q?LUEFAA8ewpriyRLksTPhz4qyusOTQ+8NMKMTEq/V0yP9sbAX04nTFk71eGmt?=
 =?us-ascii?Q?VmVmpo9VQDZ/Ec1vzAzJ040YWr7lupoOHws/zZIrhi5s89ObFQLfvs6Z3esz?=
 =?us-ascii?Q?PNdmimXYd8OfUApOKBDLiNKc8TAELnCD3z1XBCqFjVc620sCvLzkbRGFXMqt?=
 =?us-ascii?Q?OP9QkxfnjoYHS0R5mdEpOhApmQ/d3TS1YjzlE9ZDxaq9x+4QhbpwInYS6jRF?=
 =?us-ascii?Q?u5szKzxH2vNYCYYm/TbSNQUpYVno5zyhaWkcBkgYkkGj5bYSRpbTQ82BvCdR?=
 =?us-ascii?Q?afj/S58PoGxjlw7eQN1Uzp76KHOOeAn/V7Q+n9e8x4hCrZmywoKhqSFjSiU3?=
 =?us-ascii?Q?EXclEMuuKWzUa/rrxGpJFQyDaMkfbWJWlL0yfFDjCtaV/IYBgVgX/RzbVsU0?=
 =?us-ascii?Q?uLtDWQ=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67468009-5c23-461a-56f9-08d9d5475b26
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:14:29.9831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CEd2d4vVYSpGF2ocNe8C7nR2BBb5Z1aCsdtjKKCVpXEtXLLMt0eSyqduEg9xgx6AJ/Mg4kHSChTjnj5pkoLbWNEHalUP1dUWj/okFL3UZaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9218
X-Proofpoint-ORIG-GUID: TRyAKUHtD7JWCetOCEM1J-9voBQileAY
X-Proofpoint-GUID: TRyAKUHtD7JWCetOCEM1J-9voBQileAY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=651 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for whether a TX ring slot was available was incorrect,
since a slot which had been loaded with transmit data but the device had
not started transmitting would be treated as available, potentially
causing non-transmitted slots to be overwritten. The control field in
the descriptor should be checked, rather than the status field (which may
only be updated when the device completes the entry).

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 8a60219d3bfb..ee8d656200b8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -643,7 +643,6 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			dev_consume_skb_irq(cur_p->skb);
 
-		cur_p->cntrl = 0;
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
@@ -651,6 +650,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		cur_p->skb = NULL;
 		/* ensure our transmit path and device don't prematurely see status cleared */
 		wmb();
+		cur_p->cntrl = 0;
 		cur_p->status = 0;
 
 		if (sizep)
@@ -713,7 +713,7 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	/* Ensure we see all descriptor updates from device or TX IRQ path */
 	rmb();
 	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
-	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
+	if (cur_p->cntrl)
 		return NETDEV_TX_BUSY;
 	return 0;
 }
-- 
2.31.1

