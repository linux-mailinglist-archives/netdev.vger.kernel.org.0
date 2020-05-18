Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF06C1D7BC1
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 16:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgEROsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 10:48:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26940 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgEROsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 10:48:21 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IEagIe015584;
        Mon, 18 May 2020 07:48:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=agOclweCAmSeP4HPLHRLk9sAhs6V1J0PtgvVVGqcWrw=;
 b=JpzifDtAretCR97h9nuLlseyIVdDLYOOIvJl0+50aJ9DfQtDK1Pgg59xwozJBlLO2Raf
 BoApHuVH+0MjwzinDyq6zbcZo4UTh0DFEx/pdECfnk0NUNiwzZo3vBF/mb1HC9aTiyhC
 Dk3H9tv2Z0ekhyJYBNZE55nyU3KkkWICVAU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 313013cj4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 May 2020 07:48:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 07:48:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SK2Fqw3W38Nb9A+Vv3fDs3KY1YCk7ij7b7boUAf1hQ5+gXBu8aQ6MaQGFADRTJ6aI5wSzv/tpcDx47nLPD1rZjo72mc/Hw8TncVwXDJi8vzsRBXdckyeiT2QsfzMco4clF+D0UiMvuWVCIlC/1Lmx3oxVvWLpe0SBKsdaBVaClnU4E+Nhcxj52Oyzj6lMs74p/MMxhmfnvLXxLhlFC6skAQ6Y4QiWoiet0lAILlvEmBznmi0ZoWtB07i757qP2BGLT+r4eWyRUTWqaSD9SERRb4P39cx9CJrmtpplZVX0gEcyfZ6vxBXYF3iMXukab/7UL6MsrvUnp4mGDgw3qLD0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agOclweCAmSeP4HPLHRLk9sAhs6V1J0PtgvVVGqcWrw=;
 b=JkDhvHv49igDdW8bPQv/s+2lHRiu9g86fkabuhXJIjbN0Keoyl2Fr/7vpLauurdjEjDiuIW9L/A6qfUzZjdNaJd6zYiTjEQNPghzQwPmoqQeX6ruYBLKb3KQf85B2hpLY+Zwhlh3bD9sDcFslB3BOeUCUjfteConrZSeuNjz0PzWxeIQimmQfLG/rfDP4SUkmyK1vhrVqEhRgpQEMdDLgbfuvPIAdh8NopNOD7Ea9ew8joIr3ctITg3TDI2aOyOVxZ07m9t7Jcc9hGHKGMipoddvk3MYOfOr85q1zqnJosJ3NE4q52tjFBenLs95H35bCK1YsESQQuYgeGsmakwqMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agOclweCAmSeP4HPLHRLk9sAhs6V1J0PtgvVVGqcWrw=;
 b=a8ZUTptEaI4/G5bFYuJ8B82z2IM9RMPZsTUoPxh0aWfGOcs76crwQEyWK/pgow7pWG7t9tSOcFHApCGsgiWUjvgGGuWtHcbXtqOtUFSGF8mepVMi6D6RtJ2XRSegnMJu/8r6YbtHbi3L/EcD6PQWoKbSp/eF+vtJmRI+9urAgsA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2328.namprd15.prod.outlook.com (2603:10b6:a02:8b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Mon, 18 May
 2020 14:47:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 14:47:59 +0000
Subject: Re: [PATCH v2 bpf-next 6/7] bpf: add support for %pT format specifier
 for bpf_trace_printk() helper
To:     Alan Maguire <alan.maguire@oracle.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <joe@perches.com>, <linux@rasmusvillemoes.dk>,
        <arnaldo.melo@gmail.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <1589263005-7887-7-git-send-email-alan.maguire@oracle.com>
 <040b71a1-9bbf-9a55-6f1a-e7b8c36f8c6e@fb.com>
 <alpine.LRH.2.21.2005181000520.893@localhost>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <91960eea-fb43-c26d-f8bb-256d37d5903f@fb.com>
Date:   Mon, 18 May 2020 07:47:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <alpine.LRH.2.21.2005181000520.893@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0033.namprd08.prod.outlook.com
 (2603:10b6:a03:100::46) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:d485) by BYAPR08CA0033.namprd08.prod.outlook.com (2603:10b6:a03:100::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Mon, 18 May 2020 14:47:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:d485]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d424ae4-ecea-43da-c292-08d7fb3a7568
X-MS-TrafficTypeDiagnostic: BYAPR15MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2328EB84FC142B625C6016C1D3B80@BYAPR15MB2328.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VdJQxgZ3xoSiRP19KJ7OW4ZyRuqSOwy9CSbIYUvBcS3U6WkWOD8+35uQijSv4f2fUtWffaUo9JdjQMqaFKdcRbv7Prxg56g9ctVbIsqfxNmoyNv03TUndACB9hNAk6Iy2btTD76eIf8MFje2vy0cIrF9DSyr0fT1nRgrYk3b2muA800Tv8MMuzqrS5/KDu7SKAW8GpimBQkj5yHV76+DcpeB4OIhg8IfRG65B0Wm1o/xyNgAIu2+sQhJdDhLgFD5mp456lCB0ErVBcoc+JhEA+GbianfDejobsh+V9gbKO6yzj3SUPwNG+tL+gQL4pFpjMdoV3olBCnfQfTEYY8WslaiJij4cGJJh9GGcKwF3jXgI6/bole4YqULAFU6vafDKBtS8Dwp7h1/FnM6V7YIaHBb39ZzlFfS3k0tEoRxKI0hXW5tTOioVzPWUtInZKOY5EkbxL2+kIoZRoeOEo7E9xe+vJOrMvAsmjylZYsT6TVwN4olo5OX8LVTCn8KvTLt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(366004)(376002)(346002)(396003)(16526019)(86362001)(31696002)(31686004)(316002)(36756003)(2616005)(66476007)(66556008)(66946007)(52116002)(6506007)(53546011)(186003)(4326008)(8676002)(6512007)(5660300002)(8936002)(478600001)(2906002)(6916009)(6486002)(7416002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ZAPQSK2VkvvDv3jCN96lsGUt2vjEeflIGq8NXDhcwAB5x5iitaTyRwYPR7D6Jr1kr7kfaZeuFVaoW+jNl+TaRzhyB1KlHK01hu512hXCtjvgjpyjr1Z/O2xp7+lyhHf5+XHQni+/6yK/XY7kMX9zOmOoJgmwGc326hAeCAxoZw0toLEgaxWUU3Nm/odzNxj2Rf3dHRZrKgUQRtiDFlDW7PtHA4JRevwi5vXdQC6hF70l/lWxat5wNyHe+AYKHznvFz9t+H9dOnz0j2cF/Z+X8YDezFzZp8I5OXWUpoRJJdYQqpuQScBXRHS3xEHrwcYJf7fSBsngFaGzD6m5vVOdvfDEYv6CnPRKcGz5+kYRmprGLD7B56RXxJM+C8uCVH5/GILQAgXjSqOq/t11uthwmF8pOHBxDAfFTKorJpYYbWr+qT5p93AIDa2oKQRRGhitR4nYDF2RmJ+lJnP1bVb4FyygFyJr7Arbqjq7NBeBGBpjxSKLELezw6FNHv0v19hDI2ZGAHfyIm4DbGebzRyKOA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d424ae4-ecea-43da-c292-08d7fb3a7568
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 14:47:59.5297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDVAmXe7zKLGppWWunRbqgoYrXOn66IKrZIwiCtFgLK8T0OJIoQgkD3/LkC2HZvL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005180129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/20 2:10 AM, Alan Maguire wrote:
> On Wed, 13 May 2020, Yonghong Song wrote:
> 
>>
>>> +				while (isbtffmt(fmt[i]))
>>> +					i++;
>>
>> The pointer passed to the helper may not be valid pointer. I think you
>> need to do a probe_read_kernel() here. Do an atomic memory allocation
>> here should be okay as this is mostly for debugging only.
>>
> 
> Are there other examples of doing allocations in program execution
> context? I'd hate to be the first to introduce one if not. I was hoping
> I could get away with some per-CPU scratch space. Most data structures
> will fit within a small per-CPU buffer, but if multiple copies
> are required, performance isn't the key concern. It will make traversing
> the buffer during display a bit more complex but I think avoiding
> allocation might make that complexity worth it. The other thought I had
> was we could carry out an allocation associated with the attach,
> but that's messy as it's possible run-time might determine the type for
> display (and thus the amount of the buffer we need to copy safely).

percpu buffer definitely better. In fact, I am using percpu buffer
in bpf_seq_printf() helper. Yes, you will need to handling contention
though. I guess we can do the same thing here, return -EBUSY so bpf
program can react properly (retry, or just print error, etc.)
if there is a contention.

> 
> Great news about LLVM support for __builtin_btf_type_id()!

Thanks. Hopefully this will make implementation easier.

> 
> Thanks!
> 
> Alan
> 
