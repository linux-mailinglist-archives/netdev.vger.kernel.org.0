Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1E23FD550
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 10:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243175AbhIAIZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 04:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242961AbhIAIZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 04:25:04 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E957C061575;
        Wed,  1 Sep 2021 01:24:08 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id c79so2741097oib.11;
        Wed, 01 Sep 2021 01:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mu0u756JuxJy3ISlVCl3fsggBtaeErrnWb4pupBSB2U=;
        b=m/88ywnuHnGoqlZI+DNQimhUgiR+FiovN9zKFAmiR9cIJvLiZoaOchwd1bOpE3X4Jt
         IdVBhd2r4yudw2pJPSbnc7ZQ2wEKfo6XSE9j1AtjLn21DnETC0ReONwovK5k/XOCyV0U
         wuQl1T4IN/capl+jMgIgcZ6Ufibxj3wZlFoYiDvCVEhFhwGlkfmqDpx1dC5jg4aNhg2j
         K7CF3UfTJV7sVel3LsMccvFkSPBqmRso2Gxjap/mo0S3eTmN2MJqFL+8ZaUdvc0ogq5R
         AQo7boMGrvDrdFrP82PFZamNQxPeP60V6iXAgx/10ymMfmsDD/EXCCNcXlmY3Sdm6m/i
         Y/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mu0u756JuxJy3ISlVCl3fsggBtaeErrnWb4pupBSB2U=;
        b=chj/lY+fQo5o5Ar1v2pZAzvyYq8TPPw1UcpIz5ds7SDvyTeXRey6kAR61LxJJpFXaE
         s3t5I13AO/20dU62NZUCeTh2Pctj9Ydst1EswzXXDYOr7hFCAGsV15lES8Z16JblTK08
         vdgmzuyW2Ee4Uxo5TdMB2ZC1zY2w7FH6PC4p9HUxejgsYUC82X8XI6civ/xle7t0ida5
         DC7VXzrnJ4iQWHxRRgcXP1S8yT4kWeVDM4YzscbBVis4dcMsORHOqdw+dQ/9+AUGgzqe
         FuWfW01pVohB2oAxabhtcwnelH/FBm+4dAtXyNlWnVQ95eFULHtZzy8SKbVaYeVZaGqZ
         DPcw==
X-Gm-Message-State: AOAM532RojJA3SmBBnzq3ByVojkujh0sfsxvy8yXLVNOLaM35PEfQvrZ
        VFXCyy781o2ia0VwCLd/Y0zuCyzGWy9lVob/Bj8=
X-Google-Smtp-Source: ABdhPJyjgtkycA8j6p8gveR+0QWz4gp3XaGTF4BKU0iZwIOpL66TfCRzkDdmSGy1sOWuDcsHJiYVYJXFKqSjjVDGjms=
X-Received: by 2002:a05:6808:208b:: with SMTP id s11mr6395419oiw.95.1630484647299;
 Wed, 01 Sep 2021 01:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210901044933.47230-1-kerneljasonxing@gmail.com>
 <7ca5bca6-16eb-4102-0b29-504edb80a21b@gmail.com> <CAL+tcoChbdau88Ge2A4DntnNHisEZtg8cBHd6J55LR0ZYCRNWQ@mail.gmail.com>
In-Reply-To: <CAL+tcoChbdau88Ge2A4DntnNHisEZtg8cBHd6J55LR0ZYCRNWQ@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 1 Sep 2021 16:23:30 +0800
Message-ID: <CAL+tcoD0XJQDQTUK9jn23ZddMQfW1ry12DqsuV14RbxvopWprQ@mail.gmail.com>
Subject: Re: [PATCH v6] ixgbe: let the xdpdrv work with more than 64 cpus
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        kernel test robot <lkp@intel.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 3:20 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> On Wed, Sep 1, 2021 at 1:13 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> >
> > On 8/31/21 9:49 PM, kerneljasonxing@gmail.com wrote:
> > > From: Jason Xing <xingwanli@kuaishou.com>
> > >
> > > Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> > > server is equipped with more than 64 cpus online. So it turns out that
> > > the loading of xdpdrv causes the "NOMEM" failure.
> > >
> > > Actually, we can adjust the algorithm and then make it work through
> > > mapping the current cpu to some xdp ring with the protect of @tx_lock.
> > >
> > > Here're some numbers before/after applying this patch with xdp-example
> > > loaded on the eth0X:
> > >
> > > As client (tx path):
> > >                      Before    After
> > > TCP_STREAM send-64   734.14    714.20
> > > TCP_STREAM send-128  1401.91   1395.05
> > > TCP_STREAM send-512  5311.67   5292.84
> > > TCP_STREAM send-1k   9277.40   9356.22 (not stable)
> > > TCP_RR     send-1    22559.75  21844.22
> > > TCP_RR     send-128  23169.54  22725.13
> > > TCP_RR     send-512  21670.91  21412.56
> > >
> > > As server (rx path):
> > >                      Before    After
> > > TCP_STREAM send-64   1416.49   1383.12
> > > TCP_STREAM send-128  3141.49   3055.50
> > > TCP_STREAM send-512  9488.73   9487.44
> > > TCP_STREAM send-1k   9491.17   9356.22 (not stable)
> > > TCP_RR     send-1    23617.74  23601.60
> > > ...
> > >
> > > Notice: the TCP_RR mode is unstable as the official document explaines.
> > >
> > > I tested many times with different parameters combined through netperf.
> > > Though the result is not that accurate, I cannot see much influence on
> > > this patch. The static key is places on the hot path, but it actually
> > > shouldn't cause a huge regression theoretically.
> > >
> > > Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > > ---
> > > v6:
> > > - Move the declaration of static-key to the proper position (Test Robot)
> > > - Add reported-by tag (Jason)
> > > - Add more detailed performance test results (Jason)
> > >
> > > v5:
> > > - Change back to nr_cpu_ids (Eric)
> > >
> > > v4:
> > > - Update the wrong commit messages. (Jason)
> > >
> > > v3:
> > > - Change nr_cpu_ids to num_online_cpus() (Maciej)
> > > - Rename MAX_XDP_QUEUES to IXGBE_MAX_XDP_QS (Maciej)
> > > - Rename ixgbe_determine_xdp_cpu() to ixgbe_determine_xdp_q_idx() (Maciej)
> > > - Wrap ixgbe_xdp_ring_update_tail() with lock into one function (Maciej)
> > >
> > > v2:
> > > - Adjust cpu id in ixgbe_xdp_xmit(). (Jesper)
> > > - Add a fallback path. (Maciej)
> > > - Adjust other parts related to xdp ring.
> > > ---
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe.h           | 15 ++++-
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |  9 ++-
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 64 ++++++++++++++++------
> > >  .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |  1 +
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  9 +--
> > >  5 files changed, 73 insertions(+), 25 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> > > index a604552..1dcddea 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> > > @@ -351,6 +351,7 @@ struct ixgbe_ring {
> > >       };
> > >       u16 rx_offset;
> > >       struct xdp_rxq_info xdp_rxq;
> > > +     spinlock_t tx_lock;     /* used in XDP mode */
> > >       struct xsk_buff_pool *xsk_pool;
> > >       u16 ring_idx;           /* {rx,tx,xdp}_ring back reference idx */
> > >       u16 rx_buf_len;
> > > @@ -375,11 +376,13 @@ enum ixgbe_ring_f_enum {
> > >  #define IXGBE_MAX_FCOE_INDICES               8
> > >  #define MAX_RX_QUEUES                        (IXGBE_MAX_FDIR_INDICES + 1)
> > >  #define MAX_TX_QUEUES                        (IXGBE_MAX_FDIR_INDICES + 1)
> > > -#define MAX_XDP_QUEUES                       (IXGBE_MAX_FDIR_INDICES + 1)
> > > +#define IXGBE_MAX_XDP_QS             (IXGBE_MAX_FDIR_INDICES + 1)
> > >  #define IXGBE_MAX_L2A_QUEUES         4
> > >  #define IXGBE_BAD_L2A_QUEUE          3
> > >  #define IXGBE_MAX_MACVLANS           63
> > >
> > > +DECLARE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
> > > +
> > >  struct ixgbe_ring_feature {
> > >       u16 limit;      /* upper limit on feature indices */
> > >       u16 indices;    /* current value of indices */
> > > @@ -629,7 +632,7 @@ struct ixgbe_adapter {
> > >
> > >       /* XDP */
> > >       int num_xdp_queues;
> > > -     struct ixgbe_ring *xdp_ring[MAX_XDP_QUEUES];
> > > +     struct ixgbe_ring *xdp_ring[IXGBE_MAX_XDP_QS];
> > >       unsigned long *af_xdp_zc_qps; /* tracks AF_XDP ZC enabled rings */
> > >
> > >       /* TX */
> > > @@ -772,6 +775,14 @@ struct ixgbe_adapter {
> > >  #endif /* CONFIG_IXGBE_IPSEC */
> > >  };
> > >
> > > +static inline int ixgbe_determine_xdp_q_idx(int cpu)
> > > +{
> > > +     if (static_key_enabled(&ixgbe_xdp_locking_key))
> > > +             return cpu % IXGBE_MAX_XDP_QS;
> > > +     else
> > > +             return cpu;
> > > +}
> > > +
> > >  static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
> > >  {
> > >       switch (adapter->hw.mac.type) {
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > > index 0218f6c..86b1116 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > > @@ -299,7 +299,10 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
> > >
> > >  static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
> > >  {
> > > -     return adapter->xdp_prog ? nr_cpu_ids : 0;
> > > +     int queues;
> > > +
> > > +     queues = min_t(int, IXGBE_MAX_XDP_QS, nr_cpu_ids);
> > > +     return adapter->xdp_prog ? queues : 0;
> > >  }
> > >
> > >  #define IXGBE_RSS_64Q_MASK   0x3F
> > > @@ -947,6 +950,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
> > >               ring->count = adapter->tx_ring_count;
> > >               ring->queue_index = xdp_idx;
> > >               set_ring_xdp(ring);
> > > +             spin_lock_init(&ring->tx_lock);
> > >
> > >               /* assign ring to adapter */
> > >               WRITE_ONCE(adapter->xdp_ring[xdp_idx], ring);
> > > @@ -1032,6 +1036,9 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
> > >       adapter->q_vector[v_idx] = NULL;
> > >       __netif_napi_del(&q_vector->napi);
> > >
> > > +     if (static_key_enabled(&ixgbe_xdp_locking_key))
> > > +             static_branch_dec(&ixgbe_xdp_locking_key);
> > > +
> > >       /*
> > >        * after a call to __netif_napi_del() napi may still be used and
> > >        * ixgbe_get_stats64() might access the rings on this vector,
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > index 14aea40..bec29f5 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > @@ -165,6 +165,9 @@ static int ixgbe_notify_dca(struct notifier_block *, unsigned long event,
> > >  MODULE_DESCRIPTION("Intel(R) 10 Gigabit PCI Express Network Driver");
> > >  MODULE_LICENSE("GPL v2");
> > >
> > > +DEFINE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
> > > +EXPORT_SYMBOL(ixgbe_xdp_locking_key);
> > > +
> > >  static struct workqueue_struct *ixgbe_wq;
> > >
> > >  static bool ixgbe_check_cfg_remove(struct ixgbe_hw *hw, struct pci_dev *pdev);
> > > @@ -2422,13 +2425,10 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
> > >               xdp_do_flush_map();
> > >
> > >       if (xdp_xmit & IXGBE_XDP_TX) {
> > > -             struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
> > > +             int index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> > > +             struct ixgbe_ring *ring = adapter->xdp_ring[index];
> > >
> > > -             /* Force memory writes to complete before letting h/w
> > > -              * know there are new descriptors to fetch.
> > > -              */
> > > -             wmb();
> > > -             writel(ring->next_to_use, ring->tail);
> > > +             ixgbe_xdp_ring_update_tail_locked(ring);
> > >       }
> > >
> > >       u64_stats_update_begin(&rx_ring->syncp);
> > > @@ -6320,7 +6320,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
> > >       if (ixgbe_init_rss_key(adapter))
> > >               return -ENOMEM;
> > >
> > > -     adapter->af_xdp_zc_qps = bitmap_zalloc(MAX_XDP_QUEUES, GFP_KERNEL);
> > > +     adapter->af_xdp_zc_qps = bitmap_zalloc(IXGBE_MAX_XDP_QS, GFP_KERNEL);
> > >       if (!adapter->af_xdp_zc_qps)
> > >               return -ENOMEM;
> > >
> > > @@ -8539,21 +8539,32 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
> > >  int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
> > >                       struct xdp_frame *xdpf)
> > >  {
> > > -     struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
> > >       struct ixgbe_tx_buffer *tx_buffer;
> > >       union ixgbe_adv_tx_desc *tx_desc;
> > > +     struct ixgbe_ring *ring;
> > >       u32 len, cmd_type;
> > >       dma_addr_t dma;
> > > +     int index, ret;
> > >       u16 i;
> > >
> > >       len = xdpf->len;
> > >
> > > -     if (unlikely(!ixgbe_desc_unused(ring)))
> > > -             return IXGBE_XDP_CONSUMED;
> > > +     index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> > > +     ring = adapter->xdp_ring[index];
> > > +
> > > +     if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> > > +             spin_lock(&ring->tx_lock);
> > > +
> > > +     if (unlikely(!ixgbe_desc_unused(ring))) {
> > > +             ret = IXGBE_XDP_CONSUMED;
> > > +             goto out;
> > > +     }
> > >
> > >       dma = dma_map_single(ring->dev, xdpf->data, len, DMA_TO_DEVICE);
> > > -     if (dma_mapping_error(ring->dev, dma))
> > > -             return IXGBE_XDP_CONSUMED;
> > > +     if (dma_mapping_error(ring->dev, dma)) {
> > > +             ret = IXGBE_XDP_CONSUMED;
> > > +             goto out;
> > > +     }
> > >
> > >       /* record the location of the first descriptor for this packet */
> > >       tx_buffer = &ring->tx_buffer_info[ring->next_to_use];
> > > @@ -8590,7 +8601,11 @@ int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
> > >       tx_buffer->next_to_watch = tx_desc;
> > >       ring->next_to_use = i;
> > >
> > > -     return IXGBE_XDP_TX;
> > > +     ret = IXGBE_XDP_TX;
> > > +out:
> > > +     if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> > > +             spin_unlock(&ring->tx_lock);
> > > +     return ret;
> > >  }
> > >
> > >  netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
> > > @@ -10130,8 +10145,13 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
> > >                       return -EINVAL;
> > >       }
> > >
> > > -     if (nr_cpu_ids > MAX_XDP_QUEUES)
> > > +     /* if the number of cpus is much larger than the maximum of queues,
> > > +      * we should stop it and then return with NOMEM like before.
> > > +      */
> > > +     if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
> > >               return -ENOMEM;
> > > +     else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
> > > +             static_branch_inc(&ixgbe_xdp_locking_key);
> > >
> > >       old_prog = xchg(&adapter->xdp_prog, prog);
> > >       need_reset = (!!prog != !!old_prog);
> > > @@ -10195,12 +10215,22 @@ void ixgbe_xdp_ring_update_tail(struct ixgbe_ring *ring)
> > >       writel(ring->next_to_use, ring->tail);
> > >  }
> > >
> > > +void ixgbe_xdp_ring_update_tail_locked(struct ixgbe_ring *ring)
> > > +{
> > > +     if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> > > +             spin_lock(&ring->tx_lock);
> > > +     ixgbe_xdp_ring_update_tail(ring);
> > > +     if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> > > +             spin_unlock(&ring->tx_lock);
> > > +}
> >
> > It is not clear why you use a pair of spin_lock()/unlock for each ixgbe_xmit_xdp_ring()
> > call, plus one other for ixgbe_xdp_ring_update_tail()
> >
> > I guess this could be factorized to a single spin lock/unlock in ixgbe_xdp_xmit(),
> > and thus not have this ixgbe_xdp_ring_update_tail_locked() helper ?
> >
>
> I agree with what you said in ixgbe_xdp_xmit(). Two pairs of
> spin_lock/unlock could be factorized to a single one, which could
> decrease the times of calling lock and unlock.
>

Wait, Eric. It seems that this could decrease the times of calling.
However, this behaviour brings other changes about adding spin
lock/unlock in ixgbe_run_xdp() and ixgbe_run_xdp_zc(). Is that
necessary?

Well, now, I'm a little bit convinced that what you said is the right
way to go though I have to change some codes in ixgbe_run_xdp()/_zc().

> Thanks,
> Jason
>
> > > +
> > >  static int ixgbe_xdp_xmit(struct net_device *dev, int n,
> > >                         struct xdp_frame **frames, u32 flags)
> > >  {
> > >       struct ixgbe_adapter *adapter = netdev_priv(dev);
> > >       struct ixgbe_ring *ring;
> > >       int nxmit = 0;
> > > +     int index;
> > >       int i;
> > >
> > >       if (unlikely(test_bit(__IXGBE_DOWN, &adapter->state)))
> > > @@ -10209,10 +10239,12 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
> > >       if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> > >               return -EINVAL;
> > >
> > > +     index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> > > +
> > >       /* During program transitions its possible adapter->xdp_prog is assigned
> > >        * but ring has not been configured yet. In this case simply abort xmit.
> > >        */
> > > -     ring = adapter->xdp_prog ? adapter->xdp_ring[smp_processor_id()] : NULL;
> > > +     ring = adapter->xdp_prog ? adapter->xdp_ring[index] : NULL;
> > >       if (unlikely(!ring))
> > >               return -ENXIO;
> > >
> > > @@ -10230,7 +10262,7 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
> > >       }
> > >
> > >       if (unlikely(flags & XDP_XMIT_FLUSH))
> > > -             ixgbe_xdp_ring_update_tail(ring);
> > > +             ixgbe_xdp_ring_update_tail_locked(ring);
> > >
> > >       return nxmit;
> > >  }
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> > > index 2aeec78..f6426d9 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> > > @@ -23,6 +23,7 @@ void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
> > >  void ixgbe_rx_skb(struct ixgbe_q_vector *q_vector,
> > >                 struct sk_buff *skb);
> > >  void ixgbe_xdp_ring_update_tail(struct ixgbe_ring *ring);
> > > +void ixgbe_xdp_ring_update_tail_locked(struct ixgbe_ring *ring);
> > >  void ixgbe_irq_rearm_queues(struct ixgbe_adapter *adapter, u64 qmask);
> > >
> > >  void ixgbe_txrx_ring_disable(struct ixgbe_adapter *adapter, int ring);
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> > > index b1d22e4..82d00e4 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> > > @@ -334,13 +334,10 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
> > >               xdp_do_flush_map();
> > >
> > >       if (xdp_xmit & IXGBE_XDP_TX) {
> > > -             struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
> > > +             int index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> > > +             struct ixgbe_ring *ring = adapter->xdp_ring[index];
> > >
> > > -             /* Force memory writes to complete before letting h/w
> > > -              * know there are new descriptors to fetch.
> > > -              */
> > > -             wmb();
> > > -             writel(ring->next_to_use, ring->tail);
> > > +             ixgbe_xdp_ring_update_tail_locked(ring);
> > >       }
> > >
> > >       u64_stats_update_begin(&rx_ring->syncp);
> > >
