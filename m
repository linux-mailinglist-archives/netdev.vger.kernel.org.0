Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375E12BBC50
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKUCn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:43:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20510 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbgKUCn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 21:43:28 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AL2eVHN000747;
        Fri, 20 Nov 2020 18:43:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Sn5Mdnzzm1LB96/69gXBNj8A2kpa9h8LFdeIqTa5aTc=;
 b=MtGkW90JuLQzNNR/jnrWT9xPBJ99g7WVBd0Yi/g0FtRrin55c5SAebIZqTOagg6xwBI9
 b8H6xEZvXRrygVSzFCQDZREo65hYxAS6QAS6art/tQJtpAbXzCU6/Yj1uSj0qHXpXDVp
 iYH4alsjxCfQhpxSdG/7iQUGPg0ar96EPeM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wx1ss12c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 18:43:05 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 18:43:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/rOWf1Q5cD5Qt5o5d8qyXWN55c8r8BCXcHD6SI0ftEaj5bNJuVD+0LtTferaA9HRaiRO40pXmXG5l09zD4mlToeCYdE/B8UPFmZJNbdSj6OcQnpGdIemnR+p+oTIqacISIygeNP9Ye+p/jMZX73Bm9xiEgiNuNRxw9GDih5gYEBYh/oTvUljTkZ3qdkjV8kacOl0MzxZ5/9hhIcQPcGSu51MjrzGc9FJLYzdTm2L7fk1jgFlj6SskConDBntLwZDcSJyDp937FKtU33KngxF5bZgBe9L0rHUWJUdrfQRMT/fz1A/3jpAOCmWB4PnzQfHgb0uaTL+c/QRuyET+GEfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn5Mdnzzm1LB96/69gXBNj8A2kpa9h8LFdeIqTa5aTc=;
 b=NgWQceGe7mr4DDjmTLboaZBuJuRWn3N01xpGZj+WWibX8CbcrbhNj14ZV/KfnLGzKF5SYiDmONqMbFah/QN3TUmx9CjYExZIIrEar8yNY2LFF9VvarWpVg1xHnGPDO3rN6/FQFLIpbBfmCE1/0dHv6ony6Os1veOsjORcEQMDf0eKAligwkJRMzwYqtQpaMvghMIADNTIjDdQXVQXQNuCEsVdIyOSfvMlsXLTXeZZGEbAk/EWS3LL0iuYcYhIMXluL6sTL7d0QLGaxhLIvNhF3pEHqSiHhyE0aVXIHGhzDNDbOweMQnxzqji8zaI6r8Cval6Mrbkn4zyFLr/uGTIiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn5Mdnzzm1LB96/69gXBNj8A2kpa9h8LFdeIqTa5aTc=;
 b=L6s1l0e4uYVUP7EvifGIuonrsrTeSLPoG2Zd8RKHOG+bp+4Kd0R4S1b8jqwM68IvMey8F7D4z/DRdYMVhQeZL78p+/vbqFfciAsvOzZUqM/oaVcC2R7KnDfaEkc/jVcKxpQRmDq/T9ferCidGDqFUmZSl3yF31XZ/l2UGeMuFC4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3510.namprd15.prod.outlook.com (2603:10b6:a03:112::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Sat, 21 Nov
 2020 02:43:02 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Sat, 21 Nov 2020
 02:43:02 +0000
Date:   Fri, 20 Nov 2020 18:42:53 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 1/7] samples: bpf: refactor hbm program with
 libbpf
Message-ID: <20201121024227.orabmvy76esenpsf@kafai-mbp.dhcp.thefacebook.com>
References: <20201119150617.92010-1-danieltimlee@gmail.com>
 <20201119150617.92010-2-danieltimlee@gmail.com>
 <20201121023405.tchtyadco4x45sf3@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121023405.tchtyadco4x45sf3@kafai-mbp.dhcp.thefacebook.com>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MW4PR03CA0128.namprd03.prod.outlook.com
 (2603:10b6:303:8c::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MW4PR03CA0128.namprd03.prod.outlook.com (2603:10b6:303:8c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Sat, 21 Nov 2020 02:42:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af8956ed-1964-4077-fc12-08d88dc72971
X-MS-TrafficTypeDiagnostic: BYAPR15MB3510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB351006B0F78573945B5F43B0D5FE0@BYAPR15MB3510.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: An8jlihF6gE3EJ1MXU3hPoz1qjo1JzsLPCQb0Mloa5cR193XHCi4UwXU8z6b1+dji+cjeK/T0FYGIHYYYSxW+mEJMJfAkOtS1ZlFpslZ9uBV5kF+T7Yu6Qd4+Z4SIKc1tCzhnh1NcS2h7z5TKBT0Pt2A7Dfai7GWajj5vqNyCFCLVVk4SoN029KRJZZLu+oD6fN79u7Vuz2TaszgEM5kjcP3KEJP58RqC2OYPBTzKXmuSd16TTCSJeHEtqXuyNTpPWrdqcvrv06pOtvF5Mgx0gclZJR40wixNim7FPnlFspdUC503c9Mbm3BIRUFpEQ5/lspRmHWXsszOXR6hhIFhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(39860400002)(396003)(8676002)(8936002)(54906003)(6506007)(316002)(16526019)(186003)(1076003)(83380400001)(7416002)(55016002)(6916009)(478600001)(7696005)(6666004)(5660300002)(52116002)(66556008)(86362001)(4326008)(66946007)(2906002)(9686003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GnW12vTVSIjMDc5AxL3xQGv5zfheaGTn89KTpG0eXsoS9vgNFcOqcmPW3q0WGx2Q4M28T7CuXyqKBJoDtOaxM+IyfVsMNFJEBzqrr6ztRWI271cXwwkuyA/H5u9Py3V1e9/9Ni1357S/uTlyLsaZrcoknjtgBmSII15Y5EF7ZC19YQe10Ls6IRDWlx3AXp4PlFwljgbeQ47Ix0lT7wpVJAxdKSP/Ap6cZal/FLO9/oMOKR//TcBrpIBoVjhewcglmT/JRa4XLkOQEHVfovH7Q0p+98zxVMZSjoEJtAAQheMVuZFAHQa4ZlyZfIdPybQc3KYdL4WbUprWcccE6u5pjMpljNJnusskQ5iuAr0lI39ySU/Dz8O2oSfgYIQ+PEzg/cYzK6q1HfT9z/8cqfrQycq6aTS8azUN2+3FPvWRbuo5fScsxEBxXYzczC7AEiK+7ZIo+ALqfYRIstwUbvvdu5Azqs5s6Iphbe5sl744DAytkSX0GdQCb4ou+jsk2QlopujuR5wxjaf7Khw3HWmsfICsOJ3Lhnq74uQ9U4SNcA5IzWOJqlZN/IhSEUge/tb3MgduDbjAgXesSK0xHOUn6tOO/XET5N7lWwoumxkkNYZ7PEmYfmFdK3ZMuSBmFdX8CecRzeJMqUtH5mcUm2AY7joQq1l6FbdPunl75u32z3fSxK22fAn8ykq5Uyk9dEAy82k41NdQFVOxOb+QM/eLMG5/rzPjNjsyTPF+X2mcJKtqDbsu7D64MLjoR+jXuqnlWmJuBa9TZp33SWWvHIsHYR6UghdraePwi3aMZxsQ/nMz6/8vrPuGoGBIfiDQ/t7k2mNKTeYcMNJCA0mrdllii6zQnQ/VJwROHZdJUwMVsYvzgRwyuCcw7uN3zOwZcTB4PAFexYnQaG7KmpHFfFqxQKBbB/MbShFUyG3Q51mylAYEBmgd6/nP9b3+0nzFKLxy
X-MS-Exchange-CrossTenant-Network-Message-Id: af8956ed-1964-4077-fc12-08d88dc72971
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2020 02:43:01.1996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQ7w4TYzRHCZJMj0WSlIvYsgZL/UQsXNPjklZoY5HiAwgOaAVVKTGWn5Er4yDipX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3510
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_17:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=1 malwarescore=0 adultscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011210019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 06:34:05PM -0800, Martin KaFai Lau wrote:
> On Thu, Nov 19, 2020 at 03:06:11PM +0000, Daniel T. Lee wrote:
> [ ... ]
> 
> >  static int run_bpf_prog(char *prog, int cg_id)
> >  {
> > -	int map_fd;
> > -	int rc = 0;
> > +	struct hbm_queue_stats qstats = {0};
> > +	char cg_dir[100], cg_pin_path[100];
> > +	struct bpf_link *link = NULL;
> >  	int key = 0;
> >  	int cg1 = 0;
> > -	int type = BPF_CGROUP_INET_EGRESS;
> > -	char cg_dir[100];
> > -	struct hbm_queue_stats qstats = {0};
> > +	int rc = 0;
> >  
> >  	sprintf(cg_dir, "/hbm%d", cg_id);
> > -	map_fd = prog_load(prog);
> > -	if (map_fd  == -1)
> > -		return 1;
> > +	rc = prog_load(prog);
> > +	if (rc != 0)
> > +		return rc;
> >  
> >  	if (setup_cgroup_environment()) {
> >  		printf("ERROR: setting cgroup environment\n");
> > @@ -190,16 +183,25 @@ static int run_bpf_prog(char *prog, int cg_id)
> >  	qstats.stats = stats_flag ? 1 : 0;
> >  	qstats.loopback = loopback_flag ? 1 : 0;
> >  	qstats.no_cn = no_cn_flag ? 1 : 0;
> > -	if (bpf_map_update_elem(map_fd, &key, &qstats, BPF_ANY)) {
> > +	if (bpf_map_update_elem(queue_stats_fd, &key, &qstats, BPF_ANY)) {
> >  		printf("ERROR: Could not update map element\n");
> >  		goto err;
> >  	}
> >  
> >  	if (!outFlag)
> > -		type = BPF_CGROUP_INET_INGRESS;
> > -	if (bpf_prog_attach(bpfprog_fd, cg1, type, 0)) {
> > -		printf("ERROR: bpf_prog_attach fails!\n");
> > -		log_err("Attaching prog");
> > +		bpf_program__set_expected_attach_type(bpf_prog, BPF_CGROUP_INET_INGRESS);
> > +
> > +	link = bpf_program__attach_cgroup(bpf_prog, cg1);
> > +	if (libbpf_get_error(link)) {
> > +		fprintf(stderr, "ERROR: bpf_program__attach_cgroup failed\n");
> > +		link = NULL;
> Again, this is not needed.  bpf_link__destroy() can
> handle both NULL and error pointer.  Please take a look
> at the bpf_link__destroy() in libbpf.c
> 
> > +		goto err;
> > +	}
> > +
> > +	sprintf(cg_pin_path, "/sys/fs/bpf/hbm%d", cg_id);
> > +	rc = bpf_link__pin(link, cg_pin_path);
> > +	if (rc < 0) {
> > +		printf("ERROR: bpf_link__pin failed: %d\n", rc);
> >  		goto err;
> >  	}
> >  
> > @@ -213,7 +215,7 @@ static int run_bpf_prog(char *prog, int cg_id)
> >  #define DELTA_RATE_CHECK 10000		/* in us */
> >  #define RATE_THRESHOLD 9500000000	/* 9.5 Gbps */
> >  
> > -		bpf_map_lookup_elem(map_fd, &key, &qstats);
> > +		bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
> >  		if (gettimeofday(&t0, NULL) < 0)
> >  			do_error("gettimeofday failed", true);
> >  		t_last = t0;
> > @@ -242,7 +244,7 @@ static int run_bpf_prog(char *prog, int cg_id)
> >  			fclose(fin);
> >  			printf("  new_eth_tx_bytes:%llu\n",
> >  			       new_eth_tx_bytes);
> > -			bpf_map_lookup_elem(map_fd, &key, &qstats);
> > +			bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
> >  			new_cg_tx_bytes = qstats.bytes_total;
> >  			delta_bytes = new_eth_tx_bytes - last_eth_tx_bytes;
> >  			last_eth_tx_bytes = new_eth_tx_bytes;
> > @@ -289,14 +291,14 @@ static int run_bpf_prog(char *prog, int cg_id)
> >  					rate = minRate;
> >  				qstats.rate = rate;
> >  			}
> > -			if (bpf_map_update_elem(map_fd, &key, &qstats, BPF_ANY))
> > +			if (bpf_map_update_elem(queue_stats_fd, &key, &qstats, BPF_ANY))
> >  				do_error("update map element fails", false);
> >  		}
> >  	} else {
> >  		sleep(dur);
> >  	}
> >  	// Get stats!
> > -	if (stats_flag && bpf_map_lookup_elem(map_fd, &key, &qstats)) {
> > +	if (stats_flag && bpf_map_lookup_elem(queue_stats_fd, &key, &qstats)) {
> >  		char fname[100];
> >  		FILE *fout;
> >  
> > @@ -398,10 +400,10 @@ static int run_bpf_prog(char *prog, int cg_id)
> >  err:
> >  	rc = 1;
> >  
> > -	if (cg1)
> > -		close(cg1);
> > +	bpf_link__destroy(link);
> > +	close(cg1);
> >  	cleanup_cgroup_environment();
> > -
> > +	bpf_object__close(obj);
> The bpf_* cleanup condition still looks wrong.
> 
> I can understand why it does not want to cleanup_cgroup_environment()
> on the success case because the sh script may want to run test under this
> cgroup.
> 
> However, the bpf_link__destroy(), bpf_object__close(), and
> even close(cg1) should be done in both success and error
> cases.
> 
> The cg1 test still looks wrong also.  The cg1 should
> be init to -1 and then test for "if (cg1 == -1)".
oops.  I meant cg1 != -1 .
