Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEBC6CED35
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjC2PoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjC2PoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:44:23 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2176530E6;
        Wed, 29 Mar 2023 08:44:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id kc4so15307503plb.10;
        Wed, 29 Mar 2023 08:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680104658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZB9Gng/bSJbqymM4NvT3ASIykRxYTVJWxfwiTANs0tE=;
        b=TG78JGz17hb6VNnIiomQZ2TwfThSO+UL/u1S2kq52LkivTs4Ew+wpK+fYDv89fOSUD
         w3bIzUbJAYlSfF0sHONJLTI27QBHb+cNZwZ/miFycaxLlDRAlMlOtbBkLS+LS3mn2DGK
         q9yoqy8vdfwnriqnwq2dJJmm3/ikZiHUjVA4dj290dU0lZBA4diLTLEc15meIT8gjuMh
         tz5PPvHT6JuTkanNDGOv2s+FfKgqcP1ox+nCDFjbedI2yXfJrWzcBY0lemxzsMfoKFo0
         mtuITW4gRKGYdelhQSwUDLRhqmTaciOa0AzqUeco38aM6bGiDLZVoEYuX4If8x4FOuiL
         dIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680104658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZB9Gng/bSJbqymM4NvT3ASIykRxYTVJWxfwiTANs0tE=;
        b=N3l3FcXf/zia5k3TD2+hFsg3DpHRKfxyowriEKll6Lyn2tOQndcfMIACk5m7VC04ay
         GyZB66YA05sEpbQhiXr6xnky5P1crJ4j2fm57QHjtC7yckNuYijcxUQGC+z/67qV/Rrr
         sJCZr0rqQP5nXGuxGwV/vYPdLPjO1XWYFFqloBVBX4/nErX0LId+ujiBR8wK7v4zBRR+
         plgpoX4V87QLhCNkrpnVUUr7XbYLwFtvlW8LiFJS1ZWQILOIrfk3RGOZ5XBQiFV122Tj
         /7Fg+JaMZVYsdOrWSwTYLdzBg8/3YJcGtqT8aEEPId0q8J/C5yiORrDQwOWFn+EkvYqs
         S8vg==
X-Gm-Message-State: AAQBX9c1vwuL07lOkfNORAIuuTMUmNkdibkqW2IkV+Yx3nsH1nJBwLcX
        pNzDcZAmQdVR1jlQBt+kwas=
X-Google-Smtp-Source: AKy350YasjwLuPGttfZSUOPqjWduhfDk5NxOyn/ELF3HDloNRs6WPm3omC7Gj4l/usW7Zwx8h5aKlA==
X-Received: by 2002:a17:902:d10c:b0:1a0:5524:eb8e with SMTP id w12-20020a170902d10c00b001a05524eb8emr15955262plw.68.1680104658419;
        Wed, 29 Mar 2023 08:44:18 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902a9c400b0019f3da8c2a4sm23112731plr.69.2023.03.29.08.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 08:44:17 -0700 (PDT)
Date:   Sat, 18 Mar 2023 17:50:10 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net v2] virtio/vsock: fix leaks due to missing skb owner
Message-ID: <ZBX50kSQsmSgaH66@bullseye>
References: <20230327-vsock-fix-leak-v2-1-f6619972dee0@bytedance.com>
 <teatarzyqlkgbgxjezbm56ilpsbcq3f6nwvwwfi7f6z7agbgoh@jxwm3mgot2w4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <teatarzyqlkgbgxjezbm56ilpsbcq3f6nwvwwfi7f6z7agbgoh@jxwm3mgot2w4>
X-Spam-Status: No, score=1.9 required=5.0 tests=DATE_IN_PAST_96_XX,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 09:16:19AM +0200, Stefano Garzarella wrote:
> On Tue, Mar 28, 2023 at 04:29:09PM +0000, Bobby Eshleman wrote:
> > This patch sets the skb owner in the recv and send path for virtio.
> > 
> > For the send path, this solves the leak caused when
> > virtio_transport_purge_skbs() finds skb->sk is always NULL and therefore
> > never matches it with the current socket. Setting the owner upon
> > allocation fixes this.
> > 
> > For the recv path, this ensures correctness of accounting and also
> > correct transfer of ownership in vsock_loopback (when skbs are sent from
> > one socket and received by another).
> > 
> > Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
> > Link: https://lore.kernel.org/all/ZCCbATwov4U+GBUv@pop-os.localdomain/
> > ---
> > Changes in v2:
> > - virtio/vsock: add skb_set_owner_r to recv_pkt()
> > - Link to v1: https://lore.kernel.org/r/20230327-vsock-fix-leak-v1-1-3fede367105f@bytedance.com
> > ---
> > net/vmw_vsock/virtio_transport_common.c | 5 +++++
> > 1 file changed, 5 insertions(+)
> > 
> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> > index 957cdc01c8e8..900e5dca05f5 100644
> > --- a/net/vmw_vsock/virtio_transport_common.c
> > +++ b/net/vmw_vsock/virtio_transport_common.c
> > @@ -94,6 +94,9 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> > 					 info->op,
> > 					 info->flags);
> > 
> > +	if (info->vsk)
> > +		skb_set_owner_w(skb, sk_vsock(info->vsk));
> > +
> > 	return skb;
> > 
> > out:
> > @@ -1294,6 +1297,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> > 		goto free_pkt;
> > 	}
> > 
> > +	skb_set_owner_r(skb, sk);
> > +
> > 	vsk = vsock_sk(sk);
> > 
> > 	lock_sock(sk);
> 
> Can you explain why we are using skb_set_owner_w/skb_set_owner_r?
> 
> I'm a little concerned about 2 things:
> - skb_set_owner_r() documentation says: "Stream and sequenced
>   protocols can't normally use this as they need to fit buffers in
>   and play with them."
> - they increment sk_wmem_alloc and sk_rmem_alloc that we never used
>   (IIRC)
> 
> For the long run, I think we should manage memory better, and using
> socket accounting makes sense to me, but since we now have a different
> system (which we have been carrying around since the introduction of
> vsock), I think this change is a bit risky, especially as a fix.
> 
> So my suggestion is to use skb_set_owner_sk_safe() for now, unless I
> missed something about why to use skb_set_owner_w/skb_set_owner_r.
> 

I think that makes sense. I was honestly unaware of
skb_set_owner_sk_safe(), but given the reasons you stated and after
reading its code, I agree it is a better fit in light of vsock's
different accounting scheme.

I'll switch it over in v3.

Best,
Bobby
