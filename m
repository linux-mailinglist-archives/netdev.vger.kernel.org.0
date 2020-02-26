Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D13416F837
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 07:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgBZGtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 01:49:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53396 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726396AbgBZGtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 01:49:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582699741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zTs0u5uGl9tyXxq8oEd/VN3o2cJO7Hfk1LD3/v5KKQk=;
        b=INWkw553JmSiJtnrC/N+0K1D4D7x6FgZ38QpprZ4ReAwNoXdf+5LmgrwbbAC7SmaRG3SAW
        SsRsyTb8ufXOOiX4r5gn1AgCRqeUOdWoq8ZXFrBxA3gaLv+tWcspL8Ziv9Q3PfpAslLwbC
        A1Up760COiUE9k4ZjO2r6isDybYkPP8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-CiYGB7gkMYqXmPgyyshTcg-1; Wed, 26 Feb 2020 01:48:59 -0500
X-MC-Unique: CiYGB7gkMYqXmPgyyshTcg-1
Received: by mail-qv1-f70.google.com with SMTP id ce2so2605871qvb.23
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 22:48:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zTs0u5uGl9tyXxq8oEd/VN3o2cJO7Hfk1LD3/v5KKQk=;
        b=HdygqvTZRC0WT/IjMej9CLqam1UdWy5+qKPWQUkK5cKIkAQYGyqRLfgzREwvk2/VCQ
         jwWuZXhTpXLe1wM6GKEz8Vn2zFiLPzJ5fXXBtR5AE6cIuiiVXqk2qMcexvV5TU/Hg783
         73163iPZDvzcieDTlVay1UC0QNhZCfSB4XU0RyjQDnVIVqurZc3ERFKJewADpsIHsdu8
         G6IhD+lmtAjwlZ8EAlXd6JffW44VeiWhn7dizj6O836svXo9o1gmLaufWJPuQEkrj9zx
         UQbu4C8Husw/N9g9HXuxmwD8eROiKJE/CHaxTKKjL5PSkzirbCMrwMff3Oi2awWZALJb
         wikA==
X-Gm-Message-State: APjAAAX3WxpfaiKyvt94p0nFJYk2O2oXEdPk6FjX30OBVOm0LiadXznH
        aHqDL7xJ7DpJfFXU16TuOD0QcMLJJhkgakaWLc3Wu70ot9dHuKydwnV7S0g/VMZu75ijG0WeALk
        hI7zia+BL3/aL/4A8
X-Received: by 2002:a37:ae85:: with SMTP id x127mr614762qke.190.1582699739092;
        Tue, 25 Feb 2020 22:48:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwnmyAvL0ZjIabQ8fY+cGwWvZWY3SLMpLVp/01Z234rN51OtWm8OZ+fbSs50cRJRsxV+f556g==
X-Received: by 2002:a37:ae85:: with SMTP id x127mr614739qke.190.1582699738847;
        Tue, 25 Feb 2020 22:48:58 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id j127sm661733qkc.36.2020.02.25.22.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 22:48:57 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:48:53 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
Message-ID: <20200226014333-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 11:00:40AM +0800, Jason Wang wrote:
> 
> On 2020/2/26 上午8:57, David Ahern wrote:
> > From: David Ahern <dahern@digitalocean.com>
> > 
> > virtio_net currently requires extra queues to install an XDP program,
> > with the rule being twice as many queues as vcpus. From a host
> > perspective this means the VM needs to have 2*vcpus vhost threads
> > for each guest NIC for which XDP is to be allowed. For example, a
> > 16 vcpu VM with 2 tap devices needs 64 vhost threads.
> > 
> > The extra queues are only needed in case an XDP program wants to
> > return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
> > additional queues. Relax the queue requirement and allow XDP
> > functionality based on resources. If an XDP program is loaded and
> > there are insufficient queues, then return a warning to the user
> > and if a program returns XDP_TX just drop the packet. This allows
> > the use of the rest of the XDP functionality to work without
> > putting an unreasonable burden on the host.
> > 
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: David Ahern <dahern@digitalocean.com>
> > ---
> >   drivers/net/virtio_net.c | 14 ++++++++++----
> >   1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 2fe7a3188282..2f4c5b2e674d 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -190,6 +190,8 @@ struct virtnet_info {
> >   	/* # of XDP queue pairs currently used by the driver */
> >   	u16 xdp_queue_pairs;
> > +	bool can_do_xdp_tx;
> > +
> >   	/* I like... big packets and I cannot lie! */
> >   	bool big_packets;
> > @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
> >   			len = xdp.data_end - xdp.data;
> >   			break;
> >   		case XDP_TX:
> > +			if (!vi->can_do_xdp_tx)
> > +				goto err_xdp;
> 
> 
> I wonder if using spinlock to synchronize XDP_TX is better than dropping
> here?
> 
> Thanks

I think it's less a problem with locking, and more a problem
with queue being potentially full and XDP being unable to
transmit.

From that POV just sharing the queue would already be better than just
an uncondiitonal drop, however I think this is not what XDP users came
to expect. So at this point, partitioning the queue might be reasonable.
When XDP attaches we could block until queue is mostly empty. However,
how exactly to partition the queue remains open.  Maybe it's reasonable
to limit number of RX buffers to achieve balance.

> 
> >   			stats->xdp_tx++;
> >   			xdpf = convert_to_xdp_frame(&xdp);
> >   			if (unlikely(!xdpf))
> > @@ -870,6 +874,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> >   			}
> >   			break;
> >   		case XDP_TX:
> > +			if (!vi->can_do_xdp_tx)
> > +				goto err_xdp;
> >   			stats->xdp_tx++;
> >   			xdpf = convert_to_xdp_frame(&xdp);
> >   			if (unlikely(!xdpf))
> > @@ -2435,10 +2441,10 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> >   	/* XDP requires extra queues for XDP_TX */
> >   	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
> > -		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
> > -		netdev_warn(dev, "request %i queues but max is %i\n",
> > -			    curr_qp + xdp_qp, vi->max_queue_pairs);
> > -		return -ENOMEM;
> > +		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available; XDP_TX will not be allowed");
> > +		vi->can_do_xdp_tx = false;
> > +	} else {
> > +		vi->can_do_xdp_tx = true;
> >   	}
> >   	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);

