Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504BA1AE857
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 00:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgDQWkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 18:40:13 -0400
Received: from mail-am6eur05on2068.outbound.protection.outlook.com ([40.107.22.68]:38456
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728762AbgDQWkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 18:40:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W40b3ZVj/ZQnCNUkMFgtpndw6UrqlDqZcmtZY+W8Xu35l7GXdEKZ7h9ZPAZwP/rXkGH+2hkgIahRjMb4ac5OfWGCBblOmmfutGPOILxo+RwToKGBws/i6C5qUikskihZmULxrZUDrokhnyASaDS3WY4oHJmUwqcOdhHvIiks8ODx1Q/8oGNOjAz6RY5J8a5ROclGflF2lBilS69/9UwCwrDvx+pg+7YhpfJdBvtb3Yyqvgvv0gZHP/8DbFteJby3ZUsBzjWVpT5W/aotsdFO421gN0z/z8C3iyVKwIx1sqJKg6R9L4iMcgb/rDnSfEXxv1qZkoSzoDtVQeoIe/pgZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFYLOG8PlQwcjazfBlrgLn5HA6N64xytHHsBhOU37FM=;
 b=jxXt9TUk7L+fQb0kkBKAtPPdpUVhvo35S6XYfrhj5xw9H+WPaXod8okiMKxwC9Abn8xqjTy6YjIJNYrsqDUBXTxz76Ceu8Ta/jjw+mDTogW42hLnoD80u/BLqx7dsUb3m2Zs8V6FsoRdRm3Pvz3Jo75Ytf+rlkr2tkt1gK8K5ayCgRvCcmMx7uQgaki0ePDB3w548nMw4OcItqUyfv6GAyLWYFIDABws0Q+AzrEdA99QauamifqM1krMB0+x9JgPIp9b/zH/m1WTCvDhOEi5lQRO3zee26PZdG9gNIRxnEf5XOUjCbG7rpckSi5ClyFW+aeCIt+MYvIEFdJVA/yVPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFYLOG8PlQwcjazfBlrgLn5HA6N64xytHHsBhOU37FM=;
 b=ntU3SF4pZka1sLn40qpFfJb6wa4F7fviKi0iagFUKOWG4eR0vxTXwApW5gXsfyvgmAas00FRodWzRAMraCxtco2gdjD/i0MTU3XsTlRQ21YjX0PoImmTJHku2fp90graY+ZcF5KijY2oS1jmMkNuS199qwjS66kMg8gdn+9rcZk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6350.eurprd05.prod.outlook.com (2603:10a6:803:fb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Fri, 17 Apr
 2020 22:40:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 22:40:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "xianfengting221@163.com" <xianfengting221@163.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "lsahlber@redhat.com" <lsahlber@redhat.com>,
        "kw@linux.com" <kw@linux.com>,
        "xiubli@redhat.com" <xiubli@redhat.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wqu@suse.com" <wqu@suse.com>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "stfrench@microsoft.com" <stfrench@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5: add the missing space character
Thread-Topic: [PATCH v2] net/mlx5: add the missing space character
Thread-Index: AQHWCXBS9ROcHN2SK0+YUleKNIIPWqhvqOGAgAw/QICAANnkAIAADjEAgAEvMQA=
Date:   Fri, 17 Apr 2020 22:40:08 +0000
Message-ID: <cc28a4bf79e8edbe4a27fac068ce556e8b9da2da.camel@mellanox.com>
References: <20200403042659.9167-1-xianfengting221@163.com>
         <14df0ecf093bb2df4efaf9e6f5220ea2bf863f53.camel@mellanox.com>
         <fae7a094-62e8-d797-a89b-23faf0eb374e@163.com>
         <a77ddcfad6bfd68b9d69e0d5a18cf5d66692d270.camel@mellanox.com>
         <4861c789-a333-efea-6d51-ab5511645dcf@163.com>
In-Reply-To: <4861c789-a333-efea-6d51-ab5511645dcf@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b023c4bc-3bd6-4457-f2b0-08d7e3204841
x-ms-traffictypediagnostic: VI1PR05MB6350:|VI1PR05MB6350:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6350A5DF1A31384D0EE0D815BED90@VI1PR05MB6350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(316002)(66476007)(478600001)(66556008)(66446008)(966005)(91956017)(66946007)(7416002)(64756008)(86362001)(110136005)(76116006)(4326008)(54906003)(6512007)(36756003)(2616005)(71200400001)(186003)(81156014)(5660300002)(6506007)(2906002)(6486002)(53546011)(8676002)(8936002)(26005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f1BDd2SA8BHAXDLEpm/4AhJLZ570xFGWSPL+SI6m3uhJAt0eoytw1Vp4eOYvTkvtLpzA2MKRY2sUhPLFNp9E/vTK1PZzjG9Hl7yyFBIk/jZjVAoQQTFiIlR50FhltBwxNTU/IzhaM4EmZB9WQnxNffCSEE3Od4o4wms0uD0hynMRr5K9PqtbkHmSZ9QMknfIWtmbAAbGMCmTTyXErWEavFWPQP4S+TBbqJItkv6ApIJFlb9eEW9BjGhWAVn/ataEZYevYO3BkFGubWQ4US6hJeZJrk0Vl3XWB/8WvXz48pxLeGqW71JKycvUCM/VAvcRIqAkfSA9vev5FMxxDXZx59VHCdf8FLnL5eeki/PEDHQKSl80ZK318P+gkIqWKmUgfaCcW0em2Zn7w0kjRaZw8Wk57+lOFlBjskETSFhaWkBtQHR3x0rGob/YJCX5WZqjqRxKWOiGr2HG7l+YkFVADDOfF7gbc5UsWhvuCYHFxPIy1Fgrc7i6+xUWX+nswx2hYwpr2ft8N5/JP0zc3H/pxQ==
x-ms-exchange-antispam-messagedata: Sf5t1Vi+yUuJZ5fg6tHgWm6TKu2zLfyUTIiKRF0wF8W0iOp5T59neiIzx0pRk7P9mWdkLEpqk6mSfoO0e3jIHn/U+mZAkBpbQV7nvhf1QokOo31iyzafjLJL6ejbvc7eW7mD5L28iiW8mPmwfS98Iw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D710F895E2AB8499BA13B3BEACB7FCA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b023c4bc-3bd6-4457-f2b0-08d7e3204841
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 22:40:08.5635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ZaEGKBbImAOlN2MsyWUF4LnBtm/CObj5v53ENJ2d+s9cJpJHNTFbBFNmcjs6ZBZOLqLjLBMA9wRJplJXvl/fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTE3IGF0IDEyOjM0ICswODAwLCBIdSBIYW93ZW4gd3JvdGU6DQo+IE9u
IDIwMjAvNC8xNyAxMTo0NCBBTSwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+ID4gT24gVGh1LCAy
MDIwLTA0LTE2IGF0IDIyOjQ0ICswODAwLCBIdSBIYW93ZW4gd3JvdGU6DQo+ID4gPiBPbiAyMDIw
LzQvOSAzOjQyIEFNLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiA+ID4gT24gRnJpLCAyMDIw
LTA0LTAzIGF0IDEyOjI2ICswODAwLCBIdSBIYW93ZW4gd3JvdGU6DQo+ID4gPiA+ID4gQ29tbWl0
IDkxYjU2ZDg0NjJhOSAoIm5ldC9tbHg1OiBpbXByb3ZlIHNvbWUgY29tbWVudHMiKSBkaWQNCj4g
PiA+ID4gPiBub3QNCj4gPiA+ID4gPiBhZGQNCj4gPiA+ID4gPiB0aGF0IG1pc3Npbmcgc3BhY2Ug
Y2hhcmFjdGVyIGFuZCB0aGlzIGNvbW1pdCBpcyB1c2VkIHRvIGZpeA0KPiA+ID4gPiA+IGl0DQo+
ID4gPiA+ID4gdXAuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gRml4ZXM6IDkxYjU2ZDg0NjJhOSAo
Im5ldC9tbHg1OiBpbXByb3ZlIHNvbWUgY29tbWVudHMiKQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiBQ
bGVhc2UgcmUtc3BpbiBhbmQgc3VibWl0IHRvIG5ldC1uZXh0IG9uY2UgbmV0LW5leHQgcmUtb3Bl
bnMsDQo+ID4gPiA+IGF2b2lkIHJlZmVyZW5jaW5nIHRoZSBhYm92ZSBjb21taXQgc2luY2UgdGhp
cyBwYXRjaCBpcyBhIHN0YW5kDQo+ID4gPiA+IGFsb25lDQo+ID4gPiA+IGFuZCBoYXMgbm90aGlu
ZyB0byBkbyB3aXRoIHRoYXQgcGF0Y2guLiBqdXN0IGhhdmUgYSBzdGFuZCBhbG9uZQ0KPiA+ID4g
PiBjb21taXQNCj4gPiA+ID4gbWVzc2FnZSBleHBsYWluaW5nIHRoZSBzcGFjZSBmaXguDQo+ID4g
PiBTb3JyeSBmb3IgbXkgbGF0ZSByZXBseS4gQmVjYXVzZSBJJ20gYSBrZXJuZWwgbmV3YmllLCBJ
IGtub3cNCj4gPiA+IG5vdGhpbmcNCj4gPiA+IGFib3V0IHRoZSBiYXNpYyBtZXRob2RzIGFuZCBt
YW5uZXJzIGluIHRoZSBrZXJuZWwgZGV2ZWxvcG1lbnQuDQo+ID4gPiBUaGFua3MNCj4gPiA+IGEg
bG90IGZvciB5b3VyIHBhdGllbmNlIG9uIG15IG1pc3Rha2UsIHBvaW50aW5nIGl0IG91dCBhbmQg
Zml4aW5nDQo+ID4gPiBpdA0KPiA+ID4gdXAuDQo+ID4gPiANCj4gPiA+IEJ0dywgZGlkIG5ldC1u
ZXh0IHJlLW9wZW4gYW5kIGRpZCBteSBjaGFuZ2VzIGdldCBpbnRvIHRoZQ0KPiA+ID4gbWFpbmxp
bmU/DQo+ID4gPiANCj4gPiA+IA0KPiA+IE5vcm1hbGx5IG5ldC1uZXh0IGNsb3NlcyBvbmNlIG1l
cmdlIHdpbmRvdyBpcyBvcGVuIGF0IHRoZSBlbmQgb2YNCj4gPiByYzcvcmM4IGtlcm5lbCBjeWNs
ZS4NCj4gPiANCj4gPiBhbmQgcmVvcGVucyBvbiB0aGUgd2VlayBvZiB0aGUga2VybmVsIHJlbGVh
c2UsIGFmdGVyIHRoZSBtZXJnZQ0KPiA+IHdpbmRvdw0KPiA+IGlzIGNsb3NlZCAoMiB3ZWVrcyBh
ZnRlciByYzcvOCBpcyBjbG9zZWQpLg0KPiA+IA0KPiA+IHlvdSBjYW4gdXNlIHRoaXMgbGluay4N
Cj4gPiBodHRwOi8vdmdlci5rZXJuZWwub3JnL35kYXZlbS9uZXQtbmV4dC5odG1sDQo+IA0KPiBP
aC4uLiBUaGFua3MuDQo+IA0KPiBCdXQgaXQncyBtb3JlIHRoYW4gMiB3ZWVrcyBzaW5jZSBMaW51
eCA1LjYgd2FzIHJlbGVhc2VkLCBzbyBuZXQtbmV4dA0KPiBzaG91bGQgYmUgb3BlbiBub3cgYWNj
b3JkaW5nIHRvIHlvdXIgd29yZHMuIEJ1dCBpdCdzIHN0aWxsIGNsb3NlZC4NCj4gDQo+IElzIG15
IGlkZWEgd3Jvbmc/IERvZXMgImtlcm5lbCByZWxlYXNlIiBtZWFuIGFuIC1yYyByZWxlYXNlIG9y
IGENCj4gZm9ybWFsDQo+IHJlbGVhc2U/DQoNCk9oLCBteSBiYWQsIA0KeWVzIHJlbGVhc2UgbWVh
bnMgYSBrZXJuZWwgcmVsZWFzZSAuLiA1LngNCndoYXQgaSBtZWFudCBpcyB3aGVuIHRoZSByYzEg
aXMgb3V0IHR3byB3ZWVrcyBhZnRlciB0aGUga2VybmVsIHJlbGVhc2UuDQoNCg==
