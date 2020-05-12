Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A1D1CE9BA
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgELAgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:36:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52332 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbgELAgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:36:00 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04C0ToRe017138;
        Mon, 11 May 2020 17:35:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=uKoyQJYnNoJ4L4qq9LucatSEPAR8TrN2qZrLD6sPSaA=;
 b=diHbAN8foGOvL86LyOZYqCgfYEfhd0apVVHYlNiukE2A9Ev6X9uqfbo6NwTlgxSgLGEX
 22DsUlKbwZdAi3g/PMpmMfIYH5XCLX/WAkjFVbp2hNnOE0lvB1IWfm0uZ4yVAuW6waUn
 GOw5Ms4zcfVbTP8aAZEK4T3juiEW+C4JyIU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30ws55myyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 May 2020 17:35:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 11 May 2020 17:35:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKDxmrr5KtCRBGaC0ROrIccNjyIZOVZ5rIxFFL/6XDh4/Y5bUT/6MrbccsHc1f7AJM70rz9JALTc42kwP6IyEilZxdIPX23NM85fomGzWc1H7ULd04Uze4nPpmHdBFcnZ6kC8TBaweM9blWsMjN5AHDOEhpjAeNNSw9J4JoRX9eh1a4SBEPdKAoR9EQRP2fpXh2iuZ1Ir5gddnXGLnlVoOiIUKDJBV3HNsEoBmgNiKVkfkmrRnCq3awyzYpepbvFq/i1MweZO2IifTTzd/cED6AWdTTbBNQzQpvI7fJ3gVdr9V8lylR1WInum4pcg3N7JW0CyeRb2VMp1xJuPBeQPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKoyQJYnNoJ4L4qq9LucatSEPAR8TrN2qZrLD6sPSaA=;
 b=I9vAwTnQ7zq3YYfm7cfYlM3eXlYExkznaW93hxRlpBTeOdQJa5KP/Ip6zLnGJoNMwkjYLuXy+0XSdqN2Emle9/vdfjVrerBgXoXQJld94op6nu4PG2men/t1rpXFgpZBYP0hf3QzzroiQely5bBX7aRIDXh8X4C8KT/zEJSov+0+6jIQW3Ru1DwVvnKsA9f51Sr6t0U9VctXRwXpYLcTOBLUAWghnQYno+l/YfDGx69DHyn6KkmS8RbHXEOkhBGgIplKev+yUIekiNK+nN66OTFnWOx/vL51K15XMBnvkJjanQqNbFTaHWrSUq5kK9HeNiY3JUwJYJ1VpTJ5si7/Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKoyQJYnNoJ4L4qq9LucatSEPAR8TrN2qZrLD6sPSaA=;
 b=JinROC9LxpSjsme138uBg6zkyAY1MCLwqTttAShf+cH/0zt7pygI1lk1chNDv3GGYXsXfF71WDZb+kidfcvsXWqgd4XQ9eWhuMo8FnTo+NMtMyI7CZlxpj8TU/gCm/lE8fDDrhsl4TZInlEIc6H+YsnBktupLIWo7Tz7EdLk0RE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2870.namprd15.prod.outlook.com (2603:10b6:a03:ff::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Tue, 12 May
 2020 00:35:32 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 00:35:32 +0000
Subject: Re: [PATCH bpf-next] samples/bpf: xdp_redirect_cpu: set MAX_CPUS
 according to NR_CPUS
To:     Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <davem@davemloft.net>, <brouer@redhat.com>,
        <daniel@iogearbox.net>, <lorenzo.bianconi@redhat.com>
References: <79b8dd36280e5629a5e64b89528f9d523cb7262b.1589227441.git.lorenzo@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c3fa2001-ef77-46c4-c0de-3335e7934db9@fb.com>
Date:   Mon, 11 May 2020 17:35:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <79b8dd36280e5629a5e64b89528f9d523cb7262b.1589227441.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0110.namprd15.prod.outlook.com
 (2603:10b6:101:21::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e242) by CO1PR15CA0110.namprd15.prod.outlook.com (2603:10b6:101:21::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 12 May 2020 00:35:30 +0000
X-Originating-IP: [2620:10d:c090:400::5:e242]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 429c99a5-37f3-4fc4-06ea-08d7f60c6094
X-MS-TrafficTypeDiagnostic: BYAPR15MB2870:
X-Microsoft-Antispam-PRVS: <BYAPR15MB28705BF7F5C305BA469F47A6D3BE0@BYAPR15MB2870.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSwGsVEYKD7Wsvt5TA6Ns4pWmffs1HX3ElF06n/FEZuWVkwuBlYCLks3RVsNxsAbp6mH4c/ydDWL2ZJ4AhaamBdzJToS7kCpsgrwTeT+K0zqDiGzz4BulekEnyldo/Fj4Ipa+Z2K1hEXRdVMM/P33yOraTX0Wp+o3Le8JKA+yfyhj6V0+B8vSdoWTJhvovXkkeu727nG2JvObYstN1CrpPpMNvlJnDO2QxaebITXqJ3RiN+GWMjVNVMOqobUUbt7wztxrHnFnLVcx/AvRqZ14TIypvJA9E4T6ZK+0XEbk6QxXKFnWKRIiBnxJrmyCCRgtPUGEu9UVVFHchF/ZNtsKROYk8OTKnmgnrmsipOrp9EQc6LhT193pHQi0tEhSNPjHVlrKyOi+AY8YC6DhmpYrlzawhWarydMCCCSSKuwLLEmLsl6l/LmVib202xhYsML4nfyd241ph6925iW9NiteWLdedLimcA6Aif/dHYERjS31EO5F0r+dciaCrYBpAxr7biZSDz+M1WMN19dcP9XB2zPv/Xj5I/yhiZLtorLLXlgKVVM0IKr779ouVjme6dW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(376002)(396003)(366004)(346002)(33430700001)(6486002)(2906002)(5660300002)(186003)(2616005)(16526019)(53546011)(6506007)(52116002)(6512007)(31696002)(66946007)(4326008)(8936002)(8676002)(33440700001)(66556008)(478600001)(36756003)(66476007)(31686004)(316002)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 1TP0ELuDY2Fssy+xO/5HVf4msnWc2Ae54NA0P7y8HwvLdielVjWsC1ihZV0boIhrCbKkwnqePsBa/u08Uoi7Y3leRfkQukURAh3OLowPz6nLtG8EwGHmtRACV7QMLfGrXAi5+W+7R1GCt+UjH6WmDqZcTE6PAcdE5917cDx+YH14+eoveZl458o9eVX4hto2pfTIr6hY9Xy/oMAeuI6DOIh3WfgxkV1GBxickSM0ceG6+MFEzAntp8MGjnMCIH3ZIGp6ozX9Y3wYdiuocDYbBxHZzZGZhFuLQi3jRSVkNP9h4HwjgMRq3B4QsWR/lA4Wcm7lRAdc0THQXkUUEGkKge2u8x1l4Zfx4fQem6PQ8YLi5bvxdLfrpA6PPL3ezXQSi9g0RBhNDe1CnObfWeUHrXO7HYZnI+/Yv6Fqi+ExHdAWjk8Kq43Cafz0DJI6GyHDOUidHbUbFC7phxWc6kMOCGXoxQOdP+v+iPOvH1hxepagRTC9+AQnbo5QokoeHVzjiZKGLOMMLe0LBYtDI3WJWQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 429c99a5-37f3-4fc4-06ea-08d7f60c6094
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 00:35:31.9646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHljh2HTbJufN6xmEj46x5VZ1XNVS57crrGdYTQeriFbkVVd+hcHxg6mns2SW4U6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2870
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_11:2020-05-11,2020-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1011 mlxscore=0 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=2
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 1:24 PM, Lorenzo Bianconi wrote:
> xdp_redirect_cpu is currently failing in bpf_prog_load_xattr()
> allocating cpu_map map if CONFIG_NR_CPUS is less than 64 since
> cpu_map_alloc() requires max_entries to be less than NR_CPUS.
> Set cpu_map max_entries according to NR_CPUS in xdp_redirect_cpu_kern.c
> and get currently running cpus in xdp_redirect_cpu_user.c
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   samples/bpf/xdp_redirect_cpu_kern.c |  2 +-
>   samples/bpf/xdp_redirect_cpu_user.c | 29 ++++++++++++++++-------------
>   2 files changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
> index 313a8fe6d125..2baf8db1f7e7 100644
> --- a/samples/bpf/xdp_redirect_cpu_kern.c
> +++ b/samples/bpf/xdp_redirect_cpu_kern.c
> @@ -15,7 +15,7 @@
>   #include <bpf/bpf_helpers.h>
>   #include "hash_func01.h"
>   
> -#define MAX_CPUS 64 /* WARNING - sync with _user.c */
> +#define MAX_CPUS NR_CPUS
>   
>   /* Special map type that can XDP_REDIRECT frames to another CPU */
>   struct {
> diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
> index 15bdf047a222..100e72cb4cf5 100644
> --- a/samples/bpf/xdp_redirect_cpu_user.c
> +++ b/samples/bpf/xdp_redirect_cpu_user.c
> @@ -13,6 +13,7 @@ static const char *__doc__ =
>   #include <unistd.h>
>   #include <locale.h>
>   #include <sys/resource.h>
> +#include <sys/sysinfo.h>
>   #include <getopt.h>
>   #include <net/if.h>
>   #include <time.h>
> @@ -24,8 +25,6 @@ static const char *__doc__ =
>   #include <arpa/inet.h>
>   #include <linux/if_link.h>
>   
> -#define MAX_CPUS 64 /* WARNING - sync with _kern.c */
> -
>   /* How many xdp_progs are defined in _kern.c */
>   #define MAX_PROG 6
>   
> @@ -40,6 +39,7 @@ static char *ifname;
>   static __u32 prog_id;
>   
>   static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> +static int n_cpus;
>   static int cpu_map_fd;
>   static int rx_cnt_map_fd;
>   static int redirect_err_cnt_map_fd;
> @@ -170,7 +170,7 @@ struct stats_record {
>   	struct record redir_err;
>   	struct record kthread;
>   	struct record exception;
> -	struct record enq[MAX_CPUS];
> +	struct record enq[];
>   };
>   
>   static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
> @@ -225,10 +225,11 @@ static struct datarec *alloc_record_per_cpu(void)
>   static struct stats_record *alloc_stats_record(void)
>   {
>   	struct stats_record *rec;
> -	int i;
> +	int i, size;
>   
> -	rec = malloc(sizeof(*rec));
> -	memset(rec, 0, sizeof(*rec));
> +	size = sizeof(*rec) + n_cpus * sizeof(struct record);
> +	rec = malloc(size);
> +	memset(rec, 0, size);
>   	if (!rec) {
>   		fprintf(stderr, "Mem alloc error\n");
>   		exit(EXIT_FAIL_MEM);
> @@ -237,7 +238,7 @@ static struct stats_record *alloc_stats_record(void)
>   	rec->redir_err.cpu = alloc_record_per_cpu();
>   	rec->kthread.cpu   = alloc_record_per_cpu();
>   	rec->exception.cpu = alloc_record_per_cpu();
> -	for (i = 0; i < MAX_CPUS; i++)
> +	for (i = 0; i < n_cpus; i++)
>   		rec->enq[i].cpu = alloc_record_per_cpu();
>   
>   	return rec;
> @@ -247,7 +248,7 @@ static void free_stats_record(struct stats_record *r)
>   {
>   	int i;
>   
> -	for (i = 0; i < MAX_CPUS; i++)
> +	for (i = 0; i < n_cpus; i++)
>   		free(r->enq[i].cpu);
>   	free(r->exception.cpu);
>   	free(r->kthread.cpu);
> @@ -350,7 +351,7 @@ static void stats_print(struct stats_record *stats_rec,
>   	}
>   
>   	/* cpumap enqueue stats */
> -	for (to_cpu = 0; to_cpu < MAX_CPUS; to_cpu++) {
> +	for (to_cpu = 0; to_cpu < n_cpus; to_cpu++) {
>   		char *fmt = "%-15s %3d:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
>   		char *fm2 = "%-15s %3s:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
>   		char *errstr = "";
> @@ -475,7 +476,7 @@ static void stats_collect(struct stats_record *rec)
>   	map_collect_percpu(fd, 1, &rec->redir_err);
>   
>   	fd = cpumap_enqueue_cnt_map_fd;
> -	for (i = 0; i < MAX_CPUS; i++)
> +	for (i = 0; i < n_cpus; i++)
>   		map_collect_percpu(fd, i, &rec->enq[i]);
>   
>   	fd = cpumap_kthread_cnt_map_fd;
> @@ -549,10 +550,10 @@ static int create_cpu_entry(__u32 cpu, __u32 queue_size,
>    */
>   static void mark_cpus_unavailable(void)
>   {
> -	__u32 invalid_cpu = MAX_CPUS;
> +	__u32 invalid_cpu = n_cpus;
>   	int ret, i;
>   
> -	for (i = 0; i < MAX_CPUS; i++) {
> +	for (i = 0; i < n_cpus; i++) {
>   		ret = bpf_map_update_elem(cpus_available_map_fd, &i,
>   					  &invalid_cpu, 0);
>   		if (ret) {
> @@ -688,6 +689,8 @@ int main(int argc, char **argv)
>   	int prog_fd;
>   	__u32 qsize;
>   
> +	n_cpus = get_nprocs();

get_nprocs() gets the number of available cpus, not including offline 
cpus. But gaps may exist in cpus, e.g., get_nprocs() returns 4, and cpus 
are 0-1,4-5. map updates will miss cpus 4-5. And in this situation,
map_update will fail on offline cpus.

This sample test does not need to deal with complication of
cpu offlining, I think. Maybe we can get
	n_cpus = get_nprocs();
	n_cpus_conf = get_nprocs_conf();
	if (n_cpus != n_cpus_conf) {
		/* message that some cpus are offline and not supported. */
		return error
	}

> +
>   	/* Notice: choosing he queue size is very important with the
>   	 * ixgbe driver, because it's driver page recycling trick is
>   	 * dependend on pages being returned quickly.  The number of
> @@ -757,7 +760,7 @@ int main(int argc, char **argv)
>   		case 'c':
>   			/* Add multiple CPUs */
>   			add_cpu = strtoul(optarg, NULL, 0);
> -			if (add_cpu >= MAX_CPUS) {
> +			if (add_cpu >= n_cpus) {
>   				fprintf(stderr,
>   				"--cpu nr too large for cpumap err(%d):%s\n",
>   					errno, strerror(errno));
> 
