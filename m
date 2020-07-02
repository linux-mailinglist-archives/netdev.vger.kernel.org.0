Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C772C21278F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgGBPQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:16:07 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:21408 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbgGBPQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:16:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593702965; x=1625238965;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=G2KdACUDMhPF1LJv5L05QRy/SK6eT4rBO1AipV2v3mY=;
  b=byMv0DM0zRZ9JaK70mYA6h8BfOV2VDCHmi3LuhSn6bEJ8GgaOpj+M+mF
   yYHnfXVnXS3qlZu59rwlOru53T5zLB7BJmaIDiR/A0o6ooyIPC/R7l12e
   4X1ruAm9oPRzksCvoN8FzUl6vHfVua8M5aOkaPWf6Ynavc7eP4OpwUa0a
   vbzXwpUTveyNPGnaMMSD+O9S9gN37wJ6zD+7jlWc69J4mg3PbYS9eyHrB
   Bc7IwpN6e5+ro/jhSvOrGiL7wF6NuxXcvYujFCVO0Y4Ksug6jeJhFEepG
   Ao6pZVDhOfc6sgJLbro2q67ZlvvJdIBIDUj4MXcNtl7rL7iS3iWkBB3RB
   g==;
IronPort-SDR: vUILuTksfALcDOgXpQ6RXedJGV9t+pXTEn4GyFx3soNPB3B7enO9VoQ3r0u+Pq1Giv+tLNDc+8
 pp3/aQb5pEz8Nmr6eOKylfNKuEMIMUYi/RL9wAUw1FJnxfrrXGEwDBJ9S9pe9sO4AVE3b5YFZb
 wpihv9tvQPrMT2a/FWBipZNRtV9PIuRB9K/2GUU0wQCHT/MgvganZvA+iE7rO160ThoXNOLiTO
 sc7siPjIusqS/rkqDUlbCSxypub4bcSYYQcsjsVZLxpKjCHJ3Q9i7xYVBelwO+oWBpvuJwTzUH
 fPc=
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="81675372"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 08:16:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 08:16:04 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 2 Jul 2020 08:16:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8z27JHE7lRDio9thZ/i8C2IIofOFqwsvtYLF9jZXC6lRcwiLvgDiB0HxyGlpxiOL+POnMfp3VQqqC22Kz5UhfAUGU0o19RyWlk5MUf6lgys5Pqm7KLCf+axqaMCclET0T7BXMTnsM5Uzh8kupKSm0rRZ5koaFObs4gCnVw5I6FUlfmhR/Y1tqK6oB/PBXsJ6sgaEwYN/uSMZ+N1ZyCntnLIQKsSF+HGbxXo70I3kXP0R+SgrH0Q6MiwS215Pu2a0VlYaqpfdrFO+shnkV/I0nWQ+419Q80pbQdZMJY2nGE3/ECpT8Xs2B5o/oV/fcmGLJ5rtTuETKoYyhRNmB2cBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2KdACUDMhPF1LJv5L05QRy/SK6eT4rBO1AipV2v3mY=;
 b=JzlApOUc9Vc2my4Y8B0bfhXsExpLcdXpFfh7maqMNif9kfqnqhjYDaSXfX6///Ug3sfPWe8XE/8dXsQ1FFnfpiB1tkEx1f5L3ON7GYDMSM3ucZcpqJwFNjdEe7gBGpp6nVoyGnpNmHTfS4ST988UvK9wh5b7anpr9sU1E2UsDfEBhDPPCOZT62dt9ZeYvyAwJ+YisJ1cqGNAyCRWUnbx2F8z8jT/iwrESkCB9kvRXH3iHzh7DmEI7GAM8cfp1LNfFxUfYyfR+oQR/oVwKFqr3SZcL7dLpdI8zjXBa7we+wWH2g+85zJIq5XeWm/xdFTV7L8Gjbl8VNarlohSjnYpWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2KdACUDMhPF1LJv5L05QRy/SK6eT4rBO1AipV2v3mY=;
 b=ZE5mvDxIEpWNzz9RWqGnVCj3no4kYAO4tu8nqta637nGh/dIxIcKwlx4/154UrlBoIS/9aIfYoazo5pwzAu68raZNbGKoXnIM+j6h+6da7fZFXvhnlomMh7S4p1vxg6K3bYogS1rUX7lQXE6w50CiK6DWiTW7OpJwtwck4OpwiY=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SN6PR11MB3360.namprd11.prod.outlook.com (2603:10b6:805:c8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Thu, 2 Jul
 2020 15:16:01 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3153.022; Thu, 2 Jul 2020
 15:16:01 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: Re: [PATCH net] net: dsa: microchip: set the correct number of ports
Thread-Topic: [PATCH net] net: dsa: microchip: set the correct number of ports
Thread-Index: AQHWUFWHd0WP8soSeEyltHncN8aSFqj0TsMAgAAX7oA=
Date:   Thu, 2 Jul 2020 15:16:01 +0000
Message-ID: <1133ac51-bdda-1005-8afd-75dd1d53cea8@microchip.com>
References: <20200702094450.1353917-1-codrin.ciubotariu@microchip.com>
 <20200702135016.GL730739@lunn.ch>
In-Reply-To: <20200702135016.GL730739@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fab9b9c8-ee96-48af-d63c-08d81e9ad482
x-ms-traffictypediagnostic: SN6PR11MB3360:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB33605E75E58269058511FB20E76D0@SN6PR11MB3360.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0452022BE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LM35HERpYc9pXStsOppo5gY/WeCSH3GOKM1DR/0vA7ipZ8NWZG2gZfTQ7PydAYl34CjVk7uW021xXKTSf6IJpenXsDzZT8PG5Kjpvjj1jZUSrRHL6eKBJQO+QHumskxfzm8vNI/V5+MPqMBhSoyGGvzlJXNgDhGn14Tv5fXkXso76lou40HELghUQpREHkaAI26Y0b1RPANasQociSm1v23RiefJ1gZQSElVX4OFCwMKNdG8aBNZVb1VOi+x8CQxyaa4kBhDczgBwL408ZVYPHwueffKlseV9gNM1zwuqnGy2iFCI4Ceyz57NQZ53V2e5IUW1SFoCQ0guapnfAQQL0AWBw8UOaJP4wU84KZZ50gw55spinTtF0xT1ICGmz9Q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(346002)(376002)(396003)(39860400002)(2616005)(316002)(66556008)(5660300002)(91956017)(66946007)(31686004)(76116006)(6486002)(36756003)(6512007)(6916009)(66446008)(478600001)(26005)(64756008)(66476007)(53546011)(2906002)(8676002)(186003)(8936002)(54906003)(86362001)(6506007)(71200400001)(31696002)(4326008)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YM7eHLC3rnKhst5ELaG0i+/TD/nG7bLD2LCUgA04zJKf27LEsL9ESwarNtwlMQP9Ybs5dIE+SSrK21V5vWi6w4sGcorqr2Pw4JSen/NKEC28onSw/+Lm8ocUGtI6FeqIcPQ7v8t8ZRDiA9+meITAUn+T2xpE5+JCQBbHD/PrOFXoQXkXaroyrncSlnZyvkP/xLF9JD16CFcsLjQow5lf9WmXWVkgnLgc3CwhxI0aT+KiE5/ZdrILBnFZBT3j2oKhWW941lT73ZVuBaVMgl/LTXm9n1vgO/ygBGlovM4GSsaLBm0LBOBlygmvaK58JFmaxTAIcLrVHU5q4Sh3FYPVht6bX+NrvNPgM2DfjsbL8W4kZqX/Eq4KtY9C2BPrICnMAMqNXzFH4KEHGGeokzS+3qol9BXw/ZQqI5mXyV830+8SF1Ld1RvvC/Ylb1gI2XrnzA/RcRevdxUzGVtti/snXyit41wkU/z3IWcAKTcjP+4t4FQ89PJQ/fegg6wzYE2y
Content-Type: text/plain; charset="utf-8"
Content-ID: <93FE24067A731D4D884E8171B151E677@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fab9b9c8-ee96-48af-d63c-08d81e9ad482
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2020 15:16:01.0647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P24uihujzVmkzlB08swbnszDZNdQ4m82N6SDuaUy2fgrJ+dCOoJLTQHRbCnh+zqbs3M5KRtlm91Mq6slBcaidtLXRiMZYfnDOdr1ntWV8Uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3360
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDIuMDcuMjAyMCAxNjo1MCwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVGh1LCBKdWwgMDIsIDIwMjAgYXQgMTI6NDQ6
NTBQTSArMDMwMCwgQ29kcmluIENpdWJvdGFyaXUgd3JvdGU6DQo+PiBUaGUgbnVtYmVyIG9mIHBv
cnRzIGlzIGluY29ycmVjdGx5IHNldCB0byB0aGUgbWF4aW11bSBhdmFpbGFibGUgZm9yIGEgRFNB
DQo+PiBzd2l0Y2guIEV2ZW4gaWYgdGhlIGV4dHJhIHBvcnRzIGFyZSBub3QgdXNlZCwgdGhpcyBj
YXVzZXMgc29tZSBmdW5jdGlvbnMNCj4+IHRvIGJlIGNhbGxlZCBsYXRlciwgbGlrZSBwb3J0X2Rp
c2FibGUoKSBhbmQgcG9ydF9zdHBfc3RhdGVfc2V0KCkuIElmIHRoZQ0KPj4gZHJpdmVyIGRvZXNu
J3QgY2hlY2sgdGhlIHBvcnQgaW5kZXgsIGl0IHdpbGwgZW5kIHVwIG1vZGlmeWluZyB1bmtub3du
DQo+PiByZWdpc3RlcnMuDQo+Pg0KPj4gRml4ZXM6IGI5ODdlOThlNTBhYiAoImRzYTogYWRkIERT
QSBzd2l0Y2ggZHJpdmVyIGZvciBNaWNyb2NoaXAgS1NaOTQ3NyIpDQo+PiBTaWduZWQtb2ZmLWJ5
OiBDb2RyaW4gQ2l1Ym90YXJpdSA8Y29kcmluLmNpdWJvdGFyaXVAbWljcm9jaGlwLmNvbT4NCj4g
DQo+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+IA0KPiBUaGFu
a3MgZm9yIHRoZSBtaW5pbXVtIHBhdGNoLg0KPiANCj4gSWYgeW91IHdhaXQgYWJvdXQgYSB3ZWVr
LCBuZXQgd2lsbCBnZXQgbWVyZ2VkIGludG8gbmV0LW5leHQuIFlvdSBjYW4NCj4gdGhlbiBzdWJt
aXQgYSByZWZhY3RvcmluZyBwYXRjaCBiYXNlZCBvbiB5b3VyIHByZXZpb3VzIHZlcnNpb24uDQo+
IA0KPiAgICAgIEFuZHJldw0KPiANCg0KDQpTdXJlIHRoaW5nLiBUaGlzIHNtYWxsIHZlcnNpb24g
ZG9lcyB0aGUgam9iLCBzbyBJIHdpbGwgc2VlIGFib3V0IHRoZSANCnJlZmFjdG9yaW5nLCBtYXli
ZSBJIHdpbGwgZ3JvdXAgaXQgd2l0aCBzb21ldGhpbmcgZWxzZS4uLg0KDQpUaGFuayB5b3UgZm9y
IHlvdXIgcmV2aWV3IQ0KDQpCZXN0IHJlZ2FyZHMsDQpDb2RyaW4NCg==
