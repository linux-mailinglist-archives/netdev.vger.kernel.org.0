Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50490A62DD
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfICHlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:41:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39114 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfICHlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 03:41:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so16292561wra.6
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 00:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uBbUOkIm+hH/m14NkeDfPWKMLj5o4khZfJMW5jryBcE=;
        b=QoK5X2QAn2dUaAmKjiJ/rEroSGEIbnCg53g3eOECKDszqFGO2gTZL/uzRfP7mzN+z6
         A6sua53AntqGuv/85deF67WF6c/KJleB3HnSY17rrfEHqavdX34rMytTr23WR+Ua3v1I
         81CFC7Z22lHcCVDTUPHfc6BIrVFeTPV4enSX3De8BQ1VfY3umExtkIq/M6ONxuGGZyQA
         0tWTTOnXmndKc/BDyq09/1XFM5Vjumuq8vbt48PyY5pXEMxJBJV4E+G127Qg6P+8jyux
         TM65PLdoiS2wAMfdVcTEWi3etNPdkvC8YGs21jUATeKBF2u2OC2uXP1aQboKMYRTa7GZ
         XYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uBbUOkIm+hH/m14NkeDfPWKMLj5o4khZfJMW5jryBcE=;
        b=t5SzsHBpprpt0SE0g6Oe6cGYMRAvai6Co8y28XFDW4Q1/JPW38toXNWkBmCckFjnJa
         cDJvM1jbqIikfCAbbgkjRvkge58bPx9Bh1ffU/zYtIV1j9yDNB0gKx5ff4uri251Gk+s
         Dtp5FFc8SA8A0RccBVgQR1agihXUNuymoVtSelc1F9oV4v42iD+wuH/pxM+O+fGNzqif
         OyGi3zoSm6EwkqaSsDPO6z6orNrGIfNAxKcUkBoupGwH50YTLXETycVObxvddAxdc7oR
         fGMPFAoSnjDhY0tJaQfLZ5eyH9NAwRqGitihjRY6w6l0+PG1J+0e8E5rYebgo5WYBwzH
         8B8A==
X-Gm-Message-State: APjAAAUN0sIZ+SLI+7M/tCqkZwQtZnHW/ITdg+a8LFwlrk+HPgGoP51k
        8/zfR01BAfNicM4ofs22hoM=
X-Google-Smtp-Source: APXvYqzShBBplqgd4izBo86iWGfRzzykD1vG4VAT61JglL4R6touZqkKY0/M8CNlkUXS+eYsvZplbA==
X-Received: by 2002:adf:f284:: with SMTP id k4mr22166016wro.294.1567496510618;
        Tue, 03 Sep 2019 00:41:50 -0700 (PDT)
Received: from [192.168.8.147] (85.162.185.81.rev.sfr.net. [81.185.162.85])
        by smtp.gmail.com with ESMTPSA id c9sm14053555wrv.40.2019.09.03.00.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 00:41:50 -0700 (PDT)
Subject: Re: [PATCH] Clock-independent TCP ISN generation
To:     Cyrus Sh <sirus.shahini@gmail.com>, davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, sirus@cs.utah.edu
References: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fa0aadb3-9ada-fb08-6f32-450f5ac3a3e1@gmail.com>
Date:   Tue, 3 Sep 2019 09:41:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 7:06 AM, Cyrus Sh wrote:
> This patch addresses the privacy issue of TCP ISN generation in Linux
> kernel. Currently an adversary can deanonymize a user behind an anonymity
> network by inducing a load pattern on the target machine and correlating
> its clock skew with the pattern. Since the kernel adds a clock-based
> counter to generated ISNs, the adversary can observe SYN packets with
> similar IP and port numbers to find out the clock skew of the target
> machine and this can help them identify the user.  To resolve this problem
> I have changed the related function to generate the initial sequence
> numbers randomly and independent from the cpu clock. This feature is
> controlled by a new sysctl option called "tcp_random_isn" which I've added
> to the kernel. Once enabled the initial sequence numbers are guaranteed to
> be generated independently from each other and from the hardware clock of
> the machine. If the option is off, ISNs are generated as before.  To get
> more information about this patch and its effectiveness you can refer to my
> post here:
> https://bitguard.wordpress.com/?p=982


<quote>
Firstly it’s unlikely that this happens at all,
</quote>

Sorry this happens all the time.
Some people use very disturbing setups really, and they are not trying to be malicious.

Clock skew seems quite secondary. Some firewall rules should prevent this kind of attacks ?

> and to see a discussion about the issue you can read this:
> https://trac.torproject.org/projects/tor/ticket/16659

Four years old discussion. Does not seem urgent matter :/

> 
> Signed-off-by: Sirus Shahini <sirus.shahini@gmail.com>
> ---
>  include/net/tcp.h           |  1 +
>  include/uapi/linux/sysctl.h |  1 +
>  kernel/sysctl_binary.c      |  1 +
>  net/core/secure_seq.c       | 24 +++++++++++++++++++++++-
>  net/ipv4/sysctl_net_ipv4.c  |  7 +++++++
>  net/ipv4/tcp_input.c        |  1 +
>  6 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 81e8ade..4ad1bbf 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -241,6 +241,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
>  
>  /* sysctl variables for tcp */
>  extern int sysctl_tcp_max_orphans;
> +extern int sysctl_tcp_random_isn;

All TCP sysctls are per netns these days. (Look in include/net/netns/ipv4.h )

>  extern long sysctl_tcp_mem[3];
>  
>  #define TCP_RACK_LOSS_DETECTION  0x1 /* Use RACK to detect losses */
> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
> index 87aa2a6..ba8927e 100644
> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -426,6 +426,7 @@ enum
>  	NET_TCP_ALLOWED_CONG_CONTROL=123,
>  	NET_TCP_MAX_SSTHRESH=124,
>  	NET_TCP_FRTO_RESPONSE=125,
> +	NET_IPV4_TCP_RANDOM_ISN=126,

Nope, we do not add new sysctls there anymore.

Everybody should now have /proc files to tune the values.

>  };
>  
>  enum {
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index 73c1320..0faf7d4 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -332,6 +332,7 @@ static const struct bin_table bin_net_ipv4_netfilter_table[] = {
>  };
>  
>  static const struct bin_table bin_net_ipv4_table[] = {
> +	{CTL_INT,   NET_IPV4_TCP_RANDOM_ISN     "tcp_random_isn"}

Same remark. We no longer add stuff there.

>  	{CTL_INT,	NET_IPV4_FORWARD,			"ip_forward" },
>  
>  	{ CTL_DIR,	NET_IPV4_CONF,		"conf",		bin_net_ipv4_conf_table },
> diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
> index 7b6b1d2..b644bbe 100644
> --- a/net/core/secure_seq.c
> +++ b/net/core/secure_seq.c
> @@ -22,6 +22,7 @@
>  
>  static siphash_key_t net_secret __read_mostly;
>  static siphash_key_t ts_secret __read_mostly;
> +static siphash_key_t last_secret = {{0,0}} ;
>  
>  static __always_inline void net_secret_init(void)
>  {
> @@ -134,8 +135,29 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
>  		   __be16 sport, __be16 dport)
>  {
>  	u32 hash;
> -
> +	u32 temp;
> +	
>  	net_secret_init();
> +	
> +	if (sysctl_tcp_random_isn){
> +		if (!last_secret.key[0] && !last_secret.key[1]){
> +			memcpy(&last_secret,&net_secret,sizeof(last_secret));	
> +					
> +		}else{

Check your patch using scripts/checkpatch.pl

All these missing spaces should be spotted.

> +			temp = *((u32*)&(net_secret.key[0]));
> +			temp >>= 8;
> +			last_secret.key[0]+=temp;
> +			temp = *((u32*)&(net_secret.key[1]));
> +			temp >>= 8;
> +			last_secret.key[1]+=temp;

Why not simply use an official random generator, instead of these convoluted
and not SMP safe attempts ?

Check drivers/char/random.c for officially maintained generators.

> +		}
> +		hash = siphash_3u32((__force u32)saddr, (__force u32)daddr,
> +			        (__force u32)sport << 16 | (__force u32)dport,
> +			        &last_secret);
> +		return hash;
> +	}
> +	
> +	
>  	hash = siphash_3u32((__force u32)saddr, (__force u32)daddr,
>  			    (__force u32)sport << 16 | (__force u32)dport,
>  			    &net_secret);
