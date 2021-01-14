Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388492F6CCE
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbhANVCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:02:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728792AbhANVCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:02:39 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10EKx9mj018764;
        Thu, 14 Jan 2021 13:01:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6HT4dHA0YukUdV9HZDZplfF2ldeuDJ3qNM0j1ezlkBA=;
 b=WJ6ZyRHvqYY+cXQg34VRz18YFaIpXh1tHTanSxc4E6GhEOlpQVasZo/P+p4oIGrbBQet
 dcjlf13zlyytliVmzGY8e5Jp+Vt+zPZzaenMHAdtscYM/f8jQQaJah94XYPzQgUGGVLu
 zMltzxb7EYPmjp5jI8meXGvSSh2OtlsKh0w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fp359tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 Jan 2021 13:01:42 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 14 Jan 2021 13:01:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSrwr5sNn8gplTpsW2iqbzXOBaC0WJUHN+qIEvVw9CSp5BSMCcSbtBtCl0UpIrIA9gHPHluNXFyBjd9+aAdhadp8ac0T2/Aa96AlaJxS3PAtPXJbTdi/iwj9M2HTU69q3yDbTgZJfzMqV1isbKOZcylmvQic9+if+wwroBU4q9uumBZAdE75lcy1YqpfB4cnTqUGSJC1KQhdWJWs1aw21yDrOXgsYHkEhk1uYMrvCIMPQ08HxXYhzo7t2s6rTU3NnYBit+F1d/JqbOyBvOZae4joLC3muumhS3r6H2TSpni49zZ+ZfA6n5D0r/hrd2bKfZEZ76xbj79m2+g8lTP5vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HT4dHA0YukUdV9HZDZplfF2ldeuDJ3qNM0j1ezlkBA=;
 b=XlrsjlFH3h3alTBClpbIg9TVO+rFieei1fYV6SLdV8RY5TUdufnIzUrwHV+3aiqOvlgmNL0QFffl394MlB4pX7CCOMoqo4LKlM3GZ/ysuZNedPP9vpqxZT4AYJuM2itagzzhGmLI7OCGRbdSTb81iWWiKno4J4sGB+j1Kj/qaQ2bcWTbY0mTW1QovFcjrZRyGxhyN6n2fYc2T42wtBm2r5OnxIyHOT9kzL515noJhqx48Jsdj56M/ov38at4aqxnHAeSKLlIpyyjDRMD0XPCqQQ3tWo+EbIevcb00+8Nu/7XMJQFadb8q5C3Cc4lIQEYV29VqhT7QV1pLc8VK0Rm+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HT4dHA0YukUdV9HZDZplfF2ldeuDJ3qNM0j1ezlkBA=;
 b=THto/MNDkZ4/njlOmDQ0MsYMapZW56E1ROuptyGtJ2gcjI9eYvWQwpBTvUyvdaATM3S0XBFamU5RmwUkYtGW4HwMVWfv6lKWM+WFz5ENXah67B693RYszUmo5S1rMjGc//gs84YJHNKd0csjvLCN4EQz+pHT+ySyNWZz6w3DqIs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3572.namprd15.prod.outlook.com (2603:10b6:a03:1b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 21:01:31 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 21:01:31 +0000
Subject: Re: [PATCHv6 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
To:     Hangbin Liu <liuhangbin@gmail.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201211024049.1444017-1-liuhangbin@gmail.com>
 <20210114142732.2595651-1-liuhangbin@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4d9b5846-bd08-09b4-53a2-3cb02a9a1eee@fb.com>
Date:   Thu, 14 Jan 2021 13:01:28 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114142732.2595651-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:ab59]
X-ClientProxiedBy: CO2PR04CA0189.namprd04.prod.outlook.com
 (2603:10b6:104:5::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:ab59) by CO2PR04CA0189.namprd04.prod.outlook.com (2603:10b6:104:5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 21:01:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8355372-f7c1-48b3-53c4-08d8b8cf91a4
X-MS-TrafficTypeDiagnostic: BY5PR15MB3572:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3572D43D4F6A50ABD0C740ECD3A80@BY5PR15MB3572.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SPundpbiToJYhXZN7g4kXQhvfCz00HPYSMeeF8vZXbRrTyhwm1MUxm9WX6ZwSgAUtp9QVKRir7kyaoC+aNjTghR44afuq8m1XrsNGwWAfXvpr1rj8WYE6YXM6ghhGMciGr4gKOX9jzv2gR1GjuKSAFineKB8QDAMgT7od1A1LcOhTonOkWN3PZtuS8XSdOpORWlE8URTQ/BN2h1RuQFXa1zksjSBW+8vpFWVxI9xv4hYhnAR4eMQLw2SPnjtP1ExGfyKBolHpe9YBjWaFfelREjRLYf6Hr8siWlnuQQQ1l3nfu2JBDXll+5wi7CpU8U0KiZXft1ZocP5qPL2s8sb/FJACGv20ZwXzaduoQ7vpAbGmPXqG+zpCk458+Qmxu1QAnbMRMteJbqhFhL0lyBoQ0rsXp7a3NAx9vEZHMxTxzYlJFol0i/6hW3i1urq+6w2irol+C3Vcdrih451CTkPQGPAFUvg3cChbJYzOquTYho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(136003)(376002)(54906003)(316002)(8676002)(4326008)(478600001)(8936002)(36756003)(53546011)(31696002)(6486002)(5660300002)(66946007)(66476007)(66556008)(2906002)(16526019)(31686004)(83380400001)(2616005)(186003)(86362001)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MGliR3JvNy84R1VYWUhuWkRKMWJQMGZ5VmFLYzVseDI3dmV1UktZSG8xMjUx?=
 =?utf-8?B?N2tuWVFZdkU5MFpYWStrRmFRTEJJSVVkK1hvZWwrK2o2eWRlTytJNFl0WENy?=
 =?utf-8?B?cCtGdlg5VDhwMTNldUQ0dUZZaVh1cktNbjhYc0NDMjA3Rm1tUlJmeE04SG1q?=
 =?utf-8?B?VFFiTmtzbEpFVXNWQVlJV2k3RTJIWTh3dTd6NkF4dXM0azV3MFE3cjhDQUR5?=
 =?utf-8?B?OWdlYTI4R2p3WmI2N3pxVUlrdVExRnkwaXpHajFzb0JoOXB0Z2RSZmErR2Nn?=
 =?utf-8?B?NTlrSk9aRDNCN3pqSWNxL2NWcTNMNko2RHNUYVhyM3E1VSswQkZ3Ulg0QVgy?=
 =?utf-8?B?M21zTm92K2F5OU5SOUpEMGlsTEV4MytIZitTcElkeXQvRTQvdUY2VktUTDhr?=
 =?utf-8?B?STcvM1ZERlBFRmxsSGhFR05lR2loWlhtOGk5cHk4L1NWYWhrQXR0UVhrUm9G?=
 =?utf-8?B?c3Q3ZWJscExEMlJUMlo1SnhYeDdlc00rU0RwaE1yd0l2STVYdDE5eUxsMUtQ?=
 =?utf-8?B?eEVJbGFlNVd4RitBNEIzdGluMHpocE5LUmVTc3VHaUFNRVMvUlJlSnhhZWhj?=
 =?utf-8?B?eVh5RnB5WGtXb0Z5c1Bnc1o4NjRKTitqMmdLOHQwLzlXSDNRL2hnMkxYOXNQ?=
 =?utf-8?B?L1QxeCsvUk9IU0s3RC9pMklxNkNxYzVacDJKMHhTSmNFblh6YmNoU1NnZUVU?=
 =?utf-8?B?UVNHbU85dzNKeEdDbDJZMDhaVWUzL21QSkJLZ0FpRVg4bjF0d1BYNVFnV05B?=
 =?utf-8?B?bjJhVmVDMGUydW5renFlS2JQQXN3cjg2MUVZUmdScDBNSWpCUjJDL1lONVpl?=
 =?utf-8?B?dElrYWdOTFdOeS80TlBmakN3NC8xS3pxSUxLTThmSUZGeHNvUUx4bDBvdGU1?=
 =?utf-8?B?Q0xOSXovS0t1Z0dZK3BEZ0FSTkViRDJHc0E5eTMyR1NoRmZzT09OVVgydWRR?=
 =?utf-8?B?OVJyYkJSWFJrUUhwREJ0bHk3RjMxZFpicEd1WnVhbWtSRUFqbDlXN3RVUlJZ?=
 =?utf-8?B?M3RGZ2wrOUVHaGlTeGFDWmlka2FWSGp6Rm9qUmtzZytwejQ1N3VOemczcCtn?=
 =?utf-8?B?WUxLMjhRc0VyU1V1alJlemlxSlB3NFZZa3IwQ05ZRUF4dDdtYTExTHFKcGw2?=
 =?utf-8?B?cHZONW41TFM5bDNSUFhFZzNOOWw0ZjR5MmtIeFBXcExjejdkcCtORm4rcVMy?=
 =?utf-8?B?TnBNL0J6dmNXRHJLNHZmVHVqWm4yVnczYzhhOU1XQTBwcVhPY0NZNC9NU0x3?=
 =?utf-8?B?c0JqS1FKclB3cDI2LzZTTDNaNEd4VEQ2RE5DMjRVM2YvZmVBQ1JnUWcwOFFo?=
 =?utf-8?B?SEhDSnpra0wyUmhFbUlodWxjVVRGQmFmS1R4ZnZGRysyNUZ1Zk8wM1lSbyt0?=
 =?utf-8?B?NEpvbWh1ZkZKRXc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:01:31.3902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: a8355372-f7c1-48b3-53c4-08d8b8cf91a4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XnjDCl9gRS6+CLnFJ6zG5iTtmHcRXV13LeQiJaPwMVwlrmN2Lm+I9thOVmwDersb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3572
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_08:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/21 6:27 AM, Hangbin Liu wrote:
> This patch add a xdp program on egress to show that we can modify
> the packet on egress. In this sample we will set the pkt's src
> mac to egress's mac address. The xdp_prog will be attached when
> -X option supplied.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> ---
> v6: no code update, only rebase the code on latest bpf-next
> 
> v5:
> a) close fd when err out in get_mac_addr()
> b) exit program when both -S and -X supplied.
> 
> v4:
> a) Update get_mac_addr socket create
> b) Load dummy prog regardless of 2nd xdp prog on egress
> 
> v3:
> a) modify the src mac address based on egress mac
> 
> v2:
> a) use pkt counter instead of IP ttl modification on egress program
> b) make the egress program selectable by option -X
> ---
>   samples/bpf/xdp_redirect_map_kern.c |  75 ++++++++++++++--
>   samples/bpf/xdp_redirect_map_user.c | 135 +++++++++++++++++++++++-----
>   2 files changed, 184 insertions(+), 26 deletions(-)
> 
> diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
> index 6489352ab7a4..8b8e73d25ad6 100644
> --- a/samples/bpf/xdp_redirect_map_kern.c
> +++ b/samples/bpf/xdp_redirect_map_kern.c
> @@ -19,12 +19,22 @@
>   #include <linux/ipv6.h>
>   #include <bpf/bpf_helpers.h>
>   
> +/* The 2nd xdp prog on egress does not support skb mode, so we define two
> + * maps, tx_port_general and tx_port_native.
> + */
>   struct {
>   	__uint(type, BPF_MAP_TYPE_DEVMAP);
>   	__uint(key_size, sizeof(int));
>   	__uint(value_size, sizeof(int));
>   	__uint(max_entries, 100);
> -} tx_port SEC(".maps");
> +} tx_port_general SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_DEVMAP);
> +	__uint(key_size, sizeof(int));
> +	__uint(value_size, sizeof(struct bpf_devmap_val));
> +	__uint(max_entries, 100);
> +} tx_port_native SEC(".maps");
>   
>   /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
>    * feedback.  Redirect TX errors can be caught via a tracepoint.
> @@ -36,6 +46,14 @@ struct {
>   	__uint(max_entries, 1);
>   } rxcnt SEC(".maps");
>   
> +/* map to stroe egress interface mac address */

s/stroe/store

> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__type(key, u32);
> +	__type(value, __be64);
> +	__uint(max_entries, 1);
> +} tx_mac SEC(".maps");
> +
>   static void swap_src_dst_mac(void *data)
>   {
>   	unsigned short *p = data;
> @@ -52,17 +70,16 @@ static void swap_src_dst_mac(void *data)
>   	p[5] = dst[2];
>   }
>   
[...]
>   int main(int argc, char **argv)
>   {
>   	struct bpf_prog_load_attr prog_load_attr = {
> -		.prog_type	= BPF_PROG_TYPE_XDP,
> +		.prog_type	= BPF_PROG_TYPE_UNSPEC,
>   	};
> -	struct bpf_program *prog, *dummy_prog;
> +	struct bpf_program *prog, *dummy_prog, *devmap_prog;
> +	int devmap_prog_fd_0 = -1, devmap_prog_fd_1 = -1;

The default value is -1 here. I remembered there was a discussion
about the default value here, does default value 0 work here?

> +	int prog_fd, dummy_prog_fd;
> +	int tx_port_map_fd, tx_mac_map_fd;
> +	struct bpf_devmap_val devmap_val;
>   	struct bpf_prog_info info = {};
>   	__u32 info_len = sizeof(info);
> -	int prog_fd, dummy_prog_fd;
> -	const char *optstr = "FSN";
> +	const char *optstr = "FSNX";
>   	struct bpf_object *obj;
>   	int ret, opt, key = 0;
>   	char filename[256];
> -	int tx_port_map_fd;
>   
>   	while ((opt = getopt(argc, argv, optstr)) != -1) {
>   		switch (opt) {
> @@ -120,14 +154,21 @@ int main(int argc, char **argv)
>   		case 'F':
>   			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
>   			break;
> +		case 'X':
> +			xdp_devmap_attached = true;
> +			break;
>   		default:
>   			usage(basename(argv[0]));
>   			return 1;
>   		}
>   	}
>   
> -	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
> +	if (!(xdp_flags & XDP_FLAGS_SKB_MODE)) {
>   		xdp_flags |= XDP_FLAGS_DRV_MODE;
> +	} else if (xdp_devmap_attached) {
> +		printf("Load xdp program on egress with SKB mode not supported yet\n");
> +		return 1;
> +	}
>   
>   	if (optind == argc) {
>   		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
> @@ -150,24 +191,28 @@ int main(int argc, char **argv)
>   	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
>   		return 1;
>   
> -	prog = bpf_program__next(NULL, obj);
> -	dummy_prog = bpf_program__next(prog, obj);
> -	if (!prog || !dummy_prog) {
> -		printf("finding a prog in obj file failed\n");
> -		return 1;
> +	if (xdp_flags & XDP_FLAGS_SKB_MODE) {
> +		prog = bpf_object__find_program_by_title(obj, "xdp_redirect_general");

libbpf supports each section having multiple programs, so 
bpf_object__find_program_by_title() is not recommended.
Could you change to bpf_object__find_program_by_name()?

> +		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_general");
> +	} else {
> +		prog = bpf_object__find_program_by_title(obj, "xdp_redirect_native");
> +		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_native");
> +	}
> +	dummy_prog = bpf_object__find_program_by_title(obj, "xdp_redirect_dummy");
> +	if (!prog || dummy_prog < 0 || tx_port_map_fd < 0) {
> +		printf("finding prog/tx_port_map in obj file failed\n");
> +		goto out;
>   	}
> -	/* bpf_prog_load_xattr gives us the pointer to first prog's fd,
> -	 * so we're missing only the fd for dummy prog
> -	 */
> +	prog_fd = bpf_program__fd(prog);
>   	dummy_prog_fd = bpf_program__fd(dummy_prog);
> -	if (prog_fd < 0 || dummy_prog_fd < 0) {
> +	if (prog_fd < 0 || dummy_prog_fd < 0 || tx_port_map_fd < 0) {
>   		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
>   		return 1;
>   	}
>   
> -	tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port");
> +	tx_mac_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_mac");
>   	rxcnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rxcnt");
> -	if (tx_port_map_fd < 0 || rxcnt_map_fd < 0) {
> +	if (tx_mac_map_fd < 0 || rxcnt_map_fd < 0) {
>   		printf("bpf_object__find_map_fd_by_name failed\n");
>   		return 1;
>   	}
[...]
