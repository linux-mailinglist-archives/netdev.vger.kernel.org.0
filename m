Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173B24B95EE
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiBQCa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:30:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiBQCa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:30:56 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC11529E970;
        Wed, 16 Feb 2022 18:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645065043; x=1676601043;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RZvLyF6pt79AURwwgSwp6G7MUjHzSf3CpttlzE3s/1w=;
  b=FqeE5BPVW3dPrfdLwpueqPgyONLkWQjzFUOOPQLyXgYBzmSkdAT/gywO
   lLXU+1uIlV1r8QS2rHmkDks/V40ZhoRXRlLOma4JDbyGyyeYoxOdr7g1w
   Fm2nFHbrJQydOG751dol2NE2AG0vRsDUoYZiDgMQLz8oA9Cclak2NlKxW
   Xke+pN2xLLGGvn0ADrAklQs0LobFqcQRXiabpHN22BYtJKYeL9Ad/A0HK
   /+krNCKNLNYgO9r/ekvATRTl366epqoESoWPau4PyE+c1ks3C7QBmJQYY
   RsmEGSNfnL6J+bTsMPSJ8Vydl5sa7YBXzr0uvFqDc+mpkZZDCX/jb6oC7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="230734472"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="230734472"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 18:30:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="625739722"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Feb 2022 18:30:43 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 16 Feb 2022 18:30:43 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 16 Feb 2022 18:30:43 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 16 Feb 2022 18:30:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqvGSEbyKALQscjz9wtLCo/zQzklnhimDuRkJruAB/vDZprqDhK97kbSHaYCxPPw7xAcqWOfIvbm+LYhsYzVZZJ5ZeMigcl5As+Efti//u2XVHSpUo10dprWRmFJiY6vYXkWqz+kUtQUS0nd0XEScJGEtD/u5E5gKv7c5ogF8hYqtu8VRry3ltSa0G1cUmkr6ev1jIsieIU4fUi53QXfLuPUuzxHDtvQzxSbvqX3DdVz9dM0XVB/EXQQKr6RDxLCpL/agp9apVZxPEIZJZBPvrLg5AVEeLfZ+BOHwyhaHy+cgeKAnijBBhEAQa+lTFhbXuZb1pLZaVAsbbT5NgaBLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZvLyF6pt79AURwwgSwp6G7MUjHzSf3CpttlzE3s/1w=;
 b=iV+45bseCHuOBTD8mEI1E/NH4DiR88ZahOYhCxP4/s3XNdQgf/xe2NPillv4a3aX7fRpLDiMvqr8CnIdt7pTsLEOgp0ThFCnAi8e9Zvzdq0OnIkfBQ1SFJEM/KI5TKrFNfeRn1kLOjxfHFj31eZ3YrvYqSL+241DLPmzSHKFm8gjoyfQbCDeHUMeSHuS6HQg2LnlNJwKcvtPuFMkJVY7tclcw4CRkIHXx0jfRd2aMO26N9Jfvq6vFfTiDdAUIw7yQxv3jPOv8xRvOKUGO3ClkH7QULqivRtoYYNRvcsSkCFfRD181mE4WyZDhaJt3RkKOgtDFXZaEvDySNvSGInLyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5440.namprd11.prod.outlook.com (2603:10b6:5:39c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Thu, 17 Feb
 2022 02:29:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 02:29:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
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
Thread-Index: AQHYHEd8WrQ75CuCwEmQ+4nXbJWyQ6yKWZwAgAAploCACfA7AIAAX2SAgAC4ipCAAJmEAIAA52SQ
Date:   Thu, 17 Feb 2022 02:29:56 +0000
Message-ID: <BN9PR11MB52769A578896D2233B9DDC798C369@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <20220208170754.01d05a1d.alex.williamson@redhat.com>
 <20220209023645.GN4160@nvidia.com>
 <BN9PR11MB5276BD03F292902A803FA0E58C349@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220215160419.GC1046125@nvidia.com>
 <BN9PR11MB527610A23D8271F45F72C1728C359@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220216121416.GF4160@nvidia.com>
In-Reply-To: <20220216121416.GF4160@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 20508dfc-3b04-447c-6702-08d9f1bd6331
x-ms-traffictypediagnostic: DM4PR11MB5440:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM4PR11MB5440D81B1442CDEF9D172FCB8C369@DM4PR11MB5440.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GlaqYps/14CTwWHB0YkZcRzvx2B3xSVTW5kBeL4rfC6sA9yjn71TwAz1y6gUx7IoF4cVMnrGxVrRaatTxC3PTHf2ZTBIoCjo4zgazH+V7HnRNrOqNvC5uL//AKOLGmb3eMXy+tXNR2YGdcLRGqhOcrGFHuV4D8vkWfduszMxQUmaI2q9XqV0GEawNkzyyfXpNioi/cPrK+nTsIkrSKhKLHKSajIQuJ+2ZervEemPwnc/vG1EiJz4jWxO+glCD1bgnPvVLwqhOIyWR6SkDiNfcKFRXYp7Sc1+1Fq0osQR0fa5lTwnFTYGk3TckEx9aNGL3YU6y70wUYZhd17Zhebalr1DqJep/GTCqjxq1GT8G8jk6JtVx8XjoFyhztOHvxI8BldG4N3L8HCT1ae2jCZow9qMmQZ+psaU7d+xCDLqSR6Yu36V1/4jZt7vDZRN1S0ipYMiQxafiCtTiDlagxShsAeXj2PPKFoBGLHetWgd8AyTP+Hz8+eUXJZ1KQ90+K8hLLEyglRYDfDOuO/Cp7uIR8ZeEXEithkY3k/hYFPko42guJ3Js0vJtU45Sz5lr9Pp7a9odRmmf9GvpEXxU7pKwE3D3Q6UE6aK9pzp6vx7UM9RnfSbAypqXSlRFAATTvV4NafNAdv42oeTjaFDgyKkHO3ouFIyUnwJAj/G752PZKC76VfWPCz53QiSAwYUroH709rmevl6hi01qStPqDPKyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8936002)(54906003)(6916009)(26005)(64756008)(316002)(66556008)(52536014)(76116006)(186003)(82960400001)(66476007)(8676002)(122000001)(83380400001)(86362001)(4326008)(38100700002)(66446008)(2906002)(9686003)(33656002)(7696005)(38070700005)(5660300002)(71200400001)(6506007)(508600001)(55016003)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzVacHZXN1pBclNDRzR2UFpPamk5UUFNMkNZRW1QMkJSUVlCNXR5UWgwUkxB?=
 =?utf-8?B?R0JkQzdueEVVekhidFBOKzhEQzNadjRwbEpQU25IYkFGUFVuUkNRblBRSjlj?=
 =?utf-8?B?VndzaTM5OTk3YTlTay9JdHRYRDBWSWRsNDNydEpXT1JCMU51aVI2NzVnbmRm?=
 =?utf-8?B?OEhVcmZ3cG1jaCtYdm56K09EWnNPTnVJZzRJR1NZV0VuQWRwa0tnYnZqR3ZZ?=
 =?utf-8?B?OFg2Uks3MXVlRUt4YURDaEZjRjc3U0NPb3NJclJRaVZZZUgrdHEvYWhGa1Fq?=
 =?utf-8?B?SXYrdjdjTUd4cGhKbXhrVDBBci9nMjVXZU1nVXNaWlBJNU9IYWgwcGdIL2cz?=
 =?utf-8?B?TlpxaFBpVFpRK1FZWGdKN01pVTd4bENibFNtdm5uZHd0N0ZSTDlqR2ZUSklH?=
 =?utf-8?B?ZHR1V0hEejJNdUdPVFZtS2JyRGY5Zzg1czJ2NWJmWThpSEtVdTNIZXlIL0g1?=
 =?utf-8?B?LzFoWEQwZDF2NmRyMnZMYU9wYndmSHRmUjQ3cktFYjFVNXhKTUpjc290b1M2?=
 =?utf-8?B?ZGRJbVhpSFFwT0ZVdzNBbWR6QjZsY3RkMTBEaXFhOEZlalZkZDJaVUorMm1L?=
 =?utf-8?B?MUhzeG9WMDdyV3F6aE5RS0Yzb3VlNU9IK1hXT0hOSHRJak9MWnhYWGhxN3F2?=
 =?utf-8?B?eVFIVkw0NW16T0ZnMk5pd3R1S1JNYXBreFJJa29OTFpIc3NqSlR4TEdXNGt1?=
 =?utf-8?B?MjRtdFhkLzZqTEkwWXBCVkczMnk3bW9ra1VtUGRadmtGdUZCRHZjMXhTSEtH?=
 =?utf-8?B?cVl5WENHbDZIb2lOZStBV1B1QTVCbGNhZzBtOWtkVEUvTUlMc21KazUzNmJW?=
 =?utf-8?B?aHNjZ0dkUE5HQjMva2crcnFYRU1BcjZlanNxOUVLOHZjUUt1dm5ZMHpFZWxI?=
 =?utf-8?B?UVJDaUszRk5yNmtwQ2VNZzZBOVNjNk5OOGpXYmprY2dmckV0eG9TajRyKzZL?=
 =?utf-8?B?dGE5dUpHbnlSL0oreGFqNm9EWWxKYTIrNDJkQlR3MmdDL29GZVVOQjdYeUZZ?=
 =?utf-8?B?eUkxTlU2VGNMUDNlazhSVGhhV3dPT2JpWUx4UzhvOWJGRS9ERzJFQW1tQ1VU?=
 =?utf-8?B?RGwwaklDMURmQjk0TjhXZUYvWUlJOUNGUHkwSThJcldzVDlmV3pMbktoZ2hm?=
 =?utf-8?B?SGVudFBpTFZJY2o3WGVBazFKTmpSZTEveDVZazVVbW9veDFPSCtKbkQyREFU?=
 =?utf-8?B?SjdaTFk3ZlNYd2VQRTlxZXI1VlNjWXlZSTN4eEp4MmRYUytuVXdzN1REWWRq?=
 =?utf-8?B?djUwYk5YNSttQ1pPTlJ6WFRmRlY2MU5NQ3FxdGx4U2tCb281K2poNDFGd2xF?=
 =?utf-8?B?ZjRpMG51ZFpjNWQzcDBGYzNxUHI3ayt0Z2M1eE5HeUlPdXJUM251enBSVGRK?=
 =?utf-8?B?YU9kVjNKSEFIcjZlU3hKeGduRlRyNHdZRjUwUGtQTjhnQVNUL0FrRmlDWWEv?=
 =?utf-8?B?T1BubE92d1B4eU5zaHArdGY3VlU3Q0RRTzN1SHI3aFJUVHk2V1BXUS91dnBB?=
 =?utf-8?B?SEdLVVFPcGtleXFrMHlWVXk1OXlxbDg1QnNvTmpOTTdLNXpDd0o2VFlLaDFV?=
 =?utf-8?B?RHNQMTVNK1F2MEJDK2VWRVJJTEpzck5LZHdyd0xmNHRKejlHMEcvYXE0R1dt?=
 =?utf-8?B?SERBYkFBdWNXd1kvaUZtZDdlOE83RXNud2NoNmpYNWs4a1ZMRXUvNzlPYmVI?=
 =?utf-8?B?ZGk0NzRkQzlTUFlyWndiYkp1TWJtU3gySmYrdHhmbHFNQnM5aWlTdnpVa2cz?=
 =?utf-8?B?UEVZRk1lcDM0Qm5Vc0MrSU90Ly9MRFZFL0lzK1BFV1NVaGpDYzdpM2xDMTlX?=
 =?utf-8?B?c0dRZWpmQ012RUYxNUIrUmdCOU53ZGI3NndDM2dKMnJweVA2RUlUeXVzK0xr?=
 =?utf-8?B?d1NsdmZNM0Y5cXcyUVZ5ZTBlSWtHNEFpQXB6NHlrb21NZi9Qa2FuK0RyUHc2?=
 =?utf-8?B?NHlBanRHS29XVlRNcHFxbEs1K04rQjljakM3Uk1uY00zazFoQ2FxR2loWU5B?=
 =?utf-8?B?Ylk2aWpTWGlKbWk3ODJhTkpJcFpNWC9CMUdIWWRkSHV1ZXhzbFBaazdlb2dW?=
 =?utf-8?B?QXM2aVY3Nnh5c2hVVGdkNzhoczd3czZuT0ZNeVZlYUdQZWc3V0Z6TXVKT3Za?=
 =?utf-8?B?TitlRDZKL3IzVkdRb1JEUnRuNnpHaXg2dUdDM1VSL1dWYVVVaEVQalVleXFX?=
 =?utf-8?Q?2r5+8CZJRczK4DiAJRQGPOM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20508dfc-3b04-447c-6702-08d9f1bd6331
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 02:29:56.3837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ePdkAZphAfb0b1w6mXzKWLC/ZgW9/t66Poh3NAO8u6qgKM55x7ATOeN+JZpTy+TL3q2pNgmvQbAhTJPOwtkNKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5440
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEZlYnJ1YXJ5IDE2LCAyMDIyIDg6MTQgUE0NCj4gDQo+IE9uIFdlZCwgRmViIDE2LCAyMDIy
IGF0IDAzOjE3OjM2QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiANCj4gPiB0aG9zZSBy
ZXF1ZXN0cyBkb24ndCByZWx5IG9uIHZDUFVzIGJ1dCBzdGlsbCB0YWtlIHRpbWUgdG8gY29tcGxl
dGUNCj4gPiAodGh1cyBtYXkgYnJlYWsgU0xBKSBhbmQgYXJlIGludmlzaWJsZSB0byBtaWdyYXRp
b24gZHJpdmVyIChkaXJlY3RseQ0KPiA+IHN1Ym1pdHRlZCBieSB0aGUgZ3Vlc3QgdGh1cyBjYW5u
b3QgYmUgZXN0aW1hdGVkKS4gU28gdGhlIG9ubHkgbWVhbnMNCj4gPiBpcyBmb3IgdXNlciB0byB3
YWl0IG9uIGEgZmQgd2l0aCBhIHRpbWVvdXQgKGJhc2VkIG9uIHdoYXRldmVyIFNMQSkgYW5kDQo+
ID4gaWYgZXhwaXJlcyB0aGVuIGFib3J0cyBtaWdyYXRpb24gKG1heSByZXRyeSBsYXRlcikuDQo+
IA0KPiBJIHRoaW5rIEkgZXhwbGFpbmVkIGluIG15IG90aGVyIGVtYWlsIGhvdyB0aGlzIGNhbiBi
ZSBpbXBsZW1lbnRlZA0KPiB0b2RheSB3aXRoIHYyIGZvciBTVE9QX0NPUFkgd2l0aG91dCBhbiBl
dmVudCBmZC4NCj4gDQoNCkkgc3VwcG9zZSB5b3UgbWVhbnQgdGhpcyBwYXJ0Og0KDQoiSXQgYWxs
b3dzIFJVTk5JTkcgLT4gU1RPUF9DT1BZIHRvIGJlIG1hZGUgYXN5bmMgYmVjYXVzZSB0aGUgZHJp
dmVyIGNhbg0KcmV0dXJuIFNFVF9TVEFURSBpbW1lZGlhdGVseSwgYmFja3JvdW5kIHRoZSBzdGF0
ZSBzYXZlIGFuZCBpbmRpY2F0ZQ0KY29tcGxldGlvbi9wcm9ncmVzcy9lcnJvciB2aWEgcG9sbChy
ZWFkYWJsZSkgb24gdGhlIGRhdGFfZmQuIg0KDQpZZXMgaXQgY291bGQgd29yayBpZiB0aGUgdXNl
ciBkaXJlY3RseSByZXF1ZXN0IFNUT1BfQ09QWSBhcyB0aGUgZW5kIHN0YXRlDQood2l0aCBTVE9Q
IGFzIGFuIGltcGxpY2l0L2ltbWVkaWF0ZSBzdGVwKS4gSW4gdGhhdCBjYXNlIHBvbGxpbmcgb24g
ZGF0YV9mZA0Kd2l0aCB0aW1lb3V0IGNhbiBjb3ZlciB0aGUgcmVxdWlyZW1lbnQgZGVzY3JpYmVk
IGZvciBTVE9QIGhlcmUuDQoNClRoYW5rcw0KS2V2aW4NCg==
