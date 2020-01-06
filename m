Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC633130F48
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 10:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgAFJQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 04:16:44 -0500
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:24898
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbgAFJQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 04:16:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDcHJ7cWx+HJ4I+H4fQ+hRNPBg1TlZGspKwpPVA3EIhj+eRUyCMlETWQNfywWQ7NQUpyx5Zkv0LsxihG9oVBPjTTgx+yKIbL5uJr4cIVERK4TrEBUItetVgYDfCAIvp+qifKL0B17Lz6xquY9eol234KDJwC5VvGkM3tQlqB+KCBCbzndwH000Kwp8NXxUsD/VKW0Ibr2eKDssQgeV0tQK2NiOScFQyl1dyS/QRZrSHWHmS5f+H7yLyBPAsVp6hr6sNkAsjlYtyOAYGEj7Q8ajCwQkmaKb/4MEcRJv8w9iQpbKd11YtyK8HxnhQeTI2W0O3lFTf2Oy1PWELosBksyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tv/BzuUXPdsYm1fS1Z7aqY8AiYxcVcTveiJ7OSibLiw=;
 b=dBq5DJFJ79032xXBJ47Ct0rnTBRbpaPttbbeMDBNFJP0YpS1PxKTRpK6ussNEdp7pY+nGTiENmUUTvxoIGaJuL+DlaEoNgYe36lxdIjBK408qLqXLord61Rfz7esT/1hSz6fsY6WCM+HvxeEBzyDrCmihP6kNPWkdASvjhRtGeagKVZLFBJPoBRYYn69QZpxcUiPLMq0hpg1aV8lZXUWHdQfL9/aESjsYwVf1/2UA/Ky7cbY5sUsJ72AMXpV2n0esm8mr9nxAznAAcAEpoMGdXyhZ7qVBtAAVW/MCXwtuFmvP7BUdAxSxdWBrbnLdLLiipYoRcB15vNnT8RG4oHgBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tv/BzuUXPdsYm1fS1Z7aqY8AiYxcVcTveiJ7OSibLiw=;
 b=W31nvTwVgxt5eYSmfb/ly+irars1OFnCt1O4P3lcUEpYlHAjuAJWzyEE/6fZBPtKSZLNPiF0dY3ycqSzXoVYV/vDoMnJk1L2WLzPr1KOPDMxuEgx183mcCrCby3jKgYvBvOp/SS5+gPP3Jaj0EWO53y4z2ojVNcv3iB67S3BybI=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB5867.eurprd04.prod.outlook.com (20.179.11.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Mon, 6 Jan 2020 09:16:40 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 09:16:40 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] Fix 10G PHY interface types
Thread-Topic: [PATCH net-next 0/2] Fix 10G PHY interface types
Thread-Index: AQHVwiwrxFflOt73iU6BRITH1hAO2KfY2OpQgAAj3oCAACKCoIAAB2mAgAQ2asA=
Date:   Mon, 6 Jan 2020 09:16:40 +0000
Message-ID: <DB8PR04MB6985B617539D2E909B30822FEC3C0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20200103115125.GC25745@shell.armlinux.org.uk>
 <DB8PR04MB698593C7DB07A82577562348EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103141743.GC22988@lunn.ch>
 <DB8PR04MB698518D97251CB15938279C3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103164745.GL1397@lunn.ch>
In-Reply-To: <20200103164745.GL1397@lunn.ch>
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
x-ms-office365-filtering-correlation-id: efc8429f-8a38-470f-38b6-08d7928923d6
x-ms-traffictypediagnostic: DB8PR04MB5867:|DB8PR04MB5867:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5867681D8F010CA4382231EFAD3C0@DB8PR04MB5867.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(199004)(189003)(13464003)(9686003)(86362001)(26005)(53546011)(2906002)(4326008)(110136005)(54906003)(186003)(316002)(7696005)(71200400001)(8676002)(81156014)(81166006)(52536014)(66476007)(66946007)(76116006)(66556008)(8936002)(66446008)(64756008)(6506007)(5660300002)(966005)(55016002)(33656002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5867;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x3Ze6GHJAtz/qTxSWaXKfj6Yr/qKrcmRWhoXqptBfjFf9/E+9UlWwoG+z5019zHYohoO2CWPEmKlTeuOz/FjWRKb1VxUGnGrw7zfxxz8inlz+3Tg4ittYgpGZg0AD/h/p+8vTMhSD5meMhFZ9dG3nDLSa+h/+eJGVvYmMh5iIX5BhJ9xV5IyLn/CZ/Wa9AucFged+iIuitDnBRgLiYG8EqH4/QQC9i+vEfYtch9qMoCTOeU02IrceKupwpbEcv0gwssPpFljnTmJqotmqiM5nC100RTHtY5aJ/2zIbaDnieA5sBw2fBJWOawariXkfhoO6lGbIWLjvLBfLzvkJtK9Cm/FNYiW9wOXzzstW0O9+0mMILAvA5WPwirJFJR/QlS3d+zE9RQSYT5peDhk4WoITiZ7U9F2aEuCvUjAhKi55MyFGwwcidnrFhgCeiGN0ZwSWMufrWnfSP0973Bb1s+OA8zolduw6F9y6lsK6p7FY1EqEJB9MaZuyMi6ILwpVOhiUrd7jknTStJd/LGkXMgsui31eNltj1TbN77Hm4Eif4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc8429f-8a38-470f-38b6-08d7928923d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 09:16:40.4516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kYaBDoJ9Ajqa6TgXQI2XvrmgWBPU141vGcWX/3dsS90VxdlnstmmlHa9GFAKsanJ1pKSNsxHX5yV6Is5FwLg0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5867
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, January 3, 2020 6:48 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>; Florian
> Fainelli <f.fainelli@gmail.com>; Heiner Kallweit <hkallweit1@gmail.com>;
> David S. Miller <davem@davemloft.net>; Jonathan Corbet <corbet@lwn.net>;
> Kishon Vijay Abraham I <kishon@ti.com>; linux-doc@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 0/2] Fix 10G PHY interface types
>=20
> > And here is a LS1046A SoC document that describes XFI and 10GBASE_KR:
> >
> > https://www.mouser.com/pdfdocs/LS1046A.pdf

You need to register, unfortunately, but the information is in the referenc=
e
manual (18.3 MB of download):

https://www.nxp.com/products/processors-and-microcontrollers/arm-processors=
/layerscape-communication-process/qoriq-layerscape-1046a-and-1026a-multicor=
e-communications-processors:LS1046A?tab=3DDocumentation_Tab

You can find there also an application note on the backplane ethernet
support on this device, with a description of the current solution, describ=
ing
the SoC internal PCS (manageable through an MDIO bus) as a PHY to be able
to use the PHYlib infrastructure to control it. The code is still under
refinement, not upstream yet, but it's available and in use by customers.

> I don't see any register descriptions here. So you failed to answer my
> question. What do you actually need to configure? What needs to go
> into DT?
>=20
> You keep avoiding the questions Russell and I pose, which is not
> helping your argument. We need details, not hand waiving.
>=20
> 	Andrew

Answers are there, spreading the conversation on multiple threads and
removing history is not helping.

Madalin
