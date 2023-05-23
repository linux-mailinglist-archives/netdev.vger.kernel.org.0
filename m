Return-Path: <netdev+bounces-4628-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD71570D9BF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C8D31C20CF5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DCC1E537;
	Tue, 23 May 2023 10:00:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512F41E501
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:00:38 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447C0E6
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684836036; x=1716372036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A9hWUjkUnAYjZGXbZp13x/saMLnayAqGhoy/dA6GYqs=;
  b=KcpHRjF/1RNClV3TA0ATYPZTaxNFgsGoM6OBpuCjtT18kS3WTNYzEtoj
   8lIqJid6Hqv1xN3gdCRRprEL0fy+hIHTjCh+SU4MfaHdO4OzdCHbqq100
   1P//dr04UH1cHSfrk6EW9z0S++XVUWgygE3eIJbBRflJ2MnFPF9OtrFg+
   07mnv+spF+g44b6JHdeEQPoxKp8YbGEq+kvTEEMKsljWXtJ4rIihJVucY
   ATs6x78CtEa0LWcc59xmckp+ZCdd7ZAWK1BDPM7A4ohX4b81zSxkIz2IF
   U7zt1rCMADt7ftseyy7uKf2Eb5h/pAVn9aaSfIRiwU+M58u2g6bE8aw5m
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="332807526"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="332807526"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 03:00:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="1033996745"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="1033996745"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 23 May 2023 03:00:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 03:00:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 03:00:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 03:00:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WedFUfnn3IJtHMiKvySko6wJH3smgJGmANtVIuD/fZUv0LRUPOw8RIrNaRvCKYmkmA6WLfbXSJN9D3MmZH8bk6/vFlMYyEbbkX86AFCPEmP4HBwDWfFNzwp2kt1Z8OrhHe9yly6BYaaamKmPJjbABlUEA2OEw78sxVL+vfIGkQz9/JFgFyWmF9ETx1CUmr15k4g5UFPSbo9zybUtCW4cVeOt/rmMCEytJ8AOqDC059XJH64tPGJai3d/YQlBXx8ijB40v+A99xGtMhZhRi5gjqCHbs4k+fUT3+OuNcVuZrbHYANHQXnjc7xF/qprDeRqg22WZBfeCSwl0dNhPHqCWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9hWUjkUnAYjZGXbZp13x/saMLnayAqGhoy/dA6GYqs=;
 b=hBzUqe/AXx+r1WSkj4DuQ1poRgOEIWRF09XTG+pUt0B3Ya6h2hTz0HeyZn4TRqHh5MExLJOlIsbP8lnAtCJU+hclN/uj6htPCaAJ6CPBOQIRcc+FErUhB9jWZ26724p7Vgr5Ruu9DQHVOpKQp/PbZwdjr+jUbInDCUmchiInJXA69mja5f1i5RbnQjelhC/BfB6p4RlEiwsamU6HKANcBu/1BAdvScy/VrTbWCfngj+8OUOCOqC7oMwPzggvMoJzjhl1WjfofYC3/u/2v8IDPuDzx4GUe13yvdQWOd0sqeD/IgJpayPSu+XiOk/9yXEhQz+iNvTxtJWlPsis/Wu6lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by PH8PR11MB6973.namprd11.prod.outlook.com (2603:10b6:510:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 10:00:30 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 10:00:30 +0000
From: "Drewek, Wojciech" <wojciech.drewek@intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next v3 09/10] ice: implement static
 version of ageing
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next v3 09/10] ice: implement
 static version of ageing
Thread-Index: AQHZjIzwoGlo19EJEEqD667oEvGRCa9mEw2AgAGDmyA=
Date: Tue, 23 May 2023 10:00:30 +0000
Message-ID: <MW4PR11MB5776FEB0387A9B1E800FDE7EFD409@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230522090542.45679-1-wojciech.drewek@intel.com>
 <20230522090542.45679-10-wojciech.drewek@intel.com>
 <c883bf80-3110-79a4-617a-69566ba360c6@molgen.mpg.de>
In-Reply-To: <c883bf80-3110-79a4-617a-69566ba360c6@molgen.mpg.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|PH8PR11MB6973:EE_
x-ms-office365-filtering-correlation-id: 43a4a462-9d74-47c7-3858-08db5b748a9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fr37YPV72i61k5zYazaBLyaje1D1+GPaXDvL55O1itILQfbued7ZtX1ocqznwoBhLWqzumh3SbxSDyZbp07k1xTV54Fm3oaIRzB50I5Ylo0L9sMERm/aklAJgXlN0yABiiv8YoO3qRmZZS/I+NBeGFTLzjq+W1FE4J6XraPGq/7Td79/7zfhROsy+fehifAcO7M5eZSGoK5Hqk3D5Ik5zPcgk5FXbTRJoSp+OFiY+nqI50zKejWyi50LJSyvhXc7Sujf1ftEZ+GTo1hrqPOxUAL2JfDqhRGD4evTqXy9PP0QGL/j8dGAdbom+k9ueVxbqBVWRKcb1SZ75klMtsRG9rIpfg5ch45gzDfvOUUmVyPrFj/73zAVYnqq9UzzZBIMWmRhf7Bn/yNf70E/glzBXd7jBTYSi6N2M2cAeuB79HBKwZEIN+rSABs2xwL8aL+02K5+VqlWCIzNQWwotN0Rkx8ZYk6N13TbkEBM4FI2SCRIQyqyUjjAHj/fdk9+UkH8SJEoTnnCJSt0zy6dHvrucvbuFtu9+BeebnqNbx2am3M8j4HBBsd+7cMgB1zBCDUP+deRcOFu+oUpE2WPtBl4WQblOCZiIGIR904BwMELHYKG9GzRE/CkqjcebpS4m8r5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199021)(54906003)(122000001)(478600001)(38070700005)(38100700002)(66556008)(66446008)(66476007)(64756008)(82960400001)(66946007)(83380400001)(76116006)(6916009)(4326008)(71200400001)(316002)(66574015)(41300700001)(2906002)(7696005)(86362001)(186003)(8936002)(8676002)(5660300002)(52536014)(33656002)(53546011)(26005)(9686003)(6506007)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmphK21oVi9wNVFybjFOei8wUkN0MlIzNDQyQTV0MnFkdmh3ZmtERHJtRm1W?=
 =?utf-8?B?aGRaYVFMR3BQQzBpOHBYenF1MkIyWTBWcEFuTEJ2dW5xQlZBRSt1VU8xVDR2?=
 =?utf-8?B?ajU1a3hna0xXRDlSLzdubUx0ZkgwL04xQldDWW56UExEZWprYmErc0NHaXJJ?=
 =?utf-8?B?Z0JkM3d3dFZXWmJtUmtIVzkrcUZUYkNKZFczOVZGbDhZZ2QvODQvdnp1Mkt1?=
 =?utf-8?B?MDJvUEMyMWZXeS9PNDd4WlUxeTZUc3B0SE1OcENHWXpwNTZ6WXZxbm9ZUFpz?=
 =?utf-8?B?OGRVUjA2cFY0cm9WZEVmckxpUmFpM3RlNUlHYmJ5NmltOHB3cGpDSFJYSGpZ?=
 =?utf-8?B?S05NRVErQmRaOFJVVzluNklNRDkzWHY2M29RS20yUU1RWWVmcGN4T3dFYXFI?=
 =?utf-8?B?cE9FYUg4V0JUcUJHckJudm1wSVQ2YjhhVFp4aStYNnZWSklKZ0k4MkRGZGxR?=
 =?utf-8?B?RkV1TFN4QVZuV2dKWkY1YnFzN1BrdFRvemFOMjF4YnlZV00yTzE2QkhCd2c2?=
 =?utf-8?B?OERBK2hhWmxLUUxadUtYVmJvQk90VUZoZnVlNkNPU2k2eUpvYUYydGVIVzVy?=
 =?utf-8?B?Zkw5cjlhZFc3c2lSWXlKclJ3cjhWcWd6N2RIKzE5ZzRKZHBmWWF5MW5uRE1o?=
 =?utf-8?B?YjNHZzc0Z3M0QysvUEI5eEVvUHFKZUFJandZZUg2d0todytIWS9nQkNsanEr?=
 =?utf-8?B?MXdjRUlXZFYrNW8zT1VCWlhIN1hCanFUVGw1MGJTNmMzK0VrYU5mOHJ1Mm9M?=
 =?utf-8?B?RUtCMXVXeElqU1hhcmdxYVlrcXF2QkRjL0llVWQ2SUJtR3BnckdFVDhtL3dN?=
 =?utf-8?B?Z3BPNmpvRDRrSXZ0OHQ5RkhoL2Q5NkRwNmpPWS9zZXdWWkQxSGNNbjBQdG9i?=
 =?utf-8?B?TnZYK01VOVFGbEIwYWJ2KzlFMGh5aVlUTmxXZFlPYTBvZjV0RjNwbHJDREp4?=
 =?utf-8?B?d0Qzck5EMjc4M3lGTjhtQm1sWlp6Q0wxc2wwZFNrbDg2d3pCZWx1Y0FRb2pX?=
 =?utf-8?B?aUFsZGg2ZEZ5OWlhcVVXbU5EK1NmRHpBVS9SaU15QUFMRko2Zkk0R1IwQ05u?=
 =?utf-8?B?RUJhNVczaHdOWXBJd0EwKzIwaWpqMWhVWUo1YUtkeXE0QTVWd3FyOU9RV1p4?=
 =?utf-8?B?UGV0STUzNldaOEduUzFLYW40c3E1aXJUa2hZNkxVN1owbGJoTUY2TWd6WVpp?=
 =?utf-8?B?RDlRUlZPKy81OUFneTlWZlJPYVZnTXFOenlNSCtsd2ZhU2FCbExPQlRvQ1Ju?=
 =?utf-8?B?ZDJWRkVUTmtRU2Rld0tNZUtVYWtZNSsrNHhXVWZYRkp5OWxrc1JHOXNsT2tx?=
 =?utf-8?B?ZTRtd1RUVWl2Q3A5cVZKdnJuVndKOWVlb1Rwdy91ZitxNHJycmZtSFkwWms0?=
 =?utf-8?B?a1pyelVid2kwblZRZVBlQTdpU1NmT1NaVWRyK3NSMkdSdWV0c3ZlRkxFQUlY?=
 =?utf-8?B?ei9HTlJici9WRVA3OERud3RwK2lucVBEcTNydE5LM1EzVld6cENQVk1iSFgw?=
 =?utf-8?B?bUJXTlVjRjVUbjBWcFVqQTgrMlVtNk5vNlhYMGhpcS9qcnRybmpLbGsvaFpl?=
 =?utf-8?B?NmdCMmxJdzROcng4Nm15eWJiUG13L2tEc3V2Yyt2aHdlQ2RiY0N5ckh4anZn?=
 =?utf-8?B?Z1hKMUpoZG9VQzZLYlVhQ1NUZ2UwbVUzU0NQaWUweWFDRU5ORjBBOTNxY1dO?=
 =?utf-8?B?OXhoRFRQM3ZyK0Fobi9TeFpRVDBIV2sya2o2WEltYUI4MjBmY3Vuc0xlc21Z?=
 =?utf-8?B?TFljUVJLTG9mRVdld0ZIVm5QZ3FtNDJMclYxZTdYWE0xWWxjNHRNai91M29r?=
 =?utf-8?B?b2dOV2JBc1U2dlA4SzlvTDBrZzJqK0JpeFk3SHo2TmVDbzgzNmdqQndSM2FL?=
 =?utf-8?B?RmhTZ3lkQ0M5ZlUrdkZZZEtTUUFnVExROUtEaVdOTWRUM29CVGFYN1B3b0Nz?=
 =?utf-8?B?Z0MvUWtlQXRLc1FLRHdwZ3c5UVU1ZlBNYkZCVnZMTGNPWUgxZFVIVUxGdUpv?=
 =?utf-8?B?V0VxNmwzVklVUmVZZHhvU3UwZXpubWtSbldxREZ2NHI2Z3p0WWZhVm9zRXVm?=
 =?utf-8?B?YTh4RFJLb0hsdmUzWkY4bUoxaUkycm5QaTl4WGx5dGJGVFN3cmxGZ000RW05?=
 =?utf-8?Q?zjPyX9rSbZL50oHsaqY18AjLO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a4a462-9d74-47c7-3858-08db5b748a9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 10:00:30.2406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yEV6Gi3P5DAWX2QzXS2hAzdmqfiAmPBJeFxsA4AJb0CvjL2KVeTt7PE4u+9vh/8zuW0AEbCl7Ky6kjQOnmeUYLS4kCYoe9Gd72AdCm5UkO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6973
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGF1bCBNZW56ZWwgPHBt
ZW56ZWxAbW9sZ2VuLm1wZy5kZT4NCj4gU2VudDogcG9uaWVkemlhxYJlaywgMjIgbWFqYSAyMDIz
IDEyOjE0DQo+IFRvOiBEcmV3ZWssIFdvamNpZWNoIDx3b2pjaWVjaC5kcmV3ZWtAaW50ZWwuY29t
Pg0KPiBDYzogaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IE1pY2hhbCBTd2lhdGtv
d3NraSA8bWljaGFsLnN3aWF0a293c2tpQGxpbnV4LmludGVsLmNvbT47IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtJbnRlbC13aXJlZC1sYW5dIFtQQVRDSCBpd2wtbmV4
dCB2MyAwOS8xMF0gaWNlOiBpbXBsZW1lbnQgc3RhdGljIHZlcnNpb24gb2YgYWdlaW5nDQo+IA0K
PiBEZWFyIFdvamNpZWNoLCBkZWFyIE1pY2hhbCwNCj4gDQo+IA0KPiBBbSAyMi4wNS4yMyB1bSAx
MTowNSBzY2hyaWViIFdvamNpZWNoIERyZXdlazoNCj4gPiBGcm9tOiBNaWNoYWwgU3dpYXRrb3dz
a2kgPG1pY2hhbC5zd2lhdGtvd3NraUBsaW51eC5pbnRlbC5jb20+DQo+ID4NCj4gPiBSZW1vdmUg
ZmRiIGVudHJpZXMgYWx3YXlzIHdoZW4gYWdlaW5nIHRpbWUgZXhwaXJlZC4NCj4gDQo+IFdoeSBp
cyB0aGF0IGEgZ29vZCB0aGluZyB0byBkbz8NCg0KSSBhZ3JlZSB0aGF0IGl0IGlzIG5vdCBhIGdv
b2Qgc29sdXRpb24uDQpGb3IgcHJvcGVyIGFnaW5nIHdlIHdvdWxkIG5lZWQgY291bnRlciBzdXBw
b3J0IGluIHN3IHdoaWNoIGlzIG5vdCBpbiBwbGFjZSB5ZXQuDQoNCj4gDQo+ID4gQWxsb3cgdXNl
ciB0byBzZXQgYWdlaW5nIHRpbWUgdXNpbmcgcG9ydCBvYmplY3QgYXR0cmlidXRlLg0KPiANCj4g
TWF5YmUgYWRkIHRoZSBjb21tZW50IGhvdyB0byBkbyBpdCB0b28/DQoNClN1cmUgdGhpbmcNCg0K
PiANCj4gDQo+IEtpbmQgcmVnYXJkcywNCj4gDQo+IFBhdWwNCj4gDQo+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IE1pY2hhbCBTd2lhdGtvd3NraSA8bWljaGFsLnN3aWF0a293c2tpQGxpbnV4LmludGVs
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXb2pjaWVjaCBEcmV3ZWsgPHdvamNpZWNoLmRyZXdl
a0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gdjI6IHVzZSBtc2Vjc190b19qaWZmaWVzIHVwb24g
ZGVmaW5pdGlvbiBvZg0KPiA+ICAgICAgSUNFX0VTV19CUklER0VfVVBEQVRFX0lOVEVSVkFMDQo+
ID4gLS0tDQo+ID4gICAuLi4vbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZXN3aXRjaF9ici5j
ICAgfCA0OCArKysrKysrKysrKysrKysrKysrDQo+ID4gICAuLi4vbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfZXN3aXRjaF9ici5oICAgfCAxMCArKysrDQo+ID4gICAyIGZpbGVzIGNoYW5nZWQs
IDU4IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9pY2UvaWNlX2Vzd2l0Y2hfYnIuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2ljZS9pY2VfZXN3aXRjaF9ici5jDQo+ID4gaW5kZXggNzQ4NTdkYTZiZTlmLi5hZjM0NjVi
OTY5OWMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9lc3dpdGNoX2JyLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2Uv
aWNlX2Vzd2l0Y2hfYnIuYw0KPiA+IEBAIC04LDYgKzgsOCBAQA0KPiA+ICAgI2luY2x1ZGUgImlj
ZV92bGFuLmgiDQo+ID4gICAjaW5jbHVkZSAiaWNlX3ZmX3ZzaV92bGFuX29wcy5oIg0KPiA+DQo+
ID4gKyNkZWZpbmUgSUNFX0VTV19CUklER0VfVVBEQVRFX0lOVEVSVkFMIG1zZWNzX3RvX2ppZmZp
ZXMoMTAwMCkNCj4gPiArDQo+ID4gICBzdGF0aWMgY29uc3Qgc3RydWN0IHJoYXNodGFibGVfcGFy
YW1zIGljZV9mZGJfaHRfcGFyYW1zID0gew0KPiA+ICAgCS5rZXlfb2Zmc2V0ID0gb2Zmc2V0b2Yo
c3RydWN0IGljZV9lc3dfYnJfZmRiX2VudHJ5LCBkYXRhKSwNCj4gPiAgIAkua2V5X2xlbiA9IHNp
emVvZihzdHJ1Y3QgaWNlX2Vzd19icl9mZGJfZGF0YSksDQo+ID4gQEAgLTQ0Myw2ICs0NDUsNyBA
QCBpY2VfZXN3aXRjaF9icl9mZGJfZW50cnlfY3JlYXRlKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRk
ZXYsDQo+ID4gICAJZmRiX2VudHJ5LT5icl9wb3J0ID0gYnJfcG9ydDsNCj4gPiAgIAlmZGJfZW50
cnktPmZsb3cgPSBmbG93Ow0KPiA+ICAgCWZkYl9lbnRyeS0+ZGV2ID0gbmV0ZGV2Ow0KPiA+ICsJ
ZmRiX2VudHJ5LT5sYXN0X3VzZSA9IGppZmZpZXM7DQo+ID4gICAJZXZlbnQgPSBTV0lUQ0hERVZf
RkRCX0FERF9UT19CUklER0U7DQo+ID4NCj4gPiAgIAlpZiAoYWRkZWRfYnlfdXNlcikgew0KPiA+
IEBAIC04MzYsNiArODM5LDEwIEBAIGljZV9lc3dpdGNoX2JyX3BvcnRfb2JqX2F0dHJfc2V0KHN0
cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsIGNvbnN0IHZvaWQgKmN0eCwNCj4gPiAgIAkJaWNlX2Vz
d2l0Y2hfYnJfdmxhbl9maWx0ZXJpbmdfc2V0KGJyX3BvcnQtPmJyaWRnZSwNCj4gPiAgIAkJCQkJ
CSAgYXR0ci0+dS52bGFuX2ZpbHRlcmluZyk7DQo+ID4gICAJCXJldHVybiAwOw0KPiA+ICsJY2Fz
ZSBTV0lUQ0hERVZfQVRUUl9JRF9CUklER0VfQUdFSU5HX1RJTUU6DQo+ID4gKwkJYnJfcG9ydC0+
YnJpZGdlLT5hZ2VpbmdfdGltZSA9DQo+ID4gKwkJCWNsb2NrX3RfdG9famlmZmllcyhhdHRyLT51
LmFnZWluZ190aW1lKTsNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiAgIAlkZWZhdWx0Og0KPiA+ICAg
CQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ID4gICAJfQ0KPiA+IEBAIC0xMDA3LDYgKzEwMTQsNyBA
QCBpY2VfZXN3aXRjaF9icl9pbml0KHN0cnVjdCBpY2VfZXN3X2JyX29mZmxvYWRzICpicl9vZmZs
b2FkcywgaW50IGlmaW5kZXgpDQo+ID4gICAJSU5JVF9MSVNUX0hFQUQoJmJyaWRnZS0+ZmRiX2xp
c3QpOw0KPiA+ICAgCWJyaWRnZS0+YnJfb2ZmbG9hZHMgPSBicl9vZmZsb2FkczsNCj4gPiAgIAli
cmlkZ2UtPmlmaW5kZXggPSBpZmluZGV4Ow0KPiA+ICsJYnJpZGdlLT5hZ2VpbmdfdGltZSA9IGNs
b2NrX3RfdG9famlmZmllcyhCUl9ERUZBVUxUX0FHRUlOR19USU1FKTsNCj4gPiAgIAl4YV9pbml0
KCZicmlkZ2UtPnBvcnRzKTsNCj4gPiAgIAlicl9vZmZsb2Fkcy0+YnJpZGdlID0gYnJpZGdlOw0K
PiA+DQo+ID4gQEAgLTEyMTAsNiArMTIxOCw3IEBAIGljZV9lc3dpdGNoX2JyX29mZmxvYWRzX2Rl
aW5pdChzdHJ1Y3QgaWNlX3BmICpwZikNCj4gPiAgIAlpZiAoIWJyX29mZmxvYWRzKQ0KPiA+ICAg
CQlyZXR1cm47DQo+ID4NCj4gPiArCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmYnJfb2ZmbG9h
ZHMtPnVwZGF0ZV93b3JrKTsNCj4gPiAgIAl1bnJlZ2lzdGVyX25ldGRldmljZV9ub3RpZmllcigm
YnJfb2ZmbG9hZHMtPm5ldGRldl9uYik7DQo+ID4gICAJdW5yZWdpc3Rlcl9zd2l0Y2hkZXZfYmxv
Y2tpbmdfbm90aWZpZXIoJmJyX29mZmxvYWRzLT5zd2l0Y2hkZXZfYmxrKTsNCj4gPiAgIAl1bnJl
Z2lzdGVyX3N3aXRjaGRldl9ub3RpZmllcigmYnJfb2ZmbG9hZHMtPnN3aXRjaGRldl9uYik7DQo+
ID4gQEAgLTEyMjQsNiArMTIzMyw0MCBAQCBpY2VfZXN3aXRjaF9icl9vZmZsb2Fkc19kZWluaXQo
c3RydWN0IGljZV9wZiAqcGYpDQo+ID4gICAJcnRubF91bmxvY2soKTsNCj4gPiAgIH0NCj4gPg0K
PiA+ICtzdGF0aWMgdm9pZCBpY2VfZXN3aXRjaF9icl91cGRhdGUoc3RydWN0IGljZV9lc3dfYnJf
b2ZmbG9hZHMgKmJyX29mZmxvYWRzKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgaWNlX2Vzd19iciAq
YnJpZGdlID0gYnJfb2ZmbG9hZHMtPmJyaWRnZTsNCj4gPiArCXN0cnVjdCBpY2VfZXN3X2JyX2Zk
Yl9lbnRyeSAqZW50cnksICp0bXA7DQo+ID4gKw0KPiA+ICsJaWYgKCFicmlkZ2UpDQo+ID4gKwkJ
cmV0dXJuOw0KPiA+ICsNCj4gPiArCXJ0bmxfbG9jaygpOw0KPiA+ICsJbGlzdF9mb3JfZWFjaF9l
bnRyeV9zYWZlKGVudHJ5LCB0bXAsICZicmlkZ2UtPmZkYl9saXN0LCBsaXN0KSB7DQo+ID4gKwkJ
aWYgKGVudHJ5LT5mbGFncyAmIElDRV9FU1dJVENIX0JSX0ZEQl9BRERFRF9CWV9VU0VSKQ0KPiA+
ICsJCQljb250aW51ZTsNCj4gPiArDQo+ID4gKwkJaWYgKHRpbWVfaXNfYWZ0ZXJfZXFfamlmZmll
cyhlbnRyeS0+bGFzdF91c2UgKw0KPiA+ICsJCQkJCSAgICAgYnJpZGdlLT5hZ2VpbmdfdGltZSkp
DQo+ID4gKwkJCWNvbnRpbnVlOw0KPiA+ICsNCj4gPiArCQlpY2VfZXN3aXRjaF9icl9mZGJfZW50
cnlfbm90aWZ5X2FuZF9jbGVhbnVwKGJyaWRnZSwgZW50cnkpOw0KPiA+ICsJfQ0KPiA+ICsJcnRu
bF91bmxvY2soKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIHZvaWQgaWNlX2Vzd2l0Y2hf
YnJfdXBkYXRlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiA+ICt7DQo+ID4gKwlz
dHJ1Y3QgaWNlX2Vzd19icl9vZmZsb2FkcyAqYnJfb2ZmbG9hZHM7DQo+ID4gKw0KPiA+ICsJYnJf
b2ZmbG9hZHMgPSBpY2Vfd29ya190b19icl9vZmZsb2Fkcyh3b3JrKTsNCj4gPiArDQo+ID4gKwlp
Y2VfZXN3aXRjaF9icl91cGRhdGUoYnJfb2ZmbG9hZHMpOw0KPiA+ICsNCj4gPiArCXF1ZXVlX2Rl
bGF5ZWRfd29yayhicl9vZmZsb2Fkcy0+d3EsICZicl9vZmZsb2Fkcy0+dXBkYXRlX3dvcmssDQo+
ID4gKwkJCSAgIElDRV9FU1dfQlJJREdFX1VQREFURV9JTlRFUlZBTCk7DQo+ID4gK30NCj4gPiAr
DQo+ID4gICBpbnQNCj4gPiAgIGljZV9lc3dpdGNoX2JyX29mZmxvYWRzX2luaXQoc3RydWN0IGlj
ZV9wZiAqcGYpDQo+ID4gICB7DQo+ID4gQEAgLTEyNzIsNiArMTMxNSwxMSBAQCBpY2VfZXN3aXRj
aF9icl9vZmZsb2Fkc19pbml0KHN0cnVjdCBpY2VfcGYgKnBmKQ0KPiA+ICAgCQlnb3RvIGVycl9y
ZWdfbmV0ZGV2X25iOw0KPiA+ICAgCX0NCj4gPg0KPiA+ICsJSU5JVF9ERUxBWUVEX1dPUksoJmJy
X29mZmxvYWRzLT51cGRhdGVfd29yaywNCj4gPiArCQkJICBpY2VfZXN3aXRjaF9icl91cGRhdGVf
d29yayk7DQo+ID4gKwlxdWV1ZV9kZWxheWVkX3dvcmsoYnJfb2ZmbG9hZHMtPndxLCAmYnJfb2Zm
bG9hZHMtPnVwZGF0ZV93b3JrLA0KPiA+ICsJCQkgICBJQ0VfRVNXX0JSSURHRV9VUERBVEVfSU5U
RVJWQUwpOw0KPiA+ICsNCj4gPiAgIAlyZXR1cm4gMDsNCj4gPg0KPiA+ICAgZXJyX3JlZ19uZXRk
ZXZfbmI6DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9p
Y2VfZXN3aXRjaF9ici5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9lc3dp
dGNoX2JyLmgNCj4gPiBpbmRleCA3MjMxNmJhOGZmNGQuLjkzYThjMjNhYTA4OSAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Vzd2l0Y2hfYnIuaA0K
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZXN3aXRjaF9ici5o
DQo+ID4gQEAgLTUsNiArNSw3IEBADQo+ID4gICAjZGVmaW5lIF9JQ0VfRVNXSVRDSF9CUl9IXw0K
PiA+DQo+ID4gICAjaW5jbHVkZSA8bGludXgvcmhhc2h0YWJsZS5oPg0KPiA+ICsjaW5jbHVkZSA8
bGludXgvd29ya3F1ZXVlLmg+DQo+ID4NCj4gPiAgIHN0cnVjdCBpY2VfZXN3X2JyX2ZkYl9kYXRh
IHsNCj4gPiAgIAl1bnNpZ25lZCBjaGFyIGFkZHJbRVRIX0FMRU5dOw0KPiA+IEBAIC0zMCw2ICsz
MSw4IEBAIHN0cnVjdCBpY2VfZXN3X2JyX2ZkYl9lbnRyeSB7DQo+ID4gICAJc3RydWN0IG5ldF9k
ZXZpY2UgKmRldjsNCj4gPiAgIAlzdHJ1Y3QgaWNlX2Vzd19icl9wb3J0ICpicl9wb3J0Ow0KPiA+
ICAgCXN0cnVjdCBpY2VfZXN3X2JyX2Zsb3cgKmZsb3c7DQo+ID4gKw0KPiA+ICsJdW5zaWduZWQg
bG9uZyBsYXN0X3VzZTsNCj4gPiAgIH07DQo+ID4NCj4gPiAgIGVudW0gaWNlX2Vzd19icl9wb3J0
X3R5cGUgew0KPiA+IEBAIC01OSw2ICs2Miw3IEBAIHN0cnVjdCBpY2VfZXN3X2JyIHsNCj4gPg0K
PiA+ICAgCWludCBpZmluZGV4Ow0KPiA+ICAgCXUzMiBmbGFnczsNCj4gPiArCXVuc2lnbmVkIGxv
bmcgYWdlaW5nX3RpbWU7DQo+ID4gICB9Ow0KPiA+DQo+ID4gICBzdHJ1Y3QgaWNlX2Vzd19icl9v
ZmZsb2FkcyB7DQo+ID4gQEAgLTY5LDYgKzczLDcgQEAgc3RydWN0IGljZV9lc3dfYnJfb2ZmbG9h
ZHMgew0KPiA+ICAgCXN0cnVjdCBub3RpZmllcl9ibG9jayBzd2l0Y2hkZXZfbmI7DQo+ID4NCj4g
PiAgIAlzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqd3E7DQo+ID4gKwlzdHJ1Y3QgZGVsYXllZF93
b3JrIHVwZGF0ZV93b3JrOw0KPiA+ICAgfTsNCj4gPg0KPiA+ICAgc3RydWN0IGljZV9lc3dfYnJf
ZmRiX3dvcmsgew0KPiA+IEBAIC04OSw2ICs5NCwxMSBAQCBzdHJ1Y3QgaWNlX2Vzd19icl92bGFu
IHsNCj4gPiAgIAkJICAgICBzdHJ1Y3QgaWNlX2Vzd19icl9vZmZsb2FkcywgXA0KPiA+ICAgCQkg
ICAgIG5iX25hbWUpDQo+ID4NCj4gPiArI2RlZmluZSBpY2Vfd29ya190b19icl9vZmZsb2Fkcyh3
KSBcDQo+ID4gKwljb250YWluZXJfb2YodywgXA0KPiA+ICsJCSAgICAgc3RydWN0IGljZV9lc3df
YnJfb2ZmbG9hZHMsIFwNCj4gPiArCQkgICAgIHVwZGF0ZV93b3JrLndvcmspDQo+ID4gKw0KPiA+
ICAgI2RlZmluZSBpY2Vfd29ya190b19mZGJfd29yayh3KSBcDQo+ID4gICAJY29udGFpbmVyX29m
KHcsIFwNCj4gPiAgIAkJICAgICBzdHJ1Y3QgaWNlX2Vzd19icl9mZGJfd29yaywgXA0K

