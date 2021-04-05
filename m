Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845E1354758
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 22:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbhDEUHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 16:07:54 -0400
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:53152
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232752AbhDEUHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 16:07:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oP4v8xgXJh7wX0WF6KfcYt1BZKAqVCD3ecsTyA8r77UtpKlig/ZA7LpXrbQ2k3he50tFYkmVK2Z8ECLAZ6IKJAvrPAe2PW72v3BvJVz6Es9mPxKNwq85SCEpi/NrtxPJHQRUqmm4qx1uotaxsXPYRtB0eFhmCAdMBUisZRDbDLdqqsbfNnnizJUNkI9j41wgZlTFIZ9vp7wILzhYnk/nb31RKNRYvDH7vpffMoD/tL7YdoDGcMMbtkVmNSyBItfc7Ewmu7oeBfA+Ja61IfkWKWclpGm6/mupTud8Ff0/WhOSbtFAZj0ulFBwjknadkdCnZjcyyudfAWfaY/aI+eeLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/nNy5d3ferFJ12C5JxIISPWWcb5xgmyHOvBmXJMgHY=;
 b=ej4VDWwwaj8D40cs+H9I6hbshDm3OgFZXqYmnwlJgk+v3NL6uLxN/p1sVocbOrtr8DyiHCecfa5A1ZR65STjwBrGLru4Yw2gkXgCbEkwKwet+EACz4BxayPgch6tZ2dcObMufUBBFvevp39EZSJ/46z+Wq22VZymu+iK7bS5mqJ/uVk5AxNs5hyyqjYTOwV7sqPYpz6FforWVQbA4NNWF1hv0BduZNP/2X8sVr+JvXJlpp9I5rSnq/JajFqTCu7TDQjvpDuvlANI9ZeC6JwGqv+EcMDKIyiFYAan/ZkKzjKNRVFSDCLF2PQbNfFYiZXZt4Q5lllVeMZ9drM6Pl5Bgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/nNy5d3ferFJ12C5JxIISPWWcb5xgmyHOvBmXJMgHY=;
 b=YaCwjAAHJnqy1nuGttymzQLkRI4mnXYiHOzsKwMB7s1c1T+ITLe0PzbzO/lkRBgCRp/4rzrasWAwnio3yXE+CUdGs5qDLkB/V28k/7Z9UteLS594nlfZfU559afqNcstha6wj+tXxNkMCfzemDmQqS5HLCOHAXdE+YZQF6HotykZ7vLBd3uhOvSA63UIaACCLoifVfKGk0G61xJBWwdOtvk9W9w/s5KomJtj03q/BIJY/jKcMSc9DHfLDKpLAFVIYFDPw1eEiIQAADALpHtZw3YLEVMuHlpP3UMil8mhq4NH68ub2O0ILCUSstCorPAf4wVfOPmW9cd9iorRSLhYeQ==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2601.namprd12.prod.outlook.com (2603:10b6:5:45::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Mon, 5 Apr
 2021 20:07:41 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 20:07:41 +0000
Date:   Mon, 5 Apr 2021 17:07:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
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
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Message-ID: <20210405200739.GB7405@nvidia.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405134115.GA22346@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR06CA0027.namprd06.prod.outlook.com
 (2603:10b6:208:23d::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0027.namprd06.prod.outlook.com (2603:10b6:208:23d::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Mon, 5 Apr 2021 20:07:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTVVb-000tsE-LU; Mon, 05 Apr 2021 17:07:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84471cb5-c7be-4f0b-30c2-08d8f86e7775
X-MS-TrafficTypeDiagnostic: DM6PR12MB2601:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2601EEC348FC6E86E4227214C2779@DM6PR12MB2601.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NHNTkdOlA/aWZMLR91pcCzLgboahKPGPdx3XMscdxQijU3GVRO9QMGkq0P2RcaxWLRDiIMpFKQvkP0OuGkPn+ucOWa+QpijJNe1G9cD7futxjPQAlgC3S8SujpjP5TaNobfIp25T4dXR+vl9WymYWJ7d97hjhoMRWkzzSawtb8DL2YZOgvuivF0PQmYqVcjmBNRFwhLXITdIDzwa2uEOhHRASVirtBedul5Y5/A9YBWQKw1YI69mRAJqtl6Pivt6+SKy+9dZ/HJVLGfSFMJJVarFh9D+UVz5OaqyD18l8TlDseSIOqiDqKb3WCOgAmwNuBImz1eXOhzqzn+OzH1VqkTf0JpTgSpGgjSTLD5K83GXJ096BbFuKqDBB9Mpe+2uHgQaoHZX+Hebf0ipGtT72NJqH1hEUqZmAH1KW8jv+ud2EC6WAXDVZZ2iZL6e4MA018+OPO18uoZh7h/IdRSp01zrzpFbxUZSSZvPY2KLiQrWEOdgJMfoXMHWGSm5oZdh/CROKu7kP1pj22DIrZgjTnBfYSbGgkCPTXrIJwDU6156ShNRZqjg6lIwNLaqYDJfeqQH3BtXemcEmL0hqnYsZ+o1p65+w2p7UoKnLdqQMt866TCbBpFOmnWWvBGfW8eNagtBlFIiaLLjE8/xz2WjS/S2X4OlAwKde1AXM5uPfkg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(478600001)(1076003)(33656002)(26005)(6916009)(186003)(2906002)(54906003)(66476007)(8936002)(7416002)(4326008)(8676002)(7406005)(2616005)(38100700001)(5660300002)(426003)(66946007)(9746002)(9786002)(316002)(83380400001)(36756003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dqguTN/Lil2raHacxDUb1fBWY5uYIBxJq0o5eoU8qvfW/+b+SWmzTaN+X7zH?=
 =?us-ascii?Q?VuUo5o9IkAEBAz6i3ydb9EgU0PLpwj926RYwVrALCo94gzF98/rE390oTy0r?=
 =?us-ascii?Q?r0t7rCr8r4cxGo9HadMvqE//X0JPRNvcZJvkmRfryHkFiC/BfKKIaa+r5qpa?=
 =?us-ascii?Q?OojIGRjUtIJUnpSRtXSdWF0foxml9vDSoexPK1RwY+6DqXNc86Jc4Mocj+KJ?=
 =?us-ascii?Q?5pcoOSHJ5J5iunwFIAz95bHfjX9RD+0aBybnrgMOazXAj/V7JA3abFR2NF0N?=
 =?us-ascii?Q?oeHuoK0IOoan3aaYPvQiSb44OLhopO8XTcKUQy6maCJPpUP98q8EEq2XcR04?=
 =?us-ascii?Q?ns3LXlX32mJhhq0kdrQWTTQHvLnIVoqq4W/0ZJ+6DJaIoHDT0iZyYwmdwjMv?=
 =?us-ascii?Q?jA0G8itp1ubdrSu++hBG0bs1snt2DyeheOahpeLW1XkxyIVha2FoZHCr94Bi?=
 =?us-ascii?Q?9bFQQr6PQrzpXNU9WGF5rzhh6OF9olTXNY/W6LL1Y2li9Dz/SV7TyVXQY+DW?=
 =?us-ascii?Q?03OaL7X8kSx0TfzuPnmNwrBU/HAJA9Avhpwwny9yUQwmhdSFKIaJVqkocpd4?=
 =?us-ascii?Q?QQHt66eQzencv5zcf3svyaE1vd0pRxB0yaM6WKzhGjyteZanANMYl0gAZME0?=
 =?us-ascii?Q?7tz9l+omUQERvXqanfG9+vnOh+q4BIo0TD7HwGajfeZcVB/WHPwyL/vKqMGd?=
 =?us-ascii?Q?scPNNA0r0hpFpJr6UBOHaZfH1ob/FyraeWqeH+UlZIG0Un+wns5yOuxI+kTW?=
 =?us-ascii?Q?H9esesJ9VEcjuETZ1pdatTrl1DdhUl7/Zj3KiDUHvrEuC903w/wOzTdw6KmG?=
 =?us-ascii?Q?KNCY3KQfs8VQO1UagzzID38DGNF+NmCndxAfDKa6FvT3eX5sUK1TMTnEVcgd?=
 =?us-ascii?Q?gQcLyiZZfgZ4Lnm5ahBwfZyFkGoNhdUPHKlz87g308GR4IuDyL8Llkjvi5Fu?=
 =?us-ascii?Q?ACVkvdX02cDylVi2hHltapeGqK3550CdCpX2ckvvOdzMzW0dhyW2O2eBUacH?=
 =?us-ascii?Q?Prq6IYS3npduBM1hIJxdENAd2g3XZQRdsbjgonT35iYRf/dYhmZP6D6hmNdt?=
 =?us-ascii?Q?vHf/o9kszJbIYhP5aA9XSqFBvhXYq2XYTuSL/QvSoskTitydxqraP7+X/lvz?=
 =?us-ascii?Q?zvy7HUKfYIhwKFM8/zJiCruYnBuqnoxWtrc/AvMX+JhEnGaG/ZlLOu0WHe2I?=
 =?us-ascii?Q?ZpQZCx39algQNxVAwJU5p6CGOhtVbf9S3ePbIDH4Z+morN+K+Q/LbIFJrBoh?=
 =?us-ascii?Q?PCnpnckQT+Bhj7vUqR5rceDRaGWC1q+Kxeo/pDs593zhpkNhgFVoBw/H0t6W?=
 =?us-ascii?Q?9cWjzeOtfZhCJrjOvsEWlfmT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84471cb5-c7be-4f0b-30c2-08d8f86e7775
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 20:07:41.0693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KEx5Ujcc1t1goDc3HXmjwHd1eaMclkbpip1jnZjj+VLeDPeZaFMR0wTZ2OdJn8N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2601
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 03:41:15PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 05, 2021 at 08:23:54AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > >From Avihai,
> > 
> > Relaxed Ordering is a PCIe mechanism that relaxes the strict ordering
> > imposed on PCI transactions, and thus, can improve performance.
> > 
> > Until now, relaxed ordering could be set only by user space applications
> > for user MRs. The following patch series enables relaxed ordering for the
> > kernel ULPs as well. Relaxed ordering is an optional capability, and as
> > such, it is ignored by vendors that don't support it.
> > 
> > The following test results show the performance improvement achieved
> > with relaxed ordering. The test was performed on a NVIDIA A100 in order
> > to check performance of storage infrastructure over xprtrdma:
> 
> Isn't the Nvidia A100 a GPU not actually supported by Linux at all?
> What does that have to do with storage protocols?

I think it is a typo (or at least mit makes no sense to be talking
about NFS with a GPU chip) Probably it should be a DGX A100 which is a
dual socket AMD server with alot of PCIe, and xptrtrdma is a NFS-RDMA
workload.

AMD dual socket systems are well known to benefit from relaxed
ordering, people have been doing this in userspace for a while now
with the opt in.

What surprises me is the performance difference, I hadn't heard it is
4x!

Jason
