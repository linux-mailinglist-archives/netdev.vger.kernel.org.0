Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6F54A225
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfFRNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:30:18 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:40422 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFRNaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:30:18 -0400
Received: by mail-wm1-f42.google.com with SMTP id v19so3263286wmj.5
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZIXug2fXpQlm6LSfg+7ebuVv4v5h7rVyIs7Ly/Pq4ec=;
        b=EDkWOsnXiP71Pan8G/FqHDOBKcsL2lTVMuXTvw7tnPbeC6pauRFykrENLYQXwRcOPE
         fMBLnczuOXH0wKysOau+EtchK0tuZFLKmmsY5psbuKauNJpdOgGDjbBV8UbvGIGSkcJT
         PuossePbmKrfT8dCTHzhQtKSg/Gi5BtybH5yqn3R6nTShjV323CcrMgOSBwChBfs3WuY
         RycBt+nZZ84DL4YLeJXxvmnrlZnHc0we5wzpMOeuoZyCFIdY62/i1sivHVzv+K+RYeKx
         wsymt8YxBHqhhK5J7PzPF2RJmokowZe2QBiptXSV3iAyf1eH/nM4tWPr0tM+10eEAXcl
         Ur6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZIXug2fXpQlm6LSfg+7ebuVv4v5h7rVyIs7Ly/Pq4ec=;
        b=ivAnCFsqmozN3obWntxXmzzAHyHUdMXZPv0AP1It1R4Aq+WkJnrEzH7IrbL9RIDWaV
         dknFfWd8WUMm1jNZcoUyw5zm5Ud7AB/++Apq3ch5GaDjWZeO2bFoKTVA3MEYowELblJb
         rHSIhOCj4CGKzrStgIJ6s3L4hfsVEIVgN28GjdMYIDyzuUbYpzgpND7rKuXc8Z93wu/s
         90r9GH4XLOHO8jFRWiK/Hn2XHjjIjh0nZjesjsi34lUzStNEB2+ZUi8oa41hnVxITRBZ
         vilvRLTK91CEMtRQXBZ3LvnGBW+D9t9kBMBKn+BbnIHJ9DSi5jGm6IJsetRBFFFHfrha
         QJxw==
X-Gm-Message-State: APjAAAWwhqO5ZZh0W1QBUw/Iayz6jtCYPaUusRdMvWUUevntAKjOA+/Z
        Wxwtmhsy7AfVk5xCM54u6xljMQ==
X-Google-Smtp-Source: APXvYqxqCqpaFG3JAhz8rUW/ZTsvSO8wDyArWCTrvamoJZlCgmTJEkFZFyU/hLFBA5C5Riz3pGic7Q==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr3594020wmg.65.1560864615427;
        Tue, 18 Jun 2019 06:30:15 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id l19sm1551436wmj.33.2019.06.18.06.30.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 06:30:14 -0700 (PDT)
Date:   Tue, 18 Jun 2019 16:30:12 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "toshiaki.makita1@gmail.com" <toshiaki.makita1@gmail.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "mcroce@redhat.com" <mcroce@redhat.com>
Subject: Re: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190618133012.GA2055@apalos>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
 <156045052249.29115.2357668905441684019.stgit@firesoul>
 <20190615093339.GB3771@khorivan>
 <a02856c1-46e7-4691-6bb9-e0efb388981f@mellanox.com>
 <20190618125431.GA5307@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618125431.GA5307@khorivan>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ivan, Tariq,

> >>>+
[...]
> >>
> >>What would you recommend to do for the following situation:
> >>
> >>Same receive queue is shared between 2 network devices. The receive ring is
> >>filled by pages from page_pool, but you don't know the actual port (ndev)
> >>filling this ring, because a device is recognized only after packet is
> >>received.
> >>
> >>The API is so that xdp rxq is bind to network device, each frame has
> >>reference
> >>on it, so rxq ndev must be static. That means each netdev has it's own rxq
> >>instance even no need in it. Thus, after your changes, page must be
> >>returned to
> >>the pool it was taken from, or released from old pool and recycled in
> >>new one
> >>somehow.
> >>
> >>And that is inconvenience at least. It's hard to move pages between
> >>pools w/o
> >>performance penalty. No way to use common pool either, as unreg_rxq now
> >>drops
> >>the pool and 2 rxqa can't reference same pool.
> >>
> >
> >Within the single netdev, separate page_pool instances are anyway
> >created for different RX rings, working under different NAPI's.
> 
> The circumstances are so that same RX ring is shared between 2
> netdevs... and netdev can be known only after descriptor/packet is
> received. Thus, while filling RX ring, there is no actual device,
> but when packet is received it has to be recycled to appropriate
> net device pool. Before this change there were no difference from
> which pool the page was allocated to fill RX ring, as there were no
> owner. After this change there is owner - netdev page pool.
> 
> For cpsw the dma unmap is common for both netdevs and no difference
> who is freeing the page, but there is difference which pool it's
> freed to.
Since 2 netdevs are sharing one queue you'll need locking right?
(Assuming that the rx-irq per device can end up on a different core)
We discussed that ideally page pools should be alocated per hardware queue. 
If you indeed need locking (and pay the performance penalty anyway) i wonder if
there's anything preventing you from keeping the same principle, i.e allocate a
pool per queue and handle the recycling to the proper ndev internally.
That way only the first device will be responsible of
allocating/recycling/maintaining the pool state.

> 
> So that, while filling RX ring the page is taken from page pool of
> ndev1, but packet is received for ndev2, it has to be later
> returned/recycled to page pool of ndev1, but when xdp buffer is
> handed over to xdp prog the xdp_rxq_info has reference on ndev2 ...
> 
> And no way to predict the final ndev before packet is received, so no
> way to choose appropriate page pool as now it becomes page owner.
> 
> So, while RX ring filling, the page/dma recycling is needed but should
> be some way to identify page owner only after receiving packet.
> 
> Roughly speaking, something like:
> 
> pool->pages_state_hold_cnt++;
> 
> outside of page allocation API, after packet is received.
> and free of the counter while allocation (w/o owing the page).
If handling it internally is not an option maybe we can sort something out for
special devices


Thanks
/Ilias
