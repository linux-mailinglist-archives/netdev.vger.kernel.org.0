Return-Path: <netdev+bounces-2003-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B63C86FFF02
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 04:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C313F1C21043
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 02:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB617ED;
	Fri, 12 May 2023 02:38:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A757E9
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 02:38:52 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36CB59D4;
	Thu, 11 May 2023 19:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683859130; x=1715395130;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YpSODKnMTBnfb3N0AHUEPGQQ8u9heGeBOGBq9g5+d2A=;
  b=IUNXvS/PQwn0HKRS2Gw8DiSxxwFZ/DX/UzMxUQ6EdPdFCtrMLiKAA4Re
   ymgwKE8vIK8eC2AXCrfORfUFfbdZVTIe2KCQD2K3EQ4KDn8gp3DqhSwmH
   G7KCiCixNuWeYfbWBRtRioT+qAVeHqGX5ENffgarcesrqgFzb7gG0xKW1
   YrKG6DGmnwf4HX9uM7BqrKXn7B2tdYSGOizhX7YQrGcXXqVR+sO67Vphl
   3OgfXb2u9bisP1aAXEDt8O0ttMeMRL4klyeNwJ454UjGuiNAEt7NeaKbX
   VNtpEMxsSpeedYyqLEnWJr9JiaPQWtbX9S5oYAOXg4LVRCZf6xn4uhznb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335202134"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="335202134"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 19:38:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="702998854"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="702998854"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 11 May 2023 19:38:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 19:38:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 19:38:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 19:38:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 19:38:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNZMtxDtkNaTcphf1a/nu/h7ucNUq3/6QPeXvnwWeT7yoVthU31HworwlhAig/1achRbsYr12KBsQoU/OIdQtd2/ugztUCFXCF1m53aibKnU1RsvIUWuvRAE19azfuGnsU6bbqvP6qJVr/2m/MipcG560gbgFgNsVvhcSlNYKZPLzv65Qatin7cqprClivXVwaK9Fhxa06HRB9ud5r8GblK5SsRI3zwz1XX6AbymEGvzxPkjm3tIKjW/NZ/hZ+BJw7dyNfN4AuKJROsxsxAjQtzYglUriaWtnyIN96ig5WH7Cnn+uptezreza43qIto4Ir8o7EdZhWKCp24sxKPkAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUsW7iKqZkGMl3UHu+GErzeE6NpTg0GM6HPNCt5Kq28=;
 b=hqJ8H1elYLp+eyV/fUNWIfdXaZ/QiQ81dOCJg9dClIqgI3XYgMteDbrgeiiJFqIBeo/ztAQruqvfC1yWDS1RvX86mGHeeu+GyctlyGLnJ3HPRP1+oJjaExKbdMUMCFNHSALqUAl4odqa//rzYWwtBH0IDKq/QJIkDt+GzK0hpAwLXgGnmTfsCGqb3Aw2FawoB63qP9XYGH5nBgtlFILrPhwzyZtY2BUxglji0seIO+FqHQ4gR8bajlbtQWGtbZagUncvOSd2kk3Ld7066vgh4yHCiiWcxhTf0C2aHhV2OuiVKk845/VgweytjOSQ+dGWs8J1iztbYi7Yh1LxD84xpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by MN2PR11MB4757.namprd11.prod.outlook.com (2603:10b6:208:26b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Fri, 12 May
 2023 02:38:46 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6387.022; Fri, 12 May 2023
 02:38:46 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>, "Zhang@google.com" <Zhang@google.com>
CC: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
	<cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "Brandeburg@google.com" <Brandeburg@google.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas@google.com"
	<Srinivas@google.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"Chen@google.com" <Chen@google.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
	"You@google.com" <You@google.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbwgAAVVACAABAwAIAAMNEAgABhfVCAAGbfEIAADugAgAATvZCAAM4SAIAAWFPw
Date: Fri, 12 May 2023 02:38:46 +0000
Message-ID: <CH3PR11MB734512D5836DBA1F1F3AE7CDFC759@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com>
 <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <20230511211338.oi4xwoueqmntsuna@google.com>
In-Reply-To: <20230511211338.oi4xwoueqmntsuna@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|MN2PR11MB4757:EE_
x-ms-office365-filtering-correlation-id: 3877a517-e6ff-46ef-3c21-08db5292028b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1lejx0Y/fDES2rX6OMKetfTqOITYj3+nANTESSu1UhaNMR+47HjXAroa9FV8Uf7DH431XuZX/3wGiTII+yZ/ln1yqBcIP60e9b17RCqCTI0XaX1mh95Q+NJvplO41mj9oR+Pq16FZosxceMAgJYYbZaRsFKc7Dji92+rGxsLsTt92kvc6OjvbFCMvIX09sgiKggU6rHx07ANtef1kLkJ5O+9ja5KPxG4PAcd+32NQrqkh2yq7bC2vKdLGGW+6U0fMh4+wVWk5Vk3h1jpp8v+eVFxMMRMM5mdcANSnEuCZPJJPnjNTO1nRLC1giSNr1gdTdXKVtWI3ye6T+Jrhu2X8ML5d6WlbykIK4oG0q2HsvGH1eMqKpBRLChCMg8w3RVfIpggNwYwNkXnQl8kTIlJKhpN/hGU2F/bVsPKDNTny9gkFRO+9kO9slpuFaCc7zXGQg+zPVALp67QnLXmyDjWRaiiF1jwz4kDcPzFEUJZnRzm3sbrLP4iwQ5SgmjZX5QFHH0iVhwFwvrN1oxQ2vAz0YkQ7BfHbmQSFwGWrF2+deZlZlRGGP7mFG3iRw2ktXrQKcdwwkZfKkfSpQHl4VCO3U9cO/Zo4KL3MIzxT1F/s4zgvNGAiUGiSJR670Z+6HS/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199021)(53546011)(6506007)(186003)(8676002)(2906002)(26005)(71200400001)(8936002)(7416002)(5660300002)(52536014)(9686003)(83380400001)(55016003)(122000001)(82960400001)(33656002)(4326008)(66476007)(86362001)(54906003)(316002)(110136005)(66556008)(41300700001)(66946007)(76116006)(38100700002)(64756008)(66446008)(478600001)(38070700005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aR3/PfUXET41RhYklSLqSRAgIko5+X1JeyO7UcdGxTRqAp+cYBXlA2pQTomw?=
 =?us-ascii?Q?+uTgoCkzKJrxFAB8KJEB5rl6BeNn6F1p8LW7pR+lfHnfNeHRvLfUgeuS/Kvc?=
 =?us-ascii?Q?kX/E+j0V+KUXirWBHZ6qHKnV1ITW7HqkW2U1v6KKtR28MPvCxyox5s4AybPT?=
 =?us-ascii?Q?wUZm8lWfgc32oh12wV3107J1yNR55+sa6lyK2B3FM7NsynnTJe/U2hC08C+t?=
 =?us-ascii?Q?1+Zmbf0QfKcGnlGG578fnrc/qg+bET6aRIzSJmrkt7mnEyogiYzcUgwySpyn?=
 =?us-ascii?Q?Y5Kv78nnUwnTx4QWeMArA3vPCYjTpeZUfnR5ASyxvMq3u1B0ldw6jUP4an8A?=
 =?us-ascii?Q?iTXuIcb5ELAgWdjU0/7RelnGKDXaD5yEC1xd3OKoymNCMxmOmhU4eZO31RIr?=
 =?us-ascii?Q?WJBPA3jAuhy25qeFvpLGKAZNepqFgf2m2jz19LYYSfiw/IMBa8Eu8RrtUWJ2?=
 =?us-ascii?Q?APCe69AnA4uRS8fbAUb1Pe7cESTCTP1rj9YvtkcbXQXkAGQq8Xh80rKBKmKW?=
 =?us-ascii?Q?l8y68u8Ha932RK5tIHz1f+fe20sr7wjyM5x72lbpG5Xz3JaO+7xFAVKEMQ6j?=
 =?us-ascii?Q?K39A8POeY9KuHQhlWhcxxWmBkrmQCmPAoUqW09kSm40d8xDR+8toeTBsKIy1?=
 =?us-ascii?Q?lFgQ91HyXeQKwcqsxLPEQgwxdU5EDkr4TbRsQ1aq+w05D7tvPcWk1O6Z32o8?=
 =?us-ascii?Q?OFGXLSN9cVEzPwh8+KPJXDo6S7k2hVdj2HtL77mrgK2aSef84bmqsmEdmht2?=
 =?us-ascii?Q?2ZlNfuDSig7w8dEKCnBP//iTrYmdIbxEZ5BXlUzBqk+d1yOgPncU46o5mV+f?=
 =?us-ascii?Q?3r4UVHAiKKYr7lTMWxlNX82ZtNQG/L4beYLHyq4Butj27sWBOBWMwpb5WAu9?=
 =?us-ascii?Q?1/0uwOmOuafJ5dRrWIPnpat8ZmNa6uDB77Z6BMnuIkWaqZdKeHuyAcNprSE/?=
 =?us-ascii?Q?vbjjkIudVozCcW8kJHDlTMlnh8cxy4fxN398YNMcLbTNwdKu05Qq6p+jNoaL?=
 =?us-ascii?Q?eqljsrIYR66QRyR+cZDatHfT06A5rLTDueJmMZatLebXe80eI2/ozDVqHvjp?=
 =?us-ascii?Q?E/QKj31tV1ztHp08yAmzyjbkbiS5Qh9dxJ0gxewpddWQr9aOqHA5WQNw3Ng5?=
 =?us-ascii?Q?Hesg3NnzqQrfty3EsqrrpI1cga+2+DiLlsc6sbMVEIICYpi+/ezBAQWK47oi?=
 =?us-ascii?Q?XMPg/eHxozz151/MaUrpvDqusrtbXnesVx6JZzwihrcEEUCepYXpW1PgQJcl?=
 =?us-ascii?Q?3QYIKjMUk6N6735onCbsx3vH3mYNqtGR/ZiVPbESjn4tXrn4FzDH5gK1l0Fh?=
 =?us-ascii?Q?AmB2RMR7sl5+0YthwkUFiGtRr1SlhbDeacYvI/Qx54KAL0apo6VNcsj6KCdr?=
 =?us-ascii?Q?VRs3gcbzqDbu+G5QjfzN6vAdInbt9ueaE4e+RSpeZNwq6hMIK3qYo/P5nVM4?=
 =?us-ascii?Q?GNvkyuyW7gX7Jpmc1RBfLfRT22Vk7mdlooU8joxW1kPtWQzK3WWOEQ06WW3f?=
 =?us-ascii?Q?xcIouOnOkIQa1IW4dzPH/RMXLBe4lpQCIV+blXgNLAuoVt92rIN5GexfXpCa?=
 =?us-ascii?Q?3MB5kaM5EfKy/cTbHKWkwH/PrPzojIL8GkNSSQbZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3877a517-e6ff-46ef-3c21-08db5292028b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 02:38:46.3890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /uV9kS9+MhBpBaHQHPcOvaF8LoslOsaJ4K9EXkJBOPKIXawvdIuEW9myvLXp6YKke2XxyQicwuATt1/iCezJxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4757
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Shakeel Butt <shakeelb@google.com>
> Sent: Friday, May 12, 2023 5:19 AM
> To: Zhang@google.com; Zhang, Cathy <cathy.zhang@intel.com>
> Cc: Eric Dumazet <edumazet@google.com>; Linux MM <linux-
> mm@kvack.org>; Cgroups <cgroups@vger.kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; davem@davemloft.net; kuba@kernel.org;
> Brandeburg@google.com; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> Srinivas@google.com; Srinivas, Suresh <suresh.srinivas@intel.com>;
> Chen@google.com; Chen, Tim C <tim.c.chen@intel.com>; You@google.com;
> You, Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> On Thu, May 11, 2023 at 09:26:46AM +0000, Zhang, Cathy wrote:
> >
> [...]
> >
> >      8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter=
_cancel
> >             |
> >              --8.97%--page_counter_cancel
> >                        |
> >                         --8.97%--page_counter_uncharge
> >                                   drain_stock
> >                                   __refill_stock
> >                                   refill_stock
> >                                   |
> >                                    --8.91%--try_charge_memcg
> >                                              mem_cgroup_charge_skmem
>=20
> I do want to understand for above which specific condition in __refill_st=
ock is
> causing to drain stock in the charge code path. Can you please re-run and
> profile your test with following code snippet (or use any other mechanism
> which can answer the question)?
>=20
> From f1d91043f21f4b29717c78615b374d79fc021d1f Mon Sep 17 00:00:00
> 2001
> From: Shakeel Butt <shakeelb@google.com>
> Date: Thu, 11 May 2023 20:00:19 +0000
> Subject: [PATCH] Debug drain on charging.
>=20
> ---
>  mm/memcontrol.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c index
> d31fb1e2cb33..4c1c3d90a4a3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2311,6 +2311,16 @@ static void drain_local_stock(struct work_struct
> *dummy)
>  		obj_cgroup_put(old);
>  }
>=20
> +static noinline void drain_stock_1(struct memcg_stock_pcp *stock) {
> +	drain_stock(stock);
> +}
> +
> +static noinline void drain_stock_2(struct memcg_stock_pcp *stock) {
> +	drain_stock(stock);
> +}
> +
>  /*
>   * Cache charges(val) to local per_cpu area.
>   * This will be consumed by consume_stock() function, later.
> @@ -2321,14 +2331,14 @@ static void __refill_stock(struct mem_cgroup
> *memcg, unsigned int nr_pages)
>=20
>  	stock =3D this_cpu_ptr(&memcg_stock);
>  	if (READ_ONCE(stock->cached) !=3D memcg) { /* reset if necessary */
> -		drain_stock(stock);
> +		drain_stock_1(stock);
>  		css_get(&memcg->css);
>  		WRITE_ONCE(stock->cached, memcg);
>  	}
>  	stock->nr_pages +=3D nr_pages;
>=20
>  	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
> -		drain_stock(stock);
> +		drain_stock_2(stock);
>  }
>=20
>  static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages=
)
> --
> 2.40.1.606.ga4b1b128d6-goog

Hi Shakeel,

Run with the temp change you provided,  the output shows it comes to drain_=
stock_1(),
Here is the call trace:

     8.96%  mc-worker        [kernel.vmlinux]            [k] page_counter_c=
ancel
            |
             --8.95%--page_counter_cancel
                       |
                        --8.95%--page_counter_uncharge
                                  drain_stock_1
                                  __refill_stock
                                  refill_stock
                                  |
                                   --8.88%--try_charge_memcg
                                             mem_cgroup_charge_skmem
                                             |
                                              --8.87%--__sk_mem_raise_alloc=
ated
                                                        __sk_mem_schedule
                                                        |
                                                        |--5.37%--tcp_try_r=
mem_schedule
                                                        |          tcp_data=
_queue
                                                        |          tcp_rcv_=
established
                                                        |          tcp_v4_d=
o_rcv


