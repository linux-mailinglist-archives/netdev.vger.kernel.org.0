Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB73218C70C
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 06:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgCTFeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 01:34:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgCTFeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 01:34:18 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02K5QTAY000508;
        Thu, 19 Mar 2020 22:34:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qPMqL8gw4bZd5CW6DSK9yvCKmjepeDI0NRJAwp2MUbY=;
 b=gtXZ3bakOfCKEh8gr6K4JftTnFonUi4DMCDOaefIyndptIzos+2oBBOX7TadYobfB6WP
 S4SovhMhynHkBT/4GMwYhzDbJhyJPZZ6N/EBVFQ1wVQwTwoAda1BrpXpV0YwW2eIbY00
 90jBqYZrMU4151kkQJ+BAF5kwEO+h84gyCk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu7qamh44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Mar 2020 22:34:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 22:34:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRhGYGIS5yDLjjC1FPnQQmgoO5NuEs3K7ZlIZ6uXYV74nXMFZ74l/hxC3Rc3DgcEZRwJWZ6bsQEG+n9LoEJKZABob2pTfXcgMJxTCzorYIIimw6PaUOWRSAXEeb4AOR/oA6oR0EpjEtyhzW5JjPEO5VckreVKNGjpXynh/lbo1mX04vIZ0pBxjjrX5vDtMQGKCEWBvgToqmKHyvCtkoFmYO8oWyadvoHBc5+jcyhiCBL54VMKKc8gMtGbqs7SX1shPVmeX0O3x3mHE2PsQhNW2TWeF6G53hDxlVEBZbMcS//DtXABqjBume61Mt/0V/uzVd6XrQHZtoZJoiu7/87ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPMqL8gw4bZd5CW6DSK9yvCKmjepeDI0NRJAwp2MUbY=;
 b=aCfh3Az5YHsxEimHT77cv9ce0vgaF7QfzX0kFgxZUq2PLMPQdW6WQqG6NdSuYHuoKo06aMOYtro9AF5Ihfch6cyStyFzigQqUEsHLWXS2pbYc/3c9FIF6DRzwRaOnODkfzv5HCCUAR7Poev0rtu52VGgtCqpHQDgbP2zRkwQctB0wAcGuWwZF8sJhWqzNHTm3RHIAn6QBdJXDfJUz6qoX4PfO7M7meLe+sEDGUUtdXfeX/mRyzddYPsxGEu1lreT413R3IybpWxGrL3vSGf/Ch+GJ6Jgj2MnQMMqjM3DViD6WltJZP6eZK6h1DNYYcOXR8eElP//F1lvA//PdZzWTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPMqL8gw4bZd5CW6DSK9yvCKmjepeDI0NRJAwp2MUbY=;
 b=ZBGP8tLRFfGaINKnBXkvcRVyRzI5Rh7FguHdafUFVbp+mVdrDOzc1Z4Fl8GKguqwSXcBwve22UFJCQ1kyam6tVgRCG/vswkhLNtwkpGO+eC+wemn9iQJni4P6lPR2j5IoEqZ1vYVGVu/OtCTg1XSuANqsIwX6R8tV3uT8wcUzdU=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3125.namprd15.prod.outlook.com (2603:10b6:a03:fc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Fri, 20 Mar
 2020 05:34:01 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Fri, 20 Mar 2020
 05:34:01 +0000
Date:   Thu, 19 Mar 2020 22:33:58 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/2] bpf: Add tests for bpf_sk_storage to
 bpf_tcp_ca
Message-ID: <20200320053358.kkjljdhd4wh6l5nc@kafai-mbp>
References: <20200319234955.2933540-1-kafai@fb.com>
 <20200319235008.2940124-1-kafai@fb.com>
 <dbf97cdd-9daa-6164-50d4-576dbb9ed3e4@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbf97cdd-9daa-6164-50d4-576dbb9ed3e4@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR12CA0030.namprd12.prod.outlook.com
 (2603:10b6:301:2::16) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e366) by MWHPR12CA0030.namprd12.prod.outlook.com (2603:10b6:301:2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Fri, 20 Mar 2020 05:34:00 +0000
X-Originating-IP: [2620:10d:c090:400::5:e366]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a32ab19-9294-4b3e-0ca5-08d7cc904b9e
X-MS-TrafficTypeDiagnostic: BYAPR15MB3125:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB31259405CE42E4B3D9FE49C6D5F50@BYAPR15MB3125.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(136003)(366004)(346002)(199004)(478600001)(186003)(1076003)(55016002)(66946007)(5660300002)(66476007)(9686003)(66556008)(16526019)(4326008)(316002)(6862004)(86362001)(53546011)(2906002)(8676002)(52116002)(33716001)(81156014)(8936002)(54906003)(6636002)(6496006)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3125;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jQwCEQD2XRm2DKLEvvk7C1F29cJse40cP7UModPZGWS0gAwU+mvJfImu6DE4CFT0OB3KcuBO/gG1FbQDKZ8QhO2co+n01VGZ2wunW37SvkL7zQG+F6eUeksg/ztEDB72kkBAHG4zM0xX+mxacnLzHzESalYfJbvE/lXZYTKyIFS6Ln6YmI4hvyG23oDHE3B2fiej6rKXYMGokVS7a1lxcT4D0hF/nmCDluhZRIbm0BxlfY7ibI9/yo0W776UrsUPi2a8/o24QXr5LVJUSzL3HTqIS640IrP+fGKd4MjM3ai2mmV02xEugoFVJyHqyOpMmTAe/xZGFIe1KbYgDWPVTsheSeFw3oLgSiY6SReXhVXEw8p5hC2KJV0QlWB8o9/TNLVJPp76QLH2F97x0M22xTHZ+7RHT/DcIWl0Pi2IVe8OmhhprY/YYHlbwnOfcp8I
X-MS-Exchange-AntiSpam-MessageData: tLR350dCAJ/XuV9enwAPjjM3dkbEgjjnAcYJ2MzQolJ/wQtlLmd+/xxnzUJJ72X8XNq6Ttbo5YOZGRNYyhjCRhP1AiJyEzPXxg4+0MrNXEPfweg0A1mU3MOTcvtXaoeEmvmco+L3u1eG8Ngm//fIJNJa1ThIThQ9qRBcYyHawEII3D/s75SElXHRQ2q2IOfH
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a32ab19-9294-4b3e-0ca5-08d7cc904b9e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 05:34:01.6128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNLHoaohfg/LJ7VzkBC9P4Z4clgKRy00pmP+qsFtVhDcb+8E6SOw5gMDs/aoTEjD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3125
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_01:2020-03-19,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003200023
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 08:49:22PM -0700, Yonghong Song wrote:
> 
> 
> On 3/19/20 4:50 PM, Martin KaFai Lau wrote:
> > This patch adds test to exercise the bpf_sk_storage_get()
> > and bpf_sk_storage_delete() helper from the bpf_dctcp.c.
> > 
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >   .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 28 +++++++++++++++++--
> >   tools/testing/selftests/bpf/progs/bpf_dctcp.c | 16 +++++++++++
> >   2 files changed, 41 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > index 8482bbc67eec..9aaecce0bc3c 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > @@ -11,6 +11,7 @@
> >   static const unsigned int total_bytes = 10 * 1024 * 1024;
> >   static const struct timeval timeo_sec = { .tv_sec = 10 };
> >   static const size_t timeo_optlen = sizeof(timeo_sec);
> > +static int expected_stg = 0xeB9F;
> >   static int stop, duration;
> >   static int settimeo(int fd)
> > @@ -88,7 +89,7 @@ static void *server(void *arg)
> >   	return NULL;
> >   }
> > -static void do_test(const char *tcp_ca)
> > +static void do_test(const char *tcp_ca, const struct bpf_map *sk_stg_map)
> >   {
> >   	struct sockaddr_in6 sa6 = {};
> >   	ssize_t nr_recv = 0, bytes = 0;
> > @@ -110,6 +111,14 @@ static void do_test(const char *tcp_ca)
> >   		return;
> >   	}
> > +	if (sk_stg_map) {
> > +		err = bpf_map_update_elem(bpf_map__fd(sk_stg_map), &fd,
> > +					  &expected_stg, BPF_NOEXIST);
> > +		if (CHECK(err, "bpf_map_update_elem(sk_stg_map)",
> > +			  "err:%d errno:%d\n", err, errno))
> > +			goto done;
> > +	}
> > +
> >   	if (settcpca(lfd, tcp_ca) || settcpca(fd, tcp_ca) ||
> >   	    settimeo(lfd) || settimeo(fd))
> >   		goto done;
> > @@ -149,6 +158,16 @@ static void do_test(const char *tcp_ca)
> >   	CHECK(bytes != total_bytes, "recv", "%zd != %u nr_recv:%zd errno:%d\n",
> >   	      bytes, total_bytes, nr_recv, errno);
> 
> Should the control go to "wait_thread" here if failure?
Thanks for the review!

I did think about that.  I did not bail on this because the
sk_stg_map check below does not depend on the about check.
Hence, I didn't bail here.  I moved the sk_stg_map test
to the very bottom is for this reason also.

Since you asked, I think it makes sense to go back to my first
approach which is to do the below test immediately after
connect() and just bail there.

I will also take this chance to postpone the thread creation
after connect().

> 
> > +	if (sk_stg_map) {
> > +		int tmp_stg;
> > +
> > +		err = bpf_map_lookup_elem(bpf_map__fd(sk_stg_map), &fd,
> > +					  &tmp_stg);
> > +		CHECK(!err || errno != ENOENT,
> > +		      "bpf_map_lookup_elem(sk_stg_map)",
> > +		      "err:%d errno:%d\n", err, errno);
> > +	}
> > +
> >   wait_thread:
> >   	WRITE_ONCE(stop, 1);
> >   	pthread_join(srv_thread, &thread_ret);
> > @@ -175,7 +194,7 @@ static void test_cubic(void)
> >   		return;
> >   	}
> > -	do_test("bpf_cubic");
> > +	do_test("bpf_cubic", NULL);
> >   	bpf_link__destroy(link);
> >   	bpf_cubic__destroy(cubic_skel);
> > @@ -197,7 +216,10 @@ static void test_dctcp(void)
> >   		return;
> >   	}
> > -	do_test("bpf_dctcp");
> > +	do_test("bpf_dctcp", dctcp_skel->maps.sk_stg_map);
> > +	CHECK(dctcp_skel->bss->stg_result != expected_stg,
> > +	      "Unexpected stg_result", "stg_result (%x) != expected_stg (%x)\n",
> > +	      dctcp_skel->bss->stg_result, expected_stg);
> >   	bpf_link__destroy(link);
> >   	bpf_dctcp__destroy(dctcp_skel);
> > diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > index 127ea762a062..5c1fc584f3ae 100644
> > --- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > +++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > @@ -6,6 +6,7 @@
> >    * the kernel BPF logic.
> >    */
> > +#include <stddef.h>
> >   #include <linux/bpf.h>
> >   #include <linux/types.h>
> >   #include <bpf/bpf_helpers.h>
> > @@ -14,6 +15,15 @@
> >   char _license[] SEC("license") = "GPL";
> > +static volatile int stg_result;
> 
> "int stg_result = 0;" should work too.
will use.
