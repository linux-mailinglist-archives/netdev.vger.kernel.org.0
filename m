Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF5819A5F
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 11:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfEJJPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 05:15:40 -0400
Received: from mail-eopbgr730061.outbound.protection.outlook.com ([40.107.73.61]:35200
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726992AbfEJJPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 05:15:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSA47lRaD47gVkjnR4QZVVI1SlFOWw1QUqW5W1oYeBg=;
 b=P6j9qkyh/W9HoJNWlkiVn/q6miOnRfxuL4pYK6RankU/nkLaNOXsosVR+gcsuu3XAwFd6cCTRB1MoJlA6P/+7hwoSPcs/v94ubYmmHkZsEjQZMDFPXRh598iyCuxRg3vxxT0+p7oYdCqVHV63UCp9RKgx9ZRCph3+zfILCQVp14=
Received: from DM6PR03CA0057.namprd03.prod.outlook.com (20.178.24.34) by
 BN3PR03MB2257.namprd03.prod.outlook.com (10.167.5.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Fri, 10 May 2019 09:15:30 +0000
Received: from SN1NAM02FT044.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::209) by DM6PR03CA0057.outlook.office365.com
 (2603:10b6:5:100::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.21 via Frontend
 Transport; Fri, 10 May 2019 09:15:30 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT044.mail.protection.outlook.com (10.152.72.173) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Fri, 10 May 2019 09:15:29 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x4A9FSgk007201
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 10 May 2019 02:15:28 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Fri, 10 May 2019 05:15:28 -0400
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
Thread-Index: AQHVBZFQXT7pBvOEwE+osXNwuBSvQKZhdwMAgAACFgCAAADdAIAC38WA
Date:   Fri, 10 May 2019 09:15:27 +0000
Message-ID: <4df165bc4247e60aa4952fd55cb0c77e60712767.camel@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
         <20190508112842.11654-5-alexandru.ardelean@analog.com>
         <20190508131128.GL9224@smile.fi.intel.com>
         <20190508131856.GB10138@kroah.com>
         <b2440bc9485456a7a90a488c528997587b22088b.camel@analog.com>
In-Reply-To: <b2440bc9485456a7a90a488c528997587b22088b.camel@analog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.1.244]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE5857B429D5854D8FB2F6D2ED721097@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(39860400002)(136003)(376002)(396003)(346002)(2980300002)(189003)(199004)(486006)(126002)(86362001)(186003)(436003)(426003)(11346002)(476003)(2501003)(478600001)(2616005)(47776003)(336012)(446003)(229853002)(5660300002)(305945005)(70206006)(70586007)(6116002)(3846002)(7416002)(118296001)(7736002)(8676002)(54906003)(8936002)(6246003)(7636002)(102836004)(76176011)(110136005)(7696005)(246002)(2486003)(23676004)(36756003)(26005)(356004)(316002)(2906002)(50466002)(14454004)(4326008)(106002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR03MB2257;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa9ce3d9-4ae4-4703-3aac-08d6d5280c52
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328)(7193020);SRVR:BN3PR03MB2257;
X-MS-TrafficTypeDiagnostic: BN3PR03MB2257:
X-Microsoft-Antispam-PRVS: <BN3PR03MB2257FE51D1B5A3F49D339355F90C0@BN3PR03MB2257.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0033AAD26D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: U4QfQ9HE8G1hEmln7GMZMyZmGsSziLWs3MNhXESgKInyvjzvkf4zPUY0jxBs8jtBjx7o2HFh8RIrr84vqRJr33sBZ52u9jfyq+UnxjAZSIrQ7IYKCUViOV5wTfc+RZS4gKq+m/p9jOSvcbzSH0ANK7KYyLAnpQ4IIqqF/SOcdGtx+WMbS/bT2TaFvdKuG59b7NKK6kGPGcMgRa7VYxax9zMBVy+dB0vsn0G86Hyi3v99BIScotX2/E538fCfuzOtpR0Q6tUTkRJPRYlQSs8X/zugHmiwjsghQR5RqizMR7EABuUEf3qu55yG2t4YMjpnXTwsjzfXpumUi61GtQtgLgw/49vgzi5xG43Mo9YB/ngdoLZaVP0/kyKOb+jNhjx6GOpJZiy+Hc8kiON1awKOp8PYEbFqiQg2JSn2ulHzU0I=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2019 09:15:29.1206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9ce3d9-4ae4-4703-3aac-08d6d5280c52
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTA4IGF0IDE2OjIyICswMzAwLCBBbGV4YW5kcnUgQXJkZWxlYW4gd3Jv
dGU6DQo+IE9uIFdlZCwgMjAxOS0wNS0wOCBhdCAxNToxOCArMDIwMCwgR3JlZyBLSCB3cm90ZToN
Cj4gPiANCj4gPiANCj4gPiBPbiBXZWQsIE1heSAwOCwgMjAxOSBhdCAwNDoxMToyOFBNICswMzAw
LCBBbmR5IFNoZXZjaGVua28gd3JvdGU6DQo+ID4gPiBPbiBXZWQsIE1heSAwOCwgMjAxOSBhdCAw
MjoyODoyOVBNICswMzAwLCBBbGV4YW5kcnUgQXJkZWxlYW4gd3JvdGU6DQo+ID4gPiA+IFRoaXMg
Y2hhbmdlIHJlLWludHJvZHVjZXMgYG1hdGNoX3N0cmluZygpYCBhcyBhIG1hY3JvIHRoYXQgdXNl
cw0KPiA+ID4gPiBBUlJBWV9TSVpFKCkgdG8gY29tcHV0ZSB0aGUgc2l6ZSBvZiB0aGUgYXJyYXku
DQo+ID4gPiA+IFRoZSBtYWNybyBpcyBhZGRlZCBpbiBhbGwgdGhlIHBsYWNlcyB0aGF0IGRvDQo+
ID4gPiA+IGBtYXRjaF9zdHJpbmcoX2EsIEFSUkFZX1NJWkUoX2EpLCBzKWAsIHNpbmNlIHRoZSBj
aGFuZ2UgaXMgcHJldHR5DQo+ID4gPiA+IHN0cmFpZ2h0Zm9yd2FyZC4NCj4gPiA+IA0KPiA+ID4g
Q2FuIHlvdSBzcGxpdCBpbmNsdWRlL2xpbnV4LyBjaGFuZ2UgZnJvbSB0aGUgcmVzdD8NCj4gPiAN
Cj4gPiBUaGF0IHdvdWxkIGJyZWFrIHRoZSBidWlsZCwgd2h5IGRvIHlvdSB3YW50IGl0IHNwbGl0
IG91dD8gIFRoaXMgbWFrZXMNCj4gPiBzZW5zZSBhbGwgYXMgYSBzaW5nbGUgcGF0Y2ggdG8gbWUu
DQo+ID4gDQo+IA0KPiBOb3QgcmVhbGx5Lg0KPiBJdCB3b3VsZCBiZSBqdXN0IGJlIHRoZSBuZXcg
bWF0Y2hfc3RyaW5nKCkgaGVscGVyL21hY3JvIGluIGEgbmV3IGNvbW1pdC4NCj4gQW5kIHRoZSBj
b252ZXJzaW9ucyBvZiB0aGUgc2ltcGxlIHVzZXJzIG9mIG1hdGNoX3N0cmluZygpICh0aGUgb25l
cyB1c2luZw0KPiBBUlJBWV9TSVpFKCkpIGluIGFub3RoZXIgY29tbWl0Lg0KPiANCg0KSSBzaG91
bGQgaGF2ZSBhc2tlZCBpbiBteSBwcmV2aW91cyByZXBseS4NCkxlYXZlIHRoaXMgYXMtaXMgb3Ig
cmUtZm9ybXVsYXRlIGluIDIgcGF0Y2hlcyA/DQoNCk5vIHN0cm9uZyBwcmVmZXJlbmNlIGZyb20g
bXkgc2lkZS4NCg0KVGhhbmtzDQpBbGV4DQoNCj4gVGhhbmtzDQo+IEFsZXgNCj4gDQo+ID4gdGhh
bmtzLA0KPiA+IA0KPiA+IGdyZWcgay1oDQo=
