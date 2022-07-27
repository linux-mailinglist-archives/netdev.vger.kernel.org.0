Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A70581DAF
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 04:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiG0Cky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 22:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiG0Ckx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 22:40:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB531D0F9
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 19:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658889652; x=1690425652;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tXclYP85ge7mg1lh6ig++KHyhkvI2GsAnniRSIHaGW4=;
  b=WqnT283i2mLA7wW7dgSpTkldGLsDmuDGpooNBCEVZ3tbmPXmJn5xyw+W
   uAOGZK1Xbp4b17rKgqUKe99LXOyHmZio4WEXDcLI4PXBZ8jNVQgoBKzH7
   KyIfPjUOu2/6k/WLu6dYS8D9nlKUJmTmmRb86c8YPphfhmIiTpiaEXXNM
   cdoftdLP1lM9Wd7KqSXPe6ibiZ1cNwJ/5Djm5Xs3JMY3zjjBhK/BO2K/f
   RF/WGubpCIpwTt+ouA3jlWSNfO1kfd56th9aJv37jM2uYfX41xdzYc9s6
   PaVcbIzJv+xqz6VHIS+o9jbleTRmCRc7tajVS04b9+IidOjLj0pi05skK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="271167697"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="271167697"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 19:40:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="575781180"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 26 Jul 2022 19:40:51 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 19:40:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 19:40:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 19:40:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 19:40:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtEeKVbXWLx51BW32FUL+sOEg0DITL8gb6WHNDt+IkhZVbmMheExy/fmO5DkHltm08L/wY/rwl6824UENYvdkbxEZEBYi1DKF0dvfGSZzQDEDbyW2mma5J3//z+qf2GFAPg0LtcXFO1jVFAcaIQulrkEn+DwtLfdjZKrSJuJHrOGqbvezYP/2rBY9FvlgObMBM7lTEoERs8KuZ8HkoYrIPMs3jky2oERapnaAlWhPHYRNyywPpGHCQGrJwqVJx/l0CdtOuXbhmTY9lf1IAoeF0Nh+vaPrDTXvRYGDNAHXZ4io+H9r1Sm6LnxGraNjfE6V9q8R8Myx1s06OqfM3SI7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXclYP85ge7mg1lh6ig++KHyhkvI2GsAnniRSIHaGW4=;
 b=O/YwamoDcIt+8q0d5B559k/XgG6cUJojswX/4HvNllFc8zh1uoreelkZHUMYAy9mpAO+dmt/pvvAneu0YALdqhxObH8JN/oPsWQeB58zQTFZEq0Hqczu0JlFvJrADtggpjpX9Ea0EQXcyIqcRJtRKrpcNAJ4NId2pRrVSOAFDsVHP0mvPstXcoBGnCi6mwJ0khEe3uKKblwX7/dGUgLWo6NyM+a0EhmnhCu3BakxvP6ub6wMirYNzoZLi2SU5cnuI+oIrGVlaGHPlO2UvmkcIu9VCHHtfduubV65oH/ZqjycvvuDLT/O2Pkn+RIfSRJ10tb/2F8+bBVjSBS/SNxo6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6095.namprd11.prod.outlook.com (2603:10b6:8:aa::14) by
 CY4PR11MB1320.namprd11.prod.outlook.com (2603:10b6:903:2b::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Wed, 27 Jul 2022 02:40:42 +0000
Received: from DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::9103:fb41:29eb:4af4]) by DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::9103:fb41:29eb:4af4%7]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 02:40:42 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Gilles BULOZ <gilles.buloz@kontron.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Marvell 88E1512 PHY LED2 mode mismatch with Elkhartlake pin mode
Thread-Topic: Marvell 88E1512 PHY LED2 mode mismatch with Elkhartlake pin mode
Thread-Index: AQHYm43HCC9yXfUFT0mihPqDV+s5p62GN9gAgAqA/ICAANQwcA==
Date:   Wed, 27 Jul 2022 02:40:42 +0000
Message-ID: <DM4PR11MB609541669084880AF23FDCCCCA979@DM4PR11MB6095.namprd11.prod.outlook.com>
References: <3f6a37ab-c346-b53c-426c-133aa1ce76d7@kontron.com>
 <YtcjpofgVhSRyo+t@lunn.ch> <e6a883e4-0635-7683-cbfe-b4504c9da893@kontron.com>
In-Reply-To: <e6a883e4-0635-7683-cbfe-b4504c9da893@kontron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9ec61b9-0b44-480e-da1e-08da6f796645
x-ms-traffictypediagnostic: CY4PR11MB1320:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P/jVKiz0tjmLXPPm+ybb54Zwos5TO4Uzt8yEnph71hDBmFehlsMRL8NjETorJR7QLfqayuhVwI2prmxasBiG0JKmAZNFRfTk3Wh3iCcWt7iOHZD7X5v0ewQhgNehLuyIj9lyfufJyuWOqIGEG4zyYR4WAVVve9vwPDveYrjxXK72Fv7cY5ZdueihmxZqwWyq0o45SNx71Lz/H1mZHNrTUEffrDCD20rJjEvm46aplIsqx1/ezt9ibY0tdRTeXDnurgJ9PBqFhL+Uqlrn6dGKw4+RrJw/dDmcIS6EDpK4Sf4L8vhmEEBuK6nCHnnKuR600Wx/XSIubljiXgkB7tkvSaRwW27UOyS2QCd3XlyF2OhSiyDe5RLPx7U0zaRQQxY38N6C75NL2GjTt6KlyT6m/3PUs7vhUAEj7okJWUTx9myLM+2m+7jcmh/YU1g0GcFfQ0h4ZIjsBK3ujsWaXO1eQMUQHoOB+DTvvGMqJVd3zatM/gwcY5Xd1T3gh3w7VU5oG8MCpHdynfFov2ry4l+Xb421AcbBItE/IttMksGskuqV5z7Jd8fiOYqu3AsDQis9/aka3VgL0k+ZXSj/N5s5LxqoIE4C5qZWacCFsobU6KlTf7Gy3cch6dfPXJewLZEnfB2lIkk2H+EScbfXcjH/s5rkxWGuH6OF6l6AiGDH1sIBPWt9gCMRaTRLZ72cYF6mhBPbKt3U9z9uWLxw+DOjzsI/ZUZAE8hxZrVieY77ROeLXFEF8HogSpcOUVK6G2QB+6cS0o7jo9krH1t30XdzFs8Y+sRYJbpKKq/aIIcn2vA6DT/Cg7Z3wsYqkQiHtEuX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(366004)(136003)(39860400002)(346002)(316002)(6506007)(186003)(86362001)(122000001)(41300700001)(83380400001)(7696005)(2906002)(5660300002)(38100700002)(558084003)(38070700005)(4326008)(82960400001)(66476007)(55016003)(26005)(9686003)(8936002)(478600001)(71200400001)(33656002)(110136005)(64756008)(66946007)(52536014)(8676002)(66556008)(76116006)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wk5udVJ5THZha1JnT1lZK3F6WkVyRERBdldkOTZ6NWU3UWpSSEhDOVdHdmNo?=
 =?utf-8?B?K0U5RU9PcmFZLzB3UnZvRmJCTkplMkQyeWkwVjFQZi9JRjFpZUhwVzJzaWcw?=
 =?utf-8?B?SnFCM3lVOUlWWlNYUHI0RlFUOTF6aEFSVDc3Q1hFVkJRNzJUK1dmcUE3TCto?=
 =?utf-8?B?NS9SZXFGa2x3eFJ3U3Jod29MM3QyNGQxZWhUOVB4eCtROUQrSktZNGVHNnFQ?=
 =?utf-8?B?ZVo4NnNmMFBISjd3RFo1Wko3Tk9QQ256emg4QkpaZTRueE5WRk5wU0JtV0hK?=
 =?utf-8?B?WFpDQkdaQkxaQk9uc1R1VXljWllTTW0rMVNwVDdFVHFtTTNaaTM2UExmdTl0?=
 =?utf-8?B?YytFRFRSWHQvd01lTGZtdXNRNTB2WFBJSzRJYjluTFRSV1NsbXJiZFczbmxQ?=
 =?utf-8?B?dU10TTZBWXNMWjYxemRUZ2piaWNoQ1U0ZTI5NWJVcmw2cDlIeHRDeEtka3ZI?=
 =?utf-8?B?WEptODZTRk5pSWU4dWlSNzRVbXFTZ2M2bGlLd05zak5NcFZERUNTenFuZHVO?=
 =?utf-8?B?bThNaFVyU1VUd1M3dytuZ2ZpR212ZjBwbnlyNlNwWi9yeHlySWsxSDZ3VGtM?=
 =?utf-8?B?UmFOdTlMY3Jla0owc1Q2R0w1bVF4SFFTcUkxanNpWnJ2SjczSlQyczRGYy8x?=
 =?utf-8?B?VGtUL29sWXlJZjZndVhMZGdNK1lSN05GUGs5UWZ2ek5MVEdoSmZqTlhMN2N5?=
 =?utf-8?B?cTV0L0prZEd5WVBRWndSQmJ3bW0rMC9oZFVrMWw0UXViaTBsVk1IRzhod0t5?=
 =?utf-8?B?SlY4UjVpQnMzWXd2MnJ6T1AySlhVd0hpNCtYR0FnWVd0cUNCQmFybUVsYVdM?=
 =?utf-8?B?blhZVkJIdDZUd2hmdDZWcXJSTUYvN285eXpBQWdWdGJYSW93TzBQT2dleURk?=
 =?utf-8?B?aXczbHJEVWZ0VkY0N2Q2UzJMOFh6R1pyVEdNVWtzbTE3Q0gyUlhpSkt6UFdG?=
 =?utf-8?B?OUZmSnhWMlgvMW1hR2RQcmVJSHRrUjNESGV6MHRDaWxVMlppVXBWM3BJNFo3?=
 =?utf-8?B?alY5QlVkQjFoMUtlZ2FZRHNzWUlLTXRyUHlpQ3MxK1F2N0ZaajNMN3JjcGhT?=
 =?utf-8?B?L2hmd1cxTU9pQUtSZVZtVEtmbXh6WU9rM1I3VjQ1dTQrVkFhNFlTY3oxK2FY?=
 =?utf-8?B?d2M2SkJGYmZtMERzeWJaMkpGekdkaXQ4WTNQUG1EQ1V3YkdvclowZjRzY2Rk?=
 =?utf-8?B?UURTS09TdUVTMDFicmZKL0FiaHRIN01salEvbGZSRC9SaDFGS2I1M29pdUNR?=
 =?utf-8?B?Um1qQXkzVnlNT1JSb3RibmRzSEJ2N2dlNkZVcmNka1dQZmM5MzJHY1VtSUtF?=
 =?utf-8?B?Z1VmckJ0SUhULzRPUHN3V2ZvWVFWVW9CZlQ0SDNMWFJieTZFVEpqUGU0bU5S?=
 =?utf-8?B?am5HcXJobzAzYk92cVExSkxGYXJUeXJBYTlTV1dLVExZQllCM21HNGxhN2xH?=
 =?utf-8?B?LzF0TlZPdkRZbVRTMHBxTTdxelkxd3RhZGplUnc1b3h2ZjJsZ0pPcTFUOGZq?=
 =?utf-8?B?eWRITzJxTE9GSjJMYnVHNllHZmFzUldoMW5IZzQ5NE9IVzFwOVFSaWx5K0d3?=
 =?utf-8?B?bmxCMFo4UGtaR0NBNGplVEh2LzQrUE03VjNrdDM5S1Q3Mjd2K2d3Vm04NktO?=
 =?utf-8?B?Z2VPQ3V4T3FFNkk0bGdMVXlYWkFEUnZUUEEwalh2MHBJbTRQM1pZTVZjZFh1?=
 =?utf-8?B?TjJEZUhKS3gwTDM3UHdnc2VGSElERi9Ka3pjUWNhbkNZMVVicVhVdklTVkI0?=
 =?utf-8?B?L2ROTythY0c0ZzBPWHQzS0JtQjhBNy96bzJCYldvWGNzNFUwVUp3Y2ZQajdq?=
 =?utf-8?B?ZnNPT1dKWnFCR1h5d3A1TnpXOVFkUWFlTzVwWkY0Yk9ldXFwZXNUU3h0RmNC?=
 =?utf-8?B?Zjd5NzF0TEZ1Z0RHOUg4SER0K3lHR2hmS2hIaTZPWVIrdllzY3lIbnVWYTN5?=
 =?utf-8?B?b0dSYkJoakJiSC9iNGg3WlFWTXVscXJ0MjNKdjZXRVBJUjlwdmQzQkFjV2Za?=
 =?utf-8?B?UEJ6L2FVTVh0b3crUVJjbnNOcXZReGFWQUtDTXk3ZXo2UHZrU1ZnR2pQanZj?=
 =?utf-8?B?Y3owcTJmeW9HTkluWkhrSmQxWjdReEl6aDdiK1ZUb3dkKzR4OXlNblA1RXUr?=
 =?utf-8?B?d2FrVmMwTDdTTG90ZnUyQlozUWZwYjFnOWFEUzlkZGtKNTNBdko2UVl3UmtC?=
 =?utf-8?B?M0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ec61b9-0b44-480e-da1e-08da6f796645
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 02:40:42.3457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mn4A8E1xTULQ/gIh6mYLywRrttdrcPGF37GSRgtfR5SkH1f/nVEkmj7lT993gwN5NNerBnBGhwcfjWDjnRbpoVoazY2nCR/XspHURUuIgWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1320
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PklzIHRoZSBQSFkgaW50ZXJydXB0IG5lZWRlZCB0byBzdXBwb3J0IFdha2VPbkxhbiA/DQo+QW5k
IGlzIHRoZSBQSFkgUE9MTCBtb2RlIHdoYXQgd2UgaGF2ZSBvbiB0aGUgRUhMIENSQiAoSSBkb24n
dCBoYXZlIHRoZSBDUkINCj5oZXJlIHNvIEkgY2FuJ3QgY2hlY2sgdGhhdCkgPw0KDQpHaWxsZXMs
IEkgaGF2ZSBzZW50IHlvdSBhIHNlcGFyYXRlIGVtYWlsIHRvIGNoYW5uZWwgdG8gcXVlc3Rpb24g
dG8gaW50ZWwgdGlja2V0Lg0KIA0K
