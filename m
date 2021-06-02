Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486443980ED
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhFBGPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:15:16 -0400
Received: from mail-mw2nam12on2080.outbound.protection.outlook.com ([40.107.244.80]:20193
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230264AbhFBGPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 02:15:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQXrndndJ5gHLUiRer2sF7vvOFTG+/FCfnIo2oR/d/YpxdqTGMDDCe3+r7J071411O6xP2xmDixYLAZja9NpWtqaEr1e4ZQlbCU35A8zyvLpoMVsUcrWJlGiIc4SALkGesYTTFN+coBbjIQ4c53kmxs/KSWB1in40wafhC0nk6xxCD1tK2fZSS1xEw1BcemaegFiOBx44CXqLzdUS7KutC+az0LFdXvTAHE/dpClYtWMAuR4vsotadv433FivqSUi5K5CO4G7dII6w8b1SowkIUX342Hgju3U0YGquPVjT75IroK6NkbAZ3u0UPNFVc7UiIzi6tE+852c4QRfRVXBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqCHOy+gyoBP4DVlbeWbMdSnmO1Xwkv01pObQN1hRXE=;
 b=K1vJwYYiRGkwyTGhrt7rtj7i3CfrGM9ZxQW0k21XeXnhirltPaIi5FzZxyHY8/+VFnGdaoy39Mgo668XPyr7VobzpCRNCcJyG4+IQO6Npqosm0JhIA/aThPLzvOVFkDypQDRaRVFMdyHEe0I7Cl02E/ltKtFDsJWUGK92cA4T63PIJ1aKWw0WcTjKiP9J2cOmGP4cCSHGm8h9V9nQYE4T+xe6OqXeVvkGpE5BWZ06x157CGJw8MUAPyOo+kL/WYvjWutPc43Y1DTV0RYph2qDsV7x/c2qR6W8WhoYzkvMM+2sShQ04bVdl5epiZ4tsfC1F6sE2ybSKPA9PuZcuG6dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqCHOy+gyoBP4DVlbeWbMdSnmO1Xwkv01pObQN1hRXE=;
 b=fx7J7FZdiJm2xyoPC2du5b+ic/3XM2BvuM743NrJzoe+Fo9rdseiqQxSrW1mVjVMOmgH/cYFf2dnJv4nCBo2yHK9e77BwGbqI9XntExSHgHjyPMa+1zOQRtRwMKVXW9lo+f0TaVImOLzFE5zJQNxunQOiAkE/ccSesqoDEL07nQKvWvY45WIjn3aVYX6Imim+4/y2ebfeFNT/QyQ+Z/lCSJJtuOigaLGF8+KxebvE8g4bT7D3c6+/fX7Vxu3FmRjxDPaJl3+9Zhqg66u6xlv6ERIn9og9Q6oDrn9A2AkyP4RD9HfdFb3if6koYaBuerKtzXJS1A9TDbENfF9pFWdaA==
Received: from CO2PR04CA0177.namprd04.prod.outlook.com (2603:10b6:104:4::31)
 by MWHPR12MB1821.namprd12.prod.outlook.com (2603:10b6:300:111::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Wed, 2 Jun
 2021 06:13:30 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:4:cafe::d9) by CO2PR04CA0177.outlook.office365.com
 (2603:10b6:104:4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 06:13:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 06:13:30 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 06:13:27 +0000
Date:   Wed, 2 Jun 2021 09:13:24 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH V2 3/4] vp_vdpa: allow set vq state to initial state
 after reset
Message-ID: <20210602061324.GA8662@mtl-vdi-166.wap.labs.mlnx>
References: <20210602021043.39201-1-jasowang@redhat.com>
 <20210602021043.39201-4-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210602021043.39201-4-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e453ff38-73e2-4024-4469-08d9258d8b03
X-MS-TrafficTypeDiagnostic: MWHPR12MB1821:
X-Microsoft-Antispam-PRVS: <MWHPR12MB18214E30136874730D1469C6AB3D9@MWHPR12MB1821.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULKuKHS2fX1KnE6zvWpFKZ2WNwnWbt4WS09l/ob5bXZ9Z6hWN5Tb5Euaxt8mZ5z7wzZeKO8z838Xly+wWfUZncZbhhH5tCGcR3jRmNRWrIerqKecfDGW5hbs9xb2ZxtDfWsJ50TGmJjS/l5GoWumVlSxWeCDbVeIB1c/Vbf0UT5DMQDfWW7dVfSVpC0ozzPvSkBSG3zRYYcmMn5lOhU3NbNKM4ZCdR9R/380jXTtYkzSk//WQDB8QEfVS9Clhys1ie7mFM4ElOre6bSRDFOAp6PN9Cf7Dd1nuj7nEwOiVZx58b1qcYz+EOPUJtOjFrDV4s2782ZCw69uvBiSamFYzhqy4Cu7N1lQ7pr10aHzVdFjZZaZslMRuyBQhg9Jv1ljAH8xrD5xCzTZBurBZdTMfKuihF55RahNf+p8ltPsuMwoI75AXqOYlYGwUL9fc6ZeZeUJNYeSqUArTk70UDPhh2HlmakN6H5KGp+rLGFW/No85rcdq5PIGtqk42UZaDxWyuOq3Kryt/ybURVAuxJLEkFvjY1n7J349qHhJH8+AkF9qfn0rRopcPDBrXHv2kAm+pRed8eani+zzDOBkNRInuNtSMZcpdAwk62NaXeUk9O79T9WZdWjTBpNFL7DmJO5rgb6j1eTooPKbS18chIoFePqDtxvIPkapP2MIXe1EHg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(46966006)(36840700001)(7696005)(6916009)(4326008)(36860700001)(336012)(33656002)(1076003)(426003)(7636003)(107886003)(54906003)(8676002)(82310400003)(86362001)(316002)(82740400003)(83380400001)(36906005)(9686003)(8936002)(2906002)(70206006)(26005)(5660300002)(47076005)(16526019)(478600001)(356005)(55016002)(70586007)(6666004)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 06:13:30.1410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e453ff38-73e2-4024-4469-08d9258d8b03
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1821
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:10:42AM +0800, Jason Wang wrote:
> We used to fail the set_vq_state() since it was not supported yet by
> the virtio spec. But if the bus tries to set the state which is equal
> to the device initial state after reset, we can let it go.
> 
> This is a must for virtio_vdpa() to set vq state during probe which is
> required for some vDPA parents.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vdpa/virtio_pci/vp_vdpa.c | 42 ++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
> index c76ebb531212..18bf4a422772 100644
> --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
> +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
> @@ -210,13 +210,49 @@ static int vp_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 qid,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int vp_vdpa_set_vq_state_split(struct vdpa_device *vdpa,
> +				      const struct vdpa_vq_state *state)
> +{
> +	const struct vdpa_vq_state_split *split = &state->split;
> +
> +	if (split->avail_index == 0)
> +		return 0;
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static int vp_vdpa_set_vq_state_packed(struct vdpa_device *vdpa,
> +				       const struct vdpa_vq_state *state)
> +{
> +	const struct vdpa_vq_state_packed *packed = &state->packed;
> +
> +	if (packed->last_avail_counter == 1 &&
Can you elaborate on the requirement on last_avail_counter and
last_used_counter?

> +	    packed->last_avail_idx == 0 &&
> +	    packed->last_used_counter == 1 &&
> +	    packed->last_used_idx == 0)
> +		return 0;
> +
> +	return -EOPNOTSUPP;
> +}
> +
>  static int vp_vdpa_set_vq_state(struct vdpa_device *vdpa, u16 qid,
>  				const struct vdpa_vq_state *state)
>  {
> -	/* Note that this is not supported by virtio specification, so
> -	 * we return -ENOPOTSUPP here. This means we can't support live
> -	 * migration, vhost device start/stop.
> +	struct virtio_pci_modern_device *mdev = vdpa_to_mdev(vdpa);
> +
> +	/* Note that this is not supported by virtio specification.
> +	 * But if the state is by chance equal to the device initial
> +	 * state, we can let it go.
>  	 */
> +	if ((vp_modern_get_status(mdev) & VIRTIO_CONFIG_S_FEATURES_OK) &&
> +	    !vp_modern_get_queue_enable(mdev, qid)) {
> +		if (vp_modern_get_driver_features(mdev) &
> +		    BIT_ULL(VIRTIO_F_RING_PACKED))
> +			return vp_vdpa_set_vq_state_packed(vdpa, state);
> +		else
> +			return vp_vdpa_set_vq_state_split(vdpa,	state);
> +	}
> +
>  	return -EOPNOTSUPP;
>  }
>  
> -- 
> 2.25.1
> 
