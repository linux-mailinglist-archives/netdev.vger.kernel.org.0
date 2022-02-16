Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846AF4B812C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiBPHQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:16:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiBPHQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:16:14 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58A4B0E89
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 23:16:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zl6SOuEpVzZ3WGsSW8bLOjieO/W7oAvCZnD6IBPJjR9NN826nJt6+HxpD0JpasarGlfAEEGq54WzKmPLi/EMDS25zMSikvupPkFF9GrkeJSJkr0CG7bQ+5uKqZOKX0o8oe1ONgurqk2KULmHhUnqiv7JENXKQ+49vSAzeVHfZ0WEaVPfmoliD4IF+RiUgdPiK8rBOomG85eGowPuKnQZ/P/jXBeGlVlwYR+j05K4eschLliCrc26GdyhllY30DlYNn3FBV/+JI+HDeGxwLgpdI9/Dha5jwqf6H1rENVSF9LXHeJgkZLj0k59c0Qid5AHhy7ImrS8+qvCAB09A8l7+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XivT0T4VeyriQ8axHz7SSS5qedT8TQh8BnOLT/Wcyt0=;
 b=bMPhtFEpbon57S5LAnZiXNZSguzuAMC74bwPI93ztzD/3Oawk9Wq8PikAZhhCXNnLxdgJT0lEA7oa05cxllLqiK+9xUs8n0pIgXrw8JeocFEam12uM3PHSH7puhVnSFvmBerngeCe3J9HahFCe0pIqBxlexwVHceCv0cU3cpVUFdXAWXOzAKlEWGHnhdKTAK5TG6eknE3pEdhqNuXeqE4OIsxx7z5uqkKAu/ewkXF12GnbbaKa5epiQW191tJfgt+xpPhxv3rF8D/FZHeydd9K36bu7CAkNxD5RNnY52BwUgHDxb/YapfNJdaYl+NcEiIuiOLOv1Cn/+lSMzBCDs7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XivT0T4VeyriQ8axHz7SSS5qedT8TQh8BnOLT/Wcyt0=;
 b=r7y+Spxlv7Y8bOegwr+ztIdTUVt4ys8uUEmKU0uJ69c7Olc4yoW+pF58OoPDMqqoPUsUc2MLONtM8256r/izdP4jc3BLZ5kk+gD7jcT9W2BKVd/uOSEoZ5V3ZfgOEJkJffeanhFMdT1dC9a9kEKfUxTFALxQpGKdPYxHuIEbel0As+ttOjuB3zALOFnsgOLj5Bm7u8Z6wclroJIEhsb67D4TRrKjiLJSyKKKGtSQWY9Tm2uTFrW6fioiALRRltEjigK7v4Qbw6aKiV8Xhw0e5AYLws5Flusp8PfqCy6S+9pt8+W/AR8yV09M3yI8Uc3MEz5he0ivetzWLd93nfDbDA==
Received: from DM6PR02CA0045.namprd02.prod.outlook.com (2603:10b6:5:177::22)
 by BY5PR12MB4997.namprd12.prod.outlook.com (2603:10b6:a03:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 07:15:59 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::2d) by DM6PR02CA0045.outlook.office365.com
 (2603:10b6:5:177::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15 via Frontend
 Transport; Wed, 16 Feb 2022 07:15:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 07:15:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 07:15:59 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 15 Feb 2022 23:15:57 -0800
Date:   Wed, 16 Feb 2022 09:15:53 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: Re: [PATCH 2/3] virtio: Define bit numbers for device independent
 features
Message-ID: <20220216071553.GB2109@mtl-vdi-166.wap.labs.mlnx>
References: <20220207125537.174619-1-elic@nvidia.com>
 <20220207125537.174619-3-elic@nvidia.com>
 <CACGkMEvF7opCo35QLz4p3u7=T1+H-p=isFm4+yh4uNzKiAxr1A@mail.gmail.com>
 <20220210083050.GA224722@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEtBq_q_NQZgs4LobSRkA-4eOafBPLXZJ7ny9f8XJygSzw@mail.gmail.com>
 <20220210092718.GA226512@mtl-vdi-166.wap.labs.mlnx>
 <185b96bb-68bd-9aef-b473-1f312194b42b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <185b96bb-68bd-9aef-b473-1f312194b42b@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bfc44cd-35a6-4945-0e48-08d9f11c2ec3
X-MS-TrafficTypeDiagnostic: BY5PR12MB4997:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB49973F166A9F8578479B8763AB359@BY5PR12MB4997.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: at59p8rad2VTNkkLU8kJUBocU9Wk9B5AEze5zmRqofWhJts7tNGQHn/xSpjReqdMul6Lkq+gwofOTQl+N7cU3fMckKS8WRqn6P+rWChLskWU3VBxvq831Wq7iDAGM/tMLsuonA+4cGcbXp1IWYtbOF6cZp6a/qoEUZH1Lbw5PPLy+UDNPnlorXG4ko0QvmyMhr6YhKsUTLU9chMwLBywdW6e19U89HQcoJ4eLhncB/d3Qr4wDiNP6Muwx3CEni+YDbugTPadIMIpaizh06LTpkwfD9LcXlOLUMk8qh0kPhsf6Apq4JaqusF9UH0LzioLWXv16OOuwNKjXURnmVVNt85jEie1JSep2w6Hl+WxR8KXpO7cJyk8QkdG4gZxyYLc7t7cehgdZJFo73EYEBimk4Rmb+KmGv1gpOV7efs2LV1izJusADlpVyoRGi3s+K1/tNdTBjtyrONVMnP1HyanSUiF51oBHVwIuwWfPpSHaI1uxS1SGJDLw31JQMOxGsa6J2kYkKrfmCD/5tOU+08E5haDUbLfXmCYspPSdVGLY+9JyjzVnkQNzRLMJoozl+8huH8+ZrVTeR3AE1aX3YXmCzI8Mno6/fISUHj6i+t35GiB4HZzg/oiU4lWNghL9gXThJZTr3P2lRv4wjQfAQowVvpKG+Vp+9+DojIJWCVSr+nu2aUk/TPKAp/kx7Fju+mZ86imbikgu/xpZmKr7uqJnA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(36860700001)(40460700003)(2906002)(6916009)(81166007)(356005)(70586007)(8676002)(4326008)(70206006)(54906003)(316002)(55016003)(8936002)(5660300002)(426003)(336012)(107886003)(1076003)(16526019)(186003)(26005)(83380400001)(508600001)(9686003)(6666004)(33656002)(7696005)(53546011)(47076005)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 07:15:59.4143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bfc44cd-35a6-4945-0e48-08d9f11c2ec3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4997
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 02:06:54PM +0800, Jason Wang wrote:
> 
> 在 2022/2/10 下午5:27, Eli Cohen 写道:
> > On Thu, Feb 10, 2022 at 04:35:28PM +0800, Jason Wang wrote:
> > > On Thu, Feb 10, 2022 at 4:31 PM Eli Cohen <elic@nvidia.com> wrote:
> > > > On Thu, Feb 10, 2022 at 03:54:57PM +0800, Jason Wang wrote:
> > > > > On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
> > > > > > Define bit fields for device independent feature bits. We need them in a
> > > > > > follow up patch.
> > > > > > 
> > > > > > Also, define macros for start and end of these feature bits.
> > > > > > 
> > > > > > Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> > > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > > ---
> > > > > >   include/uapi/linux/virtio_config.h | 16 ++++++++--------
> > > > > >   1 file changed, 8 insertions(+), 8 deletions(-)
> > > > > > 
> > > > > > diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> > > > > > index 3bf6c8bf8477..6d92cc31a8d3 100644
> > > > > > --- a/include/uapi/linux/virtio_config.h
> > > > > > +++ b/include/uapi/linux/virtio_config.h
> > > > > > @@ -45,14 +45,14 @@
> > > > > >   /* We've given up on this device. */
> > > > > >   #define VIRTIO_CONFIG_S_FAILED         0x80
> > > > > > 
> > > > > > -/*
> > > > > > - * Virtio feature bits VIRTIO_TRANSPORT_F_START through
> > > > > > - * VIRTIO_TRANSPORT_F_END are reserved for the transport
> > > > > > - * being used (e.g. virtio_ring, virtio_pci etc.), the
> > > > > > - * rest are per-device feature bits.
> > > > > > - */
> > > > > > -#define VIRTIO_TRANSPORT_F_START       28
> > > > > > -#define VIRTIO_TRANSPORT_F_END         38
> > > > > > +/* Device independent features per virtio spec 1.1 range from 28 to 38 */
> > > > > > +#define VIRTIO_DEV_INDEPENDENT_F_START 28
> > > > > > +#define VIRTIO_DEV_INDEPENDENT_F_END   38
> > > > > Haven't gone through patch 3 but I think it's probably better not
> > > > > touch uapi stuff. Or we can define those macros in other place?
> > > > > 
> > > > I can put it in vdpa.c
> > > > 
> > > > > > +
> > > > > > +#define VIRTIO_F_RING_INDIRECT_DESC 28
> > > > > > +#define VIRTIO_F_RING_EVENT_IDX 29
> > > > > > +#define VIRTIO_F_IN_ORDER 35
> > > > > > +#define VIRTIO_F_NOTIFICATION_DATA 38
> > > > > This part belongs to the virtio_ring.h any reason not pull that file
> > > > > instead of squashing those into virtio_config.h?
> > > > > 
> > > > Not sure what you mean here. I can't find virtio_ring.h in my tree.
> > > I meant just copy the virtio_ring.h in the linux tree. It seems cleaner.
> > I will still miss VIRTIO_F_ORDER_PLATFORM and VIRTIO_F_NOTIFICATION_DATA
> > which are only defined in drivers/net/ethernet/sfc/mcdi_pcol.h for block
> > devices only.
> > 
> > What would you suggest to do with them? Maybe define them in vdpa.c?
> 
> 
> I meant maybe we need a full synchronization from the current Linux uapi
> headers for virtio_config.h and and add virtio_ring.h here.
> 

virtio_config.h is updatd already and virtio_ring.h does not add any
flag definition that we're missing.

The flags I was missing are
+#define VIRTIO_F_IN_ORDER 35
+#define VIRTIO_F_NOTIFICATION_DATA 38

and both of these do not appear in the linux headers. They appear as
block specific flags:

drivers/net/ethernet/sfc/mcdi_pcol.h:21471:#define VIRTIO_BLK_CONFIG_VIRTIO_F_IN_ORDER_LBN 35
drivers/net/ethernet/sfc/mcdi_pcol.h:21480:#define VIRTIO_BLK_CONFIG_VIRTIO_F_NOTIFICATION_DATA_LBN 38

So I just defined these two in vdpa.c (in patch v1).

> Thanks
> 
> 
> > 
> > > Thanks
> > > 
> > > > > Thanks
> > > > > 
> > > > > >   #ifndef VIRTIO_CONFIG_NO_LEGACY
> > > > > >   /* Do we get callbacks when the ring is completely used, even if we've
> > > > > > --
> > > > > > 2.34.1
> > > > > > 
> 
