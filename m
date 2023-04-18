Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCD66E6610
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjDRNf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDRNfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:35:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDEFE40;
        Tue, 18 Apr 2023 06:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681824954; x=1713360954;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AdGUNkH3OGSCG/OsF9G60Nue2GUHdEgO99+fQBLoTRI=;
  b=bnBzDhNnZqYAUiBWWtnEHBMeKXwvarU9cpqrJWu08rkUWqJ/5JFhsKuo
   2oOC0eH6gyl0ecmVbg1pcpKa9r6DqhyWe2vo9RYKuLqlRDOcEv5D8he9s
   tfKPyxIFHPyHZMDMRimo6m//2hxRdW/7Ffl971bJVckupkfhbqHSYeHKF
   tQCIsbtN0OvRJikYjj1DqqdRG3KmWUReiUGmwRrkjLAS8Xr2P3oCpC+Ut
   bkoIwH653itl2VAMwYiN3kCk93/sJ2YLRRpHVlZL0NyA0ImU5qTeANnA9
   W8UkrejFj0CUGT4U0tvFF8pZtbnbvou6QzzwtgkQ5qeH0AepfhvRA9Rt+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="410390901"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="410390901"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 06:35:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="721512362"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="721512362"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 18 Apr 2023 06:35:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 06:35:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 18 Apr 2023 06:35:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 18 Apr 2023 06:35:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRcrPNbNw75YSbHJ4FEJ0zl0c83vFpIHo+qEjFPycwkmltwvMTluK7asE4WWQAfCeL9zAdhPx4uoQ/ggj6JaizxSZ+d0EkyBRSFeoMAuO75NuHbAMSHRswPFPwVv6tFYptpZ4CDFoXFT5GbUMRYbgP+SmVEvOrPCf8bk1QjJP9qE3VwRV9HJWUPDrwRR8lCpg+pZHUU2cGidyHXu+bHCgWsNiNb3els46xAVJGrOSDpkSbnQGwuyL0dbB8ZksnvS/PmPusMHabGx6ZAJB+lNk2Csegvm3YEDsBPfrp37ptTJqZ3wWQF8kWDmjqg1Rhf+NvKKpoIdUYMOgScdIlU+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdGUNkH3OGSCG/OsF9G60Nue2GUHdEgO99+fQBLoTRI=;
 b=NfwoCF/NUFMsy/j9vmmT6kqJDEQrne/KdmmLr11OBBPT/ivICayjN+/MSy2c+uIrinfJHWWit2uhc9RLyMVwk0rGpphWKvnuejVPriFQ5wiBroh7FSRl5CRihBCxhbxhxuKqwFm3U7ExdoPimSinmOKROjAZ6Bt/kOSIDR4RQTElc7IwUUPVMWzokPM7i5PvsJDILV9MwjQBGL3rz2AA7AhUSNOvzXWi/awcgolE804MLfzhdiWHa4O7xwh4EEFktiUQDE3Br6qTOdb6NzgjREDvOcWRVAai3AW8AlEtU2Kui4ImEh1seqX9KTwuLFMIycBqpR0DvCSCbqXfWQLGWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8)
 by PH0PR11MB4904.namprd11.prod.outlook.com (2603:10b6:510:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 13:35:51 +0000
Received: from MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::590:168a:7eda:e545]) by MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::590:168a:7eda:e545%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 13:35:50 +0000
From:   "Greenman, Gregory" <gregory.greenman@intel.com>
To:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Stern, Avraham" <avraham.stern@intel.com>
Subject: Re: pull-request: wireless-next-2023-03-30
Thread-Topic: pull-request: wireless-next-2023-03-30
Thread-Index: AQHZY0owVlnv36mNfkmfy3oRVu4Fa68UeCMAgAW9VwCADnV3AIAIg9kA
Date:   Tue, 18 Apr 2023 13:35:50 +0000
Message-ID: <ccc046c7e7db68915447c05726dd90654a7a8ffc.camel@intel.com>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
         <20230331000648.543f2a54@kernel.org> <ZCtXGpqnCUL58Xzu@localhost>
         <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
In-Reply-To: <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5987:EE_|PH0PR11MB4904:EE_
x-ms-office365-filtering-correlation-id: 04048e24-c554-4f64-0249-08db4011d34f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BtcXwdCzd8EIWZO/e+QLE5q/dsL3DZLIX41RsGOLjb/o8Vus9tsx2v03GbZIAYW2MY4Q16A7D7aOadrITgWcRNuyilGlTpnDVx6qs6cYZlN3CHqJZpbUW1TGNhXvm+2zMRLlVWn0dzGOMLur45MDpC/eO0z8eFNR6pCf7AmKy/Yfm1Q7BRJ0YPG2B7ltEX6qcTHEiU85ot18at4aKn9YB5nN8AbUnlsTPpxNLv60XYXuadjO0wSL5o9tLtZnORaoH+XTAoVAETh9iBi+k/wfAyePM0KQ2neMXTq3Yfd1zOprAv1LAg8KirSeIYglQZe9HaaHy+Lzexi2xJfvVLrdhvwTyP9Ig+lfHEZpuf+ceR1rwIDuYU8/VZNm6B3t8eogDNrilK3Rz1nTUoV1G+JzqPJC8/+5L4DIHwnLem/g9fNfpqpLSJo7XyVPK1tSgk0rwFi891QKNWKrKkv5fT5brV3bBBP8cCtYRD2AGL1rPtV01ZJgrXxD75TMmUA1+NLZn4uiaJ6GN+1VXn+HIyeoe6tJ73lgoJzEv5x5RxQtkUJ5/9p2GuoGZ0RF90eDw98CZ+Zw9LugnEEnBgsCM6UrKBThELkhFBp01UvjFbuYzguJLYXZHFwvjtsNyNHs1oUf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5987.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199021)(5660300002)(86362001)(2616005)(107886003)(6512007)(83380400001)(186003)(122000001)(82960400001)(26005)(6506007)(38100700002)(8676002)(38070700005)(8936002)(478600001)(54906003)(110136005)(6486002)(71200400001)(316002)(76116006)(41300700001)(91956017)(36756003)(66446008)(66476007)(66556008)(4326008)(64756008)(66946007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzhLN2w5eVppTjBLYUx4RDUrckg5ZUtDTVdGSDlud3lseGE4ZzBVWkVReC9O?=
 =?utf-8?B?bTVnazNXMEdiTHB5RW53cEtiOEd2ZmVsZDkzRHlQNlB2VmM2YU9kTzR1RnlK?=
 =?utf-8?B?eitvajdQZUJURGVOMktHWlFlOGZqaUtta3N4RkxTNVpqK2dHbXYzNk5qLzZJ?=
 =?utf-8?B?QkVNdkVuMHZZWWplcHFLV01SRUJTd3N1eXNMS2s2MW1FM1BTelVYeEU1Uk9R?=
 =?utf-8?B?N1dxU2NVT3lZc1ltOFZoKzExT2w1R0ZxamJacGpUZlhQQ28xVHRHbFowU0NK?=
 =?utf-8?B?T0JQL2lYQXJkcUlrMy9SUER6K1JqTG4zWHVibnI0K0MrQy9sM2dIbDl2Vnh6?=
 =?utf-8?B?REtvV0Y3WkdFY1h4MlQrMTQvMTRpbkJFN2YvWS9JSUlnNHNPSVh2ZGVISXNJ?=
 =?utf-8?B?Y1laQm14U2FqczFXVlpZd2FKK0E4OE0rcnVlN3NTelQvWldUVXpmRzdqNi9P?=
 =?utf-8?B?aU00VUpJeHdwMk9BcXBEcnBFR3dZUmJJaUdZYVhlb0ZDcXd4a2ROQjhRQ1d2?=
 =?utf-8?B?ampoVEVlOFFyWTFCZStheFdZdU42cWlKTThJeVN5NnI4Z1AwWVFZWTZYR1Fx?=
 =?utf-8?B?T0Z0TGp6ZTJ2b1RqaUdlS0hUZTZRV1lnZVg4dU1pWTZHeVBLQkJYbWE3MUFZ?=
 =?utf-8?B?YjFmMkhLMnoyRXkzL2hIaEgrbm41UTBIcnJXa0crdndTbGxrS05rRUhaQVRY?=
 =?utf-8?B?SlIxRGlOVEUzTy9ITFhSMmVWTGhRQWdlWFljdzBrSjNpSURqdzJiZnRLU2hv?=
 =?utf-8?B?L2wwT1p1eXhWNWMza3N5a1BzdDdFL0pVVzVHUlhzVHNrdUZVMXhCVDNodnMw?=
 =?utf-8?B?d1k1U1dTOFpTNkg3UUIwTnk5QVRscHFYVmU0eC9OMWhra3IxYXRmSG1GSU51?=
 =?utf-8?B?bWZCZVBhRWh5K2EvbHhvd0I5K1VrKzRVZ2U5aTNRUjhkdVBCbzl6Nmx3WmpC?=
 =?utf-8?B?cjN5bXFwTElENFFqUXJhR1R1Rmx4dU1yVkZwWS90Yk5lRnlWK25nNDNCVnRC?=
 =?utf-8?B?a3RHSFoyaXRBaU02eTJWS25MU1RQb3NwOURZcE1ucmNBeG82WnhkOEI0aHgz?=
 =?utf-8?B?N05QQWNCN2owbUxiRWFJZFJMQy9abk5abGVCZk1BYmlqVnJPOUtrQ3BZYUpP?=
 =?utf-8?B?SUNQb3V4ZVhSOUZ6MVBuNUwzZFdSUG9KQnN1aHhORFlPb1FtQ3hwWkYvM2Zq?=
 =?utf-8?B?anI3NzZWdGx4UEhQeTBOOWIrVlFKRlN1UnpEVFlhYjBVOHpXUjRIMHdGbW5j?=
 =?utf-8?B?cjlJR2UwME1BUUo0cVRQRU5SQUhQRGJ6blhUTW96UTVicXZkWVNNbjkzQmxo?=
 =?utf-8?B?YW1JejRLNmxhN2pYcVB2dUowQWNlK1ZGRjFTY05ZeEZPaHA5b0VoelBPczZs?=
 =?utf-8?B?RnFZUmFZUkkzUlJsRld2M05XQnhNcjZ3cTVJK2RkZEczNnc4VWh2eklqSlds?=
 =?utf-8?B?UmJDSGllbFVhVnVyUTZ6TVRjTUs0Y2pMT1NIdDlHOE0zSVJ6UEpQaTRya21i?=
 =?utf-8?B?UURaSHMwSzRxdmtBSnN6akhkbzlybG14dy9XUlhuelRFbGNobFhpUlZOeTdi?=
 =?utf-8?B?ZjNLNzdGa2J3TEtmUmRQaFFiVCtJc0FmQlYyRG0yMFZKQmVOSE03OGk3MXNn?=
 =?utf-8?B?Z0szaDFacVpsRTVrWkJSTCtwTDMvZWN5SFF0cDJsc1hyRDIvUjBRSXNqN1FG?=
 =?utf-8?B?ZkJqVFhrVXJCWng3UlV0d0QyY1h3aFVsWnVUekY3N2laMzJIWVZPVUNBSmdh?=
 =?utf-8?B?a1p3b1NNcXVSM096VUZ2bEttQTR2UVpjRkNEcFo4R2VZdlFHdXM5eW93VHBl?=
 =?utf-8?B?cncvLy9PY2hGd3NYcWJyMEVYUlNEZmlwaGFycVlHN0MwYXNqaDU0TmZkMDhr?=
 =?utf-8?B?YWZ2NFFlMkJUeGNtRFQ1VGdNUEJULzVNa1huYndNZ2ltekxpVHU1eSttQXhI?=
 =?utf-8?B?Q2hIZnRodExlMjZ1d3RTK0ZqanVyUk41U2FmVHRCUmhiaDdJbk9HU3RudHVB?=
 =?utf-8?B?VDlaODlac1gwemtEOEtZU01JcnMrdnpHblMyYTZ5U3FSNUlPNzg4UHR1N3FJ?=
 =?utf-8?B?YTJNZjVMQVprV2krN1RKUEErdWcxRENMazBUa2lxenlkem1RY3BHOUZlMVJL?=
 =?utf-8?B?bFhRanFFMDhTZktYRHZjZHdLTE16NzdQaFVmbjc3U0NpVWE5VnNsWDRNWVRG?=
 =?utf-8?B?Y3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2631F9B1398FD64287A0F20D8C04C241@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5987.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04048e24-c554-4f64-0249-08db4011d34f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 13:35:50.6518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lgll3mcJJVOjM3OoozOHP2CFo/q4jJpJdrJ8N8bOqnAK25hsahYRtFPOnC3mYJQRJLUK21b+ExJgDznJ6cn2hBM13zZMIm9phl/cWSq7wsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4904
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIzLTA0LTEyIGF0IDIwOjMzIC0wNzAwLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6
DQo+IE9uIFR1ZSwgQXByIDA0LCAyMDIzIGF0IDEyOjQ1OjQ2QU0gKzAyMDAsIFJpY2hhcmQgQ29j
aHJhbiB3cm90ZToNCj4gPiBPbiBGcmksIE1hciAzMSwgMjAyMyBhdCAxMjowNjo0OEFNIC0wNzAw
LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPiA+IE9uIFRodSwgMzAgTWFyIDIwMjMgMjI6NTY6
MTEgKzAyMDAgSm9oYW5uZXMgQmVyZyB3cm90ZToNCj4gPiA+ID4gwqAqIGhhcmR3YXJlIHRpbWVz
dGFtcGluZyBzdXBwb3J0IGZvciBzb21lIGRldmljZXMvZmlyd21hcmVzDQo+ID4gPiANCj4gPiA+
IFdhcyBSaWNoYXJkIENDZWQgb24gdGhvc2UgcGF0Y2hlcz8gDQo+ID4gPiBXb3VsZCBoYXZlIGJl
ZW4gZ29vZCB0byBzZWUgaGlzIGFja3MgdGhlcmUuDQo+ID4gPiANCj4gPiA+IEFkZGluZyBoaW0g
aGVyZSBpbiBjYXNlIGhlIHdhbnRzIHRvIHRha2UgYSBsb29rICdwb3N0IGZhY3R1bScuDQo+ID4g
DQo+ID4gVGltZXN0YW1waW5nIG9uIHdpZmkgaXMgc29tZXRoaW5nIEkndmUgc3BlbnQgYSBmYWly
IGFtb3VudCBvZiB0aW1lDQo+ID4gdGhpbmtpbmcgYWJvdXQuwqAgSSdsbCB0YWtlIGEgbG9vayBi
dXQgbm90IHRoaXMgd2VlayBhcyBJIGFtIG9uDQo+ID4gdmFjYXRpb24gdW50aWwgQXByaWwgMTAu
DQo+IA0KPiBUaGlzIHNvLWNhbGxlZCAiaGFyZHdhcmUgdGltZXN0YW1waW5nIHN1cHBvcnQiIGFw
cGVhcnMgdG8gYmUgYSBiaWcNCj4gbm90aGluZyBidXJnZXIuDQo+IA0KPiBJIHRvb2sgYSBxdWlj
ayBsb29rIGF0IHRoZSBQUiwgYW5kIEFGQUlDVCB0aGlzIGlzIG9ubHkgaW50ZXJuYWwgY29kZQ0K
PiBmb3IgaXdsd2lmaS9tdm0sIGFuZCB0aGUgY29kZSBpcyBkZWFkIGNvZGUsIG1lYW5pbmcgbm90
IHJlYWNoYWJsZSBieQ0KPiB1c2VyIHNwYWNlIGZvciBhbnkgcHJhY3RpY2FsIHB1cnBvc2UuDQo+
IA0KPiBMaWtlIGluIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvbXZtL29wcy5j
IC4uLg0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoFJYX0hBTkRMRVJfR1JQKExFR0FDWV9HUk9VUCwN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgV05NXzgwMjEx
Vl9USU1JTkdfTUVBU1VSRU1FTlRfTk9USUZJQ0FUSU9OLA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpd2xfbXZtX3RpbWVfc3luY19tc210X2V2ZW50LCBS
WF9IQU5ETEVSX1NZTkMsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHN0cnVjdCBpd2xfdGltZV9tc210X25vdGlmeSksDQo+IMKgwqDCoMKgwqDCoMKgwqBS
WF9IQU5ETEVSX0dSUChMRUdBQ1lfR1JPVVAsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIFdOTV84MDIxMVZfVElNSU5HX01FQVNVUkVNRU5UX0NPTkZJUk1f
Tk9USUZJQ0FUSU9OLA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpd2xfbXZtX3RpbWVfc3luY19tc210X2NvbmZpcm1fZXZlbnQsIFJYX0hBTkRMRVJfU1lO
QywNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0
IGl3bF90aW1lX21zbXRfY2ZtX25vdGlmeSksDQo+IA0KPiBUaGVzZSBhcmVuJ3QgdXNlZnVsLCBv
ciBhcmUgdGhleT8NCj4gDQo+IEkgYW0gYXdhcmUgb2YgRlRNIGV0YywgYnV0IEkgc2VlIG5vIGF0
dGVtcHQgdG8gZG8gYW55dGhpbmcgd2l0aCBpdCBpbg0KPiB0aGlzIGNvZGUuDQo+IA0KPiBUaGFu
a3MsDQo+IFJpY2hhcmQNCg0KSnVzdCBhIGZldyBjbGFyaWZpY2F0aW9ucy4gVGhlc2UgdHdvIG5v
dGlmaWNhdGlvbnMgYXJlIGludGVybmFsIHRvIGl3bHdpZmksIHNlbnQNCmJ5IHRoZSBmaXJtd2Fy
ZSB0byB0aGUgZHJpdmVyLiBUaGVuLCB0aGUgdGltZXN0YW1wcyBhcmUgYWRkZWQgdG8gdGhlIHJ4
L3R4IHN0YXR1cw0KdmlhIG1hYzgwMjExIGFwaS4gQWN0dWFsbHksIHdlIGFscmVhZHkgaGF2ZSBh
IGZ1bmN0aW9uYWwgaW1wbGVtZW50YXRpb24gb2YgcHRwNGwNCm92ZXIgd2lmaSB1c2luZyB0aGlz
IGRyaXZlciBzdXBwb3J0Lg0K
