Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD2D287B65
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJHSNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 14:13:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:62518 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgJHSNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 14:13:20 -0400
IronPort-SDR: +k07Fftul3jjv3GAPLMXOotEaTCq+JqfiBdBSmN6GD08SrWHNbz489lF8xNIIwf3ys//Yw9Srj
 nD7HTKC33oXA==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="229569521"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="229569521"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 11:13:19 -0700
IronPort-SDR: CQTFDCDe+a/eO0ujxZRciV6Tq7zjxGoIVZt5chh09NP2ovOZctNmUZAA4iyz/EnrtJ1Zxp4ZF/
 9vZFnkMjAtuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="344821191"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 08 Oct 2020 11:13:18 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Oct 2020 11:13:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Oct 2020 11:13:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 8 Oct 2020 11:13:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYzVqzoTpOD4ImsUHOP1WAsgV3ejFa743aKQyvyEG8G/c1Vf9mtkrcktlupNopjgzQTK/3udzIoaqEopO13g9OK/bkIlFstPMkvMRsVONoMTAhmXVLf7Qw/LhLXiF/v6t1WlQIjXSzZqtA7cnypN+U8GlCPHbracjPKPdn3e3kdAtSHeJYuu/3FbDE42x13nl8c8glKxyve4St8Ue830M0afgMJTJawKoM9iRqETupSbQDStlsm+wIHLZGqKUsSpIv8KTkLWQgroCB7e4C7DxoeCdrbPU/o9stt7vU/Kn5m1qeOT/mG37hOltseyZU/FovI7PrT+QXNXqhJSDj8BiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N27XnsiG1U7UsWxEbavAJ2gA2nvl/Q+36djw+C+gQsY=;
 b=fwcycD4PYgmTvMyhWwYneLfCNCiXqP3gskDZZLm94ZczKJGjn/FE/6Dp5CpXaBfI3Oy59TalHScI2tM+NVV4x1K0s+NpBzR5kMHWpsYGK8wurVrrG3/4Hn73QfhxFcBF85yvzUOtOVihVZIicmEtTezStCQr9XD34jgxJFog+MywbCPj2/RDyw7/umPCSwiK/1kiMvNSF6v0HxDKZGtqMU4Ltn3HOxVwLva5oiD1O/DOMzO+VJB8TzfTQ0ClNW+b7+ss5s/K+8K+W8EwejRXZqGmMmn7ArYS/SjGCoPG39sVMclJadMqebekAqRjhw40nge2hGO+orXCzO6LyLFy7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N27XnsiG1U7UsWxEbavAJ2gA2nvl/Q+36djw+C+gQsY=;
 b=DZRI3qjs3mfg8UsdvvZUmZXh04XYY0qd8hN8RXkxea12/uzedqLNRQmIlir9OPErG3lUwnYn5zxRt7pE6PAHireQKdsio1EPkFPerqkueTG3HmgBSXBqXff67t/1ntmpaoX7G01VBTenSh+d7Y4YuWCji6RO7OkLGzrt9z9ena8=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM5PR1101MB2282.namprd11.prod.outlook.com (2603:10b6:4:53::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Thu, 8 Oct 2020 18:13:15 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.046; Thu, 8 Oct 2020
 18:13:15 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
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
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABoskggAAXogCAAA5GgIAABE1ggAAHfwCAAAYEwIAACBeAgAB3CoCAAMgIcIAADAwAgAAHN4A=
Date:   Thu, 8 Oct 2020 18:13:15 +0000
Message-ID: <DM6PR11MB2841C22E6BCF1525A6BA2BB2DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
 <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
 <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB284193A69F553272DA501C52DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <BY5PR12MB43223FE33A906FF4AA0C46A4DC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43223FE33A906FF4AA0C46A4DC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66d17c1f-dd11-4e0a-2aea-08d86bb5d39c
x-ms-traffictypediagnostic: DM5PR1101MB2282:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB22829DA18C203E04FFBD5FD8DD0B0@DM5PR1101MB2282.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9VT0Mtn8OAXcx7Uip3FgqBbDTTYba2joYf8DutIe89OQTfOAi1VDjTc6D0B8aL+VJDRG41u5M+m4hgzF09Qh/L/gEbz2DYBCUjUEN5UAzjGlv+UZZtdizT6fcAe1aj5HeCN3qAMxb8+HdKB/+EM16BSDr7H6Jjq/2T5fEt0qYhxtEAP0Fj1lw2j4fkOW5VlAmvSa0jkKXR170rt6FvFEkU9kQSzPz7cIFGX9m10ycs7/okwP4mozo9cMTCcUbqEnxR2BrCWhoLI+K6uixomLyx73iAukoEvAhgITGlwX1Hk63g9HQFC9WPcc4HaDKrL32A55BmtwLsL8GsNU5sRA+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(9686003)(2906002)(33656002)(110136005)(54906003)(26005)(478600001)(71200400001)(52536014)(7696005)(55016002)(7416002)(316002)(64756008)(66476007)(76116006)(66446008)(66556008)(66946007)(8676002)(6506007)(186003)(53546011)(4326008)(5660300002)(8936002)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: c3UAO05NQMcdQsyM3adT77WyzD/x9wFxh90MJwygxMfAYFCyV0/BoMXd6vSEKWPwoe7BnjGU6DEJ/ddrzPXNBabNziXC5JVyJ+Pz6G6CGNPwmSuh8X6q6zyv19WkNHnmX2j9w00yxqesJGCRZcYdAcIm4rW0cN4B0UCtnkmSlwMBnkfJlrnKvv7WNXVrqOqdyW937qL8PacQPf+2seVCluojH3oMHisek8Ebhh4OIWY72b5vAJWAcL4bevcm0ZdUL5Pr3/UZJmHdzfNI6vzQ6hP6xvyrwthIyhqKK9X51P0LFiBlbyiTQ3XAD7QFnhjusYJIFUuhzOMOEZwUF+MCG0x4dipU5ZPSw6fcYuh9ckn0sPIiyOUrCEnyzf8hIZ72MtPMWOPpUi/yxdu9g1pDZNUwC/ps0x8YCe/1ifS+8VKynn4kQGmBauEIWx7JFFP+xPaHnyMV5RRD9R6b04WFL3UI68khthraf0uPmHhNv2rQWgUmtFtbdtjYU+l6WyBKbrVUoO1fLWVRQ0b+dq1AlJpK+f3SCFZTLkKMr3S8oxjs2nsQ62qiAEjGi11swk0e9HNbdpE3D7ZlJbC8ij9L9MumPpu3pMe+7Qq6chmh62h+BkT5xs9HlW/vslriNislSYk9Z4drsDzsLC8Flv4/Tg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d17c1f-dd11-4e0a-2aea-08d86bb5d39c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 18:13:15.5315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: anGKgnh9IVTVk1C+07sqlrJaymDs1mDYPSt3YtlRdAZpGqPi1JUTGcrvJjOQClibYhLhKF8wziMLSxTCNzWWevfLJ2sXxHmkpdsVf7Pjcz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2282
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYXJhdiBQYW5kaXQgPHBhcmF2
QG52aWRpYS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDgsIDIwMjAgMTA6MzUgQU0N
Cj4gVG86IEVydG1hbiwgRGF2aWQgTSA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPjsgUGllcnJl
LUxvdWlzIEJvc3NhcnQNCj4gPHBpZXJyZS1sb3Vpcy5ib3NzYXJ0QGxpbnV4LmludGVsLmNvbT47
IExlb24gUm9tYW5vdnNreQ0KPiA8bGVvbkBrZXJuZWwub3JnPg0KPiBDYzogYWxzYS1kZXZlbEBh
bHNhLXByb2plY3Qub3JnOyBwYXJhdkBtZWxsYW5veC5jb207IHRpd2FpQHN1c2UuZGU7DQo+IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IHJhbmphbmkuc3JpZGhhcmFuQGxpbnV4LmludGVsLmNvbTsN
Cj4gZnJlZC5vaEBsaW51eC5pbnRlbC5jb207IGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnOw0K
PiBkbGVkZm9yZEByZWRoYXQuY29tOyBicm9vbmllQGtlcm5lbC5vcmc7IEphc29uIEd1bnRob3Jw
ZQ0KPiA8amdnQG52aWRpYS5jb20+OyBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZzsga3ViYUBr
ZXJuZWwub3JnOyBXaWxsaWFtcywNCj4gRGFuIEogPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT47
IFNhbGVlbSwgU2hpcmF6DQo+IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IFBhdGlsLCBLaXJhbg0KPiA8a2lyYW4ucGF0aWxAaW50ZWwuY29tPg0KPiBTdWJq
ZWN0OiBSRTogW1BBVENIIHYyIDEvNl0gQWRkIGFuY2lsbGFyeSBidXMgc3VwcG9ydA0KPiANCj4g
DQo+IA0KPiA+IEZyb206IEVydG1hbiwgRGF2aWQgTSA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29t
Pg0KPiA+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDgsIDIwMjAgMTA6MjQgUE0NCj4gDQo+ID4g
PiBGcm9tOiBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5jb20+DQo+ID4gPiBTZW50OiBXZWRu
ZXNkYXksIE9jdG9iZXIgNywgMjAyMCA5OjU2IFBNDQo+IA0KPiANCj4gPiA+IC8qKg0KPiA+ID4g
ICogYW5jaWxsYXJfZGV2aWNlX3JlZ2lzdGVyKCkgLSByZWdpc3RlciBhbiBhbmNpbGxhcnkgZGV2
aWNlDQo+ID4gPiAgKiBOT1RFOiBfX25ldmVyIGRpcmVjdGx5IGZyZWUgQGFkZXYgYWZ0ZXIgY2Fs
bGluZyB0aGlzIGZ1bmN0aW9uLCBldmVuDQo+ID4gPiBpZiBpdCByZXR1cm5lZA0KPiA+ID4gICog
YW4gZXJyb3IuIEFsd2F5cyB1c2UgYW5jaWxsYXJ5X2RldmljZV9wdXQoKSB0byBnaXZlIHVwIHRo
ZQ0KPiA+ID4gcmVmZXJlbmNlIGluaXRpYWxpemVkIGJ5IHRoaXMgZnVuY3Rpb24uDQo+ID4gPiAg
KiBUaGlzIG5vdGUgbWF0Y2hlcyB3aXRoIHRoZSBjb3JlIGFuZCBjYWxsZXIga25vd3MgZXhhY3Rs
eSB3aGF0IHRvIGJlDQo+ID4gZG9uZS4NCj4gPiA+ICAqLw0KPiA+ID4gYW5jaWxsYXJ5X2Rldmlj
ZV9yZWdpc3RlcigpDQo+ID4gPiB7DQo+ID4gPiAJZGV2aWNlX2luaXRpYWxpemUoJmFkZXYtPmRl
dik7DQo+ID4gPiAJaWYgKCFkZXYtPnBhcmVudCB8fCAhYWRldi0+bmFtZSkNCj4gPiA+IAkJcmV0
dXJuIC1FSU5WQUw7DQo+ID4gPiAJaWYgKCFkZXYtPnJlbGVhc2UgJiYgIShkZXYtPnR5cGUgJiYg
ZGV2LT50eXBlLT5yZWxlYXNlKSkgew0KPiA+ID4gCQkvKiBjb3JlIGlzIGFscmVhZHkgY2FwYWJs
ZSBhbmQgdGhyb3dzIHRoZSB3YXJuaW5nIHdoZW4NCj4gPiByZWxlYXNlDQo+ID4gPiBjYWxsYmFj
ayBpcyBub3Qgc2V0Lg0KPiA+ID4gCQkgKiBJdCBpcyBkb25lIGF0IGRyaXZlcnMvYmFzZS9jb3Jl
LmM6MTc5OC4NCj4gPiA+IAkJICogRm9yIE5VTEwgcmVsZWFzZSBpdCBzYXlzLCAiZG9lcyBub3Qg
aGF2ZSBhIHJlbGVhc2UoKQ0KPiA+IGZ1bmN0aW9uLCBpdA0KPiA+ID4gaXMgYnJva2VuIGFuZCBt
dXN0IGJlIGZpeGVkIg0KPiA+ID4gCQkgKi8NCj4gPiA+IAkJcmV0dXJuIC1FSU5WQUw7DQo+ID4g
PiAJfQ0KPiA+IFRoYXQgY29kZSBpcyBpbiBkZXZpY2VfcmVsZWFzZSgpLiAgQmVjYXVzZSBvZiB0
aGlzIGNoZWNrIHdlIHdpbGwgbmV2ZXIgaGl0DQo+IHRoYXQNCj4gPiBjb2RlLg0KPiA+DQo+ID4g
V2UgZWl0aGVyIG5lZWQgdG8gbGVhdmUgdGhlIGVycm9yIG1lc3NhZ2UgaGVyZSwgb3IgaWYgd2Ug
YXJlIGdvaW5nIHRvIHJlbHkNCj4gb24NCj4gPiB0aGUgY29yZSB0byBmaW5kIHRoaXMgY29uZGl0
aW9uIGF0IHRoZSBlbmQgb2YgdGhlIHByb2Nlc3MsIHRoZW4gd2UgbmVlZCB0bw0KPiA+IGNvbXBs
ZXRlbHkgcmVtb3ZlIHRoaXMgY2hlY2sgZnJvbSB0aGUgcmVnaXN0cmF0aW9uIGZsb3cuDQo+ID4N
Cj4gWWVzLiBTaW5jZSB0aGUgY29yZSBpcyBjaGVja2luZyBpdCwgYW5jaWxsYXJ5IGJ1cyBkb2Vz
bid0IG5lZWQgdG8gY2hlY2sgaGVyZSBhbmQNCj4gcmVsZWFzZSBjYWxsYmFjayBjaGVjayBjYW4g
YmUgcmVtb3ZlZC4NCg0KV2lsbCBkbw0KDQo+IA0KPiA+IC1EYXZlRQ0K
