Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CE1648CFE
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLJDxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLJDxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:53:19 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB3112085
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 19:53:18 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id x11so6862679ljh.7
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 19:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RDv4NbsPAYs3WKpRNnfyHzyOTn53LRoGs77iSY7uqyE=;
        b=GnFcUoF0xhVZqBs4jqSZsM4qyT8+w6K5+jIDnA0cERsIOKSb5yzvON7E9pMJKhYBqI
         QZ5wT2ntBy6Mr3b3+GY47Ar8pLjit+RdbYeQGZjGvcmBB57YUAOuv+0bpkVVG2biElhk
         /eHvwwU6BRP79HJKX6GpPLjrruw60b863FZnRfHLVrraVDNUauIlhrTKoE5YgAZKS+j2
         u/Ij4wUAaofMBlBiE0IsdTN0AP50zQdrHKEPkEBMCxTGvqXAeHHEgeq4rBh3VFY79Gdx
         FIpdkgP6A1CKVb7pwylH3YuxEVL8BUinqK/Kp9+ulButaYBwGrokQ8k6BsAGmgiIuMtk
         Gwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RDv4NbsPAYs3WKpRNnfyHzyOTn53LRoGs77iSY7uqyE=;
        b=RETqZ6YMHDENVKZTlkgZpvi7VaEGke40I/4e9kVQTfe1n89mLCcDKA0N5/042uLP49
         BVYminI31o/nzPCbxUrcP9cI4yS2ptvE4PjaFd6P6c9bqn9x0uX4Cj1wOhfcIUxpsqHo
         +bmpvoAYkteloYvi3ivibfAW/Vu0UbCyhGNohzwf1i51WAKRwEh0JtGl/0AaDn1K8wkW
         sgwne9n5/rkEZzZ96C1U2M2EPbD1b5E3QltqqqrHtnzW1t0WG/jtHkEQKyEUlgGMCTK9
         2hsM60gXQ3NX6oNvxOwauZNCGp16SunR+hUxYKbekhLMCf8f5f6F6SPpgDsUyqJTkhTO
         7u8w==
X-Gm-Message-State: ANoB5plLEX9se4U/dqN782549g5G+Oe+WfZ45BCoeHY0kOoIc4FEjizd
        3HSk3SZz+OC/lMXx8EYeuL2xQxIKWELUoKkg8I9nMA==
X-Google-Smtp-Source: AA0mqf4EtRKxKDGmET7yKxaCD2fZeNFEoZOBuc5UR05LsviY9qdHGI9xZcXhXdA2P3LySKF/h7ACvTXSXrWy3670Jnc=
X-Received: by 2002:a05:651c:1681:b0:279:f29b:3dfc with SMTP id
 bd1-20020a05651c168100b00279f29b3dfcmr6533243ljb.470.1670644396550; Fri, 09
 Dec 2022 19:53:16 -0800 (PST)
MIME-Version: 1.0
References: <20221207225435.1273226-1-lixiaoyan@google.com>
 <20221207225435.1273226-2-lixiaoyan@google.com> <Y5EwunX89Nq59vf0@x130>
In-Reply-To: <Y5EwunX89Nq59vf0@x130>
From:   Coco Li <lixiaoyan@google.com>
Date:   Fri, 9 Dec 2022 19:53:05 -0800
Message-ID: <CADjXwjg8iVQuviKNwf9b2aKeD3SQcUhd4o1O4XL6ncc87wcjkA@mail.gmail.com>
Subject: Re: [RFC net-next v5 2/2] bnxt: Use generic HBH removal helper in tx path
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I agree that this function isn't efficient for drivers who already
copy headers, which can just copy over the needed parts of the header
as you mentioned. However, for drivers that need HBH header removed in
place, it would be a nice function to have (and it reduces code
duplication, see function be reused for GSO path).

On Wed, Dec 7, 2022 at 4:33 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
>
> On 07 Dec 14:54, Coco Li wrote:
> >Eric Dumazet implemented Big TCP that allowed bigger TSO/GRO packet sizes
> >for IPv6 traffic. See patch series:
> >'commit 89527be8d8d6 ("net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes")'
> >
> >This reduces the number of packets traversing the networking stack and
> >should usually improves performance. However, it also inserts a
> >temporary Hop-by-hop IPv6 extension header.
> >
> >Using the HBH header removal method in the previous path, the extra header
>                                                       ^ patch
> >be removed in bnxt drivers to allow it to send big TCP packets (bigger
> >TSO packets) as well.
> >
>
> I think Eric didn't expose this function because it isn't efficient for
> drivers who are already processing the headers separately from payload for
> LSO packets .. the trick is to have an optimized copy method depending on
> your driver xmit function, usually you would just memcpy the TCP header over
> the HBH exactly at the point you copy/process those headers into the HW
> descriptor.
>
> >Tested:
> >Compiled locally
> >
> >To further test functional correctness, update the GSO/GRO limit on the
> >physical NIC:
> >
> >ip link set eth0 gso_max_size 181000
> >ip link set eth0 gro_max_size 181000
> >
> >Note that if there are bonding or ipvan devices on top of the physical
> >NIC, their GSO sizes need to be updated as well.
> >
> >Then, IPv6/TCP packets with sizes larger than 64k can be observed.
> >
> >Big TCP functionality is tested by Michael, feature checks not yet.
> >
> >Tested by Michael:
> >I've confirmed with our hardware team that this is supported by our
> >chips, and I've tested it up to gso_max_size of 524280.  Thanks.
> >
> >Tested-by: Michael Chan <michael.chan@broadcom.com>
> >Reviewed-by: Michael Chan <michael.chan@broadcom.com>
> >Signed-off-by: Coco Li <lixiaoyan@google.com>
> >---
> > drivers/net/ethernet/broadcom/bnxt/bnxt.c | 26 ++++++++++++++++++++++-
> > 1 file changed, 25 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> >index 0fe164b42c5d..6ba1cd342a80 100644
> >--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> >+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> >@@ -389,6 +389,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >                       return NETDEV_TX_BUSY;
> >       }
> >
> >+      if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> >+              goto tx_free;
> >+
> >       length = skb->len;
> >       len = skb_headlen(skb);
> >       last_frag = skb_shinfo(skb)->nr_frags;
> >@@ -11315,6 +11318,7 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
> >                             u8 **nextp)
> > {
> >       struct ipv6hdr *ip6h = (struct ipv6hdr *)(skb->data + nw_off);
> >+      struct hop_jumbo_hdr *jhdr;
> >       int hdr_count = 0;
> >       u8 *nexthdr;
> >       int start;
> >@@ -11342,9 +11346,27 @@ static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
> >
> >               if (hdrlen > 64)
> >                       return false;
> >+
> >+              /* The ext header may be a hop-by-hop header inserted for
> >+               * big TCP purposes. This will be removed before sending
> >+               * from NIC, so do not count it.
> >+               */
> >+              if (*nexthdr == NEXTHDR_HOP) {
> >+                      if (likely(skb->len <= GRO_LEGACY_MAX_SIZE))
> >+                              goto increment_hdr;
> >+
> >+                      jhdr = (struct hop_jumbo_hdr *)nexthdr;
> >+                      if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0 ||
> >+                          jhdr->nexthdr != IPPROTO_TCP)
> >+                              goto increment_hdr;
> >+
> >+                      goto next_hdr;
> >+              }
> >+increment_hdr:
> >+              hdr_count++;
> >+next_hdr:
> >               nexthdr = &hp->nexthdr;
> >               start += hdrlen;
> >-              hdr_count++;
> >       }
> >       if (nextp) {
> >               /* Caller will check inner protocol */
> >@@ -13657,6 +13679,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >               dev->features &= ~NETIF_F_LRO;
> >       dev->priv_flags |= IFF_UNICAST_FLT;
> >
> >+      netif_set_tso_max_size(dev, GSO_MAX_SIZE);
> >+
> > #ifdef CONFIG_BNXT_SRIOV
> >       init_waitqueue_head(&bp->sriov_cfg_wait);
> > #endif
> >--
> >2.39.0.rc0.267.gcb52ba06e7-goog
> >
