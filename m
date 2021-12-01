Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C2046547B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352222AbhLASBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352006AbhLASAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:45 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEE7C0613DD;
        Wed,  1 Dec 2021 09:57:11 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id m6so50207332oim.2;
        Wed, 01 Dec 2021 09:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZLy6Jb+6Ty24fX68SpNaQHHxD3uEqTcLfyiSOpS1cog=;
        b=GiV7gMzj+3aRKlq31wAPB3RVY+mEmhyhz0l3S43ArUwJV5I5ALh6N+eNs0DO0OCMAj
         ll0RBwEiQmQ+3n+VxHbtKCVoJCM8OaCENU0Ffl0Iq9y+tmt2qUwZtoU/JwfaBO2dZZeo
         0tVGBqcsLIgXVNBEwg30A8mwQUV18n89uta5H3IcEnz+583zmHMrY6Rs6xFstVCF/aUP
         PmRC6wNTz+7P+ArnCy1Rq++sHLB92JbVXDnvMQfyUJVbjN7md/5eugFy1monZ7Pet7SU
         em+a4oMQroZG1OUtFf5qfbpw/e4h5VBHACaZuE3tajOGS71FdkTmIk7WGhLyfPvSYpov
         fNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZLy6Jb+6Ty24fX68SpNaQHHxD3uEqTcLfyiSOpS1cog=;
        b=P9oMUXfzMZbDtAp5ipe51M4WkegBvYGjr2VIYnih7Tz/VGD07hSHccan6/nmJCHoJY
         pGi5j8LJi3eGFkWpcTznE5UtClZCeUNBdqOsFodtonB0onEq85elifQLQzG273X9+MzC
         3uHc0x+hGQ/QtiGRHPlshe3kzhv7mu9txtAL2Jt/SsGeEkBn6ovOykOjDwU+ylDRZzMg
         UqHMPll2hRQDsga2Xvd4CqZMccSOe8lt0sv67J5k96Snr40ZjwBkzq8Bb+pXg3eNHGdg
         UHvlo9LgmtvQSSsBrrrV3yYG7VH6VlfdOuk5FKaL8MILSOpPQxpDdnVdT7AYix+yo1SM
         m/nQ==
X-Gm-Message-State: AOAM531WU6RagYLme7YtmJefZmhW7Jk7TSzf5l14xf3ij770TPBns1Nf
        Yqzfr52oWBofY4FKY7QXXyA=
X-Google-Smtp-Source: ABdhPJxfBuWPwGbgqA8NaLP/Hxr10UC/stVPUmZU5tFkPgYG/wFW+cRClTJPbiQ+XHQUm5JY+P4/5A==
X-Received: by 2002:aca:de07:: with SMTP id v7mr7367492oig.28.1638381431002;
        Wed, 01 Dec 2021 09:57:11 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id d3sm158953otc.0.2021.12.01.09.57.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 09:57:10 -0800 (PST)
Message-ID: <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
Date:   Wed, 1 Dec 2021 10:57:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
 <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 8:32 AM, Pavel Begunkov wrote:
> 
> Sure. First, for dummy I set mtu by hand, not sure can do it from
> the userspace, can I? Without it __ip_append_data() falls into
> non-zerocopy path.
> 
> diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
> index f82ad7419508..5c5aeacdabd5 100644
> --- a/drivers/net/dummy.c
> +++ b/drivers/net/dummy.c
> @@ -132,7 +132,8 @@ static void dummy_setup(struct net_device *dev)
>      eth_hw_addr_random(dev);
>  
>      dev->min_mtu = 0;
> -    dev->max_mtu = 0;
> +    dev->mtu = 0xffff;
> +    dev->max_mtu = 0xffff;
>  }
> 
> # dummy configuration
> 
> modprobe dummy numdummies=1
> ip link set dummy0 up


No change is needed to the dummy driver:
  ip li add dummy0 type dummy
  ip li set dummy0 up mtu 65536


> # force requests to <dummy_ip_addr> go through the dummy device
> ip route add <dummy_ip_addr> dev dummy0

that command is not necessary.

> 
> 
> With dummy I was just sinking the traffic to the dummy device,
> was good enough for me. Omitting "taskset" and "nice":
> 
> send-zc -4 -D <dummy_ip_addr> -t 10 udp
> 
> Similarly with msg_zerocopy:
> 
> <kernel>/tools/testing/selftests/net/msg_zerocopy -4 -p 6666 -D
> <dummy_ip_addr> -t 10 -z udp

I get -ENOBUFS with '-z' and any local address.

> 
> 
> For loopback testing, as zerocopy is not allowed for it as Willem
> explained in
> the original MSG_ZEROCOPY cover-letter, I used a hack to bypass it:
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index ebb12a7d386d..42df33b175ce 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2854,9 +2854,7 @@ static inline int skb_orphan_frags(struct sk_buff
> *skb, gfp_t gfp_mask)
>  /* Frags must be orphaned, even if refcounted, if skb might loop to rx
> path */
>  static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
>  {
> -    if (likely(!skb_zcopy(skb)))
> -        return 0;
> -    return skb_copy_ubufs(skb, gfp_mask);
> +    return skb_orphan_frags(skb, gfp_mask);
>  }
>  

that is the key change that is missing in your repo. All local traffic
(traffic to the address on a dummy device falls into this comment) goes
through loopback. That's just the way Linux works. If you look at the
dummy driver, it's xmit function just drops packets if any actually make
it there.


>> mileage varies quite a bit.
> 
> Interesting, any brief notes on the setup and the results? Dummy

VM on Chromebook. I just cloned your repos, built, install and test. As
mentioned above, the skb_orphan_frags_rx change is missing from your
repo and that is the key to your reported performance gains.

