Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B0A5FFBCC
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 21:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJOTuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 15:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJOTuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 15:50:04 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DCE2649A;
        Sat, 15 Oct 2022 12:50:02 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id z30so4522635qkz.13;
        Sat, 15 Oct 2022 12:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6oLVdw0cZuqaOKT9ROptKn3b8uDN0aCnLROazMdgeqk=;
        b=IO8WJ3hL5rwlhfbeUVUH8LrBsTDdTLyDy0tbu+HxxYzzKbU6/o7MukfZBWR0sztSP2
         H8myo6VAwPy5/zjB89Oq4p3oFHZKf+k/Fre09M6Zbnr25hz7BTtM825B/OAZJISKyGqz
         OvrWFaHBZmy8r34Ctve6/4mm6EV+2+2f64TETcoujZ/EkbLGxYFlDzpQEgdn5bx89351
         w5p60sX/z9TtaKq1x/o3RvIBaZYl9GuiV0Tpgu6BfTbPxekuzW5Kn4AOGtf7/XQ0HVDb
         fds/gbOHOXqEMtApIUz8AAV/R7IwqijrBPBH3h+zK1WOMWz4cLOE80nxV3KZWDUZAGdb
         npzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6oLVdw0cZuqaOKT9ROptKn3b8uDN0aCnLROazMdgeqk=;
        b=K/PgTM6KwNAmb0jZIFz5EZlVmrRaxw8w6Pk1CMK3pRJDm0NL+siegECka3xXNBMQ0g
         EplumX0OXj7tll1VU7NzxtP5DjvIYOuE/u/ZDmsV8J8HS/Ve7i4H/PDeFbXV15noVngq
         FDBL0stTDSm4/DLfPcf+kL3LRqvbbX57JCf7P6ROrLcoU3XkatuRuU1sYkhnXlfAAYEf
         8X7xmxII3gpqgg3+ZLFqsvTlGvNIBA7P1ui2yKN6XsK7sR8qt+LAxkfFrEsSxGaYQVeB
         Y+AWBE79KCrZqN2GW9sNs4ke4yR9nWu9ALRJhonDpuKLvor3FPpnChQ/u5M8Osii83tg
         VJ9g==
X-Gm-Message-State: ACrzQf0amW8L78gfMniWid84oj7krf/l2NyKU9FtbvqYm11ThsEibG3C
        mSoQ3neVm1TPT+pOODtuYt0=
X-Google-Smtp-Source: AMsMyM4WwiQfxwMrAO85WbcfHaH/QaOsu71JLPtcGxIY6207P2zl2kaMFx3KXXR9kW58X0SS0BrtGw==
X-Received: by 2002:a05:620a:1519:b0:6ee:af9e:9048 with SMTP id i25-20020a05620a151900b006eeaf9e9048mr2825542qkk.601.1665863401804;
        Sat, 15 Oct 2022 12:50:01 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:b8b9:b1cd:e6fc:2d50])
        by smtp.gmail.com with ESMTPSA id a20-20020a05622a065400b0039853b7b771sm4707455qtb.80.2022.10.15.12.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 12:50:00 -0700 (PDT)
Date:   Sat, 15 Oct 2022 12:49:59 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <Y0sO5yNqQkFQucjb@pop-os.localdomain>
References: <20221006011946.85130-1-bobby.eshleman@bytedance.com>
 <20221006025956-mutt-send-email-mst@kernel.org>
 <20221006073410.ahhqhlhah4lo47o7@sgarzare-redhat>
 <Yzoou4UwOv5lh0hE@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yzoou4UwOv5lh0hE@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 12:11:39AM +0000, Bobby Eshleman wrote:
> On Thu, Oct 06, 2022 at 09:34:10AM +0200, Stefano Garzarella wrote:
> > On Thu, Oct 06, 2022 at 03:08:12AM -0400, Michael S. Tsirkin wrote:
> > > On Wed, Oct 05, 2022 at 06:19:44PM -0700, Bobby Eshleman wrote:
> > > > This patch replaces the struct virtio_vsock_pkt with struct sk_buff.
> > > > 
> > > > Using sk_buff in vsock benefits it by a) allowing vsock to be extended
> > > > for socket-related features like sockmap, b) vsock may in the future
> > > > use other sk_buff-dependent kernel capabilities, and c) vsock shares
> > > > commonality with other socket types.
> > > > 
> > > > This patch is taken from the original series found here:
> > > > https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> > > > 
> > > > Small-sized packet throughput improved by ~5% (from 18.53 Mb/s to 19.51
> > > > Mb/s). Tested using uperf, 16B payloads, 64 threads, 100s, averaged from
> > > > 10 test runs (n=10). This improvement is likely due to packet merging.
> > > > 
> > > > Large-sized packet throughput decreases ~9% (from 27.25 Gb/s to 25.04
> > > > Gb/s). Tested using uperf, 64KB payloads, 64 threads, 100s, averaged
> > > > from 10 test runs (n=10).
> > > > 
> > > > Medium-sized packet throughput decreases ~5% (from 4.0 Gb/s to 3.81
> > > > Gb/s). Tested using uperf, 4k to 8k payload sizes picked randomly
> > > > according to normal distribution, 64 threads, 100s, averaged from 10
> > > > test runs (n=10).
> > > 
> > > It is surprizing to me that the original vsock code managed to outperform
> > > the new one, given that to my knowledge we did not focus on optimizing it.
> > 
> > Yeah mee to.
> > 
> 
> Indeed.
> 
> > From this numbers maybe the allocation cost has been reduced as it performs
> > better with small packets. But with medium to large packets we perform
> > worse, perhaps because previously we were allocating a contiguous buffer up
> > to 64k?
> > Instead alloc_skb() could allocate non-contiguous pages ? (which would solve
> > the problems we saw a few days ago)
> > 
> 
> I think this would be the case with alloc_skb_with_frags(), but
> internally alloc_skb() uses kmalloc() for the payload and sk_buff_head
> slab allocations for the sk_buff itself (all the more confusing to me,
> as the prior allocator also uses two separate allocations per packet).

I think it is related to your implementation of
virtio_transport_add_to_queue(), where you introduced much more
complicated logic than before:

-	spin_lock_bh(&vsock->send_pkt_list_lock);
-	list_add_tail(&pkt->list, &vsock->send_pkt_list);
-	spin_unlock_bh(&vsock->send_pkt_list_lock);
-
+	virtio_transport_add_to_queue(&vsock->send_pkt_queue, skb);

A simple list_add_tail() is definitely faster than your
virtio_transport_skbs_can_merge() check. So, why do you have to merge
skb while we don't merge virtio_vsock_pkt?

_If_ you are trying to mimic TCP, I think you are doing it wrong, it can
be much more efficient if you could do the merge in sendmsg() before skb
is even allocated, see tcp_sendmsg_locked().

Thanks.
