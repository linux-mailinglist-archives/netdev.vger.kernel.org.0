Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520B11AFF97
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 03:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDTBmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 21:42:53 -0400
Received: from mail-eopbgr50043.outbound.protection.outlook.com ([40.107.5.43]:36737
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725949AbgDTBmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 21:42:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMhLtK+/L6QVmIAJ0YSI/FbSRTlUZynaXFNiMj/JogwaeTAeLaaT//GeBnD+YLWVO00Ukhu0ZTy0rBzlryWCFmak7JV3ZIIWHRaj8zMxtvHyg76dTcYM7fXqqxDbu0K2E7ZRzikGko3uoJQWCnaakjXZVBxlq67OK+S10QQH1jerPit17/9W0yXBG3t0C5AoD23/CgBvOPoQrCRUXjvqZtbtvIMs0Ht6r2OUx52tVjIosbkRp4I3ocmyXVHuNZnVPmLwT4tgoT9kD91UPQ4zSfKgDseoVgPXtMcmR/vBJcAhzDQRoYRtq8hE4yEMbSsxGPKw//AfsfgLilOvP5H7kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x36cKQCPXtRMZTsF+xgxpO4uZE8zYXqv0PNdyAIu/Do=;
 b=FEFP7BxmK+ttBykdyo46xrHPSznqSFmswA5j9iHvrUnh4f5mNYm76wmT6xQqTwmmc03OlvqAMAaW2H6qIAdm1fIYbuJBw7OQ1sxWHEcOl+Wa9gzBFx1+RpZCK2OOEbLGd5La6y59bBj1ccyflcQXc+DSFqGTNxCl7Ty5ACSuOx6UlkbW8DT5R5tEhqvFBW5LFb4fXvEdq9nhjlsZyJ3PGiOVb5mlo2hT5uBSiwi7sANL6bsrN1jtgw9ioMst4QLXgeHJ/KIlLGgAd7amrA+dE0IfwXfYAs2z9C7Ff/u13xjAMSYOnq8rap/ql+RJOn7Wj2t7OPeTx8QvLxCkD0SVjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x36cKQCPXtRMZTsF+xgxpO4uZE8zYXqv0PNdyAIu/Do=;
 b=fStx4eb8VRM7RcbK8beAaymLMfyyYBDUx7KA9tNf+6nvTLojVOStItYr7mvCGrqrWgbKDBK2xJ3j1B1bIponO/xU1ENDo4PcFM2JfBRzuSgIlApvmQImMfyglKbXYE9yOIgqD5kFpVyQhuTHDmQJUyh9LGcJnV6maCRf5SyFgoU=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB2842.eurprd04.prod.outlook.com (2603:10a6:3:d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 01:42:48 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::f9f4:42f7:8353:96ad]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::f9f4:42f7:8353:96ad%3]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 01:42:48 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [EXT] [PATCH net-next v3 0/3]  FEC MDIO speedups
Thread-Topic: [EXT] [PATCH net-next v3 0/3]  FEC MDIO speedups
Thread-Index: AQHWFpaHtvdPe5yhakmidXyEIz3kzaiBPHow
Date:   Mon, 20 Apr 2020 01:42:47 +0000
Message-ID: <HE1PR0402MB2745765C4F546A8395FC09E8FFD40@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200419220402.883493-1-andrew@lunn.ch>
In-Reply-To: <20200419220402.883493-1-andrew@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fe3daf65-d353-45e7-bc76-08d7e4cc215d
x-ms-traffictypediagnostic: HE1PR0402MB2842:
x-microsoft-antispam-prvs: <HE1PR0402MB284263968E67EA252C770960FFD40@HE1PR0402MB2842.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(66556008)(8676002)(66946007)(66446008)(6506007)(71200400001)(8936002)(9686003)(66476007)(81156014)(55016002)(7696005)(186003)(4326008)(64756008)(76116006)(2906002)(86362001)(52536014)(478600001)(26005)(54906003)(110136005)(5660300002)(33656002)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t89BAu62WtnTTwIEcOh9Odc42skqCD7bLAT3m8X3pA1O6KCrBAOWZ+S17m/WIbZDOu3rHUzyoDfQXnCrqu9XVJEkLpElpErCSf4RntM8P6PKMmrnxqh8+Tpn5jinb3K/WbbMhYQdHfcfyClA+684qC3gt8Zr5qAA47KjP9jOmjuHdTauV7q4n4fR6+IQ9k+qxVCr/2GQRI7ajq7BtAcWsR/Zb6FzVHPhWon4DrKMeEbbrC6o2RpxKC3byOUwnlSjuKnHq43QnooA8sFU1Ob5bzt8MhuA0uKXMRNn8G+nhmKLiQIsNWgonYNJx/FoShmN7EziKaTVHTf6olj+wf1alnI2ehNwrOlTqmug5/L6iz7o46ub6pXTnDGO3EmZlOxcGVLb4DfK3MR2tp9nDTX+EUe+0aZiDsVEIeBObJIQkrlrXjDB2cBdHZVCPZTK+bTF
x-ms-exchange-antispam-messagedata: ZpOpBC4yNtNLkK1xIe5CdFAajDvY2rxO5A3BlKswxbQnokZlPnOznofw+5X4gAtq3WYQrAEGn63yme0uD34yxlEfBX9qVfiv9+0mq/wxBbGOeKPwBb2DB651urByMuB+PsPyp4blBFpBLJ4i/Fl0nQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe3daf65-d353-45e7-bc76-08d7e4cc215d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 01:42:47.8378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Vmp6NTZwD6acn8yIxowkAJIix+pF3KPoZylwN6ykhdgBACGifBfwDubGXNuVnDfQOkDV8jtW6Y8V9JqhA1C9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2842
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Monday, April 20, 2020 6:04 AM
> This patchset gives a number of speedups for MDIO with the FEC.
> Replacing interrupt driven with polled IO brings a big speedup due to the
> overheads of interrupts compared to the short time interval.
> Clocking the bus faster, when the MDIO targets supports it, can double th=
e
> transfer rate. And suppressing the preamble, if devices support it, makes=
 each
> transaction faster.
>=20
> By default the MDIO clock remains 2.5MHz and preables are used. But these
> can now be controlled from the device tree. Since these are generic
> properties applicable to more than just FEC, these have been added to the
> generic MDIO binding documentation.
>=20
> v2:
> readl_poll_timeout()
> Add patches to set bus frequency and preamble disable
>=20
> v3:
> Add Reviewed tags
> uS->us
> readl_poll_timeout_atomic()
> Extend DT binding documentation
>=20
> Andrew Lunn (3):
>   net: ethernet: fec: Replace interrupt driven MDIO with polled IO
>   net: ethernet: fec: Allow configuration of MDIO bus speed
>   net: ethernet: fec: Allow the MDIO preamble to be disabled

The v3 version seems good.
Thanks, Andrew.

Acked-by: Fugang Duan <fugang.duan@nxp.com>
>=20
>  .../devicetree/bindings/net/fsl-fec.txt       |  1 +
>  .../devicetree/bindings/net/mdio.yaml         | 12 +++
>  drivers/net/ethernet/freescale/fec.h          |  4 +-
>  drivers/net/ethernet/freescale/fec_main.c     | 85 +++++++++++--------
>  4 files changed, 63 insertions(+), 39 deletions(-)
>=20
> --
> 2.26.1

