Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BB9589A5D
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 12:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiHDKX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 06:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiHDKXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 06:23:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2DB39B9F;
        Thu,  4 Aug 2022 03:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659608603; x=1691144603;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Da8RU9NGM7CXKUVAU6iUv+E9xuf9JGswy6CImd/qZZA=;
  b=XOXrEbbpuiZb+1GkT9PW8bxVwd0YcX7+Il1sbw7sDuwz3srZdMoI2vLF
   yrvFNxsuez6W8v6DmvK068VkUNa6kX5rTE9GLhRFJuVpr4AkAz4vGzC+1
   VdD9Ttc2mHH0cJvDlusvFn4ZM48FA5mZuzueU3bRcsuTvMZ37uHpZSSJV
   bKRlUR66I6JV8vsibefCrVc7D2JMmmVl0JLHKTUx+YnmvK+00oHVDogMX
   5ltXzpLMpgCzArjqTNKgACgA9CX1oVyGQdHtPlQ2LlDhoRU1ZOKu8knbh
   SYNqMV+iyQ/KC0uT36KCb0GVFbz6E996riP0f6Z5RlrAdAexn6u45Dd94
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="351611896"
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="351611896"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 03:23:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="692579681"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Aug 2022 03:23:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 4 Aug 2022 03:23:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 4 Aug 2022 03:23:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 4 Aug 2022 03:23:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJt+scMROZQESyoPEIdfLFkHCoITOeYmQhucjII9i02STte/73qwE9Ohx4BRcNNuu7YfW7koLewvoHMcU0E3FT2RbxIkG1ol7YC1OFgPGvDAWHloZ1RKpaiJ90l1+0ypdvSC9aQ+q1RcyRs9V+gBTwUdG07dzTbCEF6+cZsPGEUs0ukbkZSqZcd2R2k0uaqLTdJdaZRqNCjup5HdUydJjyH9ANsLjO/y5xw6SggAZOVQk1N9HNI5LK9u8id9VuutYOjBB6BjlyMSm2N2W2jpyUEhkdRxnsvl52oXKGbeOg6aRq5/20euz4iC1EieqE0kdrZnbiy5bKuO+trbrOOfzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Da8RU9NGM7CXKUVAU6iUv+E9xuf9JGswy6CImd/qZZA=;
 b=kmdUOyqrOVysuraSUdgalVm+2E+Wc8tDD9gqV1xIjhXJoDIG9IxjAaJuVDSIgCgjCFaTIGkemOoQaQK4McBVS3HkVTC7gLWEMeDfNCtn3xr1U4oY0z2uTNXxEIswbAke1Q5ZwXv1rW9cVEOC6jya6i+UaNuYvTJBIAUzcvSuAuQnIgvn0qsd/BKRxN1ApM6/F6eqLWYF+9fyj2VwgdJTpl7JvCiLnjMXQlt2wWkrvDOCAUsDL6iYqF+j+mYuxrfSQ3oPi0XnG0AfgR1/Y+7+RW7GhzydiUCyqZ5tFtLAcw7ld6yYDVy4kAnQtmB6YZ/2atkAhwkEvlscxGzFivP5vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8)
 by BN6PR11MB1330.namprd11.prod.outlook.com (2603:10b6:404:4a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 10:23:14 +0000
Received: from MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::2c14:8c9c:16a4:282c]) by MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::2c14:8c9c:16a4:282c%7]) with mapi id 15.20.5438.014; Thu, 4 Aug 2022
 10:23:14 +0000
From:   "Greenman, Gregory" <gregory.greenman@intel.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "justinstitt@google.com" <justinstitt@google.com>
CC:     "Coelho, Luciano" <luciano.coelho@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Stern, Avraham" <avraham.stern@intel.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "trix@redhat.com" <trix@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: fix clang -Wformat warnings
Thread-Topic: [PATCH] iwlwifi: mvm: fix clang -Wformat warnings
Thread-Index: AQHYlXW4JKT3RqonnEKamAWonUHDFq2EbxKAgAxd+yqADeBtAA==
Date:   Thu, 4 Aug 2022 10:23:14 +0000
Message-ID: <b084853fe9d9bac6b3d5fd037053b09cce0aa6bb.camel@intel.com>
References: <20220711222919.2043613-1-justinstitt@google.com>
         <CAFhGd8qRfhQg2k8E7pUm5EYSLp+vmtSd5tZuqtpZUyKud6_Zag@mail.gmail.com>
         <87sfmoq786.fsf@kernel.org>
In-Reply-To: <87sfmoq786.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6415eee6-2c71-463d-73b9-08da760356e2
x-ms-traffictypediagnostic: BN6PR11MB1330:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3FP3cH8aoFYtL6VzVbkn4/9J1duqXGNfpOA/09FDWG6Tu69SNMWxqeYWJuG68XNNeiR5IMPWf+mgyeBeUjzl2g7llUQArJmVwNIXBspFlk+fxelYrq7RiykfVwyNlN6spAZbcGsL47M0EpU6z9tP/2WAl9i0qbrAr3FzqVZ3FR01qhRaMKxX1yMQp0cFmYzdYKOot1HYNDDupPtCDwjESKBnY1GyvdVmnxrrWyTKmeCuoaTuQawESur6DjVYF/Nto0CHWqPmukstpWj8e4+tslOvL1kHuKFK9aZH+rzLFxSeo91yr1n77Col5c7ooB+zUH/5a5zAIfq4qeH1lvFhK90xvkplcA/46ShPLGtDlAZyupxNxMLA0zDNm1L56p3Ia8YaW/NJju0nHF3bNctL6hGJ03ujyYC1d0TfVgqinQF+t9kCSCaLyYFJ6GcqwUZMSSAv2ePgwwHc/dGVo7og7QrMiyk4VjJvbMR5hAkr1rATDG1oayt6RUfLzBPv3MICmP/8w5cAyyQq3e+/x97OdFi5Ayt4KbRZuyHrei+zS6393+8UFxbiGZLY29pdQ0VIFrVqJXtQm73cM1DqDLwJdzd3g/++SvKrYgsy1itfKJFoMwRAx5NzkrfU2DfMKi+WfCo8KxaPMiN4bWdCthYrB9kSobKb+sVjq9f+NueRNMhVa+mFk7QgqWfAp4PqA4kDQ4pjOmhr8Fy6rkSRPgcJWgG9YYVQAuJgTMcWmZy5pmwiyqELZ7DUQIKZdgqg6Su8d4lEuLyNfQO+Wh9NJIisfCnyUuDZMTPzvM1taP/5sFNr98lBP4Z2Qpp+zKXptmQT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5987.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(39860400002)(366004)(376002)(110136005)(5660300002)(8936002)(82960400001)(54906003)(316002)(38100700002)(36756003)(122000001)(66446008)(66556008)(8676002)(71200400001)(26005)(64756008)(91956017)(38070700005)(4326008)(83380400001)(186003)(6512007)(6486002)(478600001)(2616005)(86362001)(66476007)(7416002)(4744005)(41300700001)(2906002)(6506007)(66946007)(107886003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RU5PVllXTjE1b2hmQTMzZk1SQzVSUHlsaklqWUk0c3Nld2Jhb3Z4Q1dXNUli?=
 =?utf-8?B?NjlVOU9hWDNDbzFncEhTY2t6U0ZqUVZqbTlZL1BMR1JEd2U4alJvMjJORUw5?=
 =?utf-8?B?NkM3YUtjOHBqSmNMRFpFN3hSTUVRdTFOOWtpZnNJYzBQMFhramxCYUVFdVdZ?=
 =?utf-8?B?YjN3Mnc3OFoxQ0J0KzhicVFxdWQxZVNTcUg0TE1zNy93NFNncHc4QmI3VDlU?=
 =?utf-8?B?R3lkOSt0WE1KU2IrWWhQOUY0c20zajJDN05sRkRnODFKbHVCTEtRM3BrUzVK?=
 =?utf-8?B?bmE1OWFFVTNsNGRBSlAzTm5RNkRuR1FNcDZneU9jdHgyRmNRU0hBWDIrTW0w?=
 =?utf-8?B?dmNPWml6ekcvc2UycmVva1pWb0x1OEVqb1ZIMzNGblFwYzgxT21hQUh5eWdY?=
 =?utf-8?B?R2JvRmo3aGpxYXpIa00xUVNUbUdOZDQyNGx5eEU4UTZjOTlKYWx4bDF1UWIy?=
 =?utf-8?B?Tks2bFk3cWZNRnJlRS9sQVFDdkxqM0FJeWdrSkRzZW5PcWlTWXRuNkNkTGJI?=
 =?utf-8?B?R3d5Y3QvdXBXeTl3WktWUzk5cFRaNmpuM0ZxdGZUUk1tTXNxVVdPa2EyYldm?=
 =?utf-8?B?bjZsM3d6SzFEb2xvNDQ0YnVFeXd4ZE1yazRZV0kzNnlYTjYzbnFQa0ZtNDRk?=
 =?utf-8?B?VVBmZHdaaW4xSjM2WFROWkVwQmM3cTh3bW1lTS9UNC9NV1NaOVZ2UXcxYjU5?=
 =?utf-8?B?amxoL3lBNlRKV2UrV3dERHRGYUM3YXQwQzRoZkl1QUZmY0FJbkp1eStOR2JD?=
 =?utf-8?B?YUlGMEZNSndEQmZjR1lyV3ZaSHBKdnE0RmlmbVJWUUdWNEdQOHltbU1sbkV5?=
 =?utf-8?B?MmhLMFFYR3ZwTWZIWCtIYjZWVjdDbHd6c3hjMGJoamVRbTJ3VS9uYXZWdlc2?=
 =?utf-8?B?VWgyeS9CRHJUdE9COFl3ZXlFMjVzMDhvSlRJZ1FDSUdMNFpydHA5NWh6YjZt?=
 =?utf-8?B?ek84c3BKUEREM0JrZkM3SUdJV2pPcW9lSWZXbnRmenRVbkFXVFJrVTRyQk8x?=
 =?utf-8?B?Q3BDc2dOamRYcFQxSnRScjJxUytvWUtLMWtJTTBUZjhYaGljYzlkTUNXQnB0?=
 =?utf-8?B?cUw0QkhVS0NGVFdYSFN0bW1MbFE1eGNaNE5jN1FocytnVWoxL1dMdXN0QnFS?=
 =?utf-8?B?eGlibjdEckJPWTN4SC9sTWE4VDBqWFBHSkVYN1AwVk5NYU5zMjBDOTNEVmE3?=
 =?utf-8?B?a0xuTlE2d0t1a1p6dHJrWUczQVhrVjR3dFlvRGpTd0YzTkkyNVcza3dYN0U2?=
 =?utf-8?B?Z1E2bWpjNEt4cTdXVi8zNjcwZGExUVZHR3BLYlFKY21OejRxYTd4K2Rhb3BY?=
 =?utf-8?B?VVJaNC9yUVNvYVhvODh5blI1S2I1d1cycHdtVlAyM1U1TmxBV3VEMTNxLzkw?=
 =?utf-8?B?V0h5dzlZZUxJWml4UGZpNWlCZC9IVFp2eWtyL0hQdUtTZWV3SWtKZVN5RVRI?=
 =?utf-8?B?NDN4YmZYQzlmZVZwbUJEcHJpQmYzWHVsNVpRVUdZL05WZGI5RFVubW1pZmtx?=
 =?utf-8?B?Zll5d2drSmROSVAvUXNVR09xdGdCSHlUT08yUW1HRkVubWEzTjE2bGYwbTRV?=
 =?utf-8?B?ZlI1S21uTkh6RDYzakpXZDltZXh4ZXRYUllPelg2cExHYThaWVQvNVQ2STFt?=
 =?utf-8?B?bkQwVUtzcHMyWVgyUUVWL0NyVnZwUUNsNXlVS24wQXRjV1dJYXhwcmJIVWsx?=
 =?utf-8?B?emZJUUlnWDYrdzBva1ovZCtDY29pbjcvYm5yWWFiMnZCSk52ZnVKVHJtb2NV?=
 =?utf-8?B?NElhT3R4c3hoeEN0T1JBL1lyMm9IMzRBTUhsaTRTeTNySjliMi8rMnZpdUQw?=
 =?utf-8?B?Yy9jaUxmaXN0NWt4bHhISWVJYjFjYXVZNlczdE8yd014L3VYQVFRR1FsTldM?=
 =?utf-8?B?TklFeXJxOW1LaUxEQmVBcC9lVVE4Ry9STVgzVDVOUytHYnNtYll5S2w5THlU?=
 =?utf-8?B?czFyQnM1WEJydlJySDliSDRsNUtGaEQ1SDcveWFuVS9rdFlneUZsTFRQVTFz?=
 =?utf-8?B?OWtXSzd2VFdyRDdFSEpmZ0szaUljUXRlUUYvd0pZSU9KVU9PVkhOdTdtcS9S?=
 =?utf-8?B?RXlOUVFzc2h0czJEWU5WczFGWkxWSTJjUFdaaW9raHkreVRFVkNhSU5KTkxE?=
 =?utf-8?B?TWRXSENaNDBBbHBreHc5S3JDbG1BQnAxVU9sUEViczlFSWNPeDlRUndIYy85?=
 =?utf-8?Q?4tJLYXCoT58bf+0oE6CDH2s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0957B0D27A8C9A47B74592866A87B411@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5987.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6415eee6-2c71-463d-73b9-08da760356e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 10:23:14.0694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oNZelr3JCsYrPWIBW1KLmhyqEnpDC2lo2qD2wbvclJVpZkbIMrr+kq7Co94UqkqTTGGgR/8dPf+CZg3PdbWzBJtI6UXjxg7UmA1dji3W5DI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1330
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA3LTI2IGF0IDE3OjI3ICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBK
dXN0aW4gU3RpdHQgPGp1c3RpbnN0aXR0QGdvb2dsZS5jb20+IHdyaXRlczoNCj4gDQo+ID4gQW55
IGNoYW5jZSBhIG1haW50YWluZXIgY291bGQgdGFrZSBhIGxvb2sgYXQgdGhpcyBwYXRjaD8gSSBh
bSB0cnlpbmcNCj4gPiB0byBnZXQgaXQgdGhyb3VnaCB0aGlzIGN5Y2xlIGFuZCB3ZSBhcmUgc28g
Y2xvc2UgdG8gZW5hYmxpbmcgdGhlDQo+ID4gLVdmb3JtYXQgb3B0aW9uIGZvciBDbGFuZy4gVGhl
cmUncyBvbmx5IGEgaGFuZGZ1bCBvZiBwYXRjaGVzIHJlbWFpbmluZw0KPiA+IHVudGlsIHRoZSBw
YXRjaCBlbmFibGluZyB0aGlzIHdhcm5pbmcgY2FuIGJlIHNlbnQhDQo+IA0KPiBHcmVnb3J5LCBj
YW4gSSB0YWtlIHRoaXMgZGlyZWN0bHkgdG8gd2lyZWxlc3MtbmV4dD8gSSBhc3NpZ25lZCBpdCB0
byBtZQ0KPiBpbiBwYXRjaHdvcmsuDQo+IA0KU29ycnkgZm9yIHRoZSBsb25nIGRlbGF5LiBZZXMs
IGl0IGxvb2tzIGxpa2UgYSBnb29kIGZpeC4gVGhhbmtzIQ0K
