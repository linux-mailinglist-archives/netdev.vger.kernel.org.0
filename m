Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553D562FC10
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242463AbiKRRz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242265AbiKRRzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:55:48 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893FE697DE
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 09:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668794147; x=1700330147;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R0QvV5lIxtOuHk8S1EC6qtToRX140aXK0B3Xhdh4elI=;
  b=hIcP3eKSGrQzS9Pm3j/oegW5VYoR+eJ5ZsAizhwOqDLPrTOb+jv8N6w2
   aHJUBRCBy97O7KZcrFVN3nJ3W8jOpqFL9kjm919IXAstfEhZ+MMm3U/UX
   Hz18GigpqT8uG+JZL0m8xbhdjIzHMERb5eRvbtNAWXSXkGUzs/qcxDUBe
   iLfSpnz+nBv3bMo8m17FFARJuJ2JF/gnUaWrNvAQPDi7CGNCXD0OFYt/E
   w3AlrgdJ4LEx+it4+XTqNl0eV3zuVmwILdGSykvE1UXmKlPAT56O7JlDZ
   bNgnndHh2+vOzwaGI77hKBoWskaxFa8dCF9ssjusjC5NctZ9+MOkDwnvX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="292895691"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="292895691"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 09:55:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="634506882"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="634506882"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 18 Nov 2022 09:55:41 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 09:55:40 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 09:55:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 09:55:40 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 09:55:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lORY6xg4KHddaC/u7dGtilvswodHbkn/TUTj3zVtYUM2hBqhAdsdMBpDxj+yCgjdjWJPZ4b9PWF32ETjVseX2v04BKT5FvEfyIcgovRlMHGMQ/Se5ynU7jeBLa+7rITYY9XONfi3kZS8+zXmuOVW4qcX++/bbIJkLRpbGNyELYHXadgTfYw52MBx93UN2K/y6OSrjfDWyujqeLjJ8C7Z4ZLv8FviT5qIG6cePmgfNlJBd0QjDsPqJQQjvh1k4V7YKtB2Ts4F7TvLdUHUN1DPsYotkaRlhi72A5/blsuEtXzIvVfdAgSNnq2BDhlEZ7Ae5oL2maGlzit2ERh5nR3vAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PW1Db2gxZQACamPVzzyMkpdhptSw5YT8IST9Ext6H1A=;
 b=Wv4XbZNKsgxJlq+Z2u6U2iLKrdfH88BjSz1nri+pHXgwVCQrm4DLBdMt3tqMheid0AMwpUAOgd3x/WY3bxW1zXqB2PaBzMMwLwYL+i54BifzYh29E+fogGiMhparC7M1pUHjRU3QUWB88dwR/m2riwrMd1KHT8N91nwhHvSq6mgr7OaHN6XRTqU9pCXoLmAivLP/THFMlh4bJ6ymUJvvwH/A9ofmPSoitakayll6dGkNXlkeqxtOtPUGfB5r6gUYSJ93+AQYRxjTOsnQ30nzcBpQp+QQPFbIcyA+BiRGT4919Lzvu3y8EVs3N/qutipmyndVvyLxQi4ZUy2nxZRwOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by IA1PR11MB6291.namprd11.prod.outlook.com (2603:10b6:208:3e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 17:55:38 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9%8]) with mapi id 15.20.5834.009; Fri, 18 Nov 2022
 17:55:38 +0000
Message-ID: <d9a3d57b-e72c-8f8f-b4ae-979836d87d32@intel.com>
Date:   Fri, 18 Nov 2022 09:55:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 3/5] cassini: Remove unnecessary use of
 kmap_atomic()
Content-Language: en-US
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        <netdev@vger.kernel.org>
CC:     Ira Weiny <ira.weiny@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <20221117222557.2196195-4-anirudh.venkataramanan@intel.com>
 <3752791.kQq0lBPeGt@suse>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <3752791.kQq0lBPeGt@suse>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:40::26) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|IA1PR11MB6291:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c0e0a7b-f026-4001-6dd9-08dac98e19dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4CbyFc7NVl/85knL7qDlTTUzT++FSLVrYZ3c0x+2+kmAoiqOO3fnUmW6pPESMKa4hclJnPJ3M5w9/b36ce63eHjCh64orhETyJl+C/0Qf4VR7LrW58wrg0UFHN4DloaOcBSc/tpRJRL7nTuR/9Av4jsuHqC5yYA1mup+vqsZYCmQfl/C5z5SFEFeA92hPKyPBDn+4JRn9W/9YAEuVJJd6ZswSHnfrSap4m5MPwepmBwjrTAiWUDAJPMsn7GhikUmFJkh1ifI+Bjrykkl7+F5iEoyBjRpKstAfJb6vB069IcbFbCSrunJ0/M8VMFLQEOady7VaQuBuTfIkqsFdR/N4arPnmk5tZuuJ0Zhf7uYrg0FJZCdGJmL+9rO9W1xf18jTUcsT0nuEkVfUiuyhZlsWMT9KjUCxOSanzeXSNM+xQ7EnP7TUK7idX92Y908uViYdhelFNsN70WqrGhiAd1ixwySKI58PqTnt0P0OKOPOHrkgGtEVBGZtjn2aA0G9u6YlNWp/FbOuvQkElZwvd1O3rzmJ7wp1h0SvGuYYHqw7MX+UDr5+hCtfEZl9e4zH9iVDli+6VZnNmn0vhtQpYI0da9vCKrq5vOkvSoF3qS4yo2C16vQOwaeioliEh4zs9UTyYxH3hw1wA/i0/NKAgFQ2TruoYvpb2JO57dDvXaw9VdplxUg/CCP7QRrbfuLT3HqiBCCgz2TQxiFz7mMi3kOnpqDmsmqUt7uCMo8VWRcPU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199015)(107886003)(478600001)(31696002)(6486002)(31686004)(86362001)(53546011)(316002)(26005)(6512007)(41300700001)(2616005)(8676002)(4326008)(66556008)(8936002)(66946007)(186003)(66476007)(6506007)(36756003)(2906002)(82960400001)(83380400001)(38100700002)(5660300002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFM4NnNSVEZqOHloSFJQMHRDSVRJSFhhVis1dUlXNlczdGZSWmcrRFJ0eEs2?=
 =?utf-8?B?Yi84V3dQc0JmWldoK0o5WlpTMVNvWXhRZVo3RCt6K3UvL0twQkFzU0Z6RXpI?=
 =?utf-8?B?MTVPZ1pieVNXRFdJVWlsNzc3N25aVkRaZDIxN3hobHcvV0dhZ2Q0UThVNmdr?=
 =?utf-8?B?K2RKNEZEUGoxVHNvdnhpU251cy9uNGIzL0tYMXVkQUlweHZCamtjZnJtcXJZ?=
 =?utf-8?B?aTRKejk3V1Z2bFBpZWtZNlpjV0g4OXg2b0hJakFxdFRTMGJybDlxUCthUElv?=
 =?utf-8?B?UlVYWDd0TGh5Z2diTFBoKzVydE5Pb1paMWRIL2dHcHp3dmoyMXczWi9ONmJ1?=
 =?utf-8?B?UVpGUHk3ako0b3BrOVBHMWE2SjFrMXZxdWo3ZW5YbkZ3QUhNdXdDV0ZIWll2?=
 =?utf-8?B?VmpLaEFOMEpiQS9zUXh5QmkveDh1TVJLQUV4Zy9kL2hWLzlsMWxmTUtISXFt?=
 =?utf-8?B?MUFXYi9YV0d6WlJXYTBFb3JtaHVWNm1sc0txN0xzbFAya3h2YWcvQzVqNEdY?=
 =?utf-8?B?RXdpbEQ5RW5JUHcvOGhCR3FmN3ZRVDNaOU5Va0Z3eHJmWDlrUE1vU3FUKy9O?=
 =?utf-8?B?bW1pME1CbjNvK1U3dDBKOWNrSTk3UGZvczdIZ3pCSVdLeHFtR0t6MWVTWVMw?=
 =?utf-8?B?ZDdVcG1jZU5SbjNXYkJENmNtMnkzU0hCV1AyN0ZsK2xwbDFxY2FHT1ZXY21t?=
 =?utf-8?B?Wi9YdTdxaFZTdWxjKy9lelhxN0s0dmJrTFZtT08rQ3NQbFJ1ZEc1Ym54K3Vw?=
 =?utf-8?B?L3h5RU9LOHBnNVpGLzhjK3ZRKzVZUUFCWVFhckNYNmhlVDNWalVUOVBPTU9j?=
 =?utf-8?B?cURQM3gwK2lUMmNBYnhtVkVyQWZZdXcrMDF5RkxTSFZqelRleE5OSDFwSzgr?=
 =?utf-8?B?MTQvR3FPUGpVUlZGZjhEUU5LemNObVZmWGpZbWhZcWFRU2ZqQkY4djZqbkp3?=
 =?utf-8?B?UVU0RmpteDhVZ3A5U2NVa25nM0VNRVdTNEU4YzA3cEFYQXhmaElvUWVXbXVB?=
 =?utf-8?B?QXZ0aWpXMzNiU21UbnBwTmxMVmdURGEzT1EwZmk3ek1YemJXYWdnTiswMEhX?=
 =?utf-8?B?QXcwL1lOS3EvUEpvOFBVQmY3OHNBa1JYYzdjVUZ4QmdRTjNXMS9aVk42aFRZ?=
 =?utf-8?B?TWdMY3I4cWkrQ3NhOUQybFFGckw5cjcxc09OUmI1SGg2a29xckpEcWRoZSsv?=
 =?utf-8?B?K3JEMExDeWVXQXF0T0lHeEF3bStGbGduTTVIcEI1ZVVvVDR6RzBFekticXUr?=
 =?utf-8?B?QkZQN0FwbG1lQWFUdTlhUVczUFlHNEhOZXV5R0lFR3RZNko2Nk1ybmlmajNi?=
 =?utf-8?B?MmxHcXFXMzhIRlZzNUsrQWJLbEFhZWQyWUFJMm1welNRNDlwQ00xV1NJR3c1?=
 =?utf-8?B?UWo2RytSTHFaa3pibFpzUFVaOTRyWVBnb3dqVk9WbFlITWcyazM1aHVLbTFM?=
 =?utf-8?B?dmp3SURFOUlpY0RLK3hNUzNUU3BiRXJzZE5Lbkd4OUUyN2R5MzkzV0RuZXcy?=
 =?utf-8?B?bWpDSmlsbmxjWW9hTXVRcCtlcXBEWXFoZUQ3V3ZQM1kzcFdIbEZVUlpEeFI4?=
 =?utf-8?B?MEFhenphQzAwL0FYbXJ4RzNNaU0zbFlaajZ5WGRvSFU4Y3F0WWV3YkFrak54?=
 =?utf-8?B?S2tUdFZZanRPMjhGcDlCSHRaeTlCc2hFaWtCU3ZQQ2w1dWtKbjhqb2JlWlhG?=
 =?utf-8?B?aVFnbndOUS9WMThtK2Q5bXM5R28xVjhkcUVFc2VYa3UwUm9oMUEwa3hqK0Mx?=
 =?utf-8?B?SFpaclVqY25yUCs0QWI5N2p5U0kzMUd3QVF0TEhPV05RSkxyb0NaeWlUZ25L?=
 =?utf-8?B?VUJEVjhaY0hrcFdrUzBNMjJ3YjMrNkQwUmk2SlZXaTV2SnFuaitWYUhnNGg4?=
 =?utf-8?B?SFdjS1laK0g5OUdwTEIrbmhjZE1TZnJFWm15dGxJQXRmbzVUVll4dXpobVJi?=
 =?utf-8?B?UzdSbXFrRHZPUFVHYldROWNhTlFxbWlIL2ZjVCs4eXRPZi9Ta0FYaUpMcE5H?=
 =?utf-8?B?S1dRRnhLQzYrdnlQTnhzaVA0STBRY3owbFdoNGNTRkJVWHM2N0F2Q00zTm4y?=
 =?utf-8?B?dkl4YTBJWkdjblkrRGxURU5mSFl4OFk3MW1WYlVmcnUxNkRiSlBXSlRLMUFM?=
 =?utf-8?B?UkNSMC9oWXNjaDJXUHdDWlpQNXlDNENqak5xL2Iza1Z5d0xIbXVHTGtEVmJD?=
 =?utf-8?Q?KZOivjP05B9YzivzKncyYOA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0e0a7b-f026-4001-6dd9-08dac98e19dc
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 17:55:38.4393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5q9dG3Mf9YbKyWfGD2D4K7bLiuxhjeh7hN3iSM/z223vJdpq56LY2Fg2Qb5oZyAsh6g4ZIavlRXjXL41V6XjuPWaHHJ7LIkkS7LY+GFtiZ1eJzUxoao6GCEuNz3h6z+6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6291
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/2022 12:35 AM, Fabio M. De Francesco wrote:
> On giovedì 17 novembre 2022 23:25:55 CET Anirudh Venkataramanan wrote:
>> Pages for Rx buffers are allocated in cas_page_alloc() using either
>> GFP_ATOMIC or GFP_KERNEL. Memory allocated with GFP_KERNEL/GFP_ATOMIC
>> can't come from highmem and so there's no need to kmap() them. Just use
>> page_address() instead.
>>
>> I don't have hardware, so this change has only been compile tested.
>>
>> Cc: Ira Weiny <ira.weiny@intel.com>
>> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
>> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
>> ---
>>   drivers/net/ethernet/sun/cassini.c | 34 ++++++++++--------------------
>>   1 file changed, 11 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sun/cassini.c
>> b/drivers/net/ethernet/sun/cassini.c index 0aca193..2f66cfc 100644
>> --- a/drivers/net/ethernet/sun/cassini.c
>> +++ b/drivers/net/ethernet/sun/cassini.c
>> @@ -1915,7 +1915,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct
>> cas_rx_comp *rxc, int off, swivel = RX_SWIVEL_OFF_VAL;
>>   	struct cas_page *page;
>>   	struct sk_buff *skb;
>> -	void *addr, *crcaddr;
>> +	void *crcaddr;
>>   	__sum16 csum;
>>   	char *p;
>>
>> @@ -1936,7 +1936,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct
>> cas_rx_comp *rxc, skb_reserve(skb, swivel);
>>
>>   	p = skb->data;
>> -	addr = crcaddr = NULL;
>> +	crcaddr = NULL;
>>   	if (hlen) { /* always copy header pages */
>>   		i = CAS_VAL(RX_COMP2_HDR_INDEX, words[1]);
>>   		page = cp->rx_pages[CAS_VAL(RX_INDEX_RING, i)]
> [CAS_VAL(RX_INDEX_NUM, i)];
>> @@ -1948,12 +1948,10 @@ static int cas_rx_process_pkt(struct cas *cp, struct
>> cas_rx_comp *rxc, i += cp->crc_size;
>>   		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr +
> off,
>>   					i, DMA_FROM_DEVICE);
>> -		addr = cas_page_map(page->buffer);
>> -		memcpy(p, addr + off, i);
>> +		memcpy(p, page_address(page->buffer) + off, i);
>>   		dma_sync_single_for_device(&cp->pdev->dev,
>>   					   page->dma_addr + off, i,
>>   					   DMA_FROM_DEVICE);
>> -		cas_page_unmap(addr);
>>   		RX_USED_ADD(page, 0x100);
>>   		p += hlen;
>>   		swivel = 0;
>> @@ -1984,12 +1982,11 @@ static int cas_rx_process_pkt(struct cas *cp, struct
>> cas_rx_comp *rxc, /* make sure we always copy a header */
>>   		swivel = 0;
>>   		if (p == (char *) skb->data) { /* not split */
>> -			addr = cas_page_map(page->buffer);
>> -			memcpy(p, addr + off, RX_COPY_MIN);
>> +			memcpy(p, page_address(page->buffer) + off,
>> +			       RX_COPY_MIN);
>>   			dma_sync_single_for_device(&cp->pdev->dev,
>>   						   page->dma_addr
> + off, i,
>>   						
> DMA_FROM_DEVICE);
>> -			cas_page_unmap(addr);
>>   			off += RX_COPY_MIN;
>>   			swivel = RX_COPY_MIN;
>>   			RX_USED_ADD(page, cp->mtu_stride);
>> @@ -2036,10 +2033,8 @@ static int cas_rx_process_pkt(struct cas *cp, struct
>> cas_rx_comp *rxc, RX_USED_ADD(page, hlen + cp->crc_size);
>>   		}
>>
>> -		if (cp->crc_size) {
>> -			addr = cas_page_map(page->buffer);
>> -			crcaddr  = addr + off + hlen;
>> -		}
>> +		if (cp->crc_size)
>> +			crcaddr = page_address(page->buffer) + off +
> hlen;
>>
>>   	} else {
>>   		/* copying packet */
>> @@ -2061,12 +2056,10 @@ static int cas_rx_process_pkt(struct cas *cp, struct
>> cas_rx_comp *rxc, i += cp->crc_size;
>>   		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr +
> off,
>>   					i, DMA_FROM_DEVICE);
>> -		addr = cas_page_map(page->buffer);
>> -		memcpy(p, addr + off, i);
>> +		memcpy(p, page_address(page->buffer) + off, i);
>>   		dma_sync_single_for_device(&cp->pdev->dev,
>>   					   page->dma_addr + off, i,
>>   					   DMA_FROM_DEVICE);
>> -		cas_page_unmap(addr);
>>   		if (p == (char *) skb->data) /* not split */
>>   			RX_USED_ADD(page, cp->mtu_stride);
>>   		else
>> @@ -2081,20 +2074,17 @@ static int cas_rx_process_pkt(struct cas *cp, struct
>> cas_rx_comp *rxc, page->dma_addr,
>>   						dlen + cp-
>> crc_size,
>>   						DMA_FROM_DEVICE);
>> -			addr = cas_page_map(page->buffer);
>> -			memcpy(p, addr, dlen + cp->crc_size);
>> +			memcpy(p, page_address(page->buffer), dlen + cp-
>> crc_size);
>>   			dma_sync_single_for_device(&cp->pdev->dev,
>>   						   page->dma_addr,
>>   						   dlen + cp-
>> crc_size,
>>   						
> DMA_FROM_DEVICE);
>> -			cas_page_unmap(addr);
>>   			RX_USED_ADD(page, dlen + cp->crc_size);
>>   		}
>>   end_copy_pkt:
>> -		if (cp->crc_size) {
>> -			addr    = NULL;
>> +		if (cp->crc_size)
>>   			crcaddr = skb->data + alloclen;
>> -		}
>> +
> 
> This is a different logical change. Some maintainers I met would have asked
> for a separate patch, but I'm OK with it being here.

cas_page_map()/cap_page_unmap() were using addr. Once these went away 
addr became unnecessary. It would be weird to leave the declaration, 
init and reinit for a variable that's not of any use, and so it was 
removed as well. It's cleaner this way.

Ani
