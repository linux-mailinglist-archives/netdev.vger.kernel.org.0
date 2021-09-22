Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4149414708
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhIVK5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:57:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235009AbhIVK44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 06:56:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M6IKhS013527;
        Wed, 22 Sep 2021 03:55:23 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b7q5dje0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:55:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KP87Aj9PPbmHL0rJHIqbO6ipHXL1bchstHZS9HRkRH6/t33QymjajJoJOTyzLEZcLQvsGw8DOHeG2OanqtaPAQSuM4XLYdZt8v4iq2UA8+ouvU0maToxzN7i6CIM5wPmQs+0MCK4HgszvChW0Ri2/Yu5pAnBTApoLNC6VE7fSDlMNfI3NtCgQSaChOO1bfTT+PHUoTigmggzWlIlY7pYNSaNep1xfJsIrYAmS1yccWTROyJtqPIbIvN6d+7FjOa9pFiLnlxxe+8bjFFBSmvMjtTZarZEATnw4vzs9R+QlyJlr8Dfu0XCuaqa+cRhtQxPq6LidBiyQPjsDVAkIBWopA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/Cjkx8wAHCX3vVOaCBKLh1bA1D6pnK1uLZIhPkuVMF4=;
 b=E4i8zeJLygtiuVrGsBRxwT40rPk4CSUgao/uxRwRWPTf2pIvCOgq1YkrJYNXiIY4XHTLfVt+qjEP1v2moCWs+HlGbuy0cCWpxp7D2lJuFOVgM8+7DJTuR0t2zLgQ+iS5l9Mkpu3D3HAtIZmFogyc+V3E53cEvsOd/ZmZtSPCmo3j1eWiz2u/gslzvZ2bBrtSuWS0ECItTyiyXFeOVSyEi8vwt+qthqk2dHKzV2lw9o24njyzOVzTGFMjnb9mgOFM69M1uTd/ZtABv/QyAi78uZsEaHPJsBeOkXUaALZUItuidvUFxIIf57OLEsNtQRz1eJPVbkVI7FG7dh4mA9UyuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Cjkx8wAHCX3vVOaCBKLh1bA1D6pnK1uLZIhPkuVMF4=;
 b=CGEdNzqXTRmBzlkxW9Rf1WcJDOvjtCSG6q//T+DTBulvHdRYPBUoMZ1TMVJcQkkA850kW/Q2S1OEAwmH/4XW5oaj1JP5p/fwptQs5LAHyHxU3JYxXehNR2EPVW/gWnp6FxnlcrtIVh63iBj3HGI9Z3Jx+LCeIEGtcyFm88rXnVI=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by SJ0PR18MB4010.namprd18.prod.outlook.com (2603:10b6:a03:2ea::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 10:55:22 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::fddb:40f4:506d:f608]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::fddb:40f4:506d:f608%9]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 10:55:22 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Ariel Elior <aelior@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [PATCH net v2] qed: rdma - don't wait for resources under hw
 error recovery flow
Thread-Topic: [PATCH net v2] qed: rdma - don't wait for resources under hw
 error recovery flow
Thread-Index: AdevoEzeEO9No2e7Rb6QRw9VKTnEMQ==
Date:   Wed, 22 Sep 2021 10:55:21 +0000
Message-ID: <SJ0PR18MB3882BCB095875CF5B09DC88CCCA29@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24def24a-dfcb-48b4-7561-08d97db7797e
x-ms-traffictypediagnostic: SJ0PR18MB4010:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB40109AFF7946C1B3025CB385CCA29@SJ0PR18MB4010.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NPTT3Pu43WJaPiKeGtfrewEFn8DqAJSiKGJaqDBsh8ie0LgfQqJrj6IckmdLimgAW11G6qb52Vbnyw5TES++Gbxif1vY5EmfgwklI++LO6UW/ofgMatcuZoCUy21xcIqi6Z6Yg2GQ7Ef+jdle5hA+PNj2+lJ+cEuqg26/VSVm+9Owl2Ve0O5aVm4MCzIjm4MXfX35bn4iJtYGHX3lI+PLfibI2HHhqnGxUCfuPsnhsJhQicr9qzXGZsu9RR05s7/f88Bs9C7Me8N/I62KXoAczyx1+G7Nd/c2+68dD+O5+cxvffR0rbUCJlLKL5MqJVY1vA3aOp8b6gdZXfG6+5X8p14PVUNiAMoKYQc3bkdy4IGUD9OpxCJ4NmVibUi4CXWB/wX/Vo81NVKMSXQocK8ScBp7vw5Wuf+/dSQGk68+apBeFjucJQ4sXdtqAvOuRMtD+LMrDNarSan0tgfMa0n70CH9wWy4sJAkFDUaZeI0QrYnAP++3Ll0Z2o8ErAlTVadX/ryMVXW+Q/HPZWB1tkHdxOL7pHgCEONqonAooXjrAUiLWmL+H1VbMbxgdP7Dvum2cpIHAGvbDQwQQnGiuZHzvR04+mODf9Ik21AmnHLKOE+dK3FKEHib5HR7ak4ggBW4K1DnU1RSxp66avW2ilAedYHIZfc8YmgM5X0vwARtYN9yMZWGG3M5cD+POVZ/u6KmIEZWm/wAl591+5ZdSWyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(66946007)(86362001)(66556008)(54906003)(2906002)(316002)(8936002)(38070700005)(4326008)(66476007)(83380400001)(71200400001)(64756008)(66446008)(6916009)(9686003)(107886003)(52536014)(38100700002)(508600001)(7696005)(55016002)(5660300002)(186003)(8676002)(76116006)(33656002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JIhhHARfnN+DmILQfaJkZmJAmhDEtX0LSPHWj1Bof3lH5cbYyE8+0EmpZz2Y?=
 =?us-ascii?Q?GYuN3Z6SCmc1/nGd53vb1XIsKPPE4evbNA+IW3FCe2lQd/hB3Oh6yYQZfaiC?=
 =?us-ascii?Q?jFDCHvWXCIUSzzclhB7mA9URKIKvynL6lpn1nsf7ghOKkRKCJgm7wDxbzulO?=
 =?us-ascii?Q?Ueluwx8+xuSOjVynnydaf93du3XteT9AHqXNYeKYIw8H4hCq3UwMmrvjLAzA?=
 =?us-ascii?Q?s9NvEGQ/T03GJ7byg1tCYx0OxK3sIPVzZV35Nwp6OFrA/kmuRmrIphjnJwUm?=
 =?us-ascii?Q?3WDy9HgI55MG4+xEowlgyI3SjTEf/51lHpUZmpqTm6dg1XxmVAKE+t+f3QHZ?=
 =?us-ascii?Q?AU0CUBDol2tsFOl51KXxYgPjuauZxYg1MAtSMI/UxPly1D34g03IcyTwC5mH?=
 =?us-ascii?Q?PZXXZnJ6nObYH17rHeGDG6KbJ15hqflTukQDjmJCmP2nrnb0cP84uUDSoCmA?=
 =?us-ascii?Q?mNSUgS7v8uKQiyfTPXEK1sth6/bxlobOvdVMwmQvdGvxZMFbXQuEXSqXtfOm?=
 =?us-ascii?Q?jmtsBgiHkukYlp94wnl9afbw/ciyjtBDEj0Av1ZKtYGf9hTeG2YmPncJXwQB?=
 =?us-ascii?Q?0BMobJmmhdFvMKKZR3EpjoJCJkXYe+lbRx2V0aMMwre6WEdWaVNxkop+gTGF?=
 =?us-ascii?Q?KhGU++Qx2eH8SWvRnGScCBekDWZz6HGj3SksJ+sieZtIsPfCyNk9i9ZsBl3U?=
 =?us-ascii?Q?XHCznFZPXOYdwnzp/vzjdT4D/Ayl0WuxNbIhnoZkhmVcsq4G9pBrNFFfSXGg?=
 =?us-ascii?Q?IoeagXQoA8ZUOKzBc9dcT7h1lkOPc42tOies1Ryh42wfSMw7tiPqSCoCQIrt?=
 =?us-ascii?Q?I+XWtrwGmSBdIwDlPi7nneEgfF4L6u9D8X0QyoyFl80adshm+FshYEBsx4xj?=
 =?us-ascii?Q?NableHXN6xrtXJi+It0zHIf+k/csAcs1hPSTJrDTI5SRKMR0wkqft8S3cwVL?=
 =?us-ascii?Q?Ddm51RB1LtRU2Vfk0xaGOG20rO8pJV6SRfkJwWueESzzRMKP0Qg89iGoKgXE?=
 =?us-ascii?Q?LtBVJMKkPsIbwX9sGX86pBr3Hxa4YkR3csocmPG7ya0/iD65SSCqxQyDQqyv?=
 =?us-ascii?Q?V5vb7pHQvXXhoes5xJU1nHAvmSEG/L+dZwwWNfIz+Ok6Yjv7M4WU6GiNRflh?=
 =?us-ascii?Q?gmpGYaObH8re4jxKzDoaYxS/qpmHj2ar8e1XeJoppNo2iyS9P9JPJR8aOq7c?=
 =?us-ascii?Q?eZBLkBYbTljBhTT6uFi19mBUw4FehbtTvzBUXsP7RqMBf71E+VDPtGcZ8WwL?=
 =?us-ascii?Q?XWQv1PyqadGGfEJMxa7+jHz+McaZnt9klJM+U35NlnQ7rtjDzDY3VKUCyJJp?=
 =?us-ascii?Q?sKZok9EjE9pjkFQ4gUwzntdvLoUIs9GUYDKerjIWs3mjKJxPn8OSP/EKvMKW?=
 =?us-ascii?Q?8UzzjD8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24def24a-dfcb-48b4-7561-08d97db7797e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 10:55:21.9199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUwPkSmR9b6tOHnEdUrjRwTQrjhpp9O4/SCZEtZzTmDmfL92t7XO08rtH5454nJ7f7MVmZ1mPxSmtQZMDAQlSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4010
X-Proofpoint-GUID: FHRXZPBg69bruc8qEC1HspSInOJdT_-a
X-Proofpoint-ORIG-GUID: FHRXZPBg69bruc8qEC1HspSInOJdT_-a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sept 2021 at 12:40, Leon Romanovsky <leon@kernel.org> wrote:
> On Wed, Sep 22, 2021 at 10:36:31AM +0300, Shai Malin wrote:
> > If the HW device is during recovery, the HW resources will never return=
,
> > hence we shouldn't wait for the CID (HW context ID) bitmaps to clear.
> > This fix speeds up the error recovery flow.
> >
> > Changes since v1:
> > - Fix race condition (thanks to Leon Romanovsky).
>=20
> Please put changelog under "---", there is a little value for them in the
> commit message.

Sure. Thanks.

>=20
> >
> > Fixes: 64515dc899df ("qed: Add infrastructure for error detection and
> recovery")
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 8 ++++++++
> >  drivers/net/ethernet/qlogic/qed/qed_roce.c  | 8 ++++++++
> >  2 files changed, 16 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > index fc8b3e64f153..186d0048a9d1 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
> > @@ -1297,6 +1297,14 @@ qed_iwarp_wait_cid_map_cleared(struct qed_hwfn
> *p_hwfn, struct qed_bmap *bmap)
> >  	prev_weight =3D weight;
> >
> >  	while (weight) {
> > +		/* If the HW device is during recovery, all resources are
> > +		 * immediately reset without receiving a per-cid indication
> > +		 * from HW. In this case we don't expect the cid_map to be
> > +		 * cleared.
> > +		 */
> > +		if (p_hwfn->cdev->recov_in_prog)
> > +			return 0;
> > +
> >  		msleep(QED_IWARP_MAX_CID_CLEAN_TIME);
> >
> >  		weight =3D bitmap_weight(bmap->bitmap, bmap->max_count);
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > index f16a157bb95a..cf5baa5e59bc 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
> > @@ -77,6 +77,14 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
> >  	 * Beyond the added delay we clear the bitmap anyway.
> >  	 */
> >  	while (bitmap_weight(rcid_map->bitmap, rcid_map->max_count)) {
> > +		/* If the HW device is during recovery, all resources are
> > +		 * immediately reset without receiving a per-cid indication
> > +		 * from HW. In this case we don't expect the cid bitmap to be
> > +		 * cleared.
> > +		 */
> > +		if (p_hwfn->cdev->recov_in_prog)
> > +			return;
> > +
> >  		msleep(100);
> >  		if (wait_count++ > 20) {
> >  			DP_NOTICE(p_hwfn, "cid bitmap wait timed out\n");
> > --
> > 2.27.0
> >
