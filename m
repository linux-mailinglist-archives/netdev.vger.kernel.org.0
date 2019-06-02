Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1733253D
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 00:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfFBWAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 18:00:23 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46331 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFBWAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 18:00:23 -0400
Received: by mail-lj1-f196.google.com with SMTP id m15so6022403ljg.13;
        Sun, 02 Jun 2019 15:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pSO0H2Cb09CLOksHCZL4+23n2F4bglfpiYqVlXdmSfM=;
        b=rXUyCBlMcV0bxFvqljbaR2UaMAAKXoGyvYOwiL/fraYrb6NX1s+e06Db9EmTtqZyq+
         MR9+Aj7S7O0Esk1UGwr5N3MsS20PQbC6MjjZT0UyE3LB9lU/OmE3hxPpTeRxMCMscSTj
         bM8WlmIS2thi69ERW3BEQlCfeuJ2NlX7b3nA1YjDNzidYEX7taTrVG8j1NfN9uw5LYEG
         QCIsyOeDsNjNtJWo2T5zpo9DAi94Js2EmxoOkbU97JY6FQV4VHDUkJHqPWffysMBS5pN
         ADpDcj57t3ob377xVWa8R8LcdFHbJS1/TvUf+Rw1nQDRlYN7CQkw9yu+SipjBVdm0KJA
         DCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pSO0H2Cb09CLOksHCZL4+23n2F4bglfpiYqVlXdmSfM=;
        b=bn7KO7kSG9gqwHIq+rPXsuiF16yx43XhYo15auszsqGq/ECJEt+Zhrrnu2Vs9pyOZY
         MTi61kICWDfl/NibXXoa+hB4rbgXTugZqV3I+DdFOm9J4QPhkQ0bz1VPmRSXyyRxppfj
         q8Tm16eBVxfhQiRbhtZQHzX7Ern72hef6jpLVHrRuTg9868sYKuGYHn6NoYGnqLu4aZ8
         DHfpA6AUeUmv0e8I1DUJxOAIx9aN7+N4oRThY5iYu+sBva9oPntDTtdpQxA/Qm41z7mE
         b7jevFnLxhlpI49Y0CtNqfJdLe2yb6bpS9DgZbw8lvgYYj8kKj8aA/KBzet19dLnseCH
         cz0A==
X-Gm-Message-State: APjAAAUnzDgqcKXc+kmOeXHruCqoKpYBGMDXdLjXXP/r303zFFkeUOl+
        Gvo18AGkvagnTl04nqhPhGLYvEiYhZ29kMSRvDo=
X-Google-Smtp-Source: APXvYqzF2ASIyINX5BllZ1zYtV8spOtlH4ML28puBxpogyGYLuAXeJjrOIOpZBBzC3J7OdWvFcybZF60eiLm7KaJ6zs=
X-Received: by 2002:a2e:8116:: with SMTP id d22mr7225ljg.8.1559512820874; Sun,
 02 Jun 2019 15:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190602213926.2290-1-olteanv@gmail.com> <20190602213926.2290-9-olteanv@gmail.com>
In-Reply-To: <20190602213926.2290-9-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 3 Jun 2019 01:00:10 +0300
Message-ID: <CA+h21ho1d0RWE=fjy9YhcJ2aBr11BHvOT+daoQd7M+S1S6B0WA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 08/10] net: dsa: sja1105: Make
 sja1105_is_link_local not match meta frames
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 at 00:40, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Although meta frames are configured to be sent at SJA1105_META_DMAC
> (01-80-C2-00-00-0E) which is a multicast MAC address that would also be
> trapped by the switch to the CPU, were it to receive it on a front-panel
> port, meta frames are conceptually not link-local frames, they only
> carry their RX timestamps.
>
> The choice of sending meta frames at a multicast DMAC is a pragmatic
> one, to avoid installing an extra entry to the DSA master port's
> multicast MAC filter.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> Changes in v2:
>
> Patch is new.
>
>  include/linux/dsa/sja1105.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
> index f3237afed35a..d64e56d6c521 100644
> --- a/include/linux/dsa/sja1105.h
> +++ b/include/linux/dsa/sja1105.h
> @@ -31,6 +31,8 @@ static inline bool sja1105_is_link_local(const struct sk_buff *skb)
>         const struct ethhdr *hdr = eth_hdr(skb);
>         u64 dmac = ether_addr_to_u64(hdr->h_dest);
>
> +       if (ntohs(hdr->h_proto) == ETH_P_SJA1105_META)
> +               return false;
>         if ((dmac & SJA1105_LINKLOCAL_FILTER_A_MASK) ==
>                     SJA1105_LINKLOCAL_FILTER_A)
>                 return true;
> --
> 2.17.1
>

Please be aware that this patch is misplaced and should be moved after
the current 09/10 (doesn't compile as 08/10).
I'll bundle this change in v3 with the other feedback I'll hopefully get.

Thanks!
-Vladimir
