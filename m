Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59EA35F66C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351878AbhDNOp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:45:26 -0400
Received: from mail-bn7nam10on2061.outbound.protection.outlook.com ([40.107.92.61]:31425
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231897AbhDNOpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 10:45:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibmessIBNInzAKABnqjjGSln8YXkHwOnKAsXezcjdQSnHTtcW0s5eJLQSQgr8oakAWpyu4WQG651Y1W78xs2kgcounU+ojKDOdJ40lk40OhqR+EA4hKYTha/GMRs4GFXIg+gcZnXsWugora30blJnlDw9L0JNDJNbxK9JpVrI/5j8Dzw5z8jPMVlT9R+qxdsJJfOU16fLxI9RbHZFq56pUyD8Xb8scS4OnO13XbH5mQdltWyWpdzEbKAA93wl3cKODndlA2OCtfF2LLK4iZyYxGiOwhqIpFnle+8cUS4XKGe95Xo+42PjMKRwmvZ0sM9ERipsjjrNa3zH7hy6jiytw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmItWz6JcS+tnOVYvYxPLDkm8cKzugsxhgqgLomJmNE=;
 b=KrEMJkU+7bpF1clq6VRxLcQzwKWXTUOdky3gAARxS3koCc/s4tpWDT6/i4Gf3k/yip2ESdS6xl3nYz99GFXyESgDapeCfsEqRWLdm4jY7y6GEQ83ujCg0lAOEGqsjqrG7D6WmYV33S8ZEcXCmvMpSCmFnq212KBS9PQe6a1BHA4MCsNEmqHRMToIJxRobGhw8xRzjDr4f5YR2O+ISXdQUiJ7N27AZoV3RArNk2HgK8ul0ca4o9qukERU26LHdScZ85JjCnrX3fFQPi1RtyWQgvHtKs3xtCzdiYe0Tq7uxhzaQLWXoxE/ZHs32ltC4taTKsmfnY/VK6/tfK8tDzizAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmItWz6JcS+tnOVYvYxPLDkm8cKzugsxhgqgLomJmNE=;
 b=pOab/OR+nnRdEPNkWXtDwDXs+EAcOVN36AmxF63kTuzzB7ssfYSLymVvPiAPt+WGbtgzThxZxJzRl0314Kx2OgHVWiFE0DAGSLTN4zLk5LwNUf5RYVR621662zKZMlLeQdyfsj89Z8z7nm8l+kJflhebgjrSgHweg3Wnt9Ryq/Oa0xez/f2h7zBW2mAi0F3qHs0TXxUsEbNIklEfx73Qj/5bozCkqfwAKYeST2YfxzCuKSQ9toBGEMM7MOuoilKS2w5zjIjJMEliIJJ/o4RWlSdbVNCZSh7K1txmOnYPW4k4NrmHyi/DQBtqupVOUdSj9ZNr37/aDX0meh7NqoRBlg==
Authentication-Results: talpey.com; dkim=none (message not signed)
 header.d=none;talpey.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 14 Apr
 2021 14:44:54 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Wed, 14 Apr 2021
 14:44:54 +0000
Date:   Wed, 14 Apr 2021 11:44:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tom Talpey <tom@talpey.com>
Cc:     Haakon Bugge <haakon.bugge@oracle.com>,
        David Laight <David.Laight@aculab.com>,
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
Message-ID: <20210414144452.GC1370958@nvidia.com>
References: <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
 <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
 <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
 <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
 <f71b24433f4540f0a13133111a59dab8@AcuMS.aculab.com>
 <880A23A2-F078-42CF-BEE2-30666BCB9B5D@oracle.com>
 <7deadc67-650c-ea15-722b-a1d77d38faba@talpey.com>
 <20210412224843.GQ7405@nvidia.com>
 <02593083-056e-cc62-22cf-d6bd6c9b18a8@talpey.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02593083-056e-cc62-22cf-d6bd6c9b18a8@talpey.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:208:91::40) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR05CA0030.namprd05.prod.outlook.com (2603:10b6:208:91::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Wed, 14 Apr 2021 14:44:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lWglA-0068L0-VB; Wed, 14 Apr 2021 11:44:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f12e5107-4728-4ae2-b670-08d8ff53ddc2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4042:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4042BC3D9930938E00A7980AC24E9@DM6PR12MB4042.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +w/3Tf/755vvH77OA979g7HV+TlmyJY2OHDUvvWiE1EpyirmPKf/34prFCiIbWVrCJG+sJjuEkJQYbEzn9v2OYWFbynFmWPl2X2KszclYcHWl75eR424AneM1IEdj9roau/jWks/2IyUIwYw9rJWCQREnH1JJRBkdGpiDZMMk9rey5jkb/Y6zPYylEcJBKPjbJpvqLfk1qmPRNaLOU3T4UcBx2ZX1Xc91UG0O0F5r3gc6mYnauG+q3vEE3rlp6tZvEyHKHFqOjGPmjfQCEaQV+W/Vcag5amDmUMtDHR/4ds1RCQC6QlpbzGNu8UYWvA1o5HAuHU9SD6C4THZb/GSr+rR+KKkEo1hbPuVLp2JsvY+CqTeTm1RSsx8mzpZvu/9MvRlM4zpD/OhSTASOrOexcaaKeZ9JYcsJ241WN+6puSsPl0qFDxWfDRGcGtiHT7IkaBlFPJu5BQibnoKpSda7EEj1caamZvBFaq8UxyPBo3fEkGYkSYcPfCGMwbrWFA1mRFj8wu94Pu1cxLW/H+3BBCEEi7H6L+t1yHB883kV5XESn5bD7AhY5YnVM1+JVPzeAwHH6q43CSTCPGyRJ7RTs/y7FmHab53fSnTTS37o74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(8676002)(83380400001)(478600001)(426003)(186003)(316002)(54906003)(5660300002)(33656002)(26005)(7416002)(7406005)(38100700002)(6916009)(2616005)(8936002)(66556008)(86362001)(66476007)(4326008)(66946007)(9746002)(9786002)(1076003)(36756003)(53546011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6TxZO2cRZI5xtNq/cytN1ZDbtUy7SW4MtE27VSXt7uSaTn/CmYU75xdGkwbx?=
 =?us-ascii?Q?C8+clCpXpVs7b/Seny5MhvxJKBm64PihMWUeD0CicnAGqXhlrA/FLaLc0+Lw?=
 =?us-ascii?Q?2fF70hz3qJUdUkUaOLlOS5thNN2tGgGmr479xUq2eBMgQiT6zl6bj5/uETei?=
 =?us-ascii?Q?xGGE+gBJO379u+1ZTFSbzgpn0v5m2xkss465/w9Z/woB752HC7U3G5sgBi31?=
 =?us-ascii?Q?kPnJzHyqUeKW4Qh3MOpxYX6oShuUmAAuO0aaQOMm2ZxzD7Q7ttGHs/UEqk/6?=
 =?us-ascii?Q?UQxO9KqHbL55FtUwZWFQ7hl3kDgca1Ln8ivQE0HycB/5OB5PDzt3Oq0tcTwE?=
 =?us-ascii?Q?3APF2NxpeRVqEcyIyuEAjfHDVbkWdaw/7xUG8hbsDd8Yin1bCW8Y5dQrhXvg?=
 =?us-ascii?Q?of2d4K/1sEDvOPLvYdpF0bEJ5yD/OI4ewDoBkNrRvzAwpRvenEKn1OyFyLP+?=
 =?us-ascii?Q?l38bj+kbytADO/5RXxMowHnfmShW6tL1e1URNnlb4GwK4XwUgoH312OpD54m?=
 =?us-ascii?Q?QzvjkOgBC6ldQJJ6Jo+3411HyVI/D8y4QeyAy/faO01el96zNtWewW3Mee0k?=
 =?us-ascii?Q?iUd/NzjexW9PscG7Yq6nq68Z6QC4uzillvrAS8Ih3STRTN7pCl7/tOdn/J88?=
 =?us-ascii?Q?hF1opbIKkk6C5OdVXLMi8n/LSTJTKyjPcil7YqMO1pyS2UlkURqcRHSTNIez?=
 =?us-ascii?Q?XXi/6fOmm4T1NHitZ+6xvY3unDa0Sp5l7WvV5XFIxmuYE8JmIB6aHWA41dQO?=
 =?us-ascii?Q?4e1KnSV5LRrSGIzxUjFqXCqDFGY8PirpoEEFFEq7L/EZKeBJVUsvIdkd+odn?=
 =?us-ascii?Q?3tn/xAUnjyCHqkXbpwQp/oj+XTgIHw+SHlzoBIuwDtnFbdaAD70/oeh4Tgz+?=
 =?us-ascii?Q?zVo2ybPBSIc0EHy86F3bbG6hSIxqZSX0q559VqeTDwKFCN1uYZQKZrmJI453?=
 =?us-ascii?Q?MZu0OJNVgnrMAT+qRt8bLolXRsjD7PturuPBkPO7ZnTzZEnmLxdldyWOkdaf?=
 =?us-ascii?Q?tkaXPpQtdJELr9WuhfHxIy1+3G6d7+5mt5nSeq0g4IQcXUg5EPFsQAqoZTAh?=
 =?us-ascii?Q?d3rsMrRo+Ue0MbZSYYtRkn2WreFf2aKF8O7A9TvJAr29ajAlZK3dAooMfspb?=
 =?us-ascii?Q?XcTjAomNThe2VuG1v4LwMChhLW1PeX3jKQRorxbkJdH3Q3TOxTVy/jcu04vU?=
 =?us-ascii?Q?8GODoWEOLXkwwn+xfrFhoKuFQabNIaV6yZ7cPL8HfovjJJMW8AZpQkN8Z2ew?=
 =?us-ascii?Q?US6jhZemd9sXxqHktANUfazi34LW2tOeEkTppsME8PbYHg3FsolmpO/1HTMh?=
 =?us-ascii?Q?zqkuAH/7vKaBLOr6nRcW5l1T7LpJdehjVAx4RS8UCd6Jng=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f12e5107-4728-4ae2-b670-08d8ff53ddc2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 14:44:54.3117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QN7u8x9oSLmEVkZibvK3zBfiR7v6YAhnvwcBCJffh52x8uZRTYMFv9++z4Hh+Dbx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 10:16:28AM -0400, Tom Talpey wrote:
> On 4/12/2021 6:48 PM, Jason Gunthorpe wrote:
> > On Mon, Apr 12, 2021 at 04:20:47PM -0400, Tom Talpey wrote:
> > 
> > > So the issue is only in testing all the providers and platforms,
> > > to be sure this new behavior isn't tickling anything that went
> > > unnoticed all along, because no RDMA provider ever issued RO.
> > 
> > The mlx5 ethernet driver has run in RO mode for a long time, and it
> > operates in basically the same way as RDMA. The issues with Haswell
> > have been worked out there already.
> > 
> > The only open question is if the ULPs have errors in their
> > implementation, which I don't think we can find out until we apply
> > this series and people start running their tests aggressively.
> 
> I agree that the core RO support should go in. But turning it on
> by default for a ULP should be the decision of each ULP maintainer.
> It's a huge risk to shift all the storage drivers overnight. How
> do you propose to ensure the aggressive testing happens?

Realistically we do test most of the RDMA storage ULPs at NVIDIA over
mlx5 which is the only HW that will enable this for now.

I disagree it is a "huge risk".

Additional wider testing is welcomed and can happen over the 16 week
release cycle for a kernel. I would aim to get the relaxed ordering
changed merged to linux-next a week or so after the merge window.

Further testing happens before these changes would get picked up in a
distro on something like MLNX_OFED.

I don't think we need to make the patch design worse or over think the
submission process for something that, so far, hasn't discovered any
issues and alread has a proven track record in other ULPs.

Any storage ULP that has a problem here is mis-using verbs and the DMA
API and thus has an existing data-corruption bug that they are simply
lucky to have not yet discovered.

> One thing that worries me is the patch02 on-by-default for the dma_lkey.
> There's no way for a ULP to prevent IB_ACCESS_RELAXED_ORDERING
> from being set in __ib_alloc_pd().

The ULPs are being forced into relaxed_ordering. They don't get to
turn it off one by one. The v2 will be more explicit about this as
there will be no ULP patches, just the verbs core code being updated.

Jason
