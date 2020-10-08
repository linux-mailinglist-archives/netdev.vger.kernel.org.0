Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF13287BA8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgJHSZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 14:25:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:37680 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgJHSZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 14:25:30 -0400
IronPort-SDR: H54qyJLN1RLiqYXXLRLy4b8TtYYOho4m33Xvax7EogOnGGQa9vaRbWZ2p5WHCCt7IzHYAE8T5S
 yAp1Jpzn3I8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="144707236"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="144707236"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 11:25:27 -0700
IronPort-SDR: 3xfhHxTKFsgJwRIwdArv/kwQegklewAW/cqFJbaqgdeut9+COLP9E6//gGS8xCHH9Qbfwv9GKe
 6X4C6CX8r+gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="312289413"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 08 Oct 2020 11:25:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Oct 2020 11:25:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Oct 2020 11:25:27 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.52) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 8 Oct 2020 11:25:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N366vVos3gr1Bs2lMaHvDLOeiFWmQcr2aL8aLI+dQwG/m+pD0egh/kjMw5QTjMnxg/CLkVoyYme55eaga+Cb/s6qgS6vkRXF8u+GxiKLRN5l8e4K5dd94yd/VHf3Tz530AOZef7SNDlZxcXl/AzFB1cOrcmeKXdHPdHGLtKXqVK91kg3+QTQXnEtGTCdaTMGcLTrnj4V9MHSvp0RxaGSrKRL/+lLfgfDH91eiByo2xaeLPNs8NPNGI5NoS5LuDnSf96sj1kEfH3ejw0EjlW7NpyPvu2yjIheEJx37hmZRxBpBm/rQyBLufo67w+8myWDxhx4fXDuVAQtnn1zd73gsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuK/15loDMqAIik8+94q2qkmHdotT0S828ThjrCNt+E=;
 b=Xno6JCUR67Xc4EwQ6SmlwxiFFcU9kOSNT3P9rfsSGPzbX8XI8/WHnik8nKFWCWTjBiXiFRduT8R17usBjBnt/aAKCWp1bdDzOi2b+6y2IJkMkCsSwqxOBQaa+AyOksf84/O9fINuEXf6lFxsfeqPIp8+ZG/7jUdSjofQWUD8wytP1aPKyEO5iRW4/05/5tor0VZeisia3A6Rso5o+Ygc3t7ZPn52EXrLDxsZvg5Sno/VoHJjvaZLGB0nt52dvSr0nCvP1nEJL5LIRsVWvkJ/dAslU+oLyx7KGaEPSOOxyH2KEoRBrXhvThba2ycj9zqmRNsVCXpN9K4jdzCvhA+mTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuK/15loDMqAIik8+94q2qkmHdotT0S828ThjrCNt+E=;
 b=iNBiieYb8C3kY8FK3aan1i6Dpzk8vs0avqXim1yzW9FjjPYUWvuc8CewWhOQV8sEcuE2qDWBnsEkCjnBmLY3K25AtmL0s7JqFnfbWfIB7tc50mATLkggWI0ZldxN05D/veRoZJcs7hnN00HvBD/9zr5wCytPnD3/QPoqa4h5Pas=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB3211.namprd11.prod.outlook.com (2603:10b6:5:58::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Thu, 8 Oct 2020 18:25:20 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.046; Thu, 8 Oct 2020
 18:25:20 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABoskggAAXogCAAA5GgIAABE1ggACTy4CAABO4gIAAxvtw
Date:   Thu, 8 Oct 2020 18:25:20 +0000
Message-ID: <DM6PR11MB284113CE8F7D4C5A0989E233DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201008052137.GA13580@unreal>
 <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79c06fd5-82c0-4bec-585b-08d86bb7839a
x-ms-traffictypediagnostic: DM6PR11MB3211:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB32117143F613F4C57E079F26DD0B0@DM6PR11MB3211.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wmuZ8HUqmXOgwoogf+whe217YyhanLFydxkt5fe6kaVf7UJWkNGUZJyC4ehSeuZ1VYKLf4+Drh/3p/gHIYeWR2hd7UGSmKt3cApg2u33gN+7fS0ePeVkrPry4Lb/Sba38f15EryTa64LZ4wST1sW9o/An5fjoIa557V316Q15vL8BnPxWhs8oHm8JJYQQWSyKSTAcyBltmI5li4KfTOR8Z/Sv7negu1PK7jMsCc8VhCExGMU41zApQ0t1rNn6daKQ3McvgX/nWhL1CPr1vlWSyX/1cZY4Hn1aUcQIBd57owzccJjTaG0oEPRQHXvTzU+x177Xd66VSYzUMozkriWRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(4326008)(64756008)(5660300002)(66556008)(8676002)(7416002)(52536014)(66476007)(33656002)(8936002)(2906002)(9686003)(66946007)(55016002)(86362001)(7696005)(316002)(66446008)(76116006)(54906003)(6506007)(110136005)(26005)(186003)(83380400001)(53546011)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xjmi9cR/pbTg2Zc2no1rgq68ABzA0ycIQRPc+S/w4ACgXCHGMmuPr5Heo8aMnoHhPxwFSB4HzZdLHALHFmNr5UK6ub1QtgKnxjGfKObu+MeZOk9gfsbMEj1YSg2Wd0IezOnSMVRp9oBKc2dm8QTv4mbXqcrLPlpxeq0CrXlQp1KftxQXRVn8ymBEv0WbnJgO7PQcGdwL7QpomjcI0kjbqPXxQgfmQlBnZM1PsPCnE1mL19xNuY0L9mCmqyf0dXdV96y9x7gkvGu0KpeJMcxYwNjlyLfBEprU2+IzEymSjyjNuKT9qPn51XW2tiqopizMTlJewxj6X3qHPx0sqq75DhEor+uaVoMeIqiJZvaIns0c3hPc/74ttXoJO4z9qVv5WP0CNzWgq9dmvp5eW2zwOUGm9pVt/LCXkT3mbkh6wIO1TQYJlDI3QM3MzQzbV0dt4jFcAwMkFt9Og27V54nwg/LcKMIAx7MlWYyekgcf4Q81n5eZ66ZMLNVWKw/U4B2R2wHIEq4FCBQ1rV2tuf3y/iUEjSxI6gF5BOlAIm490VhxbF+80xr8OKl5y2sCcXZ9aVlSPXJfB6DQbJry1i6B+Mny4RAbiUI+BxoFiTrR7ocPXU3XULr/DSz5z1JhC/yTKT3AE/dq59caMfCorMibbw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79c06fd5-82c0-4bec-585b-08d86bb7839a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 18:25:20.3483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YH50+lhVWmyuOS/ASdzEv2Fit3OwjfUUmLtDQk+QoDO+2srCvdems6fV0tCNrY1ePnAoXfBLL+da9SeIHdeHhXk+0tJ6laMPCfRbWkXIR94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3211
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5q
LndpbGxpYW1zQGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVyIDcsIDIwMjAg
MTE6MzIgUE0NCj4gVG86IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPg0KPiBDYzog
RXJ0bWFuLCBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+OyBQYXJhdiBQYW5kaXQN
Cj4gPHBhcmF2QG52aWRpYS5jb20+OyBQaWVycmUtTG91aXMgQm9zc2FydCA8cGllcnJlLQ0KPiBs
b3Vpcy5ib3NzYXJ0QGxpbnV4LmludGVsLmNvbT47IGFsc2EtZGV2ZWxAYWxzYS1wcm9qZWN0Lm9y
ZzsNCj4gcGFyYXZAbWVsbGFub3guY29tOyB0aXdhaUBzdXNlLmRlOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOw0KPiByYW5qYW5pLnNyaWRoYXJhbkBsaW51eC5pbnRlbC5jb207IGZyZWQub2hAbGlu
dXguaW50ZWwuY29tOyBsaW51eC0NCj4gcmRtYUB2Z2VyLmtlcm5lbC5vcmc7IGRsZWRmb3JkQHJl
ZGhhdC5jb207IGJyb29uaWVAa2VybmVsLm9yZzsgSmFzb24NCj4gR3VudGhvcnBlIDxqZ2dAbnZp
ZGlhLmNvbT47IGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnOw0KPiBrdWJhQGtlcm5lbC5vcmc7
IFNhbGVlbSwgU2hpcmF6IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47DQo+IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IFBhdGlsLCBLaXJhbiA8a2lyYW4ucGF0aWxAaW50ZWwuY29tPg0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIHYyIDEvNl0gQWRkIGFuY2lsbGFyeSBidXMgc3VwcG9ydA0KPiANCj4gT24g
V2VkLCBPY3QgNywgMjAyMCBhdCAxMDoyMSBQTSBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVs
Lm9yZz4NCj4gd3JvdGU6DQo+ID4NCj4gPiBPbiBXZWQsIE9jdCAwNywgMjAyMCBhdCAwODo0Njo0
NVBNICswMDAwLCBFcnRtYW4sIERhdmlkIE0gd3JvdGU6DQo+ID4gPiA+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+ID4gPiA+IEZyb206IFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNv
bT4NCj4gPiA+ID4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVyIDcsIDIwMjAgMToxNyBQTQ0KPiA+
ID4gPiBUbzogTGVvbiBSb21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+OyBFcnRtYW4sIERhdmlk
IE0NCj4gPiA+ID4gPGRhdmlkLm0uZXJ0bWFuQGludGVsLmNvbT4NCj4gPiA+ID4gQ2M6IFBpZXJy
ZS1Mb3VpcyBCb3NzYXJ0IDxwaWVycmUtbG91aXMuYm9zc2FydEBsaW51eC5pbnRlbC5jb20+OyBh
bHNhLQ0KPiA+ID4gPiBkZXZlbEBhbHNhLXByb2plY3Qub3JnOyBwYXJhdkBtZWxsYW5veC5jb207
IHRpd2FpQHN1c2UuZGU7DQo+ID4gPiA+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHJhbmphbmku
c3JpZGhhcmFuQGxpbnV4LmludGVsLmNvbTsNCj4gPiA+ID4gZnJlZC5vaEBsaW51eC5pbnRlbC5j
b207IGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnOw0KPiA+ID4gPiBkbGVkZm9yZEByZWRoYXQu
Y29tOyBicm9vbmllQGtlcm5lbC5vcmc7IEphc29uIEd1bnRob3JwZQ0KPiA+ID4gPiA8amdnQG52
aWRpYS5jb20+OyBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZzsga3ViYUBrZXJuZWwub3JnOw0K
PiBXaWxsaWFtcywNCj4gPiA+ID4gRGFuIEogPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT47IFNh
bGVlbSwgU2hpcmF6DQo+ID4gPiA+IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7IFBhdGlsLCBLaXJhbg0KPiA+ID4gPiA8a2lyYW4ucGF0aWxAaW50ZWwuY29t
Pg0KPiA+ID4gPiBTdWJqZWN0OiBSRTogW1BBVENIIHYyIDEvNl0gQWRkIGFuY2lsbGFyeSBidXMg
c3VwcG9ydA0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiA+IEZyb206IExlb24gUm9tYW5vdnNr
eSA8bGVvbkBrZXJuZWwub3JnPg0KPiA+ID4gPiA+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDgs
IDIwMjAgMTI6NTYgQU0NCj4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBUaGlzIEFQSSBpcyBwYXJ0
aWFsbHkgb2JzY3VyZXMgbG93IGxldmVsIGRyaXZlci1jb3JlIGNvZGUgYW5kIG5lZWRzDQo+ID4g
PiA+ID4gPiA+IHRvIHByb3ZpZGUgY2xlYXIgYW5kIHByb3BlciBhYnN0cmFjdGlvbnMgd2l0aG91
dCBuZWVkIHRvDQo+IHJlbWVtYmVyDQo+ID4gPiA+ID4gPiA+IGFib3V0IHB1dF9kZXZpY2UuIFRo
ZXJlIGlzIGFscmVhZHkgX2FkZCgpIGludGVyZmFjZSB3aHkgZG9uJ3QgeW91DQo+IGRvDQo+ID4g
PiA+ID4gPiA+IHB1dF9kZXZpY2UoKSBpbiBpdD8NCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+
DQo+ID4gPiA+ID4gPiBUaGUgcHVzaGJhY2sgUGllcnJlIGlzIHJlZmVycmluZyB0byB3YXMgZHVy
aW5nIG91ciBtaWQtdGllciBpbnRlcm5hbA0KPiA+ID4gPiA+ID4gcmV2aWV3LiAgSXQgd2FzIHBy
aW1hcmlseSBhIGNvbmNlcm4gb2YgUGFyYXYgYXMgSSByZWNhbGwsIHNvIGhlIGNhbg0KPiBzcGVh
ayB0bw0KPiA+ID4gPiBoaXMNCj4gPiA+ID4gPiByZWFzb25pbmcuDQo+ID4gPiA+ID4gPg0KPiA+
ID4gPiA+ID4gV2hhdCB3ZSBvcmlnaW5hbGx5IGhhZCB3YXMgYSBzaW5nbGUgQVBJIGNhbGwNCj4g
PiA+ID4gPiA+IChhbmNpbGxhcnlfZGV2aWNlX3JlZ2lzdGVyKSB0aGF0IHN0YXJ0ZWQgd2l0aCBh
IGNhbGwgdG8NCj4gPiA+ID4gPiA+IGRldmljZV9pbml0aWFsaXplKCksIGFuZCBldmVyeSBlcnJv
ciBwYXRoIG91dCBvZiB0aGUgZnVuY3Rpb24NCj4gcGVyZm9ybWVkIGENCj4gPiA+ID4gPiBwdXRf
ZGV2aWNlKCkuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gSXMgdGhpcyB0aGUgbW9kZWwgeW91
IGhhdmUgaW4gbWluZD8NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEkgZG9uJ3QgbGlrZSB0aGlzIGZs
b3c6DQo+ID4gPiA+ID4gYW5jaWxsYXJ5X2RldmljZV9pbml0aWFsaXplKCkNCj4gPiA+ID4gPiBp
ZiAoYW5jaWxsYXJ5X2FuY2lsbGFyeV9kZXZpY2VfYWRkKCkpIHsNCj4gPiA+ID4gPiAgIHB1dF9k
ZXZpY2UoLi4uLikNCj4gPiA+ID4gPiAgIGFuY2lsbGFyeV9kZXZpY2VfdW5yZWdpc3RlcigpDQo+
ID4gPiA+IENhbGxpbmcgZGV2aWNlX3VucmVnaXN0ZXIoKSBpcyBpbmNvcnJlY3QsIGJlY2F1c2Ug
YWRkKCkgd2Fzbid0DQo+IHN1Y2Nlc3NmdWwuDQo+ID4gPiA+IE9ubHkgcHV0X2RldmljZSgpIG9y
IGEgd3JhcHBlciBhbmNpbGxhcnlfZGV2aWNlX3B1dCgpIGlzIG5lY2Vzc2FyeS4NCj4gPiA+ID4N
Cj4gPiA+ID4gPiAgIHJldHVybiBlcnI7DQo+ID4gPiA+ID4gfQ0KPiA+ID4gPiA+DQo+ID4gPiA+
ID4gQW5kIHByZWZlciB0aGlzIGZsb3c6DQo+ID4gPiA+ID4gYW5jaWxsYXJ5X2RldmljZV9pbml0
aWFsaXplKCkNCj4gPiA+ID4gPiBpZiAoYW5jaWxsYXJ5X2RldmljZV9hZGQoKSkgew0KPiA+ID4g
PiA+ICAgYW5jaWxsYXJ5X2RldmljZV91bnJlZ2lzdGVyKCkNCj4gPiA+ID4gVGhpcyBpcyBpbmNv
cnJlY3QgYW5kIGEgY2xlYXIgZGV2aWF0aW9uIGZyb20gdGhlIGN1cnJlbnQgY29yZSBBUElzIHRo
YXQNCj4gYWRkcyB0aGUNCj4gPiA+ID4gY29uZnVzaW9uLg0KPiA+ID4gPg0KPiA+ID4gPiA+ICAg
cmV0dXJuIGVycjsNCj4gPiA+ID4gPiB9DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJbiB0aGlzIHdh
eSwgdGhlIGFuY2lsbGFyeSB1c2VycyB3b24ndCBuZWVkIHRvIGRvIG5vbi1pbnR1aXRpdmUNCj4g
cHV0X2RldmljZSgpOw0KPiA+ID4gPg0KPiA+ID4gPiBCZWxvdyBpcyBtb3N0IHNpbXBsZSwgaW50
dWl0aXZlIGFuZCBtYXRjaGluZyB3aXRoIGNvcmUgQVBJcyBmb3IgbmFtZQ0KPiBhbmQNCj4gPiA+
ID4gZGVzaWduIHBhdHRlcm4gd2lzZS4NCj4gPiA+ID4gaW5pdCgpDQo+ID4gPiA+IHsNCj4gPiA+
ID4gICAgIGVyciA9IGFuY2lsbGFyeV9kZXZpY2VfaW5pdGlhbGl6ZSgpOw0KPiA+ID4gPiAgICAg
aWYgKGVycikNCj4gPiA+ID4gICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiA+ID4NCj4gPiA+
ID4gICAgIGVyciA9IGFuY2lsbGFyeV9kZXZpY2VfYWRkKCk7DQo+ID4gPiA+ICAgICBpZiAocmV0
KQ0KPiA+ID4gPiAgICAgICAgICAgICBnb3RvIGVycl91bndpbmQ7DQo+ID4gPiA+DQo+ID4gPiA+
ICAgICBlcnIgPSBzb21lX2ZvbygpOw0KPiA+ID4gPiAgICAgaWYgKGVycikNCj4gPiA+ID4gICAg
ICAgICAgICAgZ290byBlcnJfZm9vOw0KPiA+ID4gPiAgICAgcmV0dXJuIDA7DQo+ID4gPiA+DQo+
ID4gPiA+IGVycl9mb286DQo+ID4gPiA+ICAgICBhbmNpbGxhcnlfZGV2aWNlX2RlbChhZGV2KTsN
Cj4gPiA+ID4gZXJyX3Vud2luZDoNCj4gPiA+ID4gICAgIGFuY2lsbGFyeV9kZXZpY2VfcHV0KGFk
ZXYtPmRldik7DQo+ID4gPiA+ICAgICByZXR1cm4gZXJyOw0KPiA+ID4gPiB9DQo+ID4gPiA+DQo+
ID4gPiA+IGNsZWFudXAoKQ0KPiA+ID4gPiB7DQo+ID4gPiA+ICAgICBhbmNpbGxhcnlfZGV2aWNl
X2RlKGFkZXYpOw0KPiA+ID4gPiAgICAgYW5jaWxsYXJ5X2RldmljZV9wdXQoYWRldik7DQo+ID4g
PiA+ICAgICAvKiBJdCBpcyBjb21tb24gdG8gaGF2ZSBhIG9uZSB3cmFwcGVyIGZvciB0aGlzIGFz
DQo+ID4gPiA+IGFuY2lsbGFyeV9kZXZpY2VfdW5yZWdpc3RlcigpLg0KPiA+ID4gPiAgICAgICog
VGhpcyB3aWxsIG1hdGNoIHdpdGggY29yZSBkZXZpY2VfdW5yZWdpc3RlcigpIHRoYXQgaGFzIHBy
ZWNpc2UNCj4gPiA+ID4gZG9jdW1lbnRhdGlvbi4NCj4gPiA+ID4gICAgICAqIGJ1dCBnaXZlbiBm
YWN0IHRoYXQgaW5pdCgpIGNvZGUgbmVlZCBwcm9wZXIgZXJyb3IgdW53aW5kaW5nLCBsaWtlDQo+
ID4gPiA+IGFib3ZlLA0KPiA+ID4gPiAgICAgICogaXQgbWFrZSBzZW5zZSB0byBoYXZlIHR3byBB
UElzLCBhbmQgbm8gbmVlZCB0byBleHBvcnQgYW5vdGhlcg0KPiA+ID4gPiBzeW1ib2wgZm9yIHVu
cmVnaXN0ZXIoKS4NCj4gPiA+ID4gICAgICAqIFRoaXMgcGF0dGVybiBpcyB2ZXJ5IGVhc3kgdG8g
YXVkaXQgYW5kIGNvZGUuDQo+ID4gPiA+ICAgICAgKi8NCj4gPiA+ID4gfQ0KPiA+ID4NCj4gPiA+
IEkgbGlrZSB0aGlzIGZsb3cgKzENCj4gPiA+DQo+ID4gPiBCdXQgLi4uIHNpbmNlIHRoZSBpbml0
KCkgZnVuY3Rpb24gaXMgcGVyZm9ybWluZyBib3RoIGRldmljZV9pbml0IGFuZA0KPiA+ID4gZGV2
aWNlX2FkZCAtIGl0IHNob3VsZCBwcm9iYWJseSBiZSBjYWxsZWQgYW5jaWxsYXJ5X2RldmljZV9y
ZWdpc3RlciwNCj4gPiA+IGFuZCB3ZSBhcmUgYmFjayB0byBhIHNpbmdsZSBleHBvcnRlZCBBUEkg
Zm9yIGJvdGggcmVnaXN0ZXIgYW5kDQo+ID4gPiB1bnJlZ2lzdGVyLg0KPiA+ID4NCj4gPiA+IEF0
IHRoYXQgcG9pbnQsIGRvIHdlIG5lZWQgd3JhcHBlcnMgb24gdGhlIHByaW1pdGl2ZXMgaW5pdCwg
YWRkLCBkZWwsDQo+ID4gPiBhbmQgcHV0Pw0KPiA+DQo+ID4gTGV0IG1lIHN1bW1hcml6ZS4NCj4g
PiAxLiBZb3UgYXJlIG5vdCBwcm92aWRpbmcgZHJpdmVyL2NvcmUgQVBJIGJ1dCBzaW1wbGlmaWNh
dGlvbiBhbmQgb2JmdXNjYXRpb24NCj4gPiBvZiBiYXNpYyBwcmltaXRpdmVzIGFuZCBzdHJ1Y3R1
cmVzLiBUaGlzIGlzIG5ldyBsYXllci4gVGhlcmUgaXMgbm8gcm9vbSBmb3INCj4gPiBhIGNsYWlt
IHRoYXQgd2UgbXVzdCB0byBmb2xsb3cgaW50ZXJuYWwgQVBJLg0KPiANCj4gWWVzLCB0aGlzIGEg
ZHJpdmVyIGNvcmUgYXBpLCBHcmVnIGV2ZW4gcXVlc3Rpb25lZCB3aHkgaXQgd2FzIGluDQo+IGRy
aXZlcnMvYnVzIGluc3RlYWQgb2YgZHJpdmVycy9iYXNlIHdoaWNoIEkgdGhpbmsgbWFrZXMgc2Vu
c2UuDQoNCldpbGwgbW92ZSB0byBkcml2ZXJzL2Jhc2Ugd2l0aCBuZXh0IHBhdGNoIHNldC4NCg0K
LURhdmVFDQo=
