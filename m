Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88A4316D3
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfEaV44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:56:56 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:34170
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfEaV44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 17:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmsWbHc4mN1eBgAzKzH/6JgJjohni4E9HkVlaycVOGE=;
 b=fjbq8zMVf0le9bJFnRTTdIFfQjVa227ggB7cjWAtiATZQuk+13Vj4jcrf/O2K+RJCumhSQ0b57I+IcOq5xgn46fSuxUkaFKMkuKa7t7hPpNaE+NVWLyMbYrI0aMFyjqN3pzoUP6o5rEzmm0IyEM+0XMjeIJaqCnDydT+u0w6I/I=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5916.eurprd05.prod.outlook.com (20.179.9.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Fri, 31 May 2019 21:56:51 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1943.018; Fri, 31 May 2019
 21:56:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "yhs@fb.com" <yhs@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>,
        "bsd@fb.com" <bsd@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 00/16] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Topic: [PATCH bpf-next v3 00/16] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Index: AQHVEhP77EFLAt51B0eS4F+v4SSj1qZ6D+sAgAvDagA=
Date:   Fri, 31 May 2019 21:56:51 +0000
Message-ID: <c5f6ab402de93f0b675d19499490e8c99701b5cc.camel@mellanox.com>
References: <20190524093431.20887-1-maximmi@mellanox.com>
         <8b0450c2-ad5e-ecaa-9958-df4da1dd6456@intel.com>
In-Reply-To: <8b0450c2-ad5e-ecaa-9958-df4da1dd6456@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4651e7b1-92fb-4d2f-258b-08d6e612e372
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB5916;
x-ms-traffictypediagnostic: DB8PR05MB5916:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB8PR05MB59160C0A017EF76201EA148DBE190@DB8PR05MB5916.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(396003)(136003)(366004)(199004)(189003)(99286004)(316002)(25786009)(2616005)(66476007)(14444005)(6306002)(118296001)(476003)(186003)(26005)(53546011)(73956011)(68736007)(11346002)(446003)(7416002)(6506007)(76176011)(102836004)(5660300002)(64756008)(66556008)(66446008)(76116006)(91956017)(66574012)(66946007)(229853002)(486006)(81156014)(7736002)(53936002)(6436002)(6486002)(478600001)(6116002)(3846002)(8676002)(2906002)(81166006)(256004)(8936002)(71190400001)(6636002)(6512007)(54906003)(6246003)(110136005)(966005)(2501003)(305945005)(66066001)(4326008)(14454004)(2201001)(36756003)(71200400001)(86362001)(58126008)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5916;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9UwVVDSu7uhmOrs1S3byV7Tq27nyYV1OTNnufQOO0hWDaRhTnDAx15w3os3etcczrVckeXGJUMYRR0anWSlXTqZpO8OmxE8sDiDD3T+zjTUufSGFsV+/gbMpBr3BG0Il4TRV1m5HsNqEnMWq6P7Dzgtkh/b9n4jvSQclgFltmLYBaBZ+yqy7qmQqCgRTGp3tMNeBAW4syhNsFSXuFXuqeWFspGGWv2Lsqfoh0sz+KL7LUbd8j2BAq7fYF/xF8UYupOMaaleWQIjPjGeKif7LFTcCjvopssNCXvqoA0Mr/qtIXLuS5i6TrrMfgNDUdhQdgFfFhztYYuBjEIRhDedB2sL8Xc3Us3zBp2132f5GpnZ96OxwyUI/3BcCvm8e/NUvUx9GG4vwfwNKOz6db7jYfeObEgeRnB2D4UUkL43n028=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B041F1EE12D024596B1E0E476DAF9D5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4651e7b1-92fb-4d2f-258b-08d6e612e372
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 21:56:51.7273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5916
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA1LTI0IGF0IDEyOjE4ICswMjAwLCBCasO2cm4gVMO2cGVsIHdyb3RlOg0K
PiBPbiAyMDE5LTA1LTI0IDExOjM1LCBNYXhpbSBNaWtpdHlhbnNraXkgd3JvdGU6DQo+ID4gVGhp
cyBzZXJpZXMgY29udGFpbnMgaW1wcm92ZW1lbnRzIHRvIHRoZSBBRl9YRFAga2VybmVsDQo+ID4g
aW5mcmFzdHJ1Y3R1cmUNCj4gPiBhbmQgQUZfWERQIHN1cHBvcnQgaW4gbWx4NWUuIFRoZSBpbmZy
YXN0cnVjdHVyZSBpbXByb3ZlbWVudHMgYXJlDQo+ID4gcmVxdWlyZWQgZm9yIG1seDVlLCBidXQg
YWxzbyBzb21lIG9mIHRoZW0gYmVuZWZpdCB0byBhbGwgZHJpdmVycywNCj4gPiBhbmQNCj4gPiBz
b21lIGNhbiBiZSB1c2VmdWwgZm9yIG90aGVyIGRyaXZlcnMgdGhhdCB3YW50IHRvIGltcGxlbWVu
dCBBRl9YRFAuDQo+ID4gDQo+ID4gDQpbLi4uXQ0KPiANCj4gTWF4aW0sIHRoaXMgZG9lc24ndCBh
ZGRyZXNzIHRoZSB1YXBpIGNvbmNlcm4gd2UgaGFkIG9uIHlvdXIgdjIuDQo+IFBsZWFzZSByZWZl
ciB0byBNYWdudXMnIGNvbW1lbnQgaGVyZSBbMV0uDQo+IA0KPiBQbGVhc2UgZWR1Y2F0ZSBtZSB3
aHkgeW91IGNhbm5vdCBwdWJsaXNoIEFGX1hEUCB3aXRob3V0IHRoZSB1YXBpDQo+IGNoYW5nZT8N
Cj4gSXQncyBhbiBleHRlbnNpb24sIHJpZ2h0PyBJZiBzbywgdGhlbiBleGlzdGluZyBYRFAvQUZf
WERQIHByb2dyYW0gY2FuDQo+IHVzZSBNZWxsYW5veCBaQyB3aXRob3V0IHlvdXIgYWRkaXRpb24/
IEl0J3MgZ3JlYXQgdGhhdCBNZWxsYW5veCBoYXMgYQ0KPiBaQw0KPiBjYXBhYmxlIGRyaXZlciwg
YnV0IHRoZSB1YXBpIGNoYW5nZSBpcyBhIE5BSy4NCj4gDQo+IFRvIHJlaXRlcmF0ZTsgV2UnZCBs
aWtlIHRvIGdldCB0aGUgcXVldWUgc2V0dXAvc3RlZXJpbmcgZm9yIEFGX1hEUA0KPiBjb3JyZWN0
LiBJLCBhbmQgTWFnbnVzLCBkaXNsaWtlIHRoaXMgYXBwcm9hY2guIEl0IHJlcXVpcmVzIGEgbW9y
ZQ0KPiBjb21wbGljYXRlZCBYRFAgcHJvZ3JhbSwgYW5kIGlzIGhhcmQgZm9yIHJlZ3VsYXIgdXNl
cnMgdG8gdW5kZXJzdGFuZC4NCj4gDQo+IA0KDQpIaSBCam9ybiBhbmQgTWFnbnVzLA0KDQpJdCBp
cyBub3QgY2xlYXIgdG8gbWUgd2h5IHlvdSBkb24ndCBsaWtlIHRoaXMgYXBwcm9hY2gsIGlmIGFu
eXRoaW5nLA0KdGhpcyBhcHByb2FjaCBpcyBhZGRyZXNzaW5nIG1hbnkgY29uY2VybnMgeW91IHJh
aXNlZCBhYm91dCBjdXJyZW50DQpsaW1pdGVkIGFwcHJvYWNoIG9mIHJlLXVzaW5nLyJzdGVhbGlu
ZyIgb25seSByZWd1bGFyIFJYIHJpbmdzIGZvciB4c2sNCnRyYWZmaWMgIQ0KDQpmb3IgaW5zdGFu
Y2UgDQoxKSB4c2sgcmluZyBub3cgaGFzIGEgdW5pcXVlIGlkLiAod2Fzbid0IHRoaXMgdGhlIHBs
YW4gZnJvbSB0aGUNCmJlZ2lubmluZyA/KSANCjIpIE5vIFJTUyBpc3N1ZXMsIG9ubHkgZXhwbGlj
aXQgc3RlZXJpbmcgcnVsZXMgZ290IHRoZSB0aGUgbmV3bHkNCmNyZWF0ZWQgaXNvbGF0ZWQgeHNr
IHJpbmcsIGRlZmF1bHQgUlNTIGlzIG5vdCBhZmZlY3RlZCByZWd1bGFyIFJYIHJpbmdzDQphcmUg
c3RpbGwgaW50YWN0Lg0KMykgdGhlIG5ldyBzY2hlbWUgaXMgZmxleGlibGUgYW5kIHdpbGwgYWxs
b3cgYXMgbXVjaCB4c2sgc29ja2V0cyBhcw0KbmVlZGVkLCBhbmQgY2FuIGNvLWV4aXN0IHdpdGgg
cmVndWxhciByaW5ncy4gDQo0KSBXZSB3YW50IHRvIGhhdmUgYSBzb2x1dGlvbiB0aGF0IHdpbGwg
cmVwbGFjZSBEUERLLCBoYXZpbmcgc3VjaA0KbGltaXRhdGlvbnMgb2YgYSBsaW1pdGVkIG51bWJl
ciBvZiBSWCByaW5ncyBhbmQgc3RlYWxpbmcgZnJvbSByZWd1bGFyDQpyaW5ncywgaXMgcmVhbGx5
IG5vdCBhIHdvcnRoeSBkZXNpZ24sIGp1c3QgYmVjYXVzZSBzb21lIGRyaXZlcnMgZG8gbm90DQp3
YW50IHRvIGRlYWwgb3IgZG9uJ3Qga25vdyBob3cgdG8gZGVhbCB3aXRoIGNyZWF0aW5nIGRlZGlj
YXRlZA0KcmVzb3VyY2VzLg0KNSkgaSB0aGluayBpdCBpcyB3cm9uZyB0byBjb21wYXJlIHhzayBy
aW5ncyB3aXRoIHJlZ3VsYXIgcmluZ3MsIHhzaw0KcmluZ3MgYXJlIGFjdHVhbGx5IGp1c3QgYSBh
IGRldmljZSBjb250ZXh0IHRoYXQgcmVkaXJlY3RzIHRyYWZmaWMgdG8gYQ0Kc3BlY2lhbCBidWZm
ZXIgc3BhY2UsIHRoZXJlIGlzIG5vIHJlYWwgbWVtb3J5IGJ1ZmZlcnMgbW9kZWwgYmVoaW5kIGl0
LA0Kb3RoZXIgdGhhbiB0aGUgcngvdHggZGVzY3JpcHRvcnMuIChtZW1vcnkgbW9kZWwgaXMgaGFu
ZGxlZCBvdXRzaWRlIHRoZQ0KZHJpdmVyKS4NCjYpIG1seDUgaXMgZGVzaWduZWQgYW5kIG9wdGlt
aXplZCBmb3Igc3VjaCB1c2UgY2FzZXMgKGRlZGljYXRlZC91bmlxdWUNCnJ4L3R4IHJpbmdzIGZv
ciBYRFApLCBsaW1pdGluZyB1cyB0byBjdXJyZW50IEFGX1hEUCBsaW1pdGF0aW9uIHdpdGhvdXQN
CmFsbG93aW5nIHVzIHRvIGltcHJvdmUgdGhlIEFGX1hEUCBkZXNpZ24gaXMgcmVhbGx5IG5vdCBm
YWlyLg0KDQp0aGUgd2F5IGkgc2VlIGl0LCB0aGlzIG5ldyBleHRlbnNpb24gaXMgYWN0dWFsbHkg
YSBnZW5lcmFsaXphdGlvbiB0bw0KYWxsb3cgZm9yIG1vcmUgZHJpdmVycyBzdXBwb3J0IGFuZCBB
Rl9YRFAgZmxleGliaWxpdHkuDQoNCmlmIHlvdSBoYXZlIGRpZmZlcmVudCBpZGVhcyBvbiBob3cg
dG8gaW1wbGVtZW50IHRoZSBuZXcgZGVzaWduLCBwbGVhc2UNCnByb3ZpZGUgeW91ciBmZWVkYmFj
ayBhbmQgd2Ugd2lsbCBiZSBtb3JlIHRoYW4gaGFwcHkgdG8gaW1wcm92ZSB0aGUNCmN1cnJlbnQg
aW1wbGVtZW50YXRpb24sIGJ1dCByZXF1ZXN0aW5nIHRvIGRyb3AgaXQsIGkgdGhpbmsgaXMgbm90
IGENCmZhaXIgcmVxdWVzdC4NCg0KU2lkZSBub3RlOiBPdXIgdGFzayBpcyB0byBwcm92aWRlIGEg
c2NhbGFibGUgYW5kIGZsZXhpYmxlIGluLWtlcm5lbCBYRFANCnNvbHV0aW9uIHNvIHdlIGNhbiBv
ZmZlciBhIHZhbGlkIHJlcGxhY2VtZW50IGZvciBEUERLIGFuZCB1c2Vyc3BhY2UNCm9ubHkgc29s
dXRpb25zLCBJIHRoaW5rIHdlIG5lZWQgdG8gaGF2ZSBhIHNjaGVtZSB3aGVyZSB3ZSBhbGxvdyBh
bg0KdW5saW1pdGVkIG51bWJlciBvZiB4c2sgc29ja2V0cy9yaW5ncyB3aXRoIGZ1bGwgZmxvdw0K
c2VwYXJhdGlvbi9pc29sYXRpb24gYmV0d2VlbiBkaWZmZXJlbnQgdXNlciBzb2NrZXRzL2FwcHMs
IHRoZSBkcml2ZXIvaHcNCnJlc291cmNlcyBhcmUgcmVhbGx5IHZlcnkgY2hlYXAgKGFzIHRoZXJl
IGlzIG5vIGJ1ZmZlciBtYW5hZ2VtZW50KSBtdWNoDQpjaGVhcGVyIHRoYW4gYWxsb2NhdGluZyBh
IGZ1bGwgYmxvd24gcmVndWxhciBzb2NrZXQgYnVmZmVycy4NCg0KVGhhbmtzLA0KU2FlZWQuDQoN
Cj4gVGhhbmtzLA0KPiBCasO2cm4NCj4gDQo+IFsxXSANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvYnBmL0NBSjh1b3oyVUhrKzV4UHd6LVNUTTlna1FaZG03cl89anNnYUIwbkYrbUhnY2g9YXhQ
Z0BtYWlsLmdtYWlsLmNvbS8NCj4gDQo+IA0K
