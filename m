Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B5A16F980
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgBZIVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:21:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59428 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727311AbgBZIVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:21:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582705295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MIUFZi1ECwyW5FR6V19xBaNUYIMack+vSSWvg2VsD+E=;
        b=RQIGp60bMivbj5hKWmj5waLsxYWm9k/S3oVIeFVhiZQo7g5KpYzW8oYIg1lJJqfEfweKc5
        ArtTdlnLjaMo9SRrtUHf5NonBQ2DwAERnmEd+84iqQe2Sw9gw1fzoE3GTLdpq1BO0StpMS
        WSxSJe3WuXBv6kFlPV1J6YzLjVRGln0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-S_ZW7hMEOLKPfWuE0RgYeA-1; Wed, 26 Feb 2020 03:21:33 -0500
X-MC-Unique: S_ZW7hMEOLKPfWuE0RgYeA-1
Received: by mail-qk1-f199.google.com with SMTP id 200so3072880qkd.10
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:21:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MIUFZi1ECwyW5FR6V19xBaNUYIMack+vSSWvg2VsD+E=;
        b=C2bNPbyAT1Pbv3y1UOMAHsvEVCr4TjMW+/DrnopecRTGjor2HwSspb4btEqFjUugTY
         TVVtLPNVKfcw7QsT3xC7gwoThC3NJ+b5YF0AKKhstDvTPBFAh6eH6vbJHuZy5UVSFy4v
         YLhWbTOIATzjuoyO11MmDhbewueDE9KeCFRpJR6iJoJT6hQRu/uh6pkPfDiRZaupAwZB
         dDErw98ZVk5uBoooYS9o7WbKjSlMCJUN6m0ZKktYUAWCFuKKUjKYxfyhb54U5bVxcMT2
         86S2Bh4M28jMMxiYVnCuXGgwlAsiXmUgIS96s/39Jn2RyLdHGnYAJDEsatvMeGwf66Os
         VytQ==
X-Gm-Message-State: APjAAAWAg601st3vmXbduo5qWIlFZzQP6D1aklttcUQiuZUwm/oNXlu7
        CXgeQwD4H48/jx9ZXhJlvBIdHTFxH7tm+IvhDEb6jCSAEmty2R+vLQWoH7klnPixh+CEQJ6/TcT
        Y0jfnlqyNYd9ODtMN
X-Received: by 2002:ad4:5562:: with SMTP id w2mr3857253qvy.147.1582705292861;
        Wed, 26 Feb 2020 00:21:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqxeUa43A19794D2L5zC1A1NkBc13i9RWxOGz8Xkizbo0KuUkkoWWTFl0Eaj9avgr0FbIkV7cA==
X-Received: by 2002:ad4:5562:: with SMTP id w2mr3857219qvy.147.1582705292571;
        Wed, 26 Feb 2020 00:21:32 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id s2sm745615qkj.59.2020.02.26.00.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:21:31 -0800 (PST)
Date:   Wed, 26 Feb 2020 03:21:27 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
Message-ID: <20200226031437-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <20200226014333-mutt-send-email-mst@kernel.org>
 <449099311.10687151.1582702090890.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <449099311.10687151.1582702090890.JavaMail.zimbra@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 02:28:10AM -0500, Jason Wang wrote:
> 
> 
> ----- Original Message -----
> > On Wed, Feb 26, 2020 at 11:00:40AM +0800, Jason Wang wrote:
> > > 
> > > On 2020/2/26 上午8:57, David Ahern wrote:
> > > > From: David Ahern <dahern@digitalocean.com>
> > > > 
> > > > virtio_net currently requires extra queues to install an XDP program,
> > > > with the rule being twice as many queues as vcpus. From a host
> > > > perspective this means the VM needs to have 2*vcpus vhost threads
> > > > for each guest NIC for which XDP is to be allowed. For example, a
> > > > 16 vcpu VM with 2 tap devices needs 64 vhost threads.
> > > > 
> > > > The extra queues are only needed in case an XDP program wants to
> > > > return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
> > > > additional queues. Relax the queue requirement and allow XDP
> > > > functionality based on resources. If an XDP program is loaded and
> > > > there are insufficient queues, then return a warning to the user
> > > > and if a program returns XDP_TX just drop the packet. This allows
> > > > the use of the rest of the XDP functionality to work without
> > > > putting an unreasonable burden on the host.
> > > > 
> > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > Signed-off-by: David Ahern <dahern@digitalocean.com>
> > > > ---
> > > >   drivers/net/virtio_net.c | 14 ++++++++++----
> > > >   1 file changed, 10 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 2fe7a3188282..2f4c5b2e674d 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -190,6 +190,8 @@ struct virtnet_info {
> > > >   	/* # of XDP queue pairs currently used by the driver */
> > > >   	u16 xdp_queue_pairs;
> > > > +	bool can_do_xdp_tx;
> > > > +
> > > >   	/* I like... big packets and I cannot lie! */
> > > >   	bool big_packets;
> > > > @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(struct
> > > > net_device *dev,
> > > >   			len = xdp.data_end - xdp.data;
> > > >   			break;
> > > >   		case XDP_TX:
> > > > +			if (!vi->can_do_xdp_tx)
> > > > +				goto err_xdp;
> > > 
> > > 
> > > I wonder if using spinlock to synchronize XDP_TX is better than dropping
> > > here?
> > > 
> > > Thanks
> > 
> > I think it's less a problem with locking, and more a problem
> > with queue being potentially full and XDP being unable to
> > transmit.
> 
> I'm not sure we need care about this. Even XDP_TX with dedicated queue
> can meet this. And XDP generic work like this.

Well with rx queue matching tx queue depth, this might work out well.

> > 
> > From that POV just sharing the queue would already be better than just
> > an uncondiitonal drop, however I think this is not what XDP users came
> > to expect. So at this point, partitioning the queue might be reasonable.
> > When XDP attaches we could block until queue is mostly empty.
> 
> This mean XDP_TX have a higher priority which I'm not sure is good.
> 
> > However,
> > how exactly to partition the queue remains open.
> 
> It would be not easy unless we have support from virtio layer.
> 
> 
> > Maybe it's reasonable
> > to limit number of RX buffers to achieve balance.
> >
> 
> If I understand this correctly, this can only help to throttle
> XDP_TX. But we may have XDP_REDIRECT ...
> 
> So consider either dropping or sharing is much better than not enable
> XDP, we may start from them.
> 
> Thanks

Yea, sharing is at least simple.

Going forward, with the new proposal for RSS recently accepted by virtio TC,
maybe it makes sense to use that in Linux.
Driver then gets full control over which RX queues are in use,
and so something like ethtool can then be used to
direct which queues are for which purpose.

Does anyone have cycles for the above?
Cc Yuri who added this to the spec.

-- 
MST

