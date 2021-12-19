Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49ADF47A2FD
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 00:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhLSXTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 18:19:07 -0500
Received: from mail-vi1eur05on2108.outbound.protection.outlook.com ([40.107.21.108]:50497
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233864AbhLSXTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Dec 2021 18:19:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLPp8hLP0LpkQH+eTF6PMzoyjGCbVW/vxnw6QrventH+XvWe+EbK7Yic6168PK5+WtoDb+qbbOvc+LNhDiALdQBYW0+ColME+c09DT8JrwksIspS1sV2AiW8mK1WJZZI97ibxiGUYC2k+0TnskSLdY6fCK+6Dex/c+0Qkensiy/Qf+xw9RZmfvjufKMD2JzKuIWOqr9D3XyyBdmE7hJzmJxQtbS+PQH4w2eHCpPt0TvmoFM74GdzPkr2FLua+TOVcqKpaxc9zYAS7P1x4Aoo1KAVWIdZmI1Q1odsTlSzVa3gXuQ7XFeJBSBAruQil9hgCFIaS16eVkC4k/5L6bUA7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jEBMD5rzLiyrOr/NuMGMpe+W03bd9DwiePhnR+8alSQ=;
 b=c5qLkBknF+XvI6SMt/9gkMvXY3EDGdsmPXTKRk/Dg4KrvApGH6jPzRTqhIoUWy+d/kU22WQOOCcjCg0x3YTH4g7GIlEeBY/ZZiM4a3dU/LAbQx7vc/awN0tc0qVJXF+1svYiAdyZYXzKqrBuF2506Gwp3hhSUn8Hs/m/RDiZm2ezeGhnhozgzhdvCUIRYzzBcO+bGg1ox14CG4vckqaWbiEO+o7bmrUkk28c5xTDC3IvGfMNM1Vzew7nOdp95xXqxNeWfsug1iaEhJCTRDYH82Mmv+VTJYiT0bbP/+QBLEGy55Lj/Ha0fKN759alvg3+gPaitTqiB2z9OSC9q2dFFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEBMD5rzLiyrOr/NuMGMpe+W03bd9DwiePhnR+8alSQ=;
 b=MS5as7Dzc0geuVb/e3Eh7aXJhRI0et+Cw7fHoIsMlXAOV7APFZOqVE8pvmyWmZr6AG2LKjDb0FO2zejy1jpvl+SOtG05SyTuHF6gC5IJ7O9MeYjRus9CgdklD2SdExb0AhCd7eu4jY35AvXD5t9yl+JjoxJzlI/TmKNHcgSw2xM=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB3941.eurprd03.prod.outlook.com (2603:10a6:20b:1e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sun, 19 Dec
 2021 23:19:03 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4801.020; Sun, 19 Dec 2021
 23:19:03 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2 11/13] net: dsa: realtek: rtl8365mb: use DSA
 CPU port
Thread-Topic: [PATCH net-next v2 11/13] net: dsa: realtek: rtl8365mb: use DSA
 CPU port
Thread-Index: AQHX8+drM7L1MfR4F0mOUM8RVdi+c6w6ZRiAgAAQtwA=
Date:   Sun, 19 Dec 2021 23:19:03 +0000
Message-ID: <464bd9da-16ab-793d-972d-dff8967bdc50@bang-olufsen.dk>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-12-luizluca@gmail.com>
 <20211219221913.c7hxslrvkj6cyrle@skbuf>
In-Reply-To: <20211219221913.c7hxslrvkj6cyrle@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 199d69ba-4078-441b-3160-08d9c345f21d
x-ms-traffictypediagnostic: AM6PR03MB3941:EE_
x-microsoft-antispam-prvs: <AM6PR03MB3941D090BD1F6D5AE2C69B0F837A9@AM6PR03MB3941.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jm/jL3/CnpLaU8rotj3mfF6SG2TVo2JXfINV6f8AZce4EWOBlkQ1xmRQuocHgD+C5E/IZCHPIHT/BmEs9DXnZkjJtcf62uDxq6gAGOOvY3akkq4HDY4karfsbo7n+13Gl+FjwbqFk2znpuFY0dYYBsLdl+/2gjhFVbwvKapRmXre+TfW3OrA5CWi9ALP1Bj4L3aFAH2fg4t4pJzfHalQZVE5+eiI588bhHPg7M5brDxK9RTJjZI3sIwaeWGcPV4z/Fmn3vqa0F0P+6brRloCWCNB8yFwCYxYa+HmAp30JnKUohsv/Pt7LRJl/9bh1+JxnEbHX2voqdAwhBO59zNiJtmwpZkMFyfUm/Y1ioV5HAORD0+vOCZt9t/ZzxTYhoR6tI0Ie5UlUPF3cf+gByIR5oJ/caVVm0Lqe/vvkX47eIBuLm4rrLsX9jFkpNJiaIZjZyGxFNj6DCA8nAPDU6SbdA2Lu6tXbntqRDbGifSfYCHHKhpR93JEefB5/yDh52cJVoPT6NzLRYB1Qy9rscv24LLB68phlljvTZjE6uCVMxVlEPrhC+A/QvRBUIv/KgU7RjzzHRmUa6eL6l7ufobfR3T1z7DA75GxWwZncU7NxiEeg6mE1MoX8UsByhAgC0lMznFz+z8w6RLRAeKKKlhRufMh2hOHmEqgDqJeE7ZgEMaocgrpdnGUOl5EjOK8zoCnMMC+nkpkkiru30ANnKpCbZ9h8GCHyEUfUxpfrj3s3MrTEeKOO5of+AY9z6eK8pK9nAkVSOV30uevLpEqg+qHfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(2906002)(6486002)(316002)(38070700005)(2616005)(5660300002)(110136005)(31696002)(85202003)(86362001)(31686004)(66446008)(4326008)(36756003)(66476007)(66946007)(508600001)(8936002)(66556008)(64756008)(85182001)(6512007)(76116006)(83380400001)(91956017)(66574015)(186003)(54906003)(26005)(8976002)(53546011)(8676002)(6506007)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHl4YjV3cG94cDE5RmNXb3Rra21kYkdyRVRzUXkwZ3BnRXBFa2hLdG5ZazNZ?=
 =?utf-8?B?VGRhTm1YdXJCWCtybFhERnZiSHBhWm45QUtUTDZ2akFmekFwVU9EQjByT254?=
 =?utf-8?B?Z2hFbFBKSWFHYm9FcnJseTBpSWEzc2NJTHdocDZ6dXVCdGVFeWM4SkNiU2R3?=
 =?utf-8?B?WnJVV0M5ckpsYnpRUTFvMW9EVTJmc0QwNjRpMm9oTy9LcWZrVWRuVmpsblFE?=
 =?utf-8?B?R2J4VWFjVG5KYVdvWFRWYUpoWEJaSVhBSEF1cXYrVUdwQXA4Y2VOZHdPM2xl?=
 =?utf-8?B?bUtLOUZFZHA5N2F2QzlxS0VXaVpTT1VTZTFJWjVtaTBZeDIvMWE1NFJYUlZX?=
 =?utf-8?B?b2FPZmJoeXhLMzFVUmZiZlNremxnc1VELzZaZ0plV21CWGxsd2x1YVJNY0Fu?=
 =?utf-8?B?TWVWK3E2Z213S3hZR3pFSHcrNnJhaUFOQnVvNktXUVNoWkd2dmdPWG5rTUtn?=
 =?utf-8?B?dTVMb3ZqRG1YMWJlZkZXb0xoeEFtQjdBa3dkSFl0UGJKTENUTHIwa3cwbkNH?=
 =?utf-8?B?c0NJUGpuWDZUT0pSN3ZJenBHSXQzR0srY2JYWlQzcFVwU3FHS0hKSUs1VlB3?=
 =?utf-8?B?TStWc3Zkak81MDc3b2dsSmVEdXVkQlVya1BZYWNDcXAxQ1Fhbk4rV0xYWmpE?=
 =?utf-8?B?K3EvN09QQTAyem85OXZGMlc0Q1MzNVJYTGRONHVQTWxmZlNEUzdJN0duZHRZ?=
 =?utf-8?B?Vmh2cGxEWEJQZ0VWWmtUUG5oNnRHelI4VG1FOUI2aHMvd2JOb2F1bDlVelZq?=
 =?utf-8?B?VEg3azh6VXlDckprK25pU1p1cWZSSXFRcDFyZGM2YjJORzdXcHc0eEpKdG95?=
 =?utf-8?B?b3hrUFZnM1VrcE5MTWlySnlCL2F2U1NUd01QNFNJUjgrTHAzR0k2Y3JOTWln?=
 =?utf-8?B?OHBlYkFlRWh1RFhBcGxWZStVVnFJWm1wSjc0aWFIRlBrbjI0NVdVR1pHYWdB?=
 =?utf-8?B?NVZYRDMwN2RpRGsva05EcC83azl1MHpuUVBWMmw3N2xrUU5heGRuM1M2K05Q?=
 =?utf-8?B?ZFRWZ2krb1BlUEpsLzVGbHdCRUdEclpMaVd0ZFVsaG9FeVBKWThRMnVUQkFK?=
 =?utf-8?B?eUFnek5NdHI0YkZoZ1MvYUk3T2YwK3ZpbkNzd09nc0JPSGxwRUxJb0h5VElU?=
 =?utf-8?B?VTU5UlVobXkrZ2pZcS9ZZzVPNVh6cXRDdFUxMVlWdmplN00rOFcxeG4yUTNT?=
 =?utf-8?B?cDU2S2M4ZjcwQXpnUThmMlo4TDJNWkJmQ0k0dGlMQUFtRityM0t0Z2lId3Mr?=
 =?utf-8?B?N08rd0pZdC9ORXk3M1phdCtWdm1zWXB1Sy9SczNyUGhuTytJR2tOSVBDYTVk?=
 =?utf-8?B?ZExMNnZmUWpvZDhDZWhPR1lRT2hvWlJHM1dTdVZnaWFlbGh1UmtJSmhCRE1C?=
 =?utf-8?B?VVVQUy84a08zaHkrZ1NlVTZBYVBuaUJLWEJ0by9YUEYrN1Z1RnlsWUV0R09K?=
 =?utf-8?B?Y2J6Vko0cmhabWdXTHRXVVBHa2VzcHREbklzeFNyTkVhb1BqYThLa3BLY01x?=
 =?utf-8?B?SC9uaU91U1B6UE9nOUd3cnJTNmlkRm9BUHZlcFI4V2hKVkZ5NjA1Q2h3RG5w?=
 =?utf-8?B?bFo2R0dFcVpXYTVZTWFMYjZUK0tGZmVQVFlHUUtXbkN5TEIzbEI1Ym55c20z?=
 =?utf-8?B?TmExSXdpOWl0YlBSaEZMV2JnRTRyRHVRWWVoZUFNMHVLOHFUVTdhWHpKMGhN?=
 =?utf-8?B?K1dFUTdwa3N0VEpXU0hyek8wYnN2dHUxWExTamEzY0Nsd0MrMWY1Q09sMTlF?=
 =?utf-8?B?aHVwcG9UcjVVeFRlRlo2ckpuaUcwazZkUjBEdkw1eEsrUXhUeDRzZXhmQWFs?=
 =?utf-8?B?emdGR281STlqOHIwL0hNamNaOEJqNmZiSS8yaGZSRFFmY3J3SlIyQ1lWSDNh?=
 =?utf-8?B?QTNxR25CWHI1d1U2R0FjK3ZlSlN2L2JsQlJEL3ZHSlJRdjRCVHc0S0hnUndN?=
 =?utf-8?B?aE9PdHBwWDF6eDNQcmRhb0FsaDlNbWdvMlg0bU1mRi9ZTGN1TjRoY1Rqdk5F?=
 =?utf-8?B?YW9VcjY1QkczcitEZDNEQ3orYmhlRkdSQ3VZNWNxcHpQTEMxcTJXbDlNYXQr?=
 =?utf-8?B?aFlxdmJETTUrM3BkWStPOEoxNFZ1TDY4NnJUdTh6QVE3eXo0UUJORWRHamNZ?=
 =?utf-8?B?MytFbHB5cGQzRXZ2MnlvejJ1TjNzK1lybTd5RGNENy9GZ0F5QUR6bVd6T25u?=
 =?utf-8?Q?qByx2SB1lNFNk5rVE7lxr6a4b9Dn1TJsj8zAEKatCb3Z?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEC09AFB8282C845B5CA8233BD5CC957@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199d69ba-4078-441b-3160-08d9c345f21d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2021 23:19:03.0545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7A+ajQLZj99GMoE4Hj78x3WdfY8UBx7aUh8OnpVNptM4oXlVA0vzHd5Xm69FSS57T2+TM04Hvw4i7BvuTg0p+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTkvMjEgMjM6MTksIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gT24gU2F0LCBEZWMg
MTgsIDIwMjEgYXQgMDU6MTQ6MjNBTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSB3
cm90ZToNCj4+IEluc3RlYWQgb2YgYSBmaXhlZCBDUFUgcG9ydCwgYXNzdW1lIHRoYXQgRFNBIGlz
IGNvcnJlY3QuDQo+Pg0KPj4gVGVzdGVkLWJ5OiBBcsSxbsOnIMOcTkFMIDxhcmluYy51bmFsQGFy
aW5jOS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBMdWl6IEFuZ2VsbyBEYXJvcyBkZSBMdWNhIDxs
dWl6bHVjYUBnbWFpbC5jb20+DQo+PiAtLS0NCj4gDQo+IEkgZG9uJ3QgbmVjZXNzYXJpbHkgc2Vl
IHRoZSB2YWx1ZSBhZGRlZCBieSB0aGlzIGNoYW5nZS4gU2luY2UgKEkgdGhpbmspDQo+IG9ubHkg
YSBzaW5nbGUgcG9ydCBjYW4gYmUgYSBDUFUgcG9ydCwgYSBzYW5pdHkgY2hlY2sgc2VlbXMgdG8g
YmUgbWlzc2luZw0KPiB0aGF0IHRoZSBDUFUgcG9ydCBpbiB0aGUgZGV2aWNlIHRyZWUgaXMgdGhl
IGV4cGVjdGVkIG9uZS4gVGhpcyBzZWVtcyB0bw0KPiBiZSBtaXNzaW5nIHdpdGggb3Igd2l0aG91
dCB5b3VyIHBhdGNoLiBZb3UgYXJlIHVubmF0dXJhbGx5IHNwbGl0dGluZyB0aGUNCj4gaW5pdGlh
bGl6YXRpb24gb2YgYSBkYXRhIHN0cnVjdHVyZSBiZXR3ZWVuIHJ0bDgzNjVtYl9zZXR1cCgpIGFu
ZA0KPiBydGw4MzY1bWJfZGV0ZWN0KCkuIE1heWJlIHdoYXQgeW91IHNob3VsZCBkbyBpcyBrZWVw
IGV2ZXJ5dGhpbmcgaW4NCj4gcnRsODM2NW1iX2RldGVjdCgpIHdoZXJlIGl0IGlzIHJpZ2h0IG5v
dywgYW5kIGNoZWNrIGluIHJ0bDgzNjVtYl9zZXR1cA0KPiB0aGF0IHRoZSBjcHVfZHAtPmluZGV4
IGlzIGVxdWFsIHRvIHByaXYtPmNwdV9wb3J0Pw0KDQpJJ20gcXVpdGUgc3VyZSB0aGUgc3dpdGNo
IGZhbWlseSBkb2VzIGFjdHVhbGx5IHN1cHBvcnQgbXVsdGlwbGUgQ1BVIA0KcG9ydHMuIElmIHlv
dSBoYXZlIGEgY2FzY2FkZWQgc3dpdGNoLCBDUFUtdGFnZ2VkIGZyYW1lcyBtYXkgcGFzcyBiZXR3
ZWVuIA0KdGhlIGV4dGVybmFsIHBvcnRzIG9mIHRoZSBzd2l0Y2hlcy4gQW55IHBvcnQgY2FuIGJl
IGNvbmZpZ3VyZWQgdG8gcGFyc2UgDQpDUFUtdGFnZ2VkIGZyYW1lcy4gQW5kIHRoZSBDUFUgcG9y
dCBjb25maWd1cmF0aW9uIHJlZ2lzdGVyIGFsbG93cyBmb3IgYSANCm1hc2sgb2YgRVhUIHBvcnRz
IHRvIGJlIGNvbmZpZ3VyZWQgZm9yIHRyYXBwaW5nLg0KDQpIb3dldmVyLCB0aGlzIGNoYW5nZSBy
ZXF1aXJlcyBhIG1vcmUgdGhvcm91Z2ggZXhwbGFuYXRpb24gb2Ygd2hhdCBpdCBpcyANCnRyeWlu
ZyB0byBhY2hpZXZlLiBJIGFscmVhZHkgc2VlIHRoYXQgVmxhZGltaXIgaXMgY29uZnVzZWQuIFRo
ZSBjb250cm9sIA0KZmxvdyBhbHNvIGxvb2tzIHJhdGhlciBzdHJhbmdlLg0KDQpJZiBJIGFtIHRv
IGd1ZXNzIHdoYXQgZGVmaWNpZW5jeSB5b3UgYXJlIHRyeWluZyB0byBhZGRyZXNzLCBpdCdzIHRo
YXQgDQp0aGUgZHJpdmVyIGFzc3VtZXMgdGhhdCB0aGUgQ1BVIHBvcnQgaXMgdGhlIEVYVCBwb3J0
OyBzaW5jZSB0aGVyZSBpcyANCm9ubHkgb25lIHBvc3NpYmxlIEVYVCBwb3J0LCB0aGlzIGlzIGhh
cmRjb2RlZCB3aXRoIA0KUlRMODM2NU1CX0NQVV9QT1JUX05VTV84MzY1TUJfVkMgPSA2LiBCdXQg
bm93IHlvdXIgbmV3IHN3aXRjaCBhY3R1YWxseSANCmhhcyBfdHdvXyBFWFQgcG9ydHMuIFdoaWNo
IG9mIHRob3NlIGlzIHRoZSBDUFUgcG9ydCBpcyBjb25maWd1cmVkIGJ5IA0Kc2V0dGluZyB0aGUg
cmVhbHRlayxleHQtaW50IHByb3BlcnR5IGluIHRoZSBkZXZpY2UgdHJlZSBub2RlIG9mIHRoZSBD
UFUgDQpwb3J0LiBCdXQgdGhhdCBtZWFucyB0aGF0IHRoZSBDUFUgcG9ydCBjYW5ub3QgYmUgaGFy
ZGNvZGVkLiBTbyB5b3Ugd2FudCANCnRvIGdldCB0aGlzIGluZm9ybWF0aW9uIGZyb20gRFNBIGlu
c3RlYWQuDQoNClNpbWlsYXIgdG8gbXkgY29tbWVudCB0byBhbm90aGVyIHBhdGNoIGluIHlvdXIg
c2VyaWVzLCBJIHRoaW5rIGl0J3MgDQp3b3J0aCBtYWtpbmcgdGhlIGRyaXZlciBzdXBwb3J0IG11
bHRpcGxlIEVYVCBpbnRlcmZhY2VzLiBUaGVuIGl0IHNob3VsZCANCmJlIGNsZWFyZXIgaW4gdGhl
IHNlcmllcyB3aHkgeW91IGFyZSBtYWtpbmcgdGhlc2UgY2hhbmdlcy4NCg0KUGxlYXNlIGNvbnNp
ZGVyIGFsc28gVmxhZGltaXIncyBwb2ludCBhYm91dCB1bm5hdHVyYWxseSBzcGxpdHRpbmcgY29k
ZS4gDQpJIGNhbiBzZWUgaXQgZWxzZXdoZXJlIGluIHRoZSBzZXJpZXMgYSBsaXR0bGUgYml0IHRv
by4gSXQgaXMgbmljZSB0byANCmtlZXAgdGhlIHN0cnVjdHVyZSBvZiB0aGUgZHJpdmVyIGNvbnNp
c3RlbnQgLSBhdCBsZWFzdCB3aGlsZSBpdCBpcyBzdGlsbCANCnlvdW5nIGFuZCBpbm5vY2VudC4g
Oi0pDQoNCj4gDQo+PiAgIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgMjMg
KysrKysrKysrKysrKystLS0tLS0tLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlv
bnMoKyksIDkgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Rz
YS9yZWFsdGVrL3J0bDgzNjVtYi5jIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1i
LmMNCj4+IGluZGV4IGE4ZjQ0NTM4YTg3YS4uYjc5YTQ2MzliMjgzIDEwMDY0NA0KPj4gLS0tIGEv
ZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0
L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+PiBAQCAtMTAzLDE0ICsxMDMsMTMgQEANCj4+ICAg
DQo+PiAgIC8qIENoaXAtc3BlY2lmaWMgZGF0YSBhbmQgbGltaXRzICovDQo+PiAgICNkZWZpbmUg
UlRMODM2NU1CX0NISVBfSURfODM2NU1CX1ZDCQkweDYzNjcNCj4+IC0jZGVmaW5lIFJUTDgzNjVN
Ql9DUFVfUE9SVF9OVU1fODM2NU1CX1ZDCTYNCj4+ICAgI2RlZmluZSBSVEw4MzY1TUJfTEVBUk5f
TElNSVRfTUFYXzgzNjVNQl9WQwkyMTEyDQo+PiAgIA0KPj4gICAvKiBGYW1pbHktc3BlY2lmaWMg
ZGF0YSBhbmQgbGltaXRzICovDQo+PiAgICNkZWZpbmUgUlRMODM2NU1CX1BIWUFERFJNQVgJNw0K
Pj4gICAjZGVmaW5lIFJUTDgzNjVNQl9OVU1fUEhZUkVHUwkzMg0KPj4gICAjZGVmaW5lIFJUTDgz
NjVNQl9QSFlSRUdNQVgJKFJUTDgzNjVNQl9OVU1fUEhZUkVHUyAtIDEpDQo+PiAtI2RlZmluZSBS
VEw4MzY1TUJfTUFYX05VTV9QT1JUUwkoUlRMODM2NU1CX0NQVV9QT1JUX05VTV84MzY1TUJfVkMg
KyAxKQ0KPj4gKyNkZWZpbmUgUlRMODM2NU1CX01BWF9OVU1fUE9SVFMgIDcNCj4+ICAgDQo+PiAg
IC8qIENoaXAgaWRlbnRpZmljYXRpb24gcmVnaXN0ZXJzICovDQo+PiAgICNkZWZpbmUgUlRMODM2
NU1CX0NISVBfSURfUkVHCQkweDEzMDANCj4+IEBAIC0xODI3LDkgKzE4MjYsMTggQEAgc3RhdGlj
IGludCBydGw4MzY1bWJfc2V0dXAoc3RydWN0IGRzYV9zd2l0Y2ggKmRzKQ0KPj4gICAJCWRldl9p
bmZvKHByaXYtPmRldiwgIm5vIGludGVycnVwdCBzdXBwb3J0XG4iKTsNCj4+ICAgDQo+PiAgIAkv
KiBDb25maWd1cmUgQ1BVIHRhZ2dpbmcgKi8NCj4+IC0JcmV0ID0gcnRsODM2NW1iX2NwdV9jb25m
aWcocHJpdik7DQo+PiAtCWlmIChyZXQpDQo+PiAtCQlnb3RvIG91dF90ZWFyZG93bl9pcnE7DQo+
PiArCWZvciAoaSA9IDA7IGkgPCBwcml2LT5udW1fcG9ydHM7IGkrKykgew0KPj4gKwkJaWYgKCEo
ZHNhX2lzX2NwdV9wb3J0KHByaXYtPmRzLCBpKSkpDQo+PiArCQkJY29udGludWU7DQo+IA0KPiBk
c2Ffc3dpdGNoX2Zvcl9lYWNoX2NwdV9wb3J0KGNwdV9kcCwgZHMpDQo+IA0KPj4gKwkJcHJpdi0+
Y3B1X3BvcnQgPSBpOw0KPj4gKwkJbWItPmNwdS5tYXNrID0gQklUKHByaXYtPmNwdV9wb3J0KTsN
Cj4+ICsJCW1iLT5jcHUudHJhcF9wb3J0ID0gcHJpdi0+Y3B1X3BvcnQ7DQo+PiArCQlyZXQgPSBy
dGw4MzY1bWJfY3B1X2NvbmZpZyhwcml2KTsNCj4+ICsJCWlmIChyZXQpDQo+PiArCQkJZ290byBv
dXRfdGVhcmRvd25faXJxOw0KPj4gKw0KPj4gKwkJYnJlYWs7DQo+PiArCX0NCj4+ICAgDQo+PiAg
IAkvKiBDb25maWd1cmUgcG9ydHMgKi8NCj4+ICAgCWZvciAoaSA9IDA7IGkgPCBwcml2LT5udW1f
cG9ydHM7IGkrKykgew0KPj4gQEAgLTE5NjAsOCArMTk2OCw3IEBAIHN0YXRpYyBpbnQgcnRsODM2
NW1iX2RldGVjdChzdHJ1Y3QgcmVhbHRla19wcml2ICpwcml2KQ0KPj4gICAJCQkgImZvdW5kIGFu
IFJUTDgzNjVNQi1WQyBzd2l0Y2ggKHZlcj0weCUwNHgpXG4iLA0KPj4gICAJCQkgY2hpcF92ZXIp
Ow0KPj4gICANCj4+IC0JCXByaXYtPmNwdV9wb3J0ID0gUlRMODM2NU1CX0NQVV9QT1JUX05VTV84
MzY1TUJfVkM7DQo+PiAtCQlwcml2LT5udW1fcG9ydHMgPSBwcml2LT5jcHVfcG9ydCArIDE7DQo+
PiArCQlwcml2LT5udW1fcG9ydHMgPSBSVEw4MzY1TUJfTUFYX05VTV9QT1JUUzsNCj4+ICAgDQo+
PiAgIAkJbWItPnByaXYgPSBwcml2Ow0KPj4gICAJCW1iLT5jaGlwX2lkID0gY2hpcF9pZDsNCj4+
IEBAIC0xOTcyLDggKzE5NzksNiBAQCBzdGF0aWMgaW50IHJ0bDgzNjVtYl9kZXRlY3Qoc3RydWN0
IHJlYWx0ZWtfcHJpdiAqcHJpdikNCj4+ICAgCQltYi0+amFtX3NpemUgPSBBUlJBWV9TSVpFKHJ0
bDgzNjVtYl9pbml0X2phbV84MzY1bWJfdmMpOw0KPj4gICANCj4+ICAgCQltYi0+Y3B1LmVuYWJs
ZSA9IDE7DQo+PiAtCQltYi0+Y3B1Lm1hc2sgPSBCSVQocHJpdi0+Y3B1X3BvcnQpOw0KPj4gLQkJ
bWItPmNwdS50cmFwX3BvcnQgPSBwcml2LT5jcHVfcG9ydDsNCj4+ICAgCQltYi0+Y3B1Lmluc2Vy
dCA9IFJUTDgzNjVNQl9DUFVfSU5TRVJUX1RPX0FMTDsNCj4+ICAgCQltYi0+Y3B1LnBvc2l0aW9u
ID0gUlRMODM2NU1CX0NQVV9QT1NfQUZURVJfU0E7DQo+PiAgIAkJbWItPmNwdS5yeF9sZW5ndGgg
PSBSVEw4MzY1TUJfQ1BVX1JYTEVOXzY0QllURVM7DQo+PiAtLSANCj4+IDIuMzQuMA0KPj4NCg0K
