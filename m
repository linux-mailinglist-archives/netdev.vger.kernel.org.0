Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A670B2B233E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKMSCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:02:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:20008 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgKMSCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 13:02:53 -0500
IronPort-SDR: 2ONlEeer8PD5viToGDKUxnbQ21HJteTR/NobuzDqKD5mD9pGDAcQi7dekZeRtOVD/Gy2zRMgcx
 BkWGmET7fMCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="150358872"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="150358872"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 10:02:52 -0800
IronPort-SDR: kAsf1rdtmoH+L1uAIy7pRql74SqFAxqg+YA2MFTAOO9A62iERe7y2shIeKyRshRiP5QjvzD9Pm
 P1fE8yHE7nqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="328949393"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 13 Nov 2020 10:02:51 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Nov 2020 10:02:51 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Nov 2020 10:02:51 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 13 Nov 2020 10:02:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFMpXNKsWegOU6oVd9PBeQoXVzJFSB4mJ0dYBPLoMFSVkYuYffAx30XjbMtkkd+cfDUwAH8Tzofza/qeklv4vFBeP40HgFzxU90hGdCZncQGTHgoERqbvtX3/cQUpPU0/wXoCesoNGHUIpkdack6E1c2IuecxTzLAqMgH1WwSB4LI8/MTnSF9QO/DRy3DQXsTcgU6OcuQoC/PYqUF/T8GBS5RyZKU4o8apE2BS1onQYHqn61CVrC7M91617fSgFRYmCi16FWdIJi8rzfJCVbHmAfqYwtqlClRJgYRMxPm/OiityQWlzR/ILva/PgBnq/jpfTuYG46rFyDe/uZLtY5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWjjm88k/POaBU14/Bc5FDvmdGbSPL6+EluAJJdrciA=;
 b=FRdZg0Ua9han0IIweFyV7T/ZWVmJMolNj84oUsy5tN/vJaphBn50QL/3ibbo4HSDm6OVfeV6/5S5JWSZI9Ua3eCJ7rQcA5kiS7QOOMhK/r0hXjZHffxt4duHoXVlWNiHWLJePxS1reeXj7qdSCkPYG8/IFMa8e9z16sUsRro20IFk3oU9HytT1CyioLnkdI5iLX02BaJH+GQHLlHv10oLwPbxfTxsSatuaTEA4/+3tAfojoi8dpQX3nLxkKQ6P++/YOiD+L/1HjegylZHhjGV94aKR7x2VAistVLMYPfbNZwPN/EpZoLGqFfDWuQakqR1rIVAep/Qq6j/iF41tAkbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWjjm88k/POaBU14/Bc5FDvmdGbSPL6+EluAJJdrciA=;
 b=jSKMqW9JbuCFPNpg89crME4tOjkOgzziHxeix+EbU6R4UzibzcSwcIZ7eoPDtI7jJhz5V69EFXv9/1K56V9hGWiHLxeWQP077ssdmIXf4XaNrx3ywALoYTHxyIPLbBQ0q+hopAZWgPBwFKoo6g+faPactsfhfLQOd8QbhAjwK50=
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com (2603:10b6:301:58::7)
 by CO1PR11MB5202.namprd11.prod.outlook.com (2603:10b6:303:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Fri, 13 Nov
 2020 18:02:47 +0000
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02]) by MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02%8]) with mapi id 15.20.3564.025; Fri, 13 Nov 2020
 18:02:47 +0000
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
Subject: Re: Hardware time stamping support for AF_XDP applications
Thread-Topic: Hardware time stamping support for AF_XDP applications
Thread-Index: AQHWt7MCSEaDlO58DE6scAsur7MQZanCBAaAgAAGAoCAAttmAIABeY0A
Date:   Fri, 13 Nov 2020 18:02:47 +0000
Message-ID: <16DFFD9A-3973-4526-BF20-FD41E9BFBC25@intel.com>
References: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
 <6af7754d5bcba7a7f7d92dc43e1f4206ce470c79.camel@kernel.org>
 <65418F25-1795-4FF7-AB04-8DE78F0C8BF5@intel.com>
 <14da7d0820e3e185dcb65e010d16c818ad030e33.camel@kernel.org>
In-Reply-To: <14da7d0820e3e185dcb65e010d16c818ad030e33.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.96.95.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96a3e4fd-207f-4604-907b-08d887fe541e
x-ms-traffictypediagnostic: CO1PR11MB5202:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5202010A97518E7000A1901292E60@CO1PR11MB5202.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jjwsCr5MQuKhoVI2zEfvH3VIjaAieyEQRfQ7aVDWGeCNHyI92JUPHUPnTwLJ3mzaxmnTU4OlH0DYXS36hYq+n8NOhc/eHyJXXMxyiKAjtgSikdn3O3CLvWwBdR+wFP/pgwlMTH6UyZrM4oyraKHfrb2uJjfd82QK/+fkDYlKB/fBuFsOUZuoaVj82/+vmmcWjgMZwxF+coaBQcCbZg216sy7Z5ZjFKcfQC6e6NYhaAKKPrTJK2xr4g7koxbiyig2ow1DEG1XH2fPJf7uJm8pfWG6GZkqLGtS4qfwQ6ff5kW4pnv22MLlzjREPRSJcB+S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(478600001)(26005)(5660300002)(6512007)(316002)(2616005)(86362001)(2906002)(4326008)(54906003)(64756008)(66556008)(66476007)(66446008)(66946007)(8936002)(186003)(76116006)(91956017)(6486002)(8676002)(107886003)(53546011)(71200400001)(36756003)(4001150100001)(6506007)(33656002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gD1y8wVwrEgdXjC0im5rI7nkxPTKRcB6ZxzWLr/33wJUBqkvK/3OQiu6AXa9UJ3Pzc4meY7/q3RiR7F0Hwgdb4XonIqbt7QGr+h/qqssXn1wj3jHxxeQQRAASKsbooyRIFbY6cT/qVfifWh+Boin1xGGis3pUI46uD7zp4n86qZsKLJ9N80Ens0IcYGe5EkD35SzunDhWasa4bckuT3Feju9DrXXcpWvTVHMi/NGY6DijJVh+x24ZOR9k+fAUfvoybFzm75BDVhdFK6EKZpPQkoPHDN9XTOlHzZ2HzZ/mslOrjmVkgikCqPzjnkhcBO6IGwtvasC6jTCKlaT7p4XCwjdiz5gGh+mA56LiowGaTI8TxAj9XIbD1IDA7/cpLTVC6caFqvUMtOY3Ne87c2V0Cd2iCFBDcZ7LhMn6qr98S2+0+tFTjg1E8QeBaxaILwFW/yK3jcG2q8z/iXBTrgVaqlaEvK7PWvh7RpHSUvh7CXM8Hb8vONYAqrVtvtmKFel7q2p6jyTB+ibQJnc0zR8M90AMt98gQZewq153jII4y50Jms/ScuQ1JRCMRxxiCcxG3xBqkBbn/0D025MNuwC7J1BhMNQJ8QWuVWu0GiI9T7qQSq3LOVHqUGSrVNgKawlqEahlw4JU5iqL5BU7j52rw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1AA2D563EF2D524899DC184189D99E74@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a3e4fd-207f-4604-907b-08d887fe541e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 18:02:47.4347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DEAmqrnikLKB9u60ajd+iVlI0KwRXeH0bkUoKaC9fZOYj13lyB6/CWA0eFcMaqQ/IeCos8cj967liUDBJqIePQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5202
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FlZWQsDQoNCj4gT24gTm92IDEyLCAyMDIwLCBhdCAxMTozMSBBTSwgU2FlZWQgTWFoYW1l
ZWQgPHNhZWVkQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gVHVlLCAyMDIwLTExLTEwIGF0
IDIzOjUzICswMDAwLCBQYXRlbCwgVmVkYW5nIHdyb3RlOg0KPj4+IFdpdGggQlRGIGZvcm1hdHRl
ZCBtZXRhZGF0YSBpdCBpcyB1cCB0byB0aGUgZHJpdmVyIHRvIGFkdmVydGlzZQ0KPj4+IHdoYXRl
dmVyIGl0IGNhbi93YW50IDopDQo+Pj4gc28geWVzLg0KPj4gDQo+PiBJIGhhdmUgYSB2ZXJ5IGJh
c2ljIHF1ZXN0aW9uIGhlcmUuIEZyb20gd2hhdCBJIHVuZGVyc3RhbmQgYWJvdXQgQlRGLA0KPj4g
SSBjYW4gZ2VuZXJhdGUgYSBoZWFkZXIgZmlsZSAodXNpbmcgYnBmdG9vbD8pIGNvbnRhaW5pbmcg
dGhlIEJURiBkYXRhDQo+PiBmb3JtYXQgcHJvdmlkZWQgYnkgdGhlIGRyaXZlci4gSWYgc28sIGhv
dyBjYW4gSSBkZXNpZ24gYW4gYXBwbGljYXRpb24NCj4+IHdoaWNoIGNhbiB3b3JrIHdpdGggbXVs
dGlwbGUgTklDcyBkcml2ZXJzIHdpdGhvdXQgcmVjb21waWxhdGlvbj8gSSBhbQ0KPj4gZ3Vlc3Np
bmcgdGhlcmUgaXMgc29tZSBzb3J0IG9mIOKAnG1hc3RlciBsaXN04oCdIG9mIEhXIGhpbnRzIHRo
ZSBkcml2ZXJzDQo+PiB3aWxsIGFncmVlIHVwb24/DQo+IA0KPiBIaSBQYXRlbCwgYXMgSmVzcGVy
IG1lbnRpb25lZCwgc29tZSBoaW50cyB3aWxsIGJlIHdlbGwgZGVmaW5lZCBpbiBCVEYNCj4gZm9y
bWF0LCBieSBuYW1lLCBzaXplIGFuZCB0eXBlLCBlLmcuOg0KPiANCj4gICB1MzIgaGFzaDMyOw0K
PiAgIHUxNiB2bGFuX3RjaTsNCj4gICB1NjQgdGltZXN0YW1wOw0KPiANCj4gZXRjLi4gDQo+IA0K
PiBpZiB0aGUgZHJpdmVyIHJlcG9ydHMgb25seSB3ZWxsIGtub3duIGhpbnRzLCBhIHByb2dyYW0g
Y29tcGlsZWQgd2l0aA0KPiB0aGVzZSBjYW4gd29yayBpbiB0aGVvcnkgb24gYW55IE5JQyB0aGF0
IHN1cHBvcnRzIHRoZW0uIHRoZSBCUEYgcHJvZ3JhbQ0KPiBsb2FkZXIvdmVyaWZpZXIgaW4gdGhl
IGtlcm5lbCBjYW4gY2hlY2sgY29tcGF0aWJpbGl0eSBiZWZvcmUgbG9hZGluZyBhDQo+IHByb2dy
YW0gb24gYSBOSUMuDQo+IA0KPiBub3cgdGhlIHF1ZXN0aW9uIHJlbWFpbnMsIFdoYXQgaWYgZGlm
ZmVyZW50IE5JQ3MvRHJpdmVycyByZS1hcnJhbmdlDQo+IHRob3NlIGZpZWxkcyBkaWZmZXJlbnRs
eT8gDQo+IHRoaXMgYWxzbyBjYW4gYmUgc29sdmVkIGJ5IHRoZSBCUEYgWERQIHByb2dyYW0gbG9h
ZGVyIGluIHRoZSBrZXJuZWwgYXQNCj4gcnVuZyB0aW1lLCBpdCBjYW4gcmUtYXJyYW5nZSB0aGUg
bWV0YSBkYXRhIG9mZnNldHMgYWNjb3JkaW5nIHRvIHRoZQ0KPiBjdXJyZW50IE5JQyBkaXJlY3Rs
eSBpbiB0aGUgYnl0ZSBjb2RlLCBidXQgdGhpcyBpcyBnb2luZyB0byBiZSBhIGZ1dHVyZQ0KPiB3
b3JrLg0KPiANClRoYW5rcyBmb3IgbW9yZSBpbmZvIQ0KDQpJIGhhdmUgcHVsbGVkIGluIHlvdXIg
Y2hhbmdlcyBhbmQgc3RhcnRlZCBtb2RpZnlpbmcgdGhlIGlnYyBkcml2ZXIuIEkgd2lsbCByZXBv
cnQgYmFjayBvbiBob3cgaXQgZ29lcy4NCg0KVGhhbmtzLA0KVmVkYW5nIA==
