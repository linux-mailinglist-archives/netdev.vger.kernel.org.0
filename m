Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B38616FAD3
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgBZJgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:36:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27538 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727339AbgBZJgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:36:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582709775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1cPkI6KnngicmG1b55Lq+7GrehJNy/FxpxJUSbZpoBo=;
        b=fEh1JUtNxv0AoFhF65yDUcKj8CKJtwH1z32rg3pG0tNFZKsj1H98aRplZORVL83HwWjNfI
        19zS3X/qObgLHsRCEA2QlbLGpuYTSsBf1X16G/tj57x9I+duCQhovgBl6wGbUzHw6dY+pF
        VJlaFFJKCQT+7sa7tJkqYgy2O7jRdz8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-7KOasp8qOfWZA5Qc3wOO_A-1; Wed, 26 Feb 2020 04:36:14 -0500
X-MC-Unique: 7KOasp8qOfWZA5Qc3wOO_A-1
Received: by mail-qk1-f197.google.com with SMTP id n130so3337395qke.19
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 01:36:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1cPkI6KnngicmG1b55Lq+7GrehJNy/FxpxJUSbZpoBo=;
        b=uh3D/m9WY45TWYEFbUS8afv9+Xl4MV1nbQVjAsLqj+G1dSDeddQtsg8DiZyIhQKFE6
         8+pow3TDmiaoqvHur9D1e/aocNfqvAtDG7SeiZYWx8ZQL6yq8KAU1sCFiptyZR3eBxei
         2alfNEmHQrr8IcGGj8cTVWyup3M7xddjTu5G3Nuaa5XYV/tkS/SVFJF9agsx/90p6LR9
         3J69eS42mlx0/Ib2dKGLeAmUsXUKUaME+xZbHX3fEaDoCB7D5sSEpvgYYslZeaxw5VSf
         mAeeIQqSn1Jr2MuT2Gbvs7/g+bw417bU1sbkQoHgfEOD3AuAXevJ3ZpSmuSbuK1yxNUa
         bZ6Q==
X-Gm-Message-State: APjAAAXSQAqb1yFDIYLh/XCUNk3qDr33UZFjsVMVjftZIF/1FmYIuvWX
        60NNK58gyNqqDKdfGndC09zkFqVkOhvCjpeZH2Mmj3weSQMPOzix9PQUOlbvrIHDfJi7lYMX4pd
        sZtiFcouYcjBOdp6M
X-Received: by 2002:a37:644f:: with SMTP id y76mr4488925qkb.488.1582709774107;
        Wed, 26 Feb 2020 01:36:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqxUwwE45My/XwdX7hIoU3COFqj3In3rAhxaDziwMpei5CfEgfyyXFFAIMAwJ2PFDdEJcc5fwg==
X-Received: by 2002:a37:644f:: with SMTP id y76mr4488898qkb.488.1582709773895;
        Wed, 26 Feb 2020 01:36:13 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id f59sm779223qtb.75.2020.02.26.01.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 01:36:12 -0800 (PST)
Date:   Wed, 26 Feb 2020 04:36:08 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     David Ahern <dahern@digitalocean.com>, netdev@vger.kernel.org
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200226043343-mutt-send-email-mst@kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
 <20200226015113-mutt-send-email-mst@kernel.org>
 <172688592.10687939.1582702621880.JavaMail.zimbra@redhat.com>
 <20200226032421-mutt-send-email-mst@kernel.org>
 <b8dcde8c-ce7b-588a-49c1-0cf315794613@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8dcde8c-ce7b-588a-49c1-0cf315794613@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 05:30:18PM +0800, Jason Wang wrote:
> 
> On 2020/2/26 下午4:39, Michael S. Tsirkin wrote:
> > On Wed, Feb 26, 2020 at 02:37:01AM -0500, Jason Wang wrote:
> > > 
> > > ----- Original Message -----
> > > > On Tue, Feb 25, 2020 at 08:32:14PM -0700, David Ahern wrote:
> > > > > Another issue is that virtio_net checks the MTU when a program is
> > > > > installed, but does not restrict an MTU change after:
> > > > > 
> > > > > # ip li sh dev eth0
> > > > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
> > > > > state UP mode DEFAULT group default qlen 1000
> > > > >      link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
> > > > >      prog/xdp id 13 tag c5595e4590d58063 jited
> > > > > 
> > > > > # ip li set dev eth0 mtu 8192
> > > > > 
> > > > > # ip li sh dev eth0
> > > > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
> > > > > state UP mode DEFAULT group default qlen 1000
> > > > Well the reason XDP wants to limit MTU is this:
> > > >      the MTU must be less than a page
> > > >      size to avoid having to handle XDP across multiple pages
> > > > 
> > > But even if we limit MTU is guest there's no way to limit the packet
> > > size on host.
> > Isn't this fundamental? IIUC dev->mtu is mostly a hint to devices about
> > how the network is configured. It has to be the same across LAN.  If
> > someone misconfigures it that breaks networking, and user gets to keep
> > both pieces. E.g. e1000 will use dev->mtu to calculate rx buffer size.
> > If you make it too small, well packets that are too big get dropped.
> > There's no magic to somehow make them smaller, or anything like that.
> > We can certainly drop packet > dev->mtu in the driver right now if we want to,
> > and maybe if it somehow becomes important for performance, we
> > could teach host to drop such packets for us. Though
> > I don't really see why we care ...
> > 
> > > It looks to me we need to introduce new commands to
> > > change the backend MTU (e.g TAP) accordingly.
> > > 
> > > Thanks
> > So you are saying there are configurations where host does not know the
> > correct MTU, and needs guest's help to figure it out?
> 
> 
> Yes.
> 
> 
> > I guess it's
> > possible but it seems beside the point raised here.  TAP in particular
> > mostly just seems to ignore MTU, I am not sure why we should bother
> > propagating it there from guest or host. Propagating it from guest to
> > the actual NIC might be useful e.g. for buffer sizing, but is tricky
> > to do safely in case the NIC is shared between VMs.
> 
> 
> Macvlan passthrough mode could be easier I guess.
> 
> Thanks

As usual :) So sure, it's doable for simple configs.
But this seems orthogoal to the question raised in this thread.

-- 
MST

