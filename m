Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEB44F5426
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376730AbiDFE1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385492AbiDFDdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 23:33:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816581F8921;
        Tue,  5 Apr 2022 17:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649203731; x=1680739731;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=lxu670OvAWdxycaGX30QWIL/xopECVQ4C8tEePe3Ggw=;
  b=kU4Up99BrNbsjrUnD09kCVGJj1M72MuCN2G0lBQf0zew5+mQb5Bu6fZR
   Smy8BluJVD8/qGrEoqcUVw3I9ZpvV0n3Ca/oRzvDPjTqVZjXsnHCGdNgN
   wNN6424U2hRvAmROYvAlNwRVQqo1OTE30nMFTRtw5dWpINn2Q+/QgdYsg
   ypOhC5D9IfdoVxQoFmVTW4U7ALo7DSka2BZwiQNcaeF9sbWcozmAv1wqk
   uuuR/TgCArEvhklCCYzzZxmdgkzao7t3h3uWafy3gYKLjrqDtKLbtrSwe
   5VrGunbrMEyIjXgMyUom8jvEd0VVfFs7LA71WHvQz7zbr3clgM0cV91ln
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="258486601"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="258486601"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 17:08:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="641826348"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 17:08:51 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 17:08:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 5 Apr 2022 17:08:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 5 Apr 2022 17:08:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVN5AShgfO5zbrdDcI/ewxfs5eyFMFXL9reblaZziLd6btTCaB7j3ztQ79XJmA7ESvdbC1NBfmaimfwW5uHEJ+cf48K+4+eYoxW72FVsKeHRnJH8aT5IYBUX+GyMLvEjZ58wnDCg9U3vMZcpLLyx8zirGM/inDT6rF4rElDK0rRcBMPxxS8cKivJYN8y3GmnhCpOlphrDH3pFi67k49xJV1Xgbz1ss6hjw2IuQhLuhM2yp6aOpvHW3ejov5dAPBZ77/VTCcwVPwVoBlnhAZ29Na4yDCj46ynfEGr3ieTpRyaFSd8VCLIdHfnOXlAHff7IDay5bJ9402m+nHqGeLAuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxu670OvAWdxycaGX30QWIL/xopECVQ4C8tEePe3Ggw=;
 b=MdEQnCKpMKVHis5uF2onisl1wwsk81MWJEyIfDj909flrIjW72UBpdy8Bd227sXuRz5SFt8GX3MMGI1lydGHF8HbUqWPNjrJU6HaiR1hZauL3qA0k0Cvm79QsGYDw83GhQwLxk81hO4TItGjUAIeBkfYO8go2d57EqgB9h6RmgnD7uUG3Tk7m1kGoD0PDff3r+alZ+8UHaT1NjxmtYcxaid+CsYk4qf3cwIMu36Vzjq7Hiw+mA7QCPj24SNxGBKlVRZzO7JxqCIcujiSp0lywDdP62aX2XInDAABHc6Gx35cSGW15mSqFh5dvZNZa1bGH9w3zlygQKsFUJApVhTGpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 00:08:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 00:08:45 +0000
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
Thread-Index: AQHYSQiEbYC3kRQ06EKEzYAnMp+0x6zhusQAgAA0Q4CAAAdUsIAAC8YQ
Date:   Wed, 6 Apr 2022 00:08:45 +0000
Message-ID: <BN9PR11MB5276DE2C3D0CBCBB380570348CE79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <3-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <20220405135036.4812c51e.alex.williamson@redhat.com>
 <20220405225739.GW2120790@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 248e12d1-ae92-4ebb-aa15-08da17619dc7
x-ms-traffictypediagnostic: MW4PR11MB5911:EE_
x-microsoft-antispam-prvs: <MW4PR11MB59112F6A4E39937CF11CDA3B8CE79@MW4PR11MB5911.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g97o/eQLWUgOA7HJg4eiFZQ/gmyyL1RDdckkoykpGCRlpi7ET4odX1kgryKNtIWmUwcraTKbZuJYfz8Xc2GrAOSG44aeSHwSzEC0NLejQxlMTTpUmoJfRATY0cllVHdl4Wp/YjIRaBPZmsTH7gcB/DqBvCa7wTaiauuXwbIanDSYn4lB8KZnSyaMvwvIPOLgQU3CjcFenhyBwn9W+hh21HV1nSDcX5KPs8QHFS+zplrWuFqKFXXoYqFyz4eM6EMxarZ8G4WmZ9sbZ+b9I0thRCmTqa9zZYQhSJg6gr/Bmjcfjy1AJp5ackv/AipcuElEzdgouAQuS4Hthd7ziexInIuHV8e6bNcJ+Ux/1OI9yX/8Q3Nas72k56BuNE2QdpqWfckMOwis2Kr3jumZFqnLp2qVsv+AdKg3uE8trZ2sYBzUpgVORkSS5T1YYNFPn1ON4b18l1BfdUsQRMs/Hc+Hp26kgFj2JSBCqub8SVu651xz0IS3UUKer+W9vIHtzvKF2oTTShsENJg6VOBq+PZ7VilG6Xg6VTopitEkl9KbBomWG2D82cUbdjlosF8lElfICtoREVv3+PCvqvbdxw1Q0jhM4S42drNakf+Tvt2EpmaVtkbht3GSeHK25Add5D3seGr/QxFCWIXNB3ThwRSTJl/2MA+zGTIeO12jdE7OdjS55SIhEjDmMTQUbj/cYpyQiQE/bnrcpGXjGVAUDXkr+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(82960400001)(38100700002)(26005)(54906003)(110136005)(316002)(33656002)(2906002)(186003)(71200400001)(55016003)(5660300002)(76116006)(66946007)(7416002)(6506007)(9686003)(508600001)(38070700005)(7696005)(8936002)(86362001)(64756008)(66556008)(66476007)(66446008)(4326008)(83380400001)(52536014)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWkvVW5ObEVCR293aE5Ob3ZJZXY1K0x6TVNDMkNBeUsvYjNCblQ0djUxZlVl?=
 =?utf-8?B?M3BVOEx6aE1ZUkRQUzNRc24yN0swM3VhTHNRaldMZWowUytDaEFWbTVIdGtJ?=
 =?utf-8?B?RnM0NzIxNXh3WUloMG1ZaWFudWNZZExDUjNCUEJhSWo4WWF1Qi95eUdqSG1M?=
 =?utf-8?B?Y2p6STROeVliSU9haFVXYmVua2Y0QXh3S20waHR1UXBvdjhFbGsybUk3SVF1?=
 =?utf-8?B?N2dPL3pMUkhBWFRRZmdTVUhvaWlCZ1dDMlFPbW9oMkxtWE85aGEralRUOHpW?=
 =?utf-8?B?Sm5MOHJQcnk4L0tNWFo4TmtDa0xRemg3dUZEN1ZZYlZuMzNIUlVNcTI4TmRa?=
 =?utf-8?B?VTBJN0k1SDJVNExYTEhoTi9KRUV2ODRseWFMUkVJTE5BYU1GYWpoMEJuYjBC?=
 =?utf-8?B?OVloMWhEcDlLN3N2S21NLy9jaDRHMzNzRklKOW0yck9lOG1MQTk3OWZBbnNF?=
 =?utf-8?B?WmF4QWhhN3lteHlyay96Y0V5ejhOVTlnRHhwOTZGdWJEY3BTZzdyb0dPTi9q?=
 =?utf-8?B?TjI3K013WFZUWEJCTTVYSDZZN3Vwenl2Ymt2M3lUUlBxRW9Qd04raXlUTDBH?=
 =?utf-8?B?WWdGL1N6aGdubFhPR2l5bDRKZkYvaE9LYkVsZ0VQMk9teS9hdlVLZGtYNUpP?=
 =?utf-8?B?V05VdFdnZWl1TFd2czhrZUhvZFJ3d0lZVlBOUkFkMmNIcXc3RHN3a1gwM2gx?=
 =?utf-8?B?aERSWjIyN0xxTzJIL0g4OGFWNkx3by8weVppYmZjVWpaMnRpcGdKZVdHWVZK?=
 =?utf-8?B?Q0tZY05tbWNXc1ZVVC9NU1N2Yk5aOUlLc3FNTHBWbGVyVXByd2ZwaXgzbGwy?=
 =?utf-8?B?NjczQ1FNZ3FtbUZjK3FDeEFCOVZtU2E3ejFQSHFSU09zK3B1RXk3Q3NmcSs3?=
 =?utf-8?B?VWdIMzIya0ZUU1NCbEFXOXB4d2JDVUw4TnRIQmowd3l6SU9BVVdvUCswZW43?=
 =?utf-8?B?K0FJVjl2RFErS2ZuWkw4TjZHQVZSTXc0UGtMY2pWRVJmOVQyZ1dYK3VVQlVU?=
 =?utf-8?B?T2Y4REdhQTFTOWJFWThtVXo1bCsxblBnZ002L0Q1dzA0R1lCbGJGMWtJbHlN?=
 =?utf-8?B?UDNMTVlwL3l2ZnVCc1pwNHRhMm5tZnNBTUFPempQSkEzMG9lbmpGaEpBQ1JP?=
 =?utf-8?B?OVFvcDBxVFI4am90Z0RFTUpYMEZHNzdlbVJUcUN1K1hEK0NvdzU4V0JOUU5J?=
 =?utf-8?B?bkNPalRiTFlXOFpCSDlhMWNEQTZxcnJYYWpTMkFncE8zZkhVNytIZWU2Vi9K?=
 =?utf-8?B?VHJIcXlDU1R0a3lnZXlrZTEzRjVwUFp5NnFFQUhzUGJPUjltS1hvYWo1elc1?=
 =?utf-8?B?NVVyK0RielM4RHFZRjUrb0NSNEFnOUsvWUZ0VUFGdi9ZbmVDdnpCTFcwYjJE?=
 =?utf-8?B?KzZqZVFodDBJZDNsMW9TTmZsMUpyQ0lXU1BBMG12NUR2bWVyR3QzYWZoZHZl?=
 =?utf-8?B?K3doQXVCZFBJWGZCQnB0MWNHdmFuTmMxWHhKMEdreTBGVG1nczVPL0w0Nm9p?=
 =?utf-8?B?UzQrRUZGQ2FSOVJBT0dwdGFuMDZpRFBZR2lzOUI3Sjd1b0tDUytuTGRrVjZn?=
 =?utf-8?B?YmJseVFqQmFYSng0aFpyNG5MWVdNOENuK0o4N0F4UzBFL3hxbUxpdWxsbkYr?=
 =?utf-8?B?MWtRQlp6YitHOUV1cEw3aEZJakVLY2VaYmlTL3B2WlF1emZJT00zME1BamJ5?=
 =?utf-8?B?Q0t5WndCVXBudnVob2pBbGZRQURSSnpHanRvV2tTOHg3SnBMc213aDBOd1B4?=
 =?utf-8?B?ZXJXaktYb0xoaXJpVkE5bStqZXhsaGlSTWxkY1FXOTRFL2ZtUFV1dDZVdmNY?=
 =?utf-8?B?eDZzS1ZvQTFhbDdtMmdwNjNNMkwvUDM1cXgybnBidWNibTVHYWNIVmFrVmNO?=
 =?utf-8?B?M0taM0RlYXhOSm9oNXRkSjR4VlBxYmNwbnlhN0JhbjFSTVlTaTB2MUFKQ3VR?=
 =?utf-8?B?NjNjbHFWTjU0V3NXbEVBRE5PbmxJTkZKWmRHVHNYRHZrUFhXYVljVHZ4dVpt?=
 =?utf-8?B?cnZuYUpJNzlKUEJISWlqYXpVbk9INUdLVVhmNTE4Z3N5ZHlFV1BoTDBnUjdz?=
 =?utf-8?B?dmlSb1VReHdrMyswM0ZxY2xXZ215WUVxOVA1YkNieDZveFdvZC9DekE4dEdz?=
 =?utf-8?B?enJkbEpqZXJDVW41VXlzOTQ2S1ZKUFdJazNjeHFKQ045YzhrUTRaaEhkbE0y?=
 =?utf-8?B?bzRJTE9OR0xtVlZkR0VmcHZ1M04yeHhSYktBSFVTb1gvZzM4WVFrTWtYOFdr?=
 =?utf-8?B?TUVYS1h1eWM3VU04ZStuY295TVNDcHM1TGx5NEd1S2owSzZiVFBLckJmSVUv?=
 =?utf-8?B?NWNEcFZqSVVpVGRSWWpMdGJVWm1QTVFsTVJNMnY1bHVnbFA0UC9udz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248e12d1-ae92-4ebb-aa15-08da17619dc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 00:08:45.1002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3tnGRRhMjF2RhqnbV2Y9RdTnL3sv3f5F0UhA6N+NXu5gv/N5EGA53VQEFAqwFC1dvfnJ6NWZqAlOrhg69ts/Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
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

PiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50OiBXZWRuZXNkYXksIEFwcmlsIDYsIDIwMjIgNzoz
MiBBTQ0KPiANCj4gPiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+
IFNlbnQ6IFdlZG5lc2RheSwgQXByaWwgNiwgMjAyMiA2OjU4IEFNDQo+ID4NCj4gPiBPbiBUdWUs
IEFwciAwNSwgMjAyMiBhdCAwMTo1MDozNlBNIC0wNjAwLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6
DQo+ID4gPiA+DQo+ID4gPiA+ICtzdGF0aWMgYm9vbCBpbnRlbF9pb21tdV9lbmZvcmNlX2NhY2hl
X2NvaGVyZW5jeShzdHJ1Y3QNCj4gPiBpb21tdV9kb21haW4gKmRvbWFpbikNCj4gPiA+ID4gK3sN
Cj4gPiA+ID4gKwlzdHJ1Y3QgZG1hcl9kb21haW4gKmRtYXJfZG9tYWluID0gdG9fZG1hcl9kb21h
aW4oZG9tYWluKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCWlmICghZG1hcl9kb21haW4tPmlvbW11
X3Nub29waW5nKQ0KPiA+ID4gPiArCQlyZXR1cm4gZmFsc2U7DQo+ID4gPiA+ICsJZG1hcl9kb21h
aW4tPmVuZm9yY2Vfbm9fc25vb3AgPSB0cnVlOw0KPiA+ID4gPiArCXJldHVybiB0cnVlOw0KPiA+
ID4gPiArfQ0KPiA+ID4NCj4gPiA+IERvbid0IHdlIGhhdmUgaXNzdWVzIGlmIHdlIHRyeSB0byBz
ZXQgRE1BX1BURV9TTlAgb24gRE1BUnMgdGhhdCBkb24ndA0KPiA+ID4gc3VwcG9ydCBpdCwgaWUu
IHJlc2VydmVkIHJlZ2lzdGVyIGJpdCBzZXQgaW4gcHRlIGZhdWx0cz8NCj4gPg0KPiA+IFRoZSB3
YXkgdGhlIEludGVsIGRyaXZlciBpcyBzZXR1cCB0aGF0IGlzIG5vdCBwb3NzaWJsZS4gQ3VycmVu
dGx5IGl0DQo+ID4gZG9lczoNCj4gPg0KPiA+ICBzdGF0aWMgYm9vbCBpbnRlbF9pb21tdV9jYXBh
YmxlKGVudW0gaW9tbXVfY2FwIGNhcCkNCj4gPiAgew0KPiA+IAlpZiAoY2FwID09IElPTU1VX0NB
UF9DQUNIRV9DT0hFUkVOQ1kpDQo+ID4gCQlyZXR1cm4gZG9tYWluX3VwZGF0ZV9pb21tdV9zbm9v
cGluZyhOVUxMKTsNCj4gPg0KPiA+IFdoaWNoIGlzIGEgZ2xvYmFsIHByb3BlcnR5IHVucmVsYXRl
ZCB0byBhbnkgZGV2aWNlLg0KPiA+DQo+ID4gVGh1cyBlaXRoZXIgYWxsIGRldmljZXMgYW5kIGFs
bCBkb21haW5zIHN1cHBvcnQgaW9tbXVfc25vb3BpbmcsIG9yDQo+ID4gbm9uZSBkby4NCj4gPg0K
PiA+IEl0IGlzIHVuY2xlYXIgYmVjYXVzZSBmb3Igc29tZSByZWFzb24gdGhlIGRyaXZlciByZWNh
bGN1bGF0ZXMgdGhpcw0KPiA+IGFsbW9zdCBjb25zdGFudCB2YWx1ZSBvbiBldmVyeSBkZXZpY2Ug
YXR0YWNoLi4NCj4gDQo+IFRoZSByZWFzb24gaXMgc2ltcGx5IGJlY2F1c2UgaW9tbXUgY2FwYWJp
bGl0eSBpcyBhIGdsb2JhbCBmbGFnIPCfmIkNCg0KLi4uYW5kIGludGVsIGlvbW11IGRyaXZlciBz
dXBwb3J0cyBob3RwbHVnLWVkIGlvbW11LiBCdXQgaW4gcmVhbGl0eSB0aGlzDQpyZWNhbGN1bGF0
aW9uIGlzIGFsbW9zdCBhIG5vLW9wIGJlY2F1c2UgdGhlIG9ubHkgaW9tbXUgdGhhdCBkb2Vzbid0
DQpzdXBwb3J0IGZvcmNlIHNub29wIGlzIGZvciBJbnRlbCBHUFUgYW5kIGJ1aWx0LWluIGluIHRo
ZSBwbGF0Zm9ybS4NCg0KPiANCj4gd2hlbiB0aGUgY2FwIGlzIHJlbW92ZWQgYnkgdGhpcyBzZXJp
ZXMgSSBkb24ndCB0aGluayB3ZSBuZWVkIGtlZXAgdGhhdA0KPiBnbG9iYWwgcmVjYWxjdWxhdGlv
biB0aGluZy4NCj4gDQo+IFRoYW5rcw0KPiBLZXZpbg0K
