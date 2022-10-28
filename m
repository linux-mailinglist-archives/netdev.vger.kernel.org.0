Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A6261149C
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 16:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiJ1Obl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 10:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJ1Obi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 10:31:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89851B5748;
        Fri, 28 Oct 2022 07:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666967498; x=1698503498;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pBfXY04c3CahdS4iqaX5vG/AEMt7uVeEBR5IK2e0GUI=;
  b=Ox6zXglrF8mAZmq30tFU9wsmjzYu4uzVmL4l0SjSnoGji18+mXMZ2EGD
   pdhn1Ap8gMEcn47fji5vxhSbwebQ1nRhTghlFi67hoQrMGGvHIFHue34i
   fZ4a49LnJjba9uPIOkP7m3FveYUoDPbn0OXR5lbz/sXgd0HIy2CxYfuyC
   dKkDkSBcQLwMu3aL4kY2EvQAAlO05S3tLSXR4yZ8VYM1v0JTM571UP3wC
   g1vPaq4dLqWCnLdfXRCFktbVl9Ndpp+TxZQtwc3HOCJWNCF34bFnXTDWr
   Su8hgU8bgjoD9ZgBtQ2a7sR/paZfVvo3Db88D3u6itmZn4Hdwb3ojsqfG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="309594524"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="309594524"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 07:31:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="877980338"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="877980338"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 28 Oct 2022 07:31:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 07:31:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 28 Oct 2022 07:31:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 28 Oct 2022 07:31:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggmfJJP4GQnyENxiV2MTcONjVc1UR8LHF5VT29iVAJu0wHn971KfVV7Uxi2s9mx2kWmI6mjSNSilCZTbeilazviIRM+MbXs1u8biE1zZbRpq96TNkrqW98w3WctOWlxhnjvN7Tf0x8hTZyzujX0lIxJuSmI+bMeVTsqq0GUkAdP9/9tmQ46ULalxkdBLACvSCp6D4VTZaPWBlizvFhUzsC/thDIkJmraQu0wroFeJqh82hPXmS199KfBYbPT6GguGimPuSd7AUJNgjRm16tpG+ZBCSmPbpsGuJ30+OCFpGM6F2/I/Kg/nYCablerk2LkxtuCrai3vchAj7SYt4smjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBfXY04c3CahdS4iqaX5vG/AEMt7uVeEBR5IK2e0GUI=;
 b=la18pGOh3AloZNqRvjj1SDBwbwsDtpKaSKVScZbPCkkQKmgG9JYGwoHkudZrH/1A1EEZgsMn9xiNDpA4FZJqltZyMeHKmfrvl2BY33Re9C6PKuhbc9GwIkCgbqBK2G3NMyEkpwiBWcPDomg7y2GxkVJIaKq0xYR2G4QJh8U85e4ETBKdnAZTyJqUZ2ICMIN7XFArwtM9i00j9LDX7Bmn+OzRgFdg4h5e5l107k5uZSYjPHRa4UO2y5oNnVNt3kIY6FILBYqDq+a/vQj1eMHAyIMdLxrEmUQeh6UzgJ8gWtuX5ZxdMYpbasVJks/wlXG+qFTUMu+9JEUevK5Izb8V/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB5792.namprd11.prod.outlook.com (2603:10b6:a03:425::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 14:31:34 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%4]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 14:31:34 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        "Phil Edworthy" <phil.edworthy@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v3 8/9] ptp: ravb: convert to .adjfine and
 adjust_by_scaled_ppm
Thread-Topic: [PATCH net-next v3 8/9] ptp: ravb: convert to .adjfine and
 adjust_by_scaled_ppm
Thread-Index: AQHY6r0Um98f1keA7kaCmxN/8bj5Ga4jphkAgAA4QDA=
Date:   Fri, 28 Oct 2022 14:31:34 +0000
Message-ID: <CO1PR11MB5089C70AA505ADFFE7FFEDD6D6329@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221028110420.3451088-1-jacob.e.keller@intel.com>
 <20221028110420.3451088-9-jacob.e.keller@intel.com>
 <ce3a9441-7bfd-a876-c21f-5337716da3a5@omp.ru>
In-Reply-To: <ce3a9441-7bfd-a876-c21f-5337716da3a5@omp.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SJ0PR11MB5792:EE_
x-ms-office365-filtering-correlation-id: 5b0258ff-5870-4249-c737-08dab8f11d51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pQTZvtDjTzAoE3Oig5aUdkQeyQUk1psIMzxcR6vg9z/K35Q9Vpxrlo/RKnt191OW0m3mQBNGvX+eaRG/apOYKtEQAZCLURnY5/ytqNb11JWXzY0w+LQgg/onUKhWezVGgQBYZxUeHq4u7nVoU9E9hBCvgtmwm2emopt6R9GaJIQIzd7u9ezVZeuCCnbvySlqsdhQEAPVPpKip88O1mT/+uTc6Ajm7RkE0IurL1Y7fJxhEFbWJZTRoFHq/6dEuiLMLq2RAYzk+RzZnpDmxFSy4Rx4gHMjb06W8jh6HdJIOn+CZd1tWSsrbcDb+RtUrQPNkrc+WScq8TqJQPXo02YQahksVsq1olyl5h/LYXPuLshDa4pJIT3DiRrM4Lsz06oPEXKQSI6n2TaxmPQUzXInBM70qisya8XTy5qADHV52cH604thIadI1zFtJlZqJX/dkW7IMxvwDMfIdel6hyMAyf6ZLGIYLkAy32t6tJi7m0mb0Ie4YHx8bpGa5+7Y5dXuTkMOEMw9h1v2cKnthS/+lUDHuOc4OZZPbz+DrrgjkswgJn3yaTIXURAKtrpyiTdwUvl8ef6mS0VnmeijPSdNoFW13L3ROGoJ7pazYX8rsE2v9t2gzIKUobTd4MNG3/H5sPnW7oaNX5SqN7LPvNeY3WGb2FjuUG99CUsc9CNDL0bVx1pKwjQOtR7Pp2aZDP7gPAw6dcVnV/sy8QdAOMWFMExKhJWq8PwTW4oKQisId26w1wnrU9aqvTlowy1ZUpxUdXErr6B0/S+IZ/4e9pXA0q5VZ3v7Arvva6BUaoVDWBk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199015)(2906002)(8936002)(5660300002)(316002)(66946007)(66476007)(66446008)(64756008)(8676002)(66556008)(110136005)(76116006)(54906003)(6506007)(7696005)(71200400001)(478600001)(33656002)(52536014)(41300700001)(53546011)(83380400001)(26005)(9686003)(186003)(38070700005)(4326008)(122000001)(38100700002)(55016003)(86362001)(82960400001)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3hzVWpZZStRQXl3SlNNMUtWczR3c28yUUg1Q3BMamNPdlZtUkFQVkFGMG0x?=
 =?utf-8?B?TDFYN1NuaERxd0M2aHk1N3ZCcHNyRHNyV2w3Y0o3VHNVNVljTU1DcEFPRzMv?=
 =?utf-8?B?NFkyWnpTK0tGVklxTnliQVQ5ejFhMzlDcmJwTVVJYnFqellpZDhzVk95YlRX?=
 =?utf-8?B?QUs3SXFpTStyQkRDQ3Y3VkgyaUkvRkFtZTQ1aGV2amdHNWpkZEJtcUh6S2Rq?=
 =?utf-8?B?dDlEV1ZoLzRwRi9rSXdWZjN1U1BIUEJvWGhENnY3elVseVpoQTlUYkViVU5r?=
 =?utf-8?B?MzZ0L1pYZ3JUV04xL0l0dnVPZmlwdXFybFRRMVVQdlhmYmVsYTdCZGFlYWV3?=
 =?utf-8?B?NktCZHQ1Sy8vZ2l3R2VjME5nWDdDQnFET1ZFZjFyN21UQjFqdDd1aUlRT3lY?=
 =?utf-8?B?cWpOOVBGYXIxSVFtVEE0NFJGZkx1UThhNDBSdVk0ak1Id005NGRvdkRSQkMv?=
 =?utf-8?B?UVVEMmxZWFlRbTIwcEkxSkd0UVRJK2tXNW1teFRGM0pmOW1oelB3eFdXWXBQ?=
 =?utf-8?B?ckVzQXU4cjVta1FRcnozYTRuVHBYTHpyd01YRFJIbkcxOTZCTnpUUDVlb1hK?=
 =?utf-8?B?UStkRkxMdkJTaE5kMVBpNHpGWVpKZExQSUtSZlJubHJQK1cvbFQ1UXpWbjZz?=
 =?utf-8?B?N2Q3MXFWdkZTSS9aZnBCdG5mVWgwU1FGWGtBVG9zNFVlNUJ6Mjl3VDJYVHd0?=
 =?utf-8?B?azlSTXZPS011YWJTMlFQelh5VDFkajZEZlVrK05uQTMrQncxM2t2NXRTVEor?=
 =?utf-8?B?a1poQU1HdEJpcFNybnVmazAxbjAvR3dROHhkV1kxNzVCRnM1VmRzczRQWGJ2?=
 =?utf-8?B?bUVBTW50ZW5oVVNmbjdHS0tpbzRDUGRyUkQzdWJSc1kzdjJTeE1uYnVhWi9Y?=
 =?utf-8?B?emNrSy8yV3dyTVNibkdYQmNCQk5MVXhpQ0FkMWJWVkcycVhWTi8yTlRnN05x?=
 =?utf-8?B?Y0xMblZpR3lFMllKdGtqeVYyZllqK0RSQWF4ZEJWNUtFM1FlTGluUmtYYWcw?=
 =?utf-8?B?cTBWcXM2bmUxSnNjNVJOTGs2VjBvbVFtcFFWa2g1YW8weEpmNlBOUW1TY24y?=
 =?utf-8?B?R3U0aVhJNm82T1hhNnE3bWZ1UStVM3ZzaVcxKzVmYzJuM0VCNHI3Rm1pNWpP?=
 =?utf-8?B?WDB2UUwvK3ZlYVJyYTRRY1lTU3I4eHlWVFNvYnJ1YVRSV3E1Z1M5c2dSajBS?=
 =?utf-8?B?TEM0WTFGTFlRZk40MlhPSVR0a3VtUW53VDNtQllBMExlMHU5Ynkrd2pyMzlh?=
 =?utf-8?B?SXNDSHdIdmxma2ZqekdhLzI0N0lrUFdJeCtJa3FZQThpd0Q5RGxPYWU2dFVK?=
 =?utf-8?B?TUxwNXJCWkFlS0NCUTdNbk9GV1lUVGM1bEEySTA2T05ESGhBekJyY0NBbWVY?=
 =?utf-8?B?K1ZwWmlCaU5OMUthOG05TFU5QmVhWWFFY0ZvZVluTFNVZm83OXhrelZzd0NG?=
 =?utf-8?B?cFlTUFM4QUd3VlJyc0FneXFBZWxXd3VFMGRJRDBibmZMRW53NTJLL0VXclpP?=
 =?utf-8?B?bTR6VUEvd3JRc1U0WmZpRXBIVjFhQ09pbkp4eGd3SU8rbFh6SHQrK3h4OHg2?=
 =?utf-8?B?QXg0RnJKcjlKRklocGVOblA3ZFQrUVNPaXJNa1Rnci9FeUh4UG85RGJQRk1Y?=
 =?utf-8?B?V21KRWVWOUJkN2U2N0JmOGZvUkdNMHVoWGdYYjRDSzlNZUdHRm1RYnhKMWFx?=
 =?utf-8?B?NUhPV1ZCbm1VWUJqdU1hK2hIT2I3Y1hGVmt4SmRhKzRrVkJYOGN2emw2SzZl?=
 =?utf-8?B?UVBPZHpoQVJhRkxRMzBNcFRYZU1pVnFzNFR1b3FSaVFKWFdQRVNlMEdxUTlq?=
 =?utf-8?B?NVIreks1MDhKUTVLczJwNEk3MzgxZDBBeUpTQUlDZzdYeEFLejIwaXlJQzBj?=
 =?utf-8?B?eGg3QkJxK1E5Vy9rNlNhRlBXVkZlZHh4VXJ4MWErVUg0cGZram9Yc0NxdkJY?=
 =?utf-8?B?SHkxd2oxZmxSbFZoMzlleGFDZFUwalQ3OVJId2JJZFFJcnBCRGRSWkIxc0dF?=
 =?utf-8?B?V2I0aW5YWEZ0dkM4TndTQ3g4a0VlclR2RXpEekZlWVJXUEllbzZ6eXRzSWp6?=
 =?utf-8?B?VlNacGlUbjZPNVk1R1JWdlJLZjRVTjdyZjN6TnByaDMyZEh4S2JTdXd5eWhV?=
 =?utf-8?Q?RygrtsYXmcmWvV3IffO5I7vxC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0258ff-5870-4249-c737-08dab8f11d51
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 14:31:34.4561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: twNicRUMkFC0DLr0zurztltMLJMO+/977Fqk1FjZdPhz3Dm7WCTCLj9s2D1txsvRBLlw9BrhUFf2B0xc4rpzH+zr/PZ7TBbYT7mysB0BJD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5792
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2V5IFNodHlseW92
IDxzLnNodHlseW92QG9tcC5ydT4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDI4LCAyMDIyIDQ6
MTAgQU0NCj4gVG86IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPjsg
SmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IERhdmlkIE1pbGxlciA8ZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldD4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFJpY2hhcmQgQ29j
aHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPjsgQmlqdQ0KPiBEYXMgPGJpanUuZGFzLmp6
QGJwLnJlbmVzYXMuY29tPjsgUGhpbCBFZHdvcnRoeQ0KPiA8cGhpbC5lZHdvcnRoeUByZW5lc2Fz
LmNvbT47IExhZCBQcmFiaGFrYXIgPHByYWJoYWthci5tYWhhZGV2LQ0KPiBsYWQucmpAYnAucmVu
ZXNhcy5jb20+OyBsaW51eC1yZW5lc2FzLXNvY0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDog
UmU6IFtQQVRDSCBuZXQtbmV4dCB2MyA4LzldIHB0cDogcmF2YjogY29udmVydCB0byAuYWRqZmlu
ZSBhbmQNCj4gYWRqdXN0X2J5X3NjYWxlZF9wcG0NCj4gDQo+IEhlbGxvIQ0KPiANCj4gT24gMTAv
MjgvMjIgMjowNCBQTSwgSmFjb2IgS2VsbGVyIHdyb3RlOg0KPiANCj4gPiBUaGUgcmF2YiBpbXBs
ZW1lbnRhdGlvbiBvZiAuYWRqZnJlcSBpcyBpbXBsZW1lbnRlZCBpbiB0ZXJtcyBvZiBhDQo+ID4g
c3RyYWlnaHQgZm9yd2FyZCAiYmFzZSAqIHBwYiAvIDEgYmlsbGlvbiIgY2FsY3VsYXRpb24uDQo+
ID4NCj4gPiBDb252ZXJ0IHRoaXMgZHJpdmVyIHRvIC5hZGpmaW5lIGFuZCB1c2UgdGhlIGFkanVz
dF9ieV9zY2FsZWRfcHBtIGhlbHBlcg0KPiA+IGZ1bmN0aW9uIHRvIGNhbGN1bGF0ZSB0aGUgbmV3
IGFkZGVuZC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEphY29iIEtlbGxlciA8amFjb2IuZS5r
ZWxsZXJAaW50ZWwuY29tPg0KPiA+IEFja2VkLWJ5OiBSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRj
b2NocmFuQGdtYWlsLmNvbT4NCj4gPiBDYzogU2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9t
cC5ydT4NCj4gDQo+ICAgIFlvdSBmb3Jnb3QgdG8gY29sbGVjdCBteSBSLWIgdGFnLi4uIDotLw0K
DQpPb3BzLCBJIGFwb2xvZ2l6ZSBmb3IgbWlzc2luZyB0aGF0Lg0KDQo+IA0KPiA+IENjOiBCaWp1
IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gQ2M6IFBoaWwgRWR3b3J0aHkg
PHBoaWwuZWR3b3J0aHlAcmVuZXNhcy5jb20+DQo+ID4gQ2M6IExhZCBQcmFiaGFrYXIgPHByYWJo
YWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gPiBDYzogbGludXgtcmVuZXNh
cy1zb2NAdmdlci5rZXJuZWwub3JnDQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdleQ0K
