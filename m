Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50E7205830
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732662AbgFWREQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:04:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40464 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728916AbgFWREQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:04:16 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NGoKhn011997;
        Tue, 23 Jun 2020 10:04:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lb8HKEkL0RkoZGG978Zxj1yfe3fQi3o9pH1ohou2bqk=;
 b=OLxnlLz4RcPFIw65TrRxfNkAQyehpaq1mV4goOjZG8XTcebo3S+1u11ZKPo6FZJDF2JL
 FmPw8TGB58QG6aOOXnkn72xiqJNaVZdJhtRqbohT6U7bAVB9Uzx45OR+L8DNRMdabBzm
 7knjVLRLxlKtsY6alXVdyKOOch73ZaCK/Ug= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk2ugy2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 10:04:01 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 10:04:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxW2Km1il90AYznw8dNu8gWr6CjU0D4WjTcvFErfWRWDKi8QTNHGe1IhTfGFhcez6hQTfrEAdUYh+y1wYTpgI0esrNmIZxkxxpFLnR+17la3fsXZMBNfkBHGtzi2t8xrLy0/iuBHCJBXKfUucuISlznncTAdQM/Sc9X074syTU3sLyFj3VuRd00Zuh02eR6AWySZoIkNqOFcg/Wlp6pDdsIofKQZzAA1x+ZQnG3KS7Nc5VZUj9lQ7iRajjnSXb3pa/TM0NIBmUf2k75uBK8n0KkeYSJY97fVxpHbzyDng20HcRGwcBvvt6CieoevbdrGbHhnJvDuhNE7GHRpIwLzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lb8HKEkL0RkoZGG978Zxj1yfe3fQi3o9pH1ohou2bqk=;
 b=bEwvwzr9QlaQ5+9bKI7Y7vL5CUNvhc7vTNrgardvpFKwjkSxKsKBr0/8HvFvZ9HBrwRyNK9rT7xFLiEpGIjMT6o/DC3hI0rDOZmME8BtSn/ac5rC/KxIIUSmVThJJhMkAwnC2tkOsG4N3wmUKT31rACglRclYskEOb+0DN3HJEKjIuH0rABMnMs2elxgZBGw367QzDImTCeG36jVc/uaQXn/R1UA92euQMRa//5rVmgOWP5EmLbxDJtHXSt6ooMhxGvRgMhT9BaqMyQD+MDYyxOn9+n5NvtJuFlTrDwrRyIWElvztYfGhoiaYyxfRqu6p2FbpkSwW1ckTe0j9Svj0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lb8HKEkL0RkoZGG978Zxj1yfe3fQi3o9pH1ohou2bqk=;
 b=eaZNB06Kq/nEBlLUMYuDglHlk2unwW7XhXhtaHiJXdcgrdtu80JgAsW+F6tjdtPnGz4YK3kdrdiWRvNxo9jkT56pcnOnsPWtEfiMrNvQoXWoLLZ5fknuzVIp5JQg4hW9Zz8A/KAAa1qQkH7RGtj89KMCPo0KqYRbp87AL+6nxPQ=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2728.namprd15.prod.outlook.com (2603:10b6:a03:14c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 17:03:57 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 17:03:57 +0000
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3e24b214-fc7e-d585-9c8d-98edd6202e70@fb.com>
Date:   Tue, 23 Jun 2020 10:03:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <37d6021e-1f93-259e-e90a-5cda7fddcb21@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:a03:40::48) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1377] (2620:10d:c090:400::5:7789) by BYAPR04CA0035.namprd04.prod.outlook.com (2603:10b6:a03:40::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 17:03:56 +0000
X-Originating-IP: [2620:10d:c090:400::5:7789]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb576977-8dcd-4661-d4e8-08d817976ac4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2728:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2728BECFD2BF122CBBF2EB3BD3940@BYAPR15MB2728.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NqkOVjQjoBtUTaMlDeJyKhJZWVxkAd8xVu5u4uq7RVCRJxcK2Q4diBKn/g/f3JtI+Fnr4MnBH/w8hFrBjwL3UddgM5gV+0ft2vpIQiOl307kYzvoQH121NHykIw6FRQXXP/T7vB15k+SMNVaA5KBwoMHSVijyw9F9QEuBBMvH9W9FWSZ5VL7lYp5ZzS1LSlWtqA3+qSq0YY7npu+iVQkJcoub/mExipFGhHxPsdW7uwRZn9ZffnuoFR4LaGltLOO8zlgLdc2conF/uFZgL3dNXU/dxR+p1i/iO2TbH6csKNitiUgynbG2gmk3ulklL0sKb9H8wsU27DOZ5I/XcY7edqASMwib2L75nt+ZyccUEbypupXP5I/6idm7WSlBCmc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(66946007)(4326008)(52116002)(2616005)(66476007)(66556008)(8676002)(36756003)(53546011)(86362001)(31686004)(83380400001)(478600001)(4744005)(6666004)(6486002)(16526019)(8936002)(2906002)(5660300002)(31696002)(186003)(54906003)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0pC8bpUvw3w8LtZRnXbdaptoeEi2DNwX4ZuP3nL6A86xSGRLOoQK6qqzYFUsqbV5yL/GWRjtNVBGC2oWhf0R8Uqs9geaLdwsUFxuxpR0ARjKPB5VPUdXFCb22xTSNiVCCVtxC9FYQo0ZbpBvBMEXucPj96fo20NWY7znZ7vpgR/jZ1WwH36vVBhM0kHNTpLouxgF4UrT/YGmE/pixZA6fAkJaaI/Bf0YMfM8p3HUt9HdG1CesvJobo/br453rhEXiMtnUHxTjVLeg2xzBkuIRdWY1BcFbS5+qKpHm6yHlcHqPkS29MvJKRUSHCZgeSByaTFkTh4ebljqevzqRv49xTgMF2jRYJcgcC4HVtNc9lyCw7Qs5DmKh8M/V8O6U1u3xt1ZOkIhas02aJprzfsJr8eSkh59opbQzzc9e1hmjokd5drvXa43tWpIIZd09sU/tXwn1epC5062x/8BNjUngo/nWGIE7WSbK5s4TKzRQ6or4SZnIDqdqlIbF3UDxWd6AQWGT/o7y5m9SOfO23vNlg==
X-MS-Exchange-CrossTenant-Network-Message-Id: bb576977-8dcd-4661-d4e8-08d817976ac4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 17:03:57.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xybrHpy2a1khnpmZNsOSZK5F3R+TtfVauJr9ZXKuM7Zy5AkE7D03tN3V0qEJ5nf7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2728
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_11:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=745
 bulkscore=0 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/20 9:27 AM, Eric Dumazet wrote:
> 
> 
> On 6/22/20 7:22 PM, Yonghong Song wrote:
>>
>>
>> On 6/22/20 6:47 PM, Eric Dumazet wrote:
> &
>>>
>>> Why is the sk_fullsock(sk) needed ?
>>
>> The parameter 'sk' could be a sock_common. That is why the
>> helper name bpf_skc_to_udp6_sock implies. The sock_common cannot
>> access sk_protocol, hence we requires sk_fullsock(sk) here.
>> Did I miss anything?
> 
> OK, if arbitrary sockets can land here, you need also to check sk_type

The current check is:
         if (sk_fullsock(sk) && sk->sk_protocol == IPPROTO_UDP &&
             sk->sk_family == AF_INET6)
                 return (unsigned long)sk;
it checks to ensure it is full socket, it is a ipv6 socket and then 
check protocol.

Are you suggesting to add the following check?
   sk->sk_type == SOCK_DGRAM

Not a networking expert. Maybe you can explain when we could have
protocol is IPPROTO_UDP and sk_type not SOCK_DGRAM?
