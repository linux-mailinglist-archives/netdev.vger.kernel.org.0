Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4367045B4BA
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 07:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239430AbhKXHAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 02:00:10 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54494 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhKXHAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 02:00:08 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AO6oCuc017974;
        Wed, 24 Nov 2021 06:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=aHA1nMl76NjBrQnZLWM9YoPmzD+1w5GWU4qzBNg8tJI=;
 b=JEn0mSYO62lIAdNMfBo+qteg2DBoGft+sMpLqzvxMo4W6L2Bhn4k7lNzRlGC5ujUcwi6
 eI4z0p91Ctmur1mNuUEq8DFZj6XIry2XjzLAGjat3IvkzhxwxA9kgMN4PbsDiaONLp9p
 34FLCaxjav5GCiypA3GARZNK5YFeWsBT4HtSvQDjV3r3XFIGlT8AnZI8wsFKW2k4oePf
 qbYVJduiTgxb1jibHZAb1uvu9dY5Wl8Uajw3E19OAiNuqOJoaIJ1s6z38uXYH038e0oM
 Rqjr0hlskDlvGCReMPEDfxSWKW+h0nACPkkUwHnk/CQ0DmDiUJ8IiSd4X+lsHtuq4HEC LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg305e7yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 06:56:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AO6uiXo148641;
        Wed, 24 Nov 2021 06:56:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3cep50y4an-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 06:56:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHMu4KBB0Q0xky7O1cbtamLNHUWIyyek7UGrsTWSBIO60IzFTig9Ugj0f+R6TZX9Lb8M2S2tJCMTaW/PFFTDrVLXoLFABgXoqUyFVAdbN/lJtgJOTSoBMGAZ0s/iGHQdav50sozrhBak/BkTHNwpjp/6eSThQFuMR+rMJqaPfITPUiopTPpanNT/9W3rpEC9beCR3ypNuaSvowVif7qq8xQUGS+wyKcz3Msqfh0mEhsMaBgx8SO5fMjRN7s27v6klPJoiygW8i2yl8FiGpRSzgldG/xd0Ai5GOJr0O5nPHUoJ6MrzUI9XivVyOjS4+jCiDpwEBzFZeCRo1lf+ronrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHA1nMl76NjBrQnZLWM9YoPmzD+1w5GWU4qzBNg8tJI=;
 b=QMEdTLj3J9xeHGJhJMMYn7/70o+6H4j4FD/eUeT1yereMKpM875davijN+b7mfuDvDrTtdYcGzIqTDO2JDVLR/slfO7RBgHLvsN2h+4HdhHXBCU7uo6SL27UbbAClSykfcBZdttvjI7WkHPpYuGfdVMUaXQNFKAh75k2fbrc/rAsX8rD+EjcCWaVYB+7W7FfjmPQP3//IwHcBWIOqHECNbw6fql8scOZcgrGmueGw6oZcXo4Wj4x9lsAKdjKUISaCYlrU49khbmZxcD10IF/PvKQDvwNTX0aa7ykhhsly+0BQOliRdX7aqPgeT1/EqixKYELff6LUwyEhSUgx1HA9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHA1nMl76NjBrQnZLWM9YoPmzD+1w5GWU4qzBNg8tJI=;
 b=sSlOVrpZ/bAmWdPWpmwXMzt0A+rMg6fpWcy549VaYmOgV0GPIW0+scrPRkoLdwJYg3VsO/skuI7ByAXmFlQ2liFUWMSLFYHBVoVWUVHeWzWJhh5cstjf92CH3VovhRoFiEcMn7XOBnj8fAsG5hAd2diKbgap7p7a8v3KlYTqvGU=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR10MB1637.namprd10.prod.outlook.com
 (2603:10b6:910:8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 24 Nov
 2021 06:56:34 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e5e3:725b:4bb:7809]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e5e3:725b:4bb:7809%5]) with mapi id 15.20.4713.025; Wed, 24 Nov 2021
 06:56:34 +0000
Date:   Wed, 24 Nov 2021 09:56:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Markus Plessing <plessing@ems-wuensche.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net] can: sja1000: fix use after free in
 ems_pcmcia_add_card()
Message-ID: <20211124065618.GA3970@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0143.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::22) To CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0143.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Wed, 24 Nov 2021 06:56:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59c34cb2-dcc3-4130-56d2-08d9af178d59
X-MS-TrafficTypeDiagnostic: CY4PR10MB1637:
X-Microsoft-Antispam-PRVS: <CY4PR10MB16377612F347B74F244282DA8E619@CY4PR10MB1637.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sb9UTSXzOUzG4h2gPWIQOx3YnbYVPppNOWc66MI8L8iUBkMKaSEjPDsdjskpoVBfPoQ5DsQGeI2FPWsjboKXFXv62U1n5Py7/2EaBOlkWrmdnTxhdTDwC3Z8AXsywOe/9A2ECsM5lvVm900XVWtZ7ADlClafSYl+tHOlzy3wWMb7GIabylZMu0hRKtcu78M6hTBdkrrh72DTGYqqZ9Lx37yzNFw+SU1nOYf2inKTF0Pmzk8q2RCwZnVZ3I9rPxK6yHP8TI/c5FXMi7BdiJ7+Ep+y3nX5/x+0l/opshoYhD8+QtHjZe9bJunB+P5Vo1eNKwK3hKAg9ybo5Mv8fuX+KjTOKybUfRkrMYLTwnktzto7XL4bPV6JSgr1zyXi/wP0IiBa7nIvFsmFETEDmkSmjB6+3XRtDceu+HiY1B08r7G4cowj+bhEiU9irEArAhs/09nFkBKWfu7njQLCOCNBBJpthpgn32r+tC3mPfvilUiPPBu+kb3fpJUh3Wr8R7kEUJ9cpSFFoM9HMXUfxckaLCz+/AmeNoJOZ7Df0zpjqFd2vcH9o9WuGq0DX76vkvHv/lOimqManirg30fbNBql2okj07qa1AueaIRcmjgXLPv19gOP0dd8byQgY28JJ3cvxp4gwOa4WbZENGFdP6ywtBKbURhd/XV1AHP1lQTpQUpEjSrKlGTXJ7nLmGywwYmNcxBvzt2caPtrivu+xVXAnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(6496006)(8936002)(66946007)(26005)(54906003)(33656002)(52116002)(9576002)(508600001)(9686003)(4744005)(110136005)(86362001)(8676002)(956004)(4326008)(316002)(38350700002)(55016003)(6666004)(44832011)(1076003)(83380400001)(2906002)(38100700002)(186003)(5660300002)(7416002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JaggOgdNQWlvLYuH5kPse+JTr/yiYEI1DJGXXN1DIow5hVLDKTQCi649Gdnm?=
 =?us-ascii?Q?8Sph4tfgifveSxgFsOBBM+/9v1WRk0cLaslRAStX/SQUVoXxsoHgEt8fDB3J?=
 =?us-ascii?Q?UCTgU1orQMUpLfDBJUqw+vNr3yFXSzg54p6OHWjCOMxhC+YU1ovtz6TZC0Jh?=
 =?us-ascii?Q?fBJ3pLxyM5a/AhO/5Txs4hfWlksR9xvTVld75hjemKXcMhue0UucBdiLCYIS?=
 =?us-ascii?Q?n/ABzsy9W96IguFHPdAmCnjtjCA9aqSrs88YtqqHMOYkCEN942wAH5t9LvDC?=
 =?us-ascii?Q?Tv1tfgAf0tg1jHjC7K7/hONlgAmvan0k7zRPRRaxJz13ZXDyejXk8PE7ICmM?=
 =?us-ascii?Q?PLjNxzYMYFDebsPVYXxXrgonx7yMYPgS+3Y7UQ5E6ygqYLQaP8q2Az8YrfWt?=
 =?us-ascii?Q?BboX94lTAn7/AWwsjBiWucoyZnvzL6NjHKt5mm4/KigptSb8mWVM178Q2p6f?=
 =?us-ascii?Q?iTVL2HYlPhguo0wRRTeAooakauRUpXPHnPSp/aXRD+foNzUVYD/ovMVAzYDm?=
 =?us-ascii?Q?8+YupJhyu/2o9NOfbrNQT6o67q8T7QRDcCD/QZstYJOqXRk86/MwC0lpFccm?=
 =?us-ascii?Q?HoTb6ZhuatGVWxkYAN/WQNsIoGGZexjC6mfIpY+Ah45ZqmdpKrCub1e0W8fq?=
 =?us-ascii?Q?j6qOIF9QR7CkHA66Nd+SliHs+mFvMWiWts+PVUJtrLrBGtFkFAkTZXiVZnZX?=
 =?us-ascii?Q?hdhZdLN8FLS+A/PUsbcEXBbn25j/bM37zVjGZLkaPg3Q0YWE5RP4FY+TWoB7?=
 =?us-ascii?Q?EMlTRTnKwz82guVKLtAIXDma1xXSWP7MH5k/i1x2L6ULk1BTtorbKBx5A+Nz?=
 =?us-ascii?Q?daqXYrTcDvjN5XraZoKzmq6U7BVTIWz1PDXI4UyQtwwD3sHyEQGYyAhpBi4m?=
 =?us-ascii?Q?kIC3rzruATcNj81SH3RJdCGALw3eFgrdPEQkQvxs8sYeeegGoIKZFqqpj0L6?=
 =?us-ascii?Q?JzZ4/+o1X/NCpXQlP0dwA3zJzKmvbuqgOAldkH5mDSZ74Sq4iO52RrwI6FPO?=
 =?us-ascii?Q?rHY8bjcDocbA61iEIztYF9Rq9HzpLRGt03zzYWaMbMchtp8ckjIxbnqlDn8X?=
 =?us-ascii?Q?4LLvHeZcAEcfYrlzQtJoMMXC6WYhaMnpznWWeKyfNJ+WJ7qsjzgVbuKxXq7U?=
 =?us-ascii?Q?tTXasw+6NAa3GYugVRJYURXsYdiFkvRAdeEJ84y++o2CsziH5ZMtl26fnUwU?=
 =?us-ascii?Q?akdQIG7UoT6ljoOoEnNNOaM3AFWdev9xWGSDdinbsiOfSe3VhDjwsYU7y2Cx?=
 =?us-ascii?Q?T72NWf5u9MUFEUEl4EF4TI3RpcWSsdLeMggDZn9LHZCAuBos76zfM/S8bOjF?=
 =?us-ascii?Q?aFPVFky8rLRkVBYEcgzSPD/wFHbSxJGNMPGskYwGJLQkmvue6Al9YFAr519d?=
 =?us-ascii?Q?4KSp0qud9FeWWJwuXCpc968byFZzfqB37/qmR8MLrr2ymVjuaTqb8bBbahxP?=
 =?us-ascii?Q?ce/FS1Y544iVpe2PvdHXkzsGihx/ESK6l41VuDT0Xm4G/OAdHpd6pHeq08yV?=
 =?us-ascii?Q?o6ocGtZ/kaAMmoc0fmX5O/XQLForrBkGOmNZO8ikDE2hHZ6Bn/Awm3bLSp7B?=
 =?us-ascii?Q?iuu/zIsoe7nilkK3WgchLeF7uI4i0Bbujuuwpcw3+JqS2noom+mCAc1kshGL?=
 =?us-ascii?Q?mDha88c3GinHEiEDXOwHNrmAQ62DWHrtoLltfVJpsYQ4sCAYYuIBw4y7H2jX?=
 =?us-ascii?Q?3dEyQUK36yU7koWU4v/N4etHQoA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c34cb2-dcc3-4130-56d2-08d9af178d59
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 06:56:34.2765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ur3e8bYfSjkhpIXfffnXVyEnIl8stZhx2zYkB4VCpGCL4dfs24DklsYF7IC5nsy9/x+kZDHB/LBWelal4ZnHM95BL/2NzzGL8/+y3k2watg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1637
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240039
X-Proofpoint-GUID: Y4t7_olaoH4OrtHBnm2G9vUJgxMopqKR
X-Proofpoint-ORIG-GUID: Y4t7_olaoH4OrtHBnm2G9vUJgxMopqKR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the last channel is not available then "dev" is freed.  Fortunately,
we can just use "pdev->irq" instead.

Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: In the first version, I just failed the probe.  Sorry about that.

 drivers/net/can/sja1000/ems_pcmcia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
index e21b169c14c0..391a8253ed6f 100644
--- a/drivers/net/can/sja1000/ems_pcmcia.c
+++ b/drivers/net/can/sja1000/ems_pcmcia.c
@@ -234,7 +234,7 @@ static int ems_pcmcia_add_card(struct pcmcia_device *pdev, unsigned long base)
 			free_sja1000dev(dev);
 	}
 
-	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
+	err = request_irq(pdev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
 			  DRV_NAME, card);
 	if (!err)
 		return 0;
-- 
2.20.1

