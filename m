Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937266D5A21
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjDDH7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbjDDH7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:59:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC79C1984
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 00:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680595186; x=1712131186;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gYWRypW0QPcc26u1bj47YiR+IXq0Zcqul5Y2039GRoc=;
  b=J6DHPY3RA2ZkwjNtsOLhp/UuyHWfp4XToKG8kpAU/1rXaejyRz7r4gTu
   YX77DDOfV19me3zyIEhU/ifYCWbOHvEoRw8cE0q3bUraqfFMcf79pUy+3
   6ezF0NaKwbpg5vkv094+B/b5wpd6wFswLYqQk2qNOAgLavNb3s8GXhloc
   UmB5OQUXj1mkKiPzl6ZZUHQf6CAEbx7cJ9ivefr4yPkTtafFM8rjNDwx4
   ACF1UYwLckI/VIQyvphkdd5dgI74zMxxs3FPhUiZXtSFQi6IyPGr1OiXO
   H4GHNpJZZfD9SNszDzReeD6tQWPbZhpJjUZwYLPng5Pa8FrPnxIhI2mbR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="343819630"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="343819630"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 00:59:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="718844456"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="718844456"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 04 Apr 2023 00:59:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 00:59:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 00:59:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 00:59:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 00:59:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnJPMK8WmD2DNb55o0QJxkNJGjIZLctCeNs+dsM5SbfPcvLr0QGlhnuhTfKm/RCojLduMBDaLEUDyZTcWsx+yUUNSMk6iASuyuPf003L10bzhe6Sy/Oq2R/jdUFnZYDDF/XM+DOXoMzvG/rPEt1xMbAT7zFcBHKYSmpxYILTAoQgVxwVr5HfYVeFKwM1DJzLzVIodAwYcCbKi0nS+BJz+b8Xf8l8jL9c2Wnc6xvpMKBUnQCgi3D9g2jTiC5gRpE1q3LMGs/bwthZ4WMTS1eAu3i/eiSYr04RnB4GoUZ+zzgX1hLL74SB1vsQqPdL6qitDA8xTwAhWvJgn4BqDwDw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gYWRypW0QPcc26u1bj47YiR+IXq0Zcqul5Y2039GRoc=;
 b=byz1vdxRcOpQkXQoeI07BUBwo2knQKDJzxK1yRAIYvGtqZ98yfzuUSDoxEX6lZbfuNymgy4wPkwOlhSAA6Ht9kYNf2yBFxNZvenKSlbtOckrVxrdtfetRsb9LFE8havwZXhbEgoxi2oISod5uPMug9Px1sZPI3YHwc7nOoV5RskFtZNCxi6V/RWEv//VseX4+r90bEFDX+4oBFFqX5e/MarfSHiSunABaox9bii+PJLMV57XrAfeZTBxL4R+Akz9XSK/Mv7R5qthFDMyT9kCX6rNidh7CZZON0d9bmZ4HEqzrEQspVagBDtEaCDN6blcLRqC9+NlHpC7QVmK4JfhdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5733.namprd11.prod.outlook.com (2603:10b6:8:30::14) by
 SA2PR11MB4938.namprd11.prod.outlook.com (2603:10b6:806:fb::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.35; Tue, 4 Apr 2023 07:59:40 +0000
Received: from DM8PR11MB5733.namprd11.prod.outlook.com
 ([fe80::9762:6efd:5a7a:8c46]) by DM8PR11MB5733.namprd11.prod.outlook.com
 ([fe80::9762:6efd:5a7a:8c46%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 07:59:40 +0000
From:   "Orr, Michael" <michael.orr@intel.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        "willemb@google.com" <willemb@google.com>,
        "decot@google.com" <decot@google.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Brady, Alan" <alan.brady@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 01/15] virtchnl: add virtchnl
 version 2 ops
Thread-Topic: [Intel-wired-lan] [PATCH net-next 01/15] virtchnl: add virtchnl
 version 2 ops
Thread-Index: AQHZZngL/cO6AhH/5UGNZ/kw1BXIn68aKCqAgAAJaICAAJhPbA==
Date:   Tue, 4 Apr 2023 07:59:40 +0000
Message-ID: <9ADED21A-AF91-4B3A-82F3-FB257EC2B3CA@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-2-pavan.kumar.linga@intel.com>
 <49947b6b-a59d-1db1-f405-0ab4e6e3356e@amd.com>
 <20230403152053.53253d7e@kernel.org>
 <eb945338-915a-64cd-52c5-3d818ba45667@amd.com>
In-Reply-To: <eb945338-915a-64cd-52c5-3d818ba45667@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5733:EE_|SA2PR11MB4938:EE_
x-ms-office365-filtering-correlation-id: 77fc3e5c-2090-485e-1206-08db34e28b28
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YaGw1UHDKn+G/76lJ6Zo0tCCki3CJb3HUrkZTjC5eWzrsJoUXSPNFOwiJdxA9PdTAsqmqkqMn1qI7Hd6ZZeYgq8PCeWxJe2Hz2cgiiggx1WT3FeWoAUUdAnn4D3XTorVDU5DdJQTh5qZnGWfQk6yNP4P97n6aE+sjk6ZbriLUdqoueSOFwFWwvvk+KYuQpVQ2YWjwsBP/3jMmOwZE4ptSb+0RY9lxnD63YJijgWtRZSXQtQMT2VAG0saj3c0ycuqX0PW4GhHRNOJF2AnzBeO7j5GlxWrcaKW1DBm9rJYZEbs3uu0eBs+Fk2v2eJfV3ceWQJHdVF1Jq6h7byVesQNfMkOIQoLrWt6304VzBK0c4hFWikc2GUyAOjPi2oFaCl6kJYaoMV8vd0egJXn5JGmizPocolO1RbS9YvnknYKiHLAAb/1MgdoW2+Jm9e+jiFe7YR6a/RfTKoLkbg+2yoMl+m+FUf+FwpkjvfMToGwGE1WTf63gM9FhLIE6u705jm4mknq+Cz5MCWsFJzkgvIvbXj7ksNqRVGyA2RDU1kgdkzecMqTyoSRjIWJ37dN/U7kDCdgsP2ydTbdPSWV3WGcYX8Ca4huQCrZqDUoLrac46GdwHjW+D+dOMLV1U7xGkL4T7Xw4fk1kE79whJP12VWRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(107886003)(2616005)(83380400001)(186003)(26005)(53546011)(6506007)(6512007)(86362001)(91956017)(66476007)(4326008)(66556008)(76116006)(8676002)(66946007)(64756008)(66446008)(6916009)(38100700002)(2906002)(82960400001)(38070700005)(122000001)(41300700001)(478600001)(316002)(54906003)(40140700001)(33656002)(71200400001)(5660300002)(36756003)(8936002)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjExeDJtNXI3U3F2bFdDME9IbzRKckNSMnZ4SWdOTzZVdDZrV3pHdU9zNVFz?=
 =?utf-8?B?ZXJHenFnZTNtSTZKcjBDVE5pYTBRSjc5cDl3SSt3aVcweFArU3hRRjVMeTlW?=
 =?utf-8?B?M0hnSnZ5dnhRL3l1S0xPRS9FMUJLVFk4and4TmVjNWJrME11L1Zpc0xUdUc4?=
 =?utf-8?B?M0xzSzZzbUVweUw2YlpCYUhPWHVJVTNEQXB6dllaUHVVQ2NDekZNMzhOcFZL?=
 =?utf-8?B?dlNKTzRvRjNmNEhIR21ESVFlRVZwcnB5VncvVEUwYjhxVUJJT1NqZ21qMDU3?=
 =?utf-8?B?QnRpeCtKQWYxWWh5WU45SDVJWVZhZ3YyRm5XN0NoSjJjaDlUQ1FRWnpnNnJY?=
 =?utf-8?B?NDZYZ3dUSXlMS1hPSXdzYllPbytmZC9QU0FSOW9OcnN6dVdIRU1VRmtYMHVH?=
 =?utf-8?B?cHkxYnNxQWVubUhSU0JwNCt5YUQ2enZIZWZWVFU2bm9FS2pLTnU5NHdTUWhL?=
 =?utf-8?B?S3d5SnIwak5QQ2Y3VUlwWDA1MlYrbEFoU2pWUURvSUwzY3g5RVpMSWQvQUo2?=
 =?utf-8?B?Y0RnZXZ4MHVDOTlrb0JJQm0rRHByQzNGZGpxb3ZIWkdvcEpvT1A3djRFK1lx?=
 =?utf-8?B?ZHUrVDhhL3J4VE1zbHVNcE93VDlwSEhLbFlycFAreDlTNmdxK3VpbWNqTGFM?=
 =?utf-8?B?L2JPYk5IZ3NDSk1iK2E1a0phNTUvSVpLMVd4VDV1VDcrTXF0TG40dzdiWlBa?=
 =?utf-8?B?R1NBT1JLL0J2T3pPSUxBU3pxRGZQZXpGWlFTeFMzMEM3V1U0RkpJbXFocHJ0?=
 =?utf-8?B?SzJlQ1NjVTY0aUxlWTFIcXVvVk1ialVBN0ZjMkVUd2JPV3lSSk5wa1g2ZGxu?=
 =?utf-8?B?ZW5ySDVWT1I0dURHa3dSSTBMcHlzc0ZMNjhpOGhDd3BqWHRFaWMxbzVicDZW?=
 =?utf-8?B?dFJwTlY3cXQvMFo0YnpOY1lMbFBCbmhWcXdkRDFscTNRekttSExTVmZvclJs?=
 =?utf-8?B?U1U4VmYzWGFyVnAxY0poWGhpNmRzT3dkRlplS2Vwb3pka2dqNi9iaGZ2aVRm?=
 =?utf-8?B?NTdqMDMxV3RhdlVxMVlzUWFZbmlDdzhlTTZUSUN5WkNCaHhLczJQT09BVCtj?=
 =?utf-8?B?cStTVjEvcWRIWXB1QVhVY0QxekVWUm5PWDlZNnVIREpVZDdBYmZuT01rb0Yv?=
 =?utf-8?B?aGRVRmh5S3NDdG0vZURmKzNBNEtLVWk5WW9HRE5MZEV6dTc4L0ZmRFVleXBm?=
 =?utf-8?B?OFBCVzd1Qko3YzNxS2lmUVNQMXhrYU4rYjg2WWsyWGhLM3ZvWjRuQ2VUa0Za?=
 =?utf-8?B?TkFTdmtpNzBHd0JxQ29uMUhVYUU1dkRXaktaTVUreTNqd0hBQk1CbHFweDVG?=
 =?utf-8?B?YjM1ZFJpSTNrME5hTHl6akxhcDJSUkdZbUJvSjRsVGpRWDFpVU1FYjBhbm9O?=
 =?utf-8?B?YWNLT0ZIMmpPUU0xVUJQbEprTzU3Q3lzWGR0L0J4bkQvQVBpTFBEelBVeTFM?=
 =?utf-8?B?ZVJVbC9ZdSsySG00VVh6RWo2SU9jOEgveVhmeFE2cEJ4eTJxSTNJU3pqREFL?=
 =?utf-8?B?RTZ3QmxieFRwRDNqd2VTTHJvcW1wSTdZSWVGZ1UxczByZUVTbmJmNVhEUnYw?=
 =?utf-8?B?QUdSeEQ4WVN5dHp2K2RqZ2xEdGdtbnFFOEdNbFNlZXlzNm5iRHVTWGJ1Mi9m?=
 =?utf-8?B?d3o4RThIYUJoMnhUazFDQ21jNFNnN2xtQVNtNVo0Rm9qRDRtZk50eHBaaWtw?=
 =?utf-8?B?WjJGaFRHajhLYjZUcVNVODdTUjZkZkFqeEtNWTh1TlhpMExNdEFwZFhmWjlO?=
 =?utf-8?B?REJtdHQ0aEtTbVpiWkJKcTZSMGZGWndBeFNZcHZDaUpBRlZwRFBudnU0MFRU?=
 =?utf-8?B?RW1HNTBFV2JUa2dHZDlXSzB5REFXTHpvNksybml6ZjBIQnkrYllKcVo4YzdY?=
 =?utf-8?B?czQvS2tETkJNYURKNkRHY3VFeUFtS2wydktYNm5MZkl1OVIrZmlGZFR0bFdK?=
 =?utf-8?B?clM5R0FQMUlmZlJGWEIrSUNUYnJBWnJsYUd3YW5GSnQ2NU5OVjVoR0lkMlpv?=
 =?utf-8?B?dUZWR3hRY2RTYm1jMW1Xd04xT2RSdzJFcm4zaVQwR1Y5QWg3S3JiZTFSQklh?=
 =?utf-8?B?ZHBpSThvVmZ4T1c4M3ZYOWpTWTYrUVZ2QWM1ajNRbTZqTy9mallDWTRQNity?=
 =?utf-8?Q?zGs7Ox856W0IrlS1RyAjiRdzV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77fc3e5c-2090-485e-1206-08db34e28b28
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 07:59:40.4546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ROKjfhYK1l6Ltjn90/I6zEJAErN9+LLLgy7rMdCU47s3OSN38jqaNoR9m7pr4IKTc4ZBPojbr/iy0VFT0XnsPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4938
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyB2ZXJzaW9uIGlzIG5vdCB5ZXQgdGhlIHN0YW5kYXJkIElEUEYgdmVyc2lvbi4gSXQgaXMg
dGhlIGN1cnJlbnQgSW50ZWwgZHJpdmVyLg0KVGhlIG1lbnRpb25zIG9mIOKAnHN0YW5kYXJk4oCd
IGFuZCBPQVNJUyBaYXJldHNreSBiZWNhdXNlIHRoaXMgdmVyc2lvbiBpcyB0aGUgDQpCYXNpcyBm
cm9tIHdoaWNoIGEgc3RhbmRhcmQgZHJpdmVyIFdJTEwgYmUgZGV2ZWxvcGVkIGF0IE9BU0lTLCB3
aGljaCBpcyByZWxldmFudCBpbmZvIHRvIGtub3cuIA0KDQotLQ0KTWljaGFlbCBPcnIuICAgICAg
ICAgICAgQ2VsbDogKzEoNDA4KTYzNi0zNzQ0DQpOb3RlOiBEeXNsZXhpYyBoZXJlLiBFdmVuIG9u
IHNwZWxsZXItZXF1aXBwZWQgaVBhZCwgdHlwb3MgUHJvYmFibGUuIA0KDQo+IE9uIEFwciA0LCAy
MDIzLCBhdCAwMTo1NSwgU2hhbm5vbiBOZWxzb24gPHNoYW5ub24ubmVsc29uQGFtZC5jb20+IHdy
b3RlOg0KPiANCj4g77u/T24gNC8zLzIzIDM6MjAgUE0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0K
Pj4gT24gTW9uLCAzIEFwciAyMDIzIDE1OjAxOjU1IC0wNzAwIFNoYW5ub24gTmVsc29uIHdyb3Rl
Og0KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWRwZi92aXJ0
Y2hubDIuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lkcGYvdmlydGNobmwyLmgNCj4+
PiANCj4+PiBJZiB0aGlzIGlzIHRvIGJlIGEgc3RhbmRhcmRpemVkIGludGVyZmFjZSwgd2h5IGlz
IHRoaXMgaGVhZGVyIGJ1cmllZCBpbg0KPj4+IHRoZSBkcml2ZXIgc3BlY2lmaWMgZGlyZWN0b3J5
IGluc3RlYWQgb2Ygc29tZXRoaW5nIG1vcmUgYWNjZXNzaWJsZSBsaWtlDQo+Pj4gaW5jbHVkZS9s
aW51eC9pZHBmPw0KPj4gVGhlIG5vaXNlIGFib3V0IHRoaXMgZHJpdmVyIGJlaW5nICJhIHN0YW5k
YXJkIiBpcyBxdWl0ZSBjb25mdXNpbmcuDQo+PiBBcmUgeW91IGNvbnNpZGVyaW5nIGltcGxlbWVu
dGluZyBhbnkgb2YgaXQ/DQo+PiBJIGhhdmVuJ3QgaGVhcmQgb2YgYW55b25lIHdobyBpcyB5ZXQs
IHNvIEkgdGhvdWdodCBhbGwgdGhpcyB0YWxrIG9mDQo+PiBhIHN0YW5kYXJkIGlzIHByZXR0eSBl
bXB0eSBmcm9tIHRoZSB0ZWNobmljYWwgcGVyc3BlY3RpdmUgOigNCj4gDQo+IEp1c3QgdGhhdCB0
aGV5IHNlZW0gdG8gYmUgcHVzaGluZyBpdCB0byBiZWNvbWUgYSBzdGFuZGFyZCB0aHJvdWdoIE9B
U0lTLA0KPiBhcyB0aGV5IGluZmVyIGJ5IHBvaW50aW5nIHRvIHRoZWlyIE9BU0lTIGRvY3MgaW4g
dGhpcyBwYXRjaCwgYW5kIEkgd2FzIHVuZGVyIHRoZSAobWlzdGFrZW4/KSBpbXByZXNzaW9uIHRo
YXQgdGhpcyB3b3VsZCBiZSB0aGUgT25lIERyaXZlciBmb3IgYW55IGRldmljZSB0aGF0IGltcGxl
bWVudGVkIHRoZSBIVy9GVyBpbnRlcmZhY2UsIGtpbmRhIGxpa2UgdmlydGlvLiAgSWYgdGhhdCdz
IHRydWUsIHRoZW4gd2h5IHdvdWxkIHRoZSBkcml2ZXIgbGl2ZSB1bmRlciB0aGUgSW50ZWwgZGly
ZWN0b3J5Pw0KPiANCj4gc2xuDQo=
