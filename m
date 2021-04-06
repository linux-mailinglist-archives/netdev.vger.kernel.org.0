Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279F83556D0
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 16:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243324AbhDFOkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 10:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbhDFOkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 10:40:52 -0400
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2026FC06174A;
        Tue,  6 Apr 2021 07:40:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hG98hl+yWLKNVdFqMG/Ept10RdAMQ4JC8qm9ApOFjCjqFEPa5juNvQkpA1tjkeSLoJcDMaFnl1WQPmQG9EgAYAQ7g7OitzVqs5cfOQ7XhmSN5ZY5u652BfPMnXi9pBUrqorf47vAAU7GTMuieQFdjATZdz8XSjJ71Ko+akyusOlqrE++pWHnXEdZuqjo6a39ZHsglL6mW1kTj37dlwKjNYUb+OzCcISriccchet7ThVOiUsU09hTcHBoUNLIFL0z0rJn+mMBmwx22/KVd4Uu0qTfSLkoYVo1lyypuXIfo9VoZtJJBfy7ifyn8FqBHhXxLQZIOo9mF1mpHQJ+wE8wXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbNlPFzZ+LloSluv42Yv8u2KdBXG8/DdxMDpts0f1PE=;
 b=LoNByi4zPBFN4eShbX3vJconx0FcuPugiSuUWR+blOvpWXiJUoiNwBIqucwQDBggfgvnFKVolFZ8b7QSwcsbNr+X4AJvM6rnJ43ZiItnKBD+N/4Ee7mYP5rmFTbXJ8QUlqnEOzgSBx87QlKIurgV+mGuByYwBrGs+W4nlCW5sxxH7v1YFf7/9geAlyk9xWdYCCs/AWNi93Z2AHlGpXFtgCKKwzJdguQ+0cgDg9mDnMiQ9O2GLw1TFDBg0gvCoDIs317zO/7g7LnvR8KAfCQsE6ZZ93xZJrVBtYuT1Oe3jhQhgkbTXiimHhYgeWHXjGdCKXBMXTv0cLzLmmj0O0SYDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbNlPFzZ+LloSluv42Yv8u2KdBXG8/DdxMDpts0f1PE=;
 b=JLiqUIVdzo/yR2UGD1nIkeAaVOOiLTNQyfKFw28EDDNRDjqNeT28XLnf3gRm5vjzRZhnwXaSdsnZfg8thlcOCtRDSkC12mh9CaewaLa678NYJOFBR6Wnyc8G7rxN4Rs2MoyDUG1QlkKkXE4DEaF4XbklpL1SDMsDCdCKXqvbXCpgVONT/k1hWwKUjRFQAbYvse0TYfbognV6OXmDx6UjYDnoXRl/Ucz3EU9HT/RQq8tWp0hNb538IZJIOGuct7+QIqMFiSAOgAbm/TmAv30FTdLhFjqJaPxvbwjShCh9JKhSG9jaw9wP7rhJ675Q6MK9avyiwUmB586oEqh6gSMEIg==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 14:40:42 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 14:40:42 +0000
Date:   Tue, 6 Apr 2021 11:40:39 -0300
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
Message-ID: <20210406144039.GS7405@nvidia.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405052404.213889-2-leon@kernel.org>
 <c21edd64-396c-4c7c-86f8-79045321a528@acm.org>
 <YGvwUI022t/rJy5U@unreal>
 <20210406052717.GA4835@lst.de>
 <YGv4niuc31WnqpEJ@unreal>
 <20210406121312.GK7405@nvidia.com>
 <20210406123034.GA28930@lst.de>
 <20210406140437.GR7405@nvidia.com>
 <20210406141552.GA4936@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406141552.GA4936@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0331.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0331.namprd13.prod.outlook.com (2603:10b6:208:2c6::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 14:40:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTmsh-0019DW-Q6; Tue, 06 Apr 2021 11:40:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4779066-176d-4e6c-d3dd-08d8f909f3e4
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42676D482D3787D5F20FF19EC2769@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DyMC1ukkr3ZEQ7nvGmqTegzKIqIM0ejkeuBzhFC2ab3x3wNX19qG9KlXOSXtGD2NmFhCAP4kqEOisEpmkQcwBCFkcbSi+aZs3jyZoyu5n3WK2i00e2jip0OoW85qhbB/RnLaPW6vlukHO7+0DZjw/WP4qJTkzpC2FQhb98kWS/quhN+c/79dhLeV2nVm9O0cS/An8jAQHtuFcmx8FwPrJ/Ecy2Z6AhlmvL5sf6rmtBY8yGA2KvVaP+Awkq8J3iwuZfD1O0ZRR8HEIzRE9TQ9CXAiS3Srh9azklb3CfuQHL3XaKaGnLPMH9U9877K0acKB4T+TyPxeilw6/SKl4ZvpvtRUzpjHgiEvaZQ3X/Ayk3wydFTUsEgKTnGSN02bueP60Fj1f1ZyaWxBSbaWsXW2wvJiiS46eF8s4bT1kBZLd3qo3axuRXVGB2vX9uJmO1Dsp7eseSTaAizsqKFw1jmj48PHcRVfl6d6Eeq55OwKZuyVxjOeMbIbnLCAAOJKo3o+HbiBZzuR/b9BNYkXHQvCrHuUDd2vnHceO7HveXqnToVPhw8oAXBCS2zEl+BV22Z2HkUWqMRrLy8ooMN6DLkwgRjbeAsRFkFWhHzZvnSAipr8ZYv5WWgQV4xPlONdQ+aJv20ZYFvnojrl6zXPtdH90gfnkpuMJlzv86j9g3hfmc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(38100700001)(9786002)(33656002)(6916009)(186003)(8676002)(36756003)(66556008)(5660300002)(316002)(54906003)(9746002)(83380400001)(1076003)(2906002)(4326008)(8936002)(478600001)(86362001)(7406005)(26005)(7416002)(426003)(2616005)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8yphmt3yGhHX5Zsba9uMbf0nWm1Fs0hkgV4Wzs/lPfqePvsmbEWytuuf/d2e?=
 =?us-ascii?Q?Az1ssoz301u6Vt3/iNqzxEBgust9VUqGVJHoCb7xkhg3W700ViSbdTcVajUV?=
 =?us-ascii?Q?bXR2i84J4sAbPGPTgtDDibdEyc1Zydv/0R1nkM/rcVL5+DvtqczsHfXSoz9M?=
 =?us-ascii?Q?3xBr0ai1qz+5SctuAeSLZ47T6XajXypyTsyj5DJ7OM4wBGu8q/wR0kxVciq8?=
 =?us-ascii?Q?XB4lG8tCIRQRobOyPMn1YoR1mA/Vl9lTn10+8hcctEVO05IQC0B82N9ExZI9?=
 =?us-ascii?Q?BsvPekysXOIggEhxlQe06mMmAIaDlHo/NcR7JDeYGWujIu8ztDywoPnO/pB+?=
 =?us-ascii?Q?vgVNF1POd5/IID/AhoiD6vHM0oWo2TYT0WMuUa8xcqOgO50gep5iQyytB2OD?=
 =?us-ascii?Q?PXDnDWgqreSjhI7LBb3jkdRK36qjsskmFvRJDapCXVjvKB2aA9A5n1wTKc1z?=
 =?us-ascii?Q?By/6zoT/XbQr1eSkdyYdktC41JcdY01YtiHgWXYWePIQcUPFo8TxnUn68t6v?=
 =?us-ascii?Q?ydUsMlvoLRzi2cGmhk6iVso7CCqK7pnv9GF0sP/flW62znx6ptc4w4dLaOzZ?=
 =?us-ascii?Q?4gzje2+HV4jfK9rxsZ/LZHBRo+BgcAMSxtNXv2b65Ay4kbMbeb2Tuy1OBkLx?=
 =?us-ascii?Q?OZIY509mVnAYU34JOeurarq825ZJg3r6P6ViuJU/o5lelzgukzkDxmFSFdxS?=
 =?us-ascii?Q?d3fNqegdUAoonEAQ+PbDylUMrYGWYxIDI06kxHqKYRgqj9bp7XcHYYZm9EkT?=
 =?us-ascii?Q?dnWSwq9bb32lQls+uNtjTFv8OLY5Davz/PiCrIA2hxe177YZn/SHfX+jDETN?=
 =?us-ascii?Q?4FCE9uE5rZypTRQTOY2YWTRnu+6SzwXAKRXNvoNlvw8RLhfvDaDS3TFLXUFu?=
 =?us-ascii?Q?HS5anVfYmI0cjWIhQ8dTPf2rNjDOzKy6R6CgYp1CRtI5F+b5Rd/dUYRgpRf2?=
 =?us-ascii?Q?EtIhk/yWvRPqtbZlxF878M05S8Pkj9xjIN1xrgEGb6Vzb/Cm3lsC4vsQRTkb?=
 =?us-ascii?Q?ZeUXIBu/yRsJTMnLfCYSgqxgChBxVP3HOEtnXSebtET7/x3L9RxouPNr4seh?=
 =?us-ascii?Q?td9Sj/8C7pXKBrKTgrIruTPOboyurdm1Aej8LtS1YdTUkXvsWOB2Yoz3Uwe6?=
 =?us-ascii?Q?BbSjE93V40li0ENQqIKP+ApxwCCmOiH5JsseQ3lAHsQSfbtdsEayjDpDhN/1?=
 =?us-ascii?Q?5blG9OxWKTKk4pjDSrM0cB+c6AiAU4r0wer0T+lFpKyjGLUIogC+b/CLTcju?=
 =?us-ascii?Q?ef4FE48vIce5nVYdaqZI/Tt8CBfV9In0Yev9pMfInXrLi8VUoBzjGvsmXGJn?=
 =?us-ascii?Q?LMZgcLzo6rGcE0xq4qqXndXLtF6NeAifd4yt+KCbHWoM7g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4779066-176d-4e6c-d3dd-08d8f909f3e4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 14:40:41.8155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJRKVGEknL/KzJR/nZzGNpfhXsAKDNN/iumt1+FprcSNhoDz7G0UO8stOCAdTz7j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:15:52PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 06, 2021 at 11:04:37AM -0300, Jason Gunthorpe wrote:
> > It might be idiodic, but I have to keep the uverbs thing working
> > too.
> > 
> > There is a lot of assumption baked in to all the drivers that
> > user/kernel is the same thing, we'd have to go in and break this.
> > 
> > Essentially #2 ends up as deleting IB_ACCESS_RELAXED_ORDERING kernel
> > side and instead doing some IB_ACCESS_DISABLE_RO in kernel,
> > translating uverbs IBV_ACCESS_* to this then finding and inverting all
> > the driver logic and also finding and unblocking all the places that
> > enforce valid access flags in the drivers. It is complicated enough
> 
> Inverting the polarity of a flag at the uapi boundary is pretty
> trivial and we already do it all over the kernel.

Yes, but the complexity is how the drivers are constructed they are
designed to reject flags they don't know about..

Hum, it looks like someone has already been in here and we now have a
IB_ACCESS_OPTIONAL concept. 

Something like this would be the starting point:

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bed4cfe50554f7..fcb107df0eefc6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1440,9 +1440,11 @@ enum ib_access_flags {
 	IB_ZERO_BASED = IB_UVERBS_ACCESS_ZERO_BASED,
 	IB_ACCESS_ON_DEMAND = IB_UVERBS_ACCESS_ON_DEMAND,
 	IB_ACCESS_HUGETLB = IB_UVERBS_ACCESS_HUGETLB,
-	IB_ACCESS_RELAXED_ORDERING = IB_UVERBS_ACCESS_RELAXED_ORDERING,
 
 	IB_ACCESS_OPTIONAL = IB_UVERBS_ACCESS_OPTIONAL_RANGE,
+	_IB_ACCESS_RESERVED1 = IB_UVERBS_ACCESS_RELAXED_ORDERING,
+	IB_ACCESS_DISABLE_RELAXED_ORDERING,
+
 	IB_ACCESS_SUPPORTED =
 		((IB_ACCESS_HUGETLB << 1) - 1) | IB_ACCESS_OPTIONAL,
 };

However I see only EFA actually uses IB_ACCESS_OPTIONAL, so the lead
up would be to audit all the drivers to process optional access_flags
properly. Maybe this was done, but I don't see much evidence of it..

Sigh. It is a big mess cleaning adventure in drivers really.

> Do we actually ever need the strict ordering semantics in the kernel?

No, only for uverbs.

Jason
