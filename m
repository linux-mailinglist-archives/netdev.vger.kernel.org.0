Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE9E3CD706
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241011AbhGSOEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 10:04:32 -0400
Received: from mail-eopbgr140104.outbound.protection.outlook.com ([40.107.14.104]:18502
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232531AbhGSOE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 10:04:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEDFcImkfbrcuAVQFsxmY1cS54Ud35cc1m0H5qfXIW2cf2CLpVLCKUt1rxAyTtUYwDboVcM96WnMBjJMeoId7hyANd1Oie1p0InwFXjU9hwUNi8OQ+zldsvnBvpBqgXCLWDLRP+gevQUUFdbk6zOV4hjOXYkNxTulcIpFF7+ZN4vDl2CEIEccV/Rbg54le9VFYligf4EfhQ7x86X4E3oMhP99OR1lK2ImUXTus4s+L0v3ZGBI9H97IkXBAUL53gG1gtlM8GRCQkVG/cELQ/vjp1Rnw0HKrs/sW+t5Nu+A0G0Tnj8cLAp3tBDD0MI12Lz6ivClJeY5m651Ut+hl/lMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/Frf2Qdsy8LMfnNmhn5uHGMqmWjJyVzhgDTuUZwuwA=;
 b=NevFcIY21+H5NeZm9ZBOrHr43G7yfq6qN42mfjBHnVzvO+0bDVkgX7p4SLXCK/qjUl+tJu66/k4kT9Cfi9Lba1JaYHNq7R5IfncbyBOgu/1yH2vIiGAdZ8TdnL6cj4IhnLUoRRjEiJ5LiR87zUPQZ9Zlg1Zx6dltqpcSVj/COgj0XebacrPnQtDJWLnRaHyDQyitKqRpKCR4JqEdy8XXO8+IjP474Ngvqvb0Y4400gIGvrmBsqpaxy0yTI1ghy3Z6K2n720Jm4r6LGNSioHed1BTTD22TS35oK+xbAhEXE4FXI+r5uu7oWUkAnr+do5KYD5MFB8X0oHxpAnuwV/6eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hbkworld.com; dmarc=pass action=none header.from=hbkworld.com;
 dkim=pass header.d=hbkworld.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hbkworld.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/Frf2Qdsy8LMfnNmhn5uHGMqmWjJyVzhgDTuUZwuwA=;
 b=j3czxJ/4FyLO7gGCM5uogtlm1UumnWfaI5qWwLgfZkpSEgsXa2mMH7JYZEwfqPRgwdFPTssRyjYSWw1h9qVo3n5YxDui/LoezqzMD8wQTKjONEfy2ABLB1Q1mXmn7pqVCRsArsIYkN7UGSDmvCmhnEGxiMiEv3HTdIW/FZFx3PaAQWx/Px8e/Kq/afEq802X5+OOE0D3VyY/n5PCBcS0auyObTYNKkgXPj+HnwfTE7+AnsbkeLaOgDygXJmkskY8CauPgSCqHup0tH8QOkFaPEEIPz38pM/3QJ4GDJs+Z01maczXLRYGw01OIsHuue/HNNTwuMRDJp4XpmOXHPXPDA==
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com (2603:10a6:20b:166::10)
 by AM0PR09MB4356.eurprd09.prod.outlook.com (2603:10a6:20b:16e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 14:45:06 +0000
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92]) by AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92%7]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 14:45:06 +0000
From:   Ruud Bos <ruud.bos@hbkworld.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
Thread-Topic: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS PTP
 pin functions on 82580/i354/i350
Thread-Index: Add8j5wx8XMO0pl3SxeqH60/gUl7XgAGsUmAAAA14MA=
Date:   Mon, 19 Jul 2021 14:45:06 +0000
Message-ID: <AM0PR09MB42766646ADEF80E5C54D7EA8F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
References: <AM0PR09MB42765A3A3BCB3852A26E6F0EF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
 <YPWMHagXlVCgpYqN@lunn.ch>
In-Reply-To: <YPWMHagXlVCgpYqN@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Enabled=true;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SetDate=2021-07-19T14:45:05Z;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Method=Privileged;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Name=Unrestricted;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SiteId=6cce74a3-3975-45e0-9893-b072988b30b6;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ActionId=dc21ad43-4fd8-4872-b54c-54d6717b567b;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ContentBits=2
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=hbkworld.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 283ecd8b-f83b-447f-6bee-08d94ac3ccf1
x-ms-traffictypediagnostic: AM0PR09MB4356:
x-microsoft-antispam-prvs: <AM0PR09MB43566B8B836CB325F1BFF816F0E19@AM0PR09MB4356.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hJoWcnHg4vvPYVdK8bsgBLLaW3DRd261QJ18Ep714EI1h7rtGDTsuv/EjDYbV6jivY3vp0ryw4ERLDwK4zZh/RYYawmg7PrcFySb+6RIbZiZ02U8wjCTASIhBfJyEfKIszkfJUuKFDFj0vOxbzdBINDapIhJ+/jVSw+MPU7AhqJChb7wqDtti1h3QQjeGAvnd1I/moAN/2dx/PdiGRRFvxmZD8CZCDWdbHOqBEhYF1kfJvYxGJdCIBpAgZFL9aDKQUgIVylJohNMailzB5T0CSqPMNGq35j2rLs2nvpyzHYDmVJxNsJJmCf859mIVbeL8dsHpVsM+SQdrddo+9oSnwNraeZoTgJIowTAJIVbuhYXLuW0RPUk1CzXZ4keB3gGTs2UupXla1O0iqbTA6T9Qovw04DAT5GJ0XFJPuEpkEqh1S5xbz0qItpQeO0T7sZggKP4Kvs4hSrYeIBWsbpMPgmQ6VwGJ687XXm/vsgR9ZXS7B0LrQsBgeuCc6ba6tKCDa0IjHom4egSIgDfKenXUQT+S5I2P5m9W3dFguBOhDVfiIgPPRaZJe4NQxgapo9qtoT+hyqhZ2Sg75AlEHg3bXuFtB35pKliP6P6u6lN0Vr0r7TW84HCAeUssTA5OgLZvIjdcf0sNQTaWvf7UC/Q3QaDoy95DQ9nmfdYWUEdeDeRC0MIfWIllVw8CPhly4cWbOC5aaV/C4x5joVRxXN51Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR09MB4276.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(346002)(376002)(136003)(83380400001)(53546011)(4326008)(7696005)(76116006)(8676002)(6506007)(9686003)(44832011)(54906003)(186003)(55016002)(71200400001)(33656002)(26005)(316002)(66556008)(52536014)(64756008)(86362001)(8936002)(122000001)(66476007)(38100700002)(478600001)(15974865002)(5660300002)(66446008)(6916009)(2906002)(66946007)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h6JfT4Mf9GsMGL6RBxiQZjt3gQZFth8Cq8M8lIPK+buIlbicKPdoQTQxPgMu?=
 =?us-ascii?Q?tuE+EuixzS3LNekORl9ca2UGSdbrSOERWs7eW+ezloKOI6qOdeWgoFN5N5Fg?=
 =?us-ascii?Q?9ZPJIVl+Gzqd8iGmIVxqTi78w6ai2tpXYlXOi05wPtipFifVXD/j8qoSF8yE?=
 =?us-ascii?Q?0V9WB7YEtJyhLgl3v0IGa4nIP2kp/+wKhMZuN1XIAXedVnrYc2lBt2JWnYu6?=
 =?us-ascii?Q?dqApL6TkQSceuuEXO5XaCQFdQK/0lMVE8D5yx/t1Oq8iNKHTYqzj5iWoS++H?=
 =?us-ascii?Q?8ggwA71T3HSBHiXAstU5/WT+dKbAeayeIul5+57r+J6Otwanth2/Q41nQfrv?=
 =?us-ascii?Q?ONuInaN1gHMvrapkyrohB5/P5b7vt5M8rtHML2jXk/RI0EvfqQVr2Gnjgp+n?=
 =?us-ascii?Q?v6NYAIF6kNEa3wuS2Rigxjvg5i8wOvzs3Ed02gx4SvLvCq9MMVsUhbF8v+Qa?=
 =?us-ascii?Q?NXHAuj9083NyxZYjX4kadViGP/uFjn+XB6zN8xW+OerAoyYJvay8MzHTlTdO?=
 =?us-ascii?Q?zk2XgoRuIPOAW9O2sF+ZrgNW/hUxp1x/IiQCSQgdNljL5rB8s/lhXs6SfO9y?=
 =?us-ascii?Q?ZWDmpjtkbV7keKfIOASC6cl10Y+dMtOnSodvlkxpfmFnoJCHq2iP2L7upWPZ?=
 =?us-ascii?Q?8/FanffRqouEFzDl3g9TSWr754wA8h6mGE2LgcByPxki15uiFr35M/rZt9/h?=
 =?us-ascii?Q?chaJ+IYaHRUuSfFWQyh0okFt2/S9//rlkZ7blPpZ2wolzvFJ6rtjjXykJuGW?=
 =?us-ascii?Q?tdZdgNkn941Lb7q0vNyikrgG67YB1N8HqedS9ugiViegFMexAiiHjvT2Fzxh?=
 =?us-ascii?Q?YMMQLfWhIfBelhy2CCTvbwg/+4AmPeKe5/Jm67EZ9MHYFQGJOTkHeOsBYR3O?=
 =?us-ascii?Q?xO4yz2e2fhlcljrQFAVp4UBHC0nD8BXT/gJYMvVmuzMFw91O2dRg5YLYJlZu?=
 =?us-ascii?Q?SMlKn2ggA/pD3G2v3UwZMEMeEeBSaEKudb+KEHU1o+Gbs0uLhqSJWMogeEMu?=
 =?us-ascii?Q?XO2ZCVtrtJqqDxZk3GlbHcuLXtjY1Tu74mjS3fjcOFaInMak/7E6FS0Hk1xz?=
 =?us-ascii?Q?ZhUuQP9vKUO8+tOn7ATXQvRZcXKcXCCVvWEX9dWbF85NDNtnfmwieLtUOg1u?=
 =?us-ascii?Q?mpk0+4b9NM8dwWTh6VeYO20/q4QVMaMLsi/9HY54XoAfgiyZ7nHI3Fv0tUni?=
 =?us-ascii?Q?M9LzfUrAgfYqVIcSyJT5g4jMfprYbCnBCXvXvXmohKETqZoS5fZP13VathQY?=
 =?us-ascii?Q?Ffvic0pBJabN5qPs65XCWlMMJVvUbVMu/mjz2Rf11h0UsZIEP/oTb2DvbBWS?=
 =?us-ascii?Q?60Y=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hbkworld.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR09MB4276.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 283ecd8b-f83b-447f-6bee-08d94ac3ccf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 14:45:06.5972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6cce74a3-3975-45e0-9893-b072988b30b6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8J0l3dXCzU+k0dhNuClMQRMxrpegzEJSxL0o+FCD3Awz7F9QQYfgEj0nyyWf8SSq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR09MB4356
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, July 19, 2021 16:29
> To: Ruud Bos <ruud.bos@hbkworld.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> jesse.brandeburg@intel.com; anthony.l.nguyen@intel.com; Richard Cochran
> <richardcochran@gmail.com>
> Subject: Re: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS
> PTP pin functions on 82580/i354/i350
>
> On Mon, Jul 19, 2021 at 11:33:11AM +0000, Ruud Bos wrote:
> > The igb driver provides support for PEROUT and EXTTS pin functions that
> > allow adapter external use of timing signals. At Hottinger Bruel & Kjae=
r we
> > are using the PEROUT function to feed a PTP corrected 1pps signal into =
an
> > FPGA as cross system synchronized time source.
>
> Please always Cc: The PTP maintainer for PTP patches.
> Richard Cochran <richardcochran@gmail.com>

Thanks, will do that!
Do I need to resend again?
This is my first ever contribution, so it's all kinda new to me, sorry :-)

Best regards, Ruud

UNRESTRICTED
HBK Benelux B.V., Schutweg 15a, NL-5145 NP Waalwijk, The Netherlands www.hb=
kworld.com Registered as B.V. (Dutch limited liability company) in the Dutc=
h commercial register 08183075 0000 Company domiciled in Waalwijk Managing =
Directors : Alexandra Hellemans, Jens Wiegand, Jorn Bagijn The information =
in this email is confidential. It is intended solely for the addressee. If =
you are not the intended recipient, please let me know and delete this emai=
l.
