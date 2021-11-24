Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E625445B65D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240675AbhKXITM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:19:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:30490 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229733AbhKXITK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 03:19:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235176380"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="235176380"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 00:16:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="674782574"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2021 00:15:59 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 24 Nov 2021 00:15:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 24 Nov 2021 00:15:59 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 24 Nov 2021 00:15:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBUlW4tAaWOCixpreHAO/zyqlHHJ6cF+HmY//uZOgUCo9zqC4FtP168r5BqP+mtHOO4tezeOHrOihygzSiwyKJ3RV1sho/IkpJvd8TyzgWYsx4GzrkRsdDg5ybj6r8Pic/AOlR+N23iji1G64nkdBqp7uXqbYUxWpHL4g/ai+w8CPbXmKJNjVm3/N+8xjjQcLvTVe0dyo7IzMV8kWn6NLtKSqNQdzqZ38iVsZt8UBpx3zWqmZQ64uOu7TnRILButD8UkaUnjud9TiYFO08L62Md1lPt4FDkM2/rK8LauhG/XZZmgIO7GAEab+Wzoa7T7p7NI5xq6v1hQw2NKBswt6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8fDf5cSoxxh0bdUQRULzJ7ojspNZvylS8MSVsh0zKk=;
 b=WrcJFEsWoXfruiaXcdh1588F3jzxvXsLp5CmDt6UbXdCIEZqCmnIIJOaq3DirfBYTMdIORP1+DmGNarzOIEnvA9/bsmXKgWCtqn9mvfq4zl7+0ynYbYL3t00lHmBj3Mu2bzRhZeDzKijQujZvCqtPNTfRozmS3Y1yOzQ4WPDomk2pho1wI2Zd4LbjV32xeqFWVXcuxk+8VBTKerI/UPosJvA+XarmecrXJYOAjHbidRj3dCy10ZUMY6hOnmidgmVvHPV5mq0hr+TCiNCAQIdTbpsy/YNfMejnzekMvhILFw7zBTp/+u3tJhMtKbGSLv/jIrLhQN3pJt0Tcef4wxatg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8fDf5cSoxxh0bdUQRULzJ7ojspNZvylS8MSVsh0zKk=;
 b=PJoIOKUYIGTJKdnDOOQxMHVlcuG0eMNIMlZUyLO35+Hs2J761WUxzFUgFt53TD0sSwDbml82aVOMs44bA99ab8vTMzIQZmFOXUQI/MFae6J+Tk6WHC8hw5IWfjZSnGpIyT+QM3AWaLfvZlemoRw7r2qFJcYRnDt/FbdxLAVy8mQ=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2871.namprd11.prod.outlook.com (2603:10b6:a02:c5::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 08:15:58 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae%6]) with mapi id 15.20.4690.029; Wed, 24 Nov 2021
 08:15:58 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "jikos@kernel.org" <jikos@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: mvm: protect regulatory_set_wiphy_regd_sync()
 with wiphy lock
Thread-Topic: [PATCH] iwlwifi: mvm: protect regulatory_set_wiphy_regd_sync()
 with wiphy lock
Thread-Index: AQHX4K387olC32REA0aEpjzQqwFaXKwSVDV4gAABcQA=
Date:   Wed, 24 Nov 2021 08:15:58 +0000
Message-ID: <74c53e65a8f3db89d60718dc1dfb807cd80857ca.camel@intel.com>
References: <nycvar.YFH.7.76.2111232204150.16505@cbobk.fhfr.pm>
         <871r366kjy.fsf@codeaurora.org>
In-Reply-To: <871r366kjy.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ec3a879-4935-49d1-bf9b-08d9af22a50e
x-ms-traffictypediagnostic: BYAPR11MB2871:
x-microsoft-antispam-prvs: <BYAPR11MB28710DC76572A21E2463CAFC90619@BYAPR11MB2871.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uyOg/8Muhkp+2yjdmg7TAC1MWxFu9ygTFCekMLETVkYgYSE5M3LqHi27tfxwdTNB0uGwylSCyJP3eMri/bHs0FwxGHVICwrvkVyzxnZcuI3wtFIH/oS5RzhZOLmgRYaDT4aeRYSETgd+y0QdiIWliNpSYHJQMStPDHfKoUOYgyddG/Gdu3N3q5cg6OMgVSSwib6shYN+hIAUbC8toGYvemOzqpT2ISuD0g+h7nu7X+ug/OZY6owrZIA2IIZlrQ5pnFwPO5qD9oTOLjZrKEDz4aeYxPiPYwKK/BFy6nKZsYL8aUEA9STo1KOvNw8IaMKbpxe17GRlBQ0QHQGz9i4jEpnLgJ2+eduZFbo4zm3E97A1y2IYeAqEM10B7JcdrrsCuwSo2rp5sBUM0ScsKEJ1bxBEGeLZPWJxWXsYRte2VuPSweR6ITVWIVO+ZlkaylirEs0oKQsFqWzBSfjAxmavXH8nmhDLXa04S4J7VTNF8WlAuTO1+gIMsoGudwR+gyDpM3gdsTf6vaVVkdx6ht/q2D5s7kavO1KsHfck2rbJgj/frhvIiCWcmBKfvGOjZCERhfT56lTFqEiQ2EJXcqfrs/tuVcQ8GTewqeUVcucaxTqgsx3kEq9mq0tzhEqkf0tEK4cHMjgUR4CnSAIblvb46CSkJTo2g++21XZ9ObcXIvgNsnu9BW/kD4HV1dsVbqTkpAFCVan7dgRiulGfaX9E4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(64756008)(66446008)(316002)(54906003)(6512007)(91956017)(76116006)(66946007)(5660300002)(71200400001)(45080400002)(86362001)(508600001)(4001150100001)(8676002)(82960400001)(122000001)(83380400001)(2616005)(8936002)(110136005)(15650500001)(38100700002)(38070700005)(26005)(6506007)(4326008)(6486002)(186003)(36756003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3dNa2pHNS9QUFlDV2plZllJWTQweUZYTUNVRWdMeHA2d1NIWkx6cUdaVnFL?=
 =?utf-8?B?ZjlGL1A0L2hMUVh6NGZwT1lVMlVkemFlbTJSWGN4Y3U5VlhwNldCTC9jWXk3?=
 =?utf-8?B?bHQ4M2RaVWRld2Z5NzYwbjExc2FVbWc5SWxrUVJzeU9VNkEzdTdIWWRWd2I2?=
 =?utf-8?B?K2ozbnlWc3lxeStiN0FNYXdObjdTNzNqNU9qYVVjYlRXVDY1ZDYvN2RaVXZS?=
 =?utf-8?B?Y0tLK3FJaHV2MmJUd1dEcUwrcTBSZ3Mvbk5kbWh2ODdPL1dBOFhJRSt0Z0hs?=
 =?utf-8?B?dWhDaCtuZ25aS3prcGVEdmxHdDhoa0FyQm0vc1lOZVRCTEZJSUlPMFE0bDRN?=
 =?utf-8?B?Rml4V3JkZ1pxZmhvVnU0S0MvVWhpdkg3UWhFZFRDeUhTL0NmMGsyMlpkN3E5?=
 =?utf-8?B?RVIveFNMU0paMWUzL0paaWRDUkFYUG12dGdFdlZhZ3F1Y2UrV2JEcTZRVjR5?=
 =?utf-8?B?RG5NM2dGbGVvc1g5WU0zSzQvTzdFeW04SXFDN0lXN2l1d1FZS083K3A3RFd3?=
 =?utf-8?B?OEpNWjJaRE1yM1RlcTRnUEE3N2RQSzQwR3huZlRsSU11VkZ3eVpxTmlNTWcr?=
 =?utf-8?B?TnlYTmtOV1ZCZUowYU50YkIzckduQ0NRd1hnck81R1pDV3F1MFI5ZXNURmw0?=
 =?utf-8?B?bUN0c2duRlJtWjFoM3hDb3ZtSHRUcDFWVGxyNzFLeTZidFlkKzRKRUhqdXcw?=
 =?utf-8?B?dHpCbGhNVUtrYzBOUjVMbjQzdHZic0h5T0k1ZEVtdU9LYm5TY08xUyt5em0r?=
 =?utf-8?B?QWxwbFpyQUNONFE5RTNFNUM3SEFOaTJ0cGI2Qk5sR0RvRFZWVUl3cTVoREFk?=
 =?utf-8?B?U2VTVTFSWUh4MWFUeUhKNHhqcHh1RXJIYVd5cVh3U1lRb0FFd3hlaUZaenhD?=
 =?utf-8?B?UUE0OTFJa1lsaXErQWcveFllY2lGZzlNWVgzUHlZc29FWmtHbE91aHJuRzVB?=
 =?utf-8?B?TkRTYUttTTkxN2tzWk8rMzkzeERSdm10Z1hvVXpyOW5YL0llbzhValZUSnZv?=
 =?utf-8?B?WmN0VVlpSEZIK3JPaHg5QWlEN1M3bDd6bG90OThXREVQWmxVbE9XOU1jWUlZ?=
 =?utf-8?B?ZEFMUjVNekFuWnJSam9MUFpnbWR6VzRBZ2tvQVJpMTArcVdLSG1rSU5HZU5S?=
 =?utf-8?B?cmRac2dQSFdzZzNoYUVkZU9SYTVnWmNFWElhbzNUNTVLdzBHakxXcEx2NEFu?=
 =?utf-8?B?MjdURk5nYlpzZzdYNm1hYTZPU1JpKzBlWTFRenpscHJTZjVwWkNBK0VyYUlo?=
 =?utf-8?B?ZktqdEc3VVFlTHNaa2haWU9DeE5GVkIzZEdyY2htempGRVUrU0dvUm85WlBS?=
 =?utf-8?B?OGRLbUg3ZXlZQjNIZnFtaStTOUc2Si9Yd0kxOWw3MmJ2L0ozdzFtZEZ1RXlp?=
 =?utf-8?B?cVRMSjVrditYS3IxRGV0QnA1c2JCMUVrVUF2QUhoeTBvSjh1a0I3M3FwTnd3?=
 =?utf-8?B?SkNtWWk1disrVEE1VUpvbmZpd1RORUtNWk1KWFdQdGw1YkRiNnJocks1S1By?=
 =?utf-8?B?NFYzSjRkejVzZlBkRDR3ZmtWT2JvRng1TzNPRVF3M1J1K05jYk9heXBpUnBa?=
 =?utf-8?B?MEFZZkFFSDAwa3JNTnJ2dzZ4Y3ZWRlFmQ05meDRwNjhCaFNPdXpyMjlPWFVy?=
 =?utf-8?B?Z05RUklSclJrcXVaMzVESWVZOGlMRldkTGpUdkd1ZkV5L1FkcTVHNFlBVXVl?=
 =?utf-8?B?bDhvNm5WdmRsNHRKNlpzanA5djM1c1QvdXF0L1lYWmh6QnJiRFZKNWoweGU4?=
 =?utf-8?B?Ynhoc0pDUkZBZ1RCTWI1LzZyQzJ2RlBiSDlFRmtKdEdZQnBEM1E2anFHRm9y?=
 =?utf-8?B?bWxFRDdmY0hGTkFkTmNad21MNWJqSlFCaWZxTUlrVW9BOUpWL2RaMm93R2lU?=
 =?utf-8?B?dWppdVIzay9CcjVRUjlySUlqZE05L0RHSm1XcTkzODF4RDdtZFhJUndnOWRD?=
 =?utf-8?B?aXU1cDdYYUFPQTNNQ3JwanJTbHBGeVRHQWwxcThuQnFQR1RBbS8ydHJDS0Fi?=
 =?utf-8?B?dFl1bGtPSzF2dXhUSXFHbVp0cXdLdlM0Tm91Qm9GWXRVcDFPMk02U3E4NytO?=
 =?utf-8?B?ZGZyd3cxYVJyeHBJSmxvQW5uYkg1NzZUMnZqeW5XdlU2aUxxS256THArRk5D?=
 =?utf-8?B?ZDhQUTE0bkJjUWFCOEtKazBDUCtIcXE5TzJ6dllKZUw2WHU3OEZtVmpXeEdm?=
 =?utf-8?B?djE3MlcwL0ZieVhBZFY3bUE1MU1XUVIzSnU5WnZUM05XTXVXVFhLaTE2VmNk?=
 =?utf-8?Q?s9nE8zsK4c9yBc1wmTSMaZEGRvAQNJ7zHFODjmoLlw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5175460557702F46BE646299EBE0E373@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec3a879-4935-49d1-bf9b-08d9af22a50e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 08:15:58.1832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FxCned5lV6AJloXnfEVrmnAoNV6V81IXYu/cNW+T8ZpOTXI5uPS0Lpk/jrXUO0fkw0IA8gNClARhg53k2CHdgUMuYCJn0T8psPXpPv7KtfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2871
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTExLTI0IGF0IDEwOjEwICswMjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBK
aXJpIEtvc2luYSA8amlrb3NAa2VybmVsLm9yZz4gd3JpdGVzOg0KPiANCj4gPiBGcm9tOiBKaXJp
IEtvc2luYSA8amtvc2luYUBzdXNlLmN6Pg0KPiA+IA0KPiA+IFNpbmNlIHRoZSBzd2l0Y2ggYXdh
eSBmcm9tIHJ0bmwgdG8gd2lwaHkgbG9jaywgDQo+ID4gcmVndWxhdG9yeV9zZXRfd2lwaHlfcmVn
ZF9zeW5jKCkgaGFzIHRvIGJlIGNhbGxlZCB3aXRoIHdpcGh5IGxvY2sgaGVsZDsgDQo+ID4gdGhp
cyBpcyBjdXJyZW50bHkgbm90IHRoZSBjYXNlIG9uIHRoZSBtb2R1bGUgbG9hZCBjb2RlcGF0aC4N
Cj4gPiANCj4gPiBGaXggdGhhdCBieSBwcm9wZXJseSBhY3F1aXJpbmcgaXQgaW4gaXdsX212bV9z
dGFydF9nZXRfbnZtKCkgdG8gbWFpbnRhaW4gDQo+ID4gYWxzbyBsb2NrIG9yZGVyaW5nIGFnYWlu
c3QgbXZtLT5tdXRleCBhbmQgUlROTC4NCj4gPiANCj4gPiBUaGlzIGZpeGVzIHRoZSBzcGxhdCBi
ZWxvdy4NCj4gPiANCj4gPiAgPT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPiAgV0FS
TklORzogc3VzcGljaW91cyBSQ1UgdXNhZ2UNCj4gPiAgNS4xNi4wLXJjMiAjMSBOb3QgdGFpbnRl
ZA0KPiA+ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICBkcml2ZXJzL25ldC93
aXJlbGVzcy9pbnRlbC9pd2x3aWZpL212bS9tYWM4MDIxMS5jOjI2NCBzdXNwaWNpb3VzIHJjdV9k
ZXJlZmVyZW5jZV9wcm90ZWN0ZWQoKSB1c2FnZSENCj4gPiANCj4gPiAgb3RoZXIgaW5mbyB0aGF0
IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoNCj4gPiANCj4gPiAgcmN1X3NjaGVkdWxlcl9hY3Rp
dmUgPSAyLCBkZWJ1Z19sb2NrcyA9IDENCj4gPiAgMyBsb2NrcyBoZWxkIGJ5IG1vZHByb2JlLzU3
ODoNCj4gPiAgICMwOiBmZmZmZmZmZmMwYjZmMGU4IChpd2x3aWZpX29wbW9kZV90YWJsZV9tdHgp
eysuKy59LXszOjN9LCBhdDogaXdsX29wbW9kZV9yZWdpc3RlcisweDJlLzB4ZTAgW2l3bHdpZmld
DQo+ID4gICAjMTogZmZmZmZmZmY5YTg1NmIwOCAocnRubF9tdXRleCl7Ky4rLn0tezM6M30sIGF0
OiBpd2xfb3BfbW9kZV9tdm1fc3RhcnQrMHhhMGIvMHhjYjAgW2l3bG12bV0NCj4gPiAgICMyOiBm
ZmZmOGU1MjQyZjUzMzgwICgmbXZtLT5tdXRleCl7Ky4rLn0tezM6M30sIGF0OiBpd2xfb3BfbW9k
ZV9tdm1fc3RhcnQrMHhhMTYvMHhjYjAgW2l3bG12bV0NCj4gPiANCj4gPiAgc3RhY2sgYmFja3Ry
YWNlOg0KPiA+ICBDUFU6IDEgUElEOiA1NzggQ29tbTogbW9kcHJvYmUgTm90IHRhaW50ZWQgNS4x
Ni4wLXJjMiAjMQ0KPiA+ICBIYXJkd2FyZSBuYW1lOiBMRU5PVk8gMjBLNVMyMlIwMC8yMEs1UzIy
UjAwLCBCSU9TIFIwSUVUMzhXICgxLjE2ICkgMDUvMzEvMjAxNw0KPiA+ICBDYWxsIFRyYWNlOg0K
PiA+ICAgPFRBU0s+DQo+ID4gICBkdW1wX3N0YWNrX2x2bCsweDU4LzB4NzENCj4gPiAgIGl3bF9t
dm1faW5pdF9md19yZWdkKzB4MTNkLzB4MTgwIFtpd2xtdm1dDQo+ID4gICBpd2xfbXZtX2luaXRf
bWNjKzB4NjYvMHgxZDAgW2l3bG12bV0NCj4gPiAgIGl3bF9vcF9tb2RlX212bV9zdGFydCsweGM2
ZC8weGNiMCBbaXdsbXZtXQ0KPiA+ICAgX2l3bF9vcF9tb2RlX3N0YXJ0LmlzcmEuNCsweDQyLzB4
ODAgW2l3bHdpZmldDQo+ID4gICBpd2xfb3Btb2RlX3JlZ2lzdGVyKzB4NzEvMHhlMCBbaXdsd2lm
aV0NCj4gPiAgID8gMHhmZmZmZmZmZmMxMDYyMDAwDQo+ID4gICBpd2xfbXZtX2luaXQrMHgzNC8w
eDEwMDAgW2l3bG12bV0NCj4gPiAgIGRvX29uZV9pbml0Y2FsbCsweDViLzB4MzAwDQo+ID4gICBk
b19pbml0X21vZHVsZSsweDViLzB4MjFjDQo+ID4gICBsb2FkX21vZHVsZSsweDFiMmYvMHgyMzIw
DQo+ID4gICA/IF9fZG9fc3lzX2Zpbml0X21vZHVsZSsweGFhLzB4MTEwDQo+ID4gICBfX2RvX3N5
c19maW5pdF9tb2R1bGUrMHhhYS8weDExMA0KPiA+ICAgZG9fc3lzY2FsbF82NCsweDNhLzB4YjAN
Cj4gPiAgIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YWUNCj4gPiAgUklQ
OiAwMDMzOjB4N2Y3Y2RkN2M4ZGVkDQo+ID4gIENvZGU6IDViIDQxIDVjIGMzIDY2IDBmIDFmIDg0
IDAwIDAwIDAwIDAwIDAwIGYzIDBmIDFlIGZhIDQ4IDg5IGY4IDQ4IDg5IGY3IDQ4IDg5IGQ2IDQ4
IDg5IGNhIDRkIDg5IGMyIDRkIDg5IGM4IDRjIDhiIDRjIDI0IDA4IDBmIDA1IDw0OD4gM2QgMDEg
ZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgZmIgZWYgMGUgMDAgZjcgZDggNjQgODkgMDEgNDgN
Cj4gPiAgUlNQOiAwMDJiOjAwMDA3ZmZmYjkwYmY0NTggRUZMQUdTOiAwMDAwMDI0NiBPUklHX1JB
WDogMDAwMDAwMDAwMDAwMDEzOQ0KPiA+ICBSQVg6IGZmZmZmZmZmZmZmZmZmZGEgUkJYOiAwMDAw
NTU5YzUwMWNhZjAwIFJDWDogMDAwMDdmN2NkZDdjOGRlZA0KPiA+ICBSRFg6IDAwMDAwMDAwMDAw
MDAwMDAgUlNJOiAwMDAwNTU5YzRlYjM2NmVlIFJESTogMDAwMDAwMDAwMDAwMDAwMg0KPiA+ICBS
QlA6IDAwMDAwMDAwMDAwNDAwMDAgUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDU1OWM1
MDFjYTlmOA0KPiA+ICBSMTA6IDAwMDAwMDAwMDAwMDAwMDIgUjExOiAwMDAwMDAwMDAwMDAwMjQ2
IFIxMjogMDAwMDU1OWM0ZWIzNjZlZQ0KPiA+ICBSMTM6IDAwMDA1NTljNTAxY2FkYjAgUjE0OiAw
MDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDU1OWM1MDFjYmFkMA0KPiA+ICAgPC9UQVNLPg0KPiA+
ICAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NCj4gPiAgV0FSTklORzogQ1BV
OiAxIFBJRDogNTc4IGF0IG5ldC93aXJlbGVzcy9yZWcuYzozMTA3IHJlZ19wcm9jZXNzX3NlbGZf
bWFuYWdlZF9oaW50KzB4MTgzLzB4MWQwIFtjZmc4MDIxMV0NCj4gPiAgTW9kdWxlcyBsaW5rZWQg
aW46DQo+ID4gIENQVTogMSBQSUQ6IDU3OCBDb21tOiBtb2Rwcm9iZSBOb3QgdGFpbnRlZCA1LjE2
LjAtcmMyICMxDQo+ID4gIEhhcmR3YXJlIG5hbWU6IExFTk9WTyAyMEs1UzIyUjAwLzIwSzVTMjJS
MDAsIEJJT1MgUjBJRVQzOFcgKDEuMTYgKSAwNS8zMS8yMDE3DQo+ID4gIFJJUDogMDAxMDpyZWdf
cHJvY2Vzc19zZWxmX21hbmFnZWRfaGludCsweDE4My8weDFkMCBbY2ZnODAyMTFdDQo+ID4gIENv
ZGU6IDgzIGM0IDYwIDViIDQxIDVhIDQxIDVjIDQxIDVkIDQxIDVlIDQxIDVmIDVkIDQ5IDhkIDYy
IGY4IGMzIDQ4IDhkIDdiIDY4IGJlIGZmIGZmIGZmIGZmIGU4IDc1IDRhIDEzIGQ5IDg1IGMwIDBm
IDg1IGU2IGZlIGZmIGZmIDwwZj4gMGIgZTkgZGYgZmUgZmYgZmYgMGYgMGIgODAgM2QgYmMgMmMg
MGIgMDAgMDAgMGYgODUgYzIgZmUgZmYgZmYNCj4gPiAgUlNQOiAwMDE4OmZmZmY5OTk0ODA5Y2Zh
ZjAgRUZMQUdTOiAwMDAxMDI0Ng0KPiA+ICBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZm
OGU1MjQyZjUwNWMwIFJDWDogMDAwMDAwMDAwMDAwMDAwMA0KPiA+ICBSRFg6IDAwMDAwMDAwMDAw
MDAwMDAgUlNJOiBmZmZmOGU1MjQyZjUwNjI4IFJESTogZmZmZjhlNTI0YTJiNWNkMA0KPiA+ICBS
QlA6IGZmZmY5OTk0ODA5Y2ZiODAgUjA4OiAwMDAwMDAwMDAwMDAwMDAxIFIwOTogZmZmZmZmZmY5
YjJlMmY1MA0KPiA+ICBSMTA6IGZmZmY5OTk0ODA5Y2ZiOTggUjExOiBmZmZmZmZmZmZmZmZmZmZm
IFIxMjogMDAwMDAwMDAwMDAwMDAwMA0KPiA+ICBSMTM6IGZmZmY4ZTUyNDJmNTMyZTggUjE0OiBm
ZmZmOGU1MjQ4OTE0MDEwIFIxNTogZmZmZjhlNTI0MmY1MzJlMA0KPiA+ICBGUzogIDAwMDA3Zjdj
ZGQ2YWY3NDAoMDAwMCkgR1M6ZmZmZjhlNTM2NzQ4MDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAw
MDAwMDAwDQo+ID4gIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAw
NTAwMzMNCj4gPiAgQ1IyOiAwMDAwN2YxOTQzMDY4N2FjIENSMzogMDAwMDAwMDEwODhmYTAwMyBD
UjQ6IDAwMDAwMDAwMDAzNzA2ZTANCj4gPiAgQ2FsbCBUcmFjZToNCj4gPiAgIDxUQVNLPg0KPiA+
ICAgPyBsb2NrX2lzX2hlbGRfdHlwZSsweGI0LzB4MTIwDQo+ID4gICA/IHJlZ3VsYXRvcnlfc2V0
X3dpcGh5X3JlZ2Rfc3luYysweDJmLzB4ODAgW2NmZzgwMjExXQ0KPiA+ICAgcmVndWxhdG9yeV9z
ZXRfd2lwaHlfcmVnZF9zeW5jKzB4MmYvMHg4MCBbY2ZnODAyMTFdDQo+ID4gICBpd2xfbXZtX2lu
aXRfbWNjKzB4Y2QvMHgxZDAgW2l3bG12bV0NCj4gPiAgIGl3bF9vcF9tb2RlX212bV9zdGFydCsw
eGM2ZC8weGNiMCBbaXdsbXZtXQ0KPiA+ICAgX2l3bF9vcF9tb2RlX3N0YXJ0LmlzcmEuNCsweDQy
LzB4ODAgW2l3bHdpZmldDQo+ID4gICBpd2xfb3Btb2RlX3JlZ2lzdGVyKzB4NzEvMHhlMCBbaXds
d2lmaV0NCj4gPiAgID8gMHhmZmZmZmZmZmMxMDYyMDAwDQo+ID4gICBpd2xfbXZtX2luaXQrMHgz
NC8weDEwMDAgW2l3bG12bV0NCj4gPiAgIGRvX29uZV9pbml0Y2FsbCsweDViLzB4MzAwDQo+ID4g
ICBkb19pbml0X21vZHVsZSsweDViLzB4MjFjDQo+ID4gICBsb2FkX21vZHVsZSsweDFiMmYvMHgy
MzIwDQo+ID4gICA/IF9fZG9fc3lzX2Zpbml0X21vZHVsZSsweGFhLzB4MTEwDQo+ID4gICBfX2Rv
X3N5c19maW5pdF9tb2R1bGUrMHhhYS8weDExMA0KPiA+ICAgZG9fc3lzY2FsbF82NCsweDNhLzB4
YjANCj4gPiAgIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YWUNCj4gPiAg
UklQOiAwMDMzOjB4N2Y3Y2RkN2M4ZGVkDQo+ID4gIENvZGU6IDViIDQxIDVjIGMzIDY2IDBmIDFm
IDg0IDAwIDAwIDAwIDAwIDAwIGYzIDBmIDFlIGZhIDQ4IDg5IGY4IDQ4IDg5IGY3IDQ4IDg5IGQ2
IDQ4IDg5IGNhIDRkIDg5IGMyIDRkIDg5IGM4IDRjIDhiIDRjIDI0IDA4IDBmIDA1IDw0OD4gM2Qg
MDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgZmIgZWYgMGUgMDAgZjcgZDggNjQgODkgMDEg
NDgNCj4gPiAgUlNQOiAwMDJiOjAwMDA3ZmZmYjkwYmY0NTggRUZMQUdTOiAwMDAwMDI0NiBPUklH
X1JBWDogMDAwMDAwMDAwMDAwMDEzOQ0KPiA+ICBSQVg6IGZmZmZmZmZmZmZmZmZmZGEgUkJYOiAw
MDAwNTU5YzUwMWNhZjAwIFJDWDogMDAwMDdmN2NkZDdjOGRlZA0KPiA+ICBSRFg6IDAwMDAwMDAw
MDAwMDAwMDAgUlNJOiAwMDAwNTU5YzRlYjM2NmVlIFJESTogMDAwMDAwMDAwMDAwMDAwMg0KPiA+
ICBSQlA6IDAwMDAwMDAwMDAwNDAwMDAgUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDU1
OWM1MDFjYTlmOA0KPiA+ICBSMTA6IDAwMDAwMDAwMDAwMDAwMDIgUjExOiAwMDAwMDAwMDAwMDAw
MjQ2IFIxMjogMDAwMDU1OWM0ZWIzNjZlZQ0KPiA+ICBSMTM6IDAwMDA1NTljNTAxY2FkYjAgUjE0
OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDU1OWM1MDFjYmFkMA0KPiA+IA0KPiA+IEZpeGVz
OiBhMDU4MjlhNzIyMmU5ZDEgKCJjZmc4MDIxMTogYXZvaWQgaG9sZGluZyB0aGUgUlROTCB3aGVu
IGNhbGxpbmcgdGhlIGRyaXZlciIpDQo+ID4gU2lnbmVkLW9mZi1ieTogSmlyaSBLb3NpbmEgPGpr
b3NpbmFAc3VzZS5jej4NCj4gDQo+IEkgdGhpbmsgdGhpcyBzaG91bGQgZ28gdG8gd2lyZWxlc3Mt
ZHJpdmVycyBzbyBJIGFzc2lnbmVkIHRoaXMgdG8gbWUuDQo+IEx1Y2EsIGFjaz8NCg0KSG1tbSwg
SSB0aG91Z2h0IHdlIGFscmVhZHkgaGFkIGEgZml4IGZvciB0aGlzIGFzIHdlbGw/DQoNCi0tDQpM
dWNhLg0K
