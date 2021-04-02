Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562AD352A01
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 12:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhDBK4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 06:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhDBK4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 06:56:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A1DC0613E6;
        Fri,  2 Apr 2021 03:56:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id bx7so5055925edb.12;
        Fri, 02 Apr 2021 03:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+GJRG8pIUDDK5n2h+4aHQ/1OkIB9SkP4oBSrB/qMHjY=;
        b=cCYD91lBjo393/QXAWgPy8NFq0eBWloi/CS81btirX5bYq7Q7mMc0VS7BTvUfgKddg
         G/OUXkAILVtJk6r2RkBDGxJBA7PNZLxseX0ANQaFpy/q22RRPBGHRvqUnzdJe9k3ads9
         NFjlhlnkm+iP9x2+XEYuCcHmjfY/aPrMfkOxlsSJtNfSD3cwKCEWLBCyMO364hmM5Ym2
         jGfNlnbFd8fL+O/wlyizuq4aTARQkgvhcLWBwQ/34F79arCb3ZSqKfteL61/dnDMIQjX
         Pn6oGAG66KAnCoxINsY1/TdmqfrO9+pZ9aGuxu1w5PqLpJH7Wo7Bqo2+GNjhyw3o9p6f
         S5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+GJRG8pIUDDK5n2h+4aHQ/1OkIB9SkP4oBSrB/qMHjY=;
        b=QOiM2Zm8m6WDyerw27R7CLlx7K9eBFtMMgHUx8gs/mr04ADTGh1veiDii2jkm1WjFQ
         f6ZTaW8mMoUysNkwPjbWXfwHJdNi6bvSrTzLW105h+vD5aCUFBL6Hjs0EwX8iLRu73ZU
         HAcW5nXd2wNeuMrU2f/PPFKZhYWtxFsVZNRl52MQ+B6Hp8yOHzvHg5ADNQ4kKoGsYTdg
         MzfYRHVF6gyfozsRTmlM30PUud75KCexTRKnvGnY/X+bL/uK/XbdxUnopwtHvpDM/Qpu
         EWf5PCsPG14Mu8if+Gd9/KVn76GGTPNrMVNLq55ZEd+Bj3S65onXsxvf15qGMKttL/AH
         QuJQ==
X-Gm-Message-State: AOAM533jlV17C37ZaFeC4p8voR63PG3RBUenjQlFw0KSI7A5KjFDoxb0
        uv7PK1rrLzfYxzpMFlf/nSC0rmZbGJQ=
X-Google-Smtp-Source: ABdhPJyT0Zbt1y+iu5ORU6JI3/w2Rs6AidcoS7C6D+CdbcPnWkziLXEQ87LZjAW2JaXpaKA5k7pLNg==
X-Received: by 2002:aa7:c447:: with SMTP id n7mr14637570edr.171.1617360987630;
        Fri, 02 Apr 2021 03:56:27 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id s18sm5350858edc.21.2021.04.02.03.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 03:56:27 -0700 (PDT)
Date:   Fri, 2 Apr 2021 13:56:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 9/9] net: enetc: add support for XDP_REDIRECT
Message-ID: <20210402105625.at6p3u6dh5zorwsz@skbuf>
References: <20210331200857.3274425-1-olteanv@gmail.com>
 <20210331200857.3274425-10-olteanv@gmail.com>
 <87blaynt4l.fsf@toke.dk>
 <20210401113133.vzs3uxkp52k2ctla@skbuf>
 <875z16nsiu.fsf@toke.dk>
 <20210401160943.frw7l3rio7spr33n@skbuf>
 <87lfa1nat5.fsf@toke.dk>
 <20210401193821.3fmfxvnpwzam7b6f@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210401193821.3fmfxvnpwzam7b6f@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 10:38:21PM +0300, Vladimir Oltean wrote:
> On Thu, Apr 01, 2021 at 08:01:42PM +0200, Toke Høiland-Jørgensen wrote:
> > Vladimir Oltean <olteanv@gmail.com> writes:
> > 
> > > On Thu, Apr 01, 2021 at 01:39:05PM +0200, Toke Høiland-Jørgensen wrote:
> > >> Vladimir Oltean <olteanv@gmail.com> writes:
> > >>
> > >> > On Thu, Apr 01, 2021 at 01:26:02PM +0200, Toke Høiland-Jørgensen wrote:
> > >> >> > +int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
> > >> >> > +		   struct xdp_frame **frames, u32 flags)
> > >> >> > +{
> > >> >> > +	struct enetc_tx_swbd xdp_redirect_arr[ENETC_MAX_SKB_FRAGS] = {0};
> > >> >> > +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> > >> >> > +	struct enetc_bdr *tx_ring;
> > >> >> > +	int xdp_tx_bd_cnt, i, k;
> > >> >> > +	int xdp_tx_frm_cnt = 0;
> > >> >> > +
> > >> >> > +	tx_ring = priv->tx_ring[smp_processor_id()];
> > >> >>
> > >> >> What mechanism guarantees that this won't overflow the array? :)
> > >> >
> > >> > Which array, the array of TX rings?
> > >>
> > >> Yes.
> > >>
> > >
> > > The problem isn't even accessing an out-of-bounds element in the TX ring array.
> > >
> > > As it turns out, I had a relatively superficial understanding of how
> > > things are organized, but let me try to explain.
> > >
> > > The number of TX rings is a configurable resource (between PFs and VFs)
> > > and we read the capability at probe time:
> > >
> > > enetc_get_si_caps:
> > > 	val = enetc_rd(hw, ENETC_SICAPR0);
> > > 	si->num_rx_rings = (val >> 16) & 0xff;
> > > 	si->num_tx_rings = val & 0xff;
> > >
> > > enetc_init_si_rings_params:
> > > 	priv->num_tx_rings = si->num_tx_rings;
> > >
> > > In any case, the TX array is declared as:
> > >
> > > struct enetc_ndev_priv {
> > > 	struct enetc_bdr *tx_ring[16];
> > > 	struct enetc_bdr *rx_ring[16];
> > > };
> > >
> > > because that's the maximum hardware capability.
> > >
> > > The priv->tx_ring array is populated in:
> > >
> > > enetc_alloc_msix:
> > > 	/* # of tx rings per int vector */
> > > 	v_tx_rings = priv->num_tx_rings / priv->bdr_int_num;
> > >
> > > 	for (i = 0; i < priv->bdr_int_num; i++) {
> > > 		for (j = 0; j < v_tx_rings; j++) {
> > > 			if (priv->bdr_int_num == ENETC_MAX_BDR_INT)
> > > 				idx = 2 * j + i; /* 2 CPUs */
> > > 			else
> > > 				idx = j + i * v_tx_rings; /* default */
> > >
> > > 			priv->tx_ring[idx] = bdr;
> > > 		}
> > > 	}
> > >
> > > priv->bdr_int_num is set to "num_online_cpus()".
> > > On LS1028A, it can be either 1 or 2 (and the ENETC_MAX_BDR_INT macro is
> > > equal to 2).
> > >
> > > Otherwise said, the convoluted logic above does the following:
> > > - It affines an MSI interrupt vector per CPU
> > > - It affines an RX ring per MSI vector, hence per CPU
> > > - It balances the fixed number of TX rings (say 8) among the available
> > >   MSI vectors, hence CPUs (say 2). It does this by iterating with i
> > >   through the RX MSI interrupt vectors, and with j through the number of
> > >   TX rings per MSI vector.
> > >
> > > This logic maps:
> > > - the even TX rings to CPU 0 and the odd TX rings to CPU 1, if 2 CPUs
> > >   are used
> > > - all TX rings to CPU 0, if 1 CPU is used
> > >
> > > This is done because we have this logic in enetc_poll:
> > >
> > > 	for (i = 0; i < v->count_tx_rings; i++)
> > > 		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
> > > 			complete = false;
> > >
> > > for processing the TX completions of a given group of TX rings in the RX
> > > MSI interrupt handler of a certain CPU.
> > >
> > > Otherwise said, priv->tx_ring[i] is always BD ring i, and that mapping
> > > never changes. All 8 TX rings are enabled and available for use.
> > >
> > > What I knew about tc-taprio and tc-mqprio is that they only enqueue to
> > > TX queues [0, num_tc-1] because of this, as it turns out:
> > >
> > > enetc_xmit:
> > > 	tx_ring = priv->tx_ring[skb->queue_mapping];
> > >
> > > where skb->queue_mapping is given by:
> > > 	err = netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
> > > and by this, respectively, from the mqprio code path:
> > > 	netif_set_real_num_tx_queues(ndev, num_tc);
> > >
> > > As for why XDP works, and priv->tx_ring[smp_processor_id()] is:
> > > - TX ring 0 for CPU 0 and TX ring 1 for CPU 1, if 2 CPUs are used
> > > - TX ring 0, if 1 CPU is used
> > >
> > > The TX completions in the first case are handled by:
> > > - CPU 0 for TX ring 0 (because it is even) and CPU 1 for TX ring 1
> > >   (because it is odd), if 2 CPUs are used, due to the mapping I talked
> > >   about earlier
> > > - CPU 0 if only 1 CPU is used
> > 
> > Right - thank you for the details! So what are the constraints on the
> > configuration. Specifically, given two netdevs on the same device, is it
> > possible that the system can ever end up in a situation where one device
> > has two *RXQs* configured, and the other only one *TXQ*. Because then
> > you could get a redirect from RXQ 1 on one device, which would also end
> > up trying to transmit on TXQ 1 on the other device; and that would break
> > if that other device only has TXQ 0 configured... Same thing if a single
> > device has 2 RXQs but only one TXQ (it can redirect to itself).
> 
> I discover more and more of the driver as I talk to you, I like it :D
> 
> So I said that there is a maximum number of RX and TX rings splittable
> between the PF and its VFs, but I wasn't exactly sure where that
> configuration is done. I found it now.
> 
> enetc_port_si_configure: (SI == station interface)
> 	- read Port capability register 0 (PCAPR0) to determine how many
> 	  RX rings and TX rings the hardware has for this port (PFs + VFs)
> 	  in total.
> 	- assign num_rings = min(TX rings, RX rings)
> 	- try to assign 8 TX rings and 8 RX rings to the PF
> 	  - if this fails, just assign ${num_rings} TX rings and
> 	    ${num_rings} RX rings to the PF
> 	- split the remaining RX and TX rings to the number of
> 	  configured VFs (example: if there are 16 RX rings and 16 TX
> 	  rings for a port with 2 VFs, the driver assigns 8RX/8TX rings
> 	  for the PF, and 4RX/4TX rings for each VF).
> 	   - if we couldn't assign 8RX/8TX rings for the PF in the
> 	     previous step, we don't assign any ring to the VF
> 
> So yeah, we have an equal number of RX and TX rings. The driver,
> however, only uses 2 RX rings _actively_: one per CPU. The other 6, I
> don't know, I guess I can use them for AF_XDP (I haven't looked very
> closely at that yet), at the moment they're pretty much unused, even if
> reserved and not given to VFs.
> 
> > >> > You mean that it's possible to receive a TC_SETUP_QDISC_MQPRIO or
> > >> > TC_SETUP_QDISC_TAPRIO with num_tc == 1, and we have 2 CPUs?
> > >>
> > >> Not just that, this ndo can be called on arbitrary CPUs after a
> > >> redirect. The code just calls through from the XDP receive path so which
> > >> CPU it ends up on depends on the RSS+IRQ config of the other device,
> > >> which may not even be the same driver; i.e., you have no control over
> > >> that... :)
> > >>
> > >
> > > What do you mean by "arbitrary" CPU? You can't plug CPUs in, it's a dual
> > > core system... Why does the source ifindex matter at all? I'm using the
> > > TX ring affined to the CPU that ndo_xdp_xmit is currently running on.
> > 
> > See, this is why I asked 'what mechanism ensures'. Because if that
> > mechanism is 'this driver is only ever used on a system with fewer CPUs
> > than TXQs', then that's of course fine :)
> > 
> > But there are drivers that do basically the same thing as what you've
> > done here, *without* having such an assurance, and just looking at that
> > function it's not obvious that there's an out-of-band reason why it's
> > safe. And I literally just came from looking at such a case when I
> > replied to your initial patch...
> 
> Maybe you were confused seeing that this is a PCI device, thinking it's
> a plug-in card or something, therefore we don't get to choose the number
> of CPUs that the host has. In hindsight, I don't know why you didn't ask
> about this, it is pretty strange when you think about it.
> 
> It is actually more like a platform device with a PCI front-end - we
> found this loophole in the PCI standard where you can create a "root
> complex/integrated endpoint" which is basically an ECAM where the config
> space contains PFs corresponding to some platform devices in the SoC (in
> our case, all 4 Ethernet ports have their own PF, the switch has its own
> PF, same thing for the MDIO controller and the 1588 timer). Their
> register map is exposed as a number of BARs which use Enhanced
> Allocation, so the generic PCI ECAM driver doesn't need to create any
> translation windows for these addresses, it just uses what's in there,
> which, surprise, is the actual base address of the peripheral in the
> SoC's memory space.
> 
> We do that because we gain a lot of cool stuff by appearing as PCI
> devices to system software, like for example multiple interfaces on top
> of a 'shared MAC' are simply mapped over SR-IOV.
> 
> So it just 'smells' like PCI, but they're regular memory-mapped devices,
> there is no PCI transaction layer or physical layer. At the moment the
> LS1028A is the only SoC running Linux that integrates the ENETC block,
> so we fully control the environment.
> 
> > >> > Well, yeah, I don't know what's the proper way to deal with that. Ideas?
> > >>
> > >> Well the obvious one is just:
> > >>
> > >> tx_ring = priv->tx_ring[smp_processor_id() % num_ring_ids];
> > >>
> > >> and then some kind of locking to deal with multiple CPUs accessing the
> > >> same TX ring...
> > >
> > > By multiple CPUs accessing the same TX ring, you mean locking between
> > > ndo_xdp_xmit and ndo_start_xmit? Can that even happen if the hardware
> > > architecture is to have at least as many TX rings as CPUs?
> > >
> > > Because otherwise, I see that ndo_xdp_xmit is only called from
> > > xdp_do_flush, which is in softirq context, which to my very rudimentary
> > > knowledge run with bottom halves, thus preemption, disabled? So I don't
> > > think it's possible for ndo_xdp_xmit and ndo_xmit, or even two
> > > ndo_xdp_xmit instances, to access the same TX ring?
> > 
> > Yup, I think you're right about that. The "we always have more TXQs than
> > CPUs" condition was the bit I was missing (and of course you're *sure*
> > that this would never change sometime in the future, right? ;)).
> 
> I'm pretty sure, yeah, we build the SoCs and one of the requirements we
> have is that every ENETC PF has enough TX rings in order for every CPU
> to have its own one. That helps a lot with avoiding contention and
> simplifying the driver. Maybe I'll use this opportunity to talk again to
> the hardware design guys and make sure that the next SoCs with Linux
> follow the same pattern as LS1028A, although I see no reason why not.
> 
> > > Sorry, I'm sure these are trivial questions, but I would like to really
> > > understand what I need to change and why :D
> > 
> > Given the above I think the only potentially breaking thing is the
> > #RXQ > #TXQ case I outlined. And maybe a comment documenting why indexing
> > the tx_ring array by smp_processor_id() is safe would be nice? :)
> 
> Sure, which part exactly do you think would explain it best? Should I
> add a reference to enetc_port_si_configure?

After discussing a bit more with Claudiu, I think we do have a problem,
and it has to do with concurrent ndo_xdp_xmit on one CPU and ndo_start_xmit
on another CPU.

See, even if we have 8 TX rings, they are not really affined to any CPU.
Instead, when we call netif_set_real_num_tx_queues, we allow netdev_pick_tx
to hash amongs the TX queues of the same priority. There are three consequences:
- Traffic with the same hash will be sent to the same TX queue, thus
  avoiding reordering for packets belonging to the same stream.
- Traffic with different hashes are distributed to different TX queues.
- If we have two CPUs sending traffic with the same hash, they will
  serialize on the TX lock of the same netdev queue.

The last one is a problem because our XDP_REDIRECT tries to associate
one TX ring with one CPU, and, as explained above, that TX ring might
already be used by our ndo_start_xmit on another CPU, selected by
netdev_pick_tx.

The first idea was to implement ndo_select_queue for the network stack,
and select the TX ring based on smp_processor_id(). But we know that
this will break the first two effects of netdev_pick_tx, which are very
much desirable. For example, if we have a user space process sending a
TCP stream, and the scheduler migrates that process from one CPU to
another, then the ndo_select_queue output for that TCP stream will
change, and we will have TX reordering for packets belonging to the same
stream. Not at all ideal.

Another idea is to just crop some TX queues from the network stack, and
basically call netif_set_real_num_tx_queues(6), leaving one TX ring per
CPU dedicated to XDP. This will work just fine for normal qdiscs, except
that with mqprio/taprio we have a problem. Our TX rings have a configurable
strict priority for the hardware egress scheduler. When we don't have
mqprio/taprio, all TX rings have the same priority of 0 (therefore it is
safe to allow hashing to select one at random), but when we have mqprio
or taprio, we enjoy the benefit of configuring the priority of each TX
ring using the "map" option. The problem, of course, is that if we crop
2 TX rings out of what the network stack sees, then we are no longer
able to configure their queue-to-traffic-class mapping through
mqprio/taprio, so we cannot change their prioritization relative to the
network stack queues. In a way, this seems to be in line with the XDP
design because that bypasses anything that has to do with qdiscs, but we
don't really like that. We also have some other qdisc-based offloads
such as Credit Based Shaper, and we would very much like to be able to
set bandwidth profiles for the XDP rings, for AVB/TSN use cases.

Finally there is the option of taking the network stack's TX lock in our
ndo_xdp_xmit, but frankly I would leave that option as a last resort.
Maybe we could make this less expensive by bulk-enqueuing into a
temporary array of buffer descriptors, and only taking the xmit lock
when flushing that array (since that is the only portion that strictly
needs to be protected against concurrency). But the problem with this
approach is that if you have a temporary array, it becomes a lot more
difficult and error-prone to not take more frames than you can enqueue.
For example, the TX ring might have only 20 free entries, and you filled
your BD array with 32 frames, and you told the caller of ndo_xdp_xmit
that you processed all those frames. Now when push comes to shove and
you actually need to enqueue them, you end up in the position that you
must drop them yourself. This seems to be very much against the design
principle of commit fdc13979f91e ("bpf, devmap: Move drop error path to
devmap for XDP_REDIRECT") whose desire is to let XDP handle the dropping
of excess TX frames.

What do you think?
