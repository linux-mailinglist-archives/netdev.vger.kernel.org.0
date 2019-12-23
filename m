Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8ED1291B4
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 06:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfLWF4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 00:56:25 -0500
Received: from mail-eopbgr30069.outbound.protection.outlook.com ([40.107.3.69]:1255
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725822AbfLWF4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 00:56:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d24SnqM4U/BQrnZyJw8RpJ0t7XXvZ9b0FJTzkOHUaOVQUXN1bsfS+L//GggzdxeU4l54Xp464OcJj351r+hgkI/jYnbbh9Cn7IG7DuDLKBMSS+Px1bwQ2A5dMqBLMk0swnzP4e5IDdm916pWusRYum+l8kVzVqd2HRNK52SNsivGtgZmkmU17HC7A2Ebqk/Kf379uIMM4H9N3IrA4+nbTfYj2rlhqb9l0/drV0zBB2HtyprUhNMsoKmwWT6mdEfdGuHfKIdSyTfyb+A7QBdDTAdOs8NAhl/Gjjcjz9U7ds6Bt8w9MouPIshBydthuRXBVwfHUUbqFtFHfPN7oIi2DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLfLrfJVSBeS5oUrfNYyvvAVGA86kf8gz/D9bZz8fZw=;
 b=XWNXQv5thtW5zseOQBVCy0VZG67eEfEXFAGI25lna3sJ3FT1aqRdnkoxqYJ6HCQQbqU5zSVufNxCAWq6z7oliGQcGZaDQ4AmWiNrMVG6PwN6u8Ch2WQG4QTIJ6BPeDYRKCH1TJRm4529jqMQPvvj41qY++4s0Z5idPO6YznrbwNNcbDp7wlnPkHXn1Dng9nRcfetWawdh0V1lmzN+mHdG2/aC9fBRk3G3zb9DajRcVTDcC+sHOc1D+JGyKletWjE11hHHdh1ZHlZAx2V7R1RySOEBsya3ceaW4BceuCYGzi3x11mrzLw9pIoifzdND7FCL7wzFxtL9RulyjdQJ2brg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLfLrfJVSBeS5oUrfNYyvvAVGA86kf8gz/D9bZz8fZw=;
 b=j1ztL5lZmI6WtiAd4yN6Cs/9DPbyn6dqODnE7W0KYI6i1oB8N50VRf5Pg+NSejKhx+Ol4XoW6fiotFBFTFRI899/ANiqh3+pcEJIrS4+y/9q72+tGItwWB4nIVyK/POSvi936y7vIzCndclW/55p/aorWwMMzr9hNwVbyUgCiQ8=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB6207.eurprd04.prod.outlook.com (20.179.28.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 05:56:22 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 05:56:22 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] net: phy: aquantia: add suspend / resume ops for
 AQR105
Thread-Topic: [PATCH net] net: phy: aquantia: add suspend / resume ops for
 AQR105
Thread-Index: AQHVt8CYiezceBuDX02DezRiEbiWz6fHOH/g
Date:   Mon, 23 Dec 2019 05:56:22 +0000
Message-ID: <VI1PR04MB5567DDBA923035402CA267A0EC2E0@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1576765022-10928-1-git-send-email-madalin.bucur@oss.nxp.com>
 <20191220.213623.2272694380359701966.davem@davemloft.net>
In-Reply-To: <20191220.213623.2272694380359701966.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [188.27.188.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b150d6ed-5a86-4281-df90-08d7876cd6b7
x-ms-traffictypediagnostic: VI1PR04MB6207:|VI1PR04MB6207:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6207E87DCE173702951209C6EC2E0@VI1PR04MB6207.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(13464003)(189003)(199004)(26005)(66946007)(64756008)(52536014)(44832011)(33656002)(76116006)(55016002)(15650500001)(66476007)(66556008)(66446008)(186003)(9686003)(110136005)(81156014)(81166006)(53546011)(6506007)(5660300002)(316002)(71200400001)(8936002)(4326008)(8676002)(7696005)(2906002)(478600001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6207;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pG6H6pa87lQhZQEcga/xmfJFjIqLFqh/QHGpcecxA0/7uXZI+wzLwE+HdoZ7ohJdTQUrEc8uHbLJxqsCYcQL3zHGJlGDAF+mFFQrC7mUQDiznYbd+7js/EbfbgLR3l+beJ953shuaXsyl4lKxWani3gUAtSjjPN1RvPaeppaLCBkPEwZ+IV09cEQU8yKgYswSb7zjTrzfsi+m/8EMRkqtuVKGM/trQ2TEbKPTPKYrDPubd+Rg6y9QW/T+MOxR2gdX7NYj7rqmOCSFJhJXo56bWxY6inicm3/vu/9bRw9I2OGhu2eV2Dt0KhhFsd16VNzz/ujp3SFhqEB5KgomrneAW0Cev1qhFFoCxhzBjWJppfWKkSEl1L1RJf090ojqhcPDNa6qs8NXGsNcWl7v/gECHuf5tlmR+Kr8qRJ6WzWuWPNaEe+JSd9QdvauyQdov1PJlHadqcdnwmB+U3tbba0P5tDRBUHFmWpCb9EJjy+Uy7W08e54+dyxTfONoAPnbFk
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b150d6ed-5a86-4281-df90-08d7876cd6b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 05:56:22.3047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Z6uzoeZdyTPseWoFDjrWedD8TA/3ban2HGhaLGn8tIQdZYH18tkZMhDkcslwjcLaDs7rarl+wYxNZauwHw0bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6207
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Saturday, December 21, 2019 7:36 AM
> To: Madalin Bucur <madalin.bucur@nxp.com>; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [PATCH net] net: phy: aquantia: add suspend / resume ops for
> AQR105
>=20
> From: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Date: Thu, 19 Dec 2019 16:17:02 +0200
>=20
> > The suspend/resume code for AQR107 works on AQR105 too.
> > This patch fixes issues with the partner not seeing the link down
> > when the interface using AQR105 is brought down.
> >
> > Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
>=20
> For bug fixes please provide an appropriate Fixes: tag.

This fixes an issue with the link remaining on when the interface
is brought down that was there since the support for the PHY was
added so this may be a fix to that initial submission:

Fixes: bee8259dd31f4 ("net: phy: add driver for aquantia phy")

or it may be the commit that added suspend resume support only for
AQR107 although it applies to AQR105 too:

Fixes: ac9e81c230eb4 ("net: phy: aquantia: add suspend / resume
callbacks for AQR107 family")
