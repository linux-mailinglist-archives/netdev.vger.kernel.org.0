Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09764EE328
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 16:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfKDPI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 10:08:58 -0500
Received: from mail-eopbgr680098.outbound.protection.outlook.com ([40.107.68.98]:38883
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727796AbfKDPI5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 10:08:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f++d+hKklZSlca2GPYTtxnjPbawy3fTZ7eM3yqCH6LVg+SBdaq5L+dNBYaw4kwv04JJkTG5sLyeuEEa3RzgxitgJyFkT0NsfHFCjw/aFvtK8ziuigr5CW+/ZDQ6+5QMtyYvPamTI+OeahHKNoG60HKI53c76zVs2YoOXEKE8yVgNy6GIK75VUJZv3neSdERcSjT4kNO/rDecTn4uA1WgCiqF7uLdvT1RMn9WVvIoL+8vK61Y/56SoyvZbfQY3xIZYmXGk3Hnk3ZYM8RHBRT1H4mxwplKrM9QlxCQof662khXiR5yDQM7yhEND+FFEoYLqS216mqg7GNJorEbcEI2jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLCXeS1gL5d5twtgdHqcQE6EMIGT1P8Aqu39LoHT+IM=;
 b=bmJKmIbthZtQsL8eL/wAgMJgqZdcgR2mjCNs/4Si6VLwi5Qb4T62GLKLKKwYJa+EUKigyjGXWEK7BircnQYTdWreIUvTViAcdlX5iEJTBAPcgZ0YHq8Gq+FtUD7ocJLXccgErCWysDTxCMJ5RNn2mHSVfBJpqWc3NKSfvP2j1g3iBRUtk71V4+Xb6kjSi+Lzi+s0Z4narfnbWAUIBiRbcEN9DD6RQBGcKdni4/XLarsyoLIIqzmO4LognXZD6Pcyk4VPfDRlftdO+xbu3PQBvEIkSgTLv1+LLDdDX7CJKDvzZE9jfoV3Fcz6I7jFfeityZU782+v5qpTaJNiEpw0Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLCXeS1gL5d5twtgdHqcQE6EMIGT1P8Aqu39LoHT+IM=;
 b=g507y0VFrwv450alWGGTEJWCnuCBWXBODklVovobsGmf0XfaqqXDC0HzgyKhOWACcqUy5+SXZS4dDijHETqnPqAj+Fwzbyi/TOUxE+v3E0fbiXiOWjBnPuliLTbxZSFAUoPBo8ZGBO0VA7nBBrANxuRUSaEQiCWW07PoaT3K2u4=
Received: from BYAPR21MB1366.namprd21.prod.outlook.com (20.179.59.143) by
 BYAPR21MB1285.namprd21.prod.outlook.com (20.179.58.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.7; Mon, 4 Nov 2019 15:08:46 +0000
Received: from BYAPR21MB1366.namprd21.prod.outlook.com
 ([fe80::895e:2ab9:ef45:998f]) by BYAPR21MB1366.namprd21.prod.outlook.com
 ([fe80::895e:2ab9:ef45:998f%8]) with mapi id 15.20.2430.020; Mon, 4 Nov 2019
 15:08:46 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Markus Elfring <Markus.Elfring@web.de>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        KY Srinivasan <kys@microsoft.com>,
        Olaf Hering <olaf@aepfle.de>, Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next, 2/4] hv_netvsc: Fix error handling in
 netvsc_attach()
Thread-Topic: [PATCH net-next, 2/4] hv_netvsc: Fix error handling in
 netvsc_attach()
Thread-Index: AQHVjdOlMqN/vjaJcUKbzuSUMA+bEad2zieAgARX9eA=
Date:   Mon, 4 Nov 2019 15:08:43 +0000
Message-ID: <BYAPR21MB13667058A6F6C641EC973327CA7F0@BYAPR21MB1366.namprd21.prod.outlook.com>
References: <1572296801-4789-3-git-send-email-haiyangz@microsoft.com>
 <cdf7b308-940a-ff9c-07ae-f42b94687e24@web.de>
In-Reply-To: <cdf7b308-940a-ff9c-07ae-f42b94687e24@web.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-11-04T15:08:39.9166307Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=50585190-9c09-45ff-9f3c-b2383bb559df;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dd63b10d-399b-4e2e-17cb-08d76138e3f5
x-ms-traffictypediagnostic: BYAPR21MB1285:|BYAPR21MB1285:|BYAPR21MB1285:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BYAPR21MB1285D3AA15ABB76D86C1A976CA7F0@BYAPR21MB1285.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(376002)(136003)(346002)(189003)(199004)(13464003)(99286004)(53546011)(76176011)(8990500004)(6506007)(4326008)(7696005)(6666004)(7736002)(305945005)(11346002)(446003)(6436002)(486006)(26005)(2501003)(102836004)(71200400001)(71190400001)(6246003)(186003)(55016002)(6306002)(2906002)(476003)(3846002)(6116002)(9686003)(10290500003)(66556008)(25786009)(33656002)(110136005)(54906003)(316002)(66066001)(10090500001)(229853002)(74316002)(22452003)(81166006)(5660300002)(2201001)(52536014)(8936002)(8676002)(5024004)(256004)(81156014)(478600001)(76116006)(66446008)(66946007)(14454004)(86362001)(66476007)(64756008)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR21MB1285;H:BYAPR21MB1366.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ibgZl/sFendGpNl8if2v/kXuvXe3aoUDbBF+M8QfU2IVdMPnwDr7prkcTaTS4/sE5x/dY9dbtW9DCmOAF4IUP8equOUmjv/zv0aThe6vkg1bzmcHOB4j7VF3A52HW3m48PUdnFHtO6vf9AbUB1drVHRwY5HuO1grnMHEnJgXS52pIgVVDrwUJ71/nf959aE9AoE8aNnCuJE0Zc3IRD6HYCLRYALdhjkFEYNuyljYi98Ss+jSw3kjwtb0kDIl+0nRhPLsJc/C4OjKWBkVyhf+sKPkIRS1AALMod+b0aFt+WZOgDoa3mzBwyU4B9xFzPTt7XNgJbhw+f0iHCsUcWaZK/48BqWH0Gb33iuGkZC2vmHxDR/DP/TJUU0fXmMP/O4S7+FgHN1f+boTRiso2zTdVswFl4IBh2B/4yBoWbs1SQ1Ph6gyCXRsaSxLT4fACyR
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd63b10d-399b-4e2e-17cb-08d76138e3f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 15:08:43.3507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j+qLMco07I1h7z35RgkKol9g2cTTWn88BEwZONeKBrpUAWjrjNmb8obrT7JazHhTRkIr6HLrROvgjkGx15QVlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFya3VzIEVsZnJpbmcg
PE1hcmt1cy5FbGZyaW5nQHdlYi5kZT4NCj4gU2VudDogRnJpZGF5LCBOb3ZlbWJlciAxLCAyMDE5
IDQ6NDMgUE0NCj4gVG86IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBs
aW51eC0NCj4gaHlwZXJ2QHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0K
PiBDYzoga2VybmVsLWphbml0b3JzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsgRGF2aWQgUy4NCj4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgS1kg
U3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5jb20+OyBPbGFmDQo+IEhlcmluZyA8b2xhZkBhZXBm
bGUuZGU+OyBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+OyBTdGVwaGVuDQo+IEhlbW1p
bmdlciA8c3RoZW1taW5AbWljcm9zb2Z0LmNvbT47IHZrdXpuZXRzIDx2a3V6bmV0c0ByZWRoYXQu
Y29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0LCAyLzRdIGh2X25ldHZzYzogRml4
IGVycm9yIGhhbmRsaW5nIGluDQo+IG5ldHZzY19hdHRhY2goKQ0KPiANCj4gPiBJZiBybmRpc19m
aWx0ZXJfb3BlbigpIGZhaWxzLCB3ZSBuZWVkIHRvIHJlbW92ZSB0aGUgcm5kaXMgZGV2aWNlDQo+
ID4gY3JlYXRlZCBpbiBlYXJsaWVyIHN0ZXBzLCBiZWZvcmUgcmV0dXJuaW5nIGFuIGVycm9yIGNv
ZGUuIE90aGVyd2lzZSwNCj4gPiB0aGUgcmV0cnkgb2YNCj4gPiBuZXR2c2NfYXR0YWNoKCkgZnJv
bSBpdHMgY2FsbGVycyB3aWxsIGZhaWwgYW5kIGhhbmcuDQo+IA0KPiBIb3cgZG8geW91IHRoaW5r
IGFib3V0IHRvIGNob29zZSBhIG1vcmUg4oCcaW1wZXJhdGl2ZSBtb29k4oCdIGZvciB5b3VyDQo+
IGNoYW5nZSBkZXNjcmlwdGlvbj8NCj4gaHR0cHM6Ly9uYW0wNi5zYWZlbGlua3MucHJvdGVjdGlv
bi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGZ2l0LmsNCj4gZXJuZWwub3JnJTJGcHVi
JTJGc2NtJTJGbGludXglMkZrZXJuZWwlMkZnaXQlMkZ0b3J2YWxkcyUyRmxpbnV4LmdpdCUNCj4g
MkZ0cmVlJTJGRG9jdW1lbnRhdGlvbiUyRnByb2Nlc3MlMkZzdWJtaXR0aW5nLQ0KPiBwYXRjaGVz
LnJzdCUzRmlkJTNEMGRiZTZjYjhmN2UwNWJjOTYxMTYwMmVmNDU5ODBhNmM1N2IyNDVhMyUyM24x
NTENCj4gJmFtcDtkYXRhPTAyJTdDMDElN0NoYWl5YW5neiU0MG1pY3Jvc29mdC5jb20lN0MxNjJh
YTAxNmY0NWU0MjkzYw0KPiBhYmIwOGQ3NWYwYzBmZWUlN0M3MmY5ODhiZjg2ZjE0MWFmOTFhYjJk
N2NkMDExZGI0NyU3QzElN0MwJTdDNjM3DQo+IDA4MjM3Nzc5NjI5NTE1OSZhbXA7c2RhdGE9eXRq
eEdZVFBJMkQ0Qm9OYnNsS1B2QmJzZkdVRU03aFhqMVlBaUcNCj4gaG44SWslM0QmYW1wO3Jlc2Vy
dmVkPTANCkFncmVlZC4gVGhhbmtzLg0KDQoNCj4gDQo+IA0KPiDigKYNCj4gPiArKysgYi9kcml2
ZXJzL25ldC9oeXBlcnYvbmV0dnNjX2Rydi5jDQo+ID4gQEAgLTk4Miw3ICs5ODIsNyBAQCBzdGF0
aWMgaW50IG5ldHZzY19hdHRhY2goc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsDQo+ID4gIAlpZiAo
bmV0aWZfcnVubmluZyhuZGV2KSkgew0KPiA+ICAJCXJldCA9IHJuZGlzX2ZpbHRlcl9vcGVuKG52
ZGV2KTsNCj4gPiAgCQlpZiAocmV0KQ0KPiA+IC0JCQlyZXR1cm4gcmV0Ow0KPiA+ICsJCQlnb3Rv
IGVycjsNCj4gPg0KPiA+ICAJCXJkZXYgPSBudmRldi0+ZXh0ZW5zaW9uOw0KPiA+ICAJCWlmICgh
cmRldi0+bGlua19zdGF0ZSkNCj4g4oCmDQo+IA0KPiBJIHdvdWxkIHByZWZlciB0byBzcGVjaWZ5
IHRoZSBjb21wbGV0ZWQgZXhjZXB0aW9uIGhhbmRsaW5nIChhZGRpdGlvbiBvZiB0d28NCj4gZnVu
Y3Rpb24gY2FsbHMpIGJ5IGEgY29tcG91bmQgc3RhdGVtZW50IGluIHRoZSBzaG93biBpZiBicmFu
Y2ggZGlyZWN0bHkuDQo+IA0KPiBJZiB5b3Ugd291bGQgaW5zaXN0IHRvIHVzZSBhIGdvdG8gc3Rh
dGVtZW50LCBJIGZpbmQgYW4gb3RoZXIgbGFiZWwgbW9yZQ0KPiBhcHByb3ByaWF0ZSBhY2NvcmRp
bmcgdG8gdGhlIExpbnV4IGNvZGluZyBzdHlsZS4NCg0KSSB3aWxsIGhhdmUgbW9yZSBwYXRjaGVz
IHRoYXQgbWFrZSBtdWx0aXBsZSBlbnRyeSBwb2ludHMgb2YgZXJyb3IgY2xlYW4gdXAgDQpzdGVw
cyAtLSBzbyBJIHVzZWQgZ290byBpbnN0ZWFkIG9mIHB1dHRpbmcgdGhlIGZ1bmN0aW9ucyBpbiBl
YWNoIGlmLWJyYW5jaC4NCg0KSSB3aWxsIG5hbWUgdGhlIGxhYmVscyBtb3JlIG1lYW5pbmdmdWxs
eS4NCg0KVGhhbmtzLA0KLSBIYWl5YW5nDQo=
