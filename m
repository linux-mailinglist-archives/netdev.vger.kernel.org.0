Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4AC2ABF8D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731634AbgKIPSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:18:20 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO
        loutcimsva04.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730083AbgKIPST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:18:19 -0500
Received: from loutcimsva04.etn.com (loutcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27ACE7A111;
        Mon,  9 Nov 2020 10:18:18 -0500 (EST)
Received: from loutcimsva04.etn.com (loutcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 158717A113;
        Mon,  9 Nov 2020 10:18:18 -0500 (EST)
Received: from SIMTCSGWY02.napa.ad.etn.com (simtcsgwy02.napa.ad.etn.com [151.110.126.185])
        by loutcimsva04.etn.com (Postfix) with ESMTPS;
        Mon,  9 Nov 2020 10:18:18 -0500 (EST)
Received: from LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) by
 SIMTCSGWY02.napa.ad.etn.com (151.110.126.185) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Mon, 9 Nov 2020 10:16:56 -0500
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 9 Nov 2020 10:16:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 9 Nov 2020 10:16:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ges7LhultNwDLbWOnOXPAX2XqxrWkjt0fzEbHz03vryWqomnN9sCbl7SkmxgXqxQ28v5gW7d0T1KX/Y8L4E1svzjw6p7cfCm5QSd4Z6SBeeUbIolQCKeFT43rz0ZfZ0qfethRhhN+190jg93pCdp02aYmCLzQ7Pn43+SLdxG2lLhfjrLL9s40nXF2v7lC8xUz3BoYK0jg+sM+IqtC/wuL2lkSxU/l6UR24Jsnv+dnm8+v8H0OzMa60djP38MVgEeX0O4QShz8+Yt1UjwR1XQh5IOaELJ8bMOfV66+UDdHzufPEwDkJLwsdpQHD2fvadFgSMSKLB2SfWXaOpzjtDoGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0SzbJCkwLDUzQECDoe54RGjzHteBqnGotYKntkOZNY=;
 b=hSRLiccgCuRQef2aVGc7ruUJMXiMOokU9e6LI/594pHHvNLjrXTPShAD7h/4e1ujM7k0BhR9aFECEIJhxSRkTPeHilsIlsyhuG5YytlWG41HdOdGJ0C/CCfcohyNEY1vQIST3izLuyZmb3sqxl3d8GZscrKHIfqEv8LZvjBwEEdOyjgcg6cZ1qAX0ma9aB0xozhIGssSfIxq5HEUl38xB2V+6xByYatPou8mGbnFf1Y7Q9gj/G4FDR41qaD9CLpJe674sUTh746ra7fy9rWeA2hCsUppXdEV9DG1F5PXXKr4BrKbXROG6b4wwbbxDhlax/08UV7WJWbgRmOOpcwFDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0SzbJCkwLDUzQECDoe54RGjzHteBqnGotYKntkOZNY=;
 b=OK/zldWwyTDI6GF45OrW4VA6Bg+O1cSZ8Vzj2OeKtMIgksyL17KwXB5089ofvFuCzOjmj8s6EPMihJQ+af7rdspUJZAbwzZlWrepCyZXsYCMff+V+GvPy3COaxF/0V0uTk7xdzEGJFQe+PP/GLpoEsjRtZc+IWqdnbZ7BSxful8=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR17MB0919.namprd17.prod.outlook.com
 (2603:10b6:903:a2::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 15:16:54 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3541.024; Mon, 9 Nov 2020
 15:16:54 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>
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
        "broonie@kernel.org" <broonie@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [EXTERNAL] Re: [PATCH net 2/4] net:phy:smsc: expand documentation
 of clocks property
Thread-Topic: [EXTERNAL] Re: [PATCH net 2/4] net:phy:smsc: expand
 documentation of clocks property
Thread-Index: AQHWssPbx3CM/yP+ikWDaaElk2Q2C6m/8Lyg
Date:   Mon, 9 Nov 2020 15:16:53 +0000
Message-ID: <CY4PR1701MB1878442106B8B2A3F80924E5DFEA0@CY4PR1701MB1878.namprd17.prod.outlook.com>
References: <CY4PR1701MB187834A07970380742371D78DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
 <20201030191910.GA4174476@bogus>
 <CY4PR1701MB18789E4C1FE2C3FBCB1FC010DFEF0@CY4PR1701MB1878.namprd17.prod.outlook.com>
 <da87e8d5-01f9-50c2-5583-3876f9c12c8f@gmail.com>
In-Reply-To: <da87e8d5-01f9-50c2-5583-3876f9c12c8f@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e7ced34-9934-476a-aba5-08d884c27dc7
x-ms-traffictypediagnostic: CY4PR17MB0919:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR17MB09199FEEC86420AB3C5619FDDFEA0@CY4PR17MB0919.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P/bxBn2CyaEHPOJFWfzb+swU/qAc7+bG04Vd0fkO9dreJaDjRMkWsEXR1F3kq3bdD7u3TQJuOa4CGSV+yVmw//hZ/OY6U12hbZ1KrGBcQqpxLgbrzaBpmRrC33bUTsan1hfb5TXgznsSNBQGvxwKQ6Z2x9xZbBESb7yuH8XlUY7O6cXKGFtzn6YHygQdo3JGWzs4Eou+Kc++8lgdv1QU7fx2gtQvajbL1oEhuSaUy0bZkp3iaSntQ6kfsTU00Yo+3rl/wW9KLJKYGmwZjs6Zr6RaZcqnA8UjsuZ6/myWN7/Mo0XS0vJBzU4U1EAxvZpcYNzCheZy4PfncoZCP4rZew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(7696005)(110136005)(54906003)(66476007)(55016002)(2906002)(316002)(33656002)(76116006)(66946007)(7416002)(53546011)(9686003)(64756008)(66556008)(66446008)(478600001)(86362001)(4326008)(71200400001)(6506007)(8676002)(52536014)(8936002)(26005)(83380400001)(186003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ftlC6LeJwRCOE17hJJLrJxkmB3ASI3zB10jzqoLeEnGNmNNWsMxbW4Impbhf8udTTBaLqKw0WqAfxCZtHyCLBAC6Ez9pwNAtyBgNI3wbbw4qd+hVVsKXVTWatY18c6gi+RWr02Vj16I0c4X/abagqWRsZmNiis40eT0g2NMJNnge4iaGpoiQEgEr67nIw520yURXejkK4ncvON+Ryy8csN+7BDRC4JIZxeZBgzNtrBfn2c6arNOWEuin0R3QQnZVBarAbKmxh+9BEWg879T3nfLvn/71ELdqARMKQ8wcI813gLYIbxWTk9puGJ1LfwS2m65dFbcbQsUCXHO1gfZjcpNcOUgIB4/l4HZ4W3xsYOJ4gqaILj1l0qz7TxDJLOrlH/IUA4y1amvAHpqWEBarn2ce7m7FAzOo9prftB5aVe9OxhjJyylppnBsOQ7DKRVWgsGJNpvoYQgdxYa1Rx7Ls7tT93BA9MwgEuMNt07XXIkNbobq6ua9kPcw5oPng9QtbgfWatQOHnXNRqfMsc+X6rgEO+RlQ1beWRzbmTWosMilSzaJq7CtIAUkXmicmSGGQxaPudEOmMBQAjobp28cr6Ze4YTtI12GkXMGIT+9p2YtjeiVHrXRVSU7KJTKR/KrObmlqhQIMIulwIO2a9QyLg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7ced34-9934-476a-aba5-08d884c27dc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 15:16:54.0605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s1ZHLc1BLPC5tvUA18qsGoz9eqEEPIR7Q9IfTfMdX/K5mPCD7/HmUVi+C/i5PwAz309ahWUu0fylS34wxWJF3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR17MB0919
X-TM-SNTS-SMTP: 119ED4ACF03FFA543FB240B4F241D156AF4ED3EA250213BF9A22EB206AE453852002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25778.000
X-TM-AS-Result: No--15.830-10.0-31-10
X-imss-scan-details: No--15.830-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25778.000
X-TMASE-Result: 10--15.830500-10.000000
X-TMASE-MatchedRID: x6/VDf4KT3cpwNTiG5IsEom3Z+xz1tfDypNii+mQKrGqvcIF1TcLYAjJ
        M0WLRMJtsrWE1NucEUBp8kKYU14E2Wpe0b/o/MnFiVJZi91I9JgHuUxnhixmTyS30GKAkBxWXnm
        uBT+Y9/K8IpVpDCQoNeaWSKVTHxCsAioGpYo1Fp2aVoAi2I40/b+bXcGnGRJ6xMa2EwFBCBHZTA
        EszxrPVE+TZa43NqyPyIENmT3jM5vAHXRKkXCmPKo2fOuRT7aa/qWl+m17jWEqAZlo5C3Li+lWJ
        VR5maF063BZ+u8CIN2SApclwVipmOcLkvJgnAPf5Qo03mEdwAFF/jSlPtma/pm3TxN83Lo4enlv
        5xHoC216TWqSNek3wpREyjkstBDUTMhbwDPAzns37vkU5XIl4MI0YIwfYeBADO+DX+rUwfb/6ew
        CMzTAUnH2aMZl5CMIYsBzwcNv7+qDdmeMibEYB/vv+Ti5O6dRfS0Ip2eEHnxRDnybjGy+T7mr0d
        H30ACg2AyqvQSyt/fiRhduhvElsqX8y2tPBLhQfJGFKGgMparJnlDTNE4SnMZybtY2dQx6/zYoN
        4Aa9+90QaczomRckw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/DQoNCj4gDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpFYXRvbiBJbmR1c3Ry
aWVzIE1hbnVmYWN0dXJpbmcgR21iSCB+IFJlZ2lzdGVyZWQgcGxhY2Ugb2YgYnVzaW5lc3M6IFJv
dXRlIGRlIGxhIExvbmdlcmFpZSA3LCAxMTEwLCBNb3JnZXMsIFN3aXR6ZXJsYW5kIA0KDQotLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDog
V2VkbmVzZGF5LCBOb3ZlbWJlciAwNCwgMjAyMCA1OjAyIFBNDQo+IFRvOiBCYWRlbCwgTGF1cmVu
dCA8TGF1cmVudEJhZGVsQGVhdG9uLmNvbT47IFJvYiBIZXJyaW5nDQo+IDxyb2JoQGtlcm5lbC5v
cmc+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBmdWdhbmcuZHVhbkBueHAuY29tOyBhbmRy
ZXdAbHVubi5jaDsNCj4gbGdpcmR3b29kQGdtYWlsLmNvbTsgbS5mZWxzY2hAcGVuZ3V0cm9uaXgu
ZGU7IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4ga3ViYUBrZXJuZWwub3JnOyBsaW51eEBhcm1saW51
eC5vcmcudWs7IHJpY2hhcmQubGVpdG5lckBza2lkYXRhLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgUXVldHRlLCBBcm5hdWQgPEFybmF1ZFF1ZXR0ZUBFYXRvbi5jb20+Ow0KPiBwLnph
YmVsQHBlbmd1dHJvbml4LmRlOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgYnJvb25pZUBr
ZXJuZWwub3JnOw0KPiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPg0KPiBT
dWJqZWN0OiBSZTogW0VYVEVSTkFMXSBSZTogW1BBVENIIG5ldCAyLzRdIG5ldDpwaHk6c21zYzog
ZXhwYW5kDQo+IGRvY3VtZW50YXRpb24gb2YgY2xvY2tzIHByb3BlcnR5DQo+IA0KPiANCj4gDQo+
IE9uIDExLzQvMjAyMCA0OjExIEFNLCBCYWRlbCwgTGF1cmVudCB3cm90ZToNCj4gPiDvu78+DQo+
ID4NCj4gPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+IEVhdG9uIEluZHVzdHJp
ZXMgTWFudWZhY3R1cmluZyBHbWJIIH4gUmVnaXN0ZXJlZCBwbGFjZSBvZiBidXNpbmVzczoNCj4g
PiBSb3V0ZSBkZSBsYSBMb25nZXJhaWUgNywgMTExMCwgTW9yZ2VzLCBTd2l0emVybGFuZA0KPiA+
DQo+ID4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPg0KPiA+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+
DQo+ID4+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciAzMCwgMjAyMCA4OjE5IFBNDQo+ID4+IFRvOiBC
YWRlbCwgTGF1cmVudCA8TGF1cmVudEJhZGVsQGVhdG9uLmNvbT4NCj4gPj4gQ2M6IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7IGZ1Z2FuZy5kdWFuQG54cC5jb207IGFuZHJld0BsdW5uLmNoOw0KPiA+PiBs
Z2lyZHdvb2RAZ21haWwuY29tOyBtLmZlbHNjaEBwZW5ndXRyb25peC5kZTsgcm9iaCtkdEBrZXJu
ZWwub3JnOw0KPiA+PiBrdWJhQGtlcm5lbC5vcmc7IGxpbnV4QGFybWxpbnV4Lm9yZy51azsgcmlj
aGFyZC5sZWl0bmVyQHNraWRhdGEuY29tOw0KPiA+PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBR
dWV0dGUsIEFybmF1ZCA8QXJuYXVkUXVldHRlQEVhdG9uLmNvbT47DQo+ID4+IHAuemFiZWxAcGVu
Z3V0cm9uaXguZGU7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiA+PiBmLmZhaW5lbGxp
QGdtYWlsLmNvbTsgYnJvb25pZUBrZXJuZWwub3JnOyBIZWluZXIgS2FsbHdlaXQNCj4gPj4gPGhr
YWxsd2VpdDFAZ21haWwuY29tPg0KPiA+PiBTdWJqZWN0OiBbRVhURVJOQUxdIFJlOiBbUEFUQ0gg
bmV0IDIvNF0gbmV0OnBoeTpzbXNjOiBleHBhbmQNCj4gPj4gZG9jdW1lbnRhdGlvbiBvZiBjbG9j
a3MgcHJvcGVydHkNCj4gPj4NCj4gPj4gT24gVHVlLCAyNyBPY3QgMjAyMCAyMzoyNzo0MiArMDAw
MCwgQmFkZWwsIExhdXJlbnQgd3JvdGU6DQo+ID4+PiDvu79TdWJqZWN0OiBbUEFUQ0ggbmV0IDIv
NF0gbmV0OnBoeTpzbXNjOiBleHBhbmQgZG9jdW1lbnRhdGlvbiBvZg0KPiA+Pj4gY2xvY2tzIHBy
b3BlcnR5DQo+ID4+Pg0KPiA+Pj4gRGVzY3JpcHRpb246IFRoZSByZWYgY2xvY2sgaXMgbWFuYWdl
ZCBkaWZmZXJlbnRseSB3aGVuIGFkZGVkIHRvIHRoZQ0KPiA+Pj4gRFQgZW50cnkgZm9yIFNNU0Mg
UEhZLiBUaHVzLCBzcGVjaWZ5IHRoaXMgbW9yZSBjbGVhcmx5IGluIHRoZQ0KPiBkb2N1bWVudGF0
aW9uLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IExhdXJlbnQgQmFkZWwgPGxhdXJlbnRi
YWRlbEBlYXRvbi5jb20+DQo+ID4+PiAtLS0NCj4gPj4+ICBEb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbmV0L3Ntc2MtbGFuODd4eC50eHQgfCAzICsrLQ0KPiA+Pj4gIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPj4+DQo+ID4+DQo+ID4+
IEFja2VkLWJ5OiBSb2IgSGVycmluZyA8cm9iaEBrZXJuZWwub3JnPg0KPiA+DQo+ID4gVGhhbmsg
eW91IHZlcnkgbXVjaC4NCj4gPiBJJ20gZ3Vlc3NpbmcgcGVyaGFwcyBJIHNob3VsZCByZS1zZW5k
IHRoaXMgYXMgYSBzaW5nbGUgcGF0Y2ggc2luY2UNCj4gPiB0aGVyZSBhcmUgaXNzdWVzIHdpdGgg
dGhlIHBhdGNoIHNlcmllcz8NCj4gPiBJIHJlYWxpemUgbm93IHRoYXQgSSBzaG91bGQgaGF2ZSBz
cGxpdHRlZCB0aGluZ3MgZGlmZmVyZW50bHkuDQo+IA0KPiBUaGVyZSBhcmUgc2V2ZXJhbCB0aGlu
Z3Mgd2l0aCB5b3VyIHBhdGNoIHNlcmllcyB0aGF0IG1ha2UgaXQgdmVyeSBoYXJkIHRvIGJlDQo+
IGZvbGxvd2VkIG9yIHRvIGV2ZW4ga25vdyB3aGF0IGlzIHRoZSBsYXRlc3QgdmVyc2lvbiBvZiB5
b3VyIHBhdGNoIHNlcmllcy4gSWYNCj4geW91IGNhbiByZXN1Ym1pdCBldmVyeXRoaW5nIHRhcmdl
dGluZyB0aGUgJ25ldCcgdHJlZSBhbG9uZyB3aXRoIGEgY292ZXIgbGV0dGVyDQo+IGV4cGxhaW5p
bmcgdGhlIGRpZmZlcmVuY2VzIGJldHdlZW4gdjEgYW5kIHYyIHRoYXQgd291bGQgaGVscC4gUGxl
YXNlIG1ha2UNCj4gc3VyZSB0aGF0IGFsbCBvZiB5b3VyIHBhdGNoZXMgcmVmZXJlbmNlIHRoZSBj
b3ZlciBsZXR0ZXIncyBNZXNzYWdlLUlkIHdoaWNoIGlzDQo+IHRoZSBkZWZhdWx0IGlmIHlvdSB1
c2UgZ2l0IGZvcm1hdC1wYXRjaCAtLWNvdmVyLWxldHRlciAuDQo+IA0KPiBUaGFua3MNCj4gLS0N
Cj4gRmxvcmlhbg0KDQpJIHdpbGwgbWFrZSBzdXJlIHRvIGdpdmUgZGV0YWlscyBhcyB5b3Ugc3Vn
Z2VzdGVkLCBzb3JyeSBmb3IgdGhlIHRyb3VibGUgYW5kIHRoYW5rDQp5b3UgZm9yIHlvdXIgdGlt
ZSByZXZpZXdpbmcuIA0KTGF1cmVudA0K
