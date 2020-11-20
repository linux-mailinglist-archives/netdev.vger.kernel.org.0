Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF63E2BB495
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732131AbgKTSyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:54:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37560 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732123AbgKTSyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 13:54:36 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKIoCOa005313;
        Fri, 20 Nov 2020 10:54:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2lARocLmhZeuVxBFzz0qnGj7F3eZIZSFU54OSkNvk58=;
 b=T4pUPQlR8LFiT9T/9YYhbVYoMTqaX20D3mWpi9h1VUFek74KEss+t3ZCPvC6aAfzFWWK
 Bl7ouuj3aEscb2dPV+GBo5D0G+qhXq90MMWSIXHA8zuIvpf9Jrm+E0CQ4L0bDsIqfCAj
 G6Hgajji7L+IplSY/1ST87CgAetbYQZpPQA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34xat42w8a-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 10:54:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 10:54:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJuxbtY9fgw501QOoJB9r9eQCFW1iVnH+YDS4ty5hcuAieypqo//RHB+vB6u189cGsyIxiZLVeHeqwDFR/qEXgK5wzkeSu3R+bFNHAfdwBHQe0K5tAfNM87IIXGe63fc0U1qNZeuFiNqx7V14PGdFgQvYeO3bGmMpiDbzZCx0lq1TZvhtx1vthVNiI4soTwCIDZhfif3AEU+1oKjfa+K2dZEJw+/Pi39slF1+onGzoNBdjRZ6h99p7yGsEfW2482C/09xN6107dTTV6lC0imbd/pCjyE1SAQMBwZhG9ZSi+lV+7SsutGR/pEh08QHJK52KvRJ1YrySkXFsogOTBCyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lARocLmhZeuVxBFzz0qnGj7F3eZIZSFU54OSkNvk58=;
 b=eea46y/Zt9JQFOfpeqQ2MUPzsfpKhoNnLfZqf+wr3OF8vv/0HCt1PgE+V+19YGOkD+OovN63Iu2kWFNYdahMT35SlotJQkQg5EGP3BSNuuOMiGrFDL6eRdefao88ST3hAeFtPPYRJmWBDI+8mQSqYyU4NnBwszum3IcWI4qTvfvqLOtWgfR6Cutbjvuy6xjCs+/ZKOrmMXSxwp/TOAjVqn+X7X3tBRVNvbaK6flJLROOP6CKPBegskSI8z7HweoxZksnOXFC1Yf4MIQZFapfa+ZfdW9s2/BglnW0MoJtvx4swSEOIJqFnJl15brf/6PyJRmt8drOET+lxQsPMnmAxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lARocLmhZeuVxBFzz0qnGj7F3eZIZSFU54OSkNvk58=;
 b=Emn1MYIOvzxE0sZ5aRrgH8ZCgsJ7A3F//nYbamrA6umJM2tGvMyvreATxHPrSVTvmiEHH5OaRFVR4UJ+mZHR8asdd1jNuE8MlRLOiskWO9gy3RA+uSqnrlqtC8U8LhHbW7r+vKPo3bXRYZN7bCGXPWAdC+hWwIm5gJ549tFhYoU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3302.namprd15.prod.outlook.com (2603:10b6:a03:10f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 20 Nov
 2020 18:54:12 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%6]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 18:54:12 +0000
Subject: Re: [PATCH bpf-next v2 2/5] selftests/bpf: xsk selftests - SKB POLL,
 NOPOLL
To:     Weqaar Janjua <weqaar.janjua@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <magnus.karlsson@gmail.com>, <bjorn.topel@intel.com>
CC:     Weqaar Janjua <weqaar.a.janjua@intel.com>, <shuah@kernel.org>,
        <skhan@linuxfoundation.org>, <linux-kselftest@vger.kernel.org>,
        <anders.roxell@linaro.org>, <jonathan.lemon@gmail.com>
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
 <20201120130026.19029-3-weqaar.a.janjua@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c73ca08d-4eae-c56f-f5fe-b4dd1440773b@fb.com>
Date:   Fri, 20 Nov 2020 10:54:09 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
In-Reply-To: <20201120130026.19029-3-weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:f0a]
X-ClientProxiedBy: MWHPR22CA0069.namprd22.prod.outlook.com
 (2603:10b6:300:12a::31) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1688] (2620:10d:c090:400::5:f0a) by MWHPR22CA0069.namprd22.prod.outlook.com (2603:10b6:300:12a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 18:54:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d669d0ce-b573-49f0-43c5-08d88d85abdd
X-MS-TrafficTypeDiagnostic: BYAPR15MB3302:
X-Microsoft-Antispam-PRVS: <BYAPR15MB33026F602285DDD35775AEADD3FF0@BYAPR15MB3302.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 00N+pj34qcyhZHgaM+3ylY5jTFZOP7mnG1+CCC5y9p9ipt8K9ArN2eDY0a4UDIjy0BIkWaA0Tn2FrW/we+w91nTI5exQ9VbqB75uo11If75ca5Y5qBTsjRG4sxiFuaw52s3RqPNAKSkFR2JECslKnnz4YYXpVb+6j/Fok0fTDcqvtaqY470mHzXP4R42S0/yEBs0v4usXoKqjSWmE/OyJAah7adqQZJu3CdEQUaVxvs/LkcU4LTkOcaM8atjk+f+Ky6P4MLxoZQwTlQAk8+6VfJJymif0cvQmS0Y3lYPxLlwotUG6h3JGxFi3mK9Ygq3q7dzj1cBwxC6p0RnhMjorpnc8O6XsDbp3NPmcx2hjMOkI8WdcbfvVG79BXC4zecw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(366004)(396003)(36756003)(5660300002)(53546011)(2906002)(8676002)(186003)(52116002)(16526019)(4326008)(6486002)(7416002)(8936002)(31696002)(316002)(2616005)(66946007)(66476007)(31686004)(83380400001)(66556008)(478600001)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Gw/M3Fje9C8zZWpw3F0Fn1Xmg44e/ryQYhkOVFjzrqQcVA91DMjuF7WqX7qcUL6E8Ymjcmr5b4Jwhh+irfFCeDC+pQ2LR/HGUXZy6Rkahv65IU6WkP3+8MZU3rEDBBT7bkV12NqAvEUv5aWGykNwPYcbaISwwPNd4LbcLufvKouUbJDECywNcqDqoNro3A0yxOyNUSDAmB3J8yrXq872AYmJmTjBAb0Sqdq86C0gVgzP9jMxQ88AJExQkEvku78bfEh2bNBVS7nILQsqeWV462GnF1iE1LwImnZWN5n0aMvZHqx9qE/taOtm8ECKEUkkfDOFRBmF4F3J0lCYmTu4ZXO74+66kyGsNYyH55TK3Q5OoUyLSj7ha1R7LLjhrnAT8W2D9F6qUWtcEAmplOff5fXkWaquHGXs9TOictAahrgZ3wVv9fhmffSVJB9QrDBqJPNBG7BejajIHaFgrRmkmuNz64CJvZzy6+MejPeF9TuIJDQgg5gtLzoK1Xvzy4/1lhZJB/GMpIpWfeBl+w3SnSnfC13bTtaJYNqsaUVCYyoNE/azSYHu1AW56Tlgkga9mbSsc2VtggfZcmrB8u7GMmkbYhdp5rD2ssZC0rJFJayjFwmahH5CydW1FixXEROVKgbHRRtUKpgC+bBSGgH4oMaNhmOlxt6zuk49vucqpDUoxU+bp23y+fbsTGC083U7TZ9Vf90zPG0ZvYkMkfyMZuJJ/OnjVRyhugL6ezB4H408Vziojax3+2VIbGpRXA6DiGyrARl0b7paq12Yen+AAKLUwGHUZsxW288O1qE/LZXmb4k1LPzlPRroKA9pqOXypHhIXJTSwdcFqoeZWDToAbJhOWLUwMiuJ5f9daOJnEvvPOPqHfOaxWHl1rYr1wVwqaNJtDm9HijEBRuT8n7kW5wKWiIGEpLrbnYrOz58S6g=
X-MS-Exchange-CrossTenant-Network-Message-Id: d669d0ce-b573-49f0-43c5-08d88d85abdd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 18:54:12.8215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crLNVXUHQt78b80Xlbo0M0N304mLUaYaiQZ1Q4ndC3EgmDVS5hLp9LAgynWluH/V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3302
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_12:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1011 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/20 5:00 AM, Weqaar Janjua wrote:
> Adds following tests:
> 
> 1. AF_XDP SKB mode
>     Generic mode XDP is driver independent, used when the driver does
>     not have support for XDP. Works on any netdevice using sockets and
>     generic XDP path. XDP hook from netif_receive_skb().
>     a. nopoll - soft-irq processing
>     b. poll - using poll() syscall
> 
> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> ---
>   tools/testing/selftests/bpf/Makefile          |   5 +-
>   .../selftests/bpf/test_xsk_prerequisites.sh   |  15 +-
>   .../selftests/bpf/test_xsk_skb_nopoll.sh      |  20 +
>   ..._xsk_framework.sh => test_xsk_skb_poll.sh} |  12 +-
>   tools/testing/selftests/bpf/xdpxceiver.c      | 961 ++++++++++++++++++
>   tools/testing/selftests/bpf/xdpxceiver.h      | 151 +++
>   tools/testing/selftests/bpf/xsk_env.sh        |  17 +
>   7 files changed, 1174 insertions(+), 7 deletions(-)
>   create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_nopoll.sh
>   rename tools/testing/selftests/bpf/{test_xsk_framework.sh => test_xsk_skb_poll.sh} (61%)
>   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
>   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 51436db24f32..17af570a32d7 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -73,7 +73,8 @@ TEST_PROGS := test_kmod.sh \
>   	test_bpftool.sh \
>   	test_bpftool_metadata.sh \
>   	test_xsk_prerequisites.sh \
> -	test_xsk_framework.sh
> +	test_xsk_skb_nopoll.sh \
> +	test_xsk_skb_poll.sh
>   
>   TEST_PROGS_EXTENDED := with_addr.sh \
>   	with_tunnels.sh \
> @@ -84,7 +85,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>   # Compile but not part of 'make run_tests'
>   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>   	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> -	test_lirc_mode2_user xdping test_cpp runqslower bench
> +	test_lirc_mode2_user xdping test_cpp runqslower bench xdpxceiver
>   
>   TEST_CUSTOM_PROGS = urandom_read
>   
> diff --git a/tools/testing/selftests/bpf/test_xsk_prerequisites.sh b/tools/testing/selftests/bpf/test_xsk_prerequisites.sh
> index 00bfcf53127c..a9ce8887dffc 100755
> --- a/tools/testing/selftests/bpf/test_xsk_prerequisites.sh
> +++ b/tools/testing/selftests/bpf/test_xsk_prerequisites.sh
> @@ -8,8 +8,17 @@
>   #
>   # Topology:
>   # ---------
> -#      -----------           -----------
> -#      |  xskX   | --------- |  xskY   |
> +#                 -----------
> +#               _ | Process | _
> +#              /  -----------  \
> +#             /        |        \
> +#            /         |         \
> +#      -----------     |     -----------
> +#      | Thread1 |     |     | Thread2 |
> +#      -----------     |     -----------
> +#           |          |          |
> +#      -----------     |     -----------
> +#      |  xskX   |     |     |  xskY   |
>   #      -----------     |     -----------
>   #           |          |          |
>   #      -----------     |     ----------
> @@ -40,6 +49,8 @@
>   #       conflict with any existing interface
>   #   * tests the veth and xsk layers of the topology
>   #
> +# See the source xdpxceiver.c for information on each test
> +#
>   # Kernel configuration:
>   # ---------------------
>   # See "config" file for recommended kernel config options.
> diff --git a/tools/testing/selftests/bpf/test_xsk_skb_nopoll.sh b/tools/testing/selftests/bpf/test_xsk_skb_nopoll.sh
> new file mode 100755
> index 000000000000..96600b0f5136
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_xsk_skb_nopoll.sh
> @@ -0,0 +1,20 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2020 Intel Corporation.
> +
> +# See test_xsk_prerequisites.sh for detailed information on tests
> +
> +. xsk_prereqs.sh
> +. xsk_env.sh
> +
> +TEST_NAME="SKB NOPOLL"
> +
> +vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
> +
> +params=("-S")
> +execxdpxceiver params
> +
> +retval=$?
> +test_status $retval "${TEST_NAME}"
> +
> +test_exit $retval 0
> diff --git a/tools/testing/selftests/bpf/test_xsk_framework.sh b/tools/testing/selftests/bpf/test_xsk_skb_poll.sh
> similarity index 61%
> rename from tools/testing/selftests/bpf/test_xsk_framework.sh
> rename to tools/testing/selftests/bpf/test_xsk_skb_poll.sh
> index 2e3f099d001c..d152c8a24251 100755
> --- a/tools/testing/selftests/bpf/test_xsk_framework.sh
> +++ b/tools/testing/selftests/bpf/test_xsk_skb_poll.sh
> @@ -7,11 +7,17 @@
>   . xsk_prereqs.sh
>   . xsk_env.sh

Here both xsk_prereqs.sh and xsk_env.sh are executed.
But xsk_env.sh also calls xsk_prereqs.sh. This double
execution of xsk_prereqs.sh is required or is an
oversight?

>   
> -TEST_NAME="XSK FRAMEWORK"
> +TEST_NAME="SKB POLL"
>   
> -test_status $ksft_pass "${TEST_NAME}"
> +vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
> +
> +params=("-S" "-p")
> +execxdpxceiver params
> +
> +retval=$?
> +test_status $retval "${TEST_NAME}"
>   
>   # Must be called in the last test to execute
>   cleanup_exit ${VETH0} ${VETH1} ${NS1}
>   
> -test_exit $ksft_pass 0
> +test_exit $retval 0
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
[...]
