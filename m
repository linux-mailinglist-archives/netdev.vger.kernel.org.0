Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D764DAC97
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354483AbiCPIj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbiCPIj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:39:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D392A267;
        Wed, 16 Mar 2022 01:38:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22G7wkY3003512;
        Wed, 16 Mar 2022 08:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=m99Jjx3ahZGQcMyjtCAPvGaj/FCg/94OU596W/BieWk=;
 b=DCYGzct5LpxWVK69P8OjqSgTNVv/jOhIqbxE2/ghXmN24jOD1ml1nipHvPcO90bG1kne
 eoNiMn6Een8uM8wN+GbY6on+LBHy3/wtqgl9iJLSuLmarZq/V+PGKfISzrx1wUE46LXt
 31cY4XA2isZxp0GGl6TCdAO7ojm5n+4rwaQJ21ZAu9Cd9SoiR3PZtSq1j9KNo2EBYa+q
 t8hVTnJmQ5hyfVPUjm+UPF3uxVvzDCCFYauRg7yezPtT2YPOGzNKbXfuS6lLYzAAmXsH
 lhy52wk2rNIRKUcN7hpaSvpirxuUVl5T8EJsUw8d+oWGCzCyc2XjcEbkpE3KvKoh5Tuz kw== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et52pwg69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 08:38:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22G8UHsC036052;
        Wed, 16 Mar 2022 08:37:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3030.oracle.com with ESMTP id 3et64tvwd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 08:37:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsLlur5m5HYyc4o16fMaKdI460kd23lHFV3Zy+GU0cnDqXlrTU984yWgkL372fum2EAW2+4rRVFQQR9m6L/sBbmzRIbSSOkv6j3KcbxeZK1GkptP74VkG5ATaYxW+dk9To/u/Zrr+Md64MXqFwsX3So8sUphFPwTcpsfYhGWgtnC7tnIMi3M3XWjQy8AYd4TmpsSugWcMyKw2HjyGhjVHDaWuuQ06KMLZKyjxzaPsjWyK2fWOKmJ+OExvYjxyy1YSJ++1YzlJuj70319LLFmBAkALRMKjhZ63Yn9JjdLL6V6X+oqIpSzYYtrzTZNhBarJ5q57uwcXSVbhF8nsGIW7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m99Jjx3ahZGQcMyjtCAPvGaj/FCg/94OU596W/BieWk=;
 b=RP5nu4U8ZsHC0W0GyPjccp+ewuPpMdMVBoxZuGrWqa+ufMVWtJfyLeaYPWFOLZqS/SztLZodI8GRvRFdR420DRMl7i/eaebh7OWogzp3A6//vLVhnL5t6syprNRcSryrZItIcnQL4fUgk/WpaQpmNkf5fi+nvvmwR2ktPSISZD+9TrfHDofgZ70fXayryumFDgZlHI5mSyqR5iBBFgVG5WB2Qz04WSDcEqjJOKe4LCgGtmTK6f7L9vLpdS75z7TSqVV8Cpq1Dy9AeiXC2Mt5nb2QoQFncLof+medbbBnLGSJrfLXEatDqgpvhcWN0EXlSSQLZy5INQvjcxRDuvWXGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m99Jjx3ahZGQcMyjtCAPvGaj/FCg/94OU596W/BieWk=;
 b=ekqmdi8tvXexqC5fA1K0SPrGLM3B1YBl5+p0VErU3B8Mj5jyXr7OUiRDI+j/pFaFes4A2E46z650UgZijXYAZDplBygxiY2i5XOw+bfZ/5J5Mu2I/+tUL9ecwO9kYYXaUvH/Q+sashVz9Oqa2dPOxfXYcPc6bWOxN5AQ2muwWcQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB4736.namprd10.prod.outlook.com
 (2603:10b6:a03:2d6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 08:37:57 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 08:37:57 +0000
Date:   Wed, 16 Mar 2022 11:37:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: clean up impossible condition
Message-ID: <20220316083744.GB30941@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0018.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::28) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee0206f3-a16f-4ba0-db04-08da07284586
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4736:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4736AFE8A72E702429137AE58E119@SJ0PR10MB4736.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cwXA0W2h5XZC//6kUPHTfJJfmyib02Y6uA+oUqs3tthhCx+LhDwUKEYrPV52U05Am6BvaBqYawKS0WNtQbJj6IwrVo9MaixU1RzAzJo/yGfDQ6bjz0XHsdEVWGGZYKFwCXwTx4Sn+vRYGaDI5G2ZU4VF8sj2KcVhIQdbAzGjDHZxBsmQugxyVDiz+93I+M0GZrBhJTg9WLpUg9cRFkZHz3wiMG0u4BmfbAYHIBMM4RSKOPiPw/HIpaIJxhuQHZPNhiUotbEg3qu6YJXpIa6Ws0vRqBlePbsHoqk0LzEG6RblUjibwHI2foB9gQZ/ax92Hd89uBAo3H8nbRVtjnfKSAAWijy5YBMy2HwhSmM1R9C+hxE59tIebwyThVHwvVzkWzBSKR/qfAmV1x1TOt3IHO7JzTKPOLdTRBrrmS5EdiWmL4AwmXh3mgAql4ZfHuNpqk6LZUEJIF7eES4yHhDEro+9eQBkZKqPD/m4Wzkox2c0fzbHoRnME3Iy6ZBwuMlSlgFx4G53tzqhK08wvtGd1U1Xym4UICtwGyoEXIi+U9NytsVrm60rDYtDA8eY2Tg95Kn63CtbqjCSq0e1h/FD5ynxTj9Ivcu3/BxeRnoyjGmphQvupjsmaaKXek2AJ2amCXiDWqjkteOk2/SbQ+yXF9TQu5RFiT4NsbmWu2VGWPsp+TrMqM3cn6oZ6oMHvdxN8YNqrwyf3jnSiWdR/ApMGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(54906003)(110136005)(508600001)(6486002)(4326008)(38350700002)(38100700002)(33716001)(86362001)(7416002)(5660300002)(8936002)(66556008)(66476007)(8676002)(316002)(66946007)(83380400001)(52116002)(6506007)(9686003)(6512007)(6666004)(186003)(26005)(1076003)(2906002)(33656002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?orJw6VS+DC55YdU/q+FECkuATRDcEoJlICFp2TTG5Ktkd77m0kHdAI7Z4ZfE?=
 =?us-ascii?Q?MCwJ9338sP4B4IQb1xp4GSH1I6BPVOck2RleRlsgcYK8d5offUIHjSdFoLO2?=
 =?us-ascii?Q?G6x6q6kWyydjXtOFNTcZpDOpQstlD+ikFIEhl5YdqnykQLgdjEMpPmlmoHO7?=
 =?us-ascii?Q?p0hkJwuCxXf/TcHXLWEVfbpK34MCDGhl6IJOzswlC+OwGgANHU2p/CHc5wTP?=
 =?us-ascii?Q?97a1BpBFHlMi3ZLSyC6uROgyiKxb02BGXpGHa40aE93EdrhIP27VCjvP6IoK?=
 =?us-ascii?Q?2nv/PkjMDZA4wTkgr5jw2kFFbbdZn+veStJzJve/loxn2s2IRmZgs7BrE+th?=
 =?us-ascii?Q?Wx18OspduF6FE0Wc1y3dDbQSjQ6eBA0NXrVqI8owbnoZhwPG6SJ+S1U6qysx?=
 =?us-ascii?Q?NfRVQ8YlpHsA05birl0czfzhAcbO7hU55zPsvCoHouU9apu07HrqooqRol/u?=
 =?us-ascii?Q?CAtCqW0eboRjC2nVShKNm2gvl719i7UY7kv14pyW22FWO/HOXvvFQpdrQmYK?=
 =?us-ascii?Q?OIjHVv5UTtH21Z3UTpxn0kLw3v8awNuE0D83i6TGa2YTDTLXK75IkoNNfWYt?=
 =?us-ascii?Q?0oo/EuSKTF5WU5r+5cCcKZ4g48P2nKF/PwsVUnnjZySVj4WdUoKb5aZ1UIEU?=
 =?us-ascii?Q?gwb6ReMnEEuYvdC52zfYJlRmN1QMQvvs9Xu3aRmZH7BE4r/VM4YR9IvI8HZ5?=
 =?us-ascii?Q?hkbSAS7vvMPgdlrlgSwi3He6kCmOKznAkQydbQq5PI/phNNgChSQIjStI3a9?=
 =?us-ascii?Q?yZHfoKBAeykD3YsRuqXfE3A2H7lNHbQzSeIensbEXDAAREuqkSFudgBM1PdM?=
 =?us-ascii?Q?klzJBjieRgPNVlnMbtigd3IfIe0meWzC031cj6Q85boC5Fvkgbtbh97JdGDK?=
 =?us-ascii?Q?YscdKIvMfuO2bZO27K+cLk5hAshfBHAr++D+RJKemIrKMXOLhnRIdBKGZ9HN?=
 =?us-ascii?Q?lJt2hMPI3aDvAKEPtILnr09SsPhDivVfxJMzgM/VwsSW61IeFoa5L6fpbk7u?=
 =?us-ascii?Q?eUJy56RuxfYvVZtsxzDOHbhzE2wOZ8i1isOZHJgPsKz4WvVl+GpbFuKi3KZL?=
 =?us-ascii?Q?l9k6pBXRB9VRj6tv3yYpSO6rPq92/UNd99Xhiwk/JySdt0ZsCjhOfUSwdsCc?=
 =?us-ascii?Q?KPVHmBez5lZAA5M7c2vSJ6SHThdMekopRoEuPiTOvrzTJPIVMq+5uZQqsnhq?=
 =?us-ascii?Q?FaNxuPO2bJtSUAIhrI1PrHJ1aEmSoDm0tGxohh8mEu7rOLoJSRAbLkbYm7Ai?=
 =?us-ascii?Q?UnUU8ljaBnh4+vPATKo/sXzkIKDIwSyxRkwpiOA/anva4xOeB2JI7ed1YGyB?=
 =?us-ascii?Q?9akfwrQepdYUqH+iuPpkRECWbvtw1FN5BB3AjtPEaYZuxH5onl0CGs4mi+JY?=
 =?us-ascii?Q?0yITFT/GDC17YBfdLPFyjiNkA8mp7dgHm426OmG8obQXzDgNQYNxVcUC0k11?=
 =?us-ascii?Q?eI7A1zmiovUjbkiMGDWOw1KM+NDfrJovQHwFye0nYzjC4fpXPC+c6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0206f3-a16f-4ba0-db04-08da07284586
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 08:37:57.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ee6d0FeC30ksaSG1vOxd/w8XakOIusV7lsD0FFK5nMWzjm936wtMO3zr0RFKWMfn3bmOGifC/LVHpSIkVVqs0Z68wyUCL/jTgKFREgrRodA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4736
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10287 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203160052
X-Proofpoint-GUID: s__N-cTBUzQDHrKzWqhA7srfZRkFmNlh
X-Proofpoint-ORIG-GUID: s__N-cTBUzQDHrKzWqhA7srfZRkFmNlh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code works but it has a static checker warning:

    drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:1687 init_dma_rx_desc_rings()
    warn: always true condition '(queue >= 0) => (0-u32max >= 0)'

Obviously, it makes no sense to check if an unsigned int is >= 0.  What
prevents this code from being a forever loop is that later there is a
separate check for if (queue == 0).

The "queue" variable is less than MTL_MAX_RX_QUEUES (8) so it can easily
fit in an int type.  Any larger value for "queue" would lead to an array
overflow when we assign "rx_q = &priv->rx_queue[queue]".

Fixes: de0b90e52a11 ("net: stmmac: rearrange RX and TX desc init into per-queue basis")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This code is old so the patch could apply to net, but it's a cleanup and
not a bugfix.

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cf4e077d21ff..932f444d0d68 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1668,7 +1668,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_count = priv->plat->rx_queues_to_use;
-	u32 queue;
+	int queue;
 	int ret;
 
 	/* RX INITIALIZATION */
@@ -1695,9 +1695,6 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 		rx_q->buf_alloc_num = 0;
 		rx_q->xsk_pool = NULL;
 
-		if (queue == 0)
-			break;
-
 		queue--;
 	}
 
-- 
2.20.1

