Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE362868C2
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgJGUBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:01:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:31078 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgJGUBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 16:01:12 -0400
IronPort-SDR: 6JB1XaBjoPEhWG27VCxIAD1Eg7hIc90sYhDkhASQjRn4DnOL+7NY2we9aA1Yaddu21V0egmMON
 gZpyW78UgKlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="229269127"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="229269127"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 13:01:10 -0700
IronPort-SDR: Y54foMefP6xQqyo2sRqUX/D3CUFBu8tFiBsCzr7OGh8foPR1yKAWpOo+/62t5wQL3vDWQ1q02r
 DOPmt8hK8G3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="517965372"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 07 Oct 2020 13:01:09 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 13:01:09 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 13:01:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Oct 2020 13:01:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 7 Oct 2020 13:01:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TF0+/BxeTnCyXSH+6jWqqOVEnvXRyW6KiVMTMLJoVst5vT5kDRmpDC5rWSsAOnLlh6nEhw9NrDlif/xg7HtPikYh48Irac3GqnG5h/4wFVp2QieAtUex6smgDgn3I3ZVA/1PGEZiTkxoWbcXSj5jQulFYljDrqn2xyaFcQv6liJBL0RDqNYGJy5sMxHvPIWfMidiZQPnJtHTjEPqkA26yg+spLi4mY/DEZZrwDzCNcOOAlAvavqaQsh5ocb6KuD1pbgX/N5QmRsjijDUf9VvbKQ6vCeBSs5wf7UULFFjb2GKe7tM9v5OPrf3T2Rfa7V+go0G4/HAua34Huy8IIfdEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IlhFmOy9pH1gCKkkDOS9olEuve8AUUTR7AagVhq6J0=;
 b=NjWMh7VElMbMtFydsLExHclSdE+hS72rdMQ9/2iuAP6iv6Z6kW8qWESPdH4kiqmJbyFQrcGBGnB+3sWtYNctpRCCWQfECw/Txh4CBkRUO9IQQeOVDi11+E2IPnE152QTalvcz9lEbN1dA2HJ3FLPaI3J2ZeKAma9GERx0gXc//TkEiXxx5C17cdaR1v6Dsr/+OPIorxtVfoG6fijjXW+AcVa2lNAvxqmsTaMosSPq8rdsRW/7fi39tM0/kSf6bbhSbh6uwED/PB9IEELr2RYjchVYu3h61TxeFe+MpJfdnETiN6JX11VAMmrxKrJb6Z28lDDDphSSd5FdJai3nl2aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IlhFmOy9pH1gCKkkDOS9olEuve8AUUTR7AagVhq6J0=;
 b=aHGJqniQClEnFd54EGsKHsa4x9uSPcxN5XlOdyU8sqLzHg0bSnrpSYsnYoZinnHeQdg1CP5LLZDEsGjoZ0yoD/QMi4WPBWaFYdr+Ewsn7lAAjIPJ9K3vuEVxvQu258td0mbXuc+LwsvCYUFWpypXgFGajjIJrSx5hNiS8aYh5XM=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB2875.namprd11.prod.outlook.com (2603:10b6:5:cc::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Wed, 7 Oct 2020 20:01:03 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 20:01:03 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Parav Pandit <parav@nvidia.com>,
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
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIAAAc6AgAAE8QCAAAP1AIAAG9QAgAB9aYCAAK1bgIAAB3GAgABZOICAABHNQA==
Date:   Wed, 7 Oct 2020 20:01:03 +0000
Message-ID: <DM6PR11MB284187404E449FB5B4FE9AC9DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201006172650.GO1874917@unreal>
 <3ff1445d86564ef3aae28d1d1a9a19ea@intel.com>
 <20201006192036.GQ1874917@unreal>
 <CAPcyv4iC_KGOx7Jwax-GWxFJbfUM-2+ymSuf4zkCxG=Yob5KnQ@mail.gmail.com>
 <cd80aad674ee48faaaedc8698c9b23e2@intel.com>
 <20201007133633.GB3964015@unreal>
 <CAPcyv4j1VrPkX_=61S7pdCPdDGy+xFGMkHHNnR-FT+TXXvbOWA@mail.gmail.com>
In-Reply-To: <CAPcyv4j1VrPkX_=61S7pdCPdDGy+xFGMkHHNnR-FT+TXXvbOWA@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: 9e0ad282-1eb9-47fc-81cb-08d86afbb85a
x-ms-traffictypediagnostic: DM6PR11MB2875:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB2875565893287792406DF240DD0A0@DM6PR11MB2875.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HN5YfwRylrWE4XxxcfFliaqWzFXPLxTkN1O02erJnmpXCJ+eoSbpgkgNBng8CJKdiOE4P6ZENwERmXpLn3tKO8e7yzhSwr1EyCdn6eFk4glk1feoTIn8Hx1Af7a04BnGywNnXeMzEoj1h2D3BLtLpCmXNsv5wuBK1e6/A6gng9V4CmRtACXQzrvpBjZiqUfQC/Zd0beMWCDYOwzeha7kcaEhfHZEQiXhNP4jShwo0F0MzxUvDHj+2TIhexQJ7I+gSYIaCN0RoNE/FStS2CJxJzvllzQ3ooGw5xDVvruB+gfYdl7UccM9sXZPmlhVVNWfnMZZ0M4iJG0RznGZmnAR7NqmZzvSG0XJeBNzxot9lNdDatNnqKL5Ot7URYf1pMI1o0yaUhuTAPgnqsSOzdkstA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(71200400001)(83080400001)(86362001)(9686003)(83380400001)(966005)(478600001)(33656002)(7416002)(8676002)(8936002)(66946007)(7696005)(2906002)(186003)(53546011)(6506007)(55016002)(64756008)(110136005)(52536014)(26005)(316002)(4326008)(5660300002)(76116006)(66446008)(66476007)(66556008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Y5F2etaBgvv/+gWiyzTWcfzQQ27VMDZSS/ghHnWZc7+KPhHJxRUPFgxPdUOGJbU5xRAvLYLBDmeMwzA6QZGHK5Xrd4tDUbIvvdeaix2BAnfd8RCH23eqjnPXo3YM55Ln1kp8n5ndpdlp186We65DrSj3hU2uw6AZ0cg0DalHs/fUcG/6/wHX/71usHzwfD9w0JNqFLhQUEV9yrd9YB4/PAQdz70aUgw5pk6SNoM0wF4BM/cTSOAaM5TuXR2ZL1K6wPBOKLA2DlsYhUlWeZUOSNcJG9lfN3ov14+W8tUnz4LlSbgj06qx0Uf9wwawUSRjrTXm7N0YIXX/N4QJaOYbDpCJ0beCqAkeEn7rZSNycUviaKzHvzLfSpfzsGUnppiiis+RwIVut3yBli/umOgMe7CGBugoVxUUxvORK8gbINoYNrGxBR39kqo1VlKVoORToMw5/2E+F9NFlZ1L6QmhzyRasIMmn/gU9CmSmTRkBjPfWVB33dzsvGkJLxp5vIBmoTn9jyhbTBmopzbC3GjZFe8brBQl10brxMoI2lOxyHSa2pd2W8CMZKdESYJEULaNNhaH1tEOhehxrlucBvXZr0J7yhMRtZGZmh/B9ZQv9SecSFEe+chXEhTaP0lvpydozxPPQI4rvFYdWlsab42TDA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0ad282-1eb9-47fc-81cb-08d86afbb85a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 20:01:03.3540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2VZ/S7TKeuqNDLmWY+wUbIjFIfK1aZR26hgEy161hHRxpblhNhDHX/5vhV9Qlqov7FRC4LKmWL4IVZfcCSBzSvhOq8Iy+6Wpx3FOTcla3Ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2875
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5q
LndpbGxpYW1zQGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVyIDcsIDIwMjAg
MTE6NTYgQU0NCj4gVG86IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPg0KPiBDYzog
U2FsZWVtLCBTaGlyYXogPHNoaXJhei5zYWxlZW1AaW50ZWwuY29tPjsgUGFyYXYgUGFuZGl0DQo+
IDxwYXJhdkBudmlkaWEuY29tPjsgUGllcnJlLUxvdWlzIEJvc3NhcnQgPHBpZXJyZS0NCj4gbG91
aXMuYm9zc2FydEBsaW51eC5pbnRlbC5jb20+OyBFcnRtYW4sIERhdmlkIE0NCj4gPGRhdmlkLm0u
ZXJ0bWFuQGludGVsLmNvbT47IGFsc2EtZGV2ZWxAYWxzYS1wcm9qZWN0Lm9yZzsNCj4gcGFyYXZA
bWVsbGFub3guY29tOyB0aXdhaUBzdXNlLmRlOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBy
YW5qYW5pLnNyaWRoYXJhbkBsaW51eC5pbnRlbC5jb207IGZyZWQub2hAbGludXguaW50ZWwuY29t
OyBsaW51eC0NCj4gcmRtYUB2Z2VyLmtlcm5lbC5vcmc7IGRsZWRmb3JkQHJlZGhhdC5jb207IGJy
b29uaWVAa2VybmVsLm9yZzsgSmFzb24NCj4gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT47IGdy
ZWdraEBsaW51eGZvdW5kYXRpb24ub3JnOw0KPiBrdWJhQGtlcm5lbC5vcmc7IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IFBhdGlsLCBLaXJhbg0KPiA8a2lyYW4ucGF0aWxAaW50ZWwuY29tPg0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIHYyIDEvNl0gQWRkIGFuY2lsbGFyeSBidXMgc3VwcG9ydA0KPiANCj4g
T24gV2VkLCBPY3QgNywgMjAyMCBhdCA2OjM3IEFNIExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJu
ZWwub3JnPg0KPiB3cm90ZToNCj4gPg0KPiA+IE9uIFdlZCwgT2N0IDA3LCAyMDIwIGF0IDAxOjA5
OjU1UE0gKzAwMDAsIFNhbGVlbSwgU2hpcmF6IHdyb3RlOg0KPiA+ID4gPiBTdWJqZWN0OiBSZTog
W1BBVENIIHYyIDEvNl0gQWRkIGFuY2lsbGFyeSBidXMgc3VwcG9ydA0KPiA+ID4gPg0KPiA+ID4g
PiBPbiBUdWUsIE9jdCA2LCAyMDIwIGF0IDEyOjIxIFBNIExlb24gUm9tYW5vdnNreSA8bGVvbkBr
ZXJuZWwub3JnPg0KPiB3cm90ZToNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE9uIFR1ZSwgT2N0IDA2
LCAyMDIwIGF0IDA1OjQxOjAwUE0gKzAwMDAsIFNhbGVlbSwgU2hpcmF6IHdyb3RlOg0KPiA+ID4g
PiA+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDEvNl0gQWRkIGFuY2lsbGFyeSBidXMgc3Vw
cG9ydA0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBPbiBUdWUsIE9jdCAwNiwgMjAyMCBh
dCAwNTowOTowOVBNICswMDAwLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4N
Cj4gPiA+ID4gPiA+ID4gPiA+IEZyb206IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3Jn
Pg0KPiA+ID4gPiA+ID4gPiA+ID4gU2VudDogVHVlc2RheSwgT2N0b2JlciA2LCAyMDIwIDEwOjMz
IFBNDQo+ID4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+ID4gT24gVHVlLCBPY3QgMDYs
IDIwMjAgYXQgMTA6MTg6MDdBTSAtMDUwMCwgUGllcnJlLUxvdWlzIEJvc3NhcnQNCj4gd3JvdGU6
DQo+ID4gPiA+ID4gPiA+ID4gPiA+IFRoYW5rcyBmb3IgdGhlIHJldmlldyBMZW9uLg0KPiA+ID4g
PiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gQWRkIHN1cHBvcnQgZm9yIHRo
ZSBBbmNpbGxhcnkgQnVzLCBhbmNpbGxhcnlfZGV2aWNlIGFuZA0KPiA+ID4gPiBhbmNpbGxhcnlf
ZHJpdmVyLg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gSXQgZW5hYmxlcyBkcml2ZXJzIHRvIGNy
ZWF0ZSBhbiBhbmNpbGxhcnlfZGV2aWNlIGFuZA0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+ID4gYmlu
ZCBhbiBhbmNpbGxhcnlfZHJpdmVyIHRvIGl0Lg0KPiA+ID4gPiA+ID4gPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPiA+ID4gPiA+ID4gSSB3YXMgdW5kZXIgaW1wcmVzc2lvbiB0aGF0IHRoaXMgbmFtZSBp
cyBnb2luZyB0byBiZQ0KPiBjaGFuZ2VkLg0KPiA+ID4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gPiA+ID4gPiBJdCdzIHBhcnQgb2YgdGhlIG9wZW5zIHN0YXRlZCBpbiB0aGUgY292ZXIgbGV0
dGVyLg0KPiA+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiA+IG9rLCBzbyB3aGF0IGFy
ZSB0aGUgdmFyaWFudHM/DQo+ID4gPiA+ID4gPiA+ID4gPiBzeXN0ZW0gYnVzIChzeXNidXMpLCBz
YnN5c3RlbSBidXMgKHN1YmJ1cyksIGNyb3NzYnVzID8NCj4gPiA+ID4gPiA+ID4gPiBTaW5jZSB0
aGUgaW50ZW5kZWQgdXNlIG9mIHRoaXMgYnVzIGlzIHRvDQo+ID4gPiA+ID4gPiA+ID4gKGEpIGNy
ZWF0ZSBzdWIgZGV2aWNlcyB0aGF0IHJlcHJlc2VudCAnZnVuY3Rpb25hbCBzZXBhcmF0aW9uJw0K
PiA+ID4gPiA+ID4gPiA+IGFuZA0KPiA+ID4gPiA+ID4gPiA+IChiKSBzZWNvbmQgdXNlIGNhc2Ug
Zm9yIHN1YmZ1bmN0aW9ucyBmcm9tIGEgcGNpIGRldmljZSwNCj4gPiA+ID4gPiA+ID4gPg0KPiA+
ID4gPiA+ID4gPiA+IEkgcHJvcG9zZWQgYmVsb3cgbmFtZXMgaW4gdjEgb2YgdGhpcyBwYXRjaHNl
dC4NCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiAoYSkgc3ViZGV2X2J1cw0KPiA+ID4g
PiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBJdCBzb3VuZHMgZ29vZCwganVzdCBjYW4gd2UgYXZvaWQg
Il8iIGluIHRoZSBuYW1lIGFuZCBjYWxsIGl0DQo+IHN1YmRldj8NCj4gPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBXaGF0IGlzIHdyb25nIHdpdGggbmFtaW5nIHRoZSBidXMg
J2FuY2lsbGFyeSBidXMnPyBJIGZlZWwgaXQncyBhIGZpdHRpbmcNCj4gbmFtZS4NCj4gPiA+ID4g
PiA+IEFuIGFuY2lsbGFyeSBzb2Z0d2FyZSBidXMgZm9yIGFuY2lsbGFyeSBkZXZpY2VzIGNhcnZl
ZCBvZmYgYSBwYXJlbnQNCj4gZGV2aWNlDQo+ID4gPiA+IHJlZ2lzdGVyZWQgb24gYSBwcmltYXJ5
IGJ1cy4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEdyZWcgc3VtbWFyaXplZCBpdCB2ZXJ5IHdlbGws
IGV2ZXJ5IGludGVybmFsIGNvbnZlcnNhdGlvbiBhYm91dCB0aGlzDQo+ID4gPiA+ID4gcGF0Y2gg
d2l0aCBteSBjb2xsZWFndWVzIChub24tZW5nbGlzaCBzcGVha2Vycykgc3RhcnRzIHdpdGggdGhl
DQo+IHF1ZXN0aW9uOg0KPiA+ID4gPiA+ICJXaGF0IGRvZXMgYW5jaWxsYXJ5IG1lYW4/Ig0KPiA+
ID4gPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2Fsc2EtDQo+IGRldmVsLzIwMjAxMDAxMDcx
NDAzLkdDMzExOTFAa3JvYWguY29tLw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gIkZvciBub24tbmF0
aXZlIGVuZ2xpc2ggc3BlYWtlcnMgdGhpcyBpcyBnb2luZyB0byBiZSByb3VnaCwgZ2l2ZW4gdGhh
dA0KPiA+ID4gPiA+IEkgYXMgYSBuYXRpdmUgZW5nbGlzaCBzcGVha2VyIGhhZCB0byBnbyBsb29r
IHVwIHRoZSB3b3JkIGluIGENCj4gPiA+ID4gPiBkaWN0aW9uYXJ5IHRvIGZ1bGx5IHVuZGVyc3Rh
bmQgd2hhdCB5b3UgYXJlIHRyeWluZyB0byBkbyB3aXRoIHRoYXQNCj4gPiA+ID4gPiBuYW1lLiIN
Cj4gPiA+ID4NCj4gPiA+ID4gSSBzdWdnZXN0ZWQgImF1eGlsaWFyeSIgaW4gYW5vdGhlciBzcGxp
bnRlcmVkIHRocmVhZCBvbiB0aGlzIHF1ZXN0aW9uLg0KPiA+ID4gPiBJbiB0ZXJtcyBvZiB3aGF0
IHRoZSBrZXJuZWwgaXMgYWxyZWFkeSB1c2luZzoNCj4gPiA+ID4NCj4gPiA+ID4gJCBnaXQgZ3Jl
cCBhdXhpbGlhcnkgfCB3YyAtbA0KPiA+ID4gPiA1MDcNCj4gPiA+ID4gJCBnaXQgZ3JlcCBhbmNp
bGxhcnkgfCB3YyAtbA0KPiA+ID4gPiAxNTMNCj4gPiA+ID4NCj4gPiA+ID4gRW1waXJpY2FsbHks
ICJhdXhpbGlhcnkiIGlzIG1vcmUgY29tbW9uIGFuZCBjbG9zZWx5IG1hdGNoZXMgdGhlDQo+IGlu
dGVuZGVkIGZ1bmN0aW9uDQo+ID4gPiA+IG9mIHRoZXNlIGRldmljZXMgcmVsYXRpdmUgdG8gdGhl
aXIgcGFyZW50IGRldmljZS4NCj4gPiA+DQo+ID4gPiBhdXhpbGlhcnkgYnVzIGlzIGEgYmVmaXR0
aW5nIG5hbWUgYXMgd2VsbC4NCj4gPg0KPiA+IExldCdzIHNoYXJlIGFsbCBvcHRpb25zIGFuZCBk
ZWNpZGUgbGF0ZXIuDQo+ID4gSSBkb24ndCB3YW50IHRvIGZpbmQgdXMgYmlrZXNoZWRkaW5nIGFi
b3V0IGl0Lg0KPiANCj4gVG9vIGxhdGUgd2UgYXJlIGRlZXAgaW50byBiaWtlc2hlZGRpbmcgYXQg
dGhpcyBwb2ludC4uLiBpdCBjb250aW51ZWQNCj4gb3ZlciBoZXJlIFsxXSBmb3IgYSBiaXQsIGJ1
dCBsZXQncyB0cnkgdG8gYnJpbmcgdGhlIGRpc2N1c3Npb24gYmFjayB0bw0KPiB0aGlzIHRocmVh
ZC4NCj4gDQo+IFsxXTogaHR0cDovL2xvcmUua2VybmVsLm9yZy9yLzEwMDQ4ZDRkLTAzOGMtYzJi
Ny0yZWQ3LQ0KPiBmZDRjYTg3ZDEwNGFAbGludXguaW50ZWwuY29tDQoNCk91dCBvZiBhbGwgb2Yg
dGhlIHN1Z2dlc3Rpb25zIHB1dCBmb3J3YXJkIHNvIGZhciB0aGF0IGRvIG5vdA0KaGF2ZSByZWFs
IG9iamVjdGlvbnMgdG8gdGhlbSAuLi4NCg0KSSB3b3VsZCBwdXQgbXkgdm90ZSBiZWhpbmQgYXV4
IC0gc2hvcnQsIHNpbXBsZSwgbWVhbmluZ2Z1bA0KDQotRGF2ZUUNCg==
