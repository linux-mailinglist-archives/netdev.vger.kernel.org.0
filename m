Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9035C29151C
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 02:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439948AbgJRANc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 20:13:32 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:3685
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439943AbgJRANb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 20:13:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnsUbnM+J9WisO2lpreXYaKK9B4xPaXgQTxUOGLY1O1vhwgbazezys95ifnKDWn3psRpjOL4/mx3IntbEvTq/7Owb8781th5m0skHFGuumCEEdDxwETO8+rpq1SNAKcXprzE2ce8ff8zwqtX9DEEruKxYBPMtBByEdzVB88KOUh2YlFg/lGGe87Lr5ZuJ+FsePi3nkBtoCTmPlPuLVM4moxSWpiEDKnbkX0wKYehNBxav3ox+2fNi1PzJLZJJ91P+7EiIAYBKmzsdhjUzJ1flTaBSJ0VRCzXaPA+6uuoBt+4rhvVXCgCr2XwQrsbF3xpSLdrkPi96+6noMpxJq8iEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MomRFC6Y1M4oRuGhoODYnFa76H+XGMs64vOf8mBED5U=;
 b=ProdbLrl7I3yNTB7og21yelSd9uL+V584BWf4+/vSLN80tDqXvHGultLkRyvfRcOTQzIeEnTTQ5j3QO4g9EenUVZQqXjXBSQir4yJEOl6T42O78tzAiZs4u1ikFClr8UeN4bbGahQE0wY/2gKjU4/jADXYtZHFHKD5aeK6e68hau7uIkgQQwGrPfRLxv2eVseh3oQsocjG0XSEI28UmCmPsHpC4PaEyQTLcLohR1DDvpDugZDLud13lT50kQ472oA9jeY96GUkX2R6F2raI1cAW+5xkroHA2rBS+9lIKbNGqyuTZQMssotXOsrTEYsrwjOiDKAKTn5f5tTT+zLCA/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MomRFC6Y1M4oRuGhoODYnFa76H+XGMs64vOf8mBED5U=;
 b=TP9+N52DhZwZtR4dQ5yXFEBPlWLc1kDkQXNffM3HgFM6qpek9vL527eziMotO54QYvJ8//eDhgTJcFMFDlO1w/xotonmGCHm59ZsW20d437ltlCV4JVgeWviWuQYUjCjlcHL48ZPKbjd5OQVcPH6BDw+9QrD7507hRJevCn9igs=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5856.eurprd04.prod.outlook.com (2603:10a6:803:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Sun, 18 Oct
 2020 00:13:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sun, 18 Oct 2020
 00:13:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Topic: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Index: AQHWpM2WRVElJamqkEeHVtfDsj9ayamcWGgAgAAIdQCAAByHAA==
Date:   Sun, 18 Oct 2020 00:13:27 +0000
Message-ID: <20201018001326.auu4u7mgfnxk37nx@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
 <20201017223120.em6bp245oyfuzepk@skbuf>
In-Reply-To: <20201017223120.em6bp245oyfuzepk@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4e0a4b56-eab0-441a-11c8-08d872faa352
x-ms-traffictypediagnostic: VI1PR04MB5856:
x-microsoft-antispam-prvs: <VI1PR04MB5856EC0393B1DE5770D713E6E0010@VI1PR04MB5856.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v1T27a6R2GJOveT+hqtoXLzDDsn0c03UEs2UjeiIiwmo/XMYBMZpjMZQqbUubqHNUudsDj/PivcZGb0QCd77dLKZbyOZ2rLLvcnTwPtCVads46mN2NYJbhJaxRz0IUDY+tD4tAMYNXZoOrtW77WZcJLx5xJUkZenw8jJHKHmHFAlqCMnBTRzxAmGeoY/aB2uAk++b4v6K/ENo0tErmJK7WBHzKJAzFAfpPNe5zOfQL32shr7iUHeVZjnGuhMtqv2JFpTjyy/nLMN/e4GOAP0v8d7MLxOayGF4smqasD1asqRi5rdxBaeSRkWS9vFxEUiPCkzxy10kZBRAdmUEBcbTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(366004)(346002)(376002)(396003)(39850400004)(86362001)(76116006)(316002)(66946007)(71200400001)(478600001)(8936002)(54906003)(91956017)(26005)(8676002)(33716001)(6512007)(9686003)(2906002)(1076003)(44832011)(6486002)(6506007)(64756008)(66476007)(6916009)(66556008)(83380400001)(186003)(66446008)(5660300002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7AIEtfsBiQwA8eYyPN+DV8vaKuEQYXsHYJSBxnsyP5r31pJ6JD41PAiXEO7USWCWTZp4Bf0ZYGVVr2VBUVB5I6WybDEOgLpNehWWsVavaHJqAoU7rizPcN+g3LIDy2bQ+Jl/0nEpNihuWYSBOZY9SLZHAw+NZFuhHXlDyvDxJTMxq3y7J8SaV06BcgjrJps23w8ngOrGahJw9oTW8Mk5GHrHXEID1NFtrYb7NNAl0ylZenxvhigJj5UzBBrGOx+FpgDzkCyHhU2MGtkeyy3HfPP8ffUqVQSf4mJg3uBI019VvjcvWG8u7d9QsM/sgQbLVVhaAWSNFdY4pHgOjoV0vSam7pbW/F0Q4pbWzkkScTiiPyY2g7VBFCyKarf/N664kieUZprxm9uo0esH/t8zmT3AfpBH4eCHGS5IjqSaR0Bf7ZA8B51YH3BMQ9rqUjvjsnhoy2vmj6ZlL9/G36fyyKPsjkBYGjy4O+pHbvwXkNQCHSyj8VVgXz1eacOw2yHez1pODfyCc9ZWrqNz+nrflSwR6223LTkr83NJvAalJ431oYN9nApem6XLIZHPqCPqV9fb82HtYASQMv3nPGx4x1RB2fhb/2Xdr3XoovZPh4RJMCsRgfhvNQJ0rzPpXx9127r7Xl2FhEmelvJkDA2vDg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B34F98A07291DE40B3463BA6CF3AB8B9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0a4b56-eab0-441a-11c8-08d872faa352
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2020 00:13:27.9081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGylmRyJaGNONO0iIyUQpd6x1Od6E46FkIM0OcmhKNibXxLnuofrE7SpEcfZZzqH8qOxOzVL7U23ZKA5DBXuxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5856
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 01:31:20AM +0300, Vladimir Oltean wrote:
> On Sun, Oct 18, 2020 at 01:01:04AM +0300, Vladimir Oltean wrote:
> > > +	return pskb_expand_head(skb, headroom, tailroom, GFP_ATOMIC);
> > 	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 	err =3D pskb_expand_head(skb, headroom, tailroom, GFP_ATOMIC);
> > 	if (err < 0 || !padlen)
> > 		return err;
> >=20
> > 	return __skb_put_padto(skb, padlen, false);
>=20
> Oops, another one here. Should be:
>=20
> 	return __skb_put_padto(skb, skb->len + padlen, false);
> > > +}

Last one for today. This should actually be correct now, and not
allocate double the needed headroom size.

static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
{
	struct dsa_slave_priv *p =3D netdev_priv(dev);
	struct dsa_slave_stats *e;
	int needed_headroom;
	int needed_tailroom;
	int padlen =3D 0, err;

	needed_headroom =3D dev->needed_headroom;
	needed_tailroom =3D dev->needed_tailroom;
	/* For tail taggers, we need to pad short frames ourselves, to ensure
	 * that the tail tag does not fail at its role of being at the end of
	 * the packet, once the master interface pads the frame.
	 */
	if (unlikely(needed_tailroom && skb->len < ETH_ZLEN))
		padlen =3D ETH_ZLEN - skb->len;
	needed_tailroom +=3D padlen;
	needed_headroom -=3D skb_headroom(skb);
	needed_tailroom -=3D skb_tailroom(skb);

	if (likely(needed_headroom <=3D 0 && needed_tailroom <=3D 0 &&
		   !skb_cloned(skb)))
		/* No reallocation needed, yay! */
		return 0;

	e =3D this_cpu_ptr(p->extra_stats);
	u64_stats_update_begin(&e->syncp);
	e->tx_reallocs++;
	u64_stats_update_end(&e->syncp);

	err =3D pskb_expand_head(skb, max(needed_headroom, 0),
			       max(needed_tailroom, 0), GFP_ATOMIC);
	if (err < 0 || !padlen)
		return err;

	return __skb_put_padto(skb, ETH_ZLEN, false);
}
