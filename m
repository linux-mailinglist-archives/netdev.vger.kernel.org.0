Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242E34B6A05
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbiBOK7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:59:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236785AbiBOK7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:59:11 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065CDDD973;
        Tue, 15 Feb 2022 02:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644922742; x=1676458742;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=0jQo1ZsnwFWu0vvlQPA7wAfy0LnhmDZsxi8pSQps/Qk=;
  b=fdR7SF46Y0Q4Ck9i553aX0+yNLPcjnnD/yQQS8VysCFNR+hEondDTJvQ
   yt7TYjuYDE8q8s172JLmXVEfx10muQBbnbLyuT5vDv18jdZazmkvTtR+r
   wqbO2ewbFpfiXrEbkPBkSQw1ExNToeYnusqxK+MVTPA65Lvv5/+4iW67I
   yDbLZU6hhG4WsBzg8xiCKcd1XpraJC5VNLK4TOitDJMpqfBpVnQ7wbeJO
   shYwVGeB0+FMjjUnuG9XwQ1W3DXkIA6GVNOAiW//ZmKoVYYPeuxdJWhGG
   6pHETBDqFbbBKdvl+B6ooi5yK7pejLEpAz4mN/U8LmUZSJhyo6ULU+UlN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="230954868"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="230954868"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 02:59:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="775777834"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 15 Feb 2022 02:59:00 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 02:59:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 15 Feb 2022 02:59:00 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 15 Feb 2022 02:59:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wc5GDlbO0jT1X6UqgwhaY0P2HZKUfLz5plxXYRtGK4/rnFg8DocFTlny3ICZezagb0OM3cgoy6qgOEfXkZ/6+MryF9LUyFreaRmmFfcV7C7jbVh14Fe6w3ooqVxskNIGdxfZdhBrjqKHjCnk03WRkccQ//PXJFxIaVOuOGos9ACznyrQA7aLkwoyqDxrwGJ2aM7EM9xR/kK8d1mtn6swFmOvCe5767/afdEx6+VmwvfyEr1/7BBiz9SptY8y6sQ90ezXeo61+F1MxmCLSNKK92WAeIF+woqZA54flQSXV13uQ3ANuHWxADbX/V228e8ndR5cYhB1i8oXRoQ1B8CNDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jQo1ZsnwFWu0vvlQPA7wAfy0LnhmDZsxi8pSQps/Qk=;
 b=GpnzCKbTw9Z4aZU/dbKPRZFxuoruxrSw9fdjRNpJnshWxVUJUaf113NGz3rpOf3YA65fwqoiMrOivjAo+nMXlkr5ldRtjDK9Br//u1K6Kw4CtZbtef/mThbJDUHVzgfJyq19KpSllZU5uiM3Xd6DoWsF5mB6yTrT3tio0Drqs4xNxCu2KklERSjYUBPILFk6ICI4C/q6UkLHc7HL4YTnKskxDFMa04jTzBA2UiazjAbiFqcD1rV8CdqFaWPSvOPtApiQdsgyG3KCQ8Ih44e5hi7282YFmP424iBoIjPpL4oE448GMsvR5twXenGIy9kxoIzwGQ9jc8u6nOGhkTJQow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4528.namprd11.prod.outlook.com (2603:10b6:806:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Tue, 15 Feb
 2022 10:58:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 10:58:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V7 mlx5-next 08/15] vfio: Define device migration protocol
 v2
Thread-Topic: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Thread-Index: AQHYHEd8WrQ75CuCwEmQ+4nXbJWyQ6yKWZwAgAAploCACfA7AIAAB9xw
Date:   Tue, 15 Feb 2022 10:58:58 +0000
Message-ID: <BN9PR11MB5276C361E686DCAFA8A078788C349@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <20220208170754.01d05a1d.alex.williamson@redhat.com>
 <20220209023645.GN4160@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cae3b3b-330f-4670-455e-08d9f0722ae5
x-ms-traffictypediagnostic: SA0PR11MB4528:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SA0PR11MB4528E468E799186D534981808C349@SA0PR11MB4528.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ZrwlqPa2gHi4ztvPhGMkIQONaj04Pcb4H2bL/nHNCf6dzMskSjcBQ/yiGm2DzPPP0LLUPWdsCTFqL4pkSEDhJsm3Q8LsCGSc2gi0/MHAAywU5KgUr0o8JjwaeNt++bz6tMSn+f8i+hyH0YlvOKIWn8TPB2Lc1cJvOE08/YaHW71BciCGAV5cci9o2c/qshLCZVonKuNt+EAZSecAxcV4I27SmQHyC6MqF/kEJVM5ch7nFu2iziKJR2N6lPhNv8gWcJxndHTS2spa1fIJO2if6ak2JUjxpJYcnPIQNFn1jWSL0sj/H9z+mHlLlS98QFrBkSxTclMtq4c4TqQGvsXnWDeeqYIy0NDQe5whhiBZ6ab2FOmcobho8robfx61KjnmxmbqMsLH1L5zcIP0mpIRPy74tzRPYXlMSXA5K2whSHr6Ox+1nInP0hMTm1K649THxh2aghmnm4CzvB3PttBU/t47LvuVY4yBq4RGgyFm+a4w1hI4fqZ50k+P3Mn5pfTRkiIXD5i69IZz035g4aaRw+i8/vIxJUIXl3Ezfd1GOHgmkgtqZRPx8CMWigoLFCutmL529JOSBzFLpZ1SBRyJqhCzAF8hIqBCwSqUabC0qXNuw3xTvrkb5d1tyN5QEh4dTarTR5EUe1ooHW8kw2QLISI2xxyxd6iAb8fhYyCEYCs63k2g9uV+a/mpxl1HLlkyDPaFDshPbr7SoVSoodcFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(508600001)(71200400001)(2906002)(6506007)(38070700005)(55016003)(7416002)(7696005)(33656002)(316002)(26005)(66946007)(82960400001)(9686003)(54906003)(4326008)(83380400001)(66556008)(122000001)(110136005)(86362001)(38100700002)(52536014)(8936002)(76116006)(8676002)(66476007)(64756008)(186003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVN1ZnNPSXMydVdmWkN5eXduZHFnTzZIdlBCM3NvWTk3MzBJU1NLeWthdTFu?=
 =?utf-8?B?RmRLK2xMOVprMXZCQi85RlYrenAxMmJFbE8wVS95eDAvbUZJV0lySTArYWc1?=
 =?utf-8?B?d2VnbGxxR2tOdVNIRFRlRWwxVElGRHRzaVc3NUowcDRWZU9ETlA1Q2ZBNXRp?=
 =?utf-8?B?Z3p5ckNIY09Mbno1TzZ2QU1DRUhVRE1lU3NLZ1NvUHlhQzRlZ05IQ2RnbXBu?=
 =?utf-8?B?a0Y0YXBCcCtucWVEV3orNmlPblI1aytwTjZROTEwSzV4T2dTcUovb3JQK0kw?=
 =?utf-8?B?Y2RXbnZsZjlMZEFETFBPSUM1ZlZOZnVXSDQ1cnB2ak1PQlNYUC9ESUhpcXUv?=
 =?utf-8?B?ZkZWZ1ZUSmtRcXlWditMaE52VzlFTndlMndtU25LSXN3QXZlWXZJNW9DMyt4?=
 =?utf-8?B?WU1GOC9mRFBYMDYyUktCSWl3K2VKSXFnSUtoaE8yaW5iYkxHRU5PZjR1dnV2?=
 =?utf-8?B?U082T3FyOWVONjRVdzZXbFBQdHhqQ1VoaTB6OVZuL21td1RCektBTWpxa2Fj?=
 =?utf-8?B?Z2dmRzNDQWl1Uk5LTzdNTUdIdSttV2IrTzBpNGM4TEJiRUN3Y3ZneHVsTzZa?=
 =?utf-8?B?bWtPU21mTEFMejJTWUdsYWh2alB3RmRYSHlXVEZoQjE4VHRCMnQ2RHJJRStk?=
 =?utf-8?B?clJ0Z25MN2tXVmVYMzVaYWpPMzhLRDc2VFFJM05BTThMRVhPaUdhSVVHa2xp?=
 =?utf-8?B?N1FrK0tYckpZT0xsMmRXbHFLazByUkF6b3paaXdnRDRzaDdaV24yUW5QR0x1?=
 =?utf-8?B?elIzUzZEUmZ5Zm5zS1ZjdXJjR0VrbmZWeDM4QkE2T09lcWIxQ1Q0MzFwcDZO?=
 =?utf-8?B?VSszcTBKODJNbXkveko2VzNWVEVVcmNwM094czJFcXhHejhSMitaakRZaE9h?=
 =?utf-8?B?b0hJdE43YTdlYlZWRFBWMitXNmNLODFPRExGclJsY0FLdjlkTWQ4eTRXT2M0?=
 =?utf-8?B?emZVQjBTMGFFTHIxZGsrNWUyMEp4NlRIejl5NThnWFl2VXhuc3BNckk1eUhI?=
 =?utf-8?B?ejRlRitTYUtqM1F2NlM0Vk1ZbWNNSHpZWHE3T2o5U1A0YU5jajV2V3k4dkFa?=
 =?utf-8?B?OEU3L2RnNnhhWkcwdGhKUmFvREx1UWRPOVZVUTEwT0NjU29tK2pIdTBsTGJx?=
 =?utf-8?B?UFRlN0pkbksrcUVDcjkySmppMGE3RHJ2cFZQVnN1Yjc4MFVYYzR0Y2ZyVUhB?=
 =?utf-8?B?eG42cHlJVS90TE45bFAzbTVub0RGdFRYZi9FWnJZT0pidHhmYlV2c1FIVS9B?=
 =?utf-8?B?U2NDMnZXY1U4MHFrV25hQjJXaWdyUUluSHN1V2gvUzBXM3Y5bUY4UTIwdXdL?=
 =?utf-8?B?RTQvK1VGRmhtd2YxSk9zZmtqTTN4K2RKOXBCY3c1ZDkrZ3lVck5rL3B6YnM1?=
 =?utf-8?B?dDc2Nkd0U0dOU3ZBUG5TdGUwNnRsUFIrdFdNUHNRVHJINW1Tc1B1UkJyRGZx?=
 =?utf-8?B?L1dNYm1Ubk1UOGJkU2tBMW5MY3NLdlQ3TDdzbURmMUFnT2RFQ1RiSld5RjV0?=
 =?utf-8?B?a3VIUXBpZ1VxVDdDdHc3UEJxL0pOTStPV0Y3THRrQUxLeG83VXlSZHlkYkg4?=
 =?utf-8?B?ekUwUjlZQzZ3V1JwYXVaeWltMkE1aUpLc3BKL21tZ0J0MUVsOGh0Smduemd4?=
 =?utf-8?B?Zld6elI3ZXpiUmxpSGlPVktqTEplYWNEL0RmZmxMRDZjRVJ1aTYxVTZuVGhD?=
 =?utf-8?B?RUtyUFFyclpyVEI5VEVHc2paVlNwdWJ3UEI5MUNKUGo0ZlZ0N2tMVHVzS2hl?=
 =?utf-8?B?YlN6dDJvT1BFc1FsTDVzOGNJL01ScmsydW5LcVJzR0Z0WktLenV1QXduRERw?=
 =?utf-8?B?TmsrZmFHN3ozdE5WY2o0NmpRejN0RFJWRWdaMWxNTE1Ta2xXdHRWYjZlZGtQ?=
 =?utf-8?B?Z2Z6aVBXNWFlWHVLS2J5NU5IazI1cStHNnE2SjMzQlV0dDIwaDJGSk5XNXpW?=
 =?utf-8?B?WkJMUUNEdmZXK2tBUEdvNGtmMTQ2czhMTU9TeDVKTzk5UEV6M1NzMlpITmk5?=
 =?utf-8?B?RXRlbHUxNGMzQWtDcXdlSTZ3ZTdGaUtrNU04eXo3cDVSYjNOYXB5TndHZmJE?=
 =?utf-8?B?L1FvaVMwUDdYaTc5bXVKYXh2YmV5dFo2YkF1TTQ3U0srQWFyZ1dNUW1EVU1Y?=
 =?utf-8?B?NDVkQnI4akpoR3hiN3VzZzZYYmV5dkxUMFZTZUZXVFlPNksrRzBhZDEwN3J4?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cae3b3b-330f-4670-455e-08d9f0722ae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 10:58:58.4992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nkwYK4CRHAZXl2RhjAUzv8z5isnwpbFnVT5hNsx5rj5YAu/iCtS1uiIjfO1cS3TrBsQp9urJMd/NFh8IdHbZSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4528
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAxNSwgMjAyMiA2
OjQyIFBNDQo+IA0KPiA+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+
ID4gU2VudDogV2VkbmVzZGF5LCBGZWJydWFyeSA5LCAyMDIyIDEwOjM3IEFNDQo+ID4NCj4gPiA+
ID4gIC8qIC0tLS0tLS0tIEFQSSBmb3IgVHlwZTEgVkZJTyBJT01NVSAtLS0tLS0tLSAqLw0KPiA+
ID4gPg0KPiA+ID4gPiAgLyoqDQo+ID4gPg0KPiA+ID4gT3RoZXJ3aXNlLCBJJ20gc3RpbGwgbm90
IHN1cmUgaG93IHVzZXJzcGFjZSBoYW5kbGVzIHRoZSBmYWN0IHRoYXQgaXQNCj4gPiA+IGNhbid0
IGtub3cgaG93IG11Y2ggZGF0YSB3aWxsIGJlIHJlYWQgZnJvbSB0aGUgZGV2aWNlIGFuZCBob3cN
Cj4gaW1wb3J0YW50DQo+ID4gPiB0aGF0IGlzLiAgVGhlcmUncyBubyByZXBsYWNlbWVudCBvZiB0
aGF0IGZlYXR1cmUgZnJvbSB0aGUgdjEgcHJvdG9jb2wNCj4gPiA+IGhlcmUuDQo+ID4NCj4gPiBJ
J20gbm90IHN1cmUgdGhpcyB3YXMgcGFydCBvZiB0aGUgdjEgcHJvdG9jb2wgZWl0aGVyLiBZZXMg
aXQgaGFkIGENCj4gPiBwZW5kaW5nX2J5dGVzLCBidXQgSSBkb24ndCB0aGluayBpdCB3YXMgYWN0
dWFsbHkgZXhwZWN0ZWQgdG8gYmUgMTAwJQ0KPiA+IGFjY3VyYXRlLiBDb21wdXRpbmcgdGhpcyB2
YWx1ZSBhY2N1cmF0ZWx5IGlzIHBvdGVudGlhbGx5IHF1aXRlDQo+ID4gZXhwZW5zaXZlLCBJIHdv
dWxkIHByZWZlciB3ZSBub3QgZW5mb3JjZSB0aGlzIG9uIGFuIGltcGxlbWVudGF0aW9uDQo+ID4g
d2l0aG91dCBhIHJlYXNvbiwgYW5kIHFlbXUgY3VycmVudGx5IGRvZXNuJ3QgbWFrZSB1c2Ugb2Yg
aXQuDQo+ID4NCj4gPiBUaGUgaW9jdGwgZnJvbSB0aGUgcHJlY29weSBwYXRjaCBpcyBwcm9iYWJs
eSB0aGUgYmVzdCBhcHByb2FjaCwgSQ0KPiA+IHRoaW5rIGl0IHdvdWxkIGJlIGZpbmUgdG8gYWxs
b3cgdGhhdCBmb3Igc3RvcCBjb3B5IGFzIHdlbGwsIGJ1dCBhbHNvDQo+ID4gZG9uJ3Qgc2VlIGEg
dXNhZ2UgcmlnaHQgbm93Lg0KPiA+DQo+ID4gSXQgaXMgbm90IHNvbWV0aGluZyB0aGF0IG5lZWRz
IGRlY2lzaW9uIG5vdywgaXQgaXMgdmVyeSBlYXN5IHRvIGRldGVjdA0KPiA+IGlmIGFuIGlvY3Rs
IGlzIHN1cHBvcnRlZCBvbiB0aGUgZGF0YV9mZCBhdCBydW50aW1lIHRvIGFkZCBuZXcgdGhpbmdz
DQo+ID4gaGVyZSB3aGVuIG5lZWRlZC4NCj4gPg0KPiANCj4gQW5vdGhlciBpbnRlcmVzdGluZyB0
aGluZyAobm90IGFuIGltbWVkaWF0ZSBjb25jZXJuIG9uIHRoaXMgc2VyaWVzKQ0KPiBpcyBob3cg
dG8gaGFuZGxlIGRldmljZXMgd2hpY2ggbWF5IGhhdmUgbG9uZyB0aW1lIChlLmcuIGR1ZSB0bw0K
PiBkcmFpbmluZyBvdXRzdGFuZGluZyByZXF1ZXN0cywgZXZlbiB3L28gdlBSSSkgdG8gZW50ZXIg
dGhlIFNUT1ANCj4gc3RhdGUuIHRoYXQgdGltZSBpcyBub3QgYXMgZGV0ZXJtaW5pc3RpYyBhcyBw
ZW5kaW5nIGJ5dGVzIHRodXMgY2Fubm90DQo+IGJlIHJlcG9ydGVkIGJhY2sgdG8gdGhlIHVzZXIg
YmVmb3JlIHRoZSBvcGVyYXRpb24gaXMgYWN0dWFsbHkgZG9uZS4NCj4gDQo+IFNpbWlsYXJseSB0
byB3aGF0IHdlIGRpc2N1c3NlZCBmb3IgdlBSSSBhbiBldmVudGZkIHdpbGwgYmUgYmVuZWZpY2lh
bA0KPiBzbyB0aGUgdXNlciBjYW4gdGltZW91dC13YWl0IG9uIGl0LCBidXQgaXQgYWxzbyBuZWVk
cyBhbiBhcmMgdG8gY3JlYXRlDQo+IHRoZSBldmVudGZkIGJldHdlZW4gUlVOTklORy0+U1RPUC4u
Lg0KPiANCg0KdHlwZSB0b28gZmFzdC4gaXQgZG9lc27igJl0IG5lZWQgYSBuZXcgYXJjLiBKdXN0
IGEgbmV3IGNhcGFiaWxpdHkgdG8gc2F5DQp0aGF0IFNUT1AgcmV0dXJucyBhbiBldmVudCBmZCBm
b3IgdGhlIHVzZXIgdG8gd2FpdCBmb3IgY29tcGxldGlvbiwNCndoZW4gc3VwcG9ydGluZyBzdWNo
IGRldmljZXMgaXMgcmVxdWlyZWQuIPCfmIoNCg0KVGhhbmtzDQpLZXZpbg0K
