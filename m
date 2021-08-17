Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57363EF44C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 22:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhHQU7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 16:59:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:17000 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhHQU7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 16:59:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="214347589"
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="214347589"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 13:59:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="531228981"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 17 Aug 2021 13:59:05 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 17 Aug 2021 13:59:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 17 Aug 2021 13:59:05 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 17 Aug 2021 13:59:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZqb3n63QPdnTstctdljvodR9HU0wDzYxzWsXklo6hmjAMroZQ5yMROhO4Sl+COcRSg4ZYNJjkkUzSrdoCRaipuWo1DICvmJJnzQ2M9dk33gcnsVQIH96zY19y+e9YsTRgnoJBgY7L03BK51Ru84/lGsI/pr55xZopHEmijQgE6wKM6Jjr+IJy8rxfV2Epf/8ERVg/Ww7rbHmlmr0bzma8UA6ueyxjfhP/WfXL4ZDPdA/vok7KSU6VDq4hXHAUlGfbEOcwhNINB1Dw2ihBEV+VZZRajCb2K+/c3FweHbuR3+RlaffINj+jJeQVlfjNIWwJhxvkVqGixt8NPHSsfF+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96H3BExsgYA0UuCwgOUSj7Zi8nAZ4k34jybGmCBnqLo=;
 b=C/eFYCYydkA9l9x6EfhbtP4fGaz8Rl+U5KnPGX9uBaxZHP4pusRHAqwiv35S1U/4vhtAfNUkv4pnhLODTi3g9bCh33sucSTN/JRtcnzWw7+lZtNIL6sEaBc1487uAmGRdyYV0zDp9w9soOwH3jaHuxOrWl5bf3bJtXuk3yDSKrfH5OHPv2chwJdPtPP6Lfe5ozzbx7R/yp6ECmYWhZI0RUKy9loN2ahs2RKhTa0Pzks9VHGl9I1xDGQpr6Mlb0ZQoFsCR57XGStKHv+3muIaHbWyQK2KFQSOBTqCcuHdh5VR2nlHPttZB3ZpnZp/cZSfjhuhmdhABw7qg4Ab5OLXEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96H3BExsgYA0UuCwgOUSj7Zi8nAZ4k34jybGmCBnqLo=;
 b=TY6CJYxDpltiVyubCLqaBMG5ssZSPkvJl3lvWZ/6vgeVTatAr2wEl64Kx6yXZIAAB5yEFDdIn5W91DA+amSidS0qn4p4oGAwbB8UwuPEfZWyKiH3sH2R3WJ2AmgD0svmh14PQHTLxi3ivcE0Z+ZCkzSVufHI5eCbQCXnT+eyxeo=
Received: from BYAPR11MB3224.namprd11.prod.outlook.com (2603:10b6:a03:77::24)
 by SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Tue, 17 Aug
 2021 20:59:01 +0000
Received: from BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::98b:d3a5:6818:3194]) by BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::98b:d3a5:6818:3194%7]) with mapi id 15.20.4415.022; Tue, 17 Aug 2021
 20:59:01 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "toke@redhat.com" <toke@redhat.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "joamaki@gmail.com" <joamaki@gmail.com>
Subject: Re: [PATCH v5 intel-next 0/9] XDP_TX improvements for ice
Thread-Topic: [PATCH v5 intel-next 0/9] XDP_TX improvements for ice
Thread-Index: AQHXkRfjDVbd1gn2WEuU98SZhzox96t4NDsA
Date:   Tue, 17 Aug 2021 20:59:01 +0000
Message-ID: <86e7bcc04d8211fe5796bd7ecbea9458a725ad03.camel@intel.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5059676-93c2-43b6-7f16-08d961c1d73d
x-ms-traffictypediagnostic: SJ0PR11MB5008:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB50080BFDF6DE3199DA3655EFC6FE9@SJ0PR11MB5008.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5WN5G6xWCcaNAodae5NLH3w0ihlKRrUmpIZFrLAAG/omWDKOwji0jzQd1cy4jk/c1DN/YpUji5ajWVwTmWkqN/HjXMnqkieCrs3+c157QFaj61Hacz3wCLqno+WPbACNXYX4unl3QrmRHMGqWgMgf6DRDI+QQgsOWWHV47kaXSPCH9AufdzyHu4bVeZMf+NwZpau4/OY+QEOtcVqi+YK/Ddht8b5TO99peeGRemqkKHeGios+MHDdntfyE67ucwuKMVQO69dgBSx+NlfGGeGr9V0p+FgAHkGfLxGHLGGIh73FUnTnZXLtIYi7gG8ymmB0ZdHoGrbhXrmDEYdp5ty2FCYu8I4eAggu6PS5MXZZa7eINFh8oJyg1DVCm0TL19DmytGpfyXymlWxEF0btdaCljx69DHBpeEm+Yi1DwbNX2xlOxcrY4/UjRC8/ladqx4JZxh8hHXL9h64aqWjbXiODFbY9221d1U/9L6xXObTFHvXrphMdlUC/5npgBnhDwlfAmUW8LScCfhuLJK5roWyU6hw2fU1aG3H1E+ldjeGgYR/VIO4V7I/7YmrkxQB5Idfs4NUa9q9CxpOraZOgFNVFYscR/eChCWyeJh8okWJ0LviDpQcn1mzo/Q43LB+yHCklRXlf7R6NwY0cKtVldu0RTQOoypXE5gO0ctgMg/aTUSxTvkfxrNjAzmxC2f01BTTEq0ZnVOTP0H0qvD4RFTF7jITJKiq58l9w9Hh+15hoqQQqx4x01HLYRS2yfcNhTP1tqzhZVwr+FEm37OAqOZoN4Rq5Q/3gdabEEdUjZKwcwLbiYkDbjTetunvW9VKNzM045BUWipLKjD6RIjYe/cew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3224.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(8676002)(8936002)(2616005)(316002)(66556008)(6506007)(478600001)(966005)(38070700005)(110136005)(26005)(54906003)(5660300002)(36756003)(71200400001)(6486002)(83380400001)(66446008)(86362001)(6512007)(64756008)(91956017)(38100700002)(186003)(2906002)(4326008)(122000001)(66946007)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bU9rSTdzUFZVbkw5cmtmSEl2eVBEWU15SXE0RktJMTkvQ3RzT21FTFNiSENY?=
 =?utf-8?B?eWNBK0w0ZGtseVNxRkNyT1JoaVRYaklMN05GUkFST1hBQTF0ZmxjZWVjd1ZY?=
 =?utf-8?B?K3ZBcGhhcG1XaU9KaTVMVnRPUnoybk9XVjhCNDNqRmZITGNZNng1Z2E0d0d3?=
 =?utf-8?B?Y1ROcWZlSThqVVFBQ2ZhOW94bmF5enE5V0NHOTQyRTE2QWl0TTcvdzVFRzhh?=
 =?utf-8?B?aFN0RUJtSWhJUFRZdUhJZkJEeEJIVVRnazNNVy9qTXpuUXZOeC9VclVPRUZl?=
 =?utf-8?B?Vm4wSm5FSmV2cUNYWENHMHY3WHNtdXNxNHorM1NxSDU5TzhzeFVYVGRDTU9i?=
 =?utf-8?B?MnpMQjFZaG9YVS91R3dsc1BUOVRtQnFxWHQ3SlJpNllHSTZmVVdiLzkvYjRO?=
 =?utf-8?B?SEhuQTNuU09lUkpxVTJSUUJZc1RuUXkyZ0tOekxaS0NlQUV6RjRybHJSTW43?=
 =?utf-8?B?VHFTalYzRGhzVG9OVjJhbHVKbG9rZUllWit6M0IrYnB5dy9nWGJFZUQrcXBz?=
 =?utf-8?B?eWE4V0RDRElHOWtkVGdmMDd2elhINnNMQWN1TWtnOXYvT3ZTN1dPc3ptbmhF?=
 =?utf-8?B?M1I2K2EzZHBhK09EMFluWlMzcU9LTnVoSWwzZnlhaWVVNHZScTgrY2JFV1B0?=
 =?utf-8?B?eEI4Q01uZXBjTmthT1JYdHhaTVh2WU56NlNGMzBDc2ppM2I0aXEwZ1UxbmZG?=
 =?utf-8?B?Mkx0VUlnaXcyMVhmWnU5TkhkRXpXTkVyeHljRFpDN3NYZUpGTHBYMnBGT2w2?=
 =?utf-8?B?elM2R1ZqRXFBSWJ4eVRDdk5TYU5VejJ5Qllqc1NHOHRoQ2QyMzlTQSt3ZGps?=
 =?utf-8?B?eXBwTVI3U1dIbEtIdkw5azczNGFtcjk4MElLNDFtYzZqdzV4QStJNFJSTDJK?=
 =?utf-8?B?U2laWGNsMUVJdVZNc3lMbnJUeE5zUFN4ME9zMWs4NCs1RURDdnhMU0VQSzN2?=
 =?utf-8?B?SlJJdFF1bEFOWEhrWS9zREtyQnlJZzJRZ1VrUVZIVllYeWs2eEN1YSt1QXpT?=
 =?utf-8?B?S0U3MmNtK01MUE5jTzZXbFk5S0Nxblo4WG91eDhVRmp6TUNRSnI5cU1ZTDJu?=
 =?utf-8?B?ajlDYU56SjZWMjZONkZpak1FUy84VVFSU2Y0S2dMcmtmRS9VSFNIa01UYWZO?=
 =?utf-8?B?VzhVVHliNGJwem5PQStwMmhJelNUeDRMM2pQWDNnSUxFcUtJT0VsVnVqL1kr?=
 =?utf-8?B?NDZDNlJIdHdXeGdyOUo4aS9VZWswM3dyQ25haW1GR2IvQ04wTHNIOFZ1cjhC?=
 =?utf-8?B?aXM1VkxqdHVFdCt2UytLUXFTeWE3aXkwZmZGYXBWa2kwSnl0NndwTExKYlZz?=
 =?utf-8?B?ZEZOUFRnVUlkcVlvVjBNMTdCa1FtNXVBYzZienlzM3VBNVhMZ1hmd0pDNkVK?=
 =?utf-8?B?VzZueHhlZXl4cnIvc0xQMmcrODcveGdxYXZsYUNlY1VkQWpUVitYQVhOMGJ3?=
 =?utf-8?B?blFTMk05QWtVUExreDlSaXVTYVlxdE1rNXNySHE4ZFI1b0ZFMlRyNUs4V2pD?=
 =?utf-8?B?bSt0Q3ZiaGlPZ0dtbGdjV2xtRjMwUHArRDRhbndWSHRMTjlKMEtzNTNVUEsv?=
 =?utf-8?B?QkV2S2lxTW1SN3czQnVMeDkrOE4wTnUxeVVpN1VWR0JFTG96Q285TlhPenBk?=
 =?utf-8?B?OW96SXpxRnA1Sm43bFlmbVRNMUhSTGw2c0NUMEJJV3VuTTVRYk05Rlp0MWZk?=
 =?utf-8?B?NTlIZjlBSkRLbE83Y2YrbWhNWUdqcy9FdDNENzA1NFN1M1NOdldBWXl3Z1V0?=
 =?utf-8?B?U01SNDlDNm41OVdyTXJSNXVuKzlzMHJucVpmczZ5ZVYva1VzQ2orK2Zwc2tm?=
 =?utf-8?B?TjVIMEEyTFdyYzdyTExhUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2361AC1E2187A04E99D248DD2297F13A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3224.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5059676-93c2-43b6-7f16-08d961c1d73d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 20:59:01.5620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vWDYIX1tCVbVVx+3+PyQ2v1hQy9EKmU4SOGPhqCLFQoGW+YAnlI9iW+kF0gTcdkUhAQRy2rElgk4byuhUxdnlfL4wfR4mwynEh6tvbUuHLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5008
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTA4LTE0IGF0IDE2OjA4ICswMjAwLCBNYWNpZWogRmlqYWxrb3dza2kgd3Jv
dGU6DQo+IFdpdGggdGhlIHY1LCBJIHRoaW5rIGl0J3MgdGltZSBmb3IgYSBwcm9wZXIgY2hhbmdl
IGxvZy4NCg0KVGhpcyBpc24ndCBhcHBseWluZyB0byB0aGUgSW50ZWwtd2lyZWQtTEFOIHRyZWUu
IElmIHlvdSB3YW50IGl0IHRvIGdvDQp0aHJvdWdoIHRoZXJlLCBjb3VsZCB5b3UgYmFzZSB0aGUg
cGF0Y2hlcyBvbiB0aGF0IHRyZWU/DQoNCkFsc28sIGxvb2tpbmcgYXQgTklQQSwgaXQgbG9va3Mg
bGlrZSBwYXRjaGVzIDIgYW5kIDMgaGF2ZSBrZG9jIGlzc3Vlcy4NCg0KVGhhbmtzLA0KVG9ueQ0K
DQo+IHY0LT52NToNCj4gKiBmaXggaXNzdWVzIHBvaW50ZWQgYnkgbGtwOyB2YXJpYWJsZXMgdXNl
ZCBmb3IgdXBkYXRpbmcgcmluZyBzdGF0cw0KPiAgIGNvdWxkIGJlIHVuLWluaXRlZA0KPiAqIHMv
aWNlX3JpbmcvaWNlX3J4X3Jpbmc7IGl0IGxvb2tzIG5vdyBzeW1tZXRyaWMgZ2l2ZW4gdGhhdCB3
ZSBoYXZlDQo+ICAgaWNlX3R4X3Jpbmcgc3RydWN0IGRlZGljYXRlZCBmb3IgVHggcmluZw0KPiAq
IGdvIHRocm91Z2ggdGhlIGNvZGUgYW5kIHVzZSBpY2VfZm9yX2VhY2hfKiBtYWNyb3M7IGl0IHdh
cyBzcG90dGVkDQo+IGJ5DQo+ICAgQnJldHQgdGhhdCB0aGVyZSB3YXMgYSBwbGFjZSBhcm91bmQg
dGhhdCBjb2RlIHRoYXQgdGhpcyBzZXQgaXMNCj4gICB0b3VjaGluZyB0aGF0IHdhcyBub3QgdXNp
bmcgdGhlIGljZV9mb3JfZWFjaF90eHEuIFR1cm5lZCBvdXQgdGhhdA0KPiB0aGVyZQ0KPiAgIHdl
cmUgbW9yZSBzdWNoIHBsYWNlcw0KPiAqIHRha2UgY2FyZSBvZiBjb2FsZXNjZSByZWxhdGVkIGNv
ZGU7IGNhcnJ5IHRoZSBpbmZvIGFib3V0IHR5cGUgb2YNCj4gcmluZw0KPiAgIGNvbnRhaW5lciBp
biBpY2VfcmluZ19jb250YWluZXINCj4gKiBwdWxsIG91dCBnZXR0aW5nIHJpZCBvZiBAcmluZ19h
Y3RpdmUgb250byBzZXBhcmF0ZSBwYXRjaCwgYXMNCj4gc3VnZ2VzdGVkDQo+ICAgYnkgQnJldHQN
Cj4gDQo+IHYzLT52NDoNCj4gKiBmaXggbGtwIGlzc3VlczsNCj4gDQo+IHYyLT52MzoNCj4gKiBp
bXByb3ZlIFhEUF9UWCBpbiBhIHByb3BlciB3YXkNCj4gKiBzcGxpdCBpY2VfcmluZw0KPiAqIHBy
b3BhZ2F0ZSBYRFAgcmluZyBwb2ludGVyIHRvIFJ4IHJpbmcNCj4gDQo+IHYxLT52MjoNCj4gKiB0
cnkgdG8gaW1wcm92ZSBYRFBfVFggcHJvY2Vzc2luZw0KPiANCj4gdjQgOiANCj4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYnBmLzIwMjEwODA2MDk1NTM5LjM0NDIzLTEtbWFjaWVqLmZpamFsa293
c2tpQGludGVsLmNvbS8NCj4gdjMgOiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzIw
MjEwODA1MjMwMDQ2LjI4NzE1LTEtbWFjaWVqLmZpamFsa293c2tpQGludGVsLmNvbS8NCj4gdjIg
OiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzIwMjEwNzA1MTY0MzM4LjU4MzEzLTEt
bWFjaWVqLmZpamFsa293c2tpQGludGVsLmNvbS8NCj4gdjEgOiANCj4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYnBmLzIwMjEwNjAxMTEzMjM2LjQyNjUxLTEtbWFjaWVqLmZpamFsa293c2tpQGlu
dGVsLmNvbS8NCj4gDQo+IFRoYW5rcyENCj4gTWFjaWVqDQo+IA0KPiBNYWNpZWogRmlqYWxrb3dz
a2kgKDkpOg0KPiAgIGljZTogcmVtb3ZlIHJpbmdfYWN0aXZlIGZyb20gaWNlX3JpbmcNCj4gICBp
Y2U6IG1vdmUgaWNlX2NvbnRhaW5lcl90eXBlIG9udG8gaWNlX3JpbmdfY29udGFpbmVyDQo+ICAg
aWNlOiBzcGxpdCBpY2VfcmluZyBvbnRvIFR4L1J4IHNlcGFyYXRlIHN0cnVjdHMNCj4gICBpY2U6
IHVuaWZ5IHhkcF9yaW5ncyBhY2Nlc3Nlcw0KPiAgIGljZTogZG8gbm90IGNyZWF0ZSB4ZHBfZnJh
bWUgb24gWERQX1RYDQo+ICAgaWNlOiBwcm9wYWdhdGUgeGRwX3Jpbmcgb250byByeF9yaW5nDQo+
ICAgaWNlOiBvcHRpbWl6ZSBYRFBfVFggd29ya2xvYWRzDQo+ICAgaWNlOiBpbnRyb2R1Y2UgWERQ
X1RYIGZhbGxiYWNrIHBhdGgNCj4gICBpY2U6IG1ha2UgdXNlIG9mIGljZV9mb3JfZWFjaF8qIG1h
Y3Jvcw0KPiANCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2UuaCAgICAgICAg
ICB8ICA0MSArKystDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2FyZnMu
YyAgICAgfCAgIDIgKy0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfYmFz
ZS5jICAgICB8ICA1MSArKy0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9iYXNlLmggICAgIHwgICA4ICstDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2Uv
aWNlX2RjYl9saWIuYyAgfCAgIDkgKy0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lj
ZS9pY2VfZGNiX2xpYi5oICB8ICAxMCArLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWNlL2ljZV9ldGh0b29sLmMgIHwgIDkzICsrKysrLS0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaWNlL2ljZV9saWIuYyAgICAgIHwgIDg4ICsrKysrLS0tLQ0KPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9saWIuaCAgICAgIHwgICA2ICstDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX21haW4uYyAgICAgfCAxNDIgKysrKysrKysrLS0t
LS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfcHRwLmMgICAgICB8ICAg
MiArLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9wdHAuaCAgICAgIHwg
ICA0ICstDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3RyYWNlLmggICAg
fCAgMjggKy0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3R4cnguYyAg
ICAgfCAxODMgKysrKysrKysrKystLS0tLQ0KPiAtLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWNlL2ljZV90eHJ4LmggICAgIHwgMTI2ICsrKysrKystLS0tLQ0KPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV90eHJ4X2xpYi5jIHwgIDk4ICsrKysrKysrLS0NCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfdHhyeF9saWIuaCB8ICAxNCArLQ0K
PiAgLi4uL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3ZpcnRjaG5sX3BmLmMgIHwgICAyICst
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3hzay5jICAgICAgfCAgNzAg
KysrKy0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV94c2suaCAgICAg
IHwgIDIwICstDQo+ICAyMCBmaWxlcyBjaGFuZ2VkLCA2MDcgaW5zZXJ0aW9ucygrKSwgMzkwIGRl
bGV0aW9ucygtKQ0KPiANCg==
