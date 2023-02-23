Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16806A0C76
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbjBWPDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjBWPDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:03:51 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2098.outbound.protection.outlook.com [40.107.20.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5491ABDC
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:03:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h50/G2XE4Q8X3HMIkCA9sphhhAukzkEf7fjQYTxI9JsC0A+TPIHe6FY2M23SnFKu/Ll6+KTyjgfkfl1sarQPeGp4GMy+YbVh5jix2oLpp6ZU/DLdr10TEcSTNW05fJGylDLmgsevxjVZeGVTLPbtXlsjpRRQSXGJauPq4Y9VfkK5JuH5ArV+jYCM0n7+h92OVnwCl/erkWBrQMb43mdVABR0m5FFQTAqs1AMmjr2sHzMjqx6+DidXRtZIWS0adbs5ySuUmZA/90yuJ4kYGOUm5TFkm+GgnbRCB+wlvbSi+DNsr3EZzv6dYps9SQaZCZccoPkOe0g+janV48QnHwt8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6fBw6Ox11PRkPDeRAoNngjsTTdcNUfTOuhGNJ5TBwA=;
 b=oeCKM0JSXkCZJ+LFnBNcrmAkmYaBAx/FaDcX5yHlI3n+2D5tCj7LVY6fDzm1h5rLN0PraGO2chg5kSMJhPSmhfyvzM2b0oBk0rB3dOKhCEorxHT3keWEigEm05QmPFpdmmD1aE6iU71GmqZKMHFZuBaoDGBYOObH4EEQkPwLmOwgzyrojECAI8V1YXpNVI/KUrpEPuzEV7lQ4gMsRfy/8qFKeNJGS1vn8ZfXvUTk9OS75YBzF9ovrSK6ve9cCHRMAy+pOytMCOft/Rl6K8b+OIVVzYjje4TLK7J8yEc6JmZvMlD3j8UXFYZjl4iDmNtSKkcI0eUxdT8OYdyjzhHqsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6fBw6Ox11PRkPDeRAoNngjsTTdcNUfTOuhGNJ5TBwA=;
 b=lVCOpp4/lb0lmQwPvWB3eBWef4lrsF57zlkfJURMk1v3kn946nR8nFHniL71Yu3ZMoxv3DjIjOz48ICwtF83+vgvSud8CgurkEY5fBE6jXfdv23UMBsNG/8fjDj/5yBVpmN8EZmmzfDSf0hASKUUOwSOlk6JfaCc4OZ++XtwMA8=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AS8PR03MB7063.eurprd03.prod.outlook.com (2603:10a6:20b:293::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 15:03:44 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::8fbf:de56:f9fd:ccba]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::8fbf:de56:f9fd:ccba%6]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 15:03:44 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v3] net: dsa: realtek: rtl8365mb: add change_mtu
Thread-Topic: [PATCH net-next v3] net: dsa: realtek: rtl8365mb: add change_mtu
Thread-Index: AQHZQ+5jKI3PC9pkWkWWSYkXk7b6aq7cqDMA
Date:   Thu, 23 Feb 2023 15:03:44 +0000
Message-ID: <20230223150348.z3ufj5qqw6qv4s2m@bang-olufsen.dk>
References: <20230218230636.5528-1-luizluca@gmail.com>
In-Reply-To: <20230218230636.5528-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|AS8PR03MB7063:EE_
x-ms-office365-filtering-correlation-id: 124c8f2b-e54a-46b4-0aa8-08db15af2861
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TGxMCIr/SjnOIe/StzVa2R4int1O/h2yWb+b2uzVpFFBxhv77EdNoEW/KZgPSp+sqQnOcoeL5vkJDbH/vrRYBFKztfIbjlg5+pjfa33Gw/hKvxfnEteDFY3y80QXiAzG9rtHbcOEM22qbjTbJ5DP9aIUbwLlgKqBSefxLHSfuvd57Tp5pmPNyroABRwkkO2UP3WHctg89g4d+qetopf9cMDcKbSTMhU2/dpZNlh8qKIaxDUL3AMQlNiEZxDuxFg7v+/qGi/sX6lsioS4ZHfHyH4c1UNSF5Nv/3h0CyZHpoaRAUo8WDea1kPoI+kIaLzITuqciY1L86XGMzsaM2WM5QPqmBdU1zEIuR/13tPOybta9OJtWybTxWkIeRfd7mFza6R3ppTSlHP7/kPTnwAVzDv6n5YG1pg/3wphp6Hjp8g1d2gSf+ziCgbqxKK1yHLsa1CAe0z/TH64U6LAQoaUWgIHe5grWRErtxUK5t853Q46LWQ2PxH0/BNl80+n0Wl/DZygPWj7nA8CI//iJohi4J4Kx4cH0eqwPThlYcA6ufYKuvf3KdSZOqsvhrrqoEmDrp2Nhy273Py8Zrwebdo2t7pHfrQo3lF9Hcm6A8dCeae/TDL1hQvYdnB60k2dI6nJTVyfpwVHwo+o02Pb4jwcneYEGYKjPo9WaHUvx2UWyJL6OgqQc7ceDpKTbSmBNQPMW2mnCI6HY5YLvUJrDmLH3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199018)(2906002)(7416002)(5660300002)(8936002)(8976002)(41300700001)(76116006)(85202003)(66446008)(83380400001)(66946007)(66476007)(66556008)(8676002)(4326008)(91956017)(6916009)(316002)(36756003)(85182001)(478600001)(6486002)(26005)(186003)(71200400001)(6506007)(1076003)(2616005)(38100700002)(64756008)(66574015)(86362001)(122000001)(54906003)(6512007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3ZHWmJRYUVZbVd3K0pjR0ExdzBCZlVWU0NOeUFIL0QybUd2UHBOUlh0TjJH?=
 =?utf-8?B?VmZEVTZlS3p5dzdKeXM2eVAxVkFocDR2cGxZWWx4MTY5aFF5Skw2NnJXeGV1?=
 =?utf-8?B?ZCs1TWdNRTdEL1J4YjVTd2dxR2hkeXE2YzFnYWJTNGEycFNNOFVtamh4TjlP?=
 =?utf-8?B?QTBvb0FVQWdHcFI3Vi9NV2d2dlRWM2lpZ1VEMUZic0RuVkxXUVdUemE1bzQ2?=
 =?utf-8?B?TGNVQTNTRFNtZDkrNnZpMWxtMFgzR2QyS1JwaHlSd0FnOWxrVDNwMVFxbm1U?=
 =?utf-8?B?c0p2UlpSNlF4d0RVSm1OaHBCZFJZSGlTeWlVQjBrbWl5WURwWTYyTndDV29L?=
 =?utf-8?B?SmFBRUR6R3hDOFp4R1gzeWJZSVBEcFg5dDR3UU1TTmJBQ3JHUGlHYUJVckxE?=
 =?utf-8?B?dy9GSFNWMC9NTHBwWnJIbUhzMzNsZTB5bnFWZkpUdUdIOG1yUUFad0dlb29T?=
 =?utf-8?B?cjJhSWlhTHM4endXUTRpN2dlbnB1VDVTejVwOHFSNnpXZVJRQ0JkTkFGWVB6?=
 =?utf-8?B?U0lNd3k4QUo3N08wbTEwK0RrZG0vS1NseFc5cXZPK1RqYVJlcmxBRHh4a1Vj?=
 =?utf-8?B?SEhYZFEwTDZwRDFvb3dpMUtjc0EwMU1wZjVYT21xVlRGSElnclhxVEZ4bDJZ?=
 =?utf-8?B?Q29PS0ZOVTdJaG00Wk50SEtybnlRTi9TSlE3dHorTUVKaE02aWVBNEt2eGo3?=
 =?utf-8?B?Z1FWclJ3czF3aWd1SmlLa1JXZlVRK2lrcjVYWSsxdGZRWkViZ3p0YWJ5R1VE?=
 =?utf-8?B?T3ZKUlQxNkRHTDkyZmo5c1liNHAwcHVLSkE5NDRoREovTWtEMUoyWTJqTVJa?=
 =?utf-8?B?N01VWDNWaU9PNmhHYjVGOXdIWVQ3Q2Iwam00U0d1cGlNNlpVZVRyRWpXMERv?=
 =?utf-8?B?U0Z2TEVBQklldUp0ZytSa3RLcmJzS3VWTzlyWG92TXk2aEczZUNsaXc1RW5v?=
 =?utf-8?B?a3FwSzJ2NWtvblhZaEFsM1FHbDRRTHkvWlJBUlZCaUhGTW9Cc0x1TDRNVG90?=
 =?utf-8?B?ZW8rdEU2VlZRVGtiNzl3eXgrak9kTHpzU1RqNEg1UW5DRFVuSnVnRUhGYUxn?=
 =?utf-8?B?eG9vM1Z1eENHQWp4Z3M5dkVFTTV5d2hzWm1FTENLdFZNc1dCQnNscW13VU1I?=
 =?utf-8?B?cHZwMVhwQlhSYkx2aUlTd0paTjdST1lTUzlUdjgyYXNQUFJhQndaeTljS0Za?=
 =?utf-8?B?cWx2VVJKSzRNRFdGV0gra1grbWp2YWNMbTNaMjZhUkcvNGdtcTRxaEV6ay9k?=
 =?utf-8?B?eVNFN08xc0VjQ0psOFVnNGcrYisycEs0dmdWMEFMc2ZZZ0VxVDlrUGovZWdP?=
 =?utf-8?B?bmh2ZzA5dlREUnZmTlpJZzlPM0JWWnJud01rMHlHWTVuK1BoRzdacHRmRFVa?=
 =?utf-8?B?dEdOSTIwMmJ0am16U0Y4WTd6azNTZ3NFTlRubEtGZ2VVZVVYR1l1UDBta3ow?=
 =?utf-8?B?YWcxOWdjWGdCWnYrWkpaTzVaQk1KYTBJdFEyUytaS0tyT0QwOXBnTDhoTmJk?=
 =?utf-8?B?Qk1tSUlBd1BxRW5aUzdYS2NXN0VrQ3ZzVDNNSVVmWEp2UUdvWkN2Y0lyZWRm?=
 =?utf-8?B?NytscE1UQk9SdXBXdFk1TmloRjZ0YnNDQklCSkZYTFZHRmYrZmVxOHdNbDhp?=
 =?utf-8?B?ZHp5eWNnTTBpamxpRTl2d1E5dkdmU0ZNRkNHZkkyYklMdlMreWNYMUZyanly?=
 =?utf-8?B?emp1VDdlMzZRdGxSQjBXeXE4OVZyRWtKSnBleEtYRGtUYS81TlpQWis0UWtK?=
 =?utf-8?B?OFZGS1UrcU12dmNLL2tScXBPSWFXUHNSRDllNThpQThBVUtodDZEUFdVN2R2?=
 =?utf-8?B?TjYrQ1hscXIweGxFK2NCL1dJeTJnSXJWeGtBNFZaZllOQk1obXRnRStEU1Na?=
 =?utf-8?B?OGZFUmUySlhSOWNHQnpzWFEwU2l6Rm1nZkhUK1RoSDVLcnZESXdBb0ZQZlJ4?=
 =?utf-8?B?aHl3RXNiOE5IKzBHT0VqNUJpWjhkZFdSZnZqdE00Qm5VY2prbDB3LytZUGRR?=
 =?utf-8?B?ei9mZ3lZVUdhenRUM2lrdGRqMGRZd2JSdVd2NmdPUmlGNGcwNERoNk5PTEMv?=
 =?utf-8?B?WWNzamkrQXFwL2pYNmNuOXhva1RCa1ZFeDBCd0h1UEVVMEFxMDkyRGliNzRL?=
 =?utf-8?B?RElqcm1QQU52OWlZaUxTbHZ2eHEwTGhsdm5jSlR3SC9Lb1R5a3V5K0UzcnZI?=
 =?utf-8?B?Smc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <912FDC8B459958409684882A6495E245@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 124c8f2b-e54a-46b4-0aa8-08db15af2861
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 15:03:44.3809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 31wa9pyDYtVIvBd+YOJaAxw1ahwh4aC5ilopujDkvMVn7gMRr0l5hrWqdPB37KiIsXlDX3G1Vm4CR1a10NURvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7063
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCBGZWIgMTgsIDIwMjMgYXQgMDg6MDY6MzdQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gVGhlIHJ0bDgzNjVtYiB3YXMgdXNpbmcgYSBmaXhlZCBNVFUg
c2l6ZSBvZiAxNTM2LCB3aGljaCB3YXMgcHJvYmFibHkNCj4gaW5zcGlyZWQgYnkgdGhlIHJ0bDgz
NjZyYidzIGluaXRpYWwgcGFja2V0IHNpemUuIEhvd2V2ZXIsIHVubGlrZSB0aGF0DQo+IGZhbWls
eSwgdGhlIHJ0bDgzNjVtYiBmYW1pbHkgY2FuIHNwZWNpZnkgdGhlIG1heCBwYWNrZXQgc2l6ZSBp
biBieXRlcywNCj4gcmF0aGVyIHRoYW4gaW4gZml4ZWQgc3RlcHMuIFRoZSBtYXggcGFja2V0IHNp
emUgbm93IGRlZmF1bHRzIHRvDQo+IFZMQU5fRVRIX0hMRU4rRVRIX0RBVEFfTEVOK0VUSF9GQ1Nf
TEVOLCB3aGljaCBpcyAxNTIyIGJ5dGVzLg0KPiANCj4gRFNBIGNhbGxzIGNoYW5nZV9tdHUgZm9y
IHRoZSBDUFUgcG9ydCBvbmNlIHRoZSBtYXggTVRVIHZhbHVlIGFtb25nIHRoZQ0KPiBwb3J0cyBj
aGFuZ2VzLiBBcyB0aGUgbWF4IHBhY2tldCBzaXplIGlzIGRlZmluZWQgZ2xvYmFsbHksIHRoZSBz
d2l0Y2gNCj4gaXMgY29uZmlndXJlZCBvbmx5IHdoZW4gdGhlIGNhbGwgYWZmZWN0cyB0aGUgQ1BV
IHBvcnQuDQo+IA0KPiBUaGUgYXZhaWxhYmxlIHNwZWNpZmljYXRpb25zIGRvIG5vdCBkaXJlY3Rs
eSBkZWZpbmUgdGhlIG1heCBzdXBwb3J0ZWQNCj4gcGFja2V0IHNpemUsIGJ1dCBpdCBtZW50aW9u
cyBhIDE2ayBsaW1pdC4gVGhpcyBkcml2ZXIgd2lsbCB1c2UgdGhlIDB4M0ZGRg0KPiBsaW1pdCBh
cyBpdCBpcyB1c2VkIGluIHRoZSB2ZW5kb3IgQVBJIGNvZGUuIEhvd2V2ZXIsIHRoZSBzd2l0Y2gg
c2V0cyB0aGUNCj4gbWF4IHBhY2tldCBzaXplIHRvIDE2MzY4IGJ5dGVzICgweDNGRjApIGFmdGVy
IGl0IHJlc2V0cy4NCj4gDQo+IGNoYW5nZV9tdHUgdXNlcyBNVFUgc2l6ZSwgb3IgZXRoZXJuZXQg
cGF5bG9hZCBzaXplLCB3aGlsZSB0aGUgc3dpdGNoDQo+IHdvcmtzIHdpdGggZnJhbWUgc2l6ZS4g
VGhlIGZyYW1lIHNpemUgaXMgY2FsY3VsYXRlZCBjb25zaWRlcmluZyB0aGUNCj4gZXRoZXJuZXQg
aGVhZGVyICgxNCBieXRlcyksIGEgcG9zc2libGUgODAyLjFRIHRhZyAoNCBieXRlcyksIHRoZSBw
YXlsb2FkDQo+IHNpemUgKE1UVSksIGFuZCB0aGUgRXRoZXJuZXQgRkNTICg0IGJ5dGVzKS4gVGhl
IENQVSB0YWcgKDggYnl0ZXMpIGlzDQo+IGNvbnN1bWVkIGJlZm9yZSB0aGUgc3dpdGNoIGVuZm9y
Y2VzIHRoZSBsaW1pdC4NCj4gDQo+IE1UVSB3YXMgdGVzdGVkIHVwIHRvIDIwMTggKHdpdGggODAy
LjFRKSBhcyB0aGF0IGlzIGFzIGZhciBhcyBtdDc2MjANCj4gKHdoZXJlIHJ0bDgzNjdzIGlzIHN0
YWNrZWQpIGNhbiBnby4gVGhlIHJlZ2lzdGVyIHdhcyBtYW51YWxseQ0KPiBtYW5pcHVsYXRlZCBi
eXRlLWJ5LWJ5dGUgdG8gZW5zdXJlIHRoZSBNVFUgdG8gZnJhbWUgc2l6ZSBjb252ZXJzaW9uIHdh
cw0KPiBjb3JyZWN0LiBGb3IgZnJhbWVzIHdpdGhvdXQgODAyLjFRIHRhZywgdGhlIGZyYW1lIHNp
emUgbGltaXQgd2lsbCBiZSA0DQo+IGJ5dGVzIG92ZXIgdGhlIHJlcXVpcmVkIHNpemUuDQo+IA0K
PiBUaGVyZSBpcyBhIGp1bWJvIHJlZ2lzdGVyLCBlbmFibGVkIGJ5IGRlZmF1bHQgYXQgNmsgcGFj
a2V0IHNpemUuDQo+IEhvd2V2ZXIsIHRoZSBqdW1ibyBzZXR0aW5ncyBkbyBub3Qgc2VlbSB0byBs
aW1pdCBub3IgZXhwYW5kIHRoZSBtYXhpbXVtDQo+IHRlc3RlZCBNVFUgKDIwMTgpLCBldmVuIHdo
ZW4ganVtYm8gaXMgZGlzYWJsZWQuIE1vcmUgdGVzdHMgYXJlIG5lZWRlZA0KPiB3aXRoIGEgZGV2
aWNlIHRoYXQgY2FuIGhhbmRsZSBsYXJnZXIgZnJhbWVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPiAtLS0NCj4g
DQo+IHYyLT52MzoNCj4gLSBjaGFuZ2VkIG1heCBmcmFtZSBzaXplIHRvIDB4M0ZGRiAodXNlZCBi
eSB2ZW5kb3IgQVBJKQ0KPiAtIGFkZGVkIGluZm8gYWJvdXQgaG93IGZyYW1lIHNpemUgaXMgY2Fs
Y3VsYXRlZCwgc29tZSBtb3JlIGRlc2NyaXB0aW9uDQo+ICAgYWJvdXQgdGhlIHRlc3RzIHBlcmZv
cm1lZCBhbmQgdGhlIDQgZXh0cmEgYnl0ZXMgd2hlbiB1bnRhZ2dlZCBmcmFtZSBpcw0KPiAgIHVz
ZWQuDQo+IA0KPiB2MS0+djI6DQo+IC0gZHJvcHBlZCBqdW1ibyBjb2RlIGFzIGl0IHdhcyBub3Qg
Y2hhbmdpbmcgdGhlIGJlaGF2aW9yICh1cCB0byAyayBNVFUpDQo+IC0gZml4ZWQgdHlwb3MNCj4g
LSBmaXhlZCBjb2RlIGFsaWdubWVudA0KPiAtIHJlbmFtZWQgcnRsODM2NW1iXyhjaGFuZ2V8bWF4
KV9tdHUgdG8gcnRsODM2NW1iX3BvcnRfKGNoYW5nZXxtYXgpX210dQ0KPiANCj4gIGRyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgNDEgKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzNyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5j
IGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMNCj4gaW5kZXggZGEzMWQ4Yjgz
OWFjLi4wNTY0MmM2MTdjM2IgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVr
L3J0bDgzNjVtYi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5j
DQo+IEBAIC05OCw2ICs5OCw3IEBADQo+ICAjaW5jbHVkZSA8bGludXgvb2ZfaXJxLmg+DQo+ICAj
aW5jbHVkZSA8bGludXgvcmVnbWFwLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvaWZfYnJpZGdlLmg+
DQo+ICsjaW5jbHVkZSA8bGludXgvaWZfdmxhbi5oPg0KPiAgDQo+ICAjaW5jbHVkZSAicmVhbHRl
ay5oIg0KPiAgDQo+IEBAIC0yNjcsNiArMjY4LDcgQEANCj4gIC8qIE1heGltdW0gcGFja2V0IGxl
bmd0aCByZWdpc3RlciAqLw0KPiAgI2RlZmluZSBSVEw4MzY1TUJfQ0ZHMF9NQVhfTEVOX1JFRwkw
eDA4OEMNCj4gICNkZWZpbmUgICBSVEw4MzY1TUJfQ0ZHMF9NQVhfTEVOX01BU0sJMHgzRkZGDQo+
ICsjZGVmaW5lIFJUTDgzNjVNQl9DRkcwX01BWF9MRU5fTUFYCTB4M0ZGRg0KPiAgDQo+ICAvKiBQ
b3J0IGxlYXJuaW5nIGxpbWl0IHJlZ2lzdGVycyAqLw0KPiAgI2RlZmluZSBSVEw4MzY1TUJfTFVU
X1BPUlRfTEVBUk5fTElNSVRfQkFTRQkJMHgwQTIwDQo+IEBAIC0xMTM1LDYgKzExMzcsMzYgQEAg
c3RhdGljIHZvaWQgcnRsODM2NW1iX3BoeWxpbmtfbWFjX2xpbmtfdXAoc3RydWN0IGRzYV9zd2l0
Y2ggKmRzLCBpbnQgcG9ydCwNCj4gIAl9DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbnQgcnRsODM2
NW1iX3BvcnRfY2hhbmdlX210dShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiAr
CQkJCSAgICAgaW50IG5ld19tdHUpDQo+ICt7DQo+ICsJc3RydWN0IHJlYWx0ZWtfcHJpdiAqcHJp
diA9IGRzLT5wcml2Ow0KPiArCWludCBmcmFtZV9zaXplOw0KPiArDQo+ICsJLyogV2hlbiBhIG5l
dyBNVFUgaXMgc2V0LCBEU0EgYWx3YXlzIHNldHMgdGhlIENQVSBwb3J0J3MgTVRVIHRvIHRoZQ0K
PiArCSAqIGxhcmdlc3QgTVRVIG9mIHRoZSBzbGF2ZSBwb3J0cy4gQmVjYXVzZSB0aGUgc3dpdGNo
IG9ubHkgaGFzIGEgZ2xvYmFsDQo+ICsJICogUlggbGVuZ3RoIHJlZ2lzdGVyLCBvbmx5IGFsbG93
aW5nIENQVSBwb3J0IGhlcmUgaXMgZW5vdWdoLg0KPiArCSAqLw0KPiArDQoNCllvdSBmb3Jnb3Qg
dG8gcmVtb3ZlIHRoaXMgc3B1cmlvdXMgbmV3bGluZS4NCg0KV2l0aCB0aGF0IGZpeGVkIHlvdSBj
YW4gYWRkOg0KDQpSZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2Vu
LmRrPg0KDQpUaGFua3MhDQoNCj4gKwlpZiAoIWRzYV9pc19jcHVfcG9ydChkcywgcG9ydCkpDQo+
ICsJCXJldHVybiAwOw0KPiArDQo+ICsJZnJhbWVfc2l6ZSA9IG5ld19tdHUgKyBWTEFOX0VUSF9I
TEVOICsgRVRIX0ZDU19MRU47DQo+ICsNCj4gKwlkZXZfZGJnKHByaXYtPmRldiwgImNoYW5naW5n
IG10dSB0byAlZCAoZnJhbWUgc2l6ZTogJWQpXG4iLA0KPiArCQluZXdfbXR1LCBmcmFtZV9zaXpl
KTsNCj4gKw0KPiArCXJldHVybiByZWdtYXBfdXBkYXRlX2JpdHMocHJpdi0+bWFwLCBSVEw4MzY1
TUJfQ0ZHMF9NQVhfTEVOX1JFRywNCj4gKwkJCQkgIFJUTDgzNjVNQl9DRkcwX01BWF9MRU5fTUFT
SywNCj4gKwkJCQkgIEZJRUxEX1BSRVAoUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9NQVNLLA0KPiAr
CQkJCQkgICAgIGZyYW1lX3NpemUpKTsNCj4gK30NCj4gKw0KPiArc3RhdGljIGludCBydGw4MzY1
bWJfcG9ydF9tYXhfbXR1KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQpDQo+ICt7DQo+
ICsJcmV0dXJuIFJUTDgzNjVNQl9DRkcwX01BWF9MRU5fTUFYIC0gVkxBTl9FVEhfSExFTiAtIEVU
SF9GQ1NfTEVOOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgdm9pZCBydGw4MzY1bWJfcG9ydF9zdHBf
c3RhdGVfc2V0KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ICAJCQkJCSB1OCBz
dGF0ZSkNCj4gIHsNCj4gQEAgLTE5ODAsMTAgKzIwMTIsNyBAQCBzdGF0aWMgaW50IHJ0bDgzNjVt
Yl9zZXR1cChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMpDQo+ICAJCXAtPmluZGV4ID0gaTsNCj4gIAl9
DQo+ICANCj4gLQkvKiBTZXQgbWF4aW11bSBwYWNrZXQgbGVuZ3RoIHRvIDE1MzYgYnl0ZXMgKi8N
Cj4gLQlyZXQgPSByZWdtYXBfdXBkYXRlX2JpdHMocHJpdi0+bWFwLCBSVEw4MzY1TUJfQ0ZHMF9N
QVhfTEVOX1JFRywNCj4gLQkJCQkgUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9NQVNLLA0KPiAtCQkJ
CSBGSUVMRF9QUkVQKFJUTDgzNjVNQl9DRkcwX01BWF9MRU5fTUFTSywgMTUzNikpOw0KPiArCXJl
dCA9IHJ0bDgzNjVtYl9wb3J0X2NoYW5nZV9tdHUoZHMsIGNwdS0+dHJhcF9wb3J0LCBFVEhfREFU
QV9MRU4pOw0KPiAgCWlmIChyZXQpDQo+ICAJCWdvdG8gb3V0X3RlYXJkb3duX2lycTsNCj4gIA0K
PiBAQCAtMjEwMyw2ICsyMTMyLDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBkc2Ffc3dpdGNoX29w
cyBydGw4MzY1bWJfc3dpdGNoX29wc19zbWkgPSB7DQo+ICAJLmdldF9ldGhfbWFjX3N0YXRzID0g
cnRsODM2NW1iX2dldF9tYWNfc3RhdHMsDQo+ICAJLmdldF9ldGhfY3RybF9zdGF0cyA9IHJ0bDgz
NjVtYl9nZXRfY3RybF9zdGF0cywNCj4gIAkuZ2V0X3N0YXRzNjQgPSBydGw4MzY1bWJfZ2V0X3N0
YXRzNjQsDQo+ICsJLnBvcnRfY2hhbmdlX210dSA9IHJ0bDgzNjVtYl9wb3J0X2NoYW5nZV9tdHUs
DQo+ICsJLnBvcnRfbWF4X210dSA9IHJ0bDgzNjVtYl9wb3J0X21heF9tdHUsDQo+ICB9Ow0KPiAg
DQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGRzYV9zd2l0Y2hfb3BzIHJ0bDgzNjVtYl9zd2l0Y2hf
b3BzX21kaW8gPSB7DQo+IEBAIC0yMTI0LDYgKzIxNTUsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IGRzYV9zd2l0Y2hfb3BzIHJ0bDgzNjVtYl9zd2l0Y2hfb3BzX21kaW8gPSB7DQo+ICAJLmdldF9l
dGhfbWFjX3N0YXRzID0gcnRsODM2NW1iX2dldF9tYWNfc3RhdHMsDQo+ICAJLmdldF9ldGhfY3Ry
bF9zdGF0cyA9IHJ0bDgzNjVtYl9nZXRfY3RybF9zdGF0cywNCj4gIAkuZ2V0X3N0YXRzNjQgPSBy
dGw4MzY1bWJfZ2V0X3N0YXRzNjQsDQo+ICsJLnBvcnRfY2hhbmdlX210dSA9IHJ0bDgzNjVtYl9w
b3J0X2NoYW5nZV9tdHUsDQo+ICsJLnBvcnRfbWF4X210dSA9IHJ0bDgzNjVtYl9wb3J0X21heF9t
dHUsDQo+ICB9Ow0KPiAgDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IHJlYWx0ZWtfb3BzIHJ0bDgz
NjVtYl9vcHMgPSB7DQo+IC0tIA0KPiAyLjM5LjENCj4=
