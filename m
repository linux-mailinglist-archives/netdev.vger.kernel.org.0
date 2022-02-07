Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F084AC970
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbiBGTZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbiBGTUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 14:20:51 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22824C0401DA;
        Mon,  7 Feb 2022 11:20:51 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 217Id9mB030081;
        Mon, 7 Feb 2022 11:20:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sD+bikd1azmM0dBNEa3EYM+8HY7/bu75w4QkSK6tSqY=;
 b=i3htWLSgY2muggMjfRU/VDJ2kC6Zock/NUzxeV3jr5Q2h1z5W/eTw0647yTMrPlBMG9p
 26ZL2rPf5U/fMJVnKuhmQUJzqMeI5ZRkUclMJa+rYzOsRjluw4PpoJSB3W1tAH+99yXZ
 p9NNAXVkEfFC+djwc7T3niSZ879h4EreoHg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e2t075cbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Feb 2022 11:20:36 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 11:20:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOaTTapRS4RKVEui2TUmeajRCDQxCTauhhJKq5w5eAT/V3CLg+BucgXCICbaElvd7iSh7qhrZ5JWwCs1DeBOI88mqwQTGX47FGcByxQ7rHXItLuQne4Etz6wyrQDc0e/g/ZuwtgWX5Vv5Q4TiWL3P4hSTVQQUWgjw3aeOvV484khTe7jmssw1+meSQl/gbP4moBuy6xLI5PafA99oUBXJ7RjDM3fqnNLXSKASkdRBDFvarQdxL8ciWoOfv24L+SL1oD9fnfJ2rel/pxGoMj7d7POdDCM15wTJ6ISthEYZHswiMviZzm2Z/6H743Mtkvw5P4F4aGAp0SWXpKQFnMmHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sD+bikd1azmM0dBNEa3EYM+8HY7/bu75w4QkSK6tSqY=;
 b=bfmgSxr6NMzRskVdfDBQWL2ZkSlaO7keAty4ugAsWWBXOJmrdIq0ajPfgnoxOU5eGWzBPmwJbHQ54TqcopfkcyqjT8q7fj8c8A0dQI1xfKtrvh+6jPHmQmQpULo+b6qHg2cL9wkJ3Xi68RVxzkBGv7Fn5xFHiihBsCAZKDIDNSmwFJKQE7+RFJmRLuoirpNaDLgkaXjI13DuZyKafQLDz9xU2akmVcnGFJeh3c6dRhw7FOvYE3NYi7DPkhhT3WAzbjj9AGFF4FbHX72wA4b/BJlPrkyJ11WWSdJdEOb1HCpeNY1E9LvCL6HMgE3AlBh0oUMkW6YHTiYgorHMcJCw4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN7PR15MB2450.namprd15.prod.outlook.com (2603:10b6:406:92::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Mon, 7 Feb
 2022 19:20:33 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 19:20:33 +0000
Message-ID: <36895526-cffc-c445-be54-e15481bdd3ec@fb.com>
Date:   Mon, 7 Feb 2022 11:20:30 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Cover 4-byte load from
 remote_port in bpf_sk_lookup
Content-Language: en-US
To:     Jakub Sitnicki <jakub@cloudflare.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        <kernel-team@cloudflare.com>
References: <20220207131459.504292-1-jakub@cloudflare.com>
 <20220207131459.504292-3-jakub@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220207131459.504292-3-jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0136.namprd04.prod.outlook.com (2603:10b6:104::14)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43d82fa6-532d-4016-4c16-08d9ea6ee95c
X-MS-TrafficTypeDiagnostic: BN7PR15MB2450:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB2450007FC6A236B57C5C19BDD32C9@BN7PR15MB2450.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PjQPvLX+TxFaJJE3kMoNDHn/ROyIz0iq3VfGimdbG0oRh+JjUq4fYwZK42PObyhqVKrJMPtx33EkQULtgYSHFYp36+Qx8Zl071k6GL1Yp1XZfGetLFjRtEXymEYzz+/7wIruuTQ2jOApO6QhqB+15KEKNT/mTwWgmdsndT+JtvBD7yrbViPuODSxgoMMFnWEwzmD3KXrHswsQqlRiRxgC7Npv9YQ8L5gbFNjyg15Z9DAtB+55eGfC8ZoeWQOVzUYFwBcWSHto1grnyZ9LZ1gJH2xZBmdOBfIasaZgg05bdCo96i3oYzGnCDSu1GdlFdFJJstTUuD0M58ps94w+u2aFXbVtKn7f6JQQrckk9pjoum30mluEz/JdGQt4bCwY2IPDKRJOfuMW9lYN0aoR1I9FrfkITWLYP3IB/WTmn91a9bTEEVeT9RGVDeDu1ox7QmHHo6HuT22A/Us/4SzJXH/BtuClxZgX/2Yg9zcymzf3MUghfCGmFgsf2qMZDGEt32yreevRcWNpp8m5uRlO9CtvBHv4BAubPH12gk853JtlqWCEhXc3I6X6yBHi9aZ0lkuf1VtY2dw/ak/pgb+7Nw0s2pW8LvWetWFCWBrOFHs5vhVDK95Id5zH/MB4EB895n381wvI3DxPySr6eZhcfMsTrxxbxlFeKPf3BI15j0cFhj1asQzjrKdlbW7PyP5gEyqVGQYeUH9k2IJQz6YJMs/WXZ79AcPObHJ4bKSNw+6/fZajx1ehWBebwBPtlvjnPP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(83380400001)(53546011)(54906003)(6506007)(316002)(86362001)(4326008)(31696002)(52116002)(31686004)(2906002)(66946007)(66476007)(66556008)(38100700002)(36756003)(508600001)(6486002)(8676002)(8936002)(2616005)(5660300002)(186003)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MitvL3FxeUJRTTlBQW9kb2xxbU9XK08zSmNMS0JON29INEZ4dE1paVcvLzFm?=
 =?utf-8?B?RWtMb21wMDhUamNxVHVKalB5UkJ2elNvbTgvSnJha1duczJDaE5pQ0JITzVR?=
 =?utf-8?B?Z2RINnR4UXhLd1hwTVI3VnVrZWFOYXgvWkUrdGNMdWdaSkp1WWoxZGtGZ0Fs?=
 =?utf-8?B?V2xaQ082ZFlVcW9lbWlhZ2x5NkpuemJNUG1zYzVWNEV6dnZpRllHZ21XU3RD?=
 =?utf-8?B?R05BVzdtOFg3eVE2K0ZXWEYxYUU0dUlNU2VDSVM1M3JVd0F4SnkxcHo4WjV6?=
 =?utf-8?B?eDdOcXcxWXBYUDc3cWFjS1doSmN0eStZSWFVdlRvdUw5UVN2dGc5Y200aVdi?=
 =?utf-8?B?UGhtNVZsSVEzUTVrc3JjTVBrWkRLbGRQVUhNVUJpUnc5L0tNZXlPZ3p5c1ov?=
 =?utf-8?B?NzZkWWpOeFRuc0w2V2lmdFgvUGwwcWNDcmFYTW4rN3NuaUh2Y3NIck9QL01V?=
 =?utf-8?B?cHQraDBRTkl5WWRGemJwUWhlRVhtQ1JmdGc2NVRLanUzdHVpYjg0NEt0bTJ6?=
 =?utf-8?B?N0g5VzlmN04rNGViOWhCN3E1MytudjRnQ29Xb3k4MTVteWNHL2k2eWhvckVW?=
 =?utf-8?B?enk1MXJ3Yk5PdkdMSkUwdGFqTWlzMjJVem9WdlVHdS9Ed1krR1BXSnNZTmpV?=
 =?utf-8?B?MEJXSnMvQ3NIdjhRZVpMc1VSdlhoa0U4QlJJUXMxY1QydjJKZ24rN28zK3R0?=
 =?utf-8?B?VzhkNXFjU0M5cDFHYzAvclNsTUZNYUZWdGZuQ01Kdno3b2pORFZPcGlKWmxz?=
 =?utf-8?B?ZEJSeThrbldMYXNxb2RJZ1RsWmJSRmFDcG4zeE9KS2dBT3JRSkhLYnRlS0JI?=
 =?utf-8?B?VFdQVXNtNHR0WDhHd0h3aEViUVNYNVpkaW9zM1A3dk9waEFiS0tKZlBKOFVM?=
 =?utf-8?B?dyt6bDhFb2pFdUFxbTlYWmp5Nnh3U2x6VDNqRCszakcrWmluNFlUeVdpZlJL?=
 =?utf-8?B?Qkt3ZU9qVDQ4OXVpUjEwV3dNQklXYWpJaFpCSW04bHZXZUN2a2lXOGVoOC9j?=
 =?utf-8?B?enZZMmdSdFZhb3g4aEs1ZWN2bTlHZFE3SEhwQk8ybVBobUQyay85ajdlMXhs?=
 =?utf-8?B?QkxqenlYRTU2TEkrQXRlc3F2aHJHZTc2RmhxMmJHYitkVmswMmV5NTdpaDBO?=
 =?utf-8?B?S3VienF5WWR6eVRmTUZaK2MxbmxPQlJjZnFZUkRmaDFxZUVwZk5ZWWRUR0Qz?=
 =?utf-8?B?Z2VTOG1ZZzUwVTNvaGhiNVBlT3hkSTY4KzhQM0Y0eVZPWFplT3JGd2ZIaUxV?=
 =?utf-8?B?NWl3NFZla0piZXhjVlUrL051TG43UU9PdjZ5RWxrcGVpekUrMHJoVFgrTHRP?=
 =?utf-8?B?dm9laFZNU2ttREJMNkZxTDYrQjYyZ0d6L2lHbzhGWThsTWJKWmE0b2Jxem11?=
 =?utf-8?B?ZWlKNVpkUVBNY2ZRNzVXMWlDaXJtWUdTazJ2S0t3SS80N3JyclZ2bmUxOFBj?=
 =?utf-8?B?ZkVvanYxbnpOaFBwQ2psZ1dZbE1PcTE1M0g1NHpGUnAvYm5zOEs1ck53VDdZ?=
 =?utf-8?B?anVNejBZaGVWYVdTN3JrSTgwOHc2ZDNRbmliZEJPa2w2aTdieVlYbEJQQmk0?=
 =?utf-8?B?aFdLVEpBbkw0Y1YwMDJSMUx3cGFrVlNoVzhrU2Rsc0RpSTJwTmJQdlo1MWRU?=
 =?utf-8?B?SWRLeGlvV3p1YjNocVEreW9UejYzZFczMlNOWmFuQ2RIbkUvQ0xiU3JGNk96?=
 =?utf-8?B?TXdlcW5OMTFjM0hRTHh2bEVicHZmQUwveTk0YW9GaUJqeHFxeld1bC9jTzlU?=
 =?utf-8?B?NjNPZGlyeGRsNms4REczcWV3YlA5VUxqRmkxcC81RXdoRTVpb2NGKzBJMGFZ?=
 =?utf-8?B?ZnhONjVNNnYrVWUrK3N6c0h4L2FTRmk1dWxYcS9WWEtkMHZqZ1ZmTXl5YTdl?=
 =?utf-8?B?YitFdU10dGNpakwzVS9pK1FFaENVclJtbnJQK2U5OE02am4xc25JWklxeE9V?=
 =?utf-8?B?Tk1jRzZEK3I2NlBpdU01SHVzTEU4SUp3VVFQKzdndjNkV3FRZG9uNUhic2wy?=
 =?utf-8?B?SHhBWVVKK1FMM2Z2SWJ0bWdCZktLUVUvVWdHbUFsLzh3TEw0Vkdna0p6b3dG?=
 =?utf-8?B?TW41UHpQNzcxQzZQWTEyelI4SFpVaWhXU0tIbkZjYjh1Y3BHZS96emlxc3FN?=
 =?utf-8?B?RnMrZHJhZ2sya2pMcGFDSWh3eGhRWTFGd2daQVNXdno1M1FkdU0vRnYwUThk?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d82fa6-532d-4016-4c16-08d9ea6ee95c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 19:20:33.3484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FrIiiGTAYjEHIAb6ckh5WxwSoNvHKXH+U4PcQ4p4iZNkmJXVgUzdJPVjycoVJAuc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2450
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: emVaYtiNDO-iHpzO9Oe698bmxEL4bb3H
X-Proofpoint-ORIG-GUID: emVaYtiNDO-iHpzO9Oe698bmxEL4bb3H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=981 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070116
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



On 2/7/22 5:14 AM, Jakub Sitnicki wrote:
> Extend the context access tests for sk_lookup prog to cover the surprising
> case of a 4-byte load from the remote_port field, where the expected value
> is actually shifted by 16 bits.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Acked-by: Yonghong Song <yhs@fb.com>

