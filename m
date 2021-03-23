Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D703A345AA6
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 10:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCWJT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 05:19:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:57894 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCWJTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 05:19:16 -0400
IronPort-SDR: O+ks/e5LOfppLHiSJRlcosOXvIWFLKTMzlozwPnBgg0tXSMn+VerlTuNhLrg2rNQ12nG4mAyFx
 lhfHW2xNYb0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190535264"
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="190535264"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 02:19:15 -0700
IronPort-SDR: aBBucxcdMxMk7RB4+uV+qErwQXNM1hZhDo/7WcMdcQ9DI8rmp4s4dDWOCHqSQS9gOBc5njJWkl
 E8r4g5akyD3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="374171543"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 23 Mar 2021 02:19:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Mar 2021 02:19:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 23 Mar 2021 02:19:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 23 Mar 2021 02:19:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8WQgciFNAhZR266YxlLw548x0z+8TvLRL1rU9Lw2QmfU9icom6BfyrTHjS+doQJplg4SFLvZQ7IaU6Z71ihQF23BdlP33IFA5+thUmwHwB7c3Bd8RKFWzwu/nCYfWo35clgWKnfQmnFY2CnnyCLexbBGftalLppqRUKC7uRmXsIDFlvoSoW+aXJKLPGGBvfpTIP/xTK0HyullFPrbr30xFFkOVhfYO4td+9yykeYaOBdWMF2OFpfykUNx+rVBPlWDfhsTEaCtI20ZBgiSu12YiwIFmckrWnd7ew6kfVa3h1xOYb80adQF372LoxuRctmfYFuVAb3G+q+RRuOtXgMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3oa2EviUFmp5ghRXeBgFeJB27NP4K3EpRwEmXN89hE=;
 b=d3qabR4u9zmk5UCZS2Kxz/RniZ1VwWwBLpqGbp4wxAcPS+GuhDhlAA8xkrcxRNqxU7VDdUgRKmsgb9T233K3aX4o5rkxQSOWlsHIOl2dsay/DnuD7vr2Wu3iQL1qqTVVW6uOYPjETZlrwOVFSj1t0mEtke8sG5LpHI6MK7bP13CIKUYeaugNeKexF0JAU1vy98F5Q3h5ln0HuhaHsCG17Dh12Trr4nnuA75A+I90xiSZqCefQ4nUm0GfgsY1CbRndbRg7VYigvI/Hn1hRmbfaeh+Dadlvy5b+L9SZRCydNGUkU27/hTTyn0Z9uSJ0Prs01TinvnU2h3U7uNUz6H9ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3oa2EviUFmp5ghRXeBgFeJB27NP4K3EpRwEmXN89hE=;
 b=PKfi9eS9r1p/GbLLVgMxeSF4JpTlmGdX6v/c3OwMAZzk9DrcelqX93TRgW4haotJMuP+/BtiowJNliClbKq790aL+O4MK0gUIRVu4MQiVI9MVBNQFioMsUW/usCBJGJA0oZwU6A9OeSbazjPd+wLg/zne93+MzLe9Gk+hAKYxpw=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2853.namprd11.prod.outlook.com (2603:10b6:a02:c8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 09:19:12 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e084:727e:9608:11c7]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e084:727e:9608:11c7%7]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 09:19:12 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "zhengyongjun3@huawei.com" <zhengyongjun3@huawei.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH v2 -next] intel: iwlwifi: use DEFINE_MUTEX() for mutex
 lock
Thread-Topic: [PATCH v2 -next] intel: iwlwifi: use DEFINE_MUTEX() for mutex
 lock
Thread-Index: AQHW2fgsO08Z+kgfzkCKBAAGEvRyiqqR1ziA
Date:   Tue, 23 Mar 2021 09:19:12 +0000
Message-ID: <d449f8be4d03811c58f90fef4070eca1db8da167.camel@intel.com>
References: <20201224132503.31397-1-zhengyongjun3@huawei.com>
In-Reply-To: <20201224132503.31397-1-zhengyongjun3@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.166]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 248ce83b-d87e-4814-bc9f-08d8eddcb8bc
x-ms-traffictypediagnostic: BYAPR11MB2853:
x-microsoft-antispam-prvs: <BYAPR11MB285348272A7862B6D4C61A2F90649@BYAPR11MB2853.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SVoFhxqfN2pDF/oo4lA2+Yuy4xAEVWG9L9PsXgzK1WNY7wfd4ZlsXyBzgmerJk0ZEOC/KGkmJ955SU/rJVPkZrpsi/zHjBNeXGloEIodTA+Se4LQxHMDdWsFBvcXoFonmERB8vlPFthXpRtensQMq72yKkGrXPBQpe0N1l/4FKetmOfvHL4c6dhnte3FiybHfIxxIm0pBlLgf9Te//MP2SXQidbRnwBYrhUN67MgJYqkmKqt17bTkztijcN1npU2WEYJT1+/pA56j2fE10ZkHAQ9iMtMfWLb+XtdMRFEsGvxeXiizocU7unmcGQNa7NykGIguc0jiJ/I+CgrRcEX8jyIE+bMGCtZOj8sf3gmhDfYrtzrf+xGSkV80R4hIej7fpI9zc4jrKe7u4et7383Q+N9eaWT4usHg3QlUrNaD+fcvdFK5QJ/jC/UYRDgmBcXe7j2rJLezAdiBr2jU9p6vbhZOJ4u2bhavlxzkFzc/iomibRYtwrRmqqFd3s+iBasq4t63phCTR5ZBPzfAcIf76JcYq8izB1ThAKvqR6h8RUvSfqLdib0QwrZ5vIT+eadLs5LjWvLHuZdl73n9lVE88aXUS4QlpN6F03l5aw3BBxCowdOVIU2ZQYN+sclGs/7jBdeZeYiuEzNdItUSzULvSxtd8R36/ecEx3U1Z0vqdM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(136003)(366004)(346002)(6506007)(6512007)(26005)(8676002)(86362001)(4001150100001)(110136005)(38100700001)(36756003)(316002)(186003)(76116006)(66476007)(5660300002)(83380400001)(478600001)(6486002)(8936002)(64756008)(2906002)(66446008)(66556008)(91956017)(66946007)(71200400001)(2616005)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S085aXVqaGE2RUxsWmp2dTFWTThRZjRTTjEzc3VqTmtzRHJHaFBJZWd5Q3Jl?=
 =?utf-8?B?YVMxaWFQU2huMHRhOWR2d21kZFEwQlJQVnFpL2pKVFZEZEZycEY3Y1d2L2xR?=
 =?utf-8?B?MmZyczFWQVRwV0RLeWJqcnMzc1ZWYk0yc2hMcmFJQUx5ZTMrMlRPMCszUk1Q?=
 =?utf-8?B?ZG53ODJjbDRYa2ZhbERWb1B5VWx1bjVGZHp1YkZrekVOcFlnRkRxeDF0Q3F2?=
 =?utf-8?B?bzl3V3ZBTmxJd2I5TnJtR2drVUhYSjZEV0J3aS9lYjByWUs0Y29QU0ZrclFD?=
 =?utf-8?B?cXE3RUFPUGl6bjU4TFRmak5BYTViL0xuUDN3M0NaOElHTFNpWE1JZmJ6Smxi?=
 =?utf-8?B?Qk9hMi96ZHpURVRCNGZPcTNUQUM3RUlLSS9nUnlUcmU3YzVJWklxSEVTRDdq?=
 =?utf-8?B?dFFXSHd4OGJqSG5DbU1jakRDbDZ4R3hWMFJBN1lOWWNxc2VHd1VYUm1aQ1Er?=
 =?utf-8?B?MFowMUc5K0ZRS1ZKTUJCTmhwM2ZsQmVRaVJPWkNESk1ZWXVHUVFaL2ZiQURE?=
 =?utf-8?B?NDVORFdjTEgvYWVuSDJMWm1NZ1llcmVNSXpMVkZBcUJkamhrdlczck5oZVIz?=
 =?utf-8?B?akZ2SHVOTjFDbnVHV1JMVkpnM3FUMy9YdFgydm5JNlFuamR1aWQ0dElWc2ZL?=
 =?utf-8?B?L2x3bVZMQ1lqTk4xQWtNemtrb0svNjlVMDY2SGFYYmlxT2V2NDZjVHQ4OTNs?=
 =?utf-8?B?Z21jSHhTZ2pBdlhXTW16Skt2SllvSHRSOHlRN3d1K241Q01aN0xLbGRCcC9E?=
 =?utf-8?B?MjR2SDF3RDhsZ2ZZN2xTR3c3bWswSVlwZjV3WndPYi9RNENIK2dXUyt5MjQv?=
 =?utf-8?B?U25UQndnbUZTNFIrRGZyL1ovS0hrTnlzSytoNE9iU3FvZFpLeVpUTXIrL2NI?=
 =?utf-8?B?UTJCU0ptaWx3dmFIelNlTnJ3eFhoZEdnb0VmemZYaHhHZFQxWDJ5WVRUdUJM?=
 =?utf-8?B?ZlhYZ05RQXJEV2xLYjRHSmdJZW45UVFQWitKdVNLZ2NhR1dsbklac1ozRVgv?=
 =?utf-8?B?TWtRYkNJdENVTjFTYy9icDk1ZFJyS0wwM28rZVZhZlZoS0JKd0lZQUExK1Ba?=
 =?utf-8?B?VDNJTFBvMEJHZE1HajVTM1VEWDUvUUYrZkNuSFkreHY5WkxIc1gyNS9TVVNJ?=
 =?utf-8?B?Qm45b084TDFnZVpkOW1nVGV6K0U0VEdTRUhYQ3d4bkJycWFWVm9XWEhXclh0?=
 =?utf-8?B?eGRDVkhGd3dTN0RlTzZ4WTI5V2tJZ3lQMmY3MlU4cmZwTXRCQ2Fic2lUeVdp?=
 =?utf-8?B?dHFHWmlnV1ozdVAya01KUU9GR0pXYzA2UU5xTnpHd2JpVVBrSWEwTXV5VnRL?=
 =?utf-8?B?cEZvTzAvUnhaU1ljb08zdEpvYjNOdVpZZjg2d2hMSDEwRnZLVVFYKzVPUHRz?=
 =?utf-8?B?bzBmRzAzWmpwNlhaeEcvdUlmbWFoVW8vTk95bkZ1T1htRGRuUzlhdHNFTllR?=
 =?utf-8?B?NEpNQjlqWnZnelN2RU8rbnpvZ1l1QS85VFFTZXAyMWVnNDdUamJsdkp2b0h2?=
 =?utf-8?B?Z1dhYjFKY0dEN3BXcWJDYnZrTHd3WSs5OGZMbWxSaHpNc1JUd2pzdDZtODRY?=
 =?utf-8?B?d2hKbUJKWTFJMlh3cDUxWHYxTzNHNWJ1b2oweVIvNVZJOUNRK0pNVUFTTjBm?=
 =?utf-8?B?eU8rS1hDMERUN1lDKy9XU2dqdTNHaGxKMDBwSjBNcGZidGQzWjhIQmZOd3VY?=
 =?utf-8?B?MEt6UVE4bExhZzF2YkVCcUczZUV5bVBCenJmRk1ISndkQm1nTGtIOVZNRlVV?=
 =?utf-8?B?MUJHVEpSY05QSnNWM3RVTEhWRTRwZmx4U2hCNGx0eGQrbElBYW1FZDRMTFp6?=
 =?utf-8?B?bmFZeE4reHpzeWxyWlRpZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <54E05D841CBB8B4EA96AC3FF8FBE31EB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248ce83b-d87e-4814-bc9f-08d8eddcb8bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 09:19:12.0130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8RpLa0Ka17qu0fztezq6cG3HNjPUVEYeNpI4ZLs7+M7yyz3XOaUqRoUu500rVS9ESGuUlATwcYsJwoJ/gcaAmrJrAfb2kCMqauQplUuQx2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2853
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEyLTI0IGF0IDIxOjI1ICswODAwLCBaaGVuZyBZb25nanVuIHdyb3RlOg0K
PiBtdXRleCBsb2NrIGNhbiBiZSBpbml0aWFsaXplZCBhdXRvbWF0aWNhbGx5IHdpdGggREVGSU5F
X01VVEVYKCkNCj4gcmF0aGVyIHRoYW4gZXhwbGljaXRseSBjYWxsaW5nIG11dGV4X2luaXQoKS4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IFpoZW5nIFlvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVhd2Vp
LmNvbT4NCj4gLS0tDQoNClRoYW5rcyEgSSBoYXZlIG5vdyBhcHBsaWVkIHRoaXMgaW50ZXJuYWxs
eSBhbmQgaXQgd2lsbCByZWFjaCB0aGUNCm1haW5saW5lIGZvbGxvd2luZyBvdXIgdXN1YWwgcHJv
Y2Vzcy4NCg0KLS0NCkNoZWVycywNCkx1Y2EuDQo=
