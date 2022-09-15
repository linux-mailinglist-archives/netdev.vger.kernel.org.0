Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1B25B9840
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 11:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiIOJyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 05:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiIOJxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 05:53:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60B0578AF;
        Thu, 15 Sep 2022 02:50:47 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F8ugQZ008397;
        Thu, 15 Sep 2022 09:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=+Vpyvvqfs6DiERZprshhCX/e66BD3De3BCfXPrSo/YU=;
 b=EWPjbMuhN6ScOXoExcKQN7AZTCKVadVwOy2kucJL4r5r2sA4qMm+544W2lHbBF9j5Ot6
 qq3il+Pv8gt4fVS9XwVSCZiJDVGKAXGCQsnbSOaGbQUC5uSCEb3bOzM0YoNpo/rhy9/M
 LIDRk9PA9BCUCi5pMKplTjvi8k8H92puLFSqwM3YHX46Y6MgiuVIeZC885h30I378HgW
 Df5+10Oxx3JasVznJSVPrT+EtpviJ4VStunT9GNapCgqkNQ1lkv0vTwjSlSkL81pDdTK
 cqwUL7407VyDyVQWSU90/FmUrENPv8P5OPn0mBwEUUJqzHeNK6+rhfMCpcHE5SO/iQ4j DA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jjxypcv05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 09:49:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28F7qLoJ014535;
        Thu, 15 Sep 2022 09:49:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jjym0w582-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 09:49:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CODHWEPyfbhB+c5vAGmBdmYiAvZQUPO6MN4OxGZgbtpj+C4j4N5r4O4mwAukm/vW0Rq4N6ZB0fX4eVWtxAxo99NnsEpW8WtPC1UhFT1VWHmkU5VXRIluhZAvyZxq7dN/ZdFF7QtWrQPw66im39M9xtbULYMmEug/JwGwN4b0B9qv/VTar8YvktgNmsJrgRMOf4Qxpx2+7I7PzfjsrCAB7MTteZpsxM18llXr9ptLHwaTjvERcgJS1JPKLOmll4ioudqI2n/6VH2r93t5D2XO6N93hPzyTrs5KEdcDyvnFL954cfBCBDHhrlKj8tan05CQ6UEorsPr1iIgFsuY+c4aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Vpyvvqfs6DiERZprshhCX/e66BD3De3BCfXPrSo/YU=;
 b=mYLn5LS8hQ01/G2Bf7CwZqdMaKBVXxzNX9Ml78/HPtCCkXf29t8RNvy41E9D5CYh0Pjg9oDDDRIatXy65+ImNvYTGPXbFO3yEdOAK3X3omu1vqk/8OGxtPCX3HtvmgNwQ96nyU8E+5EVH6hbMp7tKn3TBzrsbnVCUCnqY6AAL+N9d57jbEosaI20O35cV+16McHouTTWzCmunDdnA/2rO/0YSn2AKmhnUot3VUpIbhFeSwEbhl2Ao9/WoYrtuR2XMjf6JJdKvMpohpSUWc631St8FEL+u4c7nD4W87Z6O3M31r4gAGfeL0SYj1L11M9BO34xsHVGMSXh36nuM2yMcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Vpyvvqfs6DiERZprshhCX/e66BD3De3BCfXPrSo/YU=;
 b=LawHeBDyYfgJ9lIGgur244th/yStR7cVZExu86b11+/bf6AInRjqi2kyKZ9j5XTqtAR4Zyo/30CxeZ94hslLa+yczXAYe87j4kBhwE99cwWaqanT3wGCa1zDH90xne886GEu3jFjeSgqcB/xWsfbbIpaKhYx/ccFs9PWkBsLAdM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BLAPR10MB4980.namprd10.prod.outlook.com
 (2603:10b6:208:334::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 09:49:34 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 09:49:34 +0000
Date:   Thu, 15 Sep 2022 12:49:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yu Zhe <yuzhe@nfschina.com>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        liqiong@nfschina.com
Subject: Re: [PATCH] net: broadcom: bcm4908enet: add platform_get_irq_byname
 error checking
Message-ID: <YyL1GSD42kib8iZM@kadam>
References: <20220909062545.16696-1-yuzhe@nfschina.com>
 <Yx8YDUaxXBEFYyON@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yx8YDUaxXBEFYyON@kadam>
X-ClientProxiedBy: MR2P264CA0161.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::24) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|BLAPR10MB4980:EE_
X-MS-Office365-Filtering-Correlation-Id: bf36703f-406b-4c83-6676-08da96ff985a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QW0rjRixDyPQ2qkRbhHJBOc+rITfSi8ef/eHMzJuXgcXQpVbm+wb/IiSTh9tMGvURarlRwAFGlDu45kPUFSXh0Scg8if/5Nz6OYNfxNu3esx0PMdg9KQ7UN/l8KPXn5JxOIq6lfZV135D7Z2EXfKZSlyp1QgEUM49Om9vHW0nhnYTqxUp1iusYpjIhwz10qa1Bq2Ju2PqEv9b72eYEjxF/2TqjDJ95F4BV89O1IuTEZs2eT9JzeSgNwxeOYcPB4ObTiRyoRuXyHl1xWJx3P3zTB+2Q2zJJyI4maaQu0/4SEwY+bgM5NWkksy3NQ+kWyVxKTVz8pN1VS9IBNXvKISq8Yrt4wVn2030JGhzY2ey4Wliz3TkvO97dJy6kd68Xqu9QV9d85lzrlVH4GzZcMDpKVVl+/looedtfjSl3mzxmrkoKhNC6lNcJSPH4J0fGgsYTPuiEhxIoZXF7f6RPzguqI++07WJu1T7eg1JCGYLQ9ieRuIoRuVDk7h5Gf9nb4P5ewcCYm1Z+1fQEPHmZ/OVuUHvqwgl7kfttF3mo3Zl9l1aKwaYOgJFiZravUZDCmhI1awszTBO5Vha/SBI+8NCubUagr/CuEpDjfyaGuCfngQgowWNulKep1ZprhD0FctBOro7aHzVARQREX6vJFW6Fp8vZLfQtsGoZ3q0yLb8pp1HyStTV8jSHewYFJdvTIwOOHOC74r9e00xeuXYs0m2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(186003)(38100700002)(2906002)(5660300002)(7416002)(44832011)(8936002)(4326008)(33716001)(66946007)(8676002)(9686003)(478600001)(6486002)(6512007)(26005)(41300700001)(6666004)(6506007)(66556008)(66476007)(316002)(6916009)(86362001)(66899012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VObiTfsiWlgGbQpAOhOZfmp5v+gfhxKXKFKTocsSiCn+AKLPG9+ExyJJ4QQB?=
 =?us-ascii?Q?VKDjsVSWPT/c10utryRprWwSuMETKLQLFdbN2S4NZO6cvWCCCjEtxJd44HTY?=
 =?us-ascii?Q?zsmnYFTIzg5ynuI0QppqOnYUsobWagvWTJDzK0gEGz8ANUQQEk04LkaMVSOk?=
 =?us-ascii?Q?FYADIweFpzRIV0b9uz10fcpbb46j4ckyfiA1vz5DKwfmJ6adgYpGyugdcRnP?=
 =?us-ascii?Q?RS0Z9I3i+LkOmhlvDD1TUQ+faShvW8V2i+XsuOxv8E9Crkw4p6WYZRu8xHV1?=
 =?us-ascii?Q?uM73pRgVVmD/KXJXKv1kgfIjssDS5hUmM2/GXT0BEjC4pezr29qNobINOPYm?=
 =?us-ascii?Q?xBWAguEmRX41ggb0jjONjzX1ZxKYcQj36avT+J/J6NzipK+0gm8Hk2MI9wJE?=
 =?us-ascii?Q?rjBE7wjKvS+MqogWMVvLUhk/b5pRCNttXbMmwPyXejZwSnnRLr2rkJv/Bt+X?=
 =?us-ascii?Q?I/9Z/+C26w4akguZ7A7YKZkXV2h7vOIlMybOJRSlpF2ijvJpmeZC/MzzJOH2?=
 =?us-ascii?Q?8sMoE1Hg4kl2U3soJibRT0CmKno8ywmjK7bhezIzD3MjlK+OWCzciO3dafY/?=
 =?us-ascii?Q?/9f74irkpbog4J4XltPL0f65aaAvuApzHA1yguT1VgPXJ4bVedjwUHh9FbdI?=
 =?us-ascii?Q?pELExdcrFsL/MzH69S/JETUmqzHjYn0cXqj/lwF7kV33QoqK01tDEC5MrUjD?=
 =?us-ascii?Q?+FXRS+aZsVbDJ4w71o+8p9fbLjA2MaLoRcpmjMVKljeMNJDFWnTwL80sjE1U?=
 =?us-ascii?Q?MUzMuFMgvO9gFQ1gkiSWcCQhHD6C6BBk6Hk/+J0iZGtK0EK3WkspQch/1Sxe?=
 =?us-ascii?Q?o1emnoONqwCH+RXBn7nOYGZfQzgbbasIMtKW37a6GppI/NhFYGIZmSmEaPhh?=
 =?us-ascii?Q?w4IqytObVnDSxd7sONeflk1lCLHHsKGuHkqJ3xwraSF6IxNkCQL5q8OSkvZa?=
 =?us-ascii?Q?6faFUcN1dJD6BD/OUpunFdeIJ5oYc/Ol41AxG2q4ZVvVWx4o0g1LJ1kDiuwJ?=
 =?us-ascii?Q?XziEmAsT7ThxLo67k8ICkpnMrBabNdN8ydg1u0V/72ap4ZM1/UCVRXJmiT+Z?=
 =?us-ascii?Q?nXw/ybr0xmtieQbWSsRvBvpgETgN/rCMJXdjeDrx1ja9bZlT+tCbL+K1X2BQ?=
 =?us-ascii?Q?rfjHdYXF3KvwXfVeucE7A127Su9wqf4gCXWFnsQ86HQNwMP3CvPjee/U0cVn?=
 =?us-ascii?Q?sgS5mEqg8bFxfLsq5ldbnyrtQfE2pYx6N7KMFYSQuCcl796GDTv0lciizf9d?=
 =?us-ascii?Q?Dxc8+2mqXwJwFzbYoFTZO2k/BM+pVeRwjNE6tEPbyz789aCMSBfD6mN0n5dP?=
 =?us-ascii?Q?KanBZEg+gsm2Pvp4efX984bFMRlJXkcNY+BvyCXnd1eGplSexa5KyEGNG0gE?=
 =?us-ascii?Q?oBeTiLpNM8up94g6mAp8kUVgD80eJBRfALVkHC4cBsSm5ZAk9USMmW+Z3ews?=
 =?us-ascii?Q?jX5i2x4qe7ys5B8uc1rXsvGU8Q8h1c0urETKJkRQr1ehqd5EokkF3iDSQjT0?=
 =?us-ascii?Q?HOM4AiVdS98mIt5+rMrAa5fusJdT75iDOEyLwSsZAmvVhw17cmOolblqLZbi?=
 =?us-ascii?Q?AtnGxLAXlsXZhqVq5r7Trm6/Bn0299PqrRHYzpzjWmhh3ytgtzZgkgdezvgo?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf36703f-406b-4c83-6676-08da96ff985a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 09:49:34.7921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgDYTA6kPryvGd43W/J/wLP/BNe7FrqxT5/RXQ5jYosQ34itKOANcBjVLf8OfF5p0hhIy8s0RQ5Am1Hg8rFjPtRRa56P9PYCJRy3QFC8Csw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4980
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_06,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2208220000
 definitions=main-2209150054
X-Proofpoint-ORIG-GUID: dIr_Ac9RMyoXh-8opiDQQeHvqfKsAOiV
X-Proofpoint-GUID: dIr_Ac9RMyoXh-8opiDQQeHvqfKsAOiV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 02:29:17PM +0300, Dan Carpenter wrote:
> On Fri, Sep 09, 2022 at 02:25:45PM +0800, Yu Zhe wrote:
> > The platform_get_irq_byname() function returns negative error codes on error,
> > check it.
> > 
> > Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> > ---
> >  drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> > index c131d8118489..d985056db6c2 100644
> > --- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
> > +++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> > @@ -705,6 +705,8 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
> >  		return netdev->irq;
> >  
> >  	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
> > +	if (enet->irq_tx < 0)
> > +		return enet->irq_tx;
> >  
> 
> If you read the driver, then you will see that this is deliberate.
> Search for irq_tx and read the comments.  I'm not a subsystem expert so
> I don't know if this an ideal way to write the code, but it's done
> deliberately so please don't change it unless you can test it.

Btw, my comment of "don't change it unless you can test it" only applies
to this specific IRQ...  We constantly apply untested patches.  I have
submitted my share of buggy patches.  I don't want to discourage you
from your static analysis work.

regards,
dan carpenter

