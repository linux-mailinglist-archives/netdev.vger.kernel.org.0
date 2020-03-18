Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94288189BE3
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgCRMXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:23:04 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:41665
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726619AbgCRMXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 08:23:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLrpk3Rq6BLMJR/GRyulnnTHHd7w/e611GsBx8vtaM122jLCwnCEra1Gfy9+BpzAHgVOjD/zTLFYNK4JDmC70rh2cKZNdzVjAtqYfMSft1yHuU2pEwcXOV7c5QoBoX++LFmCWfPHJwgfmvOg2gn9THtC28goY3LwK14gf/IpcsAibTuljGKPS+5HcUPuE6iiSm5yLF1j0CrikP2eg31rbdOYb2aa7OZqvF33yhcXnyVAXFPLPKtF/g21oHvkulgc3lqnjnzbWacjClxc5ICCcnKbBe3rbahF+0Pu8gJUPxyXUsmKzpBZQWkWctB6bgBPctRGs0n06PbPv3FgRZ8EHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rB/uBdueeVigHfVcZMb5CFpU4VPCCU/lBLqFKfnB1Pk=;
 b=k6IkCUE1/K5SKDVSFUaOO4LgqrSy1JToientLUYZS6Arqpue1yt3FWkXumJCP4oNPFELUyly/YIJCcMfTZPnCWEhRSeEHq5n3ifRQKVoqATa8L5UT97Yoe0IM2A+sJqbdghhhDfuOpIlUK/Qy1OpbepJRnfLG9q0XalTU+DEXZyElUXAPVkCC5LFOlbd0maum2O15fu0BC1Csg/NkxnWnmrEyh7QOTKwunvDYUaOQUH0+ZgpZOZE83IvVGOlhprr9/gCRASdrr5j5bLRfFS1sInHsGaEsCc73pDbwOwsjU8QRkz3FhmQwHSmOHEkxrYCIEBDoyxmwSpydAOVKNBdNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rB/uBdueeVigHfVcZMb5CFpU4VPCCU/lBLqFKfnB1Pk=;
 b=eTV2S5Qrsd6IOw/RLUu77Dpm/l7tB70QIg3quX9ary1XX1vS+xo5ZreZfLizA2Eh3CvNfk6nUHlshrMN1BXvo+27fv30TyTyNwMdjmuO/tqBxjxmqnIBIrjpfkFSSMLD3sPrgZTEOkn9HxQ3Q6/yF8JyHe7fvhd9KO++oEiuFrU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB6287.eurprd05.prod.outlook.com (20.179.25.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 12:23:00 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 12:23:00 +0000
Date:   Wed, 18 Mar 2020 09:22:55 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        Bie Tiwei <tiwei.bie@intel.com>
Subject: Re: [PATCH V6 8/8] virtio: Intel IFC VF driver for VDPA
Message-ID: <20200318122255.GG13183@mellanox.com>
References: <20200318080327.21958-1-jasowang@redhat.com>
 <20200318080327.21958-9-jasowang@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318080327.21958-9-jasowang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:207:3c::37) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0024.namprd02.prod.outlook.com (2603:10b6:207:3c::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.22 via Frontend Transport; Wed, 18 Mar 2020 12:22:59 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jEXip-0003l3-Nt; Wed, 18 Mar 2020 09:22:55 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fec168ad-986f-4206-50c1-08d7cb3718fe
X-MS-TrafficTypeDiagnostic: VI1PR05MB6287:|VI1PR05MB6287:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB62877A2DB1010E5C9AEFEB0DCFF70@VI1PR05MB6287.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(199004)(5660300002)(33656002)(1076003)(2906002)(4326008)(478600001)(36756003)(2616005)(26005)(7416002)(6916009)(316002)(81166006)(66946007)(186003)(52116002)(8676002)(81156014)(66476007)(66556008)(8936002)(86362001)(9746002)(9786002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6287;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSrSkNW8+D2kNXHpww3h8hJluflkZzGOIh79EuYU+2TLCHlZRNxbzEGTmHn0XltAO6VF3gLBBb3M5aRjnHf+rTmqy1qhZUxJolqubRKglLwGp1EpMzqrZNNYdBJ79YhfIcRkquRbsyCMOQ8bKMH7rmXxCoRx/32D1vBdiZBdVOpKv1igi7r+HeBRAotlM/O83mmucFvYjj2IOicwSHWZw59v07qWy6HWx60dfXT8fLtQPEugAbq0v3ROm+7h4bUfAZL1cenrHTvkGhB2plb9VV7OUhA3DV9TZwXxMmg8ETBDtm79y+i6v1L99VRktnZB1pRwljzTdHW4rpfkVuak+2nBliMWMYBet4RgtjSE9PO1HtY0Qyo4R+ry8WSSL43eDdi6J1ySRtNszrKOQpXOQYYFaOmDAiWq5p4lw36Emk/EdKA08/0Seohf+aU5wZnIfdMrKJS+8pdDFKMmBsG9dSUOV76h8thea/Wy9QBPCOi/TYM/K7e/YZ712zdWhKz8
X-MS-Exchange-AntiSpam-MessageData: jcbSCfrIPijc1oNK75p2M4+d/bq4WllgNO6A3kZnDZL4UtA7upLCtRZd6l34k6oPCz/yYGHOlYeItYYN14SJ+nfp2NnaAPilUtiVM58PCC/mSk0atAEyJ8RIAJbFOZE+BHTl9cH7hlJEI3nombHrxg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec168ad-986f-4206-50c1-08d7cb3718fe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 12:23:00.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AobLBU8Ex34USRB44Gs6xlDaeFK8kukgSZxfiwA1BuYjBWVzZLG+QxdSfYVtrgBgDwqTznZzTkhKrQBDfU8s0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6287
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 04:03:27PM +0800, Jason Wang wrote:
> From: Zhu Lingshan <lingshan.zhu@intel.com>
> +
> +static int ifcvf_vdpa_attach(struct ifcvf_adapter *adapter)
> +{
> +	int ret;
> +
> +	adapter->vdpa_dev  = vdpa_alloc_device(adapter->dev, adapter->dev,
> +					       &ifc_vdpa_ops);
> +	if (IS_ERR(adapter->vdpa_dev)) {
> +		IFCVF_ERR(adapter->dev, "Failed to init ifcvf on vdpa bus");
> +		put_device(&adapter->vdpa_dev->dev);
> +		return -ENODEV;
> +	}

The point of having an alloc call is so that the drivers
ifcvf_adaptor memory could be placed in the same struct - eg use
container_of to flip between them, and have a kref for both memories.

It seem really weird to have an alloc followed immediately by
register.

> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index c30eb55030be..de64b88ee7e4 100644
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -362,6 +362,7 @@ static int virtio_vdpa_probe(struct vdpa_device *vdpa)
>  		goto err;
>  
>  	vdpa_set_drvdata(vdpa, vd_dev);
> +	dev_info(vd_dev->vdev.dev.parent, "device attached to VDPA bus\n");
>  
>  	return 0;

This hunk seems out of place

Jason  
