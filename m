Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB04269DCA
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 07:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgIOF0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 01:26:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32858 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726057AbgIOFZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 01:25:59 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08F5Pikx021898;
        Mon, 14 Sep 2020 22:25:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nbtj69fpY9zuXu25bjC14rZw/iPip7vnA4xZIbxfnSQ=;
 b=XcmCAZ/g7Ox7KQrePV1lniVmXIXa1WnxADIsjOPgk7/r9N76H+9GBp5JSW+IyLou5D5w
 pNCPl71iEIulzMIDhF9+CrBGsn4yJPBTaVzxbjHLG/K9MN6zrrE0xZtAuCRcvqpRYlri
 rXfF2QvS4GvqKCtjJado7VDFlMz3zSp9X8Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33gstxxbmu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 22:25:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 22:25:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a59ThX9omlTRMWjZ4E2t2XNkoEmmNuk4S+LMTm3VHAcWLws4oFGDhVgNerfHb+dfIKZfOscCgPCc1YkE2q5JGLnVYzWX7Bef2cWq/qs9HXMsyjrT3FitPQwQaFAfzXykmTCH9qs6GweR56R7yxkW3TiPIp5d0wPw2pCc1aY6618HcOUEoJ/+YMfhv8W4vplSpNup+HBfV27tREjjbX1Vqbt7fereahDMxQ84D0tKB92afY2WlMZANbnbTvpLnxInoj7fW+pvwIwvn+dQRPXSnM9pcbVU4XBDmhdjLE3U22/IgNT4fE2cS+xwpG3kbwIFkkpZCAXHLLx24DyDbFtPgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbtj69fpY9zuXu25bjC14rZw/iPip7vnA4xZIbxfnSQ=;
 b=MEa3+Zd/5rzLpfL46hZ64i4XKTqTVnR65kmJpyVDIOhCHVx3PofM7nsZ9WoLKqRn4GWmJg4pd+W8irFUSTKLQvSL63DzAxYqvxIvviV05zLL45sXRqZRYx4Ph8atHHeWkURyyX3D0CiismTmUaw4oyFs6z2ahW7R3Bw5EObza4IR9+uUGJMA0AOky0FjYt9R2VEAUQFKoozp/QykudEYnkkroe0ne2tNCC5dXW5oCeO5L4ynLexc7jIWfp2ausEidVJLQ0oIJrs+FqK4GK6JJUwRRaD6c2dYIyxNI/lS2/qQ5DhcY0zCCXWAmQj2WRaYwrMV454CujzERFbfbyAWAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbtj69fpY9zuXu25bjC14rZw/iPip7vnA4xZIbxfnSQ=;
 b=JQBQimLQL3WJheU3YTdeU5L30YzWmRLH7UuD4hXVFA6Q+Gxz7DAPpY0fzzKZDwTCjOkIj7o0pmCSonlmVh3qoZIh+tBcPnyKiHokgPRnXK3GDVl98WHqfNjxwdkaFCrx8crnIJducsQafpe+rakLkY8Gcoyvt69bVri/fJ+I2d8=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2775.namprd15.prod.outlook.com (2603:10b6:a03:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 05:25:27 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 05:25:27 +0000
Subject: Re: [PATCH bpf-next] bpf: using rcu_read_lock for bpf_sk_storage_map
 iterator
To:     Song Liu <song@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200914184630.1048718-1-yhs@fb.com>
 <CAPhsuW6+kqJ+=+ssxdZ7+ZsCgiUC2rrLPZsWb6YdXEiN7ZhW9Q@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <86ee274b-a23c-25aa-6ec3-e1448667b6b4@fb.com>
Date:   Mon, 14 Sep 2020 22:25:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAPhsuW6+kqJ+=+ssxdZ7+ZsCgiUC2rrLPZsWb6YdXEiN7ZhW9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR22CA0063.namprd22.prod.outlook.com
 (2603:10b6:300:12a::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::19e4] (2620:10d:c090:400::5:ae1) by MWHPR22CA0063.namprd22.prod.outlook.com (2603:10b6:300:12a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 05:25:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:ae1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 227b14e3-1b3b-43bb-7ea2-08d85937c0c1
X-MS-TrafficTypeDiagnostic: BYAPR15MB2775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27754DE1C2927B2E0F15A937D3200@BYAPR15MB2775.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8CXIS3+A/qre1vuYV0pC8vTWCbQstkwdkG2Ms0mEQwfEkl0s4h48dkzpOy1XYMaXHX2dhtVTPOGwJot+uwBABOEK82lGpGOkb0lH5rjvql0cjxNyeN8saPts8pDtpYYETJMaDyIG/jTXXbeKw4ioDEVVWbKBXRZJtNnKqWpG/kqsyshlt8/rx6ONtF67C9yCtqTxieK0i+Q9X17BCem+f4u80NYg3wcW7PXc4rlNNIroF7+1I+NaRL9KgRHnwEY9JYQQHxCtX/0sbws4SbWxYdxdmOposEu2L+V6rB4U+tGWwS0MpWgwmBAOUZlsXjKM9b5ro07Ly91RIzb7j6xywq097Tmi7XmZ9L7mBvLTcHHIPBNPsnB6vpS6b/sQbzMtTpy2+DOxR5eDQO2Wg2SC2pZ8VeIbQ7zOohJkVYysD7jHM2FdeeVJQmbnPWmb3DZHa+3ryHIPslEFyp41/R0DB0u1SXlNvh+I8pVzTe+lS76Iwo0nz1Hw5Q63R1AbKGjU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(366004)(396003)(136003)(31696002)(86362001)(16526019)(36756003)(53546011)(8936002)(5660300002)(6486002)(4326008)(52116002)(66946007)(66476007)(66556008)(54906003)(2616005)(186003)(478600001)(83380400001)(8676002)(31686004)(6916009)(2906002)(966005)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Pbyd4AesyEmIv4JW4W7HADG1NyKQtV5p0ZeLwd4+QKf3CxMBsXisSDBJf83Y3003XZH5afhBxj4+Y//lGkH+X7JuZ9gtsL8bgNIppPP52YTUDdbNsP7KnFGWVZ1gB53+IJRbiNjLNPiCQzibXv+163GFH2mf/o91qK3CeKTfE+b69jvqDhCCgSUEeQqaAeoCY3o1mv0wrWaFsO+17CTwHiedDUCuewQB0VUFwItbR6n31EjgrIQDOIo7b620qDIFfhYK0GCc3U77t7viV9GOVjNGENfEQeLFTNDkDrg3lfnfO7ECNlDPIMz1v/7GKLQo9ww5aaEv2WwB7DSr+dl/44E5rZxrAsdzsbc9dw9IztyGK4q6Hm10wElgpnewAE+0DInGQ+rAaLCb/oUNPTWSXI8bt77hKNqBzMZMBFyfGEHrS4TgHNa2Np5IpFHrgB3KtYMZCqoZxUkaqpNVYXZWVISDIdlYxno+iK7q6NAS4gtAAB3viQwSWCGXU8pXpD82L/eM6ulk6rjx7mIDpzeH8MKM08Ge9Cd3F2FrvuFOBNOfiAPstwM6pRw5GzkxH+A3H++YDPOaGMgRGSXfg9443yvzOgw57np+Q5zjQdrNIxQSP1Pk2MOWTFYQzlxor875VXXHbEV7xoWMrzQPuhD/Y9poKoPgm4DSy5qdLsx3oFc=
X-MS-Exchange-CrossTenant-Network-Message-Id: 227b14e3-1b3b-43bb-7ea2-08d85937c0c1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 05:25:27.2780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5t/qpkWvyDstXFn7d/pOVEb60pHjhMvdpAKdapayHoap/f42VZ1/QK5gTDkKZErx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_04:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009150051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/20 2:28 PM, Song Liu wrote:
> On Mon, Sep 14, 2020 at 11:47 AM Yonghong Song <yhs@fb.com> wrote:
>>
>> Currently, we use bucket_lock when traversing bpf_sk_storage_map
>> elements. Since bpf_iter programs cannot use bpf_sk_storage_get()
>> and bpf_sk_storage_delete() helpers which may also grab bucket lock,
>> we do not have a deadlock issue which exists for hashmap when
>> using bucket_lock ([1]).
> 
> The paragraph above describes why we can use bucket_lock, which is more
> or less irrelevant to this change. Also, I am not sure why we refer to [1] here.

What I try to clarify here is unlike [1], we do not have bugs
with the current code.
But I guess no bugs is implicit so I probably do not need to say
anything. Will skip the above paragraph in the next revision.

> 
>>
>> If a bucket contains a lot of sockets, during bpf_iter traversing
>> a bucket, concurrent bpf_sk_storage_{get,delete}() may experience
>> some undesirable delays. Using rcu_read_lock() is a reasonable
> 
> It will be great to include some performance comparison.

Sure. Let me give some try to collect some statistics.

> 
>> compromise here. Although it may lose some precision, e.g.,
>> access stale sockets, but it will not hurt performance of other
>> bpf programs.
>>
>> [1] https://lore.kernel.org/bpf/20200902235341.2001534-1-yhs@fb.com
>>
>> Cc: Martin KaFai Lau <kafai@fb.com>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
> 
> Other than these,
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> [...]
> 
