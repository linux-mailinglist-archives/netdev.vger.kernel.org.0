Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC415A438F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiH2HLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH2HL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:11:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980794D4F9
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661757086; x=1693293086;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CxycLD13gmKdcG6sYkM6VO+p1D3noMCgd3/BiQzy+40=;
  b=MibMu6ZjiGP9ruUXJfCEtw47yVSfsxmfAh/dn5O2d8JkLhC74bkDm7Qj
   qj3kRxU6Vnx82K+Qwi2XcPFlaKKnjtxPktTYQB+J988xh2yC1RMINctBY
   wgO76CDWZo21m9JyYWBz47WSNOALN4RGSAW6YfubhaBC39dLM4aYCXFbY
   DfXrzCzFBXR9wy0ouRaHNCu2lIQ/f47GA1OrVf9KqKGK7RMO/YDj8ScgE
   Ai+4uMtcwuVZdNYZgV/7Kjddcw/Ra/UXi3oD2gncjv3KthIh3Z9Yd8h77
   Jw9ysm/kEXpFdQuq44ehzd7oW+jfmC94KAWhLJxg3cUHau+8IW0halBfV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="275232591"
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="275232591"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 00:11:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="714758259"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 29 Aug 2022 00:11:26 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 00:11:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 29 Aug 2022 00:11:25 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 29 Aug 2022 00:11:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMbgvfftbjKaq419QWq37Us+0PjHr28tMWdi0WPKAsB3oVu+5Cx73tNUUWW53GPRqi0opRvLY5EGBsJuZMhqF2bOUGdiCNh0kxWhL9ajwvgGiDMSXLaP9ufx5NJU5/qUbr3/q8pZ1xrT0/EpJw2AtCSyQHGqzowF8FOjvgNoSCYlJRXYLv07vzkAjLVtE7UYG14RnJ36AANPxOpJGOzItwnkOujTUAGHlUhhb9A8L2ly47kTl034o7/93ndsWk2L8j2q/Pi40F7GaUXwViyWB4D+MyewXAuYQdP4b0d9sQhZVxIudP3oPK05Sv6i6JG8CcdhxkRFiHNOtYtYuSMjRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxycLD13gmKdcG6sYkM6VO+p1D3noMCgd3/BiQzy+40=;
 b=Te9UC0+xzWLiz3A76DmS4VPySweVX7iD7VTms7fEcluMMSfm9BMU+kol1N5NH3vxwk6bucaa4Kj0/PiRzYRF5QaSzY25D5UG1GrA+jKM7TVMQ/eoiPPuqj/iUyzbLgKNuF5oYxVaXXnlsVx30lDocwIwYrHODHgibGUMSy/m7ZhiSovpIMSllbizBsEawI5SHpEFqdU65JlMSmcHYWhpijWNcrwQ40qfVygoYHUQ+sZFDzdAHIvLlEixKgwn6khzVLQbPQKsFzEuOVgnZ6lRniwkeyvHZCxAa1qR1RzMe/4Dv/e4q5tFvPDaKOx6Kr6uARtQnuFX2/7t0Qu7b9UpAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by BL0PR11MB2884.namprd11.prod.outlook.com (2603:10b6:208:72::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Mon, 29 Aug
 2022 07:11:18 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::b4ce:dcac:20c5:66c8]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::b4ce:dcac:20c5:66c8%8]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 07:11:18 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: RE: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Topic: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Index: AQHYtwG+vEC+zxF9EUaLIV60VfCCNK2+DsqAgABCJ9CAAOPjgIAAnPyAgAAHflCAAAlpgIAAAyXwgAAwQYCAAEQfAIAABmWAgAEaQoCAAGY2gIACRriAgAFU34A=
Date:   Mon, 29 Aug 2022 07:11:18 +0000
Message-ID: <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
 <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
 <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
 <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
 <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
 <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
 <20220825180107.38915c09@kernel.org>
 <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
 <20220826165711.015e7827@kernel.org>
 <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
In-Reply-To: <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 519dfe23-7d45-4640-6f43-08da898dab45
x-ms-traffictypediagnostic: BL0PR11MB2884:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N+foolpd/ky3N2FpRarOjepesgzWXL+xxRn8JvUIx7hKcZO+iKI9qnj2ZjhOZdfHCsBkLKcM6gbhSVnuYe/3fa1Htk9TfBA1nr8VYqMSwlb4zpyFoNtK9Dkl1X7LVYujxfGi3jPGIu/MhrecLrBQD3YEGAxNuNzcsLQWbft6vgzyef2WrjUZ5Z4Rs3MdnDyd7ijmx0DaTfKAoqviBx0dYTPomQI7L4gnHlUbDeOtEw0WRRHyKdv3eMkLKoeMhGhsGVHVdPwHyZQZWj6p5BVddBLQWjx8Wt2cWElN6eKA9PiDzz6tqechiV46Lbm3A53PB4HFIURLMXJmwVaofTfxAnFSAZpnjpM4G9orood4B8BIePb5EMYs/UjesvmJwtYAq0D7WqTSkTEOy3rve8LlcBcdIe8oaZLc2UuMWs4bwjS/aJJhTogbJIX5EBRlYWva0IWdfHdiwD+R50SMUaAoOpO9kwlN+A94mu0vIQE2ZjSfIDq0ZGvHRZoBOJnexrvG6JL6OcsmMiziNqyc5qZ9NwefzSuPRDMrG4AK5/2YdaUN/vGoeUFrgYvOYbxn89FoG8fiTK5/AP3YYbpilAreVL4WeB5X4pUeHElwKg2TsidjsEV/JsnjJmptkoVdyIN7rZ0fEtWdbaxBZ9Od2vfoy+zymRMn4uMhDQgtyXpcbzL/c+pPfWiY5BcHO3k2L+bqyokkbomBGOXzYYxZLkHp4T5yZ4TXu709FkHR4YLbe2nJwbJz8qiEJJLWCe0j3dPVmuWoeLKWpjjuyOcPoyfWYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(136003)(366004)(39860400002)(66476007)(2906002)(8676002)(33656002)(8936002)(66556008)(55016003)(66446008)(4326008)(64756008)(66946007)(76116006)(316002)(54906003)(478600001)(110136005)(53546011)(7696005)(9686003)(26005)(6506007)(41300700001)(71200400001)(82960400001)(83380400001)(38070700005)(86362001)(186003)(38100700002)(52536014)(5660300002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW5CbXpOTmVZVlYvZVNObFVndXN1TllwWWR5Rjh6eHlmQ2VqSEd2K09KT0Np?=
 =?utf-8?B?Zzh0NlN1QmZtSjdsTDlZSFJZQWdqR3Eya3M1VFlIU1RyQ1FVY2pjeW9oZ0NI?=
 =?utf-8?B?RXpjNjZZNTh1YVhwcmgzRmlkS3NEOUpKcEhlTDIxNCtObkQzaEo3OWtIU0V1?=
 =?utf-8?B?YVNuK2dSM2lINkphT1F6NVA1c2pFWFV0eWRkT2NWRjNZS3VrUyt2K3JaSzBq?=
 =?utf-8?B?bmY1TlpmbDFaZVh4Nk54bXZvRmFaeEoxdS9FYStJQVVNblNEeSt1dE9jMFg4?=
 =?utf-8?B?d1pXK01RSjFoR3NrYmNtZ3Z4UHBrNVhGMHhWYzhOVTczeDBmK0J6MWM5TTcr?=
 =?utf-8?B?Uy9HT3hmYmxISjBmakNMbXRKdWZoNmhhR2NNcm9tYktVMllDSkN3eXBLbzN5?=
 =?utf-8?B?N3ZNa1NEcUJyUk1sa3ZtLzc3ZTRubjMwMkNBelI4elBaanFSaHA2RWNOUExs?=
 =?utf-8?B?R2tXbkRsd0tOeDRpNlFreXN1N3lFS1poeUl3MWlPcGNrT3FCQW16eUFFRTJm?=
 =?utf-8?B?MkJaSDdXd01NUFFvemdVQ210TTk5RGZJTW5tWlB3M25mUVVUUXQ2R2NWNHlL?=
 =?utf-8?B?WnNKQkorbFk5QmpGVk52cGVFeG9DVk1mS3k4S1M2UUJoU1EvV2pHTEJNaEN3?=
 =?utf-8?B?KzIyVlgvWlVIYmwxMjh3ejdwdG9mblYzVkVERnZGZ1Z0Q2tNWHp0Z0d1R1dC?=
 =?utf-8?B?WjVYZWJaS1Q5M0o5UmhRTUwvL2hES0k1UHJieFJVbmovcDZOYm5SQmE0Sndk?=
 =?utf-8?B?Uk5OTTdLam1wTHZuY3g0Q3FxaWRVZ2Rzc2U5YzUrWTMzU3JYc2lyQlc2dngy?=
 =?utf-8?B?R3ZzOXphYXVWSjRjRjlJZnZEQmNhQ2Q4V25QS1RqbUs0aXh4RjJwOVEzT3pu?=
 =?utf-8?B?b2RFNzh4TjU0bkJOMko2bkdKZWhPN2RLWmJBNnNjN2luSUVzeU5leTBwRHJr?=
 =?utf-8?B?R04rNnozRnhLbVBNcHVRVjB2RGE2d0FZMWkyRmNOamZnbXBFMGhGZkU3NDE0?=
 =?utf-8?B?WjQzRno2ckhFOTFsTnRtVDByZDNtRVBiZG9oR0pCQitlSkZXZmtUazlPeWZB?=
 =?utf-8?B?TlUzQWxISTI5b1E0TEpHQUk2d0s5UWV6Nzhscy81Z05aV1NlbVZuMURVZ3Iv?=
 =?utf-8?B?aXdTWG9lL3p0VllKbXRVWVVvQXNuaXlIc0tkTXZRUk91OCtPSjBtMWJ1VnhJ?=
 =?utf-8?B?a1dLUUZBc0NjcWdEcHR5bkNiSXRQUGFEaE1GbnNUanJYM3pPNnhFTURDMnk5?=
 =?utf-8?B?Zk1mbDV4R0RDWUs3ak52UW13YUtRL0lZR043L05Tcmp1Z1hIRlJ2cnhKWGlY?=
 =?utf-8?B?RHloRXZqb3lEVFVJN0hoVzFyYjBLN3h2RnBJUDV5UFRrMkFhbmJHUEZmdHg3?=
 =?utf-8?B?OUM5ckpPYWFlZmE3K2hEbWt3MC9SL0NkbU1qVFloWEorRDRVUnVoa1FDVUIv?=
 =?utf-8?B?YnFKMldlbTduVVYvb1ZrSDlBSHJpSjloNmpIS0VpeGdESUtTcEhQMERreVg1?=
 =?utf-8?B?Tzk4SFU0RUJKY3I3dkl6RWdIY3BKKy9wVmtkTDE0YnM4L3JMclRHb1ZJZ0hr?=
 =?utf-8?B?UTlqNkpPYWwwOTQ0a0ZjNkMrbXpZcTRwcFJ6N1loTzRvYnhUbE1ialJrTjlP?=
 =?utf-8?B?ak5MeVRhbzZyemlrRWFUQkdtTkRySUkvNThSZkFScHNoM3VSRGpMaHdPMEp2?=
 =?utf-8?B?b3VEYXA1ODdDTHRSSTNRcytRdUJhc0diZEtrdU5LMnRmaWRjdHIyS3pDZnhh?=
 =?utf-8?B?czNjc1gvSDVYZUsyQXFGdDVqZDRobll5OFpMMzIzQXNOLzJZdTAxcmRONXdC?=
 =?utf-8?B?cTlhNHBGTGFLTG1xeFdVTVZKU2dEUndjSEtnSjdEUGNlUThmcUVSNW5jeUVs?=
 =?utf-8?B?K1VTSWxEL2JUZkpOOTRUVGtFTHF4RkZkRVRUczFWQlQ0Q1ZGajg3THkzK2Vx?=
 =?utf-8?B?a0NHSHIwK0FneXRtRFB1czhyREpDZ2R1RWI3UEtDQzl0cEJWdW9WRFhHTmp0?=
 =?utf-8?B?eGNYMm43YXlYSUhSLzdOVFJHSjVpZlRRaDg4SWFLUVBwWmJCa09nM0EvM2tF?=
 =?utf-8?B?YkUzZEhrWk9qaW5rWDhmYkRmN3NCN1VwYnhIMUpyK2t4dHUyT3piLzc5bHdp?=
 =?utf-8?Q?GYCK7mE+Pe/vyqaiLbi+AvgMA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 519dfe23-7d45-4640-6f43-08da898dab45
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 07:11:18.3038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wD4BKexbsfUCdozBkLgvjPAFBJM15RXhNaVAPpx1jIQFTKG5+3pxYSjQL67+mGzKtkWWzDY29GsLDb0TpDipreRUwDAKyh3ss/HN5+Sx1Io=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2884
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR2FsIFByZXNzbWFuIDxn
YWxAbnZpZGlhLmNvbT4NCj4gU2VudDogU3VuZGF5LCBBdWd1c3QgMjgsIDIwMjIgMzo0MyBBTQ0K
PiBUbzogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEtlbGxlciwgSmFjb2IgRSA8
amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiBDYzogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBu
dmlkaWEuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgU2ltb24NCj4gSG9ybWFuIDxob3Jt
c0B2ZXJnZS5uZXQuYXU+OyBBbmR5IEdvc3BvZGFyZWsgPGFuZHlAZ3JleWhvdXNlLm5ldD4NCj4g
U3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAwLzJdIGljZTogc3VwcG9ydCBGRUMgYXV0b21h
dGljIGRpc2FibGUNCj4gDQo+IE9uIDI3LzA4LzIwMjIgMDI6NTcsIEpha3ViIEtpY2luc2tpIHdy
b3RlOg0KPiA+IE9uIEZyaSwgMjYgQXVnIDIwMjIgMTA6NTE6MjEgLTA3MDAgSmFjb2IgS2VsbGVy
IHdyb3RlOg0KPiA+PiBPbiA4LzI1LzIwMjIgNjowMSBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6
DQo+ID4+PiBPaCwgYnV0IHBlciB0aGUgSUVFRSBzdGFuZGFyZCBObyBGRUMgaXMgX25vdF8gYW4g
b3B0aW9uIGZvciBDQS1MLg0KPiA+Pj4gRnJvbSB0aGUgaW5pdGlhbCByZWFkaW5nIG9mIHlvdXIg
c2VyaWVzIEkgdGhvdWdodCB0aGF0IEludGVsIE5JQ3MNCj4gPj4+IHdvdWxkIF9uZXZlcl8gcGlj
ayBObyBGRUMuDQo+ID4+IFRoYXQgd2FzIG15IG9yaWdpbmFsIGludGVycHJldGF0aW9uIHdoZW4g
SSB3YXMgZmlyc3QgaW50cm9kdWNlZCB0byB0aGlzDQo+ID4+IHByb2JsZW0gYnV0IEkgd2FzIG1p
c3Rha2VuLCBoZW5jZSB3aHkgdGhlIGNvbW1pdCBtZXNzYWdlIHdhc24ndCBjbGVhciA6KA0KPiA+
Pg0KPiA+PiBUaGlzIGlzIHJhdGhlciBtb3JlIGNvbXBsaWNhdGVkIHRoYW4gSSBvcmlnaW5hbGx5
IHVuZGVyc3Rvb2QgYW5kIHRoZQ0KPiA+PiBuYW1lcyBmb3IgdmFyaW91cyBiaXRzIGhhdmUgbm90
IGJlZW4gbmFtZWQgdmVyeSB3ZWxsIHNvIHRoZWlyIGJlaGF2aW9yDQo+ID4+IGlzbid0IGV4YWN0
bHkgb2J2aW91cy4uLg0KPiA+Pg0KPiA+Pj4gU291bmRzIGxpa2Ugd2UgbmVlZCBhIGJpdCBmb3Ig
Imlnbm9yZSB0aGUgc3RhbmRhcmQgYW5kIHRyeSBldmVyeXRoaW5nIi4NCj4gPj4+DQo+ID4+PiBX
aGF0IGFib3V0IEJBU0UtUiBGRUM/IElzIHRoZSBGVyBnb2luZyB0byB0cnkgaXQgb24gdGhlIENB
LUwgY2FibGU/DQo+ID4+IE9rIEkgZ290IGZ1cnRoZXIgY2xhcmlmaWNhdGlvbiBvbiB0aGlzLiBX
ZSBoYXZlIGEgYml0LCAiQXV0byBGRUMNCj4gPj4gZW5hYmxlIiwgYXMgd2VsbCBhcyBhIGJpdG1h
c2sgZm9yIHdoaWNoIEZFQyBtb2RlcyB0byB0cnkuDQo+ID4+DQo+ID4+IElmICJBdXRvIEZFQyBF
biIgaXMgc2V0LCB0aGVuIHRoZSBMaW5rIEVzdGFibGlzaG1lbnQgU3RhdGUgTWFjaGluZSB3aWxs
DQo+ID4+IHRyeSBhbGwgb2YgdGhlIEZFQyBvcHRpb25zIHdlIGxpc3QgaW4gdGhhdCBiaXRtYXNr
LCBhcyBsb25nIGFzIHdlIGNhbg0KPiA+PiB0aGVvcmV0aWNhbGx5IHN1cHBvcnQgdGhlbSBldmVu
IGlmIHRoZXkgYXJlbid0IHNwZWMgY29tcGxpYW50Lg0KPiA+Pg0KPiA+PiBGb3Igb2xkIGZpcm13
YXJlIHRoZSBiaXRtYXNrIGRpZG4ndCBpbmNsdWRlIGEgYml0IGZvciAiTm8gRkVDIiwgd2hlcmUg
YXMNCj4gPj4gdGhlIG5ldyBmaXJtd2FyZSBoYXMgYSBiaXQgZm9yICJObyBGRUMiLg0KPiA+Pg0K
PiA+PiBXZSB3ZXJlIGFsd2F5cyBzZXR0aW5nICJBdXRvIEZFQyBFbiIgc28gY3VycmVudGx5IHdl
IHRyeSBhbGwgRkVDIG1vZGVzDQo+ID4+IHdlIGNvdWxkIHRoZW9yZXRpY2FsbHkgc3VwcG9ydC4N
Cj4gPj4NCj4gPj4gSWYgIkF1dG8gRkVDIEVuIiBpcyBkaXNhYmxlZCwgdGhlbiB3ZSBvbmx5IHRy
eSBGRUMgbW9kZXMgd2hpY2ggYXJlIHNwZWMNCj4gPj4gY29tcGxpYW50LiBBZGRpdGlvbmFsbHks
IG9ubHkgYSBzaW5nbGUgRkVDIG1vZGUgaXMgdHJpZWQgYmFzZWQgb24gYQ0KPiA+PiBwcmlvcml0
eSBhbmQgdGhlIGJpdG1hc2suDQo+ID4+DQo+ID4+IEN1cnJlbnRseSBhbmQgaGlzdG9yaWNhbGx5
IHRoZSBkcml2ZXIgaGFzIGFsd2F5cyBzZXQgIkF1dG8gRkVDIEVuIiwgc28NCj4gPj4gd2Ugd2Vy
ZSBlbmFibGluZyBub24tc3BlYyBjb21wbGlhbnQgRkVDIG1vZGVzLCBidXQgIk5vIEZFQyIgd2Fz
IG9ubHkNCj4gPj4gYmFzZWQgb24gc3BlYyBjb21wbGlhbmNlIHdpdGggdGhlIG1lZGlhIHR5cGUu
DQo+ID4+DQo+ID4+IEZyb20gdGhpcywgSSB0aGluayBJIGFncmVlIHRoZSBjb3JyZWN0IGJlaGF2
aW9yIGlzIHRvIGFkZCBhIGJpdCBmb3INCj4gPj4gIm92ZXJyaWRlIHRoZSBzcGVjIGFuZCB0cnkg
ZXZlcnl0aGluZyIsIGFuZCB0aGVuIG9uIG5ldyBmaXJtd2FyZSB3ZSdkDQo+ID4+IHNldCB0aGUg
Ik5vIEZFQyIgd2hpbGUgb24gb2xkIGZpcm13YXJlIHdlJ2QgYmUgbGltaXRlZCB0byBvbmx5IHRy
eWluZw0KPiA+PiBGRUMgbW9kZXMuDQo+ID4+DQo+ID4+IERvZXMgdGhhdCBtYWtlIHNlbnNlPw0K
PiA+Pg0KPiA+PiBTbyB5ZWEgSSB0aGluayB3ZSBkbyBwcm9iYWJseSBuZWVkIGEgImlnbm9yZSB0
aGUgc3RhbmRhcmQiIGJpdC4uIGJ1dA0KPiA+PiBjdXJyZW50bHkgdGhhdCBhcHBlYXJzIHRvIGFs
cmVhZHkgYmUgd2hhdCBpY2UgZG9lcyAoZXhjZXB0aW5nIE5vIEZFQw0KPiA+PiB3aGljaCBkaWRu
J3QgcHJldmlvdXNseSBoYXZlIGEgYml0IHRvIHNldCBmb3IgaXQpDQo+ID4gVGhhbmtzIGZvciBn
ZXR0aW5nIHRvIHRoZSBib3R0b20gb2YgdGhpcyA6KQ0KPiA+DQo+ID4gVGhlICJvdmVycmlkZSBz
cGVjIG1vZGVzIiBiaXQgc291bmRzIGxpa2UgYSByZWFzb25hYmxlIGFkZGl0aW9uLA0KPiA+IHNp
bmNlIHdlIHBvc3NpYmx5IGhhdmUgZGlmZmVyZW50IGJlaGF2aW9yIGJldHdlZW4gdmVuZG9ycyBs
ZXR0aW5nDQo+ID4gdGhlIHVzZXIga25vdyBpZiB0aGUgZGV2aWNlIHdpbGwgZm9sbG93IHRoZSBy
dWxlcyBjYW4gc2F2ZSBzb21lb25lDQo+ID4gZGVidWdnaW5nIHRpbWUuDQo+ID4NCj4gPiBCdXQg
aXQgZG9lcyBzb3VuZCBvcnRob2dvbmFsIHRvIHlvdSBhZGRpbmcgdGhlIE5vIEZFQyBiaXQgdG8g
dGhlIG1hc2sNCj4gPiBmb3IgaWNlLg0KPiA+DQo+ID4gTGV0IG1lIGFkZCBTaW1vbiBhbmQgQW5k
eSBzbyB0aGF0IHdlIGhhdmUgdGhlIG1ham9yIHZlbmRvcnMgb24gdGhlIENDLg0KPiA+ICh0bDtk
ciB0aGUgcXVlc3Rpb24gaXMgd2hldGhlciB5b3VyIEZXIGZvbGxvd3MgdGhlIGd1aWRhbmNlIG9m
DQo+ID4gJ1RhYmxlIDExMEPigJMx4oCUSG9zdCBhbmQgY2FibGUgYXNzZW1ibHkgY29tYmluYXRp
b25zJyBpbiBBVVRPIEZFQyBtb2RlKS4NCj4gPg0KDQpUaGUgb3RoZXIgZW5naW5lZXJzIEkgc3Bv
a2UgdG8gYWxzbyB3YW50ZWQgdG8gbWVudGlvbiB0aGF0IDExMEMtMSBpcyBvbmx5IGEgc21hbGwg
c3Vic2V0IG9mIGFsbCBvZiB0aGUgdmFyaW91cyBsaW5rIHR5cGVzLiBUaGV5IGFsc28gbWVudGlv
bmVkIHNvbWV0aGluZyBhYm91dCBhbiBTRkYgc3RhbmRhcmQgd2hpY2ggZGVzY3JpYmVzIG1hbnkg
bW9yZSB0eXBlcy4NCg0KPiA+IElmIGFsbCB0aGUgdmVuZG9ycyBhbHJlYWR5IGlnbm9yZSB0aGUg
c3RhbmRhcmQgKGxpa2UgSW50ZWwgYW5kIEFGQUlVDQo+ID4gblZpZGlhKSB0aGVuIHdlIGp1c3Qg
bmVlZCB0byBkb2N1bWVudCwgbm8gcG9pbnQgYWRkaW5nIHRoZSBiaXQuLi4NCj4gDQo+IEkgdGhp
bmsgd2UgbWlzdW5kZXJzdG9vZCBlYWNoIG90aGVyIDopLg0KPiBPdXIgaW1wbGVtZW50YXRpb24g
ZGVmaW5pdGVseSAqZG9lcyBub3QqIGlnbm9yZSB0aGUgc3RhbmRhcmQuDQo+IFdoZW4gYXV0b25l
ZyBpcyBkaXNhYmxlZCwgYW5kIGF1dG8gZmVjIGlzIGVuYWJsZWQsIHRoZSBmaXJtd2FyZSBjaG9v
c2VzDQo+IGEgZmVjIG1vZGUgYWNjb3JkaW5nIHRvIHRoZSBzcGVjLiBJZiAibm8gRkVDIiBpcyBu
b3QgaW4gdGhlIHNwZWMsIHdlDQo+IHdpbGwgbm90IHBpY2sgaXQgKG5vciBkbyB3ZSB3YW50IHRv
KS4NCj4gSXQgc291bmRzIGxpa2UgeW91J3JlIG5vdCBoYXBweSB3aXRoIHRoZSBzcGVjLCB0aGVu
IHdoeSBub3QgY2hhbmdlIGl0Pw0KPiBUaGlzIGRvZXNuJ3Qgc291bmQgbGlrZSBhbiBhcmVhIHdo
ZXJlIHdlIHdhbnQgdG8gYmUgbm9uLWNvbXBsaWFudC4NCj4gDQo+IFJlZ2FyZGxlc3MsIGNoYW5n
aW5nIG91ciBpbnRlcmZhY2UgYmVjYXVzZSBvZiBvbmUgZGV2aWNlJyBmaXJtd2FyZQ0KPiBidWcv
YmVoYXZpb3IgY2hhbmdlIGRvZXNuJ3QgbWFrZSBhbnkgc2Vuc2UuIFRoaXMgaW50ZXJmYWNlIGFm
ZmVjdHMgYWxsDQo+IGNvbnN1bWVycywgYW5kIGlzIGdvaW5nIHRvIHN0aWNrIHdpdGggdXMgZm9y
ZXZlci4gRmlybXdhcmUgd2lsbA0KPiBldmVudHVhbGx5IGdldCB1cGRhdGVkIGFuZCBpdCBvbmx5
IGFmZmVjdHMgb25lIGRyaXZlci4NCg0KV2VsbCwgdGhlIGN1cnJlbnQgaWNlIGJlaGF2aW9yIGZv
ciBldmVyeSBGRUMgbW9kZSAqZXhjZXB0KiBObyBGRUMsIHdlIHRyeSBtb2RlcyB3aGljaCBtYXkg
YmUgc3VwcG9ydGFibGUgZXZlbiB0aG91Z2ggdGhleSdyZSBvdXRzaWRlIHRoZSBzcGVjLiBBcyBm
YXIgYXMgSSB1bmRlcnN0YW5kLCB0aGUgcmVhc29uIHdlIGF0dGVtcHQgdGhlc2UgaXMgYmVjYXVz
ZSBpdCBhbGxvd3MgbGlua2luZyBpbiBtb3JlIHNjZW5hcmlvcywgcHJlc3VtYWJseSBiZWNhdXNl
IHNvbWUgY29tYmluYXRpb24gb2YgdGhpbmdzIGlzIG5vdCBmdWxseSBzcGVjIGNvbXBsaWFudD8g
SSBkb24ndCByZWFsbHkga25vdyBmb3Igc3VyZS4NCg0KRm9yIGZ1dHVyZSBmaXJtd2FyZSwgdGhp
cyB3b3VsZCBpbmNsdWRlIE5vIEZFQyBhcyB3ZWxsLiBUaHVzLCBldmVuIHdpdGggZnV0dXJlIGZp
cm13YXJlIHdlJ2Qgc3RpbGwgYmUgdHJ5aW5nIHNvbWUgbW9kZXMgb3V0c2lkZSBvZiB0aGUgc3Bl
Yy4gSSBjYW4gdHJ5IHRvIGdldCBzb21lIG1vcmUgYW5zd2VycyB0b21vcnJvdyBhYm91dCB0aGUg
cmVhc29uaW5nIGFuZCBqdXN0aWZpY2F0aW9uIGZvciB0aGlzIGJlaGF2aW9yLg0KDQpUaGFua3Ms
DQpKYWtlDQo=
