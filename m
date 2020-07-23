Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57A622AA0D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 09:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgGWHvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 03:51:54 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:51686 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgGWHvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 03:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595490712; x=1627026712;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hiuPNBGi4RXNNjGG2ixGTRRVmKDTjodCCcyFSr034T8=;
  b=BEGTTY/Xn/GNLu+riu+CwH2vLLEpMweBWNe0DwYCCE0D5TuywAw29Rjj
   3PLoiAsIE0C6HikugTgZgWP3AUUr0mKdzZDY7PeLjftqPYoM56ljcSzvM
   KRBhJn9RiFanvRw/rcTUnMPZDJKhc0ghW6zi47S7BubvS+IR+FqZQW+PX
   2ZBm74Eyimc3D9hy3WCHt4sZQT9ZkYa6ZAwzzdTCEGiba5oByLEMsPz3k
   LE9O1ckJqxgoOKFDQyrxu8OA3kRQpwFHaAVLd+T7vwaiY8ueL6ObOATh2
   Trdfo+wYS1Dn+Pd9armZXLDeIHJ1PPvXNjva7cg5GvJPvRM0CnC/0WeRQ
   A==;
IronPort-SDR: 3sSb+N1kW/HIFdAFPuFvfDFPRzGtFO4vJauphphqqsOx12+UG8JZ7oreuLN0LyTwYoRRLLm5aI
 oeDidev9WrENzq+qvwMxDmLiS4yBA93vgSC/L8g/Oh10H0Iqj014o05GD2nurikxRUwiv9Tqst
 7mjYsj9bdLcvy2Lbj2HbaTAz8EcNa3Mvsbdpa+OImJnrB2vvBYvJUuJq2lYWaQAbYTXjJ4jofH
 3aUk8E4QCnr5KcDBwDktzpkwhRt+IJ7JcyUFQXhK6quEj9YMZntJn7AnspgY2wFOwGJwrumP/c
 Aek=
X-IronPort-AV: E=Sophos;i="5.75,385,1589266800"; 
   d="scan'208";a="82939593"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2020 00:51:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 00:51:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Thu, 23 Jul 2020 00:51:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQ5QBpYE7B0PZfnDPjPN9xC9oHP36oyQ5KIa7hJk4pR3ubb6JNKxHBrcjSJFqHEMeY/lMubKrqSqSGyKSI5vmDlW59sJrga/G5qGpz00jJh5GcTdLXMoBH1wFPjyJuz3El9lGVYl7lhIag8SaakmfHV7+SnfNZXykb7skVkBKhwTASO3Nes9GQO+V1KUJpxNp3p33K13pscrr9qdHIygdj+msKd0OJIKO9YNIQ6iso77odHYO1b90HxIScG3CupupsxHXPO3bJuaUgenYD8OMDiYGnk+TngJ/Ee4sKZ6gOZTbV7FLlENh+5S0K0nM8cRSSb8CdoXK33ezDyGnBwWoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiuPNBGi4RXNNjGG2ixGTRRVmKDTjodCCcyFSr034T8=;
 b=UuaXMYIcZMjbuHhwCUvsZpXOrTB8fZo/Hmq8yaACGHkpeiJhbvPg90aA2dV7HYNyXnt6dnJazE3B9MsPwTcfP8D4p4gcOoDyVOt1Noh8II9gS5cCjdawEqMUL1FzfvJaCG2MpRDMj0UZ5wbWs/dIwZjMX7jCxoZucWBBQsndGs6PY4ZstnaY5Qx+I7GmGOifaixkxUXrPD90UJVJ9fCUoN0mt+igVGFRrQKd+YtFIKOLTPox3XrP4db+bf1bI66FLGnE9bVndiKmaWNSiNR6VXVmJDfZz/7RVga8P65PkSfXyvzDsmPDV8o3FM2w1X1pMFeNeR4A8q/fFiocHYkmpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiuPNBGi4RXNNjGG2ixGTRRVmKDTjodCCcyFSr034T8=;
 b=VhNb8S9UjCOS3lZwW2yWrxs/gkivTkhgb4Ixarc8d7Fqc1Juxmq2+jHou8w8GFq8x/ghsbHFlZZZw52Elu4fTzLmj58aOVYPj/xdUlWN7yRKn04wX2wd89Raqwv7KyHtH4gYLhOl0D3za8dR4Irkcgdsq35SgKSI0RAjmXHeTMw=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM5PR11MB1578.namprd11.prod.outlook.com (2603:10b6:4:e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.23; Thu, 23 Jul 2020 07:51:48 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::e8b2:1d82:49d9:f4b]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::e8b2:1d82:49d9:f4b%6]) with mapi id 15.20.3216.024; Thu, 23 Jul 2020
 07:51:48 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Codrin.Ciubotariu@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <robh+dt@kernel.org>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next v2 0/7] Add an MDIO sub-node under MACB
Thread-Topic: [PATCH net-next v2 0/7] Add an MDIO sub-node under MACB
Thread-Index: AQHWYBNhIyVBpIRYr0OAbjzWw9KOlQ==
Date:   Thu, 23 Jul 2020 07:51:48 +0000
Message-ID: <8a78218a-9fbe-889d-8501-ad67ccb6e59b@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
 <0ec99957-57e9-b384-425a-ccf0e877f1a1@microchip.com>
 <7cab13f6-ac54-8f5c-c1bf-35e6c3b5d9db@microchip.com>
In-Reply-To: <7cab13f6-ac54-8f5c-c1bf-35e6c3b5d9db@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [213.233.110.107]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e28297b-f1ab-4235-3d05-08d82edd40f4
x-ms-traffictypediagnostic: DM5PR11MB1578:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB157892AE227824BC6673944187760@DM5PR11MB1578.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dMN1S7M8sH8DjdAkUxSMcNY0+iQ6IC/hkxpgrV50yxt5zDjWQ/JK7BWobPSwpgtKe5udrbnH5cm8vrSmp4p8S2qnBNmS5CJrCsfuHH90bUBEWLbWHBW4UTXzirqqHjdcMJptRAKJ5Lo+9Pxw4kGKo3LYET4cejl/m2i6lm2XZ6o8TQSwFTBS8AV85KGZalMNnyB6zsMI+5RcIXOxINeVBDELGtx4dAi/6QEQzhG/eVvhsmswSW7504obegdnaDKEDsjkx+pojn+i9y9Gv/URyqMPkzcPyn8C1OyV8AG2mSs6hoziw5YLt0YI5Wu+VborWLNynvPtM3cFZm6Xy+AYveTYChqwJd7zzVQfj10L4H9jVjQoWX/fwPlr1YocntZv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(136003)(39860400002)(396003)(2616005)(26005)(53546011)(478600001)(6486002)(31686004)(6506007)(110136005)(186003)(83380400001)(71200400001)(66476007)(66446008)(64756008)(66556008)(91956017)(76116006)(8936002)(107886003)(31696002)(4326008)(316002)(54906003)(8676002)(86362001)(7416002)(6512007)(66946007)(2906002)(36756003)(5660300002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KCz6ex+hXqI0FAH/3jmGpNh7UafUFWy35KWD0oZYvqb3EoEX5MWDiJH4lZc3p6F3MZPbVhqGDFN+JHy8pYVXIMUG535O++iKUAFdOM1LM3uIvzwsoFcVu0rsEV25K4WlN5z83/Q96B9ZCmxT1oNiowIL502ymMxuS7wYghcNH909aFoFsk2Gk48bUrsbkMPCq2UP52DWNUlWO51/6RMxjBhHIXkyMclfdemEYqP+7zTpntv35woH6gqNtqeXLtcnqA4DCwBG4ExokKWVAoqQjZVzrixvotuM6nztbaTNMQ6zeQP9R1CBXYeTAXJ82OiZlu1CuxxKYZiPLLNdxP+mw5foLrf/3gxAz8eJSckAKvpyg0YFN44/pdjcc2yMAf6CMx21M1nMPkg8mI5ZXLCusUB2OyH3C4pBYliEjySej89/1wXpXInFllJQ1PV9KZU9moERyP+i623dsZbv4Vqvf9bwjb2EzFKz9XKzXNXOOWJXo8meXx0u5V9VvqaJGQ5Q
Content-Type: text/plain; charset="utf-8"
Content-ID: <283181F64A83D845874B94714A0D4929@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e28297b-f1ab-4235-3d05-08d82edd40f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 07:51:48.3694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zRw1JD05J480xnGSzDNcnRmUn1vYmCHxBDCjG2aMngLRTfGtltZDXpDLI3l2lk1ROVCLkwHjbrSDD8cPlvTBUj0vw4LYbaOR+0SwuOL3+JI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1578
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIyLjA3LjIwMjAgMTQ6MzgsIENvZHJpbiBDaXVib3Rhcml1IC0gTTE5OTQwIHdyb3Rl
Og0KPiBPbiAyMi4wNy4yMDIwIDEzOjMyLCBDbGF1ZGl1IEJlem5lYSAtIE0xODA2MyB3cm90ZToN
Cj4+DQo+Pg0KPj4gT24gMjEuMDcuMjAyMCAyMDoxMywgQ29kcmluIENpdWJvdGFyaXUgd3JvdGU6
DQo+Pj4gQWRkaW5nIHRoZSBQSFkgbm9kZXMgZGlyZWN0bHkgdW5kZXIgdGhlIEV0aGVybmV0IG5v
ZGUgYmVjYW1lIGRlcHJlY2F0ZWQsDQo+Pj4gc28gdGhlIGFpbSBvZiB0aGlzIHBhdGNoIHNlcmll
cyBpcyB0byBtYWtlIE1BQ0IgdXNlIGFuIE1ESU8gbm9kZSBhcw0KPj4+IGNvbnRhaW5lciBmb3Ig
TURJTyBkZXZpY2VzLg0KPj4+IFRoaXMgcGF0Y2ggc2VyaWVzIHN0YXJ0cyB3aXRoIGEgc21hbGwg
cGF0Y2ggdG8gdXNlIHRoZSBkZXZpY2UtbWFuYWdlZA0KPj4+IGRldm1fbWRpb2J1c19hbGxvYygp
LiBJbiB0aGUgbmV4dCB0d28gcGF0Y2hlcyB3ZSB1cGRhdGUgdGhlIGJpbmRpbmdzIGFuZA0KPj4+
IGFkYXB0IG1hY2IgZHJpdmVyIHRvIHBhcnNlIHRoZSBkZXZpY2UtdHJlZSBQSFkgbm9kZXMgZnJv
bSB1bmRlciBhbiBNRElPDQo+Pj4gbm9kZS4gVGhlIGxhc3QgcGF0Y2hlcyBhZGQgdGhlIE1ESU8g
bm9kZSBpbiB0aGUgZGV2aWNlLXRyZWVzIG9mIHNhbWE1ZDIsDQo+Pj4gc2FtYTVkMywgc2FtYWQ0
IGFuZCBzYW05eDYwIGJvYXJkcy4NCj4+Pg0KPj4NCj4+IFRlc3RlZCB0aGlzIHNlcmllcyBvbiBz
YW1hNWQyX3hwbGFpbmVkIGluIHRoZSBmb2xsb3dpbmcgc2NlbmFyaW9zOg0KPj4NCj4+IDEvIFBI
WSBiaW5kaW5ncyBmcm9tIHBhdGNoIDQvNzoNCj4+IG1kaW8gew0KPj4gCSNhZGRyZXNzLWNlbGxz
ID0gPDE+Ow0KPj4gCSNzaXplLWNlbGxzID0gPDA+Ow0KPj4gCWV0aGVybmV0LXBoeUAxIHsNCj4+
IAkJcmVnID0gPDB4MT47DQo+PiAJCWludGVycnVwdC1wYXJlbnQgPSA8JnBpb0E+Ow0KPj4gCQlp
bnRlcnJ1cHRzID0gPFBJTl9QQzkgSVJRX1RZUEVfTEVWRUxfTE9XPjsNCj4+IH07DQo+Pg0KPj4g
Mi8gUEhZIGJpbmRpbmdzIGJlZm9yZSB0aGlzIHNlcmllczoNCj4+IGV0aGVybmV0LXBoeUAxIHsN
Cj4+IAlyZWcgPSA8MHgxPjsNCj4+IAlpbnRlcnJ1cHQtcGFyZW50ID0gPCZwaW9BPjsNCj4+IAlp
bnRlcnJ1cHRzID0gPFBJTl9QQzkgSVJRX1RZUEVfTEVWRUxfTE9XPjsNCj4+IH07DQo+Pg0KPj4g
My8gTm8gUEhZIGJpbmRpbmdzIGF0IGFsbC4NCj4+DQo+PiBBbGwgMyBjYXNlcyB3ZW50IE9LLg0K
Pj4NCj4+IFlvdSBjYW4gYWRkOg0KPj4gVGVzdGVkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRp
dS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4+IEFja2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xh
dWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4gDQo+IFRoYW5rIHlvdSB2ZXJ5IG11Y2ggQ2xh
dWRpdSENCj4gVGhlcmUgaXMgc3RpbGwgb25lIG1vcmUgY2FzZSBpbiBteSBtaW5kLiBtYWNiIGNv
dWxkIGJlIGEgZml4ZWQtbGluayB3aXRoIA0KPiBhbiBNRElPIERTQSBzd2l0Y2guIFdoaWxlIHRo
ZSBtYWNiIHdvdWxkIGhhdmUgYSBmaXhlZCBjb25uZWN0aW9uIHdpdGggYSANCj4gcG9ydCBmcm9t
IHRoZSBEU0Egc3dpdGNoLCB0aGUgc3dpdGNoIGNvdWxkIGJlIGNvbmZpZ3VyZWQgdXNpbmcgbWFj
YidzIA0KPiBNRElPLiBUaGUgZHQgd291bGQgYmUgc29tZXRoaW5nIGxpa2U6DQo+IA0KPiBtYWNi
IHsNCj4gCWZpeGVkLWxpbmsgew0KPiAJCS4uLg0KPiAJfTsNCj4gCW1kaW8gew0KPiAJCXN3aXRj
aEAwIHsNCj4gCQkJLi4uDQo+IAkJfTsNCj4gCX07DQo+IH07DQoNCkRvIHlvdSBoYXZlIGEgc2V0
dXAgZm9yIHRlc3RpbmcgdGhpcz8gQXQgdGhlIG1vbWVudCBJIGRvbid0IGtub3cgYQ0KY29uZmln
dXJhdGlvbiBsaWtlIHRoaXMgdGhhdCBtYWNiIGlzIHdvcmtpbmcgd2l0aC4NCg0KPiANCj4gVG8g
c3VwcG9ydCB0aGlzLCBpbiBwYXRjaCAzLzcgSSBzaG91bGQgZmlyc3QgY2hlY2sgZm9yIHRoZSBt
ZGlvIG5vZGUgdG8gDQo+IHJldHVybiBvZl9tZGlvYnVzX3JlZ2lzdGVyKCkgYW5kIHRoZW4gY2hl
Y2sgaWYgaXQncyBhIGZpeGVkLWxpbmsgdG8gDQo+IHJldHVybiBzaW1wbGUgbWRpb2J1c19yZWdp
c3RlcigpLiBJIHdpbGwgYWRkcmVzcyB0aGlzIGluIHYzLi4uPiANCj4gVGhhbmtzIGFuZCBiZXN0
IHJlZ2FyZHMsDQo+IENvZHJpbg0KPiANCj4+DQo+PiBUaGFuayB5b3UsDQo+PiBDbGF1ZGl1IEJl
em5lYQ0KPj4NCj4+PiBDaGFuZ2VzIGluIHYyOg0KPj4+ICAgLSByZW5hbWVkIHBhdGNoIDIvNyBm
cm9tICJtYWNiOiBiaW5kaW5ncyBkb2M6IHVzZSBhbiBNRElPIG5vZGUgYXMgYQ0KPj4+ICAgICBj
b250YWluZXIgZm9yIFBIWSBub2RlcyIgdG8gImR0LWJpbmRpbmdzOiBuZXQ6IG1hY2I6IHVzZSBh
biBNRElPDQo+Pj4gICAgIG5vZGUgYXMgYSBjb250YWluZXIgZm9yIFBIWSBub2RlcyINCj4+PiAg
IC0gYWRkZWQgYmFjayBhIG5ld2xpbmUgcmVtb3ZlZCBieSBtaXN0YWtlIGluIHBhdGNoIDMvNw0K
Pj4+DQo+Pj4gQ29kcmluIENpdWJvdGFyaXUgKDcpOg0KPj4+ICAgIG5ldDogbWFjYjogdXNlIGRl
dmljZS1tYW5hZ2VkIGRldm1fbWRpb2J1c19hbGxvYygpDQo+Pj4gICAgZHQtYmluZGluZ3M6IG5l
dDogbWFjYjogdXNlIGFuIE1ESU8gbm9kZSBhcyBhIGNvbnRhaW5lciBmb3IgUEhZIG5vZGVzDQo+
Pj4gICAgbmV0OiBtYWNiOiBwYXJzZSBQSFkgbm9kZXMgZm91bmQgdW5kZXIgYW4gTURJTyBub2Rl
DQo+Pj4gICAgQVJNOiBkdHM6IGF0OTE6IHNhbWE1ZDI6IGFkZCBhbiBtZGlvIHN1Yi1ub2RlIHRv
IG1hY2INCj4+PiAgICBBUk06IGR0czogYXQ5MTogc2FtYTVkMzogYWRkIGFuIG1kaW8gc3ViLW5v
ZGUgdG8gbWFjYg0KPj4+ICAgIEFSTTogZHRzOiBhdDkxOiBzYW1hNWQ0OiBhZGQgYW4gbWRpbyBz
dWItbm9kZSB0byBtYWNiDQo+Pj4gICAgQVJNOiBkdHM6IGF0OTE6IHNhbTl4NjA6IGFkZCBhbiBt
ZGlvIHN1Yi1ub2RlIHRvIG1hY2INCj4+Pg0KPj4+ICAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL25ldC9tYWNiLnR4dCB8IDE1ICsrKysrKysrKysrKy0tLQ0KPj4+ICAgYXJjaC9h
cm0vYm9vdC9kdHMvYXQ5MS1zYW05eDYwZWsuZHRzICAgICAgICAgICB8ICA4ICsrKysrKy0tDQo+
Pj4gICBhcmNoL2FybS9ib290L2R0cy9hdDkxLXNhbWE1ZDI3X3NvbTEuZHRzaSAgICAgIHwgMTYg
KysrKysrKysrKy0tLS0tLQ0KPj4+ICAgYXJjaC9hcm0vYm9vdC9kdHMvYXQ5MS1zYW1hNWQyN193
bHNvbTEuZHRzaSAgICB8IDE3ICsrKysrKysrKystLS0tLS0tDQo+Pj4gICBhcmNoL2FybS9ib290
L2R0cy9hdDkxLXNhbWE1ZDJfcHRjX2VrLmR0cyAgICAgIHwgMTMgKysrKysrKystLS0tLQ0KPj4+
ICAgYXJjaC9hcm0vYm9vdC9kdHMvYXQ5MS1zYW1hNWQyX3hwbGFpbmVkLmR0cyAgICB8IDEyICsr
KysrKysrLS0tLQ0KPj4+ICAgYXJjaC9hcm0vYm9vdC9kdHMvYXQ5MS1zYW1hNWQzX3hwbGFpbmVk
LmR0cyAgICB8IDE2ICsrKysrKysrKysrKy0tLS0NCj4+PiAgIGFyY2gvYXJtL2Jvb3QvZHRzL2F0
OTEtc2FtYTVkNF94cGxhaW5lZC5kdHMgICAgfCAxMiArKysrKysrKy0tLS0NCj4+PiAgIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgICAgICAgfCAxOCArKysrKysrKysr
KystLS0tLS0NCj4+PiAgIDkgZmlsZXMgY2hhbmdlZCwgODYgaW5zZXJ0aW9ucygrKSwgNDEgZGVs
ZXRpb25zKC0pDQo+IA==
