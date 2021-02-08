Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4065A31401B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhBHUOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:14:16 -0500
Received: from mail-eopbgr770112.outbound.protection.outlook.com ([40.107.77.112]:10478
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236046AbhBHUNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 15:13:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcL+vnbEBgtSv/CIbu0dLjlZaFEPbf/xamfndmmgT9iTj+Lo/0yq0KgM/q1DAPV3Ez+c5Y7t77luyige0qIcxT7sragkSQN/YgB9dnmHr4+M5rVSdvG06pUZxqkyLTlZDn6qCSPFWyCd2+YT6nqv/dty5SXWNsQllLfcZtTe69WsrsobgAc2FGkNJrGaQPV2GeHzY8IwHzr34Up8RiQ7z0GVT59/hPdTz7+cAMahgzVJvgVam2XY/YPUSGt+LQv/WMPkou1FSo36rLvbSKARLQ49LlkkIpZwFBxAHROlLFMdlWP/79vCkhe+JYbK9X7mDf4itE9aPSJgoIQhw3uwfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lab+sb+f3n0hjrE8VaHEjXwEBWk839raSlVgskp1RXM=;
 b=fuBCL646KC99s9S/kjmmZUIgsjitOmh7nI2IMGBXu/AtfvMvSN8vxOMQo52mfF4i8PURM+g+saKE5zF2CZSDZEMAo3PqRWQzvKK2vu+tlKtbQn1YgXlfNobvTUj6UdJbK2KF56zjMufzy8XpV6jf2YKBdeKSTxwByAg7hhBrvs7JzKk3SB536QTpuGYoehE0ajgasebPTtAF54j8c9YVKYV6lEIi8z1NTGW7FdPeTveA3NWOyFoNazvTyFqIflOih9Cftki4infINzx8oY9PygWAcJQhcQRNWMy99wl3KI/YaZDOT12QNR1gxNf5HFkqFc+tRr3tdZaCfVkVA1OlNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lab+sb+f3n0hjrE8VaHEjXwEBWk839raSlVgskp1RXM=;
 b=hGd+oowCkPMKqwuKbhifnnmb/5+xwyenCLK8L+a0UNL8pDL+zAQoLM3IxLpuVTE1f01xSvZYAseBOs+WehyZ58KtSCMgWriOAveDRjOkD87JyAelk2jRqOEbiIMrzYdtUIE+savBmA+jaCRgaOojw1f6Z2jpZyddNe3ij/orlJc=
Received: from (2603:10b6:610:21::29) by
 CH2PR13MB3510.namprd13.prod.outlook.com (2603:10b6:610:2d::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.23; Mon, 8 Feb 2021 20:12:32 +0000
Received: from CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063]) by CH2PR13MB3525.namprd13.prod.outlook.com
 ([fe80::f453:2dd2:675:d063%3]) with mapi id 15.20.3846.025; Mon, 8 Feb 2021
 20:12:32 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daire@dneg.com" <daire@dneg.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.10 03/45] SUNRPC: Handle TCP socket sends with
 kernel_sendpage() again
Thread-Topic: [PATCH AUTOSEL 5.10 03/45] SUNRPC: Handle TCP socket sends with
 kernel_sendpage() again
Thread-Index: AQHW7tQlUl/ijYkh5UeVw+yM/Wf1I6pOxQuAgAAEF4CAAAamgA==
Date:   Mon, 8 Feb 2021 20:12:31 +0000
Message-ID: <6a137e45966fc297671d6f7218b9603d856c4604.camel@hammerspace.com>
References: <20210120012602.769683-1-sashal@kernel.org>
         <20210120012602.769683-3-sashal@kernel.org>
         <2c8a1cfc781b1687ace222a8d4699934f635c1e9.camel@hammerspace.com>
         <5CD4BF8B-402C-4735-BF04-52B8D62F5EED@oracle.com>
In-Reply-To: <5CD4BF8B-402C-4735-BF04-52B8D62F5EED@oracle.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16187d8a-ee42-4953-15bc-08d8cc6dddf2
x-ms-traffictypediagnostic: CH2PR13MB3510:
x-microsoft-antispam-prvs: <CH2PR13MB35107384424AF753F8F9DDACB88F9@CH2PR13MB3510.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YW5y+yADGttR5GcbXFrmxn4WR+VstGOO/Fg3X/IxxRumY5hz1iJQev2iBSswBkJLfv3FM1asfAG3b7Sk+VKkQy9bHjI98lAwuYTSOoKz8VHqpMPtWLgK7le50w0iJBOcJUJRBv4miKaCXWqKbl3eu5C/gi19x/t6edUnFPaBp7y512+ZmccA7XOtlGAnBqm43VK74n3guokGW4Pxw6/6XjsJugsB6GuoeTsZIz2UQD9fqQmTYMSfo6Hd/ppVFrKIsIa270lZ0HE6wwWbZcCqBNevqU5F9CA0Wo/zpAIJYnnNAbuKQeSZHS0QQcwTIMyf2Dwm+HGq7qGbHuCaXyw8kMVi0gsZ3ayJT5kBXHFPcF+6sOHK9iVdeYc1ngIsFKbyWcqsFHBSj5m+1iFfCg71/h5T1tQ7iX8EmbI/2YWEc0WL64kcAHAPwleCCkp5sex/eU06VGT6266ilD5Kig6+hz0HZwb6JNiLe/PEt/tfJiDL/shy37Xvy1PBTiqgRbkP98Db0u+BBEVONgtLxrZ5swWFvh/S8hz0idpySlCBgvL2vOZoP1KsnLrTwe4zdO2ca1r6GTXH+HpHXRuq3IpsgkjQF4y6ePFXlQxEzEFjIjQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3525.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(136003)(396003)(346002)(376002)(2616005)(8676002)(36756003)(6512007)(83380400001)(86362001)(66476007)(8936002)(6916009)(76116006)(66946007)(66556008)(64756008)(66446008)(316002)(478600001)(53546011)(71200400001)(6506007)(26005)(2906002)(5660300002)(6486002)(966005)(4326008)(54906003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?K2QwQmtyNUVtNG05YjlWMElORENDTERTRlJLeGdDd3Vra01RSjRqRXlxRUlq?=
 =?utf-8?B?eUpxWXNGL2I4ZXVqSGVoenV0WXFZY0FMck0yU00vZlFoY1RaWnlYWDBiSVZm?=
 =?utf-8?B?SVZtUWx0ZTBJR3NRTDJxNkI0cTRCZkJuK05EL2Q1cjM2blZoWnFiYjRvSHkz?=
 =?utf-8?B?WUVBdVZCVW9Od3V1NmpXaEhaM0Qwa2hyVjBqNGk5bVhTSERzTHpoMFRqNXBM?=
 =?utf-8?B?TTNxS1Z0VG1zcDY2NGIwekpxanRUTGo2bW1PQUt1OEZZVnZFSE1MTWU3K00x?=
 =?utf-8?B?b2E5SlFwdi9uUjNKSFNUVGp5VkgrWnltQVMwNS85K1RZdysyT0JsT0dDd2hy?=
 =?utf-8?B?OU1CVUNPdlZiVHU5Q09xZ2FVQW95Wm9oaU0rZ00wNk5iRC9VTjkvR0I5V2d6?=
 =?utf-8?B?MW5Mb2p5cHAyVFBsaHZNUVdJOGpGeWFGdSs3NjVhMkRsZWkxRWNZNVpNeFBM?=
 =?utf-8?B?Q3NwUGdLK0tTeHBmL1R1TDJyR29zZFVkRUpOTkVwWmc4bTBrN0V5eXdBQnVq?=
 =?utf-8?B?b3lMaldlNVFhZ2JCQ1pUZEFLanBpemFBdTFibHd3SmNCY01wU2dkaUcrd1Nj?=
 =?utf-8?B?ditLbUZPM3lCcEN0M2JheUt1Q09iNnhNcDB1L1lIOEFQRW1waW5ySTRxcWF3?=
 =?utf-8?B?OFdpSkxTRnJRUHF3NTQrbVVGcUlkTTU3ZGQzbHBRUWFDeTFPSk4waEFiZXlo?=
 =?utf-8?B?NDZndm5naFJBQ2NEYWRuMjBYM2FiSW1QUDNXQnhuSUZyejI3ZnNMek1iL3BZ?=
 =?utf-8?B?ZjN4elBLS3pFdHNZM3NzQ21HajlRNzh6MDUxV2ViUnpJSWM0U0pJTGhVc1A4?=
 =?utf-8?B?N0crNzhlUHVQTGxkQ2RHaWtWSzNDNDJ3aFNFT0ZFZVdreW1FeldnOCtUWHlx?=
 =?utf-8?B?ckRTS05OQllTVTAvdmNoV3VuMzJVSUhjYzBrbldOeG9QTk9UVkFlUkd3Ynh6?=
 =?utf-8?B?Q2o4SklXSEZoMVN0eGNERE5UcFVNZWlUTjYyaEdDN1JwenpjQUJYSHNQY3Vs?=
 =?utf-8?B?VzdyR0EvTkF3U055c2ZzR3h3M2MrbDhJMVlreU43aGZ4b2ZXQjNiQm1ZK2Nw?=
 =?utf-8?B?cUhjWmkrMlJOS3RGRDQ5WGo3d2Rtb1Q4TGF2cFdXUG1YVFBobFg0cnBpL0xh?=
 =?utf-8?B?WUlSWlVWSlBLYVFsUXlralpJQnR2L2dJRU1iYXpHQ2RHUlp5aW9ZVVlROHlC?=
 =?utf-8?B?ZnVCdmo3WmdwOVIyNFc1V1h4WDFyN3grUEVTNFBMaFN6UWMzR1N6dGtqSFlI?=
 =?utf-8?B?Y3VqYytOMkhJNUxxbkJwSnRVZVpGa1NLdWtTYXUwY295ZDVSM2gwY0YrV0Iy?=
 =?utf-8?B?aGhKcGRRTU5JYnpsS0xRM21iUkN3cnlaenREbkJ1aWs0VTJqbzZwUGZ3d01K?=
 =?utf-8?B?V3lkSkZtTVRzRFMyNGFQUlZBbkRwSXB3RFhhR25PZWJFUUVMWGMxVXZBbmRw?=
 =?utf-8?B?Skl3dDd6b0dZUEpqNmJqQUdrQ0xCL1lPNTNsT1FoQmRQcW1NS2kzYUE4aVhu?=
 =?utf-8?B?cExnRWFkb1BaNUhyVG1ReU1KNXRBOW1DV1lQRWY5NmZleW96d2ZYTUp0Y2M1?=
 =?utf-8?B?L1AxSjNvWEx3L2VDOVZKcUJxUHpqSHNCOEtSMDU3QnRQMGxERGZER1BZTWpL?=
 =?utf-8?B?QS96by9RYXF3Z1pIL2NaSnh2WlRBSGxqK0U0TFRLU2YwTzBPRGpWeUFOSjNs?=
 =?utf-8?B?RWpyMHN2Vi9NQXpBeFJFMmpoZDZ5UWh3a3VDVGtHdGF0L0p2cEtsMlBodU0r?=
 =?utf-8?Q?ex5LqmZX3Mf3j8/QQWeqd/iVde9ETt7GiiFeqDk?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <050AD0FD6C06504D8F241521A8179117@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR13MB3525.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16187d8a-ee42-4953-15bc-08d8cc6dddf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2021 20:12:31.7498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uQXFaODWWKDWYoGUZ6pJ9REbeYOGQfzNW2espazrhGYn/CnhTiu9/2iHRXFVtLmaeRHVwLauSAbZanhn4xTUcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAyLTA4IGF0IDE5OjQ4ICswMDAwLCBDaHVjayBMZXZlciB3cm90ZToNCj4g
DQo+IA0KPiA+IE9uIEZlYiA4LCAyMDIxLCBhdCAyOjM0IFBNLCBUcm9uZCBNeWtsZWJ1c3QgPA0K
PiA+IHRyb25kbXlAaGFtbWVyc3BhY2UuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBUdWUsIDIw
MjEtMDEtMTkgYXQgMjA6MjUgLTA1MDAsIFNhc2hhIExldmluIHdyb3RlOg0KPiA+ID4gRnJvbTog
Q2h1Y2sgTGV2ZXIgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+DQo+ID4gPiANCj4gPiA+IFsgVXBz
dHJlYW0gY29tbWl0IDRhODVhNmEzMzIwYjRhNjIyMzE1ZDJlMGVhOTFhMWQyYjAxM2JjZTQgXQ0K
PiA+ID4gDQo+ID4gPiBEYWlyZSBCeXJuZSByZXBvcnRzIGEgfjUwJSBhZ2dyZWdyYXRlIHRocm91
Z2hwdXQgcmVncmVzc2lvbiBvbg0KPiA+ID4gaGlzDQo+ID4gPiBMaW51eCBORlMgc2VydmVyIGFm
dGVyIGNvbW1pdCBkYTE2NjFiOTNiZjQgKCJTVU5SUEM6IFRlYWNoIHNlcnZlcg0KPiA+ID4gdG8N
Cj4gPiA+IHVzZSB4cHJ0X3NvY2tfc2VuZG1zZyBmb3Igc29ja2V0IHNlbmRzIiksIHdoaWNoIHJl
cGxhY2VkDQo+ID4gPiBrZXJuZWxfc2VuZF9wYWdlKCkgY2FsbHMgaW4gTkZTRCdzIHNvY2tldCBz
ZW5kIHBhdGggd2l0aCBjYWxscyB0bw0KPiA+ID4gc29ja19zZW5kbXNnKCkgdXNpbmcgaW92X2l0
ZXIuDQo+ID4gPiANCj4gPiA+IEludmVzdGlnYXRpb24gc2hvd2VkIHRoYXQgdGNwX3NlbmRtc2co
KSB3YXMgbm90IHVzaW5nIHplcm8tY29weQ0KPiA+ID4gdG8NCj4gPiA+IHNlbmQgdGhlIHhkcl9i
dWYncyBidmVjIHBhZ2VzLCBidXQgaW5zdGVhZCB3YXMgcmVseWluZyBvbiBtZW1jcHkuDQo+ID4g
PiBUaGlzIG1lYW5zIGNvcHlpbmcgZXZlcnkgYnl0ZSBvZiBhIGxhcmdlIE5GUyBSRUFEIHBheWxv
YWQuDQo+ID4gPiANCj4gPiA+IEl0IGxvb2tzIGxpa2UgVExTIHNvY2tldHMgZG8gaW5kZWVkIHN1
cHBvcnQgYSAtPnNlbmRwYWdlIG1ldGhvZCwNCj4gPiA+IHNvIGl0J3MgcmVhbGx5IG5vdCBuZWNl
c3NhcnkgdG8gdXNlIHhwcnRfc29ja19zZW5kbXNnKCkgdG8NCj4gPiA+IHN1cHBvcnQNCj4gPiA+
IFRMUyBmdWxseSBvbiB0aGUgc2VydmVyLiBBIG1lY2hhbmljYWwgcmV2ZXJzaW9uIG9mIGRhMTY2
MWI5M2JmNA0KPiA+ID4gaXMNCj4gPiA+IG5vdCBwb3NzaWJsZSBhdCB0aGlzIHBvaW50LCBidXQg
d2UgY2FuIHJlLWltcGxlbWVudCB0aGUgc2VydmVyJ3MNCj4gPiA+IFRDUCBzb2NrZXQgc2VuZG1z
ZyBwYXRoIHVzaW5nIGtlcm5lbF9zZW5kcGFnZSgpLg0KPiA+ID4gDQo+ID4gPiBSZXBvcnRlZC1i
eTogRGFpcmUgQnlybmUgPGRhaXJlQGRuZWcuY29tPg0KPiA+ID4gQnVnTGluazogaHR0cHM6Ly9i
dWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMDk0MzkNCj4gPiA+IFNpZ25lZC1v
ZmYtYnk6IENodWNrIExldmVyIDxjaHVjay5sZXZlckBvcmFjbGUuY29tPg0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiA+ID4gLS0tDQo+ID4g
PiDCoG5ldC9zdW5ycGMvc3Zjc29jay5jIHwgODYNCj4gPiA+ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystDQo+ID4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA4NSBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9uZXQv
c3VucnBjL3N2Y3NvY2suYyBiL25ldC9zdW5ycGMvc3Zjc29jay5jDQo+ID4gPiBpbmRleCBjMjc1
MmUyYjljZTM0Li40NDA0YzQ5MWViMzg4IDEwMDY0NA0KPiA+ID4gLS0tIGEvbmV0L3N1bnJwYy9z
dmNzb2NrLmMNCj4gPiA+ICsrKyBiL25ldC9zdW5ycGMvc3Zjc29jay5jDQo+ID4gPiBAQCAtMTA2
Miw2ICsxMDYyLDkwIEBAIHN0YXRpYyBpbnQgc3ZjX3RjcF9yZWN2ZnJvbShzdHJ1Y3QNCj4gPiA+
IHN2Y19ycXN0DQo+ID4gPiAqcnFzdHApDQo+ID4gPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDvC
oMKgwqDCoMKgwqAgLyogcmVjb3JkIG5vdCBjb21wbGV0ZSAqLw0KPiA+ID4gwqB9DQo+ID4gPiDC
oA0KPiA+ID4gK3N0YXRpYyBpbnQgc3ZjX3RjcF9zZW5kX2t2ZWMoc3RydWN0IHNvY2tldCAqc29j
aywgY29uc3Qgc3RydWN0DQo+ID4gPiBrdmVjDQo+ID4gPiAqdmVjLA0KPiA+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCBmbGFn
cykNCj4gPiA+ICt7DQo+ID4gPiArwqDCoMKgwqDCoMKgIHJldHVybiBrZXJuZWxfc2VuZHBhZ2Uo
c29jaywgdmlydF90b19wYWdlKHZlYy0+aW92X2Jhc2UpLA0KPiA+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgb2Zmc2V0X2luX3Bh
Z2UodmVjLT5pb3ZfYmFzZSksDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2ZWMtPmlvdl9sZW4sIGZsYWdzKTsNCj4gDQo+
IFRoYW5rcyBmb3IgeW91ciByZXZpZXchDQo+IA0KPiA+IEknbSBoYXZpbmcgdHJvdWJsZSB3aXRo
IHRoaXMgbGluZS4gVGhpcyBsb29rcyBsaWtlIGl0IGlzIHRyeWluZyB0bw0KPiA+IHB1c2gNCj4g
PiBhIHNsYWIgcGFnZSBpbnRvIGtlcm5lbF9zZW5kcGFnZSgpLg0KPiANCj4gVGhlIGhlYWQgYW5k
IHRhaWwga3ZlYydzIGluIHJxX3JlcyBhcmUgbm90IGttYWxsb2MnZCwgdGhleSBhcmUNCj4gYmFj
a2VkIGJ5IHBhZ2VzIGluIHJxc3RwLT5ycV9wYWdlc1tdLg0KPiANCj4gDQo+ID4gV2hhdCBndWFy
YW50ZWVzIHRoYXQgdGhlIG5mc2QNCj4gPiB0aHJlYWQgd29uJ3QgY2FsbCBrZnJlZSgpIGJlZm9y
ZSB0aGUgc29ja2V0IGxheWVyIGlzIGRvbmUNCj4gPiB0cmFuc21pdHRpbmcNCj4gPiB0aGUgcGFn
ZT8NCj4gDQo+IElmIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHkgd2hhdCBOZWlsIHRvbGQgdXMgbGFz
dCB3ZWVrLCB0aGUgcGFnZQ0KPiByZWZlcmVuY2UgY291bnQgb24gdGhvc2UgcGFnZXMgaXMgc2V0
IHVwIHNvIHRoYXQgb25lIG9mDQo+IHN2Y194cHJ0X3JlbGVhc2UoKSBvciB0aGUgbmV0d29yayBs
YXllciBkb2VzIHRoZSBmaW5hbCBwdXRfcGFnZSgpLA0KPiBpbiBhIHNhZmUgZmFzaGlvbi4NCj4g
DQo+IEJlZm9yZSBkYTE2NjFiOTNiZjQgKCJTVU5SUEM6IFRlYWNoIHNlcnZlciB0byB1c2UgeHBy
dF9zb2NrX3NlbmRtc2cNCj4gZm9yIHNvY2tldCBzZW5kcyIpLCB0aGUgb3JpZ2luYWwgc3ZjX3Nl
bmRfY29tbW9uKCkgY29kZSBkaWQgdGhpczoNCj4gDQo+IC3CoMKgwqDCoMKgwqAgLyogc2VuZCBo
ZWFkICovDQo+IC3CoMKgwqDCoMKgwqAgaWYgKHNsZW4gPT0geGRyLT5oZWFkWzBdLmlvdl9sZW4p
DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZsYWdzID0gMDsNCj4gLcKgwqDCoMKg
wqDCoCBsZW4gPSBrZXJuZWxfc2VuZHBhZ2Uoc29jaywgaGVhZHBhZ2UsIGhlYWRvZmZzZXQsDQo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHhkci0+aGVhZFswXS5pb3ZfbGVuLCBmbGFncyk7DQo+IC3CoMKgwqDCoMKgwqAg
aWYgKGxlbiAhPSB4ZHItPmhlYWRbMF0uaW92X2xlbikNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZ290byBvdXQ7DQo+IC3CoMKgwqDCoMKgwqAgc2xlbiAtPSB4ZHItPmhlYWRbMF0u
aW92X2xlbjsNCj4gLcKgwqDCoMKgwqDCoCBpZiAoc2xlbiA9PSAwKQ0KPiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsNCj4gDQo+IA0KPiANCg0KT0ssIHNvIHRoZW4gb25s
eSB0aGUgYXJndW1lbnQga3ZlYyBjYW4gYmUgYWxsb2NhdGVkIG9uIHRoZSBzbGFiICh0aGFua3MN
CnRvICBzdmNfZGVmZXJyZWRfcmVjdik/IElzIHRoYXQgY29ycmVjdD8NCg0KLS0gDQpUcm9uZCBN
eWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UNCnRyb25k
Lm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
