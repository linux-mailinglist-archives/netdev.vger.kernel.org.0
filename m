Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D8C2A8AFE
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 00:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733111AbgKEXst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 18:48:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:9640 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732975AbgKEXss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 18:48:48 -0500
IronPort-SDR: +gXu4TbNc1Kw6mZl42cwea7DuGm0ktWizE/E1cMA/wtWBxcOwy81aAqA1E7W9DPBWhAmhp+yj9
 OBmT61JbWYKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233645506"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="233645506"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 15:48:47 -0800
IronPort-SDR: IgZKlu3NBLuDhECIdEDYIGgjgXbtrSRJRBhddwQ971U84vqoLew/uYjnMDBv0LSVZ5rFMrXGFI
 V8WFYCcgEEBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="529614176"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 05 Nov 2020 15:48:46 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Nov 2020 15:48:45 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Nov 2020 15:48:45 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Nov 2020 15:48:45 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 5 Nov 2020 15:48:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7nK0JPNNkcIJqio2b2JdFwXyx6MA/gfkVK2fGknITphk5+2FbeqyqRQ6Hfe7a824MuFH7xgsBARjJhzcxIkHQxuLyfh/l1fWdtvidLM67Ou2d9JHPyWVvmAumqtB/CzolXZSYehVNYL4y0xxS0uU/G/X1o9CEbO6dx3N5JoIPjzutXPuvep9l0VfRxkJuDOlX4hyX1Y1LQJ3NjuFcjHA+uwwNj4fkQFwzzmjJH8Uek9ZXvIEFq6SL4tCcAPJkR2qMBomGfs6Clh4yG+ocPOMUsNfec2YphX18tVM5+IniE7qfGjIoq5Bt/zLdQrbPHwqX0WVjUagoxHWDXsXmVFkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAnt8hwyLj0m1seARPSpsHWo09MkNJdkAsiPPsFOu2Y=;
 b=k0LorNsI9FMuSyRv51a4UymdxKY5D8ZCoaFYUi6JlorrPnJXsMH384K7JtAPJNcuXD5Qc9m9UF61nc59ilixmWpuzEC0RAEgZxMpDtjGaXnd2OpNjTOBDj36miuhiLGl942lm4uuYBRJxZwSskziABAXcz3s8SEEkynpynZrY/y6rrV5Si1knIVR0IbpXcL+/wKxpAWIT0uFSIqFF3ybwKjhLZt2H4PAFbgKNVcjfTTU3o7XMSfmLFbJPoXXw4zUpeVLB2PCrOw+eLHrjPz+fLsJlQPjII0boGaLX95IVRQ/SwZT14gpPvQBoKoqNgNl3zSYZX3twWIEjgTO33uCEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAnt8hwyLj0m1seARPSpsHWo09MkNJdkAsiPPsFOu2Y=;
 b=wv9Y1dXiE2h3gtWgu2eNhHUv8b4Yq4mwltnc6Oe9MRw8pnmQKnw12l+iee7dS5n4m1EDmgBf2blqoJECg6WBd3jiuQL1F/7ncyOWOl7toxgK6CUv+lCPzZt5uuLaRf7eeEr6G89BpilAHH0TIOf2GBldZJ36WoXRs3T5Q7MOchQ=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM5PR11MB0060.namprd11.prod.outlook.com (2603:10b6:4:63::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Thu, 5 Nov 2020 23:48:41 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3541.021; Thu, 5 Nov 2020
 23:48:41 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: RE: [PATCH v3 01/10] Add auxiliary bus support
Thread-Topic: [PATCH v3 01/10] Add auxiliary bus support
Thread-Index: AQHWqNRxbABQ//8l1UOfD+CnDPwsEKm5V8WAgACIGmCAAEx7AIAAHiIA
Date:   Thu, 5 Nov 2020 23:48:40 +0000
Message-ID: <DM6PR11MB28417902253469FC9ABB72F0DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <CAPcyv4hjCmaCEUhgchkJO7WaGQeTz8gtS2YgMtBAvoGBksvvSg@mail.gmail.com>
In-Reply-To: <CAPcyv4hjCmaCEUhgchkJO7WaGQeTz8gtS2YgMtBAvoGBksvvSg@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: fe9c1498-9e6c-4c79-dbfc-08d881e552df
x-ms-traffictypediagnostic: DM5PR11MB0060:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB006059C4B948C4A6A874D75FDDEE0@DM5PR11MB0060.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +CggJKR92QjjHvOkqWPj4275nvGf4AOv3tggZCmFhSkLsAcKuchdO5Tyo5Juq8XkyYab+y+VglMiW5igBOPHdYOMHSxFrLX1nmKz3zvPusFMEvgBrR4SS5n3UzooTPVKtuoOj2xA0Kj+u71hIiltSMbZpodxsIEGIRTJ6PBgF4ejD3T3+4O55YElJBYYzubQFmxUQOCBuJQGSxzj+9lMI+aB/lqgNSMPmYrC4sREd/mpFEQximF6nP1qpg4zUgeaX0AH+zUyNCQP3bbGa56QyoLHH0AOUHie8lB09u3BfGsQXXyvlImf43yGe2Ba9qMTRVwwgHIgPjYWwoCsbar2CA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(9686003)(6636002)(52536014)(2906002)(6862004)(7416002)(8676002)(7696005)(8936002)(86362001)(55016002)(5660300002)(478600001)(76116006)(64756008)(186003)(66556008)(66476007)(71200400001)(54906003)(66946007)(6506007)(53546011)(26005)(66446008)(316002)(33656002)(83380400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: WKhvrlhjBwzr9EneFOdQLkVrA5PA7DmRBD4O6IkQ1S5Tl02i2ExtpeOj6BoGf/rVmJftutjw1CW9cJSrvrv8dHsLTRb2EcRGEQLKSZveXVUTYaTMW1kNXKEwJCBh72DYCeoQj7gu5PYj3QyKbJgSoh5fDZyC8DDXM07euStZgx7XFWDer/tII87eLrLGCpnGKZeJOTwFxJMbkyvYjfw5J6dimqt7ZxVQYmqLar4psYm+UrR7VLA7E39bFMbYtJ9p3xD3FAPic73oq+uUo6lsSxJvepzwQAQaSVQA0E1wL4oOe+csAN09DImR9+qXRc5A/Wc1BqdQr36W2Ykl1ROPkFD7LUHWfoStg6lpk5K913Dm5FiAwsJiabYTu+Env6Lepebea18DVHuJHd9F2IZnDR9JppfGGXnejkjGXHK4aKjlI3ibZ6VMRPWLIxubpKnEOmawwPDqxIgrXzMk42tbBdlcSkWSPBWlX0uFWDyjiqgaEprEmCcD67TBQVLEs2pBSH0bV0hZ0IOUb0ZwoMBf7dWndrIhzrv9muOm+RrDyplZBrtH2NXSmLDfNVcc/C2hceTUqt3nmjRv1GbvZXsXFJZy3lYljehbF37E1EbyFoQPzC7+06MxGF17uqMhBuL0KXTaftRgxz3bAsa28BrgOA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9c1498-9e6c-4c79-dbfc-08d881e552df
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2020 23:48:40.9702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LHpMTdU7eziye97gEkO/FlUTob91nnI9QVCUlKMlsSi5cPrLWI48RJCDpiNWDyNNbHp0/3lp64j2+s1HYt89Hvigkn4YArsaF5ij0dWkbmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0060
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5q
LndpbGxpYW1zQGludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDUsIDIwMjAg
MjowMCBQTQ0KPiBUbzogRXJ0bWFuLCBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+
DQo+IENjOiBhbHNhLWRldmVsQGFsc2EtcHJvamVjdC5vcmc7IFRha2FzaGkgSXdhaSA8dGl3YWlA
c3VzZS5kZT47IE1hcmsgQnJvd24NCj4gPGJyb29uaWVAa2VybmVsLm9yZz47IGxpbnV4LXJkbWEg
PGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnPjsgSmFzb24NCj4gR3VudGhvcnBlIDxqZ2dAbnZp
ZGlhLmNvbT47IERvdWcgTGVkZm9yZCA8ZGxlZGZvcmRAcmVkaGF0LmNvbT47DQo+IE5ldGRldiA8
bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD47DQo+IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBHcmVnIEtIIDxncmVna2hA
bGludXhmb3VuZGF0aW9uLm9yZz47DQo+IFJhbmphbmkgU3JpZGhhcmFuIDxyYW5qYW5pLnNyaWRo
YXJhbkBsaW51eC5pbnRlbC5jb20+OyBQaWVycmUtTG91aXMgQm9zc2FydA0KPiA8cGllcnJlLWxv
dWlzLmJvc3NhcnRAbGludXguaW50ZWwuY29tPjsgRnJlZCBPaCA8ZnJlZC5vaEBsaW51eC5pbnRl
bC5jb20+Ow0KPiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT47IFNhbGVlbSwgU2hp
cmF6DQo+IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47IFBhdGlsLCBLaXJhbiA8a2lyYW4ucGF0
aWxAaW50ZWwuY29tPjsgTGludXgNCj4gS2VybmVsIE1haWxpbmcgTGlzdCA8bGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZz47IExlb24gUm9tYW5vdnNreQ0KPiA8bGVvbnJvQG52aWRpYS5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjMgMDEvMTBdIEFkZCBhdXhpbGlhcnkgYnVzIHN1cHBv
cnQNCj4gDQo+IE9uIFRodSwgTm92IDUsIDIwMjAgYXQgMTE6MjggQU0gRXJ0bWFuLCBEYXZpZCBN
DQo+IDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+IHdyb3RlOg0KPiBbLi5dDQo+ID4gPiA+IEVh
Y2ggYXV4aWxpYXJ5X2RldmljZSByZXByZXNlbnRzIGEgcGFydCBvZiBpdHMgcGFyZW50DQo+ID4g
PiA+ICtmdW5jdGlvbmFsaXR5LiBUaGUgZ2VuZXJpYyBiZWhhdmlvciBjYW4gYmUgZXh0ZW5kZWQg
YW5kIHNwZWNpYWxpemVkIGFzDQo+ID4gPiBuZWVkZWQNCj4gPiA+ID4gK2J5IGVuY2Fwc3VsYXRp
bmcgYW4gYXV4aWxpYXJ5X2RldmljZSB3aXRoaW4gb3RoZXIgZG9tYWluLXNwZWNpZmljDQo+ID4g
PiBzdHJ1Y3R1cmVzIGFuZA0KPiA+ID4gPiArdGhlIHVzZSBvZiAub3BzIGNhbGxiYWNrcy4gRGV2
aWNlcyBvbiB0aGUgYXV4aWxpYXJ5IGJ1cyBkbyBub3Qgc2hhcmUgYW55DQo+ID4gPiA+ICtzdHJ1
Y3R1cmVzIGFuZCB0aGUgdXNlIG9mIGEgY29tbXVuaWNhdGlvbiBjaGFubmVsIHdpdGggdGhlIHBh
cmVudCBpcw0KPiA+ID4gPiArZG9tYWluLXNwZWNpZmljLg0KPiA+ID4NCj4gPiA+IFNob3VsZCB0
aGVyZSBiZSBhbnkgZ3VpZGFuY2UgaGVyZSBvbiB3aGVuIHRvIHVzZSBvcHMgYW5kIHdoZW4gdG8g
anVzdA0KPiA+ID4gZXhwb3J0IGZ1bmN0aW9ucyBmcm9tIHBhcmVudCBkcml2ZXIgdG8gY2hpbGQu
IEVYUE9SVF9TWU1CT0xfTlMoKQ0KPiBzZWVtcw0KPiA+ID4gYSBwZXJmZWN0IGZpdCBmb3IgcHVi
bGlzaGluZyBzaGFyZWQgcm91dGluZXMgYmV0d2VlbiBwYXJlbnQgYW5kIGNoaWxkLg0KPiA+ID4N
Cj4gPg0KPiA+IEkgd291bGQgbGVhdmUgdGhpcyB1cCB0aGUgZHJpdmVyIHdyaXRlcnMgdG8gZGV0
ZXJtaW5lIHdoYXQgaXMgYmVzdCBmb3IgdGhlbS4NCj4gDQo+IEkgdGhpbmsgdGhlcmUgaXMgYSBw
YXRob2xvZ2ljYWwgY2FzZSB0aGF0IGNhbiBiZSBhdm9pZGVkIHdpdGggYQ0KPiBzdGF0ZW1lbnQg
bGlrZSB0aGUgZm9sbG93aW5nOg0KPiANCj4gIk5vdGUgdGhhdCBvcHMgYXJlIGludGVuZGVkIGFz
IGEgd2F5IHRvIGF1Z21lbnQgaW5zdGFuY2UgYmVoYXZpb3INCj4gd2l0aGluIGEgY2xhc3Mgb2Yg
YXV4aWxpYXJ5IGRldmljZXMsIGl0IGlzIG5vdCB0aGUgbWVjaGFuaXNtIGZvcg0KPiBleHBvcnRp
bmcgY29tbW9uIGluZnJhc3RydWN0dXJlIGZyb20gdGhlIHBhcmVudC4gQ29uc2lkZXINCj4gRVhQ
T1JUX1NZTUJPTF9OUygpIHRvIGNvbnZleSBpbmZyYXN0cnVjdHVyZSBmcm9tIHRoZSBwYXJlbnQg
bW9kdWxlIHRvDQo+IHRoZSBhdXhpbGlhcnkgbW9kdWxlKHMpLiINCj4gDQo+IEFzIGZvciB5b3Vy
IG90aGVyIGRpc3Bvc2l0aW9ucyBvZiB0aGUgZmVlZGJhY2ssIGxvb2tzIGdvb2QgdG8gbWUuDQoN
Ckkgd2lsbCBhZGQgdGhpcyBpbi4NCg0KLURhdmVFDQo=
