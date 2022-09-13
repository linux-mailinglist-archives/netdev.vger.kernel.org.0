Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F555B6BF6
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiIMKwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiIMKw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:52:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8917D5F121;
        Tue, 13 Sep 2022 03:52:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28DACnrG002349;
        Tue, 13 Sep 2022 10:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=5qo1Utyd1zJ0mdN7HihGaqzHR8UyUXa+Job3UrTgBkk=;
 b=lVMB5WCvZ/NLryLRLHm9ezwoF/L2NbkFsIrLRL0JGce6GD3gcCzyWMlRMN8Pf4vAZmR1
 buOuKIRDp3FhTAPraktT1tIYEk7F4nzebtlGAk4usrVl3UrJ+7fAqsiuwSkOR+0zrPZx
 gCi8sv2dtR00lBBVFJOKzF7pDWjWf7xvUGUrkmEPr7TtXoIQvSWaf//loRWv7u/JeXHw
 jlWtrhLOTtP5WDicgymnwI6SNBCPgM2rRFMYbSGUQyVBet1cwAb0C29Vee+b5fQU6dzs
 95uSs6nzWOk2ENdkkkQJWZmzVBYITIbVJ3ao9Hd1zEKIb9RVzob6M/QHsC5/P9LdwHjD Ew== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgk4tecme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 10:52:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28D8TUbe034839;
        Tue, 13 Sep 2022 10:52:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh13ardm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 10:52:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlSSgQZps8iuRWnW/lRvR4n5gD3NxKsTJf0NlaD7vnCRuIEc2bKVBPganwx+TNXHUC2OHPQbz7urI9PJtUg3zJhiOlDVAVdL7cqRV8LbYGRyXy6Yi2PLJwN1Z7Xt7Jj2gew6j2bW07QiQtBgNx5Cp1WC2t0cK920I4wS9lOolQCz9dm1xuw8uJFiccB7t+0SV6i0WfgfQ3fvAwllbXtKypDLzSBPDaqEnfdqQYziSn0Lii8PIPw7D6fWof5TrPwtaV0SstnjdWTx8e+a9SEMvG/7sLAEO6PzNVBY/IlKB2EYLv0XuNUJA/HeXZA07Wfi9/w/ki5eGv1gYsF4aezbNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qo1Utyd1zJ0mdN7HihGaqzHR8UyUXa+Job3UrTgBkk=;
 b=YOhdMKAwj1OHd35P5yLz/tzTpTIG29LKn1vsp6jpALLXBYCL2H9856r5CfNY07WL0ShH+L+Wb8CJWeBFhjk7irh4FIW3EVjVhVZvGKx+f1dmy1B7lXEFUDV+nBVjqijqbSOCkSgNn6UhkZy5BwPXZbPQ0uJ4gxzddGFmRM9WUNOKs3O51KIx2RpMJoXzquKaFIoLk9qNM9kTvTqQQ6kcOmRrEcx33plYS6VHi/6pBXyTz9Uzo8nOPbLWIq69rhb0LKPwzRG38LRwe4frJL6mSlvHItXZiiMfKMiYvwcFsQ45IgqU3Y1Yp4JbEDGKt6HHIltZHzSS9bNQJjACnx1xVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qo1Utyd1zJ0mdN7HihGaqzHR8UyUXa+Job3UrTgBkk=;
 b=Ax31aw/ay+BM+ZHXD9dPdxPoBbGQqY22vxpmTFmcq5pCeWNIgpUEolccxllk4iDmf9RA9P+ugRhMe6+lQOh5zUd6lESI7t15Z1zbMKuSgfCa8gUdqrnizTiK94VxzU57fH8/eHKg5ykul7uLbA86Kidms47iJrLW8XOaSJFBBe8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH8PR10MB6337.namprd10.prod.outlook.com
 (2603:10b6:510:1cc::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 10:52:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 10:52:07 +0000
Date:   Tue, 13 Sep 2022 13:51:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Yu Zhe <yuzhe@nfschina.com>, rafal@milecki.pl,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, liqiong@nfschina.com
Subject: Re: [PATCH] net: broadcom: bcm4908enet: add platform_get_irq_byname
 error checking
Message-ID: <YyBgx8JxmbvR0XS9@kadam>
References: <20220909062545.16696-1-yuzhe@nfschina.com>
 <Yx8YDUaxXBEFYyON@kadam>
 <2380c655-a6ba-7cdb-06d1-9c7856ff6cce@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2380c655-a6ba-7cdb-06d1-9c7856ff6cce@gmail.com>
X-ClientProxiedBy: JNXP275CA0009.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|PH8PR10MB6337:EE_
X-MS-Office365-Filtering-Correlation-Id: bf9c01ca-2a02-4784-c83f-08da95760048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S5qFd2aXRcA+Nc9Qfw5t2IfuSTwvWwSMv1y7qSKHmVSjCxb5Fma8kd8LQY7MoLSj9wzmh+maprjJGCHpHmi4ahWYGQYBwNE3SfMvRj5s2TP8JOviis+A67c3mTx6Aw5usWUedXGaMmDJ6HsyAhWTR6hBB8G3n2xgIFUBFRaWHe32ppAwJ+HuEIIKemZ9pbSl9rtSEw08tBxskGc5UZLdWzi7fKo5yZog4TTJl27rF9jXqc7FIruL4nlXUjF+gW/wj12OfA8LIeSFZmKNKuMo602k1jUflbLC3IPjGtXzOLLFAQRYIQ9bm8UEWa/pTJxtv496BfmW9tGyPrEzQMkQrlhv8nMiz6fICwnSG3ypA21W7We2UntFbDMaA8Op5UWCIWVEj6YkZ2fNBkK9zIcWoC5Pgbh3xv9MQmvOh1qB4b/Fz/QWkCkDd3QcQpZ/wHXSa5B7W0QfYlMwgy2jqOrcRS0VYCjTqP7dIDAZEr8ZPtkrQW4HfexWecrGqpj7OO8zIOKsGRlcCZyO1jmkA4vp9bl13u7LaR4OPr+lpirq6MPqZRSaI1O5xh+kkQOraqSxw3FKooeiCMZ1Sj5hsAJ2NS9m0BxrWUYveb7NFIDKcvkqnzCHpQaSShg5NLY70/VN0MTqOfJyQOYxAeMm1xsrtEI+qKpRW/TbqDUOEGSvGUXnkHl5tTqKHUEU231OCMUZKfZc9LrtMBghVkGk6rf8HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199015)(44832011)(66556008)(7416002)(38100700002)(66476007)(5660300002)(478600001)(186003)(8676002)(4326008)(2906002)(316002)(9686003)(83380400001)(6666004)(26005)(41300700001)(6916009)(6512007)(8936002)(86362001)(53546011)(6506007)(6486002)(66946007)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?feeiMQ3Bk3wVpzeeSiRA+8PhSTFXLhq3lTvCxA4SISnoXp3y10CjMYbGt2fE?=
 =?us-ascii?Q?/PvTC2OyzALFBg2kEd4vHmKxP5Vx028lJXK7JPLfU/k5vXUVyDGFpVCFg9No?=
 =?us-ascii?Q?zKqOft7c1E7M46D7ooFx3b5yjiGTZjPWJ5JxFh828+Uw+0YFuCC+bulQjhTD?=
 =?us-ascii?Q?O7HPwEJvi9iTk49b5GtPt9KtNKsANvLPL3xITdO5g4T8ScmNi5D9Jf1mvMA3?=
 =?us-ascii?Q?ru8ZdBCzF/yMNSYHBNfeGiyCTl1HbFa9TAWbnqmnRnTJbVAaJjAe7wALD5jf?=
 =?us-ascii?Q?mOaIh7tyBVPUs6c06U/q50/pnKQhDXjmnZZNrWJaY9k+ZKQhrIV73KcNbZNe?=
 =?us-ascii?Q?fX8YXoE7VBrWkD9uzKT3fQWdmgoO4o7+MUoZM6citXsLpdtJw8s3BHH/Gr8r?=
 =?us-ascii?Q?f47hki8j0gX5tw6LjiAcSjM4tAvDjgr9dijuIATjcUj8mvCoaTILtrjyB3VY?=
 =?us-ascii?Q?9uWFWvPU+2xsgR26vvFIZ7LHNKNU7ceHsFnzOg8yIYJRuTIAApEYivQPorpi?=
 =?us-ascii?Q?el0Tb752mopALvgdgOOqMILCjz6bgAI1LF0lNyh/7oK8GWjvFKzDdT/FC7Gc?=
 =?us-ascii?Q?fQ/1CdH8NUGCMspgPkXfzpSSRbQPrs7S5wGjYRYiQ9l1WgzQPhErvCCJotZi?=
 =?us-ascii?Q?U4E2vcZ/zRTiza8xdLYQyA8zOow1j7VHC0Ex2t47A7AmYnCAgq82B1nRda4W?=
 =?us-ascii?Q?40IuW0+mvXqCtshAOTZShxV9CxSu+IFv3L25UZ3JX6zmdPuh9QhyXBAdmFmG?=
 =?us-ascii?Q?G0VL7DEhoT4tH8VkySsOK0JtJtj30tImaqQY4a7dAvtPloZKAqpQyEoy/ZtT?=
 =?us-ascii?Q?AU5Hl/HaMsWNpKRXgx5SIPbeHb8V1ciqlo4M8KPAy/eDpMq8mpUmbwShe+a/?=
 =?us-ascii?Q?pGSOC3VuF/JgvLvFBSZYLckrTC8dWARUND71iXWFADPM8mgDq+dgnV7+sses?=
 =?us-ascii?Q?h203DzvvnuJNf5hhiEKrsoM7GuOjN6hA7dRGjUVK4nMrQMR5cI2ASF4RNiQ+?=
 =?us-ascii?Q?SlkRv5N8GWEqKlhl47utVK55M43nygUM7n2+1HSKwj82VAs89bICyN+6jGrC?=
 =?us-ascii?Q?sZszx1udJpAtUgQ05ubjV9O3AqhY4bDp+oY9wOR3QxgMFbyXZtRfAMZiFruD?=
 =?us-ascii?Q?UWxVbpBH8kiCUSwOdzilLC+4hMC4iPKsWvCt8bUpr8zWDyUlX2esvDeJPvxf?=
 =?us-ascii?Q?9vZVFrbWEqYmL/Rzalf6qE40bWj64/p2n4HVDnF4kvHWoRktvhP2VReWb3d+?=
 =?us-ascii?Q?KSW8oyiK0DbDq58kngK3UBGDb1Dqpcid25pOR2CTCE0RT2Z5S/yQOsveBzdH?=
 =?us-ascii?Q?YbmP9lllntB53x2JWr5fRLWWeH3P8ZPerxNmlDB54IRyk0CMmxeehKr2p87Z?=
 =?us-ascii?Q?LQyoF+g0JfFMJhwQAGSZmCe9MTSoLaxBHQp9NDKMUaObQ1SjnbvKlGHxLevz?=
 =?us-ascii?Q?e3mww/AG2XzmhTQdRxtREnK5BBv6qGOJaSRLK57Yuyn99DLjY+ndVFu6vqqY?=
 =?us-ascii?Q?wzkRo7Xbs2g+Q55XYxgrQaNPmVmbs8iddeTW/hw3yMXRQ7c4p+Ja43kLO2gS?=
 =?us-ascii?Q?BfSeVLI/abJRvj/3pU+/MN4C6jb51OsWe0sST+DSpF69uLuXpRtLw02yGiEo?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9c01ca-2a02-4784-c83f-08da95760048
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 10:52:07.1826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOSJag/4nMGRC2sCHk30KjdN6ehR2/1GILeLSlLxmUyBjVVoM3IfFE9HCiYQqytDSKgPT8RdHjKnysBBsY6u8QY1ACBZueGp5lEGcXsGK7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_04,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209130048
X-Proofpoint-ORIG-GUID: 8S3IeFdoomC05qh8S0yJJUm4KyehffOP
X-Proofpoint-GUID: 8S3IeFdoomC05qh8S0yJJUm4KyehffOP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 11:14:42AM -0700, Florian Fainelli wrote:
> On 9/12/22 04:29, Dan Carpenter wrote:
> > On Fri, Sep 09, 2022 at 02:25:45PM +0800, Yu Zhe wrote:
> > > The platform_get_irq_byname() function returns negative error codes on error,
> > > check it.
> > > 
> > > Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> > > ---
> > >   drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> > > index c131d8118489..d985056db6c2 100644
> > > --- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
> > > +++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> > > @@ -705,6 +705,8 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
> > >   		return netdev->irq;
> > >   	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
> > > +	if (enet->irq_tx < 0)
> > > +		return enet->irq_tx;
> > 
> > If you read the driver, then you will see that this is deliberate.
> > Search for irq_tx and read the comments.  I'm not a subsystem expert so
> > I don't know if this an ideal way to write the code, but it's done
> > deliberately so please don't change it unless you can test it.
> 
> Yup, the transmit interrupt is deemed optional, or at least was up to some
> point during the driver development. There is however a worthy bug you could
> fix:
> 
>   static int bcm4908_enet_stop(struct net_device *netdev)
>   {
>           struct bcm4908_enet *enet = netdev_priv(netdev);
>           struct bcm4908_enet_dma_ring *tx_ring = &enet->tx_ring;
>           struct bcm4908_enet_dma_ring *rx_ring = &enet->rx_ring;
> 
>           netif_stop_queue(netdev);
>           netif_carrier_off(netdev);
>           napi_disable(&rx_ring->napi);
>           napi_disable(&tx_ring->napi);
> 
>           bcm4908_enet_dma_rx_ring_disable(enet, &enet->rx_ring);
>           bcm4908_enet_dma_tx_ring_disable(enet, &enet->tx_ring);
> 
>           bcm4908_enet_dma_uninit(enet);
> 
>           free_irq(enet->irq_tx, enet);
> 
> We might attempt to free an invalid interrupt here ^^

Freeing a negative IRQ does not cause an issue.  The irq_to_desc()
function will return NULL so it becomes a no-op.

It's ugly code because you have to read in a couple different files to
verify that it works...

regards,
dan carpenter

