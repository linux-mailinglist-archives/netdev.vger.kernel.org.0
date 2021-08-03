Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1471E3DF875
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhHCXZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:25:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:62553 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhHCXZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:25:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="235756588"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="235756588"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 16:25:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="511539947"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Aug 2021 16:25:45 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 3 Aug 2021 16:25:44 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 3 Aug 2021 16:25:44 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 3 Aug 2021 16:25:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 3 Aug 2021 16:25:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCBckqfbDIx42SZ4UbCQM8Xh2J9I3qqJmO5LU3RPZeaC/SAG79ZBxqw7+3nGRDDMnWqqHMhftU2vQQ6S9Uhnna1JpZprI6mxH63ISxEOkcMHubJezXBSSvtzj4OD/ghGcga9/DmC0sX6kAUJcJeQUW7SJFsZZSQCOG/wcxtEUIhQj49/df0PQylqhfnFXE0DPsT3x52OfHZD0/ztFYKVwFG7HbcSqJr4QWvCtwH6OehJFOSdtJuXVMeeJlp7my7KNua0OPgaW8k7W4zBfcDxgx9bT5s2+2ETZFpvuA89ibXEMD9ueJX7UPOsjSiRFTThuiqhLp4cJtoCA63i+nXpgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/N4WGp0EenZtIATxPsX9WF5Yi5r7YWRej09zR3AXF+s=;
 b=T+sP3MXrcn+YqZQy3sTfCycK+PsNvUTI4D6lORSrCu5l3S5L4r1vEPHQKf6Vf9tETSR6pUM49uSE5NYbz0mglrBUR+ElPSS784oyp8XtIFU3IYQPEEbQYgY5+G47rCFhQI1tuXX8a5vqco5nAWdSee1OgNi8c/V15RdVnm8hLSGEO44SDia2kVCpGQgQ1ii5y8IRmeG5bSzBc79uvhwRdgtvnRU52lLhq3ab9VQzQgi+cVKkrhmypd9ddksKroYeqlJJsImHaE79iUu++T0sbswfQzLBO0Y784l51ZUJsu0kDsNYPV48L7KFAauJ+/jw+NIjVk3UvXFOMZRiKsgiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/N4WGp0EenZtIATxPsX9WF5Yi5r7YWRej09zR3AXF+s=;
 b=fpEgA4ibBWRM+hsqNs7X5VGhaB2QriGEv2JeE9Ohq+YJo5WtIrPW69o++QHTlr0ox8CZNcX67CjczGpKHCi0G/S+U4R9FYQeG+ov6PmfrE34pLLPkDcujqBy3S/VkcZMT+K7P3WEaIIzS23P8mJ43CEDjbh/yLyNyFKJyl0ygbw=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 23:25:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 23:25:43 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
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
Thread-Index: AQHXh68Y1owt0G/CUEakzTAdq+RvtqtgbT+AgAAzuICAADaFgIAAgzoAgACWAgCAAAU1AIAADOyAgAAEIGCAABQFAIAAUvdg
Date:   Tue, 3 Aug 2021 23:25:42 +0000
Message-ID: <CO1PR11MB5089B32E93853E4723B02819D6F09@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <20210802230921.GA13623@hoboy.vegasvil.org>
 <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
 <20210803155556.GD32663@hoboy.vegasvil.org>
 <20210803161434.GE32663@hoboy.vegasvil.org>
 <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com>
 <CO1PR11MB50892EAF3C871F6934B85852D6F09@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAK8P3a06enZOf=XyZ+zcAwBczv41UuCTz+=0FMf2gBz1_cOnZQ@mail.gmail.com>
In-Reply-To: <CAK8P3a06enZOf=XyZ+zcAwBczv41UuCTz+=0FMf2gBz1_cOnZQ@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: df7c117f-50bf-4991-ed47-08d956d60374
x-ms-traffictypediagnostic: MWHPR11MB1886:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB18866077A9DEB5CE00244E9ED6F09@MWHPR11MB1886.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mlEJROriHuNekVnPNOAEr6APpoG48UB3PtqlxbtCHU5P55d0jm9/jkm15hNlq12L1xKaAIFtyLir9kvNppTP+N0IO5M8oxbZuCJ5krBHjRF5bVPfzeVH02xNdIWYPHX8nlQK+m0o8tcKvoshXOj0J+tCgaW5kTaQ77LX4+YA+vYUilkznqTsl9uAkR34xya2K+2/jb9TIe3s9BHySQjSPVorQJqpRhsTh641UYSHlDvtcHWlUqal3Fuc3aiGla4zq+/K9yMbTx0GRqjzpPJTHGDTw7TIQQcU7EjPF7Sfsj/WKp+MqCKmv8ZLW+SqWnagGRjSJrNqJxxhTwgYKe27qwvMmnD9TXbNOpiU/6fa9PnjTVAl8BHFOG0e+obkBUQ0zBG1ye7g/AakN1dcYXiyWksM9uFQwmhHl7tVOTcrll80gLeXVvM+fXJoWI/oy9Q+yQDS7Tn4bgwNHR7OPehiVIympYguhxwy8y3BCWSiREUh6Sg7x8gaAyBIHjFdWaYl2XXOVYSZY4eDlSAE8BUYi2SY1JTGqXPBvf3g5ryGcJFx/o4CnBMpls5iMSMLT2urdMf1zQHGKgC/+fHx8pO5Z3xJtunW9zZiDzCnl7x6eRvW0cz4nHoLb9GYxhsbqCCgOURDhJ/0WExYAiga9zDCT/Gz1TCXe4RHfMGXSENcsa2LtCZoLOv52O4bulWOBdA2VKRLnCEnEPgqelGLkyOlKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(2906002)(66476007)(76116006)(66556008)(33656002)(478600001)(66446008)(66946007)(64756008)(5660300002)(71200400001)(6916009)(52536014)(8676002)(7696005)(54906003)(8936002)(9686003)(7416002)(83380400001)(86362001)(55016002)(26005)(122000001)(186003)(53546011)(316002)(4326008)(6506007)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzF2ak1TZXM1eHBTQTRiQWNrYXVqaGZpUC9CQ1Jsb3gyTDc3SEpFSVNlbCtk?=
 =?utf-8?B?bHoyUkZ3NVhSVm9NeloxZTVCQlRiV2VySENhaDhzdDllTVl4UVdNSDNIbDBS?=
 =?utf-8?B?WFRxU2VScFpoWFVjcU5WNEpua3BQL01tUVpYUWtQRjZENGc0SitrbVBBOFpw?=
 =?utf-8?B?U2N0c0U5OFNsWHRFR1RHaVR3YW5iLytmV21QQmt2dW14RjNtcXVaYm5kME9x?=
 =?utf-8?B?cnhzZUN1eHczTVlob1R1R2ZWc2NMMTdFQm9HUEhJVEZ5aGVLajNmZXBoZm15?=
 =?utf-8?B?M1hDUTFqaHNYUnhPeHM0Z3pSSVd0dkcrR1ZWMnl3aWJwYi9BM0F1bXdhTnZy?=
 =?utf-8?B?a2J0N0lGWDU0RWpWUUUxS3B5YmI4TElNUnhxTFpvelhOcXhMdTRaY2g2dVhU?=
 =?utf-8?B?VEdGTkpsWnlRTkxLcW5LRFRQa0NBNmVWb28wY0pWTm94NFNvSit1dWxaaGh4?=
 =?utf-8?B?RGNtVjUyWGw5dGQ5SUtRTW5BMWs4YTRBYnhveWZqTTZ3Z1NDUk9MckFoeU1v?=
 =?utf-8?B?ZzhnTksxK1BSS3A1Kzk2dXQ0UE0xWnUyWlk1UC9Kak5Gdk9ydUkreFhVbk5H?=
 =?utf-8?B?U1ovbWE1dEFxYnlzRndjQXNoMHJtcFNCU0F0eFB6cHd5NjlLMGMvTHgrUENj?=
 =?utf-8?B?VWxmajhaZWtVSmdUaW1Hb2RLaDA0OWZobC9Hbnk2Z09nMUo5dDdKNDBTQ3VY?=
 =?utf-8?B?UVVzWFpkVWhrb3FSZkZEUlRhS2lyRmpaNmVibFRTa2ZxREQ2OGpBeFZmLytQ?=
 =?utf-8?B?ejdkb2VpNHN2VWYrOFFPVERvbVNDbDJ2OHpDQk5sa0Q0Z0RVVlFyVWt6K2Fp?=
 =?utf-8?B?WHpBNGVXbk1ZSVFDTk5xU3BmTkx5UkVySFJnNWUxajFBKzdkaElibFZjTDNx?=
 =?utf-8?B?bEFhckEwVVdQcXRrV2ZwUXFRUU9HMEtEODF0MDhEQm9mOGNBWW5NRVVacDZj?=
 =?utf-8?B?eUdjYnNBV1BKRUJhKzIrZnJLVDVCbWZCMkozZ2w1dnVSa0xLR3Z2Qk1JVUZh?=
 =?utf-8?B?TE5TSE5xN21ZdDZ1TFRkMGNHN3l6Z2ZDa0dXREMyZGc4Z0FVdkhLekRrZy80?=
 =?utf-8?B?U0NuNmp4MVJXcWVTUm1qbW9UQURKUm45WE40TjdFUTVwck9sUWJQK3RQUWRa?=
 =?utf-8?B?c05LajlVTDFxTnhFdWhLYkhkN1lBV3lVTEVBcGwvbWVBQXJveFExRUtrL25E?=
 =?utf-8?B?bkJxQnZJTTJPVUJON1dHdHB6SzRzQ3luWnFOU2ttOStvck5GUWx2UktHNkNS?=
 =?utf-8?B?Y3JFWW11bTBaSi9rdnlWeWIvU2ZRUXFSUVBuSWI4UWpvT2FVS1Q1RS9mNnh3?=
 =?utf-8?B?dW5uLzluTVkyRXE3eDFmazd1UDMweUdqTnBsMkwyUU9FNU82NHN0S043Q0M2?=
 =?utf-8?B?blY5RWdUY04rejJudDZyWEpjN0xCcXB1V0IrdjlTaXhwRU1jTXVad0lMQUpN?=
 =?utf-8?B?dnRnRVdkSVRrVlMrS2hRWlVydHVTVUsvVC95dkZka1F6eTNoZkZuWWZhK2Q5?=
 =?utf-8?B?SmsrckxlMWRZSVRWT1FDSjhGN2FybG5FUW1tbDBTdUE4SW1ST2tvR1poQ0pr?=
 =?utf-8?B?eHBCRE5kZSt2NVR0a1RXRmxqU0tDbjJJa0xJdDU3bTdTTGZZY1h6UWx3NlZB?=
 =?utf-8?B?SCtoUDNmOTBNN3ByUUV4YWxpL1UzM1dEaEhBSStiSWZBaktHRkxDdGpKNlNo?=
 =?utf-8?B?Z0s4bFhBdlhVQTBPVCtuU25TTTJ4a2MxOHEzV1RtRlQvaFp6Y3BOY3pqQm9P?=
 =?utf-8?Q?52A9GMf7PxTBGsB09M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df7c117f-50bf-4991-ed47-08d956d60374
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 23:25:42.9943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jyu8g9mM3qkFv3iuwgiuojkmnQYsBonUYwNcDJNYhAHOJmCE1S/iO+QS9vLKejvbTLevBnM+LOiY/sOw7M4ZZ8rTXTERItmphteOjRREN8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1886
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJuZCBCZXJnbWFubiA8
YXJuZEBrZXJuZWwub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBBdWd1c3QgMDMsIDIwMjEgMTE6Mjcg
QU0NCj4gVG86IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiBD
YzogUmljaGFyZCBDb2NocmFuIDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+OyBOaWNvbGFzIFBp
dHJlDQo+IDxuaWNvQGZsdXhuaWMubmV0PjsgQnJhbmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5k
ZWJ1cmdAaW50ZWwuY29tPjsgTmd1eWVuLA0KPiBBbnRob255IEwgPGFudGhvbnkubC5uZ3V5ZW5A
aW50ZWwuY29tPjsgRGF2aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFr
dWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEFybmQgQmVyZ21hbm4NCj4gPGFybmRAYXJu
ZGIuZGU+OyBLdXJ0IEthbnplbmJhY2ggPGt1cnRAbGludXRyb25peC5kZT47IFNhbGVlbSwgU2hp
cmF6DQo+IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47IEVydG1hbiwgRGF2aWQgTSA8ZGF2aWQu
bS5lcnRtYW5AaW50ZWwuY29tPjsNCj4gaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjJdIGV0aGVybmV0L2ludGVsOiBmaXgg
UFRQXzE1ODhfQ0xPQ0sNCj4gZGVwZW5kZW5jaWVzDQo+IA0KPiBPbiBUdWUsIEF1ZyAzLCAyMDIx
IGF0IDc6MTkgUE0gS2VsbGVyLCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+IHdy
b3RlOg0KPiA+ID4gT24gVHVlLCBBdWcgMywgMjAyMSBhdCA2OjE0IFBNIFJpY2hhcmQgQ29jaHJh
bg0KPiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPiB3cm90ZToNCj4gDQo+ID4gVGhlcmUgaXMg
YW4gYWx0ZXJuYXRpdmUgc29sdXRpb24gdG8gZml4aW5nIHRoZSBpbXBseSBrZXl3b3JkOg0KPiA+
DQo+ID4gTWFrZSB0aGUgZHJpdmVycyB1c2UgaXQgcHJvcGVybHkgYnkgKmFjdHVhbGx5KiBjb25k
aXRpb25hbGx5IGVuYWJsaW5nIHRoZSBmZWF0dXJlDQo+IG9ubHkgd2hlbiBJU19SRUFDSEFCTEUs
IGkuZS4gZml4IGljZSBzbyB0aGF0IGl0IHVzZXMgSVNfUkVBQ0hBQkxFIGluc3RlYWQgb2YNCj4g
SVNfRU5BQkxFRCwgYW5kIHNvIHRoYXQgaXRzIHN0dWIgaW1wbGVtZW50YXRpb24gaW4gaWNlX3B0
cC5oIGFjdHVhbGx5IGp1c3Qgc2lsZW50bHkNCj4gZG9lcyBub3RoaW5nIGJ1dCByZXR1cm5zIDAg
dG8gdGVsbCB0aGUgcmVzdCBvZiB0aGUgZHJpdmVyIHRoaW5ncyBhcmUgZmluZS4NCj4gDQo+IEkg
d291bGQgY29uc2lkZXIgSVNfUkVBQ0hBQkxFKCkgcGFydCBvZiB0aGUgcHJvYmxlbSwgbm90IHRo
ZSBzb2x1dGlvbiwgaXQgbWFrZXMNCj4gdGhpbmdzIG1hZ2ljYWxseSBidWlsZCwgYnV0IHRoZW4g
c3VycHJpc2VzIHVzZXJzIGF0IHJ1bnRpbWUgd2hlbiB0aGV5IGRvIG5vdCBnZXQNCj4gdGhlIGlu
dGVuZGVkIGJlaGF2aW9yLg0KPiANCj4gICAgICAgQXJuZA0KDQpGYWlyIGVub3VnaC4gSSBhbSBh
bHNvIGZpbmUgd2l0aCBqdXN0ICJkZXBlbmRzIi4gV2UgY2FuIG1ha2UgbW9zdCBvZiB0aGUgZHJp
dmVycyBzaW1wbHkgYWx3YXlzIGVuYWJsZSBpdCwgYW5kIGlmIGEgc3BlY2lmaWMgZHJpdmVyIGlz
IHVzZWQgaW4gc29tZSBlbWJlZGRlZCBzZXR1cCB0aGF0IGhhcyByZXF1aXJlbWVudHMgb24gbWlu
aW1pemluZyB0aGluZ3MgdGhhdCBkcml2ZXIgY2FuIGJlIHNldHVwIHRvIHVzZSBhIDJuZCBjb25m
aWcgc3ltYm9sLCBhbmQgYWxsIG9mIHRoZSBvdGhlciBkcml2ZXJzIHRoYXQgYXJlbid0IHVzZWQg
Y2FuIGJlIGRpc2FibGVkIChhcyB0aGF0IG1pbmltaXplciBpcyBwcm9iYWJseSBhbHJlYWR5IGRv
aW5nISkNCg0KSSB0aGluayB3ZSd2ZSBmb3VuZCB0aGUgYmVzdCByb3V0ZSB0byBnbyB0aGVuIQ0K
DQpUaGFua3MsDQpKYWtlDQo=
