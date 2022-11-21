Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2FE644ACF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiLFSHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLFSHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:07:07 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027A737FAC;
        Tue,  6 Dec 2022 10:07:07 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id 4so14747543pli.0;
        Tue, 06 Dec 2022 10:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ljNu6S0OSDZyXnvb0ijspBr9gVj4Qc/YnF3bNQn/I8=;
        b=HUCh9k37yTzeCdInyu8rQfSW8oViWo+tNYrb2OsXsMJvyQY9Ps+qUBmZaEh/33naYG
         7/yyMqicAb8fw9sd3Sum3QzudFwsPHcC5ZYmpGkeG6g0Nr541fVfe7t2J+xY1pk5p1NE
         BQfs8JWXwMICNZO4CiDUztlTYoRF4QUjQNnfaob+OUxXFdD4GmkZdN1nNfXlZ+rDDERf
         6bv7hTW2jtJ4JAss91X/4al3E3TT15Mo1TquA6TDVToGyCyhNPlMyloebnvDZQMjhiyz
         8rwnWsCkKMElaTtmd7d30RYD1oQOm0PHt2nk6NpYt6X91kGuyS89d0k9KpS0GYrvuq5k
         F2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ljNu6S0OSDZyXnvb0ijspBr9gVj4Qc/YnF3bNQn/I8=;
        b=TxCyVCyWzO8HB9fuMH92/2vO+ewJenmsZV+SRBgh7jqehvYFtm9v3HO7ynkAGJzlUQ
         8+zGKvwQeCYJEMY+U5jl7Pa/HY2YheUmCTDU4rePQT1PTc5/+2kP8zeXCOMHaEPuC4X0
         XRwjaOFzLy4whGs5QlafuwWv2ppk6R/mH/6cHvbpgSMwlXhR4dG1X8kHF8jyPnQPxlm3
         yhcVtxcoNaClqqjpDfcrH2G6VoZYoTppfTYRKY5doObV8SXLyyiEdJgmMRLhUIQMlqcR
         XwNtvrzU2YApZf0riqe1s+Pc5RH8eekgfWdo3T6R57xXhlb0IckQdMqUNkyZcaRwffyU
         LIpA==
X-Gm-Message-State: ANoB5plGyzwi5MwdVmSjVhaVKCuOMVMNgqL16gOqHYS0aqVbWxKskdqJ
        y+Vefh020IEUmX6zmL1LN8HQI6kpHIMZaQ==
X-Google-Smtp-Source: AA0mqf5L0pfy4aPghPHJFiy0VeVhIUfZMuusO47/oVX9fjml+QDK4+nwV11JSirp89DdH8DuDuALwQ==
X-Received: by 2002:a17:902:74c5:b0:189:5e36:c051 with SMTP id f5-20020a17090274c500b001895e36c051mr60157628plt.174.1670350026349;
        Tue, 06 Dec 2022 10:07:06 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902714400b0017f756563bcsm12919323plm.47.2022.12.06.10.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:07:05 -0800 (PST)
Date:   Mon, 21 Nov 2022 12:01:12 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] virtio/vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <Y3toiPtBgOcrb8TL@bullseye>
References: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
 <863a58452b4a4c0d63a41b0f78b59d32919067fa.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863a58452b4a4c0d63a41b0f78b59d32919067fa.camel@redhat.com>
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

On Tue, Dec 06, 2022 at 11:20:21AM +0100, Paolo Abeni wrote:
> Hello,
> 
> On Fri, 2022-12-02 at 09:35 -0800, Bobby Eshleman wrote:
> [...]
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > index 35d7eedb5e8e..6c0b2d4da3fe 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -3,10 +3,129 @@
> >  #define _LINUX_VIRTIO_VSOCK_H
> >  
> >  #include <uapi/linux/virtio_vsock.h>
> > +#include <linux/bits.h>
> >  #include <linux/socket.h>
> >  #include <net/sock.h>
> >  #include <net/af_vsock.h>
> >  
> > +#define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
> > +
> > +enum virtio_vsock_skb_flags {
> > +	VIRTIO_VSOCK_SKB_FLAGS_REPLY		= BIT(0),
> > +	VIRTIO_VSOCK_SKB_FLAGS_TAP_DELIVERED	= BIT(1),
> > +};
> > +
> > +static inline struct virtio_vsock_hdr *virtio_vsock_hdr(struct sk_buff *skb)
> > +{
> > +	return (struct virtio_vsock_hdr *)skb->head;
> > +}
> > +
> > +static inline bool virtio_vsock_skb_reply(struct sk_buff *skb)
> > +{
> > +	return skb->_skb_refdst & VIRTIO_VSOCK_SKB_FLAGS_REPLY;
> > +}
> 
> I'm sorry for the late feedback. The above is extremelly risky: if the
> skb will land later into the networking stack, we could experience the
> most difficult to track bugs.
> 
> You should use the skb control buffer instead (skb->cb), with the
> additional benefit you could use e.g. bool - the compiler could emit
> better code to manipulate such fields - and you will not need to clear
> the field before release nor enqueue.
> 
> [...]
> 

Hey Paolo, thank you for the review. For my own learning, this would
happen presumably when the skb is dropped? And I assume we don't see
this in sockmap because it is always cleared before leaving sockmap's
hands? I sanity checked this patch with an out-of-tree patch I have that
uses the networking stack, but I suspect I didn't see issues because my
test harness didn't induce dropping...

I originally avoided skb->cb because the reply flag is set at allocation
and would potentially be clobbered by a pass through the networking
stack. The reply flag would be used after a pass through the networking
stack (e.g., during transmission at the device level and when sockets
close while skbs are still queued for xmit).

I suppose using skb->cb would look like something like this:
- use skb_clone() for reply skbs
- set reply on the cloned sk_buff skb->cb
- keep a hashmap mapping original skb to cloned skb (is there a better
  way?)
- when choosing to apply reply logic, if skb_cloned() refer to the
  hashmap

Is there a better/simpler way to maintain skb->cb?

> > @@ -352,37 +360,38 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> >  				   size_t len)
> >  {
> >  	struct virtio_vsock_sock *vvs = vsk->trans;
> > -	struct virtio_vsock_pkt *pkt;
> >  	size_t bytes, total = 0;
> > -	u32 free_space;
> > +	struct sk_buff *skb;
> >  	int err = -EFAULT;
> > +	u32 free_space;
> >  
> >  	spin_lock_bh(&vvs->rx_lock);
> > -	while (total < len && !list_empty(&vvs->rx_queue)) {
> > -		pkt = list_first_entry(&vvs->rx_queue,
> > -				       struct virtio_vsock_pkt, list);
> > +	while (total < len && !skb_queue_empty_lockless(&vvs->rx_queue)) {
> > +		skb = __skb_dequeue(&vvs->rx_queue);
> 
> Here the locking schema is confusing. It looks like vvs->rx_queue is
> under vvs->rx_lock protection, so the above should be skb_queue_empty()
> instead of the lockless variant.
> 
> [...]
> 
> > @@ -858,16 +873,11 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> >  static void virtio_transport_remove_sock(struct vsock_sock *vsk)
> >  {
> >  	struct virtio_vsock_sock *vvs = vsk->trans;
> > -	struct virtio_vsock_pkt *pkt, *tmp;
> >  
> >  	/* We don't need to take rx_lock, as the socket is closing and we are
> >  	 * removing it.
> >  	 */
> > -	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
> > -		list_del(&pkt->list);
> > -		virtio_transport_free_pkt(pkt);
> > -	}
> > -
> > +	virtio_vsock_skb_queue_purge(&vvs->rx_queue);
> 
> Still assuming rx_queue is under the rx_lock, given you don't need the
> locking here as per the above comment, you should use the lockless
> purge variant.
> 

Good catch, thanks!

Thanks again,
Bobby
