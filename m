Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE3C3F3FB5
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhHVOUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:20:30 -0400
Received: from mail-am6eur05on2135.outbound.protection.outlook.com ([40.107.22.135]:20448
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232043AbhHVOU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 10:20:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOTJHtxiAFR6hbgvVU4NR7tkZ+c/cjm8fOkXlxGwVdLV59gAkIOOUYAPVY2nS/ll7yRlrDov5nwP7x+WGmE564CMCqD6toQBE9mc2gjIkeXn6HZ+6m0JDOcUAPXP7vGjHAEvPhovmIwYq4KoHFywfRL7/dAZJzPcuQcZ/8F7De6IuRnPooFZjUqFtmwJTVyBYO3wCGMqs2Czi0qxBh3Ou/LW42UmEDtHRU3/VNjEr7mNkq/nZYJRkfm9UfTlrhhSQ0L9iz7BGZafPXkqwo6jsqbezX0hH/SysMcajJ0BOktEhzlEPD9j1w7yX+hmOt1+xQqFVqVkQTuo/A5kd9uwyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJ8Lt6bWdtBPhQ3QogxI/WH/Nq18zJlFUvLgy5f6hys=;
 b=QqR+AutX8pSgk41s2w/U5ftzo/IyW0xcrhcAz9m8HNCHouxQN+Xb4zoCw4wFraPrMT5gi6k9OlrWRuKgUjUyHW+/rkkdkDs3dFJ+OYUa64/78WEZj6spybyJc5umkEz2dEuzRmNeZz3Fer5qpGrwQ7pmRN0HP7+nlX8Z5Ho4BxGYkwpBMBikHVQNhyRmwe9lLY3NQ0z31jaBdCQN3wvm60wwl947jzzP0GT1MHJLCCBFG4aYWdXZApVE3uORv9Tw2425pL+zqJ/JQ2EzpffT+AOvXtinxnH4j2K+vhX+7MxWiHcZHlizzl33xLe6vHWMo9Z/sLpH1xhcIgVBUMTkDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJ8Lt6bWdtBPhQ3QogxI/WH/Nq18zJlFUvLgy5f6hys=;
 b=eAKOowA6IU0AxZQ+1XojPaEF79zv9pyzva2AXuBlzyVyWQlUfRC5P8BRaXJuNWit3392xl3VGuScWtXlwxF0jj6RpTt+sWYX2D+IkGLTv0iasriPoFtd7q8Z9z5mnOyOCtGQUC52tkmUQWMF2eslWZb/oaJDozYcc8FThPQ2my0=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2667.eurprd03.prod.outlook.com (2603:10a6:3:ee::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Sun, 22 Aug 2021 14:19:45 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Sun, 22 Aug 2021
 14:19:44 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Saravana Kannan <saravanak@google.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Thread-Topic: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Thread-Index: AQHXk3edAldLqW55BEm1kFydkTRTGqt4NdyAgAASUYCAAEdPAIAAfkAAgAEf9ACAAKtuAIAAv5oAgAEH2ACAAvoCAA==
Date:   Sun, 22 Aug 2021 14:19:44 +0000
Message-ID: <14891624-655b-a71d-dc04-24404e0c2e1a@bang-olufsen.dk>
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk>
 <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <875f7448-8402-0c93-2a90-e1d83bb7586a@bang-olufsen.dk>
 <CAGETcx_M5pEtpYhuc-Fx6HvC_9KzZnPMYUH_YjcBb4pmq8-ghA@mail.gmail.com>
 <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com>
In-Reply-To: <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01458672-c791-4c44-8ff5-08d96577e3e4
x-ms-traffictypediagnostic: HE1PR0302MB2667:
x-microsoft-antispam-prvs: <HE1PR0302MB2667850117407D347BB93C4D83C39@HE1PR0302MB2667.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QvF4YymIRvh38dRS6wlzLEjLDDTJ8tEofvrVmNIrxzXoUk66sFFnaRLMqrPENEj/O7vdGFpuM4O9jwlUcJj7mVZEIrLGQt8fmTLKZhCzBeV/dJOPcw7XrZqT7Um3VfxTJaFI2v3CFBWl4QVFSIp+Y368GRdssfhwBGpXfS/gCJyDcGKt9H8SWF+vsfpGDl99Fp6gUmDm2pjHSJaXqwcDwdEpGimksB+/bhCtxVlw86ushiAvy24nvaRPI2BZr5rQB5AcAzMUjTBOwxf9aXUp8V7KvMMYMt8+jgEdPet2QrFQrkj6zG/emKCHPuaN7ELlk1YWbjhEzEZAGdAFPm6cy9H73eg5Lj1rag0Otiq9Aymc79Hy+nVDjKWvuXRIaH15Xtb6+A826Gi2j77u/kbYwe+Gie0jtMeRlbmxTiaNVTtqwpqv6Z90U1m8iwnTVJVVmdVEOzYl4C/KqH56F8NU8vrRAbkTeXILblGq8jWY0jKXHT6LIWO3WD5eJgrtD2E4rtmos5EEZtkRcB5+z/Lv0uykS3ZRjajwcrGstcQpfPjV6IH4CO7CeywuPzEF1jym5UhHD9A7w5aH4AIo9VcFQ1G/DrjD1tIKEbX3M8ladhAZUtX9HakRQq8B/mlNB5DSpzRNHYPfSGFYeMpvd01Z4Rq1ecBPX5WQU3VljEr3FNygN6aquMIlHsJdR2pjaV8eoxztRjtg125ffPLMMtipii5ohvo2w43WYxZHdoKQi1n8TmFb7mrmISdjVOFTgm2mITRnBJ7b6hkCgcbxxZjoLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(366004)(39840400004)(122000001)(38100700002)(31696002)(66446008)(8936002)(66476007)(86362001)(66556008)(38070700005)(66946007)(76116006)(64756008)(6512007)(6916009)(36756003)(83380400001)(2616005)(6486002)(5660300002)(186003)(8676002)(6506007)(478600001)(53546011)(8976002)(316002)(4326008)(7416002)(85182001)(26005)(31686004)(2906002)(54906003)(71200400001)(85202003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGdiSFJrU05wbE5XN3JGWXk5M3FDR1k1dXh3RWhGSEx3MXhFbmdOUlEzRlVu?=
 =?utf-8?B?MkZ2MWlUWWF4OW5MUGFxMGMzTEUrYlJxVTdXeEovQlo3V3R1ZjRrbldyVFk1?=
 =?utf-8?B?UTFZUUdwK2FTVXJiaU1KTHVJRmxxbmRGa3VtOW16cUVjLytyVkVQNTZtV1B2?=
 =?utf-8?B?aGxEVGpHRXlKUmk5OHIxRFEvb25ibEV1MDZmNkdsU1ByRE0xN1JJREVkbFM1?=
 =?utf-8?B?QTJhNUcxS2I5TVlUVUxYeTMrQ0hackxHckxOU0k2b2Q1c0hldVYyMmNyZGhX?=
 =?utf-8?B?eGk0NG1OQ3RqdUVyclFCNUcwZll5YlRQdTlQOUtmMFhCbUpEdmhkUG1JZm9a?=
 =?utf-8?B?SDE5a05JTkFDYTlmRzRPbERQdGtWZkwyMmQ0YysrNzVHamtCRXhEWHVZTlhL?=
 =?utf-8?B?SUtVeFRXbGpxM0ppNGpTUENkUnNoZjRGbmhoR25tYVU4UkVWY2w2S3NoUUJY?=
 =?utf-8?B?c1Qxc2pPNnZ3QTZodVNsTHVDVnhveDUxN1hOU3FMRXFwUWNYNGNDdHVMNjJR?=
 =?utf-8?B?RkJaN3J3bDl4YUhrU2p2V01aTkNoRE1YVWFZamJrYXh5TmNwTEZaVk42Sjdr?=
 =?utf-8?B?L1UrWExLN0IyUStQd2V2dGg5WHlxZUhqbVRxdC9EWk5McGROSTBYazJWUHli?=
 =?utf-8?B?VTlXTHFPb1ZtM085TlRHWnpHMTBwaHIwSVB6U1lRVm4raG1TeTEvTDBCRnpE?=
 =?utf-8?B?TUY4ZzlIMjV2Zzhienk4aWVNVFo4clRHUVNseDM5U0hXNE9YRDZlRVdKOVRB?=
 =?utf-8?B?MHd2Rk5JcUQrNUFkQmI3Y05pUExXNjBWVW1mcERBS2VSOE9DOTdySlhoZWpJ?=
 =?utf-8?B?eEJlaEUyTGpuTWs1V3dMTFp4dThIVk5hbEMvS3pLVUZjbGRHWExjNFBjVVpX?=
 =?utf-8?B?cW9pVHd4NFhFT3ByQ21QUEp3NG02YTlpbFJ1UFV3L2MwbjQ0dmJneUFjMG4y?=
 =?utf-8?B?VU81VW10RUZvV1lMdFNVZWlMaWQ3YjczempUUmZwT1JYUVpkMFpuM096S0RZ?=
 =?utf-8?B?Y0hIY0JLZ05QWWYrTFlMazBVS1pUTzdGdzhaNFQxM3V3UWhvajNuRkllMVpn?=
 =?utf-8?B?d2xhK1ovYzZzYmZwSG1rUlM3ZklmeXJYUWFJY2tqVWZhcjB1Q0dvZTJaemFB?=
 =?utf-8?B?akx1Nm5Ndys4R1Z5SDF1Sk1VaHhlMUJYR0FkUVFNQ1ZKUE1ZbW56VVFzWWVj?=
 =?utf-8?B?ZDVCVXhwYnpvNFhRSVd2eXk0UUVGRVZBeWZjVzlPOWgyaEZicnVOWnZKRURi?=
 =?utf-8?B?VEE3dFZkQmlsa3FNQmxsQ1JianNyUHZ3Y0xDS3RidnRXSmNaaVM0aVNWUUVy?=
 =?utf-8?B?SVZNZGI3K0hUblhXajVEanhDdkFTeFVZbThycG4wdjdscy9pbVcvQ3lXV1dH?=
 =?utf-8?B?d0w2UnMzbzJnYmUyK2hxSTlJM3JDY0M5Z0R0MVZ3dE1icnVjaEQ5b2NYSnV4?=
 =?utf-8?B?aDB2akZkbzlYdVNOOW8vY3Q0MlZNK2lnai80ZTU3ZHBRaE85NmZRRlg1eTlY?=
 =?utf-8?B?eVhCMU93aE96cC8zclBqalNnV1EyaW9nMTY2TFdNZnVIcGI3NXpiMkNKbXlN?=
 =?utf-8?B?N1FSYzIxTkF4Qm1HZEU4WUNoRUNhNjJBdGYzQjBkWjRkUnRYNGhWYkIreStx?=
 =?utf-8?B?VzJzUkVRZnY2ZTNhLzJTOWJjamhESHRaMHhLUHM0UitZeHI2V3ZuZEJxeTZG?=
 =?utf-8?B?Vm42SktGVXR0dHlwdzM3U2NRSDVQZlgvV0tZY3hrcnVHdEJ2cGdJZTlQbjQw?=
 =?utf-8?B?K251NTVVbzlQN0dQQXFPMzd4SzMzTzRSd3VoVUhZWHhpaDBNTytsaGYvbFgz?=
 =?utf-8?B?K0RibW95TXBCQ3Vobk9WZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A95FAE790588E045B11E6E63A469731B@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01458672-c791-4c44-8ff5-08d96577e3e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2021 14:19:44.7057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ssVeyBJc6sy3V8NZ14vX53o3wzK5m1v/y+hXsr/NqJP01gNPdV33orVX09Xvjv7Z0Jo+P06vzGqXDYf/zTBhOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2667
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FyYXZhbmEsDQoNClRoYW5rcyBmb3IgdGhlIGZvbGxvdy11cC4gSSB0ZXN0ZWQgeW91ciBj
aGFuZ2UgYW5kIGl0IGRvZXMgdGhlIHRyaWNrOiANCnRoZXJlIGlzIG5vIGRlZmVycmFsIGFuZCB0
aGUgUEhZIGRyaXZlciBnZXRzIHByb2JlZCBmaXJzdC10cnkgZHVyaW5nIHRoZSANCm1kaW9idXMg
cmVnaXN0cmF0aW9uIGR1cmluZyB0aGUgY2FsbCB0byBkc2FfcmVnaXN0ZXJfc3dpdGNoKCkuIEkg
dGVzdGVkIA0Kd2l0aCB0aGUgc3dpdGNoLCBQSFksIGFuZCB0YWdnaW5nIGRyaXZlcnMgYWxsIGJ1
aWx0aW4sIG9yIGFsbCBtb2R1bGVzLCANCmFuZCBpdCB3b3JrZWQgaW4gYm90aCBjYXNlcy4NCg0K
T24gOC8yMC8yMSA2OjUyIFBNLCBTYXJhdmFuYSBLYW5uYW4gd3JvdGU6DQo+IEhpIEFsdmluLA0K
PiANCj4gQ2FuIHlvdSBnaXZlIHRoaXMgYSBzaG90IHRvIHNlZSBpZiBpdCBmaXhlcyB5b3VyIGlz
c3VlPyBJdCBiYXNpY2FsbHkNCj4gZGVsYXlzIHRoZSByZWdpc3RyYXRpb24gb2YgZHNhX3JlZ2lz
dGVyX3N3aXRjaCgpIHVudGlsIGFsbCB0aGUNCj4gY29uc3VtZXJzIG9mIHRoaXMgc3dpdGNoIGhh
dmUgcHJvYmVkLiBTbyBpdCBoYXMgYSBjb3VwbGUgb2YgY2F2ZWF0czoNCg0KSG0sIHdlcmVuJ3Qg
dGhlIG9ubHkgY29uc3VtZXJzIHRoZSBQSFlzIHRoZW1zZWx2ZXM/IEl0IHNlZW1zIGxpa2UgdGhl
IA0KbWFpbiBlZmZlY3Qgb2YgeW91ciBjaGFuZ2UgaXMgdGhhdCAtIGJ5IGRvaW5nIHRoZSBhY3R1
YWwgDQpkc2FfcmVnaXN0ZXJfc3dpdGNoKCkgY2FsbCBhZnRlciB0aGUgc3dpdGNoIGRyaXZlciBw
cm9iZSAtIHRoZSANCmV0aGVybmV0LXN3aXRjaCAocHJvdmlkZXIpIGlzIGFscmVhZHkgcHJvYmVk
LCB0aGVyZWJ5IGFsbG93aW5nIHRoZSBQSFkgDQooY29uc3VtZXIpIHRvIHByb2JlIGltbWVkaWF0
ZWx5Lg0KDQo+IDEuIEknbSBob3BpbmcgdGhlIFBIWXMgYXJlIHRoZSBvbmx5IGNvbnN1bWVycyBv
ZiB0aGlzIHN3aXRjaC4NCg0KSW4gbXkgY2FzZSB0aGF0IGlzIHRydWUsIGlmIHlvdSBjb3VudCB0
aGUgbWRpb19idXMgYXMgd2VsbDoNCg0KL3N5cy9kZXZpY2VzL3BsYXRmb3JtL2V0aGVybmV0LXN3
aXRjaCMgbHMgLWwgY29uc3VtZXJcOioNCmxyd3hyd3hyd3ggICAgMSByb290ICAgICByb290ICAg
ICAgICAgICAgIDAgQXVnIDIyIDE2OjAwIA0KY29uc3VtZXI6bWRpb19idXM6U01JLTAgLT4gDQou
Li8uLi92aXJ0dWFsL2RldmxpbmsvcGxhdGZvcm06ZXRoZXJuZXQtc3dpdGNoLS1tZGlvX2J1czpT
TUktMA0KbHJ3eHJ3eHJ3eCAgICAxIHJvb3QgICAgIHJvb3QgICAgICAgICAgICAgMCBBdWcgMjIg
MTY6MDAgDQpjb25zdW1lcjptZGlvX2J1czpTTUktMDowMCAtPiANCi4uLy4uL3ZpcnR1YWwvZGV2
bGluay9wbGF0Zm9ybTpldGhlcm5ldC1zd2l0Y2gtLW1kaW9fYnVzOlNNSS0wOjAwDQpscnd4cnd4
cnd4ICAgIDEgcm9vdCAgICAgcm9vdCAgICAgICAgICAgICAwIEF1ZyAyMiAxNjowMCANCmNvbnN1
bWVyOm1kaW9fYnVzOlNNSS0wOjAxIC0+IA0KLi4vLi4vdmlydHVhbC9kZXZsaW5rL3BsYXRmb3Jt
OmV0aGVybmV0LXN3aXRjaC0tbWRpb19idXM6U01JLTA6MDENCmxyd3hyd3hyd3ggICAgMSByb290
ICAgICByb290ICAgICAgICAgICAgIDAgQXVnIDIyIDE2OjAwIA0KY29uc3VtZXI6bWRpb19idXM6
U01JLTA6MDIgLT4gDQouLi8uLi92aXJ0dWFsL2RldmxpbmsvcGxhdGZvcm06ZXRoZXJuZXQtc3dp
dGNoLS1tZGlvX2J1czpTTUktMDowMg0KbHJ3eHJ3eHJ3eCAgICAxIHJvb3QgICAgIHJvb3QgICAg
ICAgICAgICAgMCBBdWcgMjIgMTY6MDAgDQpjb25zdW1lcjptZGlvX2J1czpTTUktMDowMyAtPiAN
Ci4uLy4uL3ZpcnR1YWwvZGV2bGluay9wbGF0Zm9ybTpldGhlcm5ldC1zd2l0Y2gtLW1kaW9fYnVz
OlNNSS0wOjAzDQoNCg0KPiAyLiBBbGwgb2YgdGhlbSBoYXZlIHRvIHByb2JlIHN1Y2Nlc3NmdWxs
eSBiZWZvcmUgdGhlIHN3aXRjaCB3aWxsDQo+IHJlZ2lzdGVyIGl0c2VsZi4NCg0KWWVzLg0KDQo+
IDMuIElmIGRzYV9yZWdpc3Rlcl9zd2l0Y2goKSBmYWlscywgd2UgY2FuJ3QgZGVmZXIgdGhlIHBy
b2JlIChiZWNhdXNlDQo+IGl0IGFscmVhZHkgc3VjY2VlZGVkKS4gQnV0IEknbSBub3Qgc3VyZSBp
ZiBpdCdzIGEgbGlrZWx5IGVycm9yIGNvZGUuDQoNCkl0J3Mgb2YgY291cnNlIHBvc3NpYmxlIHRo
YXQgZHNhX3JlZ2lzdGVyX3N3aXRjaCgpIGZhaWxzLiBBc3N1bWluZyANCmZ3X2RldmxpbmsgaXMg
ZG9pbmcgaXRzIGpvYiBwcm9wZXJseSwgSSB0aGluayB0aGUgcmVhc29uIGlzIG1vc3QgbGlrZWx5
IA0KZ29pbmcgdG8gYmUgc29tZXRoaW5nIHNwZWNpZmljIHRvIHRoZSBkcml2ZXIsIHN1Y2ggYXMg
YSBjb21tdW5pY2F0aW9uIA0KdGltZW91dCB3aXRoIHRoZSBzd2l0Y2ggaGFyZHdhcmUgaXRzZWxm
Lg0KDQpJIGdldCB0aGUgaW1wcmVzc2lvbiB0aGF0IHlvdSBkb24ndCBuZWNlc3NhcmlseSByZWdh
cmQgdGhpcyBjaGFuZ2UgYXMgYSANCnByb3BlciBmaXgsIHNvIEknbSBoYXBweSB0byBkbyBmdXJ0
aGVyIHRlc3RzIGlmIHlvdSBjaG9vc2UgdG8gDQppbnZlc3RpZ2F0ZSBmdXJ0aGVyLg0KDQpLaW5k
IHJlZ2FyZHMsDQpBbHZpbg0KDQo+IA0KPiAtU2FyYXZhbmENCj4gDQo+IA0KPiArKysgYi9kcml2
ZXJzL25ldC9kc2EvcmVhbHRlay1zbWktY29yZS5jDQo+IEBAIC00NTQsMTQgKzQ1NCwxNiBAQCBz
dGF0aWMgaW50IHJlYWx0ZWtfc21pX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYp
DQo+ICAgICAgICAgIHNtaS0+ZHMtPnByaXYgPSBzbWk7DQo+IA0KPiAgICAgICAgICBzbWktPmRz
LT5vcHMgPSB2YXItPmRzX29wczsNCj4gLSAgICAgICByZXQgPSBkc2FfcmVnaXN0ZXJfc3dpdGNo
KHNtaS0+ZHMpOw0KPiAtICAgICAgIGlmIChyZXQpIHsNCj4gLSAgICAgICAgICAgICAgIGRldl9l
cnIoZGV2LCAidW5hYmxlIHRvIHJlZ2lzdGVyIHN3aXRjaCByZXQgPSAlZFxuIiwgcmV0KTsNCj4g
LSAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+IC0gICAgICAgfQ0KPiAgICAgICAgICByZXR1
cm4gMDsNCj4gICB9DQo+IA0KPiArc3RhdGljIHZvaWQgcmVhbHRla19zbWlfc3luY19zdGF0ZShz
dHJ1Y3QgZGV2aWNlICpkZXYpDQo+ICt7DQo+ICsgICAgICAgc3RydWN0IHJlYWx0ZWtfc21pICpz
bWkgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gKyAgICAgICBpZiAoZHNhX3JlZ2lzdGVyX3N3
aXRjaChzbWktPmRzKSkNCj4gKyAgICAgICAgICAgICAgIGRldl9lcnIoZGV2LCAidW5hYmxlIHRv
IHJlZ2lzdGVyIHN3aXRjaCByZXQgPSAlZFxuIiwgcmV0KTsNCj4gK30NCj4gKw0KPiAgIHN0YXRp
YyBpbnQgcmVhbHRla19zbWlfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+
ICAgew0KPiAgICAgICAgICBzdHJ1Y3QgcmVhbHRla19zbWkgKnNtaSA9IGRldl9nZXRfZHJ2ZGF0
YSgmcGRldi0+ZGV2KTsNCj4gQEAgLTQ5Miw2ICs0OTQsNyBAQCBzdGF0aWMgc3RydWN0IHBsYXRm
b3JtX2RyaXZlciByZWFsdGVrX3NtaV9kcml2ZXIgPSB7DQo+ICAgICAgICAgIC5kcml2ZXIgPSB7
DQo+ICAgICAgICAgICAgICAgICAgLm5hbWUgPSAicmVhbHRlay1zbWkiLA0KPiAgICAgICAgICAg
ICAgICAgIC5vZl9tYXRjaF90YWJsZSA9IG9mX21hdGNoX3B0cihyZWFsdGVrX3NtaV9vZl9tYXRj
aCksDQo+ICsgICAgICAgICAgICAgICAuc3luY19zdGF0ZSA9IHJlYWx0ZWtfc21pX3N5bmNfc3Rh
dGUsDQo+ICAgICAgICAgIH0sDQo+ICAgICAgICAgIC5wcm9iZSAgPSByZWFsdGVrX3NtaV9wcm9i
ZSwNCj4gICAgICAgICAgLnJlbW92ZSA9IHJlYWx0ZWtfc21pX3JlbW92ZSwNCj4gDQo=
