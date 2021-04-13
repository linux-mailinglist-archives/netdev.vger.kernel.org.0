Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8872035DE67
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345452AbhDMMN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:13:26 -0400
Received: from mail-eopbgr130049.outbound.protection.outlook.com ([40.107.13.49]:59299
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243979AbhDMMNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 08:13:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddHY65smR6jWqzWR5T724cJIjSb0zCDT3bU4pqQW0O5VE9SauPPryuod/A9AH70pdEQznkFl8Mst4XtvfCWSJh4ndxUYzgyvr8r9az3LByTCcHVP7IJRFMv5uTz8HI/cEbPBIjl7vXmlbv7zI4E1trcBEmByuPwuUyW4mVNkKTgQWigPI/KCDEUWFyy+3IF/HG0QP8+vWZzySalk96EfnluBPicdZ2oK15gAFPcujI8uDHfERldAVirc3MFvQ7w3WCPUohQixWWpHX3XG4WkLUXSdT9JWPibZY2BstoVBLVy7IAICltS9seoB2ZsSAEL1Gt4NeOKS2nEJhhBUyaTMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjjp5ZpAT102pYwiW09Jl21Tj7Mk3icnBmktTu8XUGE=;
 b=IG8uzVsLXRn4HlNpuIq0uPadHd7bbYt4dH0Ndd2m7p71z9ePZqLNqE583ahusy5X0f3f2DyN408PnORFYTQhbYAIKAuNjgIjFzifCstYsKM5yxQHxKyB92hJFNc5JppHiCvPfte4hcRFIh1KRgWiqJsNlguAAiq6U3AB2Hzra+umKVFC15y8fxFS6QY/LuaWFV6xzwi2QpSo5aetDIkeigfwHs/ZZtVkGas4LFRLAa3GgCqwWnPgd5dMyhc0IvjC4c+Pd28QK92okn4OHp1qwulF5N5/m61wsZh0Ynkx7PJy+SYbaGWDlzDQNCrRNr0H4UBNu2j30e0hd4Ampak+ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjjp5ZpAT102pYwiW09Jl21Tj7Mk3icnBmktTu8XUGE=;
 b=e0bTxqOgarGW+DruL3WCRrEBc9tce8FzTtMd6pdz8LCJTvmbIW9Nbu4aW5AoDqvgjjbHeV1bKvkuj927VjVKCH+jl8yi0sWGJjhozJt/w/Yx/VwWSqCHcwKUPlK7GFzVb93I2YHZK+rVYWohFQmoe/7vOdcu9Iz4Mo3sI7ls9YM=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.20; Tue, 13 Apr
 2021 12:13:02 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 12:13:02 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Topic: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Index: AQHXIJuN/Okb/PN4nkWB+yH0VnH6i6qTC9OwgAAITACAAT8a8IAABYcAgAABmVCACCsMAIABO0DQgAA346CAAAhZgIAAAU1ggAHkuICAElltAIAANb9Q
Date:   Tue, 13 Apr 2021 12:13:01 +0000
Message-ID: <DB8PR04MB6795C779FD47D5712DAE11CDE64F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
 <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
 <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
 <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB6795D4C733DC4938B1D62EBDE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <85f02fbc-6956-2b19-1779-cd51b2e71e3d@nvidia.com>
 <DB8PR04MB6795ECCB5E6E2091A45DADAEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <563db756-ebef-6c8b-ce7c-9dcadaecfea1@nvidia.com>
 <e4864046-e52f-63b6-a490-74c3cd8045f4@nvidia.com>
In-Reply-To: <e4864046-e52f-63b6-a490-74c3cd8045f4@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8eb93f7e-4ec1-44b2-0c3d-08d8fe757c65
x-ms-traffictypediagnostic: DB8PR04MB6971:
x-microsoft-antispam-prvs: <DB8PR04MB69714E3A8D895B17D76B0C1EE64F9@DB8PR04MB6971.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9HiAXjJNx7AowjnlA6oAV2g/CiD7X0eKVrGdWj3Zqz6kpN5hHKEY9kw0bt5OAi4JgmvywavTEWXib3SsbRnxHMbJXS29riS9wqYYWjpQNYs94pzb966cCVHWJgOfatJxSI1q5rQrwvMlk7MYH9jD2TpUq31KLrzUAoe8IFZ1DlvXWe0JOXQKuQ5Eqt6JiOsrOr4yOpe3f0/ehwyH8JjVsYJyr8cqMptc4MUCOau1TwXNF4ZS5SU79HMa6jk8Y2xslxbH86W26ohshkAv3/jXYDlC6CLC335yY+nV27E0TYuBHLnv00oFPCvbgk9XHNbOmsEWe9HC1LnyxVvbxrDJmVUNC6Eon1lIfF3tUgqzfTnta+KX4z/SETwZFLj+3kvMbvM5R8cIL91gjmOfGhRbyHBzXHaTyUN6u8eUNDYLI83El3wF7iiThV9k6vo1rZa+qK3tQ6G37uupnHaBEjhIIWQTUIgqp6s1k4Hf88R6jDYL/R+7xbkY1yC/+MvvWA+kuKtuDjy3EdBmM22rIwgv3fMSlSOw+zesaEbwMpTkesq2Icm92jMTMZauoOZ+Y/QxcPj8ckGBb3rt6xQJ0BBXnJ9hmfGVsMVm+hzKI/9B1zE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(4326008)(53546011)(6506007)(52536014)(26005)(83380400001)(2906002)(122000001)(38100700002)(8676002)(33656002)(110136005)(5660300002)(66946007)(498600001)(66476007)(71200400001)(66556008)(76116006)(54906003)(66446008)(55016002)(8936002)(86362001)(64756008)(9686003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OVBpYVVlY0NEL09jallzdThUVXRPYnl3aWVBblFTcWNUWFRJVzVvbUprWm1r?=
 =?utf-8?B?MkVsNm5zSHBxdldOZWdWR05mUVphUDd3UU4rV241U3E0VmdDbEhlYi9mUE9O?=
 =?utf-8?B?QjhweWRpSTNYa2J2S2J5ZFdINlNyYUh3K2JNeVJuY2FZemVFNWdleGc1em9F?=
 =?utf-8?B?bWZNRlhESWlsU1pIemJoY1o0cHJUeGdPOFZVLy9pVzZYdzlCM1ZSRnkvMmdu?=
 =?utf-8?B?OFpwc0NycytuWUZ2U0R0YzBRYVM1MEY5dk1Iczlzbnh4VTA5WG95Z25Xa29N?=
 =?utf-8?B?MlozR0ZLVTF0U1JoNGtpVUxSQW1kcEFhZ01JOWpMWjlrVm8vanNsV1czeU9m?=
 =?utf-8?B?RU1YZHFGeUdGZ3gwSlZaaFArS3ZXNno3cXBhMUV5THdBcTE5bmRiTXpjdnNy?=
 =?utf-8?B?d3QvZDNKMVZ6SG9JOVJwUnFGbHBPMU9PNEUrYzR2OVV2cDRRd1VtOVlkWkZK?=
 =?utf-8?B?clJESUdlaExxVXlCN1BESHg2WEZTdEY0WS9TWWhsYTRXSmN4Wk1nRk1GVWhB?=
 =?utf-8?B?eUtnVFRJQjlZUG5Ib21QNVAxQzMxaDhORTBpcFR5QzI2SENjb0FlUGlPb1JB?=
 =?utf-8?B?RzJIM0R3T2JrdFVNV3JFdFZRVy8yVFRnQkNnNkpkWDg3L2l2anE2OGQ0OHFx?=
 =?utf-8?B?NDNQb01ZdWw2cGFQNlJSSGs5NUowOGp5OFlyMExtMUJJeXpML3JFOE8zVzZz?=
 =?utf-8?B?MElDRE94Vk5RYm4xTW5VY0JQWmtnZ29ySVdpUUFKeFJIcHJqMVFsRnFxVTcv?=
 =?utf-8?B?NlY0bHh4K2ZrcHcvK0JIU0RaYVczVG9KT004M2J6cnRuMy92MWs2Smk5Y2l5?=
 =?utf-8?B?NzIyODFtMExvUmNNK0p1U0lRZTE4aVNXZDg5Q3NyakNBVWtIa1NnWHR3ZS9r?=
 =?utf-8?B?R213R0VhaXZWS2tVYXoydVVWNGx1OEdqSGpjdklZUFBXanVnSEh5UTF4dGpD?=
 =?utf-8?B?ZmtlaXVYNUo1V1FEc0ZLejFVbkRDcDFnUzBwY1ppWHRGYkpVa21xNWJGTmRZ?=
 =?utf-8?B?ak4zSjJkYWJ4VWhvT1BZQzB0RGVGRGwzTW9kSWcwWGo4bTBqcG9nWU1VSDgx?=
 =?utf-8?B?YTdvTkhxa1MvUG5maWo1MjZZZXluQzdHZG0rN1Z0bkc1Zk84YnQrTWVJZjJo?=
 =?utf-8?B?KzV5cG1jWFpOditvRGp2ZWR2TkdYNFFDMHN2SkZCUlhZazRjR05uNG1PelJl?=
 =?utf-8?B?U2Mycm45Y210VG5RUnZRaWVmRVF5cEVSYXJpaE5qNE9HL2hXN0dKUTB2RHZr?=
 =?utf-8?B?cjhJTGpUOUZEeUlRTUVYU2NDNUNmMWw4d0x5aSt4WFRUd2VYaC9PQ1l2aHZi?=
 =?utf-8?B?c08xcmJZVlJQaXVIRHNzUHdDNjhUUkFWb2tMYzljRm9JVEt2NDAxazNWaG5G?=
 =?utf-8?B?S2xzUmRWNVJmVHVjc2JBMW85T05CbUFod0JzWVUrditFbldkY050ZGZkck8y?=
 =?utf-8?B?OXlCWDR4QnRGeGV6MnF3Y05SaW5PYUQ1N1lnY0lxcXVrNFcvZ21NSG4rSUtr?=
 =?utf-8?B?T05jdFcwYmtVa0ZoaWhXTmRQK2V2UkJ1UXg1Q0N6MmFWeVphSExBbmo5aTVh?=
 =?utf-8?B?a1Y2RDV5TldHQWt1VVNUbnpGSGM4SE5nUlliNzlZY0FFKzk1VndOM3pCdmpW?=
 =?utf-8?B?NDVUTUFBUElmU2x5UngzZzZIRGMrSE16cW95NkVYeUhHTkwxL05VeDJBM09t?=
 =?utf-8?B?anIrY20zZ0sra28weUVWMEJyVVN3WnpKNmlNM3B4cnVDOHZuUTgrV01FT1Zs?=
 =?utf-8?Q?EH/BQZax4mDQY4x3Ok=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb93f7e-4ec1-44b2-0c3d-08d8fe757c65
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 12:13:02.0419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VkzA0Y1In5T+purKHh9TnxVLualLjVyGwpdOtnsVTVFyGTBoMk07BH+9HPFXkTpLIrk2I6H/Jmx+vMRgamCaEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBKb24sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9uIEh1
bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQo+IFNlbnQ6IDIwMjHlubQ05pyIMTPml6UgMTY6
NDENCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBHaXVzZXBw
ZSBDYXZhbGxhcm8NCj4gPHBlcHBlLmNhdmFsbGFyb0BzdC5jb20+OyBBbGV4YW5kcmUgVG9yZ3Vl
IDxhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbT47DQo+IEpvc2UgQWJyZXUgPGpvYWJyZXVAc3lub3Bz
eXMuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgTGludXggS2VybmVsIE1haWxp
bmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IGxpbnV4LXRlZ3JhIDxs
aW51eC10ZWdyYUB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJu
ZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogUmVncmVzc2lvbiB2NS4xMi1yYzM6IG5ldDogc3RtbWFj
OiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBtYWMNCj4gcmVzdW1lIGJhY2sNCj4gDQo+IA0KPiBP
biAwMS8wNC8yMDIxIDE3OjI4LCBKb24gSHVudGVyIHdyb3RlOg0KPiA+DQo+ID4gT24gMzEvMDMv
MjAyMSAxMjo0MSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+DQo+ID4gLi4uDQo+ID4NCj4gPj4+
IEluIGFuc3dlciB0byB5b3VyIHF1ZXN0aW9uLCByZXN1bWluZyBmcm9tIHN1c3BlbmQgZG9lcyB3
b3JrIG9uIHRoaXMNCj4gPj4+IGJvYXJkIHdpdGhvdXQgeW91ciBjaGFuZ2UuIFdlIGhhdmUgYmVl
biB0ZXN0aW5nIHN1c3BlbmQvcmVzdW1lIG5vdw0KPiA+Pj4gb24gdGhpcyBib2FyZCBzaW5jZSBM
aW51eCB2NS44IGFuZCBzbyB3ZSBoYXZlIHRoZSBhYmlsaXR5IHRvIGJpc2VjdA0KPiA+Pj4gc3Vj
aCByZWdyZXNzaW9ucy4gU28gaXQgaXMgY2xlYXIgdG8gbWUgdGhhdCB0aGlzIGlzIHRoZSBjaGFu
Z2UgdGhhdCBjYXVzZWQNCj4gdGhpcywgYnV0IEkgYW0gbm90IHN1cmUgd2h5Lg0KPiA+Pg0KPiA+
PiBZZXMsIEkga25vdyB0aGlzIGlzc3VlIGlzIHJlZ3Jlc3Npb24gY2F1c2VkIGJ5IG15IHBhdGNo
LiBJIGp1c3Qgd2FudCB0bw0KPiBhbmFseXplIHRoZSBwb3RlbnRpYWwgcmVhc29ucy4gRHVlIHRv
IHRoZSBjb2RlIGNoYW5nZSBvbmx5IHJlbGF0ZWQgdG8gdGhlIHBhZ2UNCj4gcmVjeWNsZSBhbmQg
cmVhbGxvY2F0ZS4NCj4gPj4gU28gSSBndWVzcyBpZiB0aGlzIHBhZ2Ugb3BlcmF0ZSBuZWVkIElP
TU1VIHdvcmtzIHdoZW4gSU9NTVUgaXMgZW5hYmxlZC4NCj4gQ291bGQgeW91IGhlbHAgY2hlY2sg
aWYgSU9NTVUgZHJpdmVyIHJlc3VtZSBiZWZvcmUgU1RNTUFDPyBPdXIgY29tbW9uDQo+IGRlc2ly
ZSBpcyB0byBmaW5kIHRoZSByb290IGNhdXNlLCByaWdodD8NCj4gPg0KPiA+DQo+ID4gWWVzIG9m
IGNvdXJzZSB0aGF0IGlzIHRoZSBkZXNpcmUgaGVyZSBpbmRlZWQuIEkgaGFkIGFzc3VtZWQgdGhh
dCB0aGUNCj4gPiBzdXNwZW5kL3Jlc3VtZSBvcmRlciB3YXMgZ29vZCBiZWNhdXNlIHdlIGhhdmUg
bmV2ZXIgc2VlbiBhbnkgcHJvYmxlbXMsDQo+ID4gYnV0IG5vbmV0aGVsZXNzIGl0IGlzIGFsd2F5
cyBnb29kIHRvIGNoZWNrLiBVc2luZyBmdHJhY2UgSSBlbmFibGVkDQo+ID4gdHJhY2luZyBvZiB0
aGUgYXBwcm9wcmlhdGUgc3VzcGVuZC9yZXN1bWUgZnVuY3Rpb25zIGFuZCB0aGlzIGlzIHdoYXQg
SQ0KPiA+IHNlZSAuLi4NCj4gPg0KPiA+ICMgdHJhY2VyOiBmdW5jdGlvbg0KPiA+ICMNCj4gPiAj
IGVudHJpZXMtaW4tYnVmZmVyL2VudHJpZXMtd3JpdHRlbjogNC80ICAgI1A6Ng0KPiA+ICMNCj4g
PiAjICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfLS0tLS09PiBpcnFzLW9mZg0KPiA+
ICMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLyBfLS0tLT0+IG5lZWQtcmVzY2hlZA0K
PiA+ICMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IC8gXy0tLT0+IGhhcmRpcnEvc29m
dGlycQ0KPiA+ICMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8fCAvIF8tLT0+IHByZWVt
cHQtZGVwdGgNCj4gPiAjICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfHx8IC8gICAgIGRl
bGF5DQo+ID4gIyAgICAgICAgICAgVEFTSy1QSUQgICAgIENQVSMgIHx8fHwgICBUSU1FU1RBTVAg
IEZVTkNUSU9ODQo+ID4gIyAgICAgICAgICAgICAgfCB8ICAgICAgICAgfCAgIHx8fHwgICAgICB8
ICAgICAgICAgfA0KPiA+ICAgICAgICAgIHJ0Y3dha2UtNzQ4ICAgICBbMDAwXSAuLi4xICAgNTM2
LjcwMDc3NzoNCj4gc3RtbWFjX3BsdGZyX3N1c3BlbmQgPC1wbGF0Zm9ybV9wbV9zdXNwZW5kDQo+
ID4gICAgICAgICAgcnRjd2FrZS03NDggICAgIFswMDBdIC4uLjEgICA1MzYuNzM1NTMyOg0KPiBh
cm1fc21tdV9wbV9zdXNwZW5kIDwtcGxhdGZvcm1fcG1fc3VzcGVuZA0KPiA+ICAgICAgICAgIHJ0
Y3dha2UtNzQ4ICAgICBbMDAwXSAuLi4xICAgNTM2Ljc1NzI5MDoNCj4gYXJtX3NtbXVfcG1fcmVz
dW1lIDwtcGxhdGZvcm1fcG1fcmVzdW1lDQo+ID4gICAgICAgICAgcnRjd2FrZS03NDggICAgIFsw
MDNdIC4uLjEgICA1MzYuODU2NzcxOg0KPiBzdG1tYWNfcGx0ZnJfcmVzdW1lIDwtcGxhdGZvcm1f
cG1fcmVzdW1lDQo+ID4NCj4gPg0KPiA+IFNvIEkgZG9uJ3Qgc2VlIGFueSBvcmRlcmluZyBpc3N1
ZXMgdGhhdCBjb3VsZCBiZSBjYXVzaW5nIHRoaXMuDQo+IA0KPiANCj4gQW5vdGhlciB0aGluZyBJ
IGhhdmUgZm91bmQgaXMgdGhhdCBmb3Igb3VyIHBsYXRmb3JtLCBpZiB0aGUgZHJpdmVyIGZvciB0
aGUgZXRoZXJuZXQNCj4gUEhZIChpbiB0aGlzIGNhc2UgYnJvYWRjb20gUEhZKSBpcyBlbmFibGVk
LCB0aGVuIGl0IGZhaWxzIHRvIHJlc3VtZSBidXQgaWYgSQ0KPiBkaXNhYmxlIHRoZSBQSFkgaW4g
dGhlIGtlcm5lbCBjb25maWd1cmF0aW9uLCB0aGVuIHJlc3VtZSB3b3Jrcy4gSSBoYXZlIGZvdW5k
DQo+IHRoYXQgaWYgSSBtb3ZlIHRoZSByZWluaXQgb2YgdGhlIFJYIGJ1ZmZlcnMgdG8gYmVmb3Jl
IHRoZSBzdGFydHVwIG9mIHRoZSBwaHksIHRoZW4NCj4gaXQgY2FuIHJlc3VtZSBPSyB3aXRoIHRo
ZSBQSFkgZW5hYmxlZC4NCj4gDQo+IERvZXMgdGhlIGZvbGxvd2luZyB3b3JrIGZvciB5b3U/IERv
ZXMgeW91ciBwbGF0Zm9ybSB1c2UgYSBzcGVjaWZpYyBldGhlcm5ldA0KPiBQSFkgZHJpdmVyPw0K
DQpJIGFtIGFsc28gbG9va2luZyBpbnRvIHRoaXMgaXNzdWUgdGhlc2UgZGF5cywgd2UgdXNlIHRo
ZSBSZWFsdGVrIFJUTDgyMTFGREkgUEhZLCBkcml2ZXIgaXMgZHJpdmVycy9uZXQvcGh5L3JlYWx0
ZWsuYy4NCg0KRm9yIG91ciBFUU9TIE1BQyBpbnRlZ3JhdGVkIGluIG91ciBTb0MsIFJ4IHNpZGUg
bG9naWMgZGVwZW5kcyBvbiBSWEMgY2xvY2sgZnJvbSBQSFksIHNvIHdlIG5lZWQgcGh5bGlua19z
dGFydCBiZWZvcmUgTUFDLg0KDQpJIHdpbGwgdGVzdCBiZWxvdyBjb2RlIGNoYW5nZSB0b21vcnJv
dyB0byBzZWUgaWYgaXQgY2FuIHdvcmsgYXQgbXkgc2lkZSwgc2luY2UgaXQgaXMgb25seSByZS1p
bml0IG1lbW9yeSwgbmVlZCBub3QgUlhDIGNsb2NrLg0KDQoNCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4gYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+IGluZGV4IDIwOGNh
ZTM0NGZmYS4uMDcxZDE1ZDg2ZGJlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4gQEAgLTU0MTYsMTkgKzU0MTYsMjAg
QEAgaW50IHN0bW1hY19yZXN1bWUoc3RydWN0IGRldmljZSAqZGV2KQ0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiAgICAgICAgIH0NCj4gKyAgICAgICBydG5sX2xvY2so
KTsNCj4gKyAgICAgICBtdXRleF9sb2NrKCZwcml2LT5sb2NrKTsNCj4gKyAgICAgICBzdG1tYWNf
cmVpbml0X3J4X2J1ZmZlcnMocHJpdik7DQo+ICsgICAgICAgbXV0ZXhfdW5sb2NrKCZwcml2LT5s
b2NrKTsNCj4gKw0KPiAgICAgICAgIGlmICghZGV2aWNlX21heV93YWtldXAocHJpdi0+ZGV2aWNl
KSB8fCAhcHJpdi0+cGxhdC0+cG10KSB7DQo+IC0gICAgICAgICAgICAgICBydG5sX2xvY2soKTsN
Cj4gICAgICAgICAgICAgICAgIHBoeWxpbmtfc3RhcnQocHJpdi0+cGh5bGluayk7DQo+ICAgICAg
ICAgICAgICAgICAvKiBXZSBtYXkgaGF2ZSBjYWxsZWQgcGh5bGlua19zcGVlZF9kb3duIGJlZm9y
ZSAqLw0KPiAgICAgICAgICAgICAgICAgcGh5bGlua19zcGVlZF91cChwcml2LT5waHlsaW5rKTsN
Cj4gLSAgICAgICAgICAgICAgIHJ0bmxfdW5sb2NrKCk7DQo+ICAgICAgICAgfQ0KPiAtICAgICAg
IHJ0bmxfbG9jaygpOw0KPiAgICAgICAgIG11dGV4X2xvY2soJnByaXYtPmxvY2spOw0KPiAgICAg
ICAgIHN0bW1hY19yZXNldF9xdWV1ZXNfcGFyYW0ocHJpdik7DQo+IC0gICAgICAgc3RtbWFjX3Jl
aW5pdF9yeF9idWZmZXJzKHByaXYpOw0KPiAgICAgICAgIHN0bW1hY19mcmVlX3R4X3NrYnVmcyhw
cml2KTsNCj4gICAgICAgICBzdG1tYWNfY2xlYXJfZGVzY3JpcHRvcnMocHJpdik7DQo+IA0KPiAN
Cj4gSXQgaXMgc3RpbGwgbm90IGNsZWFyIHRvIHVzIHdoeSB0aGUgZXhpc3RpbmcgY2FsbCB0bw0K
PiBzdG1tYWNfY2xlYXJfZGVzY3JpcHRvcnMoKSBpcyBub3Qgc3VmZmljaWVudCB0byBmaXggeW91
ciBwcm9ibGVtLg0KDQpEdXJpbmcgc3VzcGVuZC9yZXN1bWUgc3RyZXNzIHRlc3QsIEkgZm91bmQg
cnggZGVzY3JpcHRvciBtYXkgbm90IHJlZmlsbCB3aGVuIHN5c3RlbSBzdXNwZW5kZWQsIHJ4IGRl
c2NyaXB0b3IgY291bGQgYmU6IDAwOCBbMHgwMDAwMDAwMGM0MzEwMDgwXTogMHgwIDB4NDAgMHgw
IDB4MzQwMTAwNDAuDQpXaGVuIHN5c3RlbSByZXN1bWUgYmFjaywgc3RtbWFjX2NsZWFyX2Rlc2Ny
aXB0b3JzKCkgd291bGQgY2hhbmdlIHRoaXMgcnggZGVzY3JpcHRvciB0bzogMDA4IFsweDAwMDAw
MDAwYzQzMTAwODBdOiAweDAgMHg0MCAweDAgMHhiNTAxMDA0MCwgYSBicm9rZW4gcnggZGVzY3Jp
cHRvci4NClNvIGF0IG15IHNpZGUsIHN0bW1hY19jbGVhcl9kZXNjcmlwdG9ycygpIHNlZW1zIHRv
IGJlIGNoaWVmIGN1bHByaXQuIEkgaGF2ZSBhIGlkZWEgaWYgdGhlcmUgaXMgd2F5IHRvIGVuc3Vy
ZSBhbGwgcnggZGVzY3JpcHRvcnMgYXJlIHJlZmlsbGVkIHdoZW4gc3VzcGVuZCBNQUMuDQoNCj4g
SG93IG9mdGVuIGRvZXMgdGhlIGlzc3VlIHlvdSBzZWUgb2NjdXI/DQpTdXNwZW5kIGFib3V0IDIw
MDAgdGltZXMuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBUaGFua3MNCj4gSm9u
DQo+IA0KPiAtLQ0KPiBudnB1YmxpYw0K
