Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DDC3397E0
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhCLUCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbhCLUBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 15:01:52 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAD2C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 12:01:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so5287258pjb.1
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 12:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jT7Gae2UYF17yrShizBLgrNrTjqBQtQlZYQNZBCnsWM=;
        b=44evdGAgWXnLL1Lq/KUeVRHECRlVNAkVmf4w7z/dDeBr5EDt5NWiqTT9x2SXWKmQec
         pyZozaFuOQvveZuPSWvBKln5B8Eb9sFwt0aQNjX+WdXF0hNBKGsaLWvYU24vHJFZEUbv
         VbYIRjT0+qFsmBuvVm0VB+rGadfQqRi5ALkkr/dGGCPuUrVTdynbPqlWqdEZDrYpMR9e
         TsB5LxarKe1i5tD4jGfmKoVDhDOYpJi5MiRsTjL50BD+zufh01xJOpCP8+L3qK5jVIfx
         bBP0NAq+oji8zlY2qaU+PD89dLOJevNvZQJPg2bTaHu1K0MNhzmxKqljDsN2S3qby2Y1
         EfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jT7Gae2UYF17yrShizBLgrNrTjqBQtQlZYQNZBCnsWM=;
        b=KPzdyiPKtSclWNPsZZbgUD9g/4WoRwPLlw4T/f87rgvB8YGlsi4rrpQqdI+zBac65r
         /FwcVCMt1F6BdV9iVBMUoIhPTKxzRbAV5yQ33pQvsu4cM4CCEf5GVzemS20CRPsVg9Iq
         fkZRKL0R5F7VloW/jbMtlkDl7ZmeS9UOrv5O921VT8hFMla99rjtIpuHXIz9/0jgqL6f
         wmWxIbwV4KLiclCqxb6UVj3dWies+gtu2831ORD4k5oKL4Vp7gIverJLPLURDWiUSwfq
         I4N6I47WTKZEFhiD6cADFr2U+BLXkmInjUoPfAm+g+H0o8kX5VZ1NSj1qBuGzsMIdegz
         bDbw==
X-Gm-Message-State: AOAM530Fryy5a9Fg99tJG0jt5+1+G/giWRpIwX4tKl3YqPfTXpqQ7iPk
        MOpbCItC1HhguHp0fRdRZMAY7xzQ2L+CYA==
X-Google-Smtp-Source: ABdhPJwdLWxSMc5Cbf7t1o9JTvMK0ZsjiHh0ArVbSQRN0JkIluOtvf0XybYjpOc85ZpQdmGq2tJl9A==
X-Received: by 2002:a17:902:f1c2:b029:e4:6c23:489f with SMTP id e2-20020a170902f1c2b02900e46c23489fmr731094plc.62.1615579311143;
        Fri, 12 Mar 2021 12:01:51 -0800 (PST)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id u2sm6187514pfn.79.2021.03.12.12.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 12:01:50 -0800 (PST)
Subject: Re: [PATCH net-next 2/6] ionic: implement Rx page reuse
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pensando Drivers <drivers@pensando.io>
References: <20210310192631.20022-1-snelson@pensando.io>
 <20210310192631.20022-3-snelson@pensando.io>
 <CAKgT0UfyjoAN7LTnq0NMZfXRv4v7iTCPyAb9pVr3qWMhop_BVw@mail.gmail.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <b25b599e-069e-bf1f-d598-edee732aa30e@pensando.io>
Date:   Fri, 12 Mar 2021 12:01:48 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfyjoAN7LTnq0NMZfXRv4v7iTCPyAb9pVr3qWMhop_BVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 6:14 PM, Alexander Duyck wrote:
> On Wed, Mar 10, 2021 at 11:28 AM Shannon Nelson <snelson@pensando.io> wrote:
>> Rework the Rx buffer allocations to use pages twice when using
>> normal MTU in order to cut down on buffer allocation and mapping
>> overhead.
>>
>> Instead of tracking individual pages, in which we may have
>> wasted half the space when using standard 1500 MTU, we track
>> buffers which use half pages, so we can use the second half
>> of the page rather than allocate and map a new page once the
>> first buffer has been used.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> So looking at the approach taken here it just seems like you are doing
> the linear walk approach and getting 2 uses per 4K page. If you are
> taking that route it might make more sense to just split the page and
> use both pieces immediately to populate 2 entries instead of waiting
> on the next loop through the ring. Then you could just split the page
> into multiple buffers and fill your sg list using less total pages
> rather than having 2K gaps between your entries. An added advantage
> would be that you could simply merge the page fragments in the event
> that you have something writing to the full 2K buffers and you cannot
> use copybreak.

Thanks, Alex, for the detailed review.  I'll work with our internal 
performance guy to fold these comments into an update.
sln


>
>> ---
>>   .../net/ethernet/pensando/ionic/ionic_dev.h   |  12 +-
>>   .../net/ethernet/pensando/ionic/ionic_txrx.c  | 215 +++++++++++-------
>>   2 files changed, 138 insertions(+), 89 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> index 690768ff0143..0f877c86eba6 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> @@ -170,9 +170,15 @@ typedef void (*ionic_desc_cb)(struct ionic_queue *q,
>>                                struct ionic_desc_info *desc_info,
>>                                struct ionic_cq_info *cq_info, void *cb_arg);
>>
>> -struct ionic_page_info {
>> +#define IONIC_PAGE_SIZE                                PAGE_SIZE
>> +#define IONIC_PAGE_SPLIT_SZ                    (PAGE_SIZE / 2)
> This probably doesn't work out too well when the page size gets up to
> 64K. I don't know of too many networks that support a 32K MTU.. :)
>
>> +#define IONIC_PAGE_GFP_MASK                    (GFP_ATOMIC | __GFP_NOWARN |\
>> +                                                __GFP_COMP | __GFP_MEMALLOC)
>> +
>> +struct ionic_buf_info {
>>          struct page *page;
>>          dma_addr_t dma_addr;
>> +       u32 page_offset;
>>   };
> I'm not really sure the rename was needed. You are still just working
> with a page aren't you? It would actually reduce the complexity of
> this patch a bunch as you could drop the renaming changes.
>
>>   struct ionic_desc_info {
>> @@ -187,8 +193,8 @@ struct ionic_desc_info {
>>                  struct ionic_txq_sg_desc *txq_sg_desc;
>>                  struct ionic_rxq_sg_desc *rxq_sgl_desc;
>>          };
>> -       unsigned int npages;
>> -       struct ionic_page_info pages[IONIC_RX_MAX_SG_ELEMS + 1];
>> +       unsigned int nbufs;
>> +       struct ionic_buf_info bufs[IONIC_RX_MAX_SG_ELEMS + 1];
>>          ionic_desc_cb cb;
>>          void *cb_arg;
>>   };
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> index 70b997f302ac..3e13cfee9ecd 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> @@ -54,7 +54,7 @@ static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q,
>>          if (frags)
>>                  skb = napi_get_frags(&q_to_qcq(q)->napi);
>>          else
>> -               skb = netdev_alloc_skb_ip_align(netdev, len);
>> +               skb = napi_alloc_skb(&q_to_qcq(q)->napi, len);
>>
>>          if (unlikely(!skb)) {
>>                  net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
>> @@ -66,8 +66,15 @@ static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q,
>>          return skb;
>>   }
>>
>> +static void ionic_rx_buf_reset(struct ionic_buf_info *buf_info)
>> +{
>> +       buf_info->page = NULL;
>> +       buf_info->page_offset = 0;
>> +       buf_info->dma_addr = 0;
>> +}
>> +
> Technically speaking you probably only need to reset the page value.
> You could hold off on resetting the page_offset and dma_addr until you
> actually are populating the page.
>
>>   static int ionic_rx_page_alloc(struct ionic_queue *q,
>> -                              struct ionic_page_info *page_info)
>> +                              struct ionic_buf_info *buf_info)
>>   {
>>          struct ionic_lif *lif = q->lif;
>>          struct ionic_rx_stats *stats;
>> @@ -78,26 +85,26 @@ static int ionic_rx_page_alloc(struct ionic_queue *q,
>>          dev = lif->ionic->dev;
>>          stats = q_to_rx_stats(q);
>>
>> -       if (unlikely(!page_info)) {
>> -               net_err_ratelimited("%s: %s invalid page_info in alloc\n",
>> +       if (unlikely(!buf_info)) {
>> +               net_err_ratelimited("%s: %s invalid buf_info in alloc\n",
>>                                      netdev->name, q->name);
>>                  return -EINVAL;
>>          }
>>
>> -       page_info->page = dev_alloc_page();
>> -       if (unlikely(!page_info->page)) {
>> +       buf_info->page = alloc_pages(IONIC_PAGE_GFP_MASK, 0);
>> +       if (unlikely(!buf_info->page)) {
>>                  net_err_ratelimited("%s: %s page alloc failed\n",
>>                                      netdev->name, q->name);
>>                  stats->alloc_err++;
>>                  return -ENOMEM;
>>          }
>> +       buf_info->page_offset = 0;
>>
>> -       page_info->dma_addr = dma_map_page(dev, page_info->page, 0, PAGE_SIZE,
>> -                                          DMA_FROM_DEVICE);
>> -       if (unlikely(dma_mapping_error(dev, page_info->dma_addr))) {
>> -               put_page(page_info->page);
>> -               page_info->dma_addr = 0;
>> -               page_info->page = NULL;
>> +       buf_info->dma_addr = dma_map_page(dev, buf_info->page, buf_info->page_offset,
>> +                                         IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
>> +       if (unlikely(dma_mapping_error(dev, buf_info->dma_addr))) {
>> +               __free_pages(buf_info->page, 0);
>> +               ionic_rx_buf_reset(buf_info);
>>                  net_err_ratelimited("%s: %s dma map failed\n",
>>                                      netdev->name, q->name);
>>                  stats->dma_map_err++;
> So one thing I would change about the setup here is that I would not
> store anything in buf_info page until after you have stored the
> page_offset and dma_addr. That way you know that the other two are
> only valid because a page is present. In addition you can avoid having
> to do the extra cleanup as they should only be read if info->page is
> set.
>
>> @@ -108,32 +115,46 @@ static int ionic_rx_page_alloc(struct ionic_queue *q,
>>   }
>>
>>   static void ionic_rx_page_free(struct ionic_queue *q,
>> -                              struct ionic_page_info *page_info)
>> +                              struct ionic_buf_info *buf_info)
>>   {
>> -       struct ionic_lif *lif = q->lif;
>> -       struct net_device *netdev;
>> -       struct device *dev;
>> -
>> -       netdev = lif->netdev;
>> -       dev = lif->ionic->dev;
>> +       struct net_device *netdev = q->lif->netdev;
>> +       struct device *dev = q->lif->ionic->dev;
>>
>> -       if (unlikely(!page_info)) {
>> -               net_err_ratelimited("%s: %s invalid page_info in free\n",
>> +       if (unlikely(!buf_info)) {
>> +               net_err_ratelimited("%s: %s invalid buf_info in free\n",
>>                                      netdev->name, q->name);
>>                  return;
>>          }
>>
>> -       if (unlikely(!page_info->page)) {
>> -               net_err_ratelimited("%s: %s invalid page in free\n",
>> -                                   netdev->name, q->name);
>> +       if (!buf_info->page)
>>                  return;
>> -       }
>>
>> -       dma_unmap_page(dev, page_info->dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
>> +       dma_unmap_page(dev, buf_info->dma_addr, IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
>> +       __free_pages(buf_info->page, 0);
>> +       ionic_rx_buf_reset(buf_info);
>> +}
>> +
>> +static bool ionic_rx_buf_recycle(struct ionic_queue *q,
>> +                                struct ionic_buf_info *buf_info, u32 used)
>> +{
>> +       u32 size;
>> +
>> +       /* don't re-use pages allocated in low-mem condition */
>> +       if (page_is_pfmemalloc(buf_info->page))
>> +               return false;
>> +
>> +       /* don't re-use buffers from non-local numa nodes */
>> +       if (page_to_nid(buf_info->page) != numa_mem_id())
>> +               return false;
>> +
> So I am not sure if either of these is really needed if you are just
> going to be freeing the page after all 4K is consumed. With the Intel
> drivers we were bouncing back and forth between the upper and lower
> halves. With this it looks like you do a linear walk and then exit
> when you have reached the end of the page. With that being the case
> the memory locality check is kind of moot since you will flush the
> page after two uses anyway. In addition the pfmemalloc check might
> also be moot since it may actually be more efficient to reuse the page
> rather than use a full 4K and attempt to allocate yet another page.
>
>> +       size = ALIGN(used, IONIC_PAGE_SPLIT_SZ);
>> +       buf_info->page_offset += size;
>> +       if (buf_info->page_offset >= IONIC_PAGE_SIZE)
>> +               return false;
>> +
>> +       get_page(buf_info->page);
> The get_page per 2K section will add up in terms of cost as it is an
> expensive atomic operation. You might see if you can get away with
> batching it to do one atomic add per allocation instead of one per
> use.
>
>> -       put_page(page_info->page);
>> -       page_info->dma_addr = 0;
>> -       page_info->page = NULL;
>> +       return true;
>>   }
>>
>>   static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>> @@ -142,16 +163,16 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>>   {
>>          struct ionic_rxq_comp *comp = cq_info->cq_desc;
>>          struct device *dev = q->lif->ionic->dev;
>> -       struct ionic_page_info *page_info;
>> +       struct ionic_buf_info *buf_info;
>>          struct sk_buff *skb;
>>          unsigned int i;
>>          u16 frag_len;
>>          u16 len;
>>
>> -       page_info = &desc_info->pages[0];
>> +       buf_info = &desc_info->bufs[0];
>>          len = le16_to_cpu(comp->len);
>>
>> -       prefetch(page_address(page_info->page) + NET_IP_ALIGN);
>> +       prefetch(buf_info->page);
> Just want to confirm this is what you meant to do. The old code was
> prefetching the first line of the data. The new code is just
> prefetching the page struct. You may want to change this to a
> prefetchw if you are expecting to use this to improve the performance
> for the get_page call.
>
>>          skb = ionic_rx_skb_alloc(q, len, true);
>>          if (unlikely(!skb))
>> @@ -159,7 +180,7 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>>
>>          i = comp->num_sg_elems + 1;
>>          do {
>> -               if (unlikely(!page_info->page)) {
>> +               if (unlikely(!buf_info->page)) {
>>                          struct napi_struct *napi = &q_to_qcq(q)->napi;
>>
>>                          napi->skb = NULL;
>> @@ -167,15 +188,25 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>>                          return NULL;
>>                  }
>>
>> -               frag_len = min(len, (u16)PAGE_SIZE);
>> +               frag_len = min_t(u16, len, IONIC_PAGE_SIZE - buf_info->page_offset);
>>                  len -= frag_len;
>>
>> -               dma_unmap_page(dev, dma_unmap_addr(page_info, dma_addr),
>> -                              PAGE_SIZE, DMA_FROM_DEVICE);
>> +               dma_sync_single_for_cpu(dev,
>> +                                       buf_info->dma_addr + buf_info->page_offset,
>> +                                       frag_len, DMA_FROM_DEVICE);
>> +
>>                  skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>> -                               page_info->page, 0, frag_len, PAGE_SIZE);
>> -               page_info->page = NULL;
>> -               page_info++;
>> +                               buf_info->page, buf_info->page_offset, frag_len,
>> +                               IONIC_PAGE_SIZE);
>> +
>> +               if (!ionic_rx_buf_recycle(q, buf_info, frag_len)) {
>> +                       dma_unmap_page(dev, buf_info->dma_addr,
>> +                                      IONIC_PAGE_SIZE, DMA_FROM_DEVICE);
>> +                       ionic_rx_buf_reset(buf_info);
>> +               }
>> +
> If you don't unmap it don't you need to sync the remaining portion of
> the page for use by the device?
>
>> +               buf_info++;
>> +
>>                  i--;
>>          } while (i > 0);
>>
>> @@ -188,26 +219,26 @@ static struct sk_buff *ionic_rx_copybreak(struct ionic_queue *q,
>>   {
>>          struct ionic_rxq_comp *comp = cq_info->cq_desc;
>>          struct device *dev = q->lif->ionic->dev;
>> -       struct ionic_page_info *page_info;
>> +       struct ionic_buf_info *buf_info;
>>          struct sk_buff *skb;
>>          u16 len;
>>
>> -       page_info = &desc_info->pages[0];
>> +       buf_info = &desc_info->bufs[0];
>>          len = le16_to_cpu(comp->len);
>>
>>          skb = ionic_rx_skb_alloc(q, len, false);
>>          if (unlikely(!skb))
>>                  return NULL;
>>
>> -       if (unlikely(!page_info->page)) {
>> +       if (unlikely(!buf_info->page)) {
>>                  dev_kfree_skb(skb);
>>                  return NULL;
>>          }
>>
>> -       dma_sync_single_for_cpu(dev, dma_unmap_addr(page_info, dma_addr),
>> +       dma_sync_single_for_cpu(dev, buf_info->dma_addr + buf_info->page_offset,
>>                                  len, DMA_FROM_DEVICE);
>> -       skb_copy_to_linear_data(skb, page_address(page_info->page), len);
>> -       dma_sync_single_for_device(dev, dma_unmap_addr(page_info, dma_addr),
>> +       skb_copy_to_linear_data(skb, page_address(buf_info->page) + buf_info->page_offset, len);
>> +       dma_sync_single_for_device(dev, buf_info->dma_addr + buf_info->page_offset,
>>                                     len, DMA_FROM_DEVICE);
>>
>>          skb_put(skb, len);
>> @@ -327,64 +358,73 @@ void ionic_rx_fill(struct ionic_queue *q)
>>   {
>>          struct net_device *netdev = q->lif->netdev;
>>          struct ionic_desc_info *desc_info;
>> -       struct ionic_page_info *page_info;
>>          struct ionic_rxq_sg_desc *sg_desc;
>>          struct ionic_rxq_sg_elem *sg_elem;
>> +       struct ionic_buf_info *buf_info;
>>          struct ionic_rxq_desc *desc;
>> +       unsigned int max_sg_elems;
>>          unsigned int remain_len;
>> -       unsigned int seg_len;
>> +       unsigned int frag_len;
>>          unsigned int nfrags;
>>          unsigned int i, j;
>>          unsigned int len;
>>
>>          len = netdev->mtu + ETH_HLEN + VLAN_HLEN;
>> -       nfrags = round_up(len, PAGE_SIZE) / PAGE_SIZE;
>> +       max_sg_elems = q->lif->qtype_info[IONIC_QTYPE_RXQ].max_sg_elems;
>>
>>          for (i = ionic_q_space_avail(q); i; i--) {
>> +               nfrags = 0;
>>                  remain_len = len;
>>                  desc_info = &q->info[q->head_idx];
>>                  desc = desc_info->desc;
>> -               sg_desc = desc_info->sg_desc;
>> -               page_info = &desc_info->pages[0];
>> +               buf_info = &desc_info->bufs[0];
>>
>> -               if (page_info->page) { /* recycle the buffer */
>> -                       ionic_rxq_post(q, false, ionic_rx_clean, NULL);
>> -                       continue;
>> -               }
>> -
>> -               /* fill main descriptor - pages[0] */
>> -               desc->opcode = (nfrags > 1) ? IONIC_RXQ_DESC_OPCODE_SG :
>> -                                             IONIC_RXQ_DESC_OPCODE_SIMPLE;
>> -               desc_info->npages = nfrags;
>> -               if (unlikely(ionic_rx_page_alloc(q, page_info))) {
>> -                       desc->addr = 0;
>> -                       desc->len = 0;
>> -                       return;
>> +               if (!buf_info->page) { /* alloc a new buffer? */
>> +                       if (unlikely(ionic_rx_page_alloc(q, buf_info))) {
>> +                               desc->addr = 0;
>> +                               desc->len = 0;
>> +                               return;
>> +                       }
>>                  }
>> -               desc->addr = cpu_to_le64(page_info->dma_addr);
>> -               seg_len = min_t(unsigned int, PAGE_SIZE, len);
>> -               desc->len = cpu_to_le16(seg_len);
>> -               remain_len -= seg_len;
>> -               page_info++;
>>
>> -               /* fill sg descriptors - pages[1..n] */
>> -               for (j = 0; j < nfrags - 1; j++) {
>> -                       if (page_info->page) /* recycle the sg buffer */
>> -                               continue;
>> +               /* fill main descriptor - buf[0] */
>> +               desc->addr = cpu_to_le64(buf_info->dma_addr + buf_info->page_offset);
>> +               frag_len = min_t(u16, len, IONIC_PAGE_SIZE - buf_info->page_offset);
>> +               desc->len = cpu_to_le16(frag_len);
>> +               remain_len -= frag_len;
>> +               buf_info++;
>> +               nfrags++;
>>
>> +               /* fill sg descriptors - buf[1..n] */
>> +               sg_desc = desc_info->sg_desc;
>> +               for (j = 0; remain_len > 0 && j < max_sg_elems; j++) {
>>                          sg_elem = &sg_desc->elems[j];
>> -                       if (unlikely(ionic_rx_page_alloc(q, page_info))) {
>> -                               sg_elem->addr = 0;
>> -                               sg_elem->len = 0;
>> -                               return;
>> +                       if (!buf_info->page) { /* alloc a new sg buffer? */
>> +                               if (unlikely(ionic_rx_page_alloc(q, buf_info))) {
>> +                                       sg_elem->addr = 0;
>> +                                       sg_elem->len = 0;
>> +                                       return;
>> +                               }
>>                          }
>> -                       sg_elem->addr = cpu_to_le64(page_info->dma_addr);
>> -                       seg_len = min_t(unsigned int, PAGE_SIZE, remain_len);
>> -                       sg_elem->len = cpu_to_le16(seg_len);
>> -                       remain_len -= seg_len;
>> -                       page_info++;
>> +
>> +                       sg_elem->addr = cpu_to_le64(buf_info->dma_addr + buf_info->page_offset);
>> +                       frag_len = min_t(u16, remain_len, IONIC_PAGE_SIZE - buf_info->page_offset);
>> +                       sg_elem->len = cpu_to_le16(frag_len);
>> +                       remain_len -= frag_len;
>> +                       buf_info++;
>> +                       nfrags++;
>>                  }
>>
>> +               /* clear end sg element as a sentinel */
>> +               if (j < max_sg_elems) {
>> +                       sg_elem = &sg_desc->elems[j];
>> +                       memset(sg_elem, 0, sizeof(*sg_elem));
>> +               }
>> +
>> +               desc->opcode = (nfrags > 1) ? IONIC_RXQ_DESC_OPCODE_SG :
>> +                                             IONIC_RXQ_DESC_OPCODE_SIMPLE;
>> +               desc_info->nbufs = nfrags;
>> +
>>                  ionic_rxq_post(q, false, ionic_rx_clean, NULL);
>>          }
>>
>> @@ -395,21 +435,24 @@ void ionic_rx_fill(struct ionic_queue *q)
>>   void ionic_rx_empty(struct ionic_queue *q)
>>   {
>>          struct ionic_desc_info *desc_info;
>> -       struct ionic_page_info *page_info;
>> +       struct ionic_buf_info *buf_info;
>>          unsigned int i, j;
>>
>>          for (i = 0; i < q->num_descs; i++) {
>>                  desc_info = &q->info[i];
>>                  for (j = 0; j < IONIC_RX_MAX_SG_ELEMS + 1; j++) {
>> -                       page_info = &desc_info->pages[j];
>> -                       if (page_info->page)
>> -                               ionic_rx_page_free(q, page_info);
>> +                       buf_info = &desc_info->bufs[j];
>> +                       if (buf_info->page)
>> +                               ionic_rx_page_free(q, buf_info);
>>                  }
>>
>> -               desc_info->npages = 0;
>> +               desc_info->nbufs = 0;
>>                  desc_info->cb = NULL;
>>                  desc_info->cb_arg = NULL;
>>          }
>> +
>> +       q->head_idx = 0;
>> +       q->tail_idx = 0;
>>   }
>>
>>   static void ionic_dim_update(struct ionic_qcq *qcq)
>> --
>> 2.17.1
>>

