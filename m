Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E0B23A892
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgHCOeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:34:01 -0400
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:31650
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbgHCOeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 10:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B42xbLgNCaLw32qYJEDUSDBFU3/2yAVjQVvuCiOc5bNY/OFlhcD0PeDVVFQ1o/rEbR6bOg45ICbI0fXS6TqdZOUWOiOQ4DwxdGWhw2ieLoyu54noc/WeEIi9MyrNeE5EgFgP107czWbspXB4UNvu8cg6CYlNuGonIjKVJQ4jvcQeDH3twBMgciJl2RbjuEElhcDnTJa9KSLBWqxfL5fd7Bhj7nSE+r7MfK4sZVQsXMv3V8L6IdRhlBSdD0/XMoIXpWnHTbURupVCpVIRCiEFZisOolSTpom1ttO7LkVRT3mmmFB5lAIU2SbuxleHCKQcteJfOCRrBwhncXSIHyETBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZdK/DN3G4rtllubW4TQ65dP6awfSRKjOjfcBobFElI=;
 b=bDV+JfxJRrL9ZoH+nOZZVD+Wve6lqT/8zKHMw4X3FeSEMTookrkB7ugvhbAICtz3xAGekzYhnAF95lNoOQnZ8IjzC0v9mUcJwXufivhX+MtODOQMGvZimxfgLdc6xB1HlelzxfZH8frXQQJLNwGTCsxHhFfXqzIPG17F8bqPfMTky0wpLllica1rK/u1AE6looHDpbhaTLHguxKR2BfUsYwLuL83N6EMUUZd0NiLG5tYeTZKyWB3/i6ekoSOHWyYSsPbtMpGX1Zpc7hkeamr2R1aDFftnFFmRUyTIWCxvPWVcCx5srAPl5JkAAeru1UhBEX5i2g2tTVgwUVlNQpxeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZdK/DN3G4rtllubW4TQ65dP6awfSRKjOjfcBobFElI=;
 b=k1SJb9Gd2vY8/fO82f9gOFgCFu6g4oyok6T4+80TAJ9cyakddNcRTGgcVF9Qhoj3avjJ3MvQXSBgGKVcw6znWxhoKSTP5qQajEkqcC3+16rvZQ2aGOBROgaAvox/VNYQ7k4CIToeq3La3J32F7saoz/0Af7nZBCCy3zzzFIyfk0=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM7PR04MB6824.eurprd04.prod.outlook.com (2603:10a6:20b:10e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Mon, 3 Aug
 2020 14:33:56 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f%2]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 14:33:56 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vikas Singh <vikas.singh@puresoftware.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        kuldip dwivedi <kuldip.dwivedi@puresoftware.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: RE: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Thread-Topic: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Thread-Index: AQHWZNiOdpikt9xf+EiwD7SyrSwWH6kc9FCAgAGkTICAAzz5gIAA15EAgABZCQCAAFwWgIACs+VwgAALHACAACsYYIAAFUkAgAAZMOA=
Date:   Mon, 3 Aug 2020 14:33:56 +0000
Message-ID: <AM6PR04MB3976D3E9BA05AB5D4EBB6AA6EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
 <20200801094132.GH1551@shell.armlinux.org.uk>
 <20200801151107.GK1712415@lunn.ch>
 <AM6PR04MB3976BB0CAB0B4270FF932F62EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803090716.GL1551@shell.armlinux.org.uk>
 <AM6PR04MB3976284AEC94129D26300485EC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200803125742.GK1862409@lunn.ch>
In-Reply-To: <20200803125742.GK1862409@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4f8ef9d5-4030-4dea-9600-08d837ba40af
x-ms-traffictypediagnostic: AM7PR04MB6824:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB682470513939ECF62FCF2461AD4D0@AM7PR04MB6824.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IVJgFUx4nCzKRkYdPk3Qqw3EPXQV/ziOXWnMR4J76f8ocWzXoo2Rb5GCWq/nsnMGTbmY1tMaHzLb0j0amYNh/szkKJyZmMPGhdCa08YH15CfOF48J4RLEVCA//8JuUrDaDXWgEsN/mdx4VHxAN+omkc+1uij3nJKrJX2oiC9mdSBairYAtU2M0GJsS4u+R7VuEo6smlJ8mOuB82/jofR2VrwgXLAdTY9jLT4XGusgOBD6jxAsCkEystPOFMeOIrbVb2W3wyGPY9AxWMqgyMxGGMCBSXePVDmYM7bljw5Y3GA9JskzYOEmwAsTUR40biQLBgyCQiaY+FEm+j/pTgKbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(52536014)(86362001)(110136005)(66446008)(83380400001)(8676002)(2906002)(186003)(7696005)(76116006)(55016002)(4326008)(478600001)(26005)(54906003)(8936002)(66556008)(9686003)(66946007)(66476007)(64756008)(6506007)(316002)(5660300002)(33656002)(53546011)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /sX+sSeKMWagIlwRGiC/ZVuXKPEVQZQl+DAOetJxQTi5GNGXdurIGyMTHupaK3AbArhSWtAualwOtinHd0hHIzRoXUdJmv8/XLD32tjJRih6JI79ZB0U3I+B06pGsqWWfQYO1l/UO1j8iZj5WyMjmcefdjfjeFpouHY5nKCPsVo8ABLcf9s9DvUTbHBeOAii/bS4nEDvT51s6Upw9AxDOoonFD3V0UknlXOYFGWF3Lvi/eMOfLSn78P4Xa4KeO1jpy4GBKfHvqWuf8h1WXSglelSJj9X4o4kollqRxjv+Zddu74dFLtOZ3CF5VjO8tU8nGvnE5nI3sv5z9y0OKocI8oo1PPYjUR5IjEeJHiMdJlpz+Vg3j8E9Pd5Leh9DTH2L3zTD3bv/gi+WaBIjgqpcGjVZwZ9hjgwetBXy+fh6lFiVCNkBOniS0dP+cvXqUD2J6u/aLypywICgH7N3hBuZWpcpAtgchpp23l0v2DE8nEuUWiqrKsC002351s/EeajC9GUDcIfyTQe2Ofjl9U6X5xklyQFGiguJHRRotU9CVnn6s55OpKntGpqhIVGSKUmisEvTOhWNt+RqifR00XtPhzzzJKdLNihrkCIzBiOriEm0U/qGTlgW20mTwBULRs0K07rHJ3tClSN4+MlJflsBQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8ef9d5-4030-4dea-9600-08d837ba40af
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 14:33:56.0719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mOn8Jhcy/HpTAtaqBizvVAtvBjYLK+JEo5aMt3P5Rdq/vRIYKO0xyDgTieZ/FDIfpKEve1lZgmIkNpMW2pC5VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: 03 August 2020 15:58
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>; Vikas Singh
> <vikas.singh@puresoftware.com>; f.fainelli@gmail.com; hkallweit1@gmail.co=
m;
> netdev@vger.kernel.org; Calvin Johnson (OSS) <calvin.johnson@oss.nxp.com>=
;
> kuldip dwivedi <kuldip.dwivedi@puresoftware.com>; Vikas Singh
> <vikas.singh@nxp.com>
> Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
>=20
> > I see you agree that there were and there will be many changes for a
> while,
> > It's not a complaint, I know hot it works, it's just a decision based o=
n
> > required effort vs features offered vs user requirements. Lately it's
> been
> > time consuming to try to fix things in this area.
>=20
> So the conclusion to all this that you are unwilling to use the
> correct API for this, which would be phylink, and the SFP code.  So:
>=20
> NACK
>=20
> 	Andrew

You've rejected a generic change - ACPI support for fixed link.
The discussion above is just an example of how it could have been (mis-)use=
d.
Are you rejecting the general case or just the particular one?

Madalin
