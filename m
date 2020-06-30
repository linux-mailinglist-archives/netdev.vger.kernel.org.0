Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A1210061
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgF3XYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:24:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3126 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725791AbgF3XYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:24:35 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UNJp82007271;
        Tue, 30 Jun 2020 16:24:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8QAtl4/4C0pOa8KdvWnbzZm1/7pcei8z7pmkcmsgnRc=;
 b=DzigCAhDrbVwmjWw3+6vtQYIKl8GCOjA9E+5KV4Skm2dPnPTCSNwW0B5EO/qhuOxmu8I
 Qo3pT50JHBiBipgUG+ZqSThHlte4o1f+iGj1WmqX1W4h0EiulZv526xo4VWTYx0Lwmrw
 9rTsl6pquqUmVFJE8dzTY5y3bAplS7nopIY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3upq1nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jun 2020 16:24:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 16:24:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpgAtDRuZQ0m9+EUIMEg348DJdx8tg9esEYEBumxQ9y7tE/Qh6ffuAsek0OvLmvarM6wkM1nrP2Lsb6UriP4F50XX2l7oj6peb1IFkI6t+54dGFG1icvs95d6nf/3Qtqs4NRNCPvlDUgnyVudFL8dopV0hHrA914dGc6t9aIreHF3rS10YfgxQBrfcHyjraGVFHaGSKlwGwyEm8S5z7SX2HboaHxNEKmEbxNZIKF09J2/G9SQ5Zh8YuJFjmTx7zpAmPcjhakeb18+SngK3EuwvWND6V3cbvp/tEc8WATjXRZ0970O1YDvAfJtPeCluLUKSwa95CjvyNlkXjLGcaBHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QAtl4/4C0pOa8KdvWnbzZm1/7pcei8z7pmkcmsgnRc=;
 b=jUX04xsP5JhrH/+hesbtbAG3kLH4SLjr7NVXlmpH9gvzMXqg8Vn0bbVbe9dq8jp33iOKQHt0eJFOPyTQy2jdNx/bPll/dlCurcvNaNFIr7wkldaDV7dXvKbaZFk41+qdQxDe7dyui3tRAicjN67Y+qEpdyJRb86lmnzo9ID7u/hILNQkMt3H7q7KrxkM1i0W6nq8f2TpN8GXzjkdAH6sYNrXo8pR1lneH00dxXNXlMxuYTJWIhoFuAA3CsFIfyYez+Ie8D19R4aBV6F/AwSyHv3g+Wc5At3J4DKoMNkdylquU0X+4CFHl0ZC5VQQmkFDbI4bsQm6s2xrhSv5Yq64+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QAtl4/4C0pOa8KdvWnbzZm1/7pcei8z7pmkcmsgnRc=;
 b=NK0N6bXbmpL3+TRujWEXTGJetFfu3JNu8zNyshM+i7vjRtnFKEuQ3WVdffY6Gg+USCAlxgkuostgD+K3lzMYcmb4QxPS93cFkRJLF4LIKlDLzSCNVYwnPNqMx2vC73PNJHP/vLOnHVPDN4FRsJ+Ahr+48q1h0CsyJFUWVyIpwHA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3605.namprd15.prod.outlook.com (2603:10b6:610:7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Tue, 30 Jun
 2020 23:24:16 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 23:24:16 +0000
Date:   Tue, 30 Jun 2020 16:24:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH bpf-next 01/10] tcp: Use a struct to represent a saved_syn
Message-ID: <20200630232406.3ozanjlyx5a2mv6i@kafai-mbp.dhcp.thefacebook.com>
References: <20200626175501.1459961-1-kafai@fb.com>
 <20200626175508.1460345-1-kafai@fb.com>
 <CANn89iLJNWh6bkH7DNhy_kmcAexuUCccqERqe7z2QsvPhGrYPQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLJNWh6bkH7DNhy_kmcAexuUCccqERqe7z2QsvPhGrYPQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR08CA0066.namprd08.prod.outlook.com
 (2603:10b6:a03:117::43) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a88e) by BYAPR08CA0066.namprd08.prod.outlook.com (2603:10b6:a03:117::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23 via Frontend Transport; Tue, 30 Jun 2020 23:24:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:a88e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8408041b-9a1e-46f4-df6c-08d81d4cb464
X-MS-TrafficTypeDiagnostic: CH2PR15MB3605:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB3605C4CBB6915939C50C10FBD56F0@CH2PR15MB3605.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqtzVIgyx0/4BuzFQU1ohDcjYl0T6FXFh9tQNeEhTBTzDH6arhQo5KkBu3Fy+bv/wgchFJfIpTnb6lDaLRa9qJjvl0QrBGj1XyhfsPV/j/BYGxZmA7fO3q+W+brBC1Jx6BPZK6JJ3fj2DFXOgLMvG5sqm7B7s2WNIn4bjoBkF/RAignImv/r2wOCWjuF6UbNhZobcqdr6CovHfy27EqNaa4uzwr1vyfKhle5GkE4+4odUAn/RqnXBvinNsSCo7+akcGxB/MF/0bed2TNGWoBMdZoe61Roz48PAG/yS3uZZOOsh7oRJe1bTLsxFR7vmnevfVdEA5eGKVWoGIAOKcnpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(366004)(376002)(396003)(346002)(6666004)(2906002)(54906003)(66556008)(66476007)(4326008)(66946007)(9686003)(6916009)(55016002)(316002)(5660300002)(86362001)(8936002)(1076003)(478600001)(53546011)(52116002)(7696005)(8676002)(16526019)(83380400001)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: K+jMj7NiSXtd+oIkwibaGODV2P4q2VNK4ekZjvJ1Oh7xzeAy1P85Vfik35nbjMe9noQjYbs9OsOdtWLn0ebGnFlephXket5ftvlHodYjISYghBfdR4aHpmMqNP66ws99lNTPlYZkWj0rmJq5xLzwDidITErZ7gNHTNVFRYbPK+Z+D9DvXvPq37bEmvPzfuoCBt/aVjWt98WIFfK+4s2mZIljAqGObClTfvBHWb2+RPJswLM9atx7eVeKs744+V+FPTBtAQSd6hInAcXQ8rIrx+o266n8KoxjiL/4nWeTwPpADIziQH2ehybnRNPYg06zfJTWRepRRUZ7gY8vsZmZWoxtcrkwmnirfPzX8Vv3o5kZp3zw1/u90vnRWkLskxaEAndgSmEX2TvIAvzPNIpzBGRbwdMeuBGPP3ih+PvGyQ30o2fukykHBGVsMevfmFnrHGAgIsHLPTMWo1z7qV6gqGcWGqsxHAdLKTMVt+H6bP1QE10QadIlUsKwD9AhqKUVNt7Kbmk/J8/xU5rEdm3giw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8408041b-9a1e-46f4-df6c-08d81d4cb464
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 23:24:16.0821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxcpqrlE43jLvfAV8BQNIsqjSFanRpMdZVL5wpnV/M/jGVn3e57UFd/4tarNXRza
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3605
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=778 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 cotscore=-2147483648
 suspectscore=2 mlxscore=0 malwarescore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 10:41:32AM -0700, Eric Dumazet wrote:
> On Fri, Jun 26, 2020 at 10:55 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > The total length of the saved syn packet is currently stored in
> > the first 4 bytes (u32) and the actual packet data is stored after that.
> >
> > A latter patch will also want to store an offset (bpf_hdr_opt_off) to
> > a TCP header option which the bpf program will be interested in parsing.
> > Instead of anonymously storing this offset into the second 4 bytes,
> > this patch creates a struct for the existing saved_syn.
> > It can give a readable name to the stored lengths instead of implicitly
> > using the first few u32(s) to do that.
> >
> > The new TCP bpf header offset (bpf_hdr_opt_off) added in a latter patch is
> > an offset from the tcp header instead of from the network header.
> > It will make the bpf programming side easier.  Thus, this patch stores
> > the network header length instead of the total length of the syn
> > header.  The total length can be obtained by the
> > "network header len + tcp_hdrlen".  The latter patch can
> > then also gets the offset to the TCP bpf header option by
> > "network header len + bpf_hdr_opt_off".
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/tcp.h        | 11 ++++++++++-
> >  include/net/request_sock.h |  7 ++++++-
> >  net/core/filter.c          |  4 ++--
> >  net/ipv4/tcp.c             |  9 +++++----
> >  net/ipv4/tcp_input.c       | 12 ++++++------
> >  5 files changed, 29 insertions(+), 14 deletions(-)
> >
> > diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> > index 3bdec31ce8f4..9d50132d95e6 100644
> > --- a/include/linux/tcp.h
> > +++ b/include/linux/tcp.h
> > @@ -404,7 +404,7 @@ struct tcp_sock {
> >          * socket. Used to retransmit SYNACKs etc.
> >          */
> >         struct request_sock __rcu *fastopen_rsk;
> > -       u32     *saved_syn;
> > +       struct saved_syn *saved_syn;
> >  };
> >
> >  enum tsq_enum {
> > @@ -482,6 +482,15 @@ static inline void tcp_saved_syn_free(struct tcp_sock *tp)
> >         tp->saved_syn = NULL;
> >  }
> >
> > +static inline u32 tcp_saved_syn_len(const struct saved_syn *saved_syn)
> > +{
> > +       const struct tcphdr *th;
> > +
> > +       th = (void *)saved_syn->data + saved_syn->network_hdrlen;
> > +
> > +       return saved_syn->network_hdrlen + __tcp_hdrlen(th);
> > +}
> 
> 
> Ah... We have a patch extending TCP_SAVE_SYN to save all headers, so
> keeping the length in a proper field would be better than going back
> to TCP header to get __tcp_hdrlen(th)
> 
> I am not sure why trying to save 4 bytes in this saved_syn would matter ;)
I will use another 4 bytes to store __tcp_hdrlen().

> 
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index c9fcfa4ec43f3f0d75763e2bc6773e15bd38d68f..8ecdc5f87788439c7a08d3b72f9567e6369e7c4e
> 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -258,7 +258,7 @@ struct tcp_sock {
>                 fastopen_connect:1, /* FASTOPEN_CONNECT sockopt */
>                 fastopen_no_cookie:1, /* Allow send/recv SYN+data
> without a cookie */
>                 is_sack_reneg:1,    /* in recovery from loss with SACK reneg? */
> -               unused:2;
> +               save_syn:2;     /* Save headers of SYN packet */
Interesting idea.  I don't have an immediate use case in the mac header of
the SYN but I think it may be useful going forward.

Although bpf_hdr_opt_off may be no longer needed in v2,
it will still be convenient for the bpf prog to be able to get the TCP header
only instead of reparsing from the mac/ip[46] and also save some stack space
of the bpf prog.  Thus, storing the length of each hdr would still be nice
so that the bpf helper can directly offset to the start of the required
header.

Do you prefer to incorporate this "save_syn:2" idea in this set
so that mac hdrlen can be stored in the "struct saved_syn"?

This "unused:2" bits have already been used by "fastopen_client_fail:2".
May be get 2 bits from repair_queue?


>         u8      nonagle     : 4,/* Disable Nagle algorithm?             */
>                 thin_lto    : 1,/* Use linear timeouts for thin streams */
>                 recvmsg_inq : 1,/* Indicate # of bytes in queue upon recvmsg */
> @@ -270,7 +270,7 @@ struct tcp_sock {
>                 syn_fastopen_exp:1,/* SYN includes Fast Open exp. option */
>                 syn_fastopen_ch:1, /* Active TFO re-enabling probe */
>                 syn_data_acked:1,/* data in SYN is acked by SYN-ACK */
> -               save_syn:1,     /* Save headers of SYN packet */
> +               unused_save_syn:1,      /* Moved above */
>                 is_cwnd_limited:1,/* forward progress limited by snd_cwnd? */
>                 syn_smc:1;      /* SYN includes SMC */
>         u32     tlp_high_seq;   /* snd_nxt at the time of TLP retransmit. */
