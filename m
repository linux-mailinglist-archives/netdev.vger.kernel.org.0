Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEFC622625
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiKIJDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiKIJDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:03:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00D52180C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667984575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OGker5EOPTIasCJQNRDUDLX6sX07htTB/k+i6ev/GdE=;
        b=H25H9VHVbj/qSKtjUJKkiw5FDbjbKSn+4788yMsZiOUCttY9uIYP5T2spJtfhIRXr1hwsU
        SU8la6Q+DPX6+WMwdJyjCjVvRQfBFl+cQriNNj1mRzeoIkfBjJRyiNPAqpteLmpnUctgQ9
        qSEWb5APYzDvEhA33n7PeuLTz3rsmwU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-376-C74qoj6xMKq5ids57M9zqQ-1; Wed, 09 Nov 2022 04:02:54 -0500
X-MC-Unique: C74qoj6xMKq5ids57M9zqQ-1
Received: by mail-qt1-f199.google.com with SMTP id cm12-20020a05622a250c00b003a521f66e8eso12100154qtb.17
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 01:02:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OGker5EOPTIasCJQNRDUDLX6sX07htTB/k+i6ev/GdE=;
        b=fUHQDjvw5+LwhszkngoZEZ/UlC7zkpf67hOlYx0ii5dr8kd3aqrZPcwrPtFWi3qctj
         WR6NRrw1oF/PNydOjxZrapenXYDR1d75vy4XAkYNU2m5FDrQS6xvpnR55lRgKYiByYwZ
         XZA+8ReJBXuVpWCM71f0tpHexRtaZsI2FUJDIAP4fBmAsdOEa2DxjBbW395b/mQ9N9Bo
         6HIbsczAbrdKhJaqjFR58vRooyn8a5LOO1hwMLdDJbFs69rFRuC8tLa07I0BcwwyyRlR
         4jKF7D0ACkNQygwhvlhBSR/BTg9lwaDWR437qIHb1n+Ag3iF8MDyELzuC+QWG0lfkOuq
         Kteg==
X-Gm-Message-State: ACrzQf0How6/MHt2815PRbk69CWUOGyOvYu1lxX9F1DTV3PFkDm5f37k
        VegFrWBr89HW3FsAWkCV8tx7DVQepMxyHfnjVSpYILQAxfVkAp9WK/Tkqm4mik0Jj3R26SuS1N8
        zMds83NT/v6KIIqkv
X-Received: by 2002:a05:622a:4ccc:b0:3a5:4070:1f7e with SMTP id fa12-20020a05622a4ccc00b003a540701f7emr32996010qtb.472.1667984573909;
        Wed, 09 Nov 2022 01:02:53 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6r3zDrrUt39YsV4YdbiGcl2WYJkspXzfvz7zA8vh1ts3eYC2qiAWragH4kMy+er7GhxwF9Tg==
X-Received: by 2002:a05:622a:4ccc:b0:3a5:4070:1f7e with SMTP id fa12-20020a05622a4ccc00b003a540701f7emr32995978qtb.472.1667984573441;
        Wed, 09 Nov 2022 01:02:53 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-112-224.dyn.eolo.it. [146.241.112.224])
        by smtp.gmail.com with ESMTPSA id g10-20020a05620a40ca00b006f3e6933bacsm11012084qko.113.2022.11.09.01.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 01:02:52 -0800 (PST)
Message-ID: <824f56a316b96aaa0cc52c301429a3438486b691.camel@redhat.com>
Subject: Re: [PATCH v1 net-next 6/6] udp: Introduce optional per-netns hash
 table.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, netdev@vger.kernel.org
Date:   Wed, 09 Nov 2022 10:02:49 +0100
In-Reply-To: <20221107184129.11491-1-kuniyu@amazon.com>
References: <77aa882a0ac72cf434ecb44590f83ab9ece3b2f8.camel@redhat.com>
         <20221107184129.11491-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-11-07 at 10:41 -0800, Kuniyuki Iwashima wrote:
> From:   Paolo Abeni <pabeni@redhat.com>
> Date:   Mon, 07 Nov 2022 11:03:38 +0100
> > On Fri, 2022-11-04 at 12:06 -0700, Kuniyuki Iwashima wrote:
> > > The maximum hash table size is 64K due to the nature of the protocol. [0]
> > > It's smaller than TCP, and fewer sockets can cause a performance drop.
> > > 
> > > On an EC2 c5.24xlarge instance (192 GiB memory), after running iperf3 in
> > > different netns, creating 32Mi sockets without data transfer in the root
> > > netns causes regression for the iperf3's connection.
> > > 
> > >   uhash_entries		sockets		length		Gbps
> > > 	    64K		      1		     1		5.69
> > > 			    1Mi		    16		5.27
> > > 			    2Mi		    32		4.90
> > > 			    4Mi		    64		4.09
> > > 			    8Mi		   128		2.96
> > > 			   16Mi		   256		2.06
> > > 			   32Mi		   512		1.12
> > > 
> > > The per-netns hash table breaks the lengthy lists into shorter ones.  It is
> > > useful on a multi-tenant system with thousands of netns.  With smaller hash
> > > tables, we can look up sockets faster, isolate noisy neighbours, and reduce
> > > lock contention.
> > > 
> > > The max size of the per-netns table is 64K as well.  This is because the
> > > possible hash range by udp_hashfn() always fits in 64K within the same
> > > netns and we cannot make full use of the whole buckets larger than 64K.
> > > 
> > >   /* 0 < num < 64K  ->  X < hash < X + 64K */
> > >   (num + net_hash_mix(net)) & mask;
> > > 
> > > The sysctl usage is the same with TCP:
> > > 
> > >   $ dmesg | cut -d ' ' -f 6- | grep "UDP hash"
> > >   UDP hash table entries: 65536 (order: 9, 2097152 bytes, vmalloc)
> > > 
> > >   # sysctl net.ipv4.udp_hash_entries
> > >   net.ipv4.udp_hash_entries = 65536  # can be changed by uhash_entries
> > > 
> > >   # sysctl net.ipv4.udp_child_hash_entries
> > >   net.ipv4.udp_child_hash_entries = 0  # disabled by default
> > > 
> > >   # ip netns add test1
> > >   # ip netns exec test1 sysctl net.ipv4.udp_hash_entries
> > >   net.ipv4.udp_hash_entries = -65536  # share the global table
> > > 
> > >   # sysctl -w net.ipv4.udp_child_hash_entries=100
> > >   net.ipv4.udp_child_hash_entries = 100
> > > 
> > >   # ip netns add test2
> > >   # ip netns exec test2 sysctl net.ipv4.udp_hash_entries
> > >   net.ipv4.udp_hash_entries = 128  # own a per-netns table with 2^n buckets
> > > 
> > > We could optimise the hash table lookup/iteration further by removing
> > > the netns comparison for the per-netns one in the future.  Also, we
> > > could optimise the sparse udp_hslot layout by putting it in udp_table.
> > > 
> > > [0]: https://lore.kernel.org/netdev/4ACC2815.7010101@gmail.com/
> > > 
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > >  Documentation/networking/ip-sysctl.rst |  27 ++++++
> > >  include/linux/udp.h                    |   2 +
> > >  include/net/netns/ipv4.h               |   2 +
> > >  net/ipv4/sysctl_net_ipv4.c             |  38 ++++++++
> > >  net/ipv4/udp.c                         | 119 ++++++++++++++++++++++---
> > >  5 files changed, 178 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > > index 815efc89ad73..ea788ef4def0 100644
> > > --- a/Documentation/networking/ip-sysctl.rst
> > > +++ b/Documentation/networking/ip-sysctl.rst
> > > @@ -1177,6 +1177,33 @@ udp_rmem_min - INTEGER
> > >  udp_wmem_min - INTEGER
> > >  	UDP does not have tx memory accounting and this tunable has no effect.
> > >  
> > > +udp_hash_entries - INTEGER
> > > +	Show the number of hash buckets for UDP sockets in the current
> > > +	networking namespace.
> > > +
> > > +	A negative value means the networking namespace does not own its
> > > +	hash buckets and shares the initial networking namespace's one.
> > > +
> > > +udp_child_ehash_entries - INTEGER
> > > +	Control the number of hash buckets for UDP sockets in the child
> > > +	networking namespace, which must be set before clone() or unshare().
> > > +
> > > +	If the value is not 0, the kernel uses a value rounded up to 2^n
> > > +	as the actual hash bucket size.  0 is a special value, meaning
> > > +	the child networking namespace will share the initial networking
> > > +	namespace's hash buckets.
> > > +
> > > +	Note that the child will use the global one in case the kernel
> > > +	fails to allocate enough memory.  In addition, the global hash
> > > +	buckets are spread over available NUMA nodes, but the allocation
> > > +	of the child hash table depends on the current process's NUMA
> > > +	policy, which could result in performance differences.
> > > +
> > > +	Possible values: 0, 2^n (n: 0 - 16 (64K))
> > 
> > If you constraint the non-zero minum size to UDP_HTABLE_SIZE_MIN - not
> > sure if that makes sense - than you could avoid dynamically allocating
> > the bitmap in udp_lib_get_port(). 
> 
> Yes, but 256 didn't match for our case.  Also, I was thinking like
> this not to affect the global table case.  Which do you prefer ?
> 
> uncompiled code:
> 
> unsigned long *udp_get_bitmap(struct udp_table *udptable,
> 			      unsigned long *bitmap_stack)
> {
> 	unsigned long *bitmap;
> 
> 	if (udptable == &udp_table)
> 		return bitmap_stack;
> 
> 	/* UDP_HTABLE_SIZE_MIN */
> 	if (udptable->log >= 8)
> 		return bitmap_stack;
> 
> 	bitmap = bitmap_alloc(udp_bitmap_size(udptable));
> 	if (!bitmap)
> 		return bitmap_stack;
> 
> 	return bitmap;
> }
> 
> void udp_free_bitmap(unsigned long *bitmap,
> 		     unsigned long *bitmap_stack)
> {
> 	if (bitmap != bitmap_stack)
> 		bitmap_free(bitmap);
> }

I'm sorry for the latency. The thing that makes me feel not so
comfortable is the new allocation required in udp_lib_get_port().

The above will avoid such allocation for the common case, but not for
every caller.

What about adding a 'unsigned long *bitmap' field to udp_table, setting
it to the global bitmap for the main table, and allocating enough
storage to include even the bitmap when allocating the per netns
udp_table? e.g.

L1_CACHE_ALIGN(hash_entries * 2 * sizeof(struct udp_hslot)) *
BITS_TO_LONGS(udp_bitmap_size(udptable))

WDYT?

thanks!

Paolo

