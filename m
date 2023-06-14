Return-Path: <netdev+bounces-10904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D71730B10
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:58:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E09471C20DA3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE18B13ADE;
	Wed, 14 Jun 2023 22:58:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F23125A2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:58:30 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DE72132
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686783507; x=1718319507;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d1MBmDMmcBN873A3YH+uUJQh7aN3obWyhGzsgbbRrOA=;
  b=GL/vfkRvqnbbFdVK3OsvHH1BeBvL+MGGRzIfr/IOOA8BCI4iU1QSN2e0
   MzU6G5sS5BKYjp+Czjom6ShO1073nR6iOBrbK2GoB8xQyQ6pToVtCR+Vu
   N0+vKUAW4I8zC1dca4B/274+vBAnW3cyJhXzproT3sldgEEXE+su3OHL3
   0AN+uCeXPeEvTxyYge3mREer+N8n+KP8+kwwK9c8SBwR1Y/GPGoQy56lN
   U4xP0xd8zH/SlOlIqFpVPmqRGp7WGyUmXulytDBGi8yJcvmYfdByuVkH3
   76FntYDZ/LXPuFUpGoI/SXfSxa2oas8qyc8+xMMkdun/63lmy8rknVe9S
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387170972"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="387170972"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 15:58:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="706405113"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="706405113"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2023 15:58:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 15:58:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 15:58:25 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 15:58:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvI4sG2+iL7LBZxFZg/QkX0QbHgFokEbIJchdAm6yKMZWVOR2F8ottnd4rAKsKvjedw8LBnehvasWEUh+we3swEXRi8TTe6+AH7rlqmoFfVQRtJ3jtFbViY+atCEkgtJD5vlDaPx8x0MCbkSQYgMUDvbFPSxlU8DprfCaQ9Yju2h5bGycdrxnfKuOFb0OO0/1anuMcOciW6o/rIMWy2xzDtRTybUmiabJGtLlEHrMuf8wbbDbWoEsWVWZzLF4/XhGVdNIipb6gju+0hTecB96rHi2Vej8YjXMWaf98oPXmiObPP+enBWk6A4wj5VcjxGOXut/znLBppVoHp94QRH8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d1MBmDMmcBN873A3YH+uUJQh7aN3obWyhGzsgbbRrOA=;
 b=B/4+SDnJf0yL5uw9k8cly17tk9MNB+zo32Xjgmmri+BTjvX/5Oe6is/8Szte0y1jZhuYNMyKD106WSUji3s5ua0qDwRXylL/io0XNy9wY6Fe3+efWGGpMFWDFngj9LUtkmatnYU5gYSzqX7FHHO+GuEHsTutC2LVjVfC2OkfYtR9wC76tQewEEQOlGP3tRaomGIBF7a9bO6yEp4Kg0oP/jbRRvJ+Ma6LQuP7Ukc+/ARnLwH8xHuUcTV11JcUzRegsIoClYyr347F9AnP/DVPV17tykQNiK6VsLwsPTbJIFtIm6vbw3SKIMsUhbmd6jbRtXYxruLnlPQn7a05QeG6lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by DM4PR11MB7758.namprd11.prod.outlook.com (2603:10b6:8:101::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 22:58:19 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a%6]) with mapi id 15.20.6455.030; Wed, 14 Jun 2023
 22:58:19 +0000
From: "Ertman, David M" <david.m.ertman@intel.com>
To: Brett Creeley <bcreeley@amd.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>
CC: "daniel.machon@microchip.com" <daniel.machon@microchip.com>,
	"simon.horman@corigine.com" <simon.horman@corigine.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH iwl-next v4 04/10] ice: implement lag netdev event handler
Thread-Topic: [PATCH iwl-next v4 04/10] ice: implement lag netdev event
 handler
Thread-Index: AQHZnwaglZ7ENpsem06wiMN1siC/Ia+K5hiA
Date: Wed, 14 Jun 2023 22:58:19 +0000
Message-ID: <MW5PR11MB5811D84BB9769C3FE5D0AEA8DD5AA@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
 <20230609211626.621968-5-david.m.ertman@intel.com>
 <26e4698d-fd5e-feae-b9ee-fc3ac35c7a1c@amd.com>
In-Reply-To: <26e4698d-fd5e-feae-b9ee-fc3ac35c7a1c@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|DM4PR11MB7758:EE_
x-ms-office365-filtering-correlation-id: 86c9b00e-c233-446b-bb50-08db6d2ad8e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cr0fYSaCI2ADHm6TRCxy1FiIulvQA8uAMCngDJzvLN5f8T6yFd59ShN8gIXvfh5mYWIgWtMCryejpQ0zwkYopGONb7hkYxBlgo9KVcUouQZhL+5eMgMuDSiza3XOMKbUoT+h50NXGQ49XhYy2p/YTLQRfGfULjVrycr2Rodmo1SCAWng7p3MVk4DQlQrr/w4ENylk8npeE82GRtRWwjjbcn1lFxDA7evfnOfJFppD5a8qjbxsnRVrZ3XBv785CfQYZYjRJVF8efWVycePGrG+6OeXAtFWuUp5ZnSikq5d12SLAVshLDZ5YiEvnsRZRXMfENwoC+GwcH8SBThJmG6ihISSd2HF6MSCP6Gu844wB75fAeXQqAwmctxD948bp5ArUnGXY6Bcksekoan7oeqyq7kh0gTT9F0t6bI97t9QaMbGe29naz+sGaAtvLr7Qeq5ghr/99QFHdyuM1jMt//P0f7C/aYfvkufZiqOWfy1fO7ZoQNfQWktd6rLsPiO9pPIyiR7ly3wE4od+qN3rWtmnSK3QFZNzuUWY4v3GPR0w9Link6SBRLCUrVKpWm9Hoq1sQsvW/lLEq73q4eW3sWRGo8Jf9nNIC9WAROuGpu0S/OsP7GSmhkA1ut8tv/5zlI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(346002)(136003)(39860400002)(451199021)(7696005)(316002)(41300700001)(122000001)(2906002)(9686003)(86362001)(6506007)(186003)(53546011)(26005)(38070700005)(33656002)(82960400001)(55016003)(38100700002)(83380400001)(5660300002)(8936002)(52536014)(76116006)(8676002)(66946007)(66476007)(478600001)(54906003)(110136005)(4326008)(71200400001)(66556008)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGUvVkdoU2V0RGV2Qk1Ja2VZTzVoQmxiVVAyeWNEM1VzZ3JvVTNiSXdXeC96?=
 =?utf-8?B?ZGdTTm9Sc3hlekhNZ3lXYmdMMkEvS0JzbEJsNGEzY2xyd2NnRVk0TUJndDFG?=
 =?utf-8?B?bTdtK21xRjAwcVNpaGNIVEx0S2hGRjJHdmcxRmdJaHRJZGI2akxsTmNFSGJB?=
 =?utf-8?B?bDgwZDNqUUdrM3B4VElQTE1Xc3VzbnQwbXBZMnJPN25uSUdndmsrT242OEpE?=
 =?utf-8?B?eHhhSVc4Y093TWRpd0ZBVVBOdjZ4Z2h4czBRK1BOSW5mc0Vxd2RSVk82YXhn?=
 =?utf-8?B?V2dIOUttK2ZQUzVaZEtiOUZ5RWFXTkYyZXdXcC9zRUgvTWJhSzNIajBkMDNY?=
 =?utf-8?B?YURhbUR6Q2FOd1ZHdkgwemIvUElwOGs5Q0ZnbGxjOURLY3pOL3EwT1plOGwx?=
 =?utf-8?B?eHpRanFZVHdxckpHY05hVUtKSklCM2hXNVdXY2kxRXhIM2JYb2F4VFR4Mk5Q?=
 =?utf-8?B?WFBYK0FqUXNyczJjdTkvTXV0R0pZTHR0c0lYVk15L1k5eS9CQyt0blVxY0Nx?=
 =?utf-8?B?OXFkbWROaE9ZUE16OVJpSjVMb2JqQmdQYXdCYjNRK1QxRXFHUUpnbjIxOTJy?=
 =?utf-8?B?R1gzSi9vbzNsOWRJMWlVb1ZsMWtMUlI1U3FtS0RmMlpZL3l2VFNQTDQ0Qjcz?=
 =?utf-8?B?SFBaSGNPQ2JVQU81LzZrOFBPQUpRbldOdk9qaU41N1FMZ3Q0RkxuR2NPb3JC?=
 =?utf-8?B?SkRBSnJ1bGJXQnA0ZzlIUUZEQitrZXhKWm1yV2tQeUMwdUZHL05Xb3RRMVpi?=
 =?utf-8?B?ZWdSS0pEeXhqYzJETkFIOUlSUUttaXZjSFkrTEkwSUM2MTZxbFBNVkNsZmNS?=
 =?utf-8?B?eDFXanFQanBBZnBRR1A1RlFKUUpVMnpZUjBsdEpnUEVhT2ZZYnd4N1lxMkEv?=
 =?utf-8?B?Vm53TW1oVDRmaHdGb2hXRWEwMHgxWU4xUVRiK3cwVU81MXUvM3BsYmY2OHM4?=
 =?utf-8?B?NTd1Y05iVlZqeGxpZDhVd2IzZmRNMEhBU2FTc0hpMVR3VWx5ZUVhbWVxQlZJ?=
 =?utf-8?B?am04dUFPSFBnZHJXbHRlSXVqMzlOSUtxK1FoNEtDVEhhN1ZuZzdZR0ZIODJs?=
 =?utf-8?B?NWlqUC9veGpkNFZqVGN0TkFmOUlZU04zNHd4SHZJaFg5SEp2SWZUQXB1bVk2?=
 =?utf-8?B?bnNDcFBPY0Y0cmtPbFFQbUl2c2txT01MY3ZsdHQxU0NFaXZOeHBQRG1ubnpN?=
 =?utf-8?B?MW5pZEs2TDRhYy9NMFlpbTEvbTRqKzZzSnpXU3M1c1p4WVVHZVM4Y01hTi9J?=
 =?utf-8?B?LzBQRjJxbktXZ2owSXJjY2ZCRk1KeTdXSHd3THZyeFVSbXR0eG5rY2ppalpX?=
 =?utf-8?B?clRLS2kwb2VBTXpHV0ZCT3RMWG5PVU4vdXhTVjk0UmM0cWlpVi91VWRYRldP?=
 =?utf-8?B?Y2JYU3NPaE9DY0E4ZG54MkFDa3BzaUpaa3RxbE9XU0I1UUVOQUdMclhHdkZj?=
 =?utf-8?B?RGh3VzlFdnJvSUVzTWJFQkdvOElxcEVncUhjbmR3WGF3NXlTdVkwMkZzdXky?=
 =?utf-8?B?aFlCQytDbGtnOTl0N29XTE5uVVBCYWR3KzZvbEd0QTV5d0RGZnlwejJIM2pk?=
 =?utf-8?B?cjA2SXhwREJrMi9oRkNGU2JjTnNLWnpzaEs4UW9ocnNYNmZvT0NsY0trUGpI?=
 =?utf-8?B?bERrYzBpa0U5dnF4by8xVGFEY0dkeHJiMGU5UG1mWGpaRTkvUVgwNEJ2QUVE?=
 =?utf-8?B?OURGR0xIRG5xM2NuWlU0Qk1vckdRU1Z1Y2hrb3grOWZKdWl2SVV5NWs4MjFF?=
 =?utf-8?B?cXdYRjlzVVZpOXI1VzlNZWFqVWNTQzZObHBQT2ludnBRejY5a2ZTbmpZZVVO?=
 =?utf-8?B?RnBKZGJzZUZFalh5ZE16SGx4ZElsRXdpdWtWNHJ2UWNBVTNETjFSTlV5Vi9S?=
 =?utf-8?B?SmVEeUY2d0VDVHVlODdpWGNkVDlHdnQ5d3dRdERjSEY5MTVGa3ZmT3BEMGNu?=
 =?utf-8?B?NjJ0RS9vL3kwNVN1NlJwV1FDOVVOMkkxNGRQVWJ2OThFTmN4bk1OaWdwaVlx?=
 =?utf-8?B?TmRvUWNvSnRNb2E2aGF5U09pMnBOWVVwNm9OeFduVFZOL01NbWowNW92S0Jh?=
 =?utf-8?B?Y0g3Mkk0SVdqUzlWMnhidjBjKzBlUm83RDJCZm0vNTgvaDd5SjBJTXVqK0k4?=
 =?utf-8?Q?UTOIIriD9/S20ZS5Jn2xdph55?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c9b00e-c233-446b-bb50-08db6d2ad8e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 22:58:19.7675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Y6SAOMMJBRNnpqiBaw5H6x4OgE4EMcxksnDj2bR0OvIFMvqIvz4cxDQrvQiaMor1vj7GBcMRHN75O1S7l5x2AF4DdFj6EtXfDeT5ylG9sI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7758
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCcmV0dCBDcmVlbGV5IDxiY3Jl
ZWxleUBhbWQuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEp1bmUgMTQsIDIwMjMgMjoyNCBQTQ0K
PiBUbzogRXJ0bWFuLCBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+OyBpbnRlbC13
aXJlZC0NCj4gbGFuQGxpc3RzLm9zdW9zbC5vcmcNCj4gQ2M6IGRhbmllbC5tYWNob25AbWljcm9j
aGlwLmNvbTsgc2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGl3bC1uZXh0IHY0IDA0LzEwXSBpY2U6IGltcGxl
bWVudCBsYWcgbmV0ZGV2IGV2ZW50DQo+IGhhbmRsZXINCj4gDQo+IE9uIDYvOS8yMDIzIDI6MTYg
UE0sIERhdmUgRXJ0bWFuIHdyb3RlOg0KPiA+IENhdXRpb246IFRoaXMgbWVzc2FnZSBvcmlnaW5h
dGVkIGZyb20gYW4gRXh0ZXJuYWwgU291cmNlLiBVc2UgcHJvcGVyDQo+IGNhdXRpb24gd2hlbiBv
cGVuaW5nIGF0dGFjaG1lbnRzLCBjbGlja2luZyBsaW5rcywgb3IgcmVzcG9uZGluZy4NCj4gPg0K
PiA+DQo+ID4gVGhlIGV2ZW50IGhhbmRsZXIgZm9yIExBRyB3aWxsIGNyZWF0ZSBhIHdvcmsgaXRl
bSB0byBwbGFjZSBvbiB0aGUgb3JkZXJlZA0KPiA+IHdvcmtxdWV1ZSB0byBiZSBwcm9jZXNzZWQu
DQo+ID4NCj4gPiBBZGQgaW4gZGVmaW5lcyBmb3IgdHJhaW5pbmcgcGFja2V0cyBhbmQgbmV3IHJl
Y2lwZXMgdG8gYmUgdXNlZCBieSB0aGUNCj4gPiBzd2l0Y2hpbmcgYmxvY2sgb2YgdGhlIEhXIGZv
ciBMQUcgcGFja2V0IHN0ZWVyaW5nLg0KPiA+DQo+ID4gVXBkYXRlIHRoZSBpY2VfbGFnIHN0cnVj
dCB0byByZWZsZWN0IHRoZSBuZXcgcHJvY2Vzc2luZyBtZXRob2RvbG9neS4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IERhdmUgRXJ0bWFuIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+DQo+ID4g
LS0tDQo+ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xhZy5jIHwgMTI1
ICsrKysrKysrKysrKysrKysrKysrLS0NCj4gLQ0KPiA+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWNlL2ljZV9sYWcuaCB8ICAzMCArKysrKy0NCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwg
MTQxIGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGFnLmMNCj4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xhZy5jDQo+ID4gaW5kZXggNzNiZmM1Y2Q4YjM3Li41
MjlhYmZiOTA0ZDAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWNlL2ljZV9sYWcuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9p
Y2VfbGFnLmMNCj4gDQo+IFsuLi5dDQo+IA0KPiA+ICsvKioNCj4gPiArICogaWNlX2xhZ19wcm9j
ZXNzX2V2ZW50IC0gcHJvY2VzcyBhIHRhc2sgYXNzaWduZWQgdG8gdGhlIGxhZ193cQ0KPiA+ICsg
KiBAd29yazogcG9pbnRlciB0byB3b3JrX3N0cnVjdA0KPiA+ICsgKi8NCj4gPiArc3RhdGljIHZv
aWQgaWNlX2xhZ19wcm9jZXNzX2V2ZW50KHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCj4gPiAr
ew0KPiA+ICsgICAgICAgc3RydWN0IG5ldGRldl9ub3RpZmllcl9jaGFuZ2V1cHBlcl9pbmZvICpp
bmZvOw0KPiA+ICsgICAgICAgc3RydWN0IGljZV9sYWdfd29yayAqbGFnX3dvcms7DQo+ID4gKyAg
ICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2Ow0KPiA+ICsgICAgICAgc3RydWN0IGxpc3Rf
aGVhZCAqdG1wLCAqbjsNCj4gPiArICAgICAgIHN0cnVjdCBpY2VfcGYgKnBmOw0KPiA+ICsNCj4g
PiArICAgICAgIGxhZ193b3JrID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCBpY2VfbGFnX3dv
cmssIGxhZ190YXNrKTsNCj4gPiArICAgICAgIHBmID0gbGFnX3dvcmstPmxhZy0+cGY7DQo+ID4g
Kw0KPiA+ICsgICAgICAgbXV0ZXhfbG9jaygmcGYtPmxhZ19tdXRleCk7DQo+ID4gKyAgICAgICBs
YWdfd29yay0+bGFnLT5uZXRkZXZfaGVhZCA9ICZsYWdfd29yay0+bmV0ZGV2X2xpc3Qubm9kZTsN
Cj4gPiArDQo+ID4gKyAgICAgICBzd2l0Y2ggKGxhZ193b3JrLT5ldmVudCkgew0KPiA+ICsgICAg
ICAgY2FzZSBORVRERVZfQ0hBTkdFVVBQRVI6DQo+ID4gKyAgICAgICAgICAgICAgIGluZm8gPSAm
bGFnX3dvcmstPmluZm8uY2hhbmdldXBwZXJfaW5mbzsNCj4gPiArICAgICAgICAgICAgICAgaWYg
KGljZV9pc19mZWF0dXJlX3N1cHBvcnRlZChwZiwgSUNFX0ZfU1JJT1ZfTEFHKSkNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICBpY2VfbGFnX2NoYW5nZXVwcGVyX2V2ZW50KGxhZ193b3JrLT5s
YWcsIGluZm8pOw0KPiA+ICsgICAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICAgIGNhc2Ug
TkVUREVWX0JPTkRJTkdfSU5GTzoNCj4gPiArICAgICAgICAgICAgICAgaWNlX2xhZ19pbmZvX2V2
ZW50KGxhZ193b3JrLT5sYWcsICZsYWdfd29yay0NCj4gPmluZm8uYm9uZGluZ19pbmZvKTsNCj4g
PiArICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAgICAgICBjYXNlIE5FVERFVl9VTlJFR0lT
VEVSOg0KPiA+ICsgICAgICAgICAgICAgICBpZiAoaWNlX2lzX2ZlYXR1cmVfc3VwcG9ydGVkKHBm
LCBJQ0VfRl9TUklPVl9MQUcpKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgbmV0ZGV2
ID0gbGFnX3dvcmstPmluZm8uYm9uZGluZ19pbmZvLmluZm8uZGV2Ow0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgIGlmICgobmV0ZGV2ID09IGxhZ193b3JrLT5sYWctPm5ldGRldiB8fA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGFnX3dvcmstPmxhZy0+cHJpbWFyeSkgJiYg
bGFnX3dvcmstPmxhZy0+Ym9uZGVkKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaWNlX2xhZ191bnJlZ2lzdGVyKGxhZ193b3JrLT5sYWcsIG5ldGRldik7DQo+ID4gKyAgICAg
ICAgICAgICAgIH0NCj4gPiArICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAgICAgICBkZWZh
dWx0Og0KPiA+ICsgICAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICAgIH0NCj4gPiArDQo+
ID4gKyAgICAgICAvKiBjbGVhbnVwIHJlc291cmNlcyBhbGxvY2F0ZWQgZm9yIHRoaXMgd29yayBp
dGVtICovDQo+ID4gKyAgICAgICBsaXN0X2Zvcl9lYWNoX3NhZmUodG1wLCBuLCAmbGFnX3dvcmst
Pm5ldGRldl9saXN0Lm5vZGUpIHsNCj4gPiArICAgICAgICAgICAgICAgc3RydWN0IGljZV9sYWdf
bmV0ZGV2X2xpc3QgKmVudHJ5Ow0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgZW50cnkgPSBs
aXN0X2VudHJ5KHRtcCwgc3RydWN0IGljZV9sYWdfbmV0ZGV2X2xpc3QsIG5vZGUpOw0KPiA+ICsg
ICAgICAgICAgICAgICBsaXN0X2RlbCgmZW50cnktPm5vZGUpOw0KPiA+ICsgICAgICAgICAgICAg
ICBrZnJlZShlbnRyeSk7DQo+ID4gKyAgICAgICB9DQo+ID4gKyAgICAgICBsYWdfd29yay0+bGFn
LT5uZXRkZXZfaGVhZCA9IE5VTEw7DQo+ID4gKw0KPiA+ICsgICAgICAgbXV0ZXhfdW5sb2NrKCZw
Zi0+bGFnX211dGV4KTsNCj4gPiArDQo+ID4gKyAgICAgICBrZnJlZSh3b3JrKTsNCj4gDQo+IFNo
b3VsZCB0aGlzIGJlIGZyZWVpbmcgbGFnX3dvcmsgaW5zdGVhZD8NCg0KTmljZSBjYXRjaCEhISAg
WW91IGFyZSByaWdodCwgbGFnX3dvcmsgaXMgd2hhdCBpcyBhbGxvY2F0ZWQgbm90IGl0J3MgZWxl
bWVudCB3b3JrIQ0KDQo+IA0KPiA+ICt9DQo+ID4gKw0KPiA+ICAgLyoqDQo+ID4gICAgKiBpY2Vf
bGFnX2V2ZW50X2hhbmRsZXIgLSBoYW5kbGUgTEFHIGV2ZW50cyBmcm9tIG5ldGRldg0KPiA+ICAg
ICogQG5vdGlmX2Jsazogbm90aWZpZXIgYmxvY2sgcmVnaXN0ZXJlZCBieSB0aGlzIG5ldGRldg0K
PiA+IEBAIC0yOTksMzEgKzM1MSw3OSBAQCBpY2VfbGFnX2V2ZW50X2hhbmRsZXIoc3RydWN0IG5v
dGlmaWVyX2Jsb2NrDQo+ICpub3RpZl9ibGssIHVuc2lnbmVkIGxvbmcgZXZlbnQsDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICB2b2lkICpwdHIpDQo+ID4gICB7DQo+ID4gICAgICAgICAgc3Ry
dWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IG5ldGRldl9ub3RpZmllcl9pbmZvX3RvX2RldihwdHIp
Ow0KPiA+ICsgICAgICAgc3RydWN0IG5ldF9kZXZpY2UgKnVwcGVyX25ldGRldjsNCj4gPiArICAg
ICAgIHN0cnVjdCBpY2VfbGFnX3dvcmsgKmxhZ193b3JrOw0KPiA+ICAgICAgICAgIHN0cnVjdCBp
Y2VfbGFnICpsYWc7DQo+ID4NCj4gPiAtICAgICAgIGxhZyA9IGNvbnRhaW5lcl9vZihub3RpZl9i
bGssIHN0cnVjdCBpY2VfbGFnLCBub3RpZl9ibG9jayk7DQo+ID4gKyAgICAgICBpZiAoIW5ldGlm
X2lzX2ljZShuZXRkZXYpKQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gTk9USUZZX0RPTkU7
DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKGV2ZW50ICE9IE5FVERFVl9DSEFOR0VVUFBFUiAmJiBl
dmVudCAhPQ0KPiBORVRERVZfQk9ORElOR19JTkZPICYmDQo+ID4gKyAgICAgICAgICAgZXZlbnQg
IT0gTkVUREVWX1VOUkVHSVNURVIpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBOT1RJRllf
RE9ORTsNCj4gDQo+IFdvdWxkIGl0IG1ha2UgbW9yZSBzZW5zZSB0byBwcmV2ZW50IHRoZSB3b3Jr
IGl0ZW0gYW5kIGFueSByZWxhdGVkIHdvcmsNCj4gaWYgdGhlIGljZV9pc19mZWF0dXJlX3N1cHBv
cnRlZChwZiwgSUNFX0ZfU1JJT1ZfTEFHKSBjaGVjayBpcyBtb3ZlZCB0bw0KPiB0aGlzIGZ1bmN0
aW9uIGFsb25nIHdpdGggdGhlIGV2ZW50cyB0aGF0IHJlcXVpcmUgdGhhdCBmZWF0dXJlPw0KPiAN
Cj4gU29tZXRoaW5nIGxpa2U6DQo+IA0KPiBpZiAoKGV2ZW50ID09IE5FVERFVl9DSEFOR0VVUFBF
UiB8fCBldmVudCA9PSBORVRERVZfVU5SRUdJU1RFUikNCj4gJiYNCj4gICAgICAgIWljZV9pc19m
ZWF0dXJlX3N1cHBvcnRlZChwZiwgSUNFX0ZfU1JJT1ZfTEFHKSkNCj4gCXJldHVybiBOT1RJRllf
RE9ORTsNCj4gDQoNCkV2ZW4gaWYgU1JJT1YgaXMgbm90IHN1cHBvcnRlZCwgdGhlcmUgYXJlIHN0
aWxsIHRhc2tzIHRoYXQgbmVlZCB0byBiZSBwZXJmb3JtZWQgZm9yIGJvbmRpbmcNCmV2ZW50cyAt
IGUuZy4gdW5wbHVnIHRoZSBSRE1BIGF1eCBkZXZpY2VzLCBzbyB3ZSBkb24ndCB3YW50IHRvIGF2
b2lkIGNyZWF0aW5nIGEgd29ya3F1ZXVlDQplbnRyeSB3aGVuIGZlYXR1cmUgbm90IHN1cHBvcnRl
ZC4gV2hpY2ggbWFrZXMgbWUgbm90aWNlIHRoYXQgaWNlX2xhZ19jaGFuZ2V1cHBlcl9ldmVudA0K
aXMgdW5kZXIgYSBmZWF0dXJlIGNoZWNrIGFuZCBpdCBzaG91bGQgbm90IGJlIGhlcmUuDQoNCldp
bGwgY2hhbmdlIGl0LiAgQ2hhbmdlcyBjb21pbmcgaW4gdjUuDQpEYXZlRQ0KDQo+ID4NCj4gPiAr
ICAgICAgIGlmICghKG5ldGRldi0+cHJpdl9mbGFncyAmIElGRl9CT05ESU5HKSkNCj4gPiArICAg
ICAgICAgICAgICAgcmV0dXJuIE5PVElGWV9ET05FOw0KPiA+ICsNCg0K

