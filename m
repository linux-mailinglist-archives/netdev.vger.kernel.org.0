Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4706920CB1F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 01:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgF1Xom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 19:44:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23218 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgF1Xol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 19:44:41 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05SNfCSd021305;
        Sun, 28 Jun 2020 16:44:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YpeGwvaSdcKI0mCTOBVTq+S1pfVRvWiWrULfkOpw//A=;
 b=qitBD1SxbSw8Okx4fIW9Wtg94VQfNF/nA1YTPJcWldLSurFy8yFGym5eY0IsUhj1l2Wf
 h9lQYC0SCT29GKNUgVme3HN/QM0SjBdXgvC9B6m6QimoFSyMbUw5HpAo2iNjihaJXFIR
 /aI4VkdXJltcmE6cVhEkQrnlouVFHB4g9jQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 31x1kymuwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 28 Jun 2020 16:44:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 28 Jun 2020 16:44:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8HhhQxXhdN4pAQm2p+F3O9FqrWgyK1SIYLTJukYnNB3lx4eRN3suKEfXv8ZKKDn/JnPvxV8XyJh2wfuRlYMA9Bk6BTJB5qIiycuCyC+5QbkUWK5OlBEWmseCzTenMdFT/NgAXvfNmRJY6obGQmyQrQ60h20NipZlPh/fney80kznoUvob1u32MrhA0dV9cW/CI6G22hwmytumymo+CqM//j184pLWAiyiqyA/sZyUPbtqHSL3lDZiNr7turh5N2kkTDrsg0BO+JdT3X4gl1uCxGq0ojSe9jWcerkn7+w/1rQlJGZUYjMkRei2T0EmpUxnKW0K2Sgx4lRiKQCoG6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpeGwvaSdcKI0mCTOBVTq+S1pfVRvWiWrULfkOpw//A=;
 b=mvGNGrwKXAjDg94RrDfModt1QGjaZIMzGZWi8jZsM+Bwm4Is9qFJ2jZGPEZajM1l/8Zm1TS1SGAdI8EFcnIzKf+2AR9hB9ck02X/lyluRZRJ09MLOTBwhlgdtG/QHrNtfJrAHbwFOr+HpUj9fwkZMlK/jE7NniiSiwXQVjCDMIfIsZSPkltb2FgriP5svyDATxd726jdrEoumV9SAAS1ZER6X65Qe5RGr40bAQcnAHrsDnW9gnTK0jqphFHH/+L2lWhsvLEP94ov5hykx+rKqxq5/GA/zp/0tpDyyMi/TRw4sjWVNEQL3KYvr1U+3fpTTCzwGXh3PLovMDS+DLxcWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpeGwvaSdcKI0mCTOBVTq+S1pfVRvWiWrULfkOpw//A=;
 b=OIlIeyvTjuvFLOe4z1furf4mmDKtgwh2epC+8kIA0ZCdGhbLKCrFwBpDb6TlxTD4RcUDw988vDvyW0VERXDcK3x15zAN8If2PUzctUQdoQw0zunaPjru5coSZrybw0qu2e8BsOXZf/6zP6/Vkm1XH1iWG6NRS7hwEZDsQHUI8Gs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3720.namprd15.prod.outlook.com (2603:10b6:610:d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Sun, 28 Jun
 2020 23:44:22 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 23:44:22 +0000
Date:   Sun, 28 Jun 2020 16:44:19 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH bpf-next 02/10] tcp: bpf: Parse BPF experimental header
 option
Message-ID: <20200628234419.en2loln6wlyy4r3w@kafai-mbp.dhcp.thefacebook.com>
References: <20200626175501.1459961-1-kafai@fb.com>
 <20200626175514.1460570-1-kafai@fb.com>
 <CANn89iK50rqOVy=PmKO-Fe1D-HsHjp4zj-feevouQ2hc1GAQ9Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iK50rqOVy=PmKO-Fe1D-HsHjp4zj-feevouQ2hc1GAQ9Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR17CA0062.namprd17.prod.outlook.com
 (2603:10b6:a03:167::39) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:807c) by BY5PR17CA0062.namprd17.prod.outlook.com (2603:10b6:a03:167::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sun, 28 Jun 2020 23:44:20 +0000
X-Originating-IP: [2620:10d:c090:400::5:807c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 446396bd-1ad9-49c3-3ebd-08d81bbd2e77
X-MS-TrafficTypeDiagnostic: CH2PR15MB3720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB3720F5E42B034B6E910B5DA0D5910@CH2PR15MB3720.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0448A97BF2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TrwZarwKSM9dbLVeBbmH7CpTU/p8c6i3Kbhe1X+zlub0OwciBO5+df6YfYzgfDnSSffr/oeZ1Ze/s+QKBXDGKvOX7p7Knonq2y8g1SFbJo4SsnDdAxpG9OyYY8dIn2SeTHzEZlAce57BKVtTKls0B+Zybkw1eoT8hCQ2f3bu/cR6W+soKgeth2XN3KBw2v+VCuK2GTLk2XiXrbwcWktmNqf3Z5/0kLHvZXYhviX/bbAWIWfw64qgFIC7YWWB9R+EUrCkiANRalGGDZpg16bo3eGCYVq2E/b5Zj+u51Ky4Brfa89pY1pTwI9wCkwSY5u3zvXgia/HDQjfjAElUluCEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(376002)(39860400002)(396003)(366004)(6506007)(6916009)(1076003)(16526019)(186003)(86362001)(55016002)(52116002)(7696005)(53546011)(9686003)(66946007)(83380400001)(5660300002)(66556008)(66476007)(4326008)(54906003)(478600001)(8676002)(2906002)(8936002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nWDNDTRf+iZpTsmcZntCNi5TQQHN/ygEnsT97Z3nVD7rOlhE4mx31tmYssmIino73OkfFOZCk5Ijqmv4U0XNeYfMl0tbvCUqiPR87D5Kbw/FTcqQm4iuBmHC5olS8WbT3TStgk4AtLEOWM2XPFQhfKLdaod7dst+QKY/yWcu0+IltACuuLp8EcZ0s9saodFnc5ZCUwymAzDbeBEgIG2lMMLnfJyiazQPEjZ7GbnM0X2rZTON9PJRykAQxKzz44bOaiqp3PzgF+Jy3eMfFUzHkNayjE4+2oEp8k7h1bcSvtYXR2PC00YI81xULgE0YOy8zZyz/Mm5MT6r9opUj/LhHq9pVsmNn3k5iU0j3+zZMTANQz1x7BHJ0XU7SEGuEyKSa4XF9uNgeq1CWASBmx1xH4N23n2QVJZDimEs9+8KtUZ2LckHxQ1zDebrO/xJqvglGwdxLB/wugAKbs8HcX6I+861bmCLtCplP4sJjPwBDXeoBd/pLMKlyp3H62Tui7HFSkeZt05cIcIIqc7YzCooqw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 446396bd-1ad9-49c3-3ebd-08d81bbd2e77
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2020 23:44:22.0547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qbt3rmKzWJA/KXQa6/yT89dZxyvDTtGpJXzgj8nLp1hHagnwy1lIvbpKn3d0W7dX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3720
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-28_11:2020-06-26,2020-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 cotscore=-2147483648 spamscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 10:17:26AM -0700, Eric Dumazet wrote:
> On Fri, Jun 26, 2020 at 10:55 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch adds logic to parse experimental kind 254 with 16 bit magic
> > 0xeB9F.  The latter patch will allow bpf prog to write and parse data
> > under this experimental kind and magic.
> >
> > A one byte bpf_hdr_opt_off is added to tcp_skb_cb by using an existing
> > 4 byte hole.  It is only used in rx.  It stores the offset to the
> > bpf experimental option and will be made available to BPF prog
> > in a latter patch.  This offset is also stored in the saved_syn.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/net/request_sock.h | 1 +
> >  include/net/tcp.h          | 3 +++
> >  net/ipv4/tcp_input.c       | 6 ++++++
> >  net/ipv4/tcp_ipv4.c        | 1 +
> >  net/ipv6/tcp_ipv6.c        | 1 +
> >  5 files changed, 12 insertions(+)
> >
> > diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> > index d77237ec9fb4..55297286c066 100644
> > --- a/include/net/request_sock.h
> > +++ b/include/net/request_sock.h
> > @@ -43,6 +43,7 @@ int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req);
> >
> >  struct saved_syn {
> >         u32 network_hdrlen;
> > +       u32 bpf_hdr_opt_off;
> >         u8 data[];
> >  };
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index eab1c7d0facb..07a9dfe35242 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -191,6 +191,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
> >   */
> >  #define TCPOPT_FASTOPEN_MAGIC  0xF989
> >  #define TCPOPT_SMC_MAGIC       0xE2D4C3D9
> > +#define TCPOPT_BPF_MAGIC       0xEB9F
> >
> >  /*
> >   *     TCP option lengths
> > @@ -204,6 +205,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
> >  #define TCPOLEN_FASTOPEN_BASE  2
> >  #define TCPOLEN_EXP_FASTOPEN_BASE  4
> >  #define TCPOLEN_EXP_SMC_BASE   6
> > +#define TCPOLEN_EXP_BPF_BASE   4
> >
> >  /* But this is what stacks really send out. */
> >  #define TCPOLEN_TSTAMP_ALIGNED         12
> > @@ -857,6 +859,7 @@ struct tcp_skb_cb {
> >                         has_rxtstamp:1, /* SKB has a RX timestamp       */
> >                         unused:5;
> >         __u32           ack_seq;        /* Sequence number ACK'd        */
> > +       __u8            bpf_hdr_opt_off;/* offset to bpf hdr option. rx only. */
> >         union {
> >                 struct {
> >                         /* There is space for up to 24 bytes */
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index eb0e32b2def9..640408a80b3d 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -3924,6 +3924,10 @@ void tcp_parse_options(const struct net *net,
> >                                         tcp_parse_fastopen_option(opsize -
> >                                                 TCPOLEN_EXP_FASTOPEN_BASE,
> >                                                 ptr + 2, th->syn, foc, true);
> > +                               else if (opsize >= TCPOLEN_EXP_BPF_BASE &&
> > +                                        get_unaligned_be16(ptr) ==
> > +                                        TCPOPT_BPF_MAGIC)
> > +                                       TCP_SKB_CB(skb)->bpf_hdr_opt_off = (ptr - 2) - (unsigned char *)th;
> >                                 else
> >                                         smc_parse_options(th, opt_rx, ptr,
> >                                                           opsize);
> > @@ -6562,6 +6566,8 @@ static void tcp_reqsk_record_syn(const struct sock *sk,
> >                 saved_syn = kmalloc(len + sizeof(*saved_syn), GFP_ATOMIC);
> >                 if (saved_syn) {
> >                         saved_syn->network_hdrlen = skb_network_header_len(skb);
> > +                       saved_syn->bpf_hdr_opt_off =
> > +                               TCP_SKB_CB(skb)->bpf_hdr_opt_off;
> >                         memcpy(saved_syn->data, skb_network_header(skb), len);
> >                         req->saved_syn = saved_syn;
> >                 }
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index ea0df9fd7618..a3535b7fe002 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1864,6 +1864,7 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
> >         TCP_SKB_CB(skb)->sacked  = 0;
> >         TCP_SKB_CB(skb)->has_rxtstamp =
> >                         skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
> > +       TCP_SKB_CB(skb)->bpf_hdr_opt_off = 0;
> >  }
> >
> >  /*
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index f67d45ff00b4..8356d0562279 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -1545,6 +1545,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
> >         TCP_SKB_CB(skb)->sacked = 0;
> >         TCP_SKB_CB(skb)->has_rxtstamp =
> >                         skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
> > +       TCP_SKB_CB(skb)->bpf_hdr_opt_off = 0;
> >  }
> >
> >  INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
> > --
> > 2.24.1
> >
> 
> (Sorry for the prior empty reply, accidentally click the wrong area)
> 
> It seems strange that we want to add code in TCP stack only to cover a
> limited use case (kind 254 and 0xEB9F magic)
> 
> For something like the work Petar Penkov did (to be able to generate
> SYNCOOKIES from XDP), we do not go through tcp_parse_options() and BPF
> program
> would have to implement its own parsing (without having an SKB at
> hand), probably calling a helper function, with no
> TCP_SKB_CB(skb)->bpf_hdr_opt_off.
> 
> This patch is hard coding a specific option and will prevent anyone
> using private option(s) from using this infrastructure in the future,
> yet paying the extra overhead.
> 
> TCP_SKB_CB(skb) is tight, I would prefer keeping the space in it for
> standard TCP stack features.
> 
> If an optional BPF program needs to re-parse the TCP options to find a
> specific option, maybe the extra cost is noise (especially if this is
> only for SYN & SYNACK packets) ?
Thanks for the feedback.

Re: syn & synack only

The bpf tcp hdr option infrastructure is not only limited to syn
and synack.  It is available to the data/ack/fin pkt also, although
most of the use cases may be limited to syn and synack.
e.g. the latter example tests parsing the 0xeB9F option in FIN.

After a connection is established, the bpf may choose to continue hearing
for (kind 254 and 0xEB9F magic).  bpf_hdr_opt_off is also used to
decide if the tcphdr has the 0xeB9F option and then call the bpf prog
to handle it.

Re: the spaces in TCP_SKB_CB(skb).  I think I can avoid tapping into it.

bpf_hdr_opt_off is only needed upto calling the bpf prog.  i.e. after
the bpf prog returns, the bpf_hdr_opt_off is no longer needed in TCP_SKB_CB.
Like "struct tcp_fastopen_cookie *foc", "u8 *bpf_hdr_opt_off" can be
added to tcp_parse_options() instead of saving it in TCP_SKB_CB(skb).
Then pass it all the way to the bpf prog and also save this to "saved_syn".
Does it address the concern in the spaces in TCP_SKB_CB(skb)?
