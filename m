Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DD06DCB3B
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 20:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDJSyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 14:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjDJSyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 14:54:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFE5E4
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 11:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681152876; x=1712688876;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oDOX5JsEpwzHb6u0W/Ezn8lQhfW59yEzpfVHn73cH/k=;
  b=jfsHYCHXz7Bpzx0ICgtXoG4uEDzIOMUx9stY0FMt0YnS9ih9LXVwA4Au
   UnzP0XPwxySOeBg+u2hUfqQeCZKwxhZBU7+e8CSwu/MIrMfKdwGiNpgA/
   NSDw/+6jN59x+yCJYeheijvUh4rKTspVcaOFL2XMWO/qKS30VQMZRcIP5
   5s6i5V1F1IVlNcH38cT85XEaT2gXLkfIHKoUYVgXjQ/o0dFezW/YfFvwp
   E2p9vUPBNHQdkWbNg9C3z4DU6A55T5GkGXgt+3NmUeC5B6zHCCF/2D5ID
   2L/CuhTFY5H3sAKviEbfRAVl84Zc5CXzHeEP9X0O0WtboBroGHbcxAzLg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="408568951"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="408568951"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 11:54:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="681808369"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="681808369"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 10 Apr 2023 11:54:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 11:54:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 11:54:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 11:54:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 11:54:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+VP7kHctAg8IjtNQ9EhKHioK0YbDzeBl6f75kGpNXaWR8HllfCmRlpI5dAAFGNx9ig/vIi4kHs1m7G+gYWtcoECm5xqyIXRUE6i4Cae8IzoLixPMh76eZJSp1a1j1mPxrk5XwvTiG/E2M8m741pcq7FThR/ZcdKvLckuIUh27Yr/PLAUKtBYDBhlMjtV3TSJnNyFGS95D0DNlmkA1ouwN3emDdDspx/PNKK9vWnLW7uQ3+yngEHm4Eo0CZigLlXqI60cPm4YLmnxp8JLNHs74FTmr5p8A74FgaI4nTib9rV4Ptl4mIv/msD5rqp5NnD/KpUkT8+7Lva3zS1+jlqWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49X420Ph/S94D/LoBEP/n2tTX9hTeMvPjnyPfKYlOr0=;
 b=M0AlV++o9DRKGNhlNLdwZPzXbyaT1nRTb1K7o92rQPO/SNbLd/WejXZfo9ctEgvEedQUvk34/altNiwpLAmCuwi+qEP3UUM/O2FmWHLh9YRQxuh+7izQIh0QLcr1web7Z39JnCRFaSkZH+VNFOjrO53Jh2UaOk/1uJ+PfvPcLw4CeBZVbZWfXT1ncaXdkAoK84CRSExWslvRX8oCq55agCMdVe7dlKlgK42lQLZ38GR9kY4KAAeLizDgJAqU8CN0x1ImYWJMZwRnZHRS++xS0yttawhlCMeFzCxDgfKuVeUCzSHbliY1dCcoB9Sr4Nb5S29bXtofzIKG/st5xkH1kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7420.namprd11.prod.outlook.com (2603:10b6:806:328::20)
 by DM4PR11MB6261.namprd11.prod.outlook.com (2603:10b6:8:a8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Mon, 10 Apr
 2023 18:54:32 +0000
Received: from SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::a3e9:b91e:a70b:100b]) by SN7PR11MB7420.namprd11.prod.outlook.com
 ([fe80::a3e9:b91e:a70b:100b%6]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 18:54:32 +0000
Message-ID: <3de9c4a4-4fba-9837-962a-e3e78299ed3b@intel.com>
Date:   Mon, 10 Apr 2023 12:54:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net 1/1] ice: identify aRFS flows using L3/L4 dissector
 info
To:     Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        Arpana Arland <arpanax.arland@intel.com>
References: <20230407210820.3046220-1-anthony.l.nguyen@intel.com>
 <20230409104529.GQ14869@unreal>
Content-Language: en-US
From:   Ahmed Zaki <ahmed.zaki@intel.com>
In-Reply-To: <20230409104529.GQ14869@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::20) To SN7PR11MB7420.namprd11.prod.outlook.com
 (2603:10b6:806:328::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7420:EE_|DM4PR11MB6261:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b84e39-6f88-4d16-f16a-08db39f50550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KAgnx0ec7JiTXfg/XnZB/10fYL1DcPcZNdX1iV0XAvmBRpTb1RAG+FJbZqPmYkw6fuNyJHwLkFkI9QawYezZ4cdFUP0jO/Si0oOrOit38O8E5IWR0elLIk/ILhrbED9HPJ9+0fdcigTbl2QfKCam9SGckULEht1FLhrPXr/DsB8eRxApPMGUTkxIJCTLsz6WBvP2ojIFjBiGLWp62E0s/e8ycgHDvkOlh71HH2dYPYao1J3oQPX4DWnAlX8oF8Ndqf0hQC2SE5OwZVhU4F0MfWmqFydT27InHCCf6bpbBJIQtcDBmslOtpj5UXVkGlGVu2CCNlHzgDTtdg0Eds9jmIrLK8pRfhSuUOSUy6S1ezJviRgjYM7+xdm6Z094V5B1aZaso/fckx+AVkpKtRFxa82yljmt8rywJi3o78Ya6b0mF2EtL0Act1DZIsD9T39O6D0qgEt8UB49X39Zb4so4hlxqYKFGuuQIPa1Ht1POb6hV4ax22C7rxBvOYqWlAoTs6iwcy98iuh7/PSQj9+twu8tSYzCnf406LApZX8Of5d8wfZU2R0Fx5HNsUNbyFKEdhPgtKc5zm3L15vqslMnp6aQowFLTMp2Idf87RfJs1yChdHRwGfg1GspUktHh6me6VI91wz40azqWbgJrCacMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(39860400002)(366004)(396003)(451199021)(38100700002)(86362001)(8936002)(31696002)(6666004)(66476007)(4326008)(66556008)(41300700001)(66946007)(478600001)(6636002)(110136005)(6486002)(316002)(5660300002)(2906002)(44832011)(53546011)(6512007)(8676002)(186003)(82960400001)(6506007)(26005)(2616005)(107886003)(36756003)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWlnaFNnZTZjeXBEOFJYOUNTOS9EZlZ2aXArOEIycS9RSkptOEtVZmRPWVJN?=
 =?utf-8?B?RFlMdTlyQlBMcjlwUFQ2YjNhSVB6RDRYanM3OGFxUlFCSFQ1SVl6R1Z3enNX?=
 =?utf-8?B?Rm45TDlIUUtKSkRZRmJoTGJ1UnNQdGlJVXJObjdvQU9pRkJoWTg4eXROWFlL?=
 =?utf-8?B?M2QvNHpEUW1leWFjK2pYTFJ2OE9USkZ6L2VFU2NJeFJBSkpaTXd6cEE5bm92?=
 =?utf-8?B?eENBUU41YWR4MDZYTnhzZkMvSk9hU05zalRnKzdNMG5pUllPY0s4WmlSaHVv?=
 =?utf-8?B?eGtTZjRqUktSVlhXYWVLTHkzYXd6RDFIenNuQXNwZUI5dGdrMlFyNXJDYnlL?=
 =?utf-8?B?b0UxVHhZNHNhckJ3MDFWNVR4S0FYQk84aTBqNjZHU0ZDTHBQbXMrN0lTTmtp?=
 =?utf-8?B?K29xblF0dmZSa0haaG1hTDVsN3NZWmlDUmVmNmFuWXZjSUxSQ1VtOFdvVmJQ?=
 =?utf-8?B?b1F1MWxDbEtTZTRlUmVndjJMRGVuM0xMeEpvM2pRK3VaRDFpZ3JwNzRqNjRV?=
 =?utf-8?B?YTBsN0NkK2pkMnBkVEdtM0J0aGxaY2crelVJZnhXYTMwK3FVZlY1L05KdVk3?=
 =?utf-8?B?UlU5ejRlYzBnSlZqcHFsNmVLamJ0MlZIOHNJcUJnSnJzZHMxamJzTk1VTVpT?=
 =?utf-8?B?ekdZTW16TEg2VXp0QWZaMzRDakdPTFkxcnNvdlpZdUZSOGN4MVNLMWxPY2Ju?=
 =?utf-8?B?OTFHa1RISDk3QmhRL0w1MjBHZEJRd1J4UHpjYzZRS3NaY3dqdmF4ZEN2UzJ1?=
 =?utf-8?B?OGFLR3VRaTg1QkJMdFBWSi9LbXcvNVdyNVpsbFZWWjRHektYNjdDcmRjSzB0?=
 =?utf-8?B?Mm02QmpYMm1YWVhkOWZuRXQ2Y2VDRlhFTnFXZTJldWE2MFF4am5HajdUQVlt?=
 =?utf-8?B?ZFBoMzg4Uk94c0t6L3F0VjJkWDg3MC9ieGJaSHpuZEVaMDhVZnJsTXVkK3FW?=
 =?utf-8?B?cm1JVEpqYTBrd0Raa2V0YmhxRjVOZzRuckZPZUFKUXpYSXRJTytFUmt4eWJt?=
 =?utf-8?B?UWpGdFRNWXl5eEFWbW50ZWtYLzlmeERvNVZaTzMzNkwrYmcyMDU0VFNHeFRO?=
 =?utf-8?B?aEplNTZkc2NxU25JTXUrQk5PQUFDQXpXUHI3MWoxTm1hRDhHeVVGWGovUHRy?=
 =?utf-8?B?Umh3K3VYSHJ1aG5tT0VJMk4rNFJORWpxRWVpZzl6SDNBOVhmdU4zMmV2WHlB?=
 =?utf-8?B?QVVPdm50WC9MV0swQXZFZ2tHdFlpSUt4a2xiKzZkclh5dmR0WHJHMXFjL3Vx?=
 =?utf-8?B?WjVENVBDWnBMaHhmS01qcE9Da0g2enIvN0dXWWowSzNOVmk5UTBsNnBpS2V1?=
 =?utf-8?B?eCtlT1RFK1FKNTB3TkRzaXFpanFGVVFjQmFBUjd2STJVWFhhWDQ2N3Exam01?=
 =?utf-8?B?TUtYS0NrTHIwWDB4OXhHeS9ZZDZOVzJXSHF6Q3A0MEtGc1oySzE3ZVRpV2ZB?=
 =?utf-8?B?c0hHTWJDbFVyMUM4WnI2Y0plSGdaOUdhYVVROXhJekNFWks1M1ZyL2cvY3JI?=
 =?utf-8?B?b3JaY3gzNEZET3dkNHpJRWdXZDZHcVVWUXJZd1hON3VYUjhUV255cWZybWhz?=
 =?utf-8?B?NkZCMnRTMFJydGxTc1VJeHh1VzBwR0VONVVsajV2WUJ1UVVjMW54VjY1Q1kx?=
 =?utf-8?B?TlQ1YnhpUmt1M0dBVWNHcGhiazl6Qkc3OW00N1lvY1ppY1Z6WGFBOEFnLzFv?=
 =?utf-8?B?NlZNb09Ya3BjVG0zM0dLUjZESHhnMnM1Z0E1N0RMS3FUTk5qL1F0V3lnQloz?=
 =?utf-8?B?SjZnU2FVSi9ZTTRURFFNdEM0ZGpIaXY0TG9tbUliWHBWUjFuckFzYm1INklB?=
 =?utf-8?B?YWRUM0tUMkR6dnl6VTQ2UjhLcmRPSStTNC9JbENvRHBQeHY3Ynk0cUN2WU8x?=
 =?utf-8?B?NDkyWGdBMlFSY3U4V20xMUdaYUlkQ0tYRDY0YnU4MDVEVDcwam5lRGphK3Bx?=
 =?utf-8?B?TmtXNDNhRDBaaUQ0OU1FdndYbjZiNjJWKzI2NE5EOHdsRW5uZFRzMnNPMkw5?=
 =?utf-8?B?WXh0M2tEdEg2dmxkSStnTUVRdjJTcHliUVY3Nzk1eDRQdFUyWE1LdHNoNnJn?=
 =?utf-8?B?WGY4R2VhcGIxZWo3dDMzSk5VVFdmaVJ3NHdFRWhwMExhMTNhUEZNbzUxekJ0?=
 =?utf-8?Q?ONtZ2CB4CrIoRCpezelwFBrs8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b84e39-6f88-4d16-f16a-08db39f50550
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 18:54:32.4620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0EjJvu5Kyb90Q8jzCVvo9LO7jnhU6LPfmGUa5KLQbMe5T5yDrAG1amwrOZB+4y8WGXw7iZVFlki2G9rX6YhVsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6261
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2023-04-09 04:45, Leon Romanovsky wrote:
> On Fri, Apr 07, 2023 at 02:08:20PM -0700, Tony Nguyen wrote:
>> From: Ahmed Zaki <ahmed.zaki@intel.com>
>>
>> The flow ID passed to ice_rx_flow_steer() is computed like this:
>>
>>      flow_id = skb_get_hash(skb) & flow_table->mask;
>>
>> With smaller aRFS tables (for example, size 256) and higher number of
>> flows, there is a good chance of flow ID collisions where two or more
>> different flows are using the same flow ID. This results in the aRFS
>> destination queue constantly changing for all flows sharing that ID.
>>
>> Use the full L3/L4 flow dissector info to identify the steered flow
>> instead of the passed flow ID.
>>
>> Fixes: 28bf26724fdb ("ice: Implement aRFS")
>> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
>> Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> ---
>>   drivers/net/ethernet/intel/ice/ice_arfs.c | 44 +++++++++++++++++++++--
>>   1 file changed, 41 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
>> index fba178e07600..d7ae64d21e01 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_arfs.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
>> @@ -345,6 +345,44 @@ ice_arfs_build_entry(struct ice_vsi *vsi, const struct flow_keys *fk,
>>   	return arfs_entry;
>>   }
>>   
>> +/**
>> + * ice_arfs_cmp - compare flow to a saved ARFS entry's filter info
>> + * @fltr_info: filter info of the saved ARFS entry
>> + * @fk: flow dissector keys
>> + *
>> + * Caller must hold arfs_lock if @fltr_info belongs to arfs_fltr_list
>> + */
>> +static bool
>> +ice_arfs_cmp(struct ice_fdir_fltr *fltr_info, const struct flow_keys *fk)
>> +{
>> +	bool is_ipv4;
>> +
>> +	if (!fltr_info || !fk)
>> +		return false;
>> +
>> +	is_ipv4 = (fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
>> +		fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP);
>> +
>> +	if (fk->basic.n_proto == htons(ETH_P_IP) && is_ipv4)
>> +		return (fltr_info->ip.v4.proto == fk->basic.ip_proto &&
>> +			fltr_info->ip.v4.src_port == fk->ports.src &&
>> +			fltr_info->ip.v4.dst_port == fk->ports.dst &&
>> +			fltr_info->ip.v4.src_ip == fk->addrs.v4addrs.src &&
>> +			fltr_info->ip.v4.dst_ip == fk->addrs.v4addrs.dst);
>> +	else if (fk->basic.n_proto == htons(ETH_P_IPV6) && !is_ipv4)
>> +		return (fltr_info->ip.v6.proto == fk->basic.ip_proto &&
>> +			fltr_info->ip.v6.src_port == fk->ports.src &&
>> +			fltr_info->ip.v6.dst_port == fk->ports.dst &&
>> +			!memcmp(&fltr_info->ip.v6.src_ip,
>> +				&fk->addrs.v6addrs.src,
>> +				sizeof(struct in6_addr)) &&
>> +			!memcmp(&fltr_info->ip.v6.dst_ip,
>> +				&fk->addrs.v6addrs.dst,
>> +				sizeof(struct in6_addr)));
> I'm confident that you can write this function more clear with
> comparisons in one "return ..." instruction.
>
> Thanks

Do you mean remove the "if condition"? how?

I wrote it this way to match how I'd think:

If (IPv4 and V4 flows), test IPv4 flow keys, else if (IPv6 and V6 
flows), test IPv6 keys, else false.

I m not sure how can I make it more clearer.

Thanks.

