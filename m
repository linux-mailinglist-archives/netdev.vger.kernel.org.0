Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9109A2D2935
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 11:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgLHKty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 05:49:54 -0500
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:29550
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727940AbgLHKtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 05:49:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqqGXcs/bxQyc/7oOyk0Z2hBn3NqIox46Z6+CSLl2Egzzer6DEFA5riBDJBF9pTixM4R0LEjAJbDmQ7/AAjY0qPMqYYr9aO5sqluwiHHrCKSCCEv/8S+uC7hifrzHPJM2eUDb2gQeY59F9KIIeiWuXsLQ/CqAEp+CS7lRm58+znFklmpnm5RcNTzq/GR1LsBj51GVRa2jXU1vQzdRISCxboW2bcylTPcUwoFnmIx2O9dIQne+VfxiiRDsR2nBrtpeKNRJ++be/fZDuumYJ1ScSJClYn66gas/4K+b9f/XaJgx1ZaWiiXcVHob6gxqu9a41AlPbooMpWf3JEV2ODPUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRZSneP0/HHxu9xUk+kZ95rc14iRlLSnl62AsOMhIUs=;
 b=ffO6vXwDiqKkXeW+bRyfjVNYDEPlxYghqaM/OtIPLo9wyfmB/Qgy70M9NlPItUlOhDoT7bpa3iN0TCvwNUagnSE9fVwQAIZWPGofoIAxqmOPHKA5TIU0oFF3nd3GXDwKfraI/052SgcrTezYOFbyTVSGS4WPPg/2JB4yICM1eZucCt8brmUM1QoDTh8eJJOs6JxM5vi/pve5Zm2ZhpUa4tvlnk/N/s05o5Cyxz5keqdpDWUHP6Ov8MaCun6Vmbq/JNBBBLxBHjRak0a96RolamtymOO/5rbWQMQ9K24eTD7IjWSSgM/n9m9DU7quYnmcWJYy0OEOXZP5YmU+WbnEKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRZSneP0/HHxu9xUk+kZ95rc14iRlLSnl62AsOMhIUs=;
 b=Wp+2gWKXiwzYkeTBF5kOXkxuGdCtHItUVZQzOljLftbYF52VtnVwj3amuMoPfWpvA/StcGqfLkB5JqbJRDeRV5nJ3ghI1k1hymXIJ5QEr4x4AUJUNXehE1lDHSsJDNhuhIEljY7q249dLl3U3+/vW6pr0qUZpzZ9LrGig8zLnbk=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB2967.eurprd04.prod.outlook.com (2603:10a6:6:a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Tue, 8 Dec 2020 10:49:03 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 10:49:03 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH RFC] ethernet: stmmac: clean up the code for
 release/suspend/resume function
Thread-Topic: [PATCH RFC] ethernet: stmmac: clean up the code for
 release/suspend/resume function
Thread-Index: AQHWzI2S18NWndIqyUWx3RsQGG1aHqns/3sAgAABlGA=
Date:   Tue, 8 Dec 2020 10:49:03 +0000
Message-ID: <DB8PR04MB67952071DBA50ECF03BF9B98E6CD0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201207113849.27930-1-qiangqing.zhang@nxp.com>
 <20201208182422.156f7ef1@xhacker.debian>
In-Reply-To: <20201208182422.156f7ef1@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synaptics.com; dkim=none (message not signed)
 header.d=none;synaptics.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9b97ebd1-43bb-42f1-9457-08d89b66e0b3
x-ms-traffictypediagnostic: DB6PR04MB2967:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB2967569163B437C398142404E6CD0@DB6PR04MB2967.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +//juVnPJpeb85V8VbqHAkSsGmdAUlApVgE0fxHgrrBjJFwJVAIMH1LL9xd4DVGoz3bsLhOk64K7+crtFVxCiHWVtUUPF3M7GKmyDV8A+v4tToUWOwiNdKNgiV9s4qMW5Ygq/GQS5Cq8Zsm1svyi1ZZ1d9g5+YojeUQ8gRc3bcUuNd6w0SMATbeTPaLo88YtlTF5FwNjyqjb3ocu23+RQsdDKCEHFH96y6vr4c5H/d4G7e9RHehH8YI7AJQA144eYqodZK9VizHDukaeDXdxSj/75tb/Hok/n12nYN022VHOpVe5ljHdmC8GbHr9SiW9Ozg+iQuLAsvlAbOHaOM0LfoPdBfJw8UtGdn5tXKB+IiflHZfwSbRiK1XGva0DJMEfSbBK2qe92qjBGiT2irh2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(76116006)(5660300002)(26005)(66946007)(8936002)(2906002)(15650500001)(53546011)(83380400001)(498600001)(186003)(9686003)(6916009)(966005)(54906003)(55016002)(6506007)(66556008)(71200400001)(7696005)(66476007)(64756008)(33656002)(52536014)(8676002)(66446008)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?N0g2V2V1Z3dTaUVRaEJOa2hqZFpWc1dUOHoySWluM2tGSjZybXdZd01FS0xx?=
 =?gb2312?B?WEhmWlVxQ3lTQ0tPdkFPUFk1Qk4waVV0ak9YanhUbmdtNDhSSWcrY1g4Y2lh?=
 =?gb2312?B?cTZKNm1NVGoyRWZEemw1NDFyL3pIVmtNVi9ubno0Z0d0YUdhRkJodGVLLzdD?=
 =?gb2312?B?dFNUektDV09KQlNDMVB6MHVUd0d6d1RMM3dNSFNyQ0Y3ZWI5TnVLZUh3UHZx?=
 =?gb2312?B?RGRqSlgzcWgzcGtOWGdYdnNoZWtHR0VqQVhBZWFlQVE0bnBFbnlkZDFzYlRR?=
 =?gb2312?B?RXZmUGJ6MnNuN1FZdmZSU21DM3FVNlZtcUFLQThqVm9HOENJbGZ4WjFtbjYx?=
 =?gb2312?B?Y3F1bGxQL3ZIN1lJNWJMTWlBVVRUcWh4OEpUa1RmNGZkYUp5Z0k2SUxmdFlH?=
 =?gb2312?B?SFNEYnBPWVcwSG9jL0FKTEhrb3Y3NjQwa3dHQmNxaE9sTDR1Vk9vd2VIVXpL?=
 =?gb2312?B?OVhyMHRBWHJ0Qjh0Y3dWdEp5RXFPWVV3ZEZaSGZjL3JJbjh6bjdISUVpMlVX?=
 =?gb2312?B?OHRPVmY3dWhMNGFFcnJTeUc2dGFaVlYrNUE2dy9nYldQRmIwaXlmZUUxRE9U?=
 =?gb2312?B?RzJnTE9nTnZhWE9WZHVGTWk4TEF3V1hjOVhoTkRaamdaWjdoSFF2UzZ1QjIr?=
 =?gb2312?B?dFJoNTRVTm13OVU4aVJWb2dPOTJlSmsrVGNkR1pheUVvV1FBaW9FdllPZlZt?=
 =?gb2312?B?NjM3bjAvWFo0ZkRpN29HblZiZTBrMXFYSGtwUitLMUtQeFVrZHUzeDNSOHVI?=
 =?gb2312?B?T2tycXdzWkczS0R4NXlxMGVidmRDWThwcnhDMWxwaE13cytRSnpWbHMwekdy?=
 =?gb2312?B?VVlqNGhHcjFoUjVJZUVPLzBIY0JtenpCV2VPQ2NoUytnUVlFaEJHT2YxR2NB?=
 =?gb2312?B?U1cybnlLZnZYQ0VCRGpMMy9IZmNBazFPSzVDY2cxU3g3Qm81RVFzVWc4QXZJ?=
 =?gb2312?B?Qmh3WUhiTkhWalBuWnVkRnFvU1VxQm05aGpUb1lydUpoUUtFSy9wMVdiQndk?=
 =?gb2312?B?OWl0ZGlvdXZTMElrb1JuWDVicGNYbWdMR0Zxa2tVSjJSR2RLVXJqOWNvOFR0?=
 =?gb2312?B?c1BjQ1djRmNkTjc4ZGxyRFBhemEvb0FWOGowQmI2VlV5WlNZL29IZHZMYzMr?=
 =?gb2312?B?N083K1hhTVhzakJ5YnNlaTA0cmJ5OXhWZDlQaVJxMW8vL0dKMjBpUmFEVkxO?=
 =?gb2312?B?WU8vSTl0bjhreW1sckVPbytCY01tRkRhNDhLV1FYV3duSms2TDFsSG5VUzE5?=
 =?gb2312?B?cmtOZWM0UXY5Z1AwLzNKY09CeHN5aUloN281bHlhTVNTU2NES0FTejJ3TXM1?=
 =?gb2312?Q?zeMWYUYRavj3s=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b97ebd1-43bb-42f1-9457-08d89b66e0b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 10:49:03.1311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oco1Ap3UxwpigMdq0q6vmHCfAJCp/kDEnqq6fU08wZ4HFfcGk+XL3SQik2PfmbGALaLllg2HxDQJip/+lJ4RPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEppc2hlbmcgWmhhbmcgPEpp
c2hlbmcuWmhhbmdAc3luYXB0aWNzLmNvbT4NCj4gU2VudDogMjAyMMTqMTLUwjjI1SAxODoyNA0K
PiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBl
LmNhdmFsbGFyb0BzdC5jb207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5
bm9wc3lzLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBT
dWJqZWN0OiBSZTogW1BBVENIIFJGQ10gZXRoZXJuZXQ6IHN0bW1hYzogY2xlYW4gdXAgdGhlIGNv
ZGUgZm9yDQo+IHJlbGVhc2Uvc3VzcGVuZC9yZXN1bWUgZnVuY3Rpb24NCj4gDQo+IE9uIE1vbiwg
IDcgRGVjIDIwMjAgMTk6Mzg6NDkgKzA4MDAgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiANCj4gDQo+
ID4NCj4gPiBjb21taXQgMWMzNWNjOWNmNmEwICgibmV0OiBzdG1tYWM6IHJlbW92ZSByZWR1bmRh
bnQgbnVsbCBjaGVjayBiZWZvcmUNCj4gPiBjbGtfZGlzYWJsZV91bnByZXBhcmUoKSIpLCBoYXZl
IG5vdCBjbGVhbiB1cCBjaGVjayBOVUxMIGNsb2NrIHBhcmFtZXRlcg0KPiBjb21wbGV0ZWx5LCB0
aGlzIHBhdGNoIGRpZCBpdC4NCj4gPg0KPiA+IGNvbW1pdCBlODM3N2U3YTI5ZWZiICgibmV0OiBz
dG1tYWM6IG9ubHkgY2FsbCBwbXQoKSBkdXJpbmcNCj4gPiBzdXNwZW5kL3Jlc3VtZSBpZiBIVyBl
bmFibGVzIFBNVCIpLCBhZnRlciB0aGlzIHBhdGNoLCB3ZSB1c2UgaWYNCj4gPiAoZGV2aWNlX21h
eV93YWtldXAocHJpdi0+ZGV2aWNlKSAmJiBwcml2LT5wbGF0LT5wbXQpIGNoZWNrIE1BQyB3YWtl
dXANCj4gPiBpZiAoZGV2aWNlX21heV93YWtldXAocHJpdi0+ZGV2aWNlKSkgY2hlY2sgUEhZIHdh
a2V1cCBBZGQgb25lbGluZQ0KPiA+IGNvbW1lbnQgZm9yIHJlYWRhYmlsaXR5Lg0KPiA+DQo+ID4g
Y29tbWl0IDc3YjI4OTgzOTRlM2IgKCJuZXQ6IHN0bW1hYzogU3BlZWQgZG93biB0aGUgUEhZIGlm
IFdvTCB0byBzYXZlDQo+ID4gZW5lcmd5IiksIHNsb3cgZG93biBwaHkgc3BlZWQgd2hlbiByZWxl
YXNlIG5ldCBkZXZpY2UgdW5kZXIgYW55IGNvbmRpdGlvbi4NCj4gPg0KPiA+IFNsaWdodGx5IGFk
anVzdCB0aGUgb3JkZXIgb2YgdGhlIGNvZGVzIHNvIHRoYXQgc3VzcGVuZC9yZXN1bWUgbG9vaw0K
PiA+IG1vcmUgc3ltbWV0cmljYWwsIGdlbmVyYWxseSBzcGVha2luZyB0aGV5IHNob3VsZCBhcHBl
YXIgc3ltbWV0cmljYWxseS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8
cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9uZXQvZXRoZXJuZXQv
c3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYyB8IDIyDQo+ID4gKysrKysrKysrLS0tLS0tLS0t
LQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0p
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1t
YWMvc3RtbWFjX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1t
YWMvc3RtbWFjX21haW4uYw0KPiA+IGluZGV4IGMzM2RiNzljZGQwYS4uYTQ2ZTg2NWM0YWNjIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1h
Y19tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9z
dG1tYWNfbWFpbi5jDQo+ID4gQEAgLTI5MDgsOCArMjkwOCw3IEBAIHN0YXRpYyBpbnQgc3RtbWFj
X3JlbGVhc2Uoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gPiAgICAgICAgIHN0cnVjdCBzdG1t
YWNfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+ID4gICAgICAgICB1MzIgY2hhbjsN
Cj4gPg0KPiA+IC0gICAgICAgaWYgKGRldmljZV9tYXlfd2FrZXVwKHByaXYtPmRldmljZSkpDQo+
IA0KPiBUaGlzIGNoZWNrIGlzIHRvIHByZXZlbnQgbGluayBzcGVlZCBkb3duIGlmIHRoZSBzdG1t
YWMgaXNuJ3QgYSB3YWtldXAgZGV2aWNlLg0KDQpXaGVuIHdlIGludm9rZSAubmRvX3N0b3AsIHdl
IGRvd24gdGhlIG5ldCBkZXZpY2UuIFBlciBteSB1bmRlcnN0YW5kaW5nLCB3ZSBjYW4gc3BlZWQg
ZG93biB0aGUgcGh5LCBubyBtYXR0ZXIgaXQgaXMgYSB3YWtldXAgZGV2aWNlIG9yIG5vdC4NClNp
bmNlIHdoZW4gaW52b2tlIC5uZG9fb3BlbiB0byB1cCB0aGUgbmV0IGRldmNlLCB3ZSB3aWxsIHJl
LWNvbmZpZyBtYWMgYW5kIHBoeS4gUGxlYXNlIHBvaW50IG91dCB0byBtZSBpZiBJIG1pcy11bmRl
cnN0YW5kIHNvbWV0aGluZy4gVGhhbmtzLg0KDQo+ID4gLSAgICAgICAgICAgICAgIHBoeWxpbmtf
c3BlZWRfZG93bihwcml2LT5waHlsaW5rLCBmYWxzZSk7DQo+ID4gKyAgICAgICBwaHlsaW5rX3Nw
ZWVkX2Rvd24ocHJpdi0+cGh5bGluaywgZmFsc2UpOw0KPiA+ICAgICAgICAgLyogU3RvcCBhbmQg
ZGlzY29ubmVjdCB0aGUgUEhZICovDQo+ID4gICAgICAgICBwaHlsaW5rX3N0b3AocHJpdi0+cGh5
bGluayk7DQo+ID4gICAgICAgICBwaHlsaW5rX2Rpc2Nvbm5lY3RfcGh5KHByaXYtPnBoeWxpbmsp
Ow0KPiA+IEBAIC01MTgzLDYgKzUxODIsNyBAQCBpbnQgc3RtbWFjX3N1c3BlbmQoc3RydWN0IGRl
dmljZSAqZGV2KQ0KPiA+ICAgICAgICAgfSBlbHNlIHsNCj4gPiAgICAgICAgICAgICAgICAgbXV0
ZXhfdW5sb2NrKCZwcml2LT5sb2NrKTsNCj4gPiAgICAgICAgICAgICAgICAgcnRubF9sb2NrKCk7
DQo+ID4gKyAgICAgICAgICAgICAgIC8qIEZvciBQSFkgd2FrZXVwIGNhc2UgKi8NCj4gPiAgICAg
ICAgICAgICAgICAgaWYgKGRldmljZV9tYXlfd2FrZXVwKHByaXYtPmRldmljZSkpDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgcGh5bGlua19zcGVlZF9kb3duKHByaXYtPnBoeWxpbmssIGZh
bHNlKTsNCj4gPiAgICAgICAgICAgICAgICAgcGh5bGlua19zdG9wKHByaXYtPnBoeWxpbmspOyBA
QCAtNTI2MCwxMSArNTI2MCwxNyBAQA0KPiA+IGludCBzdG1tYWNfcmVzdW1lKHN0cnVjdCBkZXZp
Y2UgKmRldikNCj4gPiAgICAgICAgICAgICAgICAgLyogZW5hYmxlIHRoZSBjbGsgcHJldmlvdXNs
eSBkaXNhYmxlZCAqLw0KPiA+ICAgICAgICAgICAgICAgICBjbGtfcHJlcGFyZV9lbmFibGUocHJp
di0+cGxhdC0+c3RtbWFjX2Nsayk7DQo+ID4gICAgICAgICAgICAgICAgIGNsa19wcmVwYXJlX2Vu
YWJsZShwcml2LT5wbGF0LT5wY2xrKTsNCj4gPiAtICAgICAgICAgICAgICAgaWYgKHByaXYtPnBs
YXQtPmNsa19wdHBfcmVmKQ0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIGNsa19wcmVwYXJl
X2VuYWJsZShwcml2LT5wbGF0LT5jbGtfcHRwX3JlZik7DQo+ID4gKyAgICAgICAgICAgICAgIGNs
a19wcmVwYXJlX2VuYWJsZShwcml2LT5wbGF0LT5jbGtfcHRwX3JlZik7DQo+IA0KPiBJIHRoaW5r
IHRoaXMgMyBsaW5lIG1vZGlmaWNhdGlvbnMgY2FuIGJlIGEgc2VwYXJhdGVkIHBhdGNoLg0KDQpZ
ZXMsIHRoaXMganVzdCBhIFJGQyB0byBleHBvcnQgaXNzdWUuDQoNCj4gPiAgICAgICAgICAgICAg
ICAgLyogcmVzZXQgdGhlIHBoeSBzbyB0aGF0IGl0J3MgcmVhZHkgKi8NCj4gPiAgICAgICAgICAg
ICAgICAgaWYgKHByaXYtPm1paSkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBzdG1tYWNf
bWRpb19yZXNldChwcml2LT5taWkpOw0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgcnRubF9s
b2NrKCk7DQo+ID4gKyAgICAgICAgICAgICAgIHBoeWxpbmtfc3RhcnQocHJpdi0+cGh5bGluayk7
DQo+ID4gKyAgICAgICAgICAgICAgIC8qIFdlIG1heSBoYXZlIGNhbGxlZCBwaHlsaW5rX3NwZWVk
X2Rvd24gYmVmb3JlICovDQo+ID4gKyAgICAgICAgICAgICAgIGlmIChkZXZpY2VfbWF5X3dha2V1
cChwcml2LT5kZXZpY2UpKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHBoeWxpbmtfc3Bl
ZWRfdXAocHJpdi0+cGh5bGluayk7DQo+ID4gKyAgICAgICAgICAgICAgIHJ0bmxfdW5sb2NrKCk7
DQo+IA0KPiBUaGlzIGlzIG1vdmluZyBwaHlsaW5rIG9wIGJlZm9yZSBtYWMgc2V0dXAsIEknbSBu
b3Qgc3VyZSB3aGV0aGVyIHRoaXMgaXMgc2FmZS4NCg0KV2UgZW5jb3VudGVyIGFuIGlzc3VlLCBu
ZWVkIG1vdmUgcGh5bGluayBiZWZvcmUgbWFjIHNldHVwLCBwbGVhc2Ugc2VlIGJlbG93IHBhdGNo
Lg0KaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbmV0ZGV2L21zZzcwNjQ1OC5odG1sDQoN
CkhhdmUgbm90IGZvdW5kIHByb2JsZW1zIGFmdGVyIHRlc3QuIElzIHRoZXJlIGFuZyByaXNrPw0K
DQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gPiAgICAgICAgIH0NCj4gPg0KPiA+ICAg
ICAgICAgaWYgKHByaXYtPnBsYXQtPnNlcmRlc19wb3dlcnVwKSB7IEBAIC01Mjc1LDE0ICs1Mjgx
LDYgQEAgaW50DQo+ID4gc3RtbWFjX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiAgICAgICAgIH0NCj4gPg0KPiA+
IC0gICAgICAgaWYgKCFkZXZpY2VfbWF5X3dha2V1cChwcml2LT5kZXZpY2UpIHx8ICFwcml2LT5w
bGF0LT5wbXQpIHsNCj4gPiAtICAgICAgICAgICAgICAgcnRubF9sb2NrKCk7DQo+ID4gLSAgICAg
ICAgICAgICAgIHBoeWxpbmtfc3RhcnQocHJpdi0+cGh5bGluayk7DQo+ID4gLSAgICAgICAgICAg
ICAgIC8qIFdlIG1heSBoYXZlIGNhbGxlZCBwaHlsaW5rX3NwZWVkX2Rvd24gYmVmb3JlICovDQo+
ID4gLSAgICAgICAgICAgICAgIHBoeWxpbmtfc3BlZWRfdXAocHJpdi0+cGh5bGluayk7DQo+ID4g
LSAgICAgICAgICAgICAgIHJ0bmxfdW5sb2NrKCk7DQo+ID4gLSAgICAgICB9DQo+ID4gLQ0KPiA+
ICAgICAgICAgcnRubF9sb2NrKCk7DQo+ID4gICAgICAgICBtdXRleF9sb2NrKCZwcml2LT5sb2Nr
KTsNCj4gPg0KPiA+IC0tDQo+ID4gMi4xNy4xDQo+ID4NCg0K
