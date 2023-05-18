Return-Path: <netdev+bounces-3645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32CB9708291
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE57F2814C2
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7985423C8E;
	Thu, 18 May 2023 13:24:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFB723C67
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:24:53 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEF1EC;
	Thu, 18 May 2023 06:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684416291; x=1715952291;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AGtaHjcqjwF8Rl1xl4oNltezqW03kNs+5inYzJJPwQQ=;
  b=CQhPgg/SQivwkzMsxbchn1HNibqgJqEhCNeinv+YuIqat+9k1gREhOIv
   ehFau1aWZF1khs2swU7YLzlqzHZ6+OCyeHrCVC2JbJpWzukOYvEUpaaY6
   3mIVOoGOAckhptwR8BNApBTCpjIgx5z2OG3TWChIzT7kCRopHzKUid0sf
   oHUUjCsZ5S6i73WwPtLH9NBlpGuhTr5gm1BjWmGJmiAMU0m2wQTI+I58j
   5T9Gh3X/dCr9DGGnP2h418EN166v+/LImsmkjVTtlTVP/uht08/Bb5w6S
   CeY08uYEM/tNqOo2S5aaug2P/+OndctG1jTswI49V5exXV5c7QKIQX47w
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="438405130"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="438405130"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 06:24:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="791973469"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="791973469"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 18 May 2023 06:24:50 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:24:50 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:24:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 06:24:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 06:24:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUC0HL/T6unGpzX6sls/bxXlRafeaCaeHTkVdAaUcu5qI0L4VJBtj+XwbHkJ4Tc14ceZRUL99m1RYLgv6GyFCweoOiP1mjuJMUmCjVkXkIzaaauyq/a5iMCviluqLA0qTKN6/OnJB6tlwOqxY5cE3WR9nXjwBt+GUml4g9fxRBWj/f7shCXFtd0lTqDG8/+v06RB6yHf3r3vzJXku90tZXpSWmmbLgp9XILKy+UrVSgoIovIm6hgHsXdluMep+39OLAz/DH45dQTj3BXToX8fDYxyUr2Dzk5d4A/hKS0ZYBB6u8RXFe3hwla48eduZBkzCYCLK/AsIXA9IF2DQyXSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xL5yWzEWJ8ZHcv+09TbSMCxmVqLcF2Z0wM58M4Shnjs=;
 b=T77e87bGZc28xkfQxOLFXKJPPuTlMkdmF8APvM5JpV1g8loWVenE6LM83KV32vy6sRVL6ryJTgqZ1Ye00RBj1ReIgMwErTEs8tx4b4EHqu1E8GkwJeX6ZPj4XTdo907Sctgmj6gkfLEQb6rXmn7++FueKVmV9DLVvHJc97W+0JgFGm/lOv52AFqLYb/UgxmIx4/E88J9pj3izh4Jq5Rqf4L0wDm/QrWwc67xD7y2VUeg0IQzsSN0K+SGqrq5bdsWR3UptAPYuniybFgtofuEpW1tIc7xMhs4R9Qoz2AK6miisEnsvxZ1cK9xqYGfJl/jO4HoyHyPY0EnHb+sNe4ghg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 BN9PR11MB5401.namprd11.prod.outlook.com (2603:10b6:408:11a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 13:24:46 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%6]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 13:24:45 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Jakub Kicinski <kuba@kernel.org>, Vadim Fedorenko <vadfed@meta.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgACdH4CAChnlwIAABXaAgACPXPCABdNcAIABvNIAgAAqKQCAAw+/YA==
Date: Thu, 18 May 2023 13:24:45 +0000
Message-ID: <DM6PR11MB4657BD5424F8845A0BB9AF119B7F9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com> <ZFOe1sMFtAOwSXuO@nanopsycho>
 <20230504142451.4828bbb5@kernel.org>
 <MN2PR11MB46645511A6C93F5C98A8A66F9B749@MN2PR11MB4664.namprd11.prod.outlook.com>
 <ZFygbd1H+VdvCTyH@nanopsycho>
 <DM6PR11MB4657924148B84F502A44903D9B749@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGH7uvxD55Pan0gf@nanopsycho>
 <DM6PR11MB4657670163F45823F66B28619B799@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZGOUPCxCzVNuOrDZ@nanopsycho>
In-Reply-To: <ZGOUPCxCzVNuOrDZ@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|BN9PR11MB5401:EE_
x-ms-office365-filtering-correlation-id: 5d0271be-32b5-448f-c94a-08db57a33f39
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3RFQrzZxixaDlOFUkpLbAV2ZfsQldNYMAJgGkw9Yt3lJI1kGuNKbCCi4dTE9IVdt4Q6fxYJK9Eq0DujjfpSW+VPbk/n0inWTrqg9uZ9ZaMUtQlINHCTvuAYH9x2ZMQk0FzsG8H20CL43MaDszTywjHDwmbJKv5n4rMX8UU43Ln+nFwF+IU+LwE608oIJ+XNQsag9FX+URwRLhctTC/z0wwQpRNg5daFLce46Cd4VVJInJ0XnlzbN9ReJqCw5XwizYy/InI1atcTPsRzGG86BBy5EkIFCGYqq0drYCnj0J4AEJDrHCn6kzMfKM0XNtnXaBThfHhUf+vOobMMyIbyQhxoMR4Dawk4Qn6Gtb4silFuE/lGBjpbCWZEK8zkfnINrO25QY6m7FBeoNuDRHT/oblfrt4+Zt517LkRuLqpu+g64YmYDOzupLyHOaHKZNdmdDHmWl9LNFsqz4f46bz/x6Zi00qJ9iBc5/zpNKHpKKBYAY+Eiag/ZE1QAagaMwuAKkBZ3kYQ3q8S51imL1sLpBoDY7UzUVPXuxrANWT6QLkSFBR3cTw2am+wTkXU2lqRYOrugwFXq+c1nyXjV44Qou32GmeHu/UE8idNLo0BT1Sr3PuClIGavugb/rNbn0bUw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(26005)(9686003)(6506007)(7696005)(83380400001)(33656002)(86362001)(38070700005)(38100700002)(82960400001)(55016003)(122000001)(186003)(54906003)(7416002)(478600001)(2906002)(316002)(8936002)(6916009)(4326008)(8676002)(41300700001)(52536014)(5660300002)(64756008)(66476007)(66446008)(66556008)(76116006)(66946007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/2lcHkT6usx4BTMQqQphM/0pws+esidthW1OhGGqZfCNvPCXTubEElynXS1p?=
 =?us-ascii?Q?t8SAgUJxnygDn6AxqqmHj8fodWPJKNbDWyhlwiItPJHwHqBvZvzxfKVGa1yM?=
 =?us-ascii?Q?gWgPhJpQxLYYIvLL37/gx2Bi4iPCsKIwFfvzU3mNIvqtJPoXOu6HZVnyYnF+?=
 =?us-ascii?Q?1h1kd4yDs2r1HWvjoR35+ZPfFdQRfQ6KYtf+4Qgor5ARjS+XtcE1+zc3cdXl?=
 =?us-ascii?Q?qKzpAms/1SqUR6MI3DKn/QrooxpwxRwaWhEGxq0/bjABu7E0LYU3jJnN5Zhc?=
 =?us-ascii?Q?LIpedZlccrWOKTcwMfH4eT3SwRU3wpElB5BnfyAmEZDGAFE7BSB0wKdXsDct?=
 =?us-ascii?Q?Fu+of4hw9Hnai07CoyF7ZCUfbyPHwVgJkI+4tPvnkn6vcIraDZsYWn7cZI7w?=
 =?us-ascii?Q?AfPVkcJgp45rZWubrnqqXnEKFiLm6GJWctibGyD/d8Eh1sM3Ex5OWOK5Cwue?=
 =?us-ascii?Q?2crmfSKuoRi2TPTXw4bnXKUjIWM+DAVvNSbxpZO3AKxn8L6n2J1+9f4zO+6s?=
 =?us-ascii?Q?X4OWD3hpJJN+3/GSVn1uVRkakHPCXHmNFw/uVWYIvtzPaRO7LrLfYBTvbc1U?=
 =?us-ascii?Q?gH5B/HalIMX7V15jKxuGsFg1tseP0usxngi/EN2F0lbc1lNl70R2tbEr2P5t?=
 =?us-ascii?Q?3K2sihMmlULQz1/7UUwnMFAiSEgDvIvf2QzapIoULD2wZ8KceVX4aWao8ht+?=
 =?us-ascii?Q?LXfbsLNjMFNp5itTZSGVuduqntBoXNs1v8ap+ddaxZsGOq/Qbg2khYCuftA6?=
 =?us-ascii?Q?nHcA1o1MI25W0ZGvrhTHIStpKpGCCezQXsSsXRs7wRGHE4gjavsJzsyDxYO0?=
 =?us-ascii?Q?3ra8JtbKIOwUZhivm2qeHFhwj76BV2Nspx3sgbfIq3E3Xzpaqa6KQScDhtht?=
 =?us-ascii?Q?/x15ny/eyp4BNiY6NReHEorK7YWvZMJfkex702QzKkxPfLB+poBcKwQGRicI?=
 =?us-ascii?Q?yK5jfRHqhLODjhRg4FI03SceOAaMltQTCbMsBYx9oukcd/BTtalNlOXFLo5e?=
 =?us-ascii?Q?/s+YwyOdni/4e+KcYLGTGnlMXXvC5P4Vk4F8gK9NYWJJKtRn1ec5njxuOSTF?=
 =?us-ascii?Q?QHvKYcqxMc0rPdKMXUPqvhehDWZaiIef3enzhFLb4tdR7vcp66n6YD1iQt9K?=
 =?us-ascii?Q?7HRdtNb9sVgxqMg0CJkQaVHJUFyWJNnTXwHpkP/OwmhvguxGUjGvQmJJtzUm?=
 =?us-ascii?Q?m+Ke8CUhvljGTd79F/fCvuk/EpZ9j/U1PCpMiG9fKzaT7QU8ew0+GPRIkXhD?=
 =?us-ascii?Q?Klrj6qruAVJhUq6HEvamXbILtMg3ZVSRgTubIRKBxFEW2YhTkzV2xIwwHP7V?=
 =?us-ascii?Q?RODApqAI2duw2QSqzIeKgz9pj/Bf7O+TZhMLyJaVfWYDd8ZdEPcuWCxOaIOf?=
 =?us-ascii?Q?E3zhDhn9pnzh9+QruhkTyZ3uDCvBN6QXbBLxs5jPgZv+TbeRd1wQQeVVlbTj?=
 =?us-ascii?Q?hAhlkWyTv8M2bbdiCyHqAsPCgtED1ApHgTUe0tmMMF51q0UyD7Ex2uAYaOks?=
 =?us-ascii?Q?wYVicOd1vqGbrBG17niTQU1YVVFtntcLYwCXHd9NYvkJtsHNPal0ckRmiB+W?=
 =?us-ascii?Q?8aWDhxHcjxLl8au7Jnes7a+IQYXlxdn+QbBBAAAkgCAASjarkzzN7pqPuioS?=
 =?us-ascii?Q?Jw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0271be-32b5-448f-c94a-08db57a33f39
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 13:24:45.4833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HcHiFrXpg93vPO11PL5xY81YySFQJC+fuMlT5yeIz00EdH/D6L3dIGEVTRZuslpzR8dHq+A9ykra5/mVuoo87ap91FxSRUbOu7pTUHxs4YA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5401
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, May 16, 2023 4:34 PM
>
>Tue, May 16, 2023 at 02:05:38PM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Monday, May 15, 2023 11:31 AM
>>>
>>>Thu, May 11, 2023 at 10:51:43PM CEST, arkadiusz.kubalewski@intel.com wro=
te:
>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>Sent: Thursday, May 11, 2023 10:00 AM
>>>>>
>>>>>Thu, May 11, 2023 at 09:40:26AM CEST, arkadiusz.kubalewski@intel.com
>>>>>wrote:
>>>>>>>From: Jakub Kicinski <kuba@kernel.org>
>>>>>>>Sent: Thursday, May 4, 2023 11:25 PM
>>>>>>>
>>>>>>>On Thu, 4 May 2023 14:02:30 +0200 Jiri Pirko wrote:
>>>>>>>> >+definitions:
>>>>>>>> >+  -
>>>>>>>> >+    type: enum
>>>>>>>> >+    name: mode
>>>>>>>> >+    doc: |
>>>>>>>> >+      working-modes a dpll can support, differentiate if and how
>>>>>>>> >dpll selects
>>>>>>>> >+      one of its sources to syntonize with it, valid values for
>>>>>>>> >DPLL_A_MODE
>>>>>>>> >+      attribute
>>>>>>>> >+    entries:
>>>>>>>> >+      -
>>>>>>>> >+        name: unspec
>>>>>>>>
>>>>>>>> In general, why exactly do we need unspec values in enums and CMDs=
?
>>>>>>>> What is the usecase. If there isn't please remove.
>>>>>>>
>>>>>>>+1
>>>>>>>
>>>>>>
>>>>>>Sure, fixed.
>>>>>>
>>>>>>>> >+        doc: unspecified value
>>>>>>>> >+      -
>>>>>>>> >+        name: manual
>>>>>>>
>>>>>>>I think the documentation calls this "forced", still.
>>>>>>>
>>>>>>
>>>>>>Yes, good catch, fixed docs.
>>>>>>
>>>>>>>> >+        doc: source can be only selected by sending a request to
>>>>>>>> >dpll
>>>>>>>> >+      -
>>>>>>>> >+        name: automatic
>>>>>>>> >+        doc: highest prio, valid source, auto selected by dpll
>>>>>>>> >+      -
>>>>>>>> >+        name: holdover
>>>>>>>> >+        doc: dpll forced into holdover mode
>>>>>>>> >+      -
>>>>>>>> >+        name: freerun
>>>>>>>> >+        doc: dpll driven on system clk, no holdover available
>>>>>>>>
>>>>>>>> Remove "no holdover available". This is not a state, this is a mod=
e
>>>>>>>> configuration. If holdover is or isn't available, is a runtime inf=
o.
>>>>>>>
>>>>>>>Agreed, seems a little confusing now. Should we expose the system cl=
k
>>>>>>>as a pin to be able to force lock to it? Or there's some extra magic
>>>>>>>at play here?
>>>>>>
>>>>>>In freerun you cannot lock to anything it, it just uses system clock =
from
>>>>>>one of designated chip wires (which is not a part of source pins pool=
) to
>>>>>>feed the dpll. Dpll would only stabilize that signal and pass it furt=
her.
>>>>>>Locking itself is some kind of magic, as it usually takes at least ~1=
5
>>>>>>seconds before it locks to a signal once it is selected.
>>>>>>
>>>>>>>
>>>>>>>> >+      -
>>>>>>>> >+        name: nco
>>>>>>>> >+        doc: dpll driven by Numerically Controlled Oscillator
>>>>>>>
>>>>>>>Noob question, what is NCO in terms of implementation?
>>>>>>>We source the signal from an arbitrary pin and FW / driver does
>>>>>>>the control? Or we always use system refclk and then tune?
>>>>>>>
>>>>>>
>>>>>>Documentation of chip we are using, stated NCO as similar to FREERUN,=
 and
>>>>>>it
>>>>>
>>>>>So how exactly this is different to freerun? Does user care or he woul=
d
>>>>>be fine with "freerun" in this case? My point is, isn't "NCO" some
>>>>>device specific thing that should be abstracted out here?
>>>>>
>>>>
>>>>Sure, it is device specific, some synchronizing circuits would have thi=
s
>>>>capability, while others would not.
>>>>Should be abstracted out? It is a good question.. shall user know that =
he
>>>>is in
>>>>freerun with possibility to control the frequency or not?
>>>>Let's say we remove NCO, and have dpll with enabled FREERUN mode and pi=
ns
>>>>supporting multiple output frequencies.
>>>>How the one would know if those frequencies are supported only in
>>>>MANUAL/AUTOMATIC modes or also in the FREERUN mode?
>>>>In other words: As the user can I change a frequency of a dpll if activ=
e
>>>>mode is FREERUN?
>>>
>>>Okay, I think I'm deep in the DPLL infra you are pushing, but my
>>>understanding that you can control frequency in NCO mode is not present
>>>:/ That only means it may be confusing and not described properly.
>>>How do you control this frequency exactly? I see no such knob.
>>>
>>
>>The set frequency is there already, although we miss phase offset I guess=
.
>
>Yeah, but on a pin, right?
>
>

Yes frequency of an output pin is configurable, phase offset for a dpll or
output is not there, we might think of adding it..

>
>>
>>But I have changed my mind on having this in the kernel..
>>Initially I have added this mode as our HW supports it, while thinking th=
at
>>dpll subsystem shall have this, and we will implement it one day..
>>But as we have not implemented it yet, let's leave work and discussion on
>>this mode for the future, when someone will actually try to implement it.
>
>Yeah, let's drop it then. One less confusing thing to wrap a head around :=
)
>

Dropped.

Thank you!
Arkadiusz

>
>>
>>>Can't the oscilator be modeled as a pin and then you are not in freerun
>>>but locked this "internal pin"? We know how to control frequency there.
>>>
>>
>>Hmm, yeah probably could work this way.
>>
>>
>>Thank you!
>>Arkadiusz
>>
>>>
>>>>
>>>>I would say it is better to have such mode, we could argue on naming
>>>>>though.
>>>>
>>>>>
>>>>>>runs on a SYSTEM CLOCK provided to the chip (plus some stabilization =
and
>>>>>>dividers before it reaches the output).
>>>>>>It doesn't count as an source pin, it uses signal form dedicated wire=
 for
>>>>>>SYSTEM CLOCK.
>>>>>>In this case control over output frequency is done by synchronizer ch=
ip
>>>>>>firmware, but still it will not lock to any source pin signal.
>>>>>>
>>>>>>>> >+    render-max: true
>>>>>>>> >+  -
>>>>>>>> >+    type: enum
>>>>>>>> >+    name: lock-status
>>>>>>>> >+    doc: |
>>>>>>>> >+      provides information of dpll device lock status, valid
>>>>>>>> >>values for
>>>>>>>> >+      DPLL_A_LOCK_STATUS attribute
>>>>>>>> >+    entries:
>>>>>>>> >+      -
>>>>>>>> >+        name: unspec
>>>>>>>> >+        doc: unspecified value
>>>>>>>> >+      -
>>>>>>>> >+        name: unlocked
>>>>>>>> >+        doc: |
>>>>>>>> >+          dpll was not yet locked to any valid source (or is in =
one
>>>>>>>> >of
>>>>>>>> >+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>>>>>>>> >+      -
>>>>>>>> >+        name: calibrating
>>>>>>>> >+        doc: dpll is trying to lock to a valid signal
>>>>>>>> >+      -
>>>>>>>> >+        name: locked
>>>>>>>> >+        doc: dpll is locked
>>>>>>>> >+      -
>>>>>>>> >+        name: holdover
>>>>>>>> >+        doc: |
>>>>>>>> >+          dpll is in holdover state - lost a valid lock or was
>>>>>>>> >forced by
>>>>>>>> >+          selecting DPLL_MODE_HOLDOVER mode
>>>>>>>>
>>>>>>>> Is it needed to mention the holdover mode. It's slightly confusing=
,
>>>>>>>> because user might understand that the lock-status is always "hold=
over"
>>>>>>>> in case of "holdover" mode. But it could be "unlocked", can't it?
>>>>>>>> Perhaps I don't understand the flows there correctly :/
>>>>>>>
>>>>>>>Hm, if we want to make sure that holdover mode must result in holdov=
er
>>>>>>>state then we need some extra atomicity requirements on the SET
>>>>>>>operation. To me it seems logical enough that after setting holdover
>>>>>>>mode we'll end up either in holdover or unlocked status, depending o=
n
>>>>>>>lock status when request reached the HW.
>>>>>>>
>>>>>>
>>>>>>Improved the docs:
>>>>>>        name: holdover
>>>>>>        doc: |
>>>>>>          dpll is in holdover state - lost a valid lock or was forced
>>>>>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>>>>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>>>>>	  if it was not, the dpll's lock-status will remain
>>>>>
>>>>>"if it was not" does not really cope with the sentence above that. Cou=
ld
>>>>>you iron-out the phrasing a bit please?
>>>>
>>>>
>>>>Hmmm,
>>>>        name: holdover
>>>>        doc: |
>>>>          dpll is in holdover state - lost a valid lock or was forced
>>>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>>>          if dpll lock-state was not DPLL_LOCK_STATUS_LOCKED, the
>>>>          dpll's lock-state shall remain DPLL_LOCK_STATUS_UNLOCKED
>>>>          even if DPLL_MODE_HOLDOVER was requested)
>>>>
>>>>Hope this is better?
>>>
>>>Okay.
>>>
>>>>
>>>>
>>>>Thank you!
>>>>Arkadiusz
>>>>
>>>>[...]

