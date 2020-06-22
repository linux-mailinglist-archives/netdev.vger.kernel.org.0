Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690C3203354
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgFVJ3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:29:21 -0400
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:12167
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbgFVJ3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 05:29:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJDSwwdeW/GiUBxbkMqROkCb17CqOFYa4ksxr97vP1i6h3EqjKA+gntcHezsq9EqGBbXJF5cfTYVER52x6JXTKhloGfi/kZEWrax4nNA/yGsCusJQxT15wTQxatuaXxY5SogDwo89M196k7CDO9wAM4b0twowpAMvcu+NoHKGz8y0f2164xuIqsQMQTFd6OiQOxGh4fVkV9K/1b+MZjg79iAMmWmEIMdQ+TV8Njjj7MsMFUHUzTBAwReQjfEV8fD6od1X50Brv3QUJnOFnkdDHqGc4jtaf7oL0bC/jdQy2HfPWGY97v3ACBYX1Tn6vgA+NDoJHdQmW0M9fRmpMTQow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4b9h0+8201yvNAmicycnwo79X7bSPnPBqhqbQjoyiE=;
 b=FXTEAdsAO+FnCFw21oF084tcMpRneP8zHiJmzBmon0vJ2Y/wmi9RTuweFHAXL0CMg6bYYlvpdfc7II/pJ76ZraDRVaubcikOWvEpgydQjGwK/rJCgY36dLDfDDlolx/MC1iO5juFTWVIdKcvVMBGUN7cWHhqlSDt1zcNLOmfVHwzt0JfUoq+pcGyPVHxD+JN8yvdDyx93CqzWpEjpI6+eKLqJ7oRGvoM6sC6NB2Bh1Dd0gnwGw2SJWO/c0mQ/t84eQuGTvKy6ytX6x/jaULGT0SWnVAxquHMS3DHFR3g48sjASfzsuYDMgOR9z1MWDJWqu1y/OHSBxQ9/HOkV2azfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4b9h0+8201yvNAmicycnwo79X7bSPnPBqhqbQjoyiE=;
 b=kuJPk+L3WgGOXd9rfszdUVjciw++NJrTuQOqfmoO2LHQDleWZ0BEAiTaEGPJoMCrb2U+NgHnRSoP+f1PgH2Bp2S1RwwXFPg/pBb7I8qn9QqpBjtJSC6bXXMpJET490y50GmIfL9hTeNraAa2cghsUHzFGZFkUraiNtLkYd3BHx0=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB5989.eurprd04.prod.outlook.com (2603:10a6:20b:94::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 09:29:17 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::8576:ca02:4334:31a3]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::8576:ca02:4334:31a3%5]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 09:29:17 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "linux.cj@gmail.com" <linux.cj@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe
 c45 devices
Thread-Topic: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe
 c45 devices
Thread-Index: AQHWSG3yqYKmzQAQL0y/c09AW7YmXKjkXZfg
Date:   Mon, 22 Jun 2020 09:29:17 +0000
Message-ID: <AM6PR04MB3976D2F9DFD9EE940356D31CEC970@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
 <20200622081914.2807-2-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200622081914.2807-2-calvin.johnson@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oss.nxp.com; dkim=none (message not signed)
 header.d=none;oss.nxp.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [86.127.220.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5372d184-efaf-4cd5-c932-08d8168ebc54
x-ms-traffictypediagnostic: AM6PR04MB5989:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB59891B66CB99CD27F218C9C5AD970@AM6PR04MB5989.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0442E569BC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b922KuL9sMHtGfoXKl0qUwMAc06ejhNIgcDFI6MgKwlgMcEjRn7HFhyBGeitWsmPOtMfeZ+P0N3tLEC1c02Nt3OAfQW2CqyWL9056SRUftOTcdg6LGvSgnFbvA0OR3+Zk7zxjFlvMcprggcKp7YKZPIeZT2UZzqVwdAnjk5Ir/UIRZcKxewGNDwyFrymDhsPuWFjizj+YNx3cmQq8fYn/duWcRo//WdMh8757TYxbfPIHc4Yv0bwqiW9K5/ySjZcj+wTt6pn5HWAyX9G766cEdTQ/14P2zXkKNtHu3j6dW6Mydhf6U3kOYgbfL80i2aOtL+OKyhkc3Ac12hMIOeffW9jAlIII/U6fL6nAKXvL++ErUglYwkJGjyvCbdkAEfb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(66476007)(53546011)(64756008)(66556008)(66946007)(8936002)(66446008)(55016002)(9686003)(83380400001)(8676002)(52536014)(316002)(110136005)(186003)(54906003)(2906002)(6506007)(7696005)(33656002)(5660300002)(4326008)(71200400001)(76116006)(86362001)(478600001)(26005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: z3J8uQoJZUnIEo/1CXAC2nFCRuhxx2q/YVxfAqAYd9QNaBRRyl6KlO8l50R169nCPRKmXF0oXMoPNpJcTgIh4kBHzb4+iVYc1w3iCI46gWMBpbEZJGm2BsyLBkCYe1BwQ/ECvvcKPXAVQfvaPcZB0AO1krRhBf2nwYu0dNpUOjYrmWIOKrIMKnpfd98EJMnATxK7uFzVnaMiRrxjGt8V3I6UEYjNkbCU2Xw9hhHqbS005QyEUYRuiYbDhOgxxXW8ltb/zUnrDXQ8/9B7/NxrVybkk1JwQRJLlrL+HN8Rje2rVm8kk3Pa5fPC4uP8p4LBlvWYTlOf9CTQxTarRBQV+4N95ef90P9ufVtwU3zHasnQW8j00uyPrYo49fZyurRKvOxRun8epp+jwa/kd8VWdtjZSjdmNfRGx4gK6VGZNQufvLF3jmdaIhq1FF3uzHqzJBxmOoAbl78NeMoSQELwbH8leU1xAp4P3L489jk3eAg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5372d184-efaf-4cd5-c932-08d8168ebc54
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2020 09:29:17.3315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hgB2jVaI9z2UNPqz3XDNvwJCMbN1o4SOzG7VNlYux9X1iPugxJyQvnrww8DRhbU5mjU9aZ+ywkSPTkhA+yqabQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5989
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Calvin Johnson (OSS) <calvin.johnson@oss.nxp.com>
> Sent: Monday, June 22, 2020 11:19 AM
> To: Jeremy Linton <jeremy.linton@arm.com>; Russell King - ARM Linux admin
> <linux@armlinux.org.uk>; Jon <jon@solid-run.com>; Cristi Sovaiala
> <cristian.sovaiala@nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; Andre=
w
> Lunn <andrew@lunn.ch>; Andy Shevchenko <andy.shevchenko@gmail.com>;
> Florian Fainelli <f.fainelli@gmail.com>; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>
> Cc: linux.cj@gmail.com; netdev@vger.kernel.org; Calvin Johnson (OSS)
> <calvin.johnson@oss.nxp.com>
> Subject: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe
> c45 devices
>=20
> From: Jeremy Linton <jeremy.linton@arm.com>
>=20
> The mdiobus_scan logic is currently hardcoded to only
> work with c22 devices. This works fairly well in most
> cases, but its possible that a c45 device doesn't respond
> despite being a standard phy. If the parent hardware
> is capable, it makes sense to scan for c22 devices before
> falling back to c45.
>=20
> As we want this to reflect the capabilities of the STA,
> lets add a field to the mii_bus structure to represent
> the capability. That way devices can opt into the extended
> scanning. Existing users should continue to default to c22
> only scanning as long as they are zero'ing the structure
> before use.

How is this default working for existing users, the code below does not see=
m
to do anything for a zeroed struct, as there is no default in the switch?

>=20
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
>=20
> ---
>=20
> Changes in v2:
> - Reserve "0" to mean that no mdiobus capabilities have been declared.
>=20
>  drivers/net/phy/mdio_bus.c | 17 +++++++++++++++--
>  include/linux/phy.h        |  8 ++++++++
>  2 files changed, 23 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 6ceee82b2839..e6c179b89907 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -739,10 +739,23 @@ EXPORT_SYMBOL(mdiobus_free);
>   */
>  struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
>  {
> -	struct phy_device *phydev;
> +	struct phy_device *phydev =3D ERR_PTR(-ENODEV);
>  	int err;
>=20
> -	phydev =3D get_phy_device(bus, addr, false);
> +	switch (bus->probe_capabilities) {
> +	case MDIOBUS_C22:
> +		phydev =3D get_phy_device(bus, addr, false);
> +		break;
> +	case MDIOBUS_C45:
> +		phydev =3D get_phy_device(bus, addr, true);
> +		break;
> +	case MDIOBUS_C22_C45:
> +		phydev =3D get_phy_device(bus, addr, false);
> +		if (IS_ERR(phydev))
> +			phydev =3D get_phy_device(bus, addr, true);
> +		break;
> +	}
> +
>  	if (IS_ERR(phydev))
>  		return phydev;
>=20
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 9248dd2ce4ca..7860d56c6bf5 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -298,6 +298,14 @@ struct mii_bus {
>  	/* RESET GPIO descriptor pointer */
>  	struct gpio_desc *reset_gpiod;
>=20
> +	/* bus capabilities, used for probing */
> +	enum {
> +		MDIOBUS_NO_CAP =3D 0,
> +		MDIOBUS_C22,
> +		MDIOBUS_C45,
> +		MDIOBUS_C22_C45,
> +	} probe_capabilities;
> +
>  	/* protect access to the shared element */
>  	struct mutex shared_lock;
>=20
> --
> 2.17.1

