Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41FA468499
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 12:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384854AbhLDMAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 07:00:11 -0500
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:3766
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344429AbhLDMAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 07:00:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXE+xTEVQ8VAyI8b+gi3OEgUIAplc2VUO0hADpao/R6DOG4yzxLP7uxkQxecyw5ZFvu0+nxTI7KOfByjmzAFizsT0fd794AlxdHuubFscX2IzANooKyaSdfxW3AQgji0SoWdTy6g1AnE4rRbi7Bv2VYCoRQZ24e5ON6N97yEfyEFXVV6kj3D4os45ERxgrokdSQ5CKQW3P5zq5vk+weJW42qikF2ivS4mx7Fm9xntPgaOd6L1ZJN+rRPDcakZhhmWUg0uYizEDY+TtEIC6NH2rJQG/JA7CVegjSYvpVpPNvbVPafUUnkSYhMf27rO80lFqC+qUFc/oc3CoAYa5H3HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=em5O+dMYhsrCbX4UvwbebKgNwCchOHFR7dKC2suYjLg=;
 b=lmMi5ceBlsGEm6dsBg/6zN/h4LdHkigEASLPOxljBtmBwlUZ3vVhsRJivdTQbPXNAob1nboEOYWxsYUkDycqE4ZNQJL4juSGrw7xmM4qgb19hL9u2Vuv02qOuGAdFIUCZfhf8UtYwo3CcQYUXFgTPbc5dLpZK/j49TsJtnRAIPxMwLH7t14j8JZnvjPwsj+9UOcnWWHdmsX22giknDIAf/gKefPi9l1Uvjnxds92x5cclYVIuMryE4QX7aY/vEA1o2A4R3wuXpe9E3JT7ppkXPe3pe+1VPBchXw3XTuuqkgNRXDpdnc4aHiC3J5SZWcZKHEMcP9/63GMOO5Ho5QUtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=em5O+dMYhsrCbX4UvwbebKgNwCchOHFR7dKC2suYjLg=;
 b=MiKNZm8UOrP9c5T+22I6/CV+r9EPZk4WeMlI4A7Bi/Sj941uayTooU/i+lKwwUBY9RENmBXmmVR3V5WAZKaNZpAjTIxgxFnvO3W2CpZgmaFhv8ppR2RG4I7bwOxlgJ+bgIpCYl5Ii6+sscmoSj9JauaB1oq9SvmvTLA28Qw5DTU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2864.eurprd04.prod.outlook.com (2603:10a6:800:b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Sat, 4 Dec
 2021 11:56:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 11:56:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 net-next 2/5] net: dsa: ocelot: felix: Remove
 requirement for PCS in felix devices
Thread-Topic: [PATCH v2 net-next 2/5] net: dsa: ocelot: felix: Remove
 requirement for PCS in felix devices
Thread-Index: AQHX6KptS1gl/DnuYUCbQHNxmSVrIKwiOqkA
Date:   Sat, 4 Dec 2021 11:56:41 +0000
Message-ID: <20211204115640.4wa4jhy3look7nkh@skbuf>
References: <20211204010050.1013718-1-colin.foster@in-advantage.com>
 <20211204010050.1013718-3-colin.foster@in-advantage.com>
In-Reply-To: <20211204010050.1013718-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e581e330-b768-45a3-d20a-08d9b71d22db
x-ms-traffictypediagnostic: VI1PR0402MB2864:
x-microsoft-antispam-prvs: <VI1PR0402MB2864D0FD3951877C3EB00531E06B9@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U0PQIHsbHZyGp0E0bY1k9dKXIWCyQXJ8j1eAM7ag42FtmvLsDvjcz39eCdEeR+08cNdXaTjJJDW8Bi68+mEXrMKjUflKwVLWMEc0uqJFs0xFxs3gOEvI/060kR46ZLr7UC2ipMnRIiSoNo/HvpsMajxaImYUf029k7xsz77sYhjSXu3wIw+0Em2lF5eYXhZFSUJnLNzZNXRDsbjSLOZwxfNql8evuU+50cVC0vWQ/odjtU9k0pgVcdPo8OIImdmcMccQRs6Yv8PWKGTHsbCpJGJuzhWwfMV6CO7Zlq4x3jLGRiqLi1H51O4c3kc70yFuAzJuX3hSN436wEJXg12crQsbQSvku5hva+h/ZNQN9wXwUzinNxp0aRJKBgn2A43J0ar8GWvY3LdBJGhf1YQh98UAsqtyHF6W5PyUd1gzitcng7YbRCTU5caFOLxWPU2yDCnwL77QOxJ+jPb4TFxNkANoJpg6zkejJwINeq27kcC58roCvf2sN7iqhqABRHt6EYTAZMmMmOFoPJAqJlYnRQqvnRnU9AT4G8wnHHso1EmEBimO7ZykSG16G0c4EPUuAuYtrpl/JL6octhSYdyXCyf3AnyGKMGPythjromiGckxnOzLwVNu89sLAkpTf1tRGxGp12Gk3sl9l4zUok8uDXy7KhOoGIxhdENCk9tm3RvxEAWXbo6JlRCIpkea4sRbSQnH34Y4mvKgFYpzecVvPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(76116006)(66946007)(316002)(91956017)(9686003)(66476007)(66446008)(64756008)(66556008)(26005)(83380400001)(6506007)(6512007)(44832011)(186003)(8936002)(8676002)(6486002)(508600001)(54906003)(1076003)(6916009)(5660300002)(71200400001)(2906002)(4326008)(122000001)(86362001)(7416002)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UNbAmzBAquHmDEN95IP6niyOKBQxteyG88sl4QC0zrylkE7XTZUq5iLzgtjo?=
 =?us-ascii?Q?KPB8ukXz8f1yE53lrbGECo2BRPwysZJOKQFzZ3CchM4tSip5TAMeAT8iSAip?=
 =?us-ascii?Q?32tLm2RafCylhTtlzyiwWtV+vpvdubFoiGkN31eGdjN6DWEloTNmlWDN2EpM?=
 =?us-ascii?Q?+cFznJmMiZVD7p9O4M5Oe8I8oyvAdfbr1KFLOuVeRHTILJu60WSgJDeERLda?=
 =?us-ascii?Q?c9i0hns+d7B1fApuzT3LhI9gopH7T5bQo1dcJ4BhaCdc62zs+ZC1O0vPD1hw?=
 =?us-ascii?Q?MSitvnljFw5pZ4QUSsatzJQwd/TBopZdy/aIuPHD+0sb+widPf71ZC8XlluV?=
 =?us-ascii?Q?DFgP77QxZU993vTJTxnBYENZZAXARBA1p/i3/0Gd95w/ouvqtSpIZx8CEpDk?=
 =?us-ascii?Q?zLkPy8EfVkagCL4PbPzyMLfbSy7F3O5vf+YxgdSZkAS6mPc+N/EV6IcKICiy?=
 =?us-ascii?Q?RaLS9WtnkDFtiM0iHLvNpotsJagR8jU7sKz72REI99V9E/I3wgXHhN7KXRL7?=
 =?us-ascii?Q?aTsD0vChQr6s6YOdOToiR9xQIeg4CuYCe95GdOQ4tN1x/6q3ns1vTQ+1CoCE?=
 =?us-ascii?Q?C9eacHfDDZg8qROHMMfEiqdwKip6JPsKLoYZbDwr88qV3p+rv8lp0lx4E+ty?=
 =?us-ascii?Q?8YFWCby4AqSqsyXQ0ifxVVeJ/2zy/jBucXSiAWzxZGJjVFWTjbNfhEjHw3++?=
 =?us-ascii?Q?LFfkkL6cjFk8kjfI+m70TQXSfTpmZCVz/r6gEaP9+NkTp52pZKfZgcSLWa7c?=
 =?us-ascii?Q?QG5eEUseeh+vEuRE9HoWdn9wB2eZFdFAGTb0gX05NFhVdqi/P8UbOq11Wb9X?=
 =?us-ascii?Q?6BeKEBkwkFmgoudyo2zWtOVnYoi8VO0l7ZEy8igXz9J+UCPMBbnjMeOCsc5C?=
 =?us-ascii?Q?ZovXZGMEs3/aRPhpzB7nNu6mB3+6kzJ7ZI/9ifuLJB07UrxEWE2XHezWO3uZ?=
 =?us-ascii?Q?g+8KXnNk+jKXCftuB8bvX6VrFlKwoJwthRlMMKVXQ+x9yr5xPoX6bqDX16/+?=
 =?us-ascii?Q?romEBu2nuyX/LXbv89qaAFxvX5mCvShfUk3EzQ6aDsZUBQGDsJ2ZOIkj2Dkg?=
 =?us-ascii?Q?MEhl6we7ScbvGOlOMBGZRnliT2fQe+cnoS61C83DdiyjE+FiDvoFcbzLgzL+?=
 =?us-ascii?Q?EyNd3WnyUj4ukvDe7VijaUHHJ6JFvzEbKSd2qCv8opfvng1My5qBcuq8tHvP?=
 =?us-ascii?Q?63/39zi713yIeqVYivzOhS2RzaDGbMQyOEA8Qph5q+LYv9i230o+/qmDNMTu?=
 =?us-ascii?Q?Wv+eIFPEAuiw5/e0sjsqFk5JBj85RTyBGd1u9xFQWVf9BDISeQ9HaqbiQTKq?=
 =?us-ascii?Q?14nFY2WwibIcracuyIfMrQIGvDqisFthqMsntBNFvqWdVYp5rRiJgZQW9hfM?=
 =?us-ascii?Q?wLZjfMjdWahkkNNqt/oAJhpLSDsk0SVjuzEGhRUhAPS9hsnaqP/YMncO6zoT?=
 =?us-ascii?Q?ALsByXsgnnTt+zfihpKp3UCKwmFhLfj3JkTfIVPDtK/Uy2vrr+E0y/1kJ/sc?=
 =?us-ascii?Q?dukFCt7+plJy4ctTLjuHqN39DlHvVMIkPsy/FldkbbuCeQS5H8MUSkXoxARc?=
 =?us-ascii?Q?NVU/P/8VKgvcEtIbD3TYQKXtUfP1qlGT1KTg/MhpD5uNxulxDEdr4xJFzyW7?=
 =?us-ascii?Q?T20X9Rf2J87aQSnyPQ3U+W8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1FB8B2BA82C9BC45BFC04E6FE23C7953@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e581e330-b768-45a3-d20a-08d9b71d22db
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 11:56:41.4683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 69sUKwAiI/XuZj+L4VbpFzVQe7iTMc5p4iMNy6PBmrbBXYza9B2zVGROroPtcPG9UD7VK3C/93+IDmgXkXCd1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 05:00:47PM -0800, Colin Foster wrote:
> Existing felix devices all have an initialized pcs array. Future devices
> might not, so running a NULL check on the array before dereferencing it
> will allow those future drivers to not crash at this point
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Actually, it looks like split pcs ops (via struct phylink_pcs) are the
future, and since the vsc7512 still has a PCS1G block, you should still
consider creating a phylink_pcs for it, and then this patch won't be
needed. But anyway, to make some progress, this shouldn't hurt right now.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/dsa/ocelot/felix.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/feli=
x.c
> index 0e102caddb73..4ead3ebe947b 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -828,7 +828,7 @@ static void felix_phylink_mac_config(struct dsa_switc=
h *ds, int port,
>  	struct felix *felix =3D ocelot_to_felix(ocelot);
>  	struct dsa_port *dp =3D dsa_to_port(ds, port);
> =20
> -	if (felix->pcs[port])
> +	if (felix->pcs && felix->pcs[port])
>  		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
>  }
> =20
> --=20
> 2.25.1
>=
