Return-Path: <netdev+bounces-8553-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAD99724868
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BB3A1C20A87
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F33A30B83;
	Tue,  6 Jun 2023 16:01:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A17537B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:01:37 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6F5118
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686067295; x=1717603295;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hw9FGv0A/zuh3smZ1tpCC/RlPwqrL0Jc/ncewwdtduM=;
  b=PRJaJxpOBLvGdlbwCpCx2Q7G6HODN2Sz1e//8XVz3YRp5AduSDbfnLzF
   SrLtZPC0EjEATUkmG9Q5KX/NvyhVI6HcYslQlLIMBB6e4OkYHQe2nEsK/
   MQsfBBBonO2IxWt9AW1bHNpbHiY0MlkpG2hnSoEjMNsZOZRLDdsvbcPps
   2Tjq4Ul6EDQzC7aCpuAAclNLiI2GupH6NBK4dYbkn2ow8I/dFzPTwUD8D
   Co/VtJNgHVWngqx1VjqK9WfM6xVlAfcuCVT9T22B7rJPASefkyQ+sTyN9
   cd9XXGEn0ahzHrt+rxmbG2EL9HIQ9TejOWORHpAJ+5xHtwSvasJAHUMWh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="420263985"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="420263985"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 09:01:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="955821833"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="955821833"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 06 Jun 2023 09:01:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 09:01:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 09:01:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 09:01:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TK9FKcNsKFmB7p2mxg9TOhWehg7j5uM00lqyJU+91d0BmM6oys+T8kC7Pv7ZtJKYhDTXsXqBBCBQ/6zV2na8AYTVxnkDkTmDuCCeKT5gtr+M1YEYxNYpWgqpNM1ydJkCSFLwvgT0BUZsYns8BU2vbZwU/FPC11L7jfb2PTpu7Ur53h5mCAsvhLXuorl1ZgC9hAs1S9r1tIe/NwUskC4WukJzqiiy7TefwpWOvXhoVFVNQIjPAd2it/cGfk3UCSEpNrhxQ5RpQjeEt4sFCXBalNkMBaXI0SO7Cfiw4LjglDwVMD4RIYInwRyqFk7avi+Xe2RQ3ryHvxvBRwy4PW+aUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hw9FGv0A/zuh3smZ1tpCC/RlPwqrL0Jc/ncewwdtduM=;
 b=TsL8xoWPMRqBugoju/shjJe155VNPcjyWZIJXWPClm+MFg01TPqEe11qB4RjDNx6JW0UvMx4vZPLkXB5wjn+9EkDC+3giktLdT2u1PH5x0pXValxX/Pfvwv/ErE6iOjJO8yS7LY3071LKI+1HIZ2J8XYwh5IfrlV1N2AE7iMrwbbPw+YKzv9KQmsBRhvexc84EIDQpDAE/eN7XbntGgOA8O2pFn/HU5o0Db0CGweBey1sD/I125IaiUGU75GEhkRUA+iO08XKBzcsxI+VS48a/ko2/DULRjqOHsaElcHfgMovm7KeHg2k4RqaCwRv8oxEabg5NbIQGijyhNxrl2ukA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3521.namprd11.prod.outlook.com (2603:10b6:208:7b::32)
 by MW6PR11MB8340.namprd11.prod.outlook.com (2603:10b6:303:23e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 16:01:14 +0000
Received: from BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::2134:60a2:3968:7298]) by BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::2134:60a2:3968:7298%2]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 16:01:14 +0000
From: "Romanowski, Rafal" <rafal.romanowski@intel.com>
To: "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"edumazet@google.com" <edumazet@google.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Zaki, Ahmed" <ahmed.zaki@intel.com>, "Fijalkowski,
 Maciej" <maciej.fijalkowski@intel.com>
Subject: RE: [PATCH net-next 3/3] iavf: remove mask from
 iavf_irq_enable_queues()
Thread-Topic: [PATCH net-next 3/3] iavf: remove mask from
 iavf_irq_enable_queues()
Thread-Index: AQHZlXYqS1s4j6aPNkOckTIR8rS7R698nAkAgAAIxACAAPMPgIAAUsgAgAAKYmA=
Date: Tue, 6 Jun 2023 16:01:14 +0000
Message-ID: <BL0PR11MB35215833AE25272273FE1C9C8F52A@BL0PR11MB3521.namprd11.prod.outlook.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-4-anthony.l.nguyen@intel.com> <ZH42phazuTdyiNTm@boxer>
 <9b4c8cfb-f880-d1a0-7be9-c5e4833f3844@intel.com> <ZH8J5ZypMeSESSZd@boxer>
 <7e80c3ba-38ca-eda7-45eb-ff67628e7357@intel.com>
In-Reply-To: <7e80c3ba-38ca-eda7-45eb-ff67628e7357@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3521:EE_|MW6PR11MB8340:EE_
x-ms-office365-filtering-correlation-id: d9af6884-f516-4f7d-3648-08db66a74131
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n+Hmp5zc4mFS1laKQwJfThIBOgGQeq/LtEDFXnqGznQhEgmcPz5zfLNKjO/kgAtTXgB+7iXfC3M0qiClRCXPWVQmV8JrDGVk/7+x6WxCKaw5Iw/cVwjP89QCrMlT/hjwdljEw9sG5VBD3M8auKG/Y6J/u9YRxNL0Q3X26EwNeG+XjEp837gioTAs3qYQcbG1lyjZ5W49xQH3RJywaOBnvXopF8A14F7N06H/ehRbQdZNy8mqv96wwKJ+zmW4dx7sJs2+7S8+DYgJJRsUv3vy2yrrsP3BMU/+bDBJ34ms3WhbvxB/xNGHOt09OtAtnEr1t/zQ0I8Z3n8b23WNa9cDr9dzqXGd6ejMHlKhIyWcCD2Qk70ZzvHeBQIrFhSDS6dSwwRrl5sF941+hudsNeEWnDd4L737DxtC7yK8RN17ORPvYceSJt6XHU3U7SC0vNYBgR5Gi2viT4ZnygIyz1A522LpJ51KKjB3o8SfEOqzH3VMjG682xZ9PdnMEMmdCzKyZ0kI9v7Hgkd5Fqx+lvATmtXG4795vmIK6YcFrx27llpI6eLR5i9hvClay8SvflWHSMYRwgfgVxRMSwWZ/YepUmaPBgNLXerAKko6QD7CQ/nASWHWUVmmAGE232Tyd8FhNQZOG7NbAYebDf800JjN6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199021)(53546011)(107886003)(9686003)(6506007)(38100700002)(41300700001)(7696005)(26005)(186003)(966005)(83380400001)(71200400001)(478600001)(54906003)(122000001)(66446008)(6636002)(66556008)(64756008)(66476007)(55016003)(76116006)(66946007)(316002)(82960400001)(4326008)(5660300002)(8676002)(52536014)(8936002)(2906002)(33656002)(86362001)(38070700005)(6862004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emlNQnp2REhSaThUOGFLQ1Z0WnMxUnZreW1tdVFMZ0VPYVYwZTRPZ1QxMEpk?=
 =?utf-8?B?UDMxM2s1L1VCc2xlcTlVQW9sZ3liZ2xTbTliN0lQL0FjaGM5QXNQajJkN3FE?=
 =?utf-8?B?N1hOY2ZuUFByeUdGWllPNlRwQlhVQVBIbmxvWU4wQVRCT0tEUkY3VU93citS?=
 =?utf-8?B?K2JLR0pOZHE5aXVLY09JSFpqQUxlRHdJQ050UnNJQjhldnpIMnlaK2xNb0Jx?=
 =?utf-8?B?d2xPWTRBZlR0YjcweVBqZlhKQVB5UDVGdkZyM2tnSXFoWWRKRjFCVm5uSHpr?=
 =?utf-8?B?RlRaVFVaRTN3dnZHMmRRZUFkWnZzcG1aRUR3WGJJK1A1dyt2Mm8zQVo0WEJK?=
 =?utf-8?B?c3BLd3NnNURYQXBMYmVUTTduRFA1Uzh0RVJTT2tVZnlUY1RmMVJhVkJNRWdW?=
 =?utf-8?B?MWFGNDNRSnpXNlVIMGZKWkRTVW8zRlg0K2Y3QUxuTVBnNGxpSkhlZFVrWEIv?=
 =?utf-8?B?V3VoSlllWGJUaDNITDdjbXREcHJWV3lmUjNrbmcwVnB3OUhJM3ZId1hQZFph?=
 =?utf-8?B?SzV4bUpGNHpZSmtVSndtMnJZcnB1d3JBQ3JlRzJJbXRiUExLZUtjNXloamhB?=
 =?utf-8?B?TmsxZTFkL3YvQkRJUWlmQ3lBQ2FJamZTN20zTitzNU1sQ2FnR2J4MXlUMEpo?=
 =?utf-8?B?VVhGcTZ3czFIZFdPamE1MXg1VjgxS3BrWlNQMlNFSHhTeHozZnBXbUJlTHFk?=
 =?utf-8?B?T1c3c3R2SEpFNzVBNkMwM3hvQWpOSGxyYXdaVEJUVllveVFVWllBOWI5Q1Zu?=
 =?utf-8?B?N1BZMWpBT1Q0TUxWYXQ3aU45MUtYc0szOFVKZlQ1bGtOV2dvSHJlS1JpWFFo?=
 =?utf-8?B?aUVicW1Pd1FPWnZ5K2ZCcFE4dFFJZXNjL2RjMFZydjRvWlFWTm9jQWNQUmFm?=
 =?utf-8?B?WjdZQ2lYQjlicVdaRFNKc0dUUG9nR0xUdkh2cUZzTGNDV2RmUkpHU1djNndK?=
 =?utf-8?B?OGNwSUR6NnY2NzZ5WkFMTi8vUkN0cEx3ZnFjN0oxYndlR0lUd2w2amVDMzA1?=
 =?utf-8?B?bUFFN08ya3Y5MzU5VUdVSjBSNTJDTFNqNHNLb29MUnpETlYrTnUweUovMnZH?=
 =?utf-8?B?d1lidUVqb3VqamhYMTRLODVMODhDb3J5QjlhMStXOE4vbzFJeEc1SWRybFdR?=
 =?utf-8?B?MGZSQTR2UDV2N0wvZTE0UStsbmdCd2FZSVdHNUQxM3A0RWNVeEh5ampYT2ho?=
 =?utf-8?B?aEo2Vmh2bXlaVHN5cjdmTDlDclh0TkdqR2JyM25ZdkdKK1VYcXlCRkk4a3Rw?=
 =?utf-8?B?OGZlMXd6N3RRVUFtYm5qV2JXRTRYcm5FWTNKcDNwcWRxTTFsV25lRGh1anVR?=
 =?utf-8?B?R0xsVVdKVUFyL2pyeXhvWkdTS2FvZFlpUjJrVDVqUkU5MmtTcXhZVEt3RDQ4?=
 =?utf-8?B?R0MrVlBxajBxckEvbXAvS2JLem9sSFNVand1bFl3d0ZJSjNMQmdvQm1kQ3hX?=
 =?utf-8?B?T3BNTGhiWERiM1p0RWpJamRCUldnQmpjbXZDRmdFT2NvRVZWVVBrZkRDUnVI?=
 =?utf-8?B?Q3BrN0Erd0VSbWcxaFIyZy80bEx3dmxoN2R3SDI2d3Z0Y1hMaWh2WnVIbE9I?=
 =?utf-8?B?R3VBa3hrUms1bnZ0YWZySVVpdzI0UXZzdjFWaHNLeG5GeGNCRGtTN1YwN3lu?=
 =?utf-8?B?eE0yMmxhNCtyS3RiMGFlUFkrZTN4R1k5UlY1NFFpYlM4dVZSMFpGWUt4Ym5x?=
 =?utf-8?B?UUFiUTdTbXhzNW5icGIrVGRWam9sZ09DVGd4YjJRcUFEeFRWSVlYSjVoM0Mz?=
 =?utf-8?B?TGdtclFkQ2R3cmJTYStBY3B3T3NUREtUTk5EZzFhaWJIUFVQUzhyeExIVTUy?=
 =?utf-8?B?TVdhdXdSbjRoUzZPbWo3NHBOc1ZBWHBtNHZhTlBjeEdnOFpqZHpyVDFvT3Jh?=
 =?utf-8?B?MFpwQnVFcW1KKzE3MjRlVWliTkRSeWRORzhqQ0ZCNDAydVI5RGRmYVhsQnA3?=
 =?utf-8?B?emR2ZkdyTEdHQXdnbTdRdG1YSFhzS2ZaMFJkYWFpV25JK2NBTE1TMHFEQ1Qy?=
 =?utf-8?B?cFhZUVBYeUJOUE0wbFhBZzI3TnFPZVRtN09xWmdWa1lSbUg1OW9PZHcwRWdl?=
 =?utf-8?B?S3pOelEwVkVBVmV1QlNvU1ZXc21MZytRZTlPbEd2WG1nNktjVHVSMXhxSCt4?=
 =?utf-8?B?Ym1qeDdnNHhZY0VpeENLVEhSMkprdFVNL1JJYzVaVEpBTHQvZ2c0M3UrSkln?=
 =?utf-8?B?S2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9af6884-f516-4f7d-3648-08db66a74131
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 16:01:14.1996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ZblSV/jpiV1KMcDHWQNakKHB++Z7d56ql6dBsUdDgkMkvCroc9lKcZKWPypZuQDDuRhvhvb0rS2wvONxRRhMzTbtyTdZw9gqKXaOW743kU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8340
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBaYWtpLCBBaG1lZCA8YWhtZWQu
emFraUBpbnRlbC5jb20+DQo+IFNlbnQ6IHd0b3JlaywgNiBjemVyd2NhIDIwMjMgMTc6MjMNCj4g
VG86IEZpamFsa293c2tpLCBNYWNpZWogPG1hY2llai5maWphbGtvd3NraUBpbnRlbC5jb20+DQo+
IENjOiBOZ3V5ZW4sIEFudGhvbnkgTCA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+Ow0KPiBk
YXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0K
PiBlZHVtYXpldEBnb29nbGUuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBSb21hbm93c2tp
LCBSYWZhbA0KPiA8cmFmYWwucm9tYW5vd3NraUBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgMy8zXSBpYXZmOiByZW1vdmUgbWFzayBmcm9tDQo+IGlhdmZfaXJxX2Vu
YWJsZV9xdWV1ZXMoKQ0KPiANCj4gDQo+IE9uIDIwMjMtMDYtMDYgMDQ6MjYsIE1hY2llaiBGaWph
bGtvd3NraSB3cm90ZToNCj4gPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAwMTo1Njo0OFBNIC0w
NjAwLCBBaG1lZCBaYWtpIHdyb3RlOg0KPiA+PiBPbiAyMDIzLTA2LTA1IDEzOjI1LCBNYWNpZWog
RmlqYWxrb3dza2kgd3JvdGU6DQo+ID4+PiBPbiBGcmksIEp1biAwMiwgMjAyMyBhdCAxMDoxMzow
MkFNIC0wNzAwLCBUb255IE5ndXllbiB3cm90ZToNCj4gPj4+PiBGcm9tOiBBaG1lZCBaYWtpIDxh
aG1lZC56YWtpQGludGVsLmNvbT4NCj4gPj4+Pg0KPiA+Pj4+IEVuYWJsZSBtb3JlIHRoYW4gMzIg
SVJRcyBieSByZW1vdmluZyB0aGUgdTMyIGJpdCBtYXNrIGluDQo+ID4+Pj4gaWF2Zl9pcnFfZW5h
YmxlX3F1ZXVlcygpLiBUaGVyZSBpcyBubyBuZWVkIGZvciB0aGUgbWFzayBhcyB0aGVyZQ0KPiA+
Pj4+IGFyZSBubyBjYWxsZXJzIHRoYXQgc2VsZWN0IGluZGl2aWR1YWwgSVJRcyB0aHJvdWdoIHRo
ZSBiaXRtYXNrLg0KPiA+Pj4+IEFsc28sIGlmIHRoZSBQRiBhbGxvY2F0ZXMgbW9yZSB0aGFuIDMy
IElSUXMsIHRoaXMgbWFzayB3aWxsIHByZXZlbnQNCj4gPj4+PiB1cyBmcm9tIHVzaW5nIGFsbCBv
ZiB0aGVtLg0KPiA+Pj4+DQo+ID4+Pj4gVGhlIGNvbW1lbnQgaW4gaWF2Zl9yZWdpc3Rlci5oIGlz
IG1vZGlmaWVkIHRvIHNob3cgdGhhdCB0aGUgbWF4aW11bQ0KPiA+Pj4+IG51bWJlciBhbGxvd2Vk
IGZvciB0aGUgSVJRIGluZGV4IGlzIDYzIGFzIHBlciB0aGUgaUFWRiBzdGFuZGFyZCAxLjAgWzFd
Lg0KPiA+Pj4gcGxlYXNlIHVzZSBpbXBlcmF0aXZlIG1vb2Q6DQo+ID4+PiAibW9kaWZ5IHRoZSBj
b21tZW50IGluLi4uIg0KPiA+Pj4NCj4gPj4+IGJlc2lkZXMsIGl0IHNvdW5kcyB0byBtZSBsaWtl
IGEgYnVnLCB3ZSB3ZXJlIG5vdCBmb2xsb3dpbmcgdGhlIHNwZWMsIG5vPw0KPiA+PiB5ZXMsIGJ1
dCBhbGwgUEYncyB3ZXJlIGFsbG9jYXRpbmfCoCA8PSAxNiBJUlFzLCBzbyBpdCB3YXMgbm90IGNh
dXNpbmcNCj4gPj4gYW55IGlzc3Vlcy4NCj4gPj4NCj4gPj4NCj4gPj4+PiBsaW5rOiBbMV0NCj4g
Pj4+Pg0KPiBodHRwczovL3d3dy5pbnRlbC5jb20vY29udGVudC9kYW0vd3d3L3B1YmxpYy91cy9l
bi9kb2N1bWVudHMvcHJvZHUNCj4gYw0KPiA+Pj4+IHQtc3BlY2lmaWNhdGlvbnMvZXRoZXJuZXQt
YWRhcHRpdmUtdmlydHVhbC1mdW5jdGlvbi1oYXJkd2FyZS1zcGVjLnANCj4gPj4+PiBkZg0KPiA+
Pj4+IFNpZ25lZC1vZmYtYnk6IEFobWVkIFpha2kgPGFobWVkLnpha2lAaW50ZWwuY29tPg0KPiA+
Pj4+IFRlc3RlZC1ieTogUmFmYWwgUm9tYW5vd3NraSA8cmFmYWwucm9tYW5vd3NraUBpbnRlbC5j
b20+DQo+ID4+Pj4gU2lnbmVkLW9mZi1ieTogVG9ueSBOZ3V5ZW4gPGFudGhvbnkubC5uZ3V5ZW5A
aW50ZWwuY29tPg0KPiA+Pj4gUmV2aWV3ZWQtYnk6IE1hY2llaiBGaWphbGtvd3NraSA8bWFjaWVq
LmZpamFsa293c2tpQGludGVsLmNvbT4NCj4gPj4+DQo+ID4+Pj4gLS0tDQo+ID4+Pj4gICAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWF2Zi9pYXZmLmggICAgICAgICAgfCAgMiArLQ0KPiA+
Pj4+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lhdmYvaWF2Zl9tYWluLmMgICAgIHwg
MTUgKysrKysrLS0tLS0tLS0tDQo+ID4+Pj4gICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWF2Zi9pYXZmX3JlZ2lzdGVyLmggfCAgMiArLQ0KPiA+Pj4+ICAgIDMgZmlsZXMgY2hhbmdlZCwg
OCBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCj4gPj4+Pg0KPiA+Pj4+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pYXZmL2lhdmYuaA0KPiA+Pj4+IGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWF2Zi9pYXZmLmgNCj4gPj4+PiBpbmRleCA5YWJhZmYx
ZjJhZmYuLjM5ZDBmZTc2YTM4ZiAxMDA2NDQNCj4gPj4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9pYXZmL2lhdmYuaA0KPiA+Pj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2lhdmYvaWF2Zi5oDQo+ID4+Pj4gQEAgLTUyNSw3ICs1MjUsNyBAQCB2b2lkIGlhdmZf
c2V0X2V0aHRvb2xfb3BzKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpuZXRkZXYpOw0KPiA+Pj4+ICAg
IHZvaWQgaWF2Zl91cGRhdGVfc3RhdHMoc3RydWN0IGlhdmZfYWRhcHRlciAqYWRhcHRlcik7DQo+
ID4+Pj4gICAgdm9pZCBpYXZmX3Jlc2V0X2ludGVycnVwdF9jYXBhYmlsaXR5KHN0cnVjdCBpYXZm
X2FkYXB0ZXIgKmFkYXB0ZXIpOw0KPiA+Pj4+ICAgIGludCBpYXZmX2luaXRfaW50ZXJydXB0X3Nj
aGVtZShzdHJ1Y3QgaWF2Zl9hZGFwdGVyICphZGFwdGVyKTsNCj4gPj4+PiAtdm9pZCBpYXZmX2ly
cV9lbmFibGVfcXVldWVzKHN0cnVjdCBpYXZmX2FkYXB0ZXIgKmFkYXB0ZXIsIHUzMg0KPiA+Pj4+
IG1hc2spOw0KPiA+Pj4+ICt2b2lkIGlhdmZfaXJxX2VuYWJsZV9xdWV1ZXMoc3RydWN0IGlhdmZf
YWRhcHRlciAqYWRhcHRlcik7DQo+ID4+Pj4gICAgdm9pZCBpYXZmX2ZyZWVfYWxsX3R4X3Jlc291
cmNlcyhzdHJ1Y3QgaWF2Zl9hZGFwdGVyICphZGFwdGVyKTsNCj4gPj4+PiAgICB2b2lkIGlhdmZf
ZnJlZV9hbGxfcnhfcmVzb3VyY2VzKHN0cnVjdCBpYXZmX2FkYXB0ZXIgKmFkYXB0ZXIpOw0KPiA+
Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pYXZmL2lhdmZfbWFp
bi5jDQo+ID4+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pYXZmL2lhdmZfbWFpbi5j
DQo+ID4+Pj4gaW5kZXggM2E3OGY4NmJhNGY5Li4xMzMyNjMzZjBjYTUgMTAwNjQ0DQo+ID4+Pj4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWF2Zi9pYXZmX21haW4uYw0KPiA+Pj4+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lhdmYvaWF2Zl9tYWluLmMNCj4gPj4+
PiBAQCAtMzU5LDIxICszNTksMTggQEAgc3RhdGljIHZvaWQgaWF2Zl9pcnFfZGlzYWJsZShzdHJ1
Y3QNCj4gaWF2Zl9hZGFwdGVyICphZGFwdGVyKQ0KPiA+Pj4+ICAgIH0NCj4gPj4+PiAgICAvKioN
Cj4gPj4+PiAtICogaWF2Zl9pcnFfZW5hYmxlX3F1ZXVlcyAtIEVuYWJsZSBpbnRlcnJ1cHQgZm9y
IHNwZWNpZmllZCBxdWV1ZXMNCj4gPj4+PiArICogaWF2Zl9pcnFfZW5hYmxlX3F1ZXVlcyAtIEVu
YWJsZSBpbnRlcnJ1cHQgZm9yIGFsbCBxdWV1ZXMNCj4gPj4+PiAgICAgKiBAYWRhcHRlcjogYm9h
cmQgcHJpdmF0ZSBzdHJ1Y3R1cmUNCj4gPj4+PiAtICogQG1hc2s6IGJpdG1hcCBvZiBxdWV1ZXMg
dG8gZW5hYmxlDQo+ID4+Pj4gICAgICoqLw0KPiA+Pj4+IC12b2lkIGlhdmZfaXJxX2VuYWJsZV9x
dWV1ZXMoc3RydWN0IGlhdmZfYWRhcHRlciAqYWRhcHRlciwgdTMyDQo+ID4+Pj4gbWFzaykNCj4g
Pj4+PiArdm9pZCBpYXZmX2lycV9lbmFibGVfcXVldWVzKHN0cnVjdCBpYXZmX2FkYXB0ZXIgKmFk
YXB0ZXIpDQo+ID4+Pj4gICAgew0KPiA+Pj4+ICAgIAlzdHJ1Y3QgaWF2Zl9odyAqaHcgPSAmYWRh
cHRlci0+aHc7DQo+ID4+Pj4gICAgCWludCBpOw0KPiA+Pj4+ICAgIAlmb3IgKGkgPSAxOyBpIDwg
YWRhcHRlci0+bnVtX21zaXhfdmVjdG9yczsgaSsrKSB7DQo+ID4+Pj4gLQkJaWYgKG1hc2sgJiBC
SVQoaSAtIDEpKSB7DQo+ID4+Pj4gLQkJCXdyMzIoaHcsIElBVkZfVkZJTlRfRFlOX0NUTE4xKGkg
LSAxKSwNCj4gPj4+PiAtCQkJICAgICBJQVZGX1ZGSU5UX0RZTl9DVExOMV9JTlRFTkFfTUFTSyB8
DQo+ID4+Pj4gLQkJCSAgICAgSUFWRl9WRklOVF9EWU5fQ1RMTjFfSVRSX0lORFhfTUFTSyk7DQo+
ID4+Pj4gLQkJfQ0KPiA+Pj4+ICsJCXdyMzIoaHcsIElBVkZfVkZJTlRfRFlOX0NUTE4xKGkgLSAx
KSwNCj4gPj4+PiArCQkgICAgIElBVkZfVkZJTlRfRFlOX0NUTE4xX0lOVEVOQV9NQVNLIHwNCj4g
Pj4+PiArCQkgICAgIElBVkZfVkZJTlRfRFlOX0NUTE4xX0lUUl9JTkRYX01BU0spOw0KPiA+Pj4+
ICAgIAl9DQo+ID4+Pj4gICAgfQ0KPiA+Pj4+IEBAIC0zODcsNyArMzg0LDcgQEAgdm9pZCBpYXZm
X2lycV9lbmFibGUoc3RydWN0IGlhdmZfYWRhcHRlcg0KPiAqYWRhcHRlciwgYm9vbCBmbHVzaCkN
Cj4gPj4+PiAgICAJc3RydWN0IGlhdmZfaHcgKmh3ID0gJmFkYXB0ZXItPmh3Ow0KPiA+Pj4+ICAg
IAlpYXZmX21pc2NfaXJxX2VuYWJsZShhZGFwdGVyKTsNCj4gPj4+PiAtCWlhdmZfaXJxX2VuYWJs
ZV9xdWV1ZXMoYWRhcHRlciwgfjApOw0KPiA+Pj4+ICsJaWF2Zl9pcnFfZW5hYmxlX3F1ZXVlcyhh
ZGFwdGVyKTsNCj4gPj4+PiAgICAJaWYgKGZsdXNoKQ0KPiA+Pj4+ICAgIAkJaWF2Zl9mbHVzaCho
dyk7DQo+ID4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lhdmYv
aWF2Zl9yZWdpc3Rlci5oDQo+ID4+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pYXZm
L2lhdmZfcmVnaXN0ZXIuaA0KPiA+Pj4+IGluZGV4IGJmNzkzMzMyZmM5ZC4uYTE5ZTg4ODk4YTBi
IDEwMDY0NA0KPiA+Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lhdmYvaWF2
Zl9yZWdpc3Rlci5oDQo+ID4+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWF2
Zi9pYXZmX3JlZ2lzdGVyLmgNCj4gPj4+PiBAQCAtNDAsNyArNDAsNyBAQA0KPiA+Pj4+ICAgICNk
ZWZpbmUgSUFWRl9WRklOVF9EWU5fQ1RMMDFfSU5URU5BX01BU0sgSUFWRl9NQVNLKDB4MSwNCj4g
SUFWRl9WRklOVF9EWU5fQ1RMMDFfSU5URU5BX1NISUZUKQ0KPiA+Pj4+ICAgICNkZWZpbmUgSUFW
Rl9WRklOVF9EWU5fQ1RMMDFfSVRSX0lORFhfU0hJRlQgMw0KPiA+Pj4+ICAgICNkZWZpbmUgSUFW
Rl9WRklOVF9EWU5fQ1RMMDFfSVRSX0lORFhfTUFTSyBJQVZGX01BU0soMHgzLA0KPiA+Pj4+IElB
VkZfVkZJTlRfRFlOX0NUTDAxX0lUUl9JTkRYX1NISUZUKQ0KPiA+Pj4+IC0jZGVmaW5lIElBVkZf
VkZJTlRfRFlOX0NUTE4xKF9JTlRWRikgKDB4MDAwMDM4MDAgKyAoKF9JTlRWRikgKg0KPiA0KSkN
Cj4gPj4+PiAvKiBfaT0wLi4uMTUgKi8gLyogUmVzZXQ6IFZGUiAqLw0KPiA+Pj4gc28gdGhpcyB3
YXMgd3JvbmcgZXZlbiBiZWZvcmUgYXMgbm90IGluZGljYXRpbmcgMzEgYXMgbWF4Pw0KPiA+PiBD
b3JyZWN0LCBidXQgYWdhaW4gbm8gaXNzdWVzLg0KPiA+Pg0KPiA+PiBHaXZlbiB0aGF0LCBzaG91
bGQgSSByZS1zZW5kIHRvIG5ldCA/DQo+ID4gcHJvYmFibHkgd2l0aCBvbGRlciBrZXJuZWxzIFBG
cyB3b3VsZCBzdGlsbCBiZSBhbGxvY2F0aW5nIDw9IDE2IGlycXMsDQo+ID4gcmlnaHQ/IG5vdCBz
dXJlIGlmIG9uZSBjb3VsZCB0YWtlIGEgUEYgYW5kIGhhY2sgaXQgdG8gcmVxdWVzdCBmb3IgbW9y
ZQ0KPiA+IHRoYW4gMzIgaXJxcyBhbmQgdGhlbiBoaXQgdGhlIHdhbGwgd2l0aCB0aGUgbWFzayB5
b3UncmUgcmVtb3ZpbmcuDQo+ID4NCj4gVW5saWtlbHkgc2luY2UgdGhlIFZGIGN1cnJlbnRseSBu
ZXZlciByZXF1ZXN0cyBtb3JlIHRoYW4gMTYgcXVldWVzLCBzbyBhbnkNCj4gSVJRcyA+IDE2IGFy
ZSB1c2VsZXNzLg0KPiANCj4gVGhlICJmaXgiIGlzIG5lZWRlZCBmb3IgYW5vdGhlciBwYXRjaCB0
aGF0IHdpbGwgZW5hYmxlIHVwIHRvIDI1NiBxdWV1ZXMNCj4gdGhvdWdoLg0KDQpXZSBkb24ndCBz
ZWUgdGhpcyBwYXRjaCBpbiBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL2J1bmRsZS9hbmd1
eTExL1ZpcnR1YWxpemF0aW9uLw0KDQoNCkJlc3QgUmVnYXJkcywNClJhZmFsIFJvbWFub3dza2kN
Ck5DTkcgU1cNCg0KDQo=

