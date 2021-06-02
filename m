Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E907398379
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhFBHsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:48:21 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:56832
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232148AbhFBHsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 03:48:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gD7QzN8Gw6Oug8mqNiDKfKhNeATLgj2N1rpzgwsGey1GURU5IeCvim1kcigAhsBliyLZrt3UJzf3a77dLyk9DCylgi6yeUZBzFjOD3GeRxtiCnrW7danhRRjcY6HH4TWiq8wuN84azZrzmBe/wug1DIJ5pOoZYjhxLu1oxZeOkn0dXNQUMBkJ9/Zexp65Zkes7FZevAQ6YyFSI2AsBDhYkGn/QCvDKXsvFNJxuQX7BnjzxEkC3NLjrDlgwLPbrSv2HlzIZ5X42ZaCm88l+ToRoF7t/DiDxWRFqpQJefLJ+lPUf8Z9qE3529T/UU5K9cK3BffllLddAHcz/f6IaPIGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZQQhjXrc1hMMP3A0JUh4fOrIGss5rR4K/ZEzyP1LB8=;
 b=npheL9DN0Ub65oL2rEezFay7lNolOnNJV62QFvqmzqiaOV6pPJCHIHHZeBycq8dWQ/Odfyuc2PAN6kt2e/nSjCRFXitZab6jC3USMtisiW1UoMXTmgfMJ4KdiLfR3t7CNxUeAVXVs6xDm5kVvfHtGY1fi1F9raL1Zt948EIFIgEeVDC0IKBbGE4f1HvShJYUsRtEu09sPGn5RIS/xw5Ai95cbZpTef0m5CbpaWIV5c0cJ4TWyKDC7qoWml8RrYSq6vH2Z8hOHlm3UjhBVSSmgGz7M1ir4qCxx/gqUDMlmoxfSG2FiTpLyGccXZ7CncOLtplnBTgiAePzOgoS3KkZyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZQQhjXrc1hMMP3A0JUh4fOrIGss5rR4K/ZEzyP1LB8=;
 b=FjILdxGWsTbniFbex4XdsjbCyOp/g52spbwjky2M3aNwkZ6SP5Pbk/n6fnFjriLABUzTZP9GKwpjBqH5+DjfTTJxLLJd9p8/X1b/4n43MxFpx4Fqr5HEYOyKwk6TlRiGxSnUN7SKNBOFJ9oyxh/g7dKprrcw5RLhp3fYgtDrADh4ipesm5cG2c+EI50T5Q7/WbG18xlRkGKbQbkyoeMevrUj2K0Hj6iL32+V2/KdI/yRAOuvY7+MUEFNQLTOt1YjxXbKCAs+L8ZuJ4GlkA+SBSWF7eVWWeSEaluiVpYNbW/TBXe1zpdJD4pMmcokJsA1gryiiVaE97XTwqaNwndlzA==
Received: from DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) by
 MWHPR12MB1295.namprd12.prod.outlook.com (2603:10b6:300:11::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.20; Wed, 2 Jun 2021 07:46:35 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::cf) by DM6PR06CA0062.outlook.office365.com
 (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend
 Transport; Wed, 2 Jun 2021 07:46:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 07:46:35 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 07:46:32 +0000
Date:   Wed, 2 Jun 2021 10:46:27 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH V2 RESEND 3/4] vp_vdpa: allow set vq state to initial
 state after reset
Message-ID: <20210602074627.GG12498@mtl-vdi-166.wap.labs.mlnx>
References: <20210602021536.39525-1-jasowang@redhat.com>
 <20210602021536.39525-4-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210602021536.39525-4-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87ebd7d4-e7cf-4689-f613-08d9259a8c25
X-MS-TrafficTypeDiagnostic: MWHPR12MB1295:
X-Microsoft-Antispam-PRVS: <MWHPR12MB12954867F5FB59F076E11C2DAB3D9@MWHPR12MB1295.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 316BDnYtqivFAZSEZr/vAR0HOG6yaoCvmpZa8l95yrjeeodgDPFPH20mjOhOFpGMZL2CFwjFbFWfNhjjuLDn2AEnCmbVXIAQrO67TzO8FephlKKkw7N1mWq5vQdL123xAxRycliUkdNHLvMP9WSsMshMLbU2RLl3o1ojR1syLyUPjj2iQ51AfVHJyHQtyomjxEYQxcDSz7L8wgmVoOkv/t9NCg+6D9JthsEEuqNVGl+kD9PCy1PDdNElfl9dSXV7J+mR5WgWkygOV4uozDUalg8TMSXjDHuQObjprk//GTft8L8jQYt1uMuvKVEbo90clzZ2Ip1iPowOX+Q9fwNkpuDaZdE6qws4N/yck54fVvQUhNTy7r15VrWa/Xq+Vsxx/iZFWmqcvO5PhpDDWS9yrsLMA0H7cWDyx7fN0kTS8oZHMu6b485B6SV0JKYV/ZhhswZjej2tIpD+dswYeL27lnmoej6Y9hWV+BzQsq2G4P9lV9CZRohaj8mioSjheGTZvhDAZacruf5j9fxN4JsMI3BYR4FwQ11QyYlEnQFq16k3GTRWUfWqnsZv8MYRvxFoKA+ZkvQlQ2VXjcGdh4nJTYaEMhd6O3zKYk8rGxnhIMr+Pi0gx0g5QTNNWW2lAUXZBNK1HbFX8IWyXEW3FG8RGLjPOUJ9SaeQE8abGays54g=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(46966006)(36840700001)(36860700001)(86362001)(16526019)(186003)(6916009)(336012)(8676002)(7636003)(1076003)(356005)(82740400003)(70206006)(33656002)(54906003)(426003)(5660300002)(9686003)(6666004)(83380400001)(478600001)(82310400003)(36906005)(7696005)(70586007)(4326008)(55016002)(2906002)(47076005)(26005)(316002)(8936002)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 07:46:35.4945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ebd7d4-e7cf-4689-f613-08d9259a8c25
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:15:35AM +0800, Jason Wang wrote:
> We used to fail the set_vq_state() since it was not supported yet by
> the virtio spec. But if the bus tries to set the state which is equal
> to the device initial state after reset, we can let it go.
> 
> This is a must for virtio_vdpa() to set vq state during probe which is
> required for some vDPA parents.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
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
