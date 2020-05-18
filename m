Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB4C1D8A33
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 23:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgERVnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 17:43:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:58969 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgERVnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 17:43:10 -0400
IronPort-SDR: sm3eTytFtLjuqdZWjCaItFSY/SObBsuRAzI1s8q3jYVVbsgdF78XMEgVaVD4qwiqNgPjho6PXw
 eP9rg3zRqjBA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 14:43:09 -0700
IronPort-SDR: HJ/ULQ/K1fJ0BMuFQ569kMwVHp9OSZfP3g4O5Xb+ogLoWPMD2w8Hc0ebi9K6ov0psiG6fVd+IJ
 YhCTdGlaarMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="465902653"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2020 14:43:09 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 18 May 2020 14:43:09 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 18 May 2020 14:43:08 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 18 May 2020 14:43:08 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.50) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 18 May 2020 14:43:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qnwpn065VfsNozquKx8bXULlGFucBjOH9aKQ9eKHSZ/SiLQZP28eQVHxdJI+VbDc36lsCZlqcMdBWumNsHv3sOnnxQ4nQ8OAHtcPnw6VkzDzqxZtKG8hGZdiKH+qTTRzBByskF0Mm7pV/z3+WLgr/+YpF9/+Shd5cy2o9gsWojLN6L2raItqSqzfiWB5dRD3vffaRCzmnFv6Zfg/byvZFpdw2Ce4ek8e3s/2kb8Th/BDzUO1af+TyxEQBwlEQcW/ABbTjdNbAq7gBbTXU5eYC+utUfQHjOuj/bKpGa4cqi955ArZuxVIomux/zQnQm5w4e4qnNawyjluxvoREUzQHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DvBZdcEY9qXzEjJgJCbn5o7XWSCIidZ0Epz3Vt7lXuk=;
 b=Mdb8ZflZfmY1XYoAGp/cHAP3jt3LWturpw9aE+aofUZTX1g5I3O0adf/X9Ll6WiOE2M6Bv8shFRLjv4X1a3VeY758NpTO/dVxK033mNux5WheK1dxJ90kS9WMUFkqztxXCI1SmKjqv+oUTlXuCdFdiwIDFloldyVo2amsRdHce8GcwYx0O6GXTLr0mNFeOSke0RCMUoDx/WZX/FV9YQ3nCuM0heHcKH/wzBHZ/oo/AiYZ9WFTr8dTxpWP703JXkbVTTfKPIWrvHnam7yIf4288FcpVgJDzWm87DFqBOfhjjxkpmZbCNDWKGIvqoIaS+Ta1IhHrPb8m+2pLHuwnYReg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DvBZdcEY9qXzEjJgJCbn5o7XWSCIidZ0Epz3Vt7lXuk=;
 b=IDUUdhUQNcNIfuc4U2J8JUWtnEzvYnV05Siy65PmOFf3fB1z/y/PySrtfqSwDRSojoBZQ+S8oTeVs+eqRnCn74qzfM6oOJzErk8BqtlHgbrS8ZEy2A32OtR6auaHnhw6WL7J/NdhMNCaJTsvqoVCD4eabcsW4SzuJEx5JomrMRU=
Received: from CY4PR11MB1799.namprd11.prod.outlook.com (2603:10b6:903:125::7)
 by CY4PR11MB1365.namprd11.prod.outlook.com (2603:10b6:903:22::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Mon, 18 May
 2020 21:43:04 +0000
Received: from CY4PR11MB1799.namprd11.prod.outlook.com
 ([fe80::109c:9a02:992b:b0a7]) by CY4PR11MB1799.namprd11.prod.outlook.com
 ([fe80::109c:9a02:992b:b0a7%12]) with mapi id 15.20.3000.034; Mon, 18 May
 2020 21:43:04 +0000
From:   "Schaufler, Casey" <casey.schaufler@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     James Morris <jamorris@linux.microsoft.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: RE: [PATCH] security: fix the default value of secid_to_secctx hook
Thread-Topic: [PATCH] security: fix the default value of secid_to_secctx hook
Thread-Index: AQHWKIVYU9SRjEtxq02Y3BoxruD5UKimRQCAgAG5zwCAAAFDgIAB0EIAgACQAwCABAiYMA==
Date:   Mon, 18 May 2020 21:43:04 +0000
Message-ID: <CY4PR11MB17990BA2B00B4CEB167057C9FDB80@CY4PR11MB1799.namprd11.prod.outlook.com>
References: <20200512174607.9630-1-anders.roxell@linaro.org>
 <CAADnVQK6cka9i_GGz3OcjaNiEQEZYwgCLsn-S_Bkm-OWPJZb_w@mail.gmail.com>
 <alpine.LRH.2.21.2005141243120.53197@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
 <CAADnVQJRsknY7+3zwXR-N4e6oC6E87Z32Msg4EXaM8iyB=R3qQ@mail.gmail.com>
 <CAADnVQ+WXa62R6A=nk1kOTbX8MqkbMEKDx=5KCdx5Th0NnFm7Q@mail.gmail.com>
 <CAK8P3a3CBtitXnzQf3gLx4mXuvDoVZiwwi33iCDNvtG-0jBSwQ@mail.gmail.com>
In-Reply-To: <CAK8P3a3CBtitXnzQf3gLx4mXuvDoVZiwwi33iCDNvtG-0jBSwQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0696a41-699a-4a7e-dcd0-08d7fb74723b
x-ms-traffictypediagnostic: CY4PR11MB1365:
x-microsoft-antispam-prvs: <CY4PR11MB1365FCB8CE85FAC1981F95B0FDB80@CY4PR11MB1365.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DNWgpN6Xr/ZaFwY1sMnYoZ9E1TWdeFC2bGpisC1+rShjc1If3J9BMokhivYagS3CbjdVoq5cN+6RhKEBh5XQX/7uJoLZLXBOk4bPa0QfZst5tEJLR/23VF3+pZHZRb0TPoWDdH6nDbjbU6/DyIg7+v1C7wzrZUCT36F4UFfd92hz8NhTNlVhgg92ei5AE33IMdAQtuHA1gjvRz1nkgvbVFFaIMeZnfOOvYzrO32zW1dTJ+Brg2qs/Y5UaARRcdMIb1AtQI9VtiQ5Z3Nsp9BRxIVORq3bLuTqa0jusEuavZ/LgzQAhlRM5HjFJ5ENWHS4cG1CYKFKsEyo3JuO9tKPGleWUM5KVLKJkmLhzKL0zkjXP0vjKMLzGKlC7mUPubgM0IqHSYilzOgb2RaNpB66ILEwaTZA2u1STJI8j89hTAWH0ziAp1JheBuiEmYS0zvR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1799.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(376002)(39860400002)(346002)(366004)(2906002)(4326008)(66946007)(66446008)(64756008)(66556008)(66476007)(76116006)(8936002)(5660300002)(478600001)(86362001)(53546011)(7696005)(6506007)(8676002)(71200400001)(110136005)(316002)(54906003)(15650500001)(186003)(26005)(33656002)(7416002)(9686003)(55016002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mbZS6ggiY5xNyJmijBOlV989MkRNYH3k1ewNRd4/rGeJ436YLZcsrIfYFXHNCVNHeqSOJ8pvz3YKcZOncGdAF069kK4WUOMLbEceikBNB3+I/67rScZ8w5sR7aOcNrddMGcbYEB3ULob4BEj9METdhc0SpTayM+PyWWaj1zcZot91s0EkjYh47Ka8KAQUodpSKhrhcJ7kOH/JOje8INbwjxf+pbQH4uO/gMF9+Z24F2mXgzff6aJXylDrFNNVXVhbYbGEavvDIp2hVFx3SYP+FxVY88LTPP/1UtRXQCzd9RuMyzHW7iKVomy1jV9WK9khH/IakM3ZShMQnCkO1ZvbIak9p/czw015QbyELazK0JHWSkyog5F9n0QxBdckv8mJeYwVYKJmttwfa55UnudGf/SIT6DkaQHuVLSMJYYIZlaiLn/JkJx3nXfRZKxljHCCxqhLQ7FITp6tSnX5QbWsw9DaIKT36kq2xPlmOC6/0Ef1o6UpIy1NrxY7zlVGqUl
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f0696a41-699a-4a7e-dcd0-08d7fb74723b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 21:43:04.5939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /kGcvgKFtgXktkCGIc26V1KiWrRQ3F36oBX66UfAcNinKJ2LDtWoWYZnsj/ujeOrMbRndqmWegyQDM/dAjV5Hdip2ixce2W7uMpTwCjnqBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1365
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1rZXJuZWwtb3duZXJA
dmdlci5rZXJuZWwub3JnIDxsaW51eC1rZXJuZWwtDQo+IG93bmVyQHZnZXIua2VybmVsLm9yZz4g
T24gQmVoYWxmIE9mIEFybmQgQmVyZ21hbm4NCj4gU2VudDogU2F0dXJkYXksIE1heSAxNiwgMjAy
MCAxOjA1IEFNDQo+IFRvOiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFsZXhlaS5zdGFyb3ZvaXRvdkBn
bWFpbC5jb20+DQo+IENjOiBKYW1lcyBNb3JyaXMgPGphbW9ycmlzQGxpbnV4Lm1pY3Jvc29mdC5j
b20+OyBBbmRlcnMgUm94ZWxsDQo+IDxhbmRlcnMucm94ZWxsQGxpbmFyby5vcmc+OyBBbGV4ZWkg
U3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPjsgRGFuaWVsDQo+IEJvcmttYW5uIDxkYW5pZWxA
aW9nZWFyYm94Lm5ldD47IExLTUwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiBO
ZXR3b3JrIERldmVsb3BtZW50IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgYnBmDQo+IDxicGZA
dmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBzZWN1cml0eTogZml4IHRo
ZSBkZWZhdWx0IHZhbHVlIG9mIHNlY2lkX3RvX3NlY2N0eCBob29rDQoNCkkgd291bGQgKnJlYWxs
eSogYXBwcmVjaWF0ZSBpdCBpZiBkaXNjdXNzaW9ucyBhYm91dCB0aGUgTFNNIGluZnJhc3RydWN0
dXJlDQp3aGVyZSBkb25lIG9uIHRoZSBsaW51eC1zZWN1cml0eS1tb2R1bGUgbWFpbCBsaXN0LiAo
YWRkZWQgdG8gQ0MpLg0KDQo+IA0KPiBPbiBTYXQsIE1heSAxNiwgMjAyMCBhdCAxOjI5IEFNIEFs
ZXhlaSBTdGFyb3ZvaXRvdg0KPiA8YWxleGVpLnN0YXJvdm9pdG92QGdtYWlsLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPiBPbiBUaHUsIE1heSAxNCwgMjAyMCBhdCAxMjo0NyBQTSBBbGV4ZWkgU3Rhcm92
b2l0b3YNCj4gPiA8YWxleGVpLnN0YXJvdm9pdG92QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gPg0K
PiA+ID4gT24gVGh1LCBNYXkgMTQsIDIwMjAgYXQgMTI6NDMgUE0gSmFtZXMgTW9ycmlzDQo+ID4g
PiA8amFtb3JyaXNAbGludXgubWljcm9zb2Z0LmNvbT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+
IE9uIFdlZCwgMTMgTWF5IDIwMjAsIEFsZXhlaSBTdGFyb3ZvaXRvdiB3cm90ZToNCj4gPiA+ID4N
Cj4gPiA+ID4gPiBKYW1lcywNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IHNpbmNlIHlvdSB0b29rIHRo
ZSBwcmV2aW91cyBzaW1pbGFyIHBhdGNoIGFyZSB5b3UgZ29pbmcgdG8gcGljayB0aGlzDQo+ID4g
PiA+ID4gb25lIHVwIGFzIHdlbGw/DQo+ID4gPiA+ID4gT3Igd2UgY2FuIHJvdXRlIGl0IHZpYSBi
cGYgdHJlZSB0byBMaW51cyBhc2FwLg0KPiA+ID4gPg0KPiA+ID4gPiBSb3V0aW5nIHZpYSB5b3Vy
IHRyZWUgaXMgZmluZS4NCj4gPiA+DQo+ID4gPiBQZXJmZWN0Lg0KPiA+ID4gQXBwbGllZCB0byBi
cGYgdHJlZS4gVGhhbmtzIGV2ZXJ5b25lLg0KPiA+DQo+ID4gTG9va3MgbGlrZSBpdCB3YXMgYSB3
cm9uZyBmaXguDQo+ID4gSXQgYnJlYWtzIGF1ZGl0IGxpa2UgdGhpczoNCj4gPiBzdWRvIGF1ZGl0
Y3RsIC1lIDANCj4gPiBbICAgODguNDAwMjk2XSBhdWRpdDogZXJyb3IgaW4gYXVkaXRfbG9nX3Rh
c2tfY29udGV4dA0KPiA+IFsgICA4OC40MDA5NzZdIGF1ZGl0OiBlcnJvciBpbiBhdWRpdF9sb2df
dGFza19jb250ZXh0DQo+ID4gWyAgIDg4LjQwMTU5N10gYXVkaXQ6IHR5cGU9MTMwNSBhdWRpdCgx
NTg5NTg0OTUxLjE5ODo4OSk6IG9wPXNldA0KPiA+IGF1ZGl0X2VuYWJsZWQ9MCBvbGQ9MSBhdWlk
PTAgc2VzPTEgcmVzPTANCj4gPiBbICAgODguNDAyNjkxXSBhdWRpdDogdHlwZT0xMzAwIGF1ZGl0
KDE1ODk1ODQ5NTEuMTk4Ojg5KToNCj4gPiBhcmNoPWMwMDAwMDNlIHN5c2NhbGw9NDQgc3VjY2Vz
cz15ZXMgZXhpdD01MiBhMD0zIGExPTdmZmU0MmEzNzQwMA0KPiA+IGEyPTM0IGEzPTAgaXRlbXM9
MCBwcGlkPTIyNTAgcGlkPTIyNTEgYXVpZD0wIHVpZD0wIGdpZD0wIGV1aWQ9MCBzdWlkPTANCj4g
PiBmc3VpZD0wIGVnaWQ9MCBzZ2lkPTAgZnNnaWQ9MCB0dHk9dHR5UzAgc2UpDQo+ID4gWyAgIDg4
LjQwNTU4N10gYXVkaXQ6IHR5cGU9MTMyNyBhdWRpdCgxNTg5NTg0OTUxLjE5ODo4OSk6DQo+ID4g
cHJvY3RpdGxlPTYxNzU2NDY5NzQ2Mzc0NkMwMDJENjUwMDMwDQo+ID4gRXJyb3Igc2VuZGluZyBl
bmFibGUgcmVxdWVzdCAoT3BlcmF0aW9uIG5vdCBzdXBwb3J0ZWQpDQo+ID4NCj4gPiB3aGVuIENP
TkZJR19MU009IGhhcyAiYnBmIiBpbiBpdC4NCj4gDQo+IERvIHlvdSBoYXZlIG1vcmUgdGhhbiBv
bmUgTFNNIGVuYWJsZWQ/IEl0IGxvb2tzIGxpa2UNCj4gdGhlIHByb2JsZW0gd2l0aCBzZWN1cml0
eV9zZWNpZF90b19zZWNjdHgoKSBpcyBub3cgdGhhdCBpdA0KPiByZXR1cm5zIGFuIGVycm9yIGlm
IGFueSBvZiB0aGUgTFNNcyBmYWlsIGFuZCB0aGUgY2FsbGVyIGV4cGVjdHMNCj4gaXQgdG8gc3Vj
Y2VlZCBpZiBhdCBsZWFzdCBvbmUgb2YgdGhlbSBzZXRzIHRoZSBzZWNkYXRhIHBvaW50ZXIuDQo+
IA0KPiBUaGUgcHJvYmxlbSBlYXJsaWVyIHdhcyB0aGF0IHRoZSBjYWxsIHN1Y2NlZWRlZCBldmVu
IHRob3VnaA0KPiBubyBMU00gaGFkIHNldCB0aGUgcG9pbnRlci4NCj4gDQo+IFdoYXQgaXMgdGhl
IGJlaGF2aW9yIHdlIGFjdHVhbGx5IGV4cGVjdCBmcm9tIHRoaXMgZnVuY3Rpb24gaWYNCj4gbXVs
dGlwbGUgTFNNIGFyZSBsb2FkZWQ/DQo+IA0KPiAgICAgICAgQXJuZA0K
