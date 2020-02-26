Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9574216F9BB
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgBZIjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:39:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37730 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727443AbgBZIjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:39:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582706381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j4ib8rLNz2Tz7MXMOeIU983Q6f8JUZBSKJwKpF7FZSI=;
        b=UIaQ4bo54h7wex9wUbIO2IoG7pc9XeFg5aooDOSWoOwdbdRRv7EMDDajWvfHiC55h1/Jjk
        0G3E3hwg79YSewl+tn0pgZrmL+5XlhP2uRiDHwBxX6kJMNTPevGYTRktzGofs2ALPYHQNW
        67A2qj892yB3Zle4I09Ou6rMlmfC1MQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-RwP3s2csOfCF6GHEufrUbw-1; Wed, 26 Feb 2020 03:39:39 -0500
X-MC-Unique: RwP3s2csOfCF6GHEufrUbw-1
Received: by mail-qv1-f71.google.com with SMTP id g9so2943934qvy.20
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:39:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j4ib8rLNz2Tz7MXMOeIU983Q6f8JUZBSKJwKpF7FZSI=;
        b=HyzfQwKlLjaMbAB/LTabFybQj4ejBbCMZSXImQcoMklAHEr7sHTDzcM6NGKtJSug5t
         CJKyTLFw7E3FOmmEJFYzBxkheqClQi+4aZueKc6wsgg5RhA27vZHFWNxyH2TRJEMjs3i
         fG38NvHJHZ8UeRV1ibP99nfX4T6C0lRRrp2POgwMaRGhJ24s42RrcbcSfpS+974Yvyt9
         vWwffThuHmvqxViqrLOkfYNfqLRi8U/QzcQ5OOdRGH3PHZPPDApPojUFVY8hocCFQgaB
         4ZxJOfLsbghAmQpmh8sKpThyzIEfjFnXZK0oDBVkpiblXNqXZRIUJDMsKnjcDkNw7hOE
         EPwg==
X-Gm-Message-State: APjAAAU2SrfjUL/4nLLTwKdU/oBnmkeOr1ShPU6bv1GOsYEyAp/UafWM
        wDao1AIHcKTT7YQf/7F0A+Q6hejSx8WPzJOTxJLM7CKMvoCxc6ivjk2dxJFY/jap6MaFwfmB6gA
        S9cwQN4e+OR0aWVQl
X-Received: by 2002:a0c:fa4b:: with SMTP id k11mr3926130qvo.55.1582706378809;
        Wed, 26 Feb 2020 00:39:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqyIY2s4RQq04c8OXA53cLP/e7G2Xm1zfOoi80CXAqXqraoLcoGGR4rm8HaM0w2wNsr/m/HVkw==
X-Received: by 2002:a0c:fa4b:: with SMTP id k11mr3926114qvo.55.1582706378563;
        Wed, 26 Feb 2020 00:39:38 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id k11sm722492qti.68.2020.02.26.00.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:39:37 -0800 (PST)
Date:   Wed, 26 Feb 2020 03:39:33 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     David Ahern <dahern@digitalocean.com>, netdev@vger.kernel.org
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200226032421-mutt-send-email-mst@kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
 <20200226015113-mutt-send-email-mst@kernel.org>
 <172688592.10687939.1582702621880.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172688592.10687939.1582702621880.JavaMail.zimbra@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 02:37:01AM -0500, Jason Wang wrote:
> 
> 
> ----- Original Message -----
> > On Tue, Feb 25, 2020 at 08:32:14PM -0700, David Ahern wrote:
> > > Another issue is that virtio_net checks the MTU when a program is
> > > installed, but does not restrict an MTU change after:
> > > 
> > > # ip li sh dev eth0
> > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
> > > state UP mode DEFAULT group default qlen 1000
> > >     link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
> > >     prog/xdp id 13 tag c5595e4590d58063 jited
> > > 
> > > # ip li set dev eth0 mtu 8192
> > > 
> > > # ip li sh dev eth0
> > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
> > > state UP mode DEFAULT group default qlen 1000
> > 
> > Well the reason XDP wants to limit MTU is this:
> >     the MTU must be less than a page
> >     size to avoid having to handle XDP across multiple pages
> > 
> 
> But even if we limit MTU is guest there's no way to limit the packet
> size on host.

Isn't this fundamental? IIUC dev->mtu is mostly a hint to devices about
how the network is configured. It has to be the same across LAN.  If
someone misconfigures it that breaks networking, and user gets to keep
both pieces. E.g. e1000 will use dev->mtu to calculate rx buffer size.
If you make it too small, well packets that are too big get dropped.
There's no magic to somehow make them smaller, or anything like that.
We can certainly drop packet > dev->mtu in the driver right now if we want to,
and maybe if it somehow becomes important for performance, we
could teach host to drop such packets for us. Though
I don't really see why we care ...

> It looks to me we need to introduce new commands to
> change the backend MTU (e.g TAP) accordingly.
> 
> Thanks

So you are saying there are configurations where host does not know the
correct MTU, and needs guest's help to figure it out? I guess it's
possible but it seems beside the point raised here.  TAP in particular
mostly just seems to ignore MTU, I am not sure why we should bother
propagating it there from guest or host. Propagating it from guest to
the actual NIC might be useful e.g. for buffer sizing, but is tricky
to do safely in case the NIC is shared between VMs.

-- 
MST

