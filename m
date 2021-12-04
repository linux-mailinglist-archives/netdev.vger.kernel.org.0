Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AAC4684E6
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 13:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384963AbhLDNAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 08:00:42 -0500
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:11598
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233028AbhLDNAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 08:00:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmBGCIlONDh0jXbxPh0gDlXUtYorU17FwyJioNyBo0cyjqQMdPvu5O66zSrjzhyIA0WcArQMgrhZ56QovPgxaOKcLRc0TMRx57ibAby1hNweb3RBB5mvBAAFQhTLfU414fGywgi6klOaeEsvT7p5rqwKihvby9Wt6b/HZRO1ZnPfFnX0uf9LnE7/eCHbX/OcN0zEJpB0QxHcizSF5YdS2l7vwSwDCjJmfAqxmlSrpafcY98UyH/XHee9PpNBhHDNqFW8MHUJB4eCFWesVUqMD7hkCu+AGS7v8AGozwkBz1WtkP15E+WITVUKoADM5SaaogpZMvGXrYojUiUXKz8FUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3a7cLOe+p1TiPJ9WvcW0Pkkd57lfglGxHqDCAinEMH4=;
 b=k5sc2X4JVZ9GzOkbShxAzAML07crcMaJtJ1u01hPAMo9qwPwfYAJVCG74DU6vyNXJvn5m8XKE83ROjzcWhOMHqZeC7s1NjHcsxIEDAruphgazxk+FsAEr5XFgo4XI5OQsrH7LjrKCkO2Icw/9X4I38vQ7hW3GGwBEOP1njsBTvpddXzib9ek7cLFOetd33dSioxvB8IM/rnRfncIN7rsfCIALcygmhEA87IPV7vN/mzCaJDZeqVmsbCsRE2/L/4Bg4QBTIgx9GsBJYwnkfh8qaTGreSsNnatS6XR89YNOkxTvntFMynNTqon1AstNzTGUGvVKF4rhIuwnSIwonoQxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3a7cLOe+p1TiPJ9WvcW0Pkkd57lfglGxHqDCAinEMH4=;
 b=IJAbtbbQAj9YrFH8AR4VffpMQP02hqc9QM8Fci1qAohJpQVCc/3gjTkWtISAb0zYU7/RGJMiabtNKNSN3SZxm1QxU5wuJvj5eJYuFTUfEMGSI4WkddVz2WKr1FqsFLTP6hBeZCTD7w3xYrgzQHtVoM1WSfLpDHXsKmwH4nNZVAg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5855.eurprd04.prod.outlook.com (2603:10a6:803:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Sat, 4 Dec
 2021 12:57:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 12:57:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@ACULAB.COM>,
        David Lebrun <dlebrun@google.com>
Subject: Re: [PATCH v2 net-next] net: fix recent csum changes
Thread-Topic: [PATCH v2 net-next] net: fix recent csum changes
Thread-Index: AQHX6Mr02OXjnBHhokCw+/skHPdiBawiS0yA
Date:   Sat, 4 Dec 2021 12:57:08 +0000
Message-ID: <20211204125707.tn2w2uqlphqq23l6@skbuf>
References: <20211204045356.3659278-1-eric.dumazet@gmail.com>
In-Reply-To: <20211204045356.3659278-1-eric.dumazet@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd1c5f81-f8c5-4f80-8e5d-08d9b7259489
x-ms-traffictypediagnostic: VI1PR04MB5855:
x-microsoft-antispam-prvs: <VI1PR04MB58555BA7439B498E7892D6CCE06B9@VI1PR04MB5855.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EGQ/s1glkXbIoP3kEXr688t9N0ydqwZmsA1AOPIBdxR2f9U49piJETB+lIVwgX7fklgOMKuUV/bWDsY8i3cHrH+95AjtuJUy5tOI9WGW/XNySFW+b6zthP9HnINaiFflsRGBhWCVsKEVAoDbqAuNdQ5AzRuXsR+2jBY0JEoAUtMUxRMvb2ba1ftua13vAnWoHgxGv7A8XBhDgbgjkG4yQhucBpQHln2RF6DwjzGahGLZxK3zpgKdF1bqMZmDT9Jpjcw6DZaAe1FhXi/D3td+wXoctKdcQq8kTfu2CRQPg1RoaPY+mg9vfzoIK8u45uFHzH7I8+CwMjaIpXuHXPOkLjT/1pDPGt1v1zFeNYJKwLhPYaRyKxcTDjVKizZlsIZSwAfEgPvpIN9CVHw6jwxXnSCZZhtzND2gvGi91UeoubTwRz7b2gU/HX5A+DhblFB0AgHo1+Zkp6ZZQzzb1PXfrQZwWyH42oU9m1Ozz5HzTwYfLA3URAvS+H/HwRv6++f17n4f1LB8CSBibbmkluG+QhYQ0Lf/rUU+E1j7aOWEzQX0auX3Fmvu4Zqg9OULrzrOpMVc8n1hxdH4zMAYdZMuvM2xBcHupxP3aSWLmKn35iU+uJMA4ag4B5pcBchfRWMqIXQ2poWuy5lNVYcMrYTtFQQWgHoPaQIYleGUyyx2bKufDzmLUvb0CAbvFmbifJSHNJqndsiwHxbQGoHTSEE4Mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(316002)(8936002)(6506007)(508600001)(2906002)(76116006)(6916009)(4326008)(66446008)(71200400001)(91956017)(86362001)(1076003)(5660300002)(38100700002)(122000001)(6486002)(9686003)(66946007)(83380400001)(26005)(33716001)(66476007)(64756008)(54906003)(38070700005)(8676002)(44832011)(66556008)(6512007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LUeuWmS++UmguMz7FXkj9Qnr92Yya9d+aOrIsslfsXLXn2ayubCKlsDbX/5n?=
 =?us-ascii?Q?j93xRyK56fTYe8K64rvwU54mcN58XCLLeA0ZiZIe1RPRLLOt5bJkNE26sGUO?=
 =?us-ascii?Q?h7DKUKgiPvgx5QW1ecCxauuDTc2zF8s4IaqGS32C1OBE6JrhB9c1YyEAlmvB?=
 =?us-ascii?Q?OEwLHFxR4b5I+UgL/gXtTKjrEwsSJmVYV9EV/uddfO2imX+fKXTi6wYG9yPR?=
 =?us-ascii?Q?QhBpR1aofJyjbiDNfxP8ie9MoIu/DDdLKwHWdOPWM8uBopbPsuULiNRGpUr5?=
 =?us-ascii?Q?ge3W6fOiNKMA9Vft1xukPNevLkmMnfrk/f+8T2PLg1m9yVkn12ZvsAHcFOoE?=
 =?us-ascii?Q?dgYf7jcvvrhL4F5X75T4SKCeVdKtLay6xYr0pezZ6SI2EIgr7xQUhjnL3AM+?=
 =?us-ascii?Q?uPqrBTInFv9T1TFCfhaWE9LJGNFRPev3cwuJEuNEaMo7qHzkwsnyYtftMM9J?=
 =?us-ascii?Q?YIvU3smSnIHJ2Q+3GtGPRfqIqvop6RzdgzZ66WTQa5ODY64ZU8ULdKnOi6Yw?=
 =?us-ascii?Q?w0+tqjg9zoHduHEBX9osOjURCiUddJOVDY/q0GLc0s3x/zevkwj+Xn4zi0dK?=
 =?us-ascii?Q?Y1+oNxiB7luiiEgpsuyni4M+iIMeX3F+W/BQBFiBnmtR1GgO2QrtgkR9NO6L?=
 =?us-ascii?Q?RLdLTND4cadzMxVt/tY5qyIczL7KVVKUDuI+e7sVaIf0L1gK4RE0SUyHXEyf?=
 =?us-ascii?Q?3zNAr2mXvR3MYrdz7vS11o80OxfSLUDs7Pol5aQjeIWRm7ZpHvSKA8FKPw24?=
 =?us-ascii?Q?ESMe0LGId1QZESVYxie4E1AS1nb4DHyqgyvCzTFjLurPQMOPeWEiqDjWFeuP?=
 =?us-ascii?Q?C8EWg4nb15O5y/hxhHTc6j1PqfWu+75XgPOJZUAPUrPprIzMwuyWSEOrE/Tu?=
 =?us-ascii?Q?2kBcM/iSdKTBG8a6Wj4ZqD6HHf+FI9SYvT0YcZ7+D+CspojZoA5QV5Y5Sp/4?=
 =?us-ascii?Q?h0RtYToxhWkx3oubXkpd1rZzbM98YXJVs8R+8mTPlSZiSqe0ADqTDmBs4YkD?=
 =?us-ascii?Q?+pI71koEoWh/lY3+75ntxz9eL33DO3OF7xH8cwRpm3KZqOpuwgcRR7n6jyPg?=
 =?us-ascii?Q?VthaXF31KFS7L+MBmj0zU+cmG18l5ot13g3TB0NA+HzC1UPXzZd195l3Mwzn?=
 =?us-ascii?Q?Critaa4g5A/sp7Kn86rg1Vai/Gsq/LdD/3VHCTeEFkuM1Yqkt3Swi0uFaTc/?=
 =?us-ascii?Q?6QZn1uO4uNfQeizaecetL1VXLhdMbKyFc3mZBo9xREmMNy3cYc3/H3L5MSPN?=
 =?us-ascii?Q?6fSKtiuud3FJQYdT4Nq0UnbzHtLmkEGA0oZBgXlaHWwerC+Qv/6uPxemwt5e?=
 =?us-ascii?Q?mckIxBF4XobDXP5b6XXAjREYRsTYD8cAz5FkvaBmix9qrmHMbShvEFahN2ET?=
 =?us-ascii?Q?qNrXwjzcP/7XtKF3vbyg/hjCUJ/Jsdx7OlJnnjUvkdsxhMFFvoVSAUmqG/iT?=
 =?us-ascii?Q?bWZIXF3Mbz8XvV3HIb8B0uz7vLIQN1+1bSFtEH19xzbkLGGB72/4SvPJJlwE?=
 =?us-ascii?Q?q67T82m6IPFwHlObFia/7rWTQAo19Sq5JfPq/Hj40cOxy5FBABDt6UctztxA?=
 =?us-ascii?Q?dl8tEZcGQOuTiGDfPDjaWm+KsZoYryQXt5K/iCkRqQsdTuGf9vtxXWEowuIP?=
 =?us-ascii?Q?/gbjUc6NzfpeScZG1jjn2VM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D2AFADDFB952D44698DF83667DE49A3C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd1c5f81-f8c5-4f80-8e5d-08d9b7259489
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 12:57:08.2882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fWEhyhJOlIxyV6T4sxE4OCN2Pi8gEahwAPrTq81mBXyq+NN2UW/zzZsRJYZxaybmiDHCCewXZSqaQWaXXtTPyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5855
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 08:53:56PM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>=20
> Vladimir reported csum issues after my recent change in skb_postpull_rcsu=
m()
>=20
> Issue here is the following:
>=20
> initial skb->csum is the csum of
>=20
> [part to be pulled][rest of packet]
>=20
> Old code:
>  skb->csum =3D csum_sub(skb->csum, csum_partial(pull, pull_length, 0));
>=20
> New code:
>  skb->csum =3D ~csum_partial(pull, pull_length, ~skb->csum);
>=20
> This is broken if the csum of [pulled part]
> happens to be equal to skb->csum, because end
> result of skb->csum is 0 in new code, instead
> of being 0xffffffff
>=20
> David Laight suggested to use
>=20
> skb->csum =3D -csum_partial(pull, pull_length, -skb->csum);
>=20
> I based my patches on existing code present in include/net/seg6.h,
> update_csum_diff4() and update_csum_diff16() which might need
> a similar fix.
>=20
> I guess that my tests, mostly pulling 40 bytes of IPv6 header
> were not providing enough entropy to hit this bug.
>=20
> v2: added wsum_negate() to make sparse happy.
>=20
> Fixes: 29c3002644bd ("net: optimize skb_postpull_rcsum()")
> Fixes: 0bd28476f636 ("gro: optimize skb_gro_postpull_rcsum()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Suggested-by: David Laight <David.Laight@ACULAB.COM>
> Cc: David Lebrun <dlebrun@google.com>
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks!=
