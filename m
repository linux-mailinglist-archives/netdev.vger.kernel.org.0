Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5334AC7F9
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbiBGRwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355400AbiBGRrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:47:05 -0500
X-Greylist: delayed 1366 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 09:47:04 PST
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0433DC0401DA;
        Mon,  7 Feb 2022 09:47:03 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 217H9Zsl019992;
        Mon, 7 Feb 2022 09:09:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PfgbmLDt87B/2lblonH24U1g50PfpMa9IPoBDloWzag=;
 b=XRGy0j2azP29DFZSbm6z0tlMFRjEIgad17CG1Al3a0U3x6eIPQuolXTAjpdm7cyM8jlt
 K7g/3prYoNp0wSOIozfiNmPUABtlnP7udMzq1p2nUgBeCzTdXa6kLfnx1vvqQ3vfZGA2
 IDR0yQ4AD6YkYExJ7Q/TWcOIClKeopuRrCg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e36xk8bjr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Feb 2022 09:09:43 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 09:08:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8klEf007JuygYtepvgpzEIKlmIp9wYZ7s7D2Lgai6uU9k/qu3TmUyuyql/yHgG+F1D6uLW4pjWgzoykjs9JdSszFwASRZ1TnXrm/NBV25Ij7FmGQY28RI7MUzi1wEIHDLHttQsMxSb2VxYDpQnp8NLATlHOR55TnpNrR5rJY9I0WPIGwztRDohxz+mSz/ybWqTQWgVE3JFCiVIJY7GtNZo4Qnb4mUrelgWCmjTt5ysD/45DrlKmh8ULxcpzhcFwPJjzcWc0wrox/LxOnjhreNKZrCaOf7hpXyeGv21aW3JGAOcncFoU4pM//2LkcOzI+O18Ng/bx0uMk0DwJlppNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfgbmLDt87B/2lblonH24U1g50PfpMa9IPoBDloWzag=;
 b=KosqIXl0+9wrub/e+C4ZKnMCGkmgmct3deholom/RpZO6IqmwYHhjvDejt/toYmsFGUtj+DySr1jWR0VyYkRK/a0kl0lCAxYFbxi0q6CJzH6ODD5wFqETXnOkMBwmoBaYniX2pqFGG1JrShq44znCCPpqHfRjNgPCGoBbD6vVN+2PcVQJP07xE43odOGTdsOFd/5naxqsDsAwNzEu0DBuB48unh7peiutj8bDdyqsWNNX5E6+9RS4ggXBKalnpXfCaPHpP2C3N8at/3CIr0j6l/Z9wSpWh8/M4WtyvwKqiUaOOpMKH+brX/Ind089mVd1ATOmFvDyWIUH044dsMvNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR1501MB2133.namprd15.prod.outlook.com (2603:10b6:4:a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 17:08:36 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 17:08:36 +0000
Message-ID: <c03f0c81-8e56-6c92-d31a-03a5394b9388@fb.com>
Date:   Mon, 7 Feb 2022 09:08:33 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next] selftest/bpf: check invalid length in
 test_xdp_update_frags
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <brouer@redhat.com>,
        <toke@redhat.com>, <andrii@kernel.org>, <netdev@vger.kernel.org>
References: <aff68ca785cae86cd6263355010ceaff24daee1f.1643982947.git.lorenzo@kernel.org>
 <c3858f6b-43d5-18ef-2fc8-b58c13c12b05@fb.com> <Yf1nxMWEWy4DSwgN@lore-desk>
 <15f829a2-8556-0545-7408-3fca66eb38b7@fb.com> <Yf1w2HRokiYBg8w9@lore-desk>
 <Yf15n2GJG70JrxX6@lore-desk>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <Yf15n2GJG70JrxX6@lore-desk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MW4PR04CA0306.namprd04.prod.outlook.com
 (2603:10b6:303:82::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02b32f18-67d5-4cd7-7fef-08d9ea5c7ab4
X-MS-TrafficTypeDiagnostic: DM5PR1501MB2133:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1501MB2133AED4E0DB3DC5ED7A4AEBD32C9@DM5PR1501MB2133.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: whTP/fNZLhnInVDKcFi57Vt9q6JjF7xnFis4DmrgRDZ6GeI5flefamJaDGVLqMbxFSAtzHtngxehrs5TNFQbuA0IU/t+LACiDVPCw/DvEz1X/Xwvw1ZiXLdOOM05lk9Zey19dIh5pzM6XJr+5RXpVlLs6imHz9vIvKO3k0G46RgzQ8eFwjL4U7dz/Bl3yj4ZzGTept/yndPLOej/qGjNWXsUeYnOd9h3w+4lkD8jp7DtyT9vxOj5IzFcjne1AmwCo++SupGXANjZSa0HDOqXmN8iw7mTKqy1vOJbh1/kyHvZkeSHPUgkLSkFGQxI+QSq6YBM0kNdL/EtS8bmgyLDyn4EHVlYWb7QhPozhoMXeIQpqeyCYe3mEFfk1iuU8vY332N2bekVfWrm7v3eTTwZ3G3HiXBj+FjYLMBa6PPjtgUoWq+FborsOnyK0roCnbeP4VzVQaXUEE5htPjZ0GvsfqwGagub7b6KPloVPJPv0dWcjoBbeHpvWW879zNY/jJaLBu1wu4yshUg+j6z7TOj3Es7huhaJqDQEzKJA/BeyV4NzgY1Mvm2tYxPsPDoHaZEfc5+T+QcJq07JbVbc7EZfXFdzzmwYQb/OQavkjKTFtE+AEFE4LjzwnN21VBRTPrfWdReiX3x5n0xt5RLnxjqD8/3UJ5L6K4drCSDOBSGZ5M+xyHCji7RRpBhUyhyC1QsrcaCbXtCdZV4/X/J/8SaQlYIi2SZLQnlODrCGCJV1M6kPuKY6+BYTPTEe64h8VqnlBrJRCmn0tWPFLSog+X/5u6z01Q/hpdt5vVRMk+e/ZoXOk9MnNriIeNFyffE1+jR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6666004)(6512007)(186003)(6506007)(316002)(6916009)(52116002)(2616005)(53546011)(2906002)(38100700002)(31686004)(86362001)(66946007)(31696002)(5660300002)(508600001)(83380400001)(66476007)(8936002)(8676002)(4326008)(66556008)(6486002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnBPWHFINzBTZUMyZ1hUQVNkY1I4L3lib1picjRBU2FlTUl4K0tTYmdtTWZ3?=
 =?utf-8?B?SEk5OGhpd0Y4TG9VRVhqVk15QlRpVHFhcDduSC9vdHF4T2FaRk12OXlPU0VZ?=
 =?utf-8?B?bGJFNXhSOVRIdVRYL2JVaGthVUZJWjJxTHE5azRGN1NxL0xxOVJRa0drZlB6?=
 =?utf-8?B?ejdDVDVPYlZYTFFhd1F1bmhRcytJcVRNeUxocGxBc05ZczBPdkJKc3hjY2NS?=
 =?utf-8?B?Y3ViZEtsOW1WU0xuQ21lRVlQbDdndmN6cjlmcnExYXRmVVo3NmJFekppZ2xw?=
 =?utf-8?B?NEhCWlBTMW9ScWZOSkhOTXpidzQ3SlJ5QytvekZtalVrd3o1emZJQWZwclVo?=
 =?utf-8?B?WUNvTHJVaDhtTnIyaDJVOU1vRFBUR0FpRXYyWXRLdXBPa2VnQjB1MDU0Yzhp?=
 =?utf-8?B?V283QXdDenZTUmtPajRwYUlhU3RraUQ3dDlmb3hMc2NvRU1tcmhrMWR0cThE?=
 =?utf-8?B?NWV1NTF3S3NOSUROcG5pNnNMdVdwN3BOZk1XdGk3Qnl3eStDMStSUUVXaERZ?=
 =?utf-8?B?dFBleEI2b1FpQU1DNURSd0NYbE12MzRWTi95WmhyWlo5dXk4YzJRREEvSzlz?=
 =?utf-8?B?dHRHZnBxeUZ3ZGhFKy9rM0U2c2VmMFgxa0lsWXhYWGRGQjlHQzNaVW9oRlhr?=
 =?utf-8?B?VTdTbzZEeUhCQW1GZHg0UncxcTF1N2c1aWF5WnhIanpURmkzbVVGaTNQSU42?=
 =?utf-8?B?THM1UnJzck1TalM0alk5Y2NoQVFQSTdBK1pmRzVGbGlmRVJ3RjExMy9QUkp2?=
 =?utf-8?B?SXV3VEcxNTZPbnZ3ZzN6bHhZWW5QNVVad09vcjBrR213Y2QybkREZllvRjRk?=
 =?utf-8?B?RjFXSXVsZ1M0Y1NadDRkQlZWNFEyUktoZUthZ1c4WjBSWlVPdjNOb3dNK09H?=
 =?utf-8?B?YjFYNDM5RVRLN0FPNlF5eE1zZlhwVG83S2c3SmVaVFFmdE15MHBTOE5tZk51?=
 =?utf-8?B?eFVJdGxtZ2ViY2ZqRE5mZUJoODRMOXFMbjh3Vk5QWUl0UTBEK1dkMGF1UmxN?=
 =?utf-8?B?andrYm9oTTBvOHpyWmhVSHBzQ0UwRjk4Ny9KbTlYRjQ3em15eElGRGhrajlL?=
 =?utf-8?B?T0ZhUEhOUjJROURHZWFJQlBhTlNNUDFRamsvZTdKMVQzQmlja3ZoWWpVZVVk?=
 =?utf-8?B?M2NJVXp6ai9EVUhIWU9jWVRaOWhFd0M2dTRVUjFXV0Zja3lzeUdpbWs3aWhO?=
 =?utf-8?B?RTRoT0hnbXZINWZ0dUYwUXM0S3RoOHB5VTkxSnYwUklQTWJLWm1sa21PNXhL?=
 =?utf-8?B?VXlwTm1KNTFISDV1Y2lhNUJiOTZLM2JkRWZkY1EzcWc4cnExZHhuWXFSQXVI?=
 =?utf-8?B?WU55ZEtVeDhNMVUvalNhcWgvb0xyd3M1dGZqMkdGaUF1dnNOWUdnMWtlS0lU?=
 =?utf-8?B?d04wRDlWbjBCUk55WlhrRkRnNDFTQUJhVkphL0tmbW8yUUZPS25tZHQvdURD?=
 =?utf-8?B?cytIT2NWdk5qZUlkT1lURjFxaUNiQUJSZGR5NTdnK2NvZWVlTEVrR3FPc1dt?=
 =?utf-8?B?aitJVmNzWTlpZEJBMzZ4Y0JBQ3M3Y2xicGJMV09ScU96dWZmU2dxTTNXV0lS?=
 =?utf-8?B?ekJwNHYzLytDUnhmMHVRV0RrUmZVVUVmbEtNejJNZGlDV2ZDKzRMeWhWQzA0?=
 =?utf-8?B?SXRBdW9KZ3A5VEhGWGlWbURQTEU5NUc3WXhoTVczRjdqYnlLYXV1aEJ4SC92?=
 =?utf-8?B?Nkxpc2JDWGh1UGVWbHBXZ1RTRVpXNW5WQ01ZVkF5SFpkZUpJVm84VUVsUXVw?=
 =?utf-8?B?b2RCOFJ1T0R5L1RLRlpkeW1XSlNHU0x3clZDZHpOc0R4NVB4SG5SM1h6V1Ew?=
 =?utf-8?B?bUFrdERaRElaRzNxTSs1YW5pRWRLR1orMzhDaWduT0F6YjRDTVBJbXNMaTZT?=
 =?utf-8?B?OWlvemU0V0dua3N4VkZ1MzV5VCtiSWZNN0dZYnIzTHFvVG04UjJxSWJWRmpX?=
 =?utf-8?B?SlRSVlB0K1FBdmk4diswbDhIUGZuRmJmcklEaE1SWGd6NHk4Q0hqT1FyM25X?=
 =?utf-8?B?a0NLQVVUNGJrUW9hTWNIbGlUOGdwVitZdlJKeUl1ck1ybmpVUGNwSVozeHFy?=
 =?utf-8?B?dkZIVmY2c3oyU3M0d2NXOGlFc3R6Y1BxMXFValJLallScXZubXdUa05JUFNu?=
 =?utf-8?B?TU9ONmdJVS9KdHI4ZXNwRk9xa2NLZFJjSGptZ2NHVWpEbFd0ZzJQb3RLdjZT?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b32f18-67d5-4cd7-7fef-08d9ea5c7ab4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:08:36.7269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0bqntVMGVP+dyJ4GVaJVxWxtj9UY/bI6+YzEweW9GacBtzM+qHC84PvoJHDs5Ry
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2133
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: _QxZE2FQxFSEiFC0R3soKyi93OE6mi1G
X-Proofpoint-GUID: _QxZE2FQxFSEiFC0R3soKyi93OE6mi1G
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=681
 clxscore=1015 phishscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070107
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/22 11:08 AM, Lorenzo Bianconi wrote:
>>>
>>
>> [...]
>>
>>>>>
>>>>> In kernel, the nr_frags checking is against MAX_SKB_FRAGS,
>>>>> but if /proc/sys/net/core/max_skb_flags is 2 or more less
>>>>> than MAX_SKB_FRAGS, the test won't fail, right?
>>>>
>>>> yes, you are right. Should we use the same definition used in
>>>> include/linux/skbuff.h instead? Something like:
>>>>
>>>> if (65536 / page_size + 1 < 16)
>>>> 	max_skb_flags = 16;
>>>> else
>>>> 	max_skb_flags = 65536/page_size + 1;
>>>
>>> The maximum packet size limit 64KB won't change anytime soon.
>>> So the above should work. Some comments to explain why using
>>> the above formula will be good.
>>
>> ack, I will do in v2.
> 
> I can see there is a on-going discussion here [0] about increasing
> MAX_SKB_FRAGS. I guess we can put on-hold this patch and see how
> MAX_SKB_FRAGS will be changed.

Thanks for the link. The new patch is going to increase
MAX_SKB_FRAGS and it is possible that will be changed again
(maybe under some config options).

The default value for
/proc/sys/net/core/max_skb_flags is MAX_SKB_FRAGS and I suspect
anybody is bothering to change it. So your patch is okay to me.
Maybe change a little bit -ENOMEM error message. current,
   ASSERT_EQ(err, -ENOMEM, "unsupported buffer size");
to
   ASSERT_EQ(err, -ENOMEM, "unsupported buffer size, possible 
non-default /proc/sys/net/core/max_skb_flags?");

> 
> Regards,
> Lorenzo
> 
> [0] https://lore.kernel.org/all/202202031315.B425Ipe8-lkp@intel.com/t/#ma1b2c7e71fe9bc69e24642a62dadf32fda7d5f03
> 
>>
>> Regards,
>> Lorenzo
>>
>>>
>>>>
>>>> Regards,
>>>> Lorenzo
>>>>
>>>>>
>>>>>> +
>>>>>> +	num = fscanf(f, "%d", &max_skb_frags);
>>>>>> +	fclose(f);
>>>>>> +
>>>>>> +	if (!ASSERT_EQ(num, 1, "max_skb_frags read failed"))
>>>>>> +		goto out;
>>>>>> +
>>>>>> +	/* xdp_buff linear area size is always set to 4096 in the
>>>>>> +	 * bpf_prog_test_run_xdp routine.
>>>>>> +	 */
>>>>>> +	buf_size = 4096 + (max_skb_frags + 1) * sysconf(_SC_PAGE_SIZE);
>>>>>> +	buf = malloc(buf_size);
>>>>>> +	if (!ASSERT_OK_PTR(buf, "alloc buf"))
>>>>>> +		goto out;
>>>>>> +
>>>>>> +	memset(buf, 0, buf_size);
>>>>>> +	offset = (__u32 *)buf;
>>>>>> +	*offset = 16;
>>>>>> +	buf[*offset] = 0xaa;
>>>>>> +	buf[*offset + 15] = 0xaa;
>>>>>> +
>>>>>> +	topts.data_in = buf;
>>>>>> +	topts.data_out = buf;
>>>>>> +	topts.data_size_in = buf_size;
>>>>>> +	topts.data_size_out = buf_size;
>>>>>> +
>>>>>> +	err = bpf_prog_test_run_opts(prog_fd, &topts);
>>>>>> +	ASSERT_EQ(err, -ENOMEM, "unsupported buffer size");
>>>>>> +	free(buf);
>>>>>>     out:
>>>>>>     	bpf_object__close(obj);
>>>>>>     }
>>>>>
>>>
> 
> 
