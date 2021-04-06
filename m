Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B01355362
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343859AbhDFMN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:13:26 -0400
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:33537
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343827AbhDFMNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 08:13:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrniwhm8SJs4lwX4h1D0eG/xQcarZhcmcyvRSgMxx0kC5DDXa5fxpwku+Gw8pjngDSwl0LgbnWfpZNMdkPk6tsDoMc0OcxeyHZvw3lTJQ7zX2f/tW8eAzB6AeKGFBwH8sgyHzdxYyg7koHKOkHB+tXb3sOJ3TcnBWpEU9/MQ5EdDf8aw/iYhuaFiCgls+viElorGIHeGM1OTHsufTmjQFeZ+14QbqIhv5Xoy79vfja2ZIE8nbBlFdpic6lOgai8NgNsBdRZE9ytTKLJ+WftlG4UXsm3pzQchbki/al/enaZ6wiPyM150zUk6M4QtXmSW5BNik58eoAKNCAgEzQoxbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enQKEixItEKSjZsMKMZMj6h24oPTfpI0CqxDqwpgqCc=;
 b=cnW6k0awF+ObJCH1q8d3ITcKRtc9R2F4sAV4YAnxiuKvmn57QErCVk1INjIahWXPI0jHbOgO92SKwIy7kPevSLGDFTH0Atg1ptJOBdTotdvIIhQAhKJ9Jq20boYWXZrEk+7opOtKczHHhXmq5Sa+2JmrOuPPmkgxfUUne+/t2M1kPrxnKBpS/M+kbI9fvx0VTMLnw3USIik/oB55QyYdL5+VNBDCnQomGz/FjRxQGtsuzpYWiO9hscZdznXPJFM8ES0Af/QPAiXEWOqMWRlnCVEJEYT4XUGmdNsS22P0/CanqWJJV65AD7c7iIJ6yr5biT9Nb+3NNGc6IpcSQksCNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enQKEixItEKSjZsMKMZMj6h24oPTfpI0CqxDqwpgqCc=;
 b=omcKBxOPiiJmRhFgz2HjDxMOoX+q1B6OaElJSZd+E6m0DXzWFQTFOASaOMWG26zFp7+eorG7IjmYfaBvRO480ODa/NR6LlZ+ZVWUdrweEsNkUX4odX3PtdbY/k1GsXRljLYGaH/AdSt/tzDVh5ot18zkr6OuDQln4idNbJCQWMXEFtVKy3gRmlRvXRWRq3yqW60T0XVqOZuQHkB1knYx6muxsQjDtawU71DWU3gS4sv7WcEArMqacGOVYB3/bd1l/1Wq7G9xlS3AXNaNjawU0AmyuxB88lPKCm4j4Yp671iW/SkZvnl9UPBxG/J804Dj6c7+v3Ct7XYrxPGKAlUGJQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4973.namprd12.prod.outlook.com (2603:10b6:5:1b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 12:13:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 12:13:14 +0000
Date:   Tue, 6 Apr 2021 09:13:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20210406121312.GK7405@nvidia.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405052404.213889-2-leon@kernel.org>
 <c21edd64-396c-4c7c-86f8-79045321a528@acm.org>
 <YGvwUI022t/rJy5U@unreal>
 <20210406052717.GA4835@lst.de>
 <YGv4niuc31WnqpEJ@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGv4niuc31WnqpEJ@unreal>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0431.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0431.namprd13.prod.outlook.com (2603:10b6:208:2c3::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 12:13:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTka0-0016lT-6r; Tue, 06 Apr 2021 09:13:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52bcec7a-ff19-4bf6-00f1-08d8f8f55a33
X-MS-TrafficTypeDiagnostic: DM6PR12MB4973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4973C436003266B4C38F721FC2769@DM6PR12MB4973.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wJ2Z9SK3OgwH1/v7H3DP+sXtuaPIjeiJIewpd+MCLsomqKKzue6LtTAkdsxqFAVT6cdBkQFYaP+MtoS6wxOrsG0a/qdfaMnpY2vwWJeJ8H0f2fxShY+I+Pz207kcMJsjaw0NH+f5JADzi0wpukfN7T6GpP7Ya+AnUuJdnDBHL6aUWwqeuvo1b32ghtgTZgvMNFcoUGEy9hbyUxAESLciPtpj0oXrb8temNpJzYcYFF/6xj1exeBRldMgU5Fah2AtvsSANd0OY1rnd9kBN2pftsakgRm2BNkxZxfRxT+jN6ab5tjIM6F4ciJcEnV6u3wHkarqDeZze+QCzNDuyTLXxeurgUNbmFZash/nfptKTxfEz2aKwPNe1L+NtAdb2JH5tCM1Z/4IUHt3K9VGHTZTn9QEiYyKle2jPDmdztCjPquN5MG0tnDGOwMqn0kQ4S76Sxg0jJHuSJI1Cr6OHTtz5gydKgJilJ641uJ9KaSsrV47GcTVdVdslzfOXGxR1Rk6L/d1imwQ84SMEMJnK93B7492gYRRDTS22psO518YsSi6bto1YzEviv3Zjkg/p087TI98qTSPYhBARA+2+CxJIzD3tfnzOOG+QEz/q0lZDOBXyiFoCKuFmup0yKRCuYjsBGty8y8yVh1w/tdi83131eb1coYtUuhfK0jpSdwAeHc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(86362001)(36756003)(4326008)(1076003)(66556008)(66476007)(8676002)(426003)(186003)(33656002)(66946007)(8936002)(83380400001)(38100700001)(7406005)(2906002)(2616005)(7416002)(54906003)(316002)(6916009)(478600001)(9746002)(5660300002)(9786002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OS/shPadVgx4Gq4XnYEjLep4DBSd6faEbzq6XJCPWtwFykpTMvW0JEmForxb?=
 =?us-ascii?Q?/FuqiNfFYNc8uDzbHIuPp/Ug4f7mkvKh53jfITy8Xo7n88/fB/ZS+qKeOvBe?=
 =?us-ascii?Q?m5E28AQ2JR74gBu8DeYA++pzukRMnc0Z+97gEgw7/O19BftafSpLpL/q8r0N?=
 =?us-ascii?Q?eDNTeIj/Rcs9SSzJbINAFqbX0Ch/fl7p9wgzS2Z3fkArUL47p4iZwq+W1xhh?=
 =?us-ascii?Q?xEDlR0BQ9V/WaT/vMYaXCQpphjFZGNAqBYPIUNO3KGlV8RYL6HByzfkN2XU0?=
 =?us-ascii?Q?Cv5DeVpm7pjA+Lrnq4rZxCUebZv7iyTAqJ0G1O9hdJ6H0EbepLtN+R1JPtjG?=
 =?us-ascii?Q?mxl+w/0wOhQZRrEKEtflriZXJ4FkKUb/GWQ17DHziLNFRhsPKMjOz4/rngic?=
 =?us-ascii?Q?m2/FpP24iCWK+XMTxxMpZj3NhFjtc/km66OaO+3zOo39X/JOsy8Zj/CAHm4Q?=
 =?us-ascii?Q?JyU9hdT2tjBPTpcMv22C3hs/PXJe3Y2JRbFxAsXBqcdbffk36M7/3qQclW3F?=
 =?us-ascii?Q?Z3WJvx2pmyWCCsjYV0aZ2p5LbeT0kttAp/Q6sVnRdsoM10DSAcUCKLHkFY6n?=
 =?us-ascii?Q?PTIKKGMOyAy2i6YqIyM/wcaw2v/+GZZF2MBV8LM9/a+N3T7YMWfuEXHXNHXo?=
 =?us-ascii?Q?FUJLLj+vKaULzlD/6pKKhiqR9F5KJ8qUg/qxmf3XBM5ApaAJYljJanjNM5y5?=
 =?us-ascii?Q?+b4u29bXt1/+yKpsXJsfU59l8EwgBytvzZf3ljJRJk5rlMI7n4EaaJawVX6x?=
 =?us-ascii?Q?Cw/BU5HFMS34NXX7yO/LT5gy8XTYR5m/fmAJeHzWB8vEAAERBKHs+g82gEg/?=
 =?us-ascii?Q?IKMsd0urN7PcouDYq0yGqYx+6Z3DC5NcNueHwnJqUEiqzp3lTzhrxrAsFtW4?=
 =?us-ascii?Q?UnBznsOZ14a7kHme80p14Ote45nAhheHFpT8ZQudHnjnqFr4OmCmXcZLiRqd?=
 =?us-ascii?Q?cei2EfiVKwrLhMBRdmnXZDd4/PwczMg9An5qrYXirqMMNV0ltGBp4QNWMLEC?=
 =?us-ascii?Q?wWzVRsvGT/YYdkbIjkw42W6EJBK1vIYTiMa95DbQu0zmp6b6o+gY+SlirLTx?=
 =?us-ascii?Q?Pa7YwyYCIrbVBZoPo0Ecv5gCBx0JVqvqmtXrOuP34QedtuaRxwFUI3iKsUxv?=
 =?us-ascii?Q?SQzYmjfv6s633GkBa7gJl7SKBB6LASdaVX3QiN3iLklLEEkydgZxtjgwT8Tn?=
 =?us-ascii?Q?NG603HFqshMIF3Oi2/3p/0AOMABeXVMWvoEpfudkmCAbEj/NbAZfbMzRD4Xl?=
 =?us-ascii?Q?/HaEdNWV5kWVhEIq4oGQH6ePMCnwB5fSGl/pofHEOhwFwfZfAm6oISuHXrfB?=
 =?us-ascii?Q?cM68HK6CDfg4WAoUqnwZOvuIaBASvVOdjdos06GcIcoHKg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bcec7a-ff19-4bf6-00f1-08d8f8f55a33
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 12:13:14.1220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQLhegUrTQS4BISoxDfGyXO1kmmm2gqvUcG1uMb/BI+DGAfsJ1cFULoQazKGjDXp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4973
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 08:58:54AM +0300, Leon Romanovsky wrote:
> On Tue, Apr 06, 2021 at 07:27:17AM +0200, Christoph Hellwig wrote:
> > On Tue, Apr 06, 2021 at 08:23:28AM +0300, Leon Romanovsky wrote:
> > > The same proposal (enable unconditionally) was raised during
> > > submission preparations and we decided to follow same pattern
> > > as other verbs objects which receive flag parameter.
> > 
> > A flags argument can be added when it actually is needed.  Using it
> > to pass an argument enabled by all ULPs just gets us back to the bad
> > old days of complete crap APIs someone drew up on a whiteboard.
> 
> Let's wait till Jason wakes up, before jumping to conclusions.
> It was his request to update all ULPs.

We are stuck in a bad spot here

Only the kernel can universally support ACCESS_RELAXED_ORDERING
because all the ULPs are required to work sanely already, but
userspace does not have this limitation and we know of enough popular
verbs users that will break if we unconditionally switch on
ACCESS_RELAXED_ORDERING.

Further, we have the problem with the FMR interface that technically
lets the caller control the entire access_flags, including
ACCESS_RELAXED_ORDERING.

So we broadly have two choice
 1) Diverge the kernel and user interfaces and make the RDMA drivers
    special case all the kernel stuff to force
    ACCESS_RELAXED_ORDERING when they are building MRs and processing
    FMR WQE's
 2) Keep the two interfaces the same and push the
    ACCESS_RELAXED_ORDERING to a couple of places in the ULPs so the
    drivers see a consistent API

They are both poor choices, but I think #2 has a greater chance of
everyone doing their parts correctly.

Jason
