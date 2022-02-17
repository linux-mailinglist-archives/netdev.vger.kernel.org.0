Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7014B9AD8
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbiBQI0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:26:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiBQI0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:26:52 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748E55FE4
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 00:26:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JG5pcMiR9O7vOOMNhcptMd92r/QzIa5Ym7sXm/KsdD4kUGkPuLBI/ScozWcNGZ9KADw8S6bwFZLlsOAuBld/MN/DF4B0iVtjCo73B2+nmldnCTcGvbs4CF00rdRTCc/RoLLUiR79uiV/UUpOmwWwlqmLRXbTQHLXQ6etV8Gb6iDDwV0zlBBMWhJE8tTdhXS4Mgo3Lnd7vqiWynmxAD2iWMNpnCHCvEvxoyjZuA2hrKI5Cm02/v09rEsWC8s2qDvIQwgVWQGCHnkzTURk4DQplI7HgTj/PVdAUJW5/0w8mJ0JJbRJ2MJao62xy+dc+s1O9+Z3KpTHtLbrMMNztQcXAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fh9WrFo8HgBBE0gdci3Go74vbgo77Y1oC5mf2OLkCKQ=;
 b=FFr/Fr5hw/1ZJrLF/mjxN00bxmNL8aT7J6sTYtHUZOZ/9OTwu0s8DtzVLTKsRtVscrxvKioTANMxWCFg9goZwtT55F9wivKfpjnHxmCnXdYi/Gv3x0lVShcj4q7l9vBMiaCDFa5OjQlKNuHuU797wruIuxL4bKrKmULEsFUgm/VWomAvOmMvvtgFAVe4oyD+nnUncxnw1yZc1AThEL6Fm6gNH/1OtQ5nHNUXiPwynBM0jXNrtyE5Mh3f+Pxeyj6ZLDI3e/SMlXTb3mJQb6fPlvKVSgPygE7l/bFYtsiFLmQ6R00hqpbH94GuBT/CQcOce6jx4PIBoxuT9wI9NvtFZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fh9WrFo8HgBBE0gdci3Go74vbgo77Y1oC5mf2OLkCKQ=;
 b=rVXqJYRmmJiDThzaxBFIzKuq5jzLywtIFEKT2A/yL+TDfpLyqnXq/ciwP+H5mvOI85YPBdGupwB9RMV8Zmn0IYowNU6oN+Mz8ADO1h4JmUn9KBmL5EifgV5BPJ7xAXwhb7pIOOwP10aJN7KaXZFDCs5JYth0piMZVcrsL/ij+3e/dnyr2dCa1/5QNvnAZW3lSkn+be6mHfwh/fizNJmHiJPsHRvNqhiXSjgUcZcRfCoEXQLuFTdh0sxdTAmz+uhRdd4lwKXc2QajCSa00fgBlOvCBdnPhDdgd9Cxobi/5o9Ii/xgdfb4ze8i9oDOSDcrSyrCbBlPmzSU122xD/JhcA==
Received: from MW4PR03CA0335.namprd03.prod.outlook.com (2603:10b6:303:dc::10)
 by DM6PR12MB4092.namprd12.prod.outlook.com (2603:10b6:5:214::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 17 Feb
 2022 08:26:32 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::c) by MW4PR03CA0335.outlook.office365.com
 (2603:10b6:303:dc::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Thu, 17 Feb 2022 08:26:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 08:26:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 08:26:06 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Thu, 17 Feb 2022 00:26:04 -0800
Date:   Thu, 17 Feb 2022 10:26:00 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Gautam Dawar <gdawar@xilinx.com>
Subject: Re: [PATCH 2/3] virtio: Define bit numbers for device independent
 features
Message-ID: <20220217082600.GC86497@mtl-vdi-166.wap.labs.mlnx>
References: <20220207125537.174619-1-elic@nvidia.com>
 <20220207125537.174619-3-elic@nvidia.com>
 <CACGkMEvF7opCo35QLz4p3u7=T1+H-p=isFm4+yh4uNzKiAxr1A@mail.gmail.com>
 <20220210083050.GA224722@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEtBq_q_NQZgs4LobSRkA-4eOafBPLXZJ7ny9f8XJygSzw@mail.gmail.com>
 <20220210092718.GA226512@mtl-vdi-166.wap.labs.mlnx>
 <185b96bb-68bd-9aef-b473-1f312194b42b@redhat.com>
 <20220216071553.GB2109@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEvNoG89M0m_=Z9E-d2U0tPJ2_-eiEEj3s_FGYOKTbkH0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEvNoG89M0m_=Z9E-d2U0tPJ2_-eiEEj3s_FGYOKTbkH0w@mail.gmail.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efced687-a79e-4c25-6555-08d9f1ef341d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4092:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB40922CCE1EAAD72E2B13C9B4AB369@DM6PR12MB4092.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6FUgda5MzOEoYwW5NvXXDA4xztGyXQWVWe297baq8Bgqw1/FdeChq+Y6LZUL/4f4Z0KPr+loWtpiZeiPunmvvUAi8ZHbscfRfViWORQdFDqrxhYITXchvPj2rG4bv9Y29GfptWjrvuLWtTfUOwsynIeTV4S1EHgr6Y/dBLXPyHS7zVIZQdzP4i68mLeNnhBwyr23cSidfZWA7c+VIuz5uOK1vKcKjdbIF+mSfJoxtxjdLMBIX+vBcOrSW/aABsF5/IPCvZ4SXP80uTa9VLYr5PkyJoK1Pe0kMtkj55p5M2cPiGwBmDbDqKDCJMhNpCun+/sbiQrfy8yRAS17bk3bYYaocYJtYLydz4XHIoK93vyv2TzDSTokvAMUGceBWuzqmIFhwgrhIBctRfy1V028ZdFTQ6sF1wf0tlu6+ERAv+u2u2h1APxkKuZyN2Gr0WKdAZABd6FloZaoCWf7lBV2iYjJf6CBWseNRhZ85wZNyiEnTwBoJOqoVuTReaj6FGUxfAlh5y0JSsPShAmbQWo1pXAPi+aLWaAfwX3FsikOK0dyuNHoGHyN1BU2+bi2P5NfRDdBBOkv3/fJYgryEmEjqbZeb3Z1MfCg5aNI2LJlbz2TNmDeDH/+DRFPFhkjFEmuWkLj4BhukjOkPZB0xNycpUDunstraaw50tLrM+qJVMYFoyXRLCez7GZePKhY4qEilGrLD0huDSEdM5TFo8xa7GEIJbk1BHBnNJKfW8B+rJ6o/rBm9LIzAlDdNfliGefiTrVqrU9VooZaZRHmNqzwQucRmafClThgoOTlbDtAnAeBHE6p9IqtdD6IQqL+GNHt8Tz3q0E4kZMvOV6obESgQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(9686003)(8676002)(4326008)(55016003)(508600001)(966005)(7696005)(70586007)(53546011)(356005)(86362001)(70206006)(6666004)(81166007)(316002)(54906003)(6916009)(1076003)(82310400004)(36860700001)(2906002)(16526019)(186003)(40460700003)(26005)(33656002)(8936002)(5660300002)(47076005)(336012)(426003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 08:26:32.2205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efced687-a79e-4c25-6555-08d9f1ef341d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4092
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 02:06:39PM +0800, Jason Wang wrote:
> On Wed, Feb 16, 2022 at 3:16 PM Eli Cohen <elic@nvidia.com> wrote:
> >
> > On Mon, Feb 14, 2022 at 02:06:54PM +0800, Jason Wang wrote:
> > >
> > > 在 2022/2/10 下午5:27, Eli Cohen 写道:
> > > > On Thu, Feb 10, 2022 at 04:35:28PM +0800, Jason Wang wrote:
> > > > > On Thu, Feb 10, 2022 at 4:31 PM Eli Cohen <elic@nvidia.com> wrote:
> > > > > > On Thu, Feb 10, 2022 at 03:54:57PM +0800, Jason Wang wrote:
> > > > > > > On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
> > > > > > > > Define bit fields for device independent feature bits. We need them in a
> > > > > > > > follow up patch.
> > > > > > > >
> > > > > > > > Also, define macros for start and end of these feature bits.
> > > > > > > >
> > > > > > > > Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> > > > > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > > > > ---
> > > > > > > >   include/uapi/linux/virtio_config.h | 16 ++++++++--------
> > > > > > > >   1 file changed, 8 insertions(+), 8 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> > > > > > > > index 3bf6c8bf8477..6d92cc31a8d3 100644
> > > > > > > > --- a/include/uapi/linux/virtio_config.h
> > > > > > > > +++ b/include/uapi/linux/virtio_config.h
> > > > > > > > @@ -45,14 +45,14 @@
> > > > > > > >   /* We've given up on this device. */
> > > > > > > >   #define VIRTIO_CONFIG_S_FAILED         0x80
> > > > > > > >
> > > > > > > > -/*
> > > > > > > > - * Virtio feature bits VIRTIO_TRANSPORT_F_START through
> > > > > > > > - * VIRTIO_TRANSPORT_F_END are reserved for the transport
> > > > > > > > - * being used (e.g. virtio_ring, virtio_pci etc.), the
> > > > > > > > - * rest are per-device feature bits.
> > > > > > > > - */
> > > > > > > > -#define VIRTIO_TRANSPORT_F_START       28
> > > > > > > > -#define VIRTIO_TRANSPORT_F_END         38
> > > > > > > > +/* Device independent features per virtio spec 1.1 range from 28 to 38 */
> > > > > > > > +#define VIRTIO_DEV_INDEPENDENT_F_START 28
> > > > > > > > +#define VIRTIO_DEV_INDEPENDENT_F_END   38
> > > > > > > Haven't gone through patch 3 but I think it's probably better not
> > > > > > > touch uapi stuff. Or we can define those macros in other place?
> > > > > > >
> > > > > > I can put it in vdpa.c
> > > > > >
> > > > > > > > +
> > > > > > > > +#define VIRTIO_F_RING_INDIRECT_DESC 28
> > > > > > > > +#define VIRTIO_F_RING_EVENT_IDX 29
> > > > > > > > +#define VIRTIO_F_IN_ORDER 35
> > > > > > > > +#define VIRTIO_F_NOTIFICATION_DATA 38
> > > > > > > This part belongs to the virtio_ring.h any reason not pull that file
> > > > > > > instead of squashing those into virtio_config.h?
> > > > > > >
> > > > > > Not sure what you mean here. I can't find virtio_ring.h in my tree.
> > > > > I meant just copy the virtio_ring.h in the linux tree. It seems cleaner.
> > > > I will still miss VIRTIO_F_ORDER_PLATFORM and VIRTIO_F_NOTIFICATION_DATA
> > > > which are only defined in drivers/net/ethernet/sfc/mcdi_pcol.h for block
> > > > devices only.
> > > >
> > > > What would you suggest to do with them? Maybe define them in vdpa.c?
> > >
> > >
> > > I meant maybe we need a full synchronization from the current Linux uapi
> > > headers for virtio_config.h and and add virtio_ring.h here.
> > >
> >
> > virtio_config.h is updatd already and virtio_ring.h does not add any
> > flag definition that we're missing.
> >
> > The flags I was missing are
> > +#define VIRTIO_F_IN_ORDER 35
> > +#define VIRTIO_F_NOTIFICATION_DATA 38
> 
> Right, so Gautam posted a path for _F_IN_ORDER [1].
> 
> We probably need another patch for NOTIFICATION_DATA.
> 

OK, I will send a patch NOTIFICATION_DATA. Once they are accepted, I
will follow up with a patch to remove from iproute2.
> 
> >
> > and both of these do not appear in the linux headers. They appear as
> > block specific flags:
> >
> > drivers/net/ethernet/sfc/mcdi_pcol.h:21471:#define VIRTIO_BLK_CONFIG_VIRTIO_F_IN_ORDER_LBN 35
> > drivers/net/ethernet/sfc/mcdi_pcol.h:21480:#define VIRTIO_BLK_CONFIG_VIRTIO_F_NOTIFICATION_DATA_LBN 38
> >
> > So I just defined these two in vdpa.c (in patch v1).
> 
> Fine, but we need to remove them if we get update from linux kernel uapi headers
> 
> [1] https://lkml.org/lkml/2022/2/15/43
> 
> Thanks
> 
> >
> > > Thanks
> > >
> > >
> > > >
> > > > > Thanks
> > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > >   #ifndef VIRTIO_CONFIG_NO_LEGACY
> > > > > > > >   /* Do we get callbacks when the ring is completely used, even if we've
> > > > > > > > --
> > > > > > > > 2.34.1
> > > > > > > >
> > >
> >
> 
