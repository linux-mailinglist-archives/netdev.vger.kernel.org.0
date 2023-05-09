Return-Path: <netdev+bounces-1100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 797936FC2DD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 988411C20AF2
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAA1AD38;
	Tue,  9 May 2023 09:34:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F678BE1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:34:12 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0E6E713
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683624838; x=1715160838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lu+9CC+u3O0IO+U6R7N1ZiKdCqirHxQ5KjuxOTjAW2Q=;
  b=EMVa4AEh+EA4q1/zuOViZacr1l27EXmGk58r9lYE5OVzgnp/7ubEvvMe
   8nZJTAhwnaDkWCRyDrZdxPH2Ezw1R1eJRWM7rj2ylCZEI4BsrIJE1lZp8
   vCDqiCdXhM1mU8x2FwjtOZ2Ubo+sjkm7b84OnNC3wWQH2NhMTXVqOfGoZ
   S4FRzJqmrWWf4S02GHW0uEckPw8dH60ODICI/AiQr1+nIIyuzU/zJ1Q6w
   z4NDj6XhR+FIZOsBx+y/EgBgNBFKa0iPHGCnUINhzWS1aoCPWJUS4FQaQ
   OnllCA3docpTqO1HpxYw/aywtYB+zc2L1nHMJuBKXzVDaqfANmyw/2zsh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="348702540"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="348702540"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 02:33:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="692915328"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="692915328"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 09 May 2023 02:33:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 02:33:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 02:33:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 02:33:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 02:33:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYassPk3JUOapZEFHbAiAiwaRgjtv5SI5XeG0YUukHZhTCDmTztKwMKT6qooc7YKCyJywlaYFgmoFUAwByOYBnTvMD3qYHoMVBYACVJCMzFTsmglIiW/ZORtwC/ZU2RdJExNfGGEgPM63z5vlVJMGMlG5ayU8z7YlpW/nAB3intX/inEFAOLW5+ip0sPNyGcVg9g0qO/wmDLycmZHdLWcHoASB4TXjGXART0lvHyDWpc7wlEh+tDMHOXRbLhcOvx8vwb0xCTVFaVx6+8lEedZif5Alo4Ejzh/5nHZxxZBqkFc3h8Bkx6sGzoCgGvYyOgxCIx7LWIhaiISA8q5yGlPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lu+9CC+u3O0IO+U6R7N1ZiKdCqirHxQ5KjuxOTjAW2Q=;
 b=b2bIdG/fl4U9lA08lXIfNVh2igg48wwwzwKXoph9tQcD2Q29w0stsp1QVK2qpFOxYx2eDhely7cCaGVkN5jXIOSQpD1DhStX6s7kZ+ttfQ1e3UfI/DfNtG+2Q+CMrIGLJm5IjaZVYuIIa56uWGP+sN2X1E/3FubgvegeOcRf3kQfrRe8ndJMvs2SgFZlX53VfsdFG3/JeDXOwKfVE9XF8ryROp1eVnf8wJznlYdCpMUt5cz3qRJQ5mlxnKIZ9IVmRLow6o/zkUhs90MfZrXL1U5lJSCinGcoZF0TtM0G4bOwZ0c3OtrsgnYi3gkCgyz9ewRZu0OYK+hlQMJSfyHHCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by PH7PR11MB7049.namprd11.prod.outlook.com (2603:10b6:510:20c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 09:33:53 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 09:33:53 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Eric Dumazet <edumazet@google.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg,
 Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Shakeel Butt <shakeelb@google.com>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69Ro4qAgAAGGAA=
Date: Tue, 9 May 2023 09:33:52 +0000
Message-ID: <CH3PR11MB7345F029F83269D6B1A66231FC769@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <CANn89iJBStfwej_SO3xZq32P0+jHcaPgxY9ZBk-y8p6ZbHeWZA@mail.gmail.com>
In-Reply-To: <CANn89iJBStfwej_SO3xZq32P0+jHcaPgxY9ZBk-y8p6ZbHeWZA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|PH7PR11MB7049:EE_
x-ms-office365-filtering-correlation-id: 47ae0f4c-ad73-4404-86ac-08db50708077
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fvozpseKUZZhQgWDxsdfVETWDJCBwM2FAMUWcIR8VYZi8uj4ABTlEgd/gt2ELF7mE/HqtkNmuEVTMNzn06lamqev50pYUWd0u/iKC2gFg4otxLPQefCAqk4vldgofDFbqK96DT74YQZbnJgJFhqEw4QXorRx6a9gElFQdh7i++Fp0uPMn6y/Gs9WxU2E/5XwzMSdJHEn2vBGrgl4lYEnMYyT4kx69/AAAk88fF7EGZpzQu2aZ/pTq0jswnmWyhgW8/EcNoi+at/oVEn+/G8p2zp2wl7VIuLLZZHSY/Ys97qDl+zBjQ2pBb4sf1b0KPJNbF/I42EoRXwg/25NcJDmDEoRaBwtBRcbfOWewYg9tk5JUi0+kKVLvtF4za19x/AtXzyMACvOprH6yXvmXpp28z4DgCDJrvbaM3IgxX4mIBzggKY3Gy+gt3z2lLe4StrQpRb88PftUtWuMLFq1njpoAzfCv3jThKLjxKjRcGtqCTMPckX1tTlmCwA27p2xe08Z9zLwok/o1O7PKJalk5z30shIOHPjcvSes2JPpxe05epy4XBoPW5W8kN2/5zska3BZ6aQuJ2U+Y28ZvDpW0WCRRjVvZvVvrBW5NYItblaUM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199021)(76116006)(33656002)(38100700002)(4326008)(2906002)(52536014)(38070700005)(8676002)(316002)(86362001)(5660300002)(82960400001)(122000001)(6916009)(41300700001)(66946007)(66446008)(64756008)(66476007)(8936002)(55016003)(66556008)(83380400001)(966005)(186003)(26005)(53546011)(6506007)(9686003)(71200400001)(54906003)(478600001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzdVSGEweENabit6WnJYOUxnZzlUYlRFZ3loR0NIYkVCSWtvZXhveDVjclJD?=
 =?utf-8?B?dk42NklLNHhWZkRaNzVqZ1h0bEZ2cm40U2s1WjBSS0JyNkY3S0FZZ2tOdUYv?=
 =?utf-8?B?a2c0aWFsTUllTWdCYWl2LzZwTWtsRkNpeUUxNFVmallBVnVBV04zY040NVVk?=
 =?utf-8?B?ZzUxMVdXZnFCSW92WTBCQXdRZ3dhVDNKcjAzUWRnUGpKdENtb0ZodnBjZTJk?=
 =?utf-8?B?d0tKWUo5Tjl4bjE0M2ludG1ENlpHaGMvRDhaTXpNNVZlQVl5Vi9GOEhWVkx1?=
 =?utf-8?B?OEFJNGY3S25yM3JsT2xMdXRnTnM4RjcyZ3laT1lEK1lvZ2FoUDY0cEd5R0ZP?=
 =?utf-8?B?QTBDbHkra1dDeEI2NmdPV0l1VHBBOHJLYlEwanBiYjlUOEJFQUlRT2UzSGx1?=
 =?utf-8?B?dGNPcTUyRmZhRGt1SjlNWHBZbkZiSGRwWUVKd1RQSnBSNlJ6c2JUcVRuMG5X?=
 =?utf-8?B?SjBVclRSaVpCUmZueGRlY2x4NDBnOGFWQnViTjh3RVQwRGxIWSs3QnlWVWgw?=
 =?utf-8?B?NFZYTmJNeUYvN2hqVDcwRDBmT1Y4Q3F1YnZvcGZQQ1RNd2RuTjhWbVVKckFS?=
 =?utf-8?B?dXdwSGQ2dWJaalh0SXBHZzZqa2ZGSS9NY3U3eWx0eTQwWTNCUUd3UG4zRG9m?=
 =?utf-8?B?RnlzeFFlcU1Gck5oaVdxbnR1NlN3cXU4SzZrS09kdXRKdkZ1T25oOTR5UEZ3?=
 =?utf-8?B?ZGNXSkZ1ajFYeXZOYVR3Tm5ob0RwR0x6WTNycjNvZExaRnQ0UUdwN1lWayts?=
 =?utf-8?B?SE5USUlSS0h3QlRTcGFxd3RSaEpsVEg5UmRSNW05U1dKZDkwZDYxNFNQYk1P?=
 =?utf-8?B?Q3ZTc2l5em5lbFJDZkF3U0YxVjhnNHhRbUUzeGpWUTNYcGI2WEZYcFpkdzBv?=
 =?utf-8?B?Qzl6SkVaZTNoY3JZYnMydkxEWmFNSXNoV2dIMTNlRVFIamlZNjltWERwNnpy?=
 =?utf-8?B?MC9mZG16U3lJc2V4T3liT3pUekcwcDFVb2NOam40RXJOUElUYnduSTgxTFRQ?=
 =?utf-8?B?U2lFVjYwNERPdXlUNFBnWkJ5MEw0aFprNXJFK2h0Wjh6YnZmVTJVR3Y0S2tw?=
 =?utf-8?B?K1lJMVJ6UmduQkNqaVRKTy9KNmNENWcrK3Jtc0pROEkrSHY0WUFucEtRdE83?=
 =?utf-8?B?dnppN29HUC9KTVBrYlRYVEowOVpTV0xnK1RiMDBKNGc2SlJLTjFIZlhDbFpt?=
 =?utf-8?B?Wmo4WlE0V3FmQWhkL1k4RmYwMnVWVFZqTzE2Ulk0Nk1lRGVaaFRoK29wYW5n?=
 =?utf-8?B?VFFiL3dPK1lzUlFRNE1yZ2xZaUt3Um1zUzVwZGdCbWpXMmlpU3lldzZJcG1U?=
 =?utf-8?B?U3lheHZUMCtNa0ZyNlpXeWduYm9HWnloT21HaTdGbXhsYWt3eEt5V3FVTjJm?=
 =?utf-8?B?QmRHcE5oQjJtcFA1NUJSTWIvbDJYd0gyTU5VYVRYckZ5UEdIQkgyY2VGMVRQ?=
 =?utf-8?B?YkdCa3dtVGJlRWQvQm5LSW4xbWsvYjdvUno5L2QwSlJUWCtLOFQ2dm0zNkUy?=
 =?utf-8?B?RlR4U2dBOHREWWR0ci95WHhEdVNiOG5KZktSU0NtdWMySlR2TTB1YjFYMkx2?=
 =?utf-8?B?WW5JaFZmeU83UElHRUlDWlRKUHdJRmhTZytydGlHdU9lUkxraTIrUDJlVVNu?=
 =?utf-8?B?QWxnc2hQSDVxVllGUWRJc3EzTXA5YWRIRGk2ekdMZ1FuQWc5NmdXV0RtY09G?=
 =?utf-8?B?S0ViS2o3a3dKREpzZGlvM1VwQXNaR1Rzc2MwL2Y0eThqV3pxRE8weCtxQ1Qx?=
 =?utf-8?B?UzFiMTZEc043em0yYkRiZVZYaFZubEVYcW5lN3JLOXMyZVBWbUZmc08vbitm?=
 =?utf-8?B?RzZhQno0U3dqSStsVW9kR3dYRmo3ODVMZ3c0eURqVXMySk5HTmt3cEV2VCsv?=
 =?utf-8?B?TzkwbE5jMFNVb2l1VmVnNi9jZHBPZEx6R2xVR1JhK0ZZeXZ0QnEybUVpcXN5?=
 =?utf-8?B?UUh0QjZDZ2F4VW9VLzNmOWlMZ3duT09ZZi9FL1lOWjh0cEFqUjJzamgyRTZ5?=
 =?utf-8?B?WDBGVXZTR3JBL1RyVHpKRmgvdXRNYll2dm9zWitKZS9uQ2hYLy8xTThCRmhF?=
 =?utf-8?B?ZVlITzdqM1ROYlE4NFB3eXp3TXphcHJ5bVRKM2RTWlE5c0NielhWM256K290?=
 =?utf-8?Q?ksy3nfChdaKu+QwLsBZO72Ofy?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ae0f4c-ad73-4404-86ac-08db50708077
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 09:33:52.4574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HTs5Cm++85uy3c7F7kg4DnauOWLn7MowJF1LNm1XHlM0sea23+tTiadTGJ/Vy0Gkmm57anelBbmuNUu8bjBzpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7049
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEVyaWMgRHVtYXpldCA8ZWR1
bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gU2VudDogVHVlc2RheSwgTWF5IDksIDIwMjMgNDo0OSBQTQ0K
PiBUbzogWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+IENjOiBkYXZlbUBk
YXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBCcmFu
ZGVidXJnLCBKZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBTcmluaXZhcywgU3Vy
ZXNoDQo+IDxzdXJlc2guc3Jpbml2YXNAaW50ZWwuY29tPjsgQ2hlbiwgVGltIEMgPHRpbS5jLmNo
ZW5AaW50ZWwuY29tPjsgWW91LA0KPiBMaXpoZW4gPGxpemhlbi55b3VAaW50ZWwuY29tPjsgZXJp
Yy5kdW1hemV0QGdtYWlsLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgU2hha2VlbCBC
dXR0IDxzaGFrZWVsYkBnb29nbGUuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0
IDEvMl0gbmV0OiBLZWVwIHNrLT5za19mb3J3YXJkX2FsbG9jIGFzIGEgcHJvcGVyDQo+IHNpemUN
Cj4gDQo+IE9uIE1vbiwgTWF5IDgsIDIwMjMgYXQgNDowOOKAr0FNIENhdGh5IFpoYW5nIDxjYXRo
eS56aGFuZ0BpbnRlbC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gQmVmb3JlIGNvbW1pdCA0ODkw
YjY4NmY0MDggKCJuZXQ6IGtlZXAgc2stPnNrX2ZvcndhcmRfYWxsb2MgYXMgc21hbGwNCj4gPiBh
cyBwb3NzaWJsZSIpLCBlYWNoIFRDUCBjYW4gZm9yd2FyZCBhbGxvY2F0ZSB1cCB0byAyIE1CIG9m
IG1lbW9yeSBhbmQNCj4gPiB0Y3BfbWVtb3J5X2FsbG9jYXRlZCBtaWdodCBoaXQgdGNwIG1lbW9y
eSBsaW1pdGF0aW9uIHF1aXRlIHNvb24uIFRvDQo+ID4gcmVkdWNlIHRoZSBtZW1vcnkgcHJlc3N1
cmUsIHRoYXQgY29tbWl0IGtlZXBzIHNrLT5za19mb3J3YXJkX2FsbG9jIGFzDQo+ID4gc21hbGwg
YXMgcG9zc2libGUsIHdoaWNoIHdpbGwgYmUgbGVzcyB0aGFuIDEgcGFnZSBzaXplIGlmDQo+ID4g
U09fUkVTRVJWRV9NRU0gaXMgbm90IHNwZWNpZmllZC4NCj4gPg0KPiA+IEhvd2V2ZXIsIHdpdGgg
Y29tbWl0IDQ4OTBiNjg2ZjQwOCAoIm5ldDoga2VlcCBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcw0K
PiA+IHNtYWxsIGFzIHBvc3NpYmxlIiksIG1lbWNnIGNoYXJnZSBob3QgcGF0aHMgYXJlIG9ic2Vy
dmVkIHdoaWxlIHN5c3RlbQ0KPiA+IGlzIHN0cmVzc2VkIHdpdGggYSBsYXJnZSBhbW91bnQgb2Yg
Y29ubmVjdGlvbnMuIFRoYXQgaXMgYmVjYXVzZQ0KPiA+IHNrLT5za19mb3J3YXJkX2FsbG9jIGlz
IHRvbyBzbWFsbCBhbmQgaXQncyBhbHdheXMgbGVzcyB0aGFuIHRydWVzaXplLA0KPiA+IHNrLT5u
ZXR3b3JrIGhhbmRsZXJzIGxpa2UgdGNwX3Jjdl9lc3RhYmxpc2hlZCgpIHNob3VsZCBqdW1wIHRv
DQo+ID4gc2xvdyBwYXRoIG1vcmUgZnJlcXVlbnRseSB0byBpbmNyZWFzZSBzay0+c2tfZm9yd2Fy
ZF9hbGxvYy4gRWFjaA0KPiA+IG1lbW9yeSBhbGxvY2F0aW9uIHdpbGwgdHJpZ2dlciBtZW1jZyBj
aGFyZ2UsIHRoZW4gcGVyZiB0b3Agc2hvd3MgdGhlDQo+ID4gZm9sbG93aW5nIGNvbnRlbnRpb24g
cGF0aHMgb24gdGhlIGJ1c3kgc3lzdGVtLg0KPiA+DQo+ID4gICAgIDE2Ljc3JSAgW2tlcm5lbF0g
ICAgICAgICAgICBba10gcGFnZV9jb3VudGVyX3RyeV9jaGFyZ2UNCj4gPiAgICAgMTYuNTYlICBb
a2VybmVsXSAgICAgICAgICAgIFtrXSBwYWdlX2NvdW50ZXJfY2FuY2VsDQo+ID4gICAgIDE1LjY1
JSAgW2tlcm5lbF0gICAgICAgICAgICBba10gdHJ5X2NoYXJnZV9tZW1jZw0KPiA+DQo+ID4gSW4g
b3JkZXIgdG8gYXZvaWQgdGhlIG1lbWNnIG92ZXJoZWFkIGFuZCBwZXJmb3JtYW5jZSBwZW5hbHR5
LA0KPiA+IHNrLT5za19mb3J3YXJkX2FsbG9jIHNob3VsZCBiZSBrZXB0IHdpdGggYSBwcm9wZXIg
c2l6ZSBpbnN0ZWFkIG9mIGFzDQo+ID4gc21hbGwgYXMgcG9zc2libGUuIEtlZXAgbWVtb3J5IHVw
IHRvIDY0S0IgZnJvbSByZWNsYWltcyB3aGVuDQo+ID4gdW5jaGFyZ2luZyBza19idWZmIG1lbW9y
eSwgd2hpY2ggaXMgY2xvc2VyIHRvIHRoZSBtYXhpbXVtIHNpemUgb2YNCj4gPiBza19idWZmLiBJ
dCB3aWxsIGhlbHAgcmVkdWNlIHRoZSBmcmVxdWVuY3kgb2YgYWxsb2NhdGluZyBtZW1vcnkgZHVy
aW5nIFRDUA0KPiBjb25uZWN0aW9uLg0KPiA+IFRoZSBvcmlnaW5hbCByZWNsYWltIHRocmVzaG9s
ZCBmb3IgcmVzZXJ2ZWQgbWVtb3J5IHBlci1zb2NrZXQgaXMgMk1CLA0KPiA+IHNvIHRoZSBleHRy
YW5lb3VzIG1lbW9yeSByZXNlcnZlZCBub3cgaXMgYWJvdXQgMzIgdGltZXMgbGVzcyB0aGFuDQo+
ID4gYmVmb3JlIGNvbW1pdCA0ODkwYjY4NmY0MDggKCJuZXQ6IGtlZXAgc2stPnNrX2ZvcndhcmRf
YWxsb2MgYXMgc21hbGwNCj4gPiBhcyBwb3NzaWJsZSIpLg0KPiA+DQo+ID4gUnVuIG1lbWNhY2hl
ZCB3aXRoIG1lbXRpZXJfYmVuY2hhbXJrIHRvIHZlcmlmeSB0aGUgb3B0aW1pemF0aW9uIGZpeC4g
OA0KPiA+IHNlcnZlci1jbGllbnQgcGFpcnMgYXJlIGNyZWF0ZWQgd2l0aCBicmlkZ2UgbmV0d29y
ayBvbiBsb2NhbGhvc3QsDQo+ID4gc2VydmVyIGFuZCBjbGllbnQgb2YgdGhlIHNhbWUgcGFpciBz
aGFyZSAyOCBsb2dpY2FsIENQVXMuDQo+ID4NCj4gPiBSZXN1bHRzIChBdmVyYWdlIGZvciA1IHJ1
bikNCj4gPiBSUFMgKHdpdGgvd2l0aG91dCBwYXRjaCkgICAgICAgICsyLjA3eA0KPiA+DQo+ID4g
Rml4ZXM6IDQ4OTBiNjg2ZjQwOCAoIm5ldDoga2VlcCBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcyBz
bWFsbCBhcw0KPiA+IHBvc3NpYmxlIikNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENhdGh5IFpo
YW5nIDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl6aGVuIFlv
dSA8bGl6aGVuLnlvdUBpbnRlbC5jb20+DQo+ID4gVGVzdGVkLWJ5OiBMb25nIFRhbyA8dGFvLmxv
bmdAaW50ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBKZXNzZSBCcmFuZGVidXJnIDxqZXNzZS5i
cmFuZGVidXJnQGludGVsLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogVGltIENoZW4gPHRpbS5jLmNo
ZW5AbGludXguaW50ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBTdXJlc2ggU3Jpbml2YXMgPHN1
cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+DQo+ID4gLS0tDQo+IA0KPiANCj4gSSBkaXNhZ3JlZS4N
Cj4gDQo+IE1lbWNnIGZvbGtzIGhhdmUgc29sdmVkIHRoaXMgaXNzdWUgYWxyZWFkeS4NCg0KSGkg
RXJpYywNCg0KRG8geW91IG1lYW4gdGhlIHNlcmllcyAtICJtZW1jZzogb3B0aW1pemUgY2hhcmdl
IGNvZGVwYXRoIiBieSBTaGFrZWVsPw0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIy
MDgyNTAwMDUwNi4yMzk0MDYtMS1zaGFrZWVsYkBnb29nbGUuY29tL1QvIA0KDQpPdXIgcnVubmlu
ZyBpcyBnYWlucyB2Ni4zIHdoaWNoIGluY2x1ZGVzIHRoaXMgc2VyaWVzLCB3ZSBkbyBub3Qgc2Vl
IHRoZSBob3QgcGF0aA0KbGlrZSAiIHByb3BhZ2F0ZV9wcm90ZWN0ZWRfdXNhZ2UiLCBidXQgc2Vl
IHRoZSBob3QgcGF0aHMgc2hvd24gaW4gdGhlIGNvbW1pdA0KbG9nLg0KDQo+IA0KPiBDQyBTaGFr
ZWVsDQo+IA0KPiA2NEtCIHBlciBzb2NrZXQgaXMgdG9vIG11Y2gsIHNvbWUgb2YgdXMgaGF2ZSAx
MCBtaWxsaW9uIHRjcCBzb2NrZXRzIHBlciBob3N0Lg0KDQo2NEtCIGlzIHNlbGVjdGVkIGJlY2F1
c2UgaXQncyB0aGUgbWF4aW11bSBwYWNrZXQgc2l6ZSBvZiBJUFY0LCBwbGVhc2UgY29ycmVjdCBt
ZQ0KaWYgSSdtIHdyb25nLiBJZiB0aGUgcmVzZXJ2ZWQgbWVtb3J5IHNpemUgaXMgdG9vIGhpZ2gs
IGl0IG1pZ2h0IGJyaW5nIG1lbW9yeSBwcmVzc3VyZSwNCmJ1dCBpZiBpdCdzIHRvbyBsb3csIG1l
bWNnIG92ZXJoZWFkIHdpbGwgaGFwcGVuIGluIHNjZW5hcmlvcyBsaWtlIG91cnMuIFRoYXQncyB3
aHkgd2UNCnByb3ZpZGUgYSB0dW5hYmxlIEFCSSBpbiBuZXh0IHBhdGNoLCBpdCdzIGFsbG93ZWQg
QWRtaW4gb3Igc29tZW9uZSBlbHNlIHRvIHR1bmUgaXQNCmFjY29yZGluZyB0byB0aGUgc3lzdGVt
IHJ1bm5pbmcgc3RhdHVzLiBSZWdhcmRpbmcgdGhlIGRlZmF1bHQgdmFsdWUsIGFub3RoZXIgdHJ5
IGlzIHRvDQpzZXQgaXQgYXMgdGhlIGRlZmF1bHQgdmFsdWUgb2YgL3Byb2Mvc3lzL25ldC9pcHY0
L3RjcF93bWVtIHdoaWNoIGlzIDE2S0IuDQoNCj4gDQo+IA0KPiA+ICBpbmNsdWRlL25ldC9zb2Nr
LmggfCAyMyArKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjIg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbmV0L3NvY2suaCBiL2luY2x1ZGUvbmV0L3NvY2suaCBpbmRleA0KPiA+IDhiN2VkNzE2NzI0
My4uNmQyOTYwNDc5YTgwIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbmV0L3NvY2suaA0KPiA+
ICsrKyBiL2luY2x1ZGUvbmV0L3NvY2suaA0KPiA+IEBAIC0xNjU3LDEyICsxNjU3LDMzIEBAIHN0
YXRpYyBpbmxpbmUgdm9pZCBza19tZW1fY2hhcmdlKHN0cnVjdCBzb2NrDQo+ICpzaywgaW50IHNp
emUpDQo+ID4gICAgICAgICBzay0+c2tfZm9yd2FyZF9hbGxvYyAtPSBzaXplOw0KPiA+ICB9DQo+
ID4NCj4gPiArLyogVGhlIGZvbGxvd2luZyBtYWNybyBjb250cm9scyBtZW1vcnkgcmVjbGFpbWlu
ZyBpbg0KPiBza19tZW1fdW5jaGFyZ2UoKS4NCj4gPiArICovDQo+ID4gKyNkZWZpbmUgU0tfUkVD
TEFJTV9USFJFU0hPTEQgICAoMSA8PCAxNikNCj4gPiAgc3RhdGljIGlubGluZSB2b2lkIHNrX21l
bV91bmNoYXJnZShzdHJ1Y3Qgc29jayAqc2ssIGludCBzaXplKSAgew0KPiA+ICsgICAgICAgaW50
IHJlY2xhaW1hYmxlOw0KPiA+ICsNCj4gPiAgICAgICAgIGlmICghc2tfaGFzX2FjY291bnQoc2sp
KQ0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gICAgICAgICBzay0+c2tfZm9yd2Fy
ZF9hbGxvYyArPSBzaXplOw0KPiA+IC0gICAgICAgc2tfbWVtX3JlY2xhaW0oc2spOw0KPiA+ICsN
Cj4gPiArICAgICAgIHJlY2xhaW1hYmxlID0gc2stPnNrX2ZvcndhcmRfYWxsb2MgLQ0KPiA+ICsg
c2tfdW51c2VkX3Jlc2VydmVkX21lbShzayk7DQo+ID4gKw0KPiA+ICsgICAgICAgLyogUmVjbGFp
bSBtZW1vcnkgdG8gcmVkdWNlIG1lbW9yeSBwcmVzc3VyZSB3aGVuIG11bHRpcGxlDQo+IHNvY2tl
dHMNCj4gPiArICAgICAgICAqIHJ1biBpbiBwYXJhbGxlbC4gSG93ZXZlciwgaWYgd2UgcmVjbGFp
bSBhbGwgcGFnZXMgYW5kIGtlZXANCj4gPiArICAgICAgICAqIHNrLT5za19mb3J3YXJkX2FsbG9j
IGFzIHNtYWxsIGFzIHBvc3NpYmxlLCBpdCB3aWxsIGNhdXNlDQo+ID4gKyAgICAgICAgKiBwYXRo
cyBsaWtlIHRjcF9yY3ZfZXN0YWJsaXNoZWQoKSBnb2luZyB0byB0aGUgc2xvdyBwYXRoIHdpdGgN
Cj4gPiArICAgICAgICAqIG11Y2ggaGlnaGVyIHJhdGUgZm9yIGZvcndhcmRlZCBtZW1vcnkgZXhw
YW5zaW9uLCB3aGljaCBsZWFkcw0KPiA+ICsgICAgICAgICogdG8gY29udGVudGlvbiBob3QgcG9p
bnRzIGFuZCBwZXJmb3JtYW5jZSBkcm9wLg0KPiA+ICsgICAgICAgICoNCj4gPiArICAgICAgICAq
IEluIG9yZGVyIHRvIGF2b2lkIHRoZSBhYm92ZSBpc3N1ZSwgaXQncyBuZWNlc3NhcnkgdG8ga2Vl
cA0KPiA+ICsgICAgICAgICogc2stPnNrX2ZvcndhcmRfYWxsb2Mgd2l0aCBhIHByb3BlciBzaXpl
IHdoaWxlIGRvaW5nIHJlY2xhaW0uDQo+ID4gKyAgICAgICAgKi8NCj4gPiArICAgICAgIGlmIChy
ZWNsYWltYWJsZSA+IFNLX1JFQ0xBSU1fVEhSRVNIT0xEKSB7DQo+ID4gKyAgICAgICAgICAgICAg
IHJlY2xhaW1hYmxlIC09IFNLX1JFQ0xBSU1fVEhSRVNIT0xEOw0KPiA+ICsgICAgICAgICAgICAg
ICBfX3NrX21lbV9yZWNsYWltKHNrLCByZWNsYWltYWJsZSk7DQo+ID4gKyAgICAgICB9DQo+ID4g
IH0NCj4gPg0KPiA+ICAvKg0KPiA+IC0tDQo+ID4gMi4zNC4xDQo+ID4NCg==

