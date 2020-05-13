Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E631D21BB
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbgEMWLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 18:11:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31082 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730130AbgEMWLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:11:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DM34rv015809;
        Wed, 13 May 2020 15:11:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DQnCoXy/c+Q8lHedgoN3/V+WFNRBhuPy3a5n0B0xm9U=;
 b=Fx8o7l2MqhvdpKFHOUAXEleOSIc8SJ+yQZjsy8Ku01SUZwSL3SrG4GWXbQ3m7x1yhJhp
 k60X9LbJn95OIcBlfzWUjjre31uhiRkd6ynVgopmWTTpCYc0nkoRtj4AvgtO5xaWlTnm
 pVNFFrFlTHIfvC8ooCtc723eWKvztjPBssg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x27qdv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 May 2020 15:11:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 15:11:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moK64VZPAgP17ribjezRVhCpMyrLrk8fGz9k7E3H08001xEDAwnKwhT5i72IrEl4/LNiBxuX7BkxlkF0v9dCWKGwqP9nkrGdTWVi/QT5otxjYkFmixAPqQbc98s5Z13QMKjcH15RzlV9CNXyxPKDpmGa9vFMr4A+DLCSu/nDSVhY4qYrkSpMFHsZTJa1PTnzBfVQ6LJB879klVsNiDk9jVRYTfqhHwysBW+UcbuGP72JCJVSIcb4/zfwBbNPsb7dzzESdXxguT5zZT1PHxDYoxM8HFd0G2/2oCSKWZYVQaDbqZqqyMvwNfV3YsSgKhWonpYazOONfZ8oVYbPLOgM+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQnCoXy/c+Q8lHedgoN3/V+WFNRBhuPy3a5n0B0xm9U=;
 b=FKeTPhV8VRNgci3QMnNKGv5fBnFKCthtHmCwBAQ6YPmSYLSFEx+SneZCPx0hdyJJfZ0MGk9EO2MohXOwrKqSkYnTPHUet7t9qVhfwSUZVV2mu0H4Qn19UT9Koh/RkHkLj90kjdw2eEK0zMn/qkR+/KIcxQEDiDzsvZynZ6VPd1ZnDlbCpVqmCczMqTdOwMsN4eeBwQY2adHJhcTOl992hshw9VV8gc/oYM330RBVoJnTxrdKP03l67SWq39HuujwfTUTAw/+OuWX32vKTljcnNYulaf39g4rlCZZYXrLvkSkpFwYNZthPj21tCXvxfZLZxv6D7eAPLGZEEdc1faPVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQnCoXy/c+Q8lHedgoN3/V+WFNRBhuPy3a5n0B0xm9U=;
 b=BtktF79xiKzvrT0K/Ounl0/h9zvbPyxwVAJcB384AJL/GPNbcI5MDkeJ49XN4Qfvj1mXSD37CW7qozDWDqhGTJWbmr9kJ9Xx5Xd663NQa+V1hv3oiX8aGx32AzWrQRZ7FqpPUSN4sqzk4BQbw26BGUXq1I8gXFpBN1kvtgkgDJ0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2886.namprd15.prod.outlook.com (2603:10b6:a03:f7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Wed, 13 May
 2020 22:11:20 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 22:11:20 +0000
Subject: Re: [PATCH bpf-next] bpf: fix bpf_iter's task iterator logic
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200513212057.147133-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c7bc3381-c8fc-254f-69dc-a9288d190c69@fb.com>
Date:   Wed, 13 May 2020 15:11:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200513212057.147133-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:a03:255::10) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:a724) by BY3PR10CA0005.namprd10.prod.outlook.com (2603:10b6:a03:255::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Wed, 13 May 2020 22:11:19 +0000
X-Originating-IP: [2620:10d:c090:400::5:a724]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b849a29-a074-46df-9a9e-08d7f78a90b6
X-MS-TrafficTypeDiagnostic: BYAPR15MB2886:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28869395DB723DEFE0403C67D3BF0@BYAPR15MB2886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lmMX8DtjWoZACur7Hib27UhMXVzyXz5S4k4+8Qev2+6j3Ip8+Z/6MAje+Fn31bx1RTkFUeoPU6bOWIYFiyhe+1a7qV/PEM8r4pt66X1bnAICQcQisDh4zljO6UswrIW5PsJZwaXyQlfrU259MWnzpk7mWW41OW7ZLS54R6gYkwlNtMUu8uvcgN95s8oLoUGTQPItpFxl0AkLda39Jb0xU4/M4wMHojZcqNT3Wrvq51CUQVZoui6ZArMGXdKbcz5bJFHqRlsWYsrQmp9cQWyKgBGd8myohBEDDkNnpPo7WUullinAAJj+1yKlyjCXj0trCOk65Mv5HelGJHIMeBxNMS6T8sZCKljHw22XdzmpTztact7MRsulJ6Q+0SdjQxc9J7Dg9/i55C4YU0ov3eBeOHlrEf13+WNvog98KjJohucEXcbCubVNzJbTbIGcSCUExO8UfGiXv4hkaAiZmTvm76kWgJcMCdD4DGTWA9ezcVY5vvQPdKUK00GpKeMdyCyeskvAPULjXvWz1yIHwTolN+aJD+0mDl9hbZZelyolTZNjNpGW4p7xgHEnrWpBJ1z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(136003)(346002)(396003)(366004)(33430700001)(31696002)(316002)(2616005)(4326008)(2906002)(36756003)(31686004)(52116002)(186003)(5660300002)(8936002)(478600001)(33440700001)(8676002)(6506007)(6486002)(16526019)(66476007)(6512007)(66946007)(66556008)(86362001)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LxTNYX3n3KwkOfQSapbLpR+CDADX+3SENl/jlQK0xjOJr9X28gGz2gBQ8ayQ92WfrDT83zMtjJUrTCsD4HPEK7uix4JBV5pZr77Xqfzex1SdS3gQOeRC1wCysK+OhNdhJv0Go0q3hRg3XKXDgKLKMV7zErDlgNyAHxU+1BrJs0M7fJPLQcvzzd8M0N8Ji27YKFevMnA6Knc6pI5VL1SWWgvRuXfG/wo+C0wEm2Sux8om3SddxX4w00paKswC+gjGDrd5Tef9azYnUsi+WPOkdcuXhQ/FFNNjrp474d/EEMTF7IIoN3BH1gl7UsbGpWnBRqgVk2nxoYyTB+R9yO0pR/SVzAR3u/yWcMzlFiZyViypeA4v7W4SkRs2wVs3l/Sc/djhKcKRncgNDckPC5lcf7UcS3jKrf5sROR2Xjy9NaAACRZwo6sxL/uCS56v5+0gVQ3T1//OehytczKL6mWJqBO2QHMNftmB+qxHA0Fu7Sgub0aIHILb2m9FU0jE6IaqfC2wB9WKZEQZA1yveWCkbw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b849a29-a074-46df-9a9e-08d7f78a90b6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 22:11:20.4266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAjANp7xocDgVHeg+dWYWWHrY7apc+kWJeFekYEyWAt366Yu1pHsXWpd3rqdiWec
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2886
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/20 2:20 PM, Andrii Nakryiko wrote:
> task_seq_get_next might stop prematurely if get_pid_task() fails to get
> task_struct. Failure to do so doesn't mean that there are no more tasks with
> higher pids. Procfs's iteration algorithm (see next_tgid in fs/proc/base.c)
> does a retry in such case. After this fix, instead of stopping prematurely
> after about 300 tasks on my server, bpf_iter program now returns >4000, which
> sounds much closer to reality.
> 
> Cc: Yonghong Song <yhs@fb.com>
> Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Thanks for the fix. We did this retry logic for bpf_map which is
idr based logic too. But forgot to check for task which has the
same issue.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/task_iter.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index a9b7264dda08..e1836def6738 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -27,9 +27,15 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>   	struct pid *pid;
>   
>   	rcu_read_lock();
> +retry:
>   	pid = idr_get_next(&ns->idr, tid);
> -	if (pid)
> +	if (pid) {
>   		task = get_pid_task(pid, PIDTYPE_PID);
> +		if (!task) {
> +			*tid++;
> +			goto retry;
> +		}
> +	}
>   	rcu_read_unlock();
>   
>   	return task;
> 
