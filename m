Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB0A35F696
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352019AbhDNOte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:49:34 -0400
Received: from mail-bn8nam11on2088.outbound.protection.outlook.com ([40.107.236.88]:18273
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344527AbhDNOtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 10:49:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=On0+wKsy8Ua1NndID7mu1oubYUkoQLhMBbnNGFog2LkXEgTo2FbP76paUhDzixY1dZwmQjIJuf48uq67hyjfnxHo8gnxagoxB2+Vtgqi9yXDw/5TJZKYd/YZAY0EcNjDRsOHZ8RAmer4k4ndnV2lWMOYw34AjOp2R7xFO300+jTaqPVQGyPVMdBqiYbGgF4qyK1FVj6pYKss71VJJjXUKv9u1d8iXvAzpEfjcBaQbHNlIZpjiWDW8/coPahkWSTyQIQDWWrdEK0kLkGi3Sc/pGsyXST2zLr89vQMP/jbusYt08Vdy4tTudxgeaQf9qGHQlOs+QgRectYbsi85bxI0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zO5NoGsjfKwxotKaltJhyPAaSl2QbETrZqt0VoOXtXM=;
 b=KKjZGacF2MZPsPTLuuJq7UqhDu/o5hHwp2lItAY0ZS4FJNUxWJkgp4rB0qoycSaHoP/H1f9Hzw4gQ/CroYwygP+e3zUcgmqFlnmRMPZRD5lAu82jihgwcTIxuXjRzYT3LL4g2i0r5DAFMDpWz8XGHJML8dFN9vqv4qX9TNjUtN/txvwvNpUl2F9M9lm04dsrwBTsCKL5h711d6svF7oTSrP0/DHxs3hf7KNaZLO++A57jsnKZddSMovxfpvwqN5E16WdWwi88HOI12fIqry9MIU8d5Igbp8kKkrp/BcVuFGlkbQERnIWUr+gE9+u/4cr/Zb/i/nPAEzktZQCmAIRfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zO5NoGsjfKwxotKaltJhyPAaSl2QbETrZqt0VoOXtXM=;
 b=mLTJXDT66CD0IvHbegDqfqrhhqtox0Z578XgaQ3vFmFLtSwjPYqvURF1sE2wRloyMVGmyjwYvdcQvF8LAN11QDuDK2ZhJyqddU3Pe4RnZ0l1/TQc5dkhCgR2J1ZCcpU1SCj7mrFA5R4mbQCa68W885eDxlRIRg7OGjEEkC0TlfQN6kIFuyataahh5OEtRCGSIK2DJJ0XX2FFAQtM2GbXr701cGnz2QYIQjQ5o4Js8tlbyvNBA4xG/n1Oae3XZ3XfjKlvUtR7AsLwAMJKLVQLoXb0vmgD3WbQlNfSBJJWGc+H2/1H5dSBxP8wfxjWMJetB/6amtaI/iFXZP0vt4qMtw==
Authentication-Results: ACULAB.COM; dkim=none (message not signed)
 header.d=none;ACULAB.COM; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1148.namprd12.prod.outlook.com (2603:10b6:3:74::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Wed, 14 Apr
 2021 14:49:09 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Wed, 14 Apr 2021
 14:49:09 +0000
Date:   Wed, 14 Apr 2021 11:49:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Tom Talpey' <tom@talpey.com>,
        Haakon Bugge <haakon.bugge@oracle.com>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Linux-Net <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
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
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Message-ID: <20210414144907.GD1370958@nvidia.com>
References: <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
 <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
 <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
 <f71b24433f4540f0a13133111a59dab8@AcuMS.aculab.com>
 <880A23A2-F078-42CF-BEE2-30666BCB9B5D@oracle.com>
 <7deadc67-650c-ea15-722b-a1d77d38faba@talpey.com>
 <20210412224843.GQ7405@nvidia.com>
 <02593083-056e-cc62-22cf-d6bd6c9b18a8@talpey.com>
 <c2318ee1464a4d1c8439699cb0652d12@AcuMS.aculab.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2318ee1464a4d1c8439699cb0652d12@AcuMS.aculab.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR16CA0011.namprd16.prod.outlook.com
 (2603:10b6:208:134::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR16CA0011.namprd16.prod.outlook.com (2603:10b6:208:134::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 14 Apr 2021 14:49:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lWgpH-0068Oy-Bf; Wed, 14 Apr 2021 11:49:07 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4053342e-6ed5-4bc1-3c62-08d8ff547571
X-MS-TrafficTypeDiagnostic: DM5PR12MB1148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1148F64FF5D229DB9C3D3CEFC24E9@DM5PR12MB1148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dc/U0xRybtFnmEb3V9ZUEUTAH38Khu8dsrx85T9TZ9OYhetBItXAz1btQj/9hl4YDijW7fletksoKeGkg2oSYnpnkgnkUSkoHD52Lh812rCtdooyf9WuKU20VOaTM3T5/Tq2ziGiU1BCVbSC9utBA2KvoXHplbtrNPpkdljMox8YZnr0KXZIYbPsG2I/71Ubv1jDF6zaL4bcAk/oFWR/LwVyt6E8ka+0G6R/d5ThGB6Gr7quK2BD1AiEg/CXo+eDgbBL2/Y7vIih9QzRd1WB6GJvjYXPryoVw/7iSrphnnFyILdkjAH/TpP/NWicqnkK4WBaj860fWyi6YZmIrAWU+U5bLyjOPY9VwPnxTVsYQc2FAd2wp+KGFifoTEIDXRnHmrFEy3MFryOmIGIdbPn2w94B1CbAaS5FB3Q+9yp6FBVWbtaoSWYoAYHhrOZ3sceoMYHMdhneiAdPDhE5hXwOssagzsZlo4EARSiwjLarIb6qlQN9sTddZSvu99hVxrDZ43UdsniBqPYMNIi4SNJ9g6vSZOlQZQ9blIOaE8TiVfl6/Z4CSnH4xEpvhLTGLmRiBV2hP4F+KHmpnfkci74ZK9yVbFadV1iDAU6SN/lyOw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(316002)(36756003)(38100700002)(66946007)(9786002)(66476007)(6916009)(7416002)(4744005)(1076003)(9746002)(2616005)(66556008)(8936002)(478600001)(4326008)(54906003)(7406005)(8676002)(26005)(33656002)(426003)(86362001)(5660300002)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Fcs4gwxFQ9tsPg4lFbTieG9fbnkmkUOclKLV3cI1ZYcXkSS3fUzqDlL2qq2V?=
 =?us-ascii?Q?u5ka/JRMfnEdyaHNBseXWzx7QD8ndvkbdYuYmNHPOaRNSpgJNiZFLPjUQh9z?=
 =?us-ascii?Q?gMkz504WoeyE443IIaNyaHAGfn6YGSQ3IUYg/So/NGWWXWdyZucrvVa1IU55?=
 =?us-ascii?Q?/0cNVXqU7BRxn+zT1P631QBOUkS88rAv5AlH2r21sQvOonKp3Kde64H3HtO8?=
 =?us-ascii?Q?1NXgXqssPGX1BwYAbG8eUCTaDglDVG5yuxAqN7aAyRj9e+XUbefMJybNVjLM?=
 =?us-ascii?Q?csxjSbv0+9HymF3wco+VcLpaeqDZO1COJGjnYcmHLVLmvW1vFRQU6cc/f3M7?=
 =?us-ascii?Q?X9NbvO9dv7BeUaYPGV8BXbh5SfFXBalfsbfQZsk6i5z0DWF4xPsrKFMqVNYZ?=
 =?us-ascii?Q?8g+MhCFC5sGvpw4NahmtROpKS8sNdLWzB/24+qF5gmaGm/8pltH+/Y1iloPW?=
 =?us-ascii?Q?XWrDic77OecTyLit68J61YkTH9SbXv3m2jLG8JZFzL7Al24B0bbUtnINGaMW?=
 =?us-ascii?Q?6YT4yMEvBHDKzsd755KLUHdHuhGbQe0Abd1M3rxQ72CEw0ue26rCLZdgUc4Z?=
 =?us-ascii?Q?O9fq1Klzp2v0epJrvEUfxr5Pk/TjkQ+mAdIDc087T+J2ID7Wd4Ps80VKWPwh?=
 =?us-ascii?Q?Ondzk16ALxcp+EX3ShIkSaEviCogEhjf1H+S/1CHwsKUITEwHXpwDoTeqoFC?=
 =?us-ascii?Q?9BxfNzvNtlE6RJpQCENwT36v7IH1Gh6qMxMsCCkDJhPhoPMcnAxwx96mprqC?=
 =?us-ascii?Q?REmRmwkvCbQpHwvviAEj6Rk5lTj4oO4wWt00ECX5Ws3VA4g8EXZeoyDMbmJ7?=
 =?us-ascii?Q?NnsncTl85jJgzSbDcv+V0Nyi7HDpvIzNbteuoRHU7yKyXgAiQSzd201jr7QV?=
 =?us-ascii?Q?XgXiL7uY+UV3g4PhoV6z/+BdCn3CA5LnHHZrR/i9tKfc9qjbxKzr0lG+YlBu?=
 =?us-ascii?Q?LuTKFunuIi3UdDn+QUmI8c6UQcYhh7n7zwKaoPgBc+r6gc8szahbpOvT3n4l?=
 =?us-ascii?Q?Po0UwEzPHPNzlVxW8EMNTKN74pnLdMVKui5qhni90bGmO9dn1XUGETycTqaw?=
 =?us-ascii?Q?AC6JVEjId3x0to48+G6Nay8Bn0E81MwVHEmDN7T3Xefm/Omf+VBf9pnPq4OU?=
 =?us-ascii?Q?0wo8E+TLGPzk8hXpnKMSuHc/iVYa9icKrmRaJ/hbzedGXETQgnMJxLiCBjXl?=
 =?us-ascii?Q?vx3LHHWOw+zvEBEGUgWqxJC+tWzVyxIgVW3CpUJonf9zf81Xe4xTqG6YlDd4?=
 =?us-ascii?Q?2f/GAWE406yXvfN5qjuULIKLeCbcz3J7v31BpeELsTJYGKIJ157IEmdml56T?=
 =?us-ascii?Q?4xQahhYDYzUiNrYWw+JAfobcXqXNyCjykS4zK6wAyL10rQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4053342e-6ed5-4bc1-3c62-08d8ff547571
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 14:49:08.9803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KC3J15Oe0Fv0gtkVf31Qnsl5m7MPF0yPgTE3ZbViDQqa7gI6EvKI8e4EJJBCTs3B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1148
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 02:41:52PM +0000, David Laight wrote:

> So whatever driver initialises the target needs to configure whatever
> target-specific register enables the RO transfers themselves.

RDMA in general, and mlx5 in particular, is a layered design:

mlx5_core <- owns the PCI function, should turn on RO at the PCI
             function level
 mlx5_en  <- Commands the chip to use RO for queues used in ethernet
ib_core
  ib_uverbs
    mlx5_ib <- Commands the chip to use RO for some queues used in
               userspace
  ib_srp* <- A ULP driver built on RDMA - this patch commands the chip
             to use RO on SRP queues
  nvme-rdma <- Ditto
  ib_iser <- Ditto
  rds <- Ditto

So this series is about expanding the set of queues running on mlx5
that have RO turned when the PCI function is already running with RO
enabled.

We want as many queues as possible RO enabled because it brings big
performance wins

Jason
