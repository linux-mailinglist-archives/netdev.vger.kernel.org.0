Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E605163FDE9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiLBCDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiLBCDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:03:20 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E61BE139
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 18:03:19 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id be13so5319642lfb.4
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 18:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6DC30ra67XbimQ0DPoAW+D9lHfkQCC2g+rgI/z0QNHM=;
        b=XbCWI67Q8OAZgL4Wau2xeIeIytpIwMQxvjeU30HTI/a+y1BnRiRRoRO4mJgFhAISmV
         gtnXQG8XTMrlVx99MvawpbB9QACC/wSfDHghUJiL4sbz3g6pF1/zjyIn4dn8+J1YjQMB
         YrTDnKSGQkvmraXxKJ6WfSxgABqdrwvJLLSxZKFc4bOuIbZLsC+7VbvnwN0dhc5VgA8O
         X/B8HugSgszqD/Id/T4L1nlB0V7MUmorYjCu57NTsoycqmJePoJED852KMAGoH4B9G7x
         AszHulURpntF6Fs5uafyEIFgxLHLdCKoVQJ3NSi+0kO4R/BBnaHvVjLDWSyKhPXoJCmD
         fRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6DC30ra67XbimQ0DPoAW+D9lHfkQCC2g+rgI/z0QNHM=;
        b=s2JffWXAK9GB/KuusmOyP4LykpYlwslMIT5xrvAomqhbbY6k6zl0ja7hFKYWY6VqlW
         U/Bm+wn8dquABh5XAkr6Ou2GIFf6q9rz3yZJ0xvmus2yj4i90mMqT+oeSDdaTC+FX40O
         7mibsdMZK10KLjrc7VqhA1B4eYwvjJKpvAZmm1sHH9v9FlbWBVNLTphaIPIaytCYamDH
         Qqd/thee82K2/Hy8PgE0ZyR/YBY0VLPm+ZbyleZ1i7McdRpymoTYQlKqXkVPI1NlbRN0
         JJHIfTnyVnTdQ1YRgB+9c1q+bO22O/z3VdIo3MU54VxBitSMhwnMNOG5FWsiH+b3/qQz
         nykA==
X-Gm-Message-State: ANoB5pnMrWuFs/4oldFAchHsA/MBW5pWBjczyJjHIJ50Uymu6UHj7CSo
        DvmBW5JZb9bDZt4t8635kT5gLs39u0bAwcVdsZLAdma6GTzASA==
X-Google-Smtp-Source: AA0mqf7OXDRBb0RQNP0Alc5TqIwHvZAArQDKI7dY8JCWviTOMDXwEOM0P9W6SH9e6DGU3L6vHTY4NiNuPTamBW1YHQQ=
X-Received: by 2002:ac2:5f76:0:b0:4af:7f16:e1c4 with SMTP id
 c22-20020ac25f76000000b004af7f16e1c4mr24901596lfc.351.1669946597502; Thu, 01
 Dec 2022 18:03:17 -0800 (PST)
MIME-Version: 1.0
References: <20221129200653.962019-1-lixiaoyan@google.com> <20221129200653.962019-2-lixiaoyan@google.com>
 <CACKFLi=qu7KBNPAST0fffxu1TC7-PAX2QzMM6b-1C0X5OCNFqQ@mail.gmail.com>
In-Reply-To: <CACKFLi=qu7KBNPAST0fffxu1TC7-PAX2QzMM6b-1C0X5OCNFqQ@mail.gmail.com>
From:   Coco Li <lixiaoyan@google.com>
Date:   Thu, 1 Dec 2022 18:03:06 -0800
Message-ID: <CADjXwjgJtXQx14h4_aSYiEHgZjGsYVGEs+LKm13BkweZFAtUUQ@mail.gmail.com>
Subject: Re: [RFC net-next v3 2/2] bnxt: Use generic HBH removal helper in tx path
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-16.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 12:42 PM Michael Chan <michael.chan@broadcom.com> wrote:
>
> On Tue, Nov 29, 2022 at 12:07 PM Coco Li <lixiaoyan@google.com> wrote:
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > index 0fe164b42c5d..f144a5ef2e04 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > @@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >                         return NETDEV_TX_BUSY;
> >         }
> >
> > +       if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> > +               goto tx_free;
> > +
> >         length = skb->len;
> >         len = skb_headlen(skb);
> >         last_frag = skb_shinfo(skb)->nr_frags;
> > @@ -11342,9 +11345,15 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
> >
> >                 if (hdrlen > 64)
> >                         return false;
> > +
> > +               /* The ext header may be a hop-by-hop header inserted for
> > +                * big TCP purposes. This will be removed before sending
> > +                * from NIC, so do not count it.
> > +                */
> > +               if (!(*nexthdr == NEXTHDR_HOP && ipv6_has_hopopt_jumbo(skb)))
>
> To be more efficient, why not just check the header's tlv_type here
> instead of calling ipv6_has_hopopt_jumbo()?
>

It may be possible that the next header is Hop_by_hop but the packet
is not tcp, meaning that it would not be removed and we'd still want
to count this header towards the limit.
ipv6_has_hopopt_jumbo checks for the big tcp case (gso, skb len
reaches a certain size) particularly.

> > +                       hdr_count++;
> >                 nexthdr = &hp->nexthdr;
> >                 start += hdrlen;
> > -               hdr_count++;
> >         }
> >         if (nextp) {
> >                 /* Caller will check inner protocol */
> > @@ -13657,6 +13666,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >                 dev->features &= ~NETIF_F_LRO;
> >         dev->priv_flags |= IFF_UNICAST_FLT;
> >
> > +       netif_set_tso_max_size(dev, GSO_MAX_SIZE);
> > +
> >  #ifdef CONFIG_BNXT_SRIOV
> >         init_waitqueue_head(&bp->sriov_cfg_wait);
> >  #endif
> > --
> > 2.38.1.584.g0f3c55d4c2-goog
> >
