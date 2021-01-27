Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46426305E7A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhA0Okj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:40:39 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51748 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231852AbhA0Oif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:38:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10REaGk1026187;
        Wed, 27 Jan 2021 06:37:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=GOMjG12mSuCDg62kHYZsd1N9hFELbiVoMXAXoXdf5xQ=;
 b=QMCpWUZZEobBG19DL77caTugK+IGeHAYidp/I1VowiOHy3SWsMCaYHxn/jsfoiunHSSY
 IU86SPbGZ4lwfII/45x0J3BV1oPCLbk1M/Q0vQNImMPNQNQRJA0CHEWknWyP/a0KKt92
 3VkBzUc4SyLQZp0PjpD00ojjCnBqYas98oXNcy+tZRQBkiH5TMmVawIyxsvXA96IinI8
 b6yANbLl+NpBidTDxyRxRL+PBZ0lIfeGAHxJKPwXn4OWqHcU9aF4kJAtQNedJceMlasC
 zMyvhFV4YprkXRMs83Bezz5jM9JCq6aUmYtY2AeJYkmfAMmB5sN3rIkJrwEu2kCxR04z fw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ubtrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 06:37:40 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 06:37:39 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 27 Jan 2021 06:37:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LL1LIhAm3pIrwEwq0VfNIUAgUHfODDMNmaKs3vMKgPQlTr9DE+DTYbLHxVjRnYQlHM9yGKAsGoGZeWEJ4gu2/bpYxHUNR796pBhFvQltFzOVvCxNDZOdCI2uDsre6dFBCG4O2HAklkYhg5XTDq18DQ3tnh8Kfw5S8KPzO893/q+t1f1pMX6iTlSpcSGPS/sedWenvcuiezj3s9cgalvoqfnSjqSHsSIzBS8/oQ0b8Ys6t5VWR0OzaxV1AO2NTWW5XY6/Z2ajk0Gz/9LDdCnAX89cuEj6yBpKYTX1hGCn75sli6B9oKBfZtkRAqIo17NCiC+O31Lix8BSGPmsLOAyeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOMjG12mSuCDg62kHYZsd1N9hFELbiVoMXAXoXdf5xQ=;
 b=Lv3vr8QuIDAvEtZXVqzXTTM+qzy6rJI+fPvSxugtY2RXxumjdwcONL5iT2k+cKoqSnHXP6qJT7BsvQyG8dCcBPtAYxmaoPGrgpz52mbz/tpyRoBNWUEJR/Hubd/n5ggGDA4BSHFk88habI8V9QcdIbYQiESMD6KulEMvKw84V6w4E64342hemPrzRLn2bSzNZc2bwzL5bbsfSgmIkoNy1BieCOQiPXydWDiozLbfBJTtJ+zwvExbklBNVurdjfvZ4W9FNx3QwZL7Q5IMvCsRyVzdwjIYPPU20DWqxKLU+TuOjFqlbAKF7sSFWtLmPRyWOUZ/FpsATQun/rOzwY8RFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOMjG12mSuCDg62kHYZsd1N9hFELbiVoMXAXoXdf5xQ=;
 b=itN2yjI9y9cxB27brd0Xlmp8MNZhcjSsABROJy1SeLpJQg7GaiDJPfoLH5dvpfTSs/JNjGMHvMmWCDLPbj+9011CfV12vIMj6l61tziSaWFcOU9uUEwTq3C968cC876evuntVU/t4E6XilSE9NTvnN2BhEwsI6RlrBWuQZ30ZR4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW2PR18MB2250.namprd18.prod.outlook.com (2603:10b6:907:11::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 14:37:35 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 14:37:35 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
 firmware check
Thread-Topic: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
 firmware check
Thread-Index: AQHW9KHjwS0UHLuva0e0y+cDZ3p/aKo7gciAgAAH8aA=
Date:   Wed, 27 Jan 2021 14:37:34 +0000
Message-ID: <CO6PR18MB3873034EAC12E956E6879967B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
 <1611747815-1934-20-git-send-email-stefanc@marvell.com>
 <20210127140552.GM1551@shell.armlinux.org.uk>
In-Reply-To: <20210127140552.GM1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 426743da-c4fc-4222-9484-08d8c2d11642
x-ms-traffictypediagnostic: MW2PR18MB2250:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB22505C1D779A930CD684A519B0BB9@MW2PR18MB2250.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /gy2IPNPqqfEULaMsPc0m/uDN9iEZeJCpa5nBADnN7cMEncS+2l8QlCHg/XcmxMWWe2BthgAEdSeDkvbPYrtr3m2KmynmmPAkhx5KPl3YkSNaBH6ZqZ7pzDPVlMHN8tpJzD0a0Lv3ISpwbIXHMfyV3X82MKJuW1cugYPORAt68z12ZJoyVNZlbhEzCXWsHiC91QJ7yxp1aGPFUjwRg4Qz4/uNzocv4kA/gpJln7xw+51Bbfd8LzL1P5XPzeuwGq3G3hcosh463Nx8tHQBE/2NNCwOc3Gb/CAyoi9NFE6dSfAW9Bv6Hgs+g6hbVFYvAFfoacAdbxcNmH6bfkaDHkxw53ifkb1YbbbHzGlktELdUF52xXLv0fFD9pcNKXcGf/I6MOk3UFZqLqKV1UMZAc4LMgH5yblpn8yUKdq4AW7LN80JfFAgu1aH1H6KL8jwSa7vWTDLUrh9XU76/3x38yejlZ8bIwn/qxNYGKzuT7MTldNUC4q7DvfvIwZIh8PmGdQx3o/J9N6WJ8BdKVDJp48sQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(186003)(55016002)(66446008)(54906003)(478600001)(76116006)(71200400001)(26005)(64756008)(7696005)(33656002)(53546011)(66556008)(316002)(8936002)(8676002)(52536014)(6916009)(66946007)(83380400001)(5660300002)(4326008)(86362001)(2906002)(66476007)(6506007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6s26E9IRgmoGlUvKTad0xkhIcYslBx1BTgSgnVbvE19COS0XNXvLqq6K2IpX?=
 =?us-ascii?Q?UMVn6wusNjchdxMIvP019exOadpoju66NAdZbk+EZnW1YNSvWbwCaBCIB+yG?=
 =?us-ascii?Q?JivdqItnE7XZC626+KdRFpSW5YVpaF+vIfSBJE6KVZkrP+4Dp2u/G2eS2dX9?=
 =?us-ascii?Q?KkSw+GWTbepPHQz0FPguI++0sgjpL/pfn4ERgeR1Br7ylk/vQDjfk+V5DvKO?=
 =?us-ascii?Q?DntAycCY4Sm0D3bvcFls7d2EFfDKnU1xXc4mADThyvbvyOzjQBGwATLdSrbl?=
 =?us-ascii?Q?EY+ztAatORNTPSlg4fANm7c3pfAYwghyPJ5AcB9U6G7V4OqWnBdiX5kS+2u8?=
 =?us-ascii?Q?UyuNfkCLjr+Q+xhrWDZ4Af7Y4pX13CDxttit20DCKbft6qQY9h4FX4dyt6dp?=
 =?us-ascii?Q?zdlBr0/+W/ljcJVm9WIRErOYbOY/0ju+4Crj02C4NKgsor2HhO16Gme76g0Y?=
 =?us-ascii?Q?fV8JktVav+5k60Ger4qaiSGQl82AIXhuAfJzzthxVkT55XO7IsLtGzTeyU2G?=
 =?us-ascii?Q?HlILufZWBboLwh8toZyqLJBppRS1XfHb3Be3XFYxSTjnZDvorqnPAVa3bDBF?=
 =?us-ascii?Q?3mizvRJMDRgc6VJz+32liq+L4gKERnSwfoyCppBnU89ZGfJ+Tot0ghvyDipq?=
 =?us-ascii?Q?cTsAHt2kFZnjjUldEh41iuv508+GsL9eC+ZLQMh+45mJ39E6DzSdjpI1fR2l?=
 =?us-ascii?Q?9cCbkL1aFLBtQpaTi/6Jhnu0W9WTeJNWJg0yEtEWI3H6cOlF4PDm7/aeLVDg?=
 =?us-ascii?Q?Teo9wg2lPSyd76Z5S38O6vwfXNTK+cX400v+yL3Eogorj+CBiZu4XkgWMylO?=
 =?us-ascii?Q?qdF5Dee5aeFzpWTy63/fCgsAXkykmu473GrsiSnOrVQPb8ZDLyjjs7a/Uhnt?=
 =?us-ascii?Q?vMN5ibFYswQuFCgOGRc2T3sxF7jOQKy1eFtHPk22u0XWvHGoEzksciXUMXxN?=
 =?us-ascii?Q?dg/xo8LsfLT5GGBvxxwHIckrFMrGHyjA5Z1Fj27mFOXftg4wO6xUI6H7T/q6?=
 =?us-ascii?Q?gXhp+hN7CLQTSviiarqxP7tolTl2fmzu0MdGmuVlUg5MD3yzIfAvydWEruZL?=
 =?us-ascii?Q?Js6iEVW1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426743da-c4fc-4222-9484-08d8c2d11642
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 14:37:34.8887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LWd2H5BOEsQ7kaqQZYXoR4MfENhFV1OABX/Cj655D1gZyT1kvHHH8RTrLLOM+KHm0IttyEavMX+oma/3Ks0A1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2250
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Wednesday, January 27, 2021 4:06 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan
> Markman <ymarkman@marvell.com>; linux-kernel@vger.kernel.org;
> kuba@kernel.org; mw@semihalf.com; andrew@lunn.ch;
> atenart@kernel.org
> Subject: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
> firmware check
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Wed, Jan 27, 2021 at 01:43:35PM +0200, stefanc@marvell.com wrote:
> >  	if (priv->global_tx_fc && priv->hw_version !=3D MVPP21) {
> > -		val =3D mvpp2_cm3_read(priv, MSS_FC_COM_REG);
> > -		val |=3D FLOW_CONTROL_ENABLE_BIT;
> > -		mvpp2_cm3_write(priv, MSS_FC_COM_REG, val);
> > +		err =3D mvpp2_enable_global_fc(priv);
> > +		if (err) {
> > +			dev_warn(&pdev->dev, "CM3 firmware not running,
> version should be higher than 18.09\n");
> > +			dev_warn(&pdev->dev, "Flow control not
> supported\n");
> > +		}
>=20
> I've just booted this on my mcbin-ss, and I get:
>=20
> mvpp2 f2000000.ethernet: CM3 firmware not running, version should be
> higher than 18.09
> mvpp2 f4000000.ethernet: CM3 firmware not running, version should be
> higher than 18.09
>=20
> which is rather odd, because I believe I'm running the 18.12 firmware fro=
m
> git://github.com/MarvellEmbeddedProcessors/binaries-marvell
> branch binaries-marvell-armada-18.12.
>=20
> Any ideas?

Your mcbin-ss is A8K AX or A8K B0? On AX revisions we do not have FC suppor=
t in firmware.

Regards.


