Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754321E311A
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404350AbgEZVXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:23:15 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:28800
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404259AbgEZVXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 17:23:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwK6pXBudWf1vAVcpMI8AWHNvL1INt7/8gfHY9Z29+jJqC8yWLxmnP2v2BfJGj39cS3v94uAP1AmDNmJiqRhS2732xX2jJk8QuFHeHHar4HlFouCVridWAH9ahtOlQOX8KSIIkZFWhfkBg6l7t24lpjBdxDdYZiHZu5L3I66pPQypuc288tr0jKpheeae0cIUc7YNdDF9s7NmnffF+tVnevSfGLhI7seSQOsE7REvMCqCdwIqCHlVaFpTdt/P0MlF1vGuQFEKFBt6FwfwlLVY35gtfEkH1xyWRLWuc94lQejW5xgwjR1fHh7q6gK5lYu7bSop2jvEtr2dus6rW6UZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXbHLZz+1KZJ6diDBBtodUmkyypsu2smYVXiOdVCSCY=;
 b=EW7G4Q1kJ34o6APl8ksRix8H6MFoRZFTJClU0GpboYgXcwJ1aZLxzN44+oFZ5tOpJCxw6fqrIhIS0GK7wRDK06TcDgr814eTrwVcYpRtodiB1+TNg2TIwKqSKtrTR1kDe7Rj5xQsYNhVwDssijwBPDBb0Jhd2GyTLB3ox2T4V9OfpX43h/Fyk3LrwAGJjMGtFL5A2VQF0BIdIzW/VqQwG1OqxhUYAUdZQ4qZryTHEFErDqZwEBx6aHqJjdYW6uqwOgy/RnvV2syH3hrn9+zf1JYeaEckXlrD79bz1mX7DK+xv7KJPp3bdpS4cch/0u3PJShRVgJpu3yxVjMs1oTnOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXbHLZz+1KZJ6diDBBtodUmkyypsu2smYVXiOdVCSCY=;
 b=CIfhHjy3MUzF1QgB775fw4cQ+fZ+sjm5R/BV8DErjV1hOhEbhUR/g3p55JPbxanUZSGPn1FwXfvmWZV3LHIvc6yOmtyU5Zn84K8lQLPGanKjHoPyLGK9C1iJ7ExBSn0SzZtUk3kQHW12PEzaeGTiNKZuPw/ViOihL7vLejEauKM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5536.eurprd05.prod.outlook.com (2603:10a6:803:95::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 21:23:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 21:23:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: Re: bpf-next/net-next: panic using bpf_xdp_adjust_head
Thread-Topic: bpf-next/net-next: panic using bpf_xdp_adjust_head
Thread-Index: AQHWM5CHfIT64iBK50WQOTz4iga31Ki64JOA
Date:   Tue, 26 May 2020 21:23:11 +0000
Message-ID: <52d793f86d36baac455630a03d76f09a388e549f.camel@mellanox.com>
References: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
In-Reply-To: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15298f18-cc3a-43b4-6000-08d801bafe27
x-ms-traffictypediagnostic: VI1PR05MB5536:
x-microsoft-antispam-prvs: <VI1PR05MB55364E95A165D0403500B17EBEB00@VI1PR05MB5536.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 041517DFAB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IvyNmR+NSaj2xWfmSqn3PPjEbH2prGNDcM9trXkbP91/C5hsiNGVrRnCEumC0DQw/FKGCoIFjJsG2amuV9FUyB1/VxKfBnlqFDyTDIB3xt7lpg35H+W8p2U/1lAdFyWSEwiLdz3F5aL14IYRsb2jMipwv8HGosSYBxuWpJOwxyxkvsgaBubr0axVhr9UBY1HDdxd95DGI5leECjlQlDn+8r/5VOAel09DvwmOFOLPxf07XfVsjdDes0WBLfyxPUgppXVOKXvRoge7lYV7iyN01MuNsVh3Tn7yPbRgQMCpMeITbiDCLwFgKXhuqOAA6elzHeLi4Do1xzc7wunv9c1zQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(396003)(346002)(366004)(136003)(376002)(5660300002)(6486002)(26005)(76116006)(66476007)(66556008)(91956017)(66946007)(186003)(64756008)(66446008)(8676002)(71200400001)(36756003)(2906002)(316002)(8936002)(6512007)(478600001)(2616005)(86362001)(110136005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hBhD1RrCi5c1f26db6/9gX7jN0BAeJF+W1PZr4F/bRXZOlMJGscFw4W5kvGSn0ejAJn48yUxsQhAAOKgzD5oWBHdeCW+P/VZb4lYSOzdJlz6f2hs8UDIK7wUEQ9b4sSe6Q3Zg4gqhlG5oG4NAtaDoBtnH81RQY4NQ1TFOQsoTlkcQVT59bPZZFwKxtdHDlu7a7x24fobw6KWE9NKJFYOpFsE53Y5KLnIED7cNk9oiQHxTefTwRBY8k1KX3HxVj2Kk2MoMGufOFDoGPymZri+HrO90YpnI6ejxv1lFgqEDRZ+2uAjWLGFNvSIz7SGR7yqE5advvDuSNPkGE8DkmigTuWb1F4KOluz4IVMBDv3K3natrcnnOsfgeJEYMIDyWtMqA6G+4jFpNF8fvSvrd3YRqwV8BaPf+1F4DvA1boQ+wjoNoTvIbU9Clp4XZEAailGR3D24Hb0aSBiF/b60hc7QbS2M/1/AoodNO2F0roOOIg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B53ABE12341DBE458D4A47601926A1E0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15298f18-cc3a-43b4-6000-08d801bafe27
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2020 21:23:11.0464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZXq5OtpPt2WUckGhWMrKPqGDKqzU0IUsdLAcybizvAIGRPKZxh3sA32Kgl/No/t1lD9zE20CuValB1qJgTV4kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5536
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA1LTI2IGF0IDEzOjA0IC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
YnBmLW5leHQgYW5kIG5ldC1uZXh0IGFyZSBwYW5pY2luZyB3aGVuIGEgYnBmIHByb2dyYW0gdXNl
cw0KPiBhZGp1c3RfaGVhZCAtDQo+IGUuZy4sIHBvcHBpbmcgYSB2bGFuIGhlYWRlci4NCj4gDQo+
IFsgNzI2OS44ODY2ODRdIEJVRzoga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSwgYWRk
cmVzczoNCj4gMDAwMDAwMDAwMDAwMDAwNA0KPiBbIDcyNjkuODkzNjc2XSAjUEY6IHN1cGVydmlz
b3IgcmVhZCBhY2Nlc3MgaW4ga2VybmVsIG1vZGUNCj4gWyA3MjY5Ljg5ODgyMV0gI1BGOiBlcnJv
cl9jb2RlKDB4MDAwMCkgLSBub3QtcHJlc2VudCBwYWdlDQo+IFsgNzI2OS45MDM5NzBdIFBHRCAw
IFA0RCAwDQo+IFsgNzI2OS45MDY1MTZdIE9vcHM6IDAwMDAgWyMxXSBTTVAgUFRJDQo+IFsgNzI2
OS45MTAwMjFdIENQVTogMyBQSUQ6IDAgQ29tbTogc3dhcHBlci8zIEtkdW1wOiBsb2FkZWQgVGFp
bnRlZDogRw0KPiAgICAgICBJICAgICAgIDUuNy4wLXJjNisgIzIyMQ0KPiBbIDcyNjkuOTE5MDc2
XSBIYXJkd2FyZSBuYW1lOiBEZWxsIEluYy4gUG93ZXJFZGdlIFI2NDAvMFcyM0g4LCBCSU9TDQo+
IDEuNi4xMiAxMS8yMC8yMDE4DQo+IFsgNzI2OS45MjY2NjFdIFJJUDogMDAxMDpfX21lbW1vdmUr
MHgyNC8weDFhMA0KPiBbIDcyNjkuOTMwNzY2XSBDb2RlOiBjYyBjYyBjYyBjYyBjYyBjYyA0OCA4
OSBmOCA0OCAzOSBmZSA3ZCAwZiA0OSA4OQ0KPiBmMA0KPiA0OSAwMSBkMCA0OSAzOSBmOCAwZiA4
ZiBhOSAwMCAwMCAwMCA0OCA4MyBmYSAyMCAwZiA4MiBmNSAwMCAwMCAwMCA0OA0KPiA4OQ0KPiBk
MSA8ZjM+IGE0IGMzIDQ4IDgxIGZhIGE4IDAyIDAwIDAwIDcyIDA1IDQwIDM4IGZlIDc0IDNiIDQ4
IDgzIGVhIDIwDQo+IDQ4DQo+IFsgNzI2OS45NDk1NDhdIFJTUDogMDAxODpmZmZmOWMwOWNjYTA0
YzY4IEVGTEFHUzogMDAwMTAyODINCj4gWyA3MjY5Ljk1NDc4MV0gUkFYOiAwMDAwMDAwMDAwMDAw
MDA4IFJCWDogZmZmZjljMDljY2EwNGQ3OCBSQ1g6DQo+IGZmZmY4YmZjNDc1YTIwZmMNCj4gWyA3
MjY5Ljk2MTkyN10gUkRYOiBmZmZmOGJmYzQ3NWEyMGZjIFJTSTogMDAwMDAwMDAwMDAwMDAwNCBS
REk6DQo+IDAwMDAwMDAwMDAwMDAwMDgNCj4gWyA3MjY5Ljk2OTA2OF0gUkJQOiBmZmZmOGJmYzQ3
NWEyMTA0IFIwODogZmZmZjhiZmM0NzVhMjEwMCBSMDk6DQo+IGZmZmY4YmZjNDc1YTIxMWMNCj4g
WyA3MjY5Ljk3NjIyOV0gUjEwOiAwMDAwMDAwMDAwMDAwMDEyIFIxMTogMDAwMDAwMDAwMDAwMDAw
OCBSMTI6DQo+IDAwMDAwMDAwMDAwMDAwMDQNCj4gWyA3MjY5Ljk4MzM3Nl0gUjEzOiBmZmZmOWMw
OWNjOWY1N2I4IFIxNDogZmZmZjhiZmM0NzVhMjEwMCBSMTU6DQo+IDAwMDAwMDAwMDAwMDAwMDgN
Cj4gWyA3MjY5Ljk5MDUxOF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4YzAx
MWYyNDAwMDAoMDAwMCkNCj4ga25sR1M6MDAwMDAwMDAwMDAwMDAwMA0KPiBbIDcyNjkuOTk4NjIz
XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQo+IFsg
NzI3MC4wMDQzODFdIENSMjogMDAwMDAwMDAwMDAwMDAwNCBDUjM6IDAwMDAwMDFhNzJhMGEwMDQg
Q1I0Og0KPiAwMDAwMDAwMDAwNzYyNmUwDQo+IFsgNzI3MC4wMTE1MjNdIERSMDogMDAwMDAwMDAw
MDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIyOg0KPiAwMDAwMDAwMDAwMDAwMDAwDQo+
IFsgNzI3MC4wMTg2ODJdIERSMzogMDAwMDAwMDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZTBm
ZjAgRFI3Og0KPiAwMDAwMDAwMDAwMDAwNDAwDQo+IFsgNzI3MC4wMjU4MjRdIFBLUlU6IDU1NTU1
NTU0DQo+IFsgNzI3MC4wMjg1MzldIENhbGwgVHJhY2U6DQo+IFsgNzI3MC4wMzA5OTBdICA8SVJR
Pg0KDQpsb29rcyBsaWtlOiB4ZHAtPmRhdGFfbWV0YSBoYXMgc29tZSBpbnZhbGlkIHZhbHVlLg0K
YW5kIGkgdGhpbmsgaXRzIGJvdW5kYXJpZXMgc2hvdWxkIGJlIGNoZWNrZWQgb24gDQpicGZfeGRw
X2FkanVzdF9oZWFkKCkgcmVnYXJkbGVzcyBvZiB0aGUgaXNzdWUgdGhhdCB5b3UgYXJlIHNlZWlu
Zy4NCg0KQW55d2F5IEkgY2FuJ3QgZmlndXJlIG91dCB0aGUgcmVhc29uIGZvciB0aGlzIHdpdGhv
dXQgZXh0cmEgZGlnZ2luZw0Kc2luY2UgaW4gbWx4NSB3ZSBkbyB4ZHBfc2V0X2RhdGFfbWV0YV9p
bnZhbGlkKCk7IGJlZm9yZSBwYXNzaW5nIHRoZSB4ZHANCmJ1ZmYgdG8gdGhlIGJwZiBwcm9ncmFt
LCBzbyBpdCBpcyBub3QgY2xlYXIgd2h5IHdvdWxkIHlvdSBoaXQgdGhlDQptZW1vdmUgaW4gYnBm
X3hkcF9hZGp1c3RfaGVhZCgpLg0KDQo+IFsgNzI3MC4wMzMwMTRdICBicGZfeGRwX2FkanVzdF9o
ZWFkKzB4NjgvMHg4MA0KPiBbIDcyNzAuMDM3MTI2XSAgYnBmX3Byb2dfN2Q3MTlmMDBhZmNmOGU2
Y194ZHBfbDJmd2RfcHJvZysweDE5OC8weGExMA0KPiBbIDcyNzAuMDQzMjg0XSAgbWx4NWVfeGRw
X2hhbmRsZSsweDU1LzB4NTAwIFttbHg1X2NvcmVdDQo+IFsgNzI3MC4wNDgyNzddICBtbHg1ZV9z
a2JfZnJvbV9jcWVfbGluZWFyKzB4ZjAvMHgxYjAgW21seDVfY29yZV0NCj4gWyA3MjcwLjA1NDA1
M10gIG1seDVlX2hhbmRsZV9yeF9jcWUrMHg2NC8weDE0MCBbbWx4NV9jb3JlXQ0KPiBbIDcyNzAu
MDU5Mjk3XSAgbWx4NWVfcG9sbF9yeF9jcSsweDhjOC8weGEzMCBbbWx4NV9jb3JlXQ0KPiBbIDcy
NzAuMDY0MzczXSAgbWx4NWVfbmFwaV9wb2xsKzB4ZGMvMHg2YTAgW21seDVfY29yZV0NCj4gWyA3
MjcwLjA2OTI2MF0gIG5ldF9yeF9hY3Rpb24rMHgxM2QvMHgzZDANCj4gWyA3MjcwLjA3MzAyMF0g
IF9fZG9fc29mdGlycSsweGRkLzB4MmQwDQo+IA0KPiANCj4gZ2l0IGJpc2VjdCBjaGFzZWQgaXQg
dG8NCj4gICAxMzIwOWE4ZjczMDQgKCJNZXJnZQ0KPiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvbmV0ZGV2L25ldCIpDQo+IA0KDQpBcmUgeW91IHRlc3Rpbmcg
dmFuaWxsYSBrZXJuZWwgPyANCg0Kd2hhdCBkb2VzIHRoZSB4ZHAgcHJvZ3JhbSBkbyB3aXRoIHRo
ZSBmcmFtZS94ZHBfYnVmZiBvdGhlciB0aGFuDQpicGZfeGRwX2FkanVzdF9oZWFkKCkvIGkgbWVh
biB3aGljaCBvdGhlciBicGYgaGVscGVyIGlzIGl0IGNhbGxpbmcgPw0KDQo+IGJ1dCB0aGF0IGJy
aW5ncyBpbiBhIExPVCBvZiBjaGFuZ2VzLiBBbnlvbmUgaGF2ZSBpZGVhcyBvbiByZWNlbnQNCj4g
Y2hhbmdlcw0KPiB0aGF0IGNvdWxkIGJlIHRoZSByb290IGNhdXNlPw0K
