Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E138420B27
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhJDMti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:49:38 -0400
Received: from mail-vi1eur05on2076.outbound.protection.outlook.com ([40.107.21.76]:33268
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233151AbhJDMth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:49:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOBJDYnL3qsGEXDx7Lh3jucILUwBLWGY8WbqeeuZI0IhDBpvQ6MeotwUz+Nzb5m18dgXcnKWQlfY9j7s1Z3wRz7YUtOXryu+M9Cgmhd+qoFejm5mK4/VonjMh/qny6BK116gpyV2TgoazuXE9zUvgHdjT1XK3sd7Qd1EmvU1amhGu9K2ZdkyiRLx/i+R3kRW4xsCR689ZIRLU3h/fr4TZEKCltnZSCYtVcOV8dR+KMKfy02I3oMzi7aEKaLSQ7Pcxc5jkTDG8xqZrU3wK4NfAW0Aw/yvILnIcPC/fvhDHKVTWb73NrizgKqgZFR1M796msXODhbyBqnJpGIwQYZKVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6eicbvxaJ6lCNNA+dSRGcEOV30cECIIZNHZAMf3U+SY=;
 b=Ok6eGGRqJqJFdtXqbcM2MF2bbqLq/nWd5y5C7Bi5D0odoOVx7rFAwN+4i2s63XUnF6bwUQB0Ln0nYhCjknw5Cf7mc9nBgz5+/dfd2hSMFVlkKVfRx1ftpQPLywwzx3qv76/a6Im6wbG8WGH9GW2JXKKd+YyMgkSc0bXHN3cMWfZX2D9A2rIRJWjsvc1ZPcHjwxqCIWExRsHDmuKetKqqswvb/rxHjq1DBRfzKC51l5x9cq2vTDOaQOfMQNu+C4Zr2kriRyAz9j/6kMo5YOgVBWn6+MmdfQIdB2ZxmaezpyMyZkuPV5eZF+/WzVk51/vA0BwdjZurNlMvp7G1OUdyWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eicbvxaJ6lCNNA+dSRGcEOV30cECIIZNHZAMf3U+SY=;
 b=IPtTQoQJzXvccMrpufaxD7ByutSwlcx6/7ThLAIh3cfTKRtVWWe/sUpXvbG0SO79DjzkDKTnbzcYTCJoxdJmXocpqnGn1T93JKGqqiWn4PPchTfEPDJsVaF9vADtCYEfJ2mjWPVTxPkXccgcq4E3fCrajswlrNlVyqkvz2mZTmE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5503.eurprd04.prod.outlook.com (2603:10a6:803:d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 4 Oct
 2021 12:47:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 12:47:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] dsa: tag_dsa: Handle !CONFIG_BRIDGE_VLAN_FILTERING
 case
Thread-Topic: [PATCH net] dsa: tag_dsa: Handle !CONFIG_BRIDGE_VLAN_FILTERING
 case
Thread-Index: AQHXuG6ULWzW46PLSEq2SyN1aUYH6KvBw3sAgAD/pgCAAAgQgA==
Date:   Mon, 4 Oct 2021 12:47:46 +0000
Message-ID: <20211004124745.57e2dzauxlmvzlhw@skbuf>
References: <20211003155141.2241314-1-andrew@lunn.ch>
 <20211003210354.tiyaqsdje6ju7arz@skbuf> <YVrxLvHqkyvdYIfb@lunn.ch>
In-Reply-To: <YVrxLvHqkyvdYIfb@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccbecf14-e1f2-40cb-aa5f-08d987352a8e
x-ms-traffictypediagnostic: VI1PR04MB5503:
x-microsoft-antispam-prvs: <VI1PR04MB550300033EB355B2BC21EFFDE0AE9@VI1PR04MB5503.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YrnItJd5DWooTo0ITk8mgUNWoh5g4C5V+10I3Yao7HYMlhdxD+4eAYDDvlUXZb3l3zNyfqzEQWxJO55k48jCDPxIy1rtsMN+rVzcocS39V4Ub3m1JPKeecqI/pcdqw0dWEA3ZCSfYPnPSM2S6Mif8IgoGUA0Po6oqSZ/GOgDmfTYMJZHnyqs8GjmVdJI3x/0Vg4y8eP6af5iqpIzoDUu+0CuMQKBOjxZPRzqoFEEOqNYHnhkyXubx4DhL16t1YfNFRBre45n2HVbs8ed2OZ/65TJCfFnNsXasN8Lw1t9PWZ9C+r/sEWiBv3E1ZsrtrtIzR6cbYHrEs+JOG5HwYi6yJ+cBKgabqiRWtKdbuSsgz61AO5dC8JmU4YSQ2l9uPO4nE2UEKTsh1NXUirFtnRyN3d0Ph24upzi7Y57OfVcyVJ8dD15CSbv9y0eJJfwB3l7vIODZjGLe1p3Dkt2zpja+dL/9hrS0/R4I+KSPHNBxWhdXlDHP9Xa99RA06b0B+3AsY46z/gIa47VaO7R7YPyk0EUHGpSsqGdhIbF8ags0KIBddqvVPmkDn92hXQhaBWDnNOfG7fM6Becsj4gqayOJjcgExfxlITQfVIezl8Op2yt+VhZHsMv87vkwtRCghhuibx+uwWE0zD9HZhPxNK5LN9jKKvvWjpelhXP9B7h8WXkES/dCQTEGPyUGAc/0hlEekKFgTUAdRFsGkxp0K+YCY38DaAPSc+nGsgEdI4x9qsOvE2ZT7JjDacX5hXiMUIB3dOJlpNNS0KJns/VCLIx4/j6BzB5C9Rz+3i5ddXDX6U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(4326008)(33716001)(44832011)(6916009)(66446008)(66476007)(38070700005)(64756008)(76116006)(83380400001)(91956017)(38100700002)(71200400001)(66946007)(316002)(66556008)(2906002)(8936002)(966005)(8676002)(186003)(1076003)(122000001)(6512007)(6486002)(9686003)(54906003)(6506007)(26005)(508600001)(5660300002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7HFaNJmTDdlB8GI0klkRZ/9BMBE/fI4Qe6GSuIhzJF5qKdmJI9/QXbv7a4FQ?=
 =?us-ascii?Q?NsO2zb2SavxrELx4prM28Dk8zX/jh0KZTOixYfR+wZzKKrtYf32xdWwNYyGG?=
 =?us-ascii?Q?PeUcCr4a0uJbScyUrxCYiXFcJwqAX4YRnL0q57mFURYjwEthnFja/M6kCrm3?=
 =?us-ascii?Q?n+3YdjFaW2roI3WnK5YN2k+3IQ0SrKIGyhkCinKcE/UJpxqpb+YxRgyXfzje?=
 =?us-ascii?Q?Jou89ZFLwMnIc0qp8Wl/5xK7PQyNQWetEcb9AytRskXcFS9yleoA3zo7D4Wj?=
 =?us-ascii?Q?31l+bBwm3Qd1WtctS8id5qb9h9R+ZtL09Zsv7ujv1gSsFHF4CrcFE63OWuiC?=
 =?us-ascii?Q?ustvEZ5Ux7JlTeHZ7qYrk6GG7sXHGewLcD48kUhupvj+qGQVHT7dcB/Hal6L?=
 =?us-ascii?Q?g9hhcqmeo2lvnXc6DDfNuqbEoU6YJi5GUvPW/rUPoVjZ6Ei4aJkj6sfesejX?=
 =?us-ascii?Q?L4ZOStCaPDIkZwlJcy6PqcAly2XnWQcjBTecuZTn+jVHyG1tF7YmNoha+uDe?=
 =?us-ascii?Q?sN/xsvhQHSHUywRoUPKXzmjEuOuGm1uGuountCa+niCPgNSAWAqSBg9w6T8/?=
 =?us-ascii?Q?nojmxjPJKgoAzHFZF2VOrWteTn5QScOjsoVqOY5KgiwaUdMfRLqsf65IsJGY?=
 =?us-ascii?Q?PvxmEkayRPprX8EtE2UdVwd83c2vFvAQXeUZBGr5Jbzh9a94y+FYBRiK9ZXt?=
 =?us-ascii?Q?rqiJCnO5A62MPn9MOq9FE+5UfWPgtHtEybxhQhF+rbrSFwMnkuG/TEYF2Pey?=
 =?us-ascii?Q?vtyGlAuYVoIb88/qseCd5Em9b8+Cc7MRWAooSPgd+Fm7westhUd3hYsEPVnK?=
 =?us-ascii?Q?uJafyIl+urJ0LdWd31oN+g0oxul+Qw+hFT/lrHLsuaY2q8ZPJ8JDLfthztsR?=
 =?us-ascii?Q?r9/4ppZY6KV2J6XEzPXgiqdzd8mYr8Dq5sFKc2p/eZMuuuSwbgxP0NQ75Shq?=
 =?us-ascii?Q?HEdQJMNxyJdtV95immgou70gKTIOdSWOUrUaRkvXmwyGQB15DZInd2taqP3g?=
 =?us-ascii?Q?01FqMp3VMIbK7jCi0RIAUXmCIeZt2emZlUolGZNb/d0KeIJ6UE9jO6jGnZYt?=
 =?us-ascii?Q?nrXoUzCFJ9q6TKT4W/6fzmdzW9Ap7aisoIG1KBHmsiygCnYpao3GoqiGbALf?=
 =?us-ascii?Q?AddZq5ZlI4UY/1xuMOvNDRTcdkQ28OWFj5puT7QBom8elUzJnMY3glfr4AeE?=
 =?us-ascii?Q?LUnEw+OFhBs5251fd8PfacnMcKjnBeEwz6AEFAtlxtJlFXuevY9RzHibUSxA?=
 =?us-ascii?Q?dJgrAtJmcIl1Zsltfe1Q0cX7F4N0EP1aIWiJLC0ACGovzf0uVGpvCRLIE6H0?=
 =?us-ascii?Q?qpy65zn3hlbQ8qGKNZDGPSeg?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <751A96D0B46ED44DAEC03A38A59D7CA1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbecf14-e1f2-40cb-aa5f-08d987352a8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 12:47:46.5635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oTYRcYSxiZ3AD2txmPKj0TiPEiOwYt9oI7xxb9XFUB06RX4a0aFsftAeQzhTHBQXDAoZdi3b1MY6wvUJRD+r0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5503
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 02:18:54PM +0200, Andrew Lunn wrote:
> On Sun, Oct 03, 2021 at 09:03:55PM +0000, Vladimir Oltean wrote:
> > On Sun, Oct 03, 2021 at 05:51:41PM +0200, Andrew Lunn wrote:
> > > If CONFIG_BRIDGE_VLAN_FILTERING is disabled, br_vlan_enabled() is
> > > replaced with a stub which returns -EINVAL.
> >=20
> > br_vlan_enabled() returns bool, so it cannot hold -EINVAL. The stub for
> > that returns false. We negate that false, make it true, and then call
> > br_vlan_get_pvid_rcu() which returns -EINVAL because of _its_ stub
> > implementation.
>=20
> Yeh, i got the names of the functions wrong. I will fix that.
>=20
> > In fact it is actually wrong to inject into the switch using the
> > bridge's pvid, if VLAN awareness is turned off. We should be able to
> > send and receive packets in that mode regardless of whether a pvid
> > exists for the bridge device or not. That is also what we document in
> > Documentation/networking/switchdev.rst.
> >=20
> > So if VLAN 0 does that trick, perfect, we should just delete the entire
> > "if (!br_vlan_enabled(br))" block.
>=20
> I will rework the patch and test it without the if.
>=20
> Thanks
> 	Andrew

I already resent the patch here:
https://patchwork.kernel.org/project/netdevbpf/patch/20211003222312.284175-=
2-vladimir.oltean@nxp.com/=
