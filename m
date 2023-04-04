Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702E56D5979
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbjDDHZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjDDHZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:25:39 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2138.outbound.protection.outlook.com [40.107.247.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4342111;
        Tue,  4 Apr 2023 00:25:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apxGfWGEjI/EmJndSZX1SDU/maaHCdNsZWERVlR8JhwZUEeuK8vQg6f58IyDJj4sdcz2nhzWlWwzFp478wrqCxwm7TMgZ7dmlISidWrrr+yn5GMPXmO9hFyMz6gEgxi9KaeOfwsqYvky8Y4WfdhpZlAtYA+BDGmKaTLSzks+Tcm0dYF1P7oKFV5im6QKWNI76R0W32scz6zvO/uVuf0FPbFpEB5mAfYIVuz5OYHQlJZU54b4NTWv/kXyi7HX0QN4WJeIndLtQKxyJ4bIWC5qqkQPPyMwZT8eH/pe0pBTKc1cpgyC3rJYJD6UbfCNSUgy8CLaal6LW10NM9Hz/cayUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBFh+SIJTVe38ZW1MZdSfuo6W1lSaFe0mnhJYJuWvEI=;
 b=PWXEpw5NoA4xCdwDl2xPXGb3xLTJyIjmogjWcjVlO2G3K+/96NcuiZa9nfME3UEZDjvyh0JiTyt7sitYxermPvS5bUf1jEeBR2rhIE4zTS+9IXduuRcx9+x7042waqUqKC/MwpVm+pQkhgWQysSOnO575nUzeJHIy1H1BKG6IDo+oxoQQAmLVMYugRoBGRzqrUXwkzw8DugMGP8DhoZ1docAdl2sa7dTYkrBXA1UT9dDfKrpAVxfNugybANoEMIfXO/gytSXrBtCXvTJjmEX/iWlXDSQr8puEFYcOZ0ff1JG4Fg0T8oJcH3SxmIpnrOWKOEpaFP48XB7AXAXfYGXQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mail.schwarz; dmarc=pass action=none header.from=mail.schwarz;
 dkim=pass header.d=mail.schwarz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mail.schwarz;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBFh+SIJTVe38ZW1MZdSfuo6W1lSaFe0mnhJYJuWvEI=;
 b=fPe4gYWJlQA6iiDpQ6/wdxmnoRevfey9kzmHr30YD+2nlKEdjnzN3uJWnSDIXyiqlvVBnvNh3lXKCZBjJ9H7ws7nsCX86HqvwMAjM4rZbLF5iY5zbfbeYGYZpJ7OmCtm6798S1bNHIbe1PdlzoymFmMkkUB7yArjGsHUmbreYq4IhfQqxVcFybe4u/NYls7kSCtJ+p1lSBqODpzpb3uBSRwYuftFODQEOu6bss+pVL+WKb941iEsF6GJWnvwF4oAwi+IyxFKFp+2we3Zm0aKyaNJXsDeZ3mnClKwcuNplVhqZIsLtzRkuZcJvaayqOxkeSETDVNkPj0TcoQRh96CFQ==
Received: from DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:34c::22)
 by GVXPR10MB8004.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:16::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.21; Tue, 4 Apr
 2023 07:25:33 +0000
Received: from DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ceef:d164:880a:be9c]) by DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ceef:d164:880a:be9c%4]) with mapi id 15.20.6277.026; Tue, 4 Apr 2023
 07:25:33 +0000
From:   =?utf-8?B?RmVsaXggSMO8dHRuZXI=?= <felix.huettner@mail.schwarz>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luca Czesla <Luca.Czesla@mail.schwarz>
Subject: RE: [PATCH] net: openvswitch: fix race on port output
Thread-Topic: [PATCH] net: openvswitch: fix race on port output
Thread-Index: AdljmWv5YS2k+yAfSXWo9bXiCkDODgAuIhwAAHCFwEAAEkS3gAAaVh+w
Date:   Tue, 4 Apr 2023 07:25:32 +0000
Message-ID: <DU0PR10MB52443A214A27890DE83C1D56EA939@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
References: <DU0PR10MB5244A38E7712028763169A93EA8F9@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
        <20230331212514.7a9ee3d9@kernel.org>
        <DU0PR10MB52446CAE57724A0B878BAA66EA929@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
 <20230403115011.0d93298c@kernel.org>
In-Reply-To: <20230403115011.0d93298c@kernel.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mail.schwarz;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB5244:EE_|GVXPR10MB8004:EE_
x-ms-office365-filtering-correlation-id: 0a21a196-44ce-4363-1b6d-08db34ddc6c5
x-mp-schwarz-dsgvo2: 1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lFkKrVl7KZvNWux2gGQ6LM9NxCANH+bpvpx7hK0ef3Na/j0VvTouyV+FeDcgcjXms6bC0WUmbdLSsCxDlTbQv/6zFUiL2GpI1d5zWMQ3e6989W4S+n2aSsY/Lg2drWfn0H3hnLlTMSMxLSEtvFnVrYNsIMhBj6XkM/leXOJysepMKmCaq9aGg1AFl5ZGR7a/XHWTdWJvGq8V2OMwQU66CKbrfWqMq90YSAT80WAjqTPWSUGs442hLM3tESagVnIqOoJgHoAlheMZtDwNIReDBUSOYrfS3jWhZVwmKVuKcJ6GPxD4Zs1X49BMN6HwLP5PWf+ZzjXnNk9/D8KUpvRTeynOqbC7/hjE3eyyxf+ID05EpewPy2am/1sbcAgs4+5LvwEw37hzJPS8Q8hD19ExmUj4jcwfZFbdMX0gIzIn5m08d5sH4D3j50pb0tnpD+Pn8P9KJStsfVwL73JIOlp00w/+bME332W1ahSvcoYx5KJ6m8AvNsOwcREWrXYcqWeWOU9IxmNENvcnXRxglBE292iNZehu6Fk6w7e7I0ZzvTf8VCMGRy8hmsNp3ZvQpwKWspHhDlUptE6lRQGDhvqjgs+iEC0OQ4cicd3jg17M8OfD/RAKX1qRL1qKfKwpn1fZ1jzzhhw5T+cFD0b+Qwm6OQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199021)(55016003)(6916009)(122000001)(66946007)(64756008)(66476007)(478600001)(66446008)(82960400001)(66556008)(76116006)(52536014)(54906003)(316002)(4326008)(8936002)(8676002)(5660300002)(41300700001)(38100700002)(186003)(71200400001)(7696005)(26005)(9686003)(6506007)(86362001)(2906002)(85182001)(85202003)(33656002)(38070700005)(66899021)(46492015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0h5MG50dWM4SUpkR3hyTlpzeE9PR1k4NmFmbkEyeG1pS0V4NnBmcUlSbmtu?=
 =?utf-8?B?UXZSQWRYYjNHcEtPMHRZNW1rdThaRmxOclVNVjloWkZJSk9meTBiV2ViMGlS?=
 =?utf-8?B?VzB1VjZIQTlNSGM2ZHhoVlJTcG5weDYrc2YyZUg3Q2xYL0xVT0NZVlhtUlJJ?=
 =?utf-8?B?bWc3dkpsZ0ttSnJEL0dMQlVjbG9GS2hOaU1LVVdIMG1PTXFtZjdONGF1c2I5?=
 =?utf-8?B?V0J0K0FCSXlaSzFSQjBUdHRnZWdjSUZvL1dYMG4vcnVDcFQrQzNsSmI1dzlB?=
 =?utf-8?B?eFZjRmlvdU1nRnVwT1BGS2h3T1B2K2xncVdydHorTy83bUlreEZUK1lhdEJ2?=
 =?utf-8?B?MjJVQ0ZTSUZra09vMXg1VmkyTWN0QmJxRkdhQ0dTTnp1MmhIQ0xub05IKysx?=
 =?utf-8?B?alQ4elFRdXhMdUNVemE4Qy9MZXN2QXB4VmlvYVBIYzVxYVlLM2FkWnVLMjlC?=
 =?utf-8?B?dnlMTFo4bmpwWXdmQlVzUnFmNGM0Skc5NXBYaDE4N2o0RWUrYkxuOGtoTXZM?=
 =?utf-8?B?MUc5WTRPYVZ1QlJicldSeVFLMVBwVlNLWXNzVDRrSG9LWGpWZlRrYTRlQzNn?=
 =?utf-8?B?eGZUYkp5bTNDN1ZyK3lYMFFQM1pGYnBkKzVhSU8yWGgvaEwxb2pFQkw0MmdV?=
 =?utf-8?B?cHpRNEdmUlo5UUlRRFUycFVQdzkyd2NNRkIrR2FCVlkxRHVMb1F0dmEwMWdG?=
 =?utf-8?B?ZVg2WUU3K2N3RW1uQWxqTFhlMzlBendybnJWaUxxWmdSN1kyajlhVVFCZUpP?=
 =?utf-8?B?UzNGWlFQaFlCTEM1dGQwU2FtT0FzMjJGUEhvR1RpZUhKV2wrZ25rMVdCd002?=
 =?utf-8?B?bTE5cUFicy9FYnNZRjluZWdHSWEyUEJMTFBoWkFpeE44d3hKM0R0QWQyb0NP?=
 =?utf-8?B?SkpwRlZHaWErMDRIMW5WY2dMNnFjL2UyNDlnZXpTVnZEbnZGUVdYd3hGMFJX?=
 =?utf-8?B?Ty9ER3BRcnl3MVdzZG9wN2JsZUx4QXNiY1l6QzNvZ21samRRWWdlZEJ5SkJx?=
 =?utf-8?B?NVZYeTVjMHl5SUh6S0JjVk9HMUx2Nzl4Nlo2NEtmaXNJSzlweXI0UUQ3d1lT?=
 =?utf-8?B?Z3g2OWFkQUhtdGpQQWFaOTFrK2FIQUxmS01PUTZlc0VUZXlYelU5VWJqNnFj?=
 =?utf-8?B?MGRsc0lNcUtlSCtnemJHWTQ2dExrRkdFcGpranBURGg2NVhETmtDUm1QeXRO?=
 =?utf-8?B?NkgxeHg5ckppVExaZmViQk92SGh6czBTc1pZQitibFNodVFwME5QUXo1b0FL?=
 =?utf-8?B?M3d6TWZoOERuc3RISXprUnVsaVpCRGZTN2VuRXRCUzBIUUFXbFZPN21zSzdE?=
 =?utf-8?B?bkVJRURzeVBRaDNWdG1EV1YzQjYxbHVCN2hNK0ErNmhVL2krVHd3NEtHS3Za?=
 =?utf-8?B?bjBtL1F1aWZ5ekcvZWhPWUlURUE1c1pDaW9FUWhaUVNhZ01qSWQ0TW9DMm12?=
 =?utf-8?B?WnB6eENtcTIvNmxoVERDdW80RFprTW9LTThpZFU1UjdRL1Npd0dPNFUwZ0Fi?=
 =?utf-8?B?c2tUV3dMUktraTlndjhmRGNUQzgycmxuNTBUOXlOTzdPdThLSkUzNFpPQ3dG?=
 =?utf-8?B?dXdrZ1ZldEtiQnYzU1JPL0srVVlPY0p2dXg0OE5EOXFqNTNmZUFxcDdsNVQ3?=
 =?utf-8?B?T1RubkZhQzVkbytDTmVsWXAvQTJXN2hFSmpzclBaRDZGVlRDWlMyeVQva2tu?=
 =?utf-8?B?OHdYdCs1YzQrdHZnaTYxcmlsMkxBcEdYeVF0Z1ZrdVhONFpMZXcrUHBXYXFi?=
 =?utf-8?B?bGt0TnVsaFhaZGp4dGtQVjhRbER2RDRSOXdjRDdxMFlyNTFaYzljRUFGMkN2?=
 =?utf-8?B?cDNMQm1pQjVraVhXU2dFVDJqYXJXeWlydGhsZEZicXdCbW0wVS9UTGJSNGI1?=
 =?utf-8?B?eDMrVi9QVjlsdVhVTFRmYm55Z3JnNkt3RldkQWZOV2lZakZVZlovbk0rYnZJ?=
 =?utf-8?B?REVoaWh3eDJKRU1sb21xbkd0ZlByV0lUejh2bGJtbUh1S3Q3OEkyMm1kRGpw?=
 =?utf-8?B?aDUrMkY5aURkbnVTZ00rWlNzWmtWNklvOWt5NkZ4b25zVU1JNXlKT05jKy9B?=
 =?utf-8?B?Y3hTMmh6cXBTV2xheGVjUTRaNExpOUQ4YThEY1p4NzMyR29HVnB0eVJzZlp6?=
 =?utf-8?B?Zk52VU9hanVpdjJkUHpKY25HR2hMZnhTalE3Rzk5NTErY1pNd0FDZ3N6SlI1?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mail.schwarz
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a21a196-44ce-4363-1b6d-08db34ddc6c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 07:25:32.9748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d04f4717-5a6e-4b98-b3f9-6918e0385f4c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2FmHbJMcOY2EYNGErl3tBLFkRC7Asx6+Bxw4FgXxLCLOOvpDeBAauuGhkciZzYgOCyJZBEGkOsDZUgh+yVDJHXJS3bywwibLuXhAK6/GOA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR10MB8004
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAzIEFwciAyMDIzIDIwOjUwOjAwICswMDAwIEpha3ViIEtpY2luc2tpIHdyb3RlOg0K
PiBPbiBNb24sIDMgQXByIDIwMjMgMTE6MTg6NDYgKzAwMDAgRmVsaXggSMO8dHRuZXIgd3JvdGU6
DQo+ID4gT24gU2F0LCAxIEFwciAyMDIzIDY6MjU6MDAgKzAwMDAgSmFrdWIgS2ljaW5za2kgd3Jv
dGU6DQo+ID4gPiBPbiBGcmksIDMxIE1hciAyMDIzIDA2OjI1OjEzICswMDAwIEZlbGl4IEjDvHR0
bmVyIHdyb3RlOg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZGV2LmMgYi9uZXQvY29y
ZS9kZXYuYw0KPiA+ID4gPiBpbmRleCAyNTM1ODQ3NzcxMDEuLjY2MjgzMjNiN2JlYSAxMDA2NDQN
Cj4gPiA+ID4gLS0tIGEvbmV0L2NvcmUvZGV2LmMNCj4gPiA+ID4gKysrIGIvbmV0L2NvcmUvZGV2
LmMNCj4gPiA+ID4gQEAgLTMxOTksNiArMzE5OSw3IEBAIHN0YXRpYyB1MTYgc2tiX3R4X2hhc2go
Y29uc3Qgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCj4gPiA+ID4gICAgICAgICB9DQo+ID4gPiA+
DQo+ID4gPiA+ICAgICAgICAgaWYgKHNrYl9yeF9xdWV1ZV9yZWNvcmRlZChza2IpKSB7DQo+ID4g
PiA+ICsgICAgICAgICAgICAgICBCVUdfT04odW5saWtlbHkocWNvdW50ID09IDApKTsNCj4gPiA+
DQo+ID4gPiBERUJVR19ORVRfV0FSTl9PTigpDQo+ID4gPg0KPiA+DQo+ID4gSG93ZXZlciBpZiB0
aGlzIGNvbmRpdGlvbiB0cmlnZ2VycyB3ZSB3aWxsIGJlIHBlcm1hbmVudGx5IHN0dWNrIGluIHRo
ZSBsb29wIGJlbG93Lg0KPiA+IEZyb20gbXkgdW5kZXJzdGFkaW5nIHRoaXMgYWxzbyBtZWFucyB0
aGF0IGZ1dHVyZSBjYWxscyB0byBgc3luY2hyb25pemVfbmV0YCB3aWxsIG5ldmVyDQo+IGZpbmlz
aCAoYXMgdGhlIHBhY2tldCBuZXZlciBmaW5pc2hlcyBwcm9jZXNzaW5nKS4NCj4gPiBTbyB0aGUg
dXNlciB3aWxsIHF1aXRlIHByb2JhYmx5IG5lZWQgdG8gcmVzdGFydCBoaXMgc3lzdGVtLg0KPiA+
IEkgZmluZCBERUJVR19ORVRfV0FSTl9PTl9PTkNFIHRvIG9mZmVyIHRvbyBsaXR0bGUgdmlzaWJs
aXR5IGFzIENPTkZJR19ERUJVR19ORVQgaXMgbm90DQo+IG5lY2Vzc2FyaWx5IGVuYWJsZWQgcGVy
IGRlZmF1bHQuDQo+ID4gSSBhcyB0aGUgdXNlciB3b3VsZCBzZWUgaXQgYXMgaGVscGZ1bCB0byBo
YXZlIHRoaXMgaW5mb3JtYXRpb24gYXZhaWxhYmxlIHdpdGhvdXQNCj4gYWRkaXRpb25hbCBjb25m
aWcgZmxhZ3MuDQo+ID4gSSB3b3VsZCBwcm9wb3NlIHRvIHVzZSBXQVJOX09OX09OQ0UNCj4NCj4g
c2tiX3R4X2hhc2goKSBtYXkgZ2V0IGNhbGxlZCBhIGxvdCwgd2Ugc2hvdWxkbid0IHNsb3cgaXQg
ZG93biBvbg0KPiBwcm9kdWN0aW9uIHN5c3RlbXMganVzdCB0byBjYXRjaCBidWdneSBkcml2ZXJz
LCBJTU8uDQoNClRoYW5rcyBmb3IgdGhlIGNsYXJpZmljYXRpb24uDQpXaWxsIHRoZW4gdXNlIERF
QlVHX05FVF9XQVJOX09OX09OQ0UgaW4gdjINCkRpZXNlIEUgTWFpbCBlbnRow6RsdCBtw7ZnbGlj
aGVyd2Vpc2UgdmVydHJhdWxpY2hlIEluaGFsdGUgdW5kIGlzdCBudXIgZsO8ciBkaWUgVmVyd2Vy
dHVuZyBkdXJjaCBkZW4gdm9yZ2VzZWhlbmVuIEVtcGbDpG5nZXIgYmVzdGltbXQuIFNvbGx0ZW4g
U2llIG5pY2h0IGRlciB2b3JnZXNlaGVuZSBFbXBmw6RuZ2VyIHNlaW4sIHNldHplbiBTaWUgZGVu
IEFic2VuZGVyIGJpdHRlIHVudmVyesO8Z2xpY2ggaW4gS2VubnRuaXMgdW5kIGzDtnNjaGVuIGRp
ZXNlIEUgTWFpbC4gSGlud2Vpc2UgenVtIERhdGVuc2NodXR6IGZpbmRlbiBTaWUgaGllcjxodHRw
czovL3d3dy5kYXRlbnNjaHV0ei5zY2h3YXJ6Pi4NCg==
