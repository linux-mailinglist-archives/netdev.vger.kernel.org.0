Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B9742AB42
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 19:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhJLRyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 13:54:44 -0400
Received: from mail-eopbgr1400121.outbound.protection.outlook.com ([40.107.140.121]:3136
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232349AbhJLRyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 13:54:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZp0ENQ3lmZSZslt8ubg5XVnV6LniK+q1Ex6r9+L1H1lLhVE4acvh4XwX975POLR/HP+yGQebup3i5aTnbZtJGmS+J3/8QxgWt1hWM/5WvG8kIVwlwMS1Q5IWNO7hZWEj70BuS8H8d4pDiAvKBbi36WbmrcuwgMbEk4G5dtBcPZEY8gJCz6RK6drV83ZpPV8szX6I57t0UJgeMpBufDYB/Quih6Ki0/c2cIKKWIgpL+zRfTJaPvhyXNNOheCq9IM6vsD4I9etkBnx3GePurwHZuKicodW+WDqI1Tk1Gihn2wK1jJI6LwuhHIrcqw7HT+g+6rPucJcaYKF43o3nAdzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nnmPwHEf0a+Ql5N8JJaplCeObUuw0SvjB/oTaGRIPUo=;
 b=VLyURO9oER+OGNTza0trh69T6WxfqJsHppBvDxmoUNV4IjUB4dcY0hH/V0h4Z5H+L7IFTT1dr42BsopYHPpmseUeFu70c7cN6ATVRkOTUSockrgCofQ/NXUbSgQbUO7g/UkCc3qwGOt6F9qy4uMGvQo+9ANuhoLTOnUOSnJkdDXRuEgErTJMRxanSdo5mvRaWMmD1Io7/Behket+zP/XQ7xvwhFaPvN04bIWZ+PdVShhMTtdK7CpR81929fGt7lRYYqKyaPmk241nZ70e8BDUB1o6sCdBPWa8sHwBggM6fessJPTn5xFMKplot+1EjTAk1ChhYd4LXiWWKj9be/xfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnmPwHEf0a+Ql5N8JJaplCeObUuw0SvjB/oTaGRIPUo=;
 b=nnU0Hy/c8/4mfJCJAaGmVLbqUCsdiTDsRB4sNUeGcb1k7Sfa2Xic2DTldZkuTCyVd2PRCqgtuLwZp0zMOJmyj4XSeGFG4s1VpVEji/EMwYZYsgo+hUR6AUtyC36Oy5m8YcSdTqfohQYo6giO5GWW3wS1wbIK8OEb1lVbY5Jskog=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6487.jpnprd01.prod.outlook.com (2603:1096:604:e1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14; Tue, 12 Oct
 2021 17:52:31 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 17:52:31 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
Thread-Topic: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
Thread-Index: AQHXv4dnnKNAfP5bNkuTvIq9GdANz6vPn6iAgAAEiTA=
Date:   Tue, 12 Oct 2021 17:52:31 +0000
Message-ID: <OS0PR01MB59220334F9C1891BE848638D86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
 <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
 <b06ad74a-5ecd-8dbf-4b54-fc18ce679053@omp.ru>
In-Reply-To: <b06ad74a-5ecd-8dbf-4b54-fc18ce679053@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0b809dd-548c-4395-8ddd-08d98da9108d
x-ms-traffictypediagnostic: OS3PR01MB6487:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB648719A08CC396BBC180E4E386B69@OS3PR01MB6487.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yaAm/FpjS4PdB7vIEwgVNoa5ZSQ9+SQaNbPiliQkfbb5voRQesrBm1GMFMXoiidAR3QC+9+wevTQ7aM5wEjxfIxKpgGd4yhXii3GeoDV/xhIdNo+RFGJ2pNTzhiyGXMYcQL7SjU2Yu+E5ftfEfqMlaTSRrrF1ptg8+P9xQbSMj8T5d8ycO2J7Zouj5VtY/l7X+JKgQm7Appmr9iwj+r3PkuPbO3or669N50heRyasVJTJcRowBLLHsGP8C50VLJ8e5vLC5OHMqMECr3lszhP6bqdzCZ1W5cmOOMg9RpuR5neSLPFep71ahwnrZCx2dvkyND2NTUlPa411hdcscEu9/71pGza+DNiyu46rW1lDdtDFSP5hAKQygPqUUfitCZ7YWVbgPILHnwjVScabU/W8sSI69/ynQOOK/tFqsaOIk318IvnMlY/f7gxIbom3Hvv+EcA9NyyLQ3+nKZsYkphImD5DLRg0MYdh4inwLeKYFvUwJkc0LraOZeNmXPYQ218FGvtEnEG/f4QSkYaJ/qYEbFfXA6kaOYi8NSj4TVxT2WT5nlDxaxmLY2CvZS5cTu5EzfFlqhCKtIDpl4w0AVAnLDadPw5PTCi6eM8BO92+jf835bMAxYusBL4r2ae6M1r0UcGI8bHl0PS7YGxBDK5dYfJ3cli/VvMT4SGm95D4zhvYC4R8+FnJ9y4Ai9/W0UO7+JgDBwP9afmFGXS1loC8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(38070700005)(110136005)(71200400001)(8676002)(8936002)(316002)(186003)(54906003)(7416002)(107886003)(86362001)(508600001)(33656002)(66556008)(15650500001)(52536014)(122000001)(38100700002)(66946007)(55016002)(26005)(76116006)(53546011)(6506007)(9686003)(83380400001)(4326008)(2906002)(66476007)(5660300002)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnBBYlJoNVdhZ05GSmJxL09DS2pqZU52SzRZdGFjZ3BCQ0poWXNhRXRwN2tW?=
 =?utf-8?B?cnZVTHRxTkhTdTg4YytvSHM5b25FQnQ4WHdjNTZkSm01alBtYWZVcm9yNWpq?=
 =?utf-8?B?YlpjZE1Ca0htOTZ1cGtISnM3VXZlcjFxd1h4Y1Q3bTV1THZ3bjQreXVaMEFv?=
 =?utf-8?B?bVpMeGcwVmV3QVNoTlZhTk9VNUNoUHlnMGlYMi93MmpNNHhkNDdTZm5oUC9p?=
 =?utf-8?B?N2VMdEMvMGgxRGd3SXJmbnFuc3Y2aVR3VEM4QzV2eXIzcDZoNmYzZFE1MkVW?=
 =?utf-8?B?alZYemtsRzZRZWh5dkZpdlZhQzl2Z1phRW9nZldoYzF2RmFFRjZnZlpwSzJl?=
 =?utf-8?B?cE5OYmhiVDVMZHplaHNveUE0ek42TWc2VnhpZkozQW00N1JlM1p2VldlbElz?=
 =?utf-8?B?VldhbFdNTGQ4ZGJFM1ZaMFlRRmxGSVhGOTFpRHM2ZS9UWFpyVGliaDFXVldD?=
 =?utf-8?B?QkxpVVcxaTJWOXJaODQ2L1BjcUhkUm00MFhpRHVVcW1xeDZpbDVhYWN6MlVW?=
 =?utf-8?B?Ulc4dFFqM2w3QVFnT3BqdFI5SmtnMnk1bG5qMUMrQ1N5UmdaTkdSR1dHSnVv?=
 =?utf-8?B?TU1BR3BCN2hwNXRNekVpclE2RitqK1hzMWRoM1ZzZHA3eHlHSUNEVmk2cTJr?=
 =?utf-8?B?TUJOa1llcm5xTkg4STlxNkJSVkF2RnN0d2J1N2w3ZXp1MktaK3kydEEyWFpl?=
 =?utf-8?B?Mml0S0V0Q201OEJNOUxzbzFhcS9qODR4UVNHbVhnUVFGcS9IYWo5eTdiMEhL?=
 =?utf-8?B?Wkp6OENiR1UyTWZ3NnFYU1VXL2lkV2pjdjJQRlB4U1o0alN5NzNQMU9xa2R6?=
 =?utf-8?B?d0NES21PUjlqMVpnZnJjNWovcVFlNkI0cjRYeVVMcVVEbjVjRGxOYTBkZkZL?=
 =?utf-8?B?WGhaODhVeTl2aTB0WDJ1bGJaVkZWRXNHRExoNUNoR2dUdldCaFNxZnZEUWk0?=
 =?utf-8?B?endXY1QyQ3M0WE5QcXFYRERxNTk0REZBaWVKajl1VEk5RHVScGl6K3VMY0RO?=
 =?utf-8?B?cjJUVDZTcTZWaXJxeDhNdlNYQXB3aEdsZmRESkZnY2VoSldTVzRkalM4dFNY?=
 =?utf-8?B?WXFVb0NRSHJ0Sk02cGo0WFZEZm44M21PL2hXVzYrdWVrbDBjZnh6ZWY5dlNn?=
 =?utf-8?B?WWtmLy91NTQ3NC9ueEhQZGJUcjRtdUZSNkFDRzdiYU5xUnd2Q2N5QlhGQlNm?=
 =?utf-8?B?c20vNkN6ZUh5ZGRsekRRSG9qTDdmSEFFMzRRWGNORW5CbTRBbGNlOTVmUTdL?=
 =?utf-8?B?ZEFaMEovelJ0RG5OT20wdlVrM3RQMlRnNkRwbzljYjV5UFd0VllBVVZiSmRD?=
 =?utf-8?B?TExTK0hvQkZtVkVocXE3cFdubzE5NHQzU1N5UitxaWZJWkNlV3BDM3gzMXM1?=
 =?utf-8?B?Skg3VmI4bTM5WExpa2p4elBIS2FtRE5JRWNHWHhWMGFTMmEvdlpVd2FpeGtI?=
 =?utf-8?B?TGJoaXdKRmZGUC9xUkk3Ry9IOUM5MjRMNTd2b0d5MmZjMXVKQklMMElvdTBS?=
 =?utf-8?B?QWdYZjNoRmtDVnhUR3BlU3daZFVFSGhIZ081MkRXcmNqQnQ2UGtUcTVTNCtz?=
 =?utf-8?B?dGZKVnFycVI1c25RSVNKY2UvSngvYzE1V0NQVnZIbUZnNHlrbERoVS9RUnRz?=
 =?utf-8?B?cko1M3crbXFuVGtBZVhVNWplV2tZcG9HSEozcDUrNi9HNVVod29FdkIybFF0?=
 =?utf-8?B?UVQ1SnNEVWxod3JveG5hN2RUWDlwQnNTbmV0aTZLNXVabys0MDBaK2tubW9w?=
 =?utf-8?Q?BVOWc/EpkSZCGPu2R0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b809dd-548c-4395-8ddd-08d98da9108d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 17:52:31.5122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZQ4Gw8RoB+lXkE3/m4fzLrEiYY8VbyubjV1QaeRN2ZpQP1BuweRLEjfKWSJHc9Fw5218ibX0YiJews/zQ08OIPtnqI01FzVFlGBfcBAIW4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6487
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYzIDEzLzE0XSByYXZiOiBVcGRhdGUgcmF2Yl9lbWFjX2luaXRfZ2Jl
dGgoKQ0KPiANCj4gT24gMTAvMTIvMjEgNzozNiBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+
IFRoaXMgcGF0Y2ggZW5hYmxlcyBSZWNlaXZlL1RyYW5zbWl0IHBvcnQgb2YgVE9FIGFuZCByZW1v
dmVzIHRoZQ0KPiA+IHNldHRpbmcgb2YgcHJvbWlzY3VvdXMgYml0IGZyb20gRU1BQyBjb25maWd1
cmF0aW9uIG1vZGUgcmVnaXN0ZXIuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGFsc28gdXBkYXRlIEVN
QUMgY29uZmlndXJhdGlvbiBtb2RlIGNvbW1lbnQgZnJvbSAiUEFVU0UNCj4gPiBwcm9oaWJpdGlv
biIgdG8gIkVNQUMgTW9kZTogUEFVU0UgcHJvaGliaXRpb247IER1cGxleDsgVFg7IFJYOyBDUkMN
Cj4gPiBQYXNzIFRocm91Z2giLg0KPiANCj4gICAgSSdtIG5vdCBzdXJlIHdoeSB5b3Ugc2V0IEVD
TVIuUkNQVCB3aGlsZSB5b3UgZG9uJ3QgaGF2ZSB0aGUgY2hlY2tzdW0NCj4gb2ZmbG9hZGVkLi4u
DQo+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2Fz
LmNvbT4NCj4gPiAtLS0NCj4gPiB2Mi0+djM6DQo+ID4gICogRW5hYmxlZCBUUEUvUlBFIG9mIFRP
RSwgYXMgZGlzYWJsaW5nIGNhdXNlcyBsb29wYmFjayB0ZXN0IHRvIGZhaWwNCj4gPiAgKiBEb2N1
bWVudGVkIENTUjAgcmVnaXN0ZXIgYml0cw0KPiA+ICAqIFJlbW92ZWQgUFJNIHNldHRpbmcgZnJv
bSBFTUFDIGNvbmZpZ3VyYXRpb24gbW9kZQ0KPiA+ICAqIFVwZGF0ZWQgRU1BQyBjb25maWd1cmF0
aW9uIG1vZGUuDQo+ID4gdjEtPnYyOg0KPiA+ICAqIE5vIGNoYW5nZQ0KPiA+IFYxOg0KPiA+ICAq
IE5ldyBwYXRjaC4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiLmggICAgICB8IDYgKysrKysrDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yl9tYWluLmMgfCA1ICsrKy0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2Fz
L3JhdmIuaA0KPiA+IGluZGV4IDY5YTc3MTUyNjc3Ni4uMDgwNjJkNzNkZjEwIDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBAQCAtMjA0LDYgKzIwNCw3IEBA
IGVudW0gcmF2Yl9yZWcgew0KPiA+ICAJVExGUkNSCT0gMHgwNzU4LA0KPiA+ICAJUkZDUgk9IDB4
MDc2MCwNCj4gPiAgCU1BRkNSCT0gMHgwNzc4LA0KPiA+ICsJQ1NSMCAgICA9IDB4MDgwMCwJLyog
UlovRzJMIG9ubHkgKi8NCj4gPiAgfTsNCj4gPg0KPiA+DQo+ID4gQEAgLTk2NCw2ICs5NjUsMTEg
QEAgZW51bSBDWFIzMV9CSVQgew0KPiA+ICAJQ1hSMzFfU0VMX0xJTksxCT0gMHgwMDAwMDAwOCwN
Cj4gPiAgfTsNCj4gPg0KPiA+ICtlbnVtIENTUjBfQklUIHsNCj4gPiArCUNTUjBfVFBFCT0gMHgw
MDAwMDAxMCwNCj4gPiArCUNTUjBfUlBFCT0gMHgwMDAwMDAyMCwNCj4gPiArfTsNCj4gPiArDQo+
IA0KPiAgIElzIHRoaXMgcmVhbGx5IG5lZWRlZCBpZiB5b3UgaGF2ZSBFQ01SLlJDUFQgY2xlYXJl
ZD8NCg0KWWVzIGl0IGlzIHJlcXVpcmVkLiBQbGVhc2Ugc2VlIHRoZSBjdXJyZW50IGxvZyBhbmQg
bG9nIHdpdGggdGhlIGNoYW5nZXMgeW91IHN1Z2dlc3RlZA0KDQpyb290QHNtYXJjLXJ6ZzJsOi9y
emcybC10ZXN0LXNjcmlwdHMjIC4vZXRoX3RfMDAxLnNoDQpbICAgMzkuNjQ2ODkxXSByYXZiIDEx
YzIwMDAwLmV0aGVybmV0IGV0aDA6IExpbmsgaXMgRG93bg0KWyAgIDM5LjcxNTEyN10gcmF2YiAx
MWMzMDAwMC5ldGhlcm5ldCBldGgxOiBMaW5rIGlzIERvd24NClsgICAzOS44OTU2ODBdIE1pY3Jv
Y2hpcCBLU1o5MTMxIEdpZ2FiaXQgUEhZIDExYzIwMDAwLmV0aGVybmV0LWZmZmZmZmZmOjA3OiBh
dHRhY2hlZCBQSFkgZHJpdmVyIChtaWlfYnVzOnBoeV9hZGRyPTExYzIwMDAwLmV0aGVybmV0LWZm
ZmZmZmZmOjA3LCBpcnE9UE9MTCkNClsgICAzOS45NjYzNzBdIE1pY3JvY2hpcCBLU1o5MTMxIEdp
Z2FiaXQgUEhZIDExYzMwMDAwLmV0aGVybmV0LWZmZmZmZmZmOjA3OiBhdHRhY2hlZCBQSFkgZHJp
dmVyIChtaWlfYnVzOnBoeV9hZGRyPTExYzMwMDAwLmV0aGVybmV0LWZmZmZmZmZmOjA3LCBpcnE9
UE9MTCkNClsgICA0Mi45ODg1NzNdIElQdjY6IEFERFJDT05GKE5FVERFVl9DSEFOR0UpOiBldGgw
OiBsaW5rIGJlY29tZXMgcmVhZHkNClsgICA0Mi45OTUxMTldIHJhdmIgMTFjMjAwMDAuZXRoZXJu
ZXQgZXRoMDogTGluayBpcyBVcCAtIDFHYnBzL0Z1bGwgLSBmbG93IGNvbnRyb2wgb2ZmDQpbICAg
NDMuMDUyNTQxXSBJUHY2OiBBRERSQ09ORihORVRERVZfQ0hBTkdFKTogZXRoMTogbGluayBiZWNv
bWVzIHJlYWR5DQpbICAgNDMuMDU1NzEwXSByYXZiIDExYzMwMDAwLmV0aGVybmV0IGV0aDE6IExp
bmsgaXMgVXAgLSAxR2Jwcy9GdWxsIC0gZmxvdyBjb250cm9sIG9mZg0KDQpFWElUfFBBU1N8fFs0
MjIzOTE6NDM6MDBdIHx8DQoNCnJvb3RAc21hcmMtcnpnMmw6L3J6ZzJsLXRlc3Qtc2NyaXB0cyMN
Cg0KDQp3aXRoIHRoZSBjaGFuZ2VzIHlvdSBzdWdnZXN0ZWQNCi0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCg0Kcm9vdEBzbWFyYy1yemcybDovcnpnMmwtdGVzdC1zY3JpcHRzIyAuL2V0aF90
XzAwMS5zaA0KWyAgIDIzLjMwMDUyMF0gcmF2YiAxMWMyMDAwMC5ldGhlcm5ldCBldGgwOiBMaW5r
IGlzIERvd24NClsgICAyMy41MzU2MDRdIHJhdmIgMTFjMzAwMDAuZXRoZXJuZXQgZXRoMTogZGV2
aWNlIHdpbGwgYmUgc3RvcHBlZCBhZnRlciBoL3cgcHJvY2Vzc2VzIGFyZSBkb25lLg0KWyAgIDIz
LjU0NzI2N10gcmF2YiAxMWMzMDAwMC5ldGhlcm5ldCBldGgxOiBMaW5rIGlzIERvd24NClsgICAy
My44MDI2NjddIE1pY3JvY2hpcCBLU1o5MTMxIEdpZ2FiaXQgUEhZIDExYzIwMDAwLmV0aGVybmV0
LWZmZmZmZmZmOjA3OiBhdHRhY2hlZCBQSFkgZHJpdmVyIChtaWlfYnVzOnBoeV9hZGRyPTExYzIw
MDAwLmV0aGVybmV0LWZmZmZmZmZmOjA3LCBpcnE9UE9MTCkNClsgICAyNC4wMzE3MTFdIHJhdmIg
MTFjMzAwMDAuZXRoZXJuZXQgZXRoMTogZmFpbGVkIHRvIHN3aXRjaCBkZXZpY2UgdG8gY29uZmln
IG1vZGUNClJUTkVUTElOSyBhbnN3ZXJzOiBDb25uZWN0aW9uIHRpbWVkIG91dA0KDQpFWElUfEZB
SUx8fFs0MjIzOTE6NDI6MzJdIEZhaWxlZCB0byBicmluZyB1cCBFVEgxfHwNCg0Kcm9vdEBzbWFy
Yy1yemcybDovcnpnMmwtdGVzdC1zY3JpcHRzIw0KDQoNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQppbmRleCBmMDhkOGYyYjRkNDEuLmIzNDY3MGE4MTJmZCAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCisrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCkBAIC01MjEsNyArNTIx
LDcgQEAgc3RhdGljIHZvaWQgcmF2Yl9lbWFjX2luaXRfZ2JldGgoc3RydWN0IG5ldF9kZXZpY2Ug
Km5kZXYpDQogDQogICAgICAgIC8qIEVNQUMgTW9kZTogUEFVU0UgcHJvaGliaXRpb247IER1cGxl
eDsgVFg7IFJYOyBDUkMgUGFzcyBUaHJvdWdoICovDQogICAgICAgIHJhdmJfd3JpdGUobmRldiwg
RUNNUl9aUEYgfCAoKHByaXYtPmR1cGxleCA+IDApID8gRUNNUl9ETSA6IDApIHwNCi0gICAgICAg
ICAgICAgICAgICAgICAgICBFQ01SX1RFIHwgRUNNUl9SRSB8IEVDTVJfUkNQVCB8DQorICAgICAg
ICAgICAgICAgICAgICAgICAgRUNNUl9URSB8IEVDTVJfUkUgfCANCiAgICAgICAgICAgICAgICAg
ICAgICAgICBFQ01SX1RYRiB8IEVDTVJfUlhGLCBFQ01SKTsNCiANCiAgICAgICAgcmF2Yl9zZXRf
cmF0ZV9nYmV0aChuZGV2KTsNCkBAIC01MzQsNyArNTM0LDcgQEAgc3RhdGljIHZvaWQgcmF2Yl9l
bWFjX2luaXRfZ2JldGgoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQogDQogICAgICAgIC8qIEUt
TUFDIHN0YXR1cyByZWdpc3RlciBjbGVhciAqLw0KICAgICAgICByYXZiX3dyaXRlKG5kZXYsIEVD
U1JfSUNEIHwgRUNTUl9MQ0hORyB8IEVDU1JfUEZSSSwgRUNTUik7DQotICAgICAgIHJhdmJfd3Jp
dGUobmRldiwgQ1NSMF9UUEUgfCBDU1IwX1JQRSwgQ1NSMCk7DQorICAgICAgIC8vcmF2Yl93cml0
ZShuZGV2LCBDU1IwX1RQRSB8IENTUjBfUlBFLCBDU1IwKTsNCg0KUmVnYXJkcywNCkJpanUNCg0K
PiANCj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
