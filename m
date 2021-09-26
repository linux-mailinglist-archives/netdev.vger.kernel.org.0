Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48691418A07
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 17:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhIZPtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 11:49:53 -0400
Received: from mail-eopbgr1410122.outbound.protection.outlook.com ([40.107.141.122]:2298
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231990AbhIZPtu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 11:49:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTjVgsXmxL0/PksbeORy3kGwQbcVnjhtvFgZ2WfK8wTp0GZPqepL2kMvrqU5LrQg6dl4vGA2++PJK5corPDsao5wBljwcQeE5gW/+gYC1Hs3SCsPCbLBcgmeKNSL5IE9FqAN9+W3PluSO6eobQpcXCRjPYEqAciBuyWL+0xcTvQAUPSYnW3FK8EjTeoIf8HXi347JcrkeqdqheadukAngAmLhhc9hPK/znNcQewI7KSMgqNAVjKZPx5feW68b3GKOjVdQHC6v/Q8yrLhe3anuDXeJEQwuQaKlnKixOAh1jvWkGqQ5UcM9bg+oiRQDoiLGEKECdxhFpxW80NZFdONnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/y1bj8DSt2gdpF7KAMgv7YiTP0eaWpLDlnAeS8EFmXc=;
 b=j57xix4+aRBQARC4NpRdgnk2Bz+s9Ynbk6lnzXNI/2gCbrshQBuBEErGCjVlLxC/0Ok9Dj+CeaODk3DV9V7589Gmb6mGq+7X2exUKeXrpoBCOmTOE4GJ0a8phU94L1pvnSQ/JrK/JLtHWLhQxZGCgpCCzTWWH6kYitAlclE1y9I9Xw7Pw6GThV8EmMSq6CV6AVEl6YnUaxmaFKgbHEkrCIzVALJ30+pdJq0tBKw87X1ZH21aepkkJG7PXKDE6QViS6rc9aEewtJytVZ1ZX/0sQkSJa5yjjkYgglMPvT9O8uHdO+FylUbyXY0Y4IqP2CUXTSeeHkmUzNwUt9JIBMD8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y1bj8DSt2gdpF7KAMgv7YiTP0eaWpLDlnAeS8EFmXc=;
 b=Sd9U8usQQX/c8tIF6OQ8A7HpzGw+RpB8Np+A+6txDQTwINZaczn95kmHV44RDGxHiDaFGfu3RY63rO9q6vc34EVWJQMShtX/EYhV6R7tV8yB93t6XLi9zcNhTuWhlpdnFdlROq3djsO2awMJgFUvUwJ4PlAzmSK0eDFMwYqUPgY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2097.jpnprd01.prod.outlook.com (2603:1096:603:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sun, 26 Sep
 2021 15:48:02 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 15:48:02 +0000
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
Subject: RE: [RFC/PATCH 11/18] ravb: Add rx_2k_buffers to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 11/18] ravb: Add rx_2k_buffers to struct ravb_hw_info
Thread-Index: AQHXsISNG8lZ4S0EzU6ItVKeegvn3quzlaoAgALkygA=
Date:   Sun, 26 Sep 2021 15:48:01 +0000
Message-ID: <OS0PR01MB5922C79CF75D0592CC226CFD86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-12-biju.das.jz@bp.renesas.com>
 <1e9d1d3c-0846-077e-8e1a-e06ff86c00fa@omp.ru>
In-Reply-To: <1e9d1d3c-0846-077e-8e1a-e06ff86c00fa@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69426731-5dbe-45a2-b74f-08d9810505b2
x-ms-traffictypediagnostic: OSAPR01MB2097:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2097996F0AA9098F2B53C8D986A69@OSAPR01MB2097.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DTQO4Axmr4/ZjJ5oemPVR1BYHP39JQv+slNzb/T8dJ30vC+JOO5t4wLsaM3PzEZ7VVJFMTU558QFXnOZuqJOF/QWkFOpi2y30Jydi5Bg3aGeQbHw+afOv9vbfGzZFyKLQPNSr8NCSPp+JETnxCwGmgBgDT5LDBtLvbNYZyb0FP81VP2xH/RGlc+5ic4JTcD5RyikHHIefvaImGcoCeHBt3bH9ti0AHnnIO7N+AM1WNe9yLpzBREizFSXl9CrmMIwzrgq5UgEnOl1nQuUAdqFuiCuZ80Bxg/rDhcwL1WSub5GpRR5HFYiPfHUHPdHMZAvTpiTr8WswjGS7P9Y4QkUO/fVmgcqM5khMTXg8aNn8lEsbk1gHaold+hEmoh0P6vDuv2O+qF8ybE6wvPgFZIjavwGCgMJAdYU/wIXVPigpoUjE+OV5idqszEaBPUDdecw30eCdVTuk7Qr+rEWNqt9cP/BP4be1my/zMPjKm9PKNmgkMKtMmmlTzpe0j/Rdw4HiVgcYSLT73eb2miWgB6/ruqsC/1xUMpCML4iwW8CAPJ2vtetEkTd8JLuDXNI4Bj8hKH8nfKBbiojZTSOj6Dcx15Dg3TvKGYR++TkGkjHGJJrA1r8xDY/0rS3bM1IRi2CFz16p+zFF6ER098pw7BssRCqEXUhZyi1yGpp+TOzPxF9l8BbxMpQkJ/5QYNdYegVQRSdzMBhpJIMxZ9oMBualw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(4326008)(508600001)(33656002)(2906002)(71200400001)(5660300002)(38070700005)(6506007)(8676002)(107886003)(316002)(38100700002)(186003)(76116006)(26005)(8936002)(66946007)(9686003)(53546011)(86362001)(66476007)(64756008)(66446008)(7696005)(122000001)(66556008)(55016002)(54906003)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTBSdjJWbllPNks5UlNzMndPSC95cm4wZ1QyYzFRYVVpVXc1NlY4L1ovRkpR?=
 =?utf-8?B?bTNmdDBJRzAyeDNVMzlNaW10cC9sRDJObmtsUzl4R0VnRzdpRm5oaXB2cEtH?=
 =?utf-8?B?TVJHMVd0dTFqaE0weHQzY09XbkhJcXptaHpRWUEwS0pkNzRyS2FxU0lYYngz?=
 =?utf-8?B?SlFTeFBHS2gxbkVSakNudlF2VzJITmpPdGZaeURRbjlFSk5ucFRNKzJzSnhR?=
 =?utf-8?B?QkxCQkVWMUhsaUZvVlpYbmxSNnYvU0sxTnloaVhEWVdTbEpWZHRtMDR6QlQ1?=
 =?utf-8?B?RzZ5MmlEYXBPVmIwa0NUdjVnMVJoVVFISjM4NHUyUGpVYXhETFI0WWpYOGRF?=
 =?utf-8?B?M3N3YVN3c1c3L1NvUmJFb0ZFTG9qMXptRnArZENLTnQ2dGJxSkgxSktKRlpJ?=
 =?utf-8?B?UkFMVWxEL09Mck02bWdteUQ0MkJoaTR2akF1dHVUcURmbTlDY2JObzlBaEZE?=
 =?utf-8?B?MU5lN0JlZDgyZlYyWkIxektJT3pySUpHMXdZaFFMQm9td2V3TE5yRFlRTHVt?=
 =?utf-8?B?SUVQeHhlVnE1T2NXc2ZwdFJ3bGJDeDhtdzB0aDNuTVdmTEc2U2JpSXd6ck5v?=
 =?utf-8?B?eWJ3dzBxcldudGNyeVh5aExjaGVjR3gyZU1zNzBzdG5vN1MxdEVMcEZacnh6?=
 =?utf-8?B?V2pYM3ZtaHRBR2QvajQzN3gvd2pZUHR1SzNHMzZVa3FieFJEQ2wzZ3NSdGQv?=
 =?utf-8?B?dlQrVXpOT0VDNm1TTGZ3NUZVUjZ6UExBZDBHYy9scjl4U0xKZHJZbXhmVFcy?=
 =?utf-8?B?MGZDV3E3WjcyWTFYSy9XS1ptL2ljSytFTU81UnhEamI1TFRRWWE3bExNaEdv?=
 =?utf-8?B?M01ocGdNdFZUWEJZY1lOM2ZJNzlXYjcrZGNIcm14bHRUbmV5enlCdzZReXRn?=
 =?utf-8?B?SlkwM0poWFpPRUlWdllJOHZqeklUbGZPWlVGQUp1YVA4VXlKQ09wUjJBS3pP?=
 =?utf-8?B?Y0pRTDV6RnM3RlFWUzhvL1FsNTZMN1NYWEU5di84c014Q2c4cUNidjhzY0dt?=
 =?utf-8?B?QjhKUkdqUWZDYnltd0JPRXZFUVY4QnozQWdTazdpSWIxcS92MlpLaTJlUy9v?=
 =?utf-8?B?TWlvaUN1bU16OFBKRUZKdkNpb1c3V1M1SFBDaUw5NFBDbTVtVWZMSkU2Q0p3?=
 =?utf-8?B?Zm9Tcm9RR3U0cDEwTDdqOEZlNi8waCtmb1VlQXBxdWNtWC95cWVGaHZ5ays0?=
 =?utf-8?B?S0NpNmNlVVZEQ0djcmRyaVhCbU8veVp4SkM4MTZKdGxHQzZLclNGZXhNa3BT?=
 =?utf-8?B?aUJIOUJRK0hrazc1Z3puRHRqM2E0QzNqMngyUTUvYzArK1N4OUllZjk0OVBJ?=
 =?utf-8?B?aVc3citWcCs0Zmd5TVJ2SzhWT3JFQXN6QzdnbTZKTVpwQlRLVjF6YkFsUExk?=
 =?utf-8?B?UDdQbi9GSkNTakRldk1lMmhHdldPZDU5UjN6RmduVDdDNnB1S3BUeXBIZWNP?=
 =?utf-8?B?MHFpdDB5OXZLbmU0Rm9ETGt1U3ozbWdsR01HWjdFKzNXQkV4VWlkY2t5WExw?=
 =?utf-8?B?WVZHMFJqNkJ4MzhveG10VHBBdWZickRTV1U4QU1QcGp1cUNLSEdkOTRBYVBo?=
 =?utf-8?B?eUhaUlI3elVza2ZDbTJJdDhGL1ZOTzJ4UWlZVFk4RzAxaHBkVDhqdzNGTzRC?=
 =?utf-8?B?Rzgxb0ZZWVNUemZRSEZFMElrT1Znak5Ib2psQ2lHREswMG04TXlqNHp0c0hi?=
 =?utf-8?B?WllHajd3aFVuTzR6SWhZRmY0cVNKcFZRMFMzakRNVUdRR1EzOWpXMEJlK0Z1?=
 =?utf-8?Q?qaGmRrp/98UEp+agmFmrJ4CholvF1vEyw+vtgzg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69426731-5dbe-45a2-b74f-08d9810505b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 15:48:01.5693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VtYRP4oTlagr3uu5cQSgOc+sGGABg+EqQRCrWNBT7OuxN8Yo0JR7UjTySGoV6c0NkXyhXjSl6IDubGE+WAQymYGY9Vu8kNWkxKgE/M8Tel8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDL1BBVENIIDExLzE4XSByYXZiOiBBZGQg
cnhfMmtfYnVmZmVycyB0byBzdHJ1Y3QNCj4gcmF2Yl9od19pbmZvDQo+IA0KPiBPbiA5LzIzLzIx
IDU6MDggUE0sIEJpanUgRGFzIHdyb3RlOg0KPiANCj4gPiBSLUNhciBBVkItRE1BQyBoYXMgTWF4
aW11bSAySyBzaXplIG9uIFJaIGJ1ZmZlci4NCj4gPiBXZSBuZWVkIHRvIEFsbG93IGZvciBjaGFu
Z2luZyB0aGUgTVRVIHdpdGhpbiB0aGUgbGltaXQgb2YgdGhlIG1heGltdW0NCj4gPiBzaXplIG9m
IGEgZGVzY3JpcHRvciAoMjA0OCBieXRlcykuDQo+ID4NCj4gPiBBZGQgYSByeF8ya19idWZmZXJz
IGh3IGZlYXR1cmUgYml0IHRvIHN0cnVjdCByYXZiX2h3X2luZm8gdG8gYWRkIHRoaXMNCj4gPiBj
b25zdHJhaW50IG9ubHkgZm9yIFItQ2FyLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBE
YXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgMSArDQo+ID4gIGRyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCA4ICsrKysrKy0tDQo+ID4gIDIgZmlsZXMgY2hh
bmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGluZGV4IDc1MzJjYjUxZDdiOC4uYWI0OTA5
MjQ0Mjc2IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yi5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBA
QCAtMTAzMyw2ICsxMDMzLDcgQEAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gIAl1bnNpZ25l
ZCBtYWdpY19wa3Q6MTsJCS8qIEUtTUFDIHN1cHBvcnRzIG1hZ2ljIHBhY2tldA0KPiBkZXRlY3Rp
b24gKi8NCj4gPiAgCXVuc2lnbmVkIG1paV9yZ21paV9zZWxlY3Rpb246MTsJLyogRS1NQUMgc3Vw
cG9ydHMgbWlpL3JnbWlpDQo+IHNlbGVjdGlvbiAqLw0KPiA+ICAJdW5zaWduZWQgaGFsZl9kdXBs
ZXg6MTsJCS8qIEUtTUFDIHN1cHBvcnRzIGhhbGYgZHVwbGV4IG1vZGUgKi8NCj4gPiArCXVuc2ln
bmVkIHJ4XzJrX2J1ZmZlcnM6MTsJLyogQVZCLURNQUMgaGFzIE1heCAySyBidWYgc2l6ZSBvbiBS
WA0KPiAqLw0KPiANCj4gICAgSXQgc2VlbXMgbW9yZSBmbGV4aWJsZSB0byBzcGVjaWZ5IHRoZSBi
dWZmZXIgc2l6ZSwgbm90IGp1c3QgYSBiaXQgbGlrZQ0KPiB0aGlzLi4uDQoNCkFncmVlZCwgd2ls
bCB1c2UgcnhfbWF4X2J1Zl9zaXplIHZhcmlhYmxlIG9uIHRoZSBuZXh0IHZlcnNpb24uDQoNClJl
Z2FyZHMsDQpCaWp1DQo=
