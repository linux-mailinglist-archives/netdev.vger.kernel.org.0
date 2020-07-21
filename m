Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD6322812C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGUNmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:42:03 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:41497 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGUNmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595338921; x=1626874921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XCIemFwHVUPk9JG5bOXVOGvcvPDUygaTIGU9mXoRy0Y=;
  b=AjdHFjHammRZn5qBIvthl2OTyPz8x8aXgpsFqgQhTeHzoE5s5WGwzfvH
   88w2FJs09lUlNCfACm50AVBi/BC+nw+xaNFqKjxk8q3c1eY/eHDCHhFxz
   n51kPg4O+kx2WTOUHO4byqcDt2S4VVCVhdZi2wjGMSf9vg0nNYuMSA7iy
   Orxe2ozJE9pj8r+I5ghTKHxYf+psqn/Li/5kphi3GADx3ct6OsHqEFTZq
   o7XzRE/PzkZCAvRmk0omcDIOIyMOvW2iQQdAjzZ/IY75kUM6FrvHUOqjh
   7BAEdPM/CBU9BOFSj9KgOEC0QyIgzEujWvd1t0j8NKrkqJyY6Txug8SD9
   A==;
IronPort-SDR: juEY9KOMHYTqd1L8AE3SJSZPZHu8tF69WAc1n80LeoSvMINcJvgGoIc4Ie1IFPcR4OZpQhM5gi
 TMPBLsZriSMQ42MZq3y63/rRSZHb44ReCwfRJHYphbgtOgolOdjd5PsyZlh4u1xrbweetKyQ9h
 2xLsFZrA6OYpoHaPUh5pTO6B66N2qOkA40t06E33+qtbHzvqL+3lriNQOVz+DBnwpW1khl4JIn
 SGPSASaACkCiByV7WudxHBZY3tD8l4DKBnqOVwxBmLfQuz1ekoa6HeGkDPOyel5V1ruGvYmtiN
 kiA=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="84770976"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 06:40:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 06:39:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 21 Jul 2020 06:39:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feg/odc7n+9plk2n/OPuL1ATM5/BvDC2C0C/c6zSd3ACon8Iz8aMB/uHWeiJRGJx4DTmbB4VdwqxjNiWcpYWp/WhQBvLWF+iEPTxfT6M8eXALLY6BE3igMAwxywNMdYkOFd54byZUD7uPpziFGbNS5IHxyiQeCGJyRMz2HIIyq4hSGuCV2oimH6fn1DirC/5dv/4MOPfPDSYq57P1k+t87r/lvYIEKI/szv0HAOEEVHCoKROffa8mLldsRYsPc5wl+T9mf2ItpMyoRz3DpYVmMp1vBvqD3TA+Qn9vUKk6AUoBhlnAVryrgTRlFCthaKulijvd1dDzeCOhu2yqmB9fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCIemFwHVUPk9JG5bOXVOGvcvPDUygaTIGU9mXoRy0Y=;
 b=MB/u/r95myqjaWdDhcdjPVb3p0GYbAM08Z+nEXbsqSp4tkwjdMQSpLQdrx39nSeoFGmdsHJAnytyWUFqaxmc+YOSDEihwTGxRMa9o3DeqQgzNPbErDpAV90+JiY5C+maDvIJXme9bmZUbv6zF3gpyyxWy/LK+B4qgDVNlFs2slu7aeyigVINu42f+KDO5MxkyGPLGCAGguFAwH0Ew6dWk4xlcS1zhekaKIW3xH3i2R86rjLTXo9zo7qiioG9dEoiQnix/Z5MNzUTz1a0UKs33JfqkGCX+veicRHSHUOFGUCndV9dTvyK6MhAMaW9f5Gi9Rp8Rt2JhlKUF3EMPHKhnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCIemFwHVUPk9JG5bOXVOGvcvPDUygaTIGU9mXoRy0Y=;
 b=Tko895hBi9/oWqDuWuyonZAFirGbDAIWyzqCJzKuNLuDUHRzSjgcfNXDp0It9ODCVEndoX8eC72lbOKIF3Qcz21/WLQ/sEmENBubNAy5h22Qlg7YmKU6MPFygGT1UybNU2FmzzsWkKZBMf56fEa0VIzJjUdVGrhBVQx8jsxJnwI=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SN6PR11MB3455.namprd11.prod.outlook.com (2603:10b6:805:bb::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 21 Jul
 2020 13:40:18 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 13:40:17 +0000
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
Thread-Index: AQHWX0Zyppx1UbfeIEWndPdIyI+OoqkSCXKAgAAA8AA=
Date:   Tue, 21 Jul 2020 13:40:17 +0000
Message-ID: <9a30d357-7fc0-13d3-bba3-c4d29c36cfc2@microchip.com>
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
x-ms-office365-filtering-correlation-id: 94c7a5c6-08d7-496b-c94d-08d82d7b9b0d
x-ms-traffictypediagnostic: SN6PR11MB3455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB34558A8FF6B8E37A00B0BEF9E7780@SN6PR11MB3455.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ooC+QCXBslLKQ2Z08AX5v/a8BLBBBss+kc5fP3EVtEF+YsgCU41cygass9NBlP0ux+nQxgdh3ULQAp4vsJvFls1U3rsQoXnpt7Ra/K4soFdffVJwgRhvs2NYnTFosLw+Y7SGQBjbvWcaxfwrwI5ZoEe8A2Yog47oXCczRBGWBHY1VFe69j6Y83uYOBxx6VtmVd6aOgecrI0cj5kLpDgnMvLvpqWI0KcnuqNFHEcEU1B579fg2K4jbMrLTnJBqam4LSSs/79hG/wTSAxEEj0ImLd9KkGhmJRe33frVNJ7bvGzoShbp2VWOIMsGeWWyDfDi5JBuIll1jIfv0o89XWgUSIVt3+DtvsPrhSV7O8fCkXdsuJqEXBuawJHW/e+laui
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(6512007)(4744005)(31686004)(498600001)(7416002)(6916009)(2906002)(5660300002)(2616005)(66946007)(54906003)(8676002)(8936002)(186003)(71200400001)(53546011)(6506007)(31696002)(107886003)(6486002)(86362001)(36756003)(26005)(66476007)(4326008)(64756008)(66556008)(66446008)(76116006)(91956017)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /aVRVuptGea+ZiTOUCjyOv8O+d4woP0JI6VowX1sEZDpDNDFkI1UqT0Zr9VzzZv9KgxzgzMfYPwuBXpw3s5Xd05ce0ZpN9Fx2/upB8dvbot12sxUKVVh+zCRx+GkXltqyJsLTXO1rpK/ETS9frU9s1bUDLTXsVDXZVSBQXVKBClGl5pA+Gc6zvQgH9kXHAa/BPhryYYaSQLT+cxHejkvOF6XcgqvOGaTAjWTafHhPVC0ABJLAZfrFWZM8zgdLnVHOfV/KmfDhHJ2t3IwL+1GcIc5nwv6PsBpqgMAP0crHKkrRz30XK7iTmDTK++XgG0E96TkXqQRv3W7OZfPaxqmDsD6g6e1LHCtOs4kQZYgLsMB0/QIbzqsBF9C6Ppzfhp79dMTFiZ4baJlbe/y/EweuPZVlmAexJRfBf6/xuKVFDVQc3ON49wxNczX0Rwnm6LMUuVnoYEmzUamu0LPHGdHqNJ0VavWiV9XCyYvQ8cDA/05y/hPJ9arDP2/c44YLN+l
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDF23F0B9857CE46A167DD6E2A487F0B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c7a5c6-08d7-496b-c94d-08d82d7b9b0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 13:40:17.4246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P5flNyDmarQ8JrCGrqcg99h1d01SJiS3omqeS7MpW7hFPPV6jbCfKostZQY5FeT0NRYYA/NUPTPICT3oKE2dY1iip1Uds4xEfSE0eImwsEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3455
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
