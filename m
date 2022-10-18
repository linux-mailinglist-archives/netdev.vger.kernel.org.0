Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12848602BED
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJRMmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiJRMmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:42:24 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1193EC34C7
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666096943; x=1697632943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eOCzQX4kn79A2aRj0+EBYrCSUmzfIHSdDOpE5v0yubM=;
  b=bMsPWAC05vPPGwptGTY/ZVPQi0k90y/+aa4MB+qNm8gqzl0EOeg1BJwa
   kXL++dJ6PjrmJiEsgV9IGjMBRlFcwXZXNYDTDY+Of63bpJzcuFthTncav
   c/KvoRmMFyMsCgnb8BSJeLVFNNyYAsCZHd2tNX1nsvI22ktDWuYtyka2J
   dUTvt5R+ao9+OzsvxgU1vOaYjgfiKUj5dRj0jduzjDbcoHQuBroFIICKZ
   7nRqfmhizygX+mo/G6rElu+yj9gJzPT6xoeofhGLTXPRNXI3Hx5s7Fwn/
   k4G0egKCPxDpP0AUUYV2n1+p7YsZk0ZoUVFD8ILC5VycRb/qldqB8IgiS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="307753712"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="307753712"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:42:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="659772251"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="659772251"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 18 Oct 2022 05:42:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 05:42:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 05:42:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 18 Oct 2022 05:42:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 18 Oct 2022 05:42:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSc4UokQdnybZlwTCig0ATE53u33WFFLJJz2Baz1P3w+4B1u1K2WYWNXzUdwNCBqNLD7mfRPoMb1VOOdkzbb/O6RygPiAFU0iehwGZEVFTDsrNnLVQUra/Dp8KWSsrpKKPvGSELZUGUf6RsDHyreAJgByWkv+bsZJltu3aORVaQvlgaBXZZOAy8yGHXuc7jSoPXaz8bQXTudAaJPeURdXPtkHSGFLeaNf3Ph6l7PFirDmnPqEsLEZPSFiZJTQhEYPkFFu+qgsCqKt3OkqTxCFQgkmjLzyKUk6NRTRd6qo/E+eFOhtxpw7u6PYeZMQHuDDFKSYCIoyx7lkpFUzR+jvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOCzQX4kn79A2aRj0+EBYrCSUmzfIHSdDOpE5v0yubM=;
 b=PNx1VUwGlV/k6IaiYZHn3sXGf7AiPQzcHbi50p9qY1x02/hTi+rTGmHtnUy9hkNBhs51GH3rvuHv63yfl6sVrycyeusWq4nS27JNkzOnvg0VLj7Nh62v1NdmfJwAzkTK0yvg9Pho9XnsBiZzysc3oJM3i4hxn7DOAMKL82GRQj6jBHtjbBk8I6lh+0/M17Vl0CpBK9XGtcuNu2e7ZC/FOrckBt1taV4RxfkuAF/zi/qcZ5nmUMPR2SpvWkVigXs7YntvdkzjKJy/VOE4R0MpG5YGMyER4xFpVVTE4+yyiLWf0ODwevNWxUqrK6hqqMi32SRgxOnH8/qquIP33Nrh3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by CH0PR11MB5523.namprd11.prod.outlook.com (2603:10b6:610:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 12:42:18 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::ec4c:6d34:fe3f:8c60]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::ec4c:6d34:fe3f:8c60%4]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:42:18 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH v2 2/5] net-timestamp: Increase the size
 of tsflags
Thread-Topic: [Intel-wired-lan] [PATCH v2 2/5] net-timestamp: Increase the
 size of tsflags
Thread-Index: AQHY4o5BvKl9xlq55U+onFKq8crdl64TqAQAgABkouA=
Date:   Tue, 18 Oct 2022 12:42:18 +0000
Message-ID: <SJ1PR11MB61805649FCF0704E2EC2338BB8289@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
 <20221018010733.4765-3-muhammad.husaini.zulkifli@intel.com>
 <2d522491-e4f1-9e4a-c713-4adc4990f04f@molgen.mpg.de>
In-Reply-To: <2d522491-e4f1-9e4a-c713-4adc4990f04f@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|CH0PR11MB5523:EE_
x-ms-office365-filtering-correlation-id: e8cdf204-2ea9-43c6-c7ca-08dab1063147
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c7bm4Fo80CsBM8jmEHJKpBCT91Bggk7bBMir1yOK47ZwrmWFTLpEFx7DXDxG6D0geXyjR5wOHjfWLqibgzmrULB1DLJz7P4mYHPNo4HO6cUdWbLeFWYXIe0GEAxIdIfBfughkinoB+spel+gpD8F5mPVbNfo5IvZoZtI6u7pTEtIs5wt84363lI7rtIeP5A23lF8nQHBoyxfBBedHzhJ/gAGuLl1et/RGPwC2jO9uJ4k7PdhIt/h+GJbbMGMEUKV7X3d3JGw+3hkO3wZVqn0aADOJ/Wx3gB50L+jA0IAQnNBrURp8cPLLcyI+LRHtZak0Xq4drQ6RdNO+Eq2TVuymgGQ237gpRuBtQZ8euvPBnu4BAHFyTFnxXpnsUXd0oWTn0aI+jwyy+0RQHe2EBncTblEn4Iayp1AeHhwFht4dftm1SNrth+07rSJ2kdqFC3ABza3cJfKcdY9Sqr6mBgZPVPgKxav7NJlfiaVJPIPJs3QdpvqLZcPSZSAh6oOgrUey2hwkVpO9xwUFL/fxo5CedrN1rbYoY7n56O7EyxHmbDy2Q8el4oGH+geYbnd4BsttWTCPURORBeUiK/UDw8j7Xr7N+FBv3w0SzDeK023KqXbipqr6afEGVsGWHhqbvkI4hpIB2WzrD462SSZpaLGkAwngHHe8VIVaIezpqEQXQeTOtI3iC0AF/gnEprM04uSP9jFz5wUUeZTRXGsV0MKr3ZEehOuu/LmqP7KPJF9xT5bGmeAd7R5rEouuuA60rUUugEEqe5Ud6rkKM46VpF5IQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199015)(33656002)(86362001)(4744005)(5660300002)(7416002)(2906002)(38100700002)(82960400001)(186003)(71200400001)(6916009)(83380400001)(38070700005)(26005)(7696005)(6506007)(316002)(53546011)(478600001)(9686003)(54906003)(41300700001)(66476007)(76116006)(66556008)(66446008)(66946007)(122000001)(55016003)(52536014)(4326008)(8936002)(64756008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmhETWVZK1ljUExibmxpS0NRQU1MNFMrSDU3MllKbktVQjVoN25DZFlxV0FN?=
 =?utf-8?B?R2VYclJ6ci93R3EyMG5NZnhEUnpyWmtHSzVHNDVZYktwaEZQSFk0MFA2UEtG?=
 =?utf-8?B?eXFiTkxLZXErUGtnUWxudEZMYUxjZm42b00wOHVNdlJteVRZaVJrTkdMWDB0?=
 =?utf-8?B?NFFqUFpWWnpUSTRTYXFqYmt0cVhqblQ1c0VpamJDWWlCMDlTaE55UzhvYWxx?=
 =?utf-8?B?NjdRSUVUaGhaOUxwbzY3ZGo5NTRrZHU5S3l3d3NLT2ZlVVVkTytZWjBmUFFl?=
 =?utf-8?B?bVJXUWpKRUl2aE5Fa1RmOUhpbFNOdENnSk12ZWlIMGIycHRjRXF3VGN0RUZR?=
 =?utf-8?B?ZWFsdnUyWm5IeXpENEJ3Rk5pWTZjY1phaWJBRGZXZXcxRmE4TEMvcEFVeXBx?=
 =?utf-8?B?QnJ6V2NaWTRac3lJSVFSb1VpVm5TNGl3Y3lQR2VSTFNLQmpIY2pvQUtkaGtL?=
 =?utf-8?B?WVB6aTkxbmdWQzJUNFVUakZEMmFrK3VTTWdJekJGYVdJdVpTcE5VZGJDRlJL?=
 =?utf-8?B?S0U5ZHFDajRqQlZnQ0FIS1lNN0hpT2hlTFU2Q29KK2hteEVVZGN5b1h5NDkz?=
 =?utf-8?B?c1pKZ0V2R1lXYitIbFZLM0J5VjE3SGN4YTd3YVJDRk02TStncWFHZy9LMCsy?=
 =?utf-8?B?Vll5K0FuVGdteDB1Z2dQUVJMRnduaFRDTURlbDA2YTF1cXVIdlovSGU0a29G?=
 =?utf-8?B?Zlo3eUYvVEovT1lUR3hSZnFOb2w2ZlNyMzBWdS95OG1WZm5WR3lST3ZEbmRy?=
 =?utf-8?B?VkFTd0xEOUFCekM5Ni90eWVkRit3TllpZ2lkVUROSVQ3RXhwQTV3RnZISE9a?=
 =?utf-8?B?OFVrNEl4eWxEVGcyNEZYZnplRkYrVW16enlGN0FaenFmL0VPRE1FSGtPUXdT?=
 =?utf-8?B?bW1lZFdnZVhzcjl1Mnc1RFJmaWZ5dWNQQXMzN0lEODVWbmppNUdjTkZ0OUg0?=
 =?utf-8?B?eEs0S3lZREIvSGdCL0xLd3pUdGU2aGRjOFo3WmNKZTVwaFZyTDRKV2RxSWNM?=
 =?utf-8?B?MzByazhpMlJzZnlqN2QzMUpqcUZseHF2dzJ4NGMyZ1ZjVjZLQjZJZE9yOUNX?=
 =?utf-8?B?Q0VxZ1BXQTR4dzd2UEtmclM4dndRR1EwV1pGbmVtVVkrRW9IcmxUaEFjNlBH?=
 =?utf-8?B?NWZXT3NZYVJCb2IwWUpOQ0ZHY1NsOWFxQi9ZWTh4cnczRnFaTEtJaGV6ZDJ5?=
 =?utf-8?B?MDBONWlpSUlnZktQaEdvZnJodXl2OVF3NUw2RzFmYmJ3aWF2WVlMT1ZlV0xI?=
 =?utf-8?B?cTB4c0hUVFl2dnV1aVNtYVFLQzk2RlJFUVZ0M2Qxck01VHBYOWh1V1VxZGQy?=
 =?utf-8?B?RUtZeFQ0bWRCU1BjRGZlVmN2akVCVnVTY09HWTZJQzJXY3hqb3ZXSGhHVFJZ?=
 =?utf-8?B?U1c4SlA2b01BRGpXNmx2NUxIeFVPSHRYOGxRa0JlUzRRdVhUQmdtWnRVSFZ4?=
 =?utf-8?B?cEFOcXJidURJVzVORzR5V00yaTNkMXozdG0rNUJkQnYvSEx5QklhSEdSaGRl?=
 =?utf-8?B?SElPc1ZNY0o2YXo2V0dEM2NHbFVxWEJ4UmRMM1JZMFVnTFl6UDhVUklLSGFN?=
 =?utf-8?B?T0dDMXhyU0NFU1NNZVpabVhwSGdQUnYySEZUSmMzbTZ4Vk9EQUpiZTRuVzdw?=
 =?utf-8?B?dFk5aFdZTUQ3cjlCKzNLTVNvUWpzQnd5bjZiNWxrZGNweXR5S1F6aGllaTdv?=
 =?utf-8?B?QU5BVGJqVjdPa29DM2wxRDM1OHBvTTBwWlc5d0JNU1ZDc1lIUmYrcWplempz?=
 =?utf-8?B?bGFNQThpNFh3aEh3am02Zy96QTFaUTE3ckZCL1NPNnB4RWJMN3c4Vk5tTEwx?=
 =?utf-8?B?TmZRKy9xOTF4VkVQVU14YThRM1FFc2p0S2FBZ2d5REhvWDBnYmdJSE1PeU9t?=
 =?utf-8?B?WHdKdmZ6bmhRQ1FmYUNDcUQrWEI1VXNnckQ3ZDZOMWFUSzNXc0IvRkFMMEN5?=
 =?utf-8?B?U3JPTTdVZ0hTalArQzlneEhDUlFKaFY2Q0dUSEg3RnlpQjBaSzNQUTJ4R2lh?=
 =?utf-8?B?L2lXZmdGbTZma0Exd2owUFVkbHNjLzFSQUtIWldKTEJQQVc1dmgzZjJnN3J4?=
 =?utf-8?B?dHJoR0RTVUpaUW9jaFpKamVYWlE4eTBGK1BkL2FpYnc4REFvNzl1N0FxMXNY?=
 =?utf-8?B?REpLNUhJaUp3WlZMOGRYa3lSSG5aZ0RYM1hqNFVmcVh1Nkg5bkk1N0Vqd2hu?=
 =?utf-8?Q?NxTlGPz71zUOV/exXMIUWQ8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8cdf204-2ea9-43c6-c7ca-08dab1063147
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 12:42:18.0898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /++F7QpMz2gVbjPjN6sgCU37/z9mV6mQw5tdTM7QcYFb17ifwaNCw9C6tw8D9Xn0bpQYdw8y2lOXSRS44PSbTK6l7xqDpmsyzKuGaaW1oVSZDg1+izOM6QTmjdxmw4LA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5523
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF1bCwNCg0KVGhhbmtzIGZvciByZXZpZXcuIA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+IEZyb206IFBhdWwgTWVuemVsIDxwbWVuemVsQG1vbGdlbi5tcGcuZGU+DQo+IFNl
bnQ6IFR1ZXNkYXksIDE4IE9jdG9iZXIsIDIwMjIgMTo1OCBQTQ0KPiBUbzogWnVsa2lmbGksIE11
aGFtbWFkIEh1c2FpbmkgPG11aGFtbWFkLmh1c2FpbmkuenVsa2lmbGlAaW50ZWwuY29tPg0KPiBD
YzogbGVvbkBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyByaWNoYXJkY29jaHJh
bkBnbWFpbC5jb207DQo+IHNhZWVkQGtlcm5lbC5vcmc7IGVkdW1hemV0QGdvb2dsZS5jb207IGdh
bEBudmlkaWEuY29tOw0KPiBrdWJhQGtlcm5lbC5vcmc7IG1pY2hhZWwuY2hhbkBicm9hZGNvbS5j
b207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGFuZHlAZ3JleWhvdXNlLm5ldDsgaW50ZWwtd2ly
ZWQtbGFuQG9zdW9zbC5vcmcNCj4gU3ViamVjdDogUmU6IFtJbnRlbC13aXJlZC1sYW5dIFtQQVRD
SCB2MiAyLzVdIG5ldC10aW1lc3RhbXA6IEluY3JlYXNlIHRoZQ0KPiBzaXplIG9mIHRzZmxhZ3MN
Cj4gDQo+IERlYXIgTXVoYW1tYWQsDQo+IA0KPiANCj4gVGhhbmsgeW91IGZvciB0aGUgcGF0Y2gu
IEZvciB0aGUgc3VtbWFyeS90aXRsZSB5b3UgY291bGQgYmUgbW9yZSBzcGVjaWZpYw0KPiB3aXRo
DQo+IA0KPiAgPiBuZXQtdGltZXN0YW1wOiBEb3VibGUgdHNmbGFncyBzaXplIHRvIDMyLWJpdCBm
b3IgbW9yZSBmbGFncw0KPiANCg0KU3VyZS4gV2lsbCBkbw0KDQo+IA0KPiBLaW5kIHJlZ2FyZHMs
DQo+IA0KPiBQYXVsDQo=
