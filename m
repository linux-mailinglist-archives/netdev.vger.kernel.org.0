Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F20234ED2
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHAAHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:07:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:11379 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbgHAAHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 20:07:10 -0400
IronPort-SDR: RDTnv7j3KWzRQHOSE22m8cszVlGHbIu3UkV7qwHG9QBlaw86icVH9SVEEVs/1TefbNyOZqf/Ya
 oS3xs8Fe6huA==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="149703725"
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="149703725"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 17:07:10 -0700
IronPort-SDR: /cPn7/y2SIghq0D+5l29pAKRjHuNBbaRIn5A+o5NwWuOYVzgXkY5J0WoSjPIZsdVcByBcwBjSk
 mbNPiibrANTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="331279672"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2020 17:07:09 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 31 Jul 2020 17:07:09 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 31 Jul 2020 17:07:09 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 31 Jul 2020 17:07:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4lMiejPxlzJsPMKNFEkXNhqgEVbamBd+55IYSRMOQ7CQNdfxRvwZtazn+1VvKeWjTr9LoVTV5HIgXl9jDKI9vdSJUaSBUKsJWng7jUjh2g6u2fHnkjxjvRNK83zn7+jLMgqoT/mkbhgHYOdiKvp5jBi2lMHPYIQn1ttw7NaCygwkGXw/nI4b5/Wc8U9Wr8BNRUpzr6UgCl+dCbXAug63EfHQN7ixWsV+yTOVAViIQ33yaIlWJ+BDTMXgqfbroJxcFrc8N8B/n6aQQ0ppbVoivcD39+lvzoP0GlOThGNLa75KmT8Zxmop14G/nC0RK2iw1cyVkF1/Oinu78AdZLC0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39RrbJP7J1r5WrRp42RgoHwvjNoO6PA1x5RH3iARHxg=;
 b=jBQpuyxYehy0gm4iAD1qRNcseiJWc0XCXdJcPY3ImgqC2F0NKFYegkdC8+Dgn6Hugb4ty2TVjdlYL2PXWUm9IjK1Dl+ebE7prlgzNXKjjRcNgm6fTIwHKNR9H7VnixSff83GbiOzw0iMExKSzJZRFjFZ7LrSQdzLsgQIRqByWBnoJTh2qiE/HiMe/qGdYC+n1F+6QtwzF+KPujvLY3lmCFyqaZAFiPG9wDjLti7bmD5OIhkn87qFGMe/nehUVzwVcv4zUYPn17OWYvDd2bWustJFUfeuuxc2k6vwJdG90twzDrQgpkM6Y5r2pxH2jpinBZgJ422PU8g6LtlmRcVcyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39RrbJP7J1r5WrRp42RgoHwvjNoO6PA1x5RH3iARHxg=;
 b=GXb9+NedQyVB4+kKkuMnRIsvhe0yxmsnX3dLhbNkdufZPh4miNdwY21uEe0Fm6lbbM2fFdvUy4OlwBP5/s6GZEQUllERD6OIQtNb4XfV2dRzH0CTWHm8/PXLiiZaHHwPcVwF/M7FnvOAon8XpYh0Ed+3rb59/F31FHDS7SN+vTE=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3008.namprd11.prod.outlook.com (2603:10b6:805:cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Sat, 1 Aug
 2020 00:07:08 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f8e7:739a:a6ef:ce3b]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f8e7:739a:a6ef:ce3b%3]) with mapi id 15.20.3239.020; Sat, 1 Aug 2020
 00:07:08 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] [PATCH v1] ice: devlink: use %*phD to print
 small buffer
Thread-Topic: [Intel-wired-lan] [PATCH v1] ice: devlink: use %*phD to print
 small buffer
Thread-Index: AQHWZotEtyb4aH6jj0i1x7sv9mm/wKkiXVWAgAAE8oA=
Date:   Sat, 1 Aug 2020 00:07:07 +0000
Message-ID: <1e14e2bd97cc6e49d60acfa03ab1fa0c777a46ac.camel@intel.com>
References: <20200730160451.40810-1-andriy.shevchenko@linux.intel.com>
         <20200731.164921.1194657794631782709.davem@davemloft.net>
In-Reply-To: <20200731.164921.1194657794631782709.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46578d3d-fb53-46e2-6529-08d835aed4a4
x-ms-traffictypediagnostic: SN6PR11MB3008:
x-microsoft-antispam-prvs: <SN6PR11MB3008F768163C3DBBEC118FAAC64F0@SN6PR11MB3008.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lsEb2oOhUKfciec14eyHn5abXyAQjvppU3OOrch+SisAEwuqqTYRyNhixkeM99oHlrGZQya88r3JqoyAq06a7o2C1LWt8oc2M9Ga3WVTN/eHGz1z2gw0WFGUdJcgM4kZ5jmLz+QELVSHxMZGqibreu8srzyxrPuEl36hYTPmLaUxNADA2gy05ADWiKJERnWXi7YcDJ7ew1+m1FYsisKwuzQZjp2CWZ9/orFRmtdTnYqvypvCh9GfVUXpollhoS1sWX8hIlV2lNyywu/hdagF8Vwrn2nKmUUF9TwF4zxVEu/6h95ho4GVboFKJsP3EzMmJYlAqc7vrxJZ4oP+vYFoTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(478600001)(76116006)(66946007)(2616005)(91956017)(2906002)(66476007)(66556008)(66446008)(86362001)(36756003)(26005)(186003)(6506007)(6512007)(54906003)(4744005)(64756008)(8676002)(8936002)(71200400001)(110136005)(6486002)(4326008)(5660300002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8ChmRj1wdMZU6Adx3Ba4SpcJs+Z1VYydxO1p5jV2DSSASMioqRHEhF2kG07plz0R9WQKVtOaPOL/OiqxW2RXUwnBX0KyPP1rb5qKxH8ZXTeTGvB8JpSIgbybF99b4oroTnTUiBZdQo9ucYefYJX3KZh1sM4WKJEte5bMphTO8isx1GSe7/n9dmDl5z7JHQ6UPEyGKFM7tbJJLAiuhxCbmbfLSjJcbLvfUoPuH0aeOnJkxl9ZTTh7CbrvQQZ8Tyne68c5kB3SxKlZY/6laLcxEtfmR0Imi873v3jej/AVVNBP0tX1QfSuv4AK3CRSncGOIQoe9RziNHNLoKw1nTIwlPjIL4K5fYF6/8OI7KMCy4xTMEBrRE4a9aFxs8DNPuLRVJrwxBy5wefWhAuQS/fjaESV/J8AyXeDvlzkURWirBOyhUdOl1pp4Ydpj+kdQ0UNrbdukhdGFXSypbdw/5v6Imboz6TYbcTXFoYCCMHXc6jWwgkpSdj+8zWh1cUBupwOqX+mW9JI7soanJRLvr0zTocK8UtOSlPtLZSAs70oXk6LpilVVzriU/K8YsXph9Y+uIZrvKDuBVmrjhxsfw+Q4k2wR3VypdzGsU7ZRxy2J1ASXIPR9rher4G/NSSBCAkxaY0Vf8BP/RLXtSXmnB4ulg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2128E9EF8F60E944932A34723C191E9B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46578d3d-fb53-46e2-6529-08d835aed4a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2020 00:07:07.9391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bdoC8/B3ZS1pOJ7bxZdDjSk6EcuP93Lrd5lFOsPGzvLPbvDgcVvInyIPmxMw74QoUHZMLYUFGzUcVU/ZLAZph1dQDWnh282bunGqYJFETpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3008
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTMxIGF0IDE2OjQ5IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEFuZHkgU2hldmNoZW5rbyA8YW5kcml5LnNoZXZjaGVua29AbGludXguaW50ZWwuY29t
Pg0KPiBEYXRlOiBUaHUsIDMwIEp1bCAyMDIwIDE5OjA0OjUxICswMzAwDQo+IA0KPiA+IFVzZSAl
KnBoRCBmb3JtYXQgdG8gcHJpbnQgc21hbGwgYnVmZmVyIGFzIGhleCBzdHJpbmcuDQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogQW5keSBTaGV2Y2hlbmtvIDxhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20+DQo+IA0KPiBJIGFtIGFzc3VtaW5nIHRoZSBJbnRlbCBmb2xrcyB3aWxsIGlu
dGVncmF0ZSB0aGlzIGludG8gdGhlaXIgdHJlZS4NCg0KWWVzLCBJJ2xsIHRha2UgaXQgaW50byB0
aGUgSW50ZWwgdHJlZS4NCg==
