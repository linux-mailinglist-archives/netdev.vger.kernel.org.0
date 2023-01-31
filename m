Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A7668345D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjAaRzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjAaRzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:55:45 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326F713524
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:55:29 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-4a263c4ddbaso214527917b3.0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1syj8d33yfasYg+g/xpFl3jgX3utKwdVmBd7EXfxa3o=;
        b=MwkJ5mfLVrJmE2lAtGb7PW+JtIKsGsDcwbJIylFbpvv3uT5skZA92CBIOp8orgC8cK
         Gbgs0T2O876v009lcgeBBTt9Cf3sPdaPWKmWvL8hGciR2c/lwo38X5qmbyYuzOwwYymj
         8t6urWOH+YyeDZG83wSgHqgHx0ZekR6VICFgUOBI/AILqEjRDvUyXwojHNhsXzMKB/sz
         vwwK0Y0iYg2oGAdCiJtB1Dy/wE9Ux9LW4HtHSSvUBkCpr0UwESKNLYI94Xf+45wakRhX
         cqmvu23cW/FNhwbQIcwsiP8uNI8AHOchRAq3HxXxz1irIn6sFY7j0ms9qPL+o1FMZBSA
         Wd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1syj8d33yfasYg+g/xpFl3jgX3utKwdVmBd7EXfxa3o=;
        b=SIaLFaWk2mvgQTFlTJIrVfcVPRS2CJmJKstCPchgmle2MExFwMm572BK7EkJsg792j
         GG4JElGFBAZMSV0kA4wjftTLfJry0OqoWE8ndE4J2iAnPhHkHMnDV8ZTrNfY/Xp6FgcL
         /tCkdWcmOKY7TVqtP9nhasJ8K+EaNZh2tzpKNe7legj607EB0ELIDU/CE/xPUIrOV5z7
         OYBpphNt0zBcX0xJgT8EOm1sCzdxz9HgrgIOKpTLjAznpPj3iauPU3ysofqUKUKsuPyp
         CT2hQLMwx6B5ulCFw8QdE2iegQvROv87H9ZaQ4kUgPXeXi1gy1t+ptOsjc/P0s9sA7ew
         Z5iA==
X-Gm-Message-State: AO0yUKURWUCvMQLGzgHaAhoK/c1W3ffGPRpg8LiQZrsDtCUNzVdz02xc
        B3Ezad3RCH6l+Lh5me2CkTVtK47UbbzQw2O70PY=
X-Google-Smtp-Source: AK7set9U9naKvXLpp08zE2ervjkczgaoP1ebE2vUJ78Z6NjNiwPURHmHiUuw5cQw6hQmJQYOkpm1AvJJV1AOHlbGv5E=
X-Received: by 2002:a0d:d70b:0:b0:506:466c:480c with SMTP id
 z11-20020a0dd70b000000b00506466c480cmr3755323ywd.253.1675187728277; Tue, 31
 Jan 2023 09:55:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674921359.git.lucien.xin@gmail.com> <7e1f733cc96c7f7658fbf3276a90281b2f37acd1.1674921359.git.lucien.xin@gmail.com>
 <0601c53b3dc178293e05d87f75f481367ff4fd47.camel@redhat.com>
In-Reply-To: <0601c53b3dc178293e05d87f75f481367ff4fd47.camel@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 31 Jan 2023 12:55:10 -0500
Message-ID: <CADvbK_fXGCEwuHX5PCU1-+dTTG4ZMLGLXY8A_AqJpDoR2uV-cA@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 09/10] net: add gso_ipv4_max_size and
 gro_ipv4_max_size per device
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 9:59 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Sat, 2023-01-28 at 10:58 -0500, Xin Long wrote:
> > This patch introduces gso_ipv4_max_size and gro_ipv4_max_size
> > per device and adds netlink attributes for them, so that IPV4
> > BIG TCP can be guarded by a separate tunable in the next patch.
> >
> > To not break the old application using "gso/gro_max_size" for
> > IPv4 GSO packets, this patch updates "gso/gro_ipv4_max_size"
> > in netif_set_gso/gro_max_size() if the new size isn't greater
> > than GSO_LEGACY_MAX_SIZE, so that nothing will change even if
> > userspace doesn't realize the new netlink attributes.
>
> Not a big deal, but I think it would be nice to include the pahole info
> showing where the new fields are located and why that are good
> locations.
>
> No need to send a new version for just for the above, unless Eric asks
> otherwise ;)
>
The the pahole info without and with the patch shows below:

- Without the Patch:

# pahole --hex -C net_device vmlinux
struct net_device {
...
long unsigned int          gro_flush_timeout;    /* 0x330   0x8 */
int                        napi_defer_hard_irqs; /* 0x338   0x4 */
unsigned int               gro_max_size;         /* 0x33c   0x4 */  <---------
/* --- cacheline 13 boundary (832 bytes) --- */
rx_handler_func_t *        rx_handler;           /* 0x340   0x8 */
void *                     rx_handler_data;      /* 0x348   0x8 */
struct mini_Qdisc *        miniq_ingress;        /* 0x350   0x8 */
struct netdev_queue *      ingress_queue;        /* 0x358   0x8 */
struct nf_hook_entries *   nf_hooks_ingress;     /* 0x360   0x8 */
unsigned char              broadcast[32];        /* 0x368  0x20 */
/* --- cacheline 14 boundary (896 bytes) was 8 bytes ago --- */
struct cpu_rmap *          rx_cpu_rmap;          /* 0x388   0x8 */
struct hlist_node          index_hlist;          /* 0x390  0x10 */

/* XXX 32 bytes hole, try to pack */

/* --- cacheline 15 boundary (960 bytes) --- */
struct netdev_queue *      _tx __attribute__((__aligned__(64))); /*
0x3c0   0x8 */
...

/* --- cacheline 32 boundary (2048 bytes) was 24 bytes ago --- */
const struct attribute_group  * sysfs_groups[4]; /* 0x818  0x20 */
const struct attribute_group  * sysfs_rx_queue_group; /* 0x838   0x8 */
/* --- cacheline 33 boundary (2112 bytes) --- */
const struct rtnl_link_ops  * rtnl_link_ops;     /* 0x840   0x8 */
unsigned int               gso_max_size;         /* 0x848   0x4 */
unsigned int               tso_max_size;         /* 0x84c   0x4 */
u16                        gso_max_segs;         /* 0x850   0x2 */
u16                        tso_max_segs;         /* 0x852   0x2 */   <---------

/* XXX 4 bytes hole, try to pack */

const struct dcbnl_rtnl_ops  * dcbnl_ops;        /* 0x858   0x8 */
s16                        num_tc;               /* 0x860   0x2 */
struct netdev_tc_txq       tc_to_txq[16];        /* 0x862  0x40 */
/* --- cacheline 34 boundary (2176 bytes) was 34 bytes ago --- */
u8                         prio_tc_map[16];      /* 0x8a2  0x10 */
...
}


- With the Patch:

For "gso_ipv4_max_size", it filled the hole as expected.

/* --- cacheline 33 boundary (2112 bytes) --- */
const struct rtnl_link_ops  * rtnl_link_ops;     /* 0x840   0x8 */
unsigned int               gso_max_size;         /* 0x848   0x4 */
unsigned int               tso_max_size;         /* 0x84c   0x4 */
u16                        gso_max_segs;         /* 0x850   0x2 */
u16                        tso_max_segs;         /* 0x852   0x2 */
unsigned int               gso_ipv4_max_size;    /* 0x854   0x4 */ <-------
const struct dcbnl_rtnl_ops  * dcbnl_ops;        /* 0x858   0x8 */
s16                        num_tc;               /* 0x860   0x2 */
struct netdev_tc_txq       tc_to_txq[16];        /* 0x862  0x40 */
/* --- cacheline 34 boundary (2176 bytes) was 34 bytes ago --- */
u8                         prio_tc_map[16];      /* 0x8a2  0x10 */


For "gro_ipv4_max_size", these are no byte holes, I just put it
in the "Cache lines mostly used on receive path" area, and
next to gro_max_size.

long unsigned int          gro_flush_timeout;    /* 0x330   0x8 */
int                        napi_defer_hard_irqs; /* 0x338   0x4 */
unsigned int               gro_max_size;         /* 0x33c   0x4 */
/* --- cacheline 13 boundary (832 bytes) --- */
unsigned int               gro_ipv4_max_size;    /* 0x340   0x4 */  <------

/* XXX 4 bytes hole, try to pack */

rx_handler_func_t *        rx_handler;           /* 0x348   0x8 */
void *                     rx_handler_data;      /* 0x350   0x8 */
struct mini_Qdisc *        miniq_ingress;        /* 0x358   0x8 */
struct netdev_queue *      ingress_queue;        /* 0x360   0x8 */
struct nf_hook_entries *   nf_hooks_ingress;     /* 0x368   0x8 */
unsigned char              broadcast[32];        /* 0x370  0x20 */
/* --- cacheline 14 boundary (896 bytes) was 16 bytes ago --- */
struct cpu_rmap *          rx_cpu_rmap;          /* 0x390   0x8 */
struct hlist_node          index_hlist;          /* 0x398  0x10 */

/* XXX 24 bytes hole, try to pack */

/* --- cacheline 15 boundary (960 bytes) --- */
struct netdev_queue *      _tx __attribute__((__aligned__(64))); /*
0x3c0   0x8 */


Thanks.
