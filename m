Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36600472DA5
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237253AbhLMNn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:43:27 -0500
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:57924
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231224AbhLMNn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 08:43:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVAYBcrDMC8YYDFWSVGQ2K7zor+oIyFFBI+hQnTCTLbW5jkh4f4SNyCmWlMTFfrwRHu0YWfaXY5848Hon05icspts4zRsNi9PD7lvVtuQiR6/1U580JmI4kr73ebw4bWnXWRm2uMBvM1WsAczLs1eNb3kij7qtRLIxZVvFHK9mTLoExGEvuVo7AJ3B1a1fs7LAlxTWFA39WZFEmBQEdGC0PKI0GUhrNxLzPW7Ka4N7+lWxx+Vl8EHgdEGr/PTKRDNUpe/NBQNrcKfvAG+DjnqHJpUM7r7bdOA8USq6dgwH6TtR4DS8WfCthVsncMbzO4EIP1Wd0bEWo7c3tv2ZSd9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fllGMTV2A8FzoBbgfb0wJ57Q+u0QlV80Ok4JUebmwY=;
 b=YdkPWOzd2xpeoI7yITmET6fmzAgT3VhqqSs8/e/rEa7kXRO1ktnQEUa89vxmN6ZbGFw9JhrtM8lOtBzymo4WgFUp3tGaYiLPZP52K7uFwaX2eQVxCEsvV3DMYmE2mJxZAKIODedo/rG70GIDBC6H/YVBc/x0RNtSdvlreBw+eBxH+V65vnISBWL/+p2f4y2dr5eirZV1HjIaASPEg75YzudL2mXZyz/HMChpmFJ/T4U+DYuurfCjiENrWt39PCJOQY6b6Cmkzn0wRGr3oHsSCWD0ppNYD/gi/Ba4lJAHl4EapnoczDthzj4RpXlrxuZJlq/sE/WBNCojgw2czeXz5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fllGMTV2A8FzoBbgfb0wJ57Q+u0QlV80Ok4JUebmwY=;
 b=W2Rx1fy7r6ofKdjYkpmX6SdFAkTsSTYUZ//c1LcI8WKc+64BOrak8NbgJc2VcpZYlwhDNQ8jtKg8ltcoyCBAWXDqEf4X2k0FmpjjLEzBmlqV129N8ZgmNZKOMORRFLaALW6z7O7Heoc4UPZ97WOp32Z1zEG2Jcz6w7AgRdSuARQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 13:43:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Mon, 13 Dec 2021
 13:43:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Topic: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Index: AQHX7OGqma9W7JTLPke3A5iwt0gyh6wqKbcAgAA0OYCABd/MgIAAN0eA
Date:   Mon, 13 Dec 2021 13:43:20 +0000
Message-ID: <20211213134319.dp6b3or24pl3p4en@skbuf>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
In-Reply-To: <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b687a6e-5745-4194-7728-08d9be3e8690
x-ms-traffictypediagnostic: VI1PR04MB4222:EE_
x-microsoft-antispam-prvs: <VI1PR04MB4222345254A197F42A376142E0749@VI1PR04MB4222.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lhKQPQfAdCBk9J3+NZYY8C6lLiJ8S9axeRv04fj+lmSk32i0YYx/j1lf7dhFgHeUW+uIVlzSHQftQ63Zar/PxhuUjLeeZXieiICKAbHSCI4vd+LxErVKWROb3aCanKVMJ93VZ9d0lsTD/bC8IJ9SaljbG/jdRa9E2P+W9GUjqJDi5DC9p2rK2UDgOwMvaZY1TNwoeJ+gDyPFYRGzhYcpPRnJIpFNyEZRwx5jLHgoVrNOOTGw0DQfYeWesi74Y4C/kSnhcmKR0g5BDQzWWGjKtAUZqU2z2x6R3IQb/dNDQa3I86qJrUolAvIbZLUeacb2ameY3+6H1NnKET2DfkVp6Gm5geVJXj8Edj8v3DzS7nPB+u9PGwIv3GHw//O1lFJR9STNEPP4JSNxd9rXTVNGZFQ1dkZva0ex1IGKzx6jGTjDcMXAX33XFOS5Waxpeg5gplaNuClUbjaDI360lvo7X1xl295C7d9DaoAUO4SyQBGl+cT2iKAe6o0WOadWeqdEWfvHqyZuwTlwR5sTva6WorBnDLuP53eqG6v/b9WV9DH9wN1b3C1K53tb/7Rd4jOTYhfExYlL+YZ/3c2KrDUkvufWyPJaFTqYX+2fq1H5ElM4wb/kNQHpzDj9CZFffbJAzqWMDvpANk3YgT3ZyzBQWQ/3UL78GdsV5jsebrrB1TtFIrV0BsxM5UDaMG6uFc2p8DgsWVq8TEfO3QC+pU2Zog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6486002)(9686003)(26005)(4326008)(316002)(8676002)(7416002)(38070700005)(6512007)(1076003)(186003)(6916009)(508600001)(2906002)(83380400001)(33716001)(8936002)(44832011)(5660300002)(76116006)(122000001)(66476007)(91956017)(66946007)(71200400001)(54906003)(66556008)(6506007)(86362001)(64756008)(38100700002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zW4cU+dct4q4uKZapO354cP2mI/j/WbPFcR+sbIHDO6lzaaDANeK0w+p6X9T?=
 =?us-ascii?Q?G1ZyKQkJKFW1yKVrzXHZCrUMr1CbnWZqb/8hz7+Bw8K7uFs46VMFqVZapxC7?=
 =?us-ascii?Q?embPpTdBhQi/LXPKjlxrTl7VJQsnScksIGXsTykHCBP+QNY0wjS5kXuE53mr?=
 =?us-ascii?Q?5MbWsOv2JagqoAF6PlwARcxxp00DcrAqg1t/RhxIE8fvMtbozZ8cTBb7QN9/?=
 =?us-ascii?Q?X+OlgqpgR0e80YJ9GA1cPbctx9yrdynKRqwprbqOMedciJ6ft/8LX3E4H5Yr?=
 =?us-ascii?Q?2EY7hqy34GOSXw/O68bneDHpa4blNiVkgbUF4LELmK+erGRKzMYP8GUyfqNg?=
 =?us-ascii?Q?F7ceBH23tAyN1+VUCdyQLL2fn6dXnRrSEXsFdHNRYS+go1d0GC/uuyuObS0Q?=
 =?us-ascii?Q?qsGSNM2Jn8iL4uzXZ/NusYdGuOfC314EHNtuCsPCbgzICD4HRi0mdZE9AtlX?=
 =?us-ascii?Q?HfEvgAcV55JHpE1QbbvpgDguGnWPoF7rIvla1o7wh69fkJd7bD4ZJ6oCpcpe?=
 =?us-ascii?Q?P0+A8mzy4QmzcqYO1inpKQNZSYaBTUfROiDSJxdxYEbToejCdAi8hwH73IkS?=
 =?us-ascii?Q?KZ0Vnp2tqs0qlQDWWeXIYkikWmMQT6iWaUj6DPXmE5epptEIYx7z3Bhkr1CT?=
 =?us-ascii?Q?Stuuzkm+y2Hb0wU69D3uafk5woJwsvv3w1katp0YVa1B1yp6ePb42wSS+tZ3?=
 =?us-ascii?Q?6FgGAfVC6nwkr0Uce5J6sKkB9VEROA60kbmOwfw2a8ogTvkPSopyWbyPizRk?=
 =?us-ascii?Q?jkuxyJtA1ZjV0BB6bbMrxDLX7lzruI6P/SvJCfp19DepqmWgj0imbQ3lX0VC?=
 =?us-ascii?Q?3RQv+vpcI2wRAZfB0jxLVwUxjMZ0tOutbrQWlRqG6KKtEUYpsCcMGeYq0fsL?=
 =?us-ascii?Q?1okQsK56DdyDrGfGNIxkC53CNoLSTzeNqjW8Y+QpRWH+cPJzV4+n2gSTChk8?=
 =?us-ascii?Q?OH+M56qvt8PzBlPR7JOA2iph2SPDK1EqzT6Ob/koxGYSs7owMN2zgo7Vjwf3?=
 =?us-ascii?Q?E6+iVD1XKSWyo3YGf42ck1K/CKBq1leJ6CuMAq8Dk1FC2V1xpWBsrbH65vNm?=
 =?us-ascii?Q?evYThYGdBKNG4WhyjHQtMdBp91ggd5+ODqPBTfQqL7CSzuHbacrm0t5iQHsj?=
 =?us-ascii?Q?rrOsO5Ys1Gpn4Sq4SfKcuerDmGQBGzJWkJATvSc94IP+sRcgUKzqoJ4YbVRs?=
 =?us-ascii?Q?S/qCyuQBxgvC06VXSyi07sqA1VfsvO6utUmFbS7uJQXTF73Re93imo58CZ1R?=
 =?us-ascii?Q?kX19ovKUA5dts7mNFNwwJspylnszSKY2eF0V0Uh5x7DKU63VH3YPOt35N/jM?=
 =?us-ascii?Q?6/arLK8SUZLZZOovca41JkiHfakwsv+GBCXbRQj4AVCHjqW3nyjE6F82PWF5?=
 =?us-ascii?Q?w86q6n71+W4845/dmpWZXPcczjk8pErZEMlGBOZ1qWUPGp8AJWKMHW6bid/o?=
 =?us-ascii?Q?Wpuvii3ragOdEInS8ZKxLgPf1WhuvyWNzSMSFOPoUh7AXhxNG2DEPKI/Tae0?=
 =?us-ascii?Q?qSvbzw4eAYLIjXoBjof6TS7G5cIJhcIS0a6f7lQjBOzWjbF9KBsvzKHAWDcm?=
 =?us-ascii?Q?ZyAcqe5qpxY478Bn97FLddC4Lbngwcb1CwZ/pgrr6asB9ipzW0gqYCbh5KCk?=
 =?us-ascii?Q?wvZqCT0VujmSjTQRjDOv+xY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54F8B0CCE335CF4D896332986CAF404D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b687a6e-5745-4194-7728-08d9be3e8690
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 13:43:20.3562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k2dIjP/J8745CzkUljAcvd/DzzTDyRge0RsgAug+mWEi+awFZ3KqCFLTsn7XZ5QOzuAxNM5y7vHTPUvRu/u60Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 11:25:29AM +0100, Horatiu Vultur wrote:
> The 12/09/2021 17:43, Horatiu Vultur wrote:
> > > > +int lan966x_register_notifier_blocks(struct lan966x *lan966x)
> > > > +{
> > > > +     int err;
> > > > +
> > > > +     lan966x->netdevice_nb.notifier_call =3D lan966x_netdevice_eve=
nt;
> > > > +     err =3D register_netdevice_notifier(&lan966x->netdevice_nb);
> > > > +     if (err)
> > > > +             return err;
> > > > +
> > > > +     lan966x->switchdev_nb.notifier_call =3D lan966x_switchdev_eve=
nt;
> > > > +     err =3D register_switchdev_notifier(&lan966x->switchdev_nb);
> > > > +     if (err)
> > > > +             goto err_switchdev_nb;
> > > > +
> > > > +     lan966x->switchdev_blocking_nb.notifier_call =3D lan966x_swit=
chdev_blocking_event;
> > > > +     err =3D register_switchdev_blocking_notifier(&lan966x->switch=
dev_blocking_nb);
> > > > +     if (err)
> > > > +             goto err_switchdev_blocking_nb;
> > > > +
> > > > +     lan966x_owq =3D alloc_ordered_workqueue("lan966x_order", 0);
> > > > +     if (!lan966x_owq) {
> > > > +             err =3D -ENOMEM;
> > > > +             goto err_switchdev_blocking_nb;
> > > > +     }
> > >=20
> > > These should be singleton objects, otherwise things get problematic i=
f
> > > you have more than one switch device instantiated in the system.
> >=20
> > Yes, I will update this.
>=20
> Actually I think they need to be part of lan966x.
> Because we want each lan966x instance to be independent of each other.
> This is not seen in this version but is more clear in the next version
> (v4).

They are independent of each other. You deduce the interface on which
the notifier was emitted using switchdev_notifier_info_to_dev() and act
upon it, if lan966x_netdevice_check() is true. The notifier handling
code itself is stateless, all the state is per port / per switch.
If you register one notifier handler per switch, lan966x_netdevice_check()
would return true for each notifier handler instance, and you would
handle each event twice, would you not? This is why I'm saying that the
notifier handlers should be registered as singletons, like other drivers
do.=
