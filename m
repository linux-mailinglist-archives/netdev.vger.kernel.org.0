Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B851E42087B
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 11:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhJDJkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 05:40:00 -0400
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:13654
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230270AbhJDJj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 05:39:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqDNFO2t5Cdmlnm19hEQg/5yj/CUEastm9nLDEVz7XQv8BsRpa2z1Wd9BXOVhdFD7y+Mnauy5p37kuEdPUaafd1mk5WLz4ypsnsVZQRgWBfzJL97jtpdlCNHxdMHb10lKJjwUlPCsNi4zpdH3Us/X21b1I72bjQ3d+YuwVoQBpdzmBMxn4nHuU+n9ONG5i92X2hFg+ZzQHssrh5R9VSnkX9OOvTF/Dwo/l35UXvS6QLk2xQJsDrll4hi51DDi7dHs18wRr5WMqWaFyJruQL6a+VUH5OLUTmC+by4Ag2+knXEcjacdrabDW/kJASBdn9ckcAcK6r0hr4bqtzWvedPew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGfUDvuFeoofw2ZHw9IKuSMjfJB7X04Bwl0W+szmhf4=;
 b=Dc812I3lse2gtCy2fFkoUl3yXfRhiXO9YpDRSB6qF+8dwJhCDpiNVwMOubu8onRB792jrN9En+nlonSodvKjudfTTIHz66pJFdmUIDBzPbUs1Tou//VQvkohvXtcLcpuwHE/vuXPTTY8xPFcuIA25Ubue0Lyge1BXns3at+8bDqP4o31wYtytHCKlweKGNiP6bZ+6LbW21MY6DmXEIza4ArJtLAiE3hPzX97cYT79aH5CBhoOm2ZAVNCQKqxVWbBqthU47IlUUuTUXe8hIyn7Kwq70yRs7Axvj0JsyXdV0QMIB3RzF3i+hBMC0ARD1jdQYNKqmUEeD+ltIk3yDPKeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGfUDvuFeoofw2ZHw9IKuSMjfJB7X04Bwl0W+szmhf4=;
 b=d7t7wbndQsXcc2XP6ocu/e5NVe8lJbxvvfqdTBJvBPWrs6jmME+oUGueVWZ0A1DscZpC5Gi9XktWyuaXA98W//kvrikEUehti4+7IzED9FiIbJMtm3DsCIaOcMy7jv5db/nk9CKZFmw/gUKaLBtoXP226O4uEgGt0z02kn++nws=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2303.eurprd04.prod.outlook.com (2603:10a6:800:28::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Mon, 4 Oct
 2021 09:38:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 09:38:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net 0/2] DSA bridge TX forwarding offload fixes - part 1
Thread-Topic: [PATCH net 0/2] DSA bridge TX forwarding offload fixes - part 1
Thread-Index: AQHXuKVMHcqXdzsr5kKQs/AaIz5HgqvCY6kAgAAyHoA=
Date:   Mon, 4 Oct 2021 09:38:08 +0000
Message-ID: <20211004093807.7a46cddcb7wrlsf5@skbuf>
References: <20211003222312.284175-1-vladimir.oltean@nxp.com>
 <874k9xmgzv.fsf@waldekranz.com>
In-Reply-To: <874k9xmgzv.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19bf9496-0207-45c6-2148-08d9871aacc6
x-ms-traffictypediagnostic: VI1PR0401MB2303:
x-microsoft-antispam-prvs: <VI1PR0401MB2303FA6E5374C232ADA0AF44E0AE9@VI1PR0401MB2303.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NUCkMBk/emu4jixMcAgVPxA9g/2xzzoHXj/vEjTLNVOplKAO0P+IHitcPOn7nmZ61CQSLcWw+T7CQ81GbBC9g8veBQWxX6jm7leXFrLldTO5+c9DVyQzZeLVABl+QMFyt4L7p8+u3ekwf0gp1YdrYLZmHyQVHnWo+8t8B5OgERjdgbJaYzOECRctobT34ogNtbgrhT1yHOOBuaxRClH4FbasavBaYOPww9KhCSGlD3I8pgiNRueMYL5JIY0edmCREWgajV/x/dByjg9c0YdNt6BCjyj/wFUSUgytTqiP8Sy1l/8OV6kUbMdI9Zo1EBoej9TmOHDMA0yfMAMZTCcmvkGC25HrwWsDd6Y0DYsk1o/G3SzpJvJdG/cTXOV9obpUF6no276eMHTv+CK/mBF4uBhBcBBEbfHaFMAaSbpMARmbIVExwFj21Fp1SX7U4b93qaAjeBNloKdI4jnhQzienG2/j/TCZaJX/YhBizjnvoa7cfNbRUC75dX44qVBywcPKRixQ7gQQWL+bgyJyQx2+nJVjnZxAyRvf3XTCI/bncZyhCyJ0limIYwafGcC655EWS23hilhIepy2Wu/4uCiOV0QbHgrxXJoH9ytSMWunAeFi96gwiGdVYZ6iuxQ5v7ioYrJ+GoEx8K3ZudLjZWJc2mK+HI/JGZtaGtI2wCmn2lkuokWTm5SAe/FrkM/fhxunQwk5cpBOxGA6qbjH3rOcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38070700005)(5660300002)(6916009)(122000001)(53546011)(38100700002)(2906002)(4744005)(71200400001)(6506007)(316002)(33716001)(44832011)(8936002)(1076003)(4326008)(54906003)(26005)(6512007)(9686003)(64756008)(6486002)(66446008)(66556008)(76116006)(91956017)(86362001)(508600001)(8676002)(66476007)(66946007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DeAM2+irCjS/0f3XElAyd65XFw9/J6MXn7UkzCvL9yGLtRVJV9KwZOmz2Kqa?=
 =?us-ascii?Q?uAY6+RbjFrILeJccnJpsyinAQJk8nUzKYI5DjjQ3csjWbMS27K6qU0tZ5coD?=
 =?us-ascii?Q?dZCPBY6fwoF+6X0n3Xq0i9HtNDMA4smpbuhrgpKau4IeuT2/HImzuVxwiNhJ?=
 =?us-ascii?Q?KqMutbxhRHYZGAGS7h1lHp/FQ1RDWaGqfIiI1GjWlCNzQzz70tNedJQOqhXW?=
 =?us-ascii?Q?b+r0VGPJrx31T96IZAK9seenKvYNTeJuqBISiILVZ5HewEi0+Duu6qrtDbjJ?=
 =?us-ascii?Q?ApvJR7tLlEOkKOQyKwGWrvw/ezeKpy6gHsNq17pm81VPeaRDax6edfLTNMeK?=
 =?us-ascii?Q?wF8vyRU6hfpjTbUI3cCqmzKHFAQXYwASSeamXUJNUQWcEHAef3av5MJBOndp?=
 =?us-ascii?Q?dFALBOYTStHm3DHLs85XSFIK3pW8KY4ZgWnvVLH6XSjRUizfqiAHlfSSwqZq?=
 =?us-ascii?Q?311SOdHkuBcMFrvAUQISPKdu/OoQGIu1CDUBZKX6fLkrLKTF6BZ7g1TYQqO6?=
 =?us-ascii?Q?Lc18sDOP8pYnpmI0fbHHVDIA/a77TWwFI0pV6UwJEN0hTBar8BP4AHw8XgGe?=
 =?us-ascii?Q?cbH0U9aPJ1lBeifMfN/IB6sQzBZyDeTBIZT6Dm4HB6UMLV5UvyMsMgMReRhM?=
 =?us-ascii?Q?wGPlDe6q2hxFCsln3GCgV8ZnOB+PVhN64DpVkEhFhTrw9nPN3p8ZGPrssTjH?=
 =?us-ascii?Q?k+V+yJ7UPBvbvzm0kKS7ifIc4L/fsWtuO+jgdpy2T/2+dxmgQNDMDNwMs5c9?=
 =?us-ascii?Q?PpSXsdA6RsTFc7jVUERe7nIY4dTiQYFh9I1xDF/Ep3wEDX7IkoJrjh/xW02T?=
 =?us-ascii?Q?P8+ejIfiwGr0eiGPOc/Vg9gs76oPu6YSTq1qRIF4fRK9LgAQxRtkh1pDaKWb?=
 =?us-ascii?Q?aE5l6pOx5onnWT3Tla2/mn3hW1BNe2yg2AxoN1Sb5I0Fi35u9uOwZvkWuynY?=
 =?us-ascii?Q?vvK+9tDsfx5Ri2Mdr1bpo4z5CeRYXL2VpMGcyO0MDfMCa0K7tHFl6IFrgfFe?=
 =?us-ascii?Q?ZRBop8rbhg93PIYgGYQh5mCDUFjHhldyhcpKMDkG9CdjypVZFC2h0pXrggt0?=
 =?us-ascii?Q?pJTRI0Y4ur6JPBN6KX+YR97/WgJdFUyygAgir4O/zVe9987K006xTdMmFUBd?=
 =?us-ascii?Q?87PDlD1sZ4PE2hPna5P639Tce3iiP/MiOlTF3fUd9Q3VbZyUSV3J3xf0bnWP?=
 =?us-ascii?Q?RZJBMQTJXA9IPt/g4xJjl26xhhmozrOn1qBWySGou9g/nsiWjPJejZCtoXmI?=
 =?us-ascii?Q?di1S3mtWf6R7+V6vxskQy2MU7y4thY+lVrAwrHmSWqOBIaJt0KpqQsgtlDpK?=
 =?us-ascii?Q?qIhbW0NNi/OlWAEj8TkWITHD?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0E97361BF5742140B927F37FEA179051@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19bf9496-0207-45c6-2148-08d9871aacc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 09:38:08.5512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f3vYb8/EeFyhxdtVrcCCMQafD+2Bh0ohKzQZfhJL2O4BuvqIRpMTynwsD/0ySYSv7mzha615Oz3QFG4SJlFR2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 08:38:44AM +0200, Tobias Waldekranz wrote:
> On Mon, Oct 04, 2021 at 01:23, Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> > This is part 1 of a series of fixes to the bridge TX forwarding offload
> > feature introduced for v5.15. Sadly, the other fixes are so intrusive
> > that they cannot be reasonably be sent to the "net" tree, as they also
> > include API changes. So they are left as part 2 for net-next.
>=20
> Please give me some time to test this before merging. My spider sense is
> tingling.
>=20
> Have you tried this (1) on a multi-chip system and (2) in a multi-bridge
> setup?

Hey, nice hearing from you :) more testing and feedback is always welcome.

When you say "this", which patch are you talking about specifically?=
