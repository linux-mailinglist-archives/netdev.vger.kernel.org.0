Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390783DE0F2
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhHBUqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:46:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:29587 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231397AbhHBUqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:46:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="193812987"
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="193812987"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 13:46:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="440832474"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 02 Aug 2021 13:46:03 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 2 Aug 2021 13:46:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 13:46:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 2 Aug 2021 13:46:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 2 Aug 2021 13:46:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsmrOFOiIXbZFEr4+0ut0ykPhIcsUWQjMVMp4fawOFOWiRGPS4A3N0VOTXcZM2tAJa6vASS3rwW/H42lXcIheUmdINXv2giO9UE8HSG8O6i/utDUKPy5puvyK84cLOwsBL8vElKoMTyWYxD56ejEX1XsDb4nn+KbTObEy9M/q9muh6JsMHj4YqELLUDl7G8i4Tcxep1Zqd4JqRD+gy5weMvEacRs/UdM6IVDOw/DHo/3kOVV+j/ryfq78HhKpYeYOW+hztjQiAsluGpzUpMNiwu2ANjSp982xRM5ZTk/38fZ/aCZanQz30WPeZS7WViqGN5CfXUP2xz7+X2ItigyvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sxb6G1FuaRxJ9ncyLvGzhekHKpfh1AIvttwzeqKE+5U=;
 b=a2PhljtVhvosKil5u1dbi8JlVNqiHjOmZsUAnk3nKe9qcrELhvoz8f4/xIx+bOVrFqv98zvm3PjEYcqN0/hC07SvQJ8WI2Kg/1oWOlcxAWIg8hFIqTzlWJBjfSqfzMTcHlm8CJ89KGUvoV05LZVGczcYFzVL26ckK+y4KV8TCBtzuJpSMFb/nJSf2NS/kgr2Hkf6799tcYif7I7ykdtttHxPUpkE69SvgQD8Zsdr/G/Eduw6o94OXouh/+GEbZph4EEM8zRsmr6IPQfrLYEsAA6+99lByAR7LJngWPuNekHUAd1Vx8MxoSfdD+E8Vlwop91Wmw4gCOxp/snWaKZdTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sxb6G1FuaRxJ9ncyLvGzhekHKpfh1AIvttwzeqKE+5U=;
 b=eNPX3Hyb369YxkkuhVMMlhdZa+1eGT9YNCArzVCrD/oxVn9tKtauKQx2VluItOMzTHdREFbPdV9CBkU2IJjDnop5ZfnNfwC9U/kmGgtFW+31a/uTO7er65fzc96B68SUc9Rr2aum/wmMKwbIvxG5bkA5ooJFOtVQIqAG5/xBBT4=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1360.namprd11.prod.outlook.com (2603:10b6:300:26::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Mon, 2 Aug
 2021 20:46:01 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 20:46:00 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Topic: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Index: AQHXh68Y1owt0G/CUEakzTAdq+RvtqtgbT+AgAAzuICAAAqYAIAAAkng
Date:   Mon, 2 Aug 2021 20:46:00 +0000
Message-ID: <CO1PR11MB50892367410160A8364DBF69D6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <CAK8P3a3P6=ZROxT8daW83mRp7z5rYAQydetWFXQoYF7Y5_KLHA@mail.gmail.com>
In-Reply-To: <CAK8P3a3P6=ZROxT8daW83mRp7z5rYAQydetWFXQoYF7Y5_KLHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd99532c-88f2-4dcb-427d-08d955f689b0
x-ms-traffictypediagnostic: MWHPR11MB1360:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1360505143A6B38363486C7DD6EF9@MWHPR11MB1360.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L/8kJRVHq+aJp3aHeeCzfeTBAzl9GhjRQkx44+yrtXyR0arCNTc0WsQGWn8UfX2oN7m0QnNCYigMTXHiXclzjx+A0NbBBXN1WuSHguMYNUmfqEXfpmouhrfjKCjzrORzaC1jTwh5BJlj/9vcTnBc9FSOiJUq37/pkKrbW3fS71nAsDszqliudj2y7ntIGffYS1Fsxpikr0SWNiEJXvD2cNwVW8sd87Z0j0HUZrsAnjTYUAiwovUQG2mwckBJJbTah+TgkC/B2eplZpSA1Zkj3c/jRN34Dn5LKrNUjN4EUNh4lM3VvwWoRyNdQipRP+E76NbImln/0rljImLnM7nG3RHHAEctbzW6On3aQXXBOUZkAxun0O9KEA58DWwPyAVLnjQ8lM65Q34gZWI/Xq1JJkjQ3VuPH7flmrMYr8gDcr5+xy7fXKLwvNynDgw+AJWkqVOlKDW+HSIc7fQWSVAIVn/0tyPIgQ035mZXrdFyR5Nxn3BSmunIAZ3ud0rlinpJuIyP8lZX2WCWwfuKCS3qlOrgPNsHVb3l3AlO4n6zTrf8DuMTx4hXMxuumRD9kqIwLOUT4Dwzh8/zmup9hMnxxAPaigkJXPH9aqL/UNiAfVy2bqL720HhTzDQybYLkzCNCTNy70sM/buKAtGTA6oenCT9IIKPsEHfmF9EO5PvwahIdUGvqsOGI401EgO+GU36QShANJ/pe7+pXdBF1lzEIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(53546011)(7696005)(186003)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(6506007)(71200400001)(26005)(4326008)(52536014)(86362001)(33656002)(83380400001)(38070700005)(8936002)(8676002)(5660300002)(38100700002)(7416002)(6916009)(9686003)(54906003)(55016002)(316002)(478600001)(2906002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2twNUNJU3BlRUZtQ3Y5bm5hK29UWGtMT3U1aE03elBQUHdJSFpIMlIwV0dv?=
 =?utf-8?B?VzUvb3FrbWQ4TGVTZUp2RVhvOGY3c2M1WEtGODFrUDg3SGFEN2Q3d0k2WTF0?=
 =?utf-8?B?QUtNUXJSRDJ2dFcyc1lnUmVQMkc1TzNCYzYyWmNTejcwbXkyUUJXWW42R1ZB?=
 =?utf-8?B?NDNiVmJ6V2VUdFdnRmgydGJMQWVxeXp1M2JxRzZkZ3FlVWxud1YrbENjMzBs?=
 =?utf-8?B?clFIRExqWkUyMmFPM00xR1VqeTlLckNJY2VHU2Y2UUVTYWhjQ3A4Q2NHQU9j?=
 =?utf-8?B?aE00bTZ1K3J1WmtJVGxheklDVTNROW9pVHdZNlBScFc4SUZObnNUWjY2TzlZ?=
 =?utf-8?B?T3RMdkh3Z0QxSDMrQWdTOXRZYmZUeWFxM3pZbmptUmp1dnNhU3g2ajRIbHBw?=
 =?utf-8?B?eHR2WTBLUXk1N2hnS0V1eGQvNzdMTnk0Y1NESWswVDFydmMwcWYwYWRxQis2?=
 =?utf-8?B?OUdJdm10bnZrV0tEenlpRElVTTBLcDRvQ2NQK1B1SENxVXN2enNmSmtWZStK?=
 =?utf-8?B?R01NanEzcEI3Q3JkMDlQU1liZGlDUnkvZXR0WndmeFF3UXpwWnFHVTNyMWdx?=
 =?utf-8?B?bXkzQzBmM3BqMEtmYmhiNzRCRlU5ZHBJb290WmJSTEJGTHBtd2FvaDFRNkVB?=
 =?utf-8?B?RTJiWmFOTE56dEk0bWZ4NlZwb1FDNWZLc1VFRkc1SnN2MTg3TE9ld21nWlhz?=
 =?utf-8?B?L3o4eThVaUtRaUVWcGdwYXBUdHVnR0dULzk3ZWl5dFZKSmJiVDlxelB5RDBF?=
 =?utf-8?B?NmRFRW1ka2NDOThURmwveDIxQU0zZE5FMUkwRm9aSHJJcHl0a25Hci9CSWtl?=
 =?utf-8?B?eFNQV0dGVnRrbXFPSDFHVzJNRGFDSjJCV0ROdEtNQjZPaVYxUXJ4enQ0dGVH?=
 =?utf-8?B?WG5ScElkaDdWTGNaZFpGaWZzVG1sVCt4RXdpSExpZEpKUjVZTVR3OTBsRzBo?=
 =?utf-8?B?RHNpVEJKdGJETktBYTlTMUwrREQxSnBzVENjd2I1MURqRy9DWmtMZGJCb09a?=
 =?utf-8?B?cXI2dURrQXJIQ1ZSa3pxL3BVd1FoMHBzZGNNdE0yYUZIcXNMYWRtOWdGcFdz?=
 =?utf-8?B?dDM5Y2NqSXVnNnFUdzU0MDRBUGhrZmRPdjRBVHJ2MU5VVkdoSHIvVUFnb01U?=
 =?utf-8?B?ekpCd2V5Mm5abG5vU0NjbHBnUUk1NmJsdVpseVRvUS81dFhUdE5ZYzA3M2V2?=
 =?utf-8?B?S1k2ZXdpbDNzVG9wYVp3UkVNczNmNEZnN3pFL0ZZRFdQL0FJTTNTM2tBODFR?=
 =?utf-8?B?aUJlUzZLaVZEaDBaWkMxdUZkOTJpMFJJQVA4L3psSzhtT2p2R3ZSS1hIbnps?=
 =?utf-8?B?ei9tNEFPUXFVaFBjS21mUldNaUZGZ1BQdEtGK2ZEOFMyTTgxZDc0SStDUE5C?=
 =?utf-8?B?Mm8xTmpTMlNsZnRXNTBRUWlFZE5FeG5raVJUUXlieWpyeTUrekZ1dDV0bTdH?=
 =?utf-8?B?dDF1UTBKR1VjWmdSRjUrTDZvVEVDMFRkNVF1WjZNWGZrWDRLaTdLbnpZQVZ3?=
 =?utf-8?B?TnpCb2tveU9YQTRCU3YwY0U1dXNiek5VVjV5cjdBbytpZEd3TFBXenB4cHBO?=
 =?utf-8?B?MGhtcW1wemlYdmhDNzJNYlN3R25zNTlvS1ZsNmp0YjlXbTZrZUZKTDFLWHg3?=
 =?utf-8?B?OXVhaVN1NGtOTUNTY1haKzQzc0Y5dkZXV3JpQXJRaWZPOW9vSXNTUlJhaDZm?=
 =?utf-8?B?TmJOZ25adC80Tlo1L0JLczI2c3dMbGovWDdPeG51VFRzWVhsS3FPa2srWHVh?=
 =?utf-8?Q?5KoxbNoYkWl+wqwpPo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd99532c-88f2-4dcb-427d-08d955f689b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 20:46:00.7771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BJN1dWlWzLdb65EBRkWgkX60xQqKocFLZzhQwMqGn4yfw44/nnKf2Ekr1T+uwolNVmYx02wGhZ+DHQnz34so/23bQeJEqTG1tJbXMqFuQ/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1360
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJuZCBCZXJnbWFubiA8
YXJuZEBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIEF1Z3VzdCAwMiwgMjAyMSAxOjMyIFBN
DQo+IFRvOiBLZWxsZXIsIEphY29iIEUgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4gQ2M6
IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPjsgTmljb2xhcyBQaXRy
ZQ0KPiA8bmljb2xhcy5waXRyZUBsaW5hcm8ub3JnPjsgQnJhbmRlYnVyZywgSmVzc2UgPGplc3Nl
LmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsNCj4gTmd1eWVuLCBBbnRob255IEwgPGFudGhvbnkubC5u
Z3V5ZW5AaW50ZWwuY29tPjsgRGF2aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0
PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEFybmQgQmVyZ21hbm4NCj4gPGFy
bmRAYXJuZGIuZGU+OyBLdXJ0IEthbnplbmJhY2ggPGt1cnRAbGludXRyb25peC5kZT47IFNhbGVl
bSwgU2hpcmF6DQo+IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47IEVydG1hbiwgRGF2aWQgTSA8
ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPjsNCj4gaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9z
bC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjJdIGV0aGVybmV0L2ludGVs
OiBmaXggUFRQXzE1ODhfQ0xPQ0sNCj4gZGVwZW5kZW5jaWVzDQo+IA0KPiBPbiBNb24sIEF1ZyAy
LCAyMDIxIGF0IDk6NTQgUE0gS2VsbGVyLCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5j
b20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gU28gZ28gYmFjayB0byAic2VsZWN0Ij8NCj4gPg0KPiA+
IEl0IGxvb2tzIGxpa2UgQXJuZCBwcm9wb3NlZCBpbiB0aGUgdGhyZWFkIGEgc29sdXRpb24gdGhh
dCBkaWQgYSBzb3J0IG9mDQo+ID4gInBsZWFzZSBlbmFibGUgdGhpcyIgYnV0IHN0aWxsIGxldCB5
b3UgZGlzYWJsZSBpdC4NCj4gPg0KPiA+IEFuIGFsdGVybmF0aXZlICh1bmZvcnR1bmF0ZWx5IHBl
ci1kcml2ZXIuLi4pIHNvbHV0aW9uIHdhcyB0byBzZXR1cCB0aGUNCj4gPiBkcml2ZXJzIHNvIHRo
YXQgdGhleSBncmFjZWZ1bGx5IGZhbGwgYmFjayB0byBkaXNhYmxpbmcgUFRQIGlmIHRoZSBQVFAN
Cj4gPiBjb3JlIHN1cHBvcnQgaXMgbm90IHJlYWNoYWJsZS4uIGJ1dCB0aGF0IG9idmlvdXNseSBy
ZXF1aXJlcyB0aGF0IGRyaXZlcnMNCj4gPiBkbyB0aGUgcmlnaHQgdGhpbmcsIGFuZCBhdCBsZWFz
dCBJbnRlbCBkcml2ZXJzIGhhdmUgbm90IHRlc3RlZCB0aGlzDQo+ID4gcHJvcGVybHkuDQo+ID4N
Cj4gPiBJJ20gZGVmaW5pdGVseSBpbiBmYXZvciBvZiByZW1vdmluZyAiaW1wbGllcyIgZW50aXJl
bHkuIFRoZSBzZW1hbnRpY3MNCj4gPiBhcmUgdW5jbGVhciwgYW5kIHRoZSBmYWN0IHRoYXQgaXQg
ZG9lc24ndCBoYW5kbGUgdGhlIGNhc2Ugb2YgImknbQ0KPiA+IGJ1aWx0aW4sIHNvIG15IGltcGxp
ZXMgY2FuJ3QgYmUgbW9kdWxlcyIuLi4NCj4gPg0KPiA+IEkgZG9uJ3QgcmVhbGx5IGxpa2UgdGhl
IHN5bnRheCBvZiB0aGUgZG91YmxlICJkZXBlbmRzIG9uIEEgfHwgIUEiLi4gSSdkDQo+ID4gcHJl
ZmVyIGlmIHdlIGhhZCBzb21lIGtleXdvcmQgZm9yIHRoaXMsIHNpbmNlIGl0IHdvdWxkIGJlIG1v
cmUgb2J2aW91cw0KPiA+IGFuZCBub3QgcnVuIGFnYWluc3QgdGhlIHN0YW5kYXJkIGxvZ2ljIChB
IHx8ICFBIGlzIGEgdGF1dG9sb2d5ISkNCj4gDQo+IEkgdGhpbmsgdGhlIG1haW4gcmVhc29uIHdl
IGRvbid0IGhhdmUgYSBrZXl3b3JkIGZvciBpdCBpcyB0aGF0IG5vYm9keQ0KPiBzbyBmYXIgaGFz
IGNvbWUgdXAgd2l0aCBhbiBFbmdsaXNoIHdvcmQgdGhhdCBleHByZXNzZXMgd2hhdCBpdCBpcw0K
PiBzdXBwb3NlZCB0byBtZWFuLg0KPiANCg0KUmlnaHQuIEkgZG9uJ3QgaGF2ZSBhIGdyZWF0IGV4
YW1wbGUgdGhhdCdzIGEgc2luZ2xlIHdvcmQgZWl0aGVyLg0KDQo+IFlvdSBjYW4gZG8gc29tZXRo
aW5nIGxpa2UgaXQgZm9yIGEgcGFydGljdWxhciBzeW1ib2wgdGhvdWdoLCBzdWNoIGFzDQo+IA0K
PiBjb25maWcgTUFZX1VTRV9QVFBfMTU4OF9DTE9DSw0KPiAgICAgICAgZGVmX3RyaXN0YXRlIFBU
UF8xNTg4X0NMT0NLIHx8ICFQVFBfMTU4OF9DTE9DSw0KPiANCj4gIGNvbmZpZyBFMTAwMEUNCj4g
ICAgICAgICB0cmlzdGF0ZSAiSW50ZWwoUikgUFJPLzEwMDAgUENJLUV4cHJlc3MgR2lnYWJpdCBF
dGhlcm5ldCBzdXBwb3J0Ig0KPiAgICAgICAgIGRlcGVuZHMgb24gUENJICYmICghU1BBUkMzMiB8
fCBCUk9LRU4pDQo+ICsgICAgICAgZGVwZW5kcyBvbiBNQVlfVVNFX1BUUF8xNTg4X0NMT0NLDQo+
ICAgICAgICAgc2VsZWN0IENSQzMyDQo+IC0gICAgICAgaW1wbHkgUFRQXzE1ODhfQ0xPQ0sNCg0K
V2hhdCBhYm91dCAiaW50ZWdyYXRlcyI/DQoNCk9yLi4gd2hhdCBpZiB3ZSBqdXN0IGNoYW5nZWQg
ImltcGxpZXMiIHRvIGFsc28gaW5jbHVkZSB0aGUgZGVwZW5kZW5jaWVzIGF1dG9tYXRpY2FsbHk/
IGkuZS4gImltcGxpZXMgUFRQXzE1ODhfQ0xPQ0siIGFsc28gbWVhbnMgdGhlIGRlcGVuZHMgdHJp
Y2sgd2hpY2ggZW5zdXJlcyB0aGF0IHlvdSBjYW4ndCBoYXZlIGl0IGFzIG1vZHVsZSBpZiB0aGlz
IGlzIGJ1aWx0LWluLg0KDQpJLmUuIHdlIHN0aWxsIGdldCB0aGUgbmljZSAidGhpcyB3aWxsIHR1
cm4gb24gYXV0b21hdGljYWxseSBpbiB0aGUgbWVudSBpZiB5b3UgZW5hYmxlIHRoaXMiIGFuZCB3
ZSBlbmZvcmNlIHRoYXQgeW91IGNhbid0IGhhdmUgaXQgYXMgYSBtb2R1bGUgc2luY2UgaXQgd291
bGQgYmUgYSBkZXBlbmRlbmN5IGlmIGl0J3Mgb24iPw0KDQo+IA0KPiANCj4gICAgICAgICAgIEFy
bmQNCg==
