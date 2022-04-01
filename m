Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D8D4EFA1F
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351393AbiDASuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351387AbiDASuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:50:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693A922BE8;
        Fri,  1 Apr 2022 11:48:20 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j7so346716pjw.4;
        Fri, 01 Apr 2022 11:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=6JpIT2BaDFCc3bgcniO+3D2m2dkYcUP+F8GYfhbElYE=;
        b=Pvs9iYqvntOpBMiYvvKHEt29ng0L24cjAbXMoTdgt6pqSMV6JkZBmlktX2fFzZXF2F
         3gND3ZZhHOcIFVyF9C3Z6x7OVSd9CbP0/1BlAIEs5hwZ+EvWAVui8KnjnIV5jBZqLlJL
         ykddVw0jcGKJ4iUkilpzNiIcOnHsbXXT4B5fNbPvR4Jnd4KQehIfruuErcvWfBoCJLHG
         1s3INNO/JhonKAFxKuQ9p7iLDC559Bh/qRBaDomqiP6FBMPGppx4qwpI+v7RE6XqU3cc
         rcC4sdxQ/nNr9fkKlS/E316KuSpNG+s2g5uxTSIwGqxhoR/6MXm7JdSvWtKrliWUL8MM
         vNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6JpIT2BaDFCc3bgcniO+3D2m2dkYcUP+F8GYfhbElYE=;
        b=PFHqNXC7XSX1rlEESLg2XJD05SCIh0sucAOxsxWQiFsD+Q9LfQK7toyzNfWBdgyd7H
         kXcdHyvMSRZU5RbqhNbRF8xNGDZrzGf0NZ6SCaOSQhABBoKjMBaXTT1TwFhAaC5r9bhQ
         tn9AvfovzHBr3N0m0mpYGG0PmMq8a5OycSgdaJngrVlzYYf3ZD5YJP/ATDDdP1G9jHzl
         2cZlWGacyPywBd/M8Hfi2h4zIF8UDmzdrhVevzSBl7NIif9J60z9rPASuIa9oklDnZJE
         HOznokpndjxvnV7zL5+iJ+7yqgObpNJqEK5cR2Bfd7AAS/7Zth7BDyl25maYpOngmpqK
         Oh4g==
X-Gm-Message-State: AOAM530+tdnRdiBaMt2FG/1m8yVtCReIN3ut68maCOB1zEm5v17OVIqT
        pTJKGprjRZT+fPjH1FYhTbdtdhgOzqob2A==
X-Google-Smtp-Source: ABdhPJzp3yLwKfCkP5V2i42NXaW4Lgv/kRzhk/m2RfIlizKNduJQroip8Rheo/eaIrtQEOPQLKxQYQ==
X-Received: by 2002:a17:90a:889:b0:1c9:8baa:3eeb with SMTP id v9-20020a17090a088900b001c98baa3eebmr13296712pjc.44.1648838899410;
        Fri, 01 Apr 2022 11:48:19 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00230c00b004faf2563bcasm3978405pfh.114.2022.04.01.11.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 11:48:18 -0700 (PDT)
Message-ID: <8f22d067-fb84-cc76-9249-d68af9601d44@gmail.com>
Date:   Sat, 2 Apr 2022 03:48:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2] net: sfc: add missing xdp queue reinitialization
Content-Language: en-US
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        ecree.xilinx@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
References: <20220330163703.25086-1-ap420073@gmail.com>
 <20220401110606.whyr5hnesb4ya67q@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220401110606.whyr5hnesb4ya67q@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/22 20:06, Martin Habets wrote:

Hi Martin,
Thank you so much for your review!

 > Hi Taehee,
 >
 > Thanks for looking into this. Unfortunately efx_realloc_channels()
 > has turned out to be quite fragile over the years, so I'm
 > keen to remove it in stead of patching it up all the time.

I agree with you.
efx_realloc_channels() is too complex.

 >
 > Could you try the patch below please?
 > If it works ok for you as well we'll be able to remove
 > efx_realloc_channels(). The added advantage of this approach
 > is that the netdev notifiers get informed of the change.

I tested your patch and I found a page reference count problem.
How to test:
1. set up XDP_TX
2. traffic on
3. traffic off
4. ring buffer size change
5. loop from 2 to 4.

[   87.836195][   T72] BUG: Bad page state in process kworker/u16:1 
pfn:125445
[   87.843356][   T72] page:000000003725f642 refcount:-2 mapcount:0 
mapping:0000000000000000 index:0x0 pfn:0x125445
[   87.853783][   T72] flags: 0x200000000000000(node=0|zone=2) 

[   87.859391][   T72] raw: 0200000000000000 dead000000000100 
dead000000000122 0000000000000000
[   87.867928][   T72] raw: 0000000000000000 0000000000000000 
fffffffeffffffff 0000000000000000
[   87.876569][   T72] page dumped because: nonzero _refcount 

[   87.882125][   T72] Modules linked in: af_packet sfc ixgbe mtd 
atlantic coretemp mdio hwmon sch_fq_codel msr bpf_prelx
[   87.895331][   T72] CPU: 0 PID: 72 Comm: kworker/u16:1 Not tainted 
5.17.0+ #62 dbf33652f22e5147659e7e2472bb962779c4833
[   87.906350][   T72] Hardware name: ASUS System Product Name/PRIME 
Z690-P D4, BIOS 0603 11/01/2021
[   87.915360][   T72] Workqueue: netns cleanup_net 

[   87.920087][   T72] Call Trace: 

[   87.923311][   T72]  <TASK> 

[   87.926188][   T72]  dump_stack_lvl+0x56/0x7b 

[   87.930597][   T72]  bad_page.cold.125+0x63/0x93 

[   87.935288][   T72]  free_pcppages_bulk+0x63c/0x6f0 

[   87.940232][   T72]  free_unref_page+0x8b/0xf0 

[   87.944749][   T72]  efx_fini_rx_queue+0x15f/0x210 [sfc 
49c5d4f562a40c6a7ed913c25f5bd4e126bcfa4e]
[   87.953756][   T72]  efx_stop_channels+0xef/0x1b0 [sfc 
49c5d4f562a40c6a7ed913c25f5bd4e126bcfa4e]
[   87.962699][   T72]  efx_net_stop+0x4d/0x60 [sfc 
49c5d4f562a40c6a7ed913c25f5bd4e126bcfa4e]
[   87.971029][   T72]  __dev_close_many+0x8b/0xf0 

[   87.975618][   T72]  dev_close_many+0x7d/0x120 

[ ... ]


In addition, I would like to share issues that I'm currently looking into:
1. TX DMA error
when interface down/up or ring buffer size changes, TX DMA error would occur
because tx_queue can be used before initialization.
But It will be fixed by the below patch.

  static void efx_ethtool_get_wol(struct net_device *net_dev,
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index d16e031e95f4..6983799e1c05 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -443,6 +443,9 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, 
struct xdp_frame **xdpfs,
         if (unlikely(!tx_queue))
                 return -EINVAL;

+       if (!tx_queue->initialised)
+               return -EINVAL;
+
         if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
                 HARD_TX_LOCK(efx->net_dev, tx_queue->core_txq, cpu);

diff --git a/drivers/net/ethernet/sfc/tx_common.c 
b/drivers/net/ethernet/sfc/tx_common.c
index d530cde2b864..9bc8281b7f5b 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -101,6 +101,8 @@ void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
         netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
                   "shutting down TX queue %d\n", tx_queue->queue);

+       tx_queue->initialised = false;
+
         if (!tx_queue->buffer)
                 return;

After your patch, unfortunately, it can't fix ring buffer size change case.
It can fix only interface down/up case.
I will look into this more.

2. Memory leak
There is a memory leak in ring buffer size change logic.
reproducer:
    while :
    do
        ethtool -G <interface name> rx 2048 tx 2048
        ethtool -G <interface name> rx 1024 tx 1024
    done

Thanks a lot,
Taehee Yoo

 >
 > Regards,
 > Martin Habets <habetsm.xilinx@gmail.com>
 >
 > ---
 >   drivers/net/ethernet/sfc/ethtool.c |   13 ++++++++++++-
 >   1 file changed, 12 insertions(+), 1 deletion(-)
 >
 > diff --git a/drivers/net/ethernet/sfc/ethtool.c 
b/drivers/net/ethernet/sfc/ethtool.c
 > index 48506373721a..8cfbe61737bb 100644
 > --- a/drivers/net/ethernet/sfc/ethtool.c
 > +++ b/drivers/net/ethernet/sfc/ethtool.c
 > @@ -179,6 +179,7 @@ efx_ethtool_set_ringparam(struct net_device *net_dev,
 >   {
 >   	struct efx_nic *efx = netdev_priv(net_dev);
 >   	u32 txq_entries;
 > +	int rc = 0;
 >
 >   	if (ring->rx_mini_pending || ring->rx_jumbo_pending ||
 >   	    ring->rx_pending > EFX_MAX_DMAQ_SIZE ||
 > @@ -198,7 +199,17 @@ efx_ethtool_set_ringparam(struct net_device 
*net_dev,
 >   			   "increasing TX queue size to minimum of %u\n",
 >   			   txq_entries);
 >
 > -	return efx_realloc_channels(efx, ring->rx_pending, txq_entries);
 > +	/* Apply the new settings */
 > +	efx->rxq_entries = ring->rx_pending;
 > +	efx->txq_entries = ring->tx_pending;
 > +
 > +	/* Update the datapath with the new settings if the interface is up */
 > +	if (!efx_check_disabled(efx) && netif_running(efx->net_dev)) {
 > +		dev_close(net_dev);
 > +		rc = dev_open(net_dev, NULL);
 > +	}
 > +
 > +	return rc;
 >   }
 >
 >   static void efx_ethtool_get_wol(struct net_device *net_dev,
