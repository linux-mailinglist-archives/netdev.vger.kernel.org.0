Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A79629AC87
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751567AbgJ0Mwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:52:46 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11356 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439253AbgJ0Mwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:52:45 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9818070000>; Tue, 27 Oct 2020 05:52:24 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 27 Oct
 2020 12:52:31 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 27 Oct 2020 12:52:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fH6znLiLtAIrPRi0aQYXb4P1ZpPULgtVmpVsPKUBhfxuxEYiJOj/myp9a6Br88eOMCtzcQ6afwRm/5eeqmTfSd22N8tvO+qbuLv1TbN6EstjxcKLxKTdU4Y4Cfx0zFjEmKpUnlRiuYmSouO27LPvdilN2mQFSSHNhaenA33lAlR2DTLhG7ksRIeg8LmxRxc5GB8qUvsBuNbOQH9bUK/8lS1Zv8OsWFSaoW4pRsntwQFvypCSZ1oGZanCF+gfCn0ezI1FnG+p0Va21tOJkpqGt3czc/pNMVAuUeisMJ4Jy2TN3jNzzj7hGbA5eJrdvG2SejW7Uat77MseZB+1COkSXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVM0n0cEFEDTz3oXadiW4+5zeyt+CYPjh8AT0a0SoDo=;
 b=Y7du4kXTdlGqTdQxhQzsHzgoRdiaWTMiSwvhDPzTSgoO/pp/zNf+pMdCv9nCvqsz2Niyy04yKuv69uxqMCm3oCygzTt/CIWzYEg00JYIs/UrbrCgegvG6wochh6+1S+CW5GQAJFZ2S/oJizMVRT2NmH5mhxI3TBAWhTv9WcnwE/qRTl1ps/PPeFEuYrFbaPbefgBOc+mAEgmMfgXakmsmJbWyTMYgo9eXap387QT0B0xbVOupGfTvs4aLbKtWG2PBF6ywDhqosQNpBIeKnoqBxWhbZuQy61KqIRaM4CTvOE0322e/g6YiuWoD89LC2ie239mCGBtDvaBqa1jts6pIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2933.namprd12.prod.outlook.com (2603:10b6:a03:138::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 27 Oct
 2020 12:52:30 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 12:52:30 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linaro-mm-sig-owner@lists.linaro.org" 
        <linaro-mm-sig-owner@lists.linaro.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: WARNING in dma_map_page_attrs
Thread-Topic: WARNING in dma_map_page_attrs
Thread-Index: AQHWqbLPPEPI9mnwmUSeVEeL/Zim3qmnD9kAgAJKk0CAAcOagIAATcGA
Date:   Tue, 27 Oct 2020 12:52:30 +0000
Message-ID: <BY5PR12MB43221380BB0259FF0693BB0CDC160@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <000000000000335adc05b23300f6@google.com>
 <000000000000a0f8a305b261fe4a@google.com>
 <20201024111516.59abc9ec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <BY5PR12MB4322CC03CE0D34B83269676ADC190@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201027081103.GA22877@lst.de>
In-Reply-To: <20201027081103.GA22877@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.200.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6326d4db-810e-41f0-fdce-08d87a772a45
x-ms-traffictypediagnostic: BYAPR12MB2933:
x-microsoft-antispam-prvs: <BYAPR12MB29335F7AF6099F9C9EFB4960DC160@BYAPR12MB2933.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i65ek6GWej7LGpI07kd+40ng867ItDdKk1syXgBWEtzZNoHwMNwoaItXuiKSdlJzdukL6aBS9mWSLD6FFISaUnHFzeRZBbO1xroQANLcbVUQbwnTsN8C0zdyEfQsgSFjl809sVg6X9QYwPUTQb1H8pHdhV5z2uD7iWG6YWdvBcPeRXYK2JZKb+LB+DRYUmAN5u3376cA1vMTg/Da06U9kjERgkJxaEB18P8ZCsS2A2wieTurwLsV4xu55HW0RAVTry7jBIbNQbLmZqX2ouA9AeHDtxOARhN6lxdYYm/Mwl3ysoJPn+A/hdbbhE03geC+qeCFhEhfut2FtiMGjJx7nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(55016002)(66946007)(9686003)(6916009)(4326008)(478600001)(33656002)(83380400001)(26005)(86362001)(316002)(52536014)(5660300002)(66446008)(66476007)(186003)(55236004)(54906003)(66556008)(8676002)(71200400001)(7116003)(2906002)(64756008)(53546011)(7696005)(7416002)(6506007)(8936002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: v+l9GLGUKDGh3cKbTwJNergT08hkoCIoTB49GIH8c9JrX2tahYFTm3FI/44s6oha0HOojbx4OnIff4+rr3AU3OFJ5xCyvBGx5FGXcmWX5r3u6Js80cL6uVerZRXTaeZ3lxMs7vZ1DTlW74FMXJF17dpT5c4gNvTr9eUEPEJTt4qb7M2tW7VRaLtcDR008Yx2MRf2IABNAST5uWjAW7QUtNpe+y82Gr5IXQYOyJABXoSbcfD8W1kOz/wnqmYQdUnge4L2xMYJtd3njaUwUNIb5/nprWTijc07cj1e2cAH7onpxN3DIGq4KABT0gZU6cKHLCemeRdbNIZlK9zup/WguxBPjCROByyCANIVoRaO97ioXH+Zus0uSCV5xPg84hmAO/z8tlzMYKRrdyayGOUhmW3KSQkh253pdCxWmsAwCNosL5OKEF5k8rcOkdq8asS+DI+hUXXcPEACx2Ji2kd93igOV3Ldm/31MgpdN1xp9LauU94T6Ft2VcC6H4S5436VKgzy8US0MUWsjWkGGtXSZD81hWrEYN+kiQVQZ8lGtkcA2giRmvbTgIK0ZdYTfuHX1mFrLpbhGTeD6eLhwDnYs9+itFpuMjXn2u4sCQh0+LE/6l7KEEeYdSMGHa2YaY6PampoJQpZChWrQh/AaIDC4g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6326d4db-810e-41f0-fdce-08d87a772a45
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 12:52:30.1045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yUUrRIBw8/EVGdF5ooDvsd3UZ/Zcs9NLOW9M7OGOX3PpLweKePxirbq7iE6iDVoaQVP/a1NhXbZpIoDR6KhiQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2933
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603803144; bh=eVM0n0cEFEDTz3oXadiW4+5zeyt+CYPjh8AT0a0SoDo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=AlFfJHwlIhESIno9ZWxWX/lcM1ERiNjggMifDpg8xnLpLnruKppRCRuq846vUFHBs
         ra5bwNNaUWNpD9m9G0OyLXkZpXoyk8/88hLPqVeWl4ZP7w2KrqRHPL+jryYuclsuON
         XmuS69g4dTOqK7W33sIKEIpoqK8Yst0WVUTmMRIAjswVCgswfLLXivkVy1KqadJkCM
         4HkcgJASUAkl23sfT43C/r+u9e7BDb9Danj79aKFROpCaBopGDczWDvu4EKFB8fbhz
         lS5XnnZYNFJo0MnYGjj0+MvbH6AmOjnq4x8XptCIKjwt3tOyW4RV8gtTN4gDQMaFc2
         pJjFFzFK+vClg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: hch@lst.de <hch@lst.de>
> Sent: Tuesday, October 27, 2020 1:41 PM
>=20
> On Mon, Oct 26, 2020 at 05:23:48AM +0000, Parav Pandit wrote:
> > Hi Christoph,
> >
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Saturday, October 24, 2020 11:45 PM
> > >
> > > CC: rdma, looks like rdma from the stack trace
> > >
> > > On Fri, 23 Oct 2020 20:07:17 -0700 syzbot wrote:
> > > > syzbot has found a reproducer for the following issue on:
> > > >
> > > > HEAD commit:    3cb12d27 Merge tag 'net-5.10-rc1' of
> git://git.kernel.org/..
> >
> > In [1] you mentioned that dma_mask should not be set for dma_virt_ops.
> > So patch [2] removed it.
> >
> > But check to validate the dma mask for all dma_ops was added in [3].
> >
> > What is the right way? Did I misunderstood your comment about
> dma_mask in [1]?
>=20
> No, I did not say we don't need the mask.  I said copying over the variou=
s
> dma-related fields from the parent is bogus.
>=20
> I think rxe (and ther other drivers/infiniband/sw drivers) need a simple
> dma_coerce_mask_and_coherent and nothing else.

I see. Does below fix make sense?
Is DMA_MASK_NONE correct?

From cfad78c35788b4ff604abedd96559500c5fd2a72 Mon Sep 17 00:00:00 2001
From: Parav Pandit <parav@nvidia.com>
Date: Tue, 27 Oct 2020 14:20:07 +0200
Subject: [PATCH] RDMA: Fix software RDMA drivers for dma mapping error

A cited commit in fixes tag avoided setting dma_mask of the ib_device.
Commit [1] made dma_mask as mandetory field to be setup even for
dma_virt_ops based dma devices.

Fix it by setting empty DMA MASK for software based RDMA devices.

[1] commit: f959dcd6ddfd2 ("dma-direct: Fix potential NULL pointer derefere=
nce")

Reported-by: syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com
Fixes: e0477b34d9d1 ("RDMA: Explicitly pass in the dma_device to ib_registe=
r_device")
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 drivers/infiniband/sw/rdmavt/vt.c     | 5 +++--
 drivers/infiniband/sw/rxe/rxe_verbs.c | 4 +++-
 drivers/infiniband/sw/siw/siw_main.c  | 5 +++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdma=
vt/vt.c
index 52218684ad4a..1b456f4d4fcf 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -580,8 +580,9 @@ int rvt_register_device(struct rvt_dev_info *rdi)
=20
 	/* DMA Operations */
 	rdi->ibdev.dev.dma_parms =3D rdi->ibdev.dev.parent->dma_parms;
-	dma_set_coherent_mask(&rdi->ibdev.dev,
-			      rdi->ibdev.dev.parent->coherent_dma_mask);
+	ret =3D dma_coerce_mask_and_coherent(&rdi->ibdev.dev, DMA_MASK_NONE);
+	if (ret)
+		goto bail_wss;
=20
 	/* Protection Domain */
 	spin_lock_init(&rdi->n_pds_lock);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/=
rxe/rxe_verbs.c
index 1fc022362fbe..357787688293 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1130,7 +1130,9 @@ int rxe_register_device(struct rxe_dev *rxe, const ch=
ar *ibdev_name)
 			    rxe->ndev->dev_addr);
 	dev->dev.dma_parms =3D &rxe->dma_parms;
 	dma_set_max_seg_size(&dev->dev, UINT_MAX);
-	dma_set_coherent_mask(&dev->dev, dma_get_required_mask(&dev->dev));
+	err =3D dma_coerce_mask_and_coherent(&dev->dev, DMA_MASK_NONE);
+	if (err)
+		return err;
=20
 	dev->uverbs_cmd_mask =3D BIT_ULL(IB_USER_VERBS_CMD_GET_CONTEXT)
 	    | BIT_ULL(IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)
diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/s=
iw/siw_main.c
index ca8bc7296867..d3dc50a42dab 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -384,8 +384,9 @@ static struct siw_device *siw_device_create(struct net_=
device *netdev)
 	base_dev->dev.parent =3D parent;
 	base_dev->dev.dma_parms =3D &sdev->dma_parms;
 	dma_set_max_seg_size(&base_dev->dev, UINT_MAX);
-	dma_set_coherent_mask(&base_dev->dev,
-			      dma_get_required_mask(&base_dev->dev));
+	if (dma_coerce_mask_and_coherent(&base_dev->dev, DMA_MASK_NONE))
+		goto error;
+
 	base_dev->num_comp_vectors =3D num_possible_cpus();
=20
 	xa_init_flags(&sdev->qp_xa, XA_FLAGS_ALLOC1);
--=20
2.26.2

