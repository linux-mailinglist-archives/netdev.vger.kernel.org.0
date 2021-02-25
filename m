Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199F63249F2
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 06:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhBYFIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 00:08:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:9410 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBYFIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 00:08:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614229698; x=1645765698;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rfSrZD1RjqZpCx1q1hGd2HVLMYsNOUBqgGCbxJr8c54=;
  b=x6cbL9F0KrIklBP3WEzCu8c7is6VkllRO/Un9CvsY/Ww2YICJ+rgMG0V
   l4Dfen2bPp8nrUhjLfYpXDi+DsPaxYHcNqawDHhpsnD0x8g3okZf63no2
   I5d5bRlz+Gt2sRlvypLaoUXhCV9g14Jv8QOgkEI60AciPIwzqUp0AO4SJ
   NjZoiEsqtznwNnBkw4yBfexocG1dav6ffiQheZ45A5YjmvwEVD1o5+cOJ
   geLH3O421fK6iun4sY7lhWoEOkwx/8dFJ6sKHx9Wq+jWHELHU8SQeQIGu
   pu7cVDB1yNFTiu1ZhUo4PyoS1AD7Lg7vFM9+XO9TxUeKEAm2B4doQp0/H
   g==;
IronPort-SDR: yo2+FMjRb3vdez+RBHusuLl70V55J7XIV506fs4tAGZs5AYY+bNg8gFHqDpDbx5q/x3/rDxKQ9
 34Ryw8tdMQofth0axCxPelxhnBBaPPlvvQSXBeeWt1UvJzzoiRYSxbiYuqnGOJ8rHDOADPr4t9
 lmRVhLYWJhKlfCf8xl7fYo9NUbplFG5V6K+hdLzfJLW6XlRR57nx0e6EcYZmLpbWUTRgeBLkAV
 HpW1Mv38V0UvxViwN1KY8ecaWZaC9G6zyBrtepdh/IAwN20AYX0UNlox/sW1caqBw00a+FxdjO
 VeY=
X-IronPort-AV: E=Sophos;i="5.81,203,1610434800"; 
   d="scan'208";a="45386784"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2021 22:07:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 22:07:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Feb 2021 22:07:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjRMitz6JTVvTlzV2rN3+7OnCaKSHhj2zRqgyw6tejV7h/5AJSrfQO4yPe/aTpLyITjLAFqOQW5+udGnfwB40irESsXUQb5xirFJZOjjR2AdyB0u20bYmjeUVx3ztUJj93bi8Dlq7WYIuHzwwn4pg15Z7tUzH8FYPyCVOXPTYlFGwMxIQP2BjrkZoIw4/Hsjkrh1t+dG1H7Bzw482Z200BikIqPskbBIo7PwCnqyS3QSORIHLmBGBEodSbbzYw5Hds+VCzsU7Nc8FW6sDrhN6o4blGA3vGso3ygNJ5UT3JNernGVjUrMD5n+fIhj6fsPXAdLeV3s8VeW3vkBuQQS1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfSrZD1RjqZpCx1q1hGd2HVLMYsNOUBqgGCbxJr8c54=;
 b=eKl3D+g/g2N185S0UeNs2g2Sf9maxEHmKgbKCJLs33RYCHfnfMjraay5VHMRL2mUnazn1846p5NTtb2PctuAbjPOuZvXA7VehtAW60z9hnI2QL9g9cd6o8pl6xyFbBX8mQlAjNVY7VmG+fF8MVrzxkFmk7wqhmxxKhEmiPkXX0sCklV1xqtEivVguo+xh877tXubEvSQxZ9g59AbjuSms29uLCbyWRou9WWFT1Nm3KR0yG8BL9dAy96DRNoqspkPJxsTge4Wog+uW/FA5wcyq4vWHVMBc30c0eekAOvxIGLsmGrCXqcCPNr+40b8jjehnnhR5wp2echJTCdlAFLPzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfSrZD1RjqZpCx1q1hGd2HVLMYsNOUBqgGCbxJr8c54=;
 b=KyQR7MMqHohJ4D1r3qOTjlpplLypw5BMuAtsuoVsJukS2NUH1urqlku4D6MVuYAOXuoPubM73aNNj4hWZ56PUx+N1ArY13DV9CspJTIcnQ+n4ITFpFI2gdnmrrGZQ1/dCl/jFfYoZs8QJTouq0pmmHajcpDnVHXuDvECn5C4+qI=
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com (2603:10b6:a03:2ad::17)
 by BY5PR11MB3992.namprd11.prod.outlook.com (2603:10b6:a03:188::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 25 Feb
 2021 05:06:59 +0000
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::6c3c:2ae0:c40b:6082]) by SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::6c3c:2ae0:c40b:6082%3]) with mapi id 15.20.3868.034; Thu, 25 Feb 2021
 05:06:59 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <kvalo@codeaurora.org>, <marcus.folkesson@gmail.com>
CC:     <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wilc1000: write value to WILC_INTR2_ENABLE register
Thread-Topic: [PATCH] wilc1000: write value to WILC_INTR2_ENABLE register
Thread-Index: AQHXCssQF24Y+pKk20ak6ACLVCsmeqpngwDcgADPfoA=
Date:   Thu, 25 Feb 2021 05:06:59 +0000
Message-ID: <1b8270b5-047e-568e-8546-732bac6f9b0f@microchip.com>
References: <20210224163706.519658-1-marcus.folkesson@gmail.com>
 <87pn0pfmb4.fsf@codeaurora.org>
In-Reply-To: <87pn0pfmb4.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [106.51.110.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75a0e206-77ef-4970-3557-08d8d94b2e11
x-ms-traffictypediagnostic: BY5PR11MB3992:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB39921C64F12226414E1E9D3CE39E9@BY5PR11MB3992.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:241;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2zppvzf2sJbRf41sQAA6y3Ytj5MxuyUCxySn/7RK3FBF/iYcZOZEwbtQfvXlB5en/4zNR630OW30qpVYQrLyhTQAu9MhOr1T7AK85mU/XXV7Da0AMv01HEPf9jFPAsqjuD6AzbUWvIazZQr6+brYeJy5MsucSlYCravA5XxXf+ZJ+WpfRqE2640LUkfFcoxfmR1QneV54uFsnhxqgEVBNItjgIWW+OQVxiEFHsbN/gU9pWN/dXePCj3hnYDgchKtBl5IJwlSw4ADbHOi0hEU/cCul2Imqgf7EdH8Wvd9Lb0xs3yc4/u4A1mp6KEgf0KHonz/lgOzyk/7mH5QtJmZ8YFVHUqyJVt6LpYsajfCmMK0G0XHK7JrbfglXzXrFEwg8KdVsPBWdWxbfQEC0GHBB75QWwahTwa53lT/ZhVedueUX3Q6SWJOpKMEglj5sEfC0lz9qyutpOOUbweouF8kF9j3lv4wnKucv+raNxTPTEFaI3TlhGVCn9O6D26nnWk9CA/eGU1iOcVhRs3eH2FeZLgltMYjCz90asm0iWy0aLRtPn3/EiTqUxxXUJ0knBKAsEYYB853vFI8KNM0HFjSvMEG9+y1py2RhN5EBpwQSzAD9yWGclQy2AZNvPaUak9s0XlnzsNXjeHIMQ7cN1lxYd6KENgpRfQ5qev7gi35z2Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4943.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(346002)(136003)(39860400002)(53546011)(2906002)(31686004)(36756003)(55236004)(31696002)(71200400001)(26005)(6512007)(86362001)(186003)(6486002)(6506007)(316002)(91956017)(478600001)(8676002)(4326008)(2616005)(76116006)(66946007)(66556008)(110136005)(83380400001)(64756008)(966005)(8936002)(66476007)(66446008)(5660300002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cGxlU2NBQXgrbGhlN1RkQ3BZamlkT1A0WjVMVmc0cWpvMXpwZlh2NlUwak5G?=
 =?utf-8?B?UTBtVEpLMEJKYkVwb2NBcXNXckhwd3FqQUw3RnM3aE1TSzBkL2FGV2grQy9t?=
 =?utf-8?B?R0Uwc1gzbWloK0V3TG1mdFQxVjcrT2VzVEt3NmpRSDZzdk13RDFFNFdMRnI2?=
 =?utf-8?B?MlVOV3FNR0pRSnMxak1lQmNQOTNGVHE2dVZnaDRQWXV3bmxkVFljYklOVkpk?=
 =?utf-8?B?RHBxQndqVXBuUFJWSU16SzRTeEhCZHlBRTlCeWQ3NkxlRUZyNHNIYWQyQ0lt?=
 =?utf-8?B?NzV5Wk5jMlNHQW4yM0pxc21neE1FSlRKd3RWU3JwWTM0WXdUaExnMnhaN0V1?=
 =?utf-8?B?eWVwMGQxMFBBMXBYdkZwM1RITVJtMy8wd0lOMGtZaXdOZk1hd2pFQ1gyNHk0?=
 =?utf-8?B?SUJMb00vNXduWlJlZWh4M3VTVStNZ2dydC92NG8xQ1lRL1NyZXhtdFZiSlRO?=
 =?utf-8?B?UmJsUUt5bFgvNzlpMUtQQkRTZW9pRDlhR29EblZtL2ZvTWlERVROZC85Wkhk?=
 =?utf-8?B?bHlHOU5hOTc2dHJGQ1VLWjcxMG9BWWdWenpyRkduR3lrdWVPUEc3ZXZ5ZTdD?=
 =?utf-8?B?VW10eDJvVHJuOFNUb0FHQWZXTitVZ2JVYkZrWjA4c1A3OXBsbjMyN2RyeGNT?=
 =?utf-8?B?RUF0OUVzWXVKVW51Z1VuNWxNL2FqaGZXUWRBRzJiWVIwQU5DRW9rSGZ3STR5?=
 =?utf-8?B?RHhYMXdPZVFmQ2tTSzQ3bk9GSDdVcWdyMndUMTdTWTFFWlAra01TS01UeTZ5?=
 =?utf-8?B?SkRNMG9SaksyWkRBNU11WTRPTDFaVlptNTBTT1VMbnFQWnozdjNENVRMek9y?=
 =?utf-8?B?ZmFxRzFjNnZIa2xhUTRheUpKTGFuc1o1cS9hdlVWZmZDMnF1YnVHMVkwNThu?=
 =?utf-8?B?cWtMTzNuMHA5bzhXVm1uU2VrY2xpdks0QndhSHNZYkNjOFFodXZBVTJQZGVj?=
 =?utf-8?B?SWdnNWc3YXFVSHc1cGtqNDlqSUY4Z0hleUE4NVJGVzltcTJORHE2WDNNV0Fz?=
 =?utf-8?B?TFArelJnbWxOMXRWc0ExQjdlZ1dlNUtzT0kyUXdUSUZYSWtoN2xIeDFRRlVh?=
 =?utf-8?B?UVJNbHBTVEVpRG5lSE1hRTZWMURBeEdoOUs4OC9vODVXdFd6Nm0vMWcxZlpU?=
 =?utf-8?B?NGo4NEt3RmtMWDRLZUM5ZmJTV3RFZHBZb3NhRkVndzQwNGFPc2Y4MTRQUG1h?=
 =?utf-8?B?SU5ZaWFrYXdtS3JwdHhkVHVFbm1KN2tTNHIvb0IyTEY3YllJNEQwL2thYmhQ?=
 =?utf-8?B?MHo1VU0rVXF5N1ptdFBSV0tCMm5xb0RsTkZQQm1QNUNpNkxRam1TNVVJUG1h?=
 =?utf-8?B?UmY5WWNJZUthS0NRZEN1ZjM4VURkTHJlR1F6NjJSWm82SGpTTjU2RmJQRFRQ?=
 =?utf-8?B?QllKeU9BczRFbWVWdGI5UktwdVgrWmt0TTVmbjVTaDVQUUFXRjl5UC9aRWVi?=
 =?utf-8?B?VDlJa0E3Z21qUm1ud3dJUm8rbjlwV29OU2hOQWpNU2czcDBMbnF5dDVKSXpQ?=
 =?utf-8?B?WHFBSVRsNkVWMUpSNWNhUkdvQ1ZuQVhNL3UxMjVyQlpnUE54cVpxak9qbEpa?=
 =?utf-8?B?RXMwNWRvS1ZIcGZvNHVPdmVCTU9BVlpTUHVVT3lsOEVkUkxRWXNOYkJZOTZu?=
 =?utf-8?B?OVZYSk93WWhTSkp6ajlvdVFwa2RScDJtZjZaaVViWWJBR3VBUTVkTFFQRmxQ?=
 =?utf-8?B?QmV2V3FYVXlwV2llMk9qSURXRWdYSHFUUHpvd3d2V1FrRmxwVmkzZXkyWkIz?=
 =?utf-8?Q?uTbtRlwa8+l373FbTEtCwjSW1vSuil8GaxE7CoR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7ED7A84E5E8A74697E42B30DA4EF0A9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4943.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a0e206-77ef-4970-3557-08d8d94b2e11
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 05:06:59.0504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rGL0dyoVEagQKXAS3mHBxurzuLQvqLeyLUJADy0C6ZPiIBR/HmvYbTdkTKq1D228VQGK0Bw6XcGyoEWooyxLdBbYJal2MShv/bMZM4HaWBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3992
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDI0LzAyLzIxIDEwOjEzIHBtLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBFWFRFUk5BTCBF
TUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE1hcmN1cyBGb2xrZXNzb24gPG1hcmN1cy5m
b2xrZXNzb25AZ21haWwuY29tPiB3cml0ZXM6DQo+IA0KPj4gV3JpdGUgdGhlIHZhbHVlIGluc3Rl
YWQgb2YgcmVhZGluZyBpdCB0d2ljZS4NCj4+DQo+PiBGaXhlczogNWU2M2E1OTg0NDFhICgic3Rh
Z2luZzogd2lsYzEwMDA6IGFkZGVkICd3aWxjXycgcHJlZml4IGZvciBmdW5jdGlvbiBpbiB3aWxj
X3NkaW8uYyBmaWxlIikNCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjdXMgRm9sa2Vzc29uIDxt
YXJjdXMuZm9sa2Vzc29uQGdtYWlsLmNvbT4NCj4+IC0tLQ0KPj4gIGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL21pY3JvY2hpcC93aWxjMTAwMC9zZGlvLmMgfCAyICstDQo+PiAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9zZGlvLmMgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9taWNyb2NoaXAvd2lsYzEwMDAvc2Rpby5jDQo+PiBpbmRleCAzNTFmZjkwOWFiMWMu
LmUxNGI5ZmMyYzY3YSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3Jv
Y2hpcC93aWxjMTAwMC9zZGlvLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3Jv
Y2hpcC93aWxjMTAwMC9zZGlvLmMNCj4+IEBAIC05NDcsNyArOTQ3LDcgQEAgc3RhdGljIGludCB3
aWxjX3NkaW9fc3luY19leHQoc3RydWN0IHdpbGMgKndpbGMsIGludCBuaW50KQ0KPj4gICAgICAg
ICAgICAgICAgICAgICAgIGZvciAoaSA9IDA7IChpIDwgMykgJiYgKG5pbnQgPiAwKTsgaSsrLCBu
aW50LS0pDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZWcgfD0gQklUKGkpOw0K
Pj4NCj4+IC0gICAgICAgICAgICAgICAgICAgICByZXQgPSB3aWxjX3NkaW9fcmVhZF9yZWcod2ls
YywgV0lMQ19JTlRSMl9FTkFCTEUsICZyZWcpOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgIHJl
dCA9IHdpbGNfc2Rpb193cml0ZV9yZWcod2lsYywgV0lMQ19JTlRSMl9FTkFCTEUsIHJlZyk7DQo+
IA0KPiBUbyBtZSBpdCBsb29rcyBsaWtlIHRoZSBidWcgZXhpc3RlZCBiZWZvcmUgY29tbWl0IDVl
NjNhNTk4NDQxYToNCg0KDQpZZXMsIHlvdSBhcmUgY29ycmVjdC4gVGhlIGJ1ZyBleGlzdGVkIGZy
b20gY29tbWl0IGM1Yzc3YmExOGVhNjoNCg0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9saW51cy9j
NWM3N2JhMThlYTYNCg0KUmVnYXJkcywNCkFqYXkNCg0KPiANCj4gLSAgICAgICAgICAgICAgICAg
ICAgICAgcmV0ID0gc2Rpb19yZWFkX3JlZyh3aWxjLCBXSUxDX0lOVFIyX0VOQUJMRSwgJnJlZyk7
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IHdpbGNfc2Rpb19yZWFkX3JlZyh3aWxj
LCBXSUxDX0lOVFIyX0VOQUJMRSwgJnJlZyk7DQo+IA0KPiBodHRwczovL2dpdC5rZXJuZWwub3Jn
L2xpbnVzLzVlNjNhNTk4NDQxYQ0KPiANCj4gLS0NCj4gaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVs
Lm9yZy9wcm9qZWN0L2xpbnV4LXdpcmVsZXNzL2xpc3QvDQo+IA0KPiBodHRwczovL3dpcmVsZXNz
Lndpa2kua2VybmVsLm9yZy9lbi9kZXZlbG9wZXJzL2RvY3VtZW50YXRpb24vc3VibWl0dGluZ3Bh
dGNoZXMNCj4gDQo=
