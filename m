Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484B4294578
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 01:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410618AbgJTXjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 19:39:03 -0400
Received: from mail-am6eur05on2075.outbound.protection.outlook.com ([40.107.22.75]:48864
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410611AbgJTXjD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 19:39:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyV/nooub3iLqlAzusySbI2sIYMiOkb84NCrqWP9SDRx8J9LeivcowKkmnBPf3CqxClikz3pVvUsT73omjL1NJ5e3qrWkkogKNrCV8u5JbZdLbxjYGRJFGI4CN7r69KhD5kCqY12p6p8KxXGLbIc29/nx9Z/mZVhZM6L/d+OilMtDivzlqsYGe2QC8WzfbGjsBa07EDmoemNDqjaJMRas2yuh4hoUC2g6qzaap9S8UaL+6XiwuK8PhTSSbPnaoL0H/eP5tyYzokoSyggODztegis5Xmf5UELVcFuCd4Cz3ORTMjhKoc+esXDwztKfU/pjR3vB72Dk/4+7ZiGdzLn3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QBctoxi/Ga/aIEoJKpRQzAdpmnLF787PAgF3nViNL4=;
 b=DQ4l9M+HpPKo9FPYCZZCegeL88kls22jbbuLlKMUKYfgJ3e4ahc3XvfcqvBPw3vFusv5xtERLPKav/jZsrUjT00jHsrxlzp+20DSqvkr4rTk9zyNDHqkb2eCapeesmCyBnpnZ+THI3hK7BwCQ8Cd9KIURFmLgzariNcTO91mpfBPN6ZC24Pu8LExvfGup+/fF0xOXk+khUf6oKqtmhUtg3RWiNAKSaKQwYdwb9wkY8PhwA33tO4HjkizqJsEkj0gkvp9BRZ+T3m98OtsUmufeyItTTFtMfakAh5fUm/Zotp2ORHHqpHt7hsE61z2pxHYHh7X/8U5H7kUsYm+xFRvGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QBctoxi/Ga/aIEoJKpRQzAdpmnLF787PAgF3nViNL4=;
 b=p+WxgPhPVQqWXhC6+8KMLs2BiWdOHq8RwLpRaVt6VnmIGMKePXcOjJ21MSuJ6/0xzB8TGFOWZogm+kNCdjdzCPcqAJo8FFuFICs1TF8hA3fsgZk1iJXDmwwGoDCLdtAiEHouodWcpmGandv9R0SpuRUMOCYFOzSo+fXkyWl3dNI=
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com (2603:10a6:20b:a4::30)
 by AM6PR04MB4184.eurprd04.prod.outlook.com (2603:10a6:209:4e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.26; Tue, 20 Oct
 2020 23:38:59 +0000
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226]) by AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226%4]) with mapi id 15.20.3499.018; Tue, 20 Oct 2020
 23:38:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>
Subject: Re: [PATCH v1 net-next 5/5] net: dsa: felix: add police action for tc
 flower offload
Thread-Topic: [PATCH v1 net-next 5/5] net: dsa: felix: add police action for
 tc flower offload
Thread-Index: AQHWprM3+3GICwmxPUy+mJkFGzle6amhJvSA
Date:   Tue, 20 Oct 2020 23:38:58 +0000
Message-ID: <20201020233857.ifa4zjehupbvv5vs@skbuf>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
 <20201020072321.36921-6-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20201020072321.36921-6-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 032f978b-53e2-4ade-8945-08d875515147
x-ms-traffictypediagnostic: AM6PR04MB4184:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB41849C67A5B9FBBED19278FBE01F0@AM6PR04MB4184.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k3V5r+l4TkhEQLin5AmqYl9fkzVICi+fVzFOiscBY/OHP3Xu3faSh53KBvqVLLerQmtE55m3l4dwd5CQ3j6Ips4z+tn1ikbXPcqQrBTt34aowq7wWZq0AdDJdA2sxZ3+Mzy8MlfdEFzTC7aomUw31uTwYkFRwr6zIlOJuHDG6X7sExAySCrvQNgWBoGjUdycsYfFQKegfGGwF/D6zCZPdH8sbchjEjJDaoHO3IFqVY1DxKLIl1arCXEU3ktE0+/DbmEqkQgTJrURjJPDrNpXiiBC9LZXRhil2ffjxWJJ+gd67PQ3OHVsribh4FybHaoAFWoz1KYbE/jy1bUDzDNf9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5685.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(346002)(39860400002)(366004)(396003)(136003)(83380400001)(44832011)(2906002)(86362001)(6506007)(71200400001)(8676002)(6636002)(5660300002)(8936002)(6486002)(54906003)(1076003)(6512007)(7416002)(9686003)(6862004)(4326008)(76116006)(26005)(91956017)(66556008)(66946007)(64756008)(66446008)(66476007)(478600001)(186003)(316002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BkrjWPY7Q6RuOxSi2IWoiZk3IMVytCYvMu9TatzU0unJe9ZcfSz00PUcb5LMQwFRgr964AUBaau2oOCfiPJrkTlrImg8obIoNTMJ/aAZ9M/eSj93SwPH8y+lIWPVLKZxvLUiKN/uXX4DCIu4aaVhwD/LVX9/fbao713aXlF/3PEdW8KMm4QvCRzopEz5cSjcg0v+zlQFKs8vuZukaDdl4N3nh/bjldOe6iNPuPKWyVloskocO+hK40bbba+XxZch283HSRSc2O6I7diJiZcRrxl+59gWPycbU2AI7xLVQDDSpHZAeuEk0ZdRG2i2bG7iQ1/vRQMzbb6C/OyK4GtbErL18lWm1coAB9L6PQ2Z79YIsDOEC5f+BU9a9Wi6Y0e5+LEuHp0b7pewj1NLXPnbPCS2tKdsslaAk8cEnUz4GZ6G7KaOF+J+wm1rLIjTLpgB2poe+RGFhmthX7Br6W0odkhcI/cKEEgtnz4h5/pbPKa3lzLDqFUh6BeKb2mwpinWrTgYOaBTd1bju9iQCv20NkIUpSs3Fv7Uf6YDfh7n7xf0svV/hOmwdvUDkWY9Fmz7bwoS/4+rp6hpubm7AhxRjYbHpfiedwHHb940YBVM2NR3CNIlNQ7BQ/gihiS2W/q579NLaUCvsrf95ImlOaQdXw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C7F177C6A8CB2A47A4F7684B70FF793C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5685.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032f978b-53e2-4ade-8945-08d875515147
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 23:38:58.7429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lAgmHN2IE+zkiaDzV+r9BvCZHamw/aPxIivSphCqyVXNh5KHuwNi44tDKB/MLfd2j3GbRHbaXkaOXwHy/BLNgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 03:23:21PM +0800, Xiaoliang Yang wrote:
> This patch add police action to set flow meter table which is defined
> in IEEE802.1Qci. Flow metering is two rates two buckets and three color
> marker to policing the frames, we only enable one rate one bucket in
> this patch.
>=20
> Flow metering shares a same policer pool with VCAP policers, it calls
> ocelot_vcap_policer_add() and ocelot_vcap_policer_del() to set flow
> meter table.
>=20
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---

It would be good to provide a functional example in
tools/testing/selftests/drivers/net/ocelot/ which sets a policer up and
explains what is the practical difference between a PSFP policer and a
regular VCAP policer, except for the fact that the PSFP policer can only
match on {DMAC, VLAN} and the regular one can match on a lot more (L2,
L3 and L4 headers).
Specifically, why would the user ever want to use a PSFP policer.

>  drivers/net/dsa/ocelot/felix_flower.c | 32 +++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix_flower.c b/drivers/net/dsa/ocel=
ot/felix_flower.c
> index 71894dcc0af2..d58a2357bab1 100644
> --- a/drivers/net/dsa/ocelot/felix_flower.c
> +++ b/drivers/net/dsa/ocelot/felix_flower.c
> @@ -363,6 +363,8 @@ static void felix_list_stream_filter_del(struct ocelo=
t *ocelot, u32 index)
>  		if (tmp->index =3D=3D index) {
>  			if (tmp->sg_valid)
>  				felix_list_gate_del(ocelot, tmp->sgid);
> +			if (tmp->fm_valid)
> +				ocelot_vcap_policer_del(ocelot, tmp->fmid);
> =20
>  			z =3D refcount_dec_and_test(&tmp->refcount);
>  			if (z) {
> @@ -466,6 +468,8 @@ static int felix_psfp_set(struct ocelot *ocelot,
>  	if (ret) {
>  		if (sfi->sg_valid)
>  			felix_list_gate_del(ocelot, sfi->sgid);
> +		if (sfi->fm_valid)
> +			ocelot_vcap_policer_del(ocelot, sfi->fmid);
>  		return ret;
>  	}
> =20
> @@ -559,7 +563,9 @@ int felix_flower_stream_replace(struct ocelot *ocelot=
, int port,
>  	struct felix_streamid stream =3D {0};
>  	struct felix_stream_gate_conf *sgi;
>  	const struct flow_action_entry *a;
> +	struct ocelot_policer pol;
>  	int ret, size, i;
> +	u64 rate, burst;
>  	u32 index;
> =20
>  	ret =3D felix_flower_parse_key(f, &stream);
> @@ -595,6 +601,32 @@ int felix_flower_stream_replace(struct ocelot *ocelo=
t, int port,
>  			stream.sfid_valid =3D 1;
>  			kfree(sgi);
>  			break;
> +		case FLOW_ACTION_POLICE:
> +			if (f->common.chain_index !=3D OCELOT_PSFP_CHAIN) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Police action only be offloaded to PSFP chain");

This message is confusing and outright incorrect. The policing action
can be offloaded to VCAP IS2 too.

> +				return -EOPNOTSUPP;
> +			}
> +
> +			index =3D a->police.index + FELIX_POLICER_PSFP_BASE;
> +			if (index > FELIX_POLICER_PSFP_MAX)
> +				return -EINVAL;
> +
> +			rate =3D a->police.rate_bytes_ps;
> +			burst =3D rate * PSCHED_NS2TICKS(a->police.burst);
> +			pol =3D (struct ocelot_policer) {
> +				.burst =3D div_u64(burst, PSCHED_TICKS_PER_SEC),
> +				.rate =3D div_u64(rate, 1000) * 8,
> +			};
> +			ret =3D ocelot_vcap_policer_add(ocelot, index, &pol);
> +			if (ret)
> +				return ret;
> +
> +			sfi.fm_valid =3D 1;
> +			sfi.fmid =3D index;
> +			sfi.maxsdu =3D a->police.mtu;
> +			stream.sfid_valid =3D 1;
> +			break;
>  		default:
>  			return -EOPNOTSUPP;
>  		}
> --=20
> 2.17.1
> =
