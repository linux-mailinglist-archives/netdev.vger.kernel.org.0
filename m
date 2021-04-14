Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C380035FBF5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349705AbhDNTxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:53:43 -0400
Received: from mail-dm6nam10on2112.outbound.protection.outlook.com ([40.107.93.112]:10241
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348470AbhDNTxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 15:53:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1WBqscLigeEqTLwsVQDXyX43xycp1b79XnVJCNpMe7dWo0I84gRc4X9LXS4iWBxkMwER2blf2wTEAZGJNKHjeaNbqwL7sTIBBf1Wklc9rmMUAulmug45otr4dulgWtUt2R+FNx+xLoph8CbhbaYwzH2aYJvxn3KvK/Dwt3t72FXN1oxwpSyo7q28G+VQOxQzhzrVFLQKi9/uiqeCZ8FJEclfvU+lkPYLAFiZGoUT+HEMIteEwI9MhAW8UHhm/Q6CxPA4AFRzBQPTWtbF8106I+T/ZEZ29ihHU4BkQbJyyo3xpdhEmeVtBY6w7lK0aT2Qw7qdwJBmFfSorvkwoWsbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ErOUL/WaDUaJ5ZiZKI9zN0/qufy83A467/4zQnv60w=;
 b=j/LUo3x4wRpbB9AHUV+U3SZBS/TYR/qjYmLOIRP9p1FFq9X1jOrvwQLaFpcLbBmjpKOSvbiwD2FCbxcHAn5F4jDR7VKndE8co5tCQOOlBqxUARJzoz7feRi9QzYOZM3HEM6zn4gP2O3UQ6f9JiXmRxvCPyJCxTI5xcI8lc6TJS/AFkksJRSsgwx+tQXkAN1OLm+vBL3Z/Wpp2PjWgszRqu7iB5Cp4Xt8Wacd39xUrwphS99uLmuusM7lwM5S+YUHO6XRsP1ciujzD9uPXV28mdsQVvIKL1VZuAt3iQLCOwaAGoLzRSh2BV/U1QT8uc8pB0+zhkuqtYS5hk3WPFUUJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ErOUL/WaDUaJ5ZiZKI9zN0/qufy83A467/4zQnv60w=;
 b=Y1LJ3PJxcjpB3Uv0kAJ8TPpAX//3ew8k3INMmnoCX4rdCBViv/ppQ2J9MRAxJaHThYQuVJAU6QFt7QftXmUhH4GDzz4RHRR5y3boju4oniNNJg6v3gs+b6tThzAv/QMIIUHB7+axv3h000S5GCgDV6i+E2aCPbhE2lH8wbpeK3w=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB1767.namprd22.prod.outlook.com (2603:10b6:610:5d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 14 Apr
 2021 19:53:19 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::fd2f:cbcc:563b:aa4f%5]) with mapi id 15.20.4042.016; Wed, 14 Apr 2021
 19:53:19 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     Tom Parkin <tparkin@katalix.com>
CC:     "jchapman@katalix.com" <jchapman@katalix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: A concurrency bug between l2tp_tunnel_register() and
 l2tp_xmit_core() 
Thread-Topic: A concurrency bug between l2tp_tunnel_register() and
 l2tp_xmit_core() 
Thread-Index: AQHXMIqsY+A0TbPRFUKYRZZmW5mq8Kq0ajiAgAAEUIA=
Date:   Wed, 14 Apr 2021 19:53:19 +0000
Message-ID: <5A32CF92-8EA2-4748-A5B5-1982B8002170@purdue.edu>
References: <400E2FE1-A1E7-43EE-9ABA-41C65601C6EB@purdue.edu>
 <20210414193749.GA4707@katalix.com>
In-Reply-To: <20210414193749.GA4707@katalix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: katalix.com; dkim=none (message not signed)
 header.d=none;katalix.com; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.155]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee05cf57-07de-4eb8-a42e-08d8ff7ef3ca
x-ms-traffictypediagnostic: CH2PR22MB1767:
x-microsoft-antispam-prvs: <CH2PR22MB17676B6DB987787B9370899BDF4E9@CH2PR22MB1767.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIfu1PWs/UgqkB/6QYiKPP5jjsAfYmwfpujRCXhpnhwfNInzKZct3WwSDjMmqDASU1VI1PiwtGzeycelJ+YMK/9ZKQh6wgkBV2KBgCP6kfMPQpG9bhSeCwo89Boa+0MreAJo3+1H6T/svTXCXOrDHooE5bhIfVBQ8s3EjZJodVSlkPQTPGJT9xbbHjUWqlXPPHvNpQOZB3+sYhfyH6tiyJJb5UFI7NCeogSWuluZWF1pnwModnb6nEpV5vyn29DLkPqf5Mv8Q0OKujtISvICcSw05H4CPIzpci10anPhmWlVJSIuDQ/x5CKvotHjX1hBNyBRKFAXxot/3QSI19Hdfs2NzMp0nbgtOS3vHr4CZ+fgcG2wQVFGbZMr5WuLcWr83lpzQ9yCYTEtI3xsufSXsrlkiTl0PYK/bXR40jfbTpZU8jM0jsUgXcDjV+4lhricJlF7zxVKUSI0t6I8vFUXWV6u/aaE/LNWK/Fp0X+p9NDa8tePWoRTmT0M6CFOegZfy7N47pJRAc/426nyEEWpfpUH7wOFUDaJ6+lnrj66li2MwMSZr8/hkolQoHGutJ70eeCZkxSfK5WTapkqhBl3gBX48ArSJLfqp/vYgbU4+pcpE4utoveoLzEtwvRdJag/Mk8jrH+N0tzYFIX+hoxZVa+awNtyPADPhrNLj0/wSh8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(346002)(39860400002)(376002)(2616005)(316002)(786003)(54906003)(38100700002)(66946007)(53546011)(6506007)(71200400001)(5660300002)(36756003)(66556008)(2906002)(6512007)(4743002)(122000001)(26005)(76116006)(6486002)(66446008)(33656002)(64756008)(66476007)(6916009)(478600001)(8936002)(186003)(75432002)(83380400001)(86362001)(8676002)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WXJYSWUwVnk5RTZKV09oNExva2h2QVovTktxK0plMjhPMnU3dTdFV3hxM0Jq?=
 =?utf-8?B?dEtoaUlPSmxLTUo5Q1ZvV2hPS3ZwNlUzT3RBWHBPQkxVSTNsTUF5eTFlVXFq?=
 =?utf-8?B?QlFGRlVPRE91OXJNM21kZzNIY2hGRUdkVHFLOE10K2xNNW13NFN3emZURHJu?=
 =?utf-8?B?TlN4QzFSbFVTMXBtWVhzSlpUbTNRTUU5NUVKY3pNRC9oVVlXaGx3cmFtRXcr?=
 =?utf-8?B?Y0t4K3ptQmg2WWpRZWQvc3VtNkpGY3c4SmJJYVc0cGhud2FqU2lJVjdYNGFO?=
 =?utf-8?B?UmtRQ0dCV3k1UDQzMzhnY2oyd2cyeWhoamhjVklwZVhxN1d0c3JWVHNsWlJy?=
 =?utf-8?B?a0psTXBNdlR0bzZJanJUR1BrL2lyVUttMWExZnhMRUJSVjFFSWJNQ2U1aDBs?=
 =?utf-8?B?T0Q2dEl6NU5XdXV3YStua053M1YwY2NMUk02VUwzN2Y1aEg2TVkvWTJ4Znh3?=
 =?utf-8?B?ZkpQY3lnNmVIL3I2ZG41UUhvK20wS0pMZ28wejVjZzBGKzhqeHZ1bCttNVlp?=
 =?utf-8?B?YVpmd2NOV2g0QzZ6cUZiTlRqVCtDcS9ZaWRpbXgxQkJublRVS2k3Vkd4anZh?=
 =?utf-8?B?ejBKQjdKSUllNlpDdWN0dmJDNG93U2gzdDdEc1dWOXFXSHhmTGFFcXNCc2Nn?=
 =?utf-8?B?Z2JINDhBNS9aeUxkY3ZObmQrYS9sSC9sN0cveXhUVE16eUY5bXpRR0FkaXRH?=
 =?utf-8?B?NWMyKzVYSVhSU05kYkN0U2ZvWVNwbHNrY1ZVRU4rQU5qTGJkZ2piS3U3Z2lT?=
 =?utf-8?B?S0NRcXFDWFdUUWV6UlJHTTdBbXBWMW5tL1RnRko5ZmtiYXJlWGpnSTZjTEMw?=
 =?utf-8?B?VzU5SW9HTlUvV0tlZ09ydnQ0L0psWXJEN3VYQkc0OE1IbXdrMXVYV1JSTFda?=
 =?utf-8?B?bzE1aU9LZFFiNjJ1VFQ1MmI4cDB0NkcyS0NKRUZEVWkwU0w4S0NQOHJ0NEIy?=
 =?utf-8?B?ZFhrZjY3bHpJYmY3aUtyTS9MZ2RyK0g5UHNLenBFSUtha2VoQ1hIL1E5S09p?=
 =?utf-8?B?anhsb2sxYTZvT2dKMXBsN2o3NU5vYytsSENEL1psS3BnNUY3endob2JnOW1O?=
 =?utf-8?B?MEl1OUFCNmNnY1JsU3hzem9xVkRSeG91dGZnem42RGZhUjZwRGoyTFM5bTR0?=
 =?utf-8?B?YUpNTjBEM3JBcVpkUGs2UmhmK21yVVZ0eUtsK2tOVDZMTXVlRzY1RmRKeUs1?=
 =?utf-8?B?Zk12dFpZZXk4Y1MvNG9wMm1QbTN3ZXRuSXlYY0VhMDYwbVY2R0xGbTN0M0ZZ?=
 =?utf-8?B?eFNzWEcvcjhBZHhvTkl4bFBrbW5OOGtRdi9kUk5YTVorYnBacmVmeXNsQ3FC?=
 =?utf-8?B?OEU5VHpNQkZWQmJwSmRvQUpiZ2pBbjBBOVR3S09QaUFSQVhhMVB3OERiR2dz?=
 =?utf-8?B?Y3RrQlEySk9YbVJ1ZGhwY1Y5VllLQnF1NlZEQTFIT2pFZC8vbGRpRkdCU0Nj?=
 =?utf-8?B?ZGppTTNtV2tOdGE0RlpScDdCYm8zOE9BZkw5Q2Jqb05vWXNlS1g5WVpYeDd4?=
 =?utf-8?B?Zkd5ZGtsR3pvNFp4N2ZZNk9mcWtMS2dVbWxjS1VUdFdVYUV6akhva2VmRFpO?=
 =?utf-8?B?ZURUeWRyYVJydThpdWZTZDlFZDlYcGhJQnBreFV3dzNFZ25QcURmdENJMXRN?=
 =?utf-8?B?TzNEd1RwM3RuQkZtaHFPTXY4ZkJWRytnTFR2ZHU5bitVTC83WERkR1IrTTl0?=
 =?utf-8?B?SHovK3FCS0s1WExJbmJtYmRWRTI0LzZmd2ZRU2hUbUVZaWZlSHNkTEtlYXc4?=
 =?utf-8?Q?N6/++XPWI0dPo5TS/a7sPAo3Qyzw6VwEhfE5LlX?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A779C7A04F9024BAAC952656121682D@namprd22.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee05cf57-07de-4eb8-a42e-08d8ff7ef3ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2021 19:53:19.3005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TX1qTNbV96VmQFITIAPA0p1ksMVeXTEuiUfQg+YCRH2QQ+vs3Ww4f4jeiuHywfBfTEBvQxBfrJyNo1pOtFDLrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB1767
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gQXByIDE0LCAyMDIxLCBhdCAzOjM3IFBNLCBUb20gUGFya2luIDx0cGFya2luQGthdGFsaXgu
Y29tPiB3cm90ZToNCj4gDQo+IE9uICBUdWUsIEFwciAxMywgMjAyMSBhdCAxNzozMDoxNyArMDAw
MCwgR29uZywgU2lzaHVhaSB3cm90ZToNCj4+IEhpLA0KPj4gDQo+PiBXZSBmb3VuZCBhIGNvbmN1
cnJlbmN5IGJ1ZyBpbiBsaW51eCA1LjEyLXJjMyBhbmQgd2UgYXJlIGFibGUgdG8gcmVwcm9kdWNl
IGl0IHVuZGVyIHg4Ni4gVGhpcyBidWcgaGFwcGVucyB3aGVuIHR3byBsMnRwIGZ1bmN0aW9ucyBs
MnRwX3R1bm5lbF9yZWdpc3RlcigpIGFuZCBsMnRwX3htaXRfY29yZSgpIGFyZSBydW5uaW5nIGlu
IHBhcmFsbGVsLiBJbiBnZW5lcmFsLCBsMnRwX3R1bm5lbF9yZWdpc3RlcigpIHJlZ2lzdGVyZWQg
YSB0dW5uZWwgdGhhdCBoYXNu4oCZdCBiZWVuIGZ1bGx5IGluaXRpYWxpemVkIGFuZCB0aGVuIGwy
dHBfeG1pdF9jb3JlKCkgdHJpZXMgdG8gYWNjZXNzIGFuIHVuaW5pdGlhbGl6ZWQgYXR0cmlidXRl
LiBUaGUgaW50ZXJsZWF2aW5nIGlzIHNob3duIGJlbG93Li4NCj4+IA0KPj4gLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+PiBFeGVjdXRpb24gaW50ZXJsZWF2aW5n
DQo+PiANCj4+IFRocmVhZCAxCQkJCQkJCQkJCQkJVGhyZWFkIDINCj4+IA0KPj4gbDJ0cF90dW5u
ZWxfcmVnaXN0ZXIoKQ0KPj4gCXNwaW5fbG9ja19iaCgmcG4tPmwydHBfdHVubmVsX2xpc3RfbG9j
ayk7DQo+PiAJCeKApg0KPj4gCQlsaXN0X2FkZF9yY3UoJnR1bm5lbC0+bGlzdCwgJnBuLT5sMnRw
X3R1bm5lbF9saXN0KTsNCj4+IAkJLy8gdHVubmVsIGJlY29tZXMgdmlzaWJsZQ0KPj4gCXNwaW5f
dW5sb2NrX2JoKCZwbi0+bDJ0cF90dW5uZWxfbGlzdF9sb2NrKTsNCj4+IAkJCQkJCQkJCQkJCQlw
cHBvbDJ0cF9jb25uZWN0KCkNCj4+IAkJCQkJCQkJCQkJCQkJ4oCmDQo+PiAJCQkJCQkJCQkJCQkJ
CXR1bm5lbCA9IGwydHBfdHVubmVsX2dldChzb2NrX25ldChzayksIGluZm8udHVubmVsX2lkKTsN
Cj4+IAkJCQkJCQkJCQkJCQkJLy8gU3VjY2Vzc2Z1bGx5IGdldCB0aGUgbmV3IHR1bm5lbCAgCQkJ
CQ0KPj4gCQkJCQkJCQkJCQkJCeKApg0KPj4gCQkJCQkJCQkJCQkJCWwydHBfeG1pdF9jb3JlKCkN
Cj4+IAkJCQkJCQkJCQkJCQkJc3RydWN0IHNvY2sgKnNrID0gdHVubmVsLT5zb2NrOw0KPj4gCQkJ
CQkJCQkJCQkJCQkvLyB1bmluaXRpYWxpemVkLCBzaz0wICANCj4+IAkJCQkJCQkJCQkJCQkJ4oCm
DQo+PiAJCQkJCQkJCQkJCQkJCWJoX2xvY2tfc29jayhzayk7DQo+PiAJCQkJCQkJCQkJCQkJCS8v
IE51bGwtcG9pbnRlciBleGNlcHRpb24gaGFwcGVucw0KPj4gCeKApg0KPj4gCXR1bm5lbC0+c29j
ayA9IHNrOw0KPj4gDQo+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0NCj4+IEltcGFjdCAmIGZpeA0KPj4gDQo+PiBUaGlzIGJ1ZyBjYXVzZXMgYSBrZXJuZWwgTlVM
TCBwb2ludGVyIGRlZmVyZW5jZSBlcnJvciwgYXMgYXR0YWNoZWQgYmVsb3cuIEN1cnJlbnRseSwg
d2UgdGhpbmsgYSBwb3RlbnRpYWwgZml4IGlzIHRvIGluaXRpYWxpemUgdHVubmVsLT5zb2NrIGJl
Zm9yZSBhZGRpbmcgdGhlIHR1bm5lbCBpbnRvIGwydHBfdHVubmVsX2xpc3QuDQo+PiANCj4+IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4gQ29uc29sZSBvdXRw
dXQNCj4+IA0KPj4gWyAgODA2LjU2Njc3NV1bVDEwODA1XSBCVUc6IGtlcm5lbCBOVUxMIHBvaW50
ZXIgZGVyZWZlcmVuY2UsIGFkZHJlc3M6IDAwMDAwMDcwDQo+PiBbICA4MDcuMDk3MjIyXVtUMTA4
MDVdICNQRjogc3VwZXJ2aXNvciByZWFkIGFjY2VzcyBpbiBrZXJuZWwgbW9kZQ0KPj4gWyAgODA3
LjY0NzkyN11bVDEwODA1XSAjUEY6IGVycm9yX2NvZGUoMHgwMDAwKSAtIG5vdC1wcmVzZW50IHBh
Z2UNCj4+IFsgIDgwOC4yNTUzNzddW1QxMDgwNV0gKnBkZSA9IDAwMDAwMDAwDQo+PiBbICA4MDgu
NzU3NjQ5XVtUMTA4MDVdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUA0KPj4gWyAgODA5LjM2
Nzc0Nl1bVDEwODA1XSBDUFU6IDEgUElEOiAxMDgwNSBDb21tOiBleGVjdXRvciBOb3QgdGFpbnRl
ZCA1LjEyLjAtcmMzICMzDQo+PiBbICA4MTAuNTkwNjcwXVtUMTA4MDVdIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMDcNCj4+IFsgIDgxMS4xMjYwNDRdW1Qx
MDgwNV0gRUlQOiBfcmF3X3NwaW5fbG9jaysweDE2LzB4NTANCj4+IFsgIDgxMS42NzE3NDddW1Qx
MDgwNV0gQ29kZTogMDAgMDAgMDAgMDAgNTUgODkgZDAgODkgZTUgZTggMjYgOGMgMjAgZmUgNWQg
YzMgOGQgNzQgMjYgMDAgNTUgODkgYzEgODkgZTUgNTMgNjQgZmYgMDUgMGMgOTcgZmIgYzMgMzEg
ZDIgYmIgMDEgMDAgMDAgMDAgODkgZDAgPGYwPiAwZiBiMSAxOSA3NSAwYyA4YiA1ZCBmYyBjOSBj
MyA4ZCBiNCAyNg0KPj4gMDAgMDAgMDAgMDAgOGIgMTUgZTggN2MNCj4+IFsgIDgxMy4zNzU5MTld
W1QxMDgwNV0gRUFYOiAwMDAwMDAwMCBFQlg6IDAwMDAwMDAxIEVDWDogMDAwMDAwNzAgRURYOiAw
MDAwMDAwMA0KPj4gWyAgODEzLjk4OTQ4N11bVDEwODA1XSBFU0k6IGNiYjU5MzAwIEVESTogY2Jh
YzhjMDAgRUJQOiBjZjU0ZmQ2OCBFU1A6IGNmNTRmZDY0DQo+PiBbICA4MTQuNjI5MjA1XVtUMTA4
MDVdIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4IEVGTEFHUzog
MDAwMDAyNDYNCj4+IFsgIDgxNS44MTEwNzldW1QxMDgwNV0gQ1IwOiA4MDA1MDAzMyBDUjI6IDAw
MDAwMDcwIENSMzogMGVmZDMwMDAgQ1I0OiAwMDAwMDY5MA0KPj4gWyAgODE2LjUyNjk1MV1bVDEw
ODA1XSBEUjA6IDAwMDAwMDAwIERSMTogMDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAwMDAw
MDAwDQo+PiBbICA4MTcuMTU4MjE0XVtUMTA4MDVdIERSNjogMDAwMDAwMDAgRFI3OiAwMDAwMDAw
MA0KPj4gWyAgODE3Ljc2MjI1N11bVDEwODA1XSBDYWxsIFRyYWNlOg0KPj4gWyAgODE4LjMyMjE5
Ml1bVDEwODA1XSAgbDJ0cF94bWl0X3NrYisweDExYS8weDUzMA0KPj4gWyAgODE4Ljg3NjA5N11b
VDEwODA1XSAgcHBwb2wydHBfc2VuZG1zZysweDE2MC8weDI5MA0KPj4gWyAgODE5LjQzODIyNF1b
VDEwODA1XSAgc29ja19zZW5kbXNnKzB4MmQvMHg0MA0KPj4gWyAgODIwLjA3Nzk5OV1bVDEwODA1
XSAgX19fX3N5c19zZW5kbXNnKzB4MWEyLzB4MWQwDQo+PiBbICA4MjAuNjk0OTI4XVtUMTA4MDVd
ICA/IGltcG9ydF9pb3ZlYysweDEzLzB4MjANCj4+IFsgIDgyMS4yMjAxOTRdW1QxMDgwNV0gIF9f
X3N5c19zZW5kbXNnKzB4OTgvMHhkMA0KPj4gWyAgODIxLjkyNzg4Nl1bVDEwODA1XSAgPyBmaWxl
X3VwZGF0ZV90aW1lKzB4NGIvMHgxMzANCj4+IFsgIDgyMi40NTgyNDVdW1QxMDgwNV0gID8gdmZz
X3dyaXRlKzB4MzJjLzB4M2YwDQo+PiBbICA4MjMuMDAyNTkzXVtUMTA4MDVdICBfX3N5c19zZW5k
bXNnKzB4MzkvMHg4MA0KPj4gDQo+PiANCj4+IA0KPj4gVGhhbmtzLA0KPj4gU2lzaHVhaQ0KPj4g
DQo+IA0KPiBIaSBTaXNodWFpLA0KPiANCj4gVGhhbmtzIGZvciB0aGUgcmVwb3J0IQ0KPiANCj4g
WW91ciBhbmFseXNpcyBsb29rcyBjb3JyZWN0IHRvIG1lLCBhbmQgdGhlIHN1Z2dlc3RlZCBmaXgg
c291bmRzDQo+IHJlYXNvbmFibGUgdG9vLg0KVGhhbmtzLCBJIGFtIGdsYWQgSSBjb3VsZCBiZSBo
ZWxwZnVsOikNCj4gSXMgdGhpcyBzb21ldGhpbmcgeW91IHBsYW4gdG8gc3VibWl0IGEgcGF0Y2gg
Zm9yPw0KV2UgYXJlIG5vdCBwbGFubmluZyB0byBzdWJtaXQgYSBwYXRjaCBmb3Igbm93IGJlY2F1
c2Ugd2UgdGhpbmsgZXhwZXJpZW5jZWQgZGV2ZWxvcGVyIGhhdmUgbW9yZSBjb21wcmVoZW5zaXZl
IHZpZXcgdGhhbiB1cywgYnV0IHdlIGFyZSB2ZXJ5IGhhcHB5IHRvIHRlc3QgYW55IHBvdGVudGlh
bCBwYXRjaGVzLg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBUb20NCg0K
