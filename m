Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C09F398372
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhFBHrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:47:31 -0400
Received: from mail-dm6nam10on2054.outbound.protection.outlook.com ([40.107.93.54]:57569
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232066AbhFBHr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 03:47:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5/Dwepyc5012XxltrgCv2q2WjU6+BXU5yr0Ks5Lu6pNE32sX8lPM51lxDBrjmFTLn4OdxFEmeD62mtz93eWz5kEkOMu5ZqO4ZCSQqSZKikPAnBpblUA0mSImAZb3iN0tB4aSZ13RCjsZryiBwRQWtYsYUCWJVR7VUYLIxME8mkCbiGMyKl9l++jV7FHTV+GWh+98dQwNkZYIorOsDDXSPFsFNtcZLDrPrpZt0Qis9N2rsO2T6WuyXebhg845oy47x1tL7B03IP9yCpDV6mCq3Vn1Coz/dnfRJD1rHn4TdmLHybGbrc81kA1QGi3XZETARTDk8gwq84AhVuk8BOnnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5E3TAo2EhsOo9HEC2KDkGZ6jzX1mC6VL8nSyUk3/V8=;
 b=bySDgcp4SXncjSttzIq368X/ZL4CBQS71KFvYTyzQIixV+R5Z2xcSBGyWX1F8u6+Gea0b5zPl70OLTDxIjsM5btwMfQovSTmEOIVebCFSiNC7IRnc8mxJgI7hcddrM+VWm+CEOEdbw1FupYkF+4SdUAdX7oF+iX7cI64db6qInBxKlWGZvhbQg7T6M83At2GOHw4AN5AqlKjo9llEj/M0CB6lUyJ6pkuXUhPyQZVC+w/Yu6cflKgTI/O/T5uhCbClAfDAQbRlcjuaA/eTemBx2ICN8XRhMqz+/wr7Gaj7drJ3XPuoEUCZshx78cR11XXuO3LBVPSXAJIX64Psf/ECA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5E3TAo2EhsOo9HEC2KDkGZ6jzX1mC6VL8nSyUk3/V8=;
 b=EG/omIuCM/U65fswsDlbJKDw0EBwI6pOWk/myrVPtiSSMm01qcOvJ18s8U5p+vS5GmTgDwSX0uQEesLD0Kh8huoFcXwKmWaL4pNASHy2OzGHYwTb75vU31OHmySZslgywjV7guJ7DvmNjGox0KdPRsKPQXKS0rX+9/G4ngeF5Be4Oltg9zyiyVa9bUlkI6nTtgv0fPLDAaHlihdMY4N1o3Vg9VmUKjN1HomKq6YB6Cr79iIK++DeQgaMM3Tmen+ByAB1O137vXTS6zE93wqZMwNpNwfl7AjAr9AeJ5LlaW/U59ChhsB2oF9Rh2DhHJ6KD93fJRUZoVNwj7A9rj53+g==
Received: from DM5PR07CA0089.namprd07.prod.outlook.com (2603:10b6:4:ae::18) by
 DM6PR12MB3707.namprd12.prod.outlook.com (2603:10b6:5:1c1::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.21; Wed, 2 Jun 2021 07:45:45 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::13) by DM5PR07CA0089.outlook.office365.com
 (2603:10b6:4:ae::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 07:45:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 07:45:44 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 07:45:41 +0000
Date:   Wed, 2 Jun 2021 10:45:36 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH V2 RESEND 1/4] vdpa: support packed virtqueue for
 set/get_vq_state()
Message-ID: <20210602074536.GE12498@mtl-vdi-166.wap.labs.mlnx>
References: <20210602021536.39525-1-jasowang@redhat.com>
 <20210602021536.39525-2-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210602021536.39525-2-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d07882d2-d686-4e77-3ff9-08d9259a6df6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3707:
X-Microsoft-Antispam-PRVS: <DM6PR12MB37072E5EEE83B167778005D3AB3D9@DM6PR12MB3707.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlpGkib3lQRmPAJjHH8v1PEH20GX5zfukGGuIt2w5EDNJXxPnnYcFd1GO+9RyHezJFjRg1VeBkGf0Vq9y99FBClrKtqIlomOcqtxN85PhU4jVbrF51PjXh68rwS/xH7Gx3RrbYwxZRfI+2urS3Qg02bmQKtvAWqDfBTDwuERIv8i4CQaS0KyjGuZCUSCqVdj0ED/Qf374EfWNzQ+u7gUSxjMk3PUn3Ek2L5jQwpuB3CdhDfl0x989fEmqfmGOZcOjj/xP+Kjf4ehIx+DRj6xJy+HN6g62P7hKPs/lX4iwLBmrR+QjahrZrDNL3VX1DzefKd05ZoOFTsVb+8cJhZqIV7dIAPPo6ESDgNiXTxoHseL9aDj2P7deh9HflVuY2fLjG2FFzZYh7rSei0kvlTXRFJ7iHEBc2OxbZolo6f7Pj4+Smjlzn3E/T0xorARxD+prvNJFpupSXS+yc60Sm8V0dA+YLArmt2vi1BOc6j9Fq1DJcemTrEUYNYIh21VTqroPb8XSn/5xs2DDrpGCl52tevuLrRspelRa45bOOBndaUsHE6Z6POGR1Z+5t6EZh57Wuz6785lyLl6zZ/DZrEFkXOMsd6u1kRnGqKQ1M4PL/knsWFmJGK4QAqt8VnmkRAH67sMq28bTPRAO/s7Mk5njQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(36840700001)(46966006)(478600001)(33656002)(6666004)(83380400001)(107886003)(70586007)(26005)(7636003)(36860700001)(7696005)(86362001)(6916009)(336012)(70206006)(16526019)(2906002)(186003)(55016002)(82740400003)(5660300002)(4326008)(9686003)(82310400003)(47076005)(36906005)(356005)(426003)(8936002)(8676002)(54906003)(316002)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 07:45:44.8582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d07882d2-d686-4e77-3ff9-08d9259a6df6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:15:33AM +0800, Jason Wang wrote:
> This patch extends the vdpa_vq_state to support packed virtqueue
> state which is basically the device/driver ring wrap counters and the
> avail and used index. This will be used for the virito-vdpa support
> for the packed virtqueue and the future vhost/vhost-vdpa support for
> the packed virtqueue.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c   |  4 ++--
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |  8 ++++----
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |  4 ++--
>  drivers/vhost/vdpa.c              |  4 ++--
>  include/linux/vdpa.h              | 25 +++++++++++++++++++++++--
>  5 files changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index ab0ab5cf0f6e..5d3891b1ca28 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -264,7 +264,7 @@ static int ifcvf_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
>  {
>  	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>  
> -	state->avail_index = ifcvf_get_vq_state(vf, qid);
> +	state->split.avail_index = ifcvf_get_vq_state(vf, qid);
>  	return 0;
>  }
>  
> @@ -273,7 +273,7 @@ static int ifcvf_vdpa_set_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
>  {
>  	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>  
> -	return ifcvf_set_vq_state(vf, qid, state->avail_index);
> +	return ifcvf_set_vq_state(vf, qid, state->split.avail_index);
>  }
>  
>  static void ifcvf_vdpa_set_vq_cb(struct vdpa_device *vdpa_dev, u16 qid,
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 189e4385df40..e5505d760bca 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1427,8 +1427,8 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>  		return -EINVAL;
>  	}
>  
> -	mvq->used_idx = state->avail_index;
> -	mvq->avail_idx = state->avail_index;
> +	mvq->used_idx = state->split.avail_index;
> +	mvq->avail_idx = state->split.avail_index;
>  	return 0;
>  }
>  
> @@ -1449,7 +1449,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>  		 * Since both values should be identical, we take the value of
>  		 * used_idx which is reported correctly.
>  		 */
> -		state->avail_index = mvq->used_idx;
> +		state->split.avail_index = mvq->used_idx;
>  		return 0;
>  	}
>  
> @@ -1458,7 +1458,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>  		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
>  		return err;
>  	}
> -	state->avail_index = attr.used_index;
> +	state->split.avail_index = attr.used_index;
>  	return 0;
>  }
>  
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 98f793bc9376..14e024de5cbf 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -374,7 +374,7 @@ static int vdpasim_set_vq_state(struct vdpa_device *vdpa, u16 idx,
>  	struct vringh *vrh = &vq->vring;
>  
>  	spin_lock(&vdpasim->lock);
> -	vrh->last_avail_idx = state->avail_index;
> +	vrh->last_avail_idx = state->split.avail_index;
>  	spin_unlock(&vdpasim->lock);
>  
>  	return 0;
> @@ -387,7 +387,7 @@ static int vdpasim_get_vq_state(struct vdpa_device *vdpa, u16 idx,
>  	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
>  	struct vringh *vrh = &vq->vring;
>  
> -	state->avail_index = vrh->last_avail_idx;
> +	state->split.avail_index = vrh->last_avail_idx;
>  	return 0;
>  }
>  
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index fb41db3da611..210ab35a7ebf 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -383,7 +383,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  		if (r)
>  			return r;
>  
> -		vq->last_avail_idx = vq_state.avail_index;
> +		vq->last_avail_idx = vq_state.split.avail_index;
>  		break;
>  	}
>  
> @@ -401,7 +401,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  		break;
>  
>  	case VHOST_SET_VRING_BASE:
> -		vq_state.avail_index = vq->last_avail_idx;
> +		vq_state.split.avail_index = vq->last_avail_idx;
>  		if (ops->set_vq_state(vdpa, idx, &vq_state))
>  			r = -EINVAL;
>  		break;
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index f311d227aa1b..3357ac98878d 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -28,13 +28,34 @@ struct vdpa_notification_area {
>  };
>  
>  /**
> - * struct vdpa_vq_state - vDPA vq_state definition
> + * struct vdpa_vq_state_split - vDPA split virtqueue state
>   * @avail_index: available index
>   */
> -struct vdpa_vq_state {
> +struct vdpa_vq_state_split {
>  	u16	avail_index;
>  };
>  
> +/**
> + * struct vdpa_vq_state_packed - vDPA packed virtqueue state
> + * @last_avail_counter: last driver ring wrap counter observed by device
> + * @last_avail_idx: device available index
> + * @last_used_counter: device ring wrap counter
> + * @last_used_idx: used index
> + */
> +struct vdpa_vq_state_packed {
> +        u16	last_avail_counter:1;
> +        u16	last_avail_idx:15;
> +        u16	last_used_counter:1;
> +        u16	last_used_idx:15;
> +};
> +
> +struct vdpa_vq_state {
> +     union {
> +          struct vdpa_vq_state_split split;
> +          struct vdpa_vq_state_packed packed;
> +     };
> +};
> +
>  struct vdpa_mgmt_dev;
>  
>  /**
> -- 
> 2.25.1
> 
