Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE931487A
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 12:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfEFKoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 06:44:12 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:7936
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbfEFKoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 06:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nbZuQfjD78moNYD22lpgQi+NDQAGFjklxsYYdpxcfI=;
 b=ooVVBtcG0qXrgPmie3oN6IoftMhKioEHWsjvRispN7ZnjjxUVLDUXHKim8C75QDGXsog8eoSs/0WYnby1GALLfSANqFFtiq4rbiPbk0/L3R2rfa9rG4DDrJkCvVGYoq0auoEQQllD2IwU2haT+sRETuOFZDuP/MuxGgQb0nOTGo=
Received: from AM5PR0501MB2546.eurprd05.prod.outlook.com (10.169.150.142) by
 AM5PR0501MB2564.eurprd05.prod.outlook.com (10.169.152.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.15; Mon, 6 May 2019 10:44:08 +0000
Received: from AM5PR0501MB2546.eurprd05.prod.outlook.com
 ([fe80::7492:a69b:3c2:8d2a]) by AM5PR0501MB2546.eurprd05.prod.outlook.com
 ([fe80::7492:a69b:3c2:8d2a%2]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 10:44:08 +0000
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>, Saeed Mahameed <saeedm@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [net-next 07/15] net/mlx5: Issue SW reset on FW assert
Thread-Topic: [net-next 07/15] net/mlx5: Issue SW reset on FW assert
Thread-Index: AQHVAtoiMYHIQJMNSE2ncyR9JF0TDKZcq2KAgAFAHoA=
Date:   Mon, 6 May 2019 10:44:08 +0000
Message-ID: <b246beff-17ce-f21a-b874-55d6b04dbf07@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-8-saeedm@mellanox.com>
 <20190505153811.GB31501@nanopsycho.orion>
In-Reply-To: <20190505153811.GB31501@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM4PR0101CA0059.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::27) To AM5PR0501MB2546.eurprd05.prod.outlook.com
 (2603:10a6:203:c::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=moshe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 656e289e-98be-462c-c2b6-08d6d20fc458
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM5PR0501MB2564;
x-ms-traffictypediagnostic: AM5PR0501MB2564:
x-microsoft-antispam-prvs: <AM5PR0501MB25646498A2D0207757570EB9D9300@AM5PR0501MB2564.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(8936002)(81166006)(26005)(6636002)(8676002)(81156014)(68736007)(71190400001)(71200400001)(7736002)(2906002)(6436002)(478600001)(6512007)(6116002)(64126003)(305945005)(36756003)(66946007)(66446008)(66556008)(64756008)(66476007)(229853002)(73956011)(6486002)(102836004)(52116002)(446003)(76176011)(11346002)(316002)(6246003)(53546011)(6506007)(386003)(110136005)(54906003)(86362001)(31696002)(4326008)(476003)(486006)(2616005)(65826007)(99286004)(58126008)(107886003)(3846002)(186003)(5660300002)(31686004)(66066001)(14444005)(65956001)(65806001)(256004)(14454004)(53936002)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0501MB2564;H:AM5PR0501MB2546.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: T0g2QhN3UR3ZZ+8v3obamcYbwfL1Tc0Tc+6Z+I2NVQD814utKf6/P7KhrnJDNPHwXtwLSJ8PH+PFPXEp+2xEJjDc2u8A2FnyIwKUVbQCJYmcMtlDG17i8CjN95i3ViJW60q6mPdo/KD1+VBYMBPtb3Pwc4MNneJl9KEdi6zox2teoDv4OLjFANClJt7gUAZCGdrEEzsxuyieKJ8V+pB0I+TZ9l819r5Er/3dFw1IkClCVdAKLJn6tVlai6Hwes/eTCaPB98z4wpEUZzsIGoxaVd1VMsmqzuEKv9HviD7tjDwIdBLVWeSns6RLd3VMES98GO6kX2Fex/+n5X3goedmWXVMB8rFRzpo17ru97ERb5vvWWdnYknuzlYmTgMY704sTtd/sCvMUrt/NAthQPkMogkur7a9OANqQAKIC4fK1U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCDDD7FFA47AF84AB2D30E95CED17971@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 656e289e-98be-462c-c2b6-08d6d20fc458
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 10:44:08.4941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0501MB2564
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvNS8yMDE5IDY6MzggUE0sIEppcmkgUGlya28gd3JvdGU6DQo+IFN1biwgTWF5IDA1
LCAyMDE5IGF0IDAyOjMzOjE4QU0gQ0VTVCwgc2FlZWRtQG1lbGxhbm94LmNvbSB3cm90ZToNCj4+
IEZyb206IEZlcmFzIERhb3VkIDxmZXJhc2RhQG1lbGxhbm94LmNvbT4NCj4+DQo+PiBJZiBhIEZX
IGFzc2VydCBpcyBjb25zaWRlcmVkIGZhdGFsLCBpbmRpY2F0ZWQgYnkgYSBuZXcgYml0IGluIHRo
ZSBoZWFsdGgNCj4+IGJ1ZmZlciwgcmVzZXQgdGhlIEZXLiBBZnRlciB0aGUgcmVzZXQgZ28gdGhy
b3VnaCB0aGUgbm9ybWFsIHJlY292ZXJ5DQo+PiBmbG93LiBPbmx5IG9uZSBQRiBuZWVkcyB0byBp
c3N1ZSB0aGUgcmVzZXQsIHNvIGFuIGF0dGVtcHQgaXMgbWFkZSB0bw0KPj4gcHJldmVudCB0aGUg
Mm5kIGZ1bmN0aW9uIGZyb20gYWxzbyBpc3N1aW5nIHRoZSByZXNldC4NCj4+IEl0J3Mgbm90IGFu
IGVycm9yIGlmIHRoYXQgaGFwcGVucywgaXQganVzdCBzbG93cyByZWNvdmVyeS4NCj4+DQo+PiBT
aWduZWQtb2ZmLWJ5OiBGZXJhcyBEYW91ZCA8ZmVyYXNkYUBtZWxsYW5veC5jb20+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBBbGV4IFZlc2tlciA8dmFsZXhAbWVsbGFub3guY29tPg0KPj4gU2lnbmVkLW9m
Zi1ieTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KPj4gU2lnbmVkLW9mZi1i
eTogRGFuaWVsIEp1cmdlbnMgPGRhbmllbGpAbWVsbGFub3guY29tPg0KPj4gU2lnbmVkLW9mZi1i
eTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+PiAtLS0NCj4+IC4uLi9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9jcmR1bXAuYyB8ICAxMyArLQ0KPj4gLi4u
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMgIHwgMTU3ICsrKysrKysr
KysrKysrKysrLQ0KPj4gLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5j
ICAgIHwgICAxICsNCj4+IC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWx4NV9jb3Jl
LmggICB8ICAgMiArDQo+PiBpbmNsdWRlL2xpbnV4L21seDUvZGV2aWNlLmggICAgICAgICAgICAg
ICAgICAgfCAgMTAgKy0NCj4+IGluY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaCAgICAgICAgICAg
ICAgICAgICB8ICAgMSArDQo+PiA2IGZpbGVzIGNoYW5nZWQsIDE3NiBpbnNlcnRpb25zKCspLCA4
IGRlbGV0aW9ucygtKQ0KPj4NCj4gDQo+IFsuLi5dDQo+IA0KPiANCj4+ICt2b2lkIG1seDVfZXJy
b3Jfc3dfcmVzZXQoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCj4+ICt7DQo+PiArCXVuc2ln
bmVkIGxvbmcgZW5kLCBkZWxheV9tcyA9IE1MWDVfRldfUkVTRVRfV0FJVF9NUzsNCj4+ICsJaW50
IGxvY2sgPSAtRUJVU1k7DQo+PiArDQo+PiArCW11dGV4X2xvY2soJmRldi0+aW50Zl9zdGF0ZV9t
dXRleCk7DQo+PiArCWlmIChkZXYtPnN0YXRlICE9IE1MWDVfREVWSUNFX1NUQVRFX0lOVEVSTkFM
X0VSUk9SKQ0KPj4gKwkJZ290byB1bmxvY2s7DQo+PiArDQo+PiArCW1seDVfY29yZV9lcnIoZGV2
LCAic3RhcnRcbiIpOw0KPiANCj4gTGVmdG92ZXI/DQo+IA0KTm90IGxlZnRvdmVyLCBpdCB3YXMg
anVzdCBtb3ZlZCBmcm9tIG9uZSBwb2ludCB0byBhbm90aGVyLg0K
