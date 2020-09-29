Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C84827BC5A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 07:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgI2FRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 01:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgI2FRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 01:17:39 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F09FC061755;
        Mon, 28 Sep 2020 22:17:35 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 77so4020075lfj.0;
        Mon, 28 Sep 2020 22:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xif5oC/NRIYYhpW7XETZfA0h68yDq+U57n1x8FOdeWU=;
        b=rawzs6k4NMlg6bsVsbWsPDBl2UaCGARw1RPjil0OKWhWmLKHo+FOAGheM4W/l1jgCh
         ntfnJQD1rlXTUrk+If0qpZD2YxEp3os+qzms7fAR7NI0dZkd+LmOdlaKA7/39J2TQThs
         n7OIgwshgCO5DCcBoNk+gpLg8GsgWOyArueI5twuJ25+eeLBroZfYUD85jJqmBBC1HsZ
         AOsL6pO/eQ3kcK4P8XtgmWLVbRC888sDzCDtBJ//C6VivSP8Rc6IvHdx5+cDx/pL3iCi
         U447icvBcUcFBM0BdPKdDNq8m83UnVT2/ZMBdhmV+wtQSxmPW4Pjf6HHHzhjk24ybuW2
         mbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xif5oC/NRIYYhpW7XETZfA0h68yDq+U57n1x8FOdeWU=;
        b=TLiionnPO0fs/L8jXVBWjVXYmBe2t5T/n2VVqORsjgDl9e504eCiJ0CJhRVASWz7U/
         vRLQ5y2WZWM4rIWSxZaT2B9UpxW36/6eqXxLUhARRabr/fdPcAqL3hvB6AfC2dxEResp
         69g2KsGzNYYLOzxvtLd4ncn6iVO/FCHaL/x3Jef1F65e2+XXnhcOlYMF+Dq3Ykf6Ka9Z
         0GxpQad4CwxVYug+KBFWoNM1ZF5g9jV5hB/BiVirhyWJt88GuUmAjnHExTmADhfQujKu
         oYu2RahCtUETEf+znITqC/gp2TinaPFJ8ZOxcNOMJFefos+zsrXSqiqJcUHL8Fsc3iuz
         Khkw==
X-Gm-Message-State: AOAM531tURi6cbj6RyVICuC/CDBKSnXAodX9DUNlNYg3jQT8JgQq7RpE
        bDbS4I1yGdQ55fxkHnE3GRKwvhQ9vpNznJMVHVw=
X-Google-Smtp-Source: ABdhPJycgZBSkevRQeXI1VbUJ3Yyp8eqTYufhpIaDs+0WpIrV5IhsXpb1BlXRucnYS+kLO+uTMnYwDrzZsNB+58IdvU=
X-Received: by 2002:a05:6512:31d2:: with SMTP id j18mr621070lfe.316.1601356651774;
 Mon, 28 Sep 2020 22:17:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200929050302.28105-1-bigclouds@163.com>
In-Reply-To: <20200929050302.28105-1-bigclouds@163.com>
From:   yue longguang <yuelongguang@gmail.com>
Date:   Tue, 29 Sep 2020 13:17:20 +0800
Message-ID: <CAPaK2r__afG7epSM6As3SehhCvTk4KvXB_UjQuwjCNZmf-giGA@mail.gmail.com>
Subject: Re: [PATCH] ipvs: Add traffic statistic up even it is VS/DR or VS/TUN mode
To:     "longguang.yue" <bigclouds@163.com>
Cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

especially in public cloud case, statistic is related to monitorring
and billing , both ingress and egress packets will go throught ipvs,
even dr/tun mode.
in dr/tun mode, ipvs need to do nothing except  statistic, so
skb->ipvs_property = 1

regards

On Tue, Sep 29, 2020 at 1:04 PM longguang.yue <bigclouds@163.com> wrote:
>
> It's ipvs's duty to do traffic statistic if packets get hit,
> no matter what mode it is.
>
> Signed-off-by: longguang.yue <bigclouds@163.com>
> ---
>  net/netfilter/ipvs/ip_vs_core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index e3668a6e54e4..ed523057f07f 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1413,8 +1413,11 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
>                              ipvs, af, skb, &iph);
>
>         if (likely(cp)) {
> -               if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
> +               if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ){
> +                       ip_vs_out_stats(cp, skb);
> +                       skb->ipvs_property = 1;
>                         goto ignore_cp;
> +               }
>                 return handle_response(af, skb, pd, cp, &iph, hooknum);
>         }
>
> --
> 2.20.1 (Apple Git-117)
>
