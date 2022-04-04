Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C35C4F1337
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355999AbiDDKi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245317AbiDDKi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:38:28 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186A635255;
        Mon,  4 Apr 2022 03:36:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id w4so13744938wrg.12;
        Mon, 04 Apr 2022 03:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1HBiFYlEiqTXVb+hK23gOZGF2CdBmNE43kJRJeqQsvs=;
        b=jAZt9Jk1ZO3ahYdITjscHoG6hhL/th7YmNdy+CNKHoVjD6dYfNEO+cJFo5zEHo0BLr
         llW5AiRh9j+qxtSq/MX9HynDozOCasm+1e/689G0bHkhvPzLN9F6dY59DFxfFSeJG1uz
         V8je1YvYatt1RgJr1/swRrjzFvCDnb+TLSoDpju71DZWEY+0NSL/Jkd8DCrvoHQ3zoJR
         jjUdKFM976jVY810HvBXOJQORr/w0ZFH+FgAvNuhG4D9nE5duzY4LiMK3CmbRAmOvBkT
         BLgvFzhOpSPiG+CFbXHofv4V03mHE7KzEiHBIa1pdBSZA1x56OsLWXCdx8nju/dGcdoO
         iQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=1HBiFYlEiqTXVb+hK23gOZGF2CdBmNE43kJRJeqQsvs=;
        b=Rtuzpw6Svx08uTaXEUBSZ/AP43dJY/9gUi8GNHsRV0HedgnvrPC3aEJWREXQ2fu+Fg
         XKLm2cuDJYAPh2J2a8Eb6yi0Lhi3pRfA0UzGxcorkp1rKCXHFsdREhX4gUmlKZ2aVSUE
         hirv/4rsjkuZptV3X/Gxp08Y1TzJgzXmXTyfM/FXVBcmQTDW/nFkn3WRPshAjk89+66u
         hOaKnBC5P7+9SFU+70AzkzWlq/nXFiA+ax7VZfRb7zD9gFaNoQHD1NMPgItnv9EwYivg
         Y0wCMIeU2IRW4yswgnnHaPxWKMoDEcxBMKqWdpXNSmMHuZp2koNsr4EycUbUguyaaJOD
         rvUw==
X-Gm-Message-State: AOAM533sGX9R/WHsaO6IlsYDyg0PDo9jbHqyL7BogDZBnmem4L84Cput
        cY7PtGaL5WdwBr8ss7GJzS3UrojUasA=
X-Google-Smtp-Source: ABdhPJxA/eJaCU+3KGGsg+XYddlzhJ8brdZkkZESve5TLYmP23yuyygYEZ56XlVH1IFDLSMD7C6SQA==
X-Received: by 2002:adf:fa92:0:b0:206:1720:1e25 with SMTP id h18-20020adffa92000000b0020617201e25mr1305043wrr.390.1649068590489;
        Mon, 04 Apr 2022 03:36:30 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id 14-20020a056000154e00b00203f8adde0csm10950792wry.32.2022.04.04.03.36.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Apr 2022 03:36:30 -0700 (PDT)
Date:   Mon, 4 Apr 2022 11:36:27 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        ecree.xilinx@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Subject: Re: [PATCH net v2] net: sfc: add missing xdp queue reinitialization
Message-ID: <20220404103627.zczltvxz4pjrpqay@gmail.com>
Mail-Followup-To: Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ecree.xilinx@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com
References: <20220330163703.25086-1-ap420073@gmail.com>
 <20220401110606.whyr5hnesb4ya67q@gmail.com>
 <8f22d067-fb84-cc76-9249-d68af9601d44@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f22d067-fb84-cc76-9249-d68af9601d44@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Taehee,

On Sat, Apr 02, 2022 at 03:48:14AM +0900, Taehee Yoo wrote:
> On 4/1/22 20:06, Martin Habets wrote:
> 
> Hi Martin,
> Thank you so much for your review!
> 
> > Hi Taehee,
> >
> > Thanks for looking into this. Unfortunately efx_realloc_channels()
> > has turned out to be quite fragile over the years, so I'm
> > keen to remove it in stead of patching it up all the time.
> 
> I agree with you.
> efx_realloc_channels() is too complex.
> 
> >
> > Could you try the patch below please?
> > If it works ok for you as well we'll be able to remove
> > efx_realloc_channels(). The added advantage of this approach
> > is that the netdev notifiers get informed of the change.
> 
> I tested your patch and I found a page reference count problem.
> How to test:
> 1. set up XDP_TX
> 2. traffic on
> 3. traffic off
> 4. ring buffer size change
> 5. loop from 2 to 4.
> 
> [   87.836195][   T72] BUG: Bad page state in process kworker/u16:1
> pfn:125445
> [   87.843356][   T72] page:000000003725f642 refcount:-2 mapcount:0
> mapping:0000000000000000 index:0x0 pfn:0x125445
> [   87.853783][   T72] flags: 0x200000000000000(node=0|zone=2)
> 
> [   87.859391][   T72] raw: 0200000000000000 dead000000000100
> dead000000000122 0000000000000000
> [   87.867928][   T72] raw: 0000000000000000 0000000000000000
> fffffffeffffffff 0000000000000000
> [   87.876569][   T72] page dumped because: nonzero _refcount
> 
> [   87.882125][   T72] Modules linked in: af_packet sfc ixgbe mtd atlantic
> coretemp mdio hwmon sch_fq_codel msr bpf_prelx
> [   87.895331][   T72] CPU: 0 PID: 72 Comm: kworker/u16:1 Not tainted
> 5.17.0+ #62 dbf33652f22e5147659e7e2472bb962779c4833
> [   87.906350][   T72] Hardware name: ASUS System Product Name/PRIME Z690-P
> D4, BIOS 0603 11/01/2021
> [   87.915360][   T72] Workqueue: netns cleanup_net
> 
> [   87.920087][   T72] Call Trace:
> 
> [   87.923311][   T72]  <TASK>
> 
> [   87.926188][   T72]  dump_stack_lvl+0x56/0x7b
> 
> [   87.930597][   T72]  bad_page.cold.125+0x63/0x93
> 
> [   87.935288][   T72]  free_pcppages_bulk+0x63c/0x6f0
> 
> [   87.940232][   T72]  free_unref_page+0x8b/0xf0
> 
> [   87.944749][   T72]  efx_fini_rx_queue+0x15f/0x210 [sfc
> 49c5d4f562a40c6a7ed913c25f5bd4e126bcfa4e]

Looks to me like this is in efx_fini_rx_recycle_ring().
It could be a side effect of the memory leak you report below.
If this is in efx_fini_rx_recycle_ring() I'll post a patch for
that soon on a separate thread.

> [   87.953756][   T72]  efx_stop_channels+0xef/0x1b0 [sfc
> 49c5d4f562a40c6a7ed913c25f5bd4e126bcfa4e]
> [   87.962699][   T72]  efx_net_stop+0x4d/0x60 [sfc
> 49c5d4f562a40c6a7ed913c25f5bd4e126bcfa4e]
> [   87.971029][   T72]  __dev_close_many+0x8b/0xf0
> 
> [   87.975618][   T72]  dev_close_many+0x7d/0x120
> 
> [ ... ]
> 
> 
> In addition, I would like to share issues that I'm currently looking into:
> 1. TX DMA error
> when interface down/up or ring buffer size changes, TX DMA error would occur
> because tx_queue can be used before initialization.
> But It will be fixed by the below patch.
> 
>  static void efx_ethtool_get_wol(struct net_device *net_dev,
> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> index d16e031e95f4..6983799e1c05 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -443,6 +443,9 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n,
> struct xdp_frame **xdpfs,
>         if (unlikely(!tx_queue))
>                 return -EINVAL;
> 
> +       if (!tx_queue->initialised)
> +               return -EINVAL;
> +
>         if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
>                 HARD_TX_LOCK(efx->net_dev, tx_queue->core_txq, cpu);
> 
> diff --git a/drivers/net/ethernet/sfc/tx_common.c
> b/drivers/net/ethernet/sfc/tx_common.c
> index d530cde2b864..9bc8281b7f5b 100644
> --- a/drivers/net/ethernet/sfc/tx_common.c
> +++ b/drivers/net/ethernet/sfc/tx_common.c
> @@ -101,6 +101,8 @@ void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
>         netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
>                   "shutting down TX queue %d\n", tx_queue->queue);
> 
> +       tx_queue->initialised = false;
> +
>         if (!tx_queue->buffer)
>                 return;

Looks ok, but xmit_hard should never be called on an interface that
is down. Makes me wonder if we have a seqence issue in our ndo_stop API.

> 
> After your patch, unfortunately, it can't fix ring buffer size change case.
> It can fix only interface down/up case.
> I will look into this more.
> 
> 2. Memory leak
> There is a memory leak in ring buffer size change logic.
> reproducer:
>    while :
>    do
>        ethtool -G <interface name> rx 2048 tx 2048
>        ethtool -G <interface name> rx 1024 tx 1024
>    done

Is this with my patch or only with yours?
Thanks a lot for testing this.

Martin

> Thanks a lot,
> Taehee Yoo
> 
> >
> > Regards,
> > Martin Habets <habetsm.xilinx@gmail.com>
> >
> > ---
> >   drivers/net/ethernet/sfc/ethtool.c |   13 ++++++++++++-
> >   1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/ethtool.c
> b/drivers/net/ethernet/sfc/ethtool.c
> > index 48506373721a..8cfbe61737bb 100644
> > --- a/drivers/net/ethernet/sfc/ethtool.c
> > +++ b/drivers/net/ethernet/sfc/ethtool.c
> > @@ -179,6 +179,7 @@ efx_ethtool_set_ringparam(struct net_device *net_dev,
> >   {
> >   	struct efx_nic *efx = netdev_priv(net_dev);
> >   	u32 txq_entries;
> > +	int rc = 0;
> >
> >   	if (ring->rx_mini_pending || ring->rx_jumbo_pending ||
> >   	    ring->rx_pending > EFX_MAX_DMAQ_SIZE ||
> > @@ -198,7 +199,17 @@ efx_ethtool_set_ringparam(struct net_device *net_dev,
> >   			   "increasing TX queue size to minimum of %u\n",
> >   			   txq_entries);
> >
> > -	return efx_realloc_channels(efx, ring->rx_pending, txq_entries);
> > +	/* Apply the new settings */
> > +	efx->rxq_entries = ring->rx_pending;
> > +	efx->txq_entries = ring->tx_pending;
> > +
> > +	/* Update the datapath with the new settings if the interface is up */
> > +	if (!efx_check_disabled(efx) && netif_running(efx->net_dev)) {
> > +		dev_close(net_dev);
> > +		rc = dev_open(net_dev, NULL);
> > +	}
> > +
> > +	return rc;
> >   }
> >
> >   static void efx_ethtool_get_wol(struct net_device *net_dev,

-- 
Martin Habets <habetsm.xilinx@gmail.com>
