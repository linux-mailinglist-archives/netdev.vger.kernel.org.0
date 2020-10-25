Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739932980B4
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 08:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1763079AbgJYHmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 03:42:12 -0400
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:3104
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390858AbgJYHmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 03:42:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAYrP5QNWA6nNWulgcSsSP9yjvpbcolfWsz+sJ5tcHq+7tLzTmHiH/bqipVF94uCkfoC1TJAzb540I4/nk3TtwE5ceCc1pjSCunUrqvIhg0vEmMtkTAGwd5JnlZTaidMO5AIsD0xF4o/v+bsczoSw3E/RMPV7r0mVaEdYvplgXHm6G3WxEQ+tJCG22pOxvp7ng1xOzo4U3nwkU8up5eJ1cue+5/kOOKjiykPubb8w5mLxglhuX0fLEal/yDwsdUHZThesYaXbiJexZP/v0XPdoX50zLI0V7w9gHjsm71lhfqYP3e9Bp6cK9jhUg2wmnnV5KyzMRJkdTQrGl68PKx3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsH4hT/TBh+k+w8byxsDNwFapYnpkyKqn0RbVImo1TE=;
 b=JWw6QBS/GjiMW6sq4VC88SAul4I4DUZkPf8cJ7krVTF07KaOLXFckNkxWgqa+8WN9uQsh6v37qYdNHHem9REKZQPhScIrxm81CvRpFFSvmWOVCSvfllpkflwnOTp/Yq6Yh0Dbxp71cYIVvOE9c4VVPXPKWvP+YvnGW9UGqoxw8XNfsmS/fccqGOFePIls6wOBKSJizdZTedlQBkgwA/lnXPlk1yefXIzAarlQnEsFzArhKQ/TU7WW9UpqowYvc/FwsJDVqb3xxBVLNSKVkoYH6zJNFZXsGlFK3fC43pOJWmTF4BocerDMjWqg2xowvSug9BlUZXJ9PLLw8TsEjeUEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsH4hT/TBh+k+w8byxsDNwFapYnpkyKqn0RbVImo1TE=;
 b=fQjt0cxIO5TBmWt2+Hd1GmLhtC9oTPcRn6fivdWtuqzKbgs9mJU2/g1TsfzbCsLGzN4zu8wqxg7I1ZoHeQ+xOdPozzT1V9AHNZI1SnrOt+Qna5NlOMdOD+uJZgsMasqFkq8aPsiGavdX/535fcC9yU+UOHVejlqdYuVnPY6Ytnk=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5856.eurprd04.prod.outlook.com (2603:10a6:803:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Sun, 25 Oct
 2020 07:42:07 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.018; Sun, 25 Oct 2020
 07:42:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [RFC PATCH] net: bridge: multicast: add support for L2 entries
Thread-Topic: [RFC PATCH] net: bridge: multicast: add support for L2 entries
Thread-Index: AQHWpLUt1nu/YGQhyEC74ZUB+LFl9KmhzHqAgAYjAYCAAAvGAA==
Date:   Sun, 25 Oct 2020 07:42:06 +0000
Message-ID: <20201025074206.sdtapjy45vqbsjof@skbuf>
References: <20201017184139.2331792-1-vladimir.oltean@nxp.com>
 <98ac64d9b048278d2296f5b0ff3320c70ea13c72.camel@nvidia.com>
 <20201025065957.5736elloorffcdif@skbuf>
In-Reply-To: <20201025065957.5736elloorffcdif@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2514f1e2-b132-4e6b-9829-08d878b97921
x-ms-traffictypediagnostic: VI1PR04MB5856:
x-microsoft-antispam-prvs: <VI1PR04MB5856DB16E0EB9803D5B6739EE0180@VI1PR04MB5856.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3iK98/twlTYAJGtAhyI5jmvlHYw/HJNZOdzA17RXixFCI8IVn5vPbNJUJZo8s0cdld0l7+jCVZBJLcvh+JVVEPJS18+2WSr2iT4ULbJ0AxwFliVLmLqugixqjwVvb/AW0syWkQBVXmBanInBhXn2Hw7d14s9690FFdWcMy8PnjRl2ijmgMNRM6h+uH74T8tAaIDbj4tt27oBDw+2dVAEiHP8DQNjg22glmZqWDW1V8Z2qSeyB9gvMD8jBFKEqqqC+wO2KXYec8/ddK+rVPeTZo9yJFP2mRbwfFE/hYLK+MI8DiMg0xuJlciZWcPlBpLcjNan0ynPiApdQDprRJ1hbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39850400004)(366004)(136003)(376002)(346002)(33716001)(9686003)(86362001)(71200400001)(66446008)(2906002)(6486002)(76116006)(44832011)(66476007)(64756008)(66556008)(66946007)(4744005)(1076003)(5660300002)(54906003)(6916009)(7416002)(6512007)(316002)(8936002)(26005)(6506007)(478600001)(186003)(8676002)(83380400001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: m0UqU8Ddi2jtnO4HHluDoTQTxcYg4fIqt2Vk58zmd0XTaQfyUVz3jP78+45qYVwtUeFupzam8Sr2N0cFhzwjbnjLuUTPsHI0HWsEL2gsGV5AYRMOYfqhTf5W3z3wumwv/+Aiy7W1mMoi3z/Zt36+63SVxFOb6R1jY594gBuwniayYmlvcgViTCWktSLNk9ZqPd/GSMc6Tgk1QA70116aYyJbokM+e5zcB9F3p1kxe6XH2767RQRrOSunRSOUbqdoJoujbiOBL3THfogtu3TTKaCOZVMZfvpOdWjFoxllRenrTaLOqeTFWL11ykEMAXXNClZlv4CZncIAeXMQZQcqpjeZh4IMHVkzE+XsJVclplXIerOzqU7pS6xSChdTRFneWrKpWgcMN8HjO1oYuvHGxonkgxGEASdmWN8s0eluoIN3y17+H/uslmcfJrRJWCAL33hfF9nq0llOtCWckgAFBI/nce+VxEUiPpB2xf772gmUgt7cQMgiEH2ZyZjD6ILxBIbKMs4JdeQUAhGzwkFqP0TyX6stMhgY+EO8fWZ+Hh4sP+pIJFixN4c7DasCdhSnRUQXeyAyaEHT9XpyC8yEeFqK+6bw1bC3cSwpbbmn4NdXkETQ6Nxza0EvxKZiAiOdsGN0XSS2tzFCfbzJrp2nhQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD64E3253E4D9545ACC1B6397B7C6CD3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2514f1e2-b132-4e6b-9829-08d878b97921
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2020 07:42:06.8923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K38kmEP4yw7xBMv5V+725HajLxFqJYMM7si9iqVKqvVofoVx1nOBaBK9OXK0kBPwoxmYW8IhcteCNU9e5YpcjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5856
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 25, 2020 at 08:59:57AM +0200, Vladimir Oltean wrote:
> On Wed, Oct 21, 2020 at 09:17:07AM +0000, Nikolay Aleksandrov wrote:
> > > diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_b=
ridge.h
> > > index 4c687686aa8f..a25f6f9aa8c3 100644
> > > --- a/include/uapi/linux/if_bridge.h
> > > +++ b/include/uapi/linux/if_bridge.h
> > > @@ -520,12 +520,14 @@ struct br_mdb_entry {
> > >  #define MDB_FLAGS_FAST_LEAVE	(1 << 1)
> > >  #define MDB_FLAGS_STAR_EXCL	(1 << 2)
> > >  #define MDB_FLAGS_BLOCKED	(1 << 3)
> > > +#define MDB_FLAGS_L2		(1 << 5)
> >=20
> > I think this should be 4.
> >=20
>=20
> Shouldn't this be in sync with MDB_PG_FLAGS_L2 though? We also have
> MDB_PG_FLAGS_BLOCKED which is BIT(4).

Never mind, I'll make it 4.=
