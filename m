Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8656E1961
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 03:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjDNBB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 21:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDNBBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 21:01:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4362738;
        Thu, 13 Apr 2023 18:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681434113; x=1712970113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ek9P4izVa4GiZiunQBDPE9TVF95ELPKjEdj/oJyRtOQ=;
  b=a3CVFM28hdh2NG2avEhicHYt+7NUdZ4CRGHxIP049I0cwK5/RTG/45qp
   6QMJyaACsEdeYPnM3F6TfiAmQvtF0XnxiwwJhG1lmwoB55qei4MXWwcEb
   JNc8B/ao5QyzGfmvMl8z8/d1wZAvYUXshwl27+3rgbQDb3Hx5EJa9r3I9
   e4iC/wL5tV1ZnFkEbOPR8ozJsEIGzyO8RsXZ/TluqWMKMVFrr37nIN+eu
   K9p9joSCv3aniCTOMOPDKy/tx/OQkkEiqGJeL5ovWS5g+r4WKtItx18nq
   p8u9qGJfhbn9cdxUxP6K+mJ2DPLPx8PYqj1zScPIDJ6Tq6cv4agHu9MAe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="344345808"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="344345808"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 18:01:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="758900258"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="758900258"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 13 Apr 2023 18:01:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 18:01:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 18:01:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 18:01:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNknNDiQ1KgbLLSXFBfCu5kQXSnXLeWh16Zqgs0AlYYaOJV8Z44cNVUp0co0OTs6byOTuWkXkaF4Ht/YurkfOU2hn/Hz5E24qAMhTRuB6pagEDp/WKtMXdyOdqLkYur/ujSlcRDLhEk2G9wdR+ZtOa5oWd1x+FxSX4uP+MMN+Gd2Clt2t6MeUHx2XcpDnso2unFQvdLzFHr/Pp/ZQIKxGjCjsDHUg673Q6Wa8GaLdUihx/AOi1l2aVeHQ050N9p5vhmnZX8Z7gPUxyeGQo3xI/UE65H4lOAdg7jOpMfWsFOoFZyFZZzFg1Ggo8GpdOgg6LGri0O4ctZ+ygAPBULP8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ek9P4izVa4GiZiunQBDPE9TVF95ELPKjEdj/oJyRtOQ=;
 b=QZm5TN+MSkvOVsFLYck2/L4Zx92p15479yYoKCTCW+Wh3dajJEF5Y4NjGBTV9J/37JTEuoeVqrf6D7qamBm0VWKOxj1kxgLhVm9yIoYODAKQgcObFB8lq4A9kCv+y6lo2qApvoYbZZE9xzOEwmFW7nEJW5W5LQ4fagTAdVWC2tFDLPpbZKQRFwgXFIEk3YYUkgpUBB7GFvoQKKazgx12gqq0pvJJEVJvPq4Zuvm6B+Toz50Yp9EFWXxDGIPcCF71vrxBjuWJ+yPug9lQBwVgQ/prkXqyGF+c5MVDsvIb86BYSbvdXIwaP8O0pnH6EzwdXT7i4VZeGyDaPj143ICHFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by CY8PR11MB7194.namprd11.prod.outlook.com (2603:10b6:930:92::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 01:01:49 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Fri, 14 Apr 2023
 01:01:49 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Stanislav Fomichev <sdf@google.com>
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
Thread-Index: AQHZbSND2+tajsBCFkyFMq8B2G8mu68n5iyAgABB5QCAAA3fgIAAOWbAgAEFkICAAIl3oA==
Date:   Fri, 14 Apr 2023 01:01:49 +0000
Message-ID: <PH0PR11MB5830CC6A90EEA97CA760AA3BD8999@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230412094235.589089-1-yoong.siang.song@intel.com>
 <20230412094235.589089-4-yoong.siang.song@intel.com>
 <ZDbjkwGS5L9wdS5h@google.com>
 <677ed6c5-51fc-4b8b-d9a4-42e4cfe9006c@intel.com>
 <CAKH8qBtXTAZr5r1VC9ynSvGv5jWMD54d=-2qmBc9Zr3ui9HnEg@mail.gmail.com>
 <PH0PR11MB5830A823C4FC0483BA702293D8989@PH0PR11MB5830.namprd11.prod.outlook.com>
 <8d653ecc-4ba4-11fc-1f6f-1792bb18fabd@intel.com>
In-Reply-To: <8d653ecc-4ba4-11fc-1f6f-1792bb18fabd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|CY8PR11MB7194:EE_
x-ms-office365-filtering-correlation-id: 31e716e5-a4f9-428e-5e5b-08db3c83d3c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 76DG0AynTU/YFnDCpFh4qrXIv7JLWGulhdZa5ntPol1LJ81Qi0ayZX1ric458lyEbWkh1pSzxfY4EkOeNOQ8VRxIo1u1TMpEmqeapLSpy3x/LtkSg5DQNbDVMw9cZPsSD4poTtQkBPvM31PneTH7QnJlAfLMq1XAn++K21amdPAMNSFphuqBnYUWn6dsBN6X54oZLJdHr5cNw9F5fNV4AwgLG2LUZigzhGiNSz8gZnozDM+3lmZawppsp9uTA8SpVYL4pmcE/j3JhYq266/4aOZO2etUgopMSOt8JWllWzvR9fBSBBjobgznDkxtrQbqYozevtjrdJW9E5uwPmgpaS7b+ETJ66/DnmE901QPRQXBqvmeEPYgxupTLok6et9RhmhsQxqQkl3sfXxozA03pu/nxZqNan5OnXZy3A5y7fJM4FPoxOOwHZIP5QPbUDKPa+93dv0G58x5QrvF9h40mO4zHX0eSP8QL2CBcp+xLZ1KBKnnG//NHyLJDUW7EaDS92OiAtDlNypMVo8rHJbRb6T2P3CaB5aZIiZLgtDYp0ZSFTEPHQ8v2CxWDQCzxRyMsjZhJJG5jAZKp4dy2eEbeECOlq3bDhmFm9QjXdNcai13rtlqVO0mBX6nMDG9m14W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199021)(71200400001)(7696005)(66476007)(66556008)(66446008)(64756008)(4326008)(66946007)(76116006)(110136005)(2906002)(7416002)(38070700005)(86362001)(38100700002)(122000001)(52536014)(41300700001)(82960400001)(5660300002)(33656002)(8676002)(8936002)(316002)(478600001)(55016003)(54906003)(55236004)(53546011)(9686003)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUdWVlNMZ0h3bXQraVZFa2xLNjRuMW5qRGx5UkdOTEtsRDFwSVZQMXl1dFo2?=
 =?utf-8?B?U3prVmVxQWkvanZFLzZNMmM3bkhSdTd2dHRGQTZTa2dvM24zKzV0L3EwRnpV?=
 =?utf-8?B?V0l0L29BU0ZSRXpSMWZVTm92RVdYUWxWQ0FyY1BqMnNCTmRDZ1BNWVdTYzF5?=
 =?utf-8?B?dXJGSWRZckVMbUN2aUNCSVlia0hjMm5kbFlVcy9HZkdsejhmV1dYdGpYSHRH?=
 =?utf-8?B?Z0JrVEJQdE5CNEIxM2dWRTlHeXNQOENBcDdyMlpoVHhDcDVvNFN6cE54cE41?=
 =?utf-8?B?a2ZNaVFiWlpuZitUOUlGZ1NaNHN5dWxjb0RJZklFcEpLRjMrekJwVGlZa0Jt?=
 =?utf-8?B?MnAyRFJCSThNS1ZVRml1NUFJR0gvNVNaMCtMOU9vRVJRRGJEYTBGdExybjNi?=
 =?utf-8?B?bzN6V1FjdzVsMk03UWQxZGNiYXdHMzR6MVZxL2JNSGwwUDZ5WjFLR0FNVHhG?=
 =?utf-8?B?WWVtNmVObEhsUFQvRzMwRDdNOXFyM1QzRG94eHc4enJiYnRMeWRMUVpwZ1Nq?=
 =?utf-8?B?L1NEV2ZIdXV3TTFaWDZiZHlxL0dmanhJWGhUbWtQTnNHN0JRd2k1NFJZZlk4?=
 =?utf-8?B?andqellydnNYelZVTnFESWRXdjNXUVJvamxPdGJpMExnRFJtUWtLSEpSOHo3?=
 =?utf-8?B?NjdldksxQm9IOVpodjl6QXpFV28vb1lRK1BKRzY2L3lQTi9FT2ZSbSswQTdE?=
 =?utf-8?B?emIzdTJtM0JUM0NjTFdLYWV5UXExMEQ2d3JDQ3lBdXJWbkVXbGFGcEZQSUVQ?=
 =?utf-8?B?UjRXY2NjdVllRWltZG5JR1ViMjlidURjRDlYTi9ZZTJMWGNqeEpPWlpOdks4?=
 =?utf-8?B?eHpUMVJVc2FxTmpaM1U0NUVIMmlqYkUzbjJad0grQnY0MkdKSWlHc25rTVpN?=
 =?utf-8?B?c1kwT2VYdGhPdUY3cFNFRjNYenRjYlV0Tm90NmlON3EzUFU3c01OaVpyQ0dO?=
 =?utf-8?B?alFTbTk5dGNBd0UyTlRlTHV0dDVlcklxc2FFMnlQL0c0N2JiTlNucElUaWw2?=
 =?utf-8?B?cThPR3dmNGdiRHFXRGE0MU1JODZ6OU1PcUxNcU4wQ2o3Ym9LbHhQZG9NbzBm?=
 =?utf-8?B?R1JKUkFvRTlOVmEvdStWekFCNVQvazNqTE8rVWsySVZlT2E4V0ZJVi9hTnVy?=
 =?utf-8?B?L240QnQ4djJHWDd6d0kwVVlrMTNGOXhwdXF1QnJRUXFJVXUzeFRXa2R0NnI4?=
 =?utf-8?B?ZFBEbUk1NzJ3cXZXZmdENlZTTWlHRXZ5MTNiN2VoRmdVMVVEbmU2eXlvRGJh?=
 =?utf-8?B?bE5jVHRSaEJGZ0JVSTJRakFBSGpVTlRZN3BOb2NSR2FUOFJGMkR2MmFHYTB2?=
 =?utf-8?B?NUhJUjVVZldtU1RnN0QzTVRHNmd1aDV5dmxEMzZyMS9SdXNnS2xTUVhaVjcv?=
 =?utf-8?B?T0pqZE1WOWQ0T2NVTFZvRVBVMUQxT21nZ29IQTgvR0tZTG84YlFPcmVQOWhR?=
 =?utf-8?B?R3grYnJKakZyZlBKbWdZd1FUYlpDVDVqai9nWDFrdjNuVGtCZzdsMHcxYWJI?=
 =?utf-8?B?VzdCMS84MWV5M2ZadVVsQ2F6WGxYbXlnaGZYbnhkN01DMGF2amU5b042a1Uv?=
 =?utf-8?B?eWk1K2sxN2lCenp5anlPVlF2UFY0VnVycmZtTENaV05CVnd5N1ZhWW5FUVBQ?=
 =?utf-8?B?NnFwSUl2TDNlV3pxRFFZbGhyTWUwRjArUDZrNTFFcWR5bTY1KzNQamlBT0hK?=
 =?utf-8?B?dHoxU2hMcWhSRkQ3MHJZK3NDdkxjaERlWW5GMlpIY09JT3Zjcnd1Y3diT0hu?=
 =?utf-8?B?eXl2anVlbE9qVE14ZXFlbHBiQ0h4dVB1dmhXVURKbU1BQjZtUFgrd0JoTUdN?=
 =?utf-8?B?WHlQcjJvWGlpVVB6bW5qcFd4aHliL0luOTNMczYrVVpwWDE4L0pJVHE1Z0Qz?=
 =?utf-8?B?Ym9mbFpLbnhLOTM5VWhWei9oa0p6Y0FVeldVaWtzc0E2NVF4VFNJYUlNQi9Z?=
 =?utf-8?B?aHNMYlF0THpCUk9BUngzU293VDduc0hnMVhNU3h4RUdBc1pDMzd3WEc2Vm9o?=
 =?utf-8?B?V2R0U0pmY1N5eE50bzB4TnJTSEkwYjVJeW56dDBjLzN3cmtURXBBSlVVcjlN?=
 =?utf-8?B?WFBDRU44d09CekhxYzRSVHJsVVZqMFFXNyt2RHJrTE9XSUtFUkwvWm11L0Ri?=
 =?utf-8?Q?5nORHs7WopkBYtvou0Kx9AphZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e716e5-a4f9-428e-5e5b-08db3c83d3c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 01:01:49.3806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wE+KA/67EAwQL0/k0ghSE724EDulBZBbVNaulxJonC/23ihqGNAwg/0FbzW80VdEpm9mb/JQF75wWPZlGtEJcaTLbWFc+mIVlL53iFKjX28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpZGF5LCBBcHJpbCAxNCwgMjAyMyAxMjo0NyBBTSwgS2VsbGVyLCBKYWNvYiBFIDxqYWNv
Yi5lLmtlbGxlckBpbnRlbC5jb20+IHdyb3RlOg0KPk9uIDQvMTIvMjAyMyA2OjM5IFBNLCBTb25n
LCBZb29uZyBTaWFuZyB3cm90ZToNCj4+IE9uIFRodXJzZGF5LCBBcHJpbCAxMywgMjAyMyA1OjQ2
IEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29tPg0KPndyb3RlOg0KPj4+IE9u
IFdlZCwgQXByIDEyLCAyMDIzIGF0IDE6NTbigK9QTSBKYWNvYiBLZWxsZXIgPGphY29iLmUua2Vs
bGVyQGludGVsLmNvbT4NCj53cm90ZToNCj4+Pj4NCj4+Pj4NCj4+Pj4NCj4+Pj4gT24gNC8xMi8y
MDIzIDEwOjAwIEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+Pj4+PiBPbiAwNC8xMiwg
U29uZyBZb29uZyBTaWFuZyB3cm90ZToNCj4+Pj4+PiBBZGQgcmVjZWl2ZSBoYXJkd2FyZSB0aW1l
c3RhbXAgbWV0YWRhdGEgc3VwcG9ydCB2aWEga2Z1bmMgdG8gWERQDQo+Pj4+Pj4gcmVjZWl2ZSBw
YWNrZXRzLg0KPj4+Pj4+DQo+Pj4+Pj4gU3VnZ2VzdGVkLWJ5OiBTdGFuaXNsYXYgRm9taWNoZXYg
PHNkZkBnb29nbGUuY29tPg0KPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFNvbmcgWW9vbmcgU2lhbmcg
PHlvb25nLnNpYW5nLnNvbmdAaW50ZWwuY29tPg0KPj4+Pj4+IC0tLQ0KPj4+Pj4+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWMuaCAgfCAgMyArKysNCj4+Pj4+PiAu
Li4vbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMgfCAyNg0KPj4+Pj4+
ICsrKysrKysrKysrKysrKysrKy0NCj4+Pj4+PiAgMiBmaWxlcyBjaGFuZ2VkLCAyOCBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pj4+Pj4NCj4+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjLmgNCj4+Pj4+PiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hYy5oDQo+Pj4+Pj4gaW5kZXggYWM4Y2Nm
ODUxNzA4Li44MjZhYzBlYzg4YzYgMTAwNjQ0DQo+Pj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjLmgNCj4+Pj4+PiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWMuaA0KPj4+Pj4+IEBAIC05NCw2ICs5NCw5IEBA
IHN0cnVjdCBzdG1tYWNfcnhfYnVmZmVyIHsNCj4+Pj4+Pg0KPj4+Pj4+ICBzdHJ1Y3Qgc3RtbWFj
X3hkcF9idWZmIHsNCj4+Pj4+PiAgICAgIHN0cnVjdCB4ZHBfYnVmZiB4ZHA7DQo+Pj4+Pj4gKyAg
ICBzdHJ1Y3Qgc3RtbWFjX3ByaXYgKnByaXY7DQo+Pj4+Pj4gKyAgICBzdHJ1Y3QgZG1hX2Rlc2Mg
KnA7DQo+Pj4+Pj4gKyAgICBzdHJ1Y3QgZG1hX2Rlc2MgKm5wOw0KPj4+Pj4+ICB9Ow0KPj4+Pj4+
DQo+Pj4+Pj4gIHN0cnVjdCBzdG1tYWNfcnhfcXVldWUgew0KPj4+Pj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+Pj4+Pj4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+Pj4+
Pj4gaW5kZXggZjdiYmRmMDRkMjBjLi5lZDY2MDkyN2I2MjggMTAwNjQ0DQo+Pj4+Pj4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPj4+Pj4+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMN
Cj4+Pj4+PiBAQCAtNTMxNSwxMCArNTMxNSwxNSBAQCBzdGF0aWMgaW50IHN0bW1hY19yeChzdHJ1
Y3Qgc3RtbWFjX3ByaXYNCj4+Pj4+PiAqcHJpdiwgaW50IGxpbWl0LCB1MzIgcXVldWUpDQo+Pj4+
Pj4NCj4+Pj4+PiAgICAgICAgICAgICAgICAgICAgICB4ZHBfaW5pdF9idWZmKCZjdHgueGRwLCBi
dWZfc3osICZyeF9xLT54ZHBfcnhxKTsNCj4+Pj4+PiAgICAgICAgICAgICAgICAgICAgICB4ZHBf
cHJlcGFyZV9idWZmKCZjdHgueGRwLCBwYWdlX2FkZHJlc3MoYnVmLT5wYWdlKSwNCj4+Pj4+PiAt
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ1Zi0+cGFnZV9vZmZzZXQsIGJ1
ZjFfbGVuLCBmYWxzZSk7DQo+Pj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBidWYtPnBhZ2Vfb2Zmc2V0LCBidWYxX2xlbiwNCj4+Pj4+PiArIHRydWUpOw0KPj4+Pj4+
DQo+Pj4+Pj4gICAgICAgICAgICAgICAgICAgICAgcHJlX2xlbiA9IGN0eC54ZHAuZGF0YV9lbmQg
LSBjdHgueGRwLmRhdGFfaGFyZF9zdGFydCAtDQo+Pj4+Pj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGJ1Zi0+cGFnZV9vZmZzZXQ7DQo+Pj4+Pj4gKw0KPj4+Pj4+ICsgICAgICAgICAg
ICAgICAgICAgIGN0eC5wcml2ID0gcHJpdjsNCj4+Pj4+PiArICAgICAgICAgICAgICAgICAgICBj
dHgucCA9IHA7DQo+Pj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgY3R4Lm5wID0gbnA7DQo+Pj4+
Pj4gKw0KPj4+Pj4+ICAgICAgICAgICAgICAgICAgICAgIHNrYiA9IHN0bW1hY194ZHBfcnVuX3By
b2cocHJpdiwgJmN0eC54ZHApOw0KPj4+Pj4+ICAgICAgICAgICAgICAgICAgICAgIC8qIER1ZSB4
ZHBfYWRqdXN0X3RhaWw6IERNQSBzeW5jIGZvcl9kZXZpY2UNCj4+Pj4+PiAgICAgICAgICAgICAg
ICAgICAgICAgKiBjb3ZlciBtYXggbGVuIENQVSB0b3VjaCBAQCAtNzA3MSw2DQo+Pj4+Pj4gKzcw
NzYsMjMgQEAgdm9pZCBzdG1tYWNfZnBlX2hhbmRzaGFrZShzdHJ1Y3Qgc3RtbWFjX3ByaXYgKnBy
aXYsDQo+Ym9vbCBlbmFibGUpDQo+Pj4+Pj4gICAgICB9DQo+Pj4+Pj4gIH0NCj4+Pj4+Pg0KPj4+
Pj4+ICtzdGF0aWMgaW50IHN0bW1hY194ZHBfcnhfdGltZXN0YW1wKGNvbnN0IHN0cnVjdCB4ZHBf
bWQgKl9jdHgsIHU2NA0KPj4+Pj4+ICsqdGltZXN0YW1wKSB7DQo+Pj4+Pj4gKyAgICBjb25zdCBz
dHJ1Y3Qgc3RtbWFjX3hkcF9idWZmICpjdHggPSAodm9pZCAqKV9jdHg7DQo+Pj4+Pj4gKw0KPj4+
Pj4+ICsgICAgKnRpbWVzdGFtcCA9IDA7DQo+Pj4+Pj4gKyAgICBzdG1tYWNfZ2V0X3J4X2h3dHN0
YW1wKGN0eC0+cHJpdiwgY3R4LT5wLCBjdHgtPm5wLA0KPj4+Pj4+ICsgdGltZXN0YW1wKTsNCj4+
Pj4+PiArDQo+Pj4+Pg0KPj4+Pj4gWy4uXQ0KPj4+Pj4NCj4+Pj4+PiArICAgIGlmICgqdGltZXN0
YW1wKQ0KPj4+Pj4NCj4+Pj4+IE5pdDogZG9lcyBpdCBtYWtlIHNlbnNlIHRvIGNoYW5nZSBzdG1t
YWNfZ2V0X3J4X2h3dHN0YW1wIHRvIHJldHVybg0KPj4+Pj4gYm9vbCB0byBpbmRpY2F0ZSBzdWNj
ZXNzL2ZhaWx1cmU/IFRoZW4geW91IGNhbiBkbzoNCj4+Pj4+DQo+Pj4+PiBpZiAoIXN0bW1hY19n
ZXRfcnhfaHd0c3RhbXAoKSkNCj4+Pj4+ICAgICAgIHJldXRybiAtRU5PREFUQTsNCj4+Pj4NCj4+
Pj4gSSB3b3VsZCBtYWtlIGl0IHJldHVybiB0aGUgLUVOT0RBVEEgZGlyZWN0bHkgc2luY2UgdHlw
aWNhbGx5IGJvb2wNCj4+Pj4gdHJ1ZS9mYWxzZSBmdW5jdGlvbnMgaGF2ZSBuYW1lcyBsaWtlICJz
dG1tYWNfaGFzX3J4X2h3dHN0YW1wIiBvcg0KPj4+PiBzaW1pbGFyIG5hbWUgdGhhdCBpbmZlcnMg
eW91J3JlIGFuc3dlcmluZyBhIHRydWUvZmFsc2UgcXVlc3Rpb24uDQo+Pj4+DQo+Pj4+IFRoYXQg
bWlnaHQgYWxzbyBsZXQgeW91IGF2b2lkIHplcm9pbmcgdGhlIHRpbWVzdGFtcCB2YWx1ZSBmaXJz
dD8NCj4+Pg0KPj4+IFNHVE0hDQo+Pg0KPj4gc3RtbWFjX2dldF9yeF9od3RzdGFtcCgpIGlzIHVz
ZWQgaW4gb3RoZXIgcGxhY2VzIHdoZXJlIHJldHVybiB2YWx1ZSBpcw0KPj4gbm90IG5lZWRlZC4g
QWRkaXRpb25hbCBpZiBzdGF0ZW1lbnQgY2hlY2tpbmcgb24gcmV0dXJuIHZhbHVlIHdpbGwgYWRk
DQo+PiBjb3N0LCBidXQgaWdub3JpbmcgcmV0dXJuIHZhbHVlIHdpbGwgaGl0ICJ1bnVzZWQgcmVz
dWx0IiB3YXJuaW5nLg0KPj4NCj4NCj5Jc24ndCB1bnVzZWQgcmV0dXJuIHZhbHVlcyBvbmx5IGNo
ZWNrZWQgaWYgdGhlIGZ1bmN0aW9uIGlzIGFubm90YXRlZCBhcw0KPiJfX211c3RfY2hlY2siPw0K
SSBzZWUuIERpbnQgYXdhcmUgdGhhdC4gVGhhbmtzIGZvciB5b3VyIGluZm8uDQo+DQo+PiBJIHRo
aW5rIGl0IHdpbGwgYmUgbW9yZSBtYWtlIHNlbnNlIGlmIEkgZGlyZWN0bHkgcmV0cmlldmUgdGhl
DQo+PiB0aW1lc3RhbXAgdmFsdWUgaW4gc3RtbWFjX3hkcF9yeF90aW1lc3RhbXAoKSwgaW5zdGVh
ZCBvZiByZXVzZQ0KPnN0bW1hY19nZXRfcnhfaHd0c3RhbXAoKS4NCj4+DQo+DQo+VGhhdCBtYWtl
cyBzZW5zZSB0b28sIHRoZSBYRFAgZmxvdyBpcyBhIGJpdCBzcGVjaWFsIGNhc2VkIHJlbGF0aXZl
IHRvIHRoZSBvdGhlcg0KPm9uZXMuDQpZZXMsIGFncmVlLg0KPg0KPj4gTGV0IG1lIHNlbmQgb3V0
IHY0IGZvciByZXZpZXcuDQo+Pg0KPj4gVGhhbmtzICYgUmVnYXJkcw0KPj4gU2lhbmcNCj4+DQo+
Pj4NCj4+Pj4gVGhhbmtzLA0KPj4+PiBKYWtlDQo=
