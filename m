Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9E31E4A98
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391393AbgE0QnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391374AbgE0QnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:43:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E556C05BD1E;
        Wed, 27 May 2020 09:43:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y18so12027799pfl.9;
        Wed, 27 May 2020 09:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=94sxmCrRmKc2DPC3KtsPhTBWnnvvgtJyZZ9zT5mbST0=;
        b=oci0UzdIpbTt0Mfohfd29HpoAbIEWMIMoj+bLJpuOBVNj6c0GlPxouzFREhMAwRVDe
         2AEaAekKR3EtRQtIVSB20VBwj3JDOtRRi9fQu8dzAkxa9XgT3jfbaCN3XbdgAL8qSvn+
         9XBgvVx7DDBl5XAX7mFgb6nrzz5QbaqHSDVZV0wnwmrEi6zn5uoXQYYWOIlT7b/our0Z
         qO7v4/A0kTQ6XGYtjoQYlgubw4mpIMHtmw2aBkBmpzrLi2+/JpNXOXT+kxi/9aJbY+0U
         ln4wm/c3KsetD6Tymg2Un07qFT52FQR/FLdIhfk+ILvC1LbNFWAPfTWAqcgx0c+3+9JC
         PQOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=94sxmCrRmKc2DPC3KtsPhTBWnnvvgtJyZZ9zT5mbST0=;
        b=Uqbwk2dCgZro+eo8acC5ZBUM7avSo62ogClJ/PKqG+XivBZuuR8qQzxn3LVlj8+12L
         YaXugcql9AaS9ZfSwRlbns7G893kIHTMmvvi9oxORBzcOfTzGS19BKuU+KpCrZPkq4FQ
         h/MOzEX1E9CDt47/H2E1jeHYD24s2Wp47GG59kQyeTd22JdsPglRBK+IqobE3S6LvM/g
         NIgChVr3txpww5hD7o66vP6O0xkZAimjg0zXTLrXoZ+LJ6/CC3Uxj04cOm263zusrNSb
         cIAJJ41obDjbx+xY8LSCvP32l0ad2WrL81DKskDFmaTRIvvDNHDBdasVJQzhwJ5bzx2u
         P5qA==
X-Gm-Message-State: AOAM531GFTUePZy68DV4MBOeZXh82zmgA9uNNIp4rmqdN3wqpSFtKIvm
        rjaVAvsVWTRv10zBP3o7B/JTX5w4
X-Google-Smtp-Source: ABdhPJzn3sre/YraVwci/yEWviH2itDM3GQeAPW7Y6Q8V3JKgYPYNfUwfprNWGPJRCo1OR/aVsAZIQ==
X-Received: by 2002:a63:7e5a:: with SMTP id o26mr4962244pgn.134.1590597780261;
        Wed, 27 May 2020 09:43:00 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u4sm4186115pjf.3.2020.05.27.09.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:42:59 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpf: add SO_KEEPALIVE and related options to
 bpf_setsockopt
To:     Dmitry Yakunin <zeil@yandex-team.ru>, davem@davemloft.net,
        brakmo@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200527150543.93335-1-zeil@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b5133e4e-4562-1ea0-9d46-c5fb74528ec8@gmail.com>
Date:   Wed, 27 May 2020 09:42:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200527150543.93335-1-zeil@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/20 8:05 AM, Dmitry Yakunin wrote:
> This patch adds support of SO_KEEPALIVE flag and TCP related options
> to bpf_setsockopt() routine. This is helpful if we want to enable or tune
> TCP keepalive for applications which don't do it in the userspace code.
> In order to avoid copy-paste, common code from classic setsockopt was moved
> to auxiliary functions in the headers.


Please split this in two patches :
- one adding the helpers, a pure TCP patch.
- one for BPF additions.


> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>  include/net/sock.h |  9 +++++++++
>  include/net/tcp.h  | 18 ++++++++++++++++++
>  net/core/filter.c  | 39 ++++++++++++++++++++++++++++++++++++++-
>  net/core/sock.c    |  9 ---------
>  net/ipv4/tcp.c     | 15 ++-------------
>  5 files changed, 67 insertions(+), 23 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 3e8c6d4..ee35dea 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -879,6 +879,15 @@ static inline void sock_reset_flag(struct sock *sk, enum sock_flags flag)
>  	__clear_bit(flag, &sk->sk_flags);
>  }
>  
> +static inline void sock_valbool_flag(struct sock *sk, enum sock_flags bit,
> +				     int valbool)
> +{
> +	if (valbool)
> +		sock_set_flag(sk, bit);
> +	else
> +		sock_reset_flag(sk, bit);
> +}
> +
>  static inline bool sock_flag(const struct sock *sk, enum sock_flags flag)
>  {
>  	return test_bit(flag, &sk->sk_flags);
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index b681338..ae6a495 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1465,6 +1465,24 @@ static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
>  			  tcp_jiffies32 - tp->rcv_tstamp);
>  }
>  
> +/* val must be validated at the top level function */
> +static inline void keepalive_time_set(struct tcp_sock *tp, int val)
> +{
> +	struct sock *sk = (struct sock *)tp;

We prefer the other way to avoid a cast unless really needed :

static inline tcp_keepalive_time_set(struct sock *sk, int val)
{
      stuct tcp_sock *tp = tcp_sk(sk);




> +
> +	tp->keepalive_time = val * HZ;
> +	if (sock_flag(sk, SOCK_KEEPOPEN) &&
> +	    !((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))) {
> +		u32 elapsed = keepalive_time_elapsed(tp);
> +
> +		if (tp->keepalive_time > elapsed)
> +			elapsed = tp->keepalive_time - elapsed;
> +		else
> +			elapsed = 0;
> +		inet_csk_reset_keepalive_timer(sk, elapsed);
> +	}
> +}
> +
>  static inline int tcp_fin_time(const struct sock *sk)
>  {
>  	int fin_timeout = tcp_sk(sk)->linger2 ? : sock_net(sk)->ipv4.sysctl_tcp_fin_timeout;
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a6fc234..1035e43 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4248,8 +4248,8 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
>  static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>  			   char *optval, int optlen, u32 flags)
>  {
> +	int val, valbool;
>  	int ret = 0;
> -	int val;
>  
>  	if (!sk_fullsock(sk))
>  		return -EINVAL;
> @@ -4260,6 +4260,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>  		if (optlen != sizeof(int))
>  			return -EINVAL;
>  		val = *((int *)optval);
> +		valbool = val ? 1 : 0;
>  
>  		/* Only some socketops are supported */
>  		switch (optname) {
> @@ -4298,6 +4299,11 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>  				sk_dst_reset(sk);
>  			}
>  			break;
> +		case SO_KEEPALIVE:
> +			if (sk->sk_prot->keepalive)
> +				sk->sk_prot->keepalive(sk, valbool);
> +			sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
> +			break;
>  		default:
>  			ret = -EINVAL;
>  		}
> @@ -4358,6 +4364,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>  			ret = tcp_set_congestion_control(sk, name, false,
>  							 reinit, true);
>  		} else {
> +			struct inet_connection_sock *icsk = inet_csk(sk);
>  			struct tcp_sock *tp = tcp_sk(sk);
>  
>  			if (optlen != sizeof(int))
> @@ -4386,6 +4393,36 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>  				else
>  					tp->save_syn = val;
>  				break;
> +			case TCP_KEEPIDLE:
> +				if (val < 1 || val > MAX_TCP_KEEPIDLE)
> +					ret = -EINVAL;
> +				else
> +					keepalive_time_set(tp, val);
> +				break;
> +			case TCP_KEEPINTVL:
> +				if (val < 1 || val > MAX_TCP_KEEPINTVL)
> +					ret = -EINVAL;
> +				else
> +					tp->keepalive_intvl = val * HZ;
> +				break;
> +			case TCP_KEEPCNT:
> +				if (val < 1 || val > MAX_TCP_KEEPCNT)
> +					ret = -EINVAL;
> +				else
> +					tp->keepalive_probes = val;
> +				break;
> +			case TCP_SYNCNT:
> +				if (val < 1 || val > MAX_TCP_SYNCNT)
> +					ret = -EINVAL;
> +				else
> +					icsk->icsk_syn_retries = val;
> +				break;
> +			case TCP_USER_TIMEOUT:
> +				if (val < 0)
> +					ret = -EINVAL;
> +				else
> +					icsk->icsk_user_timeout = val;
> +				break;
>  			default:
>  				ret = -EINVAL;
>  			}
> diff --git a/net/core/sock.c b/net/core/sock.c
> index fd85e65..9836b01 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -684,15 +684,6 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
>  	return ret;
>  }
>  
> -static inline void sock_valbool_flag(struct sock *sk, enum sock_flags bit,
> -				     int valbool)
> -{
> -	if (valbool)
> -		sock_set_flag(sk, bit);
> -	else
> -		sock_reset_flag(sk, bit);
> -}
> -
>  bool sk_mc_loop(struct sock *sk)
>  {
>  	if (dev_recursion_level())
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9700649..7b239e8 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3003,19 +3003,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>  	case TCP_KEEPIDLE:
>  		if (val < 1 || val > MAX_TCP_KEEPIDLE)
>  			err = -EINVAL;
> -		else {
> -			tp->keepalive_time = val * HZ;
> -			if (sock_flag(sk, SOCK_KEEPOPEN) &&
> -			    !((1 << sk->sk_state) &
> -			      (TCPF_CLOSE | TCPF_LISTEN))) {
> -				u32 elapsed = keepalive_time_elapsed(tp);
> -				if (tp->keepalive_time > elapsed)
> -					elapsed = tp->keepalive_time - elapsed;
> -				else
> -					elapsed = 0;
> -				inet_csk_reset_keepalive_timer(sk, elapsed);
> -			}
> -		}
> +		else
> +			keepalive_time_set(tp, val);
>  		break;
>  	case TCP_KEEPINTVL:
>  		if (val < 1 || val > MAX_TCP_KEEPINTVL)
> 
