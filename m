Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0117195DD9
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgC0SpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:45:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13050 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgC0SpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:45:14 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RIhID3020077;
        Fri, 27 Mar 2020 11:44:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=HkyQ4JMQAlMcA2bJdHV6I37DEBn96e1DQtVptSV5CKA=;
 b=Tln7AVAjF+jyzjaNNEVZIMcJHonRTa/hUA5FODqvRKnnNYaUGCGflC+xbdlIvw32biT0
 x8pTTrPDn4JkfwYSwAsL94UyaFE7gQsdKZPrLrNpJvKvHaLZdPNdBRqU7xRY6Y5I21l/
 OEUkEQLordQZOBHS3U6xW1kIIdaMoY0S+rA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 301e5k2pv0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Mar 2020 11:44:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 27 Mar 2020 11:44:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzEMTG86eXkD3CzGAIjhzJrpm+gRv1+dujeBVBkazsPW9VfJlk27nGXzINiFIFyP3UCfDKQoWHm2932SfELHe8Icd31v1rmO5kUlnlMHdGqqij2jPK6M3maS0zKfopaPGKqPeI+UNB4YyrynxI6U9dsuM/FUe/Bypgmvkw5LBXfvoR5j4s95iR+2ZXxK8H+I7Ie5j79jp5QyX+gGMSnAQKFwMJxsFBSgpgriBKx8iGp+MQYmoZXnM79gBrW7yNXsv4i8oKQ6CUWHjP2gHWKHH61U53Rj+W+czRwyNic5OukOgfH8k0iGRDfsxLY67DXabcvqTsDpsUnA5+caNtU2TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkyQ4JMQAlMcA2bJdHV6I37DEBn96e1DQtVptSV5CKA=;
 b=APOgMa7stgmDIEZ3mquItSBlTLk6qtwPNXEVV57pUxoFeuP2inkXSvh+VgsETDxwirnvJoemxpcPfewFThV8OqEnjNAeuTzY9AGv11vIrvFWAWxTmxm1eqx9hwVIPReoV5jZJYepFD5iZpkhNjH+Y6hfSGSVrl2pTPjpJNNPUYcBc/QPHQW0MekT6huw31ddeZVgGmv3y/7KpVORaiqto6x19qeiGTdasJeeBnajYZ6aLaDcazzcEhqPiGVmi6Ul1CSlqrbHOb7ZP8DpJy9Q+0vseMGe+QtG/KTRmgt8JNhS4q1yxEQV3qmvqq7rk4KKmG+O+KSYlzaZTNuUra+jQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkyQ4JMQAlMcA2bJdHV6I37DEBn96e1DQtVptSV5CKA=;
 b=ezX5tFhoeXioObIGIpJPIuwdWIA8CRUJOK/f+nt5CfCvNoucwM7PCwtKPJ4c0Cz2DKQ62zeByfodjNRfkaS+TQS0egqSDgYrMpHUJFeINVXbtYrnsBBJtxv5yqrAYFJxBGjUXbOrynK+MXex1bJhSGopHxBd4LA1E1+4fDpDs7Y=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27) by MW2PR1501MB2042.namprd15.prod.outlook.com
 (2603:10b6:302:13::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Fri, 27 Mar
 2020 18:44:51 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9%7]) with mapi id 15.20.2835.025; Fri, 27 Mar 2020
 18:44:51 +0000
Date:   Fri, 27 Mar 2020 11:44:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <eric.dumazet@gmail.com>,
        <lmb@cloudflare.com>
Subject: Re: [PATCHv3 bpf-next 1/5] bpf: Add socket assign support
Message-ID: <20200327184443.msxv27ft5vbqmyze@kafai-mbp>
References: <20200327042556.11560-1-joe@wand.net.nz>
 <20200327042556.11560-2-joe@wand.net.nz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327042556.11560-2-joe@wand.net.nz>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:300:ae::25) To MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:1c15) by MWHPR14CA0015.namprd14.prod.outlook.com (2603:10b6:300:ae::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Fri, 27 Mar 2020 18:44:50 +0000
X-Originating-IP: [2620:10d:c090:400::5:1c15]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fac5a03b-dc66-4450-40a3-08d7d27eee82
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2042:
X-Microsoft-Antispam-PRVS: <MW2PR1501MB20424EC49298B35647F8B73BD5CC0@MW2PR1501MB2042.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(39860400002)(136003)(346002)(86362001)(186003)(6496006)(16526019)(478600001)(66946007)(6916009)(4326008)(33716001)(66476007)(66556008)(9686003)(8676002)(8936002)(52116002)(55016002)(2906002)(81166006)(5660300002)(6666004)(81156014)(1076003)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2042;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8j59fkN1WyMOK54gOzJIchjJ8pU+TvXbAFfmTuw4IMNS5vj8tRH7qxtWqVfi5Oz5Wt0Ij84UwTTzt2OA6DaEnow+ze2Bxq1Ge9hiQVsLxLB9V/nWjwlCKAQAoSgoYHPvMaRPJlhtzpB/54ZW4g0cKPf7zkDYVizPIUUHFvW62MI0cphsUZhigryoeJL5f+hzL/GoXq1HWUjVs1RxkjIOQfIcRqiB4anpzddqM+c6YoTFqXkaYisbUwM5l7QZ7c5ZteFLND3jvEzqimT2abtllxi3IOjtlVL0YnM6qzB0WfkkORA3FB2ved4ogRlmiVq61Sze2Bo4gk2aZA46+rPc+iOCPfwyQkNeo3IgBF+gj+mIwBGD/rmzEWIsaV9Tw3KeUZX0WiZ1+ezTbpl4lsF/cLY30cZv24iHry4AqklWLmQRIi8BFiEtmh0KZD3Bzjup
X-MS-Exchange-AntiSpam-MessageData: 94EJv4vF+wL9/o36/sW1T9F6gAMlEr5j8xkHs0Yu49K7J9gE9IIw3/ffm0mknMi2lge47ucaZmIEZIrAUTFCj9MNXekBO7x9m6CAtFTvyyCo2sUsd2D1ECq4Z0kG1uxE3mYEvUQ6iT+MWaalD+rhmfLocYpY1JEL9IrWgpfOU/o3lc/APQZbWry18g+cyEh1
X-MS-Exchange-CrossTenant-Network-Message-Id: fac5a03b-dc66-4450-40a3-08d7d27eee82
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 18:44:50.9318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bxNqflBiLPdt3KDWeoWLs1O+c2rsR3MJ1PgjWd3ZGSqyQn2hoxQrm+27H+zmDzRB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2042
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_07:2020-03-27,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 spamscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 09:25:52PM -0700, Joe Stringer wrote:
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
> v3: Check skb_sk_is_prefetched() in TC level redirect check
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
>  net/sched/act_bpf.c            |  3 +++
>  tools/include/uapi/linux/bpf.h | 25 ++++++++++++++++++++++++-
>  8 files changed, 102 insertions(+), 4 deletions(-)
> 

[ ... ]

> diff --git a/net/core/sock.c b/net/core/sock.c
> index 0fc8937a7ff4..cfaf60267360 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2071,6 +2071,15 @@ void sock_efree(struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(sock_efree);
>  
> +/* Buffer destructor for prefetch/receive path where reference count may
> + * not be held, e.g. for listen sockets.
> + */
> +void sock_pfree(struct sk_buff *skb)
> +{
> +	sock_edemux(skb);
Nit. may be directly call sock_gen_put().

> +}
> +EXPORT_SYMBOL(sock_pfree);
> +
