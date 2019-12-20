Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C3612785A
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 10:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfLTJjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 04:39:12 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:43520
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726111AbfLTJjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 04:39:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fexDySnz+QZT+5KuEDTvN9SreNC9uZjC93p9uYd151FchMyUROO16+rT/svDOkWLXv36E9wwJnDSo7RNYuV2V7wyJCP57tQ1GVbPFmlVsK/l4M/A6cckbMrX6nUr6rKEZYIrPZSfdqenrW74DPXtbCJodZBj2XZR10kF4Bj6Io6/qnvAlKQtpLum1ewgOrsVrYvbXD9pxPYNm+3tiZ7R9I0CQ3/5ObPVAM//+yCbr5Ev9qj5Tprof59OfzlVBJ8OzTPfnYVZcvg4z+ejBQv5VQjlbk7IoNwpxm1UFD74VXVISWQQJeJbyTAyQrmTkTM1p7u+Ym5Qc+QADDTVAUDN7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CAAFYFDP2+QozJPfRl85bi47Z1lasQEbImzTIYJm/k=;
 b=QltYB/XW1yU2cTdbpF1UIOuBl6RgK4oJLMabGNB0rlGFwXbZOQsb4aILK4kb1IR1VWhMNQYtvLKs7CqeGvsFRgS26JyGKEZfAp0POGUpglyzVQUqOb9pZvyVkjLmUrUykhBgDYhHD3QTqU1O4klcxFceWGavpNFSSFLZiYNYJqYSyW1ZvOpF87M3xZllnIgq5OBrD48okDmXeLbVLae1RMlBXP72f0+98UsJDDym2kF6ffslz9rm1RJOP/ATnGwqHOYpk+Fk3LgYY/zzBTSmL2m5qvnCK9MFYowaa8+0zIzdh0Nn1+E/3q4WBjPKtWssZFY7ekhWFP/sg75ICyY9Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CAAFYFDP2+QozJPfRl85bi47Z1lasQEbImzTIYJm/k=;
 b=APIcLVHHoLlrlERPUNYPnj3c3xB9YejbyrYpaxguQDiqNhiRnw/r4UvwRaV4OcKf7vCw+tHXiVgnZkIarwF5UDLv67re5Rth677tLKpV0QFPbpFG5WzNNQAsj1Lm6mfPASkFn4Nv3CUO+GJMKyOFLAejMmY+iKycwTyx9MIEaH0=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB5519.eurprd04.prod.outlook.com (20.178.121.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Fri, 20 Dec 2019 09:39:08 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.016; Fri, 20 Dec 2019
 09:39:08 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "antoine.tenart@free-electrons.com" 
        <antoine.tenart@free-electrons.com>,
        "jaz@semihalf.com" <jaz@semihalf.com>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVtn//emqdPRPEmEKC7Ncoej9h46fBtnoAgAAR9oCAAAh2AIAAKmuAgAAEEQCAAKSigIAAG14AgAADcACAAAJs8A==
Date:   Fri, 20 Dec 2019 09:39:08 +0000
Message-ID: <VI1PR04MB55679B12D4E7C9EC05FE0D9AEC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219190308.GE25745@shell.armlinux.org.uk>
 <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219214930.GG25745@shell.armlinux.org.uk>
 <VI1PR04MB556768668EEEDFD61B7AA518EC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220091642.GJ25745@shell.armlinux.org.uk>
 <20191220092900.GB24174@lunn.ch>
In-Reply-To: <20191220092900.GB24174@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66cdab82-b186-45fd-4623-08d78530762b
x-ms-traffictypediagnostic: VI1PR04MB5519:|VI1PR04MB5519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB55194614BB92883EF6DE54ABAD2D0@VI1PR04MB5519.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(13464003)(199004)(189003)(9686003)(55016002)(26005)(5660300002)(316002)(7416002)(52536014)(76116006)(478600001)(110136005)(54906003)(71200400001)(4326008)(66946007)(66476007)(66446008)(33656002)(66556008)(86362001)(64756008)(186003)(2906002)(53546011)(6506007)(8936002)(81166006)(7696005)(8676002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5519;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W2jWzit+E0rlguI3HoP3SxVAv+ygE2DeubEvxAZLyg1L5XfILF4/oA2PhVrP8gRNlN4ziCVUhM9PZBHv6FZTzmzc++f/bjEGGJIRcgtMXPSANgWflXy0nMxriZkzdyezjhuavzCp7WjjZAdS6awxl/ZotNjUAf+dzlExtqMDArc1/cPfASGc6MyoHbQYvpfEGqJHjXO4+WhWOCkYYNi+tZSYo2QFzbN6N1sa7okhfRxxNGzdUaOx5tfxjuE/IreCriWYz5qK18nBprAco9dpqLzStUNrXqpXXaoS57BQcx9Vc5uaaBxdlPa4q+wozVvcSwAET63kiFODGitkhq7kpIc6MjXGFz9yOMtQATkMxT5/Z4aH9OyK5ROeGUECUBN8Px7SG/uXPLu+hjerPG5ULQe9b91GaHjJoR5wvnpdRIVzhnpVlzFQE0xXkIte3SYwGO+wrP1aH05ESixPputwdRTJ2oXpjZot3DOVXtmkEBVzdx91n/Hj30TagcpxuBQy
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66cdab82-b186-45fd-4623-08d78530762b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 09:39:08.2537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nbsr1zh0w1YZDirjobHpkdlp/VbiEFfDc7FW8j0LWiZyy0dUM6tz+WyZoT9Ax6W11NL/Xk4WqjPAP43Chffz/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5519
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, December 20, 2019 11:29 AM
> To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; antoine.tenart@free-
> electrons.com; jaz@semihalf.com; baruch@tkos.co.il; davem@davemloft.net;
> netdev@vger.kernel.org; f.fainelli@gmail.com; hkallweit1@gmail.com;
> shawnguo@kernel.org; devicetree@vger.kernel.org
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> > How does this help us when we can't simply change the existing usage?
> > We can update the DT but we can't free up the usage of "10gbase-kr".
>=20
> Agreed. Code needs to keep on interpreting "10gbase-kr" as any 10G
> link. If we ever have a true 10gbase-kr, 802.3ap, one meter of copper
> and two connectors, we are going to have to add a new mode to
> represent true 10gbase-kr.
>=20
> 	Andrew

Hi, actually we do have that. What would be the name of the new mode
representing true 10GBase-KR that we will need to add when we upstream
support for that?

Thanks,
Madalin
