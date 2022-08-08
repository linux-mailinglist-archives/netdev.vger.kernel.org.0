Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5544358CC62
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 18:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243890AbiHHQu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 12:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243809AbiHHQuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 12:50:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ADB1101;
        Mon,  8 Aug 2022 09:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659977420; x=1691513420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KPn7/mZ+oRJPhaU+/PWQT88koePflmiq4sR2i9MB4eA=;
  b=bJgvFfupHKWQrYfE9/o2n+qUZGshstb0K6HW2Yc0snXIbwYkUi/U0Z+L
   CqGjQRVjVCg2TVtweBRA0APSEloFg4gtdzVG6mAP8SW5FpZz1tQJHoCRh
   nHrpxRNiiPrxtqJ0fCOKUwKcw5geAXg057riVRJzTRUmBhfmwly9E7SMx
   G00skfhTcyb/1PsGewd+OGe6gqvhszuzhvoOtQJKmt8jpXElXNHbtPj5H
   32jp+umHbGQ0hdw2p+uGWeEH+o6MkGm/Wnq30OH5ktCs1cDTdsyxyMuw6
   xBMDrTGHc4l6sjv0P+7lidU05u9Cjr+02kJvg/vChUMVQC5Azn2QBAVyK
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="316556902"
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="316556902"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 09:50:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="932132002"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 08 Aug 2022 09:50:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 09:50:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 09:50:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 8 Aug 2022 09:50:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 8 Aug 2022 09:50:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVwvVJPNqiPwCnDUI3KpWLBo2lmq2B4YDCBuIbOHyQmHAx8SQzuXWVvlgoESWs3Ur22DrJo7TDuwBHE4AozdMGL0lZPyzR9Q+MooKlVQVkXFsUlTvww7/xE2C321RTBr2CoR1KdUhYcCEqOKLtSL5xqyJJ52+h1IkTUBnb7vjTlMTHTLjpxJG6LI50KRTJlb0lbtSaORfelp5JQ9W5yG1WLp7g72oSNNhVgERDGVDzya6OXCGpwGl2c589KTCQSMQPE+hov3Ak47kABcSQ/myDVLImWW/rzIPcp/Ppyzhonwgf5OC79nzzctxQ1vttYi2iO947Bfcw14qZqyLEET3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPn7/mZ+oRJPhaU+/PWQT88koePflmiq4sR2i9MB4eA=;
 b=Aqv0CmvJW5poe03Ie7mVcfRMx1LT1kcADLyYlHDjqHTLl/YeUfiJ7q8wUKqlvFfGUuSvkz6z2o20Yv5Skru/2FIus1f0Jd+YB0sFe1aXJ93X8PrM8ngptXNDn0Y+e5pPO+r7tw0+dpTxsy2WYnKdO3dXPs72CVnaVA25jmmR245B0uEm2giTTB7hFoLPdMaAgqT2FZw1ZLTZMU6RHMWsnm3MRunZPinDXdJ7jHGmjLFnHZ8IbSkRoKGnD4Ahk9cNZNdLR8amlqK4EJnM+YwWClwobpjOM+TC9BdWmdlfd3JZbqy5y4SjE9lZpJIS5Mks64s4sgrhzP83JzAqdloxsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by PH7PR11MB6676.namprd11.prod.outlook.com (2603:10b6:510:1ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 8 Aug
 2022 16:50:15 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::6d2c:6e35:bb16:6cdf]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::6d2c:6e35:bb16:6cdf%9]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 16:50:15 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "ecree@xilinx.com" <ecree@xilinx.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "linux-net-drivers@amd.com" <linux-net-drivers@amd.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        "Jiri Pirko" <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: RE: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
Thread-Topic: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
Thread-Index: AQHYqO0dovW2pkPiMk+VVg4103WPy62hGiSAgAQe+mA=
Date:   Mon, 8 Aug 2022 16:50:15 +0000
Message-ID: <PH0PR11MB5095235AC8D7C4670C1E5910D6639@PH0PR11MB5095.namprd11.prod.outlook.com>
References: <20220805165850.50160-1-ecree@xilinx.com>
 <20220805184359.5c55ca0d@kernel.org>
In-Reply-To: <20220805184359.5c55ca0d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39782e73-90e9-4d52-957a-08da795e1180
x-ms-traffictypediagnostic: PH7PR11MB6676:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2vSVNvaLAbUW1++vFzpd+OuNtT/WjSklQnGPskksItum2oXxTBRu7K34qBPdnRhkWz15xj3FHobxq0L1j5taCd1ZM6vZecjEO/1E3qi9QiiRNOi0iKjGrkZImeqDHAcW8fl0RtPI9HPW4vMZrCt4kJzmjAqR4ZP5xTP5iPEtYbPaUHrAnx36Z/6MMcsYZK9gxF051AYOJglBq1AvMY+mFi2Fw5Fvox8XP68c+meI+m4MCmBY3+AilQCtxjHuiU+qNFJWy80qNxXfybXxgmyo4jZC9h9Vl0X+9Tg0ODXE5r3qJZTjNXvV7KuOO6vmTWZyhkCxFEv/hHTC223i5zQ55xxIzGU1K2Vo3sNeVkDyrEFnK8CtNXDcW4jX8ljEOUNFarfy1XJtrcyP15qN7gZaT4B8LMj7skYZnnswEGj0ZdIUJc8R4dO74YXDwuLxAvXEsx/DqBJpFmVZ9kNMdTXuy0gBJ1uXfGAIm0BQjNEfcvuiaWgax224fzlGJHXnbnheuGTbNtznYJAJrSu7mxjtqhMkioaFnDjnmnGQE6B60AUnPDcplLRKHnlXF8rfXKnv3a60vUTzKG+jlnS02ljWUjqOlx8r94S5a2J0eSZ0xSxPlNzpRj0HZ62O5bX4dA+Bmiazzttk+myAyI2ofnqGL0rf2bbGeBxK5MWXT3VYnIRo+ct8kGCueRggm04f3j9MjryOLofFgCMCewxNu49xyNxr3FSRkflFL6vwwJWRAZQeq4C5N1eTYpuT2iOoWMdICGJMkPRYxqzaiWGu0Xnt51QPu0jU6+C1Z5xquGwWXYF92DJuKBD5adi+O/N5th86
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(396003)(376002)(366004)(346002)(9686003)(26005)(53546011)(41300700001)(7696005)(6506007)(71200400001)(186003)(2906002)(478600001)(8936002)(86362001)(83380400001)(55016003)(8676002)(66946007)(33656002)(5660300002)(54906003)(66476007)(110136005)(38100700002)(7416002)(66556008)(66446008)(4326008)(64756008)(316002)(76116006)(52536014)(122000001)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a21qOEpQaXR5S3VDdThyaFVZOTF3THUyWmk1blVTTHplTVk3ZmpIY1FjVzhn?=
 =?utf-8?B?TnlTTlhSc1E5THdXbk5UcDdCenh4NVE4emdvZlBBM3VrblpTUEx1VTJFM2Ru?=
 =?utf-8?B?NXduejBrenp1SFVYSHc4Nyt5L2xLSGtmbnlLNnBLWThXRjJnUERzcXhGcnlj?=
 =?utf-8?B?WXRXRUlyckRaNTc0MXZOV3c3R3VmNFFaTTA2cGRUcjFFR3R4L2FCTmo1OHIv?=
 =?utf-8?B?YXg4RUYrU3JIbW5BQXZpY2xXRnZVeUFSdlU3cldZR09adDRnRU1HeWlPN0Zw?=
 =?utf-8?B?cWRmd2gzV0xuNXgrUkhURElsUFdVN0dFTTVZdi9XNitGT2hJZ1N1cjg2bTNZ?=
 =?utf-8?B?aDVlS3AzU3Qzd0FiQVNUMERONzhSRkNka1FLVDh3S3VzMWsxVS9xWVZrSmFO?=
 =?utf-8?B?YlJsVE9vSTg4MXNFY2I4dFZjQ0xOWVdUVk5YNHgwNXBpc1hwdmtxMWZTZjBy?=
 =?utf-8?B?WkVISHF6SXdWak1qTlVyN1EzVmR1bmRxazIrbWMxY2Z3SVpKRWlGeEVUSzRj?=
 =?utf-8?B?b1I5VnFTMkk5OVM2UUdBVXQyV1FYb1g1ZzRHMVBteDNyZzZLblVRTDZRSHly?=
 =?utf-8?B?L3RadkhBUG4rZDJHV1cvcGxpTWl0QTkvdnQ4Z3l6WmZhRWhzT1hidDNuU3Rk?=
 =?utf-8?B?TDFSSGQ4eVZwRzVZZGcwTFUxSWRKeHFxNVJ1RUw0cGxxcXd1b0xyZ1ZKSW1O?=
 =?utf-8?B?SXlCL3Y2enR4YWpXdkhvWHoramFBcXBsRVpuRXI1RFppcFdFcFI5alZiQ2JR?=
 =?utf-8?B?R2V0WnJKYSszNk5UTmthcDBRRnZZMDNjRTFjT2JiTWZ3ekpxL2NZSmxjcnA4?=
 =?utf-8?B?RmIyQ0thQ3dvS0JjblMvSWE0SzZOZ1JhM3VQUktrWG1BZjJyM1BCdEFLOEI3?=
 =?utf-8?B?WU0xcElSalV5b0Y4eGkranl2MUNhdDRvcFlJVHFScW11VzdLUDlReUtDYjdX?=
 =?utf-8?B?MDRVZ1Q0K2VnNHFjbFJtVFQwbUpzREZsZG15UEROallvZVZ1eDh6dytWN0c5?=
 =?utf-8?B?QVNkbkQ0cE5hMEN6bk9hZWgvTmZYeS9PbDJHSXovL2J1blhudTB5elhKaXhE?=
 =?utf-8?B?Rk1WMGQyRXd6Y094cDlHZ1ZWY0xzcjJOWjV4VFo1eDdnTW82aS9MaDY2Zjcr?=
 =?utf-8?B?SnZvb3JNOGd4U080alRnMjFqTmZoWVJ0K2xmSUswRk9JNEtIcVdkN2N2eXkv?=
 =?utf-8?B?akYrbWhCbXdabjNhbnZZRm42NnBCdms2UmdBZ21GYU5xSXpBK3RlQnV3QTg2?=
 =?utf-8?B?Q1c0RDB5eVBvR0RnM2FzT2ZtT3diQkZpc1BwWm9zd0lNQklNQVRMMGd6a0Yv?=
 =?utf-8?B?QmhkUEplQnFvTjFoZVVhbjVTZWV3RzJlYWNpb0lSUEV5amh2T3FucGk0MU9r?=
 =?utf-8?B?Q1NJYmdHQ1liVk9OZlAveWFSUmc0Rjl5UEVVWFBmR1BpY0JiL2Q2OEl1emt3?=
 =?utf-8?B?NFlRQ0JMTDBRaXhsUmg3ZERXNERrRWdDenV1SnJ6ejJ1T3g1akN1ZU14OGlM?=
 =?utf-8?B?amN3RFJlaXBKWVRXNHFUcldLUFdmaGhzWElvNjBPZm16Q1JrTjUrZHhvRUJn?=
 =?utf-8?B?WUIvL0V6Zm9maVZ3Vm50NVNReFVPMmVvT1NDcEh4djRHdzJnTng0WDJ0OUZz?=
 =?utf-8?B?bE1aODZYMWlJVis5S2hRZjFrUElqNFVFd01YRDN3V3IyYWxyZjAwOUFBU2ZX?=
 =?utf-8?B?YmN1WkVIVk1acU1Wd2NxRWJ0Q0cxWEJJZ2V1b0Y4UkdMSEJLbk15Z2F1Q0pm?=
 =?utf-8?B?T2U2bFhXS0pNVWtGRExiQWlzRC8zOHdldnVwdExMY3hRTWNocng2RVl3d2Rv?=
 =?utf-8?B?bG1EdjlFcW9xbnNNY1FadEppY3ZkUndHdTB2TVVDdjJyRVFYRTUzeHFTT3py?=
 =?utf-8?B?ZXJVbzB0SVVSQlZCYlg4M1RadnhwQmF0Z3VoTExCeTFpandMVmF3djAvSGlS?=
 =?utf-8?B?QVJ6ajE4K1F2MnRvL2JMb2pIK2NtYUdObEp4TVZZaVlXY1RwdXJmQ29BRkMr?=
 =?utf-8?B?RjN6d0pWNExFSGxFem10SUFKYjJuMVBvNFpta3ZNTVBMU2RlclJWN2c3a1lL?=
 =?utf-8?B?Q3o2QVFCbFRXbnM1WEphc1FKR0FFR2luczQwSXIvU1lWUFh0dUcza3ptRVlo?=
 =?utf-8?Q?BSqJzwZthFXsZMrSQ0PUKpwW3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39782e73-90e9-4d52-957a-08da795e1180
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 16:50:15.3404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uELDHsc9kNd5txshJUkXAHN+jvzFivur9v/Sj1lDj5XcGYhqmKKHT+/OnCFKdwZGJsw5dVd/NVAwy6KkKP2dDsZ4pPEgVzv6jAjhMlmkdyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6676
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCBBdWd1c3QgMDUsIDIwMjIgNjo0NCBQ
TQ0KPiBUbzogZWNyZWVAeGlsaW54LmNvbQ0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgcGFiZW5pQHJlZGhhdC5jb207DQo+IGVkdW1hemV0QGdvb2ds
ZS5jb207IGNvcmJldEBsd24ubmV0OyBsaW51eC1kb2NAdmdlci5rZXJuZWwub3JnOyBFZHdhcmQN
Cj4gQ3JlZSA8ZWNyZWUueGlsaW54QGdtYWlsLmNvbT47IGxpbnV4LW5ldC1kcml2ZXJzQGFtZC5j
b207IEtlbGxlciwgSmFjb2IgRQ0KPiA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPjsgQnJhbmRl
YnVyZywgSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsNCj4gTWljaGFlbCBDaGFu
IDxtaWNoYWVsLmNoYW5AYnJvYWRjb20uY29tPjsgQW5keSBHb3Nwb2RhcmVrDQo+IDxhbmR5QGdy
ZXlob3VzZS5uZXQ+OyBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2VybmVsLm9yZz47IEppcmkgUGly
a28NCj4gPGppcmlAcmVzbnVsbGkudXM+OyBTaGFubm9uIE5lbHNvbiA8c25lbHNvbkBwZW5zYW5k
by5pbz47IFNpbW9uIEhvcm1hbg0KPiA8c2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbT47IEFsZXhh
bmRlciBEdXljaw0KPiA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT4NCj4gU3ViamVjdDogUmU6
IFtSRkMgUEFUQ0ggbmV0LW5leHRdIGRvY3M6IG5ldDogYWRkIGFuIGV4cGxhbmF0aW9uIG9mIFZG
IChhbmQgb3RoZXIpDQo+IFJlcHJlc2VudG9ycw0KPiANCj4gT24gRnJpLCA1IEF1ZyAyMDIyIDE3
OjU4OjUwICswMTAwIGVjcmVlQHhpbGlueC5jb20gd3JvdGU6DQo+ID4gRnJvbTogRWR3YXJkIENy
ZWUgPGVjcmVlLnhpbGlueEBnbWFpbC5jb20+DQo+ID4NCj4gPiBUaGVyZSdzIG5vIGNsZWFyIGV4
cGxhbmF0aW9uIG9mIHdoYXQgVkYgUmVwcmVzZW50b3JzIGFyZSBmb3IsIHRoZWlyDQo+ID4gIHNl
bWFudGljcywgZXRjLiwgb3V0c2lkZSBvZiB2ZW5kb3IgZG9jcyBhbmQgcmFuZG9tIGNvbmZlcmVu
Y2Ugc2xpZGVzLg0KPiA+IEFkZCBhIGRvY3VtZW50IGV4cGxhaW5pbmcgUmVwcmVzZW50b3JzIGFu
ZCBkZWZpbmluZyB3aGF0IGRyaXZlcnMgdGhhdA0KPiA+ICBpbXBsZW1lbnQgdGhlbSBhcmUgZXhw
ZWN0ZWQgdG8gZG8uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBFZHdhcmQgQ3JlZSA8ZWNyZWUu
eGlsaW54QGdtYWlsLmNvbT4NCj4gPiAtLS0NCj4gPiBUaGlzIGRvY3VtZW50cyByZXByZXNlbnRv
cnMgYXMgSSB1bmRlcnN0YW5kIHRoZW0sIGJ1dCBJIHN1c3BlY3Qgb3RoZXJzDQo+ID4gIChpbmNs
dWRpbmcgb3RoZXIgdmVuZG9ycykgbWlnaHQgZGlzYWdyZWUgKHBhcnRpY3VsYXJseSB3aXRoIHRo
ZSAid2hhdA0KPiA+ICBmdW5jdGlvbnMgc2hvdWxkIGhhdmUgYSByZXAiIHNlY3Rpb24pLiAgSSdt
IGhvcGluZyB0aGF0IHRocm91Z2ggcmV2aWV3DQo+ID4gIG9mIHRoaXMgZG9jIHdlIGNhbiBjb252
ZXJnZSBvbiBhIGNvbnNlbnN1cy4NCj4gDQo+IFRoYW5rcyBmb3IgZG9pbmcgdGhpcywgd2UgbmVl
ZCB0byBDQyBwZW9wbGUgdGhvLiBPdGhlcndpc2UgdGhleSB3b24ndA0KPiBwYXkgYXR0ZW50aW9u
LiAoYWRkaW5nIHNlbWktbm9uLWV4aGF1c3RpdmVseSB0aG9zZSBJIGhhdmUgaW4gbXkgYWRkcmVz
cw0KPiBib29rKQ0KPiANCj4gPiArPT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPiAr
TmV0d29yayBGdW5jdGlvbiBSZXByZXNlbnRvcnMNCj4gPiArPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0NCj4gPiArDQo+ID4gK1RoaXMgZG9jdW1lbnQgZGVzY3JpYmVzIHRoZSBzZW1hbnRp
Y3MgYW5kIHVzYWdlIG9mIHJlcHJlc2VudG9yIG5ldGRldmljZXMsDQo+IGFzDQo+ID4gK3VzZWQg
dG8gY29udHJvbCBpbnRlcm5hbCBzd2l0Y2hpbmcgb24gU21hcnROSUNzLiAgRm9yIHRoZSBjbG9z
ZWx5LXJlbGF0ZWQgcG9ydA0KPiA+ICtyZXByZXNlbnRvcnMgb24gcGh5c2ljYWwgKG11bHRpLXBv
cnQpIHN3aXRjaGVzLCBzZWUNCj4gPiArOnJlZjpgRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3N3
aXRjaGRldi5yc3QgPHN3aXRjaGRldj5gLg0KPiA+ICsNCj4gPiArTW90aXZhdGlvbg0KPiA+ICst
LS0tLS0tLS0tDQo+ID4gKw0KPiA+ICtTaW5jZSB0aGUgbWlkLTIwMTBzLCBuZXR3b3JrIGNhcmRz
IGhhdmUgc3RhcnRlZCBvZmZlcmluZyBtb3JlIGNvbXBsZXgNCj4gPiArdmlydHVhbGlzYXRpb24g
Y2FwYWJpbGl0aWVzIHRoYW4gdGhlIGxlZ2FjeSBTUi1JT1YgYXBwcm9hY2ggKHdpdGggaXRzIHNp
bXBsZQ0KPiA+ICtNQUMvVkxBTi1iYXNlZCBzd2l0Y2hpbmcgbW9kZWwpIGNhbiBzdXBwb3J0LiAg
VGhpcyBsZWQgdG8gYSBkZXNpcmUgdG8NCj4gb2ZmbG9hZA0KPiA+ICtzb2Z0d2FyZS1kZWZpbmVk
IG5ldHdvcmtzIChzdWNoIGFzIE9wZW5WU3dpdGNoKSB0byB0aGVzZSBOSUNzIHRvIHNwZWNpZnkg
dGhlDQo+ID4gK25ldHdvcmsgY29ubmVjdGl2aXR5IG9mIGVhY2ggZnVuY3Rpb24uICBUaGUgcmVz
dWx0aW5nIGRlc2lnbnMgYXJlIHZhcmlvdXNseQ0KPiA+ICtjYWxsZWQgU21hcnROSUNzIG9yIERQ
VXMuDQo+ID4gKw0KPiA+ICtOZXR3b3JrIGZ1bmN0aW9uIHJlcHJlc2VudG9ycyBwcm92aWRlIHRo
ZSBtZWNoYW5pc20gYnkgd2hpY2ggbmV0d29yaw0KPiBmdW5jdGlvbnMNCj4gPiArb24gYW4gaW50
ZXJuYWwgc3dpdGNoIGFyZSBtYW5hZ2VkLiBUaGV5IGFyZSB1c2VkIGJvdGggdG8gY29uZmlndXJl
IHRoZQ0KPiA+ICtjb3JyZXNwb25kaW5nIGZ1bmN0aW9uICgncmVwcmVzZW50ZWUnKSBhbmQgdG8g
aGFuZGxlIHNsb3ctcGF0aCB0cmFmZmljIHRvIGFuZA0KPiA+ICtmcm9tIHRoZSByZXByZXNlbnRl
ZSBmb3Igd2hpY2ggbm8gZmFzdC1wYXRoIHN3aXRjaGluZyBydWxlIGlzIG1hdGNoZWQuDQo+IA0K
PiBJIHRoaW5rIHdlIHNob3VsZCBqdXN0IGRlc2NyaWJlIGhvdyB0aG9zZSBuZXRkZXZzIGJyaW5n
IFNSLUlPVg0KPiBmb3J3YXJkaW5nIGludG8gTGludXggbmV0d29ya2luZyBzdGFjay4gVGhpcyBz
ZWN0aW9uIHJlYWRzIHRvbyBtdWNoDQo+IGxpa2UgaXQncyBhIGhhY2sgcmF0aGVyIHRoYW4gYW4g
b2J2aW91cyBjaG9pY2UuDQoNCkkgYWdyZWUuIFRob3VnaCBub3QgYWxsIG9mIHRoZSBkZXZpY2Vz
IGNhbiBzdXBwb3J0IGl0LCByZXByZXNlbnRvciBkZXZpY2VzIGFuZCBzd2l0Y2hkZXYgYXJlIGFi
bGUgdG8gYmUgc3VwcG9ydGVkIGV2ZW4gaW4gc29tZSBjYXNlcyB3aGljaCBtYXkgbm90IGJlIGFz
IGZ1bGx5IGZlYXR1cmVkICBvciBjYXBhYmxlIGFzICJTbWFydE5JQyIuIE9mY291cnNlIHRoZSB0
ZXJtaW5vbG9neSBoZXJlIGNhbiBnZXQgbXVkZGxlZCB3aXRoIHZhcmlvdXMgYnJhbmRpbmcgZXRj
Li4NCg==
