Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D946E450B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 12:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjDQKVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 06:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjDQKVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 06:21:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25F1E4A
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 03:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681726817; x=1713262817;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EK2NF4SDIjgd9GLyRULGbakzJ4vhCg1bGSaZ/MSPtyc=;
  b=UO5WQjzsJ3hyzpKU5j+AuJcc0htBpd67pX1j+ZMptl8Q/Y+2mPOESLxm
   1XLWW28QgaGP3JKpC9o7WBKEdzQ4YMN1qwZWxv1wDJx/1YfxwvviJtoP1
   T1GNi56gANOsZAjO7yLGzQYhLJivpQRw5/7gypDquIsS+wy9K+t0dsZmi
   XyUG2o+GO3xf+XySoKMJGOuWnbKL8Jqufemnz2drDYi9CAHMF1z85gh1h
   klBN/AwaivRTzKA9lMYcM2EE3Zz5bK+E5wHLl8YSRiC2h/ZRk7pBOoXwt
   YVobqVWCRuaoP9AhgK8wOlSZ6QLOZa9AS08WlhNVAzNEZBmgaW4f/FmLD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="407747829"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="407747829"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 03:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="693198606"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="693198606"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 17 Apr 2023 03:16:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 03:16:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 03:16:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 03:16:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 03:16:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MS3Vm5hyeuBhKP/47OyxLKbP+Tr+krOC9d2NsJRBQ3hUYxL/L9pjSpKd5FDNNu1YtxFD/weW33KOdiiEaoFFs0f0Q21eXIdJ2gaq3BcjWrP1HxBjWhxyY6Wuzs75shHuH46txYTz3ad3rieAb9Dct+E7B149KOme4czm2jEs1CGfd4I43Sz/jIBJ0vBNsr1Gb5NoTNkb2T7GQo/U+D2m2nhhFcyHsdibadsAXzErCpK7Vm0arWPfYEBL7iXQtq6WO3XJ5V3+zQ1DgaEC3a43gkXY1/tG3Ix88/ZBLwz/OnQPkNpUm/e9LAQYQ/60JUZNW68NwpfdHJO9fs4tsE9rVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EK2NF4SDIjgd9GLyRULGbakzJ4vhCg1bGSaZ/MSPtyc=;
 b=ilwOIw0M/p15d5QxtzRFejYuBX1ixEuC/zd0RZOUxmHFtEU7+ccjwH6Sl++KkLI5qNy995c/bdEBRKWSQ5kyjmPubrue//N8hPkSrbMG7csFWI5JangNndDF8jD6L+BoonJLpnzBzHmXcoD7bMbj03WtQ7lHi5sBw5SryMj2ttwhx/Pmq8EO7sLc8SuM5bTYfxvQhlXCM+IPEP31UpEyedWte8WJV+3gKpamtDgxJ6shlNdp8e2uOKNJHTWIiuUJFhQGW3Txb7okV1080DD0oRiRa7xzVxRjQOC9uaN/Rf0HOSU/44YSpgAPRESu+YBYVXZgK3le4y+BCZ4y7otAEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9)
 by MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Mon, 17 Apr
 2023 10:16:46 +0000
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::f85e:135d:b09b:4c98]) by SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::f85e:135d:b09b:4c98%5]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 10:16:46 +0000
From:   "Sokolowski, Jan" <jan.sokolowski@intel.com>
To:     "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net v1] ice: fix undersized tx_flags
 field
Thread-Topic: [Intel-wired-lan] [PATCH net v1] ice: fix undersized tx_flags
 field
Thread-Index: AQHZbEfwH0T/13KEtUGuwdV4vR681K8n5M2AgAdfx1A=
Date:   Mon, 17 Apr 2023 10:16:45 +0000
Message-ID: <SJ0PR11MB5815C2C1645B74378E59298A999C9@SJ0PR11MB5815.namprd11.prod.outlook.com>
References: <20230411073707.19230-1-jan.sokolowski@intel.com>
 <d412bbf7-bfb7-42bc-4352-fd99d38121bd@intel.com>
In-Reply-To: <d412bbf7-bfb7-42bc-4352-fd99d38121bd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5815:EE_|MW4PR11MB6739:EE_
x-ms-office365-filtering-correlation-id: bc7df1be-b228-4ec6-ec69-08db3f2cd93e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pbrt2LAcZ+NL57v/aT6jITeuoH5fMJGCBSMyaS4u6tK18MkIdbCkKbNiwcae36mVd+bFv+JVIKJN2xSqpkgAf6ppl0zhmaf/nqLpPwdn1950IpEoQwZy59V7Hie8YE6JYFsQGMjI0u5CGPMxX4i+1rLeB1vbGy1U0Oe49efBZilZNt6kKcfa6eWgSqpzA8A2ML2vTAgpCjmdFpqWrTtcGl17T91c7J/ewhQ4pp3BuZgHHO4ZVCrTi1J1DFw3d6PInBU5B61CyfG/pDhK1Jw3w6cuvuBZJTmLHd7GrhVGDcN1SfZrJLfALcmHzsgR7H40XyjuAPGHI+slaMJBKNmMxwHxmhdBH5kOynw85Eu8LoAPL4lBEMC9LpAUReSCLRHazTVjI6zjPLFsFer7kMg6Ac/C1WRBCMX52+j7y+YHIu2Y0YIAh/HCkEvltC0aNwtCeENCLE1E2350Ayc9yt4r5BZEZgLtpnxrng5+2xXus1fMy0Tsb5/3LC7EVpXGqQ5Lg6dI5yl+pgiKl2E3xtdtkA/plDI5zVGlh18dFcUz9U6pwpxOwEXBXVazdNs91591YzcIkXlMgOlmfU1I/90XzLc9ALaT1iMQE9fu58CNSaWYH43j8H6xyNPzkSrsuSBD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5815.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199021)(8936002)(122000001)(83380400001)(76116006)(6506007)(71200400001)(7696005)(82960400001)(53546011)(54906003)(6636002)(478600001)(186003)(26005)(9686003)(38070700005)(33656002)(2906002)(38100700002)(52536014)(5660300002)(66446008)(86362001)(4326008)(64756008)(66556008)(41300700001)(66946007)(6862004)(66476007)(316002)(8676002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjFSaXlKS0lmWU9TMnhoR1p6TXZNcXA5QUI1Qm5Md3F3ZktQWE9ibVowR0U2?=
 =?utf-8?B?TzdmTmx6M0tIZmg3emo5b2dZelFpTHRCbmRmRlRMZC81bzVVN2poVnVxYklN?=
 =?utf-8?B?WEx0TnhlUVdqOHZwZ1Y3MUE0T1pFaW90ZGZORGR4VjFPc3hmTVJKQ0ZCRzlM?=
 =?utf-8?B?T3BsbklYWXN3dy9RMS93OGMwL2ZYbU1HRUVtcHQ1ZTNLSC9HcURjVGdIU2Fq?=
 =?utf-8?B?bTN2NlVUSVltaWY3d2hkOUJWMEtBVVdUOVZSaGVOT1NxTmQzaXNja2xiK0RN?=
 =?utf-8?B?SXd0Y2JPNTZ5VjFnUFNQTkFHRWFpNFN2dzAxOGFVajVRQzFDbGhMbEF1d2Zl?=
 =?utf-8?B?V2U0L0gySDBnOVFZaGR6U0VBWHRLMTBBY3hQQ2M0NGJnaU9xemtLN05TL1NG?=
 =?utf-8?B?MW1aMU5WaDBNR2hqYi9LbktrQmYzMEdLS0IrcHlUSnpTbTVrSExtTEV4amFp?=
 =?utf-8?B?bWFJOC8vRlpkdE00YTlqa1lKODlzSWZERFBLS3p4bTUvaDR4Q2lpYnlWTXFZ?=
 =?utf-8?B?ZVM2RitVSlRWZVlTZmk5Rm45amdWNDVYb2ZrL0g5YkYxZXVpWTBsUlZNYWd6?=
 =?utf-8?B?U3UzQmtoWVdtRk05bW9XM3FjRlRZQ3dxM1Jpanhqa3RDRnpkNVE1bkNpQngw?=
 =?utf-8?B?dWxhVHRBeGtmOWdiSlFSZk1XY2ppRjJlUFhFeWovSnNHOUx6cm9MeGJVUGxD?=
 =?utf-8?B?QjNSQTFJd1VNV2VWeDJBZ1NvdGwxZFBtOFNueDBVQjlOWU9xa3FYS0t0ZXBt?=
 =?utf-8?B?dlBYa2lXenNyTWtOdnhnSTNHa1RlS0Z2N1NvNmpVc2ErLzdDRndEL3crVGcw?=
 =?utf-8?B?bWJjMmt1a0wwRzNNTVBZRGM3OGYrdmR3K0hTS0Z5VkxlMjNLTGU0UFRqVWp0?=
 =?utf-8?B?eXlkaWwzQ2dSUzNFc0U0RjNBYWxHaEd0SGZXSG05cVRRZTBZUVBtNUIyenZK?=
 =?utf-8?B?ZnVvRCtMVXVHQTlyakNUMEVkTDhXTU1lclZMcnlwNmNkVVlZT081UUlNelNk?=
 =?utf-8?B?NlVyalRHeGFUd1Z4bnp4OFRobmNFNVZ6RHdSVHF4ZzY2RjF4Uno3QVFMamkr?=
 =?utf-8?B?YnBxNXN4VEJwN283K0N2d1dYNk44bS93ZFVHRkJwaWtGaEh0Q0pmclJ1WFZ6?=
 =?utf-8?B?U2VraEF6N0FNM1IySDUxNUtITmRBWGhhMldLUjhPaHQ3WWlRdEpDdG52eE5p?=
 =?utf-8?B?R3NwK0k3eXMvRlVzSDlLNldaWjJzQmV1cGJKWXVHSzV1RUx6L3U5Qy9lbkxj?=
 =?utf-8?B?VjNjSkRDYXRXWWZLY3Z0OXVqTEQrRitLQWF0aTIyN2U2bWZUNEY0aWN0eXlB?=
 =?utf-8?B?Z2praVB3THJiTXVmbHh5M3BMNzFlS01Ecm54QVY1VzZidFNsbVNiYTVxbjMy?=
 =?utf-8?B?RUQzT1hwL29pM3MvWTJyQnc2cHp5QkJYcWE2S3FkaVVVUms2b1ZDekhsNVNH?=
 =?utf-8?B?VnFKY1RLS1JxeWRtUmRVQXRscGt3V01jaHM1V1ZKck1XVlNVYytySDRkTjRW?=
 =?utf-8?B?VVNjVW9VeFA0RzNVK3ZJbnFXS1FHOEpNbUM1YmxiVURXVUJCR0YxREsxR3pl?=
 =?utf-8?B?aXZxMjFFRCs4RWdzNUFLOTZ2VE9jZ3pQS1Yyc1JGeEhHblRJUW85V0NEZWFP?=
 =?utf-8?B?ZzdRM3dSTmxqN28rWFZveDNoUG90dzdBOVVwelZsOGZ1MlFBaWpGbVJYa2JN?=
 =?utf-8?B?bFBkSVoxdDNUYXlnT0RjYmg4aDM3T1MwNTZqMk1tcjBhZkFzR1FiTjF2L0h6?=
 =?utf-8?B?VWR5Q3JoZGpEZGhxeFJlWUtSYU9nTVFTQ0V0Mnk1OWZkUERTZEM4aHJBdEc5?=
 =?utf-8?B?Qy9GVjZacGptbk5rc2o4aHhKK2gxM0JVWHVqa2g4clNiT1hwYklWKzNsbFd2?=
 =?utf-8?B?UVo0Y1gvKyt5Y2h6dG9UeUFIOWRjaUJDVER1UXZ0VTh5QlR0Tk1zQklIaG10?=
 =?utf-8?B?a2hJUkhGaTdFdm9OK1ZsRU1iS0lVVndidDhEL3BiOFVFUWVLN1kxRS8zaloy?=
 =?utf-8?B?eVRIamo4Z2VsSHZvS2V1b0pkYzRKdjBhSEsyYXRyZGN3SENaSVlHQnlGNnph?=
 =?utf-8?B?c2ZSOUQ2M3J0N2daUTVPWTZ1V0ZRckZDakxJMXZPdzQ5dmJyVzNwMmZwSUZ1?=
 =?utf-8?Q?GaS7BJOoKCZ6Hdkqc7nANwbA0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5815.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7df1be-b228-4ec6-ec69-08db3f2cd93e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 10:16:45.8610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uWg+/ajXuiV8KU4cRccymDW8WleyRF7k8K97bUhKzur4BN8SiWEfjhhfhUTW0cVXre/adJFP6y2JsYFgpSghGNXO/ATW/5byQ6O0+31aiMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6739
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

RnJvbTogTG9iYWtpbiwgQWxla3NhbmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4g
DQpTZW50OiBXZWRuZXNkYXksIEFwcmlsIDEyLCAyMDIzIDY6NDkgUE0NClRvOiBTb2tvbG93c2tp
LCBKYW4gPGphbi5zb2tvbG93c2tpQGludGVsLmNvbT4NCkNjOiBpbnRlbC13aXJlZC1sYW5AbGlz
dHMub3N1b3NsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPlN1YmplY3Q6IFJlOiBbSW50
ZWwtd2lyZWQtbGFuXSBbUEFUQ0ggbmV0IHYxXSBpY2U6IGZpeCB1bmRlcnNpemVkIHR4X2ZsYWdz
IGZpZWxkDQo+PkZyb206IEphbiBTb2tvbG93c2tpIDxqYW4uc29rb2xvd3NraUBpbnRlbC5jb20+
DQo+PkRhdGU6IFR1ZSwgMTEgQXByIDIwMjMgMDk6Mzc6MDcgKzAyMDANCj4NCj5QbGVhc2UgYWx3
YXlzIGFkZCBvcmlnaW5hbCBhdXRob3JzIHRvIENjcyB3aGVuIHlvdSBtb2RpZnkgc29tZSBjb2Rl
LiBJDQo+Zm91bmQgdGhpcyBtYWlsIG9ubHkgYnkgc2Nyb2xsaW5nIElXTCwgd2hpbGUgSSBzaG91
bGQndmUgZ290IGl0IGZyb20gdGhlDQo+c3RhcnQuDQo+DQo+KyBDYyBuZXRkZXYgKG5vIGlkZWEg
d2h5IHlvdSBkaWRuJ3QgZG8gdGhhdCkNCj4+IEFzIG5vdCBhbGwgSUNFX1RYX0ZMQUdTXyogZml0
IGluIGN1cnJlbnQgMTYtYml0IGxpbWl0ZWQNCj4+IHR4X2ZsYWdzIGZpZWxkLCBzb21lIGZsYWdz
IHdvdWxkIG5vdCBwcm9wZXJseSBhcHBseS4NCj4NCj5Db3VsZCB5b3UgZ2l2ZSBtb3JlIGRldGFp
bHMgaGVyZT8gV2l0aCB0aGUgYWN0dWFsIGRlZmluaXRpb25zIGFuZCBhbHNvDQo+aG93IGl0IHdh
cyBmb3VuZCBhbmQgd2hhdCdzIHRoZSByZWdyZXNzaW9uIGlzLg0KPkkgZm91bmQgdGhhdCB0aGVy
ZSdzIFZMQU4gdGFnIHdoaWNoIHVzZXMgdXBwZXIgMTYgYml0cyBvbmx5IGJ5IGJyb3dzaW5nDQo+
dGhlIGNvZGUsIHdoaWxlIEknZCBzYXkgeW91IHNob3VsZCd2ZSB3cml0dGVuIGl0IGhlcmUuDQoN
ClRoZSBkZWZpbml0aW9ucyBhcmUgSUNFX1RYX0ZMQUdTX1ZMQU5fKiBvbmVzLCBmb3IgZXhhbXBs
ZSBJQ0VfVFhfRkxBR1NfVkxBTl9NIHRoYXQgaXMgYQ0KMHhmZmZmMDAwMCBtYXNrLg0KDQpUaGUg
cmVncmVzc2lvbiBmb3VuZCB3YXMgd2l0aCBzb21lIHZsYW4gdHJhZmZpYyBubyBsb25nZXIgcGFz
c2luZyB0aHJvdWdoIGFmdGVyIGNvbW1pdCANCmFhMWQzZmFmNzFhNiAoImljZTogUm9idXN0aWZ5
IGNsZWFuaW5nL2NvbXBsZXRpbmcgWERQIFR4IGJ1ZmZlcnMiKQ0KDQo+PiANCj4+IEZpeCB0aGF0
IGJ5IHJlbW92aW5nIDE2IGJpdCBsaW1pdGF0aW9uLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBK
YW4gU29rb2xvd3NraSA8amFuLnNva29sb3dza2lAaW50ZWwuY29tPg0KPj4gRml4ZXM6IGFhMWQz
ZmFmNzFhNiAoImljZTogUm9idXN0aWZ5IGNsZWFuaW5nL2NvbXBsZXRpbmcgWERQIFR4IGJ1ZmZl
cnMiKQ0KPg0KPllvdXIgU29CIG11c3QgZ28gbGFzdCwgaS5lLiAiRml4ZXM6IiBzaG91bGQgYmUg
cGxhY2VkIGFib3ZlIGl0Lg0KPg0KPj4gLS0tDQo+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaWNlL2ljZV90eHJ4LmggfCAyICstDQo+PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9pY2UvaWNlX3R4cnguaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lj
ZS9pY2VfdHhyeC5oDQo+PiBpbmRleCBmZmYwZWZlMjgzNzMuLjQ2YzEwOGNjNTI4MyAxMDA2NDQN
Cj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfdHhyeC5oDQo+PiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3R4cnguaA0KPj4gQEAgLTE4
Myw3ICsxODMsNyBAQCBzdHJ1Y3QgaWNlX3R4X2J1ZiB7DQo+PiAgCQl1bnNpZ25lZCBpbnQgbnJf
ZnJhZ3M7CS8qIHVzZWQgZm9yIG1idWYgWERQICovDQo+PiAgCX07DQo+PiAgCXUzMiB0eXBlOjE2
OwkJCS8qICZpY2VfdHhfYnVmX3R5cGUgKi8NCj4+IC0JdTMyIHR4X2ZsYWdzOjE2Ow0KPj4gKwl1
MzIgdHhfZmxhZ3M7DQo+DQo+UGxlYXNlIGFsd2F5cyBwcm92aWRlIHBhaG9sZSBvdXRwdXQgd2hl
biB5b3UgY2hhbmdlIGZpZWxkcw0KPnNpemUvc3RydWN0dXJlLiBIZXJlIHlvdSBjcmVhdGUgYSAx
Ni1iaXQgaG9sZSBhbmQgaW5jcmVhc2Ugc3RydWN0dXJlDQo+c2l6ZSB3aXRoIG5vIG1lbnRpb25p
bmcuDQoNCk9rLCB3aWxsIGRvIHRoYXQuIA0KDQo+SSB3b3VsZG4ndCBzYXkgdGhlIGZpeCBpcyBv
cHRpbWFsLiBGcm9tIHdoYXQgSSBzZWUsIHdlIGhhdmUgc3VjaCBmbGFncw0KPihjb3JyZWN0IG1l
IGlmIEknbSB3cm9uZyk6DQo+DQo+VFNPCQkJQklUKDApDQo+W2JpdHMgMS03IGFyZSB1c2VkXQ0K
Pk9VVEVSX1NJTkdMRV9WTEFOCUJJVCg4KQ0KPltiaXRzIDktMTUgYXJlIFVOdXNlZF0NCj5WTEFO
X1MgKHNoaWZ0KQkJMTYNCj5bYml0cyAxNi0zMSBhcmUgdXNlZCBmb3IgVkxBTiB0YWddDQo+DQo+
U28geW91IGhhdmUgNyBmcmVlIGJpdHMgdG8gcmV1c2UgZm9yICZpY2VfdHhfYnVmX3R5cGUsIGJ1
dCB5b3UganVzdA0KPnJlc3RvcmVkIHRoZSBiZWZvcmUtY29tbWl0IDo6dHhfZmxhZ3Mgc2l6ZSA9
XA0KPkkgd291bGQgZG8gdGhlIGZvbGxvd2luZzoNCj4NCj4JdTMyIHR4X2ZsYWdzOjEyOw0KPgl1
MzIgdHlwZTo0Ow0KPgl1MzIgdmlkOjE2Ow0KDQpPaywgd2lsbCB0cnkgdG8gcmVmYWN0b3IgaXQg
aW4gdGhpcyB3YXkgYW5kIHNlZSB3aGV0aGVyIGl0J2xsIHdvcmsuDQoNCj4qIG5vIHN0cnVjdHVy
ZSBzaXplIGNoYW5nZSAoZXZlbiBubyBsYXlvdXQgY2hhbmdlKTsNCj4qIDo6dHlwZSByYW5nZSBp
cyAwLTE1IC0tIG1vcmUgdGhhbiBlbm91Z2gsIGFzIHRoZSBsYXN0ICZpY2VfdHhfYnVmX3R5cGUN
Cj4gIHZhbHVlIGlzIDY7DQo+KiA6OnR4X2ZsYWdzIHN0aWxsIGhhcyAzIGZyZWUgYml0cyBsZWZ0
ICg5LCAxMCwgYW5kIDExKTsNCj4qIDo6dmlkIG1ha2VzIGl0IGVhc2llciB0byBzZXQgYSBWTEFO
IHRhZyAobm8gZXhwbGljaXQgbWFza2luZy1zaGlmdGluZywNCj4gIGp1c3QgZG9uJ3QgZm9yZ2V0
IHRvIGFkanVzdCB0aGUgcGxhY2VzIHdoZXJlICVJQ0VfVFhfVkxBTl97TSxTfSBhcmUNCj4gIHVz
ZWQpLg0KPg0KPkRvbid0IGp1c3QgdXNlICJmaXJzdCB0aGF0IHdvcmtzIiBhcHByb2FjaCA9XA0K
Pg0KPj4gIAlERUZJTkVfRE1BX1VOTUFQX0xFTihsZW4pOw0KPj4gIAlERUZJTkVfRE1BX1VOTUFQ
X0FERFIoZG1hKTsNCj4+ICB9Ow0KPg0KPlRoYW5rcywNCj5PbGVrDQo=
