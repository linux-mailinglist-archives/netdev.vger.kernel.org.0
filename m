Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277051B3044
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDUTYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:24:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51766 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbgDUTYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:24:00 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LJ8t3g021869;
        Tue, 21 Apr 2020 12:23:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZW+mP98htNB7VsqrWiYjT1DH/cybCDD4F+LstqPLgps=;
 b=ih+okrN7mVPNia8HphWajkkEUdxkV5n1DTqpuxgdzpslLXeuf8aGup9iavobTlg3rIEj
 fyoJZGDQXf6IsO29OEOPTTBmUf0NLvEtQ+Dw9M/2ak6ZnGtAU5JKEkFLMUfdPksHXzK9
 i2CK7Rtt7w1/Hjp+KZ4+o/RzIc78vReH6QE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30ghjwcvnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Apr 2020 12:23:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 21 Apr 2020 12:23:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmhXmxsvS6MCCAOfQJ1uxD8T2eunOu/nS0BOC6Kz8n5IbhdEwe6n+1rwK/P4ssBs1IUtJ1ipxA04KoaU/z2037i4X0mnlyoOyw/yYbEtyia7EderDt9QcyxcsV/rAzjWenkU49qs6YkfVJfUf7aw8N8cqAU48etx9zrE8Osqdwu5x9+rvQKBUstCdZFfl6+EQvelWde/GNM6xgmq7V5v+vEDN6+U+7q5vzwg14rAu/vTG+k2ZhdH3hy5zNKfjVfPcBSVS33aWH4GBXt8AOWWU7Yn1JZ5siptHv1ECiuz0S9E6E91/wfA1UH5x4djf8ooD9aN0iNjQMqYRh32wdVVWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW+mP98htNB7VsqrWiYjT1DH/cybCDD4F+LstqPLgps=;
 b=ECO1eWMIcoDcb08VvBKhFRPBr5n6Z9Wr6I6eWfjnMi7u3flispr15hlz6V+YTlq9uhx1U5AgVJMF8WRPrLhl0MEEvD+S3YGoF3GRMMtIvMkl1gslwGbNk54DZY6azMujv2y6Cpy7TwM0kpMEDRiAsLiyMv0HenDOGaqaDp5hzN4LX+DmGWcqp/xI97TzVjbdz7dwX0bfjd8uSe+qTV/X6nIFkxk36mDSFh0/OVap7k3uka49sb+kjUuHP9NekyhH49o0qRFtqD455NCSNAVABpVKfU75oLeGM0xxSycYDo5kUuERnVk0ixTkdTc00TQle1oQM7Bv52I0Z0XgwK0abA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW+mP98htNB7VsqrWiYjT1DH/cybCDD4F+LstqPLgps=;
 b=XdhBk5zdfOFySrZ5EXjSI0F8V1W+WyIrjhFzM+qrSs4VuK0F9AQA3PVqXEqtaCwmDY5kZxIegjvIicnJ+r/1KPKM3JoZiRHW/a8fk/do94z+zJcWliOG7+MIymTlyDj9mOmosXDnUyo+3QhOAfjyynkgxVeLU4trvUDFCout9xU=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB3048.namprd15.prod.outlook.com (2603:10b6:a03:fc::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Tue, 21 Apr
 2020 19:23:33 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 19:23:32 +0000
Date:   Tue, 21 Apr 2020 12:23:30 -0700
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
Message-ID: <20200421192330.GA60879@rdna-mbp.dhcp.thefacebook.com>
References: <20200421171539.288622-1-hch@lst.de>
 <20200421171539.288622-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200421171539.288622-6-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR22CA0053.namprd22.prod.outlook.com
 (2603:10b6:300:12a::15) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:90b1) by MWHPR22CA0053.namprd22.prod.outlook.com (2603:10b6:300:12a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 21 Apr 2020 19:23:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:90b1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cab8a8a-2fdc-4da5-3645-08d7e6297af2
X-MS-TrafficTypeDiagnostic: BYAPR15MB3048:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3048D1E71E016EB04BA83053A8D50@BYAPR15MB3048.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(136003)(376002)(39860400002)(346002)(396003)(366004)(316002)(16526019)(9686003)(2906002)(33656002)(66946007)(8936002)(8676002)(186003)(4326008)(86362001)(66556008)(7416002)(66476007)(81156014)(478600001)(1076003)(54906003)(52116002)(5660300002)(6916009)(6486002)(6496006);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UfEYhyEN1kjJ0nYO2c8wU5uxwN0rPHzhhUd0+7pteTt8AwQB41WRtm+31nhWpn004M2XIl4KjahY1s+MXUKLGkXXY62Qp6t+W1eagTLMxzAzuLS5H9GFH0H1ig99tGq7VUMPt+FQTQAOch2SkRCoATWSJ7OfJBYaNuTQPbNON94fRL2n/vpePFDI1jUYePky/1iaU5HkbhufqLhv7Q8ceM2oIsMI5u8HpuEz88OcH7bgM0NawNI/ajQ3VOW5aVQRymlPqv/Wy2JO99TI9O8IdVS0Oh9mF6ekHXG9eQrrXoLHenTq2N1D7xt12N4MMgPzM4vvGLyhtNS4INUJap94Oj6mN2g4VGXHORaDo+oebazs59P79wFdlSSPMAQ939LPlGsHnwrL7opR/+E3u8QP46UdAl0C+AYb21oZv5RldAcgd9SUg7CbNPu2MhFtoBsP
X-MS-Exchange-AntiSpam-MessageData: NMmlGC6LsbbqLwJ1gGkLJEEFPW+yd2r0cVFamFFLq6lZsQLq7E63O8cgj1fIFKPhW35UkK5uw8bGqq8r48v5zUEdma7LLZwRiNphBnLLxnoBl2VGnTHQp0/AX4RvPhm0RbMBCbeymxJ0YZBia0nqLt9M5JJ6kjp4LlJRrf7BBkBO8GD/cQ50ZcPhBEA36fWu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cab8a8a-2fdc-4da5-3645-08d7e6297af2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 19:23:32.9054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6iiCGiOG+6+LyLEBj4CS2/ldkg2S45BNj27aCcZVnJVIBEs+Nqt2mslVCCQL4qA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3048
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_08:2020-04-21,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> [Tue, 2020-04-21 10:17 -0700]:
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

...

> @@ -1172,36 +1168,28 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
>  		.new_updated = 0,
>  	};
>  	struct cgroup *cgrp;
> +	loff_t pos = 0;
>  	int ret;
>  
>  	ctx.cur_val = kmalloc_track_caller(ctx.cur_len, GFP_KERNEL);
> -	if (ctx.cur_val) {
> -		mm_segment_t old_fs;
> -		loff_t pos = 0;
> -
> -		old_fs = get_fs();
> -		set_fs(KERNEL_DS);
> -		if (table->proc_handler(table, 0, (void __user *)ctx.cur_val,
> -					&ctx.cur_len, &pos)) {
> -			/* Let BPF program decide how to proceed. */
> -			ctx.cur_len = 0;
> -		}
> -		set_fs(old_fs);
> -	} else {
> +	if (!ctx.cur_val ||
> +	    table->proc_handler(table, 0, ctx.cur_val, &ctx.cur_len, &pos)) {
>  		/* Let BPF program decide how to proceed. */
>  		ctx.cur_len = 0;
>  	}
>  
> -	if (write && buf && *pcount) {
> +	if (write && *buf && *pcount) {
>  		/* BPF program should be able to override new value with a
>  		 * buffer bigger than provided by user.
>  		 */
>  		ctx.new_val = kmalloc_track_caller(PAGE_SIZE, GFP_KERNEL);
>  		ctx.new_len = min_t(size_t, PAGE_SIZE, *pcount);
> -		if (!ctx.new_val ||
> -		    copy_from_user(ctx.new_val, buf, ctx.new_len))
> +		if (ctx.new_val) {
> +			memcpy(ctx.new_val, *buf, ctx.new_len);
> +		} else {
>  			/* Let BPF program decide how to proceed. */
>  			ctx.new_len = 0;
> +		}
>  	}
>  
>  	rcu_read_lock();
> @@ -1212,7 +1200,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
>  	kfree(ctx.cur_val);
>  
>  	if (ret == 1 && ctx.new_updated) {
> -		*new_buf = ctx.new_val;
> +		*buf = ctx.new_val;

Original value of *buf should be freed before overriding it here
otherwise it's lost/leaked unless I missed something.

Other than this BPF part of this patch looks good to me. Feel free to
add my Ack on the next iteration with this fix.


>  		*pcount = ctx.new_len;
>  	} else {
>  		kfree(ctx.new_val);

-- 
Andrey Ignatov
