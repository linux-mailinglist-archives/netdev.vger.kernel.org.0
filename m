Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5853F5BDAF2
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 05:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiITDky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 23:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiITDkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 23:40:52 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898E45A17F;
        Mon, 19 Sep 2022 20:40:51 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28JMsvlc016789;
        Mon, 19 Sep 2022 20:40:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2rfx8BQZnYcNYAfvbKBqoOLlOP/uNW9e9K6tgzRk4oE=;
 b=D5+zBaOSVwCZlD1hLVtbRYsNg7kl4NP5STKO8O+jSrHpBrZNMWrYMnqjN2O4EoXI5T7K
 lVXYjBgMlDyQaaONv7/IxrjX2e+A6rYLgaR0ACwQwWWYpm9P5EN/l1t6EhKXmjNp4Q0y
 CbzE8PjwT+40KuqtB2eJP2F8Yc1n42aJ6oE= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jnc2u00b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 20:40:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTx56AwONlhMrYVrK+5eEaZfnME4In8p4sCzMk1SXOFCFywboXBdNIv60poO4IJ2h1A/jJLdN2ub8O+YQ+08LyeW82VrZ9UMAQ3AoDjWE8xBiAsVdZeb65UfeScedbO03KgDxWfUyM+Nk5o7cCFWA2HBgZ8v0mU/mXV9n7Mf60yqepeKQmt4eHZc5jYqnrJwJCXinC07vvjkha5CD9ivTxVAexfXWkdAAwSwEgH2LeaJJTQJdzDjPcitYDi8YpaYmK5n53U4zWiyGnZozso5ZNoIMpmZAe5P0cugknFDp/g4EBnndPKTWAkY25qNEx224aEGI29Mwq27ZXzDXZw2tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rfx8BQZnYcNYAfvbKBqoOLlOP/uNW9e9K6tgzRk4oE=;
 b=gW4/DnCgX2z9OKH23R4d7oT06Vso0S0AfM8OWA3XkU0rsTvdNy8aGiXXC5sg35ENx7kyaZ3Ty3wKJE6ECqgd6ia8uQy3zuWusFJ/JzDLlun0KAPJtJ0ZF0w7KCT92qVUkaLvuDVnX1vW2N3LDmdTZVuKiDhRgAKVem/RkALoL1e4NFb2SjwZHCwLBhaW4moaw/yPUe4upNect/clkFwXb/XDa0c79LbvXXSWszm4XnWgZXvNrgYzdAIT98pHlDCDHhaFqs86y68icVYSyYaCYwVyRP429It+eaPpGeDyPJPy1dqn+E/p1s2xaCW2ewJsvULfmi83R4YAobraM+dUmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN2PR15MB3615.namprd15.prod.outlook.com (2603:10b6:208:1ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 03:40:32 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::cdbe:b85f:3620:2dff]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::cdbe:b85f:3620:2dff%4]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 03:40:31 +0000
Message-ID: <d4ef24e4-0bbb-3d24-e033-e3935d791fb9@fb.com>
Date:   Mon, 19 Sep 2022 20:40:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v2] libbpf: Support raw btf placed in the default path
Content-Language: en-US
To:     Tao Chen <chentao.kernel@linux.alibaba.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3f59fb5a345d2e4f10e16fe9e35fbc4c03ecaa3e.1662999860.git.chentao.kernel@linux.alibaba.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <3f59fb5a345d2e4f10e16fe9e35fbc4c03ecaa3e.1662999860.git.chentao.kernel@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0065.namprd20.prod.outlook.com
 (2603:10b6:208:235::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|MN2PR15MB3615:EE_
X-MS-Office365-Filtering-Correlation-Id: c2f08fdb-e32e-4587-1ff9-08da9ab9de5b
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PANqNlzuN+XFUf4FkAAravjGSWU86lSyuNaeQUUr6XYfByqIHsCIA5R9xWmbL8KIbS0oorkfngpf5Hlr2ZBVvWyhS2oBHMpGP9zRY9npqAxNNMGOnXYMz9whoc3hPayfBs99DmCaReGMrA3b8NUEiEdPXbAIKq+6ZicaMMkbNl3uYQyMwqeQ/sofKK8bCUKgoMhzXseNHMQJ1r5Tsap7wbGGOSGVy+xJXIjbBSLfXEBZ/+1s2AYbvkR+p6qM4XXt46R7rUtCUJMIIgO/hHA3Mut/6rzFMBLPyK+i0RefI2cefZk10C6s6kxJFggxLlSOSk2p+Mjp5QcUnHynmLLGJ8WHBBdqLmxGSfrKimGSYBm9a8VSwin5akuODtm+JuJlthIcqaLKTTVlTdbQxZpn31G1CjNPU4VZMCPL2LLZXl36A6IaBjqqXuON1ZNzV5ESGqwRqV5aDD+8fMcsI7slMDXzlPP6a8mFps97S/gQ0j9sX1/lFpvO7BzqgXZco4+DBZRrG7BGD5Ovsy6mtPHVKv3+HmRuzT5oekuMrEhPS2i+q0YMceoMUSKtSFOBCPlkWdMnV3ynJcL/ChAxz7OJzazOPg5jWJlGoSGBjDfYDKQVHy5SuI1s4DOukJ3wtMHoNKX+wrEuRFK4bi6qBpzEW4Ac6FsN8cJLDTxNfE9gl3UxO2DrOJ+Buf1jPwzxx/XwC/KFgOM8vVa8jWPzrws93cwURV0Lm5wtijUrcArXYYcpfPt7321W4M4vPB/PVZ7+KZPbq3vJgq636NFyWDuktb4iP6IqM87n2uqBcG4w6aw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199015)(316002)(31696002)(110136005)(4326008)(8676002)(66476007)(66556008)(66946007)(83380400001)(86362001)(53546011)(6666004)(6506007)(6512007)(186003)(36756003)(2616005)(6486002)(38100700002)(478600001)(8936002)(5660300002)(4744005)(31686004)(2906002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXFleXY3bDc3dDNtVHpiZzEzNEtoUkpUcjJVN21ncjlETTZNN2FKZVIxanl6?=
 =?utf-8?B?VUx2TXNjMWdYaWR0RUgwWGRFYjU5cHFDN213aDh3bnZWZHplNTljN1V1aG9L?=
 =?utf-8?B?S3A1OXdtbmhJNSt4RzFoVWVnOG1nTWxtNjRudmFIZ0M3RmgrMGdudlV2K1JW?=
 =?utf-8?B?RXQvMnhyV2x2RTFFYzRBMU5WZFltVVFqWDB4K1VsQ2tlWXVKcUs1Z0dZVDR4?=
 =?utf-8?B?aW1mTjB5bXpRSTk4ZUxDZVRFRWFwR3drczViUEo5TTBHa09FNDlzVmt3VkQ5?=
 =?utf-8?B?b2c2MlI2M2lYYldDYWdtWU1PaXJNZDJhQ0E4eU5ZVExhWlpycEJYNmx6cC8x?=
 =?utf-8?B?dDdvZmcza0hLTUE3RGx1UEdLZWtCcjBPVWhGblUybS9GeXhNTjM1eDlidEVH?=
 =?utf-8?B?VEo2dkxadDdRNkhEZ2JBekVNMEV4M1N4VXJhVVlaQkNGaVNKRmJueEVJTnpQ?=
 =?utf-8?B?SjUydFVySCt0ZjlHaVEyMW8rVGNEbWVTWW5NenlOTHNnWFJ5cTlxSzVkWmNQ?=
 =?utf-8?B?bm5RaStjaEgzZGdOeFNjYnUwSzhwdmsrN0FvbUkzbGdLSldFbVF5M1VQcmx5?=
 =?utf-8?B?Q2pNdFA0SithVkZIQWQzSUU5QXI5SE9wK21iR25sWDE4L2xCRFBOdk1nRHJq?=
 =?utf-8?B?blhYWXVCVEtEMGxtaUR6RWQ0LzFwSFRBU2F2aFpJdHkrUHBnTGZEVG9LcVRn?=
 =?utf-8?B?aVhzcW9sKzhldERCblZhc1FWcEM2SGFDT1hQYllVY1JNL0F5ZFNtcDB3dDJl?=
 =?utf-8?B?ak1UVmlGd1JCaDgwOVY0RVg4WEltSU9EcGwyL1ljWXh0WVAwUHFBSzlhcTd3?=
 =?utf-8?B?TzN2aDB6U25kdjZJdXlsVXNhdFJjUDNjeE5qelhIQjdFSTFnWmxQd28rQUVp?=
 =?utf-8?B?L3RIU0JRc0Rwb25RRWhnWGZIcFFUV2lkYWhJSnBaKyt1MjBoQzNxaTQ4WGgr?=
 =?utf-8?B?YXQzKzQrTkdSd2VsQlM0ZGQzSUtHd0hGY0pYQmNxeFdDVFZLSzhlWVVmVmdn?=
 =?utf-8?B?QVhKbGo1VVR2VVdONmM2bWE2V0pldVZKNEJCMUlLR2RkdFFyOTZWQlZNUyta?=
 =?utf-8?B?VkVtdStDZ2xqbTZRZ1krb0VBRkRNZ1ovQXpLUUNIWERpZlJjMGhqMFBoK3VI?=
 =?utf-8?B?ZUZHcDBQSjNIcGhhM1JtN1VMNURZK2hhSXRRUTJVZkdFSytiOExiU2dGSXRh?=
 =?utf-8?B?ZUhzY1JyVEJnV1cxZ3ZZcHBiZW5FM0NHUjFRMGQxN0FrMHI3L0pFbXAxZURD?=
 =?utf-8?B?SkcwdVQrTGlWQ0NIZ1BUbXNnVCtPY0IxM0hoVkt6TnIvZmVWbHFDbUgrV0dr?=
 =?utf-8?B?MEovUEprcVVhUDAyV0E0c0Z3OUZkN2ZEOVJFTHlIWFRoVWp1eEVCckJld0pr?=
 =?utf-8?B?MExYNVhZcWZjNEFZOFpPY0VhQ1FzNzZyY0ZBWSs1bnJNdkdvRGZXejl0SFNL?=
 =?utf-8?B?YnRmOVJCNWlLOWNzRGVhOWJ1N1BvMVkvMjBYdW1QSnZaTFM2WjhkVDQ4T1li?=
 =?utf-8?B?OUpHcGQvdXQ0WEw3M1M0SXNPQ24xa3p5MVhzbEhtUTAzWFA3bTBJZzN4VE9P?=
 =?utf-8?B?bkJIL3B0dGhCeTJtNnNvV0x2WkVrenl1Y0tOejFLR2pMd2NrV1UvZlBRd0hU?=
 =?utf-8?B?anpEU3QrQTNLYUhxSndTNnNyN3RWMEdhbHZrTU91ZEFxb1lnNFpzQUlYaEtu?=
 =?utf-8?B?TG9HcS91aUNjNnFjMGVPMHpKclFRVjY4ZHpNNzdYcXdNTFFyc2U0RDRjZ0FJ?=
 =?utf-8?B?QUFJVnMzWStUcnNxSFV2SHBLWFVtZU1wUjJKWjREZy83R1JiUUFRS2tKd1E2?=
 =?utf-8?B?MXJqVkdOMGJLQmp1T05vYXZvOXphaFljZ2tvMzVBWnh0dHBSQTB3RGhzK2hJ?=
 =?utf-8?B?QkFKNHRwK0RpSVpVbDBzcklPbFhHVzMzYTdTaEFGT0hiZ3gvcVJhQXEyVUly?=
 =?utf-8?B?enFjeEtvMkk1QU1IRUVYODJtNjBRSTIyYzVsbzJXSDdQbldsaCs0b09FZ3la?=
 =?utf-8?B?OTZUbFMzblRyUFFCcmhKTkFvVG05SDNkNDJJbFZzQVBhc1pJR094RXZDRlMz?=
 =?utf-8?B?NzAvZXBMZ0tZb3Jtd293R1g5empTWkRJZ2hGUkNPR1FBZjBWemZ3Rm45TFJK?=
 =?utf-8?Q?lck7X4MEfjqiMbQ1hBJAyv8hc?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f08fdb-e32e-4587-1ff9-08da9ab9de5b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 03:40:31.8050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cawxt/WdnBmASW2cFX8LYZyfQDfoEPPsHBIXE0bbabOpyTCiEx4GDwHNrEpfAI6M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3615
X-Proofpoint-GUID: IwZGs8Wr0hgG2rfO6nJyWnnzit6tj5LG
X-Proofpoint-ORIG-GUID: IwZGs8Wr0hgG2rfO6nJyWnnzit6tj5LG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_05,2022-09-16_01,2022-06-22_01
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/22 9:43 AM, Tao Chen wrote:
> Now only elf btf can be placed in the default path(/boot), raw
> btf should also can be there.

There are more default paths than just /boot. Also some grammer
issues in the above like 'should also can be'.

Maybe the commit message can be changed like below.

Currently, the default vmlinux files at '/boot/vmlinux-*',
'/lib/modules/*/vmlinux-*' etc. are parsed with 'btf__parse_elf'
to extract BTF. It is possible that these files are actually
raw BTF files similar to /sys/kernel/btf/vmlinux. So parse
these files with 'btf__parse' which tries both raw format and
ELF format.

It would be great if you can add more information on why
'/boot/vmlinux-*' or '/lib/modules/*/vmlinux-*' might be
a raw BTF file in your system.

> 
> Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>

Ack with some commit message changes in the above.

Acked-by: Yonghong Song <yhs@fb.com>
