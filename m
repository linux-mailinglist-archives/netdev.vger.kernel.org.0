Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD075F81F
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGDMa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:30:28 -0400
Received: from mail-eopbgr00052.outbound.protection.outlook.com ([40.107.0.52]:25778
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727682AbfGDMa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:30:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvfNd1jxKJ+8aLdqZ+r/vqn7CKeQaxqOt4a6QoPqHZE=;
 b=qzEqm+BzjldkVAyFqcU/n5xWmjuoPCLovPWMxsqQyGooWQDgiiGtPzdv7qTBXa/m/oEJ9pa9bZ7J1rKfi/q2w8oK69XteTUvqPn7Vh/NP4tOWU+T4e3/KVAHAV8GIWapUQIEdjO7j2woj+MJvCl0IEaZvUAFJH/aXLg44/icTEY=
Received: from DB6PR0501MB2485.eurprd05.prod.outlook.com (10.168.74.142) by
 DB6PR0501MB2790.eurprd05.prod.outlook.com (10.172.227.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 4 Jul 2019 12:30:23 +0000
Received: from DB6PR0501MB2485.eurprd05.prod.outlook.com
 ([fe80::b1bb:696d:7e43:7987]) by DB6PR0501MB2485.eurprd05.prod.outlook.com
 ([fe80::b1bb:696d:7e43:7987%6]) with mapi id 15.20.2052.010; Thu, 4 Jul 2019
 12:30:23 +0000
From:   Idan Burstein <idanb@mellanox.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>
Subject: RE: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Thread-Topic: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Thread-Index: AQHVK5iv/PlxMrwrIkOzzXe+rsY0A6as3rOAgACxQjCACUkZgIADlmTA
Date:   Thu, 4 Jul 2019 12:30:17 +0000
Deferred-Delivery: Thu, 4 Jul 2019 12:29:55 +0000
Message-ID: <DB6PR0501MB2485EDCDEA5F8A5E0FADBBDCC5FA0@DB6PR0501MB2485.eurprd05.prod.outlook.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-11-saeedm@mellanox.com>
 <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
 <AM5PR0501MB248327B260F97EF97CD5B80EC5E20@AM5PR0501MB2483.eurprd05.prod.outlook.com>
 <9d26c90c-8e0b-656f-341f-a67251549126@grimberg.me>
In-Reply-To: <9d26c90c-8e0b-656f-341f-a67251549126@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idanb@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15f350ce-c3ac-492a-9d74-08d7007b62e0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2790;
x-ms-traffictypediagnostic: DB6PR0501MB2790:
x-microsoft-antispam-prvs: <DB6PR0501MB279047044B706419BC72EEB6C5FA0@DB6PR0501MB2790.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(13464003)(199004)(189003)(99286004)(33656002)(7696005)(107886003)(5660300002)(53546011)(6246003)(2906002)(486006)(55016002)(6506007)(53936002)(76176011)(110136005)(305945005)(54906003)(7736002)(446003)(476003)(11346002)(66556008)(66066001)(6436002)(66446008)(64756008)(52536014)(14454004)(74316002)(76116006)(6666004)(316002)(9686003)(478600001)(66946007)(66476007)(73956011)(102836004)(81166006)(4326008)(86362001)(8676002)(71200400001)(229853002)(8936002)(25786009)(186003)(81156014)(256004)(26005)(3846002)(6116002)(71190400001)(68736007)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2790;H:DB6PR0501MB2485.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xcFLqyonB9cy6Y/oGqMYoRTy7Y8gmOONRGp3klWWBUd9bW7ZEKdAoFz5ER9w94zoPcUiEF44RNOba4roODIIsp3B3eprkBWlq9vivpWYcGdSH2nGGeJGQLtnC7zQqwsXGI+U2wux/huv2QvkSHLHKsFwe2VLLbrXOVMpm5jh+5XBy8TcHJniJGlpb85pb5eOhodXhggD85tZ0q/x9MV0+KKwvbgbvXOiHda/OprUA+9GXgLH6jWANFj5/LQBm0/e4UXDoa+rVdXynrJxrUcma4FXxxiyOMZLK6V83kRi7FhOPcNa4cU2Uhswbk62FVJESEBiXGrVT/+7UXl52GXrrmo3KwwKz0teE1T7nkQRqYIlobwoR0hSpsc6CQMdJTLJEorcXuGcrstZ7Gr6NfkEPZj4hrDEQ4HTWUi2xJhsv04=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f350ce-c3ac-492a-9d74-08d7007b62e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 12:30:23.4658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idanb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2790
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGVzc2VuY2Ugb2YgdGhlIGR5bmFtaWMgaW4gRElNIGlzIHRoYXQgaXQgd291bGQgZml0IHRv
IHRoZSB3b3JrbG9hZCBydW5uaW5nIG9uIHRoZSBjb3Jlcy4gRm9yIHVzZXIgbm90IHRvIHRyYWRl
IGJhbmR3aWR0aC9jcXUlIGFuZCBsYXRlbmN5IHdpdGggYSBtb2R1bGUgcGFyYW1ldGVyIHRoZXkg
ZG9uJ3Qga25vdyBob3cgdG8gY29uZmlnLiBJZiBESU0gY29uc2lzdGVudGx5IGh1cnRzIGxhdGVu
Y3kgb2YgbGF0ZW5jeSBjcml0aWNhbCB3b3JrbG9hZHMgd2Ugc2hvdWxkIGRlYnVnIGFuZCBmaXgu
DQoNClRoaXMgaXMgd2hlcmUgd2Ugc2hvdWxkIGdvLiBFbmQgZ29hbCBvZiBubyBjb25maWd1cmF0
ZSB3aXRoIG91dCBvZiB0aGUgYm94IHBlcmZvcm1hbmNlIGluIHRlcm1zIG9mIGJvdGggYmFuZHdp
ZHRoL2NwdSUgYW5kIGxhdGVuY3kuDQoNCldlIGNvdWxkIG1ha2Ugc2V2ZXJhbCBzdGVwcyB0b3dh
cmRzIHRoaXMgZGlyZWN0aW9uIGlmIHdlIGFyZSBub3QgbWF0dXJlIGVub3VnaCB0b2RheSBidXQg
bGV0J3MgZGVmaW5lIHRoZW0gKGUuZy4gdGVzdHMgb24gZGlmZmVyZW50IHVscHMpLg0KDQotLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogbGludXgtcmRtYS1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgPGxpbnV4LXJkbWEtb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgU2Fn
aSBHcmltYmVyZw0KU2VudDogVHVlc2RheSwgSnVseSAyLCAyMDE5IDg6MzcgQU0NClRvOiBJZGFu
IEJ1cnN0ZWluIDxpZGFuYkBtZWxsYW5veC5jb20+OyBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1l
bGxhbm94LmNvbT47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IERvdWcg
TGVkZm9yZCA8ZGxlZGZvcmRAcmVkaGF0LmNvbT47IEphc29uIEd1bnRob3JwZSA8amdnQG1lbGxh
bm94LmNvbT4NCkNjOiBMZW9uIFJvbWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+OyBPciBH
ZXJsaXR6IDxvZ2VybGl0ekBtZWxsYW5veC5jb20+OyBUYWwgR2lsYm9hIDx0YWxnaUBtZWxsYW5v
eC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9y
ZzsgWWFtaW4gRnJpZWRtYW4gPHlhbWluZkBtZWxsYW5veC5jb20+OyBNYXggR3VydG92b3kgPG1h
eGdAbWVsbGFub3guY29tPg0KU3ViamVjdDogUmU6IFtmb3ItbmV4dCBWMiAxMC8xMF0gUkRNQS9j
b3JlOiBQcm92aWRlIFJETUEgRElNIHN1cHBvcnQgZm9yIFVMUHMNCg0KSGV5IElkYW4sDQoNCj4g
IiBQbGVhc2UgZG9uJ3QuIFRoaXMgaXMgYSBiYWQgY2hvaWNlIHRvIG9wdCBpdCBpbiBieSBkZWZh
dWx0LiINCj4gDQo+IEkgZGlzYWdyZWUgaGVyZS4gSSdkIHByZWZlciBMaW51eCB0byBoYXZlIGdv
b2Qgb3V0IG9mIHRoZSBib3ggZXhwZXJpZW5jZSAoZS5nLiByZWFjaCAxMDBHIGluIDRLIE5WTWVP
RiBvbiBJbnRlbCBzZXJ2ZXJzKSB3aXRoIHRoZSBkZWZhdWx0IHBhcmFtZXRlcnMuIEVzcGVjaWFs
bHkgc2luY2UgWWFtaW4gaGF2ZSBzaG93biBpdCBpcyBiZW5lZmljaWFsIC8gbm90IGh1cnRpbmcg
aW4gdGVybXMgb2YgcGVyZm9ybWFuY2UgZm9yIHZhcmlldHkgb2YgdXNlIGNhc2VzLiBUaGUgd2hv
bGUgY29uY2VwdCBvZiBESU0gaXMgdGhhdCBpdCBhZGFwdHMgdG8gdGhlIHdvcmtsb2FkIHJlcXVp
cmVtZW50cyBpbiB0ZXJtcyBvZiBiYW5kd2lkdGggYW5kIGxhdGVuY3kuDQoNCldlbGwsIGl0cyBh
IE1lbGxhbm94IGRldmljZSBkcml2ZXIgYWZ0ZXIgYWxsLg0KDQpCdXQgZG8gbm90ZSB0aGF0IGJ5
IGZhciwgdGhlIHZhc3QgbWFqb3JpdHkgb2YgdXNlcnMgYXJlIG5vdCBzYXR1cmF0aW5nIDEwMEcg
b2YgNEsgSS9PLiBUaGUgYWJzb2x1dGUgdmFzdCBtYWpvcml0eSBvZiB1c2VycyBhcmUgcHJpbWFy
aWx5IHNlbnNpdGl2ZSB0byBzeW5jaHJvbm91cyBRRD0xIEkvTyBsYXRlbmN5LCBhbmQgd2hlbiB0
aGUgd29ya2xvYWQgaXMgbXVjaCBtb3JlIGR5bmFtaWMgdGhhbiB0aGUgc3ludGhldGljIDEwMCUv
NTAlLzAlIHJlYWQgbWl4Lg0KDQpBcyBtdWNoIGFzIEknbSBhIGZhbiAoSUlSQyBJIHdhcyB0aGUg
b25lIGdpdmluZyBhIGZpcnN0IHBhc3MgYXQgdGhpcyksIHRoZSBkaW0gZGVmYXVsdCBvcHQtaW4g
aXMgbm90IG9ubHkgbm90IGJlbmVmaWNpYWwsIGJ1dCBwb3RlbnRpYWxseSBoYXJtZnVsIHRvIHRo
ZSBtYWpvcml0eSBvZiB1c2VycyBvdXQtb2YtdGhlLWJveCBleHBlcmllbmNlLg0KDQpHaXZlbiB0
aGF0IHRoaXMgaXMgYSBmcmVzaCBjb2RlIHdpdGggYWxtb3N0IG5vIGV4cG9zdXJlLCBhbmQgdGhh
dCB3YXMgbm90IHRlc3RlZCBvdXRzaWRlIG9mIFlhbWluIHJ1bm5pbmcgbGltaXRlZCBwZXJmb3Jt
YW5jZSB0ZXN0aW5nLCBJIHRoaW5rIGl0IHdvdWxkIGJlIGEgbWlzdGFrZSB0byBhZGQgaXQgYXMg
YSBkZWZhdWx0IG9wdC1pbiwgdGhhdCBjYW4gY29tZSBhcyBhbiBpbmNyZW1lbnRhbCBzdGFnZS4N
Cg0KT2J2aW91c2x5LCBJIGNhbm5vdCB0ZWxsIHdoYXQgTWVsbGFub3ggc2hvdWxkL3Nob3VsZG4n
dCBkbyBpbiBpdHMgb3duIGRldmljZSBkcml2ZXIgb2YgY291cnNlLCBidXQgSSBqdXN0IHdhbnRl
ZCB0byBlbXBoYXNpemUgdGhhdCBJIHRoaW5rIHRoaXMgaXMgYSBtaXN0YWtlLg0KDQo+IE1vcmVv
dmVyLCBuZXQtZGltIGlzIGVuYWJsZWQgYnkgZGVmYXVsdCwgSSBkb24ndCBzZWUgd2h5IFJETUEg
aXMgZGlmZmVyZW50Lg0KDQpWZXJ5IGRpZmZlcmVudCBhbmltYWxzLg0K
