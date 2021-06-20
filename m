Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7431F3ADF89
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhFTRAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 13:00:53 -0400
Received: from mail-mw2nam12on2097.outbound.protection.outlook.com ([40.107.244.97]:44641
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229605AbhFTRAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Jun 2021 13:00:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3T1HwMvd1fb3zytdFZDwhGjyhpjRuWN98OMCodzxxmVCduUwl+Hsu23TU5WJfo5DkWezE3uBla1B6l5XzSFJUHMN5Bes8wP/y4QPn3lkmZDXK+NIupHfO08gCySgdVSGMeTAGISKZI7QieCPkKJeBUGJMrTXI0uY+9czKfYzmVpNKA0v8C0Jc98MOJZwFhA9vQdV13bcTiHPYhYILegZ52V/MafnJgloRJHKSxD46aIC/7tKOhmM1P7lxNgPxSr0NbSxr5hgEUg1GNRD9P/EiTBHp6fjZ2zA5/gs16qkgk1lILPzztNT1WbgqWUzszBGlz1tNL5eq+t1FBLAT0HoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/eUANXmbBI03iPAFtFMbTXL3Lmsqk9K4ydlQTOgVJQ=;
 b=YPYhJrsxeK1W0xWF7Afas2F50AJEdgAf8M2/rzP5jPC2vZ5AuiaNn0wl17gWq1WPHnWuJbeOOImllmdqPSEEwfz+e6B9xHLBS2jY21KsuWpFLj1zYubWNU3wmUs4/u7upNJyk1h1cljTpHNA+V5XO75TnhAGserlm7HaYw/tWiJZ1j9k0IY2LVrLrz8kHstkFO7TMSluYZ/jlzJlM2qkGWI95zj15QfvwMaJocUN+KJoWaKNCdOwbRgsDIha/4c7dF44mBun6bE5t3+SDnCOY2et5dz91+x08uV3rHtms5lA1iwnTcjg3am9wK7wMMaZ57tnuRV3tScHTQ/dEQMvZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/eUANXmbBI03iPAFtFMbTXL3Lmsqk9K4ydlQTOgVJQ=;
 b=PolmI/S1uJsVz4CIOQcZAK3XZCULPGTuLj+dLqzXga63Id2xgl/skjBCcvWfoFkkbkSw8BjW2pNrXaUkBQ6iYXPRqzP8uNNfE+Mc66ChhXizee6JGA2RSoG5GUBc5mYGXoL67vCqzmKn6RKguM/boaSdenw8ukQKJBmntjHiNLQ=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BY5PR21MB1442.namprd21.prod.outlook.com (2603:10b6:a03:236::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.3; Sun, 20 Jun
 2021 16:58:33 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::7ded:3b9f:50cf:d38c]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::7ded:3b9f:50cf:d38c%5]) with mapi id 15.20.4264.011; Sun, 20 Jun 2021
 16:58:33 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] net: mana: Fix a memory leak in an error handling path in
 'mana_create_txq()'
Thread-Topic: [PATCH] net: mana: Fix a memory leak in an error handling path
 in 'mana_create_txq()'
Thread-Index: AQHXZdpHPvfj1IU9lk+ONqlh/jEYFqsdHvpQ
Date:   Sun, 20 Jun 2021 16:58:32 +0000
Message-ID: <BYAPR21MB12709AFD3F2B771400667055BF0B9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <578bcaa1a9d6916c86aaecf65f205492affb6fc8.1624196430.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <578bcaa1a9d6916c86aaecf65f205492affb6fc8.1624196430.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4359f670-00bf-40a7-afe1-5f71514ba75a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-20T16:57:23Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 075d5b95-82e0-4d81-fae2-08d9340ca36d
x-ms-traffictypediagnostic: BY5PR21MB1442:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR21MB1442D94CA9DBAFC8A1A1CBABBF0B9@BY5PR21MB1442.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ic0bSVZdPBQ6ZQ/4tkhgDB1aIhVoz2yB6EopYCNCtPQalIHmSJFdeLhmGCl2eXJM74n/rMauWLxJuIex3pmzzt7u+N0Aqm3Ss7H66sYmsFtvNOlgMWJqgGbErvOHlljmeVVkYFcg613rmgGXnttn9/Dw430kM9U4G5FPVUUdN7taWebiPNr7M+WKIACQtEkPTvog92Ix5D9Lff8wGTJW5J8XwnbQ2y/wNTSuI7z2fxn7WZnogDQWWec6i82otqIX+LG3KR7JXdVyTzvpNuq8l2gKSOF7eWPrOQMHQ44qezpIxDMVdufgrG09S5k7bq1PUe9zyexei7RqyOX+Qudgy7f6s6B6FzzXLYB7C/uWh59iNWnjSVTXT8/pV9eCTZA4i/tYWSrGU5v0O5TeMHZFdvWmLvIJQ6Ymuv5/bVdlrUhOyhTEB46qZ7XpUg+Pv6BU76Xven1Qps91Ay5Bnpjr1LUtXgOVACe6FNXKd43GaSnwgM5GcXVW/cbJf0VQfiQAIawGSB7dLLTpRhyQNRqQK1qkraXWTURyTO+x/nFDY2a3CalM80H55aL+kXclx1qktZH8ryEkvi+WRxoN+8sCZFhEN890dckpxgkvJySWeKkO+6exFkgn/qBW3wILm8M3xNVtym9qIIllo80IgW0oXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(86362001)(64756008)(82960400001)(4326008)(66946007)(66446008)(54906003)(2906002)(4744005)(66476007)(122000001)(66556008)(52536014)(110136005)(316002)(8676002)(82950400001)(9686003)(478600001)(76116006)(7696005)(33656002)(186003)(71200400001)(8990500004)(10290500003)(8936002)(6506007)(5660300002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cU8ZlQKhWgaZl9Paqgbg4L9u4Lf+ZEAIswzufL6+T1NnSMjVnVBkcMgkD9cW?=
 =?us-ascii?Q?f5MbmwHr8KK0YDcxQGTrmmlhJ1hKn/GBHWpdoHq1XlNcJQxwEw7NW+NBEnFX?=
 =?us-ascii?Q?fVzXxcOc2roFqkZtl1NmUVkfGSBGVraxnD6sNa0KPeHdS9SylXCuz3E4gAbS?=
 =?us-ascii?Q?5iVIxdOMr68tkS+Q8nVIShzbeK2qnRIAWIuIam7rUgCJGwGsgOqshoz3CdHy?=
 =?us-ascii?Q?K9sa03RnMqRcWqEKBsiiieem5D/Txuk+kKZyc2mIdx0RtJpxRZeA7PVW7fia?=
 =?us-ascii?Q?kJAJO4EPvcYibxsR+xy/ndHUoEXm9zelvEQUlS8Agjyk990tfcKQrEmjCy17?=
 =?us-ascii?Q?FdSRoHKzL1rYPxy7vtT3Et3Al6Vjc/WJSQqBh1HWgP7yqCNBh6YXDONro/Qj?=
 =?us-ascii?Q?WZMqHXniJM7pUS4A0RhDhv5sdzjw9cg977f7omPbfestV8/hAqtqy8H9gfpv?=
 =?us-ascii?Q?7S23LDIf9kORjjRl/beQXaVv38Y9YYwq4l8x4+Py+Aqf67z/xWNofzPII1yz?=
 =?us-ascii?Q?Uqyz3CqkUOaD+GqBxRRCPM/hDKD371aaxXAaCR2WJJYSBzLo4KnmwtV2lZqp?=
 =?us-ascii?Q?1avgGvzsbl1tzF1lJmOHHkYZuCIrZpMxFdcxDTkdNp92Hbqgxa0/NRbbP9+9?=
 =?us-ascii?Q?s4nnAVSaHt/fF8QMM9x2PWDigxXAUOjJu7/q4JcK25aJOKzPMNXw6YrMZ3fY?=
 =?us-ascii?Q?PYWVt91ql+gB5mgYph+/I2Kn2DLN8FHInijapsQ1exiQuET2nZBivDn6Fnvw?=
 =?us-ascii?Q?M5+AIoS0OU4fkkVQKsrX1v/AbhgIbuFxts2fNDLKprSLjcw5l4mpxhkXdwgU?=
 =?us-ascii?Q?krewsbqwUkuM5gIu49tijBv/VUkGQ7/sC1pJFJ8y4tsZtlou4aNg+sbooO3a?=
 =?us-ascii?Q?nijSiK/wY02MZcheVio3c5wjfRpCGU/XKLkW4kU6iIk8CRS5GhoW/E8tTrgZ?=
 =?us-ascii?Q?83DTEQxQOPwdWqxixxEau9GhOWzKJJJoMerhRxlh+4gtyjco3QS8yvgpWlkF?=
 =?us-ascii?Q?hSoRFzxi4Tv9hAHXz4mOu9sdixRfH38cZpYm/9cV/fPmHp++9cYdC+B8zSvf?=
 =?us-ascii?Q?6I4At2QtPyQrx36Jl/60bo9ouTTEAkk5YGcukTjDslqzGYX/26L6/Nz29HMJ?=
 =?us-ascii?Q?J5NRYeBW4agYeY8T47mqbkKqFAtK9LF3WyB9Ku72PeXn58IdEamq7SBcFNCx?=
 =?us-ascii?Q?AaNi5udeAAE3oQyPpAHKJ5OUE+42Zl80QWKKeRv3o574diYVzMKLrisBE0gi?=
 =?us-ascii?Q?wPPXSEtpA8jfIM8q02yhOxwaIPfYd3gyRpKtvzAhLKkuYpWRsazI4tQCAazN?=
 =?us-ascii?Q?bly2k1JUqMwHwshYLHxKBtXqbG4h8zKbcJtNX61krpi9KTS/jgedBCHUwsvh?=
 =?us-ascii?Q?YRzgCupFQiYF9/kNCdDREg+Ve6Kx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075d5b95-82e0-4d81-fae2-08d9340ca36d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2021 16:58:33.0714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hI30++tNeWlFaexNMBsWiiZZuQbI9tzOac0KKWW8dzC2hQXxiTLkSo0n1kTNWXv1ysimiDvWzjS3uhu8YVfweA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, June 20, 2021 6:43 AM
>=20
> If this test fails we must free some resources as in all the other error
> handling paths of this function.
>=20
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network
> Adapter (MANA)")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---

Reviewed-by: Dexuan Cui <decui@microsoft.com>
