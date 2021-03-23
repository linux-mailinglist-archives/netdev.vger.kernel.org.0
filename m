Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B624345935
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCWICq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:02:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:37480 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhCWICM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 04:02:12 -0400
IronPort-SDR: 90CpUlLU66na1o/pQmwyNXxzQlYaIwGk8JiNO/1P9MbU+AnE3Od2RK+CHGxZ5j37BH9AK5ZQHm
 LNuhaZzV/n2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="187112243"
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="187112243"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 01:02:12 -0700
IronPort-SDR: H1qoimPwcuv+NmwAEx3WFFtkH3FNPUpT+5BToarUA1Jaihc9g8aHLLGMtgpRmSDVWudk4fs/jm
 36MLMABLMn5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,271,1610438400"; 
   d="scan'208";a="413308829"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 23 Mar 2021 01:02:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Mar 2021 01:02:11 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Mar 2021 01:02:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 23 Mar 2021 01:02:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 23 Mar 2021 01:02:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fp0VN7QQc+fHWO2VsoVVQlrnF/wOiZAI80DkIz3zlK5sexdQhQxx0fyws094KLxINQ6aWMfaCSqyXlrhKknu/WqFmH57XjXTl2HM0SnT3pStYa5odKrE1p4La6oVJIXRUwx+qTVcxCqSgsuAskDC+EStl8C2d41MHgRujL/6F8Qzfu1al7kEs1r86B5EyTmtKvV0LRHXa45oq0QbEc1+9vNX3YGmXD7LkogFkJZ9kIjCmuYQp4ugkNfObmqLfVf2NbxRILl8exz+KUZG4zomOxK8Kx2eo/sfpXgLWq/dGfCh6uuM220Wtezfd76UjKw5yh1gVDwNtZvP4uY4pLY9Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+ivGRZrlhCUhPjoZKx0/l+9+paKk8Kf8CAfXmYdYnU=;
 b=LQkiU3vQVZYdkt5GoIV6wx7/CUNLa4mIZltiio6qdh8QAARitMPAZ68RSpL2SlN4MQfpQsnvHOWmLelNWKfN3LFyYN3qRZgu9qgd7mg7W4fpMpr529sMuYO1siovZHMjO5T1a/+gDUIidsjmDIodU5y/VIMfSC49yQ5ycKw2JJ4azVn70mal+IIdAJRtJBIni/P1Sm2rTIdiHZcQRd1gPCDwvOseYT3ML79MoG1vzf4R0HoEmp37flMx0A3jv1mqN4QnjMC/FGuRKGxWEg7Mz52AulMoD4cqr+54SFue1e0KrjiyPDZWVh1Y6ufhDeEUKYdwwsJ+hb6JTgrLJSaizg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+ivGRZrlhCUhPjoZKx0/l+9+paKk8Kf8CAfXmYdYnU=;
 b=vW6Vv5OhfSr+hPEIacNMCw9ZPYq/H4LVmdeyMbcHHZj18s0gRb1v6wx9Xe0w3mTMXLlua2WIoIBbEP9CBvjPObq3j4NP7tWhAGVegwoJlG9HRxzHo6dFEDxFBGWgjP7ehJysEi/7fXFYwPmK1AI7iP5km0+B0ICc9KXFaS0Xsuc=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by SJ0PR11MB4927.namprd11.prod.outlook.com (2603:10b6:a03:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 08:02:08 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e084:727e:9608:11c7]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e084:727e:9608:11c7%7]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 08:02:08 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "Greenman, Gregory" <gregory.greenman@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hulkci@huawei.com" <hulkci@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH -next] iwlwifi: mvm: fix old-style static const
 declaration
Thread-Topic: [PATCH -next] iwlwifi: mvm: fix old-style static const
 declaration
Thread-Index: AQHXEN8mkU5CcrLIs0uuenLpPlTF26qRU+MA
Date:   Tue, 23 Mar 2021 08:02:08 +0000
Message-ID: <24b3bb205c11e68bcf7b5198ad859a073b34a958.camel@intel.com>
References: <20210304102245.274847-1-weiyongjun1@huawei.com>
In-Reply-To: <20210304102245.274847-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [91.156.6.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01f79389-0bb3-48cb-f3c4-08d8edd1f4d7
x-ms-traffictypediagnostic: SJ0PR11MB4927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB49275AB8FA829D8939BFEBB190649@SJ0PR11MB4927.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: USgIcVWqskRqevgIGTjHClAiYSGJPzRTdcAQWu7cbN0zqQXkPA5fiZzmfnJ6Hjkv/KsfPAmPwVdvbxcVCcUKTJjUzYIidemyXH8GkBC+E075vahHTG/e60M5dDPtmQhothV1mUcQoLQGe3Oe5SB17sRWzERVXK6kTiOywPHEHuW5ZYhkG29YFaeU/IMnvTtlismDt8hEO33vcRZyHBaAZh6zEaXJ24aNiGuVsPrAMI+nTFKvUz8a2Ge4rV8Z1AbwqlXm0s6nYZbYWow6L2CaGHU4VhOTV1nn8enoca7TqeqLA77fWTIgifI83BAj6A4kZWyq7KfG4INvSLl2jSdAZnohAxiR15SqSjgPjykwTV4AUEHcwRDnh3P4fOEV9KBHvOWONa4S1/cInL26JHC7RyGoiB0f5amPgOwMJlwEm92h5QfU++SvJ+cXKErn0lw/yjQ1ounyy8mnJFSIyZESXcmmMeW2cUed3peKRY3B9TQxYyXW92Z8edgxRt9t8igDNG06/yAFKlsXmf1Io1donytxW7+Tysc2k5fmUlRS/7orwolw3TQQOAak18a+LQ1+H5GMFKaxBDemD4NF1ukHR0q7NPcDoHaTsG8lkDkWbdMka/4J6OdlyIYD9MMkVVQqkjS2U00PC5yJcyVvuJl2gtD9s6QkX1qvHZqyJ2W3ar0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39860400002)(396003)(346002)(76116006)(478600001)(36756003)(4744005)(110136005)(5660300002)(6506007)(54906003)(6512007)(26005)(8676002)(91956017)(316002)(186003)(64756008)(2906002)(66476007)(6486002)(66446008)(8936002)(83380400001)(66946007)(4326008)(66556008)(71200400001)(2616005)(86362001)(38100700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?T3BrSzdFVDhNOG0xVVlrazZDdXFpdWpNR0JSNHkrUWdVSFpwWjNITkFoaEEw?=
 =?utf-8?B?anZ3cS9heHJEelMxR3ZyY0Z0SGVpOFllQ242QXVFVWt0bFNLS2tjUGxZMmFh?=
 =?utf-8?B?ZFA4eWpGQUZ6SWdKOGJVTy9JaDN6NzBlTmlXOTJLa0NnejZRSVJ3YTkvQ1F4?=
 =?utf-8?B?cFNMM2pHK0toWkdLYUUrSXRVY05NTldsaVJIOXJqLzVjTFBFZ2hXRmxudHBm?=
 =?utf-8?B?OTNldFEwTThnU3MzUkFxY0J2cDIrTDNRK3ZXbjNGaGtPYlFoZUd3a0tLQm1t?=
 =?utf-8?B?QjNUcWs1RUpLTHdudWVsTk1SbktRYUVGRGlwOE85QkhDdGhrNFdXTWpiYi9Z?=
 =?utf-8?B?eE4rNjJaVHMxeWkyTnYzcWd3U0d0Y0JDeldRdDFrVmExTHErZDV3YTcxL1RJ?=
 =?utf-8?B?TnVyQURnaFNZUUxLR1I4cFk5SjRwV042RXBHTURMYWlFS05acU9HMkdyVXp0?=
 =?utf-8?B?NU0vR3ErYTNRVEVwMWo4MGFKZnlhNDJzZWR0RmFCNktGQ29iL0pZaUh5eGF6?=
 =?utf-8?B?MlRCNnNhak5RclZ4c0hiOGExMzVSWGdqdWhpQ2NYaXRzdTkxbTBNclJxbUk5?=
 =?utf-8?B?MVdldnBQS1BKWElXQjU3MVJwdjhESHNUamlNbFV6VktGSEEvc2szcjZoSStO?=
 =?utf-8?B?eEtmV1h0c1R1RVhFcVV4VTJvelQrSlk1RVg3dENEYjEyMGVCTUxMOWhlMDl3?=
 =?utf-8?B?K2h0VXZ6MUpNUmlwWkNoMTZPTk5pMlhGSldUeUtnbCtRN1VkWjc0Ui9HcWJX?=
 =?utf-8?B?NHYzcnFDb0VvZWJtcUx2N1JycHZWRERiS0d1NVhjVEpuV3I5eWJrQzlYVDhn?=
 =?utf-8?B?RVBPeVJSNzhzMjk5YWVkTkNNdmg0czQxQmJ0cDhneUdVRnVKbUxsU09Ebm8y?=
 =?utf-8?B?ZngzVllMK3hCdEd1ZTJzRFc2Y09vZUNTNmpCNUZEMXNlMVdqK2NNSUE3RDU2?=
 =?utf-8?B?eTJyWUd4WXhGZ2RZV1p0SVVpMDRJZVRzZlFaN1RmQktwU1F1UDh3OS91L0p4?=
 =?utf-8?B?RlZCMENHV3BLSzBPaklGOWdJcU1pbWVBMFNFempvRnZ6ZFFSNVI2aE9SbkRj?=
 =?utf-8?B?elNjWEdCVmhnb0NDR2RBelVlNGRaeU5mRm1OL0NwNTljR0lNcUFTRUQrUTBR?=
 =?utf-8?B?UDZqcnBaOHpLUlN1dGNseFpLTVFEbUQweGY3RjF6endudjRuWFptTFhLdHZy?=
 =?utf-8?B?OEpyaVpEZ3JBanl2RmhlVTlVS0FFbW9tTWNkdnduNFRHcko4SUExWm0zS09h?=
 =?utf-8?B?YWZOYkVxSjgwWEdvZ0UrQ20rVDdxeUxsTm5GT1RKVjRxRVJTMHQzcTA4aXhY?=
 =?utf-8?B?dCtiZFIvc3ZkMlVGOXdwZStxekN5WnRtSWRCa3laY0gwbm5GOFk5bEVTT2I1?=
 =?utf-8?B?RTFvNGlsUlVZTFJ4bzEwWk5rMTI2Y3lpYzFsSFhaOWJLaUZObkx1Nit5QjJN?=
 =?utf-8?B?MXhGWWd5WTJQaGwzUkljY3JXYW1pZ2pnRk1kNUxtdXRkRHNqV3U1ZG1EazNW?=
 =?utf-8?B?Zkg1VHg5N2NibGxjS2lyMFlzUUM1ZGppZVFBTkVzemJLWmN1TUl4NEFQbVpN?=
 =?utf-8?B?VTdTMjd2MUtrdUFROFlWWU9NVVBwdTloaTRNMFcveXdkcnpuMVJyMjl0cEp3?=
 =?utf-8?B?Y0QvTHBkL0l5azQ5eUpSek9jOGV3WTNBNitKdEFUVFpIYnZlTFZCVFhIaVVr?=
 =?utf-8?B?R2J3L0dnY0FuTUF1RFhnVWNZYjRuUUx0dU9JNXcrV2tjYXBOVnhHY1dUT2Rz?=
 =?utf-8?Q?BFCb5CUrUuZdM9BTjsS8BbscnE3KZfkyj0UtaF/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21DBEC4C541C8A4DB6CCE60229E2A8D3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f79389-0bb3-48cb-f3c4-08d8edd1f4d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 08:02:08.3397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8fgWr2N4/Q+fs95cacEJ6lEeV/NCa/Ibcursr3FgxPs9hHsq/bwI8eimusQPt+JoxDQ7nsxI726IPbjS16KeUivsX5FZ6qbaUj2sS0GlPKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4927
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTAzLTA0IGF0IDEwOjIyICswMDAwLCAnV2VpIFlvbmdqdW4gd3JvdGU6DQo+
IEZyb206IFdlaSBZb25nanVuIDx3ZWl5b25nanVuMUBodWF3ZWkuY29tPg0KPiANCj4gR0NDIHJl
cG9ydHMgd2FybmluZyBhcyBmb2xsb3dzOg0KPiANCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50
ZWwvaXdsd2lmaS9tdm0vcmZpLmM6MTQ6MTogd2FybmluZzoNCj4gwqAnc3RhdGljJyBpcyBub3Qg
YXQgYmVnaW5uaW5nIG9mIGRlY2xhcmF0aW9uIFstV29sZC1zdHlsZS1kZWNsYXJhdGlvbl0NCj4g
wqDCoMKgMTQgfCBjb25zdCBzdGF0aWMgc3RydWN0IGl3bF9yZmlfbHV0X2VudHJ5IGl3bF9yZmlf
dGFibGVbSVdMX1JGSV9MVVRfU0laRV0gPSB7DQo+IMKgwqDCoMKgwqDCoHwgXn5+fn4NCj4gDQo+
IE1vdmUgc3RhdGljIHRvIHRoZSBiZWdpbm5pbmcgb2YgZGVjbGFyYXRpb24uDQo+IA0KPiBGaXhl
czogMjEyNTQ5MDhjYmU5ICgiaXdsd2lmaTogbXZtOiBhZGQgUkZJLU0gc3VwcG9ydCIpDQo+IFJl
cG9ydGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogV2VpIFlvbmdqdW4gPHdlaXlvbmdqdW4xQGh1YXdlaS5jb20+DQo+IC0tLQ0KDQpUaGFua3Ms
IEkgYXBwbGllZCB0aGlzIHRvIG91ciBpbnRlcm5hbCB0cmVlIGFuZCBpdCB3aWxsIHJlYWNoIHRo
ZQ0KbWFpbmxpbmUgZm9sbG93aW5nIG91ciB1c3VhbCBwcm9jZXNzLg0KDQotLQ0KQ2hlZXJzLA0K
THVjYS4NCg==
