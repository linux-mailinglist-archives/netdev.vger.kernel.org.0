Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E994850ECDD
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbiDYXzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiDYXzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:55:18 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD514131D;
        Mon, 25 Apr 2022 16:52:11 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id g22so6250878uam.12;
        Mon, 25 Apr 2022 16:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MJuuYIyWr75+wIHZvavej9Axy9mhg9QwfnL0wCWjcS4=;
        b=MABzszZSXdvaMqHRHCXau39VM7pdz9DdBWdJTqWgOQM/IdAogvMNK8b+iBPAsTA8A7
         Ib67af5u5lW+SaujfJXxxRnG6YE6+YxVOShjEuqNTFwGyzY+B6/qt/X4RMY/53oWchm7
         er9wZnoAzQLQ7EbZRKDOaXWjR7OvIS5aeu3+Q1SlXYxQcG0DPQdrwTnYqNOhMz6oU8h9
         ysETh+zIYApdlAf0dkqkmwQLl8Y8XOYNyi0Q7Z3PfRKAAr1+iQbrBmQNBFUK2P3bfbM5
         Pu5X/Ij3ggdWOfmTnsShIR/p8+ze3n/zuBpK7fM7RHEsfl5C4LFWVkB7uM5vfxoY1UBm
         3+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MJuuYIyWr75+wIHZvavej9Axy9mhg9QwfnL0wCWjcS4=;
        b=tC7vGLl7xMOODXFG60sV6DVHTUqX/NpLzBHkt7N7Nr4v+6kiuG6RFlbyHGeBFkz2B+
         oWa8n0P3H42cyiXehkGPcoztEqWd3G6Vg/aExQNBFvw17P+SKbDSiryb3xVLxLX6E14H
         KwVUqQd7GB8Qp8OF8SxFhoErgvvgVKeONHQws8chXZzXqn/Mr0LRVlkeHKTKgjcpInl9
         WCYqNRAlUf6L/MB7mhtB43qzqtl3tGZNPPYJ4D2lLTRaL+K0JVHRGnP0Mk354B+3IdRH
         DiMLaqXzwpSkEtrd88MRUTRN6ayS0Ns9DfZRbnGePfxZS4xF2CFeAxAHW+jwsCCjyxZ5
         9keg==
X-Gm-Message-State: AOAM5338CcbwmUQD7o/Tr37gQVgqR8UpXWcMbem6GvbAuiicMltzrvBD
        wC7SVsz48O+dXgV3fBI+MdmXhJPPQ7ZLIkSGEIvPsqRiiAw=
X-Google-Smtp-Source: ABdhPJxXHjOBgxjdKpOQ+E30nWh9ErSkjEuwhWt5vP4cvmv7aTS649wdZA1LNkOQWG7UMe3ueE35oxPfC0oD6L/RDXo=
X-Received: by 2002:ab0:7290:0:b0:34b:71ac:96c2 with SMTP id
 w16-20020ab07290000000b0034b71ac96c2mr6176916uao.102.1650930730784; Mon, 25
 Apr 2022 16:52:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-3-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-3-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 02:52:10 +0300
Message-ID: <CAHNKnsQO27Rv4jdGuSLaQFNxcac1Y-yTubCmVwqeeeBdRoKeVQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 02/13] net: wwan: t7xx: Add control DMA interface
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
> path of Host-Modem data transfers. CLDMA HIF layer provides a common
> interface to the Port Layer.
>
> CLDMA manages 8 independent RX/TX physical channels with data flow
> control in HW queues. CLDMA uses ring buffers of General Packet
> Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
> data buffers (DB).
>
> CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
> interrupts, and initializes CLDMA HW registers.
>
> CLDMA TX flow:
> 1. Port Layer write
> 2. Get DB address
> 3. Configure GPD
> 4. Triggering processing via HW register write
>
> CLDMA RX flow:
> 1. CLDMA HW sends a RX "done" to host
> 2. Driver starts thread to safely read GPD
> 3. DB is sent to Port layer
> 4. Create a new buffer for GPD ring
>
> Note: This patch does not enable compilation since it has dependencies
> such as t7xx_pcie_mac_clear_int()/t7xx_pcie_mac_set_int() and
> struct t7xx_pci_dev which are added by the core patch.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com=
>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7=
xx/t7xx_hif_cldma.c

[skipped]

> +static int t7xx_cldma_gpd_rx_from_q(struct cldma_queue *queue, int budge=
t, bool *over_budget)
> +{
> +       struct cldma_ctrl *md_ctrl =3D queue->md_ctrl;
> +       unsigned int hwo_polling_count =3D 0;
> +       struct t7xx_cldma_hw *hw_info;
> +       bool rx_not_done =3D true;
> +       unsigned long flags;
> +       int count =3D 0;
> +
> +       hw_info =3D &md_ctrl->hw_info;
> +
> +       do {
> +               struct cldma_request *req;
> +               struct cldma_rgpd *rgpd;
> +               struct sk_buff *skb;
> +               int ret;
> +
> +               req =3D queue->tr_done;
> +               if (!req)
> +                       return -ENODATA;
> +
> +               rgpd =3D req->gpd;
> +               if ((rgpd->gpd_flags & GPD_FLAGS_HWO) || !req->skb) {
> +                       dma_addr_t gpd_addr;
> +
> +                       if (!pci_device_is_present(to_pci_dev(md_ctrl->de=
v))) {
> +                               dev_err(md_ctrl->dev, "PCIe Link disconne=
cted\n");
> +                               return -ENODEV;
> +                       }
> +
> +                       gpd_addr =3D ioread64(hw_info->ap_pdn_base + REG_=
CLDMA_DL_CURRENT_ADDRL_0 +
> +                                           queue->index * sizeof(u64));
> +                       if (req->gpd_addr =3D=3D gpd_addr || hwo_polling_=
count++ >=3D 100)
> +                               return 0;
> +
> +                       udelay(1);
> +                       continue;
> +               }
> +
> +               hwo_polling_count =3D 0;
> +               skb =3D req->skb;
> +
> +               if (req->mapped_buff) {
> +                       dma_unmap_single(md_ctrl->dev, req->mapped_buff,
> +                                        t7xx_skb_data_area_size(skb), DM=
A_FROM_DEVICE);
> +                       req->mapped_buff =3D 0;
> +               }
> +
> +               skb->len =3D 0;
> +               skb_reset_tail_pointer(skb);
> +               skb_put(skb, le16_to_cpu(rgpd->data_buff_len));
> +
> +               ret =3D md_ctrl->recv_skb(queue, skb);
> +               if (ret < 0)
> +                       return ret;

The execution flow can not be broken here even in case of error. The
.recv_skb() callback consumes (frees) skb even if there is an error.
But the skb field in req (struct cldma_request) will keep the skb
pointer if the function returns from here. And this stale skb pointer
will cause a use-after-free or double-free error.

I have not dug too deeply into the CLDMA layer and can not suggest any
solution. But the error handling path needs to be rechecked.

> +               req->skb =3D NULL;
> +               t7xx_cldma_rgpd_set_data_ptr(rgpd, 0);
> +
> +               spin_lock_irqsave(&queue->ring_lock, flags);
> +               queue->tr_done =3D list_next_entry_circular(req, &queue->=
tr_ring->gpd_ring, entry);
> +               spin_unlock_irqrestore(&queue->ring_lock, flags);
> +               req =3D queue->rx_refill;
> +
> +               ret =3D t7xx_cldma_alloc_and_map_skb(md_ctrl, req, queue-=
>tr_ring->pkt_size);
> +               if (ret)
> +                       return ret;
> +
> +               rgpd =3D req->gpd;
> +               t7xx_cldma_rgpd_set_data_ptr(rgpd, req->mapped_buff);
> +               rgpd->data_buff_len =3D 0;
> +               rgpd->gpd_flags =3D GPD_FLAGS_IOC | GPD_FLAGS_HWO;
> +
> +               spin_lock_irqsave(&queue->ring_lock, flags);
> +               queue->rx_refill =3D list_next_entry_circular(req, &queue=
->tr_ring->gpd_ring, entry);
> +               spin_unlock_irqrestore(&queue->ring_lock, flags);
> +
> +               rx_not_done =3D ++count < budget || !need_resched();
> +       } while (rx_not_done);
> +
> +       *over_budget =3D true;
> +       return 0;
> +}

--
Sergey
