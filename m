Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A84AF547
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbiBIPbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiBIPbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:31:38 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63481C0612BE;
        Wed,  9 Feb 2022 07:31:41 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 219AuOd5027829;
        Wed, 9 Feb 2022 07:31:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zvHrg9Iak7NwzpGe7yYrLbpEiydxDTD1LUGQrodREqI=;
 b=TZpcaaLHMuVuevvVRKjjQD7FUuuBHDXciVWUFbYONcTw/Tg4l3UAMTop8MMgXkxLbkHQ
 5AGntM4wymb41R5mTVvmorDjlcnXOeffSJGHUGU8z45zQs/sCakBersXXuV/9/99UQYs
 1j7Nh/ZqzSQx6zLcJ5FtGMZ7xZsGD7opI0g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e405cwhsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Feb 2022 07:31:12 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 07:31:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXi8DCCNmDJ0QWZoYckgOiJTXudTHx4XI4bhM6Qil+kGF9/hrF/wq4wBA/RsUaRrN8qp7zBhrWhNKHMqpJ+A4vd01W3rT6m09nJu82HvZxeiwk9x+q6hotSPzgG2JV1mZZGBoKYWGC37Yts/WbBa35Nig3EvD4zITR8BrWRUPN3pyoiGk4C7fcuIptvfnA0KOrNuQ103uLHKeBP6hzczdGtPUAvvIAvYt+fh25u3OJ23tUMwijxf5Mi+aWjAnUyTJVuk8ToP9JhEznGw2dR4qiF3DmzmVb7MJgMXiFlUhAg9uQkGKKCB+9h9GTKWK3x2iIPdRzDvyZM6G4pHu0znVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvHrg9Iak7NwzpGe7yYrLbpEiydxDTD1LUGQrodREqI=;
 b=JWxgstuondbYHmsh1OmlezX8Y0/7tvmEmn3tbkf1bKrOJlt7+sujV0S0ULaeWiM3YnKpcKp4z6nhMVUYaGBHhKX8GFeaXZH9j38bXvBPp4wfDiw+wO4TwHsZLlQyEFq2TKbMQGLVCiv1y8twfAcPdgqNK6O3CFC4cgVJJ4mMcFQin/Ho7hBU+p0GCZ+k88P8vuX8IGg7Ibb6GwDQx+hZypFV6oWh5xtju6UfAlpO9sCC8vaeeo5UTIcO5D1Q4ncXhpptuMjej85vshehvun2+ceKZNva5VhixdegWJIqNY2RsjBxpzF1FIYDnIMPbAY300c2ZjKnZZWCNA4D299ATw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB4912.namprd15.prod.outlook.com (2603:10b6:510:c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 15:31:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 15:31:09 +0000
Message-ID: <7f79a28f-71e7-940e-3718-f21b43105cb5@fb.com>
Date:   Wed, 9 Feb 2022 07:31:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v2] bpf: reject kfunc calls that overflow
 insn->imm
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220208123348.40360-1-houtao1@huawei.com>
 <a11e8024-5a83-3016-f741-110ee74ee927@fb.com>
 <1e3c5443-ab95-6099-55ee-edfaaaa9c898@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <1e3c5443-ab95-6099-55ee-edfaaaa9c898@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: CO1PR15CA0076.namprd15.prod.outlook.com
 (2603:10b6:101:20::20) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f74b0c32-d522-4a6e-1351-08d9ebe13234
X-MS-TrafficTypeDiagnostic: PH0PR15MB4912:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4912D7D5EA917C692C68616FD32E9@PH0PR15MB4912.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:304;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMt0WQBzNwHRpzvNMJAcBuDpNL0C+/CNN2AS847a6EZ/mCBqo2Y2XapeFHYZBjfahA1+qzvH3ohTZPzFKvqzA7aErV5lRuce2v5XbwdF+gK0Z/MZqsKOXmxHTzPecGzFYk4eXNIRhHHnEx0FdrxyDEIB8Ny8Jn2Ti0swEcQdQCy2QWQnPcbv+O/USMx6giv3Zg6E/zbJnI3+Boq47cXBHNEJ6Lfd2fFCjM/mDAFOn3B9rF1AKRp9sYCEbosV3cAxGTnaQ13tzMUgciHHASvobEUXttKtGt2rdh9BH6ySSfw7RGhaIrYtabBDpCwzRaVb9ffpo3fTf3d2HjD5uIWHkMOLT8+J0RufZpvbLFOIz2qu0+SqAywotZ2dTx4PjNSFN9cdCVBqc682INf3q4R+GaW8ic4+6lMf7/sJFLPANVH9oSN0GPcen0cmo45rqvIoODbvuwIPjXHaXarzDWQ/vWpS/wsXdvKjA7+aiEjZxdeLZC45rLTuXu30qW+t3XgwWB76Oct7TIxTqVNpL8HDoQgg98SN0UvJ8nFF0+eubQSyqTf29eQWvEemkz8z/yz/1Copf4r4uGLUGaqNOsET0u4nQik7t6vaCrbEl0IRPs4H94nrQ+s2j/NHPFA0v9aTcUt6KY5bKQS5G7ilEg1wqdvR0pWMoghWEonqd5X3uxrq3/Qfvm3Mxo6hHyHzm7EJhbVLa8KvA7Hu0fIolOXpITqoy5MQJS+e75aCuN2kkilQAcl7RKTvG/bvawrFVOO+gG1Qu8mjUMtF014l+H3+AfTa4rlb6vgOYhXg2w62yV2Jn5HNsb+K9q13S+8M/970vCBC1yjqsNCVu5cuQDbwCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6512007)(6666004)(6486002)(966005)(86362001)(5660300002)(52116002)(53546011)(2616005)(186003)(31696002)(38100700002)(31686004)(2906002)(83380400001)(316002)(66946007)(66556008)(8936002)(66476007)(110136005)(8676002)(54906003)(4326008)(36756003)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0tFekw0SVM2THAvMG8zNGR4TU9paXh5Q1BPYTU5dGRtcGd2YTlBenRLSlB4?=
 =?utf-8?B?ZHNPNWZQQ1dWVkcwazlXV2QyanFwQ0RXNVBFNzloMGwxakFmdkU2UitiZHd6?=
 =?utf-8?B?WVp2M21pZGw5ZDB1RFpXYndIcnJWY0dvazJaTzJEMDROamdObGE1Y2o2eGN0?=
 =?utf-8?B?ak1UQXFrMUxYYWZzS3M1bk9JaEhvbEYxa2dQcTlBU2p1SGZXZUVVTktkcWJj?=
 =?utf-8?B?Y1ZNU3MyWjdpbEdlRkdSSHBCQzRUNW1WVVJ3dm5hVVJiakVxSXBGWDdtYUZR?=
 =?utf-8?B?UEkyY2RCS24zUEZ3OEVYTklUMmtzYWttWmVJcTUydnV1QWU4ejlTTHdmQmNT?=
 =?utf-8?B?K2NzeGd1a2RPOGdIOVNaQzhiQ1prNkxDMkx2N3o1QlJJOFFSczlENWVSTmtN?=
 =?utf-8?B?ZjFOVnB2cXBpWUJJTzVlcVpsUWtPMnorTU1ZRHdqSWJqVU9XVkNWdi9FMmxa?=
 =?utf-8?B?ckY0R2V6VHl0MmZnMy9SMG1JMjVWTUpmNkg1UzlhcXdia01kdkZneWZKTmVE?=
 =?utf-8?B?NzM5RCtXZU4xd0hUU3FXSERMSnZnYUJidC9Xd1FhcldoSnFWenhESm1pN1NM?=
 =?utf-8?B?N2tjMEw0SGY3YWM4dGpFTURqVkh5WTNRbEJyem9MdnhlRXpRM2MvS203VHN4?=
 =?utf-8?B?aGkrTS9ML1cvS1ZFSk5yOGFlaTBwSGNQNTVnMVE4UjY3bDgrYnB0QUJpUGkw?=
 =?utf-8?B?SnZ4NDVEajRqV0toY3FsUmtmbVNFUkRWT24vaVVZeWE5NGExK1VqMkRncnpY?=
 =?utf-8?B?dE5ZNzlyclRrMW90NEc2enIrSXF3dGF2b0JIRnhhTGFpcXV1YUhYUDhBdGIr?=
 =?utf-8?B?b2JwTkMxMG5aVmxUeXBZWnZXZmsyT0Y1QWEreVFYVTFGTjNQVGt2YjhFYmxm?=
 =?utf-8?B?L2V3d0pMdVYySnpUYmVaajRVWUVTN2tSaUlMV0EzZDB4MjZPeE9qYUVHUGVQ?=
 =?utf-8?B?ejdVRzZMa0lkUHova2JNbHYwczQ5dm9LRWhpcmJCTDlxVlgwb01KY05GbmVU?=
 =?utf-8?B?c3FTT3FiT3A5czlsb2tBSG5YbWFEU1grRVlGSm5EVEYvZjFlWVZlSWpzOUpO?=
 =?utf-8?B?Qk9SQ1lBR0lMc1kzMXdKNFBWV1FLZ0JzTCtsUGNtczBTSWl2RFdraGJnaDNv?=
 =?utf-8?B?MFVkcjBDTWYrRDZLN1ZOdmpBbDI3MnQzOEluME5SYUIramFWbWo1dWQwdzR2?=
 =?utf-8?B?dFdEODlCazZsSlhQdk1HNVRLcHdoM1J4TXRnMVFaTWZLeUkwZjRiSzVDd29j?=
 =?utf-8?B?TkNxdlA1bEI1RGIyN2I4TDlTcUZGdThuS0EwM2ZnSGtrT1hSWVV3bE03cHB4?=
 =?utf-8?B?dHBLOU9ZMGlLWVdKSytRY281bSt4dVlKQlhkMlIzaGZHYjhSellzNXIrYWhu?=
 =?utf-8?B?aUVHVDR3NURGQXB2VEpGTVBVbkpvSTMrUXVFN3Vnd2lwN0J6WjlTd3k1L2pY?=
 =?utf-8?B?RjFPVURRZjAyL3QxUGhLQjIyVTRYSW9xSG5DeXZNaDJTdEUyRWF0T0hudlB0?=
 =?utf-8?B?dklDM3A1T1pXMUJsN3dKcDFlNStZRGI5VjZ0eENhbnptWWhiRFFkNVJDTWdJ?=
 =?utf-8?B?S3RjN3ZEa3RyQkczSWpvZEF0NGY5ZEc5Lzg3WGtFcFVKYjUyV3pocnlHS0FV?=
 =?utf-8?B?STdqWFpnLzhBbUlmWDZLanNKaEFXdWlBWm0zR1d0Q3p0NE1OMkp4ZmM3Y1VW?=
 =?utf-8?B?eXM2VmZ3SzE0MzhmWTBLUDVZNVErcElyWWgwVnBvMk1URWFVOFhjUVJIZkxC?=
 =?utf-8?B?NEIrV1FKVmh5azY2V2pTckpoM2RxbzBJVjdHc0orNHcwYlpDVnk2U2pQWE5X?=
 =?utf-8?B?RFBWRXJmMWJSZW9yeHpNWFNtYVE0NVIxRS81S25MT0tyY1JrcjZYbmpLZnd4?=
 =?utf-8?B?bFUwVXlUSTIxTm05QWxqWmN2VitPU2lza3Z1MHNvTktNY29sdEUvNWhDWUdK?=
 =?utf-8?B?S09uMHdhZFJIaEMva1pTdURHYUhNUnNHZXNPWm40MmE5UnpFT3JaL1VUSFc1?=
 =?utf-8?B?MHErajFMRWdLZnM0bFJnaVJ4b1pOSTNCdk85aEJzTUVFa09vbHE0OEVGd051?=
 =?utf-8?B?YlMyTEZMUTZyWnlkSWI0dHNwaHQ0SnpZNzg3RTNHZUJ2T0VEUDVKSTU3cjA5?=
 =?utf-8?B?VlgycHFLaTVSVERMYWwxU0VBSE5YYXphRTF3S1NLSk8zQzhFS3A3VEdLY2Ew?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f74b0c32-d522-4a6e-1351-08d9ebe13234
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 15:31:09.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxFitAkhJvXADt7IXDtbWWV4jLSHebypapM7BMJee3qpcgjpUbvRaQZYDyA2cx4z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4912
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: NUxyX5F75u1BpXbHz7hJnlUSjmR4hCLZ
X-Proofpoint-ORIG-GUID: NUxyX5F75u1BpXbHz7hJnlUSjmR4hCLZ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_08,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090087
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



On 2/8/22 10:20 PM, Hou Tao wrote:
> Hi,
> 
> On 2/9/2022 12:57 AM, Yonghong Song wrote:
>>
>>
>> On 2/8/22 4:33 AM, Hou Tao wrote:
>>> Now kfunc call uses s32 to represent the offset between the address
>>> of kfunc and __bpf_call_base, but it doesn't check whether or not
>>> s32 will be overflowed, so add an extra checking to reject these
>>> invalid kfunc calls.
>>>
>>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>>> ---
>>> v2:
>>>    * instead of checking the overflow in selftests, just reject
>>>      these kfunc calls directly in verifier
>>>
>>> v1: https://lore.kernel.org/bpf/20220206043107.18549-1-houtao1@huawei.com
>>> ---
>>>    kernel/bpf/verifier.c | 13 +++++++++++++
>>>    1 file changed, 13 insertions(+)
>>>
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index a39eedecc93a..fd836e64b701 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -1832,6 +1832,13 @@ static struct btf *find_kfunc_desc_btf(struct
>>> bpf_verifier_env *env,
>>>        return btf_vmlinux ?: ERR_PTR(-ENOENT);
>>>    }
>>>    +static inline bool is_kfunc_call_imm_overflowed(unsigned long addr)
>>> +{
>>> +    unsigned long offset = BPF_CALL_IMM(addr);
>>> +
>>> +    return (unsigned long)(s32)offset != offset;
>>> +}
>>> +
>>>    static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16
>>> offset)
>>>    {
>>>        const struct btf_type *func, *func_proto;
>>> @@ -1925,6 +1932,12 @@ static int add_kfunc_call(struct bpf_verifier_env
>>> *env, u32 func_id, s16 offset)
>>>            return -EINVAL;
>>>        }
>>>    +    if (is_kfunc_call_imm_overflowed(addr)) {
>>> +        verbose(env, "address of kernel function %s is out of range\n",
>>> +            func_name);
>>> +        return -EINVAL;
>>> +    }
>>> +
>>>        desc = &tab->descs[tab->nr_descs++];
>>>        desc->func_id = func_id;
>>>        desc->imm = BPF_CALL_IMM(addr);
>>
>> Thanks, I would like to call BPF_CALL_IMM only once and keep checking overflow
>> and setting desc->imm close to each other. How about the following
>> not-compile-tested code
>>
>>      unsigned long call_imm;
>>
>>      ...
>>      call_imm = BPF_CALL_IMM(addr);
>>      /* some comment here */
>>      if ((unsigned long)(s32)call_imm != call_imm) {
>>          verbose(env, ...);
>>          return -EINVAL;
>>      } else {
>>          desc->imm = call_imm;
>>      }
> call BPF_CALL_IMM once is OK for me. but I don't think the else branch is
> unnecessary and it make the code
> ugly. Can we just return directly when found that imm is overflowed ?
> 
>          call_imm = BPF_CALL_IMM(addr);
>          /* Check whether or not the relative offset overflows desc->imm */
>          if ((unsigned long)(s32)call_imm != call_imm) {
>                  verbose(env, "address of kernel function %s is out of range\n",
>                          func_name);
>                  return -EINVAL;
>          }
> 
>          desc = &tab->descs[tab->nr_descs++];
>          desc->func_id = func_id;
>          desc->imm = call_imm;

Sure. Your above change looks good. My change is just
an illustration :-).

> 
> 
> 
> 
>> .
> 
> 
