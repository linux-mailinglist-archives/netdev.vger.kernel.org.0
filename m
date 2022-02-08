Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B14AE33C
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386290AbiBHWVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386900AbiBHVSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 16:18:42 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D37C0612B8;
        Tue,  8 Feb 2022 13:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644355119; x=1675891119;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mfPH6OgpBTO2ohppjiYaJi1VDRHZLxPQPiLjqtPCbL8=;
  b=YRC4Zq8CqVcXe9YFLLSPp9l/y2qxK+WiQJcYvVCRgeHWnqJuFp9Eph3R
   g9wodcPlhWlfy2cXB/1kEnCnRIezKmNRO0LVo5zzvGmFyRhtAtHRNQniP
   uJpmCtCQCQ3lby7FPcqtU766sV/a0P1h3gbVeioIJtUbJUCYmbV1tvkog
   VRJYATqIm2u4yVm9vrbqHMFphK1lNgvlGhrjzCdjXrgceC6QPj8BQ98Dh
   UjLiUtWgxMamr8HKKxE7ce7y3Jxkxh+U6K4Ep6PFghcDq/bQCn98wWXc6
   8VM+oHnM7HCmCUMyWze0VHWf6UrLC1j3vq7tkAc9YXJ/GDqNDVk7tpq9S
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="249262434"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="249262434"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 13:18:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="536703766"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 08 Feb 2022 13:18:39 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 8 Feb 2022 13:18:38 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 8 Feb 2022 13:18:38 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 8 Feb 2022 13:18:38 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 8 Feb 2022 13:18:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYcQCcuF4rAQ6YGgK58Z+DlcjJbyCjCl66Xd/fAY1Zcnlp7x/kgn6RXVjo0Q/rJjc+bSopNSCI290h4fAGslwxonvDR7lTtjJAIowkjAs0pmQjWKudgdo0rHNDht0d51l4fud/QW1tz1IsyGFwC3nZLmitJGHnPSCM5O06c+ja1oaq8QTovormivO4SP1szhsmWbdPL6vzAgQXVk/rYWhCHZGNuUX5jUrmgyfRfFN404wB6IY7Lg3H2a8eRJUT67xq9MkU1bf2HKj7XN3vGv3kx5Vvoty1DMg3KXl/pvZvEY8xpcTHaiXgQ2jsebbgTMNC77+77ogR+0vwrygkW2uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfPH6OgpBTO2ohppjiYaJi1VDRHZLxPQPiLjqtPCbL8=;
 b=C2ja6iSi4DuKAkT7wfaFSVqlrG75iCPs/NoKyUQ4hE/wB4MEVBqiu5HeFawh1Qpma8n+3miUb1waVCCq7F4t3izjHttNqWNIYRIAgDNdVo9JybII3dL7hPyNdbO7ouQuwLQJdko0I3jlYiVdGpRSYI5Jm+SnDDVLfvajyg+ZMNo346ttZjLAbS7vZkG75kVEaMQq2D5cdY9MnTB/vXmXRb72W1evUrI1bFJVBVoNBv86CTrVm7uBlKD7RikDE+ZCRLA5g5mnzLzgjqotumgmCpAGE+O7h7dBcBCSQoWjRZbrHh4RoqoDAlh816mY1aHbC4yyr8nfhIFFoZ4ykuKZ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BYAPR11MB2614.namprd11.prod.outlook.com (2603:10b6:a02:cc::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 21:18:36 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1%5]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 21:18:36 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "Ertman, David M" <david.m.ertman@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/1] [pull request] iwl-next Intel Wired LAN
 Driver Updates 2022-02-07
Thread-Topic: [PATCH net-next 0/1] [pull request] iwl-next Intel Wired LAN
 Driver Updates 2022-02-07
Thread-Index: AQHYHH7HWBPuCWMiOE2S/3RcG/zIdayJ4Z8AgABIPAA=
Date:   Tue, 8 Feb 2022 21:18:36 +0000
Message-ID: <6591eabecd1959c1744828dad006860520708e9a.camel@intel.com>
References: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
         <20220208170000.GA180855@nvidia.com>
In-Reply-To: <20220208170000.GA180855@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1537b456-6b38-435e-f4f1-08d9eb4891a1
x-ms-traffictypediagnostic: BYAPR11MB2614:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB2614F39EA493CC069A86E4A1C62D9@BYAPR11MB2614.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3GtOVFqRYLhOWFakXC+fNCpXIPCgZKn4WIOzeOTlAT3wcmq6yEot2oTfbds+vKOUzl1cgiAS9x5cWGDd0H3lJPpOlh3conQF/RuyrJaRgV4PBiaPggcgmzGNZ1/hXU1oALPo++kZL3Ajrslgpj6n6k9CteePuiSKiRrgyTtlh3LYXDUKeooYqPnmlOpr6nS/oMEF0I/ybx5XJe8QRh/1arDW4aayUTV/b6T+ss/4wKJlhk5x2lhQo4FS4uWsfGT0l7WK0k/f2T+wMgu8byqw3XT/aNLUkr10dct/37FT6gF9wwy9A6sp6/lqUwH5kLWp81e7Lh1d5PiU0W2rddEypOn8nycc5cw2WdlHaLu/v2yY1E/GbNt81bU61Gc+xqAJnw+ObDFHBSIVaUAX4+trH/t98OKZ3QHSWEGKUH6hDftt471uxvYVorrpU/iAwYese1z3SxGSA+PTQ1Bfx7OeOcke3IoEeGtXxfKejExbaEULY8+Yoim8shOl6Yc38WI/1+q+CVmDh3Tywjrm93NnN2fK66RjavpCfI6mme5xzOxBshhH9HjM/O5ItkCbJUcRdBpqjvvV4XHZaa9+rNZ8eaz9IwyfM3LyLWEhg/EoqdNBw6PXT5l2P4PhTaEPm/8xjts1MvF1XhH0ab5B4DQ9zSFyOtojjVRKrGrV0ZDtVqEeVB+k4qWiAem1r5Z3mS2HME50ROiVE9FzI13EvWNVgEB325+4YxfDJTs49+esFvS7+TqZl/0tRzVA40umSnjZhBeIKxG2KGz9ffHwlPh2ymadZcBDJHH6iCzpChb5kSw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(71200400001)(2616005)(83380400001)(8676002)(76116006)(8936002)(508600001)(64756008)(5660300002)(66476007)(86362001)(66446008)(66556008)(26005)(6506007)(66946007)(2906002)(38100700002)(82960400001)(186003)(316002)(54906003)(6916009)(4326008)(38070700005)(6486002)(122000001)(36756003)(966005)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmZnem9ESFM0RHB5TjFCZzNRQjNPdWc5M2Y3TWJSMzY3M1k3NEN5T2xEWXlF?=
 =?utf-8?B?ZTlXZ2xYUTJoZWVqUytpSEJxTjNWS09FWGtYNEVrK2ZTZXlTOVlVaHltMjRK?=
 =?utf-8?B?RGN5MEhETTMyNDJqT1hWZGNYcWlaVDg3MlBoeEUvMnQ3VVp6azVWbmFrcnYv?=
 =?utf-8?B?Z3RPNkNzbjJSSHdsMStEVmF5NkNzeFZVUHc2dk1mR09QWFZicFh6UEQ4Mk01?=
 =?utf-8?B?MW42eWFhS0NQMlBheGxrcGpWVkZZdFRibHBHNzhXbnRmWEwrT3NvYnNQY2cx?=
 =?utf-8?B?Y0VBNTQvUDdGMUpsK1NJR0M5aTUwUlFIRGswNkVNa3FRUnR2UmxLaU5sRzdG?=
 =?utf-8?B?NHNsVjlJcE1uZmJnK2x5QnZoN3IzZ2srWGx5Q0hqeUFLcVZtY0w2amIrZUp4?=
 =?utf-8?B?RUFMTEJxL1UvZ0RPM3B2SFZQSGlWMjh1ZkVLUFFPdTIza3lNSVJWS3VhaGlH?=
 =?utf-8?B?aWFQZ1RHbHVwUFgrSEh5U1pOajRYSnk4S1ZzemlhNFpyaVBuMWJEYkozUlFC?=
 =?utf-8?B?YUt4VFhGK1U4Tlh3OUxySHRES0VqczlQZ3c3M2x3WHpVU2NYWGFNNUI3TGUy?=
 =?utf-8?B?SmtJb25Cd283QnpMQzZwZXZWMVhZTmtRb3hCTlRIdXVLY3VXd0s4S2JHUTFP?=
 =?utf-8?B?WlU3UkpzSHVIZG5XN2xST2NtVDlEZEUydkZOVHMvWDM5bU5pUGRLUUt1TkRY?=
 =?utf-8?B?L0YwZTJkdVRKV1ZqSDZuMjNDME1rYVBxaUpOcmw2UVlhSzN6c3h2NGIwb1Np?=
 =?utf-8?B?SWcydVVPQ0xVb3c3YmlnRnJaZHd4R1pCNlJsSWFUc3N0Yk4vYWNLZFlpaWUv?=
 =?utf-8?B?NTR3YlplRW5NM0hxSlZFNHNQQityck5hQnRvMW9jNTRscDlXRUU1U0tZMHF1?=
 =?utf-8?B?VGh2K2dGRUt6bjZKNnFiUHdsemh5aWhrclovU2NOVmovMllqYXZqdDE5WXlM?=
 =?utf-8?B?dzIyNDRKbUFJcTJkQUVGM0Nkek5QMUo4cHZ6U3RBMVZIMEN5RHE3R1JwNk42?=
 =?utf-8?B?QkN0ZEpra05aUEZJUkRsN2FGa0xNUjBQQW9MeHlQWGlNL1g5TllPSDE0U1JG?=
 =?utf-8?B?cDlQbnkyVXU2SFp0K1oxeUtCdVRoN3owS3B2T0xXdVU3VzZtL0ZwaUVnTkVY?=
 =?utf-8?B?N2d6aWJVQS9sM1UvVUhtSGZRUlBLNDlSTDMyS09uUENDL2pOM3VFVGRzNTdW?=
 =?utf-8?B?Mm9lNnNUdk40MVdGZXZDVmdycTFmQWtDNi83SFFUOEptbzhsa1BMOWx4blZ4?=
 =?utf-8?B?aGwrVnBtc09hTGFtWUlaYUJkaXZ6SUJJNjZFQVJlMlJSdE1xcWVhZlpLNzd1?=
 =?utf-8?B?aDNlbmw5b1VhY05SdFpGZjNjbFpaMXh2eFRxQ3ZsUGNXQ3lDQ0xNTEJnMWNY?=
 =?utf-8?B?MGJtM3d0QlNyUUdRTnBzZ1dKbUpuU1JFL05pTGVPcVNuT3lzUkZoK1NGQzBm?=
 =?utf-8?B?MGEwL2V3WDFsc3g1eHdsRjF6eGhkcnpkbTlLN293ejA4am55Mzhta0d6UVlv?=
 =?utf-8?B?VTgrVXd1cE9MakJhSWoxTmhJMGRqRWNOMXhsMmg1bzAyVHlLTzFHT3A3MjZ5?=
 =?utf-8?B?V3IwNHFFbDlIZjVFRXhkU0dZSUwxVTJNZzBlYXdGOXZ0d0NnQzJ0WFlLM3Fu?=
 =?utf-8?B?WThNSmFPOHJNUE41L3hrU2FNL2tLQ2VFZHRaVUlWRkgrbzNnWEhVakxwMzN3?=
 =?utf-8?B?VEhHSHdtWk9xZW1aWk82T0RYYjVWeDNHMTlrN2hGZnJERkdtT3NybEJyQlR1?=
 =?utf-8?B?WmlXeEFtR2lqZmk0NTlLNkhkQ3o0djVielR6OGQwNGZHd2tmUFFSdzV2V1Er?=
 =?utf-8?B?SDVKMWNXYkUvZHpWajVNVFI1MnFSdkVsR21OalNObk93c2k3aEdpYnNwenRG?=
 =?utf-8?B?aG5tcUE3V1IxSVhUQkNKeU90amljcW1MT2RTRGFPME9rTFNZTk1PR2JyYlNH?=
 =?utf-8?B?Z3JXdHNpdEk4NmZDNG5SdURLZHNWbi9nUXdZYm9ScXcrZDkzZXRaSm5HT2Vx?=
 =?utf-8?B?UC9oZjgxUFQ1NEdHcXU0V1RNeTdndGQrS3ZyWUsrcHorN0FnRXRXamlkVFZa?=
 =?utf-8?B?TFZBNG5wdnVQNnBObGNKa0xGdEdoSzZhajVYaDgzSVRTVlA4M1JLUXNGRUVr?=
 =?utf-8?B?ejZ3dWFTT0JtWG1hSVFJeU1MdFJNc214dzhFeE9QVkdWL3QvcktsSEdXNmVj?=
 =?utf-8?B?UXNwb3lKNW0rQ3hCNUJEMXhVci9ML1VSUE45YkhFNm1ybWlJRkRmdjl4WlZx?=
 =?utf-8?Q?CDwq22AWG1mE2RHI9/4xQDQWVnYO3aOAMMtg4BNdzk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F281D9837E26404AB4A7D9C0E1028B29@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1537b456-6b38-435e-f4f1-08d9eb4891a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 21:18:36.1868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 75vhi5vnrXeSMacxSBtbdYz51fCx8VwVZAgl5loRqgSxS++xFvCxPEjDu0fEVALY6t8TRqihLmONEknjThM+/dOfJh4ghOiPxtFcGUJGza0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2614
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

T24gVHVlLCAyMDIyLTAyLTA4IGF0IDEzOjAwIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIE1vbiwgRmViIDA3LCAyMDIyIGF0IDAzOjU5OjIwUE0gLTA4MDAsIFRvbnkgTmd1eWVu
IHdyb3RlOg0KPiA+IFRoaXMgcHVsbCByZXF1ZXN0IGlzIHRhcmdldGluZyBuZXQtbmV4dCBhbmQg
cmRtYS1uZXh0IGJyYW5jaGVzLg0KPiA+IFJETUENCj4gPiBwYXRjaGVzIHdpbGwgYmUgc2VudCB0
byBSRE1BIHRyZWUgZm9sbG93aW5nIGFjY2VwdGFuY2Ugb2YgdGhpcw0KPiA+IHNoYXJlZA0KPiA+
IHB1bGwgcmVxdWVzdC4gVGhlc2UgcGF0Y2hlcyBoYXZlIGJlZW4gcmV2aWV3ZWQgYnkgbmV0ZGV2
IGFuZCBSRE1BDQo+ID4gbWFpbGluZyBsaXN0c1sxXS4NCj4gPiANCj4gPiBEYXZlIGFkZHMgc3Vw
cG9ydCBmb3IgaWNlIGRyaXZlciB0byBwcm92aWRlIERTQ1AgUW9TIG1hcHBpbmdzIHRvDQo+ID4g
aXJkbWENCj4gPiBkcml2ZXIuDQo+ID4gDQo+ID4gWzFdDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbmV0ZGV2LzIwMjIwMjAyMTkxOTIxLjE2MzgtMS1zaGlyYXouc2FsZWVtQGludGVsLmNv
bS8NCj4gPiBUaGUgZm9sbG93aW5nIGFyZSBjaGFuZ2VzIHNpbmNlIGNvbW1pdA0KPiA+IGU3ODMz
NjJlYjU0Y2Q5OWIyY2FjOGIzYTlhZWFjOTQyZTZmNmFjMDc6DQo+ID4gwqAgTGludXggNS4xNy1y
YzENCj4gPiBhbmQgYXJlIGF2YWlsYWJsZSBpbiB0aGUgZ2l0IHJlcG9zaXRvcnkgYXQ6DQo+ID4g
wqAgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RuZ3V5L2xp
bnV4IGl3bC0NCj4gPiBuZXh0DQo+IA0KPiBObyBzaWduZWQgdGFnPw0KPiANCj4gSW4gZnV0dXJl
IGNhbiB5b3Ugc2VuZCB0aGVzZSBpbiB0aGUgc3RhbmRhcmQgZm9ybSBzbyBwYXRjaHdvcmtzIHdp
bGwNCj4gcGljayB0aGVtIHVwPw0KPiANCj4gQWxzbyBwbGVhc2UgYWRkIGNvdmVyIGxldHRlcnMg
c28gdGhlcmUgaXMgc29tZXRoaW5nIHRvIHB1dCBpbiB0aGUNCj4gbWVyZ2UNCg0KSSdtIHN0aWxs
IHRyeWluZyB0byBmaWd1cmUgb3V0IGhvdyB0byBkbyB0aGUgc2hhcmVkIHB1bGwgcmVxdWVzdHMu
IEknbGwNCmxvb2sgaW50byByZXNvbHZpbmcgdGhlc2UgaXNzdWVzIHlvdSBwb2ludGVkIG91dCBm
b3IgbmV4dCBvbmUuDQoNCk9uZSBvZiB0aGUgdGhpbmdzIEknbSBzdGlsbCB1bnN1cmUgb24gaXMg
d2hldGhlciB0aGUgc2hhcmVkIHB1bGwNCnJlcXVlc3Qgc2hvdWxkIGNvbnRhaW4gdGhlIG5ldGRl
diBhbmQgUkRNQSBwYXRjaGVzIG9yIG9ubHkgdGhlIG5ldGRldg0Kb25lcy4NCg0KVGhhbmtzLA0K
VG9ueQ0KDQo+IEJ1dCBQUiBhcHBsaWVkIGFsb25nIHdpdGggdGhlIG1hdGNoaW5nIHR3byBSRE1B
IHBhdGNoZXMuDQo+IFRoYW5rcywNCj4gSmFzb24NCg0K
