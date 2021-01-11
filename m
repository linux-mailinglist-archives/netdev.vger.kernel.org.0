Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F652F1D9B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390278AbhAKSJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:09:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12510 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389957AbhAKSJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:09:49 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10BI2rbG016769;
        Mon, 11 Jan 2021 10:08:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QnXXRNqpkL8HFmSJ517POhlI81LMXAeZmZzhJq3bNeQ=;
 b=XtuYkXiWYJ5idJQ/PyXupa8VevCol56lqrQVvs5J9zarhLL0mJvhSnsjOrxpBPYk4d7I
 X9I8zJpEAgO4RqYOeRuyJd4WduJeI5Kl09vn6hiEi8ZIH6AWRT6M815A7cwcilC7Fh4b
 lEdUZDBorV2lbXRgYGoP3+JVWsYCeCZtctk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35y91rs137-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 10:08:53 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 10:08:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFFFmZwEBezxREuiH6MiKLGB0HyBH0rbFMCl9nB5wy6fq1JSpAEdrAXiHrZKO8yptJxuthiNNpgFGfI1W3y7ET/VZarW8XX/lrkAZ+laEEIxDWXxaP193Od5eemojXZcytPyUGDrOK34LACPB2JfPdRYuovvDwEJ2a89y2zsXq82tMRFifCYm794Qdz0gX0iEpdqpTN8PMPXPHwEi9WO3L6UjGpNgXIZgPJM5xWbSu3pCmqa05r0ic92H7WnJjO6pBR8sHNj2CGPwsCjXmVepn04u3LJJGXpdLBFZFjLPQ1Cq16bzZ124pPd6FdSkdspD/SAJwqp2XuYSt47sH/prA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnXXRNqpkL8HFmSJ517POhlI81LMXAeZmZzhJq3bNeQ=;
 b=keYsuOvTzhSfp1rzhH+aDeI+fr63rx6o83iDT/eWQcjVisPVmf8WQg7kRfr7Ax2JSYt5q88KIc2dW+xapLtIeJvagxzJrap0iNGU729eh57XjAqhVnOockHuKfbAQZWSg2WYlSsiktdiMXqMoKUtHgwkn0P4WU5sZ8eXN8duLN7PMErEMOHM8m9INQKcC3LsiiBci0sYgVhXUTtnzpkfsP1kK0/X8BqDIHUJ8UFZNfDq6ktxpLO0aP7f73E+iihXn9Phs3Tr/ZmqWNiWjYJ5BXGuM4y6Jy6d33Z3yNAh381vXpq8CQeNce//V1ymBd6hWKBgCf3NlPw1TW+xxf/ZQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnXXRNqpkL8HFmSJ517POhlI81LMXAeZmZzhJq3bNeQ=;
 b=YKTyskE2oXuL9fdrMp8kUfG3Jwc3AYUkZouPm9w0QD26Q9Hd4YyALwpod0AeStYkU8kepMiQd5ZIj/j7HgBPx48B6MybfMI97hvetsnWMLfqKZ88NTJdo6ivHTdaQUjJyboWziDJBlfc8eoMxIiceQfPL7w8hwZsVdJpT19WMR8=
Authentication-Results: kode54.net; dkim=none (message not signed)
 header.d=none;kode54.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.8; Mon, 11 Jan
 2021 18:08:49 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 18:08:49 +0000
Subject: Re: [PATCH bpf 1/2] bpf: allow empty module BTFs
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>,
        Christopher William Snowhill <chris@kode54.net>
References: <20210110070341.1380086-1-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <baa7ef89-9540-e8e6-34d7-786125afce57@fb.com>
Date:   Mon, 11 Jan 2021 10:08:46 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210110070341.1380086-1-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: MW4PR04CA0195.namprd04.prod.outlook.com
 (2603:10b6:303:86::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by MW4PR04CA0195.namprd04.prod.outlook.com (2603:10b6:303:86::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 18:08:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe2f8616-88ab-44e7-e569-08d8b65bf215
X-MS-TrafficTypeDiagnostic: BYAPR15MB2455:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB24554B84B09DF651F14C7AE0D3AB0@BYAPR15MB2455.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W5m7IrnAv1Xjfem3c8M8oa/xcqPMFANv59ND57PKjLr6+OZBwFFo3ObIcNI7YaqnPWxzkGqeWjReHhRy5I5+wNVIyzh+Bt/tXnaMSHHMxgdN5S/ZiU2f3pvhj/LMivYGfzfvKPUf+L+klEfvnQJOfrQF3WUujKZxJbDDl1e0puxat+YZxLDFs13bUpijX/gx/7xzKLfT3JK0uIES+bTssQY/3Y4qE9z4bKfd+euUhFneLRnhkVFuJePsB8BLnXMQ4k8vYUTD9c+7YIjcLvI5+D5QzcE5PfeX/fvmBW+mUXZWPL+uHxhu4r+CmHHJHsoA+Q/guyCttqjMdD9i4G5PJ0LAaxDmfMPMXGiyKXjFag+5BCjr3K5OjLhd9w+wJrkTXJ55znlzWEYW6GpXna4t5kgzr48XstujYqi/bb8TRGFX3ZdCcGjewU/+Uto0607Rf3WjU7S20TNKg/oi4PVliAxrKIBb1xOJ/YI9q+yU5UM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39860400002)(316002)(83380400001)(16526019)(53546011)(2616005)(86362001)(2906002)(66556008)(478600001)(66946007)(186003)(66476007)(31696002)(6486002)(36756003)(52116002)(5660300002)(8676002)(4326008)(8936002)(31686004)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WVEvSlBESVBRR0pQMnBaeS9mWFJHcmE0cTVVMDg5YWZRRUVLM0RiUFVxMHc0?=
 =?utf-8?B?OUw0TEthYmlDQXNKZXNjNGFJbmtoVDFZK29rYlIzY1pyN1d3a0pONXM0QmtL?=
 =?utf-8?B?MWFBQjdCQ3dFbUtzZkI4aVlCUlAvTzBZUkI5STZmMFNrdE80TjhmOHJDYlVP?=
 =?utf-8?B?bjltZTN0bWw4MVpsbE4reldxbW5jVEtqeFBiby9jUkdYQ2xjMjZiQ053OUNw?=
 =?utf-8?B?V0NkWTBsQkg4K3NyRmcxVy85N3Zna3Y1cHhBQ09oeWV6T2k2OG43VXFMekRT?=
 =?utf-8?B?SUlMdmNCdGV3UmUyU0xVa0RJQmJoS3RoTHNBbWt3MzVzR3hvZXlWMUljV0pw?=
 =?utf-8?B?TmV5a0l1QUxVdEkzT25nK1lDNUFhdWZGaG5wL2JCOERTVDZvaDFiK0xNWWR1?=
 =?utf-8?B?N0RsWUtwK2lqRGRrQlpDeTZ1bWJKeGhTWnJzc1ovQUhldm5CWnEwSUduVStl?=
 =?utf-8?B?UGg5MEpXZWI0aEdNQU15MGRTVWcxdUxZSGF0bzVUQjM4alZvNEx1NUFMUXU2?=
 =?utf-8?B?WlFXRmoxM05tRnJjZVJ0Y3l2VFEweUoyME1CNjdtekdKVGRoeGVpSTd1TXpT?=
 =?utf-8?B?czBCNjBRb0pKTVF0UHVIT1ZTcVZCSkZtK3crZXhXOE5yd3NGNjhZVjY1STdz?=
 =?utf-8?B?QWRqdFFjN0U1TnlsdEF4NzZkZWdhNGpOdU5YMk4zc29scXpENVNJT1FLUDQv?=
 =?utf-8?B?RnRQMDhFaWJuYStlUWZJNGtJNmVya2pxdmQ5S3ZpZGk3TGJGTS9FRHk0d0VY?=
 =?utf-8?B?ZFhWQnBTQndmMTBzd2ZjMkxDbDZEaWlIcWRUSXorR1h6cWNxNitMU0RpSUpH?=
 =?utf-8?B?LzRHL281ZGtJc3dLOGdTcE1kL3VLejltVmZIN0tiTkt4ZGVKTEU4aDRoZ0NI?=
 =?utf-8?B?Z2lrUS84TTg2cGQvK0FSZFNtekxOUVgvb2ZJN1BMNUorYmxMTWpaL1paNFBp?=
 =?utf-8?B?UFM1bW1QM21ZaTd4S0U4VzB4dmllbTY5bU5BNE5TL0h0UEdXalExZ2drRElT?=
 =?utf-8?B?WFhPdHlUZ2JqRlR6Wno2Nk5mMmtnYWo1blNLT0lydzBqNUNMYmhoRGFQUnhO?=
 =?utf-8?B?blIyQmozSXhKR0hva0tyakhjTGNMTEpyUy9KUE1WNjZmcWhqMU9sYUhmc0Ry?=
 =?utf-8?B?dWs4cEs5SVRFeGNjY0QyM3ZxT1RsNnJRVHN2QUNQM2MvR24rZFpNNHhleG9V?=
 =?utf-8?B?NlJQNnZMUkJwWlloTHJWdUdrMERTaTNpNWRMc0ExVjVweGM4Ny8ra2ExV2V5?=
 =?utf-8?B?YncwU3Y1SnBRanpsYzIyeWN4bWRqN3YvZjdTSWxKMXh0VW4yS2pyZGo2ZFpP?=
 =?utf-8?B?U3BLdXNOQkFMVzhKbXZxK3czVFBrRmlRT0tobHNZekdIQnMyR1ZMbHBpWGFh?=
 =?utf-8?B?ZThIVDY5Y3lRRVE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 18:08:49.2345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2f8616-88ab-44e7-e569-08d8b65bf215
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DGBfVOo3+sCaV8O/CTd1PZbKcl/nolCgcXu2B+C9wBNoD9YR70y8NCc8kIJ7vTN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_29:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/9/21 11:03 PM, Andrii Nakryiko wrote:
> Some modules don't declare any new types and end up with an empty BTF,
> containing only valid BTF header and no types or strings sections. This
> currently causes BTF validation error. There is nothing wrong with such BTF,
> so fix the issue by allowing module BTFs with no types or strings.
> 
> Reported-by: Christopher William Snowhill <chris@kode54.net>
> Fixes: 36e68442d1af ("bpf: Load and verify kernel module BTFs")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
