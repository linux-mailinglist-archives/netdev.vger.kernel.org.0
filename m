Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F06239835A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhFBHo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:44:56 -0400
Received: from mail-mw2nam10on2049.outbound.protection.outlook.com ([40.107.94.49]:33553
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230348AbhFBHow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 03:44:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4PPomrXyTRHykXQKoP9sukor4fZC4XwywxtwQkdrB33iunTzgv3FriU/RSzvbQHTx+S2G4zw34TJL9llBQROr5D+UkhqYJNHZIPWxCJCRZbazjekpV+3+vlvIMIaRbDFkx9phrKwIoK07mo23XfTneuO4+t3pqphYx1QhpaD/+3nkmaNmqF1hzMOtu+y0wpLvJMAWJtHJ+0CRJEsGjQTis46MfBf/W9b4fHxVva8v3ze2WBcMLuZxvaIK87BZopkUUAVAUb3dRTK7a2jXGrKu8KrM5runWuVHnX7PQM8LFj4Cig6Zn/DaerJsJ3YfJ2YSYrh7oh8UZv0xAAszqBXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfsldBZNUgmsn/wKRUKfG57ue4JWD62tkyW8zyWV5tI=;
 b=hPESrmOFv6dlElLAO/d24PTYjZnSZIDOUDMMPvuXOWlAquX88X67t2AaRD8BDit9p4Xw/u0AeIy9tBbtIEutEKlHQpT1S2m68ynQ/Zc+v+H9cKxglZZ2eGIf0eCib6aLm2dl5ZzV8MOBXw1k0MotoM5zB74rdQPlVVtmQSQp70hXackQ3BSyfv9ADD9IIxrtKtEstfar1+xBZFlZ660lU3u6gXvuqK1/PVryQpDkpgI5i+8EQf20CJaiIXE8GYFUvDteJfXw6RW0KU9Rv3Ay7t/XEvqfsUpS9vGHu4mBiWRB6VPL8za2WuMSdMitCFtj+OGQ/pRmE3lSjHfah/zCQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfsldBZNUgmsn/wKRUKfG57ue4JWD62tkyW8zyWV5tI=;
 b=gs4hnUvvxVq9/P2Qr4Um7iRD5debhR+Bd59hKQ3SN4fVsOSzFp9Z44QO4Mtq5r2+DjdKNcH1R4jpxkIj3raDQBC8B0Fe3kyH3F5mLmH+A12tFCJXue8gRgiuvdzUOTujL4SqD4zuPqndnzpq0hGPou6BGAL6NjQa5FoXIdZLpMzSUV6xOMUFvU8q2pHmIWExc7fxSie1dy1AhurSqjTyquc4+GO1b0YoKHd2N1yqf0s7VN0g1ii7U4hf8OQEkke/kNBIlAvcXpa7Le7tY1L8KNLLGfkaSQ+IBJeNeFwZReD75S5mh12hGPV82fmKdHs8/TS9yyh/q5ggmeKVrl+vEw==
Received: from BN0PR04CA0016.namprd04.prod.outlook.com (2603:10b6:408:ee::21)
 by BYAPR12MB3112.namprd12.prod.outlook.com (2603:10b6:a03:ae::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Wed, 2 Jun
 2021 07:43:08 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::a0) by BN0PR04CA0016.outlook.office365.com
 (2603:10b6:408:ee::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Wed, 2 Jun 2021 07:43:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 07:43:08 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 07:43:04 +0000
Date:   Wed, 2 Jun 2021 10:43:00 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH V2 4/4] virtio/vdpa: clear the virtqueue state during
 probe
Message-ID: <20210602074300.GB12498@mtl-vdi-166.wap.labs.mlnx>
References: <20210602021043.39201-1-jasowang@redhat.com>
 <20210602021043.39201-5-jasowang@redhat.com>
 <20210602061723.GB8662@mtl-vdi-166.wap.labs.mlnx>
 <7ce52bd6-60b7-b733-9881-682cfba51ad8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ce52bd6-60b7-b733-9881-682cfba51ad8@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ccc604c-6553-4fa5-d42a-08d9259a10c7
X-MS-TrafficTypeDiagnostic: BYAPR12MB3112:
X-Microsoft-Antispam-PRVS: <BYAPR12MB311266D5A2A31F5B282806B3AB3D9@BYAPR12MB3112.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jm2CooIPpTlAS4DmqZxa4xta0jiQT00TSnoPTiX0n9fNuRm6kpzCLCtLhJX0XFbaZRDxT5yn2Un7NgkYprjANwCLfQKKrO+hORjcXxI9NY8viP4X/JvpoHiiiV5aCsVlI6+5GMAoove+ir9M0mU4tMRuQD+5Pq+dK52bHyaKpHjjIrU0kbqzbNQIqYNOYpry9kcICdLeoB0Ki5HIs3B1cmzXQW/mg3DUvYSMplayCqU3yEfllmgr/GFE/kfHETbJbzoJBL4/Z1fT9CrwFMUOY14RtxywmhMJNmBNAyiJftf68H72rm9OoK8CC4VEskvvcWlcyu2bPsrVfi0zhNeU1cuEmABL6ef8av0N6wPoohfRkIvSxlP8N6IUFdVQpp2TR8wpixZOe9G9dySOPraRyZRCoxZBW6UAuaz8ElyvhGPM7Tz5vEQQGkVMqzF5xqRHjHBLmYr/yk9Sjnpln3gleYs4nfBLfIUAqoy8Dn2xu5RuSLqtWfvFJIvFHQVPHxKVT9bqAY6G6fbh+Q6ftJprFmpu1GYNSNfNuhmQoTf8+l+vZsqT4NafCna5AX5ZD0tPt3T/cbYA9200ef/TIOlU05980mOuNKhVuz9L8epqHyn6u7P4bZDY+D+CnjapKl6lEPPUrRY9KEV5NlSMfJXQEQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(36840700001)(46966006)(316002)(8676002)(70586007)(8936002)(6916009)(54906003)(6666004)(70206006)(86362001)(47076005)(107886003)(7636003)(356005)(33656002)(16526019)(478600001)(9686003)(186003)(336012)(82310400003)(2906002)(5660300002)(426003)(36860700001)(55016002)(4326008)(82740400003)(26005)(7696005)(1076003)(83380400001)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 07:43:08.4089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ccc604c-6553-4fa5-d42a-08d9259a10c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:07:00PM +0800, Jason Wang wrote:
> 
> 在 2021/6/2 下午2:17, Eli Cohen 写道:
> > On Wed, Jun 02, 2021 at 10:10:43AM +0800, Jason Wang wrote:
> > > From: Eli Cohen <elic@nvidia.com>
> > > 
> > > Clear the available index as part of the initialization process to
> > > clear and values that might be left from previous usage of the device.
> > > For example, if the device was previously used by vhost_vdpa and now
> > > probed by vhost_vdpa, you want to start with indices.
> > > 
> > > Fixes: c043b4a8cf3b ("virtio: introduce a vDPA based transport")
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >   drivers/virtio/virtio_vdpa.c | 15 +++++++++++++++
> > >   1 file changed, 15 insertions(+)
> > > 
> > > diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> > > index e28acf482e0c..e1a141135992 100644
> > > --- a/drivers/virtio/virtio_vdpa.c
> > > +++ b/drivers/virtio/virtio_vdpa.c
> > > @@ -142,6 +142,8 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
> > >   	struct vdpa_callback cb;
> > >   	struct virtqueue *vq;
> > >   	u64 desc_addr, driver_addr, device_addr;
> > > +	/* Assume split virtqueue, switch to packed if necessary */
> > > +	struct vdpa_vq_state state = {0};
> > >   	unsigned long flags;
> > >   	u32 align, num;
> > >   	int err;
> > > @@ -191,6 +193,19 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
> > >   		goto err_vq;
> > >   	}
> > > +	/* reset virtqueue state index */
> > > +	if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
> > > +		struct vdpa_vq_state_packed *s = &state.packed;
> > > +
> > > +		s->last_avail_counter = 1;
> > > +		s->last_avail_idx = 0;
> > It's already 0
> > 
> > > +		s->last_used_counter = 1;
> > > +		s->last_used_idx = 0;
> > already 0
> 
> 
> Yes, but for completeness and make code easy to read, it's no harm to keep
> them I think.
> 

OK.

> Thanks
> 
> 
> > 
> > > +	}
> > > +	err = ops->set_vq_state(vdpa, index, &state);
> > > +	if (err)
> > > +		goto err_vq;
> > > +
> > >   	ops->set_vq_ready(vdpa, index, 1);
> > >   	vq->priv = info;
> > > -- 
> > > 2.25.1
> > > 
> 
