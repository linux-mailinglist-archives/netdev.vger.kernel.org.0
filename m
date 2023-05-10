Return-Path: <netdev+bounces-1429-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2821A6FDC58
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4F421C20D38
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A968C79CB;
	Wed, 10 May 2023 11:11:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9479320B43
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:11:44 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A72310E6;
	Wed, 10 May 2023 04:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683717101; x=1715253101;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PYNjDozDipF+mUdAF2AhOD5OPShxkRs+xPQuv9ENnog=;
  b=CaT7slPl0x1wsu2C25JZNWzS3oaCSJuEU2kZ0dYc0Mcu6/cWB8lvdj9O
   VS1M0dCQNbLoyR8L0ZTVnhwkJ0uuIRwiga+cMVFD4a2fZf6+aBjKKPCfw
   qIdTgPv55pVYg9G6+Vd0A51iffvxMhTyDY8XYbqIzOGUQpnu7YAH7JALV
   7YbF84vOHV64vMC+jiV6QJIDnVrFn550h3QRdbsIsPtgqJxePpGjfqtQ2
   /FwFSGJhgDECcjFL2SXKB3NKbxNUQ0aW0J5IjNh35TjO6yJDFyfFr9I5H
   OXPoWa6VM/6Ihui3cpx+kbple0kNvXuuYzXmOJ9NgJ+C4DAYfITnQUKe5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="347647805"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="347647805"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 04:11:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="676805863"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="676805863"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 10 May 2023 04:11:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 04:11:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 04:11:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 04:11:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOv0k5uMLCYbZHqLcGsykYCf6ORgMuXXnvcHlJG3dQshr9BeA1SzaDWUVxKmzNrncqiLwu6uNLbOiu14CnB2sKqTMpeb8+mwzjmwngSb/gjDj8lt7725G9f3ZNvrCE3EI3FELGUgJG7pNyLGHRRiP8I8CYGt+7cH5ZCYXDng0g/rDXhu/BP5YRcTbLCxdYD/eTMEKwGmTpU3Z5cNT1h11+hp8fT4IkWrnGJyBTMwYvK5hUhvn+5QxjNpLCj2lw91zwPHU/+lqzAyhKzj05S3LZPP5O8k2vicnjvVNCeBGWndOYLJBS0NBx5kkSnkqpX5aK1dk3BktznUTzXH5y+thw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYNjDozDipF+mUdAF2AhOD5OPShxkRs+xPQuv9ENnog=;
 b=c+JXNxn+KJAMsaqgoRtGL46vEiB2q8F3dsxftrUSVad5A5ow8cE73R5CM5UQBOYDehwpGIVAx6Wcas36bu5qll2Ff3yY/vH2iUy16L13JGk7RysO2LolbHLcN8EzpFc2tRgciHIdhphFfdn2zfXcouJIsxhKZ7zIDVrNC08yyNDW5PwTFZXmS4J1jqMMdN1D5jcTXwVULBTfWuEq7zAyL1ZLr6CGzyVjFA6TCeFB1SAWPWpK28ZiEiEY5nmPgQQhs5HUOUhp23bLO0C1Jc85n2YPNACtUXSAc1UUHC9JIOXN7jFQhceo2UkN8YLYa5r/TO7UIjhucnEyUpoT9heyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by DS0PR11MB6472.namprd11.prod.outlook.com (2603:10b6:8:c0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19; Wed, 10 May 2023 11:11:38 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 11:11:37 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>,
	Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>
CC: Paolo Abeni <pabeni@redhat.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, "Brandeburg,
 Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBA=
Date: Wed, 10 May 2023 11:11:37 +0000
Message-ID: <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
In-Reply-To: <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|DS0PR11MB6472:EE_
x-ms-office365-filtering-correlation-id: c097fa6b-4256-413b-af83-08db514752a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LfgzR4loMMxYNuNELz2GzfC0bJVkEJsHEq/YhWMsDow1OvI1hZQMgZN3nc0QMJX4aZkP14qLcD1vYQfeZ/dqKcef6FyrTXm4WK8R8oZbgVNNNa6VUhhhg3AWAqMtxEB6hjRt3FwbIfFDOtN0VD/sTrzCDZbaHKRH37S4UWZpHDy046F857Ufc/uBLB59wdyIn0826GppfBsAIhWGWAls4uS7XaL0/ap830k16bafcY1q4npyapldbMLxGDAfcgicQum5I4o8R0xznoyRhJmehyv9/qxJom4BzoFO0HQl0m4kKYHDY1OdVD6ea2pHOJomNIcH4yQIaoYtMh9xtsRWyDiIVVKHS2JWzbKmlapxmrd4A4m9cqErbQrgatb/Ncqc/76XQwVCJ+Wg/X9dtQojxw6g42tnSxu+nVw2/JCDaEjNfihoYMnRJx/a+DOGFdaTL2cqSVAMQ75chLX70rAuYCcPKt8HXH7kkT2KysgKQtd+C1roaXId/n1xH5eu1dwiTqtlPEc4pKH52FpPdCfK7uK3In2RqspdPf5vdEF70Lyrbg6FUDtWug50eE9I7GsaXFTvRrfAbz5+G1VbC8yfbwv2a5YF09vHRXGYvLtXJTs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199021)(966005)(66476007)(4326008)(64756008)(478600001)(71200400001)(76116006)(66946007)(7696005)(66556008)(66446008)(316002)(110136005)(54906003)(33656002)(86362001)(83380400001)(26005)(53546011)(186003)(9686003)(6506007)(5660300002)(52536014)(2906002)(8936002)(8676002)(41300700001)(55016003)(82960400001)(38070700005)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nlk2RXNTQ1VtNkhrL3pkQS9NYUUvT21YcXMzTVlMQnRtZlNmQXJMV3FwMEk1?=
 =?utf-8?B?aCt1VEZwdHA2cjB3dDllT1g3azdTZlA5MEEweFFoTTh5ZEQ0Yk5GZVhZNXov?=
 =?utf-8?B?YldnUDVHenYyeWVPNXgzNnM5MytYbFloa1Jib3diT2hOOWpNWGpNT2RTMVZn?=
 =?utf-8?B?dVpqOXlHa2RyOFBtVW80N1luSFkvSkdhOXFHVmNoZHBtSlFlcStoY0VRclJE?=
 =?utf-8?B?TktBQ1FkbU50QWRYTXh2YVNIT1JkT2xHTlBVNFJNVFUxM01WTlRWRWloQWxX?=
 =?utf-8?B?M3FPOU01dlpZYk1XQkU2eXRRdFptWnhtb3dwSk0wT3h0eVRMbHA4YWp5czRn?=
 =?utf-8?B?dHlVVTU5NlB5Ty9nUmJjSlBhUE9uU1ErbzlYU2tZSjFEVkpCM21OTG1CT1NO?=
 =?utf-8?B?cWltUWpHSkJnSzFBZUw1Y2YweDF5RnZBa3ZvNmtQSXcvYkgvRUx2Wkd3OUta?=
 =?utf-8?B?amhzQ3paVm05bUc0M3ByeEcrRzAyZzZFcnlXUXh1NVhYdGF3NHAxMEE0YXNv?=
 =?utf-8?B?TWRLZXVGZ2NDZ2ltTHpsNWFXSGo5OERtWHowbjN5a1FxemRWNzVwbnVDaFNK?=
 =?utf-8?B?bnlLU0VneWwzc3lDMjB5UlNXdGtocXpVcS9YZjlpRTNENHdYQ1J0R1dPdVRS?=
 =?utf-8?B?S2xsemtGVUFkdzhXOFJBek5KOWlyMU0wa0FLODdqUytVblZ1U2tBRjFYcklE?=
 =?utf-8?B?d1JKUFMrdnVXL3AxU1IrZ1laY2h3cHZlYkxXbGdtMFgvZTlzOFZjWmZFNjVj?=
 =?utf-8?B?WStOQU81RlNQSTBqbWVoWk5YaERWeFVqL0hJdElybWh4ek94Ly95dE5SeDh5?=
 =?utf-8?B?b2dDRTFPdmV0VElYaUFPVVBmNUZoUDJMaytBUUZZUmRpZWVYSytTVDNRSjhR?=
 =?utf-8?B?RXJTQVdJdkZVdHpiVkJETndUd0d6V0MyaUdNRzY4cE1YVVB3ZG5ZVHBpSWh0?=
 =?utf-8?B?eVp5ZXkyZ1lGU2dkUWtUWW1PMlYxNTZpeFlHdW9uZnU4UHd4Q1NFVDJicUJ6?=
 =?utf-8?B?blNCQnJlYUs4bTU3Tm9SRjh5RGFTanEyejNRVkxTc3JGaDlodnNkTFR0OHYv?=
 =?utf-8?B?RzFjUjFBNUJSeS9jT3BPb0krcml4eFB1cDZPM3l0UUF3TElJNGVRTTN0RHBI?=
 =?utf-8?B?OXhzSE8rOVk3bjMwVm4zWWNWalpkYzlLdDMwOGl0UFFkak4yY2xnN2JDM0ti?=
 =?utf-8?B?Vkp5eFQrSTlBMTRqK3UxVmF6MzZJMTg5UkVEZjhBdG1mQVlUMU5MeVp3MFRN?=
 =?utf-8?B?Q3dSbGxpaUpTWmJJZjNqZ05lcklmUWpXL1oySjlkalE5clRCdlEvRUxFVStl?=
 =?utf-8?B?Y0xrZ1lGMjVtcXpidXNTSE9WQXBiMFJYeGJFVkJQRHVOY242VTBGaTl3YzdM?=
 =?utf-8?B?NUJvUG4wV3dGcVFFL3Y2SC8zZzFHanBTbGVqclZrS2JiRFp4OHNBWmhIN0c3?=
 =?utf-8?B?N09IVTFhUk5jcGJYOWxYZkl5aVNoNHJzdk04ZnpKNDVHVTNiQmJRNHJXSWhV?=
 =?utf-8?B?NWQ5Y0hxazRPbkphZGhIQ0FaNUFhZnpOOEcvd01BMFFjbXBwVW1qbUR4NldJ?=
 =?utf-8?B?bm16dHZIU25nSGllRUM2QkZrQ0NRL0Foa3NPcHBvWitrYlJEZk44U0pFSDMw?=
 =?utf-8?B?TmxxUTBMV2o3bFRrV3N6VUN2RlU5TE4rdWdKQWJkajZBc01oREZmKzNEUyth?=
 =?utf-8?B?cXZ6SXFVZjB1WXYyczVvQ0NOZDMyNUErdjhITGEzbUJNNXM5RDVEQkwxTWYv?=
 =?utf-8?B?VzRoVHJaQi9rcDFrbHVkc1cvc1lhQm5VMlBHeWVIMnFlR0FnQWxwTlpGTWpo?=
 =?utf-8?B?c0U3ZVkzZndtSkU5Wnh4ZHhwS0RkRzVRajBYRGp5Mkh3ZTBZV3d3MTJwbStR?=
 =?utf-8?B?NGxxY0QzZ2UvSmFTQjBhSlVIRk9kUS84dFhpTUplRjBYZ080Sk5oVDI5Ylcx?=
 =?utf-8?B?SC9HclRsa0VRQy8yT3NaWHR3dFpOb2N0R1pZZzVLenBKOTZ1N29jYUdkZnFJ?=
 =?utf-8?B?WFJQQWNRVnpCeUVza0tpSVhtUWxNREdXM2ZMb3RVUFRQSkc3NXo0UGxqMzBx?=
 =?utf-8?B?VFgvbDgwUFRtUzE1eFlQdVhkdFV0MXdxeG1YSmtDNm9hSFdHUWhKQzVLeDcz?=
 =?utf-8?Q?8hATEG6v5opKHLKT5bwDOvlC9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c097fa6b-4256-413b-af83-08db514752a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 11:11:37.3919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rKYr9sd2bBmwPOxZPC4nfsKxZtEBcpOfZUAuO9EtPPV8bzL/0ACigbg6BcS2X0VgYUY8qqBHngsqLn5leb3Z3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6472
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgU2hha2VlbCwgRXJpYyBhbmQgYWxsLA0KDQpIb3cgYWJvdXQgYWRkaW5nIG1lbW9yeSBwcmVz
c3VyZSBjaGVja2luZyBpbiBza19tZW1fdW5jaGFyZ2UoKQ0KdG8gZGVjaWRlIGlmIGtlZXAgcGFy
dCBvZiBtZW1vcnkgb3Igbm90LCB3aGljaCBjYW4gaGVscCBhdm9pZCB0aGUgaXNzdWUNCnlvdSBm
aXhlZCBhbmQgdGhlIHByb2JsZW0gd2UgZmluZCBvbiB0aGUgc3lzdGVtIHdpdGggbW9yZSBDUFVz
Lg0KDQpUaGUgY29kZSBkcmFmdCBpcyBsaWtlIHRoaXM6DQoNCnN0YXRpYyBpbmxpbmUgdm9pZCBz
a19tZW1fdW5jaGFyZ2Uoc3RydWN0IHNvY2sgKnNrLCBpbnQgc2l6ZSkNCnsNCiAgICAgICAgaW50
IHJlY2xhaW1hYmxlOw0KICAgICAgICBpbnQgcmVjbGFpbV90aHJlc2hvbGQgPSBTS19SRUNMQUlN
X1RIUkVTSE9MRDsNCg0KICAgICAgICBpZiAoIXNrX2hhc19hY2NvdW50KHNrKSkNCiAgICAgICAg
ICAgICAgICByZXR1cm47DQogICAgICAgIHNrLT5za19mb3J3YXJkX2FsbG9jICs9IHNpemU7DQoN
CiAgICAgICAgaWYgKG1lbV9jZ3JvdXBfc29ja2V0c19lbmFibGVkICYmIHNrLT5za19tZW1jZyAm
Jg0KICAgICAgICAgICAgbWVtX2Nncm91cF91bmRlcl9zb2NrZXRfcHJlc3N1cmUoc2stPnNrX21l
bWNnKSkgew0KICAgICAgICAgICAgICAgIHNrX21lbV9yZWNsYWltKHNrKTsNCiAgICAgICAgICAg
ICAgICByZXR1cm47DQogICAgICAgIH0NCg0KICAgICAgICByZWNsYWltYWJsZSA9IHNrLT5za19m
b3J3YXJkX2FsbG9jIC0gc2tfdW51c2VkX3Jlc2VydmVkX21lbShzayk7DQoNCiAgICAgICAgaWYg
KHJlY2xhaW1hYmxlID4gcmVjbGFpbV90aHJlc2hvbGQpIHsNCiAgICAgICAgICAgICAgICByZWNs
YWltYWJsZSAtPSByZWNsYWltX3RocmVzaG9sZDsNCiAgICAgICAgICAgICAgICBfX3NrX21lbV9y
ZWNsYWltKHNrLCByZWNsYWltYWJsZSk7DQogICAgICAgIH0NCn0NCg0KSSd2ZSBydW4gYSB0ZXN0
IHdpdGggdGhlIG5ldyBjb2RlLCB0aGUgcmVzdWx0IGxvb2tzIGdvb2QsIGl0IGRvZXMgbm90IGlu
dHJvZHVjZQ0KbGF0ZW5jeSwgUlBTIGlzIHRoZSBzYW1lLg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQo+IEZyb206IFNoYWtlZWwgQnV0dCA8c2hha2VlbGJAZ29vZ2xlLmNvbT4NCj4g
U2VudDogV2VkbmVzZGF5LCBNYXkgMTAsIDIwMjMgMTI6MTAgQU0NCj4gVG86IEVyaWMgRHVtYXpl
dCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IExpbnV4IE1NIDxsaW51eC0NCj4gbW1Aa3ZhY2sub3Jn
PjsgQ2dyb3VwcyA8Y2dyb3Vwc0B2Z2VyLmtlcm5lbC5vcmc+DQo+IENjOiBaaGFuZywgQ2F0aHkg
PGNhdGh5LnpoYW5nQGludGVsLmNvbT47IFBhb2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNv
bT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gQnJhbmRlYnVyZywg
SmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgU3Jpbml2YXMsIFN1cmVzaA0KPiA8
c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4sIFRpbSBDIDx0aW0uYy5jaGVuQGludGVs
LmNvbT47IFlvdSwNCj4gTGl6aGVuIDxsaXpoZW4ueW91QGludGVsLmNvbT47IGVyaWMuZHVtYXpl
dEBnbWFpbC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcyBhIHBy
b3Blcg0KPiBzaXplDQo+IA0KPiArbGludXgtbW0gJiBjZ3JvdXANCj4gDQo+IFRocmVhZDogaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjMwNTA4MDIwODAxLjEwNzAyLTEtDQo+IGNhdGh5
LnpoYW5nQGludGVsLmNvbS8NCj4gDQo+IE9uIFR1ZSwgTWF5IDksIDIwMjMgYXQgODo0M+KAr0FN
IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gWy4u
Ll0NCj4gPiBTb21lIG1tIGV4cGVydHMgc2hvdWxkIGNoaW1lIGluLCB0aGlzIGlzIG5vdCBhIG5l
dHdvcmtpbmcgaXNzdWUuDQo+IA0KPiBNb3N0IG9mIHRoZSBNTSBmb2xrcyBhcmUgYnVzeSBpbiBM
U0ZNTSB0aGlzIHdlZWsuIEkgd2lsbCB0YWtlIGEgbG9vayBhdCB0aGlzDQo+IHNvb24uDQo=

