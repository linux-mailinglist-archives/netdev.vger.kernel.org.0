Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8576584181
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbiG1OfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiG1OfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:35:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A886AC1;
        Thu, 28 Jul 2022 07:33:06 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SD2lKU018062;
        Thu, 28 Jul 2022 14:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=YdWZYGSPh39jAAd62+jQ+qrIcwcoj3ZLjydA76huhCY=;
 b=Hb44Fair2hKjiBPgPi48Nq8J9Z5Ckes1yw4tsGxBnLTmaU/XLadtLHz5OJf+jYzW9dff
 v5Q2zk9fed7bORRX9e5YNX3cDUJsSMvmoOOhBp2GVDu9X1AjgutR5LWYiFuJhDkjdgNp
 ppv8l3LnH5BP/Q08NMjyWrpXnP+V2zzh7bvlk1RBJO0ifhpSdNciqkEj6jY+SY1RJhnB
 28YD4DgVg/DQWDhrsfCgou0WTn8Oe5Snqqr8GIb5wz6A+33Q/Fp6cYenT3Mu8Ga6SrsH
 8IwV1pPDyd34JMCv07vejFzfuxpO0aLe1Y11mcG5kMsihBifwbCRB82OWA2ujkqz8svl /g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9a4vvpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 14:32:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26SDKaj5034538;
        Thu, 28 Jul 2022 14:32:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh635pg8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 14:32:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mflgvx/QwZm7aofQNLbSW9s+E5IPPwnUUShB3FKH4QUb+6FWcpBqZz7EsdtCpHEKzYFeaCt0VSwg9bPic+m/4YE2Hiaw8deePHNtMDNqO6kdfchEWRtWOlgtdG1U0eTwbxWbA1G5vWXgb4xpU+7MRtZ1uQxZjpmO0Uzpac4jaWJyrKdhytnwK/IE2UKj+yl6Ve7N/MA9ksMVuiMF3X6Ac90OzU2e8/1E9YrK3Hnsl4QZOjV3y5t6A71A83p5u6pknz4cxB2fqlx8cNZYIWd2O5AE9Qh68koH64r/jTHxnz1egMKPMxHv7/02OoS8dEPJt7KBQFOgI4kjHI6APHjhdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdWZYGSPh39jAAd62+jQ+qrIcwcoj3ZLjydA76huhCY=;
 b=YFLmXTkS/q7bnUKWWFUslc8xIOl1+aUaJxYFwvczVFHVKmsDW4w5hAS94sMYraAQXLh0aKBCFoqj4Fc8q/OgrX7E+qiR4+D2Ax/ZlfL3T9tSOMpCgC/+CIYso1sOD9160wSobVi+coYDTnoqEdfA59uulPzMp6OT9F31GoL4KtEG7gXx6mDSVOesrOrwbTKs1L2wQ33paLRBqeQJBYLzqc0w5AO/cnj4/kYws5qxUYxFKIrcFXpN4PdcAWLJKoPg7Mnwf6lfKFaOZyHujLPeYTlLe6+ecvN3JpQDoJ6026NTsO0L01D/8dkbb83MHh+ePnXiC2uJCzQuQzBtfuPz7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdWZYGSPh39jAAd62+jQ+qrIcwcoj3ZLjydA76huhCY=;
 b=P7lA5zLeN0QG8Gc4/EsIjM4hAXqINeS4ms3O0AKfSrixnU3k5KUv/Kgqha8rjzlfvS66rytiqnSpiqQhlsUw5DP1ZI+zVbDVHmLUk4wvUHVLi9j0ZKjvGERYCQaNxy5700u2vPMmag8ZlQXrln+YMljTFvqe20Vhjxh1CTQqXI8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3369.namprd10.prod.outlook.com
 (2603:10b6:5:1a7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 14:32:48 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5482.011; Thu, 28 Jul 2022
 14:32:47 +0000
Date:   Thu, 28 Jul 2022 17:32:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: marvell: prestera: uninitialized variable bug
Message-ID: <YuKeBBuGtsmd7QdT@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0099.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 420fbb7f-84d1-4ae7-a202-08da70a60ae5
X-MS-TrafficTypeDiagnostic: DM6PR10MB3369:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F+Om0nUQB8PgMZ/dfxp54DCqBebor2GkOLdH6cZjfOZiZyFKFtarZ86EsJjGneNqIrWnsE/U0P10ks34oucRF4TqZbXM6OgPFTvkx86F995Fg2xoUVYElUKNm0LrElPwvYqNxi1Y6jfKOpiPsHI6KHYo7t3O5C3PxiTIekBUMiL2ZYGm8B+XZjrjW7H1Tq/NjraWzddJ3gHgDnRM5pdANN72YZVWsHArRcC9b5Lj9gPrleUKQOkb/BMvYVh6emQbBlO2KEYfXD75TH8LOoCmDmppN+c97vvuUvZcqvEo7c7n/4xWIBIBt8JRzja/kGavsXcV1ud/EK7lTbB6pr89DgNEU7AN/8P9MAsloico1d+t+PMndqr6ezfjJQuc+rw/0FalOmJ7qnudFVUaFDDcuTgpwJti+V5kvDDTzy3mFdJUD63gWmy31ccN9y9EgQoLMCZY1n2bCE+7euILDdl7+DCUKETsTU0kgzEZN8wPG1U2OXxjcKuNfI/ndJfbscOWx21DuEoSKF+6p3iBh9CyTEc39OZuKuHnBAUcvLTU9110uTpyGz7kUCylpHyDwVOkDQuyUfEcMX/bVNn86SIeLVq6s0q6Fc6CNPWX8GOuLFNO7ErMlfW+oNvJjcqxzZ/IgwbrMga63RT0N4jXxfJ6gAqJIu+4Q8iBp3jE9Bs8XvBjvQETxziAhLNwHr2PkM2Q+pvzHi8GX2l0dYdr3LGQdilvH3F0xfHwjhzVNho2Rg7En/TQmV0v71Ifxya5tJ6ZNugOMbNJ/z3x39WhEgKVCLo731S4gBB4N/6TY8hJkCThu2qoa2IiXXQPsH1vFFOD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(396003)(366004)(136003)(376002)(39860400002)(44832011)(83380400001)(186003)(86362001)(2906002)(38350700002)(38100700002)(316002)(8676002)(66946007)(5660300002)(4326008)(4744005)(8936002)(66476007)(52116002)(41300700001)(26005)(9686003)(54906003)(6506007)(110136005)(6486002)(6512007)(66556008)(478600001)(33716001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s0KSHnaB7FzXT9YQd8T2LWolTdxOZuU0BOcRBB0CA8WDYCL8mzwNzpfjNwbv?=
 =?us-ascii?Q?BtffnC7akQuSvJaFvAN6abmPeHeNZfzOf/uQEkmASu3TE+pMF23OSMkev7rp?=
 =?us-ascii?Q?HjxKgCTpssk7W/YnDl3tbVZC90hz02+n0Hk+FzjzxvmEvX+vc2UlK93Mr0hN?=
 =?us-ascii?Q?e+OpiP+hsCmfMD80+lgoi3NQlHfhj1UGS0Md484MhG/pZ2gwig9ACE01dqmt?=
 =?us-ascii?Q?jnRxBpdlWwuw4WOa8J+/mXy1IhsLGWqk60FwzVH3H3HyhJCIcWtpjDFCf5Wo?=
 =?us-ascii?Q?hGn3bqj9dBxBOVo543aiC7Hq3jHTs/MJh4inJs0Vg4oAvF2vqEB5ocLljVUx?=
 =?us-ascii?Q?zGerLOHaE/lwwWHw+tpG5skQ2Zgn76YKxVqCNADQHAb5JL+3FpYpfubGKdh9?=
 =?us-ascii?Q?nCO2GR3b+Dfhp7i50pYKRPA3iLbPQFCdccfstf4Nlr5NqHSZ1LZhUYxtc5j7?=
 =?us-ascii?Q?Ymn0gvNMB/pu0fygl8KVko3HxpnS9iqRBOjfakXK3jum6tcHUwje88QTSPF4?=
 =?us-ascii?Q?020HzOg/DsFqHijEq0c9V4AsOKBjGind321OVV8Qaz0B8mmEtypGNn50T2PJ?=
 =?us-ascii?Q?mFrGDf74xMWKRU+s7qglheEtaZL+RPpBlXqwVTKF3UPm1JqRgQiJVTsBAArK?=
 =?us-ascii?Q?+DYqioOjfiRo78akhGeXmiXUZ5BQditYazmGAAqcw0qbQcyKYFoTwd9a77mM?=
 =?us-ascii?Q?rMUyzumNPz8xSSEenounWAo2csKPrRJqdVaEUYW6lcRymg4avgqS88kVIUo4?=
 =?us-ascii?Q?7FtrwN1A6hl3RdQTOfX9kcRJ0MA7bNVfF54vvfiOvSOjUaVw0+9lzzCmpJr6?=
 =?us-ascii?Q?ZQW/VhAkXkU7O41hCl5CySxg+qtA/q1fz8aw4qcXDGemZYcVt9TTeBsPHC3m?=
 =?us-ascii?Q?pFMWVEnAwbxUYjbxTmPxfbzgZF4c28ZcuhcmtVcb+39cU0RrE3BUJoB6QiZe?=
 =?us-ascii?Q?4Gq+FFnbKkuWpTdPd51xTyXKA2bjkdcTB99P6wb27oS7cIBby5tXrGhqSvu+?=
 =?us-ascii?Q?+zbY12cC3uLwnQEwxarrVO2YSQmYbbYCDfQ8VkuqfClugJUVoloz5uiZyFi9?=
 =?us-ascii?Q?EoSveV2/CDO3gNsmv5pd312e1uiIpPvMzDuPXkvXfsJD3iW2EDlgORsEc2sF?=
 =?us-ascii?Q?ppqy0aS8cLGYJ/8R87tjsZmjWV+tIAwT/m57+b2RgXdSEsqOiRH28NaMmUeF?=
 =?us-ascii?Q?4GMj01pnlAyvsvWTnArb4+LzcHw1nMaNaIzJEUgSpnCVoUqWt4TC7s72whJS?=
 =?us-ascii?Q?mPOvQKR8Fq0DgaTlQONL3g6z3VXA1vwY/FJiab93kAWF5CX00fnL0tKF90co?=
 =?us-ascii?Q?wsCqI/49pk6V1MgIyJ+T2e3L2rJJwZPeouy3cQjIJ1VpfDoNd0EUDjgZJvY2?=
 =?us-ascii?Q?gWuFX6HsIie3ckURM4wWtzbOBJhs/uHkq8ant6iMcxJRCmRFfNv/XrJvNbFN?=
 =?us-ascii?Q?DsxB9C5dg0wLAtglOu8v+WjrloZKccY3+fh6mGIH/UDhpPbCSVQU7o3dj20a?=
 =?us-ascii?Q?/uosO6EoGNXIYW/HINCrIWcYdW7K23JKNhlnhJgiuUR5auAM15Mn9481dfIo?=
 =?us-ascii?Q?pbLpbf44aJZ13JSRedME4vgKJH+ot848lQmNU/nRCjKBUiDFhgfTs3YrZzO5?=
 =?us-ascii?Q?og=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 420fbb7f-84d1-4ae7-a202-08da70a60ae5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 14:32:47.8862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WqUeDGIcpfl7X6O6D0dwzb610PgYZnAUpHipdBcOcx5RdGAtkE0x/H/8jXAdb/braTt5b1abIP66/k69AkTFFDB/a2niVTBLmUw1Qs1OVo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_05,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207280065
X-Proofpoint-ORIG-GUID: WxOGZQ-BUZdxiGfdmmh9UnOpyQ2Fy83O
X-Proofpoint-GUID: WxOGZQ-BUZdxiGfdmmh9UnOpyQ2Fy83O
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ret" variable needs to be initialized at the start.

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index c267ca1ccdba..4b64bda3f9c2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -847,7 +847,7 @@ static void prestera_event_handlers_unregister(struct prestera_switch *sw)
 static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
 {
 	struct device_node *base_mac_np;
-	int ret;
+	int ret = 0;
 
 	if (sw->np) {
 		base_mac_np = of_parse_phandle(sw->np, "base-mac-provider", 0);
-- 
2.35.1

