Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632924210B4
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238629AbhJDNvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:51:42 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:33270
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238713AbhJDNve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 09:51:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5y9qOg5hGTIax6eAGWQJCOPq2MUTWsFpMoooy80+2zi5gL5j91m1LrrljwHqWklzzdzdBMseehGOETw/YDXtFBy+Bk5rwKq+24rQ9ocDqzL/UmjufnAsJjplRr1Sc2CORQ15csSuVVwdIE/P5eThFZw/XezkLp9sIpukThHsxO5TlHz0BdRMZ/YEU0bmn3ON4SuyZGEOx0Nv4Zs9+BAMqC71CNWyNG7mPWftAVYIYTyG5vzvBdtsov8mqaey6/0ZX6PDij6Jjc9wyjeDHqq0tADPgf6dIU7A4q7xPhJhiOmOGRdMXqikdhIGPFBnpvYAszn3WB4Z1pLpIpH1wLbqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+zZBj+CUxVRePzvi4O7uAoNRiu1+rbfk3yxsnVjnok=;
 b=C7iIfLUfsJnNSZTH2+j/rp5IYHtYePTns4MRTikOLax0SVP1xRqdzdTHhEKgXUaaje6u1wgz5NhrQe9vQmy+ZLuBi0Kr/4ujBFOOYZg18Zk3gjlj7oK0uf2MOmrWj7n724j0wm3r20rC+DDXjONmfVpOSf+ytAky+hI1zzo4GdpbgkazRX7N3gxx23CqrHjKhA5Aa5z0Mk4wHrBWaqBeEg4nxrTCj/r3JCL5sI1dQp/nnQbxKVasyXOMaEJkyreOml+xx/Fq0j9iU/PBBR04MfqG/uBlmXUUTLWKbxGt6bWSX4IBdgtbh3Wy6JZpM1HcBE+PHhLdkC54p/9hDGIfvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+zZBj+CUxVRePzvi4O7uAoNRiu1+rbfk3yxsnVjnok=;
 b=IkADRDP09EFoGFhpEOlobcIRIfiZQOaQSct2bOmh1QWBhPsTZ+ZP8cYhicdsEN9lbpAVK7ApXNFTPWRVlyv1O/oX0jpDROX+AJUEBeoJo5yEnX2/8GX+4202YwvED3ArM2FdiLGHBlk5cy0JncFLVll6PE4zSMpv4TL1pznyraI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 13:49:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 13:49:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: tag_dsa: send packets with TX fwd
 offload from VLAN-unaware bridges using VID 0
Thread-Topic: [PATCH net 1/2] net: dsa: tag_dsa: send packets with TX fwd
 offload from VLAN-unaware bridges using VID 0
Thread-Index: AQHXuKVN0g8c7qiGRUOKHtWHUYnlh6vCq2OAgAAF2ACAACnEgIAAARKA
Date:   Mon, 4 Oct 2021 13:49:42 +0000
Message-ID: <20211004134941.7ir3ca7yjt6rdtze@skbuf>
References: <20211003222312.284175-1-vladimir.oltean@nxp.com>
 <20211003222312.284175-2-vladimir.oltean@nxp.com>
 <871r51m540.fsf@waldekranz.com> <20211004111622.wgn3tssr2impfoys@skbuf>
 <87y278lx80.fsf@waldekranz.com>
In-Reply-To: <87y278lx80.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f97950e3-c633-4bcd-e3e5-08d9873dd12a
x-ms-traffictypediagnostic: VI1PR0402MB2800:
x-microsoft-antispam-prvs: <VI1PR0402MB28006AA31F0191881B434798E0AE9@VI1PR0402MB2800.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ceguyH3z/ks6tKB6xd6omIpqkhb7ZFlWmC7JFNfiz+c+CLheyCgt3tV26qWk4NewEKylEEQexgoujF+TC8ZSmRFU/3BSuMfuzXvAMbvT4pbsZNSqzIyG2QhXwXD+570TxYB1uB93OgFvOAkmwBdmvr2DgWILJ68qA2713TZBE6B1Nlr6emUCxl3fJwTlaD0+mfwoxAxHqamGZ+JccsRzMdC+o5gvmx4rjE8+rAMb6tkvGC8rkcbSBKhq6oID5+aRUhvAIypI97Av4Pczd7a60ssTn3hicbL+TxnFik+3YvNnlRS1bw+wvB9UEpq/uBQiAR3k0aEoRNwlOP58Ph+gcEpP888r9ewtAWCtCeI2npKlcgzcPQhNG/Dw6LC09XQo6uMXjPCGoymUSWiEIXxGcNxVqKD+dsQb0gh4SMRP84/tSeixY39P3ZdWObGp81DKJvTXMDzDP4b6niuL7iQ7HBKTD7Lrfj5wGm0doHBOHEfupNOblqexCBNl87xbMC8vgL69YVVyGOaCfL9WXx8k8ZoI0rs+a0QBYyn+fJUt+UBUU/Uoyy/g7gYVJd3MnWc+Gp3Ugjhin8QirXMQOC/kNgWJBtvsnlI2tjPgCppHLiuylhpX4BhUd/EYSZsyoH84WYjCTmkS69q64zMxBw+NyIIl9RRwed4WksXuJoUo7Vfghg91439pwjYk4HCrkqf7SkOOx+N/M0y0ft/IvTVMEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(508600001)(44832011)(4744005)(64756008)(66446008)(8676002)(2906002)(86362001)(316002)(186003)(66556008)(5660300002)(66476007)(76116006)(91956017)(66946007)(38070700005)(6512007)(9686003)(38100700002)(4326008)(6506007)(71200400001)(8936002)(122000001)(54906003)(1076003)(26005)(33716001)(6916009)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TerEUKUh7hCvs4NZOdluO0C04FE+6ikoGnEzg2IBAjTNx5iwycD9+5jO+eMp?=
 =?us-ascii?Q?XWylB7mIzZ3QnoMH6gjF+NeG9iMQTrLXonnf26tlfQzBdEKckI3AwDetGgUi?=
 =?us-ascii?Q?Rcy/p2/QNKX23jJCH8xP0sGrXDL7ynZJCWrQ65CdCg7KipZZzKDgZQjTBmgL?=
 =?us-ascii?Q?yk5ThsqlCRYHnJiRKAt4i7fzwpiJv0C74v2aG7egLhHDn3Fa4NdHjjgtgV2T?=
 =?us-ascii?Q?7uiGkL08TCTFMk2/QE7mUZ08r5Gc/Wyh0aSo1F+vrF+XsVT0bNmM/YYuzWbn?=
 =?us-ascii?Q?ttt1TOPwlLgiytdz/VdkB1VTqy4FpTsEBg1bVd4Eo4nGfFLZ9xrFWe+A8w3Y?=
 =?us-ascii?Q?+A9eRbPYUS6GrTkro6eXgEZT2b0rklBu3Gy5LBqhU7v/V/+ghs747U0RtxfF?=
 =?us-ascii?Q?Zi3rzo6G/8QWSfajyW2a/DrRoRyEqBzRKdD83F9CaOjGg+GFcZBdE4oGEuq+?=
 =?us-ascii?Q?LRUY4eL+1AMUOX/9tjF8NIkZvuWeJDM4Eg8eVoGbtAu0s04zTl0WIF4ZHBuf?=
 =?us-ascii?Q?xe1vnnNENOwNFQt1az4OWBdQklLLY5tJ1L01yKw9pikEroG2pxeb/4pkHfGX?=
 =?us-ascii?Q?n7PM5Up/F9A6MfOWy3WaZcWHflLVowbq4mGQ1rnkFaktin7mYIhp61E97GAa?=
 =?us-ascii?Q?7SMTdlWpHCq6lDhvBhTX+4VAso6iRN3m5TN/hZiXbc7gxOupZj0M9e4ypMmu?=
 =?us-ascii?Q?iPYYQNIHjUxsW7p0dm0FviWPYqaz4aMSZBJi0pemJFyK7MyV0MeMq3wSvbEg?=
 =?us-ascii?Q?9nkm5oQT/oIW10M1nJjC/mMsed4ebjh7+PAWDZ5DPQ1RxJst99J1Dc0HKAU/?=
 =?us-ascii?Q?QZwEF+XNWCUQ5mwRB2thGPoMTB9yfHB9WBD0QAsQLVLzFArjX1BqjYeanl1X?=
 =?us-ascii?Q?FYzpkFamw0FJeYJGPs8tqChwDLRij9Rh7JOSC1COZ70S01yMyzKszdJy8WzZ?=
 =?us-ascii?Q?dC7WIdStZb//iQK0N5Romvp3ol/StTR4Eh4iDrX41rdHchape/dX/aMOFpFP?=
 =?us-ascii?Q?A0abSDdyoXLGWGebCOw3Z9eziHzxULfLD0Lp7X2mpYucN9Zg0DDs3VnUGMnN?=
 =?us-ascii?Q?/8MFTkpP2tUVRL/8vKp5qW5sutY0f2aNYcN8xZpKAepRr5iIGnMeMbwGZOtq?=
 =?us-ascii?Q?arQQDgnPt93D2iENaYaBGd/68BRTW827Sj+Y71zePzh3OPjRjCvh2ThQf1LO?=
 =?us-ascii?Q?JMI+1drFlQs67tzkeOFMV4M3qtycYHyul8cEJFT5/XI0t3vBxjfLB4ohaVNy?=
 =?us-ascii?Q?N8rQI8yoKusVfslX+WMPKXapM9TvPP8VoH7V/LpEFxJKKnFGOyu70EkZWXR0?=
 =?us-ascii?Q?cZkn8Mtnz4SNPi8F9XJgF7RO/ekN8yZRSydfSpZQ7owZOA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B379745AC1569A42A667C9A0BBC38E79@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97950e3-c633-4bcd-e3e5-08d9873dd12a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 13:49:42.0270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6LLJVt5LSXHfQbIDNbdh4vC2m3SI+j18pxYM9l1lNQTPr02VhMlQ5KRiacvrqRQcWH7P7dnvwEpvegG7aExLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:45:51PM +0200, Tobias Waldekranz wrote:
> > So the patch is not incorrect, it is incomplete. And there's nothing
> > further I can add to the tagger logic to make it more complete, at leas=
t
> > not now.
> >
> > That's one of the reasons why this is merely a "part 1".
>=20
> Understood. But perhaps you could add the PVID-wrangling-patch you
> suggested above to this series? That way we don't surprise any users on
> stable by suddenly flooding traffic that used to be forwarded.

Sure, I suppose I could. v2 coming.=
