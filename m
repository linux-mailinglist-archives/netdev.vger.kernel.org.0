Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDE019388B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgCZGXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:23:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45324 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgCZGXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:23:36 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q65xFK022206;
        Wed, 25 Mar 2020 23:23:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=7mQYwZ6PWXAe1Qan0CHarK0mKUoFJcTJ/dgzgNadago=;
 b=m3qrfQDoJJH+sXbRqa2SDLRSGbA1EhGmapI+DM27Db+cw7m14fjGPXvFhhGgI2OK7SHO
 u9iMwXU+RbJ8RrazS1PBJqrx98yNalk9mhG/Wqb0a/e3m0eB64/RKs+Si8lKw0XD9KiT
 mX/abNJQeVtKyFbRFM42gkByAdT25Z4e5Os= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yy3gxevwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Mar 2020 23:23:22 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 25 Mar 2020 23:23:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKc2ZWAgu2/URwKCZEmaCNpEr50Lmcr2AKDKDZ83IM8+5ibd9t6hMUHLj+xBmklinhnoMon7DVDkbPL+VN4+67m2tq/vgMLN8Y72fcq0/qzbyNVP57gSt8vDfBMpFN0Z7Px3d3cCSLMkMG3pkVoiOWMeFviyw0o6sRDsE4cC06/kUT8pSivvl/5Q0zYcnMvG4Ow4hmDwnZPWu/KYinhzf7B+qUY45vGGb4ltwVzAJtuT46XtVX0/5uA/JctFGxAoS3yf0lGWhXYmxORZ/Z1TpJtMytv1bA/kDQHHwfFd0jhi3oz4c/KcoU2sm3kg/L2GbKl9jHKRFQpnbDJQJCbH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mQYwZ6PWXAe1Qan0CHarK0mKUoFJcTJ/dgzgNadago=;
 b=kLkDqO4tecdzV/WhMGVEO7yMwzNzFX/3q3nej/4o9aqacQ3f8gNgJTIt/oO214aSkSC38lRL9Rj3sa4OhAU1N820E0PIK0RwCpYB/GcD68/n2EeTzFjmYc69ov/fHlPZs6EAg9M9SRdBJpl80EkKQm+lujb0m66EIOqQ59S0i2S7D1lkkpOM9jCHossDHC1KPZ/S4yIkmN2txUqUNi/IWnaKq69cyPNoGC0YXUgXMhCLh+wjCH8xqkrrOK1Oh/MV4y7+QK4EaiS3nFRrizIcUw3QxB4iwVDpbHUzSr+REZWH1kMmnmY1mFlDh4ilmMN8LIcn5+pCezvCvC0RnzNGTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mQYwZ6PWXAe1Qan0CHarK0mKUoFJcTJ/dgzgNadago=;
 b=jJ77qVDkwgTYJ6qhTkLNcvUF9ESEvD3B9G9hPANwq52i7y/Sck5fJk403yoxKviEhBgj++KOnUoYcrADdEaCRdOsJZKMqKKjyDxFRYPAml5hNZ8yGQwXbwIbMWNPaCriaaKl83hwW6ubSiH26VJyVTIKZ6IpfoVV0koYctggu0E=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27) by MW2PR1501MB2185.namprd15.prod.outlook.com
 (2603:10b6:302:12::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Thu, 26 Mar
 2020 06:23:20 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9%7]) with mapi id 15.20.2835.025; Thu, 26 Mar 2020
 06:23:20 +0000
Date:   Wed, 25 Mar 2020 23:23:17 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <eric.dumazet@gmail.com>,
        <lmb@cloudflare.com>
Subject: Re: [PATCHv2 bpf-next 1/5] bpf: Add socket assign support
Message-ID: <20200326062317.ofhr2o7azamwhaxf@kafai-mbp>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-2-joe@wand.net.nz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325055745.10710-2-joe@wand.net.nz>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:102:1::15) To MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:cd36) by CO2PR04CA0005.namprd04.prod.outlook.com (2603:10b6:102:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Thu, 26 Mar 2020 06:23:19 +0000
X-Originating-IP: [2620:10d:c090:400::5:cd36]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9973402-6130-4fa8-c33d-08d7d14e2d58
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2185:
X-Microsoft-Antispam-PRVS: <MW2PR1501MB2185BBB6A26081804562B860D5CF0@MW2PR1501MB2185.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(366004)(396003)(39860400002)(55016002)(1076003)(66556008)(86362001)(6916009)(66946007)(316002)(66476007)(9686003)(8676002)(6496006)(478600001)(81166006)(8936002)(33716001)(52116002)(5660300002)(16526019)(81156014)(2906002)(4326008)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2185;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ry0EqtaYD7wgVz98Tura3K7DAPeu9zmQIDMyLv9BpIhLKB3gzy1xT1J657AK1QtENSd1eqKkT4VOIT1naLVyDY2mxRdHHo+HzehKPbn66IEuQnON7w+pOIEwvY9ppEKe7KMpyeKtF+jUXpFcN/Ub2GoZm9g+KbDXQX1Ep+lE8nVYmQzUqCjZm5OrKqFyqnmeyfwdQEsBRHhSYRPzLyWWR+7Mpb/eZFSQMXwNqxXGr76HZG8F4phAqp2bDYem5hyBev+uh36XVatDiTc4oSyi6UKP0HMb2iiBO72rIvuLOB66IRZSaXontRFOxZtG8pU6pTKubG2sYgDzo3AFW4rSwGx49/G9D9/Jfe8w0NyEy1hVn4sL/OuPnod6SZdBrx6mvvajiSHWkaB32zTDoYtjPrMkt7eJXliRaOZtoT8ql/c5sUEO8l0Rx9NaVg7AhMy
X-MS-Exchange-AntiSpam-MessageData: BpgN8ImcIMi4LEoDtrLgvVxmwxJtexrdM+jI0VGlHefVLDFXfn32ZPU4Lx3OxMTgcohooJoLr/bwrrFc3lBVCRi6dSsk8F9f+2H6lFGky0N2uCcCCOE0+66ExyQTlWcNQzeqpmgIHHhoYSIZjob1pgnGlGAVav0hxHVeBLkB60p1R+tBBhpkRpAfb7UjNsM2
X-MS-Exchange-CrossTenant-Network-Message-Id: d9973402-6130-4fa8-c33d-08d7d14e2d58
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:23:19.9487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1BRbZPfCetcljMBZYLG4lVMpGyLIRUMCtn4PWsg0QFs1f412vBgP0/XvRw0eLEC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2185
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_15:2020-03-24,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 10:57:41PM -0700, Joe Stringer wrote:
> Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> 
> This helper requires the BPF program to discover the socket via a call
> to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> helper takes its own reference to the socket in addition to any existing
> reference that may or may not currently be obtained for the duration of
> BPF processing. For the destination socket to receive the traffic, the
> traffic must be routed towards that socket via local route. The
> simplest example route is below, but in practice you may want to route
> traffic more narrowly (eg by CIDR):
> 
>   $ ip route add local default dev lo
> 
> This patch avoids trying to introduce an extra bit into the skb->sk, as
> that would require more invasive changes to all code interacting with
> the socket to ensure that the bit is handled correctly, such as all
> error-handling cases along the path from the helper in BPF through to
> the orphan path in the input. Instead, we opt to use the destructor
> variable to switch on the prefetch of the socket.
> 
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> ---
> v2: Use skb->destructor to determine socket prefetch usage instead of
>       introducing a new metadata_dst
>     Restrict socket assign to same netns as TC device
>     Restrict assigning reuseport sockets
>     Adjust commit wording
> v1: Initial version
> ---
>  include/net/sock.h             |  7 +++++++
>  include/uapi/linux/bpf.h       | 25 ++++++++++++++++++++++++-
>  net/core/filter.c              | 31 +++++++++++++++++++++++++++++++
>  net/core/sock.c                |  9 +++++++++
>  net/ipv4/ip_input.c            |  3 ++-
>  net/ipv6/ip6_input.c           |  3 ++-
>  net/sched/act_bpf.c            |  2 ++
>  tools/include/uapi/linux/bpf.h | 25 ++++++++++++++++++++++++-
>  8 files changed, 101 insertions(+), 4 deletions(-)
> 

[ ... ]

> diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
> index 46f47e58b3be..6c7ed8fcc909 100644
> --- a/net/sched/act_bpf.c
> +++ b/net/sched/act_bpf.c
> @@ -53,6 +53,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
>  		bpf_compute_data_pointers(skb);
>  		filter_res = BPF_PROG_RUN(filter, skb);
>  	}
> +	if (filter_res != TC_ACT_OK)
Should skb_sk_is_prefetched() be checked also?

> +		skb_orphan(skb);
>  	rcu_read_unlock();
>  
>  	/* A BPF program may overwrite the default action opcode.
