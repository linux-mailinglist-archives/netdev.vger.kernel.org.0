Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6F9398101
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhFBGTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:19:18 -0400
Received: from mail-mw2nam08on2048.outbound.protection.outlook.com ([40.107.101.48]:45266
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230468AbhFBGTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 02:19:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSTQJjybnOg8b9R1dx7uzz6d3pnHxC3VSBt47qj26d6NebK4wOLUt+leBUVmyvpt/1WStNTTP3wYlYL0oWuJZmESmtcjBSdphyMhLU4ZLn6ngN8ayt7xKn5ki9PRH2YbLfX5fLCUkLDwBY8Dx7cjvOBl6/FSZKD5P+qC+sIG2/bc89frXAtg9IRG+saPhOYngKbY7nJXQ7Q05bZsJMAK5E4kSR8RsulZGkuqL/G5jCMMFu02/Hgp75FUXi0SRs0OPR4JLJVGWInJnrjMhCG4odhkJyKRHMWe9c4KjvNiJG9uGjvBJu00OfrXDNTckkqTFwP8G85Z5BfyIb+yUUe0Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PzUl2Ss1hcWxO7tCB4pdwvj5nFmJLmfX2QL6XWMl8s=;
 b=E+hVZX93lgFnHas0Z0QAmS2iGQ7pGUaZvMid7xEJ66DaQNgZyg3uD5/8sJ0ae4XgU6MJ2iSZAbXLoqrsAuHDgzAxD8YWbx6UxUbJb5gngJqgp4ru4b8MoOYZ/bEq7xMbdQJQGkl9DHt15q1935gmujBTnFqChIV0ENKQ0B7T4leTlWkAkWOiqdpmAxq+s+1nLKfBoy5nMJGYm/gV7tb9Yv5BAR3WHqBnFg/ynNguv6O7UULz0Kx3UcPn4GXzuqsDO3UPDEjG9IyXPA2Yq+fa8GtlrGwo2+6srTMfoC+DPLgrx+b0omq8FSEaWpeySxZmfmIPFiPsRvuoTTQSMpVKmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PzUl2Ss1hcWxO7tCB4pdwvj5nFmJLmfX2QL6XWMl8s=;
 b=jrduVEDFRKyI2fVv3NNufnwAf6Yf5zHYbasLspGVzAdWd7M+QtEAIHhEA2w6iyrOZUtrm11pODu4bOYqwdmjPKVUYTQYQPfHxEaBEAVUpLNzb9vMbNlXzlP2riZELaACQJvuIuY61ElgaOXCloVU1pgAAGfpeHi0wyUGMypWG3h6sVrr61AuPdOokKlP6dJs6mhERe02vzOdM0jHwZBR6oT6+g9DL610RmxVYG0k5TzwMEw9G4SUe+fFW72kIG6IUFkK++oHKl7Z4r0UkSyOiClv4aNqJmgYQFcTwFSP+4mtiVXNsy7NCKEJRN1iYRE8IllcI7lnhiU1Q5zXOwdhMw==
Received: from BN6PR14CA0032.namprd14.prod.outlook.com (2603:10b6:404:13f::18)
 by MWHPR12MB1550.namprd12.prod.outlook.com (2603:10b6:301:8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 06:17:30 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::f) by BN6PR14CA0032.outlook.office365.com
 (2603:10b6:404:13f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend
 Transport; Wed, 2 Jun 2021 06:17:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 06:17:29 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 06:17:27 +0000
Date:   Wed, 2 Jun 2021 09:17:23 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH V2 4/4] virtio/vdpa: clear the virtqueue state during
 probe
Message-ID: <20210602061723.GB8662@mtl-vdi-166.wap.labs.mlnx>
References: <20210602021043.39201-1-jasowang@redhat.com>
 <20210602021043.39201-5-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210602021043.39201-5-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec2e45e9-a5d7-464e-1c6d-08d9258e19e0
X-MS-TrafficTypeDiagnostic: MWHPR12MB1550:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1550EC82F48A09EE0F2325F7AB3D9@MWHPR12MB1550.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:196;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: snIBeVmWBd4z8LGFrNnhi/wiQCOjM70w4BBMw030Y8smNRbX5+Vf3G2OdXDk0AgKxV50VwKKO6lOimnRyWKc5SKFx93Q6c1x6S06kO9+oMHoE3kq9EIVBKONtnu60ol8bWA9ngnkZtDwlsqYk16+OLcSZhcJfk+80E71mrQCvaBI9b0F+TVyyzp4ufOtX8kYhLWmiG0u7/sGkTlzJvNEBP0ht2ti6mK6kZUZJqnWLdrFgTbooOSZ7GZeT8j6FRUecVFOAGv/UbMKyC5TPamXwQN5dwxeC1ZQyY50okQwkG7uE9SmZOOwoMOXhFJIOa+ulMVCYdpVofIecs4HsOujY0GD5QOnlw/xd55GQkd9atLmnU40HFFUFoVgi+s/FJlJ6j0ZSvR/1s1Qot7idqvbePT0pg1TawrRDEpQKs0IKfv9Filim3OWGcEIV2d2kyzpM9iEgyHbqMrhK+wx40l9A4jdlQ4NNsGkTDphvwVHE5zZ8OPGe7VUjp/z3tRynQA8brhU+7skNg6gWRXOTWBWJH0URqUnmLECGGP8xne2GbfzaOBnk4MBYQyqT0QWZo7iUzXtHHTiNxcyDqqzNoSyCKCLmRFfTeTuj51rdZwOzvEqRnbZGgQTOnbL790aF2sF+NfVA6mhaFPI9j1Dy/72cA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(46966006)(36840700001)(82310400003)(8936002)(47076005)(7636003)(478600001)(8676002)(70586007)(82740400003)(36906005)(4326008)(316002)(33656002)(7696005)(107886003)(16526019)(186003)(26005)(36860700001)(6916009)(1076003)(86362001)(55016002)(426003)(356005)(5660300002)(54906003)(2906002)(6666004)(336012)(70206006)(83380400001)(9686003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 06:17:29.7465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2e45e9-a5d7-464e-1c6d-08d9258e19e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:10:43AM +0800, Jason Wang wrote:
> From: Eli Cohen <elic@nvidia.com>
> 
> Clear the available index as part of the initialization process to
> clear and values that might be left from previous usage of the device.
> For example, if the device was previously used by vhost_vdpa and now
> probed by vhost_vdpa, you want to start with indices.
> 
> Fixes: c043b4a8cf3b ("virtio: introduce a vDPA based transport")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/virtio/virtio_vdpa.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index e28acf482e0c..e1a141135992 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -142,6 +142,8 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
>  	struct vdpa_callback cb;
>  	struct virtqueue *vq;
>  	u64 desc_addr, driver_addr, device_addr;
> +	/* Assume split virtqueue, switch to packed if necessary */
> +	struct vdpa_vq_state state = {0};
>  	unsigned long flags;
>  	u32 align, num;
>  	int err;
> @@ -191,6 +193,19 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
>  		goto err_vq;
>  	}
>  
> +	/* reset virtqueue state index */
> +	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
> +		struct vdpa_vq_state_packed *s = &state.packed;
> +
> +		s->last_avail_counter = 1;
> +		s->last_avail_idx = 0;

It's already 0

> +		s->last_used_counter = 1;
> +		s->last_used_idx = 0;

already 0

> +	}
> +	err = ops->set_vq_state(vdpa, index, &state);
> +	if (err)
> +		goto err_vq;
> +
>  	ops->set_vq_ready(vdpa, index, 1);
>  
>  	vq->priv = info;
> -- 
> 2.25.1
> 
