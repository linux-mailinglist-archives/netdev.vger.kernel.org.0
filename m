Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBEF330B94
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 11:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhCHKpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 05:45:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhCHKpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 05:45:01 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128AXrdL053515;
        Mon, 8 Mar 2021 05:44:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=W8IkbW9YdPwCWWCFOFrFcZNiHAICGCXerfEee4vYc/4=;
 b=QO8Gyq2jcnP3nS/keTpMkWZIHpY4GJDeotX/QeQfk3su6Xo74JDy4h8D7kfwFHPMkMR4
 EJC0j+swNsMTqwMNbjYErOtkP5KaDP3lhL6JVK/zKBk/Z/RJB6J2H761E6iOLiUkqpjc
 j5IN5k2pcRqAZRpwemGQaw8zQH1LXpzj2du6g/YhtysZ1XfzdiwY//ZPaL+1HcGE67iR
 NCEy1myL6Jrw3izJ4zoluFBKMvBNmuj7caIKjJRQTA8KV6bvUXk1m0VIsWl+M+VvzkMq
 7fnobTQrjxpx7RL/aWG2ObMYw1CmAG4Z4ArqPpqZfIyk8it4X03ZqIZs7jiMZXdpO7Oz vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3757wwe54w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 05:44:42 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128AZxra063870;
        Mon, 8 Mar 2021 05:44:42 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3757wwe549-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 05:44:41 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128AggRl032206;
        Mon, 8 Mar 2021 10:44:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3741c8gw7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:44:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128AibxI46793062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 10:44:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 402B4AE045;
        Mon,  8 Mar 2021 10:44:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C86D2AE04D;
        Mon,  8 Mar 2021 10:44:36 +0000 (GMT)
Received: from localhost (unknown [9.77.201.1])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 10:44:36 +0000 (GMT)
Date:   Mon, 8 Mar 2021 16:14:33 +0530
From:   "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
Subject: Re: [PATCHv2 bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
Message-ID: <20210308104433.GC145@DESKTOP-TDPLP67.localdomain>
References: <20210305134050.139840-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305134050.139840-1-jolsa@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_04:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/03/05 02:40PM, Jiri Olsa wrote:
> When testing uprobes we the test gets GEP (Global Entry Point)
> address from kallsyms, but then the function is called locally
> so the uprobe is not triggered.
> 
> Fixing this by adjusting the address to LEP (Local Entry Point)
> for powerpc arch plus instruction check stolen from ppc_function_entry
> function pointed out and explained by Michael and Naveen.
> 
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/attach_probe.c   | 40 ++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)

LGTM. FWIW:
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

Thanks,
- Naveen

