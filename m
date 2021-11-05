Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091BC44643C
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhKENkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:40:04 -0400
Received: from mail-eopbgr1410134.outbound.protection.outlook.com ([40.107.141.134]:37816
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229924AbhKENkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 09:40:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYNSLz7SE4J8wyUfpgKEtW9ZuE45VsXMaEnfnACd9uv3JxfSfLKhh+frHu76vXVRZCATutkfqeo5Vg2XsSfn4fdeXagFYI1/RUxvm0gjqBBR7++fj0pNxrYP2z/QYtPUwRxaE6erkxW7yV3jCuJmhfbGJLwdT8qgbUsEPdGH1QeQQKUR4+1UaOtO5UP0wN4BqLvm8IVUA7YLVlOsOvtRrFyN+cqC3UjEeJuxJiQD6c+VaK3wxWCVWpjAF0pOQzelQBaxCEreiTabHfYyfEydoL646s/ErynGmuRELACxZb0vd/s+pt+/RgzrXHLDw39bJ8AS2GWF5YyjqFyy1dUEKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4IjobilcApVEZtmEgUePVAmMH0EanOy9/tzj6Qggm4=;
 b=GdcpV7Zxb7TOWsiSTZ95wV5o/iE0xf5JY+txcx/UecYtI43nlNWD2/FvppEyYEk7uydNVj6x5VLRIkgz4co+n0vDk0nKRmn5kLrNPLRILmwmSGtm/WcvfkA4HrgQH+sUpImicUfUHtxveeepv+n1Fx28hC7ILM0XR8MI4Pr3aE4q4QATcl/mhxAd2bUqpjBVC/SOS4GlLi0w1X05W+pKa3vvfFSNAS9WoWyJ3t4MZy4/WaNXROCpfULNRaBoFVVfO67i/0LVt2QyfMaDXK5yeNPNnKZUCLY2RREzSA4ywxsVAXmPhEBu2Cuj9prM76pbGKmx9sHvOyxxfxScR17Aqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.ust.hk; dmarc=pass action=none
 header.from=connect.ust.hk; dkim=pass header.d=connect.ust.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.ust.hk;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4IjobilcApVEZtmEgUePVAmMH0EanOy9/tzj6Qggm4=;
 b=i/REP1Ve8B6RdfaAYrrOndkg2s1YxySAwN2RJph272scdZoTrvNunqPV64YVR/ByOIeRoQPmr4SyqB8LEXsDUbTTU4bWEPw8J0PtvvxgoIvtFAExLFmg9F3yG4CUAWCLvbCx/4Jjv8Q20ScYuFCk6CdkZL8qDcyOZq9P6YWWsN4=
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:b7::8) by
 TYYP286MB1248.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:d7::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Fri, 5 Nov 2021 13:37:22 +0000
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04]) by TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04%6]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 13:37:22 +0000
From:   YE Chengfeng <cyeaa@connect.ust.hk>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "krzysztof.kozlowski@canonical.com" 
        <krzysztof.kozlowski@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wengjianfeng@yulong.com" <wengjianfeng@yulong.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogbmZjOiBwbjUzMzogc3VzcGVjdGVkIGRvdWJsZSBmcmVlIHdoZW4g?=
 =?gb2312?B?cG41MzNfZmlsbF9mcmFnbWVudF9za2JzKCkgcmV0dXJuIHZhbHVlIDw9IDA=?=
Thread-Topic: nfc: pn533: suspected double free when
 pn533_fill_fragment_skbs() return value <= 0
Thread-Index: AdfSJhbChn+moLKRRQKXKwLgcIIbAAAGPrKAAALGd/A=
Date:   Fri, 5 Nov 2021 13:37:21 +0000
Message-ID: <TYCP286MB11884A0B03028EC1BF021FCB8A8E9@TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB1188FA6BE2735C22AA9C473E8A8E9@TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM>
 <20211105121715.GB2026@kadam>
In-Reply-To: <20211105121715.GB2026@kadam>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=connect.ust.hk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d368f2d-86bd-4fcd-bbfd-08d9a0616554
x-ms-traffictypediagnostic: TYYP286MB1248:
x-microsoft-antispam-prvs: <TYYP286MB12483AB9CF9ADD25AD6E3DF88A8E9@TYYP286MB1248.JPNP286.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PF44P5TaW0aB0VstcbZvXn02h+LsoPOjErKdeTvB6mnbS4YzIbzxjfp2Ed+AZtnPcJUbcJisRyKaHl3WqxaC4BeFoBh9ARj7w1kLYGWDimayydmvmnJRV1ynWuCUmPRHaSSFPRqfse0wN6FclRIyLGvcMLl4KU9r3ISbQuQDjOR9UTX8WmnZ16+A1XC+Crh+fsmwBdsWfk76Z3fk5iBv4SUu5PnoRNXJdaEMJIezW5Ogeld2TQ34R3uKWDEMZV1rUgovUT5RrXg02xHmkMRc4d8zL9zHXDgxNAFzOCrt92Kh4dzdoxEVRIOdsStzNj6Q0shdF5ZkVSTkKpgTZ8+ToyCAy7OhbzstJfC7W5fbnKlgaAVfju9baqeVMT6WAv2qnWsrO6w+2Qz8JFztMEuCe1jLNa2zbupXBeWPrl176c5L7gVOBKoOZc6jlnc6sjJdk0x0GuRZam8sHpjHCc8rIFRLNv4eCDknmSjp3iT1HDUTYppGAYFFw0UcrFD1q1yWN1NdTlCBCiJ+5HpyTT0hRCdb1YMoJ9v+tcDNpUsaCqkwTXzZAY57U4eKrHkR3BNShm3fCj+hKukwy4V+dnjoWKlkQCYiz6LDqlqSAgSGaKJ+tpXhuiSClfJSsNWN1hA+aygM4bpkw9gBIObZsWfYBZ6qaUw47kLDG5zx1+c0TJbw5n7VUw5caZyA+0H8aiyQCfYD9DaYP0iV9iH/csh030lm0af5Blq3taqrlY1VjSG/U+25kdcZpSmwUSjYrQ5j0J0sFTO0m1YTrJ6odDZo+FoVtQOmuuZP4wN/4DUA0TE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(4326008)(38100700002)(66446008)(224303003)(52536014)(66476007)(66946007)(64756008)(66556008)(8936002)(86362001)(45080400002)(966005)(122000001)(54906003)(498600001)(83380400001)(5660300002)(71200400001)(2906002)(55016002)(186003)(6916009)(33656002)(26005)(9686003)(38070700005)(6506007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Z0NjNk1oY1pZUmxaMjlmNFFmRWtQQWllRUJ5K2dlU003dXJMZDB1ZzVDZ3oz?=
 =?gb2312?B?M25NMUlqbjFpanpxdE5DNnFnWWFGYkgySTE2bzlDQktHYTI3THBqV1FMTWJE?=
 =?gb2312?B?cXIzcVVVbXF2Z0pLMlErRU00UXBPSFZJUmYwRUllSnFwY3FGT0JzenMwMnBV?=
 =?gb2312?B?d0xudlhEdTBWQmFPd01GTU5TUmN3Vkt4clJSZzY4cU1Veng4MHFwQUtCdmFP?=
 =?gb2312?B?cWNFancrRjYrVittUlRkQjJLTmZBeGtYcHpBSWhaNkZpK1Bta1I0ZHJoT01s?=
 =?gb2312?B?WitkSlh2SnJubDFyQVVraUJxbElZNS9STW1HMGxYa0FNUkZUT3UzN1FJT2FL?=
 =?gb2312?B?cHoyanJ4S0RVWHVQanlQZHVFTnhrT0lRMitXRDJHdmhEWHljeVhkbkNCM2RW?=
 =?gb2312?B?N0hqRWEyN2hXTFo2T0RDM282TEgyT0dLcnhSYVQwb0NXY3ByMWtmV1hQa3o0?=
 =?gb2312?B?amR6OXB1dmoxem1XbGxqb3lieEw4ZzNJelRoR1BDRExBbmtwVlFtQzZtWFRj?=
 =?gb2312?B?S29xUWdybEJxbGxzaVpaS0VvRHFXcXR0N1ZJdVZzeURyeVFBbjc5WjhYRkY3?=
 =?gb2312?B?MkFRYVUrcUpmVDg5Q0IxaHl0dEM5bm9RYmljbThVUE9DTTZBN3hLbm5jbHJD?=
 =?gb2312?B?cG9valRQcWc1WU1FcnNrZDc4TVF0Y3VxYzExREhhY3hab3VuWCt4cFFyZnIv?=
 =?gb2312?B?L0RtelkzemRkRUgrd1hWclNYRUJKNlUrNzRPbm9pMnA4K1VnWjh4RTNrdTQ2?=
 =?gb2312?B?V2hjdGdFNVRFeVVFUUVOL1NzQkNzZnF4V3pTRk9ZcklXNDYwUStFQ0VSWitw?=
 =?gb2312?B?R2QwL1B4VFVOUmFUbXF6S2x2R3VLWitwS081aUR5VTdXVzFuQVRmcHZOVGR6?=
 =?gb2312?B?ZnV1WnJMOWtYSFNVYnFlUmhMVVRxQnp3K09wK1NrdlpxVmM5c2xOTjJUWUlB?=
 =?gb2312?B?bWJnQ29JNldtN1ExbWFWUVMwZnVmRElxNHBZTEdKNXV2YTNkbHc0RGJtcTM1?=
 =?gb2312?B?TXNtUlpudHFkempCZkM5ayttclUycXZEQnIrTUNmYzVEamE4VFVZeGpnZ2ZB?=
 =?gb2312?B?NlVvRWRXS0ZhYnc1UFRiOEMvc0lFcmxTY0dweFZSMHR6M0xmV20zMnQxWjIz?=
 =?gb2312?B?cndkS1R6bHJjL2xBZ1c3Tys1ZzBBK09rSlNyc0h6K3V5MVkxNDlGRWdkR0hs?=
 =?gb2312?B?MkRtMW5ZOCttem4xcGJIWFFoY2Q0ZGFva21HSFNiU1RLZHVweEQ4SFdMVm5m?=
 =?gb2312?B?b3N4N3lmQm15c3g1bTU4L1JDdHBrcUZWNEdMV3lJM2xZUEdFTGxQdlluSnhY?=
 =?gb2312?B?YlNhdld6OXFaZnhwQ1ZLQjJ5eHNiamt4Q2tGZFJhWUdvYWcyWE9tN1htcDFn?=
 =?gb2312?B?VW5aWHk4cG40L09GZDFIc0NOWnpEdkxvdGFqeCtoWlhMWjd2bHh5ZEliVU5D?=
 =?gb2312?B?MGd4RlUrRFhrdUpCZzVZUmpZSTJJRGhTdWN4Mlo2MW04a3NYTit5ZlphTGtv?=
 =?gb2312?B?ZzRtR2U5VTJBNy92d0tkcmpSY3phTS9taTlYKytkNFpONFNPMmFYQk5sa3By?=
 =?gb2312?B?dDhuaGxkMzZqVlk3emE0K3V1Z2ZOYXh5aWlkWVg3c05Gai9Ta1gvdUxGS3Z4?=
 =?gb2312?B?WFdjM0ZLR3psL1cwWktudFdhUDZFbXpwbGRMWmhyKy9TSFJaQnljdzJTZFp1?=
 =?gb2312?B?b281K1ZGTkhtYWJKZnVJa2h3cmJCQm9LNUZpNVowdG5hUERVQmJuZ01GdG5l?=
 =?gb2312?B?R3podEtSL2xTNW5xWWx3RlVlZFExdG5ZcXEySEhJNlZFWmRNY2Q1b2hkN3lj?=
 =?gb2312?B?Rmk0QkRsYnBMZG16UzhiVmE1TytqaitNU1h5ak1HczVDK0NHRVF2dnhJSlNX?=
 =?gb2312?B?b3pYaHFRSUNXaFNhZmIwcTFaVWpLR1JYM3NMWHVnZUphRGQwQ2Y5NjF1c0ts?=
 =?gb2312?B?ZXB5dkM4cC9oNU0vU2l0Q0tQaEFQODNOWHlUVDduc2d2ZjNERW8vMERkUGFP?=
 =?gb2312?B?aStFSTE4dUFZckxFdG5FVDBEa3pVakprckhPbTRYTE8vdFp1TE1ON1lyWlAz?=
 =?gb2312?B?QWF2d21uSGFRYkcwWVZtZzJKbHFqb05HWGpQZ3ozM0tlTXVxcXpKbnk0cHRI?=
 =?gb2312?B?Z1VQYVlxNTd0RHUyWGVQcVN6SDU2NmI1ckYra01wTzlHZ1IvMHRRTXY0anVt?=
 =?gb2312?B?aEE9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: connect.ust.hk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d368f2d-86bd-4fcd-bbfd-08d9a0616554
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 13:37:21.9062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6c1d4152-39d0-44ca-88d9-b8d6ddca0708
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZN7KcxBkWV8CU7z6LnX5yH/EQKs/P9oOoYUKcgSyt7laQqqapyz+0hVoC3CkEoySzSOd61BRrorP6hSre6I4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYP286MB1248
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIGFkdmljZS4gSSBmb2xsb3cgaXQgYW5kIHNlbmQgYSB2MiBwYXRjaCwg
aXMgaXQgY29ycmVjdD8NCg0KQmVzdCByZWdhcmRzLA0KQ2hlbmdmZW5nDQoNCi0tLS0t08q8/tSt
vP4tLS0tLQ0Kt6K8/sjLOiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+
IA0Kt6LLzcqxvOQ6IDIwMjHE6jEx1MI1yNUgMjA6MTcNCsrVvP7IyzogWUUgQ2hlbmdmZW5nIDxj
eWVhYUBjb25uZWN0LnVzdC5oaz4NCrOty806IGtyenlzenRvZi5rb3psb3dza2lAY2Fub25pY2Fs
LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgd2VuZ2ppYW5mZW5nQHl1bG9uZy5jb207IGt1YmFA
a2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZw0K1vfM4jogUmU6IG5mYzogcG41MzM6IHN1c3BlY3RlZCBkb3VibGUgZnJlZSB3aGVu
IHBuNTMzX2ZpbGxfZnJhZ21lbnRfc2ticygpIHJldHVybiB2YWx1ZSA8PSAwDQoNCk9uIEZyaSwg
Tm92IDA1LCAyMDIxIGF0IDA5OjIyOjEyQU0gKzAwMDAsIFlFIENoZW5nZmVuZyB3cm90ZToNCj4g
SGksDQo+IA0KPiBXZSBub3RpY2UgdGhhdCBza2IgaXMgYWxyZWFkeSBmcmVlZCBieSBkZXZfa2Zy
ZWVfc2tiIGluIA0KPiBwbjUzM19maWxsX2ZyYWdtZW50X3NrYnMsIGJ1dCBmb2xsb3cgZXJyb3Ig
aGFuZGxlciBicmFuY2ggI2xpbmUgMjI4OCANCj4gYW5kICNsaW5lIDIzNTYsIHNrYiBpcyBmcmVl
ZCBhZ2Fpbiwgc2VlbXMgbGlrZSBhIGRvdWJsZSBmcmVlIGlzc3VlLg0KPiBXb3VsZCB5b3UgbGlr
ZSB0byBoYXZlIGEgbG9vayBhdCB0aGVtPw0KPiANCj4gaHR0cHM6Ly9hcGMwMS5zYWZlbGlua3Mu
cHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGZ2l0aA0KPiB1Yi5jb20l
MkZ0b3J2YWxkcyUyRmxpbnV4JTJGYmxvYiUyRm1hc3RlciUyRmRyaXZlcnMlMkZuZmMlMkZwbjUz
MyUyRnBuDQo+IDUzMy5jJTIzTDIyODgmYW1wO2RhdGE9MDQlN0MwMSU3Q2N5ZWFhJTQwY29ubmVj
dC51c3QuaGslN0MyOWRmNzJkMWY4YTMNCj4gNDQ3M2ExNTAwOGQ5YTA1NjQyY2YlN0M2YzFkNDE1
MjM5ZDA0NGNhODhkOWI4ZDZkZGNhMDcwOCU3QzElN0MwJTdDNjM3Nw0KPiAxNzExNDYyNDAxNjUy
MCU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJs
DQo+IHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMTAwMCZhbXA7c2RhdGE9
OW5zc1ZJNU50eUVVdm5INmsNCj4gTlA2MGRxU210Z2ZXSUxvS1hpbWNKV0lpS2MlM0QmYW1wO3Jl
c2VydmVkPTANCj4gDQoNClRoZSBjb2RlIGlzIGJ1Z2d5LCB5ZXMsIGJ1dCBpdCdzIGEgYml0IHRy
aWNreSB0byBmaXguDQoNCnBuNTMzX2ZpbGxfZnJhZ21lbnRfc2ticygpIG5ldmVyIHJldHVybnMg
ZXJyb3IgY29kZXMsIGl0IHJldHVybnMgemVybyBvbiBlcnJvci4gIFNwZWNpZmljYWxseSBpdCBj
bGVhcnMgb3V0IHRoZSAmZGV2LT5mcmFnbWVudF9za2IgbGlzdCBhbmQgdGhlbiByZXR1cm5zIHRo
ZSBsZW5ndGggb2YgdGhlIGxpc3QgInNrYl9xdWV1ZV9sZW4oJmRldi0+ZnJhZ21lbnRfc2tiKSIN
CndoaWNoIGlzIG5vdyB6ZXJvLg0KDQpSZXR1cm5pbmcgc3VjY2VzcyBvbiB0cmFuc21pdCBmYWls
dXJlIGlzIGZpbmUgYmVjYXVzZSB0aGUgbmV0d29yayBzdGFjayB0aGlua3MgaXQgd2FzIGxvc3Qg
c29tZXdoZXJlIGluIHRoZSBuZXR3b3JrIGFuZCByZXNlbmRzIGl0LiAgQnV0IHByb2JhYmx5IGl0
IHNob3VsZCByZXR1cm4gLUVOT01FTT8gIEJ1dCBjaGFuZ2luZyB0aGUgcmV0dXJuIHdvdWxkIG1h
a2UgdGhlIG90aGVyIGNhbGxlciBpbnRvIGEgZG91YmxlIGZyZWUgbm93Lg0KDQpTbyBwcm9iYWJs
eSB0aGUgY29ycmVjdCBmaXggaXMgdG8NCjEpIE1ha2UgcG41MzNfZmlsbF9mcmFnbWVudF9za2Jz
KCkgcmV0dXJuIC1FTk9NRU0gb24gZXJyb3INCjIpIERvbid0IGNhbGwgZGV2X2tmcmVlX3NrYihz
a2IpOyBvbiBlcnJvciBpbiBwbjUzM19maWxsX2ZyYWdtZW50X3NrYnMoKS4NCiAgIE9ubHkgY2Fs
bCBpdCBvbiB0aGUgc3VjY2VzcyBwYXRoLg0KMykgQ2hhbmdlIHRoZSBjYWxsZXJzIHRvIGNoZWNr
IGZvciBuZWdhdGl2ZXMgaW5zdGVhZCBvZiA8PSAwDQoNCj4gV2Ugd2lsbCBwcm92aWRlIHBhdGNo
IGZvciB0aGVtIGFmdGVyIGNvbmZpcm1hdGlvbi4NCg0KU291bmRzIGdyZWF0LiAgWW91IGNhbiBm
aXggaXQgaG93ZXZlciB5b3Ugd2FudC4gIE15IGlkZWFzIGFyZSBhIHN1Z2dlc3Rpb24gb25seS4N
Cg0KcmVnYXJkcywNCmRhbiBjYXJwZW50ZXINCg0K
