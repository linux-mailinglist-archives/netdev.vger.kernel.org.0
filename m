Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F92487B2A
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348497AbiAGRQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:16:37 -0500
Received: from mga06.intel.com ([134.134.136.31]:53486 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240527AbiAGRQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 12:16:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641575795; x=1673111795;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ucFWg938symMovJOFCg3N4g1O4UJ4gHJzzM0ECCSdds=;
  b=ZpyauW0MzmKmQLr6BMA3oz4TjbskdpVtnsuqZp4nu1vyurnbHc5kN1w5
   nmYTF46GX3SmdmqA+xdh3Dr+3Q98p6jBh1SAkMYEHOkJr35DCpu4Wii52
   DSe1L0rfHmDRASvDPvIsY2w9wAZQeEY4kgquqlxfrij8RF7mnKrvq8pj3
   luHWMb63JQPJ7S+WPbEj2ga5OVjBULGitVZYFwQjselEuWTNtgYo++XmY
   qZnLjS+vAE8JJU+Yrlh+GCIz2E6G4DfIfZoBg9ycA3yI5rljwa8cQDcvf
   ROhx0kmRr/MOkF2sTd8/Qwm594of8lwlhA3ERmrSB082GP9AwAg2lP6ps
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="303645511"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="303645511"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 09:16:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="668822065"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jan 2022 09:16:35 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 7 Jan 2022 09:16:34 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 7 Jan 2022 09:16:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 7 Jan 2022 09:16:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLkKDgSZmbvTiDE5+9FrbV4ZeBhtJ7wtnKSmjmyESUo+bkiPyl5GGBtLEZttHVKemKNuxnp+dqSxmTbqVzfasrs0pMrzzmavR0WS5CyAy0AAwqM8fwG+reyr7fgR5KinK4es+sGkyDw+LWOdUHjO4dLkRASWguw8YyUa4meLAqdfT959xpyuTqOfwpQLemsVsm3ewIQugF4bz7Y4rX0UWsP8JxDoUNXAPB/KpEo7yHYXQJrPtHVszMH5ri8BRNVPR2fpXdS6ZswU/kTQDvHgyBlX41U73uUzcaSbNNPMj6aDxf17PdCXHnZHgh7iLIN8E1P8YJVBKkI/e/a1xXmP+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucFWg938symMovJOFCg3N4g1O4UJ4gHJzzM0ECCSdds=;
 b=jsRZH7Y4vAwX7p10NVmyq+pVhNwpvjSgTKvm8t9PRqhacCOCGh38TTpAiQ7Ys/CBnGyKxajbdCoIkhfXVOgLgBZuT88JadkTOytfrNYmF5aOZT1Q3N3mYRRvEAJt9PUt/TWfMzDI7N8X5ipO3uZFcvKZbtcSBGq1KUfUHpR04lZMQKaVUHbaURGsaOeXAfRivxn7o/eunFGx9OBI0f3/UvyLtPeSb0z35rEuS9xNCm9XjzJqjqrAW61GS+3uPTpcK62ZAG8cPEAZCsU1KcEwS0u0SiWLgYRIJMKMtPX9N1+djqXZFGmALCVGgurC+VaLpdnPYFH7pLS+oLV4HVfQ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB5051.namprd11.prod.outlook.com (2603:10b6:806:11f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 17:16:33 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1%5]) with mapi id 15.20.4844.019; Fri, 7 Jan 2022
 17:16:33 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "Sornek, Karen" <karen.sornek@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Patynowski, PrzemyslawX" <przemyslawx.patynowski@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 2/7] i40e: Add placeholder for ndo set VLANs
Thread-Topic: [PATCH net-next 2/7] i40e: Add placeholder for ndo set VLANs
Thread-Index: AQHYA0UdzHdmDXjDKkWCU7TClhazqqxW+LwAgADVNQA=
Date:   Fri, 7 Jan 2022 17:16:33 +0000
Message-ID: <9f5f4b4521194293714afab1d69dbcea9cd07030.camel@intel.com>
References: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
         <20220106213301.11392-3-anthony.l.nguyen@intel.com>
         <20220106203254.1c6159fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220106203254.1c6159fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 238b4575-41e9-4256-bcfb-08d9d20173f1
x-ms-traffictypediagnostic: SA2PR11MB5051:EE_
x-microsoft-antispam-prvs: <SA2PR11MB5051773F5DD41EA8F7C0B475C64D9@SA2PR11MB5051.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mLZ2QA9Gv0DRtRaVbPrL/KJaUCbCplofbZoxdTDqMycZ7zgdRNQZfTPrYpi1JgJ/vc1CNXbjMo+9vEIx/fEnOa4uaUJErL1D9Xp1AK2YPtQuqxtR/cygWkRcrCwKlITzOCuP6+a6xO9UB2WM+rWhD+bqxjfVwd6vEm3DDsOlcTf2zNh7ckHbVRxurIacD5QFosAE+sHZU6VK0fgumeDzmrN+RMMWIh0ybxOrXm3gma2vxSJpxbvOYOTFx1+5Xv5TWT25gAFC5L3h++sck6m9Z1ya1y6KP7qPxnoTySDsGSqilhtDxaCKgkUV8Z5npVjBijEuDB3SprJk+LUl8YTcb0aSfi/1qU6748+RJQ7cuHRJFwoRmrWYhtzXdO6bXyoYPPPugeIma+c8Mol+kkNhv8pnmB5B/sOc2xvtWAO8aJ0dyBAh0rYQ4lenMFpn7Axe0aI3YqXQSBRVDJmSTinsQJ7c45kzeZKB/mMw4mUIsxVphsI77G+u10Q2qQGoBD/ZSfrlPNqeDITIwG/WIGBm0Ut+shoXKaZhDkAyGdUFM7eCw3esun1v383xPO/O/4n9OdVK6REq1M5GtIp+0j5Q2NACfWFIlbp3N5Mo+L+22CJ/V4482NkLusZGdZKpFsvH9zfvqFHPPM7Nt6loavVcwGV2vQL1ykld3JHQNExeFFOwCPzdYFqqlZ4BWX5YtElcKZ/DfADz3ss8hG+yNSdWRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(2906002)(38070700005)(8676002)(122000001)(82960400001)(83380400001)(38100700002)(4744005)(2616005)(6512007)(8936002)(6916009)(4326008)(107886003)(26005)(66946007)(76116006)(6506007)(86362001)(66556008)(186003)(66476007)(64756008)(66446008)(54906003)(36756003)(5660300002)(91956017)(316002)(508600001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0NpcmUxRFBNNU5Ub3BCdXc5dlBvaDlkelBwSk1EMzdFVE5mbVRsZjVrSi9K?=
 =?utf-8?B?dm9ESDFxR04zU1JwK1JQbGtzZ2JZNjRDWUlQQzFLdWRtNVplTzAvSEpvR1I4?=
 =?utf-8?B?bHdqcFRFaUNmK2ZTcnJvZnVhcC96N2NqZWQ5ZnBybFBJOXN4RFdLSElCc3NB?=
 =?utf-8?B?eStQbTNudjlBeHN6OXZ1bzFlUENubkVDTUcxQ0VyTTJrRVEyRExtckxIbG1O?=
 =?utf-8?B?T3VzTWJTWktjRnRObHBSc2Mrd3RDbHB1ZmJWZHR1aVN1bGRHc1dWd2JsYlN0?=
 =?utf-8?B?cE1rVGtwZ01ac3hKM05DM2JiK2xWbFJWc0N3bmFlSldkK2tUR3puRGZDYWRz?=
 =?utf-8?B?T0xPTlRNQzFlaVcvdElHOGpMRGhJUUQzK2lxNVVoVTFKSUd1dnFTZnpzS2x4?=
 =?utf-8?B?SzI5K0s5OGp3TFV0eENwRWgzbVFpRDdKMGMrWWo3Y2VmNzl0U3Z1TXVsMHBB?=
 =?utf-8?B?NmRLcjZOenE3MUlUb3ZIbFZxemgvQThWQ3p2SVZzampZM1YvRUw0OVQyVUR0?=
 =?utf-8?B?bG53ekllK1R1cWRwSFd2TVM4ZVJSZ2s0bjF1SllDVnNOZmowbHlLaG9iRkZK?=
 =?utf-8?B?M1lWd3pGbzh5WFZ2QUk4NE9VaHBGZEt4RVNEcC96eU9DU0VuNkMreldhNXZI?=
 =?utf-8?B?aGF5dE0zd29OVlpiNW01V3BwUUQzVHB5NGlBckhGR3RzcVhYTkxNR3hjdjly?=
 =?utf-8?B?Zk9LSkY5VjlPWkNMRHpEZTlGWjROcm9VbTJMMVF3Q25iMGNqbnpKeHpheEIr?=
 =?utf-8?B?S25TR0NSRjlDZUt0bUNmYlBvY2tLTVBhYmM3ZjZWQlVJSVo2WXo1SmxIdERy?=
 =?utf-8?B?ZURrczNWcDRYbnFKZVBTem1vN3Q1R1o3LzlmaURsS3NweWg3NjJxME9zazFX?=
 =?utf-8?B?QmVqVjdwa3N1aGdkVlZmZEg3c2xkbjJ6MlRGU3lzOW03NEhtbG10RVI3bXhl?=
 =?utf-8?B?ejNRNmZrSFRFcitvZXdJUTk3Uk5zbFNjc3dscTFjZ2ZGVVVpYXBhUFJvdmlD?=
 =?utf-8?B?YnlSbnNNbFFUTzhSRlJWU1l1d3lIU1V2amZYR1FHT1RTLzFScHVOa0NBQTl0?=
 =?utf-8?B?NzdNc09ZbVluOXJjaVlYQTlOeDV4Rkc0cGx2U284aUcwMHV4b3p4bGNsdDAw?=
 =?utf-8?B?TFJVcUY2QkRQYmt0aGcxS2hoTW56a2diQ1RBWnNaa1k3NVpGbU1zaHFBRFBF?=
 =?utf-8?B?dVBzYmpseGRDblUrcXZhUjJ3dGxyVWcxdS9LbjN2UElDd3ovbkJWa2lZSjJz?=
 =?utf-8?B?Q0R0NGJBc3gvTUZwbHFDQjRxTElOZExuRC9pdE5aZVhIVWRvc01rOUVaRlJa?=
 =?utf-8?B?aDdvQVo0ZDFwRlBjekhQRGtvakZGWE9hdlFnZ2tVVk5hcW15ejNtUmpBT2d5?=
 =?utf-8?B?VTUvOWlJQ2NMbFRxSTRWV2ZIMkFVaWZtTHQ3cjNDUW55NXRoSUYzci9KeTRx?=
 =?utf-8?B?Q3hFLzNnOFNrOTlqaEtDaDZnNU9HeUI2MnYyQ204cm10V09CdGNNRlgwQTVL?=
 =?utf-8?B?RWZtaVJmcVdsTlVkcFlmQU5iTERoZno1OHk0ZjkxUXNoMkVlTUtYU2FoYVZQ?=
 =?utf-8?B?T3lidWh4R05xb1VsZmJLV0ZWaUJkazUzYXpaOFJ0Lys0WWZ2blNlelZHRXJ5?=
 =?utf-8?B?MTd1cUwwNmQ0NlZqelQwSnREa1B1eGVINHFob1IvQWt6dmNKSXZQVjRNRDBG?=
 =?utf-8?B?WGVRZkNMczlaUEQwaTZqc1lmUDR1WDRac1p3TmtvWGV2VlJmenJuL2tESDE1?=
 =?utf-8?B?TXlZa3BrVnhNYjhsbmd0dXBvZDduSmRJQ1l5RGg1R2NhZ2QxUGtHSUkrRFFs?=
 =?utf-8?B?bk9EZFBBNjFTMUNndWtqd3VER2lIbTZOVTFWUGlnR1pYNTFoK2RkY0RGck82?=
 =?utf-8?B?MDFkTFg4V3VwaVo1UnRRMUNnNktLYkFWREg2M1AwTWpoM2FyMDladFp1SEZK?=
 =?utf-8?B?SUdLWWd3V3cyNXAvUGo0N0lBeHIyQ3g4bjVUOEJnTXA1d0tQeU5wODhtemMy?=
 =?utf-8?B?VExKTThJT3V1dGM2bEhyV1FjZUxxL2Y3cnpVZ1hoNU8rVXJYZnZXYmZTdmty?=
 =?utf-8?B?NFNqZUIxWkw2U1J6TWRQOTRaVGhZcEVyTDEvcTU3M0VndTE2Qy9mbENwMU9N?=
 =?utf-8?B?b2FwN1dsd0ZETlJuZUxCMWhhVkFaRDdxRDhpeHlPUUl0cmtSRTd2ekhEaGo5?=
 =?utf-8?B?YUp1bDVhTDVhTTJvSGxyeUpiWDZqU0daVXVRc0ppQmk3OC9nYjYwUGQveVZQ?=
 =?utf-8?Q?SZFyrvYmBge38V6cRiYUQNTOc6I8npcVtRi1wzRFEg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3264862C0A92334C8E9938F79AFF32FF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238b4575-41e9-4256-bcfb-08d9d20173f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 17:16:33.0877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EKLl45oS0UryOkPCWOfhTxaGOrTT1uoHnIgI+cCNqRRtRzGYdZIyHbVjusn4V+m4U0S8KNXD/YqbXQk8fwBZ/ee1kCIBi2GSJ9wcp7Dki+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5051
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAxLTA2IGF0IDIwOjMyIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LMKgIDYgSmFuIDIwMjIgMTM6MzI6NTYgLTA4MDAgVG9ueSBOZ3V5ZW4gd3JvdGU6
DQo+ID4gRnJvbTogS2FyZW4gU29ybmVrIDxrYXJlbi5zb3JuZWtAaW50ZWwuY29tPg0KPiA+IA0K
PiA+IFZMQU5zIHNldCBieSBuZG8sIHdlcmUgbm90IGFjY291bnRlZC4NCj4gPiBJbXBsZW1lbnQg
cGxhY2Vob2xkZXIsIGJ5IHdoaWNoIGRyaXZlciBjYW4gYWNjb3VudCBWTEFOcyBzZXQgYnkNCj4g
PiBuZG8uIEVuc3VyZSB0aGF0IG9uY2UgUEYgY2hhbmdlcyB0cnVuaywgZXZlcnkgZ3Vlc3QgZmls
dGVyDQo+ID4gaXMgcmVtb3ZlZCBmcm9tIHRoZSBsaXN0ICd2bV92bGFuX2xpc3QnLg0KPiA+IElt
cGxlbWVudCBsb2dpYyBmb3IgZGVsZXRpb24vYWRkaXRpb24gb2YgZ3Vlc3QoZnJvbSBWTSkgZmls
dGVycy4NCj4gDQo+IEkgY291bGQgbm90IHVuZGVyc3RhbmQgd2hhdCB0aGlzIGNoYW5nZSBpcyBh
Y2hpZXZpbmcgZnJvbSByZWFkaW5nDQo+IHRoaXMuDQo+IA0KDQpIaSBKYWt1YiwNCg0KVGhlIGF1
dGhvciBpcyBjdXJyZW50bHkgb3V0IG9uIGhvbGlkYXkuIEknbSBnb2luZyB0byBkcm9wIHRoaXMg
ZnJvbSB0aGUNCnNlcmllcyBzbyB0aGUgb3RoZXIgcGF0Y2hlcyBjYW4gbWFrZSBpdCBiZWZvcmUg
bmV0LW5leHQgY2xvc2VzLiBTaGUnbGwNCnJlc3BvbmQgYW5kL29yIG1ha2UgY2hhbmdlcyB3aGVu
IHNoZSByZXR1cm5zLg0KDQpUaGFua3MsDQpUb255DQoNCg0K
