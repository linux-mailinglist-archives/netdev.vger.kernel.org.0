Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DD1583E18
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbiG1Lwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiG1Lwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:52:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506F119C3C;
        Thu, 28 Jul 2022 04:52:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26S9IaS6029957;
        Thu, 28 Jul 2022 11:52:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=92dvWQU7qVjNm45myX9ijIeQn691L1h3oTie0tmpV5Y=;
 b=gRqqm0T/7ZTESIcCUaARsmYI1ll8jd0V7fST790SfQqSpPXfCVmHFnaGpRAAExgRhpbf
 8VN2oXvVtkVSJqpQT9JkedlJ9xRgbninlCcrsegXwobzNd82E5g3BnRNfexUDR8wUCCV
 Q9okHorPpDrUMoN+4SrSM0kvZPIWo5Cwuu05ZBKpgFb3zb0ksnlDUrJ7VLb2sb2NWyRe
 YUV7D78VQSHePcUL6gYDp7ww4fN+XiT4n9Gt0+BzTXRH4H4Cjo2ntsvjCw/O+/OxEvkF
 JYR/KcB5YhIOGQUuo3w3PwvROm8+1v5e1F5aINt+MOLUpaVO1EEF14vZ/zET6Y8yLvlt WQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9ap3w3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 11:52:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26SA6LfW019834;
        Thu, 28 Jul 2022 11:52:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh63af3sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 11:52:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+CbpOIeoxrVlMq0STJX3ZtSOb3J3LnQrZBBSbJe9Vtoyixfxqu8q0mNPB/Zpy+VFHyyNGUWQ6OPvgwz5OzJxpxpc1Pm937503VOoiTDxg4Orgr9/SDvzJMqm0z4IZ5+WGB0IpXkddM06kLBu6fCgwoSsPW78vnUVLOtjutBUeU/ep2d1GqS+xoelEAFWSfP3HB4ItiQFR4wY0So+gBKVwwQywUMG1W2i2HfnbRphGEhuw6rRkexO/g70Hlrr/HMu3OPMz00kXLtkIcT+vFfCQMMqSHzq6wWTQ9QQjcTGGS9p7JMyPZ6yJEglnajVd1Bh9q959TzxZGIlBTJTJ2Hug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=92dvWQU7qVjNm45myX9ijIeQn691L1h3oTie0tmpV5Y=;
 b=ndK3EMtKg5qEc+6LKwYToYSNyjLs7ktupSb4hTG1Qp/OOVHUo/3xj+yjS/V+nfVz6fi7tzcielPECDAYpFYV5o6cJFkuydG3rA+FcSfYtfXgSIKONQgNwE129bH5B7LG1bbktgJqiotIeWe89B+NfTXT4FpUXHEwOz+Zsb/bzLbALyE3g69JflMHrkgq3f08DsmK9Qc/EZSnM5foj0L3pUbtMaXTeWzhwLjdTcyzlyC0kUQHLxxsqEl2KMce2sUVpo4GSHmen8BiBQ4RCl3RIh4n7KtrjddBLToqeq7RERkNp0wA9abCUmCFVZMCjEc4CefywQU4ph2j2fsumJiKDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92dvWQU7qVjNm45myX9ijIeQn691L1h3oTie0tmpV5Y=;
 b=AypwxurWbPan9NrIMd2WFZRbnwg+ruEOMzseTzEMRC3ORpACkUnV/KQ87D/ngnOkjCjnf7WOHlk5zdSgbZuBjpoKsL59pazTHtQF7ugY3xSxYXJfZ7S8VVx3A6XHHee3YhG84mZpX1IdxWs6gNgFo4nkIuRSEIrVyemzZGOYBDA=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BL0PR10MB3443.namprd10.prod.outlook.com
 (2603:10b6:208:74::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21; Thu, 28 Jul
 2022 11:52:23 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 11:52:22 +0000
Date:   Thu, 28 Jul 2022 14:52:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Biao Huang <biao.huang@mediatek.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-mediatek@lists.infradead.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] stmmac: dwmac-mediatek: fix resource leak in probe
Message-ID: <YuJ4aZyMUlG6yGGa@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0121.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6269f19-16fa-4039-7217-08da708fa1bb
X-MS-TrafficTypeDiagnostic: BL0PR10MB3443:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yrJflPu8lklee8RinzGYPHTQgsesGL3zEv2Cyun46ZjkkPHT1LS229g8VeO7hleqR8QQ+ioe5NgZiQWqqCFnzLWigKq0TI8JqVkhhaEfuZUH/I4jGEv//+BPiMG4/PJD5Sw6bzsCjk9XYFMKC95ih6+GKaUZJlFZi2Sne9ZJ+/bzjru5rC3q/5gNgFkF8NNt5AkQ6qtmSpWDXvhA1NKV+dMprHhG19yoTXSuOzy7uOeTZjkNZjtOTiTzjjfPlwsN1WR34XoKmR2PU7tP47/V5/7Uhf66Nj7xYHFONCHQioMd3IbVLjDicY4ixWh6XT0s6NjyvzwL2EkxWEBv0Jv04SB6Mmk610xHTt1HqFcY4jmN8Bas/+tWvdoLMnPGmBr+Gu3tsojgm3Yf2Vm5hQYowTJ1q2kK1HdOyG1brd+LIiaYINDZYlXnWwvF4O5Fx51TkNaPsn1yQ/PWnrFb7LKYwzkIi29zck8zU8xZkIlxgPOUzl50knUphOlYubnctB5H8wptXwq1u8Cdsk1qKKpz2kBmhiuPyUoGucePUBqoIlmqKxGdWcvJxJ6cM1fqy0SeaOFHxJQL9/sa0J05XRiLIEo6Z/4YRuH01/xuXMNZRn9FXiBTszBQTASMfsBLIQH7SwCvNiLKaEut0/OdgGMaO1t+hWHkq7Jl2GtQ9+geRRWkUe/WpdeSpKx3rWwZNel0amPyKiYiMwDjehaJOVI3/CLZgsWD2/1GjxYwQNtWyTeNUqV6up87fLFsaOO+WB79JO9XMwFMhQJTyLpMvkjSvS4k06D4zPK0AYZvL/FyJwQaKX+6duCwXbgi1ClI+VFe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(346002)(376002)(366004)(39860400002)(136003)(8676002)(4326008)(66476007)(66556008)(66946007)(33716001)(52116002)(83380400001)(2906002)(6666004)(86362001)(6506007)(41300700001)(44832011)(478600001)(7416002)(9686003)(316002)(5660300002)(26005)(8936002)(6512007)(38100700002)(6486002)(38350700002)(186003)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VStV/7OvUbpzG+PmppTUcAICeXsybFPmaKs61XtMVxc9xaDBn6oZ7m+LSpQR?=
 =?us-ascii?Q?uylFlrF4gA7j45wspeHGPFStw2/vZ5J6jkuDhPTxhHnptJxbTMTNlqifIUFc?=
 =?us-ascii?Q?Q3ZQ+Sbf3lvrGn19Oo73SnU0RmncGSkCxLHf9dEuc24kzUNbHJIKe1N9BSEi?=
 =?us-ascii?Q?F/BFccnWS8YO1PQnP3RtZuzZIXojmaww3qoX0yBAIGtw04UJOuVjzopAdZ/q?=
 =?us-ascii?Q?RL4RuZWzH2kYIjVH2NlJYnT0XV8mqPMoZCjvKwiN7OOukuPJeH+5a1Uidnw9?=
 =?us-ascii?Q?svX4gh5AC573OmMPVWaNlpkdJc3z4nCHXK6dz2fJId93A4Bnm/vnGDtMdvXA?=
 =?us-ascii?Q?IJZz2ZBcYhGbqPrvIEGxGWZxXq9M4zAynsg4KwJ95w6Qhq7RpvYTXwOiyyyw?=
 =?us-ascii?Q?MdPvTMOc5sV+6U/Vc/3jF5e/fNXsCvr3MIIw8LNhxXaZhOsPEgNTCEuG0Mmb?=
 =?us-ascii?Q?gO3rBwaimt6K1+JcY1KaB2xTUUmnGM0QK7f7EI4bQGV8i+Pgf0XdBV+VjLu7?=
 =?us-ascii?Q?L8+rb64+8adEx+dtudp9do7XpuWwGwd5UEwgYqzNBYfqV+FzbiEOG3883Vic?=
 =?us-ascii?Q?6YzC2nF9eoLQjJzLcoZxewvoRwZ326MNsJWgUIV+PAvgNi+a+on7Hh8u592t?=
 =?us-ascii?Q?Tm6BYfpkwcKALQOvkOft1l/kMEy9ZedHQG3Ka6am+ld+jfcpwIGXsXaUconh?=
 =?us-ascii?Q?LF/ZVPua8tHoo2zfpZjVHFZAP7x/jpuUrCyJOwp62QQM7Z5Z/SKnATkSjw1H?=
 =?us-ascii?Q?tTcLtyPSHMNb2WVvgNsV/C/kflhXF+eI8PxxqsW/xgNKyUulJnGtu3Zi+z5s?=
 =?us-ascii?Q?AYvLPrcr2B369jdz3CR2Kq6I9Vo4zimEer+GgPLmlNdmI9zSDA97vnBJ5XT/?=
 =?us-ascii?Q?/7Fa12mDZRDzwrN8tjrf/ckLn5wJz8cRHmgGFBZ3hdjhCiHobydEYhkkZsur?=
 =?us-ascii?Q?2/NJb2BWPXJurg+TvUfJDadO/WHssknPMm1ApXOKiyIAm9g3E+Zw7BnXwVGy?=
 =?us-ascii?Q?1Rv1APzDCha7Dte9/d/XZPAdTvq5PHmGTpRZ8cBgYzdMZ9d2FVng4lJ2hi1b?=
 =?us-ascii?Q?mF1OD6sYFQmm2NTinM3oJVZObcurdJS3m8KAincXA3eJs0WPnrdzjrajzNOX?=
 =?us-ascii?Q?UEnjRh/j5Z45T1RTvxTo43kdhB8P1e7YBsevk5UycJ4PwFUn8FjqLhM/rdxy?=
 =?us-ascii?Q?LKc1NFma3+s1fihAVkbXLQCxirgfqLpPXJJlMNVWeRg+BgTG4iFbzEJL5hYg?=
 =?us-ascii?Q?xG+QwVzlIs4FAZPA4zWTG1y/selnQRA4u6EAP+mCP1TuVyJpDi3UbPk4e4b7?=
 =?us-ascii?Q?hCiamcqDD3ROp6+qSu1m+eDvY0RRoSGzmxe/wI6x1eu3Epec0IOxukDhUSbN?=
 =?us-ascii?Q?Iyp0yjIhqZNNRM1SN1fTjTybTff0nN/N/IAKXwlT3WCuN9lJn7dqtx4c4tt0?=
 =?us-ascii?Q?i3pr0G94GLRdAxV3k99pt1c5OrokC5MJEyuv/UmLB8/GRYsIbYKkG82aALNd?=
 =?us-ascii?Q?z9FH1jMfrak8XL5F1giXdxUjEcU30OlbheFbR3W5/1TwySbNFEAU1EPNHUpO?=
 =?us-ascii?Q?l+KOTh4bkOlnjziI1I8oPuv/cqhQtz5/OmMigEhBEovrGhJeTjzC6l/0MvmC?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6269f19-16fa-4039-7217-08da708fa1bb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 11:52:22.7240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBS9b2TWIwV2dQuZ1Rp1uNdMKx/rOUuIKwnTj8/NF/zlZI0o0FjjBfW82w+lArzIlgjgnqIlWkugTC+3Pko9qn3EwD3+Tjj2/iExoWPpAsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_04,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280052
X-Proofpoint-ORIG-GUID: E3pkD6gBG0vANG5fMR_SVmNmqFyLtZFU
X-Proofpoint-GUID: E3pkD6gBG0vANG5fMR_SVmNmqFyLtZFU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If mediatek_dwmac_clks_config() fails, then call stmmac_remove_config_dt()
before returning.  Otherwise it is a resource leak.

Fixes: fa4b3ca60e80 ("stmmac: dwmac-mediatek: fix clock issue")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index ca8ab290013c..d42e1afb6521 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -688,18 +688,19 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 
 	ret = mediatek_dwmac_clks_config(priv_plat, true);
 	if (ret)
-		return ret;
+		goto err_remove_config_dt;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
-	if (ret) {
-		stmmac_remove_config_dt(pdev, plat_dat);
+	if (ret)
 		goto err_drv_probe;
-	}
 
 	return 0;
 
 err_drv_probe:
 	mediatek_dwmac_clks_config(priv_plat, false);
+err_remove_config_dt:
+	stmmac_remove_config_dt(pdev, plat_dat);
+
 	return ret;
 }
 
-- 
2.35.1

