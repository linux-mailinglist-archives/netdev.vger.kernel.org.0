Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC92560216C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 04:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJRCuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 22:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJRCuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 22:50:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332E639B95;
        Mon, 17 Oct 2022 19:49:55 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c24so12537271pls.9;
        Mon, 17 Oct 2022 19:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MYWDNHPcGSdBQ0TtCNfLbSU+DkA9tEuGDYIVvPAI7/0=;
        b=S644mYldkDdn9IzogmrtxPMghIHrRnYMwInUFSkWmIfIV6u5cT5zDrzmrXP9yXo7dE
         RW0Ve/cxIWCwnv/chDNanT6+qidZGMSdTjz58MD1+sPu2wfHDyKuA8aKkh4MhpwWgg2g
         1XbmqYyrckRGQq1PCvfutsF43+BQaJi9bebuOVXFQsFB++cM5yYMJKpVdn6FoN1G9NSL
         59780SnjTOu6VZ1Wr8YBr6GGvwDXlrOLZ67N6pa7XybsVZNTWxZZXsWlFrpGeBpGI1Nz
         hJqdVGQCcWN06UOlhDahBxTAHs8Q6vqstdu4SRVObuFqU8kq1AIChAwTEHJpzg0Ud6ff
         8SXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYWDNHPcGSdBQ0TtCNfLbSU+DkA9tEuGDYIVvPAI7/0=;
        b=sCTmv59JKd+jddnJUKwKQ9OZpPfUcpcyOqQw31+N/cc7ckUxRiGOvxcMsKePrhXgzi
         DcaXdx4P9N1OMgfyCJeE4ieQ292D5eNIM5i9zZxBbqR1CChU8shJQ+hWrSZ176VLyz7j
         +hujGFTCNBhUb0NGb9fwynXX1jQYMeS+gmnCGS9lmg9cx8vvohFeSOD20EW9Hgth21qG
         GSzoR6QUvzgkajO5/BA5Amu8hBs/80gETzgIDMABP3WRs1lRBK8GqDx9XdswxhKS43kx
         7a+5lW9cO5B0K5u+RCb46Rnh1WuLOuCjTyMh2wTl1CbhZotCJBGAt+ntxu1TCtBQJK1o
         mLfQ==
X-Gm-Message-State: ACrzQf1fRuUhQ8XgioK3av7DylLGrX/cQ5du1zs2XvZAcMi9BnR6FL7X
        KgiMb6eZhYW1S4BbwW1wuek6eCjv8+nQOjFa
X-Google-Smtp-Source: AMsMyM4ZMpYISHTX0CfUx5VRSORVl3Y3s0KqqFAEcuJ9LVkZMBd1zeNk4ESkh1fJ07etLJLfq0r5BQ==
X-Received: by 2002:a17:902:d2cf:b0:185:4bbd:1970 with SMTP id n15-20020a170902d2cf00b001854bbd1970mr854860plc.88.1666061393807;
        Mon, 17 Oct 2022 19:49:53 -0700 (PDT)
Received: from localhost (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902714500b00178323e689fsm7287963plm.171.2022.10.17.19.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 19:49:53 -0700 (PDT)
Date:   Tue, 4 Oct 2022 21:55:55 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
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
Message-ID: <Yzyr60cn468ph8Io@bullseye>
References: <20221006011946.85130-1-bobby.eshleman@bytedance.com>
 <20221006025956-mutt-send-email-mst@kernel.org>
 <20221006073410.ahhqhlhah4lo47o7@sgarzare-redhat>
 <Yzoou4UwOv5lh0hE@bullseye>
 <Y0sO5yNqQkFQucjb@pop-os.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0sO5yNqQkFQucjb@pop-os.localdomain>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 12:49:59PM -0700, Cong Wang wrote:
> On Mon, Oct 03, 2022 at 12:11:39AM +0000, Bobby Eshleman wrote:
> > On Thu, Oct 06, 2022 at 09:34:10AM +0200, Stefano Garzarella wrote:
> > > On Thu, Oct 06, 2022 at 03:08:12AM -0400, Michael S. Tsirkin wrote:
> > > > On Wed, Oct 05, 2022 at 06:19:44PM -0700, Bobby Eshleman wrote:
> > > > > This patch replaces the struct virtio_vsock_pkt with struct sk_buff.
> > > > > 
> > > > > Using sk_buff in vsock benefits it by a) allowing vsock to be extended
> > > > > for socket-related features like sockmap, b) vsock may in the future
> > > > > use other sk_buff-dependent kernel capabilities, and c) vsock shares
> > > > > commonality with other socket types.
> > > > > 
> > > > > This patch is taken from the original series found here:
> > > > > https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> > > > > 
> > > > > Small-sized packet throughput improved by ~5% (from 18.53 Mb/s to 19.51
> > > > > Mb/s). Tested using uperf, 16B payloads, 64 threads, 100s, averaged from
> > > > > 10 test runs (n=10). This improvement is likely due to packet merging.
> > > > > 
> > > > > Large-sized packet throughput decreases ~9% (from 27.25 Gb/s to 25.04
> > > > > Gb/s). Tested using uperf, 64KB payloads, 64 threads, 100s, averaged
> > > > > from 10 test runs (n=10).
> > > > > 
> > > > > Medium-sized packet throughput decreases ~5% (from 4.0 Gb/s to 3.81
> > > > > Gb/s). Tested using uperf, 4k to 8k payload sizes picked randomly
> > > > > according to normal distribution, 64 threads, 100s, averaged from 10
> > > > > test runs (n=10).
> > > > 
> > > > It is surprizing to me that the original vsock code managed to outperform
> > > > the new one, given that to my knowledge we did not focus on optimizing it.
> > > 
> > > Yeah mee to.
> > > 
> > 
> > Indeed.
> > 
> > > From this numbers maybe the allocation cost has been reduced as it performs
> > > better with small packets. But with medium to large packets we perform
> > > worse, perhaps because previously we were allocating a contiguous buffer up
> > > to 64k?
> > > Instead alloc_skb() could allocate non-contiguous pages ? (which would solve
> > > the problems we saw a few days ago)
> > > 
> > 
> > I think this would be the case with alloc_skb_with_frags(), but
> > internally alloc_skb() uses kmalloc() for the payload and sk_buff_head
> > slab allocations for the sk_buff itself (all the more confusing to me,
> > as the prior allocator also uses two separate allocations per packet).
> 
> I think it is related to your implementation of
> virtio_transport_add_to_queue(), where you introduced much more
> complicated logic than before:
> 
> -	spin_lock_bh(&vsock->send_pkt_list_lock);
> -	list_add_tail(&pkt->list, &vsock->send_pkt_list);
> -	spin_unlock_bh(&vsock->send_pkt_list_lock);
> -
> +	virtio_transport_add_to_queue(&vsock->send_pkt_queue, skb);
> 

I wish it were that easy, but I included this change because it actually
boosts performance.

For 16B payloads, this change improves throughput from 16 Mb/s to 20Mb/s
in my test harness, and reduces the memory usage of the kmalloc-512 and
skbuff_head_cache slab caches by ~50MB at cache size peak (total slab
cache size from ~540MB to ~390MB), but typically (not at peak) the slab
cache size when this merging is used keeps the memory slab caches closer
to ~150MB smaller. Tests done using uperf.

For payloads greater than GOOD_COPY_LEN I don't see any any notable
difference between the skb code with merging and the skb code without
merging in terms of throughput. I assume this is because the skb->len
comparison with GOOD_COPY_LEN should short circuit the expression and
the other memory operations should not occur.

> A simple list_add_tail() is definitely faster than your
> virtio_transport_skbs_can_merge() check. So, why do you have to merge
> skb while we don't merge virtio_vsock_pkt?
> 

sk_buff is over twice the size of virtio_vsock_pkt (96B vs 232B). It
seems wise to reduce the footprint in other ways to try and keep it
comparable.

> _If_ you are trying to mimic TCP, I think you are doing it wrong, it can
> be much more efficient if you could do the merge in sendmsg() before skb
> is even allocated, see tcp_sendmsg_locked().

I'll definitely give it a read, merging before allocating an skb sounds
better.

Best,
Bobby
