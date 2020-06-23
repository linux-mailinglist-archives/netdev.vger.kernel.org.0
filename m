Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AA220676E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388176AbgFWWoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:44:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21134 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387815AbgFWWox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:44:53 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05NMiY4i013986;
        Tue, 23 Jun 2020 15:44:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TuQsk52d8K2HWD8umLX13P/1zlw/YYZ0WAbQMgALTBc=;
 b=cxa4qShZ3Sw5YwtSxDZhQpkp7hn86KnhPhzlxVRQtavobMbxGVXNPE7Z8ea5GZAB/JF2
 xScnwwAr5VckeFnHv3ikeoqA9iCJbgWK6xAcPW7JI0/biy1I47wwPUeHQLNlwUrMdefY
 IOS9wEbE828xb8a2kU50a/MRCBzQaZjKy2Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 31utrk00ap-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 15:44:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 15:44:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvdYEo0jKlHK8N4X7mMvqK2iCuFqnx4xqXiP9EnZ4MQ26TTI6bbao0bTymxManchmsPPjw2BtGEy3uZh84Nt+5jrSYaPifhjceDfNsHYnG+ryuZK9zZoRFjK9c2SgMmrEzTI29w7VHm1tJwtlqieesNag3Lt7886S8kYVrCrw1GvqgtZNul+Wks7oF1w4EbmVPbs2t7pCZ3WIVLy+CxzyUeHbvnwmfMpncWpQsEbPa5XQ7E/EmQ8FLg9maiXNNVW2roBeDkobeZaq3+pbXqrYVIhXzZbHp4CnIJynxxXTNf6be6dlwNuzS6VQoQkFnT/aNqT9enRROqrWiS/4+rhOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuQsk52d8K2HWD8umLX13P/1zlw/YYZ0WAbQMgALTBc=;
 b=Mk6Bhh7xZH/rDor9I+Dh+LAIQM7PpDMu0zX4bVlJp/CNB5gxqw+SJC7Syh2Z8erG6WLoyKRkzVHiU12Kd96GuBt5JMTXKvDUsarxudimle7bKyQTeRHDlMKRoZGVQ8Ftp7X88Dy0u9BV55v4pLPEySDB1VZPx2IKeaLU/bwl9LV/2kjIxRQSqHONV6SRIIP2jR6GfejICbUZAv7+jU0b6Ls8G0k3CvUb141GI1pDYHlHaz/GnSoUGviE/mnkdXH/I/0lUYj47yZinmDxezRRrKDTAIN1TivQHzZgZHmeVOX9xG5O5yZK9ru/0xH3UjJ4Y8Wtin8YG/VBCdBaOwSglg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuQsk52d8K2HWD8umLX13P/1zlw/YYZ0WAbQMgALTBc=;
 b=FbC4ZcPW96Tx9Ewkj9zxHekOZlCdN/qVD1UbR8Nwj/FaCR5RuKMf/hMq2BSLq5C4MICElbkv56qAl1fuECqZY1R6nncNEu2IQw/XyQQxjIxw8jneElzS9k+ks0PDIuuy1u/70oA50ZDflBkQFR65gcoaVowDxVyTIIPlagM6xQA=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 22:44:19 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 22:44:19 +0000
Subject: Re: [PATCH bpf-next v3 09/15] bpf: add bpf_skc_to_udp6_sock() helper
To:     Eric Dumazet <eric.dumazet@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003636.3074473-1-yhs@fb.com>
 <d0a594f6-bd83-bb48-01ce-bb960fdf8eb3@gmail.com>
 <a721817d-7382-f3d1-9cd0-7e6564b70f8b@fb.com>
 <37d6021e-1f93-259e-e90a-5cda7fddcb21@gmail.com>
 <3e24b214-fc7e-d585-9c8d-98edd6202e70@fb.com>
 <ca899dce-4eac-382d-538b-4cab1f5c249d@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <408b469e-a92c-5e72-a140-9bc381ca7301@fb.com>
Date:   Tue, 23 Jun 2020 15:44:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <ca899dce-4eac-382d-538b-4cab1f5c249d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0092.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1926] (2620:10d:c090:400::5:d956) by BYAPR05CA0092.namprd05.prod.outlook.com (2603:10b6:a03:e0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Tue, 23 Jun 2020 22:44:18 +0000
X-Originating-IP: [2620:10d:c090:400::5:d956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9beaccc-a604-498e-7c65-08d817c6f6eb
X-MS-TrafficTypeDiagnostic: BYAPR15MB2407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB24075E643CC8233071165FD3D3940@BYAPR15MB2407.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /L0rGnZBzS4xjpPRto8wxAQ9dA5JBaieRkcGzlyp2qFjrJ+7bSCaT00jI2eT3Tb/988RecdOK3dUABBzeYdT6gB3MZ15pHKmmIvtHb4Ez6Uwu6v3hgxZJ67FlVM4D44jp8q0HKe84PVBW5MxsHWe8KPBshqPSWkBj7UMmIg96yknGX52pciZLxQ9TUYmLfej0VcJtoqjILAY5qTvCXoCY2U7SlJdAkpD9rT08zhaTCUtdDGsSgqieZBhmyVDbbreLg6poRWA4YAN3ot9KDX99e/2M8/5Ckdkuxzu45FpboWdPzrMJhKnQ6KmLLereDHX7U2l/8s8nOzS2aOMRsI8SEdgfsfUI92wCFMQM4FzHA5ky8YXo04p1t2zOutuebMl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(346002)(396003)(39860400002)(366004)(86362001)(36756003)(31696002)(16526019)(2906002)(186003)(5660300002)(8936002)(8676002)(83380400001)(66946007)(66556008)(66476007)(2616005)(54906003)(52116002)(31686004)(53546011)(478600001)(4326008)(6486002)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rQsuUnGrMJT9CccheDPTBswlB3NYAFtqpl6uQqVySJ/OJnD2gp7ENeSIQJj7pFD0YQxXJTulPIDXL6b9qDPzyMtFkYYt/qq7/2SShhN/vMXUCTojS8QoRYgpi797FpH1e1GAV5xzpUE5eC2a1NfU8Q2hrJdoeeE8qAl6ZBBRuE58dpjKctDWmWHsIzVeX3sfO9zhaMJEphI00vhK0r3uS6VxAqzD6lMss1HMa/jSUvuhq2KM9JCrLPMNJsjeDhpHA5CmKJtFsmN1QXQGW3xh50IuRfEa/WyKOGBr4pcTcFSw5JFBJejcwr8SZuR0Anbmt21zmdhTYnIRqFSR/rQo9WO33CDFR7XuYFxTUVnTXXnS8Kiz+eZl7tHd0U+1r2BZh24qx0wJf8u3iZ7F/LrIWPY6wkbgLjEiXilNe5ty5pjLKygPCJvNkRnLM+2mVpa59Y3NogKpFfmcJE50I+tTvT3e39OdwoT+Ih7iCqNqJG+pTHpX/Zsz7kXU3sXanxr3TV7n/p4JFTxyEb1vTyOKSQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f9beaccc-a604-498e-7c65-08d817c6f6eb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 22:44:18.8545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOx3Rn7JXXWs8lA7zTOn91JH1QFQRgXB2u2yp2JVWvndOZJSObP9IkzNQ1YTZjE9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 impostorscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 cotscore=-2147483648 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/20 3:11 PM, Eric Dumazet wrote:
> 
> 
> On 6/23/20 10:03 AM, Yonghong Song wrote:
>>
>>
>> On 6/23/20 9:27 AM, Eric Dumazet wrote:
>>>
>>>
>>> On 6/22/20 7:22 PM, Yonghong Song wrote:
>>>>
>>>>
>>>> On 6/22/20 6:47 PM, Eric Dumazet wrote:
>>> &
>>>>>
>>>>> Why is the sk_fullsock(sk) needed ?
>>>>
>>>> The parameter 'sk' could be a sock_common. That is why the
>>>> helper name bpf_skc_to_udp6_sock implies. The sock_common cannot
>>>> access sk_protocol, hence we requires sk_fullsock(sk) here.
>>>> Did I miss anything?
>>>
>>> OK, if arbitrary sockets can land here, you need also to check sk_type
>>
>> The current check is:
>>          if (sk_fullsock(sk) && sk->sk_protocol == IPPROTO_UDP &&
>>              sk->sk_family == AF_INET6)
>>                  return (unsigned long)sk;
>> it checks to ensure it is full socket, it is a ipv6 socket and then check protocol.
>>
>> Are you suggesting to add the following check?
>>    sk->sk_type == SOCK_DGRAM
>>
>> Not a networking expert. Maybe you can explain when we could have
>> protocol is IPPROTO_UDP and sk_type not SOCK_DGRAM?
> 
> 
> RAW sockets for instance.
> 
> Look at :
> 
> commit 940ba14986657a50c15f694efca1beba31fa568f
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Tue Jan 21 23:17:14 2020 -0800
> 
>      gtp: make sure only SOCK_DGRAM UDP sockets are accepted
>      
>      A malicious user could use RAW sockets and fool
>      GTP using them as standard SOCK_DGRAM UDP sockets.

Thanks for the pointer! Will fix it in the next revision.
