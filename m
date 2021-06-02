Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F7F39834E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhFBHoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:44:00 -0400
Received: from mail-dm6nam10on2075.outbound.protection.outlook.com ([40.107.93.75]:1504
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229604AbhFBHn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 03:43:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f31WV9tswuRJNpjad9wgB6xxS4EiK/dFbPo7hM6DiY8KiutVF/6/6Y1fgSsl49ufR4zoAQuHyGYfHsNEH3CZexDDbhHxCJBmYw+yBOt2kTcv8brUr9b+pyIH4/tBnhuKtmKBBrBLeXuLXi/z9+10e8JoYoDYXXSHUbj/FPZn6DtJ5Y6vIYX+Em5DDnu2ahpGe4oZ2091SRok4t/3aDvOBLnn8UPAwmuRu88M0ZXM/oYWsd/LFLvIbjYzuWd6EOTw8rMAXgbjJkGcr5q1umwJwdERNfAkslrPxQzSzr2ctG0YN54gh/qrkgYNWCaRqiDkhHPc/bqTI21MSD55U1ZnZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZpVudIeSVRodlvGdffdv/xyhOiliWqDvZBSsQMjm8k=;
 b=Qm70sbS915AD7T1dWZkhZZZIk7WDBQlijBuGgzvKQx70DgwOu2oRUBRuEeCCpZOUwqsWNa01eF6tW6/ebwRwLUo68XjdPYKSsEZAmfo4sjYmSvxuERNu/yw2crRwOwmT58h3R63Mwzj0uLOvxcwv4RKORg7rWq9mr/GRaCC+814LvpYZ03LOdQArpetZsWX8iDED6nTRa1TVTFY/R5tKpFBEF7qqSHNTMvhTYN6ADu2soQrU5tfNaiFTRBa+xiGFzshnI1gCHGUeby+vfN8C+ofhDhrC8FZckFkYhz1Lp6EehUwZX24y9qFgCtR3ZHNz3gQzRD+CL+Ny0Uq/tIxH5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZpVudIeSVRodlvGdffdv/xyhOiliWqDvZBSsQMjm8k=;
 b=uSK9WORQgIP59FqXuyUFsFGRV85EACj2lXJlgSwl4IaazmGbiVx5zbtDiv+IAUwXpNb2oHTx+jGn3g/4W1lsr390juYZtK+HprHXBPk41T6wp0bHTiT0nLV5Y1qrSMALx6clJY7hOvyPWQ8H22t3rQEYBlAXAw+dFsCkwLpIE6mQ5qk9+YVTeFcSfbiObbERlb03WVP4TvtIH7HfZQocAZDgHCUtW+M/5w/0puXGiPuBqubgppvSAYq5/5piZNM5aiK94dBosjEk/WGRmmK4c+LEulSc3X1RCkInZxW7bp1NNsCQMvqPmTNulWYpaj2qUA2H5qAjFiuuDX3ERwDl/Q==
Received: from BN9PR03CA0023.namprd03.prod.outlook.com (2603:10b6:408:fa::28)
 by DM6PR12MB2748.namprd12.prod.outlook.com (2603:10b6:5:43::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.29; Wed, 2 Jun
 2021 07:42:13 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fa:cafe::64) by BN9PR03CA0023.outlook.office365.com
 (2603:10b6:408:fa::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend
 Transport; Wed, 2 Jun 2021 07:42:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 07:42:13 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 07:42:10 +0000
Date:   Wed, 2 Jun 2021 10:42:05 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH V2 3/4] vp_vdpa: allow set vq state to initial state
 after reset
Message-ID: <20210602074205.GA12498@mtl-vdi-166.wap.labs.mlnx>
References: <20210602021043.39201-1-jasowang@redhat.com>
 <20210602021043.39201-4-jasowang@redhat.com>
 <20210602061324.GA8662@mtl-vdi-166.wap.labs.mlnx>
 <091dc6d0-8754-7b2a-64ec-985ef9db6329@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <091dc6d0-8754-7b2a-64ec-985ef9db6329@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83b53868-fbb8-4693-bd75-08d92599efc3
X-MS-TrafficTypeDiagnostic: DM6PR12MB2748:
X-Microsoft-Antispam-PRVS: <DM6PR12MB27481BA7A55298EAC0E09479AB3D9@DM6PR12MB2748.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4RqsfLRZzjXCYN32etHJmeCfH2arhJv8UxpwIvNqnQlQ24Pi5VACkLb20EYhDZFqmtVkXIM57JOefORTH/AG8Pbn7AK/hpOqvbMrdLmQR08fzpej7xcpTgtDIPfw0yx2EUwxLFqfIUX+xM/YXsl591Lw5tWzIAEOVBjprv1zDbn0YNwnvmOjtupUX4AcR7Im9owGQMIi4O7vaBO5xbJ/AI3jxOulohQpYiLufJRmMFswCCvflNsKVfFYt+l8cbU1M/lCCBwiWUNPBmQvZgbF8rTC1qqvoY8gpPL3gmXxtfvmIu/MniJwP7L2jpQeNotocGljSH6Opw05LwR+eyAnQMxLM6pfLwqce/t7BUWJ0uJwlZbrWxBpgaZRUQC12y09o/2kLxUNwfPZypV5wllLndKcs5vkvTuQmKboDvv34xXMQ4zQ7zgR6PBdP43v3k2QVy35GIZgmhZABFzQ6sOPBMV8kgpJhSAjBqyhOVfXsC2v34/fsRccvtAwFLUAskDFwTqbb81/C29jNni5uZCDIWB7VmcPcbHZPG48CcvHb9zFikEgurhjx2j6w529qt96GNAy+1ZzeC3ghH4gxBECRu4OW+uXBhkOjmNMnqGZ4QUGohnM+E2au6bVitWbTSiFkqnVxbcYNQL8Q7+Kjv5MihODESooFtSY7RquXcO1vU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(36840700001)(46966006)(82310400003)(70206006)(8676002)(316002)(36906005)(86362001)(55016002)(36860700001)(6916009)(54906003)(8936002)(5660300002)(2906002)(426003)(83380400001)(1076003)(7636003)(336012)(82740400003)(16526019)(186003)(7696005)(26005)(107886003)(9686003)(70586007)(33656002)(47076005)(356005)(6666004)(478600001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 07:42:13.0643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b53868-fbb8-4693-bd75-08d92599efc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2748
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:05:35PM +0800, Jason Wang wrote:
> 
> 在 2021/6/2 下午2:13, Eli Cohen 写道:
> > On Wed, Jun 02, 2021 at 10:10:42AM +0800, Jason Wang wrote:
> > > We used to fail the set_vq_state() since it was not supported yet by
> > > the virtio spec. But if the bus tries to set the state which is equal
> > > to the device initial state after reset, we can let it go.
> > > 
> > > This is a must for virtio_vdpa() to set vq state during probe which is
> > > required for some vDPA parents.
> > > 
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >   drivers/vdpa/virtio_pci/vp_vdpa.c | 42 ++++++++++++++++++++++++++++---
> > >   1 file changed, 39 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
> > > index c76ebb531212..18bf4a422772 100644
> > > --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
> > > +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
> > > @@ -210,13 +210,49 @@ static int vp_vdpa_get_vq_state(struct vdpa_device *vdpa, u16 qid,
> > >   	return -EOPNOTSUPP;
> > >   }
> > > +static int vp_vdpa_set_vq_state_split(struct vdpa_device *vdpa,
> > > +				      const struct vdpa_vq_state *state)
> > > +{
> > > +	const struct vdpa_vq_state_split *split = &state->split;
> > > +
> > > +	if (split->avail_index == 0)
> > > +		return 0;
> > > +
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +
> > > +static int vp_vdpa_set_vq_state_packed(struct vdpa_device *vdpa,
> > > +				       const struct vdpa_vq_state *state)
> > > +{
> > > +	const struct vdpa_vq_state_packed *packed = &state->packed;
> > > +
> > > +	if (packed->last_avail_counter == 1 &&
> > Can you elaborate on the requirement on last_avail_counter and
> > last_used_counter?
> 
> 
> This is required by the virtio spec:
> 
> "
> 2.7.1 Driver and Device Ring Wrap Counters
> Each of the driver and the device are expected to maintain, internally, a
> single-bit ring wrap counter initialized to 1.
> "
> 
> For virtio-pci device, since there's no way to assign the value of those
> counters, the counters will be reset to 1 after reset, otherwise the driver
> can't work.

I see, thanks for the explanation.

> 
> Thanks
> 
> 
> > 
> > > +	    packed->last_avail_idx == 0 &&
> > > +	    packed->last_used_counter == 1 &&
> > > +	    packed->last_used_idx == 0)
> > > +		return 0;
> > > +
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +
> > >   static int vp_vdpa_set_vq_state(struct vdpa_device *vdpa, u16 qid,
> > >   				const struct vdpa_vq_state *state)
> > >   {
> > > -	/* Note that this is not supported by virtio specification, so
> > > -	 * we return -ENOPOTSUPP here. This means we can't support live
> > > -	 * migration, vhost device start/stop.
> > > +	struct virtio_pci_modern_device *mdev = vdpa_to_mdev(vdpa);
> > > +
> > > +	/* Note that this is not supported by virtio specification.
> > > +	 * But if the state is by chance equal to the device initial
> > > +	 * state, we can let it go.
> > >   	 */
> > > +	if ((vp_modern_get_status(mdev) & VIRTIO_CONFIG_S_FEATURES_OK) &&
> > > +	    !vp_modern_get_queue_enable(mdev, qid)) {
> > > +		if (vp_modern_get_driver_features(mdev) &
> > > +		    BIT_ULL(VIRTIO_F_RING_PACKED))
> > > +			return vp_vdpa_set_vq_state_packed(vdpa, state);
> > > +		else
> > > +			return vp_vdpa_set_vq_state_split(vdpa,	state);
> > > +	}
> > > +
> > >   	return -EOPNOTSUPP;
> > >   }
> > > -- 
> > > 2.25.1
> > > 
> 
