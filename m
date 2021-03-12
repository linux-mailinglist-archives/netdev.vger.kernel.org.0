Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD46338E14
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 14:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhCLNAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 08:00:55 -0500
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:18592
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231438AbhCLNA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 08:00:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPpxSIGZvH2D//fmJYvLUt1DdVvxqZEIEXck/XL9i/5i5TaHqabyiqaBTJ/ty/Xu7QQZ3eApbmQvmUC4GcUZnXSSOgyDR4jKc70zpekqafyFC0/BwrfsLwjfms5ddn8cX7P+8Jp6jQCXFPDRWv6ZeZxgD2OWIroRcEp0pyJyiOxZFN6a4idjdPtVx8GSelSGJv6PMDXUDm6gUeCjs8DbU2NpNfUd6dtYQyXG0Si2t5XNRZqhVYPyOi5p+jG4IqHTnZxwZBTsbaX2F6FiD/PIU3OxQiHBpvbTR+CGQM+MCQdCrWLZnl6LF0TqJ0ePze6jirJhe5XuSnY7xmqnK8+A4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xgc18WFo1SsWV+7bUNPDXOVoZp0ahudAQrKir8KqIk=;
 b=AE0b7uynWmcEZdzAGj9u6YA5VCXabpbmbQR6PgcMAgFWotwPr7C3BONF4TdTRmNhQmdepqDBsai3TFgiUSXUGGE/9Rsb1Ri5V/wJ36Y78ZTVXCPoO4C7cVRpqn8ykwwT1PWjipvfPYaVX1Zn6SyCcPtNtZr3HW9KSC8NstRRnm3sd0ZBsX6uaAxiyBcfMkXrRx+hgzpwFRRwTXh7STDc30PsSoZIJCQj0BS9LjD1DvM3KC6ozfoMhYJ++5r8SJwtBfXJBtf1siRctB3sYJO6X3zxwW7Zx5L19WqW6wgyly+kqt7V40IdfLJ2DQ9qajK/RXV0AB0vRaDjYT0RZEu3Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xgc18WFo1SsWV+7bUNPDXOVoZp0ahudAQrKir8KqIk=;
 b=MRQKEgDEkmiL9W9Uc+bKcs0nJ0H0oj3RSurZ1wb7h/pb/d/Ai3IzrHMN3eAO+peCNBEitaK5k0ToFew/ytvd9S3YHXAQ1gr5Meo9QaP6ju/fS/mQWcNtx1+l5EKPAS6B1TszohjA+gSItSNrC7xS90YEarvCJ93ofBsxL1VZtR0hDa0cxSjAF/MOs8Qf3a2v9McrtAfmygJCBpbK2lJw4dWmID13uNxDpUzi7ALKMaFCZbpDIfxBPAftzdKYtyySch/KHe2hElVLbWd2GBL7ZDJz69TRdzUqSpYcfKYpTTLSeWdjk4cabLG8AeKVXCwptpZ25gv6KoKmCXqd2jKvMA==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3594.namprd12.prod.outlook.com (2603:10b6:5:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Fri, 12 Mar
 2021 13:00:19 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 13:00:19 +0000
Date:   Fri, 12 Mar 2021 09:00:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210312130017.GT2356281@nvidia.com>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <20210311201929.GN2356281@nvidia.com>
 <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
 <20210311232059.GR2356281@nvidia.com>
 <CAKgT0Ud+gnw=W-2U22_iQ671himz8uWkr-DaBnVT9xfAsx6pUg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ud+gnw=W-2U22_iQ671himz8uWkr-DaBnVT9xfAsx6pUg@mail.gmail.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0425.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::10) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0425.namprd13.prod.outlook.com (2603:10b6:208:2c3::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Fri, 12 Mar 2021 13:00:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKhOr-00BtYC-QY; Fri, 12 Mar 2021 09:00:17 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7721b25-4089-435f-6bf5-08d8e556c9f2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3594:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3594E57DF42206D7E885F366C26F9@DM6PR12MB3594.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJYdoGzvxhea0yj9SCZqx3cOtL8VQSAzAoK+BcEJRoaoVKAmWa0mH3pw1vY/JWNO6XAfrWQ8UWZ128jSuX+6VCLSSn1fs8yb9Yh/dHSwGQmm2yyiIOB3gZb9XzVV7lG9KkKiT1dtz9EIJQkfOuRgGKofPGz0gtI8UnWb/4wQzBKvRN7KWARxHoBFO+Kehe/mDtHwJpA6dzdwsx025SrZocBMssF4F5B1FgdaGXiUS1k8l6iR7kMA7L1T1QehuIXJfbZOhmDSaSIG8WSVNedOaUxxUTsDeaxLKQujSgpUJcRks8coT1jtlIWCrsWLIbfgJXhhwnqezTVH/fZhZ7XrjYi5RT6g0s9k1zc/JTySovx9kNmiicuWr+ubw9WK7YbTB4QgjeUz3K5983QeeWV/wFd30h7dgFzoAcFA8sVf1rg9WbtsGBOC1BtoxyYmIuGSHSV9prd3/NAnZTUERgFAnkNcgtn/Mpk2NEU9hvU5ayLJFmbEo85Im3j9qb2azpuUul3Y2UVB31ot6fYkvTf8eiw7XdyTtrcPslzRgYljeY59+twXZxKdc9jZtX5/fcZzndHU2dO0BARWMVp4xfBhM9Gi1gtJrzHby1JCmwPvBXt/floBwV6b0gHITwIQInqSE7GYYBCTtXXDW5r5WIHfzwtGxhpDTB8ZSXVIuJEfSYdYE7igdb3W2790kBmxdT6h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(1076003)(5660300002)(33656002)(966005)(316002)(8936002)(54906003)(9746002)(9786002)(478600001)(36756003)(6916009)(2616005)(86362001)(8676002)(53546011)(2906002)(83380400001)(26005)(186003)(426003)(66556008)(66476007)(7416002)(4326008)(66946007)(43620500001)(15398625002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?J0HdOAG8hHfc+ocpqKS9PvYYRNlRPgTIpx1MScKs7Ca4NdoGZGqrUejbTZ1W?=
 =?us-ascii?Q?OIbLZYuGeiv9Jmwt3RysNktEzcud5Ao5dv7n6nHKZKC+D5YD8Kfmapv1wvOh?=
 =?us-ascii?Q?0LSlwO+mwiNa6xA0lmZ6P0r2FTpJKIVPa5HXKkGEwwfnUarON2qUVP/zmn99?=
 =?us-ascii?Q?khQ5+D4f+o+2YM6YlKK0f+Zki87Y6UI0SGKHq3hTkThiPFqITBrXNYHDXQwj?=
 =?us-ascii?Q?TghtGhaNgUL6ZhwZ5nSIkFWB+4lDaGCM3Ct0pq5RSC6lgLIctZrDBOvrZtyD?=
 =?us-ascii?Q?lKRJfpt62Yd0pKW69weyz/vxv2N5ZK3VL6k4lwoUTCjPb4Xm3ke/vwu7dcbV?=
 =?us-ascii?Q?IbZgoGJqYhT+pOePJdYSQOByybNljOfRNo/I3Yzg1bDWpWIfddBvjPrdvlfV?=
 =?us-ascii?Q?JjdTHzVGKKLtyS2KQ6ihVMSZ+vJOnVcsNVT2cPxiE+v7lwLcT7sTAfZi3iP+?=
 =?us-ascii?Q?E2UpqaFRQUIr3WoTFK30PqS4QYevvXb5dhE5GCG3xG1JVxXSKSa6U7WofURE?=
 =?us-ascii?Q?ggGnGf9otHcxzyRmUxFYrrh6dmZW1OKHeuJc8R599CseKGJZv1GtNBT2EbSX?=
 =?us-ascii?Q?YlyERgg950H2i47b4DUFLdkls5YN7me3+8o5TBJ6CA54pTqDYG+1S+oRHJOl?=
 =?us-ascii?Q?W57YuvUuSqRJkwy+Pk2dLLxMmz7DvAFpYedFTQ1W/aNWfN6sFlx7viUoP2sp?=
 =?us-ascii?Q?IXTPlSn5pVcjHq8c31N1jW3Ns4xWIGAPIBszoa8aUyx/kjVwx3bjav73w2T0?=
 =?us-ascii?Q?xsgxnumF8AU7NMEFbMf0QGO1Tt2A1eVmXhbU57pwAnSZWZGF5+gdWl+iMOw/?=
 =?us-ascii?Q?PFgL1QiWrpN1pQdW+0cGfLMJe0VYxf91MNiyFuiabo2qoAzxTIlJyuRjOgXn?=
 =?us-ascii?Q?ENy3lebCdeZuPvyRSVZKnTP88VZ9g72qxyMCVBRURGYVRtm1SVc2ytOJ9peX?=
 =?us-ascii?Q?UbSnob9NDk4Q32zJKh5FLQC65uO3+gfV2ZJU8qVtlZzBv/w6FpO18B3b7gWo?=
 =?us-ascii?Q?k3UcsumPWXXLSFmHZJR51N4CV2jYwp1l/WSuQ0Y83W1arVCoSyazLcQ66NeQ?=
 =?us-ascii?Q?vLqM0y3l8Bx1tUQM/XKDJnQJtEv/Kv9E7X/dO/wwJ93Xkf801PBHfjjCjCBe?=
 =?us-ascii?Q?nMXATSsLJxka3iEfZsFe7E6jv3S3kV4HAIB6xty5a6OIfVero6BkmYlT2E1/?=
 =?us-ascii?Q?SQdCOjW87Ihd8WWrmX3zhrlbDumDBPFXqVVtPuElFPQM0LwTdppuU8yiGCHu?=
 =?us-ascii?Q?Rqz7U8B0tWRUeIH/L8uhePHx69NRZxjEQQj67nMTL96O3DvdNnXGJN1KUv4I?=
 =?us-ascii?Q?fLmiYJkNrlQUlaaKkXty5g4m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7721b25-4089-435f-6bf5-08d8e556c9f2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 13:00:19.5388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OyA6aTE3u4VEs+TzBR+cbcGjpyW+07RvLMH4wfEeBR62C5ERv5gi4vA8FKtE4x1W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3594
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 06:53:16PM -0800, Alexander Duyck wrote:
> On Thu, Mar 11, 2021 at 3:21 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Mar 11, 2021 at 01:49:24PM -0800, Alexander Duyck wrote:
> > > > We don't need to invent new locks and new complexity for something
> > > > that is trivially solved already.
> > >
> > > I am not wanting a new lock. What I am wanting is a way to mark the VF
> > > as being stale/offline while we are performing the update. With that
> > > we would be able to apply similar logic to any changes in the future.
> >
> > I think we should hold off doing this until someone comes up with HW
> > that needs it. The response time here is microseconds, it is not worth
> > any complexity
> 
> I disagree. Take a look at section 8.5.3 in the NVMe document that was
> linked to earlier:
> https://nvmexpress.org/wp-content/uploads/NVM-Express-1_4a-2020.03.09-Ratified.pdf
> 
> This is exactly what they are doing and I think it makes a ton of
> sense. Basically the VF has to be taken "offline" before you are

AFAIK this is internal to the NVMe command protocol, not something we
can expose generically to the OS. mlx5 has no protocol to "offline" an
already running VF, for instance.

The way Leon has it arranged that online/offline scheme has no
relevance because there is no driver or guest attached to the VF to
see the online/offline transition.

I wonder if people actually do offline a NVMe VF from a hypervisor?
Seems pretty weird.

> Another way to think of this is that we are essentially pulling a
> device back after we have already allocated the VFs and we are
> reconfiguring it before pushing it back out for usage. Having a flag
> that we could set on the VF device to say it is "under
> construction"/modification/"not ready for use" would be quite useful I
> would think.

Well, yes, the whole SRIOV VF lifecycle is a pretty bad fit for the
modern world.

I'd rather not see a half-job on a lifecycle model by hacking in
random flags. It needs a proper comprehensive design.

Jason
