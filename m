Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730502B9AEA
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 19:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgKSSvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 13:51:23 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:7008 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgKSSvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 13:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605811883; x=1637347883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=seu1I9S1RtPdVx2cDTQsxmfeVDgfgAHU/Qapy2hz8BI=;
  b=bsd2SMbF2A/uagqkdO1gEE1gVLcja1OddCArn0zmCWJjIKKOIxyEmwwh
   Hv+bugVDByily8OCsFvy4g1cwiwk1RZ3XMNTTZpPuonhe3BN7sik2SdYx
   HerU28r0r/Ngi7xawxKiwA5Wle0ZVZEsfsxDyEMUNX1XPB9Xo8v85o3Ll
   6QiDTyaFT7Fe1K/G21+1sn/+EecsGXQ7Hh3nisrPH/fCQ6CkK6oyEiPCW
   JUxwnN3waGB0w38Ggl5X6PttvziX13BX5TFLFBADG4Sq8KIR3rkI8Ap0a
   IVWc3apXnudk6c2jd61U/40b24zPcq+AiA4YSuUDZBCvPcJsKb8WD9gdS
   Q==;
IronPort-SDR: FRhX5BvMj7CMyP6qfkAn1n3Z+MzxoBDrL3+d0MpJqhIPRA9XH+XnIfIIq7IBaSg6JrAQVKsxe7
 Gyuk8gEyYgmEwXqM2ybfBkpU7nzpGFChQtBD019sOAE7Po88YSXqWSts2e/0ZzF0tQOBFhNqhZ
 jjrclUYQpD0EmTwq6/gc7XAkpD1YhCk7NTrMwPiG9rAsJ0CUf0U9/uWvhx4yVIwx0KxJ+pHchF
 G9PXl5Ec+0AgPbpBHV2ag5zbHEDJ0VYEV42wcJNiFECEj0TcZOfy9kG7tesan84I4HrTyGgqZ/
 pn4=
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="94269681"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Nov 2020 11:51:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 11:51:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 19 Nov 2020 11:51:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ea1hh0LcdJuMfPnwoUHCw+/SbDTe8QCNwCacWvLq8ClUrcKPwhqLLvnbqz0KP26lBysazwrGy3NfDNS2KcjYNrOtK764NherQWqPyJi08k+BXcRyckmZoJp/694B8vIQhKCO0HrILkrO0y6XDyRaP387Vg8Kq1Dnc4Xh5d/xtVSMh1/wgkDacm3IoLQ4x+WqWrWLkbvfST0IMvcBDho9Oyo1egx/gO4KjwcPPPOUB+OT3ozkwCF380fRFji3FmjaE7p0s+zMxskt0J769kjESy2lrMAOYTUcRwOOlbV5XJuRWB+Z/zLs6pq/3gJXKHN2SubVmcex+aGzI6k1B8K5wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seu1I9S1RtPdVx2cDTQsxmfeVDgfgAHU/Qapy2hz8BI=;
 b=oO8aTqHlRMAz5v/JVHZqrGgS2omfOu5aR/jKDsgQos4zXtvesB0rp8z9It079qb4JjhDHgWp19uwdd8wwyHWA5h/FbBV4PqqDiOHBlrTB8IQVYxv9cW538uVovsps+uYK72czSeCPO5al3s0jIaVMq3kjAw48/bR38snn29ziZthun7+NFD+ZEaML0StttfrxyXbwr80p0smdsocQCIi+ojW8Toy3JYskl7h5Drh/wd6vNYBr8aAJTOVIUogO7iDPBjUUWeZismgZ9Zd5JAOK14co79FZ5a4buXFYa/qLZcvDdJCnpaWG9dM4NwoblKUcao6G3869YvNsjGArBNVHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seu1I9S1RtPdVx2cDTQsxmfeVDgfgAHU/Qapy2hz8BI=;
 b=mmpL/iqMFc0qTbZDzNopaHeYabItms0dOqvUyGakdVQoS8tybbR3BMGpqe1M9ksvMTHfdWMMrpYVscLlKJ/Gcir0uc+wMrJTf6b0cQ59uH2r7IA2ekCgs4B4RaLcCCrfEZGNFFW7oYv8zExWs5NagB8qv8WuQzwk5pe8TRQzEcI=
Received: from BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11)
 by BYAPR11MB3400.namprd11.prod.outlook.com (2603:10b6:a03:1a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 19 Nov
 2020 18:51:16 +0000
Received: from BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::d420:c3da:146c:977e]) by BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::d420:c3da:146c:977e%7]) with mapi id 15.20.3564.031; Thu, 19 Nov 2020
 18:51:16 +0000
From:   <Tristram.Ha@microchip.com>
To:     <ceggers@arri.de>, <olteanv@gmail.com>
CC:     <kuba@kernel.org>, <andrew@lunn.ch>, <richardcochran@gmail.com>,
        <robh+dt@kernel.org>, <vivien.didelot@gmail.com>,
        <davem@davemloft.net>, <kurt.kanzenbach@linutronix.de>,
        <george.mccollister@gmail.com>, <marex@denx.de>,
        <helmut.grohne@intenta.de>, <pbarker@konsulko.com>,
        <Codrin.Ciubotariu@microchip.com>, <Woojung.Huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for
 KSZ956x
Thread-Topic: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for
 KSZ956x
Thread-Index: AQHWvenhDxym6cdhMkevUTN+Ss+rxqnOjIQAgABhLACAANQCsA==
Date:   Thu, 19 Nov 2020 18:51:15 +0000
Message-ID: <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118234018.jltisnhjesddt6kf@skbuf> <2452899.Bt8PnbAPR0@n95hx1g2>
In-Reply-To: <2452899.Bt8PnbAPR0@n95hx1g2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arri.de; dkim=none (message not signed)
 header.d=none;arri.de; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [99.25.38.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01b35f1a-06bb-4d18-a8a3-08d88cbc183f
x-ms-traffictypediagnostic: BYAPR11MB3400:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB34001584E1DFE8241CAAD2CEECE00@BYAPR11MB3400.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1QjvyLhViVKXE/8mtm4eUJZCIq4ecYK17sizODFhQKC6nQX+yTB288zHliQuitPOsBlU0hvVlaJbMBDRuAkCIDKLZBThW3XM+E88QeHHK5gQi5TIxgMJFnrLOz3r19xLX8MBj/Q3g/CRlFjpamKbX5ncqvoZWzN0C3xaz6PVkk5hwULVC64qvRsi0NIks7g8BiVJ3dpPYsl0DqW5cStnj8f+21s2xsS6EP/d1sfoRHIHeRLJLMH/Rl3yv8XqUQB22qHJAw4axl80AIWxFRUDgZpHDe3cvcaxQH3O2z+YjnciYi+hU5fDxw63lk9lV4WEhPkT4sSjm/im/sDVTvFoLTVVxJ9SMRuyl18JnvZU9HJBY9gOE8j+yhlEXVjN/0Xo7KeEsEJ8V7oIViFY+ryyFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(39860400002)(366004)(71200400001)(66556008)(64756008)(66446008)(7416002)(7696005)(5660300002)(4326008)(55016002)(76116006)(66946007)(66476007)(86362001)(2906002)(83380400001)(52536014)(478600001)(110136005)(54906003)(8676002)(9686003)(26005)(8936002)(966005)(33656002)(316002)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: azTCSouBJ1sAE79xbyETIIq1vkoHjxYkXGPrQKkkItBqKc70v7/RsVkmsQ+SU2LKZI64eMQzZFNvxmb7cUGFSFwXIsiPWFD+4rQFm0WnEb7WYpnJM0kUKF0S93a1BetFxc6LaA1XbbGgWltpafbzgqf5i9gDiga3doEf8uWZ0Hpgrx6aol/QxpLamOTLePSZZyqfiqocIyXgWYTYZ/dfxoPvtVpf0wm5eUWCd0rFSHP4LPyGv1GXcr21c+b2Z21zXRRgJLQ9fiQwGoiCuLwShyfqyT2avvqY0PVlK/b+ViGCUPVUVZ5M+lnCofHcc+2z5krgBzpUNe/B/gQWQ7XM+mvHK10KaRhYlhpliqoxxHYSKXHHqTcAJTvE4bc4hf0rby8WMhJhuptjg1X6QXJCmOH0j+ym464JG+yTMB7Gb8k7mmmtLA5pXqEvXwt0yE+HV40XLrVKja8DQE7jIT6tnxH1YTm7obYDj7disQWGXmAV/OVJDcNpMUd9z9lK4ikGi6XmzBZxjhAE09Fnm/Ndqz8NEwhuwAGiFZDo+NYuuQzxOz0pvIClPco2uePqxbKiLBWRKccVaUbJMHZgugmkFya3sTqRE15dsC3p5PGC37kUWSRuDC8wnp/QVoW3ASYWXU6vhdbItcDo7AhWnuyxEA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b35f1a-06bb-4d18-a8a3-08d88cbc183f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 18:51:15.9022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1RhheuEhQn+EBkIybRi/OesbmTFz+NfvonvVrmdg6/Gbdu4YUL7iyxpJTqb0phomNtb6X+3L2+ZXDG+jO0daEa5ENuAN7KrrXZmuc38/XRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBUaHVyc2RheSwgMTkgTm92ZW1iZXIgMjAyMCwgMDA6NDA6MTggQ0VULCBWbGFkaW1pciBP
bHRlYW4gd3JvdGU6DQo+ID4gT24gV2VkLCBOb3YgMTgsIDIwMjAgYXQgMDk6MzA6MDFQTSArMDEw
MCwgQ2hyaXN0aWFuIEVnZ2VycyB3cm90ZToNCj4gPiA+IFRoaXMgc2VyaWVzIGFkZHMgc3VwcG9y
dCBmb3IgUFRQIHRvIHRoZSBLU1o5NTZ4IGFuZCBLU1o5NDc3IGRldmljZXMuDQo+ID4gPg0KPiA+
ID4gVGhlcmUgaXMgb25seSBsaXR0bGUgZG9jdW1lbnRhdGlvbiBmb3IgUFRQIGF2YWlsYWJsZSBv
biB0aGUgZGF0YSBzaGVldA0KPiA+ID4gWzFdIChtb3JlIG9yIGxlc3Mgb25seSB0aGUgcmVnaXN0
ZXIgcmVmZXJlbmNlKS4gUXVlc3Rpb25zIHRvIHRoZQ0KPiA+ID4gTWljcm9jaGlwIHN1cHBvcnQg
d2VyZSBzZWxkb20gYW5zd2VyZWQgY29tcHJlaGVuc2l2ZWx5IG9yIGluDQo+IHJlYXNvbmFibGUN
Cj4gPiA+IHRpbWUuIFNvIHRoaXMgaXMgbW9yZSBvciBsZXNzIHRoZSByZXN1bHQgb2YgcmV2ZXJz
ZSBlbmdpbmVlcmluZy4NCj4gPg0KPiA+IFsuLi5dDQo+ID4gT25lIHRoaW5nIHRoYXQgc2hvdWxk
IGRlZmluaXRlbHkgbm90IGJlIHBhcnQgb2YgdGhpcyBzZXJpZXMgdGhvdWdoIGlzDQo+ID4gcGF0
Y2ggMTEvMTIuIENocmlzdGlhbiwgZ2l2ZW4gdGhlIGNvbnZlcnNhdGlvbiB3ZSBoYWQgb24geW91
ciBwcmV2aW91cw0KPiA+IHBhdGNoOg0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRl
di8yMDIwMTExMzAyNTMxMS5qcGtwbGhtYWNqejZsa2M1QHNrYnVmLw0KPiBzb3JyeSwgSSBkaWRu
J3QgcmVhZCB0aGF0IGNhcmVmdWxseSBlbm91Z2guIFNvbWUgb2YgdGhlIG90aGVyIHJlcXVlc3Rl
ZA0KPiBjaGFuZ2VzDQo+IHdlcmUgcXVpdGUgY2hhbGxlbmdpbmcgZm9yIG1lLiBBZGRpdGlvbmFs
bHksIGZpbmRpbmcgdGhlIFVEUCBjaGVja3N1bSBidWcNCj4gbmVlZGVkIHNvbWUgdGltZSBmb3Ig
aWRlbnRpZnlpbmcgYmVjYXVzZSBJIGRpZG4ndCByZWNvZ25pemUgdGhhdCB3aGVuIGl0IGdvdA0K
PiBpbnRyb2R1Y2VkLg0KPiANCj4gPiBhcyB3ZWxsIGFzIHRoZSBkb2N1bWVudGF0aW9uIHBhdGNo
IHRoYXQgd2FzIHN1Ym1pdHRlZCBpbiB0aGUgbWVhbnRpbWU6DQo+ID4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbmV0ZGV2LzIwMjAxMTE3MjEzODI2LjE4MjM1LTEtDQo+IGEuZmF0b3VtQHBlbmd1
dHJvbml4LmRlLw0KPiBJIGFtIG5vdCBzdWJzY3JpYmVkIHRvIHRoZSBsaXN0Lg0KPiANCj4gPiBv
YnZpb3VzbHkgeW91IGNob3NlIHRvIGNvbXBsZXRlbHkgZGlzcmVnYXJkIHRoYXQuIE1heSB3ZSBr
bm93IHdoeT8gSG93DQo+ID4gYXJlIHlvdSBldmVuIG1ha2luZyB1c2Ugb2YgdGhlIFBUUF9DTEtf
UkVRX1BQUyBmZWF0dXJlPw0KPiBPZiBjb3Vyc2UgSSB3aWxsIGRyb3AgdGhhdCBwYXRjaCBmcm9t
IHRoZSBuZXh0IHNlcmllcy4NCg0KVGhlc2UgYXJlIGdlbmVyYWwgY29tbWVudHMgYWJvdXQgdGhp
cyBQVFAgcGF0Y2guDQoNClRoZSBpbml0aWFsIHByb3Bvc2FsIGluIHRhZ19rc3ouYyBpcyBmb3Ig
dGhlIHN3aXRjaCBkcml2ZXIgdG8gcHJvdmlkZSBjYWxsYmFjayBmdW5jdGlvbnMNCnRvIGhhbmRs
ZSByZWNlaXZpbmcgYW5kIHRyYW5zbWl0dGluZy4gIFRoZW4gZWFjaCBzd2l0Y2ggZHJpdmVyIGNh
biBiZSBhZGRlZCB0bw0KcHJvY2VzcyB0aGUgdGFpbCB0YWcgaW4gaXRzIG93biBkcml2ZXIgYW5k
IGxlYXZlIHRhZ19rc3ouYyB1bmNoYW5nZWQuDQoNCkl0IHdhcyByZWplY3RlZCBiZWNhdXNlIG9m
IHdhbnRpbmcgdG8ga2VlcCB0YWdfa3N6LmMgY29kZSBhbmQgc3dpdGNoIGRyaXZlciBjb2RlDQpz
ZXBhcmF0ZSBhbmQgY29uY2VybiBhYm91dCBwZXJmb3JtYW5jZS4NCg0KTm93IHRhZ19rc3ouYyBp
cyBmaWxsZWQgd2l0aCBQVFAgY29kZSB0aGF0IGlzIG5vdCByZWxldmFudCBmb3Igb3RoZXIgc3dp
dGNoZXMgYW5kIHdpbGwNCm5lZWQgdG8gYmUgY2hhbmdlZCBhZ2FpbiB3aGVuIGFub3RoZXIgc3dp
dGNoIGRyaXZlciB3aXRoIFBUUCBmdW5jdGlvbiBpcyBhZGRlZC4NCg0KQ2FuIHdlIGltcGxlbWVu
dCB0aGF0IGNhbGxiYWNrIG1lY2hhbmlzbT8NCg0KT25lIGlzc3VlIHdpdGggdHJhbnNtaXNzaW9u
IHdpdGggUFRQIGVuYWJsZWQgaXMgdGhhdCB0aGUgdGFpbCB0YWcgbmVlZHMgdG8gY29udGFpbiA0
DQphZGRpdGlvbmFsIGJ5dGVzLiAgV2hlbiB0aGUgUFRQIGZ1bmN0aW9uIGlzIG9mZiB0aGUgYnl0
ZXMgYXJlIG5vdCBhZGRlZC4gIFRoaXMgc2hvdWxkDQpiZSBtb25pdG9yZWQgYWxsIHRoZSB0aW1l
Lg0KDQpUaGUgZXh0cmEgNCBieXRlcyBhcmUgb25seSB1c2VkIGZvciAxLXN0ZXAgUGRlbGF5X1Jl
c3AuICBJdCBzaG91bGQgY29udGFpbiB0aGUgcmVjZWl2ZQ0KdGltZXN0YW1wIG9mIHByZXZpb3Vz
IFBkZWxheV9SZXEgd2l0aCBsYXRlbmN5IGFkanVzdGVkLiAgVGhlIGNvcnJlY3Rpb24gZmllbGQg
aW4NClBkZWxheV9SZXNwIHNob3VsZCBiZSB6ZXJvLiAgSXQgbWF5IGJlIGEgaGFyZHdhcmUgYnVn
IHRvIGhhdmUgd3JvbmcgVURQIGNoZWNrc3VtDQp3aGVuIHRoZSBtZXNzYWdlIGlzIHNlbnQuDQoN
CkkgdGhpbmsgdGhlIHJpZ2h0IGltcGxlbWVudGF0aW9uIGlzIGZvciB0aGUgZHJpdmVyIHRvIHJl
bWVtYmVyIHRoaXMgcmVjZWl2ZSB0aW1lc3RhbXANCm9mIFBkZWxheV9SZXEgYW5kIHB1dHMgaXQg
aW4gdGhlIHRhaWwgdGFnIHdoZW4gaXQgc2VlcyBhIDEtc3RlcCBQZGVsYXlfUmVzcCBpcyBzZW50
Lg0KDQpUaGVyZSBpcyBvbmUgbW9yZSByZXF1aXJlbWVudCB0aGF0IGlzIGEgbGl0dGxlIGRpZmZp
Y3VsdCB0byBkby4gIFRoZSBjYWxjdWxhdGVkIHBlZXIgZGVsYXkNCm5lZWRzIHRvIGJlIHByb2dy
YW1tZWQgaW4gaGFyZHdhcmUgcmVnaXN0ZXIsIGJ1dCB0aGUgcmVndWxhciBQVFAgc3RhY2sgaGFz
IG5vIHdheSB0bw0Kc2VuZCB0aGF0IGNvbW1hbmQuICBJIHRoaW5rIHRoZSBkcml2ZXIgaGFzIHRv
IGRvIGl0cyBvd24gY2FsY3VsYXRpb24gYnkgc25vb3Bpbmcgb24gdGhlDQpQZGVsYXlfUmVxL1Bk
ZWxheV9SZXNwL1BkZWxheV9SZXNwX0ZvbGxvd19VcCBtZXNzYWdlcy4NCg0KVGhlIHJlY2VpdmUg
YW5kIHRyYW5zbWl0IGxhdGVuY2llcyBhcmUgZGlmZmVyZW50IGZvciBkaWZmZXJlbnQgY29ubmVj
dGVkIHNwZWVkLiAgU28gdGhlDQpkcml2ZXIgbmVlZHMgdG8gY2hhbmdlIHRoZW0gd2hlbiB0aGUg
bGluayBjaGFuZ2VzLiAgRm9yIHRoYXQgcmVhc29uIHRoZSBQVFAgc3RhY2sNCnNob3VsZCBub3Qg
dXNlIGl0cyBvd24gbGF0ZW5jeSB2YWx1ZXMgYXMgZ2VuZXJhbGx5IHRoZSBhcHBsaWNhdGlvbiBk
b2VzIG5vdCBjYXJlIGFib3V0DQp0aGUgbGlua2VkIHNwZWVkLg0KIA0K
