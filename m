Return-Path: <netdev+bounces-1620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F626FE8FB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 756AE2810D3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 00:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44341622;
	Thu, 11 May 2023 00:54:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B30620
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:54:46 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299B91719;
	Wed, 10 May 2023 17:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683766484; x=1715302484;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IBkdCOBw6ZGIPIH0rBLY0HHIrIIviKVRYEjMHuTPOmI=;
  b=jUwBmcbaoOw+BUxEpSTT/qkLIdytW2rXqBaSwbDny3s3cV4DJqVryY56
   3FiD423ZQp2ql5uP1eThpaYqo3D+GPE86VHyRsprHpj+Z1xgcOpsYPcmp
   HJir3BRpx1BCuSEtHwQDaeZ/75Vg93N8Zt6dQ8PXT4ZeJT2EyUYDqEodK
   CHUh6YTStraAsePb/zNtcm1y4XkLlBUwBVxnurv31gh/raXgg5HgGFgCl
   f76fdrULfSMlGBSDEPaBo06YnzMM1dDLJg/18SBmorgSsjQbyjnC1zMLc
   GKMyJPU6SfN10IZxaPFNQDTAOqZCAAUPtqluBaLUmZ/Xc8JfiF+baSwG0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334831273"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="334831273"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 17:53:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="843719024"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="843719024"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 10 May 2023 17:53:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 17:53:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 17:53:33 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 17:53:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIfCTOsGBYinOVCmitLpJ3BgV6brMlIOjhGSZxBMOys9uLSofcS/tTqoBeSCM5xrTR3BvN+emPY7yPKDczZWboqAJuatKnmXNrrVnbl1h1PhkFBMh6pEFT3YheVWfA7rZnfs2ZhDEl1XVt2SP+KIBS+4an8jAKydVNmLBG/ZNwFqPvSpHaxfVYwEPYYQLINnaFtq22gtCZt798lhdVoUhg3b1pADgzlnItKnlj3YwvbbQFDm81SCy5nyd+ojTOtADF6UUrs5NH2jF996fiTUdQpOG+EwoOPg/0Z7BNOjyMjUdIrQ1BTnUcOolln3XD6Cc1Wgl6s7HTU6cFcfGcToFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBkdCOBw6ZGIPIH0rBLY0HHIrIIviKVRYEjMHuTPOmI=;
 b=CunOl0yd7JsHTBlBZhVMaj9bHwk1srcRSRaCbHx25Ltakx4KICD9ccKoifQxMpjq2EFffkviemMczD8gFlzVH2SyoGtFq6Onj0kpx7MA/FuMsmToTylGxSvvB1UKWEiaRb6lq0Ih44OlVXkKR45D/Ar3VI37X72qTpcrds5R8WQ2XIef4dE5/3bN5KHBQ99DsxLQTnsMF255Nz8LxsCI+JF+eg4R888by2jUM0q8GKIJqecs58FMxKq+Fy3CZAPO1l+MCZefl/TQk2pNnp0RAaj8z2zCOISMIxDtUrdOfh8mahpPJDyCvmjkOdiNuyqhbwD+IBdpKVUszL5c29BNhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 00:53:26 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 00:53:26 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>
CC: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
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
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbwgAAVVACAABAwAIAAMNEAgABhfVA=
Date: Thu, 11 May 2023 00:53:26 +0000
Message-ID: <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
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
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
In-Reply-To: <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|SA2PR11MB5052:EE_
x-ms-office365-filtering-correlation-id: cace01e5-e845-40cb-c038-08db51ba20f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1N8fYgl/E9WxBRQRN6J0PHe+Iq0Lp9NSesHCN5/BfZYwHStxPOzblDXxpLTFZ4+pYe9cSBnXiZMUqO4E1RtzvJxcSq4CHo6lNWWGMg9c2zvPVqL0qOK9WrY/ftGfclWsdmDLo/jzsDBZjyvARRYMDESRRPUuOLq99hhG70YA/BwicBUObIzgBl+G1hF7gOu/z5CcOvPI7FyDU38l8ZbSywGcpQthWk+b7bpbbDPcVPAHFwDjInfXw+Tl9YHSa5TQgVR9jULJEw/LpCdmW/+j6gQAG33fQBlx6Mf7ZpDcI9n/kzZYNds9fIn2NEmfmKAJPPZV5IIHAfb6AZAWiDThwV8SInfNz9FhGigUSuKxHkeWJxInH+5wV15rjyLLdOB9q7gYdDk8Ej/KCGIso3lSmiSJiyd/JcLYUfzqkyhvAQIolYMjs4fIuN2D2n2sD3p5G/oc0x7yw4FM1/j6CeMJNmr95gUhj77w750WRqp7sgpbd4O+PnZwmAwMhXf98dgRDOWRyV6g5v5+qAEWj4CCQ9F5SvgdxPpdRCn3Hc4srk72A4OjHGriIrisZuh09uQU8KL1qYluiyKLtwe8uQW53LDQ1uZG0Of+5pQJOSDxIB9Fo7Uj49XjEa17zQnedP1H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199021)(186003)(6506007)(86362001)(83380400001)(55016003)(478600001)(52536014)(8676002)(41300700001)(8936002)(5660300002)(33656002)(4326008)(316002)(2906002)(76116006)(66446008)(66946007)(66476007)(64756008)(6916009)(54906003)(26005)(71200400001)(66556008)(9686003)(7696005)(53546011)(82960400001)(38100700002)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3EwTWNRNWlXN0pQbHJjMkZoTHRuQmxUcGMvWkpmenJNaWdPRTVObUdDM2dN?=
 =?utf-8?B?N0VreGhtaVA4RmZXaWZoQ2gxWHpFR1JNMWtXcUtrbmtrREdxaEpnTklXc25l?=
 =?utf-8?B?NDVQVWY5N05jaGlCbERjTGNDK3NlMVRZUnJsMGI4dkZhcWlsNjJDcXZtVU4r?=
 =?utf-8?B?M3JhWjA2UVlLb3hPekEvYjRzdDUwVlNiKytKZCtRRWVPRnJWRWpmRTJnUXBl?=
 =?utf-8?B?T3FUZG5RSHVGWlpnMi91c3ZKYmtybGtSTDhsT1NFU3hMTmNYU2VRUUl5WDFz?=
 =?utf-8?B?UXpVcGdHOUhQZzlqMDM1dk1ibE81bTNJNUtEMlVUVzRBbk9wR3A3Y1JEbkRK?=
 =?utf-8?B?eFdwb29BdVlOdXBWTlpLUHRwaXNiZ1JKMjd2U0hWN1JJNUVORlVweitOaGQ2?=
 =?utf-8?B?TTNZOUVPWFFJTDdYZVI2eFRIYXNrOGY1N2NoRzZWQWNuY25ScFNiNXpXTDVD?=
 =?utf-8?B?ZCtUN1RWY3V2d3VES2lZOWZQMWtieXNvQjFmZ1RWTFVHOVliSGs3STlUOUdK?=
 =?utf-8?B?WElDbEYzdTgxLzVyVHRoSkNNQUFTNzBrQkNMZG1HSDJ2UHRIby9lMXZteWtX?=
 =?utf-8?B?dU9MRUswUHUrSFZzeEJpWlA2Y0xZMW52dmRRazg1Q3liL2RweDZHZjNNM0VB?=
 =?utf-8?B?NmFTaFQvMS94K0xxQ2NNZGFVSldjQURCTW04ck5TVFhHNDU3NFBFaGxUL0Zl?=
 =?utf-8?B?SnJpQi9EVDVCY2pyNlBzU2doTjYwdUQvRGRPMDBYK1p1dS9wNk92TzFKZ0Q3?=
 =?utf-8?B?Z21UaytoZitURVp4STJRS1h0eDBuTXF6RmkzbGFtZHJWdmZQTldsc1dPT1hm?=
 =?utf-8?B?ckxobm5SUG95TjFNdWROY0g4WFgzRTFmRWNrQXMwZ2I2S3JFYytrMklpVmVa?=
 =?utf-8?B?R3lkRDBnVDlKb3BpOHhYczN2RXY3Vzhwb0xxYVA3REpUOGhHKzR5ZS80cnZh?=
 =?utf-8?B?cnc2cVFmMWg4SW9HMGN5OGpOY2MzQXJxcWd3eGRmWlVEODZEYUU3UEF4elZ2?=
 =?utf-8?B?a0RRMS9waVBQU08rSDdTdmRkNythMUNPRlE2UkI2L0p0eWJJUGFYbENRajZU?=
 =?utf-8?B?MW82cjVyaTVicEEzdUFSVkZCMnpmOFprREhpbWZteUNBOXQ2RjFjaXp3dXVa?=
 =?utf-8?B?ZmF2aWpUcnJieXkwNXNaU2ZDMXhYeDc0NTRoQkJiTDlEYjU1QzM3dmFnemV6?=
 =?utf-8?B?bUczMG1KSDZlcEs4TDZtVW5qTmVsR3FyTnhvbFBqTXdscGdoOHR4ZXNsMFE4?=
 =?utf-8?B?Q1h6dFdlS2VlYStVRXE0MmpRRWhZUWxUczdIWFlWVFVOS3RqUkpMZXlHb0p3?=
 =?utf-8?B?cXlzM2pHc3dQNktORTJBVS9RYTlJRTE1TVdEeUpMdFNJMEpxeXFGZnRzM213?=
 =?utf-8?B?cGcvci9yTjV3SkljNmdGdDc5TVlTNk1xTTEvZUVzMHZzbE9NR1FsKzJNbW9s?=
 =?utf-8?B?ZlY1eHZGbEgzcmpPMmFPeUhLYk1ZQzJwMWZKMC9NNURKdjI3QzN2a1oxTk9C?=
 =?utf-8?B?alhNbmhqNEJoSm14Q1FtaEpNeTd5dkNQS0VFVkV1ckVYekx0OTZiZXdPTDZo?=
 =?utf-8?B?SzZxblFoSVNKWk1jdVlTSktMOU1mNmp5dmdJblFMbHp6bE04cWhVWTF0ZGlQ?=
 =?utf-8?B?QWhOWVl1L2o5YUl5OVhOV3RjRERvenJNdkZNK3dXNUZCM0xZS25XeC9nTlg3?=
 =?utf-8?B?WDdpSVlKcTFHKzFVTWRwbng5ZGU1SDJQeWdMTnA5c2EyVCtxS1BmWGNKYkFh?=
 =?utf-8?B?OU5uUzE0MjFhb2RTc1RhVkptR3pXNThLdlhmSWlDQW1DRU1XcURkNHl5QVBE?=
 =?utf-8?B?OGNSbWNXRHR6TW80NFhFbVpzeGppd2RRQ2xGUFNGaUR2SFA1OHY2V0hxeXNi?=
 =?utf-8?B?aGorNzlpVG5XdzZ6Q1FhQTR3QWJldjNvNDcwZjgvT2U2ZithODkrMzlndlo4?=
 =?utf-8?B?R3ZkSkFnWlNIUFUwaDRNUW5lNXVSbHlEZnlRRkJwNDFvWWVmMDB6RGFnZFQ5?=
 =?utf-8?B?WXVqQjVHdXRsU1h6UG0wQWtVcGo4cG5lNFY4MXNxWTJCOTFpbmZoTWZuYVZ4?=
 =?utf-8?B?UnBJM05vZG53QzlFTWx2WlNiYVpadWhOd2J2SitvcVNSNnA4RDJVZDdHNUlu?=
 =?utf-8?Q?ho5Rpbeck/01zDAe+yO1IT/Nb?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cace01e5-e845-40cb-c038-08db51ba20f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 00:53:26.1802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vOOX6D6+70Cq0StMjKFegSJhIx3OdeQj/YZ/jVBsBWDQWm4l89EEIivXRcp/BEcRZBhPBytLIFOHjmdOZS6AuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5052
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hha2VlbCBCdXR0IDxz
aGFrZWVsYkBnb29nbGUuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDExLCAyMDIzIDM6MDAg
QU0NCj4gVG86IFpoYW5nLCBDYXRoeSA8Y2F0aHkuemhhbmdAaW50ZWwuY29tPg0KPiBDYzogRXJp
YyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgTGludXggTU0gPGxpbnV4LQ0KPiBtbUBr
dmFjay5vcmc+OyBDZ3JvdXBzIDxjZ3JvdXBzQHZnZXIua2VybmVsLm9yZz47IFBhb2xvIEFiZW5p
DQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVs
Lm9yZzsNCj4gQnJhbmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsg
U3Jpbml2YXMsIFN1cmVzaA0KPiA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4sIFRp
bSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT47IFlvdSwNCj4gTGl6aGVuIDxsaXpoZW4ueW91QGlu
dGVsLmNvbT47IGVyaWMuZHVtYXpldEBnbWFpbC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+c2tf
Zm9yd2FyZF9hbGxvYyBhcyBhIHByb3Blcg0KPiBzaXplDQo+IA0KPiBPbiBXZWQsIE1heSAxMCwg
MjAyMyBhdCA5OjA54oCvQU0gWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+
IHdyb3RlOg0KPiA+DQo+ID4NCj4gWy4uLl0NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEhhdmUgeW91
IHRyaWVkIHRvIGluY3JlYXNlIGJhdGNoIHNpemVzID8NCj4gPiA+ID4NCj4gPiA+ID4gSSBqdXMg
cGlja2VkIHVwIDI1NiBhbmQgMTAyNCBmb3IgYSB0cnksIGJ1dCBubyBoZWxwLCB0aGUgb3Zlcmhl
YWQgc3RpbGwNCj4gZXhpc3RzLg0KPiA+ID4NCj4gPiA+IFRoaXMgbWFrZXMgbm8gc2Vuc2UgYXQg
YWxsLg0KPiA+DQo+ID4gRXJpYywNCj4gPg0KPiA+IEkgYWRkZWQgYSBwcl9pbmZvIGluIHRyeV9j
aGFyZ2VfbWVtY2coKSB0byBwcmludCBucl9wYWdlcyBpZiBucl9wYWdlcw0KPiA+ID49IE1FTUNH
X0NIQVJHRV9CQVRDSCwgZXhjZXB0IGl0IHByaW50cyA2NCBkdXJpbmcgdGhlIGluaXRpYWxpemF0
aW9uDQo+ID4gb2YgaW5zdGFuY2VzLCB0aGVyZSBpcyBubyBvdGhlciBvdXRwdXQgZHVyaW5nIHRo
ZSBydW5uaW5nLiBUaGF0IG1lYW5zDQo+ID4gbnJfcGFnZXMgaXMgbm90IG92ZXIgNjQsIEkgZ3Vl
c3MgdGhhdCBtaWdodCBiZSB0aGUgcmVhc29uIHdoeSB0bw0KPiA+IGluY3JlYXNlIE1FTUNHX0NI
QVJHRV9CQVRDSCBkb2Vzbid0IGFmZmVjdCB0aGlzIGNhc2UuDQo+ID4NCj4gDQo+IEkgYW0gYXNz
dW1pbmcgeW91IGluY3JlYXNlZCBNRU1DR19DSEFSR0VfQkFUQ0ggdG8gMjU2IGFuZCAxMDI0IGJ1
dA0KPiB0aGF0IGRpZCBub3QgaGVscC4gVG8gbWUgdGhhdCBqdXN0IG1lYW5zIHRoZXJlIGlzIGEg
ZGlmZmVyZW50IGJvdHRsZW5lY2sgaW4gdGhlDQo+IG1lbWNnIGNoYXJnaW5nIGNvZGVwYXRoLiBD
YW4geW91IHBsZWFzZSBzaGFyZSB0aGUgcGVyZiBwcm9maWxlPyBQbGVhc2UNCj4gbm90ZSB0aGF0
IG1lbWNnIGNoYXJnaW5nIGRvZXMgYSBsb3Qgb2Ygb3RoZXIgdGhpbmdzIGFzIHdlbGwgbGlrZSB1
cGRhdGluZw0KPiBtZW1jZyBzdGF0cyBhbmQgY2hlY2tpbmcgKGFuZCBlbmZvcmNpbmcpIG1lbW9y
eS5oaWdoIGV2ZW4gaWYgeW91IGhhdmUgbm90DQo+IHNldCBtZW1vcnkuaGlnaC4NCg0KVGhhbmtz
IFNoYWtlZWwhIEkgd2lsbCBjaGVjayBtb3JlIGRldGFpbHMgb24gd2hhdCB5b3UgbWVudGlvbmVk
LiBXZSB1c2UNCiJzdWRvIHBlcmYgdG9wIC1wICQoZG9ja2VyIGluc3BlY3QgLWYgJ3t7LlN0YXRl
LlBpZH19JyBtZW1jYWNoZWRfMikiIHRvIG1vbml0b3INCm9uZSBvZiB0aG9zZSBpbnN0YW5jZXMs
IGFuZCBhbHNvIHVzZSAic3VkbyBwZXJmIHRvcCIgdG8gY2hlY2sgdGhlIG92ZXJoZWFkIGZyb20N
CnN5c3RlbSB3aWRlLg0K

