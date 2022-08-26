Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5095C5A2FE9
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240616AbiHZTZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 15:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiHZTZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:25:19 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92C65FF6D;
        Fri, 26 Aug 2022 12:25:18 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QIP6to017857;
        Fri, 26 Aug 2022 12:25:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jkxxH90Stt103NqCbPHCKyolbt05o+P+YTGn9/mslBk=;
 b=c3Z+LdtZarvjmaZQIzZTHgHJ/7sT3NcoS7/1NQ4+lqmC4/LeEMPYxwSq2BUY80mdlAfy
 RFrYEaDmomcvummKPmnpfhD4MJvhhv0LaTybhsXIOyRECn2Ze2sYiBSqZv7VFvxOWs5F
 KQySNuDFBHwdZIF6otReU3nOIhzEEJ444po= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j6g8dy1af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Aug 2022 12:25:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VyOBDMVRcyPmPlBp4cgg+JfkQeFDo+kCyasHVePJBoJkVz4m0fzHYHXbOAWirunOzxYsnmHwDe4FUcS/mFmpPI6GFRSuGht3iwM1V2U/cAniFodwBX1LWl7q8Eq+2H9O+Zp2n/t5U3roUp2glTjmoTOsPxAqMmepFIVksuW9McZ9bTg5dgAmqZl03828S5TijWdiTf5x0c6TmfHjVMbVsuMSv6j7FdDUDfvb5RJBQpBxPo2F+tDNorVPJCtG3O8ChgLThNd03ezcDjEplYRSJMNO/jyvXL64ljDqUo0rf+DhGeyVj8AtxGty/w5wLv6zC2PQ0rp4Zb0fbT9GBiIFVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkxxH90Stt103NqCbPHCKyolbt05o+P+YTGn9/mslBk=;
 b=Ilv6nWiQFAZfV6s3RZijv/2JDu6ccjgz9H8BYb5sw3IYfq0NAB/6KRxM52nlYdn6UVQeV6UdrHruNocnTmnHiH+0gX8olbit5sMnUxCCzPdtga+e1yxemRpUzTPF2RvRjSMDh5HqGpY2bwuwZCRTvKn/Mhr5yB2kFPZm26DCpj9ovOqGIrh1UdT8rl9nTTNydUexTiJE3zO3GLHTynogURgfIayaslDv8fJtOOb8k46GD1KA4nDYXc/yFGHLLJeANGlncE/v4gD/RxC3rY7YWK7j99HShdj+LETI0TY+N4QoZGqukxly7Fu114w15ox7onLa06OwI/FDnDYAoE5pYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by PH0PR15MB4213.namprd15.prod.outlook.com (2603:10b6:510:29::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Fri, 26 Aug
 2022 19:24:58 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e%3]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 19:24:58 +0000
Date:   Fri, 26 Aug 2022 12:24:56 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next 14/17] bpf: Change bpf_getsockopt(SOL_TCP) to
 reuse do_tcp_getsockopt()
Message-ID: <20220826192456.4z6khqm6g5sdg7vl@kafai-mbp.dhcp.thefacebook.com>
References: <20220824222601.1916776-1-kafai@fb.com>
 <20220824222730.1923992-1-kafai@fb.com>
 <YwfBNEVrxkafzpYE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwfBNEVrxkafzpYE@google.com>
X-ClientProxiedBy: SJ0PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:a03:331::17) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6269d0a-011a-40fb-c1c9-08da8798aa0e
X-MS-TrafficTypeDiagnostic: PH0PR15MB4213:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDgfFGV7Xhpz8+pxQfHBuGQ6wRFRTc4FpZWKE8LKLHg8dj3UULfLwH5aOVmEYmWQ/DAUyVdFYB4ouitOhuyI7axLbCAFR3Z2oXXFCHb2tLyHcAoymX9v/xMxcvUUm4Im3n0FY0/K1J9+P27RGLjMFpVxaUADUzbIsffquDy6d8yRKWajnj0K8v5cxdtjuNCyeiNvofheaUKQzrPtgO0qISCJZNkkN9SInFQm6RYNcC7GA7+z+UfErYkvQsN9CZyi/YNZtuevEMQKMOfiKjGempm7kY0Bjtsk6eBsbG6+SktnIBG0mCC6zHJAZgpIpLYCGtOaR8E2/B4EuJh0SnqKwMcCXhJpbiPDdhYpqiprFjcgmBp2UrvpOSAbpzZxs8vly7Pc35MiBVYVLB6Yt+YLTtS62bc1rOW7l/VTQmqNrWM6haqAAiTKmcj8qdo60OL5vS5DXpbAU5qklpS0Otb1iEYED0q02e6hjqd+RVkOpl2nv4SPnmNkOcB0R55iUyd7plvkQ9s9GcxHiuKWzQU1aUvVdqGkXMOk90/7QVWAw3WKpcHdQyUsTYR9MJydPFuD0fziakwfWRpXkXgnsToj91lo8uw4LIdtC4xr3VZcMIuOiOI7Tn2/E/ZAxib5rC7SXGkDWssQbh796fknbI9jfqP7oH+HFgLl3RI+DodF8kCEAZqY7B8MDkDurfIrsFzughh1Ai3fLmqx/sbS59WKeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(2906002)(6512007)(9686003)(83380400001)(1076003)(8936002)(186003)(66946007)(66556008)(66476007)(8676002)(4326008)(5660300002)(7416002)(54906003)(316002)(6486002)(478600001)(52116002)(41300700001)(6916009)(6506007)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TOFZ3Wf4XdLI1oFSleWNG1X3ao4MtMaWIQdBUOThzk6N/J7/XyaXY/7K6bJT?=
 =?us-ascii?Q?v9ppIHf/dkMmVpWae+ql+V+dl/E8ACIahrlIE9s9cphF8uhM2LFbCVzSjS1s?=
 =?us-ascii?Q?Pmmpl1P1AloGqXHC+vCnXx5eeoDgMEv1MYBHk05mwlkJSDWS/vCBej5P2QIS?=
 =?us-ascii?Q?twYsA6qE5/306ASzUgp7307XSEOvEPC9h337EhHkmo4pD21AwxcwzbfOZeJw?=
 =?us-ascii?Q?K4LPY2OPlK5nIeGLOT7f+8dfCMQy7QQMU1xQVrl/kz4fRQKqH9SMoyFwKEkc?=
 =?us-ascii?Q?quGClrYmhjXUzX/P0otFlWSTigvL+fjTuASPMc1x8iK1pR2RtoCNQDDSJ7n7?=
 =?us-ascii?Q?hVKrGiqUytI8iDXhVl+tHMZvTKgxSCFsgC3gPFB0zaUc2J2i7SU3gN88hFUL?=
 =?us-ascii?Q?Fx9prHJtyyJqE5zO/0u41a9OfFMifJhf26OrMYAlLrQW2fkKUOcWUoB/ldTq?=
 =?us-ascii?Q?GKXI/GO80iRFBRjwZn3IL+sjbBduVptxxrN08S/puBYmMcmFhGY0wW/C+rNV?=
 =?us-ascii?Q?/24lICWhvGZnty+pmQesbS7KCvf5I99biCHTW6w1gtp7S8dH6H7ugiWCpcFp?=
 =?us-ascii?Q?220a6rb8e4jKSDSDQTyDqL92hSZ0gZjTD7h0RnmU+4UpnSNG51C8GtZiof6u?=
 =?us-ascii?Q?eRqjR5wjzhq41AzvGUdq+Gi4OrN5EHHFJCHwr2ZnYbAdACXlFx0y0durjfCk?=
 =?us-ascii?Q?vilj8FSYR4ZG8mNIBYMU3m5aM8yWUavnTHJ58UdX5HycRUqTEpq1MRE/Qdx5?=
 =?us-ascii?Q?cstuangrHlqgyw3O1uIPHlOj/ukdrxhrQJnwwmIQSQ2//R3RUMNgfLTSDbok?=
 =?us-ascii?Q?SJfTAEnZXXWI9Z0aN09HpahNS/1Grgqux0tHOlyj9YLd+GU4JTTtfoGvk4Ik?=
 =?us-ascii?Q?8Y5kO6CQPvzSBWcZ1qwBglIHN7OC9i3sqbC3pxraXoqrtvuMq8IdJH20fr90?=
 =?us-ascii?Q?PunQvuf1I+MB5hnqBQUvEOYVNMWuWaz+B+iU+8Mc10syu9fyl/I3d7JPGX2X?=
 =?us-ascii?Q?MRyshzpWiouzXbpyobJNJvKWDnBAM94Ju35ChAPlFiCkdPm05ZaxI0Cut07Q?=
 =?us-ascii?Q?GrccCoIPuuwjrjml5dI7CgsY3T5Erx2H32XSWxBC/Ri8LdyuMyPJx13GPi+K?=
 =?us-ascii?Q?fndW+dK7+2Es9loRkS1Egk7fIA+QZKI95s17lSFamTE55ZS4J837XwQGNonC?=
 =?us-ascii?Q?3IeS0+8/bv1W/RnMogyXdid6kPcLovYn442FLTtvC99qhBEkknw99QX6JJ2J?=
 =?us-ascii?Q?STahnFr+0H6vxsFvKdMMg9nO5B1zVxA+ItD2Y5XGlRFUv0R0QmTpqwc457eT?=
 =?us-ascii?Q?hqHU4PQd20VPFgfQRlrTsbsF2z+VKMy31+7XeZxw7OajTaBxpScspLOblj3w?=
 =?us-ascii?Q?LXtLn5CV6BiVnQFFb9+1whhiJ39MfiS5JDMhuZXJL2ecD0lndJOtnHV93zye?=
 =?us-ascii?Q?2UXaImrQtbMqzOsGx+BmtB0rJqSgl/9qK9xmKvrokVZSU5jAjhpsriRIIQAa?=
 =?us-ascii?Q?srBWTmNhhwarLuWpFStCdBSGWHtLwEY7gYsTQay14ZmPsKTTfBrRlKhz4Ua9?=
 =?us-ascii?Q?EdBXkn33rLiBamQWpQHCQ9xX15Ip2N3QzeI8xQCa6geNeA6U4fMStxl2w7k2?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6269d0a-011a-40fb-c1c9-08da8798aa0e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 19:24:58.6562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CV5vtJlsPdMbkwXxdUFk4vZUgWgpQL4FwGNbNV9g9YNqGK30UO+HWj4rHU61uZGW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4213
X-Proofpoint-GUID: XxSK1qMPOg_wN_xidUuSjFeIJ-buyM6r
X-Proofpoint-ORIG-GUID: XxSK1qMPOg_wN_xidUuSjFeIJ-buyM6r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_10,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 11:36:36AM -0700, sdf@google.com wrote:
> On 08/24, Martin KaFai Lau wrote:
> > This patch changes bpf_getsockopt(SOL_TCP) to reuse
> > do_tcp_getsockopt().  It removes the duplicated code from
> > bpf_getsockopt(SOL_TCP).
> 
> > Before this patch, there were some optnames available to
> > bpf_setsockopt(SOL_TCP) but missing in bpf_getsockopt(SOL_TCP).
> > For example, TCP_NODELAY, TCP_MAXSEG, TCP_KEEPIDLE, TCP_KEEPINTVL,
> > and a few more.  It surprises users from time to time.  This patch
> > automatically closes this gap without duplicating more code.
> 
> > bpf_getsockopt(TCP_SAVED_SYN) does not free the saved_syn,
> > so it stays in sol_tcp_sockopt().
> 
> > For string name value like TCP_CONGESTION, bpf expects it
> > is always null terminated, so sol_tcp_sockopt() decrements
> > optlen by one before calling do_tcp_getsockopt() and
> > the 'if (optlen < saved_optlen) memset(..,0,..);'
> > in __bpf_getsockopt() will always do a null termination.
> 
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >   include/net/tcp.h |  2 ++
> >   net/core/filter.c | 70 ++++++++++++++++++++++++++---------------------
> >   net/ipv4/tcp.c    |  4 +--
> >   3 files changed, 43 insertions(+), 33 deletions(-)
> 
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index c03a50c72f40..735e957f7f4b 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -402,6 +402,8 @@ void tcp_init_sock(struct sock *sk);
> >   void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb);
> >   __poll_t tcp_poll(struct file *file, struct socket *sock,
> >   		      struct poll_table_struct *wait);
> > +int do_tcp_getsockopt(struct sock *sk, int level,
> > +		      int optname, sockptr_t optval, sockptr_t optlen);
> >   int tcp_getsockopt(struct sock *sk, int level, int optname,
> >   		   char __user *optval, int __user *optlen);
> >   bool tcp_bpf_bypass_getsockopt(int level, int optname);
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 68b52243b306..cdbbcec46e8b 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5096,8 +5096,9 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk,
> > int optname,
> >   	return 0;
> >   }
> 
> > -static int sol_tcp_setsockopt(struct sock *sk, int optname,
> > -			      char *optval, int optlen)
> > +static int sol_tcp_sockopt(struct sock *sk, int optname,
> > +			   char *optval, int *optlen,
> > +			   bool getopt)
> >   {
> >   	if (sk->sk_prot->setsockopt != tcp_setsockopt)
> >   		return -EINVAL;
> > @@ -5114,17 +5115,47 @@ static int sol_tcp_setsockopt(struct sock *sk,
> > int optname,
> >   	case TCP_USER_TIMEOUT:
> >   	case TCP_NOTSENT_LOWAT:
> >   	case TCP_SAVE_SYN:
> > -		if (optlen != sizeof(int))
> > +		if (*optlen != sizeof(int))
> >   			return -EINVAL;
> >   		break;
> 
> [..]
> 
> >   	case TCP_CONGESTION:
> > +		if (*optlen < 2)
> > +			return -EINVAL;
> > +		break;
> > +	case TCP_SAVED_SYN:
> > +		if (*optlen < 1)
> > +			return -EINVAL;
> >   		break;
> 
> This looks a bit inconsistent vs '*optlen != sizeof(int)' above. Maybe
> 
> if (*optlen < sizeof(u16))
> if (*optlen < sizeof(u8))
TCP_CONGESTION (name string) and TCP_SAVED_SYN (raw binary)
are not expecting integer optval, so I think it is
better to stay away from using integer u16 or u8.

> 
> ?
> 
> >   	default:
> > -		return bpf_sol_tcp_setsockopt(sk, optname, optval, optlen);
> > +		if (getopt)
> > +			return -EINVAL;
> > +		return bpf_sol_tcp_setsockopt(sk, optname, optval, *optlen);
> > +	}
> > +
> > +	if (getopt) {
> > +		if (optname == TCP_SAVED_SYN) {
> > +			struct tcp_sock *tp = tcp_sk(sk);
> > +
> > +			if (!tp->saved_syn ||
> > +			    *optlen > tcp_saved_syn_len(tp->saved_syn))
> > +				return -EINVAL;
> 
> You mention in the description that bpf doesn't doesn't free saved_syn,
> maybe worth putting a comment with the rationale here as well?
> I'm assuming we don't free from bpf because we want userspace to
> have an opportunity to read it as well?
Yes, it is the reason.  I will add a comment.

> 
> > +			memcpy(optval, tp->saved_syn->data, *optlen);
> > +			return 0;
> > +		}
> > +
> > +		if (optname == TCP_CONGESTION) {
> > +			if (!inet_csk(sk)->icsk_ca_ops)
> > +				return -EINVAL;
> 
> Is it worth it doing null termination more explicitly here?
> For readability sake:
> 			/* BPF always expects NULL-terminated strings. */
> 			optval[*optlen-1] = '\0';
Yep.  will do in v2.

> > +			(*optlen)--;
> > +		}
> > +
> > +		return do_tcp_getsockopt(sk, SOL_TCP, optname,
> > +					 KERNEL_SOCKPTR(optval),
> > +					 KERNEL_SOCKPTR(optlen));
> >   	}
> 
> >   	return do_tcp_setsockopt(sk, SOL_TCP, optname,
> > -				 KERNEL_SOCKPTR(optval), optlen);
> > +				 KERNEL_SOCKPTR(optval), *optlen);
> >   }
