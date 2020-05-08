Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8A21CA4FF
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgEHHUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:20:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8672 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbgEHHUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 03:20:06 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0487J5RP006550;
        Fri, 8 May 2020 00:19:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=BhW+eCSlodez48sMEkwbt2u84r06uGWDI3RbfDDYNZ4=;
 b=NtgjXolf8xnnFOyVEuGnQNwyCULArJf0i5kaol+MbXqQdZowFGntz8T6VsnmA8LYNwzf
 frWazbVoy+GJBIJ52gyMxsqkVH68gxZVncZnQm4Iep7XEPvkWniEI3wBDV8yrnON8wlw
 njciQFtuJN4XKUTrH+PPYhVSfvkHhHxYnq4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtcyj6ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 00:19:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 00:19:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXb/zZdhjfKHqauMHhdy6uGIaa39fe7HmyClDXldk1VQ8AWVY+tadmSKeO4r/EyacTghHOKu0g4B+psAthhb4y+HLwdfT5nOt9JTIiJpwAyC/XqhjrFJBy+zwglYBRYZIXd3IJTxhWsN458wb0A0ydT+/sL5zhVzPPk/xZtv4YOg90ma4O/jKNY1okv/Ju0ox5SLZuh1Z6DGEZucR0SY6Wy/mia3zl457VTczte+tJZK1YzX5ywUdjnFFspbjszgQP6NcD4BXa4Y9SCVHKNTYO/a8BGnHeaWplmXUQ2d0M+BDi6K+hFcqqr1I9x2RBNWKwiK9kFynrI8OoxpykBuoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhW+eCSlodez48sMEkwbt2u84r06uGWDI3RbfDDYNZ4=;
 b=aQiSdenOShZyRYniDLbfWHd6sYTfFoAVG9ES6t/ZzxvaJBh92ZTZX4fIY97XCjgB1PoqN+eTMDxIl31a/iuMB8Wtbk3UiO3QA2Cmcon71H2dWRO4lF63jyTyaW7PjXqgfdwby5GCceabLrsQKVCyAO/U0oZF6R2WtICY7WlcQF8eyOYB2Kq5e59td5xE53DmEPewt6kiPYlXLTZp/ZADaVqmAED2N4jMsv6kxkSf7JiJyEiD29/UpMWPqAKxelCsHJF+19lkPqxDsI2HeWeH5ucCpsxkbV7hE1fDfoZZNy7heBBjwskt26mZkl1nRMyPh/sv8LJ4F2IHaj1XrkKRvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhW+eCSlodez48sMEkwbt2u84r06uGWDI3RbfDDYNZ4=;
 b=PQh6bx1s3Fq74Cl5CCcLYAD9J8YytaqZ2EY2mewfMJYPm23+LgdGZHvol1EWXe8tIrZfKoU+wqUTxJForpOq3MW2W3Fu7BZmwFxwu4UhinqiGO6vF+UMKTax89mcQvmZh93naXug3TSLANvdEB1/CwoHtAyL5M+EyqG/k7HYRzg=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB4074.namprd15.prod.outlook.com (2603:10b6:303:48::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Fri, 8 May
 2020 07:19:34 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.034; Fri, 8 May 2020
 07:19:34 +0000
Date:   Fri, 8 May 2020 00:19:31 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [PATCH bpf-next v4 1/4] selftests/bpf: generalize helpers to
 control background listener
Message-ID: <20200508071931.hmj6c6ux3kixzug6@kafai-mbp.dhcp.thefacebook.com>
References: <20200507191215.248860-1-sdf@google.com>
 <20200507191215.248860-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507191215.248860-2-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:217::12) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2a2) by BY3PR04CA0007.namprd04.prod.outlook.com (2603:10b6:a03:217::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29 via Frontend Transport; Fri, 8 May 2020 07:19:33 +0000
X-Originating-IP: [2620:10d:c090:400::5:2a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c638830-961f-4a78-ea54-08d7f3202881
X-MS-TrafficTypeDiagnostic: MW3PR15MB4074:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB4074CDC000D6A1AFCBE30C0DD5A20@MW3PR15MB4074.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:13;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sF6NR2ElTOz3sfp//NBgfaeTjUeBS9Nt8goXmqa1zlM/dJ2bQrw75IjTvik4Fhp/e1lXR7On4v/bR5e8BGiKfxP24eTTCYy6/JdLlInQ+x8TWT9i3ikPD0IJq1cpz78rTFlAndLV9EPGyOv7ZzsEhgl0o4K9CiblGf6Io5/i2MnAF8IGtMimUgLKtaJx4tdr92m0Ze0lp4WhjJBTg8lnAwtcoTCN0nbJD0/biqiWYm9FOCvag5unGq3/1cPwyllTAw0Y00ORQhxOblpF4/7u26k56UOlPN11e2TQstd9gDVR880QkcMqFoum750Xjf+wEzdcxcv44aLS5qMMYQ6VHmRj9SU2a7fk1eNlmKdg52myIKOOJrGeoV/eLluvuV2O+xKJ/AlPkfIynx4JiqtS+Uke0W+COakcpjr8Eib1NGsaX9j2qjUNaoGFej7reVrcQuJR3HnOzeWl5DzqK2I4eR7xPns1kz2sxIDUCjzmYzzEroKZ8HP88TNoKbEp3JQah5nqQTBrzh5+radxsQ3sKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(136003)(366004)(39860400002)(33430700001)(52116002)(66946007)(186003)(7696005)(16526019)(2906002)(8936002)(83300400001)(1076003)(8676002)(86362001)(66476007)(54906003)(9686003)(66556008)(83320400001)(83290400001)(83280400001)(83310400001)(478600001)(4326008)(55016002)(316002)(5660300002)(6506007)(6916009)(33440700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mlXZGNHzuzsEAAwb5fAIjrL3JFOBKBF7zoEMdw8eN38OrYxck1f63nxTN55Fs4j3eNxxCU5+hbXsjAFtlxtcOeC534k1ETedcVedjsaAYBdNmggYhPyZnjkpbnkNqIA/JgG6/xrjYmYW0eCat1jMHO/p48HjszH9maBdjmf7NoLrS/RfLihJdcgHi+kKBfdvmXv9CrM2yw+SYVA8BhMjkx3gPzaPmPI5bvnfI2E0NcGhT51rVuSt4QtTH/v0opVgaUKUKpSCs6d5OjffvGup4Sgc/SlqnhGhiiU1u8HIubbCLsHAV1D8n9p67Q62PQ6RCTIqLqZ5TSoKBsgNYAwJyQkHeczw8LRVwSl8tsmwnYNMRmd8EgiY7E1qeDLkSmWW+QF5F7eM1/m71yDfAAGfHC+W7X3kdJkzP8UIs/G1OrpawhOK24i/oNg6ntSUtA1x9KvEw5rgRVyT4uauCLtJcnsD00fcrgWjlsY06NyRQFleElmk6l97rMy9xUjNnONHKCoBBYJvk1L7RFdXCPV83A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c638830-961f-4a78-ea54-08d7f3202881
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 07:19:34.2998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nvenTh9pMPCv9k1UUGQhdPsTMKwPF/DbdrUYB4kFdEj5yy4u2KFBfzKAIFJ6RAz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4074
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_08:2020-05-07,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 12:12:12PM -0700, Stanislav Fomichev wrote:
> Move the following routines that let us start a background listener
> thread and connect to a server by fd to the test_prog:
> * start_server - socket+bind+listen
> * connect_to_fd - connect to the server identified by fd
> 
> These will be used in the next commit.
> 
> Also, extend these helpers to support AF_INET6 and accept the family
> as an argument.
> 
> v4:
> * export extra helper to start server without a thread (Martin KaFai Lau)
> * tcp_rtt is no longer starting background thread (Martin KaFai Lau)
> 
> v2:
> * put helpers into network_helpers.c (Andrii Nakryiko)
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |   2 +-
>  tools/testing/selftests/bpf/network_helpers.c |  86 +++++++++++++
>  tools/testing/selftests/bpf/network_helpers.h |  10 ++
>  .../selftests/bpf/prog_tests/tcp_rtt.c        | 116 +-----------------
>  4 files changed, 101 insertions(+), 113 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/network_helpers.c
>  create mode 100644 tools/testing/selftests/bpf/network_helpers.h
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 3d942be23d09..8f25966b500b 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -354,7 +354,7 @@ endef
>  TRUNNER_TESTS_DIR := prog_tests
>  TRUNNER_BPF_PROGS_DIR := progs
>  TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
> -			 flow_dissector_load.h
> +			 network_helpers.c flow_dissector_load.h
>  TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read				\
>  		       $(wildcard progs/btf_dump_test_case_*.c)
>  TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
> diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
> new file mode 100644
> index 000000000000..8ea2b045452e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/network_helpers.c
> @@ -0,0 +1,86 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <errno.h>
> +#include <pthread.h>
No longer needed.

> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <linux/err.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +
> +#include "network_helpers.h"
> +
> +#define clean_errno() (errno == 0 ? "None" : strerror(errno))
> +#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
> +	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)
> +
> +int start_server(int family, int type)
> +{
> +	struct sockaddr_storage addr = {};
> +	socklen_t len;
> +	int fd;
> +
> +	if (family == AF_INET) {
> +		struct sockaddr_in *sin = (void *)&addr;
> +
> +		sin->sin_family = AF_INET;
> +		len = sizeof(*sin);
> +	} else {
> +		struct sockaddr_in6 *sin6 = (void *)&addr;
> +
> +		sin6->sin6_family = AF_INET6;
> +		len = sizeof(*sin6);
> +	}
> +
> +	fd = socket(family, type | SOCK_NONBLOCK, 0);
> +	if (fd < 0) {
> +		log_err("Failed to create server socket");
> +		return -1;
> +	}
> +
> +	if (bind(fd, (const struct sockaddr *)&addr, len) < 0) {
> +		log_err("Failed to bind socket");
> +		close(fd);
> +		return -1;
> +	}
> +
> +	if (type == SOCK_STREAM) {
> +		if (listen(fd, 1) < 0) {
> +			log_err("Failed to listed on socket");
> +			close(fd);
> +			return -1;
> +		}
> +	}
> +
> +	return fd;
> +}
> +
> +int connect_to_fd(int family, int type, int server_fd)
> +{
> +	struct sockaddr_storage addr;
> +	socklen_t len = sizeof(addr);
> +	int fd;
> +
> +	fd = socket(family, type, 0);
> +	if (fd < 0) {
> +		log_err("Failed to create client socket");
> +		return -1;
> +	}
> +
Please also set a connect timeout.  Snippet from sk_assign.c:

const struct timeval timeo_sec = { .tv_sec = 3 };
const size_t timeo_optlen = sizeof(timeo_sec);

setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo_sec, timeo_optlen);

Other than that,

Acked-by: Martin KaFai Lau <kafai@fb.com>

> +	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
> +		log_err("Failed to get server addr");
> +		goto out;
> +	}
> +
> +	if (connect(fd, (const struct sockaddr *)&addr, len) < 0) {
> +		log_err("Fail to connect to server with family %d", family);
> +		goto out;
> +	}
> +
> +	return fd;
> +
> +out:
> +	close(fd);
> +	return -1;
> +}
