Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2EC43B632
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237093AbhJZP6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:58:35 -0400
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:48960
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234115AbhJZP6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 11:58:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1m3+fY3fs3Uy15UKcdNxmbeioZ5CropUhwZWypmBIynTbPH+JLCaOXpvci98PB7QTMFA92myI4TorzLiyS1lcDe23j2r8O7pIFuJ9M1EpHMM7cJwmjfUPWm+WzMcLXJAkMTTC6nzdJ/702ihGVLf+nupzE/kYAYkln3CZ7UQAmvXvBenvYNlkfDw3EAYVG2bn0ZaNEQgQ6qU3MA6wh1Of3LUhB9SU9Yo+0EAK+jGlZL6eHLW6XUUElbLRnLfl3d7b51BoAvH9ky0j4Pim1FT5MJ4MbH6KsaeDvdE4KmcDH8/HjWQ2xsXkZJCJJ8UOJVqjtgEPnFg/v4nBIRIJ979w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87VFrEPSB+jFW5KLjthWX1YJZx+KCEWsAGztAmQgkFw=;
 b=YV4oLF83rVyJzPFDBJZY2Y9FVb55tr1NmXxEZmzdrSL1MUw2GBWVQZy0Kh0u2xhYV9iZP8iVJ/pVcox6JK3Uv6/eAMUK9wVR8s1Zw0DIjhb00OGDKoWmPF2ZyblHcSrGjeQqjvdUasDT+fts6ipBP4j45qTzvi9oh6bY2o7J+h3Vz7YdLAgg+fzqkbMrBllXIyBh8HolqBwGhlNufzHVKehvs46vN0Nj07/Dj6JKGXWh+m9HPe/v8Kj/t9ZWwnPufjTYBVvPILdt5chiDxX39dqMz4C9b1hnqyG4SzljbHJ7sEORuJTmoYoGhLYOSwPuHzJdAExg99WcIfGegGQdXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87VFrEPSB+jFW5KLjthWX1YJZx+KCEWsAGztAmQgkFw=;
 b=s7j6E65seE+tut5rs6S7ywVGx7bKALmvc00rBK8RBGWYi/Njjk47gwBm8MH3UzRhN1WtlcQ6Y4Cm2CTz5z+p0mX19ePF8gW9OUjdbQrwcqY6h2EBH5nRuIoFDIPGe9r9lovRtebuO4xjqr0exLrFzjXnzc+d98c7CP1U/FPo6fqUmffB/L0RnhKf92NYiQAlH29GL7+5b1z6Lt4ETsqRuUaoK6aAHQYUOe6D8qBiAQAssmeN+NionIexPaK/gnAB/SSOAHV2B3q0bQcIRfN+PsMBaAi96+QeVMkMvpYw6VOvRBKR61g4jQvzGbWdteEd29NG4U55NIgnL9zPRzAeRg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5301.namprd12.prod.outlook.com (2603:10b6:208:31f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 15:56:09 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 15:56:08 +0000
Date:   Tue, 26 Oct 2021 12:56:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211026155607.GY2744544@nvidia.com>
References: <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <YXbceaVo0q6hOesg@work-vm>
 <20211025115535.49978053.alex.williamson@redhat.com>
 <YXb7wejD1qckNrhC@work-vm>
 <20211025191509.GB2744544@nvidia.com>
 <YXe/AvwQcAxJ/hXQ@work-vm>
 <20211026121353.GP2744544@nvidia.com>
 <20211026085210.000dc19b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026085210.000dc19b.alex.williamson@redhat.com>
X-ClientProxiedBy: YTOPR0101CA0003.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0003.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 15:56:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfOo3-0027sy-6l; Tue, 26 Oct 2021 12:56:07 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b719b52-ab2e-4b53-b8e9-08d99899200e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5301:
X-Microsoft-Antispam-PRVS: <BL1PR12MB530185290598A15FED1B4940C2849@BL1PR12MB5301.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BToxLGzOUEIeRApdyi25j8JyCTd4F2Ea2N7FCYY5QWb9r7DD+f/TTHPvx33eddA6KnMo2WgWNy6BfiTxUYF6h1Af6FOMGQmXplvcq2Uix9SJiQVEc89oJg0nNdnG93IRK9zon1iB2RBuJ0uHs0dEfcUqENdZR/MXZWc14GkivngPGr1cjDHjPjhNv4+WZq8+gl/oy2CJpp10d0Et2jEk5ChOIJEOmbN70LVEC0PmRoNfgmaayQ3+l+C8E8J4bjyn/3/5CXhzEj4Sw8i7l/luM2plm4fmllXRo5JnJrmb/sRd9pMUETbdIJ51yq3zl1j1Z/84UfT7jL+QH0/cJwaeY0BCJgx1QB3daVzzWu/7KG7NY1IgqDzNlEMDokl4BDnxBAJyj7uDdiuULR+t65Bc069ScFAa0fOwOUCa1nMaL5XwVpEimf7UYJsN6Nch/nAFmW0h76sGU/uP6NJmRDNE6IbeVLQMWuvi0YefS2zFdc8Zwmu4ETgEqRuzIHnBRwygBGKoUVExKATvHVMpKmCzBuKCJMvUrm6hyMdf8RLMdJ11t1X781/tAhT2kwpdwEkjkj0Mf04DwHaKNlcAQxy3dPLaYjTBGcfLlz6jwAgwtW8z9WbqKqL4XiTOba5JxgdEEJglDrMkreG5AI1Ubs3F5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(426003)(4326008)(26005)(2906002)(6916009)(2616005)(9786002)(9746002)(33656002)(186003)(1076003)(38100700002)(8936002)(54906003)(8676002)(316002)(36756003)(66946007)(508600001)(66556008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P3MlHhyT5WpBtvPjXF+OxocZtBa85YCcXme7IodEnxiYj9h8nbHKccM3JDhL?=
 =?us-ascii?Q?L94NEJ63JQ8jgn/B2xyds/DI1QGAjAZfGCfp9eAngRD3RjsdA9a23mv554fi?=
 =?us-ascii?Q?sFUXFziZfwVxQaEK7GKsfmgIXeHkGRTzrNJ+6VUXGkMevJQDvCTUHmjy+5Yf?=
 =?us-ascii?Q?Xpc8u3rf7CQDYFc18LJbzYoA37r3nvbGQXKayvg/bbVfX0bR8ek76GK98KJE?=
 =?us-ascii?Q?Xkt9ajQ7vyviJiK8+DGw/BL2COxOBkQromCA7ak9YBA7rm1X+8TwA+ptSYDl?=
 =?us-ascii?Q?40SxL/y4Dkr31cbL0BDKBrph2VY8rUO0AEmgY+nagu779mSUEuGGpjPxPV/d?=
 =?us-ascii?Q?YlovvjrOl/fnr2QipRzh8J9ZA3MEraeNkAQgpZnPIL0lnKqpsbqC/f0BmC54?=
 =?us-ascii?Q?yGiV0Csj+tRzPL4Gi9noIB73sd5PQSW7SGhRI7QVXfTT7IbDEDln4hNpmtEk?=
 =?us-ascii?Q?bd1AM3xwWMTID3RxjxndmUPB8AUflDFQoU1DVVRAgxfziLdV7wyAmG6LDQyN?=
 =?us-ascii?Q?zSL5tVXmxPh0/TFPTvhYqYZLqtUbTKbxiDp9aLXmZ6qdo/ueric7psYQS0UZ?=
 =?us-ascii?Q?t8YxRpXgWfli6PCFovG6JOjkn5e+2k1HqqJb5odjSvdoFR82ZVhUmzlhgCln?=
 =?us-ascii?Q?eXCmqWBzQHnS4d6xgPbTTIjskkF+ZzzjPsvcftLxAGKkVd2zxtsCfZf1z+Tb?=
 =?us-ascii?Q?YvJkjy54nXs7thf7pfq5QQKWjhoCi3GHATKx3Pyk0TplTEp/YHTXdtEskvaA?=
 =?us-ascii?Q?1P+FehUaUHYkvRbsZm+8vfNT9IVoSLzZAt1NbRaPBizRQ/OyZT3JrMd1bBD0?=
 =?us-ascii?Q?TyPBj9k51TNLUNoWw8BHw2H4iLsF9reQ6U1q8WjkpGKoHla67hPnJ1kvfZ+G?=
 =?us-ascii?Q?M51P1apA2E5lWLY3R76I+G+oE3+cLKQiXSmDgeBB2sT19vCpdoUeMW3TSQv5?=
 =?us-ascii?Q?itsjZ1jk7hAuoRDto99L1wobL5U3aR9oX+orZ8vTeG7KipIIY9IIQgLkn8A/?=
 =?us-ascii?Q?a56vNS1fSyVp6inE21bbsVRQnqw+ohEEkzzl0hTI7px1DWgfCTlgf3ADDwR/?=
 =?us-ascii?Q?yte2nFNekZ9sR/YOT6VsFPS3wAOHQHUJufFoFEXqzY8S+9WXQ0UFQbZvVsT6?=
 =?us-ascii?Q?nYP2kt6VkExVxrpDBbJni2YuebXVGnJCcs21240gZLCPt5L5B2VUWM53R3oS?=
 =?us-ascii?Q?9Ant+L3uFf08oTO8NYSdyQsCUBlrSXv+YQazUg+WRFrekuKUg5cXm5nNeLJ/?=
 =?us-ascii?Q?VsrQPttdIEy3ZcZiCrUktxVhsssGilJun6xf20a8z8JDH4FnkRLaVe+aJ6xx?=
 =?us-ascii?Q?pDML6z5nc6ZXCa35ZlpTwsICpQcTD3ob97Y0bn7ZybF8fnWF9Q38vjWV6gw1?=
 =?us-ascii?Q?qEvaFZniXCLOMNGHJRDTjt1dofCAPIcZ8Hy8gCg4S0XmbMuNbbcTPfsFLDUd?=
 =?us-ascii?Q?LUpa2tUuK3uG8ykWFmfQUKJ8bms0z790vlqLCDkMnIo4N/DqT+4+IXUj6iBp?=
 =?us-ascii?Q?JfL5OEMsY/wQpjuxtrxBp1gis2e4ZKYJ2Lb4ltCMjz5/7zy/wewnRrVxNjZE?=
 =?us-ascii?Q?MnuGqQQr+w+6D1Vn3E0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b719b52-ab2e-4b53-b8e9-08d99899200e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 15:56:08.7129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 08p5e/UcSAyT9iEI7jpVUEFFOFsgvOo9I+hEZAluj7CjXS15vVBnpWTpNiOGM/+b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 08:52:10AM -0600, Alex Williamson wrote:
> On Tue, 26 Oct 2021 09:13:53 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Oct 26, 2021 at 09:40:34AM +0100, Dr. David Alan Gilbert wrote:
> > > * Jason Gunthorpe (jgg@nvidia.com) wrote:  
> > > > On Mon, Oct 25, 2021 at 07:47:29PM +0100, Dr. David Alan Gilbert wrote:
> > > >   
> > > > > It may need some further refinement; for example in that quiesed state
> > > > > do counters still tick? will a NIC still respond to packets that don't
> > > > > get forwarded to the host?  
> > > > 
> > > > At least for the mlx5 NIC the two states are 'able to issue outbound
> > > > DMA' and 'all internal memories and state are frozen and unchanging'.  
> > > 
> > > Yeh, so my point was just that if you're adding a new state to this
> > > process, you need to define the details like that.  
> > 
> > We are not planning to propose any patches/uAPI specification for this
> > problem until after the mlx5 vfio driver is merged..
> 
> I'm not super comfortable with that.  If we're expecting to add a new
> bit to define a quiescent state prior to clearing the running flag and
> this is an optional device feature that userspace migration needs to be
> aware of and it's really not clear from a hypervisor when p2p DMA might
> be in use, I think that leaves userspace in a pickle how and when
> they'd impose restrictions on assignment with multiple assigned
> devices.  It's likely that the majority of initial use cases wouldn't
> need this feature, which would make it difficult to arbitrarily impose
> later.

Either supporting a freeze/quiesce split is an optional feature, and
current mlx5_vfio is an example of a driver that does not implement
it

Or, freeze/quiesce is a mandatory HW feature and no VFIO driver will
be merged that doesn't implement it - even if the HW cannot support
it.

Frankly, I think we will see HW that doesn't support this and VFIO
will be required to have it as an optional feature

What does userspace do? I don't know - but it does need to be aware if
the optional HW feature is available and it does need to make choices
if the VM will be migratable or not.

I don't see any path where userspace truly cannot care unless HW
support for this is mandatory.

Jason
