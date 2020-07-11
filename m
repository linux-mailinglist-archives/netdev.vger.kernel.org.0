Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1A21C1BF
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 04:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgGKCJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 22:09:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59036 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726671AbgGKCJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 22:09:26 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06B22a1F004898;
        Fri, 10 Jul 2020 19:09:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YE8g9FAEG7B9beprHAs/kMpKuUfGzZnBUqtzRGzPRHw=;
 b=Q3VAUtnle1/DLdvpvB49u55hvbidH3BByg2gk/ac81yTDqqdugV3mOL46OokqIHfHmVm
 uxaDI7mSE3GVvFH1fA8fG65spJi+wSfGI6HU5Gq7YnSKz3L76QqYXSNKSgaAOcpluD29
 A7pSvloAnPBe+n0Ywoag11bvORQkxMhuMR0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3265vt8a88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Jul 2020 19:09:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 10 Jul 2020 19:09:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PubFFhG7Rq6AFOPXkvG4BrAQCK9cv1SO/yuXRyjOvjZfWJwhGsYd5WRQB7Bekhs9P/oUDk+rCHYv3NMK3RjW5Mk01X22ptMGzseYjYAK/3mhEvULQwkrxnjYpmEPUB607LLb8DelNgirCsPiQuxAUU4OpBkvmlAYrxmNUsxKNSZbfZziKJ+ohJ6pC5PXohBehvysIZ9HH+jnuz0qfRRfU7n7l9bM0gJY1ZswEg2qym4O2y7pJb4IhTQjW11B5jH0smRU2m8icL0Gyd3axdDKzBrylr+7QrVuwClDymDEwHdb9jJomn1hOxZ6X8ZcQsWZF9KePhJ62SmKwZr8kulxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YE8g9FAEG7B9beprHAs/kMpKuUfGzZnBUqtzRGzPRHw=;
 b=i8gi2O8mmHhKaz48SF/yv0psdpt4YAS49Bh6wKVzt61SnRCC812o5qGXdWD3X3PTCKU3j2KqZ90bwd4Xc7KUNoP5ZyJ7XMhS7nRzYt7Dtqk+FgNxiv5XMpsDUjZ4VsBeYO2feeJT8j9loGzI56xdOmwL1L4pCWcNi7ZzsI6fzWdCfbJ7pDFKwhSGDULakKVvAi6ON2edPEkJ7cJhYvjwo9rmu6pnGo8nr66zENSF6t6BjzU4uth4IhbslMlbhM0GL11Zivfat0lst3PTQ+iteetTCwAp0n+LBkuBK+JBj7eqWjAKRMCJuIGxga+nd85ljTWo5KVAeMsQJm+eo5tcVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YE8g9FAEG7B9beprHAs/kMpKuUfGzZnBUqtzRGzPRHw=;
 b=GmbZwmdBhqzMjviNAnnzRuNdYlykSuz+1iXG7ABdk4SxazPmyp2YlT6SUA4nLLA7QYH+lHKR5QL6IfrZVmWaC3f5Ozkn5Ov48tsu9pbykgJiDreX0ts2Oax/x9n72S/WvN4IILCwoSSa+Sm90t0otjeKakNN8yMwHlP+E0gHu9c=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2839.namprd15.prod.outlook.com (2603:10b6:a03:fd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Sat, 11 Jul
 2020 02:09:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3153.032; Sat, 11 Jul 2020
 02:09:05 +0000
Subject: Re: [PATCH bpf-next] tools/bpftool: remove warning about PID iterator
 support
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrey Ignatov <rdna@fb.com>
References: <20200710232605.20918-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <49d46a96-ad92-90dd-9723-893bd1e5a7bc@fb.com>
Date:   Fri, 10 Jul 2020 19:09:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200710232605.20918-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::10fb] (2620:10d:c090:400::5:1b35) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Sat, 11 Jul 2020 02:09:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:1b35]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08c13d97-1960-4767-7e35-08d8253f6334
X-MS-TrafficTypeDiagnostic: BYAPR15MB2839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2839955F0F01BC594A7645F2D3620@BYAPR15MB2839.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PUyBipwBckdAvIarMsW5grCrNPOS/Y/OT75maGTw+s5gDAz+CKgjBpCLniOZihy3a8/IxN+CT910LmmeU56OMoZsdan/MvwoxBUDMmpqgl9s0CUTT4OckzWQTUTEaoTnzFoxNGHye+lhXSB4N7e/foiywK8OIhrHpSVRc+FKXM1w67r2jFrpnKWUJ30zCgeiDfJpXybKglRmVGsbFWJtqhZq3SFYWQk2NrSON0cBU7YRW1zX2ch1/Py+BYXjkDeyh72q5SBBq52aV70UQaKQYk2NhsxauC5+YuIh0Xhc7VlJq6P+82tH67bSoEYxuK6aquEmO7I31+P+q+K9GWncL+BaAllqScQqvQtHDmpLRKr7YV085DN9t6eCyxMLl2Fa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(366004)(376002)(136003)(39860400002)(186003)(8676002)(66476007)(66946007)(4744005)(36756003)(31686004)(86362001)(66556008)(5660300002)(478600001)(31696002)(8936002)(316002)(2906002)(83380400001)(4326008)(52116002)(16526019)(53546011)(6486002)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: X3P3zRGcR8tcl6Jz4lEnalJyCbC/xZFchOhMIYF9wxqlxUxCWpBsMLCICJ/F7odig0F5x/+wPL6zX/QZvsBbinjo/MHKMabjY/oSgzIjkLJmCi3IqTZp1+Y/iobXg8U7GjURU7upJHHfZy6Ev9BXwiITtO0g+U8Xo63w6rGBCwDwgPDJE+iir51SJVKEyPbHVwHPr6bBN952/dmILkHHNHqJl9MSqVdYEwOP2kxUcDrvytGA9uqwf5FQK+tstX6n1sYj6jsw2p9ZtHmKMHBmyo0MFimJrGAumU1WtNXfJpfbRzKn3ZkdgI1zSPhKQ7F9tFV5uVC/OmbsidnulhxuIyDyTfzGN2Sl/126ZxLab0fbvzwGasnHl+eLk/xCqRJsYSleBRmN/QzQqxG7cLiVrzPm1TFV4sLzF+qbKOIucHGF7OvnSC9OddeFie6YbhVpKOlyXAiUufez6yCzCVDJETMsXdWi9M42pM7t0wIfbGfbnW9sPiLUIK/S3DPoPKVQG8BOS/wVC+zjNM2NFCZGCw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c13d97-1960-4767-7e35-08d8253f6334
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2020 02:09:05.3555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KVWAmzyynHSfmBJJZiC2IswZfDbFkTjbMtPd3rWCWtRHNk3mgoDqE9xrnPs5zb5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2839
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-10_14:2020-07-10,2020-07-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 suspectscore=0 adultscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007110012
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/20 4:26 PM, Andrii Nakryiko wrote:
> Don't emit warning that bpftool was built without PID iterator support. This
> error garbles JSON output of otherwise perfectly valid show commands.
> 
> Reported-by: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Thanks for the fix.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/bpf/bpftool/pids.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
> index c0d23ce4a6f4..e3b116325403 100644
> --- a/tools/bpf/bpftool/pids.c
> +++ b/tools/bpf/bpftool/pids.c
> @@ -15,7 +15,6 @@
>   
>   int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
>   {
> -	p_err("bpftool built without PID iterator support");
>   	return -ENOTSUP;
>   }
>   void delete_obj_refs_table(struct obj_refs_table *table) {}
> 
