Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569AA1B7E8D
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgDXTHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:07:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44712 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbgDXTHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 15:07:19 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OJ3ec4026642;
        Fri, 24 Apr 2020 12:06:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hM/GrYLnqKmMzBHmP7BfjUaoL2dAdHwpFmp9GcTdpKg=;
 b=YoW0VXwwvyIny6pKKv9c1GPWwV/luiWDCDz/7DSidKflBPj7dOWwEmJtbNdpCrmv3jKW
 Pf77jfqa+fpLZL/KtwjrL27PdhNOsIDXFTf0MBoy7Y8rVnZcWTvZcii+XMWTVCSLjFQh
 jpVrZQSncVPpkbDRuKQ6EwR5b9DAirtSHAI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30kknkxgp4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Apr 2020 12:06:57 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 24 Apr 2020 12:06:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIRClPYVvElwaX0TqgXPwqcXSJTDqRyayRHhe9WfeC6pOq/VW8zEydasZhEw9XXFqjMH5b9mw62gaq5TPTorBpyhS4cGpP75umh+Oo2LHrWq9dslmp1S5CZFDnljHpGP26CGrEYKycJtWY+nVTHX3OxkvcuG/5gr9jq7IT129OfbJoUqdYy6PTfwpyDFdh54u6qRkyTvEQHoEb/pfhjZGUBStyjZgwUZUJWMlUUZfCN/bnpR7cw+nSxe3ME3y2+nSYC8hSj1T9viiuriYjL5uHjUofRjGfKZwV4Pp/wSj7QIgsj74gVNwGtCdLEjdnKEsOE8wXIN7wO/+yTo+KVhRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hM/GrYLnqKmMzBHmP7BfjUaoL2dAdHwpFmp9GcTdpKg=;
 b=hP5TgoPtB1afinpU4yjb06/O8CzbZHtObwf0uLKr0rrz3w2Y8Nzlnaxr/2SwqVpNOU9XWnzhZqVpx8WICa57OO5NoOvMpV3gZr5RRvUwNCat/O68MrZ4Agln1QleQbb1FaRypGh8/2OE+dA+3BtXX10CdvEqkQGWuPGp0nQiBl/xchjbN6ZeSqLZQ1cvs6Qn7cEomiIc3JNlBBPMLthyniF5fZh3XSS8OTPs3gX/xqeJI7pfVhSHhSSlAEH0EIiOWxWq4SOluB/JG599/bhtvWBaC2wiCngy4PLjMWiwFVD8x0x1zYSDE8yRbftNjwotUAhnqdd5lXCnESsLoWMq4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hM/GrYLnqKmMzBHmP7BfjUaoL2dAdHwpFmp9GcTdpKg=;
 b=Hpf986SzpRAxcXLpZ9r3Q4GmLwIkyYho0tIkR2UogIImrgSFbwmHSsDXVIxPd5QzHK3+TPFSZXdaYi4DKTWjoGJRSXVf+j0hZNycN22igo8xX9dBidiRY640UG6ytZNiraT/boxiopUlm5eENfRb/1xVm3oOEfFmjgl+bjP3rko=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2646.namprd15.prod.outlook.com (2603:10b6:a03:155::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Fri, 24 Apr
 2020 19:06:53 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 19:06:53 +0000
Date:   Fri, 24 Apr 2020 12:06:50 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH 5/5] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200424190650.GA72647@rdna-mbp.dhcp.thefacebook.com>
References: <20200424064338.538313-1-hch@lst.de>
 <20200424064338.538313-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200424064338.538313-6-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:300:103::21) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:f8d0) by MWHPR12CA0059.namprd12.prod.outlook.com (2603:10b6:300:103::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:06:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:f8d0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6370f825-e3ee-4832-c815-08d7e882a65d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2646:
X-Microsoft-Antispam-PRVS: <BYAPR15MB264688E3CFBA32A1C0EB36C9A8D00@BYAPR15MB2646.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(366004)(136003)(346002)(39860400002)(396003)(9686003)(66556008)(186003)(5660300002)(16526019)(54906003)(478600001)(7416002)(52116002)(6496006)(316002)(6486002)(66946007)(66476007)(86362001)(8936002)(81156014)(33656002)(2906002)(6916009)(1076003)(8676002)(4326008);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eNaGqUW6wSd4bBK1v86xk6mZCTRwc50jcBjq/tkNyMtygZSTtQE9d4AYHmafq+og7DtEg31A7TsKBERa871xT1IlOx4SKdcNKbE+dXWGUUyJUUAsMfzzASuU2cvotVcf3bycf3byM8zHCa5pAQU3SwM5YFPnl9VJoJVAqM5L+yc1SK8Hrp6VfYW+V8QpU5Ncs3qYKENXs9wfM4aSkBoKwa637zgwaeZWanejKCGWI7Tsq+YCkOzb+4yizIbEGA8a5RK6ez0zWfE3h5Re8+vukOjGKy3qXq9Hp98DzlGyu95YG4eIZZAS8j8NK1Asnx5Gky/61q8jMA2wy1n60EOwjt9tvICDYYwpdatHxXDadkVuf+DDX7xL5i9gntT1Dj9WXQYyf+GyBk+5xwwEjwPoloWfJhFnW/W9+6FLfks/NIMuovf0iyo3Vc6QUp7+lpew
X-MS-Exchange-AntiSpam-MessageData: VEbm7jeTzG09fd1BaC+airxTE26QraJYUEe/Ot9gLYkU9qtJyaFqgT/lcN78FHmXoMQzzduUqFoHr+fHtGg3Fa/a7ZjKzvkEjq1CsJUTmwKLppY3pehwpevWrPXbXc+qSxxmCRy0+g+jVxM7AaukoYiMOERY7BMsbwC0sDh+Zj3nj9LOqT4x5w0UjUXM2WO5
X-MS-Exchange-CrossTenant-Network-Message-Id: 6370f825-e3ee-4832-c815-08d7e882a65d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:06:53.3219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8laA+gNu2MlHLKV//wJ1THIf/h4mDwarLihJBfieHtW9btJzFXmWYrKRW7m51ti
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2646
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_11:2020-04-24,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> [Thu, 2020-04-23 23:44 -0700]:
> Instead of having all the sysctl handlers deal with user pointers, which
> is rather hairy in terms of the BPF interaction, copy the input to and
> from  userspace in common code.  This also means that the strings are
> always NUL-terminated by the common code, making the API a little bit
> safer.
> 
> As most handler just pass through the data to one of the common handlers
> a lot of the changes are mechnical.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Andrey Ignatov <rdna@fb.com>

...

> @@ -72,33 +70,21 @@ extern unsigned int sysctl_sched_autogroup_enabled;
>  extern int sysctl_sched_rr_timeslice;
>  extern int sched_rr_timeslice;
>  
> -extern int sched_rr_handler(struct ctl_table *table, int write,
> -		void __user *buffer, size_t *lenp,
> -		loff_t *ppos);
> -
> -extern int sched_rt_handler(struct ctl_table *table, int write,
> -		void __user *buffer, size_t *lenp,
> -		loff_t *ppos);
> -
> -#ifdef CONFIG_UCLAMP_TASK

Decided to skim through the patch one last time to double-check the fix
from previous iteration and found that this ifdef got lost below.

> -extern int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
> -				       void __user *buffer, size_t *lenp,
> -				       loff_t *ppos);
> -#endif
> -
> -extern int sysctl_numa_balancing(struct ctl_table *table, int write,
> -				 void __user *buffer, size_t *lenp,
> -				 loff_t *ppos);
> -
> -extern int sysctl_schedstats(struct ctl_table *table, int write,
> -				 void __user *buffer, size_t *lenp,
> -				 loff_t *ppos);
> +int sched_rr_handler(struct ctl_table *table, int write, void *buffer,
> +		size_t *lenp, loff_t *ppos);
> +int sched_rt_handler(struct ctl_table *table, int write, void *buffer,
> +		size_t *lenp, loff_t *ppos);
> +int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
> +		void *buffer, size_t *lenp, loff_t *ppos);

Here ^^

-- 
Andrey Ignatov
