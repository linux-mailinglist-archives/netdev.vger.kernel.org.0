Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC4F57591E
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 03:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241018AbiGOBal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 21:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiGOBaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 21:30:39 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3F65B799
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 18:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657848639; x=1689384639;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=OuOdq9tgplIJyEGDPKylaeJTbyOvTuaNKsWGbCMgVN4=;
  b=HU4W/LBhL8z+Upol1jTEVpMyfB9/H8GCQOqYESd1CwXDc4u8iRac8i/G
   IlgbYKSnjE4v4fnWYHO7BhtxUJzoiypsI9BRNY8wCkBAJEzi9DfUSpr5q
   8/fgu3jqLhnSMz1UhiH4EEHNd5aZ9bTRgcMQ6XgelFRGZlfA8smED0Hke
   ATOzgmsLP9CgPW4OSYUaodQxOjvdMLR4BefNRz6xzG+NT7yzAaYldsEwe
   v2fCDCuyiZcY5nsrENsGPxbnnV99tqMt8mQPzfXuE9/XlBMvqchYjq951
   Q/3FVzgv2RHM18WocJ7/CV8yrYApnYFBglO8LzKp0K8p8dkAP5T6uD2e8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="284431721"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="284431721"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 18:30:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="571326713"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2022 18:30:38 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 18:30:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Jul 2022 18:30:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Jul 2022 18:30:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHKoodHrGsfEE0zFldWHFIkdxexFPRrTm3b11SmP9vPWvwq5fC7EFig5Kx03nU0EEGgBLHr0Yac/hvHCQCFNMOHKC7bjXvNyBEjDdu5totYId+wwLpWgf1G6CjG0WYag5U8V2+SA3Ab2yGfWGOtrR4Ux9G5VQWd3YcOwGkwrMX3IqPXZTTRYFmelqsvv4orJ5/jmvZHe3fM0f3522gx6zCCgDj9tMRroohbltht1UY1XxzCya3eSKb6HXGqg9v8EysvPiDisJSgxDJfD3+BOmB0+4EwhoxxGhiVP3f/za/KQUkkes4PnLRUveICfctXiFADFBqs2XRyDe+C/5nBUbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OuOdq9tgplIJyEGDPKylaeJTbyOvTuaNKsWGbCMgVN4=;
 b=a+CZkdyp4A+c7Ru/djTIq6tvj1O4BGZ07d5flhfgpHPcxmodlVS/5YrBh8fFbMIYTQ32PzIZ33yIb/hsdnLnAbbGmKe9Mkh3qZ0IGDv1jgN/mY3cLQ8lrk56BZG5geMbMFUig5+Nl5bBR16mBVH9UQSHTF6fMR9QFLuWBhowkspHRc5zk9DfDaCXZZuF0kfRCF/1XLklUMfleKWDV6YXHOfjD46sdOyQNij/Kb1Ljwkwb8g+5xSz5mUWG5Um2qe81bNK3D6PLtjA1KFRnMhWdw6M1WOt0YQH3FDJ7mGY4VWWmtkF0yUEMiSVPhBDOw6KH0tk0BBve+QiL4DkkfkC2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5370.namprd11.prod.outlook.com (2603:10b6:408:11b::8)
 by PH8PR11MB6778.namprd11.prod.outlook.com (2603:10b6:510:1c9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 01:30:37 +0000
Received: from BN9PR11MB5370.namprd11.prod.outlook.com
 ([fe80::bc2f:626b:4d64:616b]) by BN9PR11MB5370.namprd11.prod.outlook.com
 ([fe80::bc2f:626b:4d64:616b%5]) with mapi id 15.20.5438.013; Fri, 15 Jul 2022
 01:30:36 +0000
From:   "Chang, Junxiao" <junxiao.chang@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/2] net: stmmac: remove duplicate dma queue channel
 macros
Thread-Topic: [PATCH 2/2] net: stmmac: remove duplicate dma queue channel
 macros
Thread-Index: AQHYlpaKcSrzMb6RTUi/FMvY2goSeK19p0sAgAD+1cA=
Date:   Fri, 15 Jul 2022 01:30:36 +0000
Message-ID: <BN9PR11MB537070A29526C1DB55F35942EC8B9@BN9PR11MB5370.namprd11.prod.outlook.com>
References: <20220713084728.1311465-1-junxiao.chang@intel.com>
         <20220713084728.1311465-2-junxiao.chang@intel.com>
 <267f466722ed63a2ba9abd74c31a9fab57965e4a.camel@redhat.com>
In-Reply-To: <267f466722ed63a2ba9abd74c31a9fab57965e4a.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2900dd6a-a769-49e8-8f39-08da66019ea0
x-ms-traffictypediagnostic: PH8PR11MB6778:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VUdtzeW9CrFH5SKG1o3Cv3vkMnu7BF8qR93jtqIPMUlnWmxgjoVIvXAzJWomyfibcntnpwZUXW60RIwCpkF2RZN0FvWxgdlRUoLgerLr01fVrWscyXnkXSbRrFSUfyP37q9KJEPHKwnMDiFiwzOxkCTVqnEKodFYYCgbvAarGlp6uAL5vwqeu/adH7VT95ZDOp/xkFZps/M5URz1QXJnZJo+yqzbZuHSZeXLSL7klpa16ewRvMlSa8RY/nHRqp7osFlvTlJtUGnny1lMAjVMway1ALMZSN4aYLhDw+W/mB8B1Kgb+tP2CuckiDx6H4dilDfRvdHprwoThSz7me1QSmUlF1ow6+g+AsncPyDeXrmGCCfFPXso0pXZr96lRecDpu8uOiQfrRhT4Lru4SSpZNeBorKFte87v9StLm76rYl0IMM6ZDKY2/X7Hg5FRfxVOEf7/7JlaUHgzEQo301nyUaP7KRSqAWEBuTlypEBTVNcya2nL30OPuAlqD375zkQeAftp/TtTyZqezh0pWxEu3V1YKe7XUM4EIvqGRre+2iR/lOtpfZMoR/Yo5Tl5UgNSfWWTBkCdb429s0B3t/gUblodjA/gz+rAQpTTpgpjArUoWVAx7qAOirrruQTWPRjIL9cEa1Wu7QGLtP3ayRcmpnPkDwpKRedrMmBNn8Yc9Vq725SiAZOh3/sna1IV4f4ubK+0Ru/EQlZPbLUge7xUPVD3mzhqYHlrA80TeS0yGfnLLsM2QwnHjqf5mJoiy87v/6gF4kwSQmnUlrlbYyq1tn86LQWvGnwojgsl8RLwM09tYKfJhIpWTshyBh8ASk5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(396003)(376002)(366004)(83380400001)(52536014)(122000001)(316002)(55016003)(86362001)(8936002)(2906002)(110136005)(478600001)(186003)(66946007)(66446008)(8676002)(38070700005)(64756008)(71200400001)(5660300002)(66556008)(66476007)(76116006)(33656002)(82960400001)(53546011)(26005)(7696005)(41300700001)(6506007)(38100700002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnpIV0VxTGdyNVViV1EzTFRCLyt6NVpWRXdUeE5qL0Q3WWkrM1FGWk1qTWl0?=
 =?utf-8?B?RDJTUGFCUnFqWjI4TzlJT0VIMjBsNXU2ODZSSjdsamg3NGJJdit6RDl1R3Bj?=
 =?utf-8?B?ZUlIdnhYQkkrZ1RPYUczSHJXMDBjdTJ5NE8vSXcyajZlOGM0WVhHUGs4QS9l?=
 =?utf-8?B?VUpnQW8rRmV2YVEzb054YjZPWkVTSnVWZUdUTWcwRFk2c2JMZ2Uzcll4amQ2?=
 =?utf-8?B?Q0Q5eGtQSlNkV1lDYUFZZHdjWWplNzNuTXdVci80cWtwSyt1Tk9hMk81Wmxp?=
 =?utf-8?B?MkNQS1VOSGVXTUMzUmFFU2RpdHZVT21GNE42Tk5nSWZXWnh1RGhXTFFyNmV2?=
 =?utf-8?B?NVB4bUVYa3hZaUhBWkVHWnNtRDI2RHhxOW9GUW9QTGtCdkZ6R1dGQjBzalJT?=
 =?utf-8?B?VXczSjlyaTRtNk9BZVBVWjZoaW9QNmVWZ3k5MlBBelRFdS9vejJGZ3ZtS2Zj?=
 =?utf-8?B?TVhVQ2RmNnVTOVVaazl3SVRNOWZKV2dSWG02eHdaNHhvcW9ybkJNYktXSVo0?=
 =?utf-8?B?T2xVYmlUVFVhd21jUmhPak1paHc0bWMyTkVyS0lVYitBcDhFSWFwYmZYZk1B?=
 =?utf-8?B?UUFOMm9nUGlxSUdJZ1VlOUoyb0pYSlVZcXBaTUgzVmVMd091RTJwWkNsNkx4?=
 =?utf-8?B?cUtWa05iTWFHajg0WFMreXYyUlRieWIvZk5OTnhreXhmZjlScDgwU0s2aEpv?=
 =?utf-8?B?VHI5SUxXbTZIbmNaYlBGME5PY21xSU83RHRMOW12VkZXRk9pYmoxdzdwcVBF?=
 =?utf-8?B?dXRXSExpMC9wUFJjMWRGVEZaNFd1Q3VQQmtzekh3ZDIrYjBrTjdlRjFHME5U?=
 =?utf-8?B?em9nR0NuTkJab3dnalZINzhyU3ZRcEFFWDdLVDZtRWFkdGtjYmNzZTNtT2t2?=
 =?utf-8?B?ekMxdSs2YUZSQ3ZNdnRYTjNYZFF3N2hzMjJ0a0hyUVBlOXhoMWxWT2RoWWNT?=
 =?utf-8?B?TUU1L1BtYlMvbGIzQ3IxaTNGVTh5UTZCc0JQR3AzSXdXeGtnd2h0YU1vMmVp?=
 =?utf-8?B?QkpuUGNiL214WXdlRlRuRkZ2eEhtS1NnRkVjNnRhdDJDbGpqQktTaUl0cjAz?=
 =?utf-8?B?RG16bUZWR1FDMGFHUDQ0QzJjZkNhUjY0dyt5U080c1I2aHYwZkpWQXlqcnB5?=
 =?utf-8?B?Mm1HT3pXOU9FcVpOUHU2RzNTU3QzRTJxUlRpNGxLa2lpOEpXL3lqNmliK1Yw?=
 =?utf-8?B?d3liczlpY0J4ZkZ5UjVFc1d3dWdoOEJrUXZMR3pzUExHSyt3LzcwOTR3bU91?=
 =?utf-8?B?VzBXU1pZeE5PMkF3clZwN3RITXhBSkt4MXJPVlF2a1IvN0VTYUp2M2VUQVpD?=
 =?utf-8?B?a0wzMHhucnMveDFQRkx3ZTFQMkF4NkY5dXcwU2QzaDl0ZGM2aUdta3B2ZFpm?=
 =?utf-8?B?d2I2dkdOUmpxV1F2d05kQTQ3RUtIVXdKTTR4K0NBZDB0TlpXeEE2NVIrUzQv?=
 =?utf-8?B?RXhiS1c5QXROK0FFbGxxVExXcW9vZURFeEpma2tFRzBDVHR1bVhhSURVSWp5?=
 =?utf-8?B?ZU5NYWdVNkt0RXQ5eW9xVW5RV1RzVmdHYThHdlpyZm1COTVxdGZ1SERCd0lK?=
 =?utf-8?B?aWNrSHp5RUpLSGdzTnQrRGJGbjNqb1JWZ0I5SEFSUGdPKzg5L1VMM3hWQURT?=
 =?utf-8?B?c3ZIdXZ3QWoya0E0TG5kSm1IdjJxN09LY2RWWk1ZVkZDYzhuNDhSRHpVNm41?=
 =?utf-8?B?Zk1ZLzJibzR0RXRaSVAyMXliUThFbmZoZXJjT3JmTzMvUGJObGcxWU5ZdGE1?=
 =?utf-8?B?NnlvdGZCMS9wSEo4aXFTcTdncGJ2OVlINE5UU1pudi90ZnA3UlNtZUVpUzJX?=
 =?utf-8?B?dkpFZUpaeXEva3JLUW5hUU1nNmNPSTdNd3lNdUpBT1ltNm1FVG1wb09XdGIz?=
 =?utf-8?B?bDVNSDBTL0x1Mzk2RjZpelVqeVl6cWY2L2Qyc0R0aitZWEpXWHFBWlc2SkIv?=
 =?utf-8?B?dnpaSzg5L1lDYzlpL0hSanppcXowb0o4TU9FMWdCOEQrdFdPQXFZT3dkenZW?=
 =?utf-8?B?TXFTU2czMUprOVRsZDdDbmQ5SlIxL1JzMFlNMHBhZ256RWdzaG9hSEdlNlhC?=
 =?utf-8?B?Ylcxd0NjbGpySkViNHBPTXZLTVIxL1FkZFZiUzgrUEdXSjd3eElCVlNCMWVs?=
 =?utf-8?Q?j9fTMARzXdfmBrfazUnnFynkc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2900dd6a-a769-49e8-8f39-08da66019ea0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 01:30:36.8513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8IwUtzOEQGTGZykV8hv10IoBDNmYRbbBE4C/7MRJHNmsFbVP0QHak15emzhcduABKFk7lSHjqmJgroixxoi5dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6778
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U3VyZS4gVGhhbmsgeW91IGZvciByZXZpZXdpbmcgaXQuIEkgd2lsbCBzdWJtaXQgMXN0ICJuZXQ6
IHN0bW1hYzogZml4IGRtYSBxdWV1ZSBsZWZ0IHNoaWZ0IG92ZXJmbG93IGlzc3VlIiB0byBuZXQu
IEluIGZ1dHVyZSwgd2lsbCBwb3N0IHRoaXMgcGF0Y2ggdG8gbmV0LW5leHQgYWZ0ZXIgMXN0IHBh
dGNoIGxhbmRpbmcuDQoNClRoYW5rcywNCkp1bnhpYW8NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCkZyb206IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4gDQpTZW50OiBUaHVy
c2RheSwgSnVseSAxNCwgMjAyMiA2OjEzIFBNDQpUbzogQ2hhbmcsIEp1bnhpYW8gPGp1bnhpYW8u
Y2hhbmdAaW50ZWwuY29tPjsgcGVwcGUuY2F2YWxsYXJvQHN0LmNvbTsgYWxleGFuZHJlLnRvcmd1
ZUBmb3NzLnN0LmNvbTsgam9hYnJldUBzeW5vcHN5cy5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcNClN1YmplY3Q6IFJlOiBbUEFUQ0ggMi8yXSBuZXQ6IHN0bW1hYzogcmVtb3ZlIGR1cGxpY2F0
ZSBkbWEgcXVldWUgY2hhbm5lbCBtYWNyb3MNCg0KT24gV2VkLCAyMDIyLTA3LTEzIGF0IDE2OjQ3
ICswODAwLCBKdW54aWFvIENoYW5nIHdyb3RlOg0KPiBJdCBkb2Vzbid0IG5lZWQgZXh0cmEgbWFj
cm9zIGZvciBxdWV1ZSAwICYgNC4gU2FtZSBtYWNybyBjb3VsZCBiZSB1c2VkIA0KPiBmb3IgYWxs
IDggcXVldWVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSnVueGlhbyBDaGFuZyA8anVueGlhby5j
aGFuZ0BpbnRlbC5jb20+DQoNClRoaXMgbG9va3MgbGlrZSBhIG5ldC1uZXh0IGNsZWFudXAgZm9y
IHRoZSBwcmV2aW91cyBwYXRjaCwgd2hpY2ggaW5zdGVhZCBsb29rcyBsaWtlIGEgcHJvcGVyIC1u
ZXQgY2FuZGlkYXRlLiBXb3VsZCB5b3UgbWluZCByZS1wb3N0aW5nIHRoZSB0d28gcGF0Y2ggc2Vw
YXJhdGVsbHksIHdhaXRpbmcgZm9yIHRoZSBmaXggdG8gbGFuZCBpbnRvIG5ldC1uZXh0IGJlZm9y
ZSBwb3N0aW5nIHRoZSBjbGVhbnVwPw0KDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
c3RtaWNyby9zdG1tYWMvZHdtYWM0LmggICAgICB8ICA0ICstLS0NCj4gIGRyaXZlcnMvbmV0L2V0
aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNF9jb3JlLmMgfCAxMSArKysrLS0tLS0tLQ0KPiAg
MiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNC5o
IA0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNC5oDQo+IGlu
ZGV4IDQ2MmNhN2VkMDk1YTIuLmE3YjcyNWE3NTE5YmIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNC5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNC5oDQo+IEBAIC0zMzAsOSArMzMwLDcgQEAg
ZW51bSBwb3dlcl9ldmVudCB7DQo+ICANCj4gICNkZWZpbmUgTVRMX1JYUV9ETUFfTUFQMAkJMHgw
MDAwMGMzMCAvKiBxdWV1ZSAwIHRvIDMgKi8NCj4gICNkZWZpbmUgTVRMX1JYUV9ETUFfTUFQMQkJ
MHgwMDAwMGMzNCAvKiBxdWV1ZSA0IHRvIDcgKi8NCj4gLSNkZWZpbmUgTVRMX1JYUV9ETUFfUTA0
TURNQUNIX01BU0sJR0VOTUFTSygzLCAwKQ0KPiAtI2RlZmluZSBNVExfUlhRX0RNQV9RMDRNRE1B
Q0goeCkJKCh4KSA8PCAwKQ0KPiAtI2RlZmluZSBNVExfUlhRX0RNQV9RWE1ETUFDSF9NQVNLKHgp
CUdFTk1BU0soMTEgKyAoOCAqICgoeCkgLSAxKSksIDggKiAoeCkpDQo+ICsjZGVmaW5lIE1UTF9S
WFFfRE1BX1FYTURNQUNIX01BU0soeCkJR0VOTUFTSygzICsgKDggKiAoeCkpLCA4ICogKHgpKQ0K
PiAgI2RlZmluZSBNVExfUlhRX0RNQV9RWE1ETUFDSChjaGFuLCBxKQkoKGNoYW4pIDw8ICg4ICog
KHEpKSkNCg0KaWYgeW91IGhlcmUgdXNlICgoeCkgJiAweDMpIGluc3RlYWQgb2YgKHgpIGFuZCAo
KHEpICYgMHgzKSBpbnN0ZWFkIG9mIChxKSwgeW91IGNhbiBhdm9pZCB0aGUgaWYgc3RhdGVtZW50
IGJlbG93LiANCj4NCjB4NyBzaW5jZSB0aGVyZSBtaWdodCBiZSA4IGNoYW5uZWxzL3F1ZXVlcz8g
VGhpcyB3YXkgbG9va3MgYSBiaXQgdHJpY2t5LiDwn5iKDQogIA0KY2hlZXJzLA0KDQpQYW9sbw0K
DQo=
