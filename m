Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6C81823D0
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgCKVZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:25:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59531 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729488AbgCKVZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 17:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583961941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S//peyvpJxT+Gly3SxM2bdWtzhVryWYQ7YBhDC9IyzY=;
        b=aAEgF11YLBxk4JHipXmV3efwn9nJqb9JXmD85kP5qYml+jnhvyhTfwEGzqhTg6Rgy3H3ya
        QzTuy1kQ8ade16bYxi6/u+5Z3J/bFI3/K69kPrGpky6DlO41pwT80gfqSr0DwMVznmuSTf
        /J3Udv0FL05H9y1lu4TFNRNvuy1gdl0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-nqMBPO2POPCinfA5FcO02w-1; Wed, 11 Mar 2020 17:25:39 -0400
X-MC-Unique: nqMBPO2POPCinfA5FcO02w-1
Received: by mail-qv1-f69.google.com with SMTP id v2so2217378qvi.6
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 14:25:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S//peyvpJxT+Gly3SxM2bdWtzhVryWYQ7YBhDC9IyzY=;
        b=VZQIhmtCAWs5AK57+4l7mNSs5ffXgJYp24IlJrJxpV6ssN2GklpCJl8XCOvWwv6Qjf
         BuA20SnBu7OW8Bfi38cNmECD7X1rWWZaEPPjtdE/6S0PJ2eO8XG7YxBK+a/pG6i3O/wm
         E9OxuMTYtS9bhepEp3uw0Nh5JzXlo3HeNI3fNtwhVrXJ21bFRlvkMehdNUwaiUXEzGsA
         vykBLYcNU+KbpAJEg4Gli9zZjPrMr0Eg+45xfy4vMtOyLldT42erY3XBx5pPAfuhMgGe
         4bvh0SzzDA4rjxJK9/s6+nL7BRiR+XXxihgP+/C/9ceALyNgfO0UCybH3o7cID9XHCir
         GyEA==
X-Gm-Message-State: ANhLgQ0TCgf5qEIaFb8pmqQ40OLi0uFmbnFpZXi4SyBqLGnbq11KupY8
        WoKFClGXfOGmMghlIw36bue5/xe5iz2I/EmOSCrGUsZ3c5oS6rDP5n0pe3Hx8FUxsYaXPKwCxp5
        usrxSedoq0ZzYz1qn
X-Received: by 2002:ac8:76d0:: with SMTP id q16mr4543893qtr.73.1583961938949;
        Wed, 11 Mar 2020 14:25:38 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvsZRtJi28Sq4htjTMDogA/2RgA9P+DcOrCxW4zQ5xUAKZClCOwSlzWXNm2hc/7RSObLJdoGA==
X-Received: by 2002:ac8:76d0:: with SMTP id q16mr4543882qtr.73.1583961938742;
        Wed, 11 Mar 2020 14:25:38 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id w11sm22328413qti.54.2020.03.11.14.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 14:25:37 -0700 (PDT)
Date:   Wed, 11 Mar 2020 17:25:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
Message-ID: <20200311171634-mutt-send-email-mst@kernel.org>
References: <20200310085437-mutt-send-email-mst@kernel.org>
 <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
 <20200310104024-mutt-send-email-mst@kernel.org>
 <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
 <20200310172833-mutt-send-email-mst@kernel.org>
 <CA+FuTSfrjThis9UchhiKE2ibMKVgCvfTdbeB0Q33XiTDLBEX8w@mail.gmail.com>
 <20200310175627-mutt-send-email-mst@kernel.org>
 <CA+FuTSd9ywydn-EShQkhSjUMXBHFgPMipBxmwx-t8bKQb-FuDQ@mail.gmail.com>
 <20200311035238-mutt-send-email-mst@kernel.org>
 <CA+FuTSft5pSf7YJW1Ws=P7rYjWiwmZ6edYDPi7DVBafDWqcy-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSft5pSf7YJW1Ws=P7rYjWiwmZ6edYDPi7DVBafDWqcy-g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 10:31:47AM -0400, Willem de Bruijn wrote:
> I would expect packet sockets to behave the same with and without
> po->has_vnet_hdr. Without, they already pass all GSO packets up to
> userspace as is. Which is essential for debugging with tcpdump or
> wirehark. I always interpreted has_vnet_hdr as just an option to
> receive more metadata along, akin to PACKET_AUXDATA. Not something
> that subtly changes the packet flow.
>

So again just making sure:

	we are talking about a hypothetical case where we add a GSO type,
	then a hypothetical userspace that does not know about a specific GSO
	type, right?

I feel if someone writes a program with packet sockets, it is
important that it keeps working, and that means keep seeing
all packets, even if someone runs it on a new kernel
with a new optimization like gso. I feel dropping packets is
worse than changing gso type.

And that in turn means userspace must opt in to
seeing new GSO type, and old userspace must see old ones.

One way to do that would be converting packets on the socket, another
would be disabling the new GSO automatically as the socket is created
unless it opts in.

> That was my intend, but I only extended it to tpacket_rcv. Reading up
> on the original feature that was added for packet_rcv, it does mention
> "allows GSO/checksum offload to be enabled when using raw socket
> backend with virtio_net". I don't know what that raw socket back-end
> with virtio-net is. Something deprecated, but possibly still in use
> somewhere?

Pretty much. E.g. I still sometimes use it with an out of tree QEMU
patch - maybe I'll try to re-post it there just so we have an upstream
way to test the interface.

-- 
MST

