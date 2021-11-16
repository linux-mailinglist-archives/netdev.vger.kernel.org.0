Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2BA453AC3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhKPUVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:21:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:32010 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhKPUVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:21:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="233763599"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="233763599"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 12:18:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="586297009"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Nov 2021 12:18:06 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 12:18:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 12:18:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 16 Nov 2021 12:18:05 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 16 Nov 2021 12:18:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iseiMLM/cIDpeJeNFQcydYFhXVf5SLtJt9AU9rKfO5I/Jcejov80fVGTw7FAamOPCWHxiIEI/ZAkafl8UkNbtL/vfnk+/mJ3xdz7dcAnKFQVC8WvqqONXfsHbgS3GUgsgu93yBultiAT/zSJquXtyGeC2wVTe/feUi+rGOrwP7Jzs+cVSCENM6rjLz36Xdu4/dqJQHvh15NGbhKBksGBpWuXMvzdFRpHCfmVwJsTuM2efv3wvXZ85hFvKNKH3tM01ZkSUVk/NRpBDHePKNn6nELvic3qAFtT+fbQoE+DNJ3Qb6dQ/CsYhG2fYPcwsF+MDFIZRi3U4Y3t+YK9puEfIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAahuKMLRpgvgAzB/GJevDTFu/iC+H94mw0z1K94D98=;
 b=ivrYWdkGkmRxOwO0joi5cjmeqJHTgIxRpEDK/bszv2vdxGuL3H/NyVhi2+6sELPmYU4zC73v7t7ZzE5SAR03UmHMe8EyeWdwshp/FjyLempF5HjLqxoN/9ioofgvxMSGp/jQRgP6UeUoGMkXP8KWEaXOTcR3Zz2enNOpMxk5xZIVBkWprXPHw3oeM4UnHQpr8q9nA3quYPolQwbE1xVoHnEpkpyGgK3m32glpWkk7Wz4+1m8YBSpsxZqaGfNAw+LlgugtJH25N5nTmIs00ukAl8buiJG6W3Z9/DASvHnMLSjqRNFJneV0J2OQlQeNN2tB6KX1WrtqwdpydMPzEYxyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAahuKMLRpgvgAzB/GJevDTFu/iC+H94mw0z1K94D98=;
 b=fEKTZXoNFL6tcKyM0hdiGHecLaDAUS5hwY5kjmz80e/TIzFswmrEHmSkMDyAYgGEcsx0swo7DJ+U/BmxuEGzyvH/Vn55YFatG8QcnjQPGCMB6Vw2OqLeg/OzsUW8btGYsigsIZMQplKHb8Jxw/+B3EnYov7dDF6nbXrXO26CLEU=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4633.namprd11.prod.outlook.com (2603:10b6:303:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17; Tue, 16 Nov
 2021 20:18:04 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::1c41:b47d:6152:d72]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::1c41:b47d:6152:d72%4]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 20:18:04 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Stefan Assmann <sassmann@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brelinski, Tony" <tony.brelinski@intel.com>
Subject: Re: [PATCH net 06/10] iavf: prevent accidental free of filter
 structure
Thread-Topic: [PATCH net 06/10] iavf: prevent accidental free of filter
 structure
Thread-Index: AQHX2n0pB7YlQd95ekar5XlQtFhsCawFwPiAgADYKIA=
Date:   Tue, 16 Nov 2021 20:18:04 +0000
Message-ID: <a7adb8a7-800e-6761-b791-e877ff79210a@intel.com>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
 <20211115235934.880882-7-anthony.l.nguyen@intel.com>
 <20211116072421.jar25sc7plvql7gw@p1>
In-Reply-To: <20211116072421.jar25sc7plvql7gw@p1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4df656a-f4f3-4a09-5904-08d9a93e325f
x-ms-traffictypediagnostic: MW3PR11MB4633:
x-microsoft-antispam-prvs: <MW3PR11MB4633802C148DA5100692272AD6999@MW3PR11MB4633.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /lLB1gZnibmAgPVVHNEWcamvREK5mDqBrMF5IUvC0ZlFyRCa2+EMscpCzSEJPARKu8EB5j0Y7TUVW6MMAP1s56PeLUIxf+TWn1zW8JYuYHCQue95cKJ2fPk+5nvLFmtmfF+W+MrAU72yzjbLxzjuofREss2Q+TovfwHTG0F7Lc4Z83TxESDaWKykN22+ZdbPyVlkJK70mFSoTrQCypEyzhi0fh2sn+fowwsp/fr8AVPADJEjGjaZkZm4RrDFXLLaRZWU8/PMiMoP3Jy3GkSf0kNSRA7s0rgoB8in17oooS1ECVK/fdsAEYTSxIAhodYjMRZ3hYO+1gBd3N7ngWAKoeiBRgWR8FSR6lD9K5GhzEZrsL6Ao48i1QMJ1NSrVOS80zGFW1VmttLfkMRDQyhmg1tGUMl9HzS52S0b5Gnz0ARN0N1by9Dhm++YWy74praG4BFl6zs4FNtnmYa4dx2y8N2THDF/XXBdEXs+tc4QUfBkjKIbblTWGtboOfslmcPdCBEbv1pTB4O0GmMA+YelQ3463O858w4r/ypHGo+QcySAcn1fvnCo7dNQJjBxIzb8g4TCWeKfeeZCsvoDsY567oQimWTs5xtrmVciMqdX/wDAHqX8OrgciRZ64DpSG2lobDNEOfxYwClXqEAW0cCwDYYYuFbQ5vyEyXOep6UROBsovTUrwgRrmhOWzD/zMg4r4gnxUlVjTKojmkQH0H+Wu4UiyoorlCsgTReh9+gPg8kvOU6oTJOv7DCeve8tehdWSd80xyJGDa6TgUgz3X9p1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(31696002)(66946007)(4326008)(66446008)(64756008)(6636002)(26005)(8936002)(186003)(86362001)(76116006)(110136005)(83380400001)(82960400001)(2616005)(508600001)(38070700005)(8676002)(6512007)(6486002)(5660300002)(4001150100001)(31686004)(6506007)(53546011)(54906003)(71200400001)(38100700002)(316002)(107886003)(2906002)(122000001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3pWRk42MndnamtrNE8yRTJWSEdmemVCQzA5YW56YnFXdEdMMElNbTdwemJS?=
 =?utf-8?B?K0EyeFRxWkg4aW52UnFjbjN0ZDhubTM5a3pkVzd2UE5HMGNqbTJTUDZJZE1X?=
 =?utf-8?B?d3U3eE5UeDFGa0dJanRvM045TnE1UlZZMGVmZUhzTnRoYWVXUlFoUTFxOHRv?=
 =?utf-8?B?d2tGRFJQMklRdDZUWmk1YWlMNzhwQWNINFM1aWtDekdpNFVmN1JOMkhoUnRZ?=
 =?utf-8?B?L1RQakZma2I2ZDR6VHRubVA0YXEzZEhNU1FRMndHMG1XYnp6WFR6TDlqVW81?=
 =?utf-8?B?aHljSTdCVWlTeE5hKzN2MHlINVhZa2xzN01IMXFRcVhPQ3hTSEk5Y3lkUkQ3?=
 =?utf-8?B?VTFjbytMSFhzU3hZNENWN3lKcWJDZEp5a1Bqa3VvWFFqY1JBRExiVTE5Q01y?=
 =?utf-8?B?c0VqcmdkUndmMVJ5S0FmVUVVeXhsUEkrTWtlYS9tbnZEanFBQzJISm5tNEx3?=
 =?utf-8?B?UTc4UE5zUXVIMlJGdUViZEhUc0p0SG5EamFGZUtiV1I3WGFwVlBQYm1VdWVB?=
 =?utf-8?B?ZWFSa1M4Q1VNYlF4S0Vtd0dvdDVlY2ZrS1A5eEU5VE9QOXZUS3p2SHdSYTdp?=
 =?utf-8?B?b2U0YlJJejZ4WWVjNExJSGI0WTJXeHUwQUloVm9kUlNLQ3NxY1c5T3RneTFL?=
 =?utf-8?B?bmRDT2RPN2llY0NpTEdSeldGOUc2Mis3OElYY01sYm0vaTVvTjdncncvR3lk?=
 =?utf-8?B?bTNGczBQVFRtNTVZdm1zV00wWjJmdzBmOEFWWVduZi9ONG9ITGZBU0xWZVU2?=
 =?utf-8?B?dExySjlWaTJ1bWxSdzJPdnB6NFhKWm9qd3dJSElWWlV5THd0TS92VXVESmYw?=
 =?utf-8?B?R3ZwUmdXUVpESGxOQzVTc3E5Wjg2NlZXRmN0dkVWQW9tWC84K3Z1d2k1eDhP?=
 =?utf-8?B?cVJoeDMyQVVCcmVDblpOaWg3Sm9PamRzaW9ycWgwaHpXWUcwVE1ycm42bjZU?=
 =?utf-8?B?MFd6TU9zckFqV1BFWVE2dWtRbEtpNFo5WEFNUjVRNTFzSDJZZSszeXhmUlhW?=
 =?utf-8?B?SmhZTlNhYzJKS1pjbTZ0RXFkZ0RIakdpcDZ0Ymc2US90NFZFWDdGMTM1TmRh?=
 =?utf-8?B?SW42TTZHTWlzaEYyRTJ0aGZuUVhqcXBxUnVheGJZclJCMVExTmpBTmZkT1F0?=
 =?utf-8?B?Ty9oWURRSENaancvbitmU1pqU1hpTHdZdTZPNFYybDBVZkdJbDFrUllyMEpV?=
 =?utf-8?B?Tjg0bWVJQkZqdzFGVGxndGNidEd3YXlDNGlBU1RHbEJEaE9BMkp3UEdDditW?=
 =?utf-8?B?dWJ2Y1dhNkU2Unlrcy9LM0ZaS0ZPTVlUSmJySDhRbVZoYTBvb3d2RUZUcjFv?=
 =?utf-8?B?Y1Q3b2p1TGVjbkFxbmRqaUQyUzFtcmZrSU4wa28xWmRkK1dYK2FiQ21JTERh?=
 =?utf-8?B?Nkp0UUJHOXNHajdjWEVpZEtad3Q2YklPdXNyb0c3b0ttVDg3dTR1L2xqenVO?=
 =?utf-8?B?bXVRT3ZzcnlCQjJkbGNtK1hzbzAyMXpxdHBxUnZMMC9GYXZHbWltSFF0QnlK?=
 =?utf-8?B?SVluK2pPbEw5enFvaDV4S2s0ZHBQVGozbHhNS3dRbS8wRi92alNhSlZnY3F2?=
 =?utf-8?B?azVlSSszNzdpcEwzWFpQdzA0SVRMcE9JMzFDVkpOUU5iNzlrd1BhS1A0d0NK?=
 =?utf-8?B?bG44eEsrRytkZndTT1BGOFBodjBmT0lhaXFldyt0S21ELzJzNlhRMXJHbU4v?=
 =?utf-8?B?MHAwdEk3MXFHZkRGNDQ4OFQ1SFJlbkc5a1pHODVPRkpISDVuMEk4UG9uL0to?=
 =?utf-8?B?RUdwc1RPVUtWakFjMGRyMHM1TXg3ck5HSmpJdEpZTElHNXYxcjc5bWFzNUl2?=
 =?utf-8?B?MUpyVzFTOTkwc0NHNWxTQVdtVytYTGNwVHNzbXdQSU1XR2YzdFpUK3Fyd25a?=
 =?utf-8?B?SXg0Q1dOVVptSDlBTUptSGJVQUJEZURkcjNQZGYzN3p3UDdqUEovYlVTOXg5?=
 =?utf-8?B?ckVQeGJ4RFo3d1JBcmFBUWttSm1FN1NQS0J1MW1oL2E3Zm1pZUJFOVpaOXVL?=
 =?utf-8?B?RUhWUDFDN2VRZDRCSWJiN0J3bXBCaTRTSmR5M2pDWW5OWUtoOFBLWmdIc0h6?=
 =?utf-8?B?ZFp2TnNrcGliUWNNc3phUVVTUFl1KzhSem5idk5hY2hDQ0hvSDFYbW1JNnBS?=
 =?utf-8?B?b3B2MDR1V2ExL1JkZDNyVjMwbHVMUk9OaXhzM2FTYk1jZHRnUDlXdkdzMmIv?=
 =?utf-8?Q?P0klu+j3rUKZALtwiNUstSSzv9RK0tT4EXJBDn0D/Yko?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED20068E4041A54EAC1F766939D9AB25@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4df656a-f4f3-4a09-5904-08d9a93e325f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 20:18:04.6786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Nuciwxd026TCWHemEg2BbfD/mQVt6zoUF6OiN+pwOMymPHkq5XbX5JYcwIuJY7J2QLp0S70uNp6wgyNr6iz5++4JKv40cUngXpdKqgllfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4633
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTUvMjAyMSAxMToyNCBQTSwgU3RlZmFuIEFzc21hbm4gd3JvdGU6DQo+IE9uIDIwMjEt
MTEtMTUgMTU6NTksIFRvbnkgTmd1eWVuIHdyb3RlOg0KPj4gRnJvbTogSmFjb2IgS2VsbGVyIDxq
YWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+Pg0KPj4gSW4gaWF2Zl9jb25maWdfY2xzZmxvd2Vy
LCB0aGUgZmlsdGVyIHN0cnVjdHVyZSBjb3VsZCBiZSBhY2NpZGVudGFsbHkNCj4+IHJlbGVhc2Vk
IGF0IHRoZSBlbmQsIGlmIGlhdmZfcGFyc2VfY2xzX2Zsb3dlciBvciBpYXZmX2hhbmRsZV90Y2xh
c3MgZXZlcg0KPj4gcmV0dXJuIGEgbm9uLXplcm8gYnV0IHBvc2l0aXZlIHZhbHVlLg0KPj4NCj4+
IEluIHRoaXMgY2FzZSwgdGhlIGZ1bmN0aW9uIGNvbnRpbnVlcyB0aHJvdWdoIHRvIHRoZSBlbmQs
IGFuZCB3aWxsIGNhbGwNCj4+IGtmcmVlKCkgb24gdGhlIGZpbHRlciBzdHJ1Y3R1cmUgZXZlbiB0
aG91Z2ggaXQgaGFzIGJlZW4gYWRkZWQgdG8gdGhlDQo+PiBsaW5rZWQgbGlzdC4NCj4+DQo+PiBU
aGlzIGNhbiBhY3R1YWxseSBoYXBwZW4gYmVjYXVzZSBpYXZmX3BhcnNlX2Nsc19mbG93ZXIgd2ls
bCByZXR1cm4NCj4+IGEgcG9zaXRpdmUgSUFWRl9FUlJfQ09ORklHIHZhbHVlIGluc3RlYWQgb2Yg
dGhlIHRyYWRpdGlvbmFsIG5lZ2F0aXZlDQo+PiBlcnJvciBjb2Rlcy4NCj4gDQo+IEhpIEphY29i
LA0KPiANCj4gd2hlcmUgZXhhY3RseSBkb2VzIHRoaXMgaGFwcGVuPw0KPiBMb29raW5nIGF0IGlh
dmZfcGFyc2VfY2xzX2Zsb3dlcigpIEkgc2VlIGFsbCByZXR1cm5zIG9mIElBVkZfRVJSX0NPTkZJ
Rw0KPiBhcyAicmV0dXJuIElBVkZfRVJSX0NPTkZJRzsiIHdoaWxlIElBVkZfRVJSX0NPTkZJRyBp
cyBkZWZpbmVkIGFzDQo+ICAgICAgICAgSUFWRl9FUlJfQ09ORklHICAgICAgICAgICAgICAgICAg
ICAgICAgID0gLTQsDQo+IA0KPiBJJ20gbm90IG9wcG9zZWQgdG8gdGhpcyBjaGFuZ2UsIGp1c3Qg
d29uZGVyaW5nIHdoYXQncyBnb2luZyBvbi4NCj4gDQo+ICAgU3RlZmFuDQo+IA0KDQpIZWguDQoN
CkkgZG9uJ3QgaGF2ZSBtZW1vcnkgb2YgdGhlIGZ1bGwgY29udGV4dCBmb3IgdGhlIG9yaWdpbmFs
IHdvcmsuIFdlJ3ZlDQpiZWVuIGdvaW5nIHRocm91Z2ggYW5kIHRyeWluZyB0byBwdWxsIGluIGZp
eGVzIHRoYXQgd2UndmUgZG9uZSBmb3Igb3VyDQpvdXQtb2YtdHJlZSBkcml2ZXIgYW5kIGdldCBl
dmVyeXRoaW5nIHVwc3RyZWFtLg0KDQpBdCBmaXJzdCBJIHRob3VnaHQgdGhpcyBtaWdodCBiZSBi
ZWNhdXNlIG9mIHNvbWUgaGlzdG9yeSB3aGVyZSB0aGVzZQ0KdmFsdWVzIHVzZWQgdG8gYmUgcG9z
aXRpdmUgaW4gdGhlIG91dC1vZi10cmVlIGhpc3RvcnkgYXQgc29tZSBwb2ludC4uLg0KQnV0IEkg
dGhpbmsgdGhpcyB3YXNuJ3QgdHJ1ZS4gSXQgaXMgcG9zc2libGUgdGhhdCBzb21lIG90aGVyIGZs
b3cNCmFjY2lkZW50YWxseSBzZW5kcyBhIHBvc2l0aXZlIHZhbHVlLCBidXQgSSd2ZSBsb25nIHNp
bmNlIGxvc3QgbWVtb3J5IG9mDQppZiBJIGhhZCBhbiBleGFtcGxlIG9mIHRoYXQuIFlvdSdyZSBj
b3JyZWN0IHRoYXQgSUFWRl9FUlJfQ09ORklHIGlzIChhbmQNCmhhcyBiZWVuIGluIGJvdGggdXBz
dHJlYW0gYW5kIG91dC1vZi10cmVlIGNvZGUgc2luY2UgaXRzIGluY2VwdGlvbikNCm5lZ2F0aXZl
Lg0KDQpJIGRvbid0IHRoaW5rIHRoaXMgY2hhbmdlIGlzIGhhcm1mdWwsIGJ1dCBJIHRoaW5rIHlv
dSdyZSByaWdodCBpbg0KcG9pbnRpbmcgb3V0IHRoZSBkZXNjcmlwdGlvbiBpc24ndCByZWFsbHkg
dmFsaWQuDQoNCkknbSBoYXBweSB0byByZS13cml0ZSB0aGlzIGNvbW1pdCBtZXNzYWdlIGZvciBj
bGFyaXR5Lg0KDQpJIGRvIHRoaW5rIHN3aXRjaGluZyB0byAiaWYgKGVycikiIGlzIG1vcmUgaWRp
b21hdGljIGFuZCB0aGUgY29ycmVjdA0KdGhpbmcgdG8gZG8uDQoNClRoYW5rcywNCkpha2UNCg0K
Pj4gRml4IHRoaXMgYnkgZW5zdXJpbmcgdGhhdCB0aGUga2ZyZWUoKSBjaGVjayBhbmQgZXJyb3Ig
Y2hlY2tzIGFyZQ0KPj4gc2ltaWxhci4gVXNlIHRoZSBtb3JlIGlkaW9tYXRpYyAiaWYgKGVyciki
IHRvIGNhdGNoIGFsbCBub24temVybyBlcnJvcg0KPj4gY29kZXMuDQo+Pg0KPj4gRml4ZXM6IDAw
NzVmYTBmYWRkMCAoImk0MGV2ZjogQWRkIHN1cHBvcnQgdG8gYXBwbHkgY2xvdWQgZmlsdGVycyIp
DQo+PiBTaWduZWQtb2ZmLWJ5OiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVsLmNv
bT4NCj4+IFRlc3RlZC1ieTogVG9ueSBCcmVsaW5za2kgPHRvbnkuYnJlbGluc2tpQGludGVsLmNv
bT4NCj4+IFNpZ25lZC1vZmYtYnk6IFRvbnkgTmd1eWVuIDxhbnRob255Lmwubmd1eWVuQGludGVs
LmNvbT4NCj4+IC0tLQ0KPj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lhdmYvaWF2Zl9t
YWluLmMgfCA0ICsrLS0NCj4+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pYXZmL2lhdmZfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWF2Zi9pYXZm
X21haW4uYw0KPj4gaW5kZXggNzZjNGNhMGYwNTVlLi45YzY4Yzg2Mjg1MTIgMTAwNjQ0DQo+PiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pYXZmL2lhdmZfbWFpbi5jDQo+PiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pYXZmL2lhdmZfbWFpbi5jDQo+PiBAQCAtMzEw
OCwxMSArMzEwOCwxMSBAQCBzdGF0aWMgaW50IGlhdmZfY29uZmlndXJlX2Nsc2Zsb3dlcihzdHJ1
Y3QgaWF2Zl9hZGFwdGVyICphZGFwdGVyLA0KPj4gIAkvKiBzdGFydCBvdXQgd2l0aCBmbG93IHR5
cGUgYW5kIGV0aCB0eXBlIElQdjQgdG8gYmVnaW4gd2l0aCAqLw0KPj4gIAlmaWx0ZXItPmYuZmxv
d190eXBlID0gVklSVENITkxfVENQX1Y0X0ZMT1c7DQo+PiAgCWVyciA9IGlhdmZfcGFyc2VfY2xz
X2Zsb3dlcihhZGFwdGVyLCBjbHNfZmxvd2VyLCBmaWx0ZXIpOw0KPj4gLQlpZiAoZXJyIDwgMCkN
Cj4+ICsJaWYgKGVycikNCj4+ICAJCWdvdG8gZXJyOw0KPj4gIA0KPj4gIAllcnIgPSBpYXZmX2hh
bmRsZV90Y2xhc3MoYWRhcHRlciwgdGMsIGZpbHRlcik7DQo+PiAtCWlmIChlcnIgPCAwKQ0KPj4g
KwlpZiAoZXJyKQ0KPj4gIAkJZ290byBlcnI7DQo+PiAgDQo+PiAgCS8qIGFkZCBmaWx0ZXIgdG8g
dGhlIGxpc3QgKi8NCj4+IC0tIA0KPj4gMi4zMS4xDQo+Pg0KPiANCg0K
