Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64582A63EF
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 13:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgKDMLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 07:11:10 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO
        simtcimsva04.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgKDMLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 07:11:09 -0500
Received: from simtcimsva04.etn.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD7908C146;
        Wed,  4 Nov 2020 07:11:08 -0500 (EST)
Received: from simtcimsva04.etn.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7D698C130;
        Wed,  4 Nov 2020 07:11:08 -0500 (EST)
Received: from SIMTCSGWY03.napa.ad.etn.com (simtcsgwy03.napa.ad.etn.com [151.110.126.189])
        by simtcimsva04.etn.com (Postfix) with ESMTPS;
        Wed,  4 Nov 2020 07:11:08 -0500 (EST)
Received: from LOUTCSHUB04.napa.ad.etn.com (151.110.40.77) by
 SIMTCSGWY03.napa.ad.etn.com (151.110.126.189) with Microsoft SMTP Server
 (TLS) id 14.3.468.0; Wed, 4 Nov 2020 07:11:06 -0500
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 LOUTCSHUB04.napa.ad.etn.com (151.110.40.77) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Wed, 4 Nov 2020 07:11:06 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Wed, 4 Nov 2020 07:10:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NevPCUNY4fpxN85c2HLwgf7Ql6BYcodzP1oQKQ0QkM/GYQ1i4giDfmJEBoH+cFSTKR8cimm2GeMwfaDNXykwXO7o9/L4ji5cpyYnFuAzSvXkKubuCji0C+EMkegjAzAwEghBcRDX4ndobWBthAx+DcsPAsCpojieqinNj3Uqmz6hMD07sMTKZIYqsWT4ux810M5Fi+dUWg80BxIa/TIiDYCUprwcFC+i4kiAw/O85kzidhrWBRI7FvZHzJI2YkipdGp4P2DTJZKRIY8HJTkiCKAtDQgq8SB55402BEwHjZja6YiTen7v7KkOFTZ25LoEk6Bwq8oHoytfIxD3XYud5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWX9Aas9d7u6ikdeLIYIZscIdbHYvbgMCCBqGPKzkPw=;
 b=Oq/nsFw8SqLgj8c5pliHlXM4Os+PH+mh1cjSAyEyyla0fjBPyFCQEVXq5L6IL4zde235pt4aKeLMS3qbCYNqC+cw6b+C0p2TtmHs9TNpmgLK+qIFj0ojZA91C6ePVvo0gx3NgTAlbzuGqbHVcF4Lca732c5R6b7TQWYicph8EkT9TK/gPMAUfgByZroZxZ5Un03dEeJDQTXyZVcVIWa3il6sLQa0sUE/SlwUkii5wR3MaZldcsoTbBux+7q+9r0I+UP0ZOWn+pEfz0G1zUpNV+0QOw9qwr444IWrqomI+RKxlFHf8ckyVOv9xqufj7Nn8DPS4/AOoPgXi6fKonzGgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWX9Aas9d7u6ikdeLIYIZscIdbHYvbgMCCBqGPKzkPw=;
 b=w04zyKFps0IpB0Pp7HkTrioMM9ZF+KZoDiSWBmnkmb1Cras8LEQr284LWUltCsMDcciN/76iuToCWxutKQEs5DWTmq1lrQhs64tpNRhGSny4I58pgVZ1tuHqGMEp/hwEBOSFyABW4/UjQrnY1LyVUW5US3QdNN3CCELQwVB8FCI=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR1701MB1720.namprd17.prod.outlook.com
 (2603:10b6:910:68::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Wed, 4 Nov
 2020 12:11:04 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 12:11:04 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [EXTERNAL]  Re: [PATCH net 2/4] net:phy:smsc: expand
 documentation of clocks property
Thread-Topic: [EXTERNAL]  Re: [PATCH net 2/4] net:phy:smsc: expand
 documentation of clocks property
Thread-Index: AdasuMLQwu8gTK1hTbi5zinJMHAWoACOMhkAAOxovQA=
Date:   Wed, 4 Nov 2020 12:11:04 +0000
Message-ID: <CY4PR1701MB18789E4C1FE2C3FBCB1FC010DFEF0@CY4PR1701MB1878.namprd17.prod.outlook.com>
References: <CY4PR1701MB187834A07970380742371D78DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
 <20201030191910.GA4174476@bogus>
In-Reply-To: <20201030191910.GA4174476@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e785e81d-b354-40f2-9518-08d880bab3f2
x-ms-traffictypediagnostic: CY4PR1701MB1720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1701MB1720212EA3EFDF7ABADC5325DFEF0@CY4PR1701MB1720.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jma4srURQ6P8A1wrogwCWrkYfox0a2Eru+wJfSgd5qiJOcvmHgSNi4uGBt3ZHPP7a552jSUQzTnBvou9UOUSPP8TxlUGWhxTzTdGWQqfFVRmTj+oqmDIsfH/i55O4a5JyMwLt7B3k2qVjlyhPrdDuv8kK4a0okMxxu50AskUP9myrZU+xIAI7fIQV0WX4XaIF8DsTHFmt1Gf6vC+8LyD6sDPjvBVvucHo/lbX8S2dsAtx82s9ObhlP1toxXlkOGPLb3mWFdb5O+PLV1W6RlDQ2HA/PqUmMcOrWuhv6yMxU3pT+4sGs6aaLID7xbcpLQo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(4326008)(7696005)(316002)(186003)(53546011)(9686003)(6506007)(26005)(7416002)(64756008)(54906003)(55016002)(71200400001)(8676002)(8936002)(2906002)(66446008)(76116006)(5660300002)(478600001)(86362001)(6916009)(52536014)(33656002)(66556008)(66476007)(66946007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JTGjLkUuLfxN1dVBPlsqFLNeGEfaLO4ZGi1LbIi+UIObF1zjG0EYTt+4ipv0zK01e+BiJJOa9Y4wbf7JdgZWgimOSd3akO82lIgJm4DmqEit0cFRCiViWEhvm8Fax6oRzGQPYjkw0mZa/k3gfI4/Obabtw0kdXavFafscZiv45yjhXKJc1+28LZiVyXLvZ9Cr9o9cqhfYlIUtNsxJwBkngGuQahtY+blwFiHTDS/yB8bwPn6/X+it4DsDH1QboHJhxE3/j7rwkIlz8nHI5cnERlURiTM8ErqirVrSshsWJ4oTx6z4/LzLZjmfZ5puRfADKOZ2Fh1NbbGgOGxGpA4EXwRynfWTmzPCavldfC6wZzfksV6+QH4fXAJFDeusPiJhwFlwu4dec/714rVBdJJTB1DSKOs75TZjoU3hGcWu+2JYJBQ0wCl85sDLjoXdpYOY/Oq0RpUWLVs6ZYpRdcI7H1DPS5pjiHrCbA3Xgd7iPY+Vfw1tJYfHLk0aDT8r9bf0kUWmhZcfl7MSh7zIDE3tZg6GcsvdBkwYT7dWzJ1N+uvFVLJdfl+ZrQ0ITxaXY9OyMmlQu5U6Th95pGt7A2gjeu6oLLGFW/xFomSFeolRazkJl8TyeoKudWViSxJWujqWoCSJ1EbAPgIEOgCuGiNYQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e785e81d-b354-40f2-9518-08d880bab3f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2020 12:11:04.3287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4q0Y0aoHQrp71N665QL7uPl9Iru6s6zCuz7djuprD3hSre2cSa8VMmmsn/NfdUsiG9mj9W2ojcxCEqx0Rtrjtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1701MB1720
X-TM-SNTS-SMTP: B06A614C1EB4E6FBC25FF0930E19A93B42E2C4DE617AB851B2D6D8D74EEE953C2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25766.007
X-TM-AS-Result: No--11.278-10.0-31-10
X-imss-scan-details: No--11.278-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25766.007
X-TMASE-Result: 10--11.277900-10.000000
X-TMASE-MatchedRID: 1sOFX2xm268pwNTiG5IsEldOi7IJyXyIPbO0S2sWaK16pt1oU+C/pGQX
        vEIr196D4UNmbgVDQHpLH1b9n8sQWqG06k9cn1gVUy+QegVlNg14PXLLrqnAoBkUNDFS89yYNKC
        Fv+lwDDIGMzY8ANBqvD31blynzFAF6dw+xRnWB8Lxryc2N+6fmuvWkvu/824/Oz5+urQ2wrfZTA
        EszxrPVE+TZa43NqyPED29yLqmQqMwO9k8xu9MPrBZAi3nrnzblhpPdwv1Z0pYwVHjLI3nenHVg
        igRLmATC7g4IKi3xQOxZmaJUCQqr/24TWyiNqkGuZBZOg7RfX99LQinZ4QefBci5pSoRU8fBTmt
        D+MNlur3FLeZXNZS4DjAdLIal4R6o4iVZIQb0Dw3qRsgcD4Uq5WojZBDkm7s7pUBmik2NzT4+nh
        vKMDw+A==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/PiANCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCkVhdG9uIEluZHVzdHJpZXMg
TWFudWZhY3R1cmluZyBHbWJIIH4gUmVnaXN0ZXJlZCBwbGFjZSBvZiBidXNpbmVzczogUm91dGUg
ZGUgbGEgTG9uZ2VyYWllIDcsIDExMTAsIE1vcmdlcywgU3dpdHplcmxhbmQgDQoNCi0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZy
b206IFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgT2N0b2Jl
ciAzMCwgMjAyMCA4OjE5IFBNDQo+IFRvOiBCYWRlbCwgTGF1cmVudCA8TGF1cmVudEJhZGVsQGVh
dG9uLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGZ1Z2FuZy5kdWFuQG54cC5jb207
IGFuZHJld0BsdW5uLmNoOw0KPiBsZ2lyZHdvb2RAZ21haWwuY29tOyBtLmZlbHNjaEBwZW5ndXRy
b25peC5kZTsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBrdWJhQGtlcm5lbC5vcmc7IGxpbnV4QGFy
bWxpbnV4Lm9yZy51azsgcmljaGFyZC5sZWl0bmVyQHNraWRhdGEuY29tOw0KPiBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyBRdWV0dGUsIEFybmF1ZCA8QXJuYXVkUXVldHRlQEVhdG9uLmNvbT47DQo+
IHAuemFiZWxAcGVuZ3V0cm9uaXguZGU7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBmLmZh
aW5lbGxpQGdtYWlsLmNvbTsNCj4gYnJvb25pZUBrZXJuZWwub3JnOyBIZWluZXIgS2FsbHdlaXQg
PGhrYWxsd2VpdDFAZ21haWwuY29tPg0KPiBTdWJqZWN0OiBbRVhURVJOQUxdIFJlOiBbUEFUQ0gg
bmV0IDIvNF0gbmV0OnBoeTpzbXNjOiBleHBhbmQNCj4gZG9jdW1lbnRhdGlvbiBvZiBjbG9ja3Mg
cHJvcGVydHkNCj4gDQo+IE9uIFR1ZSwgMjcgT2N0IDIwMjAgMjM6Mjc6NDIgKzAwMDAsIEJhZGVs
LCBMYXVyZW50IHdyb3RlOg0KPiA+IO+7v1N1YmplY3Q6IFtQQVRDSCBuZXQgMi80XSBuZXQ6cGh5
OnNtc2M6IGV4cGFuZCBkb2N1bWVudGF0aW9uIG9mIGNsb2Nrcw0KPiA+IHByb3BlcnR5DQo+ID4N
Cj4gPiBEZXNjcmlwdGlvbjogVGhlIHJlZiBjbG9jayBpcyBtYW5hZ2VkIGRpZmZlcmVudGx5IHdo
ZW4gYWRkZWQgdG8gdGhlIERUDQo+ID4gZW50cnkgZm9yIFNNU0MgUEhZLiBUaHVzLCBzcGVjaWZ5
IHRoaXMgbW9yZSBjbGVhcmx5IGluIHRoZSBkb2N1bWVudGF0aW9uLg0KPiA+DQo+ID4gU2lnbmVk
LW9mZi1ieTogTGF1cmVudCBCYWRlbCA8bGF1cmVudGJhZGVsQGVhdG9uLmNvbT4NCj4gPiAtLS0N
Cj4gPiAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9zbXNjLWxhbjg3eHgu
dHh0IHwgMyArKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPiA+DQo+IA0KPiBBY2tlZC1ieTogUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9y
Zz4NCg0KVGhhbmsgeW91IHZlcnkgbXVjaC4NCkknbSBndWVzc2luZyBwZXJoYXBzIEkgc2hvdWxk
IHJlLXNlbmQgdGhpcyBhcyBhIHNpbmdsZSBwYXRjaCBzaW5jZSB0aGVyZSANCmFyZSBpc3N1ZXMg
d2l0aCB0aGUgcGF0Y2ggc2VyaWVzPw0KSSByZWFsaXplIG5vdyB0aGF0IEkgc2hvdWxkIGhhdmUg
c3BsaXR0ZWQgdGhpbmdzIGRpZmZlcmVudGx5Lg0K
