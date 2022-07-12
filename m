Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7367457188B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiGLLar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiGLLao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:30:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9D420F61;
        Tue, 12 Jul 2022 04:30:42 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CA2nfd027964;
        Tue, 12 Jul 2022 11:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VFoJb4L56Js3MJo2FaoD9xgMIgtEdp22V7xokcIKrdw=;
 b=Kct4dBEUw2KuVTGawoAq3WNOsN83bIxnXLNPSNMKa240MwX34dR7l2D6C40R4LmuX3Jf
 0QF3SgqrVjLJbl6w9R25J3unRf6LATM606OZa78WHl9u1fI1oNDUxgD3tBSla/hd5gGe
 DiEyqROfF7BfgHUY7ALznSykqyAJUBh7JmmO/TkVz8YA4fEf7+OB87/I6o/w2NC3EP6i
 WfleQHWAGCuBz/nwDMDhK88aY467ai2S4rCFWNEt8YEOo1UBxnLmCOPsOhB71OaSeTze
 7druwn5wQUn9Ha9mXixVqnr8TfjFWnUg886fQTyCyJFZ23qpSTlzSnfItK8mI7H1CuKH NQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71rfxe1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 11:30:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26CBAA6x025747;
        Tue, 12 Jul 2022 11:30:11 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7043h5ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 11:30:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSvIjMbvizdiUDqOKvBeo9FCp7scKk4e8hStNv8gzgj5L9n3KpuzuL3g7FeWTaDEWMRu79COfY8SngP1cEOZtU1LHxyPGIZnEbb+3S/8KZsa5p7SVD4X5TM5JYdOzeZnPUsyh7eLlAdyQbJ0Ag4xhyCdBgWcYjpgtaf50leKwkUKcEVTiFiTz7gVmF+mkBA93fOZx2UOEDbSsBh5FvQJIuZVabKY0UF29w3+hyIO1Ya48qO+4FjCJrSqsQqooDc2OqpCgMaMTeORTekmr+oyBkTuJwGV5XmzLSVYT4UZzCF/FY71CxG+F5J5rquGAoXFayWKQH7u765pMci3IibPxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFoJb4L56Js3MJo2FaoD9xgMIgtEdp22V7xokcIKrdw=;
 b=bypMalIieX6KvCR67UHHsQH5opL1ijYghv+cw4m3GsThvGTD34Vkmj5LTXL+0wKDLXgjIdWdG5uXUN7vj+FIDqaOaLFdQZMkI5v+ioUxHrVYvaIiqRtqYW34fhRjHqWZ7H2bQlSJQQC8JPe170o8g4J53iioqxh00DClctmly9bO5iSL0Nelj0rMQkLAP5slGCrEMTWbCoXjiUJQ7Ry0D3MZNnTh3ujxNJVB/4ndJXzm2DArMFjy/n2+0ZmFKMmsUAdWIilgTYUW8RbotIHXI6orYSgkWMZ9hcyHknohD2lYKf0yf3NtBw9GsnzQRksZnqyjFobOvsmbMBD1DqhcOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFoJb4L56Js3MJo2FaoD9xgMIgtEdp22V7xokcIKrdw=;
 b=0FfZerOygaU3+C7azKw1vOa7AYtm18fBUDMvkpMeBkVoXV71tQ6hKN9BSIEewYrrZ+ZzFZHGiLt2siZYy50sN3v+bKR5/QRAeM6QWrF/lMEelLBeqA12ETTNRORpn7EtN9W09swS2oDA2hQjuHsdxLbrkS9qYA5Fge/EV4j8xRw=
Received: from BYAPR10MB2888.namprd10.prod.outlook.com (2603:10b6:a03:88::32)
 by SJ0PR10MB5408.namprd10.prod.outlook.com (2603:10b6:a03:3ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Tue, 12 Jul
 2022 11:30:08 +0000
Received: from BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::b5ee:262a:b151:2fdd]) by BYAPR10MB2888.namprd10.prod.outlook.com
 ([fe80::b5ee:262a:b151:2fdd%4]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 11:30:08 +0000
From:   "Jose E. Marchesi" <jose.marchesi@oracle.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        James Hilliard <james.hilliard1@gmail.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Subject: Re: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
References: <20220706172814.169274-1-james.hilliard1@gmail.com>
        <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com>
        <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
        <CAEf4BzYwRyXG1zE5BK1ZXmxLh+ZPU0=yQhNhpqr0JmfNA30tdQ@mail.gmail.com>
        <a443a6f9-fd6f-d283-ce00-68d72b40539d@isovalent.com>
Date:   Tue, 12 Jul 2022 13:29:58 +0200
In-Reply-To: <a443a6f9-fd6f-d283-ce00-68d72b40539d@isovalent.com> (Quentin
        Monnet's message of "Tue, 12 Jul 2022 10:48:20 +0100")
Message-ID: <87r12q6021.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0502CA0039.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::16) To BYAPR10MB2888.namprd10.prod.outlook.com
 (2603:10b6:a03:88::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c20a30e-6090-4055-f415-08da63f9e036
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5408:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBCWpVbW8J/r9VoL7HUTTK4vGdcdsac9dIh43mW0X7hNxm8T09pB7lAUjX/2upsBS2ZyJTL7J9ceFvbIRMWu2OHD1FtdnMIDhpvIIXLABXTqEIoa7U7BwJviw2oH4qapbDuA5FfGrW4NF2MG4yqB30qaRR7hn5KKZNdJMOHg8SeRzcvvT3EZ/noAkg4mSgtS4QvndTPQ6QTbHPbcWWLu89u2Wf+OxhUq+wlI4q0DuAgSFD/C8Hv+Kgnd2uC9ZQfZx0t5OOFraalGeLVL1wvGU1FnFGqyDYs6u0tyFYwzUmnFgk+cWggSNH2yt6XjDWAWfbZ6IvD/cDdTTGa5lK4/KvzztjyjWm0+qA9x+eXY2w4Fsq0/tb8C9COMLOR4b6RwgWm9EVZgxNXGKv+gdWH3QHagUTwC2TbA+f3bS1ff7nGh20vD5OXy6mFhuqKg5/6jAwAAUaByuk2NCSlue6n5+nJ7iNQoxVUezxdxRCIUtNCxLnnLfrhGoG/aj3pC9vPHbdGEGZj6xV5ngycMcRfyrhpUvK4TgeoTALdBO11NlHZafj+1dCPJk8teL+H16ERLKlfiFRaaeJc7apLuX7LMHx+tEIDyff8JZE/6C63K/rE8squcR7TBk5WZyRLpDdd7031pch58BGZgC9nCOmAYrTIE6gN6lEThkD3eVxcMlnMp+Wi0rMfh0ay5dUKn1f5CoUiBWh5deN6Z/tJvHY2BUr6la4ilc5u4Q4uyEb93shrrRvyyUEaQl8sG7UXBzivdq6tZCwQ5FW3geRsyuP2m3Y7sVMHiVnN+H2wpFTiu9W0GRrS1NqDOcNilv5w6ebnJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2888.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(39860400002)(346002)(366004)(376002)(4326008)(8676002)(26005)(66556008)(66476007)(38350700002)(66946007)(5660300002)(53546011)(478600001)(6512007)(38100700002)(52116002)(86362001)(8936002)(2616005)(316002)(41300700001)(6666004)(7416002)(54906003)(6916009)(2906002)(36756003)(83380400001)(186003)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k+NvVQxq7eIdQWp6K6QsNeABXCoprLByxlYtz8QYGuefwGY7EIP4cHQckjN5?=
 =?us-ascii?Q?VYsQ/p254l1q0gD0eZS5eo1Jb+I5cFhKSx9adbsEx6TWQ2SYqTm4/9AYi6lD?=
 =?us-ascii?Q?Qu0o76cawXv9TXDggu3ZUYRpF+L5yz+p7ExJh1L/WI0H0PbTjIEMM6vxndwy?=
 =?us-ascii?Q?E5I9r+0EZB/3v2rkF+o2O7bLmk5EwCQEZ5GLKadihiQ+Yl6jDJSoCMiAYo4J?=
 =?us-ascii?Q?kUF5v2xbIcn1/sAImOx5GY25yYfj/hb/xDdcLYqs1sxUBCdhXiIghtDGte0r?=
 =?us-ascii?Q?RPWFWVD9vot8LF0u6pZCKVlHI7px5JEbNROJ4sp9ZkYL5mIXwKCnWqQunV2K?=
 =?us-ascii?Q?gOBNz9m9+FIoIuTF20uj8h9+Tchdigwankgk+fuPcKhDq0P7n6sZ56ItzIjt?=
 =?us-ascii?Q?Fqy0bEqiqnxppmY/DDZEUZltd2lsii0Q8ZDtYKuHAlvojbaSMbxbRYI6jlYx?=
 =?us-ascii?Q?CjUx3vLYVq9nNdEZLqA5rCCLE8N1aVHXJhZdTVpjvgOfjh0CYt5ZssHx/gW9?=
 =?us-ascii?Q?m9JVLGXTYIr5yyccN5OBvfqBeJqI1A/GB8U/BMv4S1kd335YXDOcu9EyrIxV?=
 =?us-ascii?Q?wym/FkF/2qbWJrARF9aIA/m26eH8ebX4FbWysTaMTIPZL8r0T9qZL80UQhtV?=
 =?us-ascii?Q?uWaEBPfvV2p44vmAniCiAyC/TV2d1p7XcTASHvhKuuWXynvfok0dTA5oWulN?=
 =?us-ascii?Q?xRBz5s5OyXDxbzst6YZa4aHSgXd2xP9/Np6ai5/70rz8Z/TT292BRx9v0uC1?=
 =?us-ascii?Q?ABCGWBN6eIeRImuxd0+KtrsjAld2PKMaVtpXkisg3u79ImFQh5kvi/VklOPa?=
 =?us-ascii?Q?jkkL1Hj9k6+ZfdRFxuRQEqmTkIcr/ATKM9edOg5gf6Po9+cuJgS5PTgSAUWd?=
 =?us-ascii?Q?l/T2ONjDgRGKCdMYd0Hb9ZbA2bLOcaqaIccz50oMAi63KF47hxIgMnI4XOhv?=
 =?us-ascii?Q?hf+jiR+kBNAzgbzBsA4t8DXmZ0ckS0i1qZ6LjlEcTKwX9uD3UTO49opyjXsG?=
 =?us-ascii?Q?hcHC5r14RaCO4ARtF7saWCmpvZ985tRMNZttXmSdcgWMh/c4c5E5gAbGaVxE?=
 =?us-ascii?Q?Qea3SXAm83MrOy2z4T2HRHxomPbrfwmBwNaN2fEe8/6gy5sG2rSn2qoJ0Nm8?=
 =?us-ascii?Q?HiXoILLsEM+U7DUomBxtVpbDMS9x9660eW3AClOiWgjrwgaZUkhHFJ1Dtk2q?=
 =?us-ascii?Q?nrZlY2BPQon6qco+8FM28FuNPmL0yGOI7Ks7KrLbqqoACfy4ARUrX+LuwwoR?=
 =?us-ascii?Q?C/5paTpPctYEbRuBxtkZoKwk5ALblHB8RSjrU+Rcs+sGfMzZVSFmeQzammqp?=
 =?us-ascii?Q?QBFWgQ6LGdqAC9rEFBMIsL/HZ6D7dXf8bYzJZPTvKh2LIA/Lv1kEdWY1z5Mv?=
 =?us-ascii?Q?Ja2fOVaxifofKI54BN0+DnxpIytL1zpqJaRESBz69/PVqleUkP6mI+heVUxY?=
 =?us-ascii?Q?yuIWbm0sBnO1kZIxiMAFH10ip+Q+eSehnyGBgYMZljXJHCESCnvtEL8oZX+C?=
 =?us-ascii?Q?TT0DKpwCHKbOb7ebF7niE3xSpGwQ3U3OJY+F0wu6m4RRmlnBZio0wCwsmU58?=
 =?us-ascii?Q?JqGeywbjzkNGHQdCi46AtLCrHY8FKqUF1X+su9MLoJAN23SdWBs2IFHJ8caG?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c20a30e-6090-4055-f415-08da63f9e036
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2888.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 11:30:08.7144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdrpLFmQYWhRFmJBpry8a1rWTabRHQFT0No7ZjkbgdNdQuLEoyWhSQRcnUbaECm5ICs2J3tOmuopZrSJrdZpV4zW7SrHzlxoCimPlSthocE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5408
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_08:2022-07-12,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=819
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120043
X-Proofpoint-GUID: 3M2MMJiVcky8xhOIZb3Z7500hYO3v00Z
X-Proofpoint-ORIG-GUID: 3M2MMJiVcky8xhOIZb3Z7500hYO3v00Z
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 12/07/2022 05:40, Andrii Nakryiko wrote:
>> CC Quentin as well
>> 
>> On Mon, Jul 11, 2022 at 5:11 PM James Hilliard
>> <james.hilliard1@gmail.com> wrote:
>>>
>>> On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 7/6/22 10:28 AM, James Hilliard wrote:
>>>>> The current bpf_helper_defs.h helpers are llvm specific and don't work
>>>>> correctly with gcc.
>>>>>
>>>>> GCC appears to required kernel helper funcs to have the following
>>>>> attribute set: __attribute__((kernel_helper(NUM)))
>>>>>
>>>>> Generate gcc compatible headers based on the format in bpf-helpers.h.
>>>>>
>>>>> This adds conditional blocks for GCC while leaving clang codepaths
>>>>> unchanged, for example:
>>>>>       #if __GNUC__ && !__clang__
>>>>>       void *bpf_map_lookup_elem(void *map, const void *key)
>>>>> __attribute__((kernel_helper(1)));
>>>>>       #else
>>>>>       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
>>>>>       #endif
>>>>
>>>> It does look like that gcc kernel_helper attribute is better than
>>>> '(void *) 1' style. The original clang uses '(void *) 1' style is
>>>> just for simplicity.
>>>
>>> Isn't the original style going to be needed for backwards compatibility with
>>> older clang versions for a while?
>> 
>> I'm curious, is there any added benefit to having this special
>> kernel_helper attribute vs what we did in Clang for a long time? Did
>> GCC do it just to be different and require workarounds like this or
>> there was some technical benefit to this?
>> 
>> This duplication of definitions with #if for each one looks really
>> awful, IMO. I'd rather have a macro invocation like below (or
>> something along those lines) for each helper:
>> 
>> BPF_HELPER_DEF(2, void *, bpf_map_update_elem, void *map, const void
>> *key, const void *value, __u64 flags);
>> 
>> And then define BPF_HELPER_DEF() once based on whether it's Clang or GCC.
>
> Hi, for what it's worth I agree with Andrii, I would rather avoid the
> #if/else/endif and dual definition for each helper in the header, using
> a macro should keep it more readable indeed. The existing one
> (BPF_HELPER(return_type, name, args, id)) can likely be adapted.
>
> Also I note that contrarily to clang's helpers, you don't declare GCC's
> as "static" (although I'm not sure of the effect of declaring them
> static in this case).

That's because in the clang line bpf_map_lookup_elem is a static
variable, a pointer to a function type, initialized to 1.

On the other hand, in the GCC line bpf_map_lookup_elem is just a normal
function declaration.  No variable, and thus no need for `static'.

>
> Thanks,
> Quentin
