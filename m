Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542696D9AC6
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239269AbjDFOm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjDFOmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:42:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD2E9ECD;
        Thu,  6 Apr 2023 07:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680792056; x=1712328056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wf1Nmtuk+PLkEaTkp2gv/vOTbJIP5/Vkhy+RsXmDrno=;
  b=iYTRAt8Ex6ElrtNLJmr6a8b1iKdIL35QLJX5R17fPCX49bvGd4WJsVYB
   vK2kq7ORfwWSfDolx7R/PODfsMXrCKWZlZHDJfAibRtAQf5pXpwf4wCpN
   juekrbr3Xwa7jIsZkxMX+FSdwQt6vRZHJ8tWu7dhtk0KJJb4tWjPfckKW
   AHFhHpDCX9Bzh2N0fKiRilU5TZMtT+zTxrNWUbZT4/l0F1BaCdtsibd3Y
   ETfmvyMDCaX+gJZ5O7dr9pJoJRxJsm4j+RiRYllHT2hbHCarnurekHuIN
   tHfbqyWg31GkSQ7x4b+cnKY2SkP4z78MPgfM31BpFM2WyTFmGJn1zmBiS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="326816341"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="326816341"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 07:40:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="756384150"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="756384150"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 06 Apr 2023 07:40:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 07:40:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 07:40:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 07:40:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzgmMaa4N0C9Qc++eYnYmFaKAdfRf38NUH4Xc/NEWCs/eJyy9s1gUz2NKH2eaAqnw6caKYGws7jiw8VVgWDhmFIHvT50BFG+JQfDbWBUaIm4qGT52hFhDl9GCObPWzkIpH0mazM40uZ8MGFM9WCUIAEhczvsTDWHXMADVji3mxEN2R7R6Frqei78+OnzdCAn84lARpSVta8xc0dtwzGkkOkVa8a0Suv+KvTypX5QVaxZ3pFStfoU2DO8SQDl3oo4ln9Gv5krdADySeLBoHNO4rua1x91hZX5biKzgEo3CB71WKo7gdX6RQifkbNXA/agwXOclL4lhimd6aiHqM0mhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wf1Nmtuk+PLkEaTkp2gv/vOTbJIP5/Vkhy+RsXmDrno=;
 b=WEoSGHEauKxCpTr1PkSTKRpSQCjdmUQnsGpIZ+0dZ/Kn0cFVi+0ZtEfYC5+u2DxDcQijRvcLRlyjc1Rg/LKxBV/WO5p709lq7KSJqN8a3ZsB0OM55dlv9k6l2D84RdrwPIGMhfEpvM5f+hqdrXp1M2AQ27Ph8NlIMh1I3I50RxDGxt2msBSQIbHVEg+APwXmjyPAyb+6uFSRoEr/4Jt396W5eJxnuvm9VsTChTBnMnXVp0/vz+Mp/67XodYSCEQ0lI4MSLD7DZ48qgI/JxwX0tvu6HC6pmk/LPTOIu5biFNg9950mHzfIvH+tEyoiBz0PmKkhPSdlpDjnQXpN6fhnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7587.namprd11.prod.outlook.com (2603:10b6:510:26d::17)
 by SA3PR11MB7625.namprd11.prod.outlook.com (2603:10b6:806:305::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Thu, 6 Apr
 2023 14:40:37 +0000
Received: from PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::7237:e32c:559e:55e2]) by PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::7237:e32c:559e:55e2%6]) with mapi id 15.20.6254.033; Thu, 6 Apr 2023
 14:40:37 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: Re: [RESEND PATCH net 1/1] net: stmmac: check fwnode for phy device
 before scanning for phy
Thread-Topic: [RESEND PATCH net 1/1] net: stmmac: check fwnode for phy device
 before scanning for phy
Thread-Index: AQHZaJROHmBSV0Yy2EyBOhYca/DIuK8eWlcj
Date:   Thu, 6 Apr 2023 14:40:36 +0000
Message-ID: <8E023389-DDC8-48E4-99FC-94CAC9543788@intel.com>
References: <20230406024541.3556305-1-michael.wei.hong.sit@intel.com>
 <20230406072504.68e032e6@kernel.org>
In-Reply-To: <20230406072504.68e032e6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7587:EE_|SA3PR11MB7625:EE_
x-ms-office365-filtering-correlation-id: b2a9b7f2-dc7d-4f3f-b940-08db36ace2b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eMIDyXKw8zle30ieG73mKujaK+HCRVp2/CNnai1bmjtR6ksfWQwJyQeCKtNoluydsYi3G3uHEaZTE9AmXUWgDflXuLgTGd3vS9mAZ6+6FwJMGlJygdwX5YpYIcHU/KUFl4FjfzZ7Kxlol2E8PA1rjSj68mOIFIdWOYX3C4qkjCpXqAEScvLe6eUPuiMPovtW3vSVe/IBOEhVVwoGClSc//PTlurPRWXGV0GxdBx6heNVRvUb3MaptFOe9bcdyuYhDtNYlvKMraniwL+EM9SgwNN8N15Q9CzoSiGB7f4hAdeZMu77thKB2ptA2MOHTGC6FZgECgi8R7K6k4x6EHbpByEXUI7OoklW7b+OQkVp7XEpSgG0HaQXFF7SKHiJUb6aMbmJ7QXll5wMyFOyFzW215hO5/QXuadjbDvhk6g5C07fUyiWZkZFaHB4Sxp2DNigWVISP8C3D2Q8Qm3hoz3XHzAo4sDXfEPfAghRHPq1mbj3dxkmbhPga+sZSC9uffNnJH7M+0Ph1rKXlZHwg4WzUUQwRKajjv+9Jaol+xMMxNlhTlVJM/+Q//kmligo53ufg12VquO1uGBJRmcy2bXRwVKLj5aPJ1qQCnXK2RHqvSoTHSjyZxFmklvg//yjVOkeucAtpjfLJ6IOX/Ql2fCfNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199021)(83380400001)(6916009)(8676002)(82960400001)(4326008)(316002)(66946007)(66556008)(2906002)(41300700001)(91956017)(86362001)(66476007)(76116006)(122000001)(54906003)(64756008)(66446008)(33656002)(36756003)(478600001)(71200400001)(38100700002)(6486002)(2616005)(8936002)(38070700005)(5660300002)(53546011)(6512007)(7416002)(186003)(4744005)(107886003)(26005)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2dSUGdXcWxZM0RvL3IzVVV6NVE0em81akRpMlY5SFpmQzJQYlQ3cFYvcGxJ?=
 =?utf-8?B?NldpcHlQdzZCZFNGdUhRSnlWWGd4d3VJbjN0eXVkOGNFQkU3MmNlU2JZeVJC?=
 =?utf-8?B?L0NEZE9STnBmTFBFWjloWFZqU3NhZlZnblNzTXhpMGdNNTdRTXBMTlY2TFIz?=
 =?utf-8?B?b0VHSjJpdW9DVENEZjJ1RDNCdDdiSXhiSTZGaHY0clMrR1hLbEVoWVlUUFp3?=
 =?utf-8?B?TFdYRUZnZE1LM0U3c0lnWlhlNkpKSWJiSzZWQ2h0bExteXNRS0tEZ0lWaGVq?=
 =?utf-8?B?Y29YSy9XVG5IV3dlRjFXSUs0RDEyRE1NZ2VPdGdGRXlRUTJKZElaWmJqZEdh?=
 =?utf-8?B?Q01hYmZpNkVRSXJOY09heVl4TkZHV0hNbXFSUzJLYlZpSXROQlVKS3JFUTFZ?=
 =?utf-8?B?cVJBQVFvV1NPQktxbGgxYzFFUkJNL0tjRncrMzBuRFo0YVhjR3lsZ1V1M0dt?=
 =?utf-8?B?cEpDWk44UXBSZkV2MUpNUjhBZ0hBa09oUS9KSkp4MVRsZ0ozelNhR1JlYWJl?=
 =?utf-8?B?cVlxSGpGUGpTTzgzYUpDZzA5bW1NTDNFSkJWdzNKTkdHcFN0Ris3WVJOd09I?=
 =?utf-8?B?UFJ1MFd6azhEOVhrNjJRMDJtcDVCQXY5d24wOXAxbEZ1UWxWVE9pYnVrR3VI?=
 =?utf-8?B?OVlubEtER0kzZFY5TXdCczVjSDlYVlVGVkhvNTduZkUrMHM1WW44bWwvclB1?=
 =?utf-8?B?bmlTOTlkbERTY1VlNDB2ZkhyQTZKZ3ArL0pMckRkUWxPYWI0QTljQWJVcUhi?=
 =?utf-8?B?c2w3clIwVDh4N1lTOEJ3VUlBUDlGL0ZzV1lCd21wTmxqckN0bk53bGM3eXhM?=
 =?utf-8?B?VUZHa1dKMVRKZnhHbjE0L0FaMlVwWVNhWFpqbjBCMTh1Y1ZYSjhFbm1Tangw?=
 =?utf-8?B?cE5tSDZiVzhQSHZKd2lqNGk5c3JQVVlJUDEvZUgvUVU1SEwwcUlZdGdLZnFU?=
 =?utf-8?B?RmF3ZEVDc2VUa3BkZjdqT3hTWVNUU2RsZWlLMzhibVJFMFB3Q01iQ1Q1aHN5?=
 =?utf-8?B?RHlTVUVublhBa0dGZ2RrMlRSU0E0MEpHdzc5YUhJcnNnWDNwZktlTzd3Y05j?=
 =?utf-8?B?bXNMN1Z2Ny9kZE5OWXBiSXZJRGlOcFc0Wmswd0xqMnpEMmNHT0JHRHc5ODcv?=
 =?utf-8?B?M3BuZEJWYzNwMTFkQTRLV05rSlZrWVphNEVpejZGS2RKWVlGQ09uempMUWFy?=
 =?utf-8?B?OTBldE53YXFjbXZ3Sm11WUxvalZQWUtOU045SENmNkQ1bldYZ3ZNWE5RWkI1?=
 =?utf-8?B?eVdRK3FuYWR2OXFZd2ZPdzdBSlJPWEdWRTlHaW5JdUFRc2tPSnMyU25hTTky?=
 =?utf-8?B?RzA1MG5iOGNQMkFFcm40TElaam9ycDFYZGJyaE1nRkcxOXpRQm9SZG9kcUxO?=
 =?utf-8?B?MExiR0VDY01yc0JxVlBHcEZ0Y3VocXpjOEtsbEwyVlFjcW1qU1I2WGVJRnpS?=
 =?utf-8?B?d3UxZ0xOVzVPZHZlWG9zUUM2andiMFowRkgrbkpJTndqVDNwYzg4R3hFaVVZ?=
 =?utf-8?B?cXVKaHhPZnA3bXdHYTVRSTVqaEtjVkZjdE1wZmpoYzNCcnVuNjdmUXFQSEdG?=
 =?utf-8?B?QU1LZ3ltOFBySWN5NVZqcUxDYWVKaEV5RTJGZDdwK1JJeEtRVm5DcS9mZW9P?=
 =?utf-8?B?b3BuOUxNa1U4ZCtjVThzZXFkOTdIaUZkbitrRG5zcVZld2FQQXU3WkpnQXdH?=
 =?utf-8?B?NDJkK0xONmhIMXB4T012TjVGVzNxZlRVdjloRkRCSGg1VThYVURQUzlFSTBa?=
 =?utf-8?B?cFVQbGhvYzh5elphZHZFTE1VVDVVblAyOE1iaFFSaGJIUkhDbVpCZ1d2VXNk?=
 =?utf-8?B?VlRxL04vWG93U3ZiQ0ZKNCtacStTSzVjZXM5UXhHU3NPZEp0Q296a3FGcExP?=
 =?utf-8?B?SGxFTkwya1lNdlprcTZ6YlBKUjJkM3g1WmtxYTFiL251T2JrYkVrL0paS2dv?=
 =?utf-8?B?WEJBOHVWM3V5RjdxcjJSSzg4ejV0eDFqWjlYRkUxa1ZQWHBrTXN6ek9FWjlG?=
 =?utf-8?B?Vm05SzYwaWtGbXdkckN4WlE1dmJ5eG9wUE4vV2lzUENBR3pQb1RoRjBKTjNr?=
 =?utf-8?B?bmxnRExoUjlqTEVvcmFuUDE2RHdTMmk2TCtKd2pNRVlFd0hkNkNJc0pPR0RM?=
 =?utf-8?B?UTF0Q3VHdTN2eG0yaXNkNTRvblI2TjJUREdQN1g2ekxkTHFuWXA0WHlUR05z?=
 =?utf-8?B?UlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a9b7f2-dc7d-4f3f-b940-08db36ace2b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 14:40:36.9048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OZMVj67GbLQBIZdCeRdsNpkqC+qyGwMp1AgnrAsp9vKSjMBTpbykARBtANOuF7+mpVsDnqRk95iMR+aESNGJDE1zMnGn3dEt3yy6/+EoBo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7625
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gNiBBcHIgMjAyMywgYXQgMTA6MzAgUE0sIEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+IHdyb3RlOg0KPiANCj4g77u/T24gVGh1LCAgNiBBcHIgMjAyMyAxMDo0NTo0MSAr
MDgwMCBNaWNoYWVsIFNpdCBXZWkgSG9uZyB3cm90ZToNCj4+IFNvbWUgRFQgZGV2aWNlcyBhbHJl
YWR5IGhhdmUgcGh5IGRldmljZSBjb25maWd1cmVkIGluIHRoZSBEVC9BQ1BJLg0KPj4gQ3VycmVu
dCBpbXBsZW1lbnRhdGlvbiBzY2FucyBmb3IgYSBwaHkgdW5jb25kaXRpb25hbGx5IGV2ZW4gdGhv
dWdoDQo+PiB0aGVyZSBpcyBhIHBoeSBsaXN0ZWQgaW4gdGhlIERUL0FDUEkgYW5kIGFscmVhZHkg
YXR0YWNoZWQuDQo+PiANCj4+IFdlIHNob3VsZCBjaGVjayB0aGUgZndub2RlIGlmIHRoZXJlIGlz
IGFueSBwaHkgZGV2aWNlIGxpc3RlZCBpbg0KPj4gZndub2RlIGFuZCBkZWNpZGUgd2hldGhlciB0
byBzY2FuIGZvciBhIHBoeSB0byBhdHRhY2ggdG8uDQo+IA0KPiBXaHkgZGlkIHlvdSByZXNlbmQg
dGhpcz8NCkZpeCBhIG1pbm9yIHR5cG8gaW4gY29tbWl0IG1lc3NhZ2UgYW5kIGFsc28gYWRkZWQg
dGhlIHRhZ3M=
