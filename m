Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA28571D1B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiGLOnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiGLOnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:43:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6121BB7CC;
        Tue, 12 Jul 2022 07:43:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CCtUuQ014903;
        Tue, 12 Jul 2022 14:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=jdIS+djgztCB+qxO4cofEZKdCwv2pJS1RE4rAvBVnGY=;
 b=tBDOD61tYqhICoX2ZDV4evOHDP+kK+RN0ktyKxvxOcp3FDFVrTJGoT0rnel5wKfeT0Gt
 BJNzdEbiRqu5Ipn2Ix1gPbZ2HGY+Q3Tjn2KPltIMB0Wh0ZSq9uTHuCq+ud730en5Xqtt
 cDuvWSMza7uISJVpYzMRCGWSj4koRIz78RjoFI7RlVai0TlPhMb6W6h8pS4bsC1ADtTV
 OsYcqgJzqzoLLxY7OKdU/xCVCAjhA/odnyP+lFv5q6JegMsJrVSQhxRnZUymaZDOurXD
 +rRzlZIDKczlIregfzvRLnAMA0YDa3O0E4wiMzp2a7UBtn+GDCMqev9TztnSAb+yw5UK VQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71rfxyr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 14:42:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26CEb1RV013698;
        Tue, 12 Jul 2022 14:42:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h704336k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 14:42:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDjpa+Kj8kqINhJROQZXRtTHajSXvR528b9VOS6NROdrRRQRQgL/r84liM5BXEQ2e3AWtNrvoeDpwbdmRKeTTvkEMj7WVnuW29MI6dYarorACI/do7KmNPq46Ut7xleCyLIADdOPMRD+/VHPrstpKbS3DS8YV1Y6ZFAIZW0jVLo3hnfYmBMGrzyeLH7NrHqnT+j+jIdoryBvl52LKO+ijwccXuk7J9PGn3HLaqi3oevF3LfEq5kpE/CXfd0mSKJy96kDcuU51fmH8Xl1M2phm26wiml1ygn4OXfXnxRIYNt80QqrqPSla2fg0sSyuhYQ68JNLkL0/X1PocmBX3r63A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdIS+djgztCB+qxO4cofEZKdCwv2pJS1RE4rAvBVnGY=;
 b=PnuaJCGD/eeyPOX9BLvOR0go6C45ngR0Itiy7RUOGQ3zpKX4meN+ogYDyXt8TFP8cTZBUSl1anWFoGuZhI0Svb5N1gIPXNt8tdoNqoVhznUAphOABYRpbLc/CbVcuHaLUlLm3gIzcbfROVc45nzgdXW6565dTh+UMCRrOWZkt5ayuQ19M+L9cUGSRDhUmrZuhDIb1uazQtQiqtM8MW4BHkEPOwQfnBR1BsnfbXLwME0gyUKYLzI6GOwGJzunrPHT1jRoy5LE1MsBLRpXZmw1wOCrm8KzlBRXZSOM2ov+nlMvvfMxrlZZNLlw7LbrwNd3fTl3pa/m2FORm+G0u+zPag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdIS+djgztCB+qxO4cofEZKdCwv2pJS1RE4rAvBVnGY=;
 b=zkCK53inRIoQ7GXsBOS6GYaGtVVwnvEAPB/QKhPh2yAgg6sV+GsL1KMaOkB8CpkuG4CJQJ3vLhNvSfxcMu1hzvXGntb+UmANOprm8y2E9AkoDuMAYbUktYwJUcqVq50iYdyg+NNR784466xHu9DLiHAoZjGNptsLe8mniTDXs/0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BL0PR10MB2913.namprd10.prod.outlook.com
 (2603:10b6:208:31::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Tue, 12 Jul
 2022 14:42:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 14:42:37 +0000
Date:   Tue, 12 Jul 2022 17:42:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: stmmac: fix leaks in probe
Message-ID: <Ys2IUUhvm2sfLEps@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0049.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4f9bad2-ea41-457b-8dfc-08da6414c39a
X-MS-TrafficTypeDiagnostic: BL0PR10MB2913:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SD+11Z+1Q1Nuri0q8F98T86dxhuBsUbEfLlhqSPj1XJWzpcRF2BH9vv3FMTe0cCUCK29Jm0CgCaT4Hlbrmi6bbC0zSV7Mo/JOrIC09ogqBVcFbuE1ouAGgMioSzTlK64rkNmEBrgk+wzewh8dDEyFmBBhYl/SWxVhFD+Z3+GQMjbVrPQi3dlIUl7/wxMymHPGJwaaTUTw1VnuDWazw+uejjYfP1BylwwLLKZtMKViXKlbU0BqJBPJ9o0dAAVt+/+S8HW65pHs86/9OkrC9EPEnKPKNvS+SUy8w2qhGJMyJDSfDzOdneWAor5VKK3kx2uqm9uaJWm6pJ5pricN/IBTl2o3dQSY7lj6ROgyJouLX/gOUl1kNG8P6fQs+dyDCyLNJ3bkrpnkCkaeLgSzYgIxYYqrXAdKLDXM2n4pYr+fRimAznoK9CfSzWJwCR527zVDJvie+yXrxYR31IuuikeqeWRKnuL6L4ssLUwxMlaxksFV1YlTNQRDlvJQMgOTLqeFt7/nqTTmPKAsP2Eg0EKI/BWsxdd2111RRihcI+ldKu6IIhODsVZYJvD+Z8OJD71xibJWgmKzk9ME6GroQv0S50OhrxU9Z76L7cgYNbU0eZ3Ujdd0GOWpu2hLUEjNTras0vnLkPsqvgKNjFx5rA/YilzJFNkUI+lQIQFDw56buCHXe3+A4wecqD+esnLbl490t2wWILd+yJaKEFsQbN1JoDKtAWu4IrQriDOxH/gDCfmb3odQBwJrInT70TGWyNGdryl26m7aEgacs5B81AVwpll6omYubBy75Ggbua9FFVyM6cDsWWWFJg13suinA2m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(39860400002)(346002)(396003)(366004)(136003)(6512007)(6666004)(41300700001)(9686003)(8936002)(86362001)(26005)(66476007)(4326008)(8676002)(66556008)(83380400001)(33716001)(52116002)(6506007)(6916009)(478600001)(66946007)(6486002)(44832011)(38100700002)(38350700002)(2906002)(5660300002)(54906003)(186003)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xcv6tKGHXWF+PmbeVh9CSajSOjlM4vTflWMvb+fbiNm1bZUxfLbUK1huECuq?=
 =?us-ascii?Q?4FXWIF4ioR2NZQ3YlKq6ITlrnBx9gO+mtxNuzkZIo4yNyhasb47hyTWjeyz6?=
 =?us-ascii?Q?rT2gX28Pap6QL+wSFRtERPu//VnDKwR5UXUGfVPkbm2Nv1hAl3+CQaTd2DEV?=
 =?us-ascii?Q?NYctwTRb1LaBZtwl0gCesRdoP2Sx0nIt4a0qYeI40PP8emEwk2cT2Gv4Sd0N?=
 =?us-ascii?Q?/DRzs8znSdKJkM/ClahVBDKjy1DGUAKf+Whua3NrYIzhf1T75EbavVHJWqIY?=
 =?us-ascii?Q?/cg6r4ca7wV1EF0/zVahNN7+0sBIgMNK0VQ96mG4BoLFboScyMJo+cwQ6QXw?=
 =?us-ascii?Q?UlQEywYr2syv5XuHIMYr3Lqc6DpavTdWfK+AyirK1B4/LOtVouXLmEsCQVGj?=
 =?us-ascii?Q?d3S3HZPkozzCBc62W4ikQSSwKeVbDq3pfAkPnMcgQrmQirX7S6xZz7nkj18B?=
 =?us-ascii?Q?cjZR3+yYupBwTNTcHMvU10yDswZKqaP/VVt0dft+2AcouhyeNsv006R9IIYv?=
 =?us-ascii?Q?NkThoKAEEE+HoQ+tCwMpr47P1b1SjNePEJStvNKnCuf3MvFPgJ6dz9edfiC5?=
 =?us-ascii?Q?q95NdJg/kK0SUq4qg4fVadNSx+dNnmDhPirk/5GL1At1mIsN/1xKIP1MDFBM?=
 =?us-ascii?Q?yX04AMWQ0mP4Q7mhrLPsKQscVMMjX82iJ92ZX9qWeuXmKThdNZMejD7bhT55?=
 =?us-ascii?Q?fnlKdvTTyFK72Dwp9mp3yDHVh2pcvC/2t7vTuy7Rk9susTafzVLkZaOu7gq2?=
 =?us-ascii?Q?MorDNaFz9Nx0wxkpNW58ybo1egm8yTS8uxYhAUJfODkRhWrqyr0vgJQNao/p?=
 =?us-ascii?Q?3tzppoZEw7MuxxLbNq369IcHetktQrLDZ07Yu/SRnHVUT5HhxApsNSg46uz1?=
 =?us-ascii?Q?agmrhBUfzvLRrIbgAIgklqC5ectuxhQMaCbtN9DJDzxDUrZ9NO4Q6NWCPgde?=
 =?us-ascii?Q?Po0NAfg+KhvjNIJ8nxDDSPXmSXxC3VeEdUgdVGpj+dOxbTglmGeInMaNyENJ?=
 =?us-ascii?Q?zY8lTTz6jtvnVtLnn3YdNScQmHx6tyjFQvCQfzeLEk7vWQrYKksbUS7RjPzX?=
 =?us-ascii?Q?2Ni9WERx5T3loAWp0aCsypuATgthLVBBvJMKAfeGPiZdGZqJD9f35lygsQU+?=
 =?us-ascii?Q?Ua2KJv9N7jA9Q/fiMAkHPacRTje8vw5nXvdJmNEzbyn3o2tyT2+AHFzYtArQ?=
 =?us-ascii?Q?Rzo/EjcOWQoG4h5O/ytLbFoJrG/eCG9LXkX9oF0U8NoYpCtJ2GXmM7buyyFH?=
 =?us-ascii?Q?S0hq8zsZ8W7FvsGNIJKy53gJhCO/lFjW4vU3ulVFC3+jU8TovArUJdwLLs20?=
 =?us-ascii?Q?+9tqeRIUtImsPARDiC/8Ps2nUSib8qUQ5SInzwjXi0nwKDwx12HX+H6wdZcD?=
 =?us-ascii?Q?Dlr2LdxQEWd/TskMcn2Q/kzvbjSvHsYJm3PrLDZ5cO1ALOAB1UpmVpmEnOFY?=
 =?us-ascii?Q?3d477xG7jrbdi0x6hGjycXfXiXA+6SQgG6fbfKiGsgs8YMZIFWUQ2IAZpTlv?=
 =?us-ascii?Q?DhbiPIwbO1dv5BehFQkacuS9HRqeNxGoflvsUUd8ZH/Qwc/pFEgg9rOZom/P?=
 =?us-ascii?Q?qzYTfWDlsUK8ChTh1mN7p6Tp1TO218Sx4Lqos/tCYz+b1AK9DeWH8vJtLYDf?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f9bad2-ea41-457b-8dfc-08da6414c39a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 14:42:37.3280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 73a+jsR+OteovmKFmRexTXNKv/GbadUEoDhV7WaR5/bDds1ueegbuCtC707hTWyZ1BeNRC2Px8Ar/OzhJ77wk9OZ7RK5rF3u0rSvNOGxfhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2913
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_08:2022-07-12,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120057
X-Proofpoint-GUID: IOXYgUpAivoXHF6I2TvA-LZeX7oWVPqM
X-Proofpoint-ORIG-GUID: IOXYgUpAivoXHF6I2TvA-LZeX7oWVPqM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two error paths should clean up before returning.

Fixes: 2bb4b98b60d7 ("net: stmmac: Add Ingenic SoCs MAC support.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
From static analysis, not tested.

 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
index 9a6d819b84ae..378b4dd826bb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
@@ -273,7 +273,8 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 			mac->tx_delay = tx_delay_ps * 1000;
 		} else {
 			dev_err(&pdev->dev, "Invalid TX clock delay: %dps\n", tx_delay_ps);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_remove_config_dt;
 		}
 	}
 
@@ -283,7 +284,8 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 			mac->rx_delay = rx_delay_ps * 1000;
 		} else {
 			dev_err(&pdev->dev, "Invalid RX clock delay: %dps\n", rx_delay_ps);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_remove_config_dt;
 		}
 	}
 
-- 
2.35.1

