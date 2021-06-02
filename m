Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A382939836D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhFBHqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:46:36 -0400
Received: from mail-mw2nam12on2046.outbound.protection.outlook.com ([40.107.244.46]:13280
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232066AbhFBHqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 03:46:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsKR4RUv6nhsijzHQ2h3AQwtbQFeJjsIxWcmtwXscch7jQgjeHQYgOhulcruI/L0kt67tjmm/t9JZQcqc27CfdXz1Nfo9mSVF93jAI81d3nSS1fHLyeM+Qvwq/XW8Wfmi4tfdOOEU1JKsIqmX5hecRE20qsLUvmpyHgzjwWDIZzdIyJ9eCMlkHgIf3cxdECyrDou0DdJdmIYJBGEMRC75GdKjfEWGmGUa5zS+Xo+9o1D+wZQL4LohbKlCNiy0zDDXm4cPTgzGFiEU54CnxrypeVm0Astw/Q161U47kvIMvbHwNRD8k3UWSJzpccvGTGQ8BDLEJC/BYs6dGXAV8hcHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NM3UaMStDV8kUDjcJ+Cn9PDzBvRZ3jJsHxxw6ySSO1Q=;
 b=Bls1C71zD0mLEnGjCEAU876VoW2B6MWD8Q5GLNPc79eWeDgQcJeK6RXW2JjY6xTDkfvFSyM287bf5j9tZtiVeZvL3B37oXxjaxvzc2Rq8Y5fExcJ16YIjtrZpqeielbzwVOpKY1Rxud3okTWdrXFLtlPY8yCdzivUPQSDjscLb7/u41koGhhaCsbmr6LIU+S6fAZ67mZLwjeh9COBHBN/4JPPpMXItHzZiaVQPq+kjukXonqJ2f0XL/a4PDERvjrHkUCirSoNlB/G8BjEPqNamgSpviocSbx/ET5/3ZME4BikLfia9M0yvkc5tmu/HEZTgj3uCgkdUfiYojCJ82dvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NM3UaMStDV8kUDjcJ+Cn9PDzBvRZ3jJsHxxw6ySSO1Q=;
 b=WJtu9+Tg6vvtdFTeORZGjTBovgB7WwTmT42hecJWIilCobA99B2ZzIh+J+L/Y0STjMRPKh8DF4YrFfYpROsl+RoukjbK6tgl0cax5NkNlXooSqYrRE9CGOj92vftIBby6ImP4MbA+pf81wciZR9g9jim+0r9WFL0EZy6UwSdeZO2YRcMl0wIG2B95m5ZB166ft3rdkoBFm0yO+N9NhYCpe+wJbHIIeFpzqfj/Btu83WIqHlZ9t9ZdFn6z2Y64noq/Q5CMBn2a6OLrT3VoB7TuL2CSrAoHk1G+t9GIP1tevUHjnpF8LYdltvCjOzxoM13m/e7ZI6COUdKMzFMxl1T3A==
Received: from DM5PR16CA0040.namprd16.prod.outlook.com (2603:10b6:4:15::26) by
 SJ0PR12MB5440.namprd12.prod.outlook.com (2603:10b6:a03:3ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 07:44:51 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::e2) by DM5PR16CA0040.outlook.office365.com
 (2603:10b6:4:15::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 2 Jun 2021 07:44:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 07:44:51 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 07:44:47 +0000
Date:   Wed, 2 Jun 2021 10:44:42 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH V2 RESEND 1/4] vdpa: support packed virtqueue for
 set/get_vq_state()
Message-ID: <20210602074442.GD12498@mtl-vdi-166.wap.labs.mlnx>
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
X-MS-Office365-Filtering-Correlation-Id: 316cbcf3-d6af-4da5-8279-08d9259a4e0c
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5440:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5440C3153EC3E81434B8F262AB3D9@SJ0PR12MB5440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cd+oa3WGnf/iVVVVmFTD96zrczQH1/0lT1f6H80X5i5aFB8p8DG3P4T+BgxrXzuKtVwqbHvqkkYj2iiFD86pfjVnio2Df6OqVeP814nVnlC+NAq6y7GT9howezHovS1RiLpGAK/3vW+rO/82jFkjTbl9+7Kmts3yjP83An80H22Yhw6/PFkuwCpLMDM4ZQc18t6lYnVzeOtvCi0gAzKK1kHJyY4v47JpxQOpLDmHPlTa9Fz/d1ZSeK4+v2RpA+3hhUa3gygmyPGU1zwEdI7jjhL7wLa+ykBG1hPl7gMskhow0S4YQiP+wzYx6CwCss8b2XYUgiQESJRFrOBE9/adZe2hR5T0KSy89cqHEh5VWrVVHkFZ/tpwdkSuvl4cnmrbe6/BWS1hnmcbMm4rP4T5iGez8blc/tq1uLh2kO+5cCGNIAKHGRVjJVQ6PB15mMCju/Sg9wH2FcbvpBSaECuT3gPB0oVmDpX8Wivof1HLo+X3/i421krXOJSyuoXAbU3HYcIfzwMbhB3qd60ColyLaV8+LY7hMurmh2juNNm7srkBTtZ/EqNZwmNK3TNKHMGwrWx44lIgktoHWrEXAyNWLkhoKHpQF78Xjzg7fLA4RvmaMR92UUDdOcUPJGYfAX9uZaPIr6CwWKSKBBm23N2V4Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(46966006)(5660300002)(2906002)(26005)(55016002)(36906005)(356005)(70206006)(9686003)(16526019)(33656002)(186003)(8676002)(1076003)(336012)(70586007)(83380400001)(316002)(86362001)(7636003)(82740400003)(54906003)(426003)(47076005)(82310400003)(478600001)(7696005)(6666004)(6916009)(36860700001)(8936002)(107886003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 07:44:51.2740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 316cbcf3-d6af-4da5-8279-08d9259a4e0c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5440
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
