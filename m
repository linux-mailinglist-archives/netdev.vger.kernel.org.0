Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFFD602880
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJRJip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJRJio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:38:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D299A9C6;
        Tue, 18 Oct 2022 02:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666085923; x=1697621923;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OanSjA/DTQLeeQ6/GnGRKo4wpaXsePkFRpXdaLXo6Gk=;
  b=P7g7TJDe0Ruc4OF4HOyANScbMy1/gb98V7IaFFJwx5pbZnK9X7rONOji
   yb7FfdXiyS9O/mefqBFzTgWkaxwB1Z+NzbLUAUdATg/6pDW/l0JV1H2sl
   VeYJdWoT40eA8+LesuryB22JyB8oYOTRvxId95iwYIu5jiKIrD0j0rx3z
   IrEpSZWYO6G/DinTgparidUPqrLJz4FWzFvcxS1sjJEr9nxfKigP2vlN0
   PCF73+hhkBf++670t9sDsFB+zhbkqzwYsvx5OJRWkdP4s8QQQkPa8r6DE
   owKTIqQ8NxmFdLR7hDZi8s5Y8js/F37tr7kN5fbJ8jHku38YYlamTbMXO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="307715867"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="307715867"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 02:38:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="873816809"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="873816809"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 18 Oct 2022 02:38:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 02:38:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 18 Oct 2022 02:38:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 18 Oct 2022 02:38:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGZaKaAezHh3oupeD3GBMEZQBQf3KDsVO+IrBxnWzqL3dbHw/LrCBmJx/Cz/SMX41X044xYxRN7SEfffhYKVGnWvEUo9gynM4lyJD6uXKUv1EU6eQSwR8PCdOZouW7z0h0OPcxkhqAipPDAKmBCbrQAOzKguSDBl9NIi54C9IZHIYFAvGdnrT4SMqHhomxblQ6fTftix0hmWaiQ8yc9WTrpWc14ckyI0LfL2X5ptXNaniWm6A+lsVRwizcBqUOipNGLsQN9qO2clHnlI1twbWGZBCDZbnEmL/faXFdrPr+2Yc4PbVoT/BjSLnK3sOb07ESMM8p6nCsD7/3l2oY2azw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OanSjA/DTQLeeQ6/GnGRKo4wpaXsePkFRpXdaLXo6Gk=;
 b=LNdseBwExLDExYM+vFQV3gBqDGXKJonRJqtYdHLP68eZWBSDMARXR/K2DlO2xEAlBtxnRUtz0khKz14T61vanWBfEL2CxlLvtTW6S6ral8x6B6XIdtC9LbpYrdJXdUCbIevmNSLBytrZw+K7yAFMfzffFywVcQCKSOKdFscaiYtFbgn1w/iCTsCcHrvPv5TjG0raF1hTEnOsWSWIeBcgFkpgX6BK4yXkaQQe3Inv6GeqF03x6H0/FSunDWPX+HDDFy4uvKeOo96mNWYdeaQMQEvmnmL3J4Ym1TdNvZHiEx/Qf6iW6rSY0/FYSoDoNzd6fyEc5K/7cCt3vyMEOSGOUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8)
 by SJ0PR11MB5120.namprd11.prod.outlook.com (2603:10b6:a03:2d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Tue, 18 Oct
 2022 09:38:39 +0000
Received: from MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::9afa:894a:4804:12a2]) by MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::9afa:894a:4804:12a2%4]) with mapi id 15.20.5723.032; Tue, 18 Oct 2022
 09:38:38 +0000
From:   "Greenman, Gregory" <gregory.greenman@intel.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
CC:     "Coelho, Luciano" <luciano.coelho@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Errera, Nathan" <nathan.errera@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
Subject: Re: [PATCH 1/2] thermal/drivers/iwlwifi: Use generic
 thermal_zone_get_trip() function
Thread-Topic: [PATCH 1/2] thermal/drivers/iwlwifi: Use generic
 thermal_zone_get_trip() function
Thread-Index: AQHY3588PlTm6hUlGUOBujhu+195wq4NrK5mgAABbYCABj1vgA==
Date:   Tue, 18 Oct 2022 09:38:38 +0000
Message-ID: <2068f7dc76b57ae72277f072c7c6188edcdcb95c.camel@intel.com>
References: <20221014073253.3719911-1-daniel.lezcano@linaro.org>
         <87mt9yn22w.fsf@kernel.org>
         <f327dfc4-cd67-930c-a011-8cc2c58d7668@linaro.org>
In-Reply-To: <f327dfc4-cd67-930c-a011-8cc2c58d7668@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5987:EE_|SJ0PR11MB5120:EE_
x-ms-office365-filtering-correlation-id: 58c74ac1-f181-4117-00fa-08dab0ec894a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3oQE36pfQ9hLKUFIXFrPu+/dHFhhjZWrp6yis0KVG5MEUO0ZediSI/2C+QnZDXQzD8h7bN1pLvW4o15I0WqhYM5UxjaBLkR9W+5hgERFCoLMAoUGR3pjqo9us9/+gbZV7552Y8d1Mhm8I/mHjc7TSCMOLSEiIIL58XorL1hkv3dteEMvubl2OqLM5zK+jvSEhcAjtT0e3ylsxVDlwdiNBR93IHblHjQnuhkZUe6D462aqGOjum8o8gMu8I6NvzSD/OXLELdXH2ntdBpnWU9d+Nzskgyf/NryWCgz3kaXVOnlv2evt3wewOc84M1ALsdan2rVt5RlnvwGDVyXwmOflb1YFwG+hY1z43FnZDzl+lRAv5TJjGNEUOHVYzaw3vBsKZe2aWuQhJEu7JaEw0QLddhnqRzRyy60KSKIrplN4cHDgGYUyWtvvPKaEQ10CUa/ytLT9RRKqkA7zefBByiicu2QamPVxc9lAWd4MgVGDEnYXwAWZa1kk0YKFBS+Wb5c47xS0TPrGD05RIcQWjISWBngQuAPfHOz5xcVtUnwu4heHWnMEvaBJ51yz9h3saWoTXG0YosUKumYhRC8yKW4mGHVC++CqcR0k7ne2BOlDGJ1F8UtSs8CPNsKnaHfbOiIHGllXgze87CZCXf/IM1q3X55TjXV50GWdpiFcUpZ2YJCfdU5bsCXti9uv9PPKVVGNx3XKCxJRSuNOHn28oiiC9upI0bfTHXSJ++zePlPFdWkpb5sg9nvIe4Y/KRhwYcZMyeQq0ZutE5OBCjfnFCWNbQYYIRakhUqCtXv9ONQf02zx7d2jKmgwP6E7A7hFEe3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5987.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199015)(2616005)(186003)(53546011)(6506007)(26005)(107886003)(6512007)(7416002)(83380400001)(4001150100001)(2906002)(5660300002)(110136005)(54906003)(316002)(966005)(71200400001)(478600001)(6486002)(41300700001)(8936002)(66946007)(91956017)(4326008)(8676002)(64756008)(66446008)(66476007)(76116006)(66556008)(86362001)(36756003)(122000001)(38100700002)(38070700005)(82960400001)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnBSR2pZTDI3UTVXbVdaUkhMZjh2SzN3azJkREFJRWZjZG9YY3FGZWhpOHl1?=
 =?utf-8?B?ZXQ3dEkvVWJwOXJGMmtsdXpyWmdZMlZMd2M0djJvTEN3dUdOb3BJaFVJQmtD?=
 =?utf-8?B?ajh0U0puT3YxYkYvVy9sTGs1cm9BR0JVOWRyZjIrSUlCWWlCdk5jWnovTlpW?=
 =?utf-8?B?K3E3OUxKVHhnS3lzU0FDUEdqcjNXMWFjMmJWa2pNczdxRUNTNU1hTFUvZkxn?=
 =?utf-8?B?b3Z0SWwrNzUzSURwU0dIVmlCbnludHp5b1cvalg0V2lSQVhBK2NnZzYzR2My?=
 =?utf-8?B?dFNFOXNhS1RYMXR4QXUwN0JjWmlJcGFXOXdrakUvU3kxeUo5TXpZa2piUnVS?=
 =?utf-8?B?dEZMQnN5RTRWQkIxbUJzVC9mcmFjSmZuM3ozekIwd2x3Q1FQOW1RaDR0TWJS?=
 =?utf-8?B?V0d5eUcvUE5zZVh1RWFqVDIzdEpOR2krOWZFK2tnTmM1enpXaWY4anpIMmRh?=
 =?utf-8?B?YnFNTmhKUktQMHhSd2ZUN1hMdjJueXhIa1lQNHZ2V0M4TFRCNnV2U0tNOHdM?=
 =?utf-8?B?T3gwdEdSN2JybXdpamV0eTQweWlGN1Y0Szc0ZFFmYVdhSzdFQzNLUEdnOWkz?=
 =?utf-8?B?QXBMZ01Tajg2OUlDMDQ2VjdpMlM1cER3VUY3UEtHVHoybEM0QU5QNkpkb3hO?=
 =?utf-8?B?WEZveFN0QlErY29uamNnbG9Jd1NLZzVEaEtiMzJqY0d2OVBGb2ZqdHJ5Z21x?=
 =?utf-8?B?TzdNcTZSbUtvM29zS0ZrWG1RZmpCV0FnNFpDY2lRS09NUFFIT1lSQlhPNTdS?=
 =?utf-8?B?Z21wMWJ1QmJSREVXT2s2TUp6QmVRT3FobkFPTmRPcFg4b09JK3pXWU1haDlO?=
 =?utf-8?B?akMzRndBZDljTWF0NWsrZEF1UHRsR2s1UlM3SnhjNGJ1dnFFcnNzdXZmaEpy?=
 =?utf-8?B?NVVUOHRPQ0o5OEtORWV4UE02WW9DYXlodnpTVlBLRXhQczUzbVlibC9yWlZ1?=
 =?utf-8?B?aDBoVlhxKzNHV0V1ZmYvdnNUNm1Ic3NwU1ltZEw5MytBSTNZVXoxNHpjQWxE?=
 =?utf-8?B?S3BUcFQyR3dHUVBHaXk4c1c4SmxDbGJZNkVOaGw2V2JmSUlPNURQdE9DYURk?=
 =?utf-8?B?K2JBd0dCTUtHUzVnMzdmQ003MlIyNXhBdzI3QzBqYVhxY3hFWDJlQjR6ekpm?=
 =?utf-8?B?YjVOTDdMMTkvd2NkV0psdzFxcGJBTUxuWEt4aStQek1Kb3kyM2t2ZSsrOWhj?=
 =?utf-8?B?ei9xYmJVZTlsU0p6VzFtNHhUcmp2OEs4WHluOGxXMXc4Rmg3OStxVHJmWUE3?=
 =?utf-8?B?Sll2VE94alJEQ1kyZTU5WWZPS1UwRmVRS2R3VWs4ZWdtSG1iaVFTUWtvMlN2?=
 =?utf-8?B?clVBTTVvdDVISlZZZWN2b3daTVdHMWUwWjQrbUhILzhkaitlSElkRHRncjN4?=
 =?utf-8?B?ZTdMaDFIWUZFb2pNTXQ4cllnalN3dm1RZm5KNkpmanBBOXArOXVkS3VMVXgv?=
 =?utf-8?B?UVl6bE85M0xlZVcxS3hMbzNldm40aWs4cGVPZUdrWCthaTFhdWwvZis4OVpy?=
 =?utf-8?B?eXlpUnhMZVV4cnp2QmVxSjNxM040Y0t6RThaM3dpY3hzbGVEbEVmeDdCUGNq?=
 =?utf-8?B?UlljVC9ZNk1yVHB3Tk9ML1duWU8vd29QSHZhTEN1RTcxdHVyUGx0Z2pTdTVL?=
 =?utf-8?B?QTFpb2kwcDhWUWlxL0pLaFhHQSsrb0wrK05uUFF1emdLV05NRWFNTjhCZ1ZY?=
 =?utf-8?B?emZzUmZEWm5sb1pnYlN0NG1WTElVMDNkSUZpOFA5Nk5CQkVEd1pNb2RCcUFK?=
 =?utf-8?B?N2ZiSCtMS2pIcUUwSDRQRGlia3N2UlUyanJCSkZFQzBKM1JBQ1BpeVN6Z3NF?=
 =?utf-8?B?MUh1ZGZUV0syMTdueXdremR4OXMrS1o5RTh2Y2FhVkZPMndEa1JkUVBhVzRB?=
 =?utf-8?B?Z1JEMXZVanlvTUxPTkkzUHNueDNtd3Bna3daUmNKUnphQWJhSlRrOURhQWVF?=
 =?utf-8?B?QjVwc3hrQ25GUWZHWnhBNzFDY2R2WjB4bllGOHN2WW9pM015MkhxZVFIY2pj?=
 =?utf-8?B?WllTSXF2NlZjMGJHeHZpa1RsWlI5MFNtTUNVelNWcGRiUWJia3B2Y0NlNHpX?=
 =?utf-8?B?REJNQWVVU0xPV3VnSExzUzZGcVAydTNIMnVzWHZ0Z3FCT1Y3K2MwcFBwbmsz?=
 =?utf-8?B?SUhxOW1KK1pRODFVU1VtVFRRWVZJTDF1Yk15UUM2TUpNVFBRK3M4N0l6UHhn?=
 =?utf-8?Q?t6nwoh1xrPIZki4qR59dz9Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7574DDB7B2D3234D8A9ED48CFFF5D651@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5987.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c74ac1-f181-4117-00fa-08dab0ec894a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 09:38:38.7820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SNmzC5SEjK3GEtHNrjtrZtlfuProRjla6uHnZJvlNKr0GPtgIAIB9jJ2qzzibbQ7EELDJth9QnWOP20GjHEwFbyDGS7OWpqBTmVS0sLaM2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTE0IGF0IDEyOjIxICswMjAwLCBEYW5pZWwgTGV6Y2FubyB3cm90ZToN
Cj4gT24gMTQvMTAvMjAyMiAxMjoxNSwgS2FsbGUgVmFsbyB3cm90ZToNCj4gPiBEYW5pZWwgTGV6
Y2FubyA8ZGFuaWVsLmxlemNhbm9AbGluYXJvLm9yZz4gd3JpdGVzOg0KPiA+IA0KPiA+ID4gVGhl
IHRoZXJtYWwgZnJhbWV3b3JrIGdpdmVzIHRoZSBwb3NzaWJpbGl0eSB0byByZWdpc3RlciB0aGUg
dHJpcA0KPiA+ID4gcG9pbnRzIHdpdGggdGhlIHRoZXJtYWwgem9uZS4gV2hlbiB0aGF0IGlzIGRv
bmUsIG5vIGdldF90cmlwXyogb3BzIGFyZQ0KPiA+ID4gbmVlZGVkIGFuZCB0aGV5IGNhbiBiZSBy
ZW1vdmVkLg0KPiA+ID4gDQo+ID4gPiBUaGUgZ2V0X3RyaXBfdGVtcCwgZ2V0X3RyaXBfaHlzdCBh
bmQgZ2V0X3RyaXBfdHlwZSBhcmUgaGFuZGxlZCBieSB0aGUNCj4gPiA+IGdldF90cmlwX3BvaW50
KCkuDQo+ID4gPiANCj4gPiA+IFRoZSBzZXRfdHJpcF90ZW1wKCkgZ2VuZXJpYyBmdW5jdGlvbiBk
b2VzIHNvbWUgY2hlY2tzIHdoaWNoIGFyZSBubw0KPiA+ID4gbG9uZ2VyIG5lZWRlZCBpbiB0aGUg
c2V0X3RyaXBfcG9pbnQoKSBvcHMuDQo+ID4gPiANCj4gPiA+IENvbnZlcnQgb3BzIGNvbnRlbnQg
bG9naWMgaW50byBnZW5lcmljIHRyaXAgcG9pbnRzIGFuZCByZWdpc3RlciB0aGVtDQo+ID4gPiB3
aXRoIHRoZSB0aGVybWFsIHpvbmUuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IERhbmll
bCBMZXpjYW5vIDxkYW5pZWwubGV6Y2Fub0BsaW5hcm8ub3JnPg0KPiA+ID4gLS0tDQo+ID4gPiDC
oCBkcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL212bS9tdm0uaCB8wqAgMiArLQ0K
PiA+ID4gwqAgZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tdm0vdHQuY8KgIHwg
NzEgKysrKy0tLS0tLS0tLS0tLS0tLS0NCj4gPiA+IMKgIDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5z
ZXJ0aW9ucygrKSwgNjAgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gVGhlIHN1YmplY3Qgc2hvdWxk
IGJlZ2luIHdpdGggIndpZmk6IGl3bHdpZmk6ICIuDQo+ID4gDQo+ID4gSSBkb24ndCBzZWUgcGF0
Y2ggMi4gVmlhIHdoaWNoIHRyZWUgaXMgdGhlIHBsYW4gZm9yIHRoaXMgcGF0Y2g/DQo+IA0KPiBw
YXRjaCAyIGFyZSBzaW1pbGFyIGNoYW5nZXMgYnV0IHJlbGF0ZWQgdG8gdGhlIG1lbGxhbm94IGRy
aXZlci4NCj4gDQo+IFRoaXMgaXMgdGhlIGNvbnRpbnVhdGlvbiBvZiB0aGUgdHJpcCBwb2ludCBy
ZXdvcms6DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMjEwMDMwOTI2
MDIuMTMyMzk0NC0yMi1kYW5pZWwubGV6Y2Fub0BsaW5hcm8ub3JnL3QvDQo+IA0KPiBUaGlzIHBh
dGNoIGlzIHBsYW5uZWQgdG8gZ28gdGhyb3VnaCB0aGUgdGhlcm1hbCB0cmVlDQo+IA0KPiBTb3Jy
eSBJIHNob3VsZCBoYXZlIG1lbnRpb25lZCB0aGF0Lg0KPiANCg0KQXMgS2FsbGUgY29tbWVudGVk
IGFib3ZlLCB0aGUgc3ViamVjdCBzaG91bGQgc3RhcnQgd2l0aCB3aWZpOiBpd2x3aWZpOg0KVGhl
IGNvbW1pdCBpdHNlbGYgc2VlbXMgZmluZSB0byBtZS4NCg0KQWNrZWQtYnk6IEdyZWdvcnkgR3Jl
ZW5tYW4gPGdyZWdvcnkuZ3JlZW5tYW5AaW50ZWwuY29tPg0KIA0K
