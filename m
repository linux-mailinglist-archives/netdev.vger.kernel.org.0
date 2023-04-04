Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F216D6D0B
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbjDDTUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjDDTUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:20:02 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF3F3A92
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 12:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680635998; x=1712171998;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A1kw9S3k9SmOjD0k1pM4lyEmgqRw52jumZIgG9u6XxM=;
  b=Uuqo4x90CoMC7pmwe/uFMCClpZNze9D5b2cqJaNfd6MVvy/KGbEaYO7e
   d5L6AZp8fDx0egLkhg4sIsnRx8s0ego/MhqbyS5+Uj/eMl9s7Xr9QMlCR
   dFyFvFETWtqXBHzWUgWppQwgRbJC1hcW9bJ9HRK650Bs9Zs6uwmJQpOrr
   Zs6nTxx8k7TrPXiqzNHVoAESKDd0tqyLNQP+/Jxp5YcbAHtETQYxjWpQF
   b+uFM0jwcYrJQSDoKubG0WH1jbifz+UsLN2oy2h7q/8QsXajqy6/s+ApX
   6Jp35/ZxU+IgqssYg+dSTzQ1rEvc4DaIuMPkccX4OEgXv5+0emJHktq3Z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="339774193"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="339774193"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 12:19:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="810367143"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="810367143"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 04 Apr 2023 12:19:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 12:19:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 12:19:57 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 12:19:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DU/UqS/7DImmETlgw9Lq4WIR/xsn/va2HNQYGnc4i9t9coMtJ1sDHhodHfsPGlhwRSwfpImK+6wJ597u95EOqCikOGnJKcO+HNURjJxW8ve1lj29oh4PulCT1Qx37L6DMtmwqHV2M7eYW6Xp6uiQRABIiM7/q5LX9txjGXWq0j0tQm5cYhC1x/ygcPjt7ccQ+XygCvio3Y9JnHmqRHEWLoSXZxMdHoFYoQpERh23ULHkWl7gLINV3pcMHt2xpW9Hcgk0h7AMtoutGuHZZkUFumOhf84LpA78j60wO3y6aJ0cavbAbvd3hH8DjJMdHYYzgmL/JShYbZS6JsoKiLhMYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1kw9S3k9SmOjD0k1pM4lyEmgqRw52jumZIgG9u6XxM=;
 b=J3aLw2kf01rRFDgvqnhe1MNWWgSSAamla8CMrX5GGE+YAgNMv9F6+xosAE3XgB+yLSdTYxshP1KCewEf4F9OpBP+oNdpWr4HTPV1UoF2jD5VZc1lQrca8Trx/uT03E1sifpbe0COc/RXLYSor0+QtIuLhuB9zDIw35j/cl/97ye9eh86UZM4YxJ09D0ueNfua4eJAffRtXDpiwv93h7MAJqGHLE3sORIShHJDeiu2mhxrTB6EufHcBNIhztHkl5wH4Vrx0byWxEGYs+zK35/ndulpfYizPXcxusTAlvziM33Dgxl0gq+V16Te2Ka6BS6W6bXYb6B/Rq5lu3gB4kAZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5733.namprd11.prod.outlook.com (2603:10b6:8:30::14) by
 SA1PR11MB6567.namprd11.prod.outlook.com (2603:10b6:806:252::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.29; Tue, 4 Apr 2023 19:19:55 +0000
Received: from DM8PR11MB5733.namprd11.prod.outlook.com
 ([fe80::9762:6efd:5a7a:8c46]) by DM8PR11MB5733.namprd11.prod.outlook.com
 ([fe80::9762:6efd:5a7a:8c46%4]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 19:19:55 +0000
From:   "Orr, Michael" <michael.orr@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
        "willemb@google.com" <willemb@google.com>,
        "decot@google.com" <decot@google.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Singhai, Anjali" <anjali.singhai@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
Thread-Topic: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
Thread-Index: AQHZZnRpMmTDfYVLMkarLYZNQjDF9q8bW+eAgAAjCUA=
Date:   Tue, 4 Apr 2023 19:19:54 +0000
Message-ID: <DM8PR11MB5733892D5D21375332EC6855E9939@DM8PR11MB5733.namprd11.prod.outlook.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <ZCV6fZfuX5O8sRtA@nvidia.com> <20230330102505.6d3b88da@kernel.org>
 <ZCXVE9CuaMbY+Cdl@nvidia.com>
 <5d0439a6-8339-5bbd-c782-123a1aad71ed@intel.com>
 <ZCxTZQJ59boMFJNZ@nvidia.com>
In-Reply-To: <ZCxTZQJ59boMFJNZ@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5733:EE_|SA1PR11MB6567:EE_
x-ms-office365-filtering-correlation-id: 748cf4a7-f8b7-41ae-7528-08db3541926a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q6X5nSBMMbky155jrBNFCcgdROfbHL7nh+uEvnujx6dJMKnSGLDsBz3auH5l+4M4amvu5fZGZUKP+ZRqOoUmr5WbkLoLZQO2NvpdPVxvIt5vXcwBlq7GCxmwN9XI7bki6w+qgv4T4nLbURIAaV3ua7idB9Tq9dkPr7ZdKlOa8Lpt128Wi2JNN/kimqZUC4rhfSO+TqeQPjJ3DgTwd5ZOQxEa/bNBr4mW0br7KmZDV11iNQMKKDgD0XvU90XF1YTzl7BKCJtLZOIAk6qh9pIA7I9rT9EAn3pDRF0ecd2Z83aVc+9U3HB3JpuiAimelr97Xy/88ljm+nClJ+2WX7ueJLjrtyBqBGu/r1jWAccEu4ZB4SBsmDjFpCuVEOAPXe92y5eLiCrJziD0kyl36IUfvIVx6+lrVS0Y/Np/ziON0nFj/oggzJ7j1u2rl8S5GKNHc9M/gzByEvffvrujHMxi24r5oGvPgLYzo+zz+egKxHjRxNRF0Gtvv9/9B5vdF1KYUYttmyah2zveL3FbbzoY7HVXgdDYx9jiDLTHzWnE68k3GKnQ5+FznCWsiWFvoLeeSywlBq9uCGJ9uFtQW9cL7b0s63ELqOO27uG86rARka7G40EfLWrrhS99B29TQejg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199021)(186003)(71200400001)(7696005)(26005)(53546011)(6506007)(9686003)(107886003)(66476007)(316002)(6636002)(64756008)(66556008)(54906003)(66446008)(110136005)(66946007)(76116006)(41300700001)(4326008)(82960400001)(2906002)(8936002)(8676002)(122000001)(83380400001)(38100700002)(38070700005)(52536014)(5660300002)(86362001)(40140700001)(33656002)(478600001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG5XVFg0WlAvVWRCQ0FrblJSRTJXcFNWTEJHQTg3WGs1ditnYWpFaXJiL0hk?=
 =?utf-8?B?MkFJbVd6blQ4ckptS3JYcFhhTWFCUmcyOHYwM2xaSis3QVk4dUFDd0c5TDZK?=
 =?utf-8?B?UC83b3YwaU5xZURoMEtaY2ZnQ3prQy90UnZwbm0wRFRuRjB5UFplMjgwU0tx?=
 =?utf-8?B?VitnRHJ3TExlenZhdW5BZnNiUDM4bysxdWNVU29WWnNjdWszSTNXYUNqNWJU?=
 =?utf-8?B?T1BQdW8xalcrY2pSRzVjdiswQzJGVzRtY3czQ1dkOEJSalc4ZHR1bUU4K0ZZ?=
 =?utf-8?B?bktzcGx1K0JNVWxYV3g0SVBENk1ndkZRYmJnaXQ1TU5sVzBkZDBHOTB1TnhN?=
 =?utf-8?B?TDJqaWdwcCtjdU1mWnBuWjM2bFZOeEpSeE5sajFmN052bGlLdCtSUWRzMnho?=
 =?utf-8?B?eFd6RnpoSm90TGY3TWRTOU1yRWVNcWZ1YTEwRkpxYSt4cFFLdWw5dkpSZ3FL?=
 =?utf-8?B?RExXTzRsd0FaaGM2NDBPTjhmSUZhNXVCKzhpT2Q2MVlQbk9JWXlpZERGdzAx?=
 =?utf-8?B?Zm02amRncGRZNjNvbFFNQ0I4VmtCeldsVEt4akxjOUJPRFJsZExlNjB3dlVS?=
 =?utf-8?B?NGgxV2FIa3gyNGozbmhFclJvVFFLNGdvTGtrRzNmT1FtaDZUT1JMYWVBWjRl?=
 =?utf-8?B?amE1QWEvYVdjMkJWV1N4S3pYZUxkT0pmdE1SKzk4QjhuVytIbHhBb0l3RG1j?=
 =?utf-8?B?U2ZPNVZFQW5vTFhDMXFOK3hsRGlNOTZsYUFPeStrdGk1MFJuUklKUHBsSDdE?=
 =?utf-8?B?dEVGWlhhbGtWOFpZQTAzV011Vm1JdWpCZkowOWpPZEhvSjJlcWE3alJuZUR4?=
 =?utf-8?B?MnpzdkRLYjYwV2FqUWxmeWR3RWxQaU9oTzZlaldNN0NoUXl3bjBOSXZHUWdJ?=
 =?utf-8?B?VnkwclhoTUZqeVhMOXNLbzk4cTIwRGozaE8yTjlwa3Fxcmc2QjRYNk0vUzc2?=
 =?utf-8?B?ak1BdUcyWjFrdjBVby85VFFqRUw5aHc4TktmenhvRnZpQ0ZHMFYzSmxvYjZk?=
 =?utf-8?B?cWYzeHhvTmtOMzdISzVYWjhrcnIvbWtrU1FkSlRDOEI4TzdmQU42TlA2Yjdo?=
 =?utf-8?B?QlMrYnJvYUpQUitRdVgydnVSZUZ0MjVsUXZIOGg5UkM4Zjg3bHRCMGcybG93?=
 =?utf-8?B?dGJRY3lZYXlhNDRIWmR6MHVtZSs5V0hsVER4UThkSk9vb2s3SXVnU3pOZU5R?=
 =?utf-8?B?WnBTR1pVd3BCOS94U2hFUnVwUURNTHpoNnl2TkgycCtSUmZ0VVlocW8ydnFo?=
 =?utf-8?B?Tmg2eU5TcElTaGNzb1hwVVJkWFhOUjFsWGxRV0dRa1FrTTJIVjY1NUxsRVda?=
 =?utf-8?B?QVA0dzh4QmhqY2NKSFlZeWgrN05wa3EvMEMxNURrWGN4am5rb05KeXFqUE5I?=
 =?utf-8?B?cFVHR3BHZmlJSFpIQzd2NlhuWDdnYncvNlc3K0pHV0FTMlBGbGZQOFFjeHNV?=
 =?utf-8?B?UEc2UW01YmN1VElyKytwdUZyaDViaWZsUGtJV2FxdlpRUUs3RDludVVqcDJt?=
 =?utf-8?B?eldISTk5OUc5R21YeUtVY3J3VjIwV25QZW9hV1h4ZEJsYnYxTE4wM2xBa21D?=
 =?utf-8?B?RTlJa3phVFVvU0duSGtGQVNpQmVxZXVxRzZkZzIvSWdFRlZFOGVObGFSc1V2?=
 =?utf-8?B?MW5LVk1uUldpeUVaQkh1Syt2bGEzTkF6R0VZNXA4d0FqU2YvT0pROHJKVlZa?=
 =?utf-8?B?T05ySVpXY1I5ZUI3dnJ4Mm14UlZkdHpVSXBLQnR1S0lsY1JpVElIMko1WEtV?=
 =?utf-8?B?Wkt3ZjBOditMV05hOEV2SmRtZjNyMVFQRXh0anJKdXY4OFNUbk9iRDFxU0hw?=
 =?utf-8?B?dDhrMldwMW4yTzZVRGVGVDlGTnZRNlhtcFBDckwyY3U1ZzZwczU0YkN2T1g4?=
 =?utf-8?B?ZWoycFIzc0F4VlkxMGNZak5aL3F4WllUOXRvSHFSNzFSZEgxcTZadGJlQ0I3?=
 =?utf-8?B?eiszZS91U2E5dHl5dm1ZdlRBaDRlRFBwaWhKVzBJdzJWbEwrb2cwUTAwK3JJ?=
 =?utf-8?B?L2x0TnhHTTBUREZBZDJGaGJZdmJ6RUpEK3JMeGdQVERpek15bWxhdWwwbWNV?=
 =?utf-8?B?M3IwbzAzaERuNzVlT1ltbGEvd3JoTHVqVzAzSHJvRGxta1RnSmxHdVJZM2RR?=
 =?utf-8?Q?xtoXmqocTqs4Blk5X2AXPfUcs?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748cf4a7-f8b7-41ae-7528-08db3541926a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 19:19:54.8506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t57N4lh5GcTzm0JelpJmuz3nUUTm2ZJNu47D6i/l7dVpfxVvffFzA+SWA/cQnlsddnBbtAeSrlgJklIM9Z9o7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6567
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SmFzb24gLQ0KDQpUaGUgRHJpdmVyIGJlaW5nIHB1Ymxpc2hlZCBub3cgaXMgYW4gSW50ZWwgZHJp
dmVyLCB1bmRlciBJbnRlbCBkaXJlY3RvcnksIA0KYW5kIHVzaW5nIHRoZSBJbnRlbCBEZXZpY2Ug
SUQgLSBiZWNhdXNlIGl0IGlzIE5PVCB0aGUgSURQRiBzdGFuZGFyZC4gIEl0IGlzIGEgVmVuZG9y
IGRyaXZlci4gDQoNClRoZXJlZm9yZSBhbGwgdGhlIGRpc2N1c3Npb24gYWJvdXQgYW55IElQUiBw
b2xpY3kgYXBwbHlpbmcgdG8gdGhlIE9BU0lTIFRDIHdvcmsgDQppcyBzaW1wbHkgaXJyZWxldmFu
dCBoZXJlLiANCg0KVGhlIHJlYXNvbiBPQVNJUyBpcyByZWZlcmVuY2VkIGlzIHRoYXQgc2luY2Ug
dGhpcyBJbnRlbCBkcml2ZXIgaXMgdGhlIGJhc2lzL3N0YXJ0aW5nIHBvaW50IGZvciBhbiBFdmVu
dHVhbCBPQVNJUyBJRFBGIA0Kc3RhbmRhcmQsICBhbnlvbmUgd2hvIGhhcyBhbiBpbnRlcmVzdCBp
biBPQVNJUyBJRFBGIHdpbGwgaGF2ZSBhbiBpbnRlcmVzdCBpbiB0aGlzIGRyaXZlciBldmVuIElm
IHRoZXkgaGF2ZSBubyBpbnRlcmVzdCANCmluIEludGVsJ3MgUHJvZHVjdHMuIEkgKHdlKSBhc3N1
bWUgdGhhdCB0aGVyZSBhcmUgbWFueSBwZW9wbGUgaW4gdGhlIG1haWxpbmcgbGlzdCB3aG8gbWln
aHQgYmUgaW50ZXJlc3RlZCBpbiBhdCBsZWFzdCANCmtlZXBpbmcgdXAgd2l0aCBPQVNJUyBJRFBG
IFRDIHdvcmssIGhlbmNlIHRoZSBPQVNJUyByZWZlcmVuY2VzLiAgQW55b25lIHdobyBpcyBub3Qg
aW50ZXJlc3RlZCBpbiBPQVNJUyBJRFBGDQpjYW4gc2ltcGx5IGlnbm9yZSB0aGlzIHJlZmVyZW5j
aW5nLiANCg0KSWYgeW91IGhhdmUgYWRkaXRpb25hbCBxdWVzdGlvbnMsIHBsZWFzZSByZWFjaCBv
dXQgdG8gbWUgZGlyZWN0bHkgLSBJJ2xsIGdsYWRseSBkaXNjdXNzIGFueSBjb25jZXJucywgYnV0
IEkgdGhpbmsgDQpUaGlzIHNob3VsZCBoYXBwZW4gYXBhcnQgZnJvbSB0aGlzIGZvcnVtLiBNeSBj
b250YWN0IGlzIGJlbG93LiANCg0KUDJQIGFuc3dlcnMgYmVsb3cgDQoNCg0KLS0NCk1pY2hhZWwg
T3JyICBOQ05HIFN0cmF0ZWd5ICYgUm9hZG1hcCBPZmZpY2UgICAgV1cgQ2VsbDogICAgICg2Njkp
MjY1LTU5OTUNCk5vdGU6ICBEeXNsZXhpYyBAV29yay4gUGxlYXNlIGV4Y3VzZSBteSB0eXBvcy4g
ICAoUmVtZW1iZXIsIER5c2xleGljcyBhcmUgdGVvcGxlLCBwb28pDQoNCg0KDQotLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4g
DQpTZW50OiBUdWVzZGF5LCBBcHJpbCA0LCAyMDIzIDc6NDIgUE0NClRvOiBTYW11ZHJhbGEsIFNy
aWRoYXIgPHNyaWRoYXIuc2FtdWRyYWxhQGludGVsLmNvbT4NCkNjOiBKYWt1YiBLaWNpbnNraSA8
a3ViYUBrZXJuZWwub3JnPjsgTGluZ2EsIFBhdmFuIEt1bWFyIDxwYXZhbi5rdW1hci5saW5nYUBp
bnRlbC5jb20+OyBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgU2FsZWVtLCBTaGlyYXogPHNoaXJhei5zYWxlZW1AaW50ZWwuY29tPjsgVGFu
dGlsb3YsIEVtaWwgUyA8ZW1pbC5zLnRhbnRpbG92QGludGVsLmNvbT47IHdpbGxlbWJAZ29vZ2xl
LmNvbTsgZGVjb3RAZ29vZ2xlLmNvbTsgSGF5LCBKb3NodWEgQSA8am9zaHVhLmEuaGF5QGludGVs
LmNvbT47IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPjsgT3JyLCBNaWNoYWVsIDxtaWNo
YWVsLm9yckBpbnRlbC5jb20+OyBTaW5naGFpLCBBbmphbGkgPGFuamFsaS5zaW5naGFpQGludGVs
LmNvbT4NClN1YmplY3Q6IFJlOiBbSW50ZWwtd2lyZWQtbGFuXSBbUEFUQ0ggbmV0LW5leHQgMDAv
MTVdIEludHJvZHVjZSBJRFBGIGRyaXZlcg0KDQpPbiBNb24sIEFwciAwMywgMjAyMyBhdCAwNDoz
Njo1NlBNIC0wNTAwLCBTYW11ZHJhbGEsIFNyaWRoYXIgd3JvdGU6DQoNCj4gPiA+IEZ1cnRoZXIg
T0FTSVMgaGFzIGEgbGVnYWwgSVBSIHBvbGljeSB0aGF0IGJhc2ljYWxseSBtZWFucyBJbnRlbCAN
Cj4gPiA+IG5lZWRzIHRvIHB1YmxpY2x5IGp1c3RpZnkgdGhhdCB0aGVpciBTaWduZWQtb2ZmLWJ5
IGlzIGNvbnNpc2VudCB3aXRoIA0KPiA+ID4gdGhlIGtlcm5lbCBydWxlcyBvZiB0aGUgRENPLiBp
ZSB0aGF0IHRoZXkgaGF2ZSBhIGxlZ2FsIHJpZ2h0IHRvIA0KPiA+ID4gc3VibWl0IHRoaXMgSVAg
dG8gdGhlIGtlcm5lbC4NCj4gPiANCj4gPiBPQVNJUyBkb2VzIE5PVCBoYXZlIHN1Y2ggYSBsZWdh
bCBJUFIgcG9saWN5LiBUaGUgb25seSBJUFIgcG9saWN5IHRoYXQgDQo+ID4gYXBwbGllcyB0byB0
aGUgSURQRiBUQyBtZW1iZXJzIGlzIHRoZSDigJxOb24tYXNzZXJ04oCdIElQUiBwb2xpY3kgYXMg
DQo+ID4gc3RhdGVkIGluIHRoZSBDaGFydGVyLg0KDQo+IE5vbi1hc3NlcnQgaXMgcmVsZXZhbnQg
dG8gaW5jbHVzaW9uIGluIExpbnV4IGFuZCBpcyBwYXJ0IG9mIHdoYXQgdGhlIERDTyBjb25zaWRl
cnMuIEFjY29yZGluZyB0byB0aGUgT0FTSVMgSVBSIG5vbi1hc3NlcnQgZG9lc24ndCBhdXRvbWF0
aWNhbGx5IHRyaWdnZXIganVzdCBiZWNhdXNlIGluZm9ybWF0aW9uIGhhcyBiZWVuIHNoYXJlZCB3
aXRoaW4gYSBUQy4NCg0KVGhlIFRDIGNoYXJ0ZXIgc3RhdGVzIHRoYXQgKkFsbCogIFRDIHdvcmsg
aXMgdW5kZXIgTm9uLUFzc2VydC4gQW55IG1hdGVyaWFscy9kb2N1bWVudHMvY29kZSBzdWJtaXR0
ZWQgdG8gdGhlIFRDIGRvIG5vdCBjaGFuZ2Ugb3duZXJzaGlwLCBidXQgdGhleSBhcmUgY292ZXJl
ZCBieSBhICJub24tYXNzZXJ0IiBsaWNlbnNlLg0KdGhpcyBhcHBsaWVzIHRvIEV2ZXJ5dGhpbmcs
IG5vdCBqdXN0IGZpbmFsIG9yIGRyYWZ0IGRlbGl2ZXJhYmxlcy4gSSBoYXZlIG5vdCBzZWVuIGFu
eSBPQVNJUyBzdGF0ZW1lbnQgdGhhdCBzYXlzIHdoYXQgeW91IHF1b3RlIGFib3ZlLCBhbmQgdGhl
IFRDIG1lbWJlciBjb21wYW5pZXMgaGF2ZSBub3QgYWdyZWVkIHRvIGFueSBzdWNoLg0KVGhlcmUg
aXMgbm90aGluZyBuZWVkZWQgdG8gInRyaWdnZXIiIG5vbi1hc3NlcnQgYW5kIGFueSBpbmZvcm1h
dGlvbiBTaGFyZWQgaW4gdGhlIFRDICpJUyogdW5kZXIgbm9uLWFzc2VydC4gV2hlbiB5b3Ugc2lu
ZyB1cCB0byB0aGUgT0FTSVMgVEMgbWFpbGluZyBsaXN0IHlvdSBhZ3JlZSB0byB0aGVzZSB0ZXJt
cy4gDQoNCkJ1dCBtb3JlIGltcG9ydGFudGx5OiB3aGF0ZXZlciBPQVNJUydzIFBvbGljaWVzL0lQ
UiBhcmUsIHRoZXkgZG8gbm90IGFwcGx5IGhlcmUuIFRoaXMgZHJpdmVyIHVwbG9hZCBpcyBOT1Qg
cGFydCBvZiB0aGUgVEMgd29yaywgYW5kIE9BU0lTIGhhcyBub3RoaW5nIHRvIGRvIHdpdGggaXQu
IA0KDQoNCg0KPiBBcyB0aGUgc3VibWl0dGVyIHlvdSBuZWVkIHRvIGV4cGxhaW4gdGhhdCBhbGwg
SVAgYW5kIGxpY2Vuc2UgaXNzdWVzIGFyZSBhY2NvdW50ZWQgZm9yIGJlY2F1c2UgKmluIGdlbmVy
YWwqIHRha2luZyB3b3JrLWluLXByb2dyZXNzIG91dCBvZiBhIGluZHVzdHJ5IHdvcmtncm91cCB3
aXRoIGFuIElQUiBpcyBhIHByb2JsZW1hdGljIHRoaW5nIHRvIGluY2x1ZGUgaW4gTGludXguDQoN
CkkgZnJhbmtseSBkbyBub3QgdW5kZXJzdGFuZCB3aGF0IHRoZSBhYm92ZSBtZWFucywgYW5kIGhv
dyB0aGlzIHdvdWxkIG1ha2UgImFsbCBJUCBhbmQgbGljZW5zZSBpc3N1ZXMgYXJlIGFjY291bnRl
ZCBmb3IiLg0KIEFnYWluIC0gdGhlIGRyaXZlciBwdWJsaXNoZWQgYnkgaW50ZWwgaGVyZSBpcyBu
b3QgIiB0YWtpbmcgd29yay1pbi1wcm9ncmVzcyBvdXQgb2YgYSBpbmR1c3RyeSB3b3JrZ3JvdXAi
Lg0KT24gdGhlIGNvbnRyYXJ5IC0gdGhpcyBpcyBhbiBJbnRlbCBEcml2ZXIsIHRoYXQgd2lsbCBi
ZSBEb25hdGVkIElOVE8gdGhlIE9BU0lTIFRDIEluZHVzdHJ5IHdvcmstZ3JvdXAuIEV2ZW4gdGhl
biwgaXQgd2lsbCBOT1QgYmUgIlRIRSIgc3RhbmRhcmQuIEl0IGlzIGp1c3QgYSB3YXkgdG8gc3Bl
ZWQgdXAgdGhlIFRDIHdvcmsgYnkgaGF2aW5nIGl0IG5vdCBzdGFydCBmcm9tIHNjcmF0Y2guIA0K
DQoNCj4gZWcgeW91IGNhbiBzYXkgdGhhdCB0aGUgMC45IGRvY3VtZW50IHRoaXMgc2VyaWVzIGxp
bmtlZCB0byBoYXMgcHJvcGVybHkgcmVhY2hlZCAiT0FTSVMgU3RhbmRhcmRzIERyYWZ0IERlbGl2
ZXJhYmxlIiBhbmQgaXMgdGh1cyBjb3ZlcmVkIGJ5IHRoZSBJUFIsIA0KPiBvciB5b3UgY2FuIGV4
cGxhaW4gdGhhdCBhbGwgSW50ZWwgaGFzIGNvbmZpcm1lZCBvdXRzaWRlIE9BU0lTIHRoYXQgYWxs
IHBhcnRpZXMgdGhhdCBjb250cmlidWVkIHRvIHRoZSBkb2N1bWVudCBjbGVhciB0aGUgSVAgcmVs
ZWFzZSwgb3IgcGVyaGFwcyBldmVuIHRoYXQgSW50ZWwgaXMgdGhlID4gb25seSBJUCBvd25lci4N
Cg0KSSBhbSBub3QgcGxhbm5pbmcgdG8gc2F5IGFueSBvZiB0aGVzZS4gDQoxLiBUaGlzIGRyaXZl
ciBoYXMgbm90IHJlYWNoZWQgIk9BU0lTIFN0YW5kYXJkcyBEcmFmdCBEZWxpdmVyYWJsZSIgLSBp
biBmYWN0LCBJIGhhdmUgbm8gaWRlYSB3aGF0IHRoaXMgdGVybSBtZWFucyAtIGl0IGlzIG5vdCBp
biB0aGUgVEMncyBtaWxlc3RvbmVzLCBhbmQgaWYgdGhpcyB0ZXJtIA0KICAgICBoYXMgYW55IGxl
Z2FsL0lQUiBzaWduaWZpY2FuY2UsIEkgZG8gbm90IGtub3cgaXQuDQoyLiBUaGlzIGRyaXZlciBp
cyBhbiBJbnRlbCBkcml2ZXIsIHB1Ymxpc2hlZCBhcyBzdWNoLCBhbmQgaGFzIG5vdGhpbmcgdG8g
ZG8gd2l0aCBPQVNJUywgYW5kIGFueSBhbmQgYWxsIE9BU0lTIFBvbGljaWVzIGFuZCBJUFIgdGVy
bXMgZG8gbm90IGFwcGx5LiBXaGVuIHRoZSBJRFBGIFRDIHdpbGwgDQogICAgIFB1Ymxpc2ggYW4g
aW5kdXN0cnktc3RhbmRhcmQgSURQRiBkcml2ZXIgLSBUSEFUIGRyaXZlciwgbGlrZSBhbGwgVEMg
bWF0ZXJpYWxzLCB3aWxsIGJlIHVuZGVyIE5vbi1Bc3NlcnQgSVBSIHBvbGljeSAtIGFuZCBub3Ro
aW5nIGVsc2UuICANCg0KDQo+IFRoaXMgYWJub3JtYWwgdGhpbmcganVzdCBuZWVkcyB0byBiZSBl
eHBsYWluZWQsIG1haW50YWluZXIncyBjYW4ndCBiZSBsZWZ0IHRvIGd1ZXNzIGlmIElQIGlzc3Vl
cyBhcmUgY29ycmVjdC4NCg0KDQo+ICBKYXNvbg0K
