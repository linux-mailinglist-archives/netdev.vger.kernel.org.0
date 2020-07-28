Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6616922FED4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 03:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgG1BVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 21:21:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726139AbgG1BVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 21:21:16 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S1Fiaw010327;
        Mon, 27 Jul 2020 18:21:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZqpBbPbDUdN7yV1JRrLWblu9oSa79zwX6RGhzut9M18=;
 b=riaWiyUJn0IeXuZhPL2zNdP4fQ0c2vEd+5hY8ggMb0oCe6ynTm+iWh6EyI02Q74ttW5P
 Du33sEF66azK/5cGiX59Z//qF4aZSLvhICUXn6NxML5+pM11WSXVx4bvQ145pgzTVCY3
 5gsVwr0ANKcthzf6Xzd2RAaxnIh437LhBXE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32h50vq7g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 18:21:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 18:20:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjckqBXdsPn6fS/8vKJwUyGXnIllRp0F+Za9fuMTctaJ8TLxYrGtpJJry3vipvsgntBpmm9oMIIXl+RBYQ5PnBMxwOU6DLjlS9mcpRhXgMnlg5Cy8BcuoEjKVKQXjy8Im/DHaDTH9GeMZks/ABKZvCTAarFEAXseFF3ReJi4Fmr6948YBN3RV/ZOlMlviRH0D5JGghIQ3cMqPIDWmPzGpFqd86Fm7ZqCqYRed/89Xk/lTxOmXUIaH2BQ+wYuKcBrOaWigzqMEiWpFM0fO3W4qWYiBcNWrLkZV66F/YKIHlEUE+GfTzmcqjAkuYEYRMkIcUY4rNgYWFBPC9PJ3WPGSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqpBbPbDUdN7yV1JRrLWblu9oSa79zwX6RGhzut9M18=;
 b=TI8YKnTr0Oe71Qo1GeliPfRY52tQ3O3aPmlHkk96xwJy1uimZvy7bqkbHGNdZpOFg7wzms1uCJrvIROJO2+8iCqXRdPZ4ei2n/2+u6wkWrz3whbl9ctEdnPcTsdTabXOmfJCbT1BQok8vM8VD95s8FzZOYKHjjPlUy75wgvcn/ZKbbv4rlQh97fv3T2+zsPJfrfbv5xVkeQLo4Plmvc9gfoqKwwZpXrvm19wUT+C4+7n5u4qTFng6ZQBgGw4A0agMzleA2aQylnDDfluPqVBZHVKPak6RD/m8TTxdS5Ml6NRRneLrjCF31d/jBasQIpSl51wgrQeqDR3iZZIgtITqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqpBbPbDUdN7yV1JRrLWblu9oSa79zwX6RGhzut9M18=;
 b=J6HhQb9lc/ZEtwTDFZOWWPj/Ij+8iuXwsKPu3Jyfw+FTL1NfH+ZutTykEshIYJcnfzBxU2EW3l6oWlPpyKaqH6e246UIi1XTd3NHBRUxxqM8YbKO6fGcoXqPME43mp/N6uHhGuCSzb1Klr9xDSs1C8/OTVo08FD1EM4e83P1kY0=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2885.namprd15.prod.outlook.com (2603:10b6:a03:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 01:20:44 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 01:20:44 +0000
Date:   Mon, 27 Jul 2020 18:20:42 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next] udp, bpf: Ignore connections in reuseport group
 after BPF sk lookup
Message-ID: <20200728012042.r3gkkeg6ib3r2diy@kafai-mbp>
References: <20200726120228.1414348-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726120228.1414348-1-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:217::29) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:f626) by BY3PR04CA0024.namprd04.prod.outlook.com (2603:10b6:a03:217::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Tue, 28 Jul 2020 01:20:43 +0000
X-Originating-IP: [2620:10d:c090:400::5:f626]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40437e22-9be3-47a8-344b-08d832947314
X-MS-TrafficTypeDiagnostic: BYAPR15MB2885:
X-Microsoft-Antispam-PRVS: <BYAPR15MB28856E288EFBE9A52244E5BAD5730@BYAPR15MB2885.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39KwEv08EmqMI1O0/M9N7W36AC0wCnFZmG7c9i0iVQH/iv7LPTe9SsJxr3MctGMgB/1gpGprA/Gasfzr0BBdNDe4+74HD9h7dflYPHQrvWByS8DtgMfty2mEsZhT7OGNp8/Ong7G6Dc2lG9jAW+AhwN3McInE260Mz2l2KdZLWzEXqb/XinqTCco3WK7gbR1bqvyPQERHJTnvJKMLNrUkeDJTrBdPaJcbf1+7bxHrRH5vWlMcjipMwEIH1xbsUbHrdUOXymt09RAEJccsRktQuOzA1XnKimTuRxQPUm2vR+g4UD24B08jmQQjaMwSVjc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(346002)(376002)(39860400002)(366004)(316002)(6916009)(52116002)(4326008)(1076003)(55016002)(8676002)(83380400001)(16526019)(186003)(2906002)(6496006)(9686003)(5660300002)(33716001)(8936002)(66556008)(66946007)(66476007)(478600001)(86362001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: hz1ENFkwdLxNsf2npegRUqFXNN4QsEJ4337CqpbKdCSBjQGPfpOqXmXiVxwRLpgMTQmObEq8wro0IHKB+g+p2NO55LE4D4jVuJcLo3cqXODGZS4I09SID0x2kygiSP6vXSaVOvcf1vCfDrWL1QYUSeA8/DL3wbMpy3yxw7CbA36r/9BpKxL3sxfHBbtOsVfc2A8NstWvrxD7yj0Yug1ZhYyAPmLeSZvMoxwOC8hrm495oyBBcp8OdK0qAcxKAMTVReyTz0YpjKtCDO0EjbKwomVTPb00IaWL812otabI8e5s29UNbxI7nw5KKdfnX6WZEk415JAyyvwDOEJJQ7hNlN3zU8XKIbN2kh1fmT/oRo+K75Sj8EFOUpcQ44OZjj0KUALoc3OM5geZoJlI3i6xmm9m5eNBSZZgEPR4C59gHTiUgWckWLlIMe6Nu+wpJdgDkjtSwvrnwxRsGT1IF/h42S70FRIPeR9t1hh2PGmTB+erJltGxz7k9mKBAq/MX9pRoEmfVq/mQlGHfbJzVtG8Bg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 40437e22-9be3-47a8-344b-08d832947314
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 01:20:44.2606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxZyPc3gse2GaCtWOa/FL6sNxX6PruhNza0z5AQRQCJBAPbNCJLTqeinT679XmOc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2885
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_16:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=911 priorityscore=1501 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007280007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 02:02:28PM +0200, Jakub Sitnicki wrote:
> When BPF sk lookup invokes reuseport handling for the selected socket, it
> should ignore the fact that reuseport group can contain connected UDP
> sockets. With BPF sk lookup this is not relevant as we are not scoring
> sockets to find the best match, which might be a connected UDP socket.
> 
> Fix it by unconditionally accepting the socket selected by reuseport.
> 
> This fixes the following two failures reported by test_progs.
> 
>   # ./test_progs -t sk_lookup
>   ...
>   #73/14 UDP IPv4 redir and reuseport with conns:FAIL
>   ...
>   #73/20 UDP IPv6 redir and reuseport with conns:FAIL
>   ...
> 
> Fixes: a57066b1a019 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> Cc: David S. Miller <davem@davemloft.net>
> Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/ipv4/udp.c | 2 +-
>  net/ipv6/udp.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 7ce31beccfc2..e88efba07551 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -473,7 +473,7 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
>  		return sk;
>  
>  	reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
> -	if (reuse_sk && !reuseport_has_conns(sk, false))
> +	if (reuse_sk)
>  		sk = reuse_sk;
>  	return sk;
>  }
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index c394e674f486..29d9691359b9 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -208,7 +208,7 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
>  		return sk;
>  
>  	reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
> -	if (reuse_sk && !reuseport_has_conns(sk, false))
> +	if (reuse_sk)
From __udp[46]_lib_lookup, 
1. The connected udp is picked by the kernel first.
   If a 4-tuple-matched connected udp is found.  It should have already
   been returned there.

2. If kernel cannot find a connected udp, the sk-lookup bpf prog can
   get a chance to pick another socket (likely bound to a different
   IP/PORT that the packet is destinated to) by bpf_sk_lookup_assign().
   However, bpf_sk_lookup_assign() does not allow TCP_ESTABLISHED.

   With the change in this patch, it then allows the reuseport-bpf-prog
   to pick a connected udp which cannot be found in step (1).  Can you
   explain a use case for this?
