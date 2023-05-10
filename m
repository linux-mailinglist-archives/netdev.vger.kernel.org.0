Return-Path: <netdev+bounces-1482-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 302936FDF4B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 470FA1C20D94
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D87312B98;
	Wed, 10 May 2023 13:55:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371B812B7F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:55:37 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB650D85B;
	Wed, 10 May 2023 06:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683726899; x=1715262899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ike/YhTQ6FqDHgwb1fH8bcZ4R5gcgL1tekZJPzTAz4c=;
  b=L38/C97B24LKQvGTXOXBAw0pJ/Mazck8rj7AfI9+pbwgaJBoL9HDpUDe
   vFv1DhLmghT16dWroayKhEnYnIgFDzUOjK6EKaAVKrxkKrIIG4HJ6PuiL
   rmokubQ5YZIagcl7rNmmVJMkgRtuwOoo6EenZSOUoR/w47mcgl/vW8PLl
   bJCN4LkXx3TDl99AIgn66WiFubwyOHKrXAFu0hcB0G6T4YmeKX7CLgiCU
   ObFOQpEj42P8D2mxk6LKBVVo7s6XUbG2XmuMGaJ63mg8XmTWJN0atGcIc
   1Nx6fgO1/W2dtFiekH3vj2428JoC4YitnRjKmvpJ4+59ro0HPel2kqgI3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="413517811"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="413517811"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 06:52:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="823556309"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="823556309"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 10 May 2023 06:52:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 06:52:20 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 06:52:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 06:52:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 06:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lof2EIFhKFsclHypehxgKMFrwrMFhO3OQxTa6/1fXJTDQ13utJ1Teh6j+HwqDudPOEDolZi9RlJffuNwHlJc1OrbxqiTJVyTj8laidWJU9eXMNV3zl5WTn+ytvONZ+Lj2brFwRpdmhO/YDx4H//bjymhqeSZFCA0ObHKRNOWSDZj6vkXuw6JGK7dQg5VcK6nD7tDtsuWLw92Omra9WanrXL6+sNAVU+dez4O/jsJcDWN33YIZ3vvlNTIxe15VbQ0N/GTczRhOAcOcicA0kckt+0+W6gdMkkkXw5q2E0E7YDpxMSvTFU7x/1RUDRaDX7+eMvnsMafZp02rn15livhHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ike/YhTQ6FqDHgwb1fH8bcZ4R5gcgL1tekZJPzTAz4c=;
 b=FeziVNxo9sPfuJRAs8E2aZyF15Fi8E3amvtKM9Z6slmTzo/8DcTYbFqbE1nypZ79LKEjrzGofYeuls++TWkrENRrncmfCzQ4Kxen3sNBJsg3MOPwNgd4A7kBcyny6xoy3A4ua9Kx+acwvuZKTg6Dh5Kw2X+CGah2wdFvBSOxZBlTw7k/XZfJwmJctQSJdFGqacgUjISNWjiM0MVD48ZY94lSpqtJFiWEwizgdMkSiaNjPoCLjDWvY87Fmz8cItKDX6Vqyd0Dv+tD6ekaaL7bVObd6AYDx/6dwth9cBlQLdWrZDFzYs6fpmLilgx2u//6vcIfBEcI3M9PfCoJZ8LkJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by PH7PR11MB6521.namprd11.prod.outlook.com (2603:10b6:510:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 13:52:17 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 13:52:17 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Eric Dumazet <edumazet@google.com>
CC: Shakeel Butt <shakeelb@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
	<cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Srinivas, Suresh" <suresh.srinivas@intel.com>, "Chen, Tim C"
	<tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbw
Date: Wed, 10 May 2023 13:52:16 +0000
Message-ID: <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
In-Reply-To: <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|PH7PR11MB6521:EE_
x-ms-office365-filtering-correlation-id: 716dba91-4422-4f35-e9d7-08db515dc42e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gVg2PDCKeDS+H8qxlN/5MhJPRgMyNP7qAwq6G+oyon7h2lcpSaQHi99b1HNxc+33jRwO/VS/uSsvVxM6mnvDayighuYXzI8S6gqSDEd1CADHxqeVhIxp6URj07iUMHmgWsXtTLX6dhAvFjB7v+LXzIlG9Zl6+VQeXqPrzx1wHiFmAbNgXWcUN06s5WBefqha9qQv66iLuDtb75M8ObBOoGz3CuaD0IWXv1t9YlKm4c8ScUtem3jXFSMYGzuySQrbSDVQt6U2BVlziBLYSucInSf94ZJdo+fQPibhAgiijDS+rYEni7NuqSwaax/xy7ZW221rJHneSI4m6SJ4vz2sNzq0AAoVJkKFMLxCmxdg86ZFD2xNGRVm64CGHmFDg3cFyCUepWxN1XmPEdGxvGwbIBRn4aZHZPwde/vazfbv2j7tT3YJFm8aO6Y29oi081cE4gnRwqxXjg9G4+PFaCPZJKReR0ToRnpwvFm6atWFD8LpikoOD6xhlRKJY9aFJZa5/aPoRBmCRy3C+fiyXoMgQBj2fgkoTBAerFor8ZhERKm5PSxIR/iPbkJP3s2tach2RefGbo5m4wtM8eXXsN9Ian7QNF5PKLtryLkO0UW8WWM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199021)(64756008)(33656002)(83380400001)(966005)(478600001)(54906003)(71200400001)(6506007)(186003)(53546011)(26005)(9686003)(7696005)(122000001)(2906002)(76116006)(38100700002)(52536014)(55016003)(41300700001)(6916009)(66446008)(4326008)(316002)(66476007)(66946007)(66556008)(86362001)(82960400001)(5660300002)(8676002)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WE5FMU9LZzJ1UUJ2Rm5zVW85S0gydUxOU2JycUhtdWlKQUxzRTZrc1ZmYWt1?=
 =?utf-8?B?Z3pEM0VnUXROb29TSllSMkZ4dWgwODY5TjRUNHczM2s3L243TkpVU256eW5h?=
 =?utf-8?B?TDh2OHRCT2h1a1Vzdnh4S2lZbVd6NVlmMlA3N2pOa2Z3Z3lBRHBSbDNobVcz?=
 =?utf-8?B?c2VlUVFzL2hENFRnZmdlZWNoOTRUVTJBS1dyNnJ0VEhCTitlYUs2OUVwQWZQ?=
 =?utf-8?B?MWFsNzI4bXh0SE11akFFbVp4YVdRNzl4TnExdTNKTU85SlZGQ0QxVHhIeGQ4?=
 =?utf-8?B?TE5zQlYwUnZ1SkxvSzB4WGhaVnQrclNtUXcvc0FBOHZ4MWlIdVZYbnJqdmNh?=
 =?utf-8?B?VCtna1drek55VWZBdzQzcHUrRHhPSktraXZnREJ1YkhFQS9XWmhSR0tjQml2?=
 =?utf-8?B?SzBsSG9MWWxNcy9HVVZES2pia0NPZjAwT3J1L0NtOEtTMHpzbVB4ZW00S2Uw?=
 =?utf-8?B?R2hFRDMzdVIzY2xrUVRhdFAzVm5yR2R6VHhaSmNVeEtJSXFkZDRDVkF6UHFl?=
 =?utf-8?B?b2VUbXNIWnRoU3FFMStLK0VITk55VVVLV2tLb3VRTFpsZWkwQld3elRiaTBW?=
 =?utf-8?B?aC9SZkJrWGdJYWRzOWpwdDZmZkFvTWM5Q2t5VGV5V1U5Ukh6d1E0eWtJcmdT?=
 =?utf-8?B?enZ0YitjNW91L1NweGJZQW9CTi9FSmdkMHQwRkF2ZnhMU21vbXFmUDVhTWJC?=
 =?utf-8?B?emZ4MnZLY3ZkQURQMjZRWUttdWdzSE90Tk1zU1I4aFpBeDY5STFCczBCalkw?=
 =?utf-8?B?d2JiUEpiM1BISnpZUVBhUnNxU3BwcXQrODVYL1pzNzB1OHhhT2tHNW1sZGRG?=
 =?utf-8?B?clNyZUdCTUR1YWVKbytIZXlJWGpXRnR0T3d6ekdqYnFVU3A1WllTWlJSeWIz?=
 =?utf-8?B?aWowZ1llNy9qWFZBUlZrbjBsNzg3YzhnRFNOSUk3WlNreUg2U052aUU0UmZq?=
 =?utf-8?B?VmFmeHVENkEyWjJ2c3FiZUxBT29ra0RkQ3BFemx4MlpaOEZUQ0xiSGszOWJ5?=
 =?utf-8?B?clJObVAzbTg0VEdIMVNxTXFJSnF6L05tRkNXUzZyT1BVVDBidDZ2NjhIaEF2?=
 =?utf-8?B?Ti9JUVQvSFRROEZKVnVYMURKa3M4ZHUycDhaNkxkSitqTzkvcU16MmIvekky?=
 =?utf-8?B?TlZMenl5ZnVMREFuK3NzaXRWMklUUjhweWg5emgxa2pyZkVtZmorczNZRHVx?=
 =?utf-8?B?eG9acTNmbnprMngycVRDM3R5OVJ5eTF4UzhZbzJ2Zk1sMitNck9ycDNsZ3pK?=
 =?utf-8?B?b2NtUHY2ck0vanNKempKa2pQNDlKMkNTeGFSYUZIclREWngzOWp0VUN0OVl1?=
 =?utf-8?B?dUQwYzNjWEpxMm0xSklxUldFcGp2bVY4cjVqQjRPS1dOb2YrcFFiWHE3UjUz?=
 =?utf-8?B?bEVJbmdLSDRWVEpVUTJwZnlvOUlwT0ZYd2pxTnJjSjlyVWdsaXp2cnFuazZt?=
 =?utf-8?B?M3g1b3JxM2VlY2tzZ3BmMHMxKzRCd0l4R0wzTC83cFFnbFdOaHRuMGVuWXRw?=
 =?utf-8?B?ZUY3YkJhVFVVeHBKYm53VU1NaDR3Vlg0a0t0MEIzQ1lINXhyZ1g4TFA1alRz?=
 =?utf-8?B?Q0c1WVNhYWNCaFlKY09mK1hjQ0QrWU5GdzVDYXVWM0hleVJxY21BcG5tTm9W?=
 =?utf-8?B?b09tWUJIYUVYVENBQjB5ZDJSS3BXQ0l1M0ZNdkRyK3A3RFh1YUFpd1BOYVMy?=
 =?utf-8?B?R3ZMdWdYbFhGR2VTT2FKSGZ6ZFd6dUU5ZjNpOEx4ZDBCclhYVWt1Lzh4bFY4?=
 =?utf-8?B?QUkyS3dnZ3grOUNzUDJmYlJkeDFMeUw3VnNjMWx5a2srYkR3ZXdYd2FQOFhv?=
 =?utf-8?B?dDExSWRzd0N6eituMGR0clVBYXJsMG9EdEI5bWtMSTYrUXNkQWY4VGZ5OHZ3?=
 =?utf-8?B?ODVNdUdzblJwSThIRFBQRmtZYU5FbFA0b2NCY00xWHFUc0l4MmcvSGNzNEt4?=
 =?utf-8?B?QlpJUE4ybjBpR1d4ZUFrTGF0YTZnNTR3bWdxVU1GdE8yYlorcVdMaS96OGZZ?=
 =?utf-8?B?b05xMVlnUTNuUENjaFRUVHFqZmQ1WEVrbDlqdUFEd0J5cGtrTGxvcjM2bytD?=
 =?utf-8?B?VHJMbFcvZzVwSExSdlRXOTBDZStGQ0NsVGFXQXQxdGNrZlZEV3BCcFNtZWhF?=
 =?utf-8?Q?ZwUJr7uV8EKdxWg9uG4sIp3s/?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 716dba91-4422-4f35-e9d7-08db515dc42e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 13:52:16.7831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3tEYhmZxFVof0ItVA7rmOqTFsXLhDEy+osMRga5dCNc7Q4itGak3nDGcxVE21rbINcLH/SM+idDd9dQjua1wtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6521
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
ZHVtYXpldEBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAxMCwgMjAyMyA3OjI1
IFBNDQo+IFRvOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT4NCj4gQ2M6IFNo
YWtlZWwgQnV0dCA8c2hha2VlbGJAZ29vZ2xlLmNvbT47IExpbnV4IE1NIDxsaW51eC1tbUBrdmFj
ay5vcmc+Ow0KPiBDZ3JvdXBzIDxjZ3JvdXBzQHZnZXIua2VybmVsLm9yZz47IFBhb2xvIEFiZW5p
IDxwYWJlbmlAcmVkaGF0LmNvbT47DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVs
Lm9yZzsgQnJhbmRlYnVyZywgSmVzc2UNCj4gPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsg
U3Jpbml2YXMsIFN1cmVzaA0KPiA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4sIFRp
bSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT47IFlvdSwNCj4gTGl6aGVuIDxsaXpoZW4ueW91QGlu
dGVsLmNvbT47IGVyaWMuZHVtYXpldEBnbWFpbC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+c2tf
Zm9yd2FyZF9hbGxvYyBhcyBhIHByb3Blcg0KPiBzaXplDQo+IA0KPiBPbiBXZWQsIE1heSAxMCwg
MjAyMyBhdCAxOjEx4oCvUE0gWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+
IHdyb3RlOg0KPiA+DQo+ID4gSGkgU2hha2VlbCwgRXJpYyBhbmQgYWxsLA0KPiA+DQo+ID4gSG93
IGFib3V0IGFkZGluZyBtZW1vcnkgcHJlc3N1cmUgY2hlY2tpbmcgaW4gc2tfbWVtX3VuY2hhcmdl
KCkgdG8NCj4gPiBkZWNpZGUgaWYga2VlcCBwYXJ0IG9mIG1lbW9yeSBvciBub3QsIHdoaWNoIGNh
biBoZWxwIGF2b2lkIHRoZSBpc3N1ZQ0KPiA+IHlvdSBmaXhlZCBhbmQgdGhlIHByb2JsZW0gd2Ug
ZmluZCBvbiB0aGUgc3lzdGVtIHdpdGggbW9yZSBDUFVzLg0KPiA+DQo+ID4gVGhlIGNvZGUgZHJh
ZnQgaXMgbGlrZSB0aGlzOg0KPiA+DQo+ID4gc3RhdGljIGlubGluZSB2b2lkIHNrX21lbV91bmNo
YXJnZShzdHJ1Y3Qgc29jayAqc2ssIGludCBzaXplKSB7DQo+ID4gICAgICAgICBpbnQgcmVjbGFp
bWFibGU7DQo+ID4gICAgICAgICBpbnQgcmVjbGFpbV90aHJlc2hvbGQgPSBTS19SRUNMQUlNX1RI
UkVTSE9MRDsNCj4gPg0KPiA+ICAgICAgICAgaWYgKCFza19oYXNfYWNjb3VudChzaykpDQo+ID4g
ICAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiAgICAgICAgIHNrLT5za19mb3J3YXJkX2FsbG9j
ICs9IHNpemU7DQo+ID4NCj4gPiAgICAgICAgIGlmIChtZW1fY2dyb3VwX3NvY2tldHNfZW5hYmxl
ZCAmJiBzay0+c2tfbWVtY2cgJiYNCj4gPiAgICAgICAgICAgICBtZW1fY2dyb3VwX3VuZGVyX3Nv
Y2tldF9wcmVzc3VyZShzay0+c2tfbWVtY2cpKSB7DQo+ID4gICAgICAgICAgICAgICAgIHNrX21l
bV9yZWNsYWltKHNrKTsNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICAgICAgICAg
fQ0KPiA+DQo+ID4gICAgICAgICByZWNsYWltYWJsZSA9IHNrLT5za19mb3J3YXJkX2FsbG9jIC0N
Cj4gPiBza191bnVzZWRfcmVzZXJ2ZWRfbWVtKHNrKTsNCj4gPg0KPiA+ICAgICAgICAgaWYgKHJl
Y2xhaW1hYmxlID4gcmVjbGFpbV90aHJlc2hvbGQpIHsNCj4gPiAgICAgICAgICAgICAgICAgcmVj
bGFpbWFibGUgLT0gcmVjbGFpbV90aHJlc2hvbGQ7DQo+ID4gICAgICAgICAgICAgICAgIF9fc2tf
bWVtX3JlY2xhaW0oc2ssIHJlY2xhaW1hYmxlKTsNCj4gPiAgICAgICAgIH0NCj4gPiB9DQo+ID4N
Cj4gPiBJJ3ZlIHJ1biBhIHRlc3Qgd2l0aCB0aGUgbmV3IGNvZGUsIHRoZSByZXN1bHQgbG9va3Mg
Z29vZCwgaXQgZG9lcyBub3QNCj4gPiBpbnRyb2R1Y2UgbGF0ZW5jeSwgUlBTIGlzIHRoZSBzYW1l
Lg0KPiA+DQo+IA0KPiBJdCB3aWxsIG5vdCB3b3JrIGZvciBzb2NrZXRzIHRoYXQgYXJlIGlkbGUs
IGFmdGVyIGEgYnVyc3QuDQo+IElmIHdlIHJlc3RvcmUgcGVyIHNvY2tldCBjYWNoZXMsIHdlIHdp
bGwgbmVlZCBhIHNocmlua2VyLg0KPiBUcnVzdCBtZSwgd2UgZG8gbm90IHdhbnQgdGhhdCBraW5k
IG9mIGJpZyBoYW1tZXIsIGNydXNoaW5nIGxhdGVuY2llcy4NCj4gDQo+IEhhdmUgeW91IHRyaWVk
IHRvIGluY3JlYXNlIGJhdGNoIHNpemVzID8NCg0KSSBqdXMgcGlja2VkIHVwIDI1NiBhbmQgMTAy
NCBmb3IgYSB0cnksIGJ1dCBubyBoZWxwLCB0aGUgb3ZlcmhlYWQgc3RpbGwgZXhpc3RzLg0KDQo+
IA0KPiBBbnkga2luZCBvZiBjYWNoZSAoZXZlbiBwZXItY3B1KSBtaWdodCBuZWVkIHNvbWUgYWRq
dXN0bWVudCB3aGVuIGNvcmUNCj4gY291bnQgb3IgZXhwZWN0ZWQgdHJhZmZpYyBpcyBpbmNyZWFz
aW5nLg0KPiBUaGlzIHdhcyBzb21laG93IGhpbnRlZCBpbg0KPiBjb21taXQgMTgxM2U1MWVlY2Uw
YWQ2ZjRhYWNhZWI3MzhlN2NjZWQ0NmZlYjQ3MA0KPiBBdXRob3I6IFNoYWtlZWwgQnV0dCA8c2hh
a2VlbGJAZ29vZ2xlLmNvbT4NCj4gRGF0ZTogICBUaHUgQXVnIDI1IDAwOjA1OjA2IDIwMjIgKzAw
MDANCj4gDQo+ICAgICBtZW1jZzogaW5jcmVhc2UgTUVNQ0dfQ0hBUkdFX0JBVENIIHRvIDY0DQo+
IA0KPiANCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21lbWNvbnRyb2wuaCBiL2lu
Y2x1ZGUvbGludXgvbWVtY29udHJvbC5oIGluZGV4DQo+IDIyMmQ3MzcwMTM0YzczZTU5ZmRiZGY1
OThlZDhkNjY4OTdkYmJmMWQuLjA0MTgyMjlkMzBjMjVkMTE0MTMyYTFlDQo+IGQ0NmFjMDEzNThj
ZjIxNDI0DQo+IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L21lbWNvbnRyb2wuaA0KPiAr
KysgYi9pbmNsdWRlL2xpbnV4L21lbWNvbnRyb2wuaA0KPiBAQCAtMzM0LDcgKzMzNCw3IEBAIHN0
cnVjdCBtZW1fY2dyb3VwIHsNCj4gICAqIFRPRE86IG1heWJlIG5lY2Vzc2FyeSB0byB1c2UgYmln
IG51bWJlcnMgaW4gYmlnIGlyb25zIG9yIGR5bmFtaWMgYmFzZWQNCj4gb2YgdGhlDQo+ICAgKiB3
b3JrbG9hZC4NCj4gICAqLw0KPiAtI2RlZmluZSBNRU1DR19DSEFSR0VfQkFUQ0ggNjRVDQo+ICsj
ZGVmaW5lIE1FTUNHX0NIQVJHRV9CQVRDSCAxMjhVDQo+IA0KPiAgZXh0ZXJuIHN0cnVjdCBtZW1f
Y2dyb3VwICpyb290X21lbV9jZ3JvdXA7DQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQv
c29jay5oIGIvaW5jbHVkZS9uZXQvc29jay5oIGluZGV4DQo+IDY1NmVhODlmNjBmZjkwZDYwMGQx
NmY0MDMwMjAwMGRiNjQwNTdjNjQuLjgyZjZhMjg4YmU2NTBmODg2YjIwN2U2YQ0KPiA1ZTYyYTFk
NWRkYTgwOGIwDQo+IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL25ldC9zb2NrLmgNCj4gKysrIGIv
aW5jbHVkZS9uZXQvc29jay5oDQo+IEBAIC0xNDMzLDggKzE0MzMsOCBAQCBza19tZW1vcnlfYWxs
b2NhdGVkKGNvbnN0IHN0cnVjdCBzb2NrICpzaykNCj4gICAgICAgICByZXR1cm4gcHJvdG9fbWVt
b3J5X2FsbG9jYXRlZChzay0+c2tfcHJvdCk7DQo+ICB9DQo+IA0KPiAtLyogMSBNQiBwZXIgY3B1
LCBpbiBwYWdlIHVuaXRzICovDQo+IC0jZGVmaW5lIFNLX01FTU9SWV9QQ1BVX1JFU0VSVkUgKDEg
PDwgKDIwIC0gUEFHRV9TSElGVCkpDQo+ICsvKiAyIE1CIHBlciBjcHUsIGluIHBhZ2UgdW5pdHMg
Ki8NCj4gKyNkZWZpbmUgU0tfTUVNT1JZX1BDUFVfUkVTRVJWRSAoMSA8PCAoMjEgLSBQQUdFX1NI
SUZUKSkNCj4gDQo+ICBzdGF0aWMgaW5saW5lIHZvaWQNCj4gIHNrX21lbW9yeV9hbGxvY2F0ZWRf
YWRkKHN0cnVjdCBzb2NrICpzaywgaW50IGFtdCkNCj4gDQo+IA0KPiANCj4gDQo+IA0KPiANCj4g
PiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBTaGFrZWVsIEJ1dHQg
PHNoYWtlZWxiQGdvb2dsZS5jb20+DQo+ID4gPiBTZW50OiBXZWRuZXNkYXksIE1heSAxMCwgMjAy
MyAxMjoxMCBBTQ0KPiA+ID4gVG86IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47
IExpbnV4IE1NIDxsaW51eC0NCj4gPiA+IG1tQGt2YWNrLm9yZz47IENncm91cHMgPGNncm91cHNA
dmdlci5rZXJuZWwub3JnPg0KPiA+ID4gQ2M6IFpoYW5nLCBDYXRoeSA8Y2F0aHkuemhhbmdAaW50
ZWwuY29tPjsgUGFvbG8gQWJlbmkNCj4gPiA+IDxwYWJlbmlAcmVkaGF0LmNvbT47IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gPiA+IEJyYW5kZWJ1cmcsIEplc3NlIDxq
ZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47IFNyaW5pdmFzLCBTdXJlc2gNCj4gPiA+IDxzdXJl
c2guc3Jpbml2YXNAaW50ZWwuY29tPjsgQ2hlbiwgVGltIEMgPHRpbS5jLmNoZW5AaW50ZWwuY29t
PjsNCj4gPiA+IFlvdSwgTGl6aGVuIDxsaXpoZW4ueW91QGludGVsLmNvbT47IGVyaWMuZHVtYXpl
dEBnbWFpbC5jb207DQo+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4gPiBTdWJqZWN0
OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvMl0gbmV0OiBLZWVwIHNrLT5za19mb3J3YXJkX2FsbG9j
IGFzDQo+ID4gPiBhIHByb3BlciBzaXplDQo+ID4gPg0KPiA+ID4gK2xpbnV4LW1tICYgY2dyb3Vw
DQo+ID4gPg0KPiA+ID4gVGhyZWFkOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMzA1
MDgwMjA4MDEuMTA3MDItMS0NCj4gPiA+IGNhdGh5LnpoYW5nQGludGVsLmNvbS8NCj4gPiA+DQo+
ID4gPiBPbiBUdWUsIE1heSA5LCAyMDIzIGF0IDg6NDPigK9BTSBFcmljIER1bWF6ZXQgPGVkdW1h
emV0QGdvb2dsZS5jb20+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+IFsuLi5dDQo+ID4g
PiA+IFNvbWUgbW0gZXhwZXJ0cyBzaG91bGQgY2hpbWUgaW4sIHRoaXMgaXMgbm90IGEgbmV0d29y
a2luZyBpc3N1ZS4NCj4gPiA+DQo+ID4gPiBNb3N0IG9mIHRoZSBNTSBmb2xrcyBhcmUgYnVzeSBp
biBMU0ZNTSB0aGlzIHdlZWsuIEkgd2lsbCB0YWtlIGEgbG9vaw0KPiA+ID4gYXQgdGhpcyBzb29u
Lg0K

