Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B944A81C1
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 10:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiBCJse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 04:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiBCJsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 04:48:33 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1A7C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 01:48:32 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id p7so4579433edc.12
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 01:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=M7T3IHLxN41QRZvjv1YjFFkL8vtlek+/+fn2CtCoDDU=;
        b=YH/LViuSDXCiDO41rn7E24WZMSjl8N++XHrx4b9MaYILZJko3CSNhbleRUalaw4RMs
         QG1f8jk7tJHCKj/ggBjiQJRcVUI36OXLRIP1fXLclPBX+JRpItgPk/RBYPuNaFiD4ucf
         qkkZ1WVudGuyOi9h4B8XrULqVspGiDcGjN+7SceZeOLhN6BKy6UUq7CcVAnn4Yp1BIwF
         dEcr9TwuOf8YtXK02JLT9Tl0uANeVLoajEqkHhfApp+BTEh9YNJeWssGc8JFwf3SUg4T
         1EXS5uvAb63+q1EQO1h4cKYAK091VuVDjUw2s9wDPVlKTz/Kmn3TTPHMnllve5xIGJ4y
         mD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=M7T3IHLxN41QRZvjv1YjFFkL8vtlek+/+fn2CtCoDDU=;
        b=6R6kngxcX0HCfeZwlBbfRwVLqgHLWna9lcHKnUR3IsCnTqgDUeDZNwO03lNfCQ8HqP
         EOemyt11pEkpXGS/uwe3uxsVt5IEwGHl5/8iCguwDZjy6gQebCFcNhyDfX5s2MMvNdca
         BZrGeP1C1IqTtfjfEKP4C4grm2qpSrzx5dSjF1nZbb4y6GrF2sxAZPOPoSxv9FNUIBqR
         vYJ5ix68O1t2KnGXt7ZOpQOXulhoResk9sDfa6e5Kznj7nLZp83ShpsY7vqvoBpzxIga
         TIsmCTb6MwE5DgfPPP6dY+FRhZFnemWkDO6nstw1Z4vWGPfwtXOO4TCWeIMsd8NlX84w
         WfDg==
X-Gm-Message-State: AOAM5301WPwixUUTV3S+FJ6JnM5oAbBrdKiZ+DETaN7wCXT5s4aT97/t
        GW8wl31Ukn1/PdR1y4rcvo7Vug==
X-Google-Smtp-Source: ABdhPJxWPXDA+Qfhiv1m/qrJLdCHp+0d8VSL7N9r6UBl3/CCX2ME8dVaNppeDPLwWxRsRfSXs/8EWA==
X-Received: by 2002:a05:6402:d0d:: with SMTP id eb13mr33899293edb.6.1643881711466;
        Thu, 03 Feb 2022 01:48:31 -0800 (PST)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id r15sm16466191ejz.72.2022.02.03.01.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 01:48:30 -0800 (PST)
Date:   Thu, 3 Feb 2022 09:48:07 +0000
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     linuxarm@openeuler.org, ilias.apalodimas@linaro.org,
        salil.mehta@huawei.com, netdev@vger.kernel.org,
        moyufeng@huawei.com, alexanderduyck@fb.com, brouer@redhat.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: hns3: support skb's frag page
 recycling based on page pool
Message-ID: <Yfuk11on6XiaB6Di@myrica>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
 <1628217982-53533-5-git-send-email-linyunsheng@huawei.com>
 <YfFbDivUPbpWjh/m@myrica>
 <3315a093-582c-f464-d894-cb07522e5547@huawei.com>
 <YfO1q52G7GKl+P40@myrica>
 <ff54ec37-cb69-cc2f-7ee7-7974f244d843@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff54ec37-cb69-cc2f-7ee7-7974f244d843@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 04:44:34PM +0800, Yunsheng Lin wrote:
> >> My initial thinking is to track if the reference counting or pp_frag_count of
> >> the page is manipulated correctly.
> > 
> > It looks like pp_frag_count is dropped too many times: after (1),
> > pp_frag_count only has 1 ref, so (2) drops it to 0 and (3) results in
> > underflow. I turned page_pool_atomic_sub_frag_count_return() into
> > "atomic_long_sub_return(nr, &page->pp_frag_count)" to make sure (the
> > atomic_long_read() bit normally hides this). Wasn't entirely sure if this
> > is expected behavior, though.
> 
> Are you true the above 1~3 step is happening for the same page?

Yes they happen on the same page. What I did was save the backtrace of
each call to page_pool_atomic_sub_frag_count_return() and, when an
underflow error happens on a page, print out the history of that page
only.

My report was not right, though, I forgot to save the backtrace for
pp_frag_count==0. There's actually two refs on the page. It goes like
this:

  (1) T-1535, drop BIAS_MAX - 2, pp_frag_count now 2
     page_pool_alloc_frag+0x128/0x240
     hns3_alloc_and_map_buffer+0x30/0x170
     hns3_nic_alloc_rx_buffers+0x9c/0x170
     hns3_clean_rx_ring+0x864/0x960
     hns3_nic_common_poll+0xa0/0x218
     __napi_poll+0x38/0x188
     net_rx_action+0xe8/0x248
     __do_softirq+0x120/0x284

  (2) T-4, drop 1, pp_frag_count now 1
     page_pool_put_page+0x98/0x338
     page_pool_return_skb_page+0x48/0x60
     skb_release_data+0x170/0x190
     skb_release_all+0x28/0x38
     kfree_skb_reason+0x30/0x90
     packet_rcv+0x58/0x430
     __netif_receive_skb_list_core+0x1f4/0x218
     netif_receive_skb_list_internal+0x18c/0x2a8
  
  (3) T-1, drop 1, pp_frag_count now 0
     page_pool_put_page+0x98/0x338
     page_pool_return_skb_page+0x48/0x60
     skb_release_data+0x170/0x190
     skb_release_all+0x28/0x38
     __kfree_skb+0x18/0x30
     __sk_defer_free_flush+0x44/0x58
     tcp_recvmsg+0x94/0x1b8
     inet_recvmsg+0x50/0x128
  
  (4) T, drop 1, pp_frag_count now -1 (underflow)
     page_pool_put_page+0x2d0/0x338
     hns3_clean_rx_ring+0x74c/0x960
     hns3_nic_common_poll+0xa0/0x218
     __napi_poll+0x38/0x188
     net_rx_action+0xe8/0x248

> If it is the same page, there must be something wrong here.
> 
> Normally there are 1024 BD for a rx ring:
> 
> BD_0 BD_1 BD_2 BD_3 BD_4 .... BD_1020 BD_1021  BD_1022  BD_1023
>            ^         ^
>          head       tail
> 
> Suppose head is manipulated by driver, and tail is manipulated by
> hw.
> 
> driver allocates buffer for BD pointed by head, as the frag page
> recycling is introduced in this patch, the BD_0 and BD_1's buffer
> may point to the same page（4K page size, and each BD only need
> 2k Buffer.
> hw dma the data to the buffer pointed by tail when packet is received.
> 
> so step 1 Normally happen for the BD pointed by head,
> and step 2 & 3 Normally happen for the BD pointed by tail.
> And Normally there are at least (1024 - RCB_NOF_ALLOC_RX_BUFF_ONCE) BD
> between head and tail, so it is unlikely that head and tail's BD buffer
> points to the same page.

I think a new page is allocated at step 1, no?  The driver calls
page_pool_alloc_frag() when refilling the rx ring, and since the current
pool->frag_page (P1) is still used by BD_0 and BD_1, then
page_pool_drain_frag() drops (BIAS_MAX - 2) references and
page_pool_alloc_frag() replaces frag_page with a new page, P2. Later, head
points to BD_1, the driver can drop the remaining 2 references to P1 in
steps 2 and 3, and P1 can be unmapped and freed/recycled

What I don't get is which of steps 2, 3 and 4 is the wrong one. Could be
2 or 3 because the device is evidently still doing DMA to the page after
it's released, but it could also be that the driver doesn't properly clear
the BD in which case step 4 is wrong. I'll try to find out which fragment
gets dropped twice.

Thanks,
Jean

