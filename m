Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870F03DF481
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhHCSPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:15:50 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:33184
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238836AbhHCSPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 14:15:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bugl5OSQqo8XgP3oorTAlGgejlkZFjs2exTjqOhlg4Qjz8tQx9d9FFwHKma52JkgHXwZRQJyH22C+v1/4spgzTxiAUg0Ycql21bqgYTtAvJGDphJ250BCjfWs4O/kSoTDrvSuxeyXqyqckMy5jN03goGv3H5Cz2a+j3/teWdf/EH0ZNdDyAq3VFhjsIim+4k7M3TYM00Bt14RVrp7v99Xq3TtA40/VT3jBKzLPCoT58APm2sfW0N9zJf+/hqsY6hCMGigF6JQPKQR7I51I/jINWlyP9ZLa9FgKtyt2lNNEOslPtoImSRoPaZ/zbRBVWsNGoKaix0vnoqJaZIY3/O1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ri+SD2Yc1KXe7XVzan10Kk/GAeyQKExgjuIbCygDU9w=;
 b=TdrsXoeD9urwa1bDFIGmeG6ANLMm1MTvH8nAUUjg2RIH6es99VEWG0I5VCRfB3/YrjxhitZ4IcVm1TeetM7phWBAdBuTwQBdj82+EZpZitWtIZa20WJTrOpeNCynjrQ60ngzO7JgvoDtHiMCA2cgKY28yJfmNzWL+yUb8v6Y3VN7fUPpW8MDDYKtCF2chaFp0bJiJ6zCrpW/PncXEq6i+fsLtWxX0ZfZ7hOXP3PCXCc3qOjUJcuRiy3ymOYE2AvKhjfWWsiHVlUmyV8J/Uz0f7c5RNJx5xmwe+o7ovuXX3Sujm5G4+uPs3AOmJtfHNmYz1KY/R1hTJwkj4dvhNGc9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ri+SD2Yc1KXe7XVzan10Kk/GAeyQKExgjuIbCygDU9w=;
 b=d710FNp1UMItE8gjhxc9o0moyh44p6Am9BDvB7cWRLiHaZODlTFNCMAi9Pd9KqbnPOo5ivnZpfx0W9PMMo1Zajbr6vE/DY4Q4+68g1wIhxTXqAu0erXpE0rBZNIybvhu0PaG363BJhSkeaOF2DTVbR133M88G3YU7MHsOfjXxHg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 18:15:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 18:15:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH net-next 0/2] Convert switchdev_bridge_port_{,un}offload
 to notifiers
Thread-Topic: [PATCH net-next 0/2] Convert switchdev_bridge_port_{,un}offload
 to notifiers
Thread-Index: AQHXiHT2bKwV5tFJ4EatXrPlu4SfBatiBGgAgAARyAA=
Date:   Tue, 3 Aug 2021 18:15:35 +0000
Message-ID: <20210803181534.qgbcjow4ketd4yio@skbuf>
References: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
 <00acb107-8ff6-9c98-e6c3-f6718d5ce9f4@ti.com>
In-Reply-To: <00acb107-8ff6-9c98-e6c3-f6718d5ce9f4@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d21f5a3a-83f2-4e86-2cd4-08d956aab051
x-ms-traffictypediagnostic: VI1PR04MB6270:
x-microsoft-antispam-prvs: <VI1PR04MB62709F28569585A6D6A9DF84E0F09@VI1PR04MB6270.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zhXeFXMSENgJAg/CUlckAmJNlZ1o/rxdEyBCMXR4Zq4tTgGqrHmX3ksOWUFjVy9wzGQthbsavuRhHkX9e1m+5qoSXodfPXrhj7ReEkE09B1bLZaeRXgbvPa0+PfPumQDe5t9wvKngkNYou8MyVJZZWNiQxqvtcOeur5ZTixPkGojrXqZW05C/9KduRlYC4BEbaMRbMKBCL/Z9LlDuaEt1lN6kf0gvHt5EdSRPNr41ACxpaYXlEWc7mki14gIu4e0sKEFJfxlPBBNupKjsuFE410D3e0QPLiPLAVr3b82qGQCM7UABgAdp1rnTUXMKDMVusfcUTch/1XEqWzSf0YwvncMj81uhe7h5jdDK1lKaJuHwqbH05yHr53S01fLUoRxrkt+dtAe24ygMTdl+TFssCi67QYY5pxl7tBjwMcuo8z+eDSYeeoduCH1W90R7dFxkg+MTMuBvsZ5x3wAMLJ66AZ621xg71hNd1oR11yraR9aLA6K2d2im2rdROLq2RgDhArZGY81eHZOoiALiGKDvvXRjD9jVvsSWRXJR9BvPN4crerc5+UqcwJgy0NRY4zAWEEo4hOXdX/2U7W38vG78cyaNWn4sUF3n2RsQTCLK/h5vcanLMjXpa/o+aF/H4UIFfI5HEZHp1SDLRHVqJWlfgLa5qT4wvMZ3OYVsGjdF4RP7qYOJGgm/he0rA6+iFCE5BdfW5ImTFx+yLbUx4eGGVnrrD8D/XxNgUdoEU7v5ttNdNlhEPdny8GrwhTS5vMrJ9Z/wIqJaTkC9qr259eW28GR4AHwbscluR4Nu76t9bM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(44832011)(83380400001)(2906002)(6916009)(8936002)(66946007)(86362001)(966005)(1076003)(478600001)(7416002)(38100700002)(64756008)(122000001)(91956017)(38070700005)(8676002)(186003)(26005)(71200400001)(76116006)(6486002)(33716001)(9686003)(5660300002)(54906003)(6506007)(66476007)(66556008)(4326008)(66446008)(316002)(45080400002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?CL+bMfb+QTbSc1sEqmcvW3fX98RHYCqbAGfEwPI8VCIGQz6OkEN1QXzC?=
 =?Windows-1252?Q?WsuflRYb1Bd2GeD+YWVyN577ooDq1CmDTSk5tOiefZS11QpwmvjISkHc?=
 =?Windows-1252?Q?JhxAnPlisHU0RGkEdMwVgHvPK+KToGfjKKYMh9YQ7/dWT7ZLuWvnLjNT?=
 =?Windows-1252?Q?R5G7yD3Zuaknx0IsUtrHNuwdIKLDj840wsuN5NsWOumnXPPkjqwNq5cz?=
 =?Windows-1252?Q?5AsuuKp+hKDo1md1Dy1wHnrdvfb247B6MGlZa7i/6dWQPjGNpMDCxvOT?=
 =?Windows-1252?Q?uCSoO9mYIH4xVSrRDn0CL4O7YCF1ENk5+cnORisAdYqG/lrESlL513bZ?=
 =?Windows-1252?Q?YbAWLH8MLOA1ZX+gmS2QLrZtdtrt68JuAcC1VcfqHdh3ptk0kR5UhJ6X?=
 =?Windows-1252?Q?YJD/velHZsNWfdtIp/9pbsds3ZYCEcLN4/iY5Y5ALdHRhji4CGJrcGV2?=
 =?Windows-1252?Q?knWHcCl0AIfGTOOO7uPUtJoPUstTzvrzv9uIr2dHUjHeATM9BZRX8RcA?=
 =?Windows-1252?Q?FhFDsDIDdU+NamIstmxTftbEUpLO11l1J7NiNgPrvPJp22HIqXOkUQVb?=
 =?Windows-1252?Q?Jnwp+UhL7OwmwLWhfibFuXp7xi3WkuqSwsQa08fUfTUwbxzVUWKUrZ9B?=
 =?Windows-1252?Q?Nk6eWOl3F+uokMTtrGCipwGhdYnB6cAmp1CmaMRhh6AQGJDv4TNWerkd?=
 =?Windows-1252?Q?CtNWX7RcW2e/qwhB4gMtXqCZ2tXf21yUWQtmA9TYsEFXqOCyN5tnCBnh?=
 =?Windows-1252?Q?+7pqHqSGmT9Ud2ErNy7I7rQfJjaBn5IZA7W89M2xGi3R7pQZMwnoDKL6?=
 =?Windows-1252?Q?+kLUx0ZZq8/eULLfOe968AjyXS/ZMUOY2zK03KJtNXrqJ9PO+N0ldBP4?=
 =?Windows-1252?Q?/4VAbpTvH7b2jDDN/oOdq0o5EoF+2mQhoYqcBCr/nV9W/bDYG4J4/SpA?=
 =?Windows-1252?Q?66Dl3UnTyRU0kkOTRcapfFiVQjdt0UQZBaYR5vW5J5QzkdppxqouVzTO?=
 =?Windows-1252?Q?BI8CAH0CjB+9hAfqPBDFxoRaGhaS4cjwbwlnoJBDQwu6wUB+MGUg7Ww8?=
 =?Windows-1252?Q?Tzsaviff2cxDH1A+9MAl503peRK9PUzbDb/AyxK5n3MKmHYVPTGeWt0U?=
 =?Windows-1252?Q?nDXXUfB+JA62GouoZvxlqpwo4jvXBe7OHPUtenjL0VmI+Me3gluuCNNv?=
 =?Windows-1252?Q?Z95S9KTY7mdgTAfDm+RkkkNIcxQsTqaLdec+tw0x9S/mfR6q+Za+tgVE?=
 =?Windows-1252?Q?J3bo/Ry6dOKUehvkKmYR8KKhg0V/7vzdv71j33b7gVMOJUjSS756X1FJ?=
 =?Windows-1252?Q?h3xXnlIX1QtS0Z6+5kxajZmHZBtfcBwV1yxT4AOVdzQ78QqmsIgbLpku?=
 =?Windows-1252?Q?DWX6ATRwQ/2Z+BgI+t3qDEbM8pY79jqez5+5zcX5lLbb7gAPjEw0pMwk?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <5EBB01D20F46D54F874D3AB13112056B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21f5a3a-83f2-4e86-2cd4-08d956aab051
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 18:15:35.1675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ogjovxBAQNTQv/OMMFcQGvujAsqN35CrQg2lpmzAkE2ceFhMwxYuUUeeW9VRG3+iRPHdh955E/5285Z4GZFjfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:11:56PM +0300, Grygorii Strashko wrote:
> I've tested builds, but was not able to test bridge itself on TI am57x pl=
atform.
>=20
> 1) See warning
> [    3.958496] ------------[ cut here ]------------
> [    3.963165] WARNING: CPU: 0 PID: 1 at lib/refcount.c:25 fib_create_inf=
o+0xae8/0xbd4
> [    3.970855] refcount_t: addition on 0; use-after-free.
> [    3.976043] Modules linked in: autofs4
> [    3.979827] CPU: 0 PID: 1 Comm: systemd Not tainted 5.14.0-rc4-next-20=
210802-00002-g5003e4ac441d-dirty #5
> [    3.989440] Hardware name: Generic DRA72X (Flattened Device Tree)
> [    3.995574] [<c0111098>] (unwind_backtrace) from [<c010b834>] (show_st=
ack+0x10/0x14)
> [    4.003356] [<c010b834>] (show_stack) from [<c09da808>] (dump_stack_lv=
l+0x40/0x4c)
> [    4.010986] [<c09da808>] (dump_stack_lvl) from [<c0137b44>] (__warn+0x=
d8/0x100)
> [    4.018341] [<c0137b44>] (__warn) from [<c09d6368>] (warn_slowpath_fmt=
+0x94/0xbc)
> [    4.025848] [<c09d6368>] (warn_slowpath_fmt) from [<c08f68d4>] (fib_cr=
eate_info+0xae8/0xbd4)
> [    4.034332] [<c08f68d4>] (fib_create_info) from [<c08f99c4>] (fib_tabl=
e_insert+0x5c/0x604=A2=B7=86A=CB=D5=EC=CD_=A1
>=20
> 2) see warnings and "ip link add name br0 type bridge" just stuck
> [  158.032135] unregister_netdevice: waiting for lo to become free. Usage=
 count =3D 3
>=20
> It might not be related to this series.

100% not me.

See if you have David Ahern's bug fix, and if you do, try to see what
other refcount conversion patches Yajun Deng did, revert them one by one
and see if any one fixes the issue:
https://patchwork.kernel.org/project/netdevbpf/patch/20210802160221.27263-1=
-dsahern@kernel.org/=
