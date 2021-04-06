Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCB83552CC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 13:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343552AbhDFLxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 07:53:36 -0400
Received: from mail-bn8nam11on2046.outbound.protection.outlook.com ([40.107.236.46]:7009
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243320AbhDFLxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 07:53:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lORtm4RyzVyXCnNxLPfldSbcoBJ2SMZizi445pBu1usUraLNT1yBfKWOK4IeAItxMZ/VWJvRH/J68ZE9geJR/UBhD/TQX+g0aHFoFN1HUDtrAw59x99+8+3jwGA2W390rKyjUOXaSEN8wrRe2bNWSYtcEjDHT0vVYUHFuWEa+K6DasztOYvf7WSG5BBsKTufXAW7W31dKs7N9Ev8bCuKgOZytjHWns72MhtJgstKJ/Q6pk8PU3YIbG0ZDhQkNqiPu3KErC2KFOC/Il9wioc6UhveIb32tCD5pUfhA/sn/7l0gizXnCqDPP4cen9dW6GS8Qhbjnewk1K8WmJE3dEjrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MriZDWx6DlmgwnC2CrOubTx1ie0mcu4xhZx0CPx5q78=;
 b=RZibWi8OLbLscGi/fOhj0d30ZT7P0MKH3BO319oEy9gkAaxdMVI5/zMGZyUKaxNp3pzFxLwRLlpdLg6UVDxKcwRtXyf2Jb5nPtgh4JFUc0APMb79y6MvTp5UUvqZDhmD7lBah0EQX6vwxak0IU+NcUfdzObiZe3NwqTCDx/2au/zegL+x+b23Nz+yrQdwAgTJ8TgZPYqWo3f+6rGjqpzlTdz9NpWlMDjrU8cgQjcH5lU9+UTDIBplsJHS6pCYGgCUQfaZisYPSSyZDhEFa5KFg16C5JR+JVCeb66UHD0xjeSX5Jg3jiNBN4qZ2KJwnYVCZ5UofWaJCAi9QKY2Hn3OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MriZDWx6DlmgwnC2CrOubTx1ie0mcu4xhZx0CPx5q78=;
 b=TAJ12Cj2HBKji+3LrkhkNsn7yaLSbiGdTFb8vBXKIWI180V/Eub3iuHMbjkePy4VTl04w38zD6CA6uZBLIm03HgUDdwRNByL49dXFUE5TESEDeMEfK5C6DEbKhjuc9kFb8GRxV1wcUPdvkALvBSuUguTx2a3xoPu/7zp7Fdxr/s/OEnT8nJ8kDsIC9OPRK1QWi8o80Z6cjYgkBPuj2kdbA5heix6WEjSQbpSVP7UP+Jt0zsE0fgjMBtqbGpf7mG9mXD0v42DgYYQOxvWukK8eukSUdzk/yKJ8RPmMKIKLZh5rCAh1rLp7aFnRlp35Xwlv0BDejp18SDr3Edi3Kx76Q==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4578.namprd12.prod.outlook.com (2603:10b6:5:2a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Tue, 6 Apr
 2021 11:53:25 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 11:53:25 +0000
Date:   Tue, 6 Apr 2021 08:53:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Honggang LI <honli@redhat.com>, Doug Ledford <dledford@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20210406115323.GI7405@nvidia.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210406023738.GB80908@dhcp-128-72.nay.redhat.com>
 <YGvtFxv1az754/Q5@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGvtFxv1az754/Q5@unreal>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0053.namprd20.prod.outlook.com
 (2603:10b6:208:235::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0053.namprd20.prod.outlook.com (2603:10b6:208:235::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 11:53:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTkGp-00169F-BN; Tue, 06 Apr 2021 08:53:23 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87b0ea3e-1251-4996-100b-08d8f8f29582
X-MS-TrafficTypeDiagnostic: DM6PR12MB4578:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4578F76557A483D257C5EAEFC2769@DM6PR12MB4578.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +7eGPc/6ienhbDP9Blfc3+ycjw/Gcf18e3ZeQ0qgbfY3wnzmC2FOyjT4z1stPFfrbXMZe2BKwrlxY00YskA4fwfUf8cr4M/VC3cYcgA+Lp9OjLRMUViI1wqx4CXFddghAf+rlzhRE/nAAXeuRWRtnoQYXSfJ+W2tlYl/iJzxa0Sz32Fh5/aJyHYy7KVgI2qTxwB1Xp+lJ+pKkLRREB1T4RIDMlg23sj8XCNtaO+qviSu8aedzf+Bne/S3r2owxNPJsLXUR7jnYpXyrLFg4wETBmUtnXHGZOIcasTKh78iv0zXAknmwTZogx01Q9opuVrVCa7Ig5567im7Qm9Cz1uD2YrZWYFO6coYl9UhQOudkYMDxzK5ShT1zbn/kq8NeJUpeb/Kddplvl34OKHjK4u8ntzk7j4VH7pNe4D03dfQnj0kTpoC0M5QcMktigW3KayK3cJEktJaIhe9X5Ssc2nde9ABZJiHi7gC7WIajdZmmPu3SD3Faj7HQvwE9S5HmQAK+nq3yApJhpeYmpZokIWPt0/0BF9FMiFaI5y/rj8DMzsqPavTnZDKSxi1h4HtlQvkiN/px5Fr1LSZ7mClqF8zUwj8uOeIY04ZPqvybvZaFkThvqlf4djjkPPhR3soEWhXSV35cgI6YJB+CUYwlLjsq2yZSryajYkKPyqL+v3cYL7JICtiDjCPGrOubdnr3CdtXZz/O63gWxyB8omLS+rAY8uYpyyCVetJegpmJuxad9ElD7XdSFQrNk0+bKmE9sv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(86362001)(2906002)(426003)(2616005)(36756003)(478600001)(33656002)(5660300002)(4326008)(83380400001)(66556008)(966005)(66946007)(9746002)(66476007)(8936002)(186003)(6916009)(1076003)(26005)(7406005)(8676002)(9786002)(316002)(7416002)(54906003)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?q0lzuMl5Vmr+uc1O7GGb+Ar3o1/uazZi4bHNJG6RfixYAlHyQW1C6VZq/Ejt?=
 =?us-ascii?Q?1tkNJIwn+OAVQlAcLnzOB0u49rsNJ6ba20Nc+Cd3b6+yCG2ZECgHrAj7su2I?=
 =?us-ascii?Q?TSHWVN6knMyl+ZYqzM/KnzUcIqzMrHFCMsjeB52aM8oY5vl2iCoPhVA6fdhL?=
 =?us-ascii?Q?H5HfkoV0pWUspwiz2JzODatY0U80LG8YnFmwnk8G9zxwgnCtjLp7gU07SUi9?=
 =?us-ascii?Q?VyQ309Ibx7uGfPVMQ2zUXb58gqoHBJUa8clMD+nhvUTUKu1rFdX3l1BUtyAc?=
 =?us-ascii?Q?qYXI8IC4yejLMPFzCkjX0p2kRiIpK88pdIqNgrUJSVZCsNePKnj9UKOrkiz+?=
 =?us-ascii?Q?jYXgbbFiGxrpb2u20lPGD+Z+kyV4cYEXzNqCptM4mu+jAkJiZ1Me9s92H/Rr?=
 =?us-ascii?Q?S5LBxJT0i+dgm1Kf0wkTHkDG7SLNgxsxv3YZ+joUGimEec8lyLVCwkMm7cwC?=
 =?us-ascii?Q?SnqAzUJSwsC7eqz3PELCqcDrfgLS0UC5MGWt76Wq8T/qG3OImoyjhS+b+9mS?=
 =?us-ascii?Q?US1lEJZQ4wP31o+lI60TFqhe83dNle/1KNmZyDjYK00VuF2/HI9VC8CXkTLz?=
 =?us-ascii?Q?I5/Hw5z9fpav2T+2AaVrTegdzkrBnvkyP67oNEpqV5VkU15a0drGmIB68C52?=
 =?us-ascii?Q?bhLBdw0aGGef34joeT+ewma7VT+x12ym2sISRFrDoBwvuxS39XkPL+08Lmbw?=
 =?us-ascii?Q?eNKgcIB3xEqtcQTJCHARiK+VgxVEUx/VK8YL8rCeOZbYK2wuH2DRBS0qUM+V?=
 =?us-ascii?Q?5p2cr79G6N8xn1pXQerKRccXEzOdZ5b5MqWViavBP4kck8ELFsLxyMC8X1e6?=
 =?us-ascii?Q?EKdkeKttGpxfI1CHzQwZsGQkHMU9JRPb/xfE1IttBKIOOwGQyes8o81vwLXc?=
 =?us-ascii?Q?FrXlgwNQrK4YV/IKx0zJefc88zAKerJfyPcKs/GdC6CEziSa/qrK+Fbl3QtG?=
 =?us-ascii?Q?phOo3FMJ7GLDKKdAJEUQqSddCX6JhJPWYMRKCRAKwJdOXQ7uCxjyQ0pXrTnc?=
 =?us-ascii?Q?PuiiLgOXAm+w4vdvrWSG90f1RoqxiYhp6+3Nb7yeDwbGiFRZUWGx+tSjwN2o?=
 =?us-ascii?Q?uBZ3W7oHCGZvq27IvtfQIPSf+IwYF1lhEhoX8bEyrntDhBz+P4jkwqDYVCH8?=
 =?us-ascii?Q?P1B2zZ2DjDsHeKiAGnVrPqPXtPTTSC0QwI+VRcYfdVsRYJcMwRQX+oASI469?=
 =?us-ascii?Q?5+enlAez87xwqv4HNZ+ss6hFSVa7NTi/7cJDnOdVc1PHQvF2V0GztF/OAvK1?=
 =?us-ascii?Q?KZ/7BmmRceEGC7DpBBgLb0XfklcwSQjfLbnTxuxrIi1e0zVZa+IoIYSj9faz?=
 =?us-ascii?Q?NRe9EESGAeBJwBM54GPJXTQ9xf6CZCFzD+mExKB/gA70UA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b0ea3e-1251-4996-100b-08d8f8f29582
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 11:53:25.0156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfDGmS3Gq66jcidkaUZ8EnDAPTruQPN5ym8f+mmDb/shHcMgfnVjmd/xGx4sDX+o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4578
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 08:09:43AM +0300, Leon Romanovsky wrote:
> On Tue, Apr 06, 2021 at 10:37:38AM +0800, Honggang LI wrote:
> > On Mon, Apr 05, 2021 at 08:23:54AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > From Avihai,
> > > 
> > > Relaxed Ordering is a PCIe mechanism that relaxes the strict ordering
> > > imposed on PCI transactions, and thus, can improve performance.
> > > 
> > > Until now, relaxed ordering could be set only by user space applications
> > > for user MRs. The following patch series enables relaxed ordering for the
> > > kernel ULPs as well. Relaxed ordering is an optional capability, and as
> > > such, it is ignored by vendors that don't support it.
> > > 
> > > The following test results show the performance improvement achieved
> > 
> > Did you test this patchset with CPU does not support relaxed ordering?
> 
> I don't think so, the CPUs that don't support RO are Intel's fourth/fifth-generation
> and they are not interesting from performance point of view.
> 
> > 
> > We observed significantly performance degradation when run perftest with
> > relaxed ordering enabled over old CPU.
> > 
> > https://github.com/linux-rdma/perftest/issues/116
> 
> The perftest is slightly different, but you pointed to the valid point.
> We forgot to call pcie_relaxed_ordering_enabled() before setting RO bit
> and arguably this was needed to be done in perftest too.

No, the PCI device should not have the RO bit set in this situation.
It is something mlx5_core needs to do. We can't push this into
applications.

There should be no performance difference from asking for
IBV_ACCESS_RELAXED_ORDERING when RO is disabled at the PCI config and
not asking for it at all.

Either the platform has working relaxed ordering that gives a
performance gain and the RO config spec bit should be set, or it
doesn't and the bit should be clear.

This is not something to decide in userspace, or in RDMA. At worst it
becomes another platform specific PCI tunable people have to set.

I thought the old haswell systems were quirked to disable RO globally
anyhow?

Jason
