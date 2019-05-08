Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D4617A6D
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 15:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfEHNWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 09:22:20 -0400
Received: from mail-eopbgr780051.outbound.protection.outlook.com ([40.107.78.51]:38598
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725778AbfEHNWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 09:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57n0axMWfSppjRKnE2U+vW//5BLzA4EzmC99Z5lXAeE=;
 b=UMtRA7btjltIWs48hXkIv4/4HA4IV3jQ8cBnXHCpLfp1I3Z4Akzil07iQIkMOgwEDQXTy0tz3IdYXq0FC5hSRTvvuT1Xev4r2cg33hAk4ofoV6UgoZNKh+NcLw6xgdfmxGeEwPGz/hf9ACdPlcTPaDajdfqjDPJ4X5c+Lq4NkTc=
Received: from BN6PR03CA0059.namprd03.prod.outlook.com (2603:10b6:404:4c::21)
 by CY4PR03MB3125.namprd03.prod.outlook.com (2603:10b6:910:53::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.15; Wed, 8 May
 2019 13:22:07 +0000
Received: from CY1NAM02FT028.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by BN6PR03CA0059.outlook.office365.com
 (2603:10b6:404:4c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.21 via Frontend
 Transport; Wed, 8 May 2019 13:22:06 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.57)
 smtp.mailfrom=analog.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT028.mail.protection.outlook.com (10.152.75.132) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 13:22:05 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x48DM4Hp020338
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 06:22:04 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Wed, 8 May 2019 09:22:04 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-rpi-kernel@lists.infradead.org" 
        <linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 03/16] lib,treewide: add new match_string() helper/macro
Thread-Topic: [PATCH 03/16] lib,treewide: add new match_string() helper/macro
Thread-Index: AQHVBZFQXT7pBvOEwE+osXNwuBSvQKZhdwMAgAACFgCAAADdAA==
Date:   Wed, 8 May 2019 13:22:03 +0000
Message-ID: <b2440bc9485456a7a90a488c528997587b22088b.camel@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
         <20190508112842.11654-5-alexandru.ardelean@analog.com>
         <20190508131128.GL9224@smile.fi.intel.com>
         <20190508131856.GB10138@kroah.com>
In-Reply-To: <20190508131856.GB10138@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.1.244]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E6885BF46859D4BA859205743820E9A@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(396003)(136003)(376002)(346002)(39860400002)(2980300002)(189003)(199004)(486006)(70586007)(246002)(26005)(126002)(2906002)(6246003)(2501003)(316002)(86362001)(70206006)(54906003)(7416002)(11346002)(36756003)(110136005)(5660300002)(476003)(4744005)(50466002)(102836004)(356004)(446003)(478600001)(436003)(186003)(106002)(426003)(4326008)(2616005)(229853002)(8936002)(7736002)(14454004)(336012)(7636002)(3846002)(76176011)(118296001)(6116002)(7696005)(8676002)(2486003)(305945005)(47776003)(23676004)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB3125;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf20b47f-7a5e-4fec-5507-08d6d3b82ade
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328)(7193020);SRVR:CY4PR03MB3125;
X-MS-TrafficTypeDiagnostic: CY4PR03MB3125:
X-Microsoft-Antispam-PRVS: <CY4PR03MB3125B0A44595D00ED95BC72FF9320@CY4PR03MB3125.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Y23xOtmneh07yASE+/blELoCkrmoUK2VWWlwgfLPI2XEB7HSNAG31rJcUjy0gmVYvxrvWAJWix4tCmwxJND2sMhli4fdVGFvwA+r1WjwvaHAApuJYd3VNN4OWSQT/CJhB+OvvdFJJwQlGID7fD9BmmAUUIz44XSoq5JB1yP3qTQOjUc9QybzLdR4/w1V8KZgHUgitxp1f85Fsq6Gp/t7tpe3x9bohvD3luQWpxzuQodTpuIoNkt9J/0jNcc4OJcpeiQYGsEMFn1Wm6GweN4qfiaHcfFLjzADZt7JchoV72QH3aogegojaUXzeYue5Y1hMAswgJmlCCOkjQNQRyvvx6iYA32Asn2Wy2nCRCMqaFN0wb4+EM9SyjG0jUY9CnHEEttETR6crG7QDiTZNLtDe3Op5pVyuXYipjCRAcV6uKw=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 13:22:05.0484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf20b47f-7a5e-4fec-5507-08d6d3b82ade
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB3125
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTA4IGF0IDE1OjE4ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiANCj4g
DQo+IE9uIFdlZCwgTWF5IDA4LCAyMDE5IGF0IDA0OjExOjI4UE0gKzAzMDAsIEFuZHkgU2hldmNo
ZW5rbyB3cm90ZToNCj4gPiBPbiBXZWQsIE1heSAwOCwgMjAxOSBhdCAwMjoyODoyOVBNICswMzAw
LCBBbGV4YW5kcnUgQXJkZWxlYW4gd3JvdGU6DQo+ID4gPiBUaGlzIGNoYW5nZSByZS1pbnRyb2R1
Y2VzIGBtYXRjaF9zdHJpbmcoKWAgYXMgYSBtYWNybyB0aGF0IHVzZXMNCj4gPiA+IEFSUkFZX1NJ
WkUoKSB0byBjb21wdXRlIHRoZSBzaXplIG9mIHRoZSBhcnJheS4NCj4gPiA+IFRoZSBtYWNybyBp
cyBhZGRlZCBpbiBhbGwgdGhlIHBsYWNlcyB0aGF0IGRvDQo+ID4gPiBgbWF0Y2hfc3RyaW5nKF9h
LCBBUlJBWV9TSVpFKF9hKSwgcylgLCBzaW5jZSB0aGUgY2hhbmdlIGlzIHByZXR0eQ0KPiA+ID4g
c3RyYWlnaHRmb3J3YXJkLg0KPiA+IA0KPiA+IENhbiB5b3Ugc3BsaXQgaW5jbHVkZS9saW51eC8g
Y2hhbmdlIGZyb20gdGhlIHJlc3Q/DQo+IA0KPiBUaGF0IHdvdWxkIGJyZWFrIHRoZSBidWlsZCwg
d2h5IGRvIHlvdSB3YW50IGl0IHNwbGl0IG91dD8gIFRoaXMgbWFrZXMNCj4gc2Vuc2UgYWxsIGFz
IGEgc2luZ2xlIHBhdGNoIHRvIG1lLg0KPiANCg0KTm90IHJlYWxseS4NCkl0IHdvdWxkIGJlIGp1
c3QgYmUgdGhlIG5ldyBtYXRjaF9zdHJpbmcoKSBoZWxwZXIvbWFjcm8gaW4gYSBuZXcgY29tbWl0
Lg0KQW5kIHRoZSBjb252ZXJzaW9ucyBvZiB0aGUgc2ltcGxlIHVzZXJzIG9mIG1hdGNoX3N0cmlu
ZygpICh0aGUgb25lcyB1c2luZw0KQVJSQVlfU0laRSgpKSBpbiBhbm90aGVyIGNvbW1pdC4NCg0K
VGhhbmtzDQpBbGV4DQoNCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBrLWgNCg==
