Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB56BA3C2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 00:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCNXvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 19:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCNXvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 19:51:05 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711382942C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 16:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678837864; x=1710373864;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uzIj0NhAJw6NBQzAwZdIadMZiYvlcmEU+yDAc3dx8WM=;
  b=jM+/W78DqClYRYiwJaPVwVf9NffpFaK8FUrxKmXsn2gsauWB+Sv/OMoU
   bOMNfO3hzSIY1XzIo2q1A84HXvnMcyyVHJg8NHJ1i7A89Qh6QMftwrvgy
   6y3zKqBfNp9Nq9uK7/scxmnMvxQylXhbmL5ANrenCZcFINvGcDK/0Eq04
   OB/2DHLIUxPqnH+Mvgl3NkLnbLRlkpnZP219X8BuwEVL6gFsQ9Go9EEfb
   Kjf66tYh8na+3rUOkZeuL/DM9K01DNzutR7SVaW3ixUfCDSu5bBz6lrbp
   cR+BlTh2IYnIVqF+k2El71HKoSKh4oDp5M2NimrueSn/8E0DeSNPC/QZC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317223232"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="317223232"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 16:51:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="709475195"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="709475195"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 14 Mar 2023 16:51:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 16:51:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 16:51:03 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 16:51:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6Rkwt5D5B2WYgpkvtFVMB6t068l8pU02muoUhseGTodbb6zoMLJ3wz284a15swSzQrDkegXTpsm2BQuMPqO3N9oQMnxjKlc8SRK03yF1UO8TDJR4JnX85ConnQG9KhXsyal5w12AMlu6FGQOmBFZs8awfhOa59ti1xdqv3vx9ckg/+A7h1+M7nfanRrCtd0aToFghY7Avn8ci+VqiFl/ZxTeAWyHFN/nC21Dt6kLoNlNQXWJPhkovAt6hrJ87WSUihVDdnHQjgRh6WNrOPrEIVqP2SSi0D8O8RsI9yPwmX0TOrREVzsfr+MhdYyFONW/E8tVlzXm0VmbiWrkIfcAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uzIj0NhAJw6NBQzAwZdIadMZiYvlcmEU+yDAc3dx8WM=;
 b=b0xG/FgVai2NtimZtngQW/g1b+H4W7JrBLQ5y/zNs3HM3u0JKr09jgvp1MNlIosQHkcVf8tRsXGJs0G57XTwut93eNq5H84QF+ENZHM2go76aOx4MJZ3UqWsVuXAW0+7LZYKdrmuQriZk6Zf25bpYKHe5t6Q6gwHUY1BQF4Pfwv5gTDwcMyhByF5x4HI+rUZfggPJNU3gF8HiC33Jw8crBCTH/XwEpsAL3+aVyFjkBuP03JaZ+nqIbGP4selDiU/BnIhS+9g9x2tilBXzoqMJzuKL1mTbuKVhxaMHLzQUWIrCRotqcN5a8jcf++GDUxSj8zTWwQo7qvdi0ZecEOpYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by BN0PR11MB5693.namprd11.prod.outlook.com (2603:10b6:408:164::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 23:51:01 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::250f:ee9b:4f38:b4ba]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::250f:ee9b:4f38:b4ba%4]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 23:51:00 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next] ethtool: add netlink support for rss set
Thread-Topic: [PATCH net-next] ethtool: add netlink support for rss set
Thread-Index: AQHZUtOPcdTl3zIDTE2vNdyJzYtbc67znDIAgAWy4JCAAAhoAIAA9mCAgAA47EA=
Date:   Tue, 14 Mar 2023 23:51:00 +0000
Message-ID: <IA1PR11MB62665C2D537234726DAF87D9E4BE9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
 <20230309232126.7067af28@kernel.org>
 <IA1PR11MB62665336B2FE611635CC61A3E4B99@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20230313155302.73ca491d@kernel.org>
 <1710d769-4f11-22d7-938d-eda0133a2d62@gmail.com>
In-Reply-To: <1710d769-4f11-22d7-938d-eda0133a2d62@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|BN0PR11MB5693:EE_
x-ms-office365-filtering-correlation-id: b38b1159-8f32-451f-ea92-08db24e6f706
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 95dsc7UW+g1QmUY53MnZ8GZhHecP3mf9575NG4UPZSsn9+3mAa2djqj+dj0g27RT2WWV8UPw+MPwRtHH+PyAUthUmCRzdb9mNBV2kUvcF4Ku4UsJrtHtgfPj57RqvI2cZJOyZqTPgOuxTFdDu3vBG4IL0/9Hy8K90pkar54ffPFEs9r/qRDjE31CwclWqUBwyFy853McHJWKIBfaPFPTk4KA0YLMDoY+laFGmQSA6UgnsvKSUi0Xt+l73AU39jyp6zytEwv9GeXVZpkCI2ycTTGaD/M6SLVTVx+HJLhLzvOdBl23++dMrX1T0FsEvPuygRwMmMFzTOx6CbhWVam2uzaMDjcPrIl2s9gBljxLf4fq0Mzd+BvKPYt8Bkax/IYXme4SbwOnkhrJpRvcT3nWg94cHTMqXlcWdrvbKWuHQp+e/DxktDybI1TE2T6WcZVuu6it+prjWI/jyKiCHh9TVv5CiviETTI1uqChU4fybNahHE3vp9D8ius4EltM2m9qvDg9tjmxlFoyjfLgldMueN3glcNRyCuPDskHWDllAwZU95HMvJQQifEuG5b4V8VEoVEC8lFpAqxsugRlR05uxAvKGkSICu6qsn3vlcBJCJoS+BCKtnD0UVjmKboUzdb+LgTeYetgmUeWwIrcUqXGhnxWdsKt62A6yeLAQvzs5/P0b0wQcr8aYhL87EwqR41KDzqjkV6U9MyYcWgy9WLaEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199018)(33656002)(86362001)(38100700002)(38070700005)(7696005)(82960400001)(122000001)(2906002)(41300700001)(5660300002)(8936002)(52536014)(55016003)(4326008)(9686003)(53546011)(186003)(26005)(6506007)(110136005)(54906003)(316002)(83380400001)(66556008)(8676002)(66446008)(76116006)(66476007)(64756008)(107886003)(71200400001)(66946007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFhWd3paOHJSbHFRYWo0a0gvaEpnTGQ5Wk5NdXhseXROSUwzckh1M1EyMUsv?=
 =?utf-8?B?NzZHSGlBNTh2M1NWWnAvOW1MR2pZWjFXdXdtTjlqbjVnS2pHNkpWYmNSTmo4?=
 =?utf-8?B?R21iM2t3LzB2MHJWbTYxZ1YvODlMUnpmbDBZSTVLaXRDeFJGczV3eVNrUzUr?=
 =?utf-8?B?TkNXbE9Zc1paUzF2YkRoSk5SUzRHbXpzUExHUnRJd2RIV2FBODNBTzVMcnRZ?=
 =?utf-8?B?bVpUQXFTZTVjVWRLTFBxV29ONFhuZm5zN1lnOUI0RU5IR0xCSEw1MGJNZ3kz?=
 =?utf-8?B?MThpMWMxQ1YwTmJ1dHROMWRZVDl2SkpRaVpPZlF6VHdRR2ZnU3ZVN1hZYnJa?=
 =?utf-8?B?Z2lMOXZqNWFPS3dBZFp3M0ZkK0pOdm80bDdCUzhzQWlMbzk2dFhyQWUwRFZp?=
 =?utf-8?B?STdWRWZnaXFXYWQrMVE1T3VzbjZlUFNXUzRpOGlUTUVKbDU0RVlYMHJDVmJ0?=
 =?utf-8?B?bmQwdWpyVkRlNkJoaW5DdHE0bUpVZ2pzR2NhdThRNjJDcVc2QkVMSzYvU0dr?=
 =?utf-8?B?TDhWSG5tdEtKQWQ1bjRQTzV6TjZFTFpNWW0xWmR5Uis1R2JjMU1WdjNQWjNP?=
 =?utf-8?B?ZVJUVVhHNi85RTJtSGpCSCs0L0Z5T3dsaEhtQXJmNmdNRXdwb05sV3N2R3V0?=
 =?utf-8?B?czRhdGZPRVZQNDJaOUw0N3JsK2hhdVNQRkdMV2xmUGd0c09NMnhESWpEQWwx?=
 =?utf-8?B?ajRLaUhid0dwTEZaSUFBSWN2UWtlVUpKckVvZk5LQ2lXaGV5WmxadTEyUXVk?=
 =?utf-8?B?MnNiZG9YbzI2ZmVIcmZnUGdDaG1oSzZVUDh5VlNCTWlmbzFzclVwTnJqS2dt?=
 =?utf-8?B?MHJuZm93VC9pTnJjM0t0cHdRREY3K1RCdTg4SDg1MkU1L1A4a0dOQ2YzOVcv?=
 =?utf-8?B?ekEvb3AxS1JLdTlFb3N2OFExeUZkb0FnT2lQeVcrSU1WWUJkUWNxUDM0OHlZ?=
 =?utf-8?B?UThMWTMwTUU0TVJpczFCUGNCMUVLNjFMVkZUYWNOVGFRQlljZStlL0EyWDFo?=
 =?utf-8?B?K3l4OC9XYURpSXFIbkQrSTU5NlFpU0ZEUTBwNnRJU3g0SGoyRzdLNFJRMFlU?=
 =?utf-8?B?V2lNWGZYallQdWpobjFrTG9kLytHWmp0Y3U4NGZHYmE0Y0JzOGl1VWFlbkxq?=
 =?utf-8?B?bzRpTnZtYVZ3alB4YVM0N3pIaElhRlErL1cyd1R4UEJ0Z2pvaktMOXNjNG9k?=
 =?utf-8?B?ZXU1UnRrc2lzTVB4dDdaRmtsaTZ6WWhqWlIrc0tZYXhOSlQzZFBjbjFsd1dG?=
 =?utf-8?B?QkQ4cFNxb21hcGtEcExMekQ1akFDamljRlE0TVFFRVJJcW13VW1wS2diaCty?=
 =?utf-8?B?V2JxSXJETkFjZGY0dEJvejdRK0tKbHFEMGFTQjlseUZLUCtKRWVLTzlycVVR?=
 =?utf-8?B?M25YWXNCWllkMFRXTE9SaXVyelNWZEt4Ly9jYk9TV1gwdVNrN05YUjN1OUR5?=
 =?utf-8?B?SUtXb3hQcUpkbXJjMlpqd1JvU3Jmakg3WmdZcGJUM3V1M3lvL0svT3NFMmZP?=
 =?utf-8?B?WkxieEJ6UlJqQTd0NHVvRG9qQXB6RzMyL1EvU0RUOWM3MzE5dVlkMitwL2Zp?=
 =?utf-8?B?Tk5WUUhodlJiNUIvRkwwNGlCQmdOUVNCVlIxWldjb0hsdjVHZzdCN3BoZDlU?=
 =?utf-8?B?YkNXQXhmRFdMU2dMS2JVT0R0RlgrQTdITm5xbDZ6a0lpc2FhWEt3eFRJTXNL?=
 =?utf-8?B?TVFZS1g3RDNwWEUvR0N2K3phVTY5Ti9pclM2RU9rbndYaU8xV2NMSlU5TXky?=
 =?utf-8?B?M2h4VVQ0NGl4SUdFSzIyZkJSbU4vemV5Ykc5RVFsYXhtN0RPUzNsRS9ISFcv?=
 =?utf-8?B?UkJOU2tyZWZnK0NNRXMramNsTG1pcmV0eDVqeHFzSlVrS1luOXR3eEhZQnRq?=
 =?utf-8?B?dU4zOXN4bzR6UWI2d25jNzdyRVRwaWNmNjlnT083YlFGS2kyKzF0NSswMkRk?=
 =?utf-8?B?QnExUWlqUEdpbHRSaG5jTFdFU1ZGUGZBTit1NjM0M2F6MHRWdXhaTjkvTUtG?=
 =?utf-8?B?bWh4WGpWY1JRVWg0SGNVZGNoNnNjZGFOb21aTDgxcDdmT0E4cHhFYThyazdP?=
 =?utf-8?B?U3JBQU93dkZuL1pGbnFRb2pUNHFpclBFd3lmU3c1RnVwaW16bUIxZXoxQzFi?=
 =?utf-8?B?bFFxdnpJUDJDZlVXZE1yWWxLTjBqL0U1dnc0VDNtQXFtZyswY0s1OVd6WVYz?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b38b1159-8f32-451f-ea92-08db24e6f706
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 23:51:00.7935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I/4+dGf7udBvcHz+uDLl9dSOnq4n2PSg1QlrGtGThiUVvy+aPxmXOuLGDs4lBu1HlkrDQzxpi5t1ckEEuiqEywSeKEzX2PS35qe0rK+ZxEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5693
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRWR3YXJkIENyZWUgPGVj
cmVlLnhpbGlueEBnbWFpbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDE0LCAyMDIzIDY6
MzUgQU0NCj4gVG86IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBNb2dpbGFwcGFn
YXJpLCBTdWRoZWVyDQo+IDxzdWRoZWVyLm1vZ2lsYXBwYWdhcmlAaW50ZWwuY29tPg0KPiBDYzog
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbWt1YmVjZWtAc3VzZS5jejsgU2FtdWRyYWxhLCBTcmlk
aGFyDQo+IDxzcmlkaGFyLnNhbXVkcmFsYUBpbnRlbC5jb20+OyBOZ3V5ZW4sIEFudGhvbnkgTA0K
PiA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0
LW5leHRdIGV0aHRvb2w6IGFkZCBuZXRsaW5rIHN1cHBvcnQgZm9yIHJzcyBzZXQNCj4gDQo+IE9u
IDEzLzAzLzIwMjMgMjI6NTMsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiA+IEFoLCBzbyB5b3Ug
ZG8gaGF2ZSBhIGZlYXR1cmUuIFllcywgaXQgd291bGQgYmUgc29tZXdoYXQgaGVscGZ1bCBidXQg
bXkNCj4gPiBsYXJnZXIgY29uY2VybiByZW1haW5zLiBXZSBza2lwcGVkIHRoZSBkdW1wIGltcGxl
bWVudGF0aW9uIHdoZW4NCj4gPiBpbXBsZW1lbnRpbmcgR0VULiBUaGUgYWRtaW4gc3RpbGwgaGFz
IG5vIHdheSBvZiBrbm93aW5nIHdoYXQgLyBob3cNCj4gPiBtYW55IFJTUyBjb250ZXh0cyBoYWQg
YmVlbiBjcmVhdGVkLiBXaXRoIHRoZSBjb250ZXh0IElEIGJlaW5nIGFuDQo+ID4gdW5ib3VuZGVk
IGludGVnZXIganVzdCBnb2luZyBmcm9tIDAgdW50aWwgRU5PRU5UIGlzIG5vdCBldmVuIGFuIG9w
dGlvbi4NCj4gPg0KPiA+IFNvIHdlIG5lZWQgdG8gc3RhcnQgdHJhY2tpbmcgdGhlIGNvbnRleHRz
Lg0KPiANCj4gSGkgSmFrdWIsIGFzIHRoZSBvcmlnaW5hbCBhdXRob3Igb2YgY3VzdG9tIFJTUyBj
b250ZXh0cyBJIGZlZWwgbGlrZSBJICBvd2UNCj4gdGhpcyBiaXQgb2Ygd29yazsgSSBjYW4gdGFr
ZSBhIHN3aW5nIGF0IGl0LCB1bmxlc3MgU3VkaGVlciB3b3VsZCAgcmF0aGVyIGRvDQo+IGl0IGhp
bXNlbGYuDQoNCkhpIEVkd2FyZCwgd291bGQgYmUgZ3JlYXQgaWYgeW91IGNhbiBhZGQgdGhlIHN1
cHBvcnQuIEkgd2lsbCBtb2RpZnkgdGhlIFJTU19TRVQNCnBhdGNoIGFjY29yZGluZ2x5IGJhc2Vk
IG9uIHlvdXIgY2hhbmdlcy4NCg0KR290IGEgcXVlc3Rpb24gd3J0IGR1bXBpdC4gSG93IHRvIGlu
c3RydW1lbnQgZHVtcGl0IGZ1bmN0aW9uYWxpdHk/IGV0aHRvb2wgZG9lc24ndCANCnNlZW0gdG8g
aGF2ZSBhbiBleHBsaWNpdCBvcHRpb24uIEluIGV0aHRvb2wgdXNlcnNwYWNlIGNvZGUsIE5MTV9G
X0RVTVAgaXMgc2V0IA0KaW4gYmVsb3cgZnVuY3Rpb25zIA0KDQogLSBubHNvY2tfcHJlcF9nZXRf
cmVxdWVzdDogDQoJaWYgKGRldm5hbWUgJiYgIXN0cmNtcChkZXZuYW1lLCBXSUxEQ0FSRF9ERVZO
QU1FKSkgew0KCSAgICAgICBkZXZuYW1lID0gTlVMTDsNCgkgICAgICAgbmxtX2ZsYWdzIHw9IE5M
TV9GX0RVTVA7DQoJfQ0KIC0gc3RyaW5nc2V0X2xvYWRfcmVxdWVzdCA6IGNhbGxlZCB3aXRoIGlz
X2R1bXA9ZmFsc2UgaW4gZXRodG9vbCBmdW5jdGlvbnMNCg0KSG93IHRvIGdldCBkZXZuYW1lIHRv
IGJlIFdJTERDQVJEX0RFVk5BTUUgPw0KDQo+IA0KPiA+IEFkZCBhIHBvaW50ZXIgdG8gc3RydWN0
DQo+ID4gbmV0ZGV2aWNlIHRvIGhvbGQgYW4gImV0aHRvb2xfc2V0dGluZ3MiIHN0cnVjdC4gSW4g
dGhlIGV0aHRvb2wNCj4gPiBzZXR0aW5ncyBzdHJ1Y3QgYWRkIGEgbGlzdCBoZWFkLiBQdXQgYW4g
b2JqZWN0IGZvciBlYWNoIGNyZWF0ZWQgUlNTDQo+ID4gY29udGV4dCBvbiB0aGF0IGxpc3QuDQoN
Cj4gV291bGQgYW4gSURSIG5vdCBiZSBhcHByb3ByaWF0ZSBoZXJlLCByYXRoZXIgdGhhbiBhIGxp
c3Q/DQo+IEFGQUlDVCBldmVyeSBkcml2ZXIgdGhhdCBzdXBwb3J0cyBjb250ZXh0cyBlaXRoZXIg
dHJlYXRzIHRoZSBjb250ZXh0ICBJRCBhcw0KPiBhbiBvcGFxdWUgaGFuZGxlIG9yIGFzIGFuIGlu
ZGV4IGludG8gYSBmaXhlZC1zaXplIGFycmF5LCBzbyBhcyAgbG9uZyBhcyB0aGUNCj4gZHJpdmVy
IHJlcG9ydHMgaXRzIG1heCBjb250ZXh0IElEIHRvIHRoZSBjb3JlIHNvbWVob3csICB0aGUgc3Bl
Y2lmaWMgSUQNCj4gdmFsdWVzIGNob3NlbiBhcmUgYXJiaXRyYXJ5IGFuZCB0aGUgZHJpdmVyIGRv
ZXNuJ3QgIG5lZWQgdG8gZG8gdGhlIGNob29zaW5nLA0KPiBpdCBjYW4ganVzdCB0YWtlIHdoYXQg
Y29tZXMgb3V0IG9mIHRoZSBJRFIuDQoNCg==
