Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F452930C2
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgJSVss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:48:48 -0400
Received: from mail-eopbgr660057.outbound.protection.outlook.com ([40.107.66.57]:57120
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727317AbgJSVsr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:48:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkaA2/g7yKxBY21AUiWHXuAPW5gCnicRb/wFE252ieQu1Qn8/EaF36femWt4ou3LERlL6ryrvmY64Z0moUMUfqJ3pjWmDSimTLqBWkwN+IlJ42mZiGODkxVnWuci4cHWzE48LWsjNYUf78xsbXZCukkv9XUZQ5pOozSE+h151MWhd7QL1DMMU/uhQA6wXdn/fz8xbb68wcqRwXkKWyQdJgnfXG7g0C7mheM+0XumnoPzupugJjecOsuUsbxiO9ND91dQKlN1Uz08ZY8LhEPzaPagYrGtrbZvI9vwzn/lnATiIbN/5QwxWOUva5/zPHF8YUorcV+JZbRIazUOGBOv8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJejZUgI4b9tskWN9RNoXI0dnjxq7hJPPhC3BxqEDLA=;
 b=E1daSEzN61+ML0tZoMUV44O19Y1berPT0Q3oJV4h1taB4tiUHUtxzqQC/WFrWOx2ZS8HKGUWhMd+1Kl7scGDI+EYwltJFctzF6/NW4W0ol/+NWycuu2PF+uoy0NdvIIrBFbE/YX00NCvYQevWH+HXTiomgwhyjegLP6UVYkhx+/UtTC7KNS74HlCcMWO4RJ+61rVdCj1XuxJyTID1FGPpkk+fGcQX9CK1NRDwGQVgoZfxZFEa+CV1jlV16kc5/CDU99QWsAK4aiTrhUo/aEj6CZmhhEFk2UR9bgRtDR1BON377bubgZ9VZHaNJ0IGCf/oN0qXFkD/9XRS7QPbavxYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJejZUgI4b9tskWN9RNoXI0dnjxq7hJPPhC3BxqEDLA=;
 b=hntj125JBaSgxCxw0+okEIoUNXJDjVstBkh4/56Y3mIDPbIQHWhgaUofe1r+ezXoMevCGYjOCEeHsvi0/KHBH0T+L/ThIZXBP14aTzIUfoZQhheUMmMeg0rBzDb6i8W/Ls9Zj0j0dphT67fw4ZN3h+PA9Tzt2phYfIxi6n6lCaU=
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTOPR0101MB1435.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Mon, 19 Oct
 2020 21:48:43 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 21:48:43 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH] net: axienet: Properly handle PCS/PMA PHY for 1000BaseX
 mode
Thread-Topic: [PATCH] net: axienet: Properly handle PCS/PMA PHY for 1000BaseX
 mode
Thread-Index: AQHWplf8dBlhJmBF50exgeWB7ZNFGamfcykAgAADYYA=
Date:   Mon, 19 Oct 2020 21:48:43 +0000
Message-ID: <c989910aee122cfa9d29994d9ce650ce486442ca.camel@calian.com>
References: <20201019203923.467065-1-robert.hancock@calian.com>
         <20201019213638.GW139700@lunn.ch>
In-Reply-To: <20201019213638.GW139700@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-12.el8) 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51160567-8391-42ed-6adb-08d87478bff5
x-ms-traffictypediagnostic: YTOPR0101MB1435:
x-microsoft-antispam-prvs: <YTOPR0101MB14354F7428831DB9DCF9881AEC1E0@YTOPR0101MB1435.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J844ddvWVh4leCN19zjcVwx4VzfMqJd3isPepQB3GrgmPmhwFHMd3ORLcPJ8KL4Qu+Ou8Imma3PqZCI2Z7SkgAp2rnSEV0DwU1cXL+k7MtggtTRjg/L6TKgOqOCjDHkGMctVy4vC7Zw2ZkYXdG6Hyftamzr8kx4AghR+XQd4m0IBHP2qr1QDT8HJhL836QPC1nKlSTViUt203fTZ2IUYLblnHrz5xQ8ROOXfjsbh98fctTJTX0Zv0NRhVtiuSbyePtgtLXAc9SKXDTMy/OuEBvV1KiWpo8gKbi+AcihnNa2Mm4jPgH59mYT5n1vIUHqiJCPhJlyJLKGPH2+UzWtDUAM25cZboS8s5I7cJGKsaGjemgY4ewDD9CqLYAfQ+doPPswT7XiibRr1oiRYM8XkHxe8tsW62580tT4bg25RbbL9BXK3XUICrOavbVbX3C9csWPc2SjajRh9BWEuqQRncVnuToBqbktoo5ys1Am60XE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(396003)(376002)(366004)(6506007)(2616005)(26005)(186003)(478600001)(8936002)(8676002)(83380400001)(2906002)(66556008)(66446008)(5660300002)(76116006)(316002)(64756008)(86362001)(6916009)(66946007)(91956017)(66476007)(36756003)(4001150100001)(71200400001)(6486002)(54906003)(15974865002)(4326008)(6512007)(44832011)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 67yg4PAEiyVNdWXvTOLQL55SFAiYb8m2FXGy8a2L3GYmVl82pKD4HV9ielAposhhwfpjL8TNlMhFvntIOPOcWT2UvKqVlLNkTsO0Xp5FQSkQJA8Cdacz03ED7ZnJ9Js62ZKZcmYtgBHjeJAbB6TS/MeLacw6v6JfcBC0PlkCnmI/oUfcNdLkSPgO1KiVsucMyXEJuWizrtjewy1tcXrUZEQ5cTomiHt/PP9rDfDYCdS0F50hzPrZR7GD9i8FWpZB1sCSZ4KZjlI80qBaq4UIRhYNAnQkTRVuuQj03s+7557Et7l0Egdr9SCfX5jesl/1/eYwqTAhFTQf/hABGxq9MUxg3w7yNg55maneVxQhq4oWVYo65dmC9EaC/+G8IcM8x24PVmFOxZpdQYM4Vl2y/BzvDUuZH3pQWzQqekrlet5XG7OjIQ5orYc6JoFY2tjl2syQaqq5Wjc+18MJ0Lc4MyvIdQTWCsiZXMYenLrqihTWQ5lUXE2HVPnxsWoBxBNUmk2gNpnky+MpfHpEo/YfNX9Xz9hmAPxjKuT2A1VVCJFHhYPZkWIt5Zho/NWjrJ47WuJVx3LHImVZ3IXX4evs3IaVErySTsdXl6BVTPm69kUk7hoYwLtjiUvLurTuKccRQwJ656BbvndC4hNH0Ml25g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A385FB55D87746468B2FF2B52C909699@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 51160567-8391-42ed-6adb-08d87478bff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 21:48:43.7495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L6fpveU+CmvLhm/13P9eMeGPkGuknFDNMh/FC3tJD29CzVA+/GXDqaaPduBY2EPUV4Fm8Lq5tCuuwgknCK16cv3jqwSWBedZnWm0PB9pGBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB1435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTE5IGF0IDIzOjM2ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiAgc3RhdGljIHZvaWQgYXhpZW5ldF9tYWNfY29uZmlnKHN0cnVjdCBwaHlsaW5rX2NvbmZpZyAq
Y29uZmlnLA0KPiA+IHVuc2lnbmVkIGludCBtb2RlLA0KPiA+ICAJCQkgICAgICAgY29uc3Qgc3Ry
dWN0IHBoeWxpbmtfbGlua19zdGF0ZSAqc3RhdGUpDQo+ID4gIHsNCj4gPiAtCS8qIG5vdGhpbmcg
bWVhbmluZ2Z1bCB0byBkbyAqLw0KPiA+ICsJc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYgPSB0b19u
ZXRfZGV2KGNvbmZpZy0+ZGV2KTsNCj4gPiArCXN0cnVjdCBheGllbmV0X2xvY2FsICpscCA9IG5l
dGRldl9wcml2KG5kZXYpOw0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwlzd2l0Y2ggKHN0
YXRlLT5pbnRlcmZhY2UpIHsNCj4gPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX1NHTUlJOg0K
PiA+ICsJY2FzZSBQSFlfSU5URVJGQUNFX01PREVfMTAwMEJBU0VYOg0KPiA+ICsJCXJldCA9IHBo
eWxpbmtfbWlpX2MyMl9wY3NfY29uZmlnKGxwLT5wY3NfcGh5LCBtb2RlLA0KPiA+ICsJCQkJCQkg
c3RhdGUtPmludGVyZmFjZSwNCj4gPiArCQkJCQkJIHN0YXRlLT5hZHZlcnRpc2luZyk7DQo+ID4g
KwkJaWYgKHJldCA8IDApDQo+ID4gKwkJCW5ldGRldl93YXJuKG5kZXYsICJGYWlsZWQgdG8gY29u
ZmlndXJlIFBDUzoNCj4gPiAlZFxuIiwNCj4gPiArCQkJCSAgICByZXQpOw0KPiA+ICsNCj4gPiAr
CQkvKiBFbnN1cmUgaXNvbGF0ZSBiaXQgaXMgY2xlYXJlZCAqLw0KPiA+ICsJCXJldCA9IG1kaW9i
dXNfbW9kaWZ5KGxwLT5wY3NfcGh5LT5idXMsIGxwLT5wY3NfcGh5LQ0KPiA+ID5hZGRyLA0KPiA+
ICsJCQkJICAgICBNSUlfQk1DUiwgQk1DUl9JU09MQVRFLCAwKTsNCj4gDQo+IEhpIFJvYmVydA0K
PiANCj4gVGhhdCBsb29rcyBsaWtlIGEgbGF5ZXJpbmcgdmlvbGF0aW9uLiBNYXliZSBtb3ZlIHRo
aXMgaW50bw0KPiBwaHlsaW5rX21paV9jMjJfcGNzX2NvbmZpZygpLCBpdCBpcyBhY2Nlc3Npbmcg
TUlJX0JNQ1IgYW55d2F5Lg0KDQpDb3VsZCBkbyAtIGRvIHdlIHRoaW5rIHRoZXJlJ3MgYW55IGhh
cm0gaW4ganVzdCBkaXNhYmxpbmcgQk1DUl9JU09MQVRFDQppbiBhbGwgY2FzZXMgaW4gdGhhdCBm
dW5jdGlvbj8NCg0KLS0gDQpSb2JlcnQgSGFuY29jaw0KU2VuaW9yIEhhcmR3YXJlIERlc2lnbmVy
LCBBZHZhbmNlZCBUZWNobm9sb2dpZXMgDQp3d3cuY2FsaWFuLmNvbQ0K
