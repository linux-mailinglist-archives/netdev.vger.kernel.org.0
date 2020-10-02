Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84A3280BC4
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 02:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbgJBAuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 20:50:21 -0400
Received: from mail-eopbgr20045.outbound.protection.outlook.com ([40.107.2.45]:16519
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733275AbgJBAuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 20:50:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVTdg1dz5h18Ogx3F/d5BlbrHPscTg9HMseWfsGLfEngFYbTPd4BU27POd9oU3+aeFriTe3obmYBOpZfk1ljsoJjb1Ah7UKeN/18aeEhdBzhMOkLRRHlmwb4KhQM02NDOvNPCJgRJvjHZwsUkjfRC9tgXcy/zvqOWs/cNITBDKuCNuu3vBRfA8CpKHJFGXEBmM34BjJFCaQFwnjgAJOF5yQAKIhgr7sCReCmjFc+7lEszxpuI/uKaWlZ//mMmISv72lVb9bGU/OkTDWAKWwEozfreKtUluCNEon56ZnkfhFDn2kkhTwm6Fgdl/A2j6usxY04Bji79o+B/8oAGw4FXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sel3YY351kS7xH6iNnPEnOJxfxjwtWAd9znLidf9wis=;
 b=RE3o/o3qe4VYVUzdSxJUKUB/dYsPigC5k39Pc9b4n8I5dJjRaNk96q8n8Xgy4EDw6CHc/3IqIglweIqdWMRgsf6qFVt3Ni25kkm+EMZ9bs5cYMCE7BVW0su1VqPHRHVcM3JKFHO8SrBC1wbO0knFkp8V5jSkhVuViKjxG89eRozHNO7KcA1RzP5e3KRMYmniuUBBIhhr2+ZjIdPh8/DIND/1ARkr4vYMHScdlOZSsWgsC4PyCC6RC4Dr08bQYzwXdbhNFPZjtUSVnvKDFtNkZ123FeYWerCgy/zvmnmbDfYyJug2OYH6mteJBy4Nqnh9kTFQc1RPLB/ljHn204zyig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sel3YY351kS7xH6iNnPEnOJxfxjwtWAd9znLidf9wis=;
 b=g5NYXKHlBluEQBK3ry/9vKsAfLM4eY1vlT+acYwPP8SFPzva9mc/zb4yv41Lgl9XzXjdUGtsmr0oC6TxcqSLhQajssJsMF1G0OkM3vbk4bifW/29sIhtCQeGrOPdSOyB2oKtelqOYjak8sqF3jBoHPBEI5B0p5ufMmxI6d3zxZw=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Fri, 2 Oct
 2020 00:50:16 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Fri, 2 Oct 2020
 00:50:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Radu-andrei Bulie <radu-andrei.bulie@nxp.com>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH v3 devicetree 0/2] Add Seville Ethernet switch to T1040RDB
Thread-Topic: [PATCH v3 devicetree 0/2] Add Seville Ethernet switch to
 T1040RDB
Thread-Index: AQHWl/WnnE50IayoQkG0H2c1fXcQZqmDLcmAgABOR4A=
Date:   Fri, 2 Oct 2020 00:50:16 +0000
Message-ID: <20201002005015.hxtsu7igdfd352zb@skbuf>
References: <20201001132013.1866299-1-vladimir.oltean@nxp.com>
 <20201001.131005.812058315852168053.davem@davemloft.net>
In-Reply-To: <20201001.131005.812058315852168053.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1c81ea1b-c717-400e-9a21-08d8666d2139
x-ms-traffictypediagnostic: VI1PR04MB4816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4816CDF4E4CB0C2A67DF7902E0310@VI1PR04MB4816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D6ucpyMGYVBHRy1MLTbl0CgiNXR3BQexZ+2Mn2FR+vTFAyIw3MUklx0r5wk4I3zqTiH0BoAuNct2VpMMj7rC9xCPndusL3zPFtqbkxQS+73W8i46MELpb0xfz2XTsMBA3+7fZfBAVK4phNbMWMPT7SE2VSsjEozYaZcOxZ7OUAlO1o006R0YKsKdDE/b2/G4XYWQ7vG/1oHJp9tUR2T1bSI3F8xKh/0+Wz5Zr4Q+sefdlULoNEuaz9W8xG3FryXVhnacCJBnDAaT2vO/HerSUWomlpGlYKb5eoOVpEOu3aUKbUgUeFdlc/EuJM9+LAUPcupQyDO5IcjWrDvc5NLjJyiVYRmdu1nEkQJWhIMags4UwMEQfXeOzA7KwAPqgmOz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(6506007)(2906002)(4326008)(44832011)(6486002)(54906003)(4744005)(8936002)(8676002)(66446008)(66476007)(316002)(66556008)(64756008)(66946007)(76116006)(478600001)(1076003)(91956017)(83380400001)(71200400001)(86362001)(6916009)(5660300002)(6512007)(26005)(7416002)(9686003)(186003)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: i9JUU7Q/4lp7rIHxumPj1NBRGHjipUqHTMY6h+d4UXxzLOkQatza6UUnW2p47kNrnvgj1B9BPqNv9VM1vcHneErB7SLSnq8EllCVqokdW8a5ABz7AZWSuJQwrbF9L5MkyirUApNs1PE6n76BmgF7KgCk5tpkuGo9SBij5ofcGQ31YBxSpnq4mj5Io4/OY2wyma7fGogmKp+IgnIweD1y4JWtp5JwAmjVU4qQ4RgQC8ABOo6puSbeDDYbN10ZaQzki+5bSUp7FsY49duqA9Qz+rIsGwEH9tnM+D/ufaR/nDjHZTA2CDgeYKRm6rO+6zN2GYPmz/lswcCpSrghXOMF0OLszlaP9N1YRYvEhscAsgMqvfod7xN1UAyOknBNgMnDqoTsyUYkMt8i5hBWeXUo9wUZwsHZopB2VsTiuuK0fjZtHw3E37r0HtGzxH/j2HstKh055NrWBjRjUrIRYMfXvE4WgHaBHUT9+0j42RcEo4kws+vU27+A8mC6YeUfiqEKS0BExzUGiV/yoe3t2BfGolaHAUXMfwZ+E8figQG0belip+2/wBbQc3jcqIzs3JUZXJRY05fcdbY7ZljZPx6BGMXslTc505F5aH734fi9ApFt5VbRK+Qo9HAQG6SjT115vN4GTTqlxsSoqXb7JveQBA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C84A2490DA0CB249994B0FE521FB6194@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c81ea1b-c717-400e-9a21-08d8666d2139
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 00:50:16.6747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O/ziGaoXZ8Uvx+waduTXaACg7V9xV7IhSt67FlUstTUNA2Ds98xtS4L0qU5fRKEXUdhuGev+BjdreFVurFEmEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 01:10:05PM -0700, David Miller wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Thu,  1 Oct 2020 16:20:11 +0300
>=20
> > Seville is a DSA switch that is embedded inside the T1040 SoC, and
> > supported by the mscc_seville DSA driver inside drivers/net/dsa/ocelot.
> >=20
> > This series adds this switch to the SoC's dtsi files and to the T1040RD=
B
> > board file.
>=20
> I am assuming the devicetree folks will pick this series up.
>=20
> Thanks.
>=20

I can also resend via net-next if that's easier (the last commit on
arch/powerpc/boot/dts/fsl/t104*, as per today's linux-next, has been in
2018, so there is no conflict).

I need to resend anyway, due to an epic failure where I got the port
numbering wrong...=
