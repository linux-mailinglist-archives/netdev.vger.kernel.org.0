Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2599E4B0852
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiBJIbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:31:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237549AbiBJIbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:31:22 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00171111F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:31:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEfXwbUkGczzGpxaiu4B5R2/QAFqebFaredttM0JQEFHIWHvgQz7/lQOE6T18hCPEIrCq/fE4hjBiJVHLFz3MQ8EMcA7XIMrqLSRej+qEoXO47qUTNOwQROrSswj6WGHoxdLsLwbGaaIPtvneAERzOVYkqknu0aTSk/ORBIFtUuTzMVCWuxYVQXAytMjnxT7HczVxmEw6PMn3o+jQuYB9H9U1DyCT/czumv70IEjsFED3huKJyh2OrhVQ6q6a4Fygq295x8uRfu4yxvwTUlbQXtcobJGVHMq+N5iP6yEmK5GD9y2aBfyagNrHnqZan7pElb5765ByFVvuoL1Tb7VWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wu/V4/xgTOfKc1OL6FObu/GqL/Wo0DHVck8fY2zcUSo=;
 b=CT6xsFvF4rK5spqKi2iZwnqhdaroRliqXpzeDVECbHjv6x14LWDT2XLmSBLcQQUy/i4Hmw3sj8OlYpOwk9ZnZc4Xx9AzugtOqtWK7+20Yj2vH7LX2BtE/8aaBN6xaobcWOn9br03Gr8P0GdoNZz+NDhDzn2H6xO5PJmCjlkJwGQ6Py4hPJicRTxS+RFigb3+9D4bss1Cqn03uDO5F7lOmBstZaou02VSY+QBEEQQbt1ikmto3Clq3Ms0/m3B19FqVceYINfFy6fpH5ikE9meS/5lqgFHIqWo4paP2YZJGEeltUxmPO0sWKo70kp5MpNvxmPyUo3B6ZSTTZZDCIMmEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wu/V4/xgTOfKc1OL6FObu/GqL/Wo0DHVck8fY2zcUSo=;
 b=RFm6SxkKLCO+/gijBVRSwxNNtRmZ8ByuNywYJR2JXl90XMQjxNAe3oh2VZNBkvYYPHmGAOkpE5RZtjjEO+g1oK4hIOj8GEtEhSJPm3Gfk2/aks5m9CVVHFPorZm53FwDQrenjj8FhKT1aAyVZyrH0zf3oEeLROgecPHhhIY1GIA6xaG7r2I9QYIDXMcmL3f3q+cSgLpny7pb5cM7rvPu85SaU0XqHJQfG6rwOG/alwV1GFRcc+SRyw0k89MUT8FvEvnJBCGwgq35eLvEA38ibzso/wukMeiR/iaFQv7u6L6W9mBRh52rn7rPfFJ0nw43EL7HYuSvCqhG8Rq4hs6+Hw==
Received: from MWHPR18CA0041.namprd18.prod.outlook.com (2603:10b6:320:31::27)
 by BL0PR12MB2372.namprd12.prod.outlook.com (2603:10b6:207:4d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 08:31:22 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::4f) by MWHPR18CA0041.outlook.office365.com
 (2603:10b6:320:31::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Thu, 10 Feb 2022 08:31:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 08:31:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 08:30:55 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Thu, 10 Feb 2022 00:30:53 -0800
Date:   Thu, 10 Feb 2022 10:30:50 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: Re: [PATCH 2/3] virtio: Define bit numbers for device independent
 features
Message-ID: <20220210083050.GA224722@mtl-vdi-166.wap.labs.mlnx>
References: <20220207125537.174619-1-elic@nvidia.com>
 <20220207125537.174619-3-elic@nvidia.com>
 <CACGkMEvF7opCo35QLz4p3u7=T1+H-p=isFm4+yh4uNzKiAxr1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACGkMEvF7opCo35QLz4p3u7=T1+H-p=isFm4+yh4uNzKiAxr1A@mail.gmail.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dda0f94-9599-470f-f9aa-08d9ec6fb78b
X-MS-TrafficTypeDiagnostic: BL0PR12MB2372:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2372410B21C02F9091BFC798AB2F9@BL0PR12MB2372.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6gi+Im2slsWu5SyCdJCUE7kBssCqQMVAEXBPkqlRNNnuYa4rdT5ycDere+HYwyXvsm37kqzvkBRbqzAGcdqJ4EoIhXu/onAKLBufT7T3gH0ZRJOYLF9eKD/7FnPp32HsvyBL6ozyojBCQdRdkwMuE2IQl5+Pw9qUj/Zlq9pteucsYzifXTMuQFjnWPdW+0DAISv7y4YWB1J5LXWjP3u17nHziX2QV5/XmNRSsZ00Cew/m4mqZasx8Z+ulk1oqq5uZ8RKc96qdirtDPqxD/0QwIs2yJ4qWjstQZurfQcUblHPSgL+NDEVTUhigYSsDWn/6Z+3wRiaHBHuYOXLNIhC+VEyV3PdqV9TmnexRIUEh20eQpFEb4s4/uzRBX4t3saVtxbK46pLV7DgPGbMi3labrFh54ooQBshpKsrjLRMQ3spz2UwG7CiIgfffmMlCOdbZUVKdn074rMOyCie3vPDWDlADfBouD3U63OPwqFng061UvaZSHqnoClNklXJW7yeDGtN4t3KNDheMJzhN0L72nSkgzEsW0YmKziST7oVRZ+ZeMNLp20Q2kKTtyAaoDJstze0yOmvjjmm1apNqsgDa7BuQp+ar20Dw9ystuSr/0LZZAkfZMphDqa9MGMppS69RG8+azSafGZZM1jPMwOTLtqOh9uTx6jqphze3wmJXC1M1ZoxGUE5ei4IOjTph+1f1PRvSH+6yn7F6wIWRh94tA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7696005)(316002)(81166007)(47076005)(356005)(4326008)(54906003)(8676002)(86362001)(83380400001)(55016003)(6916009)(426003)(336012)(70586007)(2906002)(70206006)(36860700001)(5660300002)(8936002)(107886003)(186003)(26005)(16526019)(82310400004)(1076003)(33656002)(53546011)(508600001)(40460700003)(9686003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 08:31:21.3471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dda0f94-9599-470f-f9aa-08d9ec6fb78b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2372
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 03:54:57PM +0800, Jason Wang wrote:
> On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
> >
> > Define bit fields for device independent feature bits. We need them in a
> > follow up patch.
> >
> > Also, define macros for start and end of these feature bits.
> >
> > Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > ---
> >  include/uapi/linux/virtio_config.h | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> > index 3bf6c8bf8477..6d92cc31a8d3 100644
> > --- a/include/uapi/linux/virtio_config.h
> > +++ b/include/uapi/linux/virtio_config.h
> > @@ -45,14 +45,14 @@
> >  /* We've given up on this device. */
> >  #define VIRTIO_CONFIG_S_FAILED         0x80
> >
> > -/*
> > - * Virtio feature bits VIRTIO_TRANSPORT_F_START through
> > - * VIRTIO_TRANSPORT_F_END are reserved for the transport
> > - * being used (e.g. virtio_ring, virtio_pci etc.), the
> > - * rest are per-device feature bits.
> > - */
> > -#define VIRTIO_TRANSPORT_F_START       28
> > -#define VIRTIO_TRANSPORT_F_END         38
> > +/* Device independent features per virtio spec 1.1 range from 28 to 38 */
> > +#define VIRTIO_DEV_INDEPENDENT_F_START 28
> > +#define VIRTIO_DEV_INDEPENDENT_F_END   38
> 
> Haven't gone through patch 3 but I think it's probably better not
> touch uapi stuff. Or we can define those macros in other place?
> 

I can put it in vdpa.c

> > +
> > +#define VIRTIO_F_RING_INDIRECT_DESC 28
> > +#define VIRTIO_F_RING_EVENT_IDX 29
> > +#define VIRTIO_F_IN_ORDER 35
> > +#define VIRTIO_F_NOTIFICATION_DATA 38
> 
> This part belongs to the virtio_ring.h any reason not pull that file
> instead of squashing those into virtio_config.h?
> 

Not sure what you mean here. I can't find virtio_ring.h in my tree.

> Thanks
> 
> >
> >  #ifndef VIRTIO_CONFIG_NO_LEGACY
> >  /* Do we get callbacks when the ring is completely used, even if we've
> > --
> > 2.34.1
> >
> 
