Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922C26DCA95
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 20:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjDJSQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 14:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDJSQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 14:16:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90481BD6
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 11:16:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTABCbFAJ2yA4haljPIVTPWhSTCGGm4DDmW5QfefiB19SrzRAfHCAcuRBw8ifumsAT9n8bdOWV0kTPXRpihpBYMaRvot8nONXrAqUe3i8f237zW8FVRl0oju73r+u+CB2jbupQQKByXdrVXD1nEmEaCgjC/ViU9Y/DpPm9X1orkBkfuIOrQf5sxAFXQX2EQ19pZxNpnri0b/zgClemJQih/wOFNhPElSOSVlv/nmNMtofw46+/g70/ftubh81mItm45CkmoFStG2XCsSLB41fd5B2yR7joMbpfJOePJWbe/ceql5qoo/23oa043hrMh/y8iBmxLly9jITp4fzhsklQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7pFBFXN63EYxyJxw9vQLCYd8MKBqsHl8XnMcN2JSvU=;
 b=lg92X7R14nxjWlb+YoPhYXQrPXWZXSwrNb0pN3+w3XdBAxEns6gVZX05DhStDCXb1a1FjTwn8o+RS+f3c5Oc8GPw5R2AYiYecAtNeGa6ACX/hYOJXEYohkFCtUvLQHzQqKPKkSnbCq4N/bL1JyQFjR5wTr9WWmsaq0XgRman7vV107q2F/myN4Ta68ih6uXbJz/N2M5l/XTbICuKWkQLpcmwp9Dfx/8PFBD6ogBG5irNV70ciyMTNwz2MA7gNqVCicPJuXI/ZdOMPu01NdJ1on+kcnR1z6h7coY5rOZjbL5DVP4oS39xsLqtonEH30JpCuEGYBisL2azWJOd5+fJxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7pFBFXN63EYxyJxw9vQLCYd8MKBqsHl8XnMcN2JSvU=;
 b=uuu5pjf1lJbKfEtjXFV0ywzk0JP9X6fD5Z7I4ukyi9IpACrArXukzjCkzXjfVbKYn4D2W7tTQyvRHTemYv1WS0MdNw+svpbooLsmYGjxQDpEVpVGQeTurbOmc/GrzDJCBnGVacxTatHaPYOLT5vh2WzhmEXSO0DPigYLhjfGmmg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA1PR12MB8095.namprd12.prod.outlook.com (2603:10b6:806:33f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Mon, 10 Apr
 2023 18:16:07 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::e19e:fb58:51b2:447f%6]) with mapi id 15.20.6277.035; Mon, 10 Apr 2023
 18:16:06 +0000
Message-ID: <bd48d23b-093c-c6d4-86f1-677c2a0ab03c@amd.com>
Date:   Mon, 10 Apr 2023 11:16:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net] ionic: Fix allocation of q/cq info structures from
 device local node
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, shannon.nelson@amd.com, neel.patel@amd.com
References: <20230407233645.35561-1-brett.creeley@amd.com>
 <20230409105242.GR14869@unreal>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230409105242.GR14869@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0055.namprd07.prod.outlook.com
 (2603:10b6:a03:60::32) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA1PR12MB8095:EE_
X-MS-Office365-Filtering-Correlation-Id: 4533188f-16ea-4a23-f223-08db39efa6e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Td0fNtcgkvZ9sJSj7EG90BYefr3LfIwUGH3Wy/Pmr3aawOdaeua2ulxfdcYm0uzy6HgH2GgtlLV3LPScR3IGLuGikgcE7UjkWTDc2XkLvY7fsxATwIzHuMTglq4B4MYQN8foOwMDC4rIonN2bfrO3aK1wp+mihbdw8ru5JjxihzNqD+d0tp0moz4qUChQJS20p8kivrchhPB9ek7jPUW3G9KFjisJSaobLlTZ/5nVDtM9kHSboiY+Y3XAUM7FjGMz09RDXRrSL7e5gYqQLvGJEmAlps2B1ty7aZD1TG5AUrV7Ga75Amb/4slV+YfV8BI+eBzgdyh6x9xsSDzztNpVAHOqIdz0rlecnnhkW3vcTCCJShVHQZY3CGPhCsJAONC3FC32gt2x05K4JwdikklPAWeu66NRxxqbuVobzdlJHbVwPc6mpv3gy8Q07kSIahgvIY5HzFvxLiGxM/dncQRJNpirUdSVwrlO1+UpP8hRbcMTEBUkaaTUcWFpxSFqVtNbgxXNiiqcxehBiJx4v2PNkYC+U9LxOs4inEzM7hsrfYitIGwDQ+qsEd9UlAICxuHLJ6pmi2WYdv37dX/4Fee+jop6CsEg+tozrA+wV7WWluBKmizQXUL5EJuNZFcQrVYxnVSrggo05CQr6IDaXJweQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199021)(36756003)(31696002)(83380400001)(41300700001)(110136005)(66946007)(316002)(6636002)(4326008)(66476007)(6486002)(8676002)(66556008)(478600001)(5660300002)(2906002)(38100700002)(8936002)(186003)(53546011)(6512007)(6506007)(26005)(2616005)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TC9HKzhyRC9xT3dNa0I0VlhldVF5bmVtTG82bXk2dkpVOE1GbmExSUx2L2Vo?=
 =?utf-8?B?cUJQWVVsTWNjUzYzZTZpWmJOUnB0N0pWR2RTRVBUdWdVbGdYTm1lc0hYbmJr?=
 =?utf-8?B?QkxTUmtXQkYzeXNDOTBYKzRKKzRwYUZoeXZtZmlLVWlLSXB3ajFGTHJlZVJr?=
 =?utf-8?B?ZzZsVE5Uc1B0eEpoQVJPenRROU1YdEtURFNTUkl4VnZEaTZDT1EyUWJXVjdS?=
 =?utf-8?B?WWpHa3dyOUJ2WldiRVNYMStEUjZoSG1oZzhZZ3hMUVhiV3R1Vy85V0M1YVNx?=
 =?utf-8?B?MlJsNDRMMlRzSmx0eVRxelBySnpxYUpCbEtvRU1ZVCt2YUgzZUdOU3hJaXM3?=
 =?utf-8?B?WDdXOE0wN3RpMzhNQ2ZjYUtwYVRXKzgwWUZnL3NZcG1WS3FCRHpoMXFOSU5o?=
 =?utf-8?B?eUFrcEN1QjhhUGpHRWJpczJ1eWVKcU9pUzU5WEZJd09xV29RQjl1akd5Q3RE?=
 =?utf-8?B?cTR4VFI3WCtJVlNQa2swRWFmTW9sa2NEZngxRSs4bUJwNlZwUkkzRDNRdVJR?=
 =?utf-8?B?WXBMcnBZT1VLZGEvcngxUHBaMXdoVXlLUVg0cUtMbnlUZkhKWXd2UERjZzVP?=
 =?utf-8?B?Q3l2TDJNci9mOUlLNzYyMG1UZlg0cnZ6UUtOb3UrNmVBR0s0blFKRjQ2T0NH?=
 =?utf-8?B?MEtoaVZPb0FsbzcvaXhvaXJXQVlRVTl4SnlWMVNwM29td0x2cFRvWmtxT2l3?=
 =?utf-8?B?K0MrM1ZUUVBZMkdsWlJrSG9jTnRYOWZjcEtrcUpJZWxaaUhaT1JUelg2bWZP?=
 =?utf-8?B?dzhDOHYxakU2SFFpWHhGWXlaMkFsQmtNelR4elJIcTYxbzVxZEdoeGhmUFBk?=
 =?utf-8?B?dWxWeFo0V0Y4bFZIT1FWODJPWjZNN014U2g4eko1Rm90cU5nZXR1cEpMUVdX?=
 =?utf-8?B?UEJsbWpvU00ybi9xODBrZHF2aUN0OU1RL25teUJQVU9FaDdTdUFqcDNXdHhG?=
 =?utf-8?B?N2kvaVhZakp5dS8wbUc4UWRmSmFIN2FEbVdqY013L2ZNY1hNV2p6TEVGNUh1?=
 =?utf-8?B?KzdHU053VUg2eWxhMkg3dWo1ZGsxcnZYd29WYnRNVjNlUDU4QVRjeEUxd2hh?=
 =?utf-8?B?OWNESElWT1c0Y0h3ZkZIODFtdjBGT1ZHK0FEUEt5eXJXYlRSMFJ0L3dzK0k2?=
 =?utf-8?B?aDJrV1ExUERvUVJnWjRlNGluTVhFK1poWGpFODRLdk9WRVVxTDNMenQ1a08r?=
 =?utf-8?B?WFNCWW0yU09NTTRMSEcwbVRsZ2NuclgvZUpqTHlkbGNVVmhKdFV3MFpldCtG?=
 =?utf-8?B?YlhIVWlkNjhzeXBtdUdxRDRHNUFXV0orU3pocXhudTl6elA0aDdxUlo3M1dz?=
 =?utf-8?B?ejE3M2R3NVBGQ2VHVmR3Q1NIM3k2cFdmaDdvalhUOHRtWEdWQlBhYzQzdmwr?=
 =?utf-8?B?YzZQT3FQdTB2ZlcxWnQyM1I5UTlGQXBBcFBLZkJVOUkrUDNjd0Vsb0NPN3pY?=
 =?utf-8?B?dUVSNXNDYzJheERrWVVta3VKSDRSK2hONWJDMUNyeWlFZHFIL01nQ3poT3g1?=
 =?utf-8?B?SE0yc2RqcXR2QUQxRytvU25NdkFXWklwZzZ6TWJ1akpCc0xQRklZWkhEUTRD?=
 =?utf-8?B?OXZQK2ZRdzlNblpSRTVjQmVtSzYwQ3laK3JrZDJSOW9FbFZkN2RmZFJRbXpk?=
 =?utf-8?B?VGI5cnJsWTBUV2RaVHhNMW9DZGg4MTFpOFlJaFdOY3ZZNXhHb0VpMjlmWXBC?=
 =?utf-8?B?T2NMUWRROHpjTVBnTlRzRzVXNW1TQUJhSnNsM1dKZHNMRWNiSmVGcllIa2Za?=
 =?utf-8?B?U2k1NFlBV3A3NVZ4VkZGelNUU1pNaFVWVnhXR3Y5cG83bFR5blp6Q3QvR0tX?=
 =?utf-8?B?NHRZdVoveFJvbExYb2FYd2F5b0k0dDFGVTdkWVA2L2N3NEk2MEVHOWxlV0FZ?=
 =?utf-8?B?c3VWQTVqdU5SMlBNaDVtZ2pyeFhLNGFFYU1lOWwzaFB3dE5OdXFkbWV5QVBv?=
 =?utf-8?B?cFJETVpyN1l2U1RKVVorcDc4SVRoMXBDbVJWTjVUUHNPYXYrZ251M0syNlhi?=
 =?utf-8?B?S2piUlJvcVE3L3M5bm5Kc21xcVgyS21iSnRVUzdoazdLQXN6UUhBS2N1VkRT?=
 =?utf-8?B?RkJhbWNXbHd2WUVZUGZrUjRwSUpNWDFSYzF3RWkyZ3pyditSY1NrSjBiLzJV?=
 =?utf-8?Q?Q4sKiVHMksOelEQu6wzJ60bc4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4533188f-16ea-4a23-f223-08db39efa6e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 18:16:06.4890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: klKtZ6jls71ifVPWO9VI+bIpVQAUwjvFNv5EXEoMMpf3JLYQ9CPt1oaBlFW7C9B6WBFVbOvIdqUuso6I76/ctw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8095
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/2023 3:52 AM, Leon Romanovsky wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Fri, Apr 07, 2023 at 04:36:45PM -0700, Brett Creeley wrote:
>> Commit 116dce0ff047 ("ionic: Use vzalloc for large per-queue related
>> buffers") made a change to relieve memory pressure by making use of
>> vzalloc() due to the structures not requiring DMA mapping. However,
>> it overlooked that these structures are used in the fast path of the
>> driver and allocations on the non-local node could cause performance
>> degredation. Fix this by first attempting to use vzalloc_node()
>> using the device's local node and if that fails try again with
>> vzalloc().
>>
>> Fixes: 116dce0ff047 ("ionic: Use vzalloc for large per-queue related buffers")
>> Signed-off-by: Neel Patel <neel.patel@amd.com>
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 24 ++++++++++++-------
>>   1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 957027e546b3..2c4e226b8cf1 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -560,11 +560,15 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
>>        new->q.dev = dev;
>>        new->flags = flags;
>>
>> -     new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
>> +     new->q.info = vzalloc_node(num_descs * sizeof(*new->q.info),
>> +                                dev_to_node(dev));
>>        if (!new->q.info) {
>> -             netdev_err(lif->netdev, "Cannot allocate queue info\n");
>> -             err = -ENOMEM;
>> -             goto err_out_free_qcq;
>> +             new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
>> +             if (!new->q.info) {
>> +                     netdev_err(lif->netdev, "Cannot allocate queue info\n");
> 
> Kernel memory allocator will try local node first and if memory is
> depleted it will go to remote nodes. So basically, you open-coded that
> behaviour but with OOM splash when first call to vzalloc_node fails and
> with custom error message about memory allocation failure.
> 
> Thanks

Leon,

We want to allocate memory from the node local to our PCI device, which 
is not necessarily the same as the node that the thread is running on 
where vzalloc() first tries to alloc. Since it wasn't clear to us that 
vzalloc_node() does any fallback, we followed the example in the ena 
driver to follow up with a more generic vzalloc() request.

Also, the custom message helps us quickly figure out exactly which 
allocation failed.

Thanks,

Brett
