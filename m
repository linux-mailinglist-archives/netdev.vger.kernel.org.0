Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0592F43CA3A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242031AbhJ0NBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:01:23 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:58950
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235978AbhJ0NBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:01:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihpIqSeQl5L0ypSLuejIFwyvfzI5NATTkHCzf7KPqRn9T+gldOvplrl1WdD6J1MZfO/Pix5rUqhnx2CH6w0oKtUMEyqIaC45IKENltWgnLwsfelm6OdrcgciFs+EPXN0CZnAg3JZdmZN+28IkOyR2z1kgrwLQ5UAh2Wni6aVJXm3fWBObYr3lyj8RRPwrFt44pFe16SgDkMWPmSXW72j9ZHgceOvg6GNsLQSukuRnmQHbBXvPo7wEpsFjXtXG42beNYH2qJajexnxQHFa9xt8x7F+jjqiR11sFbSmfbnurvepHtHw4ruUCHVRvHyp2+WOmzqbvc68SidMzFgV+dcRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FrtFdV19jVFj6us7O5gqemP5qFI6E4xlMi/LU2DMAhw=;
 b=jW/7HVGE1e6/48zUGCvWHX3zG801L8kTDlt4YBO2Ww3CtJGIcxHazzwnFl2muLd6CwSOqybpbbYloAmjypRyzRXp7BxPF9jc/wfq/etzVTQa8GIJanCqNdZBzjIMvJT/nbSDP5PNmA1IbG9EK7k5NI3gPvA2OI3+hlQ6fTukn12DfVCWrkxXb4/e+XO+27bKoMgsX+/p5DNrQ5zz/0IT3D2ZInBZxDlrQ3DvcxDbMS57JWYxBMXiQgFMgu2Z3qWPPdxjRYgUUA42dnhjy6ACgvluQ6owOyJbPHQBWLtMMqQ6x/UOUdun749yW+ogZ49zpPI6xGt6o0mOrlgHNvlFrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrtFdV19jVFj6us7O5gqemP5qFI6E4xlMi/LU2DMAhw=;
 b=hqvnQqXalO9tTKOf/h6pV3EVW+artsoNzK/sF6usN6jA2CQMzYAz1xgdjpOx6geQ6E9dGKxmkJ8v3B+u1SpiJIwzlnOT7TwxAzpOj9equHfKLKQVR4sMWaWXtI5Ibyy+cXzKDuSd1P7We+dtpuar4VkcWGWspO1aI/4mNneULlQ=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by SN6PR02MB4319.namprd02.prod.outlook.com (2603:10b6:805:ac::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 12:58:56 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::4513:36a7:3adf:3b0f]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::4513:36a7:3adf:3b0f%7]) with mapi id 15.20.4649.015; Wed, 27 Oct 2021
 12:58:56 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Michal Simek <michals@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: mdio: separate gpio-reset property per child phy usecase
Thread-Topic: mdio: separate gpio-reset property per child phy usecase
Thread-Index: AdfLMkaiDAtsCpNITLKzSmdhMK2gug==
Date:   Wed, 27 Oct 2021 12:58:55 +0000
Message-ID: <SA1PR02MB85605C26380A9D8F4D1FB2AAC7859@SA1PR02MB8560.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 738c203f-c190-463a-9779-08d999498909
x-ms-traffictypediagnostic: SN6PR02MB4319:
x-microsoft-antispam-prvs: <SN6PR02MB4319E414818F0B07F0B78445C7859@SN6PR02MB4319.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:792;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U0t4feieFXSj3gM43hr/cBZyQO2OlaAhdjdEW5fDB8FpHXuoVuV0OW3NO3dU66wFQZ8F7T3O6ZEZcBoJNxNA42gjMemGJ1vbl0fcTKmGLVoR2jnV8jAt+61ScB5ji0QPF48kG9lnyVj2RbEP4/6pzAvKut1tYmFTAF9WY5qcZpKMgVk7dYB+gp23WRags2VdzvVIF3WNpsTPRzRxO9axHdK/ZKa0YnFvj2+SI7K8+KMt17ESF1er/XHjJt3mkwwJeAgtAdbngmMJtBbwVDOgitra/lLJFNXjXM2dlYV76NQkLPbjKsD68/fLhwvXZN9Pv/Kzy241eBBE9TCVG1eQhTzyM+bOxIZD4hfUZW9BHCLQBaG/efoXlRk9zXv/3P74N0LsmuZrPZ+U68DTAGTMt6gSH7E9H2BAxJy6Ywaa0AQWQB0bwyi4X/4dIh88gsZsI3Ue/XDYZGRMbbWi4vsymubfXuE+ESqlh4HZAHt2LeOT8NZgtLjBCXCAFrWj/ZzrPuySAEl61H6Lqfe+c3Z5tTLIqx0Cs2JaLjBjVxxxa/tNWtV9/PtzBEYagJZ22QFo9JP9n4ENRYBex5TKi27paaom05h3FcQORa+4tC8o8SK1x5Roylm7KfeLbo8fCCR310HHsuaIaNiEyDuutofghwJYqMu58OYd5w0vPLCdBd9PbYlNW03U0eMEu3zc6GNSH8d0hI+L7N/kJ179lL0xkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(107886003)(66476007)(8936002)(66556008)(122000001)(2906002)(316002)(508600001)(7696005)(64756008)(66946007)(52536014)(66446008)(76116006)(55016002)(8676002)(6506007)(54906003)(33656002)(26005)(5660300002)(71200400001)(186003)(4326008)(9686003)(86362001)(83380400001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUpvajNWNUtDTFFRa3V2TnhqRlFNak9xWmRZZloxTDF6QWdIOWxkUFhYMVdH?=
 =?utf-8?B?TXRuN2VUWmN4T0NpZy9obU9vNkFPcHIrN1B3RXVEeGcyTGdqYzZpalpObXRk?=
 =?utf-8?B?V0tZd0Rtc2pjV2hycDRzaWlpVjRORkNMQVhubHVkUkZzVkkvY3NyYk9nL0hH?=
 =?utf-8?B?Nit3eDVvQXRjYXY4VkVWeHhEUERXZGdFRWFXVVVhRkIvZENSNXovTjlGL1do?=
 =?utf-8?B?MVlXMnlFdHlDR0p1cG9lWGV5RVpQZUp0ZFIxWk0wMjhIY0pwV3JxcDA0NFBa?=
 =?utf-8?B?TEU4d2dwRXNHMlk0OVJTMk5mTUNzbVBYTUpQblJ2QldwMzhhZHdGbGtjNkFB?=
 =?utf-8?B?c1o2aWQzS1FTNGs1c2ZRWHowVlZ4UkQxZVk3WmVLZmhkZk1wbWpCUlFIL2sv?=
 =?utf-8?B?ZXFJMTBOUW92S1RISzBEQ2JiMVNsU1QzZHJ3a2NSd2R0Tk9yRjFBc2w3TzBk?=
 =?utf-8?B?SVRuVkdUODZOUVBYNktmbm9WTGRtdHZWcHhoOHRFK0k0bkRWZEhtbW9hUnhs?=
 =?utf-8?B?Q3VNRitMSlN3STlpNzhOWDJzQzMvbXRhMkE0Ui91WStYc0I0Y0tpMWVsd2dn?=
 =?utf-8?B?REM0ZjViZ01NUzFSYk5NRzlaczVqUDMzSUpQbk83YXNnL1pzRW9iNmtjYUdq?=
 =?utf-8?B?b0FjWkRKMkw3RFVoUXdmekROWlY5T0d2TkVpL3VUcnQ4SXZUZU5VdUF6SG9G?=
 =?utf-8?B?SmNEQjFkbTJGcUVVSXJzZk9rMGdOaFhXdis1WmYyWnk4YjVhNkRla2JOeGth?=
 =?utf-8?B?SVRkQXdRUUtaREVpdU9BZmZPejBvZXc5OVBzbjRHYkZDa3VhRWszWDlOL3hn?=
 =?utf-8?B?eDZZSGFGL29JSk8vc0p1eDJKelZVMWd5WjQ4b2ZBMk04RHRCSFV5ZWZOdGls?=
 =?utf-8?B?WlNNVDRFeEp1ZEdob3hHM25hL2Nmbk1rMkJaYXhLNG8ydjNFUUtlbFkrbDVa?=
 =?utf-8?B?bjVoOFl6TWNic2pHZUt5d3hnWVVKdWtKdkdIcTZxYjV6MmczNGQwc1ZNOVNN?=
 =?utf-8?B?MlIxNWd6L2d5Zm84MUNaRldFak94RmljZjhqZndnZFl0dzQ4Wk5TWm9pQjg5?=
 =?utf-8?B?UDJRUWhkN0RGM05DV1hWR3RrMEhqUVpkaFUwUTVHK3JtaFBoL1o1OXFvUzRt?=
 =?utf-8?B?RTZzcVNIZllsZXhUSERja01YcVhoQStCVTkxdjE1dVBrQ2dwaVB6M0tqanAy?=
 =?utf-8?B?YjNsZk5PUkRTQmtrZndpVWVaT1N2eUowQVlLaU91OU1GNnFWc3gwWlp2OXVW?=
 =?utf-8?B?SHRxNW53UzFJWHl3SzViSGdyd2xKSFkxQWNicXoyR2c5TWRNOTk1U2Ywb09M?=
 =?utf-8?B?QXIvaTJYWW5INHNyUitVeGFTWWJkTHYrNTVBbVVUYlQrbU9SZkh2RCt1SlFQ?=
 =?utf-8?B?VFRoV0xlMndvVTRacnZobjg5VllWOVFMTFR2VW5rQ3U1NkQrQXcvZWFFb2xF?=
 =?utf-8?B?Z2lTbnRFTkJHZkRPMWlnR2tjZXpaNitWRFVhTTFTcmtZU1U2ZFdLclh2Tkxr?=
 =?utf-8?B?S3hVdlBNbkZzRWpHTmVCK0hYY3RwZkNyU25iZ0l3aUFPRkh2SXlRWUZGK1p1?=
 =?utf-8?B?a0sybDVMUXYrVWFhYjBMOUQxTXJaT1Q2bFZqL0kxZVNpSEY5aGpuc3pMU1ov?=
 =?utf-8?B?a2J2M0lOdUJETkNMdzZ6MVoxOGlQZEEzTEd2REFDY1JEVUw4UnpCMGt5Zkht?=
 =?utf-8?B?VXpzRHM1SWZMZXduay9sMGd2OFhmR1gvNllEYlZuUTl4MXo5NXh0UGVNU3du?=
 =?utf-8?B?UzQxZWpCakNKT3ptbW4xWmZoZHg2QXZHWTFCQzg1V3hkaDZqbFRXY2ZKenp1?=
 =?utf-8?B?UjhRVFkvRXRGQWxJeXc2Y1c3TDQ5ZEV2bDl3bWtrMDFIa0dtWnc0US9yMU4r?=
 =?utf-8?B?b0ZhVzljRWh4c29xZ3RNOWFTdEQ3Wm9kdW9PYjh5ZFlhUnFnODgwREwwazFm?=
 =?utf-8?B?SHlJMmN4aElpRVY5MllkenM0RDNCNkVmVWhPTkVvMGc2aGFQOXdzbHkxK0Vn?=
 =?utf-8?B?c0NFZWUvM3BpZkRYVGJBZVJsRi9udy9maURlU3JvM1I4VjFFZDREWmhTV0Jx?=
 =?utf-8?B?ZTg3TXN6UkRjVlZPQTNoQ0pxdnZzVlNkZUZCY3hpM1gzUFdhV2l0UC8ySDZN?=
 =?utf-8?B?NXBUVGtWcWRRaDlVMk9ZVUxyaVZhRndCMVJDNEpMMWhaeHJmUWkraWZPWGJQ?=
 =?utf-8?Q?7dFz06n56EP3P7m1lRRE3eA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 738c203f-c190-463a-9779-08d999498909
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 12:58:55.9768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jCW4j2mrW7pfgObuTPRSlRSN0Z3r+i7b4CHMaKpnJlrUD6IODnqXxnHxNcAoSCr3Uv67z4oPtBR8fbLQ9W/9Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4319
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWxsLA0KDQpJbiBhIHhpbGlueCBpbnRlcm5hbCBib2FyZCB3ZSBoYXZlIHNoYXJlZCBHRU0g
TURJTyBjb25maWd1cmF0aW9uIHdpdGgNClRJIERQODM4NjcgcGh5IGFuZCBmb3IgcHJvcGVyIHBo
eSBkZXRlY3Rpb24gYm90aCBQSFlzIG5lZWQgcHJpb3Igc2VwYXJhdGUNCkdQSU8tcmVzZXQuDQoN
CkRlc2NyaXB0aW9uOg0KVGhlcmUgYXJlIHR3byBHRU0gZXRoZXJuZXQgSVBzIGluc3RhbmNlcyBH
RU0wIGFuZCBHRU0xLiBHRU0wIGFuZCBHRU0xIHVzZWQNCnNoYXJlZCBNRElPIGRyaXZlbiBieSBH
RU0xLg0KDQpUSSBQSFlzIG5lZWQgcHJpb3IgcmVzZXQgKFJFU0VUX0IpIGZvciBQSFkgZGV0ZWN0
aW9uIGF0IGRlZmluZWQgYWRkcmVzcy4gDQpIb3dldmVyIHdpdGggY3VycmVudCBmcmFtZXdvcmsg
bGltaXRhdGlvbiAiIG9uZSByZXNldCBsaW5lIHBlciBQSFkgcHJlc2VudCANCm9uIHRoZSBNRElP
IGJ1cyIgdGhlIG90aGVyIFBIWSBnZXQgZGV0ZWN0ZWQgYXQgaW5jb3JyZWN0IGFkZHJlc3MgYW5k
IGxhdGVyDQpoYXZpbmcgY2hpbGQgUEhZIG5vZGUgcmVzZXQgcHJvcGVydHkgd2lsbCBhbHNvIG5v
dCBoZWxwLg0KDQpJbiBvcmRlciB0byBmaXggdGhpcyBvbmUgcG9zc2libGUgc29sdXRpb24gaXMg
dG8gYWxsb3cgcmVzZXQtZ3Bpb3MgDQpwcm9wZXJ0eSB0byBoYXZlIFBIWSByZXNldCBHUElPIHR1
cGxlIGZvciBlYWNoIHBoeS4gSWYgdGhpcw0KYXBwcm9hY2ggbG9va3MgZmluZSB3ZSBjYW4gbWFr
ZSBjaGFuZ2VzIGFuZCBzZW5kIG91dCBhIFJGQy4NCg0KbWRpbzogbWRpbyB7DQogI2FkZHJlc3Mt
Y2VsbHMgPSA8MT47DQojc2l6ZS1jZWxscyA9IDwwPjsNCnJlc2V0LWdwaW9zID0gPCZzbGc3eGw0
NTEwNiA1IEdQSU9fQUNUSVZFX0hJR0g+LCANCjwmc2xnN3hsNDUxMDYgNiBHUElPX0FDVElWRV9I
SUdIPjsNCjxzbmlwPg0KIHBoeTA6IGV0aGVybmV0LXBoeUA0IHsNCn07DQpwaHkxOiBldGhlcm5l
dC1waHlAOCB7DQp9Ow0KfTsNCiANClRoYW5rcywNClJhZGhleQ0KDQo+IGNvbW1pdCA0YzVlN2Ey
YzA1MDFiZDUzMWFhZDFkMDM3OGM1ODlhOTJjYjNjYzMxDQo+IEF1dGhvcjogICAgIEZsb3JpYW4g
RmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBBdXRob3JEYXRlOiBUdWUgQXByIDI1
IDExOjMzOjAzIDIwMTcgLTA3MDANCj4gQ29tbWl0OiAgICAgRGF2aWQgUy4gTWlsbGVyIDxkYXZl
bUBkYXZlbWxvZnQubmV0Pg0KPiBDb21taXREYXRlOiBXZWQgQXByIDI2IDE0OjQ1OjM0IDIwMTcg
LTA0MDANCj4gDQo+ICAgICAgZHQtYmluZGluZ3M6IG1kaW86IENsYXJpZnkgYmluZGluZyBkb2N1
bWVudA0KPiANCj4gICAgICBUaGUgZGVzY3JpYmVkIEdQSU8gcmVzZXQgcHJvcGVydHkgaXMgYXBw
bGljYWJsZSB0byAqYWxsKiBjaGlsZCBQSFlzLiBJZg0KPiAgICAgIHdlIGhhdmUgb25lIHJlc2V0
IGxpbmUgcGVyIFBIWSBwcmVzZW50IG9uIHRoZSBNRElPIGJ1cywgdGhlc2UNCj4gICAgICBhdXRv
bWF0aWNhbGx5IGJlY29tZSBwcm9wZXJ0aWVzIG9mIHRoZSBjaGlsZCBQSFkgbm9kZXMuDQo+IA0K
PiAgICAgIEZpbmFsbHksIGluZGljYXRlIGhvdyB0aGUgUkVTRVQgcHVsc2Ugd2lkdGggbXVzdCBi
ZSBkZWZpbmVkLCB3aGljaCBpcw0KPiAgICAgIHRoZSBtYXhpbXVtIHZhbHVlIG9mIGFsbCBpbmRp
dmlkdWFsIFBIWXMgUkVTRVQgcHVsc2Ugd2lkdGhzIGRldGVybWluZWQNCj4gICAgICBieSByZWFk
aW5nIHRoZWlyIGRhdGFzaGVldHMuDQo+IA0KPiAgICAgIEZpeGVzOiA2OTIyNjg5NmFkNjMgKCJt
ZGlvX2J1czogSXNzdWUgR1BJTyBSRVNFVCB0byBQSFlzLiIpDQo+ICAgICAgU2lnbmVkLW9mZi1i
eTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQo+ICAgICAgUmV2aWV3
ZWQtYnk6IFJvZ2VyIFF1YWRyb3MgPHJvZ2VycUB0aS5jb20+DQo+ICAgICAgU2lnbmVkLW9mZi1i
eTogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0K
