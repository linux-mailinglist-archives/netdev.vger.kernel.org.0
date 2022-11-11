Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754926251D0
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 04:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiKKDkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 22:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKKDkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 22:40:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAB4FCE4;
        Thu, 10 Nov 2022 19:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668138034; x=1699674034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uMi7mAW6CqMC3VrxGZmibF/Bsj84t22WSfnVBGxmhSE=;
  b=V4s2OOh62RtsEV5cPBDTB6Gr2LLNlPz3xmmlj31NcUHErAjkHnC5v0FL
   VrPWZfCjoKu+8f747P3TExR5ilv7KZSXTzbGTKmlkO+oqqrn3cBc49pk2
   iUPs9LSwOaVOAAwMnbR97ewWa1Y5kCkkIpKKcg/fhZYtEY6ZpIDqgCpRH
   /Hd17hOQvUarCeb943PMDyszyZPdbwMZywImdiszPTHk8gP4ig4wnrK0X
   df/VgFd7CF/ivJpIAt0SUP9wIVzwL9G5R8FP7z0v0WVY3z5L8tUZS33SR
   wn0IZ+uFcQuosYSM/hlb+YFmOUM7XmbTVUp2IuILXnrJhT6FSt0h8rlU3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="291235802"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="291235802"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:40:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="780035094"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="780035094"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2022 19:40:33 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:40:32 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 19:40:32 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 19:40:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGEPsUokw6E0kNT9efmbuULEk6Fg7WFX8xKQjYF5uLLMpsGV0GTGGZyooq8MKrKg7b5/ygxkLC2RxiZNlf3IQTxnyTZWdq6/mfDEfMcVYy6yDomZtzRH8rCohZ15+PAMlwXC6ahsF4vUzsgoAwQNz0OBn/lis8DjeWG9gqhaEsIVXDAcXVpWMnyg1c2Jzzl4ZdfKAfjHUNfBj62gd3Dpi+dinpdiLB3RXKUpBkXfr3i1Sk/0GfFrwgVU3lEyKuUMarM67nrwpG9YH4cje37DNMx/bJBvdofJIuZ5s4WOKyAg4qyPugO2R9fOBFG8Jx08XyCpfoFrSS4aiNo+RYyDlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMi7mAW6CqMC3VrxGZmibF/Bsj84t22WSfnVBGxmhSE=;
 b=HCB0u7C4Gq4XAtTJcC/Awn4Dd0AxH6XV0JWJjcNmPEr9ftL9w0cezZHFP1emF51MMO8E6cfmcSCjIvjtLPOAAucd7iqJWX/YBbuxuNdyLwvj09CMqZc64W0yOIW54SbCVs7SdntrS4KZr7Nr0jK55t7XtJs1gJjUf5xtxYmMPH9Lj6HegQlfQxe+q9SwwZ6V9wD/5qyyenRg+81TgB9TVoP6fULpSPTqSNBxZaxVrVDCi8IPsRMoOUZu/1ImppUeBhflPBgH+DTBljgmiDSaveCuTgIyfk98usFS+r1RlPKNS5prnPo21IhMn3ePMP/gHw6ii4KTTl/h0/k+r6HdAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4348.namprd11.prod.outlook.com (2603:10b6:5:1db::18)
 by PH7PR11MB6006.namprd11.prod.outlook.com (2603:10b6:510:1e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Fri, 11 Nov
 2022 03:40:25 +0000
Received: from DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::7c3c:eff3:9f4a:358]) by DM6PR11MB4348.namprd11.prod.outlook.com
 ([fe80::7c3c:eff3:9f4a:358%4]) with mapi id 15.20.5791.027; Fri, 11 Nov 2022
 03:40:25 +0000
From:   "Jamaluddin, Aminuddin" <aminuddin.jamaluddin@intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>
Subject: RE: [PATCH net-next v2] net: phy: marvell: add sleep time after
 enabling the loopback bit
Thread-Topic: [PATCH net-next v2] net: phy: marvell: add sleep time after
 enabling the loopback bit
Thread-Index: AQHY80Xv5uvGNid//E6fpHCVkDBna643iaEAgAGKn2A=
Date:   Fri, 11 Nov 2022 03:40:25 +0000
Message-ID: <DM6PR11MB434878AB5C2EF33DF8F5580D81009@DM6PR11MB4348.namprd11.prod.outlook.com>
References: <20221108074005.28229-1-aminuddin.jamaluddin@intel.com>
 <e1640d1f-f143-7b0e-8adc-002e115ef7f1@gmail.com>
In-Reply-To: <e1640d1f-f143-7b0e-8adc-002e115ef7f1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4348:EE_|PH7PR11MB6006:EE_
x-ms-office365-filtering-correlation-id: 00547f88-7154-4615-2b41-08dac3967850
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MIbC44KV4B2nNB6Q9/DRVuyGdPJ5vJRynm/ta418o+dfTtFeXB1FnV/mUbNcfwZEqJJWBwIkxdQ5lhwn05RzY12ZKF4hTyiJmqAAkccNsKFqJceMyaarpHaNOPYVaH+1lznmEXOeWbQSXbnTvlmvgMvDshXA9QMU7D3kQdTYnotSBGJ4zoESQThi6Cb0YA3gBGtsg2Q+SzHBUbI3e6tS6QiBgpzh+f9RfRFqQAqIapzjmM7zHP2kUGjY/pR2KCUg7uu5ZGzV0nPBXX+P9F3aW9rIS2MrzreENCUrbSqxfNUnzuGcCM5SBuILwYhkuhCLdGrF9HamNiZQjbD/vVx30ZemoBUtej24bLua1HJUE0KHWtBmF1/sABVnnEfuB4k1p3tSttEiDY6tHfTUeV+FO3nfoCRBIQqpRAtj2agNJWCMV2s1B+UEpEupvYZdbnsNcCItzDSMSFj++MpNFBBZifHSJkbw1CzksxTI5dTIW3FWzuwNnsEUi6TZT0SY+wQmEx4j64NDMsPtKPYTnPiB5YQ2OGrg7dqPyvVuq/YDSkxkSY1A3Y68Kx5luL1jXa3NEkbKRqDKvATzSaHaD34tZczcQ24xPosS2TEr+5k6gKW9zJo03gvNpG3SCS7vuaAu2nCLqvsZYGmetMTPv++OLpb/UwImss5j99u2Ag15BmY1DnCUW4G/p07d4O4YIgdVaO7FFpR9lHVQWgRYz2fJORLFC4BPiZI4FXIb+cJVDSgQGGuQLqepTQIxAR6WwxXAp7U94HbIpmYFPGg4Nl29GQhYHcTBBuHh4vO/oVlhBQ/2gjqcVMs8qIGdS0CF+xng
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4348.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(136003)(346002)(396003)(39860400002)(451199015)(38070700005)(54906003)(83380400001)(6636002)(64756008)(4326008)(921005)(38100700002)(9686003)(82960400001)(122000001)(26005)(66946007)(66556008)(5660300002)(8936002)(7416002)(2906002)(55016003)(110136005)(6506007)(186003)(53546011)(966005)(71200400001)(478600001)(76116006)(66476007)(8676002)(7696005)(41300700001)(316002)(52536014)(66446008)(107886003)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjFJVWx4dkVBYkF0Mzk2VkJ1VzNGWUwrUHNwTEsxOW5OQmdmdkxKbk9CZUYz?=
 =?utf-8?B?RG8zeEtkVEx2T1UxbW1wckU3d2crdDNVMC9HTW4xd2RzT3orWEJKSkpZL2dW?=
 =?utf-8?B?Y3lEYm5pTll0ZVlkQ3B0V1FVa1FoQ05zdVlLM0lJZkRoYnA2bGZDaDZRYVlF?=
 =?utf-8?B?dDlYaUNwK2xPREU2dnM5UjBpcTdHeStpdXNjeS9Sb0JkZ0VzZXovZi9oYVRj?=
 =?utf-8?B?eWx1STdvK3M4NDN5ZjBZZ1RrYmdGT0xYblBHZTlBOHEzejZJci9TemdrMTZM?=
 =?utf-8?B?TkJSY3M3QS85SzhGL1dRNWZxeWJ5QW1kem5wcEhhN0EzT2lFaEN5Q21mNlNN?=
 =?utf-8?B?aHVvNmw1VTNLUGpNTm0vV3UwVHhxWUQ2TVJlRzgwK2VsUWFOWDdCdU96cVQw?=
 =?utf-8?B?OGI4MUplQy9KdE9EZDh3OWs0Y0xGV3VkR294bitndmVDZGFPb3FKbWlrMW9x?=
 =?utf-8?B?VlZodU1UTWxlVXkycnFYUUltMDJDZjBabkhRS1p4Q0xLNWpvZytGSE1LNHYx?=
 =?utf-8?B?UVlLYUZqZmtuTWtudmRLNWdZc2QvRjhlWVlEZEc3eUZUYzRjWThPZnRBOTUv?=
 =?utf-8?B?bUROZkVyeWZTaWw4eE1Ob0Rlc1I1TG9Yc0R0cERheEJjWHJneEszN1Q3Tkk3?=
 =?utf-8?B?c2Z5SS9iblpsK3FGNXRITjIvVjkzZWgrc1NURDZ2WTEwaHJIbkJ6dlFXMU93?=
 =?utf-8?B?eS9kWGdxUklMSUVZNGZoLzVJYW5PM3ZSanJMRW9nMncvOTNqUVJZZnhBaG9D?=
 =?utf-8?B?QVVyK0tRZWdLbUEzTzdJZ1lhTnFuLzltOGNmNEdNbWxzZTVlbzVRVHhXNWFu?=
 =?utf-8?B?QW02UTBQZ0dDZ3MxbGdtNFYrK2lQZ25YL1RJSTMzNWFpeEE4K0hVSnpJUkF3?=
 =?utf-8?B?RU9JTk5DQ3ovQ2JNRnNaYkQ2ZWc2RTA4MGtrYmhhK2M3MlE4Skh0QlZOdDZC?=
 =?utf-8?B?WkRNa2NpWEM0T2hyL2t2ZzlSamNybnFIbzR3SUk5UFpNSU4xVVlpYUtES3h4?=
 =?utf-8?B?YTFEeUtkcHlHTGhkclpPZytzY3VMY08yWm9QWDB0aldVVElaZDU2U3B1YXhI?=
 =?utf-8?B?YWZ4U3JZTWhYRERhcnMvMkFwd2NqVG40UHdQWGRLSG5pMDVuYUIzTzEwUENm?=
 =?utf-8?B?cU5US1B2WGpFRHVuUUxVQWUwS0p6N0JycEFyVkd5RFprcDI0NHBVODJRUEZQ?=
 =?utf-8?B?NVM5Z3J0TzBmVHVmMWx4bG1tdCt4YUNrWHY5elpvMnZpS041dCtqNC9malJi?=
 =?utf-8?B?RlVVUDA4MldKcTBjeVNBQTE4TXFGNFRoRG9MTEVJYlJvSXk4UUowYlBCeEJm?=
 =?utf-8?B?bTdBdVE3ekFMd0t2b2RIVXMzT3NFLzk2MGRIajM0OVJvUlJxYmZCeHlxTTds?=
 =?utf-8?B?NmUrSWpTemhlSkNaUE1wMUVaQ2krd0VYUGpvWEo2dEVTTW94QU80QVRlb0o2?=
 =?utf-8?B?c2Z1bGJ1VHpOclZMOG9xbm53R09Fek5nV2lid3dXVXRUOGpMYnJjdFRnSWFn?=
 =?utf-8?B?WjVPTU5KUXArSXBYQnlIaFQweFBhMEQ3WHBGRWczbVkrc3VGcmlXU2R4anV1?=
 =?utf-8?B?ZTZjaGF3bTRobzI2QU10VW9LMS84Zld5eWhKRUlXV1NleUZUc3VBOXN2aW5C?=
 =?utf-8?B?ZnBwSUFubGJ1NDhhS3A4NnM1QlRMWlpZdE94N2lLeVhDdHdueHg0bmFEOFZ4?=
 =?utf-8?B?OVdtbnBqdW9NeERBVFA0SFdFcG96c3ZKQ2JEUS8raS9NSVZLeHZZK0Y0S1Rr?=
 =?utf-8?B?bS9TeWpzNmIydXk4TXF5TXlzaGZWanVKOWMvcWR3UjBMaHRjRzFGTCtlUklX?=
 =?utf-8?B?NXlScG4wbGx0S1NSdUJyMXJtWjlMM29VZ1d6ZHlFTFYwbnMxMTdyZ0I0ZmJC?=
 =?utf-8?B?TCtZaTcwbXpzYUpqUCsvaU1kTEx6UnYrbDYrZ1RRWVpFZTFLVUEzZmhuRlQ4?=
 =?utf-8?B?K2c4dE5HcEZGaTRsYjdHZ0UrU2hUWi9qR0FWZDlsZ1RTZnFsdDdIZ0F2SWdk?=
 =?utf-8?B?bkdqWG02dDlXWlBORXdDNlZpQzd6QVhRUGIrUDM1Z204L0hiQm9GZlFvVG0z?=
 =?utf-8?B?TmhLdURpZWlobGZBendZL2p6MDY4Wmo2eUFHanRQTkx3bXAyZFh1b2gyMUhF?=
 =?utf-8?B?NGRPb0FwalE4Qzdyb1RwNUwyeXZDaXFuY1Nzd0VXdHZrQmNYR1BlSzh0MkUy?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4348.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00547f88-7154-4615-2b41-08dac3967850
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 03:40:25.7064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uv9T3NnnOcrb2KTqc3c9/IpzK8wAEuZVJFQ8sVewJVh0QHfEoH+lIxsen0HZX5dsAiA6FF7LUpzF1pnU3y/MzFqVc3VIjjFne+O0fx74XqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6006
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIDEwIE5vdmVtYmVyLCAyMDIy
IDExOjU0IEFNDQo+IFRvOiBKYW1hbHVkZGluLCBBbWludWRkaW4gPGFtaW51ZGRpbi5qYW1hbHVk
ZGluQGludGVsLmNvbT47IEFuZHJldw0KPiBMdW5uIDxhbmRyZXdAbHVubi5jaD47IEhlaW5lciBL
YWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+OyBSdXNzZWxsDQo+IEtpbmcgPGxpbnV4QGFy
bWxpbnV4Lm9yZy51az47IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBF
cmljDQo+IER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPjsNCj4gUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsgSXNtYWls
LCBNb2hhbW1hZCBBdGhhcmkNCj4gPG1vaGFtbWFkLmF0aGFyaS5pc21haWxAaW50ZWwuY29tPg0K
PiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZzsNCj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgVGFuLCBUZWUgTWluIDx0ZWUubWluLnRhbkBp
bnRlbC5jb20+OyBadWxraWZsaSwNCj4gTXVoYW1tYWQgSHVzYWluaSA8bXVoYW1tYWQuaHVzYWlu
aS56dWxraWZsaUBpbnRlbC5jb20+OyBMb29pLCBIb25nDQo+IEF1biA8aG9uZy5hdW4ubG9vaUBp
bnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjJdIG5ldDogcGh5OiBt
YXJ2ZWxsOiBhZGQgc2xlZXAgdGltZSBhZnRlcg0KPiBlbmFibGluZyB0aGUgbG9vcGJhY2sgYml0
DQo+IA0KPiANCj4gDQo+IE9uIDExLzcvMjAyMiAxMTo0MCBQTSwgQW1pbnVkZGluIEphbWFsdWRk
aW4gd3JvdGU6DQo+ID4gU2xlZXAgdGltZSBpcyBhZGRlZCB0byBlbnN1cmUgdGhlIHBoeSB0byBi
ZSByZWFkeSBhZnRlciBsb29wYmFjayBiaXQNCj4gPiB3YXMgc2V0LiBUaGlzIHRvIHByZXZlbnQg
dGhlIHBoeSBsb29wYmFjayB0ZXN0IGZyb20gZmFpbGluZy4NCj4gPg0KPiA+IC0tLQ0KPiA+IFYx
Og0KPiA+DQo+IGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9uZXRkZXZicGYv
cGF0Y2gvMjAyMjA4MjUwODIyMzguMTENCj4gPiAwNTYtMS1hbWludWRkaW4uamFtYWx1ZGRpbkBp
bnRlbC5jb20vDQo+ID4gLS0tDQo+ID4NCj4gPiBGaXhlczogMDIwYTQ1YWZmMTE5ICgibmV0OiBw
aHk6IG1hcnZlbGw6IGFkZCBNYXJ2ZWxsIHNwZWNpZmljIFBIWQ0KPiA+IGxvb3BiYWNrIikNCj4g
PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgNS4xNS54DQo+ID4gU2lnbmVkLW9mZi1i
eTogTXVoYW1tYWQgSHVzYWluaSBadWxraWZsaQ0KPiA+IDxtdWhhbW1hZC5odXNhaW5pLnp1bGtp
ZmxpQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbWludWRkaW4gSmFtYWx1ZGRpbiA8
YW1pbnVkZGluLmphbWFsdWRkaW5AaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICAgZHJpdmVycy9u
ZXQvcGh5L21hcnZlbGwuYyB8IDE2ICsrKysrKysrKy0tLS0tLS0NCj4gPiAgIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvcGh5L21hcnZlbGwuYyBiL2RyaXZlcnMvbmV0L3BoeS9tYXJ2ZWxsLmMN
Cj4gPiBpbmRleCBhM2U4MTA3MDVjZTIuLjg2MDYxMGJhNGQwMCAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL25ldC9waHkvbWFydmVsbC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvcGh5L21hcnZl
bGwuYw0KPiA+IEBAIC0yMDE1LDE0ICsyMDE1LDE2IEBAIHN0YXRpYyBpbnQgbTg4ZTE1MTBfbG9v
cGJhY2soc3RydWN0DQo+IHBoeV9kZXZpY2UgKnBoeWRldiwgYm9vbCBlbmFibGUpDQo+ID4gICAJ
CWlmIChlcnIgPCAwKQ0KPiA+ICAgCQkJcmV0dXJuIGVycjsNCj4gPg0KPiA+IC0JCS8qIEZJWE1F
OiBCYXNlZCBvbiB0cmlhbCBhbmQgZXJyb3IgdGVzdCwgaXQgc2VlbSAxRyBuZWVkIHRvDQo+IGhh
dmUNCj4gPiAtCQkgKiBkZWxheSBiZXR3ZWVuIHNvZnQgcmVzZXQgYW5kIGxvb3BiYWNrIGVuYWJs
ZW1lbnQuDQo+ID4gLQkJICovDQo+ID4gLQkJaWYgKHBoeWRldi0+c3BlZWQgPT0gU1BFRURfMTAw
MCkNCj4gPiAtCQkJbXNsZWVwKDEwMDApOw0KPiA+ICsJCWVyciA9IHBoeV9tb2RpZnkocGh5ZGV2
LCBNSUlfQk1DUiwgQk1DUl9MT09QQkFDSywNCj4gPiArCQkJCSBCTUNSX0xPT1BCQUNLKTsNCj4g
Pg0KPiA+IC0JCXJldHVybiBwaHlfbW9kaWZ5KHBoeWRldiwgTUlJX0JNQ1IsIEJNQ1JfTE9PUEJB
Q0ssDQo+ID4gLQkJCQkgIEJNQ1JfTE9PUEJBQ0spOw0KPiA+ICsJCWlmICghZXJyKSB7DQo+ID4g
KwkJCS8qIEl0IHRha2VzIHNvbWUgdGltZSBmb3IgUEhZIGRldmljZSB0byBzd2l0Y2gNCj4gPiAr
CQkJICogaW50by9vdXQtb2YgbG9vcGJhY2sgbW9kZS4NCj4gPiArCQkJICovDQo+ID4gKwkJCW1z
bGVlcCgxMDAwKTsNCj4gDQo+IElzIG5vdCB0aGVyZSBhIGJldHRlciBpbmRpY2F0aW9uIHRoYW4g
d2FpdGluZyBhIGZ1bGwgc2Vjb25kIHRvIGVuc3VyZSB0aGUgUEhZDQo+IGV4aXRlZCBsb29wYmFj
az8NCg0KUHJldmlvdXNseSB3ZSBpbXBsZW1lbnRlZCB0aGUgbGluayBzdGF0dXMgY2hlY2sgdGhh
dCB3YWl0aW5nIHBoeSB0byBiZSByZWFkeQ0KYmVmb3JlIHRoZSBsb29wYmFjayBiaXQgYmVpbmcg
c2V0IGluIFYxLiBCdXQgd2UgcmVtb3ZlZCBpdCBkdWUgdG8gc2ltcGxlcg0KYmVoYXZpb3VyIGFz
IHRoYXQgY2FuIGJlIGFjaGlldmUgd2l0aCB0aGlzLiBBbmQgcHJldmlvdXMgZGlzY3Vzc2lvbiB3
aXRoIE1hcnZlbGwNCnN0YXRlZCB0aGUgZGVsYXkgdGltaW5nIHdhcyBuZWVkZWQgYWZ0ZXIgbG9v
cGJhY2sgYml0IGlzIHNldC4gDQoNCj4gLS0NCg0KQW1pbg0K
