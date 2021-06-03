Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB16739B26E
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhFDGP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:15:59 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:34598 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhFDGP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:15:58 -0400
Received: by mail-pj1-f49.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso4611120pjx.1
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 23:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZFq/Jx8eq2XHYdInL8xNuEXcDvyZYc0KlxFds2uevnw=;
        b=mMZN905DqTnWBLQw0weNX+/+kdGl59OKvH5pb+suVz/IwiOuON+VG2gEC60TK6pIDB
         rDD6EBTuu4Yh7+xqqKC2x5eT7qpQg5ubhWFrospx3jxl44a+aLsAki3pnrkj70VvOw6y
         hN+yBNWwNjtW5pVza0+jBpLDnFrMtDYuAz4JzpCJr57vXIXShI1UnjGQcfYoFT24v4uq
         OLhEYUbqdK1btxjN74LJs7CncZ2SjI1NKoYbPPZjwiVnKEm+TShYdcLjoB4QfXlo6XTu
         QTZpWC2viPv5WDkesVCiIUtG+70SXX/YnCQjzDDhpe36OPgUahSLtmuJtaHwcEAf+EBv
         Oqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZFq/Jx8eq2XHYdInL8xNuEXcDvyZYc0KlxFds2uevnw=;
        b=nBjZXP55vTIWn8/DxqMJj7NL8LcTx8Qoa6iDmz1vbZ1rJKWshbrLB8E5+uWKB/GbDo
         DcQ7WvRrU7TR1gFoOx+wPscLcgYAQimNGc5UsahPptea5yI+oE6vHqAWP2oRX9arRC2F
         1zWqdG9Ab+d/uCjApZglxzWkg7rABNHd3cFdnh2PqOI5Lsgx9T360lhYS0btpmL4Wcqr
         RV5mPf4fumnEbl+WPf8VIdwwmUQkRZtIqbQzpZhdbQWlYi9XdygI2xw8v1JUS+Wxmjx9
         U501F1T5FEtm1a0rNPDooqnSiZTHkUoxUaRTPen2IH8xoBhFgsJEke32+lU2sVdB1dc3
         BJ9Q==
X-Gm-Message-State: AOAM530Rwjy9xCAO8HYREtJtWfLZ7uLkrUAZZoqsYDlD/cxaJXuOgMT6
        5SldQ/WXWWxF8jKIUiiN1yKeaA==
X-Google-Smtp-Source: ABdhPJxjoCQlzRfRJxvFjY+rSLTzLyvwEr/fZYv88Sw1BPL7nQ1CVh/z0VekvAv17M001vqauLgTqw==
X-Received: by 2002:a17:902:c613:b029:107:ce4:f7b9 with SMTP id r19-20020a170902c613b02901070ce4f7b9mr2892201plr.11.1622787184946;
        Thu, 03 Jun 2021 23:13:04 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id g22sm782938pfv.123.2021.06.03.23.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:13:03 -0700 (PDT)
Date:   Thu, 3 Jun 2021 12:46:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
Subject: Re: Strange TCP behaviour when appending data to a packet from
 netfilter
Message-ID: <20210603124601.1c260b56@hermes.local>
In-Reply-To: <CALrw=nEd=nB2X8HhR2yoiPemmdmqhhUZf+u8ij0mZKDm0+TK6g@mail.gmail.com>
References: <CALrw=nEd=nB2X8HhR2yoiPemmdmqhhUZf+u8ij0mZKDm0+TK6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Jun 2021 20:38:16 +0100
Ignat Korchagin <ignat@cloudflare.com> wrote:

> Hi,
> 
> I was experimenting with a netfilter module (originally nftables
> module) which appends a fixed byte string to outgoing IP packets and
> removes it from incoming IP packets. In its simplest form the full
> module code is below:
> 
> #include <linux/module.h>
> #include <linux/netfilter.h>
> #include <linux/netfilter_ipv4.h>
> #include <net/ip.h>
> 
> #define TRAILER_LEN 16
> #define TRAILER_VAL 0xfe
> 
> static u8 trailer_pattern[TRAILER_LEN];
> 
> static void adust_net_hdr(struct sk_buff *skb, bool out)
> {
>     ip_hdr(skb)->tot_len = htons(ntohs(ip_hdr(skb)->tot_len) + (out ?
> TRAILER_LEN : -TRAILER_LEN));
>     ip_send_check(ip_hdr(skb));
> }
> 
> static unsigned int nf_crypt_trailer(void *priv, struct sk_buff *skb,
> const struct nf_hook_state *state)
> {
>     if (state->hook == NF_INET_LOCAL_OUT) {
>         struct sk_buff *trailer;
>         int num_frags = skb_cow_data(skb, TRAILER_LEN, &trailer);
>         if (num_frags < 0) {
>             pr_err("skb_cow_data failed for NF_INET_LOCAL_OUT");
>             return NF_DROP;
>         }
>         memset(pskb_put(skb, trailer, TRAILER_LEN), TRAILER_VAL, TRAILER_LEN);
>     }
> 
>     if (state->hook == NF_INET_LOCAL_IN) {
>         u8 buf[TRAILER_LEN];
>         struct sk_buff *trailer;
>         int num_frags = skb_cow_data(skb, 0, &trailer);
>         if (num_frags < 0) {
>             pr_err("skb_cow_data failed for NF_INET_LOCAL_IN");
>             return NF_DROP;
>         }
> 
>         if (skb_copy_bits(skb, skb->len - TRAILER_LEN, buf, TRAILER_LEN))
>         {
>             pr_err("skb_copy_bits failed for NF_INET_LOCAL_IN");
>             return NF_DROP;
>         }
> 
>         if (memcmp(buf, trailer_pattern, TRAILER_LEN)) {
>             pr_err("trailer pattern not found in NF_INET_LOCAL_IN");
>             return NF_DROP;
>         }
> 
>         if (pskb_trim(skb, skb->len - TRAILER_LEN)) {
>             pr_err("pskb_trim failed\n");
>             return NF_DROP;
>         }
>     }
>     /* adjust IP checksum */
>     adust_net_hdr(skb, state->hook == NF_INET_LOCAL_OUT);
> 
>     return NF_ACCEPT;
> }
> 
> static const struct nf_hook_ops nf_crypt_ops[] = {
>     {
>         .hook        = nf_crypt_trailer,
>         .pf            = NFPROTO_IPV4,
>         .hooknum    = NF_INET_LOCAL_IN,
>         .priority    = NF_IP_PRI_RAW,
>     },
>     {
>         .hook       = nf_crypt_trailer,
>         .pf         = NFPROTO_IPV4,
>         .hooknum    = NF_INET_LOCAL_OUT,
>         .priority   = NF_IP_PRI_RAW,
>     },
> };
> 
> static int __net_init nf_crypt_net_init(struct net *net)
> {
>     /* do nothing in the init namespace */
>     if (net == &init_net)
>         return 0;
> 
>     return nf_register_net_hooks(net, nf_crypt_ops, ARRAY_SIZE(nf_crypt_ops));
> }
> 
> static void __net_exit nf_crypt_net_exit(struct net *net)
> {
>     /* do nothing in the init namespace */
>     if (net == &init_net)
>         return;
> 
>     nf_unregister_net_hooks(net, nf_crypt_ops, ARRAY_SIZE(nf_crypt_ops));
> }
> 
> static struct pernet_operations nf_crypt_net_ops = {
>     .init = nf_crypt_net_init,
>     .exit = nf_crypt_net_exit,
> };
> 
> static int __init nf_crypt_init(void)
> {
>     memset(trailer_pattern, TRAILER_VAL, TRAILER_LEN);
>     return register_pernet_subsys(&nf_crypt_net_ops);
> }
> 
> static void __exit nf_crypt_fini(void)
> {
>     unregister_pernet_subsys(&nf_crypt_net_ops);
> }
> 
> module_init(nf_crypt_init);
> module_exit(nf_crypt_fini);
> 
> MODULE_LICENSE("GPL");
> 
> Then I set up a test env using two Linux network namespaces:
> #!/bin/bash -e
> 
> sudo ip netns add alice
> sudo ip netns add bob
> 
> sudo ip -netns alice link add a0 type veth peer b0 netns bob
> 
> sudo ip -netns alice address add 192.168.13.5/24 dev a0
> sudo ip -netns bob address add 192.168.13.7/24 dev b0
> 
> sudo ip -netns alice link set lo up
> sudo ip -netns alice link set a0 up
> 
> sudo ip -netns bob link set lo up
> sudo ip -netns bob link set b0 up
> 
> All works except when I try to serve a large file over HTTP (aroung 5Gb):
> $ sudo ip netns exec bob python3 -m http.server
> and in another terminal
> $ sudo ip netns exec alice curl -o /dev/null http://192.168.13.7:8000/test.bin
> 
> The download starts, but the download speed almost immediately drops
> to 0 and "stalls".
> 
> I've explicitly added the pr_err messages for the module to notify me,
> if it drops packets for whatever reason, but it doesn't drop any
> packets.
> 
> Additionally, further debugging showed - if a TCP "ack" packet to
> "bob" gets processed on a kernel thread (and not in softirq), "# cat
> /proc/<pid>/stack" for the thread produces:
> 
> [<0>] wait_woken+0x1f4/0x250
> [<0>] sk_stream_wait_memory+0x3fb/0xde0
> [<0>] tcp_sendmsg_locked+0x94b/0x2e60
> [<0>] tcp_sendmsg+0x28/0x40
> [<0>] sock_sendmsg+0xdb/0x110
> [<0>] __sys_sendto+0x1a8/0x270
> [<0>] __x64_sys_sendto+0xdd/0x1b0
> [<0>] do_syscall_64+0x33/0x40
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> It seems the server-side sending buffer is full, so one would assume
> TCP acks from the client are somehow not getting processed, but I
> definitely see client TCP acks at least in the netfilter module. I've
> also tried to disable GSO on the veth interfaces as well as lower the
> MTU to no avail.
> 
> Additionally, if I reduce TRAILER_LEN to 0 (leaving the other
> skb_cow_data calls in place) - all start working.
> 
> Are there any hints why the above code causes this strange behaviour
> in TCP given that it seems I'm undoing everything on the incoming path
> I did for the outgoing path, so should be totally transparent to TCP?
> 
> Kind regards,
> Ignat

TCP segmentation offload doesn't know what you are doing
