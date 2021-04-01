Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6DE351D55
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbhDAS2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239494AbhDASQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:16:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11314C02FEA4;
        Thu,  1 Apr 2021 09:09:47 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id jy13so3695952ejc.2;
        Thu, 01 Apr 2021 09:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=us+3Yp591gmxYbF9mhS2gMKfe8LxyfhDKgXk1LVCWx4=;
        b=iFnOKtd9w2BlsxxD++8UE77w+uiRs8+99uEAykGyQ93TTtc2v1tkfBZhEzQOK/v34H
         9MJK/+S7fPFlWD8j3CTm5Jxp/Hp1W4rRnAyj3ifUL1BFItCqHPoC5J7hBgGRh2ixrulA
         +rgFpSwS3z+/AoZGJH540lxqLURMYpy4xDJQLF5BoMjhV9dQxeB1s7u9WED94LE6c0B/
         ybEmgo95jcAo9tRFy8hP4HqdcoKJaYDZYCjykWjikLoz/GZc8ambESkqHZ6qush8TazO
         8j2gZ0nf6CDliR2dk5RuKK93Ck3d+G0XiFbw8G8MIGmcQAHcNjxP+kpU4UQl1pB/WG6u
         9tFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=us+3Yp591gmxYbF9mhS2gMKfe8LxyfhDKgXk1LVCWx4=;
        b=R14i4dueZnoubT/HmGZI20kOE5FMAyXCLd/Rc4FRSfR4qZdLhrhLz+plwr1y0HV4xH
         QuftmJq/4WmqrfDK+o77ZMIPZCJZrCPQUMVYCfijrcsObcp9T+DiFZVHVXsONTtVs9gd
         K2Y0QYYud9tQnnf9OP2CB0cZsRnDlehvDn27XQMguURqbnH6AESYqRJAD7x0fNV++CWr
         +ml3fR4M4qcww3GUhPhoI1Qb9wOAy8pPRYmKZKuY39lF+znTzPgMaZFcYYIeN4Vf5djs
         pJok3pA4noYwU6fbJcZM/ot3s76wQOXxi1Xbm/lQiW9cnQsW9MvrlF2rjFwLlz9WKN4v
         6sgg==
X-Gm-Message-State: AOAM530j8IqqhDdyRoDk4FJlEYM6awyVB+OP47jbljeK6hhbRtHJPgPE
        pYA/ZCMPUU5NW0kEwJQbfRA=
X-Google-Smtp-Source: ABdhPJyrwyPfRMr4KqfP6OorQAfwCEQQlVGm7Sxql3/HJLyN8t1gJQzvMgwEIaQA6QuO6HlcywSVEQ==
X-Received: by 2002:a17:906:fcb2:: with SMTP id qw18mr9578431ejb.434.1617293385778;
        Thu, 01 Apr 2021 09:09:45 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id l12sm3617631edb.39.2021.04.01.09.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:09:45 -0700 (PDT)
Date:   Thu, 1 Apr 2021 19:09:43 +0300
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
Message-ID: <20210401160943.frw7l3rio7spr33n@skbuf>
References: <20210331200857.3274425-1-olteanv@gmail.com>
 <20210331200857.3274425-10-olteanv@gmail.com>
 <87blaynt4l.fsf@toke.dk>
 <20210401113133.vzs3uxkp52k2ctla@skbuf>
 <875z16nsiu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875z16nsiu.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 01:39:05PM +0200, Toke Høiland-Jørgensen wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
>
> > On Thu, Apr 01, 2021 at 01:26:02PM +0200, Toke Høiland-Jørgensen wrote:
> >> > +int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
> >> > +		   struct xdp_frame **frames, u32 flags)
> >> > +{
> >> > +	struct enetc_tx_swbd xdp_redirect_arr[ENETC_MAX_SKB_FRAGS] = {0};
> >> > +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
> >> > +	struct enetc_bdr *tx_ring;
> >> > +	int xdp_tx_bd_cnt, i, k;
> >> > +	int xdp_tx_frm_cnt = 0;
> >> > +
> >> > +	tx_ring = priv->tx_ring[smp_processor_id()];
> >>
> >> What mechanism guarantees that this won't overflow the array? :)
> >
> > Which array, the array of TX rings?
>
> Yes.
>

The problem isn't even accessing an out-of-bounds element in the TX ring array.

As it turns out, I had a relatively superficial understanding of how
things are organized, but let me try to explain.

The number of TX rings is a configurable resource (between PFs and VFs)
and we read the capability at probe time:

enetc_get_si_caps:
	val = enetc_rd(hw, ENETC_SICAPR0);
	si->num_rx_rings = (val >> 16) & 0xff;
	si->num_tx_rings = val & 0xff;

enetc_init_si_rings_params:
	priv->num_tx_rings = si->num_tx_rings;

In any case, the TX array is declared as:

struct enetc_ndev_priv {
	struct enetc_bdr *tx_ring[16];
	struct enetc_bdr *rx_ring[16];
};

because that's the maximum hardware capability.

The priv->tx_ring array is populated in:

enetc_alloc_msix:
	/* # of tx rings per int vector */
	v_tx_rings = priv->num_tx_rings / priv->bdr_int_num;

	for (i = 0; i < priv->bdr_int_num; i++) {
		for (j = 0; j < v_tx_rings; j++) {
			if (priv->bdr_int_num == ENETC_MAX_BDR_INT)
				idx = 2 * j + i; /* 2 CPUs */
			else
				idx = j + i * v_tx_rings; /* default */

			priv->tx_ring[idx] = bdr;
		}
	}

priv->bdr_int_num is set to "num_online_cpus()".
On LS1028A, it can be either 1 or 2 (and the ENETC_MAX_BDR_INT macro is
equal to 2).

Otherwise said, the convoluted logic above does the following:
- It affines an MSI interrupt vector per CPU
- It affines an RX ring per MSI vector, hence per CPU
- It balances the fixed number of TX rings (say 8) among the available
  MSI vectors, hence CPUs (say 2). It does this by iterating with i
  through the RX MSI interrupt vectors, and with j through the number of
  TX rings per MSI vector.

This logic maps:
- the even TX rings to CPU 0 and the odd TX rings to CPU 1, if 2 CPUs
  are used
- all TX rings to CPU 0, if 1 CPU is used

This is done because we have this logic in enetc_poll:

	for (i = 0; i < v->count_tx_rings; i++)
		if (!enetc_clean_tx_ring(&v->tx_ring[i], budget))
			complete = false;

for processing the TX completions of a given group of TX rings in the RX
MSI interrupt handler of a certain CPU.

Otherwise said, priv->tx_ring[i] is always BD ring i, and that mapping
never changes. All 8 TX rings are enabled and available for use.

What I knew about tc-taprio and tc-mqprio is that they only enqueue to
TX queues [0, num_tc-1] because of this, as it turns out:

enetc_xmit:
	tx_ring = priv->tx_ring[skb->queue_mapping];

where skb->queue_mapping is given by:
	err = netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
and by this, respectively, from the mqprio code path:
	netif_set_real_num_tx_queues(ndev, num_tc);

As for why XDP works, and priv->tx_ring[smp_processor_id()] is:
- TX ring 0 for CPU 0 and TX ring 1 for CPU 1, if 2 CPUs are used
- TX ring 0, if 1 CPU is used

The TX completions in the first case are handled by:
- CPU 0 for TX ring 0 (because it is even) and CPU 1 for TX ring 1
  (because it is odd), if 2 CPUs are used, due to the mapping I talked
  about earlier
- CPU 0 if only 1 CPU is used

> > You mean that it's possible to receive a TC_SETUP_QDISC_MQPRIO or
> > TC_SETUP_QDISC_TAPRIO with num_tc == 1, and we have 2 CPUs?
>
> Not just that, this ndo can be called on arbitrary CPUs after a
> redirect. The code just calls through from the XDP receive path so which
> CPU it ends up on depends on the RSS+IRQ config of the other device,
> which may not even be the same driver; i.e., you have no control over
> that... :)
>

What do you mean by "arbitrary" CPU? You can't plug CPUs in, it's a dual
core system... Why does the source ifindex matter at all? I'm using the
TX ring affined to the CPU that ndo_xdp_xmit is currently running on.

> > Well, yeah, I don't know what's the proper way to deal with that. Ideas?
>
> Well the obvious one is just:
>
> tx_ring = priv->tx_ring[smp_processor_id() % num_ring_ids];
>
> and then some kind of locking to deal with multiple CPUs accessing the
> same TX ring...

By multiple CPUs accessing the same TX ring, you mean locking between
ndo_xdp_xmit and ndo_start_xmit? Can that even happen if the hardware
architecture is to have at least as many TX rings as CPUs?

Because otherwise, I see that ndo_xdp_xmit is only called from
xdp_do_flush, which is in softirq context, which to my very rudimentary
knowledge run with bottom halves, thus preemption, disabled? So I don't
think it's possible for ndo_xdp_xmit and ndo_xmit, or even two
ndo_xdp_xmit instances, to access the same TX ring?

Sorry, I'm sure these are trivial questions, but I would like to really
understand what I need to change and why :D
