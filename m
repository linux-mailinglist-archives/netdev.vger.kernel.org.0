Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F11633C76B
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhCOUFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:05:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:32810 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234080AbhCOUEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 16:04:48 -0400
IronPort-SDR: Kwk/58cAME83POK5iknhFNM19w5USmLlSxWkn4Hur6i+GqzV5Uo7CUTXgoxL9+tLsp6mfZ/pBX
 jrXqq/5FrKqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="186770325"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="186770325"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 13:04:41 -0700
IronPort-SDR: zhuYoUjNYUNXK60xVISEJN0WQdn0fIuELa/lYPTuddetiopZgoMK4mo4atJWYBkMcWs+JxJIDy
 kAy6dPsWBOuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="410768941"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 15 Mar 2021 13:04:40 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 13:04:40 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 13:04:40 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 15 Mar 2021 13:04:40 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 15 Mar 2021 13:04:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+1kSKyJMPHaCxhP1eLr0oM3vaRGwBBD8vfloZjCPZMBYXApqz9Gfp7XdTfoA6wYEtwOFlFlSNIBBK/6dnYWuNhp33IucbRqU4HR8kvlJizgH7CGEZzRpeQw9a6HY8LvpLmrR1jk0zw436VFbDsdHE31Tx3dc0NuJW+wwMrTytxsWUUtZeSuBvbbRPZpg3ingQpKZLgG7M/FciF0VmoMxmbwIxYiAjo/95/3ohDXkhtoSLVS133uADlv2WhyCQ2CoQZNf82a2JdhNpsu/oh00FU5wDUadk3tVan94aQybPiHYgfEmRkZLqekPGTPt8KVEa7Rdx1iYr+0X3DgZMxxjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAxkKkH3EwOO9vuEKf6gY8xUVu1T2dXtFlL0bNIYSDc=;
 b=P9S3x3PYC1xZYYg5N8/tP1ag1CT3CM6ADembRAbDXr2+GzU/2btxpWxICpUHDWs8Ym8/csuaqquP+N0VmhFjujtMCHsfSX7kccKcuNqvVOq6lad6HyDyL+A+wC1V3NJWM7PXLoIIiDxkLPwdJ1gQ4F+H3m3HTrgLmmijtxgE8Bceg0VMTzPPWTtS2II/Qhh0V3LrIXcebnvz6QMQbh/Pyf7os0BwW30sG2xNm2jxA+wauC8rGzlkPR+AtJobkY4EgdWg+FVuC0VYN21IAFkFjq81OP8PC1ki57wXanFb+mOVV2Hf+Qzqf+UpYZ3x0XGxR2ChQi2/5TDLgztbUYTuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAxkKkH3EwOO9vuEKf6gY8xUVu1T2dXtFlL0bNIYSDc=;
 b=UHXZRq8YipzB/vnUXxKHt2xPXg5ETLqLRy/qib8oDztEUVlWV+XfdP80QOjlTpQ3yta72c+L5gvqIPFHuwweaU8An9mdL4qxzJ13vOFXvNP8VfjDqx16IlvJD87ljcstS/Jr5VMesq2IsvC4tDtobeULLLmtjQdfzoUZ7pAadsM=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BY5PR11MB3957.namprd11.prod.outlook.com (2603:10b6:a03:183::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 20:04:37 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 20:04:36 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [PATCH v10 00/20] dlb: introduce DLB device driver
Thread-Topic: [PATCH v10 00/20] dlb: introduce DLB device driver
Thread-Index: AQHW/9Zt8wdlPnXnkESxoD5/CU9Koap9GIKAgAMHmACAAN/QcIAAU8sAgARYeQA=
Date:   Mon, 15 Mar 2021 20:04:36 +0000
Message-ID: <BYAPR11MB30957D871AF159CB7BB7F753D96C9@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <YEiLI8fGoa9DoCnF@kroah.com>
 <CAPcyv4gCMjoDCc2azLEc8QC5mVhdKeLibic9gj4Lm=Xwpft9ZA@mail.gmail.com>
 <BYAPR11MB30950965A223EDE5414EAE08D96F9@BYAPR11MB3095.namprd11.prod.outlook.com>
 <CAPcyv4htddEBB9ePPSheH+rO+=VJULeHzx0gc384if7qXTUHHg@mail.gmail.com>
In-Reply-To: <CAPcyv4htddEBB9ePPSheH+rO+=VJULeHzx0gc384if7qXTUHHg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10b3621e-6ab6-4a88-6892-08d8e7ed8f43
x-ms-traffictypediagnostic: BY5PR11MB3957:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB3957AE3FAE6896F149D9B1EAD96C9@BY5PR11MB3957.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jy/QHubyVtwbmXniD1KT/B3JG+kup6G2bybpE5lyd4viksh8T+hQiVXqYGNZWUWISydxeFsaY1sW1EdU4tGDroITfPeqQaQNkfNFSUt5pALeJ8mvfdljHPMwJGv3VrPygxch0P+uVA0GDTUXmdPIKHdfgPhAvImbSUelwaRSLPINj42U/iMKq8bx4yceXPk5lw1UkaRqW1JyqJOHBm9qMdxZKKQMb8rpdsovPziIIORj8uUDViorpO+Kv/HXAc3y7ASIhgbPR8ccWDMfIdzWFNw1ewonZj/kWaCAC1/uyWsDqPVV9Kz859ocPyqjj+x7SJ0cfrlCCOF+8xIrbLeJ+7kfPjcYhTTUDzcq0A4vpEMVSHhATvggqJMuMQBaZ75ShlNv8JV5gNmzCrj8VVI1eKoHpHMO/pPdK2/dLHSX60WY8qPgiazp9bxkhjJfqcX40Ikbf8vGmH8ZjBpmqSx0NdYWoW7nM7aw8rnEZXkR/yrJwvzEAjhrG6ydIfdkVo88SJ09WTOOu9qoArV+LeyWgvpfQXS8olEeXKpUPRFC25gACUlrDxP8TrxYwwwl1g0+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(6862004)(66556008)(6636002)(54906003)(64756008)(66476007)(76116006)(66946007)(66446008)(33656002)(53546011)(52536014)(8936002)(71200400001)(186003)(83380400001)(316002)(26005)(2906002)(6506007)(7696005)(8676002)(86362001)(9686003)(5660300002)(55016002)(4326008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SUd6MnFkd1BMMHJBWjlGOW05bGdQU21ET1NvbGVDUVZrRmxyRytES2l6K3I1?=
 =?utf-8?B?eUNuRlNqMHZTTU9BVmJBUCtSVmNDMGtVbmhMQnowYzZBVUZsa3hsTEt6K1J6?=
 =?utf-8?B?S0FjNUlyQ2MwMk5wVnhYMnZMVVZwWGRlMUhYSXYwYkREZ3J1OGYyUWcyMXpL?=
 =?utf-8?B?Z0M3ZGpiQlFlaUhKWW8zeGQ2N0NoNGNBcEtqa3hXTTBQajg3NnNnNC9JMDR2?=
 =?utf-8?B?UE0xTXVtUitrTVNValpCMjJXUmFsVGN2N3ZoaSt0SXdtV29oWjRFTFhYcEJO?=
 =?utf-8?B?akdVU3RzaEg2dXplSWxBNmU4RkZBTkV3Y2pFZmhlQ1I3ZGdGQUd5bkk3eWdS?=
 =?utf-8?B?UEdIN2hpUERTK3dDclBiU2RMZ3Rwc2p4dG10T0FmbmVQVUF6K3hENUpOUjQx?=
 =?utf-8?B?R3Rza3ZWVzUzcjliL3NkQ250RDVlVWtpS29yaElEczVyNXQ1Y0xuQ3I2SlBk?=
 =?utf-8?B?UWNTYi9aZTYzaTFhaHpJOG9NRkNRWHpNbGdGbExHY2I4VVB0VE1yc1Uvc0dN?=
 =?utf-8?B?U3hXWm5taGFOUkVLSG9rU0RTUTNTN1pJNElPZTdqMm0xdFpTNWZKZllVYXNs?=
 =?utf-8?B?Y0dheExjOUwvb1YyVzdTR2ZLZ2xERExvaCtRQVhJUVNacFF1bk5wd3RqektZ?=
 =?utf-8?B?anJhalNPTGZJcHlBa29mckcxVjRsNWcwbHZldWw5Um1DdU4yMlBXbzRIcjNV?=
 =?utf-8?B?RDRMVHlja3UwNE1iOWlUanhML1NTT1BFTTN5elpuWHU3MWpkaWZ3UlJtQVBL?=
 =?utf-8?B?RVpNZjd5Z1hiOXZOdWlPd2grU2g1OE84OHpHa2Y3WVJJcUM0d0kycVFTSkds?=
 =?utf-8?B?aStsYnZzVGo1blZMRk8wVjlTNTlYL0NETGZhWHpqNFo0MmZTamU0RHRGbTFX?=
 =?utf-8?B?ajBLeU9QVWN4MThYcHRoeXNCbTFkVDhHeDJ2SjFTWTNKRk53VFEzZmJ2Y1hH?=
 =?utf-8?B?TkdxSTNtNkhSK2FUNFV0TGFUdnFjblVIUURsTmVpUk1mNXduYlpITWxpWUFM?=
 =?utf-8?B?WWNjdFV2YVhwRFRWWm8zeXIyalRlTlNvc0NuR2s1SmZqWXB1K2hmZHprdnE2?=
 =?utf-8?B?TWFIWmNWd1JFS0VCMUFub3hPZWpWUnM4Um81emhTV2tDS1N1UEw4eEFOcm93?=
 =?utf-8?B?M3VrNHlZeEhZN3AzSU95RUhOZjI3MWpjVExkWFZBdEdkMFBBVkJHcWZpeVht?=
 =?utf-8?B?dDJON1lrQnNEMXY3MW8yTXJ6MTI1U3BPdHQycEJDd2lVTWR0K0RmOVUxTzJk?=
 =?utf-8?B?bHVpUXkxcHZqcFI1WXNIMUhrb2x5MExOSlNKQllqZ29WakxmMysvRmMrd2xz?=
 =?utf-8?B?bGtOb1Y2Yjcyd0hHa3h2ZkppL3pvbUpONjIvT2xUS01WSGlUSG0wcTFVZkNR?=
 =?utf-8?B?TnVpRUZZcGhBMEl1NGorZFVJdkZoakJ1OXo4U3BObjYwUEtCZWF3S1hCSUdD?=
 =?utf-8?B?a011aGU0QW9uSkdBaDdlYkxWM0Vycmk4dmN6ejZibWNTYVJBTUJSZzFOdENY?=
 =?utf-8?B?Wk1wcnpZRXMxUTl4R0dFZ0ZqSGtLTjlwODQyUGdTTTYyc0FDWFEwU2ZkZWtC?=
 =?utf-8?B?WkJ1OE0zSlp5NnZQbFFmUWxxU0tZa2JIdGU3ZlB3cEpOSkxqSmtWemQ0TlJS?=
 =?utf-8?B?djMvL2tObGdqeEVlbGNkZENoQVphWCsrU21Qb3NhRUE0SHJjL056MW1taXBU?=
 =?utf-8?B?Z3JmYTRGVng2SnVDdXEyc1loaGNtTGUrTU02UHJMSkducUpXcEhwbER6enZC?=
 =?utf-8?Q?uEExdi3cyZSPWUz6iq5XHXAs77SS6W3dlEGa6jo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b3621e-6ab6-4a88-6892-08d8e7ed8f43
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 20:04:36.8420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: luUwW6Zlr5ObM9r+NjrtuyHC+HyfpxjjbP2uMtEy0WUbjA/zR/mhC3NGf5y1MHfv2t6astrqHEVS3/XZXhUBD7Vm8qUs9fSdS4+NPsjZb5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3957
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gT24gRnJp
LCBNYXIgMTIsIDIwMjEgYXQgMTo1NSBQTSBDaGVuLCBNaWtlIFhpbWluZyA8bWlrZS54aW1pbmcu
Y2hlbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gSW4gYSBicmllZiBkZXNjcmlwdGlvbiwg
SW50ZWwgRExCIGlzIGFuIGFjY2VsZXJhdG9yIHRoYXQgcmVwbGFjZXMNCj4gPiBzaGFyZWQgbWVt
b3J5IHF1ZXVpbmcgc3lzdGVtcy4gTGFyZ2UgbW9kZXJuIHNlcnZlci1jbGFzcyBDUFVzLCAgd2l0
aA0KPiA+IGxvY2FsIGNhY2hlcyBmb3IgZWFjaCBjb3JlLCB0ZW5kIHRvIGluY3VyIGNvc3RseSBj
YWNoZSBtaXNzZXMsIGNyb3NzDQo+ID4gY29yZSBzbm9vcHMgYW5kIGNvbnRlbnRpb25zLiAgVGhl
IGltcGFjdCBiZWNvbWVzIG5vdGljZWFibGUgYXQgaGlnaA0KPiA+IChtZXNzYWdlcy9zZWMpIHJh
dGVzLCBzdWNoIGFzIGFyZSBzZWVuIGluIGhpZ2ggdGhyb3VnaHB1dCBwYWNrZXQNCj4gPiBwcm9j
ZXNzaW5nIGFuZCBIUEMgYXBwbGljYXRpb25zLiBETEIgaXMgdXNlZCBpbiBoaWdoIHJhdGUgcGlw
ZWxpbmVzDQo+ID4gdGhhdCByZXF1aXJlIGEgdmFyaWV0eSBvZiBwYWNrZXQgZGlzdHJpYnV0aW9u
ICYgc3luY2hyb25pemF0aW9uDQo+ID4gc2NoZW1lcy4gIEl0IGNhbiBiZSBsZXZlcmFnZWQgdG8g
YWNjZWxlcmF0ZSB1c2VyIHNwYWNlIGxpYnJhcmllcywgc3VjaA0KPiA+IGFzIERQREsgZXZlbnRk
ZXYuIEl0IGNvdWxkIHNob3cgc2ltaWxhciBiZW5lZml0cyBpbiBmcmFtZXdvcmtzIHN1Y2ggYXMN
Cj4gPiBQQURBVEEgaW4gdGhlIEtlcm5lbCAtIGlmIHRoZSBtZXNzYWdpbmcgcmF0ZSBpcyBzdWZm
aWNpZW50bHkgaGlnaC4NCj4gDQo+IFdoZXJlIGlzIFBBREFUQSBsaW1pdGVkIGJ5IGRpc3RyaWJ1
dGlvbiBhbmQgc3luY2hyb25pemF0aW9uIG92ZXJoZWFkPw0KPiBJdCdzIG1lYW50IGZvciBwYXJh
bGxlbGl6YWJsZSB3b3JrIHRoYXQgaGFzIG1pbmltYWwgY29tbXVuaWNhdGlvbiBiZXR3ZWVuIHRo
ZSB3b3JrIHVuaXRzLCBvcmRlcmluZyBpcw0KPiBhYm91dCBpdCdzIG9ubHkgc3luY2hyb25pemF0
aW9uIG92ZXJoZWFkLCBub3QgbWVzc2FnaW5nLiBJdCdzIHVzZWQgZm9yIGlwc2VjIGNyeXB0byBh
bmQgcGFnZSBpbml0Lg0KPiBFdmVuIHBvdGVudGlhbCBmdXR1cmUgYnVsayB3b3JrIHVzYWdlcyB0
aGF0IG1pZ2h0IGJlbmVmaXQgZnJvbSBQQURBVEEgbGlrZSBsaWtlIG1kLXJhaWQsIGtzbSwgb3Ig
a2NvcHlkDQo+IGRvIG5vdCBoYXZlIGFueSBtZXNzYWdpbmcgb3ZlcmhlYWQuDQo+IA0KSW4gdGhl
IG91ciBQQURBVEEgaW52ZXN0aWdhdGlvbiwgdGhlIGltcHJvdmVtZW50cyBhcmUgcHJpbWFyaWx5
IGZyb20gb3JkZXJpbmcgb3ZlcmhlYWQuDQpQYXJhbGxlbCBzY2hlZHVsaW5nIGlzIG9mZmxvYWRl
ZCBieSBETEIgb3JkZXJkIHBhcmFsbGVsIHF1ZXVlLg0KU2VyaWFsaXphdGlvbiAocmUtb3JkZXIp
IGlzIG9mZmxvYWRlZCBieSBETEIgZGlyZWN0ZWQgcXVldWUuDQpXZSBzZWUgc2lnbmlmaWNhbnQg
dGhyb3VnaHB1dCBpbmNyZWFzZXMgaW4gY3J5cHRvIHRlc3RzIHVzaW5nIHRjcnlwdC4gIEluIG91
ciB0ZXN0IGNvbmZpZ3VyYXRpb24sIHByZWxpbWluYXJ5IHJlc3VsdHMgc2hvdyB0aGF0IHRoZSBk
bGIgYWNjZWxlcmF0ZWQgY2FzZSBlbmNyeXB0cyBhdCAyLjR4IChwYWNrZXRzL3MpLCBhbmQgZGVj
cnlwdHMgYXQgMi42eCBvZiB0aGUgdW5hY2NlbGVyYXRlZCBjYXNlLg0K
