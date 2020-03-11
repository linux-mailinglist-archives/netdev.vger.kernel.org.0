Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 009BF18243D
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgCKVue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:50:34 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:40589 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbgCKVue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 17:50:34 -0400
Received: by mail-yw1-f67.google.com with SMTP id c15so3568509ywn.7
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 14:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtV4sBlcaucQjbKKFp+772A6QsH5ptpz612QCw4dSQM=;
        b=kId2cHXoS7m9bZ7LfK15xb/4Wy5fuGVyysuA3ryyrp51NwJ+btCnpVdyr4+IG9ZrNe
         1Dk7zdoDw9bwFq33J14XtafxYKmoP/RDdd9l4WUkmBUMWvSFLHNSUWil/1Cv82XQuAKT
         n84qb1AnRMC+yMvDMm0IgpesLuqBxTLJjQO2KqZOsKGncJT0/3HlBFkNYcfP6UnTwumU
         8G8nVNXHc3Isi3J0BgnTLysJfwqM32FSofs0ZPUgbg09MCcJh/tKef8pzaAjW5n+kL1K
         QWMgxl8/kUGKtA1C73g5y8WKjDRswXm682J2E0FZXXASJKctnC9rU4rarSbVEUl3Ifa8
         +Cwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtV4sBlcaucQjbKKFp+772A6QsH5ptpz612QCw4dSQM=;
        b=gQBdC99YvtaGH/mI8SoquyHGnc8zDrxl/AB6bhu8noHwWMZAPBoJQ7pn8x2xe7yv8B
         ty5tnAY9XlZuVGsltVCD5RJzqjG5i595za2wNu3kSWac0aN902OKc24K1kLieQrHGX/O
         gqID7/lfsYBjin9WdG2SNxAOpsEgHqg3w2WuG2Y1xWw0h0x+S9C8kzsL9JcqDAiRiVKv
         S+AFhpolDzSYbuJYt35Paiq+538S6qTX+lcCt0Q58mi3Dl/oBTNidq6O4ly+jML6fyrA
         eKjlSGW55VKRojc2pu/EeUagOQRAQTTmd7qVj8dGvO/IkuRJEfowtVRBpricpazgRn5x
         gIkQ==
X-Gm-Message-State: ANhLgQ0z5N9OsAFetcg4UPhXPYByvUsa3x8FyqQow1+TaYHwpdaT/0Jn
        dZGEkRvqcppPA7UoPpEAMwDVM2fL
X-Google-Smtp-Source: ADFU+vtJFyCpM3y89qxsu0vLToMu1VHDU+yBybgRtZsTVJlBW9B1RmpPTOAFYkxOqsRGyXx2cJ3cjA==
X-Received: by 2002:a0d:e8d5:: with SMTP id r204mr5257050ywe.386.1583963431290;
        Wed, 11 Mar 2020 14:50:31 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id g192sm22012198ywe.99.2020.03.11.14.50.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 14:50:30 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id p124so3562445ywc.8
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 14:50:30 -0700 (PDT)
X-Received: by 2002:a81:32ca:: with SMTP id y193mr5435193ywy.347.1583963429579;
 Wed, 11 Mar 2020 14:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200310085437-mutt-send-email-mst@kernel.org>
 <CA+FuTSe+mxUwHMTccO7QO+GVi1TUgxbwZoAktGTD+15yMZf5Vw@mail.gmail.com>
 <20200310104024-mutt-send-email-mst@kernel.org> <CA+FuTSeZFTUShADA0STcHjSt88JsSGWQ0nnc5Sr-oQAvRH+-3A@mail.gmail.com>
 <20200310172833-mutt-send-email-mst@kernel.org> <CA+FuTSfrjThis9UchhiKE2ibMKVgCvfTdbeB0Q33XiTDLBEX8w@mail.gmail.com>
 <20200310175627-mutt-send-email-mst@kernel.org> <CA+FuTSd9ywydn-EShQkhSjUMXBHFgPMipBxmwx-t8bKQb-FuDQ@mail.gmail.com>
 <20200311035238-mutt-send-email-mst@kernel.org> <CA+FuTSft5pSf7YJW1Ws=P7rYjWiwmZ6edYDPi7DVBafDWqcy-g@mail.gmail.com>
 <20200311171634-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200311171634-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 11 Mar 2020 17:49:52 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeMRBG4GyQFjtk3+SuxZX+aPGUezuhwk7yumFq1CHyu5A@mail.gmail.com>
Message-ID: <CA+FuTSeMRBG4GyQFjtk3+SuxZX+aPGUezuhwk7yumFq1CHyu5A@mail.gmail.com>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 5:25 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Mar 11, 2020 at 10:31:47AM -0400, Willem de Bruijn wrote:
> > I would expect packet sockets to behave the same with and without
> > po->has_vnet_hdr. Without, they already pass all GSO packets up to
> > userspace as is. Which is essential for debugging with tcpdump or
> > wirehark. I always interpreted has_vnet_hdr as just an option to
> > receive more metadata along, akin to PACKET_AUXDATA. Not something
> > that subtly changes the packet flow.
> >
>
> So again just making sure:
>
>         we are talking about a hypothetical case where we add a GSO type,
>         then a hypothetical userspace that does not know about a specific GSO
>         type, right?

I suppose we're talking about two cases:

- what to do about the two gso types that have already been added, and
are now dropped
- what to do about future gso types.

As for userspace, yeah, I don't know of any pf_packet programs that
are not robust against unknown gso_type. But you may know better on
this front :)

> I feel if someone writes a program with packet sockets, it is
> important that it keeps working, and that means keep seeing
> all packets,

Agreed

> even if someone runs it on a new kernel
> with a new optimization like gso. I feel dropping packets is
> worse than changing gso type.

Agreed

> And that in turn means userspace must opt in to
> seeing new GSO type, and old userspace must see old ones.

This is where I'm inclined to disagree. But that does depend on
whether the fragile legacy applications are hypothetical or not.

> One way to do that would be converting packets on the socket,

Then packet sockets are really showing something else than what they're reading.

It may be a necessary evil for legacy applications, but I really don't
like either the basic idea or that it differs from packet sockets
without po->has_vnet_hdr.

> another
> would be disabling the new GSO automatically as the socket is created
> unless it opts in.

Unfortunately that's not possible for packet sockets that are not
bound to a specific device.

> > That was my intend, but I only extended it to tpacket_rcv. Reading up
> > on the original feature that was added for packet_rcv, it does mention
> > "allows GSO/checksum offload to be enabled when using raw socket
> > backend with virtio_net". I don't know what that raw socket back-end
> > with virtio-net is. Something deprecated, but possibly still in use
> > somewhere?
>
> Pretty much. E.g. I still sometimes use it with an out of tree QEMU
> patch - maybe I'll try to re-post it there just so we have an upstream
> way to test the interface.

If you have a pointer, that would help me understand this case, thanks.

Segmentation on-demand, if we have to do that similar to the previous
checksum fix up (thought that was opt-in, not set as default, btw),
will not be entirely trivial code-wise, but doable.

As for handling a full socket partially through a segment list, I
guess that is no different from drops any other time, so that at least
will not be a problem.
