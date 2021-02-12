Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0690A31A5E4
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 21:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhBLUQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:16:38 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:43749 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhBLUQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 15:16:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613160993; x=1644696993;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jDIvqbET0muVio0Zt50T5tsg+4Ngyw7k53rSl6QWES0=;
  b=Q+R5/12gIuk7RPArbFApbH3XpeyTj6PQcdZ10IRaI1g6HPBJcc9mO9Bb
   K840l/hxpttdy1CWCsFSVlmnJYSJFf5IpQbrHJvMplySl2yr2z1+mzWNs
   vVf6MJLbEsgFTrO/tAKcrbUP85gnfaIBgHGx2bTwlcNNhRNv3tfwvSA+c
   9o9o3o6bqdRhvflS8hAQgUxawq1WciVqO7GxKdMPKQYZ9Y2G8ehLKb+NI
   5Sxb4yHdbtOsH4pQib8sHOtpWpqVa0Ua2wfZ//jPqobNDhtYos0CBVjVU
   T4Lj2ZCqCaiQguBP1uFGEvdRRb4Q9zF/QSWe6rfBHiLcF3FQB6XTwllNl
   g==;
IronPort-SDR: X8ZPneQZo6EqYDUEzhq3QbwCqkVop+x5MEyF5fAJuVtgBu8VwADnMC8ShPtJvJYl2bJkcuxCLa
 rVLeOa5CTdMDypLhrv86PZ3fgU3gvj8AO+mJj4DfSXnkB5u5VXOZQu5EdXdR6b1mUoXLkZODiR
 C/Wk12tkFBR6RW4kD14dnXYynQgn6N4s06501MVAg5ofc9Ob+N4cbEm30U9Z0kUn4PoHptia8Q
 VMFfVFAqbAjttCgWTLN+I9097cpBSalA5kRX2e6znqU5T4aELv1aV+uoXSFdGQRYYdOYTLBZuh
 yRU=
X-IronPort-AV: E=Sophos;i="5.81,174,1610434800"; 
   d="scan'208";a="106419595"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2021 13:15:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Feb 2021 13:15:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Fri, 12 Feb 2021 13:15:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5qNVLRPfLGI5oGY+Wgm3QRKSHggOd2jAxUJLyGZfOZHHYx1lTRltKxUhuHTExGv2Szqo+fI1edzN4UhMNHLlqjM9vqMSydaU9+wtALsrqGlVDeBUGWjMKARKiDEKaJlINpeIbb2GFDGyceDw9QLrnPDo5lPEprVAuRd0Jtg7pHfecPngD1Ew+yZSb7zFBalhwEb6y/fwNfu6kcPRRui+Lm/ZOU72GHdzrWL87ZkO7xj54KGjRK7Aq8jZIxKFebgKtAv66VCfS/MX0u4317u0gnHg+piSf5WMSyOR2bJVInazEpH2CWZVBRMa7t82NC50sbcKRQdHdvSAmF/y1WW6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDIvqbET0muVio0Zt50T5tsg+4Ngyw7k53rSl6QWES0=;
 b=C4zS5q3B1UkQO0FOranbrADFY9Q/xOGFz661KbrIC9jLjwAdvYvSi8EuDgUjyDECJ5xSUg4+OC6kz7OosffF0oP9lTlM0mMBfh7PaaRZwF/DjgULUSB7IShYAxHCSMSB7a80wnPPt7mH+r9Mq5SAaIEifDEWHdLe/bP9h5rHw8zL0BDplRGpRPODtiHdtGvPHUXpvl6Xpv3VxuhuaTU93lCKFkU9PpV8iiE+M8QyTDeOMMDSfA43+Tn7x4hwS/Ms5w9NDQ8TBqsmrKXKAWlPeZ6/dMfeq96qeXh8w2Qb39AFuDaCcPE2MM7a68ZWKsQllFWkxiGmNdZXMToT6K7YYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDIvqbET0muVio0Zt50T5tsg+4Ngyw7k53rSl6QWES0=;
 b=oc0FDchgvRWyIVp/ZbrykuH4w/zTU9+ME7mT3orHGmr7eD2PFkYL0Ri7QJEuzUmCD6gUbrvxX3qioKRPCmHHDh8ja/xWKCmmdHw+fsdNRp4BH95sc0cEu/eWxqhle5UUtS8UYj1CfCy6FHqSe72pXA0oY72PuhnAn/qC60G68WI=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3726.namprd11.prod.outlook.com (2603:10b6:208:ef::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 20:15:07 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584%2]) with mapi id 15.20.3825.031; Fri, 12 Feb 2021
 20:15:07 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <rtgbnm@gmail.com>, <sbauer@blackbox.su>,
        <tharvey@gateworks.com>, <anders@ronningen.priv.no>,
        <hdanton@sina.com>, <hch@lst.de>,
        <willemdebruijn.kernel@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/5] lan743x speed boost
Thread-Topic: [PATCH net-next v2 0/5] lan743x speed boost
Thread-Index: AQHXAJGvwzFnplh/4EOmtLA/KUqX2apU9l2Q
Date:   Fri, 12 Feb 2021 20:15:07 +0000
Message-ID: <MN2PR11MB3662B5854974A6788B670B9BFA8B9@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20210211161830.17366-1-TheSven73@gmail.com>
In-Reply-To: <20210211161830.17366-1-TheSven73@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 923ba688-9268-4798-1104-08d8cf92e476
x-ms-traffictypediagnostic: MN2PR11MB3726:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB372629DEDC9D04ABA39F1E84FA8B9@MN2PR11MB3726.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y7UE9t+DGoDZb1IpMKZdg3CXS3hV4vs37eD6vMJb4wGBqPDw94ZC4TLi+f8vzWTX7RvOszt+KpeHnzVXyHjCDEhqOl8Gp9pL8Eglcg2/5dOOUyV0UkecEb4tLjq7Mh1Jq3+8nuc7v9+q1oEF/10gDEtIap0xR9C9m+eMypnaQDaCbTGsNFZ6+0SASjTSnUvvlZKIQlHWGFvls80i8+oBsuMcHozqMZZpMehKi0IsIRBgDRyQ/52tASY53olmxl4zHIZgeHbDYRqBDNgWo4J+f/PMmAQ4h41GAqikZKs9QtZczyalEALCZqJ2yaaIdeYhNSGM+XnOhBYGPIkCyQjb6lDbD79NIUqJNfXKLa5JDkab2ijXGozkiDFbY3FhW6Fi+rJiks+IzU+ZFfZzkoXWiz594yn036Ha9eDN59x8UWyvcIL7zJFfbddEURFp6Ar3QJtmobAZADQCYOoZ1aLMkjXTsUB3ZD9uZbHZmFd66ZMeAB7ov8ERENT015SWGhjyg9xNHya5waoosInfrEryPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(39860400002)(396003)(376002)(2906002)(86362001)(76116006)(8676002)(7416002)(26005)(478600001)(4744005)(54906003)(52536014)(64756008)(186003)(66556008)(316002)(9686003)(66946007)(66446008)(5660300002)(71200400001)(66476007)(8936002)(55016002)(4326008)(7696005)(33656002)(6506007)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y1JDU1JlSnVLQ28rUUxIT2NzNE9jYnBOSzlPaFU2d09wbFpBWDBBMld0dWV1?=
 =?utf-8?B?SXorbElWT01LMzV5OUNVai9wQmhjZzgwK0VqOVBDdXZwc0cyZURsV0ZXeVJO?=
 =?utf-8?B?V0d0aGlFM25ra0FwcW9lSTdMeUY2Z0drOUtkR0pYV3h6TWRFeWM4VUFWVUxk?=
 =?utf-8?B?b3MvaW1LRVN0RTRBS2tnY1R4Tkw1K3RQb0Fld2o5YnVuZkIvYzRDcmpqQ0dk?=
 =?utf-8?B?eVdVY2J0OEJZalpidytkSm0wK2d1MXdhT1VFMUtGdmNnU29vWDFWWVdSUnkv?=
 =?utf-8?B?akdMMFJianZaazE1R2tWSldEREN1Q2ZYWDRkMVFNMnRLbW9VK29idkRhQW94?=
 =?utf-8?B?Q0NrMVIybERhRndOUDFmWEtlZTVPaENQTkxlT01oOS9ZM1RFOFRxdXpmcHMw?=
 =?utf-8?B?bzBEQ3Evcko1WFh1VHl3azFDRTRibmJTbGhLZ2drRUVTNytmdHdZeXA1SUxV?=
 =?utf-8?B?TlRsWGpBUGNXZUg0TVczaE5tcS82WXBWYVdpU0s0MFM5cHlrL1R2azNmdHVO?=
 =?utf-8?B?Y2lRZDR0cTFQTXZybWRORFJXN2xNUjlLNUtmZW9TNHoxWFg4aDd2MGFReW9T?=
 =?utf-8?B?M3NsTElQLys0UTlIdWVnYUJzblpuY2ptb3lyN05nclFPdnlBRXNUU0J0ZXNY?=
 =?utf-8?B?TVgxbGJWa2Z2eHNUUlVDRFNKMmtvT21mb0ozTlVDSUVHQmNYNVQvYTBvMWlw?=
 =?utf-8?B?VWdMN2x0amV6Vlh3b0h1WmZVMFlTaVF4QU90WTZhdVg4V1FiZnAwSSt6M2lU?=
 =?utf-8?B?dEQvb09JZEZNamVPcmJKL2hyQU9jSFJodzkyR0dwYzNLV2N3QkJxUDlXcGg1?=
 =?utf-8?B?eFUvMUtLbjg4Q2c5ZmM3T3piM0JTbXdTWWZHQzNUSm85ODcra1hUM1AvNThH?=
 =?utf-8?B?TW9xeWcxbmNHUUJLc3pNbmU0VXFmcFhhUHZEd3lWM1RMYjc3NS8ybC9odmt1?=
 =?utf-8?B?MVBrNG9xdk5xVVFvS0pwWjRQQ3pRQ1RoMDI1Zk1qNEhTV3BSUXhTWHkwOEUz?=
 =?utf-8?B?NmFIcFBUZ0kzWmFzUi9lSC9nL1Q0UnJQZFhLbTk4UE00d0hvQ1QvSDdiRytV?=
 =?utf-8?B?TTVjOW9wN2tBT2tZUUlwZUhxZnkwSHFEQkxnTU45d0E1clVISERoa0Vvemh5?=
 =?utf-8?B?Nk02UEw5S3Q4MXNUQkJMQUR0RnM1Ym1lS0t5MFlKZFBtbDhLQVlzWERyQjJt?=
 =?utf-8?B?SE5PRGVTQWFkdTlhS3U4SlU4MGZUcmFrWmwrMy9DK0JRbFZhWU5LUDZCS1px?=
 =?utf-8?B?N2k5Q0hlRkRZWlhIM0FGQTNYSVpmeDEwSG5SSnNsT3hPSjdCbmFhYWtNS3lk?=
 =?utf-8?B?M3hnVGIxUWZVNDd0NDl6cFlmVEtYOWd1dlo1c1Q4byszeUszWHZ3V2lDV0VQ?=
 =?utf-8?B?b0szbXpaSUttZTZjS0h5QkVIQ3dianZrZitwcU9xT3JneWpOZE1iS3k4YTdi?=
 =?utf-8?B?aVAzZ2Jab0RnUTQxUERXR3hVRUVuTDZ4SlpHbzlvU0NLRlAvanc3SGdRdS9K?=
 =?utf-8?B?aFNZcUN1aGJGdEFSNGV6MnBScm92VmJZVDg3MklVS2ZUNUFreGhPQzlGcUVs?=
 =?utf-8?B?Y3ZrUnJEa1UwWG1ZS0s0dzJyZXB0bnFPTStmWkJsRWxhNHB3NkduYWJybmFk?=
 =?utf-8?B?VUFINUFWMlN0dnRnNHBISkVSYTZmUEN0YjdyblRic09nam45d3pZcWNhUEw3?=
 =?utf-8?B?NTIzTXJDdHRMM29qZVpsZjc1NGZSMngyZDRKM0VjQ0dHdnJuWjhNRHQ2UThZ?=
 =?utf-8?Q?dkLK7h9BLDv7F+0m19F+T4PM3bQTg1lnHP0W15j?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 923ba688-9268-4798-1104-08d8cf92e476
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 20:15:07.7473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: co9jrGLBnpVTfTmOSQxjldacCzEQ8lbCpmN+KCo4zx0dWQ2jk+lfMXDcPEGks1wn33TaL2OUmBwu22QMYYwsVxOv8sse2Ph+iZ8/YboRpCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3Zlbiwgc2VlIGJlbG93DQogDQo+IC0gQnJ5YW4gV2hpdGVoZWFkOg0KPiAgICAgKyBtdWx0
aS1idWZmZXIgcGF0Y2ggY29uY2VwdCAibG9va3MgZ29vZCIuDQo+ICAgICAgIEFzIGEgcmVzdWx0
LCBJIHdpbGwgc3F1YXNoIHRoZSBpbnRlcm1lZGlhdGUgImRtYSBidWZmZXIgb25seSIgcGF0Y2gg
d2hpY2gNCj4gICAgICAgZGVtb25zdHJhdGVkIHRoZSBzcGVlZCBib29zdCB1c2luZyBhbiBpbmZs
ZXhpYmxlIHNvbHV0aW9uDQo+ICAgICAgICh3L28gbXVsdGktYnVmZmVycykuDQo+ICAgICArIFJl
bmFtZSBsYW43NDN4X3J4X3Byb2Nlc3NfYnVmZmVyKCkgdG8gbGFuNzQzeF9yeF9wcm9jZXNzX3Bh
Y2tldCgpDQpZb3UgbWVhbnQgIlJlbmFtZSBsYW43NDN4X3J4X3Byb2Nlc3NfcGFja2V0KCkgdG8g
bGFuNzQzeF9yeF9wcm9jZXNzX2J1ZmZlcigpIg0KDQo+ICAgICArIFJlbW92ZSB1bnVzZWQgUlhf
UFJPQ0VTU19SRVNVTFRfUEFDS0VUX0RST1BQRUQNCj4gICAgICsgUmVuYW1lIFJYX1BST0NFU1Nf
UkVTVUxUX0JVRkZFUl9SRUNFSVZFRCB0bw0KPiAgICAgICBSWF9QUk9DRVNTX1JFU1VMVF9QQUNL
RVRfUkVDRUlWRUQNCllvdSBtZWFudCAiUmVuYW1lIFJYX1BST0NFU1NfUkVTVUxUX1BBQ0tFVF9S
RUNFSVZFRCB0byBSWF9QUk9DRVNTX1JFU1VMVF9CVUZGRVJfUkVDRUlWRUQiDQoNCkkgZG9uJ3Qg
dGhpbmsgeW91IG5lZWQgYSBuZXcgdmVyc2lvbiBmb3IganVzdCB0aGVzZSB0eXBvcywgYmVjYXVz
ZSB0aGUgcGF0Y2ggaXMgY29ycmVjdC4gQnV0IGlmIHlvdSBkbyBhIG5ldyB2ZXJzaW9uIHRoZW4g
eW91IGNhbiBjaGFuZ2UgaXQuDQoNClJlZ2FyZHMsDQpCcnlhbg0K
