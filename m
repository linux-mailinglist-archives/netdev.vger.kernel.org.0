Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F972BBC41
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgKUCeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:34:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45736 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbgKUCeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 21:34:36 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AL2QB2I026335;
        Fri, 20 Nov 2020 18:34:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8JLK+xr+jk+Pxo4jtj854FfKFfA8nJ/B1TN2YgqjOpw=;
 b=Wk7OuHccA0758vZ1fTOMvE6bVSvstbI0W/23MsxDMMjO3DfKYclDQhZ6URPj9jTzhfY9
 +4Ui3htQSzuKVS3lGJI64qdiJ4pYqDmjaq+ExZi0DWVVM7p6gm5nmJPx3KiGgCua+Oez
 MUsnXJaEZ5gqY8k7I8uRxxoi8QGihWu8toQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34xat44w9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 18:34:16 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 18:34:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBcFI8NzkpCtqG1swB9247rw+apb4b8Rv36p96qlOFqxCrQxo0i9jeLjDBof0njh9RDYOs3X1N91xIt3zCice8WzjEu2BS7xoSOQvkFYBo++iN+PRsZCbOSbSnS3cbfCFWr5uhL5J1g1b49R87M9gMupbebaoPfjcuF//dpdQeKXfr7xmxeCx5u2BbQvYr1CbeerUlL401jtNZRIFaFLrnJFVExYovnfYQW1Rvd4iy5EZYWv8qBtwceFmS3FUMPSWmAVOpcqfB9rZXD8I6BLMCr9wUlNxyyV3KjGyFFlm8W+Us+tju5nC5YhIP4uGNXi8tvWAM4mfL+x9+MYcKdV+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JLK+xr+jk+Pxo4jtj854FfKFfA8nJ/B1TN2YgqjOpw=;
 b=D323x3ZdcEle0OajP7cakBhc4Ksb3Sx4ju8zrp5k7vbdI5LQ39s0t4gbzH5S6Vh1dof165lklP9p0vDLlDCJI+FAhIJiVm10GeeEJ55n/SSdlWuaDxnMsnmhd1LNUhTEbAZc7YtKKBKAY1oPNIuj8PWBdIBIyWvMjg4viDhQ5x6ay43gHBpmTSPJR6dURcdJj+/g2TbmweStZ5WSOBo+q3Kvnyo550tnUS9RKB+0i3CuI8F0LocVXAq2DdX2x8i0Hq0Hqg6zTYytg5eWgwIiLO+2VajXOyAUFSq/jEzppdfd9OtyWRvp5cDvOj54uPaoNRUT25V+08DFY8o+QhF5dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JLK+xr+jk+Pxo4jtj854FfKFfA8nJ/B1TN2YgqjOpw=;
 b=C+Zl0XlCIAiNAIlApjmLJ8Dw7ROMTeR6vuQtO70CC1UZkshVR9fNWsN7aADmlE4Gk20IqEZ7xhJBu7M01bOdliJbmX7jnXIDOleey2RhcmXRHvi8F8axuyGOG9q81/Er//6LWFd0q/6b4Z3zEp8rFaWIm2i6sUFpsGeKKc5SNK4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2405.namprd15.prod.outlook.com (2603:10b6:a02:87::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Sat, 21 Nov
 2020 02:34:13 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Sat, 21 Nov 2020
 02:34:13 +0000
Date:   Fri, 20 Nov 2020 18:34:05 -0800
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
Message-ID: <20201121023405.tchtyadco4x45sf3@kafai-mbp.dhcp.thefacebook.com>
References: <20201119150617.92010-1-danieltimlee@gmail.com>
 <20201119150617.92010-2-danieltimlee@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119150617.92010-2-danieltimlee@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR2201CA0047.namprd22.prod.outlook.com
 (2603:10b6:301:16::21) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR2201CA0047.namprd22.prod.outlook.com (2603:10b6:301:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Sat, 21 Nov 2020 02:34:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b32d39a-bd08-4573-5ca9-08d88dc5eefc
X-MS-TrafficTypeDiagnostic: BYAPR15MB2405:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2405CDE50FA2E818BEB3B553D5FE0@BYAPR15MB2405.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJ2glBDeAyXytl0Y/Q92lZTTEXCghemV1GTM/LudPnDTK+t3JRjmedXllZ6eYx7a9Tbp/MOIZbDiE4uWh6CxiMJWNEnI+HMq63/feYiLWgDNnF1r+Z68/XBSc+M7omvIGCHsTH8kHjlW37EXPtVGR6RLcgEdrwj9NhcBXSGU4Y9YGcxf+uYLgm5bdF7buojvqaoL2CD0CRmAS9KFKLSy/SdPL+rP8UUSZ3O/NufkLb6R9uLPcRyVgpmFb8qb1cROMYtrrrwM4/scT3E3lodJgMJVl+2BpL6WBN4HmXHYTvPkzy5A+D2pe1VXQw9q02KDFocsl8MfMMrwk/vJbrJArw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(376002)(366004)(83380400001)(54906003)(66946007)(8936002)(8676002)(478600001)(66476007)(4326008)(2906002)(66556008)(1076003)(86362001)(16526019)(7416002)(186003)(5660300002)(55016002)(7696005)(316002)(6506007)(52116002)(6666004)(9686003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kyHmXl4HfrjAMpBvHWXx3xKlZIxoPkoh/7h6O5kDlRsko0BmYaZWuhPM76H6ccoITmu2EBT3nXxnSfL2NZzF1MvWJ+vkUDvfhbKNlf4dN05GSA2E81cIMU8vBhZJ8Y1EQVoihHXr1DqNZuWdwYJOPO/FTHYhZ5Hv0e3lHkQxxXWuW54vQMGV7W5sE55hiHmYCEY+IxAU7m5isVtdyXm+dwveTVwaNEUj7gLZYe8p0NIZNhwPmDNXqjeuSc5B9LN8Oz4EnLH33HHlYey7Ctfh4G42Tz8lvnR8X0yW7a5OiFt2TLEuDBhqgXkmrfkJUvjrtSZ5BUz/E1Y2bIROEP760K45/GTTYpWxve/bYvHQQ/Ba2FSdWzKuej1bg6TSJHp5Ah6SyIHy0M5WnAJ3+ECUMLYGPlFHL8gb98YooMHIHChTTAHNpbnoiCqEpHtoFFZlnu9/FIzKUS+j+haUWGd9O7ZlL5ZNzt70nLEzHNghK/nzdeStlwcXMgR66CT67b8iA5apAOq2rDCKtwGIibst/i793/J1XhUy3Z4R0TDKlFhAsRxhD0iIc1Xl9BVfftxKCr5TyGzu4Ko0buG4LP3b2c2b5jVWLDPV5d2Urylj1leTR0iMquWTg0aHh+8IdzyiPRZqa/Mas4c8i9K4MYw8Ez3+CIvvSrDs8nElCZOo0Qsk1Pwuzx0TP5W7bCb+MR8/xeKSuJORGquc+DqOs07us6YwPhWu9LdkBn5b6X88kg6piPzsF82jdnJFOs5Q3jVlnISoaznAOsSanvMko1gEl1hXIbO1jlCk8xpTSlUJa31M52X6TWjqjMwVbsbU0zmywXURAv9v0q0ehWD9Qvm1/ijlBT9T4j0M70N5Ip3FTJE0NqYfD+8Wu8DSaJqbnZNVyC2V7+xfBnWpQ+SUolrxT6jYZBJ6aFtoslcf0s8aazU=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b32d39a-bd08-4573-5ca9-08d88dc5eefc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2020 02:34:13.6251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqMZja9M1rLAv6Gp28umCe6IIjqt3wPRrZ44+B1yOdZKqYqbk6eskrFnUOZO/V+M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2405
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_17:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=1 lowpriorityscore=0 phishscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011210017
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:06:11PM +0000, Daniel T. Lee wrote:
[ ... ]

>  static int run_bpf_prog(char *prog, int cg_id)
>  {
> -	int map_fd;
> -	int rc = 0;
> +	struct hbm_queue_stats qstats = {0};
> +	char cg_dir[100], cg_pin_path[100];
> +	struct bpf_link *link = NULL;
>  	int key = 0;
>  	int cg1 = 0;
> -	int type = BPF_CGROUP_INET_EGRESS;
> -	char cg_dir[100];
> -	struct hbm_queue_stats qstats = {0};
> +	int rc = 0;
>  
>  	sprintf(cg_dir, "/hbm%d", cg_id);
> -	map_fd = prog_load(prog);
> -	if (map_fd  == -1)
> -		return 1;
> +	rc = prog_load(prog);
> +	if (rc != 0)
> +		return rc;
>  
>  	if (setup_cgroup_environment()) {
>  		printf("ERROR: setting cgroup environment\n");
> @@ -190,16 +183,25 @@ static int run_bpf_prog(char *prog, int cg_id)
>  	qstats.stats = stats_flag ? 1 : 0;
>  	qstats.loopback = loopback_flag ? 1 : 0;
>  	qstats.no_cn = no_cn_flag ? 1 : 0;
> -	if (bpf_map_update_elem(map_fd, &key, &qstats, BPF_ANY)) {
> +	if (bpf_map_update_elem(queue_stats_fd, &key, &qstats, BPF_ANY)) {
>  		printf("ERROR: Could not update map element\n");
>  		goto err;
>  	}
>  
>  	if (!outFlag)
> -		type = BPF_CGROUP_INET_INGRESS;
> -	if (bpf_prog_attach(bpfprog_fd, cg1, type, 0)) {
> -		printf("ERROR: bpf_prog_attach fails!\n");
> -		log_err("Attaching prog");
> +		bpf_program__set_expected_attach_type(bpf_prog, BPF_CGROUP_INET_INGRESS);
> +
> +	link = bpf_program__attach_cgroup(bpf_prog, cg1);
> +	if (libbpf_get_error(link)) {
> +		fprintf(stderr, "ERROR: bpf_program__attach_cgroup failed\n");
> +		link = NULL;
Again, this is not needed.  bpf_link__destroy() can
handle both NULL and error pointer.  Please take a look
at the bpf_link__destroy() in libbpf.c

> +		goto err;
> +	}
> +
> +	sprintf(cg_pin_path, "/sys/fs/bpf/hbm%d", cg_id);
> +	rc = bpf_link__pin(link, cg_pin_path);
> +	if (rc < 0) {
> +		printf("ERROR: bpf_link__pin failed: %d\n", rc);
>  		goto err;
>  	}
>  
> @@ -213,7 +215,7 @@ static int run_bpf_prog(char *prog, int cg_id)
>  #define DELTA_RATE_CHECK 10000		/* in us */
>  #define RATE_THRESHOLD 9500000000	/* 9.5 Gbps */
>  
> -		bpf_map_lookup_elem(map_fd, &key, &qstats);
> +		bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
>  		if (gettimeofday(&t0, NULL) < 0)
>  			do_error("gettimeofday failed", true);
>  		t_last = t0;
> @@ -242,7 +244,7 @@ static int run_bpf_prog(char *prog, int cg_id)
>  			fclose(fin);
>  			printf("  new_eth_tx_bytes:%llu\n",
>  			       new_eth_tx_bytes);
> -			bpf_map_lookup_elem(map_fd, &key, &qstats);
> +			bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
>  			new_cg_tx_bytes = qstats.bytes_total;
>  			delta_bytes = new_eth_tx_bytes - last_eth_tx_bytes;
>  			last_eth_tx_bytes = new_eth_tx_bytes;
> @@ -289,14 +291,14 @@ static int run_bpf_prog(char *prog, int cg_id)
>  					rate = minRate;
>  				qstats.rate = rate;
>  			}
> -			if (bpf_map_update_elem(map_fd, &key, &qstats, BPF_ANY))
> +			if (bpf_map_update_elem(queue_stats_fd, &key, &qstats, BPF_ANY))
>  				do_error("update map element fails", false);
>  		}
>  	} else {
>  		sleep(dur);
>  	}
>  	// Get stats!
> -	if (stats_flag && bpf_map_lookup_elem(map_fd, &key, &qstats)) {
> +	if (stats_flag && bpf_map_lookup_elem(queue_stats_fd, &key, &qstats)) {
>  		char fname[100];
>  		FILE *fout;
>  
> @@ -398,10 +400,10 @@ static int run_bpf_prog(char *prog, int cg_id)
>  err:
>  	rc = 1;
>  
> -	if (cg1)
> -		close(cg1);
> +	bpf_link__destroy(link);
> +	close(cg1);
>  	cleanup_cgroup_environment();
> -
> +	bpf_object__close(obj);
The bpf_* cleanup condition still looks wrong.

I can understand why it does not want to cleanup_cgroup_environment()
on the success case because the sh script may want to run test under this
cgroup.

However, the bpf_link__destroy(), bpf_object__close(), and
even close(cg1) should be done in both success and error
cases.

The cg1 test still looks wrong also.  The cg1 should
be init to -1 and then test for "if (cg1 == -1)".
