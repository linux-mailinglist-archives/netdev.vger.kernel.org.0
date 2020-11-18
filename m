Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC04C2B87FB
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgKRW5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:57:25 -0500
Received: from alln-iport-3.cisco.com ([173.37.142.90]:26062 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgKRW5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:57:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1200; q=dns/txt; s=iport;
  t=1605740260; x=1606949860;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=51HGGaI8QFnmEx7AZ8c4WIyWFJwmElA02Eo9aIeEaNU=;
  b=Bu8p8glJjQISkIj3Leh5tCfrlLOWA6P1HBTi82YBOsuylHAgQGMac0bv
   F4YNH71SxgJlUxYJJguwr2irdgfwp1jYY83B48vWWKJYlU6TmgbUNgk+z
   aj8TAiCqFSY6BKaZ7apqwWfVi8AhGfvu4+j0Wq9aIVHIzSEuE8lEQrGVe
   g=;
X-IPAS-Result: =?us-ascii?q?A0AcEACZprVf/40NJK1iHgEBCxIMQIMhUQd0WS8uhD2DS?=
 =?us-ascii?q?QONLggmmQSCUwNUCwEBAQ0BASMKAgQBAYRKAheCDgIlOBMCAwEBAQMCAwEBA?=
 =?us-ascii?q?QEFAQEBAgEGBHGFYQyFcwEBAQMSEREMAQE3AQ8CAQgYAgImAgICMBUQAgQNA?=
 =?us-ascii?q?QcBAR6DBAGCVQMuAQ6kDQKBPIhodoEygwQBAQWFFRiCEAMGgQ4qgnODdoZXG?=
 =?us-ascii?q?4FBP4E4DIJfPoJdBBeBRheDAIJfky89pE0Kgm2JEZF8BQcDH4MZihaUS55Tl?=
 =?us-ascii?q?VcCBAIEBQIOAQEFgWsjgVdwFYMkEz0XAg2OBBs3gzqCWYd/dDcCBgoBAQMJf?=
 =?us-ascii?q?I1MAQE?=
IronPort-PHdr: =?us-ascii?q?9a23=3Aig4McxxKQHf2ABfXCy+N+z0EezQntrPoPwUc9p?=
 =?us-ascii?q?sgjfdUf7+++4j5ZRaFt/NgkFHIWZnW8bRDkeWF+6zjWGlV55GHvThCdZFXTB?=
 =?us-ascii?q?YKhI0QmBBoG8+KD0D3bZuIJyw3FchPThlpqne8N0UGHsviaVzWvnCoqzkIFU?=
 =?us-ascii?q?a3OQ98PO+gHInUgoy+3Pyz/JuGZQJOiXK9bLp+IQ/wox/Ws5wdgJBpLeA6zR?=
 =?us-ascii?q?6arw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.77,488,1596499200"; 
   d="scan'208";a="586130958"
Received: from alln-core-8.cisco.com ([173.36.13.141])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Nov 2020 22:57:39 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by alln-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 0AIMvdou006062
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 18 Nov 2020 22:57:39 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 16:57:39 -0600
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 16:57:38 -0600
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-001.cisco.com (173.37.227.246) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 18 Nov 2020 16:57:38 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dn53zPSHz8QGsbUi79QIvCneXXKgoMZtWtnXzMd5NETesoVAxMd3popjRdjGofslpFtyvWDqJT6iYSuf4tljGaye3xi5yIA9jn2DGwgmhcNZ2hKWKYmTCJeRHD8egCx/k03wOZBZHeAmsS+Y1U/3Og9nsKdX6J7ANLttK8PGrToAvHPqHHTlxVIWW2DthL6oZBI57qgblK7X1CBJ2XTbyzkCC0Csqk8QMhHvO1zdZZFG7zpP6iiP+BtjfVjgUxmTLKkaYbTl9fJ260BVmHHCgjKJSLlCSIgrUXR+axqL6WFbE04b7zboqx0LKtInIlhc7SIRDVN7MzqMFha1vJ0zkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51HGGaI8QFnmEx7AZ8c4WIyWFJwmElA02Eo9aIeEaNU=;
 b=FoIavnrhFUx5U6EKwYJOn5SAP1EOyuahBquQSXow9ne/MIHP90qlHspRWs5DAmQ8cF7Bj2aPsehHgaRXKS79myjw+RhK8hRZLFbRbNwBYXtinsQOwmPyBsDpHrd4DlOUaz9chLGr2ymOyCEk6S0bHjGi65ZFB/EiSDoZhaIXHQQXHYsIE7lpYe/kxIDuGbErsDrw9c0OCTBesz3jWweYsEndpF/Rs2Wej8g8qM30GKed83/fTM4sKjWZNkgsNkGe4HMAR7cJ+Q96fBG4R77lG7PCKAKn4jDRw2BZ2aPvtbXTYrX0JMZr0LFtmyidah32p2DT4gCB0CIN/BiZFu/nLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51HGGaI8QFnmEx7AZ8c4WIyWFJwmElA02Eo9aIeEaNU=;
 b=040vNSRTpyRe98MBSfCi2rR+5/I/mqw8YsbPXS0FUMVhLR4iItdFFzPLwC3v6/VQ30odUCXJbdeYjt6lBcDkF/3/IS0xny+o6b7JBdHgsOBSh02XVyVqasKDDCXoJizCbReXP3O/WwbjcbgpaLSe6oHbqFqoHt7n38adV7x/oPQ=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by BL0PR11MB3092.namprd11.prod.outlook.com (2603:10b6:208:7d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Wed, 18 Nov
 2020 22:57:38 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2%5]) with mapi id 15.20.3589.022; Wed, 18 Nov 2020
 22:57:36 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net v4] ipv6/netfilter: Discard first fragment not
 including all headers
Thread-Topic: [PATCH net v4] ipv6/netfilter: Discard first fragment not
 including all headers
Thread-Index: AQHWuCDjuibzITuPWEyjvK0bIRZAOqnOPbuAgABOa4A=
Date:   Wed, 18 Nov 2020 22:57:36 +0000
Message-ID: <3f2c7333-7375-ff1c-7f0f-5251d00bd6a4@cisco.com>
References: <20201111115025.28879-1-geokohma@cisco.com>
 <20201118181655.GA11119@salvia>
In-Reply-To: <20201118181655.GA11119@salvia>
Accept-Language: nb-NO, en-US
Content-Language: nb-NO
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
authentication-results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c0:1006::1f5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92ebb67e-2f71-4847-22e5-08d88c15577c
x-ms-traffictypediagnostic: BL0PR11MB3092:
x-microsoft-antispam-prvs: <BL0PR11MB3092EDFD57F435E91B53E31BCDE10@BL0PR11MB3092.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VkRHFXNte7cNmdjHAQQY7lqdIU8c7HU6Ej/qJBbVUMJ5Mwkw6G0RUh8G3os3ClLQg14swurLgHgEuIp/17ySOfZtK95VMuXlIJJIgBdV5LhYwV3xl97glnZKLcp3+nNxAaYYQ4jGRsi+umDJThGhj4oljRsv3ZkUXJ+mENO+A9PvdkDsZxg863CRgtoFrvmjAzNX+4e93X4wU7S705B7ndEgPZ4vifhnppRfmA5UVhGx/hzm7sUO+MXcmUO2vtv62fq5FDpqiBs+ROILiYJX0EH9hyjglwtLT15FvpDX9jmEN/pkLHZvJrYuxPf1uEgGxLNB5hYVOhq4ckolNIAdkrsCpka6FoCirFPEc4mYR3AcZwm/ih8/FlQOKcUF5ViOIMW4+0feWasdxazSfkwNGIZ4eKfaJgyi41/e/tZqPMAiWpHZVGvZi497E5MzAaxKXdcD2gdAiL/tNgTcTRUCNPjGUnSJW4Nlqu5LGBAvnLI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(346002)(376002)(39860400002)(64756008)(91956017)(66946007)(5660300002)(66446008)(86362001)(31686004)(36756003)(6486002)(6506007)(966005)(66476007)(66556008)(4744005)(2906002)(76116006)(71200400001)(478600001)(316002)(6916009)(4326008)(186003)(54906003)(8676002)(31696002)(7416002)(53546011)(2616005)(6512007)(8936002)(43740500002)(6606295002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: JMzhULw+QMWBDCg5yFIpURWi4brEqPLnsjEisiOx6QQYQMEFAwLvRGQN8sqlCqh0xe3t91+HY5/+7Tcm37ducZn0xqkl/0NnuAkDAWDxrEEr27o4KKrB6O4a0Bd7GM3UZhE4EHKVScyfFs1GWf68rNf0MzwXMs5Z5H76KhiEKjfmv6amNyWH4YCvhoJqaIGuoWMK829mdG4K5RQgKNBq+DcJQ6DWNQwNOZRm8tdo0wq5BNezh9lFDm0hmJWCeVFFnXbf7mVkbjIYaRYRYcDL62xonmvh4F6fxtyJLRsyKVLn/uLxCjaeYpLFO/07ax3h1g7+3+jJmLisKbBzdrCSZuyoiZitlumAgpaNruEIS0jgUpyfXb9Q731AcWtUkn3N7h6bW92T8jcyD1DPTny2r8AOt9nTTj+zIjKFFomCU8XQ7UWIsatI+bWnZGbP/b4ncTEkdGV+dCEcCFeGreZdUMQDbO0l81da5BPlQYo6oY7pfEUUJhfz420GPphpfTmdSdkbeExpuO54QzI749cygafXe2wn99Lxt0EfLWbpUGaOxrjgrEFikx0RCEZVHfpsJ8gV0UDgEjncJ/UlGzaPIu37efnQdW7Kc/Vkdg4lIE33XlCyPICSdpiABb8pJqAiTWmeJgP3ymeDsDutJda02rB/ae1jC2BmiTtwbDE3U9U=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EE40E2DAC472241A8327B2B8266E4BF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ebb67e-2f71-4847-22e5-08d88c15577c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 22:57:36.1640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Umpiu9H3YRP1LWGWc0Z/nZyZTrxBZkGu9sbdHEFjHko0PCLhzvFv6uxP+7ODLBLDmT24zCXtREPifFN4PQriw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3092
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: alln-core-8.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTguMTEuMjAyMCAxOToxNiwgUGFibG8gTmVpcmEgQXl1c28gd3JvdGU6DQo+IEhpLA0KPg0K
PiBPbiBXZWQsIE5vdiAxMSwgMjAyMCBhdCAxMjo1MDoyNVBNICswMTAwLCBHZW9yZyBLb2htYW5u
IHdyb3RlOg0KPiBbLi4uXQ0KPj4gZGlmZiAtLWdpdCBhL25ldC9pcHY2L3JlYXNzZW1ibHkuYyBi
L25ldC9pcHY2L3JlYXNzZW1ibHkuYw0KPj4gaW5kZXggYzhjZjFiYi4uZTM4NjliYSAxMDA2NDQN
Cj4+IC0tLSBhL25ldC9pcHY2L3JlYXNzZW1ibHkuYw0KPj4gKysrIGIvbmV0L2lwdjYvcmVhc3Nl
bWJseS5jDQo+PiBAQCAtMzE4LDE1ICszMTgsNDMgQEAgc3RhdGljIGludCBpcDZfZnJhZ19yZWFz
bShzdHJ1Y3QgZnJhZ19xdWV1ZSAqZnEsIHN0cnVjdCBza19idWZmICpza2IsDQo+PiAgCXJldHVy
biAtMTsNCj4+ICB9DQo+PiAgDQo+PiArLyogQ2hlY2sgaWYgdGhlIHVwcGVyIGxheWVyIGhlYWRl
ciBpcyB0cnVuY2F0ZWQgaW4gdGhlIGZpcnN0IGZyYWdtZW50LiAqLw0KPj4gK2Jvb2wgaXB2Nl9m
cmFnX3RoZHJfdHJ1bmNhdGVkKHN0cnVjdCBza19idWZmICpza2IsIGludCBzdGFydCwgdTggKm5l
eHRoZHJwKQ0KPiBQbGVhc2UsIGZvbGxvdyB1cCBhbmQgc2VuZCBhIHBhdGNoIHRvIHBsYWNlIHRo
aXMgZnVuY3Rpb24gaW4NCj4gaW5jbHVkZS9uZXQvaXB2Nl9mcmFnLmggYXMgc3RhdGljIGlubGlu
ZS4NCj4NCj4gU2VlOiBodHRwczovL21hcmMuaW5mby8/bD1uZXRmaWx0ZXItZGV2ZWwmbT0xNjA1
NzE5NDI3Mjg1MTYmdz0yDQpUaGFua3MgZm9yIHRoZSBsaW5rIHRvIHRoZSBzaW1pbGFyIHByb2Js
ZW0uIEkgaGF2ZSBiZWVuIGxvb2tpbmcgaW50byB0aGlzIGFsbCBkYXkuDQpJIGFtIHdvcmtpbmcg
b24gYSBwYXRjaCBub3cuDQoNCg==
