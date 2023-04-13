Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457946E03C7
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDMBjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDMBjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:39:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A03E4234;
        Wed, 12 Apr 2023 18:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681349951; x=1712885951;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3Y9CV8TzzV41CXbO5C9uVMuneJAhFSLff3qbiPq7Y0s=;
  b=FVktTwdHp40hGskp6iX0hXMKi1Ksh1azdPRA3agjoLSo/IKnc2asQo7f
   7uVLMNsIuyCbaNYsLj2hnFv0vI908mcuthA2cnNWow91sYPTf+hhmyn/3
   KKlDzYxPVLzf0W9mEbriBgoNEplqgkkl+ZBuU91DRO3qfoQBercQpskuF
   90VEDNro1gHsetKmQPdcqiZ5I9IonrM2FUIazNfvCGeSPWs18K0n6ow/3
   5uDojD1n2XRlsIzE1IYZHqlLKloJNXfKCCMxqL1emj/LBMID29Cpl70D1
   z86ObeF2IKzU8QtnrO74Rt1vxNl5IFaCkGLfoCOhPlmpYyTNs+kjC/cZw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="346745180"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="346745180"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 18:39:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="800576054"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="800576054"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 12 Apr 2023 18:39:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 18:39:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 18:39:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 18:39:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d39qLPNzfCbjNCWAmvCCLBSiXKsJphq1x9g5EjhJtMK9nWBCSLGNCT6Rak+Ge+sR8UQZlJpcb+cs+HBpHPGU8n0cxCCcLPqcCGRMOZu3nq/S9ou57/kz8VGT1kgayuSZ2CR9Db8CeGOzXRgLlIdoB6eXtfteMlX8iJKBhHFreuEUnFqBcxFzeLaIDFUqnFb0C/CgRkAc8y4CIIZiMqWT6zYLsLO12gE89QGcHRpTiFoENftI8qNSZv+5CbOPrSOffJ5iTHveb5QRj+TMDgUYl0/0S0wJQVf+f7jxPAp36pxdgued9wbK/ec8gmRY666zxouGnayilumRUqZA8CNTGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Y9CV8TzzV41CXbO5C9uVMuneJAhFSLff3qbiPq7Y0s=;
 b=QgIE8msnEktpybnUYj6ZPeVffeCpoDnt7NBBy3HZ0P3i3mST6qZpsasbw3SiQoNyIXV4cmj5IJZl5MfTWyaaPP3RhDJihp85et2m6RgVmrNcjdSxMW/t/wTjeCF27Dn9O0zBk1LRprOt8agQdXza1aI+Wp96GMOuAPV+SSD1fELf0ofsx/s7/nMWKt2iW4nEtV4hhjr/TJC3vlcjy3cKq992u6wVUXyZEOgHbk4Z9ZtegX8Ex0tJiLudQkomFnRBlHM0BdY9IqjEs3lP5Huvb840dkwXMSeS4blHe7G+6yvlREfTZ5r+rH4cJ7WgNbR0Awns2yKf1PKnCHUFgBwgDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by SN7PR11MB7589.namprd11.prod.outlook.com (2603:10b6:806:34a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 01:39:07 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 01:39:07 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>
Subject: RE: [PATCH net-next v3 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Thread-Topic: [PATCH net-next v3 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Thread-Index: AQHZbSND2+tajsBCFkyFMq8B2G8mu68n5iyAgABB5QCAAA3fgIAAOWbA
Date:   Thu, 13 Apr 2023 01:39:06 +0000
Message-ID: <PH0PR11MB5830A823C4FC0483BA702293D8989@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230412094235.589089-1-yoong.siang.song@intel.com>
 <20230412094235.589089-4-yoong.siang.song@intel.com>
 <ZDbjkwGS5L9wdS5h@google.com>
 <677ed6c5-51fc-4b8b-d9a4-42e4cfe9006c@intel.com>
 <CAKH8qBtXTAZr5r1VC9ynSvGv5jWMD54d=-2qmBc9Zr3ui9HnEg@mail.gmail.com>
In-Reply-To: <CAKH8qBtXTAZr5r1VC9ynSvGv5jWMD54d=-2qmBc9Zr3ui9HnEg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|SN7PR11MB7589:EE_
x-ms-office365-filtering-correlation-id: d51a5112-431c-4071-34e0-08db3bbfdee5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MdDZNsyQOk7z1KXeHbThJ1Ybm5UncllirIsm8nD93scgKyvLN5MKAzbePp0FLWeluuteZv0cXoaxgw+h+VAY/NOlycrrUNXBfnKVtT1KBX0Gwc4aYYxE7rozb5qJF6OthU6yC0Re9TFxuz9vKyg3x5bYvT5D2z6O+OTs7I+tDR+mE5Dvd2s9jRTxCf0ERSdFg9A9ZShdnn59J7uVHJUfCLMKV4Lap6guolAtBuynCuRf6Sg4D3+ed6466icYyOfu0FY0G+mNcyTmh0L/KO/InvNzMesIKIDfWtdtGc6yWQeRNAH3whaKK5Pmix+T0QPfH+xExOC+0+6s5f3GdM7aUKoidBubG31x+4DXCqx4Y9vVEp+JEUxwh73k/GaRxehZE4kCN5SQqgxhZpOGZ1aL98h588yncXVMhOnW6/GMPi9teQQ2UKZYOcMCiMtldtOulVLHzBKv0PicLKO0J1etQzyAytzi5srP0VjFBYzpHQjYQuRi4HF/yI4/CTa+Q8Kib9MzF2jDn1nzYYBskVoSC+CNz/Wnh7HQRa2Bu7TJRZk5LZC4sG4ySp8OuWHpj8k7slJ1J3iofgETx656m4aSzuR0Rjm5H+M6KVY3zBwjCqI453ir2uyf3g97aXykD+7B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199021)(52536014)(55236004)(33656002)(478600001)(71200400001)(7696005)(316002)(26005)(5660300002)(9686003)(66556008)(66446008)(6506007)(110136005)(53546011)(186003)(6636002)(2906002)(76116006)(66946007)(54906003)(4326008)(64756008)(7416002)(41300700001)(66476007)(8936002)(8676002)(38100700002)(82960400001)(122000001)(55016003)(83380400001)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXZWd0p4NlZzRWxlb212VTFVQnh3TGRlR2oydnh3WS9qOWVtZkY1b3lCZVNF?=
 =?utf-8?B?UExzZy82OVRYVEQvV3d0S3pQV0ZXMDYvVll4OVd6Umx1dVBDZ1huYXNnZXl6?=
 =?utf-8?B?Nm9jOGtmWXdoYzdsUEorR2svS21LenM4bWlSSlk4NnFWK2dvS1ZHZWdnR3cy?=
 =?utf-8?B?SkEwYlpCYTNmRkdVUlBSMVdVYjM1bE9vaVE3ckc0azR4Z2NlaW1UYTBuZkpj?=
 =?utf-8?B?bFdhYlV6a2JiQ01NL0lLZjUrdkVMVDd2cUJaV214dGxFRlVRYk53eFMvMk5F?=
 =?utf-8?B?a2NmRElzRXJNMzhSdnRDYmQ0NlNNc2VMcjIyeThKZmhXL2RKUWJSQldOb1hH?=
 =?utf-8?B?MFpHQmJwejJ4N3ZEM3JpbGlOSThvbS92ZUF2V2R3UEx6MDNIOVFnOXpjTVFj?=
 =?utf-8?B?bFNQUHRDWnkvT0k2TUNGazN1dGE5VXN4Y3l6VWlJRDhyUkdobEkwL282UWlE?=
 =?utf-8?B?Y3ZuVUtsUTUydEJubVoxS3d6LzhuQ2NZNFBVcS9CUkMzVlJ0ZXlKa2g2cTNq?=
 =?utf-8?B?ODFHZ2F5TG0xbWFNZ3ZLTUFZc1JtdVB6U3pOcEJEVkRLT1l6QVlwcHRhZEVa?=
 =?utf-8?B?dGtJQW8wdkFGSmpYZXBDbFVpQ0Zqa0NtTWNZdnpDeUoxd0d1bTNlVEVlRlZ1?=
 =?utf-8?B?Rit6TlZNVHhab3dZR3Z1SEFLZUtac1Q0eDZBZzNHT2ZBaktXVE4wWVczd3A0?=
 =?utf-8?B?dUJuK2psQ0tVRnhseWdCOXNRM0piWU9CeFd2Z1hnNlVheTF3SzlnZEJpaXZp?=
 =?utf-8?B?QXpnMEtEcW5EajNpaVNMT1JZTWNhQXhaTjJKQ0tZbkcrVXc3UXdVWGF0MjRh?=
 =?utf-8?B?Y3cwWUN1c1VQZkQrcG1yR1RyamRqaUk4NkZtQzBVS2lLamk5SGJkbFYrdWx6?=
 =?utf-8?B?enVkSDZHZUYvWW0vTlpZRVhFdWdlT2tBcTBzVzJGWnNwbittb0hGWndLY0k2?=
 =?utf-8?B?ZXFpRVEwUHRkVGNRb1hrRXhqQXVnRkVSSDVhNWpxYkhiVG1DTnlySHA2WEF6?=
 =?utf-8?B?N2JqNGlRbTlxR1U0WVVxcDFYVU5MY2hpUkNZUUhDRVFIL3dxUFdhT1kvNlNS?=
 =?utf-8?B?a1RhczU1Qmw4K1hGV1dmYlphRS9qdjNwK1FJNHZ0OXpPRmM3ZGI2bERySXhm?=
 =?utf-8?B?dEUzR0tsSjlGZDFKRUFkc0ZlcDFjdGMxNFg3Szh0blN2dkFyYzNuTUlsVTdG?=
 =?utf-8?B?R01pVjNXS0VjTUVsYkh1dm1nYm5VaXZZTlJsa1hYUWhkYm00UzhuY2lacHY5?=
 =?utf-8?B?V3A2TmV3SXMrck9FWG9rNVZvcTNvZ0VQeVJJN1BsbWx5VWpBNWdZNkVleTdp?=
 =?utf-8?B?SlgySjAyNmE0N3AyZFlYU2Q0SUdCTHF3YldZYlVrUXdUcExyRFFXOUxyVXBt?=
 =?utf-8?B?bHhzeHlCd1V3VWNLcFdSNVZtZEZlRGJnL1BFaXFLcE9JUzRzdlR5ZExJY1Br?=
 =?utf-8?B?ZExIMmtkRGg3UXMydFl0OEI5V1pnQ2pDVXhicCtVaEpod1cyWlRIcDk1Uk9v?=
 =?utf-8?B?ZHUzd2ZqOEpWdWdQb0J4TEJBVmd0cldGSVFYbVppK01kblZYbkhnZlNKQVNE?=
 =?utf-8?B?MTE1emlQSGpYMnJhb0lINVVXZ0o5WkZ5a1N4VHNLanlaMGtEQS9aWlJ3d3NX?=
 =?utf-8?B?SHh1dlo0QWhiMEY3Zmt2SU9XUXJuNHI1RnBheldjS3A0MmFJVVhvK3RtTUY2?=
 =?utf-8?B?UXl3TEtiSi83ZjR2eVRwaUtvcUEyM01jNjEvSTV0Ym81WC9xSDN2TWx1SUFt?=
 =?utf-8?B?L0pacS9IamZqUCtjZGk0YVEyalN0SU5CZnZLY1ZCR1VaYWo0aVhKMVZ6eHFD?=
 =?utf-8?B?WTdNZVoxc2ZMNnVNVFpaL1AwdUFKOHhIWEdHMzVZeFFnTWpQUWlScG9ibmZX?=
 =?utf-8?B?VFN6c1lLcFNhejJTV29qQ2NpZlV4TGRud29neloxc0dtWHRXMDhFWjFhVFJK?=
 =?utf-8?B?TUQreGRISVJsSldNK3ZnbmhFcGdxZDhkRHVQdkpBMmc1amE5RmxUZWpYSTlG?=
 =?utf-8?B?WE92cXM1dzBYbEp2WmlWV2Q1c0lDV1Q3L051cDAzWWxsVFpreVpTalJhZW5V?=
 =?utf-8?B?N0w4NnhILy9MeWNFTFR6TXlScGI2TmNtR2NVNUZVRE9XeVk4eU9PazUveGxu?=
 =?utf-8?Q?E5fp9uD//pGPx84dlx51bfDVY?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d51a5112-431c-4071-34e0-08db3bbfdee5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 01:39:06.7009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Du1fwkcgjGgsBUFXwzLcRhQ45B3ouRT42HmvJVdrwoCqifJql2/XsCwX2kGX5CwAYY9okVJrISSiulLHP2hDPTy6xMMo8FTEkWwMlOahFPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7589
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1cnNkYXksIEFwcmlsIDEzLCAyMDIzIDU6NDYgQU0sIFN0YW5pc2xhdiBGb21pY2hldiA8
c2RmQGdvb2dsZS5jb20+IHdyb3RlOg0KPk9uIFdlZCwgQXByIDEyLCAyMDIzIGF0IDE6NTbigK9Q
TSBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4gd3JvdGU6DQo+Pg0KPj4N
Cj4+DQo+PiBPbiA0LzEyLzIwMjMgMTA6MDAgQU0sIFN0YW5pc2xhdiBGb21pY2hldiB3cm90ZToN
Cj4+ID4gT24gMDQvMTIsIFNvbmcgWW9vbmcgU2lhbmcgd3JvdGU6DQo+PiA+PiBBZGQgcmVjZWl2
ZSBoYXJkd2FyZSB0aW1lc3RhbXAgbWV0YWRhdGEgc3VwcG9ydCB2aWEga2Z1bmMgdG8gWERQDQo+
PiA+PiByZWNlaXZlIHBhY2tldHMuDQo+PiA+Pg0KPj4gPj4gU3VnZ2VzdGVkLWJ5OiBTdGFuaXNs
YXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29tPg0KPj4gPj4gU2lnbmVkLW9mZi1ieTogU29uZyBZ
b29uZyBTaWFuZyA8eW9vbmcuc2lhbmcuc29uZ0BpbnRlbC5jb20+DQo+PiA+PiAtLS0NCj4+ID4+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWMuaCAgfCAgMyArKysN
Cj4+ID4+IC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYyB8IDI2
DQo+PiA+PiArKysrKysrKysrKysrKysrKystDQo+PiA+PiAgMiBmaWxlcyBjaGFuZ2VkLCAyOCBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiA+Pg0KPj4gPj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hYy5oDQo+PiA+PiBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hYy5oDQo+PiA+PiBpbmRleCBhYzhj
Y2Y4NTE3MDguLjgyNmFjMGVjODhjNiAxMDA2NDQNCj4+ID4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hYy5oDQo+PiA+PiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWMuaA0KPj4gPj4gQEAgLTk0LDYgKzk0LDkgQEAg
c3RydWN0IHN0bW1hY19yeF9idWZmZXIgew0KPj4gPj4NCj4+ID4+ICBzdHJ1Y3Qgc3RtbWFjX3hk
cF9idWZmIHsNCj4+ID4+ICAgICAgc3RydWN0IHhkcF9idWZmIHhkcDsNCj4+ID4+ICsgICAgc3Ry
dWN0IHN0bW1hY19wcml2ICpwcml2Ow0KPj4gPj4gKyAgICBzdHJ1Y3QgZG1hX2Rlc2MgKnA7DQo+
PiA+PiArICAgIHN0cnVjdCBkbWFfZGVzYyAqbnA7DQo+PiA+PiAgfTsNCj4+ID4+DQo+PiA+PiAg
c3RydWN0IHN0bW1hY19yeF9xdWV1ZSB7DQo+PiA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPj4gPj4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+PiA+PiBpbmRleCBmN2Ji
ZGYwNGQyMGMuLmVkNjYwOTI3YjYyOCAxMDA2NDQNCj4+ID4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4+ID4+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4+ID4+IEBAIC01MzE1
LDEwICs1MzE1LDE1IEBAIHN0YXRpYyBpbnQgc3RtbWFjX3J4KHN0cnVjdCBzdG1tYWNfcHJpdg0K
Pj4gPj4gKnByaXYsIGludCBsaW1pdCwgdTMyIHF1ZXVlKQ0KPj4gPj4NCj4+ID4+ICAgICAgICAg
ICAgICAgICAgICAgIHhkcF9pbml0X2J1ZmYoJmN0eC54ZHAsIGJ1Zl9zeiwgJnJ4X3EtPnhkcF9y
eHEpOw0KPj4gPj4gICAgICAgICAgICAgICAgICAgICAgeGRwX3ByZXBhcmVfYnVmZigmY3R4Lnhk
cCwgcGFnZV9hZGRyZXNzKGJ1Zi0+cGFnZSksDQo+PiA+PiAtICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGJ1Zi0+cGFnZV9vZmZzZXQsIGJ1ZjFfbGVuLCBmYWxzZSk7DQo+PiA+
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ1Zi0+cGFnZV9vZmZzZXQs
IGJ1ZjFfbGVuLA0KPj4gPj4gKyB0cnVlKTsNCj4+ID4+DQo+PiA+PiAgICAgICAgICAgICAgICAg
ICAgICBwcmVfbGVuID0gY3R4LnhkcC5kYXRhX2VuZCAtIGN0eC54ZHAuZGF0YV9oYXJkX3N0YXJ0
IC0NCj4+ID4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWYtPnBhZ2Vfb2Zmc2V0
Ow0KPj4gPj4gKw0KPj4gPj4gKyAgICAgICAgICAgICAgICAgICAgY3R4LnByaXYgPSBwcml2Ow0K
Pj4gPj4gKyAgICAgICAgICAgICAgICAgICAgY3R4LnAgPSBwOw0KPj4gPj4gKyAgICAgICAgICAg
ICAgICAgICAgY3R4Lm5wID0gbnA7DQo+PiA+PiArDQo+PiA+PiAgICAgICAgICAgICAgICAgICAg
ICBza2IgPSBzdG1tYWNfeGRwX3J1bl9wcm9nKHByaXYsICZjdHgueGRwKTsNCj4+ID4+ICAgICAg
ICAgICAgICAgICAgICAgIC8qIER1ZSB4ZHBfYWRqdXN0X3RhaWw6IERNQSBzeW5jIGZvcl9kZXZp
Y2UNCj4+ID4+ICAgICAgICAgICAgICAgICAgICAgICAqIGNvdmVyIG1heCBsZW4gQ1BVIHRvdWNo
IEBAIC03MDcxLDYgKzcwNzYsMjMNCj4+ID4+IEBAIHZvaWQgc3RtbWFjX2ZwZV9oYW5kc2hha2Uo
c3RydWN0IHN0bW1hY19wcml2ICpwcml2LCBib29sIGVuYWJsZSkNCj4+ID4+ICAgICAgfQ0KPj4g
Pj4gIH0NCj4+ID4+DQo+PiA+PiArc3RhdGljIGludCBzdG1tYWNfeGRwX3J4X3RpbWVzdGFtcChj
b25zdCBzdHJ1Y3QgeGRwX21kICpfY3R4LCB1NjQNCj4+ID4+ICsqdGltZXN0YW1wKSB7DQo+PiA+
PiArICAgIGNvbnN0IHN0cnVjdCBzdG1tYWNfeGRwX2J1ZmYgKmN0eCA9ICh2b2lkICopX2N0eDsN
Cj4+ID4+ICsNCj4+ID4+ICsgICAgKnRpbWVzdGFtcCA9IDA7DQo+PiA+PiArICAgIHN0bW1hY19n
ZXRfcnhfaHd0c3RhbXAoY3R4LT5wcml2LCBjdHgtPnAsIGN0eC0+bnAsIHRpbWVzdGFtcCk7DQo+
PiA+PiArDQo+PiA+DQo+PiA+IFsuLl0NCj4+ID4NCj4+ID4+ICsgICAgaWYgKCp0aW1lc3RhbXAp
DQo+PiA+DQo+PiA+IE5pdDogZG9lcyBpdCBtYWtlIHNlbnNlIHRvIGNoYW5nZSBzdG1tYWNfZ2V0
X3J4X2h3dHN0YW1wIHRvIHJldHVybg0KPj4gPiBib29sIHRvIGluZGljYXRlIHN1Y2Nlc3MvZmFp
bHVyZT8gVGhlbiB5b3UgY2FuIGRvOg0KPj4gPg0KPj4gPiBpZiAoIXN0bW1hY19nZXRfcnhfaHd0
c3RhbXAoKSkNCj4+ID4gICAgICAgcmV1dHJuIC1FTk9EQVRBOw0KPj4NCj4+IEkgd291bGQgbWFr
ZSBpdCByZXR1cm4gdGhlIC1FTk9EQVRBIGRpcmVjdGx5IHNpbmNlIHR5cGljYWxseSBib29sDQo+
PiB0cnVlL2ZhbHNlIGZ1bmN0aW9ucyBoYXZlIG5hbWVzIGxpa2UgInN0bW1hY19oYXNfcnhfaHd0
c3RhbXAiIG9yDQo+PiBzaW1pbGFyIG5hbWUgdGhhdCBpbmZlcnMgeW91J3JlIGFuc3dlcmluZyBh
IHRydWUvZmFsc2UgcXVlc3Rpb24uDQo+Pg0KPj4gVGhhdCBtaWdodCBhbHNvIGxldCB5b3UgYXZv
aWQgemVyb2luZyB0aGUgdGltZXN0YW1wIHZhbHVlIGZpcnN0Pw0KPg0KPlNHVE0hDQoNCnN0bW1h
Y19nZXRfcnhfaHd0c3RhbXAoKSBpcyB1c2VkIGluIG90aGVyIHBsYWNlcyB3aGVyZSByZXR1cm4N
CnZhbHVlIGlzIG5vdCBuZWVkZWQuIEFkZGl0aW9uYWwgaWYgc3RhdGVtZW50IGNoZWNraW5nIG9u
IHJldHVybiB2YWx1ZQ0Kd2lsbCBhZGQgY29zdCwgYnV0IGlnbm9yaW5nIHJldHVybiB2YWx1ZSB3
aWxsIGhpdCAidW51c2VkIHJlc3VsdCIgd2FybmluZy4NCg0KSSB0aGluayBpdCB3aWxsIGJlIG1v
cmUgbWFrZSBzZW5zZSBpZiBJIGRpcmVjdGx5IHJldHJpZXZlIHRoZSB0aW1lc3RhbXAgdmFsdWUN
CmluIHN0bW1hY194ZHBfcnhfdGltZXN0YW1wKCksIGluc3RlYWQgb2YgcmV1c2Ugc3RtbWFjX2dl
dF9yeF9od3RzdGFtcCgpLg0KDQpMZXQgbWUgc2VuZCBvdXQgdjQgZm9yIHJldmlldy4NCg0KVGhh
bmtzICYgUmVnYXJkcw0KU2lhbmcNCg0KPg0KPj4gVGhhbmtzLA0KPj4gSmFrZQ0K
