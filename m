Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934A926325D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgIIQlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730802AbgIIQlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:41:05 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908F3C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:41:05 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 60so2856274otw.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PbUDbMNyou/Q5glcn6fxlLAcSfHhOJDH4vHE9j8juiY=;
        b=ZLBubHKTegXq+NQBrcunh1xwcNvrSJ2X0L0tSvV3jNPZwaSVGKL89A3q6BdwEjIhfY
         8ztmUyEF/sDt+dVULqHa4IcsvY5BvUwn/wqH3UwjTzY06JnGEA225UdFs77NQP3Irds/
         Cy567RgX8tXTcZzxWSZHhUuNdQ8mkRY+lW2j4vKLsXXm5ta0Gljw8rCQSnZJYWtkbtQz
         cG15kbpxVJ8Dk/pbGETgjf3Ovt6pQc47xA5LZe/EdoTHaCfY/tKuR0hnikLb1aZgaOEP
         Nr/0X9GP7NkO8TyDPrwsGBQE14LN3bVR63gi6hg4GpGscpKaN5X5r5TU6GFUFGEsScdS
         Vy8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PbUDbMNyou/Q5glcn6fxlLAcSfHhOJDH4vHE9j8juiY=;
        b=fXTlEHiZyWyshPClL5UZLGgYq9m9AMrm2szwbAfIqxIKmHC5bqk8MH/Ccj0mvWi8gn
         sW+SHcAjle3cx2qV7aINsOSluRSnHCaaJOQ8DtIxnCXYAIAsVx3GZjZVkP1SwViK/qOk
         jbRQqb3KTMFFgCStIWw7NhStKBe4A+Xk9Hn/yswMNc3ss2uIxCfJvqMZJlUYeS/CKNp9
         aju73IVqagAAYJ5wW2audJEkn6Z0DoqTwulgNtVBo/CZ/kBPWh6fVWyUr8dEbMCzfbUs
         Mp7FBTfg17XHMcdABIruxeCZzkLVvONhTuHQxer92yZosskIFKr771mqoEmxLvi1FNP+
         SshQ==
X-Gm-Message-State: AOAM532rOA/pFvBGX8IARdruRSEVDaV3BG5KGZjNVpN3gF/QZn+ysYQ9
        tWO4r65s58ZYfKgQphve9Emu6w==
X-Google-Smtp-Source: ABdhPJxAdiL7okfMhmPnaXWBt6j8y9COhF4Cob1UmaNhq80tAHEYNeIB5chwhD9kqdgvkAr3Y5xaBg==
X-Received: by 2002:a05:6830:1191:: with SMTP id u17mr1218087otq.335.1599669664221;
        Wed, 09 Sep 2020 09:41:04 -0700 (PDT)
Received: from yoga ([2605:6000:e5cb:c100:8898:14ff:fe6d:34e])
        by smtp.gmail.com with ESMTPSA id z8sm210588oic.11.2020.09.09.09.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:41:03 -0700 (PDT)
Date:   Wed, 9 Sep 2020 11:41:01 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Carl Huang <cjhuang@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH net 1/2] net: qrtr: check skb_put_padto() return value
Message-ID: <20200909164101.GT3715@yoga>
References: <20200909082740.204752-1-edumazet@google.com>
 <20200909082740.204752-2-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909082740.204752-2-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 09 Sep 03:27 CDT 2020, Eric Dumazet wrote:

> If skb_put_padto() returns an error, skb has been freed.
> Better not touch it anymore, as reported by syzbot [1]
> 
> Note to qrtr maintainers : this suggests qrtr_sendmsg()
> should adjust sock_alloc_send_skb() second parameter
> to account for the potential added alignment to avoid
> reallocation.
> 
> [1]
> 
> BUG: KASAN: use-after-free in __skb_insert include/linux/skbuff.h:1907 [inline]
> BUG: KASAN: use-after-free in __skb_queue_before include/linux/skbuff.h:2016 [inline]
> BUG: KASAN: use-after-free in __skb_queue_tail include/linux/skbuff.h:2049 [inline]
> BUG: KASAN: use-after-free in skb_queue_tail+0x6b/0x120 net/core/skbuff.c:3146
> Write of size 8 at addr ffff88804d8ab3c0 by task syz-executor.4/4316
> 
> CPU: 1 PID: 4316 Comm: syz-executor.4 Not tainted 5.9.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1d6/0x29e lib/dump_stack.c:118
>  print_address_description+0x66/0x620 mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report+0x132/0x1d0 mm/kasan/report.c:530
>  __skb_insert include/linux/skbuff.h:1907 [inline]
>  __skb_queue_before include/linux/skbuff.h:2016 [inline]
>  __skb_queue_tail include/linux/skbuff.h:2049 [inline]
>  skb_queue_tail+0x6b/0x120 net/core/skbuff.c:3146
>  qrtr_tun_send+0x1a/0x40 net/qrtr/tun.c:23
>  qrtr_node_enqueue+0x44f/0xc00 net/qrtr/qrtr.c:364
>  qrtr_bcast_enqueue+0xbe/0x140 net/qrtr/qrtr.c:861
>  qrtr_sendmsg+0x680/0x9c0 net/qrtr/qrtr.c:960
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg net/socket.c:671 [inline]
>  sock_write_iter+0x317/0x470 net/socket.c:998
>  call_write_iter include/linux/fs.h:1882 [inline]
>  new_sync_write fs/read_write.c:503 [inline]
>  vfs_write+0xa96/0xd10 fs/read_write.c:578
>  ksys_write+0x11b/0x220 fs/read_write.c:631
>  do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45d5b9
> Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f84b5b81c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000038b40 RCX: 000000000045d5b9
> RDX: 0000000000000055 RSI: 0000000020001240 RDI: 0000000000000003
> RBP: 00007f84b5b81ca0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000f
> R13: 00007ffcbbf86daf R14: 00007f84b5b829c0 R15: 000000000118cf4c
> 
> Allocated by task 4316:
>  kasan_save_stack mm/kasan/common.c:48 [inline]
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc+0x100/0x130 mm/kasan/common.c:461
>  slab_post_alloc_hook+0x3e/0x290 mm/slab.h:518
>  slab_alloc mm/slab.c:3312 [inline]
>  kmem_cache_alloc+0x1c1/0x2d0 mm/slab.c:3482
>  skb_clone+0x1b2/0x370 net/core/skbuff.c:1449
>  qrtr_bcast_enqueue+0x6d/0x140 net/qrtr/qrtr.c:857
>  qrtr_sendmsg+0x680/0x9c0 net/qrtr/qrtr.c:960
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg net/socket.c:671 [inline]
>  sock_write_iter+0x317/0x470 net/socket.c:998
>  call_write_iter include/linux/fs.h:1882 [inline]
>  new_sync_write fs/read_write.c:503 [inline]
>  vfs_write+0xa96/0xd10 fs/read_write.c:578
>  ksys_write+0x11b/0x220 fs/read_write.c:631
>  do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Freed by task 4316:
>  kasan_save_stack mm/kasan/common.c:48 [inline]
>  kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
>  kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
>  __kasan_slab_free+0xdd/0x110 mm/kasan/common.c:422
>  __cache_free mm/slab.c:3418 [inline]
>  kmem_cache_free+0x82/0xf0 mm/slab.c:3693
>  __skb_pad+0x3f5/0x5a0 net/core/skbuff.c:1823
>  __skb_put_padto include/linux/skbuff.h:3233 [inline]
>  skb_put_padto include/linux/skbuff.h:3252 [inline]
>  qrtr_node_enqueue+0x62f/0xc00 net/qrtr/qrtr.c:360
>  qrtr_bcast_enqueue+0xbe/0x140 net/qrtr/qrtr.c:861
>  qrtr_sendmsg+0x680/0x9c0 net/qrtr/qrtr.c:960
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg net/socket.c:671 [inline]
>  sock_write_iter+0x317/0x470 net/socket.c:998
>  call_write_iter include/linux/fs.h:1882 [inline]
>  new_sync_write fs/read_write.c:503 [inline]
>  vfs_write+0xa96/0xd10 fs/read_write.c:578
>  ksys_write+0x11b/0x220 fs/read_write.c:631
>  do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The buggy address belongs to the object at ffff88804d8ab3c0
>  which belongs to the cache skbuff_head_cache of size 224
> The buggy address is located 0 bytes inside of
>  224-byte region [ffff88804d8ab3c0, ffff88804d8ab4a0)
> The buggy address belongs to the page:
> page:00000000ea8cccfb refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88804d8abb40 pfn:0x4d8ab
> flags: 0xfffe0000000200(slab)
> raw: 00fffe0000000200 ffffea0002237ec8 ffffea00029b3388 ffff88821bb66800
> raw: ffff88804d8abb40 ffff88804d8ab000 000000010000000b 0000000000000000
> page dumped because: kasan: bad access detected
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Fixes: ce57785bf91b ("net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Carl Huang <cjhuang@codeaurora.org>
> Cc: Wen Gong <wgong@codeaurora.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  net/qrtr/qrtr.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index 90c558f89d46565ee5d5845d0ca97c095a8287a8..957aa9263ba4ce10dbb8d94c4e4bbcaef8b6e84b 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -332,8 +332,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
>  {
>  	struct qrtr_hdr_v1 *hdr;
>  	size_t len = skb->len;
> -	int rc = -ENODEV;
> -	int confirm_rx;
> +	int rc, confirm_rx;
>  
>  	confirm_rx = qrtr_tx_wait(node, to->sq_node, to->sq_port, type);
>  	if (confirm_rx < 0) {
> @@ -357,15 +356,17 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
>  	hdr->size = cpu_to_le32(len);
>  	hdr->confirm_rx = !!confirm_rx;
>  
> -	skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));
> -
> -	mutex_lock(&node->ep_lock);
> -	if (node->ep)
> -		rc = node->ep->xmit(node->ep, skb);
> -	else
> -		kfree_skb(skb);
> -	mutex_unlock(&node->ep_lock);
> +	rc = skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));
>  
> +	if (!rc) {
> +		mutex_lock(&node->ep_lock);
> +		rc = -ENODEV;
> +		if (node->ep)
> +			rc = node->ep->xmit(node->ep, skb);
> +		else
> +			kfree_skb(skb);
> +		mutex_unlock(&node->ep_lock);
> +	}
>  	/* Need to ensure that a subsequent message carries the otherwise lost
>  	 * confirm_rx flag if we dropped this one */
>  	if (rc && confirm_rx)
> -- 
> 2.28.0.526.ge36021eeef-goog
> 
