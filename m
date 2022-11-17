Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B408F62E710
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiKQVhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiKQVhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:37:13 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4CDC11;
        Thu, 17 Nov 2022 13:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668721031; x=1700257031;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bAsFA6Ks+9kw0AEkO4p8s/JG/+HxwYDxLQr+mznXXNg=;
  b=hrbJflMcK40wIDyJArebGQ1Y/bfV4M4jhz7iVVzMlCFDOm6Ti98j5gcu
   lxx0wpN1bdyemyBzJRcJLF7SJBKgcmvXC/UZ5oDVWGLoJ4bXki86wxZ/o
   wuQwkGO3T6mSQjB3gq+xEZRFXT54V/FNHAg2qmeHCfpKeLQZZQ0F/DUZp
   qAu16sLUz9XJNOeCgg/v+ADRkf6qlILF3sB8bwrcnLx5HHFdeJj0QI988
   glRQkSnXTeEGi7XD6KwLWXHfy6Yrulof+Y2rFDkbUnnMQc0nZBNvw3sgd
   h4T0KcWOtnABP7LgJs33+bGAIgEV0msgmr0u5BT54hp/TumkJ7zOF0lIF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="314131514"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="314131514"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 13:36:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="814674124"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="814674124"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 17 Nov 2022 13:36:56 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 13:36:55 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 17 Nov 2022 13:36:55 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 17 Nov 2022 13:36:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAFk3xoqAVXBjlOkOFIxGkC/XrWUjIJpddq5DEuU7CvA8fgJ5TxhAgd+DHuPmj6C+ea3AZdw/QZFCs0rP5RmPi+fqRatov6h9nzF7Ucgyw9zz/HxnWgjqa5Ru3nGwBGqA+2VenkghJPDpH/V6q9qNFKN/2riUiYjPNeWdgeC39rc3jiK85IXh3t+sx1oKZ5DTJFotxdIgj+AsOkPOuNEhnrnef4ZOKSpeCHvULg4cFzdmps5pjZ9zsWCmugOPBdKMm4BUGXT0dqpcBYhUHFxcGndeUqu2n0EWm5ttPYIsR8WsfYfpMbe5Nm1kTgXEK+AD7RR1H4YWKtEOjHXKbhcRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAsFA6Ks+9kw0AEkO4p8s/JG/+HxwYDxLQr+mznXXNg=;
 b=ZYk1k1XjKMKuJs6jMgg56aWqi+0J+O2rdJzGGZNlfrdLsBPRD6Huc6Rdyq9+c+MpOsomgMCgnaau3478INGYXiGtzWcOm1xoH3G8far3fMS0Tc6JqLIxYpRm9EFva+JVjBJLGTJssguwdQcaxLlGN1ca93ePbCc/hhe1QIC0o1gs07UzcuR9UDjwaHygRGsHDA5aMy9mrv6SqmtJmwcCcLKZ/viJUrNHkV6acn57T+UFn/cKe+vrEyiOuMCSYsUszMOLLbinKKtNDbYdjUM3xo2D6Xf3murdY79Gl3YEdgVkVMTt/uBPLaYDkHcPzqwYDB1BIKdcm0a0HeiDznmy7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA0PR11MB4526.namprd11.prod.outlook.com (2603:10b6:806:96::15)
 by DM4PR11MB5342.namprd11.prod.outlook.com (2603:10b6:5:391::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 21:36:53 +0000
Received: from SA0PR11MB4526.namprd11.prod.outlook.com
 ([fe80::fae8:2a72:6b07:e5c]) by SA0PR11MB4526.namprd11.prod.outlook.com
 ([fe80::fae8:2a72:6b07:e5c%4]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 21:36:53 +0000
From:   "Gix, Brian" <brian.gix@intel.com>
To:     "mat.jonczyk@o2.pl" <mat.jonczyk@o2.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Von Dentz, Luiz" <luiz.von.dentz@intel.com>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "marcel@holtmann.org" <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: silence a dmesg error message in hci_request.c
Thread-Topic: [PATCH] Bluetooth: silence a dmesg error message in
 hci_request.c
Thread-Index: AQHY+foo/clfMr03b0+vGy2gyjbY1q5Dk/UAgAAO6oCAAAKWAA==
Date:   Thu, 17 Nov 2022 21:36:53 +0000
Message-ID: <7909f86e4d13015b7f14a6f3f1f75f053d837314.camel@intel.com>
References: <20221116202856.55847-1-mat.jonczyk@o2.pl>
         <499a1278bcf1b2028f6984d61733717a849d9787.camel@intel.com>
         <232fd0ae-0002-53cb-9400-f0347e434d42@o2.pl>
In-Reply-To: <232fd0ae-0002-53cb-9400-f0347e434d42@o2.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR11MB4526:EE_|DM4PR11MB5342:EE_
x-ms-office365-filtering-correlation-id: e264ef63-2c92-401a-429d-08dac8e3d813
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EZAsOzdjzNlwibOPSpaCZ8NNmD5nFWU2G9C48uwAiTvecPRFuB4Z+XIcsX8qj957ccdQIV3mE3Qzk3PFY4jJi9tiB5fAG7+26msuzCUcswYY/FWq/PLLE/3IPe7WXalpBstfGYRnTj98LRvOfspwY1dg+idukWzu29bAeUJpJCccPB3TBCgn1z8SfO6UqbFr9Waq810koWQscyQIoCXqzLDOboN/6LinxNGlh421ep2Hb92UOEsWqrHHkarbiCLPUmKm51cMi3T4N03XJHLGxE2yz25INJLMzcudU9ZyAaSE0C7mJWX/ti+NZDLJkcySC6J/LH64Gzg8d7gr6uEXx2GpI/aK8qx9X2nBOGQ5yTdQ4rS5gvLcVO2q+WYWp15tmkCwjjG0/rHAdRGfueYFhhE50DLyHYqFE+cBz+1/+Vf+1NNJf2e9X5+ogpl6yBbm39aRinl0rj5SPFtReLxX1wMqrmTGS+3n77Dh9NNFQ8C5OjgC6ycRJCDzMfKE474F9LVp9Wb0lxSMRuXyqnK6/plNuPgWMFmgtCh2ddXkd7/pTppsOFxiN8pJqw+B4KImpAToZ7DdBhb545OypMGNpWJwUBXstJcwVoDGCsmxtSiKgkvGYSz6zJAjcr9RR723bK66yK+mxP7C0s7DiX+ThyHnEH4etyt/R3foNS6OW0iTYN6dfnEHo1HlTua/35o+wObI2i68zITbYWCA1iiM8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4526.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199015)(86362001)(38070700005)(36756003)(38100700002)(83380400001)(4001150100001)(5660300002)(2906002)(15650500001)(6512007)(6506007)(186003)(2616005)(82960400001)(66574015)(122000001)(110136005)(26005)(91956017)(76116006)(71200400001)(6486002)(41300700001)(66476007)(316002)(66446008)(64756008)(66556008)(66946007)(8676002)(54906003)(478600001)(4326008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFBmUllPb1llakU2RFJSUDk1dkl1cGFRZTZKMXdpWFRuZHZTTFEyRXJYbTBw?=
 =?utf-8?B?MFYwczdtd21BL1psVmpTWjRxdEI2SENWeWxlcG9mSXgzSEJEVU82SWJEMXBG?=
 =?utf-8?B?bk1GbThmSFJ2Q3pBVUVPYjI3czRDSldGbUtoWjVjeEJ6OTllU01BeHpXOTMz?=
 =?utf-8?B?aUdRZ2lOT01KTmJYQTJXU25ER21Sd0J5aXpMOS9jOWRxZVV2Wmw0eVFiMmFw?=
 =?utf-8?B?ZERhWVNsdDZ0Q0FNblBrcGZaRlNDSEZqR2Jad2Z2MEY1MVROTlJxUGlZWmMz?=
 =?utf-8?B?eFpObFR4Nk9ieWdHc1R0STczQ0RJeGRwT3g2ZExkOTlKV1lQRjhMWFFlQjZI?=
 =?utf-8?B?ZFhLeWVNNDFBSTk0cmM5M0FrY004VXl0dWNQeVJaeTFzZm1scXl3TDFjYTNT?=
 =?utf-8?B?ZVVjcCtGbzNhbHJnbXpHWFQveHp4cGFvVVBXV0o0dEFzcmJWenphcG5xYXdW?=
 =?utf-8?B?VzIreVZZL3U5ajRrV055U3AxcXR4NjRTbXVDcXVwN090UGd4Z0dkNFlHWllG?=
 =?utf-8?B?eTcvVVV2Z2tyckg5eGxZU2hrREJTWG9ramx3SVV4S0Z4SXJDZ3ZaUU1XQklq?=
 =?utf-8?B?OU1UVGtJMkdsR2hLMUVhUDgzNFQ4cVdFeURMSmJxMVRVUHFpaWNGSHAwZXNm?=
 =?utf-8?B?cHlUZDdtRDgrUWJoUkIvZFNISDA3RzB2RjR0d1JwY2lyVlo0VldUZjQ5V1Vz?=
 =?utf-8?B?T1Zkd3FGbmw2YVZEeGRmSVlnVUxJV28wZnl1YUdZYlh3b2FWTEVOajhvRzFR?=
 =?utf-8?B?aDFMS3l1b0IyVnoxdmdrdWxsZXBUeUxSSmt5cUI5MkQycGdtNTNhOURYcExn?=
 =?utf-8?B?UUI4anUvdTgvMkxSSWhjZERtMEt0U3V3cEU4SjV0dVJ2LzF3QllmZk8wUXRR?=
 =?utf-8?B?eFB4ZE5xMkh0VksvZnNEd1pOcndqd2VydThwVU9oeGh2NTFFUFlWdmtBcWJr?=
 =?utf-8?B?bk9qQnVhRE1VR2tGOE96dlZiQVFERlhtdW9ROGRKRmU1VWpQWE9JQVVPaVhW?=
 =?utf-8?B?c2oyUytrc3d1MFFoQklIUDk4MEo3TERhRlJvUHN0RlFrVm9SWEd0L09ObGZv?=
 =?utf-8?B?cmVJNko1NFZ4TzZ0U0UwalpOb2hxc1lNUWt4bS82Q3Nockw1ME9CSXE1eE5W?=
 =?utf-8?B?cGp5V1J6Y0NxSXdEOGp1WnZLclBscXZpNWJqaW1MNjVxVGUxRVRJcmNHNHJY?=
 =?utf-8?B?UjF6UHVTSDFERUlBN3JRVmNpRk5iMEgreHZybnJ4SEhiN3ZhN1UxajNKQm1I?=
 =?utf-8?B?YkxNVkRjRUVqcGMvMUxvUnhjbkV2VmxzRklaOVZBWHIrdmpCd3ZQMDcwMFhN?=
 =?utf-8?B?a0REdE52MytWdTlqOU9ONXgwb2ZVZThDZFJxWS9TSVdTd1N4Zk5wY3VKZzFZ?=
 =?utf-8?B?Sk1qK2pzdmRVUlN3Y0FFTlp1VTk3SXpIMFJUalU2dmJBOWY0QUxqd2tTUzVH?=
 =?utf-8?B?bStjcmFuRTZLQnl5S2tZbTRDSGI0MDMwcTdDT2VsWXdRYzJJTllZSjVnc09k?=
 =?utf-8?B?UHJSeG1RaWFuQWRocDhLUFhES3VvSlNVeFhYVXR0ZTR3Q1pESkdZR0kzUC9j?=
 =?utf-8?B?NkVDcnFFRE9KQ3dub0g3ZDFXb3lvVFhVRXp3WjNTV3NuNWh1MjVUNmZwdUFR?=
 =?utf-8?B?elNrMlBKTWdXaTVxM24rb1ZRVDZVUzQxcXVjMk5wSGp4Y2ZnSkFiUWFjaE1v?=
 =?utf-8?B?VzdBY3Q0MjUrMEE0ZDArNGYwMWRvTnVQbm1VSWNuRFVVMDlKM1pGUDdQQVZX?=
 =?utf-8?B?K1ZJK0JzODE0QzhEdGJaekNZMjJjWHhDZG5JcTQ2cTMvcG1STXJWam5Edk1p?=
 =?utf-8?B?Q0RINW03RE80VzVwY2NHT0oxZU1oU3BpNG15UWMwc2Jua0ZaODJYSVJDNXh4?=
 =?utf-8?B?NUUySThKcXN1WUhYK1hWZE91NE9CTTIySWg1c3dOKzgreDR0VlZzUWpEaUIy?=
 =?utf-8?B?VkRqcGh1OE5zMmFKNlpoSlV4NVIyRWdnbUxYa3V5emNUTzFxUWVlM1p4a0hy?=
 =?utf-8?B?ZHVDc0Myc2JiVXlEbER6cm1CMkRKUytudGFZWFJjdlVWOTBDdlgwbGFLSjF6?=
 =?utf-8?B?bUo1UmhmQWNmYlA1NzV5T0UwQVBiQWJqTi9MQUQ5bURSVVZwUkZLTndRKzcr?=
 =?utf-8?Q?GhApb4QKL46KSCBrys3dPScWh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB177593EB99CD42A2E5DCCE4E033499@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4526.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e264ef63-2c92-401a-429d-08dac8e3d813
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 21:36:53.4150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0WqTegh3dHLqzalhuRdGeol3eVtt71EXcaKWpDiGVBMFLNutL6HhFw5FjUnj3WzdbTbpvRifn/uRztRcK6HMyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5342
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgIE1hdGV1c3osDQoNCk9uIFRodSwgMjAyMi0xMS0xNyBhdCAyMjoyNyArMDEwMCwgTWF0ZXVz
eiBKb8WEY3p5ayB3cm90ZToNCj4gVyBkbml1IDE3LjExLjIwMjIgb8KgMjE6MzQsIEdpeCwgQnJp
YW4gcGlzemU6DQo+ID4gT24gV2VkLCAyMDIyLTExLTE2IGF0IDIxOjI4ICswMTAwLCBNYXRldXN6
IEpvxYRjenlrIHdyb3RlOg0KPiA+ID4gT24ga2VybmVsIDYuMS1yY1gsIEkgaGF2ZSBiZWVuIGdl
dHRpbmcgdGhlIGZvbGxvd2luZyBkbWVzZyBlcnJvcg0KPiA+ID4gbWVzc2FnZQ0KPiA+ID4gb24g
ZXZlcnkgYm9vdCwgcmVzdW1lIGZyb20gc3VzcGVuZCBhbmQgcmZraWxsIHVuYmxvY2sgb2YgdGhl
DQo+ID4gPiBCbHVldG9vdGgNCj4gPiA+IGRldmljZToNCj4gPiA+IA0KPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoEJsdWV0b290aDogaGNpMDogSENJX1JFUS0weGZjZjANCj4gPiA+IA0KPiA+IFRoaXMg
aGFzIGEgcGF0Y2ggdGhhdCBmaXhlcyB0aGUgdXNhZ2Ugb2YgdGhlIGRlcHJlY2F0ZWQgSENJX1JF
UQ0KPiA+IG1lY2hhbmlzbSByYXRoZXIgdGhhbiBoaWRpbmcgdGhlIGZhY3QgaXQgaXMgYmVpbmcg
Y2FsbGVkLCBhcyBpbg0KPiA+IHRoaXMNCj4gPiBjYXNlLg0KPiA+IA0KPiA+IEkgYW0gc3RpbGwg
d2FpdGluZyBmb3Igc29tZW9uZSB0byBnaXZlIG1lIGEgIlRlc3RlZC1CeToiIHRhZyB0bw0KPiA+
IHBhdGNoOg0KPiA+IA0KPiA+IFtQQVRDSCAxLzFdIEJsdWV0b290aDogQ29udmVydCBNU0ZUIGZp
bHRlciBIQ0kgY21kIHRvIGhjaV9zeW5jDQo+ID4gDQo+ID4gV2hpY2ggd2lsbCBhbHNvIHN0b3Ag
dGhlIGRtZXNnIGVycm9yLiBJZiB5b3UgY291bGQgdHJ5IHRoYXQgcGF0Y2gsDQo+ID4gYW5kDQo+
ID4gcmVzZW5kIGl0IHRvIHRoZSBsaXN0IHdpdGggYSBUZXN0ZWQtQnkgdGFnLCBpdCBjYW4gYmUg
YXBwbGllZC4NCj4gDQo+IEhlbGxvLA0KPiANCj4gSSBkaWQgbm90IHJlY2VpdmUgdGhpcyBwYXRj
aCwgYXMgSSB3YXMgbm90IG9uIHRoZSBDQyBsaXN0OyBJIHdhcyBub3QNCj4gYXdhcmUgb2YgaXQu
IEkgd2lsbCB0ZXN0IGl0IHNob3J0bHkuDQo+IA0KPiBBbnkgZ3VpZGVsaW5lcyBob3cgSSBzaG91
bGQgdGVzdCB0aGlzIGZ1bmN0aW9uYWxpdHk/IEkgaGF2ZSBhIFNvbnkNCj4gWHBlcmlhIDEwIGk0
MTEzDQo+IG1vYmlsZSBwaG9uZSB3aXRoIExpbmVhZ2VPUyAxOS4xIC8gQW5kcm9pZCAxMkwsIHdo
aWNoIGFjY29yZGluZyB0bw0KPiB0aGUgc3BlYyBzdXBwb3J0cw0KPiBCbHVldG9vdGggNS4wLiBR
dWljayBHb29nbGUgc2VhcmNoIHRlbGxzIG1lIHRoYXQgSSBzaG91bGQgZG8gdGhpbmdzDQo+IGxp
a2XCoA0KPiANCj4gwqDCoMKgwqDCoMKgwqAgaGNpdG9vbCBsZXNjYW4NCj4gDQoNCldoYXRldmVy
IHlvdSB3ZXJlIHJ1bm5pbmcgdGhhdCBwcm9kdWNlZCB0aGUNCg0KIkJsdWV0b290aDogaGNpMDog
SENJX1JFUS0weGZjZjAiDQoNCmVycm9yIGluIHRoZSBkbWVzZyBsb2cgc2hvdWxkIGJlIHN1ZmZp
Y2llbnQgdG8gZGV0ZXJtaW5lIHRoYXQgdGhlIGVycm9yDQpsb2cgaXMgbm8gbG9uZ2VyIGhhcHBl
bmluZy4gVGhlIEhDSSBjYWxsIGlzIG5lY2Vzc2FyeSBvbiBzb21lDQpwbGF0Zm9ybXMsIHNvIHRo
ZSBhYnNlbnNlIG9mIG90aGVyIG5lZ2F0aXZlIGJlaGF2aW9yIHNob3VsZCBiZQ0Kc3VmZmljaWVu
dCB0byB2ZXJpZnkgdGhhdCB0aGUgY2FsbCBpcyBzdGlsbCBiZWluZyBtYWRlLiAgVGhlIGNvZGUg
Zmxvdw0KaXRzZWxmIGhhcyBub3QgY2hhbmdlZCwgYW5kIG5ldyBjb2RpbmcgZW5mb3JjZXMgdGhl
IEhDSSBjb21tYW5kDQpzZXF1ZW5jZSwgc28gdGhhdCBpdCBpcyBtb3JlIGRldGVybWluaXN0cmlj
IHRoYW4gaXQgd2FzIHdpdGgNCmhjaV9yZXF1ZXN0LiBUaGUgaGNpX3JlcXVlc3QgbWVjaGFuaXNt
IHdhcyBhbiBhc3luY3Jvbm91cyByZXF1ZXN0Lg0KDQo+IHRvIGRpc2NvdmVyIHRoZSBwaG9uZSwg
dGhlbiB1c2UgZ2F0dHRvb2wgdG8gbGlzdCB0aGUgc2VydmljZXMsIGV0Yy4NCj4gDQo+IEdyZWV0
aW5ncywNCj4gDQo+IE1hdGV1c3oNCj4gDQoNCg==
