Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27BD3DE036
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhHBTmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:42:13 -0400
Received: from mga04.intel.com ([192.55.52.120]:62958 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhHBTmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 15:42:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="211651756"
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="211651756"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 12:42:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="510377030"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Aug 2021 12:42:00 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 2 Aug 2021 12:42:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 2 Aug 2021 12:42:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 2 Aug 2021 12:42:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXSBmFBLSM1OTtLwniYoqk+m08Dr9X3gZwBeTFe25U65jIFmg0yNEki2jCysdGslCAXvzthVorYJhSF0HttAP0c4heYUy/MgW5W5ewj3ZZYpSg0CNJkLqnUAoqE+jS41RWWzTpGPbYx62wvg26y8PSkWEW46qewcG2Kd2y6IV0Dr907qr9gTBuSCe/+7ksrQqI0kGUG1Qt+7KPIj2/pKgNFiF1OxcbaF6VZUOwfzGLHLkEbbDWSQpRKUfnhqQ7NRxyQS3xww47eIa6YgBLEug5MR99qGisj/PKFZki3YBcctLjFTvkMrL/XyyOR4GOpMVVi3/z8x25AGTYU9bHBChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BSRHyh0bqRoj2yv3Fe3KivBlIhMqYo1LsymJCjKd3c=;
 b=Y6W2zdIlRM4x1Ie2rzHBCQe37s3jEUEPQ6IcbYm6pIfgdQ7j/xwlzEWZrKv3YU5bzEnCOOGZYOnV35K2pAcR56lKm7xKb+HJVM4u4glaRt23b/1XR+BbS2UogE1KDZ7YNi6pb9LLVStc+F/4aFuP5eassbK7mIPYxDvky/7hSxNETNyDl4hHZ1ePCEadcYIFY5POOvjGyD0VJnTwiwAA55dYCH6hpEzlBaztSkOxxvaJaF0XDE9krfYS8GLtXSmgKZwAqOLQK3nbw+DLGHzr1rV4mFeH0Xo/lnkjmEJYc1mQwTh8p45V9aBOfUVD7CEDuUOxH51mAJJ6SpVcyZtB2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BSRHyh0bqRoj2yv3Fe3KivBlIhMqYo1LsymJCjKd3c=;
 b=S2LlJC1v9Qoo9MQtpk5heghW5HL5m2pPtW4d7b6+5EYFV8p9Iy78/ZumMlQB0Rp3wQGJUq1gsM+/kEkMg71Hov5QMhtdULZHO4EoYUbUqdYPAuVR4NhsYde2bRVPu67Dn5/0RDQaCyS92SF9TvESUEXKU2LR5J1DdwxO3Q0cq1g=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1776.namprd11.prod.outlook.com (2603:10b6:300:110::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Mon, 2 Aug
 2021 19:41:59 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 19:41:59 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Kalesh A P <kalesh-anakkur.purayil@broadcom.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edwin.peer@broadcom.com" <edwin.peer@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 0/2] devlink enhancements
Thread-Topic: [PATCH net-next 0/2] devlink enhancements
Thread-Index: AQHXh1TC6QV6AUyKYkGu2P8g6Ld1/6tgamQAgAAz2IA=
Date:   Mon, 2 Aug 2021 19:41:59 +0000
Message-ID: <0152a495-9cca-db62-ccdf-be7231215db2@intel.com>
References: <20210802042740.10355-1-kalesh-anakkur.purayil@broadcom.com>
 <20210802093622.17c29268@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210802093622.17c29268@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd5f5ff6-152d-43da-73dc-08d955ed97fd
x-ms-traffictypediagnostic: MWHPR11MB1776:
x-microsoft-antispam-prvs: <MWHPR11MB1776260720C1C89852733478D6EF9@MWHPR11MB1776.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 78Tyoczb7G4McHymmkHdhY0ps4yjrO2g4hqpfHCGHIIhTMJes4nkq/ahYFl//zcYSIv6yl6ErArBW/vgdYPbP8aVQbexXzsW6n49tmtC0fRa51SXww6jeC22je34WE+K2RpM7oxHur7q6XCYNrAzxt4MGDiebSlX5a3SHPa43JvAFKTkFqeNxCqBTFHQlhnCr/1VjBBoqUh7Gd28b0saFbeeEtyQyWzWTLp9ljMSgAghAxddzQ9tBEQTlcvezJ0iqD9YonY1W8/LV8jkhb6vvzP3H7fIdSnuwd2BxMbwAZZ2h4DfP0F2LhzcsgUR3KHl6aqM6FouD2T3GNaip63xXcAUAznoB4hb7nR1ew268vL3hEvQEWlSw1VKK7g0+SkVAGpwI9p+6RrYrDvXffTbmFL8VNABrCnMKNGKZXgnJZPUFAmBfUsGMLDI3rhHVFWRcnmnPilsOjzUy931frJFftaym8hq18Q7nl4CCJon2QAPGkLfmrS20CdaBJzHnxvY2CCWp0XiIW3E/HxVvDuJbwn5oY2I7qNbkJcug5+lJx9cqgacy3tPCQwm+5PAtJxMxq/Gus0X9tA8xVjLEgatbpT87MmyEav8O+HirmHv3HY/y0H+SxCNgmKGprW791ZkAIsSyLKTc2SZyN2NXSxwczdt+IdIMc4aWAli40tJEPimWvFHd+6Wvp4PcvJVZJ5mn9btqXo7TYoc3/Rtk5BED3OLxzuETZWDZ88O9QLszQIObgJNbWhfNgRbyjSWi9bUAiWs5TKWAV4ssleHTu+KDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(5660300002)(508600001)(54906003)(71200400001)(38100700002)(86362001)(4326008)(53546011)(122000001)(2906002)(6506007)(38070700005)(8936002)(6512007)(6486002)(8676002)(110136005)(31686004)(316002)(26005)(186003)(66556008)(66946007)(66476007)(36756003)(64756008)(66446008)(76116006)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2pxZFJnVEhqOWpsMGFPVmU0Ylord2xtWGxnQVBFWURKWnNpUmozWGJkT2M3?=
 =?utf-8?B?V01TN3pWc0RQelR0Y2VYQ1gvYUVZTUxNaU5OKzV6MkV2ek1zRENnV3VTUWZ1?=
 =?utf-8?B?cm9SVml6TVZwNmtzeG1aRjJ4bEl5SVFnMGZSMXo1MEtyRS9hQTE1NStyZlZR?=
 =?utf-8?B?RktFeHpxc2NLa3BvdDMzWnFoanNaaGJFMXFUc1F0WXN4VTB0WTNHU3g1TlMz?=
 =?utf-8?B?bkpydTliWFU5TjE4UjNmWlpleHkraXVCY1hnczZKRUFnSndlTEFRZWhDSGVL?=
 =?utf-8?B?VUlnRE9sZ2UxNDJVNFdIWkR0S2pJTm1LY1pVdG9mYlpLTUVWQzMyZDJGcDFJ?=
 =?utf-8?B?Y1NNV2JMaXZhWjI3OU9pSTIxaGw3eXhtdjRlYzVvWnpTZVYwN0c3Y0ZDTGpp?=
 =?utf-8?B?UE9zbjlFTjlEUDQrZmhSMncxaGRGSjhnbXVMblF5ZWxyeDlGNURtWTZEVEJM?=
 =?utf-8?B?NkpaN2tJV1RYOHZwblRzcUQ0NFJEczhMcENtRW53T0VOWkUrS09zeXlvVk1G?=
 =?utf-8?B?aTB6VEdReVN5YWJHaXhaaDlIVjVZT2d6c3VSS3poL2h5ajB5RG9CUXJiNmtB?=
 =?utf-8?B?WDBxZ1hSVTlmbmp3YXVRSTN2VDUzNTdRS3kyODh3WW9USVcxWmtvVjR2a0Ny?=
 =?utf-8?B?RlpyZWdEQThuaWR6eWxZQ0Y0THBHcnVTdGhTY0w3MHVvZGlmZ290VzU4Z2Ev?=
 =?utf-8?B?S3pYaWJoSzJVblJoVFBqOUN1anJGZUxqemsrRWM1cWx2QWk0SVltdFJtYWlu?=
 =?utf-8?B?ZFRHT3k5Q1Y0TzkxTXJaaGlqVmJvSTlJUW5vRlZHTXF5RzF3amNvRzlxSnBQ?=
 =?utf-8?B?MzZFV1d2NE8yUE0ranFDeFRmTmdVSzNmNjE4TEhBdS9IY0gyMCtraWNNQ2Zi?=
 =?utf-8?B?emtvMmVoQUluY2hiOVRTVnhtSUFNVmplWW9RNlJWQWRVaEtDeFJBYVhMVzNX?=
 =?utf-8?B?eGM1TjdEVUJwcTEyY015TjJwSFNWSzZvYW5JYTZXUFdPQldqQ3FMZ1lHMlZ4?=
 =?utf-8?B?SEREcHVDUGR4aUJzRTBva1RtVzNsQlpMZUNyQ0IrUW1tSDRVVGliazJMSmtq?=
 =?utf-8?B?ZjJpL1FCeGMyU2l3R3NuaVRVQzZHUU5tUFRnVnZBSWw4TURrMFRFcnZkQnNu?=
 =?utf-8?B?OVFCcm1iMUFObVdUVithaUMzWkVGd05lUnlXVlFWWldWNEEzYTdGNnhwYURv?=
 =?utf-8?B?NDNhQmk5TWIzQ1ZwdVdqYnBGU0xyTmJrSWl4WUJiWm9INVVydi9iNkdiVGNo?=
 =?utf-8?B?UDVSZk51RXN5RE14bnlIWDNpVGw4T1o3Z2ZrZ1BOZ2FPTWFFdFpFUncxNE1G?=
 =?utf-8?B?Y3RuQzVJYS9QWGlKdFB3RlZFbG1PNWVqejdIZkc2RTVxejEvUkZScTFLa0wv?=
 =?utf-8?B?RkJGVER0S2wxcnM0djR2NVZCUnJFQTlPMS9EMGdKOVhGQUw2ajB4U0tMYW8y?=
 =?utf-8?B?bHNXQUMrd3FvZVZ6UStoREN1K290b2RaMW9tOGQxVFdLTHJIMGI3WUVBQjBD?=
 =?utf-8?B?SWdxa3d5NXVjZ0lkcE1BUHdxRTBXcXNNRHR5S1Y5SDJtTHhTenNnQ3liRXpt?=
 =?utf-8?B?YW5ORGNmYjFWL0NpZmlaWTlMcXNCa0I4Q0lUdVlLcS9yd3VzT1VlWTVLbDNN?=
 =?utf-8?B?QjBwQXU0T0lkdU5JeGx6M0Zhd2FmS1BOeE56ejUvWHVJTzgzOWorSkxqVTJB?=
 =?utf-8?B?TkZvSjF0MDRZOElPSXVBZ1BNZm5IOGpCVjlIamwyN2VlS1R0RXNaS3hSTnNo?=
 =?utf-8?Q?81L8Wpat7hDBUQV+nc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C3D84AAB3CD284DB68BEA590D36133E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd5f5ff6-152d-43da-73dc-08d955ed97fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 19:41:59.4638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ppu8DuriG1QxzOWMj4QolRkzHtQ7l9fwK5VdbVIFvgueuz7sBh7eVlBnqNCWthohfZ7moMO31GanoW8u/x6dfiP1pThmAR1Jj9qME3x8Uno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1776
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yLzIwMjEgOTozNiBBTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIE1vbiwgIDIg
QXVnIDIwMjEgMDk6NTc6MzggKzA1MzAgS2FsZXNoIEEgUCB3cm90ZToNCj4+IEZyb206IEthbGVz
aCBBUCA8a2FsZXNoLWFuYWtrdXIucHVyYXlpbEBicm9hZGNvbS5jb20+DQo+Pg0KPj4gVGhpcyBw
YXRjaHNldCBhZGRzIGRldmljZSBjYXBhYmlsaXR5IHJlcG9ydGluZyB0byBkZXZsaW5rIGluZm8g
QVBJLg0KPj4gSXQgbWF5IGJlIHVzZWZ1bCBpZiB3ZSBleHBvc2UgdGhlIGRldmljZSBjYXBhYmls
aXRpZXMgdG8gdGhlIHVzZXINCj4+IHRocm91Z2ggZGV2bGluayBpbmZvIEFQSS4NCj4gDQo+IERp
ZCB5b3Ugc2VlIHRoZSBSRkMgSmFrZSBwb3N0ZWQ/IFRoYXQncyB3YXkgbW9yZSBwYWxhdGFibGUu
DQo+IA0KDQpGV0lXLCBteSBwYXRjaCBpcyBtb3JlIGluIHJlZ2FyZHMgdG8gbWFraW5nIHN1cmUg
dGhhdCB1c2VycywgdG9vbHMsIG9yDQpzY3JpcHRzLCBoYXZlIGEgd2F5IHRvIHRlbGwgaWYgYSBn
aXZlbiBkZXZsaW5rIGludGVyZmFjZSBpcyBzdXBwb3J0ZWQuDQoNClRoaXMgc2VlbXMgbGlrZSBh
IHdheSB0byBpbmRpY2F0ZSBzcGVjaWZpYyBkZXZpY2UgZmVhdHVyZXM/DQoNCj4gT3BlcmF0aW9u
YWxseSB0aGUgQVBJIHByb3ZpZGVkIGhlcmUgaXMgb2YgbGl0dGxlIHRvIG5vIHZhbHVlIA0KPiB0
byB0aGUgdXNlciwgYW5kIHNpbmNlIGl0IGV4dGVuZHMgdGhlICJsZXQgdGhlIHZlbmRvcnMgZHVt
cCBjdXN0b20NCj4gbWVhbmluZ2xlc3Mgc3RyaW5ncyIgcGFyYWRpZ20gcHJlc2VudCBpbiBkZXZs
aW5rIHBsZWFzZSBleHBlY3QgDQo+IG1ham9yIHB1c2ggYmFjay4NCj4gDQoNClJpZ2h0LiB0aGUg
YmV0dGVyIGFwcHJvYWNoIGhlcmUgaXMgdG8gZW5zdXJlIHRoYXQgd2hhdGV2ZXIgdXNlci1mYWNp
bmcNCmltcGFjdCBvZiB0aGVzZSBmZWF0dXJlcyBpcyBleHBvc2VkIHRocm91Z2ggYSBzdGFuZGFy
ZCBpbnRlcmZhY2UuIElmIG9uZQ0KZG9lc24ndCBleGlzdCBmb3IgdGhlIGNhcGFiaWxpdHksIHlv
dSB3aWxsIG5lZWQgdG8gZG8gd29yayB0byBjcmVhdGUNCnN1Y2ggYW4gaW50ZXJmYWNlLg0KDQpJ
ZiB0aGVyZSdzIG5vIHVzZXIgaW1wYWN0IChhbmQgdGh1cyBubyBuZWVkIGZvciBhIHNlcGFyYXRl
IGludGVyZmFjZSksDQp0aGVuIHdoeSBkb2VzIGEgdXNlciBuZWVkIHRvIGtub3cgdGhlIGNhcGFi
aWxpdHk/DQoNClRoYW5rcywNCkpha2UNCg==
