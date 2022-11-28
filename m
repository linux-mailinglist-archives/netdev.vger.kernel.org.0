Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4377F63B170
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiK1SgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiK1Sfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:35:44 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE2BE83
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669660496; x=1701196496;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xuR3q7SoT1XOXsq/57PTojhkAM1EEdctbh93iFKmxoo=;
  b=CmYmLwv/HxolrhYjc3pxW9N20q4lloCI3Vftz/CPyZAZfFDtmNN+L6K7
   eAuk4kjQB5mBjEZmQprAQFhNUQn8Xi5Lvpp1cD3dqFcXQYoFK0a0IVjZN
   yxhx+u7z2vlDI7svK96bOPKs3LJdy7hzjgeq6cjplpadGRDRWQNEFW5gz
   XgUvkgANQ44AzyPDzyliKMzHBNfd56IhVDidHKaoNw4yeeF5ZQuoVynAR
   s4hxnhKiWS2JutEe6F/4dwqb6YRqaG7aUgNh5JaBZFTm5p2hbhl4P+4yI
   pdSCIrB98RHBnbAPsXOQwp64y0/zD2dlAPIhV6N7LOGq/cYVz1I+AWq6Z
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="377065763"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="377065763"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 10:34:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="712076357"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="712076357"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 28 Nov 2022 10:34:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 10:34:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 10:34:55 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 10:34:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f71LHWeh6O2iptlMuD4z744OjmtLh7CE1mQHh9RUJ5CQaBjsPwX2CEpLMEq/tkH5loLKUZFX+m4SQNMF5WC7Y8WmnWknQ8TzM/d8frLV2C4NLsepdZfd7Yt0iKzzLFlhY/qBkRAwbkZN5SHUaoTLAEuIqYDGzLM6Ji0WEllHqhOnhZe3L31R1NmN87jzwiQWt3M/TOi1Aa2srZcxIeOHPPiWTaYL5mMgAb0GNqLOOpwtLjeTIg95m9fUJZXZLkAihET7FFT2BJbv2DELfP1fa6JHAxzjgn8kVvtvGYH6cOd6rS9km7ndRZE+nbu55JL8nnOAv7YuBp6mEvhLnOLJMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lhu4xdSZmhHbcCaqlQJni584KTYzGCS/qfjD5KAnzuw=;
 b=cIR3I3ANG8TsH6hNq36aRbKZ/L5qSAI/nwFB7BIi8QK8Dk+YV1q8lzMKP17HebvQXhEAoFwJXJEh+Qx2XUnEJdqJl+hoj5PDxbhSRA7hfE02IF9c58cC89TuD1n0TVbEkKyPlUvYyxVpWWmeTgRi08565Rwg82KP85faq2lWkIL/uav3dJ1khsNdcV5eeFygVcjOL4JWqSEWBXOyU/9CwscSKo8KIM2kdia66v+8vPFiCRRrMEVUGOrqYUZdZoRDBQ1CINexj/CH/Yh536x+r3BizL9kvzPi9Kg+HQsEtILYnXPvsTW9+Ox1vHGPq1kCh8BewH7zs+fXFcjSUs2log==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5204.namprd11.prod.outlook.com (2603:10b6:303:6e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 18:34:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 18:34:54 +0000
Message-ID: <bd3887c2-1d91-3af1-f1cc-403b9ef849b7@intel.com>
Date:   Mon, 28 Nov 2022 10:34:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v2 6/9] devlink: support directly reading from
 region memory
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-7-jacob.e.keller@intel.com>
 <Y38z418/Uv8ExF1V@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y38z418/Uv8ExF1V@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::26) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d56a663-3b27-4b01-6370-08dad16f3e36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I0q021O652Rgm4lESrasmmq8chCeZsS2yxWNI1bPlIhDSOgPzIO4Zoh4i1WdeX4rWyeFV6Y6dbgON+43lMyio1yfpfN03++SCD4x2hCDS/mC7oWaX3uRKMPwrrJ0TEBiUkVefQZ4CjniXJ84l39UcbYKGFP3je7z7Gm59EjJXveRe0Zjmbx8a+7xgLTzmeTdSyl6zTlhQLwX0MzADIq1Ec+h1stp80d6/rp6Ao+hlrRqsWolU1QETvdDXdnii1sKkqPA70H9l2b4hRzUe2Vo2/hYGoJOxKILIJk0WPui4QxLvJzdSfuJatpcGPYqfD4zkLW49IHdBqPMkk5dCBTY2X041GIn8dU3z1CJO2Vb3lgFtcNuvtYKNvDoEYPJHj6lmpEFo3P7oMrWtVOlw2dIy6s8NMBLqlbj6MnL9fdyqLSq21xJk1EWbLIEjlftcZ31qTlph/j3vlXdFqLfGMuDx5rrBABWgVMMmBqittOfAXvWL/6/i8RinAgkZJ5Rl9Uz2ir6NV/5hXBm3Ady8H06P9D3oPYXr/93Me2XzoNbU71bIUcXg/FhsB4PQy90Rb/4aTjHuIUiiSOTfeiadIWlLX0l0kBfTOid9JWfWT8KDKTqSj+L1sAH103RS+YAdl8vwnfTvEJMueBVJV+UlZXTXjpHLoZauUlO31ZiQcIA5OyLDk41asdWDibA9w2oc6JTo7zahSF0hnNkckw6r5j44//qzSg7TR17q4Ez33Y5oEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(6486002)(31686004)(186003)(41300700001)(2616005)(478600001)(53546011)(54906003)(36756003)(82960400001)(38100700002)(316002)(6506007)(26005)(6512007)(86362001)(31696002)(4326008)(8676002)(66556008)(66476007)(66946007)(6916009)(5660300002)(8936002)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?di94ZGR2Z2RhWDlORGw3U2FvUVFpd0VYSHVPcnNmVFlia09Hc3gwRWhDS2N0?=
 =?utf-8?B?SEVETy8xTUpUMUFBd0FqOXByYWRRb1NxeEoxWUJ3NnA2d1U2emFaRzZkaEY1?=
 =?utf-8?B?azdlaGs5bVp3cm5EUmpzZ0p1MHpVZ3ZnQXlsaUgvb25qMi93cStVT1dEb2c5?=
 =?utf-8?B?MitrZ3JETjBxdFh0ZEFIY2FNWkMxakpwdkpyWWtOWVpESStmV2RwMlFlQ3VO?=
 =?utf-8?B?M2tkUWZCZ1RKdzE0OEhnQ1J5eE1jQUE5N3VvR040SDdwN2lKaG5BN09GaE1W?=
 =?utf-8?B?elF1SGh0UWhzb0NGYlVzU2x1cFowQlg1MFVjMUM0UDVOcGlpS1BYaDQ1Qm9s?=
 =?utf-8?B?dWpMQ0NrN28vaUVjRkNmN3djaHQ1Rlc5ZmszQTNhNUVBZkZHeENpUCtybjlW?=
 =?utf-8?B?VTZTWUFTUFY4dTh4QlROZ2RRVk1xSEJIbUkvL1pnUUdsRzJHL1NxbDRWeTVZ?=
 =?utf-8?B?RURYK0p0S0NwdnByMklSczUvSHN1Q0x0TFo0SWEyV0Fqd0I2eGEvVjEydUFX?=
 =?utf-8?B?TlJKKzdHWDdTbEhpTW9Jbm5mb25vMm1oOGl4THRLNFBmYWIwZnhWeHMwcGs3?=
 =?utf-8?B?b0ErK2hqaThBRUxyRklKVWtXOUpseEgrR3RjK2p6Qk5NM3RINHo4MENlVlpF?=
 =?utf-8?B?UjZlcDkwYnRRWjIwUy95aEhhOU1rc2pudnU4SUpzUEVCR3pqVW51aGZETWtS?=
 =?utf-8?B?WVBHVi8yL1dCajl0WHVqMUJlTGFwdld1Und6dW1MU3JBQjRKSnFtY0VlaEdX?=
 =?utf-8?B?UkdwR3FNSWdvKzUva3lOdm45L0JGSkpPTTVLaHZOcHp2UlBZTHNpczVTVkxa?=
 =?utf-8?B?R1ZwM0ZpWWdxNzJueEc0R09EeFplRnB2bEtsc2pZa3k1WVEwT1p5SE02Y3hy?=
 =?utf-8?B?OWtCTmF6K0UxMlZLTzhpVFI3aFpDaWZBYWZqTG5rQ2xCNHBqU0VsOG45MUs4?=
 =?utf-8?B?ZGVGYkZULzllS285RDRpdUt4ZHhyMGt4dnVLeHF5ZlhEZ1lFVW9UWlIrcVFv?=
 =?utf-8?B?WmRvdWQ0eWozQ0N0bkFiV3M4TFRzclN1MUt2bWw2Wk9jUHJJYUx0djdJQllU?=
 =?utf-8?B?UzliWWxGbVhURFdYbFFMVW9Vd0NSVUU2MDlYV08xc0MzOHFVNFhnZUxxRzlJ?=
 =?utf-8?B?NDRWWC8vbVo0TTd4R1dQTVdVekxFamVTeVNIdE9KbjUrS0tSWnNwM2p2bzg1?=
 =?utf-8?B?eDR1bjZlbVdyaGlCaEpFdGxNSFhGSXVVYzlNbCt1Q1R1bUp0ZUZaQWxZVzd3?=
 =?utf-8?B?cEE2MmsyRjRjalVTN095cXZTckYrTmk4UVZ6bGdibU84d1cwZkJ1UEFBUWp3?=
 =?utf-8?B?c25aZ0thbXZLS3NYdWhDTmhBWk5aWUtpS2FiUEJsc0JIUFZRSTdFQlZJNHQ3?=
 =?utf-8?B?OHE0UU8zbm10TXdzWFVhRTdPcXZ4Q3hqQWdsTzA1VnZKbHJpWVRWR2JsNmFk?=
 =?utf-8?B?NWpVY3JOb3Y3KytWRHl4cFg4WVI0YWNzS2MrcE5xUENIVHhWd216RnYvMG1B?=
 =?utf-8?B?Y1RURHpqNVhTeUtVQyt1OHdnTkpiYmdkeDBIdkhGck9SWnVrend4bjg4TzRD?=
 =?utf-8?B?WTVLc3psQmJjTnVCNEc5TXZtWnUvN3FvWml0MUZtbEh6UUNWQVI0eVpwazA0?=
 =?utf-8?B?aHI2UHZlODVSNUVtUk5jY0k0YytIME5TSlRJNXlxUU5qUGdLNCtUd0Z5dkpX?=
 =?utf-8?B?MlVzNnZYVVlNVXF2S2VKMUxLbnpjbW1UdXNmZFJ5OG5qZWwwYXJQWSs4dkZK?=
 =?utf-8?B?QzRXcDhLNWRMTS9xaC9NQjU1SmFjdzlQS0JrYUZmNlBZM2ZBWC9WQThYWGJq?=
 =?utf-8?B?dXBUbituKzVKb3g0UmIzR0hPZllQTm9zRGswajJOeldUQ2syOENPS2JXeU9Q?=
 =?utf-8?B?S3RVTWIrQzJ1MFpVanZZbU5VMk1NMUhTTkdhVHRpYWlSbnBYdjc0WEMwQ0RX?=
 =?utf-8?B?NlBDVkRrVFZuY2gweG1lUCtaWGFHVWVJUjAvYmY2dDN2TXA4TVJuejJCQksw?=
 =?utf-8?B?VFkzbXk2dkkycEJTMzN3UHM0bmt1U3lrdHV3cE5CVkc1ZXZrcmxIaytxSmhM?=
 =?utf-8?B?aWlEcGU2Vk8yaCtjc1ZmbXdBVDB1YWt1bERJNDVUYTRja3VWNkNIKzFXc3Aw?=
 =?utf-8?B?N3FGblpXY2xYOWpCeTYwZjNCVFkya0Z2WFlXY0pyTjZvT1FjSjNLOHluOU9t?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d56a663-3b27-4b01-6370-08dad16f3e36
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 18:34:54.4812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tbfahngL1tu5elGrS0AUXJ6qSJ9G5I3o66L67bQ5bFpk1Apf5StqMj1ujqQZumZlEBtmuEtm8nssgoOOqsHzXvpw59U7xGE13o5sIWXIKYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5204
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2022 1:05 AM, Jiri Pirko wrote:
> Wed, Nov 23, 2022 at 09:38:31PM CET, jacob.e.keller@intel.com wrote:
> 
> Hmm. Being pedantic here, it changes userspace expectations:
> current - message without snapshotid is errored out
> new - message without snapshotid is happily processed
> 

Yea. I guess I'm thinking more from an interactive application 
standpoint this wouldn't be a problem but from a scripted setup it might 
do something weird.

> I can imagine some obscure userspace app depending on this behaviour,
> in theory.

Hmm.

> 
> Safe would be to add new NLA_FLAG attr DEVLINK_ATTR_REGION_DIRECT or
> something that would indicate userspace is interested in direct read.
> Also, the userspace would know right away it this new functionality
> is supported or not by the kernel.
> 

The advantage of being able to see that such a feature exists is good.

I can rework this to add an attribute.

> 
> 
>> +		if (!region->ops->read) {
>> +			NL_SET_ERR_MSG(cb->extack, "requested region does not support direct read");
>> +			err = -EOPNOTSUPP;
>> +			goto out_unlock;
>> +		}
>> +		if (port)
>> +			region_cb = &devlink_region_port_direct_fill;
>> +		else
>> +			region_cb = &devlink_region_direct_fill;
>> +		region_cb_priv = region;
>> +	} else {
>> +		struct devlink_snapshot *snapshot;
>> +		u32 snapshot_id;
>> +
>> +		snapshot_id = nla_get_u32(snapshot_attr);
>> +		snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
>> +		if (!snapshot) {
>> +			NL_SET_ERR_MSG_ATTR(cb->extack, snapshot_attr, "requested snapshot does not exist");
>> +			err = -EINVAL;
>> +			goto out_unlock;
>> +		}
>> +		region_cb = &devlink_region_snapshot_fill;
>> +		region_cb_priv = snapshot;
>> 	}
>>
>> 	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
>> @@ -6633,9 +6665,9 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>> 		goto nla_put_failure;
>> 	}
>>
>> -	err = devlink_nl_region_read_fill(skb, &devlink_region_snapshot_fill,
>> -					  snapshot, start_offset, end_offset,
>> -					  &ret_offset, cb->extack);
>> +	err = devlink_nl_region_read_fill(skb, region_cb, region_cb_priv,
>> +					  start_offset, end_offset, &ret_offset,
>> +					  cb->extack);
>>
>> 	if (err && err != -EMSGSIZE)
>> 		goto nla_put_failure;
>> -- 
>> 2.38.1.420.g319605f8f00e
>>
