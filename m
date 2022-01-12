Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6A748CEB8
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 00:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiALXFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 18:05:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234993AbiALXFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 18:05:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642028749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ws9TpzzjuOpfNvU+GlroZVEa9/4QRGFMjeW9z5siB2s=;
        b=bQAQbgT9S+oJ6ofMVUiJCYudmwv3KC8pKRF9MyD8u9CqbM1YzonMLsr0vsVhLN52P8UaIu
        YNq61f3jX+nbV2ECODAQjQahc4kDQAPRZjwC6w4vdOt4wnW97EFxrWy+xEw/GC3xwtpoYV
        2amqogwsW9z5vcmB2kzZvpzbLrOFoWA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-kZqGn5qnO9qYeU4nRNZ64Q-1; Wed, 12 Jan 2022 18:05:48 -0500
X-MC-Unique: kZqGn5qnO9qYeU4nRNZ64Q-1
Received: by mail-ed1-f71.google.com with SMTP id z9-20020a05640240c900b003fea688a17eso3607013edb.10
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 15:05:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ws9TpzzjuOpfNvU+GlroZVEa9/4QRGFMjeW9z5siB2s=;
        b=7YhOFxNzT03V2wbzv+DQ7FOFWaMwj62zZCfekCvAjC4EFq1F7Ecc2Ds6ckm28+tdCa
         OwMB/H9uBc7yTZDPScR0yVfJH3Y0Vf4wGDGjUuZUbV9dFGYm9mZ+lGDRLoJ6dHpAKMDT
         SQMO+tZOVaZX9BBCTWqDRp3X5AqONSnKfGZu0Wwe3IQtz/ZWt3wxyMmWxx4O69aEWsBN
         kG67a1t/P9khYYpjkuQqHVdO/f0SEF0SnnNvALA0aqC8k5sw4fTRAq+b05aozIje5onm
         CqJr+eh8n9sJiOzz5gDW88o2wNUAF6VdwGl8XGMqAHG3b00YRdY4vQkxRnvIlGG8AjjQ
         n+6w==
X-Gm-Message-State: AOAM532UTPQwVwYqvfR3tDneIfDYPY+KIHzknM/j78YNb3GLfODC2mhe
        d7YGgIPB9/PevQNewQKOwdn0/fXRCGtGz7lQRH3GI3FlpzWrjt3WXOzKnv4VJsmbDlXFtBhsi5P
        nTTAhxCtxj2iuoRTw
X-Received: by 2002:a05:6402:4404:: with SMTP id y4mr1783918eda.226.1642028746623;
        Wed, 12 Jan 2022 15:05:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwojY1LxAjD9AXAzaNuTF4NAhU9QOmsFCUDXeKKPiTITlH+XF52dJU+fJLJfD7B/tnfoQW5Uw==
X-Received: by 2002:a05:6402:4404:: with SMTP id y4mr1783858eda.226.1642028745612;
        Wed, 12 Jan 2022 15:05:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id qf22sm318756ejc.85.2022.01.12.15.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 15:05:44 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 242B21802D8; Thu, 13 Jan 2022 00:05:44 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org, Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        hideaki.yoshifuji@miraclelinux.com,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address
 calculation
In-Reply-To: <20220112131204.800307-3-Jason@zx2c4.com>
References: <20220112131204.800307-1-Jason@zx2c4.com>
 <20220112131204.800307-3-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Jan 2022 00:05:44 +0100
Message-ID: <87r19cftbr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> BLAKE2s is faster and more secure. SHA-1 has been broken for a long time
> now. This also removes some code complexity, and lets us potentially
> remove sha1 from lib, which would further reduce vmlinux size.

So this one is a bit less obvious than the BPF case: the "stable address
generation" is supposed to result in generating addresses that are,
well, stable. The documentation for the stable_secret sysctl implies
that this should be for the lifetime of the system:

       It is recommended to generate this secret during installation
       of a system and keep it stable after that.

However, if we make this change, systems setting a stable_secret and
using addr_gen_mode 2 or 3 will come up with a completely different
address after a kernel upgrade. Which would be bad for any operator
expecting to be able to find their machine again after a reboot,
especially if it is accessed remotely.

I haven't ever used this feature myself, though, or seen it in use. So I
don't know if this is purely a theoretical concern, or if the
stable_address feature is actually used in this way in practice. If it
is, I guess the switch would have to be opt-in, which kinda defeats the
purpose, no (i.e., we'd have to keep the SHA1 code around)?

Adding some of the people involved in the original work on stable
address generation in the hope that they can shed some light on the
real-world uses for this feature.

-Toke

> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  net/ipv6/addrconf.c | 31 +++++++++----------------------
>  1 file changed, 9 insertions(+), 22 deletions(-)
>
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 3445f8017430..f5cb534aa261 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -61,7 +61,7 @@
>  #include <linux/delay.h>
>  #include <linux/notifier.h>
>  #include <linux/string.h>
> -#include <linux/hash.h>
> +#include <crypto/blake2s.h>
>  
>  #include <net/net_namespace.h>
>  #include <net/sock.h>
> @@ -3225,25 +3225,16 @@ static int ipv6_generate_stable_address(struct in6_addr *address,
>  					const struct inet6_dev *idev)
>  {
>  	static DEFINE_SPINLOCK(lock);
> -	static __u32 digest[SHA1_DIGEST_WORDS];
> -	static __u32 workspace[SHA1_WORKSPACE_WORDS];
> -
> -	static union {
> -		char __data[SHA1_BLOCK_SIZE];
> -		struct {
> -			struct in6_addr secret;
> -			__be32 prefix[2];
> -			unsigned char hwaddr[MAX_ADDR_LEN];
> -			u8 dad_count;
> -		} __packed;
> -	} data;
> -
> +	struct {
> +		struct in6_addr secret;
> +		__be32 prefix[2];
> +		unsigned char hwaddr[MAX_ADDR_LEN];
> +		u8 dad_count;
> +	} __packed data;
>  	struct in6_addr secret;
>  	struct in6_addr temp;
>  	struct net *net = dev_net(idev->dev);
>  
> -	BUILD_BUG_ON(sizeof(data.__data) != sizeof(data));
> -
>  	if (idev->cnf.stable_secret.initialized)
>  		secret = idev->cnf.stable_secret.secret;
>  	else if (net->ipv6.devconf_dflt->stable_secret.initialized)
> @@ -3254,20 +3245,16 @@ static int ipv6_generate_stable_address(struct in6_addr *address,
>  retry:
>  	spin_lock_bh(&lock);
>  
> -	sha1_init(digest);
>  	memset(&data, 0, sizeof(data));
> -	memset(workspace, 0, sizeof(workspace));
>  	memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
>  	data.prefix[0] = address->s6_addr32[0];
>  	data.prefix[1] = address->s6_addr32[1];
>  	data.secret = secret;
>  	data.dad_count = dad_count;
>  
> -	sha1_transform(digest, data.__data, workspace);
> -
>  	temp = *address;
> -	temp.s6_addr32[2] = (__force __be32)digest[0];
> -	temp.s6_addr32[3] = (__force __be32)digest[1];
> +	blake2s((u8 *)&temp.s6_addr32[2], (u8 *)&data, NULL,
> +		sizeof(temp.s6_addr32[2]) * 2, sizeof(data), 0);
>  
>  	spin_unlock_bh(&lock);
>  
> -- 
> 2.34.1

