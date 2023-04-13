Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678D16E14DD
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDMTKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjDMTKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:10:18 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B6283D2
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681413011; x=1712949011;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PK9U84kG1+dctAJj+hsAs3fhz1qWX205gzfhlS11jkA=;
  b=ZP8GOPgxHqPDsgqU7wiV8KmO/Nlc8IZHTlZSrcjdmvBkKNkz0yzeKzk3
   EQujuZ3/QhoB39tyjekg6Pgo/Pn+9od0YfiLT9+jGwuzrTJhnUdNnar1c
   fqRDSEjkzfHxrB3MNMRsz2iZqFoMu4jLDSXtX60BzhVRBpW9wlccHUdaY
   QB7GVtWVqRJF1ftFDcHzu9ma6XHGGftH7VoCawLMukRzq6O3gkTSRY8Fv
   NerZ8Dw+ANZRlPdvQKP0VcwA5qbx/yFaS+HNrWElDDjJhVTSVthIge9X0
   zI2LdddczxUw/PIduwxLjFiAHTR9iqI0LJWM5Hwu327sLGiQTz9Bsu+YW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="343036529"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="343036529"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 12:10:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="833238044"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="833238044"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 13 Apr 2023 12:10:11 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:10:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 12:10:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 12:10:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYDrpyV+xrYZarpylpxPwSVepX9Xaa+8LZBn2GLWR2lkWqkg3a2mVk7MkFHTFeWWVaA5v5xzgkC15M6MDzFE11faiQfeyIboX6fRV2+3PbMdLnyZUD4za5BBzR0BU//6v9sgvI8Xk5PwBhCwIY4JYf2Xx8RdDGkT/2YDlsofT58NdP6fNNlpQcRmtW/6EfP6xSX4+PcIGv1YxSXRM88Vw/azpLchchA9aK4yrgfhE8iiaLsg+zMFwproarbFWMRr13YA+Wa5mscYRo1ahkSXoCI2fLAHK7QohhEpq2PSw7v0thpE+5D6iG5oymvveg1hk5lDlDvjZmwsNnwqI4MUiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzaFG6SHwyVI8RFK/tQjtVMNxcUOhFdP9T3spMCGE44=;
 b=MzDKSSRsA9yEoDCJ9sp7j9G+EA0UV8Dp0POTaOwUD4IkpRBVkSl6c+htFDJUlEuPwe1xGYW78KEL7i1XNyn+gIxrSGYYFZGkrQgN8Zn23A9oRVg0jI0PKmgNyHnVpjfXcxSAXJZSA1btt56Cd8ZQ+s+qYYuSMX3BMeEP6+V91x4KarWkciSFRYuOKnHG5qwof+BoC1RL8NoAik3gnR9Hj8u/NYp9xWT61I5UdP3dKwoJFYSyooZwffs1kwBwUqHcUisF00s8u9N5XSjMj7DZ3H5pvnnKK3DNe+Si5/PjpikXCGnR5ZoBrW3y+SZ4CW7p9X56fBspIr7l1kdAfc7dMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 19:10:05 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6%6]) with mapi id 15.20.6277.038; Thu, 13 Apr 2023
 19:10:05 +0000
Message-ID: <baf5ac2e-87a2-c2e1-2b61-aae668b10881@intel.com>
Date:   Thu, 13 Apr 2023 12:10:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 04/15] idpf: add core init and interrupt
 request
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <joshua.a.hay@intel.com>, <sridhar.samudrala@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <willemb@google.com>, <decot@google.com>, <pabeni@redhat.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <davem@davemloft.net>,
        Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <20230411011354.2619359-5-pavan.kumar.linga@intel.com>
 <ZDUt2ZWypHcc856F@corigine.com>
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <ZDUt2ZWypHcc856F@corigine.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0052.namprd08.prod.outlook.com
 (2603:10b6:a03:117::29) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|SJ0PR11MB5214:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e3e5345-7282-4a0f-e076-08db3c52b075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SeCSFieN8pz/8y03bttW0cRO4T2S4n/jIP6EYOWxPdt6DCNL/WuMGbXZwgNcmbH/GW55zR5Fw8LmfO2/kMX2J83o/joo7NLGgJC8JM86FgVv3urMKqAZNfKmLrCWTcI4PyeI+lVTR+x7owCza4P2+EcMb0yu75JFEh2PULf7S0rGFKgZPYCRry8hxYlyTPf371YJV1u7H7Izy8iXTXCD16+GGpL7F5yGBe53/72L+fYr2ihroXyDzNroNIw8WjG/UpN/WNicoWUigzZhSyp9eAFpPeBA4HuA+lLk6ne1/gNiE/WHH/V/PczDQwJ9wP1iplOKH0WfJimLnCnjwenG7TuIqdJHYT8ijhijmKEfcPwbJlb+7LIl3T5bohY3oANvaqL6qNf2dBUAAPU8F26dABQjZww+uv9vXiU64PadZmL/5d7rJIr7LJsNSADdLYyaW3Hn4RLsGWBzZ8eeiC2hgoFg2530TKTToer2WbROWvVkgBfTMPzLU3mw/U1NM0Ygg75BcZuwIde9bQuPoUUjWbuhCC6XDb/EMJro3xleYMr2/SALL9X3Rn/rQSn0tmU1ZcbhmwBr/v0PDiYFyzTa9zfgJqJiGvzy65NQEmF7mk0Cyfy3l7hYe9gGE2ddmx5eaHezjgyvU0GtMo7Lv8xX0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199021)(53546011)(26005)(31686004)(6512007)(6506007)(54906003)(6636002)(83380400001)(186003)(2616005)(107886003)(6486002)(6666004)(5660300002)(41300700001)(82960400001)(38100700002)(316002)(8676002)(8936002)(86362001)(31696002)(478600001)(66946007)(4326008)(36756003)(66556008)(66476007)(2906002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVF2ektXM25XdURjazNCM21Wa2V0b1RLYnpHRHBqY2ZOLzJNMlViSkV6M2pt?=
 =?utf-8?B?VmNEckRsUE1CeWI4SWMrQVAzQWVpWlFZQWlsOC9QY3JVYXlzK3lweVJmT0FS?=
 =?utf-8?B?ZWV1NGg2MGxHTnFUdzFqcUZHWW9GeUVBWjFGS2JEd09jWVU1UVBlTHRyVm02?=
 =?utf-8?B?THdSY3ZwRXVoVytvY3dKNjkzcUJLY3pSNUhuUStrMDVtc0J0elFBTEVJVkJE?=
 =?utf-8?B?b0hodFMzY29VYU9kSzNFRUQxTDFldnkzU2tQUk1lc0hsYlJiSWR3UGg5VEpC?=
 =?utf-8?B?dHhTS3YxUHYyTzhQUkx4b1E2dU1HUGpsQ3dxMnFQQ1M4a1hHSUpHWW5GSkxW?=
 =?utf-8?B?WFo2SHh6Rjk2ZkV0SURpdER1SXMxYnU0c1ZqVi9iY2s1SWkrRFBGc094bUFm?=
 =?utf-8?B?cnpVczhEZW5XaTlDVy9hTjNGUXVWT0F6U1gwTFBDalUzNWwrVGdUWGc4ZTFZ?=
 =?utf-8?B?TlVBcVBMSW1kM25MTGdHK2tzVDZ6QXVzNjRMYzJneGVEckxYQ2wzbXV5UzBs?=
 =?utf-8?B?aWlyQVdtaDREb05ER3hHaHdGY3ZTRFFOaDNoRTI0UGhVSENnYUxIK2FrTlNn?=
 =?utf-8?B?UGx6ekhLQnlZNVFMYkhNcHY3LytCaTVKYzVUVUdYeXgwMy93L2dhSkVSd3pZ?=
 =?utf-8?B?Qm5WRk5JSWxWbmtTTXB5Y1B0ZGREeWE1MzhPSjh2WUlyaXlmcm1HdnAyT1VS?=
 =?utf-8?B?L0lNbjlnT3lVeTFqM3I2VEpuMGdWbklHY0xpWDZwYm81NzUyWE1MUzd4T0Qz?=
 =?utf-8?B?K3N3WktLZ3phNG9tK042YmxQRXkyVzV1OUJJTjU2N01LZUwwUUVYWk9ySmRi?=
 =?utf-8?B?STM0ZjVWT29kcm5FODV2RERSeGZKRm54VFlOeHlqNS9RVk93bm10WVVacEt4?=
 =?utf-8?B?WEpIWEhnbVRhTk1zbmRieHVlUUsySXFjbU4yaU81NWVKU3hIMFMydFczRkxV?=
 =?utf-8?B?RDJ0RnpoNzFvd2dTZDdlb1VxZU9hKy9Td2JjK0FDeVFhVkJ4RFdET2gyakIx?=
 =?utf-8?B?QmFXbW4reXJJdGZpajJOb3prNjdRWDd1RklYai9oclc3aE15OEwzSzVKSldD?=
 =?utf-8?B?QUZBampibHlqc1pNa0d4YVBsemhuN01PaUZqSlorbWY1Mmc1YmNRdXFOOHZO?=
 =?utf-8?B?YzdERndkMzhLM3pXRXovSHhmVkNOMHZKT2RiTEFPMXZtQ0tocGJ4TUxUM2Zt?=
 =?utf-8?B?MHVORDhJY0JYS0dPNXYyaVVyWkt1alE1eG9qNXpOclkwL3oyS0I1VHAxQklo?=
 =?utf-8?B?VG1PenBjSFlMRjRtZUp5MmZaTGJvV2ZtOW94TzBuaklrUTkvWkE4YUJ1dVV0?=
 =?utf-8?B?SS90c2g5UGJQdVpYUUJIbnNlYVd0S0h3QnRqYmgzaFhSL1JjRGM4VUJ3b2NN?=
 =?utf-8?B?ck42VVF0N2plQkx0aTBpMmRiWjNsNkpIaDhRWkVlSWIxK2J3QXhHRGZwbVl1?=
 =?utf-8?B?RWJsc0hvSWNlVVZRUVlaSy84RWxHUGxFUXh0U3d5cGRUSkRtcFZvcUZmMTIr?=
 =?utf-8?B?K25mNUpCeEppVnJhSkV1QUlPWmQvOVpjVURybDBtMDBXQzRQNlA4dFhDSHJO?=
 =?utf-8?B?RXd4a0ZSRU5nSXNaUWIycTlnWXhEeEJXMWFlNkhFUlhxN3VCZHFLMWZVQjRm?=
 =?utf-8?B?RVNJZTRHNnB5Uzd3ajh0aWtzci9NUzNjSW9uTzQxSjFsb0NSbzZSNU42czJQ?=
 =?utf-8?B?Y3VXQ2cyR2hzN3YrSENaVDB4d2FPOHZ6c2xRMWE0ZWtJK3lvVVVuUEJlQnB3?=
 =?utf-8?B?bFhBaXpEYkdYUjRWS1ZrdFNKVlFLYUtHREljT2gvMC93S0wvaHJ4UEdDTmRJ?=
 =?utf-8?B?SEQwY1lnNmZiYkNucENnMWc4cEx5WUpxb3FHWE8rSDYySmpTeHRFd3FLUi9W?=
 =?utf-8?B?dVRHR1o0UGh0Y2doRkJQNWJjTythNW4zZ2ZtNkFNcGc3NkZ4Q3JPQTVpSDJZ?=
 =?utf-8?B?T3JZODRQM050clNCZC9QVFcySXQxSmdWR0lDWVNHYmtsOFlscTRjWndSdzRR?=
 =?utf-8?B?Zk9BR083Z3NpTG5sOHMwT1BMcWN3QnVzK2VGOE9jaXFacTd6NkpyUFovMXlU?=
 =?utf-8?B?MEwrT0I4YWgxS09uY1NWaTZsbVllUSt4T0ptSm9ZeVNGL090UW1IM3djQkFC?=
 =?utf-8?B?dURTc1VvdnZUSnBocWQ2Q1BSSzlVMEx5STI0YkFuZG1nU2kzaHBUQ3NyckJ5?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3e5345-7282-4a0f-e076-08db3c52b075
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 19:10:05.1357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nPBbxWU3W0jy6EA8cjfkvqxQqlu8Leobp7m8Cdfl6JbWHHwiIe5Rdz1eOhX2FTbhN1mz2d/n9p+APR/KtHTvJOI1Xz59kyPeCHwgQbTAhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5214
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2023 2:52 AM, Simon Horman wrote:
> On Mon, Apr 10, 2023 at 06:13:43PM -0700, Pavan Kumar Linga wrote:
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
> 
> ...
> 
>> +/**
>> + * idpf_recv_get_caps_msg - Receive virtchnl get capabilities message
>> + * @adapter: Driver specific private structure
>> + *
>> + * Receive virtchnl get capabilities message. Returns 0 on success, negative on
>> + * failure.
>> + */
>> +static int idpf_recv_get_caps_msg(struct idpf_adapter *adapter)
>> +{
>> +	return idpf_recv_mb_msg(adapter, VIRTCHNL2_OP_GET_CAPS, &adapter->caps,
>> +				sizeof(struct virtchnl2_get_capabilities));
>> +}
>> +
>> +/**
>> + * idpf_send_alloc_vectors_msg - Send virtchnl alloc vectors message
>> + * @adapter: Driver specific private structure
>> + * @num_vectors: number of vectors to be allocated
>> + *
>> + * Returns 0 on success, negative on failure.
>> + */
>> +int idpf_send_alloc_vectors_msg(struct idpf_adapter *adapter, u16 num_vectors)
>> +{
>> +	struct virtchnl2_alloc_vectors *alloc_vec, *rcvd_vec;
>> +	struct virtchnl2_alloc_vectors ac = { };
>> +	u16 num_vchunks;
>> +	int size, err;
>> +
>> +	ac.num_vectors = cpu_to_le16(num_vectors);
>> +
>> +	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_ALLOC_VECTORS,
>> +			       sizeof(ac), (u8 *)&ac);
>> +	if (err)
>> +		return err;
>> +
>> +	err = idpf_wait_for_event(adapter, NULL, IDPF_VC_ALLOC_VECTORS,
>> +				  IDPF_VC_ALLOC_VECTORS_ERR);
>> +	if (err)
>> +		return err;
>> +
>> +	rcvd_vec = (struct virtchnl2_alloc_vectors *)adapter->vc_msg;
>> +	num_vchunks = le16_to_cpu(rcvd_vec->vchunks.num_vchunks);
>> +
>> +	size = struct_size(rcvd_vec, vchunks.vchunks, num_vchunks);
>> +	if (size > sizeof(adapter->vc_msg)) {
>> +		err = -EINVAL;
>> +		goto error;
>> +	}
>> +
>> +	kfree(adapter->req_vec_chunks);
>> +	adapter->req_vec_chunks = NULL;
>> +	adapter->req_vec_chunks = kzalloc(size, GFP_KERNEL);
>> +	if (!adapter->req_vec_chunks) {
>> +		err = -ENOMEM;
>> +		goto error;
>> +	}
>> +	memcpy(adapter->req_vec_chunks, adapter->vc_msg, size);
> 
> Hi Pavan,
> 
> Coccinelle suggests that kmemdup might be used here.
> 
> drivers/net/ethernet/intel/idpf/idpf_virtchnl.c:2085:27-34: WARNING opportunity for kmemdup
> 
> Likewise for a similar pattern in:
> * [PATCH net-next v2 14/15] idpf: add ethtool callbacks
> 
> ...

We'll address it in v3.

Thanks,
Emil
