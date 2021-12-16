Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A53478075
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 00:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbhLPXU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 18:20:57 -0500
Received: from mail-eopbgr60117.outbound.protection.outlook.com ([40.107.6.117]:40263
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234193AbhLPXU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 18:20:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0ZXXUcMe4xMBeAAgvNNxMSv8hLF+6sSVHxXWSuWHN+cw05F9aHFw9UxHX6cb6qXNokEOS/QL6jbEQJiwursYnufhbAGPIY2pX1+ho1nHXYATNonNvocitiyJVDl1z6LcpCfBQc4NnTbVo2PYkUKoDiYzkuKOstKULhVeTnqPlVYu4VuQxK8c9aVe+z1Wua/7/k1WktGV57M/mNMe53uIwiMq3yDXRrgOguPldPWTT7DSrPNIqQbqBP691jGeiCssfyThVkbWKfGe8KmqDnQbXI3djIy2wgeE71tBdRsZAiMzIWTg5CMlo2l1bMpj28HWFeM/3oM+8eMDpH9SVvYWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LB7jYpy5bwVAoV5iX0I/xUF165+SfXCbiYcBZHxLX+U=;
 b=dH23z/wdiC1+bxcMkEM0idHSc5cjUc5f/ZgC3jdX/Crz5RO+1oMc9zm7NXGKvgWBZgMS4x+xIcPaCcxz8u2N5odjqe/0t3bCf5noFIq5m2A3hm5Iml1b4Qi0yxGpUk8oiqBpgsxLObwphyIFXoInR6ffPKXkgVrwOkEswB46UTj1Y07qJ1aYSMlUDQ0htUxXBVMLCsdfUhjQHZvPR2DUveOjeU9OUK2nfhFH1optwVSbYd9d+GI59iLrizEE5NGf2nm6UN8S38ZgpNt1MlaGUWwtDUohplTlaeQHQ+K+dMsof77G8kXGxFjC7iANQAY/lvwH2dSfpGmx6T4e8mmxPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LB7jYpy5bwVAoV5iX0I/xUF165+SfXCbiYcBZHxLX+U=;
 b=BD/1aNxLy5l5n8PFn42Kxz422TempmHzzi9vosbaJeI3JIrGAYun6QM0zO0Fr0aqfTOost7vLV6o24vL8/hlWrQJWHtttjraUF+CJuk2PCDDFdGjfDYsh0O3zlUSlfcbYs2av4ZWS0sT3Y3uewzDXFz5ZA1xa917f+GeHpRvrgU=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB4919.eurprd03.prod.outlook.com (2603:10a6:20b:85::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 23:20:54 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 23:20:54 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "luizluca@gmail.com" <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 01/13] dt-bindings: net: dsa: realtek-smi: remove
 unsupported switches
Thread-Topic: [PATCH net-next 01/13] dt-bindings: net: dsa: realtek-smi:
 remove unsupported switches
Thread-Index: AQHX8rmAkg+HH3K17UGt3W6IQ2E8N6w1wbCA
Date:   Thu, 16 Dec 2021 23:20:53 +0000
Message-ID: <4f288fb5-3497-1529-c715-146e3c4dae83@bang-olufsen.dk>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211216201342.25587-2-luizluca@gmail.com>
In-Reply-To: <20211216201342.25587-2-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e02312f-eed6-4fe8-f151-08d9c0eab501
x-ms-traffictypediagnostic: AM6PR03MB4919:EE_
x-microsoft-antispam-prvs: <AM6PR03MB49197C8CF85E303EF11CD47D83779@AM6PR03MB4919.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4fcXJJxOnOOliuccVwtHRKYDY3pDdRW/kJR0K6mXpgXECThuqeGu5AZHbUG7RerXm8WQaSHrqfNUsWfeBx7co/Df02TE5rLv9Z5DNJ+UqEE/7mqes4E/j70aD8x6zfGz0yDMTCPzs9TS+Sx3afLHaMNtEGYcGGyXdohSoTioqTVDt9vqxb3Hln3n7PPxQVeE66FdM3NdUvp6luB68x9hErmQLSQdHhVV0keXW4RdNWqOAYVQ3WN4mQuOOFRhkwbOomYZFWcNlqI4Bh6epK8rl3g4An5RtXOTOil7B9JM7md7pYq/8dnFWXskN4DnIKaSkBPtCBRC+8cc8Wv9oM47ji4t2CM0BMEEygod2WS0Y+d/wnJ4CT7AUyWKkdlzM88D6jCH4s5MtxCuQ6np4SQ5ImgNP2Z68/C8ADsijsZJdv/PK7KEAqERmTG1bOFkOIQTBDfC9tVQvPSbtDyzwfhuL5c6ACzLDmyTym/dLKcX0C6Yy6uibpnzGXCJaC0BPk2nd1LQzafzhus/Zm6CeCEgawd0K8dqWiSGN3NmalrnQc3UnAkk6uA+D4GMjFUvFyxnHHz7yOhNdBbewrtR1vJomB3lVT5PigZaNjrBD9sI4PSXFUPSj/A3LZEmFjZcW24tp4ODM5u1kpB88hB3A54It8OnhlNycucojactyMB3oQ6UgtmF4jvMf8UQCW4jF84iqldHsxXh18v6G9YYqnmIK8i7nfJnXqp0sdPL2Qy/oebOw13LFJMHRPiyj460tECcABj6qkITX9M+9AAOJMi7Og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(38100700002)(54906003)(26005)(85202003)(91956017)(8976002)(76116006)(2906002)(64756008)(8936002)(6486002)(31686004)(66476007)(66556008)(66946007)(6512007)(4326008)(71200400001)(83380400001)(66446008)(8676002)(85182001)(6506007)(316002)(508600001)(5660300002)(31696002)(2616005)(53546011)(110136005)(122000001)(86362001)(38070700005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3lvTWpTNFV0N1BIL2l0Vit4ZnVtRlo4UXJLY1QrRkdBSVkrL1g3QmR5ZWk4?=
 =?utf-8?B?cHhmYmVVeThMaVV4S1NlVjg0bEFIZTBuZkozdzhuRFhDdGVHNmJYbUF6SG5J?=
 =?utf-8?B?aDh1NHRnTU5PZ3BRSXdrajFXTExYaUJoWFVIcWRIeHkwL0Fwc2hFdmtDWDJU?=
 =?utf-8?B?NXI0MjF2NjF0UjNTNVFScFFNRlMreVdGUFloWEh6RU5hZ1JmQmhjNVk3QVZv?=
 =?utf-8?B?THI5QVBoalZITzI4MG5TOWZBcElmNThiSFNGVmxjaUhEUzZ5K2F3cUdvQkNU?=
 =?utf-8?B?ZVU4SkdOemJOM1R6L1h1dEpMTzVsNnkrTTVHaVBESlRRRjJZLzIwN1FHYU1W?=
 =?utf-8?B?ZEVmOEpOUEN5TDJnV285aXVqVkcvY2RkditwSDZSQ3NNWXFGRk9GTlVDci9r?=
 =?utf-8?B?c0VCb1B5cmdOdGxlLzJveVpRWXR5YU45UWx5ZVU2Vzh4VEoyR0VTdU1Nd1dF?=
 =?utf-8?B?WTg2VWs2bldFbDNTd2lyM2dTTWxkYmpwd29waHdRT1ArUmhSV0tqQUdKaE5m?=
 =?utf-8?B?QktqZEhCRWYvUWk1SlJqWHdiVUhUUlZYSDJLcDZrNjdoZkVNRlBUajdyUXR0?=
 =?utf-8?B?STdHVkE0VGdZTGkrd2NHMlpjaTlvMEh0dHpJdnZqMXBjTUw4SHJ1dnlsMGl3?=
 =?utf-8?B?ZkI2dWU5ZjdsZFNGSGhHQ2ZRN0ZubWxSZnpCa3U5NzRpTHdyNnNEeXdVNzRh?=
 =?utf-8?B?WGFNaVNOc21ZdDFWLzBvczI1MmZhT2V4aEVLRUlvbHdqbzZPVUdSMDcvTG9W?=
 =?utf-8?B?WUJvd25xdUQyTWhnOU56dDc3MzBFdHRTdE8yaUxzZjJCYnZRR3MzQURzb1FZ?=
 =?utf-8?B?TXF4RlFjNHhITUoyZko0N3F1NEhRUERmTXVXRTR4TytmUVA4MXE1SlVSeXNm?=
 =?utf-8?B?R1NkcytneXlTSDV3S2FKQjNVUExUc3IwejBiQXdtNmh6Ulh3WGZJMnhWWk1I?=
 =?utf-8?B?NlljRDF1MTZFdUVMcVVLaHVjNzV6dTkxTWE2Q2I0YXFyL3Riai9qbFYwMG9Y?=
 =?utf-8?B?ZVdCaXVKKytoMWs4UXZ6VExiUzBEYWxDOXFwNGxYTUkrV25UN0FLNFNCYVkw?=
 =?utf-8?B?MVM4L2F3K3IwUkRtZDN1WFYrS1NCa0pjYk43R2xMVXRvYTRDdS9BM0RZU1lW?=
 =?utf-8?B?U0hGbHZNMnBwYllGUU44eDNSeUpFZ2IxUkFjcGY1aWQ2WHVVR1ZTQUxMeU1R?=
 =?utf-8?B?bWZSUk0yeFJlNWptUWNsSGpxSXAyNmFGODFYdU5vY0daaExpaWNNWlFtVnBl?=
 =?utf-8?B?anlvUmV2bWZ5NjhUV1M0WUJ0Z2lRRjBBekFQNStVcE1CNjI5eSt0MG1seEpv?=
 =?utf-8?B?cnFFeEdiYk9kRzEvcWF3ZVd5c1FSZUpwZUtYOEd6ck84Q3dCQ2pNMXZqakRR?=
 =?utf-8?B?RGdEUVNRamVzYndWMWt3bDZYamluSUlaNmpZdkxrMkkxM3l6c1JtcnErb1hK?=
 =?utf-8?B?S2hWeVMzVnFxaURQT2QvaGFsNXVRZFltNS9YT3Bid283UnhhTVhwWFpTRWZr?=
 =?utf-8?B?bTJ0OWw4amJGbkdxeVVVV2w2ZFE5SndLL0gyNmZITldNbHJYOFZkY0hCdzJO?=
 =?utf-8?B?cWpkcW1KY3B0QmJ5Q0lUL04wZStyVFIvTUMrU2d5VDZyUmZSV2did1V1eWxI?=
 =?utf-8?B?NHFPMStMZlhCeXFtN0VCdXZkZjZtTEZTeEVyS0M2RGhnNk10QnU0ZFdlRDBh?=
 =?utf-8?B?WHNNMnNFQ0RlOWlIeFFadkdnWk9lQVpMTWhiNm9OdGN0SDM0clcyL3Q1WFhj?=
 =?utf-8?B?aTAvSDIzK3lUZElGcDY0bWZxWkpDWkhpWDFhY29SUjRTSUl3TGhLNERzSGZm?=
 =?utf-8?B?RE1wem0vWlI3ckFJcUs0V1JnaVlvTlczYWcrSTN0Z1ZMeGtJSG5wd3RzcmNl?=
 =?utf-8?B?UEJHWmc3dWNGV2xNb21yNkt1YlFxOUgxa3I4RTRxYWNLTE83YW5XaW44RFZ3?=
 =?utf-8?B?UDNDalhJNEhkMk9STkdDcjBISEp4QW9kT3AxMW8rVEhhLzFFR0ZTMG1oRU9D?=
 =?utf-8?B?SFNJTTJoc1oxT0dmUzM1N1lwVjVrMzJkbEhQaDJEVGFSNE8xODhQN3VvS0xV?=
 =?utf-8?B?MHVaSElWN3RsNGJsekxOWEV6VFlDbEFIMHVxc3FJNmF2ZHoybmtqSDZDMDN4?=
 =?utf-8?B?eC91T1Zjb3dBSURKalBJT0huZHFYaXRhemVKWUdGY01qVkxrT2RQUmJRcytp?=
 =?utf-8?Q?mB/fS4OfcbhvHtkc86zlxcA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98BABE174974FA4495DD7F70C3DE46B9@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e02312f-eed6-4fe8-f151-08d9c0eab501
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 23:20:54.0090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r7vVPX6t4cYLI2g+7M4aZL2BkW3+e2kXyTMxSIcqhmJJapdWV6/GzRbtpzfRHREPKjhUNeVGhiaf1AT/V2z31Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4919
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTYvMjEgMjE6MTMsIGx1aXpsdWNhQGdtYWlsLmNvbSB3cm90ZToNCj4gRnJvbTogTHVp
eiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPiANCj4gUmVtb3Zl
IHNvbWUgc3dpdGNoIG1vZGVscyB0aGF0IGFyZSBub3QgY2l0ZWQgaW4gdGhlIGNvZGUuIEFsdGhv
dWdoIHJ0bDgzNjZzDQo+IHdhcyBrZXB0LCBpdCBsb29rcyBsaWtlIGEgc3R1YiBkcml2ZXIgKHdp
dGggYSBGSVhNRSBjb21tZW50KS4NCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNp
QGJhbmctb2x1ZnNlbi5kaz4NCg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFyxLFuw6cgw5xOQUwgPGFy
aW5jLnVuYWxAYXJpbmM5LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTHVpeiBBbmdlbG8gRGFyb3Mg
ZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPiAtLS0NCj4gICAuLi4vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvZHNhL3JlYWx0ZWstc21pLnR4dCAgICAgICAgICB8IDkgKystLS0tLS0tDQo+
ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9y
ZWFsdGVrLXNtaS50eHQgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Rz
YS9yZWFsdGVrLXNtaS50eHQNCj4gaW5kZXggNzk1OWVjMjM3OTgzLi4zYTYwZTc3Y2VlZDQgMTAw
NjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL3Jl
YWx0ZWstc21pLnR4dA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
bmV0L2RzYS9yZWFsdGVrLXNtaS50eHQNCj4gQEAgLTQsMjAgKzQsMTUgQEAgUmVhbHRlayBTTUkt
YmFzZWQgU3dpdGNoZXMNCj4gICBUaGUgU01JICJTaW1wbGUgTWFuYWdlbWVudCBJbnRlcmZhY2Ui
IGlzIGEgdHdvLXdpcmUgcHJvdG9jb2wgdXNpbmcNCj4gICBiaXQtYmFuZ2VkIEdQSU8gdGhhdCB3
aGlsZSBpdCByZXVzZXMgdGhlIE1ESU8gbGluZXMgTUNLIGFuZCBNRElPIGRvZXMNCj4gICBub3Qg
dXNlIHRoZSBNRElPIHByb3RvY29sLiBUaGlzIGJpbmRpbmcgZGVmaW5lcyBob3cgdG8gc3BlY2lm
eSB0aGUNCj4gLVNNSS1iYXNlZCBSZWFsdGVrIGRldmljZXMuDQo+ICtTTUktYmFzZWQgUmVhbHRl
ayBkZXZpY2VzLiBUaGUgcmVhbHRlay1zbWkgZHJpdmVyIGlzIGEgcGxhdGZvcm0gZHJpdmVyDQo+
ICthbmQgaXQgbXVzdCBiZSBpbnNlcnRlZCBpbnNpZGUgYSBwbGF0Zm9ybSBub2RlLg0KPiAgIA0K
PiAgIFJlcXVpcmVkIHByb3BlcnRpZXM6DQo+ICAgDQo+ICAgLSBjb21wYXRpYmxlOiBtdXN0IGJl
IGV4YWN0bHkgb25lIG9mOg0KPiAgICAgICAgICJyZWFsdGVrLHJ0bDgzNjVtYiIgKDQrMSBwb3J0
cykNCj4gLSAgICAgICJyZWFsdGVrLHJ0bDgzNjYiDQo+ICAgICAgICAgInJlYWx0ZWsscnRsODM2
NnJiIiAoNCsxIHBvcnRzKQ0KPiAgICAgICAgICJyZWFsdGVrLHJ0bDgzNjZzIiAgKDQrMSBwb3J0
cykNCj4gLSAgICAgICJyZWFsdGVrLHJ0bDgzNjciDQo+IC0gICAgICAicmVhbHRlayxydGw4MzY3
YiINCj4gLSAgICAgICJyZWFsdGVrLHJ0bDgzNjhzIiAgKDggcG9ydCkNCj4gLSAgICAgICJyZWFs
dGVrLHJ0bDgzNjkiDQo+IC0gICAgICAicmVhbHRlayxydGw4MzcwIiAgICg4IHBvcnQpDQo+ICAg
DQo+ICAgUmVxdWlyZWQgcHJvcGVydGllczoNCj4gICAtIG1kYy1ncGlvczogR1BJTyBsaW5lIGZv
ciB0aGUgTURDIGNsb2NrIGxpbmUuDQoNCg==
