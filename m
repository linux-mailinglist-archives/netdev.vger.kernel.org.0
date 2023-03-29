Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EC26CF6F9
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 01:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjC2XXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 19:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjC2XXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 19:23:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18B335B6;
        Wed, 29 Mar 2023 16:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680132204; x=1711668204;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4EafHpwZJ07cRRVjKdnM9mw9iawxEjekbPGw4y0jcXY=;
  b=PgK/hDjeRC1Tm/pL06qaYXDzGLL15gey1SXJrZeNNTrQtKHxISgdQU5e
   K9umHpKzOe5pu48EWWzvl/nWJzmWnHJ9P9n1J0Tp5irkX7bF50BgpWeWH
   SITxVp5riENQQnl/BcOknGqJLn5h6J+aHiE5QlgE+ZIXNUBsgKJb03Y3P
   1w3tT7Wi2J86nO+NCft0cAVcVd7oJD8edSH0sf+ZCrTXSs3ybyBqLEUto
   4s4Fr+A8Jay+8UIGpUPNi9j09lYLTD4ebmpIoKV5VdJJeDS+l8MVW/9Tk
   zDQVJhOYIJNg4Gmbw14GMpskUD9XkPUk6SYYQE70DjEdjTIil4PgnZO0x
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="341041052"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="341041052"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 16:23:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="930514062"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="930514062"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2023 16:23:24 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 16:23:23 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 16:23:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 16:23:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 16:23:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLlg/v2DdmsaUBnGAgHo8/peOBB8I2cZinIObskyAXcCnhUeSGhNjyPEQZ89vCWEnVQGSDNA8ZEMyntRbQqEscFqxLyLUdyBb+mZ/npSYNhhGu/0adCiRWrj8a7jGrA5MLnaJguI488HFPH9DAl+/F88jCLBxPlniBj11oCHPiR47yxSRAVB5x8FGE+ggV5ozqZDMs3B3956cApLAHL4c4LuFJDiVE1+y2C+yP3EalWYhzH77XOwx08ad6R3JUzy+NFEtoWaPfHDGKPL/7E11EBBQwfGSDJLUE1C2/pUM/AO99oqeDz+YTouaIdh46Ooy+LUPYo0r+R+FP7YupSBqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4EafHpwZJ07cRRVjKdnM9mw9iawxEjekbPGw4y0jcXY=;
 b=IuGaI7RjHK/aiQ2MzoSYvSj1WBiLI2zepB0akljO3njt8Cp7s2lhRnUGohBI5nR0b6K08IOgM1bvU3ob4G+12/kMtsFqhSU79jDluQ/R5Sl9Rp/agov0gu6mC62Y22sABJ6qlb9nNV6Y4fA6RPgQAXrjtsETC4quo9JKZrjAYaZ4UuLmF7O2Mintybf2QpAVORPDNfhoGU1Em3QwlTF1Oj94fw2SaexeKbTfOUIxZal9mWenXtNE3FpT/voO8pMahLpordkVEiztcpWLwapAQHjwq/6qmLWMsSYZE2vnKDJxGG6GD++nEBOroAYpws8L92lGH4UJBodgetc+3/FLWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB8247.namprd11.prod.outlook.com (2603:10b6:208:449::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Wed, 29 Mar
 2023 23:23:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::ea5c:3d05:5d92:bc04]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::ea5c:3d05:5d92:bc04%8]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 23:23:20 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Rob Herring <robh@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "Marc Zyngier" <maz@kernel.org>
CC:     "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 0/5] Remove acpi.h implicit include of of.h
Thread-Topic: [PATCH 0/5] Remove acpi.h implicit include of of.h
Thread-Index: AQHZYoSCF122w+cVw0Skw6T+0Rx/SK8SZUsg
Date:   Wed, 29 Mar 2023 23:23:20 +0000
Message-ID: <CO1PR11MB508970B2F338C9176CE32DD3D6899@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
In-Reply-To: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|IA1PR11MB8247:EE_
x-ms-office365-filtering-correlation-id: 32aa7b70-246b-40b3-7cc4-08db30ac95c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rakcu5VYvPmrNTT1IWayzZAOAHE3SMcJlwsHISLtPzqpTlaQhsl8mW6L5JopYe50UZS+l0ljbeZsL7d2wA5ArX+e0UCDGmIsEIVV4yhWWf2JNfkswBbr5JN5wX8a5lA4sx4IcYCHamKSL68vDZiUsalaaxsuSpf5zJ1d4I/b/hAlaa/TeVr4AUY32THnEOGw8wBbNQkWEVuKbtL7wNkoADdTtDJuizjBX7VGnXnAvH9sSV8lOoYoKrH51O48g5QjL9KGQeQc8lq4eSyxHjc5w8FhwNz+esr59KEi/yy1ryvc0I8mvoiSdqlptHDHwni853bn+Dw2MGNukQijyXogCz7kT9H0WO2K/f0cGCTdaEPKjMKQnZx+MeBKQXM/XjmjTxjfyhou74GYP2BaK/lPp6jv9SatuMOxE8rl1PMEqMetvtgwENJ7nl6PrqYn7loEVJTunZf8xrBdvOV22TK4Z7UP5dIFGUwW2Kr5YIVGfdT9GvZXot1sbKsk72qpE15DsWoui4tSVC/uOyR2YZP9ACPDQErmfUuUB3If4wzhi5Hp1XwKf301BADaBL0b/ekW/RSwAvTcM2abE1MQd3YwYHYKNVV8sgpNZPpcTRkSfEaYaBdT0Tx0Dnu3poD0y5M8PWJYJNPveWnCbpmLP65mtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199021)(86362001)(2906002)(38070700005)(33656002)(55016003)(76116006)(53546011)(83380400001)(478600001)(71200400001)(66946007)(54906003)(38100700002)(7696005)(9686003)(5660300002)(8676002)(66446008)(66556008)(66476007)(64756008)(316002)(4326008)(122000001)(6506007)(26005)(110136005)(186003)(8936002)(52536014)(82960400001)(921005)(7416002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eldMRU03dFRDd3VpN25VSlE0dTY3Z2hJMjhZT3BIWVpyZmdNVDZySFp0RWYr?=
 =?utf-8?B?b2Yvamxvb3VtdmV6bnc0TVBxcWFvUU5XS09tQ3ZpQmp5SVZWbDVwNnUxYlQ0?=
 =?utf-8?B?OEJIWnpHTWUzVmhlajF0UWhWRXplbzBSVk0rSzJqd0twWmY1TEE4KzVlODlS?=
 =?utf-8?B?T1ZhK3BpenJwOUdrbFdZYmJaZUR3SENWSm4yUmtvMCt3WVVjRGlnemxpZ1FN?=
 =?utf-8?B?aGduaFdWMlR6WUZaQTZrNGltRE9GamtGUmNOdTJWc0tFWWtGQ2t2Um5lSG9m?=
 =?utf-8?B?UmpOY1NHNVRFNXdubzVtcm51dC9VMVdDR2hpVXViMjVhWWFkem1XOHVJaGhr?=
 =?utf-8?B?NkVxZnBaSlVOSk1PanJtdVl0eVB3ME1NQ2sxbS9DZVdnWXBlaTRSczhxNFJs?=
 =?utf-8?B?bWpZZDNub0tGSTNUUzdmT2Y0MXUwVklBSHlQTnZWWlQ3M3ZGRDlWU01DZnJ6?=
 =?utf-8?B?eklrejZ3Z0huV3BUZ29yUC80UHhyVDJvTENWV1E0U1ZYcXpIY1pRd2kwYzNr?=
 =?utf-8?B?c1R0czN4TktTbWhUd0JQeEw5bndIVnZucndUejBISk0zbGtMY09qTkF1Q3gr?=
 =?utf-8?B?WWMxRk9lMEUzalBhV0lRMlRDT3ZUOGNDOFpKck9CWU9BSy8rcGVBcHpHZGY4?=
 =?utf-8?B?Mmx6U2czaXh2ckFSUEVFOEFZNlR1djloUERaYWk0TTY3T0M2aG5jU0EwaVBx?=
 =?utf-8?B?UXEwN1pneVUvS0g1a0FrSk9YMzZnSFMxT05EYXNhSTFWRVp5cUlyWkdrRlVF?=
 =?utf-8?B?RnZndVJzVUpSLytsKzUySTJRRStTVFdLbHUrSHZ6MTJEYTk2TzVIZjZMSGdD?=
 =?utf-8?B?a3ZJa2dvaGVnb1hmUzFJYm9wWDRoQlYrdTJBLzJIRU1WVHdvNGhVQ0dQTGhz?=
 =?utf-8?B?VUlCSnlVTldRMlVYeFpQZkJUSllEc0VGNmd6S1NTbFlLT0dYRnpaNW5hZHov?=
 =?utf-8?B?TmJWSHUwb1I5L3JEK1hsRXBucWp5NDBTVThwTitGSlRtOW9DYUppUzlCNGhh?=
 =?utf-8?B?dzByWis2dkVtamlEVDBtV3p1MlcwcGZ6b0Y1bXNEQjY5VHdzYUFYT1lNZ1NL?=
 =?utf-8?B?SUhLTjd0dW11SmxqYUxQK01mQTczT0g1dVZjby83bVBBcGJrV2x4b0x4NHI5?=
 =?utf-8?B?M3BSVWlFSUxndUp1amwzbHgvT0Q3a2EzYklTUm1FU0FTaEN6eVRXQS9MRGJZ?=
 =?utf-8?B?em0rVko5bFY1OElJVmd2a0hpZWRadDB3RVk0aEVQVWNOaFhSWVRUNUZtZ0tP?=
 =?utf-8?B?Tk5ySmxHU3gwVlZ3SXNYUndPODFHME0zNWJsNFBTSGQ0YlNEakdqT1cxMEs3?=
 =?utf-8?B?K1F2MTRKVnBma3l2bWZOeWZ4cUNpK3RZUnI4QlRiYlVnR3NsekJUMGJqd3pX?=
 =?utf-8?B?V1orSHFGUnMvcENyNTBzckFRM2NIQXpzWVBDM3lJaGJXWS93b01BZEF5SjMz?=
 =?utf-8?B?bWt4dDZjenAxMEdMZ3ArbW13YU5LUUExS0ErY0ZFOHBCRFZXdzR2ZGtHNUVv?=
 =?utf-8?B?aE45UkpMcWFtY2cwTGYyajB4WURJandQdE5BRndsVTVYbGRlc0FqQnI5dXVu?=
 =?utf-8?B?b3BXazFRT0FTcnZ0WHJiTVByLzVhZ3pRQWxUVW9VenRxeEhsQVVuRWljNnJN?=
 =?utf-8?B?Y3ljL1ArZTRqTXVUNE5URWFuV3V3SkVrOFZxV1lWWmFGWHlEU0YvWHg3cjQ5?=
 =?utf-8?B?eVRqYVVuS2psTjkyNjJIWkpIRmRMeUQyS0RDNnl2VkY1SHdPbWhsalByZEFy?=
 =?utf-8?B?L2JkbzBrUmZKK1hzT05BaUxUejJKeXhwNnFOR2JCay9yTlk1VDB5dFVaaUc0?=
 =?utf-8?B?bXA4dnVoaGtJSElCWUNyblh3VndDZGJldGVQbGU1ZUM3L3M1TDIvYTZkZ2ho?=
 =?utf-8?B?enBXL2d0djNxYlJZSVFrUUhPdDMxcDQ5bGt3VjVQOGMzeVJuWHFJeXNMOU96?=
 =?utf-8?B?UnR3a0pYdnViMHRHRmtBQlJXeEZqVWY2bHVGYVI4UXkzNWp4M0EyQlMrUlNG?=
 =?utf-8?B?cGhNWlYrdXFHZGorbXcxTjdTdUZQcndsYmZubkhmT3hWT0pMd0R2c1QwNzdY?=
 =?utf-8?B?RERhaExVRUwweGVkRzFYN3ovMFlVdThQM2Vqem9xbFVGOVEvZEJzVVpEYlZx?=
 =?utf-8?Q?Xyo216EKqqFeb7uZzgR+91xt8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32aa7b70-246b-40b3-7cc4-08db30ac95c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 23:23:20.8343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xvQ0H2nRC/6pcyh4kT+QV8UpZSeRhMpI3mrSfxV+maxoZ8rmZpv0Ur3/UtVnGuqBZ2BWgRNI4f1PKq/OlPcXqM6xVnWN0IF8m9lLe8FEZVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8247
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUm9iIEhlcnJpbmcgPHJv
YmhAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAyOSwgMjAyMyAyOjIxIFBN
DQo+IFRvOiBSYWZhZWwgSi4gV3lzb2NraSA8cmFmYWVsQGtlcm5lbC5vcmc+OyBMZW4gQnJvd24g
PGxlbmJAa2VybmVsLm9yZz47DQo+IE1hcmNlbG8gU2NobWl0dCA8bWFyY2Vsby5zY2htaXR0MUBn
bWFpbC5jb20+OyBMYXJzLVBldGVyIENsYXVzZW4NCj4gPGxhcnNAbWV0YWZvby5kZT47IE1pY2hh
ZWwgSGVubmVyaWNoIDxNaWNoYWVsLkhlbm5lcmljaEBhbmFsb2cuY29tPjsNCj4gSm9uYXRoYW4g
Q2FtZXJvbiA8amljMjNAa2VybmVsLm9yZz47IEdyZWcgS3JvYWgtSGFydG1hbg0KPiA8Z3JlZ2to
QGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lc0BzaXBzb2x1dGlv
bnMubmV0PjsNCj4gRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBE
dW1hemV0DQo+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz47IFBhb2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47IEppcmkgU2xhYnkg
PGppcmlzbGFieUBrZXJuZWwub3JnPjsgVGhpZXJyeSBSZWRpbmcNCj4gPHRoaWVycnkucmVkaW5n
QGdtYWlsLmNvbT47IEpvbmF0aGFuIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+OyBNYXJj
DQo+IFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPiBDYzogbGludXgtaWlvQHZnZXIua2VybmVs
Lm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IHN0YWdpbmdAbGlz
dHMubGludXguZGV2OyBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNlcmlhbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiB0
ZWdyYUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFjcGlAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0
cmVlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0ggMC81XSBSZW1vdmUgYWNwaS5o
IGltcGxpY2l0IGluY2x1ZGUgb2Ygb2YuaA0KPiANCj4gSW4gdGhlIHByb2Nlc3Mgb2YgY2xlYW5p
bmcgdXAgRFQgaW5jbHVkZXMsIEkgZm91bmQgdGhhdCBzb21lIGRyaXZlcnMNCj4gdXNpbmcgRFQg
ZnVuY3Rpb25zIGNvdWxkIGJ1aWxkIHdpdGhvdXQgYW55IGV4cGxpY2l0IERUIGluY2x1ZGUuIEkg
dHJhY2VkDQo+IHRoZSBpbmNsdWRlIHRvIGJlIGNvbWluZyBmcm9tIGFjcGkuaCB2aWEgaXJxZG9t
YWluLmguDQo+IA0KPiBJIHdhcyBwbGVhc2FudGx5IHN1cnByaXNlZCB0aGF0IHRoZXJlIHdlcmUg
bm90IDEwMHMgb3IgZXZlbiAxMHMgb2YNCj4gd2FybmluZ3Mgd2hlbiBicmVha2luZyB0aGUgaW5j
bHVkZSBjaGFpbi4gU28gaGVyZSdzIHRoZSByZXN1bHRpbmcNCj4gc2VyaWVzLg0KPiANCj4gSSdk
IHN1Z2dlc3QgUmFmYWVsIHRha2UgdGhlIHdob2xlIHNlcmllcy4gQWx0ZXJuYXRpdmVseSx0aGUg
Zml4ZXMgY2FuIGJlDQo+IGFwcGxpZWQgaW4gNi40IGFuZCB0aGVuIHRoZSBsYXN0IHBhdGNoIGVp
dGhlciBhZnRlciByYzEgb3IgdGhlDQo+IGZvbGxvd2luZyBjeWNsZS4NCj4gDQoNCk5pY2UgdGhh
dCB0aGVyZSBhcmVuJ3QgdG9vIG1hbnkgZXJyb3JzLiBVc2Ugb2YgdGhlIGZvcndhcmQgZGVjbGFy
YXRpb25zIG1ha2VzIHNlbnNlIHJhdGhlciB0aGFuIGluY2x1ZGluZyBhIGJ1bmNoIG9mIHVucmVs
YXRlZCBkZWZpbml0aW9ucy4gTmljZS4NCg0KUmV2aWV3ZWQtYnk6IEphY29iIEtlbGxlciA8amFj
b2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KDQpUaGFua3MsDQpKYWtlDQoNCj4gU2lnbmVkLW9mZi1i
eTogUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9yZz4NCj4gLS0tDQo+IFJvYiBIZXJyaW5nICg1
KToNCj4gICAgICAgaWlvOiBhZGM6IGFkNzI5MjogQWRkIGV4cGxpY2l0IGluY2x1ZGUgZm9yIG9m
LmgNCj4gICAgICAgc3RhZ2luZzogaWlvOiByZXNvbHZlcjogYWQyczEyMTA6IEFkZCBleHBsaWNp
dCBpbmNsdWRlIGZvciBvZi5oDQo+ICAgICAgIG5ldDogcmZraWxsLWdwaW86IEFkZCBleHBsaWNp
dCBpbmNsdWRlIGZvciBvZi5oDQo+ICAgICAgIHNlcmlhbDogODI1MF90ZWdyYTogQWRkIGV4cGxp
Y2l0IGluY2x1ZGUgZm9yIG9mLmgNCj4gICAgICAgQUNQSTogUmVwbGFjZSBpcnFkb21haW4uaCBp
bmNsdWRlIHdpdGggc3RydWN0IGRlY2xhcmF0aW9ucw0KPiANCj4gIGRyaXZlcnMvaWlvL2FkYy9h
ZDcyOTIuYyAgICAgICAgICAgICAgICB8IDEgKw0KPiAgZHJpdmVycy9zdGFnaW5nL2lpby9yZXNv
bHZlci9hZDJzMTIxMC5jIHwgMSArDQo+ICBkcml2ZXJzL3R0eS9zZXJpYWwvODI1MC84MjUwX3Rl
Z3JhLmMgICAgfCAxICsNCj4gIGluY2x1ZGUvbGludXgvYWNwaS5oICAgICAgICAgICAgICAgICAg
ICB8IDQgKysrLQ0KPiAgbmV0L3Jma2lsbC9yZmtpbGwtZ3Bpby5jICAgICAgICAgICAgICAgIHwg
MSArDQo+ICA1IGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
PiAtLS0NCj4gYmFzZS1jb21taXQ6IGZlMTVjMjZlZTI2ZWZhMTE3NDFhN2I2MzJlOWYyM2IwMWFj
YTRjYzYNCj4gY2hhbmdlLWlkOiAyMDIzMDMyOS1hY3BpLWhlYWRlci1jbGVhbnVwLTY2NTMzMTgy
ODQzNg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiAtLQ0KPiBSb2IgSGVycmluZyA8cm9iaEBrZXJu
ZWwub3JnPg0KDQo=
