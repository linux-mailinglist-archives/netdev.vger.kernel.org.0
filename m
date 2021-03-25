Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA2C349CC4
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 00:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhCYXQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 19:16:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:31898 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhCYXPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 19:15:39 -0400
IronPort-SDR: nsa2Sq9uBs+agrpc1b8cnab53vOLe1dEd2n7IE9FSmCz2xY3cgq+aBsT7bF7qWuRwd8vvIrY3w
 gSyYEFntkT/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="276164920"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="276164920"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 16:15:38 -0700
IronPort-SDR: rWEBRGp+guBC9qFFbS+leFuY7nu0uYOya4cYcjdpMzDB98Y3rVJoIh5CO2yiRrGqpnZfkO1hHM
 vqOlC+dbJyJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="525829564"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2021 16:15:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 16:15:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 16:15:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 16:15:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=al1itboT7aPmCSukVMdJCFG0gdq6JqeGMc8eYn+QF6aqQhPxKqVBttWYh2Bmh+BWWqaCVGX3DOwFNrtqHLGJjdIMO/ve4NJ/mPRJ5VlClooeJ5IFc+PdhGVAjKhTuMJ38Fa2e8yWtoopQ/jnRPHl9+4RvR5d5x5F9PI1gUzeGav9U5Y648oDu/O1Lf015dBD7yzk4veSisz93kt+89mqs4VU4XgZsfAVSCOi54aUv7ezL6PAuiR/zfT+byamCkAHqpae/yOIHkLIbBv3RDtyi+TUeFYKc/hrsNTuWyv5RedHumPh/zmY5QPtAfLkCxYUM8h1qUPTB/yeqi3byAE/0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UfY6V7PbQeO6Nc3z4uqrloh2B0R9gYVIHMc9JEE9724=;
 b=cC1Mz1jadV4Yd0+DI9upC9LfcsJQsZ5LD5tpepLaMtR8yHfyLam64726DLSUbbnJETkzcmME563et3J1pSZCR+StPELjeqlyaIeCVze7faYpEgMyzREJa1ctsTjEwU3/u2iUUuA4dGWt0gYnmzUU3lNTG5yguhxT4lSoFETML8gqklnCyr7XJv5yxOtZm2RXkuvX24wVe3l+hn7LA/ACQGSTQfFexIPMRh64mllxZQKDxg4Ra21sroljxpOvbg8f4P42m9Ih2ZGF8HfhSzTBCDW5DWMIc8mLXAzkeDH/sozkDHRcJrK/bFusOYMKZeGpAJj/fEthZhrUnv7YgORwGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UfY6V7PbQeO6Nc3z4uqrloh2B0R9gYVIHMc9JEE9724=;
 b=c6mqAX0p/tTubRRyTwUP9Rtdaf4BscIrdtAb1EGhRVu7aVNs4dJY4K8bicXPNQ4dvozL3HvO8y8jmFe0Jsp1yTz/GoA17lRiFmSgcYZWWUtVAwsH75pL4yasM0xMJ25y+3H7r0b1GgZwKi1WfYGBJyhME+7x0dvNujOFrAnZ6vs=
Received: from BYAPR11MB2870.namprd11.prod.outlook.com (2603:10b6:a02:cb::12)
 by SJ0PR11MB4832.namprd11.prod.outlook.com (2603:10b6:a03:2dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Thu, 25 Mar
 2021 23:15:34 +0000
Received: from BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608]) by BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608%5]) with mapi id 15.20.3977.029; Thu, 25 Mar 2021
 23:15:34 +0000
From:   "Wong, Vee Khee" <vee.khee.wong@intel.com>
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jose Abreu" <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Joakim Zhang" <qiangqing.zhang@nxp.com>,
        "Chuah@vger.kernel.org" <Chuah@vger.kernel.org>,
        "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>,
        "Fugang Duan" <fugang.duan@nxp.com>
CC:     "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        narmstrong <narmstrong@baylibre.com>
Subject: RE: [PATCH net-next] net: stmmac: support FPE link partner
 hand-shaking procedure
Thread-Topic: [PATCH net-next] net: stmmac: support FPE link partner
 hand-shaking procedure
Thread-Index: AQHXII0xyT5JWKwKjUKLUAfO+f80/aqU0bWAgACF1TA=
Date:   Thu, 25 Mar 2021 23:15:34 +0000
Message-ID: <BYAPR11MB2870B83EC0D5EF01B24C5E67AB629@BYAPR11MB2870.namprd11.prod.outlook.com>
References: <20210324090742.3413-1-mohammad.athari.ismail@intel.com>
        <CGME20210325151329eucas1p10b57c4e56a53ba17dc8f68e6b29a46b2@eucas1p1.samsung.com>
 <ccd0e43b-b4f4-8074-83dc-eb59c5ddb969@samsung.com>
In-Reply-To: <ccd0e43b-b4f4-8074-83dc-eb59c5ddb969@samsung.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [210.195.26.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb4d89af-23d6-434e-3a9f-08d8efe3e489
x-ms-traffictypediagnostic: SJ0PR11MB4832:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4832E9D589F84590D12060CDAB629@SJ0PR11MB4832.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TNfBXFZqNqPsslJdWgP7NHxlEN6qATwRNDqq5i94b/pCNhXlFLc5VjgtozBnaL2w4qSEj1da4TMCOjWhhNAUMd1r9iiJt3//pzVrLfLud5+hp8ZNxGjr2VnQPun9lMY+FG7mygcx/Mco6lv6wJTiq9ApQ3UcsyJKJV8UXCxqKfgHWgqoLt3QsSDzpLX5VVD0o5AbYR5crFEZ1GvW7fKKngH/hXlmuZa3lWpmiLO65ea9x0rXK50SyYkDlKfnsNU5h9ON+3Lt9zSyp9MHT+dULaXlZEEcJT+Fhmqw2aQ5JaE6FLjuM5NHXLWDH3HQufiS5DU/P8Dde80BHcMWggKyS4lMHei2MuTD+q/uxQEBpZLQzFAZnv56Dda8txdkMdgtF+k+OqWwK+ZqonzPeepBLrzE7YfwRCRrYcDlje0M+OfaFc6+R1y3KJbrWCzLa6Xm+O3OgZolmqJAQERxS00UgCpRRrKEKZiGULuDxQBtNIJn5C4Z/YXlwfEKAvA3xy/xdbHszXQZ1HXOHvbjqaS6KFoHw16q+8G+Ouh/AjOaxSEnSVXp7rUWfypUhTdNip3yQcxEpz/9C5pTg9GIRRCKmLiw3jaow6RP6T2/j6n172rXUuOyHBFvxjdtbAKNWiEtBViuZwd6cZzMTyVK9nm2WKHGkhfCHwk4qOrW7meiAgYKkmPuVmOAoaySQ8gm8EHl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(136003)(366004)(54906003)(66446008)(7696005)(66476007)(64756008)(5660300002)(52536014)(66556008)(86362001)(71200400001)(9686003)(66946007)(316002)(55016002)(76116006)(2906002)(110136005)(38100700001)(4326008)(921005)(7416002)(8676002)(55236004)(8936002)(33656002)(26005)(478600001)(45080400002)(6506007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MWZQdHp1WURWTkk5QjhuL05XQ2NoR215bG9LQk1YMG5yUFZiSkxpZjE0UWNr?=
 =?utf-8?B?cFdmeXRUVjVZeHVhemxqSUc3Y1VxUWJWTXB3SVdkSkpna3ozYTdEM243d0R5?=
 =?utf-8?B?NENtaitONmo2eWNPMW9FMDJHVUo5aGR6b2dBOGExOVlFZmdzdHo0TmpxdU94?=
 =?utf-8?B?VHZIcWxSUkZ0SG4vWTJvczEvZEIrSUlnZEUvbWxBL1hQdE53d0pRd1VwNGxM?=
 =?utf-8?B?TEs4djFtRFZXY0kxT1BzdTFtc094MGRsV3Z5bEU2NHppWXNTOXZ3dUlVTk1y?=
 =?utf-8?B?K2FTU1E1OHc4eGNaRHR6dDNIRFRBNUd2dXRpZkZWbm1WWEZQNFRHbWQ0bTdo?=
 =?utf-8?B?K1I2Y3VMeDV3L3pZOVlOaStrRjJuWENCTjBrMHpSVk14Z2ZwNjI0UlBRWU5i?=
 =?utf-8?B?T3NuVmY0dTU0R2FnNFdVVzNRSW5KL05LU00wQW9QaFFqQmR1c3RXVnVMTzhv?=
 =?utf-8?B?TXgwZVlTNy9lVnBOUXEwL3NUWEdkTTROYXA0YmVmOFZlOXB2elFLYlZiNEZt?=
 =?utf-8?B?bUJCbU96RHkxUUk5THRSajZTZkVnaXBPNkNNcTgzT3hNTUh2YmNSMUJJZjBN?=
 =?utf-8?B?RDkyc2ZzTUJxRnk4TnhyTzFpdk53andFcXVoSTJDOEh0Tks4MHp1YWVJZGxB?=
 =?utf-8?B?bStpSzVWRkZXajdFVGRKcDJHQTRoUnM2NW1HRzNWaFRhY2dYQm1IMEZiOTlu?=
 =?utf-8?B?VmVsaHBlVnFzOGYzYldXckFqa3luT0RTYkNoNkRRbTYxMzV0TWVHTlhZemNm?=
 =?utf-8?B?aVpSeStXa01zU3djdStYeUhOblFuZmRpY0lSOVl1cTZCMlgwLzA0b3ZBVkgv?=
 =?utf-8?B?UGtWQUVncjZSdHJHTE5TWHZoM2orcitYMHZjZ1lkUFk1d010dCtCR1B5ampZ?=
 =?utf-8?B?dGdBOWpmVlJhSTFmblM2MzJPZjNMQ0VMZkVlSFE0T0w4QmVnVWJWeWNGNTF6?=
 =?utf-8?B?N0IrNjJKaGFYQzdSYUhXeEQ1L0RlSkVNcEtySCt3U3RPNHloaFdBUWZYeHlU?=
 =?utf-8?B?WWdnOUk1alltYzZLZ3llckw2MExHSFVjTEY2OFVUREdwc3RaeVpkSkV0blpY?=
 =?utf-8?B?YkZHUGRsQk1Jb3NaK0hjWVBxQlRzTStJUXBVRG1tckZmZ09lZUl2R1dTbjdj?=
 =?utf-8?B?V1FiOHAwUDhUNmlWQ092bDhLZ2xxNHVrcWZqRGtwaWRXck5Cc1NOenhKZTFr?=
 =?utf-8?B?QkZoT29rWjlDR0hYYVRsWG1OTGVyMHlJYkJHWTZnVUM2R2FGVU5tak1Qc2xU?=
 =?utf-8?B?K1dKWUwwT2txd1lzY2NjNlZ1aEt4VVViZXM5RXRRTWdwKzh6Y2cxQy9PYk8w?=
 =?utf-8?B?ZnZSNDNKVk4vNm0vaVozYnpsRU1DRk5vSHBjV20wNTVGZ3JoWmdjWVhTOG1Z?=
 =?utf-8?B?VXZTRG1uQTNMUjhKMDJFM1dtN0dJa1BzYkxnMGVXeWkvb2UrajkxMkR4REtP?=
 =?utf-8?B?L0ZGbmdJcjZEdW5xdFgrMXBKclRqUWt3NkVmbmJia3FYQkE1SEhGZzFBY1dP?=
 =?utf-8?B?SUVEdC9yNVJJaFVZeEVpdE9VYjhJYXRrdDB2SkxKSFQzWURkeVVSSW93N25S?=
 =?utf-8?B?a2xPT0JSTG9VZTN5RlNWbFRPWWppTHBBdlZLaHlycWZPTGhSbCt0dFdYdjVp?=
 =?utf-8?B?NUowSlkrb042ZGVKRUF5UWdDWlZRL2U3cFcwVzdDUlBadHdaVjhDM3EyU1BJ?=
 =?utf-8?B?d3AzTzVJRzNWNVRhK0U5YTVYejY2NDIzenEwOFdhTWxPb3lpd1JIbEliNXVs?=
 =?utf-8?Q?shV+paJVrgxk5IUFPHpPLxKTZygD3L+oy3NoKcs?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4d89af-23d6-434e-3a9f-08d8efe3e489
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 23:15:34.1979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ub9o9zFtyFqwW1McGM+QKbuUD5SynnubJrQJ1oc+eqTiMer6ItHJbkpxf6y14aCUTGFOmNRlRFMkoZjFGpWMDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4832
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyNSBNYXJjaCAyMDIxLCAxMToxM1BNICs4MDAsIE1hcmVrIFN6eXByb3dza2kgd3Jv
dGU6IA0KPiBUaGlzIHBhdGNoIGxhbmRlZCBpbiB0b2RheSdzIGxpbnV4LW5leHQgYXMgY29tbWl0
IDVhNTU4NjExMmI5MiAoIm5ldDoNCj4gc3RtbWFjOiBzdXBwb3J0IEZQRSBsaW5rIHBhcnRuZXIg
aGFuZC1zaGFraW5nIHByb2NlZHVyZSIpLiBJdCBjYXVzZXMgdGhlDQo+IGZvbGxvd2luZyBOVUxM
IHBvaW50ZXIgZGVyZWZlcmVuY2UgaXNzdWUgb24gdmFyaW91cyBBbWxvZ2ljIFNvQyBiYXNlZA0K
PiBib2FyZHM6DQo+IA0KPiAgwqBtZXNvbjhiLWR3bWFjIGZmM2YwMDAwLmV0aGVybmV0IGV0aDA6
IFBIWSBbMC4wOjAwXSBkcml2ZXIgW1JUTDgyMTFGDQo+IEdpZ2FiaXQgRXRoZXJuZXRdIChpcnE9
MzUpDQo+ICDCoG1lc29uOGItZHdtYWMgZmYzZjAwMDAuZXRoZXJuZXQgZXRoMDogTm8gU2FmZXR5
IEZlYXR1cmVzIHN1cHBvcnQNCj4gZm91bmQNCj4gIMKgbWVzb244Yi1kd21hYyBmZjNmMDAwMC5l
dGhlcm5ldCBldGgwOiBQVFAgbm90IHN1cHBvcnRlZCBieSBIVw0KPiAgwqBtZXNvbjhiLWR3bWFj
IGZmM2YwMDAwLmV0aGVybmV0IGV0aDA6IGNvbmZpZ3VyaW5nIGZvciBwaHkvcmdtaWkgbGluaw0K
PiBtb2RlDQo+ICDCoFVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVy
ZW5jZSBhdCB2aXJ0dWFsIGFkZHJlc3MNCj4gMDAwMDAwMDAwMDAwMDAwMQ0KPiAgwqBNZW0gYWJv
cnQgaW5mbzoNCj4gLi4uDQo+ICDCoHVzZXIgcGd0YWJsZTogNGsgcGFnZXMsIDQ4LWJpdCBWQXMs
IHBnZHA9MDAwMDAwMDAwNDRlYjAwMA0KPiAgwqBbMDAwMDAwMDAwMDAwMDAwMV0gcGdkPTAwMDAw
MDAwMDAwMDAwMDAsIHA0ZD0wMDAwMDAwMDAwMDAwMDAwDQo+ICDCoEludGVybmFsIGVycm9yOiBP
b3BzOiA5NjAwMDAwNCBbIzFdIFBSRUVNUFQgU01QDQo+ICDCoE1vZHVsZXMgbGlua2VkIGluOiBk
d19oZG1pX2kyc19hdWRpbyBkd19oZG1pX2NlYyBtZXNvbl9neGwgcmVhbHRlaw0KPiBtZXNvbl9n
eGJiX3dkdCBzbmRfc29jX21lc29uX2F4Z19zb3VuZF9jYXJkIGR3bWFjX2dlbmVyaWMNCj4gYXhn
X2F1ZGlvDQo+IG1lc29uX2R3X2hkbWkgY3JjdDEwZGlmX2NlIHNuZF9zb2NfbWVzb25fY2FyZF91
dGlscw0KPiBzbmRfc29jX21lc29uX2F4Z190ZG1vdXQgcGFuZnJvc3QgcmNfb2Ryb2lkIGdwdV9z
Y2hlZA0KPiByZXNldF9tZXNvbl9hdWRpb19hcmIgbWVzb25faXIgc25kX3NvY19tZXNvbl9nMTJh
X3RvaGRtaXR4DQo+IHNuZF9zb2NfbWVzb25fYXhnX2ZyZGRyIHNjbGtfZGl2IGNsa19waGFzZSBz
bmRfc29jX21lc29uX2NvZGVjX2dsdWUNCj4gZHdtYWNfbWVzb244YiBzbmRfc29jX21lc29uX2F4
Z19maWZvIHN0bW1hY19wbGF0Zm9ybSBtZXNvbl9ybmcNCj4gbWVzb25fZHJtDQo+IHN0bW1hYyBy
dGNfbWVzb25fdnJ0YyBybmdfY29yZSBtZXNvbl9jYW52YXMgcHdtX21lc29uIGR3X2hkbWkNCj4g
bWRpb19tdXhfbWVzb25fZzEyYSBwY3NfeHBjcyBzbmRfc29jX21lc29uX2F4Z190ZG1faW50ZXJm
YWNlDQo+IHNuZF9zb2NfbWVzb25fYXhnX3RkbV9mb3JtYXR0ZXIgbnZtZW1fbWVzb25fZWZ1c2UN
Cj4gZGlzcGxheV9jb25uZWN0b3INCj4gIMKgQ1BVOiAxIFBJRDogNyBDb21tOiBrd29ya2VyL3U4
OjAgTm90IHRhaW50ZWQgNS4xMi4wLXJjNC1uZXh0LTIwMjEwMzI1Kw0KPiAjMjc0Nw0KPiAgwqBI
YXJkd2FyZSBuYW1lOiBIYXJka2VybmVsIE9EUk9JRC1DNCAoRFQpDQo+ICDCoFdvcmtxdWV1ZTog
ZXZlbnRzX3Bvd2VyX2VmZmljaWVudCBwaHlsaW5rX3Jlc29sdmUNCj4gIMKgcHN0YXRlOiAyMDQw
MDAwOSAobnpDdiBkYWlmICtQQU4gLVVBTyAtVENPIEJUWVBFPS0tKQ0KPiAgwqBwYyA6IHN0bW1h
Y19tYWNfbGlua191cCsweDE0Yy8weDM0OCBbc3RtbWFjXQ0KPiAgwqBsciA6IHN0bW1hY19tYWNf
bGlua191cCsweDI4NC8weDM0OCBbc3RtbWFjXQ0KPiAuLi4NCj4gIMKgQ2FsbCB0cmFjZToNCj4g
IMKgIHN0bW1hY19tYWNfbGlua191cCsweDE0Yy8weDM0OCBbc3RtbWFjXQ0KPiAgwqAgcGh5bGlu
a19yZXNvbHZlKzB4MTA0LzB4NDIwDQo+ICDCoCBwcm9jZXNzX29uZV93b3JrKzB4MmE4LzB4NzE4
DQo+ICDCoCB3b3JrZXJfdGhyZWFkKzB4NDgvMHg0NjANCj4gIMKgIGt0aHJlYWQrMHgxMzQvMHgx
NjANCj4gIMKgIHJldF9mcm9tX2ZvcmsrMHgxMC8weDE4DQo+ICDCoENvZGU6IGI5NzFiYTYwIDM1
MDAwN2MwIGY5NThjMjYwIGY5NDAyMDAwICgzOTQwMDQwMSkNCj4gIMKgLS0tWyBlbmQgdHJhY2Ug
MGM5ZGViNmM1MTAyMjhhYSBdLS0tDQo+IA0KPiANCj4gQmVzdCByZWdhcmRzDQo+IC0tDQo+IE1h
cmVrIFN6eXByb3dza2ksIFBoRA0KPiBTYW1zdW5nIFImRCBJbnN0aXR1dGUgUG9sYW5kDQoNClNv
cnJ5IGZvciB0aGF0LCB3ZSB3aWxsIHN1Ym1pdCBhIGZpeCBmb3IgdGhpcy4NCg0KVksNCg0K
