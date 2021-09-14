Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2698A40A6A9
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240179AbhINGYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:24:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48766 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239908AbhINGYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:24:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DN5NlV009361;
        Mon, 13 Sep 2021 23:23:04 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b2380uuah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 23:23:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBq/bEOV518QbM2N+PnbZuTzvnjYCjicVrCSBqrCaWubt5o9xDAG91d/iAuVo3XaVhxUu9uLLXx3hQZlUiOYv3C8cEZFou7nksjtIaLNdU48sSIw92NIhVDaRazG2JEFso9pNoS7IHtZ4KyItQgxRgpxXMSiqziNt2BAF1fjkBNE3GSFiw1Vq1aMDVhvWiHHTbrY+8jqXSFKqMPRDUR6m17S8LWnPANv5g1U7TMu53UiiA9Om5Uz6V+O74aBfV+7gf3oRA8O51aiO1VWIx0pAwOX+jwcAEdcUeuM+2ZCaaLmHGHli1oo3hCPV/0oplLK9V0Oi4Xek1++2Gfbvv2ktg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=b03kM01ODuDSIEVuSf1sY+mem3jLq2Zhd4YHE0bT4BY=;
 b=fZRuxVEOSZjqgxEfBeVS6K0+IFsgHaoy3YeuKavFKFadp46K81ob+9RnUOwaBpps9EfWu3dJ3VoNYcTtjZGRpLpX0A7N2zI9rnqGmzyKw+GpC+WJ1YPLmDJNLKR4Jt48cPlrOXrj31n/elfA7G+DBMrDvt3XxQOC25lK0skkZvlb8fSXWbtNxYGFfEprqt3kmD2lYOH4jiG74qK3vwR1Ws/HRhXx3M6zJGhAqlqdPk5cf9Z+mdi1VAJ7wi66F1jMUkm5P5Anw9N6dw07b2iUFK7+cw60lBuqj4fWgQynpK08fVxes4ZZNVBxrVEpHk0XTln4DJZ7P81yu6sHJyN9mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b03kM01ODuDSIEVuSf1sY+mem3jLq2Zhd4YHE0bT4BY=;
 b=OQOZqTvm1coLpA4FpUfdZ62IzwodR/8QyeMdFqWDgz1O0rPf6pcZ8HQKupMb8G3hKublfsgzy/uT0pOqW9DMQHYQzvUOIjGDwWA4QKfffyOFuu7xzIyQNAgzf4dVSDzrpSM5vLUGbrcAuzGXu/NJdSlxI99LzDoPm6V/dydMI+Y=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2501.namprd18.prod.outlook.com (2603:10b6:a03:131::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 06:23:02 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::c38:a710:6617:82a5]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::c38:a710:6617:82a5%4]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 06:23:02 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Ariel Elior <aelior@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: Re: [PATCH net] qed: rdma - don't wait for resources under hw error
 recovery flow
Thread-Topic: [PATCH net] qed: rdma - don't wait for resources under hw error
 recovery flow
Thread-Index: AdepMH6krEZHu5kxSOKllNhVhRVcsg==
Date:   Tue, 14 Sep 2021 06:23:02 +0000
Message-ID: <SJ0PR18MB3882BDDFA81A7FD3A541C282CCDA9@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1054b52d-676c-47b0-e578-08d977481b01
x-ms-traffictypediagnostic: BYAPR18MB2501:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB250133097BB04CFD88D00450CCDA9@BYAPR18MB2501.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qFIgSCR1Y0ZN/78qpcdJ9nN2JrnvQyAJ67TRrdGXavfX2R/XEwmPuBPnlxLC7yH2go7bpuDvFYquZ1iX0dTtXMOU1mnjvYKUHGCroTO3EKB9PXOdFiVN9KzipcZ3YzpOJOcmZZfJKKlwMzm6cPNjgyr1wu0pSaFgmRQ81sitsKKnuSLeOYBzKhgrnjlvOlUYx8FytKew63yjcbBYWigj4IObOBgppE/XlgzphLikqLuwuLU7AlYUO8uP/Q5qQx7jOHsW89wFgXFrtYiHB73S33kc7JyDBKWC0r+AtyxE5/hFKapKkd/ETFf5SeS7hBp6dpDwrkDcdcp4VXyjgNHLae3pMpC1cyGNpsSDSFzJi8/MDDHA1hJygUmvR4ubDo+Lapin0zBNsDblJQQNLIj1z/Z9BXm/GajhSWibocj9bIakFcvTMGOjTl005eY0sYB9+u9Azjjy6ZNUd6EHBU05mCUsjSuKexUp1zIheoqsbAMrlQZekuz9hoj6tvS+PNn5s2UWp18BjxWeAxdDzIPxkJcZyK0rfV/nlGPHomueclGHAUV0UptkTbXFcOtrcYtl3IpXVtXuPMMmBEAoAIr4rSRd9evGQ2dNuAQDueR+OE1Ta0pIKZvrBRnHQNgoTi/ak1GH9aQfHcSKI0JC5DHd9QERcklpc3jeJ2xkuhmGV0p1p8c+l7ru9rbedNox67xhGO38xRZm857GEa0hEG9H/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2906002)(33656002)(71200400001)(8676002)(38070700005)(6506007)(86362001)(107886003)(55016002)(7696005)(6916009)(186003)(4326008)(54906003)(9686003)(66556008)(64756008)(83380400001)(76116006)(66446008)(316002)(122000001)(38100700002)(52536014)(478600001)(66946007)(66476007)(8936002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uIQI8F3p7xDaqf9xK9b+PJ+audAbVNjBQO01indp8X3Qsfe5ES/UY3V4R8el?=
 =?us-ascii?Q?haprvcKNjvC+zRrh7nkFKyuzyjPcfViZL1aOfaUdja/7ATR7VtK+FQmbyRf1?=
 =?us-ascii?Q?6C+blbBbB4+ymQlsBPFdU8LMKeeqtY6vCPTx05rFqMroKku4xNZyb82GSkdJ?=
 =?us-ascii?Q?4qEexGc+Ij+FrgpkkpqrNRkIfft854UziwUm7Q/pZxDqqZmZo63CGYG1q0Sd?=
 =?us-ascii?Q?LvpH7ZEgCX3MZoqWyyUrAzjPxq51r6604fLAVNK3FEKIJnt07iFRv16Bdh9S?=
 =?us-ascii?Q?dLonpXhoOky6ThQpQy5MTpdqBMk45YrSxJkvdmDBP91iNlu2Ukd02w4DAq0B?=
 =?us-ascii?Q?9l6SlQSR23Kv+6VAqARmCJZ+YsWiicbAE36eBslr4/lu5g1I3qDWesRNBAHU?=
 =?us-ascii?Q?zpa9vNn9dipn48WNZP1FXObxkVSJ1c7TDDAJjcY3X/t6pEeBvYvrGhTmQYat?=
 =?us-ascii?Q?Fk/bDK581a0m4mv4/05pspOdLYvA8Wg05dMTj4ZEdTQZQj+XYxY3WuEk0Lyo?=
 =?us-ascii?Q?rDRf8vaMt7pEz9gFhsDZO17YRV910Tqwh+zMnvW/NI1LW3lPx0XLyT8amZFr?=
 =?us-ascii?Q?0Rq9Zhv7pd38W2aTmOdPTTI/uL0IWCsm8+89bx1y365V8Xhc8Rb9it+AUYAS?=
 =?us-ascii?Q?it/rIWHirU5b8yM2vr1NC9wrXy6b/oj3gB/Wb7cVmXYHFyfbLD668gRcTov4?=
 =?us-ascii?Q?HpGfEghlG9Lw+T9yLSToo2h0LpqFuMq+Yh5TQ5Hb0GUU1LpzjWzqCsilLzV2?=
 =?us-ascii?Q?egCMhNUYgrf5qwTZkGojODLdvFr9RzC2qKQow+g7pbUmk7FIelrvWJQC4FW/?=
 =?us-ascii?Q?/lJaqX5zvh4cTitQvICQW39qsFBe4xrvgLGaeU7ObIqledeMRU1DkzD9Qztk?=
 =?us-ascii?Q?kIe34udb0cpNo14PLGkvT95oZS1VtyBqtl9+xPH7t09C+d0WEiKdO1fAMaqH?=
 =?us-ascii?Q?qAYNdMLEerFX8Ggi7Kssd7DbyWeSA2EGXrQ1T5dgCf0WRWOZyVszbFrGQS2m?=
 =?us-ascii?Q?QOHA/GwKsIOBfecuypFDcpwT/OxDsUEFWk8FQU2VypJnOgj1Fmqa8SYfRAlJ?=
 =?us-ascii?Q?4rxkfHZBnz2rOaST/srcWFnUZ0J5TQX6h4Gn2XpWacTFjv2Gxu3ovx+xiPTs?=
 =?us-ascii?Q?uA/ebb9rNawOQlxKYzLDmNpSyBrab7cvNjHerRqlaNGhOm87ELFVUqBjCWOk?=
 =?us-ascii?Q?z6GOakg+3P2La7b/Tg5Cejq18wfFHLXOc0lSa0cO/mB4gNXswNjJqkYD/iIU?=
 =?us-ascii?Q?UbRtswarbXzv7gBpUbVNN0Vu3WS/cT8L172RZwcqLbGAL9ejPOq8+qZ9qKor?=
 =?us-ascii?Q?VjNkVswh1Wm/mTekBL8RA0Kj0pL6N037JwgKSLtaFj243PzQvTW6hL7iWGx3?=
 =?us-ascii?Q?wUkqi90=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1054b52d-676c-47b0-e578-08d977481b01
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 06:23:02.2870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7VNt96Hnz+mxs9jajtnVi58nYRvW56ljUcZnOebyKoyVG4hGj0zhvm8ZsH4k4eX42Btv2Xbq3m2HdRNvPmVRYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2501
X-Proofpoint-ORIG-GUID: oNdLpI4JOv5z8suTKdX7bvkLMDBxHe0w
X-Proofpoint-GUID: oNdLpI4JOv5z8suTKdX7bvkLMDBxHe0w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_09,2021-09-09_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 5:45:00PM +0300, Leon Romanovsky wrote:
> On Mon, Sep 13, 2021 at 03:14:42PM +0300, Shai Malin wrote:
> > If the HW device is during recovery, the HW resources will never return=
,
> > hence we shouldn't wait for the CID (HW context ID) bitmaps to clear.
> > This fix speeds up the error recovery flow.
> >
> > Fixes: 64515dc899df ("qed: Add infrastructure for error detection and
> recovery")
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 7 +++++++
> >  drivers/net/ethernet/qlogic/qed/qed_roce.c  | 7 +++++++
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > index fc8b3e64f153..4967e383c31a 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > @@ -1323,6 +1323,13 @@ static int qed_iwarp_wait_for_all_cids(struct
> qed_hwfn *p_hwfn)
> >  	int rc;
> >  	int i;
> >
> > +	/* If the HW device is during recovery, all resources are immediately
> > +	 * reset without receiving a per-cid indication from HW. In this case
> > +	 * we don't expect the cid_map to be cleared.
> > +	 */
> > +	if (p_hwfn->cdev->recov_in_prog)
> > +		return 0;
>=20
> How do you ensure that this doesn't race with recovery flow?

The HW recovery will start with the management FW which will detect and rep=
ort
the problem to the driver and it also set "cdev->recov_in_prog =3D ture" fo=
r all=20
the devices on the same HW.
The qedr recovery flow is actually the qedr_remove flow but if=20
"cdev->recov_in_prog =3D true" it will "ignore" the FW/HW resources.
The changes introduced with this patch are part of this qedr remove flow.
The cdev->recov_in_prog will be set to false only as part of the following=
=20
probe and after the HW was re-initialized.

>=20
> > +
> >  	rc =3D qed_iwarp_wait_cid_map_cleared(p_hwfn,
> >  					    &p_hwfn->p_rdma_info-
> >tcp_cid_map);
> >  	if (rc)
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > index f16a157bb95a..aff5a2871b8f 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > @@ -71,6 +71,13 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
> >  	struct qed_bmap *rcid_map =3D &p_hwfn->p_rdma_info->real_cid_map;
> >  	int wait_count =3D 0;
> >
> > +	/* If the HW device is during recovery, all resources are immediately
> > +	 * reset without receiving a per-cid indication from HW. In this case
> > +	 * we don't expect the cid bitmap to be cleared.
> > +	 */
> > +	if (p_hwfn->cdev->recov_in_prog)
> > +		return;
> > +
> >  	/* when destroying a_RoCE QP the control is returned to the user afte=
r
> >  	 * the synchronous part. The asynchronous part may take a little long=
er.
> >  	 * We delay for a short while if an async destroy QP is still expecte=
d.
> > --
> > 2.22.0
> >
