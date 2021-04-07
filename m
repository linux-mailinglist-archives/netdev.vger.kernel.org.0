Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD29357454
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355306AbhDGS22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:28:28 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:56800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355308AbhDGS2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 14:28:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbdqMlJiqDwHT7oBQ7xqfK+BzjMi7YvPldlx1ud2NVaWFtff5g1u+cers8BEptxxgctGbDW0I9K9fUwJRZ5nC7hqL9vcy0CZMUu3reavQSchzpb80TOdjDfMAkbDQFFCBNwOew5hktTRAzbVdRB+Y4xbvR9Ns8Kb7vPdkMFVTSkHxJM+Dd9GGcYyd5BiU3JoWTzwKPwaPas4FpY2Fy8VJw8XT8GyugrVywHwOZPQLEQManxvT4F6qPLv71qK9763uvLZqdlJr5Bo3pLdNuwRHU7NdQzMO8MQpsd0LIWiK3hxbECevFmrfQmus1Xne5LyPKHmYLhTI9U69/nIHWUCPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyChI4sBAPKWAco1y0aOEOq/jAQhfrRkYEYsfoKCIq4=;
 b=FVADORiA4wTJu0KJoq5cfIhCfk6euoV/wk4o5ZQkQbqFlKgDkEX1um/hmCOcoVIeujqpDYx/On9PF4iOfrnBHH/qxG/Mk+Ppcn38rUTjzr+I+9p15mG0f927O5uurUvjbACa6g+zvrDFtEURrTq0Zu2433WkO4y05rOzpbux++X5uhwNVJduT3vnOiwPz0ZriwJ9BzVUh/qf8n6kAikKd8L2CLymwFsQxNLDRSwPFfJO2oXSJxfO8ELzCD1R2Zk/qCgwErKwTgrbCePr0+WwFa3F8VscU9eLEemCKIHAbBpn1YNcCulrCljDqURLOSAtd+0TBiNgJ4Del4kFiNvVKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyChI4sBAPKWAco1y0aOEOq/jAQhfrRkYEYsfoKCIq4=;
 b=g/o3Em73EUVZw9g/HkcMD/obeLRVmsfXGJEJRyRPmIJujc3P3a2sdVzTqFjAFvc/YvLUuudw/cHd+bTo6XQEBnuP9j8CN4Zh4hn+21P+d+DQW2+QYi2AEgE+WY51I9rkjACFPdw7D+NhwJKq4lDSZMLv0TpJ7WiTN4/4rNaAcl6S7uuKKLa1uh3ZeOBTVqEYBy2DCIhCmAoIkIwlWF7YVxld9Y1LXOw8SK1iq6IBZEbJvjWDk0+HPUubc7EOstrSapY7itNkbzhH22xnISO5GwRJA/DtVbv70bOEXEXMHkFiAwBctQZ+40mmnXGqhL1RK+lGWkG072ziSZ3P/PO8XA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2437.namprd12.prod.outlook.com (2603:10b6:4:ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 18:28:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 18:28:13 +0000
Date:   Wed, 7 Apr 2021 15:28:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 01/10] RDMA: Add access flags to ib_alloc_mr()
 and ib_mr_pool_init()
Message-ID: <20210407182811.GK7405@nvidia.com>
References: <c21edd64-396c-4c7c-86f8-79045321a528@acm.org>
 <YGvwUI022t/rJy5U@unreal>
 <20210406052717.GA4835@lst.de>
 <YGv4niuc31WnqpEJ@unreal>
 <20210406121312.GK7405@nvidia.com>
 <20210406123034.GA28930@lst.de>
 <20210406140437.GR7405@nvidia.com>
 <20210406141552.GA4936@lst.de>
 <20210406144039.GS7405@nvidia.com>
 <20210406145457.GA7790@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406145457.GA7790@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR22CA0016.namprd22.prod.outlook.com
 (2603:10b6:208:238::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR22CA0016.namprd22.prod.outlook.com (2603:10b6:208:238::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Wed, 7 Apr 2021 18:28:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUCuR-002JI4-8y; Wed, 07 Apr 2021 15:28:11 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea7aca26-63a2-4526-8350-08d8f9f2e700
X-MS-TrafficTypeDiagnostic: DM5PR12MB2437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB24378F89F3B6CF65D4B15844C2759@DM5PR12MB2437.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: heawpVH7Az1lMCa8K6SHeDrJb+PHSxrGthL37q97MPNj4nGhMTVwhip2EjQ2yunaKBPoxBxwpVGeu9Uma2K/oa9pbI/MYIvWE+kFrxnuIbXzNDNCBdFVb99LHUUzHC2C6OIIDkDBL0KsXF9P1Zx8HfY2Xci92pbdygHTdxxd2ZVEhLE8iD5UPVdh5P/qJagYzBq3sJdKgORIzl/UzgGl2MEz+nr/2aOE8zPD8XhI09FJiyVbcMIk21bcsqvdrmC3LYeh5ugQ60zo7BW+c7+Es9vian2CaOUp0yziqU5bzs+T3toBUpdr4Z4FpOdg/0QkTyAbNEN/zsvn+zB2KIHHNjpZZchxcZJbTD/7Bqh6mRFQGveIixKnhTSe+gvoz4cTPn97I7EcMeHgEQ6Ru+3mQZLHKNMgtAO7LPOoQ1TlYksBGLaxvROQnIUCTw2BPJKr/Ykc+9RNtTjvVk3E8dphjL05IkoO98Mq+TBtMtDw6pKTR0R4Vg36le1G6nvHI2kDq6kKoYG7R1QVtJctwwKBRpWIhESk99qrMXaDZtYUQqOZuuuTR07dyJWwmINImvOTu51n6hbI2DQheByaUt4sj1x4BMzDDunN3HQtWUkLN3smB3xBtGwfETLhXoBPeD8FqAwzXM4y/D8EUKwOJnDqUe2Tzmxy/hRxynepkaVJrZo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(66556008)(66476007)(66946007)(5660300002)(38100700001)(426003)(2616005)(186003)(33656002)(2906002)(26005)(316002)(4326008)(8936002)(8676002)(9746002)(9786002)(83380400001)(7416002)(1076003)(478600001)(86362001)(6916009)(54906003)(7406005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UlpmIgywqzKR97WnD6m/PfU4j8Ke1pwl4QrpBbZMnG8q/YkYGhAitD8Q0UNI?=
 =?us-ascii?Q?vNRBMOrsc3PgLfGA8xTr9Z366XfLRqy0G3TMldjunempZcMHkArd7DjtTSYp?=
 =?us-ascii?Q?hbF9PWuh3ILjskJTkDXyFbUtVwoaXoK55idxgA38TkzNvUN+frGPzoPHJqx2?=
 =?us-ascii?Q?oyOyYoANzi1Y/9Z6dbTT5o3DRAC98PlbK1GdOiq+nyKaqvcxWe1Ao0B1axt0?=
 =?us-ascii?Q?jFo2hjTvZeOUipEM1zxCzu2+ruVTH4Xisya5h0jRmKdTmQGuBdsd+Tc9c7GV?=
 =?us-ascii?Q?iOyeZTgJZlBJogvqiFzLmt+3oBT4OPyP4jrHETUC3+flPKrDprqH4y602pIV?=
 =?us-ascii?Q?AJ3qJjpeJOvnrfmnS1euGfXf4WxTclOfNJWk+5ohUHTiuZ0knzmHwrSHqGWy?=
 =?us-ascii?Q?VyJ9cn52yMRWIETgw0JdVOqZJwmHBTgd7Bup0rzL9qwXMlG78btRVuAVSVnr?=
 =?us-ascii?Q?OR7VqjcnC9TmLufAim18DFqa8y9R1SNbnfixKSfuEhi4Ybn2WmwnrE6HHLwT?=
 =?us-ascii?Q?5yNuCMSmGjz1FaPigF1vNbB1yD3kIJrNBqeYEt2xqhJ77fRQu0i+y5uUp0Rs?=
 =?us-ascii?Q?AtlLaRR6PcPjmsJvHrBmc6TEeEExyinTvRD8elOUl9pWbxe+gEBOVV8fiPiY?=
 =?us-ascii?Q?6WIyagV+DdgLMswTD0ZpUT2hCwvWFkBIBGE8FxMSU+EMBQGDJO2J2RBW96p2?=
 =?us-ascii?Q?cG41bpwB9fjS1p5ICLydR8tpijIjhqxRTTZ092kFcB6cgHXUnvm/AxmooTY7?=
 =?us-ascii?Q?/fetj7Sm6xufkO5o8+cm2iur/0NEct0885BIEsS66b//4MJbfjc2GR3ANwWP?=
 =?us-ascii?Q?/+WrMx2IcVVeDEDgOU6L4tAXc+zrpUXQwQTog69q67PmCvA771wdkINdM1jI?=
 =?us-ascii?Q?ZDDoxJ5hvm2hne5wXlLEZmZSpsSjQL8KtVHWa/qwnaGP75mKloMpW5p7SQSh?=
 =?us-ascii?Q?dcHEVS5cXTeQKF6fSFHocRulYxexaR9aDFFfDs/Q4HMHFB0FoElkTwO3de/z?=
 =?us-ascii?Q?r7v0oJXCc+YFO24PhASAjrEyth0DOxLBokNW4ZP7zszPXnR98BfwlBj7ckT1?=
 =?us-ascii?Q?aE80t5SU10eTfo1jN+55VxI1EV55M8Y0LvDPofCwmmRX/Fw9tyZvALP+fwqf?=
 =?us-ascii?Q?rxFM17l63g6CQMbh9Kmxia8qba53qKig6ZIZAESqgIudG2zNIBs3p7sJuUVh?=
 =?us-ascii?Q?aYF/cft+nEdPsle/jGfv6rSduhM+y1sI2l0gHhgt56LGXk37FrjRvd9XZYna?=
 =?us-ascii?Q?khLc0JlbW0LlOpp34NIg8dFkpJnDPkgqp/N3b9zbTIWOAxUZcFL3x6ej062r?=
 =?us-ascii?Q?BbtScPAproyFIBfwC2mAaZKhK17VDTXTaWeYu7z/bCa0Pg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7aca26-63a2-4526-8350-08d8f9f2e700
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 18:28:12.9585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qcw8OKlhnWWqiigIafiMjQ5WuWwRNwWrx2rJbMN76jOotAkWPPjc5DNaj2zYri+S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2437
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:54:57PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 06, 2021 at 11:40:39AM -0300, Jason Gunthorpe wrote:
> > Yes, but the complexity is how the drivers are constructed they are
> > designed to reject flags they don't know about..
> > 
> > Hum, it looks like someone has already been in here and we now have a
> > IB_ACCESS_OPTIONAL concept. 
> > 
> > Something like this would be the starting point:
> >
> > [...]
> >
> > However I see only EFA actually uses IB_ACCESS_OPTIONAL, so the lead
> > up would be to audit all the drivers to process optional access_flags
> > properly. Maybe this was done, but I don't see much evidence of it..
> >
> > Sigh. It is a big mess cleaning adventure in drivers really.
> 
> Yes.  When passing flags to drivers we need to have a good pattern
> in place for distinguishing between mandatory and optional flags.
> That is something everyone gets wrong at first (yourself included)
> and which then later needs painful untangling.  So I think we need
> to do that anyway.

It looks like we did actually do this right here, when the
RELAXED_ORDERING was originally added it was done as an optional flag
and a range of bits were set aside in the uAPI for future optional
flags.

This should be quite easy to do then

Jason
