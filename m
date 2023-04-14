Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD72F6E19C7
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 03:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjDNBgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 21:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDNBgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 21:36:45 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC626CA;
        Thu, 13 Apr 2023 18:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681436204; x=1712972204;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dx3QdiKQbHHs2a0a5adZFNyZh+8yQYrvuOb5yyVYsJc=;
  b=duAZk81sI3/HxGBENWI75KvGXytr17bBoQ0C8QX2h3wenRuRg2qAU/h8
   XWP2LeSmNFMUutigKyGFFXCnZx9OHypiMUuaPP83aYUGuY4fRE6yJHSIk
   iGoS944N2DY4kHgIShAtd0VO3tECbeWA4AqL+C9Na50Na2gfUP0RAvDbH
   wtC/c0A3DVErAT9n9fulxFP7/iE6965rsrQccYQSBgZHu/48zq8ASfNTp
   kNpqhr3MKp/SjtdnVTeYQi8t4J6fka5o6KL9RkcGywRgd8uTxRA2IJFRd
   hxCc+It+VCUtkOP+3ItGL3uyjsRmriQCVZ627VTqcQPp1VJpXfjRjAmIt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="430647496"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="430647496"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 18:36:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="801005540"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="801005540"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 13 Apr 2023 18:36:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 18:36:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 18:36:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 18:36:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXgVccS+Z1QHlGm6b6TvKLEvieIGTqgp+o8pWSLTNczcmD6BnN/YvWJRcVRgVgtfyohECJ7CHDNHGHpUk/JSRtjvOk5H6RDqf2At6mBumtBvz7VrbR5RBAOcioWBAz+im+MFB4jFjZaxu08S604rKg6z+0p3IQPKPNdknG+mVuQMLUraJiKYbdnpWbnGoS6yCSnqP73212H09RTT1khRir6BWiNRbMxVM7KxT9do61xCwro13dsYloWUx6mwyXsiXHiU6w9e5J0jNoG4xZemtZdhF6csu5G0qCdpZDwujYw6EVvvJLhu6EXZCSoKVXyNXmAOYBRwKX8TRMb8ttFfBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dx3QdiKQbHHs2a0a5adZFNyZh+8yQYrvuOb5yyVYsJc=;
 b=lchqXEgLdQ2qte6dZ8bjRMozYKyT2A0Rtp8BkwARpo2/SEZUPEtZPWaQvNmwjc2Ewu6JOJC0G7U8ugKUr+k7YYeQRl8czyL7+JeP3t715Ff9K45aqvJX8KkOciQubsRmEHo4Rraxrzrgw7MKNAJ+fIDHy2GFYfidAPICTBFvf8s9F14NI6fMwnnJ03d8jTOzI/btWyorU6bjRirEtUgssyzjpKFBW9yXOCnxXNe35jm5IZCG80I7ifEUfBFniBIPXfjFAinxTX6Cbf8Pvlk6YDg6MQm4m0zc/KNJrzGZKZzUJFHhDlSJLFYWNwXRtjy46tqC0unbawc3kKGk+pdqtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 01:36:13 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Fri, 14 Apr 2023
 01:36:13 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Stanislav Fomichev <sdf@google.com>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net 1/1] igc: read before write to SRRCTL register
Thread-Topic: [PATCH net 1/1] igc: read before write to SRRCTL register
Thread-Index: AQHZbhp1VdIm3fVCg0ugMsk8Zltg9K8pmaEAgABsWtA=
Date:   Fri, 14 Apr 2023 01:36:13 +0000
Message-ID: <PH0PR11MB5830F8D2E4D5E3955F18AEB4D8999@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230413151222.1864307-1-yoong.siang.song@intel.com>
 <e7d81a89-da60-1da6-7966-7739ad545834@redhat.com>
In-Reply-To: <e7d81a89-da60-1da6-7966-7739ad545834@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|PH0PR11MB4790:EE_
x-ms-office365-filtering-correlation-id: 569d2458-cb7f-4fbe-84e4-08db3c88a222
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L9A3jK5quD+k0YeIUPwJjvKkMEwmmfPIRQx76RJJVKuFAA+rN0e4SirHW3ee+YHYeqCZeZo5osjL0cF+2hDcYtqTy+HvE0BtBIxEJlNRdGEx0ekA8aGPuvlUHw55q8CeizfIbH2j0KCUZBD0R67jHDl3pdLEea9ww1J5SktBw1Ty4GNySq78MDWeXsUKJ0PGFXzWmPUQvexPy3S4o58XzxbE6WWBOZG6qhIXIZmYq2pWJ0AOGjx2yvVe7Q0wDVH6TFoaIt8maEtKvT7yVWbrjuyVoiM9tioAPgqFh8Q0ZXOYLyirg0mBUdrZJLY6sudUBiBloTaQvC23p9zh4hgjcnDL3kgJtMkonpNIy7TZFkK6hsPP1/jzzaMoat3a+yw/JMHuOhDYkyByA6e2yZFRS0AlfWub4iaimX5Ohwj+MZ3J34TirXgc+VtWR5Q7jFHSvZALnJJKyezG+YDSAz5QmeeVtXgWY4F/9LDbFoA77H+zpRtazz3W2yOGJj0xagio/IW4hhBjvW1Ab0p7uQzC+WA5awXji9/Eg6THyp+RwcSaKyUHeqXEQCg3oKpJ7anRNIDAFIp7gqwBDuM7esamMcL0ZCZPZRpLi3Pmfgupgvtef6u9zopr4Q1EegQptSSVtAUkjOEx/BKfhvOlF+OmXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199021)(38070700005)(55236004)(9686003)(26005)(186003)(6506007)(53546011)(54906003)(33656002)(478600001)(55016003)(110136005)(122000001)(921005)(2906002)(7416002)(8676002)(8936002)(41300700001)(5660300002)(52536014)(38100700002)(316002)(4326008)(66946007)(66556008)(76116006)(66476007)(64756008)(66446008)(82960400001)(86362001)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVpNTk1LajdBWHRBU0pvVDNrQ3MyYm5WeU1JeDNFWjg0M2JqeFNlajkrWXFM?=
 =?utf-8?B?QzVEZ1hYL1ZJR1YxR3FObWdsMFFHYzZVdnhDcG9mS0tUTW5zL2I3WGJrdUZ0?=
 =?utf-8?B?Rnk0WHMrRkFBSXFSdHJ6Tjd0b0xvekRXVTk5SE5BbjMzQk1aY3M1WmM0Qm80?=
 =?utf-8?B?SWN1ZlI2MkxPMFZZWDBnZmkySTVDTnR2RlkrK2w1Mm1rZWxkRkJ4QWJBTklT?=
 =?utf-8?B?RFdQMCt3YStPenRRZzhlcnY5MC9ucXpEMExMK1NLRzVoMmV2SHJPbnlMbkVM?=
 =?utf-8?B?bkJnTG1iTlA1MGJjcU1QcUJhOFVkZWhLYXlDRE9idDlsMDFLckw4YStFVnk5?=
 =?utf-8?B?emVnRVp6SzlUbzU1RERRUDEvcUc5eUovSHZaN1hqTGZGblhSWWpFM0lMZ1Vq?=
 =?utf-8?B?ZXpVaER6UGlzc3BPYzlXMmJqd2krc0VuNjV3RHRJRnFVYkNKWm9uWE5sOFpZ?=
 =?utf-8?B?U0dOR1d4UXFOOEVhdFZJc2RiTGtHMnkwTXBSRTZtc1p2WGt3WmlJelczaVFn?=
 =?utf-8?B?cjBlNWVSTXUxVFREdE9uWis3dW12RUVhcUNFTDlkbkw2aytaY2VxQmxMaGNa?=
 =?utf-8?B?d3hlWk5NM3hVZGRodWl6VjJWMldTZEx3ZXNBQUFBcXBUZVJiaFRkY0JmZkwz?=
 =?utf-8?B?amtLdlltMk5CSEhsZk0xWHE4M0FNc1hvSDAzVm95VDRDRW8xZWtyWEVrSEdN?=
 =?utf-8?B?WDdKSnR2ZW5nSEFvajRIYUgzajlZSkRwbzY5OU91dWhFQkJxanNxb3pScEVh?=
 =?utf-8?B?N3dhQ0M1VllGQzJmYnl0cE02N01GSmZUYkJ5MlRNWm5lZWR1anVXd0h6VGxH?=
 =?utf-8?B?RTFDYmhHNHNVRVpJbzZ4K0hFWlZpdmFzVjRDNFF0WFJ2eVN0U3d1VkpSVzJ5?=
 =?utf-8?B?aFprcDQ2YnJ2M3RpUlVlYUhmTVJnUUJsT2p6UlFFTkVrYjB3MWt5NzdYRU9Z?=
 =?utf-8?B?VFVlZXJVb3BRY2xjNVVCOGZ0d1hvZmM1dWh3M2NtcngyWnRXZjk0QkZ1amhs?=
 =?utf-8?B?YWVQRkcxZTUxZnBhK2RiVGR5aW45MTFwR1h4SDhMLytTcjNhUU9KcVZQL2Mx?=
 =?utf-8?B?R0czaktDVHNmYXBpcFg1Vi9XQk9qV1Jtejk2djBPWGlhSENKd3BHOU13aXRW?=
 =?utf-8?B?SHRXMzY3UlhiSktyS0IveVp0R2EwTVBLbWV3ODVHblNiY3IydU5mVjZieFB3?=
 =?utf-8?B?VnY3ZzFQRjExU2FlZ3Vvc3Njc3BuMExaMlhJMlZ2dFZnZFhrMS95aTlraG5w?=
 =?utf-8?B?TjU0cEc4MC9GMXEvNmd2Q0lKMi9HWkYvdU41aFNSRVIvd1V3Vi9rOXIwU1Yx?=
 =?utf-8?B?eSsyTkcwbDNseHI5alZPSGRQZGM2d2J3eHdSOEtJMXlST3E4Umlpd3ZBT2g0?=
 =?utf-8?B?VlIyZGdsNGcyeVpzamZ5VE1oWFpDcHFQT0xUdkVVekU3WURUZWs2cG94c3JW?=
 =?utf-8?B?VnNjWkhFeUsvdnNraW5zTWllZm5UNkZaakZaTUkrM2FEVy9Zek5WTTZ1eWly?=
 =?utf-8?B?QjI2SlloK3p4eENVRGZMa2xzMnhDdnRpaW9MdE54RVZWWCtoNjlYeTk3V1BF?=
 =?utf-8?B?R3B2eG9kL1h6RFAxSFNZeG5reHVCK0o5TFpFNExuMFJKRitydnh1VFFtanhQ?=
 =?utf-8?B?RDBMTVhSOWpSN1hrcEwrbnVIbWlTWk1xcmVRRG1jU1JLR2Yxd3J3SXVab1BW?=
 =?utf-8?B?N2Q2NHpISzZPQzk0V2ZhSjg5SENTUVdCdWhpbmhWMkk4Nmo1di9IRXB4RW9t?=
 =?utf-8?B?cWZ1VWhFKzJrd2gvSEZOQUlhaGUwOWdoZGg4a1Izcm8rZ1FoZGV6N09jOE5T?=
 =?utf-8?B?bmFSMUFIbzZGcUF2Y1pDaTVUWjl2bllQQTQvSWIyK3o4UUpnOW1YN0cvQ3hD?=
 =?utf-8?B?cmRldWR5ZnlMOWdrd0FPZlY5U01rSUd3azZjMmorS3BiSnFRRVB3T0RSS2s4?=
 =?utf-8?B?Rmt5TmNHN2FjZFVacm91dmRTa2VUVXBUOVlIMFhJV0w3V0JuYmtjVjhleENF?=
 =?utf-8?B?RVJlY3cyc0hiRjhDRHNSSEJjd3IwRlVxRE0wTWlYN2Q2VUlWNGROclU5MllL?=
 =?utf-8?B?UGZqcTh2c2hVMEY2U29lSTVZT3p1UWN3b2tMcTkvKyszMWRTU2hqWTVUL2Ev?=
 =?utf-8?Q?SH4zStOb+PC5L7Ac8QiZJxmeE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569d2458-cb7f-4fbe-84e4-08db3c88a222
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 01:36:13.6369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AEBoCxX395irE1P0qZuBHupzzp5FIe8w0dUr0DSMmIPgsPOH5J9QzDKZCYhE2zl9vDOfSYS1iea6IjZ7BjUUCzO2hy4mvCudJ7hcgZ+DVzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpZGF5LCBBcHJpbCAxNCwgMjAyMyAzOjA2IEFNICwgSmVzcGVyIERhbmdhYXJkIEJyb3Vl
ciA8amJyb3VlckByZWRoYXQuY29tPiB3cm90ZToNCj5PbiAxMy8wNC8yMDIzIDE3LjEyLCBTb25n
IFlvb25nIFNpYW5nIHdyb3RlOg0KPj4gaWdjX2NvbmZpZ3VyZV9yeF9yaW5nKCkgZnVuY3Rpb24g
d2lsbCBiZSBjYWxsZWQgYXMgcGFydCBvZiBYRFAgcHJvZ3JhbQ0KPj4gc2V0dXAuIElmIFJ4IGhh
cmR3YXJlIHRpbWVzdGFtcCBpcyBlbmFibGVkIHByaW8gdG8gWERQIHByb2dyYW0gc2V0dXAsDQo+
PiB0aGlzIHRpbWVzdGFtcCBlbmFibGVtZW50IHdpbGwgYmUgb3ZlcndyaXR0ZW4gd2hlbiBidWZm
ZXIgc2l6ZSBpcw0KPj4gd3JpdHRlbiBpbnRvIFNSUkNUTCByZWdpc3Rlci4NCj4+DQo+PiBUaHVz
LCB0aGlzIGNvbW1pdCByZWFkIHRoZSByZWdpc3RlciB2YWx1ZSBiZWZvcmUgd3JpdGUgdG8gU1JS
Q1RMDQo+PiByZWdpc3Rlci4gVGhpcyBjb21taXQgaXMgdGVzdGVkIGJ5IHVzaW5nIHhkcF9od19t
ZXRhZGF0YSBicGYgc2VsZnRlc3QNCj4+IHRvb2wuIFRoZSB0b29sIGVuYWJsZXMgUnggaGFyZHdh
cmUgdGltZXN0YW1wIGFuZCB0aGVuIGF0dGFjaCBYRFANCj4+IHByb2dyYW0gdG8gaWdjIGRyaXZl
ci4gSXQgd2lsbCBkaXNwbGF5IGhhcmR3YXJlIHRpbWVzdGFtcCBvZiBVRFANCj4+IHBhY2tldCB3
aXRoIHBvcnQgbnVtYmVyIDkwOTIuIEJlbG93IGFyZSBkZXRhaWwgb2YgdGVzdCBzdGVwcyBhbmQg
cmVzdWx0cy4NCj5bLi4uXQ0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2lnYy9pZ2NfYmFzZS5oDQo+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9p
Z2NfYmFzZS5oDQo+PiBpbmRleCA3YTk5MmJlZmNhMjQuLmI5NTAwN2Q1MWQxMyAxMDA2NDQNCj4+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfYmFzZS5oDQo+PiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX2Jhc2UuaA0KPj4gQEAgLTg3LDgg
Kzg3LDExIEBAIHVuaW9uIGlnY19hZHZfcnhfZGVzYyB7DQo+PiAgICNkZWZpbmUgSUdDX1JYRENU
TF9TV0ZMVVNICQkweDA0MDAwMDAwIC8qIFJlY2VpdmUgU29mdHdhcmUgRmx1c2ggKi8NCj4+DQo+
PiAgIC8qIFNSUkNUTCBiaXQgZGVmaW5pdGlvbnMgKi8NCj4+IC0jZGVmaW5lIElHQ19TUlJDVExf
QlNJWkVQS1RfU0hJRlQJCTEwIC8qIFNoaWZ0IF9yaWdodF8gKi8NCj4+IC0jZGVmaW5lIElHQ19T
UlJDVExfQlNJWkVIRFJTSVpFX1NISUZUCQkyICAvKiBTaGlmdCBfbGVmdF8gKi8NCj4+ICsjZGVm
aW5lIElHQ19TUlJDVExfQlNJWkVQS1RfTUFTSwlHRU5NQVNLKDYsIDApDQo+PiArI2RlZmluZSBJ
R0NfU1JSQ1RMX0JTSVpFUEtUX1NISUZUCTEwIC8qIFNoaWZ0IF9yaWdodF8gKi8NCj4+ICsjZGVm
aW5lIElHQ19TUlJDVExfQlNJWkVIRFJTSVpFX01BU0sJR0VOTUFTSygxMywgOCkNCj4+ICsjZGVm
aW5lIElHQ19TUlJDVExfQlNJWkVIRFJTSVpFX1NISUZUCTIgIC8qIFNoaWZ0IF9sZWZ0XyAqLw0K
Pj4gKyNkZWZpbmUgSUdDX1NSUkNUTF9ERVNDVFlQRV9NQVNLCUdFTk1BU0soMjcsIDI1KQ0KPj4g
ICAjZGVmaW5lIElHQ19TUlJDVExfREVTQ1RZUEVfQURWX09ORUJVRgkweDAyMDAwMDAwDQo+Pg0K
Pj4gICAjZW5kaWYgLyogX0lHQ19CQVNFX0ggKi8NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4uYw0KPj4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pZ2MvaWdjX21haW4uYw0KPj4gaW5kZXggMjVmYzZjNjUyMDliLi5kZTdiMjFjMmNj
ZDYgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21h
aW4uYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19tYWluLmMN
Cj4+IEBAIC02NDEsNyArNjQxLDEwIEBAIHN0YXRpYyB2b2lkIGlnY19jb25maWd1cmVfcnhfcmlu
ZyhzdHJ1Y3QgaWdjX2FkYXB0ZXIgKmFkYXB0ZXIsDQo+PiAgIAllbHNlDQo+PiAgIAkJYnVmX3Np
emUgPSBJR0NfUlhCVUZGRVJfMjA0ODsNCj4+DQo+PiAtCXNycmN0bCA9IElHQ19SWF9IRFJfTEVO
IDw8IElHQ19TUlJDVExfQlNJWkVIRFJTSVpFX1NISUZUOw0KPj4gKwlzcnJjdGwgPSByZDMyKElH
Q19TUlJDVEwocmVnX2lkeCkpOw0KPj4gKwlzcnJjdGwgJj0gfihJR0NfU1JSQ1RMX0JTSVpFUEtU
X01BU0sgfCBJR0NfU1JSQ1RMX0JTSVpFSERSU0laRV9NQVNLIHwNCj4+ICsJCSAgSUdDX1NSUkNU
TF9ERVNDVFlQRV9NQVNLKTsNCj4gICAgICAgICAgICAgICAgICAgXl4NCj5QbGVhc2UgZml4IGlu
ZGVudGlvbiwgbW92aW5nIElHQ19TUlJDVExfREVTQ1RZUEVfTUFTSyBzdWNoIHRoYXQgaXQgYWxp
Z25zDQo+d2l0aCBJR0NfU1JSQ1RMX0JTSVpFUEtUX01BU0suICBUaGlzIG1ha2UgaXMgZWFzaWVy
IGZvciB0aGUgZXllIHRvIHNwb3QgdGhhdCBpdA0KPmlzIHBhcnQgb2YgdGhlIG5lZ2F0aW9uICh+
KS4NClN1cmUuIFRoYW5rcyBmb3IgeW91ciBjb21tZW50LiBJIHdpbGwgZml4IGl0IGluIHYyLg0K
DQo+DQo+PiArCXNycmN0bCB8PSBJR0NfUlhfSERSX0xFTiA8PCBJR0NfU1JSQ1RMX0JTSVpFSERS
U0laRV9TSElGVDsNCj4+ICAgCXNycmN0bCB8PSBidWZfc2l6ZSA+PiBJR0NfU1JSQ1RMX0JTSVpF
UEtUX1NISUZUOw0KPj4gICAJc3JyY3RsIHw9IElHQ19TUlJDVExfREVTQ1RZUEVfQURWX09ORUJV
RjsNCj4+DQoNCg==
