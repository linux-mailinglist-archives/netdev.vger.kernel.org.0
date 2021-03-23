Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5B734593A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhCWIEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:04:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:56504 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhCWIEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 04:04:39 -0400
IronPort-SDR: IYF8HBC9f0trWufInOopDBT2A8Pybbr0l5wMJGN8jr/rQ9Klq9T7WyNT/+hrCiccUjQfekFd9v
 pUg2kmuEKs9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="251783560"
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="251783560"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 01:04:38 -0700
IronPort-SDR: 46dV3PgeGjl/vtT6cxgxHG9wGfMrDFNRKYMyWjGCp6+YMu2vAT+Ew1TbV/cYJlIh0VCMZajXL+
 zXehboTLDxYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="592889180"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 23 Mar 2021 01:04:38 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Mar 2021 01:04:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 23 Mar 2021 01:04:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 23 Mar 2021 01:04:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WucJg5iBKFVrEtSy/hjkVmXsQgFzFsT9Gcl6lqS4Z/82h4u/42iHy52xI4tytxUenAHl3EmJnzFblEa7l9E27IcBzTguOQBcMdimU+qLBD4k2AWevn7ajg+0LIA9LyHs4wHdwuGmnb6DTohJoRx1O0RNN0xmfRVp/vNR2+mo4y64BSTrbuHjcKlRIxEzStQvWBehqunqE7+NYC029bl14qTI70OZdk1x31C51V1E43/3daO+w9zhmBNjbide0zXnBGVLwpQaBD1xvOgSLWcd/zbBxcCTsX1B8LkMYHr4YCXKj3GSxUpOPayeR9VDADr2XKlkp4IixbZKrTcqhZJNAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGV+/yJYE5Emh3HButTC4zYS4uQBGFVzLr6dVS/7Qsc=;
 b=AYcVU/a1OAIN8wwY1GuHFzwRvvnRool6BXOfmLWQar09DgC2lmLBNKx00Zqz8Kgh3L2Hz4XlJe7642ktlIwId/azmnVMGeZF6KAgoJi6uSuWfAN6TVmTYohLQKKO6sxR6pOfC/murq+zIJYWW3PmRuRzfeQ4zs3Oo3CuLgWJ+4eRbGMbC/ZvLd6+HJysnphitp4lhgCnykHTUEmafaFEo++s3iqwCRgrSULYm/wX5Y5xEIWtHsE4NZs21X0c/FB4RCLW6UZHnQeMun0MCpSR91g2gTuPgC0rSp1+pPX0zfMupt3YwJWJdGpnTmiu1KGMVU/hofwEWG5W21ddqoX4lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGV+/yJYE5Emh3HButTC4zYS4uQBGFVzLr6dVS/7Qsc=;
 b=cHOdK3JFpcL0w+LlcadWs1ldwcpNN2NX7QOgMs0rtuGmis9GHZV0JKedOFdhzKEEKAadFTzRAur9ic+Kt8VVRfgRjhqrc93Xr3RH4dq/9iRxppfb42eQXU56KqWwJ+1wMkWeujvXC0B3gSlQTRuLIjK40BtgzXxm4oeB2aWAuIs=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by SJ0PR11MB4927.namprd11.prod.outlook.com (2603:10b6:a03:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 08:04:36 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e084:727e:9608:11c7]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e084:727e:9608:11c7%7]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 08:04:36 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "Greenman, Gregory" <gregory.greenman@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@kernel.org" <arnd@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH net-next] iwlwifi: fix old-style-declaration warning
Thread-Topic: [PATCH net-next] iwlwifi: fix old-style-declaration warning
Thread-Index: AQHXH2WG/u8rCHdGv0KctTI76/1BXqqRN4aA
Date:   Tue, 23 Mar 2021 08:04:35 +0000
Message-ID: <94eedcd0501ba64cfa17fc852dd4f22950a8c435.camel@intel.com>
References: <20210322215124.1078478-1-arnd@kernel.org>
In-Reply-To: <20210322215124.1078478-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [91.156.6.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cacf13b1-b46b-4870-15dd-08d8edd24d2c
x-ms-traffictypediagnostic: SJ0PR11MB4927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4927CEDA9BB8D542EB60EA3390649@SJ0PR11MB4927.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3O+fZ2KyOPk+HADgcN3dD2jrfLArzJb9K5m0nRUpWj1zYiEjSTtDgvyiuVjxKN8fo+QLXOoWbEHrtSWSNxUPWYSPeV/KfDkJDqsaSV8/5im85QL7Q9sgilrtizjrpwlH9pgMaNdv2uOe4+Nmp0RQmH7HMaREqqvb6WMpi5n0JieA+0/rbVI0kHpMbWy662twzL63P8qL0U76EHoc1cCDkt5aRNdMYnK7izSy5FvukGNWDC6+815uKfDI1jmgvHzg3ZSNx+aIsmphJBMfccDRb6Psyeot5zDDlzVjnm36LkScdRxpCXDKinIa8do/C8Yy1yeQAbipqBRWAIxspM268bM5GkeLf0uS6uAmtJfEqVSyUSDWDu8xAxk9TBDqPeqaftx/d3C+DIRGujA9Jk2hWBb+FYG/NoOUdQSfdivgzK7TvBxQImeq5MqrYipr/ehU8f9qQMufmX/n2TUnZ+AZh/Jilctgp31ZCAIFjRdrKi+RYZusg0l9BmLVBLzITuPl/pI2ha66EavT/ADRggfYhohX1WRZFdCNpRmVYCluIBLtXcNuDtUR3TiivXzft0GA24RM4asgDS01SdR9rXLVHmglVk2XNKqAl3mBDBq0NlQs6wXIpK3jTm0kljs7qIK9KiakItOeDRdIPLd7bz8931fCMtZBljTFAVAP7MFCVU4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(376002)(366004)(8936002)(83380400001)(66476007)(6486002)(66446008)(66946007)(2906002)(64756008)(86362001)(38100700001)(4326008)(2616005)(71200400001)(66556008)(36756003)(478600001)(76116006)(91956017)(316002)(186003)(4744005)(110136005)(5660300002)(54906003)(6512007)(26005)(8676002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RnZTNnZZMkNDelpzWno1M2F5QUZhZnQwaW9Va01qenF5NGZRR3A4MXNNbkZn?=
 =?utf-8?B?TDV1QVgxRHQwVUFKTy9mMmlEdFlFU0VOT2dSTVhzckYyOHdXR1VtYlU3NlNU?=
 =?utf-8?B?eEUvWmlzNkhNMGFRMHlXUHJKRlA5RDBzWnFVcGFqMjEzdzJBSno2cFNrSTlK?=
 =?utf-8?B?dkdBVUZhWDQ3STMvUmVhTGh2OE1uekpCamI2L1Z1TkErblJKK3A2YzdBbXBm?=
 =?utf-8?B?ZEFraGpUdVVhSm1DNFVCbUxwVHR1aVdKeVFaV2I5V29DbmVhYWdvTFJTVHgw?=
 =?utf-8?B?Z3BHZDlBTERSY1p3QjJTSVhTZ05wYzdGVHFLM1V4ajhUbnJqYW9EbE9MWGcw?=
 =?utf-8?B?ZFRNQ0hUMm9LZElTTmZRNzduWmY0eVVCUjh4TG1UZlM4Y1o2a3ZBOU5xdEVK?=
 =?utf-8?B?VGQ3d0ZpUzNRVlljTnBCWEVMTnZlenZtR0NTamVQMTZaT3dVVFpZZVQ2eGV0?=
 =?utf-8?B?c3FyTjRYNlZHaUpEOUdsanc2ZVBnZjBaeVAwY05NbEE1U2h3My9LQWVEZGpI?=
 =?utf-8?B?Q2NPYXRpOTZJVk9nOFR3Mk5MUXRHNTd5cWNZckJiNjU2MnEvZVBvZXRRU1JQ?=
 =?utf-8?B?UzdYcGZTUEJmZzVUbHZ5TkxadjE4cHc3VDl6dFdWTFJSS3Rnc0laK2VBOXpI?=
 =?utf-8?B?RzJPcGo0OWlnN3ZGTE9qM0RJVTliM0NOYjJjWFQ2dExONDdBQXpadGx2MEFR?=
 =?utf-8?B?bFpVNHViR091OEFjWjlXYWgxeUEwZGJZZFVoTkxlVGY3Y1cxMHBnYU5OVUQ3?=
 =?utf-8?B?OExZT24vT1o1aFpBNUNJOVdTcTZhaFIzY2NwcHNNV2o5cDR2RU5FQU0veEdE?=
 =?utf-8?B?a0lKM3pwUXdVbUR4dnhNOGNjemtCL3U4cEtOZUE3eFFZcW9PM2VETWNvbGR0?=
 =?utf-8?B?dEJieFZKSUswcHJaTTV5VE80ZnNKVEtEQVBaVXdZcnNRQWtoUGVwZnQ0dlRQ?=
 =?utf-8?B?YTlQVEpxRFZPQmlBTVdzcnVDc2h6NHBrQXBkT0E5bElsUWxsRGFJaWkyYTk3?=
 =?utf-8?B?Q2l3S0dJbElaSkc0cVJicTc4SlpHQnBJaHVzY20vakxoNm5aU1V3U1ZpVG5R?=
 =?utf-8?B?dm5IOFJpU3FyeXRMQy9pNEZVQ2o0TEwwVzhsTVpyYU5BRjh5bVpSOGU4elly?=
 =?utf-8?B?NXE4VEx3SWZJbTlTbmg5RlhjNGZGcDdIQjQ2d0I2dE9BR3JNajhmeHZQWmJl?=
 =?utf-8?B?SUdZNjUwRmpCemlWZHlCZ0ZWMlVCWXU2YnNET1ArZGgwUFdoaUo4SU8vaXBI?=
 =?utf-8?B?anhZWDJLN0svZmFFamhZTmlzOUlnemJ2eDEwS3Y5U1V0UmV5SjVsci9FTHBq?=
 =?utf-8?B?dTdXZXl1azNvNDJoYjgrQXpJaFQxZWxNeVBmS05qdWZNYXJzSHFSQXR5cHRC?=
 =?utf-8?B?OExjUjh3U0pRWVpLcWJNUGVHdzFLN2xTRE9ZVjBJZ21QKzJPc0RFQXEybmMy?=
 =?utf-8?B?TVNIalVpbUgrZmpMdlVDUkViWWdsajNqRi9jeUs1aE9xcmhEaFZGK294b3Ny?=
 =?utf-8?B?THFUczV4c2NzalIvYXgrV0NQWTV1Y3pCU0U5TEU0YU5xcEpENjFkTmNLWUNt?=
 =?utf-8?B?QVhrRWFWM2praW12SVhPVkZMZTI2cHJ2T2lqc0k2b21SeklobzgrNEQxbDVv?=
 =?utf-8?B?bUl5YXJ3MUNYeUFuNDJrcGFGeFZmd0N1cHRrRzVZWmJRSVNBZGhScUZoRzNF?=
 =?utf-8?B?eFVVTnBaZndnSDFSaHlDRW85T3dsRWsxQ0JOMVZsMGN3VXk0MFpGNldYMVU2?=
 =?utf-8?Q?3UI4CcwJrd80XNdyvSzpP5Hpk1LitFUaxfWm6Md?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAC85937955C9B48B728913234DAE070@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cacf13b1-b46b-4870-15dd-08d8edd24d2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 08:04:36.5785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TvPArvgT9T7TQdbuHLNoxDYu/W4jssALSKbpigsD1HL+jRNl+jIlePegDfLqCTPXtBIa9wLhiDVB2SpBT9dzWATMd5fdn3UQXRygOlJcjPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4927
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAzLTIyIGF0IDIyOjUxICswMTAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiANCj4gVGhlIGNvcnJlY3Qg
b3JkZXIgaXMgJ3N0YXRpYyBjb25zdCcsIG5vdCAnY29uc3Qgc3RhdGljJywgYXMgc2VlbiBmcm9t
DQo+IG1ha2UgVz0xOg0KPiANCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9t
dm0vcmZpLmM6MTQ6MTogZXJyb3I6ICdzdGF0aWMnIGlzIG5vdCBhdCBiZWdpbm5pbmcgb2YgZGVj
bGFyYXRpb24gWy1XZXJyb3I9b2xkLXN0eWxlLWRlY2xhcmF0aW9uXQ0KPiANCj4gRml4ZXM6IDIx
MjU0OTA4Y2JlOSAoIml3bHdpZmk6IG12bTogYWRkIFJGSS1NIHN1cHBvcnQiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiAtLS0NCg0KVGhhbmtzLCBB
cm5kISBCdXQgSSBqdXN0IGFwcGxpZWQgdGhlIHBhdGNoIFdlaSBZb25nanVuIHN1Ym1pdHRlZCwg
c28NCndlJ2xsIGdvIHdpdGggdGhhdCBvbmUuDQoNCi0tDQpDaGVlcnMsDQpMdWNhLg0K
