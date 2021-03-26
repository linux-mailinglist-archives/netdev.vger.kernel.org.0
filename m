Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B5134A98C
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 15:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCZOUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 10:20:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45276 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230170AbhCZOUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 10:20:46 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12QEFi2q019027;
        Fri, 26 Mar 2021 07:20:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aHLvo+8xkjBFHmv0fBsufwDhMuuH6FcCjTpV+4n6PnM=;
 b=nBstRxj5kKnxVaxJaH0mCRZ9cOkRK83f5cj5QnCKTaRNxXH2hX5QqY2CXBApIZiOGCol
 6iD4S0GocmKfFnT/wj6R3BaDsoT24fdxsQdEW4i2kaDvmfW/Gk3MlFlvKmWf1goocOxn
 pZc+g8tkf+tDm+9bHv65Zo8TV+dqlY/YAJk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37h11v4btc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Mar 2021 07:20:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 26 Mar 2021 07:20:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHd8pwh8VXCInAGuWVUkwXPCYZ7UJFIx/CGZPf5MIBzVFCKarM945rXBQiLPDERkBxOwbzsxVuwdFGwP+qbBjEFxce3z1tOVAtL+GY0YUxzHQGCeKb9iR11iMIK7QXu7xNxxvxFFjhlI+VFSlgJRBJa7xnu4d8zrv5g2OhVy5C26FNnUiaugND10ozxARV1Zft9oKyx8aUXtZuipZ+C/+wU2/rS4vqhreKt6TzIhtvguoVefi6ev/X64LBLYnjb6Fu3T946iA4beIlueTEk1nr66o9vsit0jXJGzSAjtfG5Qd+mv64DujcjVuxAR27AVTypwsCMqAJY7eY99INwkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHLvo+8xkjBFHmv0fBsufwDhMuuH6FcCjTpV+4n6PnM=;
 b=X3NWaer7qae/sj28turDTNer74kiiAoft4NMsCBRRwehYP+yk+/g2QODysMIr92fWkhpmetYw+m8JsimHqKecE38tDzz4CIj7xGrZZf5cxqYSrOVLSrDTGA196OA37qrT8v5QEFzgzY12ks3Ki+AEZaETYzcySVsrCZn+0TwsIGQnhh+GJACy6frKggQGDEcIfSkaH/HnqEP5fv3FAZhSoTo4+CB3pQRh/uEVlhy8GfAsHq8aUVulCdoQpArGNMK4m/AFIh0hYvX1b1bYcv4dH1pAkwaaO1L3CyYhRB6u5BsRxSAGdNn7DpakK3ozmCEhwlgsJX4i2zfGNIVkz/TbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN6PR15MB1588.namprd15.prod.outlook.com (2603:10b6:404:c7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 14:20:29 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40%3]) with mapi id 15.20.3933.038; Fri, 26 Mar 2021
 14:20:29 +0000
Subject: Re: [PATCH v2 bpf-next 03/14] bpf: Support bpf program calling kernel
 function
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
References: <20210325015124.1543397-1-kafai@fb.com>
 <20210325015142.1544736-1-kafai@fb.com> <87wntudh8w.fsf@toke.dk>
 <20210325230940.2pequmyzwzv65sub@kafai-mbp.dhcp.thefacebook.com>
 <87ft0icjhe.fsf@toke.dk>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <22ef1556-cebf-e1c9-8a83-251c08a1b465@fb.com>
Date:   Fri, 26 Mar 2021 07:20:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <87ft0icjhe.fsf@toke.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:3ee5]
X-ClientProxiedBy: MWHPR20CA0004.namprd20.prod.outlook.com
 (2603:10b6:300:13d::14) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:3ee5) by MWHPR20CA0004.namprd20.prod.outlook.com (2603:10b6:300:13d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Fri, 26 Mar 2021 14:20:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 721f4eb3-d5f5-44ac-0143-08d8f0624ea2
X-MS-TrafficTypeDiagnostic: BN6PR15MB1588:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR15MB1588A41BBD71BAE5821ED55FD7619@BN6PR15MB1588.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zffqIsoXCIZWQ0XvUF5rto/Uat+wSk8ITzJhK0vVGkgmiJAtINZK3EdOVQ6CXEBBYQdFBVQ1BPLJxQ3UaKNUhmTZ356HtyUXpmxbZgy5qXXWE+/3wMkooTeBTB6vdYCS3LY73dTSPBQzsBh6iM86CZ8TwleJL3NHgk8aOE1V1+uMnJUrC2npt1cr71dSYOmUUcM4Anyc/nlay/CSVVjY+4KHIY5qst1Z7rpeBa/OD4yFfVa0l3Jy6eUNPR7IGcN1FTo+yWs9UGOBAxUwM9LpL+vUMgenDaUXHdg/fQAd6AeaVeUKvfQBQcyuWI3ZZzrHbgcjEZUmbZAuS1+f7AlNxpAxBV9ry1gpGiys/l+m7toRbxBs2ZWyyVetoP0g7yZaWoE74N5DryNJ/1if84qIhRbVMYcNCnhJr1+scKOLIF65LEy0YqzN5Bh/9ofr5Nr9hX9CSYebKasQmj2mIgiK/2N9YJQ8WHMk8DL75UQ1gOm4q1+E7rYY5KFFTbIwqHQZiEbW4vWdTI1CsIm/DSBuQyBZpuoQS7fUuvhfftzq4zudcxZMcXxb8TKoLGKWarBNTVdNwCRO9y+2GlDHmEbS0ZcFFVf5HkabUh8DFbgERkB7CnrQk9y+dqOIcFiZmSQ0TJ1UULYVJ3xrHMcpk8Zrkj5aYjQtjfC6lLyIll3JK4pQeRGcIsmS1UqpHgFdoY1/ofsStARxKHVEC8UYz0uZeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(366004)(376002)(52116002)(66574015)(36756003)(83380400001)(16526019)(66946007)(316002)(186003)(54906003)(110136005)(2616005)(5660300002)(53546011)(478600001)(6636002)(38100700001)(8676002)(4326008)(31696002)(31686004)(6666004)(2906002)(66476007)(6486002)(66556008)(8936002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VFFOaGhURzhybzM3NGIvQ0ZrREpuNFdHN09KK1dPVlFVR2JmVnhSZHkyYnNK?=
 =?utf-8?B?T0RqYmxmM3cvcW9XeS9KVjBqVDROK3gvcC9hblRCendLTWZDcStldnYrVHF5?=
 =?utf-8?B?dm9wWUlmY0ZVZ3RCUW05ay9lN3ZoeUUydnJSMk0zQmVmQXdVN0s3Tko1WWUz?=
 =?utf-8?B?NkxrSHNVbVBBbHlXUmZmOFJJYnc0M1E3T1VnVVJPN0FUMzd5eE51L3l0ZUgy?=
 =?utf-8?B?ZWg0RXYwdEdoMnVtRDRHUTJhR2J6Tmw3aHJmdVV6QXR2MW9LaFI1VkpGMGtz?=
 =?utf-8?B?UDhKU3RYMjhYZHh4Tmp0T1ZJMkI4bDhXVXdDYUpjOWZWRlcrMWwvT1VPakN2?=
 =?utf-8?B?dHJldFpKRTZxdFdzYXpCbEgxT1h5Y2tDaFR6OUJhWWhWNUlNMWJoYUFwVlp2?=
 =?utf-8?B?aUlodjRzUks3NEhEeTdMVHoyRXR2aG4vK1VCQURtcGg5bzQ0eWZyMUVtYUFQ?=
 =?utf-8?B?QXdVT0kzTFlEdk1YYXVkbThPLzNHcE9JblBvWVpoaFpFL01oV0pBTFZVczBB?=
 =?utf-8?B?cTBkSzBYbEh4eEViZGRVODg0VVlDcUdLLzFUeDFaUmdxdU9nOXNkK0RkdXJI?=
 =?utf-8?B?TkY2Ny84U1d1c2JEeXRCeVRvUnVBY3pmOU1tWGo0ajVNNytDcGJ4K2t4Nms4?=
 =?utf-8?B?aTUrR2VjYm96TEpmeDkxNnlGM3BBdlZuU1dNMFZsTHFvdmxxdUprSnRpbHlh?=
 =?utf-8?B?d1N5dENNbGpLdlJ1Y3lac0hXemoraFc2anhLNEh1SjhDejZTdXVZT0NpakdB?=
 =?utf-8?B?RnIyNnNDM1hFZDFQWHNYVVhMTDZnazlCMUhBMHUwOXM3L28zaUN6SXdaTU9r?=
 =?utf-8?B?RW5XVnB5eWkyMXdiZ3VadDIvWlVrNkJkbGNZZGJCNnhPeGM0Tk1oTENQWTlP?=
 =?utf-8?B?dGRZK3J4dDV0QmhmTGJVeU4xVnRCZ1VMYjlwN3h6TDhQZTZGQ3U1MUI2SXQv?=
 =?utf-8?B?SWQwdU1CZkk0TmxKZUFDMHJ6NHhLK3U2RTYwamFZK1U2TFNrZmpMdEpBWHZp?=
 =?utf-8?B?b1FBRkZySms2RkRhQzY4dkZJK0dyVnYyems4ZEg2eEZIbUp2VWZPVnFPR0w5?=
 =?utf-8?B?R294eTZJTjY3cEFsT2J3NWZPZkg2dFdoZ050ZGJyOWQxdVF1ZUlzZ2wwbzcr?=
 =?utf-8?B?TmJzUm04RUQ2OWFWdFovY1J1VHJZS2dJK21PUlhObDNvakc2ZzlrWjA2UWQ3?=
 =?utf-8?B?dXZWNFRHMThmbEI5K0F0cWlqa0NUVnNSTFNmNUtDWDhlSG8zQXRSY2hmbGxK?=
 =?utf-8?B?VTN1elRpL3hFUHl4L0FXK01pek4xQ00xZlRqeGRMUU1aVzYvTXBxNW1veU15?=
 =?utf-8?B?UUJYcnNHUDJSVkZzbGh1RTU2Tk13YTFUWXJOUk0wUTFIeEdSLzZ6dVZnQTJi?=
 =?utf-8?B?OWg4SzhZdE9YV3RsUXdhS0hrR3h1WjJqZWdaZE53M3MrTm1lVWluMHdiNUZB?=
 =?utf-8?B?dHIvU3YvYkZQSVQveHFrclJYaGYvV0hZYkgzbFhsQlkxYmovTjhyMkx6TnB3?=
 =?utf-8?B?OWxROXozV2xNcmx1OCtPKy85YTVydDJEYTl5RUxaZXBvdzVLd2lxNExFYS9S?=
 =?utf-8?B?UEVON2xjTmxTUkNwTmszMWQvUFlCTVQzdWFzY2txby9TTVV1cHNIVHlkK3ha?=
 =?utf-8?B?OThxcWZGYzh4WjB2b1psUlJQOWVDV2FsWnBQN2NPRGx2djNOZVRmMzRrWjhT?=
 =?utf-8?B?eGllK3lWdUpGVVREc2JyWmFGZUVVVkFJT1FocGZUcmVPUTg3MnMzM0tSdmlS?=
 =?utf-8?B?YU8vVXQ2MTMwYU9PUFc4RDVtRHFSbTNhSDFQbHZyNloxdSsvaFphbnhxaktj?=
 =?utf-8?B?UEdzVTVKdFFUVzVNNUErUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 721f4eb3-d5f5-44ac-0143-08d8f0624ea2
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 14:20:29.4293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mlSTMlNxUUtowwtHYYNiIXU6xBRWcEnr9cize6ETJ78/hLm78I0BeUa/a1mPS++w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1588
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: VWqoCiGVdl3FN2l_WhnYbkHiAMy9g04B
X-Proofpoint-ORIG-GUID: VWqoCiGVdl3FN2l_WhnYbkHiAMy9g04B
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_06:2021-03-26,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 impostorscore=0
 mlxlogscore=834 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103260109
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/21 3:11 AM, Toke Høiland-Jørgensen wrote:
> Martin KaFai Lau <kafai@fb.com> writes:
> 
>> On Thu, Mar 25, 2021 at 11:02:23PM +0100, Toke Høiland-Jørgensen wrote:
>>> Martin KaFai Lau <kafai@fb.com> writes:
>>>
>>>> This patch adds support to BPF verifier to allow bpf program calling
>>>> kernel function directly.
>>>
>>> Hi Martin
>>>
>>> This is exciting stuff! :)
>>>
>>> Just one quick question about this:
>>>
>>>> [ For the future calling function-in-kernel-module support, an array
>>>>    of module btf_fds can be passed at the load time and insn->off
>>>>    can be used to index into this array. ]
>>>
>>> Is adding the support for extending this to modules also on your radar,
>>> or is this more of an "in case someone needs it" comment? :)
>>
>> It is in my list.  I don't mind someone beats me to it though
>> if he/she has an immediate use case. ;)
> 
> Noted ;)
> No promises though, and at the rate you're going you may just get there
> first. I'll be sure to ping you if I do start on this so we avoid
> duplicating effort!

That's great!
Curious what use cases you have in mind?
