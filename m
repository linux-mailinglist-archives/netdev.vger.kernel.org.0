Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DA5381514
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 04:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhEOCGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 22:06:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45914 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230146AbhEOCGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 22:06:49 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14F25KcP031004;
        Fri, 14 May 2021 19:05:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=g4NYz43vJD18sD9fhDsbs3x46O983MJLudBhX3gIpgs=;
 b=guGPnQqewBq2DozTPCTmu9lx+CEwVIMMsKX3ICNwiuUUgOYs7hD5//KdqQIa8+ddb2Y7
 RSAmsfiBca/f5ZHRdhxWWbhG1FjGqP7FinIJspHTCHwCHSotZdTxWOV7iZUQc7ROEYHW
 08/lvBLxW0jOJiv6zAwo6L427fkO/SMF3Q8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38j1gtgsyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 May 2021 19:05:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 19:05:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQ4Q3f0Oejxku1rINN8CMAoIXn8DK9rXMcQJ+k323boN+W5WfJ+Pw392wgc90EKSufR107QU0hZ06+x+CYkhZ0+QG4GC1oAEgCbSzpFpLTp08ShZEPLl8F13II58LSDPhgUxEXAMhxmCDahlwNxH2MHCBL2via+Jfq5BZVXk7CdQyI75bRtPDqdEj1EjpJD9LbU8Qjf1iPzwBF78WvlUjjEMYX0jiguW2BQYPjCZuA8BcfCkvcPvAV9vQzeA+xdrBH+HGVt3n0DURqKI9gKbZuUfe4jsdBqnef0xZ5pYbVxP/ZH0qTYNUVa12VUud+tvv9Oqdr+uGQlQX3/hPVKpwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4NYz43vJD18sD9fhDsbs3x46O983MJLudBhX3gIpgs=;
 b=UhegCnUm+CgfUwGXCALksU9htomfu/n5/xnsT3aGPlNF+tUkx+ahZGlUqt65xOo0zR79gEMniVoDY9f815UY/rwDiuAK7UlVlr4PRF1Z5FXfd+ZsoARBEk+Z+wryuxT+Jrx8vAo8Aj8kWs273aodSEX3klDcUC47P/mgpNDHedtXbkOCgWwkm1DHgvxVwsVUv7KtYCTBy7C8iS+a2328ZwV0+osx9538saBdlJVaFCRJvTQp1EfkIa3Am7LsNOTYnfXDAIGEtfjQ6t+2vgmC1x3l2s/SglYL1UKVjgYRk/vi9L3wVTfkrQRDKioGf2U6+xd4ZdiejuUsvgsouDHkMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2453.namprd15.prod.outlook.com (2603:10b6:a02:8d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 02:05:18 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 02:05:18 +0000
Date:   Fri, 14 May 2021 19:05:15 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 11/11] bpf: Test
 BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Message-ID: <20210515020515.mq2b3gqaq5edepk7@kafai-mbp>
References: <20210510034433.52818-1-kuniyu@amazon.co.jp>
 <20210510034433.52818-12-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210510034433.52818-12-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:717c]
X-ClientProxiedBy: MWHPR1201CA0007.namprd12.prod.outlook.com
 (2603:10b6:301:4a::17) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:717c) by MWHPR1201CA0007.namprd12.prod.outlook.com (2603:10b6:301:4a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 15 May 2021 02:05:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c59b00b-a8a8-4dc1-6ac6-08d91745e36d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2453:
X-Microsoft-Antispam-PRVS: <BYAPR15MB24530EBB0F3B38EC6DBCABF6D52F9@BYAPR15MB2453.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VbkNAvQiStJpBwNsprtKSHHdvg5GGciLrLL2mk+rSZAm4ZQAEwNgK0EWg6ZghTuXJ1O7tlVGuQgqIW/qmgt+yh/Fxt+cJSfdHkCTLbzWiaY/tHH5W6iNAXTGN2GzUzkFpC/njRPhrxzL/FdnPxTAj67SneImxp99Kv6vdBOve/iyVlGTF/SV1L5RhK7PFpLm5ApyFIuOg+q+yQfjjI3VLWVzrhr7/Jy3hqEIvjOVOGjLLTfGIxlAT/2ylq+JsGzZVoM1vE7Q/KxVr5PiLQhLeIKXDJgZe4oDv04K3KFfusVZHQGpS1nzNtCk5oORvzG2/IIQTzv50pmPpK+aA4X402OnpxkZpmsw2xYgxctxYGSOhC1gYLcO/eSbv+sjgmm5YBojH8NpAbTn07WmHqzgstntH3UaoZDumW8Ga++uNlPpyi5mAfAwbE5hLz4GOfJn+3Cz0pwj1KWhXYeiP1P5TE7y3yiKFlYc5SMdyCyDcDTyKX9q5dXpCd7HdAG/vn2HfWHbXzSvRf88po8Tx9OOMAwr5+2vQubfi2+qCCQTIms9i4fkjVRMph0wg+/tcAPetf7avCWV6rXdUEWGN40FeS1loOiYbOOkRS70KopfDBg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39850400004)(396003)(366004)(136003)(8676002)(5660300002)(16526019)(8936002)(9686003)(4326008)(83380400001)(2906002)(55016002)(33716001)(1076003)(86362001)(66946007)(478600001)(66556008)(6496006)(66476007)(316002)(54906003)(7416002)(6916009)(186003)(52116002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cv6IVSuE7zTMUbrzfbyhViw1UdOqZGJzWffCRzew39Gh018N0uSdnmKozHNd?=
 =?us-ascii?Q?mDQa/fHrlkkaT3uwR4soNb3Nl7UwSW3hgsm9a7RmuMR9jpZ4dbRWhUQiNvqY?=
 =?us-ascii?Q?7gYtze2e5GuUAs8LPgqq8lG1hW6YKDSag5SVMpF57uF5Ng5rjBJd5ZhusjnW?=
 =?us-ascii?Q?fuA321fZgX+7lbweJfhqo/tdAdT8oO9Fpk7x9A7aXL82ExltntLGw1X1O3LE?=
 =?us-ascii?Q?1xCjLAA7ayr4d3Vf6HUsW7i8ZQtZ1jFB1dlTs8GNbNslsfPOCc2Sc3Faq2ib?=
 =?us-ascii?Q?KmeIf0Kp32II3xIwW3zH2aS3jDxDPVbp22cLVPv0cxX7FfXmCKDEtZkjQqPy?=
 =?us-ascii?Q?DjM/N5pJA9Wq1oeSD3Ki1i+ChSx3m25xoY6IdMZtpY0AAqWpK7DyNq2daQPY?=
 =?us-ascii?Q?gGSC3Ijzn4VZFrpc2dQJZyNTEJFL3jFAPZCBsvnV5yn24YqgtZMiQUdcOfQ3?=
 =?us-ascii?Q?vyekSgLNYHP8BG2qcQwSenbU3lU33/SCCvSY7BQgGnTIWFAIvwwnm8o5UXFm?=
 =?us-ascii?Q?t1/jMXK1dvL5SOJonkB0KVzSa5fB+QXsCMrXivKsY1h/E7l6aUKlDdlEDl2i?=
 =?us-ascii?Q?L5b+K3jY7DK/ORTcTzAjQhZhG89xM04Xpm4CsyDwgzzrM2jtbE9ZPdoy0knQ?=
 =?us-ascii?Q?muHhsWxkURrarN6bUTPiUxjYihn0o4ol12jNmW62nXOKnvQmQCyC4qH6gZQ4?=
 =?us-ascii?Q?YYw2RkBPLniaK7QiT44/pCY85WXV0uNJ+0AI6syndIeRVfrRCSn5KctKx9lc?=
 =?us-ascii?Q?8l26+AGYq8e4AwHawQENw1CUKTPw5FGb3H88Zelb/lHuAlOnNyDGzAG2H8rh?=
 =?us-ascii?Q?qDqRLH/xJfMLhEL2bMzERj+no9dlF9AHgqAKYk6xhLzscqL+TO0HrNLS/hGz?=
 =?us-ascii?Q?kWA0c/gZCNUvNEAkdjHVwN67Kd+T8RiIRLdK14t9To7K8CzvstOBEBXDFvFy?=
 =?us-ascii?Q?RpZkfxEvf+zQIhR0xcb9s6fDRbZfoWMe5AD6u9Fiz/X3eXysGiW6vHVwztkf?=
 =?us-ascii?Q?QpIZDe0rFR0gkxaVOf1XMQG3E9bQIn2wEUNZag8ynMQ5R08sYm/jHZd1TNAa?=
 =?us-ascii?Q?rmqWLh2eBIAU9gcQc6Fwp5fgZdgaMRsO68lDZ/so8d3Dtc59flL/jf56VgMw?=
 =?us-ascii?Q?ucfuUznle30ij5iUNBVJI3372vYP9VAwsjbhdTyRRHjr2BAPnFUl/iW98mia?=
 =?us-ascii?Q?Ri0u1ZAkoXF+rpozhFN6ILzynxx0DrBSanNmlMqvCP6qc67w8painVOyzt95?=
 =?us-ascii?Q?/QtOQzETc+qp/fA5MiGzcG0H5uffNsLYgAwqj0yNzVgwke9LHPuErqeHF0Tb?=
 =?us-ascii?Q?cUlmVlYwa0vEN9VlBZyP7Z2+j3A9pnraUfELFryV2rgHGg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c59b00b-a8a8-4dc1-6ac6-08d91745e36d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 02:05:18.6356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9Tecj8C91Gl9Xguss28AnJrUZ/K2Yz60937mIHqOTXQyziQlLCrFmoyCD3bdVvf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4WWPB8bJJo0NLqHayYL3LlWJ-6NQLwl3
X-Proofpoint-ORIG-GUID: 4WWPB8bJJo0NLqHayYL3LlWJ-6NQLwl3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_11:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1015 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 12:44:33PM +0900, Kuniyuki Iwashima wrote:
> diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
> index 12ee40284da0..2060bc122c53 100644
[ ... ]

> +static int setup_fastopen(char *buf, int size, int *saved_len, bool restore)
> +{
> +	int err = 0, fd, len;
> +
> +	fd = open("/proc/sys/net/ipv4/tcp_fastopen", O_RDWR);
> +	if (!ASSERT_NEQ(fd, -1, "open"))
> +		return -1;
> +
> +	if (restore) {
> +		len = write(fd, buf, *saved_len);
> +		if (!ASSERT_EQ(len, *saved_len, "write - restore"))
> +			err = -1;
> +	} else {
> +		*saved_len = read(fd, buf, size);
> +		if (!ASSERT_GE(*saved_len, 1, "read")) {
> +			err = -1;
> +			goto close;
> +		}
> +
> +		err = lseek(fd, 0, SEEK_SET);
> +		if (!ASSERT_OK(err, "lseek"))
> +			goto close;
> +
> +		/* (TFO_CLIENT_ENABLE | TFO_SERVER_ENABLE) */
> +		len = write(fd, "3", 1);
> +		if (!ASSERT_EQ(len, 1, "write - setup"))
Is it to trigger the tcp_try_fastopen() case?
I am not sure it is enough.  At least, I think not for the
very first connection before the cookie is saved.
The second run of the test may be able to trigger it.

setsockopt(TCP_FASTOPEN_NO_COOKIE) or another value in the
"/proc/sys/net/ipv4/tcp_fastopen" (ip-sysctl.rst) may be
needed.

> +			err = -1;
> +	}
> +
> +close:
> +	close(fd);
> +
> +	return err;
> +}
> +
[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> new file mode 100644
> index 000000000000..72978b5d1fcb
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Check if we can migrate child sockets.
> + *
> + *   1. If reuse_md->migrating_sk is NULL (SYN packet),
> + *        return SK_PASS without selecting a listener.
> + *   2. If reuse_md->migrating_sk is not NULL (socket migration),
> + *        select a listener (reuseport_map[migrate_map[cookie]])
> + *
> + * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> + */
> +
> +#include <stddef.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_REUSEPORT_SOCKARRAY);
> +	__uint(max_entries, 256);
> +	__type(key, int);
> +	__type(value, __u64);
> +} reuseport_map SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_HASH);
> +	__uint(max_entries, 256);
> +	__type(key, __u64);
> +	__type(value, int);
> +} migrate_map SEC(".maps");
> +
> +int migrated_at_close SEC(".data");
> +int migrated_at_send_synack SEC(".data");
> +int migrated_at_recv_ack SEC(".data");
int migrated_at_close = 0;
int migrated_at_send_synack = 0;
int migrated_at_recv_ack = 0;

and then use skel->bss->migrated_at_* in migrate_reuseport.c.
