Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AD63971C8
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 12:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhFAKtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 06:49:03 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:41285
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230282AbhFAKtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 06:49:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i24u+QHqoffX7/8Kkn+Hw3jORN8jG+2lpNMYNopbUmCcwWuaN16ljm2ZUAA5leoKtRAIWy4LSrj4XhNrfEV2uFJ4lcYD7cFnLtIPWX7elV8YAFZ9Z64nwbaJWmA+QT57pIfXm5vB7NkaNsi6SkXDqb5gN0T8LSKelJGSVBlmP3PebuR4taMdbRTYYNcQnjsoh0rFJn3pY+awsIf31Gh/pOvZMnAWC/wmM3NCNu5yU/UUIvdproXKk9c3AWb88olWyENxULAXTUUWhH3gJmCrqXRaz1q0ArMI7n4ASenficSta1B9WN0m4YzDvVCWkWTuK79npu/3tyQcXJRY/ctWEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gnGBo4uzDQfbQzSZ871xLCcXdNgcuR04h5bvDpQns0=;
 b=KLADeGbiaN50/zEjqTTL65+Aba1M2nCKCLRivAWKxvStX0s18gQb/5J3ZyOTj7mYwYfCQJeHtJVPVHPI43kJmo2Sacw1icRSjEQnDdAPyp+mGaCASSLukwfvi9LgHJwg6SasB1BfzCognf8GNkK5xS9Xhj3JhG/SuR56NGnZTyZ9VohE1yH58+m1UJ8Dg3EzggirZg4iZ4axK4wcQVqnmNPN1+0kzQeg3KFhnSuF20x9nrvrUmfO3qSuBkWaU4CoWXJeaJ3afKcpjKvtvaRFFhPD8Q5jLLvMBWasR79nzk10Eew+4zXmGB7UOAeY18eLWOMnNQOYEZ8Eel8TY7d1qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gnGBo4uzDQfbQzSZ871xLCcXdNgcuR04h5bvDpQns0=;
 b=l4prqc+6H5aPlY+aeU3BEqlAawuchXZWdJIQcxd1CevxdAIKklYsUEazFsY3oGc1K7D2XvnXgbVDeaPQrRRb26FDf1OaEkKKK8nUXVrnSIThnVcce9SzXdPAWRrTHrPqVUbeRM0yg46sZpN5XIH50Z1vWaT+ynSuTxqO5Xx4SnhG/p7zW7IolI2ieE93pmLv4NNIbqW/CAJEguERKHoFjNLbVyxhIKPT+UkKiM+LoFp7ucM9jVq89hIKHfYkB3cUfi5iq7RmMiFdtMyKiY6h6vZPZzd1pPx2/PJkV9/QRcaxmBNqH7lWlExY5c1Bb2Zqkw9c6bBADiNFn9CueDqSRw==
Received: from MW3PR05CA0027.namprd05.prod.outlook.com (2603:10b6:303:2b::32)
 by MW2PR12MB2587.namprd12.prod.outlook.com (2603:10b6:907:f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 10:47:17 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::fa) by MW3PR05CA0027.outlook.office365.com
 (2603:10b6:303:2b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11 via Frontend
 Transport; Tue, 1 Jun 2021 10:47:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Tue, 1 Jun 2021 10:47:17 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 1 Jun 2021 10:47:15 +0000
Date:   Tue, 1 Jun 2021 13:47:11 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH 1/4] vdpa: support packed virtqueue for set/get_vq_state()
Message-ID: <20210601104711.GD215954@mtl-vdi-166.wap.labs.mlnx>
References: <20210601084503.34724-1-jasowang@redhat.com>
 <20210601084503.34724-2-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210601084503.34724-2-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 479e2f5a-ebf7-447b-68d6-08d924eaa02d
X-MS-TrafficTypeDiagnostic: MW2PR12MB2587:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2587BAC8CB5C624746000AE4AB3E9@MW2PR12MB2587.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJRJGUx6uQdlLWR753httJ89B7ioDFUDNSLP/4qYqgL6pb1Js0QxDi7VxL5Vq/lesoe9FQnuX6roThYoNDH44hFxrvhFHd16K0fXda16NgwwYqjirUT480ZUGcxJc2ljadI/JY19qurg5pQ3Vbcasi1PmzHgNAYQrvafQNNQU9wPJkOJDpY3aNM5lpNVAO2OGf9cdC5XkVPmDgnKte+D8FhxUMHSO06f32UnW16A/8FtmHiNN2EQTIvJePoDB4jiY7A4GHBY0qfQwP+6eM9zFkwGl/hRCIKIbpNt5V1dKtpO/S2DWYleAbczQ2wtJwV1yP+tKg4FhnlSSri1b5jbMjANUHjiehiq3/QiwOgyIJ2QaCABwauR81SfLxIWuNqmE2KMAAMBblA9twRxMESBZUcdKFBrich/hBZCgdV/NFTrAgXQtr3lhLQWg2JSHGtJeBjiCf+ZermfXt3ttegLMO5n7IaymAdE+rvaRsm3t/iE5gWqxR6gOcfSieMuPwXpCPDGM+oCy7gtrAexliXJ2HWjHay5Udd17jJ7B+upNKGBUO2qModbbk8HEG1HMYZVZxI4pBas35oE58b3AT/Epa9w5P4R2ZCxZs1z/7K2PuxTbuf0LVfah6+Mo6hGtDxJpJ8Lqts2iUKgVuen59hJvrGzZ8G3ABXRYzMZck96uBc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(36840700001)(46966006)(7696005)(316002)(54906003)(36906005)(36860700001)(33656002)(2906002)(55016002)(6666004)(47076005)(26005)(478600001)(7636003)(9686003)(107886003)(6916009)(8676002)(8936002)(4326008)(82740400003)(86362001)(336012)(186003)(16526019)(426003)(83380400001)(5660300002)(82310400003)(70586007)(356005)(1076003)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 10:47:17.6864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 479e2f5a-ebf7-447b-68d6-08d924eaa02d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2587
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 04:45:00PM +0800, Jason Wang wrote:
> This patch extends the vdpa_vq_state to support packed virtqueue
> state which is basically the device/driver ring wrap counters and the
> avail and used index. This will be used for the virito-vdpa support
> for the packed virtqueue and the future vhost/vhost-vdpa support for
> the packed virtqueue.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

You changed interface but did not modify mlx5. Does this compile on your
system?

> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c  |  4 ++--
>  drivers/vdpa/vdpa_sim/vdpa_sim.c |  4 ++--
>  drivers/vhost/vdpa.c             |  4 ++--
>  include/linux/vdpa.h             | 25 +++++++++++++++++++++++--
>  4 files changed, 29 insertions(+), 8 deletions(-)
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
