Return-Path: <netdev+bounces-3955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7FA7709C87
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D6811C212D4
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156B8C14B;
	Fri, 19 May 2023 16:37:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73863D3A1;
	Fri, 19 May 2023 16:37:15 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2626C1;
	Fri, 19 May 2023 09:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684514234; x=1716050234;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CrHuy7/kg+MjhE4rcZsROuwkyTgzNozSyNjaMwGVlyQ=;
  b=gZii3ZBJ45Re8zJAToXqNhEN++e2nG2bwsBo6aM7smVp1TzIhLqy+3ea
   iXCwZjwpy8mTg8dExwS+8N3Ik+Yfhkn0FAbs9xhZpw9OdBWcvi3el67MT
   L+ziP+jRSFNNqR6HgCfXOA7nNkpZog5b7h4LQp3ebhR3ZfYXfqFWXOrj/
   DkW8I+Y5oVao/JpaOCKDgvQFfP0M7UulaVk/1rnP9wUlRmosUZ2sOf0GQ
   tntHhIM3DVcYT3Ysrybw5/Saja0lERdbc63CO3mybDBWHaPLcejaTdXTT
   FQCTIEceZqg9qquvojVcSoxpM20aMa92XmNlIhEZ6p5aAj4qOSUe1zmBm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="354774285"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="354774285"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 09:37:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="733357344"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="733357344"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 19 May 2023 09:37:01 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 09:37:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 19 May 2023 09:37:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 19 May 2023 09:37:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVHegnM5iDaYuqTDPep2PztU26gdcbqQJ0IBJDxlGboryrNyJu3PglzfncjbOyoEnl40r4hHDxeptFBuhCjqFUsJoTA8N00sXP/oUTPi7mcM1YEYkW8NlbRpFZH5OQv4hPxhMq/I9xJ5DFTYu236NEbxJLKfgrbvc6gDVAzsQltrh2HiUJaw95wUqk5x0PUE30VzaZeb6GkIRw7OO59POqcG8+uyiiSurOlotz0TbngZRZ2S/cU/BxQbPsURxls4oldrQfhGZFLhoRGo8tJ5+vKWcxrcPtIWwfH61n1BiZ6iN6vtcogNAKytr7yquP2etbopwIyb80TA4Fr0loW/2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTf2u9h11Fwy4FTjWvptSzX9VI6pT+c6a3nau4ud3lQ=;
 b=bMJY64LW0DAmTLeQ3Hx6aPKCzNE0gO3LzreFLA3bK+IEkeKpmUM6NblzfW2lK+SkhBWoUdlP8898K08ShWU7mMnTwXVrfI4x6mx1+NP5VGvvq7kp4n3K8UJ9Cn4/x3nQf4SbZi6s0BN1/mO0CC2LtG8epJmAmB7CVtSxPx983ge7RtXisBAgeyvf0BDbr1V0y4EzcW7dsr93ggVkEvGeN1QtM5Uyi5ju1ms/fJSmnfOkm2kY46jAWkBteM4v/X5bPYwgICvKio0piDfop5YSYEpQzBLOjbOaAQo5072HZ7aTAsPNSMBdBA+wHh5e91l1A83eramwpW+iQLFkWhcFng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BY1PR11MB7981.namprd11.prod.outlook.com (2603:10b6:a03:52f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 16:36:56 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.019; Fri, 19 May 2023
 16:36:56 +0000
Message-ID: <5b817d49-eefa-51c9-3b51-01f1dba17d42@intel.com>
Date: Fri, 19 May 2023 18:35:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RESEND bpf-next 14/15] net, xdp: allow metadata > 32
Content-Language: en-US
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
CC: Larysa Zaremba <larysa.zaremba@intel.com>, <brouer@redhat.com>,
	<bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
	"Andrii Nakryiko" <andrii@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	"Martin KaFai Lau" <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP
 Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>, Alexander Lobakin
	<alexandr.lobakin@intel.com>, Magnus Karlsson <magnus.karlsson@gmail.com>,
	Maryam Tahhan <mtahhan@redhat.com>, <xdp-hints@xdp-project.net>,
	<netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-15-larysa.zaremba@intel.com>
 <ee1ad4f2-34ab-4377-14d5-532cb0687180@redhat.com> <ZGJnFxzDTV2qE4zZ@lincoln>
 <b9a879b2-bb62-ba18-0bdd-5c126a1086a9@intel.com>
 <a37db72f-2e83-c838-7c81-8f01a5a0df32@redhat.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <a37db72f-2e83-c838-7c81-8f01a5a0df32@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0426.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::30) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BY1PR11MB7981:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b8c19c-cd85-4ffb-6b86-08db588741f4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H2AhOgOrOI8Cq1cBjXY3lk6d7xIExUrkt1LyF2sJIwbtIlBDVmc4Q4Qupy32ssFm+D/IYRSTKzxBnELkpTZeqUCGKm5Df/i8KwR3dOr3FlTFIra2sgVPjyH+22HE1UvlyPwUFkOkh5yRNzWgYkwqcPaOwIGxZcOrjPYrzG0S/1r95fkUTUeUa5Nn3HpJZVAHPJrDKUQM4NnXL/ZJb/8BkUVgHL1JL4vyHn4IwdbZyPRz8dTIS9Lg5atfAKhFmw3BeYp5WjkFsgHgCmO4xlNPyRvMDdkBVYTVPT8UjpxcWvGje8WSAzw0bU7jgm5aFKpSp9R1/zhjirnzLqE4eE0A7/SKzVzKDjNZSKnkvIbtOb/y4YCChgU+Jj7KnvAzo9emcDh2RsmEQjnM52XVC/22J7DskzjQt+8jgc/vqd7gzEcgHo9taqr0uKYo4HnbHLy14NeNvYISCj+td5buUmDmlE/CUrEejJHi8PnD7XiiXWJedEe9Htblh9iH/V+srUsDrHKGB0nNDjK80JU4LtiKSO5aA/Em9Nsmt35t8+pI1yJvmDVPgkzEw1W39tzZ6MtpGEFR/aNzQKgCsGTv4gdBQ9QjXhGUCvEPiLloTsa3JON2rXtcVb5vsE24QDsCHS4wTj5SuKk8vwBAngrfLn0F/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199021)(6512007)(26005)(6506007)(36756003)(2616005)(31696002)(86362001)(83380400001)(38100700002)(186003)(82960400001)(6486002)(54906003)(7416002)(478600001)(316002)(31686004)(2906002)(4326008)(8936002)(6916009)(8676002)(41300700001)(5660300002)(66476007)(66556008)(66946007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2MwNzNyejBkdWxWdm5jOS9qeDlVSmJtd3hzUnlOTUNFaytoMkRjcmxTcmJC?=
 =?utf-8?B?OWI0QTIzOWxnaWlNZTdIN2NmUEZJN2NqbjhFYXhWazZFWDUxbHFNY2RPd0dj?=
 =?utf-8?B?MUNzWW94L2h6N21lVUJ2aFQvL2g4OXByVDFvMlYrNEFRRVpGOXhWL2NEaWli?=
 =?utf-8?B?QmltRk5CYnhOY2NxeUlUTDdkWFNlZ3BuQW5Ja2hxOGN5Yk5lODVVZG0xa2RD?=
 =?utf-8?B?WGMxcXhERWswT0lONUs4Sk43NkRPSUd2a1FVdTgyZVRHM0hhNXpEKzBzTWhQ?=
 =?utf-8?B?T1lRc3BKSFAxRVZQRTBpRnJUTVhhd3RIeWxGK3pZNlQ4T3ZqMGt6OUd5TXho?=
 =?utf-8?B?MkJsVi83WC80K2xOMVZXZUQ3eTZneXBQOGhZTWRlNVZubS9yM0RhMEQxZEE1?=
 =?utf-8?B?K1R3SUh2N0pjN0E0bVJYS0t2QjlvTlQ4cFUvMHdhMDBpc2Nmbk9EeFptT0tX?=
 =?utf-8?B?Q0J0NFRpdXJnZklwT2I1UGUyTmtkc3V1dDdhTjhmdHdUUy9pamN1eGNkVnlu?=
 =?utf-8?B?OXZPQ1FaRXpDSmpFK3FxUGJTNGtLTEk1OVdoeTRXRG10bWc4Q0NKbTk1cGwv?=
 =?utf-8?B?RG1EcVQwektBVC9zamdMcmhGS0ZORGo0RlM4MjFZR1ZLRTA2YXdFWElRZG9y?=
 =?utf-8?B?TkRiNk1WWWVXZVl2UXpRYm81OHh1ZGszVGM2L3F6VHY4Ym5CVUhVL2kyaFcy?=
 =?utf-8?B?cWIxOUVwTEpsa1VnZjgybUFUZzlKU0l3SnRQK2pxTWZqOFVCMEZsazNGekhz?=
 =?utf-8?B?a3R6SmJjdHIvWXVxbkNiSm5VSFFDZTl4dWdsV3dDTklCdmMwd2x3dk8vcUdL?=
 =?utf-8?B?SDQzTDJZWnQ4cGRxK1lBbkFEaGRFQ0ZGeDlURHI3Mkh1RGQ2U3RQcG9wY29O?=
 =?utf-8?B?QmNKdlJIR1g3R2dFdUxGc01qenBFRDRhaHp5SVZQS3l2dzFRdmlubkVqWS9P?=
 =?utf-8?B?enVES2FYcWdzSHJCQjdRbkcxVUxOYW11NGJVcVF4ZCtScTd1NUFLbThtS0VI?=
 =?utf-8?B?TVhZb08rREN2RHpScld2YkZYLytJc3JxOGVOWHIrOEphc3Qzc1k0K2R2cjFJ?=
 =?utf-8?B?eXVNa2ZoQS9TM3hJaHVoUkZiSU1GdFoyS21HYU02RjFGcWF5OUZXRDJMOEIy?=
 =?utf-8?B?RWVWUXFReXQrdFUyTDJSRkQ4ZXNYdFp1aDhObjJTK29yby8zdms0ODRGMENi?=
 =?utf-8?B?dHVPMVlSV2RvUkhNbFdtaTJLd0pKUE1pQ0RUb2M4bEJTUXFDZWQvVzR5UTJ1?=
 =?utf-8?B?dGJwS2pmbkdNWDJIejl1TE5KUXM5UUs0VVdwalNQU3Q5bDQ3R3ZjdSt5TnJj?=
 =?utf-8?B?dmtNZnZiTlR4c3FNbGRQYUdNdXN5QnB5VnpUYktmTHhCRVVUdW44ZkV1VG9p?=
 =?utf-8?B?MXRNdVN2WE9nRnhQZ21iZjQvMk1vVXBadlpiVy8yTm55ajJQNUE1eDZvdzRY?=
 =?utf-8?B?enZmYUxiTVN5T3ZFVzRWd2F3MlNEc1dtL2RVV0I1OCtvU0hPdVUxRzR6MEp3?=
 =?utf-8?B?UGNlcUIvMkxqOEJDWE5CMUlNcDUzWllKUXR3Ums4TFVaNW5KN01ZYU9UNlRE?=
 =?utf-8?B?eGRGNWdEU28vU2IzTGRERXVZV21SckJWN1JYTXgvcGpaNzlIS2JOOHNIU1Jl?=
 =?utf-8?B?K0JJS2NUclhQZmZ0K2QvaE9uTHUwUUtvU3F6YXYrSHluV3VEWUFTUWRuTTFr?=
 =?utf-8?B?VllMaFphSlU4cE1Lak1pTGNGOEd0bGhIV1BmM3Q0RVNSUlVUTlJ0VWhyMjZN?=
 =?utf-8?B?L3lTTHBCSHdGQkRNSlBKeDNjMXFhamFWeE00SFptVTlxdVBocGViNS9kMUVq?=
 =?utf-8?B?UCtHL0VVdWxhcFhWdE1WWE8xRjVNSDVETG5DZ0RMbnpOYWFNSTViMnM5K2xI?=
 =?utf-8?B?K1VYVXAvbDRBcHo4NGF4N1Bmc0I4NVVIeWxMYXdlQnRSL3hOQWZwMVdJa244?=
 =?utf-8?B?dlpUUVp0eDdqVmpWTlQ4LzVCanlMakRoS1pPenhVSkNWZGFsVXZKd3VqbzBL?=
 =?utf-8?B?NnZ6VkowWFFpbDRtRU4waWQ5V2ZLM3ZFaU4vMnBrOTE0RG1GOWtSeW02TFBF?=
 =?utf-8?B?SWs0cVNhRWRpbnl6dFNGNGlXUC9CbXhzckNxaWlqbGdjNTJTUVhzTnBBMzcx?=
 =?utf-8?B?YWh2aXZWNTBibEZRMFpCVW9VN0s1T0d6QTJoYjJwMnRPL2xtWWk4T1Z2U3hB?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b8c19c-cd85-4ffb-6b86-08db588741f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 16:36:55.8372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHNCpTHq3icYlnW9IxzWlOaXOQpm8744qj7BFK4KIYUwOazOwvBVBtVuhqemPG3fuxy3Vc5KX2It6vNQxnPuYjRrvXX9mL/KYH1/lDm8738=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7981
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Tue, 16 May 2023 17:35:27 +0200

> 
> 
> On 16/05/2023 14.37, Alexander Lobakin wrote:
>> From: Larysa Zaremba<larysa.zaremba@intel.com>
>> Date: Mon, 15 May 2023 19:08:39 +0200
>>
>>> On Mon, May 15, 2023 at 06:17:02PM +0200, Jesper Dangaard Brouer wrote:
>>>>
>>>> On 12/05/2023 17.26, Larysa Zaremba wrote:
>>>>> From: Aleksander Lobakin<aleksander.lobakin@intel.com>
>>>>>
>>>>> When using XDP hints, metadata sometimes has to be much bigger
>>>>> than 32 bytes. Relax the restriction, allow metadata larger than 32
>>>>> bytes
>>>>> and make __skb_metadata_differs() work with bigger lengths.
>>>>>
>>>>> Now size of metadata is only limited by the fact it is stored as u8
>>>>> in skb_shared_info, so maximum possible value is 255.
>>>>
>>>> I'm confused, IIRC the metadata area isn't stored "in skb_shared_info".
>>>> The maximum possible size is limited by the XDP headroom, which is also
>>>> shared/limited with/by xdp_frame.  I must be reading the sentence
>>>> wrong,
>>>> somehow.
>>
>> skb_shared_info::meta_size  is u8. Since metadata gets carried from
>> xdp_buff to skb, this check is needed (it's compile-time constant
>> anyway).
>> Check for headroom is done separately already (two sentences below).
>>
> 
> Damn, argh, for SKBs the "meta_len" is stored in skb_shared_info, which
> is located on another cacheline.
> That is a sure way to KILL performance! :-(

Have you read the code? I use type_max(typeof_member(shinfo, meta_len)),
what performance are you talking about?

The whole xdp_metalen_invalid() gets expanded into:

	return (metalen % 4) || metalen > 255;

at compile-time. All those typeof shenanigans are only to not open-code
meta_len's type/size/max.

> 
> But only use for SKBs that gets created from xdp with metadata, right?
> 
> 
> 
>>> It's not 'metadata is stored as u8', it's 'metadata size is stored as
>>> u8' :)
>>> Maybe I should rephrase it better in v2.
> 
> Yes, a rephrase will be good.
> 
> --Jesper
> 
> 
> 
> static inline u8 skb_metadata_len(const struct sk_buff *skb)
> {
>     return skb_shinfo(skb)->meta_len;
> }
> 

Thanks,
Olek

