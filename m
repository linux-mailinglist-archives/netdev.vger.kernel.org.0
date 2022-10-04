Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAAE06022D8
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 05:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiJRDmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 23:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiJRDm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 23:42:26 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A287549B6F;
        Mon, 17 Oct 2022 20:40:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m6so12958312pfb.0;
        Mon, 17 Oct 2022 20:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wr5/VrN02VfWVz0aMlleq7PLncTfzwdhLS5d4kdkvB0=;
        b=cq2rlQgpCR3/4EyPkzBbsxSd4qbYeNbyGdnvps88EC3yZl4PNCp4VYMmGpAj3i1UGT
         i6KVJV7RQbZ9X/sHwhHEMulcrPdGrpWTm5Cuq1uN7XF2GJXRqpbReK4x8ehFKIAOTFrj
         6IYV6PSyP64F7l6408uRr90MSPMgFRDYpeD5XqdA4BeVDobVQCjDTSDABHN3kkMZQM3o
         ElZyQNSsL7aerJ1iavpUPG0UrV6N2anudvTbqiz5YvY6pSW62kpQDUH7wi02x1DvUnW8
         1Rgc045Qpxojk+w7Osutu02nwDAI4959fYV5hkZQ9BwbZOdqFGrfe0hdlFxKgrvjfT8G
         npVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wr5/VrN02VfWVz0aMlleq7PLncTfzwdhLS5d4kdkvB0=;
        b=Wzd81jnQMv4NZKweBhqyrmvUw9FAGrxTbzrAuInKONHGfYZ4qnhskEfT70PZ37444/
         Iltb5AHTdqFUFPzKqa133h74wxyaOu99k0ZK/Jz4VHZ+q46vpob3vBu7pHfjRZfkQUPy
         U5RPIqAr7s4h14lVQ19DK2KMaRLxrHgnDv5GROkznVQBjYz8EFL64TmInpAXrHZb+R3+
         T+rJk7KW4bLpgO2pvgDbBpaxqODqPJkg7zXGxrz7Y5oxK1sEm1uGL2wmC/T/L+S/dFga
         3KU81giEB+GlOi3kZ5sVhCnVn1A3Q/cOpyotsjsSusg6V1KYstHUXbPX3gjgCza2yQ5s
         HmBA==
X-Gm-Message-State: ACrzQf39zRI7GnzR9ffu2rdWG5+L1QgPtcXLs6/0h5DyhR6Tks40CX4c
        GUt1OVCvuGmNIBi4xSj6/J4=
X-Google-Smtp-Source: AMsMyM55cRa1R1Nj3ygjmAcBVetRmj0g6Y0tW6r35DzJI6AKG4Fk3TWt2RM016V71niWBzQfK9i3gA==
X-Received: by 2002:a63:5766:0:b0:440:2960:37d with SMTP id h38-20020a635766000000b004402960037dmr956292pgm.278.1666064414804;
        Mon, 17 Oct 2022 20:40:14 -0700 (PDT)
Received: from localhost (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id 83-20020a621456000000b0056203db46ffsm8119756pfu.172.2022.10.17.20.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 20:40:14 -0700 (PDT)
Date:   Tue, 4 Oct 2022 22:50:28 +0000
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
Message-ID: <Yzy4tEGXSZcLYkLv@bullseye>
References: <20221006011946.85130-1-bobby.eshleman@bytedance.com>
 <20221006025956-mutt-send-email-mst@kernel.org>
 <20221006073410.ahhqhlhah4lo47o7@sgarzare-redhat>
 <Yzoou4UwOv5lh0hE@bullseye>
 <Y0sO5yNqQkFQucjb@pop-os.localdomain>
 <Yzyr60cn468ph8Io@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yzyr60cn468ph8Io@bullseye>
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

On Tue, Oct 04, 2022 at 09:55:55PM +0000, Bobby Eshleman wrote:
> On Sat, Oct 15, 2022 at 12:49:59PM -0700, Cong Wang wrote:
> > On Mon, Oct 03, 2022 at 12:11:39AM +0000, Bobby Eshleman wrote:
> > > On Thu, Oct 06, 2022 at 09:34:10AM +0200, Stefano Garzarella wrote:
> > > > On Thu, Oct 06, 2022 at 03:08:12AM -0400, Michael S. Tsirkin wrote:
> > > > > On Wed, Oct 05, 2022 at 06:19:44PM -0700, Bobby Eshleman wrote:
> > > > > > This patch replaces the struct virtio_vsock_pkt with struct sk_buff.
> > > > > > 
> > > > > > Using sk_buff in vsock benefits it by a) allowing vsock to be extended
> > > > > > for socket-related features like sockmap, b) vsock may in the future
> > > > > > use other sk_buff-dependent kernel capabilities, and c) vsock shares
> > > > > > commonality with other socket types.
> > > > > > 
> > > > > > This patch is taken from the original series found here:
> > > > > > https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> > > > > > 
> > > > > > Small-sized packet throughput improved by ~5% (from 18.53 Mb/s to 19.51
> > > > > > Mb/s). Tested using uperf, 16B payloads, 64 threads, 100s, averaged from
> > > > > > 10 test runs (n=10). This improvement is likely due to packet merging.
> > > > > > 
> > > > > > Large-sized packet throughput decreases ~9% (from 27.25 Gb/s to 25.04
> > > > > > Gb/s). Tested using uperf, 64KB payloads, 64 threads, 100s, averaged
> > > > > > from 10 test runs (n=10).
> > > > > > 
> > > > > > Medium-sized packet throughput decreases ~5% (from 4.0 Gb/s to 3.81
> > > > > > Gb/s). Tested using uperf, 4k to 8k payload sizes picked randomly
> > > > > > according to normal distribution, 64 threads, 100s, averaged from 10
> > > > > > test runs (n=10).
> > > > > 
> > > > > It is surprizing to me that the original vsock code managed to outperform
> > > > > the new one, given that to my knowledge we did not focus on optimizing it.
> > > > 
> > > > Yeah mee to.
> > > > 
> > > 
> > > Indeed.
> > > 
> > > > From this numbers maybe the allocation cost has been reduced as it performs
> > > > better with small packets. But with medium to large packets we perform
> > > > worse, perhaps because previously we were allocating a contiguous buffer up
> > > > to 64k?
> > > > Instead alloc_skb() could allocate non-contiguous pages ? (which would solve
> > > > the problems we saw a few days ago)
> > > > 
> > > 
> > > I think this would be the case with alloc_skb_with_frags(), but
> > > internally alloc_skb() uses kmalloc() for the payload and sk_buff_head
> > > slab allocations for the sk_buff itself (all the more confusing to me,
> > > as the prior allocator also uses two separate allocations per packet).
> > 
> > I think it is related to your implementation of
> > virtio_transport_add_to_queue(), where you introduced much more
> > complicated logic than before:
> > 
> > -	spin_lock_bh(&vsock->send_pkt_list_lock);
> > -	list_add_tail(&pkt->list, &vsock->send_pkt_list);
> > -	spin_unlock_bh(&vsock->send_pkt_list_lock);
> > -
> > +	virtio_transport_add_to_queue(&vsock->send_pkt_queue, skb);
> > 
> 
> I wish it were that easy, but I included this change because it actually
> boosts performance.
> 
> For 16B payloads, this change improves throughput from 16 Mb/s to 20Mb/s
> in my test harness, and reduces the memory usage of the kmalloc-512 and
> skbuff_head_cache slab caches by ~50MB at cache size peak (total slab
> cache size from ~540MB to ~390MB), but typically (not at peak) the slab

Edit:  from ~590MB to ~540MB. Mixed up numbers in editing the
paragraph.

> cache size when this merging is used keeps the memory slab caches closer
> to ~150MB smaller. Tests done using uperf.
> 

> For payloads greater than GOOD_COPY_LEN I don't see any any notable
> difference between the skb code with merging and the skb code without
> merging in terms of throughput. I assume this is because the skb->len
> comparison with GOOD_COPY_LEN should short circuit the expression and
> the other memory operations should not occur.
> 
> > A simple list_add_tail() is definitely faster than your
> > virtio_transport_skbs_can_merge() check. So, why do you have to merge
> > skb while we don't merge virtio_vsock_pkt?
> > 
> 
> sk_buff is over twice the size of virtio_vsock_pkt (96B vs 232B). It
> seems wise to reduce the footprint in other ways to try and keep it
> comparable.
> 
> > _If_ you are trying to mimic TCP, I think you are doing it wrong, it can
> > be much more efficient if you could do the merge in sendmsg() before skb
> > is even allocated, see tcp_sendmsg_locked().
> 
> I'll definitely give it a read, merging before allocating an skb sounds
> better.
> 
> Best,
> Bobby
