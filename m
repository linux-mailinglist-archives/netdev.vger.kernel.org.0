Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A453A21A0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhFJAw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:52:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26324 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFJAw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:52:29 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A0h714018521;
        Wed, 9 Jun 2021 17:50:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LSRwYGTXHFw7vXcGCIWFnDcrtKnEUsKG/ng43VTJnj0=;
 b=hfbYh/FoywOW6C+gUkogHryWoSIBcVzM5hzpCkcFeEKx0VPUw1jcROaGAGH2fejdRUXT
 gPGmxGULPZ3B9XHQ685mFj6TcFItU+pwcR2hDC23uFGJCjHrTj9a7UubFqMrnejH8fQQ
 YFMUFuh2zinLtxxiaA/P7ZZOv4o3hrO1Puw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39379g0bep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Jun 2021 17:50:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:50:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYIzi9ZOI/k/7CCztkKXWKnegi8qcq6MxLAt/rw7lQxnF6IJZi2CourmHTlntzGQbee39IZ7SL/Pb1HF+Uct/XofJt8VCm5ZvjJdVN6uyOpJVUiBciXpyrxgcKsa/LIDuvlg5auXbWHo3XhEr7C7G3lAzuQ2Oq9xZFpciRC+z0m9w4roFSMqSsf8AoXUiSzfN/UpKWP0/n57rRd25Jczki4/PNXN5LKggzzwVDVrjPkiqmRUra/UNuT5bkCSpcYGNCSKHMq5PxKxGiW6yTLRS1aEWBsiLBbbh8ei/EgZ12EukJxjOR1SQ/bXlbRhj6hX2dXzueuGaTHr802YYKuevw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSRwYGTXHFw7vXcGCIWFnDcrtKnEUsKG/ng43VTJnj0=;
 b=Vv3cBf6w/VHC/ohbkZoXZPfLbPBk88ZFEUEOeZl35M9YMbteL36+BgfJySCB2m00eCC4KJpeuj27WG3XLluXBcfm9TNOBEvQc3ZRqBx4+e5GCYGkHtfY1k/pP9tuU3gmdqWegBWbChXLwvJHzGBw/Yb6SABRj7asz7R5JTxhh5DcFEi6fAj9P2iAyGlDeN+wGGFOWF9sTTzAR6NP++xhxh/EuLSoq1mujlqPDQ3V0+G81jq96ADf5A0N7Yv2Cj2C8EFbX6efSblTWl5ysmxxNdgo6K04cobVZ1061zzLDAcRdcaDYlpi+lzstZNpT4A2xRDuth3RSz70KtinalcSDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3935.namprd15.prod.outlook.com (2603:10b6:806:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Thu, 10 Jun
 2021 00:50:16 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 00:50:16 +0000
Subject: Re: [PATCH bpf-next v1 00/10] bpfilter
To:     Dmitrii Banshchikov <me@ubique.spb.ru>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <davem@davemloft.net>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <rdna@fb.com>
References: <20210603101425.560384-1-me@ubique.spb.ru>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4dd3feeb-8b4a-0bdb-683e-c5c5643b1195@fb.com>
Date:   Wed, 9 Jun 2021 17:50:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210603101425.560384-1-me@ubique.spb.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:92ff]
X-ClientProxiedBy: SJ0PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::6) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:92ff) by SJ0PR03CA0271.namprd03.prod.outlook.com (2603:10b6:a03:39e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 00:50:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44b70e6b-fdd5-46f0-87f2-08d92ba9b68c
X-MS-TrafficTypeDiagnostic: SA0PR15MB3935:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB39357CC29AE30B241B41097AD3359@SA0PR15MB3935.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qF+9GAhMrQ3UGFwOEWmtKjNPXfsAr9Ot/LA1ypymUIw0n+AYRccURlN/IDnQChsLzfAAxXxYelpRm22/H8Z+Lq4A3UhLxdHNEMINhmlQfepRftuGCzSBxb9Oml8QYJIz426j5rAYAAumeElnNcx6I3ArWhyfXu6kH8xTgfy7MBFQkIq8vNn35iamwwELOtlICympUACaNBG90MOBix/gtKTWgqa/PtgRnD8vPbqQnOLgqz+xcKfnLI+m+NGIuV8mODc5AjGVZoO4UUs+dEfOxiY624HNo9akAhEC6BjKt7wnjDR+t7qMBK/dqnZL0f4D3O3RHsO/pw7QAVGTYaqvxwtoFvg0voVpRcZGafTsMyKTA+eh/H1m8smUqtuMcSaAKWEmrHgNKc+V2F34B3o261zmEn2GU8wYRy3nb1swPUTDcC14G4sPXa/trzJbwF/ZU8hFtWZ8uxpS9e0PRX/Drr6FaForFI5xdnp6omieBfTA4//BtTK9HeGcH+dtr4WrRVDqyHEueRUBii/jrEO2xP1m36hXZeXmBRUDJtx98iqHgU4CgmQUary06DnHkSy2Xjz+QsQjtF6vY9XgapNKWIw+iWQbnqhXp2mbaOvKso8uHegR+dXSdlwuTRlEE2++a66PHH1kKXx04mo09xf/opfAsT3f0DmL0W+5cvmtf4GtkxF5rs44qYamX8BGrNne
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(66476007)(316002)(66556008)(83380400001)(8676002)(4326008)(2906002)(36756003)(31696002)(2616005)(53546011)(31686004)(8936002)(38100700002)(52116002)(66946007)(86362001)(6486002)(478600001)(186003)(5660300002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1FramptZkxpd1NRNkZndjhteDkvTFM3RzcyMjRJampkZ0ljak45Z2t5MWps?=
 =?utf-8?B?R2hsR3JEM3JTYTJBOUZTelZnaDZ5MWsrRmRTT3h5N1Qzam9NRmxPQW1QU0Fi?=
 =?utf-8?B?TjlWTTRmd0E3YUFKRkVLdHVTVWFmTyszWXBNdmJ4U2VxMEN3S2tNQkZnZlMw?=
 =?utf-8?B?MTc4RVRxSHcrZllOcGhCMktQN2ZCS0RpK3hoaGF5Nmk3Y2ZYSzl1dDNJSDIv?=
 =?utf-8?B?dlh6bjBtU2NFaEdKS0FIZ2FXS0RiQTEyQXlUZXlHNXNKSXpJdWFlQ1dzOXYw?=
 =?utf-8?B?RG5KS0ZyQldpKzFXaEFzMGNhZ0pudXgwWU4vQ1FvOFJnZjFQTzB1bXI1czda?=
 =?utf-8?B?Ynp3OStxSHEzdTdNbHpJM2tLNjdPbURrSWJibE94WVNFbGxiSGIxc0hSZ2w0?=
 =?utf-8?B?dVpzNmY2djlPRlVPVC8vb1U2K2VkNjlaMHY0ZWZoWm9xL3Zsa0xjcHJBMEJ2?=
 =?utf-8?B?dkU5T2xpdm0zNzhlbFJLd1FMMUdBY25kRjRYdmtueUFGL3Nkd3V1OU5VcTN0?=
 =?utf-8?B?OTZNeDVRUnZYOHpHMTNIbnFYVHI3UWtuemFDVnVjbHdSemRBK25jN3RpYlgz?=
 =?utf-8?B?bU1za0pldEsxaGZDQ0FYMmM5TDNQV1VGNFE0RzdYeiswUGtIT2d1SU9sekdj?=
 =?utf-8?B?dTVRV2xzcEZoOXFsakJ3T0dMajVnTlRXd3EwNFFhQzlSTm1VUEg4UkJpbWJL?=
 =?utf-8?B?RSsycUh4cnlIekpYZ2IyR3VNb1RLSkhjeklmd2V5VHA1V25UMjBOby9vZS8x?=
 =?utf-8?B?QXRHNFRUREg5dk5yWnBVeDk4OGlzNldpVTd1U0lHZVFXeHJuMDg5K3Z6dEpP?=
 =?utf-8?B?c2NtdFpidmhNbEl2UlJhNVhZbStST2tEZlNFbkNOdVAyWDZZQklzWHJmRU1Z?=
 =?utf-8?B?Mng3TTFKRGdXaWNqQW5wZnBvcFgrNTg2eHpSQjBpQXJSQ1ZHUDZVSXFJS05F?=
 =?utf-8?B?NmtCOHpHZ2Z2MFJFdmVhc2VyRkpZNUJkdzFYdSs3NXRRbUZualZhM0pqcnZz?=
 =?utf-8?B?SllHOURjSmwzeGJKSHlJdVhGY1hnTzdFdytXbklZMTFhc1JHUGR5UEk2LytI?=
 =?utf-8?B?RVZUT1FpNFh5ZmhES3Q3YnhlOWREOVg3RWhCb2xxREtjRThUcWt1dE9pY0Z0?=
 =?utf-8?B?UTBQOWxxYTJrTmY4SWhFS3lhRkMzZnlLNkJVSzZGS2FtcUVxOVROY2pqYXJh?=
 =?utf-8?B?TExvdVZVT2g1UE1OVzEzZzA0anJ6Vmdob0Y2dlJlaG9uTEwyWVo4VGE5dUZ4?=
 =?utf-8?B?STV0STBoc05kUmh4RnRMQkdPNGpHNnowN2hTQnJMdEJKVkNoNkFyMzdUVmFj?=
 =?utf-8?B?VXJuWnNDMkJ2VG15L0NiL2ZJcEtxd1dTY2VTdC9ob2J0K21qVmVBd1NnMXNa?=
 =?utf-8?B?TUQ3cTh4UzF1cStyQVRjY0NwQzdJU0Q4MFBXdUlHMUtDd1RlamVtT3Eya05x?=
 =?utf-8?B?RGdSQkFEUm1GRHJQcjEzL0lZRUtxWXlwdkt0eXBUZUF5czZtZWx3SlBCZURO?=
 =?utf-8?B?YkhxWEthUW5RUmNOZXIzaVNsUjNVTDczVHllRkQxaDY4cWNacS9pem1VQ0Yz?=
 =?utf-8?B?Yk5XMEhhZnEvWmh4cVZBcFhNQ05ZT0k4RkJQNlRpZURlZHBkdkloZnA2OUxT?=
 =?utf-8?B?ajlsNVltcmlMRi9oYlNMRVk2cy9uYmtUcVRPTEI1L2Z0cXRmaHpQcFhmbXRx?=
 =?utf-8?B?cGdVeWlTdSt4eU9SLzNjM0lzVlg5QTJRdzFIalhJb29teWlTVDVuR09nc3lp?=
 =?utf-8?B?RmlCYzVxNW96RzNqTnp2ckRaTW5JY1NiYUpkeWk3MktsTEt0QVlwNGRZbC8w?=
 =?utf-8?Q?hvLnoQsBGOx53YirWG3xQlfIa3uX3vamOMNhA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b70e6b-fdd5-46f0-87f2-08d92ba9b68c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 00:50:16.3075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9UVHtTKc2dlpLgWZr/UrM4ps9bXjDettfUHgKA2aiBfM/0OOy5VK1uIlYBHAi/E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3935
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Y72SYoRQtGnrHlqwxuGBjmL4nA4Td3Ti
X-Proofpoint-ORIG-GUID: Y72SYoRQtGnrHlqwxuGBjmL4nA4Td3Ti
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_14:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/3/21 3:14 AM, Dmitrii Banshchikov wrote:
> The patchset is based on the patches from David S. Miller [1] and
> Daniel Borkmann [2].
> 
> The main goal of the patchset is to prepare bpfilter for
> iptables' configuration blob parsing and code generation.
> 
> The patchset introduces data structures and code for matches,
> targets, rules and tables.
> 
> The current version misses handling of counters. Postpone its
> implementation until the code generation phase as it's not clear
> yet how to better handle them.
> 
> Beside that there is no support of net namespaces at all.
> 
> In the next iteration basic code generation shall be introduced.
> 
> The rough plan for the code generation.
> 
> It seems reasonable to assume that the first rules should cover
> most of the packet flow.  This is why they are critical from the
> performance point of view.  At the same time number of user
> defined rules might be pretty large. Also there is a limit on
> size and complexity of a BPF program introduced by the verifier.
> 
> There are two approaches how to handle iptables' rules in
> generated BPF programs.
> 
> The first approach is to generate a BPF program that is an
> equivalent to a set of rules on a rule by rule basis. This
> approach should give the best performance. The drawback is the
> limitation from the verifier on size and complexity of BPF
> program.
> 
> The second approach is to use an internal representation of rules
> stored in a BPF map and use bpf_for_each_map_elem() helper to
> iterate over them. In this case the helper's callback is a BPF
> function that is able to process any valid rule.
> 
> Combination of the two approaches should give most of the
> benefits - a heuristic should help to select a small subset of
> the rules for code generation on a rule by rule basis. All other
> rules are cold and it should be possible to store them in an
> internal form in a BPF map. The rules will be handled by
> bpf_for_each_map_elem().  This should remove the limit on the
> number of supported rules.

Agree. A bpf program inlines some hot rule handling and put
the rest in for_each_map_elem() sounds reasonable to me.

> 
> During development it was useful to use statically linked
> sanitizers in bpfilter usermode helper. Also it is possible to
> use fuzzers but it's not clear if it is worth adding them to the
> test infrastructure - because there are no other fuzzers under
> tools/testing/selftests currently.
> 
> Patch 1 adds definitions of the used types.
> Patch 2 adds logging to bpfilter.
> Patch 3 adds bpfilter header to tools
> Patch 4 adds an associative map.
> Patches 5/6/7/8 add code for matches, targets, rules and table.
> Patch 9 handles hooked setsockopt(2) calls.
> Patch 10 uses prepared code in main().
> 
> Here is an example:
> % dmesg  | tail -n 2
> [   23.636102] bpfilter: Loaded bpfilter_umh pid 181
> [   23.658529] bpfilter: started
> % /usr/sbin/iptables-legacy -L -n

So this /usr/sbin/iptables-legacy is your iptables variant to
translate iptable command lines to BPFILTER_IPT_SO_*,
right? It could be good to provide a pointer to the source
or binary so people can give a try.

I am not an expert in iptables. Reading codes, I kind of
can grasp the high-level ideas of the patch, but probably
Alexei or Daniel can review some details whether the
design is sufficient to be an iptable replacement.


> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> 
[...]
