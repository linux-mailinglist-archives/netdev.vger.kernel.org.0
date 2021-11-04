Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2585444CDE
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 02:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhKDBJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 21:09:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8952 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232747AbhKDBJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 21:09:33 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A3KAd3s008188;
        Wed, 3 Nov 2021 18:06:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZTfHHrnkxLNWbN/Sn37ZqvNc0lyGpaMr4mtZVkIn4mI=;
 b=A+hA/5DFSM+T72BcQO4Ueo3LIvXbKqdbGtvGfEFXA1RwnRQerMfHKnq+cZO5HggUWxIR
 6oB8p/49IIhf92CQIIiDumtNZSTu5yhlmKgRCgYBXYTHjfly5nDvO7V90235dwQErCps
 a4MoE306acU/SJxk4CExE64ULhaShdr7GYo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c3veb44np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Nov 2021 18:06:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 3 Nov 2021 18:06:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4GQCqBvdkL7q8IGZ20Y3bI7M2CugbafmCoMf1KhqRz7Ggj8apSfQGIrQPRsieF6YHwfpLf5QfI4hehNfjsyxbhZQqIEjKvUrmy6nI1m3CmHuk/GcAZRDx+RjEzTBEk2lWPSfkzXlBh9aifSGFNp12atrXwVKXGV9PaVF34LtvTOL7IKKvGqB8tlaN4GnCRKL5i3i4A5lyWoU7N0oVNqnOPdoB0DCXf+5ZSPoG7QozyqTnKMIfWEPCVKm+PV3EJRR59ukG48QnWV1YfJX4a//cEIEHWF0SKs2uCZ0OJlehzAgNvWlb5AE4t/+uEBu43q/9z6uqG3iIUtj33888xZfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZTfHHrnkxLNWbN/Sn37ZqvNc0lyGpaMr4mtZVkIn4mI=;
 b=WmLF3Bi27xZjCThLeLcYFp5zYnakmzlcTqg44JYiLcObXTSn80uR2JRNPDmaiPFb1wviOhqSmS4seqzYRKkx5TG/IsQ4fYLKpQflBi3pH1uSuoTCatb+Y+pQWyBBlGys7WBSXevXt4BsBNaI51PO/jcisnOdVjKmB8298Zpo7ocjFGr77PIDSFWiyTL/mP1pgSYVIpJ10JqhR0XKjSgJeXfpQON0eQNljPgpT6Ak97gRcr39IcPEoo/S3MjfpqW+tsbiZx3odUPHUUcSVZlR6ZhUWUSX5qPTSnLQbhCN+BENxLG22ENPo4gY3Kt1194kzUOQk2shBGt7FDa1q89d7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: yandex-team.ru; dkim=none (message not signed)
 header.d=none;yandex-team.ru; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR1501MB2015.namprd15.prod.outlook.com (2603:10b6:805:7::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 4 Nov
 2021 01:06:53 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4669.010; Thu, 4 Nov 2021
 01:06:52 +0000
Date:   Wed, 3 Nov 2021 18:06:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
CC:     <brakmo@fb.com>, <eric.dumazet@gmail.com>,
        <mitradir@yandex-team.ru>, <ncardwell@google.com>,
        <netdev@vger.kernel.org>, <ycheng@google.com>,
        <zeil@yandex-team.ru>
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
Message-ID: <20211104010648.h3bhz6cugnhcyfg6@kafai-mbp>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <20211103204607.21491-1-hmukos@yandex-team.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211103204607.21491-1-hmukos@yandex-team.ru>
X-ClientProxiedBy: MW4PR04CA0247.namprd04.prod.outlook.com
 (2603:10b6:303:88::12) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp (2620:10d:c090:400::5:b511) by MW4PR04CA0247.namprd04.prod.outlook.com (2603:10b6:303:88::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 01:06:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 886ddf71-64c9-44b4-66fc-08d99f2f62f4
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2015:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2015D84282EE5CC3A7A88846D58D9@SN6PR1501MB2015.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJND+Hfw4vfN4cEQvZWAI8VFZSWUsSxdM+G4xRgfXT0b+twu5frDhlx6048HP88ffrdsIMi3NFqsZF4gSyNQVFnnnq98060RBXHWocff8z5mNG/BZ4OpyjD44o/wEu5VC5e3FG02uJ7cri0b8eDJWl4TQ/G6XVV8GD0h183s2XQxG1Ew7Uacgzbfd++k3wTYWDEzpt4SHsw54FcPo2g/TLzmk/QTrPjL1p2EFxFrotfxo1evwoUpgJtkshKI12fStShnnTcvuY62XBczi3S8T6adl/JRsEDvRiQO/y5ZpR2sJVBMZQ3YTEb0m7yCTx3KfhitjSkPQIuuNtUEfq/xCDx6F7nHD2nJNG9R/EYGy8H2XtvltcOLyMRgw7BgrWz4rIp/bWOURN7++4JMD6Hjdi6pgkT/x0vT/5Z2t51EA5VpoMvgeJwfVdDKQI0h+LjyeAFsPo239RUjdyB7ZZdCjSZb2n/kpx2hJugLh6/xfQnI2drZosFGNpDS1Bf80zC+q0JscM+IVBQvg7qqMuY2JkQeyPl/e2XQNINowvBjE0ChU5YccQo3xmtinHJj+2EAYsp7PlozuY4/Oh4DTvbjF42n3AHb+hBtf+Jsdk8VuSZKLddp/80Y8X+YJs/4s9Swi7uqSt5GOTCWmdHaBkj4kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6496006)(38100700002)(8676002)(6666004)(83380400001)(8936002)(66476007)(5660300002)(66556008)(2906002)(66946007)(508600001)(4326008)(186003)(33716001)(6916009)(55016002)(316002)(9686003)(86362001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S/C3xXA92EWxmu6d66qajA+TkRgvenGeUF5j0Z/0DZSgkBBcrhYFMi8Fj2X7?=
 =?us-ascii?Q?iLUQh4MoIkpY9uwuGG9HHc/6T8dQ30Cva+QrDOIhFatKCBfOBUn2WkEcLfNx?=
 =?us-ascii?Q?gEvKDCnL5sWub9jPeLrvlvlvshHoZECZBqtaLB2M+yUgqRqZavpiCTXg3EPd?=
 =?us-ascii?Q?ghRjAUwcO1O+wSo5DeA+Zoa8iI2uWCodiEt4PQAOAzjm/hLcBZ5MudpEJ9Ag?=
 =?us-ascii?Q?Nz/Y5XFuxbO8Nt+INyq5ZGPJLkgJSaIj37bzlyG/AO5RsLbZdeYlhthd090F?=
 =?us-ascii?Q?ibfVRr/e/hTu97LpVGMw6fXNFptXmZUj9gTK6wC88+cmo8L9C7eB5JXzVR5S?=
 =?us-ascii?Q?Vwo6yrccg0DDBihIdEHXAEKO30DLH5SLruk9bQJzTYXUGjjlcGyhbYSSFfqS?=
 =?us-ascii?Q?NBUAoZEmeYYZhH+ZDqfn4BQZuHJAtMRFhRNffC0UlOlqzE+BeHeYgxONULwD?=
 =?us-ascii?Q?/5HfPOX+gNmxk1JHurDMnKMD7Ku7kDEkHDOjjkwPhyFfK7GoRdiHa6TvRorZ?=
 =?us-ascii?Q?N2aSQ9iBmJmuAbal4YnbrRrR64vHt4xPZOxpeZDRws+w+59utX91K3ZGmT7d?=
 =?us-ascii?Q?E9pcPVt+070/63hn2RW48I5RY4MlDts3aTxhQEUBz9PALhHjiXFVLSqB795d?=
 =?us-ascii?Q?lTWpBxKXoUnJclWz5+Li71szxowknVDBQYzabKM0uK/i3MZFU3iR4Zu/JE00?=
 =?us-ascii?Q?3OTTSlaUVQrfbiTgV0L3A4UaBYgetMXdZ4RAb1zq768pFRTHvP8YBv3HWZuq?=
 =?us-ascii?Q?OPla+4cWv50lOFEa2lF5DwWV1SO+bxxbTOTJSGXKye+QBE9/h0uxpNiFGv92?=
 =?us-ascii?Q?vN2jQGk4wJPtViOLo0haZuFuOepzVywLl6h/jFn948ixisLDdobTtUP3ZCWH?=
 =?us-ascii?Q?v3hHoFEedH8qYb5iobNwrD4Nh4c/qo+M02sI8uhPy9biYC1NIYhvMF0hhnln?=
 =?us-ascii?Q?uVB2gxm6RsaagcB8ZLzVhz2GLmN4S/58/Q67ZbWK96MY9hrcsy2+BrKr0Y0w?=
 =?us-ascii?Q?rUdrNvA+IKXtxQCru16GdERo2LhRdO34lek60O+SKYkbIPG7jLQvI2vRaSjW?=
 =?us-ascii?Q?NiTT4Ey2wNQPsc15bj98trT2HJUMEiFQdmk7mNopZ2FnPVu6fAki+Rl2+IWO?=
 =?us-ascii?Q?LeZdCvRWPqJKBgIYoMx9JiXMrOaoahYo03D7uueGNX3nZgfvF55grSQVdWqa?=
 =?us-ascii?Q?IEnWLYa9pDgc05kVvErrGJ2KVeY/6rJFJD4MOp0OHar+eTcWanKk7a1vOieO?=
 =?us-ascii?Q?tRztqflKDKo4lq9y00yB/JJZbj8zpRT+eXbV7K+QVsC6xicyank/pb52R199?=
 =?us-ascii?Q?U5T4M160dBEEX3Lcu6vWRy0cRz9EbdFZ30E4sYPpwz3wCW2mF718EB7cpmxD?=
 =?us-ascii?Q?Hzm66UqB/fr10yDmyd6uSQdJZUMVLDXPl0EVly9g73NwRnkQfgh94NBZUoET?=
 =?us-ascii?Q?fAOltedejh5zk8UYQk7t1UfQOjINhV4/rQo3Ca/k9SGYRPhWLOcMHS3Ig+jO?=
 =?us-ascii?Q?kFctQ2zRQ8rKyxrOfF5IqkyWEuYvXPixUlq175faHYcIOtXNThmJMirNQUMd?=
 =?us-ascii?Q?YviPAHJpi86XhWgp5g6nStcXZ7m/Ae6j/O63RxJZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 886ddf71-64c9-44b4-66fc-08d99f2f62f4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 01:06:52.6060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fda0fAKi/eEB/8mHrW7E+9NnHGB/i9uyFa6svlxha/LMdIENxuFGfcTtvYN3Z4kA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2015
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: zO-B8udu9qXm8riS7wh4yODJBGwoub-M
X-Proofpoint-GUID: zO-B8udu9qXm8riS7wh4yODJBGwoub-M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-03_06,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 11:46:07PM +0300, Akhmat Karakotov wrote:
> When setting RTO through BPF program, some SYN ACK packets were unaffected
> and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
> option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
> and is reassigned through BPF using tcp_timeout_init call. SYN ACK
> retransmits now use newly added timeout option.
> 
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  include/net/request_sock.h      |  2 ++
>  include/net/tcp.h               |  2 +-
>  net/ipv4/inet_connection_sock.c |  4 +++-
>  net/ipv4/tcp_input.c            |  8 +++++---
>  net/ipv4/tcp_minisocks.c        | 12 +++++++++---
>  5 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> index 29e41ff3ec93..144c39db9898 100644
> --- a/include/net/request_sock.h
> +++ b/include/net/request_sock.h
> @@ -70,6 +70,7 @@ struct request_sock {
>  	struct saved_syn		*saved_syn;
>  	u32				secid;
>  	u32				peer_secid;
> +	u32				timeout;
>  };
>  
>  static inline struct request_sock *inet_reqsk(const struct sock *sk)
> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
>  	sk_node_init(&req_to_sk(req)->sk_node);
>  	sk_tx_queue_clear(req_to_sk(req));
>  	req->saved_syn = NULL;
> +	req->timeout = 0;
>  	req->num_timeout = 0;
>  	req->num_retrans = 0;
>  	req->sk = NULL;
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 3166dc15d7d6..e328d6735e38 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2323,7 +2323,7 @@ static inline u32 tcp_timeout_init(struct sock *sk)
>  
>  	if (timeout <= 0)
>  		timeout = TCP_TIMEOUT_INIT;
> -	return timeout;
> +	return min_t(int, timeout, TCP_RTO_MAX);
Acked-by: Martin KaFai Lau <kafai@fb.com>
