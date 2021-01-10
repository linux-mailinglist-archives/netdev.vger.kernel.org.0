Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC112F094F
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbhAJTMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:12:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58560 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726346AbhAJTMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 14:12:47 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AJ6xfV014297;
        Sun, 10 Jan 2021 11:11:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=YOcFISDRElUruOhtfr8a8927rHP9Y/4zy3+j2XUfTf8=;
 b=hHEsPlh/4hqwcKMtRKjJZzW9dh12ioK4VrIShtHuA+E0tx+aOE38pRjS1G5WtHycWrk/
 YlfuUC2P0gROZKBVgxUdc86u1uAm1HO6HUgfD/PB/mVyj8q6Ge64sW4gL6pntNHuBy2I
 N6/HRTX25Xrc7C58DCwU/YL++/5UAls6GzPN5XKZUizQMyumpB+6RhiCCRWGQchxuFQi
 laKWWSNnIT9x5ra1+G/6CjnR5f9uoCKkwIZXwfQCo1zIvMJj35ArnicPB+hwTcOYxm+D
 2SYpSZZwNFVrHOGwhC5Z3dK50uDl+SOCYK8RmAmK2Knhaev6jLx5i59ppWjH8Xkg6zgf fw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpj4n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 11:11:57 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 11:11:55 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 11:11:55 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.57) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 11:11:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXp4ynfttxvwQ/8EdI/fSoUBYWPfr+Qwl14+vkLS1f7jeuuFSFUD5IKCG8qKO3FoYcOewx+zZZjcZhKEq7l+c3xNHrDolw0mxF0TU8RedLcE9kPG94uN4U2ypOPHnlnHix0+bWOp7YO63TQckzoASCkwD3AVGizl3GafAZI6S+40ZtOZbgEyDJ99IpmpeiXl1whkDOGqDNCd4S/Fe4S5BClwLDEq5nPkbyfnl2KWdTMlyFmETE7MODvqDZhjrCPayCeKlLdYV8ubIx3pjHEmrzjOrN2sFPhGojuA/iNo6gEmR53N7X17JiZOAnbWbVQyl1+KIxexaqBVbWGT06HgGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOcFISDRElUruOhtfr8a8927rHP9Y/4zy3+j2XUfTf8=;
 b=RYXdua/3p5/zE552z95ALojiORZKPpwnQ8IcuFI4KpWGxkdH1D4omswC0wnb0qD04IQAJ5UF/ZNp6GD8EQO0FDuZFcLEs90V1ef+nmVibTMIqNTwiBaeXG0om/OZf6FOhNNY0W8hfNyMf3Kf1Tp8jaHP1i43x86yOFzH69YCxdmvjhsyYPTvgXidpBAJJHrhNogznDUqCKZC+D0lgq36EDdKrMKA47HUCo/owYh5RNuIejVMBzaGRoTvCRR9V3slGT/ugL55jAULweV5hkrqcVKX8/36z1TU8KcuycDD8a/H+sI0A2T2rTUTSKOc3iUDt5T00DSIL/MJNbkxjD+IAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOcFISDRElUruOhtfr8a8927rHP9Y/4zy3+j2XUfTf8=;
 b=es5ynXN3gNynrVtyVOlgcSt0JbpnX0c9y5He7Eh+qk6K2G644Q9aA2xKadLoE4TfiaCU8ZnL4wpuoUTgaqSIyB7HzSobSpGV/NXmpMDmWSJeQt7q7ndkdT82baxfPZpxRrAi4DO0jlnlUFlQDVW+FQlf1E1BtoSl6rWsnLA+BTs=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1567.namprd18.prod.outlook.com (2603:10b6:300:d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.10; Sun, 10 Jan
 2021 19:11:53 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 19:11:53 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH RFC net-next  00/19] net: mvpp2: Add TX Flow
 Control support
Thread-Topic: [EXT] Re: [PATCH RFC net-next  00/19] net: mvpp2: Add TX Flow
 Control support
Thread-Index: AQHW52WJ6b6KlH/9dUq7cLwyM+o1P6ohKuiAgAAJQ+CAAATzgIAAAChQ
Date:   Sun, 10 Jan 2021 19:11:53 +0000
Message-ID: <CO6PR18MB387345DC31C2E9AB837E39F4B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <20210110181727.GK1551@shell.armlinux.org.uk>
 <CO6PR18MB38737A567187B2BBAFACFF6AB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <X/tQo0uNFY63ra5R@lunn.ch>
In-Reply-To: <X/tQo0uNFY63ra5R@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5280b7ce-80de-4cda-1900-08d8b59b9743
x-ms-traffictypediagnostic: MWHPR18MB1567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1567A2A851725B9C475FA8F8B0AC9@MWHPR18MB1567.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lt5Xj4K0f2A4pY7dMAyag0npJEEMQAs2kiwZDaSY4XcPXNLwhg5z9Dw4tvs32h8FkVBThK/kM3re4ORoxhX1nmMjCexAnJFYbn0eTr81u9mCudjzGIA7oF7XCIA2qewqA5m6samvqmqM2n972p+5B23SGHMR/hNUT+UQipfXn4bc9jDEH+tczQb+8kkMizL+0NJuzOEziH78bGs3VfL402lFMGkgRcKq3k4rPvV02IBmAArE5zPix1s0KV0W+xWLBaL8bXjxn3MnOp3ythduyHslfoLOYefgiKrEJ6Jas3IDkr+Wl9CgkDW5JTr95DjGtJmXhIvgwpkWs2gfWPveW6nt00EL2eWunsIvxHaFOy0yEgXrpbuNK3W7Apvn5bqHtLcNsBwHeh+ote+C10is6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(64756008)(66476007)(66556008)(316002)(8676002)(66446008)(4744005)(86362001)(76116006)(6916009)(55016002)(9686003)(54906003)(52536014)(4326008)(7696005)(5660300002)(66946007)(8936002)(71200400001)(478600001)(33656002)(26005)(186003)(83380400001)(6506007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vVphcm+kMEpCYiedefkJVxv9/VnJH1gZJ+v9cedbn3uDjsUuKjstJ61VMMht?=
 =?us-ascii?Q?1YvBKKd1YvLb7ok3rVoRKYSB4KpC17ULnkkgS6SjRhnFjZbv9EiiG6C8wd58?=
 =?us-ascii?Q?rQqLgTmt4jjyuT4swwSzwTcS5T6p6hctiGstui+r2UhdCvdMU2aEl35ti3X3?=
 =?us-ascii?Q?77mFTIQDA5kU18UAOlBSj4mmgXgE/6frE87lfQ28+nuy/HD1xQw/iO/S9Og8?=
 =?us-ascii?Q?ZTTH3A6RNKrM59LwUsdldB7fO9xVR8dhPTU3ZvOBKE4aOYnPVjrhJtPaqV1D?=
 =?us-ascii?Q?ZO9ZOcFxa+72raJPNq9i1i+8DLUAYQMwbRtnds8gSzWKCw9/C9hQksrNBt8W?=
 =?us-ascii?Q?v9qIrP48eY1uD1QamxrfGmcsk575yufyKEAOKLqnBtUYWxMkKQ9xgKrhTiTd?=
 =?us-ascii?Q?SOzkQiUl8gJdOtLtBszZnB0BWgl+bg4ffi3NvOfDSMLEVTLVBBH1tPSRdta5?=
 =?us-ascii?Q?X0bZ6vRIk9BtDgwYQ8/6I9P7ov1Np5TMexCie/qqXvY0xwKlab19QueguHEm?=
 =?us-ascii?Q?QsGI+swyHVa6kbvQc1qfqm+lHi13W6AB6Z0S38nIAD3ZwC3pL2JotgI+pvlC?=
 =?us-ascii?Q?3NyLckP9yDenvaUlYCaFCX/Pj377F1lf4biuf6bsfTQvSJLRAEyWAgO1q2R8?=
 =?us-ascii?Q?aCCATqpMpvx7v0mNGoVq1c3I0M0gw+Rf9CCwOqiIWR+cTfBdBRn8Lmy4BcbM?=
 =?us-ascii?Q?GbwVyRP2cI9xrff7ixfw3cfqdWaDBN9SHhCE94GslE7wLPUH02tYUnPasDN6?=
 =?us-ascii?Q?puEHhda+jIE7sOlM12XXJanFOi6/odF9OwB5FuolFnoGe21adhu/NE0l2U8p?=
 =?us-ascii?Q?W7NFIosVIlMDoFc/A+27qA4GWchU7WPI8qQIYbScVlWBj4OaArSig2Xjv7U4?=
 =?us-ascii?Q?JSqAmu2jJeCVAqTD0fU2h6niVfipjL1HsZS8gfF6ECGVCFIjrQQ6KaYaYzop?=
 =?us-ascii?Q?Fq7pVYLSZjAuo6WSfAhj4AMSAn67elITwOaAIRkZshM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5280b7ce-80de-4cda-1900-08d8b59b9743
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 19:11:53.4503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 43d+YPUp0diR9YNW2K60nuCOacuv2Ozmcp6hYBkBAma61HNKO2ZRNlPYtEsVvY9I++WnBlxWfDNGYmfuynzxJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1567
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> On Sun, Jan 10, 2021 at 06:55:11PM +0000, Stefan Chulski wrote:
> > > > not connected to the GOP flow control generation mechanism.
> > > > To solve this issue Armada has firmware running on CM3 CPU
> > > > dedectated for Flow Control support. Firmware monitors Packet
> > > > Processor resources and asserts XON/XOFF by writing to Ports Contro=
l 0
> Register.
> > >
> > > What is the minimum firmware version that supports this?
> > >
> >
> > Support were added to firmware about two years ago.
> > All releases from 18.09 should has it.
>=20
> Can you query the firmware and ask its version? We should keep all this c=
ode
> disabled if the firmware it too old.
>=20
>      Andrew

This is exactly what " net: mvpp2: add TX FC firmware check " patch do. If =
handshake of flow control support fail, FC won't be supported.

Stefan.=20
