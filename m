Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DB010FC5E
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 12:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfLCLRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 06:17:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34929 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725997AbfLCLRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 06:17:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575371867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P0GMfVL6QAezA2eT0aIWQXB/37RirCO0eO2hEzXqpFM=;
        b=gFVruzjSiGxkv8iSoeg1Io5S3NxZaxTBgESUeQZQ3xXUqEpUivEDkZHUidoApQXUkEPDuB
        u0nRBNfzsikXj8UCFk/P/BOceSAaL6qbghGv8khWkbUhJ4lswPW6ljTFQSpr57RBFSj/2A
        P87H56lHEMkxcCdPdgrhb4HHmnbDEvI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-JAY8vFYkMiKoKaBYECl7Bg-1; Tue, 03 Dec 2019 06:17:43 -0500
Received: by mail-wr1-f72.google.com with SMTP id z15so1631741wrw.0
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 03:17:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8m7nF4w29pgZQB4V/SdwIROmAwTn+h+KHeQv4HnXE8M=;
        b=a0wNNMjZ8dRUsZ5l+hl1dA4kru8vOFuT8QxAKSa1cpyTbt+RY72OzEQBGiaKYagP2H
         EXPpkPJ+nGRVpm5M4xDNZlobTVe2xyPvzTZl69b5A+8Aw77z2TSNsEFdqw9+KtIaqipq
         5TKujZzHm29l5VXaV0FCo1WcCoO5lF0cjprU/cBJcgRN6hN9mmU9KWUGgE6Y5NBkNrK3
         Bs+pQk/GBq3wy+4ruB1PQOKv2mEn7mdvrHIQRwe9CjN50LZJWz6qS4nqKPG5e6GrbV/Q
         P+3hsh+h+VApwlU3L9VTupRe5ktNAJiiEW1j9FXqL3AXglk6+sWcy+dh+B4igWZiUHYI
         wuIw==
X-Gm-Message-State: APjAAAUjtZpUyXNkao1y/9cnyIBCEC9D5raGSmr/vx7q985wj32MRT12
        NdZfeU8jqn4N9wXVcgiseW1Xr1qG1UQ5AXT87Kb3RXyu6YHy8Sf1urgEOTcngBI4yhrtSPyJ7RA
        JJ9p+6yxZM+ocC/KU
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr4444054wrs.369.1575371862792;
        Tue, 03 Dec 2019 03:17:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqxHsfuHbTjkQH8eviKJ48+Nlp7C/1JLX3I4FiWaDe4+xpQuoyOM0/YkQJewOzX/cskP8i9LEw==
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr4444037wrs.369.1575371862537;
        Tue, 03 Dec 2019 03:17:42 -0800 (PST)
Received: from steredhat (host28-88-dynamic.16-87-r.retail.telecomitalia.it. [87.16.88.28])
        by smtp.gmail.com with ESMTPSA id p17sm3209682wrx.20.2019.12.03.03.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 03:17:41 -0800 (PST)
Date:   Tue, 3 Dec 2019 12:17:39 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 0/3] vsock: support network namespace
Message-ID: <20191203111739.jbxptcpmvtwg7j2g@steredhat>
References: <20191128171519.203979-1-sgarzare@redhat.com>
 <20191203092649.GB153510@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <20191203092649.GB153510@stefanha-x1.localdomain>
X-MC-Unique: JAY8vFYkMiKoKaBYECl7Bg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 09:26:49AM +0000, Stefan Hajnoczi wrote:
> On Thu, Nov 28, 2019 at 06:15:16PM +0100, Stefano Garzarella wrote:
> > Hi,
> > now that we have multi-transport upstream, I started to take a look to
> > support network namespace (netns) in vsock.
> >=20
> > As we partially discussed in the multi-transport proposal [1], it could
> > be nice to support network namespace in vsock to reach the following
> > goals:
> > - isolate host applications from guest applications using the same port=
s
> >   with CID_ANY
> > - assign the same CID of VMs running in different network namespaces
> > - partition VMs between VMMs or at finer granularity
> >=20
> > This preliminary implementation provides the following behavior:
> > - packets received from the host (received by G2H transports) are
> >   assigned to the default netns (init_net)
> > - packets received from the guest (received by H2G - vhost-vsock) are
> >   assigned to the netns of the process that opens /dev/vhost-vsock
> >   (usually the VMM, qemu in my tests, opens the /dev/vhost-vsock)
> >     - for vmci I need some suggestions, because I don't know how to do
> >       and test the same in the vmci driver, for now vmci uses the
> >       init_net
> > - loopback packets are exchanged only in the same netns
> >=20
> > Questions:
> > 1. Should we make configurable the netns (now it is init_net) where
> >    packets from the host should be delivered?
>=20
> Yes, it should be possible to have multiple G2H (e.g. virtio-vsock)
> devices and to assign them to different net namespaces.  Something like
> net/core/dev.c:dev_change_net_namespace() will eventually be needed.
>=20

Make sense, but for now we support only one G2H.
How we can provide this feature to the userspace?
Should we interface vsock with ip-link(8)?

I don't know if initially we can provide through sysfs a way to set the
netns of the only G2H loaded.

> > 2. Should we provide an ioctl in vhost-vsock to configure the netns
> >    to use? (instead of using the netns of the process that opens
> >    /dev/vhost-vsock)
>=20
> Creating the vhost-vsock instance in the process' net namespace makes
> sense.  Maybe wait for a use case before adding an ioctl.
>=20

Agree.

> > 3. Should we provide a way to disable the netns support in vsock?
>=20
> The code should follow CONFIG_NET_NS semantics.  I'm not sure what they
> are exactly since struct net is always defined, regardless of whether
> network namespaces are enabled.

I think that if CONFIG_NET_NS is not defined, all sockets and processes
are assigned to init_net and this RFC should work in this case, but I'll
try this case before v1.

I was thinking about the Kata's use case, I don't know if they launch the
VM in a netns and even the runtime in the host runs inside the same netns.

I'll send an e-mail to kata mailing list.

Thanks,
Stefano

