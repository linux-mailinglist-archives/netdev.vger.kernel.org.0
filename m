Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE11861437
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 08:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfGGGyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 02:54:50 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:11949
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbfGGGyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jul 2019 02:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/YRLR6ppxXyEXpNJw4MxwUg5cvaIHnn/xVRUDEyFyQ=;
 b=IYKtdBZ2TeypIkBYfWSWN+TiVIu2p7u8zyPVAlFPFdGdH+NmQqJrZusyLlnpVu448Z4XbP1YtrmPC/vUiizVz/YliOUi8S9/RCueHhjOQaeY+i2sAenuS7f0eFLpujcHAeVXwbfPyCawDsL2N1G1U3K/S87OyCojYa/75d4WP8M=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3202.eurprd05.prod.outlook.com (10.171.189.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Sun, 7 Jul 2019 06:54:45 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7%4]) with mapi id 15.20.2052.019; Sun, 7 Jul 2019
 06:54:45 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next v3 1/4] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next v3 1/4] net/sched: Introduce action ct
Thread-Index: AQHVMl85LV1deWLVwkCA8rYYCrD8Daa7AZuAgAO7WYA=
Date:   Sun, 7 Jul 2019 06:54:45 +0000
Message-ID: <b9d35c18-3ffd-11d4-2d7b-292842a4a818@mellanox.com>
References: <1562241233-5176-1-git-send-email-paulb@mellanox.com>
 <1562241233-5176-2-git-send-email-paulb@mellanox.com>
 <20190704145521.29f67ba4@cakuba.netronome.com>
In-Reply-To: <20190704145521.29f67ba4@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM7PR03CA0022.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::32) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72d789ba-ad61-4ae7-7ebd-08d702a7fe6e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3202;
x-ms-traffictypediagnostic: AM4PR05MB3202:
x-microsoft-antispam-prvs: <AM4PR05MB3202B48BA0069CE3CFB611E9CFF70@AM4PR05MB3202.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0091C8F1EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(376002)(346002)(396003)(136003)(366004)(199004)(189003)(486006)(2616005)(476003)(66066001)(446003)(7736002)(305945005)(11346002)(4744005)(31696002)(86362001)(14454004)(8676002)(31686004)(8936002)(81156014)(102836004)(71200400001)(71190400001)(5660300002)(81166006)(186003)(54906003)(26005)(53546011)(6506007)(386003)(6246003)(73956011)(6512007)(66556008)(64756008)(66446008)(66946007)(66476007)(68736007)(3846002)(76176011)(4326008)(478600001)(6116002)(316002)(7416002)(52116002)(2906002)(53936002)(99286004)(229853002)(36756003)(6916009)(6436002)(25786009)(256004)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3202;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aJHp7lpUT0yBgPnhvdIOzhKtlHaxrj8yiA/BiaQXQ0Q/A/B4MiRC6bHp5XD+8mIjBUqTuUe1t7A34kKhkerRXzYCmqsMmU1Qt3AOgT8t30rfAvvPj8iziUe2xCQhokD0eYHJHeeE0wnSlD4ec8481dTqFP4uSFnEiGnaHrizhJ9aS+dnXtAC+mliGHXI1nnboIdX6EBfv2df6VPxtKhfA6fT7YCsfzEuoZWyuw1IjKJayTQihRnfBoS5qMm8+/XAjs5qURATuDSDm0d+3504VPKiQE3E++8uNq/jps9UokU6vFFa37CNXBTh9n5JnzuELDlUuvwW/snEGvWazmHLRKX8AbM4TZpLK31ieHoWuhXgx1icXYodt1P1f6rt0/s3g0YT1PZVyWWmdiH7oxJ1T/XbEACj4j+chz1smAKs10M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC023617890EB04C9BD2B3375A800A9F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d789ba-ad61-4ae7-7ebd-08d702a7fe6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2019 06:54:45.3299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3202
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy81LzIwMTkgMTI6NTUgQU0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KDQo+IE9uIFRodSwg
IDQgSnVsIDIwMTkgMTQ6NTM6NTAgKzAzMDAsIFBhdWwgQmxha2V5IHdyb3RlOg0KPj4gK3N0YXRp
YyBjb25zdCBzdHJ1Y3QgbmxhX3BvbGljeSBjdF9wb2xpY3lbVENBX0NUX01BWCArIDFdID0gew0K
Pj4gKwlbVENBX0NUX0FDVElPTl0gPSB7IC50eXBlID0gTkxBX1UxNiB9LA0KPiBQbGVhc2UgdXNl
IHN0cmljdCBjaGVja2luZyBpbiBhbGwgbmV3IHBvbGljaWVzLg0KPg0KPiBhdHRyIDAgbXVzdCBo
YXZlIC5zdHJpY3Rfc3RhcnRfdHlwZSBzZXQuDQoNCg0KVGhhbmtzLCBJJ2xsIGZpeCBpdC4NCg0K
