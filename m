Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871E63552AC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 13:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343501AbhDFLuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 07:50:05 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:5216
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232884AbhDFLuE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 07:50:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQpbvKyh5h78ssvu9JKetle8sc2ZmLv5nQ+G+OAfdtZrHFv9FBLk0O+ablXafQZb5/eXjqufL8zvIebCH5a7yzG4UD7N5oUpyw1YiflKYksyRIuprMDQX/gUk5+fLamlUtuj+yCJCKOBb7ashdO7GIq/pFHyrSoCoFDymrptMUPOtJjKx5Lw4TZCGbUY92mKA+rCuhIRZsZZ1n0KmrU5Z2cBp55z+9/xm+Eq8/kvG0hVzqeaG8jIK/lCnvkVRlf+g46YrDxQsRU9xg+N+OaU39zfk6IpEVva6hamp2yIMowhgHByIBcvm9B/jrM6laXwcD0ZZmCQHlyxcSKmx7Urxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YU5kwv83bbU6QP//L9LIRU1lNCxipsfh6RyS7TyGJ20=;
 b=icd3+iFad6tj0vLR0VXFY19r/PBEL11RZRP/dexj6TPwLzGKcuZfaz0WLauK7faz3H/EF6YoSittdg+NoVM25vj5g9agdplEhwFc+o7LNHb9gpYNtQ1Ho+PX9Qg62liD07K54Te+As2lUfxYET0yty+LgEAa9mjSgfkhuKA6QxUgwmqtHPUueC4S8FZIkO54XztnithA/hJpZT2Oa3h/uHiggPPfh88GCTgv8M68rYl2EnlTDn/MrhK1Lqvlwa/9j4jGQaLaWKRJo5KSes/BnBOT815KWAqMhz5YhsHkZirrS/KTp5Sm94b+06o4qjMDHzXV9pfHmdAl71HmXNkIdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YU5kwv83bbU6QP//L9LIRU1lNCxipsfh6RyS7TyGJ20=;
 b=hNOwWqHRAcZ85QAKolIBZyOjAAlRAKVhIVkxX2KgcNWTpdJ6Q5fJONqvuFHsp+GF5NMc8frMQjNyIq8SL5kPV7kdQ73r780HK2CujKPdlfcQrpWj9u2l4fOURBFk3as4nl/cKZ+v1Bni+54wsWSqqedN/ySROFb53sbKpxa2patl3QaoVcJs4/3WutFX1gE+HZdH9APhEyf+u9sQTr5GMXNj0pxpWhgnQOTDXFMIYps13NZ84OFjTTjXRU1q/P3seJoLUHhBxkP0gRwrBZ54EJdnNNVdfk8ThQyUSshe5X1CCLmsuDzyk9pE/6bR08KWXbY1Hw0Gg4FRMBnOFU47mA==
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3739.namprd12.prod.outlook.com (2603:10b6:5:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 11:49:54 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 11:49:54 +0000
Date:   Tue, 6 Apr 2021 08:49:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
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
        linux-rdma <linux-rdma@vger.kernel.org>,
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
Message-ID: <20210406114952.GH7405@nvidia.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de>
 <20210405200739.GB7405@nvidia.com>
 <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0350.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0350.namprd13.prod.outlook.com (2603:10b6:208:2c6::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 11:49:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTkDQ-00166W-78; Tue, 06 Apr 2021 08:49:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba6c7959-89f3-4d7e-90bd-08d8f8f217d3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739E223AE85E6F9625E6AEFC2769@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2ye2s37xG9fAimW0VTpt3OiE9ZFx7TKIB3uZv9HdstAN7qW1YArvCpUzwJtEhpwwvoJUvWLl2lShV3cnvhpEsU15b4GecN/lmCBYpOFQnC9pCqw7VIRtsT8vK1rVbZ5ftYjdh0FmcNCDoxMC2ceAbKoQWV1F9HNegAq/mO7E9Xqxzma6W/kcAMLO22HFi6eXs474dwqIZ04bygDV8PbI2+p88W7pscvkpVdRq+GghWB6i6nUwGk5/8+E1HkqsCmF5LMTqn4cNphe/WA+pHgw9VDiCb5sCdLlZ43vrpDwWiFdYp1r5+38Pe+bXG43Vqh2bWsWx0E4wSg+fn/7rpZoU5UjYzsN5UFUJ4iixurupmkRfCn+5Oj2Xo3AAs5r9vnZTZ8xyng0sO6NB3alMB2iye+AqxoF0md1uNBN8vcD3q5DzPWPm21pZIHXvy4QK653WXhA1Hv0Lt00kD6eFG142sGXBDptTXrbzWgabmow5QN/sv+NTzqlWtzOIM8Ou7rgCVthxwlCO986FXsiP71Tr8DRsJ+RtT7y5fzbGe16DBh7WweU3vPi/N2XIuL1DIwaBgmZqb0Cz0bViSwwiUO28+Bj9rhccqvKRW+QFDQzDvSq+6es66x9DYbZZRJUJDPccD4ss/DZmLgo+50A//ue7uUnpcBGBi5VaClpvZ0ObM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(4744005)(478600001)(316002)(2616005)(7416002)(7406005)(54906003)(5660300002)(36756003)(186003)(86362001)(33656002)(38100700001)(4326008)(8936002)(26005)(6916009)(66476007)(66556008)(2906002)(426003)(1076003)(8676002)(9786002)(9746002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uPDLh4bJEN7hEX2D2W/BBTKnGqoDW2lEft+WNhzedxI8fqHT1QZkTvepyl3D?=
 =?us-ascii?Q?9YG93roldNVc3DCI8xh43r5R2g9vnpq93n8v4G36D/1ovpUifb62c2v4UXIC?=
 =?us-ascii?Q?avJ0Rk0aBcqr9+NWkhgsY3VV8vGHmSviAJ9lZarnQKaS3OFASfqP0tZNRUQs?=
 =?us-ascii?Q?9N3RXuWy4Hi19vfKzy9CekgOu8zVbqPJZq29y0D4DM+t9oIhqtlTDKhkuEJj?=
 =?us-ascii?Q?s0jxc0Q+ay+Cf+p5TNoWYq3SMTgn7G8frBMEe40SrCT/miHdrxryRaoI5Eeh?=
 =?us-ascii?Q?1Lc8wb9QhU/luZVteF6gU6iGZmkcetrQn2PR6Wwlk+PAi/hUE7vkKSUNKR6q?=
 =?us-ascii?Q?x/pZkgwTmHOY+JV+iR7fopszeEaqu+63gFt/pnWGSBI7MNq0jmDlNSCS8Wl8?=
 =?us-ascii?Q?k+rPCNWNpXmSSA7oVYPqgFh+NWlZRjMXHt/6xl61GWW8vzSfECNXP+FcheB4?=
 =?us-ascii?Q?wHmhlHwRSr3oWvsHFpc1sKhEf/184DZdM1K11CtG05y6ar/Ktfyl4IObgOnK?=
 =?us-ascii?Q?2zLtLAwIHrxD+YaQ3lwJfig8gTCL+7xa+JAwlg6L8T3RmfJBa+4JTRPDXRxL?=
 =?us-ascii?Q?TSceH9FVWU/pmjGOreNHoo4DYURRLJLmXJ31C8ic0a7dRzHEkN5uIfaY42eH?=
 =?us-ascii?Q?EqxRDCuAZcrQAtlyTDQpSIJdUt4BWlDv2jfOVP0j0zdwxMU++DBPI5nLlLgk?=
 =?us-ascii?Q?GodPqCwKaPTJVbhZ/abHqcAcNH52Ldmnifpc/1O5/FxOYeFTXZCSQy/Z+A3I?=
 =?us-ascii?Q?JZLtZM6+vHjinItltu18xRasBrFYS4X9L1viSnDVpS3reKVHAvKjW/MCmleV?=
 =?us-ascii?Q?HMu3WZMLdkU6nlo0Kp9QSRwHF/f1gVEsUZUEXwtmmaAnk23GvIol4bNrNECk?=
 =?us-ascii?Q?5WT87+E8gsG9Igi4eSiDI1OTba0iw13XKX5SxWiA1bQZbYRojbOSxj/mOiIA?=
 =?us-ascii?Q?SV1soL1rhelL1ih87P5ESrOhsauFtOglP9DsKEi1g17bcM+wxCIfSoT3FPao?=
 =?us-ascii?Q?CWxbHMq5oQiWKUEi4ntMmTkaWvPt7yR0sWV5w3Hz+mtMK+UxQ0BBtUxLoHJ+?=
 =?us-ascii?Q?1FJ/8AriZG2OZ2nXbXYiDcrPUKpxdPVIZfKwntdq+cYtKPHAnD2CP7ZNFOps?=
 =?us-ascii?Q?yglfZGAV9RtrCS1aenftBtyD9wrQf+cgcsdDaM/Zi8O/8ZH4rGUJWjPjcSAD?=
 =?us-ascii?Q?ZZb6kmDlg7DJRrjq/cdQgJ6yr5DWkhFASM+kGIvyzR1eJ+Bcsias2ktEael8?=
 =?us-ascii?Q?ez0ng5pzKRUM5OMamNUYeONeYhi1LZB+RYjt/2v0R43WHr37tpHiX+LWGJIL?=
 =?us-ascii?Q?vXuV75/XHs0Y/gN8vE7vP8hGeEGVOaaTuaP2Ba0vSKmYYg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6c7959-89f3-4d7e-90bd-08d8f8f217d3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 11:49:54.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phh4UfQpks0iD3gItE5Jl4HdAGWe/e4/L/Wu2d8AxNVxqQM4PPHwKdj/0tHmCB54
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 11:42:31PM +0000, Chuck Lever III wrote:
 
> We need to get a better idea what correctness testing has been done,
> and whether positive correctness testing results can be replicated
> on a variety of platforms.

RO has been rolling out slowly on mlx5 over a few years and storage
ULPs are the last to change. eg the mlx5 ethernet driver has had RO
turned on for a long time, userspace HPC applications have been using
it for a while now too.

We know there are platforms with broken RO implementations (like
Haswell) but the kernel is supposed to globally turn off RO on all
those cases. I'd be a bit surprised if we discover any more from this
series.

On the other hand there are platforms that get huge speed ups from
turning this on, AMD is one example, there are a bunch in the ARM
world too.

Still, obviously people should test on the platforms they have.

Jason
