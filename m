Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C693EABEC
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfJaIyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:54:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbfJaIyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 04:54:47 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E3B75C05A1BE
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:54:46 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id e3so476825wrs.17
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 01:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wIxff/xeNXe1wb8LPDwW/yTYgkSfAil2vq+uYePEE2c=;
        b=llhQuvwHG23FdHU/6xX9tv2n0gaAbfu5O5KrqOHOc4S4zPeNctEoazeKZaA6TYfGye
         1JLUks/E8eyGB1OkqmXtCCIoQyPtCalS6ZnaAxHvgHqz/R8ER99Z8RORbb2cEkCNkd1O
         mWEPLmB0ACpbKt45tEz/0+Ei1q0wgnUQ02Ezq0LHtZZHpRVofLrCOR5640uCayc494aM
         Dz3+TaoJQIhGk3+Z9BLGLhJtzOt8/5YW48CzG3h4pLTR2BgMLxR69zLD9b0Ti6LqqRTo
         AkjU+5VzilazkGIRzIRAHUX+eCx7zSnGyWEUrOtRHvo6kezNEuD3Rgb+q0lFjuaCxNjC
         9i6A==
X-Gm-Message-State: APjAAAVUe5qe4TXjlUTdOp1IqtAl1+0IUTNFqvUAZDNq496k44bwysj5
        fUA0Kb2sBHX5toOXyU21kzYC/BcaeI7w7OHdGqBIz57S0AaMcB4ztl523tEMsVn1fm/z8ztwv24
        keDWzGNXlsJJMpti/
X-Received: by 2002:a05:600c:2248:: with SMTP id a8mr3992688wmm.176.1572512085582;
        Thu, 31 Oct 2019 01:54:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwljnfXIFUbhpOVjeOyn7RSMG1RK8ExAwGTNSA6Ok15JomaTkrWe27dOdJI/ge/KJL7MFrKYQ==
X-Received: by 2002:a05:600c:2248:: with SMTP id a8mr3992677wmm.176.1572512085348;
        Thu, 31 Oct 2019 01:54:45 -0700 (PDT)
Received: from steredhat ([91.217.168.176])
        by smtp.gmail.com with ESMTPSA id l8sm3361933wru.22.2019.10.31.01.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 01:54:44 -0700 (PDT)
Date:   Thu, 31 Oct 2019 09:54:42 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, kvm <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dexuan Cui <decui@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 11/14] vsock: add multi-transports support
Message-ID: <20191031085442.vkb5tnchfsa6n4dh@steredhat>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-12-sgarzare@redhat.com>
 <CAGxU2F7n48kBy_y2GB=mcvraK=mw_2Jn8=2hvQnEOWqWuT9OjA@mail.gmail.com>
 <MWHPR05MB3376E623764F54D39D8135A9DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR05MB3376E623764F54D39D8135A9DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:40:05PM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > > +/* Assign a transport to a socket and call the .init transport callback.
> > > + *
> > > + * Note: for stream socket this must be called when vsk->remote_addr
> > > +is set
> > > + * (e.g. during the connect() or when a connection request on a
> > > +listener
> > > + * socket is received).
> > > + * The vsk->remote_addr is used to decide which transport to use:
> > > + *  - remote CID > VMADDR_CID_HOST will use host->guest transport
> > > + *  - remote CID <= VMADDR_CID_HOST will use guest->host transport
> > > +*/ int vsock_assign_transport(struct vsock_sock *vsk, struct
> > > +vsock_sock *psk) {
> > > +       const struct vsock_transport *new_transport;
> > > +       struct sock *sk = sk_vsock(vsk);
> > > +
> > > +       switch (sk->sk_type) {
> > > +       case SOCK_DGRAM:
> > > +               new_transport = transport_dgram;
> > > +               break;
> > > +       case SOCK_STREAM:
> > > +               if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
> > > +                       new_transport = transport_h2g;
> > > +               else
> > > +                       new_transport = transport_g2h;
> > 
> > I just noticed that this break the loopback in the guest.
> > As a fix, we should use 'transport_g2h' when remote_cid <=
> > VMADDR_CID_HOST or remote_cid is the id of 'transport_g2h'.
> > 
> > To do that we also need to avoid that L2 guests can have the same CID of L1.
> > For vhost_vsock I can call vsock_find_cid() in vhost_vsock_set_cid()
> > 
> > @Jorgen: for vmci we need to do the same? or it is guaranteed, since it's
> > already support nested VMs, that a L2 guests cannot have the same CID as
> > the L1.
> 
> As far as I can tell, we have the same issue with the current support for nested VMs in
> VMCI. If we have an L2 guest with the same CID as the L1 guest, we will always send to
> the L2 guest, and we may assign an L2 guest the same CID as L1. It should be straight
> forward to avoid this, though.
> 

Yes, I think so.

For the v2 I'm exposing the vsock_find_cid() to the transports, in this
way I can reject requests to set the same L1 CID for L2 guests.

Thanks,
Stefano
