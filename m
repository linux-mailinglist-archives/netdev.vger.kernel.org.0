Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25216121F27
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfLQAAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:00:53 -0500
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:15052 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbfLQAAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:00:53 -0500
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id xBH00hTM032714;
        Tue, 17 Dec 2019 00:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=Z+1zvFT5VI/kYrrjCOyCjCH3zfW7cuIb2lDJKy081hY=;
 b=AIXeNOkPzmsAeAJMC1eFLAGOfcXGZRNPNRTvHcabDerwhZQa9zIGDyHV3msy4VrFRkO3
 9e2Fkn7JMIH9+f+KrQHW7IMXBBKzMbKbv7d8pgo10hIrj7TRjr/xk/umIH4klxyq4b3S
 hH418bX4iAsq2Gj0BNjof7cS01sTw5Da80hThzet1AvN3+c6t11Zs00HXQb0XY3s2yX/
 tfrxRVSVwqTtQDhQ2IXdumBtH0IoMJEVXFLz3Wo2eDK6bABnTrA5NnFaOHKSas2+iJsV
 9einbOTZd+by2ouj5dXeCwuxILx65hJvEP5SsTv6z8cvpEg2lHGafqkhwHt3Dg/ofaX7 Gw== 
Received: from prod-mail-ppoint4 (prod-mail-ppoint4.akamai.com [96.6.114.87] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 2wvnpjacty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 00:00:47 +0000
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.27/8.16.0.27) with SMTP id xBGNlWgX010545;
        Mon, 16 Dec 2019 19:00:46 -0500
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint4.akamai.com with ESMTP id 2wvuy4nus0-1;
        Mon, 16 Dec 2019 19:00:45 -0500
Received: from [172.28.3.123] (bos-lp8gj.145bw.corp.akamai.com [172.28.3.123])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 8B97981355;
        Tue, 17 Dec 2019 00:00:14 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 4.19 010/209] tcp: up initial rmem to 128KB and
 SYN rwin to around 64KB
To:     Sasha Levin <sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
 <20191113015025.9685-10-sashal@kernel.org>
 <CAP12E-JHedm+OA9Zaf6PaZBuNw5ddmeMn4RMcSWFFNrH=MpOhA@mail.gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Hunt, Joshua" <johunt@akamai.com>
From:   Vishwanath Pai <vpai@akamai.com>
Message-ID: <14a09720-902f-b4ce-6c8f-98f1667a94ec@akamai.com>
Date:   Mon, 16 Dec 2019 19:00:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAP12E-JHedm+OA9Zaf6PaZBuNw5ddmeMn4RMcSWFFNrH=MpOhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-12-16_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912160199
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 clxscore=1031 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160201
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 9:30 PM Sasha Levin <sashal@kernel.org> wrote:
> 
> From: Yuchung Cheng <ycheng@google.com>
> 
> [ Upstream commit a337531b942bd8a03e7052444d7e36972aac2d92 ]
> 
> Previously TCP initial receive buffer is ~87KB by default and
> the initial receive window is ~29KB (20 MSS). This patch changes
> the two numbers to 128KB and ~64KB (rounding down to the multiples
> of MSS) respectively. The patch also simplifies the calculations s.t.
> the two numbers are directly controlled by sysctl tcp_rmem[1]:
> 
>   1) Initial receiver buffer budget (sk_rcvbuf): while this should
>      be configured via sysctl tcp_rmem[1], previously tcp_fixup_rcvbuf()
>      always override and set a larger size when a new connection
>      establishes.
> 
>   2) Initial receive window in SYN: previously it is set to 20
>      packets if MSS <= 1460. The number 20 was based on the initial
>      congestion window of 10: the receiver needs twice amount to
>      avoid being limited by the receive window upon out-of-order
>      delivery in the first window burst. But since this only
>      applies if the receiving MSS <= 1460, connection using large MTU
>      (e.g. to utilize receiver zero-copy) may be limited by the
>      receive window.
> 
> With this patch TCP memory configuration is more straight-forward and
> more properly sized to modern high-speed networks by default. Several
> popular stacks have been announcing 64KB rwin in SYNs as well.
> 
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ipv4/tcp.c        |  4 ++--
>  net/ipv4/tcp_input.c  | 25 ++-----------------------
>  net/ipv4/tcp_output.c | 25 ++++---------------------
>  3 files changed, 8 insertions(+), 46 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 611ba174265c8..1a1fcb32c4917 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3910,8 +3910,8 @@ void __init tcp_init(void)
>         init_net.ipv4.sysctl_tcp_wmem[2] = max(64*1024, max_wshare);
> 
>         init_net.ipv4.sysctl_tcp_rmem[0] = SK_MEM_QUANTUM;
> -       init_net.ipv4.sysctl_tcp_rmem[1] = 87380;
> -       init_net.ipv4.sysctl_tcp_rmem[2] = max(87380, max_rshare);
> +       init_net.ipv4.sysctl_tcp_rmem[1] = 131072;
> +       init_net.ipv4.sysctl_tcp_rmem[2] = max(131072, max_rshare);
> 
>         pr_info("Hash tables configured (established %u bind %u)\n",
>                 tcp_hashinfo.ehash_mask + 1, tcp_hashinfo.bhash_size);
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 14a6a489937c1..0e2b07be08585 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -426,26 +426,7 @@ static void tcp_grow_window(struct sock *sk,
> const struct sk_buff *skb)
>         }
>  }
> 
> -/* 3. Tuning rcvbuf, when connection enters established state. */
> -static void tcp_fixup_rcvbuf(struct sock *sk)
> -{
> -       u32 mss = tcp_sk(sk)->advmss;
> -       int rcvmem;
> -
> -       rcvmem = 2 * SKB_TRUESIZE(mss + MAX_TCP_HEADER) *
> -                tcp_default_init_rwnd(mss);
> -
> -       /* Dynamic Right Sizing (DRS) has 2 to 3 RTT latency
> -        * Allow enough cushion so that sender is not limited by our window
> -        */
> -       if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf)
> -               rcvmem <<= 2;
> -
> -       if (sk->sk_rcvbuf < rcvmem)
> -               sk->sk_rcvbuf = min(rcvmem,
> sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
> -}
> -
> -/* 4. Try to fixup all. It is made immediately after connection enters
> +/* 3. Try to fixup all. It is made immediately after connection enters
>   *    established state.
>   */
>  void tcp_init_buffer_space(struct sock *sk)
> @@ -454,8 +435,6 @@ void tcp_init_buffer_space(struct sock *sk)
>         struct tcp_sock *tp = tcp_sk(sk);
>         int maxwin;
> 
> -       if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK))
> -               tcp_fixup_rcvbuf(sk);
>         if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
>                 tcp_sndbuf_expand(sk);
> 
> @@ -485,7 +464,7 @@ void tcp_init_buffer_space(struct sock *sk)
>         tp->snd_cwnd_stamp = tcp_jiffies32;
>  }
> 
> -/* 5. Recalculate window clamp after socket hit its memory bounds. */
> +/* 4. Recalculate window clamp after socket hit its memory bounds. */
>  static void tcp_clamp_window(struct sock *sk)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 2697e4397e46c..53f910bb55087 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -179,21 +179,6 @@ static inline void tcp_event_ack_sent(struct sock
> *sk, unsigned int pkts,
>         inet_csk_clear_xmit_timer(sk, ICSK_TIME_DACK);
>  }
> 
> -
> -u32 tcp_default_init_rwnd(u32 mss)
> -{
> -       /* Initial receive window should be twice of TCP_INIT_CWND to
> -        * enable proper sending of new unsent data during fast recovery
> -        * (RFC 3517, Section 4, NextSeg() rule (2)). Further place a
> -        * limit when mss is larger than 1460.
> -        */
> -       u32 init_rwnd = TCP_INIT_CWND * 2;
> -
> -       if (mss > 1460)
> -               init_rwnd = max((1460 * init_rwnd) / mss, 2U);
> -       return init_rwnd;
> -}
> -
>  /* Determine a window scaling and initial window to offer.
>   * Based on the assumption that the given amount of space
>   * will be offered. Store the results in the tp structure.
> @@ -228,7 +213,10 @@ void tcp_select_initial_window(const struct sock
> *sk, int __space, __u32 mss,
>         if (sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
>                 (*rcv_wnd) = min(space, MAX_TCP_WINDOW);
>         else
> -               (*rcv_wnd) = space;
> +               (*rcv_wnd) = min_t(u32, space, U16_MAX);
> +
> +       if (init_rcv_wnd)
> +               *rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
> 
>         (*rcv_wscale) = 0;
>         if (wscale_ok) {
> @@ -241,11 +229,6 @@ void tcp_select_initial_window(const struct sock
> *sk, int __space, __u32 mss,
>                         (*rcv_wscale)++;
>                 }
>         }
> -
> -       if (!init_rcv_wnd) /* Use default unless specified otherwise */
> -               init_rcv_wnd = tcp_default_init_rwnd(mss);
> -       *rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
> -
>         /* Set the clamp no higher than max representable value */
>         (*window_clamp) = min_t(__u32, U16_MAX << (*rcv_wscale), *window_clamp);
>  }
> --
> 2.20.1
> 

Hi Sasha,

Apologies for not bringing this up during the review period, I only just
noticed this patch when updating to v4.19.89. Can you please clarify why
this patch was selected for a LTS update? This doesn't look like a bug
fix and it makes significant changes to core tcp settings. The patch is
also fairly old (Sep 2018) and we generally don't expect a change like
this from a stable kernel update.

A follow up patch (tcp: start receiver buffer autotuning sooner) was
also included in v4.19.86.

Both of the patches were selected by the auto selector based on the
AUTOSEL tag. It looks like this tag only shows up in the email, have you
thought about placing the tag in commit messages as well so that we can
easily identify AUTOSEL patches?

Thanks,
Vishwanath
