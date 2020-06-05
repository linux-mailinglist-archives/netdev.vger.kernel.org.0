Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E761EF168
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 08:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgFEGgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 02:36:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:60820 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgFEGgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 02:36:47 -0400
IronPort-SDR: d7ckQZGBK6ARJaOgyvemrRoVpiDkO+W5MIqqyYOgzMcxow9ri4sjMXwHf2yUg3PT/LSPEOWCX0
 LcbomDW6UzwA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 23:36:46 -0700
IronPort-SDR: TXA1OSg/gf9Ggbb0Lk1H5U2fuXPLgicKdO6MwxsvyNza6YhEaIienQNHlw5xRWF/CHBUgbBlBW
 m2c1lmNyd7Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,475,1583222400"; 
   d="scan'208";a="257950045"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jun 2020 23:36:46 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jun 2020 23:36:45 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 4 Jun 2020 23:36:45 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 4 Jun 2020 23:36:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jun 2020 23:36:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZF6IYp2VuNSNTIXQMCEZM2C9HaQm7XG8GKnaa9hcUohbTB65PFa875ql5O7VoOnOVowqS8DM3Syv2dmnhiAOzKqmuR3HOQ/63bMr2sxiOm28/qDhNivIz2mGvkIZ2exDfMs6zS1x0IWLZ9TO2//3KAPL5Rqg8QaMZ/r8CVM7igoZSPzkQ390PnpI2JDXNWcuTxpO1yB3rpFE37CJcnJuIAbfcgsRbNx/yHwaYoH2YWHMUGCv4cNB/oHAZxgKIPfZ+a2f+2hRDBucSduZulQK8Szh8lSY6fKQKYM+CFDDuVajVg42Hl65d0PET6TgrhU2ylyMFWAmrHhV6sYIVNp/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bt6igjb9YpZy4lfUbuKwdkSyqn2SH3AHUOe06JV9j50=;
 b=Hsj2Vj50gzQOL/0cF515jxLwH68lHoone1Jyi7goXLioQjEWZj+p83leXreoaK27oTc7GAxQudEs+4DhOMDeeTUU7rlB8a8g6CtoCI9bwlGwV9XEaTes59gJCmbVacace8OqFJUL4fLWktIL6TX+JubWLFRJ+o8+VSKxHidfLPya52nJawYF6JPlJLRZtfe+Os075ZkEVBBXjnLWkc8/c/rzGRsKFMV16WoruOTJRi4BBvxpzqO4yNRQWa/9BkiKwBqaOfsnlZrDPj4ydbQ83f72CcE9IFxdX5p44TuRYhGoFFku+QroNrnzgoYjt8iWDdw+DwPY+HIrzmPheMoBpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bt6igjb9YpZy4lfUbuKwdkSyqn2SH3AHUOe06JV9j50=;
 b=QYOVtlB1kArdwpay5raNnbRevJZEAuPEofdBRsqQkvaWwheUm9Wk+xdiwYZsR/pT/wxn6L9oepnPDitJAAj+YMrRCRa2L9FhUhQNxuSmfHLclnQiDYDnJgsnaNChko5FwaajzLF4D/9ugDYivQImSbg4EZPuQ8M2lyxA2Cxx7QQ=
Received: from BN6PR11MB1939.namprd11.prod.outlook.com (2603:10b6:404:ff::18)
 by BN6PR11MB1747.namprd11.prod.outlook.com (2603:10b6:404:102::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 5 Jun
 2020 06:36:42 +0000
Received: from BN6PR11MB1939.namprd11.prod.outlook.com
 ([fe80::28d8:4c35:7dcb:4e20]) by BN6PR11MB1939.namprd11.prod.outlook.com
 ([fe80::28d8:4c35:7dcb:4e20%6]) with mapi id 15.20.3066.019; Fri, 5 Jun 2020
 06:36:42 +0000
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Rob Herring <robh@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "Westergreen, Dalon" <dalon.westergreen@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>
Subject: RE: [PATCH v3 10/10] net: eth: altera: update devicetree bindings
 documentation
Thread-Topic: [PATCH v3 10/10] net: eth: altera: update devicetree bindings
 documentation
Thread-Index: AQHWOkLNBKZdtzZwnESIhu+vAPDAqqjJCPCAgAB7o1A=
Date:   Fri, 5 Jun 2020 06:36:42 +0000
Message-ID: <BN6PR11MB1939E6BAE4121A5D0340BAB0F2860@BN6PR11MB1939.namprd11.prod.outlook.com>
References: <20200604073256.25702-1-joyce.ooi@intel.com>
 <20200604073256.25702-11-joyce.ooi@intel.com>
 <20200604222311.GA4151468@bogus>
In-Reply-To: <20200604222311.GA4151468@bogus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.134.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83a29671-bb51-4d02-0cae-08d8091acf8f
x-ms-traffictypediagnostic: BN6PR11MB1747:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1747C996D78838FED7B30D54F2860@BN6PR11MB1747.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0425A67DEF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Eu/gJaCoO9o41Hv1InbCbU2FB5lqDdU92QRTd4rpwJ+7ecMzB4CpiJuHbyYnREyunaArDgLFXC60fPQCKL5PRefmIyU6M97JKPEfTcn+ePGxGnEU5pUq2FyDMbXG5B0pB+fbtK5wBHZt8N+/XQy2pKATKZBDYr+A/UbXGG3AppUHvRHHQYe0vOyERunhHilEpsme60gAREuhd2B7GW2RomBG0UQ/qyLsC4tDrqcuLiNQFAQHt66rG3/GFb9kPpMCgBnP6aLwNlFPRoa6QcSLRflhPEtl7Gd2YTw65TnXEnGZMEZO2o29NzLaNaN3X4j+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1939.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(39860400002)(376002)(366004)(396003)(4326008)(186003)(478600001)(6506007)(66946007)(26005)(33656002)(66476007)(15650500001)(2906002)(53546011)(5660300002)(83380400001)(52536014)(8676002)(316002)(54906003)(71200400001)(66556008)(55016002)(86362001)(64756008)(66446008)(6916009)(7696005)(8936002)(9686003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MJIVCkqdjQSv9kwEJ9LWEfpJsrQWAleaU4/qAWr2llhRe0i9vgaoQ0AMXMQ6yXkO0IFXV+mukIAaujYfbqxAx/TQZ62gbyvtX/PJ+QUELGHXdU6Am43X2XzzkZCl4z0oNr9TQhv2B21fI/e4LFZraqwJd9WE+zARzFkof+BYy74ctgK/LNnSNMwTEGCsn4dC7045icx/youCZDZiTUzWgkZiINXoELTzzI0ZYAsxTRYTMYdoLx7LR/tgJZRwawlijLaBANfTAq32GJmojECYYG5J/9O61XfxZSBl6MRe4FIe82JLDCa/sa8+JK74VQzW4tsHHee3qMnP1+v4RiyAU052wglKbr5PAszHcfSqsxMrssUc/DM86bWurFPtHaMsN2H8nFiXh5pt/5KrmYN5/AU5qFP73fXbfJJRvMAyT4y6WlUc/jmxwoNN8gZK3h/Zf8bOe4wDH/7VHTsRJnKZ3p6J3uQa0XaLnyip+FWn9Bn+ehlwuuZJOO9W/9oRuVU8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a29671-bb51-4d02-0cae-08d8091acf8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2020 06:36:42.7354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9FTttcEEAZpE4goQU0wg0VmzHh7FjmoXWONT/LoRsJ4LA9pcCeArwikiq797wpGrslWXnBQ7lPvfgd5DM8YmzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1747
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Friday, June 5, 2020 6:23 AM
> To: Ooi, Joyce <joyce.ooi@intel.com>
> Cc: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Thor Thayer <thor.thayer@linux.intel.com>;
> netdev@vger.kernel.org; Rob Herring <robh+dt@kernel.org>; See, Chin
> Liang <chin.liang.see@intel.com>; linux-kernel@vger.kernel.org; Nguyen,
> Dinh <dinh.nguyen@intel.com>; Westergreen, Dalon
> <dalon.westergreen@intel.com>; devicetree@vger.kernel.org; Dalon
> Westergreen <dalon.westergreen@linux.intel.com>; Tan, Ley Foon
> <ley.foon.tan@intel.com>
> Subject: Re: [PATCH v3 10/10] net: eth: altera: update devicetree binding=
s
> documentation
>=20
> On Thu, 04 Jun 2020 15:32:56 +0800, Ooi, Joyce wrote:
> > From: Dalon Westergreen <dalon.westergreen@intel.com>
> >
> > Update devicetree bindings documentation to include msgdma prefetcher
> > and ptp bindings.
> >
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
> > Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
> > ---
> > v2: no change
> > v3: no change
> > ---
> >  .../devicetree/bindings/net/altera_tse.txt         | 103
> +++++++++++++++++----
> >  1 file changed, 84 insertions(+), 19 deletions(-)
> >
>=20
>=20
> Please add Acked-by/Reviewed-by tags when posting new versions.
> However, there's no need to repost patches *only* to add the tags. The
> upstream maintainer will do that for acks received on the version they ap=
ply.
>=20
> If a tag was not added on purpose, please state why and what changed.

Noted, will do that next time.

