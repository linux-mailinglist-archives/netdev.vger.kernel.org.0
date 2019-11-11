Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2ECF6FF1
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 09:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfKKIyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 03:54:00 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:38272 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726770AbfKKIyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 03:54:00 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAB8mrfR006013;
        Mon, 11 Nov 2019 00:53:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=BcgwGx1hNwaj2bgzj0tXQXBi6DSx9KwGPTZ+t5XFt2M=;
 b=lex0iy2t0a3bqW+Vwz+YosTLaPhoXCpEcagZ/B2TGChABv6DSyQI0QyKi+2hr3TfONvm
 g/P84Rd08U30w6OROHeCviViJ1PDAb6gq8CYXV4oVPRCxbH61imT6J1uV7SFwlR31p55
 TO5uY1T4Fu7tiNSXFYTSfkoqgbQx+eNoQw1SuPZK6r78Rn86GAezTigYtYD03CSl9rge
 gKqIG4ZhyKCQXfY/loqVSQaawH9YrakciZDJ8BNowdzvxE0EFriQ8TFO+xuAHDWTPM0k
 tcOxPUPAUatwWE13WlvCws0Wih3N8kd7tZ16NOAGiheirwyTwpJ1FeBDQKWFkuGIcrS1 4Q== 
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2059.outbound.protection.outlook.com [104.47.32.59])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2w5swy8c81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Nov 2019 00:53:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EU8HUn7nzLz1i451j53npP0B5w0+eQ2iTtbEjND6e1JfMH3rbB2vJDm9fWV4x8piLadw9ezSg1dx2htQAEFEAUbbVpjTheEUECiD5scpZTcb9ZXxVgCuVttwTD4bYR+1Z0mAAfLEx8ruX1lpDftOynjloMnxxoFJX+9W5N94acdwoh+riWvrCAkx2OKnWVYfBqzdzbvimQ0kCEYJMQsCP18f7g6oCK5ZyTUgGiph1oP27ZTEL1Kb+c82yHVwfygOe2EYq5LWRbnWsG8tDIZOuFta4emnWOVJu+Zfj4aWq7GRNVhxRG3sCFu1+NOAzo4YucGmgYicgn4crRhWE2TxzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcgwGx1hNwaj2bgzj0tXQXBi6DSx9KwGPTZ+t5XFt2M=;
 b=j/sKmrlOLg5oFsPWPX0vttJnJ22W0U99dPptyHFMg7nc5fkiFcbgdh54tjSGxJPrNzrbmkwNKg5BJFdGtnQzdLBFiRambNPqMUdt2CB8A3tSjY47LxaWe34vyHF7is9NoqErPgbKOhuXLvf+rPbvxmxjMXzNsG/5M+sEiKUTrZHDTPwGipNoH8bqaucqnv6bPVwM+tiFRuUIefclrth/xJ9hpgvAHVqg43c821u32Jw0SulreI/Irxyz/vP1MWFIYQ9mtWQhwLrsSW/jVrc8rQAg2XtXB1DShilsjO91kqht68fLbdn4mSZ0IlLs7yMN5f1U57f9H8Xs68TcEAfpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcgwGx1hNwaj2bgzj0tXQXBi6DSx9KwGPTZ+t5XFt2M=;
 b=nEtfuQ87oiJjxCdeT+ZCx3jzzIJjNwvGvSN4qpGJXN87WAOzZcgJDYcsyG+NQwulEh4wqotaqSTgKpFaiYa3ZxY/KEPN6FhZa+KN167atQUX8S3S/jspLUf/pzCbktSgBmy/Lwdxy5jmqPZXJgj3wnv3oDroQyRLeExGOOuiK70=
Received: from BY5PR07MB6514.namprd07.prod.outlook.com (10.255.137.27) by
 BY5PR07MB6769.namprd07.prod.outlook.com (10.255.137.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Mon, 11 Nov 2019 08:53:39 +0000
Received: from BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::fc51:186:dd82:f768]) by BY5PR07MB6514.namprd07.prod.outlook.com
 ([fe80::fc51:186:dd82:f768%7]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 08:53:39 +0000
From:   Milind Parab <mparab@cadence.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Piotr Sroka <piotrs@cadence.com>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        Ewan McCulloch <ewanm@cadence.com>,
        Arthur Marris <arthurm@cadence.com>,
        Steven Ho <stevenh@cadence.com>
Subject: RE: [PATCH 1/4] net: macb: add phylink support
Thread-Topic: [PATCH 1/4] net: macb: add phylink support
Thread-Index: AQHVljlIWafsj48NsUeL1qdx/rwz2qeBadQAgARChmA=
Date:   Mon, 11 Nov 2019 08:53:39 +0000
Message-ID: <BY5PR07MB65146091E2AD492FD656C9AFD3740@BY5PR07MB6514.namprd07.prod.outlook.com>
References: <1573220027-15842-1-git-send-email-mparab@cadence.com>
 <1573220063-17470-1-git-send-email-mparab@cadence.com>
 <20191108154234.GA208063@kwain>
In-Reply-To: <20191108154234.GA208063@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbXBhcmFiXGFwcGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEyOWUzNWJcbXNnc1xtc2ctYmU5ZWQ2NGUtMDQ2MC0xMWVhLWFlYjYtZDhmMmNhNGQyNWFhXGFtZS10ZXN0XGJlOWVkNjRmLTA0NjAtMTFlYS1hZWI2LWQ4ZjJjYTRkMjVhYWJvZHkudHh0IiBzej0iMjI2MTEiIHQ9IjEzMjE3OTM2MDE2MDY0NDA3OSIgaD0iME9ESmhzY3FhQVdMdDhhMTZuNngzL1NFdWhRPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae2a9491-a666-4ea2-2d18-08d76684a567
x-ms-traffictypediagnostic: BY5PR07MB6769:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR07MB676900A542973196024637C2D3740@BY5PR07MB6769.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(36092001)(13464003)(55674003)(189003)(199004)(6916009)(74316002)(66574012)(6246003)(5660300002)(52536014)(99286004)(316002)(54906003)(7736002)(107886003)(4326008)(305945005)(186003)(66066001)(30864003)(446003)(11346002)(7696005)(53546011)(55236004)(486006)(26005)(102836004)(476003)(71190400001)(71200400001)(5024004)(256004)(81156014)(6506007)(66946007)(76176011)(66446008)(64756008)(66556008)(229853002)(33656002)(66476007)(478600001)(76116006)(6306002)(8936002)(25786009)(81166006)(8676002)(55016002)(14454004)(6436002)(3846002)(9686003)(2906002)(14444005)(6116002)(966005)(86362001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6769;H:BY5PR07MB6514.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZdNjUul2TLiG2uzg0v1JOlL7gAchAoeG8LaYBvqO9hMR0b3sfJsrnSUcbX0TBOaPtH1nypDkPYtpY1zyRfO2ZYGuUKKPFwXg4QH6HBxJX6inbuWYngCmd69wWsSz0Mcr6cMmwRhe+XZyuywA7A2i7eIXwtlIWdRTDYWBUD5EvZFZ+DSwCit+omOVVBxn+XFg7iGI6F0BBaBoNRA1Bce8V0DUvbpIOfHYV01c0t8FrUMIvXYIcX4y1nsK4HI5lAJYmbzcJ98X200f7ulh39Hv/0nmCgWLBfcqWRKruFYUcvuYEX/Zy/DjSBNALCYhZ5f4Xpbw3WhwH0Gzw0xcfuY3zN4iAk4xKVb4I6IpLV5FdeNKkBsBJsqjU6KnXqT8T5ZfJqVuOdEftyLQwZfEpYyN7fHmaYY3rp5BJ/NSoYcQcoTgPRVMI3awXaOEhle0Iyg+Z+OBDkDGwbChlv67CBFrQcQx744vlxIMLb3RbNGLdNU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae2a9491-a666-4ea2-2d18-08d76684a567
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 08:53:39.1324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c+/0vOflodYCxe0QmRncTkn1WQAFC/eLg035KBBkc72KB4C87GnxePWSpOXeUlrLik7iPH5hKSU83vAPF4Cuy/8mdXUcqm3UNwhszgAwOxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6769
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-11_02:2019-11-08,2019-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 impostorscore=0
 phishscore=0 suspectscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911110087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Antoine,

I had a look at your patch. It is worth waiting for your acceptance rather =
than duplicating the effort.
When do you plan to submit your "V2" patch?
And please add me and other cadence members in your patch submission.


Regards,
Milind


-----Original Message-----
From: Antoine Tenart <antoine.tenart@bootlin.com>=20
Sent: Friday, November 8, 2019 9:13 PM
To: Milind Parab <mparab@cadence.com>
Cc: andrew@lunn.ch; nicolas.ferre@microchip.com; davem@davemloft.net; f.fai=
nelli@gmail.com; netdev@vger.kernel.org; hkallweit1@gmail.com; linux-kernel=
@vger.kernel.org; Piotr Sroka <piotrs@cadence.com>; Dhananjay Vilasrao Kang=
ude <dkangude@cadence.com>; Ewan McCulloch <ewanm@cadence.com>; Arthur Marr=
is <arthurm@cadence.com>; Steven Ho <stevenh@cadence.com>
Subject: Re: [PATCH 1/4] net: macb: add phylink support

EXTERNAL MAIL


Hello Milind,



I sent a similar patch a few weeks ago. Have you seen

https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.org_netd=
ev_20191018145230.GJ3125-40piout.net_T_-3F&d=3DDwIDAw&c=3DaUq983L2pue2FqKFo=
P6PGHMJQyoJ7kl3s3GZ-_haXqY&r=3DBDdk1JtITE_JJ0519WwqU7IKF80Cw1i55lZOGqv2su8&=
m=3DToN1RMBv1eK6uj1h7HO6NdJivPHLvHDYcDwSDfcB3fc&s=3D5KotdNmEBqzpiI3kom2EL7a=
373rIiAefrTqD-8Esg6E&e=3D=20

I also intended to send the v2 in the next days. I looked briefly at

your patch and it seems it has some of the issues my first version had

(such as not using state->link in mac_config()). This is why I would

suggest to wait for my v2 and to see if the rest of your series could be

based on it. What do you think? I pushed it in the meantime on GH[1].



Also, one of the comments I got was that it should be possible to get

the status of the negotiation, and that it would be very nice to

implement the get_link_state() helper. I couldn't get lots of info

about the status register (NSR), but I had the feeling this register is

exposing the info we need. Do you have more info about this?



Thanks!

Antoine



[1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_atena=
rt_linux_commit_eef7734734310e6759a0c5e0b61bc71cf978e46b&d=3DDwIDAw&c=3DaUq=
983L2pue2FqKFoP6PGHMJQyoJ7kl3s3GZ-_haXqY&r=3DBDdk1JtITE_JJ0519WwqU7IKF80Cw1=
i55lZOGqv2su8&m=3DToN1RMBv1eK6uj1h7HO6NdJivPHLvHDYcDwSDfcB3fc&s=3D2u_8Chlk0=
JlEa5onkqq56GQHC4-VhqUa3e4XnAt2V0Q&e=3D=20



On Fri, Nov 08, 2019 at 01:34:23PM +0000, Milind Parab wrote:

> This patch replace phylib API's by phylink API's.

>=20

> Signed-off-by: Milind Parab <mparab@cadence.com>

> ---

>  drivers/net/ethernet/cadence/Kconfig     |    2 +-

>  drivers/net/ethernet/cadence/macb.h      |    3 +

>  drivers/net/ethernet/cadence/macb_main.c |  326 ++++++++++++++++--------=
-----

>  3 files changed, 184 insertions(+), 147 deletions(-)

>=20

> diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/=
cadence/Kconfig

> index f4b3bd8..53b50c2 100644

> --- a/drivers/net/ethernet/cadence/Kconfig

> +++ b/drivers/net/ethernet/cadence/Kconfig

> @@ -22,7 +22,7 @@ if NET_VENDOR_CADENCE

>  config MACB

>  	tristate "Cadence MACB/GEM support"

>  	depends on HAS_DMA && COMMON_CLK

> -	select PHYLIB

> +	select PHYLINK

>  	---help---

>  	  The Cadence MACB ethernet interface is found on many Atmel AT32 and

>  	  AT91 parts.  This driver also supports the Cadence GEM (Gigabit

> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/c=
adence/macb.h

> index 03983bd..a400705 100644

> --- a/drivers/net/ethernet/cadence/macb.h

> +++ b/drivers/net/ethernet/cadence/macb.h

> @@ -11,6 +11,7 @@

>  #include <linux/ptp_clock_kernel.h>

>  #include <linux/net_tstamp.h>

>  #include <linux/interrupt.h>

> +#include <linux/phylink.h>

> =20

>  #if defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) || defined(CONFIG_MACB_USE_HWS=
TAMP)

>  #define MACB_EXT_DESC

> @@ -1232,6 +1233,8 @@ struct macb {

>  	u32	rx_intr_mask;

> =20

>  	struct macb_pm_data pm_data;

> +	struct phylink *pl;

> +	struct phylink_config pl_config;

>  };

> =20

>  #ifdef CONFIG_MACB_USE_HWSTAMP

> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ether=
net/cadence/macb_main.c

> index b884cf7..15016ff 100644

> --- a/drivers/net/ethernet/cadence/macb_main.c

> +++ b/drivers/net/ethernet/cadence/macb_main.c

> @@ -432,115 +432,160 @@ static void macb_set_tx_clk(struct clk *clk, int =
speed, struct net_device *dev)

>  		netdev_err(dev, "adjusting tx_clk failed.\n");

>  }

> =20

> -static void macb_handle_link_change(struct net_device *dev)

> +static void gem_phylink_validate(struct phylink_config *pl_config,

> +				 unsigned long *supported,

> +				 struct phylink_link_state *state)

>  {

> -	struct macb *bp =3D netdev_priv(dev);

> -	struct phy_device *phydev =3D dev->phydev;

> +	struct net_device *netdev =3D to_net_dev(pl_config->dev);

> +	struct macb *bp =3D netdev_priv(netdev);

> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };

> +

> +	switch (state->interface) {

> +	case PHY_INTERFACE_MODE_GMII:

> +	case PHY_INTERFACE_MODE_RGMII:

> +		if (!macb_is_gem(bp))

> +			goto empty_set;

> +		break;

> +	default:

> +		break;

> +	}

> +

> +	switch (state->interface) {

> +	case PHY_INTERFACE_MODE_GMII:

> +	case PHY_INTERFACE_MODE_RGMII:

> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {

> +			phylink_set(mask, 1000baseT_Full);

> +			phylink_set(mask, 1000baseX_Full);

> +			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))

> +				phylink_set(mask, 1000baseT_Half);

> +		}

> +	/* fallthrough */

> +	case PHY_INTERFACE_MODE_MII:

> +	case PHY_INTERFACE_MODE_RMII:

> +		phylink_set(mask, 10baseT_Half);

> +		phylink_set(mask, 10baseT_Full);

> +		phylink_set(mask, 100baseT_Half);

> +		phylink_set(mask, 100baseT_Full);

> +		break;

> +	default:

> +		goto empty_set;

> +	}

> +

> +	linkmode_and(supported, supported, mask);

> +	linkmode_and(state->advertising, state->advertising, mask);

> +	return;

> +

> +empty_set:

> +	linkmode_zero(supported);

> +}

> +

> +static int gem_phylink_mac_link_state(struct phylink_config *pl_config,

> +				      struct phylink_link_state *state)

> +{

> +	return -EOPNOTSUPP;

> +}

> +

> +static void gem_mac_config(struct phylink_config *pl_config, unsigned in=
t mode,

> +			   const struct phylink_link_state *state)

> +{

> +	struct net_device *netdev =3D to_net_dev(pl_config->dev);

> +	struct macb *bp =3D netdev_priv(netdev);

> +	bool change_interface =3D bp->phy_interface !=3D state->interface;

>  	unsigned long flags;

> -	int status_change =3D 0;

> =20

>  	spin_lock_irqsave(&bp->lock, flags);

> =20

> -	if (phydev->link) {

> -		if ((bp->speed !=3D phydev->speed) ||

> -		    (bp->duplex !=3D phydev->duplex)) {

> -			u32 reg;

> +	if (change_interface)

> +		bp->phy_interface =3D state->interface;

> =20

> -			reg =3D macb_readl(bp, NCFGR);

> -			reg &=3D ~(MACB_BIT(SPD) | MACB_BIT(FD));

> -			if (macb_is_gem(bp))

> -				reg &=3D ~GEM_BIT(GBE);

> +	if (!phylink_autoneg_inband(mode) &&

> +	    (bp->speed !=3D state->speed ||

> +	     bp->duplex !=3D state->duplex)) {

> +		u32 reg;

> =20

> -			if (phydev->duplex)

> -				reg |=3D MACB_BIT(FD);

> -			if (phydev->speed =3D=3D SPEED_100)

> -				reg |=3D MACB_BIT(SPD);

> -			if (phydev->speed =3D=3D SPEED_1000 &&

> -			    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)

> -				reg |=3D GEM_BIT(GBE);

> -

> -			macb_or_gem_writel(bp, NCFGR, reg);

> +		reg =3D macb_readl(bp, NCFGR);

> +		reg &=3D ~(MACB_BIT(SPD) | MACB_BIT(FD));

> +		if (macb_is_gem(bp))

> +			reg &=3D ~GEM_BIT(GBE);

> +		if (state->duplex)

> +			reg |=3D MACB_BIT(FD);

> =20

> -			bp->speed =3D phydev->speed;

> -			bp->duplex =3D phydev->duplex;

> -			status_change =3D 1;

> +		switch (state->speed) {

> +		case SPEED_1000:

> +			reg |=3D GEM_BIT(GBE);

> +			break;

> +		case SPEED_100:

> +			reg |=3D MACB_BIT(SPD);

> +			break;

> +		default:

> +			break;

>  		}

> -	}

> +		macb_or_gem_writel(bp, NCFGR, reg);

> =20

> -	if (phydev->link !=3D bp->link) {

> -		if (!phydev->link) {

> -			bp->speed =3D 0;

> -			bp->duplex =3D -1;

> -		}

> -		bp->link =3D phydev->link;

> +		bp->speed =3D state->speed;

> +		bp->duplex =3D state->duplex;

> =20

> -		status_change =3D 1;

> +		if (state->link)

> +			macb_set_tx_clk(bp->tx_clk, state->speed, netdev);

>  	}

> =20

>  	spin_unlock_irqrestore(&bp->lock, flags);

> +}

> =20

> -	if (status_change) {

> -		if (phydev->link) {

> -			/* Update the TX clock rate if and only if the link is

> -			 * up and there has been a link change.

> -			 */

> -			macb_set_tx_clk(bp->tx_clk, phydev->speed, dev);

> +static void gem_mac_link_up(struct phylink_config *pl_config, unsigned i=
nt mode,

> +			    phy_interface_t interface, struct phy_device *phy)

> +{

> +	struct net_device *netdev =3D to_net_dev(pl_config->dev);

> +	struct macb *bp =3D netdev_priv(netdev);

> =20

> -			netif_carrier_on(dev);

> -			netdev_info(dev, "link up (%d/%s)\n",

> -				    phydev->speed,

> -				    phydev->duplex =3D=3D DUPLEX_FULL ?

> -				    "Full" : "Half");

> -		} else {

> -			netif_carrier_off(dev);

> -			netdev_info(dev, "link down\n");

> -		}

> -	}

> +	bp->link =3D 1;

> +	/* Enable TX and RX */

> +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE))=
;

>  }

> =20

> +static void gem_mac_link_down(struct phylink_config *pl_config,

> +			      unsigned int mode, phy_interface_t interface)

> +{

> +	struct net_device *netdev =3D to_net_dev(pl_config->dev);

> +	struct macb *bp =3D netdev_priv(netdev);

> +

> +	bp->link =3D 0;

> +	/* Disable TX and RX */

> +	macb_writel(bp, NCR,

> +		    macb_readl(bp, NCR) & ~(MACB_BIT(RE) | MACB_BIT(TE)));

> +}

> +

> +static const struct phylink_mac_ops gem_phylink_ops =3D {

> +	.validate =3D gem_phylink_validate,

> +	.mac_link_state =3D gem_phylink_mac_link_state,

> +	.mac_config =3D gem_mac_config,

> +	.mac_link_up =3D gem_mac_link_up,

> +	.mac_link_down =3D gem_mac_link_down,

> +};

> +

>  /* based on au1000_eth. c*/

> -static int macb_mii_probe(struct net_device *dev)

> +static int macb_mii_probe(struct net_device *dev, phy_interface_t phy_mo=
de)

>  {

>  	struct macb *bp =3D netdev_priv(dev);

>  	struct phy_device *phydev;

>  	struct device_node *np;

> -	int ret, i;

> +	int ret;

> =20

>  	np =3D bp->pdev->dev.of_node;

>  	ret =3D 0;

> =20

> -	if (np) {

> -		if (of_phy_is_fixed_link(np)) {

> -			bp->phy_node =3D of_node_get(np);

> -		} else {

> -			bp->phy_node =3D of_parse_phandle(np, "phy-handle", 0);

> -			/* fallback to standard phy registration if no

> -			 * phy-handle was found nor any phy found during

> -			 * dt phy registration

> -			 */

> -			if (!bp->phy_node && !phy_find_first(bp->mii_bus)) {

> -				for (i =3D 0; i < PHY_MAX_ADDR; i++) {

> -					phydev =3D mdiobus_scan(bp->mii_bus, i);

> -					if (IS_ERR(phydev) &&

> -					    PTR_ERR(phydev) !=3D -ENODEV) {

> -						ret =3D PTR_ERR(phydev);

> -						break;

> -					}

> -				}

> -

> -				if (ret)

> -					return -ENODEV;

> -			}

> -		}

> +	bp->pl_config.dev =3D &dev->dev;

> +	bp->pl_config.type =3D PHYLINK_NETDEV;

> +	bp->pl =3D phylink_create(&bp->pl_config, of_fwnode_handle(np),

> +				phy_mode, &gem_phylink_ops);

> +	if (IS_ERR(bp->pl)) {

> +		netdev_err(dev,

> +			   "error creating PHYLINK: %ld\n", PTR_ERR(bp->pl));

> +		return PTR_ERR(bp->pl);

>  	}

> =20

> -	if (bp->phy_node) {

> -		phydev =3D of_phy_connect(dev, bp->phy_node,

> -					&macb_handle_link_change, 0,

> -					bp->phy_interface);

> -		if (!phydev)

> -			return -ENODEV;

> -	} else {

> +	ret =3D phylink_of_phy_connect(bp->pl, np, 0);

> +	if (ret =3D=3D -ENODEV && bp->mii_bus) {

>  		phydev =3D phy_find_first(bp->mii_bus);

>  		if (!phydev) {

>  			netdev_err(dev, "no PHY found\n");

> @@ -548,32 +593,22 @@ static int macb_mii_probe(struct net_device *dev)

>  		}

> =20

>  		/* attach the mac to the phy */

> -		ret =3D phy_connect_direct(dev, phydev, &macb_handle_link_change,

> -					 bp->phy_interface);

> +		ret =3D phylink_connect_phy(bp->pl, phydev);

>  		if (ret) {

>  			netdev_err(dev, "Could not attach to PHY\n");

>  			return ret;

>  		}

>  	}

> =20

> -	/* mask with MAC supported features */

> -	if (macb_is_gem(bp) && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)

> -		phy_set_max_speed(phydev, SPEED_1000);

> -	else

> -		phy_set_max_speed(phydev, SPEED_100);

> -

> -	if (bp->caps & MACB_CAPS_NO_GIGABIT_HALF)

> -		phy_remove_link_mode(phydev,

> -				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);

> -

>  	bp->link =3D 0;

> -	bp->speed =3D 0;

> -	bp->duplex =3D -1;

> +	bp->speed =3D SPEED_UNKNOWN;

> +	bp->duplex =3D DUPLEX_UNKNOWN;

> +	bp->phy_interface =3D PHY_INTERFACE_MODE_MAX;

> =20

> -	return 0;

> +	return ret;

>  }

> =20

> -static int macb_mii_init(struct macb *bp)

> +static int macb_mii_init(struct macb *bp, phy_interface_t phy_mode)

>  {

>  	struct device_node *np;

>  	int err =3D -ENXIO;

> @@ -598,22 +633,12 @@ static int macb_mii_init(struct macb *bp)

>  	dev_set_drvdata(&bp->dev->dev, bp->mii_bus);

> =20

>  	np =3D bp->pdev->dev.of_node;

> -	if (np && of_phy_is_fixed_link(np)) {

> -		if (of_phy_register_fixed_link(np) < 0) {

> -			dev_err(&bp->pdev->dev,

> -				"broken fixed-link specification %pOF\n", np);

> -			goto err_out_free_mdiobus;

> -		}

> -

> -		err =3D mdiobus_register(bp->mii_bus);

> -	} else {

> -		err =3D of_mdiobus_register(bp->mii_bus, np);

> -	}

> +	err =3D of_mdiobus_register(bp->mii_bus, np);

> =20

>  	if (err)

>  		goto err_out_free_fixed_link;

> =20

> -	err =3D macb_mii_probe(bp->dev);

> +	err =3D macb_mii_probe(bp->dev, phy_mode);

>  	if (err)

>  		goto err_out_unregister_bus;

> =20

> @@ -624,7 +649,6 @@ static int macb_mii_init(struct macb *bp)

>  err_out_free_fixed_link:

>  	if (np && of_phy_is_fixed_link(np))

>  		of_phy_deregister_fixed_link(np);

> -err_out_free_mdiobus:

>  	of_node_put(bp->phy_node);

>  	mdiobus_free(bp->mii_bus);

>  err_out:

> @@ -2417,12 +2441,6 @@ static int macb_open(struct net_device *dev)

>  	/* carrier starts down */

>  	netif_carrier_off(dev);

> =20

> -	/* if the phy is not yet register, retry later*/

> -	if (!dev->phydev) {

> -		err =3D -EAGAIN;

> -		goto pm_exit;

> -	}

> -

>  	/* RX buffers initialization */

>  	macb_init_rx_buffer_size(bp, bufsz);

> =20

> @@ -2440,7 +2458,7 @@ static int macb_open(struct net_device *dev)

>  	macb_init_hw(bp);

> =20

>  	/* schedule a link state check */

> -	phy_start(dev->phydev);

> +	phylink_start(bp->pl);

> =20

>  	netif_tx_start_all_queues(dev);

> =20

> @@ -2467,8 +2485,7 @@ static int macb_close(struct net_device *dev)

>  	for (q =3D 0, queue =3D bp->queues; q < bp->num_queues; ++q, ++queue)

>  		napi_disable(&queue->napi);

> =20

> -	if (dev->phydev)

> -		phy_stop(dev->phydev);

> +	phylink_stop(bp->pl);

> =20

>  	spin_lock_irqsave(&bp->lock, flags);

>  	macb_reset_hw(bp);

> @@ -3157,6 +3174,23 @@ static int gem_set_rxnfc(struct net_device *netdev=
, struct ethtool_rxnfc *cmd)

>  	return ret;

>  }

> =20

> +static int gem_ethtool_get_link_ksettings(struct net_device *netdev,

> +					  struct ethtool_link_ksettings *cmd)

> +{

> +	struct macb *bp =3D netdev_priv(netdev);

> +

> +	return phylink_ethtool_ksettings_get(bp->pl, cmd);

> +}

> +

> +static int

> +gem_ethtool_set_link_ksettings(struct net_device *netdev,

> +			       const struct ethtool_link_ksettings *cmd)

> +{

> +	struct macb *bp =3D netdev_priv(netdev);

> +

> +	return phylink_ethtool_ksettings_set(bp->pl, cmd);

> +}

> +

>  static const struct ethtool_ops macb_ethtool_ops =3D {

>  	.get_regs_len		=3D macb_get_regs_len,

>  	.get_regs		=3D macb_get_regs,

> @@ -3164,8 +3198,8 @@ static int gem_set_rxnfc(struct net_device *netdev,=
 struct ethtool_rxnfc *cmd)

>  	.get_ts_info		=3D ethtool_op_get_ts_info,

>  	.get_wol		=3D macb_get_wol,

>  	.set_wol		=3D macb_set_wol,

> -	.get_link_ksettings     =3D phy_ethtool_get_link_ksettings,

> -	.set_link_ksettings     =3D phy_ethtool_set_link_ksettings,

> +	.get_link_ksettings     =3D gem_ethtool_get_link_ksettings,

> +	.set_link_ksettings     =3D gem_ethtool_set_link_ksettings,

>  	.get_ringparam		=3D macb_get_ringparam,

>  	.set_ringparam		=3D macb_set_ringparam,

>  };

> @@ -3178,8 +3212,8 @@ static int gem_set_rxnfc(struct net_device *netdev,=
 struct ethtool_rxnfc *cmd)

>  	.get_ethtool_stats	=3D gem_get_ethtool_stats,

>  	.get_strings		=3D gem_get_ethtool_strings,

>  	.get_sset_count		=3D gem_get_sset_count,

> -	.get_link_ksettings     =3D phy_ethtool_get_link_ksettings,

> -	.set_link_ksettings     =3D phy_ethtool_set_link_ksettings,

> +	.get_link_ksettings     =3D gem_ethtool_get_link_ksettings,

> +	.set_link_ksettings     =3D gem_ethtool_set_link_ksettings,

>  	.get_ringparam		=3D macb_get_ringparam,

>  	.set_ringparam		=3D macb_set_ringparam,

>  	.get_rxnfc			=3D gem_get_rxnfc,

> @@ -3188,17 +3222,13 @@ static int gem_set_rxnfc(struct net_device *netde=
v, struct ethtool_rxnfc *cmd)

> =20

>  static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)

>  {

> -	struct phy_device *phydev =3D dev->phydev;

>  	struct macb *bp =3D netdev_priv(dev);

> =20

>  	if (!netif_running(dev))

>  		return -EINVAL;

> =20

> -	if (!phydev)

> -		return -ENODEV;

> -

>  	if (!bp->ptp_info)

> -		return phy_mii_ioctl(phydev, rq, cmd);

> +		return phylink_mii_ioctl(bp->pl, rq, cmd);

> =20

>  	switch (cmd) {

>  	case SIOCSHWTSTAMP:

> @@ -3206,7 +3236,7 @@ static int macb_ioctl(struct net_device *dev, struc=
t ifreq *rq, int cmd)

>  	case SIOCGHWTSTAMP:

>  		return bp->ptp_info->get_hwtst(dev, rq);

>  	default:

> -		return phy_mii_ioctl(phydev, rq, cmd);

> +		return phylink_mii_ioctl(bp->pl, rq, cmd);

>  	}

>  }

> =20

> @@ -3708,7 +3738,7 @@ static int at91ether_open(struct net_device *dev)

>  			     MACB_BIT(HRESP));

> =20

>  	/* schedule a link state check */

> -	phy_start(dev->phydev);

> +	phylink_start(lp->pl);

> =20

>  	netif_start_queue(dev);

> =20

> @@ -4181,7 +4211,7 @@ static int macb_probe(struct platform_device *pdev)

>  	struct clk *tsu_clk =3D NULL;

>  	unsigned int queue_mask, num_queues;

>  	bool native_io;

> -	struct phy_device *phydev;

> +	//struct phy_device *phydev;

>  	phy_interface_t interface;

>  	struct net_device *dev;

>  	struct resource *regs;

> @@ -4312,21 +4342,17 @@ static int macb_probe(struct platform_device *pde=
v)

>  	err =3D of_get_phy_mode(np, &interface);

>  	if (err)

>  		/* not found in DT, MII by default */

> -		bp->phy_interface =3D PHY_INTERFACE_MODE_MII;

> -	else

> -		bp->phy_interface =3D interface;

> +		interface =3D PHY_INTERFACE_MODE_MII;

> =20

>  	/* IP specific init */

>  	err =3D init(pdev);

>  	if (err)

>  		goto err_out_free_netdev;

> =20

> -	err =3D macb_mii_init(bp);

> +	err =3D macb_mii_init(bp, interface);

>  	if (err)

>  		goto err_out_free_netdev;

> =20

> -	phydev =3D dev->phydev;

> -

>  	netif_carrier_off(dev);

> =20

>  	err =3D register_netdev(dev);

> @@ -4338,8 +4364,6 @@ static int macb_probe(struct platform_device *pdev)

>  	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,

>  		     (unsigned long)bp);

> =20

> -	phy_attached_info(phydev);

> -

>  	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",

>  		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),

>  		    dev->base_addr, dev->irq, dev->dev_addr);

> @@ -4350,7 +4374,9 @@ static int macb_probe(struct platform_device *pdev)

>  	return 0;

> =20

>  err_out_unregister_mdio:

> -	phy_disconnect(dev->phydev);

> +	rtnl_lock();

> +	phylink_disconnect_phy(bp->pl);

> +	rtnl_unlock();

>  	mdiobus_unregister(bp->mii_bus);

>  	of_node_put(bp->phy_node);

>  	if (np && of_phy_is_fixed_link(np))

> @@ -4384,13 +4410,18 @@ static int macb_remove(struct platform_device *pd=
ev)

> =20

>  	if (dev) {

>  		bp =3D netdev_priv(dev);

> -		if (dev->phydev)

> -			phy_disconnect(dev->phydev);

> +		if (bp->pl) {

> +			rtnl_lock();

> +			phylink_disconnect_phy(bp->pl);

> +			rtnl_unlock();

> +		}

>  		mdiobus_unregister(bp->mii_bus);

>  		if (np && of_phy_is_fixed_link(np))

>  			of_phy_deregister_fixed_link(np);

>  		dev->phydev =3D NULL;

>  		mdiobus_free(bp->mii_bus);

> +		if (bp->pl)

> +			phylink_destroy(bp->pl);

> =20

>  		unregister_netdev(dev);

>  		pm_runtime_disable(&pdev->dev);

> @@ -4433,8 +4464,9 @@ static int __maybe_unused macb_suspend(struct devic=
e *dev)

>  		for (q =3D 0, queue =3D bp->queues; q < bp->num_queues;

>  		     ++q, ++queue)

>  			napi_disable(&queue->napi);

> -		phy_stop(netdev->phydev);

> -		phy_suspend(netdev->phydev);

> +		phylink_stop(bp->pl);

> +		if (netdev->phydev)

> +			phy_suspend(netdev->phydev);

>  		spin_lock_irqsave(&bp->lock, flags);

>  		macb_reset_hw(bp);

>  		spin_unlock_irqrestore(&bp->lock, flags);

> @@ -4482,9 +4514,11 @@ static int __maybe_unused macb_resume(struct devic=
e *dev)

>  		for (q =3D 0, queue =3D bp->queues; q < bp->num_queues;

>  		     ++q, ++queue)

>  			napi_enable(&queue->napi);

> -		phy_resume(netdev->phydev);

> -		phy_init_hw(netdev->phydev);

> -		phy_start(netdev->phydev);

> +		if (netdev->phydev) {

> +			phy_resume(netdev->phydev);

> +			phy_init_hw(netdev->phydev);

> +		}

> +		phylink_start(bp->pl);

>  	}

> =20

>  	bp->macbgem_ops.mog_init_rings(bp);

> --=20

> 1.7.1

>=20



--=20

Antoine T=E9nart, Bootlin

Embedded Linux and Kernel engineering

https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__bootlin.com&d=3DDwID=
Aw&c=3DaUq983L2pue2FqKFoP6PGHMJQyoJ7kl3s3GZ-_haXqY&r=3DBDdk1JtITE_JJ0519Wwq=
U7IKF80Cw1i55lZOGqv2su8&m=3DToN1RMBv1eK6uj1h7HO6NdJivPHLvHDYcDwSDfcB3fc&s=
=3DNT3VgR_be1KAgq5vc1BgdA21q-br_ihwk-41VPk__gY&e=3D=20

