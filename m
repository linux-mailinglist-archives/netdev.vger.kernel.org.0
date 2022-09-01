Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB535A9E8A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 20:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbiIASAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 14:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbiIAR77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 13:59:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102A4632A
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 10:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662055195; x=1693591195;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mMnQ35zR8omn2YCS70NMPydNpUr3gdLoUQjukEZBe7A=;
  b=iZgygDh349mt6AFCMEj+W8eaHM/0agvMCSJshJwUqUkZeiuOPmy73hoQ
   RLB/q6vk7rqKzw30BgY4Q9UzPVEsQL/b6b+QHCmnpZe9J1UuBYtZCHd77
   jkAn6imzI5yQ3Ihea3dOR97kVCqRnUtladYrDU08msUFzm/W6XaGWevab
   tJ6sOXn+sLoHFLiJvUV13IJryEmJOWX++dQbRhkUdDoysWutDQSVIYyYK
   bkWFOC2zf9U0N/Mzdt0ZUC1J/C48INnNZ9WC8/o+kCWfPZo9RiJItq4Qv
   Hg0Kw1iDLZmf4PRAEIfkXIGhr3BfHVNJQjeXVYhEFXBQkZ76V5Be4yZEy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="295796681"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="295796681"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 10:59:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608640608"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 01 Sep 2022 10:59:55 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 10:59:55 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 10:59:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 10:59:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 10:59:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QF4igar5CVqhFHZFGuq+lj4jTriuGOi4vD7PayaSDlGUn35Z5dr7D792K+cS7OeK2pUXevsrKg/Qm05XIdUWa3ttordZZqeDVjtEMtMEuUsMSrd96h+IlugMEy35jeK03KY8H2+lpfeABAcxNTZT2GSS6QHSX1Gh8JabY73w4eD3CHXyaxcH4FwLVZMHExPuKoEoOsOUN6yoGMUrcMIgy8UaEO6WFINLVpReltWf0Kt77WVtkO2d8dKG28nnv+d4wuedbmfcx6F/QSPmvbh/TQCS7NudvuS571spdLOeC8pScfq9C+LcB21UiupWEkhhzNgFx27yfQnjd3IE42MJFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMnQ35zR8omn2YCS70NMPydNpUr3gdLoUQjukEZBe7A=;
 b=BwSFF71SVE8KWikNA2qUeLHJvJO6bJW5rJOiIY65vsrcm2TVNoOG2u+URpbYN7IpRnVKIARPVFfGRs0ISW+/f1M2kn3rAsug6Aivjz3FS+Z3vgfpYOGPYd57hBFL1OAeUENPAR2VZGrv5vrOs1C2y7drDgtrj9QOY5Pum15uF0nKsgr43tHWgyOEaPx9T0XIA/pn07h8okGUxmHNoE+wBo70tI8IL4gZftHXh2sTsSbJz9x752ZzAnfVJSgt7hWT6VXSv8R0NzAQvhj37WG3+79LDFKkn0KW/QRSo9jYm8KBq/Dc2Om+EjWtV9ypJybtlKSBFtWzzh76UWBi6J2UGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5172.namprd11.prod.outlook.com (2603:10b6:303:6c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 17:59:53 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::295a:f0fd:ffeb:2115]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::295a:f0fd:ffeb:2115%4]) with mapi id 15.20.5588.011; Thu, 1 Sep 2022
 17:59:53 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: RE: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Topic: [PATCH net-next 0/2] ice: support FEC automatic disable
Thread-Index: AQHYtwG+vEC+zxF9EUaLIV60VfCCNK2+DsqAgABCJ9CAAOPjgIAAnPyAgAAHflCAAAlpgIAAAyXwgAAwQYCAAEQfAIAABmWAgAEaQoCAAGY2gIACRriAgAFU34CAAEhLgP///PSAgAIo1ACAABqwgIAA3n0AgAAlZoCAAXsdgIAAZWFw
Date:   Thu, 1 Sep 2022 17:59:53 +0000
Message-ID: <CO1PR11MB5089F9D77077B9EF91FA77D8D67B9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
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
 <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
 <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
 <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
 <26384052-86fa-dc29-51d8-f154a0a71561@intel.com>
 <20220830144451.64fb8ea8@kernel.org>
 <923e103e-b770-163b-f8b6-ff57305f8811@nvidia.com>
 <25286acf-a633-8b1e-95c1-9e3a93cd79ea@intel.com>
 <e1d57b80-2e62-8799-ce36-bb944ea85ed9@nvidia.com>
In-Reply-To: <e1d57b80-2e62-8799-ce36-bb944ea85ed9@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7874f0c9-2d1e-4af7-5024-08da8c43c58c
x-ms-traffictypediagnostic: CO1PR11MB5172:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1pDQcLpLkz47NYCOAdW8WhpVXvORNLz/zn3wXk63ucGSdtYX8XTeXjf4Ch2/FmGZiYitnqtAgz68ji205bXcZFDDwOXrL9n5efz2iripjxzs2MzlMgGLpjvlfL4zNEMqEs1cnGEaRO3a999Z5PMyJxcvj/nJcgbRXUeb2qOZ2LP+SwS8y5FIvMiqpYIYgaqYUO8LO4JrgiqdiLz3cT0+obVrVsS0iUlFIcYVYzA7VsxEQktK9Ta+VO2ya3awMKYbCglYnaX7eAUsUdnwjezB39TRwbTFxCtVrrkCggEUswuzSjls9gXIReZzp0+K+JRrYEizGAEfpQqm7VXRTxT0XDUY0URBfpNFS6vc2fAHGpD9irWIOsQ2Kl5hYLnsFlPxCAcGC46Qz+Ly/gaQgbQS7T3xxkvnKKfTwaiRGI1WACx1szB7PjgHZWKzy5f7i/PBxQ0Tg6nuRHJtjQSrmfSHAWHDFZdwXuApi4T3fyurmaSncnLh/Ez0lxQpU7vfI330s8V9fecUgw9hDf/c0jYRbi1j6+5MsMTq99X5iOXK0jp0uv02P5sEm9UP9ycoRHzEbj16WGJBYXRkxTwbelqXICVJwTjiGGmggtxK1AzDvs93F2rltUeOdXHWAy369A1PdSPgXSSf02iBROh5oiLe9EEWqiAn2AFAKUHGn2xL/H/mTJQgclLuxpTS9/C/oCCrxoFecQtHAdQvf5i7wTJjDOQVOkfy+hNfDh8bOFJzDBSddrnqvmevP7QUBjkx5vpMyLrP33utCdoSdunHxRLP0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(396003)(366004)(346002)(136003)(33656002)(86362001)(2906002)(66446008)(64756008)(66946007)(66556008)(66476007)(4326008)(76116006)(316002)(8676002)(82960400001)(38070700005)(110136005)(54906003)(7696005)(6506007)(186003)(53546011)(5660300002)(9686003)(83380400001)(122000001)(52536014)(71200400001)(478600001)(38100700002)(8936002)(26005)(41300700001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1dMQTF4ZmtodVpsTXJlWEJXQ1p5MmJJTmtLcmJPM1Rocldzb3ZPNVEwUkg4?=
 =?utf-8?B?MHBOU0g3b1N1OGpmSllyczA0Mmc5YUVXT29ObW5hR3UvVDg0R0V0ZllmbGU4?=
 =?utf-8?B?N0Y3UU1tajdvRFBDUDFQYVk5WnhGb0JHODBUQ0l3QjlleGdoYUlXeGJMcEVp?=
 =?utf-8?B?QlhsTGVWNUNGYVlmYjBwWHZTZDFhbkE1cE4zVHI0cU03TVIzV1FDTzhzanA1?=
 =?utf-8?B?NGNIU1kvSTZ1d3BCSG40OTUybDVsMzNJYzBQZUFuNzhJVm56MUg2aUc4eUhk?=
 =?utf-8?B?K0tJRTBEWDJwb0cxbTBCMDhGakVIamFucGkxVjFCekViZ3VsS29iYTdrSTNw?=
 =?utf-8?B?VGtObUQvaUVkNTFqWTdKcWtQZzlIUGsxWUtPdzE1cENQc25ydVJtc0xOMFE3?=
 =?utf-8?B?T0dzVDR5bDFRaFZ4VVV5Mkdqenp5d1ZQcmpwSGhoV081UldoZC9oMWdGM08z?=
 =?utf-8?B?Q1dWaHhmcFpCZ1Q5UHFVTTExNFE2SDR6ckFTVjJQazVubHE5eXYyOVFnSnJm?=
 =?utf-8?B?Ri9obVl3L29XSHBxYVBuMkJjT1RQY29PMFdsNzd4cnl5Rm5PeGJ5a3BkTHdi?=
 =?utf-8?B?MUtjcUtwUmx3Y1pPRy96L05MWWFabjJoNXNBbGJsNXNoV3RQN1kweXpJdVRC?=
 =?utf-8?B?UGQ5cDJiSFhoZTk1bjEwVUNuZW1CNWNkakRxUW5GS2F3Q1htMGVHejg5T1dI?=
 =?utf-8?B?TW81bWdxa1pMSTFRRU1xZkFOTS9JbVR4MmEyVWhxKzRBTy9zSWNtaXFLaWli?=
 =?utf-8?B?OWdFdHAyTWdSK2JhWldSY2tvWjdYUFJUYktJYWw1cVRpalI5b3dBUVpaN1Iz?=
 =?utf-8?B?bFY1c2N4RWg5ZzU0aUFQb0ZFdXYwdWdiN2puS1MyYTJCbkExNzkwdFpHZTVx?=
 =?utf-8?B?WmY4djR0NldPVWhaRE1jQ2kxNkhvTURpT3NFMk1YOUVsbXJacGttczF3d3gz?=
 =?utf-8?B?Y29DTHo4Ymw3M0NlWFpzR0t5bklZcHdJTjladFJvR0hDc1drOVE2RGZTMjFT?=
 =?utf-8?B?M2pOeHh1SzZjL2hHSnFtb2U5aWJKRU9LT2dXQTRiU1lIeFpSWTY0bThzczVv?=
 =?utf-8?B?T21jUVg5Z2djSXhpVUFjREpCRTZNL0ZrcmYrRlJ2ZDg4bnliYkRBeDVTNG9S?=
 =?utf-8?B?Vk9KL3NDN0x1dnllejluTnVCRWV0R0o2ZG1Vb0FVMmZQa3RHaEROd0xCdHIw?=
 =?utf-8?B?SWg3TDFFNnY3K3ptU0ZsaTdmem50QVp2Zk1JUGl4anBibjl4c3lpVzd3dDg1?=
 =?utf-8?B?THNoQlpYR0xIWlJnZjdqL0txVFpJaGdzWFFJazUybnptNVRNMkZjQTFZeXM1?=
 =?utf-8?B?MW15YWh0UGp5R0QvbGRmRXFoSkdreVRyeGFUY0cvcTc5aU5rNHpFL2FnbFY0?=
 =?utf-8?B?enhzZElrdmFSYTdWQXhKWGtTVGpVWTRzMHZHSXV0Y2tWRnZHaFFDK3JhK2Qy?=
 =?utf-8?B?SGZXRzRvazJXVzdGWVB3ZnB4cDNtcm5xenBsQUExaG5jd3FncGhtL00weUJj?=
 =?utf-8?B?Q2JBTExUbEoyVUk0cUoybzhOYjBkeUw3eXdpWTNEZmk0azdlNWQ1V2FBZGl4?=
 =?utf-8?B?K0lXRnBqYXovN1lzREptTzN5TitMa3hjbkkyRXNCbjJPbFJTL1V2bmYvdE9C?=
 =?utf-8?B?OWFNNTUwZHBxWFVVeml0TnpUUk5PRDBwdU1meG9QRkFrUkRLMnJHWVBVZzVw?=
 =?utf-8?B?akdjZHZyU3Y2N2lISXZ6d0NHcVR4cE5FR05kVDF6RFhYcDMwb0tZZzBHWjdx?=
 =?utf-8?B?NEZ4U0ZQL09iQkhPRVVMSUtHUVV5UVB5S1FwMkErdmdyVnd4VW92MGZxYzhk?=
 =?utf-8?B?eGFYWmRvVWFjUzBkK2dFTkxRUm1GVmo3ZmY1Y1VmNWFjOXBKWWdyeStmZnQx?=
 =?utf-8?B?M1laemRtTkpxb3JkdDN6OGVJMkl4STc1MzdhOSs1Y0JjRTc4cmNIcUJyUldj?=
 =?utf-8?B?RFQxV3NzR2MwcmFKbnlFWWRzZ0FIcXNEc2Zldmh1VExyOWJJb1FmTXFSYTJQ?=
 =?utf-8?B?SitrREx4T1I3cVVzcEhrUmo4dkh0Y1h3QnllSm1lTFYvNTdVV2V0MTEyYlBO?=
 =?utf-8?B?SmFWcGdjY2t4QXNUbXZVSDRvUGlrbnc2THVFR05vcG5FM2lUdVY2TTMyRk1O?=
 =?utf-8?Q?ydgpIRO+nE8Iige9EemhK1byV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7874f0c9-2d1e-4af7-5024-08da8c43c58c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 17:59:53.0726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p0xknHfq9CPc8A9s5J6S1c2uPCwaFYU872EJ2d8DfrABv++36/xOvKk62BJAxcFDRoyJap/nB7XZ20pgAHes4j7khRlISOfGWnWNeoy/FvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5172
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR2FsIFByZXNzbWFuIDxn
YWxAbnZpZGlhLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAwMSwgMjAyMiA0OjUy
IEFNDQo+IFRvOiBLZWxsZXIsIEphY29iIEUgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT47IEph
a3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IENjOiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRtQG52aWRpYS5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBTaW1vbg0KPiBIb3JtYW4g
PGhvcm1zQHZlcmdlLm5ldC5hdT47IEFuZHkgR29zcG9kYXJlayA8YW5keUBncmV5aG91c2UubmV0
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDAvMl0gaWNlOiBzdXBwb3J0IEZFQyBh
dXRvbWF0aWMgZGlzYWJsZQ0KPiANCj4gT24gMzEvMDgvMjAyMiAyMzoxNSwgSmFjb2IgS2VsbGVy
IHdyb3RlOg0KPiA+IE9uIDgvMzEvMjAyMiA0OjAxIEFNLCBHYWwgUHJlc3NtYW4gd3JvdGU6DQo+
ID4+IFdoZW4gYXV0b25lZyBpcyBkaXNhYmxlZCAoYW5kIGF1dG8gZmVjIGVuYWJsZWQpLCB0aGUg
ZmlybXdhcmUgY2hvb3Nlcw0KPiA+PiBvbmUgb2YgdGhlIHN1cHBvcnRlZCBtb2RlcyBhY2NvcmRp
bmcgdG8gdGhlIHNwZWMuIEFzIGZhciBhcyBJDQo+ID4+IHVuZGVyc3RhbmQsIGl0IGRvZXNuJ3Qg
dHJ5IGFueXRoaW5nLCBqdXN0IHBpY2tzIGEgc3VwcG9ydGVkIG1vZGUuDQo+ID4+DQo+ID4gVGhp
cyBpcyBob3cgaWNlIHdvcmtzIGlmIHdlIGRvbid0IHNldCB0aGUgSUNFX0FRQ19QSFlfRU5fRkVD
X0FVVE8gZmxhZw0KPiA+IHdoZW4gY29uZmlndXJpbmcgb3VyIGZpcm13YXJlLg0KPiANCj4gSWYg
YXV0byBmZWMgaXMgb2ZmLCB3aGF0ZXZlciBtb2RlIHRoZSB1c2VyIGNob3NlIGV4cGxpY2l0bHkg
c2hvdWxkIGJlIHVzZWQuDQo+IFdoYXQgSSdtIHJlZmVycmluZyB0byBpcyB3aGVuIGF1dG8gZmVj
IGlzIG9uLCB0aGVuIG91ciBmaXJtd2FyZSBwaWNrcw0KPiBvbmUgb2YgdGhlIHNwZWMgbW9kZXMg
aXQgc2VlcyBmaXQgKGFjY29yZGluZyB0byBzcGVjKS4NCg0KQ29ycmVjdC4gSSdtIHJlZmVycmlu
ZyB0byBhIGZpcndhbXJlIGJpdCB3ZSBzZXQsIG5vdCB0aGUgRVRIVE9PTF9GRUNfQVVUTyBoZXJl
LiBTb3JyeSBmb3IgdGhlIGNvbmZ1c2lvbiwgdGhlIG5hbWVzIGFyZSBzaW1pbGFyIGJ1dCBub3Qg
c3RyaWN0bHkgcmVsYXRlZC4gVGhhdCBpcyBkZWZpbml0ZWx5IGEgcG9pbnQgb2YgY29uZnVzaW9u
IGhlcmUgOigNCg0KQ3VycmVudGx5LCB3aGVuIEVUSFRPT0xfRkVDX0FVVE8gaXMgIHNldCwgd2Ug
YWx3YXlzIHNldCBJQ0VfQVFDX1BIWV9FTl9GRUNfQVVUTywgYnV0IGlmIHdlIG9wdGVkIG5vdCB0
byBkbyB0aGF0LCB0aGVuIHdlIHdvdWxkIGhhdmUgc2ltaWxhciBiZWhhdmlvciB0byB3aGF0IHlv
dSBkZXNjcmliZS4NCg0KV2Ugd291bGQgY2hvb3NlIGEgc2luZ2xlIEZFQyBtb2RlIHRvIHRyeSBm
b3IgdGhlIHZhcmlvdXMgbWVkaWEgdHlwZXMgdGhhdCBnZXQgdHJpZWQuIFdlIHN0aWxsIHBlcmZv
cm0gdGhlIGxpbmsgc3RhdGUgbWFjaGluZSwgYnV0IHdpdGggZmV3ZXIgRkVDIG9wdGlvbnMgYW5k
IG5vbmUgb2YgdGhlbSBvdXRzaWRlIHNwZWMuIFdlIGRvbid0IGN1cnJlbnRseSBoYXZlIGEgZHJp
dmVyIGltcGxlbWVudGVkIHRoaXMgd2F5Lg0KDQo+IA0KPiA+PiBUaGlzIHdob2xlIHRoaW5nIHJl
dm9sdmVzIGFyb3VuZCBjdXN0b21lcnMgd2hvIGRvbid0IHVzZSBhdXRvDQo+ID4+IG5lZ290aWF0
aW9uLCBidXQgaXQgc291bmRzIGxpa2UgaWNlIGlzIHN0aWxsIHRyeWluZyB0byBkbyBhdXRvDQo+
ID4+IG5lZ290aWF0aW9uIGZvciBmZWMgdW5kZXIgdGhlIGhvb2QuDQo+ID4gSXQncyBub3QgcmVh
bGx5IGF1dG8gbmVnb3RpYXRpb24gYXMgaXQgaXMgbW9yZSBsaWtlIGF1dG8tcmV0cnksIGl0cyBh
DQo+ID4gc2ltcGxlIHN0YXRlIG1hY2hpbmUgdGhhdCBpdGVyYXRlcyB0aHJvdWdoIGEgc2VyaWVz
IG9mIHBvc3NpYmxlDQo+ID4gY29uZmlndXJhdGlvbnMuIFRoZSBnb2FsIGJlaW5nIHRvIHJlZHVj
ZSBjb2duaXRpdmUgYnVyZGVuIG9uIHVzZXJzIGFuZA0KPiA+IGp1c3QgdHJ5IHRvIGVzdGFibGlz
aCBsaW5rLg0KPiANCj4gQ29nbml0aXZlIGJ1cmRlbiBjYW4gYmUgcmVkdWNlZCBieSB1c2luZyBh
dXRvIG5lZ290aWF0aW9uPw0KDQpJJ20gbm90IHN1cmUgd2hhdCBzaXR1YXRpb25zIHJlc3VsdCBp
biBhdXRvbmVnb3RpYXRpb24gdnMgd2hlbiB3ZSBoYXZlIGl0IGRpc2FibGVkLiBGb3IgZXhhbXBs
ZSwgaWYgYXV0b25lZ290aWF0aW9uIGZhaWxzIHdlIHRoZW4gdGhlIGxpbmsgc3RhdGUgbWFjaGlu
ZSBmYWxscyBiYWNrIHRvIHRoZSBzZXJpZXMgb2YgZm9yY2VkIGNvbmZpZ3VyYXRpb25zIGl0IHRy
aWVzLg0KDQpUaGUgYXV0byBzZWxlY3Rpb24gbWFrZXMgdGhlIGRldmljZSBhdHRlbXB0IHRvIGdl
dCBsaW5rLCBhbmQgYnkgZW5hYmxpbmcgbW9yZSBtb2RlcyB3ZSBhcmUgbW9yZSBsaWtlbHkgdG8g
YWNoaWV2ZSBsaW5rLiBCeSBoYXZpbmcgdGhpcyBoYXBwZW4gd2l0aG91dCBuZWVkIGZvciBzaWdu
aWZpY2FudCB1c2VyIGludGVyYWN0aW9uIG1lYW5zIHRoYXQgdXNlcnMgc2ltcGx5IHNlZSB0aGUg
ZGV2aWNlIGxpbmsgdXAgYW5kIGZ1bmN0aW9uIHdpdGhvdXQgdGhlIG5lZWQgdG8gbWFrZSBhIGNo
b2ljZS4NCg0KVGhhbmtzLA0KSmFrZQ0K
