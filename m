Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466BA496996
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 04:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiAVD3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 22:29:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16988 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231519AbiAVD3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 22:29:09 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20LG2MIH003118;
        Fri, 21 Jan 2022 19:28:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=iZ66reAc/z1wOxR6elWxQDLurl4FWT9t6Z2pZimnQ2s=;
 b=QmwPjbiY3nZxN3F+xK6dHhGV0sN1khEvOa3eOlJ2fDz/VANlALCneUAIFIn1SuxjNnJb
 aajx7nA4bXrWJcrHe0rLr1WfMo64a9Vf+jkmkQlsFm3211Q0Jj6Z1de+xjZgNkZBzRtP
 1dsyKB78V+izRur1CYLaG+UtBMwioiHCY1w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqhycykn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Jan 2022 19:28:43 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 19:28:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsAQPnuXX3ekaLdrRCiJyIXu3PTZ5xQE1hMEpd0YVcBlay2DW2k5Vmm5JU2vubJT+oxtmlcsHTMYp3de8IxgLWdms+xa+dA6e8VPokaQ+ZTELJBCdIQvKNqeDZAWNnqbOrGiDLQ7Qs8JFSHMFbUGd0XwhYWzQcd/qihdpeZ0nsdHt9uZYcISG7IvHCbRV58Wy0IrbWaXGAP04hArgKzOB380I8C+JbK8mhZoaUcqlV11YpzTqCOt7dXo37hKZkfcHEud7kO9HAk+YvTwf5BEGWiyvWr3/DYS3Wym8zf824MLC43qA5mKWgYjf6ol2HAdMjAwIHojmjwYxvkxGY+4nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZ66reAc/z1wOxR6elWxQDLurl4FWT9t6Z2pZimnQ2s=;
 b=oEU7VnYzIh2sfWPVyYkd5nEiMtiuQUtSLaG2fJ7RVojhVKp4wz/IakTqWBkSJqGoeSJjhmJGZlPlS5LsPuh9N1nOPtUBlYPVg438jET1AWl/DXR6Jigw3MytNSxWy/RYW7QpHg3F9ptEk+6VLgOG074OkJrvy3MP+mcU/QpV6KhskM5g94SF9wVr4aGZ/nitxrHqlgkooH6kEedH6zP/57vKyVoRCShTJNcXW9vlXRMydi4NRYHlYq3vYsiwGPWdpf9W6fhY8wpTu26OQ494aEpFPaAcZOUX2z5gnuO51FvOJvBP18BFcq77AamBFKpuJ93iODp+cZkaBocK6H1Png==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CY4PR15MB1541.namprd15.prod.outlook.com (2603:10b6:903:ff::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.13; Sat, 22 Jan
 2022 03:28:40 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4909.012; Sat, 22 Jan 2022
 03:28:40 +0000
Date:   Fri, 21 Jan 2022 19:28:37 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Julian Anastasov <ja@ssi.bg>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [RFC PATCH v3 net-next 3/4] net: Set skb->mono_delivery_time and
 clear it when delivering locally
Message-ID: <20220122032837.lng6uwg5ugomplpx@kafai-mbp.dhcp.thefacebook.com>
References: <20220121073026.4173996-1-kafai@fb.com>
 <20220121073045.4179438-1-kafai@fb.com>
 <ca728d81-80e8-3767-d5e-d44f6ad96e43@ssi.bg>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ca728d81-80e8-3767-d5e-d44f6ad96e43@ssi.bg>
X-ClientProxiedBy: MW4P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::20) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6d135a0-0ddb-4c02-1b4f-08d9dd5748d5
X-MS-TrafficTypeDiagnostic: CY4PR15MB1541:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB15414C647DAA410DF660C72CD55C9@CY4PR15MB1541.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ecL7neHi4QnLNeZHDM/i7J22sZ5EbchaXeVrz7hzwXFXuW+k0fFTeX4J6K3iyWUTrF0koXFn5CIf4Nj9YLV+buMCSkTUvq77sXrEkeESd1beSWQ+8nWBlwPdv+iWOGnMzP1Str/acy7DqnYD8cHP+srpz7x7vg1NrSSWay3Z4D2PayRJsj3ZNl8aIwnxq4kM8BhInvgh7qmuOv5wtUSoOY8fFzITKUX2gVCxa+fITi6CVjbdpDz1wmdmjrLuHHBa+CbQw+s9vcD1rlTfBuxEWGkhoPJxTuVxavoCw+Y5Z3f8xjqXP7NPXeWjYE+AxgyNqC5MB1/jZI+l6xi1SaeRZgDJEcww5Vtcbc20N1DGjvV1WL9rIje+PhoAEuLNXkB53/rOQuruSKXjCLVkUA5Q7t2tgv2QOYLNMNMzhzC6QvLI+HJCcyVR/50xo4vbROM8Bce6Fmm8bfOxuYcvFdbdREUIgxB0nh+ZmgO1bp2WUDdnZ1SRX0XjbMMdNXc/Gzw+5nT2uVmU69Ryxk8D9tcmLdvY+dnGh5d0vTfkmP9OsSBIDzYj+tC0dZYIubdGvBCFAQkSh69YHd5DMIVEBUAm+mibZArWuXSIeVqkcl6OOKzxZ3GRiqZCp/rDsihxskYKX9BZDTNx+OVqqEde/2noJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(4326008)(52116002)(6506007)(6916009)(54906003)(6666004)(7416002)(1076003)(316002)(8676002)(86362001)(186003)(66476007)(66946007)(66556008)(38100700002)(6486002)(83380400001)(2906002)(8936002)(508600001)(6512007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PqjRKE8CU/ZhDXtW+LhZuT7lEPphJVsWAlNvGN4FQJZAvNKifr17Y94im7oX?=
 =?us-ascii?Q?kFnDZ+RaN7r++4GwvR/WBXtYjngSgvBSZ9d9h9cq6uTYlWxlu4/cyyPmHSkk?=
 =?us-ascii?Q?kfpZYnIBphk7Qps/ghNoNQ5N36vCqT4aDbDylDGdjkJb80hSlAJhGDLrh6Hr?=
 =?us-ascii?Q?RlGWyMwo0IMMCWOAw/JrmtKaUJmdb7uMi+5Yrw4M7YQPue92xcfG+jVr3rhN?=
 =?us-ascii?Q?9DvdZckT+mzRO215nZzQvImoSR6becK56YAeVB1VeDr/PFDroWWh1EUDLhTM?=
 =?us-ascii?Q?/xIE+ZZep2BBhz/3E5medwW4R9t4TOnpbXcsVRegZUPaKd/hloQj9d7++w4C?=
 =?us-ascii?Q?cIRyEyjXiKcdYrGc9QKppgXe2J3y12ukAoJaL0J3YN7YkxA/3KbopU3FNb9x?=
 =?us-ascii?Q?ZqW3D72+0pEbx4LhgZqONr9U41jJ7z7w7dmmUUyYzFNDHFrIb1ZdL87GwOq8?=
 =?us-ascii?Q?gSKkQAVDVJOuBV1YvP1sdLVcqx5aMx1ODY0pBu1WCRPJM4o69XfDlyLGAOIO?=
 =?us-ascii?Q?E+VSU6IoiyN/GoIO7K21Mi6/WQmp0XQ5e6uOBHhRs/ItvIKwbk2D8t55RgtD?=
 =?us-ascii?Q?J/NCNTUTp8rvypSluTyCK5ETDxDkv4KCku1tm8M4i42M6orGRVz4jSvcBuoJ?=
 =?us-ascii?Q?XoHvYLt4fcSdKc3h9M9Uw7RoUUbt/5vS+0zVwRq0Mb/o/m4e79JC+4tg8rFM?=
 =?us-ascii?Q?+VJIE7KhnjEVkqkmo+nHq+Z5mTm6wuaRfdtbDFi885u6EPe8Y5cVM8+Rv28D?=
 =?us-ascii?Q?rbtAPeT0jOBpK9CpXDUCxbL+ikzUB2dDrhjp1firRbLR71phczfbK1yKQi/d?=
 =?us-ascii?Q?b75QNw3Pi8IQRZfVjgjlNxFMkgYUMv/o2xXjdj98PV8rUz8HNlPLq0DBh0AL?=
 =?us-ascii?Q?Zwt24Y51S6yBAUJDLc2rqSdLan72DrvhygLKASC73wFi6RhJHsXUORpQkXk3?=
 =?us-ascii?Q?HkHJic+gv079RE7fBsoG4XrjWjqaVmnSAnfRH8xlegvOK4Wza3JDWInOSgE8?=
 =?us-ascii?Q?xOn98Mxhl4Nb7c82leZjEzkkgvDQa6dwqbQjf6uMH1lWii6de6jTyQyV2V8c?=
 =?us-ascii?Q?2aqbnLU/vOJ4BoN0cyELY9s+ATBnJwn8ib6KzNg8Dtay3yR02gQJ5VOgGn2V?=
 =?us-ascii?Q?Y+7wu3fT8aQhTAZlTa4rTYZtzoKc2C92u7A7QyiCCvkTyFeHq9fVjbWgAB4n?=
 =?us-ascii?Q?awqjgaCwB47v6iVFYMVrSigJD8U8wXLN/DHr17YBlLUdQJNw9hzWZxRn4v63?=
 =?us-ascii?Q?z57eWPa1t3LJRlmI4jnBAb236DA+7ugsKyX4aoyCk60sJzNOjQUF9KshcXuf?=
 =?us-ascii?Q?3ekT6FKiQnS003gN2a4jWmn5UyNVmyhGVbUt/IYH83yzL+T3JmJiumQ4n7Dt?=
 =?us-ascii?Q?4/kitzbUW1/cfwlXKB5KkNkABoLiYtlwrl6WPSMUMC0yTbNY6lZZV5QFu+8J?=
 =?us-ascii?Q?CQiv4d7C7g5n9DoW9aDOCWUCHezx4DiucAg7rcLo0qg603LRPUFqJA3u+tJD?=
 =?us-ascii?Q?OfXzMQqFt6x6sR7twEkjDRaxxHF4nqxd5C/VtdH79oqHGELPQWz76nZOopb6?=
 =?us-ascii?Q?MrO7dowC3QjOwRncZQnYRgi6LRGv8uA/Ur4sLXCs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d135a0-0ddb-4c02-1b4f-08d9dd5748d5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2022 03:28:40.4860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U9uufwde3zOaHSa21qxn0AZYcGhVtrhEAsGKdiWifMrhDDSJrq0ZwvDqhLShDDYX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1541
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: XEadAiyDtPom-gxQGqjkdWwmvtVzUVPQ
X-Proofpoint-GUID: XEadAiyDtPom-gxQGqjkdWwmvtVzUVPQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-22_01,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=0
 mlxlogscore=879 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201220018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 02:02:23PM +0200, Julian Anastasov wrote:
> > diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> > index 3a025c011971..35311ca75496 100644
> > --- a/net/ipv4/ip_input.c
> > +++ b/net/ipv4/ip_input.c
> > @@ -244,6 +244,7 @@ int ip_local_deliver(struct sk_buff *skb)
> >  	 */
> >  	struct net *net = dev_net(skb->dev);
> >  
> > +	skb_clear_delivery_time(skb);
> 
> 	Is it safe to move this line into ip_local_deliver_finish ?
> 
> >  	if (ip_is_fragment(ip_hdr(skb))) {
> >  		if (ip_defrag(net, skb, IP_DEFRAG_LOCAL_DELIVER))
> >  			return 0;
> > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > index 80256717868e..84f93864b774 100644
> > --- a/net/ipv6/ip6_input.c
> > +++ b/net/ipv6/ip6_input.c
> > @@ -469,6 +469,7 @@ static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *sk
> >  
> >  int ip6_input(struct sk_buff *skb)
> >  {
> > +	skb_clear_delivery_time(skb);
> 
> 	Is it safe to move this line into ip6_input_finish?
> The problem for both cases is that IPVS hooks at LOCAL_IN and
> can decide to forward the packet by returning NF_STOLEN and
> avoiding the _finish code. In short, before reaching the
> _finish code it is still not decided that packet reaches the
> sockets.
hmm...

Theoretically, it should be doable to push it later because the
ingress path cannot assume the (rcv) timestamp is always available,
so it should be expecting to handle the 0 case and do ktime_get_real(),
e.g. the tapping case used by af_packet.  The tradeoff is just
a later (rcv) timestamp and also more code churns.  e.g.
Somewhere in ip_is_fragment() may need to change.

My initial attempt was to call skb_clear_delivery_time()
right after sch_handle_ingress() in dev.c.  However, it seems not taking
much to make ip[6]_forward work also, so I pushed it here.  However, it
seems that will make other kernel forward paths not consistent in terms of
the expectation in keeping the delivery_time.

I will give it a try in v4 but not very sure for now before looking
closer.  The worst is to move it back to just after sch_handle_ingress()
so that the kernel forward path will still behave consistently
but I will give it a try first.

Thanks for the review !
