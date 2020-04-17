Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BECD1AE848
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 00:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgDQWgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 18:36:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54330 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728470AbgDQWgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 18:36:45 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03HMZCkg028626;
        Fri, 17 Apr 2020 15:36:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Xt0l+kTGj3xkgG9RxtQEBFczpL/GKnnzURyl+ApyXgo=;
 b=egilSFY/7QU7dH/TQnqczm4gEDhFWv3LjdKA0Lf2jLbGCFI+6C3e3ysehW1NTD42ZvNi
 Z+PCSXXQ4I0a4f7+OAaSlySxcv0YMMLMWKulEt2nZf4ei2k/qk3DB5IxYg/hbrdAhmzJ
 Xo2ukB0GiTjPQs0G5meoA8FwEsjksWqVli8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30ffg625b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Apr 2020 15:36:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 17 Apr 2020 15:36:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXCk5oG++HwxJdouHN1PASFDi2JJEKqbCtBstXJwv9yB5w4BvhNGTsRGISw2cj+1y3IeGyvMO0hnRhi01sAv1ty2B11LhE5MEk/R0WigMPQptxyOeyqswVt4e4F+W3SjLdCk9hL6AVn/mxuLegG/zTAM981tyncWtH3y3TuqcbqWVC1ukmVzcryM+t2MgtEpyvEbB/yqQTSrZuSOkCt4tM2zVmCtUJLXtWnSHLwdg/eWkv00piuY1znKzshBbSq13wteJ6IZiYfiB31rvftaF3yNluZfKwCfRiBA6fBmMzsuBUnq2TnadGWJZqtj/FZSwPhy6AqFu50GZScilW5JiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt0l+kTGj3xkgG9RxtQEBFczpL/GKnnzURyl+ApyXgo=;
 b=dtSF38KaUXf5Ec6old+h9GqsM1DdHtwEeYO1Xu6MjHMxaSNc8s+m5yYgK9sezFZbep5AZDmOWkTjT87pBLB5jEBepPFXe3BJIkfZ+o5IuhJIyhfqSXqpORkil4L6YnNW4kqRKkEsNtU1DzBdUmxUdnJbek6k9LceRs7ByVXyxGVsp9yt9c1DsaPJGwlYoid5BRyv3GkezoUoG1eFgsTkJsRF1faFpmVTPxgmSuTldeLaoYBeRwQ913tWVtuuQO5v7G5CjjZmVi6RICqomyR8sEhU7g3VA2+MHuSpCfSLHjrJrRJs6A1JPs9d4DuxfQhpQVN64vEyyxT/X68AHdHFqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt0l+kTGj3xkgG9RxtQEBFczpL/GKnnzURyl+ApyXgo=;
 b=YtR2NKqnTjnPUnvLBNEr+UfNdMD+ip6N8W7ESDwk5/s8xEmEOKHLglNlFKC7c0iJpfCxhTYvjsQk7ITZTo8L4I4NYyPMe/QoATvdiZuSvHJw3HPZqBcwGQd45Ux+/X9r24dhsA1UJlgN1Yog8TFkOw+TqxDFf5FZ7Zt9Ym3dLMU=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Fri, 17 Apr
 2020 22:36:22 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2900.028; Fri, 17 Apr 2020
 22:36:22 +0000
Date:   Fri, 17 Apr 2020 15:36:20 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [Potential Spoof] Re: [PATCH 6/6] sysctl: pass kernel pointers
 to ->proc_handler
Message-ID: <20200417223620.GB15155@rdna-mbp>
References: <20200417064146.1086644-1-hch@lst.de>
 <20200417064146.1086644-7-hch@lst.de>
 <20200417193910.GA7011@rdna-mbp>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200417193910.GA7011@rdna-mbp>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR22CA0033.namprd22.prod.outlook.com
 (2603:10b6:300:69::19) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:6540) by MWHPR22CA0033.namprd22.prod.outlook.com (2603:10b6:300:69::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29 via Frontend Transport; Fri, 17 Apr 2020 22:36:22 +0000
X-Originating-IP: [2620:10d:c090:400::5:6540]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0475255-aa0d-4b00-7319-08d7e31fc168
X-MS-TrafficTypeDiagnostic: BYAPR15MB2197:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2197695E8D07A608B232D468A8D90@BYAPR15MB2197.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0376ECF4DD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(7916004)(366004)(39860400002)(136003)(376002)(396003)(346002)(81156014)(478600001)(6916009)(52116002)(8936002)(2906002)(8676002)(9686003)(33716001)(86362001)(66476007)(5660300002)(33656002)(66946007)(66556008)(316002)(7416002)(6496006)(4326008)(6486002)(1076003)(16526019)(54906003)(186003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 63p1A7/dvtJOdatgSzxR0HFmFBWy9yqZMZHDDrQwSx156Jh4cnI/2fRyjTFx3QvDbKQOqsocd+vavu2UG79a2mtVIa8+p6udZd5VenxilhqHdhhJfS3PDmruaVoFvJprY4mtw9QowKe3uDkjVfi9xEBQfLuMBgVVvDlPJLBaifz9O3HLJS82EnicPkgWpAw2qo/xvIkh9RIBuidacMjSi0mzDulaweNL8SunjYMPNZHmc7lZ7ML2QcRtVg74EkAYmNsYoESPxj5BoXqNuNYaQmUjCYfMA8w1wtz5ifm3ejqegED17dT+tlKL+TlP8refGMvlKqq8SnFzk/uaD+rcr+evIPWaV8HeBuiu/a1C1IADwbNdKt/wKItn42epx3FXLvHy9BE0vRSliJj9P4GkpPEzUSOM4a/EELF81vm15yCjzQcg+P0ELQ5U7FSGczk2
X-MS-Exchange-AntiSpam-MessageData: EffABp7TSDqZddNUYiGuBzQ8lpEPPrt8HatJkqkgGFkG/BE/yvofXL0gZU0M6Vgh8fgTtkLV6Mb4E7PNFVsOLvn5+iRAYzl9zq6pXSDktT8ywSVNxDglukLBjGxuXR9Si3uTtHpDBnIXq6/P9dchAhmXlq22h+lZlJhFJOq8BkNv3HbObacGydth8d/hhsc7
X-MS-Exchange-CrossTenant-Network-Message-Id: b0475255-aa0d-4b00-7319-08d7e31fc168
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2020 22:36:22.8431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQFMWZvULrQqu7G6lILymyuogfOOusONsrufRYxjcmI0B5tU3YsrDJeG7khGDLom
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_10:2020-04-17,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 impostorscore=0
 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrey Ignatov <rdna@fb.com> [Fri, 2020-04-17 12:41 -0700]:
> Christoph Hellwig <hch@lst.de> [Thu, 2020-04-16 23:42 -0700]:

...

> > @@ -564,27 +564,36 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
> >  	if (!table->proc_handler)
> >  		goto out;
> >  
> > -	error = BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, buf, &count,
> > -					   ppos, &new_buf);
> > +	if (write) {
> > +		kbuf = memdup_user_nul(ubuf, count);
> > +		if (IS_ERR(kbuf)) {
> > +			error = PTR_ERR(kbuf);
> > +			goto out;
> > +		}
> > +	} else {
> > +		error = -ENOMEM;
> > +		kbuf = kzalloc(count, GFP_KERNEL);
> > +		if (!kbuf)
> > +			goto out;
> > +	}
> > +
> > +	error = BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, &kbuf, &count,
> > +					   ppos);
> >  	if (error)
> > -		goto out;
> > +		goto out_free_buf;
> >  
> >  	/* careful: calling conventions are nasty here */
> > -	if (new_buf) {
> > -		mm_segment_t old_fs;
> > -
> > -		old_fs = get_fs();
> > -		set_fs(KERNEL_DS);
> > -		error = table->proc_handler(table, write, (void __user *)new_buf,
> > -					    &count, ppos);
> > -		set_fs(old_fs);
> > -		kfree(new_buf);
> > -	} else {
> > -		error = table->proc_handler(table, write, buf, &count, ppos);
> > -	}
> > +	error = table->proc_handler(table, write, kbuf, &count, ppos);
> > +	if (error)
> > +		goto out_free_buf;
> > +
> > +	error = -EFAULT;
> > +	if (copy_to_user(ubuf, kbuf, count))
> > +		goto out_free_buf;

This copy_to_user is where the last failing test I mentioned in the
previous email was failing:

> Test case: sysctl_set_new_value sysctl:write ok .. [FAIL]

What the test does is it attaches BPF program that overrides the value
that user is trying to write to sysctl net/ipv4/route/mtu_expires.

User tries to write "606", BPF program overrides it with "600" using
bpf_sysctl_set_new_value() helper.

This leads to kbuf being replaced in BPF_CGROUP_RUN_PROG_SYSCTL call
above with a new buffer allocated inside __cgroup_bpf_run_filter_sysctl.
And when this new buffer is tried to be copied to user here it fails.

In `strace -e ./test_sysctl` it can be seen as:

	write(5, "606", 3)                      = -1 EFAULT (Bad address)

I also verified same with printk.

Changing it to:

	if (!write && copy_to_user(ubuf, kbuf, count))

(basically what Matthew Wilcox suggested earlier) fixes the problem.


> >  
> > -	if (!error)
> > -		error = count;
> > +	error = count;
> > +out_free_buf:
> > +	kfree(kbuf);
> >  out:
> >  	sysctl_head_finish(head);
> >  

...

> I applied the whole patchset to bpf-next tree and run selftests. This
> patch breaks 4 of them:
> 
> 	% cd tools/testing/selftests/bpf/
> 	% ./test_sysctl
> 	...
> 	Test case: sysctl_get_new_value sysctl:write ok .. [FAIL]
> 	Test case: sysctl_get_new_value sysctl:write ok long .. [FAIL]
> 	Test case: sysctl_get_new_value sysctl:write E2BIG .. [FAIL]
> 	Test case: sysctl_set_new_value sysctl:read EINVAL .. [PASS]
> 	Test case: sysctl_set_new_value sysctl:write ok .. [FAIL]
> 	...
> 	Summary: 36 PASSED, 4 FAILED
> 
> I applied both changes I suggested above and it reduces number of broken
> selftests to one:
> 
> Test case: sysctl_set_new_value sysctl:write ok .. [FAIL]
> 
> I haven't debugged this last one though yet ..

-- 
Andrey Ignatov
