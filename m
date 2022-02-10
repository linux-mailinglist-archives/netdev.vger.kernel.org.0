Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE4B4B0972
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiBJJ10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:27:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238197AbiBJJ1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:27:25 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E3E10B2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 01:27:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OK/hvM468pHjUBTKyjJHH7fHTctw/CFE3BMS+YD1gez6wjd5YWTzNdiDNEbobl5ILQzPMgVsPQtk55E3oW09vtTQAd/3UNeS+YhlBvHi5ujXL0ggtQJ0C0814Jg8Av0dAeL90Mo8wxyAYn3NEX7Azuss8Mq20bOjefUYQQ80ttsAHcCYQrfkqRmJVoHi+jxHUESsCJSZLGe1VfgWvjxIwcfySgtrsDwKYgjP3WvKk8ayj4xr8ZaFbyFZiIkv5Lh1+qcf0EPnVitn/AyxjoRK8PI5LCew6MCx1PGm9J/a3SkujDZtsglYs5W2ECTzbz8JLz8vduxf4SdPKKxUA5uSQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFSVFh9HOvYHWl0OAbMG+4Wz3aBePaxbTQ8As7E7OZk=;
 b=LTlc2JFCLOOXOOjkvjzb/GYJSFamL9GH0NshmAkQtQ1xISdUAaxml9XY4tavPlh8q/Kz5xqpSMOaunyg7gIbecW6zxs3qJ8cXgbTzkZoqQ0GDLVqLTtxqK9OMDvI83hBsXAh7p08Ejlp6AjoY6AzYGz4biLQPFaO+pJLDz+AbYldD4xeHReo2LgBqtl8vB1Jll80ZkN0IZWfjzWdz8/jeJm0H5lgigVCSZKuZMXyL2gG/51zAIi4R+alFnBuw/3msWJKkyAcyGyDUWPGPyXSoQ2TMjggQnOyLn2L20iQBH9sEEIBuY0B3b6Nc+6z2ISrMeu8CcS9ORs9+nct3/1avg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFSVFh9HOvYHWl0OAbMG+4Wz3aBePaxbTQ8As7E7OZk=;
 b=XB4959+KiickWoqiBtKjcaavfAULaklPQ8Cm0scu4xWUp+FpNQC0ftxjUhxAdzORUxIynd4QKPHvL71hiRsfbLxXH6pl38LmUAFs5k/0rzULT2JrETimuMAr8Pd5KgVv1o70e3oi/+xaxGoRpfJdOg16owEfrn8JpPISDk4OBr+yyIq1059waJb5ILHACFXqrz2z/Y7TqJiCWT4wMZ5QpZQDKoI4F/0WMXyyFvJZ8V0tD+WURTdkUGmfp7ypRUXmKbdSfQLnxsFkVTT4CoCBogrPfbDvWnSE1QieoKiuq+El7SFZI5ddsHCQovgNmYJmxwNW2hgqzPN49hICuN/yOQ==
Received: from DM6PR08CA0029.namprd08.prod.outlook.com (2603:10b6:5:80::42) by
 MN2PR12MB3950.namprd12.prod.outlook.com (2603:10b6:208:16d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Thu, 10 Feb
 2022 09:27:24 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::42) by DM6PR08CA0029.outlook.office365.com
 (2603:10b6:5:80::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 10 Feb 2022 09:27:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 09:27:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 09:27:23 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Thu, 10 Feb 2022 01:27:21 -0800
Date:   Thu, 10 Feb 2022 11:27:18 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: Re: [PATCH 2/3] virtio: Define bit numbers for device independent
 features
Message-ID: <20220210092718.GA226512@mtl-vdi-166.wap.labs.mlnx>
References: <20220207125537.174619-1-elic@nvidia.com>
 <20220207125537.174619-3-elic@nvidia.com>
 <CACGkMEvF7opCo35QLz4p3u7=T1+H-p=isFm4+yh4uNzKiAxr1A@mail.gmail.com>
 <20220210083050.GA224722@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEtBq_q_NQZgs4LobSRkA-4eOafBPLXZJ7ny9f8XJygSzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACGkMEtBq_q_NQZgs4LobSRkA-4eOafBPLXZJ7ny9f8XJygSzw@mail.gmail.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5ba7fbf-21e5-452b-bcb8-08d9ec778bf6
X-MS-TrafficTypeDiagnostic: MN2PR12MB3950:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB395060D9CC9E91F46AC49C3EAB2F9@MN2PR12MB3950.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e7b+EMOO4EZy2oyCwufAl+6DUXeU9FegdWp7LXH2DhmFd3bnVmrHh+wsMULmHsBp1E1loWcOBwaVC5fNg0h+0QpjQV+755Xg9XHJQiQoj1naxp3AKa8/jX0nRbpu1wh362POODgQf1P8sBWjs6iN9dMVQdW+IWUHlfoejD12/4XXN/4dUvahFj5haOzBp5YHEwLAbW8FiqodOVhmoFI9vXZvWB9dQWdYQeHiCDlSzG24BwEErGcrtITOY/uS2Fz0OjL+af0tdjRpw9g9AJAeRpZwJc4VrMzxCIckIO8Hmp7EduNUh+SbIPCVXG2H84f4+CkWbHHSwW0EG6Mu/NgSDo8R8KOSz0GZY+20pz16KDPaqkuPZapLjdWzeUBqQvvC1F10frxcOIEyF+C4YJqbkybINz2YT7Dqd3OUDSaP885iTWOMFpQjEeTy7mj7RgoW7uWHoBqSCrdtcqgnhaDtREdO56FSL0ca+5H5Flqy43wtHpNphGrco43eELRHzpNHJtpy7jaW29yGyu1YSV6xyXhAXKaZlyw/uShXbj0CGaKFh/7HuTySg1C9jjOM8EnEY6SBPD6u36J8iJFP8QDUM3pebfAdQg502YQXsl0kF0/ygN/ekCWH0y253dNJWgsTlIqvEOdqFAgb/A5LZLPRWhy+3/DjSXu1X+RVg3Nkl4pOGoXNkcZnbGpcr+WzielsPvLxxY5ohkPkxwUA87GvVg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(186003)(1076003)(426003)(26005)(16526019)(107886003)(336012)(4326008)(54906003)(6916009)(8936002)(70586007)(8676002)(316002)(70206006)(5660300002)(7696005)(2906002)(9686003)(40460700003)(82310400004)(356005)(83380400001)(81166007)(55016003)(36860700001)(47076005)(508600001)(6666004)(33656002)(86362001)(53546011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 09:27:24.1696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ba7fbf-21e5-452b-bcb8-08d9ec778bf6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3950
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 04:35:28PM +0800, Jason Wang wrote:
> On Thu, Feb 10, 2022 at 4:31 PM Eli Cohen <elic@nvidia.com> wrote:
> >
> > On Thu, Feb 10, 2022 at 03:54:57PM +0800, Jason Wang wrote:
> > > On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
> > > >
> > > > Define bit fields for device independent feature bits. We need them in a
> > > > follow up patch.
> > > >
> > > > Also, define macros for start and end of these feature bits.
> > > >
> > > > Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > ---
> > > >  include/uapi/linux/virtio_config.h | 16 ++++++++--------
> > > >  1 file changed, 8 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> > > > index 3bf6c8bf8477..6d92cc31a8d3 100644
> > > > --- a/include/uapi/linux/virtio_config.h
> > > > +++ b/include/uapi/linux/virtio_config.h
> > > > @@ -45,14 +45,14 @@
> > > >  /* We've given up on this device. */
> > > >  #define VIRTIO_CONFIG_S_FAILED         0x80
> > > >
> > > > -/*
> > > > - * Virtio feature bits VIRTIO_TRANSPORT_F_START through
> > > > - * VIRTIO_TRANSPORT_F_END are reserved for the transport
> > > > - * being used (e.g. virtio_ring, virtio_pci etc.), the
> > > > - * rest are per-device feature bits.
> > > > - */
> > > > -#define VIRTIO_TRANSPORT_F_START       28
> > > > -#define VIRTIO_TRANSPORT_F_END         38
> > > > +/* Device independent features per virtio spec 1.1 range from 28 to 38 */
> > > > +#define VIRTIO_DEV_INDEPENDENT_F_START 28
> > > > +#define VIRTIO_DEV_INDEPENDENT_F_END   38
> > >
> > > Haven't gone through patch 3 but I think it's probably better not
> > > touch uapi stuff. Or we can define those macros in other place?
> > >
> >
> > I can put it in vdpa.c
> >
> > > > +
> > > > +#define VIRTIO_F_RING_INDIRECT_DESC 28
> > > > +#define VIRTIO_F_RING_EVENT_IDX 29
> > > > +#define VIRTIO_F_IN_ORDER 35
> > > > +#define VIRTIO_F_NOTIFICATION_DATA 38
> > >
> > > This part belongs to the virtio_ring.h any reason not pull that file
> > > instead of squashing those into virtio_config.h?
> > >
> >
> > Not sure what you mean here. I can't find virtio_ring.h in my tree.
> 
> I meant just copy the virtio_ring.h in the linux tree. It seems cleaner.

I will still miss VIRTIO_F_ORDER_PLATFORM and VIRTIO_F_NOTIFICATION_DATA
which are only defined in drivers/net/ethernet/sfc/mcdi_pcol.h for block
devices only.

What would you suggest to do with them? Maybe define them in vdpa.c?

> 
> Thanks
> 
> >
> > > Thanks
> > >
> > > >
> > > >  #ifndef VIRTIO_CONFIG_NO_LEGACY
> > > >  /* Do we get callbacks when the ring is completely used, even if we've
> > > > --
> > > > 2.34.1
> > > >
> > >
> >
> 
