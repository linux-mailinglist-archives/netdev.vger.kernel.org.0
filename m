Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BF31BF3A9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 11:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgD3JDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 05:03:02 -0400
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO loutcimsva03.etn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgD3JDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 05:03:01 -0400
Received: from loutcimsva03.etn.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 932128C094;
        Thu, 30 Apr 2020 05:02:59 -0400 (EDT)
Received: from loutcimsva03.etn.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82DCE8C0CA;
        Thu, 30 Apr 2020 05:02:59 -0400 (EDT)
Received: from LOUTCSGWY01.napa.ad.etn.com (loutcsgwy01.napa.ad.etn.com [151.110.126.83])
        by loutcimsva03.etn.com (Postfix) with ESMTPS;
        Thu, 30 Apr 2020 05:02:59 -0400 (EDT)
Received: from LOUTCSHUB01.napa.ad.etn.com (151.110.40.74) by
 LOUTCSGWY01.napa.ad.etn.com (151.110.126.83) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Thu, 30 Apr 2020 05:02:59 -0400
Received: from USLTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.152) by
 LOUTCSHUB01.napa.ad.etn.com (151.110.40.74) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Thu, 30 Apr 2020 05:02:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by hybridmail.eaton.com (151.110.240.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Thu, 30 Apr 2020 05:02:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sr9zGD922DW5hTSXxLFrCY+ZcjFXr0c3bMEecC0ODSGrME7j6oHE9QuOt5ChxuGY6zwo9iGfckLjwo/jm37q0wVQJAGXuZspexI9Jk17RPIKE4RhiPuIQ4w5uTp/t+ayN9BicWuLpJo3dlwCk4wMfyl6qpy8DewNy5Lw+usvt5t7a3QDbNConG2H32lkEhJhbTY5x2XWlyHmAxZNmv4T4Q16yKA1d8C0wZxSA8b5+Zmlo8+sTkg+y4U23bRTfAAHvrEdUdBJhs26oPMSNt1qZVW1EzGNx5OyxU5MBuUlq/VbCYKvjTmUGtW20PtHsaD0VqMcmFFzpQW7kn+Mwwcdrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiogsYd0iOWOkRuF1OAdJnvdw3v9MBYDyePrDeLquM4=;
 b=PZHYkaDAT/sO/w1Lk3h4jtg/ErTc2PyjYWjoc5t50jOSaOB0nGjAggcaFQPHRa8Juf0TIIbTlLhAl4CapFdeFwLupf8TnykQxIxHPrhBt0gN2dAoJBKfNfL3xi9T1KzMGIyXrN0cIB0gfH02e1gLtuVSoYLV23WQsFx0oTEIsdwsc6kVESd7SXYxABeTGgBbXCTAxLITtaI3LJm0L80cmUxmZvgSxCeZQzyqCxdynZU2k9lDHgekIXENawI+k+eKFYHHeMb9o8kIFSFct5yKICylxgm66M3LnhvnQWjYQLK8GZdw0WweAJI+Jlzrfnl4af9W92GocrvXo60GDVLzKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiogsYd0iOWOkRuF1OAdJnvdw3v9MBYDyePrDeLquM4=;
 b=1YK1B1w6EqPu1a5Xsqd259lo3dqcMcUx+mPMO5zzFMbAPjjjJ7B0ZR1Xqb4hnpe+KORkmus8tDIA2+wLCsX+mgKiFAGmTb93DhoT5bQOW9NQSmqx+d0lk9yy6uThbs65Pi7THZjshHAzr6twR5TLMw229w4mCJa7qjp20g7/moE=
Received: from CH2PR17MB3542.namprd17.prod.outlook.com (2603:10b6:610:40::24)
 by CH2PR17MB3526.namprd17.prod.outlook.com (2603:10b6:610:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 09:02:57 +0000
Received: from CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c]) by CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c%5]) with mapi id 15.20.2937.023; Thu, 30 Apr 2020
 09:02:57 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: RE: [EXTERNAL]  Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Thread-Topic: [EXTERNAL]  Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Thread-Index: AdYeHY7rY3M9YncCRBykPeyQlUA9mwAHNUqAAAC9YgAAAbMgAAAievJA
Date:   Thu, 30 Apr 2020 09:02:56 +0000
Message-ID: <CH2PR17MB3542811DCB397E385E0E8884DFAA0@CH2PR17MB3542.namprd17.prod.outlook.com>
References: <CH2PR17MB3542DCD8D9825EE6B88BC5FCDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
 <20200429152519.GB66424@lunn.ch>
 <CH2PR17MB35423A4698E4068CDE3E18A6DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
 <20200429163510.GD66424@lunn.ch>
In-Reply-To: <20200429163510.GD66424@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [178.39.126.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1ee3334-4be0-46c7-1221-08d7ece54681
x-ms-traffictypediagnostic: CH2PR17MB3526:
x-ld-processed: d6525c95-b906-431a-b926-e9b51ba43cc4,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR17MB3526C6107FFF7DE5DE87FD7FDFAA0@CH2PR17MB3526.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R4vn0xmlwyacmbd+Q+Q7lQrdm4/mJk7QKKQsk7ChWJREmqzUEngqSqPEQw9xScy9JTLMgWb+DWmhjYgCVpu/2dpqqwusI3eTDkHputDbBsvehIMlm2aQYBtbfYwjZ3hwJqbTZG0pdHifzZziLDlohBuFZa/TaADGnCAoI7+qsQjNZk9MoEOJdogHFuywjNcBb+ZmAyhSs6pM59WCvUFcIo+qTz4C2kqxGZHZGICHbPT9d0P6QCDMyjy+XoVap8tIumVVjfoG6GzbE5adp/7/WYCrEklcFB3nUS/AQ0FiHkImbDrV1pOZS5qKykIqeJznnxKDWfyN75AJ5+xTGbAEw19BR3S/ShYUul4Z344ZaxGLJTMiHgyRhvSIwbCNDb7hblRrQ1aVMKXE83UxP2T46C5Wb37zvNQv73Nnli3GiAeWB4klvNG5FwdcP8+1UJ7x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3542.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(396003)(136003)(376002)(52536014)(316002)(66476007)(66946007)(76116006)(66556008)(64756008)(54906003)(66446008)(5660300002)(2906002)(107886003)(55016002)(9686003)(86362001)(33656002)(8676002)(8936002)(4326008)(53546011)(478600001)(26005)(45080400002)(7696005)(6506007)(186003)(7416002)(71200400001)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FKU10XWW+EORxU6bFZG9d7rSA3B7kW0y6d/Zg+YFtaxslI/vrNNtBL5ucqDZtjM4jkPWi1gGYCSgoDjKcgBtZ2r7vZTTCXKIpU31YiWsym/DS8Mrxj2Mc+1hwoN9ik/jwu3eF5YFuV3KYdT3WuaBN/Q+bOjDyXcOe4Hdx8w19B/G2r7Nq6rL4Pn3B8P9vQO/rPoHtmhvzgEHARBhVdsY4zTxVZ0exNtSFfNtFNBhFEXU4DomzMQa+nZNfccSZMdEuq0JXSemQByBOiioqF6ojkjx/XeKl2d9lCrGcsLNviYsy5XJJqBTB4HIPQNVOFr5acZAepggIW1MCa5M2g2mvbqVmUculEtAibqkC9dEJC+fksA/73df/hpzmFJv4hIN8BhNI2sGwC36+uTMEv2dtEwWD6BT1QSVylowy+4nFWvmcgbBXIDChJgphcuukVw0OjgWlfC5mzfyuo9K+K63lMoq2INMfE43OzEFP3kER8cTgK9CYTz4bQePS6RwYhKgxUQlpnhomVSxPmC4GGqReT7Db3Mf7mjMUEdVPYkdcw4YCj1ers/AsE7YQVl4FYBO8wDWc42T3vnmkWS0UvbW5ojWoblFhkfLBVHTYgD+u8+d7GrgvwGf7Y+L2v9Jpq3IwUQgpn5UJw2fU7xLZ37vvCtGR+Lir1khH6tcyXDAM412mk9W/jeatZpgkH6ZjBoTC1eRq0n8QgcyyU8SSzfffHT4vB2N7FnFHcktjnpS8BY4p2I0ipC2n0fheYFmDCqdbZvcWkz0ViAwIlTCJp8tTkvWAyRDjF13cl93nJ+ckO8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ee3334-4be0-46c7-1221-08d7ece54681
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 09:02:56.8885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LPW6GcuEEh3IiHfcK3TMvvV7i5c40IoMz61MKA4QPjHizHDkg9YBCTZSObkdl/OQUkFMQKheYnaeaSk96Adc1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR17MB3526
X-TM-SNTS-SMTP: EB194BDAED4828951F18EB22880A355A323808EEDC6CC0C5BB3060A3D24318B62002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.5.0.1020-25386.005
X-TM-AS-Result: No--20.131-10.0-31-10
X-imss-scan-details: No--20.131-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.5.1020-25386.005
X-TMASE-Result: 10--20.131400-10.000000
X-TMASE-MatchedRID: G7I3j5/20vUpwNTiG5IsEldOi7IJyXyI8SHVXrj1HSihEEjLknSXwJtl
        oA0oorgBNYAS4TydAxKSqdj9Ion/h648GVQyXAyfHQ3LRa+7KRxR3sGN+j7mNEeuAuWa2CY0fjc
        dX7WMS/AGMzY8ANBqvG9oSOZRLbyNqw5Zwx1QoJf2b09s2KGDsH4yToAKzDgmSFyaPnhpvhR6oh
        uAoQsbwk4K15kIUY+JK9OAyVrK7cI3J8S54w0mBdh5cGtwmAvk4cLBHAw1BRZQKAQSutQYXHAja
        /i+SuWwekS8nXe5AIJ5OPD8XJFfpEL9tcyTZdAs7ni+GTUS+xHEQdG7H66TyKsQd9qPXhnJVWgR
        crSEFLc=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/VGhhbmsgeW91IEFuZHJldywgDQpJIHdpbGwgZG8gdGhhdC4gU29ycnkgZm9yIHRoZSB0cm91
YmxlLg0KQmVzdCByZWdhcmRzLA0KTGF1cmVudA0KDQo+IA0KDQotLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KRWF0b24gSW5kdXN0cmllcyBNYW51ZmFjdHVyaW5nIEdtYkggfiBSZWdpc3Rl
cmVkIHBsYWNlIG9mIGJ1c2luZXNzOiBSb3V0ZSBkZSBsYSBMb25nZXJhaWUgNywgMTExMCwgTW9y
Z2VzLCBTd2l0emVybGFuZCANCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCg0KLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5u
LmNoPg0KPiBTZW50OiBXZWRuZXNkYXksIEFwcmlsIDI5LCAyMDIwIDY6MzUgUE0NCj4gVG86IEJh
ZGVsLCBMYXVyZW50IDxMYXVyZW50QmFkZWxAZWF0b24uY29tPg0KPiBDYzogZ3JlZ2toQGxpbnV4
Zm91bmRhdGlvbi5vcmc7IGZ1Z2FuZy5kdWFuQG54cC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc7IGYuZmFpbmVsbGlAZ21haWwuY29tOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsNCj4gbGlu
dXhAYXJtbGludXgub3JnLnVrOyByaWNoYXJkLmxlaXRuZXJAc2tpZGF0YS5jb207DQo+IGRhdmVt
QGRhdmVtbG9mdC5uZXQ7IGFsZXhhbmRlci5sZXZpbkBtaWNyb3NvZnQuY29tOyBRdWV0dGUsIEFy
bmF1ZA0KPiA8QXJuYXVkUXVldHRlQEVhdG9uLmNvbT4NCj4gU3ViamVjdDogUmU6IFtFWFRFUk5B
TF0gUmU6IFtQQVRDSCAxLzJdIFJldmVydCBjb21taXQNCj4gMWIwYTgzYWMwNGUzODNlM2JlZDIx
MzMyOTYyYjkwNzEwZmNmMjgyOA0KPiANCj4gT24gV2VkLCBBcHIgMjksIDIwMjAgYXQgMDM6NDg6
NTZQTSArMDAwMCwgQmFkZWwsIExhdXJlbnQgd3JvdGU6DQo+ID4g77u/SGkgQW5kcmV3LA0KPiA+
DQo+ID4gVGhhbmtzIGZvciB0aGUgcmVwbHkuIEl0J3MgdGhlIG1haW5saW5lIHRyZWUsIHdhcyA1
LjYuLXJjNyBhdCB0aGUgdGltZS4NCj4gPiBUaGVyZSdzIG5vIHRyZWUgbWVudGlvbmVkIGZvciB0
aGUgZXRoZXJuZXQgUEhZIGxpYnJhcnkgaW4gdGhlDQo+ID4gbWFpbnRhaW5lcnMgZmlsZXMsIGJ1
dCBhbSBJIGV4cGVjdGVkIHRvIHRlc3QgYWdhaW5zdCBuZXQvIG9yIG5ldC1uZXh0LyA/DQo+ID4g
SSdtIGhhcHB5IHRvIGRvIHNvIGJ1dCBzaG91bGQgSSB1c2UgcmF0aGVyIHVzZSBuZXQvIHNpbmNl
IHRoaXMgaXMgbW9yZSBvZiBhDQo+IGJ1Z2ZpeD8NCj4gDQo+IFRoZSBuZXRkZXYgRkFRIHRhbGtz
IGFib3V0IHRoaXMuIFlvdSBuZWVkIHRvIHN1Ym1pdCBhZ2FpbnN0IG5ldCwgdG8gRGF2aWQNCj4g
TWlsbGVyLg0KPiANCj4gCUFuZHJldw0K
