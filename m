Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE684478A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404473AbfFMRAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:00:17 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41500 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729773AbfFMACT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 20:02:19 -0400
Received: by mail-pf1-f193.google.com with SMTP id m30so10084987pff.8
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 17:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YDUESB646rGE/IVwAhBdOdDFlzT1Fe3pYy+zXnheJTg=;
        b=KfHLt5cjs9H7cVhUF7lUhuutBJqVxGfM2Z1KL6ty86XPylMaMb9MT+1bJ7D8agCirE
         H3dyhwUf3Ma+dKTzEmxv9AX75R7AIjxMGbVnFjxUyQk3CmA+ckPORdC3rY2Qj3P2N1K8
         bTN0oR/qB5zla6DTYYn6k6lCa8rfPRW5T8JfhTSeHIx2SxAkI5MWbgrDWMs39z6a8i2e
         jJrR+ezPQK6piQYriYMTmgoTwtbkzxg6txWxfzSa7zcd9IXbXbIsMenGHlHLhbcXQAyW
         HHrykwN5p2Nb5Okg8OuSYNIONkJYLe3XmmrE0w/Nj1hhhmNNZWNqxpkuFM6/QJJzeGAL
         KMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YDUESB646rGE/IVwAhBdOdDFlzT1Fe3pYy+zXnheJTg=;
        b=WYHWQb+n2JGbAiHPvSZrf032kBFza3ybWBYTF6Mu5L6AT+IU3ZwdLvN1jCw4FB8Oj6
         hzbKLt7N1epMkXzjufc1DRFMnmkQXVkbaGe9vIeuD4emKFvoV21vApYXiTf18EW1rSAi
         RN0DzQMeh/BWMILVJZ7Ml6V7SEp1E1h0Hne3E3ZBfJpAkmG7S2prEsN+4+xnPTvkmCis
         HYR2pD2IlR1Y6zIEBKFnvZFW1zTh8VB8qe8y85Z2v0zw8zHGTIZe/+KLq8UM1VBLACUJ
         +5DdOKMD0NnnRrTPSR1npLuIoXCnC08Ij8CbkVdKZKum5AE69N6rI2p/woogGWefFF80
         XBzw==
X-Gm-Message-State: APjAAAU00ReRIYqCvOWtfEDpHHaK81igK4406ByZKuaPno9856VVG/7F
        OBv6O6QuAQh5sdYBabGCwO7zc+Ftjrg=
X-Google-Smtp-Source: APXvYqzFTunDH1pyfWd5wOU6xZ4tPlALyEsdyFMvJdVk2ijf0e8OBUTRZWe933xIqfLKzF6D6mROYQ==
X-Received: by 2002:a65:620a:: with SMTP id d10mr27506727pgv.42.1560384138023;
        Wed, 12 Jun 2019 17:02:18 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s1sm625604pfm.187.2019.06.12.17.02.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 17:02:16 -0700 (PDT)
Date:   Wed, 12 Jun 2019 17:02:15 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        Craig Gallek <kraig@google.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: net: Add SO_DETACH_REUSEPORT_BPF
Message-ID: <20190613000215.GD9056@mini-arch>
References: <20190612232412.3196844-1-kafai@fb.com>
 <20190612232414.3196957-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612232414.3196957-1-kafai@fb.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12, Martin KaFai Lau wrote:
> There is SO_ATTACH_REUSEPORT_[CE]BPF but there is no DETACH.
> This patch adds SO_DETACH_REUSEPORT_BPF sockopt.  The same
> sockopt can be used to undo both SO_ATTACH_REUSEPORT_[CE]BPF.
> 
> reseport_detach_prog() is added and it is mostly a mirror
> of the existing reuseport_attach_prog().  The differences are,
> it does not call reuseport_alloc() and returns -ENOENT when
> there is no old prog.
> 
> Cc: Craig Gallek <kraig@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  arch/alpha/include/uapi/asm/socket.h  |  2 ++
>  arch/mips/include/uapi/asm/socket.h   |  2 ++
>  arch/parisc/include/uapi/asm/socket.h |  2 ++
>  arch/sparc/include/uapi/asm/socket.h  |  2 ++
>  include/net/sock_reuseport.h          |  2 ++
>  include/uapi/asm-generic/socket.h     |  2 ++
>  net/core/sock.c                       |  4 ++++
>  net/core/sock_reuseport.c             | 24 ++++++++++++++++++++++++
>  8 files changed, 40 insertions(+)
> 
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 976e89b116e5..de6c4df61082 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -122,6 +122,8 @@
>  #define SO_RCVTIMEO_NEW         66
>  #define SO_SNDTIMEO_NEW         67
>  
> +#define SO_DETACH_REUSEPORT_BPF 68
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index d41765cfbc6e..d0a9ed2ca2d6 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -133,6 +133,8 @@
>  #define SO_RCVTIMEO_NEW         66
>  #define SO_SNDTIMEO_NEW         67
>  
> +#define SO_DETACH_REUSEPORT_BPF 68
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index 66c5dd245ac7..10173c32195e 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -114,6 +114,8 @@
>  #define SO_RCVTIMEO_NEW         0x4040
>  #define SO_SNDTIMEO_NEW         0x4041
>  
> +#define SO_DETACH_REUSEPORT_BPF 0x4042
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 9265a9eece15..1895ac112a24 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -115,6 +115,8 @@
>  #define SO_RCVTIMEO_NEW          0x0044
>  #define SO_SNDTIMEO_NEW          0x0045
>  
> +#define SO_DETACH_REUSEPORT_BPF  0x0046
> +
>  #if !defined(__KERNEL__)
>  
>  
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index 8a5f70c7cdf2..d9112de85261 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -35,6 +35,8 @@ extern struct sock *reuseport_select_sock(struct sock *sk,
>  					  struct sk_buff *skb,
>  					  int hdr_len);
>  extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
> +extern int reuseport_detach_prog(struct sock *sk);
> +
>  int reuseport_get_id(struct sock_reuseport *reuse);
>  
>  #endif  /* _SOCK_REUSEPORT_H */
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index 8c1391c89171..77f7c1638eb1 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -117,6 +117,8 @@
>  #define SO_RCVTIMEO_NEW         66
>  #define SO_SNDTIMEO_NEW         67
>  
> +#define SO_DETACH_REUSEPORT_BPF 68
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 75b1c950b49f..06be30737b69 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1045,6 +1045,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>  		}
>  		break;
>  
> +	case SO_DETACH_REUSEPORT_BPF:
> +		ret = reuseport_detach_prog(sk);
> +		break;
> +
>  	case SO_DETACH_FILTER:
>  		ret = sk_detach_filter(sk);
>  		break;
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index dc4aefdf2a08..e0cb29469fa7 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -332,3 +332,27 @@ int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
>  	return 0;
>  }
>  EXPORT_SYMBOL(reuseport_attach_prog);
> +
> +int reuseport_detach_prog(struct sock *sk)
> +{
> +	struct sock_reuseport *reuse;
> +	struct bpf_prog *old_prog;
> +
> +	if (!rcu_access_pointer(sk->sk_reuseport_cb))
> +		return sk->sk_reuseport ? -ENOENT : -EINVAL;
> +
> +	spin_lock_bh(&reuseport_lock);
> +	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> +					  lockdep_is_held(&reuseport_lock));

[..]
> +	old_prog = rcu_dereference_protected(reuse->prog,
> +					     lockdep_is_held(&reuseport_lock));
> +	RCU_INIT_POINTER(reuse->prog, NULL);
Nit, optionally can do the following instead:

	struct bpf_prog *old_prog = NULL;

	...

	spin_lock_bh(&reuseport_lock);
	reuse = rcu_dereference_protected(...);
	rcu_swap_protected(reuse->prog, old_prog, lockdep_is_held(...));
	spin_unlock_bh(&reuseport_lock);

	if (!old_prog)
		....

	...

rcu_swap_protected does rcu_dereference_protected+rcu_assign_pointer,
can save you one line :-)

> +	spin_unlock_bh(&reuseport_lock);
> +
> +	if (!old_prog)
> +		return -ENOENT;
> +
> +	sk_reuseport_prog_free(old_prog);
> +	return 0;
> +}
> +EXPORT_SYMBOL(reuseport_detach_prog);
> -- 
> 2.17.1
> 
