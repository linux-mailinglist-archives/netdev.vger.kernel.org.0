Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086322191BE
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGHUof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:44:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:24025 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgGHUoe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 16:44:34 -0400
IronPort-SDR: nwl+d0x3uOFWtOfn1lKUqBbZRb8251keSSYK8x1JBVCVV1M7khW4YDSsleerbbh7Z8CMmwyABB
 OYI410RICr4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="145388233"
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="145388233"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 13:44:33 -0700
IronPort-SDR: cXduNpA67XNZQDgoi9s2E9LUHmkT1naKPAAo29xq+eBonsG/ZxSuNJC1rvPOKbti1ZaAJTgARe
 gTawI+GsY9EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="323995083"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga007.jf.intel.com with ESMTP; 08 Jul 2020 13:44:33 -0700
Received: from fmsmsx126.amr.corp.intel.com (10.18.125.43) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:44:32 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX126.amr.corp.intel.com (10.18.125.43) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:44:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 8 Jul 2020 13:44:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X694dYS6VNwM9pI9bi4roz9rxCwUrLyfEpnzjbdOH89WTH1io/Q/vyMjdAf5iNtFHfcp6f7KooeRmrBgEU+X9yN2tgbgpXlEgtsuCiks3V1iEPD+tA7th5k5lBH9Loev0ebd7bMN1vXo99ryPgGSNOGKyo86LIv8OwmOvu6oIhb1BFjLzBNr/sROJ1TsABaXeM+1zviZDA0I1A5R9IboEyVqbjGbCImyte6G7DtOyNLaoHQ+5mx8DcEp3BgBHbgMAh/BN2p/tZEzg9CLON0JTZ1En2LqBh605jLc9pJEq6lZVuAE2eMvjLKP2N4QOXDXqemSLnmcpXkBoECyaAutsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpIqcOiZeahDbvFSP6jts002Y7epj8gZzMHl9jNhSZA=;
 b=CZAO78IagobM3otL02o/zRHJRmYUTmMiNnf2BT9C7lYgJQKrEQMT3gXOBY8indlcS7/y1KeF/MFn414CUfT0UV9P0sgZIdRkRCK6wUpP+Oe5NMxhudbBZQG2GUrRWByK26W4S7J9DnQGIDl1Uh7hbhGRg/s/V+WLcwKeQslWsiB3k57HS+nwISAjxLilQztRR/6TSqITJGby+IJhLnpaulNphfifitq7Cw/qew1L1yBZt1qLk1Sbi9u35SJg9hY3xACd31Cd4zXHGJWUS/JRdBVkpuPu5NDO5v8Cg6OAuTyB3yC9/1mpQADRI9poMp3pt99raja9yWJ/DvrR63PKGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpIqcOiZeahDbvFSP6jts002Y7epj8gZzMHl9jNhSZA=;
 b=kS4DtIfr3xjv5igvSvsbMaRwZoHQykaPjAxayev01yu5QPk47F3FEng3CzOrrqBSEdedeeSveKHmpON7OIHO/B4jHCA7SKdyA0CIclHD5jwDrM5v5wGHQK/bbYTXD0nAENOzjBx8ok5ByOnKuXc3sJIVCOB3tTtYluz5UKD4Tyw=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN7PR11MB2594.namprd11.prod.outlook.com
 (2603:10b6:406:b5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Wed, 8 Jul
 2020 20:44:30 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3%9]) with mapi id 15.20.3174.022; Wed, 8 Jul 2020
 20:44:30 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next 3/4] i40e, xsk: increase budget
 for AF_XDP path
Thread-Topic: [Intel-wired-lan] [PATCH net-next 3/4] i40e, xsk: increase
 budget for AF_XDP path
Thread-Index: AQHWUIbP2jpdinIYWEKRTgfsNzD+Nqj+L/qQ
Date:   Wed, 8 Jul 2020 20:44:30 +0000
Message-ID: <BN6PR1101MB2145C84FFB906F0FA2692D488C670@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200702153730.575738-1-bjorn.topel@gmail.com>
 <20200702153730.575738-4-bjorn.topel@gmail.com>
In-Reply-To: <20200702153730.575738-4-bjorn.topel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07d44364-18e1-4005-4888-08d8237fb6ed
x-ms-traffictypediagnostic: BN7PR11MB2594:
x-microsoft-antispam-prvs: <BN7PR11MB25945FD91008E309B611CC478C670@BN7PR11MB2594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:291;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E0WIy3yOyvDPdcfVz/7bWRGhwPZ3+ywc4Zv+5lmJ81N8j0W+WbBfph9qHXpTK4vi173mk674WxV7IGXRAzXhrZuZn2nAC50O2NmF1xCelc8FE+mmtzelscbUTuLYeHONc+8w0Lxq4ul0HB2ItrTroGi6Bh+Cm4EBkjAqDKPZBnuk2UhPHbLyz1wjJ2HFSRtQ3uSibRG6XQW2Tbrww/3Lzg2oNFGoSB7FSCJubcp3ZS/fpvqqTrw1amTNgGOo3dy17krc5N7MOwjnz7VQTOhZYh6UZjXnxgNV7xRqasKa+Enq3EQ/lEH2iF/zpZ1fNu2qDZUdLY9uXkt2GwlZ2nzhgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(478600001)(33656002)(186003)(54906003)(316002)(4326008)(6916009)(71200400001)(9686003)(55016002)(7696005)(64756008)(8936002)(2906002)(66476007)(76116006)(66556008)(8676002)(66946007)(52536014)(53546011)(86362001)(6506007)(26005)(5660300002)(83380400001)(66446008)(66574015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fvueUf1Fe9C0mqZVZKhyR9OH5PyC9bHFv9ABtZKOX6dF26++TW0DId118bL5hwMk28ui7RnMyoZCAnFcH4a++OUv64r9I4ZarrK9wAk7PulXFyax0E5WPrFga5sWknHf1j0Mt3onxlVtNkCMOyWwDizoOg0/5P51h4DnepifeRo587jxAK9veGpM9Vw08jJ8RxgQ0CYR3Njh870gVVI7JiZLrvHkIhupTMjqRbmEddfkE5svBrnM+hBsbPz/Yl+e3CgFR+Y251aj/GP1ubNyvlejQqVUWWWQnO/rZbSsLahCduU981jIRfbYOStn5pF2VqLXbEFtdsR1IiEnq/amYYT/OIwG9ghxovJ47pYulR8hqcB6kqxGwaNRK+BphDQdhsjHld73naVrxJq2Op27Ke4uOz1k6+KPM7HicxY+1i9qsbkrFmbfZahmoaj+ZDxuAXXWSVV6dK5CuhXOB5FYC2y/6oxNKn2M/GhOG3pSRU4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d44364-18e1-4005-4888-08d8237fb6ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 20:44:30.8698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PhfkRRlKzoO/NhYm77HQdmCWq0X9kWhTxGx4qQ+vX5W6USqDoAVrmUKeIXqsj4F3C55QS7TfPB4e0GUOQEAC2AaUxRhVFCbQ8O8CwVnQBKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2594
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gPGlu
dGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5vcmc+IE9uIEJlaGFsZiBPZg0KPiBCasO2cm4g
VMO2cGVsDQo+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDIsIDIwMjAgODozNyBBTQ0KPiBUbzogaW50
ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmcNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGJwZkB2Z2VyLmtlcm5lbC5vcmc7IFRvcGVsLCBCam9ybg0KPiA8Ympvcm4udG9wZWxAaW50
ZWwuY29tPjsgS2FybHNzb24sIE1hZ251cyA8bWFnbnVzLmthcmxzc29uQGludGVsLmNvbT4NCj4g
U3ViamVjdDogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIIG5ldC1uZXh0IDMvNF0gaTQwZSwgeHNr
OiBpbmNyZWFzZSBidWRnZXQgZm9yDQo+IEFGX1hEUCBwYXRoDQo+IA0KPiBGcm9tOiBCasO2cm4g
VMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+DQo+IA0KPiBUaGUgbmFwaV9idWRnZXQsIG1l
YW5pbmcgdGhlIG51bWJlciBvZiByZWNlaXZlZCBwYWNrZXRzIHRoYXQgYXJlIGFsbG93ZWQNCj4g
dG8gYmUgcHJvY2Vzc2VkIGZvciBlYWNoIG5hcGkgaW52b2NhdGlvbiwgdGFrZXMgaW50byBjb25z
aWRlcmF0aW9uIHRoYXQgZWFjaA0KPiByZWNlaXZlZCBwYWNrZXQgaXMgYWltZWQgZm9yIHRoZSBr
ZXJuZWwgbmV0d29ya2luZyBzdGFjay4NCj4gDQo+IFRoYXQgaXMgbm90IHRoZSBjYXNlIGZvciB0
aGUgQUZfWERQIHJlY2VpdmUgcGF0aCwgd2hlcmUgdGhlIGNvc3Qgb2YgZWFjaA0KPiBwYWNrZXQg
aXMgc2lnbmlmaWNhbnRseSBsZXNzLiBUaGVyZWZvcmUsIHRoaXMgY29tbWl0IGRpc3JlZ2FyZHMg
dGhlIG5hcGkgYnVkZ2V0DQo+IGFuZCBpbmNyZWFzZXMgaXQgdG8gMjU2LiBQcm9jZXNzaW5nIDI1
NiBwYWNrZXRzIHRhcmdldGVkIGZvciBBRl9YRFAgaXMgc3RpbGwgbGVzcw0KPiB3b3JrIHRoYW4g
NjQgKG5hcGkgYnVkZ2V0KSBwYWNrZXRzIGdvaW5nIHRvIHRoZSBrZXJuZWwgbmV0d29ya2luZyBz
dGFjay4NCj4gDQo+IFRoZSBwZXJmb3JtYW5jZSBmb3IgdGhlIHJ4X2Ryb3Agc2NlbmFyaW8gaXMg
dXAgNyUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBp
bnRlbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBl
X3hzay5jIHwgNCArKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQoNClRlc3RlZC1ieTogQW5kcmV3IEJvd2VycyA8YW5kcmV3eC5ib3dlcnNAaW50
ZWwuY29tPg0KDQoNCg==
