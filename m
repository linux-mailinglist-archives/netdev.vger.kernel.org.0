Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA9F253A39
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgHZWXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:23:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:64779 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgHZWXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 18:23:51 -0400
IronPort-SDR: Uk9w46LtnSO8YTN5LDQYldXTWJ/iWReOO+xgMYow3HvS8njRbgcfpHOj4lf7RZO01vf4Ae5Sim
 V2/vHCsyy6IQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="217941314"
X-IronPort-AV: E=Sophos;i="5.76,357,1592895600"; 
   d="scan'208";a="217941314"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 15:23:48 -0700
IronPort-SDR: JhngNHuMueBazIyDEueXTWCsYQ4Sb0Y5XGAteyjDXF1dIuPUsYNU0SnYIq8U2fT1SaIdZzfJQz
 kIuLj6A8mVgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,357,1592895600"; 
   d="scan'208";a="500411192"
Received: from fmsmsx601-2.cps.intel.com (HELO fmsmsx601.amr.corp.intel.com) ([10.18.84.211])
  by fmsmga005.fm.intel.com with ESMTP; 26 Aug 2020 15:23:48 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 26 Aug 2020 15:23:48 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Aug 2020 15:23:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 26 Aug 2020 15:23:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jfqm5lF2ssRy0aEXICW14q+mYFVPi2niS5nc8OT/IfLBPkUAGAD18VsEgKVZjsLnfFDrsXAr8U4v6YCOEiGKwVyDOwradRvRF/E8krkMNTzJOv+yUsml8/AdH1kaAugKazBNF5VTgsykW7py6wvrLjcp9R6puLbzYIbT5mgNcEpQg2yJ4WDZ0+8CxTNVIvgPmxZeDYqXNbTzdY08/iTcVFcQX75kz9wyIMTuWaYhWx+w2zb67zshFbE8n0H2r8QwYqE72k3LaSKhD5B3rtRy70GKw8/i/zKN3S+8Dx9jaks9nEIZkie6mcCHmR5MixCh8Xqw6m6nywT70qlqR+EmbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8Mhp92iH8ep7vrgoD/Agv0ELP2uJV0bFbzgxTF/ovE=;
 b=lV81TZLmHVA1vCT18zmvMKfko7lmbOySN/iOvt0YUCj+e82Q8yQr42GOxmkUzrUy6nlad9N+fLYGuyVy7/vfqhm0bGBjzUbi721uNSOxOGEoXgIrCgtzhCjxZfRNfMI0zqhYGPZdbQbu5F2Npem/zvm2rVJbicYmB/NkuqtOoxuiClAhh87wCu5PR5HPMudC3Ggws6VzH/zyAus75jvjemVYF8A+u+aHXtHT0uSQOWBRFXz/ecMRDyEknzualwj2aGXRcRECCmvA32wh0/NM3mN1rqzC+uvFkRY3Hrd0GFT3pq9HFv8APRbgcda0N8jKV7OPfGhd8WeD4AceBcvWtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8Mhp92iH8ep7vrgoD/Agv0ELP2uJV0bFbzgxTF/ovE=;
 b=IngFmzSRwakPuryd+BXugFCROx9ZC//v4NCEBpZO81OSo6Fs++mAmNbSyDivLtM7oa02hBEkzsgJrwn4ROE9tvBz5KoyB6JVd+Q6Kl51dJCdE/iO6a6UIqGZjY6qpFJ1XZWbZNVX9jGg1Crz6mlDESeJUjZWYZingfWSMmhAadw=
Received: from MN2PR11MB4221.namprd11.prod.outlook.com (2603:10b6:208:18d::14)
 by MN2PR11MB4600.namprd11.prod.outlook.com (2603:10b6:208:26e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 26 Aug
 2020 22:23:45 +0000
Received: from MN2PR11MB4221.namprd11.prod.outlook.com
 ([fe80::a05a:b1e8:cf3a:db3c]) by MN2PR11MB4221.namprd11.prod.outlook.com
 ([fe80::a05a:b1e8:cf3a:db3c%6]) with mapi id 15.20.3305.031; Wed, 26 Aug 2020
 22:23:45 +0000
From:   "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To:     Shannon Nelson <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Subject: RE: [RFC PATCH net-next 0/2] Granular VF Trust Flags for SR-IOV
Thread-Topic: [RFC PATCH net-next 0/2] Granular VF Trust Flags for SR-IOV
Thread-Index: AQHWd1nEhIafTA9zxEaqwCsXoznhG6lJC7MAgAAEw/A=
Date:   Wed, 26 Aug 2020 22:23:45 +0000
Message-ID: <MN2PR11MB422120B08EC5537084B494F1E3540@MN2PR11MB4221.namprd11.prod.outlook.com>
References: <159797251668.773633.8211193648312545241.stgit@cmw-fedora32-wp.jf.intel.com>
 <f2105737-007d-35f6-426d-ba72df029c13@pensando.io>
In-Reply-To: <f2105737-007d-35f6-426d-ba72df029c13@pensando.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: pensando.io; dkim=none (message not signed)
 header.d=none;pensando.io; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.46.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dba3ca09-2723-463b-789b-08d84a0eb284
x-ms-traffictypediagnostic: MN2PR11MB4600:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4600138BE2DBE20DB539BE5DE3540@MN2PR11MB4600.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gVicPOMt1eoodT32zmIk0RPqsEq3B1OjnT0PVxvsW5yNjff9fu1rHEBEONNVrLk25546ZtWtvIVIxpRkJkRgiaVmzLlHPs2U+3hcf31W005Y2InMOAoUIg1+zSowNXt2pVYW/imVx/eMDBNITMF2OWhH4X0adr8Tjohi9aJErM+4s6UsM+SzVXoiSqsTK6Qj5MIskBeDJnZPQdDrXNx5QwOyF6ECAAdXRHoaLpD/U1nIIyRl+SUsetggCgFdi4D8cOFmHc+nBvO69lMt1f/cRhl/E63nesB5RqsUtB+CJnd4M0BCW6MdIRDvBjng3RibmN56X70Wz/gPC+SHPjFClg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(71200400001)(9686003)(5660300002)(107886003)(33656002)(6506007)(53546011)(83380400001)(55016002)(478600001)(52536014)(66556008)(54906003)(64756008)(8676002)(2906002)(8936002)(186003)(66476007)(76116006)(66446008)(26005)(66946007)(86362001)(7696005)(316002)(110136005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: lY9abj80zJGnc1o6JVruNlwlkKSdJzoyaLavSy+qdLqiwATVFAbWw4uGS9ndZm7EXqHdmYzz0Y12Uj+zYsVYXAf9jupL7zWvopz2woxKVsQjHfJMzWBmqCaX+IWPho8mGyed8bmO7LGlfWSa3Xj0G/NYl1df/6LkwByvlD/PEL7ewQjpC7JYsmwJYBoPYUUsamjzjquuNl4vL7WC9liEvZIJAo1KoApK5BRIZnmxZa4dQY6W97xBHpWd19SWCJtDR9TPVaaZrz84VaDC25cDy6Sh+2yDjwv3lXT0T7uu5IRO6Plerppo8uCbJKDK+bHnkqQ2xc0QwGc8Iy101oREKBwxSwsTNX5pS+TcGo7ScY5wUiMt/1gdeeZxZWkF0MbwvgjYoFFj5v9elITfQQb8hNKRBEquQ41ziYccOLlasRqDg2HYHQC7lPt8HdwSPT27VLr6vmGmhRJ7k/BxZddDowp/IGIPNYpu9w+zKtBbuUvcZsj8nP+DEm7E3JgQG306iq2mNdGOtBzE9ifq5+82RLZhw+qAtzU1bqaqaQJKI9k071Anczdx3XDJVYj61SH+VJBVpiH6pGNLT/dkHcfuwdcsYfQpZpLDyVoYclFeXme+a9WAUrxoXbGxxasrRKGF2wLS22agynJyOBH/HkZGog==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba3ca09-2723-463b-789b-08d84a0eb284
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 22:23:45.6819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j8ym0DO2wO24qbxvRwIPAJZvgguOc8oNuRXffBZp/EdY91Ac7Q5Xq7zfIyQdYT2jmIY/oDCjJqEXc1tWlUOWbbRHVlvdoqKuZ/39MmtSizE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4600
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTaGFubm9uIE5lbHNvbiA8c25l
bHNvbkBwZW5zYW5kby5pbz4NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDI1LCAyMDIwIDk6MzIg
QU0NCj4gVG86IFd5Ym9ybnksIENhcm9seW4gPGNhcm9seW4ud3lib3JueUBpbnRlbC5jb20+Ow0K
PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJh
QGtlcm5lbC5vcmc7IEJyYW5kZWJ1cmcsIEplc3NlDQo+IDxqZXNzZS5icmFuZGVidXJnQGludGVs
LmNvbT47IEhlcmJlcnQsIFRvbSA8dG9tLmhlcmJlcnRAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBS
ZTogW1JGQyBQQVRDSCBuZXQtbmV4dCAwLzJdIEdyYW51bGFyIFZGIFRydXN0IEZsYWdzIGZvciBT
Ui1JT1YNCj4gDQo+IA0KPiANCj4gT24gOC8yMC8yMCA2OjE2IFBNLCBDYXJvbHluIFd5Ym9ybnkg
d3JvdGU6DQo+ID4gUHJvcG9zYWwgZm9yIEdyYW51bGFyIFZGIFRydXN0IEZsYWdzIGZvciBTUi1J
T1YNCj4gPg0KPiA+IEkgd291bGQgbGlrZSB0byBwcm9wb3NlIGV4dGVuZGluZyB0aGUgY29uY2Vw
dCBvZiBWRiB0cnVzdCBpbiBhIG1vcmUNCj4gPiBncmFudWxhciB3YXkgYnkgY3JlYXRpbmcgVkYg
dHJ1c3QgZmxhZ3MuIFZGIFRydXN0IEZsYWdzIHdvdWxkIGFsbG93IG1vcmUNCj4gPiBmbGV4aWJp
bGl0eSBpbiBhc3NpZ25pbmcgcHJpdmlsZWdlcyB0byBWRidzIGFkbWluaXN0cmF0aXZlbHkgaW4g
U1ItSU9WLg0KPiA+IFVzZXJzIGFyZSBhc2tpbmcgZm9yIG1vcmUgY29uZmlndXJhdGlvbiB0byBi
ZSBhdmFpbGFibGUgaW4gdGhlIFZGLg0KPiA+IEZlYXR1cmVzIGZvciBvbmUgdXNlIGNhc2UgbGlr
ZSBhIGZpcmV3YWxsIGFyZSBub3QgYWx3YXlzIHdhbnRlZCBpbiBhDQo+ID4gZGlmZmVyZW50IHR5
cGUgb2YgcHJpdmlsZWdkIFZGLiAgSWYgYSBiYXNlIHNldCBvZiBnZW5lcmljIHByaXZpbGVnZXMg
Y291bGQgYmUNCj4gPiBjb25maWd1cmVkIGluIGEgbW9yZSBncmFudWxhciB3YXksIHRoZXkgY2Fu
IGJlIGNvbWJpbmVkIGluIGEgbW9yZSBmbGV4aWJsZQ0KPiA+IHdheSBieSB0aGUgdXNlci4NCj4g
Pg0KPiA+IFRoZSBpbXBsZW1lbnRhdGlvbiB3b3VsZCBkbyB0aGlzIGJ5IGJ5IGFkZGluZyBhIG5l
dyBpZmxhdHRyaWJ1dGUgZm9yIHRydXN0DQo+ID4gZmxhZ3Mgd2hpY2ggZGVmaW5lcyB0aGUgZmxh
Z3MgaW4gYW4gbmxhX2JpdGZpZWxkMzIuICBUaGUgY2hhbmdlcyBgd291bGQNCj4gPiBhbHNvIGlu
Y2x1ZGUgY2hhbmdlcyB0byAubmRvX3NldF92Zl90cnVzdCBwYXJhbWV0ZXJzLCBkaWZmZXJlbnQg
b3INCj4gY29udmVydGVkDQo+ID4gc2V0dGluZ3MgaW4gLm5kb19nZXRfdmZfY29uZmlnLCBrZXJu
ZWwgdmFsaWRhdGlvbiBvZiB0aGUgdHJ1c3QgZmxhZ3MgYW5kDQo+ID4gZHJpdmVyIGNoYW5nZXMg
Zm9yIHRob3NlIHRoYXQgaW1wbGVtZW50IC5uZG9fc2V0X3ZmX3RydXN0LiBUaGVyZSB3aWxsIGFs
c28NCj4gPiBiZSBjaGFuZ2VzIHByb3Bvc2VkIGZvciBpcCBsaW5rIGluIHRoZSBpcHJvdXRlMiB0
b29sc2V0Lg0KPiA+DQo+ID4gVGhpcyBwYXRjaHNldCBwcm92aWRlcyBhbiBleGFtcGxlIGltcGxl
bWVudGF0aW9uIHRoYXQgaXMgbm90IGNvbXBsZXRlLg0KPiA+IEl0IGRvZXMgbm90IGluY2x1ZGUg
dGhlIGZ1bGwgdmFsaWRhdGlvbiBvZiB0aGUgZmVhdHVyZSBmbGFncyBpbiB0aGUga2VybmVsLA0K
PiA+IGFsbCB0aGUgaGVscGVyIG1hY3JvcyBsaWtlbHkgbmVlZGVkIGZvciB0aGUgdHJ1c3QgZmxh
Z3Mgbm9yIGFsbCB0aGUgZHJpdmVyDQo+ID4gY2hhbmdlcyBuZWVkZWQuIEl0IGFsc28gbmVlZHMg
YSBtZXRob2QgZm9yIGFkdmVydGlzaW5nIHN1cHBvcnRlZA0KPiBwcml2aWxlZ2VzDQo+ID4gYW5k
IHZhbGlkYXRpb24gdG8gZW5zdXJlIHVuc3VwcG9ydGVkIHByaXZpbGVnZXMgYXJlIG5vdCBiZWlu
ZyBzZXQuDQo+ID4gSXQgZG9lcyBoYXZlIGEgc2ltcGxlIGV4YW1wbGUgZHJpdmVyIGltcGxlbWVu
dGF0aW9uIGluIGlnYi4gIFRoZSBmdWxsDQo+ID4gcGF0Y2hzZXQgd2lsbCBpbmNsdWRlIGFsbCB0
aGVzZSB0aGluZ3MuDQo+ID4NCj4gPiBJJ2QgbGlrZSB0byBzdGFydCB0aGUgZGlzY3Vzc2lvbiBh
Ym91dCB0aGUgZ2VuZXJhbCBpZGVhIGFuZCB0aGVuIGJlZ2luIHRoZQ0KPiA+IGRpY3Vzc2lvbiBh
Ym91dCBhIGJhc2Ugc2V0IG9mIFZGIHByaXZsZWdlcyB0aGF0IHdvdWxkIGJlIGdlbmVyaWMgYWNy
b3NzIHRoZQ0KPiA+IGRldmljZSB2ZW5kb3JzLg0KPiA+DQo+ID4gLS0tDQo+IA0KPiBIaSBDYXJv
bHluLCB0aGFua3MgZm9yIHNlbmRpbmcgdGhpcyBvdXQsIGFuZCBmb3IgeW91ciBwcmVzZW50YXRp
b24gYXQNCj4gTmV0RGV2IGxhc3Qgd2Vlay7CoCBIZXJlIGFyZSBzb21lIGluaXRpYWwgdGhvdWdo
dHMgYW5kIHF1ZXN0aW9ucyBJIGhhZCB0bw0KPiBnZXQgdGhlIGRpc2N1c3Npb24gZ29pbmcuDQo+
IA0KPiBXb3VsZCB0aGlzIGV2ZXIgbmVlZCB0byBiZSBleHRlbmRlZCB0byB0aGUgc3ViLWZ1bmN0
aW9uIGRldmljZXMgKHNmKQ0KPiB0aGF0IHNvbWUgZGV2bGluayB0aHJlYWRzIGFyZSBkaXNjdXNz
aW5nPw0KDQpUaGFua3MgU2hhbm5vbiwNCg0KWWVzLCBpbiBzb21lIGZvcm0gYnV0IElJVUMsIHN1
YmZ1bmN0aW9ucyBhcmUgbm90IFNSLUlPViBhbmQgSSdtIG5vdCBleGFjdGx5IHN1cmUgb2YgdGhl
IGludGVyYWN0aW9uIGJldHdlZW4gdGhlbS4gIEkgcmVhbGl6ZSB0aGF0IG9yY2hlc3RyYXRpb24g
c29mdHdhcmUgYWxzbyBoYXMgdGhpcyBjb25jZXB0IG9mIHRydXN0L3ByaXZpbGVnZSBidXQgaXRz
IGhhbmRsZWQgYXQgYSBoaWdoZXIgbGF5ZXIgdGhhbiBTUi1JT1YuICBTbywgd2hpbGUgdGhpcyBw
cm9wb3NhbCBpcyBhIG5hcnJvdyBmb2N1cyBvbiBTUi1JT1Ygc3BlY2lmaWNhbGx5LCBJIHRoaW5r
IHRoaXMgaXMgYSBnb29kIHF1ZXN0aW9uLiAgUGVyaGFwcyBhbiBvdmVyYWxsIHNlY3VyaXR5IG1v
ZGVsIHNob3VsZCBiZSBkZXRhaWxlZCBvciBkZWZpbmVkIHdoZXJlIHRoZXJlIGFyZSBnYXBzIHRo
YXQgc2hvd3MgdGhlIHBpZWNlcyBhbmQgaG93IHRoZXkgZ28gdG9nZXRoZXIuICANCg0KPiANCj4g
V2hhdCB3b3VsZCB0aGUgdXNlci1sYW5kIHNpZGUgb2YgdGhpcyBsb29rIGxpa2U/wqAgV291bGQg
dGhpcyBiZSBhbg0KPiBleHRlbnNpb24gb2YgdGhlIGV4aXN0aW5nIGlwIGxpbmsgc2V0IGRldiA8
cGY+IHZmIDx2ZmlkPiA8YXR0cj4NCj4gPHZhbHVlPj/CoCBIb3cgd291bGQgdGhlc2UgYXR0cmli
dXRlcyBiZSBuYW1lZD8NClllcywgSSB3YXMgdGhpbmtpbmcgaXAgbGluayBzZXQgPHBmPiB2ZiA8
dmZpZD4gdHJ1c3QgdmFsIDx2YWw+LCBidXQgYW0gb3BlbiB0byBiZXR0ZXIgaWRlYXMuDQoNCj4g
DQo+IFdpbGwgZW5hYmxpbmcgdGhlIGxlZ2FjeSB0cnVzdCBpbmNsdWRlIHRydXN0aW5nIGFsbCBj
dXJyZW50IGFuZCBmdXR1cmUNCj4gdHJ1c3QgaXRlbXMsIG9yIHNob3VsZCBpdCBiZSBsaW1pdGVk
IHRvIHRoZSBjdXJyZW50IHNldD/CoCBJZiBsaW1pdGVkLA0KPiB0aGVuIHlvdSBtaWdodCBhZGQg
YSBtYWNybyBmb3IgVkZfVFJVU1RfRl9BTExfTEVHQUNZLsKgIE5vdCBzdXJlDQo+IHdoZXRoZXIN
Cj4gb3Igbm90IHRoaXMgd291bGQgYmUgYSBnb29kIHRoaW5nLg0KTXkgaW5pdGlhbCB0aGlua2lu
ZyB3YXMgdGhhdCBjdXJyZW50IHRvb2xzIHdvdWxkIHVzZSB0aGUgZmxhZ3MsIGV2ZW4gaWYgaXRz
IGxlZ2FjeSB0cnVzdCBhbmQgdGhlIHByb3ZpZGluZyBvZiBsZWdhY3kgdHJ1c3QgZnVuY3Rpb25h
bGl0eSB3b3VsZCBiZSBkb25lIGF0IHRoZSBkcml2ZXIgc2lkZS4gIEFueXRoaW5nIHVzaW5nIHRo
ZSBvbGQgbmxhX3ZmX3RydXN0IGF0dHJpYnV0ZSB3b3VsZCBuZWVkIHRoZSBjb3JyZWN0IGhhbmRs
aW5nIGluIHRoZSBkcml2ZXJzIHRvIHByb3ZpZGUgd2hhdCBsb29rcyBsaWtlIGxlZ2FjeSB0cnVz
dC4gIEFsc28sIGFueSB0cnVzdCBmbGFnIHNldCwgd291bGQgY2F1c2UgdGhlIG9sZCB0cnVzdCBz
ZXR0aW5nIHRvIGJlIGNvbmZpZ3VyZWQgaW4gb3JkZXIgdG8gcHJvdmlkZSB0aGUgbmVlZGVkIGJh
Y2t3YXJkcyBjb21wYXRpYmlsaXR5Lg0KDQo+IA0KPiBJbnN0ZWFkIG9mIFNQRkNIS19ESVMgb3Ig
InNwb29mY2hrX2Rpc2FibGUiIC0gY2FuIHdlIGdldCByZXBsYWNlIHRoZQ0KPiByZXZlcnNlIGxv
Z2ljIGFuZCByZW5hbWUgdGhlc2U/DQpTbywgdGhpcyBpcyBpbnRlbmRlZCBmb3IgdGhlIHByaXZp
bGVnZSB0byBkaXNhYmxlIHRoZSBzcG9vZmNoayBmZWF0dXJlLiAgSXTigJlzIGEgc2VjdXJpdHkg
ZmVhdHVyZSB0aGF0J3MgZW5hYmxlZCBieSBkZWZhdWx0LiAgSSdtIG9wZW4gdG8gcmVuYW1pbmcg
dGhvdWdoLiAgV2hhdCBkbyB5b3UgdGhpbmsgd291bGQgYmUgYmV0dGVyPyAgDQoNCj4gDQo+IFBl
cm1pc3Npb24gYml0cyBtaWdodCBiZSBuZWVkZWQgZm9yIGFsbG93aW5nIFJTUyBjb25maWd1cmF0
aW9uIGFuZA0KPiBiYW5kd2lkdGggbGltaXRzLg0KWWVzLCBhcyBTcmlqZWV0IG1lbnRpb25lZC4g
IENhbiBhZGQgdHdvIGZvciBSU1MgY29uZmlnIGFuZCBiYW5kd2lkdGggb24gdGhlIG5leHQgc3Vi
bWlzc2lvbi4NCj4gDQo+IFdpbGwgdGhlcmUgbmVlZCB0byBiZSBtb3JlIGdyYW51bGFyaXR5IGFy
b3VuZCB0aGUgQWR2YW5jZWQgRmxvdw0KPiBjb25maWd1cmF0aW9uIGFiaWxpdGllcz8NClRoaXMg
aXMgYSBnb29kIHF1ZXN0aW9uIGFuZCBhZnRlciBsb29raW5nIGFyb3VuZCBhdCB0aGUgb3RoZXIg
ZHJpdmVyJ3MgdXNlIG9mIHRoZSBvcmlnaW5hbCB0cnVzdCBmZWF0dXJlLCBJIHdhc24ndCBzdXJl
IGlmIHdlIG5lZWQganVzdCBvbmUgZmxhZyBoZXJlIG9yIG1vcmUuICBXaGF0IHdvdWxkIHlvdSBz
dWdnZXN0IGZyb20geW91ciBkZXZpY2UgcGVyc3BlY3RpdmU/DQoNCj4gDQo+IFNob3VsZCB0aGVy
ZSBiZSBwZXJtaXNzaW9uIGJpdHMgZm9yIGNoYW5naW5nIHNldHRpbmdzIGZvdW5kIGluDQo+IGV0
aHRvb2wtYmFzZWQgc2V0dGluZ3MgbGlrZSBsaW5rLWtzZXR0aW5ncywgY29hbGVzY2UsIHBhdXNl
LCBzcGVlZCwgZXRjPw0KSSB0aGluayBvbmNlIHdlIGhhdmUgdGhpcyBwcml2aWxlZ2Ugc2NoZW1l
IGltcGxlbWVudGVkLCBpdCBtaWdodCBtYWtlIHNlbnNlIHRvIGNvbnNpZGVyIHRoaXMuICBUaGlz
IGJyaW5ncyB1cCBhbm90aGVyIHBvdGVudGlhbCBwb2xpY3kgcXVlc3Rpb24gYXJvdW5kIFZGJ3Mg
a25vd2luZyB0aGVpciBjb25maWd1cmF0aW9uIG9yIG5vdC4gIEkgd291bGQgcHJlZmVyIHRvIGFs
bG93IGFkbWluJ3MgdG8gbWFrZSBwb2xpY3kgZGVjaXNpb25zIGJ1dCBpbiBhIHZpcnR1YWxpemVk
IHdvcmxkIHRoZXJlIGFyZSB0d28gbGF5ZXJzIG9mIGFkbWluLiAgTWF5YmUgaXRzIGJlc3QgdG8g
c3VwcG9ydCBib3RoIG1vZGVscy4gIA0KDQo+IA0KPiBIb3cgY2FuIHdlIGd1aWRlL21hbmFnZSB0
aGlzIHRvIGJlIHN1cmUgd2UgZG9uJ3QgZW5kIHVwIHdpdGggdmVuZG9ycw0KPiBwdXNoaW5nIGRl
dmljZSBzcGVjaWZpYyBwZXJtaXNzaW9uIGJpdHMgb3IgZmVhdHVyZSBlbmFibGluZyBiaXRzIHJh
dGhlcg0KPiB0aGFuIGdlbmVyaWMgcGVybWlzc2lvbnM/DQpJIHdhcyBob3BpbmcgdGhhdCB0aGUg
a2VybmVsIHN1Ym1pc3Npb24gcHJvY2VzcyB3b3VsZCBnZW5lcmljaXplIHRoZW0gZmxhZ3MgYnkg
ZGVmYXVsdCwgYnV0IHBlcmhhcHMgdGhhdCBvcHRpbWlzdGljLiAgSXMgdGhlcmUgYW5vdGhlciBm
ZWF0dXJlIG9yIHN5c3RlbSB0aGF0IGhhcyBzb2x2ZWQgdGhpcyBwb3RlbnRpYWwgcHJvYmxlbSBv
ciBkbyB3ZSBrZWVwIGNyZWF0aW5nIGl0IGZvciBvdXJzZWx2ZXM/ICAgIA0KDQo+IA0KPiBEbyB3
ZSByZWFsbHkgbmVlZCBhIHR5cGVkZWYgZm9yIHZmX3RydXN0X2ZsYWdzX3QsIG9yIGNhbiB3ZSBr
ZWVwIHdpdGggYQ0KPiBzaW1wbGUgdHlwZT8NClBvc3NpYmx5IG5vdCwgSSdtIG9wZW4gdG8gZGVz
aWduIHN1Z2dlc3Rpb25zLiAgSSB0aGluayB0aGUgYml0ZmllbGQgb3BzIGFuZCBoZWxwZXJzIGFy
ZSB0aGUgbW9yZSBpbXBvcnRhbnQgdGhpbmdzIHRvIGltcGxlbWVudCB3ZWxsLiAgDQoNClRoYW5r
cywNCg0KQ2Fyb2x5bg0KPiANCj4gQ2hlZXJzLA0KPiBzbG4NCg0K
