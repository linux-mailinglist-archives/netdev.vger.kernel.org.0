Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5007367ECBB
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 18:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbjA0Rsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 12:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjA0Rsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:48:52 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1276432E51
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 09:48:52 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id b1so6872994ybn.11
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 09:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eieLlMtUQzDO09X9B4p1rcAat7hYw6HTgh7Q6bnDcaw=;
        b=Wqb+Dod4io8SaenzXGi1FZuPfthgItQ13pMJsNCiOWXYKH89tx2JTM12+PZceomjrB
         3L9Rl43IZkPeIhV6+WLYMdhekZUc7btkPf9XRayWu9VHWB1C0KQhxcGKXJCsMCW1Uj7n
         KhHbNblIR3Rh/KeIuqAJbAa7t+GxqnE5h14tE1aIJrSkkUrm35ixPE5wMYJisANRuACi
         psWk1cXIxq95/I7OLYn4hxO37aO3hKIPUoT3pM8foHWtF5KRrXBNt5Af3VaXJkXaZPC6
         5lcQqttPN8JZ6dd3/vijoD3wtmrKsuWx+Bnpv/Bd8Autf6RUqjTFhg0FYqcg5y2K9Pa3
         2dAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eieLlMtUQzDO09X9B4p1rcAat7hYw6HTgh7Q6bnDcaw=;
        b=LX8AxDEqVEZ5Jye7b8KHNotfeD58Fd8qLLvwme2I+0QQvQQN4mp6UHFQJ/2K5z7hT+
         nxnkNQAI2Cul3GGfVKQBe05MynPTtHK7SsM7M8gIAJCi9akIGF+GHiqoePnu2MCNmhKa
         raJIHxX1oBnivwNiTFlETm3g5tkETbQ2xe//ju36qbtuFj00e8+vsZKTvplDKsVD4mAq
         8AY0r5CAHndSJ7PzqFCRP1eGOPu4eFtBHQ5fOczBV4pTtDxB9ChAlBjCdKgKRJkb7lRb
         q+AR6apS9Hp6irccUbaRfCzhZpazxJBfYBnplrbpzWy6RvZ1J0w1K/LbOJ/KpvMsDEFg
         U4VQ==
X-Gm-Message-State: AO0yUKUT6DeFtOMxlMhDjVCRO4oOA2I0MZJiARvquGaZNPyAF8LNGCmU
        g+CnnqpTdDhQk1PuoSS263P0UkoKlvW1a9KVRfaS6g==
X-Google-Smtp-Source: AK7set9C/iHihBmD9nG8Ow6aSaiS2ARlS4kCyfX/DeaMPaopULqek3Sa5BtFew/gBmeV62ZulPnjo0rfy6CvM4bquRg=
X-Received: by 2002:a25:37d4:0:b0:80b:8602:f3fe with SMTP id
 e203-20020a2537d4000000b0080b8602f3femr1810255yba.36.1674841730975; Fri, 27
 Jan 2023 09:48:50 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674835106.git.lucien.xin@gmail.com> <905adccfe82888a8f0ca05fe6f2abd7e3a9649a0.1674835106.git.lucien.xin@gmail.com>
In-Reply-To: <905adccfe82888a8f0ca05fe6f2abd7e3a9649a0.1674835106.git.lucien.xin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 27 Jan 2023 18:48:40 +0100
Message-ID: <CANn89iJWRZNpSbCYVzgKGpzVjuQo2nXk9y-ysWyQ7dJ+PzUHjQ@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 09/10] net: add gso_ipv4_max_size and
 gro_ipv4_max_size per device
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 5:00 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> This patch introduces gso_ipv4_max_size and gro_ipv4_max_size
> per device and adds netlink attributes for them, so that IPV4
> BIG TCP can be guarded by a separate tunable in the next patch.
>
> To not break the old application using "gso/gro_max_size" for
> IPv4 GSO packets, this patch updates "gso/gro_ipv4_max_size"
> in netif_set_gso/gro_max_size() if the new size isn't greater
> than GSO_LEGACY_MAX_SIZE, so that nothing will change even if
> userspace doesn't realize the new netlink attributes.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/linux/netdevice.h    |  6 ++++++
>  include/uapi/linux/if_link.h |  3 +++
>  net/core/dev.c               |  4 ++++
>  net/core/dev.h               | 18 ++++++++++++++++++
>  net/core/rtnetlink.c         | 33 +++++++++++++++++++++++++++++++++
>  5 files changed, 64 insertions(+)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 63b77cbc947e..ce075241ec47 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2010,6 +2010,9 @@ enum netdev_ml_priv_type {
>   *                     SET_NETDEV_DEVLINK_PORT macro. This pointer is static
>   *                     during the time netdevice is registered.
>   *
> + *     @gso_ipv4_max_size:     Maximum size of IPv4 GSO packets.
> + *     @gro_ipv4_max_size:     Maximum size of IPv4 GRO packets.
> + *
>   *     FIXME: cleanup struct net_device such that network protocol info
>   *     moves out.
>   */
> @@ -2362,6 +2365,9 @@ struct net_device {
>         struct rtnl_hw_stats64  *offload_xstats_l3;
>
>         struct devlink_port     *devlink_port;
> +
> +       unsigned int            gso_ipv4_max_size;
> +       unsigned int            gro_ipv4_max_size;

This seems a pretty bad choice in terms of data locality.

Field order in "struct net_device" is very important for performance.

Please put gro_ipv4_max_size close to other related fields, so that we
do not need an extra cache line miss.

Same for gso_ipv4_max_size.

Use "pahole --hex" to study how "struct net_device" is currently partitioned.
It seems we have a hole after tso_max_segs, so this would be for
gso_ipv4_max_size


>  };
>  #define to_net_dev(d) container_of(d, struct net_device, dev)
>
>
