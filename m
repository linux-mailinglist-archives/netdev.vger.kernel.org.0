Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86F45A2DDB
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 19:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243241AbiHZRwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 13:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiHZRv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 13:51:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8F8E095F
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 10:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661536319; x=1693072319;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ntbm0f6SOQbEswCsuFpczizqM5maYW+a707f1gUS+ws=;
  b=TkT0xJMyU09REeh6gboAlFu2kEO1W6gf1Qtt95cpiFSc+OlWYkrXDNdi
   hTDZ85KzOHufaJfqpPjbXrDzxGyDs8wyRJPQH6O1McnRiWZ2+zlbMA18M
   wQeDG52I8aFL8Z4GkAWt4UPGKZVwAWwJ52pubJn6cMaBV9z9Sy48hz6qK
   sUcHE2E1C49MoVCTmhRroiR41+Xr+CbISkrY4uveQ673lXiVwGeIuDgUW
   tunAxB/zB5+gbAzYeDgbH+/DE4EE209ZxUoY0UwV5mdGIEX/Qb32jnhs3
   TvTX7qKFxlRKWruRgJ0PFxVG4aFk/tGibjXXY1Yi61AsBtQzfa0ne6DjO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="358527218"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="358527218"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 10:51:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="643747729"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 26 Aug 2022 10:51:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 10:51:58 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 10:51:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 26 Aug 2022 10:51:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 26 Aug 2022 10:51:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hhx/LAjVE6vkiCTDMm8GFDmEfZAGCHbqjGPqztsZqntgG8tJ6SBbxJaiyOewViVwBH7UbuIupCuemA0WXEtnmHvwloXYpkHAIDmbHr2lSPcXzvzpNLN89VLLR42rcqPTdWE/N1dkxFIxZoCvre6xL2jr+Q4zNZ+18+2Pby0UwLSzb4eb8QU6jaFPLnr2myTyFHTv8iQceK+CZwkTpDzg4W8oVECxAwj35tzOOYq3xXqj15yJG8ivkHFnMtzWmbS8dT5ubNbV1GZjmdYeJKA59sEo9XPJOmggXldrPHu+byZKbeMaYlOu6/X1hLGbhCjUGASBpcB7JgsX4cYznfRx/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9VsSfautMQZqLKIE7pEQQytTHtLufDU5ICT45y/+b0=;
 b=bhU9Z3ly1KR082ye1yFncV44NiV1ABC/gn4MgQeXZHP+gM89dUc9mmv6P5UKJ3bWhxsZZG+1QAu+3E3jx0Y4ix3oIfVRD/ODoq57xd+7XFk7D/y+qxx0G+ppQRaSdc6xiPCaYWgGLo7rrHkBKL8npeJg1UXddOuB2C/KTKYPoJGrzFLgDqOpuBG8/BsvKXZaVHlMO6VTiUFJByvhBrFh+yOztlWuYxgCPW96RLdue451wVDoofLHEtUM/mcGkmvFC2div8nEmYkZx+K+OQdnpcMRfNOl4Gj1RSAJdIy1RgOKSLzFw9vB32iiuC1xD0MedUcokRhw/37hs5bj/s5U+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5304.namprd11.prod.outlook.com (2603:10b6:208:316::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Fri, 26 Aug
 2022 17:51:25 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 17:51:25 +0000
Message-ID: <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
Date:   Fri, 26 Aug 2022 10:51:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
 <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
 <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
 <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
 <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
 <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
 <20220825180107.38915c09@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20220825180107.38915c09@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0240.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::35) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6062e00a-cf71-41bf-2795-08da878b988e
X-MS-TrafficTypeDiagnostic: BL1PR11MB5304:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 952uLYs9VUAnA4v+4W97yOxavGqbakeyqqmrV98uOmXUPqDVKYos6BRLWql0ChwHm1h94G+qZhVXueJUkH65bUBPvw/QvE1yQYtKGiSq/HsATVyxlUV5tIZxoxys62hJSlC+STEnVTjZkAZCItLIq4FHxiARidLO7u5JvIizt6KQKVOY1KD9Vm+i67C+pqFIvkWUXvbsqLW8lZCkWEaoPfZurl1gicaNugg6ArQ5UTOFWmsx5HZh4oJvCqwyRwnEUizFuZRLPlvRmlvgRK+fatMHOelE/EGC4qFDX1/pn7N47dFv4CKF7g/F6BAULM2pBlQxWt0uZGSR824plhPH6W+0Jqe/xIOugbG9KvQbEU/O23HtaqgHfHBSS1NTb2s5tiNGo1BX6qJw8nE/xzqvMO2wQwthXE/OQkFnSV6TaRTz1c5JEx6kojr5WdkR8EOTR78ZsqjNgU5G3qQVuYEZ9ze5rM1JNkahZ7P6qv/ucOrO30jYU+pUI+zkhCzJA6rADiA+PC8Ap9GtwjLP951hW0XbtOh2lbG4xsw24Z9bFefGTU+Jxt18HmQ3AtnVOY8YZzYQUI0n45ngChQbHYRs0LrtOafui7pHmjjdqk9cokneQ4LFe0jK6zkKWboa2hJc2V6WvzKXPTXTVkGplzENX2elKIddJtuZLacjViVG6xKmfbG+PkqifeGb8AtJt4lnHmHIGvVF5TbCdS4+mtnAe8sOxHnwxpQxva1c6AypWh2FXWCp7folQ7+WqiEgt3cQfEfGXTbCky2q01gQllJo5MRFuQRcBKeFGypMnqLUyak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(396003)(39860400002)(366004)(86362001)(31696002)(82960400001)(38100700002)(316002)(54906003)(6916009)(2906002)(8936002)(5660300002)(66946007)(66556008)(66476007)(8676002)(4326008)(83380400001)(186003)(2616005)(478600001)(6486002)(53546011)(6506007)(26005)(6512007)(41300700001)(6666004)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnkxdzkydG9zbWUxR09HN1ZQdFJSaDlFNXVxNjlxWGhrVXF1QjNyZ1dXU3Jq?=
 =?utf-8?B?TExWRkFGUkQvUC92cFRaVHJrS2RSRlR0RXBxZHRoRy9Lb21LZnNrdlgyMHN5?=
 =?utf-8?B?dHRBQUh4TWp6M3hNMk5jaG9FRkdQNjR1M1BZYXI2ZkZDT09QdXNUQ1ZQeWI0?=
 =?utf-8?B?NENUNlNIYmFTbmtjTjdMVHFuSUVuMlJVUWdNbml0MCthenZaNG51WUFyTDAr?=
 =?utf-8?B?VmYrYy9qWUtPcnNHZWtoaEhTVWNhOU5HVG1pS05YYkovZXNvVU50WUtFZFdJ?=
 =?utf-8?B?aXB2TTQxdnZwTmVlZWV0QkswcEphcFRLMkhGMGdDSXRDNHg4WjhOb0JQazdO?=
 =?utf-8?B?Z3B5MC9QUjd1blkrRHZncFBzYnZ6YlYvOS95eWwrZDVWSkdvV1JnaXAwM3Zt?=
 =?utf-8?B?b1V2WG95VkhkQW02MW15dnBOYmx2QkRUMVNIa3lQQzVacW5XUlJHUTFRY2NG?=
 =?utf-8?B?REVxMUo4OUF3bEJNK3BYUjZNWXdCOFlZMzRWSThJLzE4RnZjMTl6b1ZQVE9S?=
 =?utf-8?B?ZDNTL2I1QVZUTVVQWFhjRS8wMThFRmNkaTlWUnp3Z2R4Z1lvYlViSlRjUmFo?=
 =?utf-8?B?eWkzelJVYmgrVi9NcE1BeEkxeGViNlFZeFRQSCtXN2lrcUtrcGxyRWFrZEVq?=
 =?utf-8?B?ZnlrZTQ3U1FwdUdKSk81TUZPaElFT2lLR2F0eGhlNzFLZGxweE5ETGJ1aTNR?=
 =?utf-8?B?dEpabkplM1lPZWd2SGdJbzkrbytzK0RSY0RvQ1FZYWRMOGUzM1ptU2JCKzhV?=
 =?utf-8?B?NWx2L3Y2S00rUnBQVXZma3QwbzVUQ285aURKYWYvbitqOFJSNHN6VjNxN3VK?=
 =?utf-8?B?bmZZOWFVVGQrVWRuWjRiSUxpZXFsRnB0SFFBbWtvWDZsM25aOUlLelB3Tmgw?=
 =?utf-8?B?OUhzNG15eHgyQ1J4M214RVZ0ZElOV2hTcGgydTVwRStJUGMzMGRrd0pIRTBw?=
 =?utf-8?B?RVJ1RVh0TzY5NnJKMlNIYmxNWXd2cTEvcHBTQmxlZUM2cVU1aDRoVlhZa2Rz?=
 =?utf-8?B?c2lhU2FxV1Y3WFcyVWczdnJMbS9yOW1WWXFOOENCb1RxOWI3WjVGT0Jmd3NG?=
 =?utf-8?B?aTZzeFF0cW1ZR3FvejZSSnlWSWtQWFdxSWl1MjlWVHdhMEhZYTAycXZJVzdC?=
 =?utf-8?B?RzBVc3o3VEQ0d1hySXZlT3ZOTjNUMWR2NlhwbytnMXdwVmRsallJZVBuamdj?=
 =?utf-8?B?ZzdxMmpKb3FSWXJZZENoTlZqRmdKNXdnb0dkSkZSMHg5a2VBRTlKRytLL1Yv?=
 =?utf-8?B?cTR4MmVzMVA1SXU2UXM1Q2tha25WQndZR1VxVmpnczR1K1EzcWFuZzIxQ3Zn?=
 =?utf-8?B?R0pyQ1VYYmVOK1pkZ0ltQnB5QWRteTNTeUsrZUR2ZnNrNEJjVVNwdmxHamFC?=
 =?utf-8?B?aWNSL1hBRjF2dDhBNDFFQndzQm1DUDJXeFdEU1loeGF3cnhkcVRKMjBHKy9q?=
 =?utf-8?B?VyszVHNuQ01LOEE1ZFRFUnBydGxRY3pmM2hROHFTS0FyUm92ZEdXWXBvcVcv?=
 =?utf-8?B?L1BpOWFENExIUXNBVWdReXZESTFoQ3BVcXNnbU1EQ1NBVG1oTGVyUjFjdTdu?=
 =?utf-8?B?SGlvVGpmQVMrUGlpTGQwb2tncFdIT2wxMHR4cDFnQjdMTHJmRzBCazFvcXdy?=
 =?utf-8?B?YkgrV2JWMjR6cExZWjN3dXZxSXZ0Smo4RDl0Tk1VM3l4bHY0OVhKQWJPUS9F?=
 =?utf-8?B?bUxDdnZEMklqQ3dKWGdDejBPckhzZmhySE5DbHRkU1pROGwxN1pycHQyZEhl?=
 =?utf-8?B?azE5V3IzaVUyc3VBRlp2S29zQllNazIxSEhwdHN0NGI1K0E2dnlDS1B5Z3JO?=
 =?utf-8?B?aE93Tnpua1puajBmYlNkelVUSk1UNzR5eVROUkw1OCtERXo3N0JNN2NvTGda?=
 =?utf-8?B?TEhiU3RkNHNENHhMMkEzZlRzNTRVYk9YUmZJVk1BdTZJcGx1dkNXN0MrRkM2?=
 =?utf-8?B?Y2lxOERIc1JuT095MWRicGxGSXVoVHpmKzV5czJkcWN1RDZBSmZheVRMRHBP?=
 =?utf-8?B?SStOTXhIV21xeG1pRnBPb2RJY1lCd1YyRmJybnZtdk00WmtEempIRW0zNTZr?=
 =?utf-8?B?aCtEc3NqVjZRNVpKZkdFSEJ6SVpRNmhBaWptbDgxcFlYM2Q5TytMT1RuOVFm?=
 =?utf-8?B?V1hEQTRweVB2NDJ3d1R3aWZwTmxxUGxNV2habjk5MldxUmpXY3lveFQyQlE1?=
 =?utf-8?B?eFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6062e00a-cf71-41bf-2795-08da878b988e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 17:51:25.7409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sL68eL7b5deUXf4ET0aQlZruG+l03FJjdM3LgBAmE7I/x8F7He1npozRKhb6cKD/vp/lO/MBULBXOvCm/N3yQPYvB8b+wayM8X0K7NnL1h8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5304
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/2022 6:01 PM, Jakub Kicinski wrote:
> On Thu, 25 Aug 2022 17:38:14 -0700 Jacob Keller wrote:
>> 2b) on newer firmware, the set PHY capabilities interface does have a
>> bit to request No FEC. In this case, if we set the No FEC bit, then the
>> firmware will be able to select No FEC as an option for cables that
>> otherwise wouldn't have selected it in the old firmware (such as CA-L
>> cables mentioned above).
> 
> Oh, but per the IEEE standard No FEC is _not_ an option for CA-L.
> From the initial reading of your series I thought that Intel NICs 
> would _never_ pick No FEC.
> 

That was my original interpretation when I was first introduced to this
problem but I was mistaken, hence why the commit message wasn't clear :(

This is rather more complicated than I originally understood and the
names for various bits have not been named very well so their behavior
isn't exactly obvious...


> Sounds like we need a bit for "ignore the standard and try everything".
> 
> What about BASE-R FEC? Is the FW going to try it on the CA-L cable?
> 

Ok I got further clarification on this. We have a bit, "Auto FEC
enable", as well as a bitmask for which FEC modes to try.

If "Auto FEC En" is set, then the Link Establishment State Machine will
try all of the FEC options we list in that bitmask, as long as we can
theoretically support them even if they aren't spec compliant.

For old firmware the bitmask didn't include a bit for "No FEC", where as
the new firmware has a bit for "No FEC".

We were always setting "Auto FEC En" so currently we try all FEC modes
we could theoretically support.

If "Auto FEC En" is disabled, then we only try FEC modes which are spec
compliant. Additionally, only a single FEC mode is tried based on a
priority and the bitmask.

Currently and historically the driver has always set "Auto FEC En", so
we were enabling non-spec compliant FEC modes, but "No FEC" was only
based on spec compliance with the media type.

From this, I think I agree the correct behavior is to add a bit for
"override the spec and try everything", and then on new firmware we'd
set the "No FEC" while on old firmware we'd be limited to only trying
FEC modes.

Does that make sense?

So yea I think we do probably need a "ignore the standard" bit.. but
currently that appears to already be what ice does (excepting No FEC
which didn't previously have a bit to set for it)

Thanks,
Jake
