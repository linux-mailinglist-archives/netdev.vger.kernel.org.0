Return-Path: <netdev+bounces-1344-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D85B56FD844
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A914280F2F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75296135;
	Wed, 10 May 2023 07:33:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF9C5686
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:33:32 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE5B1FF6;
	Wed, 10 May 2023 00:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683703990; x=1715239990;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8E85QzoLrD0HZDvr68t+olXePj7qfrXbC7Qm67avPXA=;
  b=KbJU+dtFecMq7Jmyis+4AFqmtXvja4e2nJ3/mT6DpiEUx4KfHHiUPoGl
   d6IjnmA9HZ49HQ6tuFG/ibjpLnWXm1L7V+GjpMUf5kCE/t9zQMgM1FLaE
   CiCVmeydJdR92eopfnYUeK59R4as3JobdPSqRwGMzmA3ViVprryeCoGO8
   FWlNhzIOqq+c+4u3et6wKbrhY5m/IXwLF0TEs/9F472dnHDd1ENwx7fXT
   1sxmRZv5LdavYn0si8GKNQPOiKRpD7b+RQhBsNEwJfNK5n1k484n22uRT
   rHYD8aQ0anEjvF0xyTwse9aDSeViImdbjnAJNMi/xOJV7RUyF4tmP0FCQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="329767663"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="329767663"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 00:32:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="693301097"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="693301097"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 10 May 2023 00:32:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 00:32:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 00:32:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 00:32:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 00:32:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6LiY24rHB+cAQJzdiK00HmuoL33U0/pL6NrQRqq3LaxEGBxdW2ZP667z04ngGa6GjOBBHUW3HMlWEqvsnLn9GFPrK8dZwgOBOedvFANGLeY7i94SevXQfuPwq+RjDZnwDaJl3Jo/iWqyEhEeI0wuC2IdPOO3YPmGu0WnHZ1waIJa6jAzYpLQRDVIaFA+JvW3/KLn2yQ9bpiM1EUL/x3pRZdDrWKS2RAi7GhV5mr5fLilwAWFIVEC75Xlz2Nj5Nc54PvVmO4ejHCHYE6sDmyTs9Gyklz/Q/rplfBYfZFyC6YREsqw+l4dEmO+A3dBmunmqL+kuq/QbgSwwn417gymg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8E85QzoLrD0HZDvr68t+olXePj7qfrXbC7Qm67avPXA=;
 b=IDz5UXGCas0+NZ3WwxpHgA6/SUuJBDUVmxfjucfjuPeAeYA9h6iXcMBNrNQV0MLi+qxhj08wjNiFM6jKvHlHb+jYLvTeqD6/cIvkrQUbiZJCuhXa7fS/OoZNYrswfHyHpYgPjG9On0JpwkKpdL3MhOXQeuOiJUDlfFC6flhjbbLQA7d0uAw6UVOugOCYfssN3tdO4Hn9MEbSL3ApMbB4J9rByWxkPO4ooAtqsvFosAx2NnB96O97KU6/OrbWRs1+f155Bygl/jHsoN0Cu4hntDcBZa6kSLcX2uoxQlco05gZIWqjnDlHrZ0pf3pElcDLu5+en9heNOSf11jeS7W5Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by SJ0PR11MB5120.namprd11.prod.outlook.com (2603:10b6:a03:2d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 07:32:04 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 07:32:03 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>, "Chen, Tim C" <tim.c.chen@intel.com>
CC: "edumazet@google.com" <edumazet@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"You, Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69SMhgAgAAMv4CAAAOcAIAA095QgAAHvMA=
Date: Wed, 10 May 2023 07:32:03 +0000
Message-ID: <CH3PR11MB73458B537328CB4F96BE3497FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230509171910.yka3hucbwfnnq5fq@google.com>
 <DM6PR11MB41078CDC3B97ED88AF71DEBFDC769@DM6PR11MB4107.namprd11.prod.outlook.com>
 <CALvZod7njXsc0JDHxxi_+0c=owNwC6m1g_FieRfY4XkfuTmo1A@mail.gmail.com>
 <CH3PR11MB734547B820C475A465BA6D94FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
In-Reply-To: <CH3PR11MB734547B820C475A465BA6D94FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|SJ0PR11MB5120:EE_
x-ms-office365-filtering-correlation-id: 04d4680d-bdb0-436d-2dc2-08db5128a667
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PXfPFsiQqEAzeLNerC2Sey8562uSpm8velAcl5kJpDM8udv/I6jBOSVDwD6txkZ4lwKMdR7Uhx9HR8rUZoiHrYd5+V+y0tER5Ndq1f+Op8HcQ1eAqiJlhIZfd5kLkw53jbGneh+48WftB7LxmCQRjuvFBqfIKhwKKWQrq5oSGjscmhNCLcNovo0fUlT9p/3p3DmR1SlY2KkkO1hsfsPcSzXvrOqq3+p7GujGAtgRnJMCjnRVp7YqWVQKaq7xuGdeUfRWYWUxZs0wpsnF8MNkGR67VDA/crebFW2thATJ6wdrAS4ITfI2s4aCBVnIbibO7UKDpqH9RZOIZmcu14a95vp6fnkIX8XkvncXHtyaGDPksvNpWepQz2czvQ6chUqDWovVxUz9CYCHTXX0xmWLWAeTM/xUZD4n+7z/WsMsxEeJLmQh8L2MBXvvpLDx2tlWPDxR1Vm+rHmdj0HxzUfh8C2sRjLUCcPrMl1aZk02/sDu6s22+FKsL4lCnPOM+0d23weBX62+CzfQAQj4iZlO1feqc286ZBFfxw4vlw+G9utwyws4Om6ksL+fZJHPYQiKkY09w3Vh5Z9Y+i0K7673FDB4/A7yDKZp1SjyjCZIPSBVxA4rsvHFopQrJGdhgOcZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199021)(54906003)(8676002)(52536014)(41300700001)(316002)(8936002)(110136005)(478600001)(2940100002)(2906002)(71200400001)(66476007)(5660300002)(64756008)(66946007)(66556008)(66446008)(4326008)(76116006)(6636002)(9686003)(7696005)(6506007)(53546011)(26005)(186003)(82960400001)(83380400001)(55016003)(38070700005)(122000001)(38100700002)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTJ4cVN5UzJhVjJhQzlIdDdUeG1wM3U5VkpVeVl3VElpWHhvc2loWmFZb3JE?=
 =?utf-8?B?bVBlbC9YeGl2MHpTQVkvQ3d3M1FpUVA0VnZFOCticXR2OVd4RHN6SW1QVjhK?=
 =?utf-8?B?ejY4OUJJU01OakN2RCt4UzU1QlgxU25FL2NIczRESDZLRkwzMDJMVE1ybHJy?=
 =?utf-8?B?TFUyUStYUkRqSVBaRzB2VVVUbVNGemgyZXczNzRvOGd2dVBTdFpHbHNpVUxF?=
 =?utf-8?B?SDgzc21yQzg4cDZaUFgrUXFiYkZJTVJ0SkJqQXc4MjVrcXNDT3hLbk1NbWdn?=
 =?utf-8?B?a1h4RGI0TDkvNXk5ZmRqOEJPZmtjWTByMTNPZlRBYXh5ano5bjJJbnllc2hK?=
 =?utf-8?B?WkhLbDVxRzdiRnR5b1pKMjhWcTV5bXBoT0duTG9BNjByd21OKzFHQURoeUpE?=
 =?utf-8?B?Qm1Nc0ZmR2dkd1g4ejJ1Y0l4M2RwTVZHMnNVY2JWYVMwRDBTQUxwbXZORkpG?=
 =?utf-8?B?S3EwRXNyZGZPcUZnL25EZzIvc3Iwd1psS3FwR2E2dmpTdUlod2dweXh1MHUv?=
 =?utf-8?B?Tkx2R0FBcWpxVUZUaGQzMWFFZGVLRmRpbjV0OFlIT0VIM2RoTldlQlNUT1hH?=
 =?utf-8?B?NWFWSzl4UVpxVnJNeEVTUjNMQjRWcDlWekpMVHZNNmRGTCtrWEloVitwM2JF?=
 =?utf-8?B?di9jYmNCc005K0NlVnl3SjYvdWc4ZmdYcEEwcmNvZSszS1N1ODFSeVpjN2h4?=
 =?utf-8?B?UnZ6LzB3L3h6dUVsTUNPejBjOHRMNzlwaURaeHZ1WFlFczdPeUU3V2dFbDBp?=
 =?utf-8?B?ek52S2U3UlJXVWdYd1FZSjBFNk41U1dQNjU0UENLMExaRVk5MEN6TlhrbkRx?=
 =?utf-8?B?QjJUSkUzY09za0o5b1RCTzgvOEM1UkN6VG5sd0hHNko2U2xhNTJ6a0dhQU9B?=
 =?utf-8?B?aWFGSGRZUTJBRk9HRGhmYklCYmxIUTlzdEc1dkVWWUdVdGd2MkJNN2xsRUJm?=
 =?utf-8?B?bW9lMVoxUXFnU2dNY1NQczR1Y0dueHl4SHZMbmF1cWtrZUFQMG1KVmtVcXNB?=
 =?utf-8?B?bDVSQXYybXJ6RmZjY2NwMUJjNWszSTd2WlN2L3ZSODZaY3h2dnVkUHAreXc5?=
 =?utf-8?B?a3RzcS9sR3orTmpOdkRQY2Ezd1ZhellzQzdOUzBKdnFuOTllZ0FRTm9FRU1V?=
 =?utf-8?B?MmJyU3pnL2hZOEtYeFAxWWJZR0Y0ZjZBaW84YnB1amljcGVYcVhhbExMbzB3?=
 =?utf-8?B?K2p1L0ZkOTlLbW1yd0R3U1ZkVEFvNmtxcUQ1MnRxNU5wRDNhL2dwNWxYeFlT?=
 =?utf-8?B?UUg3emU4bmYzU2JCRjhQczlneERWZjY3WXNFdTJXUEcwL3dHTndyM01xQTZY?=
 =?utf-8?B?cHVjT2NYNS9JZDZqVy9xUm9acjMxNkM5dDBhZG9YUU1GMGYrUWg1anEvZWNI?=
 =?utf-8?B?TTZpZUJvNlcraGNTWEpBcURrWEVxMCtFcGJSeUpEb25KdWthcjI1YTl2VUJH?=
 =?utf-8?B?cXM5Z2hFeG9DZWtFSW94bGt2a21rTlBuVmNpc0ZUSkFzUm10MHdqeEhhTUpy?=
 =?utf-8?B?K3J3VU16ditBUGE0YWhONDYwbmgyNzV4MzJHZGZOVXArTWxKTCtUSExnOExL?=
 =?utf-8?B?dGt5RXo4SndmTW5iVTNmNzBrU3A5bjcrMk56VjZvRWdLdWVHWGhxVmdkL3dM?=
 =?utf-8?B?Rjk5bHJJKytMVEVIVng3VU00VVhjeG9FRUYxaVJHcEVVWHVqNFB1akY5dzdt?=
 =?utf-8?B?OTBka0lsRmV4Y0p3VVR3MC9QN2FqcXNjTmxncW9NRFFXenFyeTNwMlZSdHpy?=
 =?utf-8?B?TyswaXFOTFd2Wkd6QWM2M1pYdkw3Q0Q3cEN5aHBScUltd0tRNlI3MXpwQlpC?=
 =?utf-8?B?UHJDTXpVMng5UUdoVFh4d09weSsxMVFuekRSVm1QTlV4dlVDK1pua3VvazJK?=
 =?utf-8?B?RVVGMjR2VWxVczJFRzNkYUJENXpDWHFlRG9EVXJCYzdZSVNGbEhyNDA2TkpC?=
 =?utf-8?B?SW9GbWM4cmxXWk1pSGdvUWx3YnpCVEZRcUlCZDFmYy9zSjZkMGY0c050NGhi?=
 =?utf-8?B?aHpqTGdHUlJlTU01SURIdkRyd3J4NW94VFZ0dDdJTVVydlpoWHNaOVVqL2c4?=
 =?utf-8?B?OFR2Y2xLZEI0dytlUGRCMWt6blM3eG5Ud1dMVEt0SkFSeVI0QmRPZlNOcTIw?=
 =?utf-8?Q?jvCfShJT+dtcaL9keeuRt4Pk8?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d4680d-bdb0-436d-2dc2-08db5128a667
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 07:32:03.5173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a5rsVCUQw32i/DWub89K9QCpLlOLxwFVlGzyyRyH1X+T3khcCYu7bw/ht6jZTRjhHQvJ7yLOSIoyIQxGhWxpyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWmhhbmcsIENhdGh5DQo+
IFNlbnQ6IFdlZG5lc2RheSwgTWF5IDEwLCAyMDIzIDM6MDQgUE0NCj4gVG86IFNoYWtlZWwgQnV0
dCA8c2hha2VlbGJAZ29vZ2xlLmNvbT47IENoZW4sIFRpbSBDDQo+IDx0aW0uYy5jaGVuQGludGVs
LmNvbT4NCj4gQ2M6IGVkdW1hemV0QGdvb2dsZS5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1
YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IEJyYW5kZWJ1cmcsIEplc3NlIDxq
ZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47DQo+IFNyaW5pdmFzLCBTdXJlc2ggPHN1cmVzaC5z
cmluaXZhc0BpbnRlbC5jb20+OyBZb3UsIExpemhlbg0KPiA8TGl6aGVuLllvdUBpbnRlbC5jb20+
OyBlcmljLmR1bWF6ZXRAZ21haWwuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51
eC1tbUBrdmFjay5vcmc7IGNncm91cHNAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBb
UEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2stPnNrX2ZvcndhcmRfYWxsb2MgYXMgYSBw
cm9wZXINCj4gc2l6ZQ0KPiANCj4gDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+ID4gRnJvbTogU2hha2VlbCBCdXR0IDxzaGFrZWVsYkBnb29nbGUuY29tPg0KPiA+IFNlbnQ6
IFdlZG5lc2RheSwgTWF5IDEwLCAyMDIzIDI6MTggQU0NCj4gPiBUbzogQ2hlbiwgVGltIEMgPHRp
bS5jLmNoZW5AaW50ZWwuY29tPg0KPiA+IENjOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGlu
dGVsLmNvbT47IGVkdW1hemV0QGdvb2dsZS5jb207DQo+ID4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
a3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gQnJhbmRlYnVyZywNCj4gPiBK
ZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBTcmluaXZhcywgU3VyZXNoDQo+ID4g
PHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBZb3UsIExpemhlbiA8bGl6aGVuLnlvdUBpbnRl
bC5jb20+Ow0KPiA+IGVyaWMuZHVtYXpldEBnbWFpbC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsNCj4gPiBjZ3JvdXBzQHZnZXIua2VybmVsLm9yZw0KPiA+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2stPnNrX2Zvcndh
cmRfYWxsb2MgYXMgYQ0KPiA+IHByb3BlciBzaXplDQo+ID4NCj4gPiBPbiBUdWUsIE1heSA5LCAy
MDIzIGF0IDExOjA04oCvQU0gQ2hlbiwgVGltIEMgPHRpbS5jLmNoZW5AaW50ZWwuY29tPg0KPiB3
cm90ZToNCj4gPiA+DQo+ID4gPiA+Pg0KPiA+ID4gPj4gUnVuIG1lbWNhY2hlZCB3aXRoIG1lbXRp
ZXJfYmVuY2hhbXJrIHRvIHZlcmlmeSB0aGUgb3B0aW1pemF0aW9uDQo+ID4gPiA+PiBmaXguIDgg
c2VydmVyLWNsaWVudCBwYWlycyBhcmUgY3JlYXRlZCB3aXRoIGJyaWRnZSBuZXR3b3JrIG9uDQo+
ID4gPiA+PiBsb2NhbGhvc3QsIHNlcnZlciBhbmQgY2xpZW50IG9mIHRoZSBzYW1lIHBhaXIgc2hh
cmUgMjggbG9naWNhbCBDUFVzLg0KPiA+ID4gPj4NCj4gPiA+ID4gPlJlc3VsdHMgKEF2ZXJhZ2Ug
Zm9yIDUgcnVuKQ0KPiA+ID4gPiA+UlBTICh3aXRoL3dpdGhvdXQgcGF0Y2gpICAgICArMi4wN3gN
Cj4gPiA+ID4gPg0KPiA+ID4NCj4gPiA+ID5EbyB5b3UgaGF2ZSByZWdyZXNzaW9uIGRhdGEgZnJv
bSBhbnkgcHJvZHVjdGlvbiB3b3JrbG9hZD8gUGxlYXNlDQo+ID4gPiA+a2VlcA0KPiA+IGluIG1p
bmQgdGhhdCBtYW55IHRpbWVzIHdlIChNTSBzdWJzeXN0ZW0pIGFjY2VwdHMgdGhlIHJlZ3Jlc3Np
b25zIG9mDQo+ID4gbWljcm9iZW5jaG1hcmtzIG92ZXIgY29tcGxpY2F0ZWQgb3B0aW1pemF0aW9u
cy4gU28sIGlmIHRoZXJlIGlzIGEgcmVhbA0KPiA+IHByb2R1Y3Rpb24gcmVncmVzc2lvbiwgcGxl
YXNlIGJlIHZlcnkgZXhwbGljaXQgYWJvdXQgaXQuDQo+ID4gPg0KPiA+ID4gVGhvdWdoIG1lbWNh
Y2hlZCBpcyBhY3R1YWxseSB1c2VkIGJ5IHBlb3BsZSBpbiBwcm9kdWN0aW9uLiBTbyB0aGlzDQo+
ID4gPiBpc24ndA0KPiA+IGFuIHVucmVhbGlzdGljIHNjZW5hcmlvLg0KPiA+ID4NCj4gPg0KPiA+
IFllcywgbWVtY2FjaGVkIGlzIHVzZWQgaW4gcHJvZHVjdGlvbiBidXQgSSBhbSBub3Qgc3VyZSBh
bnlvbmUgcnVucyA4DQo+ID4gcGFpcnMgb2Ygc2VydmVyIGFuZCBjbGllbnQgb24gdGhlIHNhbWUg
bWFjaGluZSBmb3IgcHJvZHVjdGlvbg0KPiA+IHdvcmtsb2FkLiBBbnl3YXlzLCB3ZSBjYW4gZGlz
Y3VzcywgaWYgbmVlZGVkLCBhYm91dCB0aGUgcHJhY3RpY2FsaXR5DQo+ID4gb2YgdGhlIGJlbmNo
bWFyayBhZnRlciB3ZSBoYXZlIHNvbWUgaW1wYWN0ZnVsIG1lbWNnIG9wdGltaXphdGlvbnMuDQo+
IA0KPiBUaGUgdGVzdCBpcyBydW4gb24gcGxhdGZvcm0gd2l0aCAyMjQgQ1BVcyAoSFQgZW5hYmxl
ZCkuIEl0J3Mgbm90IGEgbXVzdCB0byBydW4NCj4gOCBwYWlycywgdGhlIG1lbWNnIGNoYXJnZSBo
b3QgcGF0aHMgY2FuIGJlIG9ic2VydmVkIGlmIHdlIHJ1biBvbmx5IG9uZSBwYWlyDQo+IGJ1dCB3
aXRoIG1vcmUgQ1BVcy4gTGV2ZXJhZ2UgYWxsIENQVSByZXNvdXJjZXMgb24gVENQIGNvbm5lY3Rp
b24gdG8gc3RyZXNzDQo+IGNvbnRlbnRpb25zLg0KDQpJZiB3ZSBydW4gbGVzcyBzZXJ2ZXItY2xp
ZW50IHBhaXJzICg8PSAzKSwgYW5kIGVhY2ggcGFpciBpcyB3aXRoIDI4IENQVXMgc2hhcmVkLA0K
dGhhdCBtZWFucyA8PTg0IENQVXMgYWN0dWFsbHkgcnVuLCB0aGVyZSBpcyBubyBvYnZpb3VzIG1l
bWNnIGNoYXJnZSBvdmVyaGVhZA0Kb2JzZXJ2ZWQuIEJ1dCB3aGVuIHdlIHJ1biBtb3JlIHRoYW4g
MTEyIENQVXMgKD49IDQgcGFpcnMpIHRvIHN0cmVzcyB0aGUgc3lzdGVtDQp3aXRoIFRDUCBtZW1v
cnkgYWxsb2NhdGlvbiwgbWVtY2cgY2hhcmdlIHdpbGwgYmUgdGhlIGJvdHRsZW5lY2suDQoNCj4g
DQo+ID4NCj4gPiA+IFRpbQ0K

