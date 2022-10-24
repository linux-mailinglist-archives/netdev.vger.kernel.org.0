Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B44609E69
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJXKAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiJXKAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:00:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B2D57DDD
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666605647; x=1698141647;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=INq6tIvnsN//q2NaHGdgQWJvzGQ8d6V6d4vkZJiLbfU=;
  b=WsuCTLSIztO2Eck+bLkYw6vl9W2AjvcKqnMM+ln1HjY44too1GhGHwEZ
   US7q0LFYn1TGDY/dSZm6FecHRS7dIRz8YL24glmhl3niKW0grS82OWIlv
   Ij980TAp9qRdt8Z87jFLQhzqBdPMFTCecudeJ/nF8G+VdsgMqQV+gqBH8
   GpBLtwW/ixp1KzeGZOMZRpQSPMfcY8LSCdwSVwn2INe4+qeM7eKRlADTM
   EvZRz1buk7NDlQO/7qtzhvsM9DdW/iNGqiOo5OqvxlT8R5uB+NBNDmzg8
   8wfTWt8Of+eHJsWdd/ksOAfeLMbFHk1AX6l2/Z5Z+ne6WxSrudya2Ezdu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="371598671"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="371598671"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 03:00:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="694497553"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="694497553"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 24 Oct 2022 03:00:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 03:00:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 24 Oct 2022 03:00:45 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 24 Oct 2022 03:00:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKTW0Vbc/7apHepE62X79FdbeHmcS+K3ngOXgMCaiybMUHsXtkaFEUtJPKOxHhFBUULxravtMxmG/S5iJ2d4zlKK7KJNnNCWCmQAQJ0yDAdNGITfJt02Fca2XFKM4IIeokwoDdrNqTrjb9kpfj+tvRhqNW9C6KoHfq0hulXi8ORu4ta/2rYas2/Sw4Sv25sq54EJZIImdWnSlpu/bolbYDg5ZRCj6kiy46AjuPgdtsV0RJY1jyiHZjkqJMS5VBJSY4HZq2xMKqB7z50a5ZOePFz6oUIcFj0995wzC0ADnYQ6MNCvxy/wmhKSA4krX8gJJgZte++pT4JNMyMOXHiNMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FOiT9M0rJbhJMWSd8kWvz2VMhXwMveAhax0ptWhBHTQ=;
 b=ahc81ydkGiyfUhZ7zxjl/cJPy1hoU0Ocykt8brh7vhjnJsCSMpnzz8SEQ2P6/EVltycXynmJLMEl6ZbCERtw81tCf9OLttd6tDQoeuY13HNHT9E7NFMpgpVULM/F2Vp7qAtxJO1r1mda5LM1/HgqflDp9bly894VFrH8RCmXYmzx5H5im57reumODD1hgjDgUcrqjHGw3E0R3JpDMc6Zh/vPj1tyvW/TMn8qOwQ6+E/8goP9gUc5tb/bKj9m58MxQwQ7onaAtsdTn5n6zS/BpZCPZLQftOl8QJcIW/AMrHfyJRVVRKBawN7MmsaCPT2xcUcZVArG1ju7uUkNLhulHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 10:00:42 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::50a5:d88c:e104:48bd]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::50a5:d88c:e104:48bd%5]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 10:00:42 +0000
Message-ID: <cb8113b9-ad0a-ad75-0784-19b8e0bc3fb2@intel.com>
Date:   Mon, 24 Oct 2022 03:00:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net] genetlink: piggy back on resv_op to default to a
 reject policy
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <fw@strlen.de>,
        <jiri@nvidia.com>
References: <20221021193532.1511293-1-kuba@kernel.org>
 <6ba9f727e555fd376623a298d5d305ad408c3d47.camel@sipsolutions.net>
 <20221021210815.44e8220f@kernel.org>
 <1b5ce217d872cdb59b73f1dc745819861e46c8cb.camel@sipsolutions.net>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <1b5ce217d872cdb59b73f1dc745819861e46c8cb.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::21) To SA2PR11MB5100.namprd11.prod.outlook.com
 (2603:10b6:806:119::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5100:EE_|PH0PR11MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: fcf76f6b-2540-4cc2-4dc6-08dab5a69c76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1upJ4G/9v7F3/we9+C9owUSiJyZymfniq29TZH1k/io2mMxw2zsBYlqmtax0otn/CE1qZOQkEWpT0XqvNM5GGZ10hkWZOi4D8ZBkpk1ZiU+bpDFvCfMrfGT/iPwquT8ThAGmxkbxFtJFJGEDWmuyD9sQZecAKdiN7DBJ441MFf4kuUjxgiEI+Yo8yEuH4NK+tQ8rJcHFwnMUISWLG1xJd239I9mTC/dC7J9hXH7AaKLOSbA8dqu9PcyV5sWWLvmrV1UnpzqBwgOQvp6sBxBz8IIGsHAeHMvVjVbVmNqa75bm5b/g15HuQ/54hxC17A96AwNqg6pSXg1KY0enC8sjpylhS94EUsWALAKW8+mA9/QK9HJMshVRgyBmaCoFNyxBfympzIwQsYgEUdSYILxxVlNjX4X7qzi8Zqqdn8rDJKCHha9abgDNqvAj/1m+qhqVO5Z4edga+lmdzetBnnIUUa/AdWYZ5ATRIcW/04spQUB2Gyrv+4Iz98tkbjb0Fng2fIJDSONh+NgXGwXHWrrGjlh1d2cbK1eA4wpHE2XGUwqM3WSyp4flPR4iiD82nBJ+cnyw6YStdIh+PoYCT4HhkFkpGztko1tC0x8ltslSVEUQbyA/P1zBo0gign6tmgX2i6P+dcuJBdlBAxjY+8Q5YA1sjjq5V3kquLw3zaeJM+otxVetrd3mYPgFq8/bk2OKmtW2DT0CgyDPQQkX4QQc/AS1b4VAIIdbAiKURQgyrcLksOikaQyGGTHne8Pqxd42Tf9e+/lQj3n27ZfHSQMmQwficpapxk00YsM8n+icGY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199015)(186003)(2616005)(86362001)(31696002)(38100700002)(82960400001)(2906002)(4001150100001)(41300700001)(8936002)(5660300002)(478600001)(53546011)(66946007)(26005)(6666004)(6486002)(4326008)(66556008)(66476007)(6506007)(8676002)(110136005)(316002)(6512007)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkNUTlFockg3NVdCa29wMGFjR0JCTzFlalR3R25kRUd5NjVFWFphMVhJZWJ0?=
 =?utf-8?B?NERnWkY0VlhVcVB4eEErZldTRTkyY0ljWndSeUhYcGhUYkgyYThTTWEzWStE?=
 =?utf-8?B?ZXFDMGZmZHdYZXJNdjM3cXo5dG5pdjlPUnNNRzA3blovMXJMbnllbGtRZThO?=
 =?utf-8?B?cG4wTHB4RVoyaTg4US9aN0dwYnhaZUVtWkR5REhvVTZjUkg5RWdpQSs5WFZZ?=
 =?utf-8?B?OXQ1OFZ0WlRoa0NZOTkwejh1dGgzMkZhWlgyU0ROT3cwNnpVVHVmWGVLTG95?=
 =?utf-8?B?c1RJbXZWVGk5QWlOMGlsMmZtdmtUMHJ6Zk92UDZYaHpIcFNPWjd3dlQwWHRN?=
 =?utf-8?B?TnB3SjhhclJUN3pLM3hGWmtjcTZ1bExTYlB5SDJSRDVZWnl4Y2J1UGNKMzRR?=
 =?utf-8?B?Ui9rblBCOWNZdkowc1dMUE5ydFJyb3d6UDlrcThtbnlXNDQwWUQ2anpoejJE?=
 =?utf-8?B?d2kwWDZqcUVTeXU1d1gya1h4MjBqNVZETVV4Wk40b29rVTgzVkxKSVNtZktI?=
 =?utf-8?B?Vm9FOU5EaGpqUndRejgzb0hML1NtRkk1TFRETnVoNWxWUlR0amFKVnlLek9S?=
 =?utf-8?B?SGlRbkdlVTRoZFdBTTUwMDMwSlBvZTRtS0creGt4dzBHZGFhTW96dmxIcXJN?=
 =?utf-8?B?L3lTQ1Mrakx2MkdrbjNVQWY1V3pQN01uUWtJVkNSQUNRRS9hL0JOaEh6THhx?=
 =?utf-8?B?c1Nac056Y2pqYUxVcDhHV0pKdmNXUjBDM0w2Q0JTL1VEeGlQTnhzM25rN3BO?=
 =?utf-8?B?SnJ2VVdCMWpIR1BUUG1DbDJheHd3L3JuS3IvUHNOalg5QUdjL1ljTHlib3Ja?=
 =?utf-8?B?ZmRNMktac0t5QzVybm9JakpTdmJnTjNTcnVlVDNrc2dVTWd4QS9ETDZWZlpH?=
 =?utf-8?B?TjFkOE9xUVdPSHBDUHhVUStIODhhamp4cTd3alNHdU5ZZGcvWVhvSnA0aEYx?=
 =?utf-8?B?Y0RpeEVGTlRKTU9tSGQ0NmUzNUl3MWszOEZCbTBZbnBCUmt4aVdtZGdCKyto?=
 =?utf-8?B?d05tOVcwWEc1VVVlU3NodXJpZG55R25KTnVBbHNuZ0ZPL0dQcEdSbmFzSUZa?=
 =?utf-8?B?TW15aitNaGxkK0lEU2M1LzR6bDV2N0Y3RFFYaG9uUVBvMDBQbStidlVucHQ2?=
 =?utf-8?B?UDg5Q000SStEWkY4K2RLdURtblVhVzEvWVkzZ2JhMnkrQjdkR2dUbHo0Vity?=
 =?utf-8?B?K01ibUMwNWRYWU03RC9CZ1FVRHA4NjlSWlg2REdKRXVsdW52N3NRR1dsd3Bu?=
 =?utf-8?B?azR3UXhuWDZRcDBUSWY4T00rUkNWSlpxRjE1d2RKTGlQUG5pbE9FWWN0QVRI?=
 =?utf-8?B?MHBrRWsyczFaRG13VERBV1IvS0hnVW1iSm9tZmtuVGpSWXk3R3pkeDh2eE5T?=
 =?utf-8?B?R0lhMTZsVlQwbk9HSS9OWlpPSnhIV1lNcWtlOGhaZ1poaHJ1Mnh4ejFVNnFM?=
 =?utf-8?B?Y3FWZHFuZFQ4ekdJd2VtdHpVL1dGYnFVS2YwOEExa0ZBdWVqOGFTekpyMGc5?=
 =?utf-8?B?VVFNdmxYQ2hRNXJIdjVzU25KWHFrY3MxRldISkswV3krRUFiK25vSjB5ZEls?=
 =?utf-8?B?THFGMTREYmxqRlIvQ3RmY3djc1JybzlCakVBWnhzdDRSdHlxaGVxZmdDb0w1?=
 =?utf-8?B?L0ZNMUYxNFBySUtCZ1J6aG1CN1RrdThRQjRQemcyVUFKdytvTnRTRVZvQWU3?=
 =?utf-8?B?aTM3bGV6bUhSQk5lNWM5SEdjanJHLzBwNjF1aXVoYnJlc2hsQ0NDYXdKdUxV?=
 =?utf-8?B?TldxTnBSUnNOWTE4QU1YWnFUOE9ZdGw4dmpyVG45RU1QNEoxTllDL2V1YjZH?=
 =?utf-8?B?aVZkY3JkSUwvL2xCcldtV3pRTU5aa001YjRIbEx2OWhqUGplY1VLMndaVDE1?=
 =?utf-8?B?OEJxYzg5TlhUbzRXYXZ5L3B2QjhzUk9OZFNxeXFxL0NhKzhDb29DdWlKSGZ0?=
 =?utf-8?B?OVZ5V3J5Y3R0NDdjdDVRTUFmT3FISUM2NEc1a2pvU0dMemFYWGMvZ0w5ZFRE?=
 =?utf-8?B?dVh3cWVKQTlYTDExc2NsUHVsWTMvTUFsNjZ3Qyt4bHljNU8wVnBsdzhRS25m?=
 =?utf-8?B?NjMxbUJRc2RsWXJvWnhzWXBsbG5PeGo1VFVzL3FsZGN4dU54am5zNkFuUTBD?=
 =?utf-8?B?Q01sUFhidVBQd3ZHbFVRdTFscXRnK1VpbXVERHNDd0d5SmIzcnYxRmJGelZ4?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf76f6b-2540-4cc2-4dc6-08dab5a69c76
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 10:00:42.1949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jX/MjD5wJyGdAvD9zzUQ3H/HiaxIssTE1ylnA1D4NpqJqwYkIVh8k+i/hu8FbdPiuPYvZ9twR1tj2i7rbrH1CDCFG5ZloBZ333bdNu2IA4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4950
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/23/2022 9:19 AM, Johannes Berg wrote:
> On Fri, 2022-10-21 at 21:08 -0700, Jakub Kicinski wrote:
>> On Fri, 21 Oct 2022 21:57:53 +0200 Johannes Berg wrote:
>>> It feels it might've been easier to implement as simply, apart from the
>>> doc changes:
>>>
>>> --- a/net/netlink/genetlink.c
>>> +++ b/net/netlink/genetlink.c
>>> @@ -529,6 +529,10 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
>>>   	struct nlattr **attrbuf;
>>>   	int err;
>>>   
>>> +	if (ops->cmd >= family->resv_start_op && !ops->maxattr &&
>>> +	    nlmsg_attrlen(nlh, hdrlen))
>>> +		return ERR_PTR(-EINVAL);
>>> +
>>>   	if (!ops->maxattr)
>>>   		return NULL;
>>>
>>> But maybe I'm missing something in the relation with the new split ops
>>> etc.
>>
>> The reason was that payload length check is... "unintrospectable"?
> 
> Fair enough.
> 
>> The reject all policy shows up in GETPOLICY. Dunno how much it matters
>> in practice but that was the motivation. LMK which way you prefer.
> 
> No I guess it's fine, it just felt a lot of overhead for what could've
> been a one-line check. Having it introspectable is a nice benefit I
> didn't think about :)
> 

I agree with reporting and making it possible to introspect. Thanks!

>>> Anyway, for the intended use it works, and I guess it'd be a stupid
>>> family that makes sure to set this but then still uses non-strict
>>> validation, though I've seen people (try to) copy/paste non-strict
>>> validation into new ops ...
>>
>> Hm, yeah, adding DONT*_STRICT for new commands would be pretty odd as
>> you say. Someone may copy & paste an existing command, tho, without
>> understanding what this flag does.
>>
>> I can add a check separately I reckon. It's more of a "no new command
>> should set this flag" thing rather than inherently related to the
>> reject-all policy, right?
> 

I agree here. Non-strict commands are very difficult if not impossible 
to extend or modify. Making it difficult to add new ones (whether by 
accident or not) is good in my book.

> Yes. In fact there's also the strict_start_type in the policy[0] entry
> too, which was kind of similar.
> 
> johannes
