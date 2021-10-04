Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BEA4216CD
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbhJDStr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:49:47 -0400
Received: from mail-eopbgr1400099.outbound.protection.outlook.com ([40.107.140.99]:41184
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235628AbhJDStq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 14:49:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKGXNh5Pr14YEPFPrEQar3Yg72Z9EubF6yljbU9gEJNMPsgyKraYLrSxwql4ug/Moe5xPpLf5xlgamQABYKIPNcsHYmMor6UcKKQGlmyF8mmk8ngsRhcJXwSudM+XzrJlRsYxflSsn84JU8Vuxrt6S+18ifRThbr7ZePxo8SvnEZ9HbDwj761VjHNnxnppOGC+s82UydqwQhs8C1+OV7x+DC1r/WdWwamANQ0XuttpgoX+3LNyrA+zWMHluY9HC9s7jB25lymXXchWf0HDlCluU9/HYxqrRocxi44naZg3XmrkvV1yAn6riZPnBoUdwpL2fyYYRK2GmWHjEog44SMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ce1O4bhDLx15OQ5yrXeDqVFETHTJbDz4Bzf+Ty/IKAg=;
 b=koa0hUqe0uosx4vOrOOOjv+mFix87oW7U4PUXixoTHWTe0iBUZQpFslFYEUMxG6eGaAkcB+NqUDTxd0IylSN80DSHoZKnWOIzT+PVHNSBPGZn2Z/3uc54VBaqU7D34CM0x1IR322J8GbCSTIYtgeAJA2Jn34ZJSu+MKyrulvM/8DAa9CM4oG1cT23sLC+FAkU+4B32faUPA63iXr+vJZ//g1blacu21b3ESIDDtRFiZOTlB401VtkV3+qg/ilPdosv3hgI5AvlEF3NUR+TP/0yP/erScNjRNJxkN0Qa3yiDAaGNMestlWXaTpPhKubcjcLL6HBAlNZI7SeaxppgeZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ce1O4bhDLx15OQ5yrXeDqVFETHTJbDz4Bzf+Ty/IKAg=;
 b=tH/tvjPF5govJoo2rpki5ydR8/Aw1WppWotBblZulCSdcsJ1BQR6/wAZwucRHgqiDHcgYtKlITBKT8JuXYmypVNPMPygSVTvASZK4on+kpU3JLlXP+D+0KhB9eKOrs1nWH7TyZYW4wds8NDnj+fA5LACMZpKJOkxSCWRNsT8yaE=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB1941.jpnprd01.prod.outlook.com (2603:1096:603:1f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 18:47:53 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 18:47:53 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
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
Subject: RE: [PATCH 07/10] ravb: Add tsrq to struct ravb_hw_info
Thread-Topic: [PATCH 07/10] ravb: Add tsrq to struct ravb_hw_info
Thread-Index: AQHXttYBwrLZxD51OEWm4mtgQbic7KvDJcMAgAAKOACAAAKqsA==
Date:   Mon, 4 Oct 2021 18:47:53 +0000
Message-ID: <OS0PR01MB59220CAF5B166D4E6887B63486AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-8-biju.das.jz@bp.renesas.com>
 <5193e153-2765-943b-4cf8-413d5957ec01@omp.ru>
 <e83b3688-4cfe-8706-bd42-ab1ad8644239@gmail.com>
In-Reply-To: <e83b3688-4cfe-8706-bd42-ab1ad8644239@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14df53d2-fcaa-45fc-c759-08d987677944
x-ms-traffictypediagnostic: OSBPR01MB1941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB1941B2CC51BDBF20163EDA9486AE9@OSBPR01MB1941.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:397;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ji2XnrRhxdh1pfdNtim0CY1mpvA/mD7RPj/22TPk9itLavRXyu8l5fJuVc/tuYFklsD0zyv9W8j6JVlwhBgE/m1VJUA6Tcb9aFFVQnw+Ocz7bmLsHWrQ9/5pPq+51MXAX6viJzaibWOE2eCx7dRNB6MIM4ut/6Y9FFxAzUvANQ4Xur/uQvFhD8rzJaxV0teKWeCNxINHRbYcsT8sNt1LL88rUkYZrv9GhO3n8FBRScJVtsA9g9Ffx2CXm837Nj15PrGND48lsE05AD1y8RbV1hsnO1JawmmCnPQfaM6pcoWtFGm2rzC8bNMASzSi0Ods0jZFNsYeqF8egIVzCVE5ygVS+x8dnBS6crBLH8IV0zwwGcU1oHKO2K/IaPXQYB97Oc7Rm0Sb49KYSsynMQaYcunm643TsOZLIFLAiOmZxS6FC43+EBMEz/uEMJnE3Do53mJKcS4XhtgldXwWXF2iTRUYoyytbN1ibXySf1KI/hxO3TD2JyKZNNuwhOn57ywgLZ2nN7M9JXjCGxy4VEJVAUrZyIaJkpPgaAJh1S7MN9NXjshSI0piK27YjSKFbbIG4PtrMZcSdldEb68oh69EpZrTDCMiw9Hg9epf4AgeGxPaTz+/HHBCp59k81Lds5MMyXwcN7mOGj1eJR+owRekw+nEN1+y3+MQv7NYM+IsL0lpR8RPTABjEntopL9/K8U/FmqvU8Zuf1sJpc7rooorzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(83380400001)(7416002)(8936002)(76116006)(8676002)(71200400001)(2906002)(33656002)(9686003)(66446008)(508600001)(5660300002)(6506007)(66556008)(64756008)(52536014)(66946007)(55016002)(66476007)(86362001)(7696005)(107886003)(26005)(110136005)(54906003)(316002)(53546011)(122000001)(4326008)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGpubDhQUmk1cDFIM0QzdTAzRy9rY0NiMklOVHMzcHByK0dPUVJ2WUR4UStJ?=
 =?utf-8?B?Y3RqVWY2NEhJZnJyRzRHZytTakpxVWJJQy9iN2RhVUg3bkF0K3p2SUNmYXBZ?=
 =?utf-8?B?Y1Uwblkya0lyZldpNkwxZXIzdlhqS0NlZ3JNUmE2MWNzWHMzakpETzZGT2sr?=
 =?utf-8?B?cVlXaEtiMmgyT0lsd1RFOWJ1NFlGSDVWYUpWckNpWTdSR1ByN3VWZGdDWUh0?=
 =?utf-8?B?RXl5Y01WanlBMlFRRXJ6QVlPZ0VKbjFOL0ZiZFAyaWlkN2xtbnByNXhSYmJ4?=
 =?utf-8?B?VlBIOE0ydHczdE9pWiswczVTbGV5bW9xVnY3TUtZTkpUNjZkTXlnb0R4dThp?=
 =?utf-8?B?ZEhyZlRhSjlKSUE4ZjhhYjBKUnV4RFIzVFFlMk4vWU9xeTJNOWl2VTJjcnp3?=
 =?utf-8?B?WWtpUXhQZmlFQlRwRVFsWEZGOVJmNlNqOE8remZmMGJObXpjWG5WS2lwVnA2?=
 =?utf-8?B?TDJzM3VKN1hTV1NzY0c1L1pvdFJwYW4wbGJRU2xxdkQyc0h6VGJ4MmVIYWpq?=
 =?utf-8?B?aTVHdDhpMVZBSzVXR0FSd3dKUm56WTR1OTg5M0hUaGZlcHJ2ZXl2V3NDaE5r?=
 =?utf-8?B?R2Y4eDRSRHhXYVY4bjZ2WllORTdTeEFuVXIyVmtGcjhMdzNRK09MTklnYnZs?=
 =?utf-8?B?MDlpTGFsTHdiUm1SUkQ5a3ZsSjdId3UvNUowbUYrRUd1KzdpbnEwSGxldERM?=
 =?utf-8?B?TUh4bWU0KzBSTE1hL0J5cDJGK28yL25jbXhaaGxsUkJhekxRamdNOERFU0Nm?=
 =?utf-8?B?VmZPbzNuSnhQbE5pVXNveHdvMDJzSHY3RG41bkxxVXNBcmgxL3pXblp3WHFL?=
 =?utf-8?B?OHdNeUFpZG1ZOVR2cWlXR3hoUWR0d2xvOFo1OGV0MjNDUW55UDluMEQyU0Ux?=
 =?utf-8?B?WkN3TEVRclVBeHMzYmZVS3dmMWNHVnkrMUhGSTFaLzBoUm1vUFFwejl3UVNt?=
 =?utf-8?B?NzNGMHVoTVoxek1lWUlFbXFPbndUMVRLNUJIS2dCZ2pZbFl4ME5pQ1NPODNo?=
 =?utf-8?B?UXI3bk9LTDB1MGs3SUlKcCtEYjRiZFlKazZTdDdGMTJJQWF4bUhrSU82RTE4?=
 =?utf-8?B?cGVwNlNvc3ByLzVGY1Ryd2xMb2FnZWFXNjVKdXVNTmN4LzdHNTdBNlZUTkFD?=
 =?utf-8?B?Z0piT3FmT0dWZEwwZFNTNlhMMWJ6ZzdUVEZMOTVxUmJsczlXMFdwTzhpKzNq?=
 =?utf-8?B?bnBsQy9TTDRLVndnWjlQUStnN1BHNnJweEZnMnk0ajFOSmo2ZjhOZGZ6Vmln?=
 =?utf-8?B?bjdMc3hlenpJWEplQlRJbm11Zlk0NnJHbzdzVk1ycmYvYzNwY3htcWQ4UWZv?=
 =?utf-8?B?eW1oaW41OUtpNmxZNmdIdGtramszbTZDVDRjaG9Id2JrbFhBcHpCSXFJNTE1?=
 =?utf-8?B?VE04S240UDRIWENobXVuYkpQMkhIU3lmdkRvdDlVZG12OWRmdkh5UFZPZXpE?=
 =?utf-8?B?cGh6cXpGcmFiUUF6ek8zNlVobldURnVlMGxYbEo3a0x3Yngxc2I2SHNJZmlj?=
 =?utf-8?B?SHlxQUVyamZWdGlRZkVrOXpMdnE5NU54czkvT3lMRjIwSXFZQkhjQjRTa1Jm?=
 =?utf-8?B?L2tieXhuLzBNMzFUWnFuSUlaVldiOWljMFRoNkw5RGpQL05MY0hTNUw4K1Rp?=
 =?utf-8?B?aUY5UWlUcnBCNWRiU2VuNW9HK2srZ2JBT1RYYjlVRWc0SnFrYUV2eC9KbFRH?=
 =?utf-8?B?OWtKV2ZwMjd6ZytkaThxVGhuRlZFb0NkVklzM2NnajBad293MkhjcEQzWXNv?=
 =?utf-8?Q?pWwn1T7zK5zSDDjBu8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14df53d2-fcaa-45fc-c759-08d987677944
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 18:47:53.4353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +EVQG+iPK4/SFTpD8B+mhT7j2nDFEl22NOWKwpLbjL7ZE7wD6PChbgXx+u0GfLIxPcPSOjIrRYegr9VTFG1/iOdHAMe8wTCsCpZA/0baUIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2VpIFNodHlseW92
IDxzZXJnZWkuc2h0eWx5b3ZAZ21haWwuY29tPg0KPiBTZW50OiAwNCBPY3RvYmVyIDIwMjEgMTk6
MzcNCj4gVG86IFNlcmdleSBTaHR5bHlvdiA8cy5zaHR5bHlvdkBvbXAucnU+OyBCaWp1IERhcw0K
PiA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBKYWt1Yg0KPiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBDYzog
R2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IFNlcmdleSBTaHR5
bHlvdg0KPiA8cy5zaHR5bHlvdkBvbXBydXNzaWEucnU+OyBBZGFtIEZvcmQgPGFmb3JkMTczQGdt
YWlsLmNvbT47IEFuZHJldyBMdW5uDQo+IDxhbmRyZXdAbHVubi5jaD47IFl1dXN1a2UgQXNoaXp1
a2EgPGFzaGlkdWthQGZ1aml0c3UuY29tPjsgWW9zaGloaXJvDQo+IFNoaW1vZGEgPHlvc2hpaGly
by5zaGltb2RhLnVoQHJlbmVzYXMuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgt
DQo+IHJlbmVzYXMtc29jQHZnZXIua2VybmVsLm9yZzsgQ2hyaXMgUGF0ZXJzb24gPENocmlzLlBh
dGVyc29uMkByZW5lc2FzLmNvbT47DQo+IEJpanUgRGFzIDxiaWp1LmRhc0BicC5yZW5lc2FzLmNv
bT47IFByYWJoYWthciBNYWhhZGV2IExhZA0KPiA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJw
LnJlbmVzYXMuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDA3LzEwXSByYXZiOiBBZGQgdHNy
cSB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+IA0KPiBPbiAxMC80LzIxIDk6MDAgUE0sIFNlcmdl
eSBTaHR5bHlvdiB3cm90ZToNCj4gDQo+IFsuLi5dDQo+ID4gICAgVGhlIFRDQ1IgYml0cyBhcmUg
Y2FsbGVkIHRyYW5zbWl0IHN0YXJ0IHJlcXVlc3QgKHF1ZXVlIDAvMSksIG5vdA0KPiB0cmFuc21p
dCBzdGFydCByZXF1ZXN0IHF1ZXVlIDAvMS4NCj4gPiBJIHRoaW5rIHlvdSd2ZSByZWFkIHRvbyBt
dWNoIHZhbHVlIGludG8gdGhlbSBmb3Igd2hhdCBpcyBqdXN0IFRYIHF1ZXVlDQo+IDAvMS4NCj4g
Pg0KPiA+PiBBZGQgYSB0c3JxIHZhcmlhYmxlIHRvIHN0cnVjdCByYXZiX2h3X2luZm8gdG8gaGFu
ZGxlIHRoaXMgZGlmZmVyZW5jZS4NCj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMg
PGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+PiBSZXZpZXdlZC1ieTogTGFkIFByYWJo
YWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+PiAtLS0N
Cj4gPj4gUkZDLT52MToNCj4gPj4gICogQWRkZWQgdHNycSB2YXJpYWJsZSBpbnN0ZWFkIG9mIG11
bHRpX3RzcnEgZmVhdHVyZSBiaXQuDQo+ID4+IC0tLQ0KPiA+PiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcmVuZXNhcy9yYXZiLmggICAgICB8IDEgKw0KPiA+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiX21haW4uYyB8IDkgKysrKysrKy0tDQo+ID4+ICAyIGZpbGVzIGNoYW5nZWQs
IDggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4gaW5kZXggOWNkM2ExNTc0M2I0Li5jNTg2MDcw
MTkzZWYgMTAwNjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yi5oDQo+ID4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+
IEBAIC05OTcsNiArOTk3LDcgQEAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4+ICAJbmV0ZGV2
X2ZlYXR1cmVzX3QgbmV0X2ZlYXR1cmVzOw0KPiA+PiAgCWludCBzdGF0c19sZW47DQo+ID4+ICAJ
c2l6ZV90IG1heF9yeF9sZW47DQo+ID4+ICsJdTMyIHRzcnE7DQo+ID4NCj4gPiAgICBJJ2QgY2Fs
bCBpdCAndGNjcl92YWx1ZScgaW5zdGVhZC4NCj4gDQo+ICAgICBPciBldmVuIGJldHRlciwgJ3Rj
Y3JfbWFzaycuLi4NCg0KV2UgYXJlIG5vdCBtYXNraW5nIGFueXRoaW5nIGhlcmUgcmlnaHQuIHRj
Y3JfdmFsdWUgd2lsbCBiZSBvaywgYXMgaXQgaW1wbGllcyByZWFsIHRjY3IgcmVnaXN0ZXIgdmFs
dWUuDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4gDQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdleQ0K
