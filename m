Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E2A228137
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgGUNoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:44:16 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:63961 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGUNoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595339056; x=1626875056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XCIemFwHVUPk9JG5bOXVOGvcvPDUygaTIGU9mXoRy0Y=;
  b=WD2VMWdTUyPVnHZNFrTCg8LIva3HvX2bKbol8H5imT5LsxD/xH9Lzcm/
   Yn41D+SnaSmTS7LDVb+sp17GJ+hD+ivKixNBN/wpTBJF8MxuYM78L0C1J
   Rt1b1Bz+rhxrfhlnScXF6SzPU4g8APSCoh+JfZ84/BQpOlJaAfrFg0wNl
   pbNVG3CVd4ZOa4AOI0vC6otpQ+t+ik1HVekGmR10+NVgQt+G6vHcsr1Zu
   qPSaY1zbqG+v4WSl4fBmQgg2rRRFynX1EHxaEFBmyXd+wo37fvV1HJNoC
   UPd4D1x8CcOOJwBPcH3SUtH7XuskKbTQwbnuxJBLbylVguCM7xlZs745j
   w==;
IronPort-SDR: pBcfm6HJHWNVc8LS68LpTz9+aWZ/znox0qHY3T17wGCG6oU7jMPMoBOHQCHY+yoKJkD3th805+
 t3zK2G8IuZWP3ectSqVoEyQTxA9itBwbytIbz1AN98Y/qTtKOjwxeLRHwfTVp8Xw0BGvnYZ+eA
 C7S1Vv7bPPmQa1F3u63I+6uUcsmUcopcEC1O5+RVvtaQ34KVV3gmrcEMxAMlbx7V42d6vcanq+
 pinIMY6l0qdNBB45o8wN8dHZvv4+2uDEDWXZawa1B3/v8fHPLAqhtlzlOKqaa4rWcMNtFhrumD
 +Ms=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="84029521"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 06:44:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 06:43:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 21 Jul 2020 06:43:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWOfioQOWYyAKjkAascP26w/zIWynRc8q3/9LZYsiibl23Ul/EXu0o04DLr7CygOsJqMSIWgRIOXKj6LR+zRQXgdP2j0pRKkrlQHViNk8EwVcjs75Su/XugCQycGfHowKPskMuC+hYWt090uDFztCM1jms4FHGn26qFh8tEezx3mTnsTKg+6LV/iG9wDLJI3VQDtma32UP3JIj1A35mXQvjS6NWcUBmfZzB0N1dAJADNYOOTJTtTN/c45LbTxJU7iKoVozZwuJqji4owYWvudu3JH+xl6e0pfIKbVRIwGUZ3WPePRKGagpr2k75fuGcMLK7+wZbOfgRD8U1/ndntcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCIemFwHVUPk9JG5bOXVOGvcvPDUygaTIGU9mXoRy0Y=;
 b=dKSYO+hEWD9PkrnJcTBXnhD61ximJf9aP02teeyZ6FoD18DtGL5WtxI7BFa08H3Kw7KwpVr6IwWaKIeSAHQRC+2ViJ3FELRnQYR+Ko27f9Uf0xzx+RS+1zB6kp0vp4zvB6pa7pMGL1KbcKfani+hxk6DkTsWrc3ofLrNias5tmgvtF5TegP35r+oVR7BKESy8FwomT52m5yZpisJtRrIY+wL3oE/1EfYbfjcLl55GxMqRGTnf6yFnTq5HgPcjyiM0ZL7wjXIfRwoKxfNSxN8PTYcXe8jNugVTk4sllCaPE6dBZ0ql+6chvKKwEyEOEWpfzch33A3MG9Nyre0AWTebw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCIemFwHVUPk9JG5bOXVOGvcvPDUygaTIGU9mXoRy0Y=;
 b=elBaS847ZKB5q2AXd3DKjWJi7UW1bm6kd/kXerrCN7JY90CvcHy6Bt1dwNNRGicJZXbRgozsstZmCTXChQSvk8U9VXVgrHWDYgPhyfq/Lat1BN+N0LP0dW7l/Zp3wXu/0og/xMIpF+RcH6xTQaMb1J0+uBk7HYXac2RxYJlwpyc=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 13:44:13 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 13:44:13 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next 3/7] net: macb: parse PHY nodes found under an
 MDIO node
Thread-Topic: [PATCH net-next 3/7] net: macb: parse PHY nodes found under an
 MDIO node
Thread-Index: AQHWX0Zyppx1UbfeIEWndPdIyI+OoqkSCXKAgAACBwA=
Date:   Tue, 21 Jul 2020 13:44:12 +0000
Message-ID: <fb08dc46-68be-9fc3-0f8f-7e285815a0e6@microchip.com>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
 <20200721100234.1302910-4-codrin.ciubotariu@microchip.com>
 <20200721133655.GA1472201@lunn.ch>
In-Reply-To: <20200721133655.GA1472201@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3efac5b4-e678-4361-5f6c-08d82d7c2738
x-ms-traffictypediagnostic: SN6PR11MB3504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3504873D6B8B2461B27A7D17E7780@SN6PR11MB3504.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dRorErjZIi0H0bm/URENR1dvoYiBsD8QfAZhdPISl3tkvu4WvwRDM/jETUJ374gZuQKlJ9q+fHyBd9iIVj5eD3aEU+vsItwibPHnoU7y0czxc7Dam8mDtZV3wEBqfqfll4hkMG5GTG6/y+iTw9pRL/Qp/pJBpFDDSyBJGzVvLVFtESkaT1Fr6EQwnrRJ5g1XlPETLfz3nMkyO88VmOH7Cjt1fmvU+HuTr5cSrKId8OlkNtheWH2b6WjDtj4aTuOD7sggq4OoENBksXdkfl0Jr3KK2J2pK+ZiknNDkPc16Zg6eSBrdYbYVQxPHKErs2fmNZYv2X0WdnytJPx1/0vDEfkZ+xy5ugx/oc9WkEVgyZfd1tapOgLtk92AEfLY3gYO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(4326008)(6512007)(86362001)(54906003)(2906002)(498600001)(186003)(7416002)(8676002)(6916009)(76116006)(64756008)(91956017)(66556008)(66476007)(66946007)(4744005)(8936002)(66446008)(71200400001)(6506007)(107886003)(26005)(6486002)(36756003)(5660300002)(31686004)(31696002)(2616005)(53546011)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vx4fInbxWdtXJJtD6Z279rYE6a/nNL+ciFcTWapy+0ED1UdXQxkX2dPNz5A0vz8KdmUvZ5M+hqK1QZFifzy6CNAXHUeu/2L1eLUg/O+REhkB25/OL1pU+SBnUiZDaMwgNXepyvC+FOkafvnV3KKGHhjJro1pAcbucoE18R+4UxCl0gU746donkrBV2jxDR9otjApkUQ2lSV3SxmqEu3nU0BnAKKzGQSc7tDrBXnvF/PZ+9IPh5Lbxhdjwk0V6gqzH3J+oAohRd30xHRrH61DCYbI5xLiX9XWKfz1iUC9isD0QgAMebzaoeqfHjkXrphyTuma00Y5zhWCQ4TCpQyed7JoMSnj+AfOty9Vv6CUixB33DJhmG6LVA1jl3CIwRPvqcEjYAHUzN9649CBdB0otvdnWKvPbAv1UqGOcyj0sLRFs3Xt5M5JYRlrLKWJXluZIaywe4eUq/dO3uAvdZ5bLDhDqUk/QJRFCFnGuul9zJXLz3OBBbF9PrIfYnvaNOIn
Content-Type: text/plain; charset="utf-8"
Content-ID: <4640F424C63DFF4C912F736285AD2DB5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3efac5b4-e678-4361-5f6c-08d82d7c2738
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 13:44:12.8506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TwJAvd7+2+/q+LVixovi3hTVAlyTvaYPiAKyCTX6Gbfu0kihX2P5AiWJxW3CqvvDGxoyJA8p+RGiPEzqXaaBVfxRcGy+Sd2eaFkcBmOAAvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEuMDcuMjAyMCAxNjozNiwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4+IEBAIC03NTUsNyArNzY1LDYgQEAgc3RhdGljIGlu
dCBtYWNiX21kaW9idXNfcmVnaXN0ZXIoc3RydWN0IG1hY2IgKmJwKQ0KPj4gICAgICAgICAgICAg
ICAgICAgICAgICAgKiBkZWNyZW1lbnQgaXQgYmVmb3JlIHJldHVybmluZy4NCj4+ICAgICAgICAg
ICAgICAgICAgICAgICAgICovDQo+PiAgICAgICAgICAgICAgICAgICAgICAgIG9mX25vZGVfcHV0
KGNoaWxkKTsNCj4+IC0NCj4+ICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIG9mX21kaW9i
dXNfcmVnaXN0ZXIoYnAtPm1paV9idXMsIG5wKTsNCj4+ICAgICAgICAgICAgICAgIH0NCj4gDQo+
IFBsZWFzZSBhdm9pZCB3aGl0ZSBzcGFjZSBjaGFuZ2VzIGxpa2UgdGhpcy4NCg0KU29ycnkgYWJv
dXQgdGhpcywgaXQgd2FzIG5vdCBpbnRlbmRlZC4gV2lsbCBmaXggaW4gdjIuIFRoYW5rcyENCg0K
PiANCj4gT3RoZXJ3aXNlIHRoaXMgbG9va3MgTy5LLg0KPiANCj4gICAgICAgICBBbmRyZXcNCj4g
DQoNCg==
