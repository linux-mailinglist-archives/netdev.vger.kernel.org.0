Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70CA416B88
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 08:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244205AbhIXGXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 02:23:04 -0400
Received: from mail-eopbgr1400122.outbound.protection.outlook.com ([40.107.140.122]:61436
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244191AbhIXGW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 02:22:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agtJ93OWrUvk/yS5P8nmcmhmwg8DknzEBvfp27VLxbr8RFXzWdHWYgQKjF71NdqC6Y40GuO9L/2ek9uof8kRE0qfbamQpPZP7wdxHITD5o6Ji4t9bXfqFvlcCOulObLIjB63o13cQx4onG/jId7Ogqz+ZZMe4I/CrFeZHBFbZgXryFcyfUmIuiy5V+hwgs/MYU/8EdKkhEy6a1S+8PDzYVSVyGGLJBTFj/CtBhW3dLXIV1K51gPLIJ5/UHrEvaz2Ow2zv3nRkv9qRB+epoOhWyXT+2+mo1d3L0P3WUVLXvsZ5YuW06oUaKun4Prou1peqVfCsKcni9kE9/1YWEdu8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ubZiW+VSokCjqrbGb689dTArIdidzH+tDnnr9dlW0vE=;
 b=AXGL0RRGxdpiLedETU9cl79ipaMBjLV+nPO4Vsre8hDW5HcZS8YC1Q0utVhHlnpr+1vywON0Ntv6zWjHrOVLGHh+xaWE4Vu6wiCvfHtUBuMr6YI6miMopzemQ+9Loune3ESAGQiHtJLvV9xhQ5JmeCV57B/OSkfsb66cxM2PDpw6gemh2nSZzTm1alYFbKzWZUhCic4eytuNNbKtyW1/9dk69Lh1B/VmiOcA2lzavX+zxVf0R2KbrDWXUW0C3kb6CDDWfAPY0BVt/Eyo+WRapbTfv0cYXGBzziE//aRwQK4Cl83iX7qEfi81Kq/oHzqtV/2DkEIc0MO2AdPBITup5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubZiW+VSokCjqrbGb689dTArIdidzH+tDnnr9dlW0vE=;
 b=d/aNKizhVJQOmTtBR3RRGVkFQ8tEtuliNuyCHHPdHvhe4aseXMbAWuYgzTc1H6KelxIqtHFlEwui4Nk/Vk2w8RY8fpXXwyW4ZSofeglNXa6upysD9H2xuguyjpH/k62QGkLctxeIH2/nM0vgOYNlbu/623Xs1/j1ykMFvkQ37I4=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5847.jpnprd01.prod.outlook.com (2603:1096:604:b5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 24 Sep
 2021 06:19:28 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 06:19:26 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 06/18] ravb: Add multi_tsrq to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 06/18] ravb: Add multi_tsrq to struct ravb_hw_info
Thread-Index: AQHXsISD1oySk6FFzkKsyCBHXOWNQquyD7OAgAClW1A=
Date:   Fri, 24 Sep 2021 06:19:26 +0000
Message-ID: <OS0PR01MB5922135B7F17FDE3F4C6091A86A49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-7-biju.das.jz@bp.renesas.com>
 <9aa57bf1-44a5-6016-5445-4f2b8518ddfe@omp.ru>
In-Reply-To: <9aa57bf1-44a5-6016-5445-4f2b8518ddfe@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5024a2e-0d12-41a8-e408-08d97f23427e
x-ms-traffictypediagnostic: OS3PR01MB5847:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB58477FE7F818EBE51657923486A49@OS3PR01MB5847.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2VDxG5+0YZmDOUbnp+EX3dya9XJXdk2Te9XIKi5cozYCx+OrTQKPcNzafdzUVDIaTJi3P/Rx2ceHd7L919y80SJHehqq80zhxhZt4Bf4f1RQ6VdhzmrhniJrzvGl6dwfu2FMsu2OAlG0LdzMXtsZNwdvq//y7lTdFLH6Vex4++BhT/KHnOBKBSluGcyFo/04qhtoRTQkXq8j/UEt+6cozAXEuqBfTueQyo19WBJ+8YYIR6WbaVmodV7/3MDaeVtjL6h0wSryxnJYT/xBZTuic7GuGWoPlcyphln4ULSw4/UvOvkI9MI4LPOEmZnPekWBHq+GllwpLNNjno6lm1gMn1sBSuGVaslX8FwSwvKHH2ZKxmT3TOS8TVNmvWMjOzrA8gKCS7E+O88fZNdLyxStA6ZOGAwe59N/27xwvXt6IayXsUNtn4L1+JOYBUIeTRxms+7PBI79flPyHF+Y4cE+WlRLfuo9bbTzy5QQ8RjEh5B7wApCIBdRCVuUS6zJUl5S4ffIRatD9ip0lfzxyNRR3q+6RPFC1S4xJE3ZVKEsP8ytDGlO4QayFCgyHsL+zAoHyNw7O3a8z0pYnyaXIAjlTcG2T0/j6jivuA9zCqEeOm41lT2dYGeW7nOAZ7/B2vPR8RwhS+eWoSfzl+GlLyXyiuvwer/YJPMEGU97maffqNx/bMVI+qMLJj+ZgR+GJ5NN+xY3C/OPfS9Mpg4O+SpL9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(122000001)(53546011)(38070700005)(38100700002)(2906002)(26005)(6506007)(186003)(76116006)(33656002)(7696005)(316002)(54906003)(110136005)(66476007)(83380400001)(508600001)(66446008)(66946007)(64756008)(107886003)(66556008)(4326008)(8936002)(52536014)(5660300002)(9686003)(8676002)(71200400001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NW9xcGhpaVFNY1ZUd3cvbnFYckxrOEM1OS9rd01uK0NnR3N5dkJBeEo5Y3F0?=
 =?utf-8?B?UFBEUDlWcFlkVExBdTBZVUkveWkrZG1LOHpyblUxOEx5aDYwYTBBbjZyc2hH?=
 =?utf-8?B?S3RtaUw2aURhMTd0MDlqaG0zRms2ajZORFFkU0VzZjFNUVpxaVhtcm9QRWVk?=
 =?utf-8?B?S0pwV1NqNTRuNWhNUUxUWUNEYjkwTVFyRE1peXE2V2ZtVklFNHFaejNIZEdY?=
 =?utf-8?B?RGd0Z2JVT2x2dlZTaXpuWmIrKzVkOG1WbkhQclZvakxXY3M2STV4QlgyQlNY?=
 =?utf-8?B?T2hhcnZYZC9pWWpVL205MG55TkdodkV6MnlhMzl4K0djbTN6UHpSUTdHSHdn?=
 =?utf-8?B?MHRNSUIwMWZxVFNPVzZjY3I2R3g1enFXRjE2NXlFbDQ1blFxU1VHN3NuNGph?=
 =?utf-8?B?QnBTRVhBdVUydjIzdFU4TFgvZzV1enY5ZTdkR1g2VzM3MVVGOFNQRGN6UUps?=
 =?utf-8?B?V2YwaHRxQklzVC9uNFhPWnJSeFNhYU13dnpPN1NaM2pUc2xlUnZPdFFURThO?=
 =?utf-8?B?UURRVFd3NEUyWGNTVHRESktzS21CY1djdjMzN1p1cm1CazdRSWlocG03YTRm?=
 =?utf-8?B?MjVCbWYyOU9BNzF3MnoyT2hVd2d4dWorNGdhRVhkbWJBa1l6RFVvUFhPSnly?=
 =?utf-8?B?azNQb0cyK21Sc2lUMUJhMElZQXVmbGpOQU9hN0UrME56cEVNK0F4czdYZk5i?=
 =?utf-8?B?UEt4NzZqVk5wSHFxaytjV3hXa3NYYzN6ckpmS3V3Sng1d2Q4MVNzN2hHVFRC?=
 =?utf-8?B?c21BeDJIUWFlRUhDZTN2NG9HZTNLVDlBcVh6T2lmcEovS2xDQlVWNVlYMTFR?=
 =?utf-8?B?dkNBbUdGZGg1RWFJTExZUnFuKzNKb0RJei9jZGNIbGdtL1pDRDlCUDd5ZS9O?=
 =?utf-8?B?TnVhdHd1U1k2dlhzeThUU21UdUMxY2lSNWdrRE04ZzRGVHU3MGtaclF0UElK?=
 =?utf-8?B?OUk0dVNETDJkRUl3V1ZOcmE2YytNREZPUjJGM1Fma25hL3RoSnNrNU5lVkY4?=
 =?utf-8?B?MVpQZFNwNXdneGI0bjlWV3VWd2szanVnZ1hya2orR0EwaG5Vc2RORzFvY0JG?=
 =?utf-8?B?NnZEWG5MS3lsN0FmRy92eEhnTy9VcittbDQ2SUc2RjVRQVVuZEYwWWpQU2hT?=
 =?utf-8?B?Z1pyV0dRQ1N4cDlLRFU3NkhXbmFLaEplaTNRTnNvcTQxVUljekhYTjcxNjhC?=
 =?utf-8?B?V0pvNlhJYlBYbVNYOVhCMzFiYjFrQk5HUThCN3dxVEdyd1ZOUXlyaTJsM2Vk?=
 =?utf-8?B?NW9PRDFNYk5oTTd2bGZIeU5USks0ZEp1TDVLTmZlMXpaUmtObWNwOFZxMWc1?=
 =?utf-8?B?TVZuUThVcTdNb24zc2sySmlKbHErQ0xRYWZNbm44U0w5KzJkbU9UV3NQQldL?=
 =?utf-8?B?N0dGOU9YTEg4TFAzTHd6YzdOdzBweGhsN3BXUzB2K21GaHR1QjJXaEQ4UHBF?=
 =?utf-8?B?VENkRC83Q2RxSjM1Y3VaU3R3TXB1NERXWmF4c0NuVWRaMXZ3WDRIMjUwMlFX?=
 =?utf-8?B?WEh3ejJ5dHFMNFE3clJEQ0FaRUpFR24zT1FjVDVMT0JTdmdwOHRUZEpHRUFn?=
 =?utf-8?B?S1FBRDNCdDFpYUV4THd6TDA1aS9WNVV1bXZKRXQyQmRCNFk0bFpUSXdHSVhj?=
 =?utf-8?B?SEp2Z21GYjdjSlg5YndkNGxSYTcrMXBoY2NaZ0FMMVFTaFZnWXppZWVRbjQy?=
 =?utf-8?B?ZDBiZUgyemFmMjJVMWF2L1Y4MVV0ZkFEa2hMTHZ6a1FZRlNsNE0vTE51UHV3?=
 =?utf-8?Q?QBXZeMmNUwqPao1Y9/+k5BdSK+bunaMEK4o2Tw2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5024a2e-0d12-41a8-e408-08d97f23427e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 06:19:26.3590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LiB1JUjMbUATJIkJFCjCKP+f7TKH2Hi5Bhqw80QLEdT8caYSi7vKhVshiAnXnKh7wW+PW7Jwj7ZvLs3Nnr4vyFWTf8Drrs57yD0gm7t6fW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5847
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQy9QQVRDSCAwNi8xOF0gcmF2YjogQWRkIG11bHRpX3RzcnEgdG8gc3RydWN0IHJhdmJfaHdf
aW5mbw0KPiANCj4gT24gOS8yMy8yMSA1OjA4IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4g
Ui1DYXIgQVZCLURNQUMgaGFzIDQgVHJhbnNtaXQgc3RhcnQgUmVxdWVzdCBxdWV1ZXMsIHdoZXJl
YXMgUlovRzJMIGhhcw0KPiA+IG9ubHkgMSBUcmFuc21pdCBzdGFydCBSZXF1ZXN0IHF1ZXVlKEJl
c3QgRWZmb3J0KQ0KPiA+DQo+ID4gQWRkIGEgbXVsdGlfdHNycSBodyBmZWF0dXJlIGJpdCB0byBz
dHJ1Y3QgcmF2Yl9od19pbmZvIHRvIGVuYWJsZSB0aGlzDQo+ID4gb25seSBmb3IgUi1DYXIuIFRo
aXMgd2lsbCBhbGxvdyB1cyB0byBhZGQgc2luZ2xlIFRTUlEgc3VwcG9ydCBmb3INCj4gPiBSWi9H
MkwuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVu
ZXNhcy5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yi5oICAgICAgfCAgMSArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9t
YWluLmMgfCAxMiArKysrKysrKysrLS0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmIuaA0KPiA+IGluZGV4IGJiOTI0NjlkNzcwZS4uYzA0M2VlNTU1YmU0IDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBAQCAtMTAwNiw2ICsxMDA2
LDcgQEAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gIAl1bnNpZ25lZCBtdWx0aV9pcnFzOjE7
CQkvKiBBVkItRE1BQyBhbmQgRS1NQUMgaGFzIG11bHRpcGxlDQo+IGlycXMgKi8NCj4gPiAgCXVu
c2lnbmVkIG5vX2dwdHA6MTsJCS8qIEFWQi1ETUFDIGRvZXMgbm90IHN1cHBvcnQgZ1BUUA0KPiBm
ZWF0dXJlICovDQo+ID4gIAl1bnNpZ25lZCBjY2NfZ2FjOjE7CQkvKiBBVkItRE1BQyBoYXMgZ1BU
UCBzdXBwb3J0IGFjdGl2ZSBpbg0KPiBjb25maWcgbW9kZSAqLw0KPiA+ICsJdW5zaWduZWQgbXVs
dGlfdHNycToxOwkJLyogQVZCLURNQUMgaGFzIE1VTFRJIFRTUlEgKi8NCj4gDQo+ICAgIE1heWJl
ICdzaW5nbGVfdHhfcScgaW5zdGVhZD8gDQoNClNpbmNlIGl0IGlzIGNhbGxlZCB0cmFuc21pdCBz
dGFydCByZXF1ZXN0IHF1ZXVlLCBpdCBpcyBiZXR0ZXIgdG8gYmUgbmFtZWQgYXMgc2luZ2xlX3Rz
cnENCnRvIG1hdGNoIHdpdGggaGFyZHdhcmUgbWFudWFsIGFuZCBJIHdpbGwgdXBkYXRlIHRoZSBj
b21tZW50IHdpdGggIkdiRXRoZXJuZXQgRE1BQyBoYXMgc2luZ2xlIFRTUlEiDQpQbGVhc2UgbGV0
IG1lIGtub3cgYXJlIHlvdSBvayB3aXRoIGl0LiBPdGhlciB3aXNlIEkgd291bGQgbGlrZSB0byB1
c2UgZXhpc3RpbmcgbmFtZS4NCg0KPiANCj4gPiAgfTsNCj4gPg0KPiA+ICBzdHJ1Y3QgcmF2Yl9w
cml2YXRlIHsNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4u
Yw0KPiA+IGluZGV4IDg2NjNkODM1MDdhMC4uZDM3ZDczZjZkOTg0IDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gQEAgLTc3NiwxMSArNzc2
LDE3IEBAIHN0YXRpYyB2b2lkIHJhdmJfcmN2X3NuZF9lbmFibGUoc3RydWN0DQo+ID4gbmV0X2Rl
dmljZSAqbmRldikNCj4gPiAgLyogZnVuY3Rpb24gZm9yIHdhaXRpbmcgZG1hIHByb2Nlc3MgZmlu
aXNoZWQgKi8gIHN0YXRpYyBpbnQNCj4gPiByYXZiX3N0b3BfZG1hKHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2KSAgew0KPiA+ICsJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2
KG5kZXYpOw0KPiA+ICsJY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyAqaW5mbyA9IHByaXYtPmlu
Zm87DQo+ID4gIAlpbnQgZXJyb3I7DQo+ID4NCj4gPiAgCS8qIFdhaXQgZm9yIHN0b3BwaW5nIHRo
ZSBoYXJkd2FyZSBUWCBwcm9jZXNzICovDQo+ID4gLQllcnJvciA9IHJhdmJfd2FpdChuZGV2LCBU
Q0NSLA0KPiA+IC0JCQkgIFRDQ1JfVFNSUTAgfCBUQ0NSX1RTUlExIHwgVENDUl9UU1JRMiB8IFRD
Q1JfVFNSUTMsIDApOw0KPiA+ICsJaWYgKGluZm8tPm11bHRpX3RzcnEpDQo+ID4gKwkJZXJyb3Ig
PSByYXZiX3dhaXQobmRldiwgVENDUiwNCj4gPiArCQkJCSAgVENDUl9UU1JRMCB8IFRDQ1JfVFNS
UTEgfCBUQ0NSX1RTUlEyIHwNCj4gVENDUl9UU1JRMywgMCk7DQo+ID4gKwllbHNlDQo+ID4gKwkJ
ZXJyb3IgPSByYXZiX3dhaXQobmRldiwgVENDUiwgVENDUl9UU1JRMCwgMCk7DQo+IA0KPiAgICBB
cmVuJ3QgdGhlIFRTUlExLzIvMyBiaXRzIHJlc2VydmVkIG9uIFJaL0cyTD8gSWYgc28sIHRoaXMg
bmV3IGZsYWcgYWRkcw0KPiBhIGxpdHRsZSB2YWx1ZSwgSSB0aGluay4uLiB1bmxlc3MgeW91IHBs
YW4gdG8gdXNlIHRoaXMgZmxhZyBmdXJ0aGVyIGluIHRoZQ0KPiBzZXJpZXM/DQoNCkl0IHdpbGwg
YmUgY29uZnVzaW5nIGZvciBSWi9HMkwgdXNlcnMuIEhXIG1hbnVhbCBkb2VzIG5vdCBkZXNjcmli
ZXMgVFNSUTEvMi8zDQphbmQgd2UgYXJlIHdyaXRpbmcgdW5kb2N1bWVudGVkIHJlZ2lzdGVycyB3
aGljaCBpcyByZXNlcnZlZC4NCg0KVG9tb3Jyb3cgaXQgY2FuIGhhcHBlbiB0aGF0IHRoaXMgcmVz
ZXJ2ZWQgYml0cyg5MCUgaXQgd2lsbCBub3QgaGFwcGVuKSB3aWxsIGJlIHVzZWQgZm9yIGRlc2Ny
aWJpbmcgc29tZXRoaW5nIGVsc2UuDQoNCkl0IGlzIHVuc2FmZSB0byB1c2UgcmVzZXJ2ZWQgYml0
cy4gQXJlIHlvdSBhZ3JlZWluZyB3aXRoIHRoaXM/DQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4gDQo+
IE1CUiwgU2VyZ2VpDQo=
