Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5891F6F98
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 23:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgFKVvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 17:51:37 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:18181
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbgFKVvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 17:51:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvhL0wIW3R0m7XifpvDt9GSbHaxxOoyO5i3ncjvesdnieNlnTHK38eA7N1gvW5AQsQsOvsvhTqt1Ai8xcGcwX6GwG8vUHjd0PVoKxw+ElEK6DvUgP2GmoxE+oNPGG1+bNiZJckAPIkVems8xvpWdYKudSkSfQoSsij9alZ4WoyYa5fQuzv5yTSIWlJCtv91KoGmweg2axkdexkcyu+aZPw/2QcIU5KxKsnV1Ge71bNh1PdfvyUPeyng9dq2dZZpE1Hc88zlI1F6mjd/j9rjVKPL9fgNsPUCq4/0n62bRHlRbgLktfskwUqDHS+ASdIyae1LfBGngdRNvgDC1rkOC1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9KGZRYqH37evKSCIRokCymukwT7+lxKmXLJ1YJvbOY=;
 b=R3iggE5q6eV6b7il/8gN5Qcu8vPPw9ljVDtSxrugoEIl311nRJBbo/6wZqBV5ZVnbfkbk95NSxHJtUPjOZcfKNjF51D/JO9pzC9rChR883/zE+5q/JyS4lWyecIcksNvz2X2/L4/hv+F2cJj6URA7ONXHNfjmIvURvwj/O9bP2dg9oQ7WEg6SqffcryHHYftVI0Fcj68aD/NLcdXTL2w1DD6IIe1RjMoqqEMD00SH1RedcYfwpSw1Aa9wdZ5NdUd+9rwszDObHrY8G2Z5DKY2BrigJXGoKzMFfAG5FCj8sISiy48qrKtKin6ZdyodVld3Su50fxyl8GaYmNC4qFBOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9KGZRYqH37evKSCIRokCymukwT7+lxKmXLJ1YJvbOY=;
 b=hGwcK7Z9e0YdTbIprU+Hp1JIdqA6G0JFLeNidVYZy8JysxUWarcoYgoSQS8INIfy+txiFkMYB2KB4VkYYvcwp8y5JgaI1DjTA9LF5IRszQYThbViIK/VvEAAtqQINfjRCuwnD86/CHX0EeDXBkgIqDQzaNnGa5XmN48HrY+cQwo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5360.eurprd05.prod.outlook.com (2603:10a6:803:a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 21:51:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 21:51:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jarod@redhat.com" <jarod@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/4] mlx5: become aware of when running as a
 bonding slave
Thread-Topic: [PATCH net-next v2 3/4] mlx5: become aware of when running as a
 bonding slave
Thread-Index: AQHWP1lNthEWdpqZ4kekL+uaCFqBK6jT9jgA
Date:   Thu, 11 Jun 2020 21:51:31 +0000
Message-ID: <68f2ff6ee06bf4520485121b15c0d8c10cad60d2.camel@mellanox.com>
References: <20200608210058.37352-1-jarod@redhat.com>
         <20200610185910.48668-1-jarod@redhat.com>
         <20200610185910.48668-4-jarod@redhat.com>
In-Reply-To: <20200610185910.48668-4-jarod@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2edf5455-b673-41df-3c4c-08d80e519a5e
x-ms-traffictypediagnostic: VI1PR05MB5360:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5360F130180B11ED6407F158BE800@VI1PR05MB5360.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WFMuXBZX493hhH5/FGAZUxN2rw7rgqhpZsHFo3oVbHBUOB0eaNAXkEAIkti079FyK6OoNH3+xHNatG1BO6tNqV0or+z1tVwlDUU5ysVCJWBi7naz07bpuuYxS9BcDYgWQgHsAw87mrwniwyJLxhQjBA+IR9Dwvyskl8bj3rHPS0kEMfCtmbQG+FofCf0klah22d7pW2cPprQA+iiZEqkFnIcSJCZMPzMXpDVU1vtH8+ZFfWVCrZusVE87kspowEqOsoQkerNbTJEm/IvqEVZFdINmD7R7G81p+9OY3yWbrguadpvakK7AKJ8HaPZcNEr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(36756003)(2616005)(66446008)(110136005)(86362001)(54906003)(6486002)(5660300002)(6512007)(83380400001)(8936002)(4326008)(66476007)(64756008)(316002)(8676002)(66556008)(66946007)(6506007)(7416002)(2906002)(26005)(478600001)(91956017)(76116006)(71200400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: tmYO0Gw+dRW43WYW5xncFvNmS8M7tLMl7VQxxAQoEDNvsMO4wtAmbs6LBhfeGwwux03n4zZ+CWwEPEK0tIzVkwbPhDtxSweQt3wSrb7LX5dvr2duRbdTB2P6VwSj5wbjB0BeacWAPHsI//M6Uv6LbXlWtZ6+xjQJxFaNEI3sJKU9NLF0tF20l7ZQemRDANvUkrNzXKVpghrrT701lw0YUX3GQb5gklNoOVlfasWMcqgTBm0LhJRlk2V28cPRhIWYSqHJJzsou7SXojzMmIajncWWQZ8UmB+SQsMu1TobOvAni6JbxAT+7QC92lf5SHmkhFr28YS1270rssIKNFcaoB+gUD7FKYwBdDTRTplr8VwSNy7XwN+BmBeU/DGDLl+XqCnjN1cPUwQSEOFceVzMCyzusid3+cbuDvlO+d06oNZpx+rlUaH9+slljiz4+9X8tr7LRTTDPFbWDm9XvfIkxLTvv2qftfQplzEH7qP/FQc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E3D810FE152FC469BA80C9B784B5F89@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edf5455-b673-41df-3c4c-08d80e519a5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 21:51:31.6602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +XJyXckzNlDCfDB9uPH5/Mt0aA5bVxCxcdwcGNeWF4S5HEnMQNHp08h8z2mpPOet0iMHm7JnNwJXkntIDp3ZJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5360
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA2LTEwIGF0IDE0OjU5IC0wNDAwLCBKYXJvZCBXaWxzb24gd3JvdGU6DQo+
IEkndmUgYmVlbiB1bmFibGUgdG8gZ2V0IG15IGhhbmRzIG9uIHN1aXRhYmxlIHN1cHBvcnRlZCBo
YXJkd2FyZSB0bw0KPiBkYXRlLA0KPiBidXQgSSBiZWxpZXZlIHRoaXMgb3VnaHQgdG8gYmUgYWxs
IHRoYXQgaXMgbmVlZGVkIHRvIGVuYWJsZSB0aGUgbWx4NQ0KPiBkcml2ZXIgdG8gYWxzbyB3b3Jr
IHdpdGggYm9uZGluZyBhY3RpdmUtYmFja3VwIGNyeXB0byBvZmZsb2FkDQo+IHBhc3N0aHJ1Lg0K
PiANCj4gQ0M6IEJvcmlzIFBpc21lbm55IDxib3Jpc3BAbWVsbGFub3guY29tPg0KPiBDQzogU2Fl
ZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+IENDOiBMZW9uIFJvbWFub3Zza3kg
PGxlb25Aa2VybmVsLm9yZz4NCj4gQ0M6IEpheSBWb3NidXJnaCA8ai52b3NidXJnaEBnbWFpbC5j
b20+DQo+IENDOiBWZWFjZXNsYXYgRmFsaWNvIDx2ZmFsaWNvQGdtYWlsLmNvbT4NCj4gQ0M6IEFu
ZHkgR29zcG9kYXJlayA8YW5keUBncmV5aG91c2UubmV0Pg0KPiBDQzogIkRhdmlkIFMuIE1pbGxl
ciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IENDOiBKZWZmIEtpcnNoZXIgPGplZmZyZXkudC5r
aXJzaGVyQGludGVsLmNvbT4NCj4gQ0M6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+
DQo+IENDOiBTdGVmZmVuIEtsYXNzZXJ0IDxzdGVmZmVuLmtsYXNzZXJ0QHNlY3VuZXQuY29tPg0K
PiBDQzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiBDQzogbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBKYXJvZCBXaWxzb24gPGphcm9k
QHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX2FjY2VsL2lwc2VjLmMgfCA2ICsrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDYg
aW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9pcHNlYy5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2lwc2VjLmMNCj4gaW5kZXggOTJlYjNiYWQ0
YWNkLi43MmFkNjY2NGJkNzMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9pcHNlYy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9pcHNlYy5jDQo+IEBAIC0yMTAsNiAr
MjEwLDkgQEAgc3RhdGljIGlubGluZSBpbnQNCj4gbWx4NWVfeGZybV92YWxpZGF0ZV9zdGF0ZShz
dHJ1Y3QgeGZybV9zdGF0ZSAqeCkNCj4gIAlzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2ID0geC0+
eHNvLmRldjsNCj4gIAlzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdjsNCj4gIA0KPiArCWlmICh4LT54
c28uc2xhdmVfZGV2KQ0KPiArCQluZXRkZXYgPSB4LT54c28uc2xhdmVfZGV2Ow0KPiArDQoNCkRv
IHdlIHJlYWxseSBuZWVkIHRvIHJlcGVhdCB0aGlzIHBlciBkcml2ZXIgPyANCndoeSBub3QganVz
dCBzZXR1cCB4c28ucmVhbF9kZXYsIGluIHhmcm0gbGF5ZXIgb25jZSBhbmQgZm9yIGFsbCBiZWZv
cmUNCmNhbGxpbmcgZGV2aWNlIGRyaXZlcnMgPyANCg0KRGV2aWNlIGRyaXZlcnMgd2lsbCB1c2Ug
eHNvLnJlYWxfZGV2IGJsaW5kbHkuDQoNCldpbGwgYmUgdXNlZnVsIGluIHRoZSBmdXR1cmUgd2hl
biB5b3UgYWRkIHZsYW4gc3VwcG9ydCwgZXRjLi4NCg0KDQo+ICAJcHJpdiA9IG5ldGRldl9wcml2
KG5ldGRldik7DQo+ICANCj4gIAlpZiAoeC0+cHJvcHMuYWFsZ28gIT0gU0FEQl9BQUxHX05PTkUp
IHsNCj4gQEAgLTI5MSw2ICsyOTQsOSBAQCBzdGF0aWMgaW50IG1seDVlX3hmcm1fYWRkX3N0YXRl
KHN0cnVjdCB4ZnJtX3N0YXRlDQo+ICp4KQ0KPiAgCXVuc2lnbmVkIGludCBzYV9oYW5kbGU7DQo+
ICAJaW50IGVycjsNCj4gIA0KPiArCWlmICh4LT54c28uc2xhdmVfZGV2KQ0KPiArCQluZXRkZXYg
PSB4LT54c28uc2xhdmVfZGV2Ow0KPiArDQo+ICAJcHJpdiA9IG5ldGRldl9wcml2KG5ldGRldik7
DQo+ICANCj4gIAllcnIgPSBtbHg1ZV94ZnJtX3ZhbGlkYXRlX3N0YXRlKHgpOw0K
