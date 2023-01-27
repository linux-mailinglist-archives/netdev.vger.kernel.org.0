Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782D767E655
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbjA0NPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbjA0NPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:15:46 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242EDEF9D
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:15:18 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d132so5929778ybb.5
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lC39G5119m5qR2WHncEwv0NVNN8KnNdOo+BCexcPzb8=;
        b=LUe+k+rGllZV0hx8waVOjnEpMiHXZyibvkzGFbZbx0ov82aAUSQZSnUs9Wi8fFShqp
         zuLfFcFvyWQgywP9pcohbrmnf3Oq+54vnWoanHq1fnwydLN+yPC6HYgz77qrOyxjsd5C
         mo5epqsXv8kskQYS0DRJVwU9frqd0u+pI4rdO5/8e65/peJ5CstXysX5wK3TF7EaPafl
         p+s7AQj0nm3dHpvG0qOPSrOlpB0f98JKCwps5yhy4ODzzakeqyM+JVpHgfZAZCHPRjYj
         HVdyZYSN3un8Tx0+MiQ+joL2B/HnGdEZq7CdwFrs9f04jSowax2yl9nPTAzA/BJ55otv
         SNiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lC39G5119m5qR2WHncEwv0NVNN8KnNdOo+BCexcPzb8=;
        b=088fYrICUpCPqXNrp8B3UvOetl/NN+V02acCVpUT33heXdggAB6Ei7lNtawUvXdeZD
         DMa7ogffYhgQBmsLQR3X4pGjWfXkjlUjx5Awn2f2DNKrReAlxPnsGU9lyMXu+7S+7nkw
         XGKF7gcm1dzL8g3YxTozoIS4YDDbhPtlPMwszFdbr2+tsSKFjANG9vEfqejt+Uqs/5ZZ
         dc64p1d9QSVvFCsMwDOA6fCp5g5oY6Sq6Qxw30gTp3Evw4KrfgkALVEna2u7ZWX5pr6c
         uFaw8ZeHk5T8xSY5JoD4bwwjvl9DDKADLrin19FZE91ACkngAvzpGMyuQieMtg5WehSc
         wKhQ==
X-Gm-Message-State: AFqh2kp1Q25tS6nMDwUiU/Rn73llQFFmQUqrYHyuf/7Xo8naCvlrHH+8
        7zVAR1xOeDkl89SQaoQf9Rjk/zCVohNsWMmJ/IA=
X-Google-Smtp-Source: AMrXdXsJW3pTyOrtP+/TfvqSTTG+uN6lXJw5JG4DkiQGA+5dyyEEoipagKShC1/Cxryrw8Wzs908OlagcP0aPWqlqS0=
X-Received: by 2002:a25:bf83:0:b0:7fe:75bb:d85f with SMTP id
 l3-20020a25bf83000000b007fe75bbd85fmr4419081ybk.539.1674825286864; Fri, 27
 Jan 2023 05:14:46 -0800 (PST)
MIME-Version: 1.0
References: <20230112140743.7438-1-u9012063@gmail.com> <450e40d1-cec6-ba81-90c3-276eeddd1dd1@intel.com>
 <CALDO+SYoQ5OaEdxFGh8Xr5Y-kDzGB679F+fSKQGsk-4=i4vOaA@mail.gmail.com> <af962003-5d03-ae00-0f05-085fc74add6c@intel.com>
In-Reply-To: <af962003-5d03-ae00-0f05-085fc74add6c@intel.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 27 Jan 2023 05:14:10 -0800
Message-ID: <CALDO+SZTyXyuCn6X_qkiMwtOjYPDWmqZnDJ0vQF3K-9_XgFUBA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v13] vmxnet3: Add XDP support.
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev@vger.kernel.org, jsankararama@vmware.com, gyang@vmware.com,
        doshir@vmware.com, alexander.duyck@gmail.com,
        gerhard@engleder-embedded.com, bang@vmware.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,
Thanks for your feedback.

On Tue, Jan 24, 2023 at 2:47 AM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: William Tu <u9012063@gmail.com>
> Date: Sat, 21 Jan 2023 10:29:28 -0800
>
> > On Wed, Jan 18, 2023 at 6:17 AM Alexander Lobakin
> > <alexandr.lobakin@intel.com> wrote:
> >>
> >> From: William Tu <u9012063@gmail.com>
> >> Date: Thu, 12 Jan 2023 06:07:43 -0800
>
> [...]
>
> >>> +static int
> >>> +vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
> >>> +               struct vmxnet3_rx_queue *rq, int size)
> >>> +{
> >>> +     const struct page_pool_params pp_params = {
> >>> +             .order = 0,
> >>
> >> Nit: it will be zeroed implicitly, so can be omitted. OTOH if you want
> >> to explicitly say that you always use order-0 pages only, you can leave
> >> it here.
> > I will leave it here as it's more clear.
>
> +
>
> >
> >>
> >>> +             .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> >>> +             .pool_size = size,
> >>> +             .nid = NUMA_NO_NODE,
> >>> +             .dev = &adapter->pdev->dev,
> >>> +             .offset = XDP_PACKET_HEADROOM,
> >>
> >> Curious, on which architectures does this driver work in the real world?
> >> Is it x86 only or maybe 64-bit systems only? Because not having
> >> %NET_IP_ALIGN here will significantly slow down Rx on the systems where
> >> it's defined as 2, not 0 (those systems can't stand unaligned access).
>
> [...]
>
> >>> @@ -1730,6 +1863,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
> >>>               vmxnet3_getRxComp(rcd,
> >>>                                 &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
> >>>       }
> >>> +     if (need_flush)
> >>> +             xdp_do_flush();
> >>
> >> What about %XDP_TX? On each %XDP_TX we usually only place the frame to a
> >> Tx ring and hit the doorbell to kick Tx only here, before xdp_do_flush().
> >
> > I think it's ok here. For XDP_TX, we place the frame to tx ring and wait until
> > a threshold (%tq->shared->txThreshold), then hit the doorbell.
>
> What if it didn't reach the threshold and the NAPI poll cycle is
> finished? It will stay on the ring without hitting the doorbell?

Good catch... Actually we don't need to do anything here.
The backend driver at hypervisor side will poll packets from the tx queues,
transmit these packets, and reset the %tq->shared->txThreshold to zero.
I should add a comment in the source code.

>
> >
> >>
> >>>
> >>>       return num_pkts;
> >>>  }
> >>> @@ -1755,13 +1890,20 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
> >>>                               &rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
> >>>
> >>>                       if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> >>> -                                     rq->buf_info[ring_idx][i].skb) {
> >>> +                         rq->buf_info[ring_idx][i].pp_page &&
> >>> +                         rq->buf_info[ring_idx][i].buf_type ==
> >>> +                         VMXNET3_RX_BUF_XDP) {
> >>> +                             page_pool_recycle_direct(rq->page_pool,
> >>> +                                                      rq->buf_info[ring_idx][i].pp_page);
> >>> +                             rq->buf_info[ring_idx][i].pp_page = NULL;
> >>> +                     } else if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
> >>> +                                rq->buf_info[ring_idx][i].skb) {
> >>>                               dma_unmap_single(&adapter->pdev->dev, rxd->addr,
> >>>                                                rxd->len, DMA_FROM_DEVICE);
> >>>                               dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
> >>>                               rq->buf_info[ring_idx][i].skb = NULL;
> >>>                       } else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
> >>> -                                     rq->buf_info[ring_idx][i].page) {
> >>> +                                rq->buf_info[ring_idx][i].page) {
> >>>                               dma_unmap_page(&adapter->pdev->dev, rxd->addr,
> >>>                                              rxd->len, DMA_FROM_DEVICE);
> >>>                               put_page(rq->buf_info[ring_idx][i].page);
> >>> @@ -1786,9 +1928,9 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
> >>>
> >>>       for (i = 0; i < adapter->num_rx_queues; i++)
> >>>               vmxnet3_rq_cleanup(&adapter->rx_queue[i], adapter);
> >>> +     rcu_assign_pointer(adapter->xdp_bpf_prog, NULL);
> >>>  }
> >>>
> >>> -
> >>
> >> (nit: also unrelated)
> >>
> >>>  static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
> >>>                              struct vmxnet3_adapter *adapter)
> >>>  {
> >>> @@ -1815,6 +1957,13 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
> >>>               }
> >>>       }
> >>>
> >>> +     if (rq->page_pool) {
> >>
> >> Isn't it always true? You always create a Page Pool per each RQ IIUC?
> > good catch, will remove the check.
> >
> >>
> >>> +             if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
> >>> +                     xdp_rxq_info_unreg(&rq->xdp_rxq);
> >>> +             page_pool_destroy(rq->page_pool);
> >>> +             rq->page_pool = NULL;
> >>> +     }
> >>> +
> >>>       if (rq->data_ring.base) {
> >>>               dma_free_coherent(&adapter->pdev->dev,
> >>>                                 rq->rx_ring[0].size * rq->data_ring.desc_size,
> >>
> >> [...]
> >>
> >>> -static int
> >>> +int
> >>>  vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
> >>>  {
> >>>       int i, err = 0;
> >>> @@ -2585,7 +2742,7 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
> >>>       if (adapter->netdev->features & NETIF_F_RXCSUM)
> >>>               devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
> >>>
> >>> -     if (adapter->netdev->features & NETIF_F_LRO) {
> >>> +     if ((adapter->netdev->features & NETIF_F_LRO)) {
> >>
> >> Unneeded change (moreover, Clang sometimes triggers on such on W=1+)
> >>
> >>>               devRead->misc.uptFeatures |= UPT1_F_LRO;
> >>>               devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
> >>>       }
> >>> @@ -3026,7 +3183,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
> >>>  }
> >>>
> >>>
> >>> -static void
> >>> +void
> >>>  vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
> >>>  {
> >>>       size_t sz, i, ring0_size, ring1_size, comp_size;
> >>> @@ -3035,7 +3192,8 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
> >>>               if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
> >>>                                           VMXNET3_MAX_ETH_HDR_SIZE) {
> >>>                       adapter->skb_buf_size = adapter->netdev->mtu +
> >>> -                                             VMXNET3_MAX_ETH_HDR_SIZE;
> >>> +                                             VMXNET3_MAX_ETH_HDR_SIZE +
> >>> +                                             vmxnet3_xdp_headroom(adapter);
> >>>                       if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
> >>>                               adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
> >>>
> >>> @@ -3563,7 +3721,6 @@ vmxnet3_reset_work(struct work_struct *data)
> >>>       clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> >>>  }
> >>>
> >>> -
> >>
> >> (unrelated)
> >>
> >>>  static int
> >>>  vmxnet3_probe_device(struct pci_dev *pdev,
> >>>                    const struct pci_device_id *id)
> >>
> >> [...]
> >>
> >>>  enum vmxnet3_rx_buf_type {
> >>>       VMXNET3_RX_BUF_NONE = 0,
> >>>       VMXNET3_RX_BUF_SKB = 1,
> >>> -     VMXNET3_RX_BUF_PAGE = 2
> >>> +     VMXNET3_RX_BUF_PAGE = 2,
> >>> +     VMXNET3_RX_BUF_XDP = 3
> >>
> >> I'd always leave a ',' after the last entry. As you can see, if you
> >> don't do that, you have to introduce 2 lines of changes instead of just
> >> 1 when you add a new entry.
> > thanks, that's good point. Will do it, thanks!
> >
> >>
> >>>  };
> >>>
> >>>  #define VMXNET3_RXD_COMP_PENDING        0
> >>> @@ -271,6 +279,7 @@ struct vmxnet3_rx_buf_info {
> >>>       union {
> >>>               struct sk_buff *skb;
> >>>               struct page    *page;
> >>> +             struct page    *pp_page; /* Page Pool for XDP frame */
> >>
> >> Why not just use the already existing field if they're of the same type?
> >
> > I guess in the beginning I want to avoid mixing the two cases/rings.
> > I will use just %page as you suggest.
> >
> >>
> >>>       };
> >>>       dma_addr_t dma_addr;
> >>>  };
> >>
> >> [...]
> >>
> >>> +static int
> >>> +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> >>> +             struct netlink_ext_ack *extack)
> >>> +{
> >>> +     struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> >>> +     struct bpf_prog *new_bpf_prog = bpf->prog;
> >>> +     struct bpf_prog *old_bpf_prog;
> >>> +     bool need_update;
> >>> +     bool running;
> >>> +     int err = 0;
> >>> +
> >>> +     if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
> >>
> >> Mismatch: as I said before, %VMXNET3_XDP_MAX_MTU is not MTU, rather max
> >> frame len. At the same time, netdev->mtu is real MTU, which doesn't
> >> include Eth, VLAN and FCS.
> >
> > Thanks!
> > So I should include the hardware header length, define s.t like
> > #define VMXNET3_RX_OFFSET       (XDP_PACKET_HEADROOM + NET_IP_ALIGN)
> > #define VMXNET3_XDP_MAX_MTU    PAGE_SIZE - VMXNET3_RX_OFFSET -
> > dev->hard_header_len
>
> Hmm, since your netdev is always Ethernet, you can hardcode %ETH_HLEN.
> OTOH don't forget to include 2 VLANs, FCS and tailroom:
>
> #define VMXNET3_RX_OFFSET       (XDP_PACKET_HEADROOM + NET_IP_ALIGN)
> #define VMXNET3_RX_TAILROOOM    SKB_DATA_ALIGN(sizeof(skb_shared_info))
> #define VMXNET3_RX_MAX_FRAME    (PAGE_SIZE - VMXNET3_RX_OFFSET - \
>                                  VMXNET3_RX_TAILROOM)
> #define VMXNET3_RX_MAX_MTU      (VMXNET3_RX_MAX_FRAME - ETH_HLEN - \
>                                  2 * VLAN_HLEN - ETH_FCS_LEN)
>
> Then it will be your max MTU :)
> dev->hard_header_len is also ok, but it's always %ETH_HLEN for Ethernet
> devices.

Thanks a lot :)

>
> >
> >>
> >>> +             NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> >>
> >> Any plans to add XDP multi-buffer support?
> >>
> >>> +             return -EOPNOTSUPP;
> >>> +     }
> >>> +
> >>> +     if ((adapter->netdev->features & NETIF_F_LRO)) {
> >>
> >> (redundant braces)
> >>
> >>> +             netdev_err(adapter->netdev, "LRO is not supported with XDP");
> >>
> >> Why is this error printed via netdev_err(), not NL_SET()?
> >
> > I want to show the error message in dmesg, which I didn't see it
> > printed when using NL_SET
> > is it better to use NL_SET?
>
> When &netlink_ext_ack is available, it's better to use it instead.
> Alternatively, you can print to both Netlink *and* the kernel log.
> Printing to NL allows you to pass a message directly to userspace and
> then the program you use to configure devices will print it. Otherwise,
> the user will need to open up the kernel log.

Got it, thanks for explaining it.
Thanks
William
