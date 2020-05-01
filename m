Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B56B1C0E00
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 08:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgEAGZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 02:25:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28830 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728126AbgEAGZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 02:25:39 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0416Eqm2000492;
        Thu, 30 Apr 2020 23:25:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hIElppGZapH9Ibt07sfWnGMgQNSXBhns7rALbuG3/T8=;
 b=XBcxG/hNO/IWS8JeYOhiSP0jc++jeHdKYatj+HeefeslzePKcDRlha5MiN3HFt9XzyXg
 JUUq57wNtrE+71XOCdgFuDK6r7nqummlsf8lGy+B2qOrrT8qyb0+Fv0ibGwXnAE33w8U
 8I/B/5/lLBuSYs/76UL45wNHj5zLGRANv0c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30r7ea9vpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Apr 2020 23:25:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 30 Apr 2020 23:25:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xaj9dkzon1dEDlhj5BECbkuR4yczkWz89D0yk6FKDsgxsduxKr5puuj4v2GuXuIA4KJvedLlJJuf4PWDy/OvxDjCEjEuh+uFNYvopMrSG+5djYZ4LgU7a7nII3C6cIQEnkLIB6j21leF5w7w96atcs1HUzl2fd+S9H8B/hnLknq92ZfGcQJSfb02HCZhWDsl7AR/hykGgw3zVDGminHV6Z2dSkVJKCpg4HOIltUfRHq0fkkc8ZTcrNYTs3HeVnGIXof+3zpDWu6CuluDRcLajUKPlLy0AKXZH3Xdj3D1w3alY/BPrcOiExDRIPW6AOG8tbQUBpjTaxqoCoLhWSKwFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIElppGZapH9Ibt07sfWnGMgQNSXBhns7rALbuG3/T8=;
 b=W79H/3oWeDE8IURBUeCTruy7A1u5iKUJRUz18/yEbcYz4Q9UodtEdxa3o4iov2+LmOhe4TGMdH+KIJ3Vco57t32qtApIAUw2GcG0z1hKjeRN/gPGss5hIIILE4C7ogwDEZF4fN6vwz+8cafyEslqJUgOhmVWHrDNW9CtrUtzXUG4emPNZwl+P9FaCPq4rZLGRdle9myNEQ7nhdF325RgNmGoZ+l+qc2s2ef6mPurRSeuL58hk6q0dX+Vxz2gtfv5Bnc2UbtYk1h+x7fBmFzJ3nwkUVg6BOzV+zZX2JVgkXqnbVQq7iJPy/2C9pHJ9OMcbvARQKTY7LBugSykJmhTzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIElppGZapH9Ibt07sfWnGMgQNSXBhns7rALbuG3/T8=;
 b=lQaMuzelaeIuxyzzg4VRdcEpi0Az0cO+RfWCziwSoOH+g7cBeBrs5tZclmuFVKx3Z5PLSLEBuNtmVEdbgMYNaVTyoEx331q5xkd5/0HF4x/NrOYaP/yWrqJ3NFzP+84SSTnKbMOU8UmqxSfUJGXdMmCGhLmo+aIID2rG2Gr+hrY=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3884.namprd15.prod.outlook.com (2603:10b6:303:42::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Fri, 1 May
 2020 06:25:24 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.020; Fri, 1 May 2020
 06:25:24 +0000
Date:   Thu, 30 Apr 2020 23:25:21 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>,
        <syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] bpf: fix use-after-free of
 bpf_link when priming half-fails
Message-ID: <20200501062521.2xruidyrtuxycipw@kafai-mbp>
References: <20200430194609.1216836-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430194609.1216836-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR17CA0060.namprd17.prod.outlook.com
 (2603:10b6:300:93::22) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:da9a) by MWHPR17CA0060.namprd17.prod.outlook.com (2603:10b6:300:93::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Fri, 1 May 2020 06:25:23 +0000
X-Originating-IP: [2620:10d:c090:400::5:da9a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c8cf6ba-fd90-4ea4-3ebc-08d7ed986e3a
X-MS-TrafficTypeDiagnostic: MW3PR15MB3884:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38847C7D6DDE3DAAAC0D1489D5AB0@MW3PR15MB3884.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Q1b1btKW9R4Ck95hU1OTWFgN/hmt235sy8P6WLQHjJF+lpNODW31cx7I3ozkKIiEauXkVsPHyX+U8A13zBqR5hkmbXrueslrfp107rphQ1EzqRTAf2vBdGdarJCbx5jtM4k4eAy5X9J5Cy/6KtZD5zqN/tL/f/M1t9JzCrC45zHnRiyDjfvlZC+Ug2Xf3fo9VavdUUl+N8LkFlEuFYGzHyJ4BCwkkndjNU99XRL99O2ddXYqKy27nDsZ0+tJZlPiIV4FKZgWLV15LBg9og7yupYipxAz93VTGpdklk1sZ2/gQPOpPMDxqDCN6702R27UisEzIOytaGpDpy1r4D81kS4kFcYQd1vxaDONQr+mKHvM8xl3geV2XIRSVe8jeXQXu5B/mYv4c3BFuBUjOwhcRK/0Q3YxsE+g64eirORKSuxJJof1r4MUKB5HX7tBGnD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(8676002)(8936002)(16526019)(186003)(55016002)(33716001)(6496006)(52116002)(4326008)(9686003)(316002)(6862004)(1076003)(86362001)(5660300002)(478600001)(2906002)(66556008)(66476007)(6636002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0WaBnjwi7D+35espMBT453c1+qjsSg0YZlo9UIa0HJh6bDjdq4q8YhBpOKIqD1VQKTWTHvhV42DZvvpfqAiPvdBgRnM0rX1TtxSXu52tEkRk6iuwzTy4Gn7k2cawUBLlURXMLCIU1O0OjNrpPMX/gatsilUsWe1tfx1ESXgX0cC4qrMODCISkdkRTuetAw7yyF6VXHw9fM+3B1L4BsiNQ/aMu1Jyo1TD9+58/Zr8ojalo5FUyCuRQdonM3mXRcDsPffo7O60059R26ICbmGF6W2l1tWo5pRNQeRxVD4Fly6NkNl8BJaXjn4hba8aTJx8Mhr5yLdp5r2mlTB3q8JM/WRotEriaz7Fxbluj9y13IogqXPDo+wPJOqwkn5cjsdg6Jfvxx1rrd+ebTD5RVbTr3r4ExR5vF7OkPn+u0xfRNGw0odTWDa2i8/A0Pr/3qIhJN6FfiIMmQyctdCjMCnfKLjEpz9iewYhru8brmNfBH3pJrnOjVLAF1S/UeLUYMOO+1ayEaz8tJ98JY1hJTpVLZE3Pbx5hG8uvNIBXrYrtn1AitWfpkSTRFTY74Q/BukTXNgr9N1U/gokS4lChLSeMPmoEvjAWnd6t+E5Xfb6uFWpGKIMEBPNFpXVZhpLeLUGZfjZQpzKMnoHAvffkra0sVohzkuWMPCDayOJPAzWPinUuktFVsMjccMlZ4RrBCilljWBoqqV7D4nDXqTk20OfSU54g3gOCgdFuxxvuJWFXs6r9hyfks9r07luSUaAddnRkR/lVkmEgs5sbFC54h4Te7fIWwRWDE5iJ/Xdjq2yWPMV70mDqJXOjCSzSa4LqoFCJyb7s4J5CN5NjWdNKx+ZQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8cf6ba-fd90-4ea4-3ebc-08d7ed986e3a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 06:25:24.0628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzUPvoAu6B4qtcIiz0uf+07PEakZhLtF+sWq39t+YGjd5FUiGZ3ROUV4hK7Wvm57
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3884
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_01:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=762 bulkscore=0 priorityscore=1501 clxscore=1011 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 suspectscore=2 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 12:46:08PM -0700, Andrii Nakryiko wrote:
> If bpf_link_prime() succeeds to allocate new anon file, but then fails to
> allocate ID for it, link priming is considered to be failed and user is
> supposed ot be able to directly kfree() bpf_link, because it was never exposed
> to user-space.
> 
> But at that point file already keeps a pointer to bpf_link and will eventually
> call bpf_link_release(), so if bpf_link was kfree()'d by caller, that would
> lead to use-after-free.
> 
> Fix this by creating file with NULL private_data until ID allocation succeeds.
> Only then set private_data to bpf_link. Teach bpf_link_release() to recognize
> such situation and do nothing.
> 
> Fixes: a3b80e107894 ("bpf: Allocate ID for bpf_link")
> Reported-by: syzbot+39b64425f91b5aab714d@syzkaller.appspotmail.com
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  kernel/bpf/syscall.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index c75b2dd2459c..ce00df64a4d4 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2267,7 +2267,12 @@ static int bpf_link_release(struct inode *inode, struct file *filp)
>  {
>  	struct bpf_link *link = filp->private_data;
>  
> -	bpf_link_put(link);
> +	/* if bpf_link_prime() allocated file, but failed to allocate ID,
> +	 * file->private_data will be null and by now link itself is kfree()'d
> +	 * directly, so just do nothing in such case.
> +	 */
> +	if (link)
> +		bpf_link_put(link);
>  	return 0;
>  }
>  
> @@ -2348,7 +2353,7 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
>  	if (fd < 0)
>  		return fd;
>  
> -	file = anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC);
> +	file = anon_inode_getfile("bpf_link", &bpf_link_fops, NULL, O_CLOEXEC);
>  	if (IS_ERR(file)) {
>  		put_unused_fd(fd);
>  		return PTR_ERR(file);
> @@ -2357,10 +2362,15 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
>  	id = bpf_link_alloc_id(link);
>  	if (id < 0) {
>  		put_unused_fd(fd);
> -		fput(file);
> +		fput(file); /* won't put link, so user can kfree() it */
>  		return id;
>  	}
>  
> +	/* Link priming succeeded, point file's private data to link now.
> +	 * After this caller has to call bpf_link_cleanup() to free link.
> +	 */
> +	file->private_data = link;
Instead of switching private_data back and forth, how about calling getfile() at end
(i.e. after alloc_id())?

> +
>  	primer->link = link;
>  	primer->file = file;
>  	primer->fd = fd;
> -- 
> 2.24.1
> 
