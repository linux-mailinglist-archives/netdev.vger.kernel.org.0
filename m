Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E186EF371
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 13:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbjDZLb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 07:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240010AbjDZLbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 07:31:25 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A4D5274
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 04:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682508680; x=1714044680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WF1n7Gh8gfdfr0wYy5khNX7F/Hl4C80fRlVCj2y8NzU=;
  b=V4W9bKK/VUMM3rEDv1+0+24ycXIPXn9XdaJK2G/v9o7rO+3YHZc/oHUx
   AIVXqNMk+UkDHkaMj19SnT1Ead+67enTSlSMczhqjjgBQQ0HtR0je+IxP
   gsU/XULIcDnq74BjYLL3C9ze2+HK2NuUznt/JYZk7+CbZCwxcaM3+wcjB
   +AUm/55eXIfC1crvQmxmBj2XqzbF5wJjzYZnsZRcIeP9pXO2cbtqBQeub
   maBq6/i2YTNOXuTxn9UE4iGZD8jdKyQNP/k/HzKPGzZd4VDLTIoOIH5KB
   iFEywKwInfnIWpBnIQx6pnAmVdLBSU9haTlg6Zwfcc601DH8Rgls1C9zT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="345837222"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="345837222"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 04:31:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="687904277"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="687904277"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 26 Apr 2023 04:31:20 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 04:31:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 04:31:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 04:31:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmx0IlFzqOpDcqcQsca877SnDbResM/pdZkJEKhadrVEc3dn7SbDZOwl3HlajTsNrSmhnAtuCkoDQE+7ca9CVYvs73cgAFb/Tc9yrdu0K9yNVHL6fk8gz+xdY5OYa+wv+CYxsp7fuD9uxCHU0s4cadOuDGQTBv1o6SdVtBsNaOtCfw74LST33IVakFpVUkDC9WUfP19rjJeTu5+/jiBWzN2nHz2/bvW/MXToRR0bA6Oi7ookTgWNT3+fCXaDX0Logrj7PqxmdolcmPjbnCNyNaDhPJN5ASnIxz3ZhFU5oNW28Hs6Bw/YaY3zXbqo5haZpbMlB9r+CaGcmmJx6wDe2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WF1n7Gh8gfdfr0wYy5khNX7F/Hl4C80fRlVCj2y8NzU=;
 b=LUqwR48PzDVqQa9VYkF3GyNdarVabH+JPnliuPjy4dB8wbiGL89CLCMURT2O2fzPFNHfHXhpGgZqAw02gMC1UjYegFwg6NaqA3t98F/fVwmUEiejHFINvB5NwEot/XPSY+jFVHpLpEqt7WEniJOqeWo19TXIvllks+XfX9jOd6MGUimb8Z/WdeDp4K7lISbyktij56JvpofMRwk0d9x1bG8d56BUaPpHmRYj9jVRY5F1xEub4aTDM9Miv1FdPgfQ6/dSgg+jwBy5X5ufGL0lnDW6B27qhgJAcLO5VgWodVNScHfOnNku7+jmlXJxLt4YD2klhl7yCXm/AgfE68GipA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by PH8PR11MB6705.namprd11.prod.outlook.com (2603:10b6:510:1c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Wed, 26 Apr
 2023 11:31:18 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 11:31:17 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 07/12] ice: Accept LAG netdevs in bridge offloads
Thread-Topic: [PATCH net-next 07/12] ice: Accept LAG netdevs in bridge
 offloads
Thread-Index: AQHZdF9p4EeAREgbpEOl7g6NB9SEFa89dJpQ
Date:   Wed, 26 Apr 2023 11:31:17 +0000
Message-ID: <MW4PR11MB5776258BAC908BD75A739DF2FD659@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-8-wojciech.drewek@intel.com>
 <ee3d3162-bba6-d65b-92d4-e44930b9110b@intel.com>
In-Reply-To: <ee3d3162-bba6-d65b-92d4-e44930b9110b@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|PH8PR11MB6705:EE_
x-ms-office365-filtering-correlation-id: 74550c46-481c-4ca6-85ee-08db4649c009
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9N9SnccVGtAkhqXfGvekEQdh+FWUGUWeRvxIH7xR4jZT+f8QEP4TedQcDwS9cpe2uvuXiuMqwqo5s/hIOvLiKm3pp3bn3s2HzNWiR+5IDoW30etnWYMLFZdYUYm2fPOwEc37grXhGU9wVs3wxBm6VXQuX0mERCnxJ0LUh4jVkQtaKRc3GBIGKyMPeRYekFAzSABTeOyF2wgAfO63jgOypgJ75CGftk8EjylwHARIgpsPnBIbMgPZSRZjvLzFd425m4/FvVzs2RM2JIo7GFJ57TiJ7XLWFZRdgPI2Pvx6KlszkahnNGG3GGLhZySdmn9z6gX65DOZTYivgGUOj+uPBnfTPn1DrYxVl9+BcHraKMK470QgObFAOtH4bl0yEQRbfEEwlSzFuqQwsoDgCXKZyn1IMaQggcsBK7pk9L3OooRJvPTGz594xFhznUX+gAQvMx4qncrJhcwY5CLWiQeYrHDh1WuIj6eLrHRc4xV3UBs9v758aJjeAXKRsfdTHE+M5Sqdyz7600bwSKOWGoPyuZY8AlNh1MFRkmDCH9R6xc/qZzJH2KXjP9z3lL4lsdBiOQA4ksxlh4hZj/ZyajJaEZpBaGgzyk9P2vXznPSA29WhsMi0sGXt5cTdgDUV5a+0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(396003)(366004)(376002)(451199021)(38070700005)(54906003)(478600001)(76116006)(66476007)(82960400001)(64756008)(316002)(4326008)(66446008)(66946007)(122000001)(6636002)(66556008)(55016003)(41300700001)(2906002)(6862004)(8936002)(8676002)(52536014)(5660300002)(38100700002)(6506007)(53546011)(26005)(9686003)(86362001)(186003)(33656002)(71200400001)(83380400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmpOblQ3M0xyMXBSV3R2Mk1iNGx2eTBmek1HOWlXcXV3a043K016b0padGxV?=
 =?utf-8?B?N2lWaFVyUVNFa3pqRnlEeU9xbGdMZ1E1UE9RaG5PbUhZU3l5WmoxWEVIaEVB?=
 =?utf-8?B?SE5GK1QyaGpTRStSdkREQjBieXRPc25nZWRubTBHcnRxVzBMU083akkyRytW?=
 =?utf-8?B?ZEFoMmtUS0JlWStCcmpDY2NrMVB5L21xU09naHhjZW0rajFMMi9MY0RkUmJn?=
 =?utf-8?B?VnViYXk0UXgyK1FEdkFVSG1XSVQ0VFlUd2FxeTN2STk3eSs2dlhHdjRmM1NU?=
 =?utf-8?B?dVE5RzRYQUN2ZHVaL1AzRTZEeVlFaGlIU3FGejdEVGFMSlBScVlFb0JSMXZJ?=
 =?utf-8?B?N2RCUUhWdHF1QXhCMlZCaDVFdEx5S0VTT3JINmRWZVRNS2V1MzlNellYVlRv?=
 =?utf-8?B?L3Zxdk9FZFVjNmxIdUNKWGd6dXdtZmhIWk9JWSs5RTNDT2pHQWZCc3U2NDkx?=
 =?utf-8?B?T2pvR1VLY3JpN0NHZk4wRGozejAyckQyNTkvY3Y3b0JqdUtZUFZCT1dmbXdE?=
 =?utf-8?B?K2kwR1VZNUNBS0FaRUpqRUZHMnJ2VHhtUFBncnJuT2VSK0Y4eVVSb2tTa1FM?=
 =?utf-8?B?Vk05R2x6elJkMG1HSW1iaUk0aFlzMlI3Z1ByYjJWeU5HU0M0UU00dWZSelFl?=
 =?utf-8?B?YmtrbllyUVExWWt0UzgwNmh3QXkxWUhQREtCNEhSWDg3dUdFa2o2OFJUempl?=
 =?utf-8?B?a3BST0w5MUU1WHMzT3AxRExVMDN1UUNNSC9QcEFHSzdTQzNHcnY0OGo5QTNy?=
 =?utf-8?B?dkZUUjF1aUNIZ21CVWloOEZUNGg5U3VWaEF5SDB0UUFpS1FraVErQTlNbHhH?=
 =?utf-8?B?V014cHh3N0F3N0Zrbkw3NDBlM0tXNnFhWmQvZXR4eGVtcXQza1FyZlNvT0FO?=
 =?utf-8?B?Q3M2aHEyQThGM1NZai9uTG1kdmk1dXNFU1NrWUo0bXBOS2JLR1EvbUpUb1ZU?=
 =?utf-8?B?TUI5eGRRTnRBbEttTVY3eURmMGZsNCtaeTR6RjRUTmtWdlNyc25mUVhsdEZz?=
 =?utf-8?B?VmozdEJHcVgzeEdoVzFMN2R6NEdabjVQR0tLbThUQXluZk5sVU1qUXdSQUt2?=
 =?utf-8?B?bXdhSGZoYlpUeVJFOURTcnlRMmJjRE1vejFkVTM5RmhOT0l6V0xkL1dlNWRJ?=
 =?utf-8?B?NTBNaEdXd3JYS01DS2ZPMEpIMXBDMVFWRXdFUHo1SkJLZmlKeE80Ukx0N0xB?=
 =?utf-8?B?RU02Y2NRRExIVjBFc0RMTTY5QmxQV05CamRaVDRhQVU2NUJSQm5nVk9vZ1Ax?=
 =?utf-8?B?d1ZLVFVuK0FQR0laQVdLRXhRMzRWWTVwUkVLckFGV3pLL1hUYkhFUzRUTzhN?=
 =?utf-8?B?WWtMUzhwUVZpT1d0TmJmbG1icGRBLzhpQ2Z0Y1hTWHloOHd2M21oRWNPS2hn?=
 =?utf-8?B?WU81TGcrVEVSZUh4VCtDcWJPYlJQREoydC9jNzEzUDU0VVBKZXcxcEY3WWQw?=
 =?utf-8?B?RWZQdXNPOW04VkNnekpQSEt0ODliQllKU0N2a3Q3dC9uSFpBM3J2M0ZHeVRo?=
 =?utf-8?B?cjVEWjJwWC94Q2trWUkzc1lpRzY5YU5MWlFOaTZoZUFZOE9XOEorTEt5M0hT?=
 =?utf-8?B?M2RldGExQmxnb01xOHJwOEZpcVJIalRiTWVaT29ma240OGhnb3ZKRmhuOGtC?=
 =?utf-8?B?WjVZT2U3WlFYVHlqS2pWa0dOdnYwZ3doeVBpRUdZWFRYL2hPOFp0WVJMbnNh?=
 =?utf-8?B?ZFFxWlN4dnkxYmpyZ2xEa0xTQVBnM1RKcEVtUUVDakF6WG8rNzlXanlSSmFx?=
 =?utf-8?B?VUV3WGhFYmF0WHRnaEdldlAyVGhOeDduWjlkbHZBN2FxVUhwTG9LTzNySnNO?=
 =?utf-8?B?R25BcGNwQ0ViS3lVL21pK05hdWNlMHU2YVVCSlc3MlJWOVVJckpzVm9jR0RG?=
 =?utf-8?B?bHRVZDVCRC9BeFZDT2NLVmN2YjVvUk4rN2lMRURpZzhabUU0NExBa0FUbGl0?=
 =?utf-8?B?WE1Sa0phWEhrWnVhMUZHRzh1bFVwTmNUS3ZVQkpUMjM2dHg0Y0Rpd0NpeHd4?=
 =?utf-8?B?Wm5xQ0xoaXIxZ0ZRRTI4Qm9WRlNIbVBYMXF5Vjg1ZzhDaXVaTGF6Y3FHc0xi?=
 =?utf-8?B?WHV5WTdIMlg1S3FJbitnRzFNMmZSQWt2bVdvSFZZM01TQmFWRGZ5OHVObytW?=
 =?utf-8?Q?z3pJmo92pbw3xEiueFNJo5ni0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74550c46-481c-4ca6-85ee-08db4649c009
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 11:31:17.1382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YmyzQMUs+/BjhlKSUW75xdKzQMOYO/i0xyLPO/mA3BFHN42CpEq6/ZHrLXNIGMCVx3GpJOthiU/2eFL6v6V2N/rqKSIVptgi3cQzsIzoBBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6705
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9iYWtpbiwgQWxla3Nh
bmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gU2VudDogcGnEhXRlaywgMjEg
a3dpZXRuaWEgMjAyMyAxNjo0MA0KPiBUbzogRHJld2VrLCBXb2pjaWVjaCA8d29qY2llY2guZHJl
d2VrQGludGVsLmNvbT4NCj4gQ2M6IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBFcnRtYW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0bWFuQGlu
dGVsLmNvbT47DQo+IG1pY2hhbC5zd2lhdGtvd3NraUBsaW51eC5pbnRlbC5jb207IG1hcmNpbi5z
enljaWtAbGludXguaW50ZWwuY29tOyBDaG1pZWxld3NraSwgUGF3ZWwgPHBhd2VsLmNobWllbGV3
c2tpQGludGVsLmNvbT47DQo+IFNhbXVkcmFsYSwgU3JpZGhhciA8c3JpZGhhci5zYW11ZHJhbGFA
aW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDA3LzEyXSBpY2U6IEFj
Y2VwdCBMQUcgbmV0ZGV2cyBpbiBicmlkZ2Ugb2ZmbG9hZHMNCj4gDQo+IEZyb206IFdvamNpZWNo
IERyZXdlayA8d29qY2llY2guZHJld2VrQGludGVsLmNvbT4NCj4gRGF0ZTogTW9uLCAxNyBBcHIg
MjAyMyAxMTozNDowNyArMDIwMA0KPiANCj4gPiBBbGxvdyBMQUcgaW50ZXJmYWNlcyB0byBiZSB1
c2VkIGluIGJyaWRnZSBvZmZsb2FkIHVzaW5nDQo+ID4gbmV0aWZfaXNfbGFnX21hc3Rlci4gSW4g
dGhpcyBjYXNlLCBzZWFyY2ggZm9yIGljZSBuZXRkZXYgaW4NCj4gPiB0aGUgbGlzdCBvZiBMQUcn
cyBsb3dlciBkZXZpY2VzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogV29qY2llY2ggRHJld2Vr
IDx3b2pjaWVjaC5kcmV3ZWtAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICAuLi4vbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfZXN3aXRjaF9ici5jICAgfCA0MCArKysrKysrKysrKysrKysrLS0t
DQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzNSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vf
ZXN3aXRjaF9ici5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9lc3dpdGNo
X2JyLmMNCj4gPiBpbmRleCA4MmI1ZWIyMDIwY2QuLjQ5MzgxZTRiZjYyYSAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Vzd2l0Y2hfYnIuYw0KPiA+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZXN3aXRjaF9ici5jDQo+
ID4gQEAgLTE1LDggKzE1LDIxIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgcmhhc2h0YWJsZV9wYXJh
bXMgaWNlX2ZkYl9odF9wYXJhbXMgPSB7DQo+ID4NCj4gPiAgc3RhdGljIGJvb2wgaWNlX2Vzd2l0
Y2hfYnJfaXNfZGV2X3ZhbGlkKGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ID4gIHsN
Cj4gPiAtCS8qIEFjY2VwdCBvbmx5IFBGIG5ldGRldiBhbmQgUFJzICovDQo+ID4gLQlyZXR1cm4g
aWNlX2lzX3BvcnRfcmVwcl9uZXRkZXYoZGV2KSB8fCBuZXRpZl9pc19pY2UoZGV2KTsNCj4gPiAr
CS8qIEFjY2VwdCBvbmx5IFBGIG5ldGRldiwgUFJzIGFuZCBMQUcgKi8NCj4gPiArCXJldHVybiBp
Y2VfaXNfcG9ydF9yZXByX25ldGRldihkZXYpIHx8IG5ldGlmX2lzX2ljZShkZXYpIHx8DQo+ID4g
KwkJbmV0aWZfaXNfbGFnX21hc3RlcihkZXYpOw0KPiANCj4gTml0OiB1c3VhbGx5IHdlIGFsaWdu
IHRvIGByZXR1cm5gICg3IHNwYWNlcyksIG5vdCB3aXRoIG9uZSB0YWI6DQo+IA0KPiAJcmV0dXJu
IGljZV9pc19wb3J0X3JlcHJfbmV0ZGV2KGRldikgfHwgbmV0aWZfaXNfaWNlKGRldikgfHwNCj4g
CSAgICAgICBuZXRpZl9pc19sYWdfbWFzdGVyKGRldik7DQoNCkkndmUgc2VlbiBleGFtcGxlcyBv
ZiBib3RoIHNvIGVpdGhlciB3YXkgaXMgb2sgSSB0aGluaw0KDQo+IA0KPiA+ICt9DQo+ID4gKw0K
PiA+ICtzdGF0aWMgc3RydWN0IG5ldF9kZXZpY2UgKg0KPiA+ICtpY2VfZXN3aXRjaF9icl9nZXRf
dXBsbmlrX2Zyb21fbGFnKHN0cnVjdCBuZXRfZGV2aWNlICpsYWdfZGV2KQ0KPiA+ICt7DQo+ID4g
KwlzdHJ1Y3QgbmV0X2RldmljZSAqbG93ZXI7DQo+ID4gKwlzdHJ1Y3QgbGlzdF9oZWFkICppdGVy
Ow0KPiA+ICsNCj4gPiArCW5ldGRldl9mb3JfZWFjaF9sb3dlcl9kZXYobGFnX2RldiwgbG93ZXIs
IGl0ZXIpDQo+ID4gKwkJaWYgKG5ldGlmX2lzX2ljZShsb3dlcikpDQo+ID4gKwkJCXJldHVybiBs
b3dlcjsNCj4gDQo+IEhlcmUgSSB0aGluayB0aGUga2VybmVsIGd1aWRlbGluZXMgd291bGQgcmVx
dWlyZSB0byBoYXZlIGEgc2V0IG9mIGJyYWNlcw0KPiAoZWFjaCBtdWx0aS1saW5lIGNvZGUgYmxv
Y2sgbXVzdCBiZSBlbmNsb3NlZCwgZXZlbiBpZiBpdCB3b3JrcyB3aXRob3V0KS4NCj4gSSBtZWFu
LCBJIHdhc24ndCBkb2luZyBpdCBteXNlbGYgdXNpbmcgdGhlIHJ1bGUgImFzIG1pbmltdW0gYnJh
Y2VzIGFzDQo+IG5lZWRlZCB0byB3b3JrIiwgYnV0IHRoZW4gbXkgY29sbGVhZ3VlIHNob3dlZCBt
ZSB0aGUgZG9jIDpEDQo+IA0KPiAJZm9yX2VhY2hfbG92ZXIoLi4uKSB7DQo+IAkJaWYgKGlzX2lj
ZShsb3ZlcikpDQo+IAkJCXJldHVybiBsb3ZlcjsNCj4gCX0NCj4gDQo+IEluIGNvbnRyYXJ5LCB0
aGlzOg0KPiANCj4gCWZvcl9lYWNoX3NvbWV0aGluZygpDQo+IAkJLyogU29tZSB1c2VmdWwgY29t
bWVudCAqLw0KPiAJCWRvX3NvbWV0aGluZygpOw0KPiANCj4gaXMgbm90IG1lbnRpb25lZCBpbiB0
aGUgcnVsZXMgYXMgcmVxdWlyaW5nIGJyYWNlcyA6cw0KDQpXaWxsIGJlIGZpeGVkDQoNCj4gDQo+
ID4gKwlyZXR1cm4gTlVMTDsNCj4gPiAgfQ0KPiA+DQo+ID4gIHN0YXRpYyBzdHJ1Y3QgaWNlX2Vz
d19icl9wb3J0ICoNCj4gPiBAQCAtMjYsOCArMzksMTYgQEAgaWNlX2Vzd2l0Y2hfYnJfbmV0ZGV2
X3RvX3BvcnQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gPiAgCQlzdHJ1Y3QgaWNlX3JlcHIg
KnJlcHIgPSBpY2VfbmV0ZGV2X3RvX3JlcHIoZGV2KTsNCj4gPg0KPiA+ICAJCXJldHVybiByZXBy
LT5icl9wb3J0Ow0KPiA+IC0JfSBlbHNlIGlmIChuZXRpZl9pc19pY2UoZGV2KSkgew0KPiA+IC0J
CXN0cnVjdCBpY2VfcGYgKnBmID0gaWNlX25ldGRldl90b19wZihkZXYpOw0KPiA+ICsJfSBlbHNl
IGlmIChuZXRpZl9pc19pY2UoZGV2KSB8fCBuZXRpZl9pc19sYWdfbWFzdGVyKGRldikpIHsNCj4g
PiArCQlzdHJ1Y3QgbmV0X2RldmljZSAqaWNlX2RldiA9IGRldjsNCj4gPiArCQlzdHJ1Y3QgaWNl
X3BmICpwZjsNCj4gPiArDQo+ID4gKwkJaWYgKG5ldGlmX2lzX2xhZ19tYXN0ZXIoZGV2KSkNCj4g
PiArCQkJaWNlX2RldiA9IGljZV9lc3dpdGNoX2JyX2dldF91cGxuaWtfZnJvbV9sYWcoZGV2KTsN
Cj4gDQo+IE1heWJlIGp1c3QgcmV1c2UgQGRldiBpbnN0ZWFkIG9mIG9uZSBtb3JlIHZhcj8NCj4g
T3IgZG8gaXQgdGhpcyB3YXk6DQo+IA0KPiAJCXN0cnVjdCBuZXRfZGV2aWNlICppY2VfZGV2Ow0K
PiANCj4gCQkuLi4NCj4gDQo+IAkJaWYgKG5ldGlmX2lzX2xhZ19tYXN0ZXIoZGV2KSkNCj4gCQkJ
aWNlX2RldiA9IGljZV9lc3dpdGNoIC4uLg0KPiAJCWVsc2UNCj4gCQkJaWNlX2RldiA9IGRldjsN
Cj4gCQlpZiAoIWljZV9kZXYpDQo+IAkJCXJldHVybiBOVUxMOw0KPiANCj4gT3RoZXJ3aXNlIGl0
J3MgYSBiaXQgY29uZnVzaW5nIHRvIGhhdmUgYGlmYCBpbiBvbmUgcGxhY2UgYW5kIGBlbHNlYA0K
PiAoaW1wbGljaXQpIGluIGFub3RoZXIgb25lLCBhdCBsZWFzdCBpdCB0b29rIHNvbWUgdGltZSBm
b3IgbWUgLl8uDQoNClVzaW5nIGVsc2UgbWFrZXMgc2Vuc2UgdG8gbWUNCg0KPiANCj4gPiArCQlp
ZiAoIWljZV9kZXYpDQo+ID4gKwkJCXJldHVybiBOVUxMOw0KPiA+ICsNCj4gPiArCQlwZiA9IGlj
ZV9uZXRkZXZfdG9fcGYoaWNlX2Rldik7DQo+ID4NCj4gPiAgCQlyZXR1cm4gcGYtPmJyX3BvcnQ7
DQo+ID4gIAl9DQo+ID4gQEAgLTcxOSw3ICs3NDAsMTYgQEAgaWNlX2Vzd2l0Y2hfYnJfcG9ydF9s
aW5rKHN0cnVjdCBpY2VfZXN3X2JyX29mZmxvYWRzICpicl9vZmZsb2FkcywNCj4gPg0KPiA+ICAJ
CWVyciA9IGljZV9lc3dpdGNoX2JyX3ZmX3JlcHJfcG9ydF9pbml0KGJyaWRnZSwgcmVwcik7DQo+
ID4gIAl9IGVsc2Ugew0KPiA+IC0JCXN0cnVjdCBpY2VfcGYgKnBmID0gaWNlX25ldGRldl90b19w
ZihkZXYpOw0KPiA+ICsJCXN0cnVjdCBuZXRfZGV2aWNlICppY2VfZGV2ID0gZGV2Ow0KPiA+ICsJ
CXN0cnVjdCBpY2VfcGYgKnBmOw0KPiA+ICsNCj4gPiArCQlpZiAobmV0aWZfaXNfbGFnX21hc3Rl
cihkZXYpKQ0KPiA+ICsJCQlpY2VfZGV2ID0gaWNlX2Vzd2l0Y2hfYnJfZ2V0X3VwbG5pa19mcm9t
X2xhZyhkZXYpOw0KPiANCj4gKHNhbWUpDQo+IA0KPiA+ICsNCj4gPiArCQlpZiAoIWljZV9kZXYp
DQo+ID4gKwkJCXJldHVybiAwOw0KPiA+ICsNCj4gPiArCQlwZiA9IGljZV9uZXRkZXZfdG9fcGYo
aWNlX2Rldik7DQo+ID4NCj4gPiAgCQllcnIgPSBpY2VfZXN3aXRjaF9icl91cGxpbmtfcG9ydF9p
bml0KGJyaWRnZSwgcGYpOw0KPiA+ICAJfQ0KPiANCj4gVGhhbmtzLA0KPiBPbGVrDQo=
