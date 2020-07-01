Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB942106AF
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 10:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgGAIsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 04:48:04 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:9456 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgGAIsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 04:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593593284; x=1625129284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=thsSwSEFfrF6xIVlmG68UeSCA70cU1RlthNnaspOLo0=;
  b=BW7t22I3dMRWelUYHNKsBHAq79yOVOvJcojkWH0VronQe8GtU/HZpEI6
   RauKEyKo88f2y91CdO60CHm77+Tc2bI1GNHswSDE6+Jy4SdVFFNpuRLoD
   oW+Os4XcyRW4c+7lbBXR79saTmj3Rp6CTv1LYzXlk33kU6SnDm6BpIAWn
   zBe+XDoxUPnSOcPWJ7w9hdzQtOatb7L/DOve8bnubJJ2ia9rMuBFGp7qV
   ryMNe9WSLwd+n/SmzYADBod7j3gZfUfgh0OruTsQ4vm4Aq01wNM/gJHTn
   bdWoUUQDf56KCGQs5aKGYxGNJ0QQVrtGeKxOULXBWMu4pSbfdMXtJwaH7
   w==;
IronPort-SDR: q7dCQwlA8Pkl6AkdyVA3HIh7XCJNhoJgArxLuWR5AE8aJ5c5nYpxCFhJKmze3qOHU9snkTSveo
 CpRsuU8SIMqrePeiRx5VP4Huge1UJGEEbiiBAmOpPz4JHIq9hlS0IcxWBAKERMat3CzZ3hiReq
 UE0xY2s+N/Qblz9a+jT2Un1V0QSJx7BT7CpTNnr0tazHD2p7g0PkPUNr0W+qrsMha8SPrm/VRv
 NyqOQrYlyaztAHPDNyW/QguAt7fcP0t2FYuXB1Pk64eBMO07nDIV4cSNb2QrXDw+Yx3IH9yO+M
 zuI=
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="81506384"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2020 01:48:03 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 01:48:02 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 1 Jul 2020 01:48:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xdw1FqMzFfYmnLV3CAGsRHCWA1gnejSmYRSpEzcmtv601zCJhPgVA5tbHhR+cAhpbWVzTT24D+yWdkbilBoTfs1NQxb0ENpqrefp8Qo33LGETXv2ZKDa9lD1ZW+d/mJLvbeCaYjkt43JebYkgwLMiXiv7MXN6iF6Bt2ls2afMyHxakEM+AFTyNdG7UlvkiVIJqLnG884rgRGdgqUJHBjAF031cLjzUOlJzQ+pJH4gJ6F7OjUUAq2pxaAs2yyIHmUviJ+uCsz5/crIwlnFlvAMI5SRT28yXwznF9jz6r3IsRAZveIG8/4WE0zTAU0dyz+jvlqhR+auReFnX9HdUtN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thsSwSEFfrF6xIVlmG68UeSCA70cU1RlthNnaspOLo0=;
 b=YgE9LJHbzRS3z/W2qM/7gbUraXLC6PwKhjYr1X7ZQ8O7ezNKW+GfCATt/coqHJ+YgpMglkf2Pg9gVMEMWwRMHP8CC+5sKq9OfjfZJSz8lXhBC4XIBtW9t7xnXqyLmea9EgUtmPk7d6k/xLIHAUMHoC75Vps26M7kPBpHjqRVv3THGWhJNhE628cMKSxaS5PaoL+yWWDFV9YLSQ8PnL8oZGH9EzXlorDvvhTcerEHP9qjNKSeMLXFPp/Muvtc4HzK+WuxxskgnYsBXiMKP1IYhgyKvJhAPz4R68QeiCCjKwFKfDIyT2UDsuK3WoRLrSsibnIBfjBLsSOUiVf5DBc21A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thsSwSEFfrF6xIVlmG68UeSCA70cU1RlthNnaspOLo0=;
 b=UBacNokgC09oKM3RS+iL7wt63JQaykkQpBIgpqdcD8sr9UdJfaoQ0RSrpY18pvPhbHI5ZS8bie5NPAywZPqL6q7/SE3PMRqlOsRNiBonWvWJr5voxhtyuTjh0HR9Qq+txgHjfLqUI0Qw1nT6wn01shvsruSLMKTARBA/RUn2Ra4=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB3594.namprd11.prod.outlook.com (2603:10b6:5:13b::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.26; Wed, 1 Jul 2020 08:47:59 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::e8fd:29e5:1fa6:c01d]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::e8fd:29e5:1fa6:c01d%5]) with mapi id 15.20.3131.027; Wed, 1 Jul 2020
 08:47:59 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <f.fainelli@gmail.com>, <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <robh+dt@kernel.org>, <frowand.list@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of: of_mdio: count number of regitered phys
Thread-Topic: [PATCH] of: of_mdio: count number of regitered phys
Thread-Index: AQHWT4RSbR8kCeB1/Ua92S66c99Oqw==
Date:   Wed, 1 Jul 2020 08:47:58 +0000
Message-ID: <bf1f950d-9e2b-f898-d46c-4d9ff14632eb@microchip.com>
References: <1593415596-9487-1-git-send-email-claudiu.beznea@microchip.com>
 <20200630004543.GB597495@lunn.ch>
 <6b022bcc-a670-da1d-5f5a-bdf4af667652@gmail.com>
In-Reply-To: <6b022bcc-a670-da1d-5f5a-bdf4af667652@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [86.127.222.245]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf81fc33-3352-4321-0613-08d81d9b74e1
x-ms-traffictypediagnostic: DM6PR11MB3594:
x-microsoft-antispam-prvs: <DM6PR11MB359432450B6BEFF2D9CBE5DF876C0@DM6PR11MB3594.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C8E9BclSZTEywOoj4ryLpxWLtru4CrH6jrRJO+7tgASkAvbHjlW+DIi//SgKfL0FnbsbP+y5hKGH2eXag5yg6058RaBlXttfPIqt5S2wFlWlCQ2aLnBv2pfC5wA0vkIa7sxSodUNyni0XQ7BiGyQJR/jUThwmJ7F0z5OabL0lgX5zX66i9DWJX4jsoGk/ylSgSVhtlR51ZUNNgTp3cx884Rb3AjoI9fcBbk6AWelLN0HZNEKyBsNGJbBILCyvDiNqN0Lg83RT5yxCMuKz5nhxD28dToFUz3dMRD9dNi+jNbqehUC1FpfuQ3Y8bW0MiO51Xdby/MRFl4PyIfyD5IuVskhvkgwCJWLr/WJip7qDfjMCXZLRAL43zBqeI/n7hwO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(376002)(396003)(346002)(366004)(5660300002)(53546011)(6506007)(4326008)(26005)(31696002)(186003)(86362001)(316002)(91956017)(64756008)(66556008)(66476007)(66446008)(66946007)(54906003)(110136005)(6486002)(76116006)(2906002)(478600001)(8676002)(2616005)(83380400001)(8936002)(31686004)(6512007)(36756003)(71200400001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: v25hzei09Rsc7v3pOt1p6iHyTRzxaOUYcTypPmxgORddEeNw+h+JM68p8ZGtyncv48GeFVE8JsIwIOC14071PQrYeqOuTv1sTF4ViWHLQPxQ69ezvim+8zfOpUobC4B8lh0pQJTcM+JLeYn39lIYGxMbe36OQz+s+Mj0XkGzAPcF0HXzB7n/uPJlDNH59z/CjsqDkhi5kY+u69WR7Borx/5SMgwuhB2/KGx+/Lv46a3K1vPB1ziKlYbZJvRwYj/IqLJg4CJ6BfcG7cFM2W6qxUF66qPSiMV8F/3z1rEU3OfKzKsEndLaSxsMPhweYgU/JvFNAjMw12ReNqsCt+uKble+YeyY1r9GnGkQ7MonJVAQCKP3uIjgLsQV4Cc1V4tNuiKVfFWTzNpODXBBiCB91di3OZ81ao+VCki1/KWZ9xtJIgMeqp1nllCf3odtu1ZyHeHpzw3Da1/d8nvz/7IRqnImHvbnGfJv23FA1o6uHN/TaQ5+gUQQEp5iUslpxgAt
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <347E8989DD296B428326F0E4F59968B3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf81fc33-3352-4321-0613-08d81d9b74e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 08:47:58.9976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 43ZDvx+6CS+tIuWm8dUuaD7tUbiLQDGdmruRmMWOcyxSIYou3zRF7W9XdU+rCQ76FPEIYJUNYFCYIQ+H/LfY0E+nP/MDwQGpmziYL6Lb+O8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3594
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LCBGbG9yaWFuLA0KDQpPbiAzMC4wNi4yMDIwIDA2OjM1LCBGbG9yaWFuIEZhaW5l
bGxpIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9u
IDYvMjkvMjAyMCA1OjQ1IFBNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+IE9uIE1vbiwgSnVuIDI5
LCAyMDIwIGF0IDEwOjI2OjM2QU0gKzAzMDAsIENsYXVkaXUgQmV6bmVhIHdyb3RlOg0KPj4+IElu
IGNhc2Ugb2ZfbWRpb2J1c19yZWdpc3Rlcl9waHkoKS9vZl9tZGlvYnVzX3JlZ2lzdGVyX2Rldmlj
ZSgpDQo+Pj4gcmV0dXJucyAtRU5PREVWIGZvciBhbGwgUEhZcyBpbiBkZXZpY2UgdHJlZSBvciBm
b3IgYWxsIHNjYW5uZWQNCj4+PiBQSFlzIHRoZXJlIGlzIGEgY2hhbmNlIHRoYXQgb2ZfbWRpb2J1
c19yZWdpc3RlcigpIHRvDQo+Pj4gcmV0dXJuIHN1Y2Nlc3MgY29kZSBhbHRob3VnaCBubyBQSFkg
ZGV2aWNlcyB3ZXJlIHJlZ2lzdGVyZWQuDQo+Pj4gQWRkIGEgY291bnRlciB0aGF0IGluY3JlbWVu
dHMgZXZlcnkgdGltZSBhIFBIWSB3YXMgcmVnaXN0ZXJlZA0KPj4+IHRvIGF2b2lkIHRoZSBhYm92
ZSBzY2VuYXJpby4NCj4+DQo+PiBIaSBDbGF1ZGl1DQo+Pg0KPj4gVGhlcmUgaXMgYSBkYW5nZXIg
aGVyZSB0aGlzIHdpbGwgYnJlYWsgc29tZXRoaW5nLiBXaXRob3V0IHRoaXMgcGF0Y2gsDQo+PiBh
biBlbXB0eSBidXMgaXMgTy5LLiBCdXQgd2l0aCB0aGlzIHBhdGNoLCBhIGJ1cyB3aXRob3V0IGEg
UEhZIGlzIGENCj4+IHByb2JsZW0uDQo+Pg0KPj4gVGFrZSBmb3IgZXhhbXBsZSBGRUMuIEl0IG9m
dGVuIGNvbWVzIGluIHBhaXJzLiBFYWNoIGhhcyBhbiBNRElPDQo+PiBidXMuIEJ1dCB0byBzYXZl
IHBpbnMsIHRoZXJlIGFyZSBzb21lIGRlc2lnbnMgd2hpY2ggcGxhY2UgdHdvIFBIWXMgb24NCj4+
IG9uZSBidXMsIGxlYXZpbmcgdGhlIG90aGVyIGVtcHR5LiBUaGUgZHJpdmVyIHVuY29uZGl0aW9u
YWxseSBjYWxscw0KPj4gb2ZfbWRpb2J1c19yZWdpc3RlcigpIGFuZCBpZiBpdCByZXR1cm5zIGFu
IGVycm9yLCBpdCB3aWxsIGVycm9yIG91dA0KPj4gdGhlIHByb2JlLiBTbyBpIHdvdWxkIG5vdCBi
ZSB0b28gc3VycHJpc2VkIGlmIHlvdSBnZXQgcmVwb3J0cyBvZg0KPj4gbWlzc2luZyBpbnRlcmZh
Y2VzIHdpdGggdGhpcyBwYXRjaC4NCj4gDQo+IEFncmVlZCwgdGhlIHBvdGVudGlhbCBmb3IgYnJl
YWthZ2UgaGVyZSBpcyB0b28gaGlnaCBlc3BlY2lhbGx5IGdpdmVuDQo+IHRoaXMgaXMgZml4aW5n
IGEgaHlwb3RoZXRpY2FsIHByb2JsZW0gcmF0aGVyIGFuIGFuIGFjdHVhbCBvbmUuIEV2ZW4gaWYN
Cj4gd2Ugd2VyZSB0YWtpbmcgdGhpcyBmcm9tIHRoZSBhbmdsZSBvZiBwb3dlciBtYW5hZ2VtZW50
LCBydW50aW1lIFBNDQo+IHNob3VsZCBlbnN1cmUgdGhhdCBhIE1ESU8gYnVzIHdpdGggbm8gc2xh
dmUsIG9yIG5vIGFjdGl2aXR5IGdldHMgcnVudGltZQ0KPiBzdXNwZW5kZWQuDQoNCkkgdW5kZXJz
dGFuZCB5b3VyIHBvaW50cy4gVGhhbmsgeW91IGZvciB0YWtpbmcgdGltZSBvbiByZXZpZXdpbmcg
dGhpcy4NCg0KQ2xhdWRpdSBCZXpuZWENCg0KPiAtLQ0KPiBGbG9yaWFuDQo+IA==
