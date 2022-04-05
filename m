Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491384F53EF
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2361227AbiDFEZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846085AbiDFCCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 22:02:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D4C6D192;
        Tue,  5 Apr 2022 16:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649201512; x=1680737512;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9ld9YxnqQ/tft6SeSwMe4rrTweNCvt3iXi6pX/TyAqE=;
  b=fozqsz2PTcQO+d57DH3pkHP71I+x5PqwJXiDmTKc7kuTKqArJGT1BFQH
   euKrjIah4DcYVphme/o344sFicDodz4fkuv6oDs6BsJlGQaY/hQDzUVi9
   kiwhTI3y2sBlXYWg25uXJn38QdIX6fNhC8VdRZWTlXWVU9v0+zvcX85jU
   7sC7xxdEvFeiXmD0hXs7kDRlIqUUJav/hSDPYkSXnjJUdIHs82Qs4PrU8
   XAwXZMshGLEtAl/Rq3Bv4fISgIIXZNlGI+4R/o7UfGS0g1om8bHPfvi00
   Z5jE8eSYqmkCg/OYWplZThej8DAIPcAjfbBEcOmXGUxMwdpwGSizmChWj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="260586444"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="260586444"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 16:31:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="790051672"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 05 Apr 2022 16:31:50 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 16:31:49 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 16:31:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 5 Apr 2022 16:31:49 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 5 Apr 2022 16:31:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikK/bGFmqhRcKq7GGdaRun5tD+ymfOSEyExRD8dOVURV3UDr6WOhdEuLCSJL1zNYwryZMlOTbHqXm/mIf2cQ71CKiCw06tKg1BaPbTi40vg7OCjH3ve+nfux08ueq4tdhLH9pdCDZ4Nsvqe4/EX9XbMVxzOILJU4ilzOMTTADOQ+2oOtz1mvhrMUchs7nvrt8bhj3wZxeUFAn9+3I041xclEG+43lDW6VjKJXhA1Ot29rAg3emPWecAphB+qGDd8wd6HAxnPlz4+9GcMTaZJSertldfdgliIXwf5iQGJ/dwDvZa8BvirQAWZ7pEWLQuKT566wQrqQ8lcGZJlJGEnZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ld9YxnqQ/tft6SeSwMe4rrTweNCvt3iXi6pX/TyAqE=;
 b=QW2nv/VgYuvji/uKvx3rsMmlTFFM8R9jIyOWMPEeSs1PCKm8qU5jiaK+vQbN51hObTp+28Aj08Ba0th9aPX8uJQwn/MChOqd9ZdH/X/4BW7J2rELpCBWATIodoXk6K9yE13WDsrMeBt/i9QMqSEyUBnduwdpE5jK6MH9qR4oNqOdCCrOgu8iW7obEdF/q3e8kRIA7QJqFoE79c+9D6aB0/LBgRMZuVZJHysdm9/tBt/JR3mWV77Fu5riPxP2HEnZvPGcSaYDyLxLp94cv4rN6EYmOiywX7fEQPeL3/ndaWLu04eaP/wsxM+aDYnfXOGj04TrVCQDtA3kbxsYbrrUrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB3749.namprd11.prod.outlook.com (2603:10b6:a03:b0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:31:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%7]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 23:31:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
CC:     Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 3/5] iommu: Introduce the domain op
 enforce_cache_coherency()
Thread-Topic: [PATCH 3/5] iommu: Introduce the domain op
 enforce_cache_coherency()
Thread-Index: AQHYSQiEbYC3kRQ06EKEzYAnMp+0x6zhusQAgAA0Q4CAAAdUsA==
Date:   Tue, 5 Apr 2022 23:31:44 +0000
Message-ID: <BN9PR11MB52769195041933E35E9D8D428CE49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <3-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <20220405135036.4812c51e.alex.williamson@redhat.com>
 <20220405225739.GW2120790@nvidia.com>
In-Reply-To: <20220405225739.GW2120790@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a81af7e0-4fab-4900-09f2-08da175c7222
x-ms-traffictypediagnostic: BYAPR11MB3749:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3749F66EB97A17ACDAE93AA58CE49@BYAPR11MB3749.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1yYQP7AAmIBTTJMCFRAS5iBvOFqJgFQriYeFjiwW5C/Ttv1K2+55YfTlHuSqZ9JsadWxB+nA4RdGtaRibBOwjMI9IeFGDbchwZ5NzO/jTPg68f0Aek1/sAFZ5uUV6nEqeQKyXJ4vGMquflQI27WWwkUGAgjd+v4kAYs7SBe5ujuAU7IdpI3lT9Z9Irsr/vVYtki+N18ovZaBr4qQsw+ogZHUX8CCPDHE99Wvr/ZYSQN0S6bVoppjyba4mokG3IuF5FUFb2A5kyKypc2Rf3C5AMS55cL8ZAbUlqKrPpDC9MLlET0En/aw3g0tklOXw7tK/vFXDN6NwxMAoCWWAqa1VqX7N1UDtvNzzoN5jsa+yRliXR4eHxqz0mhUaoaA3kiTm8zfb8x7zBNCzVxW8C2FXbuBrntXjFDlSpGOifMBe/xAwxacXEz8Hg3Wi/HNmz04pbsM5MqPhPd+uQk5zbO1cca/ycpKTrq2PAjUefPPir7J2hiKpMZGv4ShMptOd2bye88Swdcv/9GmvMPp/6sx+THo7PZLNJvZwJ3d+kREDT1mqClxP8d+4vP5Bu6G2m9Bk/ebutxFGyqOnBFqrsmQCREj4yLo0i7RQWhAbQSCHWUyZ2HdQjjxJLMS0t4lyGFlUZWDPM4MYN7HsUVTnYiYxc/qhxnAMWty9erwuHzoI1kcbJTfvu5M1mQzhlye5s6ZIBCUlnjrIYWWpWAOICezdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(26005)(186003)(66446008)(110136005)(316002)(76116006)(52536014)(55016003)(8936002)(71200400001)(66556008)(7416002)(83380400001)(66946007)(5660300002)(33656002)(86362001)(54906003)(6506007)(7696005)(2906002)(38100700002)(64756008)(9686003)(122000001)(8676002)(508600001)(38070700005)(4326008)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFFENW9rMUtkQUV0ek1UcWlHR1dkZWxzZzFpQUhsL21tcElidzc2bkVPelFM?=
 =?utf-8?B?eTJLdk5rdUx0cENtR0NBU216cVhiQWpncVBXcmhXSVVGaEkwYnZISWZlait6?=
 =?utf-8?B?WGg0TTdlYWVoVWF1aVlZMWY1UTFubS9qMDVodUp5Z3pFU3pEZlF5Nm9zdW10?=
 =?utf-8?B?SzkwR28xYWNXVDVNSzZwSFhOZks4c21BWnljS2VIZlFXeEZoYnpySllzdWV4?=
 =?utf-8?B?MjNLUlV0QzJ2SDlwZFZyR0RVQ0tRdmVRdGxQbWZRYU12YmM1S0dzV0xyeVYv?=
 =?utf-8?B?bHFPcjJocXFIQm5OeDBpaHZiZ0pkRlh4L3d5U2R2ZjArVy9NaWU5L3hNSkpt?=
 =?utf-8?B?dVRha1IxNG94OFNTcjQzNWJBbExyankyakRTSXlKL3pMc0UxTlpWYnhGYmFO?=
 =?utf-8?B?KzFJbmpaUzZsdlZINUc0TFZXTU9PQkJkeWRTQkFLYTlXSGNaTHBlaW5iL2tu?=
 =?utf-8?B?dW90b1J6NFpIUEg4WGg3NWdXTEUxZE95cWlDOU5rQ25wVEpzVVNFbXZWUXJQ?=
 =?utf-8?B?NXFSV2lhQ3FaUlRsVWU4Q1pmTkdONy8wZ3h4amlWaXd4VllSUm1FN3diaTd6?=
 =?utf-8?B?K051dWxiSXRJRGF0RjhhUVhKWUxWQzZWZm44K2ZQcDJ0Q0JVaEVKVkNRcEY0?=
 =?utf-8?B?S1Y1VysvbXVMZDJrL1FQRTJoZkRQYXB5TjZhUnRZd3pSUDJlWnQ4bjQyMXZX?=
 =?utf-8?B?c1VsV1N3Y0VZdHozUHorMDQ1MUwvWlc1UTVKVG14a09WellDUS9NeGpkb0hw?=
 =?utf-8?B?Q1JtSFI5TFhzZEw2R0ZuNWRwRmpDSU1HVVBwVFZaeVRBQXc1MDZZN2pENGVL?=
 =?utf-8?B?Z0lySjR2SkxpdWs5K0RxT0JGaWdxekRqK1FvM0lWR3RFQWF1V3hjQjIxTmwx?=
 =?utf-8?B?Z3UrWldJUUZ5RU4raU5CbjIxcFpEQ3V4bkZ5M1J1MlZUVUc5THNWTXJLZng4?=
 =?utf-8?B?TzZ6WVFzaW11MzJ3MzlOdkd1eWRRcnh4VkJoeXdOckQ3MjYremI0dnJqUlZI?=
 =?utf-8?B?QzlTZmlIanExQlhzOENtVStJVGxUQTNNRjhrTFpmVnFlUDEyNkpHTkx4dnp3?=
 =?utf-8?B?bk9ZMjVxUmRlQnVDSzhqdC8zcnVhVXZYcGthbjNJMFBrMnZKdHVJRkVNODFt?=
 =?utf-8?B?MHhvK0ExanFYOUNBVkhXL0dmQTV6dWZoRjlDWXFEY01GVjlkbk1vTUJGVm9I?=
 =?utf-8?B?dHA0UTl5QUQrLzBHbDIxVjdqVTZwQTY4MmlrbHgva2t2dWVqeHV2TDRtTnor?=
 =?utf-8?B?L0lOM1l1dzgwdjBFZlU4VUtmaGdQU1doYml6d0pqeUtGZ085aG1UblA4bXN0?=
 =?utf-8?B?SGpZenRMYVpEQ1p5RmhTTitrOVNaQ2kxNFRscEthWUFtbVg4bkllWUV0NStq?=
 =?utf-8?B?U254eGJCVzJ0RndQbXlPSWpmcWtVTndpcFd2VkZuY095TmFpaEpxN2piZTVS?=
 =?utf-8?B?U3BrUVRWaExMTkkraEswWnJnb281MGp6TGhneXRNa2ZKVXBUZUF2bHdOR0ZG?=
 =?utf-8?B?clZXQ1NvZEc5WnJXQnFhdUN3Y0xZTWYyVGVjTUFrcHFSY2xpUnFtS0hxbkxP?=
 =?utf-8?B?N21QMDNDeFFTcHcwNy85bEdNNjJRdytHdXZjR1MxSVZaODdTeVNXNkdLdU9K?=
 =?utf-8?B?eSt5aElOTnd0em94cnQ1MFVNZElvdGJqdXppZDJ3KzV5T2lUUVp1Q1o3L2cw?=
 =?utf-8?B?NGNNK0N4YlJhYzFpdFVTeis2L0EzWWVoLzdmVENCdVdwSVpzK2lxRnBhVGFs?=
 =?utf-8?B?aDl4bUZrOXUrcW1TU3ZRRmdnYlZaUVAwbUFtWlJ4RWw3MHB2VjYzeHRuaE5O?=
 =?utf-8?B?dnQ4TlIvRmxkVUt2Z0l0ditHQUNrUXRlWTRraHJibEZLNnprb3pIL3dJZmNU?=
 =?utf-8?B?V1ZNQzZ0NmNOR0NXWnJkUmNyOFhMLzJZV2VMcyttVVY3eTFiSnp6bGtxRkJH?=
 =?utf-8?B?cnZna0RucUU1bS9xMFp0Mi9Ra1RLSndTOEdwdUNJazVjWWJxUEtxL1gyVjIz?=
 =?utf-8?B?OThuSHFhZXlDU3RRRTdFVnM2UWhLN296K3NFbUNTVXc0TXVNU09lSkpnUTdG?=
 =?utf-8?B?QWpFaXJEZDlRT09oTFZrdzhDY0lUU3k4S20wa295c3FIeERuNkVOMXdGOFFx?=
 =?utf-8?B?QkVnM2RpcG15MWgwVTkrb2NMR3ZRSWdaWnpWQ0VYRDRmYkllN1JsN0xXaEpQ?=
 =?utf-8?B?Zkk1T3lIajJQQmFwNk9ML0VrWEF4RDh6U24vMlJYUlE5bGVJdDZidGpJS3VK?=
 =?utf-8?B?SFd1aE9FRUVsODVMQmZZYmZabXhvRzltRkhjRnVVK1pHbW1LSE1iRk1rU2l5?=
 =?utf-8?B?b0R5Uk1NaTFWS1RzejBBWTRCUVZwYzRNdVFKS0FZNU42S1BIOUZQQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a81af7e0-4fab-4900-09f2-08da175c7222
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 23:31:44.3735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LoproUycFzsFr3d1QfdiOOK6W6XLxgoAt5z6sK+akKad2NtiDZaMXJt3YLALySSRhoMcARRLrVsaK2BGiOupUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3749
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEFwcmlsIDYsIDIwMjIgNjo1OCBBTQ0KPiANCj4gT24gVHVlLCBBcHIgMDUsIDIwMjIgYXQg
MDE6NTA6MzZQTSAtMDYwMCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiA+ID4NCj4gPiA+ICtz
dGF0aWMgYm9vbCBpbnRlbF9pb21tdV9lbmZvcmNlX2NhY2hlX2NvaGVyZW5jeShzdHJ1Y3QNCj4g
aW9tbXVfZG9tYWluICpkb21haW4pDQo+ID4gPiArew0KPiA+ID4gKwlzdHJ1Y3QgZG1hcl9kb21h
aW4gKmRtYXJfZG9tYWluID0gdG9fZG1hcl9kb21haW4oZG9tYWluKTsNCj4gPiA+ICsNCj4gPiA+
ICsJaWYgKCFkbWFyX2RvbWFpbi0+aW9tbXVfc25vb3BpbmcpDQo+ID4gPiArCQlyZXR1cm4gZmFs
c2U7DQo+ID4gPiArCWRtYXJfZG9tYWluLT5lbmZvcmNlX25vX3Nub29wID0gdHJ1ZTsNCj4gPiA+
ICsJcmV0dXJuIHRydWU7DQo+ID4gPiArfQ0KPiA+DQo+ID4gRG9uJ3Qgd2UgaGF2ZSBpc3N1ZXMg
aWYgd2UgdHJ5IHRvIHNldCBETUFfUFRFX1NOUCBvbiBETUFScyB0aGF0IGRvbid0DQo+ID4gc3Vw
cG9ydCBpdCwgaWUuIHJlc2VydmVkIHJlZ2lzdGVyIGJpdCBzZXQgaW4gcHRlIGZhdWx0cz8NCj4g
DQo+IFRoZSB3YXkgdGhlIEludGVsIGRyaXZlciBpcyBzZXR1cCB0aGF0IGlzIG5vdCBwb3NzaWJs
ZS4gQ3VycmVudGx5IGl0DQo+IGRvZXM6DQo+IA0KPiAgc3RhdGljIGJvb2wgaW50ZWxfaW9tbXVf
Y2FwYWJsZShlbnVtIGlvbW11X2NhcCBjYXApDQo+ICB7DQo+IAlpZiAoY2FwID09IElPTU1VX0NB
UF9DQUNIRV9DT0hFUkVOQ1kpDQo+IAkJcmV0dXJuIGRvbWFpbl91cGRhdGVfaW9tbXVfc25vb3Bp
bmcoTlVMTCk7DQo+IA0KPiBXaGljaCBpcyBhIGdsb2JhbCBwcm9wZXJ0eSB1bnJlbGF0ZWQgdG8g
YW55IGRldmljZS4NCj4gDQo+IFRodXMgZWl0aGVyIGFsbCBkZXZpY2VzIGFuZCBhbGwgZG9tYWlu
cyBzdXBwb3J0IGlvbW11X3Nub29waW5nLCBvcg0KPiBub25lIGRvLg0KPiANCj4gSXQgaXMgdW5j
bGVhciBiZWNhdXNlIGZvciBzb21lIHJlYXNvbiB0aGUgZHJpdmVyIHJlY2FsY3VsYXRlcyB0aGlz
DQo+IGFsbW9zdCBjb25zdGFudCB2YWx1ZSBvbiBldmVyeSBkZXZpY2UgYXR0YWNoLi4NCg0KVGhl
IHJlYXNvbiBpcyBzaW1wbHkgYmVjYXVzZSBpb21tdSBjYXBhYmlsaXR5IGlzIGEgZ2xvYmFsIGZs
YWcg8J+YiQ0KDQp3aGVuIHRoZSBjYXAgaXMgcmVtb3ZlZCBieSB0aGlzIHNlcmllcyBJIGRvbid0
IHRoaW5rIHdlIG5lZWQga2VlcCB0aGF0DQpnbG9iYWwgcmVjYWxjdWxhdGlvbiB0aGluZy4NCg0K
VGhhbmtzDQpLZXZpbg0K
