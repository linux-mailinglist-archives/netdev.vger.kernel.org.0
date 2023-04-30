Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423906F29BF
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 19:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjD3RGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 13:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjD3RG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 13:06:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD8E1723;
        Sun, 30 Apr 2023 10:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682874387; x=1714410387;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1xxbykzLe0UGIz4Zg214sKXJCuM67SRoVAFMwKXlY4k=;
  b=AUhPbi7673aLZ3PaGIiIUzOrwgWWFIt0j6d/l4+E1/SA/S02X7m0VWlq
   8lXkKq9MeEPzjqa2utrZ6L6KYKWh0MkYsKSdkJP/wIQBcCasJbZoUbvD9
   ll4glzaQx3x+yZCfzTmSvZ1p2Ixz7K/9SZ3YgxCgOMd4qz9VfiGS1QHLp
   pp8vWI9yxGC9YN+FelZ8tS2tpiHk97VHGuTsXei57wMQHVFqlbNY9LTqr
   YjVhFqCl8RuX+WgTrtJNts7jR3Bf+6RynxFdP3/rcE5mTN8kMs1LhixFJ
   6oEpaCzeMuxVxVvwEej75Ao4U64UbO/tCLFny1mAUZ6vMgoAY1R3cpxmU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10696"; a="348077962"
X-IronPort-AV: E=Sophos;i="5.99,239,1677571200"; 
   d="scan'208";a="348077962"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2023 10:06:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10696"; a="807171128"
X-IronPort-AV: E=Sophos;i="5.99,239,1677571200"; 
   d="scan'208";a="807171128"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 30 Apr 2023 10:06:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 30 Apr 2023 10:06:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 30 Apr 2023 10:06:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 30 Apr 2023 10:06:25 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 30 Apr 2023 10:06:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4Imk7RngvIPDMPgP/P4zqAFGSH6jgtLQm+T7oQo0YlJqhMOJ85RO7dIWXteG6pSJmLKGtwnq4PPw6FodIn2wQQ0M6gul2wlhbm1UjSnN3OyKNdq4xnlaoG5Lfc085szcGfHnRewWV5pD6hiE3oLU5ffI1MQ/veyQjeFrfMLRju5ZbHSHkyI4qqqeWL8Xjoi66OXfZ7unYIsNi5iZKM1CsadyJbliFmJ3Jo1lBhn9NVwAPf33quse6dv8jwoKvUApN8kAangKHroxWxwZiAzu0rg0oj2J87HF5ZkBkrXo3UWQzl2tgDISkv2BoducWqdmvpaHNmq97NgJYD6BNRivQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xxbykzLe0UGIz4Zg214sKXJCuM67SRoVAFMwKXlY4k=;
 b=FS+IhmUmoIHAePVHhE9QZy5zNgGYylXVOZiOb7uTfOHn8OLU0sj8fRJPFcz0lVk6CvUuUpRTqDNMHBy+nf3gLknonZvHz7Xl1CdgycOy0p7oTonLnW2H7n8l2ninkoT0af2KzXaj0nblWyMoCyd97SHhUZUpnV/N8wi7sO7ouZmr6wLEtuCxVgVsU7C8EEXJQx1CGVWnszyyC5/BeWAoNoRXdgurpNbQXt1L6ZIsAmKBhtiOwNhhO6szsozOAaSSo0v7C68L8Bs1/I1WzwUlhQPl9iA0o6Tb7xNSEMLqnJZB5bahAaHOSoh0VTIuaV2XflorYOxgh4CkFapFLuSAlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8)
 by DS7PR11MB7907.namprd11.prod.outlook.com (2603:10b6:8:ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.27; Sun, 30 Apr
 2023 17:06:20 +0000
Received: from MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::590:168a:7eda:e545]) by MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::590:168a:7eda:e545%6]) with mapi id 15.20.6340.028; Sun, 30 Apr 2023
 17:06:19 +0000
From:   "Greenman, Gregory" <gregory.greenman@intel.com>
To:     "jeff.chua.linux@gmail.com" <jeff.chua.linux@gmail.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: iwlwifi broken in post-linux-6.3.0 after April 26
Thread-Topic: iwlwifi broken in post-linux-6.3.0 after April 26
Thread-Index: AQHZeqQFhB2hgrahf0ygm4jpYqO+b69CmIUAgAEXqQCAAGaxgA==
Date:   Sun, 30 Apr 2023 17:06:19 +0000
Message-ID: <e9c289bea2c36c496c3425b7dc42c6324d2a43e3.camel@intel.com>
References: <20230429020951.082353595@lindbergh.monkeyblade.net>
         <CAAJw_ZueYAHQtM++4259TXcxQ_btcRQKiX93u85WEs2b2p19wA@mail.gmail.com>
         <ZE0kndhsXNBIb1g7@debian.me>
         <CAAJw_Zvxtf-Ny2iymoZdBGF577aeNomWP7u7-5rWyn6A7rzKRg@mail.gmail.com>
         <CAAJw_ZvZdFpw9W2Hisc9c2BAFbYAnQuaFFaFG6N7qPUP2fOL_w@mail.gmail.com>
In-Reply-To: <CAAJw_ZvZdFpw9W2Hisc9c2BAFbYAnQuaFFaFG6N7qPUP2fOL_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5987:EE_|DS7PR11MB7907:EE_
x-ms-office365-filtering-correlation-id: 94934ca6-6df3-468b-0d9e-08db499d3778
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0EM/7qNIBqYP1ANVPppMHt1feBftbargYBtPhTo9lKv9FW/QpYbDjpTs13QhLNz7Wr6tmwoYT42BKXtbfAbTHesN6js+YX6mopxwGgBP7EWktWQyTlmntg7k66UEeR1ZQV1UuN4MR9xVO7RGOYMkocXVJ41MFq0jqId6Gh19Zhy4sJYo22iWbXHVml0PJbWo6ZgNCjcb2dGqT9PUscHmPVlKHS5ppYHLd5exUlgVP+d09VOETXCkEfJitAcUCiOmYM2oK9qK8inxnbFB0eelNAmfLAPJQRCLlfybNOxeJT31QGa+rltoIJHEJSpelRj8chXo6gMIugZulyKThWnNF3xm2K19GpqOwfy8U4f2CJybEpa+fflcy871V7K6vbw7d0NYj6Wj7EBRizAWep7alAfZHPX009Lwyp9G269/jiS97rOlRv3edKGuC8FIVUCr8b7lg9XveUhgmNsOEN1j4Fq+F4qhL1DMXYnRSPJP9xQJpjweyhcqOJB8kYSLHzslwO/d3HhrKaOs2BD+5qp+9CQGnx9nHZBKu65YuVx8ZYFC8wiil4mgp183SdODJ+y3I+PqVMp8UKXkZ+UlU5y0I73mcuA5zG690uICb/thknQilelB9kNz8rPOuq/tZvJ7wDf1GT++pZ99xzKdgKIklg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5987.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199021)(54906003)(110136005)(71200400001)(478600001)(2906002)(5660300002)(7416002)(66446008)(316002)(64756008)(4326008)(91956017)(66476007)(76116006)(66556008)(66946007)(8936002)(41300700001)(8676002)(86362001)(83380400001)(36756003)(122000001)(38100700002)(38070700005)(82960400001)(2616005)(966005)(6486002)(186003)(6512007)(26005)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkkvTU13TU82MUVqWTVRdDBxbnRQdmIzbkFpbis3U2pGNDQ5MzhEM3ExTDhK?=
 =?utf-8?B?NEp3Wk9CRWJZQk1WbTIreWl6T1FOWUNNY0NMcnZ3aEJNTmJkcjZLL0dzOWkw?=
 =?utf-8?B?T2hhTkRkSHBWUGpwT1ZsbVEwZ2htc21NR3NiUUd5NGFsdVRlbTdFcENCRWNQ?=
 =?utf-8?B?b3YzZ2Y1SXRZbTlJWnpuL0FOTXUyMjFRbXpqbURYNk9TN1REY25PQkJabnRU?=
 =?utf-8?B?V1JXWU53TDJBc2t3ZS9FU0xodDRSSkY3eTdjT0hRcTR0d0JYQTdMMURETVU0?=
 =?utf-8?B?ZlJtSGpLbHIwQ2F0a01lVmxNRlFkU0FVZkNQQnNPb1NuRUY1TEhYY1VkQzY5?=
 =?utf-8?B?cXpsRFBIc2o0WXhSWkRYWS8xbHpYWitqRDVJcFkvbFVzSy9nMTJ4YWxUQVZS?=
 =?utf-8?B?eUxqbG94M0ozQTVYanFlZFZldDB4QTRIT3NBUmo1Y3JxSTNZUnNqeWZtcjQ2?=
 =?utf-8?B?aHVDd2tHcXI5L25TSGdWTlM4Z2RTU0JEUjlsMnNDL0c2ZUhneGZtb1VXOGZL?=
 =?utf-8?B?cTAvdGo5TWpoR0FMN2RjQld0OVpWTXQ2UitjOHpGbmplbUpzOElqaUxoczRk?=
 =?utf-8?B?UHdGeE5SSWxaSHoyZkx1OHo0czRLbVVZZWJ2N1J2TUg5aVVxR3dpckNyRXUx?=
 =?utf-8?B?OFA2MU8wNFVmamdBalpoNGZBVnQyTGtTOXVzbEhPNWhjNFNSR0FXY0xWWGo2?=
 =?utf-8?B?UDJLMzR5elpSL29NeFIxMlJNcHpXVnNTSk10YjJZM1o1OUNVdThpd1BBYk9R?=
 =?utf-8?B?WWUweFowakFXR01BNkNScE5OYUhaRUk3a0t0cXkvUzNtQVpTZHVVc3ZFK1Ey?=
 =?utf-8?B?WVdKQXNqeEs1NnJZTUFHMXVuekprOEMvc1ZvSCtYTnFTWjJHbUhnS2lDcElU?=
 =?utf-8?B?QUozRENhT1gxWGlQTGZFdTcvS0ZnVHgwT0RNdmZCRkZYd041R0p4OGl2aTBE?=
 =?utf-8?B?VStIUnJhdytLZWp6RXlKZitSNzBYT0hwWGFSckNHdjB5Z1BGMVBWZ2Vac1N5?=
 =?utf-8?B?bDVvbWw3TVplVEgzZzVlZUtLeDhNSDdKanlacDAxbktiMXU1MS9RMXVNVlVE?=
 =?utf-8?B?Q2ZJLzVFZlh0dnQrMkV3aml1S1l2b1VEOVkyYnEvQ0dYK3d4Wkhiak9rMzdv?=
 =?utf-8?B?OTBaWWFmYk1XUU9ac1V3aC9Ed3V3dmRkRkJGZUZPVWJxWTdSVGhVbml2Zisy?=
 =?utf-8?B?a2NVMG1ybEF5aUJpY2NudDIzclFSc1dmWG9uQU9jTzNSa3grR2R3TXBqQUQy?=
 =?utf-8?B?Q1lhMmF5WU9WdDN4elkxdnp4a0h1OGpzaUowdTZTRW5ucDVOWmYvVDZqRXIr?=
 =?utf-8?B?TUw5OEZEcjZKTGV6SUJnN3UwZXA2Vjk3WGp2UGJDN0lPc244djF3dytINi8w?=
 =?utf-8?B?Wk5LenBnMHBOYkJPSVhMbXUyK3RhQWNVZzBEMzBWOGhwVXRScHBaNlE4WC8x?=
 =?utf-8?B?NHNHOVhNamdsbGs3OHA1OElBS2hIMURrK2FXQzB1V2l2alRrSFV6Y0h1RlhI?=
 =?utf-8?B?NDVKYjJ5VjFhVEtWN3JNTlY0M0NsQkJlT1Bsdmc5UWY0ZmtKd2xIemxoNWxo?=
 =?utf-8?B?YTNORmcwbnBFanJqNlJPeFkxNmJLM3hDak9wYnJvK3BrU0t2YmJsSVN4cC9m?=
 =?utf-8?B?Tk04OGgzMEF0T1BldWV1T1lVYXFYcm1QN2VPckJGZ2JjQVYyMzUxT1FEdEs0?=
 =?utf-8?B?cWlHWCsxcHBwREZGUmd0a2g1VkZtQnJPN2VSQVdIR3UzUjFDRkF6SzZXdTNm?=
 =?utf-8?B?aHcrelhkVElrZzBxYUZWL2k5RkovdUlObG5GNmpBTVVmSG14VmVrV0V5ZmF2?=
 =?utf-8?B?SnMramlmM1FsRFVPVzBpVE93MFJtZndxSFpyMUhBdmUwUlg5UnkxdGlLMFBJ?=
 =?utf-8?B?MUdubWdFeXl1NmcvMVdmM1ZGKzZCc09SaUdRbVVJd1VaSFZtWG5PRzBTQzJX?=
 =?utf-8?B?VHU3ek9YMFNva0J3YmNvVVMrOHczc1pwYmlOYlJDYnVLVDd3TWVnT1lNdGxC?=
 =?utf-8?B?aHU2YU04NHErWjV2V2RFcWFjTjZXZklxR0Z4QTZHTDh0V0Z2Wk1OVUJ3REs4?=
 =?utf-8?B?cWwvdGFxZkcvK3lUckFPeEVYU2svUGhrd1ltdFl4WGlMeTRyNTZZYXpxOWpr?=
 =?utf-8?B?ZkM1SW1MKzd0d1NxaGtyOHBIaWpNMkhyTHpGNHF4SXRjWWNja2VPSGM5UUVi?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A9D8E443E05684EABAE7788A73E8F9E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5987.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94934ca6-6df3-468b-0d9e-08db499d3778
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2023 17:06:19.1879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BdfxR+awxcaqQ5nihObV2xE3dbxNqSPVxxf94RchvlpDFi/OH7NGRriAlJB3pnL3cgIFlzZxDytqhbT1dhRTeWuCGQG3sjd15QtRaPOvK7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7907
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIzLTA0LTMwIGF0IDE4OjU4ICswODAwLCBKZWZmIENodWEgd3JvdGU6DQo+IE9u
IFN1biwgQXByIDMwLCAyMDIzIGF0IDI6MTfigK9BTSBKZWZmIENodWEgPGplZmYuY2h1YS5saW51
eEBnbWFpbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFNhdCwgQXByIDI5LCAyMDIzIGF0IDEw
OjA34oCvUE0gQmFnYXMgU2FuamF5YSA8YmFnYXNkb3RtZUBnbWFpbC5jb20+IHdyb3RlOg0KPiA+
ID4gDQo+ID4gPiBPbiBTYXQsIEFwciAyOSwgMjAyMyBhdCAwMToyMjowM1BNICswODAwLCBKZWZm
IENodWEgd3JvdGU6DQo+ID4gPiA+IENhbid0IHN0YXJ0IHdpZmkgb24gbGF0ZXN0IGxpbnV4IGdp
dCBwdWxsIC4uLiBzdGFydGVkIGhhcHBlbmluZyAzIGRheXMgYWdvIC4uLg0KPiA+ID4gDQo+ID4g
PiBBcmUgeW91IHRlc3RpbmcgbWFpbmxpbmU/DQo+ID4gDQo+ID4gSSdtIHB1bGxpbmcgZnJvbSBo
dHRwczovL2dpdGh1Yi5jb20vdG9ydmFsZHMvbGludXguZ2l0LCBjdXJyZW50bHkgYXQgLi4uDQo+
ID4gDQo+ID4gY29tbWl0IDFhZTc4YTE0NTE2YjkzNzJlNGM5MGE4OWFjMjFiMjU5MzM5YTNhM2Eg
KEhFQUQgLT4gbWFzdGVyLA0KPiA+IG9yaWdpbi9tYXN0ZXIsIG9yaWdpbi9IRUFEKQ0KPiA+IE1l
cmdlOiA0ZTFjODBhZTVjZjQgNzRkNzk3MGZlYmY3DQo+ID4gQXV0aG9yOiBMaW51cyBUb3J2YWxk
cyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQo+ID4gRGF0ZTrCoMKgIFNhdCBBcHIg
MjkgMTE6MTA6MzkgMjAyMyAtMDcwMA0KPiA+IA0KPiA+ID4gQ2VydGFpbmx5IHlvdSBzaG91bGQg
ZG8gYmlzZWN0aW9uLg0KPiA+IA0KPiA+IG9rLCB3aWxsIGRvLg0KPiANCj4gQmlzZWN0ZWQhDQo+
IA0KPiBlZjNlZDMzZGZjOGYwZjFjODFjYTEwM2U2YjY4YjRmNzdlZTBhYjY1IGlzIHRoZSBmaXJz
dCBiYWQgY29tbWl0DQo+IGNvbW1pdCBlZjNlZDMzZGZjOGYwZjFjODFjYTEwM2U2YjY4YjRmNzdl
ZTBhYjY1DQo+IEF1dGhvcjogR3JlZ29yeSBHcmVlbm1hbiA8Z3JlZ29yeS5ncmVlbm1hbkBpbnRl
bC5jb20+DQo+IERhdGU6wqDCoCBTdW4gQXByIDE2IDE1OjQ3OjMzIDIwMjMgKzAzMDANCj4gDQo+
IMKgwqDCoCB3aWZpOiBpd2x3aWZpOiBidW1wIEZXIEFQSSB0byA3NyBmb3IgQVggZGV2aWNlcw0K
PiANCj4gwqDCoMKgIFN0YXJ0IHN1cHBvcnRpbmcgQVBJIHZlcnNpb24gNzcgZm9yIEFYIGRldmlj
ZXMuDQo+IA0KPiDCoMKgwqAgU2lnbmVkLW9mZi1ieTogR3JlZ29yeSBHcmVlbm1hbiA8Z3JlZ29y
eS5ncmVlbm1hbkBpbnRlbC5jb20+DQo+IMKgwqDCoCBMaW5rOiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9yLzIwMjMwNDE2MTU0MzAxLmU1MjJjY2VmZTM1NC5JZjc2MjgzNjNmYWZlYjc2ODcxNjMx
MDNlNzM0MjA2OTE1YzQ0NTE5N0BjaGFuZ2VpZA0KPiDCoMKgwqAgU2lnbmVkLW9mZi1ieTogSm9o
YW5uZXMgQmVyZyA8am9oYW5uZXMuYmVyZ0BpbnRlbC5jb20+DQo+IA0KPiDCoGRyaXZlcnMvbmV0
L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvY2ZnLzIyMDAwLmMgfCAyICstDQo+IMKgMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiANCj4gSSBoYWQgdG8g
ZG93bmdyYWRlIEZXIEFQSSB0byA3NSB0byBtYWtlIGl0IHdvcmsgYWdhaW4hDQo+IA0KPiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2NmZy8yMjAwMC5jwqDCoMKgIDIw
MjMtMDQtMzANCj4gMTg6Mjc6MjEuNzE5OTgzNTA1ICswODAwDQo+ICsrKyBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvY2ZnLzIyMDAwLmPCoMKgwqAgMjAyMy0wNC0zMA0KPiAx
ODoyNzoyNS43NDk5ODM0NDYgKzA4MDANCj4gQEAgLTEwLDcgKzEwLDcgQEANCj4gwqAjaW5jbHVk
ZSAiZncvYXBpL3R4cS5oIg0KPiANCj4gwqAvKiBIaWdoZXN0IGZpcm13YXJlIEFQSSB2ZXJzaW9u
IHN1cHBvcnRlZCAqLw0KPiAtI2RlZmluZSBJV0xfMjIwMDBfVUNPREVfQVBJX01BWMKgwqDCoMKg
wqDCoMKgIDc4DQo+ICsjZGVmaW5lIElXTF8yMjAwMF9VQ09ERV9BUElfTUFYwqDCoMKgwqDCoMKg
wqAgNzUNCj4gDQo+IMKgLyogTG93ZXN0IGZpcm13YXJlIEFQSSB2ZXJzaW9uIHN1cHBvcnRlZCAq
Lw0KPiDCoCNkZWZpbmUgSVdMXzIyMDAwX1VDT0RFX0FQSV9NSU7CoMKgwqDCoMKgwqDCoCAzOQ0K
PiANCj4gDQo+IE15IGgvdyBpcyBMZW5vdm8gWDEgd2l0aCAuLi4NCj4gDQo+IDAwOjE0LjMgTmV0
d29yayBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBBbGRlciBMYWtlLVAgUENIIENOVmkN
Cj4gV2lGaSAocmV2IDAxKQ0KPiANCj4gDQo+IEkndmUgdGhlIGZvbGxvd2luZyBmaXJtd2FyZSAu
LiBJJ3ZlIHRyaWVkIDc3LCA3OCwgNzksIDgxIC4uIC5hbGwgbm90IHdvcmtpbmcNCj4gDQo+IC1y
dy1yLS1yLS0gMSByb290IHJvb3QgMTU2MDUzMiBNYXIgMTQgMDg6MDUgaXdsd2lmaS1zby1hMC1n
Zi1hMC03Mi51Y29kZQ0KPiAtcnctci0tci0tIDEgcm9vdCByb290IDE1NjM2OTIgTWFywqAgNiAx
NDowNyBpd2x3aWZpLXNvLWEwLWdmLWEwLTczLnVjb2RlDQo+IC1ydy1yLS1yLS0gMSByb290IHJv
b3QgMTU3NzQ2MCBNYXIgMTQgMDg6MDUgaXdsd2lmaS1zby1hMC1nZi1hMC03NC51Y29kZQ0KPiAt
cnctci0tci0tIDEgcm9vdCByb290IDE2NDEyNjAgTWFywqAgNiAxNDowNyBpd2x3aWZpLXNvLWEw
LWdmLWEwLTc3LnVjb2RlDQo+IC1ydy1yLS1yLS0gMSByb290IHJvb3QgMTY2NzIzNiBNYXLCoCA2
IDE0OjA3IGl3bHdpZmktc28tYTAtZ2YtYTAtNzgudWNvZGUNCj4gLXJ3LXItLXItLSAxIHJvb3Qg
cm9vdCAxNjcyOTg4IE1hcsKgIDYgMTQ6MDcgaXdsd2lmaS1zby1hMC1nZi1hMC03OS51Y29kZQ0K
PiAtcnctci0tci0tIDEgcm9vdCByb290IDE2ODI4NTIgQXBywqAgNSAwODoyMiBpd2x3aWZpLXNv
LWEwLWdmLWEwLTgxLnVjb2RlDQo+IA0KPiANCj4gIyB3b3JraW5nIGRtZXNnIGF0dGFjaGVkIC4u
Lg0KPiBjZmc4MDIxMTogTG9hZGluZyBjb21waWxlZC1pbiBYLjUwOSBjZXJ0aWZpY2F0ZXMgZm9y
IHJlZ3VsYXRvcnkgZGF0YWJhc2UNCj4gTG9hZGVkIFguNTA5IGNlcnQgJ3Nmb3JzaGVlOiAwMGIy
OGRkZjQ3YWVmOWNlYTcnDQo+IGl3bHdpZmkgMDAwMDowMDoxNC4zOiBlbmFibGluZyBkZXZpY2Ug
KDAwMDAgLT4gMDAwMikNCj4gaXdsd2lmaSAwMDAwOjAwOjE0LjM6IERpcmVjdCBmaXJtd2FyZSBs
b2FkIGZvcg0KPiBpd2x3aWZpLXNvLWEwLWdmLWEwLTc1LnVjb2RlIGZhaWxlZCB3aXRoIGVycm9y
IC0yDQo+IGl3bHdpZmkgMDAwMDowMDoxNC4zOiBhcGkgZmxhZ3MgaW5kZXggMiBsYXJnZXIgdGhh
biBzdXBwb3J0ZWQgYnkgZHJpdmVyDQo+IHRoZXJtYWwgdGhlcm1hbF96b25lMTogZmFpbGVkIHRv
IHJlYWQgb3V0IHRoZXJtYWwgem9uZSAoLTYxKQ0KPiBpd2x3aWZpIDAwMDA6MDA6MTQuMzogU29y
cnkgLSBkZWJ1ZyBidWZmZXIgaXMgb25seSA0MDk2SyB3aGlsZSB5b3UNCj4gcmVxdWVzdGVkIDY1
NTM2Sw0KDQpTdHJhbmdlbHksIEkgY291bGRuJ3QgcmVwcm9kdWNlIGl0IG9uIG15IHN5c3RlbS4g
QnV0LCBhbnl3YXkgdGhpcyBmZWF0dXJlDQpiZXR0ZXIgYmUgZGlzYWJsZWQgZm9yIGEgd2hpbGUu
IEknbGwgc2VuZCBhIHBhdGNoIHdpdGggYSBmaXggc2hvcnRseS4NCg==
