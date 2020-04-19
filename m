Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6EC1AF72F
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 07:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgDSFe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 01:34:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52828 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgDSFe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 01:34:57 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03J5TVi5005390;
        Sat, 18 Apr 2020 22:34:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EtitMwDevjpGCwJ+BkQFfpcOHCfdym8E8FJC1cE56CY=;
 b=iYAPw4BpvfWu/WIG2AC9wutAGOD6jJsyC8xpICTEZpZHRZiQoViaZCF/zaTNGJEYrMRI
 7KP0MpDyXVg3XYLtowOzeXDecplbxBImQBcthEa9UWILD/BG50PRsMIKw/IBuq+7pbdJ
 cuAqLzsYtBwLaiJbywTIEXfTBnmdqKKwkbs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30fy9nbd2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 18 Apr 2020 22:34:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 18 Apr 2020 22:34:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJ0Rfa7NMfqT1u4bxsmixgeXR7kMBzClxCizOth6Cumee0vYtQ/uaa5zd0p9lL4V0YLobg7zA22WVps1r5s51mvjPz+d+C2DvSCCUOeSvu4vL/d+YHRzaEXRsL4x3VZtrjrsbZ9SncdwS4VWe2wiFvYAWJXTGEAZ0gxe8H9htbZj1KqqXdM4nNLLriPTFWWOSy9DVOgkDykdMOtWyXUeljvqgZNsiqsXIPSqasEfMTkkNVjW3jdT5gG+YYlXFYp8EU5snayg3mFNhu2NEY1tMTYO+kGjaOUIJlZSt2cfX5haTfR9OwZDP9K5/K1vD7ZeYbU5JaGGHX5miQABc/MoAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtitMwDevjpGCwJ+BkQFfpcOHCfdym8E8FJC1cE56CY=;
 b=Uc/oLq/jAXy9WeSPVfskp9bwEfHtirAsG+vROTBEMa21BWaA0pjn9zxS27NLxXKlXnnJ62VM0DXi5VOqUsffHowmmou8V9zRpUwnQrnzTkRHezHrmhHViBEBeV6Ea4+FnaP2vD3tkS6prnWwpaNishnIxFvNJmKffOg1jyP1orWHOL/M7NIawFapWeyhML4bslZlDjCgOr6lpHgVuS81Nrpn36qU4WeM+MDi5ic+rYtid8mtY1owKlH5BM+K2Te9kauGtHnt7Lbe9pfpaiay5+6od7QLfAiGMQwSR/wBfl4I3qsxp/ctd08JlEPVumGl5dh+Lldos4pByBTUBytfPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtitMwDevjpGCwJ+BkQFfpcOHCfdym8E8FJC1cE56CY=;
 b=BH1gRM+2h8M0tsuXcKXGRkt6fEmyM1OxaAhfTcDgDj2d+SFUpSPsWU1a+o8XeJ8EeoaCLyyWnmc5iMnHKJ/3A2Feg1NCRR3VtQJRG/dTpEVukXUwuWfaHJVV/xXztooYHVHzLAhSnD4QF2n1Tqn6gwYQK6w2HkwzBDEdN/6bVH0=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3929.namprd15.prod.outlook.com (2603:10b6:303:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sun, 19 Apr
 2020 05:34:39 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075%7]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 05:34:39 +0000
Subject: Re: [RFC PATCH bpf-next v2 00/17] bpf: implement bpf based dumping of
 kernel data structures
To:     Alan Maguire <alan.maguire@oracle.com>
CC:     David Ahern <dsahern@gmail.com>, Andrii Nakryiko <andriin@fb.com>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
 <40e427e2-5b15-e9aa-e2cb-42dc1b53d047@gmail.com>
 <e9d56004-d595-a3ac-5b4c-e4507705a7c2@fb.com>
 <alpine.LRH.2.21.2004171518090.16765@localhost>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ae1cc2d9-bb25-a39c-5fc4-1e1a5b612e43@fb.com>
Date:   Sat, 18 Apr 2020 22:34:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <alpine.LRH.2.21.2004171518090.16765@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR18CA0064.namprd18.prod.outlook.com
 (2603:10b6:104:2::32) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wongal-imac.dhcp.thefacebook.com (2620:10d:c090:400::5:7ab3) by CO2PR18CA0064.namprd18.prod.outlook.com (2603:10b6:104:2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Sun, 19 Apr 2020 05:34:38 +0000
X-Originating-IP: [2620:10d:c090:400::5:7ab3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 928c5c29-bca3-4564-b58f-08d7e4235a81
X-MS-TrafficTypeDiagnostic: MW3PR15MB3929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB39295E39166C379581266E3AD3D70@MW3PR15MB3929.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(376002)(366004)(346002)(136003)(39860400002)(36756003)(8936002)(5660300002)(66946007)(66556008)(8676002)(66476007)(478600001)(81156014)(2906002)(54906003)(52116002)(31686004)(316002)(6916009)(31696002)(4326008)(53546011)(6506007)(6486002)(86362001)(16526019)(6512007)(2616005)(186003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTJzYhUyEZPRhi6vBsPTQ9i5dypIxcosM6WZtMtol/z9L/P0wJYjMTDjrye9EymhOegLa3Hx3WGPRfyB40T1mCFtZ3ZmhV1HnI7deKJRRYoWd1hZawz/vJO3Em1bC8lyJb+1TFHV45I5v2sippq2gAYzJ27fJyRqp4CRnCZAIUsj4s+Kyc7LKPjxnTnx9QKSf+l6OBog16XHtEbPuWRzm73qidqEXIgkOx+Le/0r00vQ8QCKmRJpQTTMMsDc8/m9X3jRcKRBJVJVfQkPKCqqY4fWgwADGACEhEjniRmWe0iBChvkYpYZUourBqZ/YFA27Uvq/yVHRERLLyluhNNEI0/Ttwlb6HJl7i4cw3T5/7WgE02EKc9X+aQ5dPs6ldju+ZCzcbQtcfYkj2YSp0AAVWEpY+nhqvvvtLFsj2oA5cdRWIqQvQtq+ig6uBCs3MIB
X-MS-Exchange-AntiSpam-MessageData: 2Dw7gClP33cIrGClel64HWbXRouNG1WSXU7QaPkDUtB42je1wUk05vEX8YyfQPACDpKnK8A38xfEsWx5zdveqeteBo/pzL8UcIupoVv0XBhY1d3rV5SZpgz2LiiSWrBTRSRmlc0M8II09Y8GkdvK0zTzrquCIk7DwCoMWMy1mg59TLqts1Y3Horz8vYM1mZSvGF5W0BY2XmUfW6lTubqHl6cTRfNB5TlOubBs9xiArwgqccZcr2ewCJCebX2Kp+FjaLeIN+bWCfsOgzxj8O+5JPictrV+7VrnnWObTHYa2CnFRe2QfXmo/irMoCNCNQIYbrF9jObJZOfVjAlve0otldcR18TcYVxewj5cxx0ORvRB9QRizeaRQNzd4Psn7+GC95Gbv494tbjKXSVWxUQ7J9e2gUvDnemXBUgMYRCbdUMsW/8y1NQJ1eLPzqVUr7klOtH7+p16wYwclmOGVEAkouRdR9eCkUuRi3Vm/Viy/9BjF5IvEjfgvkasVvRpLoXS4git2bYUA8xdPtwoXr0LqlvqZQyn4BEIDGpnQoePhNAFjVHUTg15XgF7b8nMlcitBs0bUAI81gyIjUzGaGv+QoWEz3xg5N6yEeIYr12UM7iQzKHEu4rpW28WvgsUeW60QIozbQnmOZAQzy9M0JYW3E1Uorw6OaMllko2fPKtwncWutvQdLMpKiC71mXeG9oMVdyr7sZMVFr+m6dCXHRaqfI2BF48GunEztrAz3pCArCNQeOamgh4C+w2LwTF5sdkB56zgbyOLnk/TSeWwbBxNBaEfNrsiulWeiPtDMAhEnoIx/nVl3diKQceF14bkPXeK1OCPqAtVklOiJsBoCEvg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 928c5c29-bca3-4564-b58f-08d7e4235a81
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2020 05:34:39.1673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mbMs+KY8HOqERsj05nz3scsC8T450VJIrbqjndYnjnt20X6rAVANiRig8tCbdABt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3929
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-18_10:2020-04-17,2020-04-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004190049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/20 8:02 AM, Alan Maguire wrote:
> On Wed, 15 Apr 2020, Yonghong Song wrote:
> 
>>
>>
>> On 4/15/20 7:23 PM, David Ahern wrote:
>>> On 4/15/20 1:27 PM, Yonghong Song wrote:
>>>>
>>>> As there are some discussions regarding to the kernel interface/steps to
>>>> create file/anonymous dumpers, I think it will be beneficial for
>>>> discussion with this work in progress.
>>>>
>>>> Motivation:
>>>>     The current way to dump kernel data structures mostly:
>>>>       1. /proc system
>>>>       2. various specific tools like "ss" which requires kernel support.
>>>>       3. drgn
>>>>     The dropback for the first two is that whenever you want to dump more,
>>>>     you
>>>>     need change the kernel. For example, Martin wants to dump socket local
>>>
>>> If kernel support is needed for bpfdump of kernel data structures, you
>>> are not really solving the kernel support problem. i.e., to dump
>>> ipv4_route's you need to modify the relevant proc show function.
>>
>> Yes, as mentioned two paragraphs below. kernel change is required.
>> The tradeoff is that this is a one-time investment. Once kernel change
>> is in place, printing new fields (in most cases except new fields
>> which need additional locks etc.) no need for kernel change any more.
>>
> 
> One thing I struggled with initially when reading the cover
> letter was understanding how BPF dumper programs get run.
> Patch 7 deals with that I think and the answer seems to be to
> create additional seq file infrastructure to the exisiting
> one which executes the BPF dumper programs where appropriate.
> Have I got this right? I guess more lightweight methods

Yes. The reason is that some data structures like bpf_map, task, or 
task/file do not have existing seq_ops infrastructure so I created
new ones to iterate them.

> such as instrumenting functions associated with an existing /proc
> dumper are a bit too messy?

We did use existing seq_ops from /proc/net/ipv6_route and 
/proc/net/netlink as an example. In the future, we will do 
/proc/net/tcp[6] and
/proc/net/udp[6] which will reuse existing seq_ops with slight 
modifications.
