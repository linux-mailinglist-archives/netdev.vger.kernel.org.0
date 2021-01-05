Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BF92EAD9B
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbhAEOpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:45:33 -0500
Received: from mail-eopbgr690048.outbound.protection.outlook.com ([40.107.69.48]:43939
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726551AbhAEOpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:45:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQWIMsSwjcajxdifE5zT8D2YyfF4ydCYkawdRCActFo4HPtb/z5QvSK/5hBp/wGICzukkSFYp/4k6hqmUHoA0IoyWwdfxsxeva3NSIwrujCO1j5Q5G2pztvN8me8lj9pLd3E81J+Z0Uwt8sSP3yM+BhfIbG9iyWS0CeHZxOAQ4SFrxca8dqsDr7vQhIqg0xTE8h3hrIbfjNswrNOI0Y5IEivtQoLkv+X8D5M93bdpDwJzOI+BMfVl/OOlWrGH+q3ZYwOVd8BnrOA94Rd1wsMftVh2qTUIgQVUygfX68RKjt23Oh246kFBRcmjd2NERf88J/y8pURroJF0iWUCsDNwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLSnhMg4Nl4wbca9VN/9fvHFhTwGYC0IiYM9tSVi4Ms=;
 b=L67Y9yCD/Xj5eYnBZGCHv/2NYn1r84V5PtOYNAlQ8B2S0qpSPu65PLcIj/BITmH3ZlYSe2x6lpaCRob0Nc6vls/NwSxdgDySNlVx9kSvvDT5cZfDYe3eh34Cs6MCOK+JU491w/4IYvLfDC+NlJ0A/4zaPaSPUsTDazJcG58772QDLAg/StpG80FvUZNdz1H9D+Id/Iq+K1eOzzGKkpHKti+lwYVI2kxuZEUWOU7k3Z+0isECwZLGIbPvozKmDLLep+K8ne1yuxCmmmnV7XBj5BrHqx4YiYxygwhTc4fL5AKxAnm/6HBChrsMEwRFitF1NEdCVycMnRGkAmJon3jZmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLSnhMg4Nl4wbca9VN/9fvHFhTwGYC0IiYM9tSVi4Ms=;
 b=XmEFTxdKCO+xx3vW6o/kuaQQuiTl4IDcYFqIjgDFC99PvSg4MA0LP7I8H4kBVbM0ndvEE7nqWLgqrFjHH4Rynqz8UOReeL66JDN2I7MdjjiAyRvANAzZWUP4t0ydwPeiVJu3DitTvC4gK+r/qdxXNiMoTn0r74IFiKkgpwVrXE0=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR1001MB2165.namprd10.prod.outlook.com
 (2603:10b6:910:42::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 14:44:31 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::e83b:f5de:35:9fa7]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::e83b:f5de:35:9fa7%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 14:44:31 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "leoyang.li@nxp.com" <leoyang.li@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "murali.policharla@broadcom.com" <murali.policharla@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "qiang.zhao@nxp.com" <qiang.zhao@nxp.com>
Subject: Re: [PATCH 01/20] ethernet: ucc_geth: set dev->max_mtu to 1518
Thread-Topic: [PATCH 01/20] ethernet: ucc_geth: set dev->max_mtu to 1518
Thread-Index: AQHWyzvztwOyjy9i30WJ0/nUUTDGzanvkBgAgCm0fACAAARoAIAAAxgA
Date:   Tue, 5 Jan 2021 14:44:31 +0000
Message-ID: <6c56889ce3d0e9fc7a6ca7e7a43091b1ae8cd309.camel@infinera.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
         <20201205191744.7847-2-rasmus.villemoes@prevas.dk>
         <20201210012502.GB2638572@lunn.ch>
         <33816fa937efc8d4865d95754965e59ccfb75f2c.camel@infinera.com>
         <X/R4tqny72Bjt28b@lunn.ch>
In-Reply-To: <X/R4tqny72Bjt28b@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06c3433e-dd15-4c0b-b762-08d8b1886999
x-ms-traffictypediagnostic: CY4PR1001MB2165:
x-microsoft-antispam-prvs: <CY4PR1001MB2165C2A4D2D3C452ACBD9B39F4D10@CY4PR1001MB2165.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jvmBQY3/d0fVANPGbCIJFUJlNb5MxsYKhyGV3Wc86c/wp/sEuTSOwrj50ltjEpjI1bAOyIJ6UGx34XzemBsy0ZgRhEQA82PMhBzZWDeu7LqHm/6u9LvvDuFjkJ8/7K8/ZyALmCwpHTabcvhHvEo58d8Fezuvr+OFw2X6Z1sNU/zBQFB3uBVS6vKy5GuiVFQBkGDNkN4z00BmPP8yfKBxAZM1/J0ci6YQtxXw3Oea9HC1ROLbaupuzfPp62V83t6wTcT79cB8UahAB7rWFiFLLzPDkZjfiXiVJzLEjZcGlEVFeup1LFhAkLhGl3mHH3W7tS3Xe19QSMiudCQ6JB3f9sx1sBRTpEPGqEPYyixOihnYboBtvt4ZUQdn0R6RrXpiLN8BYlK0pdnT6kOhjyfxmep4ZMwexJMKy5IOZMFmfNr3BBKqlkO3x2GEXc5nbtuINWe7OtTqLJx5afvhV1LJfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39850400004)(366004)(136003)(376002)(2616005)(4001150100001)(4326008)(86362001)(76116006)(45080400002)(5660300002)(36756003)(186003)(83380400001)(8936002)(6916009)(66446008)(71200400001)(64756008)(2906002)(54906003)(8676002)(66476007)(6486002)(66556008)(66946007)(6506007)(966005)(316002)(478600001)(7416002)(6512007)(91956017)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?clo1NE5LNGxZcy9NcE9GWTRLc3VKWnMxb0Y5VnFEaXRDVXBRbVQ0aTlpZzBz?=
 =?utf-8?B?Q3hPVUpHYjlxS2dieHJjYWZkWVFLMS9FRDJMU0lYOGZYVzlaYk5qYVU0b1JD?=
 =?utf-8?B?NEw1L3JBSWNLUC95d2ttaHRxNUdIbG1xTXBTbmhQMmM3a3o3a1BFQ284RkI4?=
 =?utf-8?B?ZWxUc1Yyc1FSeWNLTTFuaGQ2R2JROTNDOFZkcTQwK21ubHNGcmg4VHAzZHFR?=
 =?utf-8?B?cUxPaFdQeFFLa2xhWGlpNjQrekNKR1dyc3IzSUZXU1RLTS9tbTN5TDF4ZlFC?=
 =?utf-8?B?OTgyZG9HWUkrczBIV1pGYmFCVlhmTHd6cDFUVng1TVJXQXh1VVVKZlpsS1Mz?=
 =?utf-8?B?eGdVNUp1L3lTZ1BHL1l3enV5aXJpTFA0c0p2MGFmSVBwb09MS1lsaXlxTkVO?=
 =?utf-8?B?d05ZZ3MwR1Y1VXVidUpxUUFDdzBIVklsT0ZteWwwM242dnFUUEY5bEdPd2lQ?=
 =?utf-8?B?cVdZVmtyT09DVWNGdXR0b3RCZUJUZ3lVVk1QdUVEY2NUMGV1azVxbGNRS1Nt?=
 =?utf-8?B?bzloU1M0OEFwanRmOWdQelRXQmw5OGFldlF1aVlFbFQ1aHdOVUtIZk5UQUVU?=
 =?utf-8?B?a1B0bm83ekZSeWc4TnduNVpWK0FKZHFETDZmUnFyckhpaG1kVUdYM2ZLTUxH?=
 =?utf-8?B?NUFpVi9rWEVOdjd6Q0h3K0lUcjZvZC83N1AvOGcrZk5jMGdpcTJBQ21IUHo4?=
 =?utf-8?B?cHFxdFNQdUErSWRNbTdWbmNucHo0cWR5cFRrSkhWRjV3czdmMzh3VGpUL1d4?=
 =?utf-8?B?bDdQWUs5dDltTVhVVy9qQlBSbTI4TUJyZ2VNcGJsL1haNldKSWtXWGJoUHo4?=
 =?utf-8?B?ME4xQnk1UXd2YW5JNHV3NHZ2UkcwOGRoSytFaHBSTElmZ0ppNEs2OUdBbXc5?=
 =?utf-8?B?NDdXbXR1V01leEM5eUVZNDBDd0ltQUdVVnM4Q3hRN0pNbzFEbDdRR0VPVmFs?=
 =?utf-8?B?SXZXOVVTWnVmNHhqRkNhZHNzTUlmYXErYUpwRjR1Ym1LQ1g2aExQREE1aG9Z?=
 =?utf-8?B?QkE4TWlLT3Y2b0xPWm9VaEFYNnpNcmR3MXpoVk1xQ3Q2d1VZZ3JNN3Y4Q1ZG?=
 =?utf-8?B?RDMxdGc2aVZob2tqWW5Hc3RPVnd0QU1JN2RVc2ZvejNVWEF5NjRXVjZuRERz?=
 =?utf-8?B?K1lvVVlGL0R0WUxOWHN5YXJDQndKeUdmaXlGdjFVVC9kY0luOU82cWlmSmV3?=
 =?utf-8?B?WnZ1ZGV4U2NveUJXYnVMdjdpT3hRb0c4RlhROWwyUUFCalo1MHl5SDcwMWtO?=
 =?utf-8?B?TS9NUTZsRGxWaDQ5LzFDUmFOWjFpNmdCZC9rTkJPTlZEMlRPLzZpY2UzV3JK?=
 =?utf-8?Q?fvSxrrFdLGcxmIVj0XtLHFTxsKguVimvZo?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <31DE7C97436FF14793197386DDDCB482@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c3433e-dd15-4c0b-b762-08d8b1886999
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 14:44:31.7076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wSQDEA6PkRYVyk8ZXedpdlRPZMIul5nJBm+zIhece0u0H20wujI/PzodQQjoTzFhTa3kusfV1xJKHai/iVzuCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2165
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTA1IGF0IDE1OjMzICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gVHVlLCBKYW4gMDUsIDIwMjEgYXQgMDI6MTc6NDJQTSArMDAwMCwgSm9ha2ltIFRqZXJubHVu
ZCB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMjAtMTItMTAgYXQgMDI6MjUgKzAxMDAsIEFuZHJldyBM
dW5uIHdyb3RlOg0KPiA+ID4gT24gU2F0LCBEZWMgMDUsIDIwMjAgYXQgMDg6MTc6MjRQTSArMDEw
MCwgUmFzbXVzIFZpbGxlbW9lcyB3cm90ZToNCj4gPiA+ID4gQWxsIHRoZSBidWZmZXJzIGFuZCBy
ZWdpc3RlcnMgYXJlIGFscmVhZHkgc2V0IHVwIGFwcHJvcHJpYXRlbHkgZm9yIGFuDQo+ID4gPiA+
IE1UVSBzbGlnaHRseSBhYm92ZSAxNTAwLCBzbyB3ZSBqdXN0IG5lZWQgdG8gZXhwb3NlIHRoaXMg
dG8gdGhlDQo+ID4gPiA+IG5ldHdvcmtpbmcgc3RhY2suIEFGQUlDVCwgdGhlcmUncyBubyBuZWVk
IHRvIGltcGxlbWVudCAubmRvX2NoYW5nZV9tdHUNCj4gPiA+ID4gd2hlbiB0aGUgcmVjZWl2ZSBi
dWZmZXJzIGFyZSBhbHdheXMgc2V0IHVwIHRvIHN1cHBvcnQgdGhlIG1heF9tdHUuDQo+ID4gPiA+
IA0KPiA+ID4gPiBUaGlzIGZpeGVzIHNldmVyYWwgd2FybmluZ3MgZHVyaW5nIGJvb3Qgb24gb3Vy
IG1wYzgzMDktYm9hcmQgd2l0aCBhbg0KPiA+ID4gPiBlbWJlZGRlZCBtdjg4ZTYyNTAgc3dpdGNo
Og0KPiA+ID4gPiANCj4gPiA+ID4gbXY4OGU2MDg1IG1kaW9AZTAxMDIxMjA6MTA6IG5vbmZhdGFs
IGVycm9yIC0zNCBzZXR0aW5nIE1UVSAxNTAwIG9uIHBvcnQgMA0KPiA+ID4gPiAuLi4NCj4gPiA+
ID4gbXY4OGU2MDg1IG1kaW9AZTAxMDIxMjA6MTA6IG5vbmZhdGFsIGVycm9yIC0zNCBzZXR0aW5n
IE1UVSAxNTAwIG9uIHBvcnQgNA0KPiA+ID4gPiB1Y2NfZ2V0aCBlMDEwMjAwMC5ldGhlcm5ldCBl
dGgxOiBlcnJvciAtMjIgc2V0dGluZyBNVFUgdG8gMTUwNCB0byBpbmNsdWRlIERTQSBvdmVyaGVh
ZA0KPiA+ID4gPiANCj4gPiA+ID4gVGhlIGxhc3QgbGluZSBleHBsYWlucyB3aGF0IHRoZSBEU0Eg
c3RhY2sgdHJpZXMgdG8gZG86IGFjaGlldmluZyBhbiBNVFUNCj4gPiA+ID4gb2YgMTUwMCBvbi10
aGUtd2lyZSByZXF1aXJlcyB0aGF0IHRoZSBtYXN0ZXIgbmV0ZGV2aWNlIGNvbm5lY3RlZCB0bw0K
PiA+ID4gPiB0aGUgQ1BVIHBvcnQgc3VwcG9ydHMgYW4gTVRVIG9mIDE1MDArdGhlIHRhZ2dpbmcg
b3ZlcmhlYWQuDQo+ID4gPiA+IA0KPiA+ID4gPiBGaXhlczogYmZjYjgxMzIwM2U2ICgibmV0OiBk
c2E6IGNvbmZpZ3VyZSB0aGUgTVRVIGZvciBzd2l0Y2ggcG9ydHMiKQ0KPiA+ID4gPiBDYzogVmxh
ZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9m
Zi1ieTogUmFzbXVzIFZpbGxlbW9lcyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+DQo+ID4g
PiANCj4gPiA+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+ID4g
PiANCj4gPiA+IMKgwqDCoMKgQW5kcmV3DQo+ID4gDQo+ID4gSSBkb24ndCBzZWUgdGhpcyBpbiBh
bnkga2VybmVsLCBzZWVtcyBzdHVjaz8gTWF5YmUgYmVjYXVzZSB0aGUgc2VyaWVzIGFzIGEgd2hv
bGUgaXMgbm90IGFwcHJvdmVkPw0KPiANCj4gSGkgSm9ha2ltDQo+IA0KPiBXaGVuIHdhcyBpdCBw
b3N0ZWQ/IElmIGl0IHdhcyB3aGlsZSBuZXRkZXYgd2FzIGNsb3NlZCBkdXJpbmcgdGhlIG1lcmdl
DQo+IHdpbmRvdywgeW91IG5lZWQgdG8gcmVwb3N0Lg0KPiANCj4gWW91IHNob3VsZCBiZSBhYmxl
IHRvIHNlZSB0aGUgc3RhdHVzIGluIHRoZSBuZXRkZXYgcGF0Y2h3b3JrIGluc3RhbmNlDQo+IA0K
PiBodHRwczovL25hbTExLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0
cHMlM0ElMkYlMkZwYXRjaHdvcmsua2VybmVsLm9yZyUyRnByb2plY3QlMkZuZXRkZXZicGYlMkZs
aXN0JTJGJmFtcDtkYXRhPTA0JTdDMDElN0NKb2FraW0uVGplcm5sdW5kJTQwaW5maW5lcmEuY29t
JTdDMjU2MTVmNGMwMGE0NDk1OTgxMDIwOGQ4YjE4NmU0OTYlN0MyODU2NDNkZTVmNWI0YjAzYTE1
MzBhZTJkYzhhYWY3NyU3QzElN0MwJTdDNjM3NDU0NTQwMjE3MTEyMjUyJTdDVW5rbm93biU3Q1RX
RnBiR1pzYjNkOGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsx
aGFXd2lMQ0pYVkNJNk1uMCUzRCU3QzEwMDAmYW1wO3NkYXRhPTAwbCUyRkJZeXhuQW9zaEgxYVpN
d0V6blZGUVpYd2FZR2UzcFRvNlIzUkczUSUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiANCj4gCUFuZHJl
dw0KDQpIaSBBbmRyZXcNCg0KSSBmb3VuZCBoZXJlOiANCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5l
bC5vcmcvcHJvamVjdC9uZXRkZXZicGYvcGF0Y2gvMjAyMDEyMTgxMDU1MzguMzA1NjMtMi1yYXNt
dXMudmlsbGVtb2VzQHByZXZhcy5kay8NCg0KU2VlbSB0byBiZSB1bmRlcndheSBidXQgc3RhYmxl
IGlzbid0IGluY2x1ZGVkLCBJIHRoaW5rIGl0IHNob3VsZCBiZS4NCg0KIEpvY2tlDQo=
