Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C59F3A3476
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFJUFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:05:23 -0400
Received: from mail-dm6nam10on2095.outbound.protection.outlook.com ([40.107.93.95]:37040
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229963AbhFJUFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:05:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8um19JHtG//dA/IQz1Xjz4ywRwfdjnRwWZpKvP2cFX+oDRIAP8bzc5HAy/9c4fj8qZJ5j5IwSjq3zPVvZYyNHr0ey6UyiV+DazulGcDCWvshPGyUlBLS98d0CNGNM7pcuqAV3oxt06VkEmm3Cy/76TcaQUDuqm/Z3Z5UsOVButOn2o5mupVaS8THKQG9OsRQGKIixVdjnAGnJp84Xzi5wRNM+eijtU3b2jfYSPhd2vc787axTzsaZIKt3+lPc+zcDWgBoWUuE5N4S8UC9kqkIaJgpwfNc6IqwJK8lJcpxqdUQ+l9REnbTnEw/IU0byfeZBMJ4Ef/DbSQRXOwARQVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BShXySRTE1qiiaklmZD5QxNU2X/AaczDPzXOdhD+qpM=;
 b=JYc/a06dUb7l+eYe2ksUOGnfQAhWqI9hFZOPhmMaWae+odCsObHHYSpMQQ6KibHEGopYWB4yHln1LPNxrvta1SKPN0njWPDuCg3E06pgOXOGhvrA48p81kj4BHY0JHiyyAu7MId1hgEiZUu7EFyJTYlJPm9kp6BcIVlt8/+4Z7gFvZIxakmTV60ruxyaLYSdM5hmdj2V2m3h79Faf0ZaeD19U7Qy7PcckIkWL/tXm33mIBMzcnSPKNFQ+O1GX/sE241vaUceIymYJIjGsmpqNIrIiSOWokO0wMa8mmhHVe90JOUUIMbVJU+pEA3bz0CdxjHxusr9fvNY/J3SYy298A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BShXySRTE1qiiaklmZD5QxNU2X/AaczDPzXOdhD+qpM=;
 b=IZi2lLL6VYOING0AobtLwqzgsXzSxWPZNTOn2G33Z/h/N8kBSFZIOOW5+zQ9dF23uvfT7NEardZP37F33syFdLF/7+VrwftcZSTHgazhs1cr2q49MzyuLE20Z1LEgt+2WN1QNSSYQV/PG4co54B0jSAwGw/o7TMvMBwZ9mFbXSQ=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SJ0PR21MB1967.namprd21.prod.outlook.com (2603:10b6:a03:29e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.5; Thu, 10 Jun
 2021 20:03:24 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::fcf8:a9d4:ac25:c7ce]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::fcf8:a9d4:ac25:c7ce%3]) with mapi id 15.20.4242.012; Thu, 10 Jun 2021
 20:03:23 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Dhiraj Shah <find.dhiraj@gmail.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Colin Ian King <colin.king@canonical.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] function mana_hwc_create_wq leaks memory
Thread-Topic: [PATCH] function mana_hwc_create_wq leaks memory
Thread-Index: AQHXXg1ojJMEZe7SE0uvKv3Tzsr7JasNfBjAgAAB/jCAACpJAIAAARgA
Date:   Thu, 10 Jun 2021 20:03:23 +0000
Message-ID: <BYAPR21MB1270FE45040F31DC71C0F5E6BF359@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20210610152925.18145-1-find.dhiraj@gmail.com>
 <BYAPR21MB1270FC995760BE925179F353BF359@BYAPR21MB1270.namprd21.prod.outlook.com>
 <BYAPR21MB127087B408352336E0A8BF2ABF359@BYAPR21MB1270.namprd21.prod.outlook.com>
 <98DC11D9-668E-47F2-891C-6F41E70BD5F4@gmail.com>
In-Reply-To: <98DC11D9-668E-47F2-891C-6F41E70BD5F4@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6673e471-8dd5-43eb-a3b0-3e6cc44cea5e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-10T19:57:04Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7c0eb9b-6e7e-4860-c35b-08d92c4acda4
x-ms-traffictypediagnostic: SJ0PR21MB1967:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR21MB19670BF8D6C5FF503B708924BF359@SJ0PR21MB1967.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ekPsuHI3y+Lf0o6nCYltW2+g80ZuCFfcWOltOHft8TLMBb62NITRD8uJy8kQxvj2lMJObKNoidSJP8wQbH2xGixgTdqaAc7xhm+LFslIDW/B6PO/dxIaHoLBPFnlBIY6oTMSlIQGX2KlYFkfC+3JxD0XmwKsbazAvF5OtormfWolX6agYBKvLCmtGMpLyeDC4kwLRRxAyy20ErMdC5zopT9m/2xK1frcc7OFeJAKGNdZMp2bOfkmLNu/uMEYYZ7RUHNeW132lqFmWB2cpALlbywUh28GnlfGpZ9bAYqLqCseLtAHN15qxbN9qTAVOf1d+HgMigGDc0TZNmliEaVg4zYs0dDU0NMp/7yrNoi/WX682LcaVyMuwd1PoJYnJOXhuf8CCb1MmV/BtqCIupr2qR/gwkI3BIEBgGZlI4CCBDfu0AP2YW6fPoBt/MI1to1L8CXmX1w2pGkyVIfILq9nUhdbJ5OWEo4ryFWj1O8b0CO0CQqbVoXQfnTjstIfP6j7pjbqhBFlsCBAhJvESoBjRiQKDiZ6j3A+PYMYluIB7+4mulyldWmkFRsq05O5UlGh9XPsAOoAVZMi4e1v9m+XlKmZ1ixbmZ42pxUJpyLwo6kYvXm5TANvYNoRfYWQ96UgSeiTRutOFcZ3sA+XuEV35w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(9686003)(10290500003)(54906003)(5660300002)(186003)(33656002)(38100700002)(71200400001)(4744005)(8676002)(2906002)(66556008)(7696005)(6506007)(66946007)(66446008)(66476007)(478600001)(4326008)(8936002)(6916009)(55016002)(8990500004)(122000001)(64756008)(316002)(52536014)(82950400001)(82960400001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzZObUU0VnhMc3Zud2I1dDMwa2FQYVpJclRTemo0ZWwxcTlxYzZyZnhNVTRh?=
 =?utf-8?B?dzByV3pMYjZrNEY1RWZheDdKNm9Pemt2VXhsaEVQYTlSZXpFZDdCQ1pNUkh1?=
 =?utf-8?B?aE9FUWZWM0pzLzZUODRhc2JLb1crNlNnRmdxU0hQZkM0WkZOQkFHS3FTYTRz?=
 =?utf-8?B?bTBSU0VuUWJwU1VHajJqZjltNzVFTnVLN29xSHA3NGVCdFhlS2ZDV0NlN21y?=
 =?utf-8?B?ejhhZGdQWTkxR0gyTzFObWN3NjZ4aFh1Q0VFdnRtR0VnQTNRWG9YelpzNnM3?=
 =?utf-8?B?UGtwZXVzZEJXT041bzM3TUZqbXNDS2VETEdwMEgwcnRYNVkyaWhuMkdmZWg1?=
 =?utf-8?B?eEh5TzA5N1k5aklTK0hmN1p6RDVlN0JIYnhzaDdwMFV6Zlg0TGJ1ekpMVVVq?=
 =?utf-8?B?bkw2emsyWWw4VjY0WG8zTkpiK0FIMXpNMmFBcjhIOVIxa2NmS21HWkZmZ0lF?=
 =?utf-8?B?YlAySS8xcXFVazBBWDFtbmJIazNBcjY4LzdwZENCQVBKa2xjQ2h4RnRsKzlE?=
 =?utf-8?B?SmlrRUZWMWxyY2tlNU4rSDl0aFUwZHhMZnBqNGRnSDV6bDZTMFU5akhjYzk1?=
 =?utf-8?B?dHZ2a3UyR3JiZkxOelI4WnMyMHJLN0wrcHRmL2dSd05nT00xMDFYaEE3amtp?=
 =?utf-8?B?RGFYNVUxbjhGSHNPYmtVSTQ3VHkvMFRRbitFam9yd3JLRklZa2lVQWRBaWMz?=
 =?utf-8?B?QWN3djNTTjljb1poNTRSZ0VaRURVU3BpMmNzUUhlR2F1Z2JaQ09BM0x4dDJt?=
 =?utf-8?B?R3hHZHl3SmdNVEtWMiswMUw5S0I2YXJ2dDJUQmsrWXRDRnZDSDcvSXZqWTF0?=
 =?utf-8?B?cW0wenlWTW16TlhDemFxbGJXQzVCMGtFMk01NFhtTERzZmRQTXZLUFZpWFdy?=
 =?utf-8?B?VUU3TWxUdFFUK0htRS9CRzNScC9HcmdtYVlOTVMrZWk5ZnE1b2E0SjA2UVZm?=
 =?utf-8?B?eUd4Q1hQR0FVWXN4WGh2dTh6NWVVL1lLcTVQb1hRVkhxcWc4WmNMak9PMWxs?=
 =?utf-8?B?ZGMvMGk2MXRMMzgvbC8veHZFM1JibDRTcEg4Yi9iUWpQVVlhd1RuMExHOWFV?=
 =?utf-8?B?VnZtS0s2bUdUWCtEeDBoa3MrL1FTbFFDUUhUMjdXa1g2Z3R0LzZwZ0tZMzls?=
 =?utf-8?B?US9sK04reFh3dysrOVQyZE5lMGFTNHZpdzNZMTIrbGV1VGs2Qk1hWGczTVpa?=
 =?utf-8?B?Vks3dXlNL202WGVyTW5LZHM2bjQwNVo5Y29US3YzU1h6NGFuVUNjM0tVbitI?=
 =?utf-8?B?ZXB1Wnh1ZFRjT2Y0bitCRnFST2xrNkwxcXRxcWg0ODhrbHEyOHJmdDJKdEZG?=
 =?utf-8?B?UlhRZ29WcHp6T3JHMEc5dkxuYm5PNlE5QjBkbmtNemJ2M3FxcDc1NDJQd1BR?=
 =?utf-8?B?M0I1bjRTMDBvdTIvdHRqS3RxWmN1YzZZSy9GcTd6c0d2L1FCejMwR2M0UGR1?=
 =?utf-8?B?aHVpZlZ4aHB2Tk81VitNSGN1UFE5RWNNUlFRL1VHbXkxTnI2UWtsSS9xOUt6?=
 =?utf-8?B?Vmp4YS9zMnR3TTJwNEVsNXdudlhGZkRJU3QySmk0Tm42YUZvZS9VNi9tcWtC?=
 =?utf-8?B?TnN2WDR3U3IrTjI5bG5zdUpmWjQvWm03MlNiQWJtUk4wM0pHNk5MTDFneGV1?=
 =?utf-8?B?dDMwR2pmYVMvdXArSk9sZDVlOGNIRXg2SUNVYThCajhmU0hGT0RVVmxFcHk1?=
 =?utf-8?B?bktCSC9nQ0h5UFlCOGRXSHVGcTdQdmk3TVVyZ1dSMU5JclVuYXphUHNaMHQ5?=
 =?utf-8?B?Rkw0UzJ4ZXY2ZmJDcnhadExJK3VRT3hCN25BZ09kdDYrWm43eHRoRjFDUEIz?=
 =?utf-8?B?VGJkSDhTbnorMGYzcE84dU1JUkZ1Ym5vMEFNcnIyRC9FVE9Gb3llcjNpWng1?=
 =?utf-8?Q?N8AbOOycs+jXh?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c0eb9b-6e7e-4860-c35b-08d92c4acda4
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2021 20:03:23.7615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rlEJeV+FIfKbihRLNpUmFBezJgC3Xb9XJm+4rqpgkc3ZhBvGijhSDHJnrUwSv2S6T0wrcZS6cue5xmmqoy974A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEaGlyYWogU2hhaCA8ZmluZC5kaGlyYWpAZ21haWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgSnVuZSAxMCwgMjAyMSAxMjo1MyBQTQ0KPiAgLi4uDQo+IEhpIERleHVhbiwNCj4gDQo+
IFRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KPiANCj4gWW91IGFyZSByaWdodCBzYXlpbmcg4oCY
bWFuYV9od2NfZGVzdHJveV93cScgZnJlZeKAmXMgdXAgdGhlIHF1ZXVlLg0KPiANCj4gSG93ZXZl
ciBmb3IgZXhhbXBsZSBpZiAgZnVuY3Rpb24gJ21hbmFfaHdjX2FsbG9jX2RtYV9idWYnIGZhaWxz
IGl0IHdpbGwgZ290bw0KPiDigJhvdXQnIGFuZCBjYWxsIOKAmG1hbmFfaHdjX2Rlc3Ryb3lfd3En
LCB0aGUgdmFsdWUgJ2h3Y193cS0+Z2RtYV93cScgaXMNCj4gc3RpbGwgbm90IGFzc2lnbmVkIGF0
IHRoaXMgcG9pbnQuIEluIHRoZSAg4oCYbWFuYV9od2NfZGVzdHJveV93cScgZnVuY3Rpb24gaSBz
ZWUNCg0KQXQgdGhpcyBwb2ludCwgaHdjX3dxLT5nZG1hX3dxIHN0YXlzIHdpdGggaXRzIGRlZmF1
bHQgdmFsdWUgTlVMTC4NCg0KPiBpdCBjaGVja3MgZm9yICdod2Nfd3EtPmdkbWFfd3EnIGJlZm9y
ZSBjYWxsaW5nLCDigJhtYW5hX2dkX2Rlc3Ryb3lfcXVldWUnLA0KPiB3aGljaCBtYWtlcyBtZSB0
aGluayBxdWV1ZSBpcyBzdGlsbCBub3QgZnJlZWQuDQoNCklNTyB0aGUgY3VycmVudCBjb2RlIGlz
IG5vdCBidWdneSwgdGhvdWdoIEkgYWRtaXQgaXQncyBub3QgdmVyeSByZWFkYWJsZS4gOi0pDQoN
CklmIHlvdSdyZSBpbnRlcmVzdGVkLCB5b3UncmUgd2VsY29tZSB0byBoZWxwIG1ha2UgaXQgbW9y
ZSByZWFkYWJsZS4gSSdsbCBhbHNvDQp0cnkgdG8gbWFrZSBzb21lIHRpbWUgb24gdGhpcy4NCg0K
VGhhbmtzLA0KRGV4dWFuDQo=
