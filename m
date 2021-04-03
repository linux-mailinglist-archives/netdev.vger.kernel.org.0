Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEA63533FB
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 14:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhDCMMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 08:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhDCMMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 08:12:37 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F406C0613E6;
        Sat,  3 Apr 2021 05:12:32 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x21so7878538eds.4;
        Sat, 03 Apr 2021 05:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=maGKMRFd5DT32qREut38NTfGtwiWF7WO3DiAaMVceSM=;
        b=MpLM7/1JDDsdlVU6IpcMFSw4UcFDjUltoEpiPmSf8x+DampOmgtzJ5ErvLaZn2uGYO
         TsO/0ZG4U0wx4+C2Nmxz5+wqJSodYI8pLmc32q0gtaFRdsN1UOARUkbmRvzjLqpBq3wY
         8m1+wx0dw7ylbHpf6MGx7xCUL+VJIMWOyuVunf15Xr7TQEyFe0cWCZLd7hZluoLiWr/9
         CtVvML+yRWhhyQrh/2HaU4+F2+CtFE8CVSgIvDcuLzUxB5bCb3S0psD1/YaLn4nrdQUi
         7/nge4LNdlFE2R1h6jKvq682YqG469QSqYfe15hKTK3hrD3I08kBZMDxfHqUU5U8By6c
         xpxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=maGKMRFd5DT32qREut38NTfGtwiWF7WO3DiAaMVceSM=;
        b=CAzHSvJ1l/WCyOoiB89zBMlhq2O1Llg3tXv7UTvpfXeeBjtaRxZXYPFw9ktSeMccNk
         /JymhwlOEXUPNExdFUxm0eDXM/2DD3GyRlkgtvLGQ2iELR3AVm6FkQffpe7FcA2c/gth
         ItAYvOhXRDrT9v0l23sXNqP8NxLO2K0OYqy6LsI3JorWmhYcHfWNQ0zsA1s2pqCxmy4G
         OHo6TywrXZem6u7OBKu2ehzc6EGq8HfgoruCKIavDLQ9b6754rXeoibi3OBZP/vYGOOS
         UAprNO94yc5gNozNH3q+pYSWheDKo59oguyFx8kY/k0CDhmysr1ztD4jar8yjQ0xxQ4/
         OalQ==
X-Gm-Message-State: AOAM532AK51HxJMmm2JYSCQ8NSmWfn0tQ110wKs9bx6IWOCIoBl6Us2k
        ue6FgL6C0yvOk7JkvbU4hwc6Rw/bujo=
X-Google-Smtp-Source: ABdhPJw6C7PrzIK0uMf+Wgm6q8JhUGCo4ALdBJtPwCCELXIPe1KnvOUkkYufKNT32w/XI6no/diDfA==
X-Received: by 2002:a05:6402:84b:: with SMTP id b11mr20446977edz.56.1617451950925;
        Sat, 03 Apr 2021 05:12:30 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r5sm5369672ejx.96.2021.04.03.05.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 05:12:30 -0700 (PDT)
Date:   Sat, 3 Apr 2021 15:12:28 +0300
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
Message-ID: <20210403121228.gfqbnyistngmf257@skbuf>
References: <20210331200857.3274425-1-olteanv@gmail.com>
 <20210331200857.3274425-10-olteanv@gmail.com>
 <87blaynt4l.fsf@toke.dk>
 <20210401113133.vzs3uxkp52k2ctla@skbuf>
 <875z16nsiu.fsf@toke.dk>
 <20210401160943.frw7l3rio7spr33n@skbuf>
 <87lfa1nat5.fsf@toke.dk>
 <20210401193821.3fmfxvnpwzam7b6f@skbuf>
 <20210402105625.at6p3u6dh5zorwsz@skbuf>
 <87eefrd3ta.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87eefrd3ta.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 01:07:29PM +0200, Toke Høiland-Jørgensen wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > On Thu, Apr 01, 2021 at 10:38:21PM +0300, Vladimir Oltean wrote:
> >> On Thu, Apr 01, 2021 at 08:01:42PM +0200, Toke Høiland-Jørgensen wrote:
> >> > Vladimir Oltean <olteanv@gmail.com> writes:
> >> > 
> >> > > On Thu, Apr 01, 2021 at 01:39:05PM +0200, Toke Høiland-Jørgensen wrote:
> >> > >> Vladimir Oltean <olteanv@gmail.com> writes:
> >> > >>
> >> > >> > On Thu, Apr 01, 2021 at 01:26:02PM +0200, Toke Høiland-Jørgensen wrote:
> >> > >> >> > +int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
> >> > >> >> > +		   struct xdp_frame **frames, u32 flags)
> >> > >> >> > +{
> >> > >> >> > +	struct enetc_tx_swbd xdp_redirect_arr[ENETC_MAX_SKB_FRAGS] = {0};
> >> > >> >> > +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> >> > >> >> > +	struct enetc_bdr *tx_ring;
> >> > >> >> > +	int xdp_tx_bd_cnt, i, k;
> >> > >> >> > +	int xdp_tx_frm_cnt = 0;
> >> > >> >> > +
> >> > >> >> > +	tx_ring = priv->tx_ring[smp_processor_id()];
> >> > >> >>
> >> > >> >> What mechanism guarantees that this won't overflow the array? :)
> >> > >> >
> >> > >> > Which array, the array of TX rings?
> >> > >>
> >> > >> Yes.
> >> > >>
> >> > >
> >> > > The problem isn't even accessing an out-of-bounds element in the TX ring array.
> >> > >
> >> > > As it turns out, I had a relatively superficial understanding of how
> >> > > things are organized, but let me try to explain.
> >> > >
> >> > > The number of TX rings is a configurable resource (between PFs and VFs)
> >> > > and we read the capability at probe time:
> >> > >
> >> > > enetc_get_si_caps:
> >> > > 	val = enetc_rd(hw, ENETC_SICAPR0);
> >> > > 	si->num_rx_rings = (val >> 16) & 0xff;
> >> > > 	si->num_tx_rings = val & 0xff;
> >> > >
> >> > > enetc_init_si_rings_params:
> >> > > 	priv->num_tx_rings = si->num_tx_rings;
> >> > >
> >> > > In any case, the TX array is declared as:
> >> > >
> >> > > struct enetc_ndev_priv {
> >> > > 	struct enetc_bdr *tx_ring[16];
> >> > > 	struct enetc_bdr *rx_ring[16];
> >> > > };
> >> > >
> >> > > because that's the maximum hardware capability.
> >> > >
> >> > > The priv->tx_ring array is populated in:
> >> > >
> >> > > enetc_alloc_msix:
> >> > > 	/* # of tx rings per int vector */
> >> > > 	v_tx_rings = priv->num_tx_rings / priv->bdr_int_num;
> >> > >
> >> > > 	for (i = 0; i < priv->bdr_int_num; i++) {
> >> > > 		for (j = 0; j < v_tx_rings; j++) {
> >> > > 			if (priv->bdr_int_num == ENETC_MAX_BDR_INT)
> >> > > 				idx = 2 * j + i; /* 2 CPUs */
> >> > > 			else
> >> > > 				idx = j + i * v_tx_rings; /* default */
> >> > >
> >> > > 			priv->tx_ring[idx] = bdr;
> >> > > 		}
> >> > > 	}
> >> > >
> >> > > priv->bdr_int_num is set to "num_online_cpus()".
> >> > > On LS1028A, it can be either 1 or 2 (and the ENETC_MAX_BDR_INT macro is
> >> > > equal to 2).
> >> > >
> >> > > Otherwise said, the convoluted logic above does the following:
> >> > > - It affines an MSI interrupt vector per CPU
> >> > > - It affines an RX ring per MSI vector, hence per CPU
> >> > > - It balances the fixed number of TX rings (say 8) among the available
> >> > >   MSI vectors, hence CPUs (say 2). It does this by iterating with i
> >> > >   through the RX MSI interrupt vectors, and with j through the number of
> >> > >   TX rings per MSI vector.
> >> > >
> >> > > This logic maps:
> >> > > - the even TX rings to CPU 0 and the odd TX rings to CPU 1, if 2 CPUs
> >> > >   are used
> >> > > - all TX rings to CPU 0, if 1 CPU is used
> >> > >
> >> > > This is done because we have this logic in enetc_poll:
> >> > >
> >> > > 	for (i = 0; i < v->count_tx_rings; i++)
> >> > > 		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
> >> > > 			complete = false;
> >> > >
> >> > > for processing the TX completions of a given group of TX rings in the RX
> >> > > MSI interrupt handler of a certain CPU.
> >> > >
> >> > > Otherwise said, priv->tx_ring[i] is always BD ring i, and that mapping
> >> > > never changes. All 8 TX rings are enabled and available for use.
> >> > >
> >> > > What I knew about tc-taprio and tc-mqprio is that they only enqueue to
> >> > > TX queues [0, num_tc-1] because of this, as it turns out:
> >> > >
> >> > > enetc_xmit:
> >> > > 	tx_ring = priv->tx_ring[skb->queue_mapping];
> >> > >
> >> > > where skb->queue_mapping is given by:
> >> > > 	err = netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
> >> > > and by this, respectively, from the mqprio code path:
> >> > > 	netif_set_real_num_tx_queues(ndev, num_tc);
> >> > >
> >> > > As for why XDP works, and priv->tx_ring[smp_processor_id()] is:
> >> > > - TX ring 0 for CPU 0 and TX ring 1 for CPU 1, if 2 CPUs are used
> >> > > - TX ring 0, if 1 CPU is used
> >> > >
> >> > > The TX completions in the first case are handled by:
> >> > > - CPU 0 for TX ring 0 (because it is even) and CPU 1 for TX ring 1
> >> > >   (because it is odd), if 2 CPUs are used, due to the mapping I talked
> >> > >   about earlier
> >> > > - CPU 0 if only 1 CPU is used
> >> > 
> >> > Right - thank you for the details! So what are the constraints on the
> >> > configuration. Specifically, given two netdevs on the same device, is it
> >> > possible that the system can ever end up in a situation where one device
> >> > has two *RXQs* configured, and the other only one *TXQ*. Because then
> >> > you could get a redirect from RXQ 1 on one device, which would also end
> >> > up trying to transmit on TXQ 1 on the other device; and that would break
> >> > if that other device only has TXQ 0 configured... Same thing if a single
> >> > device has 2 RXQs but only one TXQ (it can redirect to itself).
> >> 
> >> I discover more and more of the driver as I talk to you, I like it :D
> >> 
> >> So I said that there is a maximum number of RX and TX rings splittable
> >> between the PF and its VFs, but I wasn't exactly sure where that
> >> configuration is done. I found it now.
> >> 
> >> enetc_port_si_configure: (SI == station interface)
> >> 	- read Port capability register 0 (PCAPR0) to determine how many
> >> 	  RX rings and TX rings the hardware has for this port (PFs + VFs)
> >> 	  in total.
> >> 	- assign num_rings = min(TX rings, RX rings)
> >> 	- try to assign 8 TX rings and 8 RX rings to the PF
> >> 	  - if this fails, just assign ${num_rings} TX rings and
> >> 	    ${num_rings} RX rings to the PF
> >> 	- split the remaining RX and TX rings to the number of
> >> 	  configured VFs (example: if there are 16 RX rings and 16 TX
> >> 	  rings for a port with 2 VFs, the driver assigns 8RX/8TX rings
> >> 	  for the PF, and 4RX/4TX rings for each VF).
> >> 	   - if we couldn't assign 8RX/8TX rings for the PF in the
> >> 	     previous step, we don't assign any ring to the VF
> >> 
> >> So yeah, we have an equal number of RX and TX rings. The driver,
> >> however, only uses 2 RX rings _actively_: one per CPU. The other 6, I
> >> don't know, I guess I can use them for AF_XDP (I haven't looked very
> >> closely at that yet), at the moment they're pretty much unused, even if
> >> reserved and not given to VFs.
> >> 
> >> > >> > You mean that it's possible to receive a TC_SETUP_QDISC_MQPRIO or
> >> > >> > TC_SETUP_QDISC_TAPRIO with num_tc == 1, and we have 2 CPUs?
> >> > >>
> >> > >> Not just that, this ndo can be called on arbitrary CPUs after a
> >> > >> redirect. The code just calls through from the XDP receive path so which
> >> > >> CPU it ends up on depends on the RSS+IRQ config of the other device,
> >> > >> which may not even be the same driver; i.e., you have no control over
> >> > >> that... :)
> >> > >>
> >> > >
> >> > > What do you mean by "arbitrary" CPU? You can't plug CPUs in, it's a dual
> >> > > core system... Why does the source ifindex matter at all? I'm using the
> >> > > TX ring affined to the CPU that ndo_xdp_xmit is currently running on.
> >> > 
> >> > See, this is why I asked 'what mechanism ensures'. Because if that
> >> > mechanism is 'this driver is only ever used on a system with fewer CPUs
> >> > than TXQs', then that's of course fine :)
> >> > 
> >> > But there are drivers that do basically the same thing as what you've
> >> > done here, *without* having such an assurance, and just looking at that
> >> > function it's not obvious that there's an out-of-band reason why it's
> >> > safe. And I literally just came from looking at such a case when I
> >> > replied to your initial patch...
> >> 
> >> Maybe you were confused seeing that this is a PCI device, thinking it's
> >> a plug-in card or something, therefore we don't get to choose the number
> >> of CPUs that the host has. In hindsight, I don't know why you didn't ask
> >> about this, it is pretty strange when you think about it.
> >> 
> >> It is actually more like a platform device with a PCI front-end - we
> >> found this loophole in the PCI standard where you can create a "root
> >> complex/integrated endpoint" which is basically an ECAM where the config
> >> space contains PFs corresponding to some platform devices in the SoC (in
> >> our case, all 4 Ethernet ports have their own PF, the switch has its own
> >> PF, same thing for the MDIO controller and the 1588 timer). Their
> >> register map is exposed as a number of BARs which use Enhanced
> >> Allocation, so the generic PCI ECAM driver doesn't need to create any
> >> translation windows for these addresses, it just uses what's in there,
> >> which, surprise, is the actual base address of the peripheral in the
> >> SoC's memory space.
> >> 
> >> We do that because we gain a lot of cool stuff by appearing as PCI
> >> devices to system software, like for example multiple interfaces on top
> >> of a 'shared MAC' are simply mapped over SR-IOV.
> >> 
> >> So it just 'smells' like PCI, but they're regular memory-mapped devices,
> >> there is no PCI transaction layer or physical layer. At the moment the
> >> LS1028A is the only SoC running Linux that integrates the ENETC block,
> >> so we fully control the environment.
> >> 
> >> > >> > Well, yeah, I don't know what's the proper way to deal with that. Ideas?
> >> > >>
> >> > >> Well the obvious one is just:
> >> > >>
> >> > >> tx_ring = priv->tx_ring[smp_processor_id() % num_ring_ids];
> >> > >>
> >> > >> and then some kind of locking to deal with multiple CPUs accessing the
> >> > >> same TX ring...
> >> > >
> >> > > By multiple CPUs accessing the same TX ring, you mean locking between
> >> > > ndo_xdp_xmit and ndo_start_xmit? Can that even happen if the hardware
> >> > > architecture is to have at least as many TX rings as CPUs?
> >> > >
> >> > > Because otherwise, I see that ndo_xdp_xmit is only called from
> >> > > xdp_do_flush, which is in softirq context, which to my very rudimentary
> >> > > knowledge run with bottom halves, thus preemption, disabled? So I don't
> >> > > think it's possible for ndo_xdp_xmit and ndo_xmit, or even two
> >> > > ndo_xdp_xmit instances, to access the same TX ring?
> >> > 
> >> > Yup, I think you're right about that. The "we always have more TXQs than
> >> > CPUs" condition was the bit I was missing (and of course you're *sure*
> >> > that this would never change sometime in the future, right? ;)).
> >> 
> >> I'm pretty sure, yeah, we build the SoCs and one of the requirements we
> >> have is that every ENETC PF has enough TX rings in order for every CPU
> >> to have its own one. That helps a lot with avoiding contention and
> >> simplifying the driver. Maybe I'll use this opportunity to talk again to
> >> the hardware design guys and make sure that the next SoCs with Linux
> >> follow the same pattern as LS1028A, although I see no reason why not.
> >> 
> >> > > Sorry, I'm sure these are trivial questions, but I would like to really
> >> > > understand what I need to change and why :D
> >> > 
> >> > Given the above I think the only potentially breaking thing is the
> >> > #RXQ > #TXQ case I outlined. And maybe a comment documenting why indexing
> >> > the tx_ring array by smp_processor_id() is safe would be nice? :)
> >> 
> >> Sure, which part exactly do you think would explain it best? Should I
> >> add a reference to enetc_port_si_configure?
> >
> > After discussing a bit more with Claudiu, I think we do have a problem,
> > and it has to do with concurrent ndo_xdp_xmit on one CPU and ndo_start_xmit
> > on another CPU.
> >
> > See, even if we have 8 TX rings, they are not really affined to any CPU.
> > Instead, when we call netif_set_real_num_tx_queues, we allow netdev_pick_tx
> > to hash amongs the TX queues of the same priority. There are three consequences:
> > - Traffic with the same hash will be sent to the same TX queue, thus
> >   avoiding reordering for packets belonging to the same stream.
> > - Traffic with different hashes are distributed to different TX queues.
> > - If we have two CPUs sending traffic with the same hash, they will
> >   serialize on the TX lock of the same netdev queue.
> >
> > The last one is a problem because our XDP_REDIRECT tries to associate
> > one TX ring with one CPU, and, as explained above, that TX ring might
> > already be used by our ndo_start_xmit on another CPU, selected by
> > netdev_pick_tx.
> >
> > The first idea was to implement ndo_select_queue for the network stack,
> > and select the TX ring based on smp_processor_id(). But we know that
> > this will break the first two effects of netdev_pick_tx, which are very
> > much desirable. For example, if we have a user space process sending a
> > TCP stream, and the scheduler migrates that process from one CPU to
> > another, then the ndo_select_queue output for that TCP stream will
> > change, and we will have TX reordering for packets belonging to the same
> > stream. Not at all ideal.
> >
> > Another idea is to just crop some TX queues from the network stack, and
> > basically call netif_set_real_num_tx_queues(6), leaving one TX ring per
> > CPU dedicated to XDP. This will work just fine for normal qdiscs, except
> > that with mqprio/taprio we have a problem. Our TX rings have a configurable
> > strict priority for the hardware egress scheduler. When we don't have
> > mqprio/taprio, all TX rings have the same priority of 0 (therefore it is
> > safe to allow hashing to select one at random), but when we have mqprio
> > or taprio, we enjoy the benefit of configuring the priority of each TX
> > ring using the "map" option. The problem, of course, is that if we crop
> > 2 TX rings out of what the network stack sees, then we are no longer
> > able to configure their queue-to-traffic-class mapping through
> > mqprio/taprio, so we cannot change their prioritization relative to the
> > network stack queues. In a way, this seems to be in line with the XDP
> > design because that bypasses anything that has to do with qdiscs, but we
> > don't really like that. We also have some other qdisc-based offloads
> > such as Credit Based Shaper, and we would very much like to be able to
> > set bandwidth profiles for the XDP rings, for AVB/TSN use cases.
> 
> You'd not be the first driver to solve this by just carving out a couple
> of TX rings for XDP :)
> 
> And while I get the desire for being able to configure these things for
> XDP as well, I'm not sure that the qdisc interface is the right one to
> use for that. There was a general TXQ allocation idea that unfortunately
> stalled out, but there is also ongoing work on XDP+TSN - I'm hoping
> Jesper can chime in with the details...

See, the reason why I don't like this answer is because when we tried to
upstream our genetlink-based TSN configuration:
https://patchwork.ozlabs.org/project/netdev/patch/1545968945-7290-1-git-send-email-Po.Liu@nxp.com/
we were told that it's a QoS feature and QoS belongs to the qdisc layer.

I get the impression that XDP is largely incompatible with QoS by design,
which sounds to me like a bit of a foot gun. For example, we have some
customers interested in building an AVB application stack on top of AF_XDP,
and for the endpoints (talker/listener) they really need to be able to
configure bandwidth profiles for Stream Reservation classes A and B on
the AF_XDP rings.

To us, tc is mostly just a configuration interface for hardware features,
the deal was that this is fine as long as they have a software counterpart
with identical semantics. I think I understand the basic problem in that
a software shaper would be bypassed by XDP, and therefore, the bandwidth
profile would not be observed properly by the AVB talker if we were to
rely on that. So that sounds indeed like we shouldn't even attempt to
manage any TX queues on which XDP traffic is possible with tc, unless
we're willing to pass XDP_REDIRECT through the qdisc layer (which I'm
not suggesting is a good idea). But with the hardware offload that
wouldn't be the case, so it's almost as if what would work for us would
be to have some 'dummy' TX queues for XDP manageable by tc qdiscs where
we could attach our offloadable filters and shapers and policers. I just
don't want them to be completely invisible as far as tc is concerned.
Managing which TX queues go to XDP, and not letting the driver choose
that, would be even nicer.

> > Finally there is the option of taking the network stack's TX lock in our
> > ndo_xdp_xmit, but frankly I would leave that option as a last resort.
> > Maybe we could make this less expensive by bulk-enqueuing into a
> > temporary array of buffer descriptors, and only taking the xmit lock
> > when flushing that array (since that is the only portion that strictly
> > needs to be protected against concurrency). But the problem with this
> > approach is that if you have a temporary array, it becomes a lot more
> > difficult and error-prone to not take more frames than you can enqueue.
> > For example, the TX ring might have only 20 free entries, and you filled
> > your BD array with 32 frames, and you told the caller of ndo_xdp_xmit
> > that you processed all those frames. Now when push comes to shove and
> > you actually need to enqueue them, you end up in the position that you
> > must drop them yourself. This seems to be very much against the design
> > principle of commit fdc13979f91e ("bpf, devmap: Move drop error path to
> > devmap for XDP_REDIRECT") whose desire is to let XDP handle the dropping
> > of excess TX frames.
> 
> Note that there's already bulking in XDP_REDIRECT: after an XDP program
> returns XDP_REDIRECT, the packets will actually be put on a bulk queue
> (see bq_enqueue() in devmap.c), and that will be flushed to the TX
> driver at the end of the (RX) NAPI cycle. So taking a lock in
> ndo_xdp_xmit() may not be quite as much overhead as you think it is -
> so maybe it would be worth benchmarking before ruling this out entirely? :)

If shared TX queues does turn out to be the best alternative - which I'm
not convinced it is - then I'll benchmark it, sure.
