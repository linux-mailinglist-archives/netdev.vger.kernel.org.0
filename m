Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961C624AE6F
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 07:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHTF3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 01:29:15 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:53480 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgHTF3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 01:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597901353; x=1629437353;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UKhZNZEVSJPbhyLblsMWxI5uofLgkPkZ45A/PuF6HUM=;
  b=acawDvgKJBGVJnbgV+K1aCq1yfxan9VSpF1BAZBSO97rXF/iWC9CLVa2
   9pSoEIeq14EfxKclcZQGjZLeNzceiYsgOTJA70JJqEMgYuiDfZ4//0oP9
   4ByP8L2Za/a3guYFH2k2qd8ycD7HIocWMWUmOJKhUAOblIEidbewXxUDO
   61iv3qxgF0rVkw7Mu29Z9H3C7QUQEFIvm2qnNwt7A2AKj3nhhZaGoBHEG
   fVgJUkVqfVtdPdA+utCgk41kq3H9sZXdafhOIg3SbMdGIDnAEoAzfE1TQ
   UEkJ8eH8WujGqFJIfS+kOppb77tKlJlxxnJxMFS6xiPvtHlVL8BRjEmAR
   Q==;
IronPort-SDR: otW9Ih1E6kAtrEkAGRyo3WRm3hHu6CogUsLlduISY9MaDESr9QxTboSpNHeg5Ns3t1l6jYOe6G
 PvBHCovUBeMmjQTSTDnAK7QuqL4IQ8T4S4IGxPDs2QVdgfAiUj7yc7Ppcc4r4xdKz4j0Hujhqi
 8wb/5rcKo0EJTSOuUYrLhCZvrEx2PK0ENBj6DO/eck+OjoBfM5lsWawowllxGMOLShEkyeUrTF
 VmAOM/rp6qLwhP/+9kp+OZrtRwkezzHb4jYXp+zpRJG1gZn7svq1AbKI3TLwMWf66PyWw0Mw89
 2Uc=
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="84143381"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Aug 2020 22:29:12 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 22:29:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 19 Aug 2020 22:29:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1CYryLHKEnxxy03+0eMPh5nZc5uxx1onjjqerkXj0C7FRQIEOSyAYmfGPS2JVtJ6EZXWYDkkxkyotxvhnGCQvfXWcI571Z1osF5AdHCeKuOjTeDuaD09bnyqIAVzDgsKxzp82iberV8473m699ZhqrGA0BEG4yI6IJjT0gJ211lWdfteYiwAHoW2AfwjDHhgLCsqzubytHNcVhMlwZ8WUS30VKfRBiPGGhJZz4sbs9vOnina3BZ63w5TyLpWq/9B55f1UJj839bIYosD1zctdFtQbhpcuyXRn5YAcRgFEPxazaGTpAvoUSj7FjMKnNxqvM8f+guKFzhqhD4apBwww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKhZNZEVSJPbhyLblsMWxI5uofLgkPkZ45A/PuF6HUM=;
 b=KpGgWa28WyekE577GtXj0hOyFBpvZNOfen+P69hpEykwIHS3+3QYXm1GpIZzocFoKYaQD2LXlyv0TzZkRAXA/mGoWXQk4GgMrNaaxOGooSkgZBKsUpgUCxIDQQ7cyhSSbQTvPb/U55GNfRV1muy5FNB91Ql6CCxA9bicCGZ3NFA6mJlD/pgz9rWnXkupgyZlNj18LqHWblnhdEvEMXpv5LywMeS5jfVIpIiLcyHLOUu+WgKB/58UIQznBDSVsnkq8VLzCv3hcHFB3DjOEfEL1Tej9a8hntA+RTLrXnj1ZV5fD38mQE8Jk4GM7YMcU/2X4mdfVpmS/PkA8SUluctV2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKhZNZEVSJPbhyLblsMWxI5uofLgkPkZ45A/PuF6HUM=;
 b=CpXVXcYQbmsjVu6/e4bL6hM/CvBKDQPoBkgXXlwJQKKtH3QhlqPQ8yFTOH5rYoSaT18Y5y4AEkM2BaxlVGxbzndqSFMcTm/Cfi1U2uuwqy1waimkHaechyQJNle24Y65bPBs4tLlsSiIjRQK1RN2l9OHRA3hhxxP9R5ovKQr6Yw=
Received: from MN2PR11MB4030.namprd11.prod.outlook.com (2603:10b6:208:156::32)
 by MN2PR11MB3918.namprd11.prod.outlook.com (2603:10b6:208:151::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 20 Aug
 2020 05:29:11 +0000
Received: from MN2PR11MB4030.namprd11.prod.outlook.com
 ([fe80::d10d:18e3:9fa9:f43]) by MN2PR11MB4030.namprd11.prod.outlook.com
 ([fe80::d10d:18e3:9fa9:f43%4]) with mapi id 15.20.3305.025; Thu, 20 Aug 2020
 05:29:11 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <dinghao.liu@zju.edu.cn>, <kjlu@umn.edu>
CC:     <Claudiu.Beznea@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <Eugen.Hristev@microchip.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: wilc1000: Fix memleak in wilc_sdio_probe
Thread-Topic: [PATCH] staging: wilc1000: Fix memleak in wilc_sdio_probe
Thread-Index: AQHWdh734QjzENVmqU25Mfvq1DtesalAeWqA
Date:   Thu, 20 Aug 2020 05:29:10 +0000
Message-ID: <0f59db10-4aec-4ce6-2695-43ddf5017cb2@microchip.com>
References: <20200819115014.28955-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200819115014.28955-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [106.51.105.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf73228a-012a-40f7-f5cb-08d844c9f7e0
x-ms-traffictypediagnostic: MN2PR11MB3918:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB391878A7E18C621A9C1F26FCE35A0@MN2PR11MB3918.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ySojHF3Cr0U58Et4QsGhwSFQWhDzNcKQOldAE7fdnYvcC7u6Esb3dNX50TiisRtqIbTlfnHWejzRwJNZ+VwJiZudAQ+jyMCLd3RrP2DtcECzgXdZupw8Pw0iz5/lyDBVupSWQ+Yd707enHMJUiK9rOgeqnerAa43PWcrQqnIdgJFDkDHSJEBJ9LJWkv0MFOvkjfxy8L7xIMnr7hPvjeI25GwWHYQ/dDV+aoaJhvj65n8ZDW8htLjLZ28LGuKPuRC2rRtWWqLx1CAb9McRlkM09/jLFUu5JQB29ULoF3h8pZrQl5sfc0pXrER9gj0izPul6YviPaZhpZZOhRLt8aEcggdobrvkurBu0H5gJk2mbSV9OCc/uEjkhHZ4e9uC+6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4030.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(54906003)(2906002)(53546011)(110136005)(6512007)(8936002)(2616005)(4326008)(6506007)(186003)(26005)(31696002)(55236004)(478600001)(5660300002)(83380400001)(66476007)(76116006)(66946007)(64756008)(91956017)(66446008)(8676002)(36756003)(6486002)(31686004)(316002)(66556008)(71200400001)(86362001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZKvUaUgEzqQ8JkmhydfoaZKmxEcY93xexwjsu7wvA+Dv4HrmrdTyddLOzgNl1oZRE/WRDIfkDPny8r5XXKv5kkGw6JJwOy4jiDPbih2QawnPTMVkbZEpV8XXJM+WrTn10LLm1cY1wy5OxjQMIHs3d1jq5+WNNf11BnNKBP035EJYs1Z9zl36m9vxLrE429o8LlzlHaaszXKRgwtzDQook8/Yx/HbH7IQBy32kmg9BdDu9/GLrLgkpvMTrVkrh55PAoJJ6LwhC6wQ7mdxaxYI7nOtvhKoYoHjKCiYRQS9jg/hK5RluDdTxUMt3MDbrIySWtB0XYhMKQkmCF0mPshV4IrjCbyUKUmNFGdgzFtaKUaAbx8d5VewxxFMx9hCAvS0vZXexgzGo6LIqNuA0zL+13Gy3nrN7Yyam4j7XPPbyuRlq3c0G1nLYQ13FNUKgOEqRtYixNbn0WVDoUmEqQ473y+06ynwwzaE32Cac5GjdJPnnio7wo+wFmE6nPL03R5aDUqNWtqZYBuuEkFe/NmYbtwIPeFI8wbfc/IQr0yKfGqmT2wKmNLxpR+tOZ0W4v0o3LBimEzHmRkucmFS9EjOyzwRKZRK2lXBurEreIWmok3kTNvWKVWIHsr+lLBUGUjg/xXE3ucsYYF9xgwM/FXJKw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <7155808A69CF46448995E4A393989633@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4030.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf73228a-012a-40f7-f5cb-08d844c9f7e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 05:29:10.9736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o+nIFURPlqw/zT0Sp/u0RTKVRT0aNMN779Mb12Chz2cvD1zdQcHYa9puHNDA//fsqREIvdXwPCklt4N+bW9rtAB8GdvNg2dRQvkZzxfpt+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3918
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciBzdWJtaXR0aW5nIHRoZSBwYXRjaC4gVGhlIGNvZGUgY2hhbmdlcyBsb29rcyBv
a2F5IHRvIG1lLg0KDQpUaGUgZHJpdmVyIGlzIG5vdyBtb3ZlZCBvdXQgb2Ygc3RhZ2luZyBzbyAn
c3RhZ2luZycgcHJlZml4IGlzIG5vdA0KcmVxdWlyZWQgaW4gc3ViamVjdC4gRm9yIGZ1dHVyZSBw
YXRjaGVzIG9uIHdpbGMgZHJpdmVyLCB0aGUgJ3N0YWdpbmcnDQpwcmVmaXggY2FuIGJlIHJlbW92
ZWQuDQoNCkZvciB0aGlzIHBhdGNoLCBJIGFtIG5vdCBzdXJlIGlmIEthbGxlIGNhbiBhcHBseSBh
cyBpcyBvdGhlcndpc2UgcGxlYXNlDQpzdWJtaXQgYSBwYXRjaCBieSByZW1vdmluZyAnc3RhZ2lu
ZycgZnJvbSBzdWJqZWN0IHNvIGl0IGNhbiBiZSBhcHBsaWVkDQpkaXJlY3RseS4NCg0KUmVnYXJk
cywNCkFqYXkNCg0KT24gMTkvMDgvMjAgNToyMCBwbSwgRGluZ2hhbyBMaXUgd3JvdGU6DQo+IEVY
VEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxl
c3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gV2hlbiBkZXZtX2Nsa19nZXQo
KSByZXR1cm5zIC1FUFJPQkVfREVGRVIsIHNkaW9fcHJpdg0KPiBzaG91bGQgYmUgZnJlZWQganVz
dCBsaWtlIHdoZW4gd2lsY19jZmc4MDIxMV9pbml0KCkNCj4gZmFpbHMuDQo+IA0KPiBGaXhlczog
ODY5MmIwNDdlODZjZiAoInN0YWdpbmc6IHdpbGMxMDAwOiBsb29rIGZvciBydGNfY2xrIGNsb2Nr
IikNCj4gU2lnbmVkLW9mZi1ieTogRGluZ2hhbyBMaXUgPGRpbmdoYW8ubGl1QHpqdS5lZHUuY24+
DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NkaW8u
YyB8IDUgKysrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlw
L3dpbGMxMDAwL3NkaW8uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAw
MC9zZGlvLmMNCj4gaW5kZXggM2VjZTdiMGIwMzkyLi4zNTFmZjkwOWFiMWMgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9zZGlvLmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NkaW8uYw0KPiBAQCAt
MTQ5LDkgKzE0OSwxMCBAQCBzdGF0aWMgaW50IHdpbGNfc2Rpb19wcm9iZShzdHJ1Y3Qgc2Rpb19m
dW5jICpmdW5jLA0KPiAgICAgICAgIHdpbGMtPmRldiA9ICZmdW5jLT5kZXY7DQo+IA0KPiAgICAg
ICAgIHdpbGMtPnJ0Y19jbGsgPSBkZXZtX2Nsa19nZXQoJmZ1bmMtPmNhcmQtPmRldiwgInJ0YyIp
Ow0KPiAtICAgICAgIGlmIChQVFJfRVJSX09SX1pFUk8od2lsYy0+cnRjX2NsaykgPT0gLUVQUk9C
RV9ERUZFUikNCj4gKyAgICAgICBpZiAoUFRSX0VSUl9PUl9aRVJPKHdpbGMtPnJ0Y19jbGspID09
IC1FUFJPQkVfREVGRVIpIHsNCj4gKyAgICAgICAgICAgICAgIGtmcmVlKHNkaW9fcHJpdik7DQo+
ICAgICAgICAgICAgICAgICByZXR1cm4gLUVQUk9CRV9ERUZFUjsNCj4gLSAgICAgICBlbHNlIGlm
ICghSVNfRVJSKHdpbGMtPnJ0Y19jbGspKQ0KPiArICAgICAgIH0gZWxzZSBpZiAoIUlTX0VSUih3
aWxjLT5ydGNfY2xrKSkNCj4gICAgICAgICAgICAgICAgIGNsa19wcmVwYXJlX2VuYWJsZSh3aWxj
LT5ydGNfY2xrKTsNCj4gDQo+ICAgICAgICAgZGV2X2luZm8oJmZ1bmMtPmRldiwgIkRyaXZlciBJ
bml0aWFsaXppbmcgc3VjY2Vzc1xuIik7DQo+IC0tDQo+IDIuMTcuMQ0KPiA=
