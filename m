Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450051BA7D4
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgD0PVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:21:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34546 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbgD0PVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588000871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t0zUuDSHC2LYYJLNAsloYEAAqSEOkEn10YRd/wXdi+k=;
        b=L7Oyf6nK2tf3SjMGJOtrgJaE8E/LR+vAYZ95rtkwkZ/eq+/way1jO8MBnsbMw7XQ9j3ZBb
        tz9b18i4FyNhaPkUqBJlAxPuHwI80MjVJeOow52xO1owm3Bm5aE71PSrvDLlnU+K3DpiD5
        XxXnKKfrpEmyFWH6CxAI1vzLv6P/6Rs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-Do2aYI6jORuogjpAgL3FXw-1; Mon, 27 Apr 2020 11:21:08 -0400
X-MC-Unique: Do2aYI6jORuogjpAgL3FXw-1
Received: by mail-wr1-f72.google.com with SMTP id p2so10630277wrx.12
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 08:21:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t0zUuDSHC2LYYJLNAsloYEAAqSEOkEn10YRd/wXdi+k=;
        b=nIlZ5vbYO7lt5xEfcB91dr5PkB/NEDWSbdBf3OzIpec+EtQ1eq/9v0/nqqaPn1hA/J
         TjgSqMdYbweb1SXcU8+W4QyBfOgxoUWTRNv0UMmppIrMY1VrbFrXSWGFqvhV1+eldFMf
         tpIsOc296a21iNrIYRIBxNeO8J45Hgz063WvwZ2mNN1TnOqGfztMLseUx3weUPWcsAM+
         nDDTK7Rd9LsJKlKYJWl+zCmX3pU3A9UqX2pgHhwvmFyym/p5FOrcTss3RL84OazzlAQL
         GOwpfWHF0CmWqmjcF85bYs41YOF8J3CAypDpEASlsPkUTXm0jbwLoWLKBaGYjXYJ3pes
         /5Yw==
X-Gm-Message-State: AGi0PubcWuoowaqgjAnl7Ky3wYq1wIA15IG4JxF3BJZfaawaV7Rs7LGP
        XwXOyVNb9XmP/mR8kwKJSl4m6AlyUsBLYcXos9taTbHWAVQ5/MqhuXnXf5vqFGM+ENTTL1Y0je4
        NlhkP0xnn/EcirMEr
X-Received: by 2002:a1c:b445:: with SMTP id d66mr38644wmf.187.1588000867453;
        Mon, 27 Apr 2020 08:21:07 -0700 (PDT)
X-Google-Smtp-Source: APiQypIZ5/J/wN/0wkBkOIE/TjfFJ5VeKIYdPSnC6DlZr/llDxsorbTrSb9AdWnEjmL3w4GukHw2OQ==
X-Received: by 2002:a1c:b445:: with SMTP id d66mr38611wmf.187.1588000867197;
        Mon, 27 Apr 2020 08:21:07 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id r3sm22637536wrx.72.2020.04.27.08.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 08:21:06 -0700 (PDT)
Date:   Mon, 27 Apr 2020 17:21:03 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <20200427152103.r65new4r342crfs6@steredhat>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <20200427102828-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427102828-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 10:31:57AM -0400, Michael S. Tsirkin wrote:
> On Mon, Apr 27, 2020 at 04:25:18PM +0200, Stefano Garzarella wrote:
> > Hi David, Michael, Stefan,
> > I'm restarting to work on this topic since Kata guys are interested to
> > have that, especially on the guest side.
> > 
> > While working on the v2 I had few doubts, and I'd like to have your
> > suggestions:
> > 
> >  1. netns assigned to the device inside the guest
> > 
> >    Currently I assigned this device to 'init_net'. Maybe it is better
> >    if we allow the user to decide which netns assign to the device
> >    or to disable this new feature to have the same behavior as before
> >    (host reachable from any netns).
> >    I think we can handle this in the vsock core and not in the single
> >    transports.
> > 
> >    The simplest way that I found, is to add a new
> >    IOCTL_VM_SOCKETS_ASSIGN_G2H_NETNS to /dev/vsock to enable the feature
> >    and assign the device to the same netns of the process that do the
> >    ioctl(), but I'm not sure it is clean enough.
> > 
> >    Maybe it is better to add new rtnetlink messages, but I'm not sure if
> >    it is feasible since we don't have a netdev device.
> > 
> >    What do you suggest?
> 
> Maybe /dev/vsock-netns here too, like in the host?
> 

I'm not sure I get it.

In the guest, /dev/vsock is only used to get the CID assigned to the
guest through an ioctl().

In the virtio-vsock case, the guest transport is loaded when it is discovered
on the PCI bus, so we need a way to "move" it to a netns or to specify
which netns should be used when it is probed.

> 
> > 
> >  2. netns assigned in the host
> > 
> >     As Michael suggested, I added a new /dev/vhost-vsock-netns to allow
> >     userspace application to use this new feature, leaving to
> >     /dev/vhost-vsock the previous behavior (guest reachable from any
> >     netns).
> > 
> >     I like this approach, but I had these doubts:
> > 
> >     - I need to allocate a new minor for that device (e.g.
> >       VHOST_VSOCK_NETNS_MINOR) or is there an alternative way that I can
> >       use?
> 
> Not that I see. I agree it's a bit annoying. I'll think about it a bit.
> 

Thanks for that!
An idea that I had, was to add a new ioctl to /dev/vhost-vsock to enable
the netns support, but I'm not sure it is a clean approach.

> >     - It is vhost-vsock specific, should we provide something handled in
> >       the vsock core, maybe centralizing the CID allocation and adding a
> >       new IOCTL or rtnetlink message like for the guest side?
> >       (maybe it could be a second step, and for now we can continue with
> >       the new device)
> > 

Thanks,
Stefano

