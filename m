Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB4E1C00F7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgD3P6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:58:10 -0400
Received: from mail-db8eur05on2053.outbound.protection.outlook.com ([40.107.20.53]:6168
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgD3P6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 11:58:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzXUIHEWQ1I2g38AQNh4V6gMf0cilHwI4JDX2hzbpNUrm8T6B6y2eUjSph5f2BgwHxT0amE5uFygVod7mdBmfIGPOeTMLmDOu9HCvsR5OOszNipMC4Seb0uhGHw4FwQqrvkvn3u3IFE9iYRVSoTG5k1UgdJortyvWm5AUaJghxNbhtwnn2Dq9dmp7nj8du8HQe6goazOUDHI/gfSgk4glntbV3uAHDG4Os9hTd/bLEuBsrw7umKwdo+i22ouN3XqWqOVxBtHSjijHoFecfL/CE2Yh+j1VNtJCVmPC3D+FC8vtvx3UhQqbZoVJbN4oR6By5JO4sk+i8sPiP/2Ox8Mig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkwqgrUJ3gK4EIlL/kP7TenoEXydC4ciSCf5vULGVNo=;
 b=myvH4RQeAiuJBH8k5n6OGuwawG6Yc0Oxa9RHElMiQfY0f5Nj/CgmGX257jbCbs1K9x9CJF0u8MDOjijDBDOWChbH/hz9ZxF5H73erLO7XzPZXJvQXW0j5OWfTr87pWWEYh/iHM92C2H9sYNiWGQHt9RWXTbzZ5ULXkEobTPGKziavCBRNEduagjE3pwRZNxuRa9w/1UhO170fJtwNeWr/OoENgaDrTpJKZLpRyjkL7d32esgYQM1HR5s37+o2SCmmZPRr/YyPBwJjJ50UVGbYok8+aLVhNs48FcaWCj5DsJqSfVWf/8jvJNP1VaRREHfDFR2oHsUPehf7L/+T+l5dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkwqgrUJ3gK4EIlL/kP7TenoEXydC4ciSCf5vULGVNo=;
 b=NaZ8A2/cT0ojZYlo6OeV+BZabOsASjCyNZW0zyfYtr4V+Oc4l6dNnJpDlUoLMZR0XNmYhzo3gHNon+c5zhFatke8Jd376I4cwZiwesRn+BN71nhXIGmD8PprXvzrmdD91flLE4viGxGS4X4UEVcdzkY+MfLe1kr2HrTHRxkntio=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6942.eurprd05.prod.outlook.com (2603:10a6:800:182::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 15:58:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 15:58:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH 1/1] net/mlx5: Call pci_disable_sriov() on remove
Thread-Topic: [PATCH 1/1] net/mlx5: Call pci_disable_sriov() on remove
Thread-Index: AQHWHudo8BynXPiFfkigfe9EJ+7d7qiR0nIA
Date:   Thu, 30 Apr 2020 15:58:04 +0000
Message-ID: <2409e7071482b8d05447b8660abcac15987ad399.camel@mellanox.com>
References: <20200430120308.92773-1-schnelle@linux.ibm.com>
         <20200430120308.92773-2-schnelle@linux.ibm.com>
In-Reply-To: <20200430120308.92773-2-schnelle@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b4b51150-54e2-490c-5d87-08d7ed1f44a2
x-ms-traffictypediagnostic: VI1PR05MB6942:
x-microsoft-antispam-prvs: <VI1PR05MB6942578C77CE45EF37B03F75BEAA0@VI1PR05MB6942.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 39tM26UxrHTUsh0uKgPW+wnl0F8tpQd60he6mhgxMDtD/wBtRWy0zdo2a6cEOUHHlnGCJ4Af0zTHQoSOCES/QoVFP3K3Xm+w0j9SdmJeCsiJCN5s5W2LqZfwouHBebelUgGgNOAO1z1c3wSnBOSgOc2ozOmbDnM5JkOOfmCICJzTYIbCr+dRo3pyZ4U4RtKUuKtl8dq7v2EJm2kH4bMAWWBHpl6LBxSvz+Mggi6oSB7Upr67vHESEmaSeJK/Rhq4FGX8G9SJBWJveHyVHPmTVTjnQqlJ0czpbM2GhXzcY3CMCMYJYIehPhy2rsCepN2xIYv2pD3DOuSxVpX5nJH/GVCfXw7Sdic684o/Koub5sPh103ZTyo615VF32J5NOYww6nl4pOc1YN4Ut/kRusXMLpv7jYie3DFzTnk4+rRWIjEqEjF7yNy0/SHwWL3rih9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(5660300002)(8936002)(66946007)(2906002)(4326008)(66556008)(6512007)(8676002)(66446008)(91956017)(66476007)(64756008)(76116006)(6486002)(86362001)(2616005)(478600001)(36756003)(54906003)(186003)(26005)(316002)(6506007)(6916009)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DzCaWgm3T5Drp4v3LT6aJr7/IY2PK3QyWDIEPKoKYnun99dwbAgcN7xm8m8nhrzxQq8vAVxwdNFvmdLvtseHiidzZ+6YSUYe7DE4v7uFyqSwY7vtt/uLq9+lH8aKJRqoEN6LhEU7slBw0rEy3zyS3bUnx2M4yEJyWWhxau15na+NydQIPk3EWdLY7+cX3+zgYeZ12ixf7m6dk5eCKb/TpDEyzk4QvwQhdtoQelbOCF2TBnniRt5d57Lv5dVV5vjhJ4/pN95Wu9AQRIWG3qWYRAEgQbJYewXLmijk7iIjgG0iT3KThiaXZ6ajzolheTqaKTe0rRTYduWzoVm7D8id4HtPykQsD57++RdF4hfZ6obyEIIXk56TDbZHR/Wh3ZqOv6mDfYxfo7oC91nWDWwfj02c9SYYiNphZRdey/qRIjiJgA9BWgZ9U7CjwKyEQfGlXR9Scujik90PiQEH0lErwteKSBY8Dkq0PA1lJ0H+rN2UikEDrkYqqU7ZHkict/wJhocT3pckkqJY7T8N1suNq4eosCVxnHg8wCe8vyEkVscW0AQxEx/gxTEfh76ECfYGVOycVgSdeitn0w+cSeOdm3fT6zrtjoMfLqIKz/zxMdUFgDZV1YM4RBTuMu+6X3BYV5M0ia03yp5EpvopX6T9MyDR/Xhe5DYYQiwl7yWoAwz9XdV+P4dSN2vjS77EbZs9Oq8jKwh84qUF0n75uLeqtc4Yq4IsGIiTbGFpdoQoQtHqAb8QaR3YyHymg6Aov+AXog5H4mnU1Db8uj9FqdHjo4jJ/CZ1eriXn2DMOmLiLYU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <96E15CDB427ED246BE912471EFDF4EB6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b51150-54e2-490c-5d87-08d7ed1f44a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 15:58:04.6665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9fyVIwolMs08EN44bhhAR9TPS+m0VvH7oT/Sm/V0Ph5ybwE4Szlgy8hqV84lfOlDT4tLV9qxqcwSgxv+WZ9iFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6942
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTMwIGF0IDE0OjAzICswMjAwLCBOaWtsYXMgU2NobmVsbGUgd3JvdGU6
DQo+IGFzIGRlc2NyaWJlZCBpbiBEb2N1bWVudGF0aW9uL1BDSS9wY2ktaW92LWhvd3RvLnJzdCBh
IGRyaXZlciB3aXRoIFNSLQ0KPiBJT1YNCj4gc3VwcG9ydCBzaG91bGQgY2FsbCBwY2lfZGlzYWJs
ZV9zcmlvdigpIGluIHRoZSByZW1vdmUgaGFuZGxlci4NCg0KSGkgTmlrbGFzLA0KDQpsb29raW5n
IGF0IHRoZSBkb2N1bWVudGF0aW9uLCBpdCBkb2Vzbid0IHNheSAic2hvdWxkIiBpdCBqdXN0IGdp
dmVzIHRoZQ0KY29kZSBhcyBleGFtcGxlLg0KDQo+IE90aGVyd2lzZSByZW1vdmluZyBhIFBGIChl
LmcuIHZpYSBwY2lfc3RvcF9hbmRfcmVtb3ZlX2J1c19kZXZpY2UoKSkNCj4gd2l0aA0KPiBhdHRh
Y2hlZCBWRnMgZG9lcyBub3QgcHJvcGVybHkgc2h1dCB0aGUgVkZzIGRvd24gYmVmb3JlIHNodXR0
aW5nIGRvd24NCj4gdGhlIFBGLiBUaGlzIGxlYWRzIHRvIHRoZSBWRiBkcml2ZXJzIGhhbmRsaW5n
IGRlZnVuY3QgZGV2aWNlcyBhbmQNCj4gYWNjb21wYW55aW5nIGVycm9yIG1lc3NhZ2VzLg0KPiAN
Cg0KV2hpY2ggc2hvdWxkIGJlIHRoZSBhZG1pbiByZXNwb25zaWJpbGl0eSAuLiBpZiB0aGUgYWRt
aW4gd2FudCB0byBkbw0KdGhpcywgdGhlbiBsZXQgaXQgYmUuLiB3aHkgYmxvY2sgaGltID8gDQoN
Cm91ciBtbHg1IGRyaXZlciBpbiB0aGUgdmYgaGFuZGxlcyB0aGlzIGdyYWNlZnVsbHkgYW5kIG9u
Y2UgcGYNCmRyaXZlci9kZXZpY2UgaXMgYmFjayBvbmxpbmUgdGhlIHZmIGRyaXZlciBxdWlja2x5
IHJlY292ZXJzLg0KDQo+IEluIHRoZSBjdXJyZW50IGNvZGUgcGNpX2Rpc2FibGVfc3Jpb3YoKSBp
cyBhbHJlYWR5IGNhbGxlZCBpbg0KPiBtbHg1X3NyaW92X2Rpc2FibGUoKSBidXQgbm90IGluIG1s
eDVfc3Jpb3ZfZGV0YWNoKCkgd2hpY2ggaXMgY2FsbGVkDQo+IGZyb20NCj4gdGhlIHJlbW92ZSBo
YW5kbGVyLiBGaXggdGhpcyBieSBtb3ZpbmcgdGhlIHBjaV9kaXNhYmxlX3NyaW92KCkgY2FsbA0K
PiBpbnRvDQo+IG1seDVfZGV2aWNlX2Rpc2FibGVfc3Jpb3YoKSB3aGljaCBpcyBjYWxsZWQgYnkg
Ym90aC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5pa2xhcyBTY2huZWxsZSA8c2NobmVsbGVAbGlu
dXguaWJtLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvc3Jpb3YuYyB8IDMgKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL3NyaW92LmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvc3Jpb3YuYw0KPiBpbmRleCAzMDk0ZDIwMjk3YTkuLjI0MDE5NjFjOWY1
YiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L3NyaW92LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L3NyaW92LmMNCj4gQEAgLTExNCw2ICsxMTQsOCBAQCBtbHg1X2RldmljZV9kaXNhYmxlX3NyaW92
KHN0cnVjdCBtbHg1X2NvcmVfZGV2DQo+ICpkZXYsIGludCBudW1fdmZzLCBib29sIGNsZWFyX3Zm
KQ0KPiAgCWludCBlcnI7DQo+ICAJaW50IHZmOw0KPiAgDQo+ICsJcGNpX2Rpc2FibGVfc3Jpb3Yo
ZGV2LT5wZGV2KTsNCj4gKw0KPiAgCWZvciAodmYgPSBudW1fdmZzIC0gMTsgdmYgPj0gMDsgdmYt
LSkgew0KPiAgCQlpZiAoIXNyaW92LT52ZnNfY3R4W3ZmXS5lbmFibGVkKQ0KPiAgCQkJY29udGlu
dWU7DQo+IEBAIC0xNTYsNyArMTU4LDYgQEAgc3RhdGljIHZvaWQgbWx4NV9zcmlvdl9kaXNhYmxl
KHN0cnVjdCBwY2lfZGV2DQo+ICpwZGV2KQ0KPiAgCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYg
ID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOw0KPiAgCWludCBudW1fdmZzID0gcGNpX251bV92Zihk
ZXYtPnBkZXYpOw0KPiAgDQo+IC0JcGNpX2Rpc2FibGVfc3Jpb3YocGRldik7DQoNCnRoaXMgcGF0
Y2ggaXMgbm8gZ29vZCBhcyBpdCBicmVha3MgY29kZSBzeW1tZXRyeS4uIGFuZCBjb3VsZCBsZWFk
IHRvDQptYW55IG5ldyBpc3N1ZXMuDQoNCg0KPiAgCW1seDVfZGV2aWNlX2Rpc2FibGVfc3Jpb3Yo
ZGV2LCBudW1fdmZzLCB0cnVlKTsNCj4gIH0NCj4gIA0KDQo=
