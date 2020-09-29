Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CA427D70E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgI2Tj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:39:59 -0400
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:22165
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727700AbgI2Tj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 15:39:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAidtmjn08CJgu0GZb3ZXc0HVd0q1ttTebY0FIqYWmhEtZ5VsQCXzMvhL+gBd5sA0EHLLEMUl3N3H+8vzdNH2CfQEcHbrSS1eatRNRoSPai36aJUEp+l4nVGtzgru6ahTi+FG/nAoZUQ89irLrKU7UrY5RYrIQlrtMmKOp6NswU1Sy6G0zZymxgp3kUHFQ2LhLd7tGTVkyovAAapDZgdh5EgI9K1DpM222kSuaBwYqxaiTMTvosT/Q65S+d0vysptjFp6hftky5ercHuW+1uTRWPbYvWtNfQruUqfgsre2Tdn0R9Vbtzybt0cScF/RacIo7X3E026zn1rVfHBuT0sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDt+nXEOTCJBhjQ6spy6NmITLWXPfpiSvwx7MBN9f3s=;
 b=cZUCHAtqXK6TGdmO3Pdx1sSkfQOXHq5ooYUm/+VfUlEW48B3gwBEKOaDrlKHQYHIwKg1Omwq3czeLtQw4SzBwVg86GsD6DdZq9cnoHNuqTZwUIag7dZQVAD+chrvfnonU9cVqoIBAwpknKpIeBFqsIx4b67PCrVfC/zbDWJGEkICjSdWp869O6oLwI/pzqALz1waL2x/ISuB3t3FI6fmBtdIPpGGo26eCeiqzrYbNAkPWhLs/cMy4oxuQj13xY0iNxVjAxfU9OZj2Q15gMGhPCVgvGDIS87Imm3VKhm00kWN9kSPEipCW5R8b85uxOADjPEdOhK1BpCaL71XF54KDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDt+nXEOTCJBhjQ6spy6NmITLWXPfpiSvwx7MBN9f3s=;
 b=VMmGyORlWZNdU6NnjFMViQmKR2dRTMXCzMeQ474hoSnHs4fI0TbZQyHuMKSvEKSbtS69NbptGim4hGjVVnEy6yKp/ha7mSzwAOBHhuokW3UsZYp5GcVxwOQEsmN4lWpZSlHSkoXgqcq5uH5uORdXINGqZifOAJt854IVFw+EPZE=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.26; Tue, 29 Sep
 2020 19:39:55 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 19:39:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Radu-andrei Bulie <radu-andrei.bulie@nxp.com>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 devicetree 2/2] powerpc: dts: t1040rdb: add ports for
 Seville Ethernet switch
Thread-Topic: [PATCH v2 devicetree 2/2] powerpc: dts: t1040rdb: add ports for
 Seville Ethernet switch
Thread-Index: AQHWllQyl+0N41wVskyCvsQrZKm24ql//B+AgAAH04A=
Date:   Tue, 29 Sep 2020 19:39:54 +0000
Message-ID: <20200929193953.rgibttgt6lh5huef@skbuf>
References: <20200929113209.3767787-1-vladimir.oltean@nxp.com>
 <20200929113209.3767787-3-vladimir.oltean@nxp.com>
 <20200929191153.GF3996795@lunn.ch>
In-Reply-To: <20200929191153.GF3996795@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a89193ea-f94f-4d66-90ee-08d864af7103
x-ms-traffictypediagnostic: VI1PR04MB4224:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4224397FDAA870C4F8688406E0320@VI1PR04MB4224.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q6XNwCuYnl2XjxiKrRHvbn0uWtIAwt5XTTFNVvEE30NWFEbnLTGqIZ9e3dC8w/x0EKipikosvt47lE8wsuvdqIYwptwGIweXAOOzscclmRXaji5IKRk1LkE/GL36NSwXYJ5/BtG7+gGiLn5lbjrcXiDur7wdB7av1z56Ief/6Nveb6Y1Y7paV/0RmHVycz7ZmGNmohI0d/rXIBsK+U0T96xCmarfjlrrDPktcypDaJjP1HvfBeegI+jMVmT/hhjspkOabPqRGA9LNotqGKb720n11WBdEMkQ2cWZYpn/s1JUN40zL4CvzqrX46KwmQePi+9lnDPJ1ZffpZzsNhP3So1roQNvZgAyOXUqSkIuMq/cXEoNE4vBFlAsAk7AZDQw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(5660300002)(66446008)(64756008)(66556008)(66476007)(66946007)(91956017)(76116006)(71200400001)(33716001)(1076003)(8676002)(316002)(54906003)(6486002)(44832011)(8936002)(6512007)(9686003)(6916009)(7416002)(6506007)(4326008)(478600001)(2906002)(26005)(86362001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HN4vyvOtYMvhPMYCQuK4UfJjxZIqDnrNE5pE4Tii/YDaXEKnSsPediKKqHB4cbTg/kynsZjAVRD5tNdwhswLcYHXo6zFfytmW44ZScpQESSYu2ehf9UhdSuhvdIKaILqyIklofFgPTGH/px8jwhAPsaO3aR5XQk5G43Cfso7iKBnvLUrtgoJfrl6yLHfvM52MzjYCBevFOn/DN7pGx/PUBwKT2fmPE0jBclOw9x2Fy2oZB+kqiaBklNWEP+YFCyN/KqxfuW9ZdK0fFiD3grjb6+P06jFvDoZCiIO2wNrzl85Sq5K1hzF0Hsly4WTpjvYQU/uq/FKq1rbPpQUKxfn3OB0sFLcv1Pa+sDiN9ZKfjUNLojsAbAEmkmTXpqj1bpcvw1IfUFyoYOZisQTepRya7n22AFLyNWBfvbKMXn93eqQOdawmQvUZML2oGYnYgzVgQsd/u0oEyoWflK9PvMp/8L+sZc1zG/iHTXUSMk4CipUs2nhRlywCSovzgwvDJxXkkvWtjETkLTld5Bg7hBoatnyvZHq64p2IsKiAxnhrSmidsJmGvKl03jltrp1r8+3lC0iXKk2Y2xSExLQP27MjQAHQHhGI+dH16P3gHUHPFQWSyLwOTttQnvwmuKrCMf5Xi2ylLps0sxGiwPBaqC/Mw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9F50CAD65BF3B4481F1F5CDABF9EFFE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a89193ea-f94f-4d66-90ee-08d864af7103
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 19:39:54.9899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +VuvM7A+KXGYzB66I7FbPbULSVqIhBf2GVTz7riQHeUPpcWasUqxjhAC8cVkg3ljcFgFnEZ0XoCdL5nMeJVffw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:11:53PM +0200, Andrew Lunn wrote:
> > +&seville_port0 {
> > +	managed =3D "in-band-status";
> > +	phy-handle =3D <&phy_qsgmii_0>;
> > +	phy-mode =3D "qsgmii";
> > +	/* ETH4 written on chassis */
> > +	label =3D "swp4";
>
> If ETH4 is on the chassis why not use ETH4?

You mean all-caps, just like that?

I don't know, I never saw an interface named in all-caps, it looks
strange to me. I understand that board designers are typically
case-insensitive, and that's kind of what my problem is, "eth4" is
clashing with the default naming scheme of the kernel and I also want to
avoid that. All in all, this is a reference design board, I don't care
too much. I've seen the "swp" convention being quite frequent, and I
thought that would be more intuitive. I've been using the same scheme
(the switch ports starting from swp2, corresponding to ETH2 on the
chassis) for the LS1021A-TSN board (arch/arm/boot/dts/ls1021a-tsn.dts)
and my users haven't complained about it.

Plus, it's not like the dpaa-eth (standalone) ports are named after the
chassis labels. Freescale/NXP typically ships an udev rule file that
names the interface after the associated FMan hardware port (for
example, the DSA master for the switch on this SoC is called "fm1-gb0",
and it's an internal port having nothing to do with ETH0, which is
"fm1-gb3").

I think it's a bit strange that the Rest Of World doesn't allow
interface naming via device tree, on this board the switch ports are not
where the big interface naming problem is. Although I'm not even sure
what to do to not increase it even more. With users being used to have
ETH0 going to fm1-gb3, maybe naming ETH4 as swp4 isn't the brightest
idea, true...=
