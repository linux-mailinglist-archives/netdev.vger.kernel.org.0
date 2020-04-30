Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FC91BF42C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 11:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgD3J3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 05:29:53 -0400
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO
        simtcimsva02.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgD3J3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 05:29:53 -0400
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA08011A124;
        Thu, 30 Apr 2020 05:29:51 -0400 (EDT)
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C333311A123;
        Thu, 30 Apr 2020 05:29:51 -0400 (EDT)
Received: from LOUTCSGWY04.napa.ad.etn.com (loutcsgwy04.napa.ad.etn.com [151.110.126.21])
        by simtcimsva02.etn.com (Postfix) with ESMTPS;
        Thu, 30 Apr 2020 05:29:51 -0400 (EDT)
Received: from SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) by
 LOUTCSGWY04.napa.ad.etn.com (151.110.126.21) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Thu, 30 Apr 2020 05:29:50 -0400
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Thu, 30 Apr 2020 05:29:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Thu, 30 Apr 2020 05:29:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gl7I3s6FC8StFFfdQHszLEbMg9eQ+M2qlHXEqpC+igxGGMiVSXT13A7jcGIqMLZgnV9C4Cfs+6EqlTvbP+i1bNJ1Sv4ahD0qlJwGuFdFg94vt/ZTh7qmFMkSJm8v6HyNhbagZi9D1PsMTCEOE1X5S31PCkOlQiC+OkIODiZBhMQDp+P2+by7JXGPBKmxUdalNjidCl62Wpvx7W/A7FmwQQ/N9d5hRA5XoqgnDEjxas7uQ2mu/eEO1jz+LwyBxZY6RNe1IpCfGYOlNv6S1ZP1ct8iHj+kAbsbytXLM31NOI7AP1ZYoQDFHmTKn77awXPnu01nLueXyKEvhIagpPchIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9h3uKPacJ1iYvGN24wUJFl2JRT/kOz6cDc7+ZhhprDs=;
 b=MgJGpqQ4fOcedOatVb97FZwBwUp8fzV6WQWFNw/Kd1AwfB1E5P3MsRk3GnrWaTJkguXiBV1I1zEsRxlQUcan9PA8LlK4LflxA0xSKmsknh5hEtlyd3efbPE6lO3wf8leZ6cskknIcHeEx/FoVHSgzDpNIJxZ2ggzC9o9hXVP7rmKuZ7tXzlBipcXMh9COhZwBz1eaKfjywcyzaCABNj3TrQhiYO+BH8FB/1necAOTKq1butIyT4h5EGVHE+VWoIflHoZ/4QACNDMtvAfGhrZEeelc179u0dYDtdhAPF7LuzJkjotaNNH7DkHencqiuzXUDgCa22SmNO6Ic4y6OhP4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9h3uKPacJ1iYvGN24wUJFl2JRT/kOz6cDc7+ZhhprDs=;
 b=aMvdxGJYK8oC/eZSrPdQgiL1OzlD2ioC54GfaNJf0ehShf80k1Yhrjj+ZZLs23VblCMAFSAJ807pwzsu7BelgzhB/XoFe9JvftVTHyoIM37L7RuIHq0iH0h4riPPcgYrElPCu6TncnGW7mItI5jOz1uwfyCHly4N9TD5l1sI3Jo=
Received: from CH2PR17MB3542.namprd17.prod.outlook.com (2603:10b6:610:40::24)
 by CH2PR17MB3400.namprd17.prod.outlook.com (2603:10b6:610:41::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 09:29:49 +0000
Received: from CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c]) by CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c%5]) with mapi id 15.20.2937.023; Thu, 30 Apr 2020
 09:29:49 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: RE: [EXTERNAL]  Re: [PATCH 2/2] Reset PHY in phy_init_hw() before
 interrupt configuration
Thread-Topic: [EXTERNAL]  Re: [PATCH 2/2] Reset PHY in phy_init_hw() before
 interrupt configuration
Thread-Index: AdYeBMj3Elf0T3++RJuJe8w7Jf842wAQ7JiAACGbPLA=
Date:   Thu, 30 Apr 2020 09:29:48 +0000
Message-ID: <CH2PR17MB35427EF2FAE4E31FCA144F89DFAA0@CH2PR17MB3542.namprd17.prod.outlook.com>
References: <CH2PR17MB3542BB17A1FA1764ACE3B20EDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
 <338bd206-673d-6f3e-0402-822707af5075@gmail.com>
In-Reply-To: <338bd206-673d-6f3e-0402-822707af5075@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [178.39.126.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d136260-f2e5-453a-b02b-08d7ece90749
x-ms-traffictypediagnostic: CH2PR17MB3400:
x-ld-processed: d6525c95-b906-431a-b926-e9b51ba43cc4,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR17MB3400E61A0D8285466612E6BFDFAA0@CH2PR17MB3400.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0389EDA07F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3542.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(366004)(376002)(346002)(136003)(5660300002)(478600001)(186003)(6506007)(52536014)(64756008)(66476007)(71200400001)(66446008)(53546011)(26005)(2906002)(33656002)(4326008)(66946007)(76116006)(107886003)(86362001)(7416002)(66556008)(9686003)(110136005)(316002)(45080400002)(55016002)(8936002)(7696005)(8676002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gw2/DM6fPxfK/jF16hq9UaiRwRKEExVShvBUOyG6cDruePksuA3J04Mc5kAish+B9yVLqT3NMg4uUAgHZJt6ARH8avmfNG2NQMX62d6EKXUvvtcAWki8PplsG7Eq1bcrav6a8QCBvsQhz/uQN7C0HgpYDDUT1sFMP86kYQkVe/xDrB3XXiU3YoxvEvqvo45vN4JNjkg/8wseQUgxG8CoB43Skl5ttEEq7E8DXsB98MqFy3JORaflDy3hPKRH7/BlzT7fOoCEI0JDgBs2DbEKmaKTmeyjfkg7EifeLdIK+CNuQa9aVjHXvBVQ+WQOQebwfmYjnnQOYNmsHWaPIYAjPF29vdZy6mLbAOzYT2PObRTV2j17kGh48Guux9bqV4qwuYqA+SZVtCQDL8BEfuHeiNGzEffnxo3xOo6Dd4TkvoTid9Mh5o27eyJ2RFK8bo3ZuAI4ibGSRSHMyljLM3kxj9+3zrPmUzAK5mrh/1wgBkU=
x-ms-exchange-antispam-messagedata: BJsjNxVxy3Dk8fKOY9dXvbGIK5XuJq30JJMgB9oC6SjVelIpoiZfHOjQ9WHY3D3jv3BVQKAVRg9XjUEKDIHGcAmribx4ZEmxEwMhUxws6AFkVhvJMTdQYZ2iuiy3uD5DB3VQywnqa2Cq6uzLvSPLuixTMsC9nerbPDG5dXAiqLO89lZT/gKbZh/bojeN56KaCvB4EC7KoR8d6Zjaqvqi1K35pj5jFdbshwgMVPtHppaF5bF2qAgxaSzQ9+o5prdbMf+XmVPoBloYHeeWkoImtuKN7VEhyd1Aq+13iwAszRfc61n6Ej6u0JKJPx64b4cvdBvZa10cMtYkM8koe48Yqi6pAHSp2jV10eJ2nMPgr4ONAllC1UR8shkD686XWOl9XIAzqV2ZYjSx66Tt5I8+u3V3b9+PEUSTM0/tfIet2+LeEgOKE88SCoyv2RC4H5yIy3jQyxANiBFLeGrd97GcPhg2Vwwb5NFIq79Emg2ATuQ314PCJVv3fJI2RWHExiRP7Fs79QY9Ldr8LH0xvQBAiwz6z4LX1V+8GsHVqc93rjAM3J9ZtCxbiLDxOUoJN7f2rsEDZ99QeklcW31Hq/nEQznXmcxUc5YSCTm7NHaJIHw/VWsSBrOzQETHN+kSLQNO+EA0u9rTwZ5J1Ia956s1Rgt1aGSWXXR5D0esEJXRS/57w4MwCEukvJc79nDwVHv/ylFcFOKqLsUFrRH0mNqTeuon1ec5E9O8tfSkmUPLepEo/AHqD+H/qMXly5XB16NF3sY0HRI3LiiuBaK5UWb7qqCa19rXKbpOzjJqA0JyNz0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d136260-f2e5-453a-b02b-08d7ece90749
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 09:29:48.7960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oc7k3xNf/jlaqJxH4sY6MXU9YB+5ycA4F/BPgvn+hSCXn/cBr9jQo+iJfs/qG1u7pcOuvk6pSisDPLoAbb+I8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR17MB3400
X-TM-SNTS-SMTP: 6824DEECD39A82733E76540EBAB14E1D3F265D01C2BC1FE8DA0B4D724F6339762002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.5.0.1020-25386.005
X-TM-AS-Result: No--24.952-10.0-31-10
X-imss-scan-details: No--24.952-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.5.1020-25386.005
X-TMASE-Result: 10--24.952200-10.000000
X-TMASE-MatchedRID: bNhqr+E3/0QOMO1eHmEbOe5i6weAmSDKgD4VuLZ6ds6RKZNYkM4jwSR5
        ZmzhjWxoW3VwvqEIvJwdXvAkWdRIlVtFsD8r+sfMawF+mgcxqmVxn2A2p1z9q2ww+4tkH8hHXnm
        uBT+Y9/KEvnVVxCyMs5CoQkBz+MIb+gtEW3D/QKb2b09s2KGDsH4yToAKzDgmDfheddyhsquGDD
        N697LknmE/JYYgDQUELlrmgqpHKx+SsyjfsjrH/odlc1JaOB1T6qG5M9QNAO1XsxBNtOXTbyJvu
        JJKeAuO+j6f9Ip7+XWqvQrjP8O+uoEBch0HhZyDimHWEC28pk1LXPA26IG0hN9RlPzeVuQQ/xB+
        Lj2Wbxw5rUR+kpEcRq05fsutTNYPyyXMsAFO1NFQ+S0N05fR+10DithooYrC4ojrT4W6jjrArHM
        rf12AngLReOoVes+5yqEGZ1E2SMafbxa3A1yTp0I4eS9mV4/sF9s8UTYYetVcs16igcVqtT/luj
        CAgXrGi9IrBhL1Q3x4jGs9WKQwx152p//UKpcL3QqJN4m15UF9LQinZ4QefBci5pSoRU8fBTmtD
        +MNlur3FLeZXNZS4LU+KYi1qWO6ftwZ3X11IV0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/PiANCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCkVhdG9uIEluZHVzdHJpZXMg
TWFudWZhY3R1cmluZyBHbWJIIH4gUmVnaXN0ZXJlZCBwbGFjZSBvZiBidXNpbmVzczogUm91dGUg
ZGUgbGEgTG9uZ2VyYWllIDcsIDExMTAsIE1vcmdlcywgU3dpdHplcmxhbmQgDQoNCi0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZy
b206IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgQXByaWwgMjksIDIwMjAgNzowNiBQTQ0KPiBUbzogQmFkZWwsIExhdXJlbnQgPExhdXJl
bnRCYWRlbEBlYXRvbi5jb20+OyBmdWdhbmcuZHVhbkBueHAuY29tOw0KPiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBhbmRyZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+IGxpbnV4
QGFybWxpbnV4Lm9yZy51azsgcmljaGFyZC5sZWl0bmVyQHNraWRhdGEuY29tOw0KPiBkYXZlbUBk
YXZlbWxvZnQubmV0OyBhbGV4YW5kZXIubGV2aW5AbWljcm9zb2Z0LmNvbTsNCj4gZ3JlZ2toQGxp
bnV4Zm91bmRhdGlvbi5vcmcNCj4gQ2M6IFF1ZXR0ZSwgQXJuYXVkIDxBcm5hdWRRdWV0dGVARWF0
b24uY29tPg0KPiBTdWJqZWN0OiBbRVhURVJOQUxdIFJlOiBbUEFUQ0ggMi8yXSBSZXNldCBQSFkg
aW4gcGh5X2luaXRfaHcoKSBiZWZvcmUNCj4gaW50ZXJydXB0IGNvbmZpZ3VyYXRpb24NCj4gDQo+
IE9uIDI5LjA0LjIwMjAgMTE6MDMsIEJhZGVsLCBMYXVyZW50IHdyb3RlOg0KPiA+IO+7v0Rlc2Ny
aXB0aW9uOiB0aGlzIHBhdGNoIGFkZHMgYSByZXNldCBvZiB0aGUgUEhZIGluIHBoeV9pbml0X2h3
KCkNCj4gPiBmb3IgUEhZIGRyaXZlcnMgYmVhcmluZyB0aGUgUEhZX1JTVF9BRlRFUl9DTEtfRU4g
ZmxhZy4NCj4gPg0KPiA+IFJhdGlvbmFsZTogZHVlIHRvIHRoZSBQSFkgcmVzZXQgcmV2ZXJ0aW5n
IHRoZSBpbnRlcnJ1cHQgbWFzayB0byBkZWZhdWx0LA0KPiA+IGl0IGlzIG5lY2Vzc2FyeSB0byBl
aXRoZXIgcGVyZm9ybSB0aGUgcmVzZXQgYmVmb3JlIFBIWSBjb25maWd1cmF0aW9uLA0KPiA+IG9y
IHJlLWNvbmZpZ3VyZSB0aGUgUEhZIGFmdGVyIHJlc2V0LiBUaGlzIHBhdGNoIGltcGxlbWVudHMg
dGhlIGZvcm1lcg0KPiA+IGFzIGl0IGlzIHNpbXBsZXIgYW5kIG1vcmUgZ2VuZXJpYy4NCj4gPg0K
PiA+IEZpeGVzOiAxYjBhODNhYzA0ZTM4M2UzYmVkMjEzMzI5NjJiOTA3MTBmY2YyODI4ICgibmV0
OiBmZWM6IGFkZA0KPiBwaHlfcmVzZXRfYWZ0ZXJfY2xrX2VuYWJsZSgpIHN1cHBvcnQiKQ0KPiA+
IFNpZ25lZC1vZmYtYnk6IExhdXJlbnQgQmFkZWwgPGxhdXJlbnRiYWRlbEBlYXRvbi5jb20+DQo+
ID4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZpY2UuYyB8IDcgKysrKyst
LQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMgYi9kcml2
ZXJzL25ldC9waHkvcGh5X2RldmljZS5jDQo+ID4gaW5kZXggMjhlM2M1YzBlLi4yY2M1MTEzNjQg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZpY2UuYw0KPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gPiBAQCAtMTA4Miw4ICsxMDgyLDExIEBA
IGludCBwaHlfaW5pdF9odyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+ICB7DQo+ID4g
IAlpbnQgcmV0ID0gMDsNCj4gPg0KPiA+IC0JLyogRGVhc3NlcnQgdGhlIHJlc2V0IHNpZ25hbCAq
Lw0KPiA+IC0JcGh5X2RldmljZV9yZXNldChwaHlkZXYsIDApOw0KPiA+ICsJLyogRGVhc3NlcnQg
dGhlIHJlc2V0IHNpZ25hbA0KPiA+ICsJICogSWYgdGhlIFBIWSBuZWVkcyBhIHJlc2V0LCBkbyBp
dCBub3cNCj4gPiArCSAqLw0KPiA+ICsJaWYgKCFwaHlfcmVzZXRfYWZ0ZXJfY2xrX2VuYWJsZShw
aHlkZXYpKQ0KPiANCj4gSWYgcmVzZXQgaXMgYXNzZXJ0ZWQgd2hlbiBlbnRlcmluZyBwaHlfaW5p
dF9odygpLCB0aGVuDQo+IHBoeV9yZXNldF9hZnRlcl9jbGtfZW5hYmxlKCkgYmFzaWNhbGx5IGJl
Y29tZXMgYSBuby1vcC4NCj4gU3RpbGwgaXQgc2hvdWxkIHdvcmsgYXMgZXhwZWN0ZWQgZHVlIHRv
IHRoZSByZXNldCBzaWduYWwgYmVpbmcNCj4gZGVhc3NlcnRlZC4gSXQgd291bGQgYmUgd29ydGgg
ZGVzY3JpYmluZyBpbiB0aGUgY29tbWVudA0KPiB3aHkgdGhlIGNvZGUgc3RpbGwgd29ya3MgaW4g
dGhpcyBjYXNlLg0KPiANCg0KVGhhbmsgeW91IGZvciB0aGUgY29tbWVudCwgdGhpcyBpcyBhIHZl
cnkgZ29vZCBwb2ludC4gDQpJIHdpbGwgbWFrZSBzdXJlIHRvIGluY2x1ZGUgc29tZSBkZXNjcmlw
dGlvbiB3aGVuIHJlc3VibWl0dGluZy4gDQpJIGhhZCBwcmV2aW91c2x5IHRlc3RlZCB0aGlzIGFu
ZCB3aGF0IEkgc2F3IHdhcyB0aGF0IHRoZSBmaXJzdCANCnRpbWUgeW91IGJyaW5nIHVwIHRoZSBp
bnRlcmZhY2UsIHRoZSByZXNldCBpcyBub3QgYXNzZXJ0ZWQgc28gDQp0aGF0IHBoeV9yZXNldF9h
ZnRlcl9jbGtfZW5hYmxlKCkgaXMgZWZmZWN0aXZlLiANClRoZSBzdWJzZXF1ZW50IHRpbWVzIHRo
ZSBpbnRlcmZhY2UgaXMgYnJvdWdodCB1cCwgdGhlIHJlc2V0IA0KaXMgYWxyZWFkeSBhc3NlcnRl
ZCB3aGVuIGVudGVyaW5nIHBoeV9pbml0X2h3KCksIHNvIHRoYXQgDQppdCBiZWNvbWVzIGEgbm8t
b3AgYXMgeW91IGNvcnJlY3RseSBwb2ludGVkIG91dC4gSG93ZXZlciwgDQp0aGF0IGRpZG4ndCBj
YXVzZSBhbnkgcHJvYmxlbSBvbiBteSBib2FyZCwgcHJlc3VtYWJseSBiZWNhdXNlIA0KaW4gdGhh
dCBjYXNlIHRoZSBjbG9jayBpcyBhbHJlYWR5IHJ1bm5pbmcgd2hlbiB0aGUgUEhZIGNvbWVzIA0K
b3V0IG9mIHJlc2V0LiANCkkgd2lsbCByZS10ZXN0IHRoaXMgY2FyZWZ1bGx5IGFnYWluc3QgdGhl
ICduZXQnIHRyZWUsIHRob3VnaCwNCmJlZm9yZSBjb21pbmcgdG8gY29uY2x1c2lvbnMuICANCg0K
PiA+ICsJCXBoeV9kZXZpY2VfcmVzZXQocGh5ZGV2LCAwKTsNCj4gPg0KPiA+ICAJaWYgKCFwaHlk
ZXYtPmRydikNCj4gPiAgCQlyZXR1cm4gMDsNCj4gPg0KDQo=
