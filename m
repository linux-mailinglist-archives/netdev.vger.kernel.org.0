Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780B94B7E4A
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343844AbiBPCxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:53:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343842AbiBPCxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:53:12 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7E8FBA71;
        Tue, 15 Feb 2022 18:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644979980; x=1676515980;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+oQRDbuYY4zh6D/i1/wdu5kkRxNl/QtzwWXvEWafgU4=;
  b=ETdKm/AdmITpcD65E13MG5iHSAH9KlsrWuEesvyvzgGEH89Fw8dcb6fJ
   b+zZdljMWB5+QTRELTZ6sn27ELDD3vjKAkCFKiMwlF0jzSG+qYBfH1QbP
   ir/IJ6gcdd4PNHadyb8DBm4YzRkGaPvmRriw6gbl+S1U+JBBZCMbnSW+4
   tCgKV7zvxyZOTwenWdXxLfJch6TQEykO0PnYLvYfc3u0ulkUp+i3L5CH+
   wqCD3UnKOJJ6fW1im94Vrmsqc56wokhu6cdUHuT6JU9MYCKQV00l16oXJ
   5dpFk/cTHc0jZuddLIbseR2Ecsl9R2DxmiSoCKFZ117cvP6O+d7FcctFa
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="237913333"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="237913333"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:53:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="588125636"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2022 18:52:59 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 18:52:59 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 18:52:58 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 15 Feb 2022 18:52:58 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 15 Feb 2022 18:52:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adyjm4SgdoznyMXN7AYrAnpv2+ksdv3H8JXfX41B+jsEU30tAkfSP8BvXCMX1Yjpz48OkVDD8g6nBYxATivZxUFDplWoHE/C9607KtLa7p1FqUoaMP2OxByTxeDOiaXrUetYKH6FnhuHBcCHqaTFq8dkZsIwpO/kmmRkK/3kJkSC4ia8S1vyjX4+PloUIDW6wD1wwqnY0u5whG32AylsYZe2fXZbCOxTRfCIxgEPMKnoM+XJE++Z/WomFbvWWTH+vk4WLOo2P90kcdOvU2aTLmqfe747F1doI9VWXee3OMJeDo2N7gXl5pue1M662bTQF5gCwejkUplW7Iyuu2qANA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+oQRDbuYY4zh6D/i1/wdu5kkRxNl/QtzwWXvEWafgU4=;
 b=HCOcBIJMlzaCkSPUjYbsZ2aEOGkJwA1eYTvoGdBLKHM3FWOdC5XRgHsefykrjHNqnfI4+jZjzF0HERlUuekKgGBp0raO6q9TeaiEWuaA+qYSuwfUX7ZE8DF5GwjnG8xjgEmvu+k7TabyJyj4GNaoaePWApGjPDjlFV+NnQH1DSBHz5FwJ2rNzy+yi2l7nx6wrtWtruWC17KsPb7eM6V1L5l+LEEZqkKNM8oYzog7xE1mKwl//JyNJq1O8gHdQwYSr34uNb1vb9342+DJz+WpCKBpGKpWh7uM015JY6C87VXocwOyBXWrncC9smgMO6BHy7DN101F55OqqMML8w4xhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3907.namprd11.prod.outlook.com (2603:10b6:405:83::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.14; Wed, 16 Feb
 2022 02:52:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 02:52:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH V7 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Thread-Topic: [PATCH V7 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Thread-Index: AQHYHEd+yjnoZ8pnEEOIRNVo6epEhKyUVd/wgAB6oQCAAKM4kA==
Date:   Wed, 16 Feb 2022 02:52:55 +0000
Message-ID: <BN9PR11MB5276BED0FC008B974B8750058C359@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-10-yishaih@nvidia.com>
 <BN9PR11MB5276D169554630B8345DB7598C349@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220215155602.GB1046125@nvidia.com>
In-Reply-To: <20220215155602.GB1046125@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88ce460b-c87d-4438-8e48-08d9f0f76ebe
x-ms-traffictypediagnostic: BN6PR11MB3907:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB3907F6CD5E7F6F3CEC07EE468C359@BN6PR11MB3907.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QaCm2ywlYMhPE0S1NTL5NNksPWxOCU0hCuOFmgLLpG7mWD9ie2fDlnGmaeoxN2ITuxUHuXIvpW+hH4RCqsEzNTSI7QuS7ZhP2r1qFIrIvy1UbcCL5BDXhKAwntu+yrokqnODWMNhAFFzY/7UJBmRNUPNSAwP1A17D0cWO8vkrAX8MNHr77jG4GraIrkrmaRL0KjFC2Z+AiQhUiZ431V/RQ8GrjGFMqyefLV1Yk2qHk5RD2OjSvFIVAEGaHsTTFmihluL1z4NZjYNtHLVvh/f3wKA6uQwM9pY6w3QjOjeggS9Cxg5CJTUDArdEeFRop3CTkq+fFE2hb1m9pacTKQDcExzIpU62elEy4OPr3tmyTTq3fNNpP+tfrhF1mWR5GdfR36JjW/HM02H0s8wMZOjWH31yQA9+cin5ajTATUGAGozcIi9BOB2rL6K+TDkFWYSAxJjXlwHUl2raT/c2jhpPoO7nqUh6VGQt7fGdvTdaJAriyDUyIOWZamiuapydWGap2SM7rbWS0Uk+DV7pl+q6KDaHPCI5AyjfKEGIqL5gRJxjtTdlN+gGdq8VLinP0ttqRbAL4XyxCF9y1mG9JKn9kgjFmObycOWZnY4ecGvi2K1MnMlDEA6gj3d8KuHeWpKM2pfOwVaPVPaEg8dGdg5CSXcAt2s0TVLGTGOOm59M2HX8GFC8G1so0MvsQe+FKNBtqEdVrtj9ENESw9Mq0OwhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(71200400001)(33656002)(122000001)(38100700002)(83380400001)(82960400001)(186003)(6506007)(86362001)(7696005)(9686003)(508600001)(76116006)(54906003)(7416002)(4326008)(6916009)(38070700005)(8676002)(66476007)(64756008)(66946007)(66446008)(2906002)(66556008)(316002)(8936002)(52536014)(5660300002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3BqdG9KR083VlRtOU1wN1pxZWNHaDRXN1cxL1NvYjl4d0VrdkZaWkt6cmxI?=
 =?utf-8?B?anJMc1hudGpCM2VHeUlPSjFBc05OZnltcjFhV080RHNhNndFUEJ0aWNtQXZH?=
 =?utf-8?B?OWs2Q2kxQm1PRU9pbVorSlIxejBMWk1tZkdDN1E1RXorbkkxMFlhOFVONVpi?=
 =?utf-8?B?VmJJc3BVQ09SeWhET3JvU202eVVRSVhSb2hXMkpYNkMzWUp0eUpNSmdpTExp?=
 =?utf-8?B?UHppeWhXd2l1YXM4Uld4UWxpMmNMNXBzVVJ2WmFaaFJWaW1VNHlWZUcvS1Rz?=
 =?utf-8?B?WTFXNUhvejRLTm14bllxeEFBdTJLeCtnZWlEQ1ViOXZWMGN2T0FCeEczcnh1?=
 =?utf-8?B?ZThCS1pSUUhGRExxY2xROERCNXBsZmpubWJ0UnpCUzUvNitBa1V3cEltRExr?=
 =?utf-8?B?K3IybC91eFZoYVpDbTdNdkIvdTkrc0V5bUp1MVFybzZpdGhMRVp5Mk5XTWhu?=
 =?utf-8?B?N2tES0wzOWJkM1dFN0FtdVdFRDVOT2dCNTFUbEE4YTIzRWxsTWZvV0RSaE1x?=
 =?utf-8?B?VE9GSGF2K2NFeE1kemEyNkhNalQzaE9zblpkb1Uxd2hSeDhqbFlkUDVNNVl3?=
 =?utf-8?B?NXZPL2o0S0RFNDRWVTN4Sks1TWw0NCs3ckg5RFl3RmtkK0R4UWkvdXU5cFVU?=
 =?utf-8?B?SlRvZXhNSElhUzZJanhVbGdTR250cmVJaVVOdVFaeFFXTkY0VWJuL1owTHFm?=
 =?utf-8?B?SkdMTjZLR2tjMk9QU0NJOU9Va3JiM0NsK29yZk1zbkpvdG9QbnlkeE5qMkZF?=
 =?utf-8?B?OWJ4cmlPWGhrcnJRS2N2YVFKTFMrYTFuVWVNK1Bac0R1dUVWN21MT3NLeDZZ?=
 =?utf-8?B?RU15QXcwYlI5cEF1R1lkNzBNRkhQa0ZYb1ZyS2dxMWt6aFc0SzBiOU9NNy9s?=
 =?utf-8?B?RkRQQS9CUEtzQmo0RkI4RXFndnFUemFydVR4QUduZ1JQc0R1TTNSRU40VzRn?=
 =?utf-8?B?b3FQUEdjNDg5S0RBTC9Wek9nSUZWTjdCeTJWQ0w2R0RoMEpXZTBwY1YwVy9s?=
 =?utf-8?B?b3MweHY0dHRvdFFUc0J6bjNGWjNHaW82dzJjVmtGRVIzMDZkVzJyTmV3Skh1?=
 =?utf-8?B?LytDYjdFZUhHNllGcFhuTlpYV2lqbC9FNmExeHNhN2haNWFzdktKcXZsMXBJ?=
 =?utf-8?B?cjJBNkxrNmJjZUVoSFc3V3ZhZWRPdHB5TGNXUHArQWtpbTNDVE4xM2owb3pt?=
 =?utf-8?B?WExaU0laNVM1eU52VE9MQ3M5ZkdwQU52SVNkeTBPQlRPMWZLRGRrbDI4aTR3?=
 =?utf-8?B?ellOaWw5NnRTNmN1enArQWUxc1k0WktnUzVOOFdaRUFORGpBSnpwbnFtZmVn?=
 =?utf-8?B?WXJFSEpiM1FNN3gvZFVhM1RNV0hLdC90S2NMVkdFOHhkaGRZK1pzMHdxSGpr?=
 =?utf-8?B?WGJib0IwcEk5TEl4UW5LVjhUVzdCeHVsbXNZb3VyelVSeEVueE8wRmNaemtn?=
 =?utf-8?B?MnNNektKMktZcnpFWGN1Q1NGSkRaa0wrbFhyanZ0UExwQkF6anpmeGFiZGk0?=
 =?utf-8?B?UG96Um1TWlhtamhkSkVWMGJKZlpJb3pNMEZrYlhsdzN1S213RHNMc0pBNWtG?=
 =?utf-8?B?R1RVZmFqbVZ5T2lMS2dyTWt5T1hmYWxGRVp2SnM3YTUvVDhRbW4vR3JoZEJs?=
 =?utf-8?B?eUJKdXNZSmRURFJDNmFmcUdVd3JEQW0xWDVFT2ZUQU9rZjl1bE5HYWkzdEs3?=
 =?utf-8?B?eU1oeFE5K0VFT0EwQ3IxN1RIMmdMTEppbmozWjFKaTRFcURMVUNWS1JKa0p2?=
 =?utf-8?B?YSsxTGE2b0lpRjNlUnRCZHQrb2Rxc2k5d0p2TU91ZitRdEk2enl6V0JSbWIx?=
 =?utf-8?B?cnkvbDloc1pDT3hSY0dyTXYvMEZtSHlNUzNZNHgvQm9uaHNRQnIrM3dYc3Av?=
 =?utf-8?B?ZlBqQysyRHkzZXJnMjF3TVpyMGFvSHF1cGF6R2t4MWpPOFJ1aUdBWWZLeWNy?=
 =?utf-8?B?L1hoMnpHY3RVVjlYL0lmSitYcjk4YmNZRnMwcUZ0aG1UdVRuVWdnZTVWTHhj?=
 =?utf-8?B?MHJobkN6RmdHNHZ1aS9MVEZPLzJnUlE3T2VMQ2w2NGl6aGMySnJXcDhLaUls?=
 =?utf-8?B?bTBjWFd4UU9aVHlCRjY3WUZwalh3TGpPRDdjMlVVRzFsYWxpMGRWYzVsSFZP?=
 =?utf-8?B?UnhqcS9IMktpRnR1Z1pwbXk4Zm03SmhJYVlISEtqcUIyQ3lzcGlBd2d0SE81?=
 =?utf-8?Q?KEK4T8/efvzcelsIpN+3XXM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ce460b-c87d-4438-8e48-08d9f0f76ebe
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 02:52:55.3644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DwPAXhmv2gSkpI4olTQybbtAyV6DXruCargS64Il8oZR79d15/nPmbTGJtvA7SqDDIsWHSmaT42WI9bnhRVfaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3907
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBGZWJydWFyeSAxNSwgMjAyMiAxMTo1NiBQTQ0KPiANCj4gPiBEZWZpbmluZyBSVU5OSU5HX1Ay
UCBpbiBhYm92ZSB3YXkgaW1wbGllcyB0aGF0IFJVTk5JTkdfUDJQIGluaGVyaXRzDQo+ID4gYWxs
IGJlaGF2aW9ycyBpbiBSVU5OSU5HIGV4Y2VwdCBibG9ja2luZyBvdXRib3VuZCBQMlA6DQo+ID4g
CSogZ2VuZXJhdGUgaW50ZXJydXB0cyBhbmQgRE1Bcw0KPiA+IAkqIHJlc3BvbmQgdG8gTU1JTw0K
PiA+IAkqIGFsbCB2ZmlvIHJlZ2lvbnMgYXJlIGZ1bmN0aW9uYWwNCj4gPiAJKiBkZXZpY2UgbWF5
IGFkdmFuY2UgaXRzIGludGVybmFsIHN0YXRlDQo+ID4gCSogZHJhaW4gYW5kIGJsb2NrIG91dHN0
YW5kaW5nIFAyUCByZXF1ZXN0cw0KPiANCj4gQ29ycmVjdC4NCj4gDQo+IFRoZSBkZXZpY2UgbXVz
dCBiZSBhYmxlIHRvIHJlY2lldmUgYW5kIHByb2Nlc3MgYW55IE1NSU8gUDJQDQo+IHRyYW5zYWN0
aW9uIGR1cmluZyB0aGlzIHN0YXRlLg0KPiANCj4gV2UgZGlzY3Vzc2VkIGFuZCBsZWZ0IGludGVy
cnVwdHMgYXMgYWxsb3dlZCBiZWhhdmlvci4NCj4gDQo+ID4gSSB0aGluayB0aGlzIGlzIG5vdCB0
aGUgaW50ZW5kZWQgYmVoYXZpb3Igd2hlbiBORE1BIHdhcyBiZWluZyBkaXNjdXNzZWQNCj4gPiBp
biBwcmV2aW91cyB0aHJlYWRzLCBhcyBhYm92ZSBkZWZpbml0aW9uIHN1Z2dlc3RzIHRoZSB1c2Vy
IGNvdWxkIGNvbnRpbnVlDQo+ID4gdG8gc3VibWl0IG5ldyByZXF1ZXN0cyBhZnRlciBvdXRzdGFu
ZGluZyBQMlAgcmVxdWVzdHMgYXJlIGNvbXBsZXRlZA0KPiBnaXZlbg0KPiA+IGFsbCB2ZmlvIHJl
Z2lvbnMgYXJlIGZ1bmN0aW9uYWwgd2hlbiB0aGUgZGV2aWNlIGlzIGluIFJVTk5JTkdfUDJQLg0K
PiANCj4gSXQgaXMgdGhlIGRlc2lyZWQgYmVoYXZpb3IuIFRoZSBkZXZpY2UgbXVzdCBpbnRlcm5h
bGx5IHN0b3AgZ2VuZXJhdGluZw0KPiBETUEgZnJvbSBuZXcgd29yaywgaXQgY2Fubm90IHJlbHkg
b24gZXh0ZXJuYWwgdGhpbmdzIG5vdCBwb2tpbmcgaXQNCj4gd2l0aCBNTUlPLCBiZWNhdXNlIHRo
ZSB3aG9sZSBwb2ludCBvZiB0aGUgc3RhdGUgaXMgdGhhdCBNTUlPIFAyUCBpcw0KPiBzdGlsbCBh
bGxvd2VkIHRvIGhhcHBlbi4NCj4gDQo+IFdoYXQgZ2V0cyBjb25mdXNpbmcgaXMgdGhhdCBpbiBu
b3JtYWwgY2FzZXMgSSB3b3VsZG4ndCBleHBlY3QgYW55IFAyUA0KPiBhY3Rpdml0eSB0byB0cmln
Z2VyIGEgbmV3IHdvcmsgc3VibWlzc2lvbi4NCj4gDQo+IFByb2JhYmx5LCBzaW5jZSBtYW55IGRl
dmljZXMgY2FuJ3QgaW1wbGVtZW50IHRoaXMsIHdlIHdpbGwgZW5kIHVwIHdpdGgNCj4gZGV2aWNl
cyBwcm92aWRpbmcgYSB3ZWFrZXIgdmVyc2lvbiB3aGVyZSB0aGV5IGRvIFJVTk5JTkdfUDJQIGJ1
dCB0aGlzDQo+IHJlbGllcyBvbiB0aGUgVk0gb3BlcmF0aW5nIHRoZSBkZXZpY2UgInNhbmVseSIg
d2l0aG91dCBwcm9ncmFtbWluZyBQMlANCj4gd29yayBzdWJtaXNzaW9uLiBJdCBpcyBzaW1pbGFy
IHRvIHlvdXIgbm90aW9uIHRoYXQgbWlncmF0aW9uIHJlcXVpcmVzDQo+IGd1ZXN0IGNvLW9wZXJh
dGlvbiBpbiB0aGUgdlBSSSBjYXNlLg0KPiANCj4gSSBkb24ndCBsaWtlIGl0LCBhbmQgYmV0dGVy
IGRldmljZXMgcmVhbGx5IHNob3VsZCBhdm9pZCByZXF1aXJpbmcNCj4gZ3Vlc3QgY28tb3BlcmF0
aW9uLCBidXQgaXQgc2VlbXMgbGlrZSB3aGVyZSB0aGluZ3MgYXJlIGdvaW5nLg0KDQpNYWtlIHNl
bnNlIHRvIG1lIG5vdy4gDQoNCmJ0dyBjYW4gZGlzYWJsaW5nIFBDSSBidXMgbWFzdGVyIGJlIGEg
Z2VuZXJhbCBtZWFucyBmb3IgZGV2aWNlcyB3aGljaA0KZG9uJ3QgaGF2ZSBhIHdheSBvZiBibG9j
a2luZyBQMlAgdG8gaW1wbGVtZW50IFJVTk5JTkdfUDJQPyANCg0KPiANCj4gPiBUaG91Z2gganVz
dCBhIG5hbWluZyB0aGluZywgcG9zc2libHkgd2hhdCB3ZSByZWFsbHkgcmVxdWlyZSBpcyBhDQo+
IFNUT1BQSU5HX1AyUA0KPiA+IHN0YXRlIHdoaWNoIGluZGljYXRlcyB0aGUgZGV2aWNlIGlzIG1v
dmluZyB0byB0aGUgU1RPUCAob3IgU1RPUFBFRCkNCj4gPiBzdGF0ZS4NCj4gDQo+IE5vLCBJJ3Zl
IGRlbGliZXJhdGVseSBhdm9pZGVkIFNUT1AgYmVjYXVzZSB0aGlzIGlzbid0IGFueXRoaW5nIGxp
a2UNCj4gU1RPUC4gSXQgaXMgUlVOTklORyB3aXRoIG9uZSByZXN0cmljdGlvbi4NCg0KV2l0aCBh
Ym92ZSBleHBsYW5hdGlvbiBJJ20gZmluZSB3aXRoIGl0Lg0KDQo+IA0KPiA+IEluIHRoaXMgc3Rh
dGUgdGhlIGRldmljZSBpcyBmdW5jdGlvbmFsIGJ1dCB2ZmlvIHJlZ2lvbnMgYXJlIG5vdCBzbyB0
aGUgdXNlciBzdGlsbA0KPiA+IG5lZWRzIHRvIHJlc3RyaWN0IGRldmljZSBhY2Nlc3M6DQo+IA0K
PiBUaGUgZGV2aWNlIGlzIG5vdCBmdW5jdGlvbmFsIGluIFNUT1AuIFNUT1AgbWVhbnMgdGhlIGRl
dmljZSBkb2VzIG5vdA0KPiBwcm92aWRlIHdvcmtpbmcgTU1JTy4gSWUgbWx4NSBkZXZpY2VzIHdp
bGwgZGlzY2FyZCBhbGwgd3JpdGVzIGFuZA0KPiByZWFkIGFsbCAwJ3Mgd2hlbiBpbiBTVE9QLg0K
DQpidHcgSSB1c2VkICdTVE9QUElORycgdG8gaW5kaWNhdGUgYSB0cmFuc2l0aW9uYWwgc3RhdGUg
YmV0d2VlbiBSVU5OSU5HDQphbmQgU1RPUCB0aHVzIGl0cyBkZWZpbml0aW9uIGNvdWxkIGJlIGRl
ZmluZWQgc2VwYXJhdGVseSBmcm9tIFNUT1AuIEJ1dCANCml0IGRvZXNuJ3QgbWF0dGVyIG5vdy4N
Cg0KPiANCj4gVGhlIHBvaW50IG9mIFJVTk5JTkdfUDJQIGlzIHRvIGFsbG93IHRoZSBkZXZpY2Ug
dG8gY29udGludWUgdG8gcmVjaWV2ZQ0KPiBhbGwgTU1JTyB3aGlsZSBoYWx0aW5nIGdlbmVyYXRp
b24gb2YgTU1JTyB0byBvdGhlciBkZXZpY2VzLg0KPiANCj4gPiBJbiB2aXJ0dWFsaXphdGlvbiB0
aGlzIG1lYW5zIFFlbXUgbXVzdCBzdG9wIHZDUFUgZmlyc3QgYmVmb3JlIGVudGVyaW5nDQo+ID4g
U1RPUFBJTkdfUDJQIGZvciBhIGRldmljZS4NCj4gDQo+IFRoaXMgaXMgYWxyZWFkeSB0aGUgY2Fz
ZS4gUlVOTklORy9TVE9QIGhlcmUgZG9lcyBub3QgcmVmZXIgdG8gdGhlDQo+IHZDUFUsIGl0IHJl
ZmVycyB0byB0aGlzIGRldmljZS4NCg0KSSBrbm93IHRoYXQgcG9pbnQuIE9yaWdpbmFsbHkgSSB0
aG91Z2h0IHRoYXQgaGF2aW5nICdSVU5OSU5HJyBpbiBSVU5OSU5HX1AyUA0KaW1wbGllcyB0aGF0
IHZDUFUgZG9lc24ndCBuZWVkIHRvIGJlIHN0b3BwZWQgZmlyc3QgZ2l2ZW4gYWxsIHZmaW8gcmVn
aW9ucyBhcmUNCmZ1bmN0aW9uYWwuIEJ1dCBub3cgSSB0aGluayB0aGUgcmF0aW9uYWxlIGlzIGNs
ZWFyLiBJZiBndWVzdC1vcGVyYXRpb24gZXhpc3RzDQp0aGVuIHZDUFUgY2FuIGJlIGFjdGl2ZSB3
aGVuIGVudGVyaW5nIFJVTk5JTkdfUDJQIHNpbmNlIHRoZSBndWVzdCB3aWxsDQpndWFyYW50ZWUg
bm8gUDJQIHN1Ym1pc3Npb24gKHZpYSB2Q1BVIG9yIHZpYSBQMlApLiBPdGhlcndpc2UgdkNQVSBt
dXN0IGJlIA0Kc3RvcHBlZCBmaXJzdCB0byBibG9jayBwb3RlbnRpYWwgUDJQIHdvcmsgc3VibWlz
c2lvbnMgYXMgYSBicnV0ZS1mb3JjZSBvcGVyYXRpb24uDQoNCj4gDQo+ID4gQmFjayB0byB5b3Vy
IGVhcmxpZXIgc3VnZ2VzdGlvbiBvbiByZXVzaW5nIFJVTk5JTkdfUDJQIHRvIGNvdmVyIHZQUkkN
Cj4gPiB1c2FnZSB2aWEgYSBuZXcgY2FwYWJpbGl0eSBiaXQgWzFdOg0KPiA+DQo+ID4gICAgICJB
IGNhcCBsaWtlICJydW5uaW5nX3AycCByZXR1cm5zIGFuIGV2ZW50IGZkLCBkb2Vzbid0IGZpbmlz
aCB1bnRpbCB0aGUNCj4gPiAgICAgVkNQVSBkb2VzIHN0dWZmLCBhbmQgc3RvcHMgcHJpIGFzIHdl
bGwgYXMgcDJwIiBtaWdodCBiZSBhbGwgdGhhdCBpcw0KPiA+ICAgICByZXF1aXJlZCBoZXJlIChh
bmQgbm90IGFuIGFjdHVhbCBuZXcgc3RhdGUpIg0KPiA+DQo+ID4gdlBSSSByZXF1aXJlcyBhIFJV
Tk5JTkcgc2VtYW50aWNzLiBBIG5ldyBjYXBhYmlsaXR5IGJpdCBjYW4gY2hhbmdlDQo+ID4gdGhl
IGJlaGF2aW9ycyBsaXN0ZWQgYWJvdmUgZm9yIFNUT1BQSU5HX1AyUCB0byBiZWxvdzoNCj4gPiAJ
KiBib3RoIFAyUCBhbmQgdlBSSSByZXF1ZXN0cyBzaG91bGQgYmUgZHJhaW5lZCBhbmQgYmxvY2tl
ZDsNCj4gPiAJKiBhbGwgdmZpbyByZWdpb25zIGFyZSBmdW5jdGlvbmFsICh3aXRoIGEgUlVOTklO
RyBiZWhhdmlvcikgc28NCj4gPiAJICB2Q1BVcyBjYW4gY29udGludWUgcnVubmluZyB0byBoZWxw
IGRyYWluIHZQUkkgcmVxdWVzdHM7DQo+ID4gCSogYW4gZXZlbnRmZCBpcyByZXR1cm5lZCBmb3Ig
dGhlIHVzZXIgdG8gcG9sbC13YWl0IHRoZSBjb21wbGV0aW9uDQo+ID4gCSAgb2Ygc3RhdGUgdHJh
bnNpdGlvbjsNCj4gDQo+IHZQUkkgZHJhaW5pbmcgaXMgbm90IFNUT1AgZWl0aGVyLiBJZiB0aGUg
ZGV2aWNlIGlzIGV4cGVjdGVkIHRvIHByb3ZpZGUNCj4gd29ya2luZyBNTUlPIGl0IGlzIG5vdCBT
VE9QIGJ5IGRlZmluaXRpb24uDQo+IA0KPiA+IE9uZSBhZGRpdGlvbmFsIHJlcXVpcmVtZW50IGlu
IGRyaXZlciBzaWRlIGlzIHRvIGR5bmFtaWNhbGx5IG1lZGlhdGUgdGhlDQo+ID4gZmFzdCBwYXRo
IGFuZCBxdWV1ZSBhbnkgbmV3IHJlcXVlc3Qgd2hpY2ggbWF5IHRyaWdnZXIgdlBSSSBvciBQMlAN
Cj4gPiBiZWZvcmUgbW92aW5nIG91dCBvZiBSVU5OSU5HX1AyUC4gSWYgbW92aW5nIHRvIFNUT1Bf
Q09QWSwgdGhlbg0KPiA+IHF1ZXVlZCByZXF1ZXN0cyB3aWxsIGFsc28gYmUgaW5jbHVkZWQgYXMg
ZGV2aWNlIHN0YXRlIHRvIGJlIHJlcGxheWVkDQo+ID4gaW4gdGhlIHJlc3VtaW5nIHBhdGguDQo+
IA0KPiBUaGlzIGNvdWxkIG1ha2Ugc2Vuc2UuIEkgZG9uJ3Qga25vdyBob3cgeW91IGR5bmFtaWNh
bGx5IG1lZGlhdGUNCj4gdGhvdWdoLCBvciBob3cgeW91IHdpbGwgdHJhcCBFTlFDTUQuLg0KDQpR
ZW11IGNhbiBhc2sgS1ZNIHRvIHRlbXBvcmFyaWx5IGNsZWFyIEVQVCBtYXBwaW5nIG9mIHRoZSBj
bWQgcG9ydGFsIA0KdG8gZW5hYmxlIG1lZGlhdGlvbiBvbiBzcmMgYW5kIHRoZW4gcmVzdG9yZSB0
aGUgbWFwcGluZyBiZWZvcmUgcmVzdW1pbmcNCnZDUFUgb24gZGVzdC4gSW4gb3VyIGludGVybmFs
IFBPQyB0aGUgY21kIHBvcnRhbCBhZGRyZXNzIGlzIGhhcmQgY29kZWQNCmluIFFlbXUgd2hpY2gg
aXMgbm90IGdvb2QuIFBvc3NpYmx5IHdlIG5lZWQgYSBnZW5lcmFsIG1lY2hhbmlzbSBzbw0KbWln
cmF0aW9uIGRyaXZlciB3aGljaCBzdXBwb3J0cyB2UFJJIGFuZCBleHRlbmRlZCBSVU5OSU5HX1Ay
UCBiZWhhdmlvcg0KY2FuIHJlcG9ydCB0byB0aGUgdXNlciBhIGxpc3Qgb2YgcGFnZXMgd2hpY2gg
bXVzdCBiZSBhY2Nlc3NlZCB2aWEgcmVhZCgpLw0Kd3JpdGUoKSBpbnN0ZWFkIG9mIG1tYXAgd2hl
biB0aGUgZGV2aWNlIGlzIGluIFJVTk5JTkdfUDJQIGFuZCB2Q1BVcw0KYXJlIGFjdGl2ZS4gQmFz
ZWQgb24gdGhhdCBpbmZvcm1hdGlvbiBRZW11IGNhbiB6YXAgcmVsYXRlZCBFUFQgbWFwcGluZ3Mg
DQpiZWZvcmUgbW92aW5nIHRoZSBkZXZpY2UgdG8gUlVOTklOR19QMlAuDQoNCj4gDQo+ID4gRG9l
cyBhYm92ZSBzb3VuZCBhIHJlYXNvbmFibGUgdW5kZXJzdGFuZGluZyBvZiB0aGlzIEZTTSBtZWNo
YW5pc20/DQo+IA0KPiBPdGhlciB0aGFuIG1pcy11c2luZyB0aGUgU1RPUCBsYWJlbCwgaXQgaXMg
Y2xvc2UgeWVzLg0KPiANCg0KVGhhbmtzDQpLZXZpbg0K
