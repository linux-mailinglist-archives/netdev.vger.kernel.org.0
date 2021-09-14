Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F2540B345
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 17:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhINPmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 11:42:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23246 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233202AbhINPmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 11:42:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18EAZmXI025843;
        Tue, 14 Sep 2021 08:41:00 -0700
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b2t41h9sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:41:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/eRvbOFSaHEZeezKVhY95tVI4wgWlZZ8JsOcNYIY7MCP1oWVA5339qBKPEQdCMqkqNMhItijV9ET9GsoK+B/rAD2eSLXPccjMuSDMkr2AwnOurg7pgIoVThd6xz9XQKdbGMPgGI++XUqTaAxYBkIBMaUIvNwudFtEOTLQovpsimB1pOQyQBzE1Ffd/3FgBPQKaRPt01Owe/iPbSJ9e4wL7/z6nqd0uNlVBmjtA6vEPpPKF/ZEtpf/CWcGBxvbuojGsnWot6fGXJxlnaniRqfelmtB3P7t+E+QV5sxyJkcd5AmYBp6KCZZA4/xtHY60u9Xg5+sm/Qg59xsvabzjW3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=eFvHuYWW8KsQl+gI3t3Nwv57vjwffvdAOzV8jKYOzYM=;
 b=QBjfRczsX2gmST8FYspk0ri93IgEllUaYi3rbaYY+OPCrQ8He6xaNLl6IO1P2YphXzVlKJWsaKvCtCbQtwOJ6jhsTKbirygk2MMlX4fwOsHMobZ5PQk++S7tQfS5lQrTg8/pkBSXpEb9121NuqBtuLkaWF1ZZCs+Fhu+g6sAlCtbEMXmdBPlg9ZUNCPRv5ytKiw2+dlgB0MNo4DSvXDB6Hy52SAKMlJNC2PIP+bZv8AJt5R3Np+Wps/QC5gL7gCG4bPdFdj6ezRy7DBpAvDme7w4S1VpjII5Ekde2t+mW8PiNpMGKsMxTBlvT5OyaSBLfxVw/3vr0DMi/ht2/HiGfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFvHuYWW8KsQl+gI3t3Nwv57vjwffvdAOzV8jKYOzYM=;
 b=PZz1nxPQ8NHAB59VBMRg1xHFI0OC+r9DUOoW4V45J+TWfjnDKJSMZMiTBF6qVNDvD48e7hxF7t5kLPXhhfVxIiBgQDRB0exbspyw6igJJwxmpKWrtAy4i2XKkburJGiE1L/IxH5vs5sh3Su/xQHf0EdYFTj3LOaPxVu+iypLNmc=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2678.namprd18.prod.outlook.com (2603:10b6:a03:131::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 15:40:57 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::c38:a710:6617:82a5]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::c38:a710:6617:82a5%4]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 15:40:57 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Ariel Elior <aelior@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [PATCH net] qed: rdma - don't wait for resources under hw error
 recovery flow
Thread-Topic: [PATCH net] qed: rdma - don't wait for resources under hw error
 recovery flow
Thread-Index: AdepcpX69CJM/LiaQme1XG94z5mYGA==
Date:   Tue, 14 Sep 2021 15:40:57 +0000
Message-ID: <SJ0PR18MB3882E0E7B9E5C7FCEF5D6787CCDA9@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 395485ac-0f0b-432b-f748-08d977960bcc
x-ms-traffictypediagnostic: BYAPR18MB2678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2678552EBB58155C95333770CCDA9@BYAPR18MB2678.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iV7p5mFjcbqUMSvKUQyuPhSR8JrmC3JFe+NFopYssNoZrCsJnsB0nNrcJOqdtd0RCehKZ/ld62mNpGK89P4JLRsH/wlQnT4YQG+DWEVXRjw5OcQuWdGeE7g6JMhL4lyH6HUnbzISL2pZxEVxurDKA+H3yqtmZf4ycJQmkO7xyEu1KwE9csWVKhvjYJkWVSAncMlpTEZZoVYhUxQ8HGoBpr7ty4AC6s6tGGw51tov6D98MW47gg69zf+tHwe/1Dl5PyyfYZrNj/9ldEFErBiQ8gQCCtTKI9Y/ELgCD7SFS/6cxQvpu8DDgLrTOj5SeRU6LzgWYjUCRi0fzkM0LHEQldVASxPJ2pmjDScZUi0CYS46BaIA+qMe3HMgDFuIFqw4QBv9SGIA8sLeOSprFX5gl0FRICIy1NP7Hps84mzwBcQU945Y1aEevvN0FOQ7c1OE7SHjMTYoOVIIy7gEm6auCqzdAO/dwbJo05gnHIFj+KffoGyXxKQYHVmKv5sNFwk9NGd/9GKwlP0vJvt6wIsnqBRbplh3drzPuTp1UqyxtHUKKMXDllKKI//VHR8wq0rc1mPQqCkRgBWtxY7tcpyAN5ZgzWSZ92sflolCMKthFrNPz83cNAaYrBeOKneZoV7Eor9RTDtXNaa+GF5qMVZuR+KOvyUQRiKnrdQV8nrg/dV3AkTCAkN7D86FriY5UJoiY/aAp8IOo9VWGpN/t0n2BA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(9686003)(2906002)(38070700005)(316002)(83380400001)(86362001)(5660300002)(122000001)(186003)(8676002)(6506007)(33656002)(8936002)(71200400001)(107886003)(478600001)(38100700002)(54906003)(55016002)(64756008)(66556008)(6916009)(76116006)(4326008)(52536014)(7696005)(66946007)(66476007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fJq6PLc2c/ktEcK4NdAlQaO2y9IrruXRRmuKQBjN6fuPbXzntwjyzzln+Ewp?=
 =?us-ascii?Q?+RP9jbTUGyiAaOC/csGLksxlLIzqMc4d7V2FsJpwdlJu4uVs+10KDe8pNIpK?=
 =?us-ascii?Q?q0QXq9ZOYUXNgIvX+Rkl8O0dr4lt2SEyo2K1VpxR+PJl9YmtKtjHxiAM0Q0N?=
 =?us-ascii?Q?guhBn65gH+m4ImS2uh1G5yOV+P4EsJV+KQYf7fsiRyWtBIjle58GZ0XeSZli?=
 =?us-ascii?Q?5q+aPZ1Foto95o+friuPZqGvCvQIupfyb6gKz/YPMftU/2wDxcogU3aNa1Ft?=
 =?us-ascii?Q?m8rVSJgTsyBbBMaDKGrw8MEO8e1SIAGe6MYPAsaaxhd8jACKPp628nKZNzqL?=
 =?us-ascii?Q?WbrMPE5UrINDxOIYX3vSXxFbWCi6XtZWYKDabA0O4d5bpX3TYg9DwPVVLxrk?=
 =?us-ascii?Q?0WAH57bhRkQlMrQngL/e3Sbeu2zjGjQdZVJKepCdY7AWAed0dAMtzPqfgim8?=
 =?us-ascii?Q?ztsUVIkKeQAZIVMLKh/3VxG/KQuHTH5yTMgI6ZyiY1n7yz75524dZ+qWp6JV?=
 =?us-ascii?Q?pqCqk3hV2jghF/r4K2pauZfufuB5zw7Em3Zvg/c/cYxb+QeARJ59bjhU1vm8?=
 =?us-ascii?Q?9x3bwzBvg+gaM1OJQvW9ca2kItlgBb8raG20Luc+p3Q2ZWac/v5vhFbkt+yt?=
 =?us-ascii?Q?GY0bGG/iDLgZ8MpMo+rmo297GvMWI1HwFD7Z1irYrVI5dgu188wLtYAYjbPO?=
 =?us-ascii?Q?NfpWk6NHOiVTiJgs67LZ06aftiMXtkkZqgLFQgAe2Vodxq/uW0zlep+pIzC/?=
 =?us-ascii?Q?vJ6oscNCWH1Ry+5Ru2hVSyqoPPQqa/VnSfHhjr+hHdLmdRoaT2h9JEWMPIVJ?=
 =?us-ascii?Q?Qmipvoo3UxNa2Wd7IDWyQue51QQFHVdbZnSLCxsG4/yJDB6Xfabz4TW4Cbic?=
 =?us-ascii?Q?GQqwWW2V+nxo6ErXVn2t/olFGRYmlFGnFw4VRyk8wPPXDJvLY4v99LPFkDEM?=
 =?us-ascii?Q?FVfUxwjJPwXs8oNjLvfha5QwFzOBs21DLOhrkwQoY2GUVGkXnHRMNKrF/KZl?=
 =?us-ascii?Q?Y6m8TdHopKVi10y50e8lAKUqGuRBKNnDv0Nu8to/+tzqJsDqQXYJ2MUrw2f0?=
 =?us-ascii?Q?4MY2im0mkjaQycqJvTjilGycwUi9bApArS/NFg9PNCP4gRna7lfzlOsJ4Zc0?=
 =?us-ascii?Q?rWQaelCd3FTGtfz/N9wc/zj8x1lyfkS1lRWx4Zxgpmwq3gA7XlowDx2ntjVH?=
 =?us-ascii?Q?wK6c5CPQPcU8OaxVUO2zy4v7zTjmhjDk4SV44HWH3DNZ3nQyK2dus+X0gnyb?=
 =?us-ascii?Q?jGdtDS+i9vbQpLhGDDDfEaxWr3tREDEpXTWCn3G9zJT2sNGNwACm7fwWe0Cf?=
 =?us-ascii?Q?lrrDVFAYgT2bucEt/hjRxfnt0FmFqXQhysCGAYz0Y684GlZQkmRdWMue+7qg?=
 =?us-ascii?Q?fWOuEbY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 395485ac-0f0b-432b-f748-08d977960bcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 15:40:57.5919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RjRYJgsWV2eOXbH8OUADNI/KA2M7S81+CiEGGs7CAdk4paF/Ghh8Jn2uuthOFrMTi+HTx8bDTZe417MxNGujwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2678
X-Proofpoint-GUID: XNVczYal8t-1ATidWlRJZJzabCudgzbk
X-Proofpoint-ORIG-GUID: XNVczYal8t-1ATidWlRJZJzabCudgzbk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-14_06,2021-09-14_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, Sep 14, 2021 at 1:01PM +0300, Leon Romanovsky wrote:
> On Tue, Sep 14, 2021 at 06:23:02AM +0000, Shai Malin wrote:
> > On Mon, Sep 13, 2021 at 5:45:00PM +0300, Leon Romanovsky wrote:
> > > On Mon, Sep 13, 2021 at 03:14:42PM +0300, Shai Malin wrote:
> > > > If the HW device is during recovery, the HW resources will never re=
turn,
> > > > hence we shouldn't wait for the CID (HW context ID) bitmaps to clea=
r.
> > > > This fix speeds up the error recovery flow.
> > > >
> > > > Fixes: 64515dc899df ("qed: Add infrastructure for error detection a=
nd
> > > recovery")
> > > > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > > > ---
> > > >  drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 7 +++++++
> > > >  drivers/net/ethernet/qlogic/qed/qed_roce.c  | 7 +++++++
> > > >  2 files changed, 14 insertions(+)
> > > >
> > > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > > b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > > > index fc8b3e64f153..4967e383c31a 100644
> > > > --- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > > > +++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > > > @@ -1323,6 +1323,13 @@ static int qed_iwarp_wait_for_all_cids(struc=
t
> > > qed_hwfn *p_hwfn)
> > > >  	int rc;
> > > >  	int i;
> > > >
> > > > +	/* If the HW device is during recovery, all resources are immedia=
tely
> > > > +	 * reset without receiving a per-cid indication from HW. In this =
case
> > > > +	 * we don't expect the cid_map to be cleared.
> > > > +	 */
> > > > +	if (p_hwfn->cdev->recov_in_prog)
> > > > +		return 0;
> > >
> > > How do you ensure that this doesn't race with recovery flow?
> >
> > The HW recovery will start with the management FW which will detect and
> report
> > the problem to the driver and it also set "cdev->recov_in_prog =3D ture=
" for all
> > the devices on the same HW.
> > The qedr recovery flow is actually the qedr_remove flow but if
> > "cdev->recov_in_prog =3D true" it will "ignore" the FW/HW resources.
> > The changes introduced with this patch are part of this qedr remove flo=
w.
> > The cdev->recov_in_prog will be set to false only as part of the follow=
ing
> > probe and after the HW was re-initialized.
>=20
> I asked how do you make sure that recov_in_prog is not changing to be
> "true" right after your "if ..." check?
>=20
> Thanks

Thanks Leon - it's a valid point. Moving the "if..." to the while loop=20
for both RoCE and iWARP will solve it.
I will fix it with V2.

>=20
> >
> > >
> > > > +
> > > >  	rc =3D qed_iwarp_wait_cid_map_cleared(p_hwfn,
> > > >  					    &p_hwfn->p_rdma_info-
> > > >tcp_cid_map);
> > > >  	if (rc)
> > > > diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > > b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > > > index f16a157bb95a..aff5a2871b8f 100644
> > > > --- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > > > +++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > > > @@ -71,6 +71,13 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
> > > >  	struct qed_bmap *rcid_map =3D &p_hwfn->p_rdma_info->real_cid_map;
> > > >  	int wait_count =3D 0;
> > > >
> > > > +	/* If the HW device is during recovery, all resources are immedia=
tely
> > > > +	 * reset without receiving a per-cid indication from HW. In this =
case
> > > > +	 * we don't expect the cid bitmap to be cleared.
> > > > +	 */
> > > > +	if (p_hwfn->cdev->recov_in_prog)
> > > > +		return;
> > > > +
> > > >  	/* when destroying a_RoCE QP the control is returned to the user =
after
> > > >  	 * the synchronous part. The asynchronous part may take a little =
longer.
> > > >  	 * We delay for a short while if an async destroy QP is still exp=
ected.
> > > > --
> > > > 2.22.0
> > > >
