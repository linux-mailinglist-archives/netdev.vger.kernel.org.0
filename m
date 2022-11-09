Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FFC622A59
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiKILYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKILYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:24:00 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B56FBC3A;
        Wed,  9 Nov 2022 03:23:52 -0800 (PST)
X-UUID: 359f2d03ce6746fc97caac5af7cd6bd4-20221109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=a9Q0ouQo0Nb+YUQ4fvu5Tced7Z0Q4yGZfHQCHINJpu4=;
        b=fH2orU2fRQowpGxv2hmbqeImO93dFIhcRY6gwZJIeBNiXwG35MqcGf+5XJf7kEOVKDBzP6typLeeeUYo+jQh31tRCbmtvJgQ+/4PVR/oiKA4ZhO5QU6Ck8wnosHMHCa8tz4b5T8j7/wIpOvfD0aLw+VEx14sc/6pzsfyglGDhSw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:bfe8d69e-7777-451f-8d4f-476235eb475e,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:1
X-CID-INFO: VERSION:1.1.12,REQID:bfe8d69e-7777-451f-8d4f-476235eb475e,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:re
        lease,TS:1
X-CID-META: VersionHash:62cd327,CLOUDID:f7f4105d-100c-4555-952b-a62c895efded,B
        ulkID:221108201457XADBHS14,BulkQuantity:15,Recheck:0,SF:17|19|102,TC:nil,C
        ontent:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: 359f2d03ce6746fc97caac5af7cd6bd4-20221109
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1656760558; Wed, 09 Nov 2022 19:23:46 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 9 Nov 2022 19:23:45 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 9 Nov 2022 19:23:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8RzwhxHVHdgk8sFHuID696vc63XTJJJkTxj53oH//cMJihLzUmUCxlsXqaw8Im8aYbT7T9JoPxvBFMdyuxVT1EQSh57XrQ5ZlN43VFZy1BA5HxChv3/UR6SQm/LQ8780SnrumiOvh3m6C3dklJfQkQ/e89LvbRu2sypIPFGZ856cLcog2NmVBlwplFqPhr6JxDU+sNRvLS0qmXWnnK/+mZM8Q/1dUH0Dtqhgy6JDI7cXO13OrtS2iZiwUUpmV0mWGZ9suC1Euw/qsKc/YVDrSl9EGtNgO46FcSj4t0lC4B4pD0s9o3BU6pszXARVtxOcX7ktHKVy9Zg32ioAW1wuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9Q0ouQo0Nb+YUQ4fvu5Tced7Z0Q4yGZfHQCHINJpu4=;
 b=Vnm7srNlZ1Zl37g8HzIs7/w/MjWvgsZ4VH2dwO4i1/NtCsr6CLj6xujyI3LNs66bkwn8U2MmTJOQk0/vfzMS78hk9DiVi1d908LJ9aHA+j/IuQVe2lDwngi8hjKji9tcjVe9WgV91wJfP8wFv3mKM0MDkymGErWERmCDK86hhSgm9Ohmfk/NRgqR5MqdyfQlZVHV+6NgpuQElfgawt8qBJgygWmDP7RkiKCSBcmzBNVXFgRcHeJBWRbG+aEvJ5/x11KDD8P8ruLTGumvyM7CQgb76E5Cycm9qqLo+BEZmLdji9IrvPMqykieAmblRu8WY4i6F7VcsFK6z7x8gKl1Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9Q0ouQo0Nb+YUQ4fvu5Tced7Z0Q4yGZfHQCHINJpu4=;
 b=oStdv8X78nnUaiEl02XcvU1hUeq3CCeyUs3Q/e94cv4mhtyPFs/Qj/SgTSPgbp/uSrhr5i3zXjCCeQ9m3FTNQeIzLbxr8G5+s4tJyVfV4ku32SYzzYCX41fVWcwfDrBnBWCbz0TxF5bbAiMnmXQZ4LL8hsI6SvEI7OQYDf664fc=
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com (2603:1096:301:8f::9)
 by KL1PR03MB6227.apcprd03.prod.outlook.com (2603:1096:820:8d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 11:23:43 +0000
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::4682:d6f1:6744:aca6]) by PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::4682:d6f1:6744:aca6%8]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 11:23:43 +0000
From:   =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>
To:     "loic.poulain@linaro.org" <loic.poulain@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@linux.intel.com" <m.chetan.kumar@linux.intel.com>,
        =?utf-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        =?utf-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        =?utf-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>
Subject: Re: [PATCH v2] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Thread-Topic: [PATCH v2] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Thread-Index: AQHY82BiULbE5nz7Gk6Q7QYIdzjjaq408HwAgAGENQA=
Date:   Wed, 9 Nov 2022 11:23:43 +0000
Message-ID: <8406210223bd8dcbf6682082570f791a6088104c.camel@mediatek.com>
References: <20221108105352.89801-1-haozhe.chang@mediatek.com>
         <CAMZdPi96dZV0J_6U-mH5eCquWycSQLPvoz6JX1BHWn0eQJyeDA@mail.gmail.com>
In-Reply-To: <CAMZdPi96dZV0J_6U-mH5eCquWycSQLPvoz6JX1BHWn0eQJyeDA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5653:EE_|KL1PR03MB6227:EE_
x-ms-office365-filtering-correlation-id: a69b5c77-da41-4329-ba94-08dac244dc36
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JRRsb8IUzmJK01vFoJkC4+lIYgyHjDVxJXhQ7UsUTnvVKvxcbeU5wLwv+f7th8u1w7siNxUvc2/iSLe1XBRcSrnnbMIPbQdhlEq9KAwWdjX13FePiIYvXZcYe4THkQatJqWmYIYsQi5N/7FGDogxHYoIh5RQVR2LRZvgwsD+NQr5DWQKbZOHpTqgu2dMvnM5t7VVX0S97RgC8u1oTIdrw6+Wvf3p5mRNJfui7qlla3nKpXru8h3vDhJQftg7qQ3Cc7VL3HoW9tHr8n9uxuoaIEwX38DtjCK6HbLc6/hKBdjLbe9UouIEBSkFHJRPwrEwylswVbfAqEFbCwjuZmyYLZ6tgglZArARHfH5owE9YA84LeUWS5wvlfdFY07IaSmBpHuqyRK+fwBtjzZGQ7D3p1Y7ZRfLq1HcJqXc0pM2GlDWZV6friSQmmg+gPIBnA9Nwx6t8V7FIAKY1ew1Eb+hNpt9IwDDYf0O2glxk536cs/+ykzHwArQhQJ6Ac/HglC1k0cZ/rw+zAbFab7kWuqwf3zQB3c9Gbx04V3EkwjfFpXFH1gT/yHVwufD9JptyJ2lqwZklDvHXT+hwErUU4pWu3tLoAcRwkLqxsEOncF5iiIwK2nPQ8GvJX4nUG8jgf5iHCp7ZkkJAJGcindSPyvY5yirN96dig/wIwNgdCeCel9ssqRA1sxiUmiOC2O5gAgDuRO1S2Qq07CCfB43bIE6HtNhqqAtvQyT5Ta6Gml1ZzO/vxmOhoHOUfuapPnhEJ2API7aR/glOd+jPENMzaJDS6MtIhVzSjAZd1lWy//FWX8gs6vMv11Hkawu/mLfLZBOnlCMKS5p6mbm/RopxgBvVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5653.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199015)(85182001)(36756003)(7416002)(38100700002)(107886003)(26005)(6512007)(478600001)(86362001)(2906002)(38070700005)(122000001)(186003)(76116006)(8936002)(5660300002)(316002)(8676002)(6486002)(6506007)(6916009)(2616005)(41300700001)(54906003)(4326008)(83380400001)(71200400001)(66946007)(91956017)(66556008)(66446008)(66476007)(64756008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVV2VStPVXI2eDBlSlZ3R1k4VTlLMnd5SldOVFNXRVNTQXlMNUpiUkJONnl5?=
 =?utf-8?B?NVJqNUN0TkQ4QS9aNlZDcGlwWVNuWFc5UmZ6bFBESldNZDhjZlJoa3JkaW8v?=
 =?utf-8?B?aFNHRWpyZ1VhREw3OU1pWmtCTEtvMWtIb2dTK2JycXJ1RHUrOWNqZENwZ3pt?=
 =?utf-8?B?UXRuN0kvR0hXdWJqWktyRitqZUZ2TkhveFBMQTgxREpVZ2RDOFp4R2d2NHFT?=
 =?utf-8?B?OTcrRDkvNklVa05MOFhwNWJRQzhlcG92N0NSK0JQQ2xITGxsOVVTQmxFUE52?=
 =?utf-8?B?a2VZVVpVVFAzUGVrVXFGSmU2Rm9QUmxobjF2eExPUVlGdVBDV0V3eE01MmNP?=
 =?utf-8?B?ZkJvT0RUeUQ1Qy96d2l4SjV5bjFqTVBtdjdnaTlsTnRDbHgxTHJvTE0wTmJ6?=
 =?utf-8?B?VFJJakpMZHdjNmRkeXcvNnkwUUlJZ0plNkR2OEd2Ykw4eHpjeTdrQUpMSER3?=
 =?utf-8?B?TjRKbm9iZU11aFBsVHJtQ21idVZnZDF1emlXNXJNQnp5dmtkYlNNa1A4c01Y?=
 =?utf-8?B?VFdVVDBVTzNYa3ZlVmk2QUlrZXp0QXFBRW9waERpa1U5L2dkYWF1aFliTm5r?=
 =?utf-8?B?NDhHRncrSWN0d3I5aHZ6NzJWOURaMFA0ZHJGbGwxZG9FN29jZ0Z4MEI1UGNn?=
 =?utf-8?B?cGl1ZVlxRDVlUGFsaEJDa1dkWTNZYkRkdTFQd25mSEFNN3RWTnVTOHlQdzFZ?=
 =?utf-8?B?OXFBMndrN2hTS0hvc04wQ1l1bE14NTVHa3BsSm5nRGFVN3FkYkgybGgrd0V3?=
 =?utf-8?B?ZzJPRkhPS1hFb2NCTFdiSUsyYUh5RGdpM2d6MVRtK0VkQk82VzJBSUVTZi9a?=
 =?utf-8?B?eHErZUNiZXhTQTFzOEJSc3R0MVpqcXE5QlI2R0d2T1VjT0traS9jZldkaVpr?=
 =?utf-8?B?ODMrUmoxSW5QanB1cmRmYVBzNzJtMnhSbWFyeVlPT0p0VEhpc05HRXRWL0Zh?=
 =?utf-8?B?WVo5WmJFMTVoRUF6Q1NOQVdlNS9QUjRXY0R1NnRXZ0RwV3czQThMVldUNjZL?=
 =?utf-8?B?SkdldU1OK240OEdEZGJFdDV1NmlJdU9RREd0NVc0VzRLMU93dHhJUElIY2FR?=
 =?utf-8?B?b0F3WWhPWmhvVEo0RjdiaVNyVVdlVjF0UklsM1ZwRDBHSE5ERTZ6QlgxZ1NN?=
 =?utf-8?B?dWFIdTF0L1RrTytKUlMrMWd0eGpPN0ZHbWpSY3kyd1AwRHpnUkkyLzhLWEFK?=
 =?utf-8?B?YlFlNElmMk02STNrR200dFN1QmhwcTRyWFh5TmRWUTQ5c1h4d01lRmZZU2k5?=
 =?utf-8?B?U2xlVUZxTjZibDJmejB1bU1hbnA2cFlNSWpnQ0FJem5DbDNuU2d3U3hwYUlv?=
 =?utf-8?B?R3VzL3FRN3NYN2pEdjJ1cmU2UWNaNEYvQTRZRnZEQ1VHSVZoRllFZmYwcDEv?=
 =?utf-8?B?Y3ZuRFdBVHFuRFREazdNc3lvNmVsZHFUUVFFTHVCcEIyRFd5S0tBakd2c0FI?=
 =?utf-8?B?Ny9ua3ZHWkNYdi94RnpwMUV5WWpZaCt0Y3B1Q01EVnJzUGw0NzV4NHBNZ2lj?=
 =?utf-8?B?dlcvd3V2ejkvKzBhWWpHaGtIQjJGUVFlYU5leG5QTkpta1BJcDRJZ2VUcWtZ?=
 =?utf-8?B?ZGlNYXUwcFU4aUFCV2ZRNG8xRUs3d0dvRHJIZ0tvQms3dllUcG5YUCt2R0xs?=
 =?utf-8?B?T2VRWHEzT1NVK1NCVGh1dU5WUjFEVjBsTWxXMnorbHd1dW5xeUNaUlFlRnM0?=
 =?utf-8?B?VXEvQ2J3ckduUUdEc0FiTjYrRENVUUQ1d0M4TzhhTzkzam9xaEpxaDJBVXVj?=
 =?utf-8?B?VnUyaEJZcUlMS3NRY0x3VFV3RE5EYWhqT3R6RzljRVBlcHl1QktkeG5Uc0cx?=
 =?utf-8?B?bzMrTlFhTWRPVVZLejE5elJLdDZGUnN0cHcrQ1ZiUVloUE5yS3VmdkVEMHRW?=
 =?utf-8?B?R2NjeWc3Y2FoczFCTGhBeENWVXJTY0hkcU9qUEdQM3F0VHJCQ3VNdGRKMThj?=
 =?utf-8?B?dGltOVpwcUJLNGNsOG9qTzlJN2c5eWR4L3kyOUlBQ2lVZi8xOFU3ellWVENG?=
 =?utf-8?B?UFVad3M5dkFZaWhWeFJUdnJmV3NvWHJDWHR3b0FyZHRmVjdzWmR4TEUvRjZO?=
 =?utf-8?B?Tkd5eEE0bnhWS1NrRzkwN2xBOU5oWUgwdWlsa0hET3pzVHJkcG1oSHBIL2s0?=
 =?utf-8?B?L3NHSjFvaDlLYlZoSzhQanh3Q3gxZXNRcGNheE5hWkI1eDRjZlJVc3Y0eFg2?=
 =?utf-8?B?ZVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9FB02AC5A614A4EA9BB5F031F163D38@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5653.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a69b5c77-da41-4329-ba94-08dac244dc36
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 11:23:43.4017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xoc25tG6zoGbvOuRIU57EOs+cpmcys9m6t7PvVBI70bXALM3+DVFfE5MR6120pPnN9kag1SVQMC0lM16SMQBa47zT2XtGfSDidzxXPSjUyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB6227
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTG9pYw0KDQpPbiBUdWUsIDIwMjItMTEtMDggYXQgMTM6MTQgKzAxMDAsIExvaWMgUG91bGFp
biB3cm90ZToNCj4gSGkgSGFvemhlLA0KPiANCj4gT24gVHVlLCA4IE5vdiAyMDIyIGF0IDExOjU0
LCA8aGFvemhlLmNoYW5nQG1lZGlhdGVrLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gRnJvbTogaGFv
emhlIGNoYW5nIDxoYW96aGUuY2hhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IA0KPiA+IHd3YW5fcG9y
dF9mb3BzX3dyaXRlIGlucHV0cyB0aGUgU0tCIHBhcmFtZXRlciB0byB0aGUgVFggY2FsbGJhY2sg
b2YNCj4gPiB0aGUgV1dBTiBkZXZpY2UgZHJpdmVyLiBIb3dldmVyLCB0aGUgV1dBTiBkZXZpY2Ug
KGUuZy4sIHQ3eHgpIG1heQ0KPiA+IGhhdmUgYW4gTVRVIGxlc3MgdGhhbiB0aGUgc2l6ZSBvZiBT
S0IsIGNhdXNpbmcgdGhlIFRYIGJ1ZmZlciB0byBiZQ0KPiA+IHNsaWNlZCBhbmQgY29waWVkIG9u
Y2UgbW9yZSBpbiB0aGUgV1dBTiBkZXZpY2UgZHJpdmVyLg0KPiA+IA0KPiA+IFRoaXMgcGF0Y2gg
aW1wbGVtZW50cyB0aGUgc2xpY2luZyBpbiB0aGUgV1dBTiBzdWJzeXN0ZW0gYW5kIGdpdmVzDQo+
ID4gdGhlIFdXQU4gZGV2aWNlcyBkcml2ZXIgdGhlIG9wdGlvbiB0byBzbGljZShieSBjaHVuaykg
b3Igbm90LiBCeQ0KPiA+IGRvaW5nIHNvLCB0aGUgYWRkaXRpb25hbCBtZW1vcnkgY29weSBpcyBy
ZWR1Y2VkLg0KPiA+IA0KPiA+IE1lYW53aGlsZSwgdGhpcyBwYXRjaCBnaXZlcyBXV0FOIGRldmlj
ZXMgZHJpdmVyIHRoZSBvcHRpb24gdG8NCj4gPiByZXNlcnZlDQo+ID4gaGVhZHJvb20gaW4gU0tC
IGZvciB0aGUgZGV2aWNlLXNwZWNpZmljIG1ldGFkYXRhLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYt
Ynk6IGhhb3poZSBjaGFuZyA8aGFvemhlLmNoYW5nQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4gPiAt
LS0NCj4gPiBDaGFuZ2VzIGluIHYyDQo+ID4gICAtc2VuZCBmcmFnbWVudHMgdG8gZGV2aWNlIGRy
aXZlciBieSBza2IgZnJhZ19saXN0Lg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC93d2FuL3Q3
eHgvdDd4eF9wb3J0X3d3YW4uYyB8IDQyICsrKysrKysrKystLS0tLS0tDQo+ID4gIGRyaXZlcnMv
bmV0L3d3YW4vd3dhbl9jb3JlLmMgICAgICAgICAgIHwgNjUgKysrKysrKysrKysrKysrKysrKysN
Cj4gPiAtLS0tLS0NCj4gPiAgaW5jbHVkZS9saW51eC93d2FuLmggICAgICAgICAgICAgICAgICAg
fCAgNSArLQ0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDgwIGluc2VydGlvbnMoKyksIDMyIGRlbGV0
aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93d2FuL3Q3eHgvdDd4
eF9wb3J0X3d3YW4uYw0KPiA+IGIvZHJpdmVycy9uZXQvd3dhbi90N3h4L3Q3eHhfcG9ydF93d2Fu
LmMNCj4gPiBpbmRleCAzMzkzMWJmZDc4ZmQuLjc0ZmE1ODU3NWQ1YSAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL25ldC93d2FuL3Q3eHgvdDd4eF9wb3J0X3d3YW4uYw0KPiA+ICsrKyBiL2RyaXZl
cnMvbmV0L3d3YW4vdDd4eC90N3h4X3BvcnRfd3dhbi5jDQo+ID4gQEAgLTU0LDEzICs1NCwxMyBA
QCBzdGF0aWMgdm9pZCB0N3h4X3BvcnRfY3RybF9zdG9wKHN0cnVjdA0KPiA+IHd3YW5fcG9ydCAq
cG9ydCkNCj4gDQo+IFsuLi5dDQo+ID4gIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgd3dhbl9wb3J0X29w
cyB3d2FuX29wcyA9IHsNCj4gPiAgICAgICAgIC5zdGFydCA9IHQ3eHhfcG9ydF9jdHJsX3N0YXJ0
LA0KPiA+ICAgICAgICAgLnN0b3AgPSB0N3h4X3BvcnRfY3RybF9zdG9wLA0KPiA+ICAgICAgICAg
LnR4ID0gdDd4eF9wb3J0X2N0cmxfdHgsDQo+ID4gKyAgICAgICAubmVlZGVkX2hlYWRyb29tID0g
dDd4eF9wb3J0X3R4X2hlYWRyb29tLA0KPiA+ICsgICAgICAgLnR4X2NodW5rX2xlbiA9IHQ3eHhf
cG9ydF90eF9jaHVua19sZW4sDQo+IA0KPiBDYW4geW91IHJlcGxhY2UgJ2NodW5rJyB3aXRoICdm
cmFnJyBldmVyeXdoZXJlPw0KPiANCk9LDQo+ID4gIH07DQo+ID4gDQo+ID4gIHN0YXRpYyBpbnQg
dDd4eF9wb3J0X3d3YW5faW5pdChzdHJ1Y3QgdDd4eF9wb3J0ICpwb3J0KQ0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC93d2FuL3d3YW5fY29yZS5jDQo+ID4gYi9kcml2ZXJzL25ldC93d2Fu
L3d3YW5fY29yZS5jDQo+ID4gaW5kZXggNjJlOWY3ZDZjOWZlLi5lZDc4NDcxZjllMzggMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvd3dhbi93d2FuX2NvcmUuYw0KPiA+ICsrKyBiL2RyaXZl
cnMvbmV0L3d3YW4vd3dhbl9jb3JlLmMNCj4gPiBAQCAtMjAsNyArMjAsNyBAQA0KPiA+ICAjaW5j
bHVkZSA8dWFwaS9saW51eC93d2FuLmg+DQo+ID4gDQo+ID4gIC8qIE1heGltdW0gbnVtYmVyIG9m
IG1pbm9ycyBpbiB1c2UgKi8NCj4gPiAtI2RlZmluZSBXV0FOX01BWF9NSU5PUlMgICAgICAgICAg
ICAgICAgKDEgPDwgTUlOT1JCSVRTKQ0KPiA+ICsjZGVmaW5lIFdXQU5fTUFYX01JTk9SUyAgICAg
ICAgICAgICAgICBCSVQoTUlOT1JCSVRTKQ0KPiA+IA0KPiA+ICBzdGF0aWMgREVGSU5FX01VVEVY
KHd3YW5fcmVnaXN0ZXJfbG9jayk7IC8qIFdXQU4gZGV2aWNlDQo+ID4gY3JlYXRlfHJlbW92ZSBs
b2NrICovDQo+ID4gIHN0YXRpYyBERUZJTkVfSURBKG1pbm9ycyk7IC8qIG1pbm9ycyBmb3IgV1dB
TiBwb3J0IGNoYXJkZXZzICovDQo+ID4gQEAgLTY3LDYgKzY3LDggQEAgc3RydWN0IHd3YW5fZGV2
aWNlIHsNCj4gPiAgICogQHJ4cTogQnVmZmVyIGluYm91bmQgcXVldWUNCj4gPiAgICogQHdhaXRx
dWV1ZTogVGhlIHdhaXRxdWV1ZSBmb3IgcG9ydCBmb3BzIChyZWFkL3dyaXRlL3BvbGwpDQo+ID4g
ICAqIEBkYXRhX2xvY2s6IFBvcnQgc3BlY2lmaWMgZGF0YSBhY2Nlc3Mgc2VyaWFsaXphdGlvbg0K
PiA+ICsgKiBAaGVhZHJvb21fbGVuOiBTS0IgcmVzZXJ2ZWQgaGVhZHJvb20gc2l6ZQ0KPiA+ICsg
KiBAY2h1bmtfbGVuOiBDaHVuayBsZW4gdG8gc3BsaXQgcGFja2V0DQo+ID4gICAqIEBhdF9kYXRh
OiBBVCBwb3J0IHNwZWNpZmljIGRhdGENCj4gPiAgICovDQo+ID4gIHN0cnVjdCB3d2FuX3BvcnQg
ew0KPiA+IEBAIC03OSw2ICs4MSw4IEBAIHN0cnVjdCB3d2FuX3BvcnQgew0KPiA+ICAgICAgICAg
c3RydWN0IHNrX2J1ZmZfaGVhZCByeHE7DQo+ID4gICAgICAgICB3YWl0X3F1ZXVlX2hlYWRfdCB3
YWl0cXVldWU7DQo+ID4gICAgICAgICBzdHJ1Y3QgbXV0ZXggZGF0YV9sb2NrOyAvKiBQb3J0IHNw
ZWNpZmljIGRhdGEgYWNjZXNzDQo+ID4gc2VyaWFsaXphdGlvbiAqLw0KPiA+ICsgICAgICAgc2l6
ZV90IGhlYWRyb29tX2xlbjsNCj4gPiArICAgICAgIHNpemVfdCBjaHVua19sZW47DQo+ID4gICAg
ICAgICB1bmlvbiB7DQo+ID4gICAgICAgICAgICAgICAgIHN0cnVjdCB7DQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgICAgc3RydWN0IGt0ZXJtaW9zIHRlcm1pb3M7DQo+ID4gQEAgLTU1MCw4ICs1
NTQsMTMgQEAgc3RhdGljIGludCB3d2FuX3BvcnRfb3Bfc3RhcnQoc3RydWN0IHd3YW5fcG9ydA0K
PiA+ICpwb3J0KQ0KPiA+ICAgICAgICAgfQ0KPiA+IA0KPiA+ICAgICAgICAgLyogSWYgcG9ydCBp
cyBhbHJlYWR5IHN0YXJ0ZWQsIGRvbid0IHN0YXJ0IGFnYWluICovDQo+ID4gLSAgICAgICBpZiAo
IXBvcnQtPnN0YXJ0X2NvdW50KQ0KPiA+ICsgICAgICAgaWYgKCFwb3J0LT5zdGFydF9jb3VudCkg
ew0KPiA+ICAgICAgICAgICAgICAgICByZXQgPSBwb3J0LT5vcHMtPnN0YXJ0KHBvcnQpOw0KPiA+
ICsgICAgICAgICAgICAgICBpZiAocG9ydC0+b3BzLT50eF9jaHVua19sZW4pDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgcG9ydC0+Y2h1bmtfbGVuID0gcG9ydC0+b3BzLQ0KPiA+ID50eF9j
aHVua19sZW4ocG9ydCk7DQo+IA0KPiBTbywgbWF5YmUgZnJhZyBsZW4gYW5kIGhlYWRyb29tIHNo
b3VsZCBiZSBwYXJhbWV0ZXJzIG9mDQo+IHd3YW5fY3JlYXRlX3BvcnQoKSBpbnN0ZWFkIG9mIHBv
cnQgb3BzLCBhcyB3ZSByZWFsbHkgbmVlZCB0aGlzIGluZm8NCj4gb25seSBvbmNlLg0KPiANCklm
IGZyYWdfbGVuIGFuZCBoZWFkcm9vbSBhcmUgYWRkZWQsIHd3YW5fY3JlYXRlX3BvcnQgd2lsbCBo
YXZlIDYNCnBhcmFtZXRlcnMsIGlzIGl0IHRvbyBtdWNoPyBBbmQgZm9yIHNpbWlsYXIgcmVxdWly
ZW1lbnRzIGluIHRoZSBmdXR1cmUsDQppdCBtYXkgYmUgZGlmZmljdWx0IHRvIGFkZCBtb3JlIHBh
cmFtZXRlcnMuDQoNCklzIGl0IGEgZ29vZCBzb2x1dGlvbiB0byBwcm92aWRlIHd3YW5fcG9ydF9z
ZXRfZnJhZ19sZW4gYW5kDQp3d2FuX3BvcnRfc2V0X2hlYWRyb29tX2xlbiB0byB0aGUgZGV2aWNl
IGRyaXZlcj8gaWYgc28sIHRoZSBkZXZpY2UNCmRyaXZlciBoYXMgYSBjaGFuY2UgdG8gbW9kaWZ5
IHRoZSB3d2FuIHBvcnQncyBmaWVsZCBhZnRlciBjYWxsaW5nDQp3d2FuX2NyZWF0ZV9wb3J0Lg0K
PiA+ICsgICAgICAgICAgICAgICBpZiAocG9ydC0+b3BzLT5uZWVkZWRfaGVhZHJvb20pDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgcG9ydC0+aGVhZHJvb21fbGVuID0gcG9ydC0+b3BzLQ0K
PiA+ID5uZWVkZWRfaGVhZHJvb20ocG9ydCk7DQo+ID4gKyAgICAgICB9DQo+ID4gDQo+ID4gICAg
ICAgICBpZiAoIXJldCkNCj4gPiAgICAgICAgICAgICAgICAgcG9ydC0+c3RhcnRfY291bnQrKzsN
Cj4gPiBAQCAtNjk4LDMwICs3MDcsNTYgQEAgc3RhdGljIHNzaXplX3Qgd3dhbl9wb3J0X2ZvcHNf
cmVhZChzdHJ1Y3QNCj4gPiBmaWxlICpmaWxwLCBjaGFyIF9fdXNlciAqYnVmLA0KPiA+ICBzdGF0
aWMgc3NpemVfdCB3d2FuX3BvcnRfZm9wc193cml0ZShzdHJ1Y3QgZmlsZSAqZmlscCwgY29uc3Qg
Y2hhcg0KPiA+IF9fdXNlciAqYnVmLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHNpemVfdCBjb3VudCwgbG9mZl90ICpvZmZwKQ0KPiA+ICB7DQo+ID4gKyAgICAgICBz
aXplX3QgbGVuLCBjaHVua19sZW4sIG9mZnNldCwgYWxsb3dlZF9jaHVua19sZW47DQo+ID4gKyAg
ICAgICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCAqaGVhZCA9IE5VTEwsICp0YWlsID0gTlVMTDsNCj4g
PiAgICAgICAgIHN0cnVjdCB3d2FuX3BvcnQgKnBvcnQgPSBmaWxwLT5wcml2YXRlX2RhdGE7DQo+
ID4gLSAgICAgICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KPiA+ICAgICAgICAgaW50IHJldDsNCj4g
PiANCj4gPiAgICAgICAgIHJldCA9IHd3YW5fd2FpdF90eChwb3J0LCAhIShmaWxwLT5mX2ZsYWdz
ICYgT19OT05CTE9DSykpOw0KPiA+ICAgICAgICAgaWYgKHJldCkNCj4gPiAgICAgICAgICAgICAg
ICAgcmV0dXJuIHJldDsNCj4gPiANCj4gPiAtICAgICAgIHNrYiA9IGFsbG9jX3NrYihjb3VudCwg
R0ZQX0tFUk5FTCk7DQo+ID4gLSAgICAgICBpZiAoIXNrYikNCj4gPiAtICAgICAgICAgICAgICAg
cmV0dXJuIC1FTk9NRU07DQo+ID4gKyAgICAgICBhbGxvd2VkX2NodW5rX2xlbiA9IHBvcnQtPmNo
dW5rX2xlbiA/IHBvcnQtPmNodW5rX2xlbiA6DQo+ID4gY291bnQ7DQo+IA0KPiBJIHdvdWxkIHN1
Z2dlc3QgbWFraW5nIHBvcnQtPmNodW5rX2xlbiAoZnJhZ19sZW4pIGFsd2F5cyB2YWxpZCwgYnkN
Cj4gc2V0dGluZyBpdCB0byAtMSAoTUFYIHNpemVfdCkgd2hlbiBjcmVhdGluZyBhIHBvcnQgd2l0
aG91dCBmcmFnX2xlbg0KPiByZXF1aXJlbWVudC4NCj4gDQpPaywgaXQgd2lsbCBoZWxwIHRvIHJl
ZHVjZSBzb21lIGNvZGUuDQo+ID4gKyAgICAgICBmb3IgKG9mZnNldCA9IDA7IG9mZnNldCA8IGNv
dW50OyBvZmZzZXQgKz0gY2h1bmtfbGVuKSB7DQo+ID4gKyAgICAgICAgICAgICAgIGNodW5rX2xl
biA9IG1pbihjb3VudCAtIG9mZnNldCwgYWxsb3dlZF9jaHVua19sZW4pOw0KPiA+ICsgICAgICAg
ICAgICAgICBsZW4gPSBjaHVua19sZW4gKyBwb3J0LT5oZWFkcm9vbV9sZW47DQo+ID4gKyAgICAg
ICAgICAgICAgIHNrYiA9IGFsbG9jX3NrYihsZW4sIEdGUF9LRVJORUwpOw0KPiANCj4gVGhhdCB3
b3JrcyBidXQgd291bGQgcHJlZmVyIGEgc2ltcGxlciBzb2x1dGlvbiBsaWtlOg0KPiBkbyB7DQo+
ICAgICBsZW4gPSBtaW4ocG9ydC0+ZnJhZ19sZW4sIHJlbWFpbik7DQo+ICAgICBza2IgPSBhbGxv
Y19za2IobGVuICsgcG9ydC0+bmVlZGVkX2hlYWRyb29tOyBHRlBfS0VSTkVMKTsNCj4gICAgIFsu
Li5dDQo+ICAgICBjb3B5X2Zyb21fdXNlcihza2JfcHV0KHNrYiwgbGVuKSwgYnVmICsgY291bnQg
LSByZW1haW4pDQo+IH0gd2hpbGUgKChyZW1haW4gLT0gbGVuKSk7DQo+IA0KTWF5IEkga25vdyBp
ZiB0aGUgc3VnZ2VzdGlvbiBpcyBiZWNhdXNlICJ3aGlsZSIgaXMgbW9yZSBlZmZpY2llbnQNCnRo
YW4gICJmb3IiLCBvciBpcyBpdCBtb3JlIHJlYWRhYmxlPw0KPiA+ICsgICAgICAgICAgICAgICBp
ZiAoIXNrYikgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IC1FTk9NRU07DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZ290byBmcmVlc2tiOw0KPiA+ICsgICAgICAgICAg
ICAgICB9DQo+ID4gKyAgICAgICAgICAgICAgIHNrYl9yZXNlcnZlKHNrYiwgcG9ydC0+aGVhZHJv
b21fbGVuKTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgIGlmICghaGVhZCkgew0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGhlYWQgPSBza2I7DQo+ID4gKyAgICAgICAgICAgICAgIH0g
ZWxzZSBpZiAoIXRhaWwpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBza2Jfc2hpbmZv
KGhlYWQpLT5mcmFnX2xpc3QgPSBza2I7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgdGFp
bCA9IHNrYjsNCj4gPiArICAgICAgICAgICAgICAgfSBlbHNlIHsNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICB0YWlsLT5uZXh0ID0gc2tiOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
IHRhaWwgPSBza2I7DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiANCj4gPiAtICAgICAgIGlm
IChjb3B5X2Zyb21fdXNlcihza2JfcHV0KHNrYiwgY291bnQpLCBidWYsIGNvdW50KSkgew0KPiA+
IC0gICAgICAgICAgICAgICBrZnJlZV9za2Ioc2tiKTsNCj4gPiAtICAgICAgICAgICAgICAgcmV0
dXJuIC1FRkFVTFQ7DQo+ID4gLSAgICAgICB9DQo+ID4gKyAgICAgICAgICAgICAgIGlmIChjb3B5
X2Zyb21fdXNlcihza2JfcHV0KHNrYiwgY2h1bmtfbGVuKSwgYnVmICsNCj4gPiBvZmZzZXQsIGNo
dW5rX2xlbikpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICByZXQgPSAtRUZBVUxUOw0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZnJlZXNrYjsNCj4gPiArICAgICAgICAg
ICAgICAgfQ0KPiA+IA0KPiA+IC0gICAgICAgcmV0ID0gd3dhbl9wb3J0X29wX3R4KHBvcnQsIHNr
YiwgISEoZmlscC0+Zl9mbGFncyAmDQo+ID4gT19OT05CTE9DSykpOw0KPiA+IC0gICAgICAgaWYg
KHJldCkgew0KPiA+IC0gICAgICAgICAgICAgICBrZnJlZV9za2Ioc2tiKTsNCj4gPiAtICAgICAg
ICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiArICAgICAgICAgICAgICAgaWYgKHNrYiAhPSBoZWFk
KSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaGVhZC0+ZGF0YV9sZW4gKz0gc2tiLT5s
ZW47DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaGVhZC0+bGVuICs9IHNrYi0+bGVuOw0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGhlYWQtPnRydWVzaXplICs9IHNrYi0+dHJ1ZXNp
emU7DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiAgICAgICAgIH0NCj4gPiANCj4gPiAtICAg
ICAgIHJldHVybiBjb3VudDsNCj4gPiArICAgICAgIGlmIChoZWFkKSB7DQo+IA0KPiBIb3cgaGVh
ZCBjYW4gYmUgbnVsbCBoZXJlPw0KPiANCmlmIHRoZSBwYXJhbWV0ZXIgImNvdW50IiBpcyAwLCB0
aGUgZm9yIGxvb3Agd2lsbCBub3QgYmUgZXhlY3V0ZWQuDQo+ID4gKyAgICAgICAgICAgICAgIHJl
dCA9IHd3YW5fcG9ydF9vcF90eChwb3J0LCBoZWFkLCAhIShmaWxwLT5mX2ZsYWdzDQo+ID4gJiBP
X05PTkJMT0NLKSk7DQo+ID4gKyAgICAgICAgICAgICAgIGlmICghcmV0KQ0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgIHJldHVybiBjb3VudDsNCj4gPiArICAgICAgIH0NCj4gPiArZnJlZXNr
YjoNCj4gPiArICAgICAgIGtmcmVlX3NrYihoZWFkKTsNCj4gPiArICAgICAgIHJldHVybiByZXQ7
DQo+ID4gIH0NCj4gPiANCj4gPiAgc3RhdGljIF9fcG9sbF90IHd3YW5fcG9ydF9mb3BzX3BvbGwo
c3RydWN0IGZpbGUgKmZpbHAsIHBvbGxfdGFibGUNCj4gPiAqd2FpdCkNCj4gPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC93d2FuLmggYi9pbmNsdWRlL2xpbnV4L3d3YW4uaA0KPiA+IGluZGV4
IDVjZTJhY2Y0NDRmYi4uYmRlZWVmNTliYmZkIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGlu
dXgvd3dhbi5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC93d2FuLmgNCj4gPiBAQCAtNDYsNiAr
NDYsOCBAQCBzdHJ1Y3Qgd3dhbl9wb3J0Ow0KPiA+ICAgKiBAdHg6IE5vbi1ibG9ja2luZyByb3V0
aW5lIHRoYXQgc2VuZHMgV1dBTiBwb3J0IHByb3RvY29sIGRhdGEgdG8NCj4gPiB0aGUgZGV2aWNl
Lg0KPiA+ICAgKiBAdHhfYmxvY2tpbmc6IE9wdGlvbmFsIGJsb2NraW5nIHJvdXRpbmUgdGhhdCBz
ZW5kcyBXV0FOIHBvcnQNCj4gPiBwcm90b2NvbCBkYXRhDQo+ID4gICAqICAgICAgICAgICAgICAg
dG8gdGhlIGRldmljZS4NCj4gPiArICogQG5lZWRlZF9oZWFkcm9vbTogT3B0aW9uYWwgcm91dGlu
ZSB0aGF0IHNldHMgcmVzZXJ2ZSBoZWFkcm9vbQ0KPiA+IG9mIHNrYi4NCj4gPiArICogQHR4X2No
dW5rX2xlbjogT3B0aW9uYWwgcm91dGluZSB0aGF0IHNldHMgY2h1bmsgbGVuIHRvIHNwbGl0Lg0K
PiA+ICAgKiBAdHhfcG9sbDogT3B0aW9uYWwgcm91dGluZSB0aGF0IHNldHMgYWRkaXRpb25hbCBU
WCBwb2xsIGZsYWdzLg0KPiA+ICAgKg0KPiA+ICAgKiBUaGUgd3dhbl9wb3J0X29wcyBzdHJ1Y3R1
cmUgY29udGFpbnMgYSBsaXN0IG9mIGxvdy1sZXZlbA0KPiA+IG9wZXJhdGlvbnMNCj4gPiBAQCAt
NTgsNiArNjAsOCBAQCBzdHJ1Y3Qgd3dhbl9wb3J0X29wcyB7DQo+ID4gDQo+ID4gICAgICAgICAv
KiBPcHRpb25hbCBvcGVyYXRpb25zICovDQo+ID4gICAgICAgICBpbnQgKCp0eF9ibG9ja2luZyko
c3RydWN0IHd3YW5fcG9ydCAqcG9ydCwgc3RydWN0IHNrX2J1ZmYNCj4gPiAqc2tiKTsNCj4gPiAr
ICAgICAgIHNpemVfdCAoKm5lZWRlZF9oZWFkcm9vbSkoc3RydWN0IHd3YW5fcG9ydCAqcG9ydCk7
DQo+ID4gKyAgICAgICBzaXplX3QgKCp0eF9jaHVua19sZW4pKHN0cnVjdCB3d2FuX3BvcnQgKnBv
cnQpOw0KPiANCj4gQXMgc2FpZCBhYm92ZSwgbWF5YmUgbW92ZSB0aGF0IGFzIHZhcmlhYmxlcywg
b3IgcGFyYW1ldGVyIG9mDQo+IHd3YW5fY3JlYXRlX3BvcnQuDQo+IA0KPiBSZWdhcmRzLA0KPiBM
b2ljDQo=
