Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1508852E062
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243882AbiESXNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240519AbiESXNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:13:05 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30073.outbound.protection.outlook.com [40.107.3.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE58F688A;
        Thu, 19 May 2022 16:13:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DqCjQMasKe2q7eDxhevdJBn9bJF1kPJiOvvpAMbioBKZt5Y/52ZUDUwA3+3x+6G6cH/nWqRt0wHTox2VlrHG0nyp1lbzVwKfDyaTXse7ZYoBVmtyAfW+Ql2rC+b2/yag+HVYo02AUBOiW0eGCJioAGrKTqjreLv8oNIPfWnFm8fIuUePsOr1NCxqk/mQ7yMfyhrKmPq/RkbJrHQdaImjKGv7BAA0gNC1BLNC5Wu4hi2x9pF6Hdngr8Ft1+Zr+6W+afDy28M2MB+Bt4hXwrj6zN7AKhgxOywFlvdEuBgXsj+JZbs1Pgxaj6V8wCNH+bAz0EaWFR07OLRaNH50iCORkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8I476g4jwMzR52DfgS4dwC+ymC2pZ+n8GhGUKqbyVs=;
 b=TQxFPZwW5i1Q2x0sF+yk23Dc7nA53qyrpbQKlY4vLDCjxRpN7YnaImPzVbfxnPNHBfJpYvLp9MwmTQiDC8QeaOYfbqG0ByRuX0z4IdPmmluzNhi7tS4SYw9XrOOFjlO0nH8Wqjc2RAEHQR61mj40VUouEw+wrMxLz6AMFUoaZvAITQne1fS3cx+9is3htbcJkozstPZYmFVoBAQ+pjNMAs+9RdS+uPQNo3nTkcKnFLfCRcQGgu80BTpO98o0h2L69UKWC1VcFsv4okyCbfvzImh+RhahhgLbex8IcA2TzxSvtQHJhACIUXBeQL0GGln2tWiOo4B0pZaMBXTK3a9J3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8I476g4jwMzR52DfgS4dwC+ymC2pZ+n8GhGUKqbyVs=;
 b=BxKcHP84WjY9njyoxlIn/SmD9n65/dELxeyfmltkijpbSGvaaB9ctkUtIyDgHJnuanBLbDb1oPamc26SM07gOK6rkpNI1e+TQFrxrv1Kh+L5CCsoHafkxyt6xyxM1liRWeVSbSUBt4kM/EMn6J7tDv0nyVWExFRIalDHGXSRhJI=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by HE1PR0402MB3625.eurprd04.prod.outlook.com (2603:10a6:7:8c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 23:13:01 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5250.015; Thu, 19 May 2022
 23:13:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Pavel Skripkin <paskripkin@gmail.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ocelot: fix wront time_after usage
Thread-Topic: [PATCH] net: ocelot: fix wront time_after usage
Thread-Index: AQHYa8CpkMuTuLmdfUG8uVuIyNZDm60m1HUA
Date:   Thu, 19 May 2022 23:13:01 +0000
Message-ID: <20220519231300.k6hizfdu5chi7lpu@skbuf>
References: <20220519204017.15586-1-paskripkin@gmail.com>
In-Reply-To: <20220519204017.15586-1-paskripkin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4346d22-bfe6-4007-81ab-08da39ed1eb3
x-ms-traffictypediagnostic: HE1PR0402MB3625:EE_
x-microsoft-antispam-prvs: <HE1PR0402MB3625CB177C3904C176FF1F7FE0D09@HE1PR0402MB3625.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OnFt+GeVIjsM7tK/oUzvXqdOeGWVUFspdQ0zLfrPb55X4SpKTDbfY+VbV9GvDJy08TiP1P+WxSK4h/iFfuuxvskjO09UAmV7OJy8VtW1isa+4mORY8RFFEqTisewCp6GCybcJt1Hq/fZzdv0p9GKLbcnaSTTwXyQrCop58wmXQSAaK1M/hWTom3opPmOYWoSN8q2ocKARqX6B3LUTZwvsVARF6YSD33BKzMdAbqWzaFCtG8lCeZt5HnGK5gPZMPBWDN9DOXMy9r/K7hPVrYXogjD0HqjAhx8AhTxfZgSVFBnbtaBS0jbxiuBbGhfhYrZ/8z0qGgxAw6Dcle1SPkX8ihrO0WAZnM+SPtr39Oh0D8mA29LWpQbGLlAWt+OjLsCW6GilFydmrRpczwn5PnAK+OJ3zrXp+ayEMYPXsGaiGh2EmzG3/vLCOwi3VRMj5NMO1j89SgYjIEXZJ/q/P3mHGwG0m7SVxdAn3v1viTrOEz3fSQYU57+FHEKqnMNvtwrszPb32khBnezQgOCQt14735Cr2NUS6BeLwDUtnx38CiCD6/JfT5wNUe3Yyqa9csiCbkkZm5/Br3kKc8dPJLkAgEa0yhI9bX3vRBYpRK108H997GUKTyrAKxIj3C1Q9fkxenUxR0YFBAQ5mN7n//B3qo2sVgHk2MpAZd29W7eq19hb6U0Xsav++dVygcItcsT4D3bMdvKVs1PI9FGrHYGYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(508600001)(71200400001)(54906003)(6486002)(83380400001)(1076003)(33716001)(6506007)(9686003)(66946007)(8676002)(76116006)(7416002)(5660300002)(66476007)(110136005)(64756008)(4326008)(38100700002)(38070700005)(122000001)(66556008)(44832011)(2906002)(316002)(91956017)(86362001)(26005)(8936002)(66446008)(6512007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Wbej8ZH3LRBgqQx5yj0WBugWwqEPDCeOx4IOla+dQIU7EsnodKh/NdV1pl?=
 =?iso-8859-1?Q?lRK4X5FSVnoeszDWgpLrVQHVA+Dihw2EbPBewEO8YcioZG/pQ3jc6kQsmb?=
 =?iso-8859-1?Q?7VRktLM+4IhrkeT+6Y/ta9TDIjN/knLHjcw2YNVZ6hfPBCrhnJc4QsSKqp?=
 =?iso-8859-1?Q?XlSuvfU+a+EubzrZLcS9xlxWQLGe8Bt3Z7PTYCiALdfbfJeQOoJom8ywPJ?=
 =?iso-8859-1?Q?1MnXDrjlaSKVqys1JVUynf4tqxfyGpNHYRdbqIx/s0ee1nDoZUS4KUcsV7?=
 =?iso-8859-1?Q?3CeyAXeS8yx9/XmBhIZpyzGhAFVAOyyI81VSQSAo7CXYrtX/Cl7afDAItr?=
 =?iso-8859-1?Q?VQPLoq1N6VNqAzIRyyiOKodujak09fa1i5OB7uq8XP1MSnfbbiBvxaiRi7?=
 =?iso-8859-1?Q?UsUTLoVEeUrl7zLgthvbhEGAjXDnBUA+s9vY1c7S+LKdu1OcEOtZAYoUZ1?=
 =?iso-8859-1?Q?BBHT673A977q4qCykhKN5KiPcABFxwjoqRvP9RK2MoAMqZQaGo1ROsaM0L?=
 =?iso-8859-1?Q?ubdRT+qXLB/vyhoacw2ZW/oH0/nEZB7Sk/SOtYMkHUbpiZmHHB4k8UnI7i?=
 =?iso-8859-1?Q?wcaESrx7xhrXiOSVJoA8rc0vLgA9urQJHU1B/zNdOL9XAv+JzWdTUGjOog?=
 =?iso-8859-1?Q?HrsuG7+ZcLXqDkoxEk93UMs0nqbf5ldznX/rmtqTz9bdXD1lIElPfZSbiq?=
 =?iso-8859-1?Q?Ps6pbqEsZHjU3LaYKZt8jzwhwkZCETyAnkLXbPKt1y7EV/Db/eALEXThux?=
 =?iso-8859-1?Q?+PZiVzh3P+XJc/NaHzlk2rQ2XNP8/Y7WazXBvNZnVFYxnzVecp4loGjQLP?=
 =?iso-8859-1?Q?V4q8y31KlQTAWJp+bpTNo5mtagcLecGSNxwQwlkPp9UfaKuigByfYwgzrm?=
 =?iso-8859-1?Q?REEdoDcT1DvvAWMWJtmunLIS7nFUYr+gljfdR0HMV/v6tgSON9TOAOuiqK?=
 =?iso-8859-1?Q?05P4pdzlAaYx8DWoD7nOeZTkOkFhjdvWIgGkb/eZagtkt0O82YTqEeCi46?=
 =?iso-8859-1?Q?E+4ewxqcg/kNSuHnfzq+VGdr3JDepneMXXBxCosEjophzuIHdA/TLiuOAc?=
 =?iso-8859-1?Q?PeMzlfWekaEunfQyQ0sZco4kxHpq0HhlWeeLuyK43Zzj+FXv0ul0RQc3N6?=
 =?iso-8859-1?Q?lhjLACUrDjDVwl0pSJ5WOZ6eJ14yYpgVNiynyglyRpOpOxqC+WgpjGV5vl?=
 =?iso-8859-1?Q?dbJr68SniRYo6LOwJV2YwyDYvOQgLr4LYPAbwsmASwgWO6N4cH1L1tDLEq?=
 =?iso-8859-1?Q?z0x2MxlBoyiPfEqD4p9Cj21PVkdvrit1TOOXVzsEUND3OC7jXrpLUpzcA6?=
 =?iso-8859-1?Q?KXvbLO10vWFxjScKdk+9jsotxrGLY0zed+R4EEjW9gZN/lvIK1C2ti4AWg?=
 =?iso-8859-1?Q?tl7bGs7Shto5StI4pguhJ3IG5JDny13Ld3k63mkUB/XAfHBxDwQbmk+y9Q?=
 =?iso-8859-1?Q?q6IzixQIlMYukar7j1NpBQfp++TkVXdsWyPIS4NbzquWWLz+mO30sRVB2A?=
 =?iso-8859-1?Q?rW1OlYcs9wiJesxxuOlLx54uYT7bRljQHJJqTJudGtTZ4eN5MPLnt5dC6O?=
 =?iso-8859-1?Q?u4S8JlLGehtmOY5vQf8t8vGBusYNheLtDd7+jGSTRI+NwPC9hHitdUCcVW?=
 =?iso-8859-1?Q?487DJGrGrXsN9X4cUdapv74pkIPGz7H/tIN0g0FZN8fT6rN/BFNex9aAZC?=
 =?iso-8859-1?Q?x3amuG+FOsOOBKSoAVuWcX4rN4RJ288+bnr5kZlsOYY5X7I0OvMl+Nl+xm?=
 =?iso-8859-1?Q?+n+4S/DIwln6ou1tVZMwa+7fakV1x+ZI0qsnOMZme5YspIHcn8GsiqW0be?=
 =?iso-8859-1?Q?mnc4l8s2QHYYgtEWJiw4Ti1xs2BSP7c=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <91315C6ABD636C44847A8AB68522EA7F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4346d22-bfe6-4007-81ab-08da39ed1eb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 23:13:01.0990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IDBaftsSu6cqsnsaweFeBb4UCaJTNJfHDZCRMCQ1aYF5n4gJ/ohMMCmdVoZsbAXV/ff33RLgmBeWm4PWD/ahBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3625
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 11:40:17PM +0300, Pavel Skripkin wrote:
> Accidentally noticed, that this driver is the only user of
> while (timer_after(jiffies...)).
>=20
> It looks like typo, because likely this while loop will finish after 1st
> iteration, because time_after() returns true when 1st argument _is after_
> 2nd one.
>=20
> Fix it by negating time_after return value inside while loops statement
>=20
> Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_fdma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethern=
et/mscc/ocelot_fdma.c
> index dffa597bffe6..4500fed3ce5c 100644
> --- a/drivers/net/ethernet/mscc/ocelot_fdma.c
> +++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
> @@ -104,7 +104,7 @@ static int ocelot_fdma_wait_chan_safe(struct ocelot *=
ocelot, int chan)
>  		safe =3D ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
>  		if (safe & BIT(chan))
>  			return 0;
> -	} while (time_after(jiffies, timeout));
> +	} while (!time_after(jiffies, timeout));
> =20
>  	return -ETIMEDOUT;
>  }
> --=20
> 2.36.1
>

+Clement. Also, there seems to be a typo in the commit message (wront -> wr=
ong),
but maybe this isn't so important.=
