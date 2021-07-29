Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF123DA73A
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhG2PLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:11:01 -0400
Received: from mail-eopbgr1410094.outbound.protection.outlook.com ([40.107.141.94]:6956
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229970AbhG2PLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 11:11:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvX/6aObPkYYS/DArbTADPmNFL8Rfa5geZ6w6P+YxcQIrbEhGn9MKzCWKyiYvtGP0wFo8UdFIMdQ74MhS7MPCnjXpnhChXs+lJpKRMWniFuGXzg8uB46UzB9RBYXCIzBH2fxquP2mjniShz0eyiKVDWBFFeDev2FYru5zD6saUvo9tJVLMRAe75y2c/ERZPvX+/TlE/2nfoBD3RxNPOX4jNZOALkOxuURZkFKuC0MwW42B8HHk+tkoyvH5B0MVc/o+AahjzuznAljeqMl+B3klTnCMBLuykDbo5pEIFkm5ObOrp7NgFJSlveyt/XBkWAQO4SUEkqQ+Qpd8SjDNQ1Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AB+pr5ROoceOmTDmbquljgfAb5CfhD0QZN2g1H2yN8c=;
 b=fuCErWaOCaTRKx2JKqC02NX+Osc1fHpKq5aUY0YBKGyx2IJurV4HJDyCXHicRtcsqtuqn+DcnEhyayLoXLTd/+Bz1MlCyvxPFUXmNAtXFoZtzqkatxBYzaEOJfrx/yl4tGlE1ifFZcGt65cuYQEJgcvmvg3EUj/4zSua9Q+bjyBN+d8BzLbw9XTMFdJfy9sBpEs6gf7UwbDtStOlgK8cGr8/vxi8HLhZbNU+xpbg1HZriNvzfWZtFFCDiEabC357hrhfEgRMhwJb0oFZSBeu+GGnQMptKLNau9d7Uptxggv3gsQDD+b+szDo3TCz94RsHqUYHqeiDfsp0DKqmutCyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AB+pr5ROoceOmTDmbquljgfAb5CfhD0QZN2g1H2yN8c=;
 b=I9ksqAj0WlMbHwIaZA+drofcTDx7riCkl1Cs+xtEFwsIs8Imnxy5XpjZd46e+OhfAJaEljZEDJcEJHB+h+CRDd7akANcp/HstRRoZpnxP0i03edNE16Q+wbiRkaip6LA4TktNqOIPYLhKBnDW+EKraSfl167pRc5kedCoLv4Rwg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5476.jpnprd01.prod.outlook.com (2603:1096:604:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 15:10:54 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.022; Thu, 29 Jul 2021
 15:10:54 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next 08/18] ravb: Add R-Car common features
Thread-Topic: [PATCH net-next 08/18] ravb: Add R-Car common features
Thread-Index: AQHXfwPhbPRJmcaBiUSgc56SRE5qLKtXU5SAgADbmTCAAEBwgIABpocg
Date:   Thu, 29 Jul 2021 15:10:54 +0000
Message-ID: <OS0PR01MB5922149AE3ADA137B64C400B86EB9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-9-biju.das.jz@bp.renesas.com>
 <d493b1d2-6d05-9eb3-c5f5-f3828938fe56@gmail.com>
 <TYCPR01MB59337E1C3F14B0E15F0626D986EA9@TYCPR01MB5933.jpnprd01.prod.outlook.com>
 <YQFfd6jcdyAPobIG@lunn.ch>
In-Reply-To: <YQFfd6jcdyAPobIG@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 168c8316-8e31-426d-ed63-08d952a30f92
x-ms-traffictypediagnostic: OS0PR01MB5476:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB547681E76739255BB9D8826086EB9@OS0PR01MB5476.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YaePiqzIJa8xpdNtEcXT5PEqFVykrwUd6Rx/UBdeXjvyXUKVAubxGT9zrAwqzCwniVuLFdMyp7tMdqkfyxY3XNkhFrzUudMr7TGssBLlITuQWASzshTRnpqyGPAbGA3y5GLqSzwFcEyB+u/jWnQ7lTxEd8LPp9bln5x/jgEXyPMIpViJszRwFXHuLXxdO/UlrGCLDT0h2NRx4izbqi+xU47KA3GBVWm7Un9a13twOWuiqCRlXQjmzJ+13HrXLACEpaMCqDQDvm9b9g1CGBrI1lhBDXCpMtuFK9R9wbOpR8QGvykXkjIUwuNkIggGOMriEAcJAFXNlJJ5XOaekF2fJWlTXgoJyUu6W6R9gr9gt5SOrQ1gHEdlJnbKaevk0LxqSjzVE6XOsxBfqHFxpGEtSk6uD3GZ3OxWzwakeOOX7Rmc0BMRbUo08yeNe3ac7LM0LaCY0uqletWpErkSlu4sbN1HjIc9b05b7jUq2ofuxV1jgPgVFWhqMxLOWQVbvxEFB6AjGjOkNTk3NMYiSjnsmzkzgNtZnVoqj8v3G7RYGbKZESp2p0zufJBZ5ChTF2W169b4PrFS8SJKhpTuLxjY7Z7V8BkLDKFcXpYnw4tSkmr9BV42CDDiIV+yZ77tCT68UeNsD7ig3E2tdjAu/RuuVO3KzYybDltwIOUxafZg2AH8A7NZ5mUvxxun3pq+W4OLvWMyKsI0xmT5AwfiCeGlig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(33656002)(86362001)(83380400001)(316002)(54906003)(6916009)(7696005)(5660300002)(71200400001)(478600001)(7416002)(38070700005)(8676002)(38100700002)(76116006)(107886003)(4326008)(122000001)(26005)(66476007)(66556008)(66946007)(2906002)(186003)(8936002)(64756008)(66446008)(52536014)(9686003)(55016002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zsPrE1lH8qMt/caohfcF9akDneAdj83MeVwZhT1SycokHQs9wyrnOmTB26hC?=
 =?us-ascii?Q?mmhPRvdERoufAtqG5Uu6SBI4WjWnWYjcBmK/GZPIlPQRfPPa7cLilwxtABTU?=
 =?us-ascii?Q?mbUOTPW/iTKHkRPpQ16K+cuyfWNKhMfjVB4/o7BnXvUenj/q/425WeK2eVnz?=
 =?us-ascii?Q?iOIUx0DFkiQErO7QqaNFTs+rU2rDkjj85DCxrQG5nyiaYbB7ECZqHZ21KSEU?=
 =?us-ascii?Q?YTbKfrcQZ13QzTgeDln22PEzl2V1Kw5jvSfv09J1BIfCW3Eu27QrYgEZEKx6?=
 =?us-ascii?Q?4PQ5lA6bWyCpX8Pn9gEhRedw6aX0wzihL4UFUdmyzh+toLVd4eMNUwUEBD05?=
 =?us-ascii?Q?ZlSMuJubzaLgFriu/AKZsVQwhSEbLOowkFHcd6NGlt25DJrS7UUe3pPFyxDb?=
 =?us-ascii?Q?w//4atOaotA/+blrj/R/tRIoKjc+Z8foy1u+p2kKIcqgVAES0/4GkJAh+8i3?=
 =?us-ascii?Q?QJ8n0jV9pvz7RHwGB1LUdRKpAuHOrfjlqNTxMJ9nzs3JuC5hYqGsopELXHxg?=
 =?us-ascii?Q?RKTlivYpUlAisk5w1aI17E7cYHn8Glo3qfjyJTWivJ9iKw97Cq4Ebm2WXD9H?=
 =?us-ascii?Q?GAvGIodZzBVqFOmiT7RhXu/PuWldkXvZixkrPG3yCaUvGrEKGT8VExxT54mJ?=
 =?us-ascii?Q?hTO1nDDelHKT/KawRinR4JGTsqezREkiWjJ0bd+Dgjq5rCK7kh16oW6ZJJrB?=
 =?us-ascii?Q?AuWWx3fzp3ZtMzh2cOP3vim4l1dNrslbWLpsR2ZC8t906AYFLb4KHAM7/oiU?=
 =?us-ascii?Q?W1ULkLQ5EwvEEoNJlPCZtrI+CIQqaYzHG7oDTUiVi1mmAzNvvnA9wnG03zR0?=
 =?us-ascii?Q?9/z9rE+iPPQ6QJnvvYgxMnpBQ/n/wv2jB0wADdZemfjxOf0WuakFuxWHtHNG?=
 =?us-ascii?Q?ObjZxYYtvxK7FT1QqmjbGrmZopgWMAdWr76NL9Gd7yJOqgiacFe5hPq4B547?=
 =?us-ascii?Q?RggbSXQo1NpLpXpyoneQK+j40jMxOWD29Vuzzz5HFxxik3m7G/ITeE/2XgTo?=
 =?us-ascii?Q?YvR5xdBgtcqH5FDkqi2GuMtJRDsPESSFBF7I5yKxa/RClAucaAiuoqjHXmq8?=
 =?us-ascii?Q?PUAlTstLssZfOxEtyyz03G7Y/25CycVczX4MG78y/wc+dS6c9bvprqb9jzbW?=
 =?us-ascii?Q?BzN+Sv8MYcnAS5foe+hGTfj4QV6fWTBcnHv2U7bbXI72poJFCJCKNvpFuHhU?=
 =?us-ascii?Q?v/svPw0+7ZgXNRk4SGPulRPw1D4Xvn618GYPxcO6DJBDoVSttmfzIXy2OI29?=
 =?us-ascii?Q?Vd41cWiTf0ZqsUO1kk2f4allApFg0Y0no01pda/7WXeVnbJS+CaQVAtF63Cb?=
 =?us-ascii?Q?dPuTxpt0bLam/1n3qlw47yMM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 168c8316-8e31-426d-ed63-08d952a30f92
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2021 15:10:54.2058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VXxjmsEqgPBGoMhLS5kU29iuBo7nDWCw1/jrmgv63Mr9La2ur8PdiIPqONw/6AnmOY/1ySXuoE89/0CaEKXPRc7aMUNhxjARR+FoyntiQcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5476
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks for the feedback.

> Subject: Re: [PATCH net-next 08/18] ravb: Add R-Car common features
>=20
> > > > @@ -2205,8 +2235,10 @@ static int ravb_probe(struct
> > > > platform_device
> > > *pdev)
> > > >  	}
> > > >  	clk_prepare_enable(priv->refclk);
> > > >
> > > > -	ndev->max_mtu =3D 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
> > > > -	ndev->min_mtu =3D ETH_MIN_MTU;
> > > > +	if (info->features & RAVB_OVERRIDE_MTU_CHANGE) {
> > >
> > >    Why? :-/ Could you tell me more details?
> >
> > RX buff size =3D 2048 for R-Car where as it is 8K for RZ/G2L.
>=20
> RAVB_OVERRIDE_MTU_CHANGE is not the most descriptive name. You are not
> overriding, you are setting the correct value for the hardware variant.

Thanks for correcting me.

> Maybe name the feature RAVB_8K_BUFFERS or RAVB_2K_BUFFERS.

OK.

>=20
> Also, putting more details in the commit message will help, and lots of
> small patches, each patch doing one thing.=20

Agreed. Will send smaller patches with more details on commit message.

It is much better to have 40
> simple, well documented, obviously correct patches, than 20 hard to
> understand patches. But please do submit them in small batches, no more
> than 15 at once.

OK.=20

Cheers,
Biju
