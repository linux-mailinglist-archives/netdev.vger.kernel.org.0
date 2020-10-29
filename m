Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E88529EA02
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 12:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbgJ2LGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 07:06:55 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:32327
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbgJ2LGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 07:06:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVd7Oq6WCVVwzW7o/wUeNL5eChbaJVL/tpttnCpQYXH94B+7kM1F5MkFLKXoaSFz5jgawhToVMwrYXnygH3m2IssawsIvNSC26rrVjPai9AZcj9k7EcNLGwTyClxETzQ7Cdvf5G+oFNAXYVRIpWOLgb+XuFCCLQbr+v1JbskXJzdH+MDZjVbW/k4ihhArBE9RfuML59K9HFGRy0aZSt/p2oz4HuSAdN6rcZmqWcbbAEDTlmblK+NCZDrdetx3zK3wJ5xNPwYdzAc4S7Q8MubuuRIUYBG7h6KPiWu20gJEwcijnbGe4l14eZF29UhS1XxpB3kL7G8FHJpgh5PEvMyfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJbCiPiloaoYvlC2ib66DxOopObhv66Rrt7Ur15W2Ew=;
 b=MCVvbOR2IuXKwYTTzzF46NQ/pN7wh6uHV8j4JYur8fIVn4rL6sqcqQ8tMLiRBf3bBe/hCvdLyrF7W6LS0pPes/EdJTcKAlnXnseRtjjGB1fLUR6VTAp5qEKPdx7jOuWxzYQ1X0TL9btHjBnNzW8W0s5G7rTfQNtx5b3VT4QsHPyvTbDoR6YhUMWwq0rVqkgA3dfbWYCdxm0qp43uq0hpUsDtvg565KUxkh320x7rUlMn4wZTMdeEwOGqOn06xjxsF+UmRJ8Y1aBNgJZo/gDql/gZEWrahh9sUYGpeScIZyjwhC/xQqqMbgDjscYduxHSprtygE9UZ+n4fCvjOECCqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJbCiPiloaoYvlC2ib66DxOopObhv66Rrt7Ur15W2Ew=;
 b=l0ejH/w/3mQrX7HZSxfYHw/CKAVBcMMyrnXLbGEtrzKdXoIHe0pb6yaimhnIbosS8koj6NhUJmpgTa4wS5D47LO20yqX6Mqi5GvgJnFmxmyFf8GGRoxMHF4Xn00m4zaHC+iw04mImQpHFz3URKpo9qg45fdv9nF1gVF7jjXz0UU=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 11:06:48 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 11:06:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] net: mscc: ocelot: make entry_type a member
 of struct ocelot_multicast
Thread-Topic: [PATCH net-next 4/5] net: mscc: ocelot: make entry_type a member
 of struct ocelot_multicast
Thread-Index: AQHWrZsfTNJok4x350yal8NLoCn43Kmt3ZWAgACOZIA=
Date:   Thu, 29 Oct 2020 11:06:47 +0000
Message-ID: <20201029110647.nfwpfuqkbznqmo2u@skbuf>
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
 <20201029022738.722794-5-vladimir.oltean@nxp.com>
 <5831e03c-1714-4ac8-3073-d18f807aff26@gmail.com>
In-Reply-To: <5831e03c-1714-4ac8-3073-d18f807aff26@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fcd7aab6-9567-4f2b-a8d4-08d87bfabae5
x-ms-traffictypediagnostic: VI1PR0402MB3550:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3550FA934B526D192A79CB78E0140@VI1PR0402MB3550.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zGbWLtYE0VwN5G7Dux+9iM6pb+cx9B7/oPAjjyE5d+QD9l1GTnyl4RVMmn6xCgjj1sYQV1huDfL5fxxijzsqen0BBj0DmyBwolBTAC0i/9DX/kFaS4TFyFO3UYS4c9u2Hdzbr7jz/5fmysdurn7fKBQ5I2Gu/QZqFWuyWETspZ88ZqoCuwpzSgrOsWlC5PgWm2c/iF+tQbhsy6djHU3hGbgrc37sR6caH7MQV6pdISWi72q8avMA7DTIOIs24QHsKBl4m/o+b5HoRgNx1i2VnQuhYKtlXgViTYpsPaDt9AgmJEgVWXL4JJILL7nr8EcvcS3i1e52I2SbaJ/J1Hxzbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(8676002)(478600001)(6486002)(33716001)(8936002)(4326008)(2906002)(6916009)(6506007)(316002)(54906003)(44832011)(66446008)(186003)(6512007)(26005)(9686003)(5660300002)(86362001)(66556008)(76116006)(64756008)(66946007)(66476007)(4744005)(71200400001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /qZVaDhfVRV7wFpHZyyYdc+FxGZ+yum+hd5+iL59arj0yUg3L12hNWgqVmutb/xc8YKfW8ZkQtmA80hexQt8Yonn9jjG2iq/FFBF2w/4NpM3Z/74xnrbwPyj4HmsnlXZjI4pFcMrh2RiqbzHDBIcY6a4N23mnNdfckLb2NsgnEAXUt3TKATvWbuOt7lJn22NvDaqfexKLT1aOjIcRDQ28j4avadaf5bDRFjd81KtmarI0voQ0lURPSOBRBRYDQRPJGhY0snuthAtc7qn9Fsz2I2H/SLPcoxhMfA4dsvBLgjub/3+6GXC/fm2DV+7L0cNeXDmTsSZo/uotbTEy38tQR9wG4gVuKXK0Tk3t3Kw/nDnnXbvwTGz6dKbL+LwPGSKR2b8dL0L9jrpde8ft9g2QQsK2PQbL4W7sjIyGvwtXH84Jzy2KeqEAmMzdPv3ae4dY0/hAuL36hljZtwAnlogtthjJqTekJ3RKNNbam8aDMl2LDgypOi1GQt5I+QiXpl13kdthIMe1A4p1typDDvhkZPpHp0RUHNUrzclOcm4WYDHXPjtq1vibPQs9JXou1FPB2Kciwqb5laxWxaWHCDYTUxaTosgskDUARd3Gajfekwf+1GYg9DxXtWRgUM99nuFaqLIBSBLBu4uyw8xkiK3WQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1264763597DD6E46857DFA1BF2184C6E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd7aab6-9567-4f2b-a8d4-08d87bfabae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2020 11:06:47.9029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NwZyXdmGTswD8A/Fr3kQ37MneEd3Y61I0gtdFI/2naH4bYsix2BKb90O2nzvoyqAceglDTbhRXtv9Vkc+LHrlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 07:37:09PM -0700, Florian Fainelli wrote:
> If the MDB object is programmed with SWITCHDEV_OBJ_ID_HOST_MDB then you
> would need this gfp_t to be GFP_ATOMIC per
> net/bridge/br_mdb.c::__br_mdb_notify, if this is a regular
> SWITCHDEV_OBJ_ID_MDB then GFP_KERNEL appears to be fine.

Good point, I think I would need to do something more radical anyway, as
programming anything into the MAC table calls:
ocelot_mact_learn
-> ocelot_mact_wait_for_completion
   -> readx_poll_timeout
I'm thinking to move all of this into a workqueue.=
