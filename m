Return-Path: <netdev+bounces-2827-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EFBB70439F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0ADF31C20D1F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D10923C1;
	Tue, 16 May 2023 02:53:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4E621
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:53:15 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A334F4C17
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684205594; x=1715741594;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hiV0K7kZcH179pPT9TZh+g1cElLMxy6ezYmmrs3R+YA=;
  b=KvbOEtVrHRXGJ3Ku0/nqgmqlezTYramBtVRkdE1bRTye+12mo4pm5g6M
   vAWGlhSOmRbg1M6pmx0QpkEsfeVwPEC4aqWLOItnI9om5uXFYxx4PaOlj
   NJDri9fRjPi35Agb+ZANejS2nHGRe4y0T0clazYt26ejPDIHweUV8Ew1A
   KwexpZ84cIYs7xM8xUkqQ/r1U72evaEHBwHZ6hZjSmgjROONUlrI+hVCG
   B3/zvbE24E/8DgGa0SEhht9LUgq9SvE3SSYowTwT1Ij2pljXT+RGAKcYy
   dEC7kww1QYMhs7o5bELaehRXsc0upqbcIcrZyRM5f5viZkZP1cnNiomY5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="417023960"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="417023960"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 19:53:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="734114240"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="734114240"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 15 May 2023 19:53:13 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 19:53:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 19:53:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 19:53:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSKAYHqTLDMhh+3nF4jt5zQYRJYOo9Ox7DNC70pYqXl+PRL9YVApu9rA0Hkrmk7E/aiFrkN7CdFM7io4PoRJW03hWm3uyveZWUiCoVKpeI1yv7G2ExCHISAfGIzv2yw7k3uahZeB/hfd+Q+VVQNdD2op1K+8AVaMtipwVwj1x/QHvGhVXiikyb9dUe47diAvhVUBipxrNOS+Y8hAkasO6u1JJdXBp3AWY/ZPjAC5E1iJwo8spsK3oPwNYDbHFWol1zNLp4XkXzKMDJsy0r97iONM+ldYVOQvXGZcIA2s+f8mekIMweCZ5r9m/hY6IPg9d38M2HwnUHSRSEIU4mNz+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MuFkPn++HpIjoZdSBySlSCStt9aabuIt7g47+Ki8o0=;
 b=BfL4mRPzdUzpnbK6SDFKztmSrfD8mRzJWy3xqsDdDCL+TQ6w7oXazxMvP+N4LtSmalTorzEruGyIekdqxG2MSlP+pDjKPyUXLT/sGGfQjDfKY865ccIkLj1tpRV2OGr8u4YZh3taKo5WJzNesiKme02BOnJjPuESsfkeDCFaI/cTexOsMXeO7sYODSfhlqRwqEXULXeTt1DUJ/vnDNyQ8aS5VAf80mriD2NfEOJ2G4v3JOOLEeR+vE+wkdoe4ljx8s5wIJgoa4QfQQ+h7NA0v8HwwXoToweM4uL73wXfSIJKzPngXBDeqbGf/bguwLu2yFtIikEhhcLAhJp9bjhsPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by MW3PR11MB4572.namprd11.prod.outlook.com (2603:10b6:303:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 02:53:08 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::903f:e910:5bb8:a346]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::903f:e910:5bb8:a346%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 02:53:08 +0000
Message-ID: <442ce443-a1fb-1cfa-e3df-14927307f9c7@intel.com>
Date: Mon, 15 May 2023 19:53:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH iwl-next v5 02/15] idpf: add module register and probe
 functionality
Content-Language: en-US
To: Stephen Hemminger <stephen@networkplumber.org>
CC: <intel-wired-lan@lists.osuosl.org>, <shannon.nelson@amd.com>,
	<simon.horman@corigine.com>, <leon@kernel.org>, <decot@google.com>,
	<willemb@google.com>, Phani Burra <phani.r.burra@intel.com>,
	<jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, Alan Brady
	<alan.brady@intel.com>, Madhu Chittim <madhu.chittim@intel.com>, "Shailendra
 Bhatnagar" <shailendra.bhatnagar@intel.com>, Pavan Kumar Linga
	<pavan.kumar.linga@intel.com>
References: <20230513225710.3898-1-emil.s.tantilov@intel.com>
 <20230513225710.3898-3-emil.s.tantilov@intel.com>
 <20230513184535.1a07c5b3@hermes.local>
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <20230513184535.1a07c5b3@hermes.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0078.namprd05.prod.outlook.com
 (2603:10b6:a03:332::23) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|MW3PR11MB4572:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d9a231e-ddd7-41f4-f6fb-08db55b8adc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ftOpdM+TjrkBxX2lUYQ++o/3x7cya8q5l5J060iYxr38aI7lQNn417UGF4cBsVwEd2XlSohaVHMnc2jljRCnat2bXb5yJNxyaC8c34agDj4HDWc7kSqyAIGukFXoZoe8Sq69eaNtuPNGSjH6OYkG/S68oDT6CFttx7yCZPzySLzPoUH6Vpe+h4yM2iStz8FufpBjNLfLa07dHTh2XtBjMkWUG5AFYfvHXdJeikNUOqvdvAkn7fcXe3RNAtJyf1YDbNlnGitOVKbLAYU3tG1Q85C3SjPbkm7wRmsOev1tL7G4GdqKlQu3QaXl7NHQFuayPyl01m0YGo2TQhqWM3e6NDCuUAZuANh9XZmeJUxEvZ4U98mfG+osdKpvpjs1LgZKDyWFuoYdWD+0/Bhnbfk9FLm9tedFng5uLauK4kIjZOkkNFjmpvXMg+/jCOwSvl+Drq5YSbYoEHcbgU+VC/6TCLWo5muByASMFMjtALf/V9OzgqCchPjS89WMjDaI+orfwAVcBnS3EuWqOpeBlmEEfPUjZ3IzTPaK53dFdAnnWDrHyIQcQHGT5ivm44fi95YtG8Ug7/ik6pCR7yBZrn/ZbDYY0eLzQVqMf3mdD8dX4YGtO1pn4JllLztRklye+hi0fhoC5KXuoyrWIWa87NVGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199021)(31686004)(4326008)(66946007)(66556008)(66476007)(478600001)(6916009)(6486002)(86362001)(316002)(54906003)(36756003)(26005)(53546011)(186003)(107886003)(6512007)(6506007)(5660300002)(8936002)(7416002)(8676002)(6666004)(2906002)(2616005)(4744005)(82960400001)(31696002)(38100700002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVl4elpLNUxpanJzS2NxMmxNbzQyUSt6MlBGbk1VNFVWa2tYejMvWUxycUs4?=
 =?utf-8?B?ZktNRWpoYW9ZM0IyTVVYWWMxMHR4R25wcnBBRzRGanlQSWptMFJJbTJrS0h0?=
 =?utf-8?B?Z1V5blRZK2tMcVAxeUFjT2krQlpXZlZ2YlVuU0RTaUhaT091ZXhBLzJpSDl5?=
 =?utf-8?B?T3lwcnoyU0xQeFpDU0tVRnBGY2VKNzdlblN6Nk5Fd2lWTk1PUGY3U0JwdmNa?=
 =?utf-8?B?OWFUWHlUL05yK3JMajFZUWE3TmNSVFRWT3pzbDFTamtzWEZGMFNEa3dUUHoy?=
 =?utf-8?B?OWYzY2JMZkpseVRwOU1xZzZJa09VNUNqeHl2cmc1bXluZUlCdTFYcGVKMUpr?=
 =?utf-8?B?cHluV05mWFNBSWZDVG9MdFdEclB6M0JJOXZ4RkVLNXBkWThSR0tHYUhSb2d6?=
 =?utf-8?B?UWFBOThCb3BaejlxdGpROFRwWVRlN0FXalEvZ21rYXJhUzR6Z2h2bjhCbVJv?=
 =?utf-8?B?MGpZZmR6VmhTYU1aMXhGb0pRRlNQUzVTdDhYcFI1Y2xNejgrcXdCZitIV2ls?=
 =?utf-8?B?OHo0SGUzOUZtR1NUNmdod1dsbmZicFRITzFXYy9PY3pFcjlwaVBhVTl5dHM4?=
 =?utf-8?B?eWZOR29SdDBWK0Zsd3JjUUcwdUM0VW83SXpkT1dSY2xsWEJGeGQzR01xOS9y?=
 =?utf-8?B?ZWdqZlNqQzEvY1dabDhmWitYTXlBSm90WGRYY2xJMXRkTUc1SUhRc3BvZVNG?=
 =?utf-8?B?WVdvcmNLYW9DbjN3OUZLQjgxbHJsNzFjRWtOTWNYRDRNK1NPaUI1QnlBQ0Uy?=
 =?utf-8?B?a2JJRlFOSGRLeEhIUWNUdCtTb0tJSTREd0ZHb2twUThnZ2dEODQ0UTJZdlVX?=
 =?utf-8?B?T1U3WGJkSlNrbmhoUzU4K1VRMFZnaENWd3lyYkYrS3I2OEFCc0JIbnlUYmxV?=
 =?utf-8?B?M2tlVklEOGhBMmFhRjdiS3dQWWVka1N1VFpKaU5QNXhOZ2N0RmtWYjJTQlhq?=
 =?utf-8?B?MWFaSEluYVFLWnFoVXl4c3pMcDFSWlNRNGN0SmpXaUROazZaUE9zSDhMS1B6?=
 =?utf-8?B?UE5FS0o5Z1c4R25DQUd0OE93QkdMZUJ5WHppOFZBV2JvaUtwb3F5Y0tyYmtZ?=
 =?utf-8?B?U3VjZFNFOUkxQ0xoWnpTdGlJR216TmpZcVR6ZlBGUGhkbXFZeFM4SGZrR2t2?=
 =?utf-8?B?WEhpUUNNOUVRK2dXelk0WTR0aHkyR05pMUJaVGlUQWxqYTdKUmlCMS9ranl4?=
 =?utf-8?B?NG40UGFyS0liaUZPc1BBSFYvazRFRnNtV3JLR1A1MmZHUXdNOHVXUnB6YmNK?=
 =?utf-8?B?ZzhENDV0R2NzekpZQys5U2FicDdkQkhQQ2F2OXdNQnhXOVk1TjVWNlB4SXY4?=
 =?utf-8?B?QWx6N1VTZkowNXRvZkNZMWk2bVI4S3RUL05IOFJKTjN1MUh6a29mUmxCYjBh?=
 =?utf-8?B?WFpSUHE2bUlSbmhic2Z1NUd2YzRTUXBnbFcrTTZSc0NZN3VUT29qNGJJdis0?=
 =?utf-8?B?SXg4MC9SSnNkdjkxa3I1UG1kNGozNHBZOWY3U29oRzRMc3liZnRFbHh0NHZB?=
 =?utf-8?B?bFlQN1MyQVF1NzFLaEp5RFhoMlZSSGZaV2laNzJaSkNXMTI1NG42VzVKK3Vv?=
 =?utf-8?B?Umg4bFR5OEJFN0NEdkhsWi8xYTdVWmcveW5wcG5rMUhPc056YUk5cWJ2d0Nx?=
 =?utf-8?B?MmVXd2lxaXh0NUVxY0pZcE5FSWs0RVJDM3dqeWlENmpoSjNQdHJvUE5FTXVu?=
 =?utf-8?B?emJaZDUxaFJnVVdFckFRWmZyVzJJN1NlNFp4MnZnZ0d0RTA5YVJZREdLekFw?=
 =?utf-8?B?eHNIMHdyZ0k5YVpJeGdYYVFpVWVTN0l6N3I5WmFOR1czMXlBRmhLYTZXU0tM?=
 =?utf-8?B?NlVBUFBmSEVMQ1N5bE1PK1BPcWZEc2hxemplbSs4cTR1dDU4VlIzc2ZRQVZT?=
 =?utf-8?B?MjYwRU9DNkwvMENEak1kWjBaVE5SQXQzWSttVmVsdThuRDB4b3UwTkk0RlFr?=
 =?utf-8?B?VkxPRzA1QVduclRSbjFud3ZBbXRLOG44ODNvcmlJL3hOZjVZRVgrMEg1bkpE?=
 =?utf-8?B?NnpEVE85NDhtUzdlL281WDFvNHVHMTlQekpma1drdHlwczdibXdMc3VlTHd2?=
 =?utf-8?B?TmJUek5acTQ2UENyYTVwaEFKanV5VVU2Z2Uva2Z1RFJvSW4vSEdYWXNuTEd0?=
 =?utf-8?B?RWR4NVRkRzNiaXJ3aGxWdmlDaHRhclZ1WjcweGwwajZNR2xuUGNEQzgvWVE3?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9a231e-ddd7-41f4-f6fb-08db55b8adc0
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 02:53:08.3417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h73tIEtHO+RpyxOr06/rZu4MrursXnIclkfetpe0G/9SHJzeTV+6c/s8+scSTiYDIezUX6PlEbqdCNE0ZH3X3HY3NA9ZBqiAGPMmNzt9PQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4572
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/13/2023 6:45 PM, Stephen Hemminger wrote:
> On Sat, 13 May 2023 15:56:57 -0700
> Emil Tantilov <emil.s.tantilov@intel.com> wrote:
> 
>> +struct idpf_hw {
>> +	void __iomem *hw_addr;
>> +	resource_size_t hw_addr_len;
>> +
>> +	void *back;
>> +};
> 
> It is safer to use a typed pointer rather than untyped (void *) for
> the back pointer. This could prevent bugs.

Right. Will convert to typed.

Thanks,
Emil

