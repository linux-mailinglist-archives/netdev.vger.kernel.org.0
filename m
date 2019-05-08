Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C58A17763
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfEHLbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:31:31 -0400
Received: from mail-eopbgr790045.outbound.protection.outlook.com ([40.107.79.45]:13760
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727543AbfEHLb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5znCPRPKBRTF+JsmgIj6aBz2AD2vefu9H7uU0wxS3Bk=;
 b=ST5Z/dIpKXaTMbKZaXyicKhHdXlzGRr2cvNr4QiUG7GY+t2c8tYrS8HUzZk7zoQX2Sqwe4wEAPF+A8JRA7yBnsNWwHplIEFbWx98uHp1nu1y/AQc7kTAAlpBLD/QdcBgnMXwfvYN222CXVA7LOxKe+AxnGT9uWSdnYuXbWlIovg=
Received: from BN3PR03CA0101.namprd03.prod.outlook.com (2603:10b6:400:4::19)
 by DM2PR03MB559.namprd03.prod.outlook.com (2a01:111:e400:241d::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.12; Wed, 8 May
 2019 11:31:18 +0000
Received: from BL2NAM02FT039.eop-nam02.prod.protection.outlook.com
 (104.47.38.57) by BN3PR03CA0101.outlook.office365.com (10.174.66.19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.21 via Frontend
 Transport; Wed, 8 May 2019 11:31:17 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT039.mail.protection.outlook.com (10.152.77.152) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:31:17 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x48BVHaS024094
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:31:17 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Wed, 8 May 2019 07:31:17 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
CC:     "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/16] lib: fix match_string() helper on -1 array size
Thread-Topic: [PATCH 01/16] lib: fix match_string() helper on -1 array size
Thread-Index: AQHVBZFHmipnRagpkkSQZ3QUXGEfCKZhWwOA
Date:   Wed, 8 May 2019 11:31:15 +0000
Message-ID: <c8cfa5dbdfc0b0665d1b48f37ba57c3ec1233197.camel@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
         <20190508112842.11654-2-alexandru.ardelean@analog.com>
In-Reply-To: <20190508112842.11654-2-alexandru.ardelean@analog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.1.244]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE083E2328EDB84B98DBA67ED168014A@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(346002)(396003)(136003)(376002)(39860400002)(2980300002)(199004)(189003)(316002)(476003)(118296001)(6116002)(446003)(11346002)(47776003)(86362001)(356004)(336012)(7736002)(54906003)(7696005)(426003)(436003)(23676004)(76176011)(2201001)(50466002)(106002)(8676002)(186003)(305945005)(7636002)(26005)(126002)(102836004)(2501003)(7416002)(110136005)(2486003)(2616005)(6246003)(486006)(229853002)(3846002)(8936002)(4326008)(36756003)(14444005)(14454004)(478600001)(2906002)(246002)(70586007)(70206006)(5660300002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB559;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02c3a8a0-d0c1-4c80-7ddc-08d6d3a8afc4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328)(7193020);SRVR:DM2PR03MB559;
X-MS-TrafficTypeDiagnostic: DM2PR03MB559:
X-Microsoft-Antispam-PRVS: <DM2PR03MB559A4A2108CED3746037F44F9320@DM2PR03MB559.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: i1sZYo6+MPS+6/7XgMeGmPbqVIlaaoyZKrXQV6LiPzw6/R3K/eQZlAf95MbvTFj8RMJWP0II8lSInFCoIulDFlCx/JsNMygVVJ8q/LRE3z17s0tpdivj0+b/UasOcUpBHIp3OQfHj2kaVyCS2BeUcnIF5LWbo+8vDRMk7TLK+H8tp8dbpETe3ScxHUYDc/wd8D9/9BbnuLxjBKjEY4u7N/823NDi/QpVZP4q5veHEW/X50PKJ719D70vsHOHlWnIvzgNsRQbuw/2iNQHJ6hMflZpi8FSBrssSpTJWXoBQ62jnwr7L3xJJTrS49pFG12Vg/fkREnj1kwJSBIkhC1aiEA+1Nhy/J5FlWq9cKCtZDZjNHFsY8zmnAX59M+MVqQAkGrEfd0btkJOD7ftl06mPopshHrrs1UdWTFfMEXIMS0=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:31:17.5189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c3a8a0-d0c1-4c80-7ddc-08d6d3a8afc4
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR03MB559
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTA4IGF0IDE0OjI4ICswMzAwLCBBbGV4YW5kcnUgQXJkZWxlYW4gd3Jv
dGU6DQo+IFRoZSBkb2N1bWVudGF0aW9uIHRoZSBgX21hdGNoX3N0cmluZygpYCBoZWxwZXIgbWVu
dGlvbnMgdGhhdCBgbmANCj4gc2hvdWxkIGJlOg0KPiAgKiBAbjogbnVtYmVyIG9mIHN0cmluZ3Mg
aW4gdGhlIGFycmF5IG9yIC0xIGZvciBOVUxMIHRlcm1pbmF0ZWQgYXJyYXlzDQo+IA0KPiBUaGUg
YmVoYXZpb3Igb2YgdGhlIGZ1bmN0aW9uIGlzIGRpZmZlcmVudCwgaW4gdGhlIHNlbnNlIHRoYXQg
aXQgZXhpdHMgb24NCj4gdGhlIGZpcnN0IE5VTEwgZWxlbWVudCBpbiB0aGUgYXJyYXksIHJlZ2Fy
ZGxlc3Mgb2Ygd2hldGhlciBgbmAgaXMgLTEgb3IgYQ0KPiBwb3NpdGl2ZSBudW1iZXIuDQo+IA0K
PiBUaGlzIHBhdGNoIGNoYW5nZXMgdGhlIGJlaGF2aW9yLCB0byBleGl0IHRoZSBsb29wIHdoZW4g
YSBOVUxMIGVsZW1lbnQgaXMNCj4gZm91bmQgYW5kIG4gPT0gLTEuIEVzc2VudGlhbGx5LCB0aGlz
IGFsaWducyB0aGUgYmVoYXZpb3Igd2l0aCB0aGUNCj4gZG9jLXN0cmluZy4NCj4gDQo+IFRoZXJl
IGFyZSBjdXJyZW50bHkgbWFueSB1c2VycyBvZiBgbWF0Y2hfc3RyaW5nKClgLCBhbmQgc28sIGlu
IG9yZGVyIHRvDQo+IGdvDQo+IHRocm91Z2ggdGhlbSwgdGhlIG5leHQgcGF0Y2hlcyBpbiB0aGUg
c2VyaWVzIHdpbGwgZm9jdXMgb24gZG9pbmcgc29tZQ0KPiBjb3NtZXRpYyBjaGFuZ2VzLCB3aGlj
aCBhcmUgYWltZWQgYXQgZ3JvdXBpbmcgdGhlIHVzZXJzIG9mDQo+IGBtYXRjaF9zdHJpbmcoKWAu
DQo+IA0KDQpUaGlzIGlzIHRoZSBkdXBsaWNhdGUgJiBzaG91bGQgYmUgZHJvcHBlZC4NClNvcnJ5
IGZvciB0aGlzLg0KDQo+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGFu
ZHJ1LmFyZGVsZWFuQGFuYWxvZy5jb20+DQo+IC0tLQ0KPiAgbGliL3N0cmluZy5jIHwgNSArKysr
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2xpYi9zdHJpbmcuYyBiL2xpYi9zdHJpbmcuYw0KPiBpbmRleCAzYWI4
NjFjMWE4NTcuLjc2ZWRiN2JmNzZjYiAxMDA2NDQNCj4gLS0tIGEvbGliL3N0cmluZy5jDQo+ICsr
KyBiL2xpYi9zdHJpbmcuYw0KPiBAQCAtNjQ4LDggKzY0OCwxMSBAQCBpbnQgbWF0Y2hfc3RyaW5n
KGNvbnN0IGNoYXIgKiBjb25zdCAqYXJyYXksIHNpemVfdA0KPiBuLCBjb25zdCBjaGFyICpzdHJp
bmcpDQo+ICANCj4gIAlmb3IgKGluZGV4ID0gMDsgaW5kZXggPCBuOyBpbmRleCsrKSB7DQo+ICAJ
CWl0ZW0gPSBhcnJheVtpbmRleF07DQo+IC0JCWlmICghaXRlbSkNCj4gKwkJaWYgKCFpdGVtKSB7
DQo+ICsJCQlpZiAobiAhPSAoc2l6ZV90KS0xKQ0KPiArCQkJCWNvbnRpbnVlOw0KPiAgCQkJYnJl
YWs7DQo+ICsJCX0NCj4gIAkJaWYgKCFzdHJjbXAoaXRlbSwgc3RyaW5nKSkNCj4gIAkJCXJldHVy
biBpbmRleDsNCj4gIAl9DQo=
