Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709051DD935
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgEUVOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:14:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14537C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:14:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m1so6876905ybk.5
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=semgcmJd0ZZ9q+OBcE/cjzRQcM4RABCN/d9XODlBjRA=;
        b=TlYSTVO/Y8u4XRBQIPQXsEu5jGML3Ds00FRBHt//Mxa9a2AaScCsqVRxFRWHdU2drB
         Oc3DmuiIsF0NWvZfGexbksIlGcw3bTNLnB7Dm2vDAvLHR0EzpVD44ZglXDaidxyyv29c
         imLD0eJU1+IZelhBUQDzp6FhQKefWoXPsjeRjoVeWZMYpuTceYBZXqwe1usyba7Mo5fd
         lxPYQMiD5umdUV8hOrVNEke3LLE++/LulrbW2iidAoyzCqUm37kUbnc4WgFvpmV98zoy
         lJZHfQ5EpPOmS9n4KMjq3spWJA07pHcS/UJ6p83Krdx6oi+LWBGpfxXoxwUURqVeV0T5
         SBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=semgcmJd0ZZ9q+OBcE/cjzRQcM4RABCN/d9XODlBjRA=;
        b=c1xEJtCXiUcD408V2gl1Ccpw9imW8rBFF9xuz4bvpvP3FGEP1FPPc1zm74i11tgmSn
         MPJGmrYwYXxXrnBAy04zPoxcT5N7OmhW22PuF6JoCd4JB/aYYxNzGBNvDJMTRcRVtMAi
         A5OzYEa8txjsKqHVdMWANp/zjyAfbgVhqBLFOP+HrueE+2ToVvBwBtq77jsq/VJ7QzEZ
         1vcJKc/d4I3OY1lisIMvOJjf+xX5v5VThuRiWFFIvVPX5SPLEehQi2UlBAg0ym+lA1X1
         /U9p6musWVzVf7zycaAjRS4y/O8Oz0I0O3or64miObgiDT6I74Pq4xp1gv1Goaq/yvIW
         4UUQ==
X-Gm-Message-State: AOAM530l1tSYbLEDIhU8qebXDHVqovIq4eD/QY2zWrlr+kZS3ckWdmXu
        RK1wkgixHyCEODtkv1H8OoGzVsY=
X-Google-Smtp-Source: ABdhPJw5CN2ei/ClgLNdsSzrKVS4Hgzwn2pYl2BgA0+O1BHrOE25xjmCCA7f/kCtzSd2kWGb8repg8I=
X-Received: by 2002:a25:cbc9:: with SMTP id b192mr18457440ybg.132.1590095674239;
 Thu, 21 May 2020 14:14:34 -0700 (PDT)
Date:   Thu, 21 May 2020 14:14:32 -0700
In-Reply-To: <20200521125247.30178-1-fejes@inf.elte.hu>
Message-Id: <20200521211432.GC49942@google.com>
Mime-Version: 1.0
References: <20200521125247.30178-1-fejes@inf.elte.hu>
Subject: Re: [PATCH net-next] Extending bpf_setsockopt with SO_BINDTODEVICE sockopt
From:   sdf@google.com
To:     Ferenc Fejes <fejes@inf.elte.hu>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/21, Ferenc Fejes wrote:
> This option makes possible to programatically bind sockets to netdevices.
> With the help of this option sockets of VRF unaware applications
> could be distributed between multiple VRFs with eBPF sock_ops program.
> This let the applications benefit from the multiple possible routes.

> Signed-off-by: Ferenc Fejes <fejes@inf.elte.hu>
> ---
>   net/core/filter.c | 39 ++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 38 insertions(+), 1 deletion(-)

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 822d662f97ef..25dac75bfc5d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4248,6 +4248,9 @@ static const struct bpf_func_proto  
> bpf_get_socket_uid_proto = {
>   static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>   			   char *optval, int optlen, u32 flags)
>   {
> +	char devname[IFNAMSIZ];
> +	struct net *net;
> +	int ifindex;
>   	int ret = 0;
>   	int val;

> @@ -4257,7 +4260,7 @@ static int _bpf_setsockopt(struct sock *sk, int  
> level, int optname,
>   	sock_owned_by_me(sk);

>   	if (level == SOL_SOCKET) {
> -		if (optlen != sizeof(int))
> +		if (optlen != sizeof(int) && optname != SO_BINDTODEVICE)
>   			return -EINVAL;
>   		val = *((int *)optval);

> @@ -4298,6 +4301,40 @@ static int _bpf_setsockopt(struct sock *sk, int  
> level, int optname,
>   				sk_dst_reset(sk);
>   			}
>   			break;
> +		case SO_BINDTODEVICE:
> +			ret = -ENOPROTOOPT;
> +#ifdef CONFIG_NETDEVICES
Any specific reason you're not reusing sock_setbindtodevice or at least
sock_setbindtodevice_locked here? I think, historically, we've
reimplemented some of the sockopts because they were 'easy' (i.e.
were just setting a flag in the socket), this one looks more involved.

I'd suggest, add an optional 'lock_sk' argument to sock_setbindtodevice,
call it with 'true' from real setsockopt, and call it with 'false'
here.

And, as Andrii pointed out, it would be nice to have a selftest
that exercises this new option.
