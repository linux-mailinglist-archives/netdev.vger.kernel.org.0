Return-Path: <netdev+bounces-188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 604E46F5BE4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:25:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E35C28167B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 16:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCDB2770E;
	Wed,  3 May 2023 16:24:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEF52770D
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 16:24:46 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544754EEB
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683131085; x=1714667085;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MwyhLy1xR+I0ZMfPWQXD5qAJN/D8LuAkFg5MLJKhreQ=;
  b=Fy6NXRBXyu0Q/A1SHl1HDyRrVyjXc6o09ChjosVE/4X3kKUgL41ZXJ1t
   k1jsMudm0GHYyyy3ACzRntT3/JYk0T6acxnpdZl6jI6YF5bd9Wqhvkjn+
   wyR+VBXFUwcvT5FEpTemtpqYjC743SGctwCeLlVnqKaWBxyf3ekF7X34n
   OSrvGkHX/HfO4VvwWQ/NTcHnAtEBjC/W1t8Jz1WI6nN6MVfIjYaU4wBGy
   Ql0tD6hgJzWEPqG2LhhG7SgB/PGWDFrVskfdKUQ/XSaCUhKRUGp/SB0bd
   mie0c9jJmtNc5rD5khoWBgneunx4sPYkN2usuYE+zhruK5c4q+KeLB+id
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="329057221"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="329057221"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 09:24:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="761545566"
X-IronPort-AV: E=Sophos;i="5.99,247,1677571200"; 
   d="scan'208";a="761545566"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 03 May 2023 09:24:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 09:24:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 09:24:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 09:24:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 09:24:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ve4HdM7/hnbjp50TarzfDc+PB/IbltreX6/sUOAv/rfKQGd+u0C7XdNVBuNv7SWieE4OSSB4kpbMWsiu47h/rIvHknWMsdAiVQt4hkZZXpZU0imaMhc0LflCP6nWar09Aqq1gMmJLiIJVcN3a4YaoKLt3jgeldZyAgMj6CUfhDx9eRhfmw6JLSy8/LiX9wGQ7qGwSJwqUnY7kVjBb/t9ruZCs67q7FInhR7nPD50ji66j2sUM7h5i+ACxoWMvcC00/CJ7bL9K8db+PMsYNn6iXBMObdHlgApcfPUfuz9yvUtFSAuDbpg8Iiszv7/gW0oyHAxh4qLB0UV6Uqfge/sMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjSxpfPnfLrr2UFxqu6o0GJHekAtEBZHPdtDCPUKLwg=;
 b=gVDUcjHSjEg0k90WTsNleeGfuQMRP1bBxnViGM+37DyMJORbn9R1uon9ap1swqCjPZGlDRa+0+NWHWD3rwcFA5sE8zVnS5MZO85JJrVnfP57scBttsocsKbf0MMzzNIjRbGafg6PXMNaUf1kp5Wx356uvHVc3FqyGgxEM+2buhUQXylKJdYaahEuhCWx5uWL69seHaPJoms509uqvRXhjbNaXAx4nCvlA/8598cQ9qvnfphZcmMGLHMltYz62w79ovVPDYhx/KA5gfagQ95sU9jsWOImmGDvQ1NgY6rPwFrZf4E35FQS7vd9tiLSrRIAbykEfVE4TbYL3lp0bAgzzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by IA0PR11MB7185.namprd11.prod.outlook.com (2603:10b6:208:432::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 16:24:38 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::9c59:d19c:6c65:f4d6]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::9c59:d19c:6c65:f4d6%6]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 16:24:37 +0000
Message-ID: <4ca60533-e32e-4ce2-3763-6f86dbcf3e94@intel.com>
Date: Wed, 3 May 2023 09:24:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [net-next v3 00/15] Introduce Intel IDPF driver
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
CC: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<joshua.a.hay@intel.com>, <sridhar.samudrala@intel.com>,
	<anthony.l.nguyen@intel.com>, <willemb@google.com>, <decot@google.com>,
	<pabeni@redhat.com>, <edumazet@google.com>, <davem@davemloft.net>,
	<alan.brady@intel.com>, <madhu.chittim@intel.com>, <phani.r.burra@intel.com>,
	<shailendra.bhatnagar@intel.com>, <pavan.kumar.linga@intel.com>,
	<shannon.nelson@amd.com>, <simon.horman@corigine.com>, <leon@kernel.org>
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
 <20230426194623.5b922067@kernel.org>
 <97f635bf-a793-7d10-9a5e-2847816dda1d@intel.com>
 <20230426202907.2e07f031@kernel.org>
 <965fa809-6cdd-7050-1516-72cc33713972@intel.com>
 <20230502192024.28029188@kernel.org>
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230502192024.28029188@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::10) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|IA0PR11MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: 61a7f401-3232-4f21-0b13-08db4bf2e3b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5DAWL66tdDiqfhCuUuHVTjd03EjHNAy6gO5JTwlams3J5in4mF7XXtQ80P+dsZb77OF6lXTXUyx2bbr07pOp5sjr7+cGQ1YgJ8wW3AH1ynzxTn0xc1KrsJ3yDuCi9yoETwYSMz6zUSVOMG1rnDuHROfdUUMdpy+Bsjym8donCtPJQxgBs2asDJkj10848HlslLentczPf9mQ8IVqXMIeoqUL006Ml98pLdIPrAQNAhs2SBBIYn6EMr4zgr6/KHLp0XveacGvfZm/mAqFuwrXCkTi0zTR9uukoSmKkotEp5Ay5feicjy/oC8z+qhibo5KtXyQkb7I+fHa34ZyzH3BSdLsRv0zqDxS7QcTQxPdnKXCNzaGoa0xszkCppeZnoZZ7cG6WmOv0btPHpa4Gys50HLwMGQ4AaREJk0sccoogpEZp+FjV4nFl+e18jUBFfIGRCghkwwOM2dgRmeZ8XCz6lZiCAIpOcQyp4a49D8w1PNmkPTFy5gv7GG6CTWtf8JUWVAJZWSlEmKp0d5xU/lM9YxiOT6C6LUnNq7jOkYbE0Tmm1aq2flMD7OhY9/F+n9fmWEfEaowC9kjdps6KMXbkonCx24rOrEYA24PgkMoKcBL2o7q2tglvBh/nrg4cU0VSahGoiz6n6yIiYHKvXIBjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(31686004)(6486002)(6506007)(26005)(316002)(53546011)(6512007)(38100700002)(7416002)(5660300002)(8936002)(8676002)(44832011)(31696002)(86362001)(478600001)(2616005)(66556008)(186003)(66946007)(66476007)(4326008)(41300700001)(4744005)(82960400001)(2906002)(36756003)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1k4RUM0TXJFckRXQXRWQy9MaDcyQ2srTGtUNlVSRW44Y1pheDdtSmR2bVRq?=
 =?utf-8?B?bXk3QmNYc3pEczFDOVliT0lTMVVEQUhyODRuRnpiTE1HMENVUzNCcmhxRTFZ?=
 =?utf-8?B?UlJmdUlpZHJLTmhudnJvUm9KSk82VFc3U3lDcUFqb09pR09TZ2c1TTFXVDRs?=
 =?utf-8?B?ZGkvM1BpRFNTYUsyYmh4eVlnMTJmcHBwbzQrWkNKbGN6UlRlWndxbHFWN2Vu?=
 =?utf-8?B?YjkyOFR4MW8xZzF6eUFRZEZROWhyWDJMbm80V0ptM0lVeVZpZ0RpYy9qendl?=
 =?utf-8?B?V3NsRFpudGM4WEtRZnJiYkE3SWk5eElxenk4Z3hlQ0k3OTM2TGJxNFE3U3lL?=
 =?utf-8?B?UTFuNHFxWFVQSTlmK1dxeG5NdW9BWm1STDFDL2hSd1Nwekw5MlFIU1J6NkdP?=
 =?utf-8?B?QjRoU0UvU0k0RWd1RzBOazlNMnhQbGFLdWtmYmRQaER0M0lvaVJpOVM0djg2?=
 =?utf-8?B?WDNCMlhGckU3dm0wRkwrd09FQmNPSERiaGVhc2t6OEJ2R2tPd2tYbENIYzls?=
 =?utf-8?B?TTBLQk9QbU9NMHZGNGRyUkFTbHZueDJSVlU3a2IrcmxDeE1aVXovWTQ2RG9J?=
 =?utf-8?B?UjZIa1pTVmNaUEluMHdxUXhxZEMxMmI4T3RmdlY3U2FIUGhvOGkyai8yQ3Nw?=
 =?utf-8?B?cG9TWHR1UzZtWUt4MGtTZFhGRm15N0VqVWJ6Y2d4TEMyQm13ZDJUbHpxUmkw?=
 =?utf-8?B?UDlmeEwvZ0o5VE81RTZTMHMwUGJuSE4rUk0ySWlZTVpGcE1mSFkwQkU4d0Jj?=
 =?utf-8?B?aWZGd3BPR2JnQ3ZaZDRsbHFnMTE4M2J2UVYrckFSQm8yYWhzZGN6VTZEZHlj?=
 =?utf-8?B?U2s0QVRkdTFnRTRuR2RhRUkyQkQvSzdoMGFJeStqV1dHYkZQTC90QW9iRzAz?=
 =?utf-8?B?WDFHdmhPd3RzU1I2TFp3eGpNb1V3OE9KSUw4RTV1MTBOc0ViNHNHVjVJaS9W?=
 =?utf-8?B?RFZWVGt5REQvOUUxLzRkV3ZCRGUvcFU3Ty9RdHQ1WGZ1aFZ1TldxN0RUdmFw?=
 =?utf-8?B?UWhHblFNdE5HVHZsRlY0dGQ2cmVXNFpxOG1pRXVueE15Q2puYWZNa1pDMGh5?=
 =?utf-8?B?YjhMWjdwMnFNT01YUTd1NG9nRkZNaVVFakdyTzlTbi8vR2tXZ1BVSjhwVWpY?=
 =?utf-8?B?NzkrS2Q1MzNmTXBOL2hiYlQ5YW9VYUlScDMvK1RReCtxKy9oU0l1bTI1UkxY?=
 =?utf-8?B?SUljWmY2cDlUNzVoUUxsc2VocDM0Z0RwMHRTeWpFRUNQamwvWU0rOXhVY1Vk?=
 =?utf-8?B?S0UzZ0NqVnJnRjhnbkt0dGR5RGhKbG1iMzluTy9MRE9KMEtXdWNyeG15NHlu?=
 =?utf-8?B?OVNOYklXbGdMeDJiVkJFV1orWFNXRjcwamtWSlg3YUF2dmEwUG1aTWlwRFFZ?=
 =?utf-8?B?emtlWExmWk5ia0NtMnM1U1IzaE9namUxaFNyemN4VmdjWlA5L3ZJb0FyRFpy?=
 =?utf-8?B?TWo0cVhyM3VIYlVJMzhnWjRRbFJScW94N2s0Q3lHVDRSZHhkWnJkbjZIS1Nv?=
 =?utf-8?B?RzJZM0x0YytoMU5Hb2hOOU5SbHZkUzYrcTV1aUJmc0Z1ZFRkZG04VzJRcjVY?=
 =?utf-8?B?RFh2Vzh0QXNNK3NwaEVJOVVHaXhMQnFaTWpwOE1yNUp4NHo2RmYyeW9TL2JL?=
 =?utf-8?B?UWJXd2JzdHZLK3B6d3FGOEZhU1ZFN3lJaHdWcGU2VDZHR0Y4aWV2alFsYzhV?=
 =?utf-8?B?ZVM3U1BMTnRILzN2YW9vczl5WXZvbXFZN3h4WnMrV0pOVFBpTC8xMjhwVGls?=
 =?utf-8?B?VCtSL3JIb21WdHA4V0pWTG5lWFJPYzEyb3lkOHA0cGQwczNRbnJLaGhBOC9v?=
 =?utf-8?B?TXc4Yzl1cG5BeU85QTBTTFNBRzluTHUyd3NyemlKZXRDbkozZVlzMlI0aW9l?=
 =?utf-8?B?YkV3M3VMYXdtcUlJQjU0VnkreXl2ZVBtekNkL25FNFllaVpqL0RVVXMvQkR0?=
 =?utf-8?B?RXpEajFmdmVYa2V1Zy8vRU9kdzltSy9ISVhLcDJQT01aaCtBcW9WT1RZM0V1?=
 =?utf-8?B?UXBCUVdheWdwS08wUFdZTHRXZ0JCSmFGR0J2UlRMaE9mbzV3MTFlSW9MUHFZ?=
 =?utf-8?B?WnAvNDA1K2xONjNwWHdUQVJvZkgrVkdCR0cyRjBLOGx1WDFUd21wcDRVS3U0?=
 =?utf-8?B?eWRhOUkycFdjcFgxUFYvN04wZTQ5dzJFZVgybmtUYXJKKzlQSFc1TTJWS3JP?=
 =?utf-8?B?N0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a7f401-3232-4f21-0b13-08db4bf2e3b3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 16:24:37.9294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eNqW4icsGhmVksgSeGrHp90StLE1+fVGEtF3CSAa3Nj3FvD+3DSgCoJ/lk6A3L6jqJpehlpmPIOBPgfMn4qMb9u8+4+DiFYJ/dVRH2Y2JNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7185
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/2/2023 7:20 PM, Jakub Kicinski wrote:
> On Thu, 27 Apr 2023 15:23:12 -0700 Jesse Brandeburg wrote:
>> We have a proposal by doing these two things in the future:
>> 1) to: intel-wired-lan, cc: netdev until we've addressed review comments
>> 2) use [iwl-next ] or [iwl-net] in the Subject: when reviewing on
>> intel-wired-lan, and cc:netdev, to make clear the intent in both headers
>> and Subject line.
> 
> Sounds like a good scheme, let's try it!
> Thanks!

Ok, we'll start implementing.

