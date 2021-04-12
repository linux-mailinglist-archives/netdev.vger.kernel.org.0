Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED36B35D2B5
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343512AbhDLVuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:50:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40924 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245367AbhDLVuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 17:50:21 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CLhHGc031672;
        Mon, 12 Apr 2021 14:49:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fEDGeoVJBHP+2e736uooXGy0sJqkVi/cV42OtULwqtU=;
 b=am77jsJvVHMZ3VOJ8hpqvFTwQnMbTnxeYGnIC/Q8prHAkGl+XXCdBtHhu6pxfAiiU1QJ
 3XttyVRtZcmnFBiMSyPx5eY2jOiowaY9XlLsCyjOJVtXByURK3Rss79AEkopZy3CX2hH
 Cl6Hf5Fl5n9JcMmdhT35XIampSgPCwJNKtc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37vrp3t7a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 12 Apr 2021 14:49:47 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Apr 2021 14:49:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwPq/+Bkl1ZFwL3/O5zGDNvG/QXrrEtEiNrf2zfiSSvcYn/98tkcyYTbmTxlyXCYYA5as7Dg9QlDFKI6LlW/CZpJdeviErRbKgmmvYx63AeBqAstbUUPwL9Kpn3LItN/m4EVQfkmysZOr8Py6fPKms6eCsTOSwQRpaAbMBv1jiGXlOD//aMy/8epCcQ4Gj+9ocPtDeOf39M7ZOI/geYdnyxQhmRxrR5VFqj7pzWJkeIXqqqBYeNtcVvTP906cB8gnhnruQVrlXmGJtP9kA86ZsS9RQ9q8n8P0V22ALDpq6r6izTktY5VMJZVfdPJIJTKF9kI/gMEkCRZuhEK+D7CUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEDGeoVJBHP+2e736uooXGy0sJqkVi/cV42OtULwqtU=;
 b=hZPcKemV3q2yimT+YpdOsMQszu2phmzz/+PF4Tp5VfZCnUpdkvMc3MJLji9LomU7GFXx3K3PqlzKbHdEE6VHghauUV/cOe/bscJfWqOlUwdKEo4iXlPvGwubdOlvFajQs+aOQOgzUjcipB+jWjvyC3RPvbQVM9497QnXrznpRMY9VBvDyfmr7KKK8sAfKqn51riWklyLStbB4GgR6lhht9NYK+I05wxgREMMHm6j14qaZgjdUCFvOPJpi/zmg3l28djwfR7Ajvs8yH6r1xVAz2lHgYCsHmgFYUzKts8ntSAisvqcipIhbQOciusOZ/sDjUEzeb4mYLz6wpVzEAnzGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Mon, 12 Apr
 2021 21:49:44 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 21:49:44 +0000
Date:   Mon, 12 Apr 2021 14:49:41 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Pedro Tammela <pctammela@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Verbeiren <david.verbeiren@tessares.net>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 3/3] bpf: selftests: update array map tests
 for per-cpu batched ops
Message-ID: <20210412214941.krhkkp7ryx3nf77m@kafai-mbp.dhcp.thefacebook.com>
References: <20210412194001.946213-1-pctammela@mojatatu.com>
 <20210412194001.946213-4-pctammela@mojatatu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210412194001.946213-4-pctammela@mojatatu.com>
X-Originating-IP: [2620:10d:c090:400::5:81f]
X-ClientProxiedBy: MW4PR03CA0311.namprd03.prod.outlook.com
 (2603:10b6:303:dd::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:81f) by MW4PR03CA0311.namprd03.prod.outlook.com (2603:10b6:303:dd::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 21:49:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6363829f-b5c3-41af-0a53-08d8fdfce292
X-MS-TrafficTypeDiagnostic: BYAPR15MB2566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2566F7FC266BAB7FD5417931D5709@BYAPR15MB2566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CCBm1c+4KMEJR7lx+0zyUv0VdwWB0lPw33sZ8RdWliDnOFStYlxLAILSbWKGfU1PBSoWcpCf/9U+cEuoNDUFUuFyk58BmvmwcQ5E2L+GM/VpaGoqio81BJktzQQo3HoEsLFublbW7+gfXrntiFPw5MGZLKkklygrADrMhOQtFZCSzBGUKE19OATU73IS5BzxiVYbxoJI0l6GMSFl8twxS63d/hukQD4usLOLm0+HaWdqSMBE7NTSimiyATsf1zc8LWEBUzxeGCwFYjAoEGI7oOSzao0p2Gf3BUg9BtEOMN4dyj0sEr89sH/w64f3m/Tv7B/XNOBmCIHduGuDMJgoYdbwd/hUoCQh6+A9zOiY0RmCFYFdRt1UR2zqQJBpbyDknBEy6rSfp8wQjl/M164JeW6DeD+MB5exzf2pAESpCSFsGJKFsyWyzhlTOXoK7XZ+slWTCVZRlUpYgArezGXLQ+b3d4nk4bSEEwR/aVFkRbE/xFsN9GBdfjl64xuoNToG/r92iDi+DU+8kr30y+W1bNVv33tQPtq4tWWxNdTlOqa3Kl912Pa+tiu28cdjSI5tBLOKM2lICI7O84YD8kj+UrfpyCqPSOayYtr0iJiQRvQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39860400002)(376002)(38100700002)(8936002)(4326008)(66946007)(8676002)(86362001)(478600001)(7696005)(66476007)(5660300002)(2906002)(16526019)(1076003)(186003)(316002)(54906003)(52116002)(83380400001)(7416002)(6506007)(6916009)(9686003)(15650500001)(55016002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aEvj3QFWgXZyJv4fRLN1Afe1LIDkovce/4TQJ4w+kRrxVl5Tm3PRnhgQdcVT?=
 =?us-ascii?Q?wPJDiPr0kVYirrZ6Vhh11fuN+p5HqK1Y4iomsiWzrVBNKOIbcQS0GoR+GCb6?=
 =?us-ascii?Q?pC6tZxi4PM2jrLfajoSgk7d38kltYz4idX0StT9l3trrA8t+pH7U0oL27wUY?=
 =?us-ascii?Q?5GdzgMOR8Be90m5ufSinKvG90c/leYlFJZbzVI3tMBAChrJTckUyXbUKhAdR?=
 =?us-ascii?Q?FSOPdPimRLikoMBLbIWdMUpaflVChBeX4zcN6VOJYTDJ8A/CueZZhD2EIbkn?=
 =?us-ascii?Q?AYJQ4M8MMVts+3VnxpiQ5oRjciQR7Q4qj43jJ6htF9GPbHz6Daa49GB3ZPRS?=
 =?us-ascii?Q?4N1gRQMXeQ2wxMmQ+KEsJNkfJalS45B8hWvTLIlsDM8XwY8QJ8qSvRjuywUR?=
 =?us-ascii?Q?JEmsQMmAeJBq9quLtMNvQ8roEiKkmOP2wn4AHPGaHf4ZV0qbND6jpksx0ssl?=
 =?us-ascii?Q?BBozrqRgWNs44AhsV4VwZ0Ze7ggDjfbTJlcbvnkmTDw0OyOVIKLVoLUFY98T?=
 =?us-ascii?Q?Yj+on/mZh82XklRMUadaNllOa77vvn7zRBbykIpaqslmAI0LcaR9E48jyAJA?=
 =?us-ascii?Q?o8WVnXgIkLXLMmUpqyb/XlRJznwkpISewHuNeU18BKKYfCLhrIJ3uBPICb7W?=
 =?us-ascii?Q?w2VAQHRt/wqseBLYzcUUOIYsjPvCMnpcFqWAco1MnLA2p+cUa+nsav94sSiU?=
 =?us-ascii?Q?hK9xSL8yYE6+zExM1rGnixhJVace65sdRwr+SuEiMINh3YQGSNIffk9Vw0IU?=
 =?us-ascii?Q?SpfQh+LP53UhfCXwwVBBy+7JPWYWAjYOqfORdkg0w5DI1bZq+nwaw69mYpME?=
 =?us-ascii?Q?xXUpaijYuIc1JZ5QRfmx9Wvo4LzSCpEW+nFmqW2YK9QZlJ2/t2vHKdRTzv9l?=
 =?us-ascii?Q?zz67tbvJYs4CDKPpCuoTVy5JDtl8rKDHLAJoWpmE3WCiz/3T3oEKvtVonXQJ?=
 =?us-ascii?Q?R3QHjlOp/aZFS5I5zxhjN2kxYaJghw2LyxFwXQop94sBKL+dGHP+PFqugE+5?=
 =?us-ascii?Q?8f9nSIZqnluUxc5m+BlFfkWVdnK1aZU2mVy9NXf2sFniix9XT91951rx8p++?=
 =?us-ascii?Q?gx945nIQUXt5IcmQCOIiGOJjJB1LhXBNUzO4D5NFVGqNF6YVyEHuIJ4/Jjaa?=
 =?us-ascii?Q?jN8XY+QzSaI8Q7qHj6Qudd/WWIAvOmWlZddDlIgA4Scgiqs4y2o3OEaGDC9n?=
 =?us-ascii?Q?Y6LXqZ7UTOpCJfkbyB83GqE0cgFlubsQpXHGSnUqMOuqcwkY12R/qzlCqucl?=
 =?us-ascii?Q?8SMYINbLqRJ00WFXkEe3IeENomcYRK7Rmm+w87LJx74CQQAQWZ+imgeW687B?=
 =?us-ascii?Q?UFTzFHcUmhRAq7eo8yOe1AuEt8SOBY1vsYXr9QQGOxSZ7w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6363829f-b5c3-41af-0a53-08d8fdfce292
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 21:49:44.8572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bnfOKg8+LBsSLzaHXO/kOoYdM4TfbW63R3xwbQ9Jcarj47lzUu7JBaefGIiCG1jR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: mTyRAxSJXnG-g4gnk4TReHmgXHZRLOKf
X-Proofpoint-GUID: mTyRAxSJXnG-g4gnk4TReHmgXHZRLOKf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 adultscore=0 clxscore=1011 mlxscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 04:40:01PM -0300, Pedro Tammela wrote:
> Follows the same logic as the hashtable tests.
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  .../bpf/map_tests/array_map_batch_ops.c       | 110 +++++++++++++-----
>  1 file changed, 80 insertions(+), 30 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
> index e42ea1195d18..707d17414dee 100644
> --- a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
> +++ b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
> @@ -10,32 +10,59 @@
>  #include <test_maps.h>
>  
>  static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
> -			     int *values)
> +			     __s64 *values, bool is_pcpu)
>  {
> -	int i, err;
> +	int nr_cpus = libbpf_num_possible_cpus();
Instead of getting it multiple times, how about moving it out to
a static global and initialize it in test_array_map_batch_ops().


> +	int i, j, err;
> +	int offset = 0;
>  	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
>  		.elem_flags = 0,
>  		.flags = 0,
>  	);
>  
> +	CHECK(nr_cpus < 0, "nr_cpus checking",
> +	      "error: get possible cpus failed");
> +
>  	for (i = 0; i < max_entries; i++) {
>  		keys[i] = i;
> -		values[i] = i + 1;
> +		if (is_pcpu)
> +			for (j = 0; j < nr_cpus; j++)
> +				(values + offset)[j] = i + 1 + j;
> +		else
> +			values[i] = i + 1;
> +		offset += nr_cpus;
This "offset" update here is confusing to read because it is only
used in the is_pcpu case but it always gets updated regardless.
How about only defines and uses offset in the "if (is_pcpu)" case and
rename it to "cpu_offset": cpu_offset = i * nr_cpus.

The same goes for other occasions.

>  	}
>  
>  	err = bpf_map_update_batch(map_fd, keys, values, &max_entries, &opts);
>  	CHECK(err, "bpf_map_update_batch()", "error:%s\n", strerror(errno));
>  }
>  
> -static void map_batch_verify(int *visited, __u32 max_entries,
> -			     int *keys, int *values)
> +static void map_batch_verify(int *visited, __u32 max_entries, int *keys,
> +			     __s64 *values, bool is_pcpu)
>  {
> -	int i;
> +	int nr_cpus = libbpf_num_possible_cpus();
> +	int i, j;
> +	int offset = 0;
> +
> +	CHECK(nr_cpus < 0, "nr_cpus checking",
> +	      "error: get possible cpus failed");
>  
>  	memset(visited, 0, max_entries * sizeof(*visited));
>  	for (i = 0; i < max_entries; i++) {
> -		CHECK(keys[i] + 1 != values[i], "key/value checking",
> -		      "error: i %d key %d value %d\n", i, keys[i], values[i]);
> +		if (is_pcpu) {
> +			for (j = 0; j < nr_cpus; j++) {
> +				__s64 value = (values + offset)[j];
> +				CHECK(keys[i] + j + 1 != value,
> +				      "key/value checking",
> +				      "error: i %d j %d key %d value %d\n", i,
> +				      j, keys[i], value);
> +			}
> +		} else {
> +			CHECK(keys[i] + 1 != values[i], "key/value checking",
> +			      "error: i %d key %d value %d\n", i, keys[i],
> +			      values[i]);
> +		}
> +		offset += nr_cpus;
>  		visited[i] = 1;
>  	}
>  	for (i = 0; i < max_entries; i++) {
> @@ -44,45 +71,52 @@ static void map_batch_verify(int *visited, __u32 max_entries,
>  	}
>  }
>  
> -void test_array_map_batch_ops(void)
> +void __test_map_lookup_and_update_batch(bool is_pcpu)
static

>  {
> +	int nr_cpus = libbpf_num_possible_cpus();
>  	struct bpf_create_map_attr xattr = {
>  		.name = "array_map",
> -		.map_type = BPF_MAP_TYPE_ARRAY,
> +		.map_type = is_pcpu ? BPF_MAP_TYPE_PERCPU_ARRAY :
> +				      BPF_MAP_TYPE_ARRAY,
>  		.key_size = sizeof(int),
> -		.value_size = sizeof(int),
> +		.value_size = sizeof(__s64),
>  	};
> -	int map_fd, *keys, *values, *visited;
> +	int map_fd, *keys, *visited;
>  	__u32 count, total, total_success;
>  	const __u32 max_entries = 10;
>  	__u64 batch = 0;
> -	int err, step;
> +	int err, step, value_size;
> +	void *values;
>  	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
>  		.elem_flags = 0,
>  		.flags = 0,
>  	);
>  
> +	CHECK(nr_cpus < 0, "nr_cpus checking",
> +	      "error: get possible cpus failed");
> +
>  	xattr.max_entries = max_entries;
>  	map_fd = bpf_create_map_xattr(&xattr);
>  	CHECK(map_fd == -1,
>  	      "bpf_create_map_xattr()", "error:%s\n", strerror(errno));
>  
> -	keys = malloc(max_entries * sizeof(int));
> -	values = malloc(max_entries * sizeof(int));
> -	visited = malloc(max_entries * sizeof(int));
> +	value_size = sizeof(__s64);
> +	if (is_pcpu)
> +		value_size *= nr_cpus;
> +
> +	keys = malloc(max_entries * sizeof(*keys));
> +	values = calloc(max_entries, value_size);
Why only this one uses calloc?

> +	visited = malloc(max_entries * sizeof(*visited));
>  	CHECK(!keys || !values || !visited, "malloc()", "error:%s\n",
>  	      strerror(errno));
>  
> -	/* populate elements to the map */
> -	map_batch_update(map_fd, max_entries, keys, values);
> -
>  	/* test 1: lookup in a loop with various steps. */
>  	total_success = 0;
>  	for (step = 1; step < max_entries; step++) {
> -		map_batch_update(map_fd, max_entries, keys, values);
> -		map_batch_verify(visited, max_entries, keys, values);
> +		map_batch_update(map_fd, max_entries, keys, values, is_pcpu);
> +		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
>  		memset(keys, 0, max_entries * sizeof(*keys));
> -		memset(values, 0, max_entries * sizeof(*values));
> +		memset(values, 0, max_entries * value_size);
>  		batch = 0;
>  		total = 0;
>  		/* iteratively lookup/delete elements with 'step'
> @@ -91,10 +125,10 @@ void test_array_map_batch_ops(void)
>  		count = step;
>  		while (true) {
>  			err = bpf_map_lookup_batch(map_fd,
> -						total ? &batch : NULL, &batch,
> -						keys + total,
> -						values + total,
> -						&count, &opts);
> +						   total ? &batch : NULL,
> +						   &batch, keys + total,
> +						   values + total * value_size,
> +						   &count, &opts);
>  
>  			CHECK((err && errno != ENOENT), "lookup with steps",
>  			      "error: %s\n", strerror(errno));
> @@ -108,7 +142,7 @@ void test_array_map_batch_ops(void)
>  		CHECK(total != max_entries, "lookup with steps",
>  		      "total = %u, max_entries = %u\n", total, max_entries);
>  
> -		map_batch_verify(visited, max_entries, keys, values);
> +		map_batch_verify(visited, max_entries, keys, values, is_pcpu);
>  
>  		total_success++;
>  	}
> @@ -116,9 +150,25 @@ void test_array_map_batch_ops(void)
>  	CHECK(total_success == 0, "check total_success",
>  	      "unexpected failure\n");
>  
> -	printf("%s:PASS\n", __func__);
> -
>  	free(keys);
> -	free(values);
>  	free(visited);
> +	free(values);
This re-ordering is unnecessary.

> +}
> +
> +void array_map_batch_ops(void)
static

> +{
> +	__test_map_lookup_and_update_batch(false);
> +	printf("test_%s:PASS\n", __func__);
> +}
> +
> +void array_percpu_map_batch_ops(void)
static

> +{
> +	__test_map_lookup_and_update_batch(true);
> +	printf("test_%s:PASS\n", __func__);
> +}
> +
> +void test_array_map_batch_ops(void)
> +{
> +	array_map_batch_ops();
> +	array_percpu_map_batch_ops();
>  }
> -- 
> 2.25.1
> 
