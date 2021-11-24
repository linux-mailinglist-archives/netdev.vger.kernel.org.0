Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4895845B703
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbhKXJAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:00:55 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57084 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236264AbhKXJAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 04:00:52 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AO8YSRw015769;
        Wed, 24 Nov 2021 08:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=8sMXqF/m49truM7LEOqwqjxp+Bx2VwhbhFRivls+WLk=;
 b=wegsJDWZ+QqwNQ0QNRAnr7xzUFRvBzLqRZgvfbd26b8PSpp08YfbVOTfeRjfJwFJ9mL6
 9abeHoJTi5xscIvvqsAdOi3K0++NI94HSiH8gv2p2wvDiExHluo3d4NwB7Ah0D+1lAYH
 F4cVgajq+H1j7jWe4C3x/VyIRxDQ33wfiTMrIaA09ptlBXdRkMrBrgJdKo9HV5pl7Xb/
 IzwoPzEHfS+n4Q4WcyicwjYWAniyQjbhrjrLUbyT6llv0+MTV/bWjauVgaGmxxyiYv4/
 tzbzaoRT7fp3kF4qk0PZl7j/mD1ZFyFOuuQ5nS8ZIYjXdW08J1JsnmROPbbSFZBs5CgY qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg46fg4nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 08:57:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AO8ueC9067124;
        Wed, 24 Nov 2021 08:57:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3030.oracle.com with ESMTP id 3cep514rus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 08:57:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSOf5vIiLwi17dyeBGTSto043XX/Acdl6D5P95rW9qnnOfTi/lgyKM/nIBmtpL47/Soj/mVXvmlowTT1hLLsmEbkBdWgrgIilLw+NJEHeLkYeFw/K8vgnoi3o1sJrgi6W2M0iIpNV9qM/iXJeP7cUx8leJT1lWcCkBQx81IkUw4IkTZxSiLebhsr4soAo1mlVYjqcZhwSScgM0CwtHAHFXcZID85IADzQ2FsSHEtZ17sGQ98T3PjnGJETOXjVmp7xJ4mWaBODu+9g/VgUfKTlDnnX9Uqa6c75KWwt8XCiEUYEWh9v5BBBxFN79dCLjHNZ+p2nfV1thW5WLa70ZdD0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sMXqF/m49truM7LEOqwqjxp+Bx2VwhbhFRivls+WLk=;
 b=cTuNpKK4iuyCUtEmLzqogGovRroBzzXVAoqkYsQI6FDJ6fV35I9kKVt29+3dYAwD4z1aDlfxj8LbK1Ai2L/MgP5KglJ8qPqIa68CYvjOOODGRvaKo8Zr2RPDjW9MSNV8QJ3gyyPyEv+HS6ZVsM2yVxvzVIN34RacNP+nOUo6X8i/QJRiWLEwU/QM1V5Fwi9fc3+i3zi34ICisgSY24VeGbhLg7NaifliX4oYylQmiLVpza9oQUfPPAH2Drdok/78uuTe9hqZBMEGj+8X7ambqhjrDuixshar+qrRb6/Cszt44Cze0lmkTODJ3GU9iZdXQ7u4wwnucOw+9TIEbI6swA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sMXqF/m49truM7LEOqwqjxp+Bx2VwhbhFRivls+WLk=;
 b=P4ozlNtvnHRc5cL8vQaAmw7sGWcRZEMmeNsOMCNPPrE8LOEy2xke0nCAgcRSLDsGfiV8cGMNBYSA9Ik3Xm8S+r16yvcGlDKcE7Vq4Vc73+QbBhIe51/beH/boLnxrj6IngRW3HUYrBURmGihYrVs4MMYx2r8I+H3A9ElHAnKx6U=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR10MB1559.namprd10.prod.outlook.com
 (2603:10b6:903:2c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 08:57:28 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e5e3:725b:4bb:7809]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e5e3:725b:4bb:7809%5]) with mapi id 15.20.4713.025; Wed, 24 Nov 2021
 08:57:28 +0000
Date:   Wed, 24 Nov 2021 11:57:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Markus Plessing <plessing@ems-wuensche.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net] can: sja1000: fix use after free in
 ems_pcmcia_add_card()
Message-ID: <20211124085704.GA18178@kadam>
References: <20211124065618.GA3970@kili>
 <bccacc1b-4c04-98f5-7b97-85664c238ec4@hartkopp.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bccacc1b-4c04-98f5-7b97-85664c238ec4@hartkopp.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0028.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::13)
 To CY4PR1001MB2358.namprd10.prod.outlook.com (2603:10b6:910:4a::32)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0028.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Wed, 24 Nov 2021 08:57:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f054c524-afb9-4f5d-35d5-08d9af287111
X-MS-TrafficTypeDiagnostic: CY4PR10MB1559:
X-Microsoft-Antispam-PRVS: <CY4PR10MB1559041BD76BBCD189FAA7A68E619@CY4PR10MB1559.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yH89n473O9kdNgO0V9/xKslgs4hh1UXIWg1LetQDs7s/Ev579Bibreli5B+ov7N5m7Le0pIJ9s0pIrVEE8xI6/TBKZ0e39Tue8B+uh5EX5+cIKOQ++fQg+HANmscyKLVbHqtiJIw5E2Bjtc3+C+BYAj/SZYXISKkjeJ/cnMuLvksxnKDrP75XvFaYM8dLg9K6t+pQOgMup1UsWqlFo0UhKs1GLX912GJmRgoBIJqpXw/gfu7B6BG7jQD2Yts4cFLsA9dkNXMmoGoi3mLmUvOYDP3XHvw8i2thqKyFxvtSkdzO0D4x0SfepQGjs69X+oNM03uQY0jm5EF8tsn8SLeIS1XdTYiydhHY808Kq3e/MECTAzlHGxNfXTPzQolW4cuR/Vm6s4QXNNAhC8YY5wmZavjm0D46IiEeoPWAIYnupaCBNyTczMLUkvEYNPp+05nc+MzNCYZxDGkZi7CZZBGi0jvhDcsCHGbQKUz9Zs/i0a8G/s5NHWgxLSUyvnUCnZ3o6DSmCQ+PltIQxAvCkbOQ+4buv1B0uYkDQEZ97BG2t1i3BXNR1vjd3cCZ0uyel6s1YJoS605hvGNsS6yVXUEzP2Gv/2dAIVb8fVHt7oWTnCGx74MjV5+xEOx50oTGAGfidakpqqrEWJEnkkUaYgiCDQkdBSatVZgtgGLdsBjjmz5x1FEjZxYAxCO6u2dUSKa3MGaf7l5n0WSgdoKOKk+hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(7416002)(9686003)(26005)(8936002)(55016003)(66946007)(83380400001)(9576002)(66556008)(8676002)(53546011)(44832011)(54906003)(1076003)(66476007)(6496006)(86362001)(2906002)(316002)(38100700002)(52116002)(33656002)(5660300002)(508600001)(4326008)(956004)(6666004)(186003)(38350700002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lSCVmpTM48z1XzWbhjnW0hoJXvwfZ2LbnYAY9QG7PZ8SofaPrkxdB1FdJ3BP?=
 =?us-ascii?Q?MpjJvo3mAMhmaBu+Gx5c5d2vxyi0qWJ9r0AkGdV/e5AKVlEFyFhlrgp1q70v?=
 =?us-ascii?Q?ZKCk9V4sS+fkum3XkxfP8IK6AFyoSUycLi1Bq3wxX/3skfkdSHRQGK1wYFig?=
 =?us-ascii?Q?5s9MtG1qOIxBHD6DGWaRP7dDQadjrqu0aaTVxdbetwedsX+wTMd99ZYNThmp?=
 =?us-ascii?Q?FGSmM/Lv7EHt1XtkNMk6X0gvbwfYrOLZaw9NEg8/hjymMqkma4Gq/U6CLkPZ?=
 =?us-ascii?Q?9pqQAet3aLx8yF/i0KS8/0sL+YSvL1aqsEagDIHtITGfhxTQJi1WKvIHN6Qb?=
 =?us-ascii?Q?Hm/For8QgGKFdBvw1pYVqt04AEfv4KCUpgnIkhz43TC8XSN1vR6hUhO1GxXS?=
 =?us-ascii?Q?4GKoWwmZxirIlN0PBBw+a4sMaz0ccPhHtMIOqLgHYAUOywhiLg1s6LOoCjrw?=
 =?us-ascii?Q?Sk5raGfIdW4QEzrmA+VMvuWRponkRL56RgAAQMIlDbYmuj5M+ng5d3oeYHV7?=
 =?us-ascii?Q?T1PTdotTB0aGg28AkBl05s8nuK8umerVkzSylt2WFiKAcyeVmKNIYxprAdch?=
 =?us-ascii?Q?T8w7TgikuPtk7uWge6+61Lr18OlcyjFHCXYzYXTwun+Ieji462B+5maLyNsa?=
 =?us-ascii?Q?XHpjjn+9UVUT6yeZPCgAQSXQEuh0NUBXX05hHIz/pPV9+un7thTrn7k2QrVJ?=
 =?us-ascii?Q?9IFQ0Tjie+vh3e7HR1NpnZKTZ+MWj63of+PRpQKIb1mHE9+XbTVDYNmYwxVd?=
 =?us-ascii?Q?m96ZKBI6Z16ShfWZC8Z5PVK7nIVWrRf90ki0xx6XENe5g+rUHhccf1+dr8G2?=
 =?us-ascii?Q?xl6D56S9xjsr4Km1ZVn9dOVYDB93kZJxiaSLNhFklcG/vCM0gYx+39DW/n4p?=
 =?us-ascii?Q?6PtC9BzPYfqT4QbplLs+ZHXvKQhfhwm7hRY9n2gA7b9o25aqArBz7C3D555f?=
 =?us-ascii?Q?iKI6y1KcUacDepA7Jym2h70ScFpK1wOXnlKasQNPID9u0rH1TEqxlWi6ltWH?=
 =?us-ascii?Q?f7RNI0wS2CG+ZTyanoRlU6mbCIiVSttdmpgETD8vxz1++AU2JTrQVqsu5am7?=
 =?us-ascii?Q?NwfoPg4cBoZVNBMGUlFSmjUzDdFiGKR/v9ZZSiZEYbTdEHNQX60f0PyXPJl7?=
 =?us-ascii?Q?ktfYcwZR1wg/903HZ3Bn0YmY5mqvQW4zDVCmzin9Po/aKVrkkUJGfg0Zy6lj?=
 =?us-ascii?Q?/1wa9ys0NpWTt5wKO1Gi5q29IXq1FeZ0m2vungwDB0zgNPXwobvVZddrf3t9?=
 =?us-ascii?Q?2+u3KLRPmV23SO4oQF9FOHjji7cUEf0SZzMEW2pxGkhRnZB27ihc/hlRAdVP?=
 =?us-ascii?Q?jjpAAeO8to8+BeXAr2WNlcj9MlS8OkQlR6CqVCLPr0MZaGX3ZwKIZRYbXWS6?=
 =?us-ascii?Q?FroOkqkI4lU6lTNJGjxT/v64bY8/kGEEWUnz/rObFNefBB3/HiS0BxQ5zVFO?=
 =?us-ascii?Q?xWu2ceTbG9LPgokag5Wi/3ERgwp6wtutpotV005jod6Ac3k1Au9B/Wu6eX6G?=
 =?us-ascii?Q?ssM8DstRNSpSZl/UBIigbjA+NHR3SDsyu8G9wGlwVM7qsREE+QYaDUU366Dm?=
 =?us-ascii?Q?7PlO+N1fPNvqVeYooaMEJXFesHuXPV+oa6HizlpP+EgX+0RC5Pb/pKS25rRk?=
 =?us-ascii?Q?YuRf0kN9+6S3r4NUXdZ3XO2ars4BLDQmDsZc9snBPX4OMGYp+V+7VIvVUh/R?=
 =?us-ascii?Q?yMY/ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f054c524-afb9-4f5d-35d5-08d9af287111
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 08:57:28.2520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mte6AzzEpIPmPvIQsY/weob8/dJ3GeymArlYXoRxun7tN8MnYR69odVUDJwGYfXWWJOrIojuCpbkbBtvt/TbQaYdrxqv+R3+VcliLtACqyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1559
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240049
X-Proofpoint-GUID: qmriuXifCX2lS_lazerKc6bWsq3eFIJF
X-Proofpoint-ORIG-GUID: qmriuXifCX2lS_lazerKc6bWsq3eFIJF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 08:37:27AM +0100, Oliver Hartkopp wrote:
> Hello Dan,
> 
> On 24.11.21 07:56, Dan Carpenter wrote:
> > If the last channel is not available then "dev" is freed.  Fortunately,
> > we can just use "pdev->irq" instead.
> 
> But in the case that we do not find any channel the irq for the card is
> still requested (via pdev->irq).
> 
> > 
> > Fixes: fd734c6f25ae ("can/sja1000: add driver for EMS PCMCIA card")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: In the first version, I just failed the probe.  Sorry about that.
> > 
> >   drivers/net/can/sja1000/ems_pcmcia.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
> > index e21b169c14c0..391a8253ed6f 100644
> > --- a/drivers/net/can/sja1000/ems_pcmcia.c
> > +++ b/drivers/net/can/sja1000/ems_pcmcia.c
> > @@ -234,7 +234,7 @@ static int ems_pcmcia_add_card(struct pcmcia_device *pdev, unsigned long base)
> >   			free_sja1000dev(dev);
> >   	}
> > -	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
> 
> When adding this check, we should be fine:
> 
> +	if (card->channels)

Sure,  I will send a v3 with that.

regards,
dan carpenter

