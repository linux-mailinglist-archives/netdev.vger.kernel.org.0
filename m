Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3E44739E
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 09:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfFPHaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 03:30:05 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:45518
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfFPHaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 03:30:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gg/NeHwQUNIIdYSvnPKLFucqa35gVK2p4WgqFrnTD+k=;
 b=pVtYOcbgJxRth/zzjt1qm0Oxs7aZJTAOGue0o5H9HfPGNWIDxUlpr/jSw/vggKP4U0BgmvPOQpn73QfiUVxEmDjHFqNAgEw0QMN9q21617kTBbAkGQeAmVhFRaC5pm/AskQhsNR0vNxmVApNWsNsQ156JIu0GYE+KGiqXKnQJ1c=
Received: from DB6PR05MB3413.eurprd05.prod.outlook.com (10.175.233.14) by
 DB6PR05MB3430.eurprd05.prod.outlook.com (10.170.222.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Sun, 16 Jun 2019 07:29:59 +0000
Received: from DB6PR05MB3413.eurprd05.prod.outlook.com
 ([fe80::9446:96ac:1ddf:b118]) by DB6PR05MB3413.eurprd05.prod.outlook.com
 ([fe80::9446:96ac:1ddf:b118%5]) with mapi id 15.20.1987.014; Sun, 16 Jun 2019
 07:29:59 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Index: AQHVIFmsY/4/azwa5kOjF2Jw4P/H36abdgwAgAJz1oA=
Date:   Sun, 16 Jun 2019 07:29:59 +0000
Message-ID: <7152c343-63e6-aa7f-82c7-ad63725c3bc8@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
 <CAM_iQpXQgJti9faPA5kVV7Ly3LStHf3zwDP5S-PfBz2jR0Y8xA@mail.gmail.com>
In-Reply-To: <CAM_iQpXQgJti9faPA5kVV7Ly3LStHf3zwDP5S-PfBz2jR0Y8xA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0102CA0012.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:14::25) To DB6PR05MB3413.eurprd05.prod.outlook.com
 (2603:10a6:6:21::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27809bd4-4b51-4fbb-021d-08d6f22c7004
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR05MB3430;
x-ms-traffictypediagnostic: DB6PR05MB3430:
x-microsoft-antispam-prvs: <DB6PR05MB3430B2EE11E326E372E393BECFE80@DB6PR05MB3430.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0070A8666B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39850400004)(376002)(136003)(366004)(346002)(199004)(189003)(229853002)(64756008)(66446008)(4326008)(66946007)(8676002)(73956011)(66066001)(71190400001)(71200400001)(66476007)(66556008)(81166006)(81156014)(256004)(446003)(11346002)(52116002)(186003)(2616005)(26005)(476003)(486006)(386003)(6506007)(6246003)(53546011)(76176011)(102836004)(25786009)(4744005)(99286004)(54906003)(2906002)(14454004)(36756003)(6512007)(31686004)(305945005)(86362001)(6486002)(5660300002)(7736002)(478600001)(68736007)(8936002)(7416002)(6916009)(53936002)(6116002)(3846002)(31696002)(6436002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR05MB3430;H:DB6PR05MB3413.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9PcVFGzdld4OQMUHL8O4YSopaoau6CMYWVlo5bOwR3Od5U2cd36v2qgxJfU9Vqy+4EX21tjEvsV4VoJKk7YqabuvMRMw4sFYEgMKLoFJmJAxgJDIF1Eh+QpQaFondvJG40vjhcGIFhzQO4mArPXp0LVOSGs6Bpz3lOOwJhPI8580n4nwYhtEcxUh0Kb4NeRHPwIAlVWwqd9j6Dmb0t8HfZnVYRGZ+bWKIidrg9Oha6JW4krOGPfx8ru7Z7cTUsED/gxv8kN0PSRCUEQF5ilGg/OLUgCDJLABHJoJsnbkG6zWZXME7eb/4XftXJZfrZDWdtGU3ZrzTUPRRCiES/6bkgC2Z5stfl23jOLifuKBf+p6cfhFTvVvARNxjErmZsbA9zlgd11QFt7lfILvMprB/7Pi+xjVYXFogIY2/40AhYg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39CFF2B09FE4464ABE8D88893CA8B963@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27809bd4-4b51-4fbb-021d-08d6f22c7004
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2019 07:29:59.7803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB3430
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzE0LzIwMTkgOTowMiBQTSwgQ29uZyBXYW5nIHdyb3RlOg0KPiBPbiBUdWUsIEp1biAx
MSwgMjAxOSBhdCA3OjA1IEFNIFBhdWwgQmxha2V5IDxwYXVsYkBtZWxsYW5veC5jb20+IHdyb3Rl
Og0KPj4gQWxsb3cgc2VuZGluZyBhIHBhY2tldCB0byBjb25udHJhY2sgYW5kIHNldCBjb25udHJh
Y2sgem9uZSwgbWFyaywNCj4+IGxhYmVscyBhbmQgbmF0IHBhcmFtZXRlcnMuDQo+Pg0KPiBUaGlz
IGlzIHRvbyBzaG9ydCB0byBqdXN0aWZ5IHdoeSB5b3Ugd2FudCB0byBwbGF5IHdpdGggTDMgc3R1
ZmYgaW4gTDIuDQo+IFBsZWFzZSBiZSBhcyBzcGVjaWZpYyBhcyB5b3UgY2FuLg0KPg0KPiBBbHNv
LCBwbGVhc2UgZG9jdW1lbnQgaXRzIHVzZSBjYXNlIHRvby4NCj4NCj4gVGhhbmtzLg0KDQpTdXJl
IEknbGwgYWRkIHRoYXQuDQoNCg==
