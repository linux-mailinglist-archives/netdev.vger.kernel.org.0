Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0C645CBE7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 19:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbhKXSQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 13:16:58 -0500
Received: from mail-am6eur05on2050.outbound.protection.outlook.com ([40.107.22.50]:12873
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241825AbhKXSQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 13:16:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gi6PizAIDaIsZ8I/nsHJ20O15o9osHrmsR/bw15Km7mt/Z+XZzpyStJtTKodq/iu0R57aq7skhKYPxPWN4Y2whj0jugWHAF7IJdewvuFKiL205+9Y17Tb7w04jO60OXJ+h4wA1gnmDiM2e52o3nyJbqEAloitoarVHQvJDdahv+BY7utRrP+j4DMt8vZ0Vqn+0aJmX7Kj0YZubU0sNb4dRLv8g+Vqbs6c3t3lDtWGBErD8u9Iz6Dbax27DfwaTpyCbU3BKfw/7hr31TKiKiqurpe9nhRt6HtTqI1o6elvDEPFcHGCgzWOwXeTtslSwe82Ztnq9ZiYOdUW0GO1hAkLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ha5TqXLcT9mnss5LqNVjACCChkPJLHo5vqULgXZd/4=;
 b=lPg0SyLyNvBG6XlqZ6OyZ6RJxKbQuVPioVq4P9lLy7Z05F0t2Td/Qkfme0Ml5NIPskKmP7TuIWXGDFo162NCG5let6iosxEIf7gXDLUDvbvpr4RgmaBNoqqDFQzxkxSZoVjouvAipriQOvu58HSiNsprr+A5MdaF8VU+zVGkPW4USsVyr8qyhPWp5rsoYQUUOj6EbJh7PjpCZCxN+cMvX0nW5T96neSHOTphJN+Qb/vsgJheI71aXkSATGbxyrpdFkLtKShKl2pDfEWXdoPc/cD+vdrliUNzBuCr9LH5KaHxg8IMCXY9vnfFiaYrveHQvK+GQWuFqQu4bo3zd+9OrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ha5TqXLcT9mnss5LqNVjACCChkPJLHo5vqULgXZd/4=;
 b=eGcWmpDUzLSFG5upb/MQbe9IddgAULD7aCgzK/XBpDLWL3TYvmpR0fk6Jh/cO2UNt5KNr7hADpHa2UH3fLw+HzK8vxhVE8Z5FllyQaP1VOnAElOQLQkA/vq5id2K92BWUFyBMVqGMOBh0CYx0DeWeMiywmXEIzUop/zf9tSk9X8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Wed, 24 Nov
 2021 18:13:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 18:13:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 02/12] net: dsa: support use of
 phylink_generic_validate()
Thread-Topic: [PATCH RFC net-next 02/12] net: dsa: support use of
 phylink_generic_validate()
Thread-Index: AQHX4VwUcgCdRIZ8ekOfZ8DOUsEJBawS+1GA
Date:   Wed, 24 Nov 2021 18:13:45 +0000
Message-ID: <20211124181345.yqhvlvqskhvvwnu6@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRd-00D8L2-Aq@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mpwRd-00D8L2-Aq@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 888be4fa-ecf8-4dd2-2fc2-08d9af7627e3
x-ms-traffictypediagnostic: VI1PR0402MB3551:
x-microsoft-antispam-prvs: <VI1PR0402MB3551D0A2878213323206645FE0619@VI1PR0402MB3551.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nKQrECMmOL4z98aBGlL+ZhQv7T/WfEGLpdVQPDgFs2y2cGwucm+4f/G2qAYqri0LVR4uyVltvWTMCiPFzYhlzFGjnXsp5VCAUNjWzwS2gpYaQBK1yEf5giI9VAKMxeQ51JxL72l7z2xZsU/KsjbBHXTnr3ASfF2VAjF1xj1sl65H5r2uazO6kRcOQWcyRuCqGHbM2v2UG3BTVuBIw4vDovIv6RQ5xOFprpS3Q+ue/ETyrDXl/n/YQJ74tAy66c6pSGDyFWiYTgIPtwSxEO7JsHtv5jea5cgxlDj3hQtw/swPiGvxqdAvQl3wajlDxcA+6YerYRtOXVnh//0CyzJx5kG2WT5hU8nbaZH4xbptSVEpNy3wF5cU2TQOIRk/g5xXHomNKhB7OD+uKD0XHnQuFoMnMG7DFnMGTSpV4P4Zkl2tEX6BY6JNBFCV9q1Nibv91lW/zuyL5Usq6+LvI/ujVA2HlIFNoG1wMXEKbZnL+zoEC+PwnZ9FTKRQW0dWRzeLsmRYSCh7Nu2Hon7C6pYZr/8P8QM4+sV4aTv6d+brkwYxU5plaJio8xQyz3Qu6zuj+cIFdNj/Vb7HxCgiJZEyG7NzlrvgE2KtQLCTJLTlEGY1azxEHmgbvN5KQOUqodws87AhSnBvCb16UTKDajaAi3+rVoOqT7NsULhlI4tW/YdNsKn23Ykp2uGcpRCDKAbL5AXWmauXFhQHdAlmOyg0TCqPT107n8NIqFAzNg8Nho8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(316002)(86362001)(7416002)(122000001)(71200400001)(66476007)(186003)(66446008)(76116006)(6486002)(38070700005)(1076003)(508600001)(83380400001)(5660300002)(91956017)(26005)(66946007)(66556008)(64756008)(8676002)(9686003)(44832011)(6512007)(2906002)(4326008)(33716001)(38100700002)(54906003)(6506007)(8936002)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Xi75ezvSyF63nR8DyB7ie41Vula3iqMr0wzRGFXS8cbokJHXZ1wP1KpHVomL?=
 =?us-ascii?Q?A41/mEkbnMg4/I75A0bz24DD5tkWUKBX7qTkYoKZKiNMTD1GLZsjZAyd49Ai?=
 =?us-ascii?Q?IwWYMRqJzTCk+o0Dg1kdLoFgtEjxZjcgqxoVVxJgHHZ331g3ZztAgYamv47b?=
 =?us-ascii?Q?nfFIaAy5/gYzkUqT4GGIDkDsZbS6+AEjqpmHCLE3IoQgqrHCbE1y1kniOAAJ?=
 =?us-ascii?Q?wZAjz2C31YrZIO0qIJGLtwhb5dpWyvYovG+rTxBPRR+iK6k5uFEo3wtKcu3a?=
 =?us-ascii?Q?goTU2gPU1yxJ+4G/LI0ByvOVxyco3XYMjtGWzn/f6iH2edlyrU7ShbSHZPna?=
 =?us-ascii?Q?rzCNax5dvSlPeYlpiltwmSy7yHpmTc40Ai76prKs6NAQyngnYhLSSzfpXaDW?=
 =?us-ascii?Q?ncfLFq1fLSnp5gF9vqi7HPaZfYuSPuBj+W5WPou9vqOhdTbsVA4NAfUxgSk4?=
 =?us-ascii?Q?iMZEisSEuhMH36K+pCL98Rge9ReDn1A8JZ6NnMNTDJmXgYA2HXZ5gLiZaci/?=
 =?us-ascii?Q?lYfcU5FBpqHqoH7Fd4T2JiunGC7Ij0sNfErrPUIptfY43pB7tIdKHZ110DKM?=
 =?us-ascii?Q?7yk8zjtiAGEJd0mgDCX3HIZcP/JLiP7hip4A+ZZZAFla+qsJG0XmlroWuZCy?=
 =?us-ascii?Q?Fs5RmBwfEXzHY4cOD1Uib/jv8aBuMK5azxXv8U96HwBr5W+C21LKZ3Y0Vn8a?=
 =?us-ascii?Q?KXddbikY8nXo4AKmrwInGzxgjLY2MsFkAAUo+xiH0bhCbN7ybKQqOgqTJutp?=
 =?us-ascii?Q?9umA74KI7ufQNNFAq79SwPxX/5/rNLPgtgi1H1n2yZMM0IqajRybUYgKrtEZ?=
 =?us-ascii?Q?l6KQk+RN1R+E4Amcr4UR5HSvEcaplQLd6v2zPsSEh88Pq2azCsTrh//WbTOY?=
 =?us-ascii?Q?QB+lq45XI5onCGcrPV3tACRZixtlIWce2SGoU4OTma/fE86jfXv5VX3wubV5?=
 =?us-ascii?Q?IwCRQ578Qx3qHJRgs0sS41G9vmboLP28eff0ClwVDNxboesEdYpc+TqreBdw?=
 =?us-ascii?Q?bPlI0K3gwuWJN5eEUYfa9ELMVsbm86Z3AUz1ZXm5I0iPP0dEeA+Mp9cMP0F5?=
 =?us-ascii?Q?/+G35FbqzxDlpjL+Hx7cQPmQLo1mLi4OTv0OuVjMSW4K7DrjWmTx3NXdRHff?=
 =?us-ascii?Q?DzjO6r4EDK5eRj/8A097+hkgxV6j7lcMLUY6a61CHUR0r7Vr2DMNu+55lz1e?=
 =?us-ascii?Q?dyISQWxi1HtQt4nVo3Vzfj1N7xMFHTrT/5Zg4OXwJHAwjZ96EhUlRfJ86Mlc?=
 =?us-ascii?Q?KS6RXtsp/QsPBQpepQeOgLO+ihvHc6gFGMy5GFrcIe7j953FSdo2xZ6/CpX/?=
 =?us-ascii?Q?j8TxPulzi+L+ROmJP/6hjzKYDY0q9J+UlTpSFvq/OyM60KyImTn5ohItcibp?=
 =?us-ascii?Q?O3W81qcPbmFBPYcCE2dacueV5DDP71LxUw2xt45FuFvs4lCklXeP26P2TbfP?=
 =?us-ascii?Q?HcuHRtPyQpOCaOsfF8QuvvbddH6IUHHXjjDG3KzYyiTQTh+7i1Y3aHRdtC3u?=
 =?us-ascii?Q?9PNtbQa+LB9ykJO2iyOS0z1gRUpv5m8TMKGEHbSoe35r+1uodHxhMD8uglop?=
 =?us-ascii?Q?GrHo7bC1rEs65Llr6UWv0X/SGwmCLaqpPyz4RkJCbv3RJDNpNAwJO/YpWqwk?=
 =?us-ascii?Q?flQJKT5nN5jXyvu7l1rlR63292/1PPHXh3bBI0EKUtcy?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A386003848B7F4C993EEE02890067B3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 888be4fa-ecf8-4dd2-2fc2-08d9af7627e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 18:13:45.8628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O8c0Co50m8S8tJ9W50+sKTFS1Znn9RfST/Vy2FVd6urPFDPvWs/Nufv4yuhJIwXRQ6CP1N8+biUB3T4f8HUQ3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 05:52:33PM +0000, Russell King (Oracle) wrote:
> Support the use of phylink_generic_validate() when there is no
> phylink_validate method given in the DSA switch operations and
> mac_capabilities have been set in the phylink_config structure by the
> DSA switch driver.
>=20
> This gives DSA switch drivers the option to use this if they provide
> the supported_interfaces and mac_capabilities, while still giving them
> an option to override the default implementation if necessary.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  net/dsa/port.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index eaa66114924b..d928be884f01 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -981,8 +981,11 @@ static void dsa_port_phylink_validate(struct phylink=
_config *config,
>  	struct dsa_port *dp =3D container_of(config, struct dsa_port, pl_config=
);
>  	struct dsa_switch *ds =3D dp->ds;
> =20
> -	if (!ds->ops->phylink_validate)
> +	if (!ds->ops->phylink_validate) {
> +		if (config->mac_capabilities)
> +			phylink_generic_validate(config, supported, state);
>  		return;
> +	}
> =20
>  	ds->ops->phylink_validate(ds, dp->index, supported, state);
>  }
> --=20
> 2.30.2
>=
