Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFAF642286
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 06:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiLEFOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 00:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiLEFOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 00:14:23 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3870D331
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 21:14:22 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3c090251d59so106898307b3.4
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 21:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dITHtQi/A5bYBAf6KbS5DSW0lKGPuNOyGTUBxUF7AgY=;
        b=TyigMKiGsh2Mvm77hdPASul/h5eOCSrlwDizATJJTDJuKupBRpkW+sxTGBHpLrwJSO
         HFJeklkwhz2/EPOtwpOSTnp3tKMkUkKHL/OtKPAKeyYDEeTI9zpNtlE3BO4AhcwGBnZz
         y7lS4Rj77j8RIJkK59IqYTF7TL35a1NmGR6BEUXKPq6+QIG3ru5mVjrKZPqGmEoMiyWH
         tBTXu0nf99X+k5HusPGa3ILNVsZA6PCd/DlC1F6CbxoqgTz/bmSjrZ5ln8fOBmChr9Kh
         pFq0L5HYm5yXH1cLQAfk3DuYp36SSCo2Qu0qSKJMubq1naNXLTeeSS96jwkva4uE7Xj+
         ljBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dITHtQi/A5bYBAf6KbS5DSW0lKGPuNOyGTUBxUF7AgY=;
        b=j701nINnlehAHcisCqNJf/q+C96r44EB8eT0VZZLm/tMl2qCx6cHgYMZC5r/0F3zQl
         j7+udUoijD3IU+h3tpyE3Ntd4f6t9sFIPAZJJ9pdU4CuyyCMRBui5ccVjQDl8fhVpQ4Q
         u2P9D6esx5BOsgBGhspMW0kmoP+ZZr7TpkoNktd9XAwFASohgN9tJS0/oudfYO9X+eSB
         QAqChZTn8p8hn4RO1cvt7VxfoVuomsb5Bi6TYPB6B1sai5LaqCjKeavbOxmJOUEggZ91
         NqxANBfykbPf1aBQQLCjSqA/+54zLaMnewdgET4If+okuOksRqXNx20fAhDz0rjBJ1u1
         vyXA==
X-Gm-Message-State: ANoB5pkm/k4gfFMUdTFQgvJv/c7MaeaHEVahKyLGNJdszVmQSW0GtV3u
        71+BouBzrYkK4HveZ8FFdnto6nQRl16RB4HZGgpTwQ==
X-Google-Smtp-Source: AA0mqf589PO51soNDzIh3cYWq3iC4LLE+eAfYZuI7dpQWa/vmCoLPucU3I1KWyqD2nUSJbff9mv5zK80I5iCQ3vVfrM=
X-Received: by 2002:a81:6ec6:0:b0:3c7:38d8:798f with SMTP id
 j189-20020a816ec6000000b003c738d8798fmr33164591ywc.489.1670217261153; Sun, 04
 Dec 2022 21:14:21 -0800 (PST)
MIME-Version: 1.0
References: <20221202221213.236564-1-lixiaoyan@google.com> <20221202221213.236564-2-lixiaoyan@google.com>
In-Reply-To: <20221202221213.236564-2-lixiaoyan@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 06:14:10 +0100
Message-ID: <CANn89iLx7WM4ih6EM8LAdXHN6W2Pd61awPz4FLL82FEBbXeRuA@mail.gmail.com>
Subject: Re: [RFC net-next v4 2/2] bnxt: Use generic HBH removal helper in tx path
To:     Coco Li <lixiaoyan@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri, Dec 2, 2022 at 11:12 PM Coco Li <lixiaoyan@google.com> wrote:
>
> Eric Dumazet implemented Big TCP that allowed bigger TSO/GRO packet sizes
> for IPv6 traffic. See patch series:
> 'commit 89527be8d8d6 ("net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes")'
>
> This reduces the number of packets traversing the networking stack and
> should usually improves performance. However, it also inserts a
> temporary Hop-by-hop IPv6 extension header.
>
> Using the HBH header removal method in the previous path, the extra header
> be removed in bnxt drivers to allow it to send big TCP packets (bigger
> TSO packets) as well.
>
> Tested:
> Compiled locally
>
> To further test functional correctness, update the GSO/GRO limit on the
> physical NIC:
>
> ip link set eth0 gso_max_size 181000
> ip link set eth0 gro_max_size 181000
>
> Note that if there are bonding or ipvan devices on top of the physical
> NIC, their GSO sizes need to be updated as well.
>
> Then, IPv6/TCP packets with sizes larger than 64k can be observed.
>
> Big TCP functionality is tested by Michael, feature checks not yet.
>
> Tested by Michael:
> I've confirmed with our hardware team that this is supported by our
> chips, and I've tested it up to gso_max_size of 524280.  Thanks.
>
> Tested-by: Michael Chan <michael.chan@broadcom.com>
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 26 ++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 0fe164b42c5d..c2713cb5debd 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
>                         return NETDEV_TX_BUSY;
>         }
>
> +       if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> +               goto tx_free;
> +
>         length = skb->len;
>         len = skb_headlen(skb);
>         last_frag = skb_shinfo(skb)->nr_frags;
> @@ -11342,9 +11345,28 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
>
>                 if (hdrlen > 64)
>                         return false;
> +
> +               /* The ext header may be a hop-by-hop header inserted for
> +                * big TCP purposes. This will be removed before sending
> +                * from NIC, so do not count it.
> +                */
> +               if (*nexthdr == NEXTHDR_HOP) {
> +                       if (likely(skb->len <= GRO_LEGACY_MAX_SIZE))
> +                               goto increment_hdr;
> +
> +                       struct hop_jumbo_hdr *jhdr = (struct hop_jumbo_hdr *)(nexthdr + hdrlen);

We discourage adding a variable declaration in the middle of code.

> +
> +                       if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0 ||
> +                           (jhdr->nexthdr != IPPROTO_TCP && jhdr->nexthdr != IPPROTO_UDP))

Why testing IPPROTO_UDP ? I do not think we support BIG UDP yet.

> +                               goto increment_hdr;
> +
> +                       goto next_hdr;
> +               }
> +increment_hdr:
> +               hdr_count++;
> +next_hdr:
>                 nexthdr = &hp->nexthdr;
>                 start += hdrlen;
> -               hdr_count++;
>         }
>         if (nextp) {
>                 /* Caller will check inner protocol */
> @@ -13657,6 +13679,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>                 dev->features &= ~NETIF_F_LRO;
>         dev->priv_flags |= IFF_UNICAST_FLT;
>
> +       netif_set_tso_max_size(dev, GSO_MAX_SIZE);
> +
>  #ifdef CONFIG_BNXT_SRIOV
>         init_waitqueue_head(&bp->sriov_cfg_wait);
>  #endif
> --
> 2.39.0.rc0.267.gcb52ba06e7-goog
>
