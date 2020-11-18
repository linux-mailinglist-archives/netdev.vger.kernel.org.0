Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333D02B741D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgKRCLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:11:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30522 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbgKRCLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 21:11:18 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI2A37K032666;
        Tue, 17 Nov 2020 18:10:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=7u+Wt2HViRASyYbbm/BW8j/GaqFpwmmUqOAsCeTGajU=;
 b=YX7r7c5vqkcDK5LXVDCRc5mgcogoQrmXDf4SV6D7DWMvLgEjYSimI5FifoUpeY4D6ZDE
 gNN4LEAqDrTsdGbgYSbQJoCCPcGJiQgulEZzfWVpad0kWo2pjr95WRnsYeKf7hvTEd0o
 kgDgo8ls1M8+Ke10zVPTJDWrMXSKHJEtjbI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34tymdf60x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Nov 2020 18:10:57 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 18:10:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYncbbYZQVea3fP4xhKaQ+Gs4UD9tizmPcnGzeOVn7BD0/50dwvLKJubAY2FZ4PEPwb7hj7slKqtdhRSkF+JCv0fpkx61ZXzBcCiu1tgTmkXjFYy4+namJE6qNiQzGmRbTk0QP2GTQNzBTLp4tWpdxFzXvcpNHDhcAtHEr7iqve29jAwjCFM1IhPISynv/9jxvC69eHQ/kYkcuArswzWTS4M6ni2Qbfh1t2BYX6TSWIhzTo+zR9APvGsO0mpcP4NoVI7Wdi50Ht1pkGhIwYqSuKvZhol1R6slTAASySouTb3N9FAJirq8XFEU5W47n4S+Z9ZprfdhnaQG67soTUaRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7u+Wt2HViRASyYbbm/BW8j/GaqFpwmmUqOAsCeTGajU=;
 b=M7EVPaSgB9qj2ucicZRKfhe2kjE9qhv4VAqTiuzl2YzI/CTm0jfOexUyNdIskcIIWRXG2SnK5z+EOwVCS/Zb72VD6icbIQ7d5t2q+S+7fOR7Gn9Z1P0c2F5tE7fXrEZ4gmSK40fU9J6yyT6I6Xhxiad3UUhpdjSOrF+is3Qw8cgH1oyx6hlPiSDvnQtx7O9Qa/JwEZF96HzdAVm5J0nKSnhbUEYnOrVJM5Q1lI099RIlP0LzH3Bes5474sPGb4obtKGNJ0RvHrdogQ7K7SunL3+pw8gSVK9tVl0ahv6Nf2O8boq81TOE0QnDTO1VgWRi0Hu+0HEZGW+UFN3gXimp0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7u+Wt2HViRASyYbbm/BW8j/GaqFpwmmUqOAsCeTGajU=;
 b=P2IsOiiy9Is1hbUFiri+F7Jtxj3OzIkBzSfADkACPGeo6KK2hxje7zZMbTXJO7IwooCguUTHW9EAsbY8ZuHmx5VW2mL4BfKjwoVOae6MEMR7utHxILG7v6BVxfRyhVGDjWUhpQCFeZIRJb0OAXH6adQV6EbEg4PldcSyO/6uukk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3715.namprd15.prod.outlook.com (2603:10b6:a03:1fe::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Wed, 18 Nov
 2020 02:10:55 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 02:10:55 +0000
Date:   Tue, 17 Nov 2020 18:10:48 -0800
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
Subject: Re: [PATCH bpf-next 2/9] samples: bpf: refactor hbm program with
 libbpf
Message-ID: <20201118021043.zck246i2jvbboqlu@kafai-mbp.dhcp.thefacebook.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-3-danieltimlee@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117145644.1166255-3-danieltimlee@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:300:117::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR03CA0006.namprd03.prod.outlook.com (2603:10b6:300:117::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 02:10:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44ac9ce6-ec39-4c3e-1dac-08d88b672e61
X-MS-TrafficTypeDiagnostic: BY5PR15MB3715:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB37155CD5293E8D802CB699F5D5E10@BY5PR15MB3715.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:48;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bRaGBgauybTa+xkYcDN8m60V+WfZdlieVBIz2NcNAs38lAOmiPDL24w8wzyGt57m8kZjxBqT2uSVpF8ehQwsGZZ5Z+5dF4Yhi8uoiYt2Yeofon7hc/Vw5ao9F7QRGFLmT5++piPQ4lYXf/sqaWES9JZqziNGXSTIdfrjHTMInPsdmnOmCJe1cPefyfwjHrUr4ewzqtcsm0RsuRuGTKwgMu9Uu5UBdruSZs8AOw1nI/YLPrTjt5injsTihL684tCbWtu8drg+KgSADIlsGAXEqxRyDZixa8YUjOSiQpla0rWkdqsx1/XRvftVKZyBaMIOobGE0KzEMurRaDE3+oAfog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(39850400004)(346002)(66946007)(66476007)(6506007)(5660300002)(4326008)(55016002)(6666004)(83380400001)(8936002)(86362001)(66556008)(186003)(16526019)(6916009)(478600001)(54906003)(9686003)(8676002)(316002)(2906002)(7416002)(1076003)(52116002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: K9tdBXc6GhZKWuqkvESmDwQUgZfnwr6oTifQXHRo0TiB7MGbRB4RC1Wbe4GP/WKU6vTeHr7Z6pMomU0LgbpiYaMIphYNVYi+mfgUmCe+apJpoSTxGJazyJnYkuFoxfLKfjsA/W/V7JIpCA90Qj/VxlzO91Kdk+rx2Sx9HjzlxzjPPRSB6h1AcBPNI69gGp9hRo3n40ox6vcW2tkvacTJPfRa+f2WAlIhqGMQ9F5xSZ4gyv4y3pbiEDdlNYVxA0aT0PX2bj5X8HXYaQVU5DhGCsdkhM/uhqGT8aGct3C8dt5D070eD5Owam7eUa1KRk+ju122DEYZQgeG5O2TXq1dqZ56HNWoVol9iFoRAY354IiT0G5A/GyyReZueg4rC1bXBriTv4VYmlxkrUDnoQXiX2mzgU3mBuH5e4qHcXYNr+asLHcb23J3ZK0b02uWmQyYhyzVVO/UVOB1lZBd28QwnQaIvg19yC1hBy9OkCvW5GxXi1f/tir39gOpNnzbASrO0LbhNEm32pez65hokf0e61Whjrh0L5VnXnqVZ0Q/Y1C+F3hV7LBGnxreggSwRLkb/lstDXq/oS59J/Kc0rcyWN8DPqD5msJQLRaioUWYDzaQLZcAbgEEKQ5n7vdIm76ro+ny5ARehQ3OztbOGuegHJbIMucN1OtnFDWZcdN3DlWp9clvR3dBRMf0tQdbmMdS
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ac9ce6-ec39-4c3e-1dac-08d88b672e61
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 02:10:55.0813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9IgulB+aVih3a3PCWjb9GjRoKUHLoU5PM3r8C0RhS4HzxvfaE3q8NmPyf4Xsx2P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3715
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_15:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011180012
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 02:56:37PM +0000, Daniel T. Lee wrote:
[ ... ]

> diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
> index b9f9f771dd81..008bc635ad9b 100644
> --- a/samples/bpf/hbm.c
> +++ b/samples/bpf/hbm.c
> @@ -46,7 +46,6 @@
>  #include <bpf/bpf.h>
>  #include <getopt.h>
>  
> -#include "bpf_load.h"
>  #include "bpf_rlimit.h"
>  #include "trace_helpers.h"
>  #include "cgroup_helpers.h"
> @@ -68,9 +67,10 @@ bool edt_flag;
>  static void Usage(void);
>  static void do_error(char *msg, bool errno_flag);
>  
> +struct bpf_program *bpf_prog;
>  struct bpf_object *obj;
> -int bpfprog_fd;
>  int cgroup_storage_fd;
> +int queue_stats_fd;
>  
>  static void do_error(char *msg, bool errno_flag)
>  {
> @@ -83,56 +83,54 @@ static void do_error(char *msg, bool errno_flag)
>  
>  static int prog_load(char *prog)
>  {
> -	struct bpf_prog_load_attr prog_load_attr = {
> -		.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
> -		.file = prog,
> -		.expected_attach_type = BPF_CGROUP_INET_EGRESS,
> -	};
> -	int map_fd;
> -	struct bpf_map *map;
> +	int rc = 1;
>  
> -	int ret = 0;
> +	obj = bpf_object__open_file(prog, NULL);
> +	if (libbpf_get_error(obj)) {
> +		printf("ERROR: opening BPF object file failed\n");
> +		return rc;
> +	}
>  
> -	if (access(prog, O_RDONLY) < 0) {
> -		printf("Error accessing file %s: %s\n", prog, strerror(errno));
> -		return 1;
> +	/* load BPF program */
> +	if (bpf_object__load(obj)) {
> +		printf("ERROR: loading BPF object file failed\n");
> +		goto cleanup;
>  	}
> -	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &bpfprog_fd))
> -		ret = 1;
> -	if (!ret) {
> -		map = bpf_object__find_map_by_name(obj, "queue_stats");
> -		map_fd = bpf_map__fd(map);
> -		if (map_fd < 0) {
> -			printf("Map not found: %s\n", strerror(map_fd));
> -			ret = 1;
> -		}
> +
> +	bpf_prog = bpf_object__find_program_by_title(obj, "cgroup_skb/egress");
> +	if (!bpf_prog) {
> +		printf("ERROR: finding a prog in obj file failed\n");
> +		goto cleanup;
>  	}
>  
> -	if (ret) {
> -		printf("ERROR: bpf_prog_load_xattr failed for: %s\n", prog);
> -		printf("  Output from verifier:\n%s\n------\n", bpf_log_buf);
> -		ret = -1;
> -	} else {
> -		ret = map_fd;
> +	queue_stats_fd = bpf_object__find_map_fd_by_name(obj, "queue_stats");
> +	if (queue_stats_fd < 0) {
> +		printf("ERROR: finding a map in obj file failed\n");
> +		goto cleanup;
>  	}
>  
> -	return ret;
> +	rc = 0;
Just return 0.

> +
> +cleanup:
> +	if (rc != 0)
so this test can be avoided.

> +		bpf_object__close(obj);
> +
> +	return rc;
>  }
>  
>  static int run_bpf_prog(char *prog, int cg_id)
>  {
> -	int map_fd;
> -	int rc = 0;
> +	struct hbm_queue_stats qstats = {0};
> +	struct bpf_link *link = NULL;
> +	char cg_dir[100];
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
> @@ -152,16 +150,18 @@ static int run_bpf_prog(char *prog, int cg_id)
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
There is a difference here.
I think the bpf_prog will be detached when link is gone (e.g. process exit)
I am not sure it is what hbm is expected considering
cg is not clean-up on the success case.

> +	if (libbpf_get_error(link)) {
> +		fprintf(stderr, "ERROR: bpf_program__attach_cgroup failed\n");
> +		link = NULL;
not needed.  bpf_link__destroy() can handle err ptr.

>  		goto err;
>  	}
>  
> @@ -175,7 +175,7 @@ static int run_bpf_prog(char *prog, int cg_id)
>  #define DELTA_RATE_CHECK 10000		/* in us */
>  #define RATE_THRESHOLD 9500000000	/* 9.5 Gbps */
>  
> -		bpf_map_lookup_elem(map_fd, &key, &qstats);
> +		bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
>  		if (gettimeofday(&t0, NULL) < 0)
>  			do_error("gettimeofday failed", true);
>  		t_last = t0;
> @@ -204,7 +204,7 @@ static int run_bpf_prog(char *prog, int cg_id)
>  			fclose(fin);
>  			printf("  new_eth_tx_bytes:%llu\n",
>  			       new_eth_tx_bytes);
> -			bpf_map_lookup_elem(map_fd, &key, &qstats);
> +			bpf_map_lookup_elem(queue_stats_fd, &key, &qstats);
>  			new_cg_tx_bytes = qstats.bytes_total;
>  			delta_bytes = new_eth_tx_bytes - last_eth_tx_bytes;
>  			last_eth_tx_bytes = new_eth_tx_bytes;
> @@ -251,14 +251,14 @@ static int run_bpf_prog(char *prog, int cg_id)
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
> @@ -367,10 +367,12 @@ static int run_bpf_prog(char *prog, int cg_id)
>  err:
>  	rc = 1;
>  
> +	bpf_link__destroy(link);
> +
>  	if (cg1)
This test looks wrong since cg1 is a fd.

>  		close(cg1);
>  	cleanup_cgroup_environment();
> -
> +	bpf_object__close(obj);
>  	return rc;
>  }
>  

