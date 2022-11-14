Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71C2628AE4
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 21:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiKNU4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 15:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbiKNU4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 15:56:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E9063FC
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 12:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668459317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AxfcSGfg62gRB36XC6hsM1PN410oOGfLrkLUrZGNUXM=;
        b=BRrLqu5YGLwaLqHvg52ZrmsmXVRJYEXh/pXWKYe4XLRVXXrZSr/0Aw4tPvZVidDmQA5R5I
        WwX/gl53Asy4GLHzr9h8ouxkPufBFsQoSxZP3X/c9uq5u5Ao/2h18ch0UQkPSv7MKurgl1
        qztbjiHk2cBlY9Y06J+gREmkQjmWrAc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-2_7OQMklM0yUoftUVmXNJg-1; Mon, 14 Nov 2022 15:55:16 -0500
X-MC-Unique: 2_7OQMklM0yUoftUVmXNJg-1
Received: by mail-qt1-f200.google.com with SMTP id g3-20020ac84b63000000b003a529c62a92so8909146qts.23
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 12:55:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AxfcSGfg62gRB36XC6hsM1PN410oOGfLrkLUrZGNUXM=;
        b=hggSknnzq0cr0YNs1AU8+0HMCsHcIXyBjoeU2lLunARLUUItvYhGf51EEW06xX1IAs
         b5CmG88MeIzSQCvn2MWNlryNNoX4BpbPhUrB4haBZnJbqIhQJCmnrXKVwomSczzM08Ed
         KTzytBNXy9WcbXRDMvjcVsCNY4x+0sOMdq+WPE2J2iIBq4X9oIl/DF9BiAO60j594a+r
         DfPyLi/QjGSegqhXaSUQlddPOKrVhwsCZPtZk5xevEDLPXAlENiEThLVQ2hhNhrk1SFd
         C3DhO+ZwRIGkaUGG1Fot822uFR3diFjdxqXKs1TTmR72vU/R/jZpa9xKefiwv+yUtuoR
         gdmA==
X-Gm-Message-State: ANoB5pmn95JhGbSh9yVjRE8hNbbZ2vXkT6PbDKSdtExjoMuSSi/bkUM5
        iYCFFlsFvl/em26bbNvWf+A+Hky1DGrzNugVGHqwDOINdFOIH8MOwLybI7AlBWAxH+k9Rk8g1rI
        e4skvji/MnLjAXLCI
X-Received: by 2002:a05:622a:4107:b0:3a5:24ad:73d with SMTP id cc7-20020a05622a410700b003a524ad073dmr14018439qtb.167.1668459315598;
        Mon, 14 Nov 2022 12:55:15 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5U5eSij9NFkSY8mGZJ2bOW6x0lWuTBIfnymCeU84RUOwln10+u91SIrklQRjZbQoX+gbqN5w==
X-Received: by 2002:a05:622a:4107:b0:3a5:24ad:73d with SMTP id cc7-20020a05622a410700b003a524ad073dmr14018422qtb.167.1668459315318;
        Mon, 14 Nov 2022 12:55:15 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id o5-20020ac87c45000000b003a494b61e67sm6206427qtv.46.2022.11.14.12.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 12:55:14 -0800 (PST)
Message-ID: <84f835ca7aacb831561cb9fb49ad4e014bf2b1fd.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 6/6] udp: Introduce optional per-netns hash
 table.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuni1840@gmail.com, netdev@vger.kernel.org
Date:   Mon, 14 Nov 2022 21:55:11 +0100
In-Reply-To: <20221114202119.32011-1-kuniyu@amazon.com>
References: <33ccbd2770b069da8144aa1b94134f7d6464f4eb.camel@redhat.com>
         <20221114202119.32011-1-kuniyu@amazon.com>
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

On Mon, 2022-11-14 at 12:21 -0800, Kuniyuki Iwashima wrote:
> From:   Paolo Abeni <pabeni@redhat.com>
> Date:   Fri, 11 Nov 2022 09:53:31 +0100
> > On Thu, 2022-11-10 at 20:00 -0800, Kuniyuki Iwashima wrote:
> > > @@ -408,6 +409,28 @@ static int proc_tcp_ehash_entries(struct ctl_table *table, int write,
> > >  	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > >  }
> > >  
> > > +static int proc_udp_hash_entries(struct ctl_table *table, int write,
> > > +				 void *buffer, size_t *lenp, loff_t *ppos)
> > > +{
> > > +	struct net *net = container_of(table->data, struct net,
> > > +				       ipv4.sysctl_udp_child_hash_entries);
> > > +	int udp_hash_entries;
> > > +	struct ctl_table tbl;
> > > +
> > > +	udp_hash_entries = net->ipv4.udp_table->mask + 1;
> > > +
> > > +	/* A negative number indicates that the child netns
> > > +	 * shares the global udp_table.
> > > +	 */
> > > +	if (!net_eq(net, &init_net) && net->ipv4.udp_table == &udp_table)
> > > +		udp_hash_entries *= -1;
> > > +
> > > +	tbl.data = &udp_hash_entries;
> > > +	tbl.maxlen = sizeof(int);
> > 
> > I see the procfs code below will only use tbl.data and tbl.maxlen, but
> > perhaps is cleaner intially explicitly memset tbl to 0 
> 
> Will add memset()
> 
> 
> > 
> > > 
> > > +
> > > +	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > > +}
> > > +
> > >  #ifdef CONFIG_IP_ROUTE_MULTIPATH
> > >  static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
> > >  					  void *buffer, size_t *lenp,
> > 
> > [...]
> > 
> > > @@ -3308,22 +3308,112 @@ u32 udp_flow_hashrnd(void)
> > >  }
> > >  EXPORT_SYMBOL(udp_flow_hashrnd);
> > >  
> > > -static int __net_init udp_sysctl_init(struct net *net)
> > > +static void __net_init udp_sysctl_init(struct net *net)
> > >  {
> > > -	net->ipv4.udp_table = &udp_table;
> > > -
> > >  	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
> > >  	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
> > >  
> > >  #ifdef CONFIG_NET_L3_MASTER_DEV
> > >  	net->ipv4.sysctl_udp_l3mdev_accept = 0;
> > >  #endif
> > > +}
> > > +
> > > +static struct udp_table __net_init *udp_pernet_table_alloc(unsigned int hash_entries)
> > > +{
> > > +	unsigned long hash_size, bitmap_size;
> > > +	struct udp_table *udptable;
> > > +	int i;
> > > +
> > > +	udptable = kmalloc(sizeof(*udptable), GFP_KERNEL);
> > > +	if (!udptable)
> > > +		goto out;
> > > +
> > > +	udptable->log = ilog2(hash_entries);
> > > +	udptable->mask = hash_entries - 1;
> > > +
> > > +	hash_size = L1_CACHE_ALIGN(hash_entries * 2 * sizeof(struct udp_hslot));
> > > +	bitmap_size = hash_entries *
> > > +		BITS_TO_LONGS(udp_bitmap_size(udptable)) * sizeof(unsigned long);
> > 
> > Ouch, I'm very sorry. I did not realize we need a bitmap per hash
> > bucket. This leads to a constant 8k additional memory overhead per
> > netns, undependently from arch long bitsize.
> 
> Ugh, it will be 64K per netns ... ?
> 
> hash_entries              : 2 ^ n
> BITS_TO_LONGS             : 2 ^ -m # arch specific
> udp_bitmap_size(udptable) : 2 ^ (16 - n)
> sizeof(unsigned long)     : 2 ^ m  # arch specific
> 
> (2 ^ n) * (2 ^ -m) * (2 ^ (16 - n)) * (2 ^ m)
> = 2 ^ (n - m + 16 - n + m)
> = 2 ^ 16
> = 64 K

For the records, I still think it's 8k ;)

BITS_TO_LONGS(n) * sizeof(unsigned long) is always equal to n/8
regardless of the arch, while the above math gives BITS_TO_LONGS(n) *
sizeof(unsigned long) == n.

Cheers,

Paolo


