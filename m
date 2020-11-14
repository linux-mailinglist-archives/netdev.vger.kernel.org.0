Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAA12B2FEB
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgKNS5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:57:49 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21892 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726219AbgKNS5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 13:57:48 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEIvlni004718;
        Sat, 14 Nov 2020 10:57:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=CUPNMQ3boJ5tE4rYKPaec8CIxHLEPMyAMNKd4dFfBUA=;
 b=ZT4RKQSQG8/zBRLeph4Cxt5y3l4Ac+T9MmGBbZ+Xhw5qAYfuWpoeQVPppiIl9XW1nNAi
 MuLIMdO+JCxtxehey/WjhAS2ic3+UELBfm1YEX3vBGJ5IIt8QLNfxm9lTG0mvF+xrbS1
 TXCilAtEE+CUzCRftChi2oqq7kn2d9GEokaIBT/c7kZmd2uDtoxZJzXDnGzFwsw/Fou4
 x5tT1OP0qWL8dJKYKUmpLUz1/HaRkWM8hSokNUkXjWQ0FjAmTpfOQ+xuzJwEVpILu1JG
 CFd1nzS5yMbw8tq8N72Ti0+XfA7CtyDVBFjL9QmsLXpFhYF+jHQs6u6R4GhveSkyc8eE eA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdftrvvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 10:57:47 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 10:57:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 14 Nov 2020 10:57:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCLC5oe2cLj+yXxLsRVDWQPmxRRQa4OOpBwElxGGjq8EcOt0q4m+ri9LJGWAs1skkNEHKx6S/297H0A32hqdQQj6LnCX4jkVC1OjF98hgOMqHDRcdHikEhAxjBmXv089h7VLG4cX878M25jRcKS2Ae1ebwBPL/ELVuVMfiIR73YMcF/f8YIuj9NUok4Yhstn4e9owejlwJkEFUg8a9SoLRYSasNR9BbTvp/5PPL3DZ2tiPCzBqXWavPaVgtbXtnunK8jaEMPfxLsumdQNX76PtKPpT1gsTlUOFtOduXQTzKG0vZK9QIrnIFYpbM71LNYmrpP4aP1DPRdsU3sBqFq+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUPNMQ3boJ5tE4rYKPaec8CIxHLEPMyAMNKd4dFfBUA=;
 b=LaK+CFHa6rbieMSvwZ1w548763wgEPQ6d9E7qFAkqGv2aOKLwKllbJl8qxgcweVEm7JqgUXG5y3MyfKSECyxVfMVTAb8BAOE0QkiFRd/oLHQD167Ig3iTMWYkW1NdWbiUkehr1WlyNR4U0v+gwj1iwngFqeaSklv3Ahhp274Zq4ig4Cxhh1yDhz1XWwgNpNqD8Udejzr96OscodZTlzUwgMAUcc97dXwIeMSRwG4HPef+z5UdBZGqNhjQqe7CPJSTPqWzyQREF9+R5hwNgGoF7XnIL30QQUV27hIj3goqdJl3bQEB5XOcz7hXBpimoPn3bW8/E/VhpVgYzLCtETEWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUPNMQ3boJ5tE4rYKPaec8CIxHLEPMyAMNKd4dFfBUA=;
 b=Po7dfMTaWIipe7a3N3NRN9NxrRgsWiJwy+6zz4Xpz8pmoT+yRiaofnWh5R6d/cR9/KaWvtbmtPWCIMl9HgbpnbDtzs28DH9AYO1f6wTpHclDG1yK/mtnVLDDtJ6qU3xrcSfdccvli7/V1f8swtZmapKDCpACAWbu/wS+wE6cleg=
Received: from DM6PR18MB3212.namprd18.prod.outlook.com (2603:10b6:5:14a::15)
 by DM6PR18MB2442.namprd18.prod.outlook.com (2603:10b6:5:181::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Sat, 14 Nov
 2020 18:57:43 +0000
Received: from DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef]) by DM6PR18MB3212.namprd18.prod.outlook.com
 ([fe80::a1ad:948b:abf5:a5ef%7]) with mapi id 15.20.3541.025; Sat, 14 Nov 2020
 18:57:43 +0000
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: [PATCH v3 net-next 07/13] octeontx2-af: Add debugfs entry to dump
 the MCAM rules
Thread-Topic: [PATCH v3 net-next 07/13] octeontx2-af: Add debugfs entry to
 dump the MCAM rules
Thread-Index: Ada6t8Lx8rvbvkCYR2y97vX471qM6A==
Date:   Sat, 14 Nov 2020 18:57:43 +0000
Message-ID: <DM6PR18MB321287B069E8AC8147B2162CA2E50@DM6PR18MB3212.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.206.46.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04add446-4fed-4fb7-7229-08d888cf2b23
x-ms-traffictypediagnostic: DM6PR18MB2442:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB2442DDC8884EE7CCB0F27861A2E50@DM6PR18MB2442.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FJ28U9iABKO5unjZN3i4Fuf/ukHvUD+Mn/3tqFWbXgIvP6S4ItlSBjl2WBHOEpWP/DbKk728vepyrOlRp/hyh+4jwQHLCrdW3cOtd59T1OugfCqGBWm5FoHpOoI+cWvuS4h48odSXoZ8+FLSrk9yrxJi6bjo++ltWqvr5qsqEeN5iRQhFmm89oYjjxASr/MTa8u2UXKwc4LujB3Yx5uXcl7BHZuhf/wcHslVvuHdXnpxAaPIb0tfQ63oTPJA3Ts8T2sTqusSWtphMlOla8eO6IjedWcaCGF08DmBgH7nvdb+YYWL3P/Z6MDPQm3+3l+T1hH9SVYpu7/37rcDZqwo8Sgg3Mkq5kJZ8qxr6HoLnmxsZezdiCt9Z+qJl6dnD22dadk+tCr11D3dKoowosHtMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3212.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(366004)(39850400004)(376002)(55236004)(53546011)(186003)(55016002)(9686003)(6506007)(26005)(4001150100001)(33656002)(107886003)(316002)(5660300002)(8676002)(71200400001)(54906003)(110136005)(66446008)(966005)(83380400001)(8936002)(86362001)(478600001)(66556008)(2906002)(64756008)(66946007)(52536014)(66476007)(7696005)(76116006)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: w4vQBgKOeKH1zaIL/xo9xk4eTuCnw749YNpsXDPI4U04/6Zxsd9chTA0rszjsM03QD9ltN8n4wR80W7zUSP9mvFXT7XUJ3aLPBdfhce8z14zOycb7RL6o8xwvJXvillMuz5G5caimrFH1/n4hBOfXXfXQJ549G84ZOo4uLV/pXoZZo1E2rQm2k5evLZKwC1PlgELCW+Nzw8m5rldXCP+0UoGY9WDQFtf7A8oyQorJRk9uBosoDb1vlITuJSiUKrhzLOzu2dorXPGL3Wg+HYNMQOF4L7r2M3dhC6/dEOKoqGs+M7xSnekKVsLRsqyTf4iGc+2vKt2xZmvAupnbzWx6xR+PPV0RHRK10+tYhOcoXxoBBOrHONR2BiXiB5g16xomWjUw28dRuE3VPbsb+T9IqNECwS/MeyOb0t/+RZNZ057jI0B6HevAiP9H/07FshgS8IEdzMdV97fJHFO5aE0nCZpnIQOC4dnTR3d/5F1yNwnFEria3Zm0/ln6QQ4w0uCINUKhjrY7Xk+422LCtmROE4NT9vzs13lvU6PcGI0J4l622DrxeQXYGeBJ/xpSxb6h0uMU+0NepW27ypuJsEBDafpKxgQw83kC0N99NKo0w5ZHgkH0Qgt9w6KMGYhbkwkJYu0U0kzzUBQDGBDZX4FoA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3212.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04add446-4fed-4fb7-7229-08d888cf2b23
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2020 18:57:43.4687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RbGCkr1n1AchWlP4H4yIWi8wdwv4alicj4etmxMU0KsF9IIBYUa3pUe6B4SvYk+lOEFSUx2BveJqT9iascbFRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2442
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FlZWQsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FlZWQg
TWFoYW1lZWQgPHNhZWVkQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgMTMs
IDIwMjAgMToxOCBBTQ0KPiBUbzogTmF2ZWVuIE1hbWluZGxhcGFsbGkgPG5hdmVlbm1AbWFydmVs
bC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+IENjOiBrdWJhQGtlcm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IFN1bmls
IEtvdnZ1cmkgR291dGhhbQ0KPiA8c2dvdXRoYW1AbWFydmVsbC5jb20+OyBMaW51IENoZXJpYW4g
PGxjaGVyaWFuQG1hcnZlbGwuY29tPjsNCj4gR2VldGhhc293amFueWEgQWt1bGEgPGdha3VsYUBt
YXJ2ZWxsLmNvbT47IEplcmluIEphY29iIEtvbGxhbnVra2FyYW4NCj4gPGplcmluakBtYXJ2ZWxs
LmNvbT47IFN1YmJhcmF5YSBTdW5kZWVwIEJoYXR0YSA8c2JoYXR0YUBtYXJ2ZWxsLmNvbT47DQo+
IEhhcmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2MyBuZXQtbmV4dCAwNy8xM10gb2N0ZW9udHgyLWFmOiBBZGQgZGVidWdmcyBlbnRyeQ0K
PiB0byBkdW1wIHRoZSBNQ0FNIHJ1bGVzDQo+IA0KPiBPbiBXZWQsIDIwMjAtMTEtMTEgYXQgMTI6
NDMgKzA1MzAsIE5hdmVlbiBNYW1pbmRsYXBhbGxpIHdyb3RlOg0KPiA+IEZyb206IFN1YmJhcmF5
YSBTdW5kZWVwIDxzYmhhdHRhQG1hcnZlbGwuY29tPg0KPiA+DQo+ID4gQWRkIGRlYnVnZnMgc3Vw
cG9ydCB0byBkdW1wIHRoZSBNQ0FNIHJ1bGVzIGluc3RhbGxlZCB1c2luZw0KPiA+IE5QQ19JTlNU
QUxMX0ZMT1cgbWJveCBtZXNzYWdlLiBEZWJ1Z2ZzIGZpbGUgY2FuIGRpc3BsYXkgbWNhbSBlbnRy
eSwNCj4gPiBjb3VudGVyIGlmIGFueSwgZmxvdyB0eXBlIGFuZCBjb3VudGVyIGhpdHMuDQo+ID4N
Cj4gPiBFdGh0b29sIHdpbGwgZHVtcCB0aGUgbnR1cGxlIGZsb3dzIHJlbGF0ZWQgdG8gdGhlIFBG
IG9ubHkuDQo+ID4gVGhlIGRlYnVnZnMgZmlsZSBnaXZlcyBzeXN0ZW13aWRlIHZpZXcgb2YgdGhl
IE1DQU0gcnVsZXMgaW5zdGFsbGVkIGJ5DQo+ID4gYWxsIHRoZSBQRidzLg0KPiA+DQo+ID4gQmVs
b3cgaXMgdGhlIGV4YW1wbGUgb3V0cHV0IHdoZW4gdGhlIGRlYnVnZnMgZmlsZSBpcyByZWFkOg0K
PiA+IH4gIyBtb3VudCAtdCBkZWJ1Z2ZzIG5vbmUgL3N5cy9rZXJuZWwvZGVidWcgfiAjIGNhdA0K
PiA+IC9zeXMva2VybmVsL2RlYnVnL29jdGVvbnR4Mi9ucGMvbWNhbV9ydWxlcw0KPiA+DQo+ID4g
CUluc3RhbGxlZCBieTogUEYxDQo+ID4gCWRpcmVjdGlvbjogUlgNCj4gPiAgICAgICAgIG1jYW0g
ZW50cnk6IDIyNw0KPiA+IAl1ZHAgc291cmNlIHBvcnQgMjMgbWFzayAweGZmZmYNCj4gPiAJRm9y
d2FyZCB0bzogUEYxIFZGMA0KPiA+ICAgICAgICAgYWN0aW9uOiBEaXJlY3QgdG8gcXVldWUgMA0K
PiA+IAllbmFibGVkOiB5ZXMNCj4gPiAgICAgICAgIGNvdW50ZXI6IDENCj4gPiAgICAgICAgIGhp
dHM6IDANCj4gPg0KPiANCj4gSSBkb24ndCB3YW50IHRvIGJsb2NrIHRoaXMgc2VyaWVzIG9yIGFu
eXRoaW5nLCBidXQgeW91IG1pZ2h0IHdhbnQgdG8gdXNlIGRldmxpbmsNCj4gZHBpcGUgaW50ZXJm
YWNlIGZvciB0aGlzOg0KPiANCj4gaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3Yy
L3VybD91PWh0dHBzLQ0KPiAzQV9fd3d3Lmtlcm5lbC5vcmdfZG9jX2h0bWxfbGF0ZXN0X25ldHdv
cmtpbmdfZGV2bGlua19kZXZsaW5rLQ0KPiAyRGRwaXBlLmh0bWwmZD1Ed0lDYVEmYz1uS2pXZWMy
YjZSMG1PeVBhejd4dGZRJnI9VHdyZXF3VjZtUThLOQ0KPiB3SXBxd0ZPOHlqaWtPX3cxalVPZTJN
ekNoZzRSbWcmbT1RM2JJYVZCQXZDSEdVODE3VGFwOFQ5b29CRlJQDQo+IENKaFA5a3ZGT0R0VW5K
ZyZzPVlWN1EydzBKSHhnOVJVZHdKdk1makMwNjNVbWV2OUhwYjZZdk5TYmUzN0EmZQ0KPiA9DQo+
IA0KPiBBcyBhIGZ1dHVyZSBwYXRjaCBvZiBjb3Vyc2UuDQoNClRoYW5rcyBmb3IgdGhlIHBvaW50
ZXJzLiBXZSB3aWxsIGRlZmluaXRlbHkgbG9vayBpbnRvIGFkZGluZyB0aGUgZGV2bGluayBkcGlw
ZSBzdXBwb3J0IGluIGZ1dHVyZS4NCg0KPiANCj4gVGhhbmtzLA0KPiBTYWVlZC4NCg0K
