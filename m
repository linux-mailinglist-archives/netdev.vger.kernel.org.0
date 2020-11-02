Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CFA2A2E42
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgKBPYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:24:10 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO
        simtcimsva04.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgKBPYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:24:07 -0500
Received: from simtcimsva04.etn.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C75858C0CC;
        Mon,  2 Nov 2020 10:24:05 -0500 (EST)
Received: from simtcimsva04.etn.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B96428C151;
        Mon,  2 Nov 2020 10:24:05 -0500 (EST)
Received: from SIMTCSGWY02.napa.ad.etn.com (simtcsgwy02.napa.ad.etn.com [151.110.126.185])
        by simtcimsva04.etn.com (Postfix) with ESMTPS;
        Mon,  2 Nov 2020 10:24:05 -0500 (EST)
Received: from LOUTCSHUB01.napa.ad.etn.com (151.110.40.74) by
 SIMTCSGWY02.napa.ad.etn.com (151.110.126.185) with Microsoft SMTP Server
 (TLS) id 14.3.468.0; Mon, 2 Nov 2020 10:24:02 -0500
Received: from USLTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.151) by
 LOUTCSHUB01.napa.ad.etn.com (151.110.40.74) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Mon, 2 Nov 2020 10:24:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by hybridmail.eaton.com (151.110.240.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 2 Nov 2020 10:23:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro3BUMA2DoRWke65a/Raa70oio02PsXuWzP2SX0X/YT2Dv6MCBcT00mebaH6e/z2q4GlKw4N7779GQagUOFaiePMntM32BJSw23AvbtHByfNXdqTHSNxXkCbO5NjDWtfpkJO1MeMDu3cDW5SINTFhrFJr/nRbFj67C4s+1VuILfb4KXIRKxjqXkgf2nWYMzZt4o/87tpd87HTIUE4eo2xryVppeSosCHYdWUDWFDH4dU2MTPueIE/Ee+cWT0lkq0kHGex4C5Fw23QmNFzt2igcCDOziw6CSG3pGyzc+v0L1ZH41/QICfpSrdmyQBMZLPQFkq6JrMTAHUuHCPshEAgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Br1figEeGgVMy4YT5daEbWlUPW0UKL4lwtwSRppUDrU=;
 b=V++uu3Bnay3AbzYNazzxGBP0kwYvJHGxlDJZLi4JoTW2jHvWXG+WPD3UcwO8SQnPLiSvDR+6if+geJAX2Yftk3Ooc/I0jeNwDXQwT/w67ZVY+rdHWvVWrkGmdN11Qv59v8FQj2eHiM85UOhHlMdi4TfVSPBzq3Xv5hocjY/74P9Wzt1zkwp2DUEklpymN0xhZvaH1+QHqrMwpsOzCKhrHY5IeOI3XV2oB3yp9nYtmJfbkuNY4R2sWXAJN7C1I5rJtImYJh67KIqhx++1HwT3roIOeF+3zSS099h34g+qr+yOYBu1fqxGdt5JcRn3o2bzzL9XoYCf3RLL7W7aroh5kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Br1figEeGgVMy4YT5daEbWlUPW0UKL4lwtwSRppUDrU=;
 b=oCXSV88rnAVICalazFJFKjxKp6M6z9bODRq2rEia+8Xbu0jh3kvWY3XFjo9r7YbE88U1ynrl5xoGB6X88nki9uRmUqFVfiZVARYyprMgk602doesJ5uee4GZVretbqZS+gip7w2izzuSJpSqqL7Vu67uqeMNT+aAaWOBcRkypEs=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR1701MB1765.namprd17.prod.outlook.com
 (2603:10b6:910:62::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Mon, 2 Nov
 2020 15:24:01 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 15:24:00 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: RE: [EXTERNAL]  Re: [PATCH net 0/4] Restore and fix PHY reset for
 SMSC LAN8720
Thread-Topic: [EXTERNAL]  Re: [PATCH net 0/4] Restore and fix PHY reset for
 SMSC LAN8720
Thread-Index: AdasuCyaTCUfPNScQDqUis8Tkf1v8AAx0yYAAOr5y0A=
Date:   Mon, 2 Nov 2020 15:24:00 +0000
Message-ID: <CY4PR1701MB187877D03FC80867FED80DA1DF100@CY4PR1701MB1878.namprd17.prod.outlook.com>
References: <CY4PR1701MB1878B85B9E1C5B4FDCBA2860DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
 <20201028161006.2dcd2a62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201028161006.2dcd2a62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19f2060f-fca8-4de0-ad2b-08d87f435340
x-ms-traffictypediagnostic: CY4PR1701MB1765:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1701MB1765B0679570AE3769AB9892DF100@CY4PR1701MB1765.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NVpwNRdh+i8sPIKf/PQ7MLJvFg4RBjpmIpo8Er48gzN7Fq1wdATUCE0+AIHBYP67I45PpmoftW0tY0DyL3zLNsbVR+b02itYuOUv0KHiC1G29oRvwMEpruvY/hdoC2xbK4kNJ4hf1VRXv9o8dwRkf+PuTFbtxyRBTFTlbcDT71XyuAueWUxzVc+AB0m1moRQge2/QKu0suehS6+dXwG51+EgqaveZL/Nwf/NaeZbHg2g9m3BgI/r5n+wBfAFIaL2WBoVnwV2Cm14i6i0q01X/s/581IBKOjBNL8OpAopG9GyR+6IpwEF6LnjPHTdypFi6Ro8q/nMe6S7k1wO/H7WBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(376002)(366004)(346002)(9686003)(7696005)(53546011)(6506007)(316002)(71200400001)(55016002)(83380400001)(107886003)(8676002)(86362001)(66446008)(7416002)(33656002)(186003)(4326008)(64756008)(66556008)(66946007)(66476007)(76116006)(5660300002)(54906003)(52536014)(478600001)(2906002)(6916009)(8936002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Jwo1HaRola0DJUY6pyHf577QVwvb2SK9SDmfH5BbvFwnIno8gZqJGKA++MULqnLWKocFcaUtU3FCI7b+PoBs/vcDPfXrnXwuDq5+urgi2i/6WuZXHh5FI24Zars7YcaAoh/HA3Z56bhxUr8O6c9yB21f0wRa8UJIW8nFBEh4wn6A1MDliGXytQcc8LIe+q0gEbUEoTfZdn+buL1cP9ndTse74ycUqFbzeXfGv5Iwqe0tCoisiWbPurMz/npdODr87fYSlOYp/cttEkpN04swQEuG1OJinCMzpRYcgO3lvhbhKa6GENJRLN3lpqoON0o3NzWZRiloYmEbEiQ/UokYW4PG2twRpu48i7B0d3oIVHvSRaB+GWM2vX+OYJZ7VrVoOZEVlnJ73R+lrJmGwNyB6sd6voDd4FdK6Q3AttxfE7XVhFgdtGf4lZUIgM3+C6c60dYAUPDYwlfIDvJKbgSs8wJJB70oonR1CdlJDvXrjuAunKQ0sLtf4kEZtiBZp8f05O2byJMNZjvDXe/XrRAEgVhxbimlOWETv4d0CqQ1Ik1PGiF9WnYfSnyHFA3xUGnKFQTKzOlFKrNXyJFUY7PLuwFaDZrHnq3nbzqzTkQkQ327s5MC2XVIkz4rrg22szGLsPdpRal71u7blCgG0ej94g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f2060f-fca8-4de0-ad2b-08d87f435340
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 15:24:00.8009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BChFV9+zoC1HXN13L9RCGccaIrlxpOrDdklLpRUOXkvaq4xkgkXM2dCddVcmO8tpUERQz3P5scyW9D/iQAXhpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1701MB1765
X-TM-SNTS-SMTP: B591E678A73A7B2991F3922FEB0F9A18F046EBD492D1AADB029BE97B188B55CD2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25762.007
X-TM-AS-Result: No--10.888-10.0-31-10
X-imss-scan-details: No--10.888-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25762.007
X-TMASE-Result: 10--10.888400-10.000000
X-TMASE-MatchedRID: f30tepkob9QpwNTiG5IsEldOi7IJyXyIypNii+mQKrGqvcIF1TcLYAjJ
        M0WLRMJtsrWE1NucEUAIcXFx1Lo8nMWMYfEdC2+2gmAd4Attpn8ZskwWqoib3Pn6214PlHOFCh5
        FGEJlYgHVSCY5YEd37pFpYMWkoc7MXKlUkWaHqwuaVoAi2I40/UPIlAqA4/DEFBQ5IKls/A6wWb
        M0s9anoi8uARuzvdVnZA2hMjGumYK4WGh1vUSL/4ph1hAtvKZNlt9cdu1PUGIjRiu1AuxJTAv44
        WfHty9MaQIZb0gBD+MfSsit/7Lqlt21fz/XtgY18Kg68su2wyHR04kfXaJqdTb9TB28UbkiYCZc
        zKpcPCB+H7FNjKOX3Q4AjNBG0nAtmRkGItO9kH6PR2u912hYRLx2voUbwFB93UNnF6Ww6gUPZUw
        DeFsZ8fA0pmT+JtrCRVl7l/D4WKhH4UfwjA8KgbqImyaR0axZD+jls0cSwJMcNByoSo036eKgAb
        FDLh41QGR+7XiGldQ6M8mizD2V5/q/dTnp8ZOTJDuWzfvz/MdrLj3DxYBIN2KWkc3vEp/1vQS/j
        zORDUE1CeLoij8u/jaa3EyGqiXDTbSzAHe1tP7L2R+KxhVLqARryDXHx6oXLO3j+XDwlkPy4Qdk
        npMqonT/Lrym5VGNhhGxcG31+H/HX826gUMzFFftSkmEYHZifYrr1p9yfCqBTfzBFuc88roTxgo
        DFSNYbjPM9DqzhiCRk6XtYogianyef22ep6XY4kYXbobxJbKl/MtrTwS4UKjM0q2NX+jw0pMI5e
        h2IYn2SahVPUtYsbqZVWN4Gi1ZGOrC+y0LW9s=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/DQoNCj4gDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpFYXRvbiBJbmR1c3Ry
aWVzIE1hbnVmYWN0dXJpbmcgR21iSCB+IFJlZ2lzdGVyZWQgcGxhY2Ugb2YgYnVzaW5lc3M6IFJv
dXRlIGRlIGxhIExvbmdlcmFpZSA3LCAxMTEwLCBNb3JnZXMsIFN3aXR6ZXJsYW5kIA0KDQotLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiBGcm9tOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTZW50OiBUaHVyc2Rh
eSwgT2N0b2JlciAyOSwgMjAyMCAxMjoxMCBBTQ0KPiBUbzogQmFkZWwsIExhdXJlbnQgPExhdXJl
bnRCYWRlbEBlYXRvbi5jb20+DQo8c25pcD4NCj4gU3ViamVjdDogW0VYVEVSTkFMXSBSZTogW1BB
VENIIG5ldCAwLzRdIFJlc3RvcmUgYW5kIGZpeCBQSFkgcmVzZXQgZm9yIFNNU0MNCj4gTEFOODcy
MA0KPiANCj4gT24gVHVlLCAyNyBPY3QgMjAyMCAyMzoyNTowMSArMDAwMCBCYWRlbCwgTGF1cmVu
dCB3cm90ZToNCj4gPiDvu79TdWJqZWN0OiBbUEFUQ0ggbmV0IDAvNF0gUmVzdG9yZSBhbmQgZml4
IFBIWSByZXNldCBmb3IgU01TQyBMQU44NzIwDQo+ID4NCj4gPiBEZXNjcmlwdGlvbjoNCj4gPiBB
IHJlY2VudCBwYXRjaHNldCBbMV0gYWRkZWQgc3VwcG9ydCBpbiB0aGUgU01TQyBQSFkgZHJpdmVy
IGZvcg0KPiA+IG1hbmFnaW5nIHRoZSByZWYgY2xvY2sgYW5kIHRoZXJlZm9yZSByZW1vdmVkIHRo
ZQ0KPiBQSFlfUlNUX0FGVEVSX0NMS19FTg0KPiA+IGZsYWcgZm9yIHRoZQ0KPiA+IExBTjg3MjAg
Y2hpcC4gVGhlIHJlZiBjbG9jayBpcyBwYXNzZWQgdG8gdGhlIFNNU0MgZHJpdmVyIHRocm91Z2gg
YSBuZXcNCj4gPiBwcm9wZXJ0eSAiY2xvY2tzIiBpbiB0aGUgZGV2aWNlIHRyZWUuDQo+ID4NCj4g
PiBUaGVyZSBhcHBlYXJzIHRvIGJlIHR3byBwb3RlbnRpYWwgY2F2ZWF0czoNCj4gPiAoaSkgQnVp
bGRpbmcga2VybmVsIDUuOSB3aXRob3V0IHVwZGF0aW5nIHRoZSBEVCB3aXRoIHRoZSAiY2xvY2tz
Ig0KPiA+IHByb3BlcnR5IGZvciBTTVNDIFBIWSwgd291bGQgYnJlYWsgc3lzdGVtcyBwcmV2aW91
c2x5IHJlbHlpbmcgb24gdGhlDQo+ID4gUEhZIHJlc2V0IHdvcmthcm91bmQgKFNNU0MgZHJpdmVy
IGNhbm5vdCBncmFiIHRoZSByZWYgY2xvY2ssIHNvIGl0IGlzDQo+ID4gc3RpbGwgbWFuYWdlZCBi
eSBGRUMsIGJ1dCB0aGUgUEhZIGlzIG5vdCByZXNldCBiZWNhdXNlDQo+ID4gUEhZX1JTVF9BRlRF
Ul9DTEtfRU4gaXMgbm90IHNldCkuIFRoaXMgbWF5IGxlYWQgdG8gb2NjYXNpb25hbCBsb3NzIG9m
DQo+ID4gZXRoZXJuZXQgY29ubmVjdGl2aXR5IGluIHRoZXNlIHN5c3RlbXMsIHRoYXQgaXMgZGlm
ZmljdWx0IHRvIGRlYnVnLg0KPiA+DQo+ID4gKGlpKSBUaGlzIGRlZmVhdHMgdGhlIHB1cnBvc2Ug
b2YgYSBwcmV2aW91cyBjb21taXQgWzJdIHRoYXQgZGlzYWJsZWQNCj4gPiB0aGUgcmVmIGNsb2Nr
IGZvciBwb3dlciBzYXZpbmcgcmVhc29ucy4gSWYgYSByZWYgY2xvY2sgZm9yIHRoZSBQSFkgaXMN
Cj4gPiBzcGVjaWZpZWQgaW4gRFQsIHRoZSBTTVNDIGRyaXZlciB3aWxsIGtlZXAgaXQgYWx3YXlz
IG9uIChjb25maXJtZWQNCj4gPiB3aXRoIHNjb3BlKS4gV2hpbGUgdGhpcyByZW1vdmVzIHRoZSBu
ZWVkIGZvciBhZGRpdGlvbmFsIFBIWSByZXNldHMNCj4gPiAob25seSBhIHNpbmdsZSByZXNldCBp
cyBuZWVkZWQgYWZ0ZXIgcG93ZXIgdXApLCB0aGlzIHByZXZlbnRzIHRoZSBGRUMNCj4gPiBmcm9t
IHNhdmluZyBwb3dlciBieSBkaXNhYmxpbmcgdGhlIHJlZmNsay4gU2luY2UgdGhlcmUgbWF5IGJl
IHVzZQ0KPiA+IGNhc2VzIHdoZXJlIG9uZSBpcyBpbnRlcmVzdGVkIGluIHNhdmluZyBwb3dlciwg
a2VlcCB0aGlzIG9wdGlvbg0KPiA+IGF2YWlsYWJsZSB3aGVuIG5vIHJlZiBjbG9jayBpcyBzcGVj
aWZpZWQgZm9yIHRoZSBQSFksIGJ5IGZpeGluZyBpc3N1ZXMgd2l0aA0KPiB0aGUgUEhZIHJlc2V0
Lg0KPiA+DQo+ID4gTWFpbiBjaGFuZ2VzIHByb3Bvc2VkIHRvIGFkZHJlc3MgdGhpczoNCj4gPiAo
YSkgUmVzdG9yZSBQSFlfUlNUX0FGVEVSX0NMS19FTiBmb3IgTEFOODcyMCwgYnV0IGV4cGxpY2l0
bHkgY2xlYXIgaXQNCj4gPiBpZiB0aGUgU01TQyBkcml2ZXIgc3VjY2VlZHMgaW4gcmV0cmlldmlu
ZyB0aGUgcmVmIGNsb2NrLg0KPiA+IChiKSBGaXggcGh5X3Jlc2V0X2FmdGVyX2Nsa19lbmFibGUo
KSB0byB3b3JrIGluIGludGVycnVwdCBtb2RlLCBieQ0KPiA+IHJlLWNvbmZpZ3VyaW5nIHRoZSBQ
SFkgcmVnaXN0ZXJzIGFmdGVyIHJlc2V0Lg0KPiA+DQo+ID4gVGVzdHM6IGFnYWluc3QgbmV0IHRy
ZWUgNS45LCBpbmNsdWRpbmcgYWxseWVzL25vL21vZGNvbmZpZy4gMTAgcGllY2VzDQo+ID4gb2Yg
YW4gaU1YMjgtRVZLLWJhc2VkIGJvYXJkIHdlcmUgdGVzdGVkLCAzIG9mIHdoaWNoIHdlcmUgZm91
bmQgdG8NCj4gPiBleGhpYml0IGlzc3VlcyB3aGVuIHRoZSAiY2xvY2tzIiBwcm9wZXJ0eSB3YXMg
bGVmdCB1bnNldC4gSXNzdWVzIHdlcmUNCj4gPiBmaXhlZCBieSB0aGUgcHJlc2VudCBwYXRjaHNl
dC4NCj4gPg0KPiA+IFJlZmVyZW5jZXM6DQo+ID4gWzFdIGNvbW1pdCBkNjVhZjIxODQyZjggKCJu
ZXQ6IHBoeTogc21zYzogTEFOODcxMC8yMDogcmVtb3ZlDQo+ID4gICAgIFBIWV9SU1RfQUZURVJf
Q0xLX0VOIGZsYWciKQ0KPiA+ICAgICBjb21taXQgYmVkZDhkNzhhYmEzICgibmV0OiBwaHk6IHNt
c2M6IExBTjg3MTAvMjA6IGFkZCBwaHkgcmVmY2xrIGluDQo+ID4gICAgIHN1cHBvcnQiKQ0KPiA+
IFsyXSBjb21taXQgZThmY2ZjZDU2ODRhICgibmV0OiBmZWM6IG9wdGltaXplIHRoZSBjbG9jayBt
YW5hZ2VtZW50IHRvDQo+IHNhdmUNCj4gPiAgICAgcG93ZXIiKQ0KPiANCj4gUGxlYXNlIHJlc2Vu
ZCB3aXRoIGdpdCBzZW5kLWVtYWlsLCBpZiB5b3UgY2FuLg0KPiANCg0KTXkgYXBvbG9naWVzLiBJ
IHdpbGwgc2VlIGlmIEkgbWFuYWdlIHRvIHNldCB1cCBnaXQgdG8gc2VuZCBlbWFpbHMgd2l0aCBt
eSBhY2NvdW50LCANCmJ1dCBpZiBub3QgSSB3aWxsIG1ha2Ugc3VyZSB0byBjaGVjayB0aGUgZm9y
bWF0dGluZyBtb3JlIHRob3JvdWdobHkuDQpUaGFua3MgYWxzbyBmb3IgdGFraW5nIHRoZSB0aW1l
IHRvIGRldGFpbCB0aGUgZGVmZWN0cy4gDQpCZXN0IHJlZ2FyZHMuDQoNCj4gQWxsIHRoZSBwYXRj
aGVzIGhhdmUgYSAiU3ViamVjdDogW1BBVENIIiBsaW5lIGluIHRoZSBtZXNzYWdlIGJvZHksIGFu
ZCBGaXhlcw0KPiB0YWdzIGFyZSBsaW5lLXdyYXBwZWQgKHRoZXkgc2hvdWxkIGJlIG9uZSBsaW5l
IGV2ZW4gaWYgdGhleSBhcmUgbG9uZykuDQo+IA0KPiA+IExhdXJlbnQgQmFkZWwgKDUpOg0KPiA+
ICAgbmV0OnBoeTpzbXNjOiBlbmFibGUgUEhZX1JTVF9BRlRFUl9DTEtfRU4gaWYgcmVmIGNsb2Nr
IGlzIG5vdCBzZXQNCj4gPiAgIG5ldDpwaHk6c21zYzogZXhwYW5kIGRvY3VtZW50YXRpb24gb2Yg
Y2xvY2tzIHByb3BlcnR5DQo+ID4gICBuZXQ6cGh5OiBhZGQgcGh5X2RldmljZV9yZXNldF9zdGF0
dXMoKSBzdXBwb3J0DQo+ID4gICBuZXQ6cGh5OiBmaXggcGh5X3Jlc2V0X2FmdGVyX2Nsa19lbmFi
bGUoKQ0KPiA+ICAgbmV0OnBoeTogYWRkIFNNU0MgUEhZIHJlc2V0IG9uIFBNIHJlc3RvcmUNCj4g
DQo+IFRoZXJlIGFyZSBvbmx5IDQgcGF0Y2hlcyBpbiB0aGUgc2VyaWVzLg0KDQo=
