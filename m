Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFFD515870
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381513AbiD2WfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381512AbiD2WfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:35:18 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0695348311
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:31:58 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23TK0YI4032058;
        Fri, 29 Apr 2022 18:31:48 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2175.outbound.protection.outlook.com [104.47.75.175])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fprsjavq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 18:31:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPSnTDHsmIqqBhzCLYdR/lwWsem1KBtdlt57kUIYGNFS7q6LKOYv2FUj4zTaXNnV9KYy8i8r4VDdtUxtdF33h3B9EQejr05NbeT5CKxJs0IR7tJINz37RyZPeOa8XKhZudGwQnRorQll5W2a47oZr0JIzXaVGRAioIPwDTqj3TjCtuQBwiFuIi4w1/N81vVJ0biUKyPQ4muG5dBsgvvZfZpcKy7ad7DW+NPf+C6pW2qvG5CtihUT5RpTzeHgwHFIIFRgDdNU0jEWaS47qjH9nqsjrWofuY0o7YjOgkRMGPiLPszdu/wALF3hyKXeqULUAY2xWkYunP8OdwOaNQuBIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2q2XLZvHNO4ab7aymmXEHMvGJ9a+Q3Ef4ribthZlnxE=;
 b=Abd/K4Q4jbN0yBk52x/88Bd1mML6EIz/5BohFMKFOnth9VMhP4qy2UY8a6jdV+kcVsmW2vXMMI5tvwb36yFDnsrA/1cdbqsS1HNlSHIZQuDKh+OQft2hnJPmUzl9HoC7YCy5XKMOa6GKmVbeRs7hrNtztxiZqYoRKqH/cgyeC66JPWl6ZPNn8C93TD9jmfm5do3hch1VSPeS58BPGE+LD1HOjw32f4ki+EUOGm5m1wqVZTKlXc9ZbgiDqaKLm/Syfr+TpWAj3sMtihuXlJ7b9fir12q9mqrPvxk7sKeFdlj7NShYRUXP/rN1s5y95IgOf0bcZo9mZmVFt2/MOhBB3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2q2XLZvHNO4ab7aymmXEHMvGJ9a+Q3Ef4ribthZlnxE=;
 b=rPInIxb86TI2N46SCH0di7REcYyFH3vgFxn74//fb0tCPagncgccsyV1gPrW8dla/qw0Bv7+TSpYLa2g7hwO+BDVvdbMHq6CdFIq5wFAIEeVK9C9iINegvJxesCWGFwrvynlInxGMS1iC7hobFp2vJ2F5nR/alcj3+wi7sD4UeE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT1PR01MB8361.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 22:31:47 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.014; Fri, 29 Apr 2022
 22:31:47 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/2] MACB NAPI improvements
Date:   Fri, 29 Apr 2022 16:31:20 -0600
Message-Id: <20220429223122.3642255-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0097.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::15) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 410fb191-1f42-4518-57de-08da2a300bb3
X-MS-TrafficTypeDiagnostic: YT1PR01MB8361:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB83612355B694170E7311C479ECFC9@YT1PR01MB8361.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WVquPzcgG/uw+m4LVjeXBat7sNpiDbArvLhy6NPnPmmf9wQvWCgah4Oqxp7GPn9JiOBfmJ1EljWsLG7qXioMB5DcaABD2mtR/ar4AyD4L2I5HVGvSe/taLt1vqhbVI2ENzkXp+Om3VgkUUrELzKdv0gYk0aRqkBYsV6QHY+DCiqj/4Mz2lcoLL5D//WQvY123UCtuUCsR6knJ+vKjbG3hAx6OOumgfb7vStXz5Azo11G+VfcrEofK+o4sjbHWnhA7CGP6PoURfv/mDAmxTx0UL14k88HRQW8BILKwCYmfDDG1OUxo11RaCcgYtFUOQO72kBeYvamRXtl7soE9SBOFn3JDyC90BDxihYgR0kKQ8OLh158d+ZcupktDVE0ywMRmynkncvOsyR/xQwvZ0OuytfdstqrZ3ac7JcSNku6a+dfZaKYNHK8sDzMA3agyyvhEwqbzM92e/tohEIWTbCikdLk6eX+tivKCGopny9KeR0FKdULFcCSwYyRBHvVUC5z8YxsG69x0Tk7FnIlrK2oYZRa3c8F6C2HjNp3UpL7clibgan/Tq+JGeTtytfLBJ0aDsUMdLLS0zdZyDaT9ONwr3TGjlWTl2lS6KghCZjvp2v4J7H40ibBPn8jJI0/DYbXCdeuIy8eyRD2WubuSSsD1b24klTyWA/WCY7gF9PmYvQfwRS6L8x8jicVCTSqUVcCUzVJKynQPm8scvewyMu2bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(36756003)(6916009)(1076003)(6666004)(316002)(2906002)(2616005)(107886003)(44832011)(4744005)(6486002)(508600001)(5660300002)(186003)(8936002)(83380400001)(8676002)(66476007)(4326008)(6512007)(66946007)(66556008)(26005)(86362001)(38350700002)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7bz6FtCDHtKuAO7ZIK7MSaIohSl2TFnI6CXAFRFlAfgd3vzJLgEvBRfLvjmp?=
 =?us-ascii?Q?dLQQ6psVdyBb9nKyDuKRinHvWKOpxHzKGl7nrrVKu1rT5KUR7VzB6l10dPfk?=
 =?us-ascii?Q?gPOz5ZHYiruEN10aXUA12piZ4i9TZUXcQkYS3e2Lt2TNAen/ecGC03cI85Fk?=
 =?us-ascii?Q?d1FXndE0Fu8cRR+SPdTzZhVtcm0gS2UR7RfBQ1Xha/J2FmvXQK+sOLjdJ1tN?=
 =?us-ascii?Q?cr0x0DqOviwsowS5+OJkMSxV46CKsFLcQSMmRj3A1m29ZsGTC/fUjK7Vc/5W?=
 =?us-ascii?Q?PFZ7Ds564QUTnrSyYvg7LCUJJB0ACaWX5SI76OtI/Zl/vnQBHsOzItqrOVcP?=
 =?us-ascii?Q?TDL8BoOdJh8h186y51Atu1cZC499A80jqQ7H4rRzMPx9k6iNoLzuLva+k6Gz?=
 =?us-ascii?Q?piuiGMkBqHD21MDvxfghKiCOJvQhUo7gbm+jJfDowrYnIadnYmevu4bvyTL+?=
 =?us-ascii?Q?Z92MVNRPhnPXEVHGjNary8pzyHNrk9LX+pnm2vqKLndi84OO6SihdxtCKJXA?=
 =?us-ascii?Q?dZMooe11H8mt3caZP3Q0oUg3yn4wEY+nWj+MnjOBlh3vRFYFtkr+foaId14D?=
 =?us-ascii?Q?V7IakGf1M+RO80C8oN3N+whu6nibjaV/w7iKqlgsAk+U6HsuM+bTiu6U2Q52?=
 =?us-ascii?Q?QtGzBdRxOlReDLRrKPHET3W0WIWWId48X5J9029rIUKfxSkSDKRcc4BdQZtX?=
 =?us-ascii?Q?RZEKHQQpHWy6GM/P1DN9YNFf4WKE8yVFeJa3u7zC5Q3VV/q6q33IYfNhcV0r?=
 =?us-ascii?Q?IL6/E39PX7KTi4P934ak1iXIDcVuNymn+zso18wfCCLxQFu3E76uRjZSe6eE?=
 =?us-ascii?Q?vVT49qU5k4Yeg7nriSRm5L93gtPNv8O9e9HVBaIwYLdHeS4rA6Ylb5ejYuic?=
 =?us-ascii?Q?UtlWbJo+KCHqTJYFHCM8S5vUJ/KGm+wwGa7k/zCTcMZ7YxTh0FCqybyEzXv0?=
 =?us-ascii?Q?yEUf+yTmxac3+BFbPcGk4ny/7+xCMEwobSjHnXU6AMCIBhz2L0Txss74T9ls?=
 =?us-ascii?Q?Pj3muDwBcdOXp2fKLlx7S64XyDScNuQFiWS6l8txlqTBY9DhX77qyQ9LtK1X?=
 =?us-ascii?Q?15v7nMx89Va8XeqoQ7bD+2Djgq3W4wwaztdLabmu5BFQUQL9a3eO179+7xD3?=
 =?us-ascii?Q?uBxv6V/iVN6ORrtKau6Uer5+f3kFBELYNvS+kHGN9U0+YoU9Urqo0PCLuhJe?=
 =?us-ascii?Q?yLRGK9my+PVfWYVCSBPz/oJWfV3pJ1e7FO2T2hqEAEl9mTrcLwSG9Vg+x6EB?=
 =?us-ascii?Q?EfMhAVk8u5k0vbCmr2q8pdDv75osSjY6Eu7K1cL38otesbpWDpV2gmkSi4va?=
 =?us-ascii?Q?+U2Q/3+5qShFRr6wNvpmwaWc3qliKfDOjl8l5Bi3/HT27zoRSvwmlL8+Apbq?=
 =?us-ascii?Q?O0nyLlvzy47Sq59NlpTo6Nmt2vJMhVU+kOcrRSX8hdPTcfYQ7Flq6i4qEW3N?=
 =?us-ascii?Q?+xmVhEhWCn1f4JXnagZNPq5YDd+RpzT5iWAW8LLnBJ/28Ef+8DjPhh2ah8d+?=
 =?us-ascii?Q?hhyFmV/SYIEF8JW44dmCFlgrAv/4C/ly+f69/TWpuSgodHD2KJETjunMEh3Z?=
 =?us-ascii?Q?7ihiOG+55Z9OZ3FoYreVk0xqI14F6pecli37nJkjRDYXNJZeRqCj+VINzlTW?=
 =?us-ascii?Q?RdI8TShkET9mOQ3AIwi4hT9eePhBUpxs6y0huG9iLdTW+d4f7AZFvdNR5ciN?=
 =?us-ascii?Q?27+c6+TwqOY1k/YkNwxm21Wvx/kvup0PjcSawrUF5Ym3Ko7m8cFuPtkTkLoC?=
 =?us-ascii?Q?KFwqLA+qnVmbBb2DV6pTHe7uwRnVSCU=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410fb191-1f42-4518-57de-08da2a300bb3
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 22:31:47.1482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: umifROdn+LLDGkn3Mn4Z0tQQ1ktiPDuzYpYRBwCHLD1Pyv1LYy/YTkQXwQG8YFTTB3lMQi3Ng174hKn0V4b5rQzpW1I+ZSpMfBG/2DDCs5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8361
X-Proofpoint-GUID: cmHcZSx0MIDHxyYCT_Zu_1qN8d0pqESh
X-Proofpoint-ORIG-GUID: cmHcZSx0MIDHxyYCT_Zu_1qN8d0pqESh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_10,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=562 mlxscore=0 clxscore=1011 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290119
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the logic in the Cadence MACB/GEM driver for determining
when to reschedule NAPI processing, and update it to use NAPI for the
TX path as well as the RX path.

Robert Hancock (2):
  net: macb: simplify/cleanup NAPI reschedule checking
  net: macb: use NAPI for TX completion path

 drivers/net/ethernet/cadence/macb.h      |   1 +
 drivers/net/ethernet/cadence/macb_main.c | 193 ++++++++++++-----------
 2 files changed, 106 insertions(+), 88 deletions(-)

-- 
2.31.1

