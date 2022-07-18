Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F2B578253
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbiGRM2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiGRM2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:28:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAD825EAE
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 05:28:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJn4K+41QdIA6TXdBOPJcR48AvhNgiJEr/a0HT/8rTrBKtKh5MLpFou6BGNkGEX+LRZWYdIKPUBoTU/svt0dJL8DtlXWHJqzLMgYKQ0viUXkRiYiMDI5FSKDL1+MXBYcwbBodm5a5mNh36xzmpwBI8td1uZsxkbKYMcUz1JVQIO9A3O8A7LdOP6ztISooxfGe+LDOl46+WM4dFSgh30+0RGzZif1HaQZKTkcvyEWHEo73vLH5QuYDXyvqvbpYg6Wprr9YIGK7q7DHm57wsQod+7Q6dSrObegVdl0xIEn48hRE0CrUJ+98bwgNsGt5dAz80MslPs5Eh+wWLoLWY21uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4WHjfMsIXVsIrNNXbVSfh+6MB8a4g++MrlCcLam37Q=;
 b=AeDw5V+Cx8zclddJM0tMjSbk2r9pktu8EaYlW4C5qxH3xkgsSQxValOykftDmlTs50BdbNZX6X+jfeIhJQOvhrtCGHKTIPhyDXgxo89FWcA8YKQ7Y/2XFSkmib+xIRQ6GJbJ3XgtYgduO50jTCiPDdKXQu+bDDSJmPpoUxXEt9WN/PHpIwJ2bSLwg8jbRVlCE0+aeABSp0vAWB3BLUsLboab5whSa4MZuD35ridSSG/4w4wre1FHSORPY6aZkj6LOAqO5sd/DZOLr8XaeHbqL6Klm1b0I7uM2DtogFfEF6XxXozoC13kGltZ4RiG8NVkQhvw8c3cxK+Lto5O2eTaqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4WHjfMsIXVsIrNNXbVSfh+6MB8a4g++MrlCcLam37Q=;
 b=ud2lE4cXnmL/I/40rWifFjqyIDwJrgaCFnaCNNqJupuqk5+vVwxxkbyqjUYFxGA/4yOtNfAsJrWoM+2uPM7KfZ7j23AgaPn498MinXspY13KEcheSxv7ovt1lJ42NVF/IDwFh/HYxUrDPRltApBgqNhBeSjP3Z/DtzxOZJUGvxNF1IBSaXVCCG4p2WPHxmOQ5lrUfq5oqqEj7orQ4LvATwhaWmMvuOfNkJNZeq7bj/6HCeeTlaqaa14Xn9+QN1PZ7nwO3ufGVeqooghhjfMb3FgFCejsVHA95aV2Jryq7eGl34YEyiJ84du9/ImDmmrQWp73HtYYxoYYckoRyjpa7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 PH7PR12MB5831.namprd12.prod.outlook.com (2603:10b6:510:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 12:28:38 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 12:28:38 +0000
Message-ID: <6230396c-afef-c110-3432-d212d2bd77c9@nvidia.com>
Date:   Mon, 18 Jul 2022 15:28:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net/sched: cls_api: Fix flow action initialization
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Roi Dayan <roid@nvidia.com>, davem@davemloft.net
References: <20220717082532.25802-1-ozsh@nvidia.com>
 <DM5PR1301MB2172BA76D9BAEADF9A40D11CE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <DM5PR1301MB2172BA76D9BAEADF9A40D11CE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0098.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::13) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f299d495-d225-41b2-378a-08da68b90ab9
X-MS-TrafficTypeDiagnostic: PH7PR12MB5831:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqYe0o2aUiuuH5GSvEsQGGBzWfFAfpD32iFbASuAgwnWt8AWJCm/FNfmV3svPVFmck60pAmi6/SP75NSfyOtasmjTtagSgeOOLWe/8GGYCIuA2Ie3VE5tDB/KSl3O5dHmV6xb4Ykz6lRrq5Cosy5Py0P6bTA53AAlQBq5SzDMQQ1RNDYedfFqU3ECa1n8ytNrvEXvaz1IZrRg3R3zAEC4UUZTmCisLNnqW49/sEAs/0lzyPAgfx5Pye0Qz1NJEH3hBBcIVfIXH4fkm8t7nmS8JS18oEP0diSxd6XiaFwqIr1HQfLS68DfJudW1gyqTGyUkHP+p+8Fl1eUciJ9NmCxtKZ5vsRwUnU6W27JJsP7eOJHo7nf7Mlj6N0Gc87oq8rE27wCRlt8oejLQT37oR5lIZ5ZZPDCqj3nM4F2rn5cbnSw+EiTEfO+Dqua8ljyrXgb1u9A1xNuND/uwt8dHC3sqRF7G8L70uDqeD1ARWQJeuJlcrqH2PAgst3JgXe1NctBGq68jTew1VGvHnpQjWYPvcc+d0nCEXbU3L1Jq65rN23kQi4QvB93zlU4HeaZZUwUG8PJqIy/7dorYWoC0Cl26sn85ud6eDhR+Cfobr79vxr4n+lDpMUGHe6b3jXn/di0+PCUdoVjREzZNbZOPAne18lHtIEzg24+MDQQVKR0dgNHlCjI2mAQOqZ8l6A/xlZRFWeAaDI5v7W6FWp2xhVPv3lZLlJB8X8BALEnOIXPMaS3KAzhl+qxKyPhNYxibFJXyQK+PXs+GvBRVTlm3Qy139+NU3kwhZ/mlIOFLrdgb2r4vfOL4WqgvpRrFWZ9zZeuRwtLhFDizHzI31ph/p6P0KE8DkzHIQHv0QBhYiLgBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(6486002)(478600001)(6666004)(41300700001)(26005)(6506007)(6512007)(86362001)(31686004)(53546011)(54906003)(316002)(110136005)(83380400001)(186003)(66556008)(66476007)(8936002)(4326008)(5660300002)(8676002)(66946007)(36756003)(38100700002)(2906002)(2616005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amh5VS9YY09KL3M0MEIvazI0Y2l0cFo4Lzk5OFN3Qi9aTWxvSVltNHVFajdz?=
 =?utf-8?B?akNSVGVmNmw3NUhqdFR2NmIyVktIOFVyZHgzSHZVeGo1VUQxeHNMZWQrekIv?=
 =?utf-8?B?eXNnRlc2UVYzMDA1czBZVS9GMEw1Sll5VlRmSzRxQXdvWTdDNHc4U3EyWnhN?=
 =?utf-8?B?VnZDa09wQjRRcGZpLzVYMnFuM3pwakVQRHZZdzlycmIxYlRQOFdSRGE4YkRH?=
 =?utf-8?B?MHE5WW9ZN0RMc3RxK2xkc3dzMmdiaWZXbG1nLzd0eVhmc1o4MTgzL1RkR3RN?=
 =?utf-8?B?TGE3Y2I0U3BTMDJOcE5kaEdBaFVHMGdwTGlpUC84LzlWVWN2Qlg4L3J2R0FJ?=
 =?utf-8?B?K3lnUGhYTUZsRmpKNVh5T1FLMXp4VHdGKzZjYitjL3FRRUR6LytNWDIzQm5z?=
 =?utf-8?B?c3VPdkViWVlOdnlvQlkrY0JHTmp2c0h1bmRZSDloSU9weW85dEFYeHJSbTg3?=
 =?utf-8?B?aTFDTU1PWjduaUk4QVZXR3BBaHFwcHEvejQyY2hSOUNrRENyRmtPaXpBMUlN?=
 =?utf-8?B?L2RPSWdnY0F5ZmJIRVRLMHZYN1p1ek1NRzBiYnNtUzVLYWl0anBqV1U1czRT?=
 =?utf-8?B?SWd1QzZsQTljTk9welp1cDFyTjQwK0xEUjhHak5mNWlSdmhtTDErbkpyRzAy?=
 =?utf-8?B?TXgwcjRjelprSk9DT01xTlVwQUlLc3pmSXh5ZGlrRXgwVW92dEtycktKM2M5?=
 =?utf-8?B?OFoxcDFxODJTT0pZMFJqbmhNYWgxZ2RBLy9MSGpWcjFnalpINUVMbGl6eEZG?=
 =?utf-8?B?ZjVhd1ZqVVFJcVMzSkxMWFNMWEl3NC9TbUc5cDJiejlDY2Fwa1lER1VkT3lm?=
 =?utf-8?B?a0RvUm9KVVlFL05seStDYndUSTJaaFlGTnk1N3NKeGd3dFdCcUFyaWlqeU5x?=
 =?utf-8?B?WC9VUmZZTHpsc1dVMHpNQmxUVjYzemgxekxRaWpFWVNJaHdpTlliRHl3ZWN3?=
 =?utf-8?B?dVFPVFZOWUtJQ1dCWlVFdzRnWWZwTFNtYTRoeERmZVRuNVU4R0Q5THVSQmJX?=
 =?utf-8?B?ZmVMdU5MR0dPM2M0WkVGYW41YU1ieWdweWVTSHJJanFweUJpY0pRcFhCY1hz?=
 =?utf-8?B?Qm8zM1VRNkIzNjM5NEJqNDJhZnRHRjFUdW1BcU40SzZ1Sk81NkRCRFkwWEFw?=
 =?utf-8?B?cEFHY0xEbzE2YjVhTXFJdUlZVkszdVJKcWZqaUo1UFAyaWdpZWdBT3pwU2x4?=
 =?utf-8?B?NWpjV3JreGk5MnhJWWVIeXJhV3lWbFJEMUkwT0tRWlA5NTFoTThpZms1Sm5I?=
 =?utf-8?B?RVhxZVFHNWlWRjJ0VnlnMEVTWXcraEd2STdxckRMckxKTkt2d1ZNdHJhalAr?=
 =?utf-8?B?NFJGNEF3eEtBc1ZrTFBacjFTRFoxbjh3cXpneFpwYzRvd1Zxa3NHbTZDSVJS?=
 =?utf-8?B?MEo3SXFjaTBWMW5vd3JzWWNMYmVDc0ZOZE9LM0RKb2VaUzdGYU9UTDhpTHFX?=
 =?utf-8?B?aDYyVlcveG1iUE5nZHpKSXJFVDdJM0dLRTNyTGY2N29HemxUb09GMTh5Rjlq?=
 =?utf-8?B?ZXBxZWtEQ1dFQm9pRGRBNXBkSDVEWGFWNHdkTTlCc3hLcGYxaXpXcTBGbGNP?=
 =?utf-8?B?dGIxbDRSMWl5VzNHTHQyRkZYbVNTV2VBbmw3YThxamwvOE1kWFVhQ2QwN28y?=
 =?utf-8?B?NFZnSHlyV1BPdDZaK01ubm5QcmtwTW9PYlQxS0sweTFyTDVEV3ZLMERUejlK?=
 =?utf-8?B?Wkg1Z3gvdDBlbEZqR3ZsUVJjWFV1d2VsY2FEV3FObzJlN3lpREhCdmVWVFMz?=
 =?utf-8?B?YzM1S0NybWdsM0MrZ2pSS1ZGN1NHVnBnTU0wR1BnZTdYMDQzRml1a082SU5v?=
 =?utf-8?B?dXZrcUJQSjVYZ2dsZjVMb01sWWFLS1NlSXpGYTV3b0FyQ0h0T1VRUEpiak9m?=
 =?utf-8?B?Z3lrOW5YR0drK0pFR2hZZGl2Wm1iQ2FNdVJqRlJudDd6d2tRUnZjMDN3WE9v?=
 =?utf-8?B?T3Y4ZjRXeWxCR1MwYndFeWVScDdzelBkemhJWXBFakpoRUtjcGIxQStKemQw?=
 =?utf-8?B?NFBDYktiZWltbGNsK2ZkUTdIdlRhSVpLOVBRb3VqSVRhTzJ5Qlg4cXB5bnFJ?=
 =?utf-8?B?cUI0a25SeUc1SHpqMW0wcXIwZEtwc3BVaGVVQ3J4ZVorY3ZpRDEvbnNiN3N3?=
 =?utf-8?Q?a+bCmqeIzLsDmmcr5Zn4hUwhO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f299d495-d225-41b2-378a-08da68b90ab9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 12:28:38.6526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dHAAag4ytHKP6QCPvyoXShCMJnoxB2vf8ED4UZSTM8mYVoShtahQxCofoSgVibWy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5831
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baoweng,

On 7/18/2022 4:40 AM, Baowen Zheng wrote:
> On Sunday, July 17, 2022 4:26 PM, Oz Shlomo wrote:
>> Subject: [PATCH net] net/sched: cls_api: Fix flow action initialization
>>
>> The cited commit refactored the flow action initialization sequence to use an
>> interface method when translating tc action instances to flow offload objects.
>> The refactored version skips the initialization of the generic flow action
>> attributes for tc actions, such as pedit, that allocate more than one offload
>> entry. This can cause potential issues for drivers mapping flow action ids.
>>
>> Populate the generic flow action fields for all the flow action entries.
>>
>> Fixes: c54e1d920f04 ("flow_offload: add ops to tc_action_ops for flow action
>> setup")
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>> ---
>> net/sched/cls_api.c | 17 +++++++++++++----
>> 1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c index
>> 9bb4d3dcc994..d07c04096560 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -3533,7 +3533,7 @@ int tc_setup_action(struct flow_action *flow_action,
>> 		    struct tc_action *actions[],
>> 		    struct netlink_ext_ack *extack)
>> {
>> -	int i, j, index, err = 0;
>> +	int i, j, k, index, err = 0;
>> 	struct tc_action *act;
>>
>> 	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY !=
>> FLOW_ACTION_HW_STATS_ANY); @@ -3557,10 +3557,19 @@ int
>> tc_setup_action(struct flow_action *flow_action,
>> 		entry->hw_index = act->tcfa_index;
>> 		index = 0;
>> 		err = tc_setup_offload_act(act, entry, &index, extack);
>> -		if (!err)
>> -			j += index;
>> -		else
>> +		if (err)
>> 			goto err_out_locked;
>> +
>> +		/* initialize the generic parameters for actions that
>> +		 * allocate more than one offload entry per tc action
>> +		 */
>> +		for (k = 1; k < index ; k++) {
>> +			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
>> +			entry[k].hw_index = act->tcfa_index;
> Thanks Oz for bringing this change to us, I think it makes sense for us when the pedit action is offloaded as a single action.
> Just a tiny advice for your reference, maybe we can start assignment from k = 0 and delete the first entry assignment above, then we will put all the general assignment in this loop, it will be more clean, WDYT?

If we do that then the hw_stats and hw_index parameters will not be 
available to the offload_act_setup method.
AFAIU no tc action actually uses these values (so possibly no 
regression) but perhaps it is better to leave them initialized.



>> +		}
>> +
>> +		j += index;
>> +
>> 		spin_unlock_bh(&act->tcfa_lock);
>> 	}
>>
>> --
>> 1.8.3.1
> 
