Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845FA5EF963
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiI2PqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiI2Ppq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:45:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050852AC2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664466275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFDRdT3YNiEMsa+AZetCOI5EJNYxOYuiooVQoGJe/s4=;
        b=RR7TnMr8JMkqFXSssJqxfmz3zHWx2AIYT7DcjKRdY73Kj8iXRBeAPjrYH7zwpwbnEvXWLs
        FrIajB/rol6KXKYbty3foNwnQSf/o3dyvyAiCXFSZjuoVHKIoSVoQCw2nqGY5MX0eUrmZg
        /U8pqQLpS0cEganLW+JZOid3BurtWZg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-412-XST4zzUeOiWZ9ra8MNPFTQ-1; Thu, 29 Sep 2022 11:44:34 -0400
X-MC-Unique: XST4zzUeOiWZ9ra8MNPFTQ-1
Received: by mail-ej1-f71.google.com with SMTP id i11-20020a1709064fcb00b00783415e70c2so892107ejw.6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:44:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=DFDRdT3YNiEMsa+AZetCOI5EJNYxOYuiooVQoGJe/s4=;
        b=UsrC4VhDizCHUUl2dP0nSO+beTWFTqhEUMvisalVBIUQLKOrro9J052UKQ1alzffWj
         TDgyDnx0USaxeWWHHtUqFIYDNjwnbJcmgiBzJP4UU4NibgA0dChEy0NLokgGB2c8itEN
         jA2ClmXutNAx5MtilX2e2UTsnV1ZnwFhZ4h9kJCx+UiV3Ox1PwZcxYK/95HXY6vAQWty
         NFhMmTAL5gX6C0/cDP/lIch8DRv4DjImmxqr2m0LZMFcRlh89O9iyNo76mIdY3Til27j
         HWUtkmxImF6qIdCueclVThoZ+h8kNfPElZfE/C6LQvBra5mnU9KTPPns+RwzWH7S+/xG
         pVOg==
X-Gm-Message-State: ACrzQf3mmTVj/yfbpcNqRO88ByEcpwAXBdopo+2b7u5HOjMiYt2KvV3C
        3egWeeiy5nM4DlWG/DdJxESBbs2/APTxElIRb9U+cNje1gon1qIP5V+wNhCUo3+BOe3+iucDrIr
        ExO1nmevx7pnFf8R3
X-Received: by 2002:a17:906:9bdb:b0:787:afc4:d088 with SMTP id de27-20020a1709069bdb00b00787afc4d088mr3046472ejc.611.1664466271297;
        Thu, 29 Sep 2022 08:44:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7K+AGqIX5myJwH31RYnX6ZEx5Iml2doWE/FRHVx0t97GmO4a7o9vbL1cP1+QiCcugQXnMVfA==
X-Received: by 2002:a17:906:9bdb:b0:787:afc4:d088 with SMTP id de27-20020a1709069bdb00b00787afc4d088mr3046452ejc.611.1664466271027;
        Thu, 29 Sep 2022 08:44:31 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709061c5200b00783fb38965bsm4126486ejg.100.2022.09.29.08.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 08:44:30 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <f1a4bd53-aa55-a040-9171-7f8a57649151@redhat.com>
Date:   Thu, 29 Sep 2022 17:44:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Content-Language: en-US
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <1898c50e-1bad-1143-17d9-d093b2d2674a@redhat.com>
 <PAXPR04MB91853E39BDA9A46CB5DED06D89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
In-Reply-To: <PAXPR04MB91853E39BDA9A46CB5DED06D89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/09/2022 15.11, Shenwei Wang wrote:
> 
>> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
 >>
>>> diff --git a/drivers/net/ethernet/freescale/fec.h
>>> b/drivers/net/ethernet/freescale/fec.h
>>> index b0100fe3c9e4..f7531503aa95 100644
>>> --- a/drivers/net/ethernet/freescale/fec.h
>>> +++ b/drivers/net/ethernet/freescale/fec.h
>>> @@ -346,8 +346,10 @@ struct bufdesc_ex {
>>>     * the skbuffer directly.
>>>     */
>>>
>>> +#define FEC_ENET_XDP_HEADROOM        (512) /* XDP_PACKET_HEADROOM
>> + NET_IP_ALIGN) */
>>
>> Why the large headroom?
>>
> 
> The accurate value here should be "XDP_PACKET_HEADROOM (256) +
> NET_IP_ALIGN" which then aligns with 64 bytes. So 256 + 64 should be
> enough here.
> 

Most other XDP drivers have 256 bytes headroom.
I don't understand why you just don't keep this at 256, like other drivers ?

>>> +
>>>    #define FEC_ENET_RX_PAGES   256
>>> -#define FEC_ENET_RX_FRSIZE   2048
>>> +#define FEC_ENET_RX_FRSIZE   (PAGE_SIZE - FEC_ENET_XDP_HEADROOM)
>>
>> This FEC_ENET_RX_FRSIZE is likely wrong, because you also need to reserve 320
>> bytes at the end for struct skb_shared_info.
>> (320 calculated as SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
>>
>>>    #define FEC_ENET_RX_FRPPG   (PAGE_SIZE / FEC_ENET_RX_FRSIZE)
>>>    #define RX_RING_SIZE                (FEC_ENET_RX_FRPPG *
>> FEC_ENET_RX_PAGES)
>>>    #define FEC_ENET_TX_FRSIZE  2048
>>> @@ -517,6 +519,22 @@ struct bufdesc_prop {
>> [...]
>>
>>> diff --git a/drivers/net/ethernet/freescale/fec_main.c
>>> b/drivers/net/ethernet/freescale/fec_main.c
>>> index 59921218a8a4..2e30182ed770 100644
>>> --- a/drivers/net/ethernet/freescale/fec_main.c
>>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>>> @@ -66,6 +66,8 @@
>>>    #include <linux/mfd/syscon.h>
>>>    #include <linux/regmap.h>
>>>    #include <soc/imx/cpuidle.h>
>>> +#include <linux/filter.h>
>>> +#include <linux/bpf.h>
>>>
>>>    #include <asm/cacheflush.h>
>>>
>>> @@ -87,6 +89,11 @@ static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0,
>> 1, 1, 1, 2, 2, 2};
>>>    #define FEC_ENET_OPD_V      0xFFF0
>>>    #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
>>>
>>> +#define FEC_ENET_XDP_PASS          0
>>> +#define FEC_ENET_XDP_CONSUMED      BIT(0)
>>> +#define FEC_ENET_XDP_TX            BIT(1)
>>> +#define FEC_ENET_XDP_REDIR         BIT(2)
>>> +
>>>    struct fec_devinfo {
>>>        u32 quirks;
>>>    };
>>> @@ -422,6 +429,49 @@ fec_enet_clear_csum(struct sk_buff *skb, struct
>> net_device *ndev)
>>>        return 0;
>>>    }
>>>
>>> +static int
>>> +fec_enet_create_page_pool(struct fec_enet_private *fep,
>>> +                       struct fec_enet_priv_rx_q *rxq, int size) {
>>> +     struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
>>> +     struct page_pool_params pp_params = {
>>> +             .order = 0,
>>> +             .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>>> +             .pool_size = size,
>>> +             .nid = dev_to_node(&fep->pdev->dev),
>>> +             .dev = &fep->pdev->dev,
>>> +             .dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
>>> +             .offset = FEC_ENET_XDP_HEADROOM,
>>> +             .max_len = FEC_ENET_RX_FRSIZE,
>>
>> XDP BPF-prog cannot access last 320 bytes, so FEC_ENET_RX_FRSIZE is wrong
>> here.
>>
> 
> So the FEC_ENET_RX_FRSIZE should subtract the sizeof(struct
> skb_shared_info) in the definition, right?
> 

Yes correct, but use:
   SKB_DATA_ALIGN(sizeof(struct skb_shared_info))


>>> +     };
>>> +     int err;
>>> +
>>> +     rxq->page_pool = page_pool_create(&pp_params);
>>> +     if (IS_ERR(rxq->page_pool)) {
>>> +             err = PTR_ERR(rxq->page_pool);
>>> +             rxq->page_pool = NULL;
>>> +             return err;
>>> +     }
>>> +
>>> +     err = xdp_rxq_info_reg(&rxq->xdp_rxq, fep->netdev, rxq->id, 0);
>>> +     if (err < 0)
>>> +             goto err_free_pp;
>>> +
>>> +     err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
>>> +                                      rxq->page_pool);
>>> +     if (err)
>>> +             goto err_unregister_rxq;
>>> +
>>> +     return 0;
>>> +
>>> +err_unregister_rxq:
>>> +     xdp_rxq_info_unreg(&rxq->xdp_rxq);
>>> +err_free_pp:
>>> +     page_pool_destroy(rxq->page_pool);
>>> +     rxq->page_pool = NULL;
>>> +     return err;
>>> +}
>>> +
>>>    static struct bufdesc *
>>>    fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
>>>                             struct sk_buff *skb, @@ -1285,7 +1335,6 @@
>>> fec_stop(struct net_device *ndev)
>>>        }
>>>    }
>>>
>>> -
>>>    static void
>>>    fec_timeout(struct net_device *ndev, unsigned int txqueue)
>>>    {
>>> @@ -1450,7 +1499,7 @@ static void fec_enet_tx(struct net_device *ndev)
>>>                fec_enet_tx_queue(ndev, i);
>>>    }
>>>
>>> -static int
>>> +static int __maybe_unused
>>>    fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff *skb)
>>>    {
>>>        struct  fec_enet_private *fep = netdev_priv(ndev); @@ -1470,8
>>> +1519,9 @@ fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc
>> *bdp, struct sk_buff
>>>        return 0;
>>>    }
>>>
>>> -static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
>>> -                            struct bufdesc *bdp, u32 length, bool swap)
>>> +static bool __maybe_unused
>>> +fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
>>> +                struct bufdesc *bdp, u32 length, bool swap)
>>>    {
>>>        struct  fec_enet_private *fep = netdev_priv(ndev);
>>>        struct sk_buff *new_skb;
>>> @@ -1496,6 +1546,78 @@ static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
>>>        return true;
>>>    }
>>>
>>> +static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
>>> +                             struct bufdesc *bdp, int index) {
>>> +     struct page *new_page;
>>> +     dma_addr_t phys_addr;
>>> +
>>> +     new_page = page_pool_dev_alloc_pages(rxq->page_pool);
>>> +     WARN_ON(!new_page);
>>> +     rxq->rx_skb_info[index].page = new_page;
>>> +
>>> +     rxq->rx_skb_info[index].offset = FEC_ENET_XDP_HEADROOM;
>>> +     phys_addr = page_pool_get_dma_addr(new_page) + FEC_ENET_XDP_HEADROOM;
>>> +     bdp->cbd_bufaddr = cpu_to_fec32(phys_addr); }
>>> +
>>> +static u32
>>> +fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
>>> +              struct xdp_buff *xdp, struct fec_enet_priv_rx_q *rxq,
>>> +int index) {
>>> +     unsigned int sync, len = xdp->data_end - xdp->data;
>>> +     u32 ret = FEC_ENET_XDP_PASS;
>>> +     struct page *page;
>>> +     int err;
>>> +     u32 act;
>>> +
>>> +     act = bpf_prog_run_xdp(prog, xdp);
>>> +
>>> +     /* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
>>> +     sync = xdp->data_end - xdp->data_hard_start - FEC_ENET_XDP_HEADROOM;
>>> +     sync = max(sync, len);
>>> +
>>> +     switch (act) {
>>> +     case XDP_PASS:
>>> +             rxq->stats.xdp_pass++;
>>> +             ret = FEC_ENET_XDP_PASS;
>>> +             break;
>>> +
>>> +     case XDP_TX:
>>> +             rxq->stats.xdp_tx++;
>>> +             bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
>>> +             fallthrough;
>>
>> This fallthrough looks wrong. The next xdp_do_redirect() call will pickup left-
>> overs in per CPU bpf_redirect_info.
>>
> 
> So before the XDP_TX is implemented, this part of codes should reside below the XDP_REDIRECT case?
> 

If that fallthrough goes to dropping packet, then yes.

>>> +
>>> +     case XDP_REDIRECT:
>>> +             err = xdp_do_redirect(fep->netdev, xdp, prog);
>>> +             rxq->stats.xdp_redirect++;
>>> -                     dma_unmap_single(&fep->pdev->dev,
> ...
> 
>>> -                                      fec32_to_cpu(bdp->cbd_bufaddr),
>>> -                                      FEC_ENET_RX_FRSIZE - fep->rx_align,
>>> -                                      DMA_FROM_DEVICE);
>>> -             }
>>> -
>>> -             prefetch(skb->data - NET_IP_ALIGN);
>>> +             skb = build_skb(page_address(page), FEC_ENET_RX_FRSIZE);
>>
>> This looks wrong, I think FEC_ENET_RX_FRSIZE should be replaced by PAGE_SIZE.
>> As build_skb() does:
>>
>>    size -= SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>>
> 
> Agree. As the current FRSIZE definition did not subtract the sizeof(struct skb_shared_info), I happened to not see the problem during the testing.
> 

As I wrote use PAGE_SIZE here.


>>> +             skb_reserve(skb, FEC_ENET_XDP_HEADROOM);
>>
>> The skb_reserve looks correct.
>>
>>>                skb_put(skb, pkt_len - 4);
>>>                data = skb->data;
>>> +             page_pool_release_page(rxq->page_pool, page);
>>
>> Today page_pool have SKB recycle support (you might have looked at drivers
>> that didn't utilize this yet), thus you don't need to release the page
>> (page_pool_release_page) here.  Instead you could simply mark the SKB for
>> recycling, unless driver does some page refcnt tricks I didn't notice.
>>
>>    skb_mark_for_recycle(skb);

I hope you try out the above proposed change.

>>
>>> -             if (!is_copybreak && need_swap)
>>> +             if (need_swap)
>>>                        swap_buffer(data, pkt_len);
>>>
>>>    #if !defined(CONFIG_M5272)
>>> @@ -1649,16 +1781,6 @@ fec_enet_rx_queue(struct net_device *ndev, int
>>> budget, u16 queue_id)
>> [...]
> 

