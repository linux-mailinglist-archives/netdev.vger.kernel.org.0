Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D64D398380
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhFBHs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:48:59 -0400
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:30848
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232180AbhFBHsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 03:48:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=da1GG4K+aPKUO0Avv6gevPhKxRgs5N8VZ0xtvgzUePOLmPEtpPkhS6fYmBgCdI25fEIoSOcX5LxlukDOM2ctJaS8I+JL46smmr0u6xQZLCNjujevxQmu5CxbTSjCb1InJ2vzzfH9ehD6VTcdBcO2a5vHNf+l2c5EVnf35AhMe5kO8Cxo3eCAaY/lbIddalZZf4ELhIcW1zDw1Cdu+EVMZliOE72GDGr4ihj08KIy/ZDXliYXIEpXcgso5HGlz6QxGXjlOD4ryY9kbcsPUn9dz0qQqRg6nNb4NdqGvdnptyqBThnZJR3hNS/qSOz4TpNMvLueinrc8jfoWhnAik6LFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgKthxxxMVSs1mBmJ3MWnQ2qJGAWYcEXwpmjkIU8yqI=;
 b=G7DL8c4N1zEnsT/gv3cJHObuUiaElmw71y+XzVjFVwVQEfthvehfPJLokMLUZriyO20nErNUuc1pXobAL8rnwWQ6wXDlK55MJMuMNiLtvpe3ayW1cCZwFNFeX8JK3jI+nn29oMDjJj84wXQxFdNet9VvysHvHRMV5cak2tHi35A7Pkz2GhXpg3tiTwUQEbV4DeGv7S5PL6AjvXUYu225006Jnwi98/7+7UQFeNWN3jbi6O7JT+ubUzbNl7Dw+tXw23AyRPJvdS4AeeEZgjFDQb0qgrnL8YkjJotZkf3qj0q0X0a/JDfsaKhSyTthWQ+7s+mXDSjiH7+6cFYQDfzVxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgKthxxxMVSs1mBmJ3MWnQ2qJGAWYcEXwpmjkIU8yqI=;
 b=d2iXk9yG3A4aja8wmODAtXPfSce1264Nw1ZhC62tjj1W/4kXg7bRSNNkqDbVq+6w+vO8Iq9usoz1MBZ035BaCF5ZClgWard+XicaH0VqPglTxDco75K6kIXiOp3/7RhwRH8LYZGlBoJeYxxjxZKN4YdrT4awrUS1v1cAzo5uySztbx9N/uivgWLECJRQczuI63X0BooEYWheDJxjMixHGHc3Gxi9f3J/cyZFMAUVcj2ctazG2ZHNymDWe6kYN0yB1h58EU+R+evCxq/1yZItMVKqcSJpzQvFAkT3VTHWNtVcU+btZwUTfU+PsucBwhFuQvT8pdAaAtoOPUakLF5H4A==
Received: from DM5PR04CA0059.namprd04.prod.outlook.com (2603:10b6:3:ef::21) by
 BYAPR12MB4600.namprd12.prod.outlook.com (2603:10b6:a03:112::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Wed, 2 Jun
 2021 07:47:10 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef::4) by DM5PR04CA0059.outlook.office365.com
 (2603:10b6:3:ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 07:47:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 07:47:09 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 07:47:06 +0000
Date:   Wed, 2 Jun 2021 10:47:02 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH V2 RESEND 4/4] virtio/vdpa: clear the virtqueue state
 during probe
Message-ID: <20210602074702.GH12498@mtl-vdi-166.wap.labs.mlnx>
References: <20210602021536.39525-1-jasowang@redhat.com>
 <20210602021536.39525-5-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210602021536.39525-5-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9d968f2-c47d-4fa3-9949-08d9259aa08d
X-MS-TrafficTypeDiagnostic: BYAPR12MB4600:
X-Microsoft-Antispam-PRVS: <BYAPR12MB4600163C6FD589C92765A6BEAB3D9@BYAPR12MB4600.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:196;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CKssnmxw3lI5HQ8+qGjUGFY60hynShb3WoMLeTRdsSF0E1bXbiI5Rr4iUJj36I8gFmWPbSOVpCDGPK01+olfLUrkDin+7iAaJ0i22zQGxrfVEzAiBexY5JwlTWxycAC16/zWH/Ou0Z6ioqSILOKvRT37Dfmx68mBlevmXSchIFFWxLsSOi1OHu9BByLcGH4IXeA3lstOo7FWeG4ZHAazAjypV66KKGXt1/0RTBfdJ//lFYE+9S/QNzj/E2Vc0B/axjjk5arZ48zhw8DgREalPNag6OOYOYR9UnJRWqPc1EahXUEPk4HM0b52ieZEuCBcWM5lsJFZIYzLWOmGfiKdhx5dwla36E0Ffs7BZ6fjRc176bVwDW+2/w0+W7fQhAtujUkmrsMfamM6O6I9spe9AEWkjSSyoURQv61hj9XTlgFUD5Q3HfVZveH2/dFGPtdnj+dkG7UMoTXKA1kvpa/n+/NItsXQH52M/dngwz/dwsbkBzEv02p1q1A1+wlAnnPxDllimS3YVwvCluWgvfpMAlvAYtoxK9LmI1ehVg9qqy5tH5K85YfINqaWa3aLeZmERVFPdPEd6ggz664AXAVTgLjyiLy6S8qpc6HR8CClJTbS2iEuK8oep4NgviTEhJ3CeMqAMbaPx3jMDnUfIvE1Qw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(46966006)(36840700001)(47076005)(2906002)(70586007)(8936002)(33656002)(70206006)(107886003)(478600001)(4326008)(5660300002)(16526019)(336012)(7696005)(316002)(426003)(26005)(36906005)(36860700001)(6916009)(55016002)(9686003)(54906003)(186003)(86362001)(6666004)(82310400003)(8676002)(7636003)(83380400001)(82740400003)(1076003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 07:47:09.7342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d968f2-c47d-4fa3-9949-08d9259aa08d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4600
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:15:36AM +0800, Jason Wang wrote:
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

Reviewed-by: Eli Cohen <elic@nvidia.com>
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
> +		s->last_used_counter = 1;
> +		s->last_used_idx = 0;
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
