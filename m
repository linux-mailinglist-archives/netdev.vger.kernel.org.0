Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EDC5EE3B2
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 19:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiI1R6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 13:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiI1R6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 13:58:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0596E1003AE;
        Wed, 28 Sep 2022 10:58:30 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a29so13195544pfk.5;
        Wed, 28 Sep 2022 10:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=15MXwlGp8DHWOSHNdUEC95cxAZTsu8kuebEqCuCxfvs=;
        b=k4lDfivKyIE5RxHPes2zmTkxu6/h25Yxz217JgbjYNB6e4MEUH1lxwXgyg74CVapUB
         eOTJtaIZWcc1v7FTuj1gokeIjI2FWl/rZ6DoFxsaKNU7nFQzS00OiR0+yZwbPUCWsBaj
         b+JZxUrCoq8dzHunvZIq+YVZ2LXwmNM4HX4R+YliCp8d6CrWFr+mXcW8b06VGtUCtwGG
         nVcdxhIPjVjb4sgE2PCcvJzp6HC2HsTaYjpE9l0/ULxN2XcqDC8TgwP10buH/B4ikrjA
         4jRvae9XAgnKfeDffS+86GSnYxtReOzleMKDTLHkiOBsbHnI8L322WlvANpaZ09B71W3
         X61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=15MXwlGp8DHWOSHNdUEC95cxAZTsu8kuebEqCuCxfvs=;
        b=2d5ye4aYvi2ANzcxqhG6zwfw/CcXtetNcFxNidu3mPtpGtP5QrET/zsQU/0LWXrl9q
         +YSZK4Esz/pYYvZM6SWBMoRDT1xt9LuGfH90YUVautaVTDPf8wyC8OEBrq1HqhFPB1QM
         Db5A93AyaeW4MknmF//MQ3VEbHg2S6RAwWeqOWUI0yQUHl4nFkZsr+mrLyy5uZOpP1OX
         d9j48iydqwsRJ8Nw9kbvEHpmjQv5gStS6kwC0vKfP4af2s64Qz48TQtsXl06SyWpCvYs
         ZFKmbR0pghb1YU9bJDxSgglzMaeH5JOrM1GWG8Lbe3iqiImuhzHeC3kPA5OljU1Vk4Od
         9nKg==
X-Gm-Message-State: ACrzQf1LMIV+7VD7+ysPlmfihoei2vTTiiWQ8FT61VMSDYSKEYLY7S3t
        0IM/jDiTKO0HmsuGm1TH8VY=
X-Google-Smtp-Source: AMsMyM4lk6YYwQmuzVsdQ5WpOvTn7X9yBjhJVuesFs56YgavUb5Uk4cEzAEU+5e6WH0IrJ5UFxn6FQ==
X-Received: by 2002:a63:4143:0:b0:43a:20d4:a438 with SMTP id o64-20020a634143000000b0043a20d4a438mr30695194pga.452.1664387909512;
        Wed, 28 Sep 2022 10:58:29 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id b66-20020a62cf45000000b0052d46b43006sm4349915pfg.156.2022.09.28.10.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 10:58:28 -0700 (PDT)
Date:   Tue, 27 Sep 2022 10:36:20 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Junichi Uekawa <uekawa@chromium.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <YzLSJLq0gTpqPwoY@bullseye>
References: <20220928064538.667678-1-uekawa@chromium.org>
 <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org>
 <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 05:11:35PM +0200, Stefano Garzarella wrote:
> On Wed, Sep 28, 2022 at 05:31:58AM -0400, Michael S. Tsirkin wrote:
> > On Wed, Sep 28, 2022 at 10:28:23AM +0200, Stefano Garzarella wrote:
> > > On Wed, Sep 28, 2022 at 03:45:38PM +0900, Junichi Uekawa wrote:
> > > > When copying a large file over sftp over vsock, data size is usually 32kB,
> > > > and kmalloc seems to fail to try to allocate 32 32kB regions.
> > > >
> > > > Call Trace:
> > > >  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
> > > >  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
> > > >  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
> > > >  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
> > > >  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
> > > >  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
> > > >  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
> > > >  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
> > > >  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
> > > >  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
> > > >  [<ffffffffb683ddce>] kthread+0xfd/0x105
> > > >  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
> > > >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > > >  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
> > > >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > > >
> > > > Work around by doing kvmalloc instead.
> > > >
> > > > Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
> > 
> > My worry here is that this in more of a work around.
> > It would be better to not allocate memory so aggressively:
> > if we are so short on memory we should probably process
> > packets one at a time. Is that very hard to implement?
> 
> Currently the "virtio_vsock_pkt" is allocated in the "handle_kick" callback
> of TX virtqueue. Then the packet is multiplexed on the right socket queue,
> then the user space can de-queue it whenever they want.
> 
> So maybe we can stop processing the virtqueue if we are short on memory, but
> when can we restart the TX virtqueue processing?
> 
> I think as long as the guest used only 4K buffers we had no problem, but now
> that it can create larger buffers the host may not be able to allocate it
> contiguously. Since there is no need to have them contiguous here, I think
> this patch is okay.
> 
> However, if we switch to sk_buff (as Bobby is already doing), maybe we don't
> have this problem because I think there is some kind of pre-allocated pool.
> 
> > 
> > 
> > 
> > > > ---
> > > >
> > > > drivers/vhost/vsock.c                   | 2 +-
> > > > net/vmw_vsock/virtio_transport_common.c | 2 +-
> > > > 2 files changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > > index 368330417bde..5703775af129 100644
> > > > --- a/drivers/vhost/vsock.c
> > > > +++ b/drivers/vhost/vsock.c
> > > > @@ -393,7 +393,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> > > > 		return NULL;
> > > > 	}
> > > >
> > > > -	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
> > > > +	pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
> > > > 	if (!pkt->buf) {
> > > > 		kfree(pkt);
> > > > 		return NULL;
> > > > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > > > index ec2c2afbf0d0..3a12aee33e92 100644
> > > > --- a/net/vmw_vsock/virtio_transport_common.c
> > > > +++ b/net/vmw_vsock/virtio_transport_common.c
> > > > @@ -1342,7 +1342,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
> > > >
> > > > void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
> > > > {
> > > > -	kfree(pkt->buf);
> > > > +	kvfree(pkt->buf);
> > > 
> > > virtio_transport_free_pkt() is used also in virtio_transport.c and
> > > vsock_loopback.c where pkt->buf is allocated with kmalloc(), but IIUC
> > > kvfree() can be used with that memory, so this should be fine.
> > > 
> > > > 	kfree(pkt);
> > > > }
> > > > EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
> > > > --
> > > > 2.37.3.998.g577e59143f-goog
> > > >
> > > 
> > > This issue should go away with the Bobby's work about introducing sk_buff
> > > [1], but we can queue this for now.
> > > 

I also expect the sk_buff allocator can handle this. I've tested the
sk_buff patch with 64K payloads via uperf without issue.
