Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58316B36C
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 03:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfGQBcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 21:32:46 -0400
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:56964
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfGQBcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 21:32:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eu1dnk/e5mzkNn4cF2hIjJGUj/D0SapbsTNWhwLyEyr8CfAm/ytQPBdjRjuww0L1CRJXc2Jk/nTlkUONXK6dMRXjPiim4gQz4udtAjmEdZT/zsSKKuQnVWZ/OnuTtKrTS6cK1WCwxmyhzwjEDEZAMEvU96LWieAIBtaoqSQLllFpPwG3i+ElSJugWYQWgPtIv4J7uLYCqWQg772VkuxzVVL6V0XQSXYE0jAoq8z5D9UC4vHYWbh7aQzoombkWeYMvYvXgV6dhN2Iy+2WJ6aST46uulbZG1Q4t+gjzz/l2sju7VlpsZuHlLsBuPhDW/zkrwyznHn87bWwRlQE4XLiJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyByxjlNd5gF/gvMuXebC8//j6u9791TEgyavOkRB1M=;
 b=WdKwtro23ideLhrhJHx0zoF0lWXVVsjKB8xG0/t/roxakXl42ZXABEuUmt1iKJkkB9sartlBm5fsgVSVtW5bRNuVBfmYIOKaAY7r/P4+TlJJ1h7e3eSdzFLED6pp8ekOU0XRP6uvOR66WNHL+WhVgI/tCkhljfzfLXxAMMXSWb15cBAUqD6V9hI3FVjAAwqztTmo83R1VmD+XIk31yqWAxLOAQ3Zl+liyOdGYkTy7rsk0qVnW5FOIP9kYqDcUzLj/yA8QI5pqzjC9SLeEyu/iWiAQLEgwqzLYEMhKwAto6ZNfS3FIzkiVyTp4Bz1xxofOxFP+OMbu8dfniFFCy0q6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyByxjlNd5gF/gvMuXebC8//j6u9791TEgyavOkRB1M=;
 b=Q3Dcl+EIiOWNQWT4Bmce8FxA4KF+4bfFQaLRrNQvYBXvwHZQ6BYzqiO5iAc8chSWqNC5c1A7nmsv4vC23hcuezaKAZ2U9PnulQiXS1xISgAsTaXyUWKmiDqfKAE2zIllrt6/7h9dv1Zo0NE05h9CpPlUOFJdTA1k5w70JiFrM9w=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3501.eurprd04.prod.outlook.com (52.134.4.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Wed, 17 Jul 2019 01:32:33 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c539:7bdc:7eea:2a52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c539:7bdc:7eea:2a52%7]) with mapi id 15.20.2073.012; Wed, 17 Jul 2019
 01:32:33 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1] net: fec: optionally reset PHY via a
 reset-controller
Thread-Topic: [EXT] [PATCH v1] net: fec: optionally reset PHY via a
 reset-controller
Thread-Index: AQHVO1EEL3ng1jsYe0KS/0rCZTBO1KbMdjtAgADFVICAAMwi4A==
Date:   Wed, 17 Jul 2019 01:32:33 +0000
Message-ID: <VI1PR0402MB36009A9893832F89BB932E09FFC90@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20190715210512.15823-1-TheSven73@gmail.com>
 <VI1PR0402MB36009E99D7361583702B84DDFFCE0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAGngYiUb5==QSM1-oa4bSeqhGyoaTw_dWjygLo=0X60eX=wQhQ@mail.gmail.com>
In-Reply-To: <CAGngYiUb5==QSM1-oa4bSeqhGyoaTw_dWjygLo=0X60eX=wQhQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fd37790-7ec5-4345-9717-08d70a56a418
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3501;
x-ms-traffictypediagnostic: VI1PR0402MB3501:
x-microsoft-antispam-prvs: <VI1PR0402MB350195766D7616AEFABD5FB8FFC90@VI1PR0402MB3501.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(199004)(189003)(316002)(25786009)(14454004)(68736007)(54906003)(7696005)(229853002)(186003)(26005)(8936002)(4326008)(5660300002)(71200400001)(478600001)(33656002)(71190400001)(52536014)(99286004)(305945005)(76116006)(76176011)(102836004)(7736002)(86362001)(53936002)(8676002)(66476007)(64756008)(66556008)(66946007)(66446008)(1411001)(486006)(256004)(14444005)(74316002)(6246003)(9686003)(11346002)(55016002)(6116002)(4744005)(53546011)(3846002)(66066001)(446003)(6506007)(81156014)(81166006)(6436002)(2906002)(476003)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3501;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VsLkYD+LsOhhJ2sJRfXumyPIMgaKME+5wFmaQbC5laPNh2sD/jVuaXFHXMSSBa4G3hDPAE9g0+4elZHmEIc6GL6D4mo4/Fl9ej7pDChd9+vvDbDV1x0jyXHnB/vdvq5swBfoQ8N+idHC9ms4nlYaOlQDc8JF+ofDxSbqkLiGvx15MAWJESY0HqUh8WLw0yVkorPwo0FNy595pTgUXjsJAS4oqH+2woqkFMSpUVUOnZsHRwStoCl5HtoYbk3tgzN8tdYy/IYYRL/aoW2uVtgec2FDUJyN2+xcZfnz10U2qMklg8F15x94HnZ9WsxPhR650uoIa1ZyRRL54hmyCQ0vSIXHVNe7OdyEWZbn/9Ktk78Ps1IOATWPQyLv8EhrQdhwo2e+MmAHiaN35pd3PBifKPIJAHrdwArBC74+h9F+/RU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd37790-7ec5-4345-9717-08d70a56a418
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 01:32:33.2494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fugang.duan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU3ZlbiBWYW4gQXNicm9lY2sgPHRoZXN2ZW43M0BnbWFpbC5jb20+IFNlbnQ6IFR1ZXNk
YXksIEp1bHkgMTYsIDIwMTkgOToxOSBQTQ0KPiBIaSBBbmR5LA0KPiANCj4gT24gTW9uLCBKdWwg
MTUsIDIwMTkgYXQgMTA6MDIgUE0gQW5keSBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPg0KPiB3
cm90ZToNCj4gPg0KPiA+IHRoZSBwaHlsaWIgYWxyZWFkeSBjYW4gaGFuZGxlIG1paSBidXMgcmVz
ZXQgYW5kIHBoeSBkZXZpY2UgcmVzZXQNCj4gDQo+IFRoYXQncyBhIGdyZWF0IHN1Z2dlc3Rpb24s
IHRoYW5rIHlvdSAhISBJIGNvbXBsZXRlbHkgb3Zlcmxvb2tlZCB0aGF0IGNvZGUuDQo+IFdoYXQg
d2lsbCBoYXBwZW4gdG8gdGhlIGxlZ2FjeSBwaHkgcmVzZXQgY29kZSBpbiBmZWM/IEFyZSB0aGVy
ZSBtYW55IHVzZXJzDQo+IGxlZnQ/DQoNClllcywgc28gdGhlIG9sZCBsZWdhY3kgY29kZSBpcyBr
ZXB0IHRoZXJlLiBCdXQgaXQgaXMgYmV0dGVyIHRvIGNsZWFuIHVwIGFsbCBpZiANCnRoZXJlIGhh
dmUgZW5vdWdoIGJvYXJkcyB0byB2ZXJpZnkgdGhlbS4NCg==
