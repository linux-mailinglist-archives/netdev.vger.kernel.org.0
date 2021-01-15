Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6649B2F7198
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732923AbhAOE2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:28:41 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbhAOE2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 23:28:39 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10F4PupQ002758;
        Thu, 14 Jan 2021 20:27:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xDLqjJd8lLT3zeJTgi1c678YEvW1uEPACAzYOw/s6pQ=;
 b=WdeMw91qhQXO5MTPpYiNmeiW5ybJUE8FCpc1eXRJMG3YTcpKkfK6N5IR4OqSV3gDv+jq
 LeIUDJ/qk21jdJudCm6WZ7ZbqMwszJxovSn2e8eI7VRFgrKl+On6xvI24K/a1aWN68j+
 22BOUM8/eBBO9u2x3Fe3ZzBhYJlw0vIUxJU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 362tcc2m4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Jan 2021 20:27:42 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 14 Jan 2021 20:27:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGBK5HnvFWsqNQ6NylgNJpjUlSCLBVYGLPVUzUTHQuxQ3zjGEOuAYNWKhcs/YyVwlKl3k97z7XdPzQlLy8W1qntPRP1xx9a8s6GpMWCU2qkm7NHft6r6P14Jq+QJDkdSyChd+FFLIG+C4PL+NgkuujlI6PZ/R1ZZRgmtfnGbk6tI4avyyTU8eH5z5VvoVaJ7rHMflaYmJ8WJoxIJfEtBSasC8AAHh46leF/fW3xZU8Q6xDpIyVGbinlTD3tkxWvJ/LTOdlih3u4WtXFB/373oUuhjVf9quv53dujJFvXElBkYWC9IxFU14wdd9FxrnCILfx+AiuWxv4QJRz2FEqySg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDLqjJd8lLT3zeJTgi1c678YEvW1uEPACAzYOw/s6pQ=;
 b=Ds9mgmSG8ePcgBunRziaA8KLkAp35lW81WqlAxY4P2G+qmYPOWjuzPTzrw04+0+X+24FlssQ2Ui6pNykGQzxCWeMtVBmMejyx4TYNwIfLbd2aKhfi5w3SqEww++AIW12bnAjHLOjFvU2lLMQNRMcejkE8QmDrRMt0IwbtQF9oNYFv9POADSlfYcdR+q4ib3kE8jKnVy+3w8J3KxbORMNVp5WVjuR+hKtfQq75HpI6/+o9kgr9z4rUt9KQh3RIMv/9VWFg23JbMeI5Nw/YDKQsvA704WL3Hu/NL2Ly8ai+jfmQcViP3xA3Beu/wUDvI4oQsWsYL7vXZ23bmxnnBPLzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDLqjJd8lLT3zeJTgi1c678YEvW1uEPACAzYOw/s6pQ=;
 b=hY0iqx4gAFCz/xEihqpyd8iQ0wwfV9B2WGnTbzPpONSkSRr57DMcQXcKXDUzhSR0fVJlLvdPXUkHD0JmSaRT3GV7DZ6S4LUdpKlbEwI4uRMBPT7jlG2mWNm/9DLUo6ucdbhXtcAW53kbkWeIYhBZgj0Nwi0x+csz/pIxa3XSxUw=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by SJ0PR15MB4233.namprd15.prod.outlook.com (2603:10b6:a03:2ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 04:27:39 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:27:39 +0000
Subject: Re: [RPC PATCH bpf-next] bpf: implement new
 BPF_CGROUP_INET_SOCK_POST_CONNECT
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <1627e0f688c7de7fe291b09c524c7fbb55cfe367.1610669653.git.sdf@google.com>
 <CAEf4BzZOt-VZPwHZ4uGxG_mZYb7NX3wJv1UiAnnt3+dOSkkqtA@mail.gmail.com>
 <CAKH8qBuvbRa0qSbYBqJ0cz5vcQ-8XQA8k6B4FS-TNE1QUEnH8Q@mail.gmail.com>
 <CAADnVQJwOteRbJuZXhbkexBYp2Sr2R9KxgTF4xEw16KmCuH1sQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <500e4d8b-6ed0-92a5-a5ef-9477766be3e4@fb.com>
Date:   Thu, 14 Jan 2021 20:27:36 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <CAADnVQJwOteRbJuZXhbkexBYp2Sr2R9KxgTF4xEw16KmCuH1sQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:d459]
X-ClientProxiedBy: MWHPR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:300:13d::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:d459) by MWHPR20CA0022.namprd20.prod.outlook.com (2603:10b6:300:13d::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Fri, 15 Jan 2021 04:27:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f17b94a9-1423-4a4b-3e6a-08d8b90de4b9
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4233:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB42335705259F62B89A983F77D3A70@SJ0PR15MB4233.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vu1m7Qtsu5XiwkXDerb1IwgfimIb+8qktjDDxAcdpd0UhC9OcXLthyKkCrX98VXOu74lbN4cHfz6D/YL4IbSxn4JrFokYgmBAdDvl9h+wGq5whU/vW79UCuT3lw2WS5UtDcmwyt2/9s8FRyDcAqDgnSvQ0vUNOlel0kd+eGOyEq0Mu/ZxoPMpbPrB2h6YqEa96unIa5pB20M9SmROc3Lkn681uSaoFCHN6qO0Rdl+8FQRw0z6JrqeiFJ3QzTcZsCa9HLOD9HXK6e3G3CrzOmZJGA9nRvS4VxkRHNZCSs90lxPmDw8KOUwcefh+96hoQ1A7tlcwpYaeoNsLYhFx2HxJQEGJ5eph+pQDvXYA/0LPa43DCUkOp5mX78UpgypOBJVEBqNF9BC1PO2FVud0bR2y8dRvTGS27j9yL/XXW5hcDT/eX13UIVplfghivN+4nrsHZD0rH+3BpYon/aJxHwhDdjjZu+c619fAl2jYgHm9A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(346002)(366004)(396003)(31686004)(6666004)(186003)(36756003)(16526019)(5660300002)(2616005)(83380400001)(52116002)(316002)(66476007)(110136005)(66556008)(53546011)(54906003)(8936002)(31696002)(86362001)(4326008)(478600001)(2906002)(8676002)(6486002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Zk1hK1NIMmlvS254cGhqWHBpd09qVmowa1A1SzJ0bVNxcWdKMWN5MnJEbG5v?=
 =?utf-8?B?QkgvZ3pQaDdFRHhGSWZSYWhmRXh0TjFaTjhqek9NTE1XM1RTZmJEcmNhWjJz?=
 =?utf-8?B?SHhaTC85UEwycEVDa3pLeXliY3NJc2pFY0lWSEt1U3dWVWlZaVdOM0pOenlm?=
 =?utf-8?B?UUFiK3lrUTBCQWxGd0ZsTDY5QU4zOUhsS1ZFc1o3TVIrVkQrY1RObWRYNngw?=
 =?utf-8?B?VHFxc3J0OE9nL1UyYXVja3FhS21DQURzcnBtYTU5dExWTXJ2Vm9kQ2tyLzlX?=
 =?utf-8?B?UGt3T2dRTmVLV01OZ1huS29OQ2U3d0VScGJmcnhLOW1qZkZXNzkrWkpweWFt?=
 =?utf-8?B?YkloK1QrZWlkNVFlTHdnbDhoaW5hZE5aZjUrUGxScVcrK0wxajVFSTA4ZjAr?=
 =?utf-8?B?NzNqeXpGa3pMQ3p5QmFncG8zYUlTWGx6bHpkQlJDMnd2R0k2REFWYlJnTHNU?=
 =?utf-8?B?QzNQK0RlU3ZnMVB5OS80T1ZoWFNhQjlFdzRTWEQzVFVCTUNHZ1lpQjFWZXdz?=
 =?utf-8?B?YWlRTFZ4TzVKenlhanI1c1hmK0ZFeGVjZUwvbW8xSlMzTU8xSXdGRDFkMzF4?=
 =?utf-8?B?dTFMTkd6djl0eU4wQ1dJcnFkTy8yai9uNVR2QU9wVEs5MWpoSldjN2o4bDRJ?=
 =?utf-8?B?VmpaWFBLL09OZVYxMzMyUmRFSEFXblVUUXkwVXZFR2lHVDlOWlZxNlNEVHdR?=
 =?utf-8?B?YndRdVh4SzBMRWM5U2k3ZE45ZTJiejllbloxZ0V5UDZnREpYVFowR1l5cGdS?=
 =?utf-8?B?bmJFUU9Td0FUS1A5aVBrTm54R3dsZ0h1NjVFdjR1V0RPd09nRmNvYzVkYVpU?=
 =?utf-8?B?OGhzTTIzQWpXeVBUVVBtaHVPNkhCbUs5czZTcXBiT09yZG5zaEFuVi9PVFRt?=
 =?utf-8?B?dFA4MnhFdVJIMlFGbnF4b3BXRHJVNjMvbFRnWkRnUHBQem56TXVzbk1LTGQy?=
 =?utf-8?B?NzN4SHNaQ1FaSElZQVp2T2JYMzhlKzQ5TkpVZWdnbGR4RDZQdk56aHg1SWNy?=
 =?utf-8?B?NjVCaVF6ZlhXYXVBWlBxekZ2YUNqM09DY24zUnZlaDZ5Y285Ukt5TU5KZGZ3?=
 =?utf-8?B?MVRvMStTZ2pML3J4THdTOXJFazVBdW82YWNHVHo1a0VQdFAyMk00Q09zYlB1?=
 =?utf-8?B?VXgrdmhSaEVmaEFPSFVNY0pEMXo1d3V4bG9kcHZBVmVtbWtaNWU2cU5ZTS9S?=
 =?utf-8?B?Und5dS9zZEpsajQ2eHVRb2Z6QzEwWEtqUzcxZzdlWWgwNzB3TGpuNHVhQ0ZG?=
 =?utf-8?B?Ky9Ubktia3NIYysvUnNPVldsbjg2S0d5OGpGTWNMTUJ3TExFczFPWEdsZzQ5?=
 =?utf-8?B?QXZzMkxFb2xIMXpzRnVtUjhjcUZReWFOdEwxb2lmRERxZ0hsUGwxRzcvUVZ3?=
 =?utf-8?B?VURTenNsWU01eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f17b94a9-1423-4a4b-3e6a-08d8b90de4b9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:27:39.8792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKk7WUDnUydczXlXjCBFLzGwjGs0soxyiwt0PMIFkNTrrzMPgMo+Lv6vBYA7Yo04
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4233
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_01:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=784 impostorscore=0
 clxscore=1011 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/21 7:59 PM, Alexei Starovoitov wrote:
> On Thu, Jan 14, 2021 at 7:51 PM Stanislav Fomichev <sdf@google.com> wrote:
>>>>
>>>>          lock_sock(sock->sk);
>>>>          err = __inet_stream_connect(sock, uaddr, addr_len, flags, 0);
>>>
>>> Similarly here, attaching fexit to __inet_stream_connect would execute
>>> your BPF program at exactly the same time (and then you can check for
>>> err value).
>>>
>>> Or the point here is to have a more "stable" BPF program type?
>> Good suggestion, I can try to play with it, I think it should give me
>> all the info I need (I only need sock).
>> But yeah, I'd rather prefer a stable interface against stable
>> __sk_buff, but maybe fexit will also work.
> 
> Maybe we can add an extension to fentry/fexit that are cgroup scoped?
> I think this will solve many such cases.

Currently, google is pushing LTO build of the kernel. If this happens,
it is possible one global function in one file (say a.c) might be
inlined into another file (say b.c). So in this particular case,
if the global function is inlined, fentry/fexit approach might be
missing some cases? We could mark certain *special purpose* function
as non-inline, but not sure whether this is scalable or not.

