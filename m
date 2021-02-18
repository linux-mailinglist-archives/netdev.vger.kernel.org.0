Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6F031E484
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 04:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhBRD2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 22:28:51 -0500
Received: from mail-eopbgr1400105.outbound.protection.outlook.com ([40.107.140.105]:40470
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229720AbhBRD2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 22:28:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sk9JCQoDj/+eWQM8NWj/EM79q7JQiK9NuSiDqsvgtpB3qsUm/ALifVoIvbart86qFQthjGSyfGCIlxYXRTZe1TjnApGCBaXEIZQmHYQ1RLtrQNs+DsoRUqdLFS09ESy5fKEe3pE2UZXT9OV4Y1hjwOMxUZn6YjxFzVyIqvNv6drMNZFbrIMr6OPxnquKWMtsP1MNSOAJAq1ismypgqrYGjvygF9pJNnQF71QWQxHwDThCQn2m2jTo4HXHu2XxSznUb40RfwPtTjhgMxD6JqULenUdGeEcmSDvRx6Oz0+lbXNEvER6U0saXP1pFju0J+MeBUIan7fkU8i2LPRiZZVfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXMHwnNuReQz1e+DyTpPNwmzeuBNsZcPJve9NJj9gn4=;
 b=Ix9zKMbiTe2Z6Uv6UW9V36W78wIWUNsp6h5HtdkNnKPuaRJTgby4fIhlKTVaMnEGXwr5udS2A30uJIXRzfNz6JbXZovyx4aLId9uNXmgLJC++6i9p1tjbszyW8WZj7MTvN4z06jecNxzc/F0R3ISNTYnb+GzNcfh5lrQ9fObJ3b4OGTF2ppk44MU6tfVi8XSdDE44DjlL+m+sVbfCWYI31u15wpe93SKx8fLoXjX/fjJSJkEs3qj4/KsH5z0TGLkluqqVrIqXNp0dqOHvYnqt+m4Y1+Kh4UEZfH+YKw8NmRhbr/uhs+JRBCQwFip1Uj9YsIDnjJyvRZ2YYpOm6aD3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXMHwnNuReQz1e+DyTpPNwmzeuBNsZcPJve9NJj9gn4=;
 b=HIgzYIqTI6gvQGAOjh/iqBtmWPFbn1UBZ5/sUyyma4WFqEfITdsiVZ+l+NanzbZc/zmTPqFlKP/ahC6dsEwA7ZN65OMgA+0m8jOXNqBKiXHaG8is/uuoN/CR/lfHonYrdBopukRFse+Gj10vwMGduVLefjvW/MZj9yySF3DxXt4=
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com (2603:1096:604:7a::23)
 by OSAPR01MB4883.jpnprd01.prod.outlook.com (2603:1096:604:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 03:28:00 +0000
Received: from OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5]) by OSBPR01MB4773.jpnprd01.prod.outlook.com
 ([fe80::1971:336c:e4c0:8c5%3]) with mapi id 15.20.3846.038; Thu, 18 Feb 2021
 03:28:00 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Topic: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
Thread-Index: AQHXACKOoFb+ofRp20OhBYk2S05d7KpS86SAgADGlHCAAIcoAIAAassggABEPICABhmmwIAAPsuAgAAOzaCAATLmgIAAD7eQgABNoACAAGKO8A==
Date:   Thu, 18 Feb 2021 03:28:00 +0000
Message-ID: <OSBPR01MB47737A11F8BFCC856C4A62DCBA859@OSBPR01MB4773.jpnprd01.prod.outlook.com>
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
 <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
 <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
 <OSBPR01MB47739CBDE12E1F3A19649772BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2fRgDJZv-vzy_X6Y5t3daaVdCiXtMwkmXUyG0EQZ0a6Q@mail.gmail.com>
 <OSBPR01MB477394546AE3BC1F186FC0E9BA869@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a32jF+iCH5Sk82LaozyPJ0n=f92MRdseZwN9aOtf4DwKQ@mail.gmail.com>
In-Reply-To: <CAK8P3a32jF+iCH5Sk82LaozyPJ0n=f92MRdseZwN9aOtf4DwKQ@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [72.140.114.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 457a7b01-8810-43c0-0beb-08d8d3bd31a3
x-ms-traffictypediagnostic: OSAPR01MB4883:
x-microsoft-antispam-prvs: <OSAPR01MB488322534BB7D195B8EA4636BA859@OSAPR01MB4883.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Fj+Z5+MdGwOYdpL7bKBHJSqFPTLUuME82r/eS7t5wu+FyIyo1K98eePBHYpozH11si7Mzqiopds63LrROLZqDk6QdKEB52uhZg/FxMPZsO6+l+QsnX9cBuy60Xhw8GJzA8v8Py3Mlpw4ZChUM9tTONmePnYgZu9AhowyNlfpWFCk1r5+RTLaItLLAM+Ti5b+QBGz/63dL7lotA2ES7qf1NKPJiak8lm1sn1JlFXllCLZ8DbRmeq1rw+VfTrxjtFsyvUGxuEUOOS+T1AxKUQAtYPss+MtZQu7kSSU6xTO0t7XjXBBGt1pkEjDtlD/24VxA0JFPgl8a5Ledj7vTJzRoQuPSNCggLr1JMz5WrjQ5aL5t/r3X/ALx73ppmtXIY84DG1gO3uWgqIYevBhX17o9eW5TsZlYQDbnZjrw3906y8W/yFx/xxIY0E9ErLk+76zWpD+4xlLRKp2d9xtI4JGRkKVlkDH4n+XQ2i1BZwb9tg+S0vfFQQU9dJBAgctRFtKGq8Sr8TsXQvTvEsgJ1yQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB4773.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(8936002)(2906002)(76116006)(52536014)(66446008)(66946007)(66556008)(6916009)(64756008)(66476007)(8676002)(5660300002)(71200400001)(478600001)(9686003)(33656002)(316002)(55016002)(54906003)(86362001)(6506007)(7696005)(26005)(186003)(83380400001)(53546011)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eHdkekxwRUs0Y09ZajUwa1RSYURsamd0WkZteTVOdktVK3JXR09KVFVrRzBL?=
 =?utf-8?B?ZnAvZlA1eG5qVFk5NktYREFDOFZSTUNmaFVEc2pjRXVLQW5GMExzVjhCeExh?=
 =?utf-8?B?UGpqT3hOaWJ2WitzVGdpU3A2MXlHVzZPdyt2NWlxTEQ0alZ4ZW9qZ0dteGE3?=
 =?utf-8?B?a2RQR2NuWDNwODVIbUtHUHVGdzdPOE9aeXRvMVdzSmV0UjhoQkRqUi93Wmw1?=
 =?utf-8?B?UUlTT3kzQmdCbGIyS1BEU1k5eVFZbTlkUFkwLzlOc0dhbVFzMUc2V3JSc2RX?=
 =?utf-8?B?enB1YXdpQ0V3bDVGZFQ0ZE5QNG93NUc2K0UrRjVjZEdoRWRRUUF3OWVwdk1S?=
 =?utf-8?B?eXVKTGdqcE1xZWtrMXV6d25QSHVLQ2syMytYNU1jbU8rdkRmZkxzZkM0SXRN?=
 =?utf-8?B?Y1JGaTl3WUVZdXVTMlMrQW9DNU9pM1N0dzFMMm4vbHRKc1oyVllRdmR3Zk8r?=
 =?utf-8?B?ZHZIeFh0SEh0L1FnWWxNbEt5c2FxcENjT05pOWF4T3l2cm5CQWRmVWhlaTlI?=
 =?utf-8?B?TlJNdE5aU2lPVTZBbnVxak9zdTJlek8rUFZ2ZzR0TURkcnRqNkIyKy9BbEVp?=
 =?utf-8?B?U2ZqdHovODVWbFEzWWs0MU1Vdi9uMDQzUWNlLzcyRS80QkxUNE9lMnU3d0tu?=
 =?utf-8?B?YkxYVk1lQTVZOVNNWFloTC91TFNJb2lZeHNOeENWTlpROGJDT0xrV2tSYnlp?=
 =?utf-8?B?SFFsdnNWZlRNQlVOc0lNMEhwZUFLNFJ6dis5KytQTUtBYWFCeE5KYnlQUW5G?=
 =?utf-8?B?Y3FiemROeXpodmJITHBvUGZONS9LajZ1Rjh4dnhhWGZ2bFlySEtrK2dhNlVw?=
 =?utf-8?B?aFk2eUZQaXVLMk5rWmdiaG01ZUFmalNIakFVMUF0cUtGZmRHUlVDR0tsNnpj?=
 =?utf-8?B?S3Jzc013Y1pVSWFBUEVyd2RUYms4dFFwdk40Y1dFaEpnVlpHcjY5UjF2VDB2?=
 =?utf-8?B?TjJmNnhQU0NoUTNpNDFZUVBCR05KeU9XUVBnMExobkNaZGExYlBIcTlYaDBl?=
 =?utf-8?B?TEFkM1hVSUlzUHd1eE1SVVcxWE94eHY0MTFzbGJRN01qYzZSVEZ4Wm1aQ0Rj?=
 =?utf-8?B?YXBCSjZtMkU4blpiUy9xa3VRRzhhblRDQzB0MTJkUWtHOXExZjI5dVQ4OS81?=
 =?utf-8?B?WXNyaDNjZVdxUjg3VGZncmNRbHpkOXlTT1ZydzhEMDNIS2RSOUYyTnV0R0tB?=
 =?utf-8?B?dCtVSEMrbFI3MWdPNzBUK3FnSHNWUEs5b2p6ZnJrVHd3WWdra2NjajFPTnhM?=
 =?utf-8?B?Smw0QnNHQ2Zpc2dWMnZZSFUyQkJoUmJYR3pZa21valNBT1U0azVvYmxqVTBY?=
 =?utf-8?B?Qlc2blhUcVhNeHR5amtkY1pBSERVM3grUzFQRyt4QUlIVjBUTU50K29DK1Q2?=
 =?utf-8?B?Q2E1T3F2bitDVnNFTFBnNXZFVlV1S0VYV0xRcnRIYUVCaUxhNGVwN2J5b0tq?=
 =?utf-8?B?VmZrNFBySGU1MGZwYlpUMnNtQmJtNlU3OVpvMDhIM09maWtQNnlFTVd1Q2pX?=
 =?utf-8?B?Q0d5RkxIck5JaXdpcDVIczNSN2s0blVpYWVWQ2xGb0pSaFVaU3RsT3lFcVJ4?=
 =?utf-8?B?REpodzBPcDVGN1ZEc3R4aHlMM2lGRzJmS1RtQkZFUENsMU5kUXJUdGZSS0du?=
 =?utf-8?B?ZkFLZ3N4TzB4MndNMjlhVUZuNzNDNUxIaFI4cFNUTFI5eXNOWlZib2FJUEhC?=
 =?utf-8?B?VTFWRHpkOUZCTWhRdktJUm9JblRjVUEzSkpGR0c3MkQyQmVPZ1VPTUQ1c1U4?=
 =?utf-8?Q?iTgP7kyU31uRzhC8ZTY1IrNphDLD/ntjBE/sDUk?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB4773.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 457a7b01-8810-43c0-0beb-08d8d3bd31a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 03:28:00.6254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QwL5gEU3KnQENJ0RpkVraLtj7+26A9C9PkZvoG1cq++YsGqsfMO3fStocp0RQbsCZRQvIBcRhfd9P3DeCar4GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4883
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJuZCBCZXJnbWFubiA8
YXJuZEBrZXJuZWwub3JnPg0KPiBTZW50OiBGZWJydWFyeSAxNywgMjAyMSA0OjMwIFBNDQo+IFRv
OiBNaW4gTGkgPG1pbi5saS54ZUByZW5lc2FzLmNvbT4NCj4gQ2M6IERlcmVrIEtpZXJuYW4gPGRl
cmVrLmtpZXJuYW5AeGlsaW54LmNvbT47IERyYWdhbiBDdmV0aWMNCj4gPGRyYWdhbi5jdmV0aWNA
eGlsaW54LmNvbT47IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+OyBncmVna2gNCj4gPGdy
ZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
TmV0d29ya2luZw0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IFJpY2hhcmQgQ29jaHJhbiA8
cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0
XSBtaXNjOiBBZGQgUmVuZXNhcyBTeW5jaHJvbml6YXRpb24NCj4gTWFuYWdlbWVudCBVbml0IChT
TVUpIHN1cHBvcnQNCj4gDQo+IE9uIFdlZCwgRmViIDE3LCAyMDIxIGF0IDk6MjAgUE0gTWluIExp
IDxtaW4ubGkueGVAcmVuZXNhcy5jb20+IHdyb3RlOg0KPiA+DQo+ID4gSSBhdHRhY2hlZCB0aGUg
Ry44MjczLjIgZG9jdW1lbnQsIHdoZXJlIGNoYXB0ZXIgNiBpcyBhYm91dCBzdXBwb3J0aW5nDQo+
ID4gcGh5c2ljYWwgbGF5ZXIgZnJlcXVlbmN5LiBBbmQgY29tYm8gbW9kZSBpcyBSZW5lc2FzIHdh
eSB0byBzdXBwb3J0DQo+ID4gdGhpcyByZXF1aXJlbWVudC4gT3RoZXIgY29tcGFuaWVzIG1heSBj
b21lIHVwIHdpdGggZGlmZmVyZW50IHdheXMgdG8NCj4gc3VwcG9ydCBpdC4NCj4gPg0KPiA+IFdo
ZW4gRUVDIHF1YWxpdHkgaXMgYmVsb3cgY2VydGFpbiBsZXZlbCwgd2Ugd291bGQgd2FubmEgdHVy
biBvZmYgY29tYm8NCj4gbW9kZS4NCj4gDQo+IE1heWJlIHRoaXMgaXMgc29tZXRoaW5nIHRoYXQg
Y291bGQgYmUgaGFuZGxlZCBpbnNpZGUgb2YgdGhlIGRldmljZSBkcml2ZXINCj4gdGhlbj8NCj4g
DQo+IElmIHRoZSBkcml2ZXIgY2FuIHVzZSB0aGUgc2FtZSBhbGdvcml0aG0gdGhhdCBpcyBpbiB5
b3VyIHVzZXIgc3BhY2Ugc29mdHdhcmUNCj4gdG9kYXksIHRoYXQgd291bGQgc2VlbSB0byBiZSBh
IG5pY2VyIHdheSB0byBoYW5kbGUgaXQgdGhhbiByZXF1aXJpbmcgYQ0KPiBzZXBhcmF0ZSBhcHBs
aWNhdGlvbi4NCj4gDQoNCkhpIEFybmQNCg0KDQpXaGF0IGlzIHRoZSBkZXZpY2UgZHJpdmVyIHRo
YXQgeW91IGFyZSByZWZlcnJpbmcgaGVyZT8NCg0KSW4gc3VtbWFyeSBvZiB5b3VyIHJldmlld3Ms
IGFyZSB5b3Ugc3VnZ2VzdGluZyBtZSB0byBkaXNjYXJkIHRoaXMgY2hhbmdlIGFuZCBnbyBiYWNr
IHRvIFBUUCBzdWJzeXN0ZW0NCnRvIGZpbmQgYSBiZXR0ZXIgcGxhY2UgZm9yIHRoaW5ncyB0aGF0
IEkgd2FubmEgZG8gaGVyZT8NCg0KTWluDQo=
