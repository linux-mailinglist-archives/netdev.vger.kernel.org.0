Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B17F589A0B
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 11:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239350AbiHDJnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 05:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiHDJnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 05:43:09 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129065A2D8;
        Thu,  4 Aug 2022 02:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659606189; x=1691142189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uL8TRVvhNeHNFdjOg8cy4BEKDqwSdgmb0CwoZhAm2lo=;
  b=AWbWkEOTGnBMTuGSNHnfkwOZHMRTc2HAQrKEZ6tITTOcQm547l+E8Zpn
   hn7gUAWFAe/ovHK0REulE0wqCGQ+uzMqINo8hpAKoMbGhZvBBCpFne0qX
   e7sRef7S0LtzmteQxOjP+6iDxYj2lBprhzlUauw6Hl7r4Bxmqwij5dcn6
   J2ZQlJw7VApTRGbduWEA9PC7lUl02M2dcjQSgeQFomEB5MtZ2T7OPmgP8
   5xnvMya+x5agkxrO4ETLfvUO5EFQYlN5y5O0NKleJs8vXhZ5hTlMHODyP
   q+xC1YNjj+Wb47kfz3vEKi1wZbD39ixRIZWBxCAOea4trzJFhjKdZ48g/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="290667028"
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="290667028"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 02:43:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,215,1654585200"; 
   d="scan'208";a="671207856"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 04 Aug 2022 02:43:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 4 Aug 2022 02:43:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 4 Aug 2022 02:43:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 4 Aug 2022 02:43:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKUsXtKWXTKBkEHA+o7TaBl6Sq6Ycp11w+aJ8tZ4dEuN3m9Qt8ib3JqsJH5FVLpUvREoRi3JGUNopyQeu33qlJVAQ5jzh9zzOB3EKNZP1nwaTMGp7DpEYKsWsA8OskpbL69/V4z1Zfpd+vbxLDSDRvWXnVvMp5V23D9JBnHR43h/CkdWor57gRkVigkyk82S3vKFmGbjZPm7X9xObAh7RaeaEjeINAOQmTsLvNjzpa65DVk4qLqqdBGFpejsLSqVSMW/B4T0sztADVMs9cD5IX5bEfffX0p2ziCYX1h9rwJnGRtuYUaAosHxQGxTQvZL1n9SbDUPRI5x9HPhgx3gIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uL8TRVvhNeHNFdjOg8cy4BEKDqwSdgmb0CwoZhAm2lo=;
 b=LvYH0osiSN8hnRkrvDGMqvONfPVx3pyX4xig3DBcnaSWLmWhhLumXl9E6m+39aDJSf1zcQbdgLC6TjpALvgsKVtz0O6NBGXXpzkIOOdh99+pzmdnvYOQzfRqQOQDzl/jmV6hkzSMWTLymRXyY4VLwYNuWhJLJKHifR6dTdbJpaORVk7Qg2brCBczzil0dn5KA2sfeKmB0Dp3zGYM7IEqhXzzKcVbk5sYOzROREHbn+fAK2r8BckhdmVSDQzKc0ZzUH3i5togJ4TummYyYnd1KhUeQSpDkAEkYVA2N6X8wo7TGybWBL86tluW6X9jJTF0SLtjOuHQ0wEJ4l8Fu3y0tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DM6PR11MB3257.namprd11.prod.outlook.com (2603:10b6:5:5c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 09:43:02 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::40bc:1ca8:3d44:9581]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::40bc:1ca8:3d44:9581%7]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 09:43:02 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Torvalds, Linus" <torvalds@linux-foundation.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [GIT PULL] Networking for 6.0
Thread-Topic: [GIT PULL] Networking for 6.0
Thread-Index: AQHYp5Hlkif7yLOX/EmmMDvtsmKd7K2ecpKA
Date:   Thu, 4 Aug 2022 09:43:02 +0000
Message-ID: <MW4PR11MB5776854D4FD673F32585950EFD9F9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220803101438.24327-1-pabeni@redhat.com>
 <CAHk-=wiwRtpyMVn1F9KT14H64tajiWsPnd0FfL5-BFnPOuFa_w@mail.gmail.com>
In-Reply-To: <CAHk-=wiwRtpyMVn1F9KT14H64tajiWsPnd0FfL5-BFnPOuFa_w@mail.gmail.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bf9b584-bb21-4bd4-ee17-08da75fdb939
x-ms-traffictypediagnostic: DM6PR11MB3257:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mvYEFd5hoe0L9PnsQElpTPU52UYBJQvNkkLNtzDeW7rUqq74jC5mM5nVqZA4P7KO3iRSFzpQwRQRBDKg6tZ7BZpZ28ObFo92+Erw3d5zv8NMhsVDYjjAW0TJ5XBqXrxx+Nlo+npyVuPMA6sjk9iYF6XJrhksuoRYFM8qqgtgH4o1hPH28QNug31YQR4pwy5naCygWj3qv6u+yLZj6apuq/UhVAIrznsazO3NVLoQV0WVLvEwQwYCipVa/AOe/iMxJuHtVUbKiUuKFOuNus/nfADoFl9fyp7PlPGw9HDG7nF3yXjNar8qH5hgk/9bNUjeVvSGpi+Fu6aaZUE8qATr4CnnwSNFAHhTDY7+f3cgCzx94c0O973CWeW+43xQ2947CaYQupLdQckmM0fSJEfqr80mNTHsSqowG+U56padeJeNHHWUihuq6ry9eOFqf9CXSsmPxhTS6D30cQQs3UBZGLNXId5pvGZ9MobqKII7cayA9izUFHC2pjR0fmNH9LzpKc0dCqOdTZ+27Qsw+sTTGZPQLq0tiwEEyMOFh86mefuW1LrZh9dHNoRXIlDURBtfga1LmS7fPCfqkOq386Xsu+KZZTGp/fiECuJiO39R75yLGnLC/nevpK8V8rOBrRqdCN142lQhZFDuITTUXmh+XJwI/rzNK8XLeud6vhotVr6s/ImJOa8o743765wHgPLx5iRAs75MhYCzybEqerNpA/HBeXbGPJ4W/v1fW9WViWsCJ4OsGmQD1C86cKTdrC6DgGM0BWc3BaLbhRj2TDuzCxwi02Iq81a0TYCSjMGMnlMnATFXHPd7PTeGAljlnPBslpwHd0mMnRD3LpLh+IClOlTMEDCLSxq70oSjRcBxhVQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(376002)(346002)(39860400002)(38100700002)(38070700005)(82960400001)(186003)(122000001)(83380400001)(8936002)(52536014)(64756008)(8676002)(66556008)(4326008)(66446008)(66476007)(76116006)(66946007)(55016003)(5660300002)(2906002)(41300700001)(478600001)(9686003)(26005)(7696005)(6506007)(110136005)(54906003)(6636002)(316002)(71200400001)(53546011)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlhWNFUzWTYvM2s2d3NiSFJUZjNEUDdHMmpsVGI1OHlzNGhzVTFnRmcwblpJ?=
 =?utf-8?B?bXRKeGxsbEt0TzdkUGo5S0hGeTNyRXJLeDV0bjBCVThMN04zejNZMU5YZmk2?=
 =?utf-8?B?VTZSUGlFVFBWM0I5Y0FwUlpyeFRjdVpxTWovMEFvaEtteUpORlJHSStxY0ph?=
 =?utf-8?B?TFNzcjR4Qk1mUjRicjdEYk16b1V4bWhUZU85UUFhdC9BS0w2dVpTSjlpallJ?=
 =?utf-8?B?TTZ3cUM0cElPNUdqZml3WGdFMDkzSDdvOTlsRTVGcXIxKzAveU9DUFFSRU5j?=
 =?utf-8?B?V3ArTUtxSHZHS0t3d2M3ZzBoZmJFNUgvQXlLai8vMWsySUUvNU51Rlo0SFBY?=
 =?utf-8?B?SGJQZW0rOUlzSFN2d0tUeXc0cWRCMlYwcHhDc1dNUW5FRy9OZWl2MEViT2oz?=
 =?utf-8?B?ZXpuNkNWR2s4eWUyS0JWQUxSYmhwbEw5ZGY0aWpIY3dDMCtmVmJXZCtVOEx2?=
 =?utf-8?B?LzFtYzdwSWdEeFFPeVFoNjFYcVZWQVAzMWRZQ3d6R0RkbUk3UVAzUVIwOUlj?=
 =?utf-8?B?UHhkWlZFNFdpMGJpUi84VzJaTjUwSFg1bEVCUEpsQUVUNVlTdUd0dHgySVpm?=
 =?utf-8?B?QW9vLzg1SkRDbG1HUHlMaHRaK3o1UnZBOHV6eCtEKzdzN2tKTFJLcGtBZlNl?=
 =?utf-8?B?NmxEb1AvZlkvWmJsQTBUZEp2T1ZvMlVQUFFFTXM3WDVRaXVTOE94NjNHM3Qr?=
 =?utf-8?B?cy9NUzJyWGN2QWtMMEU1WWNSNXZ0OFVNVTNYRXZ6MDV4aUhkWUNucDk1U3JX?=
 =?utf-8?B?NUhrYVFTV0loQlFxSVRXRG9CcWdWUHkrN0FOaktDSUlrTzJEdGEwZmFjNzZN?=
 =?utf-8?B?dldvYjlpRFpIYndONHNFM3prQ2lyZ1drZm5EZjNPbFNwQ1hFdzdCWWtJV1lz?=
 =?utf-8?B?SXNrM3l3bGdzMTFwdXhGVHhSUHRDK3NuY3VwOFlTbnVSVnJXMjNRZTJSNE5U?=
 =?utf-8?B?NmRPNXhOVER2RW96S0NkdUVLbjBsL1YrQ2ZPYUZXckZkL2hOakNwS3RDalI2?=
 =?utf-8?B?Sk5QMGpmZkFhV0RpQmVVV0YwNTBhRTM3REtoLzdhZ3BmK1VjdmpVZTB6MEly?=
 =?utf-8?B?SDU5ZVB4UjRjZzFzcmRPUXorL09HZlBXZ0lTazA0SWsyM1JrUUFHaUVBK2x2?=
 =?utf-8?B?K081RjdHYzc0bHAzOVRIUFd0dUZSUEx1Y3BsT3FpZytMU1R5MEdSMEJGVXB2?=
 =?utf-8?B?SVM1Mnc4STZpOC9OeU80eEMrN04rVDRvSmpsazc0RzJqNjcvSnRTc3B2VDBF?=
 =?utf-8?B?TUJFVTFLaGhHRWJyU0FpWXRrTEFSd3VidmRGVVpJaDB1Z2lBQW5uaGhNSGpM?=
 =?utf-8?B?NjFkdDVqaWU4NTQ3OFdpR05OZDZ0WllEYlFHQVEzY3YyTlFoVUtneGYrd2dM?=
 =?utf-8?B?T0lOOTVBRllnUVBQRTJJMUdKc1hCMWZhcmdkZmRnV1lJUHJ3L1pWK0t5c2Rz?=
 =?utf-8?B?eklvOHp1R0w0WUh4dENSSjg2NkNVRklpWFE1T1ZXSnFZYXRleWFwSFJlSmhY?=
 =?utf-8?B?c0E5Z0RRNm52RmZ4Z2pLbitsZVlmV1pXM0VCV3VjM1dIK2wrbVhRTE1wMDdL?=
 =?utf-8?B?QnIzc2NFTEtGTjFzMTdWaitnUjJoN2YrZFpXL0ZaOGNBWnorWGNXQ3JKK29q?=
 =?utf-8?B?MnpEYzhyNStGd0pxcWZDdTNHWXIxZEMrMC8wTUVOeU5DdDF3UDM4dFZxQ0pj?=
 =?utf-8?B?aDR5ZTB1MXk3MlU3SmR0Y2Y5eWRiVUJoRnROSVBsQU1BTGhBWmZ4Sml1aUpt?=
 =?utf-8?B?aDJEZ2FsZnorM1RPa1JHbUNyQndXb2RKUTMxNkwzWFRIdVlFbSs4L05pdWhD?=
 =?utf-8?B?L3p2dEhVS0lhZkttdm1kQlJWelk0N0JvWmtMTEdPbVhURThSaVkzMk03QjFy?=
 =?utf-8?B?Z1FHVlZBYUFQNUwvK2lneGNESjdsSWNEVGpFdmZDMHF4N01xdVhvSGpoREda?=
 =?utf-8?B?Z3ZKY2Q3RngrVGJhZkhqNGtKSDdEZUsralNiWitSZHhBdTA1YUJ1YTJBamRS?=
 =?utf-8?B?Tng1VGl0ZytvajJ3bmpJdnN6Zm92VXNBcVVxNnk2QUIzSDVYdUtXSW5weGdX?=
 =?utf-8?B?eEg5ejYweUNKODY2UzVOTkNjd0pCbml6ZTZsR21UMi9tdVJnalVMM3EyK2c5?=
 =?utf-8?Q?BWksjkyB8zcHnpV098j27WS1d?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf9b584-bb21-4bd4-ee17-08da75fdb939
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2022 09:43:02.0634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ebGX8ofSXi1BHGv9G53T5BVN+hu4uWBbCb+rA6T0BmBKDlWivsdFWTIFmvQbnmyGMB/17CnGYXkoQhr9qNm39Om/P0g7hIm2Oe5AdNxK60U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3257
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGludXMgVG9ydmFsZHMg
PHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBjendhcnRlaywgNCBzaWVy
cG5pYSAyMDIyIDAxOjM2DQo+IFRvOiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+OyBH
dXN0YXZvIEEuIFIuIFNpbHZhIDxndXN0YXZvYXJzQGtlcm5lbC5vcmc+OyBEcmV3ZWssIFdvamNp
ZWNoDQo+IDx3b2pjaWVjaC5kcmV3ZWtAaW50ZWwuY29tPjsgTmd1eWVuLCBBbnRob255IEwgPGFu
dGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0KPiBDYzoga3ViYUBrZXJuZWwub3JnOyBkYXZlbUBk
YXZlbWxvZnQubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbR0lUIFBVTExdIE5ldHdvcmtpbmcgZm9yIDYuMA0K
PiANCj4gT24gV2VkLCBBdWcgMywgMjAyMiBhdCAzOjE1IEFNIFBhb2xvIEFiZW5pIDxwYWJlbmlA
cmVkaGF0LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBBdCB0aGUgdGltZSBvZiB3cml0aW5nIHdlIGhh
dmUgdHdvIGtub3duIGNvbmZsaWN0cywgb25lIHdpdGggYXJtLXNvYzoNCj4gDQo+IEhtbS4gVGhl
cmUncyBhY3R1YWxseSBhIHRoaXJkIG9uZSwgdGhpcyBvbmUgc2VtYW50aWMgKGJ1dCBtb3N0bHkN
Cj4gaGFybWxlc3MpLiBJIHdvbmRlciBob3cgaXQgd2FzIG92ZXJsb29rZWQuDQo+IA0KPiBJdCBj
YXVzZXMgYW4gb2RkIGdjYyAibm90ZSIgcmVwb3J0Og0KPiANCj4gICBuZXQvY29yZS9mbG93X2Rp
c3NlY3Rvci5jOiBJbiBmdW5jdGlvbiDigJhpc19wcHBvZV9zZXNfaGRyX3ZhbGlk4oCZOg0KPiAg
IG5ldC9jb3JlL2Zsb3dfZGlzc2VjdG9yLmM6ODk4OjEzOiBub3RlOiB0aGUgQUJJIG9mIHBhc3Np
bmcgc3RydWN0DQo+IHdpdGggYSBmbGV4aWJsZSBhcnJheSBtZW1iZXIgaGFzIGNoYW5nZWQgaW4g
R0NDIDQuNA0KPiAgIDg5OCB8IHN0YXRpYyBib29sIGlzX3BwcG9lX3Nlc19oZHJfdmFsaWQoc3Ry
dWN0IHBwcG9lX2hkciBoZHIpDQo+ICAgICAgIHwgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+
fn5+fn5+fg0KPiANCj4gYW5kIGl0IGxvb2tzIGxpa2UgYSBzZW1hbnRpYyBtZXJnZSBjb25mbGlj
dCBiZXR3ZWVuIGNvbW1pdHMNCj4gDQo+ICAgOTRkZmM3M2U3Y2Y0ICgidHJlZXdpZGU6IHVhcGk6
IFJlcGxhY2UgemVyby1sZW5ndGggYXJyYXlzIHdpdGgNCj4gZmxleGlibGUtYXJyYXkgbWVtYmVy
cyIpDQo+ICAgNDYxMjZkYjljODYxICgiZmxvd19kaXNzZWN0b3I6IEFkZCBQUFBvRSBkaXNzZWN0
b3JzIikNCj4gDQo+IHdoZXJlIHRoYXQgZmlyc3QgY29tbWl0IG1ha2VzICdzdHJ1Y3QgcHBwb2Vf
aGRyJyBoYXZlIGEgZmxleGlibGUgYXJyYXkNCj4gbWVtYmVyIGF0IHRoZSBlbmQsIGFuZCB0aGUg
c2Vjb25kIHNlY29uZCBjb21taXQgcGFzc2VzIHNhaWQgcHBwb2VfaGRyDQo+IGJ5IHZhbHVlIGFz
IGFuIGFyZ3VtZW50Lg0KPiANCj4gSSBkb24ndCB0aGluayB0aGVyZSBpcyBhbnkgcmVhc29uIHRv
IHBhc3MgdGhhdCAnc3RydWN0IHBwcG9lX2hkcicgYnkNCj4gdmFsdWUgaW4gdGhlIGZpcnN0IHBs
YWNlLCBhbmQgdGhhdCBpcyBub3QgYSBub3JtYWwgcGF0dGVybiBmb3IgdGhlDQo+IGtlcm5lbC4g
U3VyZSwgd2Ugc29tZXRpbWVzIGRvIHVzZSBvcGFxdWUgdHlwZXMgdGhhdCBtYXkgYmUgc3RydWN0
dXJlcw0KPiAoZWcgJ3B0ZV90JykgYnkgdmFsdWUgYXMgYXJndW1lbnRzLCBidXQgdGhhdCBpcyBu
b3QgaG93IHRoYXQgY29kZSBpcw0KPiB3cml0dGVuLg0KPiANCj4gQW55IHNhbmUgY29tcGlsZXIg
d2lsbCBpbmxpbmUgdGhhdCB0aGluZyBhbnl3YXksIHNvIHRoZSBlbmQgcmVzdWx0DQo+IGVuZHMg
dXAgYmVpbmcgdGhlIHNhbWUsIGJ1dCBwYXNzaW5nIGEgc3RydWN0dXJlIHdpdGggYW4gYXJyYXkg
YXQgdGhlDQo+IGVuZCAod2hldGhlciB6ZXJvLXNpemVkIG9yIGZsZXhpYmxlKSBieSB2YWx1ZSBp
cyBqdXN0IGNyYXktY3JheSwgdG8NCj4gdXNlIHRoZSB0ZWNobmljYWwgdGVybS4NCj4gDQo+IFNv
IEkgcmVzb2x2ZWQgdGhpcyBzZW1hbnRpYyBjb25mbGljdCBieSBzaW1wbHkgbWFraW5nIHRoYXQg
ZnVuY3Rpb24NCj4gdGFrZSBhICdjb25zdCBzdHJ1Y3QgcHBwb2VfaGRyICpoZHInIGFyZ3VtZW50
IGluc3RlYWQuIFRoYXQncyB0aGUNCj4gcHJvcGVyIHdheS4NCj4gDQo+IFdoeSB3YXMgdGhpcyBu
b3Qgbm90aWNlZCBpbiBsaW51eC1uZXh0PyBJcyBpdCBiZWNhdXNlIG5vYm9keSBhY3R1YWxseQ0K
PiAqbG9va3MqIGF0IHRoZSBvdXRwdXQ/IEJlY2F1c2UgaXQncyBhICJub3RlIiBhbmQgbm90IGEg
Indhcm5pbmciLCBpdA0KPiBlbmRzIHVwIG5vdCBhYm9ydGluZyB0aGUgYnVpbGQsIGJ1dCBJIGRv
IHRoaW5rIHRoZSBjb21waWxlciBpcw0KPiBwb2ludGluZyBvdXQgYSB2ZXJ5IHJlYWwgaXNzdWUu
DQo+IA0KPiBJdCB3b3VsZCBiZSBwZXJoYXBzIHdvcnRod2hpbGUgbG9va2luZyBhdCBjb2RlIHRo
YXQgcGFzc2VzIHN0cnVjdHVyZXMNCj4gYnkgdmFsdWUgYXMgYXJndW1lbnRzIChvciBhcyByZXR1
cm4gdmFsdWVzKS4gSXQgY2FuIGdlbmVyYXRlIHRydWx5DQo+IGhvcnJlbmRvdXNseSBiYWQgY29k
ZSwgYW5kIGV2ZW4gd2hlbiBzYWlkIHN0cnVjdHVyZXMgYXJlIHNtYWxsLCBpdCdzDQo+IHVpc3Vh
bGx5IG5vdCB0aGUgcmlnaHQgdGhpbmcgdG8gZG8uDQo+IA0KPiBBbmQgeWVzLCBhcyBub3RlZCwg
d2Ugc29tZXRpbWVzIGRvIGhhdmUgdGhhdCBwYXR0ZXJuIHZlcnkgbXVjaCBvbg0KPiBwdXJwb3Nl
LCBzb21ldGltZXMgYmVjYXVzZSBvZiBhYnN0cmFjdGlvbiByZWFzb25zIChwdGVfdCkgYW5kDQo+
IHNvbWV0aW1lcyBiZWNhdXNlIHdlIGV4cGxpY2l0bHkgd2FudCB0aGUgbWFnaWMgInR3byB3b3Jk
cyBvZiByZXN1bHQiDQo+ICgnc3RydWN0IGZkJyBhbmQgZmRnZXQoKSkuDQo+IA0KPiBTbyBpdCdz
IG5vdCBhIHN0cmljdCBuby1ubywgYnV0IGl0J3Mgbm90IGdlbmVyYWxseSBhIGdvb2QgaWRlYSB1
bmxlc3MNCj4geW91IGhhdmUgYSB2ZXJ5IGdvb2QgcmVhc29uIGZvciBpdCAoYW5kIGl0J3MgcGFy
dGljdWxhcmx5IG5vdCBhIGdvb2QNCj4gaWRlYSB3aGVuIHRoZXJlJ3MgYW4gYXJyYXkgYXQgdGhl
IGVuZCkuDQo+IA0KPiBJJ3ZlIGZpeGVkIHRoaXMgdXAgaW4gbXkgdHJlZSwgYW5kIGl0J3MgYWxs
IGZpbmUgKGFuZCB3aGlsZSBJJ20gbm90DQo+ICpoYXBweSogd2l0aCB0aGUgZmFjdCB0aGF0IGFw
cGFyZW50bHkgbm9ib2R5IGxvb2tzIGF0IGxpbnV4LW5leHQNCj4gb3V0cHV0LCBJIGd1ZXNzIGl0
IGlzIHdoYXQgaXQgaXMpLg0KPiANCj4gICAgICAgICAgICAgICBMaW51cw0KDQpUaGFua3MgZm9y
IGZpeGluZyB0aGF0Lg0KSSdsbCBwYXkgbW9yZSBhdHRlbnRpb24gaW4gdGhlIGZ1dHVyZSB3aGVu
IHBhc3Npbmcgc3RydWN0dXJlcw0KYnkgdmFsdWUuDQoNCldvanRlaw0K
