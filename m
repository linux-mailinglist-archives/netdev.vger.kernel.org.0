Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88EF276050
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgIWSpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:45:39 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:47840
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726988AbgIWSpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 14:45:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQ4+IYYRp+H2B/IM5uyWJhJlFhFcyJUotxL7kxnUKe9tnwGkpCN/rL/acejJ4GOdapVYc99JAITA0OhZf0rTi0KI554yIQ+ohA3iEHr4osC3O1pBXp/02uE25AMRt0tCeUOMNK2HmdgwhaeXXZU4A6l4Ju5k/RNX/d2m5pSeTC9PpICCsF7tmTmWPbwFLmmDYypF2VEZgC4oDkkzWe6WBrn3A0xiiCaccu+l0fsk5+ZBQMFF0B2bw+VZxwxSEVJNdM6XjAsl+uoSwGVJ+9dqI31gYl+y5IODvfm2TdvCsMrjy3yVvoYDEM7sROv7caoXbSJ3fI5COddUOapy2IiN9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTjfvBs349rd82EYhMtukhsego3jMvQOtbBgCW+GhQg=;
 b=BwikPthfJBnG2IZkp02u2pM3J/rvoxwpbDRI3aJS8DiAckym3pXeGQrEw7YlBF3PmVP70wJVJ1Gv5XODfs4xevViBMSkr3evga/AApWrOmvYXPjx6tVsMiTWpBPZ9EsXTtPTDYBxYPsS0rChHQjfS14JUqll7apa/05BN9RDYwgLG2TOi0Pfvx++vz1oso+rrD5wRzMlGjHTiY+80FpU3EBFt7L7nPlB0y8Yra9kcrrQnxw0tpDNByC84kMfPc6FLFmlLd6ypaJb8jINA5QuYkEuOT7Ujc+nmc+BsanaRyqWV5bfEVbUMPBCuLW8udx72T5ikam5aZjwUyY61gmKEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTjfvBs349rd82EYhMtukhsego3jMvQOtbBgCW+GhQg=;
 b=ild/TKFnxpQ9qeEcOeAZwj7cD6LJrDwo4ggn24OQn1nCL0cOKBU6C0ofSWkSabzQQkKitSdGoQkn7rVsnbGExExhkdQGxxJjOteXRnQITZDkoEsL2EHNyPhgengJWmL5CboCfcorUQImAV85F/fQvVZlrW0oiFfOyw8XvYNlQxk=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Wed, 23 Sep
 2020 18:45:36 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 18:45:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH v2 net] net: mscc: ocelot: return error if VCAP filter is
 not found
Thread-Topic: [PATCH v2 net] net: mscc: ocelot: return error if VCAP filter is
 not found
Thread-Index: AQHWkHnmz2YCazd+akWUATz6cMufTql2knwA
Date:   Wed, 23 Sep 2020 18:45:35 +0000
Message-ID: <20200923184534.xkzj22zxh2dy3sk2@skbuf>
References: <20200922004657.181282-1-vladimir.oltean@nxp.com>
In-Reply-To: <20200922004657.181282-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 61915141-e424-41e3-b175-08d85ff0dbe9
x-ms-traffictypediagnostic: VI1PR04MB4816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4816C84C94847491ACA052B4E0380@VI1PR04MB4816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7awOZnDagcitkbPsGfm2uh8dMgmYgRu0S8DvcyAC01ZkiQ19Pe7Dv8kgGzfL2YoXzEWwItvGiMW1piVeVNDRzBEXw2P0gtF3L2ZEvBCUkGdmv1NQ5wSeht9dHQU0KqY4DEuvv5U9DDQQkHDiXTYC8xYecl5mbUXQXjt+pQzqQnp+nNFz0KzPtPvwW7vQasiIEIRp9mZhrqKjoe79luX/G2PnsuRpwMpgAjdANQak27BiFbLWdqf0KnKD0txAg99CExUPO2Irb/9a82DounQjP9Pxs11JiJmveHO7M/tndbS/LQtcGBWmST+1KsWld0h0jiwkIQm+sVM0XXk2RXP4tQdn/4s09iDvKXour7Ur55kbhcOGZwxp/RcM9Ywou58s
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39860400002)(136003)(376002)(396003)(366004)(4326008)(2906002)(66476007)(110136005)(478600001)(316002)(6486002)(6506007)(186003)(6512007)(66556008)(8936002)(5660300002)(1076003)(71200400001)(66574015)(66446008)(64756008)(8676002)(83380400001)(86362001)(33716001)(26005)(91956017)(54906003)(44832011)(9686003)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TnAD7iUYSXNAZLVVY+MmR2PcJqyRZ1GSGE/o2v1bcW+Hp7xlPIfP7boSQxFI5TDwkcjqeeHN5eqIlx/EjGgIBmhT0zTPEm+nJkHTbzQkO1Z7Vw0jWAn5EHXMLvr382/6shk51xYv0OTsUzC3boT68IwLzbHk556wVdBp8ixhVD40y0c+VRrD9BnBmv3ZvkhUB7+oh3hQ2PPOcp9ERt4LDBSfj4SPvF7HvEiuQ9J7sG886i9ebfPojVl7lMvpMOyhqD7IgubokCebBnF765rGQRWCQVWm2600iMJiImxuXhx9K41UIYP986jjvMU1NDXPD5C3ZBzPOPRbq2y8/CNo7U+xP7KgEYPJh1gMS/Z1Fp4AGWdM9fVOrJsxKhXwJi/87q4iY9ASJi1YPkWIUqI3iA7AFdOJ/CEJfYBk3bL/zT/voIKuQ8R6rybvBJ1L22ghzVNr8SOceKISbjVyF/GOKHNoNCLHYChlcAyRTHGFo8UX6rl++//S6S8LgW+1tVkhIOObm3DCrZwGYehwDqeEwI9gMnqKu/JgTta8Kq2Q/7r6tkykxDWY4pqtP+kTAOUx6IMv6g3w28cSTsBN3jCHEY8sKaOtmuN9hASdOE1EiDtZlVMF6FzKOmYaXdgPENeZX8Z8BbPkvVKae/HE5ke+ng==
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <5B0E931EE3EF6F4587DB70D0B752BE80@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61915141-e424-41e3-b175-08d85ff0dbe9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 18:45:35.7391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XM7Aca/dGRjirtonrH5uYXFlOvAxiIRgkCXLu7BcxaDln5J2t041uYItXIwbfTUytKt4Ay4FWOcHphdv8hgXAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 03:46:57AM +0300, Vladimir Oltean wrote:
> From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
>=20
> There are 2 separate, but related, issues.
>=20
> First, the ocelot_vcap_block_get_filter_index function, n=E9e
> ocelot_ace_rule_get_index_id prior to the aae4e500e106 ("net: mscc:
> ocelot: generalize the "ACE/ACL" names") rename, does not do what the
> author probably intended. If the desired filter entry is not present in
> the ACL block, this function returns an index equal to the total number
> of filters, instead of -1, which is maybe what was intended, judging
> from the curious initialization with -1, and the "++index" idioms.
> Either way, none of the callers seems to expect this behavior.
>=20
> Second issue, the callers don't actually check the return value at all.
> So in case the filter is not found in the rule list, propagate the
> return code to avoid kernel panics.
>=20
> So update the callers and also take the opportunity to get rid of the
> odd coding idioms that appear to work but don't.
>=20
> Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> Add Fixes tag.
>=20
>  drivers/net/ethernet/mscc/ocelot_vcap.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethern=
et/mscc/ocelot_vcap.c
> index 3ef620faf995..39edaaca836e 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vcap.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
> @@ -726,14 +726,15 @@ static int ocelot_vcap_block_get_filter_index(struc=
t ocelot_vcap_block *block,
>  					      struct ocelot_vcap_filter *filter)
>  {
>  	struct ocelot_vcap_filter *tmp;
> -	int index =3D -1;
> +	int index =3D 0;
> =20
>  	list_for_each_entry(tmp, &block->rules, list) {
> -		++index;
>  		if (filter->id =3D=3D tmp->id)
>  			break;

Please don't apply this. I meant to "return index" here instead of
leaving the "break". I'm not really sure what happened.

> +		index++;
>  	}
> -	return index;
> +
> +	return -ENOENT;
>  }
> =20
>  static struct ocelot_vcap_filter*
> @@ -877,6 +878,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
> =20
>  	/* Get the index of the inserted filter */
>  	index =3D ocelot_vcap_block_get_filter_index(block, filter);
> +	if (index < 0)
> +		return index;
> =20
>  	/* Move down the rules to make place for the new filter */
>  	for (i =3D block->count - 1; i > index; i--) {
> @@ -924,6 +927,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
> =20
>  	/* Gets index of the filter */
>  	index =3D ocelot_vcap_block_get_filter_index(block, filter);
> +	if (index < 0)
> +		return index;
> =20
>  	/* Delete filter */
>  	ocelot_vcap_block_remove_filter(ocelot, block, filter);
> @@ -950,6 +955,9 @@ int ocelot_vcap_filter_stats_update(struct ocelot *oc=
elot,
>  	int index;
> =20
>  	index =3D ocelot_vcap_block_get_filter_index(block, filter);
> +	if (index < 0)
> +		return index;
> +
>  	is2_entry_get(ocelot, filter, index);
> =20
>  	/* After we get the result we need to clear the counters */
> --=20
> 2.25.1
>=20

Thanks,
-Vladimir=
